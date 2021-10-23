# install docker
sudo yum install -y yum-utils

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce docker-ce-cli containerd.io

# start docker
sudo systemctl start docker

#add user to docker group
sudo usermod -aG docker ${USER}

# we might need to logout and login again


#install k3d
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
k3d cluster create dev-cluster --port 8080:80@loadbalancer --port 8443:443@loadbalancer

#set up argo
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f /vagrant/config/install.yaml
kubectl apply -n argocd -f /vagrant/config/ingress.yaml

#this will help
#https://www.techmanyu.com/setup-a-gitops-deployment-model-on-your-local-development-environment-with-k3s-k3d-and-argocd-4be0f4f30820
