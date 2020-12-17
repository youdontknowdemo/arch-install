#!/bin/bash

# ------------------------------------------------------------------------

sudo pacman -S --noconfirm base-devel pacman-contrib curl
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
echo -e "Setting up mirrors for optimal download ..."
cat /etc/pacman.d/mirrorlist | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 8 -m 6 - >$HOME/mirrorlist
sudo mv $HOME/mirrorlist /etc/pacman.d/mirrorlist

# ------------------------------------------------------------------------
echo -e "\nInstalling Base System\n"

PKGS=(

    # --- XORG Display Rendering
    \
    'xorg'         # Base Package
    'xorg-drivers' # Display Drivers
    'xterm'        # Terminal for TTY
    'xorg-server'  # XOrg server
    'xorg-apps'    # XOrg apps group
    'xorg-xinit'   # XOrg init
    'xorg-xinput'  # Xorg xinput
    'mesa'         # Open source version of OpenGL

    # --- Setup Desktop
    \
    'xfce4-power-manager' # Power Manager
    'rofi'                # Menu System
    'picom'               # Translucent Windows
    'xclip'               # System Clipboard
    'gnome-polkit'        # Elevate Applications
    'lxappearance'        # Set System Themes

    # --- Networking Setup
    \
    'wpa_supplicant'         # Key negotiation for WPA wireless networks
    'dialog'                 # Enables shell scripts to trigger dialog boxex
    'openvpn'                # Open VPN support
    'networkmanager-openvpn' # Open VPN plugin for NM
    'network-manager-applet' # System tray icon/utility for network connectivity
    'libsecret'              # Library for storing passwords

    # --- Audio
    \
    'alsa-utils'      # Advanced Linux Sound Architecture (ALSA) Components https://alsa.opensrc.org/
    'alsa-plugins'    # ALSA plugins
    'pulseaudio'      # Pulse Audio sound components
    'pulseaudio-alsa' # ALSA configuration for pulse audio
    'pavucontrol'     # Pulse Audio volume control
    'pnmixer'         # System tray volume control

    # --- Bluetooth
    \
    'bluez'                # Daemons for the bluetooth protocol stack
    'bluez-utils'          # Bluetooth development and debugging utilities
    'bluez-firmware'       # Firmwares for Broadcom BCM203x and STLC2300 Bluetooth chips
    'blueberry'            # Bluetooth configuration tool
    'pulseaudio-bluetooth' # Bluetooth support for PulseAudio

    # TERMINAL UTILITIES --------------------------------------------------
    \
    'cronie'          # cron jobs
    'file-roller'     # Archive utility
    'gtop'            # System monitoring via terminal
    'hardinfo'        # Hardware info app
    'htop'            # Process viewer
    'neofetch'        # Shows system info when you launch terminal
    'ntp'             # Network Time Protocol to set time via network.
    'openssh'         # SSH connectivity tools
    'p7zip'           # 7z compression program
    'rsync'           # Remote file sync utility
    'speedtest-cli'   # Internet speed via terminal
    'terminus-font'   # Font package with some bigger fonts for login terminal
    'unrar'           # RAR compression program
    'unzip'           # Zip compression program
    'wget'            # Remote content retrieval
    'terminator'      # Terminal emulator
    'vim'             # Terminal Editor
    'zenity'          # Display graphical dialog boxes via shell scripts
    'zip'             # Zip compression program
    'zsh'             # ZSH shell
    'zsh-completions' # Tab completion for ZSH

    # DISK UTILITIES ------------------------------------------------------
    \
    'android-tools'         # ADB for Android
    'android-file-transfer' # Android File Transfer
    'autofs'                # Auto-mounter
    'btrfs-progs'           # BTRFS Support
    'dosfstools'            # DOS Support
    'exfat-utils'           # Mount exFat drives
    'gparted'               # Disk utility
    'gvfs-mtp'              # Read MTP Connected Systems
    'gvfs-smb'              # More File System Stuff
    'nautilus-share'        # File Sharing in Nautilus
    'ntfs-3g'               # Open source implementation of NTFS file system
    'parted'                # Disk utility
    'samba'                 # Samba File Sharing
    'smartmontools'         # Disk Monitoring
    'smbclient'             # SMB Connection
    'xfsprogs'              # XFS Support

    # GENERAL UTILITIES ---------------------------------------------------
    \
    'flameshot'    # Screenshots
    'freerdp'      # RDP Connections
    'libvncserver' # VNC Connections
    'nautilus'     # Filesystem browser
    'remmina'      # Remote Connection
    'veracrypt'    # Disc encryption utility
    'variety'      # Wallpaper changer

    # DEVELOPMENT ---------------------------------------------------------
    \
    'ccache'   # Compiler cacher
    'clang'    # C Lang compiler
    'cmake'    # Cross-platform open-source make system
    'code'     # Visual Studio Code
    'electron' # Cross-platform development using Javascript
    'git'      # Version control system
    'gcc'      # C/C++ compiler
    'glibc'    # C libraries
    'meld'     # File/directory comparison
    'nodejs'   # Javascript runtime environment
    'npm'      # Node package manager
    'python'   # Scripting language
    'yarn'     # Dependency management (Hyper needs this)

    # MEDIA ---------------------------------------------------------------
    \
    'kdenlive'   # Movie Render
    'obs-studio' # Record your screen
    'celluloid'  # Video player

    # GRAPHICS AND DESIGN -------------------------------------------------
    \
    'gcolor2'   # Colorpicker
    'gimp'      # GNU Image Manipulation Program
    'ristretto' # Multi image viewer

    # PRODUCTIVITY --------------------------------------------------------
    \
    'xpdf' # PDF viewer

)

