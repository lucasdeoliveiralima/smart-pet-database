-- Criação do Banco de Dados
CREATE DATABASE SmartPet; 
GO
USE SmartPet;

-- Criação das Tabelas do Banco
CREATE TABLE Cliente(
	cpf_cliente CHAR(11),
	nome_cliente VARCHAR(50) NOT NULL,
	email_cliente VARCHAR(80) NOT NULL UNIQUE,
	telefone_cliente CHAR(14) NOT NULL,
	CONSTRAINT pk_cpf_cliente PRIMARY KEY(cpf_cliente)
);

CREATE TABLE Raca(
	id_raca CHAR(5),
	nome_raca VARCHAR(50) NOT NULL,
	especie_raca VARCHAR(8) NOT NULL,
	porte_raca VARCHAR(9) NOT NULL,
	CONSTRAINT ck_especie_raca CHECK(especie_raca IN('Cachorro', 'Gato')),
	CONSTRAINT ck_porte_raca CHECK(porte_raca IN('Miniatura', 'Pequeno', 'Medio', 'Grande')),
	CONSTRAINT pk_id_raca PRIMARY KEY(id_raca)
);

CREATE TABLE Atendente(
	matricula_atendente INTEGER IDENTITY(1000, 10),
	nome_atendente VARCHAR(50) NOT NULL,
	admissao_atendente DATE NOT NULL,
	CONSTRAINT pk_matricula_atendente PRIMARY KEY(matricula_atendente)
);

CREATE TABLE CategoriaItem(
	id_categoria CHAR(4),
	descricao_categoria VARCHAR(50) NOT NULL,
	tipo_categoria VARCHAR(7) NOT NULL,
	CONSTRAINT ck_tipo_categoria CHECK(tipo_categoria IN('Produto', 'Serviço')),
	CONSTRAINT pk_id_categoria PRIMARY KEY(id_categoria)
);

CREATE TABLE Especialidade(
	id_especialidade CHAR(3),
	descricao_especialidade VARCHAR(50) NOT NULL,
	tipo_especialidade VARCHAR(11) NOT NULL,
	CONSTRAINT ck_tipo_especialidade CHECK(tipo_especialidade IN('Veterinario', 'Groomer')),
	CONSTRAINT pk_id_especialidade PRIMARY KEY(id_especialidade)
);

