defmodule Dummy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DummyWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:dummy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Dummy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Dummy.Finch},
      # Start a worker by calling: Dummy.Worker.start_link(arg)
      # {Dummy.Worker, arg},
      # Start to serve requests, typically the last entry
      DummyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dummy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DummyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
