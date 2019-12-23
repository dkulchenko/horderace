defmodule Horderace.DistributedStarter do
  require Logger
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    Horde.DynamicSupervisor.start_child(Horderace.DistributedSupervisor, %{
      id: :random_process,
      start: {Horderace.TestProcess, :start_link, []}
    })
    |> ensure_child_started(Horderace.TestProcess)

    :ignore
  end

   def ensure_child_started({:ok, _pid}, process_name) do
    Logger.info("started #{process_name}")

    :ok
  end

  def ensure_child_started(:ignore, process_name) do
    Logger.info("#{process_name} reported :ignore (likely already started), skipping")
    :ok
  end

  def ensure_child_started({:error, reason}, _process_name), do: raise(inspect(reason))
end
