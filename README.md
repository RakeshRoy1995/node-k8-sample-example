1. minikube start // kubectl is now configured to use "minikube" cluster and "default" namespace by default
2. kubectl cluster-info // Kubernetes control plane is running at https://127.0.0.1:52120
3. kubectl get nodes // to see my nodes . if ready then ok
4. minikube docker-env // Use Minikube Docker
5. kubectl apply -f .\k8s\deployment.yaml // to run the pods [Kubernetes Deployment]
6. kubectl get pods // see the pods running
7. Expose App : kubectl apply -f .\k8s\service.yaml
8. minikube service node-service // Access app
9. minikube dashboard // K8s dashboard access 
