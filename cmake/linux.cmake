#[=======================================================================[.rst:
Linux
-----

This file contains functions for options and configuration for targeting the
Linux platform

]=======================================================================]
function(linux_options)
    # Linux Options
endfunction()

function(linux_generate)
    target_compile_definitions(godot-cpp PUBLIC LINUX_ENABLED UNIX_ENABLED)

    common_compiler_flags()
endfunction()
