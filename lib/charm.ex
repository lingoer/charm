defmodule Charm do
  use Monad

  defmacro __using__(opt \\ []) do
    quote do
      import Charm.Primitives
      import Charm.Combinators
    end
  end

  def return(x), do: &({x, &1})

  def bind(parser, f) do
    fn input ->
      case parser.(input) do
        {result, remain} -> f.(result).(remain)
        x -> x
      end
    end
  end

end
