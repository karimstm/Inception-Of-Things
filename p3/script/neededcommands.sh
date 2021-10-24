#!/bin/bash

echo "roming uneeded packages..."
yum -y remove podman
yum -y remove containers-common


# install docker
echo "Installing docker..."
yum install -y yum-utils

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce docker-ce-cli containerd.io

# start docker
echo "starting docker..."
systemctl start docker

# #add user to docker group
# usermod -aG docker ${USER}

# we might need to logout and login again

#install k3d
echo "instaling k3d wrapper..."
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
# k3d cluster create dev-cluster --port 8888:8888@loadbalancer 8080:80@loadbalancer --port 8443:443@loadbalancer
k3d cluster create --config ../config/k3d.yaml


echo "installing kubectl..."
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubectl


# we must for the jobs to finish
kubectl -n kube-system wait --for=condition=complete --timeout=-1s jobs/helm-install-traefik-crd


#set up argo
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f ../config/install.yaml


# Set up ingress
kubectl apply -n argocd -f ../config/ingress.yaml

# we need to wait for argo to be ready

kubectl apply -n argocd -f ../config/wils-Project.yaml
kubectl apply -n argocd -f ../config/wils-application.yaml



#this will help
#https://www.techmanyu.com/setup-a-gitops-deployment-model-on-your-local-development-environment-with-k3s-k3d-and-argocd-4be0f4f30820
