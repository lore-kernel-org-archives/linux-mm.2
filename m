Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FFD8CD98E6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 05:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B1646B0088; Fri, 19 Jun 2026 01:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462E66B008A; Fri, 19 Jun 2026 01:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379C86B008C; Fri, 19 Jun 2026 01:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9C06B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:50:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 782D41C1F6A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:50:10 +0000 (UTC)
X-FDA: 84895586580.27.9B34F24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C5D0618000C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:50:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b02lh4tx;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781848208;
	b=YBdPLLKwcPOuD8bTludt0t6Ywx6q7ylCXifEiqdfv1HB0FO31AIzrEHWTv7RXo74g8N+WH
	iqVdd9iZAvsJ9kRYbHInbYDiYGBM9+CJqg0JGbQS1VHDyKQ0Qfuz//1aJTJwvnnK/3xObG
	bw9UdtNUZJZ445QX6Jgjfsztb4fGNP0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b02lh4tx;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781848208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PK4QkHJNkYDhZsyMlgt+M7qhWBwrUtJtyeI4+tgyFjI=;
	b=QRhQof+OsbLlXOIQOy/dAksg+9eZC7i2gJMX+g6NcdsW29W7+XNhVHG9s1ddOiSF8w0zTO
	GCdNRca7fnSQovZU0cXx11g7vG2dkAx9oQSlytBPkLabV+nN734VMOdfiJHboO/Iu100WS
	7YLdwsbSWX7baxyELYjLyvZRCKW1EqU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 433B2601E1;
	Fri, 19 Jun 2026 05:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D8C1F000E9;
	Fri, 19 Jun 2026 05:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781848208;
	bh=PK4QkHJNkYDhZsyMlgt+M7qhWBwrUtJtyeI4+tgyFjI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b02lh4txiOrZRGqhBhCWjmCfJcvg1E4LB26nikRWtvQ5cBBaivbqIztiZpdjht9pQ
	 9tVPdb+lUEZh3XXZbfnTYTqJcLAQECJHVtC/il91f1vk6zYB1mN5+zt+o4WdhdK+6k
	 iRZidJZZSEtE5YAwPjBgLI7o2fCxtsqcoCvpNZYmtByMLFhfEgBEGs3Cf9zOzjdpFN
	 GtTGehpcjlxQuAMqLC3sklzTSxJWlIUD9x2jT9BwVf+2nf5Tq2t+rkDp2EGMKBtUM0
	 xKUnvOJN19qQgv9ZlOShILoPH4tWl63ZH0eiPTKYkoGhSZSsKko44wmjOZzRXeEcqa
	 DuqMVSamam+Sw==
Message-ID: <f3804d8e-f615-4e0e-91de-10a97f26643b@kernel.org>
Date: Fri, 19 Jun 2026 14:50:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: deduplicate NUMA policy calculation in
 allocation paths
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260618100913.346636-1-hao.li@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260618100913.346636-1-hao.li@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BO0Wqi200DHIqdBI3vB2CLYp"
X-Stat-Signature: kwktkkiecuiiegg9su3y5zo3rzc5k7gn
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5D0618000C
X-Rspam-User: 
X-HE-Tag: 1781848208-526779
X-HE-Meta: U2FsdGVkX196FEkdJv1afTfZYkV8Hvv1gvka8gUi6HtlzWzOvS7MW4LRojuER9EQ7Txk1YaA1wz1IcR8vkGNburofvdAF7D47p8mVIrxR1JO9+3QqrXCINiQBGO054lRyEeIZKm6hq1x+8QykHp9QHFB9k4tYPqKR8sSqe+i/2KEGF+LzeaVMa19YRt/wi+ibkEt5kBW99Y6j7aO9Qerj7TKoG3bQVjtY0ujnkCy0DbbB7pEsfhPw7UbSVsSWCKi/zcg8ICT3MX41Omf1bvgvgocJPIyztUl5H1sVskoahjmxGeqt7EQUW6RJe1dWbVMSPvmEmkob4cQJDNTT4Pyhk1MfEG68Pifn1qp7hp0lJjct1m/11+zxjZuN/ZQvVEMVAZTyjB781lC/ijhZcrAHaxXxlm+4CLdTVJxZf8OMHYa9Zey95OKZ+7k9evifSmpthSkBKXGOzpWna+Pmr0dtB+c6pBkt/P4MKr9F2LCoTVFC7WB6v5i6kl0CBtppMQRfTwSJ5iIpjC2w/t/OcLEmekeATLtzTwHJdyG3ZfliJPa19axOK6H3NCyD+wwf5LJNP8sA2yK3o3sDlRwY1PhOUZGtEastHcIhn+gbe6ZFQJMvHtqEKFsgMrvHJttGOTB/zuVSHiTtXgJQpMLxoRc3oc35Zss7rsOqxPwCgT1QVlP1vle1Ozo+Q0eGWppCXQO5+gVo///xDrFxAHM+n74K23xLMcXZDKFsCCnc/J0LbbiCAp9cE1seIUCg4Jy9lr6wcq9vhJmTpz9MVo2rCr4VY71WMNFrOnd5VbsiSLJQp1jMP9AAYt1ANxjsoYin5SbavcYh5PBXn0S0wUCOJXE5hBzR6DoNgWyxXjq/aCdx2TisBh+di0oPMTwSDEseCSsy2g1iw7pJijzEkFrApXAZLW+wOFyylarUWIxRVklJTWSaeVb8Ek456o0n3y4AUCnFnQzFgK6gk6tm+lOFI4
 yybEAu92
 u0yAE3DowgXzI5M7v+drYHtzjREFi1aKbvPyQi0qU9gSFsanvC18nt2m3gZZ8tJ8fq+rWdaxAt5nTlVqW9pGJqg1a/8Bo1mGXeKtk33zUF5bXACqM5W1ZskHdri2Dw3n3D6rTP9wjvL2G8FDkXqEay1uvFMUJ1hn53Pkx4lZq51Pup6ue8bn9W/cJFwsJZg/pi+sTmOLZVr0IJ8VqPmQ6zIsX9Q7rU8KQmOnQx89EtNgjbOai1ysOgbBt0X0R5aSXYvoJWYf0oHTczmgxBqRCLITJjV4Z/NDN08yQEoZpcBfv/ZsRB1dm3jgU7nhuDCHIPBbtlB1V2z5FOx3nKF4UNgfqQLmU6nzYgkXC8FJSTXPWUsz6mS7onq2rneKi6CQQc56Pg6g8geAXfaAF3N1+5ISvfSGJOOn1GXBrHKUosLL854RGquZL2nGgufCwe7YoE19uXbI1jpgqBMY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BO0Wqi200DHIqdBI3vB2CLYp
Content-Type: multipart/mixed; boundary="------------YZjfbF37BrzgPLGJHbJ4IY2V";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <f3804d8e-f615-4e0e-91de-10a97f26643b@kernel.org>
Subject: Re: [PATCH] mm/slub: deduplicate NUMA policy calculation in
 allocation paths
References: <20260618100913.346636-1-hao.li@linux.dev>
In-Reply-To: <20260618100913.346636-1-hao.li@linux.dev>

--------------YZjfbF37BrzgPLGJHbJ4IY2V
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/18/26 7:08 PM, Hao Li wrote:
> Currently, alloc_from_pcs() and __slab_alloc_node() both calculate the
> NUMA policy independently. Since they are called consecutively in paths=

> like __kmalloc_nolock_noprof() and slab_alloc_node(), this leads to
> redundant computations.

It uses a static key, so probably just slightly larger code when disabled=
=2E

By inlining both __slab_alloc_node and alloc_from_pcs(), I assume the
compiler would have deduplicated it, but there is a patch in
slab/for-next that makes it not inlined anymore :)

> Introduce a helper function to resolve the NUMA policy once, eliminatin=
g
> the duplicated code and reducing execution overhead.

Nice! I think there's no reason why we shouldn't do this.

> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
>  mm/slub.c | 72 ++++++++++++++++++++++---------------------------------=

>  1 file changed, 29 insertions(+), 43 deletions(-)
>=20
> diff --git a/mm/slub.c b/mm/slub.c
> index 62e9cd46916f..45e9f379b7da 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4523,32 +4523,36 @@ static void *___slab_alloc(struct kmem_cache *s=
, gfp_t gfpflags, int node,
>  	return object;
>  }
> =20
> +static __always_inline int apply_numa_policy(int node)

apply_numa_policy() is bit confusing because we usually don't apply
mempolicy for each object (unless strict_numa is set), but rather when
grabbing new slabs.

perhaps apply_strict_numa[_policy]() will be a better name?


--=20
Cheers,
Harry / Hyeonggon


--------------YZjfbF37BrzgPLGJHbJ4IY2V--

--------------BO0Wqi200DHIqdBI3vB2CLYp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajTYjQAKCRCGXBN6rc5S
1p/CAP4p+mi3CuM7hskUVs7OamecZ034Y/OC7Nx/tkCChWwUqQEA7qDdgsy2xJSq
VbtqJpTJlffPxcUmLPQUxeKmsvl3JwA=
=ATmB
-----END PGP SIGNATURE-----

--------------BO0Wqi200DHIqdBI3vB2CLYp--

