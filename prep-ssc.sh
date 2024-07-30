#!/usr/bin/env sh
# This is run in the image before running the main setup script.

sudo rm -rf seestar_alp
sudo chown -R $(whoami): .
