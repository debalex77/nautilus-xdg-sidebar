![Linux](https://img.shields.io/badge/Linux-Debian%2013-red)
![GNOME](https://img.shields.io/badge/GNOME-48-4A86CF)
![Downloads](https://img.shields.io/github/downloads/debalex77/nautilus-xdg-sidebar/total)

# Nautilus XDG Sidebar

Restore native XDG user directories in the GNOME Files (Nautilus) sidebar with a configurable GSettings preference.

The patch restores the following locations as built-in sidebar entries:
 * Documents
 * Downloads
 * Pictures
 * Music
 * Videos

Unlike bookmarks, these locations behave as native sidebar entries.

<img width="637" height="99" alt="2026-07-15_21-43" src="https://github.com/user-attachments/assets/d6b00bb7-6055-4983-98d9-be81d23b2028" />

## ✨ Features
Restores XDG user directories as native sidebar locations.
Adds a new Preferences switch:
Show user folders in the sidebar
Sidebar updates immediately when the preference changes.
Uses a standard Debian source build workflow.
Produces local Debian packages with a custom version suffix (for example 48.3-2+xdg1).

Supported base:
- Debian 13 (Trixie)
- Nautilus 48.3-2

## ⚠️ Requirements

Enable Debian source repositories (deb-src).

Install the required tools:

```
sudo apt update
sudo apt install build-essential devscripts dpkg-dev fakeroot
```

## 📚 Files

- `nautilus-xdg-sidebar.patch` — your patch
- `build.sh` — downloads the Debian source, applies the patch and builds local packages
- `install.sh` — installs the matching local packages
- `verify.sh` — checks package names, versions and architectures
- `realease.sh` - automates the complete release process.

## 📦 Build

```bash
./build.sh
```

Without installing build dependencies automatically:

```bash
./build.sh --no-build-dep
```

Choose another local suffix:

```bash
LOCAL_SUFFIX=+xdg2 ./build.sh
```

Packages are copied into `dist/`.

## ✔️ Verify

```bash
./verify.sh
```

## 🔧 Install

```bash
sudo ./install.sh
```

Then reopen Files. The installer attempts `nautilus -q` for the invoking desktop user.

## 💥 Release

```bash
sudo ./release.sh
```

Automates the complete release process.
It performs the following steps:

 * Runs build.sh
 * Verifies the generated packages
 * Installs the packages
 * Generates SHA256SUMS
 * Creates CHANGELOG.md
 * Copies all generated packages into release/
 * Creates a release archive (tar.gz)

## ⚙️ GSettings

```bash
gsettings get org.gnome.nautilus.preferences show-xdg-user-directories
gsettings set org.gnome.nautilus.preferences show-xdg-user-directories false
gsettings set org.gnome.nautilus.preferences show-xdg-user-directories true
```

A local version such as `48.3-2+xdg1` is newer than `48.3-2`, but older than a future `48.3-3`.

## ⚖️ Licensing

The build scripts and documentation in this repository are licensed under the MIT License.

The included patch contains modifications intended for GNOME Files (Nautilus), which is licensed under the GNU General Public License (GPL). 
This repository does not redistribute the Nautilus source code. Users download the official Debian source package during the build process.


This repository contains build scripts and a patch for GNOME Files (Nautilus).
This is an unofficial patch for GNOME Files (Nautilus).
It is not affiliated with or endorsed by the GNOME Project.
