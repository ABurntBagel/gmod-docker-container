#!/bin/bash
set -e

# Ensure script is executable
if [[ -f "include/entry.sh" ]]; then
  chmod +x include/entry.sh
fi

# Build the container
docker build -t gmod-server .

read -p "Build complete. Would you like to run the container? (y/n) " yn

case $yn in
  [yY] ) read -p "A GSLT token is required to run this server.
Please visit https://steamcommunity.com/dev/managegameservers to acquire an access token.
Provide your GSLT token and press [ENTER]: " gslt
    export GSLT_TOKEN="$gslt"
    include/run-container.sh "$gslt";;
  [nN] ) echo "Exiting. You may start the container at any time by running include/run-container.sh";
    exit;;
  * ) echo "Please answer y or n.";;

esac