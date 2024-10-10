defmodule DummyWeb.MyPlug do
  @behaviour Plug

  @impl Plug
  def init(opts), do: opts
  
  @impl Plug
  def call(conn, opts) do
    Appsignal.instrument("MyPlug", fn span ->
      try do
        raise "boom"
      rescue
        exception ->
          Appsignal.set_error(exception, __STACKTRACE__)
          reraise exception, __STACKTRACE__
      end
    end)
  end
end
