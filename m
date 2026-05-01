Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F02ECD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A547A6B0088; Fri,  1 May 2026 05:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A055C6B008A; Fri,  1 May 2026 05:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A9F6B008C; Fri,  1 May 2026 05:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8126B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:20:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10BB41C0D76
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:20:06 +0000 (UTC)
X-FDA: 84718304412.02.92B2015
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id B4D142000C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:20:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=fS7D8iO5;
	spf=pass (imf13.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777627204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEYgiDjAKezNWVxNMvApZjPS0+ufCBOIBbHBQD3nrlg=;
	b=mpcV8UcfnkJppKPsI7x53uV/5h7YouyoXfj9GUg7Zjy1QzCs6hZIq5HDMk/b1eUKnI9WhT
	iZOnOeJOa8ASTVsZcF5FxToO1GiKEDyG8S9+HQy5GA7JFq4p20TIPkqZUc7lbG2QdDfNSJ
	+pdAZ48DsrIaOsnTG3cVh4edKf6gUME=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=fS7D8iO5;
	spf=pass (imf13.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777627204; a=rsa-sha256;
	cv=none;
	b=2MhG7hr+8ICHgxxY4+BeEqiiucMv5muqljdlKQXVRs0e8iNJacCtI/4/nU3Z/nV0wgU82e
	wiVcfomdQ8sqKtNP6zzGcLqKnMz11NXiGFi8SCLsXnLzQyAmHhBuHB3+m3GPFZK2DMAjfz
	W2SUfxw9+4n5eQskHVNM3C0DLp/laDk=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4g6QVR5415z9tsd;
	Fri,  1 May 2026 11:19:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777627199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hEYgiDjAKezNWVxNMvApZjPS0+ufCBOIBbHBQD3nrlg=;
	b=fS7D8iO5YcqQFd0SM0FgJaDRFkgd1xAPVpaf4zb2GvVLxl7C/IRu86pyG2iL1M9iWwM4qy
	nsalyYEAvE0+zdPm4mW8qd+5UNZe2exR1l5U2YxhLtT3tYuteQvlj/7Q/hTIxVP6r8hXex
	Qfzcykco1GywiG/yb4TlGa0iGn8WokO67oWjYqRYOrdNCs0pp0BYl1uzsyrjIYlOQ35c0L
	90fqbb87TrWH95U0+jV4o2eQRgRtlsZqERGFrjfthbuXu2UTYv4+xV2er+7qfK7namG3tY
	2Ugn2LAHJ63RUo/N04UnLpfOsfdk+7c64+OtOr/F8y7I1RhTGy+VY4uvpR6W1Q==
Message-ID: <26197926621ca847b7b0337139ec7f90dc8a3703.camel@mailbox.org>
Subject: Re: [PATCH v4 3/3] Documentation: deprecated.rst: kmalloc-family:
 mark argument as optional
From: Manuel Ebner <manuelebner@mailbox.org>
To: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  linux-doc@vger.kernel.org, Kees Cook
 <kees@kernel.org>,  linux-kernel@vger.kernel.org,
 workflows@vger.kernel.org, linux-mm@kvack.org,  Geert Uytterhoeven
 <geert@linux-m68k.org>
Date: Fri, 01 May 2026 11:19:55 +0200
In-Reply-To: <20260430010332.114100-1-sj@kernel.org>
References: <20260430010332.114100-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MBO-RS-META: fdgbr8urtrrweww5c9sz6cgypuu6d3g5
X-MBO-RS-ID: 235f6216a464e3d66b8
X-Stat-Signature: pbz3ysdqxo4ayxouxfixpi3onnjxpr5q
X-Rspamd-Queue-Id: B4D142000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777627203-503272
X-HE-Meta: U2FsdGVkX19D6ujyRJuDc6vpYyGq8TVoU20OTHDj30RGE72oMGUTW/rD1iVfCMR7SKUlaefPCsrQ1lwzjzpGkC5U97LSmknXepi59wtqjomsirUcr+NlPsRH/mmD/6S+z51m7MW6ma6KiFOwIHkGOh3PcACZYrN71dc1zkZpFZiutJDBpIAc7tn4bZATW3qeroKmt5DA6uA4p/RncHJge9H1hBPsbL6iut2EAW/0QikTqFL393qa82HQmIxw9FGAi0EFtmsowX4Rycj76ueasscYpXZipNgN3OqeVfSEJ9zgIaMTxPFuu8LzufDc9EnystMG5n3rtAv0Y8x0aZCPUSAAfCxa1bB0WO8jDiluNYQOpEroV8mlJpE5cCBI1JY3537Vj1uvXZxw5iMiI9zZ+X5ShGWO25IszMKT5Iw3K1LOjb2M7rXNjhY+MTYfxdLF1ACEZTYS3rfP66y538SAcoGqAHyD0hfjMFqAmD6x5jh1Y/MxrE8KkfBb8CeJzkDVkamItRYMRBYr2Jfao/WdXW8yFAkbIEOCyUMrGeG4bmG22EBKNmxRWVcO4Jy+v8OCphDVRC5w4mhpQ/X4aiEfVHFABD7xIR8hR8fG39qPelnaM7niZkXMJ72heGZHv7jHGAP1Rmndpze1+bdJ5E3T/n1yver35D76qcPny/JHPCc9pWD7zRCNae/dx2MMxqFjUA+PO8rAfn+uYA6QTtRHbJejAb+sbBlVvWrLP3AVeLp5gR5AShJboT4Muirjr7beDuQa4AM/IYQRTZXnHas0yt22cNvIq2TEIM5JVg0x29kibmRmep7KIPERNTtgSJXMtr8SojKybxRI3B/pu6qBJ6WqlW9CgG5nt5ZaxoiB1ZI5B29RHjm3gfqe8l403aK1UtvuVQg3V+kk3FAeEyCJNZgyVZu8VohQPLUD6yAKYx+u3gXAEhT8Cc7HGo5/6Pa4zA+Mv+B408mBUD6RU8B
 /BnApIly
 VjCtGmi2Zs/k6zlzvGyS8KA28t9KKu1HGrRIE0rmr3tqDZ5rsEVbsslsBpA0MxmxpKMATizxhQX3Ujf/qE7cTIvTdeV7cNr+X61vxpENMnIdMx4gCZNM9C420KmV08QAslryHnHb65fzsa8qNQC5wjHbBKy0D56RP1PC70eGMzmNB1zJcSlAOct1W7wmEgLev6xcXFCzJoIoVsY/2fujdStNagdLDIOi+J4dZQGpevBqxquO2XaJvylJ5ALpICKJ5qLrG5v6FT/sjmIlcR9IgkRMuiGhBGVzzLHu/jL8IeTjHtxnHuQK1GngnO5TE/GBE9SS5Xg/eP0sNp1ecTBaStmwGBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-04-29 at 18:03 -0700, SeongJae Park wrote:
> On Wed, 29 Apr 2026 09:27:04 +0200 Manuel Ebner <manuelebner@mailbox.org>
> wrote:
>=20
> > put the optional argument (gfp) in square brackets
> > add default value =3D GFP_KERNEL
> >=20
> > eg. ptr =3D kmalloc_obj(*ptr, gfp);
> > =C2=A0-> ptr =3D kmalloc_obj(*ptr [, gfp] );
> >=20
> > Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
>=20
> I have a trivial question below, but because it is trivial,
>=20
> Acked-by: SeongJae Park <sj@kernel.org>
>=20
> > ---
> > =C2=A0Documentation/process/deprecated.rst | 15 ++++++++-------
> > =C2=A01 file changed, 8 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/Documentation/process/deprecated.rst
> > b/Documentation/process/deprecated.rst
> > index fed56864d036..ac75b7ecac47 100644
> > --- a/Documentation/process/deprecated.rst
> > +++ b/Documentation/process/deprecated.rst
> > @@ -392,13 +392,14 @@ allocations. For example, these open coded
> > assignments::
> > =C2=A0
> > =C2=A0become, respectively::
> > =C2=A0
> > -	ptr =3D kmalloc_obj(*ptr, gfp);
> > -	ptr =3D kzalloc_obj(*ptr, gfp);
> > -	ptr =3D kmalloc_objs(*ptr, count, gfp);
> > -	ptr =3D kzalloc_objs(*ptr, count, gfp);
> > -	ptr =3D kmalloc_flex(*ptr, flex_member, count, gfp);
> > -	__auto_type ptr =3D kmalloc_obj(struct foo, gfp);
> > -
> > +	ptr =3D kmalloc_obj(*ptr [, gfp] );
> > +	ptr =3D kzalloc_obj(*ptr [, gfp] );
> > +	ptr =3D kmalloc_objs(*ptr, count [, gfp] );
> > +	ptr =3D kzalloc_objs(*ptr, count [, gfp] );
> > +	ptr =3D kmalloc_flex(*ptr, flex_member, count [, gfp] );
> > +	__auto_type ptr =3D kmalloc_obj(struct foo [, gfp] );
> > +
> > +The argument gfp is optional, the default value is GFP_KERNEL.
> > =C2=A0If `ptr->flex_member` is annotated with __counted_by(), the alloc=
ation
> > =C2=A0will automatically fail if `count` is larger than the maximum
> > =C2=A0representable value that can be stored in the counter member asso=
ciated
>=20
> Like 'ptr->flex_member' and 'count', why don't you enclose 'gfp' and
> 'GFP_KERNEL' with backticks ('`')?

I didn't know what ` is doing, so didn't consider it. It makes sense to
enclose these two.
should __counted_by() be enclosed aswell?

> Thanks,
> SJ

Thanks
 Manuel
---
The possibility of getting blamed has to be earned.


