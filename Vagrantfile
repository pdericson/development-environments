Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
  end
  # Ubuntu Xenial
  config.vm.define "ubuntu-xenial", autostart: false do |machine|
    machine.vm.box = "ubuntu/xenial64"
    machine.vm.hostname = "ubuntu-xenial"
    machine.vm.provision "shell", inline: <<-SHELL
      set -e
      if [ ! -x /usr/bin/python ]; then
          apt-get update
          apt-get install -y python
      fi
    SHELL
    machine.vm.provision "ansible" do |ansible|
      ansible.playbook = "site.yml"
    end
    machine.vm.network "private_network", ip: "192.168.50.101"
  end
  # CentOS 7
  config.vm.define "centos-7", autostart: false do |machine|
    machine.vm.box = "centos/7"
    machine.vm.hostname = "centos-7"
    machine.vm.provision "ansible" do |ansible|
      ansible.playbook = "site.yml"
    end
  end
  # OpenBSD 6.0
  config.vm.define "openbsd-6-0", autostart: false do |machine|
    machine.vm.box = "trombik/ansible-openbsd-6.0-amd64"
    machine.vm.hostname = "openbsd-6-0"
    machine.vm.provision "shell", inline: <<-SHELL
      ln -s /usr/local/bin/python2.7 /usr/bin/python
    SHELL
    machine.vm.provision "ansible" do |ansible|
      ansible.playbook = "site.yml"
    end
  end
  # Debian 8
  config.vm.define "debian-jessie", autostart: false do |machine|
    machine.vm.box = "debian/jessie64"
    machine.vm.hostname = "debian-jessie"
    machine.vm.provision "ansible" do |ansible|
      ansible.playbook = "site.yml"
    end
  end
  # Debian 9
  (1..3).each do |i|
    config.vm.define "debian-stretch-#{i}", autostart: false do |machine|
      machine.vm.box = "debian/stretch64"
      machine.vm.hostname = "debian-stretch-#{i}"
      machine.vm.provider :libvirt do |domain|
        domain.cpus = 2
        domain.memory = 2048
      end
      machine.vm.provision "ansible" do |ansible|
        ansible.playbook = "site.yml"
      end
      machine.vm.synced_folder './', '/vagrant', type: 'rsync'
    end
  end
end
