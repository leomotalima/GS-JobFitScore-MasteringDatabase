/* ============================================================
                        Procedures
============================================================ */
DROP PROCEDURE sp_inserir_usuario;
DROP PROCEDURE sp_inserir_empresa;
DROP PROCEDURE sp_inserir_vaga;
DROP PROCEDURE sp_inserir_habilidade;
DROP PROCEDURE sp_inserir_usuario_habilidade;
DROP PROCEDURE sp_inserir_curso;
DROP PROCEDURE sp_inserir_candidatura;
DROP PROCEDURE sp_inserir_vaga_habilidade;


CREATE OR REPLACE PROCEDURE sp_inserir_usuario (
    p_nome IN VARCHAR2,
    p_email IN VARCHAR2,
    p_senha IN VARCHAR2,
    p_id_usuario OUT NUMBER
) AS
BEGIN
    INSERT INTO usuarios (nome, email, senha)
    VALUES (p_nome, p_email, p_senha)
    RETURNING id_usuario INTO p_id_usuario;
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20001, 'Email já cadastrado');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE sp_inserir_empresa (
    p_nome IN VARCHAR2,
    p_cnpj IN VARCHAR2,
    p_id_empresa OUT NUMBER
) AS
BEGIN
    INSERT INTO empresas (nome, cnpj)
    VALUES (p_nome, p_cnpj)
    RETURNING id_empresa INTO p_id_empresa;
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nome ou CNPJ já cadastrado');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE sp_inserir_vaga (
    p_titulo IN VARCHAR2,
    p_empresa_id IN NUMBER,
    p_id_vaga OUT NUMBER
) AS
BEGIN
    INSERT INTO vagas (titulo, empresa_id)
    VALUES (p_titulo, p_empresa_id)
    RETURNING id_vaga INTO p_id_vaga;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE sp_inserir_habilidade (
    p_nome IN VARCHAR2,
    p_id_habilidade OUT NUMBER
) AS
BEGIN
    INSERT INTO habilidades (nome)
    VALUES (p_nome)
    RETURNING id_habilidade INTO p_id_habilidade;
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20003, 'Habilidade já cadastrada');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE sp_inserir_usuario_habilidade (
    p_usuario_id IN NUMBER,
    p_habilidade_id IN NUMBER
) AS
BEGIN
    INSERT INTO usuario_habilidade (usuario_id, habilidade_id)
    VALUES (p_usuario_id, p_habilidade_id);
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20004, 'Usuário já possui esta habilidade');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE sp_inserir_curso (
    p_nome IN VARCHAR2,
    p_instituicao IN VARCHAR2,
    p_carga_horaria IN NUMBER,
    p_usuario_id IN NUMBER,
    p_id_curso OUT NUMBER
) AS
BEGIN
    INSERT INTO cursos (nome, instituicao, carga_horaria, usuario_id)
    VALUES (p_nome, p_instituicao, p_carga_horaria, p_usuario_id)
    RETURNING id_curso INTO p_id_curso;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE sp_inserir_candidatura (
    p_usuario_id IN NUMBER,
    p_vaga_id IN NUMBER,
    p_id_candidatura OUT NUMBER
) AS
BEGIN
    INSERT INTO candidaturas (usuario_id, vaga_id)
    VALUES (p_usuario_id, p_vaga_id)
    RETURNING id_candidatura INTO p_id_candidatura;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE sp_inserir_vaga_habilidade (
    p_vaga_id IN NUMBER,
    p_habilidade_id IN NUMBER
) AS
BEGIN
    INSERT INTO vaga_habilidade (vaga_id, habilidade_id)
    VALUES (p_vaga_id, p_habilidade_id);
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20005, 'Vaga já possui esta habilidade');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

DECLARE
    v_id NUMBER;
BEGIN
    sp_inserir_usuario('Ana Paula Santos', 'ana.santos@email.com', 'senha123', v_id);
    sp_inserir_usuario('Carlos Eduardo Lima', 'carlos.lima@email.com', 'senha123', v_id);
    sp_inserir_usuario('Mariana Costa Silva', 'mariana.costa@email.com', 'senha123', v_id);
    sp_inserir_usuario('Ricardo Almeida', 'ricardo.almeida@email.com', 'senha123', v_id);
    sp_inserir_usuario('Juliana Ferreira', 'juliana.ferreira@email.com', 'senha123', v_id);
    sp_inserir_usuario('Fernando Oliveira', 'fernando.oliveira@email.com', 'senha123', v_id);
    sp_inserir_usuario('Beatriz Rodrigues', 'beatriz.rodrigues@email.com', 'senha123', v_id);
    sp_inserir_usuario('Paulo Henrique Souza', 'paulo.souza@email.com', 'senha123', v_id);
    sp_inserir_usuario('Camila Martins', 'camila.martins@email.com', 'senha123', v_id);
    sp_inserir_usuario('Gabriel Pereira', 'gabriel.pereira@email.com', 'senha123', v_id);
    DBMS_OUTPUT.PUT_LINE('10 usuários inseridos com sucesso!');
