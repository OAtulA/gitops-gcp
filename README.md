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

## Cloud setup

- Authenticate with gcloud

`gcloud auth login`

This will open a browser tab just login with the account.

- Save the vars in the .env file

There is a `./.env.demo` copy it and fill the values

`cp .env.demo .env`

- Source it

`. ./export-vars.sh`

- __Create a service account__

```sh
$  gcloud iam service-accounts create crossplane --display-name="Crossplane GCP" --project=<PROJECT_ID>
Created service account [crossplane].
Service account email: crossplane@<PROJECT_ID>.iam.gserviceaccount.com
```

- Enable services

```sh
$ gcloud services enable   container.googleapis.com   iamcredentials.googleapis.com --project=<PROJECT_ID>
Operation "operations/acf.p2-672569518693-7d9f32cc-7475-4247-9793-7691024aab07" finished successfully.

```

- Create the GKE

`./create-gke.sh`

```sh
gcloud container clusters create gitops-gcp \
  --zone=asia-south2-a \
  --machine-type e2-medium \
  --num-nodes 1 \
  --workload-pool="${SA}.svc.id.goog"
```

__We will see the cluster like this__

THis command should be in a `.sh` file

```sh
gcloud container clusters create gitops-gcp \
  --zone=asia-south2-a \
  --machine-type e2-medium \
  --num-nodes 1 \
  --workload-pool="<PROJECT_ID>.svc.id.goog" \n 
  --project="$PROJECT_ID"
```

```sh
$ gcloud container clusters create gitops-gcp   --zone=asia-south2-a   --machine-type e2-medium   --num-nodes 1   --
workload-pool="<PROJECT_ID>.svc.id.goog" --project="$PROJECT_ID"
Note: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
Creating cluster gitops-gcp in asia-south2-a... Cluster is being health-checked (Kubernetes Control Plane is healthy)...done.                
Created [https://container.googleapis.com/v1/projects/<PROJECT-ID>/zones/asia-south2-a/clusters/gitops-gcp].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/asia-south2-a/gitops-gcp?project=
<PROJECT-ID>
CRITICAL: ACTION REQUIRED: gke-gcloud-auth-plugin, which is needed for continued use of kubectl, was not found or is not executable. Install g
ke-gcloud-auth-plugin for use with kubectl by following https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#inst
all_plugin
kubeconfig entry generated for gitops-gcp.
NAME        LOCATION       MASTER_VERSION      MASTER_IP       MACHINE_TYPE  NODE_VERSION        NUM_NODES  STATUS   STACK_TYPE
gitops-gcp  asia-south2-a  1.35.6-gke.1250000  34.131.207.220  e2-medium     1.35.6-gke.1250000  1          RUNNING  IPV4

```

- Install this plugin for gke

`sudo apt-get install google-cloud-cli-gke-gcloud-auth-plugin`

- connect to that cluster

```sh
$ gcloud container clusters get-credentials gitops-gcp --zone=asia-south2-a --project="$PID"
Fetching cluster endpoint and auth data.
kubeconfig entry generated for gitops-gcp.
```

- Unset the credentials

```sh
kubectl config unset current-context
Property "current-context" unset.
gitops-gcp$ kubectl config get-contexts
CURRENT   NAME                                          CLUSTER                                       AUTHINFO                                      NAMESPACE
          gke_<PROJECT_ID>_asia-south2-a_gitops-gcp   gke_<PROJECT_ID>_asia-south2-a_gitops-gcp   gke_<PROJECT_ID>_asia-south2-a_gitops-gcp   
          kind-gcp-gitops                               kind-gcp-gitops                               kind-gcp-gitops                               
          kind-helm-dev                                 kind-helm-dev                                 kind-helm-dev                                 
          kind-my-helm                                  kind-my-helm                                  kind-my-helm                                  
gitops-gcp$ kubectl config get-contexts
CURRENT   NAME                                          CLUSTER                                       AUTHINFO                                      NAMESPACE
          gke_<PROJECT_ID>_asia-south2-a_gitops-gcp   gke_<PROJECT_ID>_asia-south2-a_gitops-gcp   gke_<PROJECT_ID>_asia-south2-a_gitops-gcp   kind-gcp-gitops                               kind-gcp-gitops                               kind-gcp-gitops                               kind-helm-dev                                 kind-helm-dev                                 kind-helm-dev                                 kind-my-helm                                  kind-my-helm                                  kind-my-helm                                  gitops-gcp$ kubectl config delete-context gke_<PROJECT_ID>_asia-south2-a_gitops-gcp deleted context gke_<PROJECT_ID>_asia-south2-a_gitops-gcp from /home/atul/.kube/config
gitops-gcp$ kubectl config get-contexts
CURRENT   NAME              CLUSTER           AUTHINFO          NAMESPACE
          kind-gcp-gitops   kind-gcp-gitops   kind-gcp-gitops   
          kind-helm-dev     kind-helm-dev     kind-helm-dev     
          kind-my-helm      kind-my-helm      kind-my-helm      
gitops-gcp$ kubectl config current-context
error: current-context is not set
```

