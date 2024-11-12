.PHONY: clean clean_all

PROJ_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

EXTENSION_NAME=capi_quack
MINIMUM_DUCKDB_VERSION_MAJOR=0
MINIMUM_DUCKDB_VERSION_MINOR=0
MINIMUM_DUCKDB_VERSION_PATCH=1

MINIMUM_DUCKDB_VERSION=v$(MINIMUM_DUCKDB_VERSION_MAJOR).$(MINIMUM_DUCKDB_VERSION_MINOR).$(MINIMUM_DUCKDB_VERSION_PATCH)

CMAKE_VERSION_PARAMS = -DEXTENSION_NAME=$(EXTENSION_NAME)
CMAKE_VERSION_PARAMS += -DMINIMUM_DUCKDB_VERSION_MAJOR=$(MINIMUM_DUCKDB_VERSION_MAJOR)
CMAKE_VERSION_PARAMS += -DMINIMUM_DUCKDB_VERSION_MINOR=$(MINIMUM_DUCKDB_VERSION_MINOR)
CMAKE_VERSION_PARAMS += -DMINIMUM_DUCKDB_VERSION_PATCH=$(MINIMUM_DUCKDB_VERSION_PATCH)

all: configure debug

# Include makefiles from DuckDB
include extension-ci-tools/makefiles/duckdb_extension_c_api.Makefile

############################################### TODO MOVE TO MAKEFILE ###############################################

build_extension_library_debug: check_configure
	mkdir -p ./cmake_build/debug && \
    	cd cmake_build/debug && \
    	cmake $(CMAKE_VERSION_PARAMS) -DCMAKE_BUILD_TYPE=Debug ../.. && \
      	cmake --build . --config Debug
	$(PYTHON_VENV_BIN) -c "from pathlib import Path;Path('./build/debug/extension/$(EXTENSION_NAME)').mkdir(parents=True, exist_ok=True)"
	$(PYTHON_VENV_BIN) -c "import shutil;shutil.copyfile('cmake_build/debug/$(EXTENSION_LIB_FILENAME)', 'build/debug/$(EXTENSION_LIB_FILENAME)')"

build_extension_library_release: check_configure
	mkdir -p ./cmake_build/release && \
    	cd cmake_build/release && \
    	cmake $(CMAKE_VERSION_PARAMS) -DCMAKE_BUILD_TYPE=Release ../.. && \
    	cmake --build . --config Release
	$(PYTHON_VENV_BIN) -c "from pathlib import Path;Path('./build/release/extension/$(EXTENSION_NAME)').mkdir(parents=True, exist_ok=True)"
	$(PYTHON_VENV_BIN) -c "import shutil;shutil.copyfile('cmake_build/release/$(EXTENSION_LIB_FILENAME)', 'build/release/$(EXTENSION_LIB_FILENAME)')"

clean_c:
	rm -rf cmake_build

###############################################

configure: venv platform extension_version

debug: build_extension_library_debug build_extension_with_metadata_debug
release: build_extension_library_release build_extension_with_metadata_release

test: test_debug
test_debug: test_extension_debug
test_release: test_extension_release

clean: clean_build clean_c
clean_all: clean_configure clean