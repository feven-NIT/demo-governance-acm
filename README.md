
Add label cluster bm2 environment=dev 
Add label cluster bm3 environment=prod 

# Prepare

Update ca certificate to have an EOF < 1000 hours (for demo purpose)

```shell
short-new-certificate.sh
```

```shell
openssl s_client -connect test.apps.bm3.redhat.hpecic.net:443 -showcerts </dev/null 2>/dev/null | openssl x509 -noout -enddate
```

# Demo

Create the namespace for the policies and the placementrules

```shell
oc apply -f manifest/namespaces.yaml
```


```shell
oc apply -f manifest/placementrule.yml
```


Click Governance on the left pane to navigate to the governance dashboard. Then, click Create policy. The Create policy page displays.

![Alt text](./images/1-create-policy.png)

Complete the fields as follow:

| Field Name     | Value                          |
|----------------|--------------------------------|
| Name           | policy-certificatepolicy       |
| Namespace      | policy-governance              |
| Specifications | CertificatePolicy - Certificate management expiration |
| Remediation    | Inform                         |



On the right side of the Create policy page, edit the YAML code as follows:

```shell
spec:
  remediationAction: inform
  disabled: false
  policy-templates:
    - objectDefinition:
        apiVersion: policy.open-cluster-management.io/v1
        kind: CertificatePolicy
        metadata:
          name: policy-certificatepolicy-cert-expiration
        spec:
          namespaceSelector:
            include:
              - default
              - openshift-console
              - openshift-ingress
            exclude:
              - kube-*
          remediationAction: inform
          severity: low
          minimumDuration: 1000h
```

Click create


go back to default certificate
```shell
default-ingress-certificate.sh
```


# clean

