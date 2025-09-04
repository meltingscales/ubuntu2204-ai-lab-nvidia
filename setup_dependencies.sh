#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

check_if_already_run() {
    log "Checking for existing installations..."
    
    local already_installed=0
    
    if package_installed "build-essential" && package_installed "python3-dev" && command -v node >/dev/null 2>&1; then
        warn "Core dependencies appear to already be installed"
        info "✓ build-essential found"
        info "✓ python3-dev found" 
        info "✓ Node.js found ($(node --version))"
        already_installed=1
    fi
    
    if [ $already_installed -eq 1 ]; then
        read -p "Do you want to continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Exiting as requested"
            exit 0
        fi
    fi
}

package_installed() {
    dpkg -l "$1" &> /dev/null
}

update_system() {
    log "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    log "System packages updated"
}

install_basic_dependencies() {
    log "Installing basic system dependencies..."
    
    local packages=(
        build-essential
        software-properties-common
        apt-transport-https
        ca-certificates
        gnupg
        lsb-release
        curl
        wget
        git
        unzip
        zip
        netcat
    )
    
    local to_install=()
    for pkg in "${packages[@]}"; do
        if ! package_installed "$pkg"; then
            to_install+=("$pkg")
        else
            info "$pkg already installed"
        fi
    done
    
    if [ ${#to_install[@]} -gt 0 ]; then
        info "Installing: ${to_install[*]}"
        sudo apt install -y "${to_install[@]}"
        log "Basic dependencies installed"
    else
        info "All basic dependencies already installed"
    fi
}

install_python_stack() {
    log "Installing Python development stack..."
    
    sudo apt install -y \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        python3-setuptools \
        python3-wheel \
        libpython3-dev
    
    # Upgrade pip
    python3 -m pip install --user --upgrade pip
    python3 -m pip install --user --upgrade setuptools wheel
    
    log "Python stack installed"
}

install_nodejs() {
    log "Installing Node.js and npm..."
    
    # Install NodeSource repository for latest Node.js
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    
    # Update npm to latest
    sudo npm install -g npm@latest
    
    log "Node.js and npm installed"
    info "Node.js version: $(node --version)"
    info "npm version: $(npm --version)"
}

install_multimedia_libs() {
    log "Installing multimedia and graphics libraries..."
    
    sudo apt install -y \
        ffmpeg \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libswscale-dev \
        libswresample-dev \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libwebp-dev \
        libopencv-dev \
        libgl1-mesa-glx \
        libglib2.0-0
    
    log "Multimedia libraries installed"
}

install_ai_ml_dependencies() {
    log "Installing AI/ML system dependencies..."
    
    sudo apt install -y \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        gfortran \
        libhdf5-dev \
        libffi-dev \
        libssl-dev \
        liblzma-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        llvm \
        libncurses5-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev
    
    log "AI/ML dependencies installed"
}

install_optional_tools() {
    log "Installing optional development tools..."
    
    sudo apt install -y \
        htop \
        tree \
        jq \
        vim \
        nano \
        tmux \
        screen \
        rsync \
        openssh-client
    
    log "Optional tools installed"
}

configure_environment() {
    log "Configuring environment..."
    
    # Add local bin to PATH if not already there
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        info "Added ~/.local/bin to PATH in .bashrc"
    fi
    
    # Create ai-tools directory
    mkdir -p "$HOME/ai-tools"
    
    log "Environment configured"
}

verify_installation() {
    log "Verifying installation..."
    
    info "System Information:"
    info "  OS: $(lsb_release -d | cut -f2)"
    info "  Kernel: $(uname -r)"
    info "  Python: $(python3 --version)"
    info "  pip: $(python3 -m pip --version | cut -d' ' -f2)"
    info "  Node.js: $(node --version)"
    info "  npm: $(npm --version)"
    info "  Git: $(git --version)"
    info "  FFmpeg: $(ffmpeg -version | head -1)"
    
    log "Installation verification completed"
}

main() {
    log "Starting Dependencies Setup for Ubuntu 22.04"
    
    check_if_already_run
    update_system
    install_basic_dependencies
    install_python_stack
    install_nodejs
    install_multimedia_libs
    install_ai_ml_dependencies
    install_optional_tools
    configure_environment
    verify_installation
    
    log "Dependencies setup completed successfully!"
    info "Please run 'source ~/.bashrc' or restart your terminal to apply PATH changes"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi