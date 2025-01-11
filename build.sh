#!/bin/bash

rmifexists() {
   if [ -e $1 ]; then
      rm -r $1
   fi
}

mkpushd() {
   mkdir $1 && pushd $1
}

getnatives() {
   wget https://nightly.link/PojavLauncherTeam/lwjgl3/actions/runs/12714049494/lwjgl3-android-natives-$1.zip
   mkpushd ./libs_$1
      unzip ../lwjgl3-android-natives-$1.zip
   popd
}

mkmovenatives() {
   mkdir -p linux/$1/org/lwjgl/$2
   mv ../libs_$1/$3 linux/$1/org/lwjgl/$2/$3
}

mkplatform() {
   mkmovenatives $1 shaderc libshaderc.so
   mkmovenatives $1 vma liblwjgl_vma.so
}

rmifexists ./cache
rmifexists ./vkmod-an-libs.jar

mkpushd ./cache
   getnatives arm32
   getnatives arm64
   mkpushd ./jarout
      mkplatform arm64
      mkplatform arm32
      cp ../../fabric.mod.json .
      zip -r ../../vkmod-an-libs.jar .
   popd
popd
