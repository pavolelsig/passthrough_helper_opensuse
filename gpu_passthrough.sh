#!/bin/bash

if [ -a readme.md ]
    then
        echo "Please run uninstall.sh before attempting to run the script again!"
	exit
fi
    
zypper install qemu virt-manager libvirt

systemctl enable libvirtd
systemctl start libvirtd

CPU=$(lscpu | grep GenuineIntel | rev | cut -d ' ' -f 1 | rev )

INTEL="0"

if [ "$CPU" = "GenuineIntel" ]
	then
	CPU=" intel_iommu=on"
	else
	CPU=" amd_iommu=on"
fi

GRUB=`cat /etc/default/grub | grep "GRUB_CMDLINE_LINUX_DEFAULT" | rev | cut -c 2- | rev`

echo ${GRUB}\" > backup.txt

chmod +x uninstall.sh

GRUB+="$CPU rd.driver.pre=vfio-pci kvm.ignore_msrs=1\""


sed -i -e "s|^GRUB_CMDLINE_LINUX_DEFAULT.*|${GRUB}|" /etc/default/grub



grub2-mkconfig -o /boot/grub2/grub.cfg

echo "Getting GPU passthrough scripts ready"

cp vfio-pci-override-vga.sh /sbin/vfio-pci-override-vga.sh

chmod 755 /sbin/vfio-pci-override-vga.sh

if [ -a /etc/modprobe.d/local.conf ]
	then
cp /etc/modprobe.d/local.conf local.conf.modprobe_backup
	fi
	
chmod +x update.sh
./update.sh

echo "install vfio-pci /sbin/vfio-pci-override-vga.sh" > /etc/modprobe.d/local.conf

cp local.conf /etc/dracut.conf.d/local.conf

if [ -a /etc/dracut.conf.d/local.conf ]
	then
cp /etc/dracut.conf.d/local.conf local.conf.dracut_backup
	fi

echo "Generating initramfs"

dracut -f --kver `uname -r`

#To check if the installation ran already
mv README.md readme.md
