FROM cm2network/steamcmd:root

LABEL maintainer="https://github.com/ABurntBagel/gmod-docker-container"

###########################################################
#                DEFAULT ENVIRONMENT VARIABLES            #
###########################################################
#   >>> DO NOT MODIFY THESE VARIABLES UNLESS YOU KNOW     #
#       WHAT YOU'RE DOING <<<                             #
###########################################################
ENV GMODID=4020 \
    GMODDIR=/home/steam/garrysmod \
    CSSID=232330 \
    CSSDIR=/home/steam/css \
    TF2ID=232250 \
    TF2DIR=/home/steam/tf2 \
    SERVERCFG=/home/steam/garrysmod/garrysmod/cfg/server.cfg \
    MOUNTCFG=/home/steam/garrysmod/garrysmod/cfg/mount.cfg \
    PUID=1000 \
    PGID=1000
###########################################################

###########################################################
#                DEFAULT STARTUP ARGUMENTS                #
###########################################################
ENV GMOD_SERVERNAME="Garry's Mod Server" \
    GMOD_MAXPLAYERS=16 \
    GMOD_GAMEMODE="sandbox" \
    GMOD_MAP="gm_construct" \
    GMOD_WORKSHOP_COLLECTION="" \
    GMOD_PORT=27015 \
    GMOD_CLIENT_PORT=27005 \
    GMOD_GSLT="" \
    GMOD_ADDITIONAL_ARGS=""
###########################################################
WORKDIR /home/steam/

COPY --chown=steam include/mount.cfg include/autoupdatescript.txt ./
COPY --chown=steam include/entry.sh .
RUN chmod a+rx entry.sh

USER steam
ENTRYPOINT ["./entry.sh"]

# Expose ports
EXPOSE ${GMOD_PORT}/udp \
    ${GMOD_PORT}/tcp \
    ${GMOD_CLIENT_PORT}/tcp \
    ${GMOD_CLIENT_PORT}/udp
VOLUME ${GMODDIR} ${CSSDIR}
