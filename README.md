
MLflow Deployment and Access Guide

1. MLflow Deployment YAML File

apiVersion: apps/v1
kind: Deployment
metadata:
  name: mlflow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mlflow
  template:
    metadata:
      labels:
        app: mlflow
    spec:
      containers:
      - name: mlflow
        image: mlflow:1.0.0
        imagePullPolicy: Never
        ports:
        - containerPort: 5000

2. MLflow Service YAML File

apiVersion: v1
kind: Service
metadata:
  name: mlflow
spec:
  selector:
    app: mlflow
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
  type: NodePort
  
  
  

3. Dockerfile to Build mlflow:1.0.0 Image

FROM python:3.10-slim-bullseye

RUN apt-get update -y

# Best practice: Create a non-root user to run processes.
RUN useradd -rm -d /home/mlflow -s /bin/bash -g root -G sudo -u 1001 mlflow
USER mlflow
WORKDIR /home/mlflow

ENV PATH="/home/mlflow/.local/bin:${PATH}"

RUN pip install psycopg2-binary==2.9.6 \
                prometheus_flask_exporter==0.22.4 \
                boto3==1.26.146
    
RUN pip install --no-cache mlflow==2.5.0




4. Steps to Deploy and Access MLflow

Step 1: Build the Docker Image

docker build -t mlflow:1.0.0 .

Step 2: Apply Deployment and Service

kubectl apply -f mlflow-deployment.yaml
kubectl apply -f mlflow-service.yaml

Step 3: Get NodePort and Access MLflow

kubectl get svc mlflow

Example output:

NAME     TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
mlflow   NodePort   10.107.14.6     <none>        80:30202/TCP   76s

If using Minikube, get the service URL:

minikube service mlflow --url

If running on a local Kubernetes cluster, find the NodePort and use the internal IP:

kubectl get nodes -o wide

Example output:

NAME       STATUS   ROLES           INTERNAL-IP    EXTERNAL-IP
minikube   Ready    control-plane   192.168.49.2   <none>

Now, access MLflow using:

http://192.168.49.2:30202

Step 4: Port Forwarding (If Needed)

If the NodePort is not accessible, use port forwarding:

kubectl port-forward svc/mlflow 5000:80

Now, access MLflow at:

http://localhost:5000

This guide ensures a smooth MLflow deployment with Kubernetes! 
