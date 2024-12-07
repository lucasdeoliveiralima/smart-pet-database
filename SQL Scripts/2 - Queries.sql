use SmartPet;
-- Produtos mais lucrativos
SELECT
  i.nome_item as 'Produto',
  SUM(nfi.quantidade) AS 'Vendas',
  SUM(nfi.valor) AS 'Valor Arrecadado'
FROM 
  NotaFiscal_Item as nfi INNER JOIN Item  as i 
ON 
  nfi.id_item = i.id_item 
WHERE 
  nfi.id_notaFiscal LIKE 'NFP%'
GROUP BY 
  i.nome_item
ORDER BY
  'Valor Arrecadado' DESC;

-- Serviços mais lucrativos
SELECT
  i.nome_item as 'Produto',
  SUM(nfi.quantidade) AS 'Vendas',
  SUM(nfi.valor) AS 'Valor Arrecadado'
FROM 
  NotaFiscal_Item as nfi INNER JOIN Item  as i 
ON 
  nfi.id_item = i.id_item 
WHERE 
  nfi.id_notaFiscal LIKE 'NFS%'
GROUP BY 
  i.nome_item
ORDER BY
  'Valor Arrecadado' DESC;

-- Compras por cliente
SELECT
  c.nome_cliente as 'Cliente',
  COUNT(nf.cpf_cliente) as 'Compras Efetuadas'
FROM
  Cliente as c INNER JOIN NotaFiscal as nf
ON
  c.cpf_cliente = nf.cpf_cliente
GROUP BY 
 c.nome_cliente
ORDER BY
  'Compras Efetuadas' DESC;

-- Descrição dos atendimentos
SELECT
  a.id_atendimento as 'Atendimento',
  a.data_atendimento as 'Data',
  c.nome_cliente as 'Tutor',
  p.nome_pet as 'Pet',
  e.nome_especialista as 'Especialista',
  i.nome_item as 'Serviço'
FROM 
  Atendimento AS a INNER JOIN Cliente as c ON a.cpf_cliente = c.cpf_cliente
  INNER JOIN Pet AS p ON a.matricula_pet = p.matricula_pet
  INNER JOIN Especialista as e ON a.matricula_especialista = e.matricula_especialista
  INNER JOIN Servico as s ON a.id_servico = s.id_servico
  INNER JOIN Item as i ON s.id_item = i.id_item;

-- Produto com menor quantidade em estoque
SELECT
  i.id_item,
  i.nome_item,
  p.qtd_estoque
FROM
  Item as i INNER JOIN Produto as p
  ON i.id_item = p.id_item
WHERE qtd_estoque = (SELECT(MIN(qtd_estoque)) FROM Produto);

-- Serviço com maior duração na execução
SELECT
  i.id_item,
  i.nome_item,
  s.duracao_servico
FROM
  Item as i INNER JOIN Servico as s
  ON i.id_item = s.id_item
WHERE duracao_servico = (SELECT(MAX(duracao_servico)) FROM Servico);

-- Média de gasto em aquisição de serviços pelos clientes
SELECT
  'R$ ' + CAST(CAST(AVG(valor) AS DECIMAL(6,2)) AS VARCHAR(6)) AS 'Gasto Médio Serviços'
FROM
  NotaFiscal_Item
WHERE
  id_notaFiscal LIKE 'NFS%';