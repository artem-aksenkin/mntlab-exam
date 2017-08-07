# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "sbeliakou/centos-7.3-x86_64-minimal"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "private_network", ip: "192.168.56.14"
  config.vm.hostname = "pet"
  
  config.vm.provider "virtualbox" do |vb|
    vb = config.vm.hostname
    vb.memory = "2048"
  end
end
