# Linux-on-Hp-Stream-8
 
@@ -1,2 +1,41 @@
# Linux-on-Hp-Stream-8

Mint on hp Stream
########################
Create a Ubuntu live USB to boot on the Stream's 32-bit UEFI firmware
- Download a 32-bit Ubuntu or Mint image and burn it to a USB drive, I used Ubuntu MATE 18.04 32-bit.
- Also download a current 64-bit Fedora ISO file (since it contains the 32-bit EFI bootloader missing in Ubuntu). I used Fedora 29 Workstation 64-bit.
- Extract the entire EFI directory from the Fedora ISO and copy it to the root of the Ubuntu live USB.
- Also copy the Ubuntu live USB's /boot/grub/loopback.cfg file to /EFI/BOOT, and rename it "grub.cfg" (delete or rename the existing grub.cfg first).
- Edit the /EFI/BOOT/grub.cfg file like below, changing each "linux" and "initrd" label to "linuxefi" and "initrdefi":

From <https://h30434.www3.hp.com/t5/Tablets-and-Mobile-Devices/Linux-on-the-HP-Stream-tablet/td-p/6675613> 


Verify EFI partion fat16 at least 600MiB & Boot flag


Open folder mnt as root 
add mmc folder
sudo mount /dev/mmcblk1p1 /media/mmc







Audio Firmware installation
###########################
Download the zip file from: https://github.com/plbossart/UCM and unzip it to your home directory and use this command to copy it: 
sudo cp -r UCM-master/bytcr-rt5640 /usr/share/alsa/ucm
and then reboot.
Open Sound Preferences and you will see multiple audio devices, you may have to change from the default device to test it and also switch manually between speaker and headphones since the automatic headphone detection does not work.

From <https://h30434.www3.hp.com/t5/Tablets-and-Mobile-Devices/Linux-on-the-HP-Stream-tablet/td-p/6675613> 

 


for autu rotate screen check the attached script
################################################
