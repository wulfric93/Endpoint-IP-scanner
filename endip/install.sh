#!/bin/bash

# Colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
rest='\033[0m'

# Static endpoints (merged provided IPv4 and IPv6 addresses)
STATIC_ENDPOINTS=(
    "162.159.192.19:1701"
    "188.114.98.61:955"
    "188.114.96.137:988"
    "188.114.99.66:4198"
    "188.114.99.212:1074"
    "188.114.98.224:4500"
    "188.114.98.224:878"
    "188.114.98.224:1387"
    "188.114.98.224:3476"
    "188.114.98.224:500"
    "188.114.98.224:2371"
    "188.114.98.224:1070"
    "188.114.98.224:854"
    "188.114.98.224:864"
    "188.114.98.224:939"
    "188.114.98.224:2408"
    "188.114.98.224:908"
    "162.159.192.121:2371"
    "188.114.96.145:1074"
    "188.114.98.0:878"
    "188.114.98.228:878"
    "188.114.99.0:878"
    "188.114.98.224:1074"
    "162.159.195.238:7156"
    "188.114.98.224:894"
    "188.114.96.191:3854"
    "188.114.99.53:890"
    "188.114.96.157:890"
    "188.114.96.6:890"
    "188.114.99.137:968"
    "188.114.96.239:1387"
    "8.34.146.47:864"
    "8.35.211.119:500"
    "8.34.70.34:1002"
    "8.34.70.82:988"
    "8.34.146.156:2408"
    "8.39.204.244:3476"
    "8.35.211.140:7156"
    "8.34.146.37:3854"
    "[2606:4700:d1::58a8:0f84:d37f:90e7]:7559"
    "[2606:4700:d1::1665:bab6:7ff1:a710]:878"
    "[2606:4700:d0::6932:d526:67b7:77ce]:890"
    "[2606:4700:d1::9eae:b:2754:6ad9]:1018"
)

# Determine CPU architecture
case "$(uname -m)" in
    x86_64 | x64 | amd64) cpu=amd64 ;;
    i386 | i686) cpu=386 ;;
    armv8 | armv8l | arm64 | aarch64) cpu=arm64 ;;
    armv7l) cpu=arm ;;
    *) echo "The current architecture is $(uname -m), not supported"; exit ;;
esac

# Download warpendpoint binary
cfwarpIP() {
    if [[ ! -f "$PREFIX/bin/warpendpoint" ]]; then
        echo "Downloading warpendpoint program"
        if [[ -n $cpu ]]; then
            curl -L -o warpendpoint -# --retry 2 https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/$cpu
            cp warpendpoint $PREFIX/bin
            chmod +x $PREFIX/bin/warpendpoint
        fi
    fi
}

# Generate or use static IPv4 endpoints
endipv4() {
    n=0
    iplist=100
    # First, add static IPv4 endpoints
    for endpoint in "${STATIC_ENDPOINTS[@]}"; do
        if [[ $endpoint != *:*::* ]]; then # Filter out IPv6
            temp[$n]=$endpoint
            n=$(($n + 1))
        fi
    done
    # Generate additional random IPs if needed
    while [ $n -lt $iplist ]; do
        temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then break; fi
        temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then break; fi
        temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then break; fi
        temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then break; fi
        temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then break; fi
        temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then break; fi
        temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then break; fi
    done
    while [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -lt $iplist ]; do
        temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then break; fi
        temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
        n=$(($n + 1))
        if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then break; fi
        temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
        n=$(($n + 1))
    done
}

# Generate or use static IPv6 endpoints
endipv6() {
    n=0
    iplist=100
    # First, add static IPv6 endpoints
    for endpoint in "${STATIC_ENDPOINTS[@]}"; do
        if [[ $endpoint == *:*::* ]]; then # Filter IPv6
            temp[$n]=$endpoint
            n=$(($n + 1))
        fi
    done
    # Generate additional random IPv6 if needed
    while [ $n -lt $iplist ]; do
        temp[$n]=$(echo [2606:4700:d0::$(openssl rand -hex 4):$(openssl rand -hex 4):$(openssl rand -hex 4):$(openssl rand -hex 4)])
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then break; fi
        temp[$n]=$(echo [2606:4700:d1::$(openssl rand -hex 4):$(openssl rand -hex 4):$(openssl rand -hex 4):$(openssl rand -hex 4)])
        n=$(($n + 1))
        if [ $n -ge $iplist ]; then break; fi
    done
}

