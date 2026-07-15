#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$PROJECT_DIR/dist"

mapfile -t PACKAGES < <(
    find "$DIST_DIR" -maxdepth 1 -type f -name '*.deb' \
        ! -name '*dbgsym*' -print 2>/dev/null | sort
)

(( ${#PACKAGES[@]} > 0 )) || {
    echo "No packages found in dist/." >&2
    exit 1
}

printf '%-32s %-24s %-8s\n' PACKAGE VERSION ARCH
for package in "${PACKAGES[@]}"; do
    printf '%-32s %-24s %-8s\n' \
        "$(dpkg-deb -f "$package" Package)" \
        "$(dpkg-deb -f "$package" Version)" \
        "$(dpkg-deb -f "$package" Architecture)"
done

for required in nautilus nautilus-data libnautilus-extension4; do
    found=false
    for package in "${PACKAGES[@]}"; do
        [[ "$(dpkg-deb -f "$package" Package)" == "$required" ]] && found=true
    done
    [[ "$found" == true ]] || {
        echo "Missing: $required" >&2
        exit 1
    }
done

echo "Required package set is complete."
