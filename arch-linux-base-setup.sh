#!/usr/bin/env bash
# Before hop in
sudo pacman -Syy &&
    sudo pacman -S --needed --noconfirm 9base base-devel kitty pacman-contrib psmisc pulseaudio networkmanager systemd git go xorg-server &&
    sudo pacman -S --needed --noconfirm yay

# ------------------------------------------------------------------------

# Setting up locales
echo -e "LANG=en_GB.UTF8" | sudo tee -a /etc/locale.conf
echo -e "LANG=en_GB.UTF8" | sudo tee -a /etc/environment
echo -e "LC_ALL=en_GB.UTF8" | sudo tee -a /etc/environment
sudo sed -i -e 's/^#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen en_GB.UTF-8
localectl set-locale LANG=en_GB.UTF-8 LC_TIME=en_GB.UTF-8

# ------------------------------------------------------------------------

# Ranking mirrors
sudo cp -R /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
echo -e "Setting up mirrors for optimal download ..."
cat /etc/pacman.d/mirrorlist | rankmirrors -n 5 -m 3 - >$HOME/mirrorlist
sudo mv $HOME/mirrorlist /etc/pacman.d/mirrorlist

# ------------------------------------------------------------------------

# Install yay if its still not
which yay >/dev/null 2>&1
if [ $? != 0 ]; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd /tmp
fi

# ------------------------------------------------------------------------

# Colorful progress bar
echo -e "Make pacman and yay colorful and adds eye candy on the progress bar"
grep -q "^Color" /etc/pacman.conf || sudo sed -i -e "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i -e "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# ------------------------------------------------------------------------

# All cores for compilation
echo -e "Use all cores for compilation"
sudo sed -i -e "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

# ------------------------------------------------------------------------

# This may take time
echo -e "Installing Base System"

PKGS=(
    # --- Importants

    'xwallpaper'         # A lightweight and simple desktop background setter for X Window
    'xcompmgr'           # A simple composite manager
    'mate-power-manager' # MATE Power Manager
    'mksh'               # MirBSD Korn Shell
    'dmenu'              # Generic menu for X
    'gmrun'              # A lightweight application launcher
    'gsimplecal'         # A simple, lightweight calendar
    'conky'              # A system monitor software for the X Window System
    'dunst'              # Customizable and lightweight notification-daemon
    'featherpad'         # Lightweight Qt plain text editor
    'openbox'            # A lightweight, powerful, and highly configurable stacking window manager
    'scrot'              # Simple command-line screenshot utility
    'slock'              # A simple screen locker for X
    'udiskie'            # An udisks2 front-end written in python
    'pcmanfm-qt'         # The LXQt file manager
    'ranger'             # A file manager with vi key bindings written in python but with an interface that rocks
    'tint2'              # A simple, unobtrusive and light panel for Xorg
    'lxappearance'       # Set System Themes
    'lxsession'          # LXDE PolicyKit authentication agent
    #'lxdm'               # A lightweight display manager

    # DEVELOPMENT ---------------------------------------------------------

    'ccache'     # Compiler cacher
    'cmake'      # Cross-platform open-source make system
    'meson'      # Build system that use python as a front-end language and Ninja as a building backend
    'python-pip' # The official package installer for Python

    # --- Audio

    'alsaplayer'     # A heavily multi-threaded PCM player
    'pasystray'      # PulseAudio system tray
    'pavucontrol-qt' # PulseAudio volume control Qt port
    'pulsemixer'     # CLI and curses mixer for PulseAudio

    # --- Bluetooth

    'blueman' # GTK+ Bluetooth Manager

    # TERMINAL UTILITIES --------------------------------------------------

    'dialog'        # A tool to display dialog boxes from shell scripts
    'fish'          # The friendly interactive shell
    'htop'          # Interactive process viewer
    'nano'          # A simple console based text editor
    'neofetch'      # Shows system info when you launch terminal
    'irssi'         # Terminal based IRC
    'terminus-font' # Font package with some bigger fonts for login terminal

    # DISK UTILITIES ------------------------------------------------------

    'gparted' # Disk utility

    # GENERAL UTILITIES ---------------------------------------------------

    'arandr'               # Provide a simple visual front end for XRandR
    'bc'                   # An arbitrary precision calculator language
    'engrampa'             # Archive manipulator for MATE
    'filezilla'            # FTP Client
    'nocache'              # Minimize caching effects
    'unclutter'            # A small program for hiding the mouse cursor
    'playerctl'            # Utility to control media players via MPRIS
    'transmission-gtk'     # BitTorrent client
    'preload'              # Makes applications run faster by prefetching binaries and shared objects
    'simplescreenrecorder' # A feature-rich screen recorder that supports X11 and OpenGL

    # GRAPHICS, VIDEO AND DESIGN ------------------------------------------

    'pinta'    # A simplified alternative to GIMP
    'viewnior' # A simple, fast and elegant image viewer
    'vlc'      # A free and open source cross-platform multimedia player and framework

    # PRINTING ------------------------------------------------------------

    'abiword'               # Fully-featured word processor
    'atril'                 # PDF viewer
    'cups'                  # The CUPS Printing System - daemon package
    'gnumeric'              # A powerful spreadsheet application
    'system-config-printer' # A CUPS printer configuration tool and status applet

)

