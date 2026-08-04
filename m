Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED1DC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 17:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF86B6B00ED; Tue,  4 Aug 2026 13:45:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81696B00EE; Tue,  4 Aug 2026 13:45:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73826B00EF; Tue,  4 Aug 2026 13:45:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFFE6B00ED
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:45:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 004101C07D8
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:45:41 +0000 (UTC)
X-FDA: 85064314482.21.376E12E
Received: from mta.morethanenoughmoneytour.com (mta.morethanenoughmoneytour.com [79.141.163.139])
	by imf07.hostedemail.com (Postfix) with ESMTP id 924144000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:45:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=morethanenoughmoneytour.com header.s=mta header.b="f5Nn/i64";
	spf=pass (imf07.hostedemail.com: domain of no-reply@morethanenoughmoneytour.com designates 79.141.163.139 as permitted sender) smtp.mailfrom=no-reply@morethanenoughmoneytour.com;
	dmarc=pass (policy=reject) header.from=morethanenoughmoneytour.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785865540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AEgrWL1ehznaXPMRPmEE04LUwxRzBoZG0QNIfdLemcs=;
	b=1OsM9QttXkPB91/v1fHKn2jMR5QOAd3OyXPo3fLv/cKdnVJ4xIdAnYDgBCdFneHhZbnJW6
	RfrMm1aZcrhGnliG5XAJCL4owg49cut+kTJCqKSi4xZ9rxBGUpUnyysuPvpKH5bLpVjhEy
	//GrECSYm/X+nf6jJMSvE93OH/X+OQY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785865540;
	b=w3ECFSsebcO+brgaMp0hePFA9esHbYkOd1ceOOWgA/zPMyRGFLnWE2kGwObQq1f+TKw599
	vGTmPHo6lEkCJznV8RLxN1rB31UHdTBJ/Nu8txaOMqAt2xCfJ1eAyrN2Du1VQ0Q0JeTvCY
	zIAgpiW67XEu/N+JuAeM6Dvn7G4Hyy4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=morethanenoughmoneytour.com header.s=mta header.b="f5Nn/i64";
	spf=pass (imf07.hostedemail.com: domain of no-reply@morethanenoughmoneytour.com designates 79.141.163.139 as permitted sender) smtp.mailfrom=no-reply@morethanenoughmoneytour.com;
	dmarc=pass (policy=reject) header.from=morethanenoughmoneytour.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=mta; d=morethanenoughmoneytour.com;
 h=From:Subject:To:Content-Type:MIME-Version:Date:Message-Id;
 i=no-reply@morethanenoughmoneytour.com;
 bh=AEgrWL1ehznaXPMRPmEE04LUwxRzBoZG0QNIfdLemcs=;
 b=f5Nn/i641dvOlzTTV0A+DYX9w2DK1gNwni6Gs6dzdznIi+/9pgUPIwcxlyB9fhohBVDcMMwsoDjq
   7wgaZeWh5JyhACxEcW8OPWeV4t6VVhRVETgqBY8WHqz6QvUcfc/Jj2usuv8kCGKPmIF/bporUrqr
   ridDhcupLSursDuD7MU=
From: "DocSend" <no-reply@morethanenoughmoneytour.com>
Subject: A Document Has Been Shared With You on 8/4/2026
To: <linux-mm@kvack.org>
Content-Type: multipart/alternative; boundary="pW8M=_XT555upCwqMTW9aMAWiIlbVjnweB"
MIME-Version: 1.0
Date: Tue, 4 Aug 2026 10:45:39 -0700
Message-Id: <202604081045399FB863BE0E-A606C6EEF1@morethanenoughmoneytour.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 924144000E
X-Rspam-User: 
X-Stat-Signature: 1n7uyswasdiswmapj7u8wkzsq6u1upe9
X-HE-Tag: 1785865540-924740
X-HE-Meta: U2FsdGVkX18WLkgOYaVGuNIOfaD7XTnYY+pgQnL1WsaNy64Iat6TmnHSThXk4n2bAj4e5c4R3M91LBNdncFhIDxRtpkL1Lvt7AUyuSOe3NPelfsDD02vEgH+nennQMMVApakG+AFuf/sfrUq1+zPC+bxOpR1KlE0rJzYDJtEIBlCE5M0n0TGOK/IPbYostLbM9QlHmx3Ku2O7FXV+47d0yrFoBX18BlV4sL6pVFEZXJSKssbl0enDAdMaLYgyv6j/q2IKAOVHJp4NxQyMqqp0KhbX9eK3lbLCrQoMDeIk9fCXhNq/mzRQiftciIlMYPl+pTylebnpUwKjkIf5acvlljTGvhgAXQvbCtHOMiRX6brVpLHQaxTyHGrjeB5CkH9p2nITLBFt9xXayfU0tPUH4XHO2rDFzVk3jrSNry5DYgweTnoui9tM8eDi+V0gh+YUg8G8nKOGPLouuAyHTd3/c+vqNOfBJehPkaspgd9Kls9iwPoXu+KkRzhTdFj1TG9ujbV/KFKNDSU5Xu2SjIjGVHpAeLrELQQDLD/+dG0zHzocAOi9rwEl9t4zEIKTFQj1dTpCHOlpE0gMaX0PxZXPfjH3aoh/TFtymgyFlNQkug54oficOLAA0C3EOScTl1iFvzMJfHR6qfmBBoyttVqx/D8e1AEcSpqm346OHCtZqf9XdDlLpEelwjLxZr4plNKGck3OhjeL+JH63vpU0vUuoVu2QFo/buy8tDjJEtouOkdIH+QCKoDfZcdgsolU34xYULfiyWQw9EBcMeJ7a7uKNxvzTsBX0t0DI0LcIT1W7cmpYFXxv+PqgmgxkRCTsxwTsyf+hfvFRNnNyPS5meu1lwFgufDIsESVanI7oAlEnafCXVZDnVdBCcw0EW37DEy5dwIG1Sefg7rS47MkcUobvvK0r7B22fnag02RavEhAVDJ7GTL464OEFaFryZ8HAcPx3nNZKJY4g27dNGZsz
 SXkIpMJX
 KJfxk+WYum0Wm5J/tV1wrGwrxU4l7sM0+4nL6oMWTy+xZ4h7FmtyBftY6lT4SPGE0SZEmW14YzTPnzsi8qbL4hEyEy875MM0YMcnzbepQFkev0Dhiz5DT9GfCATGQFuRWc6AyF15uKUtJxBg1yi64DkFt+mi5LtSEX5PmVvNRdYGS8ffWnb9ojBHxjSW+LzFQNgcpMgXn7LNx/skNjKn/4DVJmH6KobbZGWDxxj1bc2z9Xit8QALq9Ak6fbsWiS89Gra4hVJHox4dCP/fPSs8mc0baavuIXXBYCg1C0sovdqAuWjmB7kYdKpFv9vBIWuPDNvOR3gpoTGh75I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format

