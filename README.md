# Warning

This set of scripts is intended for use by people who know what they're doing, this won't necessarily work on any system. This is just a small personal project I've done, feel free to provide feedback but I make no guarantees as to the quality or applicability of these scripts.

# Configuration

## UPS Config

Set your UPS Vendor and Product ID in debian/postinst and debian/postrm to have USB permissions setup

By default the same file will create a profile called "myups" which uses the `apc_modbus` driver and `auto` port.

## User/Group Config

The scripts create a system user and group both called `nut` for NUT services/daemons to run as

## NUT Config

In `debian/rules` there are various configurations set for building NUT, it includes APC Modbus and USB drivers, uses the user and group `nut`, and doesn't generate docs or use python.

## Running

Run `setup-custom-nut.sh` (you may have to chmod +x setup-custom-nut.sh first) which will create a Promox container using the first available ISO in local-lvm, so if this is not Debian you may need to adjust line 3.
It then pushes the script and config files to the container and runs `build.sh` which grabs and compiles libmodbus with modbus support and then builds and compiles NUT with libmodbus.
The script then pulls the .deb packages off of the container to `/tmp/` and destroys the container.

Then install the packages with `apt install /tmp/*.deb -y` (assuming they are the only .deb files in that location), and you can optionally run NUT with `startnut.sh`.

The packages can be safely removed with `apt purge nut-custom libmodbus-nut -y`.