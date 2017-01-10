# development-environments

development environments

```
vagrant up ubuntu-xenial
vagrant up centos-7
vagrant up openbsd-6-0
vagrant up debian-jessie
```

```
vagrant ssh ubuntu-xenial
vagrant ssh centos-7
vagrant ssh openbsd-6-0
vagrant ssh debian-jessie
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
