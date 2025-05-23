defmodule ChatEmpresarial.Servidor do

  @moduledoc """
  Este módulo se encarga de manejar la comunicación entre el servidor y los clientes.
  """
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{
      usuarios: %{},
      salas: %{"general" => []},
      mensajes: %{"general" => []}
    }, name: {:global, __MODULE__})
  end
  def init(state), do: {:ok, state}

  
end
