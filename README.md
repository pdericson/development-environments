# development-environments

development environments

```
vagrant up ubuntu-xenial
vagrant up centos-7
vagrant up openbsd-6-0
vagrant up debian-jessie
vagrant up debian-stretch-1
vagrant up debian-stretch-2
vagrant up debian-stretch-3
vagrant up debian-buster-1
vagrant up debian-buster-2
vagrant up debian-buster-3
```

```
vagrant ssh ubuntu-xenial
vagrant ssh centos-7
vagrant ssh openbsd-6-0
vagrant ssh debian-jessie
vagrant ssh debian-stretch-1
vagrant ssh debian-stretch-2
vagrant ssh debian-stretch-3
vagrant ssh debian-buster-1
vagrant ssh debian-buster-2
vagrant ssh debian-buster-3
```

```
ansible-playbook site.yml
```

```
vagrant destroy -f
```

## PostgreSQL

```
ansible-playbook -b postgresql.yml
```

```
rake spec
```

Riemann:

```
rake spec SPEC_OPTS="--require ./riemann_formatter.rb --format RiemannFormatter"
```

Update Vagrant boxes:

```
vagrant box update
```

## K3s

```
ansible-playbook -b k3s.yml
```

Install kubectl:

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl
```

Install helm:

```
curl -sfL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sudo bash -
```

## libvirt

<https://github.com/vagrant-libvirt/vagrant-libvirt#installation>

```
vagrant plugin install vagrant-libvirt
```

```
export VAGRANT_DEFAULT_PROVIDER=libvirt
```
