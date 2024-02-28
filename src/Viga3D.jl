module Viga3D
 
	using LinearAlgebra

	# Carregando as outras rotinas:
	include("leitura_dados.jl")
	include("pre_processamento.jl")
	include("rotacao.jl")
	include("global.jl")
	include("Kg_portico.jl")
	include("apoios.jl")
	include("main.jl")

	export 	Analise_Portico3D

end

