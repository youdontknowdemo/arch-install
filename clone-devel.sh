mkfs.vfat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4
mount -m /dev/sda3 /mnt/archinstall
mount -m /dev/sda1 /mnt/archinstall/boot
mount -m /dev/sda4 /mnt/archinstall/home
pacman -Sy --noconfirm archinstall python python-setuptools
#Archintall tends to stall instead, so this timeout and redo is often nessicary
timeout 10s bash <<EOT
archinstall --advanced --config https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/develMain.json --disk-layouts https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/confDisk.json --creds https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/confCreds.json
EOT
archinstall --advanced --config https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/develMain.json --disk-layouts https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/confDisk.json --creds https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/confCreds.json
"/dev/sda"
],
"hostname": "alienware-overlord",
"kernels": [
"linux",
"linux-lts",
"linux-zen"
],
"keyboard-layout": "us",
"mirror-region": "United States",
"nic": {
"type": "nm"
},
"ntp": true,
"packages": [
"arch-install-scripts",
"bash",
"binutils",
"ccache",
"chromium",
"coreutils",
"efibootmgr",
"fakeroot",
"grub-btrfs",
"gtk-update-icon-cache",
"meson",
"nano",
"ninja",
"procs",
"rsync",
"usbutils",
"zlib",
"zstd",
"wget",
"xdg-utils",
"xf86-input-libinput",
"linux-headers",
"linux-lts-headers",
"linux-zen-headers"
],
"profile": "gnome",
"script": "guided",
"services": [],
"swap": false,
"sys-encoding": "utf-8",
"sys-language": "en_US",
"timezone": "US/Mountain",
"version": "2.5.3"
}
