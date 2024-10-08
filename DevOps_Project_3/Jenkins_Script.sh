#!/bin/bash
set -ex


export TF_VAR_region=$REGION
export TF_VAR_vpc_id=$VPC_ID
export TF_VAR_cluster_name=$CLUSTER_NAME

#goint to the terraform path
cd "/var/lib/jenkins/workspace/awake/Terraform"

#replacing the cluster name field in backend.tf file
sed -i "s/ngg_cluster_name/$CLUSTER_NAME/g" backend.tf

#running terraform command
terraform init    
terraform plan
terraform $ACTION --auto-approve

if [ $ACTION == "apply" ]; then
#login into the eks cluster
aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION
kubectl get pods -A

# installing bitnami helm chart
 helm repo add bitnami https://charts.bitnami.com/bitnami

#installing eks helm chart
helm repo add eks https://aws.github.io/eks-charts


# Add Helm repositories
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo add eks https://aws.github.io/eks-charts

# Update Helm repositories
    helm repo update



#installing nginx
helm upgrade --install nginx bitnami/nginx

# Install/upgrade NGINX using Helm
    helm upgrade --install nginx bitnami/nginx



#installing aws loadbalancer controller
helm upgrade --install lb-controller eks/aws-load-balancer-controller --set clusterName=$CLUSTER_NAME

 # Install/upgrade AWS Load Balancer Controller using Helm
    helm upgrade --install lb-controller eks/aws-load-balancer-controller --set clusterName=$CLUSTER_NAME


# Install Esthesis using Helm (assuming Esthesis uses bitnami/nginx chart)
    #helm upgrade --install esthesis bitnami/nginx --namespace esthesis-namespace --create-namespace

else
echo "no need to install, action is $ACTION"
fi
