cmake -S . -B farmhash-c/build -DCMAKE_BUILD_TYPE=Debug
cmake --build farmhash-c/build --config Debug

cmake -S . -B farmhash-c/build -DCMAKE_BUILD_TYPE=Release
cmake --build farmhash-c/build --config Release