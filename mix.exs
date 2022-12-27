defmodule LivebookDalle.MixProject do
  use Mix.Project

  @version "0.1.4"
  @description "DALL-E integration for Livebook"

  def project do
    [
      app: :dalle,
      version: @version,
      description: @description,
      name: "LivebookDalle",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      mod: {LivebookDalle.Application, []}
    ]
  end

  defp deps do
    [
      {:kino, "~> 0.8"},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
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