CREATE TABLE Pet(
	matricula_pet INTEGER IDENTITY,
	cpf_cliente CHAR(11) NOT NULL,
	id_raca CHAR(5) NOT NULL,
	nome_pet VARCHAR(50) NOT NULL,
	comprimento_pet DECIMAL(5,2) NOT NULL,
	peso_pet DECIMAL(5,2) NOT NULL,
	sexo_pet CHAR(1) NOT NULL,
	CONSTRAINT ck_sexo_pet CHECK(sexo_pet IN('M', 'F')),
	CONSTRAINT pk_matricula_pet PRIMARY KEY(matricula_pet),
	CONSTRAINT fk_cpf_cliente_pet FOREIGN KEY(cpf_cliente) REFERENCES Cliente(cpf_cliente)
		ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_id_raca_pet FOREIGN KEY(id_raca) REFERENCES Raca(id_raca)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE Especialista(
	matricula_especialista CHAR(5),
	id_especialidade CHAR(3),
	nome_especialista VARCHAR(50) NOT NULL,
	admissao_especialista DATE NOT NULL,
	CONSTRAINT pk_matricula_especialista PRIMARY KEY(matricula_especialista),
	CONSTRAINT fk_id_especialidade_especialista FOREIGN KEY(id_especialidade) REFERENCES Especialidade(id_especialidade)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE Veterinario(
	id_veterinario INTEGER IDENTITY,
	matricula_especialista CHAR(5) NOT NULL,
	CRMV CHAR(6) NOT NULL,
	CONSTRAINT pk_id_veterinario PRIMARY KEY(id_veterinario),
	CONSTRAINT fk_matricula_especialista_veterinario FOREIGN KEY(matricula_especialista) REFERENCES Especialista(matricula_especialista)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE NotaFiscal(
	id_notaFiscal VARCHAR(10),
	cpf_cliente CHAR(11) NOT NULL,
	matricula_atendente INTEGER NOT NULL,
	data_notaFiscal DATE NOT NULL,
	hora_notaFiscal	TIME(0) NOT NULL,
	tipo_notaFiscal CHAR(7) NOT NULL,
	CONSTRAINT ck_tipo_notaFiscal CHECK(tipo_notaFiscal IN('Produto', 'Serviço')),
	CONSTRAINT pk_id_notaFiscal PRIMARY KEY(id_notaFiscal),
	CONSTRAINT fk_cpf_cliente_notaFiscal FOREIGN KEY(cpf_cliente) REFERENCES Cliente(cpf_cliente)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fk_matricula_atendente_notaFiscal FOREIGN KEY(matricula_atendente) REFERENCES Atendente(matricula_atendente)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE Item(
	id_item CHAR(6),
	id_categoria CHAR(4) NOT NULL,
	nome_item VARCHAR(50) NOT NULL,
	custo_item DECIMAL(6, 2) NOT NULL,
	CONSTRAINT pk_id_item PRIMARY KEY(id_item),
	CONSTRAINT fk_id_categoria_item FOREIGN KEY(id_categoria) REFERENCES CategoriaItem(id_categoria)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE Produto(
	id_produto INTEGER IDENTITY,
	id_item CHAR(6) NOT NULL,
	qtd_estoque INTEGER DEFAULT 0,
	CONSTRAINT pk_id_produto PRIMARY KEY(id_produto),
	CONSTRAINT fk_id_item_produto FOREIGN KEY(id_item) REFERENCES Item(id_item)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE Servico(
	id_servico INTEGER IDENTITY,
	id_item CHAR(6) NOT NULL,
	duracao_servico TIME(0),
	CONSTRAINT pk_id_servico PRIMARY KEY(id_servico),
	CONSTRAINT fk_id_item_servico FOREIGN KEY(id_item) REFERENCES Item(id_item)
		ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE Atendimento(
	id_atendimento INTEGER IDENTITY,
	matricula_especialista CHAR(5) NOT NULL,
	matricula_pet INTEGER NOT NULL,
	id_servico INTEGER NOT NULL,
	cpf_cliente CHAR(11) NOT NULL,
	data_marcacao DATE NOT NULL,
	data_atendimento DATE NOT NULL,
	hora_atendimento TIME(0) NOT NULL,
	CONSTRAINT pk_id_atendimento PRIMARY KEY(id_atendimento),
	CONSTRAINT fk_matricula_especialista_atendimento FOREIGN KEY(matricula_especialista) REFERENCES Especialista(matricula_especialista)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT fk_matricula_pet_atendimento FOREIGN KEY(matricula_pet) REFERENCES Pet(matricula_pet)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT fk_id_servico_atendimento FOREIGN KEY(id_servico) REFERENCES Servico(id_servico)
		ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT fk_cpf_cliente_atendimento FOREIGN KEY(cpf_cliente) REFERENCES Cliente(cpf_cliente)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE NotaFiscal_Item(
	id_item CHAR(6),
	id_notaFiscal VARCHAR(10),
	quantidade INTEGER NOT NULL,
	valor DECIMAL(6, 2) NOT NULL,
	CONSTRAINT pk_item_notaFiscal PRIMARY KEY(id_item, id_notaFiscal),
	CONSTRAINT fk_id_item_nfItem FOREIGN KEY(id_item) REFERENCES Item(id_item)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fk_id_notaFiscal_nfItem FOREIGN KEY(id_notaFiscal) REFERENCES NotaFiscal(id_notaFiscal)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE Especialista_Servico(
	id_servico INTEGER,
	matricula_especialista CHAR(5),
	CONSTRAINT pk_especialista_servico PRIMARY KEY(id_servico, matricula_especialista),
	CONSTRAINT fk_id_servico_especialista_servico FOREIGN KEY(id_servico) REFERENCES Servico(id_servico)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fk_matricula_especialista_especialista_servico FOREIGN KEY(matricula_especialista) REFERENCES Especialista(matricula_especialista)
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Inserindo dados nas tabelas
INSERT INTO Cliente (cpf_cliente, nome_cliente, email_cliente, telefone_cliente) VALUES
    ('87641204958', 'João da Silva', 'joao.silva@email.com', '(81)9321325987'),
    ('12345678901', 'Maria Souza', 'maria.souza@email.com', '(81)9876543210'),
    ('98765432101', 'Pedro Santos', 'pedro.santos@email.com', '(81)9123456789'),
    ('45678901234', 'Ana Oliveira', 'ana.oliveira@email.com', '(81)9789012345'),
    ('01234567890', 'Carlos Silva', 'carlos.silva@email.com', '(81)9456789012'),
    ('78901234567', 'Beatriz Santos', 'beatriz.santos@email.com', '(81)9012345678'),
    ('34567890123', 'Bruno Souza', 'bruno.souza@email.com', '(81)9999999999'),
    ('56789012345', 'Camila Lira', 'camila.lira@email.com', '(81)9888888888'),
    ('23456789012', 'Betania Oliveira', 'betania.oliveira@email.com', '(81)9777777777'),
    ('90123456789', 'Fernanda Santos', 'fernanda.santos@email.com', '(81)9666666666'),
    ('67890123456', 'Gabriel Pereira', 'gabriel.pereira@email.com', '(81)9555555555'),
    ('10111213141', 'Helena Santos', 'helena.santos@email.com', '(81)9444444444'),
    ('14151617181', 'Igor Oliveira', 'igor.oliveira@email.com', '(81)9333333333'),
    ('18192021221', 'Júlia Pereira', 'julia.pereira@email.com', '(81)9222222222'),
    ('22232425261', 'Leonardo Santos', 'leonardo.santos@email.com', '(81)9111111111'),
    ('26272829301', 'Mariana Oliveira', 'mariana.oliveira@email.com', '(81)9000000000'),
    ('30313233341', 'Nathan Silva', 'nathan.silva@email.com', '(81)9987654321'),
    ('34353637381', 'Olivia Santos', 'olivia.santos@email.com', '(81)9876543210'),
    ('38394041421', 'Pedro Pereira', 'pedro.pereira@email.com', '(81)9765432109'),
    ('42434445461', 'Rafael Souza', 'rafael.souza@email.com', '(81)9654321098'),
    ('46474849501', 'Sofia Santos', 'sofia.santos@email.com', '(81)9543210987'),
    ('50515253541', 'Thiago Oliveira', 'thiago.oliveira@email.com', '(81)9432109876'),
    ('54555657581', 'Valentina Pereira', 'valentina.pereira@email.com', '(81)9321098765'),
    ('58596061621', 'Victor Santos', 'victor.santos@email.com', '(81)9210987654'),
    ('62636465661', 'Amanda Oliveira', 'amanda.oliveira@email.com', '(81)9109876543'),
    ('66676869701', 'Bruno Pereira', 'bruno.pereira@email.com', '(81)9098765432'),
    ('70717273741', 'Camila Souza', 'camila.souza@email.com', '(81)9998765432'),
    ('74757677781', 'Daniel Oliveira', 'daniel.oliveira@email.com', '(81)9898765432'),
    ('78798081821', 'Jeferson Amaro', 'jeferson.amaro@email.com', '(81)9798765432');

INSERT INTO Raca (id_raca, nome_raca, especie_raca, porte_raca) VALUES
    ('C001', 'Golden Retriever', 'Cachorro', 'Grande'),
    ('C002', 'Labrador', 'Cachorro', 'Medio'),
    ('C003', 'Pug', 'Cachorro', 'Pequeno'),
    ('C004', 'Yorkshire Terrier', 'Cachorro', 'Miniatura'),
    ('C005', 'Rottweiler', 'Cachorro', 'Grande'),
    ('C006', 'Pastor Alemão', 'Cachorro', 'Grande'),
    ('C007', 'Bulldog Francês', 'Cachorro', 'Pequeno'),
    ('C008', 'Poodle', 'Cachorro', 'Medio'),
    ('C009', 'Shih Tzu', 'Cachorro', 'Pequeno'),
    ('C010', 'Dachshund', 'Cachorro', 'Pequeno'),
    ('C011', 'Lhasa Apso', 'Cachorro', 'Pequeno'),
    ('C012', 'Pinscher', 'Cachorro', 'Pequeno'),
    ('C013', 'Boxer', 'Cachorro', 'Medio'),
    ('C014', 'Doberman', 'Cachorro', 'Medio'),
    ('C015', 'Husky Siberiano', 'Cachorro', 'Medio'),
    ('C016', 'Spitz Alemão', 'Cachorro', 'Pequeno'),
    ('C017', 'Samoieda', 'Cachorro', 'Grande'),
    ('C018', 'Bernese Mountain Dog', 'Cachorro', 'Grande'),
    ('C019', 'Akita', 'Cachorro', 'Grande'),
    ('C020', 'Border Collie', 'Cachorro', 'Medio'),
    ('G001', 'Siamês', 'Gato', 'Pequeno'),
    ('G002', 'Persa', 'Gato', 'Medio'),
    ('G003', 'Maine Coon', 'Gato', 'Grande'),
    ('G004', 'Angorá', 'Gato', 'Pequeno'),
    ('G005', 'Siberiano', 'Gato', 'Medio'),
    ('G006', 'Ragdoll', 'Gato', 'Medio'),
    ('G007', 'Sphynx', 'Gato', 'Pequeno'),
    ('G008', 'Scottish Fold', 'Gato', 'Pequeno'),
    ('G009', 'Bengal', 'Gato', 'Medio'),
    ('G010', 'Abissínio', 'Gato', 'Pequeno');

INSERT INTO Atendente (nome_atendente, admissao_atendente) VALUES
    ('Marianna Torres', '2023-01-15'),
    ('Carlos Elias', '2023-02-20'),
    ('Alice Teixeira', '2023-03-05'),
    ('Joanna Alves', '2024-03-03');

INSERT INTO CategoriaItem (id_categoria, descricao_categoria, tipo_categoria) VALUES
    ('P001', 'Ração para Cães', 'Produto'),
    ('P002', 'Brinquedos para Gatos', 'Produto'),
    ('P003', 'Coleiras e Guias', 'Produto'),
    ('P004', 'Camas e Toalhas', 'Produto'),
    ('P005', 'Alimentos para Filhotes', 'Produto'),
    ('P006', 'Ração para Gatos', 'Produto'),
    ('P007', 'Areia Sanitária', 'Produto'),
    ('P008', 'Caixa de Transporte', 'Produto'),
    ('P009', 'Medicamentos para Cães', 'Produto'),
    ('P010', 'Medicamentos para Gatos', 'Produto'),
    ('P011', 'Shampoo e Condicionador', 'Produto'),
    ('P012', 'Petiscos para Cães', 'Produto'),
    ('P013', 'Petiscos para Gatos', 'Produto'),
    ('P014', 'Suplemento Alimentar', 'Produto'),
    ('P015', 'Roupas para Pets', 'Produto'),
    ('S001', 'Consulta Veterinária', 'Serviço'),
    ('S002', 'Banho e Tosa', 'Serviço'),
    ('S003', 'Vacinação', 'Serviço'),
    ('S004', 'Procedimento Cirúrgico', 'Serviço'),
    ('S005', 'Exame Laboratorial', 'Serviço'),
    ('S006', 'Emergência Veterinária', 'Serviço'),
    ('S007', 'Consulta de Especialidade', 'Serviço'),
    ('S008', 'Saude e bem-estar', 'Serviço');

INSERT INTO Especialidade (id_especialidade, descricao_especialidade, tipo_especialidade) VALUES
    ('VET', 'Veterinário Clínico', 'Veterinario'),
    ('ORT', 'Ortopedista', 'Veterinario'),
    ('PAT', 'Patologista', 'Veterinario'),
    ('RAD', 'Radiologista', 'Veterinario'),
    ('ULT', 'Ultrassonografista', 'Veterinario'),
    ('CIR', 'Cirurgião', 'Veterinario'),
    ('ACC', 'Acupunturista', 'Veterinario'),
    ('FIS', 'Fisioterapeuta', 'Veterinario'),
    ('GRC', 'Groomer especialista em Cães', 'Groomer'),
    ('GRG', 'Groomer especialista em Gatos', 'Groomer'),
    ('GRS', 'Groomer especialista em Raças Especiais', 'Groomer'),
    ('GTS', 'Groomer especialista em Tosa para Shows', 'Groomer'),
    ('GTH', 'Groomer especialista em Tosa Higiênica', 'Groomer');

INSERT INTO Pet (cpf_cliente, id_raca, nome_pet, comprimento_pet, peso_pet, sexo_pet) VALUES
    ('87641204958', 'C001', 'Simba', 90.0, 30.0, 'M'),
    ('12345678901', 'C001', 'Lola', 91.3, 34.2, 'F'),
    ('12345678901', 'C003', 'Max', 41.2, 6.25, 'M'),
    ('45678901234', 'G001', 'Zeus', 31.6, 4.44, 'M'),
    ('01234567890', 'G007', 'Princesa', 39.22, 3.51, 'F'),
    ('78901234567', 'C019', 'Pingo', 102.33, 42.53, 'M'),
    ('34567890123', 'G003', 'Jade', 80.12, 9.33, 'F'),
    ('56789012345', 'C001', 'Chico', 100.2, 33.92, 'M'),
    ('23456789012', 'C003', 'Marley', 42.55, 7.75, 'M'),
    ('90123456789', 'C004', 'Zeca', 31.59 ,2.65, 'M'),
    ('90123456789', 'G001', 'Amora', 32.56 ,4.61, 'F'),
    ('90123456789', 'G002', 'Biscoito', 48.51, 6.67, 'M'),
    ('14151617181', 'C017', 'Luna', 83.65, 27.15, 'F'),
    ('14151617181', 'C015', 'Bob', 81.84, 25.39, 'M'),
    ('22232425261', 'G002', 'Mel', 45.25, 6.33, 'F'),
    ('26272829301', 'G002', 'Nina', 41.72, 6.13, 'F'),
    ('30313233341', 'C020', 'Nick', 72.33, 15.26, 'M'),
    ('34353637381', 'C005', 'Pandora', 110.33, 60.22, 'F'),
    ('38394041421', 'C004', 'Pingo', 20.3, 2.22, 'M'),
    ('42434445461', 'C004', 'Banguela', 18.33, 2.3, 'M'),
    ('46474849501', 'C013', 'Maggie', 70.67, 32.41, 'F'),
    ('54555657581', 'G009', 'Frida', 56.23, 8.33, 'F'),
    ('54555657581', 'C008', 'Mel', 75.43, 23.94, 'F'),
    ('58596061621', 'C007', 'Rex', 44.23, 13.21, 'M'),
    ('66676869701', 'C006', 'Zeca', 105.66, 34.12, 'M'),
    ('66676869701', 'C008', 'Lola', 73.32, 30.11, 'F'),
    ('70717273741', 'C008', 'Biscoito', 77.36, 35.66, 'M'),
    ('78798081821', 'G004', 'Lola', 37.32, 4.96, 'F'),
    ('78798081821', 'C008', 'Rex', 76.23, 32.21, 'M');	 

INSERT INTO Especialista (matricula_especialista, id_especialidade, nome_especialista, admissao_especialista) VALUES
    ('VET01', 'VET', 'Rafael Cordeiro', '2022-10-01'),
    ('VET02', 'VET', 'Mariana Sales', '2023-01-10'),
    ('VET03', 'CIR', 'Paulo Souza', '2023-02-15'),
    ('VET04', 'CIR', 'Anabela Lins', '2023-03-05'),
    ('VET05', 'PAT', 'Patricia Torres', '2023-03-20'),
    ('VET06', 'ACC', 'Leticia Gusmão', '2023-04-10'),
    ('GRO07', 'GRC', 'Leonardo Carlos', '2023-05-01'),
    ('GRO08', 'GRG', 'Amanda Toledo', '2024-05-15'),
    ('GRO09', 'GRS', 'Bruno Silas', '2024-06-05'),
    ('GRO10', 'GTH', 'Daniel Palha', '2024-06-20');

INSERT INTO Veterinario (matricula_especialista, CRMV) VALUES
    ('VET01', '011145'),
    ('VET02', '005312'),
    ('VET03', '015451'),
    ('VET04', '009231'),
    ('VET05', '015231'),
    ('VET06', '009991');

INSERT INTO Item (id_item, id_categoria, nome_item, custo_item) VALUES
    ('IT001', 'P001', 'Ração Premium Super Cão', 100.00),
    ('IT002', 'P002', 'Bola de Pelúcia Gato Feliz', 20.00),
    ('IT003', 'S001', 'Check-up Geral', 150.00),
    ('IT004', 'S002', 'Pacote Especial Banho e Tosa', 80.00),
    ('IT005', 'P003', 'Coleira de Couro para Cães', 30.00),
    ('IT006', 'P004', 'Cama Antialérgica', 120.00),
    ('IT007', 'P005', 'Petiscão Filhote', 110.00),
    ('IT008', 'P006', 'Ração Gato Feliz', 90.00),
    ('IT009', 'P007', 'Areia Sanitária Pet Show', 40.00),
    ('IT010', 'P008', 'PetBox Plus', 50.00),
    ('IT011', 'P009', 'Vermífugo Cão Feliz', 25.00),
    ('IT012', 'P010', 'Antipulgas Gato Feliz', 35.00),
    ('IT013', 'P011', 'Shampoo Antisséptico Banho Legal', 18.00),
    ('IT014', 'S004', 'Castração e Esterilização', 150.00),
    ('IT015', 'S007', 'Acupuntura para Cães', 120.00),
    ('IT016', 'S003', 'Vacina Anti-rábica', 50.00),
    ('IT017', 'P015', 'Kit Bulldogue Cowboy', 120.00),
    ('IT018', 'P006', 'Ração Super Gato', 56.00),
    ('IT019', 'S005', 'Exame para Detecção de Parasitas', 100.00);

INSERT INTO Produto (id_item, qtd_estoque) VALUES
    ('IT001', 23),
    ('IT002', 45),
    ('IT005', 51),
    ('IT006', 11),
    ('IT007', 95),
    ('IT008', 44),
    ('IT009', 65),
    ('IT010', 54),
    ('IT011', 23),
    ('IT012', 33),
    ('IT013', 54),
    ('IT017', 12),
    ('IT018', 54);

INSERT INTO Servico (id_item, duracao_servico) VALUES
    ('IT003', '00:45:00'),
    ('IT004', '01:20:00'),
    ('IT014', '01:50:00'),
    ('IT015', '01:00:00'),
    ('IT016', '00:05:00'),
    ('IT019', '00:30:00');

INSERT INTO Especialista_Servico (id_servico, matricula_especialista) VALUES
    (1, 'VET01'),
    (1, 'VET02'),
    (2, 'GRO07'),
    (2, 'GRO08'),
    (2, 'GRO09'),
    (3, 'VET03'),
    (3, 'VET04'),
    (4, 'VET06'),
    (5, 'VET01'),
    (5, 'VET02'),
    (5, 'VET05'),
    (6, 'VET05');

INSERT INTO NotaFiscal (id_notaFiscal, cpf_cliente, matricula_atendente, data_notaFiscal, hora_notaFiscal, tipo_notaFiscal) VALUES
    ('NFP001', '01234567890', 1000, '2024-10-23', '11:12:30', 'Produto'),
    ('NFS001', '01234567890', 1000, '2024-10-23', '11:14:11', 'Serviço'),
    ('NFP002', '22232425261', 1010, '2024-10-23', '15:12:44', 'Produto'),
    ('NFP003', '23456789012', 1010, '2024-10-24', '09:32:21', 'Produto'),
    ('NFS002', '58596061621', 1020, '2024-10-24', '11:54:52', 'Serviço'),
    ('NFS003', '62636465661', 1000, '2024-10-24', '12:33:24', 'Serviço'),
    ('NFP004', '46474849501', 1020, '2024-10-24', '14:11:42', 'Produto'),
    ('NFP005', '90123456789', 1010, '2024-10-24', '15:12:31', 'Produto'),
    ('NFP006', '87641204958', 1020, '2024-10-24', '16:14:55', 'Produto'),
    ('NFS004', '87641204958', 1030, '2024-10-24', '16:54:24', 'Serviço'),
    ('NFS005', '01234567890', 1010, '2024-10-25', '08:43:45', 'Serviço'),
    ('NFS006', '54555657581', 1020, '2024-10-25', '10:32:31', 'Serviço'),
    ('NFS007', '38394041421', 1000, '2024-10-25', '11:12:43', 'Serviço'),
    ('NFS008', '66676869701', 1020, '2024-10-25', '14:54:11', 'Serviço'),
    ('NFS009', '30313233341', 1000, '2024-10-26', '08:22:44', 'Serviço'),
    ('NFS010', '78798081821', 1030, '2024-10-26', '10:33:12', 'Serviço');

INSERT INTO NotaFiscal_Item (id_item, id_notaFiscal, quantidade, valor) VALUES 
    ('IT002', 'NFP001', 2, 40.00),
    ('IT012', 'NFP001', 1, 35.00),
    ('IT004', 'NFS001', 1, 150.00),
    ('IT008', 'NFP002', 2, 180.00),
    ('IT001', 'NFP003', 1, 100.00),
    ('IT005', 'NFP003', 1, 30.00),
    ('IT003', 'NFS002', 1, 150.00),
    ('IT016', 'NFS003', 1, 50.00),
    ('IT013', 'NFP004', 2, 36.00),
    ('IT001', 'NFP004', 2, 200.00),
    ('IT007', 'NFP005', 2, 220.00),
    ('IT005', 'NFP005', 1, 30.00),
    ('IT010', 'NFP005', 1, 50.00),
    ('IT011', 'NFP006', 1, 25.00),
    ('IT001', 'NFP006', 1, 100.00),
    ('IT006', 'NFP006', 1, 120.00),
    ('IT004', 'NFS004', 1, 80.00),
    ('IT019', 'NFS005', 1, 100.00),
    ('IT004', 'NFS006', 1, 80.00),
    ('IT015', 'NFS007', 1, 120.00),
    ('IT003', 'NFS008', 1, 150.00),
    ('IT014', 'NFS009', 1, 150.00),
    ('IT016', 'NFS010', 1, 50.00);

INSERT INTO Atendimento (matricula_especialista, matricula_pet, id_servico, cpf_cliente, data_marcacao, data_atendimento, hora_atendimento) VALUES
    ('VET03', 5, 2, '01234567890', '2024-10-20', '2024-10-23', '11:45:00'),
    ('VET01', 24, 1, '58596061621', '2024-10-23', '2024-10-24', '13:00:00'),
    ('VET05', 25, 5, '66676869701', '2024-10-19' , '2024-10-24', '13:15:00'),
    ('GRO07', 1, 2, '87641204958', '2024-10-21' ,'2024-10-24', '17:10:00'),
    ('VET05', 5, 6, '01234567890', '2024-10-19', '2024-10-25', '09:00:00'),
    ('GRO09', 23, 2, '54555657581', '2024-10-22', '2024-10-25', '10:22:32'),
    ('VET06', 19, 4, '38394041421', '2024-10-22', '2024-10-25', '14:10:00'),
    ('VET02', 25, 1, '66676869701', '2024-10-23', '2024-10-25', '15:00:00'),
    ('VET04', 17, 3, '30313233341', '2024-10-23', '2024-10-25', '11:10:55'),
    ('VET01', 29, 5, '78798081821', '2024-10-23', '2024-10-25', '13:32:11'); 
