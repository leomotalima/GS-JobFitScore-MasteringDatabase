/* ============================================================
                       TRIGGERS
============================================================ */

CREATE OR REPLACE TRIGGER trg_audit_usuarios
AFTER INSERT OR UPDATE OR DELETE ON usuarios
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_detalhe VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_detalhe := 'Novo usuário: ' || :NEW.nome;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_detalhe := 'Usuário atualizado: ' || :NEW.nome;
    ELSE
        v_operacao := 'DELETE';
        v_detalhe := 'Usuário removido: ' || :OLD.nome;
    END IF;

    INSERT INTO auditoria_log (nome_tabela, operacao, registro_id, detalhe)
    VALUES ('USUARIOS', v_operacao, NVL(:NEW.id_usuario, :OLD.id_usuario),
        v_detalhe);
END;
/

CREATE OR REPLACE TRIGGER trg_audit_empresas
AFTER INSERT OR UPDATE OR DELETE ON empresas
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_detalhe VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_detalhe := 'Nova empresa: ' || :NEW.nome;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_detalhe := 'Empresa atualizada: ' || :NEW.nome;
    ELSE
        v_operacao := 'DELETE';
        v_detalhe := 'Empresa removida: ' || :OLD.nome;
    END IF;

    INSERT INTO auditoria_log (nome_tabela, operacao, registro_id, detalhe)
    VALUES (
        'EMPRESAS',
        v_operacao,
        NVL(:NEW.id_empresa, :OLD.id_empresa),
        v_detalhe
    );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_vagas
AFTER INSERT OR UPDATE OR DELETE ON vagas
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_detalhe VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_detalhe := 'Nova vaga: ' || :NEW.titulo;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_detalhe := 'Vaga atualizada: ' || :NEW.titulo;
    ELSE
        v_operacao := 'DELETE';
        v_detalhe := 'Vaga removida: ' || :OLD.titulo;
    END IF;

    INSERT INTO auditoria_log (nome_tabela, operacao, registro_id, detalhe)
    VALUES (
        'VAGAS',
        v_operacao,
        NVL(:NEW.id_vaga, :OLD.id_vaga),
        v_detalhe
    );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_habilidades
AFTER INSERT OR UPDATE OR DELETE ON habilidades
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_detalhe VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_detalhe := 'Nova habilidade: ' || :NEW.nome;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_detalhe := 'Habilidade atualizada: ' || :NEW.nome;
    ELSE
        v_operacao := 'DELETE';
        v_detalhe := 'Habilidade removida: ' || :OLD.nome;
    END IF;

    INSERT INTO auditoria_log (nome_tabela, operacao, registro_id, detalhe)
    VALUES (
        'HABILIDADES',
        v_operacao,
        NVL(:NEW.id_habilidade, :OLD.id_habilidade),
        v_detalhe
    );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_usuario_habilidade
AFTER INSERT OR UPDATE OR DELETE ON usuario_habilidade
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
    ELSE
        v_operacao := 'DELETE';
    END IF;

    INSERT INTO auditoria_log (nome_tabela, operacao, registro_id, detalhe)
    VALUES (
        'USUARIO_HABILIDADE',
        v_operacao,
        NVL(:NEW.id_usuario_habilidade, :OLD.id_usuario_habilidade),
        'Usuário ' || NVL(:NEW.usuario_id, :OLD.usuario_id) ||
        ' ↔ Habilidade ' || NVL(:NEW.habilidade_id, :OLD.habilidade_id)
    );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_cursos
AFTER INSERT OR UPDATE OR DELETE ON cursos
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_detalhe VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_detalhe := 'Curso adicionado: ' || :NEW.nome;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_detalhe := 'Curso atualizado: ' || :NEW.nome;
    ELSE
        v_operacao := 'DELETE';
        v_detalhe := 'Curso removido: ' || :OLD.nome;
    END IF;

    INSERT INTO auditoria_log (nome_tabela, operacao, registro_id, detalhe)
    VALUES (
        'CURSOS',
        v_operacao,
        NVL(:NEW.id_curso, :OLD.id_curso),
        v_detalhe
    );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_candidaturas
AFTER INSERT OR UPDATE OR DELETE ON candidaturas
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_detalhe VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_detalhe := 'Nova candidatura de usuário ' || :NEW.usuario_id;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_detalhe := 'Status atualizado para ' || :NEW.status;
    ELSE
        v_operacao := 'DELETE';
        v_detalhe := 'Candidatura removida de usuário ' || :OLD.usuario_id;
    END IF;

    INSERT INTO auditoria_log (nome_tabela, operacao, registro_id, detalhe)
    VALUES (
        'CANDIDATURAS',
        v_operacao,
        NVL(:NEW.id_candidatura, :OLD.id_candidatura),
        v_detalhe
    );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_vaga_habilidade
AFTER INSERT OR UPDATE OR DELETE ON vaga_habilidade
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
    ELSE
        v_operacao := 'DELETE';
    END IF;

    INSERT INTO auditoria_log (nome_tabela, operacao, registro_id, detalhe)
    VALUES (
        'VAGA_HABILIDADE',
        v_operacao,
        NVL(:NEW.id_vaga_habilidade, :OLD.id_vaga_habilidade),
        'Vaga ' || NVL(:NEW.vaga_id, :OLD.vaga_id) ||
        ' ↔ Habilidade ' || NVL(:NEW.habilidade_id, :OLD.habilidade_id)
    );
END;
/