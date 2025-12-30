#!/usr/bin/env bash

# TunnelBear VPN - Full IP List & Latency Checker (v3.3 - Fixed for Termux)
# Fixed the "bad substitution" error that happens on older Bash versions in Termux
# Now uses indirect expansion safely
# Lists ALL IPs first, then pings them all
# All subdomains included (ae, hk, ua, uk, etc.)

clear
echo -e "\033[1;36mTunnelBear VPN - Full IP List & Latency Checker (v3.3)\033[0m"
echo -e "\033[1;36m======================================================\033[0m"
echo

declare -A north_america=(
    ["ca"]="ca.lazerpenguin.com → Canada (General)"
    ["ca-montreal"]="ca-montreal-tier2.lazerpenguin.com → Canada - Montreal"
    ["ca-toronto"]="ca-toronto-tier2.lazerpenguin.com → Canada - Toronto"
    ["ca-vancouver"]="ca-vancouver-tier2.lazerpenguin.com → Canada - Vancouver"
    ["us"]="us.lazerpenguin.com → United States (General)"
    ["us-central"]="us-central.lazerpenguin.com → US - Central"
    ["us-central-x"]="us-central-x.lazerpenguin.com → US - Central (Load Balanced)"
    ["us-east"]="us-east.lazerpenguin.com → US - East"
    ["us-east-x"]="us-east-x.lazerpenguin.com → US - East (Load Balanced)"
    ["us-west"]="us-west.lazerpenguin.com → US - West"
    ["us-west-x"]="us-west-x.lazerpenguin.com → US - West (Load Balanced)"
    ["us-atlanta"]="us-atlanta-tier2.lazerpenguin.com → US - Atlanta"
    ["us-chicago"]="us-chicago-tier2.lazerpenguin.com → US - Chicago"
    ["us-dallas"]="us-dallas-tier2.lazerpenguin.com → US - Dallas"
    ["us-denver"]="us-denver-tier2.lazerpenguin.com → US - Denver"
    ["us-losangeles"]="us-losangeles-tier2.lazerpenguin.com → US - Los Angeles"
    ["us-miami"]="us-miami-tier2.lazerpenguin.com → US - Miami"
    ["us-newyork"]="us-newyork-tier2.lazerpenguin.com → US - New York"
    ["us-phoenix"]="us-phoenix-tier2.lazerpenguin.com → US - Phoenix"
    ["us-saltlakecity"]="us-saltlakecity-tier2.lazerpenguin.com → US - Salt Lake City"
    ["us-sanjose"]="us-sanjose-tier2.lazerpenguin.com → US - San Jose"
    ["us-seattle"]="us-seattle-tier2.lazerpenguin.com → US - Seattle"
    ["us-stlouis"]="us-stlouis-tier2.lazerpenguin.com → US - St. Louis"
    ["mx"]="mx.lazerpenguin.com → Mexico"
)

declare -A south_america=(
    ["ar"]="ar.lazerpenguin.com → Argentina"
    ["br"]="br.lazerpenguin.com → Brazil"
    ["cl"]="cl.lazerpenguin.com → Chile"
    ["co"]="co.lazerpenguin.com → Colombia"
    ["pe"]="pe.lazerpenguin.com → Peru"
)

declare -A europe=(
    ["at"]="at.lazerpenguin.com → Austria"
    ["be"]="be.lazerpenguin.com → Belgium"
    ["bg"]="bg.lazerpenguin.com → Bulgaria"
    ["cy"]="cy.lazerpenguin.com → Cyprus"
    ["cz"]="cz.lazerpenguin.com → Czech Republic"
    ["de"]="de.lazerpenguin.com → Germany"
    ["dk"]="dk.lazerpenguin.com → Denmark"
    ["fi"]="fi.lazerpenguin.com → Finland"
    ["fr"]="fr.lazerpenguin.com → France"
    ["gr"]="gr.lazerpenguin.com → Greece"
    ["hu"]="hu.lazerpenguin.com → Hungary"
    ["ie"]="ie.lazerpenguin.com → Ireland"
    ["it"]="it.lazerpenguin.com → Italy"
    ["lt"]="lt.lazerpenguin.com → Lithuania"
    ["lv"]="lv.lazerpenguin.com → Latvia"
    ["md"]="md.lazerpenguin.com → Moldova"
    ["nl"]="nl.lazerpenguin.com → Netherlands"
    ["no"]="no.lazerpenguin.com → Norway"
    ["pl"]="pl.lazerpenguin.com → Poland"
    ["pt"]="pt.lazerpenguin.com → Portugal"
    ["ro"]="ro.lazerpenguin.com → Romania"
    ["rs"]="rs.lazerpenguin.com → Serbia"
    ["si"]="si.lazerpenguin.com → Slovenia"
    ["es"]="es.lazerpenguin.com → Spain"
    ["se"]="se.lazerpenguin.com → Sweden"
    ["ch"]="ch.lazerpenguin.com → Switzerland"
    ["gb"]="gb.lazerpenguin.com → United Kingdom"
    ["uk"]="uk.lazerpenguin.com → United Kingdom"
    ["ua"]="ua.lazerpenguin.com → Ukraine"
)

declare -A asia=(
    ["ae"]="ae.lazerpenguin.com → United Arab Emirates"
    ["hk"]="hk.lazerpenguin.com → Hong Kong"
    ["id"]="id.lazerpenguin.com → Indonesia"
    ["in"]="in.lazerpenguin.com → India"
    ["jp"]="jp.lazerpenguin.com → Japan"
    ["kr"]="kr.lazerpenguin.com → South Korea"
    ["my"]="my.lazerpenguin.com → Malaysia"
    ["ph"]="ph.lazerpenguin.com → Philippines"
    ["sg"]="sg.lazerpenguin.com → Singapore"
    ["tw"]="tw.lazerpenguin.com → Taiwan"
)

