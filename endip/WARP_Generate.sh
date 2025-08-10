#!/bin/bash

# ========== VARIABLES ==========
RED="\033[31m"; GREEN="\033[32m"; YELLOW="\033[33m"; BLUE="\033[36m"; PLAIN="\033[0m"

# ========== FUNCTIONS ==========
arch_affix() {
    case "$(uname -m)" in
        x86_64 | x64 | amd64) echo 'amd64' ;;
        i386 | i686)          echo '386' ;;
        armv8 | armv8l | arm64 | aarch64) echo 'arm64' ;;
        armv7l)               echo 'arm' ;;
        *) echo "Unsupported architecture: $(uname -m)"; exit 1 ;;
    esac
}

download_wgcf() {
    if ! command -v wgcf &>/dev/null; then
        echo -e "${YELLOW}Downloading wgcf...${PLAIN}"
        local affix=$(arch_affix)
        curl -L -o wgcf -# --retry 2 \
            "https://github.com/ViRb3/wgcf/releases/download/v2.2.24/wgcf_2.2.27_linux_${affix}"
        chmod +x wgcf
        sudo mv wgcf /usr/local/bin/
    fi
}

generate_wgcf_config() {
    echo -e "${BLUE}Generating WARP account and WireGuard config...${PLAIN}"
    rm -f wgcf-account.toml wgcf-profile.conf
    wgcf register --accept-tos
    wgcf generate
    if [ -f wgcf-profile.conf ]; then
        echo -e "${GREEN}✅ Config generated: wgcf-profile.conf${PLAIN}"
    else
        echo -e "${RED}❌ Failed to generate config${PLAIN}"
    fi
}

# ========== MAIN ==========
echo -e "${GREEN}=== WARP Config Generator ===${PLAIN}"
download_wgcf
generate_wgcf_config
