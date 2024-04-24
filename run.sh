#!/bin/bash

uid=`echo -n $(pwd) | md5sum | head -c32`
bname=`basename $(pwd)`
dub_pkg_dir="$HOME/.dlang-docker-dub"

# if you want to have a different build dir for each project:
# dub_pkg_dir="$(pwd)/.dlang-docker-dub"

docker_cmd="docker run --name dlang-docker-$uid-$bname -h dlang-ubuntu -v \$(pwd):/home/user/src -ti --rm"

for param in "$@"
do
  if [ "$param" == "dub" ]; then
    docker_cmd+=" -v $dub_pkg_dir:/home/user/.dub trikko/dlang-ubuntu dub"
    continue
  elif [ "$param" == "dmd" ]; then
    docker_cmd+=" trikko/dlang-ubuntu dmd"
    continue
  elif [ "$param" == "ldc2" ]; then
    docker_cmd+=" trikko/dlang-ubuntu ldc2"
    continue
  fi

  docker_cmd+=" $param"
done

echo "----------------------------------"
echo "--- 🤖  Running on docker! 🤖  ---"
echo "----------------------------------"
echo 
echo "container: dlang-docker-$uid-$bname"
echo

mkdir -p $dub_pkg_dir
docker container rm -f dlang-docker-$uid-$bname &>/dev/null
eval $docker_cmd
