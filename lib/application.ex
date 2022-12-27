defmodule KinoDalle.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(KinoDalle.TaskCell)

    children = []
    opts = [strategy: :one_for_one, name: KinoDalle.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
