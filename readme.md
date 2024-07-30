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
scp hosts ubuntu@$host:~/
done
```



```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