# Test endpoints and save results
endipresult() {
    echo -e "${cyan}Please wait, scanning the best endpoint...${rest}"
    echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u > ip.txt
    warpendpoint
    sort -t',' -k2 -k3 -n result.csv | uniq | head -11 | awk -F',' '{print "Endpoint "$1" Packet Loss Rate "$2" Average Delay "$3}' > /dev/null
    Endip_v4=$(cat result.csv | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+" | head -n 1)
    Endip_v6=$(cat result.csv | grep -oE "\[.*\]:[0-9]+" | head -n 1)
    delay=$(cat result.csv | grep -oE "[0-9]+ ms|timeout" | head -n 1)
    echo ""
    echo -e "${green}Results Saved in result.csv${rest}"
    echo ""
    if [ "$Endip_v4" ]; then
        echo -e "${purple}************************************${rest}"
        echo -e "${purple}* ${yellow}Best IPv4:Port${purple} *${rest}"
        echo -e "${purple}* *${rest}"
        echo -e "${purple}* ${cyan}$Endip_v4${purple} *${rest}"
        echo -e "${purple}* ${cyan}Delay: ${green}[$delay] ${purple}*${rest}"
        echo -e "${purple}************************************${rest}"
    elif [ "$Endip_v6" ]; then
        echo -e "${purple}********************************************${rest}"
        echo -e "${purple}* ${yellow}Best [IPv6]:Port ${purple}*${rest}"
        echo -e "${purple}* *${rest}"
        echo -e "${purple}* ${cyan}$Endip_v6${purple} *${rest}"
        echo -e "${purple}* ${cyan}Delay: ${green}[$delay] ${purple}*${rest}"
        echo -e "${purple}********************************************${rest}"
    else
        echo -e "${red} No valid IP addresses found.${rest}"
    fi
    rm warpendpoint >/dev/null 2>&1
    rm -rf ip.txt
    exit
}

# Install wire-g and dependencies
wire-g() {
    if [ ! -f "$PREFIX/bin/wire-g" ]; then
        if [ -f "$HOME/.termux" ]; then
            if ! command -v wg &>/dev/null || ! command -v jq &>/dev/null || ! command -v xz &>/dev/null || ! command -v bzip2 &>/dev/null; then
                pkg update -y && pkg upgrade -y
                pkg install wireguard-tools jq xz-utils bzip2 -y
            fi
        else
            if ! command -v wg &>/dev/null || ! command -v jq &>/dev/null || ! command -v xz &>/dev/null || ! command -v bzip2 &>/dev/null; then
                apt update -y
                apt install wireguard-tools jq xz-utils bzip2 -y
            fi
        fi
        curl -o $PREFIX/bin/wire-g https://raw.githubusercontent.com/Ptechgithub/warp/main/wire-g.sh
        chmod +x $PREFIX/bin/wire-g
        echo ""
        echo -e "${purple}*********************${rest}"
        echo -e "${yellow}Run --> ${green}wire-g${rest}"
        echo -e "${yellow}Help --> ${green}wire-g -h${rest}"
        echo -e "${purple}*********************${rest}"
    else
        echo ""
        echo -e "${purple}*********************${rest}"
        echo -e "${yellow}Run --> ${green}wire-g${rest}"
        echo -e "${yellow}Help --> ${green}wire-g -h${rest}"
        echo -e "${purple}*********************${rest}"
    fi
}

# License cloner
cloner() {
    if ! command -v wgcf &>/dev/null; then
        echo -e "${purple}*********************${rest}"
        echo -e "${green}Downloading the required file ...${rest}"
        if [[ "$(uname -o)" == "Android" ]]; then
            if ! command -v curl &>/dev/null; then
                pkg install curl -y
            fi
            if [[ -n $cpu ]]; then
                curl -o "$PREFIX/bin/wgcf" -L "https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/wgcf"
                chmod +x "$PREFIX/bin/wgcf"
            fi
        else
            curl -L -o wgcf -# --retry 2 "https://github.com/ViRb3/wgcf/releases/download/v2.2.24/wgcf_2.2.24_linux_$cpu"
            cp wgcf "$PREFIX/usr/local/bin"
            chmod +x "$PREFIX/usr/local/bin/wgcf"
        fi
    fi
    echo -e "${purple}*********************${rest}"
    echo -e "${green}Generating free warp config ..."
}

# Menu
clear
echo -e "${cyan}By --> Peyman * Github.com/Ptechgithub * ${rest}"
echo ""
echo -e "${purple}**********************${rest}"
echo -e "${purple}* ${green}Endpoint Scanner ${purple} *${rest}"
echo -e "${purple}* ${green}wire-g installer ${purple} *${rest}"
echo -e "${purple}* ${green}License cloner${purple} *${rest}"
echo -e "${purple}**********************${rest}"
echo -e "${purple}[1] ${cyan}Preferred${green} IPV4${purple} * ${rest}"
echo -e "${purple} *${rest}"
echo -e "${purple}[2] ${cyan}Preferred${green} IPV6${purple} * ${rest}"
echo -e "${purple} *${rest}"
echo -e "${purple}[3] ${cyan}Free Config ${green}Wgcf${purple} * ${rest}"
echo -e "${purple} *${rest}"
echo -e "${purple}[4] ${cyan}Install ${green}wire-g${purple} * ${rest}"
echo -e "${purple} *${rest}"
echo -e "${purple}[5] ${cyan}License Cloner${purple} * ${rest}"
echo -e "${purple} *${rest}"
echo -e "${purple}[${red}0${purple}] Exit *${rest}"
echo -e "${purple}**********************${rest}"
echo -en "${cyan}Enter your choice: ${rest}"
read -r choice
case "$choice" in
    1) echo -e "${purple}*********************${rest}"; cfwarpIP; endipv4; endipresult; Endip_v4 ;;
    2) echo -e "${purple}*********************${rest}"; cfwarpIP; endipv6; endipresult; Endip_v6 ;;
    3) generate ;;
    4) wire-g ;;
    5) cloner ;;
    0) echo -e "${purple}*********************${rest}"; echo -e "${cyan}By 🖐${rest}"; exit ;;
    *) echo -e "${yellow}********************${rest}"; echo "Invalid choice." ;;
esac
