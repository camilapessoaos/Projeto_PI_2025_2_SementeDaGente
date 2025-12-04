USE semente_da_gente;

-- Procedures e Functions

-- -----------------------------------------------------
-- Procedure 1:
-- Criando uma procedure para pesquisar pelo nome cientifico.
-- -----------------------------------------------------


DELIMITER $$
CREATE PROCEDURE `sp_BuscarLotesPorNomeCientifico` (
    IN p_nome_cientifico VARCHAR(45)
)
BEGIN
    SELECT
        LS.idLote_Semente,
        S.nome AS nome_semente,
        S.nome_cientifico,
        LS.qtd_disponivel_kg,
        A.nome AS armazem,
        LS.data_validade,
        LS.valor
    FROM
        LoteSemente AS LS
    INNER JOIN
        Semente AS S ON LS.Semente_idSemente = S.idSemente
    INNER JOIN
        Armazem AS A ON LS.Armazem_idArmazenamento = A.idArmazenamento
    WHERE
        S.nome_cientifico = p_nome_cientifico
    ORDER BY
        LS.data_validade ASC;
END$$
DELIMITER ;

-- Agora vou chamar a procedure para buscar, por exemplo, todos os lotes de Milho (Zea mays):

CALL `sp_BuscarLotesPorNomeCientifico`('Zea mays');

-- Criando uma procedure para atualizar a quantidade disponivel:

DELIMITER $$
CREATE PROCEDURE `sp_AtualizarQtdDisponivelLote` (
    IN p_idLote INT,
    IN p_nova_quantidade DECIMAL(10,3)
)
BEGIN
    -- Verifica se o novo valor é não negativo antes de atualizar
    IF p_nova_quantidade >= 0 THEN
        UPDATE
            LoteSemente
        SET
            qtd_disponivel_kg = p_nova_quantidade
        WHERE
            idLote_Semente = p_idLote;
        
        -- Retorna a linha atualizada para confirmação
        SELECT *
        FROM LoteSemente
        WHERE idLote_Semente = p_idLote;
    ELSE
        -- Retorna uma mensagem de erro se a quantidade for inválida
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: A nova quantidade disponível não pode ser negativa.';
    END IF;
END$$
DELIMITER ;

-- Suponha que o Lote de Semente com ID 1 tinha 45000.000 kg disponíveis e, após um pedido, a nova quantidade é 40000.000 kg:

CALL `sp_AtualizarQtdDisponivelLote`(1, 40000.000);

-- -----------------------------------------------------
-- Procedure 2:
-- Agora uma função para calcular o valor total de um pedido:
-- -----------------------------------------------------