declare -A oceania=(
    ["au"]="au.lazerpenguin.com → Australia"
    ["nz"]="nz.lazerpenguin.com → New Zealand"
)

declare -A africa=(
    ["ke"]="ke.lazerpenguin.com → Kenya"
    ["ng"]="ng.lazerpenguin.com → Nigeria"
    ["za"]="za.lazerpenguin.com → South Africa"
)

continents=("north_america" "south_america" "europe" "asia" "oceania" "africa")
continent_names=("North America" "South America" "Europe" "Asia" "Oceania" "Africa")

while true; do
    clear
    echo -e "\033[1;36mTunnelBear VPN - Full IP List & Latency Checker (v3.3)\033[0m"
    echo -e "\033[1;36m======================================================\033[0m"
    echo

    num=1
    declare -A number_to_key

    for idx in "${!continents[@]}"; do
        continent="${continents[$idx]}"
        name="${continent_names[$idx]}"

        echo -e "\033[1;35m=== $name ===\033[0m"

        # Fixed line: safe way to get keys from indirect associative array
        eval "current_array=(\"\${!$continent[@]}\")"
        sorted_keys=($(printf '%s\n' "${current_array[@]}" | sort))

        for key in "${sorted_keys[@]}"; do
            eval "desc=\"\${$continent[$key]}\""
            printf "\033[1;33m%3d)\033[0m %s\n" "$num" "$desc"
            number_to_key["$num"]="$key"
            number_to_key["$num.continent"]="$continent"
            ((num++))
        done
        echo
    done

    read -rp "Enter server number (or 'q' to quit): " choice

    [[ "$choice" == "q" || "$choice" == "Q" ]] && echo -e "\nGoodbye!\n" && exit 0

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ -z "${number_to_key[$choice]}" ]]; then
        echo -e "\033[31mInvalid choice. Press Enter to continue...\033[0m"
        read -r
        continue
    fi

    selected_key="${number_to_key[$choice]}"
    continent_ref="${number_to_key[$choice.continent]}"

    eval "selected_subdomain=\"\${$continent_ref[$selected_key]}\""
    selected_subdomain=$(echo "$selected_subdomain" | awk '{print $1}')
    eval "description=\"\${$continent_ref[$selected_key]}\""
    description=$(echo "$description" | cut -d' ' -f3-)

    echo
    echo -e "\033[1;34mTesting:\033[0m $description"
    echo -e "\033[1;34mSubdomain:\033[0m $selected_subdomain"
    echo "Resolving all associated IPs..."
    echo

    if command -v dig >/dev/null 2>&1; then
        mapfile -t ips < <(dig +short "$selected_subdomain" A 2>/dev/null | grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' | sort -V)
    elif command -v nslookup >/dev/null 2>&1; then
        mapfile -t ips < <(nslookup "$selected_subdomain" 2>/dev/null | grep '^Address:' | grep -v '#' | awk '{print $2}' | grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' | sort -V)
    else
        echo -e "\033[31mError: Need 'dig' or 'nslookup' installed.\033[0m"
        echo "Termux: pkg install bind-tools"
        read -r
        continue
    fi

    if [[ ${#ips[@]} -eq 0 ]]; then
        echo -e "\033[31m✖ No IP addresses resolved for $selected_subdomain\033[0m"
        read -rp $'\nPress Enter to continue...'
        continue
    fi

    echo -e "\033[1;33mAll resolved IPs (${#ips[@]} total):\033[0m"
    for i in "${!ips[@]}"; do
        printf "   %2d) %s\n" $((i+1)) "${ips[$i]}"
    done
    echo
    echo "Pinging all IPs (4 packets each, 3s timeout)..."
    echo

    declare -A ip_latency
    working_count=0
    fastest_ip=""
    fastest_ms=999999

    for ip in "${ips[@]}"; do
        result=$(ping -c 4 -W 3 "$ip" 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            avg=$(echo "$result" | tail -1 | awk -F'/' '{print $5}' | awk '{print $1}')
            if [[ -n "$avg" && "$avg" != "0.000" ]]; then
                printf -v avg "%.0f" "$avg"
                ip_latency["$ip"]="$avg"
                echo -e "\033[32m✔ $ip  →  ${avg} ms\033[0m"
                ((working_count++))
                if (( avg < fastest_ms )); then
                    fastest_ms=$avg
                    fastest_ip="$ip"
                fi
            else
                echo -e "\033[33m⚠ $ip  →  responded but no latency data\033[0m"
            fi
        else
            echo -e "\033[31m✖ $ip  →  unreachable\033[0m"
        fi
    done

    echo
    if [[ $working_count -gt 0 ]]; then
        echo -e "\033[1;32mResponsive servers (sorted fastest to slowest):\033[0m"
        for ip in $(printf '%s %s\n' "${ip_latency[@]}" "${!ip_latency[@]}" | sort -n | awk '{print $2}'); do
            echo -e "   • $ip  (\033[1;33m${ip_latency[$ip]} ms\033[0m)"
        done
        echo
        echo -e "\033[1;36mFastest IP → $fastest_ip ($fastest_ms ms)\033[0m"
    else
        echo -e "\033[31mNo IPs responded to ping.\033[0m"
    fi

    echo
    read -rp $'Check another server? (y/n): ' again
    [[ "$again" != "y" && "$again" != "Y" ]] && echo -e "\nGoodbye!\n" && exit 0
done
