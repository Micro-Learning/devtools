#!/bin/bash

echo developer | sudo -S /usr/local/bin/wrapdocker.sh

exec "$@"
