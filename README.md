# Nautilus XDG Sidebar

Restores Documents, Downloads, Pictures, Music and Videos as native locations in the GNOME Files sidebar and adds a visible GSettings switch.

Supported base:
- Debian 13 (Trixie)
- Nautilus 48.3-2

## Files

- `nautilus-xdg-sidebar.patch` — your patch
- `build.sh` — downloads the Debian source, applies the patch and builds local packages
- `install.sh` — installs the matching local packages
- `verify.sh` — checks package names, versions and architectures

## Prepare

Copy your patch over the placeholder:

```bash
cp ~/src/nautilus-xdg-sidebar.patch ./nautilus-xdg-sidebar.patch
chmod +x build.sh install.sh verify.sh
```

Enable `deb-src`, then:

```bash
sudo apt update
sudo apt install build-essential devscripts dpkg-dev fakeroot
```

## Build

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

## Verify

```bash
./verify.sh
```

## Install

```bash
sudo ./install.sh
```

Then reopen Files. The installer attempts `nautilus -q` for the invoking desktop user.

## GSettings

```bash
gsettings get org.gnome.nautilus.preferences show-xdg-user-directories
gsettings set org.gnome.nautilus.preferences show-xdg-user-directories false
gsettings set org.gnome.nautilus.preferences show-xdg-user-directories true
```

A local version such as `48.3-2+xdg1` is newer than `48.3-2`, but older than a future `48.3-3`.
