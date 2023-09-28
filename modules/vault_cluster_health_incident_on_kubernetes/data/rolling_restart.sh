

#!/bin/bash



# Set the namespace and deployment name

NAMESPACE=${NAMESPACE}

DEPLOYMENT=${DEPLOYMENT_NAME}



# Use rolling restart to restart the pods

kubectl rollout restart deployment/${DEPLOYMENT} -n ${NAMESPACE}