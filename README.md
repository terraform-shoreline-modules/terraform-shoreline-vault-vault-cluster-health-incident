
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Vault cluster health incident on kubernetes
---

The Vault cluster health incident is related to the health of a Vault cluster instance. This incident type is triggered when the cluster instance is not healthy and requires attention to ensure it is functioning properly. The incident typically involves evaluating the current state of the cluster instance, diagnosing the issue, and taking corrective action to restore the health of the instance.

### Parameters
```shell
export DEPLOYMENT_NAME="PLACEHOLDER"

export VAULT_POD_NAME="PLACEHOLDER"

export LOG_FILE_PATH="PLACEHOLDER"

export SERVICE_URL="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export SERVICE_NAME="PLACEHOLDER"

export CONTAINER_NAME="PLACEHOLDER"
```

## Debug

### Get the list of pods running in the Kubernetes cluster
```shell
kubectl get pods
```

### Get the logs of a specific pod
```shell
kubectl logs ${VAULT_POD_NAME}
```

### Check the status of a Kubernetes deployment
```shell
kubectl rollout status deployment/${DEPLOYMENT_NAME}
```

### Describe a Kubernetes pod to get more information about its state
```shell
kubectl describe pod ${VAULT_POD_NAME}
```

### Check if the Vault cluster is running and accessible
```shell
kubectl exec -it ${VAULT_POD_NAME} -n ${NAMESPACE} bash -- vault status
```

### Check the logs of the Vault server to see if there are any errors
```shell
kubectl exec -it ${VAULT_POD_NAME} -n ${NAMESPACE} bash -- vault server -log-level=debug
```

### Check the health of the Vault cluster nodes
```shell
kubectl exec -it ${VAULT_POD_NAME} -n ${NAMESPACE} bash -- vault operator raft list-peers
```

### A network issue that is affecting the connectivity or performance of the Vault cluster instance.
```shell


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


```

## Repair

### Check the logs of the Vault cluster instance to identify the root cause of the issue. This could involve looking for error messages or other indicators of problems with the instance.
```shell


#!/bin/bash



# Set variables

VAULT_POD=${VAULT_POD_NAME}

LOG_FILE=${LOG_FILE_PATH}



# Get logs for the Vault pod

kubectl logs $VAULT_POD > $LOG_FILE



# Search for error messages

if grep -q "error" $LOG_FILE; then

    echo "Error messages found in logs"

    # Perform additional remediation steps as needed

else

    echo "No error messages found in logs"

fi


```

### Restart the Vault cluster instance to see if this resolves the issue. This could involve stopping and starting the instance, or rebooting the server if necessary.
```shell


#!/bin/bash



# Set the namespace and deployment name

NAMESPACE=${NAMESPACE}

DEPLOYMENT=${DEPLOYMENT_NAME}



# Use rolling restart to restart the pods

kubectl rollout restart deployment/${DEPLOYMENT} -n ${NAMESPACE}


```