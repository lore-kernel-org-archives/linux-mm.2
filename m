Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E59CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 21:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB4B6B024D; Fri, 15 Aug 2025 17:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291AC6B024E; Fri, 15 Aug 2025 17:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF0F8E020B; Fri, 15 Aug 2025 17:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2426B024D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:36:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 804C582CC5
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:36:34 +0000 (UTC)
X-FDA: 83780301108.26.0521AB5
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf28.hostedemail.com (Postfix) with ESMTP id EAF60C0015
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:36:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u2A9s5SO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of alx@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755293793; a=rsa-sha256;
	cv=none;
	b=scns+rBEJfg0P//U9SUDr5J7bhR5gLADJfQ3kP3yyE+0j3IYfq6YzwpZk+T3DnxoF05Xpr
	4z5L/3cJGnO/dvLTImT2iezBl9ftWE8cPoYYr6x47Xld3UA3qGsXnM+VvWU5t0G6Fuxqdh
	RQWhakr7LorIVcWssD/7ec/c6ZoUd78=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u2A9s5SO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of alx@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755293793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25g7XkEshAwkxiEj5LWpUU5BHDIP4nucZO7Cv8Q/kLo=;
	b=2n3AdSUdK9CT4hIdUmtofpsUwJ48yxPCLGJ16dnA4G8oc5bQAZ6zWcH/vqqQhu5PTGgtNS
	YIh/a+v17Nvl/7GW1+YxZLLHQZ8oDWC6uC7zWrCuDhnTi6qwPUK01yLWzlBOY/Ii5x07og
	aFevGPJwFQVIPTFhcIRgshn5QlyUs8Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 3ECA1A58331;
	Fri, 15 Aug 2025 21:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7353C4CEF6;
	Fri, 15 Aug 2025 21:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755293791;
	bh=U0tpozaKDQBPba9WDp+NiZ8JiSwtUymVIkmMJFBx268=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u2A9s5SOh0Xn7c07Jk6kYr5WnS+j1MhD4i3MBJJZGBxAu49VawaAquZQHjf8zdZAa
	 6JeYu6Vh1f3A2cXfgupqVE9vQ4VBLkTHNDkKHm1WYKaO8n7sYP4pY/2p0a4jniXuK5
	 vkPjet1vsi/KNFD19x2gI4c/5MMgf1yWvV4ExUsC9j3JCtQtjTLcaBtbHrDatK1509
	 0PZYckymAyG776qQO4xc5xIrGj4ZWyMueO5sSIMvdjTXPFj6sYqu0bVhQN94a88RqO
	 Z/xgem4ozYg3xZbI2O94V5vAeDpQRbqPEje8BRT/KetJuHK3egosh1LnQob3do2LAp
	 LDSjzjtH8EbQw==
Date: Fri, 15 Aug 2025 23:36:26 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/3] man/man2/mremap.2: describe previously
 undocumented shrink behaviour
Message-ID: <uvh2e2jjdk44tdwrhmnd46atwgdzwwmny4kczxqv2vm33gjqpp@63lsupn6y2u6>
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
 <ab2264d8c29d103d400c028f0417cada002ffc11.1754924278.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="buoh4y3nl2ltwkym"
Content-Disposition: inline
In-Reply-To: <ab2264d8c29d103d400c028f0417cada002ffc11.1754924278.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EAF60C0015
X-Stat-Signature: qqrkunfqujkuz9edpr1cswby9a7uhx7k
X-HE-Tag: 1755293792-57229
X-HE-Meta: U2FsdGVkX1/VV9PWVuKt/3t/lwxVLC7UwtOgSc/eGTBw0o1MD/XxveJ9DndSDJPRVtWu2pF6k+OxdMi5xmS8OU+ffM16tALB2sJA+6otmxXELdUOCuoWvrhOOgGsKnF1H6Kg0Nm97AVC4Mx3VywJk677RShO9GZddJDL/9ux7Ka1dIvzNFp2rgUqcnni4USklfHA4hUq1sGkRgXpFfaU7rj+wZBcFEj6hZC2cpf8AIx39llqkgl/kknCGKUL1FD9fYgWvtuzVC0t3GXsUb7BrYcfjvzk1IhTxQPhJupiUnzZfL7bzYMuYFoWQIiZsYnOXD3rjwOa55NlHVmzNQRJoPrvqe2i8CFF9jcz9DBEY40UDQ68HCmCMJc7jUipiqujo8xDkqPSs9Oi0oEt767eq1BRXNakPR/Wgy3QmzlUEosWZoyh45BLKmn5NbEBWNmypvGQvCAcx9NHW2FvFESolXiMx7ym57alNZJRU+3zcMjrFRyihZA7oGzOaB0suCvARa8XVbmLwPYYKcLLRYecDZpckn/JvqXxqWINKmnBolsG8NsdAZSUa2umtNg+0gVzNuRNn8rcsjvBF+d+rCqYCZPw8EmhwvbeObOsDpVey4F7jQ3YmMlKLi7FFNCBBOKtDqZZmCk1QYDzsky6UvM1X65kWilT7PlWdNCZC1c1NX7GW8u4Dik2BRMi9pRZ4y9cO6OIAz23OQZW8DzfPks9Nh6GosN8lmIZCnadL05xFcI5u86PQrBD2P6YS8KC0Z94h/6CcSgU6k3L9pawN3fiqLpdtIq7BaEzabDygMYg+6kQOUSDAJH2nL0jaiLaVpfBrpQxLmwfvQmmJcaXqwuNCcM7KZImTQxaQtaLbpgS5OXwS0Kv365LtduwsyS59dPNWVYfdrE3njqf1QEaVE1DE7WDSrzHCTqMJFNhnDCBPvkDCZLEsOajrIPgasWkOMsDMiIFukFRlzyCSYe0Np8
 g7LZiA2C
 7cAeZ6FwhUANFiBxGGhVgoCuAC19YWVmOUMGPR8Krp4qSM1V9TzbXjgBSsFd//37m1N27unqH43gccJ7VqY0t1k4mbd3lKj0zS43wIj9ZqLiOJGTZQ+HWLP9WNvkdJu5igxnzhWixCMeNPXZFrxmI1l6Gg/4kmdzD15lLD3DVCgWw3pzIIuKDyn25J+xzlEeFM+l/gNV/milV11wbraQt5FkhE4noUOCJb5lGXBm/sq3ImjshG3OWEbMrwF0WwcChMlng3A1kGCoRC3Eq7rC0M/EjK7R+vEHwfL/H11P0EWplodWs2qycZWTxRlYTzpI+rdrSh8apgKu7I4mJuPcBn8a/CfDIhWeYsDsIX60aq+iUNG5U5SMZHSHkUTmgi3NZP7vb9AKdS42RxLZVsdpGge3H+5n6kIbmfT8StwnXRzYUEOxu98Cu3spOyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--buoh4y3nl2ltwkym
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/3] man/man2/mremap.2: describe previously
 undocumented shrink behaviour
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
 <ab2264d8c29d103d400c028f0417cada002ffc11.1754924278.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
In-Reply-To: <ab2264d8c29d103d400c028f0417cada002ffc11.1754924278.git.lorenzo.stoakes@oracle.com>

Hi Lorenzo,

On Mon, Aug 11, 2025 at 03:59:39PM +0100, Lorenzo Stoakes wrote:
> There is pre-existing logic that appears to be undocumented for an mremap=
()
> shrink operation, where it turns out that the usual 'input range must span
> a single mapping' requirement no longer applies.
>=20
> In fact, it turns out that the input range specified by [old_address,
> old_address + old_size) may span any number of mappings.
>=20
> If shrinking in-place (that is, neither the MREMAP_FIXED nor
> MREMAP_DONTUNMAP flags are specified), then the new span may also span any
> number of VMAs - [old_address, old_address + new_size).
>=20
> If shrinking and moving, the range specified by [old_address, old_address=
 +
> new_size) must span a single VMA.
>=20
> There must be at least one VMA contained within the [old_address,
> old_address + old_size) range, and old_address must be within the range of
> a VMA.
>=20
> Explicitly document this.
>=20
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  man/man2/mremap.2 | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
>=20
> diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> index 6d14bf627..53d4eda29 100644
> --- a/man/man2/mremap.2
> +++ b/man/man2/mremap.2
> @@ -47,8 +47,35 @@ The
>  .B MREMAP_DONTUNMAP
>  flag may also be specified.
>  .P
> -If the operation is not
> -simply moving mappings,
> +Equally, if the operation performs a shrink,
> +that is if

Missing comma.

> +.I old_size
> +is greater than
> +.IR new_size ,
> +then
> +.I old_size
> +may also span multiple mappings
> +which do not have to be
> +adjacent to one another.

I'm wondering if there's a missing comma or not before 'which'.
The meaning of the sentence would be different.

So, I should ask:

Does old_size > new_size mean that old_size may span multiple mappings
and you're commenting that multiple mappings need not be adjacent?

Or are multiple mappings always allowed and old_size > new_size allows
non-adjacent ones?

I suspect it's the former, right?  Then, it's missing a comma, right?


Other than this, the patch looks good.


Have a lovely night!
Alex

> +If this shrink is performed
> +in-place,
> +that is,
> +neither
> +.BR MREMAP_FIXED ,
> +nor
> +.B MREMAP_DONTUNMAP
> +are specified,
> +.I new_size
> +may also span multiple VMAs.
> +However, if the range is moved,
> +then
> +.I new_size
> +must span only a single mapping.
> +.P
> +If the operation is neither a
> +.B MREMAP_FIXED
> +move
> +nor a shrink,
>  then
>  .I old_size
>  must span only a single mapping.
> --=20
> 2.50.1
>=20

--=20
<https://www.alejandro-colomar.es/>

--buoh4y3nl2ltwkym
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmifqFMACgkQ64mZXMKQ
wqnXURAAmhC7nlLe2VS4LJ2byHc2MqG2Eedkuvp/uWEx1SzqdTojtI/Yl6n6uvQa
JF/vI4VMca73f2g6FjXoW05aSTmVqmSV/ozGgNnzLI42rPSBBNmj4cmCL2ohabYO
Ellsndg1F1QEBscQzpjNcb0SXdjopomMBC1mtBnY8lEYSfqzS0PBOUyLwx3IjAzP
qjUQKmjHb0vrLFywkTwJ1PME48DlSrJV+R87Vpw6B6HVTNjDQGs9UnQEyDYZPnPk
3UtJZpeZJzo8FV0qqfLKfeO7RTWZz3p0abzL0K3mMfJiYExyBeUEKOAHRi8qskrU
4oq+aqPXX0OioXC8Wooro5d2QWCifwAZ+KKPGJ2C9v3z9fmk0xMruZifm8G1YFFr
5BpxVExXZm1f9eyg+M9iVuFEYQ5nnRXx9tLGNNdq2UsoCI20sSmR3TJ1O9tEoVnf
cHd9XaZjwowAWypj4QXmficy8O8daf64h9aTxrWLF90ebzkUuAIZfd8vQ2xSO49t
++GPqZLNRG8qLC8Is3rNwxNksaMo+qoFYM0fyPkMjppcMo0iaNPmp1gC+QSIkVgN
thD36RsVD2U5JidQl756IjZoOgVZrDFxUjT+RMPFYN6j4qrMkUob2V/WdWPVmb3L
yEW9hUpV15jgCzgvJ4rGiNtnaO4+Q7LlSfmDc9YthFgS/Nwi8KU=
=IxjY
-----END PGP SIGNATURE-----

--buoh4y3nl2ltwkym--

