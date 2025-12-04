-- TRIGGER
-- --------------------------------------------------------------------
-- 01:
-- Garantir que o estoque esteja suficiente antes de incluir um pedido:
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_ValidarValorPedidoPositivo`
BEFORE INSERT ON Pedido
FOR EACH ROW
BEGIN
    -- Verifica se o valor (que representa a QTD solicitada) é negativo ou zero.
    IF NEW.valor <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: A quantidade ou valor do pedido deve ser maior que zero.';
    END IF;
END$$
DELIMITER ;

-- Este INSERT será bem-sucedido, pois 500.00 > 0.
INSERT INTO Pedido (Fornecedor_idFornecedor, Beneficiario_idBeneficiario, LoteSemente_idLote_Semente, data, valor, status)
VALUES (
    1,          -- Exemplo Fornecedor
    2,          -- Exemplo Beneficiário
    3,         -- Exemplo Lote
    CURDATE(),
    500.00,     -- Valor POSITIVO
    'PENDENTE'
);

-- Verificação (Confirma que o pedido foi inserido):
SELECT * FROM Pedido
WHERE valor = 500.00 AND status = 'PENDENTE';

-- Este comando FALHARIA e retornaria a mensagem 'Erro: A quantidade ou valor do pedido deve ser maior que zero.'
/*
INSERT INTO Pedido (Fornecedor_idFornecedor, Beneficiario_idBeneficiario, LoteSemente_idLote_Semente, data, valor, status)
VALUES (1, 1, 21, CURDATE(), 0.00, 'PENDENTE');
*/


-- --------------------------------------------------------------------
-- 02:
-- Registro automatico de data de criação do usuário:
-- Adição de colunas para auditoria e regras de negocio
-- --------------------------------------------------------------------

-- Necessário 
ALTER TABLE `semente_da_gente`.`Usuario` 
ADD COLUMN `data_criacao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Necessário 
ALTER TABLE `semente_da_gente`.`LoteSemente` 
ADD COLUMN `status_lote` VARCHAR(15) NOT NULL DEFAULT 'DISPONIVEL';

DELIMITER $$
CREATE TRIGGER `trg_AuditoriaDataCriacaoUsuario`
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
    -- Define o campo data_criacao do novo registro com a data e hora atuais.
    -- Se o campo `data_criacao` não existir, esta linha será ignorada pelo MySQL (desde que você rode o ALTER TABLE).
    SET NEW.data_criacao = NOW();
END$$
DELIMITER ;



-- --------------------------------------------------------------------
-- 03:
-- Padronização do CPF/CNPJ de fornecedores (limpeza de dados) :
-- mesmo já estando com limitação de caracteres na criação do perfil.
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_PadronizarCpfCnpjFornecedor`
BEFORE INSERT ON Fornecedor
FOR EACH ROW
BEGIN
    -- Remove todos os caracteres que não são dígitos (0-9) do CPF/CNPJ.
    SET NEW.cpf_cnpj = REPLACE(REPLACE(REPLACE(REPLACE(NEW.cpf_cnpj, '.', ''), '/', ''), '-', ''), ' ', '');
END$$
DELIMITER ;

-- Supondo que o próximo ID de Fornecedor seja 21
INSERT INTO Fornecedor (nome, cpf_cnpj)
VALUES ('Fornecedor PF Teste', '987.654.321-00');

-- Busca o registro que acabamos de inserir.
SELECT nome, cpf_cnpj
FROM Fornecedor
WHERE nome = 'Fornecedor PF Teste';


-- --------------------------------------------------------------------
-- 04:
-- impedir nomes vazios em atualizacoes de fornecedores :
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_ImpedirNomeVazioFornecedor`
BEFORE UPDATE ON Fornecedor
FOR EACH ROW
BEGIN
    -- Verifica se o novo nome é nulo ou uma string vazia após a remoção de espaços em branco.
    IF NEW.nome IS NULL OR TRIM(NEW.nome) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: O nome do fornecedor não pode ser vazio na atualização.';
    END IF;
END$$
DELIMITER ;

-- Supondo que o Fornecedor ID 1 se chame "João Silva".
-- AÇÃO: Atualizar o nome para um valor não vazio.
UPDATE Fornecedor
SET nome = 'João Silva Distribuidora LTDA'
WHERE idFornecedor = 1;

-- Verificação:
SELECT idFornecedor, nome
FROM Fornecedor
WHERE idFornecedor = 1;

-- AÇÃO: Tenta atualizar o nome para uma string vazia.
-- O comando FALHARÁ e o registro original não será alterado.
/*
UPDATE Fornecedor
SET nome = ''
WHERE idFornecedor = 1;
*/

-- Mensagem de Erro Esperada:
-- 'Erro: O nome do fornecedor não pode ser vazio na atualização.'

