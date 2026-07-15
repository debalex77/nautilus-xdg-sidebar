#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$PROJECT_DIR/dist"
RELEASE_DIR="$PROJECT_DIR/release"
LOCAL_SUFFIX="${LOCAL_SUFFIX:-+xdg1}"

command -v sha256sum >/dev/null || { echo "sha256sum not found"; exit 1; }
command -v tar >/dev/null || { echo "tar not found"; exit 1; }

echo "=== Building packages ==="
"$PROJECT_DIR/build.sh" "$@"

mkdir -p "$RELEASE_DIR"
rm -f "$RELEASE_DIR"/*

echo "=== Verifying packages ==="
"$PROJECT_DIR/verify.sh"

echo "=== Installing packages ==="
sudo "$PROJECT_DIR/install.sh"

echo "=== Creating SHA256SUMS ==="
(
    cd "$DIST_DIR"
    sha256sum *.deb > "$RELEASE_DIR/SHA256SUMS"
)

VERSION="$(
find "$DIST_DIR" -maxdepth 1 -name 'nautilus_*.deb' \
| head -n1 \
| sed -E 's/.*nautilus_([^_]+)_.*/\1/'
)"

cat > "$RELEASE_DIR/CHANGELOG.md" <<EOF
# Release $VERSION

## Features

- Restores native XDG user directories in the Nautilus sidebar.
- Adds the preference:
  - Show user folders in the sidebar
- Adds live sidebar refresh when the preference changes.

Generated automatically by release.sh.
EOF

ARCHIVE="$RELEASE_DIR/nautilus-xdg-sidebar-${VERSION}.tar.gz"

echo "=== Creating release archive ==="
tar \
    --exclude='./work' \
    --exclude='./dist' \
    --exclude='./release' \
    -czf "$ARCHIVE" \
    -C "$PROJECT_DIR" .

cp "$DIST_DIR"/*.deb "$RELEASE_DIR"/

echo
echo "Release created:"
echo "  $RELEASE_DIR"
echo
ls -lh "$RELEASE_DIR"
