### STEP1: aws configure , install kubectl, helmcharts and EKS cluster

### STEP2: Authenticate the EKS cluster using .Kubeconfig file
CMD: aws eks update-kubeconfig --region <region> --name <cluster_name>
  #### verify EKS Cluster Conenctivity
CMD: kubectl get nodes


### STEP3: AWS EKS HELMCHARTS IAM Prmissions 
2. Configure IAM Roles for EKS and Helm
Create an IAM Role for EKS Node Groups: Attach the following policies to the role:

AmazonEKSWorkerNodePolicy
AmazonEC2ContainerRegistryReadOnly
AmazonEKS_CNI_Policy
Use this role when creating node groups.

Grant IAM Permissions for Helm:

Attach the following policies to your AWS user or role:
AmazonEKSClusterPolicy
AmazonEKSServicePolicy
AmazonEC2ContainerRegistryFullAccess (for ECR image access).
Enable aws-auth ConfigMap: Map your IAM role to Kubernetes RBAC:

bash
Copy code
kubectl edit configmap aws-auth -n kube-system
Add:

yaml
Copy code
mapRoles:
- rolearn: arn:aws:iam::<account_id>:role/<role_name>
  username: eks-user
  groups:
  - system:masters


## Step4: Now create helmcharts and update with required updates and configurations

### Step5: Push the docker images to ECR repo or Docker Repo Sources

### STEP6: Start Deploying the hemlmcharts
	cmd: helm package .
	cmd: helm install mlflow ./mlflow

### STEP7: Verify the Deployment pods and services..
 CMD: kubectl get pods &&& kubectl get svc
  # to manage helm charts && Rollback commands  &&& Uninstall HelmCharts
 cmd: helm upgrade mlflow ./mlflow
 cmd: helm rollback mlflow <revision_number>
 cmd: helm uninstall mlflow
  # For any update update the helmcharts and start deploying using helmupgrade commands and verify deployments.



