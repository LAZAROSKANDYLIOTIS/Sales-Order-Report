*&---------------------------------------------------------------------*
*& Include          ZDATA_SALES_REPORT_L
*&---------------------------------------------------------------------*

DATA : lv_erdat TYPE erdat.
DATA : lv_ernam TYPE ernam.

DATA : lt_final TYPE ztt_sordoutput_l.
DATA : lwa_final TYPE zstr_sordoutput_l.

DATA : lo_salesord TYPE REF TO zcl_salesord_l.

DATA : lt_fieldcat TYPE slis_t_fieldcat_alv.
DATA : lwa_fieldcat TYPE slis_fieldcat_alv.

data : lwa_grid_settings type lvc_s_glay.
