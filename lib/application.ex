defmodule LivebookDalle.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(LivebookDalle.TaskCell)

    children = []
    opts = [strategy: :one_for_one, name: LivebookDalle.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
