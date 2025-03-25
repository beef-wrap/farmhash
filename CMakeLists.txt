cmake_minimum_required(VERSION 3.27)

project(farmhash)

# remove "lib" prefix on unix systems
set(CMAKE_STATIC_LIBRARY_PREFIX "")

if (WIN32)
    set(OUTPUT_DIR "windows" CACHE STRING "")
elseif(APPLE)
    set(OUTPUT_DIR "macos" CACHE STRING "")
elseif(UNIX)
    set(OUTPUT_DIR "linux" CACHE STRING "")
endif ()

add_library(farmhash STATIC farmhash-c/farmhash.c)

set_target_properties(farmhash PROPERTIES ARCHIVE_OUTPUT_DIRECTORY $<LOWER_CASE:../../libs/${OUTPUT_DIR}>) 
set_target_properties(farmhash PROPERTIES OUTPUT_NAME_DEBUG "farmhashd")
set_target_properties(farmhash PROPERTIES OUTPUT_NAME_RELEASE "farmhash")