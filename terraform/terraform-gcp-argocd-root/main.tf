terraform { 
  cloud { 
    
    organization = "vladbuk-inc" 

    workspaces { 
      name = "learning-gcp-argocd-root" 
    } 
  } 
}

provider "google" {
  project = "kuber-430607"
  region  = "us-east1"
  zone    = "us-east1-b"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "k8s"
}

variable "cluster_location" {
  description = "The location of the GKE cluster"
  type        = string
  default     = "us-east1-b"
}

variable "eks_cluster_name" {
  description = "EKS Cluster name to deploy ArgoCD ROOT Application"
  type        = string
}

variable "git_source_repoURL" {
  description = "GitSource repoURL to Track and deploy to EKS by ROOT Application"
  type        = string
  default = "git@github.com:vladbuk/argocd.git"
}

variable "git_source_path" {
  description = "GitSource Path in Git Repository to Track and deploy to EKS by ROOT Application"
  type        = string
  default     = "argocd/applications"
}

variable "git_source_targetRevision" {
  description = "GitSource HEAD or Branch to Track and deploy to EKS by ROOT Application"
  type        = string
  default     = "HEAD"
}


data "google_client_config" "default" {}

data "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location
}


provider "kubernetes" {
    host                   = data.google_container_cluster.primary.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  }

resource "kubernetes_manifest" "argocd_root" {
  manifest = yamldecode(templatefile("${path.module}/root.yaml", {
    path           = var.git_source_path
    repoURL        = var.git_source_repoURL
    targetRevision = var.git_source_targetRevision
  }))
}