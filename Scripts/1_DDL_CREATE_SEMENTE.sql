-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema semente_da_gente
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `semente_da_gente` DEFAULT CHARACTER SET utf8 ;
USE `semente_da_gente` ;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`Usuario` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `login` VARCHAR(45) NOT NULL,
  `senha` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `senha_UNIQUE` (`senha` ASC) VISIBLE,
  UNIQUE INDEX `login_UNIQUE` (`login` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`Semente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`Semente` (
  `idSemente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `nome_cientifico` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(100) NULL,
  PRIMARY KEY (`idSemente`),
  UNIQUE INDEX `nome_cientifico_UNIQUE` (`nome_cientifico` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`Armazem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`Armazem` (
  `idArmazenamento` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `capacidade` DECIMAL(10,3) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArmazenamento`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`Banco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`Banco` (
  `idBanco` INT NOT NULL AUTO_INCREMENT,
  `numAgencia` VARCHAR(6) NOT NULL,
  `numConta` VARCHAR(20) NOT NULL,
  `chavePix` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idBanco`),
  UNIQUE INDEX `chavePix_UNIQUE` (`chavePix` ASC) VISIBLE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`Beneficiario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`Beneficiario` (
  `idBeneficiario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `cpf` VARCHAR(15) NOT NULL,
  `Banco_idBanco` INT NOT NULL,
  PRIMARY KEY (`idBeneficiario`),
  INDEX `fk_Beneficiario_Banco1_idx` (`Banco_idBanco` ASC) VISIBLE,
  CONSTRAINT `fk_Beneficiario_Banco1`
    FOREIGN KEY (`Banco_idBanco`)
    REFERENCES `semente_da_gente`.`Banco` (`idBanco`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `cpf_cnpj` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`idFornecedor`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`Endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`Endereco` (
  `idEndereco` INT NOT NULL AUTO_INCREMENT,
  `logradouro` VARCHAR(100) NOT NULL,
  `numero` INT UNSIGNED NOT NULL,
  `complemento` VARCHAR(45) NULL,
  `bairro` VARCHAR(45) NOT NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `uf` CHAR(2) NOT NULL,
  `cep` VARCHAR(8) NOT NULL,
  `Fornecedor_idFornecedor` INT NULL,
  `Beneficiario_idBeneficiario` INT NULL,
  `Armazem_idArmazenamento` INT NULL,
  PRIMARY KEY (`idEndereco`),
  INDEX `fk_Endereco_Fornecedor1_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  INDEX `fk_Endereco_Beneficiario1_idx` (`Beneficiario_idBeneficiario` ASC) VISIBLE,
  INDEX `fk_Endereco_Armazem1_idx` (`Armazem_idArmazenamento` ASC) VISIBLE,
  CONSTRAINT `fk_Endereco_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `semente_da_gente`.`Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Endereco_Beneficiario1`
    FOREIGN KEY (`Beneficiario_idBeneficiario`)
    REFERENCES `semente_da_gente`.`Beneficiario` (`idBeneficiario`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Endereco_Armazem1`
    FOREIGN KEY (`Armazem_idArmazenamento`)
    REFERENCES `semente_da_gente`.`Armazem` (`idArmazenamento`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`LoteSemente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`LoteSemente` (
  `idLote_Semente` INT NOT NULL AUTO_INCREMENT,
  `data_producao` DATE NOT NULL,
  `data_validade` DATE NOT NULL,
  `qtd_original_kg` DECIMAL(10,3) UNSIGNED NOT NULL,
  `certificado_origem` VARCHAR(45) NOT NULL,
  `local_armazenamento` VARCHAR(45) NOT NULL,
  `qtd_disponivel_kg` DECIMAL(10,3) UNSIGNED NOT NULL,
  `valor` DECIMAL(10,2) UNSIGNED NOT NULL,
  `Semente_idSemente` INT NOT NULL,
  `Armazem_idArmazenamento` INT NOT NULL,
  PRIMARY KEY (`idLote_Semente`),
  INDEX `fk_LoteSemente_Armazem1_idx` (`Armazem_idArmazenamento` ASC) VISIBLE,
  INDEX `fk_LoteSemente_Semente1_idx` (`Semente_idSemente` ASC) VISIBLE,
  CONSTRAINT `fk_LoteSemente_Armazem1`
    FOREIGN KEY (`Armazem_idArmazenamento`)
    REFERENCES `semente_da_gente`.`Armazem` (`idArmazenamento`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_LoteSemente_Semente1`
    FOREIGN KEY (`Semente_idSemente`)
    REFERENCES `semente_da_gente`.`Semente` (`idSemente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`Contato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`Contato` (
  `idTelefone` INT NOT NULL AUTO_INCREMENT,
  `numero` VARCHAR(11) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `Fornecedor_idFornecedor` INT NULL,
  `Usuario_idusuario` INT NULL,
  `Beneficiario_idBeneficiario` INT NULL,
  `Armazem_idArmazenamento` INT NULL,
  PRIMARY KEY (`idTelefone`),
  INDEX `fk_Telefone_Fornecedor1_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  INDEX `fk_Contato_Usuario1_idx` (`Usuario_idusuario` ASC) VISIBLE,
  INDEX `fk_Contato_Beneficiario1_idx` (`Beneficiario_idBeneficiario` ASC) VISIBLE,
  INDEX `fk_Contato_Armazem1_idx` (`Armazem_idArmazenamento` ASC) VISIBLE,
  CONSTRAINT `fk_Telefone_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `semente_da_gente`.`Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Contato_Usuario1`
    FOREIGN KEY (`Usuario_idusuario`)
    REFERENCES `semente_da_gente`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Contato_Beneficiario1`
    FOREIGN KEY (`Beneficiario_idBeneficiario`)
    REFERENCES `semente_da_gente`.`Beneficiario` (`idBeneficiario`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Contato_Armazem1`
    FOREIGN KEY (`Armazem_idArmazenamento`)
    REFERENCES `semente_da_gente`.`Armazem` (`idArmazenamento`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`UndRecebedora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`UndRecebedora` (
  `Beneficiario_idBeneficiario` INT NOT NULL,
  `cnpj` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Beneficiario_idBeneficiario`),
  CONSTRAINT `fk_UndRecebedora_Beneficiario1`
    FOREIGN KEY (`Beneficiario_idBeneficiario`)
    REFERENCES `semente_da_gente`.`Beneficiario` (`idBeneficiario`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `semente_da_gente`.`Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `semente_da_gente`.`Pedido` (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Beneficiario_idBeneficiario` INT NOT NULL,
  `LoteSemente_idLote_Semente` INT NOT NULL,
  `data` DATE NOT NULL,
  `valor` DECIMAL(10,2) UNSIGNED NOT NULL,
  `status` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Beneficiario_idBeneficiario`, `LoteSemente_idLote_Semente`),
  INDEX `fk_Pedido_Fornecedor1_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  INDEX `fk_Pedido_Beneficiario1_idx` (`Beneficiario_idBeneficiario` ASC) VISIBLE,
  INDEX `fk_Pedido_LoteSemente1_idx` (`LoteSemente_idLote_Semente` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `semente_da_gente`.`Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pedido_Beneficiario1`
    FOREIGN KEY (`Beneficiario_idBeneficiario`)
    REFERENCES `semente_da_gente`.`Beneficiario` (`idBeneficiario`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pedido_LoteSemente1`
    FOREIGN KEY (`LoteSemente_idLote_Semente`)
    REFERENCES `semente_da_gente`.`LoteSemente` (`idLote_Semente`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;