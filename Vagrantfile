# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # For a complete reference, please see the online documentation at https://docs.vagrantup.com.

  config.vm.box = "archlinux/archlinux"

  config.vm.network "forwarded_port", guest: 22, host: 2223

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Throw-Awarch"
  end

  config.vm.provision "shell", path: "bootstrap.sh"
end