-- --------------------------------------------------------------------
-- 05:
-- Padronizar o UF para letras MAIUSCULAS:
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_PadronizarUF`
BEFORE INSERT ON Endereco
FOR EACH ROW
BEGIN
    -- Converte o valor do campo UF para maiúsculas antes de ser inserido
    SET NEW.uf = UPPER(NEW.uf);
END$$
DELIMITER ;

-- Este INSERT será bem-sucedido, e o 'rj' será salvo como 'RJ'

INSERT INTO Endereco (logradouro, numero, complemento, bairro, cidade, uf, cep, Fornecedor_idFornecedor,
 Beneficiario_idBeneficiario, Armazem_idArmazenamento) VALUES
('Rua do Teste', 1, NULL, 'Bangu', 'Rio de Janeiro', 'rj', '21800000', 10, NULL, NULL);

-- Verificação:
SELECT logradouro, uf FROM Endereco WHERE Fornecedor_idFornecedor = 10;

-- --------------------------------------------------------------------
-- 06:
-- Padronização do Email para Minúsculas:
-- --------------------------------------------------------------------

DELIMITER $$
-- Trigger para Inserção
CREATE TRIGGER `trg_PadronizarEmailInsert`
BEFORE INSERT ON Contato
FOR EACH ROW
BEGIN
    -- Converte o email para minúsculas antes de inserção
    SET NEW.email = LOWER(NEW.email);
END$$

-- Trigger para Atualização
CREATE TRIGGER `trg_PadronizarEmailUpdate`
BEFORE UPDATE ON Contato
FOR EACH ROW
BEGIN
    -- Converte o email para minúsculas antes de atualização
    SET NEW.email = LOWER(NEW.email);
END$$
DELIMITER ;

-- Este INSERT será bem-sucedido, e 'TESTE@EMPRESA.com' será salvo como 'teste@empresa.com'
INSERT INTO Contato (numero, email, Fornecedor_idFornecedor) VALUES
('11987654321', 'TESTE@EMPRESA.com', 7);

-- Verificação:
SELECT numero, email FROM Contato WHERE Fornecedor_idFornecedor = 7 AND numero = '11987654321';

-- Encontrando o ID do Contato que vamos alterar (usamos o ID 1, do João Silva)
SELECT idTelefone, email FROM Contato WHERE idTelefone = 1;

-- Este UPDATE será bem-sucedido, e 'joao.silva@email.com' será atualizado para 'novo.email@TESTE.com' em minúsculas
UPDATE Contato
SET email = 'NOVO.EMAIL@TESTE.com'
WHERE idTelefone = 1;

-- Verificação:
SELECT idTelefone, email FROM Contato WHERE idTelefone = 1;

-- --------------------------------------------------------------------
-- 07:
-- Padronizar o nome das Sementes com as iniciais MAIUSCULAS:
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_PadronizarNomeSemente`
BEFORE INSERT ON Semente
FOR EACH ROW
BEGIN
    -- Usa a função de capitalização para formatar o nome
    -- Embora o MySQL não tenha uma função TITLECASE nativa simples, 
    -- vamos usar LOWER e CONCAT para garantir a padronização básica: primeira letra maiúscula, restante minúscula.
    SET NEW.nome = CONCAT(UPPER(LEFT(NEW.nome, 1)), LOWER(SUBSTRING(NEW.nome, 2)));
END$$
DELIMITER ;

-- Este INSERT será bem-sucedido, e 'semente nova' será salvo como 'Semente nova'
INSERT INTO Semente (nome, nome_cientifico, descricao) VALUES
('semente nova', 'Testis botanica', 'Semente teste com nome formatado');

-- Verificação:
SELECT nome, nome_cientifico FROM Semente WHERE nome_cientifico = 'Testis botanica';

-- --------------------------------------------------------------------
-- 08:
-- Padronizar o login do usuario para minusculas:
-- --------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER `trg_PadronizarLoginMinusculo`
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
    -- Converte o login para letras minúsculas antes de inserção
    SET NEW.login = LOWER(NEW.login);
END$$
DELIMITER ;

-- Este INSERT será bem-sucedido, e 'USER.TESTE' será salvo como 'user.teste'
INSERT INTO Usuario (nome, login, senha) VALUES
('Teste Padronização Login', 'USER.TESTE', 'senha4321');

-- Verificação:
SELECT nome, login FROM Usuario WHERE nome = 'Teste Padronização Login';

