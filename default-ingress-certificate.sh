#!/bin/bash

# Delete the custom config map
oc delete configmap custom-ca -n openshift-config

# Update the cluster-wide proxy configuration to use the default CA
oc patch proxy/cluster \
     --type=merge \
     --patch='{"spec":{"trustedCA":null}}'

# Delete the custom secret containing the wildcard certificate chain and key
oc delete secret wildcard-cert -n openshift-ingress

# Update the Ingress Controller configuration to use the default certificate
oc patch ingresscontroller.operator default \
     --type=merge -p \
     '{"spec":{"defaultCertificate":null}}' \
     -n openshift-ingress-operator

