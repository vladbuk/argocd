module "argocd" {
  source = "./terraform-gcp-argocd"
  cluster_name = "k8s"
}