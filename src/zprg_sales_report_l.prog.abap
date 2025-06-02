*&---------------------------------------------------------------------*
*& Report ZPRG_SALES_REPORT_L
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_sales_report_l.

INCLUDE zdata_sales_report_l.

INCLUDE zsel_sales_report_l.


*CALL FUNCTION 'ZFM_SALESORD_L'
*  EXPORTING
*    serdat      = s_erdat[]
*    sernam      = s_ernam[]
*  IMPORTING
*    lt_output   = lt_final
*  EXCEPTIONS
*    wrong_input = 1
*    OTHERS      = 2.
*IF sy-subrc <> 0.
** Implement suitable error handling here
*  MESSAGE i000(zmsg_salesord_l).
*ENDIF.


CREATE OBJECT lo_salesord.


CALL METHOD lo_salesord->get_sales_orders
  EXPORTING
    serdat      = s_erdat[]
    sernam      = s_ernam[]
  IMPORTING
    lt_output   = lt_final
  EXCEPTIONS
    wrong_input = 1
    OTHERS      = 2.
IF sy-subrc <> 0.
  MESSAGE i000(zmsg_salesord_l).
ELSE.
  PERFORM prepare_fieldcat USING '1' 'SELECT' TEXT-012 'X' 'X' CHANGING lt_fieldcat.
  PERFORM prepare_fieldcat USING '2' 'VBELN' TEXT-001 ' ' ' ' CHANGING lt_fieldcat.
  PERFORM prepare_fieldcat USING '3' 'POSNR' TEXT-002 ' ' ' ' CHANGING lt_fieldcat.
  PERFORM prepare_fieldcat USING '4' 'MATNR' TEXT-003 ' ' ' ' CHANGING lt_fieldcat.
  PERFORM prepare_fieldcat USING '5' 'MAKTX' TEXT-004 ' ' ' ' CHANGING lt_fieldcat.
  PERFORM prepare_fieldcat USING '6' 'KWMENG' TEXT-005 ' ' ' ' CHANGING lt_fieldcat.
  PERFORM prepare_fieldcat USING '7' 'VRKME' TEXT-006 ' ' ' ' CHANGING lt_fieldcat.

  lwa_grid_settings-edt_cll_cb = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'PF_STATUS'
      i_callback_user_command  = 'USER_COMMAND'
      i_callback_top_of_page   = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
      i_grid_settings          = lwa_grid_settings
*     IS_LAYOUT                =
      it_fieldcat              = lt_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS        =
*     IT_SORT                  =
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
*     I_SAVE                   = ' '
*     IS_VARIANT               =
*     IT_EVENTS                =
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER  =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = lt_final
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



ENDIF.

FORM pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'SALESORD_L'.

ENDFORM.

FORM user_command USING r_ucomm LIKE sy-ucomm
                                  rs_selfield TYPE slis_selfield.

  DATA : lt_selected_final TYPE ztt_sordoutput_l.

  READ TABLE lt_final INTO lwa_final WITH KEY select = 'X'.
  IF sy-subrc = 0.
    LOOP AT lt_final INTO lwa_final.
      IF lwa_final-select = 'X'.
        APPEND lwa_final TO lt_selected_final.
        CLEAR : lwa_final.
      ENDIF.
    ENDLOOP.
  ELSE.
    lt_selected_final = lt_final.
  ENDIF.

  IF r_ucomm = 'SMARTFORMS'.
    DATA : lv_fmname TYPE rs38l_fnam.
    DATA : lwa_controlparam TYPE ssfctrlop.
    DATA : lwa_outputop TYPE ssfcompop.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZSF_SALESORD_L'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
        fm_name            = lv_fmname
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    lwa_controlparam-no_dialog = 'X'.
    lwa_controlparam-preview = 'X'.
    lwa_outputop-tddest = 'LP01'.

    CALL FUNCTION lv_fmname
      EXPORTING