for PKG in "${PKGS[@]}"; do
    echo -e "INSTALLING: ${PKG}"
    yay -S --noconfirm --needed "$PKG"
done

echo -e "Done!"

# ------------------------------------------------------------------------

echo -e "FINAL SETUP AND CONFIGURATION"

# Sudo rights
echo -e "Add sudo rights"
sudo sed -i -e 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
echo -e "Remove no password sudo rights"
sudo sed -i -e 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# ------------------------------------------------------------------------

echo -e "Configuring vconsole.conf to set a larger font for login shell"
echo -e "FONT=ter-v32b" | sudo tee /etc/vconsole.conf

# ------------------------------------------------------------------------

echo -e "Setting laptop lid close to suspend"
sudo sed -i -e 's|#HandleLidSwitch=suspend|HandleLidSwitch=suspend|g' /etc/systemd/logind.conf

# ------------------------------------------------------------------------

echo "Disabling buggy cursor inheritance"
# When you boot with multiple monitors the cursor can look huge. This fixes that...
echo -e "[Icon Theme]
#Inherits=Theme
" | sudo tee /usr/share/icons/default/index.theme

# ------------------------------------------------------------------------

echo -e "Increasing file watcher count"
# This prevents a "too many files" error in Visual Studio Code
echo -e "fs.inotify.max_user_watches=524288" | sudo tee /etc/sysctl.d/40-max-user-watches.conf &&
    sudo sysctl --system

# ------------------------------------------------------------------------

echo -e "Disabling Pulse .esd_auth module"
sudo killall -9 pulseaudio
# Pulse audio loads the `esound-protocol` module, which best I can tell is rarely needed.
# That module creates a file called `.esd_auth` in the home directory which I'd prefer to not be there. So...
sudo sed -i -e 's|load-module module-esound-protocol-unix|#load-module module-esound-protocol-unix|g' /etc/pulse/default.pa
# Restart PulseAudio.
sudo killall -HUP pulseaudio

# ------------------------------------------------------------------------

# Prevent stupid error beeps*
sudo rmmod pcspkr
echo -e "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

# ------------------------------------------------------------------------

echo -e "Disable bluez daemon(opt-out)"
sudo systemctl disable --now bluetooth.service

# ------------------------------------------------------------------------

echo -e "Disable cups daemon(opt-out)"
sudo systemctl disable --now cups.service

# ------------------------------------------------------------------------

echo -e "Remove snapd and flatpak garbages"
sudo snap remove snap-store
sudo systemctl disable --now snapd
sudo umount /run/snap/ns
sudo systemctl disable snapd.service
sudo systemctl disable snapd.socket
sudo systemctl disable snapd.seeded.service
sudo systemctl disable snapd.autoimport.service
sudo systemctl disable snapd.apparmor.service
sudo rm -f /etc/apparmor.d/usr.lib.snapd.snap-confine.real
sudo pacman -Rns --noconfirm snapd
sudo rm -rfd $HOME/snap
sudo rm -rfd /snap
sudo rm -rfd /var/snap
sudo rm -rfd /var/lib/snapd
sudo rm -rfd /var/cache/snapd
sudo rm -rfd /usr/lib/snapd

