#!/bin/sh

set -oue pipefail

EXTRA_ARGS=()

add_argument() {
    declare -i "$1"=${!1:-0}

    if [[ "${!1}" -eq 1 ]]; then
        EXTRA_ARGS+=(${@:2})
    fi
}

# Nvidia GPUs may need to disable GPU acceleration:
# flatpak override --user --env=FRAYTOOLS_DISABLE_GPU=1 md.obsidian.Obsidian
add_argument FRAYTOOLS_DISABLE_GPU       --disable-gpu

# Wayland support can be optionally enabled like so:
# flatpak override --user --socket=wayland md.obsidian.Obsidian

WL_DISPLAY="${WAYLAND_DISPLAY:-"wayland-0"}"
# Some compositors a real path a instead of a symlink for WAYLAND_DISPLAY:
# https://github.com/flathub/md.obsidian.Obsidian/issues/284
if [[ -e "${XDG_RUNTIME_DIR}/${WL_DISPLAY}" || -e "/${WL_DISPLAY}" ]]; then
    echo "Debug: Enabling Wayland backend"
    EXTRA_ARGS+=(
        --ozone-platform-hint=auto
	--enable-features=WaylandWindowDecorations
    )
    if [[ -c /dev/nvidia0 ]]; then
        echo "Debug: Detecting Nvidia GPU. disabling GPU sandbox."
        EXTRA_ARGS+=(
            --disable-gpu-sandbox
        )
    fi
fi

# The cache files created by Electron and Mesa can become incompatible when there's an upgrade to
# either and may cause Obsidian to launch with a blank screen:
# https://github.com/flathub/md.obsidian.Obsidian/issues/214
if [[ "${FRAYTOOLS_CLEAN_CACHE}" -eq 1 ]]; then
    CACHE_DIRECTORIES=(
        "${XDG_CONFIG_HOME}/FrayTools/GPUCache"
    )
    for CACHE_DIRECTORY in "${CACHE_DIRECTORIES[@]}"; do
        if [[ -d "${CACHE_DIRECTORY}" ]]; then
            echo "Deleting cache directory: ${CACHE_DIRECTORY}"
            rm -rf "${CACHE_DIRECTORY}"
        fi
    done
fi

echo "Debug: Will run Fraytools with the following arguments: ${EXTRA_ARGS[@]}"
echo "Debug: Additionally, user gave: $@"

export FLATPAK_ID="${FLATPAK_ID:-io.gitlab.shifterbit.Fraytools}"
export TMPDIR="${XDG_RUNTIME_DIR}/app/${FLATPAK_ID}"

# Discord RPC
for i in {0..9}; do
    test -S "$XDG_RUNTIME_DIR"/"discord-ipc-$i" || ln -sf {app/com.discordapp.Discord,"$XDG_RUNTIME_DIR"}/"discord-ipc-$i";
done

ELECTRON_ENABLE_LOGGING=true
ELECTRON_RUN_AS_NODE=true
zypak-wrapper /app/FrayTools $@ ${EXTRA_ARGS[@]} --no-sandbox
