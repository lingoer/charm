
defprotocol Charm.Parseable do
  def to_state(input)
end

defimpl Charm.Parseable, for: BitString do

  def to_state(<<x::utf8, rest::binary>>), do: {x, rest}
  def to_state(_), do: :error

end