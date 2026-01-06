# =========================================
# PowerShell Script: update-node-app.ps1
# Purpose: Build Docker image, update Kubernetes Deployment, wait for pods
# Works with Docker Desktop Kubernetes
# =========================================

$namespace = "default"           # Kubernetes namespace
$deployment = "node-deployment"  # Deployment name
$imageName = "k8s-node-app"      # Docker image name
$imageTag = "v2"                 # Image version tag
$containerName = "node"          # Container name inside Deployment
$imagePullPolicy = "Never"       # Set to "Always" if using Docker Hub

# Full image string
$imageFull = "${imageName}:${imageTag}"

# Step 1: Build Docker image
Write-Host "Building Docker image $imageFull ..."
docker build -t $imageFull .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed!" -ForegroundColor Red
    exit
}

# Step 2: Check if Deployment exists
$deployCheck = kubectl get deployment $deployment -n $namespace --ignore-not-found

if (-not $deployCheck) {
    Write-Host "Deployment not found. Creating Deployment..."
    kubectl apply -f deployment.yaml
} else {
    Write-Host "Deployment found. Updating image..."
    kubectl set image deployment/$deployment $containerName=$imageFull -n $namespace
}

# Step 3: Restart pods if using local image
if ($imagePullPolicy -eq "Never") {
    Write-Host "Restarting pods to use local image..."
    kubectl delete pod -l app=node -n $namespace
}

# Step 4: Wait for rollout to complete
Write-Host "Waiting for pods to be ready..."
Start-Sleep -Seconds 5
kubectl rollout status deployment/$deployment -n $namespace

# Step 5: Show pod status
Write-Host "Pods status:"
kubectl get pods -n $namespace

Write-Host "Update complete! Access your app via NodePort service."
