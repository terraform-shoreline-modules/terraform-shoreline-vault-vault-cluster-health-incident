

#!/bin/bash



# Define the namespace, pod name, and container name for the Vault instance

NAMESPACE=${NAMESPACE}

POD_NAME=${VAULT_POD_NAME}

CONTAINER_NAME=${CONTAINER_NAME}



# Check the logs of the Vault container

kubectl logs $POD_NAME -c $CONTAINER_NAME -n $NAMESPACE



# Check the network connectivity between the Vault container and other services

kubectl exec $POD_NAME -c $CONTAINER_NAME -n $NAMESPACE -- ping ${SERVICE_NAME}



# Check the network performance between the Vault container and other services

kubectl exec $POD_NAME -c $CONTAINER_NAME -n $NAMESPACE -- curl --connect-timeout 5 --max-time 10 ${SERVICE_URL}