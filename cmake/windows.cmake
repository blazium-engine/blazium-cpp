#[=======================================================================[.rst:
Windows
-------

This file contains functions for options and configuration for targeting the
Windows platform

]=======================================================================]
function(windows_options)
    option(GODOTCPP_USE_STATIC_CPP "Link MinGW/MSVC C++ runtime libraries statically" ON)
    option(GODOTCPP_DEBUG_CRT "Compile with MSVC's debug CRT (/MDd)" OFF)

    message(
        STATUS
        "If not already cached, setting CMAKE_MSVC_RUNTIME_LIBRARY.\n"
        "\tFor more information please read godot-cpp/cmake/windows.cmake"
    )

    set(CMAKE_MSVC_RUNTIME_LIBRARY
        "MultiThreaded$<IF:$<BOOL:${GODOTCPP_DEBUG_CRT}>,DebugDLL,$<$<NOT:$<BOOL:${GODOTCPP_USE_STATIC_CPP}>>:DLL>>"
        CACHE STRING
        "Select the MSVC runtime library for use by compilers targeting the MSVC ABI."
    )
endfunction()

#[===========================[ Target Generation ]===========================]
function(windows_generate)
    set(STATIC_CPP "$<BOOL:${GODOTCPP_USE_STATIC_CPP}>")

    set_target_properties(${TARGET_NAME} PROPERTIES PDB_OUTPUT_DIRECTORY "$<1:${CMAKE_SOURCE_DIR}/bin>")

    target_compile_definitions(
        ${TARGET_NAME}
        PUBLIC WINDOWS_ENABLED $<${IS_MSVC}: TYPED_METHOD_BIND NOMINMAX >
    )

    # gersemi: off
    target_link_options(
        ${TARGET_NAME}
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
