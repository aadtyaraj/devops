#!/bin/bash
set -euo pipefail

CLUSTER_NAME="${1:-}"

# Delete existing cluster (silently, in case none exists)
if [[ -n "$CLUSTER_NAME" ]]; then
  # doesn't exist error sent to hell
  kind delete cluster --name "$CLUSTER_NAME" 2>/dev/null || true
else
  kind delete cluster 2>/dev/null || true
fi

while true; do
  read -rp "Install Calico CNI? (y/n): " CALICO
  if [[ "$CALICO" == "y" ]]; then
    CONFIG="./cluster-config-calico.yaml"
    break
  elif [[ "$CALICO" == "n" ]]; then
    CONFIG="./cluster-config.yaml"
    break
  else
    echo "Invalid input: please enter y or n"
  fi
done

echo "Creating cluster with config: $CONFIG"
if [[ -n "$CLUSTER_NAME" ]]; then
  kind create cluster --config "$CONFIG" --name "$CLUSTER_NAME"
else
  kind create cluster --config "$CONFIG"
fi

if [[ "$CALICO" == "y" ]]; then
  echo "Installing Calico operator and CRDs..."
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.0/manifests/v1_crd_projectcalico_org.yaml
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.0/manifests/tigera-operator.yaml
  
  sleep 1

  echo "Applying Calico custom resources..."
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.0/manifests/custom-resources.yaml

  sleep 1

  echo "Waiting for Calico node pods to be ready..."
  kubectl wait pod -l k8s-app=calico-node -A \
    --for=condition=Ready --timeout=120s
fi

echo "Cluster is ready."
