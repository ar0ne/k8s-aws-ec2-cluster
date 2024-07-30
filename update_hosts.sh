#!/bin/bash

SERVER_IP=$(aws cloudformation list-exports --query "Exports[?Name==\`server\`].Value" --no-paginate --output text)
NODE0_IP=$(aws cloudformation list-exports --query "Exports[?Name==\`node-0\`].Value" --no-paginate --output text)
NODE1_IP=$(aws cloudformation list-exports --query "Exports[?Name==\`node-1\`].Value" --no-paginate --output text)

echo $SERVER_IP server > hosts
echo $NODE0_IP node-0 >> hosts
echo $NODE1_IP node-1 >> hosts
