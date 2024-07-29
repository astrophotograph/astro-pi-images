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

mkdir -p dist
cd dist

TARGET=seestar_alp_$(date +"%Y%m%d").img
IMAGE=2024-07-04-raspios-bookworm-arm64-lite.img
/bin/rm -f $TARGET

wget https://raw.githubusercontent.com/smart-underworld/seestar_alp/main/raspberry_pi/setup_unified.sh
chmod 755 setup_unified.sh

sudo sdm --extend --xmb 4096 $IMAGE

sudo sdm \
    --customize \
    --expand-root \
    --plugin L10n:host \
    --plugin disables:piwiz \
    --plugin runscript:"runphase=post-install|dir=/home/pi|script=setup_unified.sh|user=pi" \
    --regen-ssh-host-keys \
    --restart $IMAGE

#    --plugin raspiconfig:overlayfs \

sudo sdm --burnfile $TARGET $IMAGE
