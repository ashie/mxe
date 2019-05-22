#!/bin/bash

# 1.34.0 fails due to https://github.com/rust-lang/rust/issues/58277
DEFAULT_RUST_VERSION=$(rustup default | awk '{print $1}')
rustup toolchain install 1.33.0
rustup default 1.33.0
rustup target add x86_64-pc-windows-gnu

make librsvg \
  MXE_TARGETS=x86_64-w64-mingw32.shared \
  MXE_PLUGIN_DIRS=plugins/librsvg-2.45.6 \
  JOBS=4

rustup default ${DEFAULT_RUST_VERSION}
