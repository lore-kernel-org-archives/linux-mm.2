Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2F1A606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.callmyapp.online header.i=@mail.callmyapp.online header.a=rsa-sha256 header.s=resend header.b=g8St0WFA;
	dkim=pass (1024-bit key, unprotected) header.d=amazonses.com header.i=@amazonses.com header.a=rsa-sha256 header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=wj+wwuun
Received: by kanga.kvack.org (Postfix)
	id D1DD36B05B1; Wed, 11 Nov 2026 17:10:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE576B05B2; Wed, 11 Nov 2026 17:10:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4E86B05B4; Wed, 11 Nov 2026 17:10:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 885576B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:10:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F085160416
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:10:40 +0000 (UTC)
X-FDA: 85424233440.20.12B0401
Received: from a3-29.smtp-out.eu-west-1.amazonses.com (a3-29.smtp-out.eu-west-1.amazonses.com [54.240.3.29])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B74DC0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:10:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=mail.callmyapp.online header.s=resend header.b=g8St0WFA;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=wj+wwuun;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of 010201a1cca9b5d9-6fdfe76e-dc60-4deb-a4a5-bc6cab823e71-000000@rsend.mail.callmyapp.online designates 54.240.3.29 as permitted sender) smtp.mailfrom=010201a1cca9b5d9-6fdfe76e-dc60-4deb-a4a5-bc6cab823e71-000000@rsend.mail.callmyapp.online
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794435038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3vh6YOt5tawjPS5h3EV1EySZC88/wL1f/U7a9PkaOaI=;
	b=dfKUFwOAYJoaiz8wJ4AwesrcZrbM/BcpAf/6m33dLeBNjKdpGkaekrWQNvrgAywP8p/VCl
	t7IdugqLReTkRk4Ft6k+W5WT+VZTHbvZWlAHrkO1utBhOhfeTDUlZJDRo+Qc2XRr6brf53
	PO0ktBMWURyLlgaDIpbv236LgeMTc/k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=mail.callmyapp.online header.s=resend header.b=g8St0WFA;
	dkim=pass header.d=amazonses.com header.s=shh3fegwg5fppqsuzphvschd53n6ihuv header.b=wj+wwuun;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of 010201a1cca9b5d9-6fdfe76e-dc60-4deb-a4a5-bc6cab823e71-000000@rsend.mail.callmyapp.online designates 54.240.3.29 as permitted sender) smtp.mailfrom=010201a1cca9b5d9-6fdfe76e-dc60-4deb-a4a5-bc6cab823e71-000000@rsend.mail.callmyapp.online
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794435038;
	b=kpfYK/jJ4ccCtcyHRJsTxgGZS6Eszn59NQMl6LiDJvjtEk4hlEkoFInPushJgDCcwFMm29
	EmSM6NU6E9Du22ATIijZOuOV3qlG1qtBDElRi/lEYzhoAJThy/enR3LzDVV6vf6GpwU4ih
	iUyIg97Soa8z2OEUsRR/ImmsRM1SIUc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mail.callmyapp.online; t=1794435036;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type;
	bh=1//QXsK3ZX/O+bwqjJWC/NMWjcPMr+C9vUhM2kBFjes=;
	b=g8St0WFAn3y3C3pxh3SoQib+jjHgw9yKiKA7zsKA1tbrMTJQ2mkRGX6CbROKyDvn
	oWSSqlEWWZ1eVZT8ntiyxp1nXCMRi3JW6EI78rOdyKB4IGmx7DGEzAfRfKozNsS9t5C
	DHOe8vZtASLEaHZOnzOVNenR/oJfWoZSPs801Woo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1794435036;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=1//QXsK3ZX/O+bwqjJWC/NMWjcPMr+C9vUhM2kBFjes=;
	b=wj+wwuunXZESTJwEeWVqKg1wH01WvEriBZP6bSsYAKH7B755wprKqqLKoHvSiwOn
	rR01xOnIheG7+IpdoeigO1gozY71VOkP61wCxWVhj9IpvF+7yqzpu2RqZ6CVPBEAPJr
	XUk3WcmX0y1piNTosJ1YihNHKBSwPLelh0y8HZj8=
