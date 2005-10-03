#! /bin/sh -e

rm -rf scratch
mkdir -p scratch
mkdir -p scratch/libsA
mkdir -p scratch/libsB

cp big-dynstr scratch/
cp libfoo.so scratch/libsA/
cp libbar.so scratch/libsB/

oldRPath=$(../src/patchelf --print-rpath scratch/big-dynstr)
if test -z "$oldRPath"; then oldRPath="/oops"; fi
../src/patchelf --set-rpath $oldRPath:$(pwd)/scratch/libsA:$(pwd)/scratch/libsB scratch/big-dynstr

exitCode=0
cd scratch && ./big-dynstr || exitCode=$?

if test "$exitCode" != 46; then
    echo "bad exit code!"
    exit 1
fi
