defmodule LocalApi do
  alias Poison.Parser

  use Tesla, only: [:post], docs: false

  plug(Tesla.Middleware.BaseUrl, "http://localhost:4647")
  plug(Tesla.Middleware.JSON)

  def in_consensus?() do
    {:ok, %{body: body}} = post("/", %{jsonrpc: "2.0", id: 1, method: "info_in_consensus"}, [])
    %{"result" => %{"in_consensus" => in_consensus}} = Parser.parse!(body)
    in_consensus
  end

  def name() do
    {:ok, %{body: body}} = post("/", %{jsonrpc: "2.0", id: 1, method: "info_name"}, [])
    %{"result" => %{"name" => name}} = Parser.parse!(body)
    name
  end

  def hbbft_perf() do
    case post("/", %{jsonrpc: "2.0", id: 1, method: "hbbft_perf"}, []) do
      {:ok, %{body: body}} ->
        %{"result" => result} = Parser.parse!(body)
        # IO.inspect body
        result

      {:error, error} ->
        IO.puts error["message"]
        nil
    end
  end

  def height do
    {:ok, %{body: body}} = post("/", %{jsonrpc: "2.0", id: 1, method: "info_height"}, [])
    %{"result" => %{"height" => height}} = Parser.parse!(body)
    height
  end

  def capture_hbbft() do
    {path, timestamp} = create_elected_dir()
    path_to_perf_file = Path.join([path, "#{Integer.to_string(timestamp)}.json"])
    content = hbbft_perf()

    IO.puts(path_to_perf_file)

    case File.write(path_to_perf_file, Poison.encode!(content), [:binary]) do
      :ok -> IO.puts("hbbft_perf written to #{path_to_perf_file}")
      {:error, reason} -> IO.puts("failed to write hbbft_perf: #{IO.inspect(reason)}")
    end
  end

  def create_elected_dir() do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()

    {:ok, path} = File.cwd()

    elected_dir = Path.join([path, "hbbft_perf", Integer.to_string(timestamp)])

    case File.mkdir_p(elected_dir) do
      :ok -> {elected_dir, timestamp}
      {:error, reason} -> IO.puts(reason)
    end
  end
end
