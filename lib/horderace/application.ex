defmodule Horderace.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Cluster.Supervisor,
       [
         [
           horderace: [
             strategy: Cluster.Strategy.Epmd,
             config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
           ]
         ],
         [name: Horderace.ClusterSupervisor]
       ]},
      {Horde.Registry,
       [
         name: Horderace.DistributedRegistry,
         keys: :unique,
         members: :auto
       ]},
      {Horde.DynamicSupervisor,
       [name: Horderace.DistributedSupervisor, strategy: :one_for_one, members: :auto]},
      Horderace.DistributedStarter
      # Starts a worker by calling: Horderace.Worker.start_link(arg)
      # {Horderace.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Horderace.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
