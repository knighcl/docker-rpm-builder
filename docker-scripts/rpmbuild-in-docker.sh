#!/bin/bash
set -ex
echo "starting $0"
SPEC=$(ls /src/*.spec | head -n 1)
cp -t /docker-rpm-build-root/SOURCES -r /src/*
[ -x /src/drb-pre ] && /src/drb-pre
/docker-scripts/rpm-setup-deps.sh
#rpmbuild -bb $SPEC || /bin/bash
cd /docker-rpm-build-root/SOURCES
make rpms
[ -x /src/drb-post ] && /src/drb-post
#cp -fr /docker-rpm-build-root/RPMS /src
cp -fr dist/rpms/*.rpm /src
#chown -R $1 /src/RPMS
chown -R $1 /src/dist/rpms
echo "Done"

