### mini-kube start

```sh
minikube start
```

### mini-kube stop

```sh
minikube stop
```

### delete all pod

```sh
kubectl delete all --all -n my-app
```

### get all pod in namespace

```sh
kubectl get all -n my-app
```

### apply all yaml file

```sh
kubectl apply -f mock.yaml
kubectl apply -f secrets.yaml
```

### Port forward to test

```
kubectl port-forward service/auth-service 8080:80 -n my-app
kubectl port-forward service/campground-service 8081:81 -n my-app
kubectl port-forward service/llm-chat-service 8082:82 -n my-app
kubectl port-forward service/mail-service 8083:83 -n my-app
```

### logs

```sh
kubectl logs <pod-name> -n my-app
```