END;
/


DECLARE
    v_id NUMBER;
BEGIN
    sp_inserir_empresa('Tech Solutions Brasil', '12345678000190', v_id);
    sp_inserir_empresa('Inovação Digital Ltda', '98765432000145', v_id);
    sp_inserir_empresa('Consultoria TI Express', '11223344000156', v_id);
    sp_inserir_empresa('Desenvolve Software SA', '55667788000198', v_id);
    sp_inserir_empresa('Cloud Computing Brasil', '99887766000132', v_id);
    sp_inserir_empresa('Data Science Corp', '44556677000178', v_id);
    sp_inserir_empresa('Agile Developers', '33221100000165', v_id);
    sp_inserir_empresa('Web Solutions Pro', '77889900000123', v_id);
    sp_inserir_empresa('Mobile Apps Brasil', '66554433000187', v_id);
    sp_inserir_empresa('Cyber Security Tech', '22334455000141', v_id);
    DBMS_OUTPUT.PUT_LINE('10 empresas inseridas com sucesso!');
END;
/


DECLARE
    v_id NUMBER;
BEGIN
    sp_inserir_habilidade('Java', v_id);
    sp_inserir_habilidade('Python', v_id);
    sp_inserir_habilidade('JavaScript', v_id);
    sp_inserir_habilidade('SQL', v_id);
    sp_inserir_habilidade('React', v_id);
    sp_inserir_habilidade('Node.js', v_id);
    sp_inserir_habilidade('Docker', v_id);
    sp_inserir_habilidade('Kubernetes', v_id);
    sp_inserir_habilidade('AWS', v_id);
    sp_inserir_habilidade('Git', v_id);
    DBMS_OUTPUT.PUT_LINE('10 habilidades inseridas com sucesso!');
END;
/


DECLARE
    v_id NUMBER;
BEGIN
    sp_inserir_vaga('Desenvolvedor Java Pleno', 1, v_id);
    sp_inserir_vaga('Analista Python Sênior', 2, v_id);
    sp_inserir_vaga('Desenvolvedor Full Stack', 3, v_id);
    sp_inserir_vaga('Engenheiro de Dados', 4, v_id);
    sp_inserir_vaga('Arquiteto de Soluções Cloud', 5, v_id);
    sp_inserir_vaga('Cientista de Dados', 6, v_id);
    sp_inserir_vaga('Scrum Master', 7, v_id);
    sp_inserir_vaga('Desenvolvedor Front-End React', 8, v_id);
    sp_inserir_vaga('Desenvolvedor Mobile Android', 9, v_id);
    sp_inserir_vaga('Analista de Segurança da Informação', 10, v_id);
    sp_inserir_vaga('DevOps Engineer', 1, v_id);
    sp_inserir_vaga('Desenvolvedor Back-End Node.js', 2, v_id);
    sp_inserir_vaga('Tech Lead Java', 3, v_id);
    sp_inserir_vaga('Engenheiro de Software', 4, v_id);
    sp_inserir_vaga('Analista de Banco de Dados', 5, v_id);
    DBMS_OUTPUT.PUT_LINE('15 vagas inseridas com sucesso!');
END;
/


BEGIN
    sp_inserir_usuario_habilidade(1, 1);
    sp_inserir_usuario_habilidade(1, 4);
    sp_inserir_usuario_habilidade(1, 10);
    
    sp_inserir_usuario_habilidade(2, 2);
    sp_inserir_usuario_habilidade(2, 4);
    sp_inserir_usuario_habilidade(2, 9);
    
    sp_inserir_usuario_habilidade(3, 3);
    sp_inserir_usuario_habilidade(3, 5);
    sp_inserir_usuario_habilidade(3, 6);
    
    sp_inserir_usuario_habilidade(4, 2);
    sp_inserir_usuario_habilidade(4, 4);
    sp_inserir_usuario_habilidade(4, 7);
    
    sp_inserir_usuario_habilidade(5, 9);
    sp_inserir_usuario_habilidade(5, 7);
    sp_inserir_usuario_habilidade(5, 8);
    
    sp_inserir_usuario_habilidade(6, 1);
    sp_inserir_usuario_habilidade(6, 7);
    sp_inserir_usuario_habilidade(6, 10);
    
    sp_inserir_usuario_habilidade(7, 3);
    sp_inserir_usuario_habilidade(7, 5);
    sp_inserir_usuario_habilidade(7, 10);
    
    sp_inserir_usuario_habilidade(8, 6);
    sp_inserir_usuario_habilidade(8, 3);
    sp_inserir_usuario_habilidade(8, 7);
    
    sp_inserir_usuario_habilidade(9, 1);
    sp_inserir_usuario_habilidade(9, 4);
    sp_inserir_usuario_habilidade(9, 9);
    
    sp_inserir_usuario_habilidade(10, 2);
    sp_inserir_usuario_habilidade(10, 8);
    sp_inserir_usuario_habilidade(10, 9);
    
    DBMS_OUTPUT.PUT_LINE('Habilidades dos usuários inseridas com sucesso!');
