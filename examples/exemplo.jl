#
# Exemplo de acesso as novas estruturas de dados
#
include("leitura_dados.jl")


#
# Chamar esta função passando o nome de um arquivo
# yaml de entrada de dados
#
# Exemplo("exemplo.yaml") 
#
function Exemplo(arquivo)

    # Chama a rotina que le e faz o pré-processamento dos dados
    ne,nnos,coord, conect, apoios, dicionario_materiais, dicionario_geometrias, dados_elementos, loads, mpc = Le_YAML(arquivo)

    println("*********************************************************")
    println("          INFORMAÇÕES BÁSICAS")
    println("A malha tem $nnos nós")
    println("A malha tem $ne elementos")
    println("Temos ",length(dicionario_materiais)," materais")
    println("Temos ",length(dicionario_geometrias)," geometrias")
    println("Temos ",size(apoios,1)," apoios")
    println("Temos ",size(loads,1)," carregamentos concentrados")
    println("Temos ",size(mpc,1)," multi point constraints")
    
    
    println("*********************************************************")
    println("             ARRAYS ")
    println("As coordenadas dos nós são:")
    println(coord)
    println("As conectividades são:")
    println(conect)
    println("Os apoios são:")
    println(apoios)
    println("As forças concentradas são:")
    println(loads)
    println("As MPC são:")
    println(mpc)
    
    
    println("*********************************************************")
    println("             DICIONÁRIOS ")
    println("As informações sobre os materiais são:")
    println()
    for mat in keys(dicionario_materiais)
 
        println("Material $mat")

        for (prop,value) in dicionario_materiais[mat]
            println("Propriedade $prop tem valor $value")
        end
        println()

    end
    
    println("As informações sobre as geometrias são:")
    println()
    for geo in keys(dicionario_geometrias)
 
        println("Geometria $geo")

        for (prop,value) in dicionario_geometrias[geo]
            println("Propriedade $prop tem valor $value")
        end
        println()

    end
   

    # Agora vamos para o principal, como acessar os dados dos elementos na montagem 
    # do problema global, por exemplo
    for ele=1:ne

        # O nome do material do elemento pode ser acessado diretamente da matriz de dados_elementos
        mat = dados_elementos[ele,1]

        # Todos os dados do material estão em um dicionário local
        material = dicionario_materiais[mat]

        # O nome da geometria do elemento pode ser acessado diretamente da matriz de dados_elementos
        geo = dados_elementos[ele,2]

        # Todos os dados da geometria do elemento estão em um dicionário local
        geometria = dicionario_geometrias[geo]

        println("O elemento $ele tem material                                             ", mat)
        println("O módulo de elasticidade Ex do material do elemento é                    ", material["Ex"])
        println("O módulo de cisalhamento  G do material do elemento é                    ", material["G"])
        println()

        println("O elemento $ele tem geometria                                             ", geo)
        println("A área da seção transversal do elemento é                                 ", geometria["A"])
        println("O momento de inéricia Iz da seção transversal do elemento é               ", geometria["Iz"])
        println("O momento de inéricia Iy da seção transversal do elemento é               ", geometria["Iy"])
        println("O momento polar de inéricia J0 da seção transversal do elemento é         ", geometria["J0"])
        println("O ângulo central principal de inércia da seção transversal do elemento é  ", geometria["α"])
        println()   
        
   
    end
    


   
end
