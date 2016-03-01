defmodule Charm.Combinators do

  def map(parser, f), do: Charm.bind(parser, &(Charm.return(f.(&1))))
  
  def as(parser, x), do: parser |> map(fn _ -> Charm.return x end)

  def rescue_with(p, rescuer) do
    fn input ->
      case p.(input) do
        :error -> rescuer.(input)
        x -> x
      end
    end
  end

  def choice (ps) do
    Enum.reduce(ps,&(rescue_with(&2,&1)))
  end

  def opt(parser, default) do
    [parser, Charm.return(default)] |> choice
  end

  def except(p, exception) do
    fn input ->
      case exception.(input) do
        :error -> p.(input)
        _ -> :error
      end 
    end
  end

  def many(parser) do
    require Charm
    Charm.m do
      h <- parser
      t <- many(parser)
      return [h|t]
    end |> opt([])
  end

  def sep_by1(parser,sep) do
    require Charm
    Charm.m do
      h <- parser
      t <- Charm.m do
        sep
        sep_by(parser, sep)
      end |> opt([])
      return [h|t]
    end
  end

  def sep_by(parser, sep), do: sep_by1(parser, sep) |> opt([])

end
