#!/bin/bash

# NodeJS Config
#export CHROME_BIN=/usr/bin/chromium-browser
export CHROME_BIN=/usr/bin/google-chrome
export NODE_ENV=CI

# X Config
export XVFB_WHD=${XVFB_WHD:-1280x720x16}
export DISPLAY=:99
Xvfb :99 -ac -screen 0 $XVFB_WHD -nolisten tcp &

# start VNC for chrome debugging
x11vnc &

. ./config.sh --unattended --acceptteeeula --replace --url ${TFSURL} --auth PAT --token ${TFSTOKEN} --pool ${TFSPOOL} --agent ${TFSAGENT}
. ./run.sh;