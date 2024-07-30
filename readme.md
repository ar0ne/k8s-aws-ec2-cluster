# How to run

```
 aws cloudformation create-stack --stack-name <YOUR_STACK_NAME> --template-body file://ec2.yaml --parameters file://k8s-ec2.json
```

Put EC2 instance IPs to file `hosts`:


```
xxx.x.x.x server
xxx.x.x.x node-0
xxx.x.x.x node-1

# cat hosts >> /etc/hosts
```

And copy same file to all instances:

```
for host in node-0 node-1 server; do
scp hosts containerd-install.sh k8s-install.sh ubuntu@$host:~/
done
```



```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```



```
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```

```
kubeadm init --ignore-preflight-errors=NumCPU,Mem
```

```
kubeadm token create --print-join-command
```


# Install Helm

Check if this is still actual for your OS.

```
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```


```
kubectl apply -f https://storage.googleapis.com/minikube-site-examples/ingress-example.yaml
```

```
cat hosts | sudo tee -a /etc/hosts
```
