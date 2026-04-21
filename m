Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD56BF94CA7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 19:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA4C6B0005; Tue, 21 Apr 2026 15:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382FF6B0089; Tue, 21 Apr 2026 15:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BFE26B008A; Tue, 21 Apr 2026 15:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1436B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:50:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB088C44F2
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:50:45 +0000 (UTC)
X-FDA: 84683605650.06.F577B8A
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf23.hostedemail.com (Postfix) with ESMTP id 55A33140003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:50:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Ojw21miq;
	spf=pass (imf23.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776801044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCjWSSIZbA4XEQuOH5MeUsG+YjOq0+1NceVLCuMx9rA=;
	b=JwlahE7AnRjQIyQJC4fcaVgwdcjyvQwobj06W+tWYPWed7571fZeb+IK2sn/r0O0G5thdu
	8tnOJeYgHLgnj4D++4X2W8gkxiuIs+1Rj1lzOGYfAB+vZsKb6CYitwNF7niXgwzrLRMbmH
	VefBo34/N53jKBd+uvIav01o/8ZEmG0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Ojw21miq;
	spf=pass (imf23.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776801044; a=rsa-sha256;
	cv=none;
	b=xcL3fVvs6QTkmrSebeuBosbFweE+wI5COpoEQpb0+cEWbDHCIBcjqNgT0w78MEVJ+tXxaz
	2SgWmGDSqr0Nsi6/HmaT8uJHn5ylfaLWzHYtBD1Z3afKfl73LIyhprzHGBvTJJVMsp2LHb
	JPv3CgZmOfHB9NBhSs0j63Hmj9ZSFVI=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4g0Xyl3Jg8z9tkN;
	Tue, 21 Apr 2026 21:50:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1776801039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WCjWSSIZbA4XEQuOH5MeUsG+YjOq0+1NceVLCuMx9rA=;
	b=Ojw21miqs8FzWgLIMJ4vgrHZMwCxxXTrILZb4XsZkxtpyvb3fJ/+EBJO2gQw9rRpqUswuV
	mhO3KP0pHGeSllyCHNCqAAqQKAxWhLhLHZar/9NQ/s7QwP4BvLmrGALf6Uq2dEhTAlfpPB
	TwsZq+gdSnnUCdJ7tJjZS7gh8dyu9pHZUCGnIvjGgefM2OhNSXqIHR7g2CZMMy02RLhK1b
	L7Mbyn3iRK0ux+YdzJ4KTq8nk0R97KNdRgVkxPc96sGqOqSqSVlU94T8UXfntorpNNzvJq
	8Pv/+ovu7c/TR4WPHmTkAIFcoXprzbrJbB5hCkxMve8kYAXfKPYZntKn780JCQ==
Message-ID: <f1bf7387d578ce4d52ad3830a5c9d9e4ceb86b62.camel@mailbox.org>
Subject: Re: [PATCH v2 1/3] Documentation: adopt new coding style of
 type-aware kmalloc-family
From: Manuel Ebner <manuelebner@mailbox.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  linux-doc@vger.kernel.org, Kees Cook
 <kees@kernel.org>,  linux-kernel@vger.kernel.org,
 workflows@vger.kernel.org,  linux-sound@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 21 Apr 2026 21:50:34 +0200
In-Reply-To: <aefPCV4ZvrnrCmoH@casper.infradead.org>
References: <20260421175516.224960-2-manuelebner@mailbox.org>
	 <20260421180200.225244-2-manuelebner@mailbox.org>
	 <aefPCV4ZvrnrCmoH@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MBO-RS-META: y6krjg6cqr7f8bgpz3k5aesy41yx81y6
X-MBO-RS-ID: 9292af9b2e0ed599f04
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55A33140003
X-Stat-Signature: u1tqu3otefzcyne18iu3ag1j39s6jmtz
X-Rspam-User: 
X-HE-Tag: 1776801043-417325
X-HE-Meta: U2FsdGVkX18V0muQfw+fBFXSgSNJoqD6Oy13JvG+zZgg0jgIrZ8N6F7FIOiNKfEAUxG8vb/lLPy5xyFj1NMzMtv0AjXon1PsQwvjxI1DiL/9SS/9OirX0vsd8fDVvwmRw3JUcIJe4EdQJFMSfqM47hulFNDRaA0jbkr/lEQhYr0mYpai5l+akAyaqOSJ3ycvDWiIXGz3ZLH6NpInJnNo4MHglRaS8VpMePxl3vi7NczTaeTk8U4jfqJMdoljy4N/FzYXbngogg9nkrkmys+9o7ozPlG+NIGDrY4eZwO45x3Cuapik5FmMett1cXcqb2xYZrim61PQZ6IGAHt2X5KHKsI3DmXf4yoYSrpQm0IZbjVK2MVfWpYZV9gsPBrpU6yX8HdhmTUdSGc/ZZTtf0WG1D4iCygmcOn6RIRU0pPonCB1kqc1l/CzkNOKF0cDUAvrL5nezlVQNdvJBkYDAcmVxpJabFJBZsjaRM8n73vCtbY6FyyUDMSejBv2etu90AkVYjWkg8ZTM0r6kesTFtlS7EY5hXvDVp7HMmZv/OuntdDadgJaQ3NF0ecChaWTT51RAFHNcdb+5tNuXcgU56T+lexSEHqAjpPLVGCKEutZHpp3wgS9fPbvPcZQj6AJkC/+AcVhg2oMB9tFdruYLcElCTEcduj5KnOKd4aXehWdps2gNaYchKXzH4XwwB+FI0DDtUWTdlyBfoBw9zyLjmWMAU4IW/DbAUrwK9c+GnsCsodlnk/tx29ExH3EreU6p1FuGF1z3/hs8YitqUlHmRdRDePcNp/jxf5ZRXjy2kCPd66CK10OpVNdZGEsdSOpyjuCkRbhHD0sS6gGW5x8fFE2o9JpsVwCB3iOSDZ1jKoH7ty0nyAJYcoLpg2upRKv6pTNrC17fYB9JnIRVCso/9YNWsjd0DvGzneCUVqgIEX/wSsgJzNPnu5Tmzw9dMdHTlBo3skxe0UAR98iyiceNt
 LA9NCbgF
 OCLDFSjQHn3dYgb4S5R2U1lgHtBcwzwSAPD0q3VgdtQbRhhIzcUNTY6YlEvxWE1oYCR0bH0TejUtteiYYCo+Fq2SOfYgsohSQLE3OChVz46HDtA9QUAW+ewWcSxNs3AWyHBs2n/AdoEtr/FgF9jjKNOHGx6PlpathEuGNvU8DBGBQnNsPliRyHxXzsfQOjTAGfI0iWU3yzgYdM3XFYHyUqPAO35RFI9juQT7Qns8ofNefRusfNltaifwEFuQgQA2GSp/Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-04-21 at 20:24 +0100, Matthew Wilcox wrote:
> On Tue, Apr 21, 2026 at 08:01:58PM +0200, Manuel Ebner wrote:
> > +++ b/Documentation/core-api/memory-allocation.rst
> > @@ -135,7 +135,7 @@ Selecting memory allocator
> > =C2=A0The most straightforward way to allocate memory is to use a funct=
ion
> > =C2=A0from the kmalloc() family. And, to be on the safe side it's best =
to use
> > =C2=A0routines that set memory to zero, like kzalloc(). If you need to
> > -allocate memory for an array, there are kmalloc_array() and kcalloc()
> > +allocate memory for an array, there are kmalloc_objs() and kzalloc_obj=
s()
> > =C2=A0helpers. The helpers struct_size(), array_size() and array3_size(=
) can
> > =C2=A0be used to safely calculate object sizes without overflowing.
>=20
> This seems to have been done without any thought.=C2=A0 kmalloc_array() s=
till
> exists and has over 500 callers.=C2=A0 It should not be de-documented.

you are right

> > @@ -151,7 +151,7 @@ sizes, the alignment is guaranteed to be at least t=
he
> > largest power-of-two
> > =C2=A0divisor of the size.
> > =C2=A0
> > =C2=A0Chunks allocated with kmalloc() can be resized with krealloc(). S=
imilarly
> > -to kmalloc_array(): a helper for resizing arrays is provided in the fo=
rm of
> > +to kmalloc_objs(): a helper for resizing arrays is provided in the for=
m of
> > =C2=A0krealloc_array().
>=20
> Think about why this is wrong too.

i see now.

> And you should have cc'd linux-mm on this.

will add in [v3]

thanks,

manuel


