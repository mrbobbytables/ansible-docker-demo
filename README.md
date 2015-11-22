Installs and verifies docker on the following platforms:
* Ubuntu (14.04+)
* CentOS (7+)

1. Download and install vagrant: https://www.vagrantup.com/downloads.html
2. Install RVM - https://rvm.io/rvm/install
```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source $HOME/.rvm/scripts/rvm
```
3. install bundler:
   `gem install bundler`
4. install test-kitchen / ansible dependencies
   `bundle install`
5. Due to an intermittent issue with test-kitchen / vagrant I suggest getting the boxes you wish to test manually before running a converge:
  * `vagrant box add --provider virtualbox ubuntu/trusty64`
  * `vagrant box add --provider virtualbox ubuntu/vivid64`
  * `vagrant box add --provider virtualbox centos/7`
6. run a converge on all version
   `kitchen converge -c=3`
7. run verification on all versions
   `kitchen verify -c=3`
8. See that all iterations are verified with:
   `kitchen list`

The serverspec file is located in `/roles/docker/spec/docker_spec.rb` and verifies the following things:
* Docker is installed.
* The docker service is enabled.
* The docker service is running.
* If a version is specified; it is running that version.
* If docker_opts are specified; it verifies the docker daemon is running with those options.

#### docker_spec.rb
```ruby
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
```
