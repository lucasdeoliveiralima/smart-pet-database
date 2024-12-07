-- Criacao de Procedure para Consultar NFs pelo CPF
USE SmartPet;
GO

CREATE OR ALTER PROCEDURE consultarNFPorCPF (@cpf_cliente CHAR(11)) AS
	BEGIN
		SELECT 
			nf.id_notaFiscal as 'ID Nota Fiscal',
			c.cpf_cliente as 'CPF',
			c.nome_cliente as 'Nome',
			i.nome_item as 'Item adquirido',
			nfi.quantidade as 'Quantidade',
			nfi.valor as 'Valor Total'
		FROM
			Cliente as c INNER JOIN NotaFiscal as nf ON c.cpf_cliente = nf.cpf_cliente
			INNER JOIN NotaFiscal_Item as nfi ON nf.id_notaFiscal = nfi.id_notaFiscal
			INNER JOIN Item as i ON i.id_item = nfi.id_item
		WHERE
			c.cpf_cliente = @cpf_cliente
		ORDER BY
			nf.id_NotaFiscal;
	END

	GO

	EXEC consultarNFPorCPF '01234567890'
