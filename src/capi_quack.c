#include "duckdb_extension.h"

#include "add_numbers.h"

// Workaround for missing struct tag in DUCKDB_EXTENSION_ENTRYPOINT (DuckDB 1.1.x)
typedef struct duckdb_extension_access duckdb_extension_access;

#if DUCKDB_EXTENSION_API_VERSION_MAJOR >= 1
#define EXTENSION_RETURN(result) return (result)
#else
#define EXTENSION_RETURN(result) return
#endif

DUCKDB_EXTENSION_ENTRYPOINT(duckdb_connection connection, duckdb_extension_info info, struct duckdb_extension_access *access) {
	// Register a demo function
	RegisterAddNumbersFunction(connection);

	// Return true to indicate succesful initialization
	EXTENSION_RETURN(true);
}
