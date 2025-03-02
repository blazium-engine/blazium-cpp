#[=======================================================================[.rst:
Windows
-------

This file contains functions for options and configuration for targeting the
Windows platform

]=======================================================================]

#[============================[ Windows Options ]============================]
function(windows_options)
    #[[ Options from SCons

    TODO silence_msvc: Silence MSVC's cl/link stdout bloat, redirecting errors to stderr
        Default: True

    These three options will not implemented as compiler selection is managed
    by CMake toolchain files. Look to doc/cmake.rst for examples.
    use_mingw: Use the MinGW compiler instead of MSVC - only effective on Windows
    use_llvm: Use the LLVM compiler (MVSC or MinGW depending on the use_mingw flag
    mingw_prefix: MinGW prefix
    ]]

    option(GODOTCPP_USE_STATIC_CPP "Link MinGW/MSVC C++ runtime libraries statically" ON)
    option(GODOTCPP_DEBUG_CRT "Compile with MSVC's debug CRT (/MDd)" OFF)

    message(
        STATUS
        "If not already cached, setting CMAKE_MSVC_RUNTIME_LIBRARY.\n"
        "\tFor more information please read godot-cpp/cmake/windows.cmake"
    )

    set( CMAKE_MSVC_RUNTIME_LIBRARY
            "MultiThreaded$<IF:$<BOOL:${GODOTCPP_DEBUG_CRT}>,DebugDLL,$<$<NOT:$<BOOL:${GODOTCPP_USE_STATIC_CPP}>>:DLL>>"
            CACHE STRING "Select the MSVC runtime library for use by compilers targeting the MSVC ABI.")
endfunction()

#[===========================[ Target Generation ]===========================]
function( windows_generate )
    set( STATIC_CPP "$<BOOL:${GODOTCPP_USE_STATIC_CPP}>")

    set_target_properties(godot-cpp PROPERTIES PDB_OUTPUT_DIRECTORY "$<1:${CMAKE_SOURCE_DIR}/bin>")

    target_compile_definitions(
        godot-cpp
        PUBLIC WINDOWS_ENABLED $<${IS_MSVC}: TYPED_METHOD_BIND NOMINMAX >
    )

    # gersemi: off
    target_link_options(
        godot-cpp
        PUBLIC
            $<${NOT_MSVC}:
                -Wl,--no-undefined
                $<${STATIC_CPP}:
                    -static
                    -static-libgcc
                    -static-libstdc++
                >
            >

            $<${IS_CLANG}:-lstdc++>
    )
    # gersemi: on

    common_compiler_flags()
endfunction()
