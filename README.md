# 🛒 Gerenciamento de Produtos
> API REST com infraestrutura completa de containers, orquestração Kubernetes, monitoramento e pipeline CI/CD.

![Java](https://img.shields.io/badge/Java_17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring_Boot_3-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL_8-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)

---

## 📋 Sobre o Projeto

Projeto backend educativo desenvolvido como trabalho final da pós-graduação em DevOps. A aplicação é uma API REST de gerenciamento de produtos construída com **Spring Boot**, com infraestrutura completa cobrindo:

- Containerização com **Docker**
- Orquestração com **Kubernetes (Minikube)**
- Monitoramento com **Prometheus + Grafana**
- Pipeline de entrega contínua com **Jenkins**

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────┐
│                   CLUSTER KUBERNETES                     │
│                                                         │
│  ┌─────────────────┐        ┌──────────────────────┐   │
│  │   API (x4 pods) │        │   Prometheus (PVC)   │   │
│  │  NodePort:30080 │        │   ClusterIP:9090     │   │
│  └────────┬────────┘        └──────────┬───────────┘   │
│           │                            │                │
│  ┌────────▼────────┐        ┌──────────▼───────────┐   │
│  │   MySQL (pod)   │        │   Grafana            │   │
│  │  ClusterIP:3306 │        │   NodePort:30300     │   │
│  └─────────────────┘        └──────────────────────┘   │
└─────────────────────────────────────────────────────────┘
          ▲
          │ CI/CD
┌─────────┴──────────┐
│   Jenkins Pipeline  │
│  Build→Push→Deploy  │
└────────────────────┘
```

---

## 🚀 Executando Localmente com Docker Compose

```bash
docker compose up --build
```

Acesse a API em: `http://localhost:8080`

### Testando a API

```bash
# Verificar se a API está no ar
curl http://localhost:8080/produtos/ping
```

### Acessando o banco de dados MySQL

```bash
# 1. Entrar no container
docker exec -it mysql-dev bash

# 2. Conectar ao banco (informe a senha do .env quando solicitado)
mysql -u root -p
```

---

## 🐳 Docker — Gerando e Publicando a Imagem

```bash
# 1. Gerar o .jar na raiz do projeto
./mvnw clean package

# 2. Buildar a imagem
docker build -t tarcizo/gerenciamento-produtos:1.0 .

# 3. Testar localmente
docker run -p 8080:8080 tarcizo/gerenciamento-produtos:1.0

# 4. Publicar no Docker Hub
docker login
docker push tarcizo/gerenciamento-produtos:1.0
```

🔗 Imagem disponível em: [hub.docker.com/r/tarcizo/gerenciamento-produtos](https://hub.docker.com/r/tarcizo/gerenciamento-produtos)

---

## ☸️ Kubernetes — Deploy no Cluster

### Pré-requisitos

```bash
minikube start
```

### Subir toda a infraestrutura

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/prometheus.yaml
```

### Verificar o estado do cluster

```bash
kubectl get pods,svc -n default
kubectl get pvc -n default
```

### Estrutura dos manifests

| Arquivo | O que sobe |
|---|---|
| `k8s/deployment.yaml` | API (4 réplicas) + MySQL |
| `k8s/prometheus.yaml` | Prometheus + Grafana + PVC |

### Acessar os serviços

```bash
# Grafana (abre no browser automaticamente)
minikube service grafana-svc

# Prometheus (para diagnóstico)
minikube service prometheus-svc --url
```

| Serviço | Tipo | Porta | Credenciais |
|---|---|---|---|
| API | NodePort | 30080 | — |
| Grafana | NodePort | 30300 | admin / admin123 |
| Prometheus | ClusterIP | 9090 | interno |
| MySQL | ClusterIP | 3306 | interno |

---

## 📊 Monitoramento — Prometheus & Grafana

### Configurar o Datasource no Grafana

1. Acesse o Grafana: `http://<NODE_IP>:30300`
2. Vá em **Connections → Data Sources → Add → Prometheus**
3. URL: `http://prometheus-svc.default.svc.cluster.local:9090`
4. Clique **Save & Test**

### Importar o Dashboard

1. Vá em **Dashboards → Import**
2. Digite o ID **1860** e clique **Load**
3. Selecione o datasource **Prometheus** → **Import**

### Métricas disponíveis da aplicação

| Métrica | Descrição |
|---|---|
| `container_memory_usage_bytes` | Uso de memória por pod |
| `container_cpu_usage_seconds_total` | Uso de CPU por pod |
| `http_server_requests_seconds_count` | Total de requisições HTTP |
| `hikaricp_connections_active` | Conexões ativas no pool do MySQL |

> Métricas expostas pelo Spring Boot Actuator em `/actuator/prometheus`

### Garantias de infraestrutura

- ✅ **Prometheus** com `ClusterIP` — acessível apenas internamente
- ✅ **Grafana** com `NodePort` — único serviço exposto externamente
- ✅ **PVC de 2Gi** — dados do Prometheus persistidos em disco

---

## 🔁 Pipeline CI/CD — Jenkins

### Estágios do pipeline

```
🐳 Build  →  📤 Push Docker Hub  →  ☸️ Deploy K8s  →  ✅ Verificação
```

### Configurar o Jenkins

```bash
# Subir o Jenkins via Docker
docker run -d -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name jenkins \
  jenkins/jenkins:lts

# Obter a senha inicial
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Pré-requisitos no Jenkins

1. Criar credencial `dockerhub-creds` em **Manage Jenkins → Credentials**
2. Instalar Docker no container Jenkins:

```bash
docker exec -u root jenkins apt-get install -y docker.io
docker exec -u root jenkins chmod 666 /var/run/docker.sock
```

### Stages do Jenkinsfile

| Stage | O que faz |
|---|---|
| Build | Gera a imagem Docker com tag do build number |
| Push | Autentica e envia a imagem para o Docker Hub |
| Deploy | Aplica os manifests no cluster Kubernetes |
| Verificação | Lista pods e serviços para confirmar o deploy |

---

## 🩺 Health Checks

| Endpoint | Tipo de Probe | Comportamento |
|---|---|---|
| `/actuator/health` | Liveness + Readiness | Reinicia o pod se falhar 3x |
| `/actuator/prometheus` | Scrape do Prometheus | Coleta métricas a cada 15s |

---

## 🗂️ Estrutura do Projeto

```
Gerenciamento-de-produtos/
├── src/                        # Código fonte Spring Boot
├── k8s/
│   ├── deployment.yaml         # API (4 réplicas, NodePort) + MySQL (ClusterIP)
│   └── prometheus.yaml         # Prometheus (PVC) + Grafana (NodePort)
├── Dockerfile                  # Imagem da aplicação
├── docker-compose.yml          # Ambiente local de desenvolvimento
├── Jenkinsfile                 # Pipeline CI/CD
└── pom.xml                     # Dependências Maven
```

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Versão | Função |
|---|---|---|
| Java | 17 | Linguagem |
| Spring Boot | 3.5 | Framework web |
| Spring Data JPA | — | Persistência |
| MySQL | 8.0 | Banco de dados |
| Micrometer + Prometheus | — | Métricas |
| Docker | — | Containerização |
| Kubernetes / Minikube | — | Orquestração |
| Prometheus | 2.51 | Coleta de métricas |
| Grafana | 10.4 | Dashboards |
| Jenkins | LTS | Pipeline CI/CD |

---

## 👤 Autor

**Tarcizo Neto**  
Pós-graduação em DevOps — Projeto Final