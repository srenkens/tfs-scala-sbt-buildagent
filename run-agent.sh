#!/bin/bash
set -euo pipefail # Strict mode on

# NodeJS Config
export CHROME_BIN=/usr/bin/google-chrome
export NODE_ENV=CI


# start VNC for chrome debugging
x11vnc &


# Configure and Run the TFS Agent
set +u # Allows unset variables (the env.sh script of the buildagent failes at this part)
. ./config.sh --unattended --acceptteeeula --replace --url ${TFSURL} --auth PAT --token ${TFSTOKEN} --pool ${TFSPOOL} --agent ${TFSAGENT}
set -u # Strict mode on
. ./run.sh;