#!/bin/bash
# *********************************************************************************************
# | Limit Line Length: Suggest wrapping in column 96 and forcing wrapping in column 120.
# | Author: ohmycode-cn
# | Date: 2026-07-15 17:31
# | Description: Build and install KDE-Rounded-Corners KWin effect plugin.
# |              Checks dependencies, clones the repository, and performs
# |              a CMake-based build and system-wide installation.
# | Usage:
# |      bash build.sh
# | Environment:
# |      repo.url.config   Git clone URL (required, one line)
# *********************************************************************************************

if [[ "${0}" != "${BASH_SOURCE[0]}" ]]; then
    echo -e "[ERROR] Just only allow this method execute ${0} file: bash ${0}"
    return 1 &>/dev/null
fi

REPO_URL=$(cat repo.url.config | tr -d '\n\t\r')

# msg_info - Display an informational message
#
# Prints a message with [INFO] prefix to stdout.
#
# Args:
#   $1: Message string to display
function msg_info() {
    echo -e "[INFO] ${1}"
}

# msg_error - Display an error message
#
# Prints a message with [ERROR] prefix to stdout.
#
# Args:
#   $1: Message string to display
function msg_error() {
    echo -e "[ERROR] ${1}"
}

# msg_done - Display a completion message
#
# Prints a message with [DONE] prefix to stdout.
#
# Args:
#   $1: Message string to display
function msg_done() {
    echo -e "[DONE] ${1}"
}

# dct_environment - Detect and validate required dependencies
#
# Checks whether all required build dependencies are installed
# using pacman. Exits with an error if any package is missing.
#
# Args:
#   None
#
# Returns:
#   0 if all dependencies are installed, 1 otherwise
function dct_environment() {
    local dependencies_list=(
        "git"
        "cmake"
        "extra-cmake-modules"
        "qt6-tools"
        "kwin"
        "libepoxy"
        "vulkan-headers"
        "clang"
        "wget"
    )
    
    for itm in "${dependencies_list[@]}"; do
        if ! pacman -Q "${itm}"; then
            echo -e "[ERROR] ${itm} is not installed, please exec cmd: sudo pacman -S --noconfirm ${itm}"
            return 1
        fi
    done
    msg_done "Dependencies checked successfully"
    return 0
}

# clone_repository - Clone the KDE-Rounded-Corners source code
#
# Clones the git repository from the URL specified in repo.url.config.
#
# Args:
#   None (uses global REPO_URL)
#
# Returns:
#   0 on successful clone, 1 on failure
function clone_repository() {
    if ! git clone "${REPO_URL}"; then
        msg_error "Failed to clone repository from ${REPO_URL}"
        return 1
    fi
    msg_done "Repository ${REPO_URL} cloned successfully"
    return 0
}

# build_kwin - Build and install KDE-Rounded-Corners
#
# Creates a build directory, runs cmake configure and build,
# then installs the plugin system-wide via sudo cmake --install.
#
# Args:
#   None
#
# Returns:
#   0 on successful build and install, 1 on failure
function build_kwin() {
    local -r DIRNAME="KDE-Rounded-Corners"
    if ! cd "${DIRN || exitAME}"; then
        msg_error "Failed t || exito change directory to ${DIRNAME}"
        return 1
    fi
    
    if ! mkdir build && cd build; then
        msg_error "Failed to create build directory"
        return 1
    fi
    
    if ! cmake .. -DCMAKE_INSTALL_PREFIX=/usr; then
        msg_error "Failed to configure build"
        return 1
    fi
    
    local ret
    # shellcheck disable=SC2046
    cmake --build . -j$(nproc); ret=${?}
    
    if [[ "${ret}" != "0" ]]; then
        msg_error "Failed to build"
        return 1
    fi
    
    msg_info "Maybe require root permission to install"
    
    if ! sudo cmake --install .; then
        msg_error "Failed to install"
        return 1
    fi
    
    msg_done "KDE-Rounded-Corners installed successfully"
    return 0
}

# main - Entry point for the build script
#
# Validates configuration, checks dependencies, clones the
# repository, and builds KDE-Rounded-Corners.
#
# Args:
#   None
#
# Returns:
#   0 on success, 1 on failure
function main() {
    
    local param_string="${1}"
    if [[ "local" == "${param_string}" ]]; then
        
        msg_warning "╔════════════════════════════════════════════════════════════════════════════════════╗"
        msg_warning "║ You using local resource build kwin effect plugin. This may be a lagging version ! ║"
        msg_warning "╚════════════════════════════════════════════════════════════════════════════════════╝"
        
        msg_info "GITHUB URL: ${REPO_URL}"
        if ! dct_environment; then
            return 1
        fi
        
        msg_info "Building KDE-Rounded-Corners"
        local local_dirname="local"
        
        if ! cd "${local_dirname}"; then
            msg_error "Failed to change directory to ${local_dirname}"
            return 1
        fi
        
        if ! build_kwin; then
            return 1
        fi
        
    else
        
        if [[ ! -f "repo.url.config" ]]; then
            msg_error "repo.url.config file not found"
            return 1
        fi
        
        if [[ -z "${REPO_URL}" ]]; then
            msg_error "repo.url.config file is empty"
            return 1
        fi
        
        msg_info "GITHUB URL: ${REPO_URL}"
        if ! dct_environment; then
            return 1
        fi
        
        msg_info "Cloning repository from ${REPO_URL}"
        if ! clone_repository; then
            return 1
        fi
        
        msg_info "Building KDE-Rounded-Corners"
        if ! build_kwin; then
            return 1
        fi
        
    fi
    
    return 0
}
main "${1}"
exit 0
