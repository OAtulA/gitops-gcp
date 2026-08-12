#!/bin/bash

set -x

echo "Installing argocd"

kubectl create namespace argocd \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply --server-side \
  -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
