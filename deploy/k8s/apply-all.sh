#!/usr/bin/env bash
# =============================================================================
# Aplica deployment.yaml (app + Redis) e prometheus.yaml (Prometheus + Grafana).
# Uso: ./scripts/apply-all.sh  (na raiz do projeto guia-kubernetes-infnet)
# =============================================================================

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo ">>> Aplicando manifests Kubernetes..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/prometheus.yaml

echo ""
echo ">>> Aguardando Pods (timeout 180s)..."
kubectl rollout status deployment/app   -n default --timeout=180s
kubectl rollout status deployment/prometheus -n default --timeout=180s
kubectl rollout status deployment/grafana    -n default --timeout=180s
kubectl rollout status deployment/mysql-svc      -n default --timeout=180s

echo ""
echo ">>> Pronto! Estado atual do cluster:"
kubectl get pods,svc -n default

echo ""
echo ">>> Acesso:"
echo "    App:     http://<NODE_IP>:30080"
echo "    Grafana: http://<NODE_IP>:30300  (admin / admin123)"
