# Reusable makefile for the C/C++ extensions targeting the C extension API
#
# Inputs
#   EXTENSION_NAME               : name of the extension (lower case)
#   EXTENSION_LIB_FILENAME       : the library name that is produced by the build
#	MINIMUM_DUCKDB_VERSION       : full version tag (including v)
#	MINIMUM_DUCKDB_VERSION_MAJOR : major version
#	MINIMUM_DUCKDB_VERSION_MINOR : minor version
#	MINIMUM_DUCKDB_VERSION_PATCH : patch version
#	CMAKE_EXTRA_BUILD_FLAGS      : additional CMake flags to pass


.PHONY: build_extension_library_debug build_extension_library_release update_duckdb_headers

# Create build params to pass name and version
CMAKE_VERSION_PARAMS = -DEXTENSION_NAME=$(EXTENSION_NAME)
CMAKE_VERSION_PARAMS += -DMINIMUM_DUCKDB_VERSION=$(MINIMUM_DUCKDB_VERSION_MAJOR)
CMAKE_VERSION_PARAMS += -DMINIMUM_DUCKDB_VERSION_MINOR=$(MINIMUM_DUCKDB_VERSION_MINOR)
CMAKE_VERSION_PARAMS += -DMINIMUM_DUCKDB_VERSION_PATCH=$(MINIMUM_DUCKDB_VERSION_PATCH)

CMAKE_BUILD_FLAGS = $(CMAKE_VERSION_PARAMS) $(CMAKE_EXTRA_BUILD_FLAGS)

#############################################
### Rust Build targets
#############################################

build_extension_library_debug: check_configure
	cmake $(CMAKE_BUILD_FLAGS) -DCMAKE_BUILD_TYPE=Debug -S $(PROJ_DIR) -B cmake_build/debug
	cmake --build cmake_build/debug --config Debug
	$(PYTHON_VENV_BIN) -c "from pathlib import Path;Path('./build/debug/extension/$(EXTENSION_NAME)').mkdir(parents=True, exist_ok=True)"
	$(PYTHON_VENV_BIN) -c "import shutil;shutil.copyfile('cmake_build/debug/$(EXTENSION_LIB_FILENAME)', 'build/debug/$(EXTENSION_LIB_FILENAME)')"

build_extension_library_release: check_configure
	cmake $(CMAKE_BUILD_FLAGS) -DCMAKE_BUILD_TYPE=Release -S $(PROJ_DIR) -B cmake_build/release
	cmake --build cmake_build/release --config Release
	$(PYTHON_VENV_BIN) -c "from pathlib import Path;Path('./build/release/extension/$(EXTENSION_NAME)').mkdir(parents=True, exist_ok=True)"
	$(PYTHON_VENV_BIN) -c "import shutil;shutil.copyfile('cmake_build/release/$(EXTENSION_LIB_FILENAME)', 'build/release/$(EXTENSION_LIB_FILENAME)')"

#############################################
### Misc
#############################################
# TODO: switch this to use the $(MINIMUM_DUCKDB_VERSION) after v1.2.0 is released
BASE_HEADER_URL=https://raw.githubusercontent.com/duckdb/duckdb/refs/heads/main/src/include
DUCKDB_C_HEADER_URL=$(BASE_HEADER_URL)/duckdb.h
DUCKDB_C_EXTENSION_HEADER_URL=$(BASE_HEADER_URL)/duckdb_extension.h

update_duckdb_headers:
	$(PYTHON_VENV_BIN) -c "import urllib.request;urllib.request.urlretrieve('$(DUCKDB_C_HEADER_URL)', 'duckdb_capi/duckdb.h')"
	$(PYTHON_VENV_BIN) -c "import urllib.request;urllib.request.urlretrieve('$(DUCKDB_C_EXTENSION_HEADER_URL)', 'duckdb_capi/duckdb_extension.h')"

clean_cmake:
	rm -rf cmake_build