for PKG in "${PKGS[@]}"; do
    echo -e "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo -e "\nDone!\n"

# ------------------------------------------------------------------------

echo -e "Make pacman and yay colorful and adds eye candy on the progress bar"
grep -q "^Color" /etc/pacman.conf || sudo sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# ------------------------------------------------------------------------

echo -e "Use all cores for compilation"
sudo sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# ------------------------------------------------------------------------

echo -e "Setup language to en_GB and set locale"
sudo sed -i 's/^#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
sudo timedatectl --no-ask-password set-ntp 1
localectl --no-ask-password set-locale LANG="en_GB.UTF-8" LC_TIME="en_GB.UTF-8"

# ------------------------------------------------------------------------

echo -e "Add sudo rights"
sudo sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
echo -e "Add sudo no password rights"
sudo sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# ------------------------------------------------------------------------

echo -e "\nFINAL SETUP AND CONFIGURATION"

# ------------------------------------------------------------------------

echo -e "\nConfiguring vconsole.conf to set a larger font for login shell"

echo -e 'FONT=ter-v32b' | sudo tee -a /etc/vconsole.conf

# ------------------------------------------------------------------------

echo -e "\nIncreasing file watcher count"

# This prevents a "too many files" error in Visual Studio Code
echo -e fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

# ------------------------------------------------------------------------

echo -e "\nDisabling Pulse .esd_auth module"

# Pulse audio loads the `esound-protocol` module, which best I can tell is rarely needed.
# That module creates a file called `.esd_auth` in the home directory which I'd prefer to not be there. So...
sudo sed -i 's|load-module module-esound-protocol-unix|#load-module module-esound-protocol-unix|g' /etc/pulse/default.pa

# Start/restart PulseAudio.
killall pulseaudio
sudo -u $USER pulseaudio --start

# ------------------------------------------------------------------------

echo -e "\nEnabling Login Display Manager"

sudo systemctl enable --now lightdm.service

# ------------------------------------------------------------------------

echo -e "\nDisabling bluetooth daemon by comment it"

sudo sed -i 's|AutoEnable|#AutoEnable|g' /etc/bluetooth/main.conf

# ------------------------------------------------------------------------

# Prevent stupid error beeps
sudo rmmod pcspkr
echo -e "blacklist pcspkr" | sudo tee -a /etc/modprobe.d/nobeep.conf

# ------------------------------------------------------------------------

# Make zsh the default shell for the user.
chsh -s /bin/zsh $USER >/dev/null 2>&1
sudo -u $USER mkdir -p "/home/$USER/.cache/zsh/"
read -p $'PRESS [ENTER] TO CONTINUE ' && clear
# ------------------------------------------------------------------------

echo "
###############################################################################
# Cleaning
###############################################################################
"

echo -e "Remove no password sudo rights"
sudo sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
echo -e "Clean orphans pkg"
if [[ ! -n $(pacman -Qdt) ]]; then
    echo "No orphans to remove."
else
    sudo pacman -Rns $(pacman -Qdtq)
fi

# ------------------------------------------------------------------------

echo -e "
###############################################################################
# All done! Would you also mind to run the author's ultra-gaming-setup-wizard? 
###############################################################################
"

extra() {
    curl https://raw.githubusercontent.com/YurinDoctrine/ultra-gaming-setup-wizard/main/ultra-gaming-setup-wizard.sh >ultra-gaming-setup-wizard.sh &&
        chmod 755 ultra-gaming-setup-wizard.sh &&
        ./ultra-gaming-setup-wizard.sh
}

final() {
    read -p $'yes\no>: ' ans
    if [[ "$ans" == "yes" ]]; then
        echo -e 'RUNNING ...\n'
        extra
    elif [[ "$ans" == "no" ]]; then
        echo -e 'LEAVING ...\n'
        exit 1
    else
        echo -e 'INVALID VALUE!\n'
        final
    fi
}
final
