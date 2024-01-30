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
vagrant up debian-bullseye-1
vagrant up debian-bullseye-2
vagrant up debian-bullseye-3
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
vagrant ssh debian-bullseye-1
vagrant ssh debian-bullseye-2
vagrant ssh debian-bullseye-3
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
ip_address=`vagrant ssh-config debian-bullseye-1 | grep HostName | awk '{print $NF}'`
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

```diff
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


## Vault

```
ansible-playbook -b vault.yml
```

vagrant ssh ...

```
export VAULT_SKIP_VERIFY=1
vault operator init -key-shares=1 -key-threshold=1

# Store "Unseal Key 1" and "Initial Root Token" somewhere safe.

vault operator unseal  # Use "Unseal Key 1"

vault login  # Use "Initial Root Token"
```

## Vault HA

```
vagrant up vault-{1,2,3}
ansible-playbook -b vault-ha.yml
```

vagrant ssh vault-1

```
vault operator init -key-shares=1 -key-threshold=1

# Store "Unseal Key 1" and "Initial Root Token" somewhere safe.

vault operator unseal  # Use "Unseal Key 1"

vault login  # Use "Initial Root Token"

watch vault operator raft list-peers
```

vagrant ssh vault-2

```
vault operator raft join https://192.168.50.101:8200

vault operator unseal  # Use "Unseal Key 1" from vault-1
```

vagrant ssh vault-3

```
vault operator raft join https://192.168.50.101:8200

vault operator unseal  # Use "Unseal Key 1" from vault-1
```

```
vagrant destroy -f vault-{1,2,3}
```

## StackGres

```
vagrant up debian-bullseye-1
ansible-playbook -b k3s.yml
vagrant ssh debian-bullseye-1
```

https://min.io/docs/minio/kubernetes/upstream/

```
curl -O https://raw.githubusercontent.com/minio/docs/master/source/extra/examples/minio-dev.yaml
yq -i e 'select(.kind == "Pod").spec.nodeSelector."kubernetes.io/hostname" = "debian-bullseye-1"' minio-dev.yaml
kubectl apply -f minio-dev.yaml
# clusterip
kubectl -n minio-dev create service loadbalancer minio --tcp 9000 --tcp 9090
```

```
stern -n minio-dev .
```

```
sudo curl https://dl.min.io/client/mc/release/linux-amd64/mc -o /usr/local/bin/mc
sudo chmod +x /usr/local/bin/mc
```

```
mc alias set k8s-minio-dev http://127.0.0.1:9000 minioadmin minioadmin
mc admin info k8s-minio-dev
```

```
mc mb k8s-minio-dev/stackgres
```

https://stackgres.io/doc/latest/install/helm/

```
helm repo add stackgres-charts https://stackgres.io/downloads/stackgres-k8s/stackgres/helm/
helm install --create-namespace --namespace stackgres stackgres-operator stackgres-charts/stackgres-operator
```

```
stern -n stackgres .
```

```
kubectl create namespace my-cluster
cat << EOF | kubectl apply -f -
apiVersion: stackgres.io/v1
kind: SGInstanceProfile
metadata:
  namespace: my-cluster
  name: size-small
spec:
  cpu: "1"
  memory: "2Gi"
EOF
```

https://stackgres.io/doc/latest/reference/crd/sgobjectstorage/

```
kubectl -n my-cluster create secret generic my-cluster-minio --from-literal=accesskey=minioadmin --from-literal=secretkey=minioadmin
cat << EOF | kubectl apply -f -
apiVersion: stackgres.io/v1beta1
kind: SGObjectStorage
metadata:
  namespace: my-cluster
  name: backupconfig1
spec:
  type: s3Compatible
  s3Compatible:
    bucket: stackgres
    region: k8s
    enablePathStyleAddressing: true
    endpoint: http://minio.minio-dev:9000
    awsCredentials:
      secretKeySelectors:
        accessKeyId:
          key: accesskey
          name: my-cluster-minio
        secretAccessKey:
          key: secretkey
          name: my-cluster-minio
EOF
```

### Test 1

```
cat << EOF | kubectl apply -f -
apiVersion: stackgres.io/v1
kind: SGCluster
metadata:
  namespace: my-cluster
  name: cluster
spec:
  postgres:
    version: '13.8'
  instances: 1
  sgInstanceProfile: 'size-small'
  pods:
    persistentVolume:
      size: '10Gi'
  prometheusAutobind: true
EOF
```

```
stern -n my-cluster .
```

### Test 2

```
cat << EOF | kubectl apply -f -
apiVersion: stackgres.io/v1
kind: SGCluster
metadata:
  namespace: my-cluster
  name: cluster
spec:
  postgres:
    version: '13.8'
  instances: 1
  sgInstanceProfile: 'size-small'
  pods:
    persistentVolume:
      size: '10Gi'
  configurations:
    # sgPostgresConfig: 'pgconfig1'
    # sgPoolingConfig: 'poolconfig1'
    backups:
    - sgObjectStorage: 'backupconfig1'
      cronSchedule: '*/5 * * * *'
      retention: 6
  prometheusAutobind: true
EOF
```

```
stern -n my-cluster .
```

### Test 3

```
kubectl -n my-cluster get sgbackups

name=...

kubectl -n my-cluster delete sgcluster cluster --wait

cat << EOF | kubectl apply -f -
apiVersion: stackgres.io/v1
kind: SGCluster
metadata:
  namespace: my-cluster
  name: cluster
spec:
  postgres:
    version: '13.8'
  instances: 1
  sgInstanceProfile: 'size-small'
  pods:
    persistentVolume:
      size: '10Gi'
  configurations:
    # sgPostgresConfig: 'pgconfig1'
    # sgPoolingConfig: 'poolconfig1'
    backups:
    - sgObjectStorage: 'backupconfig1'
      cronSchedule: '*/5 * * * *'
      retention: 6
  prometheusAutobind: true
  initialData:
    restore:
      fromBackup:
        name: $name
EOF
```

### Test 4

```
cat << EOF | kubectl apply -f -
apiVersion: stackgres.io/v1
kind: SGBackup
metadata:
  namespace: my-cluster
  name: backup
spec:
  sgCluster: cluster
  managedLifecycle: false
EOF

watch kubectl -n my-cluster get sgbackups
```

```
name=backup

kubectl -n my-cluster delete sgcluster cluster --wait

cat << EOF | kubectl apply -f -
apiVersion: stackgres.io/v1
kind: SGCluster
metadata:
  namespace: my-cluster
  name: cluster
spec:
  postgres:
    version: '13.8'
  instances: 1
  sgInstanceProfile: 'size-small'
  pods:
    persistentVolume:
      size: '10Gi'
  configurations:
    # sgPostgresConfig: 'pgconfig1'
    # sgPoolingConfig: 'poolconfig1'
    backups:
    - sgObjectStorage: 'backupconfig1'
      cronSchedule: '*/5 * * * *'
      retention: 6
  prometheusAutobind: true
  initialData:
    restore:
      fromBackup:
        name: $name
EOF
```

```
vagrant destroy -f debian-bullseye-1
```


## Ansible

```
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
```
