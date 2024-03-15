
using Test
using Viga3D

@testset "Portico Dan" begin

    # Chama o programa
    U,F,_ = Analise_Portico3D("../examples/exemplo_popov.yaml",verbose=false)

    # Compara a resposta do nó 4 com os valores de referência
    ux4 = U[6*(4-1)+1]
    uy4 = U[6*(4-1)+2]
    uz4 = U[6*(4-1)+3]
    tx4 = U[6*(4-1)+4]
    ty4 = U[6*(4-1)+5]
    tz4 = U[6*(4-1)+6]

    @test isapprox(ux4,0.0117,atol=1E-4)
    @test isapprox(uy4,0.0206,atol=1E-4)
    @test isapprox(uz4,-0.0206,atol=1E-4)

    @test isapprox(tx4,-0.2084,atol=1E-4)
    @test isapprox(ty4,0.1119,atol=1E-4)
    @test isapprox(tz4,-0.0077,atol=1E-4)

end

@testset "Força Y na ponta" begin

    # Chama o programa
    U,F,_ = Analise_Portico3D("../examples/f_ponta_y.yaml",verbose=false)

    # Compara a resposta do nó 4 com os valores de referência
    ux3 = U[6*(3-1)+1]
    uy3 = U[6*(3-1)+2]
    uz3 = U[6*(3-1)+3]
    tx3 = U[6*(3-1)+4]
    ty3 = U[6*(3-1)+5]
    tz3 = U[6*(3-1)+6]

    # Resultado teórico
    Iz = 0.000003125
    Iy = 0.000005347
    E = 30E9
    W = 1000
    vmax = (W)/(3*E*Iz)
    thetamax = (W)/(2*E*Iz)

    # Compara com os valores conhecidos
    @test isapprox(uy3,vmax,atol=1E-4)
    @test isapprox(tz3,thetamax,atol=1E-4)

    # Os demais devem dar "zero"
    @test isapprox(ux3,0.0,atol=1E-4)
    @test isapprox(uz3,0.0,atol=1E-4)
    @test isapprox(tx3,0.0,atol=1E-4)
    @test isapprox(ty3,0.0,atol=1E-4)

end

@testset "Força Z na ponta" begin

    # Chama o programa
    U,F,_ = Analise_Portico3D("../examples/f_ponta_z.yaml",verbose=false)

    # Compara a resposta do nó 4 com os valores de referência
    ux3 = U[6*(3-1)+1]
    uy3 = U[6*(3-1)+2]
    uz3 = U[6*(3-1)+3]
    tx3 = U[6*(3-1)+4]
    ty3 = U[6*(3-1)+5]
    tz3 = U[6*(3-1)+6]

    # Resultado teórico
    Iz = 0.000003125
    Iy = 0.000005347
    E = 30E9
    W = 1000
    vmax = (W)/(3*E*Iy)
    thetamax = -(W)/(2*E*Iy)

    # sinal negativo pela notação


    # Compara com os valores conhecidos
    @test isapprox(uz3,vmax,atol=1E-4)
    @test isapprox(ty3,thetamax,atol=1E-4)

    # Os demais devem dar "zero"
    @test isapprox(ux3,0.0,atol=1E-4)
    @test isapprox(uy3,0.0,atol=1E-4)
    @test isapprox(tx3,0.0,atol=1E-4)
    @test isapprox(tz3,0.0,atol=1E-4)

end

@testset "Carregamento distribuido em y" begin

    # Chama o programa

    U, F, _ = Analise_Portico3D("../examples/distribuido_y.yaml", verbose=false)

    # Comparando os valores do nó 2 para deflexao e nó 1 para theta com a referência

    ux3 = U[6*(2-1)+1]
    uy3 = U[6*(2-1)+2]
    uz3 = U[6*(2-1)+3]
    tx3 = U[6*(1-1)+4]
    ty3 = U[6*(1-1)+5]
    tz3 = U[6*(1-1)+6]

    # Resultado teórico:

    Iz = 0.000003125
    Iy = 0.000005347
    E = 30E9
    W = 10
    vmax = (5*W)/(384*E*Iz)
    thetamax = (W)/(24*E*Iz)

    # Compara com os valores conhecidos
    @test isapprox(uy3,vmax,atol=1E-4)
    @test isapprox(tz3,thetamax,atol=1E-4)

    # Os demais devem dar "zero"
    @test isapprox(ux3,0.0,atol=1E-4)
    @test isapprox(uz3,0.0,atol=1E-4)
    @test isapprox(tx3,0.0,atol=1E-4)
    @test isapprox(ty3,0.0,atol=1E-4)



end

@testset "Carregamento distribuido em z" begin

    # Chama o programa

    U, F, _ = Analise_Portico3D("../examples/distribuido_z.yaml", verbose=false)

    # Comparando os valores do nó 2 para deflexao e nó 1 para theta com a referência

    ux3 = U[6*(2-1)+1]
    uy3 = U[6*(2-1)+2]
    uz3 = U[6*(2-1)+3]
    tx3 = U[6*(1-1)+4]
    ty3 = U[6*(1-1)+5]
    tz3 = U[6*(1-1)+6]

    # Resultado teórico:

    Iz = 0.000003125
    Iy = 0.000005347
    E = 30E9
    W = 10
    vmax = (5*W)/(384*E*Iy)
    thetamax = (W)/(24*E*Iy)

    # Compara com os valores conhecidos
    @test isapprox(uz3,vmax,atol=1E-4)
    @test isapprox(ty3,thetamax,atol=1E-4)

    # Os demais devem dar "zero"
    @test isapprox(ux3,0.0,atol=1E-4)
    @test isapprox(uy3,0.0,atol=1E-4)
    @test isapprox(tx3,0.0,atol=1E-4)
    @test isapprox(tz3,0.0,atol=1E-4)



end
