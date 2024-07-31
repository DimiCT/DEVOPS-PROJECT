

terraform {
  backend "s3" {
    bucket = "terraform-state-awake"
    key = "eks/ngg_cluster_name/statefile"
    region = "eu-west-1"
  }
} 
