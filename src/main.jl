

# A função principal será:
"""
Rotina principal que calcula o vetor de deslocamento de um pórtico 3D

Uso:

Analise_Portico3D(arquivo;verbose=true)

onde arquivo deve apontar para um .yaml com os dados  e verbose
indica se queremos que a rotina faça comentários ao longo da
execução.

"""
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

    # Cria um problema linear para ser solucionado pelo LinearSolve
    # U = KA\FA
    prob = LinearProblem(KA,FA)
    linsolve = init(prob)
    U_ = solve(linsolve)
    U = U_.u[1:6*nnos]

    # Calcula as forças do modelo, usando somente os deslocamentos e rotações
    # i.e, sem os multiplicadores
    Forcas = KG*U

    # Usa o nome do arquivo .yaml como base para o arquivo de saída
    arquivo_saida = arquivo[1:end-5]*".txt"

    verbose && println("Abrindo $(arquivo_saida) para escrita dos resultados")

    # Abre um arquivo de texto para saída
    saida = open(arquivo_saida,"w")

    # Mostra de forma organizada os resultados
    gls = ["ux","uy","uz","θx", "θy", "θz"]
    contador = 1
    println(saida,"********** Deslocamentos e rotações do modelo **********")
    for no=1:nnos

        println(saida,"Nó ",no)

        for gl=1:6
            println(saida,"     ",gls[gl]," ",U[contador])
            contador += 1
        end

    end

    println(saida)
    println(saida)


    glsf = ["Fx","Fy","Fz","Mx", "My", "Mz"]
    contador = 1
    println(saida,"********** Forças e momentos do modelo **********")
    for no=1:nnos

        println(saida,"Nó ",no)

        for gl=1:6
            println(saida,"     ",glsf[gl]," ",Forcas[contador])
            contador += 1
        end

    end

    # Fecha o arquivo de escrita
    close(saida)

    # Devolve os deslocamentos e rotações sem os multiplicadores
    # e as forças
    return U, Forcas, linsolve

end
