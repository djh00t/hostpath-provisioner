#!/bin/bash
###
### hostpath-provisioner image build script
###
APP="hostpath-provisioner"
VERSION=$1

# Make sure that the version is set, if not error out
if [ -z "$VERSION" ]; then
    echo "Version not set, exiting..."
    exit 1
fi

# git tag with $VERSION
git tag $VERSION
#git tag -a $VERSION -m "hostpath-provisioner version $VERSION"

# git commit with $VERSION
git commit -a -m "hostpath-provisioner version $VERSION"

# git push
git push origin refs/tags/$VERSION
sleep 1
git push

exit 0