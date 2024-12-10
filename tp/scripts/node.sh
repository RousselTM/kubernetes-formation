#!/bin/bash

echo "Debut execution partie node"

# Attente de la commande de jointure générée sur le plan de contrôle
while [ ! -f /vagrant/join_command.sh ]; do sleep 2; done
sudo bash /vagrant/join_command.sh