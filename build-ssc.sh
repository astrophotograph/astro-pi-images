#!/usr/bin/env sh
#
# Generate images for Seestar ALP / Simple Seestar Controller
#
# Base images:
# - raspios_lite_armhf (32-bit)
# - raspios_lite_arm64 (64-bit)
#
# Images sourced from https://downloads.raspberrypi.org//?C=M;O=D
#
# Includes:
# - https://github.com/smart-underworld/seestar_alp
#

IMAGE=${1:=2024-07-04-raspios-bookworm-arm64-lite.img}
BASE=$( basename $IMAGE .img )
TARGET=seestar_alp_${BASE}_$(date +"%Y%m%d").img
SETUP=setup_unified.sh

/bin/rm -f $TARGET

if [[ ! -e $IMAGE ]]; then
    echo "$IMAGE not found"
    exit 1
fi

wget https://raw.githubusercontent.com/smart-underworld/seestar_alp/main/raspberry_pi/${SETUP}
chmod 755 ${SETUP}

sudo sdm --extend --xmb 4096 $IMAGE

sudo sdm \
    --customize \
    --expand-root \
    --plugin L10n:host \
    --plugin disables:piwiz \
    --plugin runscript:"runphase=post-install|dir=/home/pi|script=prep-ssc.sh|user=pi" \
    --plugin runscript:"runphase=post-install|dir=/home/pi|script=${SETUP}|user=pi" \
    --regen-ssh-host-keys \
    --restart $IMAGE

#    --plugin raspiconfig:overlayfs \

sudo sdm --burnfile $TARGET $IMAGE
sudo sdm --shrink $TARGET
xz -v $TARGET