From: Support <support@mail.callmyapp.online>
To: linux-mm@kvack.org
Subject: Northbridge  Workspace
Message-ID: <010201a1cca9b5d9-6fdfe76e-dc60-4deb-a4a5-bc6cab823e71-000000@eu-west-1.amazonses.com>
Date: Wed, 11 Nov 2026 22:10:36 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary="--_NmP-5294fa56ba55c26d-Part_1"
Feedback-ID: :1.eu-west-1.3pNgzRY+qZlMzbNieazgV3iQELpELcnXo/P3g0t6W6HeLpO9GC9yYZrY2J8gcpfkONSMNZkeM/L3vNGzehq/UacHStk0FEqdmbiTxuYU0RndWo6zBwAR6IEJitsEvwaSTPZz9li3qb0GvpX6BTyfQtLMO97luoqM3BjV0Gq7/gQ=:1.eu-west-1.mn4CV6NdxyxonKM+/Hjvd874GJxbRQyaS3Zo0NapPlc=:AmazonSES
X-SES-Outgoing: 2026.11.11-54.240.3.29
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5B74DC0007
X-Spam-Status: No, score=0.8 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FROM_SUSPICIOUS_NTLD,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: cdgos99aynuctfyft6ge9uyduz9koix8
X-HE-Tag: 1794435038-296126
X-HE-Meta: U2FsdGVkX1+xarTubdjuybbwkRBc+8RaRZT2TIARV6W9DYSqx/Mvk0Wf4hmdaDrv6h0z8G/nY7NPMBaQxnpFa/yQobOOZ42cZzsGzSPzjabZwqWbW1NiQu6mXw8gleq9kcz0KW8R+JKTrOWIZ+Akmn4mM0FgcUdpbpqXcsh1iJqo76Grt4k+l5x0ljwpV+Hm3pzotAuMfrf0EH728RA8Q7PjH926Yi3F5SrPJER/6pcb2cJt48uX/h1SAXlwGIJcfvsvSBhRZRd1Pudq/khwy3petcukxKlpdfmsXmkCdbJ0tkxPthvXV2ldvogbuuQt+xUQrEWtEGatcb+wFzkE9poc4rFNKeeRKh6l3jLBIcPZOny8Wkrlv+hIi+4nPV7rwW+N9lNkqOO8HGM0uB8WkpMhoza18/QRNJE7oKkU0QgfkRKdajPeE7B5tYV0I2D2yjw8y/ceZE9rtCoKSSOMB4mb48piM8VE8zG+bem7vJ8bAAOTQakzjX5I8zWZ5kmk7kZnv9WMk6O6uSa1QaEosRRXoHsDe9Vm1VoDKOeKdWrsT8AHXssfMyy7ESIPr5V8oeUryhcB+BXIwFDnjMgzq0CgpL13y//FaERQVYbPVliZUKLXF39Q7wxext6Xydrp1nRM7zI3e0dsQsKB9ENSxXgovNzzHq/iaCnlH8YtxLOxHE9bUmqi+Rk16P4FbS0W9KSoZks9PF85Z5qdrIKUPnUln3bh0891GxuradbpPEMTP/iGFo8LP4GNbsPCW27XadDZS8GXvDHV32Vf/j5Nu0UcEgEqU9gFtVRi7e3Iy8mFi9xxid/ZqM3uQYRk7hnST+nEjF+fN31ohzluQnwQWcZOozDdIPcKumI9U7D8AHJ7Bad4S/cZOliiq9Ei8R4WBXsgE3c9rZHriau8zu0oXImu2pPouUVOBO1MNbfbaQcoVlNfbofus5M6gNQLTBHL60EQyCuaPlx+7mL2R+l
 ova2BoQu
 9y+uZWq/dhm7YUAmZ8Od/G+to3VZpOtuf/C2ZJg/i+lB+TAZboP7r7Zw+rviqL+nm/KtXPXvPbwiwMPRGNVLNhqhu6wBgd3cT2iMpoU+Y56qOu4sncwj9BiU3MRlPo6ouQn12J3oQdcuD4VJFeCjZwm5N5+TvvTCBzNnjdgxeVgequnEDjnNsGLu/GYy8qbonrV+QGrJryykf8GA5vDIjmn92HFTlv/U4sDOPeuK4/CjT8CZ5eQqt+dtQZZ7i9rDM2bV8olUk0IZlbbiPDByvVB+vDNUBaLopzwiy46YtMw3vGlrSGnWlwxCvRv/RJJq6z1w3IVwcDC3yRpfqBn6GviWkEo1/3KrwC//6Fl3vp39kyPHNv3f/d2gxZjZRAU7G6dowi9qxYtFV++S3rJts4RKlqrKVOnvwofL6SXzgcousKiFsUPHXx07jyfmzltmSGXQqjmv/5ZHVJQSYGqSJzdZ3VrYeAP05U+HHaWyqxKqb3D8xgbL1+cKBiYpp3FFIOLb0PtW2UJsR9RlvQ+3Ej1hDvQpyywu2d3/8Ev8Gb5MvFdCxbb7fcJpC9r6z1/uxcxuuxPorWkqwRJFRWwYAHYb2tOLzXRTqbnn6YyP8BiENjODbMBSfqIih5zGUspbRdO5V03tGVefOeoc61BUgnumNdI3m8FeNyrgHYyLbKi/5YjF9NUOaAa4zay79yOXalnDwISCXWqm3Kb61lwnE/LcaLvBUrOFqHTALGqgF9OMsZQknQOZgN13vLjocojhTs3ahRgze0PsXLPNnLClSYHaLRE/YmZJ8xfry5KcTKr4pHsMFgY5wkxlFUlwqJHcg7TDaZX/gPchn2CRE6owZqcsbIgIj7FNH20EL0XwFQfGxz36CIts8NMOJlZ9pMArzGt+1nDpExAUBREcJKcP1sfT4/e3ts7M/C8BVul63fZ/fvE0WPJdGhOLemwdy2hrFLVq+RU2dtCFZGHElaulHxKYcFeBz
 UbSCbQem
 xr06A7VylrAGTSv4tSVzn/jJyDo4MKderjaT+F5h3t/ms1GRNa7q0Ie/xQ3UQnN3Gq+1g3/0I07/8jx/FPaSjmIn0NuESqV59ZXBJJvIOP3i8pzmu9EhmvV+WhjTOmwOBk3BVm40MwcGXNAJIv4vWG8WUPQKvWm9OQENxCn1obgPGFSCnFDgXfHjFYZ2vLzeCMgU9ILGR7oOMOTq74YhKd1RvrS34NcRpsMIaT/MP1GXUBJ9ZcFjqz0AoRUfQBSMU5VaNN/bwys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

----_NmP-5294fa56ba55c26d-Part_1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

=C2=A0

Northbridge =C2=A0Workspace Document sharing


A DOCUMENT HAS BEEN SHARED WITH YOU

Hello,

Michael Chen has shared a =
business document with you for review. Please see the details below.

Document Q3_Budget_Review_Sample.pdf Shared by Michael Chen Shared on =
October 12, 2026 Reference NB-REF-4821-03

View Sample Document

This is an automated notification. If you were not expecting this document,=
 please contact the sender directly or your IT support team to verify its =
authenticity before opening any links or attachments.

Thank you,
Northbridge Workspace
Document Collaboration Team

------------------------=
----------------

Northbridge Workspace Inc. =C2=B7 1234 Innovation Drive, =
Suite 800 =C2=B7 Austin, TX 78701

This email was sent to recipient@example=
.com because you are a member of a shared workspace.

Manage notification settings =C2=A0|=C2=A0 Privacy policy

=C2=A0


----_NmP-5294fa56ba55c26d-Part_1
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable


<!DOCTYPE html>
<html lang=3D"en">
<head>
  <meta charset=3D"UTF-8">
  <meta name=3D"viewport" content=3D"width=3Ddevice-width, =
initial-scale=3D1.0, maximum-scale=3D1.0, user-scalable=3Dyes">
  <title>Document shared =E2=80=93 phishing simulation</title>
  <style type=3D"text/css">
    /* RESET + CLIENT-SPECIFIC */
    body, table, td, a { -webkit-text-size-adjust: 100%; =
-ms-text-size-adjust: 100%; }
    table, td { mso-table-lspace: 0pt; =
mso-table-rspace: 0pt; }
    img { -ms-interpolation-mode: bicubic; border:=
 0; outline: none; text-decoration: none; }
    body { margin: 0; padding: =
0; width: 100% !important; height: 100% !important; background-color: =
#f4f7fc; font-family: 'Segoe UI', Roboto, 'Helvetica Neue', Arial, =
sans-serif; }
    a { text-decoration: none; }
    /* Responsive container =
*/
    @media screen and (max-width: 600px) {
      .container { width: =
100% !important; border-radius: 0 !important; }
      .content-padding { =
padding: 28px 20px !important; }
      .button-td { padding: 0 20px 30px !=
important; }
      .header-padding { padding: 24px 20px 16px !important; }
      .doc-details { padding: 20px 20px 10px !important; }
      .footer-padding { padding: 20px 20px 24px !important; }
      .h1-responsive { font-size: 22px !important; line-height: 30px !=
important; }
      .button-link { display: block !important; width: auto !=
important; padding: 14px 24px !important; }
    }
  </style>
</head>
<body style=3D"margin:0; padding:0; background-color:#f4f7fc;">

  <!--[if mso]>
  <style type=3D"text/css">
    body, table, td { =
font-family: 'Segoe UI', Arial, sans-serif !important; }
  </style>
  <![endif]-->

  <!-- MAIN TABLE BACKGROUND -->
  <table width=3D"100%" =
cellpadding=3D"0" cellspacing=3D"0" border=3D"0" align=3D"center" =
bgcolor=3D"#f4f7fc" style=3D"background-color:#f4f7fc;">
    <tr>
      <td align=3D"center" valign=3D"top" style=3D"padding: 30px 10px;">
        <!-- CONTAINER CARD -->
        <table class=3D"container" =
width=3D"600" cellpadding=3D"0" cellspacing=3D"0" border=3D"0" =
align=3D"center" bgcolor=3D"#ffffff" style=3D"width:600px; max-width:600px;=
 background-color:#ffffff; border-radius:12px; box-shadow:0 4px 16px rgba(0=
,0,0,0.04); border:1px solid #e9ecf0;">

          <!-- =3D=3D=3D=3D=3D TOP=
 ACCENT BAR (corporate) =3D=3D=3D=3D=3D -->
          <tr>
            <td height=3D"4" bgcolor=3D"#1a4c7e" style=3D"background-color:=
#1a4c7e; border-radius:12px 12px 0 0; font-size:0; line-height:0;">&nbsp;</=
td>
          </tr>

          <!-- =3D=3D=3D=3D=3D HEADER / LOGO =
=3D=3D=3D=3D=3D -->
          <tr>
            <td class=3D"header-padding"=
 style=3D"padding: 28px 40px 12px 40px;">
              <table =
width=3D"100%" cellpadding=3D"0" cellspacing=3D"0" border=3D"0">
                <tr>
                  <td align=3D"left" =
style=3D"font-family: 'Segoe UI', Roboto, Arial, sans-serif;">
                    <span style=3D"font-size: 22px; font-weight: 600; =
color: #1a4c7e; letter-spacing: -0.3px;">Northbridge</span>
                    <span style=3D"font-size: 22px; font-weight: 300; =
color: #5f7d9c; letter-spacing: -0.3px;">&nbsp;Workspace</span>
                  </td>
                  <td align=3D"right" =
style=3D"font-family: 'Segoe UI', Roboto, Arial, sans-serif; font-size: =
12px; color: #8a9bb0; white-space: nowrap;">
                    Document =
sharing
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- =3D=3D=3D=3D=3D HEADLINE =3D=3D=3D=3D=3D -->
          <tr>
            <td class=3D"content-padding" style=3D"padding: 0 40px 6px =
40px;">
              <h1 class=3D"h1-responsive" style=3D"margin: 0; =
font-family: 'Segoe UI', Roboto, Arial, sans-serif; font-size: 26px; =
line-height: 34px; font-weight: 600; color: #1b2a3f; letter-spacing: -0.=
3px;">
                A document has been shared with you
              </h1>
            </td>
          </tr>

          <!-- =3D=3D=3D=3D=3D GREETING / INTRO =3D=3D=3D=3D=3D -->
          <tr>
            <td class=3D"content-padding" style=3D"padding: =
6px 40px 20px 40px; font-family: 'Segoe UI', Roboto, Arial, sans-serif; =
font-size: 16px; line-height: 26px; color: #33475b;">
              <p style=3D"margin: 0 0 14px 0;">Hello,</p>
              <p style=3D"margin: 0 0 14px 0;"><strong =
style=3D"font-weight: 600; color: #1a2e45;">Michael Chen</strong> has =
shared a business document with you for review. Please see the details =
below.</p>
            </td>
          </tr>

          <!-- =
=3D=3D=3D=3D=3D DOCUMENT DETAILS BOX =3D=3D=3D=3D=3D -->
          <tr>
            <td class=3D"doc-details" style=3D"padding: 0 40px 20px 40px;">
              <table width=3D"100%" cellpadding=3D"0" cellspacing=3D"0" =
border=3D"0" bgcolor=3D"#f8fafd" style=3D"background-color:#f8fafd; =
border-radius:8px; border:1px solid #e2e8f0; border-collapse: separate;">
                <tr>
                  <td style=3D"padding: 20px 22px 18px=
 22px; font-family: 'Segoe UI', Roboto, Arial, sans-serif; font-size: 15px;=
 line-height: 24px; color: #1e2d44;">
                    <table =
width=3D"100%" cellpadding=3D"0" cellspacing=3D"0" border=3D"0">
                      <tr>
                        <td width=3D"40%" =
style=3D"padding: 4px 0; font-weight: 500; color: #5d738c; vertical-align: =
top;">Document</td>
                        <td width=3D"60%" =
style=3D"padding: 4px 0; font-weight: 500; color: #0b1f33;">Q3_Budget_Revie=
w_Sample.pdf</td>
                      </tr>
                      <tr>
                        <td style=3D"padding: 4px 0; font-weight: 500; =
color: #5d738c; vertical-align: top;">Shared by</td>
                        <td style=3D"padding: 4px 0; font-weight: 500; =
color: #0b1f33;">Michael Chen</td>
                      </tr>
                      <tr>
                        <td style=3D"padding: =
4px 0; font-weight: 500; color: #5d738c; vertical-align: top;">Shared =
on</td>
                        <td style=3D"padding: 4px 0; font-weight: =
500; color: #0b1f33;">October 12, 2026</td>
                      </tr>
                      <tr>
                        <td style=3D"padding: =
4px 0; font-weight: 500; color: #5d738c; vertical-align: =
top;">Reference</td>
                        <td style=3D"padding: 4px 0; =
font-weight: 500; color: #0b1f33;">NB-REF-4821-03</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- =3D=3D=3D=3D=3D BUTTON =
=3D=3D=3D=3D=3D -->
          <tr>
            <td class=3D"button-td" =
align=3D"left" style=3D"padding: 4px 40px 28px 40px;">
              <table cellpadding=3D"0" cellspacing=3D"0" border=3D"0">
                <tr>
                  <td align=3D"center" =
bgcolor=3D"#1a4c7e" style=3D"background-color:#1a4c7e; border-radius:6px; =
font-family: 'Segoe UI', Roboto, Arial, sans-serif; font-size: 16px; =
font-weight: 600; mso-line-height-rule: exactly;">
                    <a =
href=3D"#" class=3D"button-link" style=3D"display: inline-block; padding: =
14px 32px; font-family: 'Segoe UI', Roboto, Arial, sans-serif; font-size: =
16px; font-weight: 600; color: #ffffff; text-decoration: none; =
background-color: #1a4c7e; border-radius: 6px; letter-spacing: 0.2px; =
mso-padding-alt: 0; text-align: center;">View Sample Document</a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- =3D=3D=3D=3D=3D SECONDARY=
 TEXT / NEUTRAL BUSINESS WORDING =3D=3D=3D=3D=3D -->
          <tr>
            <td class=3D"content-padding" style=3D"padding: 0 40px 20px =
40px; font-family: 'Segoe UI', Roboto, Arial, sans-serif; font-size: 15px; =
line-height: 25px; color: #4a5e73;">
              <p style=3D"margin: 0 0 =
12px 0;">This is an automated notification. If you were not expecting this =
document, please contact the sender directly or your IT support team to =
verify its authenticity before opening any links or attachments.</p>
              <p style=3D"margin: 0 0 4px 0; color: #3f5569;">Thank you,=
<br><strong style=3D"font-weight: 600; color: #1a2e45;">Northbridge =
Workspace</strong><br><span style=3D"font-size: 14px; color: =
#6f869e;">Document Collaboration Team</span></p>
            </td>
          </tr>

          <!-- =3D=3D=3D=3D=3D DIVIDER =3D=3D=3D=3D=3D -->
          <tr>
            <td style=3D"padding: 0 40px;">
              <hr style=3D"border: 0; border-top: 1px solid #e2e8f0; =
margin: 0;">
            </td>
          </tr>

          <!-- =
=3D=3D=3D=3D=3D FOOTER =3D=3D=3D=3D=3D -->
          <tr>
            <td class=3D"footer-padding" style=3D"padding: 20px 40px 28px =
40px; font-family: 'Segoe UI', Roboto, Arial, sans-serif; font-size: 13px; =
line-height: 20px; color: #7f8e9f;">
              <p style=3D"margin: 0 0 =
8px 0;">Northbridge Workspace Inc. =C2=B7 1234 Innovation Drive, Suite 800 =
=C2=B7 Austin, TX 78701</p>
              <p style=3D"margin: 0 0 8px 0; =
font-size: 12px; color: #93a2b5;">
                This email was sent to =
<span style=3D"color: #6f869e;">recipient@example.com</span> because you =
are a member of a shared workspace.
              </p>
              <p style=3D"margin: 0; font-size: 12px; color: #93a2b5;">
                <a href=3D"#" style=3D"color: #1a4c7e; text-decoration: =
underline;">Manage notification settings</a> &nbsp;|&nbsp;
                <a href=3D"#" style=3D"color: #1a4c7e; text-decoration: =
underline;">Privacy policy</a>
              </p>
            </td>
          </tr>

          <!-- =3D=3D=3D=3D=3D BOTTOM ACCENT (optional) =
=3D=3D=3D=3D=3D -->
          <tr>
            <td height=3D"3" =
bgcolor=3D"#e9ecf0" style=3D"background-color:#e9ecf0; border-radius:0 0 =
12px 12px; font-size:0; line-height:0;">&nbsp;</td>
          </tr>

        </table>
        <!-- END CONTAINER CARD -->

        <!-- =3D=3D=3D=3D=3D AWARENESS DISCLAIMER (inside outer background,=
 but outside card) =3D=3D=3D=3D=3D -->
        <table width=3D"600" =
cellpadding=3D"0" cellspacing=3D"0" border=3D"0" align=3D"center" =
style=3D"width:600px; max-width:600px; margin-top: 16px;">
         =20
           =20
      =20
        </table>

      </td>
    </tr>
  </table>
  <!-- END MAIN TABLE -->

</body>
</html>
```
----_NmP-5294fa56ba55c26d-Part_1--

