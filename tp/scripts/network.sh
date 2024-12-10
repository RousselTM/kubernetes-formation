#!/bin/bash

# Réseau
echo "DNS=8.8.8.8" >> /etc/systemd/resolved.conf
systemctl restart systemd-resolved

apt-get update
apt-get install -y docker.io
usermod -aG docker vagrant

# KIND
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind create cluster --config /vagrant/kind-config.yaml