-- Criacao de Function para Buscar Atendimentos pelo CPF
USE SmartPet;
GO

CREATE OR ALTER FUNCTION buscarAtendimentosPorCliente (@cpf_cliente CHAR(11))
	RETURNS TABLE AS
		RETURN
			(
			SELECT 
				a.id_atendimento as 'ID Atendimento',
				p.nome_pet as 'Pet',
				i.nome_item as 'Serviço',
				s.duracao_servico as 'Duração',
				a.data_marcacao as 'Marcação em',
				a.data_atendimento as 'Data Atendimento',
				a.hora_atendimento as 'Hora Atendimento',
				e.nome_especialista as 'Especialista'
			FROM Atendimento as a
			INNER JOIN Pet as p ON a.matricula_pet = p.matricula_pet
			INNER JOIN Servico as s ON a.id_servico = s.id_servico
			INNER JOIN Item as i ON i.id_item = s.id_item
			INNER JOIN Especialista as e ON a.matricula_especialista = e.matricula_especialista
			WHERE a.cpf_cliente = @cpf_cliente
			);

GO

SELECT * FROM buscarAtendimentosPorCliente('01234567890');