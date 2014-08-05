module Omnibus
  module Packager::DSL
    def self.included(base)
      base.send(:include, Cleanroom)
      base.send(:include, NullArgumentable)
      base.send(:include, Sugarable)
      base.send(:include, Util)
      base.send(:expose, :install_dir)
      base.send(:expose, :friendly_name)
      base.send(:expose, :maintainer)
    end

    def initialize(project, &block)
      @project = project
      @block = block
      @evaluted = false
    end

    def install_dir
      @project.install_dir
    end

    def friendly_name
      @project.friendly_name
    end

    def maintainer
      @project.maintainer
    end

    def run!
      if !@evaluated
        evaluate(&@block)
        @evaluated = true
      end
      self
    end
  end
end
