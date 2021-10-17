echo "installing k3s..."

export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $1 --node-ip $1"

curl -sfL https://get.k3s.io | sh -

echo "copy node-token..."
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/scripts/

echo "create k3s alias"
echo "alias k=k3s" >> ~/.bashrc
echo "server installed"