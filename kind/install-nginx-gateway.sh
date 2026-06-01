#!/bin/bash
set -euo pipefail

echo "Installing Nginx Gateway Fabric CRDs..."
kubectl kustomize \
  "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.6.3" \
  | kubectl apply -f -

sleep 1

echo "Installing Nginx Gateway Fabric via Helm..."
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric \
  --create-namespace -n nginx-gateway \
  --set nginx.service.type=NodePort \
  --set-json 'nginx.service.nodePorts=[{"port":31437,"listenerPort":80},{"port":30478,"listenerPort":8443}]'

echo "Nginx Gateway Fabric installed."
