![Linux](https://img.shields.io/badge/Linux-Debian%2013-red)
![GNOME](https://img.shields.io/badge/GNOME-48-4A86CF)
![License](https://img.shields.io/github/license/debalex77/nautilus-xdg-sidebar)
![Release](https://img.shields.io/github/v/release/debalex77/nautilus-xdg-sidebar)
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

<img width="907" height="249" alt="2026-07-15_23-35" src="https://github.com/user-attachments/assets/1f7d3018-37c6-4d4c-9d6c-6da1f6926771" />


<img width="910" height="445" alt="2026-07-15_23-34" src="https://github.com/user-attachments/assets/b9518c56-f08d-45af-a8a8-6d84ac20e8f5" />

## ⚠️ Disclaimer

This is an unofficial patch for GNOME Files (Nautilus).
It is not affiliated with, endorsed by, or maintained by the GNOME Project.
The repository does not redistribute Nautilus source code. During the build process, the official Debian Nautilus source package is downloaded and patched locally.

## ✨ Features

- Restores XDG user directories as native sidebar locations.
- Adds a new **Preferences** switch:
  - **Show user folders in the sidebar**
- Updates the sidebar immediately when the preference changes.
- Uses a standard Debian source build workflow.
- Produces local Debian packages with a custom version suffix (for example `48.3-2+xdg1`).

## 💡 Motivation

Recent versions of GNOME Files (Nautilus) no longer display the standard XDG user directories (Documents, Downloads, Pictures, Music and Videos) as native sidebar locations.

For many users, these directories are part of their daily workflow and are expected to behave as built-in locations rather than bookmarks.

This project restores that functionality while keeping it fully optional through a new preference:
 * **Show user folders in the sidebar**

The goal is not to change the default GNOME experience, but to provide an easy-to-maintain alternative for users who prefer the traditional sidebar layout.

## ✅ Supported Version

- Debian 13 (Trixie)
- Nautilus 48.3-2

## 📖 Requirements

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
- `release.sh` - automates the complete release process.

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
./release.sh
```

The script automates the complete release process by:

- Running `build.sh`
- Verifying the generated packages
- Installing the packages
- Generating `SHA256SUMS`
- Creating `CHANGELOG.md`
- Copying all generated packages into `release/`
- Creating a release archive (`tar.gz`)

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
This repository does not redistribute Nautilus source code. Users download the official Debian source package during the build process.
This project is not affiliated with or endorsed by the GNOME Project.
