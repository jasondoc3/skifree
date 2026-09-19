cmake_minimum_required(VERSION 3.19)
project(skifree_sdl)

set(CMAKE_MODULE_PATH ${_MODULE_PATH} "${skifree_sdl_SOURCE_DIR}/cmake/")

find_package(SDL2 REQUIRED)
find_package(SDL2_image REQUIRED)
find_package(SDL2_ttf REQUIRED)

# Add all c source files under the src directory

file(GLOB SOURCES "src/*.c")
file(GLOB resource_files "resources/*.bmp")

# Linux-only toy: no Apple bundles, no MSVC branches. If you need another
# platform, that is a deliberate porting decision, not an #ifdef away.
add_executable(${PROJECT_NAME})

# The binary is just called "skifree" on every platform.
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME skifree)

add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/embedded_resources.h"
    COMMAND "${CMAKE_COMMAND}" "-DSOURCE_DIR=${CMAKE_SOURCE_DIR}" "-DRESOURCES_GLOB=resources/*" -P "${CMAKE_CURRENT_SOURCE_DIR}/cmake/EmbedResources.cmake"
    DEPENDS ${resource_files}
)

target_sources(${PROJECT_NAME} PRIVATE 
    src/skifree_decomp.c
    embedded_resources.h
)

# Add all headers files under the include directory
target_include_directories(${PROJECT_NAME} PRIVATE 
    include
    ${CMAKE_CURRENT_BINARY_DIR}
    ${SDL2IMAGE_INCLUDE_DIR}
    ${SDL2TTF_INCLUDE_DIR}
)

# Warnings on: this is a decomp with pre-existing sins, but new code
# (the theme engine) must be warning-clean under -Wall.
target_compile_options(${PROJECT_NAME} PRIVATE -Wall)

target_link_libraries(${PROJECT_NAME} SDL2::SDL2 ${SDL2IMAGE_LIBRARY} ${SDL2TTF_LIBRARY})

# Standard install surface: `cmake --install build` (honors
# CMAKE_INSTALL_PREFIX and DESTDIR, so packagers use this too).
install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
install(FILES README.md DESTINATION share/doc/skifree)
install(FILES skifree.desktop DESTINATION share/applications)