END;
/


DECLARE
    v_id NUMBER;
BEGIN
    sp_inserir_curso('Java Avançado', 'Alura', 40, 1, v_id);
    sp_inserir_curso('Python para Data Science', 'Coursera', 60, 2, v_id);
    sp_inserir_curso('React do Zero ao Avançado', 'Udemy', 50, 3, v_id);
    sp_inserir_curso('Banco de Dados Oracle', 'FIAP', 80, 4, v_id);
    sp_inserir_curso('AWS Solutions Architect', 'AWS Training', 120, 5, v_id);
    sp_inserir_curso('Docker e Kubernetes', 'LinuxTips', 40, 6, v_id);
    sp_inserir_curso('JavaScript Moderno', 'Rocketseat', 35, 7, v_id);
    sp_inserir_curso('Node.js Completo', 'Udemy', 45, 8, v_id);
    sp_inserir_curso('Scrum Master Certification', 'Scrum.org', 16, 9, v_id);
    sp_inserir_curso('Segurança da Informação', 'Descomplica', 60, 10, v_id);
    sp_inserir_curso('Git e GitHub', 'Digital Innovation One', 20, 1, v_id);
    sp_inserir_curso('Machine Learning', 'Coursera', 80, 2, v_id);
    DBMS_OUTPUT.PUT_LINE('Cursos inseridos com sucesso!');
END;
/



BEGIN
    sp_inserir_vaga_habilidade(1, 1);
    sp_inserir_vaga_habilidade(1, 4);
    sp_inserir_vaga_habilidade(1, 10);
    
    sp_inserir_vaga_habilidade(2, 2);
    sp_inserir_vaga_habilidade(2, 4);
    
    sp_inserir_vaga_habilidade(3, 3);
    sp_inserir_vaga_habilidade(3, 5);
    sp_inserir_vaga_habilidade(3, 6);
    
    sp_inserir_vaga_habilidade(4, 2);
    sp_inserir_vaga_habilidade(4, 4);
    sp_inserir_vaga_habilidade(4, 7);
    
    sp_inserir_vaga_habilidade(5, 9);
    sp_inserir_vaga_habilidade(5, 7);
    sp_inserir_vaga_habilidade(5, 8);
    
    sp_inserir_vaga_habilidade(6, 2);
    sp_inserir_vaga_habilidade(6, 4);
    
    sp_inserir_vaga_habilidade(7, 10);
    
    sp_inserir_vaga_habilidade(8, 3);
    sp_inserir_vaga_habilidade(8, 5);
    
    sp_inserir_vaga_habilidade(9, 1);
    sp_inserir_vaga_habilidade(9, 10);
    
    sp_inserir_vaga_habilidade(10, 2);
    sp_inserir_vaga_habilidade(10, 4);
    
    sp_inserir_vaga_habilidade(11, 7);
    sp_inserir_vaga_habilidade(11, 8);
    sp_inserir_vaga_habilidade(11, 9);
    
    sp_inserir_vaga_habilidade(12, 6);
    sp_inserir_vaga_habilidade(12, 4);
    
    DBMS_OUTPUT.PUT_LINE('Habilidades das vagas inseridas com sucesso!');
END;
/



DECLARE
    v_id NUMBER;
BEGIN
    sp_inserir_candidatura(1, 1, v_id);
    sp_inserir_candidatura(1, 9, v_id);
    
    sp_inserir_candidatura(2, 2, v_id);
    sp_inserir_candidatura(2, 4, v_id);
    sp_inserir_candidatura(2, 6, v_id);
    
    sp_inserir_candidatura(3, 3, v_id);
    sp_inserir_candidatura(3, 8, v_id);
    
    sp_inserir_candidatura(4, 4, v_id);
    sp_inserir_candidatura(4, 6, v_id);
    
    sp_inserir_candidatura(5, 5, v_id);
    sp_inserir_candidatura(5, 11, v_id);
    
    sp_inserir_candidatura(6, 1, v_id);
    sp_inserir_candidatura(6, 13, v_id);
    
    sp_inserir_candidatura(7, 8, v_id);
    sp_inserir_candidatura(7, 3, v_id);
    
    sp_inserir_candidatura(8, 12, v_id);
    sp_inserir_candidatura(8, 3, v_id);
    
    sp_inserir_candidatura(9, 1, v_id);
    
    sp_inserir_candidatura(10, 5, v_id);
    sp_inserir_candidatura(10, 11, v_id);
    
    DBMS_OUTPUT.PUT_LINE('Candidaturas inseridas com sucesso!');
END;
/
