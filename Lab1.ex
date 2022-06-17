defmodule  Lab1 do

#Funcion que recibe una operacion en forma de atomico y dos numeros, regresa
#el resultado de aplicar la operacion pasada como parametro a ambos numeros.
  def calc(op,a,b) do
    case op do
       :sum -> a + b
       :rest -> a - b
       :mult -> a * b
       :div -> if b==0 do
         "Error: No puedes dividir entre cero."
       else
        a/b
       end
       :div_ent -> if b==0 do
        "Error: No puedes dividir entre cero."
       else
        div(a,b)
       end
       :mod -> if b==0 do
        "Error: No puedes dividir entre cero."
       else
        rem(a,b)
       end
    end
  end

  #Funcion que regresa la reversa de una lista.
  def rev(l) do
    case l do
      []-> []
      [a|r]-> rev(r) ++ [a]
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

  #Funcion que quita los elementos duplicados de una lista.
  def dup(l) do
    case l do
      []-> []
      [a|r]-> [a] ++ dup(quita(a,r))
    end
  end
end
