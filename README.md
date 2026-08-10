# GitOps GCP

This is a basic setup of the gitops.

Commands

## Local setup

`./kind-cluster.sh`

`./install-crossplane.sh`

```sh
$ kubectl apply -f crossplane/provider/gcp-provider.yaml 
provider.pkg.crossplane.io/provider-family-gcp created
```

```sh
$ kubectl get providers
NAME                  INSTALLED   HEALTHY   PACKAGE                                               AGE
provider-family-gcp   False       False     xpkg.upbound.io/upbound/provider-family-gcp:v2.5.1   91s
```
