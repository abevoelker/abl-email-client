
 /*------------------------------------------------------------------------
    File        : SendEmailSocket
    Purpose     :
    Description : Sends an Email using a socket.
    Author(s)   : Abe Voelker
    Created     : Sat Jul 17 17:14:42 CDT 2010
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

CLASS email.SendEmailSocket IMPLEMENTS EmailClient.SendEmailAlgorithm USE-WIDGET-POOL:


        /*------------------------------------------------------------------------------
                        Purpose:
                        Notes:
        ------------------------------------------------------------------------------*/

    &SCOPED-DEFINE SOCKET_HANDLER_LOCATION email/SocketReader.p

    DEFINE PRIVATE VARIABLE cMailServerAddress    AS CHARACTER NO-UNDO.
    DEFINE PRIVATE VARIABLE iMailServerPort       AS INTEGER   NO-UNDO.
    DEFINE PRIVATE VARIABLE hSocket               AS HANDLE    NO-UNDO.
    DEFINE PRIVATE VARIABLE hSocketHandlerProcess AS HANDLE    NO-UNDO.

        CONSTRUCTOR PUBLIC SendEmailSocket (INPUT ipcMailServerAddress AS CHARACTER):
                SUPER ().
                ASSIGN cMailServerAddress = ipcMailServerAddress
                       iMailServerPort    = 25. /* Default for SMTP */
        END CONSTRUCTOR.

        CONSTRUCTOR PUBLIC SendEmailSocket (INPUT ipcMailServerAddress AS CHARACTER,
                                            INPUT ipiMailServerPort    AS INTEGER):
                SUPER ().
                ASSIGN cMailServerAddress = ipcMailServerAddress
                       iMailServerPort    = ipiMailServerPort.
        END CONSTRUCTOR.

    /* Workaround for Progress being dumb as fuck */
    METHOD PUBLIC VOID waitForSocket():
        ASSIGN hSocket:SENSITIVE = TRUE. /* Needed incase ReadSocketResponse procedure is still open on the procedure stack */
        WAIT-FOR READ-RESPONSE OF hSocket.
        /*PAUSE 5 NO-MESSAGE.*/
    END METHOD.

    /* @TODO */
    METHOD PUBLIC CHARACTER sendEmail(INPUT ipobjEmail AS email.Email):
        CREATE WIDGET-POOL.

        /* Start socket handler procedure persistently */
        RUN {&SOCKET_HANDLER_LOCATION} PERSISTENT SET hSocketHandlerProcess
          (THIS-OBJECT) NO-ERROR.

        CREATE SOCKET hSocket.

        hSocket:SET-SOCKET-OPTION ("TCP-NODELAY", "FALSE").
        hSocket:SET-SOCKET-OPTION ("SO-LINGER",   "FALSE").

        hSocket:SET-READ-RESPONSE-PROCEDURE("ReadSocketResponse", hSocketHandlerProcess).

        hSocket:CONNECT("-H " + cMailServerAddress + " -S " + STRING(iMailServerPort)) NO-ERROR.
        IF NOT hSocket:CONNECTED() THEN
            RETURN "Unable to connect to " + cMailServerAddress + ":" + STRING(iMailServerPort) + "!".

        /*
        DEFINE VARIABLE mptrRawFrame AS MEMPTR  NO-UNDO.
        DEFINE VARIABLE iFrameSize   AS INTEGER NO-UNDO.

        ASSIGN iFrameSize = LENGTH("EHLO mmprog23", "RAW").
        SET-SIZE(mptrRawFrame) = iFrameSize + 1. /* MALLOC (Extra byte for NULL-term string) */
        PUT-STRING(mptrRawFrame, 1) = ipobjFrame:toLongChar().
        hSocket:WRITE(mptrRawFrame, 1, iFrameSize + 1).

        SET-SIZE(mptrRawFrame) = 0. /* FREE */
        */

        waitForSocket().

        /* Cleanup */
        FINALLY:
            IF VALID-HANDLE(hSocket) THEN DO:
                IF hSocket:CONNECTED() THEN
                    hSocket:DISCONNECT().
                DELETE OBJECT hSocket.
            END.
            DELETE WIDGET-POOL.
        END.
        END METHOD.

        /* Handle responses from the SMTP server */
        METHOD PUBLIC CHARACTER handleResponse(INPUT iplcMessage AS LONGCHAR):
            MESSAGE "GOT HERE 1" VIEW-AS ALERT-BOX.
            COPY-LOB FROM OBJECT iplcMessage TO FILE "C:\responses.txt" APPEND.
        END METHOD.

        /* Write any errors */
        METHOD PUBLIC CHARACTER handleError(INPUT ipcMessage AS CHARACTER):
            MESSAGE "GOT HERE 2" VIEW-AS ALERT-BOX.
            OUTPUT TO VALUE("C:\errors.txt").
            OUTPUT CLOSE.
        END METHOD.

END CLASS.
