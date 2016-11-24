# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'ipaddr'

vagrant_config = YAML.load_file("provisioning/virtualbox.conf.yml")

Vagrant.configure(2) do |config|
  config.vm.box = vagrant_config['box']

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
  end
  config.vm.synced_folder File.expand_path("/opt/stack/share"), "/opt/stack/share"

  # Build the common args for the setup-base.sh scripts.
  setup_base_common_args = "#{vagrant_config['master_node']['ip']} #{vagrant_config['master_node']['short_name']} " +
                           # "#{vagrant_config['compute1']['ip']} #{vagrant_config['compute1']['short_name']} " +
                           "#{vagrant_config['slave1']['ip']} #{vagrant_config['slave1']['short_name']}"

  # Bring up the Devstack master_node node on Virtualbox
  config.vm.define "master_node", primary: true do |master_node|
    master_node.vm.host_name = vagrant_config['master_node']['host_name']
    master_node.vm.network "forwarded_port", guest: 22, host: 2223, protocol: "tcp"
    master_node.vm.network "private_network", ip: vagrant_config['master_node']['ip']
    master_node.vm.provision "shell", path: "provisioning/setup-base.sh", privileged: false,
      :args => "#{vagrant_config['master_node']['mtu']} #{setup_base_common_args}"
    master_node.vm.provision "shell", path: "provisioning/setup-master_node.sh", privileged: false,
      :args => ""
    master_node.vm.provider "virtualbox" do |vb|
       vb.memory = vagrant_config['master_node']['memory']
       vb.cpus = vagrant_config['master_node']['cpus']
       vb.customize [
           "guestproperty", "set", :id,
           "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000
          ]
    end
  end

#bring up the slave node
  config.vm.define "slave1" do |slave1|
    slave1.vm.host_name = vagrant_config['slave1']['host_name']
    slave1.vm.network "private_network", ip: vagrant_config['slave1']['ip']
    slave1.vm.provision "shell", path: "provisioning/setup-base.sh", privileged: false,
      :args => "#{vagrant_config['slave1']['mtu']} #{setup_base_common_args}"
    slave1.vm.provision "shell", path: "provisioning/setup-slave.sh", privileged: false,
      :args => "#{vagrant_config['master_node']['ip']} "
    slave1.vm.provider "virtualbox" do |vb|
       vb.memory = vagrant_config['slave1']['memory']
       vb.cpus = vagrant_config['slave1']['cpus']
       vb.customize [
           "guestproperty", "set", :id,
           "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000
          ]
    end
  end


#bring up the explorer node
  config.vm.define "explorer" do |multichain_explorer|
    multichain_explorer.vm.host_name = vagrant_config['multichain_explorer']['host_name']
    multichain_explorer.vm.network "private_network", ip: vagrant_config['multichain_explorer']['ip']
    multichain_explorer.vm.provision "shell", path: "provisioning/setup-base.sh", privileged: false,
      :args => "#{vagrant_config['multichain_explorer']['mtu']} #{setup_base_common_args}"
    multichain_explorer.vm.provision "shell", path: "provisioning/setup-explorer.sh", privileged: false,
      :args => "#{vagrant_config['master_node']['ip']} "
    multichain_explorer.vm.provider "virtualbox" do |vb|
       vb.memory = vagrant_config['multichain_explorer']['memory']
       vb.cpus = vagrant_config['multichain_explorer']['cpus']
       vb.customize [
           "guestproperty", "set", :id,
           "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000
          ]
    end
  end

end
