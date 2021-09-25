defmodule PbauApi do
  alias Poison.Parser

  use Tesla, only: [:post], docs: false

  plug(Tesla.Middleware.BaseUrl, "http://pbau.painlesspm.com:4647")
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

  def height do
    {:ok, %{body: body}} = post("/", %{jsonrpc: "2.0", id: 1, method: "info_height"}, [])
    %{"result" => %{"height" => height}} = Parser.parse!(body)
    height
  end
end
