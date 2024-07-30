# How to use

This CF template creates 3 EC2 instances within new VPC with required security groups, public IPs, route tables and NACLs.

```
 aws cloudformation create-stack --stack-name <YOUR_STACK_NAME> --template-body file://k8s-ec2.yaml --parameters file://vars.json
```
    
Once cluster created, you need to add public IPs to `/etc/hosts` file. And repeat same action on all nodes. To simplify it you could run `./scripts/update_hosts.sh`. If everything is fine, you could find new records in your hosts (`cat /etc/hosts`).

```

xxx.x.x.x server
xxx.x.x.x node-0
xxx.x.x.x node-1
```

Now you need to copy installation files to nodes.
For that you could run this:

```
for host in server node-0 node-1 server; do
scp hosts ubuntu@$host:~/
scp scripts/containerd-install.sh scripts/k8s-install.sh ubuntu@$host:~/
done
```

Now you need to connect to remote servers via ssh.

## Setup Server (control plane)

In your local `~/.ssh/conig` you could point new hosts to `.pem` file you used for ec2.
After that you could just use: `ssh ubuntu@server`.

e.g.

```
Host server
    Hostname xxx.x.x.x 
    User ubuntu
    IdentityFile ~/.ssh/ec2testkeypair.pem
```

Add hosts to local hosts file:

`cat hosts | sudo tee -a /etc/hosts`

Now you need to install container runtime (containerd/CRI-O/Docker engine)
If you prefer to install [containerd](https://containerd.io/), you could use script we just copied  `./containerd-install.sh`. After installation don't forget to check service status:

```
service containerd status
```

Now it's time to install `kubeadm`, `kubelet` and `kubectl`.

Run `./k8s-install.sh`


Then check installation:

```
kubeadm version

```

Kubelet service should be inactive, because haven't initialized the cluster yet.

```
service kubelet status
```

To make it:

```
sudo kubeadm init
```

Sizes `nano` and `micro` are not enough to run kubernetes on production. It most likely won't let you init cluster with such weak machines. But for tests environment you could just ignore it.

```
kubeadm init --ignore-preflight-errors=NumCPU,Mem
```

From result you could find that you need to run next commands as regular user and remember invitation command to join the cluster at the end.

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Now you could check status of static pods:

```
kubectl get pod -A
```

Install add-on Weave Net:

```
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```

## Setup Workers (Node-0 and Node-1)

Follow same actions as for control plane - update hosts, run installation scripts and check if services work.

Now you need to join the cluster. For it on `Server` node you could copy invitation from `kubeadm init` or run this command if you missed it already:

```
kubeadm token create --print-join-command
```

Run output on each of workers node.

Verify that nodes are available from server `kubectl get nodes`.

Well, you have created your own k8s cluster on EC2.


### Install Helm

Check if this is still actual for your OS.

```
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

### Ingress controller 

```
kubectl apply -f https://storage.googleapis.com/minikube-site-examples/ingress-example.yaml
```

