#!/bin/bash

#colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
rest='\033[0m'

# Predefined IPv4 and IPv6 lists
ipv4_list=(
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
)

ipv6_list=(
    "[2606:4700:d1::58a8:0f84:d37f:90e7]:7559"
    "[2606:4700:d1::1665:bab6:7ff1:a710]:878"
    "[2606:4700:d0::6932:d526:67b7:77ce]:890"
    "[2606:4700:d1::9eae:b:2754:6ad9]:1018"
)

case "$(uname -m)" in
x86_64 | x64 | amd64)
    cpu=amd64
    ;;
i386 | i686)
    cpu=386
    ;;
armv8 | armv8l | arm64 | aarch64)
    cpu=arm64
    ;;
armv7l)
    cpu=arm
    ;;
*)
    echo "The current architecture is $(uname -m), not supported"
    exit
    ;;
esac

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

endipv4() {
    n=0
    iplist=${#ipv4_list[@]} # Set iplist to the number of IPv4 addresses
    for ip in "${ipv4_list[@]}"; do
        temp[$n]="$ip"
        n=$(($n + 1))
    done
}

endipv6() {
    n=0
    iplist=${#ipv6_list[@]} # Set iplist to the number of IPv6 addresses
    for ip in "${ipv6_list[@]}"; do
        temp[$n]="$ip"
        n=$(($n + 1))
    done
}

# Wgcf
generate() {
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
    echo -e "${green}Generating free warp config . please wait ...${rest}"
    echo ""
    rm wgcf-account.toml >/dev/null 2>&1
    wgcf register --accept-tos
    echo -e "${blue}***********************${rest}"
    wgcf generate

    if [ -f wgcf-profile.conf ]; then
        show
    else
        echo -e "${red}wgcf-profile.conf not found in current path or failed to install${rest}"
    fi
}

v2ray() {
    urlencode() {
        local string="$1"
        local length="${#string}"
        local urlencoded=""
        for ((i = 0; i < length; i++)); do
            local c="${string:$i:1}"
            case $c in
            [a-zA-Z0-9.~_-]) urlencoded+="$c" ;;
            *)
                printf -v hex "%02X" "'$c"
                urlencoded+="%${hex: -2}"
                ;;
            esac
        done
        echo "$urlencoded"
    }

    PrivateKey=$(awk -F' = ' '/PrivateKey/{print $2}' wgcf-profile.conf)
    Address=$(awk -F' = ' '/Address/{print $2}' wgcf-profile.conf | tr '\n' ',' | sed 's/,$//;s/,/, /g')
    PublicKey=$(awk -F' = ' '/PublicKey/{print $2}' wgcf-profile.conf)
    MTU=$(awk -F' = ' '/MTU/{print $2}' wgcf-profile.conf)

    WireguardURL="wireguard://$(urlencode "$PrivateKey")@$Endip_v46?address=$(urlencode "$Address")&publickey=$(urlencode "$PublicKey")&mtu=$(urlencode "$MTU")#Peyman_WireGuard"

    echo $WireguardURL
}

show() {
    echo ""
    sleep 1
    clear
    if [ -s result.csv ]; then
        Endip_v46=$(awk 'NR==2 {split($1, arr, ","); print arr[1]}' result.csv)
        sed -i "s/Endpoint =.*/Endpoint = $Endip_v46/g" wgcf-profile.conf
    else
        Endip_v46="engage.cloudflareclient.com:2408"
    fi
    echo -e "${purple}************************************${rest}"
    echo -e "${purple}*   👇${green}Here is WireGuard Config👇   ${purple}*${rest}"
    echo -e "${purple}************************************${rest}"
    echo -e "${cyan}       👇Copy for :${yellow}[Nekobox] 👇${rest}"
    echo ""
    echo -e "${green}$(cat wgcf-profile.conf)${rest}"
    echo ""
    echo -e "${purple}************************************${rest}"
    echo -e "${cyan}       👇Copy for :${yellow}[V2rayNG] 👇${rest}"
    echo ""
    echo -e "${green}$(v2ray)${rest}"
    echo ""
    echo -e "${purple}************************************${rest}"
    echo -e "${yellow}1) ${blue}if you couldn't paste it in ${yellow}V2rayNG${blue} or ${yellow}Nekobox${blue}, copy it to a text editor and remove any extra spaces.${rest}"
    echo ""
    echo -e "${yellow}2) ${blue}If you're using ${yellow}IPv6 ${blue}in ${yellow}V2rayNG, ${blue}place IPV6 inside${yellow} [ ] ${blue}example: ${yellow}[2606:4700:d0::1836:b925:ebb2:5eb1] ${rest}"
    echo -e "${purple}************************************${rest}"
}

