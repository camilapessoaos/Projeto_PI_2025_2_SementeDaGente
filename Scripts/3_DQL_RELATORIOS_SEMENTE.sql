-- RELATÓRIO 1
-- Lista o nome da semente, seu certificado de origem e o nome do armazém onde o lote está estocado.

SELECT
	S.nome AS nome_semente,
    LS.certificado_origem,
    A.nome AS nome_armazem
FROM LoteSemente AS LS
JOIN Semente AS S ON LS.Semente_idSemente = S.idSemente
JOIN Armazem AS A ON LS.Armazem_idArmazenamento = A.idArmazenamento
	ORDER BY nome_semente;

-- RELATÓRIO 2
-- Exibe o nome de cada fornecedor e seu respectivo e-mail de contato, garantindo que apenas fornecedores com contatos cadastrados sejam exibidos.

SELECT
    F.nome AS nome_fornecedor,
    C.email
FROM Fornecedor AS F
JOIN Contato AS C ON F.idFornecedor = C.Fornecedor_idFornecedor;

-- RELATÓRIO 3
-- Lista o nome do beneficiário, o CPF e o número da agência do banco associado.

SELECT
    B.nome AS nome_beneficiario,
    B.cpf,
    BA.numAgencia
FROM Beneficiario AS B
JOIN Banco AS BA ON B.Banco_idBanco = BA.idBanco;

-- RELATÓRIO 4
-- Lista o nome do armazém junto com a cidade e estado (UF) onde ele está localizado.

SELECT
    A.nome AS nome_armazem,
    E.cidade,
    E.uf
FROM Armazem AS A
JOIN Endereco AS E ON A.idArmazenamento = E.Armazem_idArmazenamento;

-- RELATÓRIO 5
-- Mostra a data, o valor e o nome do beneficiário para todos os pedidos com o status 'ENTREGUE'.

SELECT
    P.data,
    P.valor,
    BE.nome AS nome_beneficiario,
    P.status
FROM Pedido AS P
JOIN Beneficiario AS BE ON P.Beneficiario_idBeneficiario = BE.idBeneficiario
WHERE P.status = 'ENTREGUE';

-- RELATÓRIO 6
-- Encontra o nome e a descrição das sementes cujos lotes têm uma quantidade disponível (qtd_disponivel_kg) inferior a 20.000 kg.

SELECT
    nome,
    descricao
FROM Semente
WHERE idSemente IN (
    SELECT Semente_idSemente
    FROM LoteSemente
    WHERE qtd_disponivel_kg < 20000.000
);

-- RELATÓRIO 7
-- Lista os nomes dos fornecedores que têm pedidos.

SELECT
    F.nome AS nome_fornecedor
FROM Fornecedor AS F
WHERE F.idFornecedor IN (
    SELECT DISTINCT Fornecedor_idFornecedor
    FROM Pedido
);

-- RELATÓRIO 8
-- Identifica os certificados de origem dos lotes que estão armazenados em armazéns cuja capacidade total (capacidade) é superior a 5.000.000 kg (5.000 toneladas).

SELECT
    LS.certificado_origem,
    LS.qtd_disponivel_kg
FROM LoteSemente AS LS
WHERE LS.Armazem_idArmazenamento IN (
    SELECT idArmazenamento
    FROM Armazem
    WHERE capacidade > 5000000.000
);

-- RELATÓRIO 9
-- Lista o nome comum e o nome científico de todas as sementes que estão presentes em algum lote armazenado.

SELECT
    S.nome AS nome_comum,
    S.nome_cientifico
FROM Semente AS S
WHERE S.idSemente IN (
    SELECT DISTINCT LoteSemente.Semente_idSemente
    FROM LoteSemente
);

-- RELATÓRIO 10
-- Lista o CNPJ da Unidade Recebedora e a chave Pix da sua conta bancária associada.

SELECT
	BE.nome,
    UR.cnpj,
    BA.chavePix
FROM UndRecebedora AS UR
JOIN Beneficiario AS BE ON UR.Beneficiario_idBeneficiario = BE.idBeneficiario
JOIN Banco AS BA ON BE.Banco_idBanco = BA.idBanco;

-- RELATÓRIO 11
-- Lista o nome do usuário e o seu login, juntamente com o seu e-mail de contato.

SELECT
    U.nome AS nome_usuario,
    U.login,
    C.email
FROM Usuario AS U
JOIN Contato AS C ON U.idUsuario = C.Usuario_idusuario;

