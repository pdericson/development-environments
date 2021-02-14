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

libvirt: Use the ip address of the virtual machine instead of 127.0.0.1:

```
ip_address=`vagrant ssh-config debian-buster-1 | grep HostName | awk '{print $NF}'`
echo $ip_address
sed -i "s/127.0.0.1:6443/$ip_address:6443/" ~/.kube/config
chmod 600 ~/.kube/config
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

## jenkins

```
helm repo add jenkins https://charts.jenkins.io
helm repo update
```

```
helm show values jenkins/jenkins > values.yaml
```

```
cp values.yaml values.yaml.orig
```

```
diff -u values.yaml.orig values.yaml
```

```
--- values.yaml.orig	2021-02-14 12:32:13.596789747 +1300
+++ values.yaml	2021-02-14 23:26:08.386769999 +1300
@@ -327,7 +327,7 @@
   statefulSetAnnotations: {}

   ingress:
-    enabled: false
+    enabled: true
     # Override for the default paths that map requests to the backend
     paths: []
     # - backend:
@@ -569,7 +569,7 @@
   # jenkins-agent: v1

   # Executed command when side container gets started
-  command:
+  command: jenkins-agent
   args: "${computer.jnlpmac} ${computer.name}"
   # Side container name
   sideContainerName: "jnlp"
@@ -581,7 +581,7 @@
   podName: "default"
   # Allows the Pod to remain active for reuse until the configured number of
   # minutes has passed since the last step was executed on it.
-  idleMinutes: 0
+  idleMinutes: 10
   # Raw yaml template for the Pod. For example this allows usage of toleration for agent pods.
   # https://github.com/jenkinsci/kubernetes-plugin#using-yaml-to-define-pod-templates
   # https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
@@ -650,7 +650,7 @@
   ## A manually managed Persistent Volume and Claim
   ## Requires persistence.enabled: true
   ## If defined, PVC must be created manually before volume will be bound
-  existingClaim:
+  existingClaim: jenkins
   ## jenkins data Persistent Volume Storage Class
   ## If defined, storageClassName: <storageClass>
   ## If set to "-", storageClassName: "", which disables dynamic provisioning
@@ -770,4 +770,3 @@
   #  drop:
   #    - NET_RAW
 checkDeprecation: true
-
```

```
kubectl create namespace jenkins
```

```
kubectl -n jenkins apply -f - <<EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
 name: jenkins
spec:
 # storageClassName: ""
 accessModes:
   - ReadWriteOnce
 resources:
   requests:
     storage: 8Gi
EOF
```

```
helm -n jenkins install -f values.yaml jenkins jenkins/jenkins
```


## libvirt

<https://github.com/vagrant-libvirt/vagrant-libvirt#installation>

```
vagrant plugin install vagrant-libvirt
```

```
export VAGRANT_DEFAULT_PROVIDER=libvirt
```