DELIMITER $$
CREATE FUNCTION `fn_CalcularValorPedidoEstimado` (
    p_idLote INT,
    p_quantidade_kg DECIMAL(10,3)
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_valor_lote_unitario DECIMAL(10,2);
    DECLARE v_valor_total DECIMAL(10,2);

    -- 1. Buscar o valor total do lote na tabela LoteSemente
    SELECT 
        LS.valor / LS.qtd_original_kg INTO v_valor_lote_unitario
    FROM 
        LoteSemente AS LS
    WHERE 
        LS.idLote_Semente = p_idLote;

    -- 2. Verificar se o lote existe e se o valor unitário foi encontrado (para evitar divisão por zero)
    IF v_valor_lote_unitario IS NULL THEN
        -- Retorna 0.00 se o Lote não for encontrado
        RETURN 0.00;
    END IF;

    -- 3. Calcular o valor total estimado do pedido
    SET v_valor_total = p_quantidade_kg * v_valor_lote_unitario;

    -- 4. Retornar o valor total calculado
    RETURN v_valor_total;
END$$
DELIMITER ;

-- Vamos simular um pedido para comprar 2000 kg do Lote ID 10.
SELECT 
    -- Chamando a função: (ID do Lote, Quantidade solicitada em kg)
    `fn_CalcularValorPedidoEstimado`(10, 2000.000) AS ValorEstimado;

-- -----------------------------------------------------
-- Procedure 3:
-- Procedure inserindo novo pedido e atualizando estoque:
-- -----------------------------------------------------


DELIMITER $$
CREATE PROCEDURE `sp_CriarPedidoEAtualizarEstoque` (
    IN p_idFornecedor INT,
    IN p_idBeneficiario INT,
    IN p_idLoteSemente INT,
    IN p_data DATE,
    IN p_valor DECIMAL(10,2),
    IN p_status VARCHAR(15),
    IN p_qtd_retirada DECIMAL(10,3) -- Nova quantidade a ser retirada do estoque
)
BEGIN
    DECLARE v_qtd_atual DECIMAL(10,3);
    DECLARE v_nova_qtd DECIMAL(10,3);
    
    -- Inicia a transação para garantir atomicidade
    START TRANSACTION;

    -- 1. Obter a quantidade atual disponível no lote
    SELECT qtd_disponivel_kg INTO v_qtd_atual
    FROM LoteSemente
    WHERE idLote_Semente = p_idLoteSemente
    FOR UPDATE; -- Bloqueia a linha para evitar problemas de concorrência
    
    -- 2. Calcular a nova quantidade
    SET v_nova_qtd = v_qtd_atual - p_qtd_retirada;

    -- 3. Verifica se há estoque suficiente
    IF v_nova_qtd < 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Quantidade solicitada excede o estoque disponível no lote.';
    ELSE
        -- 4. Insere o novo Pedido
        INSERT INTO Pedido (Fornecedor_idFornecedor, Beneficiario_idBeneficiario, LoteSemente_idLote_Semente, data, valor, status)
        VALUES (p_idFornecedor, p_idBeneficiario, p_idLoteSemente, p_data, p_valor, p_status);

        -- 5. Atualiza a quantidade disponível no LoteSemente
        UPDATE LoteSemente
        SET qtd_disponivel_kg = v_nova_qtd
        WHERE idLote_Semente = p_idLoteSemente;

        -- 6. Confirma a transação
        COMMIT;
        
        SELECT 'Pedido criado e estoque atualizado com sucesso!' AS Resultado, 
               v_qtd_atual AS QtdAntiga, v_nova_qtd AS QtdNova;
    END IF;
END$$
DELIMITER ;

-- Vamos simular a criação de um pedido, retirando 100.000 kg do Lote ID 2 (que tem 28000.000 kg disponíveis).
-- Este exemplo deve falhar:
-- Este exemplo deve falhar por falta de estoque (28000 - 100000 < 0)
-- CALL `sp_CriarPedidoEAtualizarEstoque`(
--    1, 1, 2, '2025-12-02', 5000.00, 'PROCESSANDO', 100000.000
-- );

-- Agora um exemplo de sucesso, retirando 1000.000 kg do Lote ID 2 (28000.000 kg disponíveis):
-- Este exemplo deve ser bem-sucedido (28000 - 1000 = 27000)
CALL `sp_CriarPedidoEAtualizarEstoque`(
    1, 1, 2, '2025-12-02', 5000.00, 'PROCESSANDO', 1000.000
);

-- -----------------------------------------------------
-- Function 1:
-- Função de calcular capacidade restante do armazem:
-- -----------------------------------------------------


DELIMITER $$
CREATE FUNCTION `fn_CapacidadeRestanteArmazem` (
    p_idArmazem INT
)
RETURNS DECIMAL(10,3)
READS SQL DATA
BEGIN
    DECLARE v_capacidade_total DECIMAL(10,3);
    DECLARE v_peso_armazenado DECIMAL(10,3);
    DECLARE v_capacidade_restante DECIMAL(10,3);

    -- 1. Obter a capacidade total do Armazém
    SELECT capacidade INTO v_capacidade_total
    FROM Armazem
    WHERE idArmazenamento = p_idArmazem;
    
    -- 2. Calcular o peso total (quantidade original) armazenado nos lotes
    SELECT COALESCE(SUM(qtd_original_kg), 0.000) INTO v_peso_armazenado
    FROM LoteSemente
    WHERE Armazem_idArmazenamento = p_idArmazem;

    -- 3. Calcular a capacidade restante
    SET v_capacidade_restante = v_capacidade_total - v_peso_armazenado;

    -- 4. Retornar a capacidade restante
    RETURN v_capacidade_restante;
END$$
DELIMITER ;

-- Buscando a capacidade restante do Armazém ID 1:
-- Armazém ID 1 (Armazém Central SP): 6000000.000 kg de capacidade.
-- Lote ID 1 está no Armazém 1 e tem qtd_original_kg: 50000.000 kg.

SELECT 
    A.nome,
    A.capacidade,
    `fn_CapacidadeRestanteArmazem`(A.idArmazenamento) AS CapacidadeRestante_kg
FROM 
    Armazem AS A
WHERE 
    A.idArmazenamento = 1;
 
-- -----------------------------------------------------
-- Procedure 4:
-- Procedure listando pedidos por status e periodo(data):
-- ----------------------------------------------------- 


DELIMITER $$
CREATE PROCEDURE `sp_RelatorioPedidosPorStatusEPeriodo` (
    IN p_status VARCHAR(15),
    IN p_data_inicio DATE,
    IN p_data_fim DATE
)
BEGIN
    SELECT
        P.data AS DataPedido,
        P.valor AS ValorTotal,
        P.status,
        F.nome AS NomeFornecedor,
        B.nome AS NomeBeneficiario,
        S.nome AS Semente
    FROM
        Pedido AS P
    INNER JOIN
        Fornecedor AS F ON P.Fornecedor_idFornecedor = F.idFornecedor
    INNER JOIN
        Beneficiario AS B ON P.Beneficiario_idBeneficiario = B.idBeneficiario
    INNER JOIN
        LoteSemente AS LS ON P.LoteSemente_idLote_Semente = LS.idLote_Semente
    INNER JOIN
        Semente AS S ON LS.Semente_idSemente = S.idSemente
    WHERE
        P.status = p_status AND
        P.data BETWEEN p_data_inicio AND p_data_fim
    ORDER BY
        P.data DESC;
END$$
DELIMITER ;

-- Listar todos os pedidos com status 'ENTREGUE' feitos entre 01/04/2024 e 10/04/2024:

CALL `sp_RelatorioPedidosPorStatusEPeriodo`('ENTREGUE', '2024-04-01', '2024-04-10');

-- -----------------------------------------------------
-- Procedure 5:
-- Procedure listando beneficiarios com contas que tenham chave Pix:
-- ----------------------------------------------------- 


DELIMITER $$
CREATE PROCEDURE `sp_ListarBeneficiariosComPixPorBanco` (
    IN p_chavePix_parcial VARCHAR(100)
)
BEGIN
    SELECT
        B.nome AS NomeBeneficiario,
        B.cpf,
        BN.chavePix,
        BN.numConta,
        BN.numAgencia
    FROM
        Beneficiario AS B
    INNER JOIN
        Banco AS BN ON B.Banco_idBanco = BN.idBanco
    WHERE
        BN.chavePix LIKE CONCAT('%', p_chavePix_parcial, '%')
    ORDER BY
        BN.numAgencia, B.nome;
END$$
DELIMITER ;

-- Listar beneficiários cujas chaves Pix contenham o texto 
-- 'https://www.google.com/url?sa=E&source=gmail&q=banco.com' (simulando um tipo de banco ou domínio):
-- no caso usaremos o banco.com

CALL `sp_ListarBeneficiariosComPixPorBanco`('banco.com');

-- -----------------------------------------------------
-- Procedure 6:
-- Procedure para atualizar o status de um pedido pela PK:
-- ----------------------------------------------------- 


DELIMITER $$
CREATE PROCEDURE `sp_AtualizarStatusPedido` (
    IN p_idFornecedor INT,
    IN p_idBeneficiario INT,
    IN p_idLoteSemente INT,
    IN p_novo_status VARCHAR(15)
)
BEGIN
    UPDATE
        Pedido
    SET
        status = p_novo_status
    WHERE
        Fornecedor_idFornecedor = p_idFornecedor AND
        Beneficiario_idBeneficiario = p_idBeneficiario AND
        LoteSemente_idLote_Semente = p_idLoteSemente;
    
    -- Retorna o registro atualizado para confirmação
    SELECT *
    FROM Pedido
    WHERE
        Fornecedor_idFornecedor = p_idFornecedor AND
        Beneficiario_idBeneficiario = p_idBeneficiario AND
        LoteSemente_idLote_Semente = p_idLoteSemente;
END$$
DELIMITER ;

-- Atualizar o status do pedido (Fornecedor=1, Beneficiario=1, LoteSemente=1) para 'FINALIZADO':

CALL `sp_AtualizarStatusPedido`(1, 1, 1, 'FINALIZADO');

-- -----------------------------------------------------
-- Procedure 7:
-- Procedure para listar sementes com lotes proximos da validade (90 dias):  -- 90 dias pra casar!
-- ----------------------------------------------------- 


DELIMITER $$
CREATE PROCEDURE `sp_AlertaValidadeSemente` ()
BEGIN
    DECLARE p_data_limite DATE;
    
    -- Calcula a data limite: hoje + 90 dias
    SET p_data_limite = DATE_ADD(CURDATE(), INTERVAL 90 DAY);
    
    SELECT
        S.nome AS Semente,
        LS.idLote_Semente,
        LS.data_validade,
        LS.qtd_disponivel_kg,
        A.nome AS Armazem
    FROM
        LoteSemente AS LS
    INNER JOIN
        Semente AS S ON LS.Semente_idSemente = S.idSemente
    INNER JOIN
        Armazem AS A ON LS.Armazem_idArmazenamento = A.idArmazenamento
    WHERE
        LS.data_validade BETWEEN CURDATE() AND p_data_limite
    ORDER BY
        LS.data_validade ASC;
END$$
DELIMITER ;

-- exemplo da sua execução:
-- Irá listar todos os lotes que vencem nos próximos 90 dias a partir de hoje
CALL `sp_AlertaValidadeSemente`();

-- -----------------------------------------------------
-- Function 2:
-- Função para contar os lotes de Sementes com validade expirada:
-- ----------------------------------------------------- 


DELIMITER $$
CREATE FUNCTION `fn_ContarLotesExpirados` ()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total_expirados INT;

    -- Conta quantos lotes têm a data de validade menor que a data atual
    SELECT COUNT(idLote_Semente) INTO v_total_expirados
    FROM LoteSemente
    WHERE data_validade < CURDATE();

    RETURN v_total_expirados;
END$$
DELIMITER ;

-- Exemplo da execução:
SELECT 
    `fn_ContarLotesExpirados`() AS TotalLotesExpirados;
    
-- -----------------------------------------------------
-- Function 3:
-- Função para obter a quantidade total de Semente especifica no estoque:
-- ----------------------------------------------------- 


DELIMITER $$
CREATE FUNCTION `fn_TotalEstoquePorSemente` (
    p_nome_semente VARCHAR(45)
)
RETURNS DECIMAL(10,3)
READS SQL DATA
BEGIN
    DECLARE v_total_kg DECIMAL(10,3);

    SELECT 
        COALESCE(SUM(LS.qtd_disponivel_kg), 0.000) INTO v_total_kg
    FROM 
        LoteSemente AS LS
    INNER JOIN 
        Semente AS S ON LS.Semente_idSemente = S.idSemente
    WHERE 
        S.nome = p_nome_semente;

    RETURN v_total_kg;
END$$
DELIMITER ;

-- Para verificar a quantidade total disponível da semente 'Milho':
SELECT 
    `fn_TotalEstoquePorSemente`('Milho') AS TotalMilho_kg;
 
-- -----------------------------------------------------
-- Function 4:
-- Função para calcular o valor médio do pedido entregue:
-- ----------------------------------------------------- 
 


DELIMITER $$
CREATE FUNCTION `fn_ValorMedioPedidoEntregue` ()
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_valor_medio DECIMAL(10,2);

    SELECT 
        COALESCE(AVG(valor), 0.00) INTO v_valor_medio
    FROM 
        Pedido
    WHERE 
        status = 'ENTREGUE';

    RETURN v_valor_medio;
END$$
DELIMITER ;

-- Exemplo da execução:
SELECT 
    `fn_ValorMedioPedidoEntregue`() AS ValorMedioEntregue;

-- -----------------------------------------------------
-- Function 5:
-- Funçõa para validar a existência do usuario com login e senha:
-- ----------------------------------------------------- 


DELIMITER $$
CREATE FUNCTION `fn_ValidarCredenciaisUsuario` (
    p_login VARCHAR(45),
    p_senha VARCHAR(45)
)
RETURNS TINYINT
READS SQL DATA
BEGIN
    DECLARE v_existe TINYINT DEFAULT 0;

    SELECT 
        COUNT(*) INTO v_existe
    FROM 
        Usuario
    WHERE 
        login = p_login AND senha = p_senha;

    -- Retorna 1 se a contagem for maior que 0 (o usuário existe), caso contrário 0
    RETURN v_existe;
END$$
DELIMITER ;

-- Exemplo da execução:
SELECT 
    `fn_ValidarCredenciaisUsuario`('joao.silva', 'senha123') AS LoginValido;

-- Aqui seria uma falha:
SELECT 
    `fn_ValidarCredenciaisUsuario`('joao.silva', 'senhaerrada') AS LoginValido;
    
-- -----------------------------------------------------
-- Procedure 8:
-- Procedure pata excluir lotes expirados e não usados em pedidos:
-- ----------------------------------------------------- 
    

DELIMITER $$
CREATE PROCEDURE `sp_ExcluirLotesExpiradosSemUso` ()
BEGIN
    -- Declaração para saber quantas linhas foram afetadas
    DECLARE rows_deleted INT;

    -- Inicia a transação, essencial para operações de exclusão
    START TRANSACTION;

    -- Exclui lotes expirados que NÃO possuem referências na tabela Pedido
    DELETE FROM LoteSemente
    WHERE 
        data_validade < CURDATE()
        AND idLote_Semente NOT IN (
            SELECT DISTINCT LoteSemente_idLote_Semente
            FROM Pedido
        );

    -- Armazena o número de linhas excluídas
    SET rows_deleted = ROW_COUNT();

    -- Confirma a exclusão
    COMMIT;

    -- Retorna uma mensagem de sucesso
    SELECT CONCAT('Limpeza de estoque concluída. ', rows_deleted, ' lotes expirados e não utilizados foram excluídos.') AS Resultado;
    
END$$
DELIMITER ;

-- Exemplo de execução:
CALL `sp_ExcluirLotesExpiradosSemUso`();

-- -----------------------------------------------------
-- Function 5:
-- Função para calcular a quantidade total de pedidos cancelados no mes atual:
-- ----------------------------------------------------- 


DELIMITER $$
CREATE FUNCTION `fn_ContarCanceladosNoMesAtual` ()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_total_cancelados INT;

    SELECT 
        COUNT(*) INTO v_total_cancelados
    FROM 
        Pedido
    WHERE 
        status = 'CANCELADO'
        -- Verifica se o ano e o mês do pedido são iguais ao ano e mês atuais
        AND YEAR(data) = YEAR(CURDATE())
        AND MONTH(data) = MONTH(CURDATE());

    RETURN v_total_cancelados;
END$$
DELIMITER ;

-- Exemplo de execução:
SELECT 
    `fn_ContarCanceladosNoMesAtual`() AS PedidosCanceladosEsteMes;
    
-- -----------------------------------------------------
-- Procedure 9:
-- Relatório de Uso de Armazéns por Semente
-- ----------------------------------------------------- 

DELIMITER $$
CREATE PROCEDURE `sp_RelatorioUsoArmazemPorSemente` (
    IN p_nome_semente VARCHAR(45)
)
BEGIN
    SELECT
        A.nome AS Armazem,
        S.nome AS Semente,
        SUM(LS.qtd_disponivel_kg) AS QuantidadeTotal_kg,
        COUNT(LS.idLote_Semente) AS TotalDeLotes
    FROM
        LoteSemente AS LS
    INNER JOIN
        Armazem AS A ON LS.Armazem_idArmazenamento = A.idArmazenamento
    INNER JOIN
        Semente AS S ON LS.Semente_idSemente = S.idSemente
    WHERE
        S.nome = p_nome_semente
    GROUP BY
        A.nome, S.nome
    ORDER BY
        QuantidadeTotal_kg DESC;
END$$
DELIMITER ;

-- Buscar o relatório de estique da semente do Milho em todos os armazens:

CALL `sp_RelatorioUsoArmazemPorSemente`('Milho');