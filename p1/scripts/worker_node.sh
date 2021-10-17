echo "Fetching binary file..."
sudo curl -L -o k3s https://github.com/k3s-io/k3s/releases/download/v1.22.2%2Bk3s2/k3s
sudo chmod 755 k3s

export TOKEN_FILE="/vagrant/scripts/node-token"
export MASTER_IP="$1"
export INTERNAL_IP="$2"

echo "Running agent..."

sudo ./k3s agent --node-ip ${INTERNAL_IP} --server https://${MASTER_IP}:6443 --token-file ${TOKEN_FILE} >& k3s-agent.log &

echo "installing ifconfig"
sudo yum install net-tools -y

echo "create k3s alias"
echo "alias k=$PWS/k3s" >> ~/.bashrc

echo "Done..."