-- RELATÓRIO 12
-- Encontra o nome dos fornecedores e o logradouro onde estão localizados, filtrando apenas por endereços nos estados de SP ou MG.

SELECT
    F.nome AS nome_fornecedor,
    E.logradouro,
    E.uf
FROM Fornecedor AS F
JOIN Endereco AS E ON F.idFornecedor = E.Fornecedor_idFornecedor
WHERE E.uf IN ('SP', 'MG');

-- RELATÓRIO 13
-- Calcula a quantidade original média (qtd_original_kg) de todos os lotes para cada tipo de semente.

SELECT
    S.nome AS nome_semente,
    ROUND(AVG(LS.qtd_original_kg), 0) AS media_qtd_original_kg
FROM LoteSemente AS LS
JOIN Semente AS S ON LS.Semente_idSemente = S.idSemente
GROUP BY S.nome;

-- RELATÓRIO 14
-- Lista o nome do Armazém e o nome do Fornecedor que participou de um pedido que utilizou um lote armazenado nele.

SELECT DISTINCT
    A.nome AS nome_armazem,
    F.nome AS nome_fornecedor_relacionado
FROM Armazem AS A
JOIN LoteSemente AS LS ON A.idArmazenamento = LS.Armazem_idArmazenamento
JOIN Pedido AS P ON LS.idLote_Semente = P.LoteSemente_idLote_Semente
JOIN Fornecedor AS F ON P.Fornecedor_idFornecedor = F.idFornecedor
ORDER BY A.nome, F.nome;

-- RELATÓRIO 15
-- Lista o nome, login e e-mail dos usuários que têm contato associado na mesma UF de um Armazém cuja capacidade é maior que 7.000.000 kg.

SELECT
    U.nome AS nome_usuario,
    U.login,
    C.email
FROM Usuario AS U
JOIN Contato AS C ON U.idUsuario = C.Usuario_idusuario
WHERE C.idTelefone IN (
    SELECT E_User.idEndereco
    FROM Endereco AS E_User
    WHERE E_User.uf IN (
        SELECT DISTINCT E_Armazem.uf
        FROM Armazem AS A
        JOIN Endereco AS E_Armazem ON A.idArmazenamento = E_Armazem.Armazem_idArmazenamento
        WHERE A.capacidade > 7000000.000 -- Armazéns Gigantes (SP, MG, RS, MT)
    )
);

-- RELATÓRIO 16
-- Encontra os certificados de origem e o valor dos lotes cujo valor (valor) é acima do valor médio de todos os lotes.

SELECT
    certificado_origem,
    valor
FROM LoteSemente
	WHERE valor > (
		SELECT AVG(valor)
		FROM LoteSemente
	)
		ORDER BY valor;

-- RELATÓRIO 17
-- Exibe a data do pedido e o nome do fornecedor para todos os pedidos que estão com o status 'PENDENTE'.

SELECT
    P.data AS data_pedido,
    F.nome AS nome_fornecedor,
    P.status
FROM Pedido AS P
JOIN Fornecedor AS F ON P.Fornecedor_idFornecedor = F.idFornecedor
WHERE P.status = 'PENDENTE';

-- RELATÓRIO 18
-- Lista o nome da semente e a data de validade para os lotes que vencem em Março de 2025.

SELECT
    S.nome AS nome_semente,
    LS.data_validade
FROM LoteSemente AS LS
JOIN Semente AS S ON LS.Semente_idSemente = S.idSemente
WHERE LS.data_validade BETWEEN '2025-03-01' AND '2025-03-31';

-- RELATÓRIO 19
-- Retorna os nomes dos beneficiários que estão associados a pedidos com o status 'ENTREGUE'.

SELECT DISTINCT
    BE.nome AS nome_beneficiario,
    P.status
FROM Beneficiario AS BE
JOIN Pedido AS P ON BE.idBeneficiario = P.Beneficiario_idBeneficiario
WHERE P.status = 'ENTREGUE';

-- RELATÓRIO 20
-- Calcula a soma da quantidade disponível (qtd_disponivel_kg) de semente em cada armazém.

SELECT
    A.nome AS nome_armazem,
    ROUND(SUM(LS.qtd_disponivel_kg), 2) AS total_disponivel_kg
FROM Armazem AS A
JOIN LoteSemente AS LS ON A.idArmazenamento = LS.Armazem_idArmazenamento
GROUP BY A.nome;




