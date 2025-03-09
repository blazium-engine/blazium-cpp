#[=======================================================================[.rst:
Ios
---

This file contains functions for options and configuration for targeting the
Ios platform

]=======================================================================]
function(ios_options)
    # iOS options
endfunction()

function(ios_generate)
    target_compile_definitions(godot-cpp PUBLIC IOS_ENABLED UNIX_ENABLED)

    common_compiler_flags()
endfunction()
