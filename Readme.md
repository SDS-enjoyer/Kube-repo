# K3s Setup Guide


## 1. Start the K3s Server
Run this command on your main server (notebook) to initialize the master node/controller:
```sh
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s
```

### 2. Taint the Master Node
Prevent the master node from running application pods by adding a taint. Replace <NODE_NAME> with the name of your node:
```sh
kubectl taint nodes <NODE_NAME> node-role.kubernetes.io/master=:NoSchedule
```

### 3. Start the K3s Agent on Raspberry Pi
Connect each Raspberry Pi node to the master server to act as an agent. Replace `<Token From Main Cluster>`, `<Main Cluster IP>`, and `<Node Name>`
```sh
curl -sfL https://get.k3s.io | K3S_TOKEN="<Token From Main Cluster>" K3S_URL="https://<Main Cluster IP>:6443" K3S_NODE_NAME="<Node Name>" sh -
```

### 4. Create a Namespace
Create a namespace to organize your application resources. Run this on the master node:
```sh
kubectl create namespace my-app
```

### 5. Delete All Pods in the Namespace
Ensure that the my-app namespace is clear of existing resources:
```sh
kubectl delete all --all -n my-app
```
### 6. Apply Configuration Files
Deploy your application by applying the necessary YAML files:

```sh
kubectl apply -f main.yaml
kubectl apply -f secrets.yaml
```

### 7. List All Pods in the Namespace
Verify the pods running in the my-app namespace:

```sh
kubectl get pods -n my-app
```


### 8. Port Forwarding for Local Testing
Forward local ports to the services for testing. Run the following commands on the master node:

```
kubectl port-forward service/auth-service 8080:80 -n my-app
kubectl port-forward service/campground-service 8081:81 -n my-app
kubectl port-forward service/llm-chat-service 8082:82 -n my-app
kubectl port-forward service/mail-service 8083:83 -n my-app
```

---

# K3s Maintenance and Troubleshooting


### 1. Check Logs
View the logs of a specific pod in the my-app namespace. Replace <pod-name> with the pod's name:

```sh
kubectl logs <pod-name> -n my-app
```

## 2. Prune Unused K3s Images
Clean up unused container images to free up space:
```sh
sudo k3s ctr images prune --all

```

### 3. Delete a Specific Image
Remove an image from the K3s container runtime. Replace `<image-name>` with the name of the image to delete:

```sh
sudo k3s ctr image rm <image-name>
```

### 4. Retrieve the K3s Server Token
Get the K3s server token to connect agents to the cluster:

```sh
sudo cat /var/lib/rancher/k3s/server/node-token
```
