VMID=$(pvesh get /cluster/nextid)

ISO=$(pveam list local | sed "2q;d" | awk '{print $1}')

pct create $VMID $ISO --cores 1 --hostname nut -password nutpass --net0 name=eth0,bridge=vmbr0,ip=dhcp --rootfs local-lvm:10 --ostype debian --start 1 --unprivileged 1
pct exec $VMID -- sed -i '/# en_US.UTF-8/s/^# //' /etc/locale.gen
pct exec $VMID -- locale-gen
pct exec $VMID -- mkdir -p /root/src/debian
for file in debian/*
do
    pct push $VMID $file "/root/src/$file"
done

pct exec $VMID -- bash < ./scripts/build.sh

pct pull $VMID /root/libmodbus-nut_1.0.0-1_amd64.deb /tmp/libmodbus-nut_1.0.0-1_amd64.deb
pct pull $VMID /root/nut-custom_1.0.0_amd64.deb /tmp/nut-custom_1.0.0_amd64.deb

pct destroy $VMID --purge --force