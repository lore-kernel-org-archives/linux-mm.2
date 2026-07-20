Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B98C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 08:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72DC6B0088; Mon, 20 Jul 2026 04:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23886B008A; Mon, 20 Jul 2026 04:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39336B008C; Mon, 20 Jul 2026 04:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9995A6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:38:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 227791A0796
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:38:56 +0000 (UTC)
X-FDA: 85008504672.03.8EE5177
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf26.hostedemail.com (Postfix) with ESMTP id EAE77140005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:38:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=T17qGW7h;
	spf=pass (imf26.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784536734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnD+41BeIxwW5o6SrXr7fbssSBi01iDhewk5InRfPfg=;
	b=fP98i7jVh1KNqWyL5ExUaL9W8gs9PHcoTNIGkkZeh0ldzmJx7VtVYWefT+NLDSkKfdLBA9
	uf0nS0Fnv6cxYFH6cIoTZlVpwNTQfBH9IniP7+Ifr70gREzNmRlC8RpD2E00iwDnFRHDY3
	u1KLmxXRqzil7rk7DyQIjk/1F6hoksc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=T17qGW7h;
	spf=pass (imf26.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784536734;
	b=oRuNl0w6ypFYXxD/LySlLGi2LE3UdS6ZF1kwAk0EuQP1H30aX38PSjCpSHogMOk9b8sClW
	g+DNppmHP7I3Vrx1rKfNowkHaB/0Rq3JHd9NoQa5vUj5k4S2uSLU2g4wqg3LW/AD+aD0lz
	e6auAiW3Nbu9W+fZfhUDe2ixLeQPO7I=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4h3Yp20yWNz8tWm;
	Mon, 20 Jul 2026 10:38:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784536730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wnD+41BeIxwW5o6SrXr7fbssSBi01iDhewk5InRfPfg=;
	b=T17qGW7hxfL9g8xYwtqNZHLJMoyio4CXsAGd0/i9NA0ab8ZBUfCivdDvqt+VD7ndJ8nOoj
	7v26RWMJJOecOAuibowY2PLp3nT3Y7i26klnBP0ELh9UQ6iN81xNI8R2MZC8byj9goEqdR
	sosQgrLXbf0XZMM5XkqpBD0A7ARun5DBH/Psw8irhWPFgLcNSQQJcsep1n+XavuJzYOakq
	8PFusdPCpzbLEPaREswz3UIS+8UkR4XeGJFMyY5f1t+R9sir+QTgvh9JmWxEAv684Z8wM4
	adcqSP89VdAMfA7TGAjU9g6OoNf/uDYYlngOZDODuICTURCsFRmKwVf0dZzg5A==
Message-ID: <0ef30a524e15530c6fc0842066367b1f86e679f2.camel@mailbox.org>
Subject: Re: [PATCH v3 3/3] Documentation: deprecated.rst: kmalloc-family:
 mark argument as optional
From: Manuel Ebner <manuelebner@mailbox.org>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, 	linux-doc@vger.kernel.org, Kees Cook
 <kees@kernel.org>, 	linux-kernel@vger.kernel.org
Cc: workflows@vger.kernel.org, linux-mm@kvack.org, Geert Uytterhoeven
	 <geert@linux-m68k.org>, Janitors <kernel-janitors@vger.kernel.org>
Date: Mon, 20 Jul 2026 10:38:45 +0200
In-Reply-To: <871pg0ras8.fsf@trenco.lwn.net>
References: <20260424174743.257951-2-manuelebner@mailbox.org>
	 <20260424175740.258522-2-manuelebner@mailbox.org>
	 <871pg0ras8.fsf@trenco.lwn.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MBO-RS-ID: b7ec4e02521ad7167bb
X-MBO-RS-META: y6rid3cwbcupdui55iwp64d4x5gtorkb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EAE77140005
X-Stat-Signature: 34sbcpxdoyxc33bi3pwg877b5k1oco7h
X-HE-Tag: 1784536733-32818
X-HE-Meta: U2FsdGVkX19JpIixSaFFDfD2PJ0QwVetOBy3nNjeUwFRJXWgodWs6FfbYlGfP5iZMFDfWP6ATNw7LQFFJ/Tqx+0eZaoORAdXhdrCyou4mtImpOoiJvkWTx44rx5ZRyXkwo8KzOp9/r5yMd3ZLFlP0IpSIcacV5YtWsxQmjhqihUBX9cwLPzr8ZFVAsIg2ZRzYzo94g3NvuPPV6nndkEkWMwsIZbzqJkBbDH6hIb0tGj4nIv1RuLRJEiTCzL90igGKTaVl8c0XbLF6603O7dmS+auE+Yy4Fv6xMCiLNHpotcwEMZx99ZPH5RJGtCJGbbUR0+CjES3kDPy4PnQrMDupNtR5xTHw+/K2HRqJZk+9el4folj5p/e7CQmkxitazI9vOf+8JZWVTnTAL/S5qPSfXCQhHzDqu6COacFV9y4f4d5f7XxLN3l5qrqZE3EX3+77y4DDqVMs6t7pb4McaogLBlfMzX/UXHVIOUOSgokYoVymjDp7JLW1WpNURAU4sLjqvpQhtDQ8394m4NYBVQg2i3hws7N4DG55MTVweAn1jdUry7Y2AzthYvXR2929ngEKiw3s/NrdspSm0a2tfRt0+FqvcnSKUVbon0WSY6EU1Oip0kXwDnLvqeGbM/GKUz+lQBpZNbSOy399byxhPttYvT7GGUIi0rCOLtzWGoEY0f/M/+muab1l64C/tabGI4qSB86CuFI7qw23pGLJOSV2cYhC6jVejpWRK6zP+PETyJ4iC1+Uq2PU8B9wmK4piNDJd/CEoZ0migHctSeZTAbyDPUJZq1/4HQB5Q0KbhhpeR1NFI+9QOcEd/q/rzPwXXQo5K9BK2u2KB6NnbvrJf00DhmImR7psbbJ4C1MCPnmZQxemdVjZpa/9KAVlOFj7XLjiXnrrcsOI0hEq3RK0Pvaq708xJp/21Qnbkhi9ykn8B1pz2QEjGPXJFVNFT4zKzLkr9tKXky1WBzjnJ041v
 FmBLYXop
 ihS5edUjl8QXJnvMY0oFEhlipbz3/5ltaXI+a7SH1ILwdDVavA7YrK9s9jXuSrbWurzw+2FQzXkKKHiWGmylxsrZcsRiDUAE2eceoV1dmCGtIgmPEFvg2RaexZvhzU2jrE+59sv7xYfK7YgLBN923CWdOLanq3GZpYmIUbC8z9oCydnX/HCZmvZCdIs3bKUHGToAkINmyDvZNSv0EWqL6SfEGpTtSGJQEPaMoiJKx57menT2n6A5iHpELug6/ysVFzVLPRnZiQPFuowgpMM8NwtN+HZgGzpUwFrLen6Pwx4tgOI9x8EIE1w06YMyzWJg8YX52XO8ghpXJpVZLsTfGOTlIFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-04-27 at 03:51 -0600, Jonathan Corbet wrote:
> Manuel Ebner <manuelebner@mailbox.org> writes:
>=20
> > put the optional argument (gfp) in square brackets
> > add whitespace for readability
> >=20
> > eg. ptr =3D kmalloc_obj(*ptr, gfp);
> > =C2=A0-> ptr =3D kmalloc_obj(*ptr [, gfp] );
> >=20
> > Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> > ---
> > =C2=A0Documentation/process/deprecated.rst | 12 ++++++------
> > =C2=A01 file changed, 6 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/Documentation/process/deprecated.rst
> > b/Documentation/process/deprecated.rst
> > index fed56864d036..b431993fd08e 100644
> > --- a/Documentation/process/deprecated.rst
> > +++ b/Documentation/process/deprecated.rst
> > @@ -392,12 +392,12 @@ allocations. For example, these open coded assign=
ments::
> > =C2=A0
> > =C2=A0become, respectively::
> > =C2=A0
> > -	ptr =3D kmalloc_obj(*ptr, gfp);
> > -	ptr =3D kzalloc_obj(*ptr, gfp);
> > -	ptr =3D kmalloc_objs(*ptr, count, gfp);
> > -	ptr =3D kzalloc_objs(*ptr, count, gfp);
> > -	ptr =3D kmalloc_flex(*ptr, flex_member, count, gfp);
> > -	__auto_type ptr =3D kmalloc_obj(struct foo, gfp);
> > +	ptr =3D kmalloc_obj(*ptr [, gfp] );
> > +	ptr =3D kzalloc_obj(*ptr [, gfp] );
> > +	ptr =3D kmalloc_objs(*ptr, count [, gfp] );
> > +	ptr =3D kzalloc_objs(*ptr, count [, gfp] );
> > +	ptr =3D kmalloc_flex(*ptr, flex_member, count [, gfp] );
> > +	__auto_type ptr =3D kmalloc_obj(struct foo [, gfp] );
> > =C2=A0
>=20
> Marking the GFP argument as optional is fine, but the documentation
> should surely say what the default is.
>=20
> There are, of course, other kmalloc()-related entries in that file that
> could use an update, but that is a job for another time, I guess.

KTODO: Update the sections suggesting to use th deprecated
kamlloc(_array)() functions.

Thanks
 Manuel

> Thanks,
>=20
> jon

