defmodule Charm.Primitives do

  def return(x), do: Charm.return(x)

  def fail, do: fn _ -> :error end

  def any do
    &Charm.Parseable.to_state/1
  end

  def satisfy(predicate) do
    require Charm
    Charm.m do
      x <- any
      if predicate.(x), do: return(x), else: fail
    end
  end

  def token(x) do
    satisfy &(&1 == x)
  end

  def tokens([]), do: return [] 
  def tokens([x|xs]) do
    require Charm
    Charm.m do
      t <- token(x)
      ts <- tokens(xs)
      return [t|ts]
    end
  end

end
