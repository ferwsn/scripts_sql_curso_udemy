	-- QUAL PRODUTO TEVE A MAIOR QUANTIDADE DE VENDAS NO MÊS 7 DO ANO DE 1996 --
	SELECT TOP(1) 
	       det.ProdutoId,
	       prod.Descricao,
	       SUM(det.Quantidade) AS Quantidade
	  FROM tb_detalhe_pedido det,
	       tb_produto prod,
	       tb_pedido ped
	 WHERE det.ProdutoId = prod.ProdutoId
	   AND det.NumeroPedido = ped.NumeroPedido
	   AND ped.DataPedido BETWEEN '01/07/1996' AND '31/07/1996'
      GROUP BY det.ProdutoId,
	       prod.Descricao
      ORDER BY SUM(det.Quantidade) DESC;

	-- QUAL CLIENTE TEVE O MAIOR GASTO DO MÊS 7 DO ANO DE 1996 --
	SELECT TOP(1)
	       ped.ClienteId,
	       cli.NomeCompleto,
	       SUM(det.preco) AS Preco
	  FROM tb_pedido ped,
	       tb_cliente cli,
	       tb_detalhe_pedido det
	 WHERE ped.ClienteId = cli.ClienteId
	   AND ped.NumeroPedido = det.NumeroPedido
	   AND ped.DataPedido BETWEEN '01/07/1996' AND '31/07/1996'
      GROUP BY ped.ClienteId,
	       cli.NomeCompleto
  ORDER BY SUM(det.preco) DESC;

	-- LISTA DE TODOS OS CLIENTES QUE MORAM NA ALEMANHA --
	SELECT cli.ClienteId,
	       cli.NomeCompleto
	  FROM tb_cliente cli,
	       tb_endereco edr
	 WHERE cli.ClienteId = edr.ClienteId
	   AND edr.Pais = 'ALEMANHA';

	-- LISTA DE TODOS OS CLIENTES QUE COMPRARAM PRODUTOS NA CATEGORIA 'BEBIDA' --
	 SELECT DISTINCT 
	        a.ClienteID,
	        a.NomeCliente
	   FROM (SELECT det.NumeroPedido,
			ped.ClienteId,
			(SELECT aa.NomeCompleto
			   FROM tb_cliente aa
			  WHERE aa.ClienteId = ped.ClienteId) AS NomeCliente,
			det.ProdutoId,
			prd.Descricao AS DescricaoProduto,
			cat.Descricao AS DescricaoCategoria
		   FROM tb_detalhe_pedido det,
			tb_pedido ped,
			tb_produto prd,
			tb_categoria cat
		  WHERE det.NumeroPedido = ped.NumeroPedido
		    AND prd.CategoriaId = cat.CategoriaId
		    AND det.ProdutoId = prd.ProdutoId
		    AND cat.Descricao LIKE '%BEBIDA%') a;

	-- DESCRIÇÃO DOS PRODUTOS QUE POSSUEM O PREÇO MAIOR QUE A MÉDIA --
	SELECT prod.ProdutoId,
	       prod.Descricao,
	       prod.Preco
	  FROM tb_produto prod
	 WHERE prod.Preco > (SELECT ROUND(AVG(Preco),2) AS PrecoMedio
			       FROM tb_produto prod);

	-- TODOS OS CLIENTES QUE TEM PEDIDOS NO MÊS 7 DE 1996 --
	SELECT a.ClienteId,
	       a.NomeCompleto
	  FROM (SELECT TOP(1000)
	               ped.ClienteId,
	               cli.NomeCompleto,
	               SUM(det.preco) AS Preco
		  FROM tb_pedido ped,
		       tb_cliente cli,
		       tb_detalhe_pedido det
		 WHERE ped.ClienteId = cli.ClienteId
		   AND ped.NumeroPedido = det.NumeroPedido
		   AND ped.DataPedido BETWEEN '01/07/1996' AND '31/07/1996'
	      GROUP BY ped.ClienteId,
		       cli.NomeCompleto
	      ORDER BY SUM(det.preco) DESC) a

	-- NOME E TOTAL DE PEDIDOS DE CADA CLIENTE  --
	SELECT ped.ClienteId,
	       (SELECT a.NomeCompleto
		  FROM tb_cliente a
		 WHERE ped.ClienteId = a.ClienteId) AS NomeCompleto,
	       COUNT(ped.NumeroPedido) AS QuantidadePedido
	  FROM tb_pedido ped
      GROUP BY ped.ClienteId
      ORDER BY COUNT(ped.NumeroPedido) DESC;

	-- QUAIS CARGOS POSSUEM MEDIA SALARIAL MAIOR QUE A MEDIA SALARIAL DO CARGO DE COORDENADOR DE VENDAS INTERNAS --	
	SELECT *
	  FROM (SELECT func.Cargo,
		       AVG(func.Salario) AS Salario
		  FROM tb_funcionario func
	      GROUP BY func.Cargo) a
	         WHERE a.Salario > (SELECT AVG(func.Salario)
				      FROM tb_funcionario func
				     WHERE func.Cargo = 'COORDENADOR DE VENDAS INTERNAS');

	-- OU --

	SELECT func.Cargo,
	       AVG(func.Salario) AS Salario
	  FROM tb_funcionario func
      GROUP BY func.Cargo
        HAVING AVG(func.Salario) > (SELECT AVG(func.Salario)
				      FROM tb_funcionario func
				     WHERE func.Cargo = 'COORDENADOR DE VENDAS INTERNAS');

	-- VENDEDOR QUE TEVE O MAIOR VALOR DE VENDAS --
	SELECT TOP(1)
	       ped.FuncionarioId,
	       func.NomeCompleto,
	       SUM(det.Preco) AS Preco
	  FROM tb_detalhe_pedido det,
	       tb_pedido ped,
	       tb_funcionario func
	 WHERE det.NumeroPedido = ped.NumeroPedido
	   AND ped.FuncionarioId = func.FuncionarioId
      GROUP BY ped.FuncionarioId,
	       func.NomeCompleto
      ORDER BY SUM(det.Preco) DESC;
