#!/bin/sh

build_type="-D CMAKE_BUILD_TYPE=Debug"
#build_type="-D CMAKE_BUILD_TYPE=Release"
#build_type="-D CMAKE_BUILD_TYPE=MinSizeRel"
#build_type="-D CMAKE_BUILD_TYPE=RelWithDebInfo"

compiler="-D CMAKE_C_COMPILER=gcc-13 -D CMAKE_CXX_COMPILER=g++-13"
#compiler="-D CMAKE_C_COMPILER=clang-15 -D CMAKE_CXX_COMPILER=clang++-15"

repo_dir=$(dirname "$0")

# Генерируем проект
cmake "$repo_dir" -B "$repo_dir/../build" -G "Unix Makefiles" $build_type $compiler \
  -D DV_BIG_INT_BUILD_TESTER=1 -D DV_BIG_INT_UB_SANITIZER=1

# Компилируем проект
cmake --build "$repo_dir/../build"
