#[=======================================================================[.rst:
MacOS
-----

This file contains functions for options and configuration for targeting the
MacOS platform

]=======================================================================]

# Find Requirements
if(APPLE)
    set(CMAKE_OSX_SYSROOT $ENV{SDKROOT})
    find_library(
        COCOA_LIBRARY
        REQUIRED
        NAMES Cocoa
        PATHS ${CMAKE_OSX_SYSROOT}/System/Library
        PATH_SUFFIXES Frameworks
        NO_DEFAULT_PATH
    )
endif(APPLE)

function(macos_options)
endfunction()

function(macos_generate)
    target_compile_definitions(godot-cpp PUBLIC MACOS_ENABLED UNIX_ENABLED)

    target_link_options(godot-cpp PUBLIC -Wl,-undefined,dynamic_lookup)

    target_link_libraries(godot-cpp INTERFACE ${COCOA_LIBRARY})

    common_compiler_flags()
endfunction()
