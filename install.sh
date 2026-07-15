#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$PROJECT_DIR/dist"

[[ $EUID -eq 0 ]] || {
    echo "Run: sudo ./install.sh" >&2
    exit 1
}

[[ -d "$DIST_DIR" ]] || {
    echo "Run ./build.sh first." >&2
    exit 1
}

mapfile -t PACKAGES < <(
    find "$DIST_DIR" -maxdepth 1 -type f \
        \( -name 'nautilus_*.deb' \
        -o -name 'nautilus-data_*.deb' \
        -o -name 'libnautilus-extension4_*.deb' \) \
        ! -name '*dbgsym*' -print | sort
)

(( ${#PACKAGES[@]} > 0 )) || {
    echo "No installable packages found." >&2
    exit 1
}

declare -A VERSIONS=()
for package in "${PACKAGES[@]}"; do
    name="$(dpkg-deb -f "$package" Package)"
    VERSIONS["$name"]="$(dpkg-deb -f "$package" Version)"
done

for required in nautilus nautilus-data libnautilus-extension4; do
    [[ -n "${VERSIONS[$required]:-}" ]] || {
        echo "Missing package: $required" >&2
        exit 1
    }
done

if [[ "${VERSIONS[nautilus]}" != "${VERSIONS[nautilus-data]}" ||
      "${VERSIONS[nautilus]}" != "${VERSIONS[libnautilus-extension4]}" ]]; then
    echo "Package versions do not match:" >&2
    for name in nautilus nautilus-data libnautilus-extension4; do
        printf '  %-28s %s\n' "$name" "${VERSIONS[$name]}"
    done
    exit 1
fi

apt-get install -y "${PACKAGES[@]}"

desktop_user="${SUDO_USER:-}"
if [[ -n "$desktop_user" && "$desktop_user" != root ]]; then
    runuser -u "$desktop_user" -- nautilus -q 2>/dev/null || true
fi

dpkg-query -W -f='${Package}\t${Version}\n' \
    nautilus nautilus-data libnautilus-extension4

echo "Installation complete. Reopen GNOME Files."
