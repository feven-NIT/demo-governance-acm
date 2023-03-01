#!/bin/bash


# Step 1: Create custom CA and certificate
echo "Generating custom CA and certificate..."
mkdir -p ca
openssl genrsa -out ca/example-ca.key 2048
openssl req -x509 -new -nodes -key ca/example-ca.key -subj "/CN=example.com" -days 30 -out ca/example-ca.crt
openssl genrsa -out ca/wildcard.example.com.key 2048
openssl req -new -key ca/wildcard.example.com.key -subj "/CN=wildcard.example.com" -out ca/wildcard.example.com.csr
openssl x509 -req -in ca/wildcard.example.com.csr -CA ca/example-ca.crt -CAkey ca/example-ca.key -CAcreateserial -out ca/wildcard.example.com.crt -days 30

# Step 2: Delete existing configmap and create new one
echo "Deleting existing configmap and creating new one..."
if oc get configmap custom-ca -n openshift-config >/dev/null 2>&1; then
  oc delete configmap custom-ca -n openshift-config
fi
oc create configmap custom-ca \
     --from-file=ca-bundle.crt=./ca/example-ca.crt \
     -n openshift-config

# Step 3: Update cluster-wide proxy configuration
echo "Updating cluster-wide proxy configuration..."
oc patch proxy/cluster \
     --type=merge \
     --patch='{"spec":{"trustedCA":{"name":"custom-ca"}}}'

# Step 4: Delete existing secret and create new one
echo "Deleting existing secret and creating new one..."
if oc get secret wildcard-cert -n openshift-ingress >/dev/null 2>&1; then
  oc delete secret wildcard-cert -n openshift-ingress
fi
oc create secret tls wildcard-cert \
     --cert=./ca/wildcard.example.com.crt \
     --key=./ca/wildcard.example.com.key \
     -n openshift-ingress

# Step 5: Update Ingress Controller configuration
echo "Updating Ingress Controller configuration..."
oc patch ingresscontroller.operator default \
     --type=merge -p \
     '{"spec":{"defaultCertificate": {"name": "wildcard-cert"}}}' \
     -n openshift-ingress-operator

echo "Custom certificate successfully created and configured!"

