.PHONY: clean clean_all

PROJ_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Main extension configuration
EXTENSION_NAME=capi_quack
TARGET_DUCKDB_VERSION_MAJOR=1
TARGET_DUCKDB_VERSION_MINOR=2
TARGET_DUCKDB_VERSION_PATCH=0
TARGET_DUCKDB_VERSION=v$(TARGET_DUCKDB_VERSION_MAJOR).$(TARGET_DUCKDB_VERSION_MINOR).$(TARGET_DUCKDB_VERSION_PATCH)

# Set to 1 to target the unstable C API.
USE_UNSTABLE_C_API=0

all: configure release

# Include makefiles from DuckDB
include extension-ci-tools/makefiles/c_api_extensions/base.Makefile
include extension-ci-tools/makefiles/c_api_extensions/c_cpp.Makefile

configure: venv platform extension_version

debug: build_extension_library_debug build_extension_with_metadata_debug
release: build_extension_library_release build_extension_with_metadata_release

test: test_debug
test_debug: test_extension_debug
test_release: test_extension_release

clean: clean_build clean_cmake
clean_all: clean_configure clean