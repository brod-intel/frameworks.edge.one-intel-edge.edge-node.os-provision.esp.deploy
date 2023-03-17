#!/bin/bash

GIT_TOKEN=$1

if [[ $(id -u) -ne 0 ]]; then
    echo -e "\e[1m\e[31;1m Please run this script as root or with sudo \e[0m"
    exit 1
fi

if [ -z ${GIT_TOKEN} ]; then
    echo -e "\e[1m\e[31;1m Please provide your Github developer token that has access to https://github.com/intel-innersource/frameworks.edge.one-intel-edge.edge-node.os-provision.esp.profile.ubuntu.  Re-run this command like the following: {$0} token_exampl-af98kajh98haieuha4987hrfau4iofha47fha \e[0m"
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo -e "\e[1m\e[31;1m Please install docker! \e[0m"
    exit 1
fi

if ! command -v docker-compose >/dev/null 2>&1; then
    echo -e "\e[1m\e[31;1m Installing docker-compose.! \e[0m"
    wget -O /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" && \
    chmod a+x /usr/local/bin/docker-compose
fi

mkdir -p /opt/esp/conf && \
cd /opt/esp && \
wget -qO /opt/esp/docker-compose.yml https://raw.githubusercontent.com/brod-intel/frameworks.edge.one-intel-edge.edge-node.os-provision.esp.deploy/main/docker-compose.yml && \
wget -qO /opt/esp/conf/config.yml https://raw.githubusercontent.com/brod-intel/frameworks.edge.one-intel-edge.edge-node.os-provision.esp.deploy/main/config.yml && \
set -i 's/XXXXXXXX/${GIT_TOKEN}/g' /opt/esp/conf/config.yml && \
mkdir .git && \
docker-compose up -d && \
./build.sh -S -i LP_Ubuntu_22.04
