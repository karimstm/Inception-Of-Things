echo "installing k3s..."

export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $1 --node-ip $1 --flannel-iface=eth1"

curl -sfL https://get.k3s.io | sh -

echo "create k3s alias"
echo 'alias k="k3s kubectl"' >> /home/vagrant/.bashrc
echo 'alias kubectl="k3s kubectl"' >> /home/vagrant/.bashrc
echo "server installed"

echo "Creating 3 deployments...."
/usr/local/bin/kubectl apply -f /vagrant/config/k3s/deployments/
echo "Creating 3 services...."
/usr/local/bin/kubectl apply -f /vagrant/config/k3s/services/
echo "Creating ingress Route...."
/usr/local/bin/kubectl apply -f /vagrant/config/k3s/Ingress/apps-ingress.yaml

echo "Happy Hacking!"