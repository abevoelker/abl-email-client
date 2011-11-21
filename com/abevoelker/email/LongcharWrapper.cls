
 /*------------------------------------------------------------------------
    File        : Longchar
    Purpose     : Wraps a LONGCHAR variable in an Object
    Description : Used in situations where you need to store a LONGCHAR but
                  Progress can't seem to handle it (e.g. in a temp-table)
    Author(s)   : Abe Voelker
    Created     : Sat Jul 24 17:16:04 CDT 2010
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

CLASS email.LongcharWrapper USE-WIDGET-POOL:

    DEFINE PRIVATE VARIABLE lc AS LONGCHAR NO-UNDO.

    CONSTRUCTOR PUBLIC LongcharWrapper():
        SUPER ().
    END CONSTRUCTOR.

    CONSTRUCTOR PUBLIC LongcharWrapper(INPUT iplc AS LONGCHAR):
        SUPER ().
        ASSIGN lc = iplc.
    END CONSTRUCTOR.

    METHOD PUBLIC LONGCHAR getLongchar():
        RETURN lc.
    END METHOD.

    METHOD PUBLIC VOID setLongchar(INPUT iplc AS LONGCHAR):
        ASSIGN lc = iplc.
    END METHOD.

END CLASS.
