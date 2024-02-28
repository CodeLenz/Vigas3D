

# A função principal será:

function Analise_Portico3D(arquivo; verbose=true)

    # Le os dados do problema
    ne,nnos,coord,elems,apoios,dicionario_materiais,dicionario_geometrias,dados_elementos,loads,mpc, floads = Le_YAML(arquivo)

    # Pré processamento para calcular os comprimentos dos elementos da malha
    L = Pre_processamento(elems, coord)

    # Monta a matriz de rigidez gloal
    KG = Monta_Kg(ne,nnos,elems,dados_elementos,dicionario_materiais, dicionario_geometrias,L,coord)

    # Monta o vetor global de forças concentradas 
    FG = Monta_FG(loads,nnos)

    # Monta o vetor global de forças distribuídas
    FD = Monta_FD(floads, elems, nnos, L, dicionario_geometrias, coord, dados_elementos, ne)

    # Vetor de forças do problema
    F = FG .+ FD

    # Modifica o sistema para considerar as restrições de apoios
    KA, FA = Aumenta_sistema(apoios, mpc, KG, F)
   
    # Soluciona o sistema global de equações para obter U
    U = KA\FA

    # Calcula as forças do modelo
    Forcas = KG*U[1:6*nnos]
   
    
    # Mostra de forma organizada os resultados
    if verbose
        gls = ["ux","uy","uz","θx", "θy", "θz"]
        contador = 1
        println("********** Deslocamentos e rotações do modelo **********")
        for no=1:nnos

            println("Nó ",no)

            for gl=1:6
                println("     ",gls[gl]," ",U[contador])
                contador += 1
            end

        end

        println()
        println()
       

        glsf = ["Fx","Fy","Fz","Mx", "My", "Mz"]
        contador = 1
        println("********** Forças e momentos do modelo **********")
        for no=1:nnos

            println("Nó ",no)

            for gl=1:6
                println("     ",glsf[gl]," ",Forcas[contador])
                contador += 1
            end

        end
    end # verbose
      

    return U[1:6*nnos], Forcas
end

