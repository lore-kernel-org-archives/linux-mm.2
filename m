Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17629CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 13:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5054B6B008C; Fri, 29 May 2026 09:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B60A6B0092; Fri, 29 May 2026 09:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5876B0095; Fri, 29 May 2026 09:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 268206B008C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:12:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71233140107
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:12:47 +0000 (UTC)
X-FDA: 84820497174.20.23AA4FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C395F80018
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:12:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8LrI91y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780060365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+i+RqYvYtCr0nViJoeYSnknaB2wTTJpaNAY3wveI0w8=;
	b=H8pudoYEqHhxH2SB63BZ7z4EUDuhwy6XPEzHyJV2Rtj8a8xXpnqu5yZJvSyZx/5M3M9BGV
	q/Ck36xSPwT0PDJbwa75VkLrlxIKdycUAy74nh2+I7A1QsbXh0ENyT1y/cOwzpVbOL47Z8
	nbjchltSQF2dL2tFjEJdq6siu/qOIis=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8LrI91y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780060365; a=rsa-sha256;
	cv=none;
	b=2coM2e/93hbu/ZvKWfB4tgLVGy9JUrnLhV2B7gg7PanQhOJFycrNGrG0I2F9n2Z+eN+j2U
	FnalimcerJVLSFcKriRvOJCCaPbGFesTWWarBO5IwywP71p7H0PbaGOLr/KN5cJTRD/pcn
	U3x5yUtkxdaycFmOI08QaVW6IX/knWg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E7D4601DD;
	Fri, 29 May 2026 13:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6161F00898;
	Fri, 29 May 2026 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780060365;
	bh=+i+RqYvYtCr0nViJoeYSnknaB2wTTJpaNAY3wveI0w8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J8LrI91y9HCvLhx9BdGDu5mJARmkY9JK64u2klRrD2aoXgVS527W9WimQ5KOch8ME
	 r1I+UYfU8H8TjfFQpWea0E9R+DOcutmtfskVBPD5Q2U1LE/ESURR+fft7iTDBpvELU
	 ScA+oWEZSbEXRpsUieenmRUzwvaANYb+X54S58lq1/1NvcEzM6POv39j0f/lGI+2VU
	 Od3N11TqCRhmku/0roakbES3nBPbMsq31zubqDwg4sRKC0Wz3min8KCl4wxdZsk1ST
	 8zSKK1FzvtkAtfK8IV0Ic0w4GDHF6u4tA/gGhW4J45YiuXgmrV37ubKci6yjNVu/Zd
	 QZheF+R7Uky/g==
Date: Fri, 29 May 2026 15:12:39 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Hugh Dickins <hughd@google.com>, linux-man@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] man/man2const/F_{ADD,GET}_SEALS.2const: document
 F_SEAL_EXEC
Message-ID: <ahmPrpekhMwD-8fD@devuan>
References: <20260529124047.1483026-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="c6bjqu5mtdxsgyfa"
Content-Disposition: inline
In-Reply-To: <20260529124047.1483026-1-pratyush@kernel.org>
X-Stat-Signature: ozn9xgsin6efu958m11yzfaeqxezjsap
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C395F80018
X-Rspam-User: 
X-HE-Tag: 1780060365-59052
X-HE-Meta: U2FsdGVkX1+tT54fEgAjXLgXhO5UVw4thOSQiVhscYK7woJkmQ41XzOeuKcpiEIWkSlejdBUO+kQ8MNg3sEY6nAeqrh6f10V5Sz3e49+zzfl8wbleVUUC/Bhdy0BN724vlkF2KvAnRxCK9NnBMHTnndxyqduNyG4ATrx+ybGoUsFS1wAvM266FdCKcCvQwX9mo1QbUmR8g2fyWx4R4P2e7FQvC+tm31idEIAKWLthMUmKjgDQuT/Xu1cDBGLzpUCs5TpXIjYCeYtJBzbvyYKCOpt9X7qARS2irKwf/75O1nzEw43mo79iOTSWqOVqVzEmdopUaW4AIjKv0Kmu4678T5TglcrK9pWtPLC3gV/VzJCGxgOlzbwtCz253rvMyaNdWsBT/PCAKqvSXMMMhbkDghhm3IS2cAn4neMo1etAnnza4h2FFEcESB6zpLtkewXM5oJDmXPJ2HY6lM0aqSVSGfSUZeu4EK10+SW3fRmwZ5OjSZVAj+YANBh8GujgxFkvpjHpuyCc+QPF8IrXIdODp8xKiwHwyBSLGvApTg0JmJLsShE2qYlncmR12OFjIzRkybQB4ad7/2yX7aVOZ/4gVNY3oz+RQjVxaCa4P/pdbDD2yK57CuktLzm7DdQLZJhd6xIJ0+uCJ69CBE6kBBvjmJ8+/4v7vuJKh++5U5xg/C5/SJwPqOI+L7IWaaMZxYlpGxX7pi16PvaNMdp5RaaKvWna8Dh9t1+ti/PCm/mJfQkI+eLNtGXhEAT9UCLDjsEWWEdG+TNLM5KhlKErUoWHtVAqgefPIiC2HJipz/n60fcVPhZotpGXeEZflDH60iXgjkJSws/ix7RO5HtJtdzsVTGcpBl1PipOpBAs56RXcsblWh4pPHnzLfkxyjoflcBPg6B8hS0+2hXM5uE3QNo59lYiefaC+cGRsYaFJBiLvRva8zdqOlW+/cqqgGHwirg90fFs1mONLOYhdoMr+P
 ACWMtivO
 ypRP0zCG1qRhO1aZ7cKEdKniUWDd02R9HQTuGhUp+hce2/PsXk7FLA0APIPM7uM7cBiFo9qFzWaC7XTwod4HJUz9lZO7vNQ+Ux0rZarwXBOJX12onJuT5kXmwGzigmzGsybLVoUUAbVV0cB/Ms3w42ZDdJyuyp/HHJfZsvhKkxxEwDT9rj4Tto+svMG5l2EU1PGQ+R0eaJgLfDocjTX5mhe5vQjg7Lq1+V1mjeEPG6R+ICUWNfmp/RT2ueA0CUmyHivkLrxpBHchC4SP1iCs/4RTsq3kQYXhmxkIVOqh9K+Yig1AsfpzDYXKTc8hvB3P+S8OXdMXC77kELAjmyGUPPGRHArpoESugNcEt1M0gq3JQeXOXIilYqJ09dxfC9al3xfUC2u7TgE6kJAQ76Ek1tguUrG3HJwGnrTcd7GWPZ+4pSu/zHvDcj1aM45jXEKi7mGzo6PRgan9IJEC9rBOUDoArK1joAJ+hUe8c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--c6bjqu5mtdxsgyfa
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Hugh Dickins <hughd@google.com>, linux-man@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] man/man2const/F_{ADD,GET}_SEALS.2const: document
 F_SEAL_EXEC
Message-ID: <ahmPrpekhMwD-8fD@devuan>
References: <20260529124047.1483026-1-pratyush@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260529124047.1483026-1-pratyush@kernel.org>

Hi Pratyush,

On 2026-05-29T14:40:44+0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>=20
> F_SEAL_EXEC was added in Linux v6.3. It seals the exec bits of the
> memfd. Document it.
>=20
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>=20
> Notes:
>     I discovered this was missing when working on [0]. I had to look at t=
he
>     code to figure out how it was supposed to behave.
>    =20
>     Disclaimer: I used help from Gemini to write this patch, mainly becau=
se
>     I don't know the man page syntax. If the man-pages project also uses =
the
>     AI-assisted tags as Linux, feel free to add:
>    =20
>     Assisted-by: Gemini:gemini-3.1-pro

	$ head -n13 CONTRIBUTING.d/ai=20
	Name
		AI - artificial intelligence policy

	Description
		It is expressly forbidden to contribute to this project any
		content that has been created or derived with the assistance of
		AI tools.

		This includes AI assistive tools used in the contributing
		process, even if such tools do not directly generate the
		contributed code but are used to derive the contribution.  For
		example, AI linters, AI static analyzers, and AI tools that
		summarize input are forbidden.

If you only used it for formatting, and the text is entirely yours, I
guess you'll be able to write it again from scratch easily (it's not
a lot of text, anyway).

To proceed clean, you should remove the patch entirely, and write it
again from scratch, only looking at surrounding code and other pages,
but not looking at the contaminated patch.

If you have any doubts about the man(7) language, I can help, or even
fix things for you (as long as it's reasonably easy to do so).

Thanks!


Have a lovely day!
Alex

>    =20
>     [0] https://lore.kernel.org/linux-mm/20260505133922.797635-1-pratyush=
@kernel.org/
>=20
>  man/man2const/F_GET_SEALS.2const | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>=20
> diff --git a/man/man2const/F_GET_SEALS.2const b/man/man2const/F_GET_SEALS=
=2E2const
> index 175025c10..2de8009a8 100644
> --- a/man/man2const/F_GET_SEALS.2const
> +++ b/man/man2const/F_GET_SEALS.2const
> @@ -176,6 +176,25 @@ will fail with
>  Using this seal,
>  one process can create a memory buffer that it can continue to modify
>  while sharing that buffer on a "read-only" basis with other processes.
> +.TP
> +.BR F_SEAL_EXEC " (since Linux 6.3)"
> +If this seal is set, the execute bits in the file mode cannot be modifie=
d.
> +Any attempt to modify these bits via
> +.BR chmod (2),
> +.BR fchmod (2),
> +or similar calls will fail with
> +.BR EPERM .
> +This preserves the execute bits as they were at the time of sealing,
> +making the file either permanently executable or permanently unexecutabl=
e.
> +.IP
> +If this seal is applied to a file that is already executable,
> +the kernel also implicitly applies
> +.BR F_SEAL_SHRINK ,
> +.BR F_SEAL_GROW ,
> +.BR F_SEAL_WRITE ,
> +and
> +.BR F_SEAL_FUTURE_WRITE ,
> +preventing any further modifications to the contents of the file.
>  .SH RETURN VALUE
>  .TP
>  .B F_GET_SEALS
>=20
> base-commit: 9db8ca91f920b9aba40ed68de6b8da0ca9dbefaa
> --=20
> 2.54.0.1013.g208068f2d8-goog
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--c6bjqu5mtdxsgyfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmoZkMEACgkQ64mZXMKQ
wqm0IRAApW+pPLwzwVdamgxo3qiTMWDe3AvSFaI3fc55UbJdX+RKHgKCu1DSNtOL
ksUCyrR3iTSwHXGeT3/ez3+kH8rLZuP4UuGjSiVzSBMyjpPemJrcw785COa82y+x
xEtfMavfvgUPkUY80hRciFQBQrqWa1J9Z1LeKY62ALd6JREAvN/Pj1rKAZsd9PBd
6cg9ZMru1omA8rdiSwBrtqNA1IlSOXHa+81NPbp5EoSTG5LyXYfXq7vCqBY5YZi4
TLJSBMmHcRkFaCtcphm8DYfDXpKAQJ6t8FIT62IaIJOW+cHcWD7BM8em8QFHfDV+
CjhwarvLbcjSqNePN56TnF5bVvc6+iR/6YzPcGOPoY2QK2+exgrpyTYSOMgIrbyf
8em4f/M3CcWGNw8oxWkFV4KWwXWFtkPeatz6DUxAa0L4ioMOYcYafJdESczpTWLQ
BkSVCQ1qQ4ha3U+8Xy8ZSi+OIbzTRnre5Uj+mtansu8xsgQ+pt47RmmDC7swgYNA
vYZtJ2LIUCmsQAZKsY+brAz6pf7F64q6Y2LulXzRnj0Nxnt93WoqAqhhIVZ0H5HC
6taB9jrU2dAOSl8McnCx8mmS0AQjtTpL+vju+9b/ky6Cilm8NUV3vSLBPv8hb+h8
IWY+NnvS9luQgibBes7SYwu9fZ7kgQpPpGsPT266fQ3EPfb2OJ0=
=RL1v
-----END PGP SIGNATURE-----

--c6bjqu5mtdxsgyfa--

