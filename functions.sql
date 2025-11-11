/* ============================================================
                        FUNÇÕES
============================================================ */
DROP FUNCTION fn_usuario_para_json;
CREATE OR REPLACE FUNCTION fn_usuario_para_json(p_usuario_id IN NUMBER)
RETURN CLOB
AS
    v_json CLOB := EMPTY_CLOB();
    v_nome VARCHAR2(100);
    v_email VARCHAR2(100);
    v_usuario_existe NUMBER := 0;
    
    CURSOR c_habilidade IS
        SELECT h.nome
        FROM usuario_habilidade uh
        JOIN habilidades h ON h.id_habilidade = uh.habilidade_id
        WHERE uh.usuario_id = p_usuario_id;
    
    CURSOR c_cursos IS
        SELECT nome, instituicao, NVL(carga_horaria, 0) carga
        FROM cursos
        WHERE usuario_id = p_usuario_id;
    
    v_first BOOLEAN;
    
BEGIN
    IF p_usuario_id IS NULL THEN
        RETURN '{"error":"Parâmetro p_usuario_id não pode ser nulo"}';
    END IF;
    
    SELECT COUNT(*) INTO v_usuario_existe
    FROM usuarios
    WHERE id_usuario = p_usuario_id;
    
    IF v_usuario_existe = 0 THEN
        RETURN '{"error":"Usuário com ID ' || p_usuario_id || ' não encontrado"}';
    END IF;
    
    SELECT nome, email INTO v_nome, v_email
    FROM usuarios
    WHERE id_usuario = p_usuario_id;
    
    v_json := '{';
    v_json := v_json || '"id_usuario":' || TO_CHAR(p_usuario_id) || ',';
    v_json := v_json || '"nome":"' || REPLACE(v_nome, '"', '\"') || '",';
    v_json := v_json || '"email":"' || REPLACE(v_email, '"', '\"') || '",';
    
    v_json := v_json || '"habilidades":[';
    v_first := TRUE;
    
    FOR r IN c_habilidade LOOP
        IF NOT v_first THEN
            v_json := v_json || ',';
        END IF;
        v_json := v_json || '"' || REPLACE(r.nome, '"', '\"') || '"';
        v_first := FALSE;
    END LOOP;
    
    v_json := v_json || '],';
    
    v_json := v_json || '"cursos":[';
    v_first := TRUE;
    
    FOR r IN c_cursos LOOP
        IF NOT v_first THEN
            v_json := v_json || ',';
        END IF;
        v_json := v_json || '{'
            || '"nome":"' || REPLACE(r.nome, '"', '\"') || '",'
            || '"instituicao":"' || REPLACE(NVL(r.instituicao, 'N/A'), '"', '\"') || '",'
            || '"carga_horaria":' || TO_CHAR(r.carga)
            || '}';
        v_first := FALSE;
    END LOOP;
    
    v_json := v_json || ']';
    v_json := v_json || '}';
    
    RETURN v_json;
    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        RETURN '{"error":"Múltiplos usuários encontrados com ID ' || p_usuario_id || '"}';
    
    WHEN NO_DATA_FOUND THEN
        RETURN '{"error":"Dados não encontrados para o usuário ID ' || p_usuario_id || '"}';
    
    WHEN VALUE_ERROR THEN
        RETURN '{"error":"Erro ao processar dados - valor inválido"}';
    
    WHEN OTHERS THEN
        RETURN '{"error":"Erro inesperado: ' || SQLERRM || '"}';
        
END fn_usuario_para_json;
/

SELECT fn_usuario_para_json(1) AS json_resultado FROM dual;--vai funcionar
SELECT fn_usuario_para_json(999) AS json_resultado FROM dual;--vai dar erro


CREATE OR REPLACE FUNCTION fn_validar_e_calcular (
    p_email IN VARCHAR2,
    p_cpf   IN VARCHAR2,
    p_usuario_id IN NUMBER,
    p_vaga_id IN NUMBER
) RETURN CLOB IS
    v_resultado CLOB;
    v_email_valido BOOLEAN := FALSE;
    v_cpf_valido BOOLEAN := FALSE;
    v_total_habilidades_vaga NUMBER := 0;
    v_habilidades_correspondentes NUMBER := 0;
    v_score NUMBER := 0;
BEGIN
    IF REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        v_email_valido := TRUE;
    END IF;

    IF REGEXP_LIKE(p_cpf, '^\d{3}\.?\d{3}\.?\d{3}-?\d{2}$') THEN
        v_cpf_valido := TRUE;
    END IF;

    SELECT COUNT(*) INTO v_total_habilidades_vaga
    FROM vaga_habilidade
    WHERE vaga_id = p_vaga_id;

    SELECT COUNT(*) INTO v_habilidades_correspondentes
    FROM usuario_habilidade uh
    JOIN vaga_habilidade vh 
        ON uh.habilidade_id = vh.habilidade_id
    WHERE uh.usuario_id = p_usuario_id
      AND vh.vaga_id = p_vaga_id;

    IF v_total_habilidades_vaga > 0 THEN
        v_score := ROUND((v_habilidades_correspondentes / v_total_habilidades_vaga) * 100, 2);
    ELSE
        v_score := 0;
    END IF;

    v_resultado := '{"email_valido": ' || CASE WHEN v_email_valido THEN '"true"' ELSE '"false"' END ||
                   ', "cpf_valido": ' || CASE WHEN v_cpf_valido THEN '"true"' ELSE '"false"' END ||
                   ', "compatibilidade": ' || v_score ||
                   ', "mensagem": "Validação e cálculo realizados com sucesso"}';

    RETURN v_resultado;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '{"erro": "Usuário ou vaga inexistente."}';
    WHEN OTHERS THEN
        RETURN '{"erro": "Falha ao processar os dados: ' || SQLERRM || '"}';
END;
/


SELECT fn_validar_e_calcular('ana.santos@email.com', '123.456.789-00', 1, 1) FROM dual;

SELECT fn_validar_e_calcular('carlos.lima@email.com', '987.654.321-00', 2, 1) FROM dual;