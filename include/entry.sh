#!/bin/bash

# ========================================= #
#           DO NOT MODIFY THIS FILE         #
# ========================================= #

set -e

echo "Starting Garry's Mod server setup..."

# Ensure required directories exist
mkdir -p "$(dirname "${MOUNTCFG}")"

# Update Garry's Mod
echo "Updating Garry's Mod..."
${STEAMCMDDIR}/steamcmd.sh +login anonymous \
 +force_install_dir ${GMODDIR} +app_update ${GMODID} validate +quit

# Update other game content
echo "Updating CSS..."
${STEAMCMDDIR}/steamcmd.sh +login anonymous \
    +force_install_dir ${CSSDIR} +app_update ${CSSID} validate +quit
echo "Updating TF2..."
${STEAMCMDDIR}/steamcmd.sh +login anonymous \
    +force_install_dir ${TF2DIR} +app_update ${TF2ID} validate +quit

# Mount other game content
echo "Configuring mount points..."
if [ -f "${MOUNTCFG}" ]; then
    # Create backup of existing mount.cfg
    cp "${MOUNTCFG}" "${MOUNTCFG}.bak"
    
    # Update mount points safely
    if ! grep -q '"cstrike"\s"'"${CSSDIR}"'/cstrike"' "${MOUNTCFG}"; then
        echo "Adding CSS mount point..."
        sed -i.tmp '/"cstrike"/d' "${MOUNTCFG}"
        sed -i.tmp '/^\s*}/ i 	"cstrike"	"'"${CSSDIR}"'/cstrike"' "${MOUNTCFG}"
        rm -f "${MOUNTCFG}.tmp"
    fi
    
    if ! grep -q '"tf"\s"'"${TF2DIR}"'/tf"' "${MOUNTCFG}"; then
        echo "Adding TF2 mount point..."
        sed -i.tmp '/"tf"/d' "${MOUNTCFG}"
        sed -i.tmp '/^\s*}/ i 	"tf"	"'"${TF2DIR}"'/tf"' "${MOUNTCFG}"
        rm -f "${MOUNTCFG}.tmp"
    fi
else
    echo "Creating new mount.cfg..."
    cp mount.cfg "${MOUNTCFG}"
fi

# Ensure proper permissions after modifications
chmod 644 "${MOUNTCFG}"

# Start Server
ARGS="-steam_dir ${STEAMCMDDIR} \
    -steamcmd_script /home/steam/autoupdatescript.txt \
    -autoupdate \
    -debug \ 
    +hostname \"${GMOD_SERVERNAME}\" \ 
    +maxplayers ${GMOD_MAXPLAYERS} \
    +map ${GMOD_MAP} \
    +gamemode ${GMOD_GAMEMODE}"

if [ -n "${GMOD_WORKSHOP_COLLECTION}" ]; then
    ARGS="${ARGS} +host_workshop_collection ${GMOD_WORKSHOP_COLLECTION}"
fi

if [ -n "${GMOD_WORKSHOP_AUTHKEY}" ]; then
    ARGS="${ARGS} -authkey ${GMOD_WORKSHOP_AUTHKEY}"
fi

if [ -n "${GMOD_SV_PASSWORD}" ]; then
    ARGS="${ARGS} +sv_password ${GMOD_SV_PASSWORD}"
fi

if [ -n "${GMOD_RCON_PASSWORD}" ]; then
    ARGS="${ARGS} +rcon_password ${GMOD_RCON_PASSWORD}"
fi

if [ -n "${GMOD_GSLT}" ]; then
    ARGS="${ARGS} +sv_setsteamaccount ${GMOD_GSLT}"
fi

ARGS="${ARGS} -port ${GMOD_PORT} -clientport ${GMOD_CLIENT_PORT} ${GMOD_ADDITIONAL_ARGS}"

exec ${GMODDIR}/srcds_run ${ARGS}