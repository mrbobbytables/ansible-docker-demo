require '/tmp/kitchen/spec/spec_helper.rb'

  describe package('docker-engine') do
    it { should be_installed }
  end

  describe service('docker') do
    it { should be_enabled }
    it {should be_running }
  end
