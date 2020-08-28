# kontaind

kontaind serves both as an installer for kontain and a device manager for
kvm/kkm devices on a k8s cluster. To use kontain monitor within containers in
k8s, we need to first install kontain monitor onto the node to which we want
to deploy kontainers. Then we need a device manager for `kvm` devices so k8s
knows how to scheudle workloads onto the right node. For this, we developed
kontaind, a device manager for `kvm` and `kkm` device, running as a daemonset
on nodes that has these devices avaliable.

To deploy the latest version of `kontaind`, run:
```bash
kubectl apply \
  -f https://github.com/kontainapp/km-releases/blob/master/k8s/kontaind/deployment.yaml?raw=true
```

Alternatively, you can download the yaml and make your own modification:
``` bash
wget https://github.com/kontainapp/km-releases/blob/master/k8s/kontaind/deployment.yaml?raw=true -O kontaind.yaml
```