-- --------------------------------------------------------------------
-- 09:
-- Garantir que o CPF seja apenas numeros:
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_LimparCpfBeneficiario`
BEFORE INSERT ON Beneficiario
FOR EACH ROW
BEGIN
    -- Remove todos os caracteres que não são dígitos (0-9) do CPF.
    SET NEW.cpf = REPLACE(REPLACE(NEW.cpf, '.', ''), '-', '');
END$$
DELIMITER ;

-- Este INSERT será bem-sucedido, e o CPF será salvo apenas com números
INSERT INTO Beneficiario (nome, cpf, Banco_idBanco) VALUES
('CPF Limpo Teste', '123.000.456-78', 1);

-- Verificação:
SELECT nome, cpf FROM Beneficiario WHERE nome = 'CPF Limpo Teste';


-- --------------------------------------------------------------------
-- 10:
-- Padronização de Nomes de Armazéns para MAIÚSCULAS no UPDATE:
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_PadronizarNomeArmazemUpdate`
BEFORE UPDATE ON Armazem
FOR EACH ROW
BEGIN
    -- Converte o novo valor do campo 'nome' para maiúsculas antes de ser salvo
    SET NEW.nome = UPPER(NEW.nome);
END$$
DELIMITER ;

SELECT idArmazenamento, nome FROM Armazem WHERE idArmazenamento = 1;
-- Este UPDATE será bem-sucedido. O valor 'Novo nome para armazem' será salvo como 'NOVO NOME PARA ARMAZEM'
UPDATE Armazem
SET nome = 'Novo nome para armazem', capacidade = 5000.000 -- Mantém a capacidade se o campo for NOT NULL
WHERE idArmazenamento = 1;

-- Verificação:
SELECT idArmazenamento, nome FROM Armazem WHERE idArmazenamento = 1;

-- --------------------------------------------------------------------
-- 11:
-- Impedir Alteração de data_producao em Lote de Semente:
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_ImpedirAlteracaoDataProducao`
BEFORE UPDATE ON LoteSemente
FOR EACH ROW
BEGIN
    -- Se a data de produção antiga for diferente da nova data, mantemos o valor antigo.
    IF OLD.data_producao <> NEW.data_producao THEN
        SET NEW.data_producao = OLD.data_producao;
    END IF;
END$$
DELIMITER ;

-- Este UPDATE será bem-sucedido, mas a data_producao não será alterada para '2025-01-01'
UPDATE LoteSemente
SET data_producao = '2025-01-01'
WHERE idLote_Semente = 1;

-- Verificação:
SELECT idLote_Semente, data_producao FROM LoteSemente WHERE idLote_Semente = 1; 
-- data_producao deve ser '2024-01-15'

-- --------------------------------------------------------------------
-- 12:
-- Padronizar nomes dos Armazens, removendo espaços extras:
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_PadronizarNomeArmazem`
BEFORE INSERT ON Armazem
FOR EACH ROW
BEGIN
    -- Remove espaços em branco do início e fim do nome
    SET NEW.nome = TRIM(NEW.nome);
END$$
DELIMITER ;

-- Este INSERT será bem-sucedido, e o nome será salvo sem os espaços
INSERT INTO Armazem (nome, capacidade) VALUES
('  Armazém Limpo  ', 1000.000);

-- Verificação:
SELECT nome, capacidade FROM Armazem WHERE nome = 'Armazém Limpo';

-- --------------------------------------------------------------------
-- 13:
-- Prevenir a inclusão de contatos sem e-mail ou telefone:
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_ValidarDadosContato`
BEFORE INSERT ON Contato
FOR EACH ROW
BEGIN
    -- Verifica se AMBOS, o número de telefone e o email, são nulos ou vazios
    IF (NEW.numero IS NULL OR NEW.numero = '') AND (NEW.email IS NULL OR NEW.email = '') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: É obrigatório informar pelo menos um número de telefone ou um email para o contato.';
    END IF;
END$$
DELIMITER ;

-- Para verificar o erro:
-- Este INSERT deve *FALHAR*, acionando a Trigger 2
-- INSERT INTO Contato (numero, email, Fornecedor_idFornecedor) VALUES
-- (NULL, NULL, 1);

-- --------------------------------------------------------------------
-- 14:
-- Impedir Exclusão de LoteSemente Usado em Pedidos
-- --------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER `trg_ImpedirExclusaoLoteUsado`
BEFORE DELETE ON LoteSemente
FOR EACH ROW
BEGIN
    DECLARE v_contagem_pedidos INT;
    
    -- Verifica se o lote (OLD.idLote_Semente) existe em algum registro de Pedido
    SELECT COUNT(*) INTO v_contagem_pedidos
    FROM Pedido
    WHERE LoteSemente_idLote_Semente = OLD.idLote_Semente;

    -- Se a contagem for maior que zero, significa que o lote foi usado
    IF v_contagem_pedidos > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: Não é possível excluir este lote, pois ele já foi referenciado em um ou mais pedidos.';
    END IF;
END$$
DELIMITER ;

-- Este comando FALHARÁ se o Lote ID 1 já existir na tabela Pedido
-- DELETE FROM LoteSemente WHERE idLote_Semente = 1;

-- Mensagem de Erro Esperada:
-- 'Erro: Não é possível excluir este lote, pois ele já foi referenciado em um ou mais pedidos.'