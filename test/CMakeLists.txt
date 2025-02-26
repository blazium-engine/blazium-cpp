#[=======================================================================[.rst:
Integration Testing
-------------------

The Test target used to validate changes in the GitHub CI.
]=======================================================================]

message(STATUS "Testing Integration targets are enabled.")

set(TARGET_NAME "godot-cpp-test")

foreach( TARGET_ALIAS template_debug template_release editor )
    set( TARGET_NAME "godot-cpp.test.${TARGET_ALIAS}" )

# conditionally add doc data to compile output
if(GODOTCPP_TARGET MATCHES "editor|template_debug")
    file(GLOB_RECURSE DOC_XML LIST_DIRECTORIES NO CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/doc_classes/*.xml")
    target_doc_sources( ${TARGET_NAME} ${DOC_XML} )
endif()

set(OUTPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/project/bin/")

# Link to godot-cpp target
target_link_libraries(${TARGET_NAME} PRIVATE godot-cpp)

### Get useful properties from godot-cpp target
get_target_property(GODOTCPP_SUFFIX godot-cpp GODOTCPP_SUFFIX)

# gersemi: off
set_target_properties(
    ${TARGET_NAME}
    PROPERTIES
        CXX_STANDARD 17
        CXX_EXTENSIONS OFF
        CXX_VISIBILITY_PRESET ${GODOTCPP_SYMBOL_VISIBILITY}

        POSITION_INDEPENDENT_CODE ON
        BUILD_RPATH_USE_ORIGIN ON

        # Try to ensure only static libraries are selected to be linked to.
        LINK_SEARCH_START_STATIC ON
        LINK_SEARCH_END_STATIC ON

        # NOTE: Wrapping the output variables inside a generator expression
        # prevents msvc generator from adding addition Config Directories
        LIBRARY_OUTPUT_DIRECTORY "$<1:${OUTPUT_DIR}>"
        RUNTIME_OUTPUT_DIRECTORY "$<1:${OUTPUT_DIR}>"
        PDB_OUTPUT_DIRECTORY     "$<1:${OUTPUT_DIR}>" #MSVC Only, ignored on other platforms

        PREFIX "lib"
        OUTPUT_NAME "gdexample${GODOTCPP_SUFFIX}"
        # TODO rename the file for both CMake and SCons

        # Some IDE's respect this property to logically group targets
        FOLDER "godot-cpp"
)
# gersemi: on

# CMAKE_SYSTEM_NAME refers to the target system
if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    set_target_properties(
        ${TARGET_NAME}
        PROPERTIES SUFFIX "" OUTPUT_DIR "${OUTPUT_DIR}/libgdexample.macos.${GODOTCPP_TARGET}.framework"
    )

    # conditionally add doc data to compile output
    if( TARGET_ALIAS MATCHES "editor|template_debug" )
        target_doc_sources( ${TARGET_NAME} ${DOC_XML} )
    endif()

    set( OUTPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/project/bin/" )

    # Link to godot-cpp target
    set( LINK_TARGET "godot-cpp::${TARGET_ALIAS}" )
    target_link_libraries( ${TARGET_NAME} PRIVATE ${LINK_TARGET} )

    ### Get useful properties from godot-cpp target
    get_target_property( GODOTCPP_SUFFIX   ${LINK_TARGET} GODOTCPP_SUFFIX      )
    get_target_property( OSX_ARCH       ${LINK_TARGET} OSX_ARCHITECTURES )

    set_target_properties( ${TARGET_NAME}
            PROPERTIES
            CXX_STANDARD 17
            CXX_EXTENSIONS OFF
            CXX_VISIBILITY_PRESET ${GODOTCPP_SYMBOL_VISIBILITY}

            POSITION_INDEPENDENT_CODE ON
            BUILD_RPATH_USE_ORIGIN ON

            # Try to ensure only static libraries are selected to be linked to.
            LINK_SEARCH_START_STATIC ON
            LINK_SEARCH_END_STATIC ON

            # NOTE: Wrapping the output variables inside a generator expression
            # prevents msvc generator from adding addition Config Directories
            LIBRARY_OUTPUT_DIRECTORY "$<1:${OUTPUT_DIR}>"
            RUNTIME_OUTPUT_DIRECTORY "$<1:${OUTPUT_DIR}>"
            PDB_OUTPUT_DIRECTORY     "$<1:${OUTPUT_DIR}>" #MSVC Only, ignored on other platforms

            PREFIX "lib"
            OUTPUT_NAME "gdexample${GODOTCPP_SUFFIX}"

            # Some IDE's respect this property to logically group targets
            FOLDER "godot-cpp"
    )

    # CMAKE_SYSTEM_NAME refers to the target system
    if( CMAKE_SYSTEM_NAME STREQUAL Darwin )
        set_target_properties( ${TARGET_NAME}
                PROPERTIES
                SUFFIX ""
                OUTPUT_DIR "${OUTPUT_DIR}/libgdexample.macos.${TARGET_ALIAS}.framework"
                OSX_ARCHITECTURES "${OSX_ARCH}"
        )
    endif()

endforeach()
