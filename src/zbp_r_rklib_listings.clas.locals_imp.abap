CLASS LHC_ZR_RKLIB_LISTINGS DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:

      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrRklibListings
        RESULT result,
      ExcelUpload FOR MODIFY
            IMPORTING keys FOR ACTION ZrRklibListings~ExcelUpload.

ENDCLASS.

CLASS LHC_ZR_RKLIB_LISTINGS IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.


  METHOD ExcelUpload.
     TYPES : BEGIN OF ty_sheet_data,
              id                  TYPE  ZR_RKLIB_LISTINGS-id,
              title               TYPE ZR_RKLIB_LISTINGS-title,
              type                TYPE ZR_RKLIB_LISTINGS-Type,
              author              TYPE ZR_RKLIB_LISTINGS-author,
              PublisherStudio     TYPE ZR_RKLIB_LISTINGS-PublisherStudio,
              IsbnEan             TYPE ZR_RKLIB_LISTINGS-IsbnEan,
              LanguageCode        TYPE ZR_RKLIB_LISTINGS-LanguageCode,
              PublicationYear     TYPE ZR_RKLIB_LISTINGS-PublicationYear,
              description         TYPE ZR_RKLIB_LISTINGS-Description,
              Totalcopies         TYPE ZR_RKLIB_LISTINGS-Totalcopies,
              AvailableCopies     TYPE ZR_RKLIB_LISTINGS-AvailableCopies,
              LocationShelfID     TYPE ZR_RKLIB_LISTINGS-LocationShelfID,
              LendingDurationDays TYPE ZR_RKLIB_LISTINGS-LendingDurationDays,
              status              TYPE ZR_RKLIB_LISTINGS-Status,
            END OF ty_sheet_data.

    DATA lv_file_content   TYPE xstring.
    DATA lt_sheet_data     TYPE STANDARD TABLE OF ty_sheet_data.
    DATA lt_listing_create TYPE TABLE FOR CREATE ZR_RKLIB_LISTINGS.

    lv_file_content = VALUE #( keys[ 1 ]-%param-_streamproperties-StreamProperty OPTIONAL ).

    " Error handling in case file content is initial

    DATA(lo_document) = xco_cp_xlsx=>document->for_file_content( lv_file_content )->read_access( ).

    DATA(lo_worksheet) = lo_document->get_workbook( )->worksheet->at_position( 1 ).

    DATA(o_sel_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
      )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )  " Start reading from Column A
      )->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'N' )   " End reading at Column N
      )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 )    " *** Start reading from ROW 2 to skip the header ***
      )->get_pattern( ).

    lo_worksheet->select( o_sel_pattern
                                     )->row_stream(
                                     )->operation->write_to( REF #( lt_sheet_data )
                                     )->set_value_transformation(
                                         xco_cp_xlsx_read_access=>value_transformation->string_value
                                     )->execute( ).

    lt_listing_create = CORRESPONDING #( lt_sheet_data ).

    MODIFY ENTITIES OF ZR_RKLIB_LISTINGS IN LOCAL MODE
           ENTITY ZrRklibListings
           CREATE AUTO FILL CID FIELDS ( Id Title Type author PublisherStudio IsbnEan LanguageCode PublicationYear description Totalcopies AvailableCopies LocationShelfID LendingDurationDays status )
           WITH lt_listing_create
           " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED DATA(lt_mapped)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(lt_reported)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED DATA(lt_failed).

    " Communicate the messages to UI - not in scope of this demo
    IF lt_failed IS INITIAL.
      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                    text     = 'Listings have been uploaded - please refresh the list!!' ) )
             TO reported-zrrkliblistings.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
