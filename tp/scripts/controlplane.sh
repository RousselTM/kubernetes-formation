#!/bin/bash

echo "Debut execution partie controlplane"

# Initialisation du cluster Kubernetes
sudo kubeadm init --apiserver-advertise-address=192.168.56.10 --pod-network-cidr=10.244.0.0/16



# Configuration de kubectl pour l'utilisateur vagrant
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config




# Création de la commande de jointure et stockage dans un fichier partagé
kubeadm token create --print-join-command > /vagrant/join_command.sh
chmod +x /vagrant/join_command.sh




#Hubble
curl -Lo https://github.com/cilium/hubble/releases/latest/download/hubble-linux-amd64.tar.gz
tar -xvf hubble-linux-amd64.tar.gz
sudo mv hubble /usr/local/bin/


# Install HELM
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh




# Define the CNI plugin from environment variable or use a default
CNI_PLUGIN=${CNI_PLUGIN:-"cilium"}

echo "Selected CNI plugin: $CNI_PLUGIN"

# Switch case for CNI plugin installation
case $CNI_PLUGIN in
  "flannel")
    echo "Installing Flannel..."
    kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
    ;;

  "calico")
    echo "Installing Calico..."
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
    ;;

  "cilium")
    echo "Installing Cilium..."
    helm repo add cilium https://helm.cilium.io/
    # https://docs.cilium.io/en/stable/observability/metrics/
    sudo helm upgrade --install --namespace kube-system --repo https://helm.cilium.io cilium cilium --values ../configs/cilium-values.yaml
    #Check 
    sudo cilium status --wait
    sudo cilium connectivity test
    ;;

  *)
    echo "Unknown CNI plugin: $CNI_PLUGIN"
    echo "Please set CNI_PLUGIN to one of the following: flannel, calico, cilium"
    exit 1
    ;;
esac

echo "CNI plugin $CNI_PLUGIN installation completed."