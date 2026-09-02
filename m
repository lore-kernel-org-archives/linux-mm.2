Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A232C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507D66B0098; Wed,  2 Sep 2026 01:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491216B0099; Wed,  2 Sep 2026 01:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359336B009B; Wed,  2 Sep 2026 01:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05E6D6B0098
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:12:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95D891A0748
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:12:32 +0000 (UTC)
X-FDA: 85167651744.28.65F7023
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id ADD66180007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:12:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=muKKXgK4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788325950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKIm7/Vo/3kBu5uxI8QEzbmCtRRNycmtWWof5ToxHwo=;
	b=obOsWH48Ag857r8FApbJU5FFaKl/k4VqOn7GqQELjxek6CsVKoi/qi2H4Bf5NGpA5ytDuK
	M4V39pZFUb6a5e9YX20BObq9mE+T0oZxCOAQzNQp4QsBQDqlypJpJJig8nAoy6SHSt3rew
	9hdLM90J9xM2Lia8IpjjET/xuVz3+l4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788325950;
	b=eVTGdBW2fX2zVd97pFLVZZ78tk8hHbd9ZBm640DpOGrm+v9FVy0CrGTkDepjBeGZkx+RSr
	6MlZlx91ktFnRnQgrU4D+iBZZcDIHvjmXJmyfv37LcG9jMC6ELhQS7YYxf5rY7+QH4rflY
	zh8FffrARBjv3NWpcI+mW+mXmEMf6mY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=muKKXgK4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc1cc1b42b5so711630a12.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 22:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788325949; x=1788930749; darn=kvack.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:content-type
         :message-id:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cKIm7/Vo/3kBu5uxI8QEzbmCtRRNycmtWWof5ToxHwo=;
        b=muKKXgK4/+7a7zX1pjUw1k5Zgz/I9HJqECKGh6QM9BQo3mgWZKfebVurXRcX+hZrCF
         ySq/7sljgm0PodRH6VTO4JsKOL8kh83L41OptW0RbrJtVflRQWTQHFiNaOzsgqOPRzdL
         qBZk0ui3HHCc5H2gtMmvPKgo03hj1mymV7P8rMWRV20rhbJTajvF993Re8X8NRy0vlcQ
         mkzrA8oiWFpUpIsgJBbaRmxQvCTMHeECcsTuwnVv6VfEwfOYDA76pXanB//MfMv3V7fz
         Lfewtbn8TXSe4lRcE/cezZyqf5k1AkFIvweslr/wHdAostnBon7Xx6jUqHnPqqwHtCZa
         EBTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788325949; x=1788930749;
        h=references:to:cc:in-reply-to:date:subject:mime-version:content-type
         :message-id:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cKIm7/Vo/3kBu5uxI8QEzbmCtRRNycmtWWof5ToxHwo=;
        b=agk4cjzgtuFFgXCIHCDbUg+DgBgCivCQPNFD6+3paUqcx88ktHQhqHcNP/di+AP2/R
         aWV6B/lTIjTCFRdAkoMlh0Rnvs+KHH5ruBgLqUfK/39XefLOCJtHJR3S8O8h+Q++y+O6
         dOWWjd9tIqoumJuEi7XSi86InTOqGlVjupBF1ES+QySeNsFnRGr0JehWruRdt5Uqobz+
         bv4YbnJuExqKMA+Ae2MVQSNJn3zE8bMvwwDcoAxR4c1t0Fg/tA+Rack8X6a1YiL8norW
         zqQgx9ict7hPmleiyg1TnVlDYzYtyVNpzJsxLqfxn2Ekl4lwmypcArPHsqguesukMs5p
         xAkA==
X-Forwarded-Encrypted: i=1; AKwUvBxEbh0kXGeFqKpJy9qojbrK6sFC8/3u9yFpVoQoPaGePtxm5RTbwlfO35N9lo1poqtkWTH3sNSe1g==@kvack.org
X-Gm-Message-State: AFuF++mjo4zsw8kHr3g4M2YYmlRUOCIg+4xVXiY0Q8v6EiTek91FbOBT
	/o6MYgCzRybkZr4gGV3/W2hTDCX9byMR27EU16oI00D+QDnEWj73R6xS
X-Gm-Gg: AYBFou3xi/WlQidvU4x9VASe2uxunVAmDMzfpWgMKbPVx22vp8H11e5/saV7othqsu7
	KCaQutHqsu9v515vWAv4Xffhz+3vja7+WJUlAWxuHitR/bYvTaO/XuRSm26djzr11I5Ngzx2vnp
	2hZgwIALjSEa8J9u59hqobFOgWCIezcCHCjoqMvl1phAnltQQeHPvmzpqp/T6/XfvFiWU7qQM3K
	7VDjKMyRUoRDNHApZjeQpHNuIiDzQtPsKgQWdcx/HjqQXlFqs/l6T3wNb6zRCd3QhbOHYhcPBRr
	hXg+gDmHekZjeVAYx9s3RUdExNmbITaap7y4Yh9381ywNPiMTyxVR9etgZqgMk4TdHrdpS9Jibj
	Zq8QNucLiNoFKndUs4gTpjR46m473ntoOBCozG+OWPAJK0sU7emvtcVYbWYt29+cyEa9KpAf7xC
	2kpNDRJUjX4A8dyXqOiIUOHjDIivZH2P8HHyif4RHixMw6Oup2iwxuI5I+6SYVVDdBXcw3kaEG+
	7ORhnYdODFKmajXNAVdkw==
X-Received: by 2002:a17:90b:3d81:b0:398:c150:e7b3 with SMTP id 98e67ed59e1d1-39aedf5d923mr3494095a91.4.1788325949194;
        Tue, 01 Sep 2026 22:12:29 -0700 (PDT)
