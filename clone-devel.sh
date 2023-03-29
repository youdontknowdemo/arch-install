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
