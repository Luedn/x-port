# X-Console OS Gaming Edition (v0.3 source build)

An original, controller-first Linux gaming environment for ordinary x86-64 PCs. It is inspired by the convenience of a living-room console, but it does not contain Microsoft Xbox OS code, assets, or proprietary console software.

## v0.4 networking additions

- **Wi-Fi:** NetworkManager, WPA supplicant, iwd, `iw`, rfkill, and firmware packages for common Intel, Realtek, Atheros, Broadcom, Marvell/Libertas, TI, and other supported chipsets.
- **Ethernet:** standard in-kernel Linux drivers plus diagnostic tools (`ethtool`, `iproute2`, `ping`, DNS utilities). Most PCIe and USB Ethernet adapters supported by the Linux kernel should work without separate vendor installers.
- **Network UI:** NetworkManager tray applet, connection editor, Wi-Fi scanning, saved networks, Ethernet, VPN profile support, and a Network & Internet shortcut.
- **Diagnostics:** `nmcli device`, `rfkill list`, `ip link`, and `ethtool` are available for troubleshooting.

## v0.3 additions

- **Broad controller support:** Linux HID/kernel drivers plus SDL2/Pygame input. Targets common Xbox, PlayStation, Switch Pro, and generic USB/Bluetooth HID gamepads. Multiple connected devices are enumerated. `jstest-gtk` and `evtest` are included for diagnosis. No OS can guarantee every obscure controller or wireless adapter works; button layouts and rumble vary by device.
- **Steam install/launch:** the dashboard's Steam tile launches Steam if present; otherwise it starts the Debian `steam-installer` flow, enables i386 multiarch, and installs Steam from Debian's configured contrib/non-free repositories. Internet access is required. Steam is proprietary software and is downloaded at install time, not redistributed in this source archive.
- **Xbox Cloud Gaming:** Chromium is included, with a fullscreen app-style launcher for `https://www.xbox.com/play`. A Microsoft/Xbox account, supported browser/device/region, suitable network connection, and any required subscription are the user's responsibility. Cloud Gaming is a web service, not a native installed Xbox app.
- **Optional emulators:** the Emulators tile offers installation of RetroArch, Dolphin, PPSSPP, and PCSX2 when packages are available in the enabled Debian repositories. Emulator availability varies by Debian release and repository. The user supplies their own legally obtained game files and any firmware/BIOS files they are entitled to use.
- **USB game library:** removable media mounted under `/media`, `/run/media`, or `/mnt` is scanned for common game-file extensions. The user chooses a file and an installed emulator. USB media is not reformatted or modified by the scanner. Filesystem automount uses UDisks/GVFS/Thunar.
- **USB insertion notifications:** a small user-session watcher notifies when a removable drive is mounted. Open USB Games to rescan it.

## Network compatibility notes

The goal is broad coverage, not a guarantee for every adapter. Linux kernel drivers handle most common Ethernet controllers (Intel, Realtek, Broadcom, Aquantia/Marvell and many USB adapters). Wi-Fi requires both a supported kernel driver and the matching firmware; some Broadcom proprietary `wl` devices and obscure USB dongles may need a separately selected driver or may not work. Secure Boot, very new chipsets, and vendor-specific Windows-only adapters can also limit support. A wired Ethernet connection is the best fallback for first boot and Steam downloads. Use `rfkill list` to check airplane-mode/radio blocks. NetworkManager handles connection setup; the tray applet appears when the desktop session starts.

## Main dashboard

Six controller-friendly tiles: Steam, Xbox Cloud, USB Games, Emulators, Settings, and Power. Navigation supports keyboard, D-pad/hat, common analog sticks, and the common south/confirm button. Pygame/SDL raw input is broad rather than universal; unusual layouts may require a remapping utility or per-device configuration.

## Important limitations and safety

- This is a source/build prototype, not a tested commercial OS or a finished ISO. Test in a VM and on spare hardware before daily use.
- The build targets Debian 12 Bookworm amd64 and a hybrid ISO for legacy BIOS + UEFI boot. MBR/GPT behavior depends on firmware and the installer. Secure Boot support varies by hardware and signed boot components.
- Steam installation requires a working network connection and Debian repositories configured with `contrib` and `non-free` components. Steam is not pre-downloaded into the ISO.
- Xbox Cloud Gaming opens the official website in Chromium; it cannot bypass subscription, regional, account, or browser/device requirements.
- USB scanning only indexes files on already-mounted paths. Thunar/GVFS/UDisks normally mount removable volumes after insertion. If a drive does not auto-mount, open File Manager and mount it first.
- Emulator package availability varies. Some systems or cores may require user-supplied firmware/BIOS. Only use game images and firmware you are legally entitled to use.
- The USB library supports common extensions, not every console format. Some extensions (especially `.iso`, `.bin`, `.cue`, and `.chd`) are ambiguous and may require choosing an emulator manually.
- A 32 GB USB is suitable for the OS and testing, but not a substantial game library. Use a separate SSD or larger external drive for games.
- Internal-drive installation is launched from the boot menu through Debian Live Installer. It can erase the selected target disk; back up data and verify the selected drive carefully.

## Build requirements

Build on Debian 12 or a compatible Debian-based system with internet access, at least 25 GB free disk space, and root/sudo access. The script installs `live-build`, `debootstrap`, `squashfs-tools`, and `xorriso` if needed.

```bash
cd x-console-os
sudo ./build.sh
```

The generated ISO is copied to `out/x-console-os-amd64.hybrid.iso`, with a SHA-256 checksum in `out/SHA256SUMS`.

## Flashing

- **Rufus:** select the ISO. If asked, use DD mode to preserve the hybrid image layout. Do not force a single partition scheme if you want hybrid BIOS/UEFI behavior.
- **balenaEtcher:** select the same ISO and flash it directly. Etcher writes the hybrid image as-is.
- Both methods erase the USB. Verify the target device before writing.

## Boot and use

1. Boot the USB using the PC's one-time boot menu. Choose the UEFI USB entry on UEFI systems or the legacy entry on BIOS systems.
2. Select Live mode to run from USB, or the installer entry to install to an internal drive.
3. Connect a controller by USB or Bluetooth. The dashboard also accepts keyboard and mouse input.
4. Use the Network & Internet shortcut or tray icon to connect Wi-Fi/Ethernet. Select Steam to install/launch Steam; Xbox Cloud to open the official cloud-gaming website; USB Games to scan mounted removable drives; Emulators to install optional emulator packages.

## Project status

The v0.4 source includes expanded Wi-Fi/Ethernet firmware and diagnostics, NetworkManager UI integration, plus the v0.3 build configuration, dashboard, launchers, installer helpers, USB scanner/watcher, and documentation. Syntax and archive checks are performed on the source package. ISO compilation, package resolution, actual boot tests, controller compatibility tests, and game-launch tests still need to be performed on a Debian build host and real hardware.
