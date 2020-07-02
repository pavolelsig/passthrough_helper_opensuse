#!/bin/sh
GPUS=DEVS=\"

for i in $(find /sys/devices/pci* -name boot_vga); do
if [ $(cat $i) -eq 0 ]; then
VIDEO=$(dirname $i)
GPUS+=$(echo $VIDEO | rev | cut -d '/' -f 1 | rev )
GPUS+=" "
AUDIO=$(echo $VIDEO | sed -e "s/0$/1/")
if [ -d $AUDIO ]; then
GPUS+=$(echo $AUDIO | rev | cut -d '/' -f 1 | rev )
GPUS+=" "
fi
fi
done


GPUS="$(echo -e "${GPUS}" | sed -e 's/[[:space:]]*$//')"
GPUS+=\"


sed -i -e "s|^DEVS=.*|${GPUS}|" /sbin/vfio-pci-override-vga.sh

