#!/bin/bash
set -ex
echo 1 = $1
echo 2 = $2
git clone --progress $1 --branch $2 /src
echo "starting $0"
SPEC=$(ls /src/*.spec | head -n 1)
# find .spec.in and copy to .spec
if [ -z "$SPEC" ] ; then
	SPEC=$(ls /src/*.spec.in | head -n 1)
	if [ -n "$SPEC" ] ; then
		DELETEBUILDDEPS="y"
		cp "$SPEC" "/src/`basename -s .spec.in "${SPEC}"`-builddeps.spec"
		SPEC=$(ls /src/*.spec | head -n 1)
	else
		SPEC=
	fi
fi
echo SPEC = ${SPEC}
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
/bin/bash
