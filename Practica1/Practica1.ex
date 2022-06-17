defmodule Module1 do

  def fibonacci(n) do
    case n do
      0 -> 0
      1 -> 1
      _ -> fibonacci(n-1) + fibonacci(n-2)
    end
  end

  def factorial(n) do
    case n do
      1 -> 1
      _ -> n*factorial(n-1)
    end
  end

  def random_probability(n) do
    #Dado un número n, escoger un número aleatorio en el rango [1, n], digamos k
    #y determinar cuál es la probabilidad de que salga un número aleatorio
    #entre [k, n], el chiste obtener el número aleatorio.
    ((n - :rand.uniform(n))+1)/n
  end

  def digits(n) do
    if n<10 do
      [n]
    else
      digits(div(n,10))++[rem(n,10)]
    end
  end

end

defmodule Module2 do
  def test() do
    lambda = fn() -> :ok end
    lambda.()
  end

  defp mcd(a,b) do
    if a<b do
      mcd(b,a)
    end
    if b==0 do
      a
    else
      mcd(b,rem(a,b))
    end
  end

  def solve(a,b,n) do
    if rem(b,mcd(a,n))==0  do
      true
    else
      :error
    end
  end
end

defmodule Module3 do

  def rev(l) do
    case l do
      []-> []
      [h|t]-> rev(t) ++ [h]
    end
  end

  #Funcion auxiliar que quita todas las apariciones de un elemento en una lista.
  defp quita(x,l) do
    case l do
      []-> []
      [a|r]-> if x==a do
        quita(x,r)
      else
        [a] ++ quita(x,r)
      end
    end
  end

  def elim_dup(l) do
    case l do
      []-> []
      [h|t]-> [h] ++ elim_dup(quita(h,t))
    end
  end

  #Funcion auxiliar para el calculo de la criba de Erathostenes.
  defp criba(l,n,i) do
    if :math.pow(Enum.at(l,i),2)<n do
      primos = Enum.slice(l,0,i+1)
      l = primos ++ Enum.reject(Enum.drop(l,i+1),fn e -> rem(e,Enum.at(primos,i))==0 end)
      criba(l,n,i+1)
    else
      l
    end
  end

  def sieve_of_erathostenes(n) do
    if n<2 do
      []
    else
      criba(Enum.to_list(2..n),n,0)
    end
  end

end

defmodule Module4 do

  def monstructure() do
    spawn(fn -> loop([],{},MapSet.new(),%{},0) end)
  end

  defp loop(lista,tupla,mapset,map,cuentaMS) do
    receive do
      #Imprime el estado actual de la estructura.
      {:get_status} -> IO.puts("Lista: #{inspect lista},Tupla: #{inspect tupla}, Mapset: #{inspect mapset}, Map: #{inspect map}")
      loop(lista,tupla,mapset,map,cuentaMS)
      #listas
      {:put_list, e} -> loop(lista++[e],tupla,mapset,map,cuentaMS)
      {:rem_list, e} -> loop(List.delete(lista,e),tupla,mapset,map,cuentaMS)
      {:get_list_size, caller} ->
        send(caller,length(lista))
        loop(lista,tupla,mapset,map,cuentaMS)
      #tuplas
      {:get_tuple, caller} ->
        send(caller,tupla)
        loop(lista,tupla,mapset,map,cuentaMS)
      {:tup_to_list, caller} ->
        send(caller,Tuple.to_list(tupla))
        loop(lista,tupla,mapset,map,cuentaMS)
      {:put_tuple, e} -> loop(lista,Tuple.append(tupla,e),mapset,map,cuentaMS)
      {:tuple_insert_at,i,e} ->
        if i<0||i>tuple_size(tupla) do
          IO.puts("El indice es negativo o mayor que el tamaño de la lista")
          loop(lista,tupla,mapset,map,cuentaMS)
        else
          loop(lista,put_elem(tupla,i,e),mapset,map,cuentaMS)
        end
      #mapsets
      {:mapset_contains, e, caller} ->
        send(caller,MapSet.member?(mapset,e))
        loop(lista,tupla,mapset,map,cuentaMS)
      {:mapset_add, e} ->
        if MapSet.member?(mapset,e)==true do
          loop(lista,tupla,mapset,map,cuentaMS)
        else
          loop(lista,tupla,MapSet.put(mapset,e),map,cuentaMS+1)
        end
      {:mapset_size, caller} ->
        send(caller,cuentaMS)
        loop(lista,tupla,mapset,map,cuentaMS)
      #maps
      {:map_put,k,v} -> loop(lista,tupla,mapset,Map.put(map,k,v),cuentaMS)
      {:map_get,k,caller} ->
        send(caller,Map.get(map,k))
        loop(lista,tupla,mapset,map,cuentaMS)
      {:map_lambda,k,lambda,o} -> loop(lista,tupla,mapset,Map.put(map,k,lambda.(Map.get(map,k),o)),cuentaMS)
      _ ->
        IO.puts("mensaje no reconocido")
        loop(lista,tupla,mapset,map,cuentaMS)
    end
  end
end
