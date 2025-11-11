/* ============================================================
   SEÇÃO 5: FUNÇÕES
============================================================ */

CREATE OR REPLACE FUNCTION fn_usuario_para_json(p_usuario_id IN NUMBER)
RETURN CLOB
AS
    v_json CLOB := EMPTY_CLOB();
    v_nome VARCHAR2(100);
    v_email VARCHAR2(100);
    v_usuario_existe NUMBER := 0;
    
    CURSOR c_hab IS
        SELECT h.nome
        FROM usuario_habilidade uh
        JOIN habilidades h ON h.id_habilidade = uh.habilidade_id
        WHERE uh.usuario_id = p_usuario_id;
    
    CURSOR c_cur IS
        SELECT nome, instituicao, NVL(carga_horaria, 0) carga
        FROM cursos
        WHERE usuario_id = p_usuario_id;
    
    v_first BOOLEAN;
    
    e_parametro_nulo EXCEPTION;
    e_usuario_nao_encontrado EXCEPTION;
    
BEGIN
    IF p_usuario_id IS NULL THEN
        RAISE e_parametro_nulo;
    END IF;
    
    BEGIN
        SELECT COUNT(*) INTO v_usuario_existe
        FROM usuarios
        WHERE id_usuario = p_usuario_id;
        
        IF v_usuario_existe = 0 THEN
            RAISE e_usuario_nao_encontrado;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_usuario_nao_encontrado;
    END;
    
    BEGIN
        SELECT nome, email INTO v_nome, v_email
        FROM usuarios
        WHERE id_usuario = p_usuario_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE e_usuario_nao_encontrado;
        WHEN TOO_MANY_ROWS THEN
            RETURN '{"error":"Múltiplos usuários encontrados com o mesmo ID"}';
    END;
    
    BEGIN
        v_json := '{';
        v_json := v_json || '"id_usuario":' || TO_CHAR(p_usuario_id) || ',';
        v_json := v_json || '"nome":"' || REPLACE(v_nome, '"', '\"') || '",';
        v_json := v_json || '"email":"' || REPLACE(v_email, '"', '\"') || '",';
        
        v_json := v_json || '"habilidades":[';
        v_first := TRUE;
        
        FOR r IN c_hab LOOP
            IF NOT v_first THEN
                v_json := v_json || ',';
            END IF;
            v_json := v_json || '"' || REPLACE(r.nome, '"', '\"') || '"';
            v_first := FALSE;
        END LOOP;
        
        v_json := v_json || '],';
        
        v_json := v_json || '"cursos":[';
        v_first := TRUE;
        
        FOR r IN c_cur LOOP
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
        
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RETURN '{"error":"Erro ao construir JSON - dados inválidos"}';
        WHEN OTHERS THEN
            RETURN '{"error":"Erro ao processar dados: ' || SQLERRM || '"}';
    END;
    
    RETURN v_json;
    
EXCEPTION
    WHEN e_parametro_nulo THEN
        RETURN '{"error":"Parametro p_usuario_id nulo"}';
    
    WHEN e_usuario_nao_encontrado THEN
        RETURN '{"error":"Usuário não encontrado"}';
    
    WHEN OTHERS THEN
        RETURN '{"error":"Erro inesperado: ' || SQLERRM || '"}';
        
END fn_usuario_para_json;
/