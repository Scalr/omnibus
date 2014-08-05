module Omnibus
  describe Packager::DSL do
    let(:project) do
      double(Project,
        install_dir: '/opt/hamlet',
        friendly_name: 'HAMLET',
        maintainer: 'maintainer'
      )
    end

    subject(:instance) do
      Class.new { include Packager::DSL }.new(project) do

      end
    end

    it_behaves_like 'a cleanroom getter', :install_dir
    it_behaves_like 'a cleanroom getter', :friendly_name
    it_behaves_like 'a cleanroom getter', :maintainer
  end
end
