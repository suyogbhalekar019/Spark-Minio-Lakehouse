# Makefile for data-lakehouse-with-delta-lake-using-k8s (branch: branch)
# tweak

# Variables
# KUBE_NAMESPACE := lakehouse


# # Kubernetes deployment targets
namespace:
	sudo kubectl create namespace lakehouse

deploy-config-maps:
	sudo kubectl apply -f config/spark-master-configmap.yaml  
	sudo kubectl apply -f config/spark-notebook-configmap.yaml  

deploy-spark-notebook:
	sudo kubectl apply -f volumes/notebooks-pv.yaml  
	sudo kubectl apply -f volumes/notebooks-pvc.yaml  
	sudo kubectl apply -f deployments/spark-notebook-deployment.yaml  
	sudo kubectl apply -f services/spark-notebook-service.yaml  

deploy-spark-master:
	sudo kubectl apply -f deployments/spark-master-deployment.yaml  
	sudo kubectl apply -f services/spark-master-service.yaml  

deploy-spark-workers:
	sudo kubectl apply -f deployments/spark-worker-1-deployment.yaml  
	sudo kubectl apply -f deployments/spark-worker-2-deployment.yaml  

deploy-minio:
	sudo kubectl apply -f volumes/minio-pv.yaml  
	sudo kubectl apply -f volumes/minio-pvc.yaml  
	sudo kubectl apply -f deployments/minio-deployment.yaml  
	sudo kubectl apply -f deployments/minio-client-deployment.yaml  
	sudo kubectl apply -f services/minio-service.yaml  
	

deploy-all: deploy-config-maps deploy-spark-notebook deploy-spark-master deploy-spark-workers deploy-minio

# Port forwarding - needed only when services are defined as a ClusterIP
# port-forward:
# 	sudo kubectl port-forward svc/spark-notebook 8888:8888 -n lakehouse  --address 0.0.0.0
# 	sudo kubectl port-forward svc/spark-master 8080:8080 -n lakehouse --address 0.0.0.0
# 	sudo kubectl port-forward svc/minio 9001:9001 -n lakehouse --address 0.0.0.0

# Clean up targets
clean-all: 
	sudo kubectl delete namespace lakehouse
	sudo kubectl delete pv notebooks-pv  
	sudo kubectl delete pv minio-pv  
