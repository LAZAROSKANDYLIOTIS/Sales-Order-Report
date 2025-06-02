FUNCTION zfm_salesord_l.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(SERDAT) TYPE  ZTT_ERDAT_L
*"     REFERENCE(SERNAM) TYPE  ZTT_ERNAM_L
*"  EXPORTING
*"     REFERENCE(LT_OUTPUT) TYPE  ZTT_SORDOUTPUT_L
*"  EXCEPTIONS
*"      WRONG_INPUT
*"----------------------------------------------------------------------

  TYPES : BEGIN OF lty_vbak,
            vbeln TYPE vbeln_va,
          END OF lty_vbak.

  DATA : lt_vbak TYPE TABLE OF lty_vbak.
  DATA : lwa_vbak TYPE lty_vbak.

  TYPES : BEGIN OF lty_vbap,
            vbeln  TYPE vbeln_va,
            posnr  TYPE posnr_va,
            matnr  TYPE matnr,
            kwmeng TYPE kwmeng,
            vrkme  TYPE vrkme,
          END OF lty_vbap.

  DATA : lt_vbap TYPE TABLE OF lty_vbap.
  DATA : lt_temp_vbap TYPE TABLE OF lty_vbap.
  DATA : lwa_vbap TYPE lty_vbap.

  TYPES : BEGIN OF lty_makt,
            matnr TYPE matnr,
            spras TYPE spras,
            maktx TYPE maktx,
          END OF lty_makt.

  DATA : lt_makt TYPE TABLE OF lty_makt.
  DATA : lwa_makt TYPE lty_makt.

  DATA : lwa_output TYPE zstr_sordoutput_l.

  DATA : lv_index TYPE i.

  SELECT vbeln
    FROM vbak
    INTO TABLE lt_vbak
    WHERE erdat IN serdat
    AND ernam IN sernam.

  IF lt_vbak IS NOT INITIAL.
    SELECT vbeln posnr matnr kwmeng vrkme
      FROM vbap
      INTO TABLE lt_vbap
      FOR ALL ENTRIES IN lt_vbak
      WHERE vbeln = lt_vbak-vbeln.
  ELSE.
    RAISE wrong_input.
  ENDIF.

  IF lt_vbap IS NOT INITIAL.
    lt_temp_vbap = lt_vbap.
    SORT lt_temp_vbap BY matnr.
    DELETE ADJACENT DUPLICATES FROM lt_temp_vbap COMPARING matnr.

    SELECT matnr spras maktx
      FROM makt
      INTO TABLE lt_makt
      FOR ALL ENTRIES IN lt_temp_vbap
      WHERE matnr = lt_temp_vbap-matnr
      AND spras = sy-langu.
  ENDIF.

  SORT lt_vbap BY vbeln.
  SORT lt_makt BY matnr.

  LOOP AT lt_vbak INTO lwa_vbak.
    READ TABLE lt_vbap INTO lwa_vbap WITH KEY vbeln = lwa_vbak-vbeln BINARY SEARCH.
    IF sy-subrc = 0.
      lv_index = sy-tabix.
    ENDIF.
    LOOP AT lt_vbap INTO lwa_vbap FROM lv_index.
      IF lwa_vbap-vbeln = lwa_vbak-vbeln.
        lwa_output-vbeln = lwa_vbak-vbeln.
        lwa_output-posnr = lwa_vbap-posnr.
        lwa_output-matnr = lwa_vbap-matnr.
        lwa_output-kwmeng = lwa_vbap-kwmeng.
        lwa_output-vrkme = lwa_vbap-vrkme.
        READ TABLE lt_makt INTO lwa_makt WITH KEY matnr = lwa_vbap-matnr BINARY SEARCH.
        IF sy-subrc = 0.
          lwa_output-maktx = lwa_makt-maktx.
        ENDIF.
        APPEND lwa_output TO lt_output.
        CLEAR : lwa_output.
      ELSE.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
ENDFUNCTION.
