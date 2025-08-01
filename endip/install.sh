#!/bin/bash

# Colors
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
orange='\033[38;5;208m'
cyan='\033[0;36m'
rest='\033[0m'

# Detect architecture
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

# Download warpendpoint if not present
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

# Generate IPv4 endpoints
endipv4() {
	n=0
	iplist=100
	while true; do
		temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 8.34.146.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 8.34.70.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 8.35.211.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo 8.39.204.$(($RANDOM % 256)))
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
	done
	while true; do
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 8.34.146.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 8.34.70.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 8.35.211.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo 8.39.204.$(($RANDOM % 256)))
			n=$(($n + 1))
		fi
	done
}

# Generate IPv6 endpoints
endipv6() {
	n=0
	iplist=100
	while true; do
		temp[$n]=$(echo [2606:4700:d0::$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2)))])
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
		temp[$n]=$(echo [2606:4700:d1::$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2)))])
		n=$(($n + 1))
		if [ $n -ge $iplist ]; then
			break
		fi
	done
	while true; do
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo [2606:4700:d0::$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2)))])
			n=$(($n + 1))
		fi
		if [ $(echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
			break
		else
			temp[$n]=$(echo [2606:4700:d1::$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2))):$(printf '%x\n' $(($RANDOM * 2 + $RANDOM % 2)))])
			n=$(($n + 1))
		fi
	done
}

# Test endpoints and display results
endipresult() {
	echo "${temp[@]}" | sed -e 's/ /\n/g' | sort -u >ip.txt
	ulimit -n 102400
	chmod +x warpendpoint >/dev/null 2>&1
	if command -v warpendpoint &>/dev/null; then
		warpendpoint
	else
		./warpendpoint
	fi

	
	cat result.csv | awk -F, '$3!="timeout ms" {print} ' | sort -t, -nk2 -nk3 | uniq | head -11 | awk -F, '{print "Endpoint "$1" Packet Loss Rate "$2" Average Delay "$3}'
	Endip_v4=$(cat result.csv | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+" | head -n 10)
	Endip_v6=$(cat result.csv | grep -oE "\[.*\]:[0-9]+" | head -n 10)
	delay=$(cat result.csv | grep -oE "[0-9]+ ms|timeout" | head -n 1)
	echo ""
	echo -e "${green}Results Saved in result.csv${rest}"
	echo ""
	if [ "$Endip_v4" ]; then
		echo -e "$Endip_v4"
		echo -e "$Endip_v6"
	else
		echo -e "${red} No valid IP addresses found.${rest}"
	fi
	rm warpendpoint >/dev/null 2>&1
	rm -rf ip.txt
	exit
}

# Menu

echo -e "${cyan}By --> Wulfric * Github.com/wulfric93 * ${rest}"
echo ""
echo -e "${orange}**********************${rest}"
echo -e "${orange}*  ${green}Endpoint Scanner ${orange} *${rest}"
echo -e "${orange}**********************${rest}"
echo -e "${orange}[1] ${cyan}Preferred${green} IPv4${orange}   * ${rest}"
echo -e "${orange}                     *${rest}"
echo -e "${orange}[2] ${cyan}Preferred${green} IPv6${orange}   * ${rest}"
echo -e "${orange}                     *${rest}"
echo -e "${orange}[${red}0${orange}] Exit             *${rest}"
echo -e "${orange}**********************${rest}"
echo -en "${cyan}Enter your choice: ${rest}"
read -r choice
case "$choice" in
1)
	echo -e "${orange}*********************${rest}"
	cfwarpIP
	endipv4
	endipresult
	;;
2)
	echo -e "${orange}*********************${rest}"
	cfwarpIP
	endipv6
	endipresult
	;;
0)
	echo -e "${orange}*********************${rest}"
	echo -e "${cyan}Bye${rest}"
	exit
	;;
*)
	echo -e "${yellow}********************${rest}"
	echo "Invalid choice. Please select a valid option."
	;;
esac
