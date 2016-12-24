Vagrant.configure("2") do |config|
  # Ubuntu 16.04
  config.vm.define "ubuntu-1604", autostart: false do |host|
    host.vm.box = "ubuntu/xenial64"
    host.vm.provision "shell", inline: <<-SHELL
      set -e
      if [ ! -x /usr/bin/python ]; then
          apt-get update
          apt-get install -y python
      fi
    SHELL
    host.vm.provision "ansible" do |ansible|
      ansible.playbook = "site.yml"
    end
  end
  # CentOS 7
  config.vm.define "centos-7", autostart: false do |host|
    host.vm.box = "centos/7"
    host.vm.provision "ansible" do |ansible|
      ansible.playbook = "site.yml"
    end
  end
  # OpenBSD 6.0
  config.vm.define "openbsd-60", autostart: false do |host|
    host.vm.box = "trombik/ansible-openbsd-6.0-amd64"
    host.vm.provision "shell", inline: <<-SHELL
      ln -s /usr/local/bin/python2.7 /usr/bin/python
    SHELL
    host.vm.provision "ansible" do |ansible|
      ansible.playbook = "site.yml"
    end
  end
end