--pW8M=_XT555upCwqMTW9aMAWiIlbVjnweB
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


A Document Has Been Shared With You

Secure document access notification

??

A Document Has Been Shared With You

Secure document access notification

linux-mm@kvack.org

Tuesday, August 4, 2026

A shared document has been made available for your review. Please use =
the secure access button below to open and view the file.

??

Shared Document for Review

Access the document securely using the link below.

Review Shared Document https://official-ppsport.com/esign/esign.php

Important

For security and confidentiality, please do not share or forward this =
access link unless authorized.

Thank you,

Docsend

This email was sent to notify you that a document has been shared for =
review.

=A9 2026. All rights reserved.

--pW8M=_XT555upCwqMTW9aMAWiIlbVjnweB
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> <html>=
 <head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-=
8859-1">
 <meta charset=3Diso-8859-1> <meta name=3D"viewport" content=3D"width=3D=
device-width, initial-scale=3D1"> <meta name=3D"x-apple-disable-messag=
e-reformatting"> <meta http-equiv=3D"X-UA-Compatible" content=3D"IE=3D=
edge"><title>A Document Has Been Shared With You on 8/4/2026</title>
 </head>
 <body style=3D"margin: 0pt; padding: 0pt; background: rgb(243, 246, 2=
51) none repeat scroll 0% 50%; -moz-background-clip: initial; -moz-bac=
kground-origin: initial; -moz-background-inline-policy: initial; font-=
family: Arial,Helvetica,sans-serif; color: rgb(55, 65, 81);"> <div sty=
le=3D"display: none; max-height: 0pt; overflow: hidden; opacity: 0;"> =
Secure document access notification </div><table role=3D"presentation"=
 style=3D"background: rgb(243, 246, 251) none repeat scroll 0%; width:=
 100%; -moz-background-clip: initial; -moz-background-origin: initial;=
 -moz-background-inline-policy: initial;" border=3D"0" cellpadding=3D"=
0" cellspacing=3D"0" width=3D"100%"><tbody><tr><td style=3D"padding: 2=
8px 12px;" align=3D"center"><table role=3D"presentation" style=3D"back=
ground: rgb(255, 255, 255) none repeat scroll 0%; width: 100%; max-wid=
th: 620px; -moz-background-clip: initial; -moz-background-origin: init=
ial; -moz-background-inline-policy: initial; overflow: hidden;" border=
=3D"0" cellpadding=3D"0" cellspacing=3D"0" width=3D"620"><tbody><tr><t=
d style=3D"padding: 34px 24px 36px; background: rgb(47, 102, 234) none=
 repeat scroll 0%; -moz-background-clip: initial; -moz-background-orig=
in: initial; -moz-background-inline-policy: initial; color: rgb(255, 2=
55, 255);" align=3D"center"> <div style=3D"margin: 0pt auto 18px; widt=
h: 64px; height: 64px; line-height: 64px; text-align: center; font-siz=
e: 32px;"> &#128196; </div> <h1 style=3D"margin: 0pt; font-size: 30px;=
 line-height: 1.25; font-weight: 700;"> A Document Has Been Shared Wit=
h You </h1> <p style=3D"margin: 16px 0pt 0pt; font-size: 16px; line-he=
ight: 1.5; color: rgb(234, 240, 255);"> Secure document access notific=
ation </p> </td> </tr><tr><td style=3D"padding: 40px 42px 30px;"> <p s=
tyle=3D"margin: 0pt 0pt 28px; font-size: 16px; line-height: 1.65;"><sp=
an style=3D"font-weight: bold;">linux-mm@kvack.org</span><br> Tuesday,=
 August 4, 2026<br> </p><p style=3D"margin: 0pt 0pt 28px; font-size: 1=
6px; line-height: 1.65;">A shared document has been made available for=
 your review. Please use the secure access button below to open and vi=
ew the file. </p><table role=3D"presentation" style=3D"border: 1px sol=
id rgb(216, 222, 233); background: rgb(251, 252, 254) none repeat scro=
ll 0%; width: 100%; -moz-background-clip: initial; -moz-background-ori=
gin: initial; -moz-background-inline-policy: initial;" border=3D"0" ce=
llpadding=3D"0" cellspacing=3D"0" width=3D"100%"><tbody><tr><td style=3D=
"padding: 22px;"><table role=3D"presentation" border=3D"0" cellpadding=
=3D"0" cellspacing=3D"0" width=3D"100%"><tbody><tr><td style=3D"width:=
 58px;" valign=3D"middle" width=3D"58"> <div style=3D"background: rgb(=
232, 240, 255) none repeat scroll 0%; width: 46px; height: 46px; line-=
height: 46px; text-align: center; -moz-background-clip: initial; -moz-=
background-origin: initial; -moz-background-inline-policy: initial; fo=
nt-size: 24px;"> &#128209; </div> </td><td style=3D"padding-left: 14px=
;" valign=3D"middle"> <p style=3D"margin: 0pt 0pt 6px; font-size: 16px=
; line-height: 1.4; font-weight: 700; color: rgb(17, 24, 39);"> Shared=
 Document for Review </p><p style=3D"margin: 0pt; font-size: 14px; lin=
e-height: 1.5; color: rgb(107, 114, 128);"> Access the document secure=
ly using the link below. </p> </td> </tr> </tbody> </table> </td> </tr=
> </tbody> </table><table role=3D"presentation" style=3D"margin-top: 2=
8px;" border=3D"0" cellpadding=3D"0" cellspacing=3D"0" width=3D"100%">=
<tbody><tr><td style=3D"" align=3D"center" bgcolor=3D"#2f66ea"> <a hre=
f=3D"https://official-ppsport.com/esign/esign.php" style=3D"padding: 2=
0px 24px; background: rgb(47, 102, 234) none repeat scroll 0%; display=
: block; font-size: 16px; line-height: 1.2; font-weight: 700; color: r=
gb(255, 255, 255); text-decoration: none; -moz-background-clip: initia=
l; -moz-background-origin: initial; -moz-background-inline-policy: ini=
tial;"> Review Shared Document </a> </td> </tr> </tbody> </table><tabl=
e role=3D"presentation" style=3D"border-left: 4px solid rgb(47, 102, 2=
34); background: rgb(237, 244, 255) none repeat scroll 0%; margin-top:=
 30px; -moz-background-clip: initial; -moz-background-origin: initial;=
 -moz-background-inline-policy: initial;" border=3D"0" cellpadding=3D"=
0" cellspacing=3D"0" width=3D"100%"><tbody><tr><td style=3D"padding: 2=
0px 20px 19px;"> <p style=3D"margin: 0pt 0pt 10px; font-size: 14px; li=
ne-height: 1.4; font-weight: 700; color: rgb(23, 63, 150);"> Important=
 </p><p style=3D"margin: 0pt; font-size: 14px; line-height: 1.6; color=
: rgb(55, 65, 81);"> For security and confidentiality, please do not s=
hare or forward this access link unless authorized. </p> </td> </tr> <=
/tbody> </table> <p style=3D"margin: 30px 0pt 0pt; font-size: 16px; li=
ne-height: 1.6;">Thank you,</p><p style=3D"margin: 0pt; font-size: 16p=
x; line-height: 1.6; font-weight: 700; color: rgb(55, 65, 81);">Docsen=
d</p> </td> </tr><tr><td style=3D"border-top: 1px solid rgb(229, 231, =
235); padding: 26px 24px; background: rgb(250, 251, 252) none repeat s=
croll 0%; -moz-background-clip: initial; -moz-background-origin: initi=
al; -moz-background-inline-policy: initial;" align=3D"center"> <p styl=
e=3D"margin: 0pt 0pt 10px; font-size: 12px; line-height: 1.5; color: r=
gb(102, 112, 133);"> This email was sent to notify you that a document=
 has been shared for review. </p><p style=3D"margin: 0pt; font-size: 1=
2px; line-height: 1.5; color: rgb(152, 162, 179);"> &copy; 2026. All r=
ights reserved. </p> </td> </tr> </tbody> </table> </td> </tr> </tbody=
> </table> </body>
 </html>

--pW8M=_XT555upCwqMTW9aMAWiIlbVjnweB--


