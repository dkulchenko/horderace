defmodule Horderace.TestProcess do
  require Logger

  use GenServer

  def via_tuple(), do: {:via, Horde.Registry, {Horderace.DistributedRegistry, __MODULE__}}

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: via_tuple())
    |> case do
      {:ok, pid} ->
        Logger.info("started #{__MODULE__} locally")
        {:ok, pid}

      {:error, {:already_started, _pid}} ->
        Logger.info(" #{__MODULE__} already started in cluster")
        :ignore
    end
  end

  def init(_), do: {:ok, nil}
end
