# Kubernetes config file
============

**Prerequisites**
* Local service images
* Kubernetes configuration files

## Deployment Script Overview
This guide provides commands for managing the configuration file and deploying services in two formats: all services in one pod or each service in its own pod.

**1. Configuration File (`config.yaml`)**
This file creates the necessary configuration for the services.
* Create:
    ```bash
    kubectl create -f config.yaml
    ```
* Delete:
    ```bash
    kubectl delete -f config.yaml
    ```

**2. Single-Pod Deployment (`deployment.yaml`)**
This deployment file creates one pod that runs all four services as separate containers.
* Create:
    ```bash
    kubectl apply -f deployment.yaml
    ```
* Delete:
    ```bash
    kubectl delete -f deployment.yaml
    ```

**3. Multi-Pod Deployment**
This option creates a separate pod for each service, allowing for independent scaling and resource management.
* Create:
    ```bash
    kubectl apply -f auth-service.yaml
    kubectl apply -f campground-service.yaml
    kubectl apply -f llm-chat-service.yaml
    kubectl apply -f mail-service.yaml
    ```
* Delete:
    ```bash
    kubectl delete -f auth-service.yaml
    kubectl delete -f campground-service.yaml
    kubectl delete -f llm-chat-service.yaml
    kubectl delete -f mail-service.yaml
    ```
