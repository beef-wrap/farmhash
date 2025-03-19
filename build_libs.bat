mkdir libs
mkdir libs\debug
mkdir libs\release

clang -c -O0 -g -gcodeview -o farmhash-c.lib -target x86_64-pc-windows -fuse-ld=llvm-lib -Wall farmhash-c\farmhash.c
move farmhash-c.lib libs\debug

clang -c -O3 -o farmhash-c.lib -target x86_64-pc-windows -fuse-ld=llvm-lib -Wall farmhash-c\farmhash.c
move farmhash-c.lib libs\release