endipresult() {
    echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u >ip.txt
    ulimit -n 102400
    chmod +x warpendpoint >/dev/null 2>&1
    if command -v warpendpoint &>/dev/null; then
        warpendpoint
    else
        ./warpendpoint
    fi

    clear
    cat result.csv | awk -F, '$3!="timeout ms" {print} ' | sort -t, -nk2 -nk3 | uniq | head -11 | awk -F, '{print "Endpoint "$1" Packet Loss Rate "$2" Average Delay "$3}'
    Endip_v4=$(cat result.csv | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+" | head -n 1)
    Endip_v6=$(cat result.csv | grep -oE "\[.*\]:[0-9]+" | head -n 1)
    delay=$(cat result.csv | grep -oE "[0-9]+ ms|timeout" | head -n 1)
    echo ""
    echo -e "${green}Results Saved in result.csv${rest}"
    echo ""
    if [ "$Endip_v4" ]; then
        echo -e "${purple}************************************${rest}"
        echo -e "${purple}*           ${yellow}Best IPv4:Port${purple}         *${rest}"
        echo -e "${purple}*                                  *${rest}"
        echo -e "${purple}*          ${cyan}$Endip_v4${purple}     *${rest}"
        echo -e "${purple}*           ${cyan}Delay: ${green}[$delay]        ${purple}*${rest}"
        echo -e "${purple}************************************${rest}"
    elif [ "$Endip_v6" ]; then
        echo -e "${purple}********************************************${rest}"
        echo -e "${purple}*          ${yellow}Best [IPv6]:Port                ${purple}*${rest}"
        echo -e "${purple}*                                          *${rest}"
        echo -e "${purple}* ${cyan}$Endip_v6${purple} *${rest}"
        echo -e "${purple}*           ${cyan}Delay: ${green}[$delay]               ${purple}*${rest}"
        echo -e "${purple}********************************************${rest}"
    else
        echo -e "${red} No valid IP addresses found.${rest}"
    fi
    rm warpendpoint >/dev/null 2>&1
    rm -rf ip.txt
    exit
}

# Run wire-g and get Wireguard Config
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
    if ! command -v wg &>/dev/null; then
        if [ -d "$PREFIX" ] && [ "$(uname -o)" = "Android" ]; then
            echo "Installing wireguard-tools"
            pkg install wireguard-tools -y
            pkg install jq -y
        elif [ -x "$(command -v apt)" ]; then
            echo "Installing wireguard-tools on Debian/Ubuntu"
            sudo apt update -y && sudo apt install wireguard-tools -y
        elif [ -x "$(command -v yum)" ]; then
            echo "Installing wireguard-tools on CentOS/RHEL"
            sudo yum install epel-release -y && sudo yum install kmod-wireguard wireguard-tools -y
        elif [ -x "$(command -v dnf)" ]; then
            echo "Installing wireguard-tools on Fedora"
            sudo dnf install wireguard-tools -y
        elif [ -x "$(command -v zypper)" ]; then
            echo "Installing wireguard-tools on openSUSE"
            sudo zypper install wireguard-tools -y
        fi
    fi

    licenses=(
        "0L156IFo-Xlou7509-cL0kj975"
        "1E987bRY-KI8167Rp-2cO3I5a0"
        "450sxY1P-0927yEPv-538cGDa0"
        "82gHq31I-785W3PSO-1rW35X9v"
        "BQ91v37L-s296aVH3-5p34vXS6"
        "8NP103zQ-u2T68YS3-b3Cy25H9"
        "6M10oEq7-HA0h5y92-F42KMv61"
        "Pi0n45K6-24ON7A1C-7Q18My2n"
        "q36pSa91-240vtF1s-F25r10gZ"
        "H9y510oc-PR53o01f-cW176f0y"
        "Y4v03C5u-Ad81i3z5-PQ30z45f"
        "8V2hX14D-D0SR78w3-2ule45m3"
        "7V9p34gb-9hlI5Y64-C35dO6l2"
        "MAa9251S-M19y53Hb-05cJ2hS4"
        "R7k0j3p4-5B14RK6p-C8F6vw72"
        "X16yb7g2-1P3fH56y-x8L7e1D0"
        "5hc0L42Z-f15su76j-r0N8ia43"
        "8wnc27d1-C5F3d2y9-45eKs3F9"
        "05skL7r1-d683ZSB0-7RrT964j"
        "iTP2I901-821KdD5h-2840MpQv"
        "14b68TNu-v801R2Mi-690t7vYu"
        "QPIE0458-1VDX92W5-70e2iNA3"
        "53RN8G7d-24J59kYR-08b4v9RU"
        "G438E2Ve-uH4sE653-Kn53fJ76"
        "21Ig0LE8-47emp59P-N190Vf5z"
    )

    echo -e "${cyan}######################${rest}"
    echo -en "${green}Enter a license (${yellow}Press Enter to use a random license, may not work${green}): ${rest}"
    read -r input_license

    if [ -z "$input_license" ]; then
        # Choose a random license from the list
        license=$(shuf -n 1 -e "${licenses[@]}")
    else
        license="$input_license"
    fi
    echo -e "${cyan}######################${rest}"
    echo -e "${purple}🔑 Warp License cloner 🔑${rest}"
    echo -e "${green}Starting...${rest}"
    echo -e "${purple}-------------------------------------${rest}"
    while true; do
        # Requirements
        if [ $(type -p wg) ]; then
            private_key=$(wg genkey)
            public_key=$(wg pubkey <<<"$private_key")
        else
            wg_api=$(curl -m5 -sSL https://wg-key.forvps.gq/)
            private_key=$(awk 'NR==2 {print $2}' <<<"$wg_api")
            public_key=$(awk 'NR==1 {print $2}' <<<"$wg_api")
        fi
        install_id=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 22)
        fcm_token="${install_id}:APA91b$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 134)"
        rand=$(tr -dc '0-9' </dev/urandom | head -c 3)

        # Register
        response=$(curl --request POST "https://api.cloudflareclient.com/v0a${rand}/reg" \
            --silent \
            --location \
            --tlsv1.3 \
            --header 'User-Agent: okhttp/3.12.1' \
            --header "CF-Client-Version: a-6.33-${rand}" \
            --header 'Content-Type: application/json' \
            --data '{
                "key": "'"${public_key}"'",
                "install_id": "'"${install_id}"'",
                "fcm_token": "'"${fcm_token}"'",
                "tos": "'"$(date +"%Y-%m-%dT%H:%M:%S.000Z")"'",
                "model": "PC",
                "serial_number": "'"${install_id}"'",
                "locale": "en_US"
            }')

        echo "$response" | jq . >warp-config.json

        # Change License
        id=$(jq -r '.id' <warp-config.json)
        token=$(jq -r '.token' <warp-config.json)
        license="${license}"

        response=$(curl --request PUT "https://api.cloudflareclient.com/v0a${rand}/reg/${id}/account" \
            --silent \
            --location \
            --header 'User-Agent: okhttp/3.12.1' \
            --header "CF-Client-Version: a-6.33-${rand}" \
            --header 'Content-Type: application/json' \
            --header "Authorization: Bearer ${token}" \
            --data '{
                "license": "'"$license"'"
            }')

        # Patch Account
        patch_one_response=$(curl -X PATCH "https://api.cloudflareclient.com/v0a${rand}/reg/${id}/account" \
            --silent \
            --location \
            --header 'User-Agent: okhttp/3.12.1' \
            --header "CF-Client-Version: a-6.33-${rand}" \
            --header 'Content-Type: application/json' \
            --header "Authorization: Bearer ${token}" \
            --data '{"active": true}')

        # Get Data
        get_response=$(curl -X GET "https://api.cloudflareclient.com/v0a${rand}/reg/${id}" \
            --silent \
            --header "Authorization: Bearer ${token}" \
            --header "Accept: application/json" \
            --header "Accept-Encoding: gzip" \
            --header "Cf-Client-Version: a-6.3-${rand}" \
            --header "User-Agent: okhttp/3.12.1" \
            --output - | gunzip -c | jq .)

        id=$(echo "$get_response" | jq -r '.id')
        balance=$(echo "$get_response" | jq -r '.account.quota')
        quota=$((balance / 1000000000))
        # Change License Again
        license=$(jq -r '.account.license' <warp-config.json)

        response=$(curl --request PUT "https://api.cloudflareclient.com/v0a${rand}/reg/${id}/account" \
            --silent \
            --location \
            --header 'User-Agent: okhttp/3.12.1' \
            --header "CF-Client-Version: a-6.33-${rand}" \
            --header 'Content-Type: application/json' \
            --header "Authorization: Bearer ${token}" \
            --data '{
                "license": "'"$license"'"
            }')

        # Patch Account Again
        patch_two_response=$(curl -X PATCH "https://api.cloudflareclient.com/v0a${rand}/reg/${id}/account" \
            --silent \
            --location \
            --header 'User-Agent: okhttp/3.12.1' \
            --header "CF-Client-Version: a-6.33-${rand}" \
            --header 'Content-Type: application/json' \
            --header "Authorization: Bearer ${token}" \
            --data '{"active": true}' | jq . >/dev/null 2>&1)

        if [ "$(echo "$patch_two_response" | jq '.result')" != "null" ]; then
            license=$(jq -r '.account.license' <warp-config.json)
            echo -e "${green}$license ${rest}| ${cyan}$quota${rest}"
            echo -e "${purple}-------------------------------------${rest}"
            echo "$license | $quota" >>output.txt
        fi

        # Delete Account
        response=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE "https://api.cloudflareclient.com/v0a${rand}/reg/${id}" \
            --header "Authorization: Bearer ${token}" \
            --header "Accept: application/json" \
            --header "Accept-Encoding: gzip" \
            --header "Cf-Client-Version: a-6.3-${rand}" \
            --header "User-Agent: okhttp/3.12.1")

        if [ "$response" -ne 204 ]; then
            echo "Error: HTTP status code $response"
        fi
        rm warp-config.json >/dev/null 2>&1
        sleep 2
    done
}