*       ARCHIVE_INDEX      =
*       ARCHIVE_INDEX_TAB  =
*       ARCHIVE_PARAMETERS =
        control_parameters = lwa_controlparam
*       MAIL_APPL_OBJ      =
*       MAIL_RECIPIENT     =
*       MAIL_SENDER        =
        output_options     = lwa_outputop
        user_settings      = ' '
        perdat_low         = s_erdat-low
        perdat_high        = s_erdat-high
        pernam             = s_ernam-low
        lt_output          = lt_selected_final
*     IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO    =
*       JOB_OUTPUT_OPTIONS =
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


  ENDIF.

  IF r_ucomm = 'ADOBEFORMS'.
    DATA : lwa_outputparams TYPE sfpoutputparams.
    DATA : lv_funcname TYPE funcname.
    DATA : lwa_result TYPE sfpjoboutput.

    lwa_outputparams-nodialog = 'X'.
    lwa_outputparams-preview = 'X'.
    lwa_outputparams-dest = 'LP01'.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lwa_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = 'ZSFP_SALESORD_L'
      IMPORTING
        e_funcname = lv_funcname
*       E_INTERFACE_TYPE           =
*       EV_FUNCNAME_INBOUND        =
      .

    CALL FUNCTION lv_funcname
      EXPORTING
*       /1BCDWB/DOCPARAMS        =
        perdat_low     = s_erdat-low
        perdat_high    = s_erdat-high
        pernam         = s_ernam-low
        lt_output      = lt_selected_final
*     IMPORTING
*       /1BCDWB/FORMOUTPUT       =
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'FP_JOB_CLOSE'
      IMPORTING
        e_result       = lwa_result
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


  ENDIF.

ENDFORM.

FORM top_of_page .
  DATA : lt_list TYPE slis_t_listheader.
  DATA : lwa_list TYPE slis_listheader.
  DATA : lv_date(30) TYPE c.
  DATA : lv_low(10) TYPE c.
  DATA : lv_high(10) TYPE c.

  lwa_list-typ = 'H'.
  lwa_list-info = TEXT-007.
  APPEND lwa_list TO lt_list.
  CLEAR : lwa_list.

  IF s_erdat-low IS NOT INITIAL AND s_erdat-high IS INITIAL.
    CONCATENATE s_erdat-low+6(2) '.' s_erdat-low+4(2) '.' s_erdat-low+0(4) INTO lv_low.
    lwa_list-typ = 'S'.
    lwa_list-key = TEXT-008.
    lwa_list-info = lv_low.
    APPEND lwa_list TO lt_list.
    CLEAR : lwa_list.
  ENDIF.

  IF s_erdat-low IS NOT INITIAL AND s_erdat-high IS NOT INITIAL.
    CONCATENATE s_erdat-low+6(2) s_erdat-low+4(2) s_erdat-low+0(4) INTO lv_low SEPARATED BY '.'.
    CONCATENATE s_erdat-high+6(2) s_erdat-high+4(2) s_erdat-high+0(4) INTO lv_high SEPARATED BY '.'.

    CONCATENATE lv_low TEXT-009 lv_high INTO lv_date SEPARATED BY space.
    lwa_list-typ = 'S'.
    lwa_list-key = TEXT-008.
    lwa_list-info = lv_date.
    APPEND lwa_list TO lt_list.
    CLEAR : lwa_list.
  ENDIF.

  IF s_ernam-low IS NOT INITIAL.
    lwa_list-typ = 'S'.
    lwa_list-key = TEXT-010.
    lwa_list-info = s_ernam-low.
    APPEND lwa_list TO lt_list.
    CLEAR : lwa_list.
  ENDIF.

  lwa_list-typ = 'A'.
  lwa_list-info = TEXT-011.
  APPEND lwa_list TO lt_list.
  CLEAR : lwa_list.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_list
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .


ENDFORM.


INCLUDE zsales_report_l_prepare_fif01.
