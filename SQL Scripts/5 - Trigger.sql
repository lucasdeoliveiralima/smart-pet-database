-- Criacao de Trigger para impedir inserções de atendimentos com data de marcação posterior a data de atendimento
USE SmartPet
GO

CREATE OR ALTER TRIGGER validarDatasAtendimento ON Atendimento
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE data_atendimento < data_marcacao
    )
    BEGIN
        RAISERROR ('A data do atendimento não pode ser anterior à data de marcação.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    INSERT INTO Atendimento (id_atendimento, cpf_cliente, matricula_pet, id_servico, data_marcacao, data_atendimento, hora_atendimento, matricula_especialista)
    SELECT id_atendimento, cpf_cliente, matricula_pet, id_servico, data_marcacao, data_atendimento, hora_atendimento, matricula_especialista
    FROM inserted;

    PRINT 'Atendimento inserido com sucesso!';
END;

GO

INSERT INTO Atendimento (matricula_especialista, matricula_pet, id_servico, cpf_cliente, data_marcacao, data_atendimento, hora_atendimento) VALUES
    ('VET03', 5, 2, '01234567890', '2024-10-24', '2024-10-23', '11:45:00');