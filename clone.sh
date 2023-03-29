mkfs.vfat -F32 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4
pacman -Sy --noconfirm archinstall python python-setuptools
#Archintall tends to stall instead, so this timeout and redo is often nessicary
timeout 10s bash <<EOT
archinstall --config https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/confMain.json --disk-layouts https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/confDisk.json --creds https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/confCreds.json
EOT
archinstall --config https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/confMain.json --disk-layouts https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/confDisk.json --creds https://raw.githubusercontent.com/youdontknowdemo/arch-install/devel/confCreds.json
