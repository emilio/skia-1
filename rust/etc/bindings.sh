#!/bin/bash

cd "$(dirname "$0")"

EXTRA_FLAGS=
EXTRA_CLANG_FLAGS=

: ${BINDGEN:=/home/emilio/projects/moz/rust-bindgen/target/debug/bindgen}

if [[ ! -x "$BINDGEN" ]]; then
    echo "error: BINDGEN does not exist or isn't executable!"
    echo "error: with BINDGEN=$BINDGEN"
    exit 1
fi

FILES=(
    SkCanvas.h
    SkPaint.h
)

WHITELISTED_TYPES=(
    SkCanvas
    SkImageInfo
    SkPaint
    SkSurface
    SkTime
    SkTime::DateTime
)

WHITELISTED_FN_REGEX=(
    'Sk.*'
)

BLACKLISTED_TYPES=(
    'std::unique_ptr__Pointer_type'
    'std::unique_ptr___tuple_type'
    'std::tuple_Inherited'
    'is_bitmask_enum'
)

$BINDGEN \
  ${EXTRA_FLAGS} \
  ${BLACKLISTED_TYPES[@]/#/--blacklist-type } \
  ${WHITELISTED_TYPES[@]/#/--whitelist-type } \
  ${WHITELISTED_FN_REGEX[@]/#/--whitelist-function } \
  --enable-cxx-namespaces \
  --raw-line 'pub use self::root::*;' \
  --bitfield-enum 'Gr.*Flags' \
  --bitfield-enum 'Sk.*Flags' \
  -o skia_bind.rs \
  skia_includes.hpp \
  -- \
  --std=c++11 \
  -I ../../include \
  -I ../../include/config \
  -I ../../include/core \
  ${EXTRA_CLANG_FLAGS} \
|| exit 1

echo
echo Post-processing...

# post-process some things
sed -i 's|, \.\.\.||g' skia_bind.rs
sed -i 's|//!|//|g' skia_bind.rs

cp skia_bind.rs ../src

echo Done