Received: from smtpclient.apple (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae380d0bdsm3070979a91.11.2026.09.01.22.12.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2026 22:12:27 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
Message-Id: <806D90E7-E65E-4DD5-B104-D684900CF265@gmail.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_A66AA493-B1D3-419F-BCAD-FF98B71764EA"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v4 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto
 tuning
Date: Wed, 2 Sep 2026 13:12:12 +0800
In-Reply-To: <20260902042344.83913-1-sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
 damon@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
To: SJ Park <sj@kernel.org>
References: <20260902042344.83913-1-sj@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ADD66180007
X-Stat-Signature: 71zpgbgmfemizyz4cacss7wteqfmrmtg
X-Rspam-User: 
X-HE-Tag: 1788325950-467141
X-HE-Meta: U2FsdGVkX18h8Nr+pDaIP9bPkkKK6SGmkd+IUimI8YNlUdDoxDseYMzz9n+Ape3IdomjJ+t/xjgEsnpqdJwLZjptUSOPL4pCCDBmUfUVVq5R85qFTNj7pf5A+DTJKRkM4UPJvSueuRhaf5kb8ltbo3qODWy5ybbhM6qIV9mlKbarN9iBo+1o2V8W61ORokRgasmfjvA0RTkphvUYZovkvC6KREL0h9V+Ru/8QvQViUELxSElng9U8oBHeu28NO+JN2VfCOMKndxwLYiW4VFB9cCAvTWX060/c6BY5FvTlAOt8x+gTbnOqnvf+hdBqkqa9llmMvTTRMcpvxxvCSfzamXS1o8hAj3bw6DDxN7tN1GtoLOd/nbMYh0I+I2+DFFoNFXU0nv/916MgHFfiV7f7Tt6+AlNBnikRSNr+/67TqHbdazl8tecdPiNUW9J+UsG7qBELcwDLIcoVQ/pyJ+iBlwIW9hUUxw6N3ZT/K0huXSLGnFmnptMATwKX/x7H+f0686t1vngkwqQYTHIE2lrwBYjoKlm5IQrEJom7lCxi7M4h8wqFw+27XV/aK3Ggeuc4I1xnxqoR8sxolgos3i17vRpIxnfD5cBuEaSgXs3JbK66DUNGu/PD3oX48865qCRiFAo8JRgnRZxAex7fxK0vU+Xf6VlKEvnnRXwosqecY6Zpq4Sdh1S+z2F2XgRi6PKVtQqsCG4WK0ZUtu03aIgwYVnjic0hwFdHTyMTse1lgf6wyNMWIad7rA0evCz5YvrNdLMTKhMTClnkN74OvIGB3fkzsgDokdbQOrmJtZ0isg0sshOFRORTg1aJMWViS1DZ5XO08JpHNwW9Yys8y79k81S9nZ4aDowJuMebUHi6f2kUwZ+Jxs/B9wOnpn5C0Ay/4yRJnNmCCv0rh1S90Z+TdgPxgspdKHYQ4D0zZy32D+6v/Ihg8ioSo2HTgZxBz0/E9kyjWKysNBNDoF5ArU
 ymFf/9GP
 R7RO+1ntTbm1rFmERggpGtp40IeEE+VR3YcE8R/TZmuHLRJl3v6ZHe6lC5O63NESCvLRxrJLYaxYmhhkK6VSfDY4vnLN7grqjntitAE3GqwD0i1pBYV1+mti4V3H5s2PiAwwCZofXW4XPEZOV/r48ZsP/izAFxO7atmXNooSmPgcortyPFbfoTRAMfe4JsPNbYDxU0RwRhsZPBbHRQKg6k9RcXCBlxYqe9oh9Qiazo/8pTnYfHVzkC8oqEf79yfEKNlOxqakEsOdx23K+DdZrYAdKEV/PxNU/HeyJAEIeWDjTD71I23RbU8gBKjZwiq4gr8OLGvC6PZibPAZHkNg5it14gyr8iz36HbYXJnHAdCLDYiM1OfS8kr4syYj0bT0sKz0NigaUFuM0PYzuKWHQWIi7c42IpZpkCnky5nHsMrcNThqGvg6a5ytVMF5cK75W5znShMAnyZ7XeiPa2bvTcYMLyz228IrfH84LqcjBLkZR++e+kE9/XNy51IwYWDrEqtbQgrBIVh6bneWDxo9x+iSc6CIZIKOlcZ4P+wzUWbMPRMnnjIeWFOt6rkt+8JolWbtW/zRfHMS3nGW9Rx8yf31Wv7/5Kk335VpR6WGIE4OL16wc/MfbTtDAb8y2IrUzNJjaJYremSNxTx7dTwC4gL2PMc1+FBZaWnsFWWyQVMmZUnohoLtGPd04lJGaKZWCJrmzmqTKt6l19Ryt1wM8iTSyHD0Rw9o/mVI2UP2cYPJty/O/DDhH2rfUbdkF3QKlI+cTlZsQMiRbU3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_A66AA493-B1D3-419F-BCAD-FF98B71764EA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On Sep 2, 2026, at 12:23, SJ Park <sj@kernel.org> wrote:
>=20
> On Wed,  2 Sep 2026 09:56:01 +0800 Lian Wang <lianux.mm@gmail.com =
<mailto:lianux.mm@gmail.com>> wrote:
>=20
>> Hi SJ,
>>=20
>>> Seems using MTHP_STAT_NR_ANON that is exposed as 'nr_anon' can be =
used?
>>=20
>> Thank you for the suggestion.  I will study MTHP_STAT_NR_ANON and =
nr_anon
>> further, and document what I find.  We can continue discussing it by =
email,
>> and I will be happy to review any follow-up or updated patches.
>>=20
>>> I'm curious if you and general reviewers need or prefer to directly =
be Cc-ed.
>>> I was naively thinking people can search and review DAMON patches by
>>> subscribing to the mailing list or using the archives via =
lore.kernel.org like
>>> tools.
>>=20
>> I subscribe to many mailing lists, including linux-mm and DAMON, and =
I also
>> follow patches through lore.  Direct Cc is not required, but I =
appreciate it
>> for DAMON-related patches.  Because I care deeply about DAMON, =
directly Cc-ed
>> messages are filtered into my important mailbox, so I can archive and =
review
>> them quickly.
>=20
> Thank you so much for your interest in DAMON, Lian.  But, the problem =
is that
> my memory is so bad. :'(
>=20
> I am maintaing mm patches review status dashboard for people who want =
to find
> patches that waiting for their review.  It also provides the review =
status for
> each sub-mm components [2] including DAMON [3].  Maybe finding patches =
that
> waiting for your review from the dashboard is also a way for you?
>=20
> If having the mail directly in your important mailbox is what you =
need, I
> believe adding mails filtering rule for DAMON patches wouldn't be that
> difficult.  If you use hkml, it could also help you monitoring [4] =
those.
>=20
> Yet another systematic and long term solution that I could suggest is =
keep
> reviewing and posting DAMON patches one by one, build more tracked =
records and
> trusts, eventually adding your name as DAMON reviewer or maintainer on =
the
> MAINTAINERS file.  All patches sent with get_maintainers.pl will =
automatically
> Cc you.  It would take time and require patience, though, of course.
Thank you for your detailed feedback.
>=20
>>=20
>> I am very happy to contribute to DAMON, and I look forward to =
continuing our
>> discussions and reviews by email.
>=20
> I really appreciate your interest and contributions to DAMON.  I hope =
it to be
> continued long term!
>=20
> [1] https://github.com/sjp38/mm_git_dashboard
> [2] =
https://github.com/sjp38/mm_git_dashboard/tree/master/summary/subsystem
> [3] =
https://github.com/sjp38/mm_git_dashboard/tree/master/summary/subsystem/DA=
MON
> [4] =
https://github.com/sjp38/hackermail/blob/master/USAGE.md#monitoring-mails
>=20
Okay, I will. I will contribute to the community, continuously learn and =
provide feedback to=20
ultimately make Damon better.
>=20
>=20
> Thanks,
> SJ
>=20
Thanks
Lian
> [...]


--Apple-Mail=_A66AA493-B1D3-419F-BCAD-FF98B71764EA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Sep 2, 2026, at 12:23, SJ Park =
&lt;sj@kernel.org&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">On Wed, &nbsp;2 Sep 2026 09:56:01 +0800 =
Lian Wang &lt;</span><a href=3D"mailto:lianux.mm@gmail.com" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px;">lianux.mm@gmail.com</a><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; wrote:</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: solid;">Hi =
SJ,<br><br><blockquote type=3D"cite">Seems using MTHP_STAT_NR_ANON that =
is exposed as 'nr_anon' can be used?<br></blockquote><br>Thank you for =
the suggestion. &nbsp;I will study MTHP_STAT_NR_ANON and =
nr_anon<br>further, and document what I find. &nbsp;We can continue =
discussing it by email,<br>and I will be happy to review any follow-up =
or updated patches.<br><br><blockquote type=3D"cite">I'm curious if you =
and general reviewers need or prefer to directly be Cc-ed.<br>I was =
naively thinking people can search and review DAMON patches =
by<br>subscribing to the mailing list or using the archives via =
lore.kernel.org like<br>tools.<br></blockquote><br>I subscribe to many =
mailing lists, including linux-mm and DAMON, and I also<br>follow =
patches through lore. &nbsp;Direct Cc is not required, but I appreciate =
it<br>for DAMON-related patches. &nbsp;Because I care deeply about =
DAMON, directly Cc-ed<br>messages are filtered into my important =
mailbox, so I can archive and review<br>them =
quickly.<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Thank you so much for your interest in =
DAMON, Lian. &nbsp;But, the problem is that</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">my memory is so bad. :'(</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">I am maintaing mm patches review status =
dashboard for people who want to find</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">patches that waiting for their review. =
&nbsp;It also provides the review status for</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">each sub-mm components [2] including DAMON =
[3]. &nbsp;Maybe finding patches that</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">waiting for your review from the dashboard =
is also a way for you?</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">If having the mail directly in your =
important mailbox is what you need, I</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">believe adding mails filtering rule for =
DAMON patches wouldn't be that</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">difficult. &nbsp;If you use hkml, it could =
also help you monitoring [4] those.</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Yet another systematic and long term =
solution that I could suggest is keep</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">reviewing and posting DAMON patches one by =
one, build more tracked records and</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">trusts, eventually adding your name as =
DAMON reviewer or maintainer on the</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">MAINTAINERS file. &nbsp;All patches sent =
with get_maintainers.pl will automatically</span><br style=3D"caret-color:=
 rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Cc you. &nbsp;It would take time and =
require patience, though, of course.</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"></div></blockquote>Thank you for your detailed =
feedback.<br><blockquote type=3D"cite"><div><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: =
solid;"><br>I am very happy to contribute to DAMON, and I look forward =
to continuing our<br>discussions and reviews by =
email.<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">I really appreciate your interest and =
contributions to DAMON. &nbsp;I hope it to be</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">continued long term!</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">[1]<span =
class=3D"Apple-converted-space">&nbsp;</span></span><a =
href=3D"https://github.com/sjp38/mm_git_dashboard" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: =
0px;">https://github.com/sjp38/mm_git_dashboard</a><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">[2]<span =
class=3D"Apple-converted-space">&nbsp;</span></span><a =
href=3D"https://github.com/sjp38/mm_git_dashboard/tree/master/summary/subs=
ystem" style=3D"font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: =
0px;">https://github.com/sjp38/mm_git_dashboard/tree/master/summary/subsys=
tem</a><br style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: =
solid;"><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline =
!important;">[3]<span =
class=3D"Apple-converted-space">&nbsp;</span></span><a =
href=3D"https://github.com/sjp38/mm_git_dashboard/tree/master/summary/subs=
ystem/DAMON" style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: =
0px;">https://github.com/sjp38/mm_git_dashboard/tree/master/summary/subsys=
tem/DAMON</a><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">[4]<span =
class=3D"Apple-converted-space">&nbsp;</span></span><a =
href=3D"https://github.com/sjp38/hackermail/blob/master/USAGE.md#monitorin=
g-mails" style=3D"font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: =
0px;">https://github.com/sjp38/hackermail/blob/master/USAGE.md#monitoring-=
mails</a><br style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: =
solid;"><br style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: =
solid;"></div></blockquote>Okay, I will. I will contribute to the =
community, continuously learn and provide feedback =
to&nbsp;</div><div>ultimately make Damon better.<blockquote =
type=3D"cite"><div><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Thanks,</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">SJ</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"></div></blockquote>Thanks</div><div>Lian<br><blockquote =
type=3D"cite"><div><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline =
!important;">[...]</span></div></blockquote></div><br></body></html>=

--Apple-Mail=_A66AA493-B1D3-419F-BCAD-FF98B71764EA--

