#!/bin/bash

set -euo pipefail

. ./config.sh

if [[ "$(hostname -s)" != "server0" ]]; then
    echo "This script has to run on server0"
    exit 1
fi

install_docker() {
    local host="$1"

    ssh -oStrictHostKeyChecking=no "$host" '
        set -e
        if ! command -v docker >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y docker.io
            sudo systemctl enable --now docker
        else
            sudo systemctl enable --now docker || true
        fi
    '
}

for i in $(seq 0 $((n_servers - 1))); do
    install_docker "server$i" &
done
wait

IP="$(ip -4 addr show | awk '/10\.10\./ {print $2}' | head -n1 | cut -d/ -f1)"

if [[ -z "${IP}" ]]; then
    echo "Error: could not determine 10.10.x.x address on server0" >&2
    exit 1
fi

if ! sudo docker info >/dev/null 2>&1; then
    echo "Error: docker is not running on server0" >&2
    exit 1
fi

if ! sudo docker node ls >/dev/null 2>&1; then
    sudo docker swarm init --advertise-addr "$IP"
fi

JOIN_COMMAND="$(sudo docker swarm join-token worker -q)"
if [[ -z "${JOIN_COMMAND}" ]]; then
    echo "Error: failed to get swarm join token" >&2
    exit 1
fi

for i in $(seq 1 $((n_servers - 1))); do
    ssh -oStrictHostKeyChecking=no "server$i" "
        set -e
        sudo docker swarm leave --force >/dev/null 2>&1 || true
        sudo docker swarm join --token ${JOIN_COMMAND} ${IP}:2377
    " &
done
wait

sudo docker node ls