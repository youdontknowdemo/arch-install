# arch-linux-base-setup
## IF you are running an alienware M18XR2 and/or have the GTX 660M for notebooks (smaller thing isn't it)
### You must first FLASH your bios, the default settings are locked down hard and you cant enable switchable graphics, which will open up the ability to use both graphics cards, better use nvidia environment variables like what enable prime-run script style gpu offloading.
## This card still sucks on linux. I mean, we'll make it work, but even after enabling cool bits, and using patched drivers, this card sits in limbo for a buch of features. Not all cool bits are enabled by card, and not all nvidia tricks and tools are enabled by the firmware. 
### The patched bios can be found but I've been encouraged to not share the link. You need to upgrade or downgrade your bios firmware to A11, then patch it with the modified bios. Within the modified bios, there will be a lot of new menus, but find where you can turn a graphics setting to SG (switchable graphics)
## MAKE sure your fans are unscrewed, cleaned, and refastened. There will probably limited driver control with coolbits.

## **Most of the post-install/setup script (setup.sh/arch-lbs-devel.sh) will run from the user account that is well qalified and promoted as such**

### IF you have your own basic arch linux install, run that first and then RUN:

```sh
curl --tlsv1.2 -fsSL https://raw.githubusercontent.com/YurinDoctrine/arch-linux-base-setup/main/arch-linux-base-setup.sh >arch-lbs-devel.sh && \
 chmod 0755 arch-lbs-devel.sh && \
 ./arch-lbs-devel.sh

```
## **OR**

### If you want to install from your live archiso USB key or CD, and you would like to use my forked base install RUN:

```

```
