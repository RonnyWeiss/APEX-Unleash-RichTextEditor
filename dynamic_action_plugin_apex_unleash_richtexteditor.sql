prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_210100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.3.00.05'
,p_default_workspace_id=>21717127411908241868
,p_default_application_id=>103428
,p_default_owner=>'RD_DEV'
);
end;
/

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/apex_unleash_richtexteditor
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(83788029902374428594)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'APEX.UNLEASH.RICHTEXTEDITOR'
,p_display_name=>'APEX Unleash RichTextEditor'
,p_category=>'EXECUTE'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PROCEDURE DOWNLOAD_FILE (',
'    P_IN_BLOB        BLOB,',
'    P_IN_FILE_NAME   VARCHAR2,',
'    P_IN_MIME_TYPE   VARCHAR2',
') AS',
'    VR_BLOB BLOB := P_IN_BLOB;',
'BEGIN',
'    HTP.INIT;',
'    OWA_UTIL.MIME_HEADER(',
'        NVL(',
'            P_IN_MIME_TYPE,',
'            ''application/octet''',
'        ),',
'        FALSE,',
'        ''UTF-8''',
'    );',
'    HTP.P(''Content-length: '' || DBMS_LOB.GETLENGTH(P_IN_BLOB));',
'    HTP.P(''Content-Disposition: attachment; filename="'' ||',
'    APEX_ESCAPE.HTML_ATTRIBUTE(P_IN_FILE_NAME) ||',
'    ''"'');',
'    OWA_UTIL.HTTP_HEADER_CLOSE;',
'    WPG_DOCLOAD.DOWNLOAD_FILE(VR_BLOB);',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        APEX_DEBUG.ERROR(''APEX Unleash RichTextEditor - Error while Execute File Download'');',
'        APEX_DEBUG.ERROR(SQLERRM);',
'        APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);',
'        RAISE;',
'END;',
'',
'FUNCTION SQL_TO_SYS_REFCURSOR (',
'    P_IN_SQL_STATEMENT   CLOB,',
'    P_IN_BINDS           SYS.DBMS_SQL.VARCHAR2_TABLE',
') RETURN SYS_REFCURSOR AS',
'    VR_CURS         BINARY_INTEGER;',
'    VR_REF_CURSOR   SYS_REFCURSOR;',
'    VR_EXEC         BINARY_INTEGER;',
'    /* TODO make size dynamic */',
'    VR_BINDS        VARCHAR(100);',
'BEGIN',
'    VR_CURS         := DBMS_SQL.OPEN_CURSOR;',
'    DBMS_SQL.PARSE(',
'        VR_CURS,',
'        P_IN_SQL_STATEMENT,',
'        DBMS_SQL.NATIVE',
'    );',
'    IF P_IN_BINDS.COUNT > 0 THEN',
'        FOR I IN 1..P_IN_BINDS.COUNT LOOP',
'            /* TODO find out how to prevent ltrim */',
'            VR_BINDS := LTRIM(',
'                P_IN_BINDS(I),',
'                '':''',
'            );',
'            DBMS_SQL.BIND_VARIABLE(',
'                VR_CURS,',
'                VR_BINDS,',
'                V(VR_BINDS)',
'            );',
'        END LOOP;',
'    END IF;',
'',
'    VR_EXEC         := DBMS_SQL.EXECUTE(VR_CURS);',
'    VR_REF_CURSOR   := DBMS_SQL.TO_REFCURSOR(VR_CURS);',
'    RETURN VR_REF_CURSOR;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        IF DBMS_SQL.IS_OPEN(VR_CURS) THEN',
'            DBMS_SQL.CLOSE_CURSOR(VR_CURS);',
'        END IF;',
'        RAISE;',
'END;',
'',
'FUNCTION F_AJAX (',
'    P_DYNAMIC_ACTION   IN   APEX_PLUGIN.T_DYNAMIC_ACTION,',
'    P_PLUGIN           IN   APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT IS',
'',
'    VR_BIND_NAMES          SYS.DBMS_SQL.VARCHAR2_TABLE;',
'    VR_BLOB                BLOB;',
'    VR_CLOB                CLOB := NULL;',
'    VR_CUR                 SYS_REFCURSOR;',
'    VR_FILE_NAME           VARCHAR2(200);',
'    VR_FUNCTION_TYPE       VARCHAR2(200) := APEX_APPLICATION.G_X01;',
'    VR_MIME_TYPE           VARCHAR2(200);',
'    VR_PK                  VARCHAR2(32767) := APEX_APPLICATION.G_X02;',
'    VR_PLSQL_PRINT_IMG     P_DYNAMIC_ACTION.ATTRIBUTE_15%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_15;',
'    VR_PLSQL_UPLOAD_CLOB   P_DYNAMIC_ACTION.ATTRIBUTE_06%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_06;',
'    VR_PLSQL_UPLOAD_IMG    P_DYNAMIC_ACTION.ATTRIBUTE_14%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_14;',
'    VR_RESULT              APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT;',
'    VR_SQL                 P_DYNAMIC_ACTION.ATTRIBUTE_03%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_03;',
'    VR_TMP_STR             VARCHAR2(32767);',
'BEGIN',
'    CASE',
'        WHEN VR_FUNCTION_TYPE = ''PRINT_CLOB'' THEN',
'            BEGIN',
'                /* undocumented function of APEX for get all bindings */',
'                VR_BIND_NAMES   := WWV_FLOW_UTILITIES.GET_BINDS(VR_SQL);',
'                VR_CUR          := SQL_TO_SYS_REFCURSOR(',
'                    RTRIM(',
'                        VR_SQL,',
'                        '';''',
'                    ),',
'                    VR_BIND_NAMES',
'                );',
'',
'                /* create json */',
'                APEX_JSON.OPEN_OBJECT;',
'                APEX_JSON.WRITE(',
'                    ''row'',',
'                    VR_CUR',
'                );',
'                APEX_JSON.CLOSE_OBJECT;',
'            EXCEPTION',
'                WHEN OTHERS THEN',
'                    IF VR_CUR%ISOPEN THEN',
'                        CLOSE VR_CUR;',
'                    END IF;',
'                    APEX_DEBUG.ERROR(''APEX Unleash RichTextEditor - Error while execute clob download'');',
'                    APEX_DEBUG.ERROR(SQLERRM);',
'                    APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);',
'                    RAISE;',
'            END;',
'        WHEN VR_FUNCTION_TYPE = ''UPLOAD_CLOB'' THEN',
'            BEGIN',
'                DBMS_LOB.CREATETEMPORARY(',
'                    VR_CLOB,',
'                    FALSE,',
'                    DBMS_LOB.SESSION',
'                );',
'                FOR I IN 1..APEX_APPLICATION.G_F01.COUNT LOOP',
'                    VR_TMP_STR := WWV_FLOW.G_F01(I);',
'                    IF DBMS_LOB.GETLENGTH(VR_TMP_STR) > 0 THEN',
'                        DBMS_LOB.WRITEAPPEND(',
'                            VR_CLOB,',
'                            DBMS_LOB.GETLENGTH(VR_TMP_STR),',
'                            VR_TMP_STR',
'                        );',
'                    END IF;',
'',
'                END LOOP;',
'',
'                BEGIN',
'                    EXECUTE IMMEDIATE ( VR_PLSQL_UPLOAD_CLOB )',
'                        USING VR_CLOB;',
'                EXCEPTION',
'                    WHEN OTHERS THEN',
'                        APEX_DEBUG.ERROR(''APEX Unleash RichTextEditor - Error while executing dynamic PL/SQL Block after Upload CLOB.'');',
'                        APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);',
'                END;',
'',
'                APEX_DEBUG.INFO(''APEX Unleash RichTextEditor - Upload and Execute of Dynamic PL/SQL Block successful with CLOB: '' ||',
'                DBMS_LOB.GETLENGTH(VR_CLOB) ||',
'                '' Bytes.'');',
'                DBMS_LOB.FREETEMPORARY(VR_CLOB);',
'            EXCEPTION',
'                WHEN OTHERS THEN',
'                    APEX_DEBUG.ERROR(''APEX Unleash RichTextEditor - Error while upload clob'');',
'                    APEX_DEBUG.ERROR(SQLERRM);',
'                    APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);',
'                    RAISE;',
'            END;',
'        WHEN VR_FUNCTION_TYPE = ''PRINT_IMAGE'' THEN',
'            BEGIN',
'                EXECUTE IMMEDIATE ( VR_PLSQL_PRINT_IMG )',
'                    USING IN VR_PK, OUT VR_FILE_NAME, OUT VR_MIME_TYPE, OUT VR_BLOB;',
'            EXCEPTION',
'                WHEN OTHERS THEN',
'                    APEX_DEBUG.ERROR(''APEX Unleash RichTextEditor - Error while executing dynamic PL/SQL Block to get Blob Source for Image Download.'');',
'                    APEX_DEBUG.ERROR(SQLERRM);',
'                    APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);',
'                    RAISE;',
'            END;',
'',
'            IF VR_FILE_NAME IS NOT NULL THEN',
'                DOWNLOAD_FILE(',
'                    P_IN_BLOB        => VR_BLOB,',
'                    P_IN_FILE_NAME   => VR_FILE_NAME,',
'                    P_IN_MIME_TYPE   => VR_MIME_TYPE',
'                );',
'            END IF;',
'',
'        WHEN VR_FUNCTION_TYPE = ''UPLOAD_IMAGE'' THEN',
'            BEGIN',
'                VR_FILE_NAME   := APEX_APPLICATION.G_X02;',
'                VR_MIME_TYPE   := NVL(',
'                    APEX_APPLICATION.G_X03,',
'                    ''application/octet-stream''',
'                );',
'                DBMS_LOB.CREATETEMPORARY(',
'                    VR_BLOB,',
'                    FALSE,',
'                    DBMS_LOB.SESSION',
'                );',
'                FOR I IN 1..APEX_APPLICATION.G_F01.COUNT LOOP',
'                    VR_TMP_STR := APEX_APPLICATION.G_F01(I);',
'                    IF DBMS_LOB.GETLENGTH(VR_TMP_STR) > 0 THEN',
'                        DBMS_LOB.APPEND(',
'                            DEST_LOB   => VR_BLOB,',
'                            SRC_LOB    => TO_BLOB(',
'                                UTL_ENCODE.BASE64_DECODE(',
'                                    UTL_RAW.CAST_TO_RAW(VR_TMP_STR)',
'                                )',
'                            )',
'                        );',
'',
'                    END IF;',
'',
'                END LOOP;',
'',
'                IF DBMS_LOB.GETLENGTH(VR_BLOB) IS NOT NULL THEN',
'                    BEGIN',
'                        EXECUTE IMMEDIATE ( VR_PLSQL_UPLOAD_IMG )',
'                            USING IN VR_FILE_NAME, IN VR_MIME_TYPE, IN VR_BLOB, OUT VR_PK;',
'                    EXCEPTION',
'                        WHEN OTHERS THEN',
'                            APEX_DEBUG.ERROR(''APEX Unleash RichTextEditor - Error while executing dynamic PL/SQL Block after Upload Image.'');',
'                            APEX_DEBUG.ERROR(SQLERRM);',
'                            APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);',
'                            RAISE;',
'                    END;',
'',
'                    APEX_DEBUG.INFO(''APEX Unleash RichTextEditor - Upload and Execute of Dynamic PL/SQL Block successful with Image: '' ||',
'                    DBMS_LOB.GETLENGTH(VR_BLOB) ||',
'                    '' Bytes and returned pk: '' ||',
'                    VR_PK);',
'',
'                END IF;',
'',
'                APEX_JSON.OPEN_OBJECT;',
'                APEX_JSON.WRITE(',
'                    P_NAME    => ''pk'',',
'                    P_VALUE   => VR_PK',
'                );',
'                APEX_JSON.WRITE(',
'                    P_NAME    => ''result'',',
'                    P_VALUE   => ''ok''',
'                );',
'                APEX_JSON.CLOSE_OBJECT;',
'                DBMS_LOB.FREETEMPORARY(VR_BLOB);',
'            EXCEPTION',
'                WHEN OTHERS THEN',
'                    DBMS_LOB.FREETEMPORARY(VR_BLOB);',
'                    APEX_DEBUG.ERROR(''APEX Unleash RichTextEditor - Error while Uploading Image'');',
'                    APEX_DEBUG.ERROR(SQLERRM);',
'                    APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);',
'                    RAISE;',
'            END;',
'        ELSE',
'            APEX_DEBUG.ERROR(''APEX Unleash RichTextEditor - No Case found in F_AJAX'');',
'    END CASE;',
'',
'    RETURN VR_RESULT;',
'END;',
'',
'FUNCTION F_RENDER (',
'    P_DYNAMIC_ACTION   IN                 APEX_PLUGIN.T_DYNAMIC_ACTION,',
'    P_PLUGIN           IN                 APEX_PLUGIN.T_PLUGIN',
') RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT IS',
'',
'    VR_ESCAPE_HTML          P_DYNAMIC_ACTION.ATTRIBUTE_08%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_08;',
'    VR_FUNCTION_TYPE        P_DYNAMIC_ACTION.ATTRIBUTE_01%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_01;',
'    VR_IMG_WIDTH            P_DYNAMIC_ACTION.ATTRIBUTE_02%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_02;',
'    VR_ITEMS_2_SUBMIT       P_DYNAMIC_ACTION.ATTRIBUTE_07%TYPE := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(P_DYNAMIC_ACTION.ATTRIBUTE_07);',
'    VR_ITEMS_2_SUBMIT_IU    P_DYNAMIC_ACTION.ATTRIBUTE_04%TYPE := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(P_DYNAMIC_ACTION.ATTRIBUTE_04);',
'    VR_ITEMS_2_SUBMIT_ID    P_DYNAMIC_ACTION.ATTRIBUTE_05%TYPE := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(P_DYNAMIC_ACTION.ATTRIBUTE_05);',
'    VR_RESULT               APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;',
'    VR_SANITIZE_HTML        P_DYNAMIC_ACTION.ATTRIBUTE_10%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_10;',
'    VR_SANITIZE_HTML_OPT    P_DYNAMIC_ACTION.ATTRIBUTE_11%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_11;',
'    VR_SHOW_LOADER          P_DYNAMIC_ACTION.ATTRIBUTE_12%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_12;',
'    VR_UN_ESCAPE_HTML       P_DYNAMIC_ACTION.ATTRIBUTE_09%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_09;',
'    VR_USE_IMAGE_UPLOADER   P_DYNAMIC_ACTION.ATTRIBUTE_13%TYPE := P_DYNAMIC_ACTION.ATTRIBUTE_13;',
'BEGIN',
'    APEX_JAVASCRIPT.ADD_LIBRARY(',
'        P_NAME                  => ''unleashrte.pkgd'',',
'        P_DIRECTORY             => P_PLUGIN.FILE_PREFIX,',
'        P_CHECK_TO_ADD_MINIFIED => TRUE,',
'        P_VERSION               => NULL,',
'        P_KEY                   => ''unleashrtejssrc''',
'    );',
'',
'    VR_RESULT.JAVASCRIPT_FUNCTION   := ''function () { var self = this; unleashRTE.initialize( self, { '' ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''ajaxID'', APEX_PLUGIN.GET_AJAX_IDENTIFIER ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''functionType'', VR_FUNCTION_TYPE ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''items2Submit'', VR_ITEMS_2_SUBMIT ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''items2SubmitImgDown'', VR_ITEMS_2_SUBMIT_ID ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''items2SubmitImgUp'', VR_ITEMS_2_SUBMIT_IU ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''escapeHTML'', VR_ESCAPE_HTML ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''unEscapeHTML'', VR_UN_ESCAPE_HTML ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''sanitize'', VR_SANITIZE_HTML ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''sanitizeOptions'', VR_SANITIZE_HTML_OPT ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''useImageUploader'', VR_USE_IMAGE_UPLOADER ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''imgWidth'', VR_IMG_WIDTH ) ||',
'    APEX_JAVASCRIPT.ADD_ATTRIBUTE( ''showLoader'', VR_SHOW_LOADER, TRUE, FALSE ) ||',
'    ''}); }'';',
'',
'    RETURN VR_RESULT;',
'END F_RENDER;'))
,p_api_version=>2
,p_render_function=>'F_RENDER'
,p_ajax_function=>'F_AJAX'
,p_standard_attributes=>'ITEM:REQUIRED:WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This plug-in makes it possible to add important features that IMHO simply lacks in the RichTextEditor:</p>',
'<ul>',
'<li>Load and save CLOB</li>',
'<li>It can remove dangerous HTML code from the CLOB or you can escaped the whole CLOB</li>',
'<li>If images are inserted into the RTE via Drag''n''Drop or screenshots are inserted into the RTE via CTRL+V, they are loaded into the database as BLOB and only referenced in the CLOB</li>',
'</ul>'))
,p_version_identifier=>'2.1.2.2'
,p_about_url=>'https://github.com/RonnyWeiss/APEX-Unleash-RichTextEditor'
,p_files_version=>198
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83788250919604443236)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Function Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'RENDER'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Used to set if this plug-in should load the html and images for RichTextEditor or if this plug-in is und save mod of the RichTextEditor content'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(83788708287045447800)
,p_plugin_attribute_id=>wwv_flow_api.id(83788250919604443236)
,p_display_sequence=>10
,p_display_value=>'Load RichTextEditor Content'
,p_return_value=>'RENDER'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(83788803377094449256)
,p_plugin_attribute_id=>wwv_flow_api.id(83788250919604443236)
,p_display_sequence=>20
,p_display_value=>'Save RichTextEditor Content'
,p_return_value=>'SAVE'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83795435665567598829)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>135
,p_prompt=>'Max Image Size'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'600'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83793496266454560636)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Used to set the default image size. If the image is in landscape format, then this maximum size is used in width. If the image is smaller, the original image size is used.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83789821069156476991)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'SQL Source'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    /* CLOB value */',
'    TO_CLOB(''Hello World'') AS CLOB_VALUE',
'FROM',
'    DUAL'))
,p_sql_min_column_count=>1
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83788250919604443236)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'RENDER'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Used to load Content for RichTextEditor. Check APEX Debug when error occurs.',
'<pre>',
'SELECT',
'    /* CLOB value */',
'    TO_CLOB(''Hello World'') AS CLOB_VALUE',
'FROM',
'    DUAL',
'</pre>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(84492131345206619795)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>150
,p_prompt=>'Items to Submit (NO SSP Protected allowed because of APEX Bug)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83793496266454560636)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Item to submit when upload image'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(84492155893358623079)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>170
,p_prompt=>'Items to Submit (NO SSP Protected allowed because of APEX Bug)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83793496266454560636)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Items that should be submitted for Image Loader.</p>',
'<b>Because of missing APEX feature no item with checksum can be used here.</b>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83791934322167520614)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Execute PL/SQL'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    /* You need to use V(''P1_COL_NAME'') because :P1_COL_NAME is not supported here */',
'    VR_COL_NAME   VARCHAR2(100) := NVL( V(''P1_COLLECTION_NAME''), ''MY_COLLECTION'');',
'BEGIN',
'    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(P_COLLECTION_NAME   => VR_COL_NAME);',
'    APEX_COLLECTION.ADD_MEMBER(',
'        P_COLLECTION_NAME   => VR_COL_NAME,',
'        P_CLOB001           => :CLOB',
'    );',
'END;'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83788250919604443236)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SAVE'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>You can execute dynamic PL/SQL when upload a CLOB.</p>',
'<p>Important is that you use the binding :CLOB for this binding the uploaded CLOB is set. Check APEX Debug when error occurs.</p>',
'<p>When want to use APEX items you have to call V(''P1_ITEM'') because of binding and add the items in "Items to Submit".</p>',
'<p>Use (SELECT V(''P1_ITEM'') FROM DUAL) for better perfromance when use in SQL Statement => See Oracle FAST_DUAL.</p>',
'<pre>',
'DECLARE',
'    /* You need to use V(''P1_COL_NAME'') because :P1_COL_NAME is not supported here */',
'    VR_COL_NAME   VARCHAR2(100) := NVL( V(''P1_COLLECTION_NAME''), ''MY_COLLECTION'');',
'BEGIN',
'    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(P_COLLECTION_NAME   => VR_COL_NAME);',
'    APEX_COLLECTION.ADD_MEMBER(',
'        P_COLLECTION_NAME   => VR_COL_NAME,',
'        P_CLOB001           => :CLOB',
'    );',
'END;',
'</pre>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83792430214041527308)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'Items that should be submited in each ajax call when upload or render CLOB or image.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83792475579954530837)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Escape special Characters'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83788250919604443236)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'RENDER'
,p_help_text=>'Select if special characters should be escaped in Render Mode.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83792488222236534369)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Unescape special Characters'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83788250919604443236)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SAVE'
,p_help_text=>'Unescapes HTML when upload to save it as HTML in DB.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83792515821457540204)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Sanitize HTML'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_help_text=>'Sanitizes HTML e.g. &lt;script&gt; tags will be removed.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83792518443265544148)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Sanitize HTML Options'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'  "ALLOWED_ATTR": [',
'    "accesskey",',
'    "align",',
'    "alt",',
'    "always",',
'    "autocomplete",',
'    "autoplay",',
'    "border",',
'    "cellpadding",',
'    "cellspacing",',
'    "charset",',
'    "class",',
'    "dir",',
'    "height",',
'    "href",',
'    "id",',
'    "lang",',
'    "name",',
'    "rel",',
'    "required",',
'    "src",',
'    "style",',
'    "summary",',
'    "tabindex",',
'    "target",',
'    "title",',
'    "type",',
'    "value",',
'    "width"',
'  ],',
'  "ALLOWED_TAGS": [',
'    "a",',
'    "address",',
'    "b",',
'    "blockquote",',
'    "br",',
'    "caption",',
'    "code",',
'    "dd",',
'    "div",',
'    "dl",',
'    "dt",',
'    "em",',
'    "figcaption",',
'    "figure",',
'    "h1",',
'    "h2",',
'    "h3",',
'    "h4",',
'    "h5",',
'    "h6",',
'    "hr",',
'    "i",',
'    "img",',
'    "label",',
'    "li",',
'    "nl",',
'    "ol",',
'    "p",',
'    "pre",',
'    "s",',
'    "span",',
'    "strike",',
'    "strong",',
'    "sub",',
'    "sup",',
'    "table",',
'    "tbody",',
'    "td",',
'    "th",',
'    "thead",',
'    "tr",',
'    "u",',
'    "ul"',
'  ]',
'}'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83792515821457540204)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This Clob Loader includes a sanitizer for HTML as option to use:',
'A Full Description you will find on: https://github.com/cure53/DOMPurify',
'Example: ',
'<pre>',
'{',
'  "ALLOWED_ATTR": [',
'    "accesskey",',
'    "align",',
'    "alt",',
'    "always",',
'    "autocomplete",',
'    "autoplay",',
'    "border",',
'    "cellpadding",',
'    "cellspacing",',
'    "charset",',
'    "class",',
'    "dir",',
'    "height",',
'    "href",',
'    "id",',
'    "lang",',
'    "name",',
'    "rel",',
'    "required",',
'    "src",',
'    "style",',
'    "summary",',
'    "tabindex",',
'    "target",',
'    "title",',
'    "type",',
'    "value",',
'    "width"',
'  ],',
'  "ALLOWED_TAGS": [',
'    "a",',
'    "address",',
'    "b",',
'    "blockquote",',
'    "br",',
'    "caption",',
'    "code",',
'    "dd",',
'    "div",',
'    "dl",',
'    "dt",',
'    "em",',
'    "figcaption",',
'    "figure",',
'    "h1",',
'    "h2",',
'    "h3",',
'    "h4",',
'    "h5",',
'    "h6",',
'    "hr",',
'    "i",',
'    "img",',
'    "label",',
'    "li",',
'    "nl",',
'    "ol",',
'    "p",',
'    "pre",',
'    "s",',
'    "span",',
'    "strike",',
'    "strong",',
'    "sub",',
'    "sup",',
'    "table",',
'    "tbody",',
'    "td",',
'    "th",',
'    "thead",',
'    "tr",',
'    "u",',
'    "ul"',
'  ]',
'}',
'</pre>',
'<pre>',
'# make output safe for usage in jQuery''s $()/html() method (default is false)',
'SAFE_FOR_JQUERY: true',
'',
'# strip {{ ... }} and &amp;lt;% ... %&amp;gt; to make output safe for template systems',
'# be careful please, this mode is not recommended for production usage.',
'# allowing template parsing in user-controlled HTML is not advised at all.',
'# only use this mode if there is really no alternative.',
'SAFE_FOR_TEMPLATES: true',
'',
'# allow only &amp;lt;b&amp;gt;',
'ALLOWED_TAGS: [''b'']',
'',
'# allow only &amp;lt;b&amp;gt; and &amp;lt;q&amp;gt; with style attributes (for whatever reason)',
'ALLOWED_TAGS: [''b'', ''q''], ALLOWED_ATTR: [''style'']',
'',
'# allow all safe HTML elements but neither SVG nor MathML',
'USE_PROFILES: {html: true}',
'',
'# allow all safe SVG elements and SVG Filters',
'USE_PROFILES: {svg: true, svgFilters: true}',
'',
'# allow all safe MathML elements and SVG',
'USE_PROFILES: {mathMl: true, svg: true}',
'',
'# leave all as it is but forbid &amp;lt;style&amp;gt;',
'FORBID_TAGS: [''style'']',
'',
'# leave all as it is but forbid style attributes',
'FORBID_ATTR: [''style'']',
'',
'# extend the existing array of allowed tags',
'ADD_TAGS: [''my-tag'']',
'',
'# extend the existing array of attributes',
'ADD_ATTR: [''my-attr'']',
'',
'# prohibit HTML5 data attributes (default is true)',
'ALLOW_DATA_ATTR: false',
'',
'# allow external protocol handlers in URL attributes (default is false)',
'# by default only http, https, ftp, ftps, tel, mailto, callto, cid and xmpp are allowed.',
'ALLOW_UNKNOWN_PROTOCOLS: true',
'</pre>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83792521649232547235)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Show Loader Icon'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'If selected then loader icon is shown on affected element. The Dynamic Action Events of this plugin is also fired on the affcted element.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83793496266454560636)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Use Image Uploader'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83788250919604443236)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'RENDER'
,p_help_text=>'This plugin can upload image to the database when drag or paste images into RichTextEditor. In RichTextEditor the images will just be referenced.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83793490489166561693)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Execute on Image Upload'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    VR_FILE_NAME   VARCHAR2(200) := :FILE_NAME;',
'    VR_MIME_TYPE   VARCHAR2(200) := :MIME_TYPE;',
'     /* Please ignore PLS-00382: expression is of wrong type',
'       because binding of :BLOB is not supported by current',
'       APEX PL/SQL Validator ',
'     */',
'    VR_BLOB        BLOB := :BLOB;',
'    /* You need to use V(''P1_COL_NAME'') because :P1_COL_NAME is not supported here */',
'    VR_COL_NAME    VARCHAR2(200) := NVL(V(''P1_COL_NAME''),''IMG_COLLECTION'');',
'BEGIN',
'    BEGIN',
'        APEX_COLLECTION.CREATE_COLLECTION(P_COLLECTION_NAME   => VR_COL_NAME);',
'    EXCEPTION',
'        WHEN OTHERS THEN',
'            NULL;',
'    END;',
'',
'    APEX_COLLECTION.ADD_MEMBER(',
'        P_COLLECTION_NAME   => VR_COL_NAME,',
'        P_C001              => VR_FILE_NAME,',
'        P_C002              => VR_MIME_TYPE,',
'        P_BLOB001           => VR_BLOB',
'    );',
'',
'    :P_OUT_PK   := VR_FILE_NAME;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        APEX_DEBUG.ERROR(SQLERRM);',
'        APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_STACK);',
'END;'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83793496266454560636)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This PL/SQL block is executed when a new image is loaded into the RTE.</p>',
'<p>It is important that the bindings :FILE_NAME, :MIME_TYPE, :BLOB are always specified in the order in the PL/SQL, so it is best to include them one after the other, as in the Declare example.</p>',
'<p>Check APEX Debug when error occurs.</p>',
'<p>When want to use APEX items you have to call V(''P1_ITEM'') because of binding and add the items in "Items to Submit".</p>',
'<p>Use (SELECT V(''P1_ITEM'') FROM DUAL) for better perfromance when use in SQL Statement => See Oracle FAST_DUAL.</p>',
'<pre>',
'DECLARE',
'    VR_FILE_NAME   VARCHAR2(200) := :FILE_NAME;',
'    VR_MIME_TYPE   VARCHAR2(200) := :MIME_TYPE;',
'     /* Please ignore PLS-00382: expression is of wrong type',
'       because binding of :BLOB is not supported by current',
'       APEX PL/SQL Validator ',
'     */',
'    VR_BLOB        BLOB := :BLOB;',
'    /* You need to use V(''P1_COL_NAME'') because :P1_COL_NAME is not supported here */',
'    VR_COL_NAME    VARCHAR2(200) := NVL(V(''P1_COL_NAME''),''IMG_COLLECTION'');',
'BEGIN',
'    BEGIN',
'        APEX_COLLECTION.CREATE_COLLECTION(P_COLLECTION_NAME   => VR_COL_NAME);',
'    EXCEPTION',
'        WHEN OTHERS THEN',
'            NULL;',
'    END;',
'',
'    APEX_COLLECTION.ADD_MEMBER(',
'        P_COLLECTION_NAME   => VR_COL_NAME,',
'        P_C001              => VR_FILE_NAME,',
'        P_C002              => VR_MIME_TYPE,',
'        P_BLOB001           => VR_BLOB',
'    );',
'',
'    :P_OUT_PK   := VR_FILE_NAME;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        APEX_DEBUG.ERROR(SQLERRM);',
'        APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_STACK);',
'END;',
'</pre>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(83794356498966564375)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>160
,p_prompt=>'Execute to get Image Sources'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    VR_FILE_NAME     VARCHAR2(200);',
'    VR_MIME_TYPE     VARCHAR2(200);',
'     /* Please ignore PLS-00382: expression is of wrong type',
'       because binding of :BLOB is not supported by current',
'       APEX PL/SQL Validator ',
'     */',
'    VR_BINARY_FILE   BLOB;',
'    VR_PK            VARCHAR2(200) := :PK;',
'    /* You need to use V(''P1_COL_NAME'') because :P1_COL_NAME is not supported here */',
'    VR_COL_NAME      VARCHAR2(200) := NVL(',
'        V(''P1_COL_NAME''),',
'        ''IMG_COLLECTION''',
'    );',
'BEGIN',
'    SELECT',
'        C001,',
'        C002,',
'        BLOB001',
'    INTO',
'        VR_FILE_NAME,',
'        VR_MIME_TYPE,',
'        VR_BINARY_FILE',
'    FROM',
'        APEX_COLLECTIONS',
'    WHERE',
'        COLLECTION_NAME   = VR_COL_NAME',
'        AND C001              = VR_PK',
'        AND ROWNUM            = 1;',
'',
'    :FILE_NAME     := VR_FILE_NAME;',
'    :MIME_TYPE     := VR_MIME_TYPE;',
'    :BINARY_FILE   := VR_BINARY_FILE;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        APEX_DEBUG.ERROR(SQLERRM);',
'        APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_STACK);',
'END;'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(83793496266454560636)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>If the CLOB is loaded into the RTE, the image download is inserted on the left.</p>',
'<p>This PL/SQL block is used to load the images from a table or collection using a primary key (:PK).</p>',
'<p>On Error please check APEX Debug. When want to use APEX items you have to call V(''P1_ITEM'') because of binding and add the items in "Items to Submit".</p>',
'<p>Use (SELECT V(''P1_ITEM'') FROM DUAL) for better perfromance when use in SQL Statement => See Oracle FAST_DUAL.</p>',
'<pre>',
'DECLARE',
'    VR_FILE_NAME     VARCHAR2(200);',
'    VR_MIME_TYPE     VARCHAR2(200);',
'     /* Please ignore PLS-00382: expression is of wrong type',
'       because binding of :BLOB is not supported by current',
'       APEX PL/SQL Validator ',
'     */',
'    VR_BINARY_FILE   BLOB;',
'    VR_PK            VARCHAR2(200) := :PK;',
'    /* You need to use V(''P1_COL_NAME'') because :P1_COL_NAME is not supported here */',
'    VR_COL_NAME      VARCHAR2(200) := NVL(',
'        V(''P1_COL_NAME''),',
'        ''IMG_COLLECTION''',
'    );',
'BEGIN',
'    SELECT',
'        C001,',
'        C002,',
'        BLOB001',
'    INTO',
'        VR_FILE_NAME,',
'        VR_MIME_TYPE,',
'        VR_BINARY_FILE',
'    FROM',
'        APEX_COLLECTIONS',
'    WHERE',
'        COLLECTION_NAME   = VR_COL_NAME',
'        AND C001              = VR_PK',
'        AND ROWNUM            = 1;',
'',
'    :FILE_NAME     := VR_FILE_NAME;',
'    :MIME_TYPE     := VR_MIME_TYPE;',
'    :BINARY_FILE   := VR_BINARY_FILE;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        APEX_DEBUG.ERROR(SQLERRM);',
'        APEX_DEBUG.ERROR(DBMS_UTILITY.FORMAT_ERROR_STACK);',
'END;',
'</pre>'))
);
end;
/
begin
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(83945185758039145084)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_name=>'clobloaderror'
,p_display_name=>'CLOB load error'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(83945185477470145083)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_name=>'clobloadfinished'
,p_display_name=>'CLOB load finished'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(83945455271677170030)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_name=>'clobsaveerror'
,p_display_name=>'CLOB save error'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(83945454989640170028)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_name=>'clobsavefinished'
,p_display_name=>'CLOB save finished'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(83945186504409145085)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_name=>'imageuploaderror'
,p_display_name=>'Image upload error'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(83945186172233145084)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_name=>'imageuploadifnished'
,p_display_name=>'Image upload finished'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2120406C6963656E736520444F4D507572696679207C202863292043757265353320616E64206F7468657220636F6E7472696275746F7273207C2052656C656173656420756E6465722074686520417061636865206C6963656E736520322E302061';
wwv_flow_api.g_varchar2_table(2) := '6E64204D6F7A696C6C61205075626C6963204C6963656E736520322E30207C206769746875622E636F6D2F6375726535332F444F4D5075726966792F626C6F622F322E322E322F4C4943454E5345202A2F0A0A2866756E6374696F6E2028676C6F62616C';
wwv_flow_api.g_varchar2_table(3) := '2C20666163746F727929207B0A2020747970656F66206578706F727473203D3D3D20276F626A6563742720262620747970656F66206D6F64756C6520213D3D2027756E646566696E656427203F206D6F64756C652E6578706F727473203D20666163746F';
wwv_flow_api.g_varchar2_table(4) := '72792829203A0A2020747970656F6620646566696E65203D3D3D202766756E6374696F6E2720262620646566696E652E616D64203F20646566696E6528666163746F727929203A0A202028676C6F62616C203D20676C6F62616C207C7C2073656C662C20';
wwv_flow_api.g_varchar2_table(5) := '676C6F62616C2E444F4D507572696679203D20666163746F72792829293B0A7D28746869732C2066756E6374696F6E202829207B202775736520737472696374273B0A0A202066756E6374696F6E205F746F436F6E73756D61626C654172726179286172';
wwv_flow_api.g_varchar2_table(6) := '7229207B206966202841727261792E69734172726179286172722929207B20666F7220287661722069203D20302C2061727232203D204172726179286172722E6C656E677468293B2069203C206172722E6C656E6774683B20692B2B29207B2061727232';
wwv_flow_api.g_varchar2_table(7) := '5B695D203D206172725B695D3B207D2072657475726E20617272323B207D20656C7365207B2072657475726E2041727261792E66726F6D28617272293B207D207D0A0A2020766172206861734F776E50726F7065727479203D204F626A6563742E686173';
wwv_flow_api.g_varchar2_table(8) := '4F776E50726F70657274792C0A20202020202073657450726F746F747970654F66203D204F626A6563742E73657450726F746F747970654F662C0A202020202020697346726F7A656E203D204F626A6563742E697346726F7A656E2C0A20202020202067';
wwv_flow_api.g_varchar2_table(9) := '657450726F746F747970654F66203D204F626A6563742E67657450726F746F747970654F662C0A2020202020206765744F776E50726F706572747944657363726970746F72203D204F626A6563742E6765744F776E50726F706572747944657363726970';
wwv_flow_api.g_varchar2_table(10) := '746F723B0A202076617220667265657A65203D204F626A6563742E667265657A652C0A2020202020207365616C203D204F626A6563742E7365616C2C0A202020202020637265617465203D204F626A6563742E6372656174653B202F2F2065736C696E74';
wwv_flow_api.g_varchar2_table(11) := '2D64697361626C652D6C696E6520696D706F72742F6E6F2D6D757461626C652D6578706F7274730A0A2020766172205F726566203D20747970656F66205265666C65637420213D3D2027756E646566696E656427202626205265666C6563742C0A202020';
wwv_flow_api.g_varchar2_table(12) := '2020206170706C79203D205F7265662E6170706C792C0A202020202020636F6E737472756374203D205F7265662E636F6E7374727563743B0A0A202069662028216170706C7929207B0A202020206170706C79203D2066756E6374696F6E206170706C79';
wwv_flow_api.g_varchar2_table(13) := '2866756E2C207468697356616C75652C206172677329207B0A20202020202072657475726E2066756E2E6170706C79287468697356616C75652C2061726773293B0A202020207D3B0A20207D0A0A20206966202821667265657A6529207B0A2020202066';
wwv_flow_api.g_varchar2_table(14) := '7265657A65203D2066756E6374696F6E20667265657A65287829207B0A20202020202072657475726E20783B0A202020207D3B0A20207D0A0A202069662028217365616C29207B0A202020207365616C203D2066756E6374696F6E207365616C28782920';
wwv_flow_api.g_varchar2_table(15) := '7B0A20202020202072657475726E20783B0A202020207D3B0A20207D0A0A20206966202821636F6E73747275637429207B0A20202020636F6E737472756374203D2066756E6374696F6E20636F6E7374727563742846756E632C206172677329207B0A20';
wwv_flow_api.g_varchar2_table(16) := '202020202072657475726E206E6577202846756E6374696F6E2E70726F746F747970652E62696E642E6170706C792846756E632C205B6E756C6C5D2E636F6E636174285F746F436F6E73756D61626C65417272617928617267732929292928293B0A2020';
wwv_flow_api.g_varchar2_table(17) := '20207D3B0A20207D0A0A2020766172206172726179466F7245616368203D20756E6170706C792841727261792E70726F746F747970652E666F7245616368293B0A2020766172206172726179506F70203D20756E6170706C792841727261792E70726F74';
wwv_flow_api.g_varchar2_table(18) := '6F747970652E706F70293B0A202076617220617272617950757368203D20756E6170706C792841727261792E70726F746F747970652E70757368293B0A0A202076617220737472696E67546F4C6F77657243617365203D20756E6170706C792853747269';
wwv_flow_api.g_varchar2_table(19) := '6E672E70726F746F747970652E746F4C6F77657243617365293B0A202076617220737472696E674D61746368203D20756E6170706C7928537472696E672E70726F746F747970652E6D61746368293B0A202076617220737472696E675265706C61636520';
wwv_flow_api.g_varchar2_table(20) := '3D20756E6170706C7928537472696E672E70726F746F747970652E7265706C616365293B0A202076617220737472696E67496E6465784F66203D20756E6170706C7928537472696E672E70726F746F747970652E696E6465784F66293B0A202076617220';
wwv_flow_api.g_varchar2_table(21) := '737472696E675472696D203D20756E6170706C7928537472696E672E70726F746F747970652E7472696D293B0A0A20207661722072656745787054657374203D20756E6170706C79285265674578702E70726F746F747970652E74657374293B0A0A2020';
wwv_flow_api.g_varchar2_table(22) := '76617220747970654572726F72437265617465203D20756E636F6E73747275637428547970654572726F72293B0A0A202066756E6374696F6E20756E6170706C792866756E6329207B0A2020202072657475726E2066756E6374696F6E20287468697341';
wwv_flow_api.g_varchar2_table(23) := '726729207B0A202020202020666F722028766172205F6C656E203D20617267756D656E74732E6C656E6774682C2061726773203D204172726179285F6C656E203E2031203F205F6C656E202D2031203A2030292C205F6B6579203D20313B205F6B657920';
wwv_flow_api.g_varchar2_table(24) := '3C205F6C656E3B205F6B65792B2B29207B0A2020202020202020617267735B5F6B6579202D20315D203D20617267756D656E74735B5F6B65795D3B0A2020202020207D0A0A20202020202072657475726E206170706C792866756E632C20746869734172';
wwv_flow_api.g_varchar2_table(25) := '672C2061726773293B0A202020207D3B0A20207D0A0A202066756E6374696F6E20756E636F6E7374727563742866756E6329207B0A2020202072657475726E2066756E6374696F6E202829207B0A202020202020666F722028766172205F6C656E32203D';
wwv_flow_api.g_varchar2_table(26) := '20617267756D656E74732E6C656E6774682C2061726773203D204172726179285F6C656E32292C205F6B657932203D20303B205F6B657932203C205F6C656E323B205F6B6579322B2B29207B0A2020202020202020617267735B5F6B6579325D203D2061';
wwv_flow_api.g_varchar2_table(27) := '7267756D656E74735B5F6B6579325D3B0A2020202020207D0A0A20202020202072657475726E20636F6E7374727563742866756E632C2061726773293B0A202020207D3B0A20207D0A0A20202F2A204164642070726F7065727469657320746F2061206C';
wwv_flow_api.g_varchar2_table(28) := '6F6F6B7570207461626C65202A2F0A202066756E6374696F6E20616464546F536574287365742C20617272617929207B0A202020206966202873657450726F746F747970654F6629207B0A2020202020202F2F204D616B652027696E2720616E64207472';
wwv_flow_api.g_varchar2_table(29) := '7574687920636865636B73206C696B6520426F6F6C65616E287365742E636F6E7374727563746F72290A2020202020202F2F20696E646570656E64656E74206F6620616E792070726F7065727469657320646566696E6564206F6E204F626A6563742E70';
wwv_flow_api.g_varchar2_table(30) := '726F746F747970652E0A2020202020202F2F2050726576656E742070726F746F7479706520736574746572732066726F6D20696E74657263657074696E6720736574206173206120746869732076616C75652E0A20202020202073657450726F746F7479';
wwv_flow_api.g_varchar2_table(31) := '70654F66287365742C206E756C6C293B0A202020207D0A0A20202020766172206C203D2061727261792E6C656E6774683B0A202020207768696C6520286C2D2D29207B0A20202020202076617220656C656D656E74203D2061727261795B6C5D3B0A2020';
wwv_flow_api.g_varchar2_table(32) := '2020202069662028747970656F6620656C656D656E74203D3D3D2027737472696E672729207B0A2020202020202020766172206C63456C656D656E74203D20737472696E67546F4C6F7765724361736528656C656D656E74293B0A202020202020202069';
wwv_flow_api.g_varchar2_table(33) := '6620286C63456C656D656E7420213D3D20656C656D656E7429207B0A202020202020202020202F2F20436F6E66696720707265736574732028652E672E20746167732E6A732C2061747472732E6A73292061726520696D6D757461626C652E0A20202020';
wwv_flow_api.g_varchar2_table(34) := '2020202020206966202821697346726F7A656E2861727261792929207B0A20202020202020202020202061727261795B6C5D203D206C63456C656D656E743B0A202020202020202020207D0A0A20202020202020202020656C656D656E74203D206C6345';
wwv_flow_api.g_varchar2_table(35) := '6C656D656E743B0A20202020202020207D0A2020202020207D0A0A2020202020207365745B656C656D656E745D203D20747275653B0A202020207D0A0A2020202072657475726E207365743B0A20207D0A0A20202F2A205368616C6C6F7720636C6F6E65';
wwv_flow_api.g_varchar2_table(36) := '20616E206F626A656374202A2F0A202066756E6374696F6E20636C6F6E65286F626A65637429207B0A20202020766172206E65774F626A656374203D20637265617465286E756C6C293B0A0A202020207661722070726F7065727479203D20766F696420';
wwv_flow_api.g_varchar2_table(37) := '303B0A20202020666F72202870726F706572747920696E206F626A65637429207B0A202020202020696620286170706C79286861734F776E50726F70657274792C206F626A6563742C205B70726F70657274795D2929207B0A20202020202020206E6577';
wwv_flow_api.g_varchar2_table(38) := '4F626A6563745B70726F70657274795D203D206F626A6563745B70726F70657274795D3B0A2020202020207D0A202020207D0A0A2020202072657475726E206E65774F626A6563743B0A20207D0A0A20202F2A204945313020646F65736E277420737570';
wwv_flow_api.g_varchar2_table(39) := '706F7274205F5F6C6F6F6B75704765747465725F5F20736F206C657473270A2020202A2073696D756C6174652069742E20497420616C736F206175746F6D61746963616C6C7920636865636B730A2020202A206966207468652070726F70206973206675';
wwv_flow_api.g_varchar2_table(40) := '6E6374696F6E206F722067657474657220616E6420626568617665730A2020202A206163636F7264696E676C792E202A2F0A202066756E6374696F6E206C6F6F6B7570476574746572286F626A6563742C2070726F7029207B0A202020207768696C6520';
wwv_flow_api.g_varchar2_table(41) := '286F626A65637420213D3D206E756C6C29207B0A2020202020207661722064657363203D206765744F776E50726F706572747944657363726970746F72286F626A6563742C2070726F70293B0A202020202020696620286465736329207B0A2020202020';
wwv_flow_api.g_varchar2_table(42) := '20202069662028646573632E67657429207B0A2020202020202020202072657475726E20756E6170706C7928646573632E676574293B0A20202020202020207D0A0A202020202020202069662028747970656F6620646573632E76616C7565203D3D3D20';
wwv_flow_api.g_varchar2_table(43) := '2766756E6374696F6E2729207B0A2020202020202020202072657475726E20756E6170706C7928646573632E76616C7565293B0A20202020202020207D0A2020202020207D0A0A2020202020206F626A656374203D2067657450726F746F747970654F66';
wwv_flow_api.g_varchar2_table(44) := '286F626A656374293B0A202020207D0A0A2020202066756E6374696F6E2066616C6C6261636B56616C756528656C656D656E7429207B0A202020202020636F6E736F6C652E7761726E282766616C6C6261636B2076616C756520666F72272C20656C656D';
wwv_flow_api.g_varchar2_table(45) := '656E74293B0A20202020202072657475726E206E756C6C3B0A202020207D0A0A2020202072657475726E2066616C6C6261636B56616C75653B0A20207D0A0A20207661722068746D6C203D20667265657A65285B2761272C202761626272272C20276163';
wwv_flow_api.g_varchar2_table(46) := '726F6E796D272C202761646472657373272C202761726561272C202761727469636C65272C20276173696465272C2027617564696F272C202762272C2027626469272C202762646F272C2027626967272C2027626C696E6B272C2027626C6F636B71756F';
wwv_flow_api.g_varchar2_table(47) := '7465272C2027626F6479272C20276272272C2027627574746F6E272C202763616E766173272C202763617074696F6E272C202763656E746572272C202763697465272C2027636F6465272C2027636F6C272C2027636F6C67726F7570272C2027636F6E74';
wwv_flow_api.g_varchar2_table(48) := '656E74272C202764617461272C2027646174616C697374272C20276464272C20276465636F7261746F72272C202764656C272C202764657461696C73272C202764666E272C20276469616C6F67272C2027646972272C2027646976272C2027646C272C20';
wwv_flow_api.g_varchar2_table(49) := '276474272C2027656C656D656E74272C2027656D272C20276669656C64736574272C202766696763617074696F6E272C2027666967757265272C2027666F6E74272C2027666F6F746572272C2027666F726D272C20276831272C20276832272C20276833';
wwv_flow_api.g_varchar2_table(50) := '272C20276834272C20276835272C20276836272C202768656164272C2027686561646572272C20276867726F7570272C20276872272C202768746D6C272C202769272C2027696D67272C2027696E707574272C2027696E73272C20276B6264272C20276C';
wwv_flow_api.g_varchar2_table(51) := '6162656C272C20276C6567656E64272C20276C69272C20276D61696E272C20276D6170272C20276D61726B272C20276D617271756565272C20276D656E75272C20276D656E756974656D272C20276D65746572272C20276E6176272C20276E6F6272272C';
wwv_flow_api.g_varchar2_table(52) := '20276F6C272C20276F707467726F7570272C20276F7074696F6E272C20276F7574707574272C202770272C202770696374757265272C2027707265272C202770726F6772657373272C202771272C20277270272C20277274272C202772756279272C2027';
wwv_flow_api.g_varchar2_table(53) := '73272C202773616D70272C202773656374696F6E272C202773656C656374272C2027736861646F77272C2027736D616C6C272C2027736F75726365272C2027737061636572272C20277370616E272C2027737472696B65272C20277374726F6E67272C20';
wwv_flow_api.g_varchar2_table(54) := '277374796C65272C2027737562272C202773756D6D617279272C2027737570272C20277461626C65272C202774626F6479272C20277464272C202774656D706C617465272C20277465787461726561272C202774666F6F74272C20277468272C20277468';
wwv_flow_api.g_varchar2_table(55) := '656164272C202774696D65272C20277472272C2027747261636B272C20277474272C202775272C2027756C272C2027766172272C2027766964656F272C2027776272275D293B0A0A20202F2F205356470A202076617220737667203D20667265657A6528';
wwv_flow_api.g_varchar2_table(56) := '5B27737667272C202761272C2027616C74676C797068272C2027616C74676C797068646566272C2027616C74676C7970686974656D272C2027616E696D617465636F6C6F72272C2027616E696D6174656D6F74696F6E272C2027616E696D617465747261';
wwv_flow_api.g_varchar2_table(57) := '6E73666F726D272C2027636972636C65272C2027636C697070617468272C202764656673272C202764657363272C2027656C6C69707365272C202766696C746572272C2027666F6E74272C202767272C2027676C797068272C2027676C79706872656627';
wwv_flow_api.g_varchar2_table(58) := '2C2027686B65726E272C2027696D616765272C20276C696E65272C20276C696E6561726772616469656E74272C20276D61726B6572272C20276D61736B272C20276D65746164617461272C20276D70617468272C202770617468272C2027706174746572';
wwv_flow_api.g_varchar2_table(59) := '6E272C2027706F6C79676F6E272C2027706F6C796C696E65272C202772616469616C6772616469656E74272C202772656374272C202773746F70272C20277374796C65272C2027737769746368272C202773796D626F6C272C202774657874272C202774';
wwv_flow_api.g_varchar2_table(60) := '65787470617468272C20277469746C65272C202774726566272C2027747370616E272C202776696577272C2027766B65726E275D293B0A0A20207661722073766746696C74657273203D20667265657A65285B276665426C656E64272C20276665436F6C';
wwv_flow_api.g_varchar2_table(61) := '6F724D6174726978272C20276665436F6D706F6E656E745472616E73666572272C20276665436F6D706F73697465272C20276665436F6E766F6C76654D6174726978272C20276665446966667573654C69676874696E67272C20276665446973706C6163';
wwv_flow_api.g_varchar2_table(62) := '656D656E744D6170272C2027666544697374616E744C69676874272C20276665466C6F6F64272C2027666546756E6341272C2027666546756E6342272C2027666546756E6347272C2027666546756E6352272C20276665476175737369616E426C757227';
wwv_flow_api.g_varchar2_table(63) := '2C202766654D65726765272C202766654D657267654E6F6465272C202766654D6F7270686F6C6F6779272C202766654F6666736574272C20276665506F696E744C69676874272C2027666553706563756C61724C69676874696E67272C2027666553706F';
wwv_flow_api.g_varchar2_table(64) := '744C69676874272C2027666554696C65272C2027666554757262756C656E6365275D293B0A0A20202F2F204C697374206F662053564720656C656D656E747320746861742061726520646973616C6C6F7765642062792064656661756C742E0A20202F2F';
wwv_flow_api.g_varchar2_table(65) := '205765207374696C6C206E65656420746F206B6E6F77207468656D20736F20746861742077652063616E20646F206E616D6573706163650A20202F2F20636865636B732070726F7065726C7920696E2063617365206F6E652077616E747320746F206164';
wwv_flow_api.g_varchar2_table(66) := '64207468656D20746F0A20202F2F20616C6C6F772D6C6973742E0A202076617220737667446973616C6C6F776564203D20667265657A65285B27616E696D617465272C2027636F6C6F722D70726F66696C65272C2027637572736F72272C202764697363';
wwv_flow_api.g_varchar2_table(67) := '617264272C2027666564726F70736861646F77272C20276665696D616765272C2027666F6E742D66616365272C2027666F6E742D666163652D666F726D6174272C2027666F6E742D666163652D6E616D65272C2027666F6E742D666163652D737263272C';
wwv_flow_api.g_varchar2_table(68) := '2027666F6E742D666163652D757269272C2027666F726569676E6F626A656374272C20276861746368272C2027686174636870617468272C20276D657368272C20276D6573686772616469656E74272C20276D6573687061746368272C20276D65736872';
wwv_flow_api.g_varchar2_table(69) := '6F77272C20276D697373696E672D676C797068272C2027736372697074272C2027736574272C2027736F6C6964636F6C6F72272C2027756E6B6E6F776E272C2027757365275D293B0A0A2020766172206D6174684D6C203D20667265657A65285B276D61';
wwv_flow_api.g_varchar2_table(70) := '7468272C20276D656E636C6F7365272C20276D6572726F72272C20276D66656E636564272C20276D66726163272C20276D676C797068272C20276D69272C20276D6C6162656C65647472272C20276D6D756C746973637269707473272C20276D6E272C20';
wwv_flow_api.g_varchar2_table(71) := '276D6F272C20276D6F766572272C20276D706164646564272C20276D7068616E746F6D272C20276D726F6F74272C20276D726F77272C20276D73272C20276D7370616365272C20276D73717274272C20276D7374796C65272C20276D737562272C20276D';
wwv_flow_api.g_varchar2_table(72) := '737570272C20276D737562737570272C20276D7461626C65272C20276D7464272C20276D74657874272C20276D7472272C20276D756E646572272C20276D756E6465726F766572275D293B0A0A20202F2F2053696D696C61726C7920746F205356472C20';
wwv_flow_api.g_varchar2_table(73) := '77652077616E7420746F206B6E6F7720616C6C204D6174684D4C20656C656D656E74732C0A20202F2F206576656E2074686F7365207468617420776520646973616C6C6F772062792064656661756C742E0A2020766172206D6174684D6C446973616C6C';
wwv_flow_api.g_varchar2_table(74) := '6F776564203D20667265657A65285B276D616374696F6E272C20276D616C69676E67726F7570272C20276D616C69676E6D61726B272C20276D6C6F6E67646976272C20276D7363617272696573272C20276D736361727279272C20276D7367726F757027';
wwv_flow_api.g_varchar2_table(75) := '2C20276D737461636B272C20276D736C696E65272C20276D73726F77272C202773656D616E74696373272C2027616E6E6F746174696F6E272C2027616E6E6F746174696F6E2D786D6C272C20276D70726573637269707473272C20276E6F6E65275D293B';
wwv_flow_api.g_varchar2_table(76) := '0A0A20207661722074657874203D20667265657A65285B272374657874275D293B0A0A20207661722068746D6C2431203D20667265657A65285B27616363657074272C2027616374696F6E272C2027616C69676E272C2027616C74272C20276175746F63';
wwv_flow_api.g_varchar2_table(77) := '61706974616C697A65272C20276175746F636F6D706C657465272C20276175746F70696374757265696E70696374757265272C20276175746F706C6179272C20276261636B67726F756E64272C20276267636F6C6F72272C2027626F72646572272C2027';
wwv_flow_api.g_varchar2_table(78) := '63617074757265272C202763656C6C70616464696E67272C202763656C6C73706163696E67272C2027636865636B6564272C202763697465272C2027636C617373272C2027636C656172272C2027636F6C6F72272C2027636F6C73272C2027636F6C7370';
wwv_flow_api.g_varchar2_table(79) := '616E272C2027636F6E74726F6C73272C2027636F6E74726F6C736C697374272C2027636F6F726473272C202763726F73736F726967696E272C20276461746574696D65272C20276465636F64696E67272C202764656661756C74272C2027646972272C20';
wwv_flow_api.g_varchar2_table(80) := '2764697361626C6564272C202764697361626C6570696374757265696E70696374757265272C202764697361626C6572656D6F7465706C61796261636B272C2027646F776E6C6F6164272C2027647261676761626C65272C2027656E6374797065272C20';
wwv_flow_api.g_varchar2_table(81) := '27656E7465726B657968696E74272C202766616365272C2027666F72272C202768656164657273272C2027686569676874272C202768696464656E272C202768696768272C202768726566272C2027687265666C616E67272C20276964272C2027696E70';
wwv_flow_api.g_varchar2_table(82) := '75746D6F6465272C2027696E74656772697479272C202769736D6170272C20276B696E64272C20276C6162656C272C20276C616E67272C20276C697374272C20276C6F6164696E67272C20276C6F6F70272C20276C6F77272C20276D6178272C20276D61';
wwv_flow_api.g_varchar2_table(83) := '786C656E677468272C20276D65646961272C20276D6574686F64272C20276D696E272C20276D696E6C656E677468272C20276D756C7469706C65272C20276D75746564272C20276E616D65272C20276E6F7368616465272C20276E6F76616C6964617465';
wwv_flow_api.g_varchar2_table(84) := '272C20276E6F77726170272C20276F70656E272C20276F7074696D756D272C20277061747465726E272C2027706C616365686F6C646572272C2027706C617973696E6C696E65272C2027706F73746572272C20277072656C6F6164272C20277075626461';
wwv_flow_api.g_varchar2_table(85) := '7465272C2027726164696F67726F7570272C2027726561646F6E6C79272C202772656C272C20277265717569726564272C2027726576272C20277265766572736564272C2027726F6C65272C2027726F7773272C2027726F777370616E272C2027737065';
wwv_flow_api.g_varchar2_table(86) := '6C6C636865636B272C202773636F7065272C202773656C6563746564272C20277368617065272C202773697A65272C202773697A6573272C20277370616E272C20277372636C616E67272C20277374617274272C2027737263272C202773726373657427';
wwv_flow_api.g_varchar2_table(87) := '2C202773746570272C20277374796C65272C202773756D6D617279272C2027746162696E646578272C20277469746C65272C20277472616E736C617465272C202774797065272C20277573656D6170272C202776616C69676E272C202776616C7565272C';
wwv_flow_api.g_varchar2_table(88) := '20277769647468272C2027786D6C6E73272C2027736C6F74275D293B0A0A2020766172207376672431203D20667265657A65285B27616363656E742D686569676874272C2027616363756D756C617465272C20276164646974697665272C2027616C6967';
wwv_flow_api.g_varchar2_table(89) := '6E6D656E742D626173656C696E65272C2027617363656E74272C20276174747269627574656E616D65272C202761747472696275746574797065272C2027617A696D757468272C2027626173656672657175656E6379272C2027626173656C696E652D73';
wwv_flow_api.g_varchar2_table(90) := '68696674272C2027626567696E272C202762696173272C20276279272C2027636C617373272C2027636C6970272C2027636C697070617468756E697473272C2027636C69702D70617468272C2027636C69702D72756C65272C2027636F6C6F72272C2027';
wwv_flow_api.g_varchar2_table(91) := '636F6C6F722D696E746572706F6C6174696F6E272C2027636F6C6F722D696E746572706F6C6174696F6E2D66696C74657273272C2027636F6C6F722D70726F66696C65272C2027636F6C6F722D72656E646572696E67272C20276378272C20276379272C';
wwv_flow_api.g_varchar2_table(92) := '202764272C20276478272C20276479272C202764696666757365636F6E7374616E74272C2027646972656374696F6E272C2027646973706C6179272C202764697669736F72272C2027647572272C2027656467656D6F6465272C2027656C65766174696F';
wwv_flow_api.g_varchar2_table(93) := '6E272C2027656E64272C202766696C6C272C202766696C6C2D6F706163697479272C202766696C6C2D72756C65272C202766696C746572272C202766696C746572756E697473272C2027666C6F6F642D636F6C6F72272C2027666C6F6F642D6F70616369';
wwv_flow_api.g_varchar2_table(94) := '7479272C2027666F6E742D66616D696C79272C2027666F6E742D73697A65272C2027666F6E742D73697A652D61646A757374272C2027666F6E742D73747265746368272C2027666F6E742D7374796C65272C2027666F6E742D76617269616E74272C2027';
wwv_flow_api.g_varchar2_table(95) := '666F6E742D776569676874272C20276678272C20276679272C20276731272C20276732272C2027676C7970682D6E616D65272C2027676C797068726566272C20276772616469656E74756E697473272C20276772616469656E747472616E73666F726D27';
wwv_flow_api.g_varchar2_table(96) := '2C2027686569676874272C202768726566272C20276964272C2027696D6167652D72656E646572696E67272C2027696E272C2027696E32272C20276B272C20276B31272C20276B32272C20276B33272C20276B34272C20276B65726E696E67272C20276B';
wwv_flow_api.g_varchar2_table(97) := '6579706F696E7473272C20276B657973706C696E6573272C20276B657974696D6573272C20276C616E67272C20276C656E67746861646A757374272C20276C65747465722D73706163696E67272C20276B65726E656C6D6174726978272C20276B65726E';
wwv_flow_api.g_varchar2_table(98) := '656C756E69746C656E677468272C20276C69676874696E672D636F6C6F72272C20276C6F63616C272C20276D61726B65722D656E64272C20276D61726B65722D6D6964272C20276D61726B65722D7374617274272C20276D61726B657268656967687427';
wwv_flow_api.g_varchar2_table(99) := '2C20276D61726B6572756E697473272C20276D61726B65727769647468272C20276D61736B636F6E74656E74756E697473272C20276D61736B756E697473272C20276D6178272C20276D61736B272C20276D65646961272C20276D6574686F64272C2027';
wwv_flow_api.g_varchar2_table(100) := '6D6F6465272C20276D696E272C20276E616D65272C20276E756D6F637461766573272C20276F6666736574272C20276F70657261746F72272C20276F706163697479272C20276F72646572272C20276F7269656E74272C20276F7269656E746174696F6E';
wwv_flow_api.g_varchar2_table(101) := '272C20276F726967696E272C20276F766572666C6F77272C20277061696E742D6F72646572272C202770617468272C2027706174686C656E677468272C20277061747465726E636F6E74656E74756E697473272C20277061747465726E7472616E73666F';
wwv_flow_api.g_varchar2_table(102) := '726D272C20277061747465726E756E697473272C2027706F696E7473272C20277072657365727665616C706861272C20277072657365727665617370656374726174696F272C20277072696D6974697665756E697473272C202772272C20277278272C20';
wwv_flow_api.g_varchar2_table(103) := '277279272C2027726164697573272C202772656678272C202772656679272C2027726570656174636F756E74272C2027726570656174647572272C202772657374617274272C2027726573756C74272C2027726F74617465272C20277363616C65272C20';
wwv_flow_api.g_varchar2_table(104) := '2773656564272C202773686170652D72656E646572696E67272C202773706563756C6172636F6E7374616E74272C202773706563756C61726578706F6E656E74272C20277370726561646D6574686F64272C202773746172746F6666736574272C202773';
wwv_flow_api.g_varchar2_table(105) := '7464646576696174696F6E272C202773746974636874696C6573272C202773746F702D636F6C6F72272C202773746F702D6F706163697479272C20277374726F6B652D646173686172726179272C20277374726F6B652D646173686F6666736574272C20';
wwv_flow_api.g_varchar2_table(106) := '277374726F6B652D6C696E65636170272C20277374726F6B652D6C696E656A6F696E272C20277374726F6B652D6D697465726C696D6974272C20277374726F6B652D6F706163697479272C20277374726F6B65272C20277374726F6B652D776964746827';
wwv_flow_api.g_varchar2_table(107) := '2C20277374796C65272C2027737572666163657363616C65272C202773797374656D6C616E6775616765272C2027746162696E646578272C202774617267657478272C202774617267657479272C20277472616E73666F726D272C2027746578742D616E';
wwv_flow_api.g_varchar2_table(108) := '63686F72272C2027746578742D6465636F726174696F6E272C2027746578742D72656E646572696E67272C2027746578746C656E677468272C202774797065272C20277531272C20277532272C2027756E69636F6465272C202776616C756573272C2027';
wwv_flow_api.g_varchar2_table(109) := '76696577626F78272C20277669736962696C697479272C202776657273696F6E272C2027766572742D6164762D79272C2027766572742D6F726967696E2D78272C2027766572742D6F726967696E2D79272C20277769647468272C2027776F72642D7370';
wwv_flow_api.g_varchar2_table(110) := '6163696E67272C202777726170272C202777726974696E672D6D6F6465272C2027786368616E6E656C73656C6563746F72272C2027796368616E6E656C73656C6563746F72272C202778272C20277831272C20277832272C2027786D6C6E73272C202779';
wwv_flow_api.g_varchar2_table(111) := '272C20277931272C20277932272C20277A272C20277A6F6F6D616E6470616E275D293B0A0A2020766172206D6174684D6C2431203D20667265657A65285B27616363656E74272C2027616363656E74756E646572272C2027616C69676E272C2027626576';
wwv_flow_api.g_varchar2_table(112) := '656C6C6564272C2027636C6F7365272C2027636F6C756D6E73616C69676E272C2027636F6C756D6E6C696E6573272C2027636F6C756D6E7370616E272C202764656E6F6D616C69676E272C20276465707468272C2027646972272C2027646973706C6179';
wwv_flow_api.g_varchar2_table(113) := '272C2027646973706C61797374796C65272C2027656E636F64696E67272C202766656E6365272C20276672616D65272C2027686569676874272C202768726566272C20276964272C20276C617267656F70272C20276C656E677468272C20276C696E6574';
wwv_flow_api.g_varchar2_table(114) := '6869636B6E657373272C20276C7370616365272C20276C71756F7465272C20276D6174686261636B67726F756E64272C20276D617468636F6C6F72272C20276D61746873697A65272C20276D61746876617269616E74272C20276D617873697A65272C20';
wwv_flow_api.g_varchar2_table(115) := '276D696E73697A65272C20276D6F7661626C656C696D697473272C20276E6F746174696F6E272C20276E756D616C69676E272C20276F70656E272C2027726F77616C69676E272C2027726F776C696E6573272C2027726F7773706163696E67272C202772';
wwv_flow_api.g_varchar2_table(116) := '6F777370616E272C2027727370616365272C20277271756F7465272C20277363726970746C6576656C272C20277363726970746D696E73697A65272C202773637269707473697A656D756C7469706C696572272C202773656C656374696F6E272C202773';
wwv_flow_api.g_varchar2_table(117) := '6570617261746F72272C2027736570617261746F7273272C20277374726574636879272C20277375627363726970747368696674272C20277375707363726970747368696674272C202773796D6D6574726963272C2027766F6666736574272C20277769';
wwv_flow_api.g_varchar2_table(118) := '647468272C2027786D6C6E73275D293B0A0A202076617220786D6C203D20667265657A65285B27786C696E6B3A68726566272C2027786D6C3A6964272C2027786C696E6B3A7469746C65272C2027786D6C3A7370616365272C2027786D6C6E733A786C69';
wwv_flow_api.g_varchar2_table(119) := '6E6B275D293B0A0A20202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520756E69636F726E2F6265747465722D72656765780A2020766172204D555354414348455F45585052203D207365616C282F5C7B5C7B5B5C735C535D2A7C5B';
wwv_flow_api.g_varchar2_table(120) := '5C735C535D2A5C7D5C7D2F676D293B202F2F20537065636966792074656D706C61746520646574656374696F6E20726567657820666F7220534146455F464F525F54454D504C41544553206D6F64650A2020766172204552425F45585052203D20736561';
wwv_flow_api.g_varchar2_table(121) := '6C282F3C255B5C735C535D2A7C5B5C735C535D2A253E2F676D293B0A202076617220444154415F41545452203D207365616C282F5E646174612D5B5C2D5C772E5C75303042372D5C75464646465D2F293B202F2F2065736C696E742D64697361626C652D';
wwv_flow_api.g_varchar2_table(122) := '6C696E65206E6F2D7573656C6573732D6573636170650A202076617220415249415F41545452203D207365616C282F5E617269612D5B5C2D5C775D2B242F293B202F2F2065736C696E742D64697361626C652D6C696E65206E6F2D7573656C6573732D65';
wwv_flow_api.g_varchar2_table(123) := '73636170650A20207661722049535F414C4C4F5745445F555249203D207365616C282F5E283F3A283F3A283F3A667C6874297470733F7C6D61696C746F7C74656C7C63616C6C746F7C6369647C786D7070293A7C5B5E612D7A5D7C5B612D7A2B2E5C2D5D';
wwv_flow_api.g_varchar2_table(124) := '2B283F3A5B5E612D7A2B2E5C2D3A5D7C2429292F69202F2F2065736C696E742D64697361626C652D6C696E65206E6F2D7573656C6573732D6573636170650A2020293B0A20207661722049535F5343524950545F4F525F44415441203D207365616C282F';
wwv_flow_api.g_varchar2_table(125) := '5E283F3A5C772B7363726970747C64617461293A2F69293B0A202076617220415454525F57484954455350414345203D207365616C282F5B5C75303030302D5C75303032305C75303041305C75313638305C75313830455C75323030302D5C7532303239';
wwv_flow_api.g_varchar2_table(126) := '5C75323035465C75333030305D2F67202F2F2065736C696E742D64697361626C652D6C696E65206E6F2D636F6E74726F6C2D72656765780A2020293B0A0A2020766172205F747970656F66203D20747970656F662053796D626F6C203D3D3D202266756E';
wwv_flow_api.g_varchar2_table(127) := '6374696F6E2220262620747970656F662053796D626F6C2E6974657261746F72203D3D3D202273796D626F6C22203F2066756E6374696F6E20286F626A29207B2072657475726E20747970656F66206F626A3B207D203A2066756E6374696F6E20286F62';
wwv_flow_api.g_varchar2_table(128) := '6A29207B2072657475726E206F626A20262620747970656F662053796D626F6C203D3D3D202266756E6374696F6E22202626206F626A2E636F6E7374727563746F72203D3D3D2053796D626F6C202626206F626A20213D3D2053796D626F6C2E70726F74';
wwv_flow_api.g_varchar2_table(129) := '6F74797065203F202273796D626F6C22203A20747970656F66206F626A3B207D3B0A0A202066756E6374696F6E205F746F436F6E73756D61626C65417272617924312861727229207B206966202841727261792E69734172726179286172722929207B20';
wwv_flow_api.g_varchar2_table(130) := '666F7220287661722069203D20302C2061727232203D204172726179286172722E6C656E677468293B2069203C206172722E6C656E6774683B20692B2B29207B20617272325B695D203D206172725B695D3B207D2072657475726E20617272323B207D20';
wwv_flow_api.g_varchar2_table(131) := '656C7365207B2072657475726E2041727261792E66726F6D28617272293B207D207D0A0A202076617220676574476C6F62616C203D2066756E6374696F6E20676574476C6F62616C2829207B0A2020202072657475726E20747970656F662077696E646F';
wwv_flow_api.g_varchar2_table(132) := '77203D3D3D2027756E646566696E656427203F206E756C6C203A2077696E646F773B0A20207D3B0A0A20202F2A2A0A2020202A20437265617465732061206E6F2D6F7020706F6C69637920666F7220696E7465726E616C20757365206F6E6C792E0A2020';
wwv_flow_api.g_varchar2_table(133) := '202A20446F6E2774206578706F727420746869732066756E6374696F6E206F7574736964652074686973206D6F64756C65210A2020202A2040706172616D207B3F5472757374656454797065506F6C696379466163746F72797D20747275737465645479';
wwv_flow_api.g_varchar2_table(134) := '7065732054686520706F6C69637920666163746F72792E0A2020202A2040706172616D207B446F63756D656E747D20646F63756D656E742054686520646F63756D656E74206F626A6563742028746F2064657465726D696E6520706F6C696379206E616D';
wwv_flow_api.g_varchar2_table(135) := '6520737566666978290A2020202A204072657475726E207B3F5472757374656454797065506F6C6963797D2054686520706F6C696379206372656174656420286F72206E756C6C2C20696620547275737465642054797065730A2020202A20617265206E';
wwv_flow_api.g_varchar2_table(136) := '6F7420737570706F72746564292E0A2020202A2F0A2020766172205F637265617465547275737465645479706573506F6C696379203D2066756E6374696F6E205F637265617465547275737465645479706573506F6C6963792874727573746564547970';
wwv_flow_api.g_varchar2_table(137) := '65732C20646F63756D656E7429207B0A202020206966202828747970656F6620747275737465645479706573203D3D3D2027756E646566696E656427203F2027756E646566696E656427203A205F747970656F6628747275737465645479706573292920';
wwv_flow_api.g_varchar2_table(138) := '213D3D20276F626A65637427207C7C20747970656F66207472757374656454797065732E637265617465506F6C69637920213D3D202766756E6374696F6E2729207B0A20202020202072657475726E206E756C6C3B0A202020207D0A0A202020202F2F20';
wwv_flow_api.g_varchar2_table(139) := '416C6C6F77207468652063616C6C65727320746F20636F6E74726F6C2074686520756E6971756520706F6C696379206E616D650A202020202F2F20627920616464696E67206120646174612D74742D706F6C6963792D73756666697820746F2074686520';
wwv_flow_api.g_varchar2_table(140) := '73637269707420656C656D656E7420776974682074686520444F4D5075726966792E0A202020202F2F20506F6C696379206372656174696F6E2077697468206475706C6963617465206E616D6573207468726F777320696E205472757374656420547970';
wwv_flow_api.g_varchar2_table(141) := '65732E0A2020202076617220737566666978203D206E756C6C3B0A2020202076617220415454525F4E414D45203D2027646174612D74742D706F6C6963792D737566666978273B0A2020202069662028646F63756D656E742E63757272656E7453637269';
wwv_flow_api.g_varchar2_table(142) := '707420262620646F63756D656E742E63757272656E745363726970742E68617341747472696275746528415454525F4E414D452929207B0A202020202020737566666978203D20646F63756D656E742E63757272656E745363726970742E676574417474';
wwv_flow_api.g_varchar2_table(143) := '72696275746528415454525F4E414D45293B0A202020207D0A0A2020202076617220706F6C6963794E616D65203D2027646F6D70757269667927202B2028737566666978203F20272327202B20737566666978203A202727293B0A0A2020202074727920';
wwv_flow_api.g_varchar2_table(144) := '7B0A20202020202072657475726E207472757374656454797065732E637265617465506F6C69637928706F6C6963794E616D652C207B0A202020202020202063726561746548544D4C3A2066756E6374696F6E2063726561746548544D4C2868746D6C24';
wwv_flow_api.g_varchar2_table(145) := '243129207B0A2020202020202020202072657475726E2068746D6C2424313B0A20202020202020207D0A2020202020207D293B0A202020207D20636174636820285F29207B0A2020202020202F2F20506F6C696379206372656174696F6E206661696C65';
wwv_flow_api.g_varchar2_table(146) := '6420286D6F7374206C696B656C7920616E6F7468657220444F4D50757269667920736372697074206861730A2020202020202F2F20616C72656164792072756E292E20536B6970206372656174696E672074686520706F6C6963792C2061732074686973';
wwv_flow_api.g_varchar2_table(147) := '2077696C6C206F6E6C79206361757365206572726F72730A2020202020202F2F2069662054542061726520656E666F726365642E0A202020202020636F6E736F6C652E7761726E282754727573746564547970657320706F6C6963792027202B20706F6C';
wwv_flow_api.g_varchar2_table(148) := '6963794E616D65202B202720636F756C64206E6F7420626520637265617465642E27293B0A20202020202072657475726E206E756C6C3B0A202020207D0A20207D3B0A0A202066756E6374696F6E20637265617465444F4D5075726966792829207B0A20';
wwv_flow_api.g_varchar2_table(149) := '2020207661722077696E646F77203D20617267756D656E74732E6C656E677468203E203020262620617267756D656E74735B305D20213D3D20756E646566696E6564203F20617267756D656E74735B305D203A20676574476C6F62616C28293B0A0A2020';
wwv_flow_api.g_varchar2_table(150) := '202076617220444F4D507572696679203D2066756E6374696F6E20444F4D50757269667928726F6F7429207B0A20202020202072657475726E20637265617465444F4D50757269667928726F6F74293B0A202020207D3B0A0A202020202F2A2A0A202020';
wwv_flow_api.g_varchar2_table(151) := '20202A2056657273696F6E206C6162656C2C206578706F73656420666F722065617369657220636865636B730A20202020202A20696620444F4D50757269667920697320757020746F2064617465206F72206E6F740A20202020202A2F0A20202020444F';
wwv_flow_api.g_varchar2_table(152) := '4D5075726966792E76657273696F6E203D2027322E322E39273B0A0A202020202F2A2A0A20202020202A204172726179206F6620656C656D656E7473207468617420444F4D5075726966792072656D6F76656420647572696E672073616E69746174696F';
wwv_flow_api.g_varchar2_table(153) := '6E2E0A20202020202A20456D707479206966206E6F7468696E67207761732072656D6F7665642E0A20202020202A2F0A20202020444F4D5075726966792E72656D6F766564203D205B5D3B0A0A20202020696620282177696E646F77207C7C202177696E';
wwv_flow_api.g_varchar2_table(154) := '646F772E646F63756D656E74207C7C2077696E646F772E646F63756D656E742E6E6F64655479706520213D3D203929207B0A2020202020202F2F204E6F742072756E6E696E6720696E20612062726F777365722C2070726F76696465206120666163746F';
wwv_flow_api.g_varchar2_table(155) := '72792066756E6374696F6E0A2020202020202F2F20736F207468617420796F752063616E207061737320796F7572206F776E2057696E646F770A202020202020444F4D5075726966792E6973537570706F72746564203D2066616C73653B0A0A20202020';
wwv_flow_api.g_varchar2_table(156) := '202072657475726E20444F4D5075726966793B0A202020207D0A0A20202020766172206F726967696E616C446F63756D656E74203D2077696E646F772E646F63756D656E743B0A0A2020202076617220646F63756D656E74203D2077696E646F772E646F';
wwv_flow_api.g_varchar2_table(157) := '63756D656E743B0A2020202076617220446F63756D656E74467261676D656E74203D2077696E646F772E446F63756D656E74467261676D656E742C0A202020202020202048544D4C54656D706C617465456C656D656E74203D2077696E646F772E48544D';
wwv_flow_api.g_varchar2_table(158) := '4C54656D706C617465456C656D656E742C0A20202020202020204E6F6465203D2077696E646F772E4E6F64652C0A2020202020202020456C656D656E74203D2077696E646F772E456C656D656E742C0A20202020202020204E6F646546696C746572203D';
wwv_flow_api.g_varchar2_table(159) := '2077696E646F772E4E6F646546696C7465722C0A20202020202020205F77696E646F77244E616D65644E6F64654D6170203D2077696E646F772E4E616D65644E6F64654D61702C0A20202020202020204E616D65644E6F64654D6170203D205F77696E64';
wwv_flow_api.g_varchar2_table(160) := '6F77244E616D65644E6F64654D6170203D3D3D20756E646566696E6564203F2077696E646F772E4E616D65644E6F64654D6170207C7C2077696E646F772E4D6F7A4E616D6564417474724D6170203A205F77696E646F77244E616D65644E6F64654D6170';
wwv_flow_api.g_varchar2_table(161) := '2C0A202020202020202054657874203D2077696E646F772E546578742C0A2020202020202020436F6D6D656E74203D2077696E646F772E436F6D6D656E742C0A2020202020202020444F4D506172736572203D2077696E646F772E444F4D506172736572';
wwv_flow_api.g_varchar2_table(162) := '2C0A2020202020202020747275737465645479706573203D2077696E646F772E7472757374656454797065733B0A0A0A2020202076617220456C656D656E7450726F746F74797065203D20456C656D656E742E70726F746F747970653B0A0A2020202076';
wwv_flow_api.g_varchar2_table(163) := '617220636C6F6E654E6F6465203D206C6F6F6B757047657474657228456C656D656E7450726F746F747970652C2027636C6F6E654E6F646527293B0A20202020766172206765744E6578745369626C696E67203D206C6F6F6B757047657474657228456C';
wwv_flow_api.g_varchar2_table(164) := '656D656E7450726F746F747970652C20276E6578745369626C696E6727293B0A20202020766172206765744368696C644E6F646573203D206C6F6F6B757047657474657228456C656D656E7450726F746F747970652C20276368696C644E6F6465732729';
wwv_flow_api.g_varchar2_table(165) := '3B0A2020202076617220676574506172656E744E6F6465203D206C6F6F6B757047657474657228456C656D656E7450726F746F747970652C2027706172656E744E6F646527293B0A0A202020202F2F20417320706572206973737565202334372C207468';
wwv_flow_api.g_varchar2_table(166) := '65207765622D636F6D706F6E656E747320726567697374727920697320696E6865726974656420627920610A202020202F2F206E657720646F63756D656E742063726561746564207669612063726561746548544D4C446F63756D656E742E2041732070';
wwv_flow_api.g_varchar2_table(167) := '65722074686520737065630A202020202F2F2028687474703A2F2F7733632E6769746875622E696F2F776562636F6D706F6E656E74732F737065632F637573746F6D2F236372656174696E672D616E642D70617373696E672D7265676973747269657329';
wwv_flow_api.g_varchar2_table(168) := '0A202020202F2F2061206E657720656D7074792072656769737472792069732075736564207768656E206372656174696E6720612074656D706C61746520636F6E74656E7473206F776E65720A202020202F2F20646F63756D656E742C20736F20776520';
wwv_flow_api.g_varchar2_table(169) := '7573652074686174206173206F757220706172656E7420646F63756D656E7420746F20656E73757265206E6F7468696E670A202020202F2F20697320696E686572697465642E0A2020202069662028747970656F662048544D4C54656D706C617465456C';
wwv_flow_api.g_varchar2_table(170) := '656D656E74203D3D3D202766756E6374696F6E2729207B0A2020202020207661722074656D706C617465203D20646F63756D656E742E637265617465456C656D656E74282774656D706C61746527293B0A2020202020206966202874656D706C6174652E';
wwv_flow_api.g_varchar2_table(171) := '636F6E74656E742026262074656D706C6174652E636F6E74656E742E6F776E6572446F63756D656E7429207B0A2020202020202020646F63756D656E74203D2074656D706C6174652E636F6E74656E742E6F776E6572446F63756D656E743B0A20202020';
wwv_flow_api.g_varchar2_table(172) := '20207D0A202020207D0A0A2020202076617220747275737465645479706573506F6C696379203D205F637265617465547275737465645479706573506F6C696379287472757374656454797065732C206F726967696E616C446F63756D656E74293B0A20';
wwv_flow_api.g_varchar2_table(173) := '20202076617220656D70747948544D4C203D20747275737465645479706573506F6C6963792026262052455455524E5F545255535445445F54595045203F20747275737465645479706573506F6C6963792E63726561746548544D4C28272729203A2027';
wwv_flow_api.g_varchar2_table(174) := '273B0A0A20202020766172205F646F63756D656E74203D20646F63756D656E742C0A2020202020202020696D706C656D656E746174696F6E203D205F646F63756D656E742E696D706C656D656E746174696F6E2C0A20202020202020206372656174654E';
wwv_flow_api.g_varchar2_table(175) := '6F64654974657261746F72203D205F646F63756D656E742E6372656174654E6F64654974657261746F722C0A2020202020202020637265617465446F63756D656E74467261676D656E74203D205F646F63756D656E742E637265617465446F63756D656E';
wwv_flow_api.g_varchar2_table(176) := '74467261676D656E743B0A2020202076617220696D706F72744E6F6465203D206F726967696E616C446F63756D656E742E696D706F72744E6F64653B0A0A0A2020202076617220646F63756D656E744D6F6465203D207B7D3B0A20202020747279207B0A';
wwv_flow_api.g_varchar2_table(177) := '202020202020646F63756D656E744D6F6465203D20636C6F6E6528646F63756D656E74292E646F63756D656E744D6F6465203F20646F63756D656E742E646F63756D656E744D6F6465203A207B7D3B0A202020207D20636174636820285F29207B7D0A0A';
wwv_flow_api.g_varchar2_table(178) := '2020202076617220686F6F6B73203D207B7D3B0A0A202020202F2A2A0A20202020202A204578706F7365207768657468657220746869732062726F7773657220737570706F7274732072756E6E696E67207468652066756C6C20444F4D5075726966792E';
wwv_flow_api.g_varchar2_table(179) := '0A20202020202A2F0A20202020444F4D5075726966792E6973537570706F72746564203D20747970656F6620676574506172656E744E6F6465203D3D3D202766756E6374696F6E2720262620696D706C656D656E746174696F6E20262620747970656F66';
wwv_flow_api.g_varchar2_table(180) := '20696D706C656D656E746174696F6E2E63726561746548544D4C446F63756D656E7420213D3D2027756E646566696E65642720262620646F63756D656E744D6F646520213D3D20393B0A0A20202020766172204D555354414348455F4558505224243120';
wwv_flow_api.g_varchar2_table(181) := '3D204D555354414348455F455850522C0A20202020202020204552425F45585052242431203D204552425F455850522C0A2020202020202020444154415F41545452242431203D20444154415F415454522C0A2020202020202020415249415F41545452';
wwv_flow_api.g_varchar2_table(182) := '242431203D20415249415F415454522C0A202020202020202049535F5343524950545F4F525F44415441242431203D2049535F5343524950545F4F525F444154412C0A2020202020202020415454525F57484954455350414345242431203D2041545452';
wwv_flow_api.g_varchar2_table(183) := '5F574849544553504143453B0A202020207661722049535F414C4C4F5745445F555249242431203D2049535F414C4C4F5745445F5552493B0A0A202020202F2A2A0A20202020202A20576520636F6E73696465722074686520656C656D656E747320616E';
wwv_flow_api.g_varchar2_table(184) := '6420617474726962757465732062656C6F7720746F20626520736166652E20496465616C6C790A20202020202A20646F6E27742061646420616E79206E6577206F6E657320627574206665656C206672656520746F2072656D6F766520756E77616E7465';
wwv_flow_api.g_varchar2_table(185) := '64206F6E65732E0A20202020202A2F0A0A202020202F2A20616C6C6F77656420656C656D656E74206E616D6573202A2F0A0A2020202076617220414C4C4F5745445F54414753203D206E756C6C3B0A202020207661722044454641554C545F414C4C4F57';
wwv_flow_api.g_varchar2_table(186) := '45445F54414753203D20616464546F536574287B7D2C205B5D2E636F6E636174285F746F436F6E73756D61626C65417272617924312868746D6C292C205F746F436F6E73756D61626C654172726179243128737667292C205F746F436F6E73756D61626C';
wwv_flow_api.g_varchar2_table(187) := '65417272617924312873766746696C74657273292C205F746F436F6E73756D61626C6541727261792431286D6174684D6C292C205F746F436F6E73756D61626C654172726179243128746578742929293B0A0A202020202F2A20416C6C6F776564206174';
wwv_flow_api.g_varchar2_table(188) := '74726962757465206E616D6573202A2F0A2020202076617220414C4C4F5745445F41545452203D206E756C6C3B0A202020207661722044454641554C545F414C4C4F5745445F41545452203D20616464546F536574287B7D2C205B5D2E636F6E63617428';
wwv_flow_api.g_varchar2_table(189) := '5F746F436F6E73756D61626C65417272617924312868746D6C2431292C205F746F436F6E73756D61626C6541727261792431287376672431292C205F746F436F6E73756D61626C6541727261792431286D6174684D6C2431292C205F746F436F6E73756D';
wwv_flow_api.g_varchar2_table(190) := '61626C654172726179243128786D6C2929293B0A0A202020202F2A204578706C696369746C7920666F7262696464656E207461677320286F766572726964657320414C4C4F5745445F544147532F4144445F5441475329202A2F0A202020207661722046';
wwv_flow_api.g_varchar2_table(191) := '4F524249445F54414753203D206E756C6C3B0A0A202020202F2A204578706C696369746C7920666F7262696464656E206174747269627574657320286F766572726964657320414C4C4F5745445F415454522F4144445F4154545229202A2F0A20202020';
wwv_flow_api.g_varchar2_table(192) := '76617220464F524249445F41545452203D206E756C6C3B0A0A202020202F2A204465636964652069662041524941206174747269627574657320617265206F6B6179202A2F0A2020202076617220414C4C4F575F415249415F41545452203D2074727565';
wwv_flow_api.g_varchar2_table(193) := '3B0A0A202020202F2A2044656369646520696620637573746F6D2064617461206174747269627574657320617265206F6B6179202A2F0A2020202076617220414C4C4F575F444154415F41545452203D20747275653B0A0A202020202F2A204465636964';
wwv_flow_api.g_varchar2_table(194) := '6520696620756E6B6E6F776E2070726F746F636F6C7320617265206F6B6179202A2F0A2020202076617220414C4C4F575F554E4B4E4F574E5F50524F544F434F4C53203D2066616C73653B0A0A202020202F2A204F75747075742073686F756C64206265';
wwv_flow_api.g_varchar2_table(195) := '207361666520666F7220636F6D6D6F6E2074656D706C61746520656E67696E65732E0A20202020202A2054686973206D65616E732C20444F4D5075726966792072656D6F766573206461746120617474726962757465732C206D75737461636865732061';
wwv_flow_api.g_varchar2_table(196) := '6E64204552420A20202020202A2F0A2020202076617220534146455F464F525F54454D504C41544553203D2066616C73653B0A0A202020202F2A2044656369646520696620646F63756D656E742077697468203C68746D6C3E2E2E2E2073686F756C6420';
wwv_flow_api.g_varchar2_table(197) := '62652072657475726E6564202A2F0A202020207661722057484F4C455F444F43554D454E54203D2066616C73653B0A0A202020202F2A20547261636B207768657468657220636F6E66696720697320616C726561647920736574206F6E20746869732069';
wwv_flow_api.g_varchar2_table(198) := '6E7374616E6365206F6620444F4D5075726966792E202A2F0A20202020766172205345545F434F4E464947203D2066616C73653B0A0A202020202F2A2044656369646520696620616C6C20656C656D656E74732028652E672E207374796C652C20736372';
wwv_flow_api.g_varchar2_table(199) := '69707429206D757374206265206368696C6472656E206F660A20202020202A20646F63756D656E742E626F64792E2042792064656661756C742C2062726F7773657273206D69676874206D6F7665207468656D20746F20646F63756D656E742E68656164';
wwv_flow_api.g_varchar2_table(200) := '202A2F0A2020202076617220464F5243455F424F4459203D2066616C73653B0A0A202020202F2A20446563696465206966206120444F4D206048544D4C426F6479456C656D656E74602073686F756C642062652072657475726E65642C20696E73746561';
wwv_flow_api.g_varchar2_table(201) := '64206F6620612068746D6C0A20202020202A20737472696E6720286F722061205472757374656448544D4C206F626A65637420696620547275737465642054797065732061726520737570706F72746564292E0A20202020202A204966206057484F4C45';
wwv_flow_api.g_varchar2_table(202) := '5F444F43554D454E546020697320656E61626C65642061206048544D4C48746D6C456C656D656E74602077696C6C2062652072657475726E656420696E73746561640A20202020202A2F0A202020207661722052455455524E5F444F4D203D2066616C73';
wwv_flow_api.g_varchar2_table(203) := '653B0A0A202020202F2A20446563696465206966206120444F4D2060446F63756D656E74467261676D656E74602073686F756C642062652072657475726E65642C20696E7374656164206F6620612068746D6C0A20202020202A20737472696E67202028';
wwv_flow_api.g_varchar2_table(204) := '6F722061205472757374656448544D4C206F626A65637420696620547275737465642054797065732061726520737570706F7274656429202A2F0A202020207661722052455455524E5F444F4D5F465241474D454E54203D2066616C73653B0A0A202020';
wwv_flow_api.g_varchar2_table(205) := '202F2A204966206052455455524E5F444F4D60206F72206052455455524E5F444F4D5F465241474D454E546020697320656E61626C65642C20646563696465206966207468652072657475726E656420444F4D0A20202020202A20604E6F646560206973';
wwv_flow_api.g_varchar2_table(206) := '20696D706F7274656420696E746F207468652063757272656E742060446F63756D656E74602E204966207468697320666C6167206973206E6F7420656E61626C6564207468650A20202020202A20604E6F6465602077696C6C2062656C6F6E6720286974';
wwv_flow_api.g_varchar2_table(207) := '73206F776E6572446F63756D656E742920746F2061206672657368206048544D4C446F63756D656E74602C20637265617465642062790A20202020202A20444F4D5075726966792E0A20202020202A0A20202020202A20546869732064656661756C7473';
wwv_flow_api.g_varchar2_table(208) := '20746F20607472756560207374617274696E6720444F4D50757269667920322E322E302E204E6F746520746861742073657474696E6720697420746F206066616C7365600A20202020202A206D69676874206361757365205853532066726F6D20617474';
wwv_flow_api.g_varchar2_table(209) := '61636B732068696464656E20696E20636C6F73656420736861646F77726F6F747320696E2063617365207468652062726F777365720A20202020202A20737570706F727473204465636C6172617469766520536861646F773A20444F4D2068747470733A';
wwv_flow_api.g_varchar2_table(210) := '2F2F7765622E6465762F6465636C617261746976652D736861646F772D646F6D2F0A20202020202A2F0A202020207661722052455455524E5F444F4D5F494D504F5254203D20747275653B0A0A202020202F2A2054727920746F2072657475726E206120';
wwv_flow_api.g_varchar2_table(211) := '547275737465642054797065206F626A65637420696E7374656164206F66206120737472696E672C2072657475726E206120737472696E6720696E0A20202020202A2063617365205472757374656420547970657320617265206E6F7420737570706F72';
wwv_flow_api.g_varchar2_table(212) := '74656420202A2F0A202020207661722052455455524E5F545255535445445F54595045203D2066616C73653B0A0A202020202F2A204F75747075742073686F756C6420626520667265652066726F6D20444F4D20636C6F62626572696E67206174746163';
wwv_flow_api.g_varchar2_table(213) := '6B733F202A2F0A202020207661722053414E4954495A455F444F4D203D20747275653B0A0A202020202F2A204B65657020656C656D656E7420636F6E74656E74207768656E2072656D6F76696E6720656C656D656E743F202A2F0A20202020766172204B';
wwv_flow_api.g_varchar2_table(214) := '4545505F434F4E54454E54203D20747275653B0A0A202020202F2A204966206120604E6F6465602069732070617373656420746F2073616E6974697A6528292C207468656E20706572666F726D732073616E6974697A6174696F6E20696E2D706C616365';
wwv_flow_api.g_varchar2_table(215) := '20696E73746561640A20202020202A206F6620696D706F7274696E6720697420696E746F2061206E657720446F63756D656E7420616E642072657475726E696E6720612073616E6974697A656420636F7079202A2F0A2020202076617220494E5F504C41';
wwv_flow_api.g_varchar2_table(216) := '4345203D2066616C73653B0A0A202020202F2A20416C6C6F77207573616765206F662070726F66696C6573206C696B652068746D6C2C2073766720616E64206D6174684D6C202A2F0A20202020766172205553455F50524F46494C4553203D207B7D3B0A';
wwv_flow_api.g_varchar2_table(217) := '0A202020202F2A205461677320746F2069676E6F726520636F6E74656E74206F66207768656E204B4545505F434F4E54454E542069732074727565202A2F0A2020202076617220464F524249445F434F4E54454E5453203D20616464546F536574287B7D';
wwv_flow_api.g_varchar2_table(218) := '2C205B27616E6E6F746174696F6E2D786D6C272C2027617564696F272C2027636F6C67726F7570272C202764657363272C2027666F726569676E6F626A656374272C202768656164272C2027696672616D65272C20276D617468272C20276D69272C2027';
wwv_flow_api.g_varchar2_table(219) := '6D6E272C20276D6F272C20276D73272C20276D74657874272C20276E6F656D626564272C20276E6F6672616D6573272C20276E6F736372697074272C2027706C61696E74657874272C2027736372697074272C20277374796C65272C2027737667272C20';
wwv_flow_api.g_varchar2_table(220) := '2774656D706C617465272C20277468656164272C20277469746C65272C2027766964656F272C2027786D70275D293B0A0A202020202F2A2054616773207468617420617265207361666520666F7220646174613A2055524973202A2F0A20202020766172';
wwv_flow_api.g_varchar2_table(221) := '20444154415F5552495F54414753203D206E756C6C3B0A202020207661722044454641554C545F444154415F5552495F54414753203D20616464546F536574287B7D2C205B27617564696F272C2027766964656F272C2027696D67272C2027736F757263';
wwv_flow_api.g_varchar2_table(222) := '65272C2027696D616765272C2027747261636B275D293B0A0A202020202F2A2041747472696275746573207361666520666F722076616C756573206C696B6520226A6176617363726970743A22202A2F0A20202020766172205552495F534146455F4154';
wwv_flow_api.g_varchar2_table(223) := '5452494255544553203D206E756C6C3B0A202020207661722044454641554C545F5552495F534146455F41545452494255544553203D20616464546F536574287B7D2C205B27616C74272C2027636C617373272C2027666F72272C20276964272C20276C';
wwv_flow_api.g_varchar2_table(224) := '6162656C272C20276E616D65272C20277061747465726E272C2027706C616365686F6C646572272C202773756D6D617279272C20277469746C65272C202776616C7565272C20277374796C65272C2027786D6C6E73275D293B0A0A20202020766172204D';
wwv_flow_api.g_varchar2_table(225) := '4154484D4C5F4E414D455350414345203D2027687474703A2F2F7777772E77332E6F72672F313939382F4D6174682F4D6174684D4C273B0A20202020766172205356475F4E414D455350414345203D2027687474703A2F2F7777772E77332E6F72672F32';
wwv_flow_api.g_varchar2_table(226) := '3030302F737667273B0A202020207661722048544D4C5F4E414D455350414345203D2027687474703A2F2F7777772E77332E6F72672F313939392F7868746D6C273B0A202020202F2A20446F63756D656E74206E616D657370616365202A2F0A20202020';
wwv_flow_api.g_varchar2_table(227) := '766172204E414D455350414345203D2048544D4C5F4E414D4553504143453B0A202020207661722049535F454D5054595F494E505554203D2066616C73653B0A0A202020202F2A204B6565702061207265666572656E636520746F20636F6E6669672074';
wwv_flow_api.g_varchar2_table(228) := '6F207061737320746F20686F6F6B73202A2F0A2020202076617220434F4E464947203D206E756C6C3B0A0A202020202F2A20496465616C6C792C20646F206E6F7420746F75636820616E797468696E672062656C6F772074686973206C696E65202A2F0A';
wwv_flow_api.g_varchar2_table(229) := '202020202F2A205F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F202A2F0A0A2020202076617220666F726D456C656D656E74203D20646F63756D656E742E637265617465456C656D65';
wwv_flow_api.g_varchar2_table(230) := '6E742827666F726D27293B0A0A202020202F2A2A0A20202020202A205F7061727365436F6E6669670A20202020202A0A20202020202A2040706172616D20207B4F626A6563747D20636667206F7074696F6E616C20636F6E666967206C69746572616C0A';
wwv_flow_api.g_varchar2_table(231) := '20202020202A2F0A202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520636F6D706C65786974790A20202020766172205F7061727365436F6E666967203D2066756E6374696F6E205F7061727365436F6E6669672863666729';
wwv_flow_api.g_varchar2_table(232) := '207B0A20202020202069662028434F4E46494720262620434F4E464947203D3D3D2063666729207B0A202020202020202072657475726E3B0A2020202020207D0A0A2020202020202F2A20536869656C6420636F6E66696775726174696F6E206F626A65';
wwv_flow_api.g_varchar2_table(233) := '63742066726F6D2074616D706572696E67202A2F0A2020202020206966202821636667207C7C2028747970656F6620636667203D3D3D2027756E646566696E656427203F2027756E646566696E656427203A205F747970656F6628636667292920213D3D';
wwv_flow_api.g_varchar2_table(234) := '20276F626A6563742729207B0A2020202020202020636667203D207B7D3B0A2020202020207D0A0A2020202020202F2A20536869656C6420636F6E66696775726174696F6E206F626A6563742066726F6D2070726F746F7479706520706F6C6C7574696F';
wwv_flow_api.g_varchar2_table(235) := '6E202A2F0A202020202020636667203D20636C6F6E6528636667293B0A0A2020202020202F2A2053657420636F6E66696775726174696F6E20706172616D6574657273202A2F0A202020202020414C4C4F5745445F54414753203D2027414C4C4F574544';
wwv_flow_api.g_varchar2_table(236) := '5F544147532720696E20636667203F20616464546F536574287B7D2C206366672E414C4C4F5745445F5441475329203A2044454641554C545F414C4C4F5745445F544147533B0A202020202020414C4C4F5745445F41545452203D2027414C4C4F574544';
wwv_flow_api.g_varchar2_table(237) := '5F415454522720696E20636667203F20616464546F536574287B7D2C206366672E414C4C4F5745445F4154545229203A2044454641554C545F414C4C4F5745445F415454523B0A2020202020205552495F534146455F41545452494255544553203D2027';
wwv_flow_api.g_varchar2_table(238) := '4144445F5552495F534146455F415454522720696E20636667203F20616464546F53657428636C6F6E652844454641554C545F5552495F534146455F41545452494255544553292C206366672E4144445F5552495F534146455F4154545229203A204445';
wwv_flow_api.g_varchar2_table(239) := '4641554C545F5552495F534146455F415454524942555445533B0A202020202020444154415F5552495F54414753203D20274144445F444154415F5552495F544147532720696E20636667203F20616464546F53657428636C6F6E652844454641554C54';
wwv_flow_api.g_varchar2_table(240) := '5F444154415F5552495F54414753292C206366672E4144445F444154415F5552495F5441475329203A2044454641554C545F444154415F5552495F544147533B0A202020202020464F524249445F54414753203D2027464F524249445F54414753272069';
wwv_flow_api.g_varchar2_table(241) := '6E20636667203F20616464546F536574287B7D2C206366672E464F524249445F5441475329203A207B7D3B0A202020202020464F524249445F41545452203D2027464F524249445F415454522720696E20636667203F20616464546F536574287B7D2C20';
wwv_flow_api.g_varchar2_table(242) := '6366672E464F524249445F4154545229203A207B7D3B0A2020202020205553455F50524F46494C4553203D20275553455F50524F46494C45532720696E20636667203F206366672E5553455F50524F46494C4553203A2066616C73653B0A202020202020';
wwv_flow_api.g_varchar2_table(243) := '414C4C4F575F415249415F41545452203D206366672E414C4C4F575F415249415F4154545220213D3D2066616C73653B202F2F2044656661756C7420747275650A202020202020414C4C4F575F444154415F41545452203D206366672E414C4C4F575F44';
wwv_flow_api.g_varchar2_table(244) := '4154415F4154545220213D3D2066616C73653B202F2F2044656661756C7420747275650A202020202020414C4C4F575F554E4B4E4F574E5F50524F544F434F4C53203D206366672E414C4C4F575F554E4B4E4F574E5F50524F544F434F4C53207C7C2066';
wwv_flow_api.g_varchar2_table(245) := '616C73653B202F2F2044656661756C742066616C73650A202020202020534146455F464F525F54454D504C41544553203D206366672E534146455F464F525F54454D504C41544553207C7C2066616C73653B202F2F2044656661756C742066616C73650A';
wwv_flow_api.g_varchar2_table(246) := '20202020202057484F4C455F444F43554D454E54203D206366672E57484F4C455F444F43554D454E54207C7C2066616C73653B202F2F2044656661756C742066616C73650A20202020202052455455524E5F444F4D203D206366672E52455455524E5F44';
wwv_flow_api.g_varchar2_table(247) := '4F4D207C7C2066616C73653B202F2F2044656661756C742066616C73650A20202020202052455455524E5F444F4D5F465241474D454E54203D206366672E52455455524E5F444F4D5F465241474D454E54207C7C2066616C73653B202F2F204465666175';
wwv_flow_api.g_varchar2_table(248) := '6C742066616C73650A20202020202052455455524E5F444F4D5F494D504F5254203D206366672E52455455524E5F444F4D5F494D504F525420213D3D2066616C73653B202F2F2044656661756C7420747275650A20202020202052455455524E5F545255';
wwv_flow_api.g_varchar2_table(249) := '535445445F54595045203D206366672E52455455524E5F545255535445445F54595045207C7C2066616C73653B202F2F2044656661756C742066616C73650A202020202020464F5243455F424F4459203D206366672E464F5243455F424F4459207C7C20';
wwv_flow_api.g_varchar2_table(250) := '66616C73653B202F2F2044656661756C742066616C73650A20202020202053414E4954495A455F444F4D203D206366672E53414E4954495A455F444F4D20213D3D2066616C73653B202F2F2044656661756C7420747275650A2020202020204B4545505F';
wwv_flow_api.g_varchar2_table(251) := '434F4E54454E54203D206366672E4B4545505F434F4E54454E5420213D3D2066616C73653B202F2F2044656661756C7420747275650A202020202020494E5F504C414345203D206366672E494E5F504C414345207C7C2066616C73653B202F2F20446566';
wwv_flow_api.g_varchar2_table(252) := '61756C742066616C73650A20202020202049535F414C4C4F5745445F555249242431203D206366672E414C4C4F5745445F5552495F524547455850207C7C2049535F414C4C4F5745445F5552492424313B0A2020202020204E414D455350414345203D20';
wwv_flow_api.g_varchar2_table(253) := '6366672E4E414D455350414345207C7C2048544D4C5F4E414D4553504143453B0A20202020202069662028534146455F464F525F54454D504C4154455329207B0A2020202020202020414C4C4F575F444154415F41545452203D2066616C73653B0A2020';
wwv_flow_api.g_varchar2_table(254) := '202020207D0A0A2020202020206966202852455455524E5F444F4D5F465241474D454E5429207B0A202020202020202052455455524E5F444F4D203D20747275653B0A2020202020207D0A0A2020202020202F2A2050617273652070726F66696C652069';
wwv_flow_api.g_varchar2_table(255) := '6E666F202A2F0A202020202020696620285553455F50524F46494C455329207B0A2020202020202020414C4C4F5745445F54414753203D20616464546F536574287B7D2C205B5D2E636F6E636174285F746F436F6E73756D61626C654172726179243128';
wwv_flow_api.g_varchar2_table(256) := '746578742929293B0A2020202020202020414C4C4F5745445F41545452203D205B5D3B0A2020202020202020696620285553455F50524F46494C45532E68746D6C203D3D3D207472756529207B0A20202020202020202020616464546F53657428414C4C';
wwv_flow_api.g_varchar2_table(257) := '4F5745445F544147532C2068746D6C293B0A20202020202020202020616464546F53657428414C4C4F5745445F415454522C2068746D6C2431293B0A20202020202020207D0A0A2020202020202020696620285553455F50524F46494C45532E73766720';
wwv_flow_api.g_varchar2_table(258) := '3D3D3D207472756529207B0A20202020202020202020616464546F53657428414C4C4F5745445F544147532C20737667293B0A20202020202020202020616464546F53657428414C4C4F5745445F415454522C207376672431293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(259) := '2020616464546F53657428414C4C4F5745445F415454522C20786D6C293B0A20202020202020207D0A0A2020202020202020696620285553455F50524F46494C45532E73766746696C74657273203D3D3D207472756529207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(260) := '616464546F53657428414C4C4F5745445F544147532C2073766746696C74657273293B0A20202020202020202020616464546F53657428414C4C4F5745445F415454522C207376672431293B0A20202020202020202020616464546F53657428414C4C4F';
wwv_flow_api.g_varchar2_table(261) := '5745445F415454522C20786D6C293B0A20202020202020207D0A0A2020202020202020696620285553455F50524F46494C45532E6D6174684D6C203D3D3D207472756529207B0A20202020202020202020616464546F53657428414C4C4F5745445F5441';
wwv_flow_api.g_varchar2_table(262) := '47532C206D6174684D6C293B0A20202020202020202020616464546F53657428414C4C4F5745445F415454522C206D6174684D6C2431293B0A20202020202020202020616464546F53657428414C4C4F5745445F415454522C20786D6C293B0A20202020';
wwv_flow_api.g_varchar2_table(263) := '202020207D0A2020202020207D0A0A2020202020202F2A204D6572676520636F6E66696775726174696F6E20706172616D6574657273202A2F0A202020202020696620286366672E4144445F5441475329207B0A202020202020202069662028414C4C4F';
wwv_flow_api.g_varchar2_table(264) := '5745445F54414753203D3D3D2044454641554C545F414C4C4F5745445F5441475329207B0A20202020202020202020414C4C4F5745445F54414753203D20636C6F6E6528414C4C4F5745445F54414753293B0A20202020202020207D0A0A202020202020';
wwv_flow_api.g_varchar2_table(265) := '2020616464546F53657428414C4C4F5745445F544147532C206366672E4144445F54414753293B0A2020202020207D0A0A202020202020696620286366672E4144445F4154545229207B0A202020202020202069662028414C4C4F5745445F4154545220';
wwv_flow_api.g_varchar2_table(266) := '3D3D3D2044454641554C545F414C4C4F5745445F4154545229207B0A20202020202020202020414C4C4F5745445F41545452203D20636C6F6E6528414C4C4F5745445F41545452293B0A20202020202020207D0A0A2020202020202020616464546F5365';
wwv_flow_api.g_varchar2_table(267) := '7428414C4C4F5745445F415454522C206366672E4144445F41545452293B0A2020202020207D0A0A202020202020696620286366672E4144445F5552495F534146455F4154545229207B0A2020202020202020616464546F536574285552495F53414645';
wwv_flow_api.g_varchar2_table(268) := '5F415454524942555445532C206366672E4144445F5552495F534146455F41545452293B0A2020202020207D0A0A2020202020202F2A2041646420237465787420696E2063617365204B4545505F434F4E54454E542069732073657420746F2074727565';
wwv_flow_api.g_varchar2_table(269) := '202A2F0A202020202020696620284B4545505F434F4E54454E5429207B0A2020202020202020414C4C4F5745445F544147535B272374657874275D203D20747275653B0A2020202020207D0A0A2020202020202F2A204164642068746D6C2C2068656164';
wwv_flow_api.g_varchar2_table(270) := '20616E6420626F647920746F20414C4C4F5745445F5441475320696E20636173652057484F4C455F444F43554D454E542069732074727565202A2F0A2020202020206966202857484F4C455F444F43554D454E5429207B0A202020202020202061646454';
wwv_flow_api.g_varchar2_table(271) := '6F53657428414C4C4F5745445F544147532C205B2768746D6C272C202768656164272C2027626F6479275D293B0A2020202020207D0A0A2020202020202F2A204164642074626F647920746F20414C4C4F5745445F5441475320696E2063617365207461';
wwv_flow_api.g_varchar2_table(272) := '626C657320617265207065726D69747465642C2073656520233238362C2023333635202A2F0A20202020202069662028414C4C4F5745445F544147532E7461626C6529207B0A2020202020202020616464546F53657428414C4C4F5745445F544147532C';
wwv_flow_api.g_varchar2_table(273) := '205B2774626F6479275D293B0A202020202020202064656C65746520464F524249445F544147532E74626F64793B0A2020202020207D0A0A2020202020202F2F2050726576656E742066757274686572206D616E6970756C6174696F6E206F6620636F6E';
wwv_flow_api.g_varchar2_table(274) := '66696775726174696F6E2E0A2020202020202F2F204E6F7420617661696C61626C6520696E204945382C2053616661726920352C206574632E0A20202020202069662028667265657A6529207B0A2020202020202020667265657A6528636667293B0A20';
wwv_flow_api.g_varchar2_table(275) := '20202020207D0A0A202020202020434F4E464947203D206366673B0A202020207D3B0A0A20202020766172204D4154484D4C5F544558545F494E544547524154494F4E5F504F494E5453203D20616464546F536574287B7D2C205B276D69272C20276D6F';
wwv_flow_api.g_varchar2_table(276) := '272C20276D6E272C20276D73272C20276D74657874275D293B0A0A202020207661722048544D4C5F494E544547524154494F4E5F504F494E5453203D20616464546F536574287B7D2C205B27666F726569676E6F626A656374272C202764657363272C20';
wwv_flow_api.g_varchar2_table(277) := '277469746C65272C2027616E6E6F746174696F6E2D786D6C275D293B0A0A202020202F2A204B65657020747261636B206F6620616C6C20706F737369626C652053564720616E64204D6174684D4C20746167730A20202020202A20736F20746861742077';
wwv_flow_api.g_varchar2_table(278) := '652063616E20706572666F726D20746865206E616D65737061636520636865636B730A20202020202A20636F72726563746C792E202A2F0A2020202076617220414C4C5F5356475F54414753203D20616464546F536574287B7D2C20737667293B0A2020';
wwv_flow_api.g_varchar2_table(279) := '2020616464546F53657428414C4C5F5356475F544147532C2073766746696C74657273293B0A20202020616464546F53657428414C4C5F5356475F544147532C20737667446973616C6C6F776564293B0A0A2020202076617220414C4C5F4D4154484D4C';
wwv_flow_api.g_varchar2_table(280) := '5F54414753203D20616464546F536574287B7D2C206D6174684D6C293B0A20202020616464546F53657428414C4C5F4D4154484D4C5F544147532C206D6174684D6C446973616C6C6F776564293B0A0A202020202F2A2A0A20202020202A0A2020202020';
wwv_flow_api.g_varchar2_table(281) := '2A0A20202020202A2040706172616D20207B456C656D656E747D20656C656D656E74206120444F4D20656C656D656E742077686F7365206E616D657370616365206973206265696E6720636865636B65640A20202020202A204072657475726E73207B62';
wwv_flow_api.g_varchar2_table(282) := '6F6F6C65616E7D2052657475726E2066616C73652069662074686520656C656D656E742068617320610A20202020202A20206E616D6573706163652074686174206120737065632D636F6D706C69616E742070617273657220776F756C64206E65766572';
wwv_flow_api.g_varchar2_table(283) := '0A20202020202A202072657475726E2E2052657475726E2074727565206F74686572776973652E0A20202020202A2F0A20202020766172205F636865636B56616C69644E616D657370616365203D2066756E6374696F6E205F636865636B56616C69644E';
wwv_flow_api.g_varchar2_table(284) := '616D65737061636528656C656D656E7429207B0A20202020202076617220706172656E74203D20676574506172656E744E6F646528656C656D656E74293B0A0A2020202020202F2F20496E204A53444F4D2C20696620776527726520696E736964652073';
wwv_flow_api.g_varchar2_table(285) := '6861646F7720444F4D2C207468656E20706172656E744E6F64650A2020202020202F2F2063616E206265206E756C6C2E205765206A7573742073696D756C61746520706172656E7420696E207468697320636173652E0A20202020202069662028217061';
wwv_flow_api.g_varchar2_table(286) := '72656E74207C7C2021706172656E742E7461674E616D6529207B0A2020202020202020706172656E74203D207B0A202020202020202020206E616D6573706163655552493A2048544D4C5F4E414D4553504143452C0A202020202020202020207461674E';
wwv_flow_api.g_varchar2_table(287) := '616D653A202774656D706C617465270A20202020202020207D3B0A2020202020207D0A0A202020202020766172207461674E616D65203D20737472696E67546F4C6F7765724361736528656C656D656E742E7461674E616D65293B0A2020202020207661';
wwv_flow_api.g_varchar2_table(288) := '7220706172656E745461674E616D65203D20737472696E67546F4C6F7765724361736528706172656E742E7461674E616D65293B0A0A20202020202069662028656C656D656E742E6E616D657370616365555249203D3D3D205356475F4E414D45535041';
wwv_flow_api.g_varchar2_table(289) := '434529207B0A20202020202020202F2F20546865206F6E6C792077617920746F207377697463682066726F6D2048544D4C206E616D65737061636520746F205356470A20202020202020202F2F20697320766961203C7376673E2E204966206974206861';
wwv_flow_api.g_varchar2_table(290) := '7070656E732076696120616E79206F74686572207461672C207468656E0A20202020202020202F2F2069742073686F756C64206265206B696C6C65642E0A202020202020202069662028706172656E742E6E616D657370616365555249203D3D3D204854';
wwv_flow_api.g_varchar2_table(291) := '4D4C5F4E414D45535041434529207B0A2020202020202020202072657475726E207461674E616D65203D3D3D2027737667273B0A20202020202020207D0A0A20202020202020202F2F20546865206F6E6C792077617920746F207377697463682066726F';
wwv_flow_api.g_varchar2_table(292) := '6D204D6174684D4C20746F20535647206973207669610A20202020202020202F2F2073766720696620706172656E7420697320656974686572203C616E6E6F746174696F6E2D786D6C3E206F72204D6174684D4C0A20202020202020202F2F2074657874';
wwv_flow_api.g_varchar2_table(293) := '20696E746567726174696F6E20706F696E74732E0A202020202020202069662028706172656E742E6E616D657370616365555249203D3D3D204D4154484D4C5F4E414D45535041434529207B0A2020202020202020202072657475726E207461674E616D';
wwv_flow_api.g_varchar2_table(294) := '65203D3D3D2027737667272026262028706172656E745461674E616D65203D3D3D2027616E6E6F746174696F6E2D786D6C27207C7C204D4154484D4C5F544558545F494E544547524154494F4E5F504F494E54535B706172656E745461674E616D655D29';
wwv_flow_api.g_varchar2_table(295) := '3B0A20202020202020207D0A0A20202020202020202F2F205765206F6E6C7920616C6C6F7720656C656D656E747320746861742061726520646566696E656420696E205356470A20202020202020202F2F20737065632E20416C6C206F74686572732061';
wwv_flow_api.g_varchar2_table(296) := '726520646973616C6C6F77656420696E20535647206E616D6573706163652E0A202020202020202072657475726E20426F6F6C65616E28414C4C5F5356475F544147535B7461674E616D655D293B0A2020202020207D0A0A20202020202069662028656C';
wwv_flow_api.g_varchar2_table(297) := '656D656E742E6E616D657370616365555249203D3D3D204D4154484D4C5F4E414D45535041434529207B0A20202020202020202F2F20546865206F6E6C792077617920746F207377697463682066726F6D2048544D4C206E616D65737061636520746F20';
wwv_flow_api.g_varchar2_table(298) := '4D6174684D4C0A20202020202020202F2F20697320766961203C6D6174683E2E2049662069742068617070656E732076696120616E79206F74686572207461672C207468656E0A20202020202020202F2F2069742073686F756C64206265206B696C6C65';
wwv_flow_api.g_varchar2_table(299) := '642E0A202020202020202069662028706172656E742E6E616D657370616365555249203D3D3D2048544D4C5F4E414D45535041434529207B0A2020202020202020202072657475726E207461674E616D65203D3D3D20276D617468273B0A202020202020';
wwv_flow_api.g_varchar2_table(300) := '20207D0A0A20202020202020202F2F20546865206F6E6C792077617920746F207377697463682066726F6D2053564720746F204D6174684D4C206973207669610A20202020202020202F2F203C6D6174683E20616E642048544D4C20696E746567726174';
wwv_flow_api.g_varchar2_table(301) := '696F6E20706F696E74730A202020202020202069662028706172656E742E6E616D657370616365555249203D3D3D205356475F4E414D45535041434529207B0A2020202020202020202072657475726E207461674E616D65203D3D3D20276D6174682720';
wwv_flow_api.g_varchar2_table(302) := '26262048544D4C5F494E544547524154494F4E5F504F494E54535B706172656E745461674E616D655D3B0A20202020202020207D0A0A20202020202020202F2F205765206F6E6C7920616C6C6F7720656C656D656E747320746861742061726520646566';
wwv_flow_api.g_varchar2_table(303) := '696E656420696E204D6174684D4C0A20202020202020202F2F20737065632E20416C6C206F74686572732061726520646973616C6C6F77656420696E204D6174684D4C206E616D6573706163652E0A202020202020202072657475726E20426F6F6C6561';
wwv_flow_api.g_varchar2_table(304) := '6E28414C4C5F4D4154484D4C5F544147535B7461674E616D655D293B0A2020202020207D0A0A20202020202069662028656C656D656E742E6E616D657370616365555249203D3D3D2048544D4C5F4E414D45535041434529207B0A20202020202020202F';
wwv_flow_api.g_varchar2_table(305) := '2F20546865206F6E6C792077617920746F207377697463682066726F6D2053564720746F2048544D4C206973207669610A20202020202020202F2F2048544D4C20696E746567726174696F6E20706F696E74732C20616E642066726F6D204D6174684D4C';
wwv_flow_api.g_varchar2_table(306) := '20746F2048544D4C0A20202020202020202F2F20697320766961204D6174684D4C207465787420696E746567726174696F6E20706F696E74730A202020202020202069662028706172656E742E6E616D657370616365555249203D3D3D205356475F4E41';
wwv_flow_api.g_varchar2_table(307) := '4D455350414345202626202148544D4C5F494E544547524154494F4E5F504F494E54535B706172656E745461674E616D655D29207B0A2020202020202020202072657475726E2066616C73653B0A20202020202020207D0A0A2020202020202020696620';
wwv_flow_api.g_varchar2_table(308) := '28706172656E742E6E616D657370616365555249203D3D3D204D4154484D4C5F4E414D45535041434520262620214D4154484D4C5F544558545F494E544547524154494F4E5F504F494E54535B706172656E745461674E616D655D29207B0A2020202020';
wwv_flow_api.g_varchar2_table(309) := '202020202072657475726E2066616C73653B0A20202020202020207D0A0A20202020202020202F2F204365727461696E20656C656D656E74732061726520616C6C6F77656420696E20626F74682053564720616E642048544D4C0A20202020202020202F';
wwv_flow_api.g_varchar2_table(310) := '2F206E616D6573706163652E205765206E65656420746F2073706563696679207468656D206578706C696369746C790A20202020202020202F2F20736F2074686174207468657920646F6E277420676574206572726F6E6F75736C792064656C65746564';
wwv_flow_api.g_varchar2_table(311) := '2066726F6D0A20202020202020202F2F2048544D4C206E616D6573706163652E0A202020202020202076617220636F6D6D6F6E537667416E6448544D4C456C656D656E7473203D20616464546F536574287B7D2C205B277469746C65272C20277374796C';
wwv_flow_api.g_varchar2_table(312) := '65272C2027666F6E74272C202761272C2027736372697074275D293B0A0A20202020202020202F2F20576520646973616C6C6F77207461677320746861742061726520737065636966696320666F72204D6174684D4C0A20202020202020202F2F206F72';
wwv_flow_api.g_varchar2_table(313) := '2053564720616E642073686F756C64206E657665722061707065617220696E2048544D4C206E616D6573706163650A202020202020202072657475726E2021414C4C5F4D4154484D4C5F544147535B7461674E616D655D2026262028636F6D6D6F6E5376';
wwv_flow_api.g_varchar2_table(314) := '67416E6448544D4C456C656D656E74735B7461674E616D655D207C7C2021414C4C5F5356475F544147535B7461674E616D655D293B0A2020202020207D0A0A2020202020202F2F2054686520636F64652073686F756C64206E6576657220726561636820';
wwv_flow_api.g_varchar2_table(315) := '7468697320706C616365202874686973206D65616E730A2020202020202F2F20746861742074686520656C656D656E7420736F6D65686F7720676F74206E616D6573706163652074686174206973206E6F740A2020202020202F2F2048544D4C2C205356';
wwv_flow_api.g_varchar2_table(316) := '47206F72204D6174684D4C292E2052657475726E2066616C7365206A75737420696E20636173652E0A20202020202072657475726E2066616C73653B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F666F72636552656D6F76650A202020';
wwv_flow_api.g_varchar2_table(317) := '20202A0A20202020202A2040706172616D20207B4E6F64657D206E6F6465206120444F4D206E6F64650A20202020202A2F0A20202020766172205F666F72636552656D6F7665203D2066756E6374696F6E205F666F72636552656D6F7665286E6F646529';
wwv_flow_api.g_varchar2_table(318) := '207B0A20202020202061727261795075736828444F4D5075726966792E72656D6F7665642C207B20656C656D656E743A206E6F6465207D293B0A202020202020747279207B0A20202020202020202F2F2065736C696E742D64697361626C652D6E657874';
wwv_flow_api.g_varchar2_table(319) := '2D6C696E6520756E69636F726E2F7072656665722D646F6D2D6E6F64652D72656D6F76650A20202020202020206E6F64652E706172656E744E6F64652E72656D6F76654368696C64286E6F6465293B0A2020202020207D20636174636820285F29207B0A';
wwv_flow_api.g_varchar2_table(320) := '2020202020202020747279207B0A202020202020202020206E6F64652E6F7574657248544D4C203D20656D70747948544D4C3B0A20202020202020207D20636174636820285F29207B0A202020202020202020206E6F64652E72656D6F766528293B0A20';
wwv_flow_api.g_varchar2_table(321) := '202020202020207D0A2020202020207D0A202020207D3B0A0A202020202F2A2A0A20202020202A205F72656D6F76654174747269627574650A20202020202A0A20202020202A2040706172616D20207B537472696E677D206E616D6520616E2041747472';
wwv_flow_api.g_varchar2_table(322) := '6962757465206E616D650A20202020202A2040706172616D20207B4E6F64657D206E6F6465206120444F4D206E6F64650A20202020202A2F0A20202020766172205F72656D6F7665417474726962757465203D2066756E6374696F6E205F72656D6F7665';
wwv_flow_api.g_varchar2_table(323) := '417474726962757465286E616D652C206E6F646529207B0A202020202020747279207B0A202020202020202061727261795075736828444F4D5075726966792E72656D6F7665642C207B0A202020202020202020206174747269627574653A206E6F6465';
wwv_flow_api.g_varchar2_table(324) := '2E6765744174747269627574654E6F6465286E616D65292C0A2020202020202020202066726F6D3A206E6F64650A20202020202020207D293B0A2020202020207D20636174636820285F29207B0A202020202020202061727261795075736828444F4D50';
wwv_flow_api.g_varchar2_table(325) := '75726966792E72656D6F7665642C207B0A202020202020202020206174747269627574653A206E756C6C2C0A2020202020202020202066726F6D3A206E6F64650A20202020202020207D293B0A2020202020207D0A0A2020202020206E6F64652E72656D';
wwv_flow_api.g_varchar2_table(326) := '6F7665417474726962757465286E616D65293B0A0A2020202020202F2F20576520766F6964206174747269627574652076616C75657320666F7220756E72656D6F7661626C6520226973222220617474726962757465730A202020202020696620286E61';
wwv_flow_api.g_varchar2_table(327) := '6D65203D3D3D20276973272026262021414C4C4F5745445F415454525B6E616D655D29207B0A20202020202020206966202852455455524E5F444F4D207C7C2052455455524E5F444F4D5F465241474D454E5429207B0A20202020202020202020747279';
wwv_flow_api.g_varchar2_table(328) := '207B0A2020202020202020202020205F666F72636552656D6F7665286E6F6465293B0A202020202020202020207D20636174636820285F29207B7D0A20202020202020207D20656C7365207B0A20202020202020202020747279207B0A20202020202020';
wwv_flow_api.g_varchar2_table(329) := '20202020206E6F64652E736574417474726962757465286E616D652C202727293B0A202020202020202020207D20636174636820285F29207B7D0A20202020202020207D0A2020202020207D0A202020207D3B0A0A202020202F2A2A0A20202020202A20';
wwv_flow_api.g_varchar2_table(330) := '5F696E6974446F63756D656E740A20202020202A0A20202020202A2040706172616D20207B537472696E677D206469727479206120737472696E67206F66206469727479206D61726B75700A20202020202A204072657475726E207B446F63756D656E74';
wwv_flow_api.g_varchar2_table(331) := '7D206120444F4D2C2066696C6C6564207769746820746865206469727479206D61726B75700A20202020202A2F0A20202020766172205F696E6974446F63756D656E74203D2066756E6374696F6E205F696E6974446F63756D656E742864697274792920';
wwv_flow_api.g_varchar2_table(332) := '7B0A2020202020202F2A2043726561746520612048544D4C20646F63756D656E74202A2F0A20202020202076617220646F63203D20766F696420303B0A202020202020766172206C656164696E6757686974657370616365203D20766F696420303B0A0A';
wwv_flow_api.g_varchar2_table(333) := '20202020202069662028464F5243455F424F445929207B0A20202020202020206469727479203D20273C72656D6F76653E3C2F72656D6F76653E27202B2064697274793B0A2020202020207D20656C7365207B0A20202020202020202F2A20496620464F';
wwv_flow_api.g_varchar2_table(334) := '5243455F424F44592069736E277420757365642C206C656164696E672077686974657370616365206E6565647320746F20626520707265736572766564206D616E75616C6C79202A2F0A2020202020202020766172206D617463686573203D2073747269';
wwv_flow_api.g_varchar2_table(335) := '6E674D617463682864697274792C202F5E5B5C725C6E5C74205D2B2F293B0A20202020202020206C656164696E6757686974657370616365203D206D617463686573202626206D6174636865735B305D3B0A2020202020207D0A0A202020202020766172';
wwv_flow_api.g_varchar2_table(336) := '2064697274795061796C6F6164203D20747275737465645479706573506F6C696379203F20747275737465645479706573506F6C6963792E63726561746548544D4C28646972747929203A2064697274793B0A2020202020202F2A0A202020202020202A';
wwv_flow_api.g_varchar2_table(337) := '205573652074686520444F4D506172736572204150492062792064656661756C742C2066616C6C6261636B206C61746572206966206E656564732062650A202020202020202A20444F4D506172736572206E6F7420776F726B20666F7220737667207768';
wwv_flow_api.g_varchar2_table(338) := '656E20686173206D756C7469706C6520726F6F7420656C656D656E742E0A202020202020202A2F0A202020202020696620284E414D455350414345203D3D3D2048544D4C5F4E414D45535041434529207B0A2020202020202020747279207B0A20202020';
wwv_flow_api.g_varchar2_table(339) := '202020202020646F63203D206E657720444F4D50617273657228292E706172736546726F6D537472696E672864697274795061796C6F61642C2027746578742F68746D6C27293B0A20202020202020207D20636174636820285F29207B7D0A2020202020';
wwv_flow_api.g_varchar2_table(340) := '207D0A0A2020202020202F2A205573652063726561746548544D4C446F63756D656E7420696E206361736520444F4D506172736572206973206E6F7420617661696C61626C65202A2F0A2020202020206966202821646F63207C7C2021646F632E646F63';
wwv_flow_api.g_varchar2_table(341) := '756D656E74456C656D656E7429207B0A2020202020202020646F63203D20696D706C656D656E746174696F6E2E637265617465446F63756D656E74284E414D4553504143452C202774656D706C617465272C206E756C6C293B0A20202020202020207472';
wwv_flow_api.g_varchar2_table(342) := '79207B0A20202020202020202020646F632E646F63756D656E74456C656D656E742E696E6E657248544D4C203D2049535F454D5054595F494E505554203F202727203A2064697274795061796C6F61643B0A20202020202020207D20636174636820285F';
wwv_flow_api.g_varchar2_table(343) := '29207B0A202020202020202020202F2F2053796E746178206572726F722069662064697274795061796C6F616420697320696E76616C696420786D6C0A20202020202020207D0A2020202020207D0A0A20202020202076617220626F6479203D20646F63';
wwv_flow_api.g_varchar2_table(344) := '2E626F6479207C7C20646F632E646F63756D656E74456C656D656E743B0A0A202020202020696620286469727479202626206C656164696E675768697465737061636529207B0A2020202020202020626F64792E696E736572744265666F726528646F63';
wwv_flow_api.g_varchar2_table(345) := '756D656E742E637265617465546578744E6F6465286C656164696E6757686974657370616365292C20626F64792E6368696C644E6F6465735B305D207C7C206E756C6C293B0A2020202020207D0A0A2020202020202F2A20576F726B206F6E2077686F6C';
wwv_flow_api.g_varchar2_table(346) := '6520646F63756D656E74206F72206A7573742069747320626F6479202A2F0A20202020202072657475726E2057484F4C455F444F43554D454E54203F20646F632E646F63756D656E74456C656D656E74203A20626F64793B0A202020207D3B0A0A202020';
wwv_flow_api.g_varchar2_table(347) := '202F2A2A0A20202020202A205F6372656174654974657261746F720A20202020202A0A20202020202A2040706172616D20207B446F63756D656E747D20726F6F7420646F63756D656E742F667261676D656E7420746F2063726561746520697465726174';
wwv_flow_api.g_varchar2_table(348) := '6F7220666F720A20202020202A204072657475726E207B4974657261746F727D206974657261746F7220696E7374616E63650A20202020202A2F0A20202020766172205F6372656174654974657261746F72203D2066756E6374696F6E205F6372656174';
wwv_flow_api.g_varchar2_table(349) := '654974657261746F7228726F6F7429207B0A20202020202072657475726E206372656174654E6F64654974657261746F722E63616C6C28726F6F742E6F776E6572446F63756D656E74207C7C20726F6F742C20726F6F742C204E6F646546696C7465722E';
wwv_flow_api.g_varchar2_table(350) := '53484F575F454C454D454E54207C204E6F646546696C7465722E53484F575F434F4D4D454E54207C204E6F646546696C7465722E53484F575F544558542C206E756C6C2C2066616C7365293B0A202020207D3B0A0A202020202F2A2A0A20202020202A20';
wwv_flow_api.g_varchar2_table(351) := '5F6973436C6F6262657265640A20202020202A0A20202020202A2040706172616D20207B4E6F64657D20656C6D20656C656D656E7420746F20636865636B20666F7220636C6F62626572696E672061747461636B730A20202020202A204072657475726E';
wwv_flow_api.g_varchar2_table(352) := '207B426F6F6C65616E7D207472756520696620636C6F6262657265642C2066616C736520696620736166650A20202020202A2F0A20202020766172205F6973436C6F626265726564203D2066756E6374696F6E205F6973436C6F62626572656428656C6D';
wwv_flow_api.g_varchar2_table(353) := '29207B0A20202020202069662028656C6D20696E7374616E63656F662054657874207C7C20656C6D20696E7374616E63656F6620436F6D6D656E7429207B0A202020202020202072657475726E2066616C73653B0A2020202020207D0A0A202020202020';
wwv_flow_api.g_varchar2_table(354) := '69662028747970656F6620656C6D2E6E6F64654E616D6520213D3D2027737472696E6727207C7C20747970656F6620656C6D2E74657874436F6E74656E7420213D3D2027737472696E6727207C7C20747970656F6620656C6D2E72656D6F76654368696C';
wwv_flow_api.g_varchar2_table(355) := '6420213D3D202766756E6374696F6E27207C7C202128656C6D2E6174747269627574657320696E7374616E63656F66204E616D65644E6F64654D617029207C7C20747970656F6620656C6D2E72656D6F766541747472696275746520213D3D202766756E';
wwv_flow_api.g_varchar2_table(356) := '6374696F6E27207C7C20747970656F6620656C6D2E73657441747472696275746520213D3D202766756E6374696F6E27207C7C20747970656F6620656C6D2E6E616D65737061636555524920213D3D2027737472696E6727207C7C20747970656F662065';
wwv_flow_api.g_varchar2_table(357) := '6C6D2E696E736572744265666F726520213D3D202766756E6374696F6E2729207B0A202020202020202072657475726E20747275653B0A2020202020207D0A0A20202020202072657475726E2066616C73653B0A202020207D3B0A0A202020202F2A2A0A';
wwv_flow_api.g_varchar2_table(358) := '20202020202A205F69734E6F64650A20202020202A0A20202020202A2040706172616D20207B4E6F64657D206F626A206F626A65637420746F20636865636B20776865746865722069742773206120444F4D206E6F64650A20202020202A204072657475';
wwv_flow_api.g_varchar2_table(359) := '726E207B426F6F6C65616E7D2074727565206973206F626A656374206973206120444F4D206E6F64650A20202020202A2F0A20202020766172205F69734E6F6465203D2066756E6374696F6E205F69734E6F6465286F626A65637429207B0A2020202020';
wwv_flow_api.g_varchar2_table(360) := '2072657475726E2028747970656F66204E6F6465203D3D3D2027756E646566696E656427203F2027756E646566696E656427203A205F747970656F66284E6F64652929203D3D3D20276F626A65637427203F206F626A65637420696E7374616E63656F66';
wwv_flow_api.g_varchar2_table(361) := '204E6F6465203A206F626A6563742026262028747970656F66206F626A656374203D3D3D2027756E646566696E656427203F2027756E646566696E656427203A205F747970656F66286F626A6563742929203D3D3D20276F626A65637427202626207479';
wwv_flow_api.g_varchar2_table(362) := '70656F66206F626A6563742E6E6F646554797065203D3D3D20276E756D6265722720262620747970656F66206F626A6563742E6E6F64654E616D65203D3D3D2027737472696E67273B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F6578';
wwv_flow_api.g_varchar2_table(363) := '6563757465486F6F6B0A20202020202A2045786563757465207573657220636F6E666967757261626C6520686F6F6B730A20202020202A0A20202020202A2040706172616D20207B537472696E677D20656E747279506F696E7420204E616D65206F6620';
wwv_flow_api.g_varchar2_table(364) := '74686520686F6F6B277320656E74727920706F696E740A20202020202A2040706172616D20207B4E6F64657D2063757272656E744E6F6465206E6F646520746F20776F726B206F6E20776974682074686520686F6F6B0A20202020202A2040706172616D';
wwv_flow_api.g_varchar2_table(365) := '20207B4F626A6563747D2064617461206164646974696F6E616C20686F6F6B20706172616D65746572730A20202020202A2F0A20202020766172205F65786563757465486F6F6B203D2066756E6374696F6E205F65786563757465486F6F6B28656E7472';
wwv_flow_api.g_varchar2_table(366) := '79506F696E742C2063757272656E744E6F64652C206461746129207B0A2020202020206966202821686F6F6B735B656E747279506F696E745D29207B0A202020202020202072657475726E3B0A2020202020207D0A0A2020202020206172726179466F72';
wwv_flow_api.g_varchar2_table(367) := '4561636828686F6F6B735B656E747279506F696E745D2C2066756E6374696F6E2028686F6F6B29207B0A2020202020202020686F6F6B2E63616C6C28444F4D5075726966792C2063757272656E744E6F64652C20646174612C20434F4E464947293B0A20';
wwv_flow_api.g_varchar2_table(368) := '20202020207D293B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F73616E6974697A65456C656D656E74730A20202020202A0A20202020202A204070726F74656374206E6F64654E616D650A20202020202A204070726F74656374207465';
wwv_flow_api.g_varchar2_table(369) := '7874436F6E74656E740A20202020202A204070726F746563742072656D6F76654368696C640A20202020202A0A20202020202A2040706172616D2020207B4E6F64657D2063757272656E744E6F646520746F20636865636B20666F72207065726D697373';
wwv_flow_api.g_varchar2_table(370) := '696F6E20746F2065786973740A20202020202A204072657475726E20207B426F6F6C65616E7D2074727565206966206E6F646520776173206B696C6C65642C2066616C7365206966206C65667420616C6976650A20202020202A2F0A2020202076617220';
wwv_flow_api.g_varchar2_table(371) := '5F73616E6974697A65456C656D656E7473203D2066756E6374696F6E205F73616E6974697A65456C656D656E74732863757272656E744E6F646529207B0A20202020202076617220636F6E74656E74203D20766F696420303B0A0A2020202020202F2A20';
wwv_flow_api.g_varchar2_table(372) := '45786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020205F65786563757465486F6F6B28276265666F726553616E6974697A65456C656D656E7473272C2063757272656E744E6F64652C206E756C6C293B0A0A2020202020';
wwv_flow_api.g_varchar2_table(373) := '202F2A20436865636B20696620656C656D656E7420697320636C6F626265726564206F722063616E20636C6F62626572202A2F0A202020202020696620285F6973436C6F6262657265642863757272656E744E6F64652929207B0A20202020202020205F';
wwv_flow_api.g_varchar2_table(374) := '666F72636552656D6F76652863757272656E744E6F6465293B0A202020202020202072657475726E20747275653B0A2020202020207D0A0A2020202020202F2A20436865636B206966207461676E616D6520636F6E7461696E7320556E69636F6465202A';
wwv_flow_api.g_varchar2_table(375) := '2F0A20202020202069662028737472696E674D617463682863757272656E744E6F64652E6E6F64654E616D652C202F5B5C75303038302D5C75464646465D2F2929207B0A20202020202020205F666F72636552656D6F76652863757272656E744E6F6465';
wwv_flow_api.g_varchar2_table(376) := '293B0A202020202020202072657475726E20747275653B0A2020202020207D0A0A2020202020202F2A204E6F77206C6574277320636865636B2074686520656C656D656E742773207479706520616E64206E616D65202A2F0A2020202020207661722074';
wwv_flow_api.g_varchar2_table(377) := '61674E616D65203D20737472696E67546F4C6F776572436173652863757272656E744E6F64652E6E6F64654E616D65293B0A0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020205F65786563';
wwv_flow_api.g_varchar2_table(378) := '757465486F6F6B282775706F6E53616E6974697A65456C656D656E74272C2063757272656E744E6F64652C207B0A20202020202020207461674E616D653A207461674E616D652C0A2020202020202020616C6C6F776564546167733A20414C4C4F574544';
wwv_flow_api.g_varchar2_table(379) := '5F544147530A2020202020207D293B0A0A2020202020202F2A20446574656374206D58535320617474656D7074732061627573696E67206E616D65737061636520636F6E667573696F6E202A2F0A20202020202069662028215F69734E6F646528637572';
wwv_flow_api.g_varchar2_table(380) := '72656E744E6F64652E6669727374456C656D656E744368696C64292026262028215F69734E6F64652863757272656E744E6F64652E636F6E74656E7429207C7C20215F69734E6F64652863757272656E744E6F64652E636F6E74656E742E666972737445';
wwv_flow_api.g_varchar2_table(381) := '6C656D656E744368696C6429292026262072656745787054657374282F3C5B2F5C775D2F672C2063757272656E744E6F64652E696E6E657248544D4C292026262072656745787054657374282F3C5B2F5C775D2F672C2063757272656E744E6F64652E74';
wwv_flow_api.g_varchar2_table(382) := '657874436F6E74656E742929207B0A20202020202020205F666F72636552656D6F76652863757272656E744E6F6465293B0A202020202020202072657475726E20747275653B0A2020202020207D0A0A2020202020202F2A2052656D6F766520656C656D';
wwv_flow_api.g_varchar2_table(383) := '656E7420696620616E797468696E6720666F7262696473206974732070726573656E6365202A2F0A2020202020206966202821414C4C4F5745445F544147535B7461674E616D655D207C7C20464F524249445F544147535B7461674E616D655D29207B0A';
wwv_flow_api.g_varchar2_table(384) := '20202020202020202F2A204B65657020636F6E74656E742065786365707420666F72206261642D6C697374656420656C656D656E7473202A2F0A2020202020202020696620284B4545505F434F4E54454E542026262021464F524249445F434F4E54454E';
wwv_flow_api.g_varchar2_table(385) := '54535B7461674E616D655D29207B0A2020202020202020202076617220706172656E744E6F6465203D20676574506172656E744E6F64652863757272656E744E6F646529207C7C2063757272656E744E6F64652E706172656E744E6F64653B0A20202020';
wwv_flow_api.g_varchar2_table(386) := '202020202020766172206368696C644E6F646573203D206765744368696C644E6F6465732863757272656E744E6F646529207C7C2063757272656E744E6F64652E6368696C644E6F6465733B0A0A20202020202020202020696620286368696C644E6F64';
wwv_flow_api.g_varchar2_table(387) := '657320262620706172656E744E6F646529207B0A202020202020202020202020766172206368696C64436F756E74203D206368696C644E6F6465732E6C656E6774683B0A0A202020202020202020202020666F7220287661722069203D206368696C6443';
wwv_flow_api.g_varchar2_table(388) := '6F756E74202D20313B2069203E3D20303B202D2D6929207B0A2020202020202020202020202020706172656E744E6F64652E696E736572744265666F726528636C6F6E654E6F6465286368696C644E6F6465735B695D2C2074727565292C206765744E65';
wwv_flow_api.g_varchar2_table(389) := '78745369626C696E672863757272656E744E6F646529293B0A2020202020202020202020207D0A202020202020202020207D0A20202020202020207D0A0A20202020202020205F666F72636552656D6F76652863757272656E744E6F6465293B0A202020';
wwv_flow_api.g_varchar2_table(390) := '202020202072657475726E20747275653B0A2020202020207D0A0A2020202020202F2A20436865636B207768657468657220656C656D656E742068617320612076616C6964206E616D657370616365202A2F0A2020202020206966202863757272656E74';
wwv_flow_api.g_varchar2_table(391) := '4E6F646520696E7374616E63656F6620456C656D656E7420262620215F636865636B56616C69644E616D6573706163652863757272656E744E6F64652929207B0A20202020202020205F666F72636552656D6F76652863757272656E744E6F6465293B0A';
wwv_flow_api.g_varchar2_table(392) := '202020202020202072657475726E20747275653B0A2020202020207D0A0A20202020202069662028287461674E616D65203D3D3D20276E6F73637269707427207C7C207461674E616D65203D3D3D20276E6F656D62656427292026262072656745787054';
wwv_flow_api.g_varchar2_table(393) := '657374282F3C5C2F6E6F287363726970747C656D626564292F692C2063757272656E744E6F64652E696E6E657248544D4C2929207B0A20202020202020205F666F72636552656D6F76652863757272656E744E6F6465293B0A2020202020202020726574';
wwv_flow_api.g_varchar2_table(394) := '75726E20747275653B0A2020202020207D0A0A2020202020202F2A2053616E6974697A6520656C656D656E7420636F6E74656E7420746F2062652074656D706C6174652D73616665202A2F0A20202020202069662028534146455F464F525F54454D504C';
wwv_flow_api.g_varchar2_table(395) := '415445532026262063757272656E744E6F64652E6E6F646554797065203D3D3D203329207B0A20202020202020202F2A204765742074686520656C656D656E742773207465787420636F6E74656E74202A2F0A2020202020202020636F6E74656E74203D';
wwv_flow_api.g_varchar2_table(396) := '2063757272656E744E6F64652E74657874436F6E74656E743B0A2020202020202020636F6E74656E74203D20737472696E675265706C61636528636F6E74656E742C204D555354414348455F455850522424312C20272027293B0A202020202020202063';
wwv_flow_api.g_varchar2_table(397) := '6F6E74656E74203D20737472696E675265706C61636528636F6E74656E742C204552425F455850522424312C20272027293B0A20202020202020206966202863757272656E744E6F64652E74657874436F6E74656E7420213D3D20636F6E74656E742920';
wwv_flow_api.g_varchar2_table(398) := '7B0A2020202020202020202061727261795075736828444F4D5075726966792E72656D6F7665642C207B20656C656D656E743A2063757272656E744E6F64652E636C6F6E654E6F64652829207D293B0A2020202020202020202063757272656E744E6F64';
wwv_flow_api.g_varchar2_table(399) := '652E74657874436F6E74656E74203D20636F6E74656E743B0A20202020202020207D0A2020202020207D0A0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020205F65786563757465486F6F6B';
wwv_flow_api.g_varchar2_table(400) := '2827616674657253616E6974697A65456C656D656E7473272C2063757272656E744E6F64652C206E756C6C293B0A0A20202020202072657475726E2066616C73653B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F697356616C69644174';
wwv_flow_api.g_varchar2_table(401) := '747269627574650A20202020202A0A20202020202A2040706172616D20207B737472696E677D206C63546167204C6F7765726361736520746167206E616D65206F6620636F6E7461696E696E6720656C656D656E742E0A20202020202A2040706172616D';
wwv_flow_api.g_varchar2_table(402) := '20207B737472696E677D206C634E616D65204C6F7765726361736520617474726962757465206E616D652E0A20202020202A2040706172616D20207B737472696E677D2076616C7565204174747269627574652076616C75652E0A20202020202A204072';
wwv_flow_api.g_varchar2_table(403) := '657475726E207B426F6F6C65616E7D2052657475726E732074727565206966206076616C7565602069732076616C69642C206F74686572776973652066616C73652E0A20202020202A2F0A202020202F2F2065736C696E742D64697361626C652D6E6578';
wwv_flow_api.g_varchar2_table(404) := '742D6C696E6520636F6D706C65786974790A20202020766172205F697356616C6964417474726962757465203D2066756E6374696F6E205F697356616C6964417474726962757465286C635461672C206C634E616D652C2076616C756529207B0A202020';
wwv_flow_api.g_varchar2_table(405) := '2020202F2A204D616B652073757265206174747269627574652063616E6E6F7420636C6F62626572202A2F0A2020202020206966202853414E4954495A455F444F4D20262620286C634E616D65203D3D3D2027696427207C7C206C634E616D65203D3D3D';
wwv_flow_api.g_varchar2_table(406) := '20276E616D652729202626202876616C756520696E20646F63756D656E74207C7C2076616C756520696E20666F726D456C656D656E742929207B0A202020202020202072657475726E2066616C73653B0A2020202020207D0A0A2020202020202F2A2041';
wwv_flow_api.g_varchar2_table(407) := '6C6C6F772076616C696420646174612D2A20617474726962757465733A204174206C65617374206F6E652063686172616374657220616674657220222D220A202020202020202020202868747470733A2F2F68746D6C2E737065632E7768617477672E6F';
wwv_flow_api.g_varchar2_table(408) := '72672F6D756C7469706167652F646F6D2E68746D6C23656D62656464696E672D637573746F6D2D6E6F6E2D76697369626C652D646174612D776974682D7468652D646174612D2A2D61747472696275746573290A20202020202020202020584D4C2D636F';
wwv_flow_api.g_varchar2_table(409) := '6D70617469626C65202868747470733A2F2F68746D6C2E737065632E7768617477672E6F72672F6D756C7469706167652F696E6672617374727563747572652E68746D6C23786D6C2D636F6D70617469626C6520616E6420687474703A2F2F7777772E77';
wwv_flow_api.g_varchar2_table(410) := '332E6F72672F54522F786D6C2F23643065383034290A20202020202020202020576520646F6E2774206E65656420746F20636865636B207468652076616C75653B206974277320616C776179732055524920736166652E202A2F0A202020202020696620';
wwv_flow_api.g_varchar2_table(411) := '28414C4C4F575F444154415F41545452202626207265674578705465737428444154415F415454522424312C206C634E616D652929203B20656C73652069662028414C4C4F575F415249415F41545452202626207265674578705465737428415249415F';
wwv_flow_api.g_varchar2_table(412) := '415454522424312C206C634E616D652929203B20656C7365206966202821414C4C4F5745445F415454525B6C634E616D655D207C7C20464F524249445F415454525B6C634E616D655D29207B0A202020202020202072657475726E2066616C73653B0A0A';
wwv_flow_api.g_varchar2_table(413) := '20202020202020202F2A20436865636B2076616C756520697320736166652E2046697273742C206973206174747220696E6572743F20496620736F2C2069732073616665202A2F0A2020202020207D20656C736520696620285552495F534146455F4154';
wwv_flow_api.g_varchar2_table(414) := '54524942555445535B6C634E616D655D29203B20656C73652069662028726567457870546573742849535F414C4C4F5745445F5552492424312C20737472696E675265706C6163652876616C75652C20415454525F574849544553504143452424312C20';
wwv_flow_api.g_varchar2_table(415) := '2727292929203B20656C73652069662028286C634E616D65203D3D3D202773726327207C7C206C634E616D65203D3D3D2027786C696E6B3A6872656627207C7C206C634E616D65203D3D3D2027687265662729202626206C6354616720213D3D20277363';
wwv_flow_api.g_varchar2_table(416) := '726970742720262620737472696E67496E6465784F662876616C75652C2027646174613A2729203D3D3D203020262620444154415F5552495F544147535B6C635461675D29203B20656C73652069662028414C4C4F575F554E4B4E4F574E5F50524F544F';
wwv_flow_api.g_varchar2_table(417) := '434F4C532026262021726567457870546573742849535F5343524950545F4F525F444154412424312C20737472696E675265706C6163652876616C75652C20415454525F574849544553504143452424312C202727292929203B20656C73652069662028';
wwv_flow_api.g_varchar2_table(418) := '2176616C756529203B20656C7365207B0A202020202020202072657475726E2066616C73653B0A2020202020207D0A0A20202020202072657475726E20747275653B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F73616E6974697A6541';
wwv_flow_api.g_varchar2_table(419) := '7474726962757465730A20202020202A0A20202020202A204070726F7465637420617474726962757465730A20202020202A204070726F74656374206E6F64654E616D650A20202020202A204070726F746563742072656D6F7665417474726962757465';
wwv_flow_api.g_varchar2_table(420) := '0A20202020202A204070726F74656374207365744174747269627574650A20202020202A0A20202020202A2040706172616D20207B4E6F64657D2063757272656E744E6F646520746F2073616E6974697A650A20202020202A2F0A20202020766172205F';
wwv_flow_api.g_varchar2_table(421) := '73616E6974697A6541747472696275746573203D2066756E6374696F6E205F73616E6974697A65417474726962757465732863757272656E744E6F646529207B0A2020202020207661722061747472203D20766F696420303B0A20202020202076617220';
wwv_flow_api.g_varchar2_table(422) := '76616C7565203D20766F696420303B0A202020202020766172206C634E616D65203D20766F696420303B0A202020202020766172206C203D20766F696420303B0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E7420';
wwv_flow_api.g_varchar2_table(423) := '2A2F0A2020202020205F65786563757465486F6F6B28276265666F726553616E6974697A6541747472696275746573272C2063757272656E744E6F64652C206E756C6C293B0A0A2020202020207661722061747472696275746573203D2063757272656E';
wwv_flow_api.g_varchar2_table(424) := '744E6F64652E617474726962757465733B0A0A2020202020202F2A20436865636B206966207765206861766520617474726962757465733B206966206E6F74207765206D69676874206861766520612074657874206E6F6465202A2F0A0A202020202020';
wwv_flow_api.g_varchar2_table(425) := '69662028216174747269627574657329207B0A202020202020202072657475726E3B0A2020202020207D0A0A20202020202076617220686F6F6B4576656E74203D207B0A2020202020202020617474724E616D653A2027272C0A20202020202020206174';
wwv_flow_api.g_varchar2_table(426) := '747256616C75653A2027272C0A20202020202020206B656570417474723A20747275652C0A2020202020202020616C6C6F776564417474726962757465733A20414C4C4F5745445F415454520A2020202020207D3B0A2020202020206C203D2061747472';
wwv_flow_api.g_varchar2_table(427) := '6962757465732E6C656E6774683B0A0A2020202020202F2A20476F206261636B7761726473206F76657220616C6C20617474726962757465733B20736166656C792072656D6F766520626164206F6E6573202A2F0A2020202020207768696C6520286C2D';
wwv_flow_api.g_varchar2_table(428) := '2D29207B0A202020202020202061747472203D20617474726962757465735B6C5D3B0A2020202020202020766172205F61747472203D20617474722C0A2020202020202020202020206E616D65203D205F617474722E6E616D652C0A2020202020202020';
wwv_flow_api.g_varchar2_table(429) := '202020206E616D657370616365555249203D205F617474722E6E616D6573706163655552493B0A0A202020202020202076616C7565203D20737472696E675472696D28617474722E76616C7565293B0A20202020202020206C634E616D65203D20737472';
wwv_flow_api.g_varchar2_table(430) := '696E67546F4C6F77657243617365286E616D65293B0A0A20202020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020202020686F6F6B4576656E742E617474724E616D65203D206C634E616D653B0A';
wwv_flow_api.g_varchar2_table(431) := '2020202020202020686F6F6B4576656E742E6174747256616C7565203D2076616C75653B0A2020202020202020686F6F6B4576656E742E6B65657041747472203D20747275653B0A2020202020202020686F6F6B4576656E742E666F7263654B65657041';
wwv_flow_api.g_varchar2_table(432) := '747472203D20756E646566696E65643B202F2F20416C6C6F777320646576656C6F7065727320746F20736565207468697320697320612070726F706572747920746865792063616E207365740A20202020202020205F65786563757465486F6F6B282775';
wwv_flow_api.g_varchar2_table(433) := '706F6E53616E6974697A65417474726962757465272C2063757272656E744E6F64652C20686F6F6B4576656E74293B0A202020202020202076616C7565203D20686F6F6B4576656E742E6174747256616C75653B0A20202020202020202F2A2044696420';
wwv_flow_api.g_varchar2_table(434) := '74686520686F6F6B7320617070726F7665206F6620746865206174747269627574653F202A2F0A202020202020202069662028686F6F6B4576656E742E666F7263654B6565704174747229207B0A20202020202020202020636F6E74696E75653B0A2020';
wwv_flow_api.g_varchar2_table(435) := '2020202020207D0A0A20202020202020202F2A2052656D6F766520617474726962757465202A2F0A20202020202020205F72656D6F7665417474726962757465286E616D652C2063757272656E744E6F6465293B0A0A20202020202020202F2A20446964';
wwv_flow_api.g_varchar2_table(436) := '2074686520686F6F6B7320617070726F7665206F6620746865206174747269627574653F202A2F0A20202020202020206966202821686F6F6B4576656E742E6B6565704174747229207B0A20202020202020202020636F6E74696E75653B0A2020202020';
wwv_flow_api.g_varchar2_table(437) := '2020207D0A0A20202020202020202F2A20576F726B2061726F756E64206120736563757269747920697373756520696E206A517565727920332E30202A2F0A20202020202020206966202872656745787054657374282F5C2F3E2F692C2076616C756529';
wwv_flow_api.g_varchar2_table(438) := '29207B0A202020202020202020205F72656D6F7665417474726962757465286E616D652C2063757272656E744E6F6465293B0A20202020202020202020636F6E74696E75653B0A20202020202020207D0A0A20202020202020202F2A2053616E6974697A';
wwv_flow_api.g_varchar2_table(439) := '652061747472696275746520636F6E74656E7420746F2062652074656D706C6174652D73616665202A2F0A202020202020202069662028534146455F464F525F54454D504C4154455329207B0A2020202020202020202076616C7565203D20737472696E';
wwv_flow_api.g_varchar2_table(440) := '675265706C6163652876616C75652C204D555354414348455F455850522424312C20272027293B0A2020202020202020202076616C7565203D20737472696E675265706C6163652876616C75652C204552425F455850522424312C20272027293B0A2020';
wwv_flow_api.g_varchar2_table(441) := '2020202020207D0A0A20202020202020202F2A204973206076616C7565602076616C696420666F722074686973206174747269627574653F202A2F0A2020202020202020766172206C63546167203D2063757272656E744E6F64652E6E6F64654E616D65';
wwv_flow_api.g_varchar2_table(442) := '2E746F4C6F7765724361736528293B0A202020202020202069662028215F697356616C6964417474726962757465286C635461672C206C634E616D652C2076616C75652929207B0A20202020202020202020636F6E74696E75653B0A2020202020202020';
wwv_flow_api.g_varchar2_table(443) := '7D0A0A20202020202020202F2A2048616E646C6520696E76616C696420646174612D2A2061747472696275746520736574206279207472792D6361746368696E67206974202A2F0A2020202020202020747279207B0A2020202020202020202069662028';
wwv_flow_api.g_varchar2_table(444) := '6E616D65737061636555524929207B0A20202020202020202020202063757272656E744E6F64652E7365744174747269627574654E53286E616D6573706163655552492C206E616D652C2076616C7565293B0A202020202020202020207D20656C736520';
wwv_flow_api.g_varchar2_table(445) := '7B0A2020202020202020202020202F2A2046616C6C6261636B20746F20736574417474726962757465282920666F722062726F777365722D756E7265636F676E697A6564206E616D6573706163657320652E672E2022782D736368656D61222E202A2F0A';
wwv_flow_api.g_varchar2_table(446) := '20202020202020202020202063757272656E744E6F64652E736574417474726962757465286E616D652C2076616C7565293B0A202020202020202020207D0A0A202020202020202020206172726179506F7028444F4D5075726966792E72656D6F766564';
wwv_flow_api.g_varchar2_table(447) := '293B0A20202020202020207D20636174636820285F29207B7D0A2020202020207D0A0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020205F65786563757465486F6F6B282761667465725361';
wwv_flow_api.g_varchar2_table(448) := '6E6974697A6541747472696275746573272C2063757272656E744E6F64652C206E756C6C293B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F73616E6974697A65536861646F77444F4D0A20202020202A0A20202020202A204070617261';
wwv_flow_api.g_varchar2_table(449) := '6D20207B446F63756D656E74467261676D656E747D20667261676D656E7420746F2069746572617465206F766572207265637572736976656C790A20202020202A2F0A20202020766172205F73616E6974697A65536861646F77444F4D203D2066756E63';
wwv_flow_api.g_varchar2_table(450) := '74696F6E205F73616E6974697A65536861646F77444F4D28667261676D656E7429207B0A20202020202076617220736861646F774E6F6465203D20766F696420303B0A20202020202076617220736861646F774974657261746F72203D205F6372656174';
wwv_flow_api.g_varchar2_table(451) := '654974657261746F7228667261676D656E74293B0A0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020205F65786563757465486F6F6B28276265666F726553616E6974697A65536861646F77';
wwv_flow_api.g_varchar2_table(452) := '444F4D272C20667261676D656E742C206E756C6C293B0A0A2020202020207768696C652028736861646F774E6F6465203D20736861646F774974657261746F722E6E6578744E6F6465282929207B0A20202020202020202F2A2045786563757465206120';
wwv_flow_api.g_varchar2_table(453) := '686F6F6B2069662070726573656E74202A2F0A20202020202020205F65786563757465486F6F6B282775706F6E53616E6974697A65536861646F774E6F6465272C20736861646F774E6F64652C206E756C6C293B0A0A20202020202020202F2A2053616E';
wwv_flow_api.g_varchar2_table(454) := '6974697A65207461677320616E6420656C656D656E7473202A2F0A2020202020202020696620285F73616E6974697A65456C656D656E747328736861646F774E6F64652929207B0A20202020202020202020636F6E74696E75653B0A2020202020202020';
wwv_flow_api.g_varchar2_table(455) := '7D0A0A20202020202020202F2A204465657020736861646F7720444F4D206465746563746564202A2F0A202020202020202069662028736861646F774E6F64652E636F6E74656E7420696E7374616E63656F6620446F63756D656E74467261676D656E74';
wwv_flow_api.g_varchar2_table(456) := '29207B0A202020202020202020205F73616E6974697A65536861646F77444F4D28736861646F774E6F64652E636F6E74656E74293B0A20202020202020207D0A0A20202020202020202F2A20436865636B20617474726962757465732C2073616E697469';
wwv_flow_api.g_varchar2_table(457) := '7A65206966206E6563657373617279202A2F0A20202020202020205F73616E6974697A654174747269627574657328736861646F774E6F6465293B0A2020202020207D0A0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573';
wwv_flow_api.g_varchar2_table(458) := '656E74202A2F0A2020202020205F65786563757465486F6F6B2827616674657253616E6974697A65536861646F77444F4D272C20667261676D656E742C206E756C6C293B0A202020207D3B0A0A202020202F2A2A0A20202020202A2053616E6974697A65';
wwv_flow_api.g_varchar2_table(459) := '0A20202020202A205075626C6963206D6574686F642070726F766964696E6720636F72652073616E69746174696F6E2066756E6374696F6E616C6974790A20202020202A0A20202020202A2040706172616D207B537472696E677C4E6F64657D20646972';
wwv_flow_api.g_varchar2_table(460) := '747920737472696E67206F7220444F4D206E6F64650A20202020202A2040706172616D207B4F626A6563747D20636F6E66696775726174696F6E206F626A6563740A20202020202A2F0A202020202F2F2065736C696E742D64697361626C652D6E657874';
wwv_flow_api.g_varchar2_table(461) := '2D6C696E6520636F6D706C65786974790A20202020444F4D5075726966792E73616E6974697A65203D2066756E6374696F6E202864697274792C2063666729207B0A20202020202076617220626F6479203D20766F696420303B0A202020202020766172';
wwv_flow_api.g_varchar2_table(462) := '20696D706F727465644E6F6465203D20766F696420303B0A2020202020207661722063757272656E744E6F6465203D20766F696420303B0A202020202020766172206F6C644E6F6465203D20766F696420303B0A2020202020207661722072657475726E';
wwv_flow_api.g_varchar2_table(463) := '4E6F6465203D20766F696420303B0A2020202020202F2A204D616B6520737572652077652068617665206120737472696E6720746F2073616E6974697A652E0A2020202020202020444F204E4F542072657475726E206561726C792C2061732074686973';
wwv_flow_api.g_varchar2_table(464) := '2077696C6C2072657475726E207468652077726F6E6720747970652069660A202020202020202074686520757365722068617320726571756573746564206120444F4D206F626A65637420726174686572207468616E206120737472696E67202A2F0A20';
wwv_flow_api.g_varchar2_table(465) := '202020202049535F454D5054595F494E505554203D202164697274793B0A2020202020206966202849535F454D5054595F494E50555429207B0A20202020202020206469727479203D20273C212D2D3E273B0A2020202020207D0A0A2020202020202F2A';
wwv_flow_api.g_varchar2_table(466) := '20537472696E676966792C20696E206361736520646972747920697320616E206F626A656374202A2F0A20202020202069662028747970656F6620646972747920213D3D2027737472696E672720262620215F69734E6F64652864697274792929207B0A';
wwv_flow_api.g_varchar2_table(467) := '20202020202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E65206E6F2D6E6567617465642D636F6E646974696F6E0A202020202020202069662028747970656F662064697274792E746F537472696E6720213D3D202766756E63';
wwv_flow_api.g_varchar2_table(468) := '74696F6E2729207B0A202020202020202020207468726F7720747970654572726F724372656174652827746F537472696E67206973206E6F7420612066756E6374696F6E27293B0A20202020202020207D20656C7365207B0A2020202020202020202064';
wwv_flow_api.g_varchar2_table(469) := '69727479203D2064697274792E746F537472696E6728293B0A2020202020202020202069662028747970656F6620646972747920213D3D2027737472696E672729207B0A2020202020202020202020207468726F7720747970654572726F724372656174';
wwv_flow_api.g_varchar2_table(470) := '6528276469727479206973206E6F74206120737472696E672C2061626F7274696E6727293B0A202020202020202020207D0A20202020202020207D0A2020202020207D0A0A2020202020202F2A20436865636B2077652063616E2072756E2E204F746865';
wwv_flow_api.g_varchar2_table(471) := '72776973652066616C6C206261636B206F722069676E6F7265202A2F0A2020202020206966202821444F4D5075726966792E6973537570706F7274656429207B0A2020202020202020696620285F747970656F662877696E646F772E746F537461746963';
wwv_flow_api.g_varchar2_table(472) := '48544D4C29203D3D3D20276F626A65637427207C7C20747970656F662077696E646F772E746F53746174696348544D4C203D3D3D202766756E6374696F6E2729207B0A2020202020202020202069662028747970656F66206469727479203D3D3D202773';
wwv_flow_api.g_varchar2_table(473) := '7472696E672729207B0A20202020202020202020202072657475726E2077696E646F772E746F53746174696348544D4C286469727479293B0A202020202020202020207D0A0A20202020202020202020696620285F69734E6F6465286469727479292920';
wwv_flow_api.g_varchar2_table(474) := '7B0A20202020202020202020202072657475726E2077696E646F772E746F53746174696348544D4C2864697274792E6F7574657248544D4C293B0A202020202020202020207D0A20202020202020207D0A0A202020202020202072657475726E20646972';
wwv_flow_api.g_varchar2_table(475) := '74793B0A2020202020207D0A0A2020202020202F2A2041737369676E20636F6E6669672076617273202A2F0A20202020202069662028215345545F434F4E46494729207B0A20202020202020205F7061727365436F6E66696728636667293B0A20202020';
wwv_flow_api.g_varchar2_table(476) := '20207D0A0A2020202020202F2A20436C65616E2075702072656D6F76656420656C656D656E7473202A2F0A202020202020444F4D5075726966792E72656D6F766564203D205B5D3B0A0A2020202020202F2A20436865636B206966206469727479206973';
wwv_flow_api.g_varchar2_table(477) := '20636F72726563746C7920747970656420666F7220494E5F504C414345202A2F0A20202020202069662028747970656F66206469727479203D3D3D2027737472696E672729207B0A2020202020202020494E5F504C414345203D2066616C73653B0A2020';
wwv_flow_api.g_varchar2_table(478) := '202020207D0A0A20202020202069662028494E5F504C41434529203B20656C73652069662028646972747920696E7374616E63656F66204E6F646529207B0A20202020202020202F2A204966206469727479206973206120444F4D20656C656D656E742C';
wwv_flow_api.g_varchar2_table(479) := '20617070656E6420746F20616E20656D70747920646F63756D656E7420746F2061766F69640A2020202020202020202020656C656D656E7473206265696E672073747269707065642062792074686520706172736572202A2F0A2020202020202020626F';
wwv_flow_api.g_varchar2_table(480) := '6479203D205F696E6974446F63756D656E7428273C212D2D2D2D3E27293B0A2020202020202020696D706F727465644E6F6465203D20626F64792E6F776E6572446F63756D656E742E696D706F72744E6F64652864697274792C2074727565293B0A2020';
wwv_flow_api.g_varchar2_table(481) := '20202020202069662028696D706F727465644E6F64652E6E6F646554797065203D3D3D203120262620696D706F727465644E6F64652E6E6F64654E616D65203D3D3D2027424F44592729207B0A202020202020202020202F2A204E6F646520697320616C';
wwv_flow_api.g_varchar2_table(482) := '7265616479206120626F64792C20757365206173206973202A2F0A20202020202020202020626F6479203D20696D706F727465644E6F64653B0A20202020202020207D20656C73652069662028696D706F727465644E6F64652E6E6F64654E616D65203D';
wwv_flow_api.g_varchar2_table(483) := '3D3D202748544D4C2729207B0A20202020202020202020626F6479203D20696D706F727465644E6F64653B0A20202020202020207D20656C7365207B0A202020202020202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E652075';
wwv_flow_api.g_varchar2_table(484) := '6E69636F726E2F7072656665722D646F6D2D6E6F64652D617070656E640A20202020202020202020626F64792E617070656E644368696C6428696D706F727465644E6F6465293B0A20202020202020207D0A2020202020207D20656C7365207B0A202020';
wwv_flow_api.g_varchar2_table(485) := '20202020202F2A2045786974206469726563746C792069662077652068617665206E6F7468696E6720746F20646F202A2F0A2020202020202020696620282152455455524E5F444F4D2026262021534146455F464F525F54454D504C4154455320262620';
wwv_flow_api.g_varchar2_table(486) := '2157484F4C455F444F43554D454E542026260A20202020202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520756E69636F726E2F7072656665722D696E636C756465730A202020202020202064697274792E696E6465784F66';
wwv_flow_api.g_varchar2_table(487) := '28273C2729203D3D3D202D3129207B0A2020202020202020202072657475726E20747275737465645479706573506F6C6963792026262052455455524E5F545255535445445F54595045203F20747275737465645479706573506F6C6963792E63726561';
wwv_flow_api.g_varchar2_table(488) := '746548544D4C28646972747929203A2064697274793B0A20202020202020207D0A0A20202020202020202F2A20496E697469616C697A652074686520646F63756D656E7420746F20776F726B206F6E202A2F0A2020202020202020626F6479203D205F69';
wwv_flow_api.g_varchar2_table(489) := '6E6974446F63756D656E74286469727479293B0A0A20202020202020202F2A20436865636B2077652068617665206120444F4D206E6F64652066726F6D207468652064617461202A2F0A20202020202020206966202821626F647929207B0A2020202020';
wwv_flow_api.g_varchar2_table(490) := '202020202072657475726E2052455455524E5F444F4D203F206E756C6C203A20656D70747948544D4C3B0A20202020202020207D0A2020202020207D0A0A2020202020202F2A2052656D6F766520666972737420656C656D656E74206E6F646520286F75';
wwv_flow_api.g_varchar2_table(491) := '72732920696620464F5243455F424F445920697320736574202A2F0A20202020202069662028626F647920262620464F5243455F424F445929207B0A20202020202020205F666F72636552656D6F766528626F64792E66697273744368696C64293B0A20';
wwv_flow_api.g_varchar2_table(492) := '20202020207D0A0A2020202020202F2A20476574206E6F6465206974657261746F72202A2F0A202020202020766172206E6F64654974657261746F72203D205F6372656174654974657261746F7228494E5F504C414345203F206469727479203A20626F';
wwv_flow_api.g_varchar2_table(493) := '6479293B0A0A2020202020202F2A204E6F7720737461727420697465726174696E67206F76657220746865206372656174656420646F63756D656E74202A2F0A2020202020207768696C65202863757272656E744E6F6465203D206E6F64654974657261';
wwv_flow_api.g_varchar2_table(494) := '746F722E6E6578744E6F6465282929207B0A20202020202020202F2A20466978204945277320737472616E6765206265686176696F722077697468206D616E6970756C6174656420746578744E6F64657320233839202A2F0A2020202020202020696620';
wwv_flow_api.g_varchar2_table(495) := '2863757272656E744E6F64652E6E6F646554797065203D3D3D20332026262063757272656E744E6F6465203D3D3D206F6C644E6F646529207B0A20202020202020202020636F6E74696E75653B0A20202020202020207D0A0A20202020202020202F2A20';
wwv_flow_api.g_varchar2_table(496) := '53616E6974697A65207461677320616E6420656C656D656E7473202A2F0A2020202020202020696620285F73616E6974697A65456C656D656E74732863757272656E744E6F64652929207B0A20202020202020202020636F6E74696E75653B0A20202020';
wwv_flow_api.g_varchar2_table(497) := '202020207D0A0A20202020202020202F2A20536861646F7720444F4D2064657465637465642C2073616E6974697A65206974202A2F0A20202020202020206966202863757272656E744E6F64652E636F6E74656E7420696E7374616E63656F6620446F63';
wwv_flow_api.g_varchar2_table(498) := '756D656E74467261676D656E7429207B0A202020202020202020205F73616E6974697A65536861646F77444F4D2863757272656E744E6F64652E636F6E74656E74293B0A20202020202020207D0A0A20202020202020202F2A20436865636B2061747472';
wwv_flow_api.g_varchar2_table(499) := '6962757465732C2073616E6974697A65206966206E6563657373617279202A2F0A20202020202020205F73616E6974697A65417474726962757465732863757272656E744E6F6465293B0A0A20202020202020206F6C644E6F6465203D2063757272656E';
wwv_flow_api.g_varchar2_table(500) := '744E6F64653B0A2020202020207D0A0A2020202020206F6C644E6F6465203D206E756C6C3B0A0A2020202020202F2A2049662077652073616E6974697A6564206064697274796020696E2D706C6163652C2072657475726E2069742E202A2F0A20202020';
wwv_flow_api.g_varchar2_table(501) := '202069662028494E5F504C41434529207B0A202020202020202072657475726E2064697274793B0A2020202020207D0A0A2020202020202F2A2052657475726E2073616E6974697A656420737472696E67206F7220444F4D202A2F0A2020202020206966';
wwv_flow_api.g_varchar2_table(502) := '202852455455524E5F444F4D29207B0A20202020202020206966202852455455524E5F444F4D5F465241474D454E5429207B0A2020202020202020202072657475726E4E6F6465203D20637265617465446F63756D656E74467261676D656E742E63616C';
wwv_flow_api.g_varchar2_table(503) := '6C28626F64792E6F776E6572446F63756D656E74293B0A0A202020202020202020207768696C652028626F64792E66697273744368696C6429207B0A2020202020202020202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520';
wwv_flow_api.g_varchar2_table(504) := '756E69636F726E2F7072656665722D646F6D2D6E6F64652D617070656E640A20202020202020202020202072657475726E4E6F64652E617070656E644368696C6428626F64792E66697273744368696C64293B0A202020202020202020207D0A20202020';
wwv_flow_api.g_varchar2_table(505) := '202020207D20656C7365207B0A2020202020202020202072657475726E4E6F6465203D20626F64793B0A20202020202020207D0A0A20202020202020206966202852455455524E5F444F4D5F494D504F525429207B0A202020202020202020202F2A0A20';
wwv_flow_api.g_varchar2_table(506) := '202020202020202020202041646F70744E6F64652829206973206E6F742075736564206265636175736520696E7465726E616C207374617465206973206E6F742072657365740A20202020202020202020202028652E672E207468652070617374206E61';
wwv_flow_api.g_varchar2_table(507) := '6D6573206D6170206F6620612048544D4C466F726D456C656D656E74292C207468697320697320736166650A202020202020202020202020696E207468656F72792062757420776520776F756C6420726174686572206E6F74207269736B20616E6F7468';
wwv_flow_api.g_varchar2_table(508) := '65722061747461636B20766563746F722E0A202020202020202020202020546865207374617465207468617420697320636C6F6E656420627920696D706F72744E6F64652829206973206578706C696369746C7920646566696E65640A20202020202020';
wwv_flow_api.g_varchar2_table(509) := '20202020206279207468652073706563732E0A202020202020202020202A2F0A2020202020202020202072657475726E4E6F6465203D20696D706F72744E6F64652E63616C6C286F726967696E616C446F63756D656E742C2072657475726E4E6F64652C';
wwv_flow_api.g_varchar2_table(510) := '2074727565293B0A20202020202020207D0A0A202020202020202072657475726E2072657475726E4E6F64653B0A2020202020207D0A0A2020202020207661722073657269616C697A656448544D4C203D2057484F4C455F444F43554D454E54203F2062';
wwv_flow_api.g_varchar2_table(511) := '6F64792E6F7574657248544D4C203A20626F64792E696E6E657248544D4C3B0A0A2020202020202F2A2053616E6974697A652066696E616C20737472696E672074656D706C6174652D73616665202A2F0A20202020202069662028534146455F464F525F';
wwv_flow_api.g_varchar2_table(512) := '54454D504C4154455329207B0A202020202020202073657269616C697A656448544D4C203D20737472696E675265706C6163652873657269616C697A656448544D4C2C204D555354414348455F455850522424312C20272027293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(513) := '73657269616C697A656448544D4C203D20737472696E675265706C6163652873657269616C697A656448544D4C2C204552425F455850522424312C20272027293B0A2020202020207D0A0A20202020202072657475726E20747275737465645479706573';
wwv_flow_api.g_varchar2_table(514) := '506F6C6963792026262052455455524E5F545255535445445F54595045203F20747275737465645479706573506F6C6963792E63726561746548544D4C2873657269616C697A656448544D4C29203A2073657269616C697A656448544D4C3B0A20202020';
wwv_flow_api.g_varchar2_table(515) := '7D3B0A0A202020202F2A2A0A20202020202A205075626C6963206D6574686F6420746F207365742074686520636F6E66696775726174696F6E206F6E63650A20202020202A20736574436F6E6669670A20202020202A0A20202020202A2040706172616D';
wwv_flow_api.g_varchar2_table(516) := '207B4F626A6563747D2063666720636F6E66696775726174696F6E206F626A6563740A20202020202A2F0A20202020444F4D5075726966792E736574436F6E666967203D2066756E6374696F6E202863666729207B0A2020202020205F7061727365436F';
wwv_flow_api.g_varchar2_table(517) := '6E66696728636667293B0A2020202020205345545F434F4E464947203D20747275653B0A202020207D3B0A0A202020202F2A2A0A20202020202A205075626C6963206D6574686F6420746F2072656D6F76652074686520636F6E66696775726174696F6E';
wwv_flow_api.g_varchar2_table(518) := '0A20202020202A20636C656172436F6E6669670A20202020202A0A20202020202A2F0A20202020444F4D5075726966792E636C656172436F6E666967203D2066756E6374696F6E202829207B0A202020202020434F4E464947203D206E756C6C3B0A2020';
wwv_flow_api.g_varchar2_table(519) := '202020205345545F434F4E464947203D2066616C73653B0A202020207D3B0A0A202020202F2A2A0A20202020202A205075626C6963206D6574686F6420746F20636865636B20696620616E206174747269627574652076616C75652069732076616C6964';
wwv_flow_api.g_varchar2_table(520) := '2E0A20202020202A2055736573206C6173742073657420636F6E6669672C20696620616E792E204F74686572776973652C207573657320636F6E6669672064656661756C74732E0A20202020202A20697356616C69644174747269627574650A20202020';
wwv_flow_api.g_varchar2_table(521) := '202A0A20202020202A2040706172616D20207B737472696E677D2074616720546167206E616D65206F6620636F6E7461696E696E6720656C656D656E742E0A20202020202A2040706172616D20207B737472696E677D2061747472204174747269627574';
wwv_flow_api.g_varchar2_table(522) := '65206E616D652E0A20202020202A2040706172616D20207B737472696E677D2076616C7565204174747269627574652076616C75652E0A20202020202A204072657475726E207B426F6F6C65616E7D2052657475726E732074727565206966206076616C';
wwv_flow_api.g_varchar2_table(523) := '7565602069732076616C69642E204F74686572776973652C2072657475726E732066616C73652E0A20202020202A2F0A20202020444F4D5075726966792E697356616C6964417474726962757465203D2066756E6374696F6E20287461672C2061747472';
wwv_flow_api.g_varchar2_table(524) := '2C2076616C756529207B0A2020202020202F2A20496E697469616C697A652073686172656420636F6E6669672076617273206966206E65636573736172792E202A2F0A2020202020206966202821434F4E46494729207B0A20202020202020205F706172';
wwv_flow_api.g_varchar2_table(525) := '7365436F6E666967287B7D293B0A2020202020207D0A0A202020202020766172206C63546167203D20737472696E67546F4C6F7765724361736528746167293B0A202020202020766172206C634E616D65203D20737472696E67546F4C6F776572436173';
wwv_flow_api.g_varchar2_table(526) := '652861747472293B0A20202020202072657475726E205F697356616C6964417474726962757465286C635461672C206C634E616D652C2076616C7565293B0A202020207D3B0A0A202020202F2A2A0A20202020202A20416464486F6F6B0A20202020202A';
wwv_flow_api.g_varchar2_table(527) := '205075626C6963206D6574686F6420746F2061646420444F4D50757269667920686F6F6B730A20202020202A0A20202020202A2040706172616D207B537472696E677D20656E747279506F696E7420656E74727920706F696E7420666F72207468652068';
wwv_flow_api.g_varchar2_table(528) := '6F6F6B20746F206164640A20202020202A2040706172616D207B46756E6374696F6E7D20686F6F6B46756E6374696F6E2066756E6374696F6E20746F20657865637574650A20202020202A2F0A20202020444F4D5075726966792E616464486F6F6B203D';
wwv_flow_api.g_varchar2_table(529) := '2066756E6374696F6E2028656E747279506F696E742C20686F6F6B46756E6374696F6E29207B0A20202020202069662028747970656F6620686F6F6B46756E6374696F6E20213D3D202766756E6374696F6E2729207B0A20202020202020207265747572';
wwv_flow_api.g_varchar2_table(530) := '6E3B0A2020202020207D0A0A202020202020686F6F6B735B656E747279506F696E745D203D20686F6F6B735B656E747279506F696E745D207C7C205B5D3B0A20202020202061727261795075736828686F6F6B735B656E747279506F696E745D2C20686F';
wwv_flow_api.g_varchar2_table(531) := '6F6B46756E6374696F6E293B0A202020207D3B0A0A202020202F2A2A0A20202020202A2052656D6F7665486F6F6B0A20202020202A205075626C6963206D6574686F6420746F2072656D6F7665206120444F4D50757269667920686F6F6B206174206120';
wwv_flow_api.g_varchar2_table(532) := '676976656E20656E747279506F696E740A20202020202A2028706F70732069742066726F6D2074686520737461636B206F6620686F6F6B73206966206D6F7265206172652070726573656E74290A20202020202A0A20202020202A2040706172616D207B';
wwv_flow_api.g_varchar2_table(533) := '537472696E677D20656E747279506F696E7420656E74727920706F696E7420666F722074686520686F6F6B20746F2072656D6F76650A20202020202A2F0A20202020444F4D5075726966792E72656D6F7665486F6F6B203D2066756E6374696F6E202865';
wwv_flow_api.g_varchar2_table(534) := '6E747279506F696E7429207B0A20202020202069662028686F6F6B735B656E747279506F696E745D29207B0A20202020202020206172726179506F7028686F6F6B735B656E747279506F696E745D293B0A2020202020207D0A202020207D3B0A0A202020';
wwv_flow_api.g_varchar2_table(535) := '202F2A2A0A20202020202A2052656D6F7665486F6F6B730A20202020202A205075626C6963206D6574686F6420746F2072656D6F766520616C6C20444F4D50757269667920686F6F6B73206174206120676976656E20656E747279506F696E740A202020';
wwv_flow_api.g_varchar2_table(536) := '20202A0A20202020202A2040706172616D20207B537472696E677D20656E747279506F696E7420656E74727920706F696E7420666F722074686520686F6F6B7320746F2072656D6F76650A20202020202A2F0A20202020444F4D5075726966792E72656D';
wwv_flow_api.g_varchar2_table(537) := '6F7665486F6F6B73203D2066756E6374696F6E2028656E747279506F696E7429207B0A20202020202069662028686F6F6B735B656E747279506F696E745D29207B0A2020202020202020686F6F6B735B656E747279506F696E745D203D205B5D3B0A2020';
wwv_flow_api.g_varchar2_table(538) := '202020207D0A202020207D3B0A0A202020202F2A2A0A20202020202A2052656D6F7665416C6C486F6F6B730A20202020202A205075626C6963206D6574686F6420746F2072656D6F766520616C6C20444F4D50757269667920686F6F6B730A2020202020';
wwv_flow_api.g_varchar2_table(539) := '2A0A20202020202A2F0A20202020444F4D5075726966792E72656D6F7665416C6C486F6F6B73203D2066756E6374696F6E202829207B0A202020202020686F6F6B73203D207B7D3B0A202020207D3B0A0A2020202072657475726E20444F4D5075726966';
wwv_flow_api.g_varchar2_table(540) := '793B0A20207D0A0A202076617220707572696679203D20637265617465444F4D50757269667928293B0A0A202072657475726E207075726966793B0A0A7D29293B0A2F2F2320736F757263654D617070696E6755524C3D7075726966792E6A732E6D6170';
wwv_flow_api.g_varchar2_table(541) := '0A0A76617220756E6C65617368525445203D202866756E6374696F6E202829207B0A202020202275736520737472696374223B0A20202020766172207574696C203D207B0A20202020202020206665617475726544657461696C733A207B0A2020202020';
wwv_flow_api.g_varchar2_table(542) := '202020202020206E616D653A2022415045582D556E6C656173682D5269636854657874456469746F72222C0A20202020202020202020202073637269707456657273696F6E3A2022322E312E322E32222C0A2020202020202020202020207574696C5665';
wwv_flow_api.g_varchar2_table(543) := '7273696F6E3A2022312E36222C0A20202020202020202020202075726C3A202268747470733A2F2F6769746875622E636F6D2F526F6E6E795765697373222C0A2020202020202020202020206C6963656E73653A20224D4954220A20202020202020207D';
wwv_flow_api.g_varchar2_table(544) := '2C0A202020202020202065736361706548544D4C3A2066756E6374696F6E202873747229207B0A20202020202020202020202069662028737472203D3D3D206E756C6C29207B0A2020202020202020202020202020202072657475726E206E756C6C3B0A';
wwv_flow_api.g_varchar2_table(545) := '2020202020202020202020207D0A20202020202020202020202069662028747970656F6620737472203D3D3D2022756E646566696E65642229207B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(546) := '2020202020202020202069662028747970656F6620737472203D3D3D20226F626A6563742229207B0A20202020202020202020202020202020747279207B0A2020202020202020202020202020202020202020737472203D204A534F4E2E737472696E67';
wwv_flow_api.g_varchar2_table(547) := '69667928737472293B0A202020202020202020202020202020207D20636174636820286529207B0A20202020202020202020202020202020202020202F2A646F206E6F7468696E67202A2F0A202020202020202020202020202020207D0A202020202020';
wwv_flow_api.g_varchar2_table(548) := '2020202020207D0A20202020202020202020202072657475726E20617065782E7574696C2E65736361706548544D4C28537472696E672873747229293B0A20202020202020207D2C0A2020202020202020756E45736361706548544D4C3A2066756E6374';
wwv_flow_api.g_varchar2_table(549) := '696F6E202873747229207B0A20202020202020202020202069662028737472203D3D3D206E756C6C29207B0A2020202020202020202020202020202072657475726E206E756C6C3B0A2020202020202020202020207D0A20202020202020202020202069';
wwv_flow_api.g_varchar2_table(550) := '662028747970656F6620737472203D3D3D2022756E646566696E65642229207B0A2020202020202020202020202020202072657475726E3B0A2020202020202020202020207D0A20202020202020202020202069662028747970656F6620737472203D3D';
wwv_flow_api.g_varchar2_table(551) := '3D20226F626A6563742229207B0A20202020202020202020202020202020747279207B0A2020202020202020202020202020202020202020737472203D204A534F4E2E737472696E6769667928737472293B0A202020202020202020202020202020207D';
wwv_flow_api.g_varchar2_table(552) := '20636174636820286529207B0A20202020202020202020202020202020202020202F2A646F206E6F7468696E67202A2F0A202020202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020202020737472203D2053';
wwv_flow_api.g_varchar2_table(553) := '7472696E6728737472293B0A20202020202020202020202072657475726E207374720A202020202020202020202020202020202E7265706C616365282F26616D703B2F672C20222622290A202020202020202020202020202020202E7265706C61636528';
wwv_flow_api.g_varchar2_table(554) := '2F266C743B2F672C20223E22290A202020202020202020202020202020202E7265706C616365282F2667743B2F672C20223E22290A202020202020202020202020202020202E7265706C616365282F2671756F743B2F672C20225C2222290A2020202020';
wwv_flow_api.g_varchar2_table(555) := '20202020202020202020202E7265706C616365282F237832373B2F672C20222722290A202020202020202020202020202020202E7265706C616365282F26237832463B2F672C20225C5C22293B0A20202020202020207D2C0A20202020202020206C6F61';
wwv_flow_api.g_varchar2_table(556) := '6465723A207B0A20202020202020202020202073746172743A2066756E6374696F6E202869642C207365744D696E48656967687429207B0A20202020202020202020202020202020696620287365744D696E48656967687429207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(557) := '20202020202020202020202024286964292E63737328226D696E2D686569676874222C2022313030707822293B0A202020202020202020202020202020207D0A20202020202020202020202020202020617065782E7574696C2E73686F775370696E6E65';
wwv_flow_api.g_varchar2_table(558) := '72282428696429293B0A2020202020202020202020207D2C0A20202020202020202020202073746F703A2066756E6374696F6E202869642C2072656D6F76654D696E48656967687429207B0A202020202020202020202020202020206966202872656D6F';
wwv_flow_api.g_varchar2_table(559) := '76654D696E48656967687429207B0A202020202020202020202020202020202020202024286964292E63737328226D696E2D686569676874222C202222293B0A202020202020202020202020202020207D0A202020202020202020202020202020202428';
wwv_flow_api.g_varchar2_table(560) := '6964202B2022203E202E752D50726F63657373696E6722292E72656D6F766528293B0A2020202020202020202020202020202024286964202B2022203E202E63742D6C6F6164657222292E72656D6F766528293B0A2020202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(561) := '202020202020207D2C0A20202020202020206A736F6E53617665457874656E643A2066756E6374696F6E2028737263436F6E6669672C20746172676574436F6E66696729207B0A2020202020202020202020207661722066696E616C436F6E666967203D';
wwv_flow_api.g_varchar2_table(562) := '207B7D3B0A20202020202020202020202076617220746D704A534F4E203D207B7D3B0A2020202020202020202020202F2A2074727920746F20706172736520636F6E666967206A736F6E207768656E20737472696E67206F72206A75737420736574202A';
wwv_flow_api.g_varchar2_table(563) := '2F0A20202020202020202020202069662028747970656F6620746172676574436F6E666967203D3D3D2027737472696E672729207B0A20202020202020202020202020202020747279207B0A2020202020202020202020202020202020202020746D704A';
wwv_flow_api.g_varchar2_table(564) := '534F4E203D204A534F4E2E706172736528746172676574436F6E666967293B0A202020202020202020202020202020207D20636174636820286529207B0A2020202020202020202020202020202020202020617065782E64656275672E6572726F72287B';
wwv_flow_api.g_varchar2_table(565) := '0A202020202020202020202020202020202020202020202020226D6F64756C65223A20227574696C2E6A73222C0A202020202020202020202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F20706172';
wwv_flow_api.g_varchar2_table(566) := '736520746172676574436F6E6669672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E222C0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(567) := '2020202022657272223A20652C0A20202020202020202020202020202020202020202020202022746172676574436F6E666967223A20746172676574436F6E6669670A20202020202020202020202020202020202020207D293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(568) := '202020202020207D0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202020746D704A534F4E203D20242E657874656E6428747275652C207B7D2C20746172676574436F6E666967293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(569) := '20207D0A2020202020202020202020202F2A2074727920746F206D657267652077697468207374616E6461726420696620616E7920617474726962757465206973206D697373696E67202A2F0A202020202020202020202020747279207B0A2020202020';
wwv_flow_api.g_varchar2_table(570) := '202020202020202020202066696E616C436F6E666967203D20242E657874656E6428747275652C207B7D2C20737263436F6E6669672C20746D704A534F4E293B0A2020202020202020202020207D20636174636820286529207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(571) := '2020202020202066696E616C436F6E666967203D20242E657874656E6428747275652C207B7D2C20737263436F6E666967293B0A20202020202020202020202020202020617065782E64656275672E6572726F72287B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(572) := '20202020202020226D6F64756C65223A20227574696C2E6A73222C0A2020202020202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F206D657267652032204A534F4E7320696E746F207374616E6461';
wwv_flow_api.g_varchar2_table(573) := '7264204A534F4E20696620616E7920617474726962757465206973206D697373696E672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E222C0A';
wwv_flow_api.g_varchar2_table(574) := '202020202020202020202020202020202020202022657272223A20652C0A20202020202020202020202020202020202020202266696E616C436F6E666967223A2066696E616C436F6E6669670A202020202020202020202020202020207D293B0A202020';
wwv_flow_api.g_varchar2_table(575) := '2020202020202020207D0A20202020202020202020202072657475726E2066696E616C436F6E6669673B0A20202020202020207D2C0A202020202020202073706C6974537472696E673241727261793A2066756E6374696F6E202870537472696E672920';
wwv_flow_api.g_varchar2_table(576) := '7B0A20202020202020202020202069662028747970656F662070537472696E6720213D3D2022756E646566696E6564222026262070537472696E6720213D3D206E756C6C2026262070537472696E6720213D2022222026262070537472696E672E6C656E';
wwv_flow_api.g_varchar2_table(577) := '677468203E203029207B0A20202020202020202020202020202020696620286170657820262620617065782E73657276657220262620617065782E7365727665722E6368756E6B29207B0A20202020202020202020202020202020202020207265747572';
wwv_flow_api.g_varchar2_table(578) := '6E20617065782E7365727665722E6368756E6B2870537472696E67293B0A202020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020202F2A20617065782E7365727665722E6368756E6B206F6E6C79';
wwv_flow_api.g_varchar2_table(579) := '20617661696C206F6E20415045582031382E322B202A2F0A20202020202020202020202020202020202020207661722073706C697453697A65203D20383030303B0A202020202020202020202020202020202020202076617220746D7053706C69743B0A';
wwv_flow_api.g_varchar2_table(580) := '202020202020202020202020202020202020202076617220726574417272203D205B5D3B0A20202020202020202020202020202020202020206966202870537472696E672E6C656E677468203E2073706C697453697A6529207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(581) := '202020202020202020202020202020666F722028726574417272203D205B5D2C20746D7053706C6974203D20303B20746D7053706C6974203C2070537472696E672E6C656E6774683B29207265744172722E707573682870537472696E672E7375627374';
wwv_flow_api.g_varchar2_table(582) := '7228746D7053706C69742C2073706C697453697A6529292C20746D7053706C6974202B3D2073706C697453697A653B0A20202020202020202020202020202020202020202020202072657475726E207265744172720A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(583) := '2020202020207D0A20202020202020202020202020202020202020207265744172722E707573682870537472696E67293B0A202020202020202020202020202020202020202072657475726E207265744172723B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(584) := '207D0A2020202020202020202020207D20656C7365207B0A2020202020202020202020202020202072657475726E205B5D3B0A2020202020202020202020207D0A20202020202020207D0A202020207D3B0A0A2020202076617220646976417070656E64';
wwv_flow_api.g_varchar2_table(585) := '203D202428223C6469763E3C2F6469763E22293B0A0A202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0A20';
wwv_flow_api.g_varchar2_table(586) := '202020202A2A0A20202020202A2A205573656420746F20636C65616E757020696D61676520737263206265666F7265207274652069732073617665640A20202020202A2A0A20202020202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(587) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2020202066756E6374696F6E20636C65616E5570496D6167655372632870456469746F722C20704F70747329207B0A202020202020';
wwv_flow_api.g_varchar2_table(588) := '2020747279207B0A20202020202020202020202076617220646976203D202428223C6469763E3C2F6469763E22293B0A2020202020202020202020206469765B305D2E696E6E657248544D4C203D2070456469746F722E6765744461746128293B0A2020';
wwv_flow_api.g_varchar2_table(589) := '202020202020202020206469762E66696E642827696D675B616C742A3D2261696823225D27292E617474722822737263222C202261696822293B0A20202020202020202020202072657475726E206469765B305D2E696E6E657248544D4C3B0A20202020';
wwv_flow_api.g_varchar2_table(590) := '202020207D20636174636820286529207B0A202020202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022';
wwv_flow_api.g_varchar2_table(591) := '202D2022202B2022636C65616E5570496D616765537263222C0A20202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F20636C65616E757020696D61676520736F7572636520696E2064796E616D6963';
wwv_flow_api.g_varchar2_table(592) := '20616464656420696D6167657320696E207269636874657874656469746F722E222C0A2020202020202020202020202020202022657272223A20652C0A20202020202020202020202020202020226665617475726544657461696C73223A207574696C2E';
wwv_flow_api.g_varchar2_table(593) := '6665617475726544657461696C730A2020202020202020202020207D293B0A20202020202020207D0A202020207D0A0A202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(594) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0A20202020202A2A0A20202020202A2A205573656420746F20636C65616E757020696D61676520737263206265666F7265207274652069732073617665640A20202020202A2A0A2020202020';
wwv_flow_api.g_varchar2_table(595) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2020202066756E6374696F6E207570646174655570496D61676553';
wwv_flow_api.g_varchar2_table(596) := '72632870456469746F722C20704F7074732C2070436F6E29207B0A202020202020202076617220646976203D202428223C6469763E3C2F6469763E22293B0A2020202020202020766172206974656D73325375626D6974496D67446F776E203D20704F70';
wwv_flow_api.g_varchar2_table(597) := '74732E6974656D73325375626D6974496D67446F776E3B0A0A2020202020202020747279207B0A2020202020202020202020206469762E68746D6C2870436F6E293B0A20202020202020202020202076617220696D674974656D73203D206469762E6669';
wwv_flow_api.g_varchar2_table(598) := '6E642827696D675B616C742A3D2261696823225D27293B0A202020202020202020202020242E6561636828696D674974656D732C2066756E6374696F6E20286964782C20696D674974656D29207B0A202020202020202020202020202020207661722070';
wwv_flow_api.g_varchar2_table(599) := '6B203D20696D674974656D2E7469746C653B0A202020202020202020202020202020206966202821706B29207B0A2020202020202020202020202020202020202020706B203D20696D674974656D2E616C742E73706C69742822616968232322295B315D';
wwv_flow_api.g_varchar2_table(600) := '3B0A202020202020202020202020202020207D0A2020202020202020202020202020202069662028706B29207B0A202020202020202020202020202020202020202076617220696D67535243203D20617065782E7365727665722E706C7567696E55726C';
wwv_flow_api.g_varchar2_table(601) := '28704F7074732E616A617849442C207B0A2020202020202020202020202020202020202020202020207830313A20225052494E545F494D414745222C0A2020202020202020202020202020202020202020202020207830323A20706B2C0A202020202020';
wwv_flow_api.g_varchar2_table(602) := '202020202020202020202020202020202020706167654974656D733A206974656D73325375626D6974496D67446F776E0A20202020202020202020202020202020202020207D293B0A2020202020202020202020202020202020202020696D674974656D';
wwv_flow_api.g_varchar2_table(603) := '2E737263203D20696D675352433B0A202020202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202020617065782E64656275672E6572726F72287B0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(604) := '20202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20227570646174655570496D616765537263222C0A202020202020202020202020202020202020202020202020226D7367223A2022507269';
wwv_flow_api.g_varchar2_table(605) := '6D617279206B6579206F6620696D675B616C742A3D5C22616968235C225D206973206D697373696E67222C0A202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E666561747572654465';
wwv_flow_api.g_varchar2_table(606) := '7461696C730A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D0A2020202020202020202020207D293B0A0A2020202020202020202020202F2A20666F7263652073756220656C656D656E7473206E';
wwv_flow_api.g_varchar2_table(607) := '6F7420746F20627265616B206F7574206F662074686520726567696F6E2A2F0A2020202020202020202020206469760A202020202020202020202020202020202E66696E642822696D6722290A202020202020202020202020202020202E63737328226D';
wwv_flow_api.g_varchar2_table(608) := '61782D7769647468222C20223130302522290A202020202020202020202020202020202E63737328226F626A6563742D666974222C2022636F6E7461696E22290A202020202020202020202020202020202E63737328226F626A6563742D706F73697469';
wwv_flow_api.g_varchar2_table(609) := '6F6E222C202235302520302522293B0A0A202020202020202020202020696620286469765B305D2E696E6E657248544D4C29207B0A20202020202020202020202020202020617065782E64656275672E696E666F287B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(610) := '2020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20227570646174655570496D616765537263222C0A20202020202020202020202020202020202020202266696E616C5F65646974';
wwv_flow_api.g_varchar2_table(611) := '6F725F68746D6C5F6F6E5F6C6F6164223A206469765B305D2E696E6E657248544D4C2C0A2020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A202020202020';
wwv_flow_api.g_varchar2_table(612) := '202020202020202020207D293B0A0A2020202020202020202020202020202070456469746F722E73657444617461286469765B305D2E696E6E657248544D4C293B0A0A20202020202020202020202020202020617065782E64656275672E696E666F287B';
wwv_flow_api.g_varchar2_table(613) := '0A202020202020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20227570646174655570496D616765537263222C0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(614) := '2020202266696E616C5F656469746F725F6F6E5F6C6F6164223A2070456469746F722C0A2020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A202020202020';
wwv_flow_api.g_varchar2_table(615) := '202020202020202020207D293B0A2020202020202020202020207D0A2020202020202020202020206164644576656E7448616E646C65722870456469746F722C20704F707473293B0A20202020202020207D20636174636820286529207B0A2020202020';
wwv_flow_api.g_varchar2_table(616) := '20202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20227570646174655570496D6167655372';
wwv_flow_api.g_varchar2_table(617) := '63222C0A20202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F206C6F616420696D61676573207768656E206C6F6164696E672072696368207465787420656469746F722E222C0A2020202020202020';
wwv_flow_api.g_varchar2_table(618) := '202020202020202022657272223A20652C0A20202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A2020202020202020202020207D293B0A20202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(619) := '20207D0A0A202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0A20202020202A2A0A20202020202A2A205573';
wwv_flow_api.g_varchar2_table(620) := '656420746F20616464206E657720696D616765207769746820646F776E6C6F61642075726920746F207274650A20202020202A2A0A20202020202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(621) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2020202066756E6374696F6E20616464496D616765287046696C654E616D652C2070504B2C20704F7074732C2070496D61676553657474696E677329207B0A202020202020';
wwv_flow_api.g_varchar2_table(622) := '2020747279207B0A2020202020202020202020206966202870504B29207B0A20202020202020202020202020202020766172206974656D73325375626D6974496D67446F776E203D20704F7074732E6974656D73325375626D6974496D67446F776E3B0A';
wwv_flow_api.g_varchar2_table(623) := '202020202020202020202020202020207661722066696775726564203D202428223C6669677572653E3C2F6669677572653E22293B0A20202020202020202020202020202020666967757265642E6373732822746578742D616C69676E222C202263656E';
wwv_flow_api.g_varchar2_table(624) := '74657222293B0A20202020202020202020202020202020666967757265642E616464436C6173732822696D61676522293B0A0A2020202020202020202020202020202076617220696D67203D202428223C696D673E22293B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(625) := '2020202020696D672E617474722822616C74222C2022616968232322202B2070504B293B0A20202020202020202020202020202020696D672E6174747228227469746C65222C2070504B293B0A0A20202020202020202020202020202020747279207B0A';
wwv_flow_api.g_varchar2_table(626) := '20202020202020202020202020202020202020206966202870496D61676553657474696E67732E726174696F203C203129207B0A2020202020202020202020202020202020202020202020206966202870496D61676553657474696E67732E6865696768';
wwv_flow_api.g_varchar2_table(627) := '74203C20704F7074732E696D67576964746829207B0A20202020202020202020202020202020202020202020202020202020696D672E6174747228227769647468222C2070496D61676553657474696E67732E7769647468293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(628) := '20202020202020202020202020202020202020696D672E617474722822686569676874222C2070496D61676553657474696E67732E686569676874293B0A2020202020202020202020202020202020202020202020207D20656C7365207B0A2020202020';
wwv_flow_api.g_varchar2_table(629) := '2020202020202020202020202020202020202020202020696D672E617474722822686569676874222C204D6174682E666C6F6F7228704F7074732E696D67576964746829293B0A2020202020202020202020202020202020202020202020202020202069';
wwv_flow_api.g_varchar2_table(630) := '6D672E6174747228227769647468222C204D6174682E666C6F6F7228704F7074732E696D675769647468202A2070496D61676553657474696E67732E726174696F29293B0A2020202020202020202020202020202020202020202020207D0A2020202020';
wwv_flow_api.g_varchar2_table(631) := '2020202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202020202020206966202870496D61676553657474696E67732E7769647468203C20704F7074732E696D67576964746829207B0A20202020202020';
wwv_flow_api.g_varchar2_table(632) := '202020202020202020202020202020202020202020696D672E6174747228227769647468222C2070496D61676553657474696E67732E7769647468293B0A20202020202020202020202020202020202020202020202020202020696D672E617474722822';
wwv_flow_api.g_varchar2_table(633) := '686569676874222C2070496D61676553657474696E67732E686569676874293B0A2020202020202020202020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020202020202020202020696D672E6174';
wwv_flow_api.g_varchar2_table(634) := '747228227769647468222C204D6174682E666C6F6F7228704F7074732E696D67576964746829293B0A20202020202020202020202020202020202020202020202020202020696D672E617474722822686569676874222C204D6174682E666C6F6F722870';
wwv_flow_api.g_varchar2_table(635) := '4F7074732E696D675769647468202F2070496D61676553657474696E67732E726174696F29293B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(636) := '202020207D20636174636820286529207B0A2020202020202020202020202020202020202020617065782E64656275672E6572726F72287B0A20202020202020202020202020202020202020202020202022666374223A207574696C2E66656174757265';
wwv_flow_api.g_varchar2_table(637) := '44657461696C732E6E616D65202B2022202D2022202B2022616464496D616765222C0A202020202020202020202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F2063616C63756C61746520696D6167';
wwv_flow_api.g_varchar2_table(638) := '6520776964746820616E64206865696768742E222C0A20202020202020202020202020202020202020202020202022657272223A20652C0A202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574';
wwv_flow_api.g_varchar2_table(639) := '696C2E6665617475726544657461696C730A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202076617220696D67535243203D20617065782E7365727665';
wwv_flow_api.g_varchar2_table(640) := '722E706C7567696E55726C28704F7074732E616A617849442C207B0A20202020202020202020202020202020202020207830313A20225052494E545F494D414745222C0A20202020202020202020202020202020202020207830323A2070504B2C0A2020';
wwv_flow_api.g_varchar2_table(641) := '202020202020202020202020202020202020706167654974656D733A206974656D73325375626D6974496D67446F776E0A202020202020202020202020202020207D293B0A0A20202020202020202020202020202020696D672E61747472282273726322';
wwv_flow_api.g_varchar2_table(642) := '2C20696D67535243293B0A20202020202020202020202020202020666967757265642E617070656E6428696D67293B0A0A202020202020202020202020202020207661722066696743617074696F6E203D202428223C66696763617074696F6E3E3C2F66';
wwv_flow_api.g_varchar2_table(643) := '696763617074696F6E3E22293B0A2020202020202020202020202020202066696743617074696F6E2E74657874287046696C654E616D65293B0A20202020202020202020202020202020666967757265642E617070656E642866696743617074696F6E29';
wwv_flow_api.g_varchar2_table(644) := '3B0A0A2020202020202020202020202020202072657475726E20666967757265643B0A0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020';
wwv_flow_api.g_varchar2_table(645) := '20202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B2022616464496D616765222C0A2020202020202020202020202020202020202020226D7367223A20224E6F20707269';
wwv_flow_api.g_varchar2_table(646) := '6D617279206B65792073657420666F7220696D6167657320706C656173652C20736F20696D61676520636F756C64206E6F7420626520616464656420746F205254452E20506C6561736520636865636B20504C2F53514C20426C6F636B206966206F7574';
wwv_flow_api.g_varchar2_table(647) := '20706172616D65746572206973207365742E222C0A2020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A202020202020202020202020202020207D293B0A20';
wwv_flow_api.g_varchar2_table(648) := '20202020202020202020207D0A20202020202020207D20636174636820286529207B0A202020202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202022666374223A207574696C2E666561747572';
wwv_flow_api.g_varchar2_table(649) := '6544657461696C732E6E616D65202B2022202D2022202B2022616464496D616765222C0A20202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F2061646420696D6167657320696E746F207269636874';
wwv_flow_api.g_varchar2_table(650) := '657874656469746F7220776974682062696E61727920736F75726365732E222C0A2020202020202020202020202020202022657272223A20652C0A20202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665';
wwv_flow_api.g_varchar2_table(651) := '617475726544657461696C730A2020202020202020202020207D293B0A20202020202020207D0A202020207D0A0A202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(652) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0A20202020202A2A0A20202020202A2A205573656420746F2075706C6F616420616E64206D616E616765207468652062617365363420737472696E670A20202020202A2A0A20202020202A2A2A2A';
wwv_flow_api.g_varchar2_table(653) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2020202066756E6374696F6E2068616E646C65426173653634537472286261';
wwv_flow_api.g_varchar2_table(654) := '736536345374722C2066696C65547970652C2066696C654E616D652C206C61737446696C652C20704F7074732C2070456469746F7229207B0A2020202020202020766172206974656D73325375626D6974496D675570203D20704F7074732E6974656D73';
wwv_flow_api.g_varchar2_table(655) := '325375626D6974496D6755703B0A202020202020202076617220696D616765203D206E657720496D61676528293B0A0A2020202020202020696D6167652E737263203D2022646174613A22202B2066696C6554797065202B20223B6261736536342C2220';
wwv_flow_api.g_varchar2_table(656) := '2B206261736536345374723B0A0A202020202020202076617220626173653634417272203D207574696C2E73706C6974537472696E6732417272617928626173653634537472293B0A0A2020202020202020696D6167652E6F6E6C6F6164203D2066756E';
wwv_flow_api.g_varchar2_table(657) := '6374696F6E202829207B0A20202020202020202020202076617220696D61676553657474696E6773203D207B7D3B0A202020202020202020202020696D61676553657474696E67732E726174696F203D20746869732E7769647468202F20746869732E68';
wwv_flow_api.g_varchar2_table(658) := '65696768743B0A202020202020202020202020696D61676553657474696E67732E7769647468203D20746869732E77696474683B0A202020202020202020202020696D61676553657474696E67732E686569676874203D20746869732E6865696768743B';
wwv_flow_api.g_varchar2_table(659) := '0A0A202020202020202020202020617065782E64656275672E696E666F287B0A2020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B202275706C6F616446696C';
wwv_flow_api.g_varchar2_table(660) := '6573222C0A20202020202020202020202020202020226D7367223A202253746172742075706C6F6164206F662022202B2066696C654E616D65202B2022202822202B2066696C6554797065202B202229222C0A2020202020202020202020202020202022';
wwv_flow_api.g_varchar2_table(661) := '6665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A2020202020202020202020207D293B0A0A202020202020202020202020617065782E7365727665722E706C7567696E28704F7074732E616A617849442C207B';
wwv_flow_api.g_varchar2_table(662) := '0A202020202020202020202020202020207830313A202255504C4F41445F494D414745222C0A202020202020202020202020202020207830323A2066696C654E616D652C0A202020202020202020202020202020207830333A2066696C65547970652C0A';
wwv_flow_api.g_varchar2_table(663) := '202020202020202020202020202020206630313A206261736536344172722C0A20202020202020202020202020202020706167654974656D733A206974656D73325375626D6974496D6755700A2020202020202020202020207D2C207B0A202020202020';
wwv_flow_api.g_varchar2_table(664) := '20202020202020202020737563636573733A2066756E6374696F6E2028704461746129207B0A0A2020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(665) := '2022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B202275706C6F616446696C6573222C0A202020202020202020202020202020202020202020202020226D7367223A202255706C6F6164206F6620';
wwv_flow_api.g_varchar2_table(666) := '22202B2066696C654E616D65202B2022207375636365737366756C2E222C0A202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020';
wwv_flow_api.g_varchar2_table(667) := '202020202020202020202020207D293B0A0A2020202020202020202020202020202020202020646976417070656E642E617070656E6428616464496D6167652866696C654E616D652C2070446174612E706B2C20704F7074732C20696D61676553657474';
wwv_flow_api.g_varchar2_table(668) := '696E677329293B0A2020202020202020202020202020202020202020696620286C61737446696C6529207B0A20202020202020202020202020202020202020202020202069662028704F7074732E76657273696F6E203D3D3D203529207B0A2020202020';
wwv_flow_api.g_varchar2_table(669) := '20202020202020202020202020202020202020202020207661722076696577467261676D656E74203D2070456469746F722E646174612E70726F636573736F722E746F5669657728646976417070656E642E68746D6C2829293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(670) := '20202020202020202020202020202020202020766172206D6F64656C467261676D656E74203D2070456469746F722E646174612E746F4D6F64656C2876696577467261676D656E74293B0A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(671) := '20202070456469746F722E6D6F64656C2E696E73657274436F6E74656E74286D6F64656C467261676D656E742C2070456469746F722E6D6F64656C2E646F63756D656E742E73656C656374696F6E293B0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(672) := '20202020207D20656C7365207B0A2020202020202020202020202020202020202020202020202020202070456469746F722E696E7365727448746D6C28646976417070656E642E68746D6C2829293B0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(673) := '202020207D0A2020202020202020202020202020202020202020202020207574696C2E6C6F616465722E73746F7028704F7074732E616666456C656D656E74444956293B0A20202020202020202020202020202020202020202020202064697641707065';
wwv_flow_api.g_varchar2_table(674) := '6E64203D202428223C6469763E3C2F6469763E22293B0A20202020202020202020202020202020202020207D20656C7365207B0A202020202020202020202020202020202020202020202020646976417070656E642E617070656E6428223C703E266E62';
wwv_flow_api.g_varchar2_table(675) := '73703B3C2F703E22293B0A20202020202020202020202020202020202020207D0A0A2020202020202020202020202020202020202020617065782E6576656E742E7472696767657228704F7074732E616666456C656D656E7449442C2027696D61676575';
wwv_flow_api.g_varchar2_table(676) := '706C6F616469666E697368656427293B0A202020202020202020202020202020207D2C0A202020202020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29';
wwv_flow_api.g_varchar2_table(677) := '207B0A2020202020202020202020202020202020202020617065782E64656275672E6572726F72287B0A20202020202020202020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B20';
wwv_flow_api.g_varchar2_table(678) := '22202D2022202B202275706C6F616446696C6573222C0A202020202020202020202020202020202020202020202020226D7367223A2022496D6167652055706C6F6164206572726F72222C0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(679) := '226A71584852223A206A715848522C0A2020202020202020202020202020202020202020202020202274657874537461747573223A20746578745374617475732C0A202020202020202020202020202020202020202020202020226572726F725468726F';
wwv_flow_api.g_varchar2_table(680) := '776E223A206572726F725468726F776E2C0A202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(681) := '7D293B0A2020202020202020202020202020202020202020646976417070656E64203D202428223C6469763E3C2F6469763E22293B0A2020202020202020202020202020202020202020617065782E6576656E742E7472696767657228704F7074732E61';
wwv_flow_api.g_varchar2_table(682) := '6666456C656D656E7449442C2027696D61676575706C6F61646572726F7227293B0A202020202020202020202020202020207D0A2020202020202020202020207D293B0A20202020202020207D3B0A202020207D0A202020202F2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(683) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0A20202020202A2A0A20202020202A2A205573656420746F2075706C6F61642061206E65772069';
wwv_flow_api.g_varchar2_table(684) := '6D616765200A20202020202A2A0A20202020202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2020202066756E63';
wwv_flow_api.g_varchar2_table(685) := '74696F6E2075706C6F616446696C6573287046696C65732C2070456469746F722C20704F70747329207B0A202020202020202069662028217046696C6573207C7C207046696C65732E6C656E677468203D3D3D2030292072657475726E3B0A0A20202020';
wwv_flow_api.g_varchar2_table(686) := '2020202069662028704F7074732E73686F774C6F6164657229207B0A2020202020202020202020207574696C2E6C6F616465722E737461727428704F7074732E616666456C656D656E74444956293B0A20202020202020207D0A0A202020202020202074';
wwv_flow_api.g_varchar2_table(687) := '7279207B0A2020202020202020202020202F2F20506F6C7966696C6C20666F722049450A2020202020202020202020206966202877696E646F772E46696C6552656164657229207B0A2020202020202020202020202020202069662028747970656F6620';
wwv_flow_api.g_varchar2_table(688) := '46696C655265616465722E70726F746F747970652E72656164417342696E617279537472696E6720213D3D202766756E6374696F6E2729207B0A2020202020202020202020202020202020202020636F6E736F6C652E6C6F6728225761726E696E673A20';
wwv_flow_api.g_varchar2_table(689) := '5573696E672072656164417342696E617279537472696E6720706F6C7966696C6C22293B0A202020202020202020202020202020202020202046696C655265616465722E70726F746F747970652E72656164417342696E617279537472696E67203D2066';
wwv_flow_api.g_varchar2_table(690) := '756E6374696F6E2028626C6229207B0A20202020202020202020202020202020202020202020202076617220726561646572203D206E65772046696C6552656164657228293B0A2020202020202020202020202020202020202020202020207661722074';
wwv_flow_api.g_varchar2_table(691) := '686174203D20746869733B0A20202020202020202020202020202020202020202020202076617220636F6E766572736F72203D2066756E6374696F6E20286529207B0A202020202020202020202020202020202020202020202020202020207661722074';
wwv_flow_api.g_varchar2_table(692) := '6F436F6E76657274203D20652E7461726765742E726573756C74207C7C2027273B0A202020202020202020202020202020202020202020202020202020207661722062696E617279203D2027273B0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(693) := '20202020202020766172206279746573203D206E65772055696E7438417272617928746F436F6E76657274293B0A20202020202020202020202020202020202020202020202020202020766172206C656E677468203D2062797465732E627974654C656E';
wwv_flow_api.g_varchar2_table(694) := '6774683B0A202020202020202020202020202020202020202020202020202020207661722069203D202D313B0A202020202020202020202020202020202020202020202020202020207768696C6520282B2B69203C206C656E67746829207B0A20202020';
wwv_flow_api.g_varchar2_table(695) := '2020202020202020202020202020202020202020202020202020202062696E617279202B3D20537472696E672E66726F6D43686172436F64652862797465735B695D293B0A202020202020202020202020202020202020202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(696) := '2020202020202020202020202020202020202020202020202020207661722066203D207B7D3B0A20202020202020202020202020202020202020202020202020202020666F7220287661722070726F706572747920696E206529207B0A20202020202020';
wwv_flow_api.g_varchar2_table(697) := '202020202020202020202020202020202020202020202020206966202870726F706572747920213D20227461726765742229207B0A202020202020202020202020202020202020202020202020202020202020202020202020665B70726F70657274795D';
wwv_flow_api.g_varchar2_table(698) := '203D20655B70726F70657274795D3B0A20202020202020202020202020202020202020202020202020202020202020207D0A202020202020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(699) := '2020202020202020662E746172676574203D207B7D3B0A20202020202020202020202020202020202020202020202020202020666F7220287661722070726F706572747920696E20652E74617267657429207B0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(700) := '202020202020202020202020202020206966202870726F706572747920213D2022726573756C742229207B0A202020202020202020202020202020202020202020202020202020202020202020202020662E7461726765745B70726F70657274795D203D';
wwv_flow_api.g_varchar2_table(701) := '20652E7461726765745B70726F70657274795D3B0A20202020202020202020202020202020202020202020202020202020202020207D0A202020202020202020202020202020202020202020202020202020207D0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(702) := '20202020202020202020202020662E7461726765742E726573756C74203D2062696E6172793B0A20202020202020202020202020202020202020202020202020202020746861742E6F6E6C6F6164656E642866293B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(703) := '202020202020202020207D3B0A202020202020202020202020202020202020202020202020696620282128746869732E6F6E6C6F6164656E64203D3D3D20756E646566696E6564207C7C20746869732E6F6E6C6F6164656E64203D3D3D206E756C6C2929';
wwv_flow_api.g_varchar2_table(704) := '207B0A202020202020202020202020202020202020202020202020202020207265616465722E6F6E6C6F6164656E64203D20636F6E766572736F723B0A2020202020202020202020202020202020202020202020207D3B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(705) := '202020202020202020202020696620282128746869732E6F6E6572726F72203D3D3D20756E646566696E6564207C7C20746869732E6F6E6572726F72203D3D3D206E756C6C2929207B0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(706) := '20207265616465722E6F6E6572726F72203D20746869732E6F6E6572726F723B0A2020202020202020202020202020202020202020202020207D3B0A202020202020202020202020202020202020202020202020696620282128746869732E6F6E61626F';
wwv_flow_api.g_varchar2_table(707) := '7274203D3D3D20756E646566696E6564207C7C20746869732E6F6E61626F7274203D3D3D206E756C6C2929207B0A202020202020202020202020202020202020202020202020202020207265616465722E6F6E61626F7274203D20746869732E6F6E6162';
wwv_flow_api.g_varchar2_table(708) := '6F72743B0A2020202020202020202020202020202020202020202020207D3B0A202020202020202020202020202020202020202020202020696620282128746869732E6F6E6C6F61647374617274203D3D3D20756E646566696E6564207C7C2074686973';
wwv_flow_api.g_varchar2_table(709) := '2E6F6E6C6F61647374617274203D3D3D206E756C6C2929207B0A202020202020202020202020202020202020202020202020202020207265616465722E6F6E6C6F61647374617274203D20746869732E6F6E6C6F616473746172743B0A20202020202020';
wwv_flow_api.g_varchar2_table(710) := '20202020202020202020202020202020207D3B0A202020202020202020202020202020202020202020202020696620282128746869732E6F6E70726F6772657373203D3D3D20756E646566696E6564207C7C20746869732E6F6E70726F6772657373203D';
wwv_flow_api.g_varchar2_table(711) := '3D3D206E756C6C2929207B0A202020202020202020202020202020202020202020202020202020207265616465722E6F6E70726F6772657373203D20746869732E6F6E70726F67726573733B0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(712) := '207D3B0A202020202020202020202020202020202020202020202020696620282128746869732E6F6E6C6F6164203D3D3D20756E646566696E6564207C7C20746869732E6F6E6C6F6164203D3D3D206E756C6C2929207B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(713) := '202020202020202020202020202020207265616465722E6F6E6C6F6164203D20636F6E766572736F723B0A2020202020202020202020202020202020202020202020207D3B0A2020202020202020202020202020202020202020202020202F2F61626F72';
wwv_flow_api.g_varchar2_table(714) := '74206E6F7420696D706C656D656E746564202121210A2020202020202020202020202020202020202020202020207265616465722E726561644173417272617942756666657228626C62293B0A20202020202020202020202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(715) := '2020202020202020202020202020207D0A2020202020202020202020207D0A0A2020202020202020202020207661722066696C65494458203D20313B0A202020202020202020202020766172206C61737446696C65203D2066616C73653B0A0A20202020';
wwv_flow_api.g_varchar2_table(716) := '2020202020202020666F7220287661722069203D20303B2069203C207046696C65732E6C656E6774683B20692B2B29207B0A20202020202020202020202020202020696620287046696C65735B695D2E747970652E696E6465784F662822696D61676522';
wwv_flow_api.g_varchar2_table(717) := '2920213D3D202D3129207B0A20202020202020202020202020202020202020207661722066696C65203D207046696C65735B695D3B0A0A2020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A20202020202020';
wwv_flow_api.g_varchar2_table(718) := '202020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B202275706C6F616446696C6573222C0A2020202020202020202020202020202020202020202020202266';
wwv_flow_api.g_varchar2_table(719) := '696C65223A2066696C652C0A202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020202020202020202020202020207D293B0A0A20';
wwv_flow_api.g_varchar2_table(720) := '2020202020202020202020202020202020202076617220726561646572203D206E65772046696C6552656164657228293B0A20202020202020202020202020202020202020207265616465722E6F6E6C6F6164656E64203D202866756E6374696F6E2028';
wwv_flow_api.g_varchar2_table(721) := '7046696C6529207B0A20202020202020202020202020202020202020202020202072657475726E2066756E6374696F6E2028704576656E7429207B0A20202020202020202020202020202020202020202020202020202020766172206261736536345374';
wwv_flow_api.g_varchar2_table(722) := '72203D2062746F6128704576656E742E7461726765742E726573756C74293B0A20202020202020202020202020202020202020202020202020202020696620287046696C65732E6C656E677468203D3D2066696C6549445829207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(723) := '2020202020202020202020202020202020202020202020206C61737446696C65203D20747275653B0A202020202020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020202020202068';
wwv_flow_api.g_varchar2_table(724) := '616E646C65426173653634537472286261736536345374722C207046696C652E747970652C207046696C652E6E616D652C206C61737446696C652C20704F7074732C2070456469746F72293B0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(725) := '202020202066696C654944582B2B3B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D292866696C65293B0A20202020202020202020202020202020202020207265616465722E72';
wwv_flow_api.g_varchar2_table(726) := '656164417342696E617279537472696E672866696C65293B0A0A202020202020202020202020202020207D20656C7365206966202866696C65494458203D3D207046696C65732E6C656E67746829207B0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(727) := '207574696C2E6C6F616465722E73746F7028704F7074732E616666456C656D656E74444956293B0A202020202020202020202020202020202020202066696C654944582B2B3B0A202020202020202020202020202020207D0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(728) := '207D0A20202020202020207D20636174636820286529207B0A202020202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E';
wwv_flow_api.g_varchar2_table(729) := '616D65202B2022202D2022202B202275706C6F616446696C6573222C0A20202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F2061646420696D6167657320746F20746F206462206166746572206472';
wwv_flow_api.g_varchar2_table(730) := '6F70206F7220706173746520696D616765222C0A2020202020202020202020202020202022657272223A20652C0A20202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A';
wwv_flow_api.g_varchar2_table(731) := '2020202020202020202020207D293B0A20202020202020207D0A202020207D0A0A202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(732) := '2A2A2A2A2A2A2A2A2A0A20202020202A2A0A20202020202A2A205573656420746F20616464206576656E742068616E646C657220666F72206472616720616E642070617374650A20202020202A2A0A20202020202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(733) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2020202066756E6374696F6E206164644576656E7448616E646C65722870456469746F722C20704F707473';
wwv_flow_api.g_varchar2_table(734) := '29207B0A2020202020202020747279207B0A2020202020202020202020202F2A206F6E2064726F7020696D616765202A2F0A20202020202020202020202069662028704F7074732E76657273696F6E203D3D3D203529207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(735) := '202020202070456469746F722E65646974696E672E766965772E646F63756D656E742E6F6E282764726F70272C2066756E6374696F6E2028652C206461746129207B0A2020202020202020202020202020202020202020646174612E70726576656E7444';
wwv_flow_api.g_varchar2_table(736) := '656661756C742874727565293B0A2020202020202020202020202020202020202020652E73746F7028293B0A0A2020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(737) := '2020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20226164644576656E7448616E646C6572222C0A202020202020202020202020202020202020202020202020226D7367223A2022';
wwv_flow_api.g_varchar2_table(738) := '46696C652064726F70706564202D20763578222C0A202020202020202020202020202020202020202020202020226576656E74223A20652C0A2020202020202020202020202020202020202020202020202264617461223A20646174612C0A2020202020';
wwv_flow_api.g_varchar2_table(739) := '20202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020202020202020202020202020207D293B0A0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(740) := '2020766172206474203D20646174612E646174615472616E736665723B0A202020202020202020202020202020202020202075706C6F616446696C65732864742E66696C65732C2070456469746F722C20704F707473293B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(741) := '20202020207D293B0A0A202020202020202020202020202020202F2A206F6E207061746520696D61676520652E672E2053637265656E73686F74202A2F0A2020202020202020202020202020202070456469746F722E65646974696E672E766965772E64';
wwv_flow_api.g_varchar2_table(742) := '6F63756D656E742E6F6E28227061737465222C2066756E6374696F6E2028652C206461746129207B0A2020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(743) := '20202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20226164644576656E7448616E646C6572222C0A202020202020202020202020202020202020202020202020226D7367223A202246696C65';
wwv_flow_api.g_varchar2_table(744) := '20706173746564202D20763578222C0A202020202020202020202020202020202020202020202020226576656E74223A20652C0A2020202020202020202020202020202020202020202020202264617461223A20646174612C0A20202020202020202020';
wwv_flow_api.g_varchar2_table(745) := '2020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020202020202020202020202020207D293B0A0A2020202020202020202020202020202020202020696620';
wwv_flow_api.g_varchar2_table(746) := '28646174612E64617456616C756520262620646174612E6461746156616C75652E696E6465784F6628227372633D5C22646174613A696D6167652F2229203E203020262620646174612E6461746156616C75652E696E6465784F6628223B626173653634';
wwv_flow_api.g_varchar2_table(747) := '2C2229203E203029207B0A202020202020202020202020202020202020202020202020646174612E70726576656E7444656661756C742874727565293B0A202020202020202020202020202020202020202020202020652E73746F7028293B0A0A202020';
wwv_flow_api.g_varchar2_table(748) := '202020202020202020202020202020202020202020766172206265666F72655265706C203D20227372633D5C22646174613A223B0A202020202020202020202020202020202020202020202020766172206236345265706C203D20226261736536342C22';
wwv_flow_api.g_varchar2_table(749) := '3B0A2020202020202020202020202020202020202020202020207661722066696C65547970655265706C203D2022696D6167652F223B0A0A20202020202020202020202020202020202020202020202076617220737472203D20646174612E6461746156';
wwv_flow_api.g_varchar2_table(750) := '616C75653B0A202020202020202020202020202020202020202020202020737472203D207374722E737562737472696E67287374722E696E6465784F66286265666F72655265706C29202B206265666F72655265706C2E6C656E677468293B0A20202020';
wwv_flow_api.g_varchar2_table(751) := '2020202020202020202020202020202020202020737472203D207374722E73706C697428225C2222295B305D3B0A2020202020202020202020202020202020202020202020207661722066696C6554797065203D207374722E73706C697428223B22295B';
wwv_flow_api.g_varchar2_table(752) := '305D3B0A2020202020202020202020202020202020202020202020207661722066696C65456E64203D2066696C65547970652E737562737472696E672866696C65547970652E696E6465784F662866696C65547970655265706C29202B2066696C655479';
wwv_flow_api.g_varchar2_table(753) := '70655265706C2E6C656E677468293B0A202020202020202020202020202020202020202020202020737472203D207374722E737562737472696E67287374722E696E6465784F66286236345265706C29202B206236345265706C2E6C656E677468293B0A';
wwv_flow_api.g_varchar2_table(754) := '202020202020202020202020202020202020202020202020766172206D7944617465203D206E6577204461746528293B0A2020202020202020202020202020202020202020202020207661722066696C654E616D65203D2022696D6167652D22202B206D';
wwv_flow_api.g_varchar2_table(755) := '79446174652E746F49534F537472696E672829202B20222E22202B2066696C65456E640A0A202020202020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(756) := '2020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20226164644576656E7448616E646C6572222C0A2020202020202020202020202020202020202020202020202020202022646174';
wwv_flow_api.g_varchar2_table(757) := '612E6461746156616C7565223A20646174612E6461746156616C75652C0A2020202020202020202020202020202020202020202020202020202022626173653634537472223A207374722C0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(758) := '202020202266696C6554797065223A2066696C65547970652C0A202020202020202020202020202020202020202020202020202020202266696C654E616D65223A2066696C654E616D652C0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(759) := '20202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A2020202020202020202020202020202020202020202020207D293B0A0A2020202020202020202020202020202020202020202020207661722064';
wwv_flow_api.g_varchar2_table(760) := '6976203D202428223C6469763E3C2F6469763E22293B0A20202020202020202020202020202020202020202020202068616E646C65426173653634537472287374722C2066696C65547970652C2066696C654E616D652C20747275652C20704F7074732C';
wwv_flow_api.g_varchar2_table(761) := '2070456469746F72293B0A20202020202020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020202020202069662028646174612E646174615472616E736665722E66696C657320262620646174612E';
wwv_flow_api.g_varchar2_table(762) := '646174615472616E736665722E66696C65732E6C656E677468203E203029207B0A20202020202020202020202020202020202020202020202020202020646174612E70726576656E7444656661756C742874727565293B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(763) := '20202020202020202020202020202020652E73746F7028293B0A202020202020202020202020202020202020202020202020202020207661722066696C6573203D205B5D3B0A202020202020202020202020202020202020202020202020202020206669';
wwv_flow_api.g_varchar2_table(764) := '6C65732E7075736828646174612E646174615472616E736665722E66696C65735B305D293B0A2020202020202020202020202020202020202020202020202020202075706C6F616446696C65732866696C65732C2070456469746F722C20704F70747329';
wwv_flow_api.g_varchar2_table(765) := '3B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D293B0A2020202020202020202020207D20656C7365207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(766) := '2020202020202070456469746F722E646F63756D656E742E6F6E282764726F70272C2066756E6374696F6E20286529207B0A2020202020202020202020202020202020202020652E646174612E70726576656E7444656661756C742874727565293B0A20';
wwv_flow_api.g_varchar2_table(767) := '20202020202020202020202020202020202020652E63616E63656C28293B0A2020202020202020202020202020202020202020652E73746F7028293B0A0A2020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A';
wwv_flow_api.g_varchar2_table(768) := '20202020202020202020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20226164644576656E7448616E646C6572222C0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(769) := '202020202020202020226D7367223A202246696C652064726F70706564202D20763478222C0A202020202020202020202020202020202020202020202020226576656E74223A20652C0A2020202020202020202020202020202020202020202020202266';
wwv_flow_api.g_varchar2_table(770) := '65617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020202020202020202020202020207D293B0A0A2020202020202020202020202020202020202020766172206474203D20652E646174612E242E64';
wwv_flow_api.g_varchar2_table(771) := '6174615472616E736665723B0A202020202020202020202020202020202020202075706C6F616446696C65732864742E66696C65732C2070456469746F722C20704F707473293B0A202020202020202020202020202020207D293B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(772) := '2020202020202020202F2A206F6E207061746520696D61676520652E672E2053637265656E73686F74202A2F0A2020202020202020202020202020202070456469746F722E6F6E28227061737465222C2066756E6374696F6E20286529207B0A20202020';
wwv_flow_api.g_varchar2_table(773) := '20202020202020202020202020202020617065782E64656275672E696E666F287B0A20202020202020202020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20';
wwv_flow_api.g_varchar2_table(774) := '226164644576656E7448616E646C6572222C0A202020202020202020202020202020202020202020202020226D7367223A202246696C6520706173746564202D20763478222C0A202020202020202020202020202020202020202020202020226576656E';
wwv_flow_api.g_varchar2_table(775) := '74223A20652C0A202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020202020202020202020202020207D293B0A0A202020202020';
wwv_flow_api.g_varchar2_table(776) := '202020202020202020202020202069662028652E6461746120262620652E646174612E6461746156616C756520262620652E646174612E6461746156616C75652E696E6465784F6628227372633D5C22646174613A696D6167652F2229203E2030202626';
wwv_flow_api.g_varchar2_table(777) := '20652E646174612E6461746156616C75652E696E6465784F6628223B6261736536342C2229203E203029207B0A202020202020202020202020202020202020202020202020652E73746F7028293B0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(778) := '202020652E63616E63656C28293B0A0A202020202020202020202020202020202020202020202020766172206265666F72655265706C203D20227372633D5C22646174613A223B0A20202020202020202020202020202020202020202020202076617220';
wwv_flow_api.g_varchar2_table(779) := '6236345265706C203D20226261736536342C223B0A2020202020202020202020202020202020202020202020207661722066696C65547970655265706C203D2022696D6167652F223B0A0A20202020202020202020202020202020202020202020202076';
wwv_flow_api.g_varchar2_table(780) := '617220737472203D20652E646174612E6461746156616C75653B0A202020202020202020202020202020202020202020202020737472203D207374722E737562737472696E67287374722E696E6465784F66286265666F72655265706C29202B20626566';
wwv_flow_api.g_varchar2_table(781) := '6F72655265706C2E6C656E677468293B0A202020202020202020202020202020202020202020202020737472203D207374722E73706C697428225C2222295B305D3B0A2020202020202020202020202020202020202020202020207661722066696C6554';
wwv_flow_api.g_varchar2_table(782) := '797065203D207374722E73706C697428223B22295B305D3B0A2020202020202020202020202020202020202020202020207661722066696C65456E64203D2066696C65547970652E737562737472696E672866696C65547970652E696E6465784F662866';
wwv_flow_api.g_varchar2_table(783) := '696C65547970655265706C29202B2066696C65547970655265706C2E6C656E677468293B0A202020202020202020202020202020202020202020202020737472203D207374722E737562737472696E67287374722E696E6465784F66286236345265706C';
wwv_flow_api.g_varchar2_table(784) := '29202B206236345265706C2E6C656E677468293B0A202020202020202020202020202020202020202020202020766172206D7944617465203D206E6577204461746528293B0A202020202020202020202020202020202020202020202020766172206669';
wwv_flow_api.g_varchar2_table(785) := '6C654E616D65203D2022696D6167652D22202B206D79446174652E746F49534F537472696E672829202B20222E22202B2066696C65456E640A0A202020202020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A';
wwv_flow_api.g_varchar2_table(786) := '2020202020202020202020202020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20226164644576656E7448616E646C6572222C0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(787) := '202020202020202020202020202020202022652E646174612E6461746156616C7565223A20652E646174612E6461746156616C75652C0A2020202020202020202020202020202020202020202020202020202022626173653634537472223A207374722C';
wwv_flow_api.g_varchar2_table(788) := '0A202020202020202020202020202020202020202020202020202020202266696C6554797065223A2066696C65547970652C0A202020202020202020202020202020202020202020202020202020202266696C654E616D65223A2066696C654E616D652C';
wwv_flow_api.g_varchar2_table(789) := '0A20202020202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A2020202020202020202020202020202020202020202020207D293B0A2020202020';
wwv_flow_api.g_varchar2_table(790) := '2020202020202020202020202020202020202076617220646976203D202428223C6469763E3C2F6469763E22293B0A20202020202020202020202020202020202020202020202068616E646C65426173653634537472287374722C2066696C6554797065';
wwv_flow_api.g_varchar2_table(791) := '2C2066696C654E616D652C20747275652C20704F7074732C2070456469746F72293B0A20202020202020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020202020202069662028652E646174612E64';
wwv_flow_api.g_varchar2_table(792) := '6174615472616E736665722E5F2E66696C657320262620652E646174612E646174615472616E736665722E5F2E66696C65732E6C656E677468203E203029207B0A20202020202020202020202020202020202020202020202020202020652E73746F7028';
wwv_flow_api.g_varchar2_table(793) := '293B0A20202020202020202020202020202020202020202020202020202020652E63616E63656C28293B0A202020202020202020202020202020202020202020202020202020207661722066696C6573203D205B5D3B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(794) := '20202020202020202020202020202066696C65732E7075736828652E646174612E646174615472616E736665722E5F2E66696C65735B305D293B0A2020202020202020202020202020202020202020202020202020202075706C6F616446696C65732866';
wwv_flow_api.g_varchar2_table(795) := '696C65732C2070456469746F722C20704F707473293B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(796) := '2020207D0A20202020202020207D20636174636820286529207B0A202020202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C73';
wwv_flow_api.g_varchar2_table(797) := '2E6E616D65202B2022202D2022202B20226164644576656E7448616E646C6572222C0A20202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F2070617374652064726F70206F72207061737465642063';
wwv_flow_api.g_varchar2_table(798) := '6F6E74656E7420696E20525445222C0A2020202020202020202020202020202022657272223A20652C0A20202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020';
wwv_flow_api.g_varchar2_table(799) := '20202020202020207D293B0A20202020202020207D0A202020207D0A0A202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(800) := '2A2A2A2A2A0A20202020202A2A0A20202020202A2A205573656420746F2073616E6974697A652048544D4C0A20202020202A2A0A20202020202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(801) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2020202066756E6374696F6E2073616E6974697A65434C4F422870434C4F422C20704F70747329207B0A202020202020202072657475726E20444F4D5075726966792E73616E';
wwv_flow_api.g_varchar2_table(802) := '6974697A652870434C4F422C20704F7074732E73616E6974697A654F7074696F6E73293B0A202020207D0A0A202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(803) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0A20202020202A2A0A20202020202A2A205573656420676F2067657420656469746F72206F626A20666F7220646966666572656E742076657273696F6E730A20202020202A2A0A20202020202A2A2A2A';
wwv_flow_api.g_varchar2_table(804) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2020202066756E6374696F6E20676574456469746F72287045656D656E7429';
wwv_flow_api.g_varchar2_table(805) := '207B0A20202020202020207661722073656C5175657279203D20222322202B207045656D656E74202B20225F434F4E5441494E4552202E636B2D656469746F725F5F6564697461626C65223B0A0A2020202020202020617065782E64656275672E696E66';
wwv_flow_api.g_varchar2_table(806) := '6F287B0A20202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B2022676574456469746F72222C0A2020202020202020202020202273656C5175657279223A2073656C5175';
wwv_flow_api.g_varchar2_table(807) := '6572792C0A202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020207D293B0A0A202020202020202076617220646F6D456C203D20646F63756D656E742E717565';
wwv_flow_api.g_varchar2_table(808) := '727953656C6563746F722873656C5175657279293B0A202020202020202069662028646F6D456C20262620646F6D456C2E636B656469746F72496E7374616E636529207B0A20202020202020202020202072657475726E20646F6D456C2E636B65646974';
wwv_flow_api.g_varchar2_table(809) := '6F72496E7374616E63653B0A20202020202020207D20656C73652069662028434B454449544F5220262620434B454449544F522E696E7374616E63657329207B0A20202020202020202020202072657475726E20434B454449544F522E696E7374616E63';
wwv_flow_api.g_varchar2_table(810) := '65735B7045656D656E745D3B0A20202020202020207D20656C7365207B0A202020202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202022666374223A207574696C2E6665617475726544657461';
wwv_flow_api.g_varchar2_table(811) := '696C732E6E616D65202B2022202D2022202B2022676574456469746F72222C0A20202020202020202020202020202020226D7367223A20224E6F20434B4520456469746F7220666F756E6421222C0A202020202020202020202020202020202273656C51';
wwv_flow_api.g_varchar2_table(812) := '75657279223A2073656C51756572792C0A20202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A2020202020202020202020207D293B0A20202020202020207D0A202020';
wwv_flow_api.g_varchar2_table(813) := '207D0A0A202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0A20202020202A2A0A20202020202A2A20557365';
wwv_flow_api.g_varchar2_table(814) := '6420746F207072696E742074686520636C6F622076616C756520746F2074686520656C656D656E747320746861742061726520696E2064617461206A736F6E0A20202020202A2A0A20202020202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(815) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A2020202066756E6374696F6E207072696E74436C6F622870546869732C2070446174612C20704F70747329207B0A20202020';
wwv_flow_api.g_varchar2_table(816) := '20202020747279207B0A202020202020202020202020766172207374723B0A0A2020202020202020202020206966202870446174612026262070446174612E726F772026262070446174612E726F775B305D2026262070446174612E726F775B305D2E43';
wwv_flow_api.g_varchar2_table(817) := '4C4F425F56414C554529207B0A20202020202020202020202020202020737472203D2070446174612E726F775B305D2E434C4F425F56414C55453B0A2020202020202020202020207D0A0A2020202020202020202020206966202821704F7074732E7361';
wwv_flow_api.g_varchar2_table(818) := '6E6974697A6529207B0A20202020202020202020202020202020737472203D207374723B0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202020737472203D2073616E6974697A65434C4F42287374722C20704F';
wwv_flow_api.g_varchar2_table(819) := '707473293B0A2020202020202020202020207D0A0A20202020202020202020202069662028704F7074732E65736361706548544D4C29207B0A20202020202020202020202020202020737472203D207574696C2E65736361706548544D4C28737472293B';
wwv_flow_api.g_varchar2_table(820) := '0A2020202020202020202020207D0A20202020202020202020202076617220616666434B45203D20676574456469746F7228704F7074732E616666456C656D656E74293B0A20202020202020202020202069662028616666434B4529207B0A0A20202020';
wwv_flow_api.g_varchar2_table(821) := '202020202020202020202020617065782E64656275672E696E666F287B0A202020202020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20227072696E74436C';
wwv_flow_api.g_varchar2_table(822) := '6F62222C0A202020202020202020202020202020202020202022656469746F72223A20616666434B452C0A2020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C73';
wwv_flow_api.g_varchar2_table(823) := '0A202020202020202020202020202020207D293B0A0A2020202020202020202020202020202066756E6374696F6E20737461727449742829207B0A20202020202020202020202020202020202020207570646174655570496D6167655372632861666643';
wwv_flow_api.g_varchar2_table(824) := '4B452C20704F7074732C20737472293B0A20202020202020202020202020202020202020207574696C2E6C6F616465722E73746F7028704F7074732E616666456C656D656E74444956293B0A202020202020202020202020202020202020202061706578';
wwv_flow_api.g_varchar2_table(825) := '2E6576656E742E7472696767657228704F7074732E616666456C656D656E7449442C2027636C6F626C6F616466696E697368656427293B0A2020202020202020202020202020202020202020617065782E64612E726573756D652870546869732E726573';
wwv_flow_api.g_varchar2_table(826) := '756D6543616C6C6261636B2C2066616C7365293B0A2020202020202020202020202020202020202020616666434B452E6F6E2827636F6E74656E74446F6D272C2066756E6374696F6E202829207B0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(827) := '2020206164644576656E7448616E646C657228616666434B452C20704F707473293B0A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202069662028704F';
wwv_flow_api.g_varchar2_table(828) := '7074732E76657273696F6E203D3D3D203529207B0A20202020202020202020202020202020202020207374617274497428293B0A202020202020202020202020202020207D20656C73652069662028616666434B452E696E7374616E6365526561647920';
wwv_flow_api.g_varchar2_table(829) := '3D3D3D207472756529207B0A20202020202020202020202020202020202020207374617274497428293B0A2020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(830) := '202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20227072696E74436C6F62222C0A202020202020202020202020202020202020202020202020226D7367223A2022737461727420696E';
wwv_flow_api.g_varchar2_table(831) := '7374616E636520776173207265616479222C0A202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(832) := '207D293B0A202020202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202020616666434B452E6F6E2827696E7374616E63655265616479272C2066756E6374696F6E202829207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(833) := '2020202020202020202020202020207374617274497428293B0A202020202020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A2020202020202020202020202020202020202020202020202020202022666374';
wwv_flow_api.g_varchar2_table(834) := '223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20227072696E74436C6F62222C0A20202020202020202020202020202020202020202020202020202020226D7367223A20227374617274206F6E20696E7374';
wwv_flow_api.g_varchar2_table(835) := '616E6365207265616479222C0A20202020202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(836) := '2020207D293B0A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A20202020202020207D20636174636820286529207B0A2020202020202020202020206170';
wwv_flow_api.g_varchar2_table(837) := '65782E64656275672E6572726F72287B0A2020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B20227072696E74436C6F62222C0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(838) := '20202020226D7367223A20224572726F72207768696C652072656E64657220434C4F42222C0A2020202020202020202020202020202022657272223A20652C0A20202020202020202020202020202020226665617475726544657461696C73223A207574';
wwv_flow_api.g_varchar2_table(839) := '696C2E6665617475726544657461696C730A2020202020202020202020207D293B0A202020202020202020202020617065782E6576656E742E7472696767657228704F7074732E616666456C656D656E7449442C2027636C6F626C6F61646572726F7227';
wwv_flow_api.g_varchar2_table(840) := '293B0A202020202020202020202020617065782E64612E726573756D652870546869732E726573756D6543616C6C6261636B2C2074727565293B0A20202020202020207D0A202020207D0A0A202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(841) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0A20202020202A2A0A20202020202A2A205573656420746F2075706C6F61642074686520636C6F622076616C75652066';
wwv_flow_api.g_varchar2_table(842) := '726F6D20616E206974656D20746F2064617461626173650A20202020202A2A0A20202020202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(843) := '2A2A2A2A2A2A2A2A2F0A2020202066756E6374696F6E2075706C6F6164436C6F622870546869732C20704F70747329207B0A202020202020202076617220656469203D20676574456469746F7228704F7074732E616666456C656D656E74293B0A202020';
wwv_flow_api.g_varchar2_table(844) := '20202020206966202865646929207B0A20202020202020202020202076617220636C6F62203D20636C65616E5570496D616765537263286564692C20704F707473293B0A0A20202020202020202020202069662028704F7074732E756E45736361706548';
wwv_flow_api.g_varchar2_table(845) := '544D4C29207B0A20202020202020202020202020202020636C6F62203D207574696C2E756E45736361706548544D4C28636C6F62293B0A2020202020202020202020207D0A0A20202020202020202020202069662028704F7074732E73616E6974697A65';
wwv_flow_api.g_varchar2_table(846) := '29207B0A20202020202020202020202020202020636C6F62203D2073616E6974697A65434C4F4228636C6F622C20704F707473293B0A2020202020202020202020207D0A0A202020202020202020202020766172206368756E6B417272203D207574696C';
wwv_flow_api.g_varchar2_table(847) := '2E73706C6974537472696E6732417272617928636C6F62293B0A0A202020202020202020202020766172206974656D73325375626D6974203D20704F7074732E6974656D73325375626D69743B0A202020202020202020202020617065782E7365727665';
wwv_flow_api.g_varchar2_table(848) := '722E706C7567696E28704F7074732E616A617849442C207B0A202020202020202020202020202020207830313A202255504C4F41445F434C4F42222C0A202020202020202020202020202020206630313A206368756E6B4172722C0A2020202020202020';
wwv_flow_api.g_varchar2_table(849) := '2020202020202020706167654974656D733A206974656D73325375626D69740A2020202020202020202020207D2C207B0A2020202020202020202020202020202064617461547970653A202274657874222C0A2020202020202020202020202020202073';
wwv_flow_api.g_varchar2_table(850) := '7563636573733A2066756E6374696F6E2028704461746129207B0A20202020202020202020202020202020202020207574696C2E6C6F616465722E73746F7028704F7074732E616666456C656D656E74444956293B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(851) := '202020202020617065782E64656275672E696E666F287B0A20202020202020202020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B202275706C6F6164436C6F';
wwv_flow_api.g_varchar2_table(852) := '62222C0A202020202020202020202020202020202020202020202020226D7367223A2022436C6F622055706C6F6164207375636365737366756C222C0A202020202020202020202020202020202020202020202020226665617475726544657461696C73';
wwv_flow_api.g_varchar2_table(853) := '223A207574696C2E6665617475726544657461696C730A20202020202020202020202020202020202020207D293B0A2020202020202020202020202020202020202020617065782E6576656E742E7472696767657228704F7074732E616666456C656D65';
wwv_flow_api.g_varchar2_table(854) := '6E7449442C2027636C6F627361766566696E697368656427293B0A2020202020202020202020202020202020202020617065782E64612E726573756D652870546869732E726573756D6543616C6C6261636B2C2066616C7365293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(855) := '20202020202020207D2C0A202020202020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0A20202020202020202020202020202020202020207574';
wwv_flow_api.g_varchar2_table(856) := '696C2E6C6F616465722E73746F7028704F7074732E616666456C656D656E74444956293B0A2020202020202020202020202020202020202020617065782E64656275672E6572726F72287B0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(857) := '22666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B202275706C6F6164436C6F62222C0A202020202020202020202020202020202020202020202020226D7367223A2022436C6F622055706C6F616420';
wwv_flow_api.g_varchar2_table(858) := '6572726F72222C0A202020202020202020202020202020202020202020202020226A71584852223A206A715848522C0A2020202020202020202020202020202020202020202020202274657874537461747573223A20746578745374617475732C0A2020';
wwv_flow_api.g_varchar2_table(859) := '20202020202020202020202020202020202020202020226572726F725468726F776E223A206572726F725468726F776E2C0A202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E666561';
wwv_flow_api.g_varchar2_table(860) := '7475726544657461696C730A20202020202020202020202020202020202020207D293B0A2020202020202020202020202020202020202020617065782E6576656E742E7472696767657228704F7074732E616666456C656D656E7449442C2027636C6F62';
wwv_flow_api.g_varchar2_table(861) := '736176656572726F7227293B0A2020202020202020202020202020202020202020617065782E64612E726573756D652870546869732E726573756D6543616C6C6261636B2C2074727565293B0A202020202020202020202020202020207D0A2020202020';
wwv_flow_api.g_varchar2_table(862) := '202020202020207D293B0A20202020202020207D0A202020207D0A0A202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(863) := '2A2A2A2A0A20202020202A2A0A20202020202A2A20496E69740A20202020202A2A0A20202020202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(864) := '2A2A2A2A2A2A2A2A2A2A2F0A2020202072657475726E207B0A2020202020202020696E697469616C697A653A2066756E6374696F6E202870546869732C20704F70747329207B0A0A202020202020202020202020617065782E64656275672E696E666F28';
wwv_flow_api.g_varchar2_table(865) := '7B0A2020202020202020202020202020202022666374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B2022696E697469616C697A65222C0A2020202020202020202020202020202022617267756D656E7473';
wwv_flow_api.g_varchar2_table(866) := '223A207B0A2020202020202020202020202020202020202020227054686973223A2070546869732C0A202020202020202020202020202020202020202022704F707473223A20704F7074730A202020202020202020202020202020207D2C0A2020202020';
wwv_flow_api.g_varchar2_table(867) := '2020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A2020202020202020202020207D293B0A0A202020202020202020202020766172206F707473203D20704F7074733B0A0A202020';
wwv_flow_api.g_varchar2_table(868) := '2020202020202020207661722064656661756C7453616E6974697A654F7074696F6E73203D207B0A2020202020202020202020202020202022414C4C4F5745445F41545452223A205B226163636573736B6579222C2022616C69676E222C2022616C7422';
wwv_flow_api.g_varchar2_table(869) := '2C2022616C77617973222C20226175746F636F6D706C657465222C20226175746F706C6179222C2022626F72646572222C202263656C6C70616464696E67222C202263656C6C73706163696E67222C202263686172736574222C2022636C617373222C20';
wwv_flow_api.g_varchar2_table(870) := '22646972222C2022686569676874222C202268726566222C20226964222C20226C616E67222C20226E616D65222C202272656C222C20227265717569726564222C2022737263222C20227374796C65222C202273756D6D617279222C2022746162696E64';
wwv_flow_api.g_varchar2_table(871) := '6578222C2022746172676574222C20227469746C65222C202274797065222C202276616C7565222C20227769647468225D2C0A2020202020202020202020202020202022414C4C4F5745445F54414753223A205B2261222C202261646472657373222C20';
wwv_flow_api.g_varchar2_table(872) := '2262222C2022626C6F636B71756F7465222C20226272222C202263617074696F6E222C2022636F6465222C20226464222C2022646976222C2022646C222C20226474222C2022656D222C202266696763617074696F6E222C2022666967757265222C2022';
wwv_flow_api.g_varchar2_table(873) := '6831222C20226832222C20226833222C20226834222C20226835222C20226836222C20226872222C202269222C2022696D67222C20226C6162656C222C20226C69222C20226E6C222C20226F6C222C202270222C2022707265222C202273222C20227370';
wwv_flow_api.g_varchar2_table(874) := '616E222C2022737472696B65222C20227374726F6E67222C2022737562222C2022737570222C20227461626C65222C202274626F6479222C20227464222C20227468222C20227468656164222C20227472222C202275222C2022756C225D0A2020202020';
wwv_flow_api.g_varchar2_table(875) := '202020202020207D3B0A0A2020202020202020202020206F7074732E696D675769647468203D206F7074732E696D675769647468207C7C203730303B0A0A2020202020202020202020202F2A206D65726765207573657220646566696E65642073616E69';
wwv_flow_api.g_varchar2_table(876) := '74697A65206F7074696F6E73202A2F0A2020202020202020202020206F7074732E73616E6974697A654F7074696F6E73203D207574696C2E6A736F6E53617665457874656E642864656661756C7453616E6974697A654F7074696F6E732C20704F707473';
wwv_flow_api.g_varchar2_table(877) := '2E73616E6974697A654F7074696F6E73293B0A0A2020202020202020202020202F2A205472616E7366726F6D205965732F4E6F2053656C656374204C69737420746F20426F6F6C65616E202A2F0A202020202020202020202020696620286F7074732E73';
wwv_flow_api.g_varchar2_table(878) := '616E6974697A65203D3D20224E2229207B0A202020202020202020202020202020206F7074732E73616E6974697A65203D2066616C73653B0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202020206F7074732E73';
wwv_flow_api.g_varchar2_table(879) := '616E6974697A65203D20747275653B0A2020202020202020202020207D0A0A202020202020202020202020696620286F7074732E65736361706548544D4C203D3D20224E2229207B0A202020202020202020202020202020206F7074732E657363617065';
wwv_flow_api.g_varchar2_table(880) := '48544D4C203D2066616C73653B0A0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202020206F7074732E65736361706548544D4C203D20747275653B0A2020202020202020202020207D0A0A202020202020202020';
wwv_flow_api.g_varchar2_table(881) := '202020696620286F7074732E756E45736361706548544D4C203D3D20224E2229207B0A202020202020202020202020202020206F7074732E756E45736361706548544D4C203D2066616C73653B0A0A2020202020202020202020207D20656C7365207B0A';
wwv_flow_api.g_varchar2_table(882) := '202020202020202020202020202020206F7074732E756E45736361706548544D4C203D20747275653B0A2020202020202020202020207D0A0A202020202020202020202020696620286F7074732E73686F774C6F61646572203D3D2027592729207B0A20';
wwv_flow_api.g_varchar2_table(883) := '2020202020202020202020202020206F7074732E73686F774C6F61646572203D20747275653B0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202020206F7074732E73686F774C6F61646572203D2066616C73653B';
wwv_flow_api.g_varchar2_table(884) := '0A2020202020202020202020207D0A0A202020202020202020202020696620286F7074732E757365496D61676555706C6F61646572203D3D2027592729207B0A202020202020202020202020202020206F7074732E757365496D61676555706C6F616465';
wwv_flow_api.g_varchar2_table(885) := '72203D20747275653B0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202020206F7074732E757365496D61676555706C6F61646572203D2066616C73653B0A2020202020202020202020207D0A0A20202020202020';
wwv_flow_api.g_varchar2_table(886) := '202020202069662028747970656F6620434B454449544F5220213D2022756E646566696E65642220262620434B454449544F522E76657273696F6E29207B0A202020202020202020202020202020206F7074732E76657273696F6E203D20434B45444954';
wwv_flow_api.g_varchar2_table(887) := '4F522E76657273696F6E3B0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202020206F7074732E76657273696F6E203D20353B0A2020202020202020202020207D0A0A202020202020202020202020696620287054';
wwv_flow_api.g_varchar2_table(888) := '6869732E6166666563746564456C656D656E74735B305D29207B0A202020202020202020202020202020206F7074732E616666456C656D656E74203D20242870546869732E6166666563746564456C656D656E74735B305D292E61747472282269642229';
wwv_flow_api.g_varchar2_table(889) := '3B0A202020202020202020202020202020206F7074732E616666456C656D656E74444956203D20222322202B20242870546869732E6166666563746564456C656D656E74735B305D292E61747472282269642229202B20225F434F4E5441494E4552223B';
wwv_flow_api.g_varchar2_table(890) := '0A202020202020202020202020202020206F7074732E616666456C656D656E744944203D20222322202B20242870546869732E6166666563746564456C656D656E74735B305D292E617474722822696422293B0A0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(891) := '202F2A2073686F77206C6F61646572207768656E20736574202A2F0A20202020202020202020202020202020696620286F7074732E73686F774C6F6164657229207B0A20202020202020202020202020202020202020207574696C2E6C6F616465722E73';
wwv_flow_api.g_varchar2_table(892) := '74617274286F7074732E616666456C656D656E74444956290A202020202020202020202020202020207D0A0A202020202020202020202020202020202F2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(893) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A0A20202020202020202020202020202020202A2A0A20202020202020202020202020202020202A2A205573656420746F2067657420636C6F622064617461207768656E20';
wwv_flow_api.g_varchar2_table(894) := '696E207072696E74206D6F64650A20202020202020202020202020202020202A2A0A20202020202020202020202020202020202A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A';
wwv_flow_api.g_varchar2_table(895) := '2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2F0A20202020202020202020202020202020696620286F7074732E66756E6374696F6E54797065203D3D202752454E4445522729207B0A2020202020202020202020202020202020202020766172';
wwv_flow_api.g_varchar2_table(896) := '206974656D73325375626D6974203D206F7074732E6974656D73325375626D69743B0A2020202020202020202020202020202020202020617065782E7365727665722E706C7567696E280A2020202020202020202020202020202020202020202020206F';
wwv_flow_api.g_varchar2_table(897) := '7074732E616A617849442C207B0A202020202020202020202020202020202020202020202020202020207830313A20225052494E545F434C4F42222C0A20202020202020202020202020202020202020202020202020202020706167654974656D733A20';
wwv_flow_api.g_varchar2_table(898) := '6974656D73325375626D69740A2020202020202020202020202020202020202020202020207D2C207B0A20202020202020202020202020202020202020202020202020202020737563636573733A2066756E6374696F6E2028704461746129207B0A2020';
wwv_flow_api.g_varchar2_table(899) := '202020202020202020202020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A20202020202020202020202020202020202020202020202020202020202020202020202022666374223A207574696C2E66656174';
wwv_flow_api.g_varchar2_table(900) := '75726544657461696C732E6E616D65202B2022202D2022202B2022696E697469616C697A65222C0A202020202020202020202020202020202020202020202020202020202020202020202020226D7367223A2022414A4158206461746120726563656976';
wwv_flow_api.g_varchar2_table(901) := '6564222C0A202020202020202020202020202020202020202020202020202020202020202020202020227044617461223A2070446174612C0A20202020202020202020202020202020202020202020202020202020202020202020202022666561747572';
wwv_flow_api.g_varchar2_table(902) := '6544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020202020202020202020202020202020202020202020202020207D293B0A202020202020202020202020202020202020202020202020202020202020202070';
wwv_flow_api.g_varchar2_table(903) := '72696E74436C6F622870546869732C2070446174612C206F707473293B0A202020202020202020202020202020202020202020202020202020207D2C0A202020202020202020202020202020202020202020202020202020206572726F723A2066756E63';
wwv_flow_api.g_varchar2_table(904) := '74696F6E20286429207B0A2020202020202020202020202020202020202020202020202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202020202020202020202020202020202020202020202266';
wwv_flow_api.g_varchar2_table(905) := '6374223A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B2022696E697469616C697A65222C0A202020202020202020202020202020202020202020202020202020202020202020202020226D7367223A2022414A';
wwv_flow_api.g_varchar2_table(906) := '41582064617461206572726F72222C0A20202020202020202020202020202020202020202020202020202020202020202020202022726573706F6E7365223A20642C0A202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(907) := '202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020202020202020202020202020202020202020202020202020207D293B0A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(908) := '20202020207D2C0A2020202020202020202020202020202020202020202020202020202064617461547970653A20226A736F6E220A2020202020202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D2065';
wwv_flow_api.g_varchar2_table(909) := '6C7365207B0A202020202020202020202020202020202020202075706C6F6164436C6F622870546869732C206F707473293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D0A202020207D0A7D';
wwv_flow_api.g_varchar2_table(910) := '2928293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(65741298129977485921)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_file_name=>'unleashrte.pkgd.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '4D4954204C6963656E73650A0A436F7079726967687420286329203230323120526F6E6E7920576569C39F0A0A5065726D697373696F6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E79207065';
wwv_flow_api.g_varchar2_table(2) := '72736F6E206F627461696E696E67206120636F70790A6F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E2066696C657320287468652022536F66747761726522292C20746F206465616C0A';
wwv_flow_api.g_varchar2_table(3) := '696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E6720776974686F7574206C696D69746174696F6E20746865207269676874730A746F207573652C20636F70792C206D6F646966792C206D';
wwv_flow_api.g_varchar2_table(4) := '657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C0A636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D697420706572736F6E7320746F20';
wwv_flow_api.g_varchar2_table(5) := '77686F6D2074686520536F6674776172652069730A6675726E697368656420746F20646F20736F2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0A0A5468652061626F766520636F70797269676874206E';
wwv_flow_api.g_varchar2_table(6) := '6F7469636520616E642074686973207065726D697373696F6E206E6F74696365207368616C6C20626520696E636C7564656420696E20616C6C0A636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520536F6674';
wwv_flow_api.g_varchar2_table(7) := '776172652E0A0A54484520534F4654574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052455353204F520A494D504C4945442C20494E434C5544494E47';
wwv_flow_api.g_varchar2_table(8) := '20425554204E4F54204C494D4954454420544F205448452057415252414E54494553204F46204D45524348414E544142494C4954592C0A4649544E45535320464F52204120504152544943554C415220505552504F534520414E44204E4F4E494E465249';
wwv_flow_api.g_varchar2_table(9) := '4E47454D454E542E20494E204E4F204556454E54205348414C4C205448450A415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941424C4520464F5220414E5920434C41494D2C2044414D41474553204F52204F544845';
wwv_flow_api.g_varchar2_table(10) := '520A4C494142494C4954592C205748455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953494E472046524F4D2C0A4F5554204F46204F5220494E20434F4E4E454354';
wwv_flow_api.g_varchar2_table(11) := '494F4E20574954482054484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450A534F4654574152452E';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(83799139456562774857)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_file_name=>'LICENSE'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '68747470733A2F2F6769746875622E636F6D2F6375726535332F444F4D5075726966790D0A0D0A444F4D5075726966790D0A436F707972696768742032303135204D6172696F204865696465726963680D0A0D0A444F4D50757269667920697320667265';
wwv_flow_api.g_varchar2_table(2) := '6520736F6674776172653B20796F752063616E2072656469737472696275746520697420616E642F6F72206D6F6469667920697420756E646572207468650D0A7465726D73206F66206569746865723A0D0A0D0A61292074686520417061636865204C69';
wwv_flow_api.g_varchar2_table(3) := '63656E73652056657273696F6E20322E302C206F720D0A622920746865204D6F7A696C6C61205075626C6963204C6963656E73652056657273696F6E20322E300D0A0D0A2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(4) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A0D0A4C6963656E73656420756E6465722074686520417061636865204C6963656E73652C2056657273696F6E20322E302028746865';
wwv_flow_api.g_varchar2_table(5) := '20224C6963656E736522293B0D0A796F75206D6179206E6F742075736520746869732066696C652065786365707420696E20636F6D706C69616E6365207769746820746865204C6963656E73652E0D0A596F75206D6179206F627461696E206120636F70';
wwv_flow_api.g_varchar2_table(6) := '79206F6620746865204C6963656E73652061740D0A0D0A20202020687474703A2F2F7777772E6170616368652E6F72672F6C6963656E7365732F4C4943454E53452D322E300D0A0D0A20202020556E6C657373207265717569726564206279206170706C';
wwv_flow_api.g_varchar2_table(7) := '696361626C65206C6177206F722061677265656420746F20696E2077726974696E672C20736F6674776172650D0A20202020646973747269627574656420756E64657220746865204C6963656E7365206973206469737472696275746564206F6E20616E';
wwv_flow_api.g_varchar2_table(8) := '20224153204953222042415349532C0D0A20202020574954484F55542057415252414E54494553204F5220434F4E444954494F4E53204F4620414E59204B494E442C206569746865722065787072657373206F7220696D706C6965642E0D0A2020202053';
wwv_flow_api.g_varchar2_table(9) := '656520746865204C6963656E736520666F7220746865207370656369666963206C616E677561676520676F7665726E696E67207065726D697373696F6E7320616E640D0A202020206C696D69746174696F6E7320756E64657220746865204C6963656E73';
wwv_flow_api.g_varchar2_table(10) := '652E0D0A0D0A2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A4D6F7A696C6C61205075626C696320';
wwv_flow_api.g_varchar2_table(11) := '4C6963656E73652C2076657273696F6E20322E300D0A0D0A312E20446566696E6974696F6E730D0A0D0A312E312E2093436F6E7472696275746F72940D0A0D0A20202020206D65616E73206561636820696E646976696475616C206F72206C6567616C20';
wwv_flow_api.g_varchar2_table(12) := '656E74697479207468617420637265617465732C20636F6E747269627574657320746F207468650D0A20202020206372656174696F6E206F662C206F72206F776E7320436F766572656420536F6674776172652E0D0A0D0A312E322E2093436F6E747269';
wwv_flow_api.g_varchar2_table(13) := '6275746F722056657273696F6E940D0A0D0A20202020206D65616E732074686520636F6D62696E6174696F6E206F662074686520436F6E747269627574696F6E73206F66206F74686572732028696620616E7929207573656420627920610D0A20202020';
wwv_flow_api.g_varchar2_table(14) := '20436F6E7472696275746F7220616E64207468617420706172746963756C617220436F6E7472696275746F72927320436F6E747269627574696F6E2E0D0A0D0A312E332E2093436F6E747269627574696F6E940D0A0D0A20202020206D65616E7320436F';
wwv_flow_api.g_varchar2_table(15) := '766572656420536F667477617265206F66206120706172746963756C617220436F6E7472696275746F722E0D0A0D0A312E342E2093436F766572656420536F667477617265940D0A0D0A20202020206D65616E7320536F7572636520436F646520466F72';
wwv_flow_api.g_varchar2_table(16) := '6D20746F2077686963682074686520696E697469616C20436F6E7472696275746F7220686173206174746163686564207468650D0A20202020206E6F7469636520696E204578686962697420412C207468652045786563757461626C6520466F726D206F';
wwv_flow_api.g_varchar2_table(17) := '66207375636820536F7572636520436F646520466F726D2C20616E640D0A20202020204D6F64696669636174696F6E73206F66207375636820536F7572636520436F646520466F726D2C20696E2065616368206361736520696E636C7564696E6720706F';
wwv_flow_api.g_varchar2_table(18) := '7274696F6E730D0A202020202074686572656F662E0D0A0D0A312E352E2093496E636F6D70617469626C652057697468205365636F6E64617279204C6963656E736573940D0A20202020206D65616E730D0A0D0A2020202020612E207468617420746865';
wwv_flow_api.g_varchar2_table(19) := '20696E697469616C20436F6E7472696275746F722068617320617474616368656420746865206E6F746963652064657363726962656420696E0D0A202020202020202045786869626974204220746F2074686520436F766572656420536F667477617265';
wwv_flow_api.g_varchar2_table(20) := '3B206F720D0A0D0A2020202020622E20746861742074686520436F766572656420536F66747761726520776173206D61646520617661696C61626C6520756E64657220746865207465726D73206F662076657273696F6E0D0A2020202020202020312E31';
wwv_flow_api.g_varchar2_table(21) := '206F72206561726C696572206F6620746865204C6963656E73652C20627574206E6F7420616C736F20756E64657220746865207465726D73206F6620610D0A20202020202020205365636F6E64617279204C6963656E73652E0D0A0D0A312E362E209345';
wwv_flow_api.g_varchar2_table(22) := '786563757461626C6520466F726D940D0A0D0A20202020206D65616E7320616E7920666F726D206F662074686520776F726B206F74686572207468616E20536F7572636520436F646520466F726D2E0D0A0D0A312E372E20934C617267657220576F726B';
wwv_flow_api.g_varchar2_table(23) := '940D0A0D0A20202020206D65616E73206120776F726B207468617420636F6D62696E657320436F766572656420536F6674776172652077697468206F74686572206D6174657269616C2C20696E20612073657061726174650D0A202020202066696C6520';
wwv_flow_api.g_varchar2_table(24) := '6F722066696C65732C2074686174206973206E6F7420436F766572656420536F6674776172652E0D0A0D0A312E382E20934C6963656E7365940D0A0D0A20202020206D65616E73207468697320646F63756D656E742E0D0A0D0A312E392E20934C696365';
wwv_flow_api.g_varchar2_table(25) := '6E7361626C65940D0A0D0A20202020206D65616E7320686176696E672074686520726967687420746F206772616E742C20746F20746865206D6178696D756D20657874656E7420706F737369626C652C2077686574686572206174207468650D0A202020';
wwv_flow_api.g_varchar2_table(26) := '202074696D65206F662074686520696E697469616C206772616E74206F722073756273657175656E746C792C20616E7920616E6420616C6C206F66207468652072696768747320636F6E76657965642062790D0A202020202074686973204C6963656E73';
wwv_flow_api.g_varchar2_table(27) := '652E0D0A0D0A312E31302E20934D6F64696669636174696F6E73940D0A0D0A20202020206D65616E7320616E79206F662074686520666F6C6C6F77696E673A0D0A0D0A2020202020612E20616E792066696C6520696E20536F7572636520436F64652046';
wwv_flow_api.g_varchar2_table(28) := '6F726D207468617420726573756C74732066726F6D20616E206164646974696F6E20746F2C2064656C6574696F6E0D0A202020202020202066726F6D2C206F72206D6F64696669636174696F6E206F662074686520636F6E74656E7473206F6620436F76';
wwv_flow_api.g_varchar2_table(29) := '6572656420536F6674776172653B206F720D0A0D0A2020202020622E20616E79206E65772066696C6520696E20536F7572636520436F646520466F726D207468617420636F6E7461696E7320616E7920436F766572656420536F6674776172652E0D0A0D';
wwv_flow_api.g_varchar2_table(30) := '0A312E31312E2093506174656E7420436C61696D7394206F66206120436F6E7472696275746F720D0A0D0A2020202020206D65616E7320616E7920706174656E7420636C61696D2873292C20696E636C7564696E6720776974686F7574206C696D697461';
wwv_flow_api.g_varchar2_table(31) := '74696F6E2C206D6574686F642C2070726F636573732C0D0A202020202020616E642061707061726174757320636C61696D732C20696E20616E7920706174656E74204C6963656E7361626C65206279207375636820436F6E7472696275746F7220746861';
wwv_flow_api.g_varchar2_table(32) := '740D0A202020202020776F756C6420626520696E6672696E6765642C2062757420666F7220746865206772616E74206F6620746865204C6963656E73652C20627920746865206D616B696E672C0D0A2020202020207573696E672C2073656C6C696E672C';
wwv_flow_api.g_varchar2_table(33) := '206F66666572696E6720666F722073616C652C20686176696E67206D6164652C20696D706F72742C206F72207472616E73666572206F660D0A2020202020206569746865722069747320436F6E747269627574696F6E73206F722069747320436F6E7472';
wwv_flow_api.g_varchar2_table(34) := '696275746F722056657273696F6E2E0D0A0D0A312E31322E20935365636F6E64617279204C6963656E7365940D0A0D0A2020202020206D65616E73206569746865722074686520474E552047656E6572616C205075626C6963204C6963656E73652C2056';
wwv_flow_api.g_varchar2_table(35) := '657273696F6E20322E302C2074686520474E55204C65737365720D0A20202020202047656E6572616C205075626C6963204C6963656E73652C2056657273696F6E20322E312C2074686520474E552041666665726F2047656E6572616C205075626C6963';
wwv_flow_api.g_varchar2_table(36) := '0D0A2020202020204C6963656E73652C2056657273696F6E20332E302C206F7220616E79206C617465722076657273696F6E73206F662074686F7365206C6963656E7365732E0D0A0D0A312E31332E2093536F7572636520436F646520466F726D940D0A';
wwv_flow_api.g_varchar2_table(37) := '0D0A2020202020206D65616E732074686520666F726D206F662074686520776F726B2070726566657272656420666F72206D616B696E67206D6F64696669636174696F6E732E0D0A0D0A312E31342E2093596F759420286F722093596F757294290D0A0D';
wwv_flow_api.g_varchar2_table(38) := '0A2020202020206D65616E7320616E20696E646976696475616C206F722061206C6567616C20656E746974792065786572636973696E672072696768747320756E64657220746869730D0A2020202020204C6963656E73652E20466F72206C6567616C20';
wwv_flow_api.g_varchar2_table(39) := '656E7469746965732C2093596F759420696E636C7564657320616E7920656E74697479207468617420636F6E74726F6C732C2069730D0A202020202020636F6E74726F6C6C65642062792C206F7220697320756E64657220636F6D6D6F6E20636F6E7472';
wwv_flow_api.g_varchar2_table(40) := '6F6C207769746820596F752E20466F7220707572706F736573206F6620746869730D0A202020202020646566696E6974696F6E2C2093636F6E74726F6C94206D65616E73202861292074686520706F7765722C20646972656374206F7220696E64697265';
wwv_flow_api.g_varchar2_table(41) := '63742C20746F2063617573650D0A20202020202074686520646972656374696F6E206F72206D616E6167656D656E74206F66207375636820656E746974792C207768657468657220627920636F6E7472616374206F720D0A2020202020206F7468657277';
wwv_flow_api.g_varchar2_table(42) := '6973652C206F7220286229206F776E657273686970206F66206D6F7265207468616E2066696674792070657263656E74202835302529206F66207468650D0A2020202020206F75747374616E64696E6720736861726573206F722062656E656669636961';
wwv_flow_api.g_varchar2_table(43) := '6C206F776E657273686970206F66207375636820656E746974792E0D0A0D0A0D0A322E204C6963656E7365204772616E747320616E6420436F6E646974696F6E730D0A0D0A322E312E204772616E74730D0A0D0A20202020204561636820436F6E747269';
wwv_flow_api.g_varchar2_table(44) := '6275746F7220686572656279206772616E747320596F75206120776F726C642D776964652C20726F79616C74792D667265652C0D0A20202020206E6F6E2D6578636C7573697665206C6963656E73653A0D0A0D0A2020202020612E20756E64657220696E';
wwv_flow_api.g_varchar2_table(45) := '74656C6C65637475616C2070726F70657274792072696768747320286F74686572207468616E20706174656E74206F722074726164656D61726B290D0A20202020202020204C6963656E7361626C65206279207375636820436F6E7472696275746F7220';
wwv_flow_api.g_varchar2_table(46) := '746F207573652C20726570726F647563652C206D616B6520617661696C61626C652C0D0A20202020202020206D6F646966792C20646973706C61792C20706572666F726D2C20646973747269627574652C20616E64206F7468657277697365206578706C';
wwv_flow_api.g_varchar2_table(47) := '6F6974206974730D0A2020202020202020436F6E747269627574696F6E732C20656974686572206F6E20616E20756E6D6F6469666965642062617369732C2077697468204D6F64696669636174696F6E732C206F722061730D0A20202020202020207061';
wwv_flow_api.g_varchar2_table(48) := '7274206F662061204C617267657220576F726B3B20616E640D0A0D0A2020202020622E20756E64657220506174656E7420436C61696D73206F66207375636820436F6E7472696275746F7220746F206D616B652C207573652C2073656C6C2C206F666665';
wwv_flow_api.g_varchar2_table(49) := '7220666F720D0A202020202020202073616C652C2068617665206D6164652C20696D706F72742C20616E64206F7468657277697365207472616E73666572206569746865722069747320436F6E747269627574696F6E730D0A20202020202020206F7220';
wwv_flow_api.g_varchar2_table(50) := '69747320436F6E7472696275746F722056657273696F6E2E0D0A0D0A322E322E2045666665637469766520446174650D0A0D0A2020202020546865206C6963656E736573206772616E74656420696E2053656374696F6E20322E31207769746820726573';
wwv_flow_api.g_varchar2_table(51) := '7065637420746F20616E7920436F6E747269627574696F6E206265636F6D650D0A202020202065666665637469766520666F72206561636820436F6E747269627574696F6E206F6E2074686520646174652074686520436F6E7472696275746F72206669';
wwv_flow_api.g_varchar2_table(52) := '7273742064697374726962757465730D0A20202020207375636820436F6E747269627574696F6E2E0D0A0D0A322E332E204C696D69746174696F6E73206F6E204772616E742053636F70650D0A0D0A2020202020546865206C6963656E73657320677261';
wwv_flow_api.g_varchar2_table(53) := '6E74656420696E20746869732053656374696F6E20322061726520746865206F6E6C7920726967687473206772616E74656420756E64657220746869730D0A20202020204C6963656E73652E204E6F206164646974696F6E616C20726967687473206F72';
wwv_flow_api.g_varchar2_table(54) := '206C6963656E7365732077696C6C20626520696D706C6965642066726F6D2074686520646973747269627574696F6E0D0A20202020206F72206C6963656E73696E67206F6620436F766572656420536F66747761726520756E6465722074686973204C69';
wwv_flow_api.g_varchar2_table(55) := '63656E73652E204E6F74776974687374616E64696E672053656374696F6E0D0A2020202020322E312862292061626F76652C206E6F20706174656E74206C6963656E7365206973206772616E746564206279206120436F6E7472696275746F723A0D0A0D';
wwv_flow_api.g_varchar2_table(56) := '0A2020202020612E20666F7220616E7920636F64652074686174206120436F6E7472696275746F72206861732072656D6F7665642066726F6D20436F766572656420536F6674776172653B206F720D0A0D0A2020202020622E20666F7220696E6672696E';
wwv_flow_api.g_varchar2_table(57) := '67656D656E7473206361757365642062793A2028692920596F757220616E6420616E79206F7468657220746869726420706172747992730D0A20202020202020206D6F64696669636174696F6E73206F6620436F766572656420536F6674776172652C20';
wwv_flow_api.g_varchar2_table(58) := '6F7220286969292074686520636F6D62696E6174696F6E206F66206974730D0A2020202020202020436F6E747269627574696F6E732077697468206F7468657220736F66747761726520286578636570742061732070617274206F662069747320436F6E';
wwv_flow_api.g_varchar2_table(59) := '7472696275746F720D0A202020202020202056657273696F6E293B206F720D0A0D0A2020202020632E20756E64657220506174656E7420436C61696D7320696E6672696E67656420627920436F766572656420536F66747761726520696E207468652061';
wwv_flow_api.g_varchar2_table(60) := '6273656E6365206F66206974730D0A2020202020202020436F6E747269627574696F6E732E0D0A0D0A202020202054686973204C6963656E736520646F6573206E6F74206772616E7420616E792072696768747320696E207468652074726164656D6172';
wwv_flow_api.g_varchar2_table(61) := '6B732C2073657276696365206D61726B732C206F720D0A20202020206C6F676F73206F6620616E7920436F6E7472696275746F722028657863657074206173206D6179206265206E656365737361727920746F20636F6D706C792077697468207468650D';
wwv_flow_api.g_varchar2_table(62) := '0A20202020206E6F7469636520726571756972656D656E747320696E2053656374696F6E20332E34292E0D0A0D0A322E342E2053756273657175656E74204C6963656E7365730D0A0D0A20202020204E6F20436F6E7472696275746F72206D616B657320';
wwv_flow_api.g_varchar2_table(63) := '6164646974696F6E616C206772616E7473206173206120726573756C74206F6620596F75722063686F69636520746F0D0A2020202020646973747269627574652074686520436F766572656420536F66747761726520756E646572206120737562736571';
wwv_flow_api.g_varchar2_table(64) := '75656E742076657273696F6E206F662074686973204C6963656E73650D0A2020202020287365652053656374696F6E2031302E3229206F7220756E64657220746865207465726D73206F662061205365636F6E64617279204C6963656E73652028696620';
wwv_flow_api.g_varchar2_table(65) := '7065726D69747465640D0A2020202020756E64657220746865207465726D73206F662053656374696F6E20332E33292E0D0A0D0A322E352E20526570726573656E746174696F6E0D0A0D0A20202020204561636820436F6E7472696275746F7220726570';
wwv_flow_api.g_varchar2_table(66) := '726573656E747320746861742074686520436F6E7472696275746F722062656C69657665732069747320436F6E747269627574696F6E730D0A202020202061726520697473206F726967696E616C206372656174696F6E287329206F7220697420686173';
wwv_flow_api.g_varchar2_table(67) := '2073756666696369656E742072696768747320746F206772616E74207468650D0A202020202072696768747320746F2069747320436F6E747269627574696F6E7320636F6E76657965642062792074686973204C6963656E73652E0D0A0D0A322E362E20';
wwv_flow_api.g_varchar2_table(68) := '46616972205573650D0A0D0A202020202054686973204C6963656E7365206973206E6F7420696E74656E64656420746F206C696D697420616E792072696768747320596F75206861766520756E646572206170706C696361626C650D0A2020202020636F';
wwv_flow_api.g_varchar2_table(69) := '7079726967687420646F637472696E6573206F662066616972207573652C2066616972206465616C696E672C206F72206F74686572206571756976616C656E74732E0D0A0D0A322E372E20436F6E646974696F6E730D0A0D0A202020202053656374696F';
wwv_flow_api.g_varchar2_table(70) := '6E7320332E312C20332E322C20332E332C20616E6420332E342061726520636F6E646974696F6E73206F6620746865206C6963656E736573206772616E74656420696E0D0A202020202053656374696F6E20322E312E0D0A0D0A0D0A332E20526573706F';
wwv_flow_api.g_varchar2_table(71) := '6E736962696C69746965730D0A0D0A332E312E20446973747269627574696F6E206F6620536F7572636520466F726D0D0A0D0A2020202020416C6C20646973747269627574696F6E206F6620436F766572656420536F66747761726520696E20536F7572';
wwv_flow_api.g_varchar2_table(72) := '636520436F646520466F726D2C20696E636C7564696E6720616E790D0A20202020204D6F64696669636174696F6E73207468617420596F7520637265617465206F7220746F20776869636820596F7520636F6E747269627574652C206D75737420626520';
wwv_flow_api.g_varchar2_table(73) := '756E646572207468650D0A20202020207465726D73206F662074686973204C6963656E73652E20596F75206D75737420696E666F726D20726563697069656E747320746861742074686520536F7572636520436F646520466F726D0D0A20202020206F66';
wwv_flow_api.g_varchar2_table(74) := '2074686520436F766572656420536F66747761726520697320676F7665726E656420627920746865207465726D73206F662074686973204C6963656E73652C20616E6420686F770D0A2020202020746865792063616E206F627461696E206120636F7079';
wwv_flow_api.g_varchar2_table(75) := '206F662074686973204C6963656E73652E20596F75206D6179206E6F7420617474656D707420746F20616C746572206F720D0A202020202072657374726963742074686520726563697069656E7473922072696768747320696E2074686520536F757263';
wwv_flow_api.g_varchar2_table(76) := '6520436F646520466F726D2E0D0A0D0A332E322E20446973747269627574696F6E206F662045786563757461626C6520466F726D0D0A0D0A2020202020496620596F75206469737472696275746520436F766572656420536F66747761726520696E2045';
wwv_flow_api.g_varchar2_table(77) := '786563757461626C6520466F726D207468656E3A0D0A0D0A2020202020612E207375636820436F766572656420536F667477617265206D75737420616C736F206265206D61646520617661696C61626C6520696E20536F7572636520436F646520466F72';
wwv_flow_api.g_varchar2_table(78) := '6D2C0D0A202020202020202061732064657363726962656420696E2053656374696F6E20332E312C20616E6420596F75206D75737420696E666F726D20726563697069656E7473206F66207468650D0A202020202020202045786563757461626C652046';
wwv_flow_api.g_varchar2_table(79) := '6F726D20686F7720746865792063616E206F627461696E206120636F7079206F66207375636820536F7572636520436F646520466F726D2062790D0A2020202020202020726561736F6E61626C65206D65616E7320696E20612074696D656C79206D616E';
wwv_flow_api.g_varchar2_table(80) := '6E65722C206174206120636861726765206E6F206D6F7265207468616E2074686520636F73740D0A20202020202020206F6620646973747269627574696F6E20746F2074686520726563697069656E743B20616E640D0A0D0A2020202020622E20596F75';
wwv_flow_api.g_varchar2_table(81) := '206D6179206469737472696275746520737563682045786563757461626C6520466F726D20756E64657220746865207465726D73206F662074686973204C6963656E73652C0D0A20202020202020206F72207375626C6963656E736520697420756E6465';
wwv_flow_api.g_varchar2_table(82) := '7220646966666572656E74207465726D732C2070726F7669646564207468617420746865206C6963656E736520666F720D0A20202020202020207468652045786563757461626C6520466F726D20646F6573206E6F7420617474656D707420746F206C69';
wwv_flow_api.g_varchar2_table(83) := '6D6974206F7220616C7465722074686520726563697069656E7473920D0A202020202020202072696768747320696E2074686520536F7572636520436F646520466F726D20756E6465722074686973204C6963656E73652E0D0A0D0A332E332E20446973';
wwv_flow_api.g_varchar2_table(84) := '747269627574696F6E206F662061204C617267657220576F726B0D0A0D0A2020202020596F75206D61792063726561746520616E6420646973747269627574652061204C617267657220576F726B20756E646572207465726D73206F6620596F75722063';
wwv_flow_api.g_varchar2_table(85) := '686F6963652C0D0A202020202070726F7669646564207468617420596F7520616C736F20636F6D706C7920776974682074686520726571756972656D656E7473206F662074686973204C6963656E736520666F72207468650D0A2020202020436F766572';
wwv_flow_api.g_varchar2_table(86) := '656420536F6674776172652E20496620746865204C617267657220576F726B206973206120636F6D62696E6174696F6E206F6620436F766572656420536F6674776172650D0A202020202077697468206120776F726B20676F7665726E6564206279206F';
wwv_flow_api.g_varchar2_table(87) := '6E65206F72206D6F7265205365636F6E64617279204C6963656E7365732C20616E642074686520436F76657265640D0A2020202020536F667477617265206973206E6F7420496E636F6D70617469626C652057697468205365636F6E64617279204C6963';
wwv_flow_api.g_varchar2_table(88) := '656E7365732C2074686973204C6963656E7365207065726D6974730D0A2020202020596F7520746F206164646974696F6E616C6C792064697374726962757465207375636820436F766572656420536F66747761726520756E6465722074686520746572';
wwv_flow_api.g_varchar2_table(89) := '6D73206F660D0A202020202073756368205365636F6E64617279204C6963656E73652873292C20736F20746861742074686520726563697069656E74206F6620746865204C617267657220576F726B206D61792C2061740D0A2020202020746865697220';
wwv_flow_api.g_varchar2_table(90) := '6F7074696F6E2C206675727468657220646973747269627574652074686520436F766572656420536F66747761726520756E64657220746865207465726D73206F660D0A20202020206569746865722074686973204C6963656E7365206F722073756368';
wwv_flow_api.g_varchar2_table(91) := '205365636F6E64617279204C6963656E73652873292E0D0A0D0A332E342E204E6F74696365730D0A0D0A2020202020596F75206D6179206E6F742072656D6F7665206F7220616C74657220746865207375627374616E6365206F6620616E79206C696365';
wwv_flow_api.g_varchar2_table(92) := '6E7365206E6F74696365732028696E636C7564696E670D0A2020202020636F70797269676874206E6F74696365732C20706174656E74206E6F74696365732C20646973636C61696D657273206F662077617272616E74792C206F72206C696D6974617469';
wwv_flow_api.g_varchar2_table(93) := '6F6E730D0A20202020206F66206C696162696C6974792920636F6E7461696E65642077697468696E2074686520536F7572636520436F646520466F726D206F662074686520436F76657265640D0A2020202020536F6674776172652C2065786365707420';
wwv_flow_api.g_varchar2_table(94) := '7468617420596F75206D617920616C74657220616E79206C6963656E7365206E6F746963657320746F2074686520657874656E740D0A2020202020726571756972656420746F2072656D656479206B6E6F776E206661637475616C20696E616363757261';
wwv_flow_api.g_varchar2_table(95) := '636965732E0D0A0D0A332E352E204170706C69636174696F6E206F66204164646974696F6E616C205465726D730D0A0D0A2020202020596F75206D61792063686F6F736520746F206F666665722C20616E6420746F206368617267652061206665652066';
wwv_flow_api.g_varchar2_table(96) := '6F722C2077617272616E74792C20737570706F72742C0D0A2020202020696E64656D6E697479206F72206C696162696C697479206F626C69676174696F6E7320746F206F6E65206F72206D6F726520726563697069656E7473206F6620436F7665726564';
wwv_flow_api.g_varchar2_table(97) := '0D0A2020202020536F6674776172652E20486F77657665722C20596F75206D617920646F20736F206F6E6C79206F6E20596F7572206F776E20626568616C662C20616E64206E6F74206F6E20626568616C660D0A20202020206F6620616E7920436F6E74';
wwv_flow_api.g_varchar2_table(98) := '72696275746F722E20596F75206D757374206D616B65206974206162736F6C7574656C7920636C656172207468617420616E7920737563680D0A202020202077617272616E74792C20737570706F72742C20696E64656D6E6974792C206F72206C696162';
wwv_flow_api.g_varchar2_table(99) := '696C697479206F626C69676174696F6E206973206F66666572656420627920596F750D0A2020202020616C6F6E652C20616E6420596F752068657265627920616772656520746F20696E64656D6E69667920657665727920436F6E7472696275746F7220';
wwv_flow_api.g_varchar2_table(100) := '666F7220616E790D0A20202020206C696162696C69747920696E637572726564206279207375636820436F6E7472696275746F72206173206120726573756C74206F662077617272616E74792C20737570706F72742C0D0A2020202020696E64656D6E69';
wwv_flow_api.g_varchar2_table(101) := '7479206F72206C696162696C697479207465726D7320596F75206F666665722E20596F75206D617920696E636C756465206164646974696F6E616C0D0A2020202020646973636C61696D657273206F662077617272616E747920616E64206C696D697461';
wwv_flow_api.g_varchar2_table(102) := '74696F6E73206F66206C696162696C69747920737065636966696320746F20616E790D0A20202020206A7572697364696374696F6E2E0D0A0D0A342E20496E6162696C69747920746F20436F6D706C792044756520746F2053746174757465206F722052';
wwv_flow_api.g_varchar2_table(103) := '6567756C6174696F6E0D0A0D0A202020496620697420697320696D706F737369626C6520666F7220596F7520746F20636F6D706C79207769746820616E79206F6620746865207465726D73206F662074686973204C6963656E73650D0A20202077697468';
wwv_flow_api.g_varchar2_table(104) := '207265737065637420746F20736F6D65206F7220616C6C206F662074686520436F766572656420536F6674776172652064756520746F20737461747574652C206A7564696369616C0D0A2020206F726465722C206F7220726567756C6174696F6E207468';
wwv_flow_api.g_varchar2_table(105) := '656E20596F75206D7573743A2028612920636F6D706C79207769746820746865207465726D73206F662074686973204C6963656E73650D0A202020746F20746865206D6178696D756D20657874656E7420706F737369626C653B20616E64202862292064';
wwv_flow_api.g_varchar2_table(106) := '6573637269626520746865206C696D69746174696F6E7320616E642074686520636F64650D0A20202074686579206166666563742E2053756368206465736372697074696F6E206D75737420626520706C6163656420696E206120746578742066696C65';
wwv_flow_api.g_varchar2_table(107) := '20696E636C75646564207769746820616C6C0D0A202020646973747269627574696F6E73206F662074686520436F766572656420536F66747761726520756E6465722074686973204C6963656E73652E2045786365707420746F207468650D0A20202065';
wwv_flow_api.g_varchar2_table(108) := '7874656E742070726F686962697465642062792073746174757465206F7220726567756C6174696F6E2C2073756368206465736372697074696F6E206D7573742062650D0A20202073756666696369656E746C792064657461696C656420666F72206120';
wwv_flow_api.g_varchar2_table(109) := '726563697069656E74206F66206F7264696E61727920736B696C6C20746F2062652061626C6520746F0D0A202020756E6465727374616E642069742E0D0A0D0A352E205465726D696E6174696F6E0D0A0D0A352E312E2054686520726967687473206772';
wwv_flow_api.g_varchar2_table(110) := '616E74656420756E6465722074686973204C6963656E73652077696C6C207465726D696E617465206175746F6D61746963616C6C7920696620596F750D0A20202020206661696C20746F20636F6D706C79207769746820616E79206F6620697473207465';
wwv_flow_api.g_varchar2_table(111) := '726D732E20486F77657665722C20696620596F75206265636F6D6520636F6D706C69616E742C0D0A20202020207468656E2074686520726967687473206772616E74656420756E6465722074686973204C6963656E73652066726F6D2061207061727469';
wwv_flow_api.g_varchar2_table(112) := '63756C617220436F6E7472696275746F720D0A2020202020617265207265696E737461746564202861292070726F766973696F6E616C6C792C20756E6C65737320616E6420756E74696C207375636820436F6E7472696275746F720D0A20202020206578';
wwv_flow_api.g_varchar2_table(113) := '706C696369746C7920616E642066696E616C6C79207465726D696E6174657320596F7572206772616E74732C20616E6420286229206F6E20616E206F6E676F696E672062617369732C0D0A20202020206966207375636820436F6E7472696275746F7220';
wwv_flow_api.g_varchar2_table(114) := '6661696C7320746F206E6F7469667920596F75206F6620746865206E6F6E2D636F6D706C69616E636520627920736F6D650D0A2020202020726561736F6E61626C65206D65616E73207072696F7220746F203630206461797320616674657220596F7520';
wwv_flow_api.g_varchar2_table(115) := '6861766520636F6D65206261636B20696E746F20636F6D706C69616E63652E0D0A20202020204D6F72656F7665722C20596F7572206772616E74732066726F6D206120706172746963756C617220436F6E7472696275746F7220617265207265696E7374';
wwv_flow_api.g_varchar2_table(116) := '61746564206F6E20616E0D0A20202020206F6E676F696E67206261736973206966207375636820436F6E7472696275746F72206E6F74696669657320596F75206F6620746865206E6F6E2D636F6D706C69616E63652062790D0A2020202020736F6D6520';
wwv_flow_api.g_varchar2_table(117) := '726561736F6E61626C65206D65616E732C2074686973206973207468652066697273742074696D6520596F752068617665207265636569766564206E6F74696365206F660D0A20202020206E6F6E2D636F6D706C69616E63652077697468207468697320';
wwv_flow_api.g_varchar2_table(118) := '4C6963656E73652066726F6D207375636820436F6E7472696275746F722C20616E6420596F75206265636F6D650D0A2020202020636F6D706C69616E74207072696F7220746F203330206461797320616674657220596F75722072656365697074206F66';
wwv_flow_api.g_varchar2_table(119) := '20746865206E6F746963652E0D0A0D0A352E322E20496620596F7520696E697469617465206C697469676174696F6E20616761696E737420616E7920656E7469747920627920617373657274696E67206120706174656E740D0A2020202020696E667269';
wwv_flow_api.g_varchar2_table(120) := '6E67656D656E7420636C61696D20286578636C7564696E67206465636C617261746F7279206A7564676D656E7420616374696F6E732C20636F756E7465722D636C61696D732C0D0A2020202020616E642063726F73732D636C61696D732920616C6C6567';
wwv_flow_api.g_varchar2_table(121) := '696E672074686174206120436F6E7472696275746F722056657273696F6E206469726563746C79206F720D0A2020202020696E6469726563746C7920696E6672696E67657320616E7920706174656E742C207468656E2074686520726967687473206772';
wwv_flow_api.g_varchar2_table(122) := '616E74656420746F20596F7520627920616E7920616E640D0A2020202020616C6C20436F6E7472696275746F727320666F722074686520436F766572656420536F66747761726520756E6465722053656374696F6E20322E31206F662074686973204C69';
wwv_flow_api.g_varchar2_table(123) := '63656E73650D0A20202020207368616C6C207465726D696E6174652E0D0A0D0A352E332E20496E20746865206576656E74206F66207465726D696E6174696F6E20756E6465722053656374696F6E7320352E31206F7220352E322061626F76652C20616C';
wwv_flow_api.g_varchar2_table(124) := '6C20656E6420757365720D0A20202020206C6963656E73652061677265656D656E747320286578636C7564696E67206469737472696275746F727320616E6420726573656C6C657273292077686963682068617665206265656E0D0A202020202076616C';
wwv_flow_api.g_varchar2_table(125) := '69646C79206772616E74656420627920596F75206F7220596F7572206469737472696275746F727320756E6465722074686973204C6963656E7365207072696F7220746F0D0A20202020207465726D696E6174696F6E207368616C6C2073757276697665';
wwv_flow_api.g_varchar2_table(126) := '207465726D696E6174696F6E2E0D0A0D0A362E20446973636C61696D6572206F662057617272616E74790D0A0D0A202020436F766572656420536F6674776172652069732070726F766964656420756E6465722074686973204C6963656E7365206F6E20';
wwv_flow_api.g_varchar2_table(127) := '616E20936173206973942062617369732C20776974686F75740D0A20202077617272616E7479206F6620616E79206B696E642C20656974686572206578707265737365642C20696D706C6965642C206F72207374617475746F72792C20696E636C756469';
wwv_flow_api.g_varchar2_table(128) := '6E672C0D0A202020776974686F7574206C696D69746174696F6E2C2077617272616E7469657320746861742074686520436F766572656420536F6674776172652069732066726565206F6620646566656374732C0D0A2020206D65726368616E7461626C';
wwv_flow_api.g_varchar2_table(129) := '652C2066697420666F72206120706172746963756C617220707572706F7365206F72206E6F6E2D696E6672696E67696E672E2054686520656E746972650D0A2020207269736B20617320746F20746865207175616C69747920616E6420706572666F726D';
wwv_flow_api.g_varchar2_table(130) := '616E6365206F662074686520436F766572656420536F667477617265206973207769746820596F752E0D0A20202053686F756C6420616E7920436F766572656420536F6674776172652070726F76652064656665637469766520696E20616E7920726573';
wwv_flow_api.g_varchar2_table(131) := '706563742C20596F7520286E6F7420616E790D0A202020436F6E7472696275746F722920617373756D652074686520636F7374206F6620616E79206E656365737361727920736572766963696E672C207265706169722C206F720D0A202020636F727265';
wwv_flow_api.g_varchar2_table(132) := '6374696F6E2E205468697320646973636C61696D6572206F662077617272616E747920636F6E737469747574657320616E20657373656E7469616C2070617274206F6620746869730D0A2020204C6963656E73652E204E6F20757365206F662020616E79';
wwv_flow_api.g_varchar2_table(133) := '20436F766572656420536F66747761726520697320617574686F72697A656420756E6465722074686973204C6963656E73650D0A20202065786365707420756E646572207468697320646973636C61696D65722E0D0A0D0A372E204C696D69746174696F';
wwv_flow_api.g_varchar2_table(134) := '6E206F66204C696162696C6974790D0A0D0A202020556E646572206E6F2063697263756D7374616E63657320616E6420756E646572206E6F206C6567616C207468656F72792C207768657468657220746F72742028696E636C7564696E670D0A2020206E';
wwv_flow_api.g_varchar2_table(135) := '65676C6967656E6365292C20636F6E74726163742C206F72206F74686572776973652C207368616C6C20616E7920436F6E7472696275746F722C206F7220616E796F6E652077686F0D0A202020646973747269627574657320436F766572656420536F66';
wwv_flow_api.g_varchar2_table(136) := '7477617265206173207065726D69747465642061626F76652C206265206C6961626C6520746F20596F7520666F7220616E790D0A2020206469726563742C20696E6469726563742C207370656369616C2C20696E636964656E74616C2C206F7220636F6E';
wwv_flow_api.g_varchar2_table(137) := '73657175656E7469616C2064616D61676573206F6620616E790D0A20202063686172616374657220696E636C7564696E672C20776974686F7574206C696D69746174696F6E2C2064616D6167657320666F72206C6F73742070726F666974732C206C6F73';
wwv_flow_api.g_varchar2_table(138) := '73206F660D0A202020676F6F6477696C6C2C20776F726B2073746F70706167652C20636F6D7075746572206661696C757265206F72206D616C66756E6374696F6E2C206F7220616E7920616E6420616C6C0D0A2020206F7468657220636F6D6D65726369';
wwv_flow_api.g_varchar2_table(139) := '616C2064616D61676573206F72206C6F737365732C206576656E2069662073756368207061727479207368616C6C2068617665206265656E0D0A202020696E666F726D6564206F662074686520706F73736962696C697479206F6620737563682064616D';
wwv_flow_api.g_varchar2_table(140) := '616765732E2054686973206C696D69746174696F6E206F66206C696162696C6974790D0A2020207368616C6C206E6F74206170706C7920746F206C696162696C69747920666F72206465617468206F7220706572736F6E616C20696E6A75727920726573';
wwv_flow_api.g_varchar2_table(141) := '756C74696E672066726F6D20737563680D0A20202070617274799273206E65676C6967656E636520746F2074686520657874656E74206170706C696361626C65206C61772070726F6869626974732073756368206C696D69746174696F6E2E0D0A202020';
wwv_flow_api.g_varchar2_table(142) := '536F6D65206A7572697364696374696F6E7320646F206E6F7420616C6C6F7720746865206578636C7573696F6E206F72206C696D69746174696F6E206F6620696E636964656E74616C206F720D0A202020636F6E73657175656E7469616C2064616D6167';
wwv_flow_api.g_varchar2_table(143) := '65732C20736F2074686973206578636C7573696F6E20616E64206C696D69746174696F6E206D6179206E6F74206170706C7920746F20596F752E0D0A0D0A382E204C697469676174696F6E0D0A0D0A202020416E79206C697469676174696F6E2072656C';
wwv_flow_api.g_varchar2_table(144) := '6174696E6720746F2074686973204C6963656E7365206D61792062652062726F75676874206F6E6C7920696E2074686520636F75727473206F660D0A20202061206A7572697364696374696F6E2077686572652074686520646566656E64616E74206D61';
wwv_flow_api.g_varchar2_table(145) := '696E7461696E7320697473207072696E636970616C20706C616365206F6620627573696E6573730D0A202020616E642073756368206C697469676174696F6E207368616C6C20626520676F7665726E6564206279206C617773206F662074686174206A75';
wwv_flow_api.g_varchar2_table(146) := '72697364696374696F6E2C20776974686F75740D0A2020207265666572656E636520746F2069747320636F6E666C6963742D6F662D6C61772070726F766973696F6E732E204E6F7468696E6720696E20746869732053656374696F6E207368616C6C0D0A';
wwv_flow_api.g_varchar2_table(147) := '20202070726576656E7420612070617274799273206162696C69747920746F206272696E672063726F73732D636C61696D73206F7220636F756E7465722D636C61696D732E0D0A0D0A392E204D697363656C6C616E656F75730D0A0D0A20202054686973';
wwv_flow_api.g_varchar2_table(148) := '204C6963656E736520726570726573656E74732074686520636F6D706C6574652061677265656D656E7420636F6E6365726E696E6720746865207375626A656374206D61747465720D0A202020686572656F662E20496620616E792070726F766973696F';
wwv_flow_api.g_varchar2_table(149) := '6E206F662074686973204C6963656E73652069732068656C6420746F20626520756E656E666F72636561626C652C20737563680D0A20202070726F766973696F6E207368616C6C206265207265666F726D6564206F6E6C7920746F207468652065787465';
wwv_flow_api.g_varchar2_table(150) := '6E74206E656365737361727920746F206D616B652069740D0A202020656E666F72636561626C652E20416E79206C6177206F7220726567756C6174696F6E2077686963682070726F7669646573207468617420746865206C616E6775616765206F662061';
wwv_flow_api.g_varchar2_table(151) := '0D0A202020636F6E7472616374207368616C6C20626520636F6E73747275656420616761696E7374207468652064726166746572207368616C6C206E6F74206265207573656420746F20636F6E73747275650D0A20202074686973204C6963656E736520';
wwv_flow_api.g_varchar2_table(152) := '616761696E7374206120436F6E7472696275746F722E0D0A0D0A0D0A31302E2056657273696F6E73206F6620746865204C6963656E73650D0A0D0A31302E312E204E65772056657273696F6E730D0A0D0A2020202020204D6F7A696C6C6120466F756E64';
wwv_flow_api.g_varchar2_table(153) := '6174696F6E20697320746865206C6963656E736520737465776172642E204578636570742061732070726F766964656420696E2053656374696F6E0D0A20202020202031302E332C206E6F206F6E65206F74686572207468616E20746865206C6963656E';
wwv_flow_api.g_varchar2_table(154) := '73652073746577617264206861732074686520726967687420746F206D6F64696679206F720D0A2020202020207075626C697368206E65772076657273696F6E73206F662074686973204C6963656E73652E20456163682076657273696F6E2077696C6C';
wwv_flow_api.g_varchar2_table(155) := '20626520676976656E20610D0A20202020202064697374696E6775697368696E672076657273696F6E206E756D6265722E0D0A0D0A31302E322E20456666656374206F66204E65772056657273696F6E730D0A0D0A202020202020596F75206D61792064';
wwv_flow_api.g_varchar2_table(156) := '6973747269627574652074686520436F766572656420536F66747761726520756E64657220746865207465726D73206F66207468652076657273696F6E206F660D0A202020202020746865204C6963656E736520756E64657220776869636820596F7520';
wwv_flow_api.g_varchar2_table(157) := '6F726967696E616C6C792072656365697665642074686520436F766572656420536F6674776172652C206F720D0A202020202020756E64657220746865207465726D73206F6620616E792073756273657175656E742076657273696F6E207075626C6973';
wwv_flow_api.g_varchar2_table(158) := '68656420627920746865206C6963656E73650D0A202020202020737465776172642E0D0A0D0A31302E332E204D6F6469666965642056657273696F6E730D0A0D0A202020202020496620796F752063726561746520736F667477617265206E6F7420676F';
wwv_flow_api.g_varchar2_table(159) := '7665726E65642062792074686973204C6963656E73652C20616E6420796F752077616E7420746F0D0A2020202020206372656174652061206E6577206C6963656E736520666F72207375636820736F6674776172652C20796F75206D6179206372656174';
wwv_flow_api.g_varchar2_table(160) := '6520616E64207573652061206D6F6469666965640D0A20202020202076657273696F6E206F662074686973204C6963656E736520696620796F752072656E616D6520746865206C6963656E736520616E642072656D6F766520616E790D0A202020202020';
wwv_flow_api.g_varchar2_table(161) := '7265666572656E63657320746F20746865206E616D65206F6620746865206C6963656E73652073746577617264202865786365707420746F206E6F7465207468617420737563680D0A2020202020206D6F646966696564206C6963656E73652064696666';
wwv_flow_api.g_varchar2_table(162) := '6572732066726F6D2074686973204C6963656E7365292E0D0A0D0A31302E342E20446973747269627574696E6720536F7572636520436F646520466F726D207468617420697320496E636F6D70617469626C652057697468205365636F6E64617279204C';
wwv_flow_api.g_varchar2_table(163) := '6963656E7365730D0A202020202020496620596F752063686F6F736520746F206469737472696275746520536F7572636520436F646520466F726D207468617420697320496E636F6D70617469626C6520576974680D0A2020202020205365636F6E6461';
wwv_flow_api.g_varchar2_table(164) := '7279204C6963656E73657320756E64657220746865207465726D73206F6620746869732076657273696F6E206F6620746865204C6963656E73652C207468650D0A2020202020206E6F746963652064657363726962656420696E20457868696269742042';
wwv_flow_api.g_varchar2_table(165) := '206F662074686973204C6963656E7365206D7573742062652061747461636865642E0D0A0D0A457868696269742041202D20536F7572636520436F646520466F726D204C6963656E7365204E6F746963650D0A0D0A2020202020205468697320536F7572';
wwv_flow_api.g_varchar2_table(166) := '636520436F646520466F726D206973207375626A65637420746F207468650D0A2020202020207465726D73206F6620746865204D6F7A696C6C61205075626C6963204C6963656E73652C20762E0D0A202020202020322E302E204966206120636F707920';
wwv_flow_api.g_varchar2_table(167) := '6F6620746865204D504C20776173206E6F740D0A2020202020206469737472696275746564207769746820746869732066696C652C20596F752063616E0D0A2020202020206F627461696E206F6E652061740D0A202020202020687474703A2F2F6D6F7A';
wwv_flow_api.g_varchar2_table(168) := '696C6C612E6F72672F4D504C2F322E302F2E0D0A0D0A4966206974206973206E6F7420706F737369626C65206F7220646573697261626C6520746F2070757420746865206E6F7469636520696E206120706172746963756C61722066696C652C20746865';
wwv_flow_api.g_varchar2_table(169) := '6E0D0A596F75206D617920696E636C75646520746865206E6F7469636520696E2061206C6F636174696F6E2028737563682061732061204C4943454E53452066696C6520696E20612072656C6576616E740D0A6469726563746F72792920776865726520';
wwv_flow_api.g_varchar2_table(170) := '6120726563697069656E7420776F756C64206265206C696B656C7920746F206C6F6F6B20666F7220737563682061206E6F746963652E0D0A0D0A596F75206D617920616464206164646974696F6E616C206163637572617465206E6F7469636573206F66';
wwv_flow_api.g_varchar2_table(171) := '20636F70797269676874206F776E6572736869702E0D0A0D0A457868696269742042202D2093496E636F6D70617469626C652057697468205365636F6E64617279204C6963656E73657394204E6F746963650D0A0D0A2020202020205468697320536F75';
wwv_flow_api.g_varchar2_table(172) := '72636520436F646520466F726D2069732093496E636F6D70617469626C650D0A20202020202057697468205365636F6E64617279204C6963656E736573942C20617320646566696E65642062790D0A202020202020746865204D6F7A696C6C6120507562';
wwv_flow_api.g_varchar2_table(173) := '6C6963204C6963656E73652C20762E20322E302E0D0A0D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(83943095459963075518)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_file_name=>'LICENSE4LIBS'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E28652C74297B226F626A656374223D3D747970656F66206578706F727473262622756E646566696E656422213D747970656F66206D6F64756C653F6D6F64756C652E6578706F7274733D7428293A2266756E6374696F6E223D3D74';
wwv_flow_api.g_varchar2_table(2) := '7970656F6620646566696E652626646566696E652E616D643F646566696E652874293A28653D657C7C73656C662C652E444F4D5075726966793D742829297D28746869732C66756E6374696F6E28297B2275736520737472696374223B66756E6374696F';
wwv_flow_api.g_varchar2_table(3) := '6E20652865297B72657475726E2066756E6374696F6E2874297B666F722876617220613D617267756D656E74732E6C656E6774682C723D417272617928613E313F612D313A30292C6E3D313B6E3C613B6E2B2B29725B6E2D315D3D617267756D656E7473';
wwv_flow_api.g_varchar2_table(4) := '5B6E5D3B72657475726E206728652C742C72297D7D66756E6374696F6E207428652C74297B7326267328652C6E756C6C293B666F722876617220613D742E6C656E6774683B612D2D3B297B76617220723D745B615D3B69662822737472696E67223D3D74';
wwv_flow_api.g_varchar2_table(5) := '7970656F662072297B766172206E3D442872293B6E213D3D722626286C2874297C7C28745B615D3D6E292C723D6E297D655B725D3D21307D72657475726E20657D66756E6374696F6E20612865297B76617220743D70286E756C6C292C613D766F696420';
wwv_flow_api.g_varchar2_table(6) := '303B666F72286120696E20652967286F2C652C5B615D29262628745B615D3D655B615D293B72657475726E20747D66756E6374696F6E207228742C61297B666F72283B6E756C6C213D3D743B297B76617220723D6628742C61293B69662872297B696628';
wwv_flow_api.g_varchar2_table(7) := '722E6765742972657475726E206528722E676574293B6966282266756E6374696F6E223D3D747970656F6620722E76616C75652972657475726E206528722E76616C7565297D743D752874297D72657475726E2066756E6374696F6E2865297B72657475';
wwv_flow_api.g_varchar2_table(8) := '726E20636F6E736F6C652E7761726E282266616C6C6261636B2076616C756520666F72222C65292C6E756C6C7D7D66756E6374696F6E206E2865297B69662841727261792E69734172726179286529297B666F722876617220743D302C613D4172726179';
wwv_flow_api.g_varchar2_table(9) := '28652E6C656E677468293B743C652E6C656E6774683B742B2B29615B745D3D655B745D3B72657475726E20617D72657475726E2041727261792E66726F6D2865297D66756E6374696F6E206928297B76617220653D617267756D656E74732E6C656E6774';
wwv_flow_api.g_varchar2_table(10) := '683E302626766F69642030213D3D617267756D656E74735B305D3F617267756D656E74735B305D3A4728292C6F3D66756E6374696F6E2865297B72657475726E20692865297D3B6966286F2E76657273696F6E3D22322E322E39222C6F2E72656D6F7665';
wwv_flow_api.g_varchar2_table(11) := '643D5B5D2C21657C7C21652E646F63756D656E747C7C39213D3D652E646F63756D656E742E6E6F6465547970652972657475726E206F2E6973537570706F727465643D21312C6F3B76617220733D652E646F63756D656E742C6C3D652E646F63756D656E';
wwv_flow_api.g_varchar2_table(12) := '742C753D652E446F63756D656E74467261676D656E742C663D652E48544D4C54656D706C617465456C656D656E742C633D652E4E6F64652C703D652E456C656D656E742C6D3D652E4E6F646546696C7465722C673D652E4E616D65644E6F64654D61702C';
wwv_flow_api.g_varchar2_table(13) := '683D766F696420303D3D3D673F652E4E616D65644E6F64654D61707C7C652E4D6F7A4E616D6564417474724D61703A672C4B3D652E546578742C4A3D652E436F6D6D656E742C583D652E444F4D5061727365722C593D652E747275737465645479706573';
wwv_flow_api.g_varchar2_table(14) := '2C513D702E70726F746F747970652C5A3D7228512C22636C6F6E654E6F646522292C65653D7228512C226E6578745369626C696E6722292C74653D7228512C226368696C644E6F64657322292C61653D7228512C22706172656E744E6F646522293B6966';
wwv_flow_api.g_varchar2_table(15) := '282266756E6374696F6E223D3D747970656F662066297B7661722072653D6C2E637265617465456C656D656E74282274656D706C61746522293B72652E636F6E74656E74262672652E636F6E74656E742E6F776E6572446F63756D656E742626286C3D72';
wwv_flow_api.g_varchar2_table(16) := '652E636F6E74656E742E6F776E6572446F63756D656E74297D766172206E653D7128592C73292C69653D6E65262648653F6E652E63726561746548544D4C282222293A22222C6F653D6C2C73653D6F652E696D706C656D656E746174696F6E2C6C653D6F';
wwv_flow_api.g_varchar2_table(17) := '652E6372656174654E6F64654974657261746F722C75653D6F652E637265617465446F63756D656E74467261676D656E742C66653D732E696D706F72744E6F64652C64653D7B7D3B7472797B64653D61286C292E646F63756D656E744D6F64653F6C2E64';
wwv_flow_api.g_varchar2_table(18) := '6F63756D656E744D6F64653A7B7D7D63617463682865297B7D7661722063653D7B7D3B6F2E6973537570706F727465643D2266756E6374696F6E223D3D747970656F66206165262673652626766F69642030213D3D73652E63726561746548544D4C446F';
wwv_flow_api.g_varchar2_table(19) := '63756D656E74262639213D3D64653B7661722070653D552C6D653D7A2C67653D6A2C68653D502C76653D422C79653D572C62653D562C44653D6E756C6C2C78653D74287B7D2C5B5D2E636F6E636174286E284F292C6E2849292C6E284C292C6E286B292C';
wwv_flow_api.g_varchar2_table(20) := '6E284D2929292C54653D6E756C6C2C45653D74287B7D2C5B5D2E636F6E636174286E284E292C6E2843292C6E2848292C6E28462929292C77653D6E756C6C2C41653D6E756C6C2C53653D21302C4F653D21302C49653D21312C4C653D21312C52653D2131';
wwv_flow_api.g_varchar2_table(21) := '2C6B653D21312C5F653D21312C4D653D21312C4E653D21312C43653D21302C48653D21312C46653D21302C55653D21302C7A653D21312C6A653D7B7D2C50653D74287B7D2C5B22616E6E6F746174696F6E2D786D6C222C22617564696F222C22636F6C67';
wwv_flow_api.g_varchar2_table(22) := '726F7570222C2264657363222C22666F726569676E6F626A656374222C2268656164222C22696672616D65222C226D617468222C226D69222C226D6E222C226D6F222C226D73222C226D74657874222C226E6F656D626564222C226E6F6672616D657322';
wwv_flow_api.g_varchar2_table(23) := '2C226E6F736372697074222C22706C61696E74657874222C22736372697074222C227374796C65222C22737667222C2274656D706C617465222C227468656164222C227469746C65222C22766964656F222C22786D70225D292C56653D6E756C6C2C4265';
wwv_flow_api.g_varchar2_table(24) := '3D74287B7D2C5B22617564696F222C22766964656F222C22696D67222C22736F75726365222C22696D616765222C22747261636B225D292C57653D6E756C6C2C24653D74287B7D2C5B22616C74222C22636C617373222C22666F72222C226964222C226C';
wwv_flow_api.g_varchar2_table(25) := '6162656C222C226E616D65222C227061747465726E222C22706C616365686F6C646572222C2273756D6D617279222C227469746C65222C2276616C7565222C227374796C65222C22786D6C6E73225D292C47653D22687474703A2F2F7777772E77332E6F';
wwv_flow_api.g_varchar2_table(26) := '72672F313939382F4D6174682F4D6174684D4C222C71653D22687474703A2F2F7777772E77332E6F72672F323030302F737667222C4B653D22687474703A2F2F7777772E77332E6F72672F313939392F7868746D6C222C4A653D4B652C58653D21312C59';
wwv_flow_api.g_varchar2_table(27) := '653D6E756C6C2C51653D6C2E637265617465456C656D656E742822666F726D22292C5A653D66756E6374696F6E2865297B5965262659653D3D3D657C7C28652626226F626A656374223D3D3D28766F696420303D3D3D653F22756E646566696E6564223A';
wwv_flow_api.g_varchar2_table(28) := '24286529297C7C28653D7B7D292C653D612865292C44653D22414C4C4F5745445F5441475322696E20653F74287B7D2C652E414C4C4F5745445F54414753293A78652C54653D22414C4C4F5745445F4154545222696E20653F74287B7D2C652E414C4C4F';
wwv_flow_api.g_varchar2_table(29) := '5745445F41545452293A45652C57653D224144445F5552495F534146455F4154545222696E20653F742861282465292C652E4144445F5552495F534146455F41545452293A24652C56653D224144445F444154415F5552495F5441475322696E20653F74';
wwv_flow_api.g_varchar2_table(30) := '2861284265292C652E4144445F444154415F5552495F54414753293A42652C77653D22464F524249445F5441475322696E20653F74287B7D2C652E464F524249445F54414753293A7B7D2C41653D22464F524249445F4154545222696E20653F74287B7D';
wwv_flow_api.g_varchar2_table(31) := '2C652E464F524249445F41545452293A7B7D2C6A653D225553455F50524F46494C455322696E20652626652E5553455F50524F46494C45532C53653D2131213D3D652E414C4C4F575F415249415F415454522C4F653D2131213D3D652E414C4C4F575F44';
wwv_flow_api.g_varchar2_table(32) := '4154415F415454522C49653D652E414C4C4F575F554E4B4E4F574E5F50524F544F434F4C537C7C21312C4C653D652E534146455F464F525F54454D504C415445537C7C21312C52653D652E57484F4C455F444F43554D454E547C7C21312C4D653D652E52';
wwv_flow_api.g_varchar2_table(33) := '455455524E5F444F4D7C7C21312C4E653D652E52455455524E5F444F4D5F465241474D454E547C7C21312C43653D2131213D3D652E52455455524E5F444F4D5F494D504F52542C48653D652E52455455524E5F545255535445445F545950457C7C21312C';
wwv_flow_api.g_varchar2_table(34) := '5F653D652E464F5243455F424F44597C7C21312C46653D2131213D3D652E53414E4954495A455F444F4D2C55653D2131213D3D652E4B4545505F434F4E54454E542C7A653D652E494E5F504C4143457C7C21312C62653D652E414C4C4F5745445F555249';
wwv_flow_api.g_varchar2_table(35) := '5F5245474558507C7C62652C4A653D652E4E414D4553504143457C7C4B652C4C652626284F653D2131292C4E652626284D653D2130292C6A6526262844653D74287B7D2C5B5D2E636F6E636174286E284D2929292C54653D5B5D2C21303D3D3D6A652E68';
wwv_flow_api.g_varchar2_table(36) := '746D6C262628742844652C4F292C742854652C4E29292C21303D3D3D6A652E737667262628742844652C49292C742854652C43292C742854652C4629292C21303D3D3D6A652E73766746696C74657273262628742844652C4C292C742854652C43292C74';
wwv_flow_api.g_varchar2_table(37) := '2854652C4629292C21303D3D3D6A652E6D6174684D6C262628742844652C6B292C742854652C48292C742854652C462929292C652E4144445F5441475326262844653D3D3D786526262844653D6128446529292C742844652C652E4144445F5441475329';
wwv_flow_api.g_varchar2_table(38) := '292C652E4144445F4154545226262854653D3D3D456526262854653D6128546529292C742854652C652E4144445F4154545229292C652E4144445F5552495F534146455F415454522626742857652C652E4144445F5552495F534146455F41545452292C';
wwv_flow_api.g_varchar2_table(39) := '556526262844655B222374657874225D3D2130292C52652626742844652C5B2268746D6C222C2268656164222C22626F6479225D292C44652E7461626C65262628742844652C5B2274626F6479225D292C64656C6574652077652E74626F6479292C6426';
wwv_flow_api.g_varchar2_table(40) := '26642865292C59653D65297D2C65743D74287B7D2C5B226D69222C226D6F222C226D6E222C226D73222C226D74657874225D292C74743D74287B7D2C5B22666F726569676E6F626A656374222C2264657363222C227469746C65222C22616E6E6F746174';
wwv_flow_api.g_varchar2_table(41) := '696F6E2D786D6C225D292C61743D74287B7D2C49293B742861742C4C292C742861742C52293B7661722072743D74287B7D2C6B293B742872742C5F293B766172206E743D66756E6374696F6E2865297B62286F2E72656D6F7665642C7B656C656D656E74';
wwv_flow_api.g_varchar2_table(42) := '3A657D293B7472797B652E706172656E744E6F64652E72656D6F76654368696C642865297D63617463682874297B7472797B652E6F7574657248544D4C3D69657D63617463682874297B652E72656D6F766528297D7D7D2C69743D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(43) := '652C74297B7472797B62286F2E72656D6F7665642C7B6174747269627574653A742E6765744174747269627574654E6F64652865292C66726F6D3A747D297D63617463682865297B62286F2E72656D6F7665642C7B6174747269627574653A6E756C6C2C';
wwv_flow_api.g_varchar2_table(44) := '66726F6D3A747D297D696628742E72656D6F76654174747269627574652865292C226973223D3D3D6526262154655B655D296966284D657C7C4E65297472797B6E742874297D63617463682865297B7D656C7365207472797B742E736574417474726962';
wwv_flow_api.g_varchar2_table(45) := '75746528652C2222297D63617463682865297B7D7D2C6F743D66756E6374696F6E2865297B76617220743D766F696420302C613D766F696420303B6966285F6529653D223C72656D6F76653E3C2F72656D6F76653E222B653B656C73657B76617220723D';
wwv_flow_api.g_varchar2_table(46) := '7828652C2F5E5B5C725C6E5C74205D2B2F293B613D722626725B305D7D766172206E3D6E653F6E652E63726561746548544D4C2865293A653B6966284A653D3D3D4B65297472797B743D286E65772058292E706172736546726F6D537472696E67286E2C';
wwv_flow_api.g_varchar2_table(47) := '22746578742F68746D6C22297D63617463682865297B7D69662821747C7C21742E646F63756D656E74456C656D656E74297B743D73652E637265617465446F63756D656E74284A652C2274656D706C617465222C6E756C6C293B7472797B742E646F6375';
wwv_flow_api.g_varchar2_table(48) := '6D656E74456C656D656E742E696E6E657248544D4C3D58653F22223A6E7D63617463682865297B7D7D76617220693D742E626F64797C7C742E646F63756D656E74456C656D656E743B72657475726E20652626612626692E696E736572744265666F7265';
wwv_flow_api.g_varchar2_table(49) := '286C2E637265617465546578744E6F64652861292C692E6368696C644E6F6465735B305D7C7C6E756C6C292C52653F742E646F63756D656E74456C656D656E743A697D2C73743D66756E6374696F6E2865297B72657475726E206C652E63616C6C28652E';
wwv_flow_api.g_varchar2_table(50) := '6F776E6572446F63756D656E747C7C652C652C6D2E53484F575F454C454D454E547C6D2E53484F575F434F4D4D454E547C6D2E53484F575F544558542C6E756C6C2C2131297D2C6C743D66756E6374696F6E2865297B72657475726E226F626A65637422';
wwv_flow_api.g_varchar2_table(51) := '3D3D3D28766F696420303D3D3D633F22756E646566696E6564223A24286329293F6520696E7374616E63656F6620633A652626226F626A656374223D3D3D28766F696420303D3D3D653F22756E646566696E6564223A24286529292626226E756D626572';
wwv_flow_api.g_varchar2_table(52) := '223D3D747970656F6620652E6E6F646554797065262622737472696E67223D3D747970656F6620652E6E6F64654E616D657D2C75743D66756E6374696F6E28652C742C61297B63655B655D2626762863655B655D2C66756E6374696F6E2865297B652E63';
wwv_flow_api.g_varchar2_table(53) := '616C6C286F2C742C612C5965297D297D2C66743D66756E6374696F6E2865297B76617220613D766F696420303B696628757428226265666F726553616E6974697A65456C656D656E7473222C652C6E756C6C292C66756E6374696F6E2865297B72657475';
wwv_flow_api.g_varchar2_table(54) := '726E21286520696E7374616E63656F66204B7C7C6520696E7374616E63656F66204A7C7C22737472696E67223D3D747970656F6620652E6E6F64654E616D65262622737472696E67223D3D747970656F6620652E74657874436F6E74656E742626226675';
wwv_flow_api.g_varchar2_table(55) := '6E6374696F6E223D3D747970656F6620652E72656D6F76654368696C642626652E6174747269627574657320696E7374616E63656F66206826262266756E6374696F6E223D3D747970656F6620652E72656D6F766541747472696275746526262266756E';
wwv_flow_api.g_varchar2_table(56) := '6374696F6E223D3D747970656F6620652E736574417474726962757465262622737472696E67223D3D747970656F6620652E6E616D65737061636555524926262266756E6374696F6E223D3D747970656F6620652E696E736572744265666F7265297D28';
wwv_flow_api.g_varchar2_table(57) := '65292972657475726E206E742865292C21303B6966287828652E6E6F64654E616D652C2F5B5C75303038302D5C75464646465D2F292972657475726E206E742865292C21303B76617220723D4428652E6E6F64654E616D65293B6966287574282275706F';
wwv_flow_api.g_varchar2_table(58) := '6E53616E6974697A65456C656D656E74222C652C7B7461674E616D653A722C616C6C6F776564546167733A44657D292C216C7428652E6669727374456C656D656E744368696C6429262628216C7428652E636F6E74656E74297C7C216C7428652E636F6E';
wwv_flow_api.g_varchar2_table(59) := '74656E742E6669727374456C656D656E744368696C642929262641282F3C5B2F5C775D2F672C652E696E6E657248544D4C29262641282F3C5B2F5C775D2F672C652E74657874436F6E74656E74292972657475726E206E742865292C21303B6966282144';
wwv_flow_api.g_varchar2_table(60) := '655B725D7C7C77655B725D297B696628556526262150655B725D297B766172206E3D61652865297C7C652E706172656E744E6F64652C693D74652865297C7C652E6368696C644E6F6465733B6966286926266E29666F722876617220733D692E6C656E67';
wwv_flow_api.g_varchar2_table(61) := '74682D313B733E3D303B2D2D73296E2E696E736572744265666F7265285A28695B735D2C2130292C6565286529297D72657475726E206E742865292C21307D72657475726E206520696E7374616E63656F66207026262166756E6374696F6E2865297B76';
wwv_flow_api.g_varchar2_table(62) := '617220613D61652865293B612626612E7461674E616D657C7C28613D7B6E616D6573706163655552493A4B652C7461674E616D653A2274656D706C617465227D293B76617220723D4428652E7461674E616D65292C6E3D4428612E7461674E616D65293B';
wwv_flow_api.g_varchar2_table(63) := '696628652E6E616D6573706163655552493D3D3D71652972657475726E20612E6E616D6573706163655552493D3D3D4B653F22737667223D3D3D723A612E6E616D6573706163655552493D3D3D47653F22737667223D3D3D7226262822616E6E6F746174';
wwv_flow_api.g_varchar2_table(64) := '696F6E2D786D6C223D3D3D6E7C7C65745B6E5D293A426F6F6C65616E2861745B725D293B696628652E6E616D6573706163655552493D3D3D47652972657475726E20612E6E616D6573706163655552493D3D3D4B653F226D617468223D3D3D723A612E6E';
wwv_flow_api.g_varchar2_table(65) := '616D6573706163655552493D3D3D71653F226D617468223D3D3D72262674745B6E5D3A426F6F6C65616E2872745B725D293B696628652E6E616D6573706163655552493D3D3D4B65297B696628612E6E616D6573706163655552493D3D3D716526262174';
wwv_flow_api.g_varchar2_table(66) := '745B6E5D2972657475726E21313B696628612E6E616D6573706163655552493D3D3D476526262165745B6E5D2972657475726E21313B76617220693D74287B7D2C5B227469746C65222C227374796C65222C22666F6E74222C2261222C22736372697074';
wwv_flow_api.g_varchar2_table(67) := '225D293B72657475726E2172745B725D262628695B725D7C7C2161745B725D297D72657475726E21317D2865293F286E742865292C2130293A226E6F73637269707422213D3D722626226E6F656D62656422213D3D727C7C2141282F3C5C2F6E6F287363';
wwv_flow_api.g_varchar2_table(68) := '726970747C656D626564292F692C652E696E6E657248544D4C293F284C652626333D3D3D652E6E6F646554797065262628613D652E74657874436F6E74656E742C613D5428612C70652C222022292C613D5428612C6D652C222022292C652E7465787443';
wwv_flow_api.g_varchar2_table(69) := '6F6E74656E74213D3D6126262862286F2E72656D6F7665642C7B656C656D656E743A652E636C6F6E654E6F646528297D292C652E74657874436F6E74656E743D6129292C75742822616674657253616E6974697A65456C656D656E7473222C652C6E756C';
wwv_flow_api.g_varchar2_table(70) := '6C292C2131293A286E742865292C2130297D2C64743D66756E6374696F6E28652C742C61297B6966284665262628226964223D3D3D747C7C226E616D65223D3D3D74292626286120696E206C7C7C6120696E205165292972657475726E21313B6966284F';
wwv_flow_api.g_varchar2_table(71) := '652626412867652C7429293B656C73652069662853652626412868652C7429293B656C73657B6966282154655B745D7C7C41655B745D2972657475726E21313B69662857655B745D293B656C736520696628412862652C5428612C79652C22222929293B';
wwv_flow_api.g_varchar2_table(72) := '656C7365206966282273726322213D3D74262622786C696E6B3A6872656622213D3D742626226872656622213D3D747C7C22736372697074223D3D3D657C7C30213D3D4528612C22646174613A22297C7C2156655B655D297B6966284965262621412876';
wwv_flow_api.g_varchar2_table(73) := '652C5428612C79652C22222929293B656C736520696628612972657475726E21317D656C73653B7D72657475726E21307D2C63743D66756E6374696F6E2865297B76617220743D766F696420302C613D766F696420302C723D766F696420302C6E3D766F';
wwv_flow_api.g_varchar2_table(74) := '696420303B757428226265666F726553616E6974697A6541747472696275746573222C652C6E756C6C293B76617220693D652E617474726962757465733B69662869297B76617220733D7B617474724E616D653A22222C6174747256616C75653A22222C';
wwv_flow_api.g_varchar2_table(75) := '6B656570417474723A21302C616C6C6F776564417474726962757465733A54657D3B666F72286E3D692E6C656E6774683B6E2D2D3B297B766172206C3D743D695B6E5D2C753D6C2E6E616D652C663D6C2E6E616D6573706163655552493B696628613D77';
wwv_flow_api.g_varchar2_table(76) := '28742E76616C7565292C723D442875292C732E617474724E616D653D722C732E6174747256616C75653D612C732E6B656570417474723D21302C732E666F7263654B656570417474723D766F696420302C7574282275706F6E53616E6974697A65417474';
wwv_flow_api.g_varchar2_table(77) := '726962757465222C652C73292C613D732E6174747256616C75652C21732E666F7263654B65657041747472262628697428752C65292C732E6B65657041747472292969662841282F5C2F3E2F692C612929697428752C65293B656C73657B4C6526262861';
wwv_flow_api.g_varchar2_table(78) := '3D5428612C70652C222022292C613D5428612C6D652C22202229293B76617220643D652E6E6F64654E616D652E746F4C6F7765724361736528293B696628647428642C722C6129297472797B663F652E7365744174747269627574654E5328662C752C61';
wwv_flow_api.g_varchar2_table(79) := '293A652E73657441747472696275746528752C61292C79286F2E72656D6F766564297D63617463682865297B7D7D7D75742822616674657253616E6974697A6541747472696275746573222C652C6E756C6C297D7D2C70743D66756E6374696F6E206528';
wwv_flow_api.g_varchar2_table(80) := '74297B76617220613D766F696420302C723D73742874293B666F7228757428226265666F726553616E6974697A65536861646F77444F4D222C742C6E756C6C293B613D722E6E6578744E6F646528293B297574282275706F6E53616E6974697A65536861';
wwv_flow_api.g_varchar2_table(81) := '646F774E6F6465222C612C6E756C6C292C66742861297C7C28612E636F6E74656E7420696E7374616E63656F66207526266528612E636F6E74656E74292C6374286129293B75742822616674657253616E6974697A65536861646F77444F4D222C742C6E';
wwv_flow_api.g_varchar2_table(82) := '756C6C297D3B72657475726E206F2E73616E6974697A653D66756E6374696F6E28742C61297B76617220723D766F696420302C6E3D766F696420302C693D766F696420302C6C3D766F696420302C663D766F696420303B6966282858653D217429262628';
wwv_flow_api.g_varchar2_table(83) := '743D225C783363212D2D5C78336522292C22737472696E6722213D747970656F6620742626216C74287429297B6966282266756E6374696F6E22213D747970656F6620742E746F537472696E67297468726F7720532822746F537472696E67206973206E';
wwv_flow_api.g_varchar2_table(84) := '6F7420612066756E6374696F6E22293B69662822737472696E6722213D747970656F6628743D742E746F537472696E67282929297468726F77205328226469727479206973206E6F74206120737472696E672C2061626F7274696E6722297D696628216F';
wwv_flow_api.g_varchar2_table(85) := '2E6973537570706F72746564297B696628226F626A656374223D3D3D2428652E746F53746174696348544D4C297C7C2266756E6374696F6E223D3D747970656F6620652E746F53746174696348544D4C297B69662822737472696E67223D3D747970656F';
wwv_flow_api.g_varchar2_table(86) := '6620742972657475726E20652E746F53746174696348544D4C2874293B6966286C742874292972657475726E20652E746F53746174696348544D4C28742E6F7574657248544D4C297D72657475726E20747D6966286B657C7C5A652861292C6F2E72656D';
wwv_flow_api.g_varchar2_table(87) := '6F7665643D5B5D2C22737472696E67223D3D747970656F6620742626287A653D2131292C7A65293B656C7365206966287420696E7374616E63656F66206329313D3D3D286E3D28723D6F7428225C783363212D2D2D2D5C7833652229292E6F776E657244';
wwv_flow_api.g_varchar2_table(88) := '6F63756D656E742E696D706F72744E6F646528742C213029292E6E6F646554797065262622424F4459223D3D3D6E2E6E6F64654E616D653F723D6E3A2248544D4C223D3D3D6E2E6E6F64654E616D653F723D6E3A722E617070656E644368696C64286E29';
wwv_flow_api.g_varchar2_table(89) := '3B656C73657B696628214D652626214C65262621526526262D313D3D3D742E696E6465784F6628223C22292972657475726E206E65262648653F6E652E63726561746548544D4C2874293A743B6966282128723D6F74287429292972657475726E204D65';
wwv_flow_api.g_varchar2_table(90) := '3F6E756C6C3A69657D7226265F6526266E7428722E66697273744368696C64293B666F722876617220643D7374287A653F743A72293B693D642E6E6578744E6F646528293B29333D3D3D692E6E6F6465547970652626693D3D3D6C7C7C66742869297C7C';
wwv_flow_api.g_varchar2_table(91) := '28692E636F6E74656E7420696E7374616E63656F6620752626707428692E636F6E74656E74292C63742869292C6C3D69293B6966286C3D6E756C6C2C7A652972657475726E20743B6966284D65297B6966284E6529666F7228663D75652E63616C6C2872';
wwv_flow_api.g_varchar2_table(92) := '2E6F776E6572446F63756D656E74293B722E66697273744368696C643B29662E617070656E644368696C6428722E66697273744368696C64293B656C736520663D723B72657475726E204365262628663D66652E63616C6C28732C662C213029292C667D';
wwv_flow_api.g_varchar2_table(93) := '76617220703D52653F722E6F7574657248544D4C3A722E696E6E657248544D4C3B72657475726E204C65262628703D5428702C70652C222022292C703D5428702C6D652C22202229292C6E65262648653F6E652E63726561746548544D4C2870293A707D';
wwv_flow_api.g_varchar2_table(94) := '2C6F2E736574436F6E6669673D66756E6374696F6E2865297B5A652865292C6B653D21307D2C6F2E636C656172436F6E6669673D66756E6374696F6E28297B59653D6E756C6C2C6B653D21317D2C6F2E697356616C69644174747269627574653D66756E';
wwv_flow_api.g_varchar2_table(95) := '6374696F6E28652C742C61297B59657C7C5A65287B7D293B76617220723D442865292C6E3D442874293B72657475726E20647428722C6E2C61297D2C6F2E616464486F6F6B3D66756E6374696F6E28652C74297B2266756E6374696F6E223D3D74797065';
wwv_flow_api.g_varchar2_table(96) := '6F66207426262863655B655D3D63655B655D7C7C5B5D2C622863655B655D2C7429297D2C6F2E72656D6F7665486F6F6B3D66756E6374696F6E2865297B63655B655D2626792863655B655D297D2C6F2E72656D6F7665486F6F6B733D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(97) := '2865297B63655B655D26262863655B655D3D5B5D297D2C6F2E72656D6F7665416C6C486F6F6B733D66756E6374696F6E28297B63653D7B7D7D2C6F7D766172206F3D4F626A6563742E6861734F776E50726F70657274792C733D4F626A6563742E736574';
wwv_flow_api.g_varchar2_table(98) := '50726F746F747970654F662C6C3D4F626A6563742E697346726F7A656E2C753D4F626A6563742E67657450726F746F747970654F662C663D4F626A6563742E6765744F776E50726F706572747944657363726970746F722C643D4F626A6563742E667265';
wwv_flow_api.g_varchar2_table(99) := '657A652C633D4F626A6563742E7365616C2C703D4F626A6563742E6372656174652C6D3D22756E646566696E656422213D747970656F66205265666C65637426265265666C6563742C673D6D2E6170706C792C683D6D2E636F6E7374727563743B677C7C';
wwv_flow_api.g_varchar2_table(100) := '28673D66756E6374696F6E28652C742C61297B72657475726E20652E6170706C7928742C61297D292C647C7C28643D66756E6374696F6E2865297B72657475726E20657D292C637C7C28633D66756E6374696F6E2865297B72657475726E20657D292C68';
wwv_flow_api.g_varchar2_table(101) := '7C7C28683D66756E6374696F6E28652C74297B72657475726E206E65772846756E6374696F6E2E70726F746F747970652E62696E642E6170706C7928652C5B6E756C6C5D2E636F6E6361742866756E6374696F6E2865297B69662841727261792E697341';
wwv_flow_api.g_varchar2_table(102) := '72726179286529297B666F722876617220743D302C613D417272617928652E6C656E677468293B743C652E6C656E6774683B742B2B29615B745D3D655B745D3B72657475726E20617D72657475726E2041727261792E66726F6D2865297D287429292929';
wwv_flow_api.g_varchar2_table(103) := '7D293B76617220763D652841727261792E70726F746F747970652E666F7245616368292C793D652841727261792E70726F746F747970652E706F70292C623D652841727261792E70726F746F747970652E70757368292C443D6528537472696E672E7072';
wwv_flow_api.g_varchar2_table(104) := '6F746F747970652E746F4C6F77657243617365292C783D6528537472696E672E70726F746F747970652E6D61746368292C543D6528537472696E672E70726F746F747970652E7265706C616365292C453D6528537472696E672E70726F746F747970652E';
wwv_flow_api.g_varchar2_table(105) := '696E6465784F66292C773D6528537472696E672E70726F746F747970652E7472696D292C413D65285265674578702E70726F746F747970652E74657374292C533D66756E6374696F6E2865297B72657475726E2066756E6374696F6E28297B666F722876';
wwv_flow_api.g_varchar2_table(106) := '617220743D617267756D656E74732E6C656E6774682C613D41727261792874292C723D303B723C743B722B2B29615B725D3D617267756D656E74735B725D3B72657475726E206828652C61297D7D28547970654572726F72292C4F3D64285B2261222C22';
wwv_flow_api.g_varchar2_table(107) := '61626272222C226163726F6E796D222C2261646472657373222C2261726561222C2261727469636C65222C226173696465222C22617564696F222C2262222C22626469222C2262646F222C22626967222C22626C696E6B222C22626C6F636B71756F7465';
wwv_flow_api.g_varchar2_table(108) := '222C22626F6479222C226272222C22627574746F6E222C2263616E766173222C2263617074696F6E222C2263656E746572222C2263697465222C22636F6465222C22636F6C222C22636F6C67726F7570222C22636F6E74656E74222C2264617461222C22';
wwv_flow_api.g_varchar2_table(109) := '646174616C697374222C226464222C226465636F7261746F72222C2264656C222C2264657461696C73222C2264666E222C226469616C6F67222C22646972222C22646976222C22646C222C226474222C22656C656D656E74222C22656D222C226669656C';
wwv_flow_api.g_varchar2_table(110) := '64736574222C2266696763617074696F6E222C22666967757265222C22666F6E74222C22666F6F746572222C22666F726D222C226831222C226832222C226833222C226834222C226835222C226836222C2268656164222C22686561646572222C226867';
wwv_flow_api.g_varchar2_table(111) := '726F7570222C226872222C2268746D6C222C2269222C22696D67222C22696E707574222C22696E73222C226B6264222C226C6162656C222C226C6567656E64222C226C69222C226D61696E222C226D6170222C226D61726B222C226D617271756565222C';
wwv_flow_api.g_varchar2_table(112) := '226D656E75222C226D656E756974656D222C226D65746572222C226E6176222C226E6F6272222C226F6C222C226F707467726F7570222C226F7074696F6E222C226F7574707574222C2270222C2270696374757265222C22707265222C2270726F677265';
wwv_flow_api.g_varchar2_table(113) := '7373222C2271222C227270222C227274222C2272756279222C2273222C2273616D70222C2273656374696F6E222C2273656C656374222C22736861646F77222C22736D616C6C222C22736F75726365222C22737061636572222C227370616E222C227374';
wwv_flow_api.g_varchar2_table(114) := '72696B65222C227374726F6E67222C227374796C65222C22737562222C2273756D6D617279222C22737570222C227461626C65222C2274626F6479222C227464222C2274656D706C617465222C227465787461726561222C2274666F6F74222C22746822';
wwv_flow_api.g_varchar2_table(115) := '2C227468656164222C2274696D65222C227472222C22747261636B222C227474222C2275222C22756C222C22766172222C22766964656F222C22776272225D292C493D64285B22737667222C2261222C22616C74676C797068222C22616C74676C797068';
wwv_flow_api.g_varchar2_table(116) := '646566222C22616C74676C7970686974656D222C22616E696D617465636F6C6F72222C22616E696D6174656D6F74696F6E222C22616E696D6174657472616E73666F726D222C22636972636C65222C22636C697070617468222C2264656673222C226465';
wwv_flow_api.g_varchar2_table(117) := '7363222C22656C6C69707365222C2266696C746572222C22666F6E74222C2267222C22676C797068222C22676C797068726566222C22686B65726E222C22696D616765222C226C696E65222C226C696E6561726772616469656E74222C226D61726B6572';
wwv_flow_api.g_varchar2_table(118) := '222C226D61736B222C226D65746164617461222C226D70617468222C2270617468222C227061747465726E222C22706F6C79676F6E222C22706F6C796C696E65222C2272616469616C6772616469656E74222C2272656374222C2273746F70222C227374';
wwv_flow_api.g_varchar2_table(119) := '796C65222C22737769746368222C2273796D626F6C222C2274657874222C227465787470617468222C227469746C65222C2274726566222C22747370616E222C2276696577222C22766B65726E225D292C4C3D64285B226665426C656E64222C22666543';
wwv_flow_api.g_varchar2_table(120) := '6F6C6F724D6174726978222C226665436F6D706F6E656E745472616E73666572222C226665436F6D706F73697465222C226665436F6E766F6C76654D6174726978222C226665446966667573654C69676874696E67222C226665446973706C6163656D65';
wwv_flow_api.g_varchar2_table(121) := '6E744D6170222C22666544697374616E744C69676874222C226665466C6F6F64222C22666546756E6341222C22666546756E6342222C22666546756E6347222C22666546756E6352222C226665476175737369616E426C7572222C2266654D6572676522';
wwv_flow_api.g_varchar2_table(122) := '2C2266654D657267654E6F6465222C2266654D6F7270686F6C6F6779222C2266654F6666736574222C226665506F696E744C69676874222C22666553706563756C61724C69676874696E67222C22666553706F744C69676874222C22666554696C65222C';
wwv_flow_api.g_varchar2_table(123) := '22666554757262756C656E6365225D292C523D64285B22616E696D617465222C22636F6C6F722D70726F66696C65222C22637572736F72222C2264697363617264222C22666564726F70736861646F77222C226665696D616765222C22666F6E742D6661';
wwv_flow_api.g_varchar2_table(124) := '6365222C22666F6E742D666163652D666F726D6174222C22666F6E742D666163652D6E616D65222C22666F6E742D666163652D737263222C22666F6E742D666163652D757269222C22666F726569676E6F626A656374222C226861746368222C22686174';
wwv_flow_api.g_varchar2_table(125) := '636870617468222C226D657368222C226D6573686772616469656E74222C226D6573687061746368222C226D657368726F77222C226D697373696E672D676C797068222C22736372697074222C22736574222C22736F6C6964636F6C6F72222C22756E6B';
wwv_flow_api.g_varchar2_table(126) := '6E6F776E222C22757365225D292C6B3D64285B226D617468222C226D656E636C6F7365222C226D6572726F72222C226D66656E636564222C226D66726163222C226D676C797068222C226D69222C226D6C6162656C65647472222C226D6D756C74697363';
wwv_flow_api.g_varchar2_table(127) := '7269707473222C226D6E222C226D6F222C226D6F766572222C226D706164646564222C226D7068616E746F6D222C226D726F6F74222C226D726F77222C226D73222C226D7370616365222C226D73717274222C226D7374796C65222C226D737562222C22';
wwv_flow_api.g_varchar2_table(128) := '6D737570222C226D737562737570222C226D7461626C65222C226D7464222C226D74657874222C226D7472222C226D756E646572222C226D756E6465726F766572225D292C5F3D64285B226D616374696F6E222C226D616C69676E67726F7570222C226D';
wwv_flow_api.g_varchar2_table(129) := '616C69676E6D61726B222C226D6C6F6E67646976222C226D7363617272696573222C226D736361727279222C226D7367726F7570222C226D737461636B222C226D736C696E65222C226D73726F77222C2273656D616E74696373222C22616E6E6F746174';
wwv_flow_api.g_varchar2_table(130) := '696F6E222C22616E6E6F746174696F6E2D786D6C222C226D70726573637269707473222C226E6F6E65225D292C4D3D64285B222374657874225D292C4E3D64285B22616363657074222C22616374696F6E222C22616C69676E222C22616C74222C226175';
wwv_flow_api.g_varchar2_table(131) := '746F6361706974616C697A65222C226175746F636F6D706C657465222C226175746F70696374757265696E70696374757265222C226175746F706C6179222C226261636B67726F756E64222C226267636F6C6F72222C22626F72646572222C2263617074';
wwv_flow_api.g_varchar2_table(132) := '757265222C2263656C6C70616464696E67222C2263656C6C73706163696E67222C22636865636B6564222C2263697465222C22636C617373222C22636C656172222C22636F6C6F72222C22636F6C73222C22636F6C7370616E222C22636F6E74726F6C73';
wwv_flow_api.g_varchar2_table(133) := '222C22636F6E74726F6C736C697374222C22636F6F726473222C2263726F73736F726967696E222C226461746574696D65222C226465636F64696E67222C2264656661756C74222C22646972222C2264697361626C6564222C2264697361626C65706963';
wwv_flow_api.g_varchar2_table(134) := '74757265696E70696374757265222C2264697361626C6572656D6F7465706C61796261636B222C22646F776E6C6F6164222C22647261676761626C65222C22656E6374797065222C22656E7465726B657968696E74222C2266616365222C22666F72222C';
wwv_flow_api.g_varchar2_table(135) := '2268656164657273222C22686569676874222C2268696464656E222C2268696768222C2268726566222C22687265666C616E67222C226964222C22696E7075746D6F6465222C22696E74656772697479222C2269736D6170222C226B696E64222C226C61';
wwv_flow_api.g_varchar2_table(136) := '62656C222C226C616E67222C226C697374222C226C6F6164696E67222C226C6F6F70222C226C6F77222C226D6178222C226D61786C656E677468222C226D65646961222C226D6574686F64222C226D696E222C226D696E6C656E677468222C226D756C74';
wwv_flow_api.g_varchar2_table(137) := '69706C65222C226D75746564222C226E616D65222C226E6F7368616465222C226E6F76616C6964617465222C226E6F77726170222C226F70656E222C226F7074696D756D222C227061747465726E222C22706C616365686F6C646572222C22706C617973';
wwv_flow_api.g_varchar2_table(138) := '696E6C696E65222C22706F73746572222C227072656C6F6164222C2270756264617465222C22726164696F67726F7570222C22726561646F6E6C79222C2272656C222C227265717569726564222C22726576222C227265766572736564222C22726F6C65';
wwv_flow_api.g_varchar2_table(139) := '222C22726F7773222C22726F777370616E222C227370656C6C636865636B222C2273636F7065222C2273656C6563746564222C227368617065222C2273697A65222C2273697A6573222C227370616E222C227372636C616E67222C227374617274222C22';
wwv_flow_api.g_varchar2_table(140) := '737263222C22737263736574222C2273746570222C227374796C65222C2273756D6D617279222C22746162696E646578222C227469746C65222C227472616E736C617465222C2274797065222C227573656D6170222C2276616C69676E222C2276616C75';
wwv_flow_api.g_varchar2_table(141) := '65222C227769647468222C22786D6C6E73222C22736C6F74225D292C433D64285B22616363656E742D686569676874222C22616363756D756C617465222C226164646974697665222C22616C69676E6D656E742D626173656C696E65222C22617363656E';
wwv_flow_api.g_varchar2_table(142) := '74222C226174747269627574656E616D65222C2261747472696275746574797065222C22617A696D757468222C22626173656672657175656E6379222C22626173656C696E652D7368696674222C22626567696E222C2262696173222C226279222C2263';
wwv_flow_api.g_varchar2_table(143) := '6C617373222C22636C6970222C22636C697070617468756E697473222C22636C69702D70617468222C22636C69702D72756C65222C22636F6C6F72222C22636F6C6F722D696E746572706F6C6174696F6E222C22636F6C6F722D696E746572706F6C6174';
wwv_flow_api.g_varchar2_table(144) := '696F6E2D66696C74657273222C22636F6C6F722D70726F66696C65222C22636F6C6F722D72656E646572696E67222C226378222C226379222C2264222C226478222C226479222C2264696666757365636F6E7374616E74222C22646972656374696F6E22';
wwv_flow_api.g_varchar2_table(145) := '2C22646973706C6179222C2264697669736F72222C22647572222C22656467656D6F6465222C22656C65766174696F6E222C22656E64222C2266696C6C222C2266696C6C2D6F706163697479222C2266696C6C2D72756C65222C2266696C746572222C22';
wwv_flow_api.g_varchar2_table(146) := '66696C746572756E697473222C22666C6F6F642D636F6C6F72222C22666C6F6F642D6F706163697479222C22666F6E742D66616D696C79222C22666F6E742D73697A65222C22666F6E742D73697A652D61646A757374222C22666F6E742D737472657463';
wwv_flow_api.g_varchar2_table(147) := '68222C22666F6E742D7374796C65222C22666F6E742D76617269616E74222C22666F6E742D776569676874222C226678222C226679222C226731222C226732222C22676C7970682D6E616D65222C22676C797068726566222C226772616469656E74756E';
wwv_flow_api.g_varchar2_table(148) := '697473222C226772616469656E747472616E73666F726D222C22686569676874222C2268726566222C226964222C22696D6167652D72656E646572696E67222C22696E222C22696E32222C226B222C226B31222C226B32222C226B33222C226B34222C22';
wwv_flow_api.g_varchar2_table(149) := '6B65726E696E67222C226B6579706F696E7473222C226B657973706C696E6573222C226B657974696D6573222C226C616E67222C226C656E67746861646A757374222C226C65747465722D73706163696E67222C226B65726E656C6D6174726978222C22';
wwv_flow_api.g_varchar2_table(150) := '6B65726E656C756E69746C656E677468222C226C69676874696E672D636F6C6F72222C226C6F63616C222C226D61726B65722D656E64222C226D61726B65722D6D6964222C226D61726B65722D7374617274222C226D61726B6572686569676874222C22';
wwv_flow_api.g_varchar2_table(151) := '6D61726B6572756E697473222C226D61726B65727769647468222C226D61736B636F6E74656E74756E697473222C226D61736B756E697473222C226D6178222C226D61736B222C226D65646961222C226D6574686F64222C226D6F6465222C226D696E22';
wwv_flow_api.g_varchar2_table(152) := '2C226E616D65222C226E756D6F637461766573222C226F6666736574222C226F70657261746F72222C226F706163697479222C226F72646572222C226F7269656E74222C226F7269656E746174696F6E222C226F726967696E222C226F766572666C6F77';
wwv_flow_api.g_varchar2_table(153) := '222C227061696E742D6F72646572222C2270617468222C22706174686C656E677468222C227061747465726E636F6E74656E74756E697473222C227061747465726E7472616E73666F726D222C227061747465726E756E697473222C22706F696E747322';
wwv_flow_api.g_varchar2_table(154) := '2C227072657365727665616C706861222C227072657365727665617370656374726174696F222C227072696D6974697665756E697473222C2272222C227278222C227279222C22726164697573222C2272656678222C2272656679222C22726570656174';
wwv_flow_api.g_varchar2_table(155) := '636F756E74222C22726570656174647572222C2272657374617274222C22726573756C74222C22726F74617465222C227363616C65222C2273656564222C2273686170652D72656E646572696E67222C2273706563756C6172636F6E7374616E74222C22';
wwv_flow_api.g_varchar2_table(156) := '73706563756C61726578706F6E656E74222C227370726561646D6574686F64222C2273746172746F6666736574222C22737464646576696174696F6E222C2273746974636874696C6573222C2273746F702D636F6C6F72222C2273746F702D6F70616369';
wwv_flow_api.g_varchar2_table(157) := '7479222C227374726F6B652D646173686172726179222C227374726F6B652D646173686F6666736574222C227374726F6B652D6C696E65636170222C227374726F6B652D6C696E656A6F696E222C227374726F6B652D6D697465726C696D6974222C2273';
wwv_flow_api.g_varchar2_table(158) := '74726F6B652D6F706163697479222C227374726F6B65222C227374726F6B652D7769647468222C227374796C65222C22737572666163657363616C65222C2273797374656D6C616E6775616765222C22746162696E646578222C2274617267657478222C';
wwv_flow_api.g_varchar2_table(159) := '2274617267657479222C227472616E73666F726D222C22746578742D616E63686F72222C22746578742D6465636F726174696F6E222C22746578742D72656E646572696E67222C22746578746C656E677468222C2274797065222C227531222C22753222';
wwv_flow_api.g_varchar2_table(160) := '2C22756E69636F6465222C2276616C756573222C2276696577626F78222C227669736962696C697479222C2276657273696F6E222C22766572742D6164762D79222C22766572742D6F726967696E2D78222C22766572742D6F726967696E2D79222C2277';
wwv_flow_api.g_varchar2_table(161) := '69647468222C22776F72642D73706163696E67222C2277726170222C2277726974696E672D6D6F6465222C22786368616E6E656C73656C6563746F72222C22796368616E6E656C73656C6563746F72222C2278222C227831222C227832222C22786D6C6E';
wwv_flow_api.g_varchar2_table(162) := '73222C2279222C227931222C227932222C227A222C227A6F6F6D616E6470616E225D292C483D64285B22616363656E74222C22616363656E74756E646572222C22616C69676E222C22626576656C6C6564222C22636C6F7365222C22636F6C756D6E7361';
wwv_flow_api.g_varchar2_table(163) := '6C69676E222C22636F6C756D6E6C696E6573222C22636F6C756D6E7370616E222C2264656E6F6D616C69676E222C226465707468222C22646972222C22646973706C6179222C22646973706C61797374796C65222C22656E636F64696E67222C2266656E';
wwv_flow_api.g_varchar2_table(164) := '6365222C226672616D65222C22686569676874222C2268726566222C226964222C226C617267656F70222C226C656E677468222C226C696E65746869636B6E657373222C226C7370616365222C226C71756F7465222C226D6174686261636B67726F756E';
wwv_flow_api.g_varchar2_table(165) := '64222C226D617468636F6C6F72222C226D61746873697A65222C226D61746876617269616E74222C226D617873697A65222C226D696E73697A65222C226D6F7661626C656C696D697473222C226E6F746174696F6E222C226E756D616C69676E222C226F';
wwv_flow_api.g_varchar2_table(166) := '70656E222C22726F77616C69676E222C22726F776C696E6573222C22726F7773706163696E67222C22726F777370616E222C22727370616365222C227271756F7465222C227363726970746C6576656C222C227363726970746D696E73697A65222C2273';
wwv_flow_api.g_varchar2_table(167) := '637269707473697A656D756C7469706C696572222C2273656C656374696F6E222C22736570617261746F72222C22736570617261746F7273222C227374726574636879222C227375627363726970747368696674222C2273757073637269707473686966';
wwv_flow_api.g_varchar2_table(168) := '74222C2273796D6D6574726963222C22766F6666736574222C227769647468222C22786D6C6E73225D292C463D64285B22786C696E6B3A68726566222C22786D6C3A6964222C22786C696E6B3A7469746C65222C22786D6C3A7370616365222C22786D6C';
wwv_flow_api.g_varchar2_table(169) := '6E733A786C696E6B225D292C553D63282F5C7B5C7B5B5C735C535D2A7C5B5C735C535D2A5C7D5C7D2F676D292C7A3D63282F3C255B5C735C535D2A7C5B5C735C535D2A253E2F676D292C6A3D63282F5E646174612D5B5C2D5C772E5C75303042372D5C75';
wwv_flow_api.g_varchar2_table(170) := '464646465D2F292C503D63282F5E617269612D5B5C2D5C775D2B242F292C563D63282F5E283F3A283F3A283F3A667C6874297470733F7C6D61696C746F7C74656C7C63616C6C746F7C6369647C786D7070293A7C5B5E612D7A5D7C5B612D7A2B2E5C2D5D';
wwv_flow_api.g_varchar2_table(171) := '2B283F3A5B5E612D7A2B2E5C2D3A5D7C2429292F69292C423D63282F5E283F3A5C772B7363726970747C64617461293A2F69292C573D63282F5B5C75303030302D5C75303032305C75303041305C75313638305C75313830455C75323030302D5C753230';
wwv_flow_api.g_varchar2_table(172) := '32395C75323035465C75333030305D2F67292C243D2266756E6374696F6E223D3D747970656F662053796D626F6C26262273796D626F6C223D3D747970656F662053796D626F6C2E6974657261746F723F66756E6374696F6E2865297B72657475726E20';
wwv_flow_api.g_varchar2_table(173) := '747970656F6620657D3A66756E6374696F6E2865297B72657475726E206526262266756E6374696F6E223D3D747970656F662053796D626F6C2626652E636F6E7374727563746F723D3D3D53796D626F6C262665213D3D53796D626F6C2E70726F746F74';
wwv_flow_api.g_varchar2_table(174) := '7970653F2273796D626F6C223A747970656F6620657D2C473D66756E6374696F6E28297B72657475726E22756E646566696E6564223D3D747970656F662077696E646F773F6E756C6C3A77696E646F777D2C713D66756E6374696F6E28652C74297B6966';
wwv_flow_api.g_varchar2_table(175) := '28226F626A65637422213D3D28766F696420303D3D3D653F22756E646566696E6564223A24286529297C7C2266756E6374696F6E22213D747970656F6620652E637265617465506F6C6963792972657475726E206E756C6C3B76617220613D6E756C6C2C';
wwv_flow_api.g_varchar2_table(176) := '723D22646174612D74742D706F6C6963792D737566666978223B742E63757272656E745363726970742626742E63757272656E745363726970742E686173417474726962757465287229262628613D742E63757272656E745363726970742E6765744174';
wwv_flow_api.g_varchar2_table(177) := '74726962757465287229293B766172206E3D22646F6D707572696679222B28613F2223222B613A2222293B7472797B72657475726E20652E637265617465506F6C696379286E2C7B63726561746548544D4C3A66756E6374696F6E2865297B7265747572';
wwv_flow_api.g_varchar2_table(178) := '6E20657D7D297D63617463682865297B72657475726E20636F6E736F6C652E7761726E282254727573746564547970657320706F6C69637920222B6E2B2220636F756C64206E6F7420626520637265617465642E22292C6E756C6C7D7D3B72657475726E';
wwv_flow_api.g_varchar2_table(179) := '206928297D293B76617220756E6C656173685254453D66756E6374696F6E28297B2275736520737472696374223B66756E6374696F6E206528652C742C612C722C6E2C69297B766172206F3D6E2E6974656D73325375626D6974496D6755702C753D6E65';
wwv_flow_api.g_varchar2_table(180) := '7720496D6167653B752E7372633D22646174613A222B742B223B6261736536342C222B653B76617220663D732E73706C6974537472696E673241727261792865293B752E6F6E6C6F61643D66756E6374696F6E28297B76617220653D7B7D3B652E726174';
wwv_flow_api.g_varchar2_table(181) := '696F3D746869732E77696474682F746869732E6865696768742C652E77696474683D746869732E77696474682C652E6865696768743D746869732E6865696768742C617065782E64656275672E696E666F287B6663743A732E6665617475726544657461';
wwv_flow_api.g_varchar2_table(182) := '696C732E6E616D652B22202D2075706C6F616446696C6573222C6D73673A2253746172742075706C6F6164206F6620222B612B222028222B742B2229222C6665617475726544657461696C733A732E6665617475726544657461696C737D292C61706578';
wwv_flow_api.g_varchar2_table(183) := '2E7365727665722E706C7567696E286E2E616A617849442C7B7830313A2255504C4F41445F494D414745222C7830323A612C7830333A742C6630313A662C706167654974656D733A6F7D2C7B737563636573733A66756E6374696F6E2874297B69662861';
wwv_flow_api.g_varchar2_table(184) := '7065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D2075706C6F616446696C6573222C6D73673A2255706C6F6164206F6620222B612B22207375636365737366756C2E222C66656174757265';
wwv_flow_api.g_varchar2_table(185) := '44657461696C733A732E6665617475726544657461696C737D292C6C2E617070656E642866756E6374696F6E28652C742C612C72297B7472797B69662874297B766172206E3D612E6974656D73325375626D6974496D67446F776E2C693D2428223C6669';
wwv_flow_api.g_varchar2_table(186) := '677572653E3C2F6669677572653E22293B692E6373732822746578742D616C69676E222C2263656E74657222292C692E616464436C6173732822696D61676522293B766172206F3D2428223C696D673E22293B6F2E617474722822616C74222C22616968';
wwv_flow_api.g_varchar2_table(187) := '2323222B74292C6F2E6174747228227469746C65222C74293B7472797B722E726174696F3C313F722E6865696768743C612E696D6757696474683F286F2E6174747228227769647468222C722E7769647468292C6F2E617474722822686569676874222C';
wwv_flow_api.g_varchar2_table(188) := '722E68656967687429293A286F2E617474722822686569676874222C4D6174682E666C6F6F7228612E696D67576964746829292C6F2E6174747228227769647468222C4D6174682E666C6F6F7228612E696D6757696474682A722E726174696F2929293A';
wwv_flow_api.g_varchar2_table(189) := '722E77696474683C612E696D6757696474683F286F2E6174747228227769647468222C722E7769647468292C6F2E617474722822686569676874222C722E68656967687429293A286F2E6174747228227769647468222C4D6174682E666C6F6F7228612E';
wwv_flow_api.g_varchar2_table(190) := '696D67576964746829292C6F2E617474722822686569676874222C4D6174682E666C6F6F7228612E696D6757696474682F722E726174696F2929297D63617463682865297B617065782E64656275672E6572726F72287B6663743A732E66656174757265';
wwv_flow_api.g_varchar2_table(191) := '44657461696C732E6E616D652B22202D20616464496D616765222C6D73673A224572726F72207768696C652074727920746F2063616C63756C61746520696D61676520776964746820616E64206865696768742E222C6572723A652C6665617475726544';
wwv_flow_api.g_varchar2_table(192) := '657461696C733A732E6665617475726544657461696C737D297D766172206C3D617065782E7365727665722E706C7567696E55726C28612E616A617849442C7B7830313A225052494E545F494D414745222C7830323A742C706167654974656D733A6E7D';
wwv_flow_api.g_varchar2_table(193) := '293B6F2E617474722822737263222C6C292C692E617070656E64286F293B76617220753D2428223C66696763617074696F6E3E3C2F66696763617074696F6E3E22293B72657475726E20752E746578742865292C692E617070656E642875292C697D6170';
wwv_flow_api.g_varchar2_table(194) := '65782E64656275672E6572726F72287B6663743A732E6665617475726544657461696C732E6E616D652B22202D20616464496D616765222C6D73673A224E6F207072696D617279206B65792073657420666F7220696D6167657320706C656173652C2073';
wwv_flow_api.g_varchar2_table(195) := '6F20696D61676520636F756C64206E6F7420626520616464656420746F205254452E20506C6561736520636865636B20504C2F53514C20426C6F636B206966206F757420706172616D65746572206973207365742E222C6665617475726544657461696C';
wwv_flow_api.g_varchar2_table(196) := '733A732E6665617475726544657461696C737D297D63617463682865297B617065782E64656275672E6572726F72287B6663743A732E6665617475726544657461696C732E6E616D652B22202D20616464496D616765222C6D73673A224572726F722077';
wwv_flow_api.g_varchar2_table(197) := '68696C652074727920746F2061646420696D6167657320696E746F207269636874657874656469746F7220776974682062696E61727920736F75726365732E222C6572723A652C6665617475726544657461696C733A732E666561747572654465746169';
wwv_flow_api.g_varchar2_table(198) := '6C737D297D7D28612C742E706B2C6E2C6529292C72297B696628353D3D3D6E2E76657273696F6E297B766172206F3D692E646174612E70726F636573736F722E746F56696577286C2E68746D6C2829292C753D692E646174612E746F4D6F64656C286F29';
wwv_flow_api.g_varchar2_table(199) := '3B692E6D6F64656C2E696E73657274436F6E74656E7428752C692E6D6F64656C2E646F63756D656E742E73656C656374696F6E297D656C736520692E696E7365727448746D6C286C2E68746D6C2829293B732E6C6F616465722E73746F70286E2E616666';
wwv_flow_api.g_varchar2_table(200) := '456C656D656E74444956292C6C3D2428223C6469763E3C2F6469763E22297D656C7365206C2E617070656E6428223C703E266E6273703B3C2F703E22293B617065782E6576656E742E74726967676572286E2E616666456C656D656E7449442C22696D61';
wwv_flow_api.g_varchar2_table(201) := '676575706C6F616469666E697368656422297D2C6572726F723A66756E6374696F6E28652C742C61297B617065782E64656275672E6572726F72287B6663743A732E6665617475726544657461696C732E6E616D652B22202D2075706C6F616446696C65';
wwv_flow_api.g_varchar2_table(202) := '73222C6D73673A22496D6167652055706C6F6164206572726F72222C6A715848523A652C746578745374617475733A742C6572726F725468726F776E3A612C6665617475726544657461696C733A732E6665617475726544657461696C737D292C6C3D24';
wwv_flow_api.g_varchar2_table(203) := '28223C6469763E3C2F6469763E22292C617065782E6576656E742E74726967676572286E2E616666456C656D656E7449442C22696D61676575706C6F61646572726F7222297D7D297D7D66756E6374696F6E207428742C612C72297B6966287426263021';
wwv_flow_api.g_varchar2_table(204) := '3D3D742E6C656E677468297B722E73686F774C6F616465722626732E6C6F616465722E737461727428722E616666456C656D656E74444956293B7472797B77696E646F772E46696C6552656164657226262266756E6374696F6E22213D747970656F6620';
wwv_flow_api.g_varchar2_table(205) := '46696C655265616465722E70726F746F747970652E72656164417342696E617279537472696E67262628636F6E736F6C652E6C6F6728225761726E696E673A205573696E672072656164417342696E617279537472696E6720706F6C7966696C6C22292C';
wwv_flow_api.g_varchar2_table(206) := '46696C655265616465722E70726F746F747970652E72656164417342696E617279537472696E673D66756E6374696F6E2865297B76617220743D6E65772046696C655265616465722C613D746869732C723D66756E6374696F6E2865297B666F72287661';
wwv_flow_api.g_varchar2_table(207) := '7220743D652E7461726765742E726573756C747C7C22222C723D22222C6E3D6E65772055696E743841727261792874292C693D6E2E627974654C656E6774682C6F3D2D313B2B2B6F3C693B29722B3D537472696E672E66726F6D43686172436F6465286E';
wwv_flow_api.g_varchar2_table(208) := '5B6F5D293B76617220733D7B7D3B666F7228766172206C20696E2065292274617267657422213D6C262628735B6C5D3D655B6C5D293B732E7461726765743D7B7D3B666F7228766172206C20696E20652E7461726765742922726573756C7422213D6C26';
wwv_flow_api.g_varchar2_table(209) := '2628732E7461726765745B6C5D3D652E7461726765745B6C5D293B732E7461726765742E726573756C743D722C612E6F6E6C6F6164656E642873297D3B766F69642030213D3D746869732E6F6E6C6F6164656E6426266E756C6C213D3D746869732E6F6E';
wwv_flow_api.g_varchar2_table(210) := '6C6F6164656E64262628742E6F6E6C6F6164656E643D72292C766F69642030213D3D746869732E6F6E6572726F7226266E756C6C213D3D746869732E6F6E6572726F72262628742E6F6E6572726F723D746869732E6F6E6572726F72292C766F69642030';
wwv_flow_api.g_varchar2_table(211) := '213D3D746869732E6F6E61626F727426266E756C6C213D3D746869732E6F6E61626F7274262628742E6F6E61626F72743D746869732E6F6E61626F7274292C766F69642030213D3D746869732E6F6E6C6F6164737461727426266E756C6C213D3D746869';
wwv_flow_api.g_varchar2_table(212) := '732E6F6E6C6F61647374617274262628742E6F6E6C6F616473746172743D746869732E6F6E6C6F61647374617274292C766F69642030213D3D746869732E6F6E70726F677265737326266E756C6C213D3D746869732E6F6E70726F677265737326262874';
wwv_flow_api.g_varchar2_table(213) := '2E6F6E70726F67726573733D746869732E6F6E70726F6772657373292C766F69642030213D3D746869732E6F6E6C6F616426266E756C6C213D3D746869732E6F6E6C6F6164262628742E6F6E6C6F61643D72292C742E7265616441734172726179427566';
wwv_flow_api.g_varchar2_table(214) := '6665722865297D293B666F7228766172206E3D312C693D21312C6F3D303B6F3C742E6C656E6774683B6F2B2B296966282D31213D3D745B6F5D2E747970652E696E6465784F662822696D6167652229297B766172206C3D745B6F5D3B617065782E646562';
wwv_flow_api.g_varchar2_table(215) := '75672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D2075706C6F616446696C6573222C66696C653A6C2C6665617475726544657461696C733A732E6665617475726544657461696C737D293B76617220753D6E';
wwv_flow_api.g_varchar2_table(216) := '65772046696C655265616465723B752E6F6E6C6F6164656E643D66756E6374696F6E286F297B72657475726E2066756E6374696F6E2873297B766172206C3D62746F6128732E7461726765742E726573756C74293B742E6C656E6774683D3D6E26262869';
wwv_flow_api.g_varchar2_table(217) := '3D2130292C65286C2C6F2E747970652C6F2E6E616D652C692C722C61292C6E2B2B7D7D286C292C752E72656164417342696E617279537472696E67286C297D656C7365206E3D3D742E6C656E677468262628732E6C6F616465722E73746F7028722E6166';
wwv_flow_api.g_varchar2_table(218) := '66456C656D656E74444956292C6E2B2B297D63617463682865297B617065782E64656275672E6572726F72287B6663743A732E6665617475726544657461696C732E6E616D652B22202D2075706C6F616446696C6573222C6D73673A224572726F722077';
wwv_flow_api.g_varchar2_table(219) := '68696C652074727920746F2061646420696D6167657320746F20746F2064622061667465722064726F70206F7220706173746520696D616765222C6572723A652C6665617475726544657461696C733A732E6665617475726544657461696C737D297D7D';
wwv_flow_api.g_varchar2_table(220) := '7D66756E6374696F6E206128612C72297B7472797B353D3D3D722E76657273696F6E3F28612E65646974696E672E766965772E646F63756D656E742E6F6E282264726F70222C66756E6374696F6E28652C6E297B6E2E70726576656E7444656661756C74';
wwv_flow_api.g_varchar2_table(221) := '282130292C652E73746F7028292C617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D206164644576656E7448616E646C6572222C6D73673A2246696C652064726F70706564202D207635';
wwv_flow_api.g_varchar2_table(222) := '78222C6576656E743A652C646174613A6E2C6665617475726544657461696C733A732E6665617475726544657461696C737D293B74286E2E646174615472616E736665722E66696C65732C612C72297D292C612E65646974696E672E766965772E646F63';
wwv_flow_api.g_varchar2_table(223) := '756D656E742E6F6E28227061737465222C66756E6374696F6E286E2C69297B696628617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D206164644576656E7448616E646C6572222C6D73';
wwv_flow_api.g_varchar2_table(224) := '673A2246696C6520706173746564202D20763578222C6576656E743A6E2C646174613A692C6665617475726544657461696C733A732E6665617475726544657461696C737D292C692E64617456616C75652626692E6461746156616C75652E696E646578';
wwv_flow_api.g_varchar2_table(225) := '4F6628277372633D22646174613A696D6167652F27293E302626692E6461746156616C75652E696E6465784F6628223B6261736536342C22293E30297B692E70726576656E7444656661756C74282130292C6E2E73746F7028293B766172206F3D692E64';
wwv_flow_api.g_varchar2_table(226) := '61746156616C75652C6C3D286F3D286F3D6F2E737562737472696E67286F2E696E6465784F6628277372633D22646174613A27292B277372633D22646174613A272E6C656E67746829292E73706C697428272227295B305D292E73706C697428223B2229';
wwv_flow_api.g_varchar2_table(227) := '5B305D2C753D6C2E737562737472696E67286C2E696E6465784F662822696D6167652F22292B22696D6167652F222E6C656E677468293B6F3D6F2E737562737472696E67286F2E696E6465784F6628226261736536342C22292B226261736536342C222E';
wwv_flow_api.g_varchar2_table(228) := '6C656E677468293B76617220663D22696D6167652D222B286E65772044617465292E746F49534F537472696E6728292B222E222B753B617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D';
wwv_flow_api.g_varchar2_table(229) := '206164644576656E7448616E646C6572222C22646174612E6461746156616C7565223A692E6461746156616C75652C6261736536345374723A6F2C66696C65547970653A6C2C66696C654E616D653A662C6665617475726544657461696C733A732E6665';
wwv_flow_api.g_varchar2_table(230) := '617475726544657461696C737D293B2428223C6469763E3C2F6469763E22293B65286F2C6C2C662C21302C722C61297D656C736520696628692E646174615472616E736665722E66696C65732626692E646174615472616E736665722E66696C65732E6C';
wwv_flow_api.g_varchar2_table(231) := '656E6774683E30297B692E70726576656E7444656661756C74282130292C6E2E73746F7028293B76617220643D5B5D3B642E7075736828692E646174615472616E736665722E66696C65735B305D292C7428642C612C72297D7D29293A28612E646F6375';
wwv_flow_api.g_varchar2_table(232) := '6D656E742E6F6E282264726F70222C66756E6374696F6E2865297B652E646174612E70726576656E7444656661756C74282130292C652E63616E63656C28292C652E73746F7028292C617065782E64656275672E696E666F287B6663743A732E66656174';
wwv_flow_api.g_varchar2_table(233) := '75726544657461696C732E6E616D652B22202D206164644576656E7448616E646C6572222C6D73673A2246696C652064726F70706564202D20763478222C6576656E743A652C6665617475726544657461696C733A732E6665617475726544657461696C';
wwv_flow_api.g_varchar2_table(234) := '737D293B7428652E646174612E242E646174615472616E736665722E66696C65732C612C72297D292C612E6F6E28227061737465222C66756E6374696F6E286E297B696628617065782E64656275672E696E666F287B6663743A732E6665617475726544';
wwv_flow_api.g_varchar2_table(235) := '657461696C732E6E616D652B22202D206164644576656E7448616E646C6572222C6D73673A2246696C6520706173746564202D20763478222C6576656E743A6E2C6665617475726544657461696C733A732E6665617475726544657461696C737D292C6E';
wwv_flow_api.g_varchar2_table(236) := '2E6461746126266E2E646174612E6461746156616C756526266E2E646174612E6461746156616C75652E696E6465784F6628277372633D22646174613A696D6167652F27293E3026266E2E646174612E6461746156616C75652E696E6465784F6628223B';
wwv_flow_api.g_varchar2_table(237) := '6261736536342C22293E30297B6E2E73746F7028292C6E2E63616E63656C28293B76617220693D6E2E646174612E6461746156616C75652C6F3D28693D28693D692E737562737472696E6728692E696E6465784F6628277372633D22646174613A27292B';
wwv_flow_api.g_varchar2_table(238) := '277372633D22646174613A272E6C656E67746829292E73706C697428272227295B305D292E73706C697428223B22295B305D2C6C3D6F2E737562737472696E67286F2E696E6465784F662822696D6167652F22292B22696D6167652F222E6C656E677468';
wwv_flow_api.g_varchar2_table(239) := '293B693D692E737562737472696E6728692E696E6465784F6628226261736536342C22292B226261736536342C222E6C656E677468293B76617220753D22696D6167652D222B286E65772044617465292E746F49534F537472696E6728292B222E222B6C';
wwv_flow_api.g_varchar2_table(240) := '3B617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D206164644576656E7448616E646C6572222C22652E646174612E6461746156616C7565223A6E2E646174612E6461746156616C7565';
wwv_flow_api.g_varchar2_table(241) := '2C6261736536345374723A692C66696C65547970653A6F2C66696C654E616D653A752C6665617475726544657461696C733A732E6665617475726544657461696C737D293B2428223C6469763E3C2F6469763E22293B6528692C6F2C752C21302C722C61';
wwv_flow_api.g_varchar2_table(242) := '297D656C7365206966286E2E646174612E646174615472616E736665722E5F2E66696C657326266E2E646174612E646174615472616E736665722E5F2E66696C65732E6C656E6774683E30297B6E2E73746F7028292C6E2E63616E63656C28293B766172';
wwv_flow_api.g_varchar2_table(243) := '20663D5B5D3B662E70757368286E2E646174612E646174615472616E736665722E5F2E66696C65735B305D292C7428662C612C72297D7D29297D63617463682865297B617065782E64656275672E6572726F72287B6663743A732E666561747572654465';
wwv_flow_api.g_varchar2_table(244) := '7461696C732E6E616D652B22202D206164644576656E7448616E646C6572222C6D73673A224572726F72207768696C652074727920746F2070617374652064726F70206F722070617374656420636F6E74656E7420696E20525445222C6572723A652C66';
wwv_flow_api.g_varchar2_table(245) := '65617475726544657461696C733A732E6665617475726544657461696C737D297D7D66756E6374696F6E207228652C74297B72657475726E20444F4D5075726966792E73616E6974697A6528652C742E73616E6974697A654F7074696F6E73297D66756E';
wwv_flow_api.g_varchar2_table(246) := '6374696F6E206E2865297B76617220743D2223222B652B225F434F4E5441494E4552202E636B2D656469746F725F5F6564697461626C65223B617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B';
wwv_flow_api.g_varchar2_table(247) := '22202D20676574456469746F72222C73656C51756572793A742C6665617475726544657461696C733A732E6665617475726544657461696C737D293B76617220613D646F63756D656E742E717565727953656C6563746F722874293B72657475726E2061';
wwv_flow_api.g_varchar2_table(248) := '2626612E636B656469746F72496E7374616E63653F612E636B656469746F72496E7374616E63653A434B454449544F522626434B454449544F522E696E7374616E6365733F434B454449544F522E696E7374616E6365735B655D3A766F69642061706578';
wwv_flow_api.g_varchar2_table(249) := '2E64656275672E6572726F72287B6663743A732E6665617475726544657461696C732E6E616D652B22202D20676574456469746F72222C6D73673A224E6F20434B4520456469746F7220666F756E6421222C73656C51756572793A742C66656174757265';
wwv_flow_api.g_varchar2_table(250) := '44657461696C733A732E6665617475726544657461696C737D297D66756E6374696F6E206928652C742C69297B7472797B766172206F3B742626742E726F772626742E726F775B305D2626742E726F775B305D2E434C4F425F56414C55452626286F3D74';
wwv_flow_api.g_varchar2_table(251) := '2E726F775B305D2E434C4F425F56414C5545292C6F3D692E73616E6974697A653F72286F2C69293A6F2C692E65736361706548544D4C2626286F3D732E65736361706548544D4C286F29293B766172206C3D6E28692E616666456C656D656E74293B6966';
wwv_flow_api.g_varchar2_table(252) := '286C297B617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D207072696E74436C6F62222C656469746F723A6C2C6665617475726544657461696C733A732E666561747572654465746169';
wwv_flow_api.g_varchar2_table(253) := '6C737D293B66756E6374696F6E207528297B2166756E6374696F6E28652C742C72297B766172206E3D2428223C6469763E3C2F6469763E22292C693D742E6974656D73325375626D6974496D67446F776E3B7472797B6E2E68746D6C2872293B76617220';
wwv_flow_api.g_varchar2_table(254) := '6F3D6E2E66696E642827696D675B616C742A3D2261696823225D27293B242E65616368286F2C66756E6374696F6E28652C61297B76617220723D612E7469746C653B696628727C7C28723D612E616C742E73706C69742822616968232322295B315D292C';
wwv_flow_api.g_varchar2_table(255) := '72297B766172206E3D617065782E7365727665722E706C7567696E55726C28742E616A617849442C7B7830313A225052494E545F494D414745222C7830323A722C706167654974656D733A697D293B612E7372633D6E7D656C736520617065782E646562';
wwv_flow_api.g_varchar2_table(256) := '75672E6572726F72287B6663743A732E6665617475726544657461696C732E6E616D652B22202D207570646174655570496D616765537263222C6D73673A275072696D617279206B6579206F6620696D675B616C742A3D2261696823225D206973206D69';
wwv_flow_api.g_varchar2_table(257) := '7373696E67272C6665617475726544657461696C733A732E6665617475726544657461696C737D297D292C6E2E66696E642822696D6722292E63737328226D61782D7769647468222C223130302522292E63737328226F626A6563742D666974222C2263';
wwv_flow_api.g_varchar2_table(258) := '6F6E7461696E22292E63737328226F626A6563742D706F736974696F6E222C2235302520302522292C6E5B305D2E696E6E657248544D4C262628617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D65';
wwv_flow_api.g_varchar2_table(259) := '2B22202D207570646174655570496D616765537263222C66696E616C5F656469746F725F68746D6C5F6F6E5F6C6F61643A6E5B305D2E696E6E657248544D4C2C6665617475726544657461696C733A732E6665617475726544657461696C737D292C652E';
wwv_flow_api.g_varchar2_table(260) := '73657444617461286E5B305D2E696E6E657248544D4C292C617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D207570646174655570496D616765537263222C66696E616C5F656469746F';
wwv_flow_api.g_varchar2_table(261) := '725F6F6E5F6C6F61643A652C6665617475726544657461696C733A732E6665617475726544657461696C737D29292C6128652C74297D63617463682865297B617065782E64656275672E6572726F72287B6663743A732E6665617475726544657461696C';
wwv_flow_api.g_varchar2_table(262) := '732E6E616D652B22202D207570646174655570496D616765537263222C6D73673A224572726F72207768696C652074727920746F206C6F616420696D61676573207768656E206C6F6164696E672072696368207465787420656469746F722E222C657272';
wwv_flow_api.g_varchar2_table(263) := '3A652C6665617475726544657461696C733A732E6665617475726544657461696C737D297D7D286C2C692C6F292C732E6C6F616465722E73746F7028692E616666456C656D656E74444956292C617065782E6576656E742E7472696767657228692E6166';
wwv_flow_api.g_varchar2_table(264) := '66456C656D656E7449442C22636C6F626C6F616466696E697368656422292C617065782E64612E726573756D6528652E726573756D6543616C6C6261636B2C2131292C6C2E6F6E2822636F6E74656E74446F6D222C66756E6374696F6E28297B61286C2C';
wwv_flow_api.g_varchar2_table(265) := '69297D297D353D3D3D692E76657273696F6E3F7528293A21303D3D3D6C2E696E7374616E636552656164793F287528292C617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D207072696E';
wwv_flow_api.g_varchar2_table(266) := '74436C6F62222C6D73673A22737461727420696E7374616E636520776173207265616479222C6665617475726544657461696C733A732E6665617475726544657461696C737D29293A6C2E6F6E2822696E7374616E63655265616479222C66756E637469';
wwv_flow_api.g_varchar2_table(267) := '6F6E28297B7528292C617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D207072696E74436C6F62222C6D73673A227374617274206F6E20696E7374616E6365207265616479222C666561';
wwv_flow_api.g_varchar2_table(268) := '7475726544657461696C733A732E6665617475726544657461696C737D297D297D7D63617463682874297B617065782E64656275672E6572726F72287B6663743A732E6665617475726544657461696C732E6E616D652B22202D207072696E74436C6F62';
wwv_flow_api.g_varchar2_table(269) := '222C6D73673A224572726F72207768696C652072656E64657220434C4F42222C6572723A742C6665617475726544657461696C733A732E6665617475726544657461696C737D292C617065782E6576656E742E7472696767657228692E616666456C656D';
wwv_flow_api.g_varchar2_table(270) := '656E7449442C22636C6F626C6F61646572726F7222292C617065782E64612E726573756D6528652E726573756D6543616C6C6261636B2C2130297D7D66756E6374696F6E206F28652C74297B76617220613D6E28742E616666456C656D656E74293B6966';
wwv_flow_api.g_varchar2_table(271) := '2861297B76617220693D66756E6374696F6E28652C74297B7472797B76617220613D2428223C6469763E3C2F6469763E22293B72657475726E20615B305D2E696E6E657248544D4C3D652E6765744461746128292C612E66696E642827696D675B616C74';
wwv_flow_api.g_varchar2_table(272) := '2A3D2261696823225D27292E617474722822737263222C2261696822292C615B305D2E696E6E657248544D4C7D63617463682865297B617065782E64656275672E6572726F72287B6663743A732E6665617475726544657461696C732E6E616D652B2220';
wwv_flow_api.g_varchar2_table(273) := '2D20636C65616E5570496D616765537263222C6D73673A224572726F72207768696C652074727920746F20636C65616E757020696D61676520736F7572636520696E2064796E616D696320616464656420696D6167657320696E20726963687465787465';
wwv_flow_api.g_varchar2_table(274) := '6469746F722E222C6572723A652C6665617475726544657461696C733A732E6665617475726544657461696C737D297D7D2861293B742E756E45736361706548544D4C262628693D732E756E45736361706548544D4C286929292C742E73616E6974697A';
wwv_flow_api.g_varchar2_table(275) := '65262628693D7228692C7429293B766172206F3D732E73706C6974537472696E673241727261792869292C6C3D742E6974656D73325375626D69743B617065782E7365727665722E706C7567696E28742E616A617849442C7B7830313A2255504C4F4144';
wwv_flow_api.g_varchar2_table(276) := '5F434C4F42222C6630313A6F2C706167654974656D733A6C7D2C7B64617461547970653A2274657874222C737563636573733A66756E6374696F6E2861297B732E6C6F616465722E73746F7028742E616666456C656D656E74444956292C617065782E64';
wwv_flow_api.g_varchar2_table(277) := '656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D2075706C6F6164436C6F62222C6D73673A22436C6F622055706C6F6164207375636365737366756C222C6665617475726544657461696C733A732E66';
wwv_flow_api.g_varchar2_table(278) := '65617475726544657461696C737D292C617065782E6576656E742E7472696767657228742E616666456C656D656E7449442C22636C6F627361766566696E697368656422292C617065782E64612E726573756D6528652E726573756D6543616C6C626163';
wwv_flow_api.g_varchar2_table(279) := '6B2C2131297D2C6572726F723A66756E6374696F6E28612C722C6E297B732E6C6F616465722E73746F7028742E616666456C656D656E74444956292C617065782E64656275672E6572726F72287B6663743A732E6665617475726544657461696C732E6E';
wwv_flow_api.g_varchar2_table(280) := '616D652B22202D2075706C6F6164436C6F62222C6D73673A22436C6F622055706C6F6164206572726F72222C6A715848523A612C746578745374617475733A722C6572726F725468726F776E3A6E2C6665617475726544657461696C733A732E66656174';
wwv_flow_api.g_varchar2_table(281) := '75726544657461696C737D292C617065782E6576656E742E7472696767657228742E616666456C656D656E7449442C22636C6F62736176656572726F7222292C617065782E64612E726573756D6528652E726573756D6543616C6C6261636B2C2130297D';
wwv_flow_api.g_varchar2_table(282) := '7D297D7D76617220733D7B6665617475726544657461696C733A7B6E616D653A22415045582D556E6C656173682D5269636854657874456469746F72222C73637269707456657273696F6E3A22322E312E322E32222C7574696C56657273696F6E3A2231';
wwv_flow_api.g_varchar2_table(283) := '2E36222C75726C3A2268747470733A2F2F6769746875622E636F6D2F526F6E6E795765697373222C6C6963656E73653A224D4954227D2C65736361706548544D4C3A66756E6374696F6E2865297B6966286E756C6C3D3D3D652972657475726E206E756C';
wwv_flow_api.g_varchar2_table(284) := '6C3B696628766F69642030213D3D65297B696628226F626A656374223D3D747970656F662065297472797B653D4A534F4E2E737472696E676966792865297D63617463682865297B7D72657475726E20617065782E7574696C2E65736361706548544D4C';
wwv_flow_api.g_varchar2_table(285) := '28537472696E67286529297D7D2C756E45736361706548544D4C3A66756E6374696F6E2865297B6966286E756C6C3D3D3D652972657475726E206E756C6C3B696628766F69642030213D3D65297B696628226F626A656374223D3D747970656F66206529';
wwv_flow_api.g_varchar2_table(286) := '7472797B653D4A534F4E2E737472696E676966792865297D63617463682865297B7D72657475726E28653D537472696E67286529292E7265706C616365282F26616D703B2F672C222622292E7265706C616365282F266C743B2F672C223E22292E726570';
wwv_flow_api.g_varchar2_table(287) := '6C616365282F2667743B2F672C223E22292E7265706C616365282F2671756F743B2F672C272227292E7265706C616365282F237832373B2F672C222722292E7265706C616365282F26237832463B2F672C225C5C22297D7D2C6C6F616465723A7B737461';
wwv_flow_api.g_varchar2_table(288) := '72743A66756E6374696F6E28652C74297B742626242865292E63737328226D696E2D686569676874222C22313030707822292C617065782E7574696C2E73686F775370696E6E65722824286529297D2C73746F703A66756E6374696F6E28652C74297B74';
wwv_flow_api.g_varchar2_table(289) := '2626242865292E63737328226D696E2D686569676874222C2222292C2428652B22203E202E752D50726F63657373696E6722292E72656D6F766528292C2428652B22203E202E63742D6C6F6164657222292E72656D6F766528297D7D2C6A736F6E536176';
wwv_flow_api.g_varchar2_table(290) := '65457874656E643A66756E6374696F6E28652C74297B76617220613D7B7D2C723D7B7D3B69662822737472696E67223D3D747970656F662074297472797B723D4A534F4E2E70617273652874297D63617463682865297B617065782E64656275672E6572';
wwv_flow_api.g_varchar2_table(291) := '726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768696C652074727920746F20706172736520746172676574436F6E6669672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E20537461';
wwv_flow_api.g_varchar2_table(292) := '6E6461726420436F6E6669672077696C6C20626520757365642E222C6572723A652C746172676574436F6E6669673A747D297D656C736520723D242E657874656E642821302C7B7D2C74293B7472797B613D242E657874656E642821302C7B7D2C652C72';
wwv_flow_api.g_varchar2_table(293) := '297D63617463682874297B613D242E657874656E642821302C7B7D2C65292C617065782E64656275672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768696C652074727920746F206D657267652032204A53';
wwv_flow_api.g_varchar2_table(294) := '4F4E7320696E746F207374616E64617264204A534F4E20696620616E7920617474726962757465206973206D697373696E672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077';
wwv_flow_api.g_varchar2_table(295) := '696C6C20626520757365642E222C6572723A742C66696E616C436F6E6669673A617D297D72657475726E20617D2C73706C6974537472696E673241727261793A66756E6374696F6E2865297B696628766F69642030213D3D6526266E756C6C213D3D6526';
wwv_flow_api.g_varchar2_table(296) := '262222213D652626652E6C656E6774683E30297B696628617065782626617065782E7365727665722626617065782E7365727665722E6368756E6B2972657475726E20617065782E7365727665722E6368756E6B2865293B76617220742C613D5B5D3B69';
wwv_flow_api.g_varchar2_table(297) := '6628652E6C656E6774683E386533297B666F7228613D5B5D2C743D303B743C652E6C656E6774683B29612E7075736828652E73756273747228742C38653329292C742B3D3865333B72657475726E20617D72657475726E20612E707573682865292C617D';
wwv_flow_api.g_varchar2_table(298) := '72657475726E5B5D7D7D2C6C3D2428223C6469763E3C2F6469763E22293B72657475726E7B696E697469616C697A653A66756E6374696F6E28652C74297B617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E';
wwv_flow_api.g_varchar2_table(299) := '6E616D652B22202D20696E697469616C697A65222C617267756D656E74733A7B70546869733A652C704F7074733A747D2C6665617475726544657461696C733A732E6665617475726544657461696C737D293B76617220613D743B696628612E696D6757';
wwv_flow_api.g_varchar2_table(300) := '696474683D612E696D6757696474687C7C3730302C612E73616E6974697A654F7074696F6E733D732E6A736F6E53617665457874656E64287B414C4C4F5745445F415454523A5B226163636573736B6579222C22616C69676E222C22616C74222C22616C';
wwv_flow_api.g_varchar2_table(301) := '77617973222C226175746F636F6D706C657465222C226175746F706C6179222C22626F72646572222C2263656C6C70616464696E67222C2263656C6C73706163696E67222C2263686172736574222C22636C617373222C22646972222C22686569676874';
wwv_flow_api.g_varchar2_table(302) := '222C2268726566222C226964222C226C616E67222C226E616D65222C2272656C222C227265717569726564222C22737263222C227374796C65222C2273756D6D617279222C22746162696E646578222C22746172676574222C227469746C65222C227479';
wwv_flow_api.g_varchar2_table(303) := '7065222C2276616C7565222C227769647468225D2C414C4C4F5745445F544147533A5B2261222C2261646472657373222C2262222C22626C6F636B71756F7465222C226272222C2263617074696F6E222C22636F6465222C226464222C22646976222C22';
wwv_flow_api.g_varchar2_table(304) := '646C222C226474222C22656D222C2266696763617074696F6E222C22666967757265222C226831222C226832222C226833222C226834222C226835222C226836222C226872222C2269222C22696D67222C226C6162656C222C226C69222C226E6C222C22';
wwv_flow_api.g_varchar2_table(305) := '6F6C222C2270222C22707265222C2273222C227370616E222C22737472696B65222C227374726F6E67222C22737562222C22737570222C227461626C65222C2274626F6479222C227464222C227468222C227468656164222C227472222C2275222C2275';
wwv_flow_api.g_varchar2_table(306) := '6C225D7D2C742E73616E6974697A654F7074696F6E73292C224E223D3D612E73616E6974697A653F612E73616E6974697A653D21313A612E73616E6974697A653D21302C224E223D3D612E65736361706548544D4C3F612E65736361706548544D4C3D21';
wwv_flow_api.g_varchar2_table(307) := '313A612E65736361706548544D4C3D21302C224E223D3D612E756E45736361706548544D4C3F612E756E45736361706548544D4C3D21313A612E756E45736361706548544D4C3D21302C2259223D3D612E73686F774C6F616465723F612E73686F774C6F';
wwv_flow_api.g_varchar2_table(308) := '616465723D21303A612E73686F774C6F616465723D21312C2259223D3D612E757365496D61676555706C6F616465723F612E757365496D61676555706C6F616465723D21303A612E757365496D61676555706C6F616465723D21312C22756E646566696E';
wwv_flow_api.g_varchar2_table(309) := '656422213D747970656F6620434B454449544F522626434B454449544F522E76657273696F6E3F612E76657273696F6E3D434B454449544F522E76657273696F6E3A612E76657273696F6E3D352C652E6166666563746564456C656D656E74735B305D29';
wwv_flow_api.g_varchar2_table(310) := '696628612E616666456C656D656E743D2428652E6166666563746564456C656D656E74735B305D292E617474722822696422292C612E616666456C656D656E744449563D2223222B2428652E6166666563746564456C656D656E74735B305D292E617474';
wwv_flow_api.g_varchar2_table(311) := '722822696422292B225F434F4E5441494E4552222C612E616666456C656D656E7449443D2223222B2428652E6166666563746564456C656D656E74735B305D292E617474722822696422292C612E73686F774C6F616465722626732E6C6F616465722E73';
wwv_flow_api.g_varchar2_table(312) := '7461727428612E616666456C656D656E74444956292C2252454E444552223D3D612E66756E6374696F6E54797065297B76617220723D612E6974656D73325375626D69743B617065782E7365727665722E706C7567696E28612E616A617849442C7B7830';
wwv_flow_api.g_varchar2_table(313) := '313A225052494E545F434C4F42222C706167654974656D733A727D2C7B737563636573733A66756E6374696F6E2874297B617065782E64656275672E696E666F287B6663743A732E6665617475726544657461696C732E6E616D652B22202D20696E6974';
wwv_flow_api.g_varchar2_table(314) := '69616C697A65222C6D73673A22414A41582064617461207265636569766564222C70446174613A742C6665617475726544657461696C733A732E6665617475726544657461696C737D292C6928652C742C61297D2C6572726F723A66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(315) := '65297B617065782E64656275672E6572726F72287B6663743A732E6665617475726544657461696C732E6E616D652B22202D20696E697469616C697A65222C6D73673A22414A41582064617461206572726F72222C726573706F6E73653A652C66656174';
wwv_flow_api.g_varchar2_table(316) := '75726544657461696C733A732E6665617475726544657461696C737D297D2C64617461547970653A226A736F6E227D297D656C7365206F28652C61297D7D7D28293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(83943536669108082447)
,p_plugin_id=>wwv_flow_api.id(83788029902374428594)
,p_file_name=>'unleashrte.pkgd.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
