#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PATCH_FILE="$PROJECT_DIR/nautilus-xdg-sidebar.patch"
WORK_DIR="$PROJECT_DIR/work"
DIST_DIR="$PROJECT_DIR/dist"
LOCAL_SUFFIX="${LOCAL_SUFFIX:-+xdg1}"
INSTALL_BUILD_DEPS=true

usage() {
    echo "Usage: $0 [--no-build-dep]"
    echo "Environment: LOCAL_SUFFIX=+xdg1"
}

for arg in "$@"; do
    case "$arg" in
        --no-build-dep) INSTALL_BUILD_DEPS=false ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown argument: $arg" >&2; usage >&2; exit 2 ;;
    esac
done

[[ -f "$PATCH_FILE" ]] || { echo "Patch not found: $PATCH_FILE" >&2; exit 1; }

for cmd in apt-get apt-cache dpkg-parsechangelog dpkg-buildpackage patch dch; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Required command not found: $cmd" >&2
        exit 1
    }
done

if [[ "$INSTALL_BUILD_DEPS" == true ]]; then
    sudo apt-get update
    sudo apt-get build-dep -y nautilus
    sudo apt-get install -y build-essential devscripts dpkg-dev fakeroot
fi

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR" "$DIST_DIR"
rm -f "$DIST_DIR"/*.deb

cd "$WORK_DIR"

SOURCE_VERSION="$(
    apt-cache showsrc nautilus 2>/dev/null |
    awk '/^Version: / { print $2; exit }'
)"

[[ -n "$SOURCE_VERSION" ]] || {
    echo "Cannot determine Nautilus source version. Enable deb-src." >&2
    exit 1
}

echo "Downloading source: nautilus $SOURCE_VERSION"
apt-get source "nautilus=$SOURCE_VERSION"

SOURCE_DIR="$(
    find "$WORK_DIR" -mindepth 1 -maxdepth 1 -type d -name 'nautilus-*' |
    sort | head -n1
)"

[[ -n "$SOURCE_DIR" && -d "$SOURCE_DIR/debian" ]] || {
    echo "Nautilus source directory not found." >&2
    exit 1
}

cd "$SOURCE_DIR"

echo "Checking patch..."
patch --dry-run -p1 < "$PATCH_FILE"

echo "Applying patch..."
patch -p1 < "$PATCH_FILE"

CURRENT_VERSION="$(dpkg-parsechangelog -S Version)"
if [[ "$CURRENT_VERSION" != *"$LOCAL_SUFFIX"* ]]; then
    dch --local "$LOCAL_SUFFIX" --distribution UNRELEASED \
        "Restore native XDG user directories in the sidebar and add a GSettings preference."
fi

LOCAL_VERSION="$(dpkg-parsechangelog -S Version)"
echo "Building version: $LOCAL_VERSION"

DEB_BUILD_OPTIONS="${DEB_BUILD_OPTIONS:-nocheck}" \
    dpkg-buildpackage -b -uc -us

cd "$WORK_DIR"

mapfile -t PACKAGES < <(
    find "$WORK_DIR" -maxdepth 1 -type f \
        -name "*_${LOCAL_VERSION}_*.deb" \
        ! -name '*dbgsym*' -print | sort
)

(( ${#PACKAGES[@]} > 0 )) || {
    echo "No Debian packages were produced." >&2
    exit 1
}

for package in "${PACKAGES[@]}"; do
    cp -v "$package" "$DIST_DIR/"
done

echo
echo "Build completed: $LOCAL_VERSION"
find "$DIST_DIR" -maxdepth 1 -type f -name '*.deb' -printf '  %f\n' | sort
echo
echo "Next: sudo ./install.sh"
