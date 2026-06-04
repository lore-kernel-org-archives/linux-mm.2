Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7847ACD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 05:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8BBA6B0088; Thu,  4 Jun 2026 01:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15716B008A; Thu,  4 Jun 2026 01:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03DD6B008C; Thu,  4 Jun 2026 01:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A97D6B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:46:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 492381C1B99
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:46:42 +0000 (UTC)
X-FDA: 84841145844.05.84E01F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 902104000E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:46:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmQAR+EA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780552000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3QgRkPokzKxJvWdmi5M8w57vRhF+d7yuw6VZVwG06A=;
	b=HvXhB4szhAmhlVVYeDWwr2xThMwPXbJDpb8Us8TQCCelA5XdMIYeJC6/Gps/7YVfiatHPw
	q/F8+4d8NUmpqrnale7lkmyGR9AyPmDDV58hAa9Ybb0HIT2E+Uwj9eQxrat/st/D/gbU1x
	Gmf31nkeHYsun1tJMIsXN1euKOcxG2c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmQAR+EA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780552000;
	b=w/9fAIT/gL5IKwmYM/wF6wF/+omMrHqwuh1eXeEm6KAACr+EsTXXk2Tho8pnmWCqi3eJty
	bxoczX1NcKAaT/lS9KPkUYfxaoMU5tHs+Zgl3gXQC9WtUndSpFZSN204lmARoMbr0z44cr
	/HxyEbOVSTebOqbVfwt3BcQIt50eJz0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83B4A43DBA;
	Thu,  4 Jun 2026 05:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0973E1F00893;
	Thu,  4 Jun 2026 05:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780551999;
	bh=I3QgRkPokzKxJvWdmi5M8w57vRhF+d7yuw6VZVwG06A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cmQAR+EAiirJp/9QBFi/3tiz60puqWAtMXmtq5fRCK4sa1SwpFtaJ9XPHsll3VBBQ
	 spblJV6uPsLZcES3o6LVBZwq9haeqmbGvfqQiYCf0G+F566PQvT9m0RNdPHeDRib3l
	 OBGMukQK7tWC77TAfiL4i738HoUblMDPTDhRW9EIcFPFox/AaqoJh6yfYbo9J3gcF4
	 nbsJ0Uk2M2SqvVLmmlk5UGKhT1rcOf9vYVHCj9aVitLpYtqPJGtJ2ca9m2RnVxOC9/
	 E+wu4KQUJMWZc15RSG0xQDBNo3K8fJHt/oQrwToZ4/oU7zT2YZ+xTEkV6MQi11kKh8
	 PVpcA7SANhHyA==
Message-ID: <07f55792-c83f-433c-bb16-58a5824d1dd7@kernel.org>
Date: Thu, 4 Jun 2026 14:46:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: preserve original size in _kmalloc_nolock_noprof
 retry path
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ZZJvR020eA0i0ukYK75K7ntc"
X-Rspamd-Queue-Id: 902104000E
X-Rspam-User: 
X-Stat-Signature: pmuy8if4rjhjhkncdfmwkxqx1ih5t69h
X-Rspamd-Server: rspam09
X-HE-Tag: 1780552000-181869
X-HE-Meta: U2FsdGVkX18bGftHlSRdnIzIASAGo3uroyEMUxZvsUmL/HtUZZckZ2Hyj2IAhQlCErxxOYXsS0JrJ37trlvQCaiWHJram4PHWWvXhomXKEjYTycKP3L4Rj889bIO7dz5l4oia7MQQa2bMGs8OvEj+21g4LeOd5WsLWrPP3N73cRmisc/mx6mZj6ukIFCdXYwV6NPbRr/rbD492SGgPJLteVYO+uqCD/JdCwLMleqSkKY3H7JZE1o69BaAwEUTRC+pHVKH1w9rcTwLxujHYpzA6+aBm6RxUzYWOYuVukFJTLOrYGVrna3F5TKaeC4snhU0vYNqfFYg3yqw0d6vVJj4XoeX3HkCm/38eKeq0u6ekx9TFWvWLvaEN4mpiNWYbIluF3xXuReeKGHC6B3yw453PWp+TQCql4nwSBW8iwymaIWk8u0KwfQCFamYrSSjqFIMObqOFHlZXSKnciPEnYbIbB9iPyYnQawmnqBme5VfiYbpUv++0QBwlDaDlMVd9eRMcn2dSbKIFq2zT8b/+gdiN7XgrU8JePdXuh/w5IZtK9A4dVLeQ4XovOicIaJOxwmBwlpXHlZWKOQXTiljpIN1ySRZfTPq3new9Vp0OPk80INZHTU9XkKmxL7rzc6n89fgVpPfWyLD6GlFoNV92i0r7mI18uwp05dcFNqJkAwKNc8LLjImeeNcsXhgoUQkKnVMpNrS/DBakHoLv5c8buNFz/KKwYz9H5cY/uh3RgQFBLORgAoxpTNvBnPXTrLDUOSe9DmgK7DroMSTcga02cWN1pxjIVr2XNzEz6Phsn8wg+jEXez9T1uo9VntyMFm/nTrywZKoaakJpeFOtKNjICCGgsCNy5M5p5uHjv4SAgE/eFJhUaTEc33fNJTQzg3rm20BEzSwH/xyAdZJgWfbDMMVTZcd1TLEj5w4F3Wkx5zcJk1lieonC+k6+TKSJcn9m33PVeQamUKwxo/Mbv/Wb
 I6OgwN3B
 WS7GenaZVrHymBcTXn/FdHZ3iWG/9dmGJo1qMA1RBdU7faUfcb49pYfUfeq+seK5Z44NW+z3rwxt8Wxq8M5puCjAPfJcnBRbutdyPz09DWR8kQtbYDrcsRtzqZGbyXXWeenVhJsytJG/fZ66RbPc3sgC3WnR8z0rVVolBxb3qg1l5yet9Uq349g7zkKgUos2U2V5+qCRpUVT8yGeSp89PSTRW9IzPDZjuf54SV8mbNGW0An6WrkjpogpmFKW7VemOxFgGlMNH7VtygbRpTU+IeY0s3k1VvNZIW8uvFGP7rzCih+D3z62w67V7KpJ9emJbRyl38Xxq0TULoAcyD7tdMNshPDRn7Hn2IGU1nFkzv1DtYDnVtcqjERKlekEvT2DAef1PFO49nrf/prIUYu5JVlswj+dSn4F3p/3tXdojaEz2DR8NM3+QMBPdnJUL8PAyqf3Karge83ZDgozgSFzCZ405SORbDmek5dnV5qVGbI1xfuS7Qj7rGxP9pXwnl9qXkZsPjSAalGEvWrZPsiODUJ2RwReFmpq+P7gQrOylRUrAT+TDJZfYhYZfGU986u4JgyS5N728GqfNvEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ZZJvR020eA0i0ukYK75K7ntc
Content-Type: multipart/mixed; boundary="------------QBU0MuEE9lWw6oOdiF27OnpM";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
Message-ID: <07f55792-c83f-433c-bb16-58a5824d1dd7@kernel.org>
Subject: Re: [PATCH] mm/slub: preserve original size in _kmalloc_nolock_noprof
 retry path
References: <20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn>
In-Reply-To: <20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn>

--------------QBU0MuEE9lWw6oOdiF27OnpM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/3/26 10:10 PM, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
>=20
> _kmalloc_nolock_noprof() retries from the next kmalloc bucket when the
> initial allocation fails. The retry currently reuses `size` as the
> bucket selector and overwrites it with s->object_size + 1.
>=20
> That value is later passed as the original allocation size to
> __slab_alloc_node(), slab_post_alloc_hook() and kasan_kmalloc(). On a
> successful retry this makes KASAN/slub-debug observe the retry bucket
> selector rather than the caller requested size, potentially widening th=
e
> valid kmalloc range and hiding overflows.

Good catch!

> Keep a separate `bucket_size` for choosing the retry cache and preserve=

> `size`.
>=20
> Fixes: <af92793e52c3> ("slab: Introduce kmalloc_nolock() and kfree_nolo=
ck()")
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---

I want to note that this conflicts with Vlastimil's work-in-progress
feature [1] where it separately stores orig_size in struct
slab_alloc_context which naturally solves the problem.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=3D=
b4/slab_alloc_flags

No strong opinion on whether to queue this patch and then rebase
Vlastimil's work on top, or wait for Vlastimil's work to solve the
problem instead...

>  mm/slub.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/mm/slub.c b/mm/slub.c
> index 67abbbf68fc1..6a2b3ade3611 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5350,6 +5350,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
>  void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp=
_flags, int node)
>  {
>  	gfp_t alloc_gfp =3D __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
> +	size_t bucket_size =3D size;
>  	struct kmem_cache *s;
>  	bool can_retry =3D true;
>  	void *ret;

But in either way, I think it's more straightforward to introduce
orig_size as a variable to keep the original size and pass it to
__slab_alloc_node().

> @@ -5372,9 +5373,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(si=
ze, token), gfp_t gfp_flags, in
>  		return NULL;
>=20
>  retry:
> -	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> +	if (unlikely(bucket_size > KMALLOC_MAX_CACHE_SIZE))
>  		return NULL;
> -	s =3D kmalloc_slab(size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
> +	s =3D kmalloc_slab(bucket_size, NULL, alloc_gfp, PASS_TOKEN_PARAM(tok=
en));
>=20
>  	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>  		/*
> @@ -5408,7 +5409,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(si=
ze, token), gfp_t gfp_flags, in
>  	 */
>  	if (!ret && can_retry) {
>  		/* pick the next kmalloc bucket */
> -		size =3D s->object_size + 1;
> +		bucket_size =3D s->object_size + 1;
>  		/*
>  		 * Another alternative is to
>  		 * if (memcg) alloc_gfp &=3D ~__GFP_ACCOUNT;

--=20
Cheers,
Harry / Hyeonggon


--------------QBU0MuEE9lWw6oOdiF27OnpM--

--------------ZZJvR020eA0i0ukYK75K7ntc
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaiERMwAKCRCGXBN6rc5S
1jRPAP9wDZ921494EYcGs/+HDS6VMmFMMG9OyxCua8hMUG+FlQEArOf1WRiBjRD6
HuTBcbGntszY/MEvv+O4sFbgjbThVA4=
=EksB
-----END PGP SIGNATURE-----

--------------ZZJvR020eA0i0ukYK75K7ntc--

