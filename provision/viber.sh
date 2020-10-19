#!/bin/sh
set +ex

# Download viber
wget https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb -P /tmp

#If you try to install Viber on Debian 9 you will probably get the following error:
# dpkg: dependency problems prevent configuration of viber: viber depends on libssl1.0.0; however: Package libssl1.0.0 is not installed.
# This is cause because libssl1.0.0 is not installed be default and is no longer available through the repos.
wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb -P /tmp

# Install libssl
apt install -y /tmp/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb

# Install viber
apt install -y /tmp/viber.deb
