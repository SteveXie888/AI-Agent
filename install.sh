#!/bin/bash

#先安裝docker ollama 和 open web ui
sudo yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker
sudo systemctl enable docker
sudo yum install epel-release -y
sudo sudo amazon-linux-extras install epel -y
sudo yum install jq -y
sudo curl -fsSL https://ollama.com/install.sh | sh
# GPU supported
# sudo docker run -d --network=host --gpus=all -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama
# CPU supported
sudo docker run -d --network=host -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama
sudo chmod 755 ~/.@@.sh

# add hot key to home folder's .bashrc
if [ $(cat ~/.bashrc | grep @@.sh | wc -l) -eq 0 ]; then
    echo alias @=\'~/.@@.sh\' >>~/.bashrc
fi

# curl http://localhost:11434/api/create -d '{
#   "name": "aiagent111",
#   "modelfile": "FROM llama3 PARAMETER temperature 1 PARAMETER num_ctx 4096 PARAMETER num_thread 8"
# }'
