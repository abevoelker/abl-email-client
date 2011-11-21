
 /*------------------------------------------------------------------------
    File        : Memptr
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : avoelker
    Created     : Sat Jul 24 13:43:51 CDT 2010
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.



CLASS EmailClient.Memptr USE-WIDGET-POOL:

    DEFINE PRIVATE VARIABLE mptr AS MEMPTR NO-UNDO.

    CONSTRUCTOR PUBLIC Memptr():
        SUPER ().
    END CONSTRUCTOR.

    CONSTRUCTOR PUBLIC Memptr(INPUT ipmptr AS MEMPTR):
        SUPER ().
        ASSIGN mptr = ipmptr.
    END CONSTRUCTOR.

    METHOD PUBLIC MEMPTR getMptr():
        RETURN mptr.
    END.

    METHOD PUBLIC VOID setMptr(INPUT ipmptr AS MEMPTR):
        ASSIGN mptr = ipmptr.
    END.

END CLASS.
