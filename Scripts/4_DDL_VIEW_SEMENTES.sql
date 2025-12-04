USE semente_da_gente;

-- -----------------------------------------------------
-- View 1: Lotes e Localização (Relatório 1)
-- Lista o nome da semente, seu certificado e o nome do armazém.
-- -----------------------------------------------------
CREATE VIEW vw_lotes_armazem_semente AS
SELECT
    S.nome AS nome_semente,
    LS.certificado_origem,
    A.nome AS nome_armazem
FROM LoteSemente AS LS
JOIN Semente AS S ON LS.Semente_idSemente = S.idSemente
JOIN Armazem AS A ON LS.Armazem_idArmazenamento = A.idArmazenamento;

-- -----------------------------------------------------
-- View 2: Contatos de Fornecedores (Relatório 2)
-- Exibe o nome de cada fornecedor e seu respectivo e-mail de contato.
-- -----------------------------------------------------
CREATE VIEW vw_fornecedor_contato_email AS
SELECT
    F.nome AS nome_fornecedor,
    C.email
FROM Fornecedor AS F
JOIN Contato AS C ON F.idFornecedor = C.Fornecedor_idFornecedor;

-- -----------------------------------------------------
-- View 3: Beneficiários e Dados Bancários (Relatório 3)
-- Lista o nome do beneficiário, o CPF e o número da agência do banco.
-- -----------------------------------------------------
CREATE VIEW vw_beneficiario_dados_banco AS
SELECT
    B.nome AS nome_beneficiario,
    B.cpf,
    BA.numAgencia
FROM Beneficiario AS B
JOIN Banco AS BA ON B.Banco_idBanco = BA.idBanco;

-- -----------------------------------------------------
-- View 4: Localização de Armazéns (Relatório 4)
-- Lista o nome do armazém, cidade e estado onde está localizado.
-- -----------------------------------------------------
CREATE VIEW vw_armazem_endereco AS
SELECT
    A.nome AS nome_armazem,
    E.cidade,
    E.uf
FROM Armazem AS A
JOIN Endereco AS E ON A.idArmazenamento = E.Armazem_idArmazenamento;

-- -----------------------------------------------------
-- View 5: Histórico de Pedidos Entregues (Relatório 5)
-- Mostra data, valor e nome do beneficiário para pedidos com status 'ENTREGUE'.
-- -----------------------------------------------------
CREATE VIEW vw_pedidos_entregues AS
SELECT
    P.data,
    P.valor,
    BE.nome AS nome_beneficiario,
    P.status
FROM Pedido AS P
JOIN Beneficiario AS BE ON P.Beneficiario_idBeneficiario = BE.idBeneficiario
WHERE P.status = 'ENTREGUE';

-- -----------------------------------------------------
-- View 6: Sementes com Estoque Baixo (Relatório 6)
-- Encontra nome e descrição das sementes cujos lotes têm qtd. disponível < 20.000 kg.
-- -----------------------------------------------------
CREATE VIEW vw_sementes_baixo_estoque AS
SELECT
    nome,
    descricao
FROM Semente
WHERE idSemente IN (
    SELECT Semente_idSemente
    FROM LoteSemente
    WHERE qtd_disponivel_kg < 20000.000
);

-- -----------------------------------------------------
-- View 7: Fornecedores com Pedidos Ativos (Relatório 7)
-- Lista os nomes dos fornecedores que já realizaram pedidos.
-- -----------------------------------------------------
CREATE VIEW vw_fornecedores_com_pedido AS
SELECT DISTINCT
    F.nome AS nome_fornecedor
FROM Fornecedor AS F
WHERE F.idFornecedor IN (
    SELECT Fornecedor_idFornecedor
    FROM Pedido
);

-- -----------------------------------------------------
-- View 8: Lotes em Armazéns de Alta Capacidade (Relatório 8)
-- Identifica lotes em armazéns com capacidade superior a 5.000.000 kg.
-- -----------------------------------------------------
CREATE VIEW vw_lotes_armazens_gigantes AS
SELECT
    LS.certificado_origem,
    LS.qtd_disponivel_kg
FROM LoteSemente AS LS
WHERE LS.Armazem_idArmazenamento IN (
    SELECT idArmazenamento
    FROM Armazem
    WHERE capacidade > 5000000.000
);

-- -----------------------------------------------------
-- View 9: Unidades Recebedoras e Chave Pix (Relatório 10)
-- Lista o CNPJ e a chave Pix da conta bancária de Unidades Recebedoras.
-- -----------------------------------------------------
CREATE VIEW vw_undrecebedora_pix AS
SELECT
	BE.nome AS nome_beneficiario,
    UR.cnpj,
    BA.chavePix
FROM UndRecebedora AS UR
JOIN Beneficiario AS BE ON UR.Beneficiario_idBeneficiario = BE.idBeneficiario
JOIN Banco AS BA ON BE.Banco_idBanco = BA.idBanco;

-- -----------------------------------------------------
-- View 10: Usuários e Seus Contatos (Relatório 11)
-- Lista nome do usuário, login e seu e-mail de contato.
-- -----------------------------------------------------
CREATE VIEW vw_usuario_contato_email AS
SELECT
    U.nome AS nome_usuario,
    U.login,
    C.email
FROM Usuario AS U
JOIN Contato AS C ON U.idUsuario = C.Usuario_idusuario;

-- -----------------------------------------------------
-- View 11: Média de Quantidade Produzida por Semente (Relatório 13)
-- Calcula a quantidade original média de todos os lotes para cada tipo de semente.
-- -----------------------------------------------------
CREATE VIEW vw_media_qtd_por_semente AS
SELECT
    S.nome AS nome_semente,
    ROUND(AVG(LS.qtd_original_kg), 0) AS media_qtd_original_kg
FROM LoteSemente AS LS
JOIN Semente AS S ON LS.Semente_idSemente = S.idSemente
GROUP BY S.nome;

-- -----------------------------------------------------
-- View 12: Lotes com Valor Acima da Média (Relatório 16)
-- Encontra lotes cujo valor é superior ao valor médio de todos os lotes.
-- -----------------------------------------------------
CREATE VIEW vw_lotes_valor_acima_media AS
SELECT
    certificado_origem,
    valor
FROM LoteSemente
WHERE valor > (
    SELECT AVG(valor)
    FROM LoteSemente
);

-- -----------------------------------------------------
-- View 13: Total de Estoque por Armazém (Relatório 20)
-- Calcula a soma da quantidade disponível (qtd_disponivel_kg) de semente em cada armazém.
-- -----------------------------------------------------
CREATE VIEW vw_total_disponivel_armazem AS
SELECT
    A.nome AS nome_armazem,
    ROUND(SUM(LS.qtd_disponivel_kg), 2) AS total_disponivel_kg
FROM Armazem AS A
JOIN LoteSemente AS LS ON A.idArmazenamento = LS.Armazem_idArmazenamento
GROUP BY A.nome;