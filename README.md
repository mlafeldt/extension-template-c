A fork of the [DuckDB C extension template](https://github.com/duckdb/extension-template-c) built with Zig. The [diff](https://github.com/duckdb/extension-template-c/compare/7463f66...mlafeldt:extension-template-c:main) speaks for itself (negative 5000 LOC).

Install [Zig](https://ziglang.org) and [uv](https://docs.astral.sh/uv/). Then run:

```
# Build the extension for all supported DuckDB versions and platforms
zig build

# Run SQL logic tests for all DuckDB versions
zig build test
```

Based on https://github.com/mlafeldt/quack-zig - check out the README for more details.
