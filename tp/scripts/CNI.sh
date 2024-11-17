
# DNS Setting
if [ ! -d /etc/systemd/resolved.conf.d ]; then
	sudo mkdir /etc/systemd/resolved.conf.d/
fi
cat <<EOF | sudo tee /etc/systemd/resolved.conf.d/dns_servers.conf
[Resolve]
DNS=8.8.8.8
EOF

sudo systemctl restart systemd-resolved




#Install required binaries:

# Kind
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

#Cilium
curl -Lo https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
tar -xzf cilium-linux-amd64.tar.gz 
sudo mv cilium /usr/local/bin/

#Hubble
curl -Lo https://github.com/cilium/hubble/releases/latest/download/hubble-linux-amd64.tar.gz
tar -xvf hubble-linux-amd64.tar.gz
sudo mv hubble /usr/local/bin/

# Create Kind cluster
kind create cluster --config=configs/kind-config.yaml

# Install HELM
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Install Cilium
# https://docs.cilium.io/en/stable/observability/metrics/
helm repo add cilium https://helm.cilium.io/
helm upgrade --install --namespace kube-system --repo https://helm.cilium.io cilium cilium --values configs/cilium-values.yaml
#Check 
cilium status --wait
cilium connectivity test