- Delete the cluster

`gcloud container clusters delete PROJECT-NAME`

- creating GKE

`./create-gke.sh`

```sh
$ ./create-gke.sh 
starting to create the gke cluster
Note: Your Pod address range (`--cluster-ipv4-cidr`) can accommodate at most 1008 node(s).
Creating cluster gitops-gcp in asia-south2-a... Cluster is being health-checked (Kubernetes Control Plane is healthy)...done.                                
Created [https://container.googleapis.com/v1/projects/<PROJECT_ID>/zones/asia-south2-a/clusters/gitops-gcp].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/asia-south2-a/gitops-gcp?project=<PROJECT_ID>
kubeconfig entry generated for gitops-gcp.
NAME        LOCATION       MASTER_VERSION      MASTER_IP      MACHINE_TYPE  NODE_VERSION        NUM_NODES  STATUS   STACK_TYPE
gitops-gcp  asia-south2-a  1.35.6-gke.1250000  34.126.214.89  e2-medium     1.35.6-gke.1250000  1          RUNNING  IPV4

```

__Check the nodes and pods there__

```sh
$ kubectl get nodes
NAME                                        STATUS   ROLES    AGE   VERSION
gke-gitops-gcp-default-pool-b51c77c0-vn8m   Ready    <none>   14m   v1.35.6-gke.1250000
$ kubectl get pods -A
NAMESPACE         NAME                                                   READY   STATUS    RESTARTS   AGE
gke-managed-cim   kube-state-metrics-0                                   2/2     Running   0          16m
gmp-system        collector-gf9qw                                        2/2     Running   0          14m
gmp-system        gmp-operator-7c57bcbd74-jd9gx                          1/1     Running   0          15m
kube-system       event-exporter-gke-7b96f8bbfb-p2z5n                    2/2     Running   0          16m
kube-system       fluentbit-gke-wvfd9                                    3/3     Running   0          14m
kube-system       gke-metadata-server-mmz62                              1/1     Running   0          14m
kube-system       gke-metrics-agent-69njw                                3/3     Running   0          14m
kube-system       konnectivity-agent-autoscaler-799f644d45-hv9qk         1/1     Running   0          15m
kube-system       konnectivity-agent-fcc4bbf5b-4xl2z                     2/2     Running   0          15m
kube-system       kube-dns-5dbb575698-sx2qh                              4/4     Running   0          16m
kube-system       kube-dns-autoscaler-54bfcb5447-9sp8h                   1/1     Running   0          15m
kube-system       kube-proxy-gke-gitops-gcp-default-pool-b51c77c0-vn8m   1/1     Running   0          14m
kube-system       l7-default-backend-67474877f5-qfhsh                    1/1     Running   0          15m
kube-system       metrics-server-v1.35.1-5f44d78b95-rck8c                1/1     Running   0          15m
kube-system       netd-dcq6g                                             3/3     Running   0          14m
kube-system       node-local-dns-xn24l                                   2/2     Running   0          14m
kube-system       pdcsi-node-qjcbh                                       3/3     Running   0          14m

```

- Installing ArgoCD

For details see [./Argocd-setup.md]()

`./install-argocd.sh`

I did the port forwarding using

`kubectl port-forward svc/argocd-server -n argocd 8080:443`

Next I got the password with

```sh
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

- enable the logs

  ```sh
  gcpdiag runbook gke/logs \
    --parameter project_id=PROJECT_ID \
    --parameter name=CLUSTER_NAME \
    --parameter location=LOCATION
  ```

- enable the cloud resource manager api
 `gcloud services enable cloudresourcemanager.googleapis.com`

- Add the argocd to the gke

 ```sh
 kubectl apply -f argocd/argocd-cm.yaml
 ```

- Restart the controller

```sh
kubectl rollout restart statefulset argocd-application-controller -n argocd
```

- Check the crossplane stable version

```sh
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
helm search repo crossplane-stable/crossplane --versions | head -10
```

- Apply the application file

```sh
$ kubectl apply -f argocd/application.yaml
application.argoproj.io/crossplane-bootstrap created
```
