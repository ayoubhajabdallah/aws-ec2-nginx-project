#!/bin/bash
set -e

cd /home/ec2-user/aws-ec2-nginx-project
git pull origin main
sudo cp index.html /usr/share/nginx/html/index.html
sudo chmod 644 /usr/share/nginx/html/index.html
sudo systemctl reload nginx

echo "Deployment complete."
