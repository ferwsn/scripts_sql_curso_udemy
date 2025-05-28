-- FATURAMENTO DE PRODUTOS POR CATEGORIA EM 1996 --
	SELECT a.Descricao,
	       a.DataPedido AS AnoAnalise,
	       SUM(a.Faturamento) AS FaturamentoAnual,
	       ROUND(((SUM(CAST(a.Faturamento AS FLOAT)) / CAST(b.FaturamentoTotal AS FLOAT)) * 100),2) AS Percentual
	  FROM (SELECT det.ProdutoId,
		       prd.CategoriaId,
		       cat.Descricao,
		       det.Preco,
		       det.Quantidade,
	     	       ROUND((det.Preco * det.Quantidade),2) AS Faturamento,
	   	       (SELECT YEAR(aa.DataPedido)
			  FROM tb_pedido aa
		         WHERE aa.NumeroPedido = det.NumeroPedido) AS DataPedido
		  FROM tb_detalhe_pedido det,
		       tb_produto prd,
		       tb_categoria cat
		 WHERE det.ProdutoId = prd.ProdutoId
		   AND prd.CategoriaId = cat.CategoriaId) a,
	       (SELECT ROUND(SUM(det.Preco * det.Quantidade),2) AS FaturamentoTotal
		  FROM tb_detalhe_pedido det,
		       tb_pedido ped
	         WHERE det.NumeroPedido = ped.NumeroPedido
		   AND ped.DataPedido LIKE '1996%') b
	WHERE a.DataPedido = '1996'
     GROUP BY a.Descricao,
	      a.DataPedido,
              b.FaturamentoTotal;
     GROUP BY a.Descricao,
	      a.DataPedido,
              b.FaturamentoTotal;
