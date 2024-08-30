# Argocd terraform install

### To create gke cluster use gcloud command

```
gcloud container clusters create k8s --machine-type n1-standard-1 --num-nodes 2 --network cluster-network
```

### Then you can deploy argocd to cluster

```
# terraform login # It's for use HCP cloud state storage
cd terraform-gcp-arg/
terraform init
terraform plan
terraform apply
```