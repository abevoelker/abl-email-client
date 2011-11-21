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
I had started to work on an actual socket-level SMTP client implementation,
but didn't get a chance to finish it (the relevant in-progress files are
`SendEmailSocket.cls` and `SocketReader.p`).  I had also considered writing
a Windows-specific algorithm, possibly wrapping the command-line `bmail`
utility, but didn't get around to that, either.

## Example
Here's some example code for using the Unix algorithm, which I believe was
tested on an HP-UX system.  YMMV depending on system configuration, etc.:

    USING com.abevoelker.email.*.

    DEF VAR objEmail        AS Email              NO-UNDO.
    DEF VAR objSendEmailAlg AS SendEmailAlgorithm NO-UNDO.

    objSendEmailAlg = NEW SendEmailUnix().
    objEmail        = NEW Email(objSendEmailAlg).

    objEmail:addToRecipient("some_email@address.com").
    objEmail:setBodyText("This is the body.").
    objEmail:setSubject("This is the subject.").

    objEmail:send().

The socket algorithm example would look the same as above, except replacing
the algorithm to use `SendEmailSocket`, passing in an SMTP server address:

    objSendEmailAlg = NEW SendEmailSocket("some.smtpserver.com").

The ability to switch out different algorithms in this manner is one of the
original <abbr title="Gang of Four">GoF</abbr> design patterns called the
[strategy pattern](http://en.wikipedia.org/wiki/Strategy_pattern).
