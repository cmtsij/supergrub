#!/bin/bash

# Grub2 Build for Super Grub2 Disk - Build all grub releases

SG2D_DIR="$(pwd)"

source grub-build-config

function sg2d_grub_build () {

local SG2D_BUILD_DIR="${1}"
local PLATFORM="${2}"
local INSTALLATION_DIR="${3}"

# Build Hybrid i386 pc
cd "${SG2D_BUILD_DIR}"
if ./autogen.sh > "${SG2D_GRUB_LOG_PREFIX}_autogen.log" 2>&1 ; then
  echo -e -n "autogen.sh run OK on: ${SG2D_BUILD_DIR}\n"
  if ./configure \
 --enable-grub-mkfont \
 --with-platform="${PLATFORM}" \
 --prefix \
 "${INSTALLATION_DIR}" \
> "${SG2D_GRUB_LOG_PREFIX}_configure.log" 2>&1 ; then
    echo -e -n "configure run OK on: ${SG2D_BUILD_DIR}\n"
	if make > "${SG2D_GRUB_LOG_PREFIX}_make.log" 2>&1 ; then
		echo -e -n "make run OK on: ${SG2D_BUILD_DIR}\n"
	else
		echo -e -n "make had a PROBLEM on: ${SG2D_BUILD_DIR}\n" 1>&2
		echo -e -n "You can check its log: ${SG2D_GRUB_LOG_PREFIX}_make.log\n" 1>&2
		echo -e -n "Skipping to next build if applicable\n" 1>&2
	fi
  else
	echo -e -n "configure had a PROBLEM on: ${SG2D_BUILD_DIR}\n" 1>&2
	echo -e -n "You can check its log: ${SG2D_GRUB_LOG_PREFIX}_configure.log\n" 1>&2
	echo -e -n "Skipping to next build if applicable\n" 1>&2
  fi
else
	echo -e -n "autogen.sh had a PROBLEM on: ${SG2D_BUILD_DIR}\n" 1>&2
	echo -e -n "You can check its log: ${SG2D_GRUB_LOG_PREFIX}_autogen.log\n" 1>&2
	echo -e -n "Skipping to next build if applicable\n" 1>&2
fi

cd ..

}


# Check if build directories exists or not.
# If anyone of them does not exist exit with an error.

for n_build_dir in "${!SG2D_GRUB_BUILD_DIRS_ARR[@]}"; do

	if [ ! -d "${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}" ] ; then
		echo -e -n "Build all grub releases refuses to continue\n" 1>&2 ;
		echo -e -n "'${SG2D_GRUB_BUILD_DIRS_ARR[n_build_dir]}' does not exist\n" 1>&2 ;
		echo -e -n "Have you run: ./grub-build-001-prepare-build.sh ?\n"1>&2 ;
		echo -e -n "and: ./grub-build-002-clean-and-update.sh ?\n"1>&2 ;
		exit 2
	fi

done

cd "${SG2D_GRUB_BUILD_PREFIX}"

# Build Hybrid i386 pc
sg2d_grub_build \
 "${SG2D_GRUB_BUILD_HYBRID_I386_PC}" \
 "pc" \
"${SG2D_GRUB_INSTALLATION_PREFIX}\
/${SG2D_GRUB_INSTALLATION_HYBRID}"

# Build Hybrid x86_64 efi
sg2d_grub_build \
 "${SG2D_GRUB_BUILD_HYBRID_X86_64_EFI}" \
 "efi" \
"${SG2D_GRUB_INSTALLATION_PREFIX}\
/${SG2D_GRUB_INSTALLATION_HYBRID}"

# Build i386 pc
sg2d_grub_build \
 "${SG2D_GRUB_BUILD_I386_PC}" \
 "pc" \
"${SG2D_GRUB_INSTALLATION_PREFIX}\
/${SG2D_GRUB_INSTALLATION_I386_PC}"

# Build x86_64 efi
sg2d_grub_build \
 "${SG2D_GRUB_BUILD_X86_64_EFI}" \
 "efi" \
"${SG2D_GRUB_INSTALLATION_PREFIX}\
/${SG2D_GRUB_INSTALLATION_X86_64_EFI}"



cd "${SG2D_DIR}"
