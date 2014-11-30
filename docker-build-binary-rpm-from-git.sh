#!/bin/bash
set -e
USAGE="Usage:\n$0 IMAGETAG SRCGIT SRCBRANCH <...additional docker options..>\n"
IMAGETAG=$1
[ -n "$1" ] || { echo "ERROR: Missing IMAGETAG param" ; echo -e $USAGE ; exit 1 ;}
shift 1
SRCGIT=$1
shift 1
SRCBRANCH=$1
shift 1
if [ -z  "$SRCBRANCH" ] ; then
	SRCBRANCH="master"
fi
#[[ -n "$1" && -d $1 && -r $1 && -x $1 && -w $1 ]] || { echo "ERROR: Missing SRCDIR or wrong permissions - must be an rwx directory" ; echo -e $USAGE ; exit 1 ;}

CURRENTDIR=$(dirname $(readlink -f $0))
echo CURRENTDIR = ${CURRENTDIR}

docker run $* -v ${CURRENTDIR}/docker-scripts:/docker-scripts -w /docker-scripts --name=drb-rpm-builder-git ${IMAGETAG} ./rpmbuild-in-docker-git.sh ${SRCGIT} ${SRCBRANCH}
#docker run $* -v ${CURRENTDIR}/docker-scripts:/docker-scripts -v ${SRCDIR}:/src -w /docker-scripts ${IMAGETAG} ./rpmbuild-in-docker.sh $(id -u):$(id -g)
#docker run $* -v ${CURRENTDIR}/docker-scripts:/docker-scripts -v ${SRCDIR}:/src -w /docker-scripts -i -t ${IMAGETAG}  /bin/bash

[ -n "${DELETEBUILDDEPS}" ] && rm -f ${SPEC}
[ -n "${DELETESPEC}" ] && rm -f ${SPECTEMPLATE%template}

