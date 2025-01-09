#!/bin/bash

GSLT_TOKEN="$1"

#Check for token
if [ -z "$GSLT_TOKEN" ]; then
  echo "A GSLT token is required to run this server."
  echo "Please visit https://steamcommunity.com/dev/managegameservers to acquire an access token."
  echo "Provide your GSLT token and press [ENTER]: "
  read -r GSLT_TOKEN
fi

docker run -it \
  -p 27015:27015/udp \
  -p 27015:27015/tcp \
  -p 27005:27005/udp \
  -e PUID=1000 \
  -e PGID=1000 \
  -v ${HOME}/Documents/server/garrysmod:/home/steam/garrysmod:rw \
  -v ${HOME}/Documents/server/css:/home/steam/css:rw \
  -e GMOD_SERVERNAME="My Gmod Server" \
  -e GMOD_GAMEMODE="dionysus" \
  -e GMOD_MAP="gm_construct" \
  -e GMOD_MAXPLAYERS=16 \
  -e GMOD_GSLT="$GSLT_TOKEN" \
  -e GMOD_ADDITIONAL_ARGS="" \
gmod-server