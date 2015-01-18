# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define 'gk-node-1' do |node|
    node.vm.box = "ubuntu/trusty64"
    node.vm.hostname = 'node1.gerald.local'
    node.vm.network "public_network"

    node.vm.provision "shell", path: "bootstrap.sh"
    node.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "site.pp"
      puppet.module_path = "modules"
    end
  end
end
