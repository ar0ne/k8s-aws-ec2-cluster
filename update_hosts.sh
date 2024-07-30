#!/bin/bash

SERVER_IP=$(aws cloudformation list-exports --query "Exports[?Name==\`server\`].Value" --no-paginate --output text)
NODE0_IP=$(aws cloudformation list-exports --query "Exports[?Name==\`node-0\`].Value" --no-paginate --output text)
NODE1_IP=$(aws cloudformation list-exports --query "Exports[?Name==\`node-1\`].Value" --no-paginate --output text)

if [[ -z $SERVER_IP ]]; then
    echo "Server (control plane) node public IP not found. Abort"
    exit
fi

echo $SERVER_IP server > hosts
echo $NODE0_IP node-0 >> hosts
echo $NODE1_IP node-1 >> hosts

echo "updating /etc/hosts"
cat hosts | sudo tee -a /etc/hosts
