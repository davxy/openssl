#!/bin/bash

DIR=openssl

# Exit on first error
set -e

begin=$(date)

if [ ! -d $DIR ]; then
    git clone git@gitlab.com:davxy/openssl.git $DIR
    cd $DIR
    git remote add upstream https://github.com/openssl/openssl.git
    cd ..
fi

cd $DIR

# Update local master using upstream
git checkout master
git pull upstream master

# Update local develop using origin
git checkout develop
git pull origin develop

# Merge master to develop
git merge --no-edit master

# Push new stuff
git push origin master
git push origin develop

# Analyze in docker
docker run -v /home/tsm/openssl/openssl:/openssl -it --rm davxy/sonar-builder /bin/bash -c "cd openssl && ./util/sonar-run.sh"

end=$(date)

# Disable exit on first error
set +e

echo "Analysis begin: $begin"
echo "Analysis end:   $end"
