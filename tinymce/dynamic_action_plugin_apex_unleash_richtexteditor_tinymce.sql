prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.5'
,p_default_workspace_id=>21717127411908241868
,p_default_application_id=>212464
,p_default_id_offset=>82247351195386137355
,p_default_owner=>'RD_DEV'
);
end;
/
 
prompt APPLICATION 212464 - Unleash RTE (TinyMCE)

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/apex_unleash_richtexteditor_tinymce
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(165236396986724815191)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'APEX.UNLEASH.RICHTEXTEDITOR.TINYMCE'
,p_display_name=>'APEX Unleash RichTextEditor (TinyMCE)'
,p_category=>'EXECUTE'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* helper function to store an image */',
'procedure store_image (',
'    p_in_plsql_block clob,',
'    p_in_file_name   varchar2,',
'    p_in_mime_type   varchar2,',
'    p_in_binary_file blob,',
'    p_out_pk         out varchar2',
') as',
'    l_exec    binary_integer;',
'    l_tmp_str varchar2(32767) := null;',
'    l_curs    binary_integer;',
'    l_binds   varchar(32767);',
'    l_binds_t sys.dbms_sql.varchar2_table := wwv_flow_utilities.get_binds(p_in_plsql_block);',
'begin',
'    l_curs := dbms_sql.open_cursor;',
'    dbms_sql.parse(l_curs, p_in_plsql_block, dbms_sql.native);',
'    for i in 1..l_binds_t.count loop',
'        -- TODO find out how to prevent ltrim',
'        l_binds := ltrim(l_binds_t(i), '':'');',
'        case l_binds',
'            when ''FILE_NAME'' then',
'                dbms_sql.bind_variable(l_curs, l_binds, p_in_file_name);',
'            when ''MIME_TYPE'' then',
'                dbms_sql.bind_variable(l_curs, l_binds, p_in_mime_type);',
'            when ''BINARY_FILE'' then',
'                dbms_sql.bind_variable(l_curs, l_binds, p_in_binary_file);',
'            when ''P_OUT_PK'' then',
'                dbms_sql.bind_variable(l_curs, l_binds, p_out_pk, 4000);',
'            else',
'                -- get values for APEX items',
'                dbms_sql.bind_variable(l_curs, l_binds, v(l_binds));',
'        end case;',
'    end loop;',
'',
'    l_exec := dbms_sql.execute(l_curs);',
'    dbms_sql.variable_value(l_curs, ''P_OUT_PK'', p_out_pk);',
'exception',
'    when others then',
'        if dbms_sql.is_open(l_curs) then',
'            dbms_sql.close_cursor(l_curs);',
'        end if;',
'        apex_debug.error(''APEX Unleash RTE (TinyMCE) - Error while try to store clob'');',
'        apex_debug.error(sqlerrm);',
'        apex_debug.error(dbms_utility.format_error_backtrace);',
'        raise;',
'end;',
'',
'-- helper function to store a note',
'procedure store_clob (',
'    p_in_plsql_block clob,',
'    p_in_clob        clob',
') as',
'',
'    l_exec    binary_integer;',
'    l_tmp_str varchar2(32767) := null;',
'    l_curs    binary_integer;',
'    l_binds   varchar(32767);',
'    l_binds_t sys.dbms_sql.varchar2_table := wwv_flow_utilities.get_binds(p_in_plsql_block);',
'begin',
'    l_curs := dbms_sql.open_cursor;',
'    dbms_sql.parse(l_curs, p_in_plsql_block, dbms_sql.native);',
'    for i in 1..l_binds_t.count loop',
'        -- TODO find out how to prevent ltrim',
'        l_binds := ltrim(l_binds_t(i), '':'');',
'        case l_binds',
'            when ''CLOB'' then',
'                dbms_sql.bind_variable(l_curs, l_binds, p_in_clob);',
'            else',
'                -- get values for APEX items',
'                dbms_sql.bind_variable(l_curs, l_binds, v(l_binds));',
'        end case;',
'    end loop;',
'    l_exec := dbms_sql.execute(l_curs);',
'exception',
'    when others then',
'        if dbms_sql.is_open(l_curs) then',
'            dbms_sql.close_cursor(l_curs);',
'        end if;',
'        apex_debug.error(''APEX Unleash RTE (TinyMCE) - Error while try to store clob'');',
'        apex_debug.error(sqlerrm);',
'        apex_debug.error(dbms_utility.format_error_backtrace);',
'        raise;',
'end;',
'',
'-- helper function to load a image via plsql',
'procedure get_image (',
'    p_in_plsql_print_img varchar2,',
'    p_in_pk              varchar2,',
'    p_out_blob           out nocopy blob,',
'    p_out_file_name      out varchar2,',
'    p_out_mime_type      out varchar2,',
'    p_out_cache_time     out number',
') as',
'',
'    l_binds_t sys.dbms_sql.varchar2_table := wwv_flow_utilities.get_binds(p_in_plsql_print_img);',
'    l_curs    binary_integer;',
'    l_exec    binary_integer;',
'    l_binds   varchar(32767);',
'    l_cache   boolean;',
'begin',
'    l_curs := dbms_sql.open_cursor;',
'    dbms_sql.parse(l_curs, p_in_plsql_print_img, dbms_sql.native);',
'    for i in 1..l_binds_t.count loop',
'        -- TODO find out how to prevent ltrim',
'        l_binds := ltrim(l_binds_t(i), '':'');',
'        case l_binds',
'            when ''PK'' then',
'                dbms_sql.bind_variable(l_curs, l_binds, p_in_pk);',
'            when ''FILE_NAME'' then',
'                dbms_sql.bind_variable(l_curs, l_binds, p_out_file_name, 4000);',
'            when ''MIME_TYPE'' then',
'                dbms_sql.bind_variable(l_curs, l_binds, p_out_mime_type, 4000);',
'            when ''BINARY_FILE'' then',
'                dbms_sql.bind_variable(l_curs, l_binds, p_out_blob);',
'            when ''CACHE_TIME'' then',
'                l_cache := true;',
'                dbms_sql.bind_variable(l_curs, l_binds, p_out_cache_time);',
'            else',
'                -- get values for APEX items',
'                dbms_sql.bind_variable(l_curs, l_binds, v(l_binds));',
'        end case;',
'    end loop;',
'    l_exec := dbms_sql.execute(l_curs);',
'    dbms_sql.variable_value(l_curs,''FILE_NAME'', p_out_file_name);',
'    dbms_sql.variable_value(l_curs, ''MIME_TYPE'', p_out_mime_type);',
'    dbms_sql.variable_value(l_curs, ''BINARY_FILE'', p_out_blob);',
'    if l_cache then',
'        dbms_sql.variable_value(l_curs, ''CACHE_TIME'', p_out_cache_time);',
'    end if;',
'exception',
'    when others then',
'        if dbms_sql.is_open(l_curs) then',
'            dbms_sql.close_cursor(l_curs);',
'        end if;',
'        apex_debug.error(''APEX Unleash RTE (TinyMCE) - Error while try to get image file'');',
'        apex_debug.error(sqlerrm);',
'        apex_debug.error(dbms_utility.format_error_backtrace);',
'        raise;',
'end;',
'',
'-- helper function to download a file',
'procedure download_file (',
'    p_in_blob           blob,',
'    p_in_mime_type      varchar2,',
'    p_in_file_name      varchar2,',
'    p_in_ajax_reference varchar2 := null,',
'    p_in_cache_time_s   number := null',
') as',
'    l_blob blob := p_in_blob;',
'begin',
'    htp.init;',
'    owa_util.mime_header(coalesce(p_in_mime_type, ''application/octet''), false, ''UTF-8'');',
'    htp.p(''Content-length: '' || dbms_lob.getlength(p_in_blob));',
'    htp.p(''Content-Disposition: attachment; filename="'' || apex_escape.html_attribute(p_in_file_name) || ''"'');',
'    if p_in_ajax_reference is not null then',
'        htp.p(''ajax-reference: '' || p_in_ajax_reference);',
'    end if;',
'',
'    if p_in_cache_time_s is not null then',
'        htp.p(''Cache-Control: public, max-age='' || p_in_cache_time_s);',
'        htp.p(''Pragma: ''); -- overrides the "no-cache" setting in the application',
'    end if;',
'',
'    owa_util.http_header_close;',
'    wpg_docload.download_file(l_blob);',
'exception',
'    when others then',
'        apex_debug.error(''APEX Unleash RTE (TinyMCE) - Error while Execute File Download'');',
'        apex_debug.error(sqlerrm);',
'        apex_debug.error(dbms_utility.format_error_backtrace);',
'        raise;',
'end;',
'',
'function sql_to_sys_refcursor (',
'    p_in_sql_statement clob,',
'    p_in_binds         sys.dbms_sql.varchar2_table',
') return sys_refcursor as',
'    l_curs       binary_integer;',
'    l_ref_cursor sys_refcursor;',
'    l_exec       binary_integer;',
'    l_binds      varchar(32767);',
'begin',
'    l_curs       := dbms_sql.open_cursor;',
'    dbms_sql.parse(l_curs, p_in_sql_statement, dbms_sql.native);',
'    if p_in_binds.count > 0 then',
'        for i in 1..p_in_binds.count loop',
'            -- TODO find out how to prevent ltrim',
'            l_binds := ltrim(p_in_binds(i), '':'');',
'            dbms_sql.bind_variable(l_curs, l_binds, v(l_binds));',
'        end loop;',
'    end if;',
'    l_exec       := dbms_sql.execute(l_curs);',
'    l_ref_cursor := dbms_sql.to_refcursor(l_curs);',
'    return l_ref_cursor;',
'exception',
'    when others then',
'        if dbms_sql.is_open(l_curs) then',
'            dbms_sql.close_cursor(l_curs);',
'        end if;',
'        raise;',
'end;',
'',
'function f_ajax (',
'    p_dynamic_action in apex_plugin.t_dynamic_action,',
'    p_plugin         in apex_plugin.t_plugin',
') return apex_plugin.t_dynamic_action_ajax_result is',
'    c_function_type     constant varchar2(32767) := apex_application.g_x01;',
'    c_plsql_print_img   constant varchar2(32767) := p_dynamic_action.attribute_15;',
'    c_plsql_upload_clob constant varchar2(32767) := p_dynamic_action.attribute_06;',
'    c_plsql_upload_img  constant varchar2(32767) := p_dynamic_action.attribute_14;',
'    c_sql               constant varchar2(32767) := p_dynamic_action.attribute_03;',
'    l_pk                varchar2(32767) := apex_application.g_x02;',
'    l_bind_names        sys.dbms_sql.varchar2_table;',
'    l_blob              blob;',
'    l_clob              clob := null;',
'    l_cur               sys_refcursor;',
'    l_file_name         varchar2(32767);',
'    l_mime_type         varchar2(32767);',
'    l_tmp_str           varchar2(32767);',
'    l_cache_time        number;',
'    l_result            apex_plugin.t_dynamic_action_ajax_result;',
'begin',
'    case',
'        when c_function_type = ''PRINT_CLOB'' then',
'            begin',
'                -- undocumented function of APEX for get all bindings',
'                l_bind_names := wwv_flow_utilities.get_binds(c_sql);',
'                l_cur        := sql_to_sys_refcursor(rtrim(c_sql, '';''), l_bind_names);',
'',
'                -- create json',
'                apex_json.open_object;',
'                    apex_json.write(''row'', l_cur);',
'                apex_json.close_object;',
'            exception',
'                when others then',
'                    if l_cur%isopen then',
'                        close l_cur;',
'                    end if;',
'                    apex_debug.error(''APEX Unleash RTE (TinyMCE) - Error while execute clob download'');',
'                    apex_debug.error(sqlerrm);',
'                    apex_debug.error(dbms_utility.format_error_backtrace);',
'                    raise;',
'            end;',
'        when c_function_type = ''UPLOAD_CLOB'' then',
'            begin',
'                l_clob := apex_application.g_clob_01;',
'                store_clob(',
'                    p_in_plsql_block => c_plsql_upload_clob,',
'                    p_in_clob => l_clob );',
'                apex_debug.info(''APEX Unleash RTE (TinyMCE) - Upload and Execute of Dynamic PL/SQL Block successful with CLOB: '' || dbms_lob.getlength(l_clob) || '' Bytes.'');',
'            exception',
'                when others then',
'                    apex_debug.error(''APEX Unleash RTE (TinyMCE) - Error while upload clob'');',
'                    apex_debug.error(sqlerrm);',
'                    apex_debug.error(dbms_utility.format_error_backtrace);',
'                    raise;',
'            end;',
'        when c_function_type = ''PRINT_IMAGE'' then',
'            begin',
'                get_image(',
'                    p_in_plsql_print_img => c_plsql_print_img,',
'                    p_in_pk => l_pk,',
'                    p_out_blob => l_blob,',
'                    p_out_file_name => l_file_name,',
'                    p_out_mime_type => l_mime_type,',
'                    p_out_cache_time => l_cache_time );',
'            exception',
'                when others then',
'                    apex_debug.error(''APEX Unleash RTE (TinyMCE) - Error while executing dynamic PL/SQL Block to get Blob Source for Image Download.'');',
'                    apex_debug.error(sqlerrm);',
'                    apex_debug.error(dbms_utility.format_error_backtrace);',
'                    raise;',
'            end;',
'',
'            if l_file_name is not null then',
'                download_file(',
'                    p_in_blob => l_blob,',
'                    p_in_file_name => l_file_name,',
'                    p_in_mime_type => l_mime_type,',
'                    p_in_cache_time_s => l_cache_time );',
'            end if;',
'',
'        when c_function_type = ''UPLOAD_IMAGE'' then',
'            begin',
'                l_file_name := apex_application.g_x02;',
'                l_mime_type := coalesce(apex_application.g_x03, ''application/octet-stream'');',
'                l_blob := apex_web_service.clobbase642blob(apex_application.g_clob_01);',
'',
'                if dbms_lob.getlength(l_blob) is not null then',
'                    store_image(',
'                        p_in_plsql_block => c_plsql_upload_img,',
'                        p_in_file_name => l_file_name,',
'                        p_in_mime_type => l_mime_type,',
'                        p_in_binary_file => l_blob,',
'                        p_out_pk => l_pk );',
'                    apex_debug.info(''APEX Unleash RTE (TinyMCE) - Upload and Execute of Dynamic PL/SQL Block successful with Image: '' || dbms_lob.getlength(l_blob) || '' Bytes and returned pk: '' || l_pk);',
'                end if;',
'                apex_json.open_object;',
'                    apex_json.write(p_name => ''pk'', p_value => l_pk );',
'                    apex_json.write(p_name => ''index'', p_value => to_number(apex_application.g_x04) );',
'                    apex_json.write(p_name => ''result'', p_value => ''ok'');',
'                apex_json.close_object;',
'                dbms_lob.freetemporary(l_blob);',
'            exception',
'                when others then',
'                    dbms_lob.freetemporary(l_blob);',
'                    apex_debug.error(''APEX Unleash RTE (TinyMCE) - Error while Uploading Image'');',
'                    apex_debug.error(sqlerrm);',
'                    apex_debug.error(dbms_utility.format_error_backtrace);',
'                    raise;',
'            end;',
'        else',
'            apex_debug.error(''APEX Unleash RTE (TinyMCE) - No Case found in F_AJAX'');',
'    end case;',
'',
'    return l_result;',
'end;',
'',
'function f_render (',
'    p_dynamic_action in apex_plugin.t_dynamic_action,',
'    p_plugin         in apex_plugin.t_plugin',
') return apex_plugin.t_dynamic_action_render_result is',
'    c_function_type      constant varchar2(32767) := p_dynamic_action.attribute_01;',
'    c_suppress_change    constant boolean := p_dynamic_action.attribute_02 = ''Y'';',
'    c_max_img_width      constant varchar2(32767) := p_dynamic_action.attribute_08;',
'    c_sanitize_html      constant boolean := p_dynamic_action.attribute_10 = ''Y'';',
'    c_sanitize_html_opt  constant varchar2(32767) := p_dynamic_action.attribute_11;',
'    c_show_loader        constant boolean := p_dynamic_action.attribute_12 = ''Y'';',
'    c_use_image_uploader constant boolean := p_dynamic_action.attribute_13 = ''Y'';',
'    c_items_2_submit     constant varchar2(32767) := apex_plugin_util.page_item_names_to_jquery(p_dynamic_action.attribute_07);',
'    c_items_2_submit_iu  constant varchar2(32767) := apex_plugin_util.page_item_names_to_jquery(p_dynamic_action.attribute_04);',
'    c_items_2_submit_id  constant varchar2(32767) := apex_plugin_util.page_item_names_to_jquery(p_dynamic_action.attribute_05);',
'    l_result             apex_plugin.t_dynamic_action_render_result;',
'begin',
'    apex_javascript.add_library(',
'        p_name => ''purify'',',
'        p_directory => p_plugin.file_prefix,',
'        p_check_to_add_minified => true,',
'        p_version => null,',
'        p_key => ''dompurify''',
'    );',
'',
'    apex_javascript.add_library(',
'        p_name => ''script'',',
'        p_directory => p_plugin.file_prefix,',
'        p_check_to_add_minified => true,',
'        p_version => null,',
'        p_key => ''unleashrtetincymcejssrc''',
'    );',
'',
'    l_result.javascript_function := ''function () { const self = this; unleashTinyMCE(apex, $, DOMPurify).initialize( self, { '' ||',
'        apex_javascript.add_attribute(''ajaxID'', apex_plugin.get_ajax_identifier) ||',
'        apex_javascript.add_attribute(''functionType'', c_function_type) ||',
'        apex_javascript.add_attribute(''maxImageWidth'', c_max_img_width) ||',
'        apex_javascript.add_attribute(''items2Submit'', c_items_2_submit) ||',
'        apex_javascript.add_attribute(''items2SubmitImgDown'', c_items_2_submit_id) ||',
'        apex_javascript.add_attribute(''items2SubmitImgUp'', c_items_2_submit_iu) ||',
'        apex_javascript.add_attribute(''suppressChangeEvent'', c_suppress_change) ||',
'        apex_javascript.add_attribute(''sanitize'', c_sanitize_html) ||',
'        apex_javascript.add_attribute(''sanitizeOptions'', c_sanitize_html_opt) ||',
'        apex_javascript.add_attribute(''useImageUploader'', c_use_image_uploader) ||',
'        apex_javascript.add_attribute(''showLoader'', c_show_loader, true, false) ||',
'    ''}); }'';',
'',
'    return l_result;',
'end f_render;'))
,p_default_escape_mode=>'HTML'
,p_api_version=>2
,p_render_function=>'F_RENDER'
,p_ajax_function=>'F_AJAX'
,p_standard_attributes=>'ITEM:REQUIRED:WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This plug-in makes it possible to add important features TinyMCE based Rich Text Editor in APEX:</p>',
'<ul>',
'<li>Load and save CLOB</li>',
'<li>It can remove dangerous HTML code from the CLOB or you can escaped the whole CLOB</li>',
'<li>If images are inserted into the RTE via Drag''n''Drop or screenshots are inserted into the RTE via CTRL+V, they are loaded into the database as BLOB and only referenced in the CLOB</li>',
'</ul>'))
,p_version_identifier=>'24.03.22'
,p_about_url=>'https://github.com/RonnyWeiss'
,p_files_version=>742
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(165263246841269439759)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_title=>'Security'
,p_display_sequence=>30
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(165264132688866451520)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_title=>'Image Handling'
,p_display_sequence=>20
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(165264801277419953446)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_title=>'CLOB Handling'
,p_display_sequence=>10
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236397312314815192)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
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
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(165236397718633815192)
,p_plugin_attribute_id=>wwv_flow_imp.id(165236397312314815192)
,p_display_sequence=>10
,p_display_value=>'Load RichTextEditor Content'
,p_return_value=>'RENDER'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(165236398202937815193)
,p_plugin_attribute_id=>wwv_flow_imp.id(165236397312314815192)
,p_display_sequence=>20
,p_display_value=>'Save RichTextEditor Content'
,p_return_value=>'SAVE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165955663966500102504)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Suppress Change Event'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'When Images are uploaded or when item is set after clob load then the item value does change. This settings is used to suppress the change events after this.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236399085582815193)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
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
,p_depending_on_attribute_id=>wwv_flow_imp.id(165236397312314815192)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'RENDER'
,p_attribute_group_id=>wwv_flow_imp.id(165264801277419953446)
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
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236399507798815193)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>150
,p_prompt=>'Items to Submit (NO SSP Protected allowed because of APEX Bug)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(165236403134679815196)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(165264132688866451520)
,p_help_text=>'Item to submit when upload image'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236399886135815194)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>170
,p_prompt=>'Items to Submit (NO SSP Protected allowed because of APEX Bug)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(165236403134679815196)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(165264132688866451520)
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Items that should be submitted for Image Loader.</p>',
'<b>Because of missing APEX feature no item with checksum can be used here.</b>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236400349824815194)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Execute PL/SQL'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_col_name varchar2(100) := coalesce(:P1_CLOB_COLLECTION, ''MY_COLLECTION'');',
'begin',
'    apex_collection.create_or_truncate_collection(p_collection_name => l_col_name);',
'    apex_collection.add_member(p_collection_name => l_col_name, p_clob001 => :CLOB);',
'end;'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(165236397312314815192)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'SAVE'
,p_attribute_group_id=>wwv_flow_imp.id(165264801277419953446)
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>You can execute dynamic PL/SQL when upload a CLOB.</p>',
'<pre>',
'declare',
'    l_col_name varchar2(100) := coalesce(:P1_CLOB_COLLECTION, ''MY_COLLECTION'');',
'begin',
'    apex_collection.create_or_truncate_collection(p_collection_name => l_col_name);',
'    apex_collection.add_member(p_collection_name => l_col_name, p_clob001 => :CLOB);',
'end;',
'</pre>'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236400748943815194)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(165264801277419953446)
,p_help_text=>'Items that should be submited in each ajax call when upload or render CLOB or image.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165957452821222161752)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>20
,p_prompt=>'Image Max Width'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'100%'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(165236403134679815196)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(165264132688866451520)
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236401939253815195)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Sanitize HTML'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(165263246841269439759)
,p_help_text=>'Sanitizes HTML e.g. &lt;script&gt; tags will be removed.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236402339114815195)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
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
,p_depending_on_attribute_id=>wwv_flow_imp.id(165236401939253815195)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(165263246841269439759)
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
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236402747196815195)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
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
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236403134679815196)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>10
,p_prompt=>'Use Image Uploader'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(165236397312314815192)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'RENDER'
,p_attribute_group_id=>wwv_flow_imp.id(165264132688866451520)
,p_help_text=>'This plugin can upload image to the database when drag or paste images into RichTextEditor. In RichTextEditor the images will just be referenced.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236403527780815196)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Execute on Image Upload'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_col_name varchar2(200) := coalesce(:P1_IMG_COLLECTION, ''IMG_COLLECTION'');',
'begin',
'    if not apex_collection.collection_exists(p_collection_name => l_col_name) then',
'        apex_collection.create_collection(p_collection_name => l_col_name);',
'    end if;',
'',
'    apex_collection.add_member(',
'        p_collection_name => l_col_name,',
'        p_c001 => :FILE_NAME,',
'        p_c002 => :MIME_TYPE,',
'        p_blob001 => :BINARY_FILE',
'    );',
'',
'    :P_OUT_PK := :FILE_NAME;',
'exception',
'    when others then',
'        apex_debug.error(sqlerrm);',
'        apex_debug.error(dbms_utility.format_error_stack);',
'end;'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(165236403134679815196)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(165264132688866451520)
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This PL/SQL block is executed when a new image is loaded into the RTE.</p>',
'<p>Check APEX Debug when error occurs.</p>',
'<pre>',
'declare',
'    l_col_name varchar2(200) := coalesce(:P1_IMG_COLLECTION, ''IMG_COLLECTION'');',
'begin',
'    if not apex_collection.collection_exists(p_collection_name => l_col_name) then',
'        apex_collection.create_collection(p_collection_name => l_col_name);',
'    end if;',
'',
'    apex_collection.add_member(',
'        p_collection_name => l_col_name,',
'        p_c001 => :FILE_NAME,',
'        p_c002 => :MIME_TYPE,',
'        p_blob001 => :BINARY_FILE',
'    );',
'',
'    :P_OUT_PK := :FILE_NAME;',
'exception',
'    when others then',
'        apex_debug.error(sqlerrm);',
'        apex_debug.error(dbms_utility.format_error_stack);',
'end;',
'</pre>'))
);
end;
/
begin
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(165236403926346815196)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>160
,p_prompt=>'Execute to get Image Sources'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'begin',
'    select',
'        c001,',
'        c002,',
'        blob001',
'    into',
'        :FILE_NAME,',
'        :MIME_TYPE,',
'        :BINARY_FILE',
'    from',
'        apex_collections',
'    where',
'            collection_name = coalesce(:P1_IMG_COLLECTION, ''IMG_COLLECTION'')',
'        and c001   = :PK',
'        and rownum = 1;',
'exception',
'    when others then',
'        apex_debug.error(sqlerrm);',
'        apex_debug.error(dbms_utility.format_error_stack);',
'end;'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(165236403134679815196)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_attribute_group_id=>wwv_flow_imp.id(165264132688866451520)
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>If the CLOB is loaded into the RTE, the image download is inserted on the left.</p>',
'<p>This PL/SQL block is used to load the images from a table or collection using a primary key (:PK).</p>',
'<p>On Error please check APEX Debug.</p>',
'<pre>',
'declare',
'begin',
'    select',
'        c001,',
'        c002,',
'        blob001',
'    into',
'        :FILE_NAME,',
'        :MIME_TYPE,',
'        :BINARY_FILE',
'    from',
'        apex_collections',
'    where',
'            collection_name = coalesce(:P1_IMG_COLLECTION, ''IMG_COLLECTION'')',
'        and c001   = :PK',
'        and rownum = 1;',
'exception',
'    when others then',
'        apex_debug.error(sqlerrm);',
'        apex_debug.error(dbms_utility.format_error_stack);',
'end;',
'</pre>'))
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(165239407612089815200)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_name=>'clobloaderror'
,p_display_name=>'CLOB load error'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(165239408041971815200)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_name=>'clobloadfinished'
,p_display_name=>'CLOB load finished'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(165239408402727815200)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_name=>'clobsaveerror'
,p_display_name=>'CLOB save error'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(165239408836570815200)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_name=>'clobsavefinished'
,p_display_name=>'CLOB save finished'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(165239409205375815201)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_name=>'imageuploaderror'
,p_display_name=>'Image upload error'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(165239409641989815201)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_name=>'imageuploadifnished'
,p_display_name=>'Image upload finished'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '636F6E737420756E6C6561736854696E794D43453D66756E6374696F6E28652C742C72297B2275736520737472696374223B636F6E737420613D7B6665617475726544657461696C733A7B6E616D653A224150455820556E6C6561736820526963685465';
wwv_flow_imp.g_varchar2_table(2) := '7874456469746F72202854696E794D434529222C73637269707456657273696F6E3A2232342E30332E3232222C7574696C56657273696F6E3A2232322E31312E3238222C75726C3A2268747470733A2F2F6769746875622E636F6D2F526F6E6E79576569';
wwv_flow_imp.g_varchar2_table(3) := '7373222C6C6963656E73653A224D4954227D2C6C6F616465723A7B73746172743A66756E6374696F6E28722C61297B612626742872292E63737328226D696E2D686569676874222C22313030707822292C652E7574696C2E73686F775370696E6E657228';
wwv_flow_imp.g_varchar2_table(4) := '74287229297D2C73746F703A66756E6374696F6E28652C72297B722626742865292E63737328226D696E2D686569676874222C2222292C7428652B22203E202E752D50726F63657373696E6722292E72656D6F766528292C7428652B22203E202E63742D';
wwv_flow_imp.g_varchar2_table(5) := '6C6F6164657222292E72656D6F766528297D7D2C6A736F6E53617665457874656E643A66756E6374696F6E28722C61297B6C657420693D7B7D2C6E3D7B7D3B69662822737472696E67223D3D747970656F662061297472797B6E3D4A534F4E2E70617273';
wwv_flow_imp.g_varchar2_table(6) := '652861297D63617463682874297B652E64656275672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768696C652074727920746F20706172736520746172676574436F6E6669672E20506C6561736520636865';
wwv_flow_imp.g_varchar2_table(7) := '636B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E222C6572723A742C746172676574436F6E6669673A617D297D656C7365206E3D742E657874656E642821302C7B7D2C61293B';
wwv_flow_imp.g_varchar2_table(8) := '7472797B693D742E657874656E642821302C7B7D2C722C6E297D63617463682861297B693D742E657874656E642821302C7B7D2C72292C652E64656275672E6572726F72287B6D6F64756C653A227574696C2E6A73222C6D73673A224572726F72207768';
wwv_flow_imp.g_varchar2_table(9) := '696C652074727920746F206D657267652032204A534F4E7320696E746F207374616E64617264204A534F4E20696620616E7920617474726962757465206973206D697373696E672E20506C6561736520636865636B20796F757220436F6E666967204A53';
wwv_flow_imp.g_varchar2_table(10) := '4F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E222C6572723A612C66696E616C436F6E6669673A697D297D72657475726E20697D7D2C693D27696D675B616C742A3D2261696823225D272C6E3D226169682323223B66';
wwv_flow_imp.g_varchar2_table(11) := '756E6374696F6E207328652C74297B72657475726E20722E73616E6974697A6528652C742E73616E6974697A654F7074696F6E73297D66756E6374696F6E206F28722C6F2C6C297B7472797B6C657420753B6F26266F2E726F7726266F2E726F775B305D';
wwv_flow_imp.g_varchar2_table(12) := '26266F2E726F775B305D2E434C4F425F56414C5545262628753D22222B6F2E726F775B305D2E434C4F425F56414C5545292C6C2E73616E6974697A65262628753D7328752C6C29292C66756E6374696F6E28722C73297B6C6574206F2C6C3D7428223C64';
wwv_flow_imp.g_varchar2_table(13) := '69763E22293B6C2E68746D6C2873293B7472797B6F3D6C2E66696E642869292C742E65616368286F2C2866756E6374696F6E28742C69297B6C657420733D692E7469746C653B737C7C28733D692E616C742E73706C6974286E295B315D292C733F692E73';
wwv_flow_imp.g_varchar2_table(14) := '72633D652E7365727665722E706C7567696E55726C28722E616A617849442C7B7830313A225052494E545F494D414745222C7830323A732C706167654974656D733A722E6974656D73325375626D6974496D67446F776E7D293A652E64656275672E6572';
wwv_flow_imp.g_varchar2_table(15) := '726F72287B6663743A60247B612E6665617475726544657461696C732E6E616D657D202D207570646174655570496D616765537263602C6D73673A605072696D617279206B6579206F6620247B6E7D206973206D697373696E67602C6665617475726544';
wwv_flow_imp.g_varchar2_table(16) := '657461696C733A612E6665617475726544657461696C737D297D29292C6C5B305D2E696E6E657248544D4C2626722E7274654974656D2E73657456616C7565286C5B305D2E696E6E657248544D4C2C6E756C6C2C722E73757070726573734368616E6765';
wwv_flow_imp.g_varchar2_table(17) := '4576656E74297D63617463682874297B652E64656275672E6572726F72287B6663743A60247B612E6665617475726544657461696C732E6E616D657D202D207570646174655570496D616765537263602C6D73673A224572726F72207768696C65207472';
wwv_flow_imp.g_varchar2_table(18) := '7920746F206C6F616420696D61676573207768656E206C6F6164696E672072696368207465787420656469746F722E222C6572723A742C6665617475726544657461696C733A612E6665617475726544657461696C737D297D7D286C2C75292C6C2E7274';
wwv_flow_imp.g_varchar2_table(19) := '65496E7374616E63652E6F6E28226368616E6765222C652E7574696C2E6465626F756E6365282866756E6374696F6E28722C69297B2166756E6374696F6E2872297B7472797B722E727465496E7374616E63652E656469746F7255706C6F61642E736361';
wwv_flow_imp.g_varchar2_table(20) := '6E466F72496D6167657328292E7468656E282866756E6374696F6E2869297B693F2E6C656E6774683E30262628722E73686F774C6F616465722626612E6C6F616465722E737461727428722E727465436F6E7461696E657253656C292C692E666F724561';
wwv_flow_imp.g_varchar2_table(21) := '6368282866756E6374696F6E28732C6F297B636F6E7374206C3D732E626C6F62496E666F2C753D6C2E66696C656E616D6528292C633D6C2E626C6F6228292E747970652C643D22646174613A222B6C2E626C6F6228292E747970652B223B626173653634';
wwv_flow_imp.g_varchar2_table(22) := '2C222B6C2E62617365363428293B652E64656275672E696E666F287B6663743A60247B612E6665617475726544657461696C732E6E616D657D202D2075706C6F616446696C6573602C66696C654E616D653A752C6D696D65547970653A632C6261736536';
wwv_flow_imp.g_varchar2_table(23) := '3446696C653A642C6665617475726544657461696C733A612E6665617475726544657461696C737D292C652E7365727665722E706C7567696E28722E616A617849442C7B7830313A2255504C4F41445F494D414745222C7830323A752C7830333A632C78';
wwv_flow_imp.g_varchar2_table(24) := '30343A6F2C705F636C6F625F30313A6C2E62617365363428292C706167654974656D733A722E6974656D73325375626D6974496D6755707D2C7B737563636573733A66756E6374696F6E2873297B636F6E7374206F3D695B732E696E6465785D2E626C6F';
wwv_flow_imp.g_varchar2_table(25) := '62496E666F2C6C3D22646174613A222B6F2E626C6F6228292E747970652B223B6261736536342C222B6F2E62617365363428293B6C657420753D7428223C6469763E22293B752E68746D6C28722E727465496E7374616E63652E676574436F6E74656E74';
wwv_flow_imp.g_varchar2_table(26) := '2829292C752E66696E642860696D675B7372633D22247B6C7D225D60292E65616368282866756E6374696F6E28612C69297B742869292E617474722822737263222C652E7365727665722E706C7567696E55726C28722E616A617849442C7B7830313A22';
wwv_flow_imp.g_varchar2_table(27) := '5052494E545F494D414745222C7830323A732E706B2C706167654974656D733A722E6974656D73325375626D6974496D67446F776E7D29292C742869292E63737328226D61782D7769647468222C722E6D6178496D6167655769647468292C742869292E';
wwv_flow_imp.g_varchar2_table(28) := '617474722822616C74222C6E2B732E706B292C722E727465496E7374616E63652E656469746F7255706C6F61642E64657374726F7928292C755B305D2E696E6E657248544D4C2626722E7274654974656D2E73657456616C756528755B305D2E696E6E65';
wwv_flow_imp.g_varchar2_table(29) := '7248544D4C2C6E756C6C2C722E73757070726573734368616E67654576656E74297D29292C732E696E6465782B313D3D3D692E6C656E677468262628652E6576656E742E7472696767657228722E72746553656C2C22696D61676575706C6F616469666E';
wwv_flow_imp.g_varchar2_table(30) := '697368656422292C722E73686F774C6F616465722626612E6C6F616465722E73746F7028722E727465436F6E7461696E657253656C29297D2C6572726F723A66756E6374696F6E28742C692C6E297B652E64656275672E6572726F72287B6663743A6024';
wwv_flow_imp.g_varchar2_table(31) := '7B612E6665617475726544657461696C732E6E616D657D202D2075706C6F616446696C6573602C6D73673A22496D6167652055706C6F6164206572726F72222C6A715848523A742C746578745374617475733A692C6572726F725468726F776E3A6E2C66';
wwv_flow_imp.g_varchar2_table(32) := '65617475726544657461696C733A612E6665617475726544657461696C737D292C722E73686F774C6F616465722626612E6C6F616465722E73746F7028722E727465436F6E7461696E657253656C292C652E6576656E742E7472696767657228722E7274';
wwv_flow_imp.g_varchar2_table(33) := '6553656C2C22696D61676575706C6F61646572726F7222297D7D297D2929297D29297D63617463682874297B652E64656275672E6572726F72287B6663743A60247B612E6665617475726544657461696C732E6E616D657D202D2075706C6F616446696C';
wwv_flow_imp.g_varchar2_table(34) := '6573602C6D73673A224572726F72207768696C652074727920746F2061646420696D6167657320746F20746F2064622061667465722064726F70206F7220706173746520696D616765222C6572723A742C6665617475726544657461696C733A612E6665';
wwv_flow_imp.g_varchar2_table(35) := '617475726544657461696C737D297D7D286C297D292C353029292C612E6C6F616465722E73746F70286C2E727465436F6E7461696E657253656C292C652E6576656E742E74726967676572286C2E72746553656C2C22636C6F626C6F616466696E697368';
wwv_flow_imp.g_varchar2_table(36) := '656422292C652E64612E726573756D6528722E726573756D6543616C6C6261636B2C2131297D63617463682874297B652E64656275672E6572726F72287B6663743A60247B612E6665617475726544657461696C732E6E616D657D202D207072696E7443';
wwv_flow_imp.g_varchar2_table(37) := '6C6F62602C6D73673A224572726F72207768696C652072656E64657220434C4F42222C6572723A742C6665617475726544657461696C733A612E6665617475726544657461696C737D292C652E6576656E742E74726967676572286C2E72746553656C2C';
wwv_flow_imp.g_varchar2_table(38) := '22636C6F626C6F61646572726F7222292C652E64612E726573756D6528722E726573756D6543616C6C6261636B2C2130297D7D66756E6374696F6E206C28722C6F297B6C6574206C3D66756E6374696F6E2865297B6C657420723D7428223C6469763E22';
wwv_flow_imp.g_varchar2_table(39) := '293B72657475726E20722E68746D6C28652E676574436F6E74656E742829292C722E66696E642869292E617474722822737263222C2261696822292C725B305D2E696E6E657248544D4C7D286F2E727465496E7374616E6365292C753D66756E6374696F';
wwv_flow_imp.g_varchar2_table(40) := '6E2865297B6C657420723D5B5D2C613D7428223C6469763E22293B72657475726E20615B305D2E696E6E657248544D4C3D652E727465496E7374616E63652E676574436F6E74656E7428292C742E6561636828612E66696E642869292C2866756E637469';
wwv_flow_imp.g_varchar2_table(41) := '6F6E28652C74297B6C657420613D742E7469746C653B617C7C28613D742E616C742E73706C6974286E295B315D292C722E707573682861297D29292C727D286F293B6F2E73616E6974697A652626286C3D73286C2C6F29292C652E7365727665722E706C';
wwv_flow_imp.g_varchar2_table(42) := '7567696E286F2E616A617849442C7B7830313A2255504C4F41445F434C4F42222C705F636C6F625F30313A6C2C706167654974656D733A6F2E6974656D73325375626D69747D2C7B64617461547970653A2274657874222C737563636573733A66756E63';
wwv_flow_imp.g_varchar2_table(43) := '74696F6E28297B612E6C6F616465722E73746F70286F2E727465436F6E7461696E657253656C292C652E6576656E742E74726967676572286F2E72746553656C2C22636C6F627361766566696E6973686564222C752E6A6F696E28223A2229292C652E64';
wwv_flow_imp.g_varchar2_table(44) := '612E726573756D6528722E726573756D6543616C6C6261636B2C2131297D2C6572726F723A66756E6374696F6E28742C692C6E297B612E6C6F616465722E73746F70286F2E727465436F6E7461696E657253656C292C652E64656275672E6572726F7228';
wwv_flow_imp.g_varchar2_table(45) := '7B6663743A612E6665617475726544657461696C732E6E616D652B22202D2075706C6F6164436C6F62222C6D73673A22436C6F622055706C6F6164206572726F72222C6A715848523A742C746578745374617475733A692C6572726F725468726F776E3A';
wwv_flow_imp.g_varchar2_table(46) := '6E2C6665617475726544657461696C733A612E6665617475726544657461696C737D292C652E6576656E742E74726967676572286F2E72746553656C2C22636C6F62736176656572726F72222C752E6A6F696E28223A2229292C652E64612E726573756D';
wwv_flow_imp.g_varchar2_table(47) := '6528722E726573756D6543616C6C6261636B2C2130297D7D297D66756E6374696F6E20752874297B652E6D6573736167652E73686F774572726F7273285B7B747970653A226572726F72222C6C6F636174696F6E3A5B2270616765222C22696E6C696E65';
wwv_flow_imp.g_varchar2_table(48) := '225D2C706167654974656D3A742E72746549642C6D6573736167653A60247B612E6665617475726544657461696C732E6E616D657D20737570706F727473206F6E6C792054696E63794D43452062617365642052696368205465787420456469746F7220';
wwv_flow_imp.g_varchar2_table(49) := '7769746820466F726D61742073657420746F202248544D4C2221602C756E736166653A21317D5D297D72657475726E7B696E697469616C697A653A66756E6374696F6E28722C69297B652E64656275672E696E666F287B6663743A60247B612E66656174';
wwv_flow_imp.g_varchar2_table(50) := '75726544657461696C732E6E616D657D202D20696E697469616C697A65602C617267756D656E74733A7B70546869733A722C704F7074733A697D2C6665617475726544657461696C733A612E6665617475726544657461696C737D293B6C6574206E3D69';
wwv_flow_imp.g_varchar2_table(51) := '3B6966286E2E73616E6974697A654F7074696F6E733D612E6A736F6E53617665457874656E64287B414C4C4F5745445F415454523A5B226163636573736B6579222C22616C69676E222C22616C74222C22616C77617973222C226175746F636F6D706C65';
wwv_flow_imp.g_varchar2_table(52) := '7465222C226175746F706C6179222C22626F72646572222C2263656C6C70616464696E67222C2263656C6C73706163696E67222C2263686172736574222C22636C617373222C22636F6C7370616E222C22646972222C22686569676874222C2268726566';
wwv_flow_imp.g_varchar2_table(53) := '222C226964222C226C616E67222C226E616D65222C2272656C222C227265717569726564222C22726F777370616E222C22737263222C227374796C65222C2273756D6D617279222C22746162696E646578222C22746172676574222C227469746C65222C';
wwv_flow_imp.g_varchar2_table(54) := '2274797065222C2276616C7565222C227769647468225D2C414C4C4F5745445F544147533A5B2261222C2261646472657373222C2262222C22626C6F636B71756F7465222C226272222C2263617074696F6E222C22636F6465222C226464222C22646976';
wwv_flow_imp.g_varchar2_table(55) := '222C22646C222C226474222C22656D222C2266696763617074696F6E222C22666967757265222C226831222C226832222C226833222C226834222C226835222C226836222C226872222C2269222C22696D67222C226C6162656C222C226C69222C226E6C';
wwv_flow_imp.g_varchar2_table(56) := '222C226F6C222C2270222C22707265222C2273222C227370616E222C22737472696B65222C227374726F6E67222C22737562222C22737570222C227461626C65222C2274626F6479222C227464222C227468222C227468656164222C227472222C227522';
wwv_flow_imp.g_varchar2_table(57) := '2C22756C225D7D2C692E73616E6974697A654F7074696F6E73292C722E6166666563746564456C656D656E74735B305D297B6966286E2E727465243D7428722E6166666563746564456C656D656E74735B305D292C6E2E72746549643D6E2E727465242E';
wwv_flow_imp.g_varchar2_table(58) := '617474722822696422292C6E2E7274654974656D3D652E6974656D286E2E7274654964292C6E2E72746553656C3D6023247B6E2E72746549647D602C6E2E727465436F6E7461696E657253656C3D60247B6E2E72746553656C7D5F434F4E5441494E4552';
wwv_flow_imp.g_varchar2_table(59) := '602C216E2E7274654974656D7C7C2266756E6374696F6E22213D747970656F66206E2E7274654974656D2E676574456469746F722972657475726E2075286E292C652E64612E726573756D6528722E726573756D6543616C6C6261636B2C2130292C2131';
wwv_flow_imp.g_varchar2_table(60) := '3B696628692E727465496E7374616E63653D6E2E7274654974656D2E676574456469746F7228292C21692E727465496E7374616E63657C7C2268746D6C22213D3D692E727465242E6174747228226D6F646522292972657475726E2075286E292C652E64';
wwv_flow_imp.g_varchar2_table(61) := '612E726573756D6528722E726573756D6543616C6C6261636B2C2130292C21313B6E2E73686F774C6F616465722626612E6C6F616465722E7374617274286E2E727465436F6E7461696E657253656C292C2252454E444552223D3D3D6E2E66756E637469';
wwv_flow_imp.g_varchar2_table(62) := '6F6E547970653F652E7365727665722E706C7567696E286E2E616A617849442C7B7830313A225052494E545F434C4F42222C706167654974656D733A6E2E6974656D73325375626D69747D2C7B737563636573733A66756E6374696F6E2865297B6F2872';
wwv_flow_imp.g_varchar2_table(63) := '2C652C6E297D2C6572726F723A66756E6374696F6E2874297B652E64656275672E6572726F72287B6663743A60247B612E6665617475726544657461696C732E6E616D657D202D20696E697469616C697A65602C6D73673A22414A415820646174612065';
wwv_flow_imp.g_varchar2_table(64) := '72726F72222C726573706F6E73653A742C6665617475726544657461696C733A612E6665617475726544657461696C737D297D2C64617461547970653A226A736F6E227D293A6C28722C6E297D7D7D7D3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(83143775409650196920)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_file_name=>'script.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '4D4954204C6963656E73650A0A436F7079726967687420286329203230323420526F6E6E792057656973730A0A5065726D697373696F6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E79207065';
wwv_flow_imp.g_varchar2_table(2) := '72736F6E206F627461696E696E67206120636F70790A6F66207468697320736F66747761726520616E64206173736F63696174656420646F63756D656E746174696F6E2066696C657320287468652022536F66747761726522292C20746F206465616C0A';
wwv_flow_imp.g_varchar2_table(3) := '696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E6720776974686F7574206C696D69746174696F6E20746865207269676874730A746F207573652C20636F70792C206D6F646966792C206D';
wwv_flow_imp.g_varchar2_table(4) := '657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F722073656C6C0A636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D697420706572736F6E7320746F20';
wwv_flow_imp.g_varchar2_table(5) := '77686F6D2074686520536F6674776172652069730A6675726E697368656420746F20646F20736F2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0A0A5468652061626F766520636F70797269676874206E';
wwv_flow_imp.g_varchar2_table(6) := '6F7469636520616E642074686973207065726D697373696F6E206E6F74696365207368616C6C20626520696E636C7564656420696E20616C6C0A636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520536F6674';
wwv_flow_imp.g_varchar2_table(7) := '776172652E0A0A54484520534F4654574152452049532050524F564944454420224153204953222C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052455353204F520A494D504C4945442C20494E434C5544494E47';
wwv_flow_imp.g_varchar2_table(8) := '20425554204E4F54204C494D4954454420544F205448452057415252414E54494553204F46204D45524348414E544142494C4954592C0A4649544E45535320464F52204120504152544943554C415220505552504F534520414E44204E4F4E494E465249';
wwv_flow_imp.g_varchar2_table(9) := '4E47454D454E542E20494E204E4F204556454E54205348414C4C205448450A415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941424C4520464F5220414E5920434C41494D2C2044414D41474553204F52204F544845';
wwv_flow_imp.g_varchar2_table(10) := '520A4C494142494C4954592C205748455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953494E472046524F4D2C0A4F5554204F46204F5220494E20434F4E4E454354';
wwv_flow_imp.g_varchar2_table(11) := '494F4E20574954482054484520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450A534F4654574152452E';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(165239410037049815201)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_file_name=>'LICENSE'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '68747470733A2F2F6769746875622E636F6D2F6375726535332F444F4D5075726966790D0A0D0A444F4D5075726966790D0A436F707972696768742032303135204D6172696F204865696465726963680D0A0D0A444F4D50757269667920697320667265';
wwv_flow_imp.g_varchar2_table(2) := '6520736F6674776172653B20796F752063616E2072656469737472696275746520697420616E642F6F72206D6F6469667920697420756E646572207468650D0A7465726D73206F66206569746865723A0D0A0D0A61292074686520417061636865204C69';
wwv_flow_imp.g_varchar2_table(3) := '63656E73652056657273696F6E20322E302C206F720D0A622920746865204D6F7A696C6C61205075626C6963204C6963656E73652056657273696F6E20322E300D0A0D0A2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_imp.g_varchar2_table(4) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A0D0A4C6963656E73656420756E6465722074686520417061636865204C6963656E73652C2056657273696F6E20322E302028746865';
wwv_flow_imp.g_varchar2_table(5) := '20224C6963656E736522293B0D0A796F75206D6179206E6F742075736520746869732066696C652065786365707420696E20636F6D706C69616E6365207769746820746865204C6963656E73652E0D0A596F75206D6179206F627461696E206120636F70';
wwv_flow_imp.g_varchar2_table(6) := '79206F6620746865204C6963656E73652061740D0A0D0A20202020687474703A2F2F7777772E6170616368652E6F72672F6C6963656E7365732F4C4943454E53452D322E300D0A0D0A20202020556E6C657373207265717569726564206279206170706C';
wwv_flow_imp.g_varchar2_table(7) := '696361626C65206C6177206F722061677265656420746F20696E2077726974696E672C20736F6674776172650D0A20202020646973747269627574656420756E64657220746865204C6963656E7365206973206469737472696275746564206F6E20616E';
wwv_flow_imp.g_varchar2_table(8) := '20224153204953222042415349532C0D0A20202020574954484F55542057415252414E54494553204F5220434F4E444954494F4E53204F4620414E59204B494E442C206569746865722065787072657373206F7220696D706C6965642E0D0A2020202053';
wwv_flow_imp.g_varchar2_table(9) := '656520746865204C6963656E736520666F7220746865207370656369666963206C616E677561676520676F7665726E696E67207065726D697373696F6E7320616E640D0A202020206C696D69746174696F6E7320756E64657220746865204C6963656E73';
wwv_flow_imp.g_varchar2_table(10) := '652E0D0A0D0A2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A4D6F7A696C6C61205075626C696320';
wwv_flow_imp.g_varchar2_table(11) := '4C6963656E73652C2076657273696F6E20322E300D0A0D0A312E20446566696E6974696F6E730D0A0D0A312E312E2093436F6E7472696275746F72940D0A0D0A20202020206D65616E73206561636820696E646976696475616C206F72206C6567616C20';
wwv_flow_imp.g_varchar2_table(12) := '656E74697479207468617420637265617465732C20636F6E747269627574657320746F207468650D0A20202020206372656174696F6E206F662C206F72206F776E7320436F766572656420536F6674776172652E0D0A0D0A312E322E2093436F6E747269';
wwv_flow_imp.g_varchar2_table(13) := '6275746F722056657273696F6E940D0A0D0A20202020206D65616E732074686520636F6D62696E6174696F6E206F662074686520436F6E747269627574696F6E73206F66206F74686572732028696620616E7929207573656420627920610D0A20202020';
wwv_flow_imp.g_varchar2_table(14) := '20436F6E7472696275746F7220616E64207468617420706172746963756C617220436F6E7472696275746F72927320436F6E747269627574696F6E2E0D0A0D0A312E332E2093436F6E747269627574696F6E940D0A0D0A20202020206D65616E7320436F';
wwv_flow_imp.g_varchar2_table(15) := '766572656420536F667477617265206F66206120706172746963756C617220436F6E7472696275746F722E0D0A0D0A312E342E2093436F766572656420536F667477617265940D0A0D0A20202020206D65616E7320536F7572636520436F646520466F72';
wwv_flow_imp.g_varchar2_table(16) := '6D20746F2077686963682074686520696E697469616C20436F6E7472696275746F7220686173206174746163686564207468650D0A20202020206E6F7469636520696E204578686962697420412C207468652045786563757461626C6520466F726D206F';
wwv_flow_imp.g_varchar2_table(17) := '66207375636820536F7572636520436F646520466F726D2C20616E640D0A20202020204D6F64696669636174696F6E73206F66207375636820536F7572636520436F646520466F726D2C20696E2065616368206361736520696E636C7564696E6720706F';
wwv_flow_imp.g_varchar2_table(18) := '7274696F6E730D0A202020202074686572656F662E0D0A0D0A312E352E2093496E636F6D70617469626C652057697468205365636F6E64617279204C6963656E736573940D0A20202020206D65616E730D0A0D0A2020202020612E207468617420746865';
wwv_flow_imp.g_varchar2_table(19) := '20696E697469616C20436F6E7472696275746F722068617320617474616368656420746865206E6F746963652064657363726962656420696E0D0A202020202020202045786869626974204220746F2074686520436F766572656420536F667477617265';
wwv_flow_imp.g_varchar2_table(20) := '3B206F720D0A0D0A2020202020622E20746861742074686520436F766572656420536F66747761726520776173206D61646520617661696C61626C6520756E64657220746865207465726D73206F662076657273696F6E0D0A2020202020202020312E31';
wwv_flow_imp.g_varchar2_table(21) := '206F72206561726C696572206F6620746865204C6963656E73652C20627574206E6F7420616C736F20756E64657220746865207465726D73206F6620610D0A20202020202020205365636F6E64617279204C6963656E73652E0D0A0D0A312E362E209345';
wwv_flow_imp.g_varchar2_table(22) := '786563757461626C6520466F726D940D0A0D0A20202020206D65616E7320616E7920666F726D206F662074686520776F726B206F74686572207468616E20536F7572636520436F646520466F726D2E0D0A0D0A312E372E20934C617267657220576F726B';
wwv_flow_imp.g_varchar2_table(23) := '940D0A0D0A20202020206D65616E73206120776F726B207468617420636F6D62696E657320436F766572656420536F6674776172652077697468206F74686572206D6174657269616C2C20696E20612073657061726174650D0A202020202066696C6520';
wwv_flow_imp.g_varchar2_table(24) := '6F722066696C65732C2074686174206973206E6F7420436F766572656420536F6674776172652E0D0A0D0A312E382E20934C6963656E7365940D0A0D0A20202020206D65616E73207468697320646F63756D656E742E0D0A0D0A312E392E20934C696365';
wwv_flow_imp.g_varchar2_table(25) := '6E7361626C65940D0A0D0A20202020206D65616E7320686176696E672074686520726967687420746F206772616E742C20746F20746865206D6178696D756D20657874656E7420706F737369626C652C2077686574686572206174207468650D0A202020';
wwv_flow_imp.g_varchar2_table(26) := '202074696D65206F662074686520696E697469616C206772616E74206F722073756273657175656E746C792C20616E7920616E6420616C6C206F66207468652072696768747320636F6E76657965642062790D0A202020202074686973204C6963656E73';
wwv_flow_imp.g_varchar2_table(27) := '652E0D0A0D0A312E31302E20934D6F64696669636174696F6E73940D0A0D0A20202020206D65616E7320616E79206F662074686520666F6C6C6F77696E673A0D0A0D0A2020202020612E20616E792066696C6520696E20536F7572636520436F64652046';
wwv_flow_imp.g_varchar2_table(28) := '6F726D207468617420726573756C74732066726F6D20616E206164646974696F6E20746F2C2064656C6574696F6E0D0A202020202020202066726F6D2C206F72206D6F64696669636174696F6E206F662074686520636F6E74656E7473206F6620436F76';
wwv_flow_imp.g_varchar2_table(29) := '6572656420536F6674776172653B206F720D0A0D0A2020202020622E20616E79206E65772066696C6520696E20536F7572636520436F646520466F726D207468617420636F6E7461696E7320616E7920436F766572656420536F6674776172652E0D0A0D';
wwv_flow_imp.g_varchar2_table(30) := '0A312E31312E2093506174656E7420436C61696D7394206F66206120436F6E7472696275746F720D0A0D0A2020202020206D65616E7320616E7920706174656E7420636C61696D2873292C20696E636C7564696E6720776974686F7574206C696D697461';
wwv_flow_imp.g_varchar2_table(31) := '74696F6E2C206D6574686F642C2070726F636573732C0D0A202020202020616E642061707061726174757320636C61696D732C20696E20616E7920706174656E74204C6963656E7361626C65206279207375636820436F6E7472696275746F7220746861';
wwv_flow_imp.g_varchar2_table(32) := '740D0A202020202020776F756C6420626520696E6672696E6765642C2062757420666F7220746865206772616E74206F6620746865204C6963656E73652C20627920746865206D616B696E672C0D0A2020202020207573696E672C2073656C6C696E672C';
wwv_flow_imp.g_varchar2_table(33) := '206F66666572696E6720666F722073616C652C20686176696E67206D6164652C20696D706F72742C206F72207472616E73666572206F660D0A2020202020206569746865722069747320436F6E747269627574696F6E73206F722069747320436F6E7472';
wwv_flow_imp.g_varchar2_table(34) := '696275746F722056657273696F6E2E0D0A0D0A312E31322E20935365636F6E64617279204C6963656E7365940D0A0D0A2020202020206D65616E73206569746865722074686520474E552047656E6572616C205075626C6963204C6963656E73652C2056';
wwv_flow_imp.g_varchar2_table(35) := '657273696F6E20322E302C2074686520474E55204C65737365720D0A20202020202047656E6572616C205075626C6963204C6963656E73652C2056657273696F6E20322E312C2074686520474E552041666665726F2047656E6572616C205075626C6963';
wwv_flow_imp.g_varchar2_table(36) := '0D0A2020202020204C6963656E73652C2056657273696F6E20332E302C206F7220616E79206C617465722076657273696F6E73206F662074686F7365206C6963656E7365732E0D0A0D0A312E31332E2093536F7572636520436F646520466F726D940D0A';
wwv_flow_imp.g_varchar2_table(37) := '0D0A2020202020206D65616E732074686520666F726D206F662074686520776F726B2070726566657272656420666F72206D616B696E67206D6F64696669636174696F6E732E0D0A0D0A312E31342E2093596F759420286F722093596F757294290D0A0D';
wwv_flow_imp.g_varchar2_table(38) := '0A2020202020206D65616E7320616E20696E646976696475616C206F722061206C6567616C20656E746974792065786572636973696E672072696768747320756E64657220746869730D0A2020202020204C6963656E73652E20466F72206C6567616C20';
wwv_flow_imp.g_varchar2_table(39) := '656E7469746965732C2093596F759420696E636C7564657320616E7920656E74697479207468617420636F6E74726F6C732C2069730D0A202020202020636F6E74726F6C6C65642062792C206F7220697320756E64657220636F6D6D6F6E20636F6E7472';
wwv_flow_imp.g_varchar2_table(40) := '6F6C207769746820596F752E20466F7220707572706F736573206F6620746869730D0A202020202020646566696E6974696F6E2C2093636F6E74726F6C94206D65616E73202861292074686520706F7765722C20646972656374206F7220696E64697265';
wwv_flow_imp.g_varchar2_table(41) := '63742C20746F2063617573650D0A20202020202074686520646972656374696F6E206F72206D616E6167656D656E74206F66207375636820656E746974792C207768657468657220627920636F6E7472616374206F720D0A2020202020206F7468657277';
wwv_flow_imp.g_varchar2_table(42) := '6973652C206F7220286229206F776E657273686970206F66206D6F7265207468616E2066696674792070657263656E74202835302529206F66207468650D0A2020202020206F75747374616E64696E6720736861726573206F722062656E656669636961';
wwv_flow_imp.g_varchar2_table(43) := '6C206F776E657273686970206F66207375636820656E746974792E0D0A0D0A0D0A322E204C6963656E7365204772616E747320616E6420436F6E646974696F6E730D0A0D0A322E312E204772616E74730D0A0D0A20202020204561636820436F6E747269';
wwv_flow_imp.g_varchar2_table(44) := '6275746F7220686572656279206772616E747320596F75206120776F726C642D776964652C20726F79616C74792D667265652C0D0A20202020206E6F6E2D6578636C7573697665206C6963656E73653A0D0A0D0A2020202020612E20756E64657220696E';
wwv_flow_imp.g_varchar2_table(45) := '74656C6C65637475616C2070726F70657274792072696768747320286F74686572207468616E20706174656E74206F722074726164656D61726B290D0A20202020202020204C6963656E7361626C65206279207375636820436F6E7472696275746F7220';
wwv_flow_imp.g_varchar2_table(46) := '746F207573652C20726570726F647563652C206D616B6520617661696C61626C652C0D0A20202020202020206D6F646966792C20646973706C61792C20706572666F726D2C20646973747269627574652C20616E64206F7468657277697365206578706C';
wwv_flow_imp.g_varchar2_table(47) := '6F6974206974730D0A2020202020202020436F6E747269627574696F6E732C20656974686572206F6E20616E20756E6D6F6469666965642062617369732C2077697468204D6F64696669636174696F6E732C206F722061730D0A20202020202020207061';
wwv_flow_imp.g_varchar2_table(48) := '7274206F662061204C617267657220576F726B3B20616E640D0A0D0A2020202020622E20756E64657220506174656E7420436C61696D73206F66207375636820436F6E7472696275746F7220746F206D616B652C207573652C2073656C6C2C206F666665';
wwv_flow_imp.g_varchar2_table(49) := '7220666F720D0A202020202020202073616C652C2068617665206D6164652C20696D706F72742C20616E64206F7468657277697365207472616E73666572206569746865722069747320436F6E747269627574696F6E730D0A20202020202020206F7220';
wwv_flow_imp.g_varchar2_table(50) := '69747320436F6E7472696275746F722056657273696F6E2E0D0A0D0A322E322E2045666665637469766520446174650D0A0D0A2020202020546865206C6963656E736573206772616E74656420696E2053656374696F6E20322E31207769746820726573';
wwv_flow_imp.g_varchar2_table(51) := '7065637420746F20616E7920436F6E747269627574696F6E206265636F6D650D0A202020202065666665637469766520666F72206561636820436F6E747269627574696F6E206F6E2074686520646174652074686520436F6E7472696275746F72206669';
wwv_flow_imp.g_varchar2_table(52) := '7273742064697374726962757465730D0A20202020207375636820436F6E747269627574696F6E2E0D0A0D0A322E332E204C696D69746174696F6E73206F6E204772616E742053636F70650D0A0D0A2020202020546865206C6963656E73657320677261';
wwv_flow_imp.g_varchar2_table(53) := '6E74656420696E20746869732053656374696F6E20322061726520746865206F6E6C7920726967687473206772616E74656420756E64657220746869730D0A20202020204C6963656E73652E204E6F206164646974696F6E616C20726967687473206F72';
wwv_flow_imp.g_varchar2_table(54) := '206C6963656E7365732077696C6C20626520696D706C6965642066726F6D2074686520646973747269627574696F6E0D0A20202020206F72206C6963656E73696E67206F6620436F766572656420536F66747761726520756E6465722074686973204C69';
wwv_flow_imp.g_varchar2_table(55) := '63656E73652E204E6F74776974687374616E64696E672053656374696F6E0D0A2020202020322E312862292061626F76652C206E6F20706174656E74206C6963656E7365206973206772616E746564206279206120436F6E7472696275746F723A0D0A0D';
wwv_flow_imp.g_varchar2_table(56) := '0A2020202020612E20666F7220616E7920636F64652074686174206120436F6E7472696275746F72206861732072656D6F7665642066726F6D20436F766572656420536F6674776172653B206F720D0A0D0A2020202020622E20666F7220696E6672696E';
wwv_flow_imp.g_varchar2_table(57) := '67656D656E7473206361757365642062793A2028692920596F757220616E6420616E79206F7468657220746869726420706172747992730D0A20202020202020206D6F64696669636174696F6E73206F6620436F766572656420536F6674776172652C20';
wwv_flow_imp.g_varchar2_table(58) := '6F7220286969292074686520636F6D62696E6174696F6E206F66206974730D0A2020202020202020436F6E747269627574696F6E732077697468206F7468657220736F66747761726520286578636570742061732070617274206F662069747320436F6E';
wwv_flow_imp.g_varchar2_table(59) := '7472696275746F720D0A202020202020202056657273696F6E293B206F720D0A0D0A2020202020632E20756E64657220506174656E7420436C61696D7320696E6672696E67656420627920436F766572656420536F66747761726520696E207468652061';
wwv_flow_imp.g_varchar2_table(60) := '6273656E6365206F66206974730D0A2020202020202020436F6E747269627574696F6E732E0D0A0D0A202020202054686973204C6963656E736520646F6573206E6F74206772616E7420616E792072696768747320696E207468652074726164656D6172';
wwv_flow_imp.g_varchar2_table(61) := '6B732C2073657276696365206D61726B732C206F720D0A20202020206C6F676F73206F6620616E7920436F6E7472696275746F722028657863657074206173206D6179206265206E656365737361727920746F20636F6D706C792077697468207468650D';
wwv_flow_imp.g_varchar2_table(62) := '0A20202020206E6F7469636520726571756972656D656E747320696E2053656374696F6E20332E34292E0D0A0D0A322E342E2053756273657175656E74204C6963656E7365730D0A0D0A20202020204E6F20436F6E7472696275746F72206D616B657320';
wwv_flow_imp.g_varchar2_table(63) := '6164646974696F6E616C206772616E7473206173206120726573756C74206F6620596F75722063686F69636520746F0D0A2020202020646973747269627574652074686520436F766572656420536F66747761726520756E646572206120737562736571';
wwv_flow_imp.g_varchar2_table(64) := '75656E742076657273696F6E206F662074686973204C6963656E73650D0A2020202020287365652053656374696F6E2031302E3229206F7220756E64657220746865207465726D73206F662061205365636F6E64617279204C6963656E73652028696620';
wwv_flow_imp.g_varchar2_table(65) := '7065726D69747465640D0A2020202020756E64657220746865207465726D73206F662053656374696F6E20332E33292E0D0A0D0A322E352E20526570726573656E746174696F6E0D0A0D0A20202020204561636820436F6E7472696275746F7220726570';
wwv_flow_imp.g_varchar2_table(66) := '726573656E747320746861742074686520436F6E7472696275746F722062656C69657665732069747320436F6E747269627574696F6E730D0A202020202061726520697473206F726967696E616C206372656174696F6E287329206F7220697420686173';
wwv_flow_imp.g_varchar2_table(67) := '2073756666696369656E742072696768747320746F206772616E74207468650D0A202020202072696768747320746F2069747320436F6E747269627574696F6E7320636F6E76657965642062792074686973204C6963656E73652E0D0A0D0A322E362E20';
wwv_flow_imp.g_varchar2_table(68) := '46616972205573650D0A0D0A202020202054686973204C6963656E7365206973206E6F7420696E74656E64656420746F206C696D697420616E792072696768747320596F75206861766520756E646572206170706C696361626C650D0A2020202020636F';
wwv_flow_imp.g_varchar2_table(69) := '7079726967687420646F637472696E6573206F662066616972207573652C2066616972206465616C696E672C206F72206F74686572206571756976616C656E74732E0D0A0D0A322E372E20436F6E646974696F6E730D0A0D0A202020202053656374696F';
wwv_flow_imp.g_varchar2_table(70) := '6E7320332E312C20332E322C20332E332C20616E6420332E342061726520636F6E646974696F6E73206F6620746865206C6963656E736573206772616E74656420696E0D0A202020202053656374696F6E20322E312E0D0A0D0A0D0A332E20526573706F';
wwv_flow_imp.g_varchar2_table(71) := '6E736962696C69746965730D0A0D0A332E312E20446973747269627574696F6E206F6620536F7572636520466F726D0D0A0D0A2020202020416C6C20646973747269627574696F6E206F6620436F766572656420536F66747761726520696E20536F7572';
wwv_flow_imp.g_varchar2_table(72) := '636520436F646520466F726D2C20696E636C7564696E6720616E790D0A20202020204D6F64696669636174696F6E73207468617420596F7520637265617465206F7220746F20776869636820596F7520636F6E747269627574652C206D75737420626520';
wwv_flow_imp.g_varchar2_table(73) := '756E646572207468650D0A20202020207465726D73206F662074686973204C6963656E73652E20596F75206D75737420696E666F726D20726563697069656E747320746861742074686520536F7572636520436F646520466F726D0D0A20202020206F66';
wwv_flow_imp.g_varchar2_table(74) := '2074686520436F766572656420536F66747761726520697320676F7665726E656420627920746865207465726D73206F662074686973204C6963656E73652C20616E6420686F770D0A2020202020746865792063616E206F627461696E206120636F7079';
wwv_flow_imp.g_varchar2_table(75) := '206F662074686973204C6963656E73652E20596F75206D6179206E6F7420617474656D707420746F20616C746572206F720D0A202020202072657374726963742074686520726563697069656E7473922072696768747320696E2074686520536F757263';
wwv_flow_imp.g_varchar2_table(76) := '6520436F646520466F726D2E0D0A0D0A332E322E20446973747269627574696F6E206F662045786563757461626C6520466F726D0D0A0D0A2020202020496620596F75206469737472696275746520436F766572656420536F66747761726520696E2045';
wwv_flow_imp.g_varchar2_table(77) := '786563757461626C6520466F726D207468656E3A0D0A0D0A2020202020612E207375636820436F766572656420536F667477617265206D75737420616C736F206265206D61646520617661696C61626C6520696E20536F7572636520436F646520466F72';
wwv_flow_imp.g_varchar2_table(78) := '6D2C0D0A202020202020202061732064657363726962656420696E2053656374696F6E20332E312C20616E6420596F75206D75737420696E666F726D20726563697069656E7473206F66207468650D0A202020202020202045786563757461626C652046';
wwv_flow_imp.g_varchar2_table(79) := '6F726D20686F7720746865792063616E206F627461696E206120636F7079206F66207375636820536F7572636520436F646520466F726D2062790D0A2020202020202020726561736F6E61626C65206D65616E7320696E20612074696D656C79206D616E';
wwv_flow_imp.g_varchar2_table(80) := '6E65722C206174206120636861726765206E6F206D6F7265207468616E2074686520636F73740D0A20202020202020206F6620646973747269627574696F6E20746F2074686520726563697069656E743B20616E640D0A0D0A2020202020622E20596F75';
wwv_flow_imp.g_varchar2_table(81) := '206D6179206469737472696275746520737563682045786563757461626C6520466F726D20756E64657220746865207465726D73206F662074686973204C6963656E73652C0D0A20202020202020206F72207375626C6963656E736520697420756E6465';
wwv_flow_imp.g_varchar2_table(82) := '7220646966666572656E74207465726D732C2070726F7669646564207468617420746865206C6963656E736520666F720D0A20202020202020207468652045786563757461626C6520466F726D20646F6573206E6F7420617474656D707420746F206C69';
wwv_flow_imp.g_varchar2_table(83) := '6D6974206F7220616C7465722074686520726563697069656E7473920D0A202020202020202072696768747320696E2074686520536F7572636520436F646520466F726D20756E6465722074686973204C6963656E73652E0D0A0D0A332E332E20446973';
wwv_flow_imp.g_varchar2_table(84) := '747269627574696F6E206F662061204C617267657220576F726B0D0A0D0A2020202020596F75206D61792063726561746520616E6420646973747269627574652061204C617267657220576F726B20756E646572207465726D73206F6620596F75722063';
wwv_flow_imp.g_varchar2_table(85) := '686F6963652C0D0A202020202070726F7669646564207468617420596F7520616C736F20636F6D706C7920776974682074686520726571756972656D656E7473206F662074686973204C6963656E736520666F72207468650D0A2020202020436F766572';
wwv_flow_imp.g_varchar2_table(86) := '656420536F6674776172652E20496620746865204C617267657220576F726B206973206120636F6D62696E6174696F6E206F6620436F766572656420536F6674776172650D0A202020202077697468206120776F726B20676F7665726E6564206279206F';
wwv_flow_imp.g_varchar2_table(87) := '6E65206F72206D6F7265205365636F6E64617279204C6963656E7365732C20616E642074686520436F76657265640D0A2020202020536F667477617265206973206E6F7420496E636F6D70617469626C652057697468205365636F6E64617279204C6963';
wwv_flow_imp.g_varchar2_table(88) := '656E7365732C2074686973204C6963656E7365207065726D6974730D0A2020202020596F7520746F206164646974696F6E616C6C792064697374726962757465207375636820436F766572656420536F66747761726520756E6465722074686520746572';
wwv_flow_imp.g_varchar2_table(89) := '6D73206F660D0A202020202073756368205365636F6E64617279204C6963656E73652873292C20736F20746861742074686520726563697069656E74206F6620746865204C617267657220576F726B206D61792C2061740D0A2020202020746865697220';
wwv_flow_imp.g_varchar2_table(90) := '6F7074696F6E2C206675727468657220646973747269627574652074686520436F766572656420536F66747761726520756E64657220746865207465726D73206F660D0A20202020206569746865722074686973204C6963656E7365206F722073756368';
wwv_flow_imp.g_varchar2_table(91) := '205365636F6E64617279204C6963656E73652873292E0D0A0D0A332E342E204E6F74696365730D0A0D0A2020202020596F75206D6179206E6F742072656D6F7665206F7220616C74657220746865207375627374616E6365206F6620616E79206C696365';
wwv_flow_imp.g_varchar2_table(92) := '6E7365206E6F74696365732028696E636C7564696E670D0A2020202020636F70797269676874206E6F74696365732C20706174656E74206E6F74696365732C20646973636C61696D657273206F662077617272616E74792C206F72206C696D6974617469';
wwv_flow_imp.g_varchar2_table(93) := '6F6E730D0A20202020206F66206C696162696C6974792920636F6E7461696E65642077697468696E2074686520536F7572636520436F646520466F726D206F662074686520436F76657265640D0A2020202020536F6674776172652C2065786365707420';
wwv_flow_imp.g_varchar2_table(94) := '7468617420596F75206D617920616C74657220616E79206C6963656E7365206E6F746963657320746F2074686520657874656E740D0A2020202020726571756972656420746F2072656D656479206B6E6F776E206661637475616C20696E616363757261';
wwv_flow_imp.g_varchar2_table(95) := '636965732E0D0A0D0A332E352E204170706C69636174696F6E206F66204164646974696F6E616C205465726D730D0A0D0A2020202020596F75206D61792063686F6F736520746F206F666665722C20616E6420746F206368617267652061206665652066';
wwv_flow_imp.g_varchar2_table(96) := '6F722C2077617272616E74792C20737570706F72742C0D0A2020202020696E64656D6E697479206F72206C696162696C697479206F626C69676174696F6E7320746F206F6E65206F72206D6F726520726563697069656E7473206F6620436F7665726564';
wwv_flow_imp.g_varchar2_table(97) := '0D0A2020202020536F6674776172652E20486F77657665722C20596F75206D617920646F20736F206F6E6C79206F6E20596F7572206F776E20626568616C662C20616E64206E6F74206F6E20626568616C660D0A20202020206F6620616E7920436F6E74';
wwv_flow_imp.g_varchar2_table(98) := '72696275746F722E20596F75206D757374206D616B65206974206162736F6C7574656C7920636C656172207468617420616E7920737563680D0A202020202077617272616E74792C20737570706F72742C20696E64656D6E6974792C206F72206C696162';
wwv_flow_imp.g_varchar2_table(99) := '696C697479206F626C69676174696F6E206973206F66666572656420627920596F750D0A2020202020616C6F6E652C20616E6420596F752068657265627920616772656520746F20696E64656D6E69667920657665727920436F6E7472696275746F7220';
wwv_flow_imp.g_varchar2_table(100) := '666F7220616E790D0A20202020206C696162696C69747920696E637572726564206279207375636820436F6E7472696275746F72206173206120726573756C74206F662077617272616E74792C20737570706F72742C0D0A2020202020696E64656D6E69';
wwv_flow_imp.g_varchar2_table(101) := '7479206F72206C696162696C697479207465726D7320596F75206F666665722E20596F75206D617920696E636C756465206164646974696F6E616C0D0A2020202020646973636C61696D657273206F662077617272616E747920616E64206C696D697461';
wwv_flow_imp.g_varchar2_table(102) := '74696F6E73206F66206C696162696C69747920737065636966696320746F20616E790D0A20202020206A7572697364696374696F6E2E0D0A0D0A342E20496E6162696C69747920746F20436F6D706C792044756520746F2053746174757465206F722052';
wwv_flow_imp.g_varchar2_table(103) := '6567756C6174696F6E0D0A0D0A202020496620697420697320696D706F737369626C6520666F7220596F7520746F20636F6D706C79207769746820616E79206F6620746865207465726D73206F662074686973204C6963656E73650D0A20202077697468';
wwv_flow_imp.g_varchar2_table(104) := '207265737065637420746F20736F6D65206F7220616C6C206F662074686520436F766572656420536F6674776172652064756520746F20737461747574652C206A7564696369616C0D0A2020206F726465722C206F7220726567756C6174696F6E207468';
wwv_flow_imp.g_varchar2_table(105) := '656E20596F75206D7573743A2028612920636F6D706C79207769746820746865207465726D73206F662074686973204C6963656E73650D0A202020746F20746865206D6178696D756D20657874656E7420706F737369626C653B20616E64202862292064';
wwv_flow_imp.g_varchar2_table(106) := '6573637269626520746865206C696D69746174696F6E7320616E642074686520636F64650D0A20202074686579206166666563742E2053756368206465736372697074696F6E206D75737420626520706C6163656420696E206120746578742066696C65';
wwv_flow_imp.g_varchar2_table(107) := '20696E636C75646564207769746820616C6C0D0A202020646973747269627574696F6E73206F662074686520436F766572656420536F66747761726520756E6465722074686973204C6963656E73652E2045786365707420746F207468650D0A20202065';
wwv_flow_imp.g_varchar2_table(108) := '7874656E742070726F686962697465642062792073746174757465206F7220726567756C6174696F6E2C2073756368206465736372697074696F6E206D7573742062650D0A20202073756666696369656E746C792064657461696C656420666F72206120';
wwv_flow_imp.g_varchar2_table(109) := '726563697069656E74206F66206F7264696E61727920736B696C6C20746F2062652061626C6520746F0D0A202020756E6465727374616E642069742E0D0A0D0A352E205465726D696E6174696F6E0D0A0D0A352E312E2054686520726967687473206772';
wwv_flow_imp.g_varchar2_table(110) := '616E74656420756E6465722074686973204C6963656E73652077696C6C207465726D696E617465206175746F6D61746963616C6C7920696620596F750D0A20202020206661696C20746F20636F6D706C79207769746820616E79206F6620697473207465';
wwv_flow_imp.g_varchar2_table(111) := '726D732E20486F77657665722C20696620596F75206265636F6D6520636F6D706C69616E742C0D0A20202020207468656E2074686520726967687473206772616E74656420756E6465722074686973204C6963656E73652066726F6D2061207061727469';
wwv_flow_imp.g_varchar2_table(112) := '63756C617220436F6E7472696275746F720D0A2020202020617265207265696E737461746564202861292070726F766973696F6E616C6C792C20756E6C65737320616E6420756E74696C207375636820436F6E7472696275746F720D0A20202020206578';
wwv_flow_imp.g_varchar2_table(113) := '706C696369746C7920616E642066696E616C6C79207465726D696E6174657320596F7572206772616E74732C20616E6420286229206F6E20616E206F6E676F696E672062617369732C0D0A20202020206966207375636820436F6E7472696275746F7220';
wwv_flow_imp.g_varchar2_table(114) := '6661696C7320746F206E6F7469667920596F75206F6620746865206E6F6E2D636F6D706C69616E636520627920736F6D650D0A2020202020726561736F6E61626C65206D65616E73207072696F7220746F203630206461797320616674657220596F7520';
wwv_flow_imp.g_varchar2_table(115) := '6861766520636F6D65206261636B20696E746F20636F6D706C69616E63652E0D0A20202020204D6F72656F7665722C20596F7572206772616E74732066726F6D206120706172746963756C617220436F6E7472696275746F7220617265207265696E7374';
wwv_flow_imp.g_varchar2_table(116) := '61746564206F6E20616E0D0A20202020206F6E676F696E67206261736973206966207375636820436F6E7472696275746F72206E6F74696669657320596F75206F6620746865206E6F6E2D636F6D706C69616E63652062790D0A2020202020736F6D6520';
wwv_flow_imp.g_varchar2_table(117) := '726561736F6E61626C65206D65616E732C2074686973206973207468652066697273742074696D6520596F752068617665207265636569766564206E6F74696365206F660D0A20202020206E6F6E2D636F6D706C69616E63652077697468207468697320';
wwv_flow_imp.g_varchar2_table(118) := '4C6963656E73652066726F6D207375636820436F6E7472696275746F722C20616E6420596F75206265636F6D650D0A2020202020636F6D706C69616E74207072696F7220746F203330206461797320616674657220596F75722072656365697074206F66';
wwv_flow_imp.g_varchar2_table(119) := '20746865206E6F746963652E0D0A0D0A352E322E20496620596F7520696E697469617465206C697469676174696F6E20616761696E737420616E7920656E7469747920627920617373657274696E67206120706174656E740D0A2020202020696E667269';
wwv_flow_imp.g_varchar2_table(120) := '6E67656D656E7420636C61696D20286578636C7564696E67206465636C617261746F7279206A7564676D656E7420616374696F6E732C20636F756E7465722D636C61696D732C0D0A2020202020616E642063726F73732D636C61696D732920616C6C6567';
wwv_flow_imp.g_varchar2_table(121) := '696E672074686174206120436F6E7472696275746F722056657273696F6E206469726563746C79206F720D0A2020202020696E6469726563746C7920696E6672696E67657320616E7920706174656E742C207468656E2074686520726967687473206772';
wwv_flow_imp.g_varchar2_table(122) := '616E74656420746F20596F7520627920616E7920616E640D0A2020202020616C6C20436F6E7472696275746F727320666F722074686520436F766572656420536F66747761726520756E6465722053656374696F6E20322E31206F662074686973204C69';
wwv_flow_imp.g_varchar2_table(123) := '63656E73650D0A20202020207368616C6C207465726D696E6174652E0D0A0D0A352E332E20496E20746865206576656E74206F66207465726D696E6174696F6E20756E6465722053656374696F6E7320352E31206F7220352E322061626F76652C20616C';
wwv_flow_imp.g_varchar2_table(124) := '6C20656E6420757365720D0A20202020206C6963656E73652061677265656D656E747320286578636C7564696E67206469737472696275746F727320616E6420726573656C6C657273292077686963682068617665206265656E0D0A202020202076616C';
wwv_flow_imp.g_varchar2_table(125) := '69646C79206772616E74656420627920596F75206F7220596F7572206469737472696275746F727320756E6465722074686973204C6963656E7365207072696F7220746F0D0A20202020207465726D696E6174696F6E207368616C6C2073757276697665';
wwv_flow_imp.g_varchar2_table(126) := '207465726D696E6174696F6E2E0D0A0D0A362E20446973636C61696D6572206F662057617272616E74790D0A0D0A202020436F766572656420536F6674776172652069732070726F766964656420756E6465722074686973204C6963656E7365206F6E20';
wwv_flow_imp.g_varchar2_table(127) := '616E20936173206973942062617369732C20776974686F75740D0A20202077617272616E7479206F6620616E79206B696E642C20656974686572206578707265737365642C20696D706C6965642C206F72207374617475746F72792C20696E636C756469';
wwv_flow_imp.g_varchar2_table(128) := '6E672C0D0A202020776974686F7574206C696D69746174696F6E2C2077617272616E7469657320746861742074686520436F766572656420536F6674776172652069732066726565206F6620646566656374732C0D0A2020206D65726368616E7461626C';
wwv_flow_imp.g_varchar2_table(129) := '652C2066697420666F72206120706172746963756C617220707572706F7365206F72206E6F6E2D696E6672696E67696E672E2054686520656E746972650D0A2020207269736B20617320746F20746865207175616C69747920616E6420706572666F726D';
wwv_flow_imp.g_varchar2_table(130) := '616E6365206F662074686520436F766572656420536F667477617265206973207769746820596F752E0D0A20202053686F756C6420616E7920436F766572656420536F6674776172652070726F76652064656665637469766520696E20616E7920726573';
wwv_flow_imp.g_varchar2_table(131) := '706563742C20596F7520286E6F7420616E790D0A202020436F6E7472696275746F722920617373756D652074686520636F7374206F6620616E79206E656365737361727920736572766963696E672C207265706169722C206F720D0A202020636F727265';
wwv_flow_imp.g_varchar2_table(132) := '6374696F6E2E205468697320646973636C61696D6572206F662077617272616E747920636F6E737469747574657320616E20657373656E7469616C2070617274206F6620746869730D0A2020204C6963656E73652E204E6F20757365206F662020616E79';
wwv_flow_imp.g_varchar2_table(133) := '20436F766572656420536F66747761726520697320617574686F72697A656420756E6465722074686973204C6963656E73650D0A20202065786365707420756E646572207468697320646973636C61696D65722E0D0A0D0A372E204C696D69746174696F';
wwv_flow_imp.g_varchar2_table(134) := '6E206F66204C696162696C6974790D0A0D0A202020556E646572206E6F2063697263756D7374616E63657320616E6420756E646572206E6F206C6567616C207468656F72792C207768657468657220746F72742028696E636C7564696E670D0A2020206E';
wwv_flow_imp.g_varchar2_table(135) := '65676C6967656E6365292C20636F6E74726163742C206F72206F74686572776973652C207368616C6C20616E7920436F6E7472696275746F722C206F7220616E796F6E652077686F0D0A202020646973747269627574657320436F766572656420536F66';
wwv_flow_imp.g_varchar2_table(136) := '7477617265206173207065726D69747465642061626F76652C206265206C6961626C6520746F20596F7520666F7220616E790D0A2020206469726563742C20696E6469726563742C207370656369616C2C20696E636964656E74616C2C206F7220636F6E';
wwv_flow_imp.g_varchar2_table(137) := '73657175656E7469616C2064616D61676573206F6620616E790D0A20202063686172616374657220696E636C7564696E672C20776974686F7574206C696D69746174696F6E2C2064616D6167657320666F72206C6F73742070726F666974732C206C6F73';
wwv_flow_imp.g_varchar2_table(138) := '73206F660D0A202020676F6F6477696C6C2C20776F726B2073746F70706167652C20636F6D7075746572206661696C757265206F72206D616C66756E6374696F6E2C206F7220616E7920616E6420616C6C0D0A2020206F7468657220636F6D6D65726369';
wwv_flow_imp.g_varchar2_table(139) := '616C2064616D61676573206F72206C6F737365732C206576656E2069662073756368207061727479207368616C6C2068617665206265656E0D0A202020696E666F726D6564206F662074686520706F73736962696C697479206F6620737563682064616D';
wwv_flow_imp.g_varchar2_table(140) := '616765732E2054686973206C696D69746174696F6E206F66206C696162696C6974790D0A2020207368616C6C206E6F74206170706C7920746F206C696162696C69747920666F72206465617468206F7220706572736F6E616C20696E6A75727920726573';
wwv_flow_imp.g_varchar2_table(141) := '756C74696E672066726F6D20737563680D0A20202070617274799273206E65676C6967656E636520746F2074686520657874656E74206170706C696361626C65206C61772070726F6869626974732073756368206C696D69746174696F6E2E0D0A202020';
wwv_flow_imp.g_varchar2_table(142) := '536F6D65206A7572697364696374696F6E7320646F206E6F7420616C6C6F7720746865206578636C7573696F6E206F72206C696D69746174696F6E206F6620696E636964656E74616C206F720D0A202020636F6E73657175656E7469616C2064616D6167';
wwv_flow_imp.g_varchar2_table(143) := '65732C20736F2074686973206578636C7573696F6E20616E64206C696D69746174696F6E206D6179206E6F74206170706C7920746F20596F752E0D0A0D0A382E204C697469676174696F6E0D0A0D0A202020416E79206C697469676174696F6E2072656C';
wwv_flow_imp.g_varchar2_table(144) := '6174696E6720746F2074686973204C6963656E7365206D61792062652062726F75676874206F6E6C7920696E2074686520636F75727473206F660D0A20202061206A7572697364696374696F6E2077686572652074686520646566656E64616E74206D61';
wwv_flow_imp.g_varchar2_table(145) := '696E7461696E7320697473207072696E636970616C20706C616365206F6620627573696E6573730D0A202020616E642073756368206C697469676174696F6E207368616C6C20626520676F7665726E6564206279206C617773206F662074686174206A75';
wwv_flow_imp.g_varchar2_table(146) := '72697364696374696F6E2C20776974686F75740D0A2020207265666572656E636520746F2069747320636F6E666C6963742D6F662D6C61772070726F766973696F6E732E204E6F7468696E6720696E20746869732053656374696F6E207368616C6C0D0A';
wwv_flow_imp.g_varchar2_table(147) := '20202070726576656E7420612070617274799273206162696C69747920746F206272696E672063726F73732D636C61696D73206F7220636F756E7465722D636C61696D732E0D0A0D0A392E204D697363656C6C616E656F75730D0A0D0A20202054686973';
wwv_flow_imp.g_varchar2_table(148) := '204C6963656E736520726570726573656E74732074686520636F6D706C6574652061677265656D656E7420636F6E6365726E696E6720746865207375626A656374206D61747465720D0A202020686572656F662E20496620616E792070726F766973696F';
wwv_flow_imp.g_varchar2_table(149) := '6E206F662074686973204C6963656E73652069732068656C6420746F20626520756E656E666F72636561626C652C20737563680D0A20202070726F766973696F6E207368616C6C206265207265666F726D6564206F6E6C7920746F207468652065787465';
wwv_flow_imp.g_varchar2_table(150) := '6E74206E656365737361727920746F206D616B652069740D0A202020656E666F72636561626C652E20416E79206C6177206F7220726567756C6174696F6E2077686963682070726F7669646573207468617420746865206C616E6775616765206F662061';
wwv_flow_imp.g_varchar2_table(151) := '0D0A202020636F6E7472616374207368616C6C20626520636F6E73747275656420616761696E7374207468652064726166746572207368616C6C206E6F74206265207573656420746F20636F6E73747275650D0A20202074686973204C6963656E736520';
wwv_flow_imp.g_varchar2_table(152) := '616761696E7374206120436F6E7472696275746F722E0D0A0D0A0D0A31302E2056657273696F6E73206F6620746865204C6963656E73650D0A0D0A31302E312E204E65772056657273696F6E730D0A0D0A2020202020204D6F7A696C6C6120466F756E64';
wwv_flow_imp.g_varchar2_table(153) := '6174696F6E20697320746865206C6963656E736520737465776172642E204578636570742061732070726F766964656420696E2053656374696F6E0D0A20202020202031302E332C206E6F206F6E65206F74686572207468616E20746865206C6963656E';
wwv_flow_imp.g_varchar2_table(154) := '73652073746577617264206861732074686520726967687420746F206D6F64696679206F720D0A2020202020207075626C697368206E65772076657273696F6E73206F662074686973204C6963656E73652E20456163682076657273696F6E2077696C6C';
wwv_flow_imp.g_varchar2_table(155) := '20626520676976656E20610D0A20202020202064697374696E6775697368696E672076657273696F6E206E756D6265722E0D0A0D0A31302E322E20456666656374206F66204E65772056657273696F6E730D0A0D0A202020202020596F75206D61792064';
wwv_flow_imp.g_varchar2_table(156) := '6973747269627574652074686520436F766572656420536F66747761726520756E64657220746865207465726D73206F66207468652076657273696F6E206F660D0A202020202020746865204C6963656E736520756E64657220776869636820596F7520';
wwv_flow_imp.g_varchar2_table(157) := '6F726967696E616C6C792072656365697665642074686520436F766572656420536F6674776172652C206F720D0A202020202020756E64657220746865207465726D73206F6620616E792073756273657175656E742076657273696F6E207075626C6973';
wwv_flow_imp.g_varchar2_table(158) := '68656420627920746865206C6963656E73650D0A202020202020737465776172642E0D0A0D0A31302E332E204D6F6469666965642056657273696F6E730D0A0D0A202020202020496620796F752063726561746520736F667477617265206E6F7420676F';
wwv_flow_imp.g_varchar2_table(159) := '7665726E65642062792074686973204C6963656E73652C20616E6420796F752077616E7420746F0D0A2020202020206372656174652061206E6577206C6963656E736520666F72207375636820736F6674776172652C20796F75206D6179206372656174';
wwv_flow_imp.g_varchar2_table(160) := '6520616E64207573652061206D6F6469666965640D0A20202020202076657273696F6E206F662074686973204C6963656E736520696620796F752072656E616D6520746865206C6963656E736520616E642072656D6F766520616E790D0A202020202020';
wwv_flow_imp.g_varchar2_table(161) := '7265666572656E63657320746F20746865206E616D65206F6620746865206C6963656E73652073746577617264202865786365707420746F206E6F7465207468617420737563680D0A2020202020206D6F646966696564206C6963656E73652064696666';
wwv_flow_imp.g_varchar2_table(162) := '6572732066726F6D2074686973204C6963656E7365292E0D0A0D0A31302E342E20446973747269627574696E6720536F7572636520436F646520466F726D207468617420697320496E636F6D70617469626C652057697468205365636F6E64617279204C';
wwv_flow_imp.g_varchar2_table(163) := '6963656E7365730D0A202020202020496620596F752063686F6F736520746F206469737472696275746520536F7572636520436F646520466F726D207468617420697320496E636F6D70617469626C6520576974680D0A2020202020205365636F6E6461';
wwv_flow_imp.g_varchar2_table(164) := '7279204C6963656E73657320756E64657220746865207465726D73206F6620746869732076657273696F6E206F6620746865204C6963656E73652C207468650D0A2020202020206E6F746963652064657363726962656420696E20457868696269742042';
wwv_flow_imp.g_varchar2_table(165) := '206F662074686973204C6963656E7365206D7573742062652061747461636865642E0D0A0D0A457868696269742041202D20536F7572636520436F646520466F726D204C6963656E7365204E6F746963650D0A0D0A2020202020205468697320536F7572';
wwv_flow_imp.g_varchar2_table(166) := '636520436F646520466F726D206973207375626A65637420746F207468650D0A2020202020207465726D73206F6620746865204D6F7A696C6C61205075626C6963204C6963656E73652C20762E0D0A202020202020322E302E204966206120636F707920';
wwv_flow_imp.g_varchar2_table(167) := '6F6620746865204D504C20776173206E6F740D0A2020202020206469737472696275746564207769746820746869732066696C652C20596F752063616E0D0A2020202020206F627461696E206F6E652061740D0A202020202020687474703A2F2F6D6F7A';
wwv_flow_imp.g_varchar2_table(168) := '696C6C612E6F72672F4D504C2F322E302F2E0D0A0D0A4966206974206973206E6F7420706F737369626C65206F7220646573697261626C6520746F2070757420746865206E6F7469636520696E206120706172746963756C61722066696C652C20746865';
wwv_flow_imp.g_varchar2_table(169) := '6E0D0A596F75206D617920696E636C75646520746865206E6F7469636520696E2061206C6F636174696F6E2028737563682061732061204C4943454E53452066696C6520696E20612072656C6576616E740D0A6469726563746F72792920776865726520';
wwv_flow_imp.g_varchar2_table(170) := '6120726563697069656E7420776F756C64206265206C696B656C7920746F206C6F6F6B20666F7220737563682061206E6F746963652E0D0A0D0A596F75206D617920616464206164646974696F6E616C206163637572617465206E6F7469636573206F66';
wwv_flow_imp.g_varchar2_table(171) := '20636F70797269676874206F776E6572736869702E0D0A0D0A457868696269742042202D2093496E636F6D70617469626C652057697468205365636F6E64617279204C6963656E73657394204E6F746963650D0A0D0A2020202020205468697320536F75';
wwv_flow_imp.g_varchar2_table(172) := '72636520436F646520466F726D2069732093496E636F6D70617469626C650D0A20202020202057697468205365636F6E64617279204C6963656E736573942C20617320646566696E65642062790D0A202020202020746865204D6F7A696C6C6120507562';
wwv_flow_imp.g_varchar2_table(173) := '6C6963204C6963656E73652C20762E20322E302E0D0A0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(165239410437990815201)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_file_name=>'LICENSE4LIBS'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A2120406C6963656E736520444F4D50757269667920332E302E3130207C202863292043757265353320616E64206F7468657220636F6E7472696275746F7273207C2052656C656173656420756E6465722074686520417061636865206C6963656E73';
wwv_flow_imp.g_varchar2_table(2) := '6520322E3020616E64204D6F7A696C6C61205075626C6963204C6963656E736520322E30207C206769746875622E636F6D2F6375726535332F444F4D5075726966792F626C6F622F332E302E31302F4C4943454E5345202A2F0A2166756E6374696F6E28';
wwv_flow_imp.g_varchar2_table(3) := '652C74297B226F626A656374223D3D747970656F66206578706F727473262622756E646566696E656422213D747970656F66206D6F64756C653F6D6F64756C652E6578706F7274733D7428293A2266756E6374696F6E223D3D747970656F662064656669';
wwv_flow_imp.g_varchar2_table(4) := '6E652626646566696E652E616D643F646566696E652874293A28653D22756E646566696E656422213D747970656F6620676C6F62616C546869733F676C6F62616C546869733A657C7C73656C66292E444F4D5075726966793D7428297D28746869732C28';
wwv_flow_imp.g_varchar2_table(5) := '66756E6374696F6E28297B2275736520737472696374223B636F6E73747B656E74726965733A652C73657450726F746F747970654F663A742C697346726F7A656E3A6E2C67657450726F746F747970654F663A6F2C6765744F776E50726F706572747944';
wwv_flow_imp.g_varchar2_table(6) := '657363726970746F723A727D3D4F626A6563743B6C65747B667265657A653A692C7365616C3A612C6372656174653A6C7D3D4F626A6563742C7B6170706C793A632C636F6E7374727563743A737D3D22756E646566696E656422213D747970656F662052';
wwv_flow_imp.g_varchar2_table(7) := '65666C65637426265265666C6563743B697C7C28693D66756E6374696F6E2865297B72657475726E20657D292C617C7C28613D66756E6374696F6E2865297B72657475726E20657D292C637C7C28633D66756E6374696F6E28652C742C6E297B72657475';
wwv_flow_imp.g_varchar2_table(8) := '726E20652E6170706C7928742C6E297D292C737C7C28733D66756E6374696F6E28652C74297B72657475726E206E65772065282E2E2E74297D293B636F6E737420753D622841727261792E70726F746F747970652E666F7245616368292C6D3D62284172';
wwv_flow_imp.g_varchar2_table(9) := '7261792E70726F746F747970652E706F70292C703D622841727261792E70726F746F747970652E70757368292C663D6228537472696E672E70726F746F747970652E746F4C6F77657243617365292C643D6228537472696E672E70726F746F747970652E';
wwv_flow_imp.g_varchar2_table(10) := '746F537472696E67292C683D6228537472696E672E70726F746F747970652E6D61746368292C673D6228537472696E672E70726F746F747970652E7265706C616365292C543D6228537472696E672E70726F746F747970652E696E6465784F66292C793D';
wwv_flow_imp.g_varchar2_table(11) := '6228537472696E672E70726F746F747970652E7472696D292C453D62284F626A6563742E70726F746F747970652E6861734F776E50726F7065727479292C413D62285265674578702E70726F746F747970652E74657374292C5F3D284E3D547970654572';
wwv_flow_imp.g_varchar2_table(12) := '726F722C66756E6374696F6E28297B666F722876617220653D617267756D656E74732E6C656E6774682C743D6E65772041727261792865292C6E3D303B6E3C653B6E2B2B29745B6E5D3D617267756D656E74735B6E5D3B72657475726E2073284E2C7429';
wwv_flow_imp.g_varchar2_table(13) := '7D293B766172204E3B66756E6374696F6E20622865297B72657475726E2066756E6374696F6E2874297B666F7228766172206E3D617267756D656E74732E6C656E6774682C6F3D6E6577204172726179286E3E313F6E2D313A30292C723D313B723C6E3B';
wwv_flow_imp.g_varchar2_table(14) := '722B2B296F5B722D315D3D617267756D656E74735B725D3B72657475726E206328652C742C6F297D7D66756E6374696F6E205328652C6F297B6C657420723D617267756D656E74732E6C656E6774683E322626766F69642030213D3D617267756D656E74';
wwv_flow_imp.g_varchar2_table(15) := '735B325D3F617267756D656E74735B325D3A663B7426267428652C6E756C6C293B6C657420693D6F2E6C656E6774683B666F72283B692D2D3B297B6C657420743D6F5B695D3B69662822737472696E67223D3D747970656F662074297B636F6E73742065';
wwv_flow_imp.g_varchar2_table(16) := '3D722874293B65213D3D742626286E286F297C7C286F5B695D3D65292C743D65297D655B745D3D21307D72657475726E20657D66756E6374696F6E20522865297B666F72286C657420743D303B743C652E6C656E6774683B742B2B297B4528652C74297C';
wwv_flow_imp.g_varchar2_table(17) := '7C28655B745D3D6E756C6C297D72657475726E20657D66756E6374696F6E20772874297B636F6E7374206E3D6C286E756C6C293B666F7228636F6E73745B6F2C725D6F662065287429297B4528742C6F2926262841727261792E69734172726179287229';
wwv_flow_imp.g_varchar2_table(18) := '3F6E5B6F5D3D522872293A722626226F626A656374223D3D747970656F6620722626722E636F6E7374727563746F723D3D3D4F626A6563743F6E5B6F5D3D772872293A6E5B6F5D3D72297D72657475726E206E7D66756E6374696F6E204C28652C74297B';
wwv_flow_imp.g_varchar2_table(19) := '666F72283B6E756C6C213D3D653B297B636F6E7374206E3D7228652C74293B6966286E297B6966286E2E6765742972657475726E2062286E2E676574293B6966282266756E6374696F6E223D3D747970656F66206E2E76616C75652972657475726E2062';
wwv_flow_imp.g_varchar2_table(20) := '286E2E76616C7565297D653D6F2865297D72657475726E2066756E6374696F6E28297B72657475726E206E756C6C7D7D636F6E737420443D69285B2261222C2261626272222C226163726F6E796D222C2261646472657373222C2261726561222C226172';
wwv_flow_imp.g_varchar2_table(21) := '7469636C65222C226173696465222C22617564696F222C2262222C22626469222C2262646F222C22626967222C22626C696E6B222C22626C6F636B71756F7465222C22626F6479222C226272222C22627574746F6E222C2263616E766173222C22636170';
wwv_flow_imp.g_varchar2_table(22) := '74696F6E222C2263656E746572222C2263697465222C22636F6465222C22636F6C222C22636F6C67726F7570222C22636F6E74656E74222C2264617461222C22646174616C697374222C226464222C226465636F7261746F72222C2264656C222C226465';
wwv_flow_imp.g_varchar2_table(23) := '7461696C73222C2264666E222C226469616C6F67222C22646972222C22646976222C22646C222C226474222C22656C656D656E74222C22656D222C226669656C64736574222C2266696763617074696F6E222C22666967757265222C22666F6E74222C22';
wwv_flow_imp.g_varchar2_table(24) := '666F6F746572222C22666F726D222C226831222C226832222C226833222C226834222C226835222C226836222C2268656164222C22686561646572222C226867726F7570222C226872222C2268746D6C222C2269222C22696D67222C22696E707574222C';
wwv_flow_imp.g_varchar2_table(25) := '22696E73222C226B6264222C226C6162656C222C226C6567656E64222C226C69222C226D61696E222C226D6170222C226D61726B222C226D617271756565222C226D656E75222C226D656E756974656D222C226D65746572222C226E6176222C226E6F62';
wwv_flow_imp.g_varchar2_table(26) := '72222C226F6C222C226F707467726F7570222C226F7074696F6E222C226F7574707574222C2270222C2270696374757265222C22707265222C2270726F6772657373222C2271222C227270222C227274222C2272756279222C2273222C2273616D70222C';
wwv_flow_imp.g_varchar2_table(27) := '2273656374696F6E222C2273656C656374222C22736861646F77222C22736D616C6C222C22736F75726365222C22737061636572222C227370616E222C22737472696B65222C227374726F6E67222C227374796C65222C22737562222C2273756D6D6172';
wwv_flow_imp.g_varchar2_table(28) := '79222C22737570222C227461626C65222C2274626F6479222C227464222C2274656D706C617465222C227465787461726561222C2274666F6F74222C227468222C227468656164222C2274696D65222C227472222C22747261636B222C227474222C2275';
wwv_flow_imp.g_varchar2_table(29) := '222C22756C222C22766172222C22766964656F222C22776272225D292C433D69285B22737667222C2261222C22616C74676C797068222C22616C74676C797068646566222C22616C74676C7970686974656D222C22616E696D617465636F6C6F72222C22';
wwv_flow_imp.g_varchar2_table(30) := '616E696D6174656D6F74696F6E222C22616E696D6174657472616E73666F726D222C22636972636C65222C22636C697070617468222C2264656673222C2264657363222C22656C6C69707365222C2266696C746572222C22666F6E74222C2267222C2267';
wwv_flow_imp.g_varchar2_table(31) := '6C797068222C22676C797068726566222C22686B65726E222C22696D616765222C226C696E65222C226C696E6561726772616469656E74222C226D61726B6572222C226D61736B222C226D65746164617461222C226D70617468222C2270617468222C22';
wwv_flow_imp.g_varchar2_table(32) := '7061747465726E222C22706F6C79676F6E222C22706F6C796C696E65222C2272616469616C6772616469656E74222C2272656374222C2273746F70222C227374796C65222C22737769746368222C2273796D626F6C222C2274657874222C227465787470';
wwv_flow_imp.g_varchar2_table(33) := '617468222C227469746C65222C2274726566222C22747370616E222C2276696577222C22766B65726E225D292C763D69285B226665426C656E64222C226665436F6C6F724D6174726978222C226665436F6D706F6E656E745472616E73666572222C2266';
wwv_flow_imp.g_varchar2_table(34) := '65436F6D706F73697465222C226665436F6E766F6C76654D6174726978222C226665446966667573654C69676874696E67222C226665446973706C6163656D656E744D6170222C22666544697374616E744C69676874222C22666544726F70536861646F';
wwv_flow_imp.g_varchar2_table(35) := '77222C226665466C6F6F64222C22666546756E6341222C22666546756E6342222C22666546756E6347222C22666546756E6352222C226665476175737369616E426C7572222C226665496D616765222C2266654D65726765222C2266654D657267654E6F';
wwv_flow_imp.g_varchar2_table(36) := '6465222C2266654D6F7270686F6C6F6779222C2266654F6666736574222C226665506F696E744C69676874222C22666553706563756C61724C69676874696E67222C22666553706F744C69676874222C22666554696C65222C22666554757262756C656E';
wwv_flow_imp.g_varchar2_table(37) := '6365225D292C783D69285B22616E696D617465222C22636F6C6F722D70726F66696C65222C22637572736F72222C2264697363617264222C22666F6E742D66616365222C22666F6E742D666163652D666F726D6174222C22666F6E742D666163652D6E61';
wwv_flow_imp.g_varchar2_table(38) := '6D65222C22666F6E742D666163652D737263222C22666F6E742D666163652D757269222C22666F726569676E6F626A656374222C226861746368222C22686174636870617468222C226D657368222C226D6573686772616469656E74222C226D65736870';
wwv_flow_imp.g_varchar2_table(39) := '61746368222C226D657368726F77222C226D697373696E672D676C797068222C22736372697074222C22736574222C22736F6C6964636F6C6F72222C22756E6B6E6F776E222C22757365225D292C4F3D69285B226D617468222C226D656E636C6F736522';
wwv_flow_imp.g_varchar2_table(40) := '2C226D6572726F72222C226D66656E636564222C226D66726163222C226D676C797068222C226D69222C226D6C6162656C65647472222C226D6D756C746973637269707473222C226D6E222C226D6F222C226D6F766572222C226D706164646564222C22';
wwv_flow_imp.g_varchar2_table(41) := '6D7068616E746F6D222C226D726F6F74222C226D726F77222C226D73222C226D7370616365222C226D73717274222C226D7374796C65222C226D737562222C226D737570222C226D737562737570222C226D7461626C65222C226D7464222C226D746578';
wwv_flow_imp.g_varchar2_table(42) := '74222C226D7472222C226D756E646572222C226D756E6465726F766572222C226D70726573637269707473225D292C6B3D69285B226D616374696F6E222C226D616C69676E67726F7570222C226D616C69676E6D61726B222C226D6C6F6E67646976222C';
wwv_flow_imp.g_varchar2_table(43) := '226D7363617272696573222C226D736361727279222C226D7367726F7570222C226D737461636B222C226D736C696E65222C226D73726F77222C2273656D616E74696373222C22616E6E6F746174696F6E222C22616E6E6F746174696F6E2D786D6C222C';
wwv_flow_imp.g_varchar2_table(44) := '226D70726573637269707473222C226E6F6E65225D292C4D3D69285B222374657874225D292C493D69285B22616363657074222C22616374696F6E222C22616C69676E222C22616C74222C226175746F6361706974616C697A65222C226175746F636F6D';
wwv_flow_imp.g_varchar2_table(45) := '706C657465222C226175746F70696374757265696E70696374757265222C226175746F706C6179222C226261636B67726F756E64222C226267636F6C6F72222C22626F72646572222C2263617074757265222C2263656C6C70616464696E67222C226365';
wwv_flow_imp.g_varchar2_table(46) := '6C6C73706163696E67222C22636865636B6564222C2263697465222C22636C617373222C22636C656172222C22636F6C6F72222C22636F6C73222C22636F6C7370616E222C22636F6E74726F6C73222C22636F6E74726F6C736C697374222C22636F6F72';
wwv_flow_imp.g_varchar2_table(47) := '6473222C2263726F73736F726967696E222C226461746574696D65222C226465636F64696E67222C2264656661756C74222C22646972222C2264697361626C6564222C2264697361626C6570696374757265696E70696374757265222C2264697361626C';
wwv_flow_imp.g_varchar2_table(48) := '6572656D6F7465706C61796261636B222C22646F776E6C6F6164222C22647261676761626C65222C22656E6374797065222C22656E7465726B657968696E74222C2266616365222C22666F72222C2268656164657273222C22686569676874222C226869';
wwv_flow_imp.g_varchar2_table(49) := '6464656E222C2268696768222C2268726566222C22687265666C616E67222C226964222C22696E7075746D6F6465222C22696E74656772697479222C2269736D6170222C226B696E64222C226C6162656C222C226C616E67222C226C697374222C226C6F';
wwv_flow_imp.g_varchar2_table(50) := '6164696E67222C226C6F6F70222C226C6F77222C226D6178222C226D61786C656E677468222C226D65646961222C226D6574686F64222C226D696E222C226D696E6C656E677468222C226D756C7469706C65222C226D75746564222C226E616D65222C22';
wwv_flow_imp.g_varchar2_table(51) := '6E6F6E6365222C226E6F7368616465222C226E6F76616C6964617465222C226E6F77726170222C226F70656E222C226F7074696D756D222C227061747465726E222C22706C616365686F6C646572222C22706C617973696E6C696E65222C22706F737465';
wwv_flow_imp.g_varchar2_table(52) := '72222C227072656C6F6164222C2270756264617465222C22726164696F67726F7570222C22726561646F6E6C79222C2272656C222C227265717569726564222C22726576222C227265766572736564222C22726F6C65222C22726F7773222C22726F7773';
wwv_flow_imp.g_varchar2_table(53) := '70616E222C227370656C6C636865636B222C2273636F7065222C2273656C6563746564222C227368617065222C2273697A65222C2273697A6573222C227370616E222C227372636C616E67222C227374617274222C22737263222C22737263736574222C';
wwv_flow_imp.g_varchar2_table(54) := '2273746570222C227374796C65222C2273756D6D617279222C22746162696E646578222C227469746C65222C227472616E736C617465222C2274797065222C227573656D6170222C2276616C69676E222C2276616C7565222C227769647468222C22786D';
wwv_flow_imp.g_varchar2_table(55) := '6C6E73222C22736C6F74225D292C553D69285B22616363656E742D686569676874222C22616363756D756C617465222C226164646974697665222C22616C69676E6D656E742D626173656C696E65222C22617363656E74222C226174747269627574656E';
wwv_flow_imp.g_varchar2_table(56) := '616D65222C2261747472696275746574797065222C22617A696D757468222C22626173656672657175656E6379222C22626173656C696E652D7368696674222C22626567696E222C2262696173222C226279222C22636C617373222C22636C6970222C22';
wwv_flow_imp.g_varchar2_table(57) := '636C697070617468756E697473222C22636C69702D70617468222C22636C69702D72756C65222C22636F6C6F72222C22636F6C6F722D696E746572706F6C6174696F6E222C22636F6C6F722D696E746572706F6C6174696F6E2D66696C74657273222C22';
wwv_flow_imp.g_varchar2_table(58) := '636F6C6F722D70726F66696C65222C22636F6C6F722D72656E646572696E67222C226378222C226379222C2264222C226478222C226479222C2264696666757365636F6E7374616E74222C22646972656374696F6E222C22646973706C6179222C226469';
wwv_flow_imp.g_varchar2_table(59) := '7669736F72222C22647572222C22656467656D6F6465222C22656C65766174696F6E222C22656E64222C2266696C6C222C2266696C6C2D6F706163697479222C2266696C6C2D72756C65222C2266696C746572222C2266696C746572756E697473222C22';
wwv_flow_imp.g_varchar2_table(60) := '666C6F6F642D636F6C6F72222C22666C6F6F642D6F706163697479222C22666F6E742D66616D696C79222C22666F6E742D73697A65222C22666F6E742D73697A652D61646A757374222C22666F6E742D73747265746368222C22666F6E742D7374796C65';
wwv_flow_imp.g_varchar2_table(61) := '222C22666F6E742D76617269616E74222C22666F6E742D776569676874222C226678222C226679222C226731222C226732222C22676C7970682D6E616D65222C22676C797068726566222C226772616469656E74756E697473222C226772616469656E74';
wwv_flow_imp.g_varchar2_table(62) := '7472616E73666F726D222C22686569676874222C2268726566222C226964222C22696D6167652D72656E646572696E67222C22696E222C22696E32222C226B222C226B31222C226B32222C226B33222C226B34222C226B65726E696E67222C226B657970';
wwv_flow_imp.g_varchar2_table(63) := '6F696E7473222C226B657973706C696E6573222C226B657974696D6573222C226C616E67222C226C656E67746861646A757374222C226C65747465722D73706163696E67222C226B65726E656C6D6174726978222C226B65726E656C756E69746C656E67';
wwv_flow_imp.g_varchar2_table(64) := '7468222C226C69676874696E672D636F6C6F72222C226C6F63616C222C226D61726B65722D656E64222C226D61726B65722D6D6964222C226D61726B65722D7374617274222C226D61726B6572686569676874222C226D61726B6572756E697473222C22';
wwv_flow_imp.g_varchar2_table(65) := '6D61726B65727769647468222C226D61736B636F6E74656E74756E697473222C226D61736B756E697473222C226D6178222C226D61736B222C226D65646961222C226D6574686F64222C226D6F6465222C226D696E222C226E616D65222C226E756D6F63';
wwv_flow_imp.g_varchar2_table(66) := '7461766573222C226F6666736574222C226F70657261746F72222C226F706163697479222C226F72646572222C226F7269656E74222C226F7269656E746174696F6E222C226F726967696E222C226F766572666C6F77222C227061696E742D6F72646572';
wwv_flow_imp.g_varchar2_table(67) := '222C2270617468222C22706174686C656E677468222C227061747465726E636F6E74656E74756E697473222C227061747465726E7472616E73666F726D222C227061747465726E756E697473222C22706F696E7473222C227072657365727665616C7068';
wwv_flow_imp.g_varchar2_table(68) := '61222C227072657365727665617370656374726174696F222C227072696D6974697665756E697473222C2272222C227278222C227279222C22726164697573222C2272656678222C2272656679222C22726570656174636F756E74222C22726570656174';
wwv_flow_imp.g_varchar2_table(69) := '647572222C2272657374617274222C22726573756C74222C22726F74617465222C227363616C65222C2273656564222C2273686170652D72656E646572696E67222C2273706563756C6172636F6E7374616E74222C2273706563756C61726578706F6E65';
wwv_flow_imp.g_varchar2_table(70) := '6E74222C227370726561646D6574686F64222C2273746172746F6666736574222C22737464646576696174696F6E222C2273746974636874696C6573222C2273746F702D636F6C6F72222C2273746F702D6F706163697479222C227374726F6B652D6461';
wwv_flow_imp.g_varchar2_table(71) := '73686172726179222C227374726F6B652D646173686F6666736574222C227374726F6B652D6C696E65636170222C227374726F6B652D6C696E656A6F696E222C227374726F6B652D6D697465726C696D6974222C227374726F6B652D6F70616369747922';
wwv_flow_imp.g_varchar2_table(72) := '2C227374726F6B65222C227374726F6B652D7769647468222C227374796C65222C22737572666163657363616C65222C2273797374656D6C616E6775616765222C22746162696E646578222C2274617267657478222C2274617267657479222C22747261';
wwv_flow_imp.g_varchar2_table(73) := '6E73666F726D222C227472616E73666F726D2D6F726967696E222C22746578742D616E63686F72222C22746578742D6465636F726174696F6E222C22746578742D72656E646572696E67222C22746578746C656E677468222C2274797065222C22753122';
wwv_flow_imp.g_varchar2_table(74) := '2C227532222C22756E69636F6465222C2276616C756573222C2276696577626F78222C227669736962696C697479222C2276657273696F6E222C22766572742D6164762D79222C22766572742D6F726967696E2D78222C22766572742D6F726967696E2D';
wwv_flow_imp.g_varchar2_table(75) := '79222C227769647468222C22776F72642D73706163696E67222C2277726170222C2277726974696E672D6D6F6465222C22786368616E6E656C73656C6563746F72222C22796368616E6E656C73656C6563746F72222C2278222C227831222C227832222C';
wwv_flow_imp.g_varchar2_table(76) := '22786D6C6E73222C2279222C227931222C227932222C227A222C227A6F6F6D616E6470616E225D292C503D69285B22616363656E74222C22616363656E74756E646572222C22616C69676E222C22626576656C6C6564222C22636C6F7365222C22636F6C';
wwv_flow_imp.g_varchar2_table(77) := '756D6E73616C69676E222C22636F6C756D6E6C696E6573222C22636F6C756D6E7370616E222C2264656E6F6D616C69676E222C226465707468222C22646972222C22646973706C6179222C22646973706C61797374796C65222C22656E636F64696E6722';
wwv_flow_imp.g_varchar2_table(78) := '2C2266656E6365222C226672616D65222C22686569676874222C2268726566222C226964222C226C617267656F70222C226C656E677468222C226C696E65746869636B6E657373222C226C7370616365222C226C71756F7465222C226D6174686261636B';
wwv_flow_imp.g_varchar2_table(79) := '67726F756E64222C226D617468636F6C6F72222C226D61746873697A65222C226D61746876617269616E74222C226D617873697A65222C226D696E73697A65222C226D6F7661626C656C696D697473222C226E6F746174696F6E222C226E756D616C6967';
wwv_flow_imp.g_varchar2_table(80) := '6E222C226F70656E222C22726F77616C69676E222C22726F776C696E6573222C22726F7773706163696E67222C22726F777370616E222C22727370616365222C227271756F7465222C227363726970746C6576656C222C227363726970746D696E73697A';
wwv_flow_imp.g_varchar2_table(81) := '65222C2273637269707473697A656D756C7469706C696572222C2273656C656374696F6E222C22736570617261746F72222C22736570617261746F7273222C227374726574636879222C227375627363726970747368696674222C227375707363726970';
wwv_flow_imp.g_varchar2_table(82) := '747368696674222C2273796D6D6574726963222C22766F6666736574222C227769647468222C22786D6C6E73225D292C483D69285B22786C696E6B3A68726566222C22786D6C3A6964222C22786C696E6B3A7469746C65222C22786D6C3A737061636522';
wwv_flow_imp.g_varchar2_table(83) := '2C22786D6C6E733A786C696E6B225D292C463D61282F5C7B5C7B5B5C775C575D2A7C5B5C775C575D2A5C7D5C7D2F676D292C7A3D61282F3C255B5C775C575D2A7C5B5C775C575D2A253E2F676D292C423D61282F5C247B5B5C775C575D2A7D2F676D292C';
wwv_flow_imp.g_varchar2_table(84) := '573D61282F5E646174612D5B5C2D5C772E5C75303042372D5C75464646465D2F292C473D61282F5E617269612D5B5C2D5C775D2B242F292C593D61282F5E283F3A283F3A283F3A667C6874297470733F7C6D61696C746F7C74656C7C63616C6C746F7C73';
wwv_flow_imp.g_varchar2_table(85) := '6D737C6369647C786D7070293A7C5B5E612D7A5D7C5B612D7A2B2E5C2D5D2B283F3A5B5E612D7A2B2E5C2D3A5D7C2429292F69292C6A3D61282F5E283F3A5C772B7363726970747C64617461293A2F69292C713D61282F5B5C75303030302D5C75303032';
wwv_flow_imp.g_varchar2_table(86) := '305C75303041305C75313638305C75313830455C75323030302D5C75323032395C75323035465C75333030305D2F67292C583D61282F5E68746D6C242F69292C243D61282F5E5B612D7A5D5B612D7A5C645D2A282D5B612D7A5C645D2B292B242F69293B';
wwv_flow_imp.g_varchar2_table(87) := '766172204B3D4F626A6563742E667265657A65287B5F5F70726F746F5F5F3A6E756C6C2C4D555354414348455F455850523A462C4552425F455850523A7A2C544D504C49545F455850523A422C444154415F415454523A572C415249415F415454523A47';
wwv_flow_imp.g_varchar2_table(88) := '2C49535F414C4C4F5745445F5552493A592C49535F5343524950545F4F525F444154413A6A2C415454525F574849544553504143453A712C444F43545950455F4E414D453A582C435553544F4D5F454C454D454E543A247D293B636F6E737420563D6675';
wwv_flow_imp.g_varchar2_table(89) := '6E6374696F6E28297B72657475726E22756E646566696E6564223D3D747970656F662077696E646F773F6E756C6C3A77696E646F777D3B766172205A3D66756E6374696F6E207428297B6C6574206E3D617267756D656E74732E6C656E6774683E302626';
wwv_flow_imp.g_varchar2_table(90) := '766F69642030213D3D617267756D656E74735B305D3F617267756D656E74735B305D3A5628293B636F6E7374206F3D653D3E742865293B6966286F2E76657273696F6E3D22332E302E3130222C6F2E72656D6F7665643D5B5D2C216E7C7C216E2E646F63';
wwv_flow_imp.g_varchar2_table(91) := '756D656E747C7C39213D3D6E2E646F63756D656E742E6E6F6465547970652972657475726E206F2E6973537570706F727465643D21312C6F3B6C65747B646F63756D656E743A727D3D6E3B636F6E737420613D722C633D612E63757272656E7453637269';
wwv_flow_imp.g_varchar2_table(92) := '70742C7B446F63756D656E74467261676D656E743A732C48544D4C54656D706C617465456C656D656E743A4E2C4E6F64653A622C456C656D656E743A522C4E6F646546696C7465723A462C4E616D65644E6F64654D61703A7A3D6E2E4E616D65644E6F64';
wwv_flow_imp.g_varchar2_table(93) := '654D61707C7C6E2E4D6F7A4E616D6564417474724D61702C48544D4C466F726D456C656D656E743A422C444F4D5061727365723A572C7472757374656454797065733A477D3D6E2C6A3D522E70726F746F747970652C713D4C286A2C22636C6F6E654E6F';
wwv_flow_imp.g_varchar2_table(94) := '646522292C243D4C286A2C226E6578745369626C696E6722292C5A3D4C286A2C226368696C644E6F64657322292C4A3D4C286A2C22706172656E744E6F646522293B6966282266756E6374696F6E223D3D747970656F66204E297B636F6E737420653D72';
wwv_flow_imp.g_varchar2_table(95) := '2E637265617465456C656D656E74282274656D706C61746522293B652E636F6E74656E742626652E636F6E74656E742E6F776E6572446F63756D656E74262628723D652E636F6E74656E742E6F776E6572446F63756D656E74297D6C657420512C65653D';
wwv_flow_imp.g_varchar2_table(96) := '22223B636F6E73747B696D706C656D656E746174696F6E3A74652C6372656174654E6F64654974657261746F723A6E652C637265617465446F63756D656E74467261676D656E743A6F652C676574456C656D656E747342795461674E616D653A72657D3D';
wwv_flow_imp.g_varchar2_table(97) := '722C7B696D706F72744E6F64653A69657D3D613B6C65742061653D7B7D3B6F2E6973537570706F727465643D2266756E6374696F6E223D3D747970656F66206526262266756E6374696F6E223D3D747970656F66204A262674652626766F69642030213D';
wwv_flow_imp.g_varchar2_table(98) := '3D74652E63726561746548544D4C446F63756D656E743B636F6E73747B4D555354414348455F455850523A6C652C4552425F455850523A63652C544D504C49545F455850523A73652C444154415F415454523A75652C415249415F415454523A6D652C49';
wwv_flow_imp.g_varchar2_table(99) := '535F5343524950545F4F525F444154413A70652C415454525F574849544553504143453A66652C435553544F4D5F454C454D454E543A64657D3D4B3B6C65747B49535F414C4C4F5745445F5552493A68657D3D4B2C67653D6E756C6C3B636F6E73742054';
wwv_flow_imp.g_varchar2_table(100) := '653D53287B7D2C5B2E2E2E442C2E2E2E432C2E2E2E762C2E2E2E4F2C2E2E2E4D5D293B6C65742079653D6E756C6C3B636F6E73742045653D53287B7D2C5B2E2E2E492C2E2E2E552C2E2E2E502C2E2E2E485D293B6C65742041653D4F626A6563742E7365';
wwv_flow_imp.g_varchar2_table(101) := '616C286C286E756C6C2C7B7461674E616D65436865636B3A7B7772697461626C653A21302C636F6E666967757261626C653A21312C656E756D657261626C653A21302C76616C75653A6E756C6C7D2C6174747269627574654E616D65436865636B3A7B77';
wwv_flow_imp.g_varchar2_table(102) := '72697461626C653A21302C636F6E666967757261626C653A21312C656E756D657261626C653A21302C76616C75653A6E756C6C7D2C616C6C6F77437573746F6D697A65644275696C74496E456C656D656E74733A7B7772697461626C653A21302C636F6E';
wwv_flow_imp.g_varchar2_table(103) := '666967757261626C653A21312C656E756D657261626C653A21302C76616C75653A21317D7D29292C5F653D6E756C6C2C4E653D6E756C6C2C62653D21302C53653D21302C52653D21312C77653D21302C4C653D21312C44653D21312C43653D21312C7665';
wwv_flow_imp.g_varchar2_table(104) := '3D21312C78653D21312C4F653D21312C6B653D21312C4D653D21302C49653D21312C55653D21302C50653D21312C48653D7B7D2C46653D6E756C6C3B636F6E7374207A653D53287B7D2C5B22616E6E6F746174696F6E2D786D6C222C22617564696F222C';
wwv_flow_imp.g_varchar2_table(105) := '22636F6C67726F7570222C2264657363222C22666F726569676E6F626A656374222C2268656164222C22696672616D65222C226D617468222C226D69222C226D6E222C226D6F222C226D73222C226D74657874222C226E6F656D626564222C226E6F6672';
wwv_flow_imp.g_varchar2_table(106) := '616D6573222C226E6F736372697074222C22706C61696E74657874222C22736372697074222C227374796C65222C22737667222C2274656D706C617465222C227468656164222C227469746C65222C22766964656F222C22786D70225D293B6C65742042';
wwv_flow_imp.g_varchar2_table(107) := '653D6E756C6C3B636F6E73742057653D53287B7D2C5B22617564696F222C22766964656F222C22696D67222C22736F75726365222C22696D616765222C22747261636B225D293B6C65742047653D6E756C6C3B636F6E73742059653D53287B7D2C5B2261';
wwv_flow_imp.g_varchar2_table(108) := '6C74222C22636C617373222C22666F72222C226964222C226C6162656C222C226E616D65222C227061747465726E222C22706C616365686F6C646572222C22726F6C65222C2273756D6D617279222C227469746C65222C2276616C7565222C227374796C';
wwv_flow_imp.g_varchar2_table(109) := '65222C22786D6C6E73225D292C6A653D22687474703A2F2F7777772E77332E6F72672F313939382F4D6174682F4D6174684D4C222C71653D22687474703A2F2F7777772E77332E6F72672F323030302F737667222C58653D22687474703A2F2F7777772E';
wwv_flow_imp.g_varchar2_table(110) := '77332E6F72672F313939392F7868746D6C223B6C65742024653D58652C4B653D21312C56653D6E756C6C3B636F6E7374205A653D53287B7D2C5B6A652C71652C58655D2C64293B6C6574204A653D6E756C6C3B636F6E73742051653D5B226170706C6963';
wwv_flow_imp.g_varchar2_table(111) := '6174696F6E2F7868746D6C2B786D6C222C22746578742F68746D6C225D3B6C65742065743D6E756C6C2C74743D6E756C6C3B636F6E7374206E743D722E637265617465456C656D656E742822666F726D22292C6F743D66756E6374696F6E2865297B7265';
wwv_flow_imp.g_varchar2_table(112) := '7475726E206520696E7374616E63656F66205265674578707C7C6520696E7374616E63656F662046756E6374696F6E7D2C72743D66756E6374696F6E28297B6C657420653D617267756D656E74732E6C656E6774683E302626766F69642030213D3D6172';
wwv_flow_imp.g_varchar2_table(113) := '67756D656E74735B305D3F617267756D656E74735B305D3A7B7D3B6966282174747C7C7474213D3D65297B696628652626226F626A656374223D3D747970656F6620657C7C28653D7B7D292C653D772865292C4A653D2D313D3D3D51652E696E6465784F';
wwv_flow_imp.g_varchar2_table(114) := '6628652E5041525345525F4D454449415F54595045293F22746578742F68746D6C223A652E5041525345525F4D454449415F545950452C65743D226170706C69636174696F6E2F7868746D6C2B786D6C223D3D3D4A653F643A662C67653D4528652C2241';
wwv_flow_imp.g_varchar2_table(115) := '4C4C4F5745445F5441475322293F53287B7D2C652E414C4C4F5745445F544147532C6574293A54652C79653D4528652C22414C4C4F5745445F4154545222293F53287B7D2C652E414C4C4F5745445F415454522C6574293A45652C56653D4528652C2241';
wwv_flow_imp.g_varchar2_table(116) := '4C4C4F5745445F4E414D4553504143455322293F53287B7D2C652E414C4C4F5745445F4E414D455350414345532C64293A5A652C47653D4528652C224144445F5552495F534146455F4154545222293F532877285965292C652E4144445F5552495F5341';
wwv_flow_imp.g_varchar2_table(117) := '46455F415454522C6574293A59652C42653D4528652C224144445F444154415F5552495F5441475322293F532877285765292C652E4144445F444154415F5552495F544147532C6574293A57652C46653D4528652C22464F524249445F434F4E54454E54';
wwv_flow_imp.g_varchar2_table(118) := '5322293F53287B7D2C652E464F524249445F434F4E54454E54532C6574293A7A652C5F653D4528652C22464F524249445F5441475322293F53287B7D2C652E464F524249445F544147532C6574293A7B7D2C4E653D4528652C22464F524249445F415454';
wwv_flow_imp.g_varchar2_table(119) := '5222293F53287B7D2C652E464F524249445F415454522C6574293A7B7D2C48653D21214528652C225553455F50524F46494C455322292626652E5553455F50524F46494C45532C62653D2131213D3D652E414C4C4F575F415249415F415454522C53653D';
wwv_flow_imp.g_varchar2_table(120) := '2131213D3D652E414C4C4F575F444154415F415454522C52653D652E414C4C4F575F554E4B4E4F574E5F50524F544F434F4C537C7C21312C77653D2131213D3D652E414C4C4F575F53454C465F434C4F53455F494E5F415454522C4C653D652E53414645';
wwv_flow_imp.g_varchar2_table(121) := '5F464F525F54454D504C415445537C7C21312C44653D652E57484F4C455F444F43554D454E547C7C21312C78653D652E52455455524E5F444F4D7C7C21312C4F653D652E52455455524E5F444F4D5F465241474D454E547C7C21312C6B653D652E524554';
wwv_flow_imp.g_varchar2_table(122) := '55524E5F545255535445445F545950457C7C21312C76653D652E464F5243455F424F44597C7C21312C4D653D2131213D3D652E53414E4954495A455F444F4D2C49653D652E53414E4954495A455F4E414D45445F50524F50537C7C21312C55653D213121';
wwv_flow_imp.g_varchar2_table(123) := '3D3D652E4B4545505F434F4E54454E542C50653D652E494E5F504C4143457C7C21312C68653D652E414C4C4F5745445F5552495F5245474558507C7C592C24653D652E4E414D4553504143457C7C58652C41653D652E435553544F4D5F454C454D454E54';
wwv_flow_imp.g_varchar2_table(124) := '5F48414E444C494E477C7C7B7D2C652E435553544F4D5F454C454D454E545F48414E444C494E4726266F7428652E435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B2926262841652E7461674E616D6543686563';
wwv_flow_imp.g_varchar2_table(125) := '6B3D652E435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B292C652E435553544F4D5F454C454D454E545F48414E444C494E4726266F7428652E435553544F4D5F454C454D454E545F48414E444C494E472E6174';
wwv_flow_imp.g_varchar2_table(126) := '747269627574654E616D65436865636B2926262841652E6174747269627574654E616D65436865636B3D652E435553544F4D5F454C454D454E545F48414E444C494E472E6174747269627574654E616D65436865636B292C652E435553544F4D5F454C45';
wwv_flow_imp.g_varchar2_table(127) := '4D454E545F48414E444C494E47262622626F6F6C65616E223D3D747970656F6620652E435553544F4D5F454C454D454E545F48414E444C494E472E616C6C6F77437573746F6D697A65644275696C74496E456C656D656E747326262841652E616C6C6F77';
wwv_flow_imp.g_varchar2_table(128) := '437573746F6D697A65644275696C74496E456C656D656E74733D652E435553544F4D5F454C454D454E545F48414E444C494E472E616C6C6F77437573746F6D697A65644275696C74496E456C656D656E7473292C4C6526262853653D2131292C4F652626';
wwv_flow_imp.g_varchar2_table(129) := '2878653D2130292C486526262867653D53287B7D2C4D292C79653D5B5D2C21303D3D3D48652E68746D6C262628532867652C44292C532879652C4929292C21303D3D3D48652E737667262628532867652C43292C532879652C55292C532879652C482929';
wwv_flow_imp.g_varchar2_table(130) := '2C21303D3D3D48652E73766746696C74657273262628532867652C76292C532879652C55292C532879652C4829292C21303D3D3D48652E6D6174684D6C262628532867652C4F292C532879652C50292C532879652C482929292C652E4144445F54414753';
wwv_flow_imp.g_varchar2_table(131) := '26262867653D3D3D546526262867653D7728676529292C532867652C652E4144445F544147532C657429292C652E4144445F4154545226262879653D3D3D456526262879653D7728796529292C532879652C652E4144445F415454522C657429292C652E';
wwv_flow_imp.g_varchar2_table(132) := '4144445F5552495F534146455F415454522626532847652C652E4144445F5552495F534146455F415454522C6574292C652E464F524249445F434F4E54454E545326262846653D3D3D7A6526262846653D7728466529292C532846652C652E464F524249';
wwv_flow_imp.g_varchar2_table(133) := '445F434F4E54454E54532C657429292C556526262867655B222374657874225D3D2130292C44652626532867652C5B2268746D6C222C2268656164222C22626F6479225D292C67652E7461626C65262628532867652C5B2274626F6479225D292C64656C';
wwv_flow_imp.g_varchar2_table(134) := '657465205F652E74626F6479292C652E545255535445445F54595045535F504F4C494359297B6966282266756E6374696F6E22213D747970656F6620652E545255535445445F54595045535F504F4C4943592E63726561746548544D4C297468726F7720';
wwv_flow_imp.g_varchar2_table(135) := '5F2827545255535445445F54595045535F504F4C49435920636F6E66696775726174696F6E206F7074696F6E206D7573742070726F766964652061202263726561746548544D4C2220686F6F6B2E27293B6966282266756E6374696F6E22213D74797065';
wwv_flow_imp.g_varchar2_table(136) := '6F6620652E545255535445445F54595045535F504F4C4943592E63726561746553637269707455524C297468726F77205F2827545255535445445F54595045535F504F4C49435920636F6E66696775726174696F6E206F7074696F6E206D757374207072';
wwv_flow_imp.g_varchar2_table(137) := '6F766964652061202263726561746553637269707455524C2220686F6F6B2E27293B513D652E545255535445445F54595045535F504F4C4943592C65653D512E63726561746548544D4C282222297D656C736520766F696420303D3D3D51262628513D66';
wwv_flow_imp.g_varchar2_table(138) := '756E6374696F6E28652C74297B696628226F626A65637422213D747970656F6620657C7C2266756E6374696F6E22213D747970656F6620652E637265617465506F6C6963792972657475726E206E756C6C3B6C6574206E3D6E756C6C3B636F6E7374206F';
wwv_flow_imp.g_varchar2_table(139) := '3D22646174612D74742D706F6C6963792D737566666978223B742626742E686173417474726962757465286F292626286E3D742E676574417474726962757465286F29293B636F6E737420723D22646F6D707572696679222B286E3F2223222B6E3A2222';
wwv_flow_imp.g_varchar2_table(140) := '293B7472797B72657475726E20652E637265617465506F6C69637928722C7B63726561746548544D4C3A653D3E652C63726561746553637269707455524C3A653D3E657D297D63617463682865297B72657475726E20636F6E736F6C652E7761726E2822';
wwv_flow_imp.g_varchar2_table(141) := '54727573746564547970657320706F6C69637920222B722B2220636F756C64206E6F7420626520637265617465642E22292C6E756C6C7D7D28472C6329292C6E756C6C213D3D51262622737472696E67223D3D747970656F6620656526262865653D512E';
wwv_flow_imp.g_varchar2_table(142) := '63726561746548544D4C28222229293B692626692865292C74743D657D7D2C69743D53287B7D2C5B226D69222C226D6F222C226D6E222C226D73222C226D74657874225D292C61743D53287B7D2C5B22666F726569676E6F626A656374222C2264657363';
wwv_flow_imp.g_varchar2_table(143) := '222C227469746C65222C22616E6E6F746174696F6E2D786D6C225D292C6C743D53287B7D2C5B227469746C65222C227374796C65222C22666F6E74222C2261222C22736372697074225D292C63743D53287B7D2C5B2E2E2E432C2E2E2E762C2E2E2E785D';
wwv_flow_imp.g_varchar2_table(144) := '292C73743D53287B7D2C5B2E2E2E4F2C2E2E2E6B5D292C75743D66756E6374696F6E2865297B70286F2E72656D6F7665642C7B656C656D656E743A657D293B7472797B652E706172656E744E6F64652E72656D6F76654368696C642865297D6361746368';
wwv_flow_imp.g_varchar2_table(145) := '2874297B652E72656D6F766528297D7D2C6D743D66756E6374696F6E28652C74297B7472797B70286F2E72656D6F7665642C7B6174747269627574653A742E6765744174747269627574654E6F64652865292C66726F6D3A747D297D6361746368286529';
wwv_flow_imp.g_varchar2_table(146) := '7B70286F2E72656D6F7665642C7B6174747269627574653A6E756C6C2C66726F6D3A747D297D696628742E72656D6F76654174747269627574652865292C226973223D3D3D6526262179655B655D2969662878657C7C4F65297472797B75742874297D63';
wwv_flow_imp.g_varchar2_table(147) := '617463682865297B7D656C7365207472797B742E73657441747472696275746528652C2222297D63617463682865297B7D7D2C70743D66756E6374696F6E2865297B6C657420743D6E756C6C2C6E3D6E756C6C3B696628766529653D223C72656D6F7665';
wwv_flow_imp.g_varchar2_table(148) := '3E3C2F72656D6F76653E222B653B656C73657B636F6E737420743D6828652C2F5E5B5C725C6E5C74205D2B2F293B6E3D742626745B305D7D226170706C69636174696F6E2F7868746D6C2B786D6C223D3D3D4A65262624653D3D3D5865262628653D273C';
wwv_flow_imp.g_varchar2_table(149) := '68746D6C20786D6C6E733D22687474703A2F2F7777772E77332E6F72672F313939392F7868746D6C223E3C686561643E3C2F686561643E3C626F64793E272B652B223C2F626F64793E3C2F68746D6C3E22293B636F6E7374206F3D513F512E6372656174';
wwv_flow_imp.g_varchar2_table(150) := '6548544D4C2865293A653B69662824653D3D3D5865297472797B743D286E65772057292E706172736546726F6D537472696E67286F2C4A65297D63617463682865297B7D69662821747C7C21742E646F63756D656E74456C656D656E74297B743D74652E';
wwv_flow_imp.g_varchar2_table(151) := '637265617465446F63756D656E742824652C2274656D706C617465222C6E756C6C293B7472797B742E646F63756D656E74456C656D656E742E696E6E657248544D4C3D4B653F65653A6F7D63617463682865297B7D7D636F6E737420693D742E626F6479';
wwv_flow_imp.g_varchar2_table(152) := '7C7C742E646F63756D656E74456C656D656E743B72657475726E206526266E2626692E696E736572744265666F726528722E637265617465546578744E6F6465286E292C692E6368696C644E6F6465735B305D7C7C6E756C6C292C24653D3D3D58653F72';
wwv_flow_imp.g_varchar2_table(153) := '652E63616C6C28742C44653F2268746D6C223A22626F647922295B305D3A44653F742E646F63756D656E74456C656D656E743A697D2C66743D66756E6374696F6E2865297B72657475726E206E652E63616C6C28652E6F776E6572446F63756D656E747C';
wwv_flow_imp.g_varchar2_table(154) := '7C652C652C462E53484F575F454C454D454E547C462E53484F575F434F4D4D454E547C462E53484F575F544558547C462E53484F575F50524F43455353494E475F494E535452554354494F4E2C6E756C6C297D2C64743D66756E6374696F6E2865297B72';
wwv_flow_imp.g_varchar2_table(155) := '657475726E2266756E6374696F6E223D3D747970656F66206226266520696E7374616E63656F6620627D2C68743D66756E6374696F6E28652C742C6E297B61655B655D2626752861655B655D2C28653D3E7B652E63616C6C286F2C742C6E2C7474297D29';
wwv_flow_imp.g_varchar2_table(156) := '297D2C67743D66756E6374696F6E2865297B6C657420743D6E756C6C3B696628687428226265666F726553616E6974697A65456C656D656E7473222C652C6E756C6C292C286E3D6529696E7374616E63656F66204226262822737472696E6722213D7479';
wwv_flow_imp.g_varchar2_table(157) := '70656F66206E2E6E6F64654E616D657C7C22737472696E6722213D747970656F66206E2E74657874436F6E74656E747C7C2266756E6374696F6E22213D747970656F66206E2E72656D6F76654368696C647C7C21286E2E6174747269627574657320696E';
wwv_flow_imp.g_varchar2_table(158) := '7374616E63656F66207A297C7C2266756E6374696F6E22213D747970656F66206E2E72656D6F76654174747269627574657C7C2266756E6374696F6E22213D747970656F66206E2E7365744174747269627574657C7C22737472696E6722213D74797065';
wwv_flow_imp.g_varchar2_table(159) := '6F66206E2E6E616D6573706163655552497C7C2266756E6374696F6E22213D747970656F66206E2E696E736572744265666F72657C7C2266756E6374696F6E22213D747970656F66206E2E6861734368696C644E6F646573292972657475726E20757428';
wwv_flow_imp.g_varchar2_table(160) := '65292C21303B766172206E3B636F6E737420723D657428652E6E6F64654E616D65293B6966286874282275706F6E53616E6974697A65456C656D656E74222C652C7B7461674E616D653A722C616C6C6F776564546167733A67657D292C652E6861734368';
wwv_flow_imp.g_varchar2_table(161) := '696C644E6F6465732829262621647428652E6669727374456C656D656E744368696C6429262641282F3C5B2F5C775D2F672C652E696E6E657248544D4C29262641282F3C5B2F5C775D2F672C652E74657874436F6E74656E74292972657475726E207574';
wwv_flow_imp.g_varchar2_table(162) := '2865292C21303B6966282167655B725D7C7C5F655B725D297B696628215F655B725D26267974287229297B69662841652E7461674E616D65436865636B20696E7374616E63656F66205265674578702626412841652E7461674E616D65436865636B2C72';
wwv_flow_imp.g_varchar2_table(163) := '292972657475726E21313B69662841652E7461674E616D65436865636B20696E7374616E63656F662046756E6374696F6E262641652E7461674E616D65436865636B2872292972657475726E21317D696628556526262146655B725D297B636F6E737420';
wwv_flow_imp.g_varchar2_table(164) := '743D4A2865297C7C652E706172656E744E6F64652C6E3D5A2865297C7C652E6368696C644E6F6465733B6966286E262674297B666F72286C6574206F3D6E2E6C656E6774682D313B6F3E3D303B2D2D6F29742E696E736572744265666F72652871286E5B';
wwv_flow_imp.g_varchar2_table(165) := '6F5D2C2130292C24286529297D7D72657475726E2075742865292C21307D72657475726E206520696E7374616E63656F66205226262166756E6374696F6E2865297B6C657420743D4A2865293B742626742E7461674E616D657C7C28743D7B6E616D6573';
wwv_flow_imp.g_varchar2_table(166) := '706163655552493A24652C7461674E616D653A2274656D706C617465227D293B636F6E7374206E3D6628652E7461674E616D65292C6F3D6628742E7461674E616D65293B72657475726E212156655B652E6E616D6573706163655552495D262628652E6E';
wwv_flow_imp.g_varchar2_table(167) := '616D6573706163655552493D3D3D71653F742E6E616D6573706163655552493D3D3D58653F22737667223D3D3D6E3A742E6E616D6573706163655552493D3D3D6A653F22737667223D3D3D6E26262822616E6E6F746174696F6E2D786D6C223D3D3D6F7C';
wwv_flow_imp.g_varchar2_table(168) := '7C69745B6F5D293A426F6F6C65616E2863745B6E5D293A652E6E616D6573706163655552493D3D3D6A653F742E6E616D6573706163655552493D3D3D58653F226D617468223D3D3D6E3A742E6E616D6573706163655552493D3D3D71653F226D61746822';
wwv_flow_imp.g_varchar2_table(169) := '3D3D3D6E262661745B6F5D3A426F6F6C65616E2873745B6E5D293A652E6E616D6573706163655552493D3D3D58653F2128742E6E616D6573706163655552493D3D3D716526262161745B6F5D2926262128742E6E616D6573706163655552493D3D3D6A65';
wwv_flow_imp.g_varchar2_table(170) := '26262169745B6F5D2926262173745B6E5D2626286C745B6E5D7C7C2163745B6E5D293A2128226170706C69636174696F6E2F7868746D6C2B786D6C22213D3D4A657C7C2156655B652E6E616D6573706163655552495D29297D2865293F2875742865292C';
wwv_flow_imp.g_varchar2_table(171) := '2130293A226E6F73637269707422213D3D722626226E6F656D62656422213D3D722626226E6F6672616D657322213D3D727C7C2141282F3C5C2F6E6F287363726970747C656D6265647C6672616D6573292F692C652E696E6E657248544D4C293F284C65';
wwv_flow_imp.g_varchar2_table(172) := '2626333D3D3D652E6E6F646554797065262628743D652E74657874436F6E74656E742C75285B6C652C63652C73655D2C28653D3E7B743D6728742C652C222022297D29292C652E74657874436F6E74656E74213D3D7426262870286F2E72656D6F766564';
wwv_flow_imp.g_varchar2_table(173) := '2C7B656C656D656E743A652E636C6F6E654E6F646528297D292C652E74657874436F6E74656E743D7429292C68742822616674657253616E6974697A65456C656D656E7473222C652C6E756C6C292C2131293A2875742865292C2130297D2C54743D6675';
wwv_flow_imp.g_varchar2_table(174) := '6E6374696F6E28652C742C6E297B6966284D65262628226964223D3D3D747C7C226E616D65223D3D3D74292626286E20696E20727C7C6E20696E206E74292972657475726E21313B69662853652626214E655B745D2626412875652C7429293B656C7365';
wwv_flow_imp.g_varchar2_table(175) := '206966286265262641286D652C7429293B656C7365206966282179655B745D7C7C4E655B745D297B6966282128797428652926262841652E7461674E616D65436865636B20696E7374616E63656F66205265674578702626412841652E7461674E616D65';
wwv_flow_imp.g_varchar2_table(176) := '436865636B2C65297C7C41652E7461674E616D65436865636B20696E7374616E63656F662046756E6374696F6E262641652E7461674E616D65436865636B2865292926262841652E6174747269627574654E616D65436865636B20696E7374616E63656F';
wwv_flow_imp.g_varchar2_table(177) := '66205265674578702626412841652E6174747269627574654E616D65436865636B2C74297C7C41652E6174747269627574654E616D65436865636B20696E7374616E63656F662046756E6374696F6E262641652E6174747269627574654E616D65436865';
wwv_flow_imp.g_varchar2_table(178) := '636B287429297C7C226973223D3D3D74262641652E616C6C6F77437573746F6D697A65644275696C74496E456C656D656E747326262841652E7461674E616D65436865636B20696E7374616E63656F66205265674578702626412841652E7461674E616D';
wwv_flow_imp.g_varchar2_table(179) := '65436865636B2C6E297C7C41652E7461674E616D65436865636B20696E7374616E63656F662046756E6374696F6E262641652E7461674E616D65436865636B286E2929292972657475726E21317D656C73652069662847655B745D293B656C7365206966';
wwv_flow_imp.g_varchar2_table(180) := '28412868652C67286E2C66652C22222929293B656C7365206966282273726322213D3D74262622786C696E6B3A6872656622213D3D742626226872656622213D3D747C7C22736372697074223D3D3D657C7C30213D3D54286E2C22646174613A22297C7C';
wwv_flow_imp.g_varchar2_table(181) := '2142655B655D297B6966285265262621412870652C67286E2C66652C22222929293B656C7365206966286E2972657475726E21317D656C73653B72657475726E21307D2C79743D66756E6374696F6E2865297B72657475726E22616E6E6F746174696F6E';
wwv_flow_imp.g_varchar2_table(182) := '2D786D6C22213D3D6526266828652C6465297D2C45743D66756E6374696F6E2865297B687428226265666F726553616E6974697A6541747472696275746573222C652C6E756C6C293B636F6E73747B617474726962757465733A747D3D653B6966282174';
wwv_flow_imp.g_varchar2_table(183) := '2972657475726E3B636F6E7374206E3D7B617474724E616D653A22222C6174747256616C75653A22222C6B656570417474723A21302C616C6C6F776564417474726962757465733A79657D3B6C657420723D742E6C656E6774683B666F72283B722D2D3B';
wwv_flow_imp.g_varchar2_table(184) := '297B636F6E737420693D745B725D2C7B6E616D653A612C6E616D6573706163655552493A6C2C76616C75653A637D3D692C733D65742861293B6C657420703D2276616C7565223D3D3D613F633A792863293B6966286E2E617474724E616D653D732C6E2E';
wwv_flow_imp.g_varchar2_table(185) := '6174747256616C75653D702C6E2E6B656570417474723D21302C6E2E666F7263654B656570417474723D766F696420302C6874282275706F6E53616E6974697A65417474726962757465222C652C6E292C703D6E2E6174747256616C75652C6E2E666F72';
wwv_flow_imp.g_varchar2_table(186) := '63654B6565704174747229636F6E74696E75653B6966286D7428612C65292C216E2E6B6565704174747229636F6E74696E75653B696628217765262641282F5C2F3E2F692C7029297B6D7428612C65293B636F6E74696E75657D4C65262675285B6C652C';
wwv_flow_imp.g_varchar2_table(187) := '63652C73655D2C28653D3E7B703D6728702C652C222022297D29293B636F6E737420663D657428652E6E6F64654E616D65293B696628547428662C732C7029297B6966282149657C7C22696422213D3D732626226E616D6522213D3D737C7C286D742861';
wwv_flow_imp.g_varchar2_table(188) := '2C65292C703D22757365722D636F6E74656E742D222B70292C512626226F626A656374223D3D747970656F66204726262266756E6374696F6E223D3D747970656F6620472E67657441747472696275746554797065296966286C293B656C736520737769';
wwv_flow_imp.g_varchar2_table(189) := '74636828472E6765744174747269627574655479706528662C7329297B63617365225472757374656448544D4C223A703D512E63726561746548544D4C2870293B627265616B3B63617365225472757374656453637269707455524C223A703D512E6372';
wwv_flow_imp.g_varchar2_table(190) := '6561746553637269707455524C2870297D7472797B6C3F652E7365744174747269627574654E53286C2C612C70293A652E73657441747472696275746528612C70292C6D286F2E72656D6F766564297D63617463682865297B7D7D7D6874282261667465';
wwv_flow_imp.g_varchar2_table(191) := '7253616E6974697A6541747472696275746573222C652C6E756C6C297D2C41743D66756E6374696F6E20652874297B6C6574206E3D6E756C6C3B636F6E7374206F3D66742874293B666F7228687428226265666F726553616E6974697A65536861646F77';
wwv_flow_imp.g_varchar2_table(192) := '444F4D222C742C6E756C6C293B6E3D6F2E6E6578744E6F646528293B296874282275706F6E53616E6974697A65536861646F774E6F6465222C6E2C6E756C6C292C6774286E297C7C286E2E636F6E74656E7420696E7374616E63656F662073262665286E';
wwv_flow_imp.g_varchar2_table(193) := '2E636F6E74656E74292C4574286E29293B68742822616674657253616E6974697A65536861646F77444F4D222C742C6E756C6C297D3B72657475726E206F2E73616E6974697A653D66756E6374696F6E2865297B6C657420743D617267756D656E74732E';
wwv_flow_imp.g_varchar2_table(194) := '6C656E6774683E312626766F69642030213D3D617267756D656E74735B315D3F617267756D656E74735B315D3A7B7D2C6E3D6E756C6C2C723D6E756C6C2C693D6E756C6C2C6C3D6E756C6C3B6966284B653D21652C4B65262628653D225C783363212D2D';
wwv_flow_imp.g_varchar2_table(195) := '5C78336522292C22737472696E6722213D747970656F6620652626216474286529297B6966282266756E6374696F6E22213D747970656F6620652E746F537472696E67297468726F77205F2822746F537472696E67206973206E6F7420612066756E6374';
wwv_flow_imp.g_varchar2_table(196) := '696F6E22293B69662822737472696E6722213D747970656F6628653D652E746F537472696E67282929297468726F77205F28226469727479206973206E6F74206120737472696E672C2061626F7274696E6722297D696628216F2E6973537570706F7274';
wwv_flow_imp.g_varchar2_table(197) := '65642972657475726E20653B69662843657C7C72742874292C6F2E72656D6F7665643D5B5D2C22737472696E67223D3D747970656F66206526262850653D2131292C5065297B696628652E6E6F64654E616D65297B636F6E737420743D657428652E6E6F';
wwv_flow_imp.g_varchar2_table(198) := '64654E616D65293B6966282167655B745D7C7C5F655B745D297468726F77205F2822726F6F74206E6F646520697320666F7262696464656E20616E642063616E6E6F742062652073616E6974697A656420696E2D706C61636522297D7D656C7365206966';
wwv_flow_imp.g_varchar2_table(199) := '286520696E7374616E63656F662062296E3D707428225C783363212D2D2D2D5C78336522292C723D6E2E6F776E6572446F63756D656E742E696D706F72744E6F646528652C2130292C313D3D3D722E6E6F646554797065262622424F4459223D3D3D722E';
wwv_flow_imp.g_varchar2_table(200) := '6E6F64654E616D657C7C2248544D4C223D3D3D722E6E6F64654E616D653F6E3D723A6E2E617070656E644368696C642872293B656C73657B6966282178652626214C65262621446526262D313D3D3D652E696E6465784F6628223C22292972657475726E';
wwv_flow_imp.g_varchar2_table(201) := '205126266B653F512E63726561746548544D4C2865293A653B6966286E3D70742865292C216E2972657475726E2078653F6E756C6C3A6B653F65653A22227D6E2626766526267574286E2E66697273744368696C64293B636F6E737420633D6674285065';
wwv_flow_imp.g_varchar2_table(202) := '3F653A6E293B666F72283B693D632E6E6578744E6F646528293B2967742869297C7C28692E636F6E74656E7420696E7374616E63656F6620732626417428692E636F6E74656E74292C4574286929293B69662850652972657475726E20653B6966287865';
wwv_flow_imp.g_varchar2_table(203) := '297B6966284F6529666F72286C3D6F652E63616C6C286E2E6F776E6572446F63756D656E74293B6E2E66697273744368696C643B296C2E617070656E644368696C64286E2E66697273744368696C64293B656C7365206C3D6E3B72657475726E2879652E';
wwv_flow_imp.g_varchar2_table(204) := '736861646F77726F6F747C7C79652E736861646F77726F6F746D6F6465292626286C3D69652E63616C6C28612C6C2C213029292C6C7D6C6574206D3D44653F6E2E6F7574657248544D4C3A6E2E696E6E657248544D4C3B72657475726E20446526266765';
wwv_flow_imp.g_varchar2_table(205) := '5B2221646F6374797065225D26266E2E6F776E6572446F63756D656E7426266E2E6F776E6572446F63756D656E742E646F637479706526266E2E6F776E6572446F63756D656E742E646F63747970652E6E616D6526264128582C6E2E6F776E6572446F63';
wwv_flow_imp.g_varchar2_table(206) := '756D656E742E646F63747970652E6E616D65292626286D3D223C21444F435459504520222B6E2E6F776E6572446F63756D656E742E646F63747970652E6E616D652B223E5C6E222B6D292C4C65262675285B6C652C63652C73655D2C28653D3E7B6D3D67';
wwv_flow_imp.g_varchar2_table(207) := '286D2C652C222022297D29292C5126266B653F512E63726561746548544D4C286D293A6D7D2C6F2E736574436F6E6669673D66756E6374696F6E28297B727428617267756D656E74732E6C656E6774683E302626766F69642030213D3D617267756D656E';
wwv_flow_imp.g_varchar2_table(208) := '74735B305D3F617267756D656E74735B305D3A7B7D292C43653D21307D2C6F2E636C656172436F6E6669673D66756E6374696F6E28297B74743D6E756C6C2C43653D21317D2C6F2E697356616C69644174747269627574653D66756E6374696F6E28652C';
wwv_flow_imp.g_varchar2_table(209) := '742C6E297B74747C7C7274287B7D293B636F6E7374206F3D65742865292C723D65742874293B72657475726E205474286F2C722C6E297D2C6F2E616464486F6F6B3D66756E6374696F6E28652C74297B2266756E6374696F6E223D3D747970656F662074';
wwv_flow_imp.g_varchar2_table(210) := '26262861655B655D3D61655B655D7C7C5B5D2C702861655B655D2C7429297D2C6F2E72656D6F7665486F6F6B3D66756E6374696F6E2865297B69662861655B655D2972657475726E206D2861655B655D297D2C6F2E72656D6F7665486F6F6B733D66756E';
wwv_flow_imp.g_varchar2_table(211) := '6374696F6E2865297B61655B655D26262861655B655D3D5B5D297D2C6F2E72656D6F7665416C6C486F6F6B733D66756E6374696F6E28297B61653D7B7D7D2C6F7D28293B72657475726E205A7D29293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(165268953809446971362)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_file_name=>'purify.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A2120406C6963656E736520444F4D50757269667920332E302E3130207C202863292043757265353320616E64206F7468657220636F6E7472696275746F7273207C2052656C656173656420756E6465722074686520417061636865206C6963656E73';
wwv_flow_imp.g_varchar2_table(2) := '6520322E3020616E64204D6F7A696C6C61205075626C6963204C6963656E736520322E30207C206769746875622E636F6D2F6375726535332F444F4D5075726966792F626C6F622F332E302E31302F4C4943454E5345202A2F0A0A2866756E6374696F6E';
wwv_flow_imp.g_varchar2_table(3) := '2028676C6F62616C2C20666163746F727929207B0A2020747970656F66206578706F727473203D3D3D20276F626A6563742720262620747970656F66206D6F64756C6520213D3D2027756E646566696E656427203F206D6F64756C652E6578706F727473';
wwv_flow_imp.g_varchar2_table(4) := '203D20666163746F72792829203A0A2020747970656F6620646566696E65203D3D3D202766756E6374696F6E2720262620646566696E652E616D64203F20646566696E6528666163746F727929203A0A202028676C6F62616C203D20747970656F662067';
wwv_flow_imp.g_varchar2_table(5) := '6C6F62616C5468697320213D3D2027756E646566696E656427203F20676C6F62616C54686973203A20676C6F62616C207C7C2073656C662C20676C6F62616C2E444F4D507572696679203D20666163746F72792829293B0A7D2928746869732C20286675';
wwv_flow_imp.g_varchar2_table(6) := '6E6374696F6E202829207B202775736520737472696374273B0A0A2020636F6E7374207B0A20202020656E74726965732C0A2020202073657450726F746F747970654F662C0A20202020697346726F7A656E2C0A2020202067657450726F746F74797065';
wwv_flow_imp.g_varchar2_table(7) := '4F662C0A202020206765744F776E50726F706572747944657363726970746F720A20207D203D204F626A6563743B0A20206C6574207B0A20202020667265657A652C0A202020207365616C2C0A202020206372656174650A20207D203D204F626A656374';
wwv_flow_imp.g_varchar2_table(8) := '3B202F2F2065736C696E742D64697361626C652D6C696E6520696D706F72742F6E6F2D6D757461626C652D6578706F7274730A20206C6574207B0A202020206170706C792C0A20202020636F6E7374727563740A20207D203D20747970656F6620526566';
wwv_flow_imp.g_varchar2_table(9) := '6C65637420213D3D2027756E646566696E656427202626205265666C6563743B0A20206966202821667265657A6529207B0A20202020667265657A65203D2066756E6374696F6E20667265657A65287829207B0A20202020202072657475726E20783B0A';
wwv_flow_imp.g_varchar2_table(10) := '202020207D3B0A20207D0A202069662028217365616C29207B0A202020207365616C203D2066756E6374696F6E207365616C287829207B0A20202020202072657475726E20783B0A202020207D3B0A20207D0A202069662028216170706C7929207B0A20';
wwv_flow_imp.g_varchar2_table(11) := '2020206170706C79203D2066756E6374696F6E206170706C792866756E2C207468697356616C75652C206172677329207B0A20202020202072657475726E2066756E2E6170706C79287468697356616C75652C2061726773293B0A202020207D3B0A2020';
wwv_flow_imp.g_varchar2_table(12) := '7D0A20206966202821636F6E73747275637429207B0A20202020636F6E737472756374203D2066756E6374696F6E20636F6E7374727563742846756E632C206172677329207B0A20202020202072657475726E206E65772046756E63282E2E2E61726773';
wwv_flow_imp.g_varchar2_table(13) := '293B0A202020207D3B0A20207D0A2020636F6E7374206172726179466F7245616368203D20756E6170706C792841727261792E70726F746F747970652E666F7245616368293B0A2020636F6E7374206172726179506F70203D20756E6170706C79284172';
wwv_flow_imp.g_varchar2_table(14) := '7261792E70726F746F747970652E706F70293B0A2020636F6E737420617272617950757368203D20756E6170706C792841727261792E70726F746F747970652E70757368293B0A2020636F6E737420737472696E67546F4C6F77657243617365203D2075';
wwv_flow_imp.g_varchar2_table(15) := '6E6170706C7928537472696E672E70726F746F747970652E746F4C6F77657243617365293B0A2020636F6E737420737472696E67546F537472696E67203D20756E6170706C7928537472696E672E70726F746F747970652E746F537472696E67293B0A20';
wwv_flow_imp.g_varchar2_table(16) := '20636F6E737420737472696E674D61746368203D20756E6170706C7928537472696E672E70726F746F747970652E6D61746368293B0A2020636F6E737420737472696E675265706C616365203D20756E6170706C7928537472696E672E70726F746F7479';
wwv_flow_imp.g_varchar2_table(17) := '70652E7265706C616365293B0A2020636F6E737420737472696E67496E6465784F66203D20756E6170706C7928537472696E672E70726F746F747970652E696E6465784F66293B0A2020636F6E737420737472696E675472696D203D20756E6170706C79';
wwv_flow_imp.g_varchar2_table(18) := '28537472696E672E70726F746F747970652E7472696D293B0A2020636F6E7374206F626A6563744861734F776E50726F7065727479203D20756E6170706C79284F626A6563742E70726F746F747970652E6861734F776E50726F7065727479293B0A2020';
wwv_flow_imp.g_varchar2_table(19) := '636F6E73742072656745787054657374203D20756E6170706C79285265674578702E70726F746F747970652E74657374293B0A2020636F6E737420747970654572726F72437265617465203D20756E636F6E73747275637428547970654572726F72293B';
wwv_flow_imp.g_varchar2_table(20) := '0A0A20202F2A2A0A2020202A20437265617465732061206E65772066756E6374696F6E20746861742063616C6C732074686520676976656E2066756E6374696F6E2077697468206120737065636966696564207468697341726720616E6420617267756D';
wwv_flow_imp.g_varchar2_table(21) := '656E74732E0A2020202A0A2020202A2040706172616D207B46756E6374696F6E7D2066756E63202D205468652066756E6374696F6E20746F206265207772617070656420616E642063616C6C65642E0A2020202A204072657475726E73207B46756E6374';
wwv_flow_imp.g_varchar2_table(22) := '696F6E7D2041206E65772066756E6374696F6E20746861742063616C6C732074686520676976656E2066756E6374696F6E2077697468206120737065636966696564207468697341726720616E6420617267756D656E74732E0A2020202A2F0A20206675';
wwv_flow_imp.g_varchar2_table(23) := '6E6374696F6E20756E6170706C792866756E6329207B0A2020202072657475726E2066756E6374696F6E20287468697341726729207B0A202020202020666F722028766172205F6C656E203D20617267756D656E74732E6C656E6774682C206172677320';
wwv_flow_imp.g_varchar2_table(24) := '3D206E6577204172726179285F6C656E203E2031203F205F6C656E202D2031203A2030292C205F6B6579203D20313B205F6B6579203C205F6C656E3B205F6B65792B2B29207B0A2020202020202020617267735B5F6B6579202D20315D203D2061726775';
wwv_flow_imp.g_varchar2_table(25) := '6D656E74735B5F6B65795D3B0A2020202020207D0A20202020202072657475726E206170706C792866756E632C20746869734172672C2061726773293B0A202020207D3B0A20207D0A0A20202F2A2A0A2020202A20437265617465732061206E65772066';
wwv_flow_imp.g_varchar2_table(26) := '756E6374696F6E207468617420636F6E7374727563747320616E20696E7374616E6365206F662074686520676976656E20636F6E7374727563746F722066756E6374696F6E2077697468207468652070726F766964656420617267756D656E74732E0A20';
wwv_flow_imp.g_varchar2_table(27) := '20202A0A2020202A2040706172616D207B46756E6374696F6E7D2066756E63202D2054686520636F6E7374727563746F722066756E6374696F6E20746F206265207772617070656420616E642063616C6C65642E0A2020202A204072657475726E73207B';
wwv_flow_imp.g_varchar2_table(28) := '46756E6374696F6E7D2041206E65772066756E6374696F6E207468617420636F6E7374727563747320616E20696E7374616E6365206F662074686520676976656E20636F6E7374727563746F722066756E6374696F6E2077697468207468652070726F76';
wwv_flow_imp.g_varchar2_table(29) := '6964656420617267756D656E74732E0A2020202A2F0A202066756E6374696F6E20756E636F6E7374727563742866756E6329207B0A2020202072657475726E2066756E6374696F6E202829207B0A202020202020666F722028766172205F6C656E32203D';
wwv_flow_imp.g_varchar2_table(30) := '20617267756D656E74732E6C656E6774682C2061726773203D206E6577204172726179285F6C656E32292C205F6B657932203D20303B205F6B657932203C205F6C656E323B205F6B6579322B2B29207B0A2020202020202020617267735B5F6B6579325D';
wwv_flow_imp.g_varchar2_table(31) := '203D20617267756D656E74735B5F6B6579325D3B0A2020202020207D0A20202020202072657475726E20636F6E7374727563742866756E632C2061726773293B0A202020207D3B0A20207D0A0A20202F2A2A0A2020202A204164642070726F7065727469';
wwv_flow_imp.g_varchar2_table(32) := '657320746F2061206C6F6F6B7570207461626C650A2020202A0A2020202A2040706172616D207B4F626A6563747D20736574202D205468652073657420746F20776869636820656C656D656E74732077696C6C2062652061646465642E0A2020202A2040';
wwv_flow_imp.g_varchar2_table(33) := '706172616D207B41727261797D206172726179202D2054686520617272617920636F6E7461696E696E6720656C656D656E747320746F20626520616464656420746F20746865207365742E0A2020202A2040706172616D207B46756E6374696F6E7D2074';
wwv_flow_imp.g_varchar2_table(34) := '72616E73666F726D4361736546756E63202D20416E206F7074696F6E616C2066756E6374696F6E20746F207472616E73666F726D207468652063617365206F66206561636820656C656D656E74206265666F726520616464696E6720746F207468652073';
wwv_flow_imp.g_varchar2_table(35) := '65742E0A2020202A204072657475726E73207B4F626A6563747D20546865206D6F64696669656420736574207769746820616464656420656C656D656E74732E0A2020202A2F0A202066756E6374696F6E20616464546F536574287365742C2061727261';
wwv_flow_imp.g_varchar2_table(36) := '7929207B0A202020206C6574207472616E73666F726D4361736546756E63203D20617267756D656E74732E6C656E677468203E203220262620617267756D656E74735B325D20213D3D20756E646566696E6564203F20617267756D656E74735B325D203A';
wwv_flow_imp.g_varchar2_table(37) := '20737472696E67546F4C6F776572436173653B0A202020206966202873657450726F746F747970654F6629207B0A2020202020202F2F204D616B652027696E2720616E642074727574687920636865636B73206C696B6520426F6F6C65616E287365742E';
wwv_flow_imp.g_varchar2_table(38) := '636F6E7374727563746F72290A2020202020202F2F20696E646570656E64656E74206F6620616E792070726F7065727469657320646566696E6564206F6E204F626A6563742E70726F746F747970652E0A2020202020202F2F2050726576656E74207072';
wwv_flow_imp.g_varchar2_table(39) := '6F746F7479706520736574746572732066726F6D20696E74657263657074696E6720736574206173206120746869732076616C75652E0A20202020202073657450726F746F747970654F66287365742C206E756C6C293B0A202020207D0A202020206C65';
wwv_flow_imp.g_varchar2_table(40) := '74206C203D2061727261792E6C656E6774683B0A202020207768696C6520286C2D2D29207B0A2020202020206C657420656C656D656E74203D2061727261795B6C5D3B0A20202020202069662028747970656F6620656C656D656E74203D3D3D20277374';
wwv_flow_imp.g_varchar2_table(41) := '72696E672729207B0A2020202020202020636F6E7374206C63456C656D656E74203D207472616E73666F726D4361736546756E6328656C656D656E74293B0A2020202020202020696620286C63456C656D656E7420213D3D20656C656D656E7429207B0A';
wwv_flow_imp.g_varchar2_table(42) := '202020202020202020202F2F20436F6E66696720707265736574732028652E672E20746167732E6A732C2061747472732E6A73292061726520696D6D757461626C652E0A202020202020202020206966202821697346726F7A656E286172726179292920';
wwv_flow_imp.g_varchar2_table(43) := '7B0A20202020202020202020202061727261795B6C5D203D206C63456C656D656E743B0A202020202020202020207D0A20202020202020202020656C656D656E74203D206C63456C656D656E743B0A20202020202020207D0A2020202020207D0A202020';
wwv_flow_imp.g_varchar2_table(44) := '2020207365745B656C656D656E745D203D20747275653B0A202020207D0A2020202072657475726E207365743B0A20207D0A0A20202F2A2A0A2020202A20436C65616E20757020616E20617272617920746F2068617264656E20616761696E7374204353';
wwv_flow_imp.g_varchar2_table(45) := '50500A2020202A0A2020202A2040706172616D207B41727261797D206172726179202D2054686520617272617920746F20626520636C65616E65642E0A2020202A204072657475726E73207B41727261797D2054686520636C65616E6564207665727369';
wwv_flow_imp.g_varchar2_table(46) := '6F6E206F66207468652061727261790A2020202A2F0A202066756E6374696F6E20636C65616E417272617928617272617929207B0A20202020666F7220286C657420696E646578203D20303B20696E646578203C2061727261792E6C656E6774683B2069';
wwv_flow_imp.g_varchar2_table(47) := '6E6465782B2B29207B0A202020202020636F6E737420697350726F70657274794578697374203D206F626A6563744861734F776E50726F70657274792861727261792C20696E646578293B0A2020202020206966202821697350726F7065727479457869';
wwv_flow_imp.g_varchar2_table(48) := '737429207B0A202020202020202061727261795B696E6465785D203D206E756C6C3B0A2020202020207D0A202020207D0A2020202072657475726E2061727261793B0A20207D0A0A20202F2A2A0A2020202A205368616C6C6F7720636C6F6E6520616E20';
wwv_flow_imp.g_varchar2_table(49) := '6F626A6563740A2020202A0A2020202A2040706172616D207B4F626A6563747D206F626A656374202D20546865206F626A65637420746F20626520636C6F6E65642E0A2020202A204072657475726E73207B4F626A6563747D2041206E6577206F626A65';
wwv_flow_imp.g_varchar2_table(50) := '6374207468617420636F7069657320746865206F726967696E616C2E0A2020202A2F0A202066756E6374696F6E20636C6F6E65286F626A65637429207B0A20202020636F6E7374206E65774F626A656374203D20637265617465286E756C6C293B0A2020';
wwv_flow_imp.g_varchar2_table(51) := '2020666F722028636F6E7374205B70726F70657274792C2076616C75655D206F6620656E7472696573286F626A6563742929207B0A202020202020636F6E737420697350726F70657274794578697374203D206F626A6563744861734F776E50726F7065';
wwv_flow_imp.g_varchar2_table(52) := '727479286F626A6563742C2070726F7065727479293B0A20202020202069662028697350726F7065727479457869737429207B0A20202020202020206966202841727261792E697341727261792876616C75652929207B0A202020202020202020206E65';
wwv_flow_imp.g_varchar2_table(53) := '774F626A6563745B70726F70657274795D203D20636C65616E41727261792876616C7565293B0A20202020202020207D20656C7365206966202876616C756520262620747970656F662076616C7565203D3D3D20276F626A656374272026262076616C75';
wwv_flow_imp.g_varchar2_table(54) := '652E636F6E7374727563746F72203D3D3D204F626A65637429207B0A202020202020202020206E65774F626A6563745B70726F70657274795D203D20636C6F6E652876616C7565293B0A20202020202020207D20656C7365207B0A202020202020202020';
wwv_flow_imp.g_varchar2_table(55) := '206E65774F626A6563745B70726F70657274795D203D2076616C75653B0A20202020202020207D0A2020202020207D0A202020207D0A2020202072657475726E206E65774F626A6563743B0A20207D0A0A20202F2A2A0A2020202A2054686973206D6574';
wwv_flow_imp.g_varchar2_table(56) := '686F64206175746F6D61746963616C6C7920636865636B73206966207468652070726F702069732066756E6374696F6E206F722067657474657220616E642062656861766573206163636F7264696E676C792E0A2020202A0A2020202A2040706172616D';
wwv_flow_imp.g_varchar2_table(57) := '207B4F626A6563747D206F626A656374202D20546865206F626A65637420746F206C6F6F6B20757020746865206765747465722066756E6374696F6E20696E206974732070726F746F7479706520636861696E2E0A2020202A2040706172616D207B5374';
wwv_flow_imp.g_varchar2_table(58) := '72696E677D2070726F70202D205468652070726F7065727479206E616D6520666F7220776869636820746F2066696E6420746865206765747465722066756E6374696F6E2E0A2020202A204072657475726E73207B46756E6374696F6E7D205468652067';
wwv_flow_imp.g_varchar2_table(59) := '65747465722066756E6374696F6E20666F756E6420696E207468652070726F746F7479706520636861696E206F7220612066616C6C6261636B2066756E6374696F6E2E0A2020202A2F0A202066756E6374696F6E206C6F6F6B7570476574746572286F62';
wwv_flow_imp.g_varchar2_table(60) := '6A6563742C2070726F7029207B0A202020207768696C6520286F626A65637420213D3D206E756C6C29207B0A202020202020636F6E73742064657363203D206765744F776E50726F706572747944657363726970746F72286F626A6563742C2070726F70';
wwv_flow_imp.g_varchar2_table(61) := '293B0A202020202020696620286465736329207B0A202020202020202069662028646573632E67657429207B0A2020202020202020202072657475726E20756E6170706C7928646573632E676574293B0A20202020202020207D0A202020202020202069';
wwv_flow_imp.g_varchar2_table(62) := '662028747970656F6620646573632E76616C7565203D3D3D202766756E6374696F6E2729207B0A2020202020202020202072657475726E20756E6170706C7928646573632E76616C7565293B0A20202020202020207D0A2020202020207D0A2020202020';
wwv_flow_imp.g_varchar2_table(63) := '206F626A656374203D2067657450726F746F747970654F66286F626A656374293B0A202020207D0A2020202066756E6374696F6E2066616C6C6261636B56616C75652829207B0A20202020202072657475726E206E756C6C3B0A202020207D0A20202020';
wwv_flow_imp.g_varchar2_table(64) := '72657475726E2066616C6C6261636B56616C75653B0A20207D0A0A2020636F6E73742068746D6C2431203D20667265657A65285B2761272C202761626272272C20276163726F6E796D272C202761646472657373272C202761726561272C202761727469';
wwv_flow_imp.g_varchar2_table(65) := '636C65272C20276173696465272C2027617564696F272C202762272C2027626469272C202762646F272C2027626967272C2027626C696E6B272C2027626C6F636B71756F7465272C2027626F6479272C20276272272C2027627574746F6E272C20276361';
wwv_flow_imp.g_varchar2_table(66) := '6E766173272C202763617074696F6E272C202763656E746572272C202763697465272C2027636F6465272C2027636F6C272C2027636F6C67726F7570272C2027636F6E74656E74272C202764617461272C2027646174616C697374272C20276464272C20';
wwv_flow_imp.g_varchar2_table(67) := '276465636F7261746F72272C202764656C272C202764657461696C73272C202764666E272C20276469616C6F67272C2027646972272C2027646976272C2027646C272C20276474272C2027656C656D656E74272C2027656D272C20276669656C64736574';
wwv_flow_imp.g_varchar2_table(68) := '272C202766696763617074696F6E272C2027666967757265272C2027666F6E74272C2027666F6F746572272C2027666F726D272C20276831272C20276832272C20276833272C20276834272C20276835272C20276836272C202768656164272C20276865';
wwv_flow_imp.g_varchar2_table(69) := '61646572272C20276867726F7570272C20276872272C202768746D6C272C202769272C2027696D67272C2027696E707574272C2027696E73272C20276B6264272C20276C6162656C272C20276C6567656E64272C20276C69272C20276D61696E272C2027';
wwv_flow_imp.g_varchar2_table(70) := '6D6170272C20276D61726B272C20276D617271756565272C20276D656E75272C20276D656E756974656D272C20276D65746572272C20276E6176272C20276E6F6272272C20276F6C272C20276F707467726F7570272C20276F7074696F6E272C20276F75';
wwv_flow_imp.g_varchar2_table(71) := '74707574272C202770272C202770696374757265272C2027707265272C202770726F6772657373272C202771272C20277270272C20277274272C202772756279272C202773272C202773616D70272C202773656374696F6E272C202773656C656374272C';
wwv_flow_imp.g_varchar2_table(72) := '2027736861646F77272C2027736D616C6C272C2027736F75726365272C2027737061636572272C20277370616E272C2027737472696B65272C20277374726F6E67272C20277374796C65272C2027737562272C202773756D6D617279272C202773757027';
wwv_flow_imp.g_varchar2_table(73) := '2C20277461626C65272C202774626F6479272C20277464272C202774656D706C617465272C20277465787461726561272C202774666F6F74272C20277468272C20277468656164272C202774696D65272C20277472272C2027747261636B272C20277474';
wwv_flow_imp.g_varchar2_table(74) := '272C202775272C2027756C272C2027766172272C2027766964656F272C2027776272275D293B0A0A20202F2F205356470A2020636F6E7374207376672431203D20667265657A65285B27737667272C202761272C2027616C74676C797068272C2027616C';
wwv_flow_imp.g_varchar2_table(75) := '74676C797068646566272C2027616C74676C7970686974656D272C2027616E696D617465636F6C6F72272C2027616E696D6174656D6F74696F6E272C2027616E696D6174657472616E73666F726D272C2027636972636C65272C2027636C697070617468';
wwv_flow_imp.g_varchar2_table(76) := '272C202764656673272C202764657363272C2027656C6C69707365272C202766696C746572272C2027666F6E74272C202767272C2027676C797068272C2027676C797068726566272C2027686B65726E272C2027696D616765272C20276C696E65272C20';
wwv_flow_imp.g_varchar2_table(77) := '276C696E6561726772616469656E74272C20276D61726B6572272C20276D61736B272C20276D65746164617461272C20276D70617468272C202770617468272C20277061747465726E272C2027706F6C79676F6E272C2027706F6C796C696E65272C2027';
wwv_flow_imp.g_varchar2_table(78) := '72616469616C6772616469656E74272C202772656374272C202773746F70272C20277374796C65272C2027737769746368272C202773796D626F6C272C202774657874272C20277465787470617468272C20277469746C65272C202774726566272C2027';
wwv_flow_imp.g_varchar2_table(79) := '747370616E272C202776696577272C2027766B65726E275D293B0A2020636F6E73742073766746696C74657273203D20667265657A65285B276665426C656E64272C20276665436F6C6F724D6174726978272C20276665436F6D706F6E656E745472616E';
wwv_flow_imp.g_varchar2_table(80) := '73666572272C20276665436F6D706F73697465272C20276665436F6E766F6C76654D6174726978272C20276665446966667573654C69676874696E67272C20276665446973706C6163656D656E744D6170272C2027666544697374616E744C6967687427';
wwv_flow_imp.g_varchar2_table(81) := '2C2027666544726F70536861646F77272C20276665466C6F6F64272C2027666546756E6341272C2027666546756E6342272C2027666546756E6347272C2027666546756E6352272C20276665476175737369616E426C7572272C20276665496D61676527';
wwv_flow_imp.g_varchar2_table(82) := '2C202766654D65726765272C202766654D657267654E6F6465272C202766654D6F7270686F6C6F6779272C202766654F6666736574272C20276665506F696E744C69676874272C2027666553706563756C61724C69676874696E67272C2027666553706F';
wwv_flow_imp.g_varchar2_table(83) := '744C69676874272C2027666554696C65272C2027666554757262756C656E6365275D293B0A0A20202F2F204C697374206F662053564720656C656D656E747320746861742061726520646973616C6C6F7765642062792064656661756C742E0A20202F2F';
wwv_flow_imp.g_varchar2_table(84) := '205765207374696C6C206E65656420746F206B6E6F77207468656D20736F20746861742077652063616E20646F206E616D6573706163650A20202F2F20636865636B732070726F7065726C7920696E2063617365206F6E652077616E747320746F206164';
wwv_flow_imp.g_varchar2_table(85) := '64207468656D20746F0A20202F2F20616C6C6F772D6C6973742E0A2020636F6E737420737667446973616C6C6F776564203D20667265657A65285B27616E696D617465272C2027636F6C6F722D70726F66696C65272C2027637572736F72272C20276469';
wwv_flow_imp.g_varchar2_table(86) := '7363617264272C2027666F6E742D66616365272C2027666F6E742D666163652D666F726D6174272C2027666F6E742D666163652D6E616D65272C2027666F6E742D666163652D737263272C2027666F6E742D666163652D757269272C2027666F72656967';
wwv_flow_imp.g_varchar2_table(87) := '6E6F626A656374272C20276861746368272C2027686174636870617468272C20276D657368272C20276D6573686772616469656E74272C20276D6573687061746368272C20276D657368726F77272C20276D697373696E672D676C797068272C20277363';
wwv_flow_imp.g_varchar2_table(88) := '72697074272C2027736574272C2027736F6C6964636F6C6F72272C2027756E6B6E6F776E272C2027757365275D293B0A2020636F6E7374206D6174684D6C2431203D20667265657A65285B276D617468272C20276D656E636C6F7365272C20276D657272';
wwv_flow_imp.g_varchar2_table(89) := '6F72272C20276D66656E636564272C20276D66726163272C20276D676C797068272C20276D69272C20276D6C6162656C65647472272C20276D6D756C746973637269707473272C20276D6E272C20276D6F272C20276D6F766572272C20276D7061646465';
wwv_flow_imp.g_varchar2_table(90) := '64272C20276D7068616E746F6D272C20276D726F6F74272C20276D726F77272C20276D73272C20276D7370616365272C20276D73717274272C20276D7374796C65272C20276D737562272C20276D737570272C20276D737562737570272C20276D746162';
wwv_flow_imp.g_varchar2_table(91) := '6C65272C20276D7464272C20276D74657874272C20276D7472272C20276D756E646572272C20276D756E6465726F766572272C20276D70726573637269707473275D293B0A0A20202F2F2053696D696C61726C7920746F205356472C2077652077616E74';
wwv_flow_imp.g_varchar2_table(92) := '20746F206B6E6F7720616C6C204D6174684D4C20656C656D656E74732C0A20202F2F206576656E2074686F7365207468617420776520646973616C6C6F772062792064656661756C742E0A2020636F6E7374206D6174684D6C446973616C6C6F77656420';
wwv_flow_imp.g_varchar2_table(93) := '3D20667265657A65285B276D616374696F6E272C20276D616C69676E67726F7570272C20276D616C69676E6D61726B272C20276D6C6F6E67646976272C20276D7363617272696573272C20276D736361727279272C20276D7367726F7570272C20276D73';
wwv_flow_imp.g_varchar2_table(94) := '7461636B272C20276D736C696E65272C20276D73726F77272C202773656D616E74696373272C2027616E6E6F746174696F6E272C2027616E6E6F746174696F6E2D786D6C272C20276D70726573637269707473272C20276E6F6E65275D293B0A2020636F';
wwv_flow_imp.g_varchar2_table(95) := '6E73742074657874203D20667265657A65285B272374657874275D293B0A0A2020636F6E73742068746D6C203D20667265657A65285B27616363657074272C2027616374696F6E272C2027616C69676E272C2027616C74272C20276175746F6361706974';
wwv_flow_imp.g_varchar2_table(96) := '616C697A65272C20276175746F636F6D706C657465272C20276175746F70696374757265696E70696374757265272C20276175746F706C6179272C20276261636B67726F756E64272C20276267636F6C6F72272C2027626F72646572272C202763617074';
wwv_flow_imp.g_varchar2_table(97) := '757265272C202763656C6C70616464696E67272C202763656C6C73706163696E67272C2027636865636B6564272C202763697465272C2027636C617373272C2027636C656172272C2027636F6C6F72272C2027636F6C73272C2027636F6C7370616E272C';
wwv_flow_imp.g_varchar2_table(98) := '2027636F6E74726F6C73272C2027636F6E74726F6C736C697374272C2027636F6F726473272C202763726F73736F726967696E272C20276461746574696D65272C20276465636F64696E67272C202764656661756C74272C2027646972272C2027646973';
wwv_flow_imp.g_varchar2_table(99) := '61626C6564272C202764697361626C6570696374757265696E70696374757265272C202764697361626C6572656D6F7465706C61796261636B272C2027646F776E6C6F6164272C2027647261676761626C65272C2027656E6374797065272C2027656E74';
wwv_flow_imp.g_varchar2_table(100) := '65726B657968696E74272C202766616365272C2027666F72272C202768656164657273272C2027686569676874272C202768696464656E272C202768696768272C202768726566272C2027687265666C616E67272C20276964272C2027696E7075746D6F';
wwv_flow_imp.g_varchar2_table(101) := '6465272C2027696E74656772697479272C202769736D6170272C20276B696E64272C20276C6162656C272C20276C616E67272C20276C697374272C20276C6F6164696E67272C20276C6F6F70272C20276C6F77272C20276D6178272C20276D61786C656E';
wwv_flow_imp.g_varchar2_table(102) := '677468272C20276D65646961272C20276D6574686F64272C20276D696E272C20276D696E6C656E677468272C20276D756C7469706C65272C20276D75746564272C20276E616D65272C20276E6F6E6365272C20276E6F7368616465272C20276E6F76616C';
wwv_flow_imp.g_varchar2_table(103) := '6964617465272C20276E6F77726170272C20276F70656E272C20276F7074696D756D272C20277061747465726E272C2027706C616365686F6C646572272C2027706C617973696E6C696E65272C2027706F73746572272C20277072656C6F6164272C2027';
wwv_flow_imp.g_varchar2_table(104) := '70756264617465272C2027726164696F67726F7570272C2027726561646F6E6C79272C202772656C272C20277265717569726564272C2027726576272C20277265766572736564272C2027726F6C65272C2027726F7773272C2027726F777370616E272C';
wwv_flow_imp.g_varchar2_table(105) := '20277370656C6C636865636B272C202773636F7065272C202773656C6563746564272C20277368617065272C202773697A65272C202773697A6573272C20277370616E272C20277372636C616E67272C20277374617274272C2027737263272C20277372';
wwv_flow_imp.g_varchar2_table(106) := '63736574272C202773746570272C20277374796C65272C202773756D6D617279272C2027746162696E646578272C20277469746C65272C20277472616E736C617465272C202774797065272C20277573656D6170272C202776616C69676E272C20277661';
wwv_flow_imp.g_varchar2_table(107) := '6C7565272C20277769647468272C2027786D6C6E73272C2027736C6F74275D293B0A2020636F6E737420737667203D20667265657A65285B27616363656E742D686569676874272C2027616363756D756C617465272C20276164646974697665272C2027';
wwv_flow_imp.g_varchar2_table(108) := '616C69676E6D656E742D626173656C696E65272C2027617363656E74272C20276174747269627574656E616D65272C202761747472696275746574797065272C2027617A696D757468272C2027626173656672657175656E6379272C2027626173656C69';
wwv_flow_imp.g_varchar2_table(109) := '6E652D7368696674272C2027626567696E272C202762696173272C20276279272C2027636C617373272C2027636C6970272C2027636C697070617468756E697473272C2027636C69702D70617468272C2027636C69702D72756C65272C2027636F6C6F72';
wwv_flow_imp.g_varchar2_table(110) := '272C2027636F6C6F722D696E746572706F6C6174696F6E272C2027636F6C6F722D696E746572706F6C6174696F6E2D66696C74657273272C2027636F6C6F722D70726F66696C65272C2027636F6C6F722D72656E646572696E67272C20276378272C2027';
wwv_flow_imp.g_varchar2_table(111) := '6379272C202764272C20276478272C20276479272C202764696666757365636F6E7374616E74272C2027646972656374696F6E272C2027646973706C6179272C202764697669736F72272C2027647572272C2027656467656D6F6465272C2027656C6576';
wwv_flow_imp.g_varchar2_table(112) := '6174696F6E272C2027656E64272C202766696C6C272C202766696C6C2D6F706163697479272C202766696C6C2D72756C65272C202766696C746572272C202766696C746572756E697473272C2027666C6F6F642D636F6C6F72272C2027666C6F6F642D6F';
wwv_flow_imp.g_varchar2_table(113) := '706163697479272C2027666F6E742D66616D696C79272C2027666F6E742D73697A65272C2027666F6E742D73697A652D61646A757374272C2027666F6E742D73747265746368272C2027666F6E742D7374796C65272C2027666F6E742D76617269616E74';
wwv_flow_imp.g_varchar2_table(114) := '272C2027666F6E742D776569676874272C20276678272C20276679272C20276731272C20276732272C2027676C7970682D6E616D65272C2027676C797068726566272C20276772616469656E74756E697473272C20276772616469656E747472616E7366';
wwv_flow_imp.g_varchar2_table(115) := '6F726D272C2027686569676874272C202768726566272C20276964272C2027696D6167652D72656E646572696E67272C2027696E272C2027696E32272C20276B272C20276B31272C20276B32272C20276B33272C20276B34272C20276B65726E696E6727';
wwv_flow_imp.g_varchar2_table(116) := '2C20276B6579706F696E7473272C20276B657973706C696E6573272C20276B657974696D6573272C20276C616E67272C20276C656E67746861646A757374272C20276C65747465722D73706163696E67272C20276B65726E656C6D6174726978272C2027';
wwv_flow_imp.g_varchar2_table(117) := '6B65726E656C756E69746C656E677468272C20276C69676874696E672D636F6C6F72272C20276C6F63616C272C20276D61726B65722D656E64272C20276D61726B65722D6D6964272C20276D61726B65722D7374617274272C20276D61726B6572686569';
wwv_flow_imp.g_varchar2_table(118) := '676874272C20276D61726B6572756E697473272C20276D61726B65727769647468272C20276D61736B636F6E74656E74756E697473272C20276D61736B756E697473272C20276D6178272C20276D61736B272C20276D65646961272C20276D6574686F64';
wwv_flow_imp.g_varchar2_table(119) := '272C20276D6F6465272C20276D696E272C20276E616D65272C20276E756D6F637461766573272C20276F6666736574272C20276F70657261746F72272C20276F706163697479272C20276F72646572272C20276F7269656E74272C20276F7269656E7461';
wwv_flow_imp.g_varchar2_table(120) := '74696F6E272C20276F726967696E272C20276F766572666C6F77272C20277061696E742D6F72646572272C202770617468272C2027706174686C656E677468272C20277061747465726E636F6E74656E74756E697473272C20277061747465726E747261';
wwv_flow_imp.g_varchar2_table(121) := '6E73666F726D272C20277061747465726E756E697473272C2027706F696E7473272C20277072657365727665616C706861272C20277072657365727665617370656374726174696F272C20277072696D6974697665756E697473272C202772272C202772';
wwv_flow_imp.g_varchar2_table(122) := '78272C20277279272C2027726164697573272C202772656678272C202772656679272C2027726570656174636F756E74272C2027726570656174647572272C202772657374617274272C2027726573756C74272C2027726F74617465272C20277363616C';
wwv_flow_imp.g_varchar2_table(123) := '65272C202773656564272C202773686170652D72656E646572696E67272C202773706563756C6172636F6E7374616E74272C202773706563756C61726578706F6E656E74272C20277370726561646D6574686F64272C202773746172746F666673657427';
wwv_flow_imp.g_varchar2_table(124) := '2C2027737464646576696174696F6E272C202773746974636874696C6573272C202773746F702D636F6C6F72272C202773746F702D6F706163697479272C20277374726F6B652D646173686172726179272C20277374726F6B652D646173686F66667365';
wwv_flow_imp.g_varchar2_table(125) := '74272C20277374726F6B652D6C696E65636170272C20277374726F6B652D6C696E656A6F696E272C20277374726F6B652D6D697465726C696D6974272C20277374726F6B652D6F706163697479272C20277374726F6B65272C20277374726F6B652D7769';
wwv_flow_imp.g_varchar2_table(126) := '647468272C20277374796C65272C2027737572666163657363616C65272C202773797374656D6C616E6775616765272C2027746162696E646578272C202774617267657478272C202774617267657479272C20277472616E73666F726D272C2027747261';
wwv_flow_imp.g_varchar2_table(127) := '6E73666F726D2D6F726967696E272C2027746578742D616E63686F72272C2027746578742D6465636F726174696F6E272C2027746578742D72656E646572696E67272C2027746578746C656E677468272C202774797065272C20277531272C2027753227';
wwv_flow_imp.g_varchar2_table(128) := '2C2027756E69636F6465272C202776616C756573272C202776696577626F78272C20277669736962696C697479272C202776657273696F6E272C2027766572742D6164762D79272C2027766572742D6F726967696E2D78272C2027766572742D6F726967';
wwv_flow_imp.g_varchar2_table(129) := '696E2D79272C20277769647468272C2027776F72642D73706163696E67272C202777726170272C202777726974696E672D6D6F6465272C2027786368616E6E656C73656C6563746F72272C2027796368616E6E656C73656C6563746F72272C202778272C';
wwv_flow_imp.g_varchar2_table(130) := '20277831272C20277832272C2027786D6C6E73272C202779272C20277931272C20277932272C20277A272C20277A6F6F6D616E6470616E275D293B0A2020636F6E7374206D6174684D6C203D20667265657A65285B27616363656E74272C202761636365';
wwv_flow_imp.g_varchar2_table(131) := '6E74756E646572272C2027616C69676E272C2027626576656C6C6564272C2027636C6F7365272C2027636F6C756D6E73616C69676E272C2027636F6C756D6E6C696E6573272C2027636F6C756D6E7370616E272C202764656E6F6D616C69676E272C2027';
wwv_flow_imp.g_varchar2_table(132) := '6465707468272C2027646972272C2027646973706C6179272C2027646973706C61797374796C65272C2027656E636F64696E67272C202766656E6365272C20276672616D65272C2027686569676874272C202768726566272C20276964272C20276C6172';
wwv_flow_imp.g_varchar2_table(133) := '67656F70272C20276C656E677468272C20276C696E65746869636B6E657373272C20276C7370616365272C20276C71756F7465272C20276D6174686261636B67726F756E64272C20276D617468636F6C6F72272C20276D61746873697A65272C20276D61';
wwv_flow_imp.g_varchar2_table(134) := '746876617269616E74272C20276D617873697A65272C20276D696E73697A65272C20276D6F7661626C656C696D697473272C20276E6F746174696F6E272C20276E756D616C69676E272C20276F70656E272C2027726F77616C69676E272C2027726F776C';
wwv_flow_imp.g_varchar2_table(135) := '696E6573272C2027726F7773706163696E67272C2027726F777370616E272C2027727370616365272C20277271756F7465272C20277363726970746C6576656C272C20277363726970746D696E73697A65272C202773637269707473697A656D756C7469';
wwv_flow_imp.g_varchar2_table(136) := '706C696572272C202773656C656374696F6E272C2027736570617261746F72272C2027736570617261746F7273272C20277374726574636879272C20277375627363726970747368696674272C20277375707363726970747368696674272C202773796D';
wwv_flow_imp.g_varchar2_table(137) := '6D6574726963272C2027766F6666736574272C20277769647468272C2027786D6C6E73275D293B0A2020636F6E737420786D6C203D20667265657A65285B27786C696E6B3A68726566272C2027786D6C3A6964272C2027786C696E6B3A7469746C65272C';
wwv_flow_imp.g_varchar2_table(138) := '2027786D6C3A7370616365272C2027786D6C6E733A786C696E6B275D293B0A0A20202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520756E69636F726E2F6265747465722D72656765780A2020636F6E7374204D555354414348455F';
wwv_flow_imp.g_varchar2_table(139) := '45585052203D207365616C282F5C7B5C7B5B5C775C575D2A7C5B5C775C575D2A5C7D5C7D2F676D293B202F2F20537065636966792074656D706C61746520646574656374696F6E20726567657820666F7220534146455F464F525F54454D504C41544553';
wwv_flow_imp.g_varchar2_table(140) := '206D6F64650A2020636F6E7374204552425F45585052203D207365616C282F3C255B5C775C575D2A7C5B5C775C575D2A253E2F676D293B0A2020636F6E737420544D504C49545F45585052203D207365616C282F5C247B5B5C775C575D2A7D2F676D293B';
wwv_flow_imp.g_varchar2_table(141) := '0A2020636F6E737420444154415F41545452203D207365616C282F5E646174612D5B5C2D5C772E5C75303042372D5C75464646465D2F293B202F2F2065736C696E742D64697361626C652D6C696E65206E6F2D7573656C6573732D6573636170650A2020';
wwv_flow_imp.g_varchar2_table(142) := '636F6E737420415249415F41545452203D207365616C282F5E617269612D5B5C2D5C775D2B242F293B202F2F2065736C696E742D64697361626C652D6C696E65206E6F2D7573656C6573732D6573636170650A2020636F6E73742049535F414C4C4F5745';
wwv_flow_imp.g_varchar2_table(143) := '445F555249203D207365616C282F5E283F3A283F3A283F3A667C6874297470733F7C6D61696C746F7C74656C7C63616C6C746F7C736D737C6369647C786D7070293A7C5B5E612D7A5D7C5B612D7A2B2E5C2D5D2B283F3A5B5E612D7A2B2E5C2D3A5D7C24';
wwv_flow_imp.g_varchar2_table(144) := '29292F69202F2F2065736C696E742D64697361626C652D6C696E65206E6F2D7573656C6573732D6573636170650A2020293B0A0A2020636F6E73742049535F5343524950545F4F525F44415441203D207365616C282F5E283F3A5C772B7363726970747C';
wwv_flow_imp.g_varchar2_table(145) := '64617461293A2F69293B0A2020636F6E737420415454525F57484954455350414345203D207365616C282F5B5C75303030302D5C75303032305C75303041305C75313638305C75313830455C75323030302D5C75323032395C75323035465C7533303030';
wwv_flow_imp.g_varchar2_table(146) := '5D2F67202F2F2065736C696E742D64697361626C652D6C696E65206E6F2D636F6E74726F6C2D72656765780A2020293B0A0A2020636F6E737420444F43545950455F4E414D45203D207365616C282F5E68746D6C242F69293B0A2020636F6E7374204355';
wwv_flow_imp.g_varchar2_table(147) := '53544F4D5F454C454D454E54203D207365616C282F5E5B612D7A5D5B612D7A5C645D2A282D5B612D7A5C645D2B292B242F69293B0A0A20207661722045585052455353494F4E53203D202F2A235F5F505552455F5F2A2F4F626A6563742E667265657A65';
wwv_flow_imp.g_varchar2_table(148) := '287B0A202020205F5F70726F746F5F5F3A206E756C6C2C0A202020204D555354414348455F455850523A204D555354414348455F455850522C0A202020204552425F455850523A204552425F455850522C0A20202020544D504C49545F455850523A2054';
wwv_flow_imp.g_varchar2_table(149) := '4D504C49545F455850522C0A20202020444154415F415454523A20444154415F415454522C0A20202020415249415F415454523A20415249415F415454522C0A2020202049535F414C4C4F5745445F5552493A2049535F414C4C4F5745445F5552492C0A';
wwv_flow_imp.g_varchar2_table(150) := '2020202049535F5343524950545F4F525F444154413A2049535F5343524950545F4F525F444154412C0A20202020415454525F574849544553504143453A20415454525F574849544553504143452C0A20202020444F43545950455F4E414D453A20444F';
wwv_flow_imp.g_varchar2_table(151) := '43545950455F4E414D452C0A20202020435553544F4D5F454C454D454E543A20435553544F4D5F454C454D454E540A20207D293B0A0A2020636F6E737420676574476C6F62616C203D2066756E6374696F6E20676574476C6F62616C2829207B0A202020';
wwv_flow_imp.g_varchar2_table(152) := '2072657475726E20747970656F662077696E646F77203D3D3D2027756E646566696E656427203F206E756C6C203A2077696E646F773B0A20207D3B0A0A20202F2A2A0A2020202A20437265617465732061206E6F2D6F7020706F6C69637920666F722069';
wwv_flow_imp.g_varchar2_table(153) := '6E7465726E616C20757365206F6E6C792E0A2020202A20446F6E2774206578706F727420746869732066756E6374696F6E206F7574736964652074686973206D6F64756C65210A2020202A2040706172616D207B5472757374656454797065506F6C6963';
wwv_flow_imp.g_varchar2_table(154) := '79466163746F72797D207472757374656454797065732054686520706F6C69637920666163746F72792E0A2020202A2040706172616D207B48544D4C536372697074456C656D656E747D20707572696679486F7374456C656D656E742054686520536372';
wwv_flow_imp.g_varchar2_table(155) := '69707420656C656D656E74207573656420746F206C6F616420444F4D5075726966792028746F2064657465726D696E6520706F6C696379206E616D6520737566666978292E0A2020202A204072657475726E207B5472757374656454797065506F6C6963';
wwv_flow_imp.g_varchar2_table(156) := '797D2054686520706F6C696379206372656174656420286F72206E756C6C2C20696620547275737465642054797065730A2020202A20617265206E6F7420737570706F72746564206F72206372656174696E672074686520706F6C696379206661696C65';
wwv_flow_imp.g_varchar2_table(157) := '64292E0A2020202A2F0A2020636F6E7374205F637265617465547275737465645479706573506F6C696379203D2066756E6374696F6E205F637265617465547275737465645479706573506F6C696379287472757374656454797065732C207075726966';
wwv_flow_imp.g_varchar2_table(158) := '79486F7374456C656D656E7429207B0A2020202069662028747970656F662074727573746564547970657320213D3D20276F626A65637427207C7C20747970656F66207472757374656454797065732E637265617465506F6C69637920213D3D20276675';
wwv_flow_imp.g_varchar2_table(159) := '6E6374696F6E2729207B0A20202020202072657475726E206E756C6C3B0A202020207D0A0A202020202F2F20416C6C6F77207468652063616C6C65727320746F20636F6E74726F6C2074686520756E6971756520706F6C696379206E616D650A20202020';
wwv_flow_imp.g_varchar2_table(160) := '2F2F20627920616464696E67206120646174612D74742D706F6C6963792D73756666697820746F207468652073637269707420656C656D656E7420776974682074686520444F4D5075726966792E0A202020202F2F20506F6C696379206372656174696F';
wwv_flow_imp.g_varchar2_table(161) := '6E2077697468206475706C6963617465206E616D6573207468726F777320696E20547275737465642054797065732E0A202020206C657420737566666978203D206E756C6C3B0A20202020636F6E737420415454525F4E414D45203D2027646174612D74';
wwv_flow_imp.g_varchar2_table(162) := '742D706F6C6963792D737566666978273B0A2020202069662028707572696679486F7374456C656D656E7420262620707572696679486F7374456C656D656E742E68617341747472696275746528415454525F4E414D452929207B0A2020202020207375';
wwv_flow_imp.g_varchar2_table(163) := '66666978203D20707572696679486F7374456C656D656E742E67657441747472696275746528415454525F4E414D45293B0A202020207D0A20202020636F6E737420706F6C6963794E616D65203D2027646F6D70757269667927202B2028737566666978';
wwv_flow_imp.g_varchar2_table(164) := '203F20272327202B20737566666978203A202727293B0A20202020747279207B0A20202020202072657475726E207472757374656454797065732E637265617465506F6C69637928706F6C6963794E616D652C207B0A2020202020202020637265617465';
wwv_flow_imp.g_varchar2_table(165) := '48544D4C2868746D6C29207B0A2020202020202020202072657475726E2068746D6C3B0A20202020202020207D2C0A202020202020202063726561746553637269707455524C2873637269707455726C29207B0A2020202020202020202072657475726E';
wwv_flow_imp.g_varchar2_table(166) := '2073637269707455726C3B0A20202020202020207D0A2020202020207D293B0A202020207D20636174636820285F29207B0A2020202020202F2F20506F6C696379206372656174696F6E206661696C656420286D6F7374206C696B656C7920616E6F7468';
wwv_flow_imp.g_varchar2_table(167) := '657220444F4D50757269667920736372697074206861730A2020202020202F2F20616C72656164792072756E292E20536B6970206372656174696E672074686520706F6C6963792C20617320746869732077696C6C206F6E6C7920636175736520657272';
wwv_flow_imp.g_varchar2_table(168) := '6F72730A2020202020202F2F2069662054542061726520656E666F726365642E0A202020202020636F6E736F6C652E7761726E282754727573746564547970657320706F6C6963792027202B20706F6C6963794E616D65202B202720636F756C64206E6F';
wwv_flow_imp.g_varchar2_table(169) := '7420626520637265617465642E27293B0A20202020202072657475726E206E756C6C3B0A202020207D0A20207D3B0A202066756E6374696F6E20637265617465444F4D5075726966792829207B0A202020206C65742077696E646F77203D20617267756D';
wwv_flow_imp.g_varchar2_table(170) := '656E74732E6C656E677468203E203020262620617267756D656E74735B305D20213D3D20756E646566696E6564203F20617267756D656E74735B305D203A20676574476C6F62616C28293B0A20202020636F6E737420444F4D507572696679203D20726F';
wwv_flow_imp.g_varchar2_table(171) := '6F74203D3E20637265617465444F4D50757269667928726F6F74293B0A0A202020202F2A2A0A20202020202A2056657273696F6E206C6162656C2C206578706F73656420666F722065617369657220636865636B730A20202020202A20696620444F4D50';
wwv_flow_imp.g_varchar2_table(172) := '757269667920697320757020746F2064617465206F72206E6F740A20202020202A2F0A20202020444F4D5075726966792E76657273696F6E203D2027332E302E3130273B0A0A202020202F2A2A0A20202020202A204172726179206F6620656C656D656E';
wwv_flow_imp.g_varchar2_table(173) := '7473207468617420444F4D5075726966792072656D6F76656420647572696E672073616E69746174696F6E2E0A20202020202A20456D707479206966206E6F7468696E67207761732072656D6F7665642E0A20202020202A2F0A20202020444F4D507572';
wwv_flow_imp.g_varchar2_table(174) := '6966792E72656D6F766564203D205B5D3B0A20202020696620282177696E646F77207C7C202177696E646F772E646F63756D656E74207C7C2077696E646F772E646F63756D656E742E6E6F64655479706520213D3D203929207B0A2020202020202F2F20';
wwv_flow_imp.g_varchar2_table(175) := '4E6F742072756E6E696E6720696E20612062726F777365722C2070726F76696465206120666163746F72792066756E6374696F6E0A2020202020202F2F20736F207468617420796F752063616E207061737320796F7572206F776E2057696E646F770A20';
wwv_flow_imp.g_varchar2_table(176) := '2020202020444F4D5075726966792E6973537570706F72746564203D2066616C73653B0A20202020202072657475726E20444F4D5075726966793B0A202020207D0A202020206C6574207B0A202020202020646F63756D656E740A202020207D203D2077';
wwv_flow_imp.g_varchar2_table(177) := '696E646F773B0A20202020636F6E7374206F726967696E616C446F63756D656E74203D20646F63756D656E743B0A20202020636F6E73742063757272656E74536372697074203D206F726967696E616C446F63756D656E742E63757272656E7453637269';
wwv_flow_imp.g_varchar2_table(178) := '70743B0A20202020636F6E7374207B0A202020202020446F63756D656E74467261676D656E742C0A20202020202048544D4C54656D706C617465456C656D656E742C0A2020202020204E6F64652C0A202020202020456C656D656E742C0A202020202020';
wwv_flow_imp.g_varchar2_table(179) := '4E6F646546696C7465722C0A2020202020204E616D65644E6F64654D6170203D2077696E646F772E4E616D65644E6F64654D6170207C7C2077696E646F772E4D6F7A4E616D6564417474724D61702C0A20202020202048544D4C466F726D456C656D656E';
wwv_flow_imp.g_varchar2_table(180) := '742C0A202020202020444F4D5061727365722C0A2020202020207472757374656454797065730A202020207D203D2077696E646F773B0A20202020636F6E737420456C656D656E7450726F746F74797065203D20456C656D656E742E70726F746F747970';
wwv_flow_imp.g_varchar2_table(181) := '653B0A20202020636F6E737420636C6F6E654E6F6465203D206C6F6F6B757047657474657228456C656D656E7450726F746F747970652C2027636C6F6E654E6F646527293B0A20202020636F6E7374206765744E6578745369626C696E67203D206C6F6F';
wwv_flow_imp.g_varchar2_table(182) := '6B757047657474657228456C656D656E7450726F746F747970652C20276E6578745369626C696E6727293B0A20202020636F6E7374206765744368696C644E6F646573203D206C6F6F6B757047657474657228456C656D656E7450726F746F747970652C';
wwv_flow_imp.g_varchar2_table(183) := '20276368696C644E6F64657327293B0A20202020636F6E737420676574506172656E744E6F6465203D206C6F6F6B757047657474657228456C656D656E7450726F746F747970652C2027706172656E744E6F646527293B0A0A202020202F2F2041732070';
wwv_flow_imp.g_varchar2_table(184) := '6572206973737565202334372C20746865207765622D636F6D706F6E656E747320726567697374727920697320696E6865726974656420627920610A202020202F2F206E657720646F63756D656E74206372656174656420766961206372656174654854';
wwv_flow_imp.g_varchar2_table(185) := '4D4C446F63756D656E742E204173207065722074686520737065630A202020202F2F2028687474703A2F2F7733632E6769746875622E696F2F776562636F6D706F6E656E74732F737065632F637573746F6D2F236372656174696E672D616E642D706173';
wwv_flow_imp.g_varchar2_table(186) := '73696E672D72656769737472696573290A202020202F2F2061206E657720656D7074792072656769737472792069732075736564207768656E206372656174696E6720612074656D706C61746520636F6E74656E7473206F776E65720A202020202F2F20';
wwv_flow_imp.g_varchar2_table(187) := '646F63756D656E742C20736F207765207573652074686174206173206F757220706172656E7420646F63756D656E7420746F20656E73757265206E6F7468696E670A202020202F2F20697320696E686572697465642E0A2020202069662028747970656F';
wwv_flow_imp.g_varchar2_table(188) := '662048544D4C54656D706C617465456C656D656E74203D3D3D202766756E6374696F6E2729207B0A202020202020636F6E73742074656D706C617465203D20646F63756D656E742E637265617465456C656D656E74282774656D706C61746527293B0A20';
wwv_flow_imp.g_varchar2_table(189) := '20202020206966202874656D706C6174652E636F6E74656E742026262074656D706C6174652E636F6E74656E742E6F776E6572446F63756D656E7429207B0A2020202020202020646F63756D656E74203D2074656D706C6174652E636F6E74656E742E6F';
wwv_flow_imp.g_varchar2_table(190) := '776E6572446F63756D656E743B0A2020202020207D0A202020207D0A202020206C657420747275737465645479706573506F6C6963793B0A202020206C657420656D70747948544D4C203D2027273B0A20202020636F6E7374207B0A202020202020696D';
wwv_flow_imp.g_varchar2_table(191) := '706C656D656E746174696F6E2C0A2020202020206372656174654E6F64654974657261746F722C0A202020202020637265617465446F63756D656E74467261676D656E742C0A202020202020676574456C656D656E747342795461674E616D650A202020';
wwv_flow_imp.g_varchar2_table(192) := '207D203D20646F63756D656E743B0A20202020636F6E7374207B0A202020202020696D706F72744E6F64650A202020207D203D206F726967696E616C446F63756D656E743B0A202020206C657420686F6F6B73203D207B7D3B0A0A202020202F2A2A0A20';
wwv_flow_imp.g_varchar2_table(193) := '202020202A204578706F7365207768657468657220746869732062726F7773657220737570706F7274732072756E6E696E67207468652066756C6C20444F4D5075726966792E0A20202020202A2F0A20202020444F4D5075726966792E6973537570706F';
wwv_flow_imp.g_varchar2_table(194) := '72746564203D20747970656F6620656E7472696573203D3D3D202766756E6374696F6E2720262620747970656F6620676574506172656E744E6F6465203D3D3D202766756E6374696F6E2720262620696D706C656D656E746174696F6E20262620696D70';
wwv_flow_imp.g_varchar2_table(195) := '6C656D656E746174696F6E2E63726561746548544D4C446F63756D656E7420213D3D20756E646566696E65643B0A20202020636F6E7374207B0A2020202020204D555354414348455F455850522C0A2020202020204552425F455850522C0A2020202020';
wwv_flow_imp.g_varchar2_table(196) := '20544D504C49545F455850522C0A202020202020444154415F415454522C0A202020202020415249415F415454522C0A20202020202049535F5343524950545F4F525F444154412C0A202020202020415454525F574849544553504143452C0A20202020';
wwv_flow_imp.g_varchar2_table(197) := '2020435553544F4D5F454C454D454E540A202020207D203D2045585052455353494F4E533B0A202020206C6574207B0A20202020202049535F414C4C4F5745445F5552493A2049535F414C4C4F5745445F55524924310A202020207D203D204558505245';
wwv_flow_imp.g_varchar2_table(198) := '5353494F4E533B0A0A202020202F2A2A0A20202020202A20576520636F6E73696465722074686520656C656D656E747320616E6420617474726962757465732062656C6F7720746F20626520736166652E20496465616C6C790A20202020202A20646F6E';
wwv_flow_imp.g_varchar2_table(199) := '27742061646420616E79206E6577206F6E657320627574206665656C206672656520746F2072656D6F766520756E77616E746564206F6E65732E0A20202020202A2F0A0A202020202F2A20616C6C6F77656420656C656D656E74206E616D6573202A2F0A';
wwv_flow_imp.g_varchar2_table(200) := '202020206C657420414C4C4F5745445F54414753203D206E756C6C3B0A20202020636F6E73742044454641554C545F414C4C4F5745445F54414753203D20616464546F536574287B7D2C205B2E2E2E68746D6C24312C202E2E2E73766724312C202E2E2E';
wwv_flow_imp.g_varchar2_table(201) := '73766746696C746572732C202E2E2E6D6174684D6C24312C202E2E2E746578745D293B0A0A202020202F2A20416C6C6F77656420617474726962757465206E616D6573202A2F0A202020206C657420414C4C4F5745445F41545452203D206E756C6C3B0A';
wwv_flow_imp.g_varchar2_table(202) := '20202020636F6E73742044454641554C545F414C4C4F5745445F41545452203D20616464546F536574287B7D2C205B2E2E2E68746D6C2C202E2E2E7376672C202E2E2E6D6174684D6C2C202E2E2E786D6C5D293B0A0A202020202F2A0A20202020202A20';
wwv_flow_imp.g_varchar2_table(203) := '436F6E66696775726520686F7720444F4D5055726966792073686F756C642068616E646C6520637573746F6D20656C656D656E747320616E6420746865697220617474726962757465732061732077656C6C20617320637573746F6D697A656420627569';
wwv_flow_imp.g_varchar2_table(204) := '6C742D696E20656C656D656E74732E0A20202020202A204070726F7065727479207B5265674578707C46756E6374696F6E7C6E756C6C7D207461674E616D65436865636B206F6E65206F66205B6E756C6C2C2072656765785061747465726E2C20707265';
wwv_flow_imp.g_varchar2_table(205) := '6469636174655D2E2044656661756C743A20606E756C6C602028646973616C6C6F7720616E7920637573746F6D20656C656D656E7473290A20202020202A204070726F7065727479207B5265674578707C46756E6374696F6E7C6E756C6C7D2061747472';
wwv_flow_imp.g_varchar2_table(206) := '69627574654E616D65436865636B206F6E65206F66205B6E756C6C2C2072656765785061747465726E2C207072656469636174655D2E2044656661756C743A20606E756C6C602028646973616C6C6F7720616E792061747472696275746573206E6F7420';
wwv_flow_imp.g_varchar2_table(207) := '6F6E2074686520616C6C6F77206C697374290A20202020202A204070726F7065727479207B626F6F6C65616E7D20616C6C6F77437573746F6D697A65644275696C74496E456C656D656E747320616C6C6F7720637573746F6D20656C656D656E74732064';
wwv_flow_imp.g_varchar2_table(208) := '6572697665642066726F6D206275696C742D696E732069662074686579207061737320435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B2E2044656661756C743A206066616C7365602E0A20202020202A2F0A20';
wwv_flow_imp.g_varchar2_table(209) := '2020206C657420435553544F4D5F454C454D454E545F48414E444C494E47203D204F626A6563742E7365616C28637265617465286E756C6C2C207B0A2020202020207461674E616D65436865636B3A207B0A20202020202020207772697461626C653A20';
wwv_flow_imp.g_varchar2_table(210) := '747275652C0A2020202020202020636F6E666967757261626C653A2066616C73652C0A2020202020202020656E756D657261626C653A20747275652C0A202020202020202076616C75653A206E756C6C0A2020202020207D2C0A20202020202061747472';
wwv_flow_imp.g_varchar2_table(211) := '69627574654E616D65436865636B3A207B0A20202020202020207772697461626C653A20747275652C0A2020202020202020636F6E666967757261626C653A2066616C73652C0A2020202020202020656E756D657261626C653A20747275652C0A202020';
wwv_flow_imp.g_varchar2_table(212) := '202020202076616C75653A206E756C6C0A2020202020207D2C0A202020202020616C6C6F77437573746F6D697A65644275696C74496E456C656D656E74733A207B0A20202020202020207772697461626C653A20747275652C0A2020202020202020636F';
wwv_flow_imp.g_varchar2_table(213) := '6E666967757261626C653A2066616C73652C0A2020202020202020656E756D657261626C653A20747275652C0A202020202020202076616C75653A2066616C73650A2020202020207D0A202020207D29293B0A0A202020202F2A204578706C696369746C';
wwv_flow_imp.g_varchar2_table(214) := '7920666F7262696464656E207461677320286F766572726964657320414C4C4F5745445F544147532F4144445F5441475329202A2F0A202020206C657420464F524249445F54414753203D206E756C6C3B0A0A202020202F2A204578706C696369746C79';
wwv_flow_imp.g_varchar2_table(215) := '20666F7262696464656E206174747269627574657320286F766572726964657320414C4C4F5745445F415454522F4144445F4154545229202A2F0A202020206C657420464F524249445F41545452203D206E756C6C3B0A0A202020202F2A204465636964';
wwv_flow_imp.g_varchar2_table(216) := '652069662041524941206174747269627574657320617265206F6B6179202A2F0A202020206C657420414C4C4F575F415249415F41545452203D20747275653B0A0A202020202F2A2044656369646520696620637573746F6D2064617461206174747269';
wwv_flow_imp.g_varchar2_table(217) := '627574657320617265206F6B6179202A2F0A202020206C657420414C4C4F575F444154415F41545452203D20747275653B0A0A202020202F2A2044656369646520696620756E6B6E6F776E2070726F746F636F6C7320617265206F6B6179202A2F0A2020';
wwv_flow_imp.g_varchar2_table(218) := '20206C657420414C4C4F575F554E4B4E4F574E5F50524F544F434F4C53203D2066616C73653B0A0A202020202F2A204465636964652069662073656C662D636C6F73696E67207461677320696E20617474726962757465732061726520616C6C6F776564';
wwv_flow_imp.g_varchar2_table(219) := '2E0A20202020202A20557375616C6C792072656D6F7665642064756520746F2061206D58535320697373756520696E206A517565727920332E30202A2F0A202020206C657420414C4C4F575F53454C465F434C4F53455F494E5F41545452203D20747275';
wwv_flow_imp.g_varchar2_table(220) := '653B0A0A202020202F2A204F75747075742073686F756C64206265207361666520666F7220636F6D6D6F6E2074656D706C61746520656E67696E65732E0A20202020202A2054686973206D65616E732C20444F4D5075726966792072656D6F7665732064';
wwv_flow_imp.g_varchar2_table(221) := '61746120617474726962757465732C206D757374616368657320616E64204552420A20202020202A2F0A202020206C657420534146455F464F525F54454D504C41544553203D2066616C73653B0A0A202020202F2A2044656369646520696620646F6375';
wwv_flow_imp.g_varchar2_table(222) := '6D656E742077697468203C68746D6C3E2E2E2E2073686F756C642062652072657475726E6564202A2F0A202020206C65742057484F4C455F444F43554D454E54203D2066616C73653B0A0A202020202F2A20547261636B207768657468657220636F6E66';
wwv_flow_imp.g_varchar2_table(223) := '696720697320616C726561647920736574206F6E207468697320696E7374616E6365206F6620444F4D5075726966792E202A2F0A202020206C6574205345545F434F4E464947203D2066616C73653B0A0A202020202F2A2044656369646520696620616C';
wwv_flow_imp.g_varchar2_table(224) := '6C20656C656D656E74732028652E672E207374796C652C2073637269707429206D757374206265206368696C6472656E206F660A20202020202A20646F63756D656E742E626F64792E2042792064656661756C742C2062726F7773657273206D69676874';
wwv_flow_imp.g_varchar2_table(225) := '206D6F7665207468656D20746F20646F63756D656E742E68656164202A2F0A202020206C657420464F5243455F424F4459203D2066616C73653B0A0A202020202F2A20446563696465206966206120444F4D206048544D4C426F6479456C656D656E7460';
wwv_flow_imp.g_varchar2_table(226) := '2073686F756C642062652072657475726E65642C20696E7374656164206F6620612068746D6C0A20202020202A20737472696E6720286F722061205472757374656448544D4C206F626A6563742069662054727573746564205479706573206172652073';
wwv_flow_imp.g_varchar2_table(227) := '7570706F72746564292E0A20202020202A204966206057484F4C455F444F43554D454E546020697320656E61626C65642061206048544D4C48746D6C456C656D656E74602077696C6C2062652072657475726E656420696E73746561640A20202020202A';
wwv_flow_imp.g_varchar2_table(228) := '2F0A202020206C65742052455455524E5F444F4D203D2066616C73653B0A0A202020202F2A20446563696465206966206120444F4D2060446F63756D656E74467261676D656E74602073686F756C642062652072657475726E65642C20696E7374656164';
wwv_flow_imp.g_varchar2_table(229) := '206F6620612068746D6C0A20202020202A20737472696E672020286F722061205472757374656448544D4C206F626A65637420696620547275737465642054797065732061726520737570706F7274656429202A2F0A202020206C65742052455455524E';
wwv_flow_imp.g_varchar2_table(230) := '5F444F4D5F465241474D454E54203D2066616C73653B0A0A202020202F2A2054727920746F2072657475726E206120547275737465642054797065206F626A65637420696E7374656164206F66206120737472696E672C2072657475726E206120737472';
wwv_flow_imp.g_varchar2_table(231) := '696E6720696E0A20202020202A2063617365205472757374656420547970657320617265206E6F7420737570706F7274656420202A2F0A202020206C65742052455455524E5F545255535445445F54595045203D2066616C73653B0A0A202020202F2A20';
wwv_flow_imp.g_varchar2_table(232) := '4F75747075742073686F756C6420626520667265652066726F6D20444F4D20636C6F62626572696E672061747461636B733F0A20202020202A20546869732073616E6974697A6573206D61726B757073206E616D6564207769746820636F6C6C6964696E';
wwv_flow_imp.g_varchar2_table(233) := '672C20636C6F6262657261626C65206275696C742D696E20444F4D20415049732E0A20202020202A2F0A202020206C65742053414E4954495A455F444F4D203D20747275653B0A0A202020202F2A20416368696576652066756C6C20444F4D20436C6F62';
wwv_flow_imp.g_varchar2_table(234) := '626572696E672070726F74656374696F6E2062792069736F6C6174696E6720746865206E616D657370616365206F66206E616D65640A20202020202A2070726F7065727469657320616E64204A53207661726961626C65732C206D697469676174696E67';
wwv_flow_imp.g_varchar2_table(235) := '2061747461636B732074686174206162757365207468652048544D4C2F444F4D20737065632072756C65732E0A20202020202A0A20202020202A2048544D4C2F444F4D20737065632072756C6573207468617420656E61626C6520444F4D20436C6F6262';
wwv_flow_imp.g_varchar2_table(236) := '6572696E673A0A20202020202A2020202D204E616D656420416363657373206F6E2057696E646F772028C2A7372E332E33290A20202020202A2020202D20444F4D2054726565204163636573736F72732028C2A7332E312E35290A20202020202A202020';
wwv_flow_imp.g_varchar2_table(237) := '2D20466F726D20456C656D656E7420506172656E742D4368696C642052656C6174696F6E732028C2A7342E31302E33290A20202020202A2020202D20496672616D6520737263646F63202F204E65737465642057696E646F7750726F786965732028C2A7';
wwv_flow_imp.g_varchar2_table(238) := '342E382E35290A20202020202A2020202D2048544D4C436F6C6C656374696F6E2028C2A7342E322E31302E32290A20202020202A0A20202020202A204E616D6573706163652069736F6C6174696F6E20697320696D706C656D656E746564206279207072';
wwv_flow_imp.g_varchar2_table(239) := '65666978696E67206069646020616E6420606E616D656020617474726962757465730A20202020202A2077697468206120636F6E7374616E7420737472696E672C20692E652E2C2060757365722D636F6E74656E742D600A20202020202A2F0A20202020';
wwv_flow_imp.g_varchar2_table(240) := '6C65742053414E4954495A455F4E414D45445F50524F5053203D2066616C73653B0A20202020636F6E73742053414E4954495A455F4E414D45445F50524F50535F505245464958203D2027757365722D636F6E74656E742D273B0A0A202020202F2A204B';
wwv_flow_imp.g_varchar2_table(241) := '65657020656C656D656E7420636F6E74656E74207768656E2072656D6F76696E6720656C656D656E743F202A2F0A202020206C6574204B4545505F434F4E54454E54203D20747275653B0A0A202020202F2A204966206120604E6F646560206973207061';
wwv_flow_imp.g_varchar2_table(242) := '7373656420746F2073616E6974697A6528292C207468656E20706572666F726D732073616E6974697A6174696F6E20696E2D706C61636520696E73746561640A20202020202A206F6620696D706F7274696E6720697420696E746F2061206E657720446F';
wwv_flow_imp.g_varchar2_table(243) := '63756D656E7420616E642072657475726E696E6720612073616E6974697A656420636F7079202A2F0A202020206C657420494E5F504C414345203D2066616C73653B0A0A202020202F2A20416C6C6F77207573616765206F662070726F66696C6573206C';
wwv_flow_imp.g_varchar2_table(244) := '696B652068746D6C2C2073766720616E64206D6174684D6C202A2F0A202020206C6574205553455F50524F46494C4553203D207B7D3B0A0A202020202F2A205461677320746F2069676E6F726520636F6E74656E74206F66207768656E204B4545505F43';
wwv_flow_imp.g_varchar2_table(245) := '4F4E54454E542069732074727565202A2F0A202020206C657420464F524249445F434F4E54454E5453203D206E756C6C3B0A20202020636F6E73742044454641554C545F464F524249445F434F4E54454E5453203D20616464546F536574287B7D2C205B';
wwv_flow_imp.g_varchar2_table(246) := '27616E6E6F746174696F6E2D786D6C272C2027617564696F272C2027636F6C67726F7570272C202764657363272C2027666F726569676E6F626A656374272C202768656164272C2027696672616D65272C20276D617468272C20276D69272C20276D6E27';
wwv_flow_imp.g_varchar2_table(247) := '2C20276D6F272C20276D73272C20276D74657874272C20276E6F656D626564272C20276E6F6672616D6573272C20276E6F736372697074272C2027706C61696E74657874272C2027736372697074272C20277374796C65272C2027737667272C20277465';
wwv_flow_imp.g_varchar2_table(248) := '6D706C617465272C20277468656164272C20277469746C65272C2027766964656F272C2027786D70275D293B0A0A202020202F2A2054616773207468617420617265207361666520666F7220646174613A2055524973202A2F0A202020206C6574204441';
wwv_flow_imp.g_varchar2_table(249) := '54415F5552495F54414753203D206E756C6C3B0A20202020636F6E73742044454641554C545F444154415F5552495F54414753203D20616464546F536574287B7D2C205B27617564696F272C2027766964656F272C2027696D67272C2027736F75726365';
wwv_flow_imp.g_varchar2_table(250) := '272C2027696D616765272C2027747261636B275D293B0A0A202020202F2A2041747472696275746573207361666520666F722076616C756573206C696B6520226A6176617363726970743A22202A2F0A202020206C6574205552495F534146455F415454';
wwv_flow_imp.g_varchar2_table(251) := '52494255544553203D206E756C6C3B0A20202020636F6E73742044454641554C545F5552495F534146455F41545452494255544553203D20616464546F536574287B7D2C205B27616C74272C2027636C617373272C2027666F72272C20276964272C2027';
wwv_flow_imp.g_varchar2_table(252) := '6C6162656C272C20276E616D65272C20277061747465726E272C2027706C616365686F6C646572272C2027726F6C65272C202773756D6D617279272C20277469746C65272C202776616C7565272C20277374796C65272C2027786D6C6E73275D293B0A20';
wwv_flow_imp.g_varchar2_table(253) := '202020636F6E7374204D4154484D4C5F4E414D455350414345203D2027687474703A2F2F7777772E77332E6F72672F313939382F4D6174682F4D6174684D4C273B0A20202020636F6E7374205356475F4E414D455350414345203D2027687474703A2F2F';
wwv_flow_imp.g_varchar2_table(254) := '7777772E77332E6F72672F323030302F737667273B0A20202020636F6E73742048544D4C5F4E414D455350414345203D2027687474703A2F2F7777772E77332E6F72672F313939392F7868746D6C273B0A202020202F2A20446F63756D656E74206E616D';
wwv_flow_imp.g_varchar2_table(255) := '657370616365202A2F0A202020206C6574204E414D455350414345203D2048544D4C5F4E414D4553504143453B0A202020206C65742049535F454D5054595F494E505554203D2066616C73653B0A0A202020202F2A20416C6C6F776564205848544D4C2B';
wwv_flow_imp.g_varchar2_table(256) := '584D4C206E616D65737061636573202A2F0A202020206C657420414C4C4F5745445F4E414D45535041434553203D206E756C6C3B0A20202020636F6E73742044454641554C545F414C4C4F5745445F4E414D45535041434553203D20616464546F536574';
wwv_flow_imp.g_varchar2_table(257) := '287B7D2C205B4D4154484D4C5F4E414D4553504143452C205356475F4E414D4553504143452C2048544D4C5F4E414D4553504143455D2C20737472696E67546F537472696E67293B0A0A202020202F2A2050617273696E67206F66207374726963742058';
wwv_flow_imp.g_varchar2_table(258) := '48544D4C20646F63756D656E7473202A2F0A202020206C6574205041525345525F4D454449415F54595045203D206E756C6C3B0A20202020636F6E737420535550504F525445445F5041525345525F4D454449415F5459504553203D205B276170706C69';
wwv_flow_imp.g_varchar2_table(259) := '636174696F6E2F7868746D6C2B786D6C272C2027746578742F68746D6C275D3B0A20202020636F6E73742044454641554C545F5041525345525F4D454449415F54595045203D2027746578742F68746D6C273B0A202020206C6574207472616E73666F72';
wwv_flow_imp.g_varchar2_table(260) := '6D4361736546756E63203D206E756C6C3B0A0A202020202F2A204B6565702061207265666572656E636520746F20636F6E66696720746F207061737320746F20686F6F6B73202A2F0A202020206C657420434F4E464947203D206E756C6C3B0A0A202020';
wwv_flow_imp.g_varchar2_table(261) := '202F2A20496465616C6C792C20646F206E6F7420746F75636820616E797468696E672062656C6F772074686973206C696E65202A2F0A202020202F2A205F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F';
wwv_flow_imp.g_varchar2_table(262) := '5F5F5F5F5F5F5F202A2F0A0A20202020636F6E737420666F726D456C656D656E74203D20646F63756D656E742E637265617465456C656D656E742827666F726D27293B0A20202020636F6E737420697352656765784F7246756E6374696F6E203D206675';
wwv_flow_imp.g_varchar2_table(263) := '6E6374696F6E20697352656765784F7246756E6374696F6E287465737456616C756529207B0A20202020202072657475726E207465737456616C756520696E7374616E63656F6620526567457870207C7C207465737456616C756520696E7374616E6365';
wwv_flow_imp.g_varchar2_table(264) := '6F662046756E6374696F6E3B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F7061727365436F6E6669670A20202020202A0A20202020202A2040706172616D20207B4F626A6563747D20636667206F7074696F6E616C20636F6E66696720';
wwv_flow_imp.g_varchar2_table(265) := '6C69746572616C0A20202020202A2F0A202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520636F6D706C65786974790A20202020636F6E7374205F7061727365436F6E666967203D2066756E6374696F6E205F706172736543';
wwv_flow_imp.g_varchar2_table(266) := '6F6E6669672829207B0A2020202020206C657420636667203D20617267756D656E74732E6C656E677468203E203020262620617267756D656E74735B305D20213D3D20756E646566696E6564203F20617267756D656E74735B305D203A207B7D3B0A2020';
wwv_flow_imp.g_varchar2_table(267) := '2020202069662028434F4E46494720262620434F4E464947203D3D3D2063666729207B0A202020202020202072657475726E3B0A2020202020207D0A0A2020202020202F2A20536869656C6420636F6E66696775726174696F6E206F626A656374206672';
wwv_flow_imp.g_varchar2_table(268) := '6F6D2074616D706572696E67202A2F0A2020202020206966202821636667207C7C20747970656F662063666720213D3D20276F626A6563742729207B0A2020202020202020636667203D207B7D3B0A2020202020207D0A0A2020202020202F2A20536869';
wwv_flow_imp.g_varchar2_table(269) := '656C6420636F6E66696775726174696F6E206F626A6563742066726F6D2070726F746F7479706520706F6C6C7574696F6E202A2F0A202020202020636667203D20636C6F6E6528636667293B0A2020202020205041525345525F4D454449415F54595045';
wwv_flow_imp.g_varchar2_table(270) := '203D0A2020202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520756E69636F726E2F7072656665722D696E636C756465730A202020202020535550504F525445445F5041525345525F4D454449415F54595045532E696E6465';
wwv_flow_imp.g_varchar2_table(271) := '784F66286366672E5041525345525F4D454449415F5459504529203D3D3D202D31203F2044454641554C545F5041525345525F4D454449415F54595045203A206366672E5041525345525F4D454449415F545950453B0A0A2020202020202F2F2048544D';
wwv_flow_imp.g_varchar2_table(272) := '4C207461677320616E64206174747269627574657320617265206E6F7420636173652D73656E7369746976652C20636F6E76657274696E6720746F206C6F776572636173652E204B656570696E67205848544D4C2061732069732E0A2020202020207472';
wwv_flow_imp.g_varchar2_table(273) := '616E73666F726D4361736546756E63203D205041525345525F4D454449415F54595045203D3D3D20276170706C69636174696F6E2F7868746D6C2B786D6C27203F20737472696E67546F537472696E67203A20737472696E67546F4C6F77657243617365';
wwv_flow_imp.g_varchar2_table(274) := '3B0A0A2020202020202F2A2053657420636F6E66696775726174696F6E20706172616D6574657273202A2F0A202020202020414C4C4F5745445F54414753203D206F626A6563744861734F776E50726F7065727479286366672C2027414C4C4F5745445F';
wwv_flow_imp.g_varchar2_table(275) := '544147532729203F20616464546F536574287B7D2C206366672E414C4C4F5745445F544147532C207472616E73666F726D4361736546756E6329203A2044454641554C545F414C4C4F5745445F544147533B0A202020202020414C4C4F5745445F415454';
wwv_flow_imp.g_varchar2_table(276) := '52203D206F626A6563744861734F776E50726F7065727479286366672C2027414C4C4F5745445F415454522729203F20616464546F536574287B7D2C206366672E414C4C4F5745445F415454522C207472616E73666F726D4361736546756E6329203A20';
wwv_flow_imp.g_varchar2_table(277) := '44454641554C545F414C4C4F5745445F415454523B0A202020202020414C4C4F5745445F4E414D45535041434553203D206F626A6563744861734F776E50726F7065727479286366672C2027414C4C4F5745445F4E414D455350414345532729203F2061';
wwv_flow_imp.g_varchar2_table(278) := '6464546F536574287B7D2C206366672E414C4C4F5745445F4E414D455350414345532C20737472696E67546F537472696E6729203A2044454641554C545F414C4C4F5745445F4E414D455350414345533B0A2020202020205552495F534146455F415454';
wwv_flow_imp.g_varchar2_table(279) := '52494255544553203D206F626A6563744861734F776E50726F7065727479286366672C20274144445F5552495F534146455F415454522729203F20616464546F53657428636C6F6E652844454641554C545F5552495F534146455F415454524942555445';
wwv_flow_imp.g_varchar2_table(280) := '53292C0A2020202020202F2F2065736C696E742D64697361626C652D6C696E6520696E64656E740A2020202020206366672E4144445F5552495F534146455F415454522C0A2020202020202F2F2065736C696E742D64697361626C652D6C696E6520696E';
wwv_flow_imp.g_varchar2_table(281) := '64656E740A2020202020207472616E73666F726D4361736546756E63202F2F2065736C696E742D64697361626C652D6C696E6520696E64656E740A20202020202029202F2F2065736C696E742D64697361626C652D6C696E6520696E64656E740A202020';
wwv_flow_imp.g_varchar2_table(282) := '2020203A2044454641554C545F5552495F534146455F415454524942555445533B0A202020202020444154415F5552495F54414753203D206F626A6563744861734F776E50726F7065727479286366672C20274144445F444154415F5552495F54414753';
wwv_flow_imp.g_varchar2_table(283) := '2729203F20616464546F53657428636C6F6E652844454641554C545F444154415F5552495F54414753292C0A2020202020202F2F2065736C696E742D64697361626C652D6C696E6520696E64656E740A2020202020206366672E4144445F444154415F55';
wwv_flow_imp.g_varchar2_table(284) := '52495F544147532C0A2020202020202F2F2065736C696E742D64697361626C652D6C696E6520696E64656E740A2020202020207472616E73666F726D4361736546756E63202F2F2065736C696E742D64697361626C652D6C696E6520696E64656E740A20';
wwv_flow_imp.g_varchar2_table(285) := '202020202029202F2F2065736C696E742D64697361626C652D6C696E6520696E64656E740A2020202020203A2044454641554C545F444154415F5552495F544147533B0A202020202020464F524249445F434F4E54454E5453203D206F626A6563744861';
wwv_flow_imp.g_varchar2_table(286) := '734F776E50726F7065727479286366672C2027464F524249445F434F4E54454E54532729203F20616464546F536574287B7D2C206366672E464F524249445F434F4E54454E54532C207472616E73666F726D4361736546756E6329203A2044454641554C';
wwv_flow_imp.g_varchar2_table(287) := '545F464F524249445F434F4E54454E54533B0A202020202020464F524249445F54414753203D206F626A6563744861734F776E50726F7065727479286366672C2027464F524249445F544147532729203F20616464546F536574287B7D2C206366672E46';
wwv_flow_imp.g_varchar2_table(288) := '4F524249445F544147532C207472616E73666F726D4361736546756E6329203A207B7D3B0A202020202020464F524249445F41545452203D206F626A6563744861734F776E50726F7065727479286366672C2027464F524249445F415454522729203F20';
wwv_flow_imp.g_varchar2_table(289) := '616464546F536574287B7D2C206366672E464F524249445F415454522C207472616E73666F726D4361736546756E6329203A207B7D3B0A2020202020205553455F50524F46494C4553203D206F626A6563744861734F776E50726F706572747928636667';
wwv_flow_imp.g_varchar2_table(290) := '2C20275553455F50524F46494C45532729203F206366672E5553455F50524F46494C4553203A2066616C73653B0A202020202020414C4C4F575F415249415F41545452203D206366672E414C4C4F575F415249415F4154545220213D3D2066616C73653B';
wwv_flow_imp.g_varchar2_table(291) := '202F2F2044656661756C7420747275650A202020202020414C4C4F575F444154415F41545452203D206366672E414C4C4F575F444154415F4154545220213D3D2066616C73653B202F2F2044656661756C7420747275650A202020202020414C4C4F575F';
wwv_flow_imp.g_varchar2_table(292) := '554E4B4E4F574E5F50524F544F434F4C53203D206366672E414C4C4F575F554E4B4E4F574E5F50524F544F434F4C53207C7C2066616C73653B202F2F2044656661756C742066616C73650A202020202020414C4C4F575F53454C465F434C4F53455F494E';
wwv_flow_imp.g_varchar2_table(293) := '5F41545452203D206366672E414C4C4F575F53454C465F434C4F53455F494E5F4154545220213D3D2066616C73653B202F2F2044656661756C7420747275650A202020202020534146455F464F525F54454D504C41544553203D206366672E534146455F';
wwv_flow_imp.g_varchar2_table(294) := '464F525F54454D504C41544553207C7C2066616C73653B202F2F2044656661756C742066616C73650A20202020202057484F4C455F444F43554D454E54203D206366672E57484F4C455F444F43554D454E54207C7C2066616C73653B202F2F2044656661';
wwv_flow_imp.g_varchar2_table(295) := '756C742066616C73650A20202020202052455455524E5F444F4D203D206366672E52455455524E5F444F4D207C7C2066616C73653B202F2F2044656661756C742066616C73650A20202020202052455455524E5F444F4D5F465241474D454E54203D2063';
wwv_flow_imp.g_varchar2_table(296) := '66672E52455455524E5F444F4D5F465241474D454E54207C7C2066616C73653B202F2F2044656661756C742066616C73650A20202020202052455455524E5F545255535445445F54595045203D206366672E52455455524E5F545255535445445F545950';
wwv_flow_imp.g_varchar2_table(297) := '45207C7C2066616C73653B202F2F2044656661756C742066616C73650A202020202020464F5243455F424F4459203D206366672E464F5243455F424F4459207C7C2066616C73653B202F2F2044656661756C742066616C73650A20202020202053414E49';
wwv_flow_imp.g_varchar2_table(298) := '54495A455F444F4D203D206366672E53414E4954495A455F444F4D20213D3D2066616C73653B202F2F2044656661756C7420747275650A20202020202053414E4954495A455F4E414D45445F50524F5053203D206366672E53414E4954495A455F4E414D';
wwv_flow_imp.g_varchar2_table(299) := '45445F50524F5053207C7C2066616C73653B202F2F2044656661756C742066616C73650A2020202020204B4545505F434F4E54454E54203D206366672E4B4545505F434F4E54454E5420213D3D2066616C73653B202F2F2044656661756C742074727565';
wwv_flow_imp.g_varchar2_table(300) := '0A202020202020494E5F504C414345203D206366672E494E5F504C414345207C7C2066616C73653B202F2F2044656661756C742066616C73650A20202020202049535F414C4C4F5745445F5552492431203D206366672E414C4C4F5745445F5552495F52';
wwv_flow_imp.g_varchar2_table(301) := '4547455850207C7C2049535F414C4C4F5745445F5552493B0A2020202020204E414D455350414345203D206366672E4E414D455350414345207C7C2048544D4C5F4E414D4553504143453B0A202020202020435553544F4D5F454C454D454E545F48414E';
wwv_flow_imp.g_varchar2_table(302) := '444C494E47203D206366672E435553544F4D5F454C454D454E545F48414E444C494E47207C7C207B7D3B0A202020202020696620286366672E435553544F4D5F454C454D454E545F48414E444C494E4720262620697352656765784F7246756E6374696F';
wwv_flow_imp.g_varchar2_table(303) := '6E286366672E435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B2929207B0A2020202020202020435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B203D206366672E4355';
wwv_flow_imp.g_varchar2_table(304) := '53544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B3B0A2020202020207D0A202020202020696620286366672E435553544F4D5F454C454D454E545F48414E444C494E4720262620697352656765784F7246756E637469';
wwv_flow_imp.g_varchar2_table(305) := '6F6E286366672E435553544F4D5F454C454D454E545F48414E444C494E472E6174747269627574654E616D65436865636B2929207B0A2020202020202020435553544F4D5F454C454D454E545F48414E444C494E472E6174747269627574654E616D6543';
wwv_flow_imp.g_varchar2_table(306) := '6865636B203D206366672E435553544F4D5F454C454D454E545F48414E444C494E472E6174747269627574654E616D65436865636B3B0A2020202020207D0A202020202020696620286366672E435553544F4D5F454C454D454E545F48414E444C494E47';
wwv_flow_imp.g_varchar2_table(307) := '20262620747970656F66206366672E435553544F4D5F454C454D454E545F48414E444C494E472E616C6C6F77437573746F6D697A65644275696C74496E456C656D656E7473203D3D3D2027626F6F6C65616E2729207B0A2020202020202020435553544F';
wwv_flow_imp.g_varchar2_table(308) := '4D5F454C454D454E545F48414E444C494E472E616C6C6F77437573746F6D697A65644275696C74496E456C656D656E7473203D206366672E435553544F4D5F454C454D454E545F48414E444C494E472E616C6C6F77437573746F6D697A65644275696C74';
wwv_flow_imp.g_varchar2_table(309) := '496E456C656D656E74733B0A2020202020207D0A20202020202069662028534146455F464F525F54454D504C4154455329207B0A2020202020202020414C4C4F575F444154415F41545452203D2066616C73653B0A2020202020207D0A20202020202069';
wwv_flow_imp.g_varchar2_table(310) := '66202852455455524E5F444F4D5F465241474D454E5429207B0A202020202020202052455455524E5F444F4D203D20747275653B0A2020202020207D0A0A2020202020202F2A2050617273652070726F66696C6520696E666F202A2F0A20202020202069';
wwv_flow_imp.g_varchar2_table(311) := '6620285553455F50524F46494C455329207B0A2020202020202020414C4C4F5745445F54414753203D20616464546F536574287B7D2C2074657874293B0A2020202020202020414C4C4F5745445F41545452203D205B5D3B0A2020202020202020696620';
wwv_flow_imp.g_varchar2_table(312) := '285553455F50524F46494C45532E68746D6C203D3D3D207472756529207B0A20202020202020202020616464546F53657428414C4C4F5745445F544147532C2068746D6C2431293B0A20202020202020202020616464546F53657428414C4C4F5745445F';
wwv_flow_imp.g_varchar2_table(313) := '415454522C2068746D6C293B0A20202020202020207D0A2020202020202020696620285553455F50524F46494C45532E737667203D3D3D207472756529207B0A20202020202020202020616464546F53657428414C4C4F5745445F544147532C20737667';
wwv_flow_imp.g_varchar2_table(314) := '2431293B0A20202020202020202020616464546F53657428414C4C4F5745445F415454522C20737667293B0A20202020202020202020616464546F53657428414C4C4F5745445F415454522C20786D6C293B0A20202020202020207D0A20202020202020';
wwv_flow_imp.g_varchar2_table(315) := '20696620285553455F50524F46494C45532E73766746696C74657273203D3D3D207472756529207B0A20202020202020202020616464546F53657428414C4C4F5745445F544147532C2073766746696C74657273293B0A20202020202020202020616464';
wwv_flow_imp.g_varchar2_table(316) := '546F53657428414C4C4F5745445F415454522C20737667293B0A20202020202020202020616464546F53657428414C4C4F5745445F415454522C20786D6C293B0A20202020202020207D0A2020202020202020696620285553455F50524F46494C45532E';
wwv_flow_imp.g_varchar2_table(317) := '6D6174684D6C203D3D3D207472756529207B0A20202020202020202020616464546F53657428414C4C4F5745445F544147532C206D6174684D6C2431293B0A20202020202020202020616464546F53657428414C4C4F5745445F415454522C206D617468';
wwv_flow_imp.g_varchar2_table(318) := '4D6C293B0A20202020202020202020616464546F53657428414C4C4F5745445F415454522C20786D6C293B0A20202020202020207D0A2020202020207D0A0A2020202020202F2A204D6572676520636F6E66696775726174696F6E20706172616D657465';
wwv_flow_imp.g_varchar2_table(319) := '7273202A2F0A202020202020696620286366672E4144445F5441475329207B0A202020202020202069662028414C4C4F5745445F54414753203D3D3D2044454641554C545F414C4C4F5745445F5441475329207B0A20202020202020202020414C4C4F57';
wwv_flow_imp.g_varchar2_table(320) := '45445F54414753203D20636C6F6E6528414C4C4F5745445F54414753293B0A20202020202020207D0A2020202020202020616464546F53657428414C4C4F5745445F544147532C206366672E4144445F544147532C207472616E73666F726D4361736546';
wwv_flow_imp.g_varchar2_table(321) := '756E63293B0A2020202020207D0A202020202020696620286366672E4144445F4154545229207B0A202020202020202069662028414C4C4F5745445F41545452203D3D3D2044454641554C545F414C4C4F5745445F4154545229207B0A20202020202020';
wwv_flow_imp.g_varchar2_table(322) := '202020414C4C4F5745445F41545452203D20636C6F6E6528414C4C4F5745445F41545452293B0A20202020202020207D0A2020202020202020616464546F53657428414C4C4F5745445F415454522C206366672E4144445F415454522C207472616E7366';
wwv_flow_imp.g_varchar2_table(323) := '6F726D4361736546756E63293B0A2020202020207D0A202020202020696620286366672E4144445F5552495F534146455F4154545229207B0A2020202020202020616464546F536574285552495F534146455F415454524942555445532C206366672E41';
wwv_flow_imp.g_varchar2_table(324) := '44445F5552495F534146455F415454522C207472616E73666F726D4361736546756E63293B0A2020202020207D0A202020202020696620286366672E464F524249445F434F4E54454E545329207B0A202020202020202069662028464F524249445F434F';
wwv_flow_imp.g_varchar2_table(325) := '4E54454E5453203D3D3D2044454641554C545F464F524249445F434F4E54454E545329207B0A20202020202020202020464F524249445F434F4E54454E5453203D20636C6F6E6528464F524249445F434F4E54454E5453293B0A20202020202020207D0A';
wwv_flow_imp.g_varchar2_table(326) := '2020202020202020616464546F53657428464F524249445F434F4E54454E54532C206366672E464F524249445F434F4E54454E54532C207472616E73666F726D4361736546756E63293B0A2020202020207D0A0A2020202020202F2A2041646420237465';
wwv_flow_imp.g_varchar2_table(327) := '787420696E2063617365204B4545505F434F4E54454E542069732073657420746F2074727565202A2F0A202020202020696620284B4545505F434F4E54454E5429207B0A2020202020202020414C4C4F5745445F544147535B272374657874275D203D20';
wwv_flow_imp.g_varchar2_table(328) := '747275653B0A2020202020207D0A0A2020202020202F2A204164642068746D6C2C206865616420616E6420626F647920746F20414C4C4F5745445F5441475320696E20636173652057484F4C455F444F43554D454E542069732074727565202A2F0A2020';
wwv_flow_imp.g_varchar2_table(329) := '202020206966202857484F4C455F444F43554D454E5429207B0A2020202020202020616464546F53657428414C4C4F5745445F544147532C205B2768746D6C272C202768656164272C2027626F6479275D293B0A2020202020207D0A0A2020202020202F';
wwv_flow_imp.g_varchar2_table(330) := '2A204164642074626F647920746F20414C4C4F5745445F5441475320696E2063617365207461626C657320617265207065726D69747465642C2073656520233238362C2023333635202A2F0A20202020202069662028414C4C4F5745445F544147532E74';
wwv_flow_imp.g_varchar2_table(331) := '61626C6529207B0A2020202020202020616464546F53657428414C4C4F5745445F544147532C205B2774626F6479275D293B0A202020202020202064656C65746520464F524249445F544147532E74626F64793B0A2020202020207D0A20202020202069';
wwv_flow_imp.g_varchar2_table(332) := '6620286366672E545255535445445F54595045535F504F4C49435929207B0A202020202020202069662028747970656F66206366672E545255535445445F54595045535F504F4C4943592E63726561746548544D4C20213D3D202766756E6374696F6E27';
wwv_flow_imp.g_varchar2_table(333) := '29207B0A202020202020202020207468726F7720747970654572726F724372656174652827545255535445445F54595045535F504F4C49435920636F6E66696775726174696F6E206F7074696F6E206D7573742070726F76696465206120226372656174';
wwv_flow_imp.g_varchar2_table(334) := '6548544D4C2220686F6F6B2E27293B0A20202020202020207D0A202020202020202069662028747970656F66206366672E545255535445445F54595045535F504F4C4943592E63726561746553637269707455524C20213D3D202766756E6374696F6E27';
wwv_flow_imp.g_varchar2_table(335) := '29207B0A202020202020202020207468726F7720747970654572726F724372656174652827545255535445445F54595045535F504F4C49435920636F6E66696775726174696F6E206F7074696F6E206D7573742070726F76696465206120226372656174';
wwv_flow_imp.g_varchar2_table(336) := '6553637269707455524C2220686F6F6B2E27293B0A20202020202020207D0A0A20202020202020202F2F204F7665727772697465206578697374696E672054727573746564547970657320706F6C6963792E0A2020202020202020747275737465645479';
wwv_flow_imp.g_varchar2_table(337) := '706573506F6C696379203D206366672E545255535445445F54595045535F504F4C4943593B0A0A20202020202020202F2F205369676E206C6F63616C207661726961626C6573207265717569726564206279206073616E6974697A65602E0A2020202020';
wwv_flow_imp.g_varchar2_table(338) := '202020656D70747948544D4C203D20747275737465645479706573506F6C6963792E63726561746548544D4C282727293B0A2020202020207D20656C7365207B0A20202020202020202F2F20556E696E697469616C697A656420706F6C6963792C206174';
wwv_flow_imp.g_varchar2_table(339) := '74656D707420746F20696E697469616C697A652074686520696E7465726E616C20646F6D70757269667920706F6C6963792E0A202020202020202069662028747275737465645479706573506F6C696379203D3D3D20756E646566696E656429207B0A20';
wwv_flow_imp.g_varchar2_table(340) := '202020202020202020747275737465645479706573506F6C696379203D205F637265617465547275737465645479706573506F6C696379287472757374656454797065732C2063757272656E74536372697074293B0A20202020202020207D0A0A202020';
wwv_flow_imp.g_varchar2_table(341) := '20202020202F2F204966206372656174696E672074686520696E7465726E616C20706F6C69637920737563636565646564207369676E20696E7465726E616C207661726961626C65732E0A20202020202020206966202874727573746564547970657350';
wwv_flow_imp.g_varchar2_table(342) := '6F6C69637920213D3D206E756C6C20262620747970656F6620656D70747948544D4C203D3D3D2027737472696E672729207B0A20202020202020202020656D70747948544D4C203D20747275737465645479706573506F6C6963792E6372656174654854';
wwv_flow_imp.g_varchar2_table(343) := '4D4C282727293B0A20202020202020207D0A2020202020207D0A0A2020202020202F2F2050726576656E742066757274686572206D616E6970756C6174696F6E206F6620636F6E66696775726174696F6E2E0A2020202020202F2F204E6F742061766169';
wwv_flow_imp.g_varchar2_table(344) := '6C61626C6520696E204945382C2053616661726920352C206574632E0A20202020202069662028667265657A6529207B0A2020202020202020667265657A6528636667293B0A2020202020207D0A202020202020434F4E464947203D206366673B0A2020';
wwv_flow_imp.g_varchar2_table(345) := '20207D3B0A20202020636F6E7374204D4154484D4C5F544558545F494E544547524154494F4E5F504F494E5453203D20616464546F536574287B7D2C205B276D69272C20276D6F272C20276D6E272C20276D73272C20276D74657874275D293B0A202020';
wwv_flow_imp.g_varchar2_table(346) := '20636F6E73742048544D4C5F494E544547524154494F4E5F504F494E5453203D20616464546F536574287B7D2C205B27666F726569676E6F626A656374272C202764657363272C20277469746C65272C2027616E6E6F746174696F6E2D786D6C275D293B';
wwv_flow_imp.g_varchar2_table(347) := '0A0A202020202F2F204365727461696E20656C656D656E74732061726520616C6C6F77656420696E20626F74682053564720616E642048544D4C0A202020202F2F206E616D6573706163652E205765206E65656420746F2073706563696679207468656D';
wwv_flow_imp.g_varchar2_table(348) := '206578706C696369746C790A202020202F2F20736F2074686174207468657920646F6E277420676574206572726F6E656F75736C792064656C657465642066726F6D0A202020202F2F2048544D4C206E616D6573706163652E0A20202020636F6E737420';
wwv_flow_imp.g_varchar2_table(349) := '434F4D4D4F4E5F5356475F414E445F48544D4C5F454C454D454E5453203D20616464546F536574287B7D2C205B277469746C65272C20277374796C65272C2027666F6E74272C202761272C2027736372697074275D293B0A0A202020202F2A204B656570';
wwv_flow_imp.g_varchar2_table(350) := '20747261636B206F6620616C6C20706F737369626C652053564720616E64204D6174684D4C20746167730A20202020202A20736F20746861742077652063616E20706572666F726D20746865206E616D65737061636520636865636B730A20202020202A';
wwv_flow_imp.g_varchar2_table(351) := '20636F72726563746C792E202A2F0A20202020636F6E737420414C4C5F5356475F54414753203D20616464546F536574287B7D2C205B2E2E2E73766724312C202E2E2E73766746696C746572732C202E2E2E737667446973616C6C6F7765645D293B0A20';
wwv_flow_imp.g_varchar2_table(352) := '202020636F6E737420414C4C5F4D4154484D4C5F54414753203D20616464546F536574287B7D2C205B2E2E2E6D6174684D6C24312C202E2E2E6D6174684D6C446973616C6C6F7765645D293B0A0A202020202F2A2A0A20202020202A2040706172616D20';
wwv_flow_imp.g_varchar2_table(353) := '207B456C656D656E747D20656C656D656E74206120444F4D20656C656D656E742077686F7365206E616D657370616365206973206265696E6720636865636B65640A20202020202A204072657475726E73207B626F6F6C65616E7D2052657475726E2066';
wwv_flow_imp.g_varchar2_table(354) := '616C73652069662074686520656C656D656E742068617320610A20202020202A20206E616D6573706163652074686174206120737065632D636F6D706C69616E742070617273657220776F756C64206E657665720A20202020202A202072657475726E2E';
wwv_flow_imp.g_varchar2_table(355) := '2052657475726E2074727565206F74686572776973652E0A20202020202A2F0A20202020636F6E7374205F636865636B56616C69644E616D657370616365203D2066756E6374696F6E205F636865636B56616C69644E616D65737061636528656C656D65';
wwv_flow_imp.g_varchar2_table(356) := '6E7429207B0A2020202020206C657420706172656E74203D20676574506172656E744E6F646528656C656D656E74293B0A0A2020202020202F2F20496E204A53444F4D2C20696620776527726520696E7369646520736861646F7720444F4D2C20746865';
wwv_flow_imp.g_varchar2_table(357) := '6E20706172656E744E6F64650A2020202020202F2F2063616E206265206E756C6C2E205765206A7573742073696D756C61746520706172656E7420696E207468697320636173652E0A2020202020206966202821706172656E74207C7C2021706172656E';
wwv_flow_imp.g_varchar2_table(358) := '742E7461674E616D6529207B0A2020202020202020706172656E74203D207B0A202020202020202020206E616D6573706163655552493A204E414D4553504143452C0A202020202020202020207461674E616D653A202774656D706C617465270A202020';
wwv_flow_imp.g_varchar2_table(359) := '20202020207D3B0A2020202020207D0A202020202020636F6E7374207461674E616D65203D20737472696E67546F4C6F7765724361736528656C656D656E742E7461674E616D65293B0A202020202020636F6E737420706172656E745461674E616D6520';
wwv_flow_imp.g_varchar2_table(360) := '3D20737472696E67546F4C6F7765724361736528706172656E742E7461674E616D65293B0A2020202020206966202821414C4C4F5745445F4E414D455350414345535B656C656D656E742E6E616D6573706163655552495D29207B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(361) := '72657475726E2066616C73653B0A2020202020207D0A20202020202069662028656C656D656E742E6E616D657370616365555249203D3D3D205356475F4E414D45535041434529207B0A20202020202020202F2F20546865206F6E6C792077617920746F';
wwv_flow_imp.g_varchar2_table(362) := '207377697463682066726F6D2048544D4C206E616D65737061636520746F205356470A20202020202020202F2F20697320766961203C7376673E2E2049662069742068617070656E732076696120616E79206F74686572207461672C207468656E0A2020';
wwv_flow_imp.g_varchar2_table(363) := '2020202020202F2F2069742073686F756C64206265206B696C6C65642E0A202020202020202069662028706172656E742E6E616D657370616365555249203D3D3D2048544D4C5F4E414D45535041434529207B0A2020202020202020202072657475726E';
wwv_flow_imp.g_varchar2_table(364) := '207461674E616D65203D3D3D2027737667273B0A20202020202020207D0A0A20202020202020202F2F20546865206F6E6C792077617920746F207377697463682066726F6D204D6174684D4C20746F2053564720697320766961600A2020202020202020';
wwv_flow_imp.g_varchar2_table(365) := '2F2F2073766720696620706172656E7420697320656974686572203C616E6E6F746174696F6E2D786D6C3E206F72204D6174684D4C0A20202020202020202F2F207465787420696E746567726174696F6E20706F696E74732E0A20202020202020206966';
wwv_flow_imp.g_varchar2_table(366) := '2028706172656E742E6E616D657370616365555249203D3D3D204D4154484D4C5F4E414D45535041434529207B0A2020202020202020202072657475726E207461674E616D65203D3D3D2027737667272026262028706172656E745461674E616D65203D';
wwv_flow_imp.g_varchar2_table(367) := '3D3D2027616E6E6F746174696F6E2D786D6C27207C7C204D4154484D4C5F544558545F494E544547524154494F4E5F504F494E54535B706172656E745461674E616D655D293B0A20202020202020207D0A0A20202020202020202F2F205765206F6E6C79';
wwv_flow_imp.g_varchar2_table(368) := '20616C6C6F7720656C656D656E747320746861742061726520646566696E656420696E205356470A20202020202020202F2F20737065632E20416C6C206F74686572732061726520646973616C6C6F77656420696E20535647206E616D6573706163652E';
wwv_flow_imp.g_varchar2_table(369) := '0A202020202020202072657475726E20426F6F6C65616E28414C4C5F5356475F544147535B7461674E616D655D293B0A2020202020207D0A20202020202069662028656C656D656E742E6E616D657370616365555249203D3D3D204D4154484D4C5F4E41';
wwv_flow_imp.g_varchar2_table(370) := '4D45535041434529207B0A20202020202020202F2F20546865206F6E6C792077617920746F207377697463682066726F6D2048544D4C206E616D65737061636520746F204D6174684D4C0A20202020202020202F2F20697320766961203C6D6174683E2E';
wwv_flow_imp.g_varchar2_table(371) := '2049662069742068617070656E732076696120616E79206F74686572207461672C207468656E0A20202020202020202F2F2069742073686F756C64206265206B696C6C65642E0A202020202020202069662028706172656E742E6E616D65737061636555';
wwv_flow_imp.g_varchar2_table(372) := '5249203D3D3D2048544D4C5F4E414D45535041434529207B0A2020202020202020202072657475726E207461674E616D65203D3D3D20276D617468273B0A20202020202020207D0A0A20202020202020202F2F20546865206F6E6C792077617920746F20';
wwv_flow_imp.g_varchar2_table(373) := '7377697463682066726F6D2053564720746F204D6174684D4C206973207669610A20202020202020202F2F203C6D6174683E20616E642048544D4C20696E746567726174696F6E20706F696E74730A202020202020202069662028706172656E742E6E61';
wwv_flow_imp.g_varchar2_table(374) := '6D657370616365555249203D3D3D205356475F4E414D45535041434529207B0A2020202020202020202072657475726E207461674E616D65203D3D3D20276D617468272026262048544D4C5F494E544547524154494F4E5F504F494E54535B706172656E';
wwv_flow_imp.g_varchar2_table(375) := '745461674E616D655D3B0A20202020202020207D0A0A20202020202020202F2F205765206F6E6C7920616C6C6F7720656C656D656E747320746861742061726520646566696E656420696E204D6174684D4C0A20202020202020202F2F20737065632E20';
wwv_flow_imp.g_varchar2_table(376) := '416C6C206F74686572732061726520646973616C6C6F77656420696E204D6174684D4C206E616D6573706163652E0A202020202020202072657475726E20426F6F6C65616E28414C4C5F4D4154484D4C5F544147535B7461674E616D655D293B0A202020';
wwv_flow_imp.g_varchar2_table(377) := '2020207D0A20202020202069662028656C656D656E742E6E616D657370616365555249203D3D3D2048544D4C5F4E414D45535041434529207B0A20202020202020202F2F20546865206F6E6C792077617920746F207377697463682066726F6D20535647';
wwv_flow_imp.g_varchar2_table(378) := '20746F2048544D4C206973207669610A20202020202020202F2F2048544D4C20696E746567726174696F6E20706F696E74732C20616E642066726F6D204D6174684D4C20746F2048544D4C0A20202020202020202F2F20697320766961204D6174684D4C';
wwv_flow_imp.g_varchar2_table(379) := '207465787420696E746567726174696F6E20706F696E74730A202020202020202069662028706172656E742E6E616D657370616365555249203D3D3D205356475F4E414D455350414345202626202148544D4C5F494E544547524154494F4E5F504F494E';
wwv_flow_imp.g_varchar2_table(380) := '54535B706172656E745461674E616D655D29207B0A2020202020202020202072657475726E2066616C73653B0A20202020202020207D0A202020202020202069662028706172656E742E6E616D657370616365555249203D3D3D204D4154484D4C5F4E41';
wwv_flow_imp.g_varchar2_table(381) := '4D45535041434520262620214D4154484D4C5F544558545F494E544547524154494F4E5F504F494E54535B706172656E745461674E616D655D29207B0A2020202020202020202072657475726E2066616C73653B0A20202020202020207D0A0A20202020';
wwv_flow_imp.g_varchar2_table(382) := '202020202F2F20576520646973616C6C6F77207461677320746861742061726520737065636966696320666F72204D6174684D4C0A20202020202020202F2F206F722053564720616E642073686F756C64206E657665722061707065617220696E204854';
wwv_flow_imp.g_varchar2_table(383) := '4D4C206E616D6573706163650A202020202020202072657475726E2021414C4C5F4D4154484D4C5F544147535B7461674E616D655D2026262028434F4D4D4F4E5F5356475F414E445F48544D4C5F454C454D454E54535B7461674E616D655D207C7C2021';
wwv_flow_imp.g_varchar2_table(384) := '414C4C5F5356475F544147535B7461674E616D655D293B0A2020202020207D0A0A2020202020202F2F20466F72205848544D4C20616E6420584D4C20646F63756D656E7473207468617420737570706F727420637573746F6D206E616D65737061636573';
wwv_flow_imp.g_varchar2_table(385) := '0A202020202020696620285041525345525F4D454449415F54595045203D3D3D20276170706C69636174696F6E2F7868746D6C2B786D6C2720262620414C4C4F5745445F4E414D455350414345535B656C656D656E742E6E616D6573706163655552495D';
wwv_flow_imp.g_varchar2_table(386) := '29207B0A202020202020202072657475726E20747275653B0A2020202020207D0A0A2020202020202F2F2054686520636F64652073686F756C64206E65766572207265616368207468697320706C616365202874686973206D65616E730A202020202020';
wwv_flow_imp.g_varchar2_table(387) := '2F2F20746861742074686520656C656D656E7420736F6D65686F7720676F74206E616D6573706163652074686174206973206E6F740A2020202020202F2F2048544D4C2C205356472C204D6174684D4C206F7220616C6C6F7765642076696120414C4C4F';
wwv_flow_imp.g_varchar2_table(388) := '5745445F4E414D45535041434553292E0A2020202020202F2F2052657475726E2066616C7365206A75737420696E20636173652E0A20202020202072657475726E2066616C73653B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F666F72';
wwv_flow_imp.g_varchar2_table(389) := '636552656D6F76650A20202020202A0A20202020202A2040706172616D20207B4E6F64657D206E6F6465206120444F4D206E6F64650A20202020202A2F0A20202020636F6E7374205F666F72636552656D6F7665203D2066756E6374696F6E205F666F72';
wwv_flow_imp.g_varchar2_table(390) := '636552656D6F7665286E6F646529207B0A20202020202061727261795075736828444F4D5075726966792E72656D6F7665642C207B0A2020202020202020656C656D656E743A206E6F64650A2020202020207D293B0A202020202020747279207B0A2020';
wwv_flow_imp.g_varchar2_table(391) := '2020202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520756E69636F726E2F7072656665722D646F6D2D6E6F64652D72656D6F76650A20202020202020206E6F64652E706172656E744E6F64652E72656D6F76654368696C64';
wwv_flow_imp.g_varchar2_table(392) := '286E6F6465293B0A2020202020207D20636174636820285F29207B0A20202020202020206E6F64652E72656D6F766528293B0A2020202020207D0A202020207D3B0A0A202020202F2A2A0A20202020202A205F72656D6F76654174747269627574650A20';
wwv_flow_imp.g_varchar2_table(393) := '202020202A0A20202020202A2040706172616D20207B537472696E677D206E616D6520616E20417474726962757465206E616D650A20202020202A2040706172616D20207B4E6F64657D206E6F6465206120444F4D206E6F64650A20202020202A2F0A20';
wwv_flow_imp.g_varchar2_table(394) := '202020636F6E7374205F72656D6F7665417474726962757465203D2066756E6374696F6E205F72656D6F7665417474726962757465286E616D652C206E6F646529207B0A202020202020747279207B0A202020202020202061727261795075736828444F';
wwv_flow_imp.g_varchar2_table(395) := '4D5075726966792E72656D6F7665642C207B0A202020202020202020206174747269627574653A206E6F64652E6765744174747269627574654E6F6465286E616D65292C0A2020202020202020202066726F6D3A206E6F64650A20202020202020207D29';
wwv_flow_imp.g_varchar2_table(396) := '3B0A2020202020207D20636174636820285F29207B0A202020202020202061727261795075736828444F4D5075726966792E72656D6F7665642C207B0A202020202020202020206174747269627574653A206E756C6C2C0A202020202020202020206672';
wwv_flow_imp.g_varchar2_table(397) := '6F6D3A206E6F64650A20202020202020207D293B0A2020202020207D0A2020202020206E6F64652E72656D6F7665417474726962757465286E616D65293B0A0A2020202020202F2F20576520766F6964206174747269627574652076616C75657320666F';
wwv_flow_imp.g_varchar2_table(398) := '7220756E72656D6F7661626C6520226973222220617474726962757465730A202020202020696620286E616D65203D3D3D20276973272026262021414C4C4F5745445F415454525B6E616D655D29207B0A20202020202020206966202852455455524E5F';
wwv_flow_imp.g_varchar2_table(399) := '444F4D207C7C2052455455524E5F444F4D5F465241474D454E5429207B0A20202020202020202020747279207B0A2020202020202020202020205F666F72636552656D6F7665286E6F6465293B0A202020202020202020207D20636174636820285F2920';
wwv_flow_imp.g_varchar2_table(400) := '7B7D0A20202020202020207D20656C7365207B0A20202020202020202020747279207B0A2020202020202020202020206E6F64652E736574417474726962757465286E616D652C202727293B0A202020202020202020207D20636174636820285F29207B';
wwv_flow_imp.g_varchar2_table(401) := '7D0A20202020202020207D0A2020202020207D0A202020207D3B0A0A202020202F2A2A0A20202020202A205F696E6974446F63756D656E740A20202020202A0A20202020202A2040706172616D20207B537472696E677D20646972747920612073747269';
wwv_flow_imp.g_varchar2_table(402) := '6E67206F66206469727479206D61726B75700A20202020202A204072657475726E207B446F63756D656E747D206120444F4D2C2066696C6C6564207769746820746865206469727479206D61726B75700A20202020202A2F0A20202020636F6E7374205F';
wwv_flow_imp.g_varchar2_table(403) := '696E6974446F63756D656E74203D2066756E6374696F6E205F696E6974446F63756D656E7428646972747929207B0A2020202020202F2A2043726561746520612048544D4C20646F63756D656E74202A2F0A2020202020206C657420646F63203D206E75';
wwv_flow_imp.g_varchar2_table(404) := '6C6C3B0A2020202020206C6574206C656164696E6757686974657370616365203D206E756C6C3B0A20202020202069662028464F5243455F424F445929207B0A20202020202020206469727479203D20273C72656D6F76653E3C2F72656D6F76653E2720';
wwv_flow_imp.g_varchar2_table(405) := '2B2064697274793B0A2020202020207D20656C7365207B0A20202020202020202F2A20496620464F5243455F424F44592069736E277420757365642C206C656164696E672077686974657370616365206E6565647320746F206265207072657365727665';
wwv_flow_imp.g_varchar2_table(406) := '64206D616E75616C6C79202A2F0A2020202020202020636F6E7374206D617463686573203D20737472696E674D617463682864697274792C202F5E5B5C725C6E5C74205D2B2F293B0A20202020202020206C656164696E6757686974657370616365203D';
wwv_flow_imp.g_varchar2_table(407) := '206D617463686573202626206D6174636865735B305D3B0A2020202020207D0A202020202020696620285041525345525F4D454449415F54595045203D3D3D20276170706C69636174696F6E2F7868746D6C2B786D6C27202626204E414D455350414345';
wwv_flow_imp.g_varchar2_table(408) := '203D3D3D2048544D4C5F4E414D45535041434529207B0A20202020202020202F2F20526F6F74206F66205848544D4C20646F63206D75737420636F6E7461696E20786D6C6E73206465636C61726174696F6E20287365652068747470733A2F2F7777772E';
wwv_flow_imp.g_varchar2_table(409) := '77332E6F72672F54522F7868746D6C312F6E6F726D61746976652E68746D6C23737472696374290A20202020202020206469727479203D20273C68746D6C20786D6C6E733D22687474703A2F2F7777772E77332E6F72672F313939392F7868746D6C223E';
wwv_flow_imp.g_varchar2_table(410) := '3C686561643E3C2F686561643E3C626F64793E27202B206469727479202B20273C2F626F64793E3C2F68746D6C3E273B0A2020202020207D0A202020202020636F6E73742064697274795061796C6F6164203D20747275737465645479706573506F6C69';
wwv_flow_imp.g_varchar2_table(411) := '6379203F20747275737465645479706573506F6C6963792E63726561746548544D4C28646972747929203A2064697274793B0A2020202020202F2A0A202020202020202A205573652074686520444F4D506172736572204150492062792064656661756C';
wwv_flow_imp.g_varchar2_table(412) := '742C2066616C6C6261636B206C61746572206966206E656564732062650A202020202020202A20444F4D506172736572206E6F7420776F726B20666F7220737667207768656E20686173206D756C7469706C6520726F6F7420656C656D656E742E0A2020';
wwv_flow_imp.g_varchar2_table(413) := '20202020202A2F0A202020202020696620284E414D455350414345203D3D3D2048544D4C5F4E414D45535041434529207B0A2020202020202020747279207B0A20202020202020202020646F63203D206E657720444F4D50617273657228292E70617273';
wwv_flow_imp.g_varchar2_table(414) := '6546726F6D537472696E672864697274795061796C6F61642C205041525345525F4D454449415F54595045293B0A20202020202020207D20636174636820285F29207B7D0A2020202020207D0A0A2020202020202F2A205573652063726561746548544D';
wwv_flow_imp.g_varchar2_table(415) := '4C446F63756D656E7420696E206361736520444F4D506172736572206973206E6F7420617661696C61626C65202A2F0A2020202020206966202821646F63207C7C2021646F632E646F63756D656E74456C656D656E7429207B0A2020202020202020646F';
wwv_flow_imp.g_varchar2_table(416) := '63203D20696D706C656D656E746174696F6E2E637265617465446F63756D656E74284E414D4553504143452C202774656D706C617465272C206E756C6C293B0A2020202020202020747279207B0A20202020202020202020646F632E646F63756D656E74';
wwv_flow_imp.g_varchar2_table(417) := '456C656D656E742E696E6E657248544D4C203D2049535F454D5054595F494E505554203F20656D70747948544D4C203A2064697274795061796C6F61643B0A20202020202020207D20636174636820285F29207B0A202020202020202020202F2F205379';
wwv_flow_imp.g_varchar2_table(418) := '6E746178206572726F722069662064697274795061796C6F616420697320696E76616C696420786D6C0A20202020202020207D0A2020202020207D0A202020202020636F6E737420626F6479203D20646F632E626F6479207C7C20646F632E646F63756D';
wwv_flow_imp.g_varchar2_table(419) := '656E74456C656D656E743B0A202020202020696620286469727479202626206C656164696E675768697465737061636529207B0A2020202020202020626F64792E696E736572744265666F726528646F63756D656E742E637265617465546578744E6F64';
wwv_flow_imp.g_varchar2_table(420) := '65286C656164696E6757686974657370616365292C20626F64792E6368696C644E6F6465735B305D207C7C206E756C6C293B0A2020202020207D0A0A2020202020202F2A20576F726B206F6E2077686F6C6520646F63756D656E74206F72206A75737420';
wwv_flow_imp.g_varchar2_table(421) := '69747320626F6479202A2F0A202020202020696620284E414D455350414345203D3D3D2048544D4C5F4E414D45535041434529207B0A202020202020202072657475726E20676574456C656D656E747342795461674E616D652E63616C6C28646F632C20';
wwv_flow_imp.g_varchar2_table(422) := '57484F4C455F444F43554D454E54203F202768746D6C27203A2027626F647927295B305D3B0A2020202020207D0A20202020202072657475726E2057484F4C455F444F43554D454E54203F20646F632E646F63756D656E74456C656D656E74203A20626F';
wwv_flow_imp.g_varchar2_table(423) := '64793B0A202020207D3B0A0A202020202F2A2A0A20202020202A20437265617465732061204E6F64654974657261746F72206F626A656374207468617420796F752063616E2075736520746F2074726176657273652066696C7465726564206C69737473';
wwv_flow_imp.g_varchar2_table(424) := '206F66206E6F646573206F7220656C656D656E747320696E206120646F63756D656E742E0A20202020202A0A20202020202A2040706172616D20207B4E6F64657D20726F6F742054686520726F6F7420656C656D656E74206F72206E6F646520746F2073';
wwv_flow_imp.g_varchar2_table(425) := '746172742074726176657273696E67206F6E2E0A20202020202A204072657475726E207B4E6F64654974657261746F727D205468652063726561746564204E6F64654974657261746F720A20202020202A2F0A20202020636F6E7374205F637265617465';
wwv_flow_imp.g_varchar2_table(426) := '4E6F64654974657261746F72203D2066756E6374696F6E205F6372656174654E6F64654974657261746F7228726F6F7429207B0A20202020202072657475726E206372656174654E6F64654974657261746F722E63616C6C28726F6F742E6F776E657244';
wwv_flow_imp.g_varchar2_table(427) := '6F63756D656E74207C7C20726F6F742C20726F6F742C0A2020202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E65206E6F2D626974776973650A2020202020204E6F646546696C7465722E53484F575F454C454D454E54207C20';
wwv_flow_imp.g_varchar2_table(428) := '4E6F646546696C7465722E53484F575F434F4D4D454E54207C204E6F646546696C7465722E53484F575F54455854207C204E6F646546696C7465722E53484F575F50524F43455353494E475F494E535452554354494F4E2C206E756C6C293B0A20202020';
wwv_flow_imp.g_varchar2_table(429) := '7D3B0A0A202020202F2A2A0A20202020202A205F6973436C6F6262657265640A20202020202A0A20202020202A2040706172616D20207B4E6F64657D20656C6D20656C656D656E7420746F20636865636B20666F7220636C6F62626572696E6720617474';
wwv_flow_imp.g_varchar2_table(430) := '61636B730A20202020202A204072657475726E207B426F6F6C65616E7D207472756520696620636C6F6262657265642C2066616C736520696620736166650A20202020202A2F0A20202020636F6E7374205F6973436C6F626265726564203D2066756E63';
wwv_flow_imp.g_varchar2_table(431) := '74696F6E205F6973436C6F62626572656428656C6D29207B0A20202020202072657475726E20656C6D20696E7374616E63656F662048544D4C466F726D456C656D656E742026262028747970656F6620656C6D2E6E6F64654E616D6520213D3D20277374';
wwv_flow_imp.g_varchar2_table(432) := '72696E6727207C7C20747970656F6620656C6D2E74657874436F6E74656E7420213D3D2027737472696E6727207C7C20747970656F6620656C6D2E72656D6F76654368696C6420213D3D202766756E6374696F6E27207C7C202128656C6D2E6174747269';
wwv_flow_imp.g_varchar2_table(433) := '627574657320696E7374616E63656F66204E616D65644E6F64654D617029207C7C20747970656F6620656C6D2E72656D6F766541747472696275746520213D3D202766756E6374696F6E27207C7C20747970656F6620656C6D2E73657441747472696275';
wwv_flow_imp.g_varchar2_table(434) := '746520213D3D202766756E6374696F6E27207C7C20747970656F6620656C6D2E6E616D65737061636555524920213D3D2027737472696E6727207C7C20747970656F6620656C6D2E696E736572744265666F726520213D3D202766756E6374696F6E2720';
wwv_flow_imp.g_varchar2_table(435) := '7C7C20747970656F6620656C6D2E6861734368696C644E6F64657320213D3D202766756E6374696F6E27293B0A202020207D3B0A0A202020202F2A2A0A20202020202A20436865636B7320776865746865722074686520676976656E206F626A65637420';
wwv_flow_imp.g_varchar2_table(436) := '6973206120444F4D206E6F64652E0A20202020202A0A20202020202A2040706172616D20207B4E6F64657D206F626A656374206F626A65637420746F20636865636B20776865746865722069742773206120444F4D206E6F64650A20202020202A204072';
wwv_flow_imp.g_varchar2_table(437) := '657475726E207B426F6F6C65616E7D2074727565206973206F626A656374206973206120444F4D206E6F64650A20202020202A2F0A20202020636F6E7374205F69734E6F6465203D2066756E6374696F6E205F69734E6F6465286F626A65637429207B0A';
wwv_flow_imp.g_varchar2_table(438) := '20202020202072657475726E20747970656F66204E6F6465203D3D3D202766756E6374696F6E27202626206F626A65637420696E7374616E63656F66204E6F64653B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F65786563757465486F';
wwv_flow_imp.g_varchar2_table(439) := '6F6B0A20202020202A2045786563757465207573657220636F6E666967757261626C6520686F6F6B730A20202020202A0A20202020202A2040706172616D20207B537472696E677D20656E747279506F696E7420204E616D65206F662074686520686F6F';
wwv_flow_imp.g_varchar2_table(440) := '6B277320656E74727920706F696E740A20202020202A2040706172616D20207B4E6F64657D2063757272656E744E6F6465206E6F646520746F20776F726B206F6E20776974682074686520686F6F6B0A20202020202A2040706172616D20207B4F626A65';
wwv_flow_imp.g_varchar2_table(441) := '63747D2064617461206164646974696F6E616C20686F6F6B20706172616D65746572730A20202020202A2F0A20202020636F6E7374205F65786563757465486F6F6B203D2066756E6374696F6E205F65786563757465486F6F6B28656E747279506F696E';
wwv_flow_imp.g_varchar2_table(442) := '742C2063757272656E744E6F64652C206461746129207B0A2020202020206966202821686F6F6B735B656E747279506F696E745D29207B0A202020202020202072657475726E3B0A2020202020207D0A2020202020206172726179466F72456163682868';
wwv_flow_imp.g_varchar2_table(443) := '6F6F6B735B656E747279506F696E745D2C20686F6F6B203D3E207B0A2020202020202020686F6F6B2E63616C6C28444F4D5075726966792C2063757272656E744E6F64652C20646174612C20434F4E464947293B0A2020202020207D293B0A202020207D';
wwv_flow_imp.g_varchar2_table(444) := '3B0A0A202020202F2A2A0A20202020202A205F73616E6974697A65456C656D656E74730A20202020202A0A20202020202A204070726F74656374206E6F64654E616D650A20202020202A204070726F746563742074657874436F6E74656E740A20202020';
wwv_flow_imp.g_varchar2_table(445) := '202A204070726F746563742072656D6F76654368696C640A20202020202A0A20202020202A2040706172616D2020207B4E6F64657D2063757272656E744E6F646520746F20636865636B20666F72207065726D697373696F6E20746F2065786973740A20';
wwv_flow_imp.g_varchar2_table(446) := '202020202A204072657475726E20207B426F6F6C65616E7D2074727565206966206E6F646520776173206B696C6C65642C2066616C7365206966206C65667420616C6976650A20202020202A2F0A20202020636F6E7374205F73616E6974697A65456C65';
wwv_flow_imp.g_varchar2_table(447) := '6D656E7473203D2066756E6374696F6E205F73616E6974697A65456C656D656E74732863757272656E744E6F646529207B0A2020202020206C657420636F6E74656E74203D206E756C6C3B0A0A2020202020202F2A2045786563757465206120686F6F6B';
wwv_flow_imp.g_varchar2_table(448) := '2069662070726573656E74202A2F0A2020202020205F65786563757465486F6F6B28276265666F726553616E6974697A65456C656D656E7473272C2063757272656E744E6F64652C206E756C6C293B0A0A2020202020202F2A20436865636B2069662065';
wwv_flow_imp.g_varchar2_table(449) := '6C656D656E7420697320636C6F626265726564206F722063616E20636C6F62626572202A2F0A202020202020696620285F6973436C6F6262657265642863757272656E744E6F64652929207B0A20202020202020205F666F72636552656D6F7665286375';
wwv_flow_imp.g_varchar2_table(450) := '7272656E744E6F6465293B0A202020202020202072657475726E20747275653B0A2020202020207D0A0A2020202020202F2A204E6F77206C6574277320636865636B2074686520656C656D656E742773207479706520616E64206E616D65202A2F0A2020';
wwv_flow_imp.g_varchar2_table(451) := '20202020636F6E7374207461674E616D65203D207472616E73666F726D4361736546756E632863757272656E744E6F64652E6E6F64654E616D65293B0A0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A';
wwv_flow_imp.g_varchar2_table(452) := '2020202020205F65786563757465486F6F6B282775706F6E53616E6974697A65456C656D656E74272C2063757272656E744E6F64652C207B0A20202020202020207461674E616D652C0A2020202020202020616C6C6F776564546167733A20414C4C4F57';
wwv_flow_imp.g_varchar2_table(453) := '45445F544147530A2020202020207D293B0A0A2020202020202F2A20446574656374206D58535320617474656D7074732061627573696E67206E616D65737061636520636F6E667573696F6E202A2F0A2020202020206966202863757272656E744E6F64';
wwv_flow_imp.g_varchar2_table(454) := '652E6861734368696C644E6F646573282920262620215F69734E6F64652863757272656E744E6F64652E6669727374456C656D656E744368696C64292026262072656745787054657374282F3C5B2F5C775D2F672C2063757272656E744E6F64652E696E';
wwv_flow_imp.g_varchar2_table(455) := '6E657248544D4C292026262072656745787054657374282F3C5B2F5C775D2F672C2063757272656E744E6F64652E74657874436F6E74656E742929207B0A20202020202020205F666F72636552656D6F76652863757272656E744E6F6465293B0A202020';
wwv_flow_imp.g_varchar2_table(456) := '202020202072657475726E20747275653B0A2020202020207D0A0A2020202020202F2A2052656D6F766520656C656D656E7420696620616E797468696E6720666F7262696473206974732070726573656E6365202A2F0A2020202020206966202821414C';
wwv_flow_imp.g_varchar2_table(457) := '4C4F5745445F544147535B7461674E616D655D207C7C20464F524249445F544147535B7461674E616D655D29207B0A20202020202020202F2A20436865636B2069662077652068617665206120637573746F6D20656C656D656E7420746F2068616E646C';
wwv_flow_imp.g_varchar2_table(458) := '65202A2F0A20202020202020206966202821464F524249445F544147535B7461674E616D655D202626205F69734261736963437573746F6D456C656D656E74287461674E616D652929207B0A2020202020202020202069662028435553544F4D5F454C45';
wwv_flow_imp.g_varchar2_table(459) := '4D454E545F48414E444C494E472E7461674E616D65436865636B20696E7374616E63656F6620526567457870202626207265674578705465737428435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B2C20746167';
wwv_flow_imp.g_varchar2_table(460) := '4E616D652929207B0A20202020202020202020202072657475726E2066616C73653B0A202020202020202020207D0A2020202020202020202069662028435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B20696E';
wwv_flow_imp.g_varchar2_table(461) := '7374616E63656F662046756E6374696F6E20262620435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B287461674E616D652929207B0A20202020202020202020202072657475726E2066616C73653B0A20202020';
wwv_flow_imp.g_varchar2_table(462) := '2020202020207D0A20202020202020207D0A0A20202020202020202F2A204B65657020636F6E74656E742065786365707420666F72206261642D6C697374656420656C656D656E7473202A2F0A2020202020202020696620284B4545505F434F4E54454E';
wwv_flow_imp.g_varchar2_table(463) := '542026262021464F524249445F434F4E54454E54535B7461674E616D655D29207B0A20202020202020202020636F6E737420706172656E744E6F6465203D20676574506172656E744E6F64652863757272656E744E6F646529207C7C2063757272656E74';
wwv_flow_imp.g_varchar2_table(464) := '4E6F64652E706172656E744E6F64653B0A20202020202020202020636F6E7374206368696C644E6F646573203D206765744368696C644E6F6465732863757272656E744E6F646529207C7C2063757272656E744E6F64652E6368696C644E6F6465733B0A';
wwv_flow_imp.g_varchar2_table(465) := '20202020202020202020696620286368696C644E6F64657320262620706172656E744E6F646529207B0A202020202020202020202020636F6E7374206368696C64436F756E74203D206368696C644E6F6465732E6C656E6774683B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(466) := '20202020666F7220286C65742069203D206368696C64436F756E74202D20313B2069203E3D20303B202D2D6929207B0A2020202020202020202020202020706172656E744E6F64652E696E736572744265666F726528636C6F6E654E6F6465286368696C';
wwv_flow_imp.g_varchar2_table(467) := '644E6F6465735B695D2C2074727565292C206765744E6578745369626C696E672863757272656E744E6F646529293B0A2020202020202020202020207D0A202020202020202020207D0A20202020202020207D0A20202020202020205F666F7263655265';
wwv_flow_imp.g_varchar2_table(468) := '6D6F76652863757272656E744E6F6465293B0A202020202020202072657475726E20747275653B0A2020202020207D0A0A2020202020202F2A20436865636B207768657468657220656C656D656E742068617320612076616C6964206E616D6573706163';
wwv_flow_imp.g_varchar2_table(469) := '65202A2F0A2020202020206966202863757272656E744E6F646520696E7374616E63656F6620456C656D656E7420262620215F636865636B56616C69644E616D6573706163652863757272656E744E6F64652929207B0A20202020202020205F666F7263';
wwv_flow_imp.g_varchar2_table(470) := '6552656D6F76652863757272656E744E6F6465293B0A202020202020202072657475726E20747275653B0A2020202020207D0A0A2020202020202F2A204D616B6520737572652074686174206F6C6465722062726F777365727320646F6E277420676574';
wwv_flow_imp.g_varchar2_table(471) := '2066616C6C6261636B2D746167206D585353202A2F0A20202020202069662028287461674E616D65203D3D3D20276E6F73637269707427207C7C207461674E616D65203D3D3D20276E6F656D62656427207C7C207461674E616D65203D3D3D20276E6F66';
wwv_flow_imp.g_varchar2_table(472) := '72616D657327292026262072656745787054657374282F3C5C2F6E6F287363726970747C656D6265647C6672616D6573292F692C2063757272656E744E6F64652E696E6E657248544D4C2929207B0A20202020202020205F666F72636552656D6F766528';
wwv_flow_imp.g_varchar2_table(473) := '63757272656E744E6F6465293B0A202020202020202072657475726E20747275653B0A2020202020207D0A0A2020202020202F2A2053616E6974697A6520656C656D656E7420636F6E74656E7420746F2062652074656D706C6174652D73616665202A2F';
wwv_flow_imp.g_varchar2_table(474) := '0A20202020202069662028534146455F464F525F54454D504C415445532026262063757272656E744E6F64652E6E6F646554797065203D3D3D203329207B0A20202020202020202F2A204765742074686520656C656D656E742773207465787420636F6E';
wwv_flow_imp.g_varchar2_table(475) := '74656E74202A2F0A2020202020202020636F6E74656E74203D2063757272656E744E6F64652E74657874436F6E74656E743B0A20202020202020206172726179466F7245616368285B4D555354414348455F455850522C204552425F455850522C20544D';
wwv_flow_imp.g_varchar2_table(476) := '504C49545F455850525D2C2065787072203D3E207B0A20202020202020202020636F6E74656E74203D20737472696E675265706C61636528636F6E74656E742C20657870722C20272027293B0A20202020202020207D293B0A2020202020202020696620';
wwv_flow_imp.g_varchar2_table(477) := '2863757272656E744E6F64652E74657874436F6E74656E7420213D3D20636F6E74656E7429207B0A2020202020202020202061727261795075736828444F4D5075726966792E72656D6F7665642C207B0A202020202020202020202020656C656D656E74';
wwv_flow_imp.g_varchar2_table(478) := '3A2063757272656E744E6F64652E636C6F6E654E6F646528290A202020202020202020207D293B0A2020202020202020202063757272656E744E6F64652E74657874436F6E74656E74203D20636F6E74656E743B0A20202020202020207D0A2020202020';
wwv_flow_imp.g_varchar2_table(479) := '207D0A0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020205F65786563757465486F6F6B2827616674657253616E6974697A65456C656D656E7473272C2063757272656E744E6F64652C206E';
wwv_flow_imp.g_varchar2_table(480) := '756C6C293B0A20202020202072657475726E2066616C73653B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F697356616C69644174747269627574650A20202020202A0A20202020202A2040706172616D20207B737472696E677D206C63';
wwv_flow_imp.g_varchar2_table(481) := '546167204C6F7765726361736520746167206E616D65206F6620636F6E7461696E696E6720656C656D656E742E0A20202020202A2040706172616D20207B737472696E677D206C634E616D65204C6F7765726361736520617474726962757465206E616D';
wwv_flow_imp.g_varchar2_table(482) := '652E0A20202020202A2040706172616D20207B737472696E677D2076616C7565204174747269627574652076616C75652E0A20202020202A204072657475726E207B426F6F6C65616E7D2052657475726E732074727565206966206076616C7565602069';
wwv_flow_imp.g_varchar2_table(483) := '732076616C69642C206F74686572776973652066616C73652E0A20202020202A2F0A202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520636F6D706C65786974790A20202020636F6E7374205F697356616C69644174747269';
wwv_flow_imp.g_varchar2_table(484) := '62757465203D2066756E6374696F6E205F697356616C6964417474726962757465286C635461672C206C634E616D652C2076616C756529207B0A2020202020202F2A204D616B652073757265206174747269627574652063616E6E6F7420636C6F626265';
wwv_flow_imp.g_varchar2_table(485) := '72202A2F0A2020202020206966202853414E4954495A455F444F4D20262620286C634E616D65203D3D3D2027696427207C7C206C634E616D65203D3D3D20276E616D652729202626202876616C756520696E20646F63756D656E74207C7C2076616C7565';
wwv_flow_imp.g_varchar2_table(486) := '20696E20666F726D456C656D656E742929207B0A202020202020202072657475726E2066616C73653B0A2020202020207D0A0A2020202020202F2A20416C6C6F772076616C696420646174612D2A20617474726962757465733A204174206C6561737420';
wwv_flow_imp.g_varchar2_table(487) := '6F6E652063686172616374657220616674657220222D220A202020202020202020202868747470733A2F2F68746D6C2E737065632E7768617477672E6F72672F6D756C7469706167652F646F6D2E68746D6C23656D62656464696E672D637573746F6D2D';
wwv_flow_imp.g_varchar2_table(488) := '6E6F6E2D76697369626C652D646174612D776974682D7468652D646174612D2A2D61747472696275746573290A20202020202020202020584D4C2D636F6D70617469626C65202868747470733A2F2F68746D6C2E737065632E7768617477672E6F72672F';
wwv_flow_imp.g_varchar2_table(489) := '6D756C7469706167652F696E6672617374727563747572652E68746D6C23786D6C2D636F6D70617469626C6520616E6420687474703A2F2F7777772E77332E6F72672F54522F786D6C2F23643065383034290A20202020202020202020576520646F6E27';
wwv_flow_imp.g_varchar2_table(490) := '74206E65656420746F20636865636B207468652076616C75653B206974277320616C776179732055524920736166652E202A2F0A20202020202069662028414C4C4F575F444154415F415454522026262021464F524249445F415454525B6C634E616D65';
wwv_flow_imp.g_varchar2_table(491) := '5D202626207265674578705465737428444154415F415454522C206C634E616D652929203B20656C73652069662028414C4C4F575F415249415F41545452202626207265674578705465737428415249415F415454522C206C634E616D652929203B2065';
wwv_flow_imp.g_varchar2_table(492) := '6C7365206966202821414C4C4F5745445F415454525B6C634E616D655D207C7C20464F524249445F415454525B6C634E616D655D29207B0A2020202020202020696620280A20202020202020202F2F20466972737420636F6E646974696F6E20646F6573';
wwv_flow_imp.g_varchar2_table(493) := '2061207665727920626173696320636865636B2069662061292069742773206261736963616C6C7920612076616C696420637573746F6D20656C656D656E74207461676E616D6520414E440A20202020202020202F2F2062292069662074686520746167';
wwv_flow_imp.g_varchar2_table(494) := '4E616D65207061737365732077686174657665722074686520757365722068617320636F6E6669677572656420666F7220435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B0A20202020202020202F2F20616E64';
wwv_flow_imp.g_varchar2_table(495) := '2063292069662074686520617474726962757465206E616D65207061737365732077686174657665722074686520757365722068617320636F6E6669677572656420666F7220435553544F4D5F454C454D454E545F48414E444C494E472E617474726962';
wwv_flow_imp.g_varchar2_table(496) := '7574654E616D65436865636B0A20202020202020205F69734261736963437573746F6D456C656D656E74286C63546167292026262028435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B20696E7374616E63656F';
wwv_flow_imp.g_varchar2_table(497) := '6620526567457870202626207265674578705465737428435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B2C206C6354616729207C7C20435553544F4D5F454C454D454E545F48414E444C494E472E7461674E61';
wwv_flow_imp.g_varchar2_table(498) := '6D65436865636B20696E7374616E63656F662046756E6374696F6E20262620435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B286C6354616729292026262028435553544F4D5F454C454D454E545F48414E444C';
wwv_flow_imp.g_varchar2_table(499) := '494E472E6174747269627574654E616D65436865636B20696E7374616E63656F6620526567457870202626207265674578705465737428435553544F4D5F454C454D454E545F48414E444C494E472E6174747269627574654E616D65436865636B2C206C';
wwv_flow_imp.g_varchar2_table(500) := '634E616D6529207C7C20435553544F4D5F454C454D454E545F48414E444C494E472E6174747269627574654E616D65436865636B20696E7374616E63656F662046756E6374696F6E20262620435553544F4D5F454C454D454E545F48414E444C494E472E';
wwv_flow_imp.g_varchar2_table(501) := '6174747269627574654E616D65436865636B286C634E616D652929207C7C0A20202020202020202F2F20416C7465726E61746976652C207365636F6E6420636F6E646974696F6E20636865636B73206966206974277320616E20606973602D6174747269';
wwv_flow_imp.g_varchar2_table(502) := '627574652C20414E440A20202020202020202F2F207468652076616C7565207061737365732077686174657665722074686520757365722068617320636F6E6669677572656420666F7220435553544F4D5F454C454D454E545F48414E444C494E472E74';
wwv_flow_imp.g_varchar2_table(503) := '61674E616D65436865636B0A20202020202020206C634E616D65203D3D3D202769732720262620435553544F4D5F454C454D454E545F48414E444C494E472E616C6C6F77437573746F6D697A65644275696C74496E456C656D656E747320262620284355';
wwv_flow_imp.g_varchar2_table(504) := '53544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B20696E7374616E63656F6620526567457870202626207265674578705465737428435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D654368';
wwv_flow_imp.g_varchar2_table(505) := '65636B2C2076616C756529207C7C20435553544F4D5F454C454D454E545F48414E444C494E472E7461674E616D65436865636B20696E7374616E63656F662046756E6374696F6E20262620435553544F4D5F454C454D454E545F48414E444C494E472E74';
wwv_flow_imp.g_varchar2_table(506) := '61674E616D65436865636B2876616C7565292929203B20656C7365207B0A2020202020202020202072657475726E2066616C73653B0A20202020202020207D0A20202020202020202F2A20436865636B2076616C756520697320736166652E2046697273';
wwv_flow_imp.g_varchar2_table(507) := '742C206973206174747220696E6572743F20496620736F2C2069732073616665202A2F0A2020202020207D20656C736520696620285552495F534146455F415454524942555445535B6C634E616D655D29203B20656C7365206966202872656745787054';
wwv_flow_imp.g_varchar2_table(508) := '6573742849535F414C4C4F5745445F55524924312C20737472696E675265706C6163652876616C75652C20415454525F574849544553504143452C202727292929203B20656C73652069662028286C634E616D65203D3D3D202773726327207C7C206C63';
wwv_flow_imp.g_varchar2_table(509) := '4E616D65203D3D3D2027786C696E6B3A6872656627207C7C206C634E616D65203D3D3D2027687265662729202626206C6354616720213D3D20277363726970742720262620737472696E67496E6465784F662876616C75652C2027646174613A2729203D';
wwv_flow_imp.g_varchar2_table(510) := '3D3D203020262620444154415F5552495F544147535B6C635461675D29203B20656C73652069662028414C4C4F575F554E4B4E4F574E5F50524F544F434F4C532026262021726567457870546573742849535F5343524950545F4F525F444154412C2073';
wwv_flow_imp.g_varchar2_table(511) := '7472696E675265706C6163652876616C75652C20415454525F574849544553504143452C202727292929203B20656C7365206966202876616C756529207B0A202020202020202072657475726E2066616C73653B0A2020202020207D20656C7365203B0A';
wwv_flow_imp.g_varchar2_table(512) := '20202020202072657475726E20747275653B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F69734261736963437573746F6D456C656D656E740A20202020202A20636865636B73206966206174206C65617374206F6E6520646173682069';
wwv_flow_imp.g_varchar2_table(513) := '7320696E636C7564656420696E207461674E616D652C20616E642069742773206E6F742074686520666972737420636861720A20202020202A20666F72206D6F726520736F706869737469636174656420636865636B696E67207365652068747470733A';
wwv_flow_imp.g_varchar2_table(514) := '2F2F6769746875622E636F6D2F73696E647265736F726875732F76616C69646174652D656C656D656E742D6E616D650A20202020202A0A20202020202A2040706172616D207B737472696E677D207461674E616D65206E616D65206F6620746865207461';
wwv_flow_imp.g_varchar2_table(515) := '67206F6620746865206E6F646520746F2073616E6974697A650A20202020202A204072657475726E73207B626F6F6C65616E7D2052657475726E7320747275652069662074686520746167206E616D65206D656574732074686520626173696320637269';
wwv_flow_imp.g_varchar2_table(516) := '746572696120666F72206120637573746F6D20656C656D656E742C206F74686572776973652066616C73652E0A20202020202A2F0A20202020636F6E7374205F69734261736963437573746F6D456C656D656E74203D2066756E6374696F6E205F697342';
wwv_flow_imp.g_varchar2_table(517) := '61736963437573746F6D456C656D656E74287461674E616D6529207B0A20202020202072657475726E207461674E616D6520213D3D2027616E6E6F746174696F6E2D786D6C2720262620737472696E674D61746368287461674E616D652C20435553544F';
wwv_flow_imp.g_varchar2_table(518) := '4D5F454C454D454E54293B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F73616E6974697A65417474726962757465730A20202020202A0A20202020202A204070726F7465637420617474726962757465730A20202020202A204070726F';
wwv_flow_imp.g_varchar2_table(519) := '74656374206E6F64654E616D650A20202020202A204070726F746563742072656D6F76654174747269627574650A20202020202A204070726F74656374207365744174747269627574650A20202020202A0A20202020202A2040706172616D20207B4E6F';
wwv_flow_imp.g_varchar2_table(520) := '64657D2063757272656E744E6F646520746F2073616E6974697A650A20202020202A2F0A20202020636F6E7374205F73616E6974697A6541747472696275746573203D2066756E6374696F6E205F73616E6974697A654174747269627574657328637572';
wwv_flow_imp.g_varchar2_table(521) := '72656E744E6F646529207B0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020205F65786563757465486F6F6B28276265666F726553616E6974697A6541747472696275746573272C20637572';
wwv_flow_imp.g_varchar2_table(522) := '72656E744E6F64652C206E756C6C293B0A202020202020636F6E7374207B0A2020202020202020617474726962757465730A2020202020207D203D2063757272656E744E6F64653B0A0A2020202020202F2A20436865636B206966207765206861766520';
wwv_flow_imp.g_varchar2_table(523) := '617474726962757465733B206966206E6F74207765206D69676874206861766520612074657874206E6F6465202A2F0A20202020202069662028216174747269627574657329207B0A202020202020202072657475726E3B0A2020202020207D0A202020';
wwv_flow_imp.g_varchar2_table(524) := '202020636F6E737420686F6F6B4576656E74203D207B0A2020202020202020617474724E616D653A2027272C0A20202020202020206174747256616C75653A2027272C0A20202020202020206B656570417474723A20747275652C0A2020202020202020';
wwv_flow_imp.g_varchar2_table(525) := '616C6C6F776564417474726962757465733A20414C4C4F5745445F415454520A2020202020207D3B0A2020202020206C6574206C203D20617474726962757465732E6C656E6774683B0A0A2020202020202F2A20476F206261636B7761726473206F7665';
wwv_flow_imp.g_varchar2_table(526) := '7220616C6C20617474726962757465733B20736166656C792072656D6F766520626164206F6E6573202A2F0A2020202020207768696C6520286C2D2D29207B0A2020202020202020636F6E73742061747472203D20617474726962757465735B6C5D3B0A';
wwv_flow_imp.g_varchar2_table(527) := '2020202020202020636F6E7374207B0A202020202020202020206E616D652C0A202020202020202020206E616D6573706163655552492C0A2020202020202020202076616C75653A206174747256616C75650A20202020202020207D203D20617474723B';
wwv_flow_imp.g_varchar2_table(528) := '0A2020202020202020636F6E7374206C634E616D65203D207472616E73666F726D4361736546756E63286E616D65293B0A20202020202020206C65742076616C7565203D206E616D65203D3D3D202776616C756527203F206174747256616C7565203A20';
wwv_flow_imp.g_varchar2_table(529) := '737472696E675472696D286174747256616C7565293B0A0A20202020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020202020686F6F6B4576656E742E617474724E616D65203D206C634E616D653B';
wwv_flow_imp.g_varchar2_table(530) := '0A2020202020202020686F6F6B4576656E742E6174747256616C7565203D2076616C75653B0A2020202020202020686F6F6B4576656E742E6B65657041747472203D20747275653B0A2020202020202020686F6F6B4576656E742E666F7263654B656570';
wwv_flow_imp.g_varchar2_table(531) := '41747472203D20756E646566696E65643B202F2F20416C6C6F777320646576656C6F7065727320746F20736565207468697320697320612070726F706572747920746865792063616E207365740A20202020202020205F65786563757465486F6F6B2827';
wwv_flow_imp.g_varchar2_table(532) := '75706F6E53616E6974697A65417474726962757465272C2063757272656E744E6F64652C20686F6F6B4576656E74293B0A202020202020202076616C7565203D20686F6F6B4576656E742E6174747256616C75653B0A20202020202020202F2A20446964';
wwv_flow_imp.g_varchar2_table(533) := '2074686520686F6F6B7320617070726F7665206F6620746865206174747269627574653F202A2F0A202020202020202069662028686F6F6B4576656E742E666F7263654B6565704174747229207B0A20202020202020202020636F6E74696E75653B0A20';
wwv_flow_imp.g_varchar2_table(534) := '202020202020207D0A0A20202020202020202F2A2052656D6F766520617474726962757465202A2F0A20202020202020205F72656D6F7665417474726962757465286E616D652C2063757272656E744E6F6465293B0A0A20202020202020202F2A204469';
wwv_flow_imp.g_varchar2_table(535) := '642074686520686F6F6B7320617070726F7665206F6620746865206174747269627574653F202A2F0A20202020202020206966202821686F6F6B4576656E742E6B6565704174747229207B0A20202020202020202020636F6E74696E75653B0A20202020';
wwv_flow_imp.g_varchar2_table(536) := '202020207D0A0A20202020202020202F2A20576F726B2061726F756E64206120736563757269747920697373756520696E206A517565727920332E30202A2F0A20202020202020206966202821414C4C4F575F53454C465F434C4F53455F494E5F415454';
wwv_flow_imp.g_varchar2_table(537) := '522026262072656745787054657374282F5C2F3E2F692C2076616C75652929207B0A202020202020202020205F72656D6F7665417474726962757465286E616D652C2063757272656E744E6F6465293B0A20202020202020202020636F6E74696E75653B';
wwv_flow_imp.g_varchar2_table(538) := '0A20202020202020207D0A0A20202020202020202F2A2053616E6974697A652061747472696275746520636F6E74656E7420746F2062652074656D706C6174652D73616665202A2F0A202020202020202069662028534146455F464F525F54454D504C41';
wwv_flow_imp.g_varchar2_table(539) := '54455329207B0A202020202020202020206172726179466F7245616368285B4D555354414348455F455850522C204552425F455850522C20544D504C49545F455850525D2C2065787072203D3E207B0A20202020202020202020202076616C7565203D20';
wwv_flow_imp.g_varchar2_table(540) := '737472696E675265706C6163652876616C75652C20657870722C20272027293B0A202020202020202020207D293B0A20202020202020207D0A0A20202020202020202F2A204973206076616C7565602076616C696420666F722074686973206174747269';
wwv_flow_imp.g_varchar2_table(541) := '627574653F202A2F0A2020202020202020636F6E7374206C63546167203D207472616E73666F726D4361736546756E632863757272656E744E6F64652E6E6F64654E616D65293B0A202020202020202069662028215F697356616C696441747472696275';
wwv_flow_imp.g_varchar2_table(542) := '7465286C635461672C206C634E616D652C2076616C75652929207B0A20202020202020202020636F6E74696E75653B0A20202020202020207D0A0A20202020202020202F2A2046756C6C20444F4D20436C6F62626572696E672070726F74656374696F6E';
wwv_flow_imp.g_varchar2_table(543) := '20766961206E616D6573706163652069736F6C6174696F6E2C0A2020202020202020202A2050726566697820696420616E64206E616D65206174747269627574657320776974682060757365722D636F6E74656E742D600A2020202020202020202A2F0A';
wwv_flow_imp.g_varchar2_table(544) := '20202020202020206966202853414E4954495A455F4E414D45445F50524F505320262620286C634E616D65203D3D3D2027696427207C7C206C634E616D65203D3D3D20276E616D65272929207B0A202020202020202020202F2F2052656D6F7665207468';
wwv_flow_imp.g_varchar2_table(545) := '6520617474726962757465207769746820746869732076616C75650A202020202020202020205F72656D6F7665417474726962757465286E616D652C2063757272656E744E6F6465293B0A0A202020202020202020202F2F205072656669782074686520';
wwv_flow_imp.g_varchar2_table(546) := '76616C756520616E64206C617465722072652D63726561746520746865206174747269627574652077697468207468652073616E6974697A65642076616C75650A2020202020202020202076616C7565203D2053414E4954495A455F4E414D45445F5052';
wwv_flow_imp.g_varchar2_table(547) := '4F50535F505245464958202B2076616C75653B0A20202020202020207D0A0A20202020202020202F2A2048616E646C652061747472696275746573207468617420726571756972652054727573746564205479706573202A2F0A20202020202020206966';
wwv_flow_imp.g_varchar2_table(548) := '2028747275737465645479706573506F6C69637920262620747970656F6620747275737465645479706573203D3D3D20276F626A6563742720262620747970656F66207472757374656454797065732E67657441747472696275746554797065203D3D3D';
wwv_flow_imp.g_varchar2_table(549) := '202766756E6374696F6E2729207B0A20202020202020202020696620286E616D65737061636555524929203B20656C7365207B0A20202020202020202020202073776974636820287472757374656454797065732E676574417474726962757465547970';
wwv_flow_imp.g_varchar2_table(550) := '65286C635461672C206C634E616D652929207B0A20202020202020202020202020206361736520275472757374656448544D4C273A0A202020202020202020202020202020207B0A20202020202020202020202020202020202076616C7565203D207472';
wwv_flow_imp.g_varchar2_table(551) := '75737465645479706573506F6C6963792E63726561746548544D4C2876616C7565293B0A202020202020202020202020202020202020627265616B3B0A202020202020202020202020202020207D0A202020202020202020202020202063617365202754';
wwv_flow_imp.g_varchar2_table(552) := '72757374656453637269707455524C273A0A202020202020202020202020202020207B0A20202020202020202020202020202020202076616C7565203D20747275737465645479706573506F6C6963792E63726561746553637269707455524C2876616C';
wwv_flow_imp.g_varchar2_table(553) := '7565293B0A202020202020202020202020202020202020627265616B3B0A202020202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020207D0A20202020202020207D0A0A20202020202020202F2A2048616E64';
wwv_flow_imp.g_varchar2_table(554) := '6C6520696E76616C696420646174612D2A2061747472696275746520736574206279207472792D6361746368696E67206974202A2F0A2020202020202020747279207B0A20202020202020202020696620286E616D65737061636555524929207B0A2020';
wwv_flow_imp.g_varchar2_table(555) := '2020202020202020202063757272656E744E6F64652E7365744174747269627574654E53286E616D6573706163655552492C206E616D652C2076616C7565293B0A202020202020202020207D20656C7365207B0A2020202020202020202020202F2A2046';
wwv_flow_imp.g_varchar2_table(556) := '616C6C6261636B20746F20736574417474726962757465282920666F722062726F777365722D756E7265636F676E697A6564206E616D6573706163657320652E672E2022782D736368656D61222E202A2F0A20202020202020202020202063757272656E';
wwv_flow_imp.g_varchar2_table(557) := '744E6F64652E736574417474726962757465286E616D652C2076616C7565293B0A202020202020202020207D0A202020202020202020206172726179506F7028444F4D5075726966792E72656D6F766564293B0A20202020202020207D20636174636820';
wwv_flow_imp.g_varchar2_table(558) := '285F29207B7D0A2020202020207D0A0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020205F65786563757465486F6F6B2827616674657253616E6974697A6541747472696275746573272C20';
wwv_flow_imp.g_varchar2_table(559) := '63757272656E744E6F64652C206E756C6C293B0A202020207D3B0A0A202020202F2A2A0A20202020202A205F73616E6974697A65536861646F77444F4D0A20202020202A0A20202020202A2040706172616D20207B446F63756D656E74467261676D656E';
wwv_flow_imp.g_varchar2_table(560) := '747D20667261676D656E7420746F2069746572617465206F766572207265637572736976656C790A20202020202A2F0A20202020636F6E7374205F73616E6974697A65536861646F77444F4D203D2066756E6374696F6E205F73616E6974697A65536861';
wwv_flow_imp.g_varchar2_table(561) := '646F77444F4D28667261676D656E7429207B0A2020202020206C657420736861646F774E6F6465203D206E756C6C3B0A202020202020636F6E737420736861646F774974657261746F72203D205F6372656174654E6F64654974657261746F7228667261';
wwv_flow_imp.g_varchar2_table(562) := '676D656E74293B0A0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020205F65786563757465486F6F6B28276265666F726553616E6974697A65536861646F77444F4D272C20667261676D656E';
wwv_flow_imp.g_varchar2_table(563) := '742C206E756C6C293B0A2020202020207768696C652028736861646F774E6F6465203D20736861646F774974657261746F722E6E6578744E6F6465282929207B0A20202020202020202F2A2045786563757465206120686F6F6B2069662070726573656E';
wwv_flow_imp.g_varchar2_table(564) := '74202A2F0A20202020202020205F65786563757465486F6F6B282775706F6E53616E6974697A65536861646F774E6F6465272C20736861646F774E6F64652C206E756C6C293B0A0A20202020202020202F2A2053616E6974697A65207461677320616E64';
wwv_flow_imp.g_varchar2_table(565) := '20656C656D656E7473202A2F0A2020202020202020696620285F73616E6974697A65456C656D656E747328736861646F774E6F64652929207B0A20202020202020202020636F6E74696E75653B0A20202020202020207D0A0A20202020202020202F2A20';
wwv_flow_imp.g_varchar2_table(566) := '4465657020736861646F7720444F4D206465746563746564202A2F0A202020202020202069662028736861646F774E6F64652E636F6E74656E7420696E7374616E63656F6620446F63756D656E74467261676D656E7429207B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(567) := '5F73616E6974697A65536861646F77444F4D28736861646F774E6F64652E636F6E74656E74293B0A20202020202020207D0A0A20202020202020202F2A20436865636B20617474726962757465732C2073616E6974697A65206966206E65636573736172';
wwv_flow_imp.g_varchar2_table(568) := '79202A2F0A20202020202020205F73616E6974697A654174747269627574657328736861646F774E6F6465293B0A2020202020207D0A0A2020202020202F2A2045786563757465206120686F6F6B2069662070726573656E74202A2F0A2020202020205F';
wwv_flow_imp.g_varchar2_table(569) := '65786563757465486F6F6B2827616674657253616E6974697A65536861646F77444F4D272C20667261676D656E742C206E756C6C293B0A202020207D3B0A0A202020202F2A2A0A20202020202A2053616E6974697A650A20202020202A205075626C6963';
wwv_flow_imp.g_varchar2_table(570) := '206D6574686F642070726F766964696E6720636F72652073616E69746174696F6E2066756E6374696F6E616C6974790A20202020202A0A20202020202A2040706172616D207B537472696E677C4E6F64657D20646972747920737472696E67206F722044';
wwv_flow_imp.g_varchar2_table(571) := '4F4D206E6F64650A20202020202A2040706172616D207B4F626A6563747D20636667206F626A6563740A20202020202A2F0A202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520636F6D706C65786974790A20202020444F4D';
wwv_flow_imp.g_varchar2_table(572) := '5075726966792E73616E6974697A65203D2066756E6374696F6E2028646972747929207B0A2020202020206C657420636667203D20617267756D656E74732E6C656E677468203E203120262620617267756D656E74735B315D20213D3D20756E64656669';
wwv_flow_imp.g_varchar2_table(573) := '6E6564203F20617267756D656E74735B315D203A207B7D3B0A2020202020206C657420626F6479203D206E756C6C3B0A2020202020206C657420696D706F727465644E6F6465203D206E756C6C3B0A2020202020206C65742063757272656E744E6F6465';
wwv_flow_imp.g_varchar2_table(574) := '203D206E756C6C3B0A2020202020206C65742072657475726E4E6F6465203D206E756C6C3B0A2020202020202F2A204D616B6520737572652077652068617665206120737472696E6720746F2073616E6974697A652E0A2020202020202020444F204E4F';
wwv_flow_imp.g_varchar2_table(575) := '542072657475726E206561726C792C20617320746869732077696C6C2072657475726E207468652077726F6E6720747970652069660A202020202020202074686520757365722068617320726571756573746564206120444F4D206F626A656374207261';
wwv_flow_imp.g_varchar2_table(576) := '74686572207468616E206120737472696E67202A2F0A20202020202049535F454D5054595F494E505554203D202164697274793B0A2020202020206966202849535F454D5054595F494E50555429207B0A20202020202020206469727479203D20273C21';
wwv_flow_imp.g_varchar2_table(577) := '2D2D3E273B0A2020202020207D0A0A2020202020202F2A20537472696E676966792C20696E206361736520646972747920697320616E206F626A656374202A2F0A20202020202069662028747970656F6620646972747920213D3D2027737472696E6727';
wwv_flow_imp.g_varchar2_table(578) := '20262620215F69734E6F64652864697274792929207B0A202020202020202069662028747970656F662064697274792E746F537472696E67203D3D3D202766756E6374696F6E2729207B0A202020202020202020206469727479203D2064697274792E74';
wwv_flow_imp.g_varchar2_table(579) := '6F537472696E6728293B0A2020202020202020202069662028747970656F6620646972747920213D3D2027737472696E672729207B0A2020202020202020202020207468726F7720747970654572726F7243726561746528276469727479206973206E6F';
wwv_flow_imp.g_varchar2_table(580) := '74206120737472696E672C2061626F7274696E6727293B0A202020202020202020207D0A20202020202020207D20656C7365207B0A202020202020202020207468726F7720747970654572726F724372656174652827746F537472696E67206973206E6F';
wwv_flow_imp.g_varchar2_table(581) := '7420612066756E6374696F6E27293B0A20202020202020207D0A2020202020207D0A0A2020202020202F2A2052657475726E2064697274792048544D4C20696620444F4D5075726966792063616E6E6F742072756E202A2F0A2020202020206966202821';
wwv_flow_imp.g_varchar2_table(582) := '444F4D5075726966792E6973537570706F7274656429207B0A202020202020202072657475726E2064697274793B0A2020202020207D0A0A2020202020202F2A2041737369676E20636F6E6669672076617273202A2F0A20202020202069662028215345';
wwv_flow_imp.g_varchar2_table(583) := '545F434F4E46494729207B0A20202020202020205F7061727365436F6E66696728636667293B0A2020202020207D0A0A2020202020202F2A20436C65616E2075702072656D6F76656420656C656D656E7473202A2F0A202020202020444F4D5075726966';
wwv_flow_imp.g_varchar2_table(584) := '792E72656D6F766564203D205B5D3B0A0A2020202020202F2A20436865636B20696620646972747920697320636F72726563746C7920747970656420666F7220494E5F504C414345202A2F0A20202020202069662028747970656F66206469727479203D';
wwv_flow_imp.g_varchar2_table(585) := '3D3D2027737472696E672729207B0A2020202020202020494E5F504C414345203D2066616C73653B0A2020202020207D0A20202020202069662028494E5F504C41434529207B0A20202020202020202F2A20446F20736F6D65206561726C79207072652D';
wwv_flow_imp.g_varchar2_table(586) := '73616E6974697A6174696F6E20746F2061766F696420756E7361666520726F6F74206E6F646573202A2F0A20202020202020206966202864697274792E6E6F64654E616D6529207B0A20202020202020202020636F6E7374207461674E616D65203D2074';
wwv_flow_imp.g_varchar2_table(587) := '72616E73666F726D4361736546756E632864697274792E6E6F64654E616D65293B0A202020202020202020206966202821414C4C4F5745445F544147535B7461674E616D655D207C7C20464F524249445F544147535B7461674E616D655D29207B0A2020';
wwv_flow_imp.g_varchar2_table(588) := '202020202020202020207468726F7720747970654572726F724372656174652827726F6F74206E6F646520697320666F7262696464656E20616E642063616E6E6F742062652073616E6974697A656420696E2D706C61636527293B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(589) := '20207D0A20202020202020207D0A2020202020207D20656C73652069662028646972747920696E7374616E63656F66204E6F646529207B0A20202020202020202F2A204966206469727479206973206120444F4D20656C656D656E742C20617070656E64';
wwv_flow_imp.g_varchar2_table(590) := '20746F20616E20656D70747920646F63756D656E7420746F2061766F69640A2020202020202020202020656C656D656E7473206265696E672073747269707065642062792074686520706172736572202A2F0A2020202020202020626F6479203D205F69';
wwv_flow_imp.g_varchar2_table(591) := '6E6974446F63756D656E7428273C212D2D2D2D3E27293B0A2020202020202020696D706F727465644E6F6465203D20626F64792E6F776E6572446F63756D656E742E696D706F72744E6F64652864697274792C2074727565293B0A202020202020202069';
wwv_flow_imp.g_varchar2_table(592) := '662028696D706F727465644E6F64652E6E6F646554797065203D3D3D203120262620696D706F727465644E6F64652E6E6F64654E616D65203D3D3D2027424F44592729207B0A202020202020202020202F2A204E6F646520697320616C72656164792061';
wwv_flow_imp.g_varchar2_table(593) := '20626F64792C20757365206173206973202A2F0A20202020202020202020626F6479203D20696D706F727465644E6F64653B0A20202020202020207D20656C73652069662028696D706F727465644E6F64652E6E6F64654E616D65203D3D3D202748544D';
wwv_flow_imp.g_varchar2_table(594) := '4C2729207B0A20202020202020202020626F6479203D20696D706F727465644E6F64653B0A20202020202020207D20656C7365207B0A202020202020202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520756E69636F726E2F';
wwv_flow_imp.g_varchar2_table(595) := '7072656665722D646F6D2D6E6F64652D617070656E640A20202020202020202020626F64792E617070656E644368696C6428696D706F727465644E6F6465293B0A20202020202020207D0A2020202020207D20656C7365207B0A20202020202020202F2A';
wwv_flow_imp.g_varchar2_table(596) := '2045786974206469726563746C792069662077652068617665206E6F7468696E6720746F20646F202A2F0A2020202020202020696620282152455455524E5F444F4D2026262021534146455F464F525F54454D504C41544553202626202157484F4C455F';
wwv_flow_imp.g_varchar2_table(597) := '444F43554D454E542026260A20202020202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E6520756E69636F726E2F7072656665722D696E636C756465730A202020202020202064697274792E696E6465784F6628273C2729203D';
wwv_flow_imp.g_varchar2_table(598) := '3D3D202D3129207B0A2020202020202020202072657475726E20747275737465645479706573506F6C6963792026262052455455524E5F545255535445445F54595045203F20747275737465645479706573506F6C6963792E63726561746548544D4C28';
wwv_flow_imp.g_varchar2_table(599) := '646972747929203A2064697274793B0A20202020202020207D0A0A20202020202020202F2A20496E697469616C697A652074686520646F63756D656E7420746F20776F726B206F6E202A2F0A2020202020202020626F6479203D205F696E6974446F6375';
wwv_flow_imp.g_varchar2_table(600) := '6D656E74286469727479293B0A0A20202020202020202F2A20436865636B2077652068617665206120444F4D206E6F64652066726F6D207468652064617461202A2F0A20202020202020206966202821626F647929207B0A202020202020202020207265';
wwv_flow_imp.g_varchar2_table(601) := '7475726E2052455455524E5F444F4D203F206E756C6C203A2052455455524E5F545255535445445F54595045203F20656D70747948544D4C203A2027273B0A20202020202020207D0A2020202020207D0A0A2020202020202F2A2052656D6F7665206669';
wwv_flow_imp.g_varchar2_table(602) := '72737420656C656D656E74206E6F646520286F7572732920696620464F5243455F424F445920697320736574202A2F0A20202020202069662028626F647920262620464F5243455F424F445929207B0A20202020202020205F666F72636552656D6F7665';
wwv_flow_imp.g_varchar2_table(603) := '28626F64792E66697273744368696C64293B0A2020202020207D0A0A2020202020202F2A20476574206E6F6465206974657261746F72202A2F0A202020202020636F6E7374206E6F64654974657261746F72203D205F6372656174654E6F646549746572';
wwv_flow_imp.g_varchar2_table(604) := '61746F7228494E5F504C414345203F206469727479203A20626F6479293B0A0A2020202020202F2A204E6F7720737461727420697465726174696E67206F76657220746865206372656174656420646F63756D656E74202A2F0A2020202020207768696C';
wwv_flow_imp.g_varchar2_table(605) := '65202863757272656E744E6F6465203D206E6F64654974657261746F722E6E6578744E6F6465282929207B0A20202020202020202F2A2053616E6974697A65207461677320616E6420656C656D656E7473202A2F0A2020202020202020696620285F7361';
wwv_flow_imp.g_varchar2_table(606) := '6E6974697A65456C656D656E74732863757272656E744E6F64652929207B0A20202020202020202020636F6E74696E75653B0A20202020202020207D0A0A20202020202020202F2A20536861646F7720444F4D2064657465637465642C2073616E697469';
wwv_flow_imp.g_varchar2_table(607) := '7A65206974202A2F0A20202020202020206966202863757272656E744E6F64652E636F6E74656E7420696E7374616E63656F6620446F63756D656E74467261676D656E7429207B0A202020202020202020205F73616E6974697A65536861646F77444F4D';
wwv_flow_imp.g_varchar2_table(608) := '2863757272656E744E6F64652E636F6E74656E74293B0A20202020202020207D0A0A20202020202020202F2A20436865636B20617474726962757465732C2073616E6974697A65206966206E6563657373617279202A2F0A20202020202020205F73616E';
wwv_flow_imp.g_varchar2_table(609) := '6974697A65417474726962757465732863757272656E744E6F6465293B0A2020202020207D0A0A2020202020202F2A2049662077652073616E6974697A6564206064697274796020696E2D706C6163652C2072657475726E2069742E202A2F0A20202020';
wwv_flow_imp.g_varchar2_table(610) := '202069662028494E5F504C41434529207B0A202020202020202072657475726E2064697274793B0A2020202020207D0A0A2020202020202F2A2052657475726E2073616E6974697A656420737472696E67206F7220444F4D202A2F0A2020202020206966';
wwv_flow_imp.g_varchar2_table(611) := '202852455455524E5F444F4D29207B0A20202020202020206966202852455455524E5F444F4D5F465241474D454E5429207B0A2020202020202020202072657475726E4E6F6465203D20637265617465446F63756D656E74467261676D656E742E63616C';
wwv_flow_imp.g_varchar2_table(612) := '6C28626F64792E6F776E6572446F63756D656E74293B0A202020202020202020207768696C652028626F64792E66697273744368696C6429207B0A2020202020202020202020202F2F2065736C696E742D64697361626C652D6E6578742D6C696E652075';
wwv_flow_imp.g_varchar2_table(613) := '6E69636F726E2F7072656665722D646F6D2D6E6F64652D617070656E640A20202020202020202020202072657475726E4E6F64652E617070656E644368696C6428626F64792E66697273744368696C64293B0A202020202020202020207D0A2020202020';
wwv_flow_imp.g_varchar2_table(614) := '2020207D20656C7365207B0A2020202020202020202072657475726E4E6F6465203D20626F64793B0A20202020202020207D0A202020202020202069662028414C4C4F5745445F415454522E736861646F77726F6F74207C7C20414C4C4F5745445F4154';
wwv_flow_imp.g_varchar2_table(615) := '54522E736861646F77726F6F746D6F646529207B0A202020202020202020202F2A0A20202020202020202020202041646F70744E6F64652829206973206E6F742075736564206265636175736520696E7465726E616C207374617465206973206E6F7420';
wwv_flow_imp.g_varchar2_table(616) := '72657365740A20202020202020202020202028652E672E207468652070617374206E616D6573206D6170206F6620612048544D4C466F726D456C656D656E74292C207468697320697320736166650A202020202020202020202020696E207468656F7279';
wwv_flow_imp.g_varchar2_table(617) := '2062757420776520776F756C6420726174686572206E6F74207269736B20616E6F746865722061747461636B20766563746F722E0A202020202020202020202020546865207374617465207468617420697320636C6F6E656420627920696D706F72744E';
wwv_flow_imp.g_varchar2_table(618) := '6F64652829206973206578706C696369746C7920646566696E65640A2020202020202020202020206279207468652073706563732E0A202020202020202020202A2F0A2020202020202020202072657475726E4E6F6465203D20696D706F72744E6F6465';
wwv_flow_imp.g_varchar2_table(619) := '2E63616C6C286F726967696E616C446F63756D656E742C2072657475726E4E6F64652C2074727565293B0A20202020202020207D0A202020202020202072657475726E2072657475726E4E6F64653B0A2020202020207D0A2020202020206C6574207365';
wwv_flow_imp.g_varchar2_table(620) := '7269616C697A656448544D4C203D2057484F4C455F444F43554D454E54203F20626F64792E6F7574657248544D4C203A20626F64792E696E6E657248544D4C3B0A0A2020202020202F2A2053657269616C697A6520646F637479706520696620616C6C6F';
wwv_flow_imp.g_varchar2_table(621) := '776564202A2F0A2020202020206966202857484F4C455F444F43554D454E5420262620414C4C4F5745445F544147535B2721646F6374797065275D20262620626F64792E6F776E6572446F63756D656E7420262620626F64792E6F776E6572446F63756D';
wwv_flow_imp.g_varchar2_table(622) := '656E742E646F637479706520262620626F64792E6F776E6572446F63756D656E742E646F63747970652E6E616D65202626207265674578705465737428444F43545950455F4E414D452C20626F64792E6F776E6572446F63756D656E742E646F63747970';
wwv_flow_imp.g_varchar2_table(623) := '652E6E616D652929207B0A202020202020202073657269616C697A656448544D4C203D20273C21444F43545950452027202B20626F64792E6F776E6572446F63756D656E742E646F63747970652E6E616D65202B20273E5C6E27202B2073657269616C69';
wwv_flow_imp.g_varchar2_table(624) := '7A656448544D4C3B0A2020202020207D0A0A2020202020202F2A2053616E6974697A652066696E616C20737472696E672074656D706C6174652D73616665202A2F0A20202020202069662028534146455F464F525F54454D504C4154455329207B0A2020';
wwv_flow_imp.g_varchar2_table(625) := '2020202020206172726179466F7245616368285B4D555354414348455F455850522C204552425F455850522C20544D504C49545F455850525D2C2065787072203D3E207B0A2020202020202020202073657269616C697A656448544D4C203D2073747269';
wwv_flow_imp.g_varchar2_table(626) := '6E675265706C6163652873657269616C697A656448544D4C2C20657870722C20272027293B0A20202020202020207D293B0A2020202020207D0A20202020202072657475726E20747275737465645479706573506F6C6963792026262052455455524E5F';
wwv_flow_imp.g_varchar2_table(627) := '545255535445445F54595045203F20747275737465645479706573506F6C6963792E63726561746548544D4C2873657269616C697A656448544D4C29203A2073657269616C697A656448544D4C3B0A202020207D3B0A0A202020202F2A2A0A2020202020';
wwv_flow_imp.g_varchar2_table(628) := '2A205075626C6963206D6574686F6420746F207365742074686520636F6E66696775726174696F6E206F6E63650A20202020202A20736574436F6E6669670A20202020202A0A20202020202A2040706172616D207B4F626A6563747D2063666720636F6E';
wwv_flow_imp.g_varchar2_table(629) := '66696775726174696F6E206F626A6563740A20202020202A2F0A20202020444F4D5075726966792E736574436F6E666967203D2066756E6374696F6E202829207B0A2020202020206C657420636667203D20617267756D656E74732E6C656E677468203E';
wwv_flow_imp.g_varchar2_table(630) := '203020262620617267756D656E74735B305D20213D3D20756E646566696E6564203F20617267756D656E74735B305D203A207B7D3B0A2020202020205F7061727365436F6E66696728636667293B0A2020202020205345545F434F4E464947203D207472';
wwv_flow_imp.g_varchar2_table(631) := '75653B0A202020207D3B0A0A202020202F2A2A0A20202020202A205075626C6963206D6574686F6420746F2072656D6F76652074686520636F6E66696775726174696F6E0A20202020202A20636C656172436F6E6669670A20202020202A0A2020202020';
wwv_flow_imp.g_varchar2_table(632) := '2A2F0A20202020444F4D5075726966792E636C656172436F6E666967203D2066756E6374696F6E202829207B0A202020202020434F4E464947203D206E756C6C3B0A2020202020205345545F434F4E464947203D2066616C73653B0A202020207D3B0A0A';
wwv_flow_imp.g_varchar2_table(633) := '202020202F2A2A0A20202020202A205075626C6963206D6574686F6420746F20636865636B20696620616E206174747269627574652076616C75652069732076616C69642E0A20202020202A2055736573206C6173742073657420636F6E6669672C2069';
wwv_flow_imp.g_varchar2_table(634) := '6620616E792E204F74686572776973652C207573657320636F6E6669672064656661756C74732E0A20202020202A20697356616C69644174747269627574650A20202020202A0A20202020202A2040706172616D20207B537472696E677D207461672054';
wwv_flow_imp.g_varchar2_table(635) := '6167206E616D65206F6620636F6E7461696E696E6720656C656D656E742E0A20202020202A2040706172616D20207B537472696E677D206174747220417474726962757465206E616D652E0A20202020202A2040706172616D20207B537472696E677D20';
wwv_flow_imp.g_varchar2_table(636) := '76616C7565204174747269627574652076616C75652E0A20202020202A204072657475726E207B426F6F6C65616E7D2052657475726E732074727565206966206076616C7565602069732076616C69642E204F74686572776973652C2072657475726E73';
wwv_flow_imp.g_varchar2_table(637) := '2066616C73652E0A20202020202A2F0A20202020444F4D5075726966792E697356616C6964417474726962757465203D2066756E6374696F6E20287461672C20617474722C2076616C756529207B0A2020202020202F2A20496E697469616C697A652073';
wwv_flow_imp.g_varchar2_table(638) := '686172656420636F6E6669672076617273206966206E65636573736172792E202A2F0A2020202020206966202821434F4E46494729207B0A20202020202020205F7061727365436F6E666967287B7D293B0A2020202020207D0A202020202020636F6E73';
wwv_flow_imp.g_varchar2_table(639) := '74206C63546167203D207472616E73666F726D4361736546756E6328746167293B0A202020202020636F6E7374206C634E616D65203D207472616E73666F726D4361736546756E632861747472293B0A20202020202072657475726E205F697356616C69';
wwv_flow_imp.g_varchar2_table(640) := '64417474726962757465286C635461672C206C634E616D652C2076616C7565293B0A202020207D3B0A0A202020202F2A2A0A20202020202A20416464486F6F6B0A20202020202A205075626C6963206D6574686F6420746F2061646420444F4D50757269';
wwv_flow_imp.g_varchar2_table(641) := '667920686F6F6B730A20202020202A0A20202020202A2040706172616D207B537472696E677D20656E747279506F696E7420656E74727920706F696E7420666F722074686520686F6F6B20746F206164640A20202020202A2040706172616D207B46756E';
wwv_flow_imp.g_varchar2_table(642) := '6374696F6E7D20686F6F6B46756E6374696F6E2066756E6374696F6E20746F20657865637574650A20202020202A2F0A20202020444F4D5075726966792E616464486F6F6B203D2066756E6374696F6E2028656E747279506F696E742C20686F6F6B4675';
wwv_flow_imp.g_varchar2_table(643) := '6E6374696F6E29207B0A20202020202069662028747970656F6620686F6F6B46756E6374696F6E20213D3D202766756E6374696F6E2729207B0A202020202020202072657475726E3B0A2020202020207D0A202020202020686F6F6B735B656E74727950';
wwv_flow_imp.g_varchar2_table(644) := '6F696E745D203D20686F6F6B735B656E747279506F696E745D207C7C205B5D3B0A20202020202061727261795075736828686F6F6B735B656E747279506F696E745D2C20686F6F6B46756E6374696F6E293B0A202020207D3B0A0A202020202F2A2A0A20';
wwv_flow_imp.g_varchar2_table(645) := '202020202A2052656D6F7665486F6F6B0A20202020202A205075626C6963206D6574686F6420746F2072656D6F7665206120444F4D50757269667920686F6F6B206174206120676976656E20656E747279506F696E740A20202020202A2028706F707320';
wwv_flow_imp.g_varchar2_table(646) := '69742066726F6D2074686520737461636B206F6620686F6F6B73206966206D6F7265206172652070726573656E74290A20202020202A0A20202020202A2040706172616D207B537472696E677D20656E747279506F696E7420656E74727920706F696E74';
wwv_flow_imp.g_varchar2_table(647) := '20666F722074686520686F6F6B20746F2072656D6F76650A20202020202A204072657475726E207B46756E6374696F6E7D2072656D6F76656428706F707065642920686F6F6B0A20202020202A2F0A20202020444F4D5075726966792E72656D6F766548';
wwv_flow_imp.g_varchar2_table(648) := '6F6F6B203D2066756E6374696F6E2028656E747279506F696E7429207B0A20202020202069662028686F6F6B735B656E747279506F696E745D29207B0A202020202020202072657475726E206172726179506F7028686F6F6B735B656E747279506F696E';
wwv_flow_imp.g_varchar2_table(649) := '745D293B0A2020202020207D0A202020207D3B0A0A202020202F2A2A0A20202020202A2052656D6F7665486F6F6B730A20202020202A205075626C6963206D6574686F6420746F2072656D6F766520616C6C20444F4D50757269667920686F6F6B732061';
wwv_flow_imp.g_varchar2_table(650) := '74206120676976656E20656E747279506F696E740A20202020202A0A20202020202A2040706172616D20207B537472696E677D20656E747279506F696E7420656E74727920706F696E7420666F722074686520686F6F6B7320746F2072656D6F76650A20';
wwv_flow_imp.g_varchar2_table(651) := '202020202A2F0A20202020444F4D5075726966792E72656D6F7665486F6F6B73203D2066756E6374696F6E2028656E747279506F696E7429207B0A20202020202069662028686F6F6B735B656E747279506F696E745D29207B0A2020202020202020686F';
wwv_flow_imp.g_varchar2_table(652) := '6F6B735B656E747279506F696E745D203D205B5D3B0A2020202020207D0A202020207D3B0A0A202020202F2A2A0A20202020202A2052656D6F7665416C6C486F6F6B730A20202020202A205075626C6963206D6574686F6420746F2072656D6F76652061';
wwv_flow_imp.g_varchar2_table(653) := '6C6C20444F4D50757269667920686F6F6B730A20202020202A2F0A20202020444F4D5075726966792E72656D6F7665416C6C486F6F6B73203D2066756E6374696F6E202829207B0A202020202020686F6F6B73203D207B7D3B0A202020207D3B0A202020';
wwv_flow_imp.g_varchar2_table(654) := '2072657475726E20444F4D5075726966793B0A20207D0A202076617220707572696679203D20637265617465444F4D50757269667928293B0A0A202072657475726E207075726966793B0A0A7D29293B0A2F2F2320736F757263654D617070696E675552';
wwv_flow_imp.g_varchar2_table(655) := '4C3D7075726966792E6A732E6D61700A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(165269427491350477963)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_file_name=>'purify.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '636F6E737420756E6C6561736854696E794D4345203D2066756E6374696F6E2028617065782C20242C20646F6D50757269667929207B0A202020202275736520737472696374223B0A20202020636F6E7374207574696C203D207B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(2) := '6665617475726544657461696C733A207B0A2020202020202020202020206E616D653A20224150455820556E6C65617368205269636854657874456469746F72202854696E794D434529222C0A2020202020202020202020207363726970745665727369';
wwv_flow_imp.g_varchar2_table(3) := '6F6E3A202232342E30332E3232222C0A2020202020202020202020207574696C56657273696F6E3A202232322E31312E3238222C0A20202020202020202020202075726C3A202268747470733A2F2F6769746875622E636F6D2F526F6E6E795765697373';
wwv_flow_imp.g_varchar2_table(4) := '222C0A2020202020202020202020206C6963656E73653A20224D4954220A20202020202020207D2C0A20202020202020206C6F616465723A207B0A20202020202020202020202073746172743A2066756E6374696F6E202869642C207365744D696E4865';
wwv_flow_imp.g_varchar2_table(5) := '6967687429207B0A20202020202020202020202020202020696620287365744D696E48656967687429207B0A202020202020202020202020202020202020202024286964292E63737328226D696E2D686569676874222C2022313030707822293B0A2020';
wwv_flow_imp.g_varchar2_table(6) := '20202020202020202020202020207D0A20202020202020202020202020202020617065782E7574696C2E73686F775370696E6E6572282428696429293B0A2020202020202020202020207D2C0A20202020202020202020202073746F703A2066756E6374';
wwv_flow_imp.g_varchar2_table(7) := '696F6E202869642C2072656D6F76654D696E48656967687429207B0A202020202020202020202020202020206966202872656D6F76654D696E48656967687429207B0A202020202020202020202020202020202020202024286964292E63737328226D69';
wwv_flow_imp.g_varchar2_table(8) := '6E2D686569676874222C202222293B0A202020202020202020202020202020207D0A2020202020202020202020202020202024286964202B2022203E202E752D50726F63657373696E6722292E72656D6F766528293B0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(9) := '20202024286964202B2022203E202E63742D6C6F6164657222292E72656D6F766528293B0A2020202020202020202020207D0A20202020202020207D2C0A20202020202020206A736F6E53617665457874656E643A2066756E6374696F6E202873726343';
wwv_flow_imp.g_varchar2_table(10) := '6F6E6669672C20746172676574436F6E66696729207B0A2020202020202020202020206C65742066696E616C436F6E666967203D207B7D3B0A2020202020202020202020206C657420746D704A534F4E203D207B7D3B0A2020202020202020202020202F';
wwv_flow_imp.g_varchar2_table(11) := '2A2074727920746F20706172736520636F6E666967206A736F6E207768656E20737472696E67206F72206A75737420736574202A2F0A20202020202020202020202069662028747970656F6620746172676574436F6E666967203D3D3D2022737472696E';
wwv_flow_imp.g_varchar2_table(12) := '672229207B0A20202020202020202020202020202020747279207B0A2020202020202020202020202020202020202020746D704A534F4E203D204A534F4E2E706172736528746172676574436F6E666967293B0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(13) := '7D20636174636820286529207B0A2020202020202020202020202020202020202020617065782E64656275672E6572726F72287B0A202020202020202020202020202020202020202020202020226D6F64756C65223A20227574696C2E6A73222C0A2020';
wwv_flow_imp.g_varchar2_table(14) := '20202020202020202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F20706172736520746172676574436F6E6669672E20506C6561736520636865636B20796F757220436F6E666967204A534F4E2E20';
wwv_flow_imp.g_varchar2_table(15) := '5374616E6461726420436F6E6669672077696C6C20626520757365642E222C0A20202020202020202020202020202020202020202020202022657272223A20652C0A20202020202020202020202020202020202020202020202022746172676574436F6E';
wwv_flow_imp.g_varchar2_table(16) := '666967223A20746172676574436F6E6669670A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202020746D';
wwv_flow_imp.g_varchar2_table(17) := '704A534F4E203D20242E657874656E6428747275652C207B7D2C20746172676574436F6E666967293B0A2020202020202020202020207D0A2020202020202020202020202F2A2074727920746F206D657267652077697468207374616E64617264206966';
wwv_flow_imp.g_varchar2_table(18) := '20616E7920617474726962757465206973206D697373696E67202A2F0A202020202020202020202020747279207B0A2020202020202020202020202020202066696E616C436F6E666967203D20242E657874656E6428747275652C207B7D2C2073726343';
wwv_flow_imp.g_varchar2_table(19) := '6F6E6669672C20746D704A534F4E293B0A2020202020202020202020207D20636174636820286529207B0A2020202020202020202020202020202066696E616C436F6E666967203D20242E657874656E6428747275652C207B7D2C20737263436F6E6669';
wwv_flow_imp.g_varchar2_table(20) := '67293B0A20202020202020202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202020202020226D6F64756C65223A20227574696C2E6A73222C0A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(21) := '226D7367223A20224572726F72207768696C652074727920746F206D657267652032204A534F4E7320696E746F207374616E64617264204A534F4E20696620616E7920617474726962757465206973206D697373696E672E20506C656173652063686563';
wwv_flow_imp.g_varchar2_table(22) := '6B20796F757220436F6E666967204A534F4E2E205374616E6461726420436F6E6669672077696C6C20626520757365642E222C0A202020202020202020202020202020202020202022657272223A20652C0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(23) := '20202266696E616C436F6E666967223A2066696E616C436F6E6669670A202020202020202020202020202020207D293B0A2020202020202020202020207D0A20202020202020202020202072657475726E2066696E616C436F6E6669673B0A2020202020';
wwv_flow_imp.g_varchar2_table(24) := '2020207D2C0A202020207D3B0A0A20202020636F6E737420494D475F4149485F53454C203D2060696D675B616C742A3D2261696823225D602C0A20202020202020204149485F4B4559203D20226169682323223B0A0A202020202F2F205573656420746F';
wwv_flow_imp.g_varchar2_table(25) := '20636C65616E757020696D61676520737263206265666F7265207274652069732073617665640A2020202066756E6374696F6E206765745374696C6C4578697374696E67496D6167657328704F70747329207B0A20202020202020206C657420706B4172';
wwv_flow_imp.g_varchar2_table(26) := '72203D205B5D2C0A202020202020202020202020646976203D202428223C6469763E22293B0A0A20202020202020206469765B305D2E696E6E657248544D4C203D20704F7074732E727465496E7374616E63652E676574436F6E74656E7428293B0A2020';
wwv_flow_imp.g_varchar2_table(27) := '202020202020242E65616368286469762E66696E6428494D475F4149485F53454C292C2066756E6374696F6E2028692C20696D674974656D29207B0A2020202020202020202020206C657420706B203D20696D674974656D2E7469746C653B0A20202020';
wwv_flow_imp.g_varchar2_table(28) := '20202020202020206966202821706B29207B0A20202020202020202020202020202020706B203D20696D674974656D2E616C742E73706C6974284149485F4B4559295B315D3B0A2020202020202020202020207D0A202020202020202020202020706B41';
wwv_flow_imp.g_varchar2_table(29) := '72722E7075736828706B293B0A20202020202020207D293B0A202020202020202072657475726E20706B4172723B0A202020207D0A0A202020202F2F205573656420746F20636C65616E757020696D61676520737263206265666F726520727465206973';
wwv_flow_imp.g_varchar2_table(30) := '2073617665640A2020202066756E6374696F6E20636C65616E5570496D6167655372632870456469746F7229207B0A20202020202020206C657420646976203D202428223C6469763E22293B0A20202020202020206469762E68746D6C2870456469746F';
wwv_flow_imp.g_varchar2_table(31) := '722E676574436F6E74656E742829293B0A20202020202020206469762E66696E6428494D475F4149485F53454C292E617474722822737263222C202261696822293B0A202020202020202072657475726E206469765B305D2E696E6E657248544D4C3B0A';
wwv_flow_imp.g_varchar2_table(32) := '202020207D0A0A202020202F2F205573656420746F20636C65616E757020696D61676520737263206265666F7265207274652069732073617665640A2020202066756E6374696F6E207570646174655570496D61676553726328704F7074732C2070436F';
wwv_flow_imp.g_varchar2_table(33) := '6E29207B0A20202020202020206C657420646976203D202428223C6469763E22292C0A202020202020202020202020696D674974656D733B0A0A20202020202020206469762E68746D6C2870436F6E293B0A2020202020202020747279207B0A20202020';
wwv_flow_imp.g_varchar2_table(34) := '2020202020202020696D674974656D73203D206469762E66696E6428494D475F4149485F53454C293B0A202020202020202020202020242E6561636828696D674974656D732C2066756E6374696F6E20286964782C20696D674974656D29207B0A202020';
wwv_flow_imp.g_varchar2_table(35) := '202020202020202020202020206C657420706B203D20696D674974656D2E7469746C653B0A202020202020202020202020202020206966202821706B29207B0A2020202020202020202020202020202020202020706B203D20696D674974656D2E616C74';
wwv_flow_imp.g_varchar2_table(36) := '2E73706C6974284149485F4B4559295B315D3B0A202020202020202020202020202020207D0A2020202020202020202020202020202069662028706B29207B0A2020202020202020202020202020202020202020696D674974656D2E737263203D206170';
wwv_flow_imp.g_varchar2_table(37) := '65782E7365727665722E706C7567696E55726C28704F7074732E616A617849442C207B0A2020202020202020202020202020202020202020202020207830313A20225052494E545F494D414745222C0A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(38) := '202020207830323A20706B2C0A202020202020202020202020202020202020202020202020706167654974656D733A20704F7074732E6974656D73325375626D6974496D67446F776E0A20202020202020202020202020202020202020207D293B0A2020';
wwv_flow_imp.g_varchar2_table(39) := '20202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202020617065782E64656275672E6572726F72287B0A20202020202020202020202020202020202020202020202022666374223A2060247B7574696C';
wwv_flow_imp.g_varchar2_table(40) := '2E6665617475726544657461696C732E6E616D657D202D207570646174655570496D616765537263602C0A202020202020202020202020202020202020202020202020226D7367223A20605072696D617279206B6579206F6620247B4149485F4B45597D';
wwv_flow_imp.g_varchar2_table(41) := '206973206D697373696E67602C0A202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020202020202020202020202020207D293B0A';
wwv_flow_imp.g_varchar2_table(42) := '202020202020202020202020202020207D0A2020202020202020202020207D293B0A0A202020202020202020202020696620286469765B305D2E696E6E657248544D4C29207B0A20202020202020202020202020202020704F7074732E7274654974656D';
wwv_flow_imp.g_varchar2_table(43) := '2E73657456616C7565286469765B305D2E696E6E657248544D4C2C206E756C6C2C20704F7074732E73757070726573734368616E67654576656E74293B0A2020202020202020202020207D0A20202020202020207D20636174636820286529207B0A2020';
wwv_flow_imp.g_varchar2_table(44) := '20202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202022666374223A2060247B7574696C2E6665617475726544657461696C732E6E616D657D202D207570646174655570496D61676553726360';
wwv_flow_imp.g_varchar2_table(45) := '2C0A20202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F206C6F616420696D61676573207768656E206C6F6164696E672072696368207465787420656469746F722E222C0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(46) := '20202020202022657272223A20652C0A20202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A2020202020202020202020207D293B0A20202020202020207D0A20202020';
wwv_flow_imp.g_varchar2_table(47) := '7D0A0A202020202F2F205573656420746F2075706C6F61642061206E657720696D616765200A2020202066756E6374696F6E2075706C6F616446696C657328704F70747329207B0A2020202020202020747279207B0A202020202020202020202020704F';
wwv_flow_imp.g_varchar2_table(48) := '7074732E727465496E7374616E63652E656469746F7255706C6F61642E7363616E466F72496D6167657328292E7468656E280A2020202020202020202020202020202066756E6374696F6E2028726573706F6E736529207B0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(49) := '20202020202020202069662028726573706F6E73653F2E6C656E677468203E203029207B0A20202020202020202020202020202020202020202020202069662028704F7074732E73686F774C6F6164657229207B0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(50) := '202020202020202020202020207574696C2E6C6F616465722E737461727428704F7074732E727465436F6E7461696E657253656C293B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(51) := '2020202020726573706F6E73652E666F72456163682866756E6374696F6E2028656C656D656E742C20696E64657829207B0A20202020202020202020202020202020202020202020202020202020636F6E737420626C6F62496E666F203D20656C656D65';
wwv_flow_imp.g_varchar2_table(52) := '6E742E626C6F62496E666F2C0A202020202020202020202020202020202020202020202020202020202020202066696C654E616D65203D20626C6F62496E666F2E66696C656E616D6528292C0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(53) := '2020202020202020206D696D6554797065203D20626C6F62496E666F2E626C6F6228292E747970652C0A202020202020202020202020202020202020202020202020202020202020202062617365363446696C65203D2022646174613A22202B20626C6F';
wwv_flow_imp.g_varchar2_table(54) := '62496E666F2E626C6F6228292E74797065202B20223B6261736536342C22202B20626C6F62496E666F2E62617365363428293B0A0A20202020202020202020202020202020202020202020202020202020617065782E64656275672E696E666F287B0A20';
wwv_flow_imp.g_varchar2_table(55) := '2020202020202020202020202020202020202020202020202020202020202022666374223A2060247B7574696C2E6665617475726544657461696C732E6E616D657D202D2075706C6F616446696C6573602C0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(56) := '2020202020202020202020202020202266696C654E616D65223A2066696C654E616D652C0A2020202020202020202020202020202020202020202020202020202020202020226D696D6554797065223A206D696D65547970652C0A202020202020202020';
wwv_flow_imp.g_varchar2_table(57) := '20202020202020202020202020202020202020202020202262617365363446696C65223A2062617365363446696C652C0A2020202020202020202020202020202020202020202020202020202020202020226665617475726544657461696C73223A2075';
wwv_flow_imp.g_varchar2_table(58) := '74696C2E6665617475726544657461696C730A202020202020202020202020202020202020202020202020202020207D293B0A0A20202020202020202020202020202020202020202020202020202020617065782E7365727665722E706C7567696E2870';
wwv_flow_imp.g_varchar2_table(59) := '4F7074732E616A617849442C207B0A20202020202020202020202020202020202020202020202020202020202020207830313A202255504C4F41445F494D414745222C0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(60) := '7830323A2066696C654E616D652C0A20202020202020202020202020202020202020202020202020202020202020207830333A206D696D65547970652C0A20202020202020202020202020202020202020202020202020202020202020207830343A2069';
wwv_flow_imp.g_varchar2_table(61) := '6E6465782C0A2020202020202020202020202020202020202020202020202020202020202020705F636C6F625F30313A20626C6F62496E666F2E62617365363428292C0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(62) := '706167654974656D733A20704F7074732E6974656D73325375626D6974496D6755700A202020202020202020202020202020202020202020202020202020207D2C207B0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(63) := '737563636573733A2066756E6374696F6E2028704461746129207B0A202020202020202020202020202020202020202020202020202020202020202020202020636F6E737420626C6F62496E666F53656E64203D20726573706F6E73655B70446174612E';
wwv_flow_imp.g_varchar2_table(64) := '696E6465785D2E626C6F62496E666F3B0A202020202020202020202020202020202020202020202020202020202020202020202020636F6E737420737263203D2022646174613A22202B20626C6F62496E666F53656E642E626C6F6228292E7479706520';
wwv_flow_imp.g_varchar2_table(65) := '2B20223B6261736536342C22202B20626C6F62496E666F53656E642E62617365363428293B0A0A2020202020202020202020202020202020202020202020202020202020202020202020206C65742064697654656D70203D202428223C6469763E22293B';
wwv_flow_imp.g_varchar2_table(66) := '0A20202020202020202020202020202020202020202020202020202020202020202020202064697654656D702E68746D6C28704F7074732E727465496E7374616E63652E676574436F6E74656E742829293B0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(67) := '2020202020202020202020202020202020202064697654656D702E66696E642860696D675B7372633D22247B7372637D225D60292E656163682866756E6374696F6E2028692C20656C656D656E7429207B0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(68) := '202020202020202020202020202020202020202020202428656C656D656E74292E617474722822737263222C20617065782E7365727665722E706C7567696E55726C28704F7074732E616A617849442C207B0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(69) := '2020202020202020202020202020202020202020202020202020207830313A20225052494E545F494D414745222C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020207830323A2070446174';
wwv_flow_imp.g_varchar2_table(70) := '612E706B2C0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020706167654974656D733A20704F7074732E6974656D73325375626D6974496D67446F776E0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(71) := '2020202020202020202020202020202020202020202020202020207D29293B0A202020202020202020202020202020202020202020202020202020202020202020202020202020202428656C656D656E74292E63737328226D61782D7769647468222C20';
wwv_flow_imp.g_varchar2_table(72) := '704F7074732E6D6178496D6167655769647468293B0A202020202020202020202020202020202020202020202020202020202020202020202020202020202428656C656D656E74292E617474722822616C74222C204149485F4B4559202B207044617461';
wwv_flow_imp.g_varchar2_table(73) := '2E706B293B0A20202020202020202020202020202020202020202020202020202020202020202020202020202020704F7074732E727465496E7374616E63652E656469746F7255706C6F61642E64657374726F7928293B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(74) := '202020202020202020202020202020202020202020202020202020206966202864697654656D705B305D2E696E6E657248544D4C29207B0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(75) := '704F7074732E7274654974656D2E73657456616C75652864697654656D705B305D2E696E6E657248544D4C2C206E756C6C2C20704F7074732E73757070726573734368616E67654576656E74293B0A202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(76) := '202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020202020202020202020202020207D293B0A202020202020202020202020202020202020202020202020202020202020202020202020696620';
wwv_flow_imp.g_varchar2_table(77) := '282870446174612E696E646578202B203129203D3D3D20726573706F6E73652E6C656E67746829207B0A20202020202020202020202020202020202020202020202020202020202020202020202020202020617065782E6576656E742E74726967676572';
wwv_flow_imp.g_varchar2_table(78) := '28704F7074732E72746553656C2C2022696D61676575706C6F616469666E697368656422293B0A2020202020202020202020202020202020202020202020202020202020202020202020202020202069662028704F7074732E73686F774C6F6164657229';
wwv_flow_imp.g_varchar2_table(79) := '207B0A20202020202020202020202020202020202020202020202020202020202020202020202020202020202020207574696C2E6C6F616465722E73746F7028704F7074732E727465436F6E7461696E657253656C293B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(80) := '202020202020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(81) := '7D2C0A20202020202020202020202020202020202020202020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(82) := '20202020202020202020202020202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202020202020202020202020202020202020202020202020202022666374223A2060247B7574696C2E66656174';
wwv_flow_imp.g_varchar2_table(83) := '75726544657461696C732E6E616D657D202D2075706C6F616446696C6573602C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020226D7367223A2022496D6167652055706C6F6164206572726F7222';
wwv_flow_imp.g_varchar2_table(84) := '2C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020226A71584852223A206A715848522C0A202020202020202020202020202020202020202020202020202020202020202020202020202020202274';
wwv_flow_imp.g_varchar2_table(85) := '657874537461747573223A20746578745374617475732C0A20202020202020202020202020202020202020202020202020202020202020202020202020202020226572726F725468726F776E223A206572726F725468726F776E2C0A2020202020202020';
wwv_flow_imp.g_varchar2_table(86) := '2020202020202020202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(87) := '2020202020207D293B0A20202020202020202020202020202020202020202020202020202020202020202020202069662028704F7074732E73686F774C6F6164657229207B0A202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(88) := '202020202020202020207574696C2E6C6F616465722E73746F7028704F7074732E727465436F6E7461696E657253656C293B0A2020202020202020202020202020202020202020202020202020202020202020202020207D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(89) := '20202020202020202020202020202020202020202020202020617065782E6576656E742E7472696767657228704F7074732E72746553656C2C2022696D61676575706C6F61646572726F7222293B0A202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(90) := '20202020202020202020207D0A202020202020202020202020202020202020202020202020202020207D293B0A2020202020202020202020202020202020202020202020207D293B0A20202020202020202020202020202020202020207D0A2020202020';
wwv_flow_imp.g_varchar2_table(91) := '20202020202020202020207D293B0A20202020202020207D20636174636820286529207B0A202020202020202020202020617065782E64656275672E6572726F72287B0A2020202020202020202020202020202022666374223A2060247B7574696C2E66';
wwv_flow_imp.g_varchar2_table(92) := '65617475726544657461696C732E6E616D657D202D2075706C6F616446696C6573602C0A20202020202020202020202020202020226D7367223A20224572726F72207768696C652074727920746F2061646420696D6167657320746F20746F2064622061';
wwv_flow_imp.g_varchar2_table(93) := '667465722064726F70206F7220706173746520696D616765222C0A2020202020202020202020202020202022657272223A20652C0A20202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544';
wwv_flow_imp.g_varchar2_table(94) := '657461696C730A2020202020202020202020207D293B0A20202020202020207D0A202020207D0A0A202020202F2F205573656420746F2073616E6974697A652048544D4C0A2020202066756E6374696F6E2073616E6974697A65434C4F422870434C4F42';
wwv_flow_imp.g_varchar2_table(95) := '2C20704F70747329207B0A202020202020202072657475726E20646F6D5075726966792E73616E6974697A652870434C4F422C20704F7074732E73616E6974697A654F7074696F6E73293B0A202020207D0A0A202020202F2F205573656420746F207072';
wwv_flow_imp.g_varchar2_table(96) := '696E742074686520636C6F622076616C756520746F2074686520656C656D656E747320746861742061726520696E2064617461206A736F6E0A2020202066756E6374696F6E207072696E74436C6F622870546869732C2070446174612C20704F70747329';
wwv_flow_imp.g_varchar2_table(97) := '207B0A2020202020202020747279207B0A2020202020202020202020206C6574207374723B0A0A2020202020202020202020206966202870446174612026262070446174612E726F772026262070446174612E726F775B305D2026262070446174612E72';
wwv_flow_imp.g_varchar2_table(98) := '6F775B305D2E434C4F425F56414C554529207B0A20202020202020202020202020202020737472203D202222202B2070446174612E726F775B305D2E434C4F425F56414C55453B0A2020202020202020202020207D0A2020202020202020202020206966';
wwv_flow_imp.g_varchar2_table(99) := '2028704F7074732E73616E6974697A6529207B0A20202020202020202020202020202020737472203D2073616E6974697A65434C4F42287374722C20704F707473293B0A2020202020202020202020207D0A0A2020202020202020202020207570646174';
wwv_flow_imp.g_varchar2_table(100) := '655570496D61676553726328704F7074732C20737472293B0A2020202020202020202020202F2F206465626F756E6365206973206E656564656420746F2070726576656E74206D756C7469706C65206576656E7473206578656375746564207768656E20';
wwv_flow_imp.g_varchar2_table(101) := '6D756C7469706C652066696C6573206172652064726F7070656420696E746F2074686520656469746F720A202020202020202020202020704F7074732E727465496E7374616E63652E6F6E28226368616E6765222C20617065782E7574696C2E6465626F';
wwv_flow_imp.g_varchar2_table(102) := '756E63652866756E6374696F6E2028652C206461746129207B0A2020202020202020202020202020202075706C6F616446696C657328704F707473293B0A2020202020202020202020207D2C20353029293B0A2020202020202020202020207574696C2E';
wwv_flow_imp.g_varchar2_table(103) := '6C6F616465722E73746F7028704F7074732E727465436F6E7461696E657253656C293B0A202020202020202020202020617065782E6576656E742E7472696767657228704F7074732E72746553656C2C2022636C6F626C6F616466696E69736865642229';
wwv_flow_imp.g_varchar2_table(104) := '3B0A202020202020202020202020617065782E64612E726573756D652870546869732E726573756D6543616C6C6261636B2C2066616C7365293B0A20202020202020207D20636174636820286529207B0A202020202020202020202020617065782E6465';
wwv_flow_imp.g_varchar2_table(105) := '6275672E6572726F72287B0A2020202020202020202020202020202022666374223A2060247B7574696C2E6665617475726544657461696C732E6E616D657D202D207072696E74436C6F62602C0A20202020202020202020202020202020226D7367223A';
wwv_flow_imp.g_varchar2_table(106) := '20224572726F72207768696C652072656E64657220434C4F42222C0A2020202020202020202020202020202022657272223A20652C0A20202020202020202020202020202020226665617475726544657461696C73223A207574696C2E66656174757265';
wwv_flow_imp.g_varchar2_table(107) := '44657461696C730A2020202020202020202020207D293B0A202020202020202020202020617065782E6576656E742E7472696767657228704F7074732E72746553656C2C2022636C6F626C6F61646572726F7222293B0A20202020202020202020202061';
wwv_flow_imp.g_varchar2_table(108) := '7065782E64612E726573756D652870546869732E726573756D6543616C6C6261636B2C2074727565293B0A20202020202020207D0A202020207D0A0A202020202F2F205573656420746F2075706C6F61642074686520636C6F622076616C75652066726F';
wwv_flow_imp.g_varchar2_table(109) := '6D20616E206974656D20746F2064617461626173650A2020202066756E6374696F6E2075706C6F6164436C6F622870546869732C20704F70747329207B0A20202020202020206C657420636C6F62203D20636C65616E5570496D61676553726328704F70';
wwv_flow_imp.g_varchar2_table(110) := '74732E727465496E7374616E6365292C0A20202020202020202020202072656D61696E696E67496D61676573203D206765745374696C6C4578697374696E67496D6167657328704F707473293B0A0A202020202020202069662028704F7074732E73616E';
wwv_flow_imp.g_varchar2_table(111) := '6974697A6529207B0A202020202020202020202020636C6F62203D2073616E6974697A65434C4F4228636C6F622C20704F707473293B0A20202020202020207D0A0A2020202020202020617065782E7365727665722E706C7567696E28704F7074732E61';
wwv_flow_imp.g_varchar2_table(112) := '6A617849442C207B0A2020202020202020202020207830313A202255504C4F41445F434C4F42222C0A202020202020202020202020705F636C6F625F30313A20636C6F622C0A202020202020202020202020706167654974656D733A20704F7074732E69';
wwv_flow_imp.g_varchar2_table(113) := '74656D73325375626D69740A20202020202020207D2C207B0A20202020202020202020202064617461547970653A202274657874222C0A202020202020202020202020737563636573733A2066756E6374696F6E202829207B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(114) := '2020202020207574696C2E6C6F616465722E73746F7028704F7074732E727465436F6E7461696E657253656C293B0A20202020202020202020202020202020617065782E6576656E742E7472696767657228704F7074732E72746553656C2C2022636C6F';
wwv_flow_imp.g_varchar2_table(115) := '627361766566696E6973686564222C2072656D61696E696E67496D616765732E6A6F696E28223A2229293B0A20202020202020202020202020202020617065782E64612E726573756D652870546869732E726573756D6543616C6C6261636B2C2066616C';
wwv_flow_imp.g_varchar2_table(116) := '7365293B0A2020202020202020202020207D2C0A2020202020202020202020206572726F723A2066756E6374696F6E20286A715848522C20746578745374617475732C206572726F725468726F776E29207B0A2020202020202020202020202020202075';
wwv_flow_imp.g_varchar2_table(117) := '74696C2E6C6F616465722E73746F7028704F7074732E727465436F6E7461696E657253656C293B0A20202020202020202020202020202020617065782E64656275672E6572726F72287B0A20202020202020202020202020202020202020202266637422';
wwv_flow_imp.g_varchar2_table(118) := '3A207574696C2E6665617475726544657461696C732E6E616D65202B2022202D2022202B202275706C6F6164436C6F62222C0A2020202020202020202020202020202020202020226D7367223A2022436C6F622055706C6F6164206572726F72222C0A20';
wwv_flow_imp.g_varchar2_table(119) := '20202020202020202020202020202020202020226A71584852223A206A715848522C0A20202020202020202020202020202020202020202274657874537461747573223A20746578745374617475732C0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(120) := '20226572726F725468726F776E223A206572726F725468726F776E2C0A2020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(121) := '2020207D293B0A20202020202020202020202020202020617065782E6576656E742E7472696767657228704F7074732E72746553656C2C2022636C6F62736176656572726F72222C2072656D61696E696E67496D616765732E6A6F696E28223A2229293B';
wwv_flow_imp.g_varchar2_table(122) := '0A20202020202020202020202020202020617065782E64612E726573756D652870546869732E726573756D6543616C6C6261636B2C2074727565293B0A2020202020202020202020207D0A20202020202020207D293B0A202020207D0A0A202020206675';
wwv_flow_imp.g_varchar2_table(123) := '6E6374696F6E2073686F77496E7374616E63654572726F7228704F70747329207B0A2020202020202020617065782E6D6573736167652E73686F774572726F7273285B7B0A202020202020202020202020747970653A20226572726F72222C0A20202020';
wwv_flow_imp.g_varchar2_table(124) := '20202020202020206C6F636174696F6E3A205B2270616765222C2022696E6C696E65225D2C0A202020202020202020202020706167654974656D3A20704F7074732E72746549642C0A2020202020202020202020206D6573736167653A2060247B757469';
wwv_flow_imp.g_varchar2_table(125) := '6C2E6665617475726544657461696C732E6E616D657D20737570706F727473206F6E6C792054696E63794D43452062617365642052696368205465787420456469746F72207769746820466F726D61742073657420746F202248544D4C2221602C0A2020';
wwv_flow_imp.g_varchar2_table(126) := '20202020202020202020756E736166653A2066616C73650A20202020202020207D5D293B0A202020207D0A0A202020202F2F20696E69740A2020202072657475726E207B0A2020202020202020696E697469616C697A653A2066756E6374696F6E202870';
wwv_flow_imp.g_varchar2_table(127) := '546869732C20704F70747329207B0A202020202020202020202020617065782E64656275672E696E666F287B0A2020202020202020202020202020202022666374223A2060247B7574696C2E6665617475726544657461696C732E6E616D657D202D2069';
wwv_flow_imp.g_varchar2_table(128) := '6E697469616C697A65602C0A2020202020202020202020202020202022617267756D656E7473223A207B0A2020202020202020202020202020202020202020227054686973223A2070546869732C0A202020202020202020202020202020202020202022';
wwv_flow_imp.g_varchar2_table(129) := '704F707473223A20704F7074730A202020202020202020202020202020207D2C0A20202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A2020202020202020202020207D';
wwv_flow_imp.g_varchar2_table(130) := '293B0A0A2020202020202020202020206C6574206F707473203D20704F7074732C0A2020202020202020202020202020202064656661756C7453616E6974697A654F7074696F6E73203D207B0A202020202020202020202020202020202020202022414C';
wwv_flow_imp.g_varchar2_table(131) := '4C4F5745445F41545452223A205B226163636573736B6579222C2022616C69676E222C2022616C74222C2022616C77617973222C20226175746F636F6D706C657465222C20226175746F706C6179222C2022626F72646572222C202263656C6C70616464';
wwv_flow_imp.g_varchar2_table(132) := '696E67222C202263656C6C73706163696E67222C202263686172736574222C2022636C617373222C2022636F6C7370616E222C2022646972222C2022686569676874222C202268726566222C20226964222C20226C616E67222C20226E616D65222C2022';
wwv_flow_imp.g_varchar2_table(133) := '72656C222C20227265717569726564222C2022726F777370616E222C2022737263222C20227374796C65222C202273756D6D617279222C2022746162696E646578222C2022746172676574222C20227469746C65222C202274797065222C202276616C75';
wwv_flow_imp.g_varchar2_table(134) := '65222C20227769647468225D2C0A202020202020202020202020202020202020202022414C4C4F5745445F54414753223A205B2261222C202261646472657373222C202262222C2022626C6F636B71756F7465222C20226272222C202263617074696F6E';
wwv_flow_imp.g_varchar2_table(135) := '222C2022636F6465222C20226464222C2022646976222C2022646C222C20226474222C2022656D222C202266696763617074696F6E222C2022666967757265222C20226831222C20226832222C20226833222C20226834222C20226835222C2022683622';
wwv_flow_imp.g_varchar2_table(136) := '2C20226872222C202269222C2022696D67222C20226C6162656C222C20226C69222C20226E6C222C20226F6C222C202270222C2022707265222C202273222C20227370616E222C2022737472696B65222C20227374726F6E67222C2022737562222C2022';
wwv_flow_imp.g_varchar2_table(137) := '737570222C20227461626C65222C202274626F6479222C20227464222C20227468222C20227468656164222C20227472222C202275222C2022756C225D0A202020202020202020202020202020207D3B0A0A2020202020202020202020202F2F206D6572';
wwv_flow_imp.g_varchar2_table(138) := '6765207573657220646566696E65642073616E6974697A65206F7074696F6E730A2020202020202020202020206F7074732E73616E6974697A654F7074696F6E73203D207574696C2E6A736F6E53617665457874656E642864656661756C7453616E6974';
wwv_flow_imp.g_varchar2_table(139) := '697A654F7074696F6E732C20704F7074732E73616E6974697A654F7074696F6E73293B0A0A2020202020202020202020206966202870546869732E6166666563746564456C656D656E74735B305D29207B0A202020202020202020202020202020206F70';
wwv_flow_imp.g_varchar2_table(140) := '74732E72746524203D20242870546869732E6166666563746564456C656D656E74735B305D293B0A202020202020202020202020202020206F7074732E7274654964203D206F7074732E727465242E617474722822696422293B0A202020202020202020';
wwv_flow_imp.g_varchar2_table(141) := '202020202020206F7074732E7274654974656D203D20617065782E6974656D286F7074732E7274654964293B0A202020202020202020202020202020206F7074732E72746553656C203D206023247B6F7074732E72746549647D603B0A20202020202020';
wwv_flow_imp.g_varchar2_table(142) := '2020202020202020206F7074732E727465436F6E7461696E657253656C203D2060247B6F7074732E72746553656C7D5F434F4E5441494E4552603B0A0A0A20202020202020202020202020202020696620286F7074732E7274654974656D202626207479';
wwv_flow_imp.g_varchar2_table(143) := '70656F66206F7074732E7274654974656D2E676574456469746F72203D3D3D202266756E6374696F6E2229207B0A2020202020202020202020202020202020202020704F7074732E727465496E7374616E6365203D206F7074732E7274654974656D2E67';
wwv_flow_imp.g_varchar2_table(144) := '6574456469746F7228293B0A202020202020202020202020202020207D20656C7365207B0A202020202020202020202020202020202020202073686F77496E7374616E63654572726F72286F707473293B0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(145) := '2020617065782E64612E726573756D652870546869732E726573756D6543616C6C6261636B2C2074727565293B0A202020202020202020202020202020202020202072657475726E2066616C73653B0A202020202020202020202020202020207D0A0A20';
wwv_flow_imp.g_varchar2_table(146) := '2020202020202020202020202020206966202821704F7074732E727465496E7374616E6365207C7C20704F7074732E727465242E6174747228226D6F6465222920213D3D202268746D6C2229207B0A202020202020202020202020202020202020202073';
wwv_flow_imp.g_varchar2_table(147) := '686F77496E7374616E63654572726F72286F707473293B0A2020202020202020202020202020202020202020617065782E64612E726573756D652870546869732E726573756D6543616C6C6261636B2C2074727565293B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(148) := '202020202020202072657475726E2066616C73653B0A202020202020202020202020202020207D0A202020202020202020202020202020202F2F2073686F77206C6F61646572207768656E207365740A2020202020202020202020202020202069662028';
wwv_flow_imp.g_varchar2_table(149) := '6F7074732E73686F774C6F6164657229207B0A20202020202020202020202020202020202020207574696C2E6C6F616465722E7374617274286F7074732E727465436F6E7461696E657253656C293B0A202020202020202020202020202020207D0A2020';
wwv_flow_imp.g_varchar2_table(150) := '20202020202020202020202020202F2F20646F776E6C6F616420636C6F620A20202020202020202020202020202020696620286F7074732E66756E6374696F6E54797065203D3D3D202252454E4445522229207B0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(151) := '2020202020617065782E7365727665722E706C7567696E280A2020202020202020202020202020202020202020202020206F7074732E616A617849442C207B0A2020202020202020202020202020202020202020202020207830313A20225052494E545F';
wwv_flow_imp.g_varchar2_table(152) := '434C4F42222C0A202020202020202020202020202020202020202020202020706167654974656D733A206F7074732E6974656D73325375626D69740A20202020202020202020202020202020202020207D2C207B0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(153) := '202020202020202020737563636573733A2066756E6374696F6E2028704461746129207B0A202020202020202020202020202020202020202020202020202020207072696E74436C6F622870546869732C2070446174612C206F707473293B0A20202020';
wwv_flow_imp.g_varchar2_table(154) := '20202020202020202020202020202020202020207D2C0A2020202020202020202020202020202020202020202020206572726F723A2066756E6374696F6E20286429207B0A20202020202020202020202020202020202020202020202020202020617065';
wwv_flow_imp.g_varchar2_table(155) := '782E64656275672E6572726F72287B0A202020202020202020202020202020202020202020202020202020202020202022666374223A2060247B7574696C2E6665617475726544657461696C732E6E616D657D202D20696E697469616C697A65602C0A20';
wwv_flow_imp.g_varchar2_table(156) := '20202020202020202020202020202020202020202020202020202020202020226D7367223A2022414A41582064617461206572726F72222C0A202020202020202020202020202020202020202020202020202020202020202022726573706F6E7365223A';
wwv_flow_imp.g_varchar2_table(157) := '20642C0A2020202020202020202020202020202020202020202020202020202020202020226665617475726544657461696C73223A207574696C2E6665617475726544657461696C730A2020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(158) := '20207D293B0A2020202020202020202020202020202020202020202020207D2C0A20202020202020202020202020202020202020202020202064617461547970653A20226A736F6E220A20202020202020202020202020202020202020207D293B0A2020';
wwv_flow_imp.g_varchar2_table(159) := '20202020202020202020202020207D20656C7365207B0A202020202020202020202020202020202020202075706C6F6164436C6F622870546869732C206F707473293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A';
wwv_flow_imp.g_varchar2_table(160) := '20202020202020207D0A202020207D3B0A7D3B0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(165269429043273478603)
,p_plugin_id=>wwv_flow_imp.id(165236396986724815191)
,p_file_name=>'script.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
