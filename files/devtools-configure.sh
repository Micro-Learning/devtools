#!/bin/bash

set -e

echo "[devtools] - docker in docker"
sudo groupmod -g $(stat -c "%g" "/var/run/docker.sock") docker

echo "Please, restart the container"