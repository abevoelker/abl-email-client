# Progress / OpenEdge ABL Email Client

## Summary
This is some old code that I found in my attic.  It's a simple email/SMTP
client for sending emails from Progress / OpenEdge ABL code.  I believe
I loosely took inspiration from the well-known `smtpmail.p` program,
albeit without the rat's nest of procedural code.

## Validity
I can't guarantee this works as I no longer have an ABL development
environment to test it with.  I'm fairly certain that the Unix
algorithm works, at least (assuming you have the `mail` command available).
I had started to work on a actual socket-level SMTP client
implementation, but didn't get a chance to finish it.  I had also considered
writing a Windows-specific algorithm possibly wrapping the command-line
`bmail` utility, but also didn't get around to that.

## Example
Here's some example code for using the Unix algorithm, which I believe was
tested on an HP-UX system.  YMMV depending on system configuration, etc.:

    USING com.abevoelker.email.*.

    DEFINE VARIABLE objEmail        AS Email              NO-UNDO.
    DEFINE VARIABLE objSendEmailAlg AS SendEmailAlgorithm NO-UNDO.

    ASSIGN objSendEmailAlg = NEW SendEmailUnix()
           objEmail        = NEW Email(objSendEmailAlg).

    objEmail:addToRecipient("some_email@address.com").
    objEmail:setBodyText("This is the body.").
    objEmail:setSubject("This is the subject.").

    objEmail:send().

