require_relative '/tmp/kitchen/spec/spec_helper.rb'
require 'yaml'

  describe package('docker-engine') do
    it { should be_installed }
  end

  describe service('docker') do
    it { should be_enabled }
    it {should be_running }
  end

  if File.exists? ('/tmp/kitchen/roles/docker/vars/main.yml')

    docker_vars = YAML.load_file('/tmp/kitchen/roles/docker/vars/main.yml')
    if ! docker_vars.nil?

      if ! docker_vars['docker_version'].nil?
        describe command('docker --version') do
          its(:stdout) { should match docker_vars['docker_version'] }
        end
      end

      if ! docker_vars['docker_opts'].nil?
        describe command('ps -aux | grep docker') do
          its(:stdout) { should match docker_vars['docker_opts'] }
        end
      end
    end
  end
