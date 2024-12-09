# K3s Cluster Setup Guide

This guide explains how to set up a K3s cluster with a notebook as the master node and Raspberry Pi devices as worker nodes.

## Prerequisites

- A notebook/laptop for the master node
- One or more Raspberry Pi devices for worker nodes
- All devices connected to the same network
- SSH access to all devices

## Setup Steps

### 1. Master Node Setup

Initialize the K3s server on your notebook:

```sh
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s
```

### 2. Master Node Configuration

Apply a taint to prevent workloads from running on the master node:

```sh
# Replace <NODE_NAME> with your master node's name
kubectl taint nodes <NODE_NAME> node-role.kubernetes.io/master=:NoSchedule
```

### 3. Worker Node Setup

Get the master node token:

```sh
sudo cat /var/lib/rancher/k3s/server/node-token
```

On each Raspberry Pi, run:

```sh
curl -sfL https://get.k3s.io | K3S_TOKEN="<Token From Main Cluster>" \
K3S_URL="https://<Main Cluster IP>:6443" \
K3S_NODE_NAME="<Node Name>" sh -
```

### 4. Application Deployment

Create and configure the application namespace:

```sh
# Create namespace
kubectl create namespace my-app

# Clean up any existing resources
kubectl delete all --all -n my-app

# Apply configurations
kubectl apply -f services.yaml
kubectl apply -f deployments.yaml
kubectl apply -f ingress.yaml
kubectl apply -f secrets.yaml
```

### 5. Verify Deployment

Check the status of your deployment:

```sh
# List all pods
kubectl get pods -n my-app

# List all services
kubectl get services -n my-app

# List all deployments
kubectl get deployments -n my-app

# Check ingress status
kubectl get ingress -n my-app
```

## Maintenance and Troubleshooting

### Logging

View logs for specific pods:

```sh
kubectl logs <pod-name> -n my-app

# Follow logs in real-time
kubectl logs -f <pod-name> -n my-app
```

### Container Image Management

Clean up unused images:

```sh
sudo k3s ctr images prune --all
```

Remove specific images:

```sh
sudo k3s ctr image rm <image-name>
```

### Cluster Management

View node status:

```sh
kubectl get nodes

# Detailed node information
kubectl describe node <node-name>
```

Check cluster health:

```sh
kubectl get componentstatuses
kubectl cluster-info
```

### Common Issues

1. **Node Not Joining Cluster**

   - Verify network connectivity
   - Check token and URL accuracy
   - Ensure ports 6443 and 10250 are open

2. **Pods Not Starting**

   - Check node resources: `kubectl describe node <node-name>`
   - View pod events: `kubectl describe pod <pod-name> -n my-app`
   - Check logs: `kubectl logs <pod-name> -n my-app`

3. **Service Connectivity Issues**
   - Verify service status: `kubectl get svc -n my-app`
   - Check endpoint status: `kubectl get endpoints -n my-app`
   - Test service DNS: `kubectl run -it --rm debug --image=busybox -- nslookup <service-name>.my-app`

## Architecture

The application consists of four microservices:

- Auth Service (Port 80)
- Campground Service (Port 81)
- LLM Chat Service (Port 82)
- Mail Service (Port 83)

All services are accessible through the Ingress controller at their respective paths:

- /auth
- /campgrounds
- /chat
- /mail

## Security Notes

- Keep the K3s token secure and never share it publicly
- Regularly update K3s and container images
- Monitor cluster logs for suspicious activities
- Use network policies to restrict pod-to-pod communication
- Keep secrets encrypted and regularly rotate credentials
