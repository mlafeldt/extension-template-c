cmake_minimum_required(VERSION 2.8)

###
# Configuration
###
if(NOT DEFINED MINIMUM_DUCKDB_VERSION_MAJOR OR
        NOT DEFINED MINIMUM_DUCKDB_VERSION_MINOR OR
        NOT DEFINED MINIMUM_DUCKDB_VERSION_PATCH)
    message(FATAL_ERROR "DuckDB minimum version is required")
endif()
if(NOT DEFINED EXTENSION_NAME)
    message(FATAL_ERROR "DuckDB extension name is required")
endif()
add_definitions(-DDUCKDB_EXTENSION_API_VERSION_MAJOR=${MINIMUM_DUCKDB_VERSION_MAJOR})
add_definitions(-DDUCKDB_EXTENSION_API_VERSION_MINOR=${MINIMUM_DUCKDB_VERSION_MINOR})
add_definitions(-DDUCKDB_EXTENSION_API_VERSION_PATCH=${MINIMUM_DUCKDB_VERSION_PATCH})
add_definitions(-DDUCKDB_EXTENSION_NAME=${EXTENSION_NAME})

###
# Build
###
project(${EXTENSION_NAME} LANGUAGES C)

set(EXTENSION_SOURCES
    src/add_numbers.c
    src/capi_quack.c
)

add_library(${EXTENSION_NAME} SHARED ${EXTENSION_SOURCES})
target_include_directories(${EXTENSION_NAME} PRIVATE src/include)
target_include_directories(${EXTENSION_NAME} PRIVATE duckdb_capi)