### Build libmodbus with apc modbus support
apt update
apt install build-essential git autoconf libtool pkg-config libusb-1.0-0-dev libssl-dev checkinstall dh-make devscripts -y

cd ~

git clone -b rtu_usb https://github.com/networkupstools/libmodbus libmodbus-nut_1.0.0
cd libmodbus-nut_1.0.0

./autogen.sh

dh_make --library --createorig --packagename libmodbus-nut_1.0.0 -y

sed -i "s/libmodbus-nutBROKEN/libmodbus-nut/g" debian/control

echo -e "\noverride_dh_auto_configure:\n\tdh_auto_configure -- --prefix=/usr --with-libusb" >> debian/rules

echo "usr/lib/*/libmodbus*.so.*" > debian/libmodbus-nut.install

echo "usr/include/modbus/" > debian/libmodbus-nut-dev.install
echo "usr/lib/*/libmodbus*.so" >> debian/libmodbus-nut-dev.install
echo "usr/lib/*/pkgconfig/" >> debian/libmodbus-nut-dev.install

echo -e "\noverride_dh_missing:\n\tdh_missing --list-missing" >> debian/rules

DEB_BUILD_PROFILES=nodoc debuild -us -uc

cd ~
dpkg -i libmodbus-nut_1.0.0-1_amd64.deb libmodbus-nut-dev_1.0.0-1_amd64.deb

### Build custom NUT
git clone https://github.com/networkupstools/nut nut-custom_1.0.0
cd nut-custom_1.0.0
./autogen.sh

dh_make --single --native --createorig --packagename nut-custom_1.0.0 -y

cp ~/src/debian/* debian

DEB_BUILD_PROFILES=nodoc debuild -us -uc -j$(nproc)