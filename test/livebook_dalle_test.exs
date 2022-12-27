defmodule LivebookDalleTest do
  use ExUnit.Case
  doctest LivebookDalle

  test "greets the world" do
    assert LivebookDalle.hello() == :world
  end
end
