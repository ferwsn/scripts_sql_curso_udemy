	-- SIMULACAO INDICADOR DE CLIENTES POR META --
	-- CONSIDERANDO META DE 5000 --
			SELECT a.NomeCompleto,
				   a.Contato,
				   CONCAT(a.MesPeriodo,'/',a.AnoPeriodo) AS Periodo,
				   SUM(a.Quantidade) AS Quantidade,
				   SUM(a.Preco) AS Preco,
				   (SUM(a.Quantidade) * SUM(a.Preco)) AS TotalMensal,
				   CASE
				        WHEN (SUM(a.Quantidade) * SUM(a.Preco)) >= 5000
						THEN 'ATINGIDO'
						ELSE 'NÃO-ATINGIDO'
				   END AS StatusMeta
			  FROM (SELECT (SELECT aa.NomeCompleto
							  FROM tb_cliente aa
							 WHERE aa.ClienteId = ped.ClienteId) AS NomeCompleto,
						   (SELECT bb.Contato
							  FROM tb_cliente bb
							 WHERE bb.ClienteId = ped.ClienteId) AS Contato,
						   MONTH(ped.DataPedido) AS MesPeriodo,
						   YEAR(ped.DataPedido) AS AnoPeriodo,
						   det.Quantidade,
						   det.Preco
					  FROM tb_pedido ped,
						   tb_detalhe_pedido det
					 WHERE ped.NumeroPedido = det.NumeroPedido) a
          GROUP BY a.NomeCompleto,
				   a.Contato,
				   a.MesPeriodo,
				   a.AnoPeriodo
		  ORDER BY a.AnoPeriodo,
		           a.MesPeriodo;		