#Menu
clear
echo -e "${cyan}By --> Peyman * Github.com/Ptechgithub * ${rest}"
echo ""
echo -e "${purple}**********************${rest}"
echo -e "${purple}*  ${green}Endpoint Scanner ${purple} *${rest}"
echo -e "${purple}*  ${green}wire-g installer ${purple} *${rest}"
echo -e "${purple}*  ${green}License cloner${purple}    *${rest}"
echo -e "${purple}**********************${rest}"
echo -e "${purple}[1] ${cyan}Preferred${green} IPV4${purple}   * ${rest}"
echo -e "${purple}                     *${rest}"
echo -e "${purple}[2] ${cyan}Preferred${green} IPV6${purple}   * ${rest}"
echo -e "${purple}                     *${rest}"
echo -e "${purple}[3] ${cyan}Free Config ${green}Wgcf${purple} *${rest}"
echo -e "${purple}                     *${rest}"
echo -e "${purple}[4] ${cyan}Install ${green}wire-g${purple}   *${rest}"
echo -e "${purple}                     *${rest}"
echo -e "${purple}[5] ${cyan}License Cloner${purple}   *${rest}"
echo -e "${purple}                     *${rest}"
echo -e "${purple}[${red}0${purple}] Exit             *${rest}"
echo -e "${purple}**********************${rest}"
echo -en "${cyan}Enter your choice: ${rest}"
read -r choice
case "$choice" in
1)
    echo -e "${purple}*********************${rest}"
    cfwarpIP
    endipv4
    endipresult
    Endip_v4
    ;;
2)
    echo -e "${purple}*********************${rest}"
    cfwarpIP
    endipv6
    endipresult
    Endip_v6
    ;;
3)
    generate
    ;;
4)
    wire-g
    ;;
5)
    cloner
    ;;
0)
    echo -e "${purple}*********************${rest}"
    echo -e "${cyan}By 🔑${rest}"
    exit
    ;;
*)
    echo -e "${yellow}********************${rest}"
    echo "Invalid choice. Please select a valid option."
    ;;
esac
