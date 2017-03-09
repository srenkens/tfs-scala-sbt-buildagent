#!/bin/bash
set -euo pipefail

# NodeJS Config
#export CHROME_BIN=/usr/bin/chromium-browser
export CHROME_BIN=/usr/bin/google-chrome
export NODE_ENV=CI



# start VNC for chrome debugging
x11vnc &

# Configure and Run the TFS Agent
. ./config.sh --unattended --acceptteeeula --replace --url ${TFSURL} --auth PAT --token ${TFSTOKEN} --pool ${TFSPOOL} --agent ${TFSAGENT}
. ./run.sh;