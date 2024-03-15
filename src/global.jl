#####################################################################################
#                 Rotina para montagem da matriz de rigidez global                  #
#####################################################################################

function Monta_Kg(ne::Int64,nnos::Int64,elems::Matrix{Int64},dados_elementos::Matrix{String},
                 dicionario_materiais, dicionario_geometrias, L::Vector{Float64}, coord::Matrix)


# Aloca a matriz de rigidez global
KG = spzeros(6*nnos, 6*nnos)

# Passando pelos elementos da malha
for e=1:ne

    # Descobre os dados do Elemento
    Le = L[e]

    # Dados dos materais
    mat = dados_elementos[e,1]

    # Todos os dados do material estão em um dicionário local
    material = dicionario_materiais[mat]

    # E podemos recuperar os dados usando os nomes como chaves
    Ee = material["Ex"]
    Ge = material["G"]

    # O nome da geometria do elemento pode ser acessado diretamente da matriz de dados_elementos
    geo = dados_elementos[e,2]

    # Todos os dados da geometria do elemento estão em um dicionário local
    geometria = dicionario_geometrias[geo]

    Ize = geometria["Iz"]
    Iye = geometria["Iy"]
    J0e = geometria["J0"]
    Ae  = geometria["A"]
    αe  = geometria["α"]

    # Montra a matriz do elemento
    Ke = Ke_portico3d(Ee, Ize, Iye, Ge, J0e, Le, Ae)

    # Monta a matriz de rotação do elemento
    R = Rotacao3d(e, elems, coord, αe)


    # Descobre os nós do elemento
    no1,no2 = elems[e,:]

    # Monta o vetor com os graus de liberdade do elemento
    gls = [6*(no1-1)+1; 6*(no1-1)+2; 6*(no1-1)+3; 6*(no1-1)+4; 6*(no1-1)+5; 6*(no1-1)+6;
           6*(no2-1)+1; 6*(no2-1)+2; 6*(no2-1)+3; 6*(no2-1)+4; 6*(no2-1)+5; 6*(no2-1)+6]

    # Sobreposição na matriz global
    KG[gls,gls] .= KG[gls,gls] .+ R'*Ke*R

end

return KG


end

#####################################################################################
#                      Montagem do vetor de forças concentradas                     #
#####################################################################################

function Monta_FG(loads::Array{Float64}, nnos::Int64)

    # Aloca o vetor global
    FG = zeros(6*nnos)

    # Loop pelas informações dos carregamentos concentrados
    for i=1:size(loads,1)


        # Descobre o nó
        no = Int(loads[i,1])

        # Descobre o gl(local)
        gl = Int(loads[i,2])

        #Descobre o valor
        valor = loads[i,3]

        # O grau de liberdade global
        glg = 6*(no-1)+gl

        # Sobrepoe no gl
        FG[glg] = FG[glg] + valor
    end

    # Retorna o vetor
    return FG
end


#####################################################################################
#                      Montagem do vetor de forças distribuídas                     #
#####################################################################################

function Monta_FD(floads::Array{Float64}, elems::Matrix{Int64}, nnos::Int64, L, dicionario_geometrias, coord, dados_elementos::Matrix{String}, ne::Int64)


    # Vetor global
    FD = zeros(6*nnos)

    # Usando um laço para a montagem de FD, passando pelas linhas do fload
    for j=1:size(floads,1)

        e=Int(floads[j,1])

        # O nome da geometria do elemento pode ser acessado diretamente da matriz de dados_elementos
        geo = dados_elementos[e,2]

        # Todos os dados da geometria do elemento estão em um dicionário local
        geometria = dicionario_geometrias[geo]

        # Descobre o valor do carregamento "inicial" em y
        q1y = floads[j,2]

        # Descobre o valor do carregamento "final" em y
        q2y = floads[j,3]

        # Descobre o valor do carregamento "inicial" em z
        q1z = floads[j,4]

        # Descobre o valor do carregamento "final" em z
        q2z = floads[j,5]

        αe  = geometria["α"]

        # Descobre o nó:
        # (Precisamos incluir tanto o nó referente a q1 quanto o nó referente a q2)
        no1, no2 = elems[e,:]

        Le = L[e]

        # Descobre o grau de liberdade global:
        gls = [6*(no1-1)+1; 6*(no1-1)+2; 6*(no1-1)+3; 6*(no1-1)+4; 6*(no1-1)+5; 6*(no1-1)+6;
        6*(no2-1)+1; 6*(no2-1)+2; 6*(no2-1)+3; 6*(no2-1)+4; 6*(no2-1)+5; 6*(no2-1)+6]

        F_elemento = Fe_viga(Le, q1y, q2y, q1z, q2z)

        # Monta a matriz de rotação do elemento
        R = Rotacao3d(e, elems, coord, αe)

        FD[gls] .= FD[gls] .+ R'*F_elemento

    end

    return FD
end
