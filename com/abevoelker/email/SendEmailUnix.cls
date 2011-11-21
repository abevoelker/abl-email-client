
 /*------------------------------------------------------------------------
    File        : SendEmailUnix
    Purpose     :
    Description : Sends an Email using the Unix 'mail' utility.
    Author(s)   : Abe Voelker
    Created     : Sat Jul 17 17:14:27 CDT 2010
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

CLASS email.SendEmailUnix IMPLEMENTS EmailClient.SendEmailAlgorithm USE-WIDGET-POOL:


    DEFINE PRIVATE VARIABLE cTempFile AS CHARACTER NO-UNDO. /* Temporary file that holds message payload */

    CONSTRUCTOR PUBLIC SendEmailUnix ():
        SUPER ().
        /* Generate a temporary file name */
        INPUT THROUGH mktemp NO-ECHO.
          IMPORT UNFORMATTED cTempFile.
        INPUT CLOSE.
        UNIX SILENT VALUE("touch " + cTempFile).
    END CONSTRUCTOR.

    CONSTRUCTOR PUBLIC SendEmailUnix (INPUT ipcTempFile AS CHARACTER):
        SUPER ().
        /* Use an input temporary file */
        ASSIGN cTempFile = ipcTempFile.
    END CONSTRUCTOR.


    DESTRUCTOR PUBLIC SendEmailUnix ():
        OS-DELETE VALUE(cTempFile).
    END DESTRUCTOR.

    METHOD PUBLIC CHARACTER sendEmail(INPUT ipobjEmail AS email.Email):
        IF OPSYS NE "UNIX" THEN
            RETURN "You cannot use the Unix send email algorithm on " + OPSYS + " operating systems!".
        COPY-LOB FROM OBJECT ipobjEmail:getPayload() TO FILE cTempFile.
        UNIX SILENT VALUE("echo ~"" + SanitizeInput(ipobjEmail:getHeaders()) + "\n`cat " + cTempFile +
          "`~" | mail " + SanitizeInput(ipobjEmail:getRecipients())).
    END METHOD.

    /* Function to clean non-escaped characters out of input (prevent injection attacks) */
    METHOD PUBLIC STATIC CHARACTER SanitizeInput (INPUT ipcDirtyInput AS CHARACTER):
        ASSIGN ipcDirtyInput = REPLACE(ipcDirtyInput, CHR(92), CHR(92) + CHR(92)) /* '\' character */
               /*ipcDirtyInput = REPLACE(ipcDirtyInput, '~"', '~\' + '~"')          /* '"' character */*/
               ipcDirtyInput = REPLACE(ipcDirtyInput, ";", "~\;")
               ipcDirtyInput = REPLACE(ipcDirtyInput, "#", "~\#")
               ipcDirtyInput = REPLACE(ipcDirtyInput, "&", "~\&")
               ipcDirtyInput = REPLACE(ipcDirtyInput, "*", "~\*")
               ipcDirtyInput = REPLACE(ipcDirtyInput, "(", "~\(")
               ipcDirtyInput = REPLACE(ipcDirtyInput, ")", "~\)")
               ipcDirtyInput = REPLACE(ipcDirtyInput, "|", "~\|")
               ipcDirtyInput = REPLACE(ipcDirtyInput, "<", "~\<")
               ipcDirtyInput = REPLACE(ipcDirtyInput, ">", "~\>")
               ipcDirtyInput = REPLACE(ipcDirtyInput, "`", "~\`")
               ipcDirtyInput = REPLACE(ipcDirtyInput, "~~", "~\~~").
        RETURN ipcDirtyInput.
    END METHOD.

END CLASS.
