defmodule Charm.Parser do
  use Charm

  def trimed(x) do
    white_spaces = ' \t\r\n' |> Enum.map(&(token &1)) |> choice |> many
    Charm.m do
      white_spaces
      t <- token(x)
      white_spaces
      return t
    end
  end

  def string do
    chars = any |> except(token(?"))
    escape = tokens('\\\"') |> as(?")
    Charm.m do
      token(?"); s <- [escape, chars] |> choice |> many; token(?")
      return to_string(s)
    end
  end

  def number, do: &Float.parse/1

  def bool, do: ['true','false'] |> Enum.map(&(tokens &1)) |> choice |> map(&List.to_atom/1)

  def null, do: tokens('null') |> as(nil)

  def list do
    Charm.m do
      trimed(?[); l <- json |> sep_by(trimed(?,)); trimed(?])
      return l
    end
  end

  def object do
    kv_pair = Charm.m do
      k <- string; trimed(?:); v <- json
      return {String.to_atom(k), v}
    end
    Charm.m do
      trimed(?{); o <- kv_pair |> sep_by(trimed(?,)); trimed(?})
      return o
    end
  end

  def json do
    [number,
     string,
     bool,
     null,
     list,
     object] |> choice
  end

end
