defmodule KinoDalle.MixProject do
  use Mix.Project

  @version "0.1.0"
  @description "DALL-E integration for Livebook"

  def project do
    [
      app: :kino_dalle,
      version: @version,
      description: @description,
      name: "KinoDalle",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      mod: {KinoDalle.Application, []}
    ]
  end

  defp deps do
    [
      {:kino, "~> 0.8"},
      {:req, "~> 0.3"}
    ]
  end

  def package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/PJUllrich/livebook_dalle"
      }
    ]
  end
end
