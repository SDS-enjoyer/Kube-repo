#!/bin/bash

# Function to run a port-forward in a loop
port_forward() {
  local service_name=$1
  local local_port=$2
  local remote_port=$3
  local namespace=$4

  while true; do
    echo "Starting port-forward for $service_name on $local_port:$remote_port in namespace $namespace..."
    kubectl port-forward service/$service_name $local_port:$remote_port -n $namespace
    echo "Port-forward for $service_name on $local_port:$remote_port failed. Restarting in 1 second..."
    sleep 1
  done
}

# Function to clean up background processes
cleanup() {
  echo "Stopping all port-forward processes..."
  pkill -f "kubectl port-forward"
  exit 0
}

# Set up trap to catch SIGINT (Ctrl+C) and clean up
trap cleanup SIGINT

# Namespace
NAMESPACE="my-app"

# Run port-forward commands for each service in the background
port_forward auth-service 8080 80 $NAMESPACE &
port_forward campground-service 8081 81 $NAMESPACE &
port_forward llm-chat-service 8082 82 $NAMESPACE &
port_forward mail-service 8083 83 $NAMESPACE &

# Wait for all background processes to finish
wait
