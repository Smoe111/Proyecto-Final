defmodule ChatEmpresarial.Salas do

  @moduledoc """
  Este módulo gestiona las salas de chat y los comandos asociados a ellas.
  """
 @path "historial/"

  defstruct [:nombre, usuarios: MapSet.new(), mensajes: []]  # el Mapset garantiza que no haya usuarios repetidos

  def añadir_usuario(%_MODULE_{}= sala, usuario) do  # el mapa es lo mismo que decir %ChatEmpresarial.Salas{}
    %{sala | usuarios: MapSet.put(sala.usuarios, usuario)}
  end

  def eliminar_usuario(%_MODULE_{}= sala, usuario) do
    %{sala | usuarios: MapSet.delete(sala.usuarios, usuario)}
  end

end