flatpak uninstall --all

sudo pacman -Rns --noconfirm flatpak

# ------------------------------------------------------------------------

echo -e "Clear the patches"
sudo rm -rfd $HOME/.cache/thumbnails
sudo pacman -Sc --noconfirm
sudo pacman -Scc --noconfirm
sudo pacman -Qtdq &&
    sudo pacman -Rns --noconfirm $(pacman -Qtdq)

# ------------------------------------------------------------------------

# Don't reserve space man-pages, locales, licenses.
echo -e "Remove useless companies"
find /usr/share/doc/ -depth -type f ! -name copyright | xargs sudo rm -f || true
find /usr/share/doc/ | egrep "\.gz" | xargs sudo rm -f
find /usr/share/doc/ | egrep "\.pdf" | xargs sudo rm -f
find /usr/share/doc/ | egrep "\.tex" | xargs sudo rm -f
find /usr/share/doc/ -empty | xargs sudo rmdir || true
sudo rm -rfd /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* \
    /usr/share/linda/* /var/cache/man/* /usr/share/man/*
sync

# ------------------------------------------------------------------------

# Implement .config/ files of the openbox
cd /tmp &&
    git clone --branch 11 https://github.com/CBPP/cbpp-configs.git &&
    sudo cp -R cbpp-configs/cbpp-configs/data/usr/bin/* /usr/bin &&
    sudo rm -rfd /usr/share/icons/CBPP
git clone --branch 11 https://github.com/CBPP/cbpp-icon-theme.git &&
    sudo cp -R cbpp-icon-theme/cbpp-icon-theme/data/usr/share/icons/* /usr/share/icons &&
    sudo rm -rfd /usr/share/themes/CBPP
git clone --branch 11 https://github.com/CBPP/cbpp-ui-theme.git &&
    sudo cp -R cbpp-ui-theme/cbpp-ui-theme/data/usr/share/themes/* /usr/share/themes &&
    sudo mkdir /usr/share/backgrounds
    sudo rm -rfd /usr/share/backgrounds/*
git clone --branch 11 https://github.com/CBPP/cbpp-wallpapers.git &&
    sudo cp -R cbpp-wallpapers/cbpp-wallpapers/data/usr/share/backgrounds/* /usr/share/backgrounds &&
    git clone --branch 11 https://github.com/CBPP/cbpp-lxdm-theme.git &&
    sudo rm -rfd /usr/share/lxdm/themes/*
sudo cp -R cbpp-lxdm-theme/cbpp-lxdm-theme/data/etc/lxdm/* /etc/lxdm
sudo cp -R cbpp-lxdm-theme/cbpp-lxdm-theme/data/usr/share/lxdm/themes/* /usr/share/lxdm/themes
git clone https://github.com/YurinDoctrine/.config.git &&
    sudo cp -R .config/.conkyrc $HOME
sudo cp -R .config/.gmrunrc $HOME
sudo cp -R .config/.gtkrc-2.0 $HOME
sudo cp -R .config/.gtkrc-2.0.mine $HOME
sudo cp -R .config/.fonts.conf $HOME
sudo cp -R .config/.gtk-bookmarks $HOME
sudo cp -R .config/* $HOME/.config
sudo cp -R .config/.conkyrc /etc/skel
sudo cp -R .config/.gmrunrc /etc/skel
sudo cp -R .config/.gtkrc-2.0 /etc/skel
sudo cp -R .config/.gtkrc-2.0.mine /etc/skel
sudo cp -R .config/.fonts.conf /etc/skel
sudo cp -R .config/.gtk-bookmarks /etc/skel
sudo cp -R .config/.conkyrc /root
sudo cp -R .config/.gmrunrc /root
sudo cp -R .config/.gtkrc-2.0 /root
sudo cp -R .config/.gtkrc-2.0.mine /root
sudo cp -R .config/.fonts.conf /root
sudo cp -R .config/.gtk-bookmarks /root
sudo mkdir /etc/skel/.config
sudo cp -R .config/* /etc/skel/.config
sudo mkdir /root/.config
sudo cp -R .config/* /root/.config
sudo chmod 0755 /home/$USER/.config/dmenu/dmenu-bind.sh
sudo chmod 0755 /etc/skel/.config/dmenu/dmenu-bind.sh
sudo chmod 0755 /root/.config/dmenu/dmenu-bind.sh
sudo chmod 0755 /etc/skel/.config/cbpp-exit
sudo chmod 0755 /etc/skel/.config/cbpp-help-pipemenu
sudo chmod 0755 /etc/skel/.config/cbpp-compositor
sudo chmod 0755 /etc/skel/.config/cbpp-places-pipemenu
sudo chmod 0755 /etc/skel/.config/cbpp-recent-files-pipemenu
sudo chmod 0755 /etc/skel/.config/cbpp-welcome
sudo mv /etc/skel/.config/cbpp-exit /usr/bin
sudo mv /etc/skel/.config/cbpp-help-pipemenu /usr/bin
sudo mv /etc/skel/.config/cbpp-compositor /usr/bin
sudo mv /etc/skel/.config/cbpp-include.cfg /usr/bin
sudo mv /etc/skel/.config/cbpp-places-pipemenu /usr/bin
sudo mv /etc/skel/.config/cbpp-recent-files-pipemenu /usr/bin
sudo mv /etc/skel/.config/cbpp-welcome /usr/bin
sudo find /home/$USER/.config/ | egrep "\cbpp-" | xargs sudo rm -f
sudo find /root/.config/ | egrep "\cbpp-" | xargs sudo rm -f

echo -e "XDG_CURRENT_DESKTOP=LXDE
QT_QPA_PLATFORMTHEME=gtk2" | sudo tee -a /etc/environment

# ------------------------------------------------------------------------

extra() {
    curl -fsSL https://raw.githubusercontent.com/YurinDoctrine/ultra-gaming-setup-wizard/main/ultra-gaming-setup-wizard.sh >ultra-gaming-setup-wizard.sh &&
        chmod 0755 ultra-gaming-setup-wizard.sh &&
        ./ultra-gaming-setup-wizard.sh
}

extra2() {
    curl -fsSL https://raw.githubusercontent.com/YurinDoctrine/secure-linux/master/secure.sh >secure.sh &&
        chmod 0755 secure.sh &&
        ./secure.sh
}

final() {

    sleep 0.3 && clear
    echo -e "
###############################################################################
# All Done! Would you also mind to run the author's ultra-gaming-setup-wizard?
###############################################################################
"

    read -p $'yes/no >_: ' ans
    if [[ "$ans" == "yes" ]]; then
        echo -e "RUNNING ..."
        chsh -s /usr/bin/fish         # Change default shell before leaving.
        sudo ln -sfT mksh /usr/bin/sh # Link mksh to /usr/bin/sh
        extra
    elif [[ "$ans" == "no" ]]; then
        echo -e "LEAVING ..."
        echo -e ""
        echo -e "FINAL: DO YOU ALSO WANT TO RUN THE AUTHOR'S secure-linux?"
        read -p $'yes/no >_: ' noc
        if [[ "$noc" == "yes" ]]; then
            echo -e "RUNNING ..."
            chsh -s /usr/bin/fish         # Change default shell before leaving.
            sudo ln -sfT dash /usr/bin/sh # Link dash to /usr/bin/sh
            extra2
        elif [[ "$noc" == "no" ]]; then
            echo -e "LEAVING ..."
            chsh -s /usr/bin/fish         # Change default shell before leaving.
            sudo ln -sfT dash /usr/bin/sh # Link dash to /usr/bin/sh
            exit 0
        else
            echo -e "INVALID VALUE!"
            final
        fi
    else
        echo -e "INVALID VALUE!"
        final
    fi
}
final
