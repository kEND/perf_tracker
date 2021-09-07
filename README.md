# PerfTracker

A simple Supervisor to tail the console.log for elections and instruct
a worker to capture hbbft_perf data on an interval until the election ends.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `perf_tracker` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:perf_tracker, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/perf_tracker](https://hexdocs.pm/perf_tracker).

