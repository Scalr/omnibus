#
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Omnibus
  #
  # Builds a Windows MSI package (.msi extension)
  #
  class Packager::MSI < Packager::Base
    class DSL
      include Packager::DSL
      attr_reader :msi_parameters
      attr_reader :wix_candle_extensions
      attr_reader :wix_light_extensions

      def initialize(project)
        @msi_parameters = {}
        @wix_light_extensions = ['WixUIExtension'] # included for backcompat
        @wix_candle_extensions = []
        super(project)
      end

      def msi_parameters(val=NULL, &block)
        if block && !null?(val)
          raise Error, 'You cannot specify additional parameters to ' \
            '#msi_parameters when a block is given'
        end

        if block
          @msi_parameters = self.class.evaluate(self, &block)
        else
          if null?(val)
            @project.msi_parameters.merge @msi_parameters
          else
            @msi_parameters = val
          end
        end
      end
      expose :msi_parameters

      def wix_candle_extension(ext)
        @wix_candle_extensions << ext
      end
      expose :wix_candle_extension

      def wix_light_extention(ext)
        @wix_light_extentions << ext
      end
      expose :wix_light_extention
    end

    # !@method msi_parameters
    #   @return (see Project#msi_parameters)
    def_delegator :config, :msi_parameters, :msi_parameters

    def config
      @config ||= @project.packager(:msi)
    end

    validate do
      assert_presence!(resource('localization-en-us.wxl'))
      assert_presence!(resource('parameters.wxi'))
      assert_presence!(resource('source.wxs'))
    end

    setup do
      purge_directory(staging_dir)
      purge_directory(Config.package_dir)
      purge_directory(staging_resources_path)
      copy_directory(resources_path, staging_resources_path)

      # Set the MSI version before rendering MSI source files
      set_msi_version_from_project

      ['localization-en-us.wxl.erb', 'parameters.wxi.erb', 'source.wxs.erb'].each do |res|
        res_path = resource(res)
        render_template(res_path) if File.exist?(res_path)
      end
    end

    build do
      # harvest the files with heat.exe
      # recursively generate fragment for project directory
      execute [
        "heat.exe dir \"#{project.install_dir}\"",
        '-nologo -srd -gg -cg ProjectDir',
        '-dr PROJECTLOCATION -var var.ProjectSourceDir',
        '-out project-files.wxs',
      ].join(' ')

      # compile with candle.exe
      execute [
        'candle.exe -nologo',
        config.wix_candle_extensions.map {|e| "-ext '#{e}'"}.join(' '),
        "-dProjectSourceDir=\"#{project.install_dir}\" project-files.wxs",
        "\"#{resource('source.wxs')}\"",
      ].join(' ')

      # create the msi
      # Don't care about the 204 return code from light.exe since it's
      # about some expected warnings...
      execute [
        'light.exe -nologo',
        config.wix_light_extensions.map {|e| "-ext '#{e}'"}.join(' '),
        '-cultures:en-us',
        "-loc #{resource('localization-en-us.wxl')}",
        'project-files.wixobj source.wixobj',
        "-out \"#{final_pkg}\"",
      ].join(' '), returns: [0, 204]
    end

    clean do
    end

    # @see Base#package_name
    def package_name
      "#{project.name}-#{project.build_version}-#{project.iteration}.msi"
    end

    # The full path where the product package was/will be written.
    #
    # @return [String] Path to the packge file.
    def final_pkg
      File.expand_path("#{Config.package_dir}/#{package_name}")
    end

    # Helper method to set the msi version for a given project
    def set_msi_version_from_project
      # build_version looks something like this:
      # dev builds => 11.14.0-alpha.1+20140501194641.git.94.561b564
      #            => 0.0.0+20140506165802.1
      # rel builds => 11.14.0.alpha.1 || 11.14.0
      #
      # MSI version spec expects a version that looks like X.Y.Z.W where
      # X, Y, Z & W are 32 bit integers.
      #
      # MSI source files expect two versions to be set in the msi_parameters:
      # msi_version & msi_display_version

      versions = project.build_version.split(/[.+-]/)
      @msi_version = "#{versions[0]}.#{versions[1]}.#{versions[2]}.#{project.build_iteration}"
      @msi_display_version = "#{versions[0]}.#{versions[1]}.#{versions[2]}"
    end
  end
end
