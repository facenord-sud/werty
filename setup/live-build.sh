# Add our builder-jessis repository for live-build, and pin it low
echo 'deb http://deb.tails.boum.org/ builder-jessie main' > /etc/apt/sources.list.d/tails.list
echo 'deb http://ftp.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list

sed -e 's/^[[:blank:]]*//' > /etc/apt/preferences.d/tails <<EOF
Package: *
Pin: release o=Debian,a=stable
Pin-Priority: 700

Package: *
Pin: origin deb.tails.boum.org
Pin-Priority: 800
EOF
