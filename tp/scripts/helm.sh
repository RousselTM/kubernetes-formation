#!/bin/bash

file=get_helm.sh

curl -fsSL -o $file https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 $file
./$file
rm -f $file