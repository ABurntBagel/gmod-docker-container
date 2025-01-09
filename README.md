# Garry's Mod Docker Server

This Docker image provides a Garry's Mod dedicated server that's easy to set up and configure.

## Requirements


- [Docker Engine installed and running (version 20.10.0 or higher recommended)](https://docs.docker.com/engine/install/)
- [Valid Steam account (for GSLT token if running a public server)](https://steamcommunity.com/dev/managegameservers)
- Ports forwarded and publicly accessible
  - 27015 (UDP/TCP): Main game port
  - 27005 (UDP): Client port

## Usage

### Quick-Start
The fastest way to get started is to use the pre-compiled bash scripts included in this repo. Building the image as-is will use the default settings in the Dockerfile. I recommend modifying and utilizing the run-container.sh file when re-building your image. I explain in detail in another section below.

1. Start by running the `./build.sh` script. This will run the `docker build` command while ensuring required files have correct permissions.
```bash
./build.sh
```
2. You will be prompted to run the container. Select `Y` to load the default container.

3. You are required to provide a GSLT for your server to be publicly accessible.
```bash
Build complete. Would you like to run the container? (y/n) y
A GSLT token is required to run this server.
Please visit https://steamcommunity.com/dev/managegameservers to acquire an access token.
Provide your GSLT token and press [ENTER]: 
```
Note: By default, the container will run in an integrated terminal. To change this, modify `include/run-container.sh`:
```
docker run -it \
```
change to:
```
docker run -d \
```
4. Congratulations! Your server is now running!

### Configuring the Server
I recommend modifying the run-container.sh file with your desired parameters directly. This saves time and headache when it comes to re-running the container multiple times.

Basic usage:
```bash
docker run -it \
  -p 27015:27015/udp \
  -p 27015:27015/tcp \
  -p 27005:27005/udp \
  -e GMOD_GSLT="$GSLT_TOKEN" 
gmod-server
```
This is the minimum arguments required to run a publicly accessible Garry's Mod server.

### Volumes
By default, I have configured 2 volumes as the server also downloads Counter Strike: Source content. If you are planning to have data that must be persistent, ensure the volumes are set in the `docker run` command.
```bash
docker run -it \
  -p 27015:27015/udp \
  -p 27015:27015/tcp \
  -p 27005:27005/udp \
  -e PUID=1000 \
  -e PGID=1000 \- 27020 (UDP): SRCDS TV port
  -v ${HOME}/Documents/server/garrysmod:/home/steam/garrysmod:rw \
  -v ${HOME}/Documents/server/css:/home/steam/css:rw \
  -e GMOD_GSLT="$GSLT_TOKEN" \
gmod-server
```
By default, these volumes point to the home directory, typcally `/home/<USERNAME>/`.
- PUID and PGID are required to allow Docker to access files in your home directory.
- Do not modify the Docker mount path unless you know what you are doing.

### Environment Variables

You can customize the server by setting these environment variables when running the container:

- `GMOD_SERVERNAME`: Server name in the browser (default: Garry's Mod Server)
- `GMOD_MAXPLAYERS`: Maximum number of players (default: 16)
- `GMOD_GAMEMODE`: Server gamemode (default: sandbox)
- `GMOD_MAP`: Server map (default: gm_construct)
- `GMOD_WORKSHOP_COLLECTION`: Steam Workshop collection ID for automatically subscribing to addons (default: empty)
- `GMOD_PORT`: Main server port for game traffic (default: 27015)
- `GMOD_CLIENT_PORT`: Client connection port (default: 27005)
- `GMOD_GSLT`: Game Server Login Token required for public servers. Get one at https://steamcommunity.com/dev/managegameservers
- `GMOD_ADDITIONAL_ARGS`: Additional command-line arguments to pass to the server
  - [Valve command line arguments](https://developer.valvesoftware.com/wiki/Command_line_options)
  - [Garry's Mod specific arguments](https://wiki.facepunch.com/gmod/Command_Line_Parameters)
- `PUID`: User ID for file permissions when using volumes (default: 1000)
- `PGID`: Group ID for file permissions when using volumes (default: 1000)

Example with custom settings:
```bash
docker run -d \
  -p 27015:27015/udp \
  -p 27015:27015/tcp \
  -p 27005:27005/udp \
  -e PUID=1000 \
  -e PGID=1000 \
  -v ${HOME}/Documents/server/garrysmod:/home/steam/garrysmod:rw \
  -v ${HOME}/Documents/server/css:/home/steam/css:rw \
  -e GMOD_SERVERNAME="My Awesome TTT Server" \
  -e GMOD_GAMEMODE="terrortown" \
  -e GMOD_MAP="ttt_minecraftcity_v4" \
  -e GMOD_MAXPLAYERS=16 \
  -e GMOD_GSLT="$GSLT_TOKEN" \
  -e GMOD_ADDITIONAL_ARGS="" \
gmod-server
```

## Ports

The server requires the following ports:
- 27015 (UDP/TCP): Main game port
- 27005 (UDP): Client port