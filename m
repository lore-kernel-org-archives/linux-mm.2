Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B73D9C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA37E6B0005; Mon, 13 Jul 2026 01:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B539A6B0088; Mon, 13 Jul 2026 01:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A415C6B008A; Mon, 13 Jul 2026 01:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77DFF6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:18:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04DAC91EE1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:18:28 +0000 (UTC)
X-FDA: 84982597938.04.0A5C560
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6703180002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:18:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdXhKMpB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783919907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGwWLHG2HI2aF2mm7hMfqXTCZbUeB2ycMtb8n8Isk/o=;
	b=c0qP22xtnZwhsgmscUHu6p9VMoy+PQzBIhjvgmw+U0O13qkIqmXIqBDWIcNmTtU/tSIXkX
	aS/3txjkEgir2ERjhyoFQ5v13Bac3pBWa5gBvyGmI0kvVqSCER6ErvjdGIEIN5Dx0WZLzp
	dmRlJ90udZ4wuLrJJy1DAIgJps1uSr8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MdXhKMpB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783919907;
	b=RN8f785Vt8Cp6WDf3JuwR1BjKlB9FpBzelnEk7bT9gyaBu3IVQIBmUYGMnICslyafJwtz2
	ip/uCzRJsVXRb0O53vF9r4jyYHNCEEqup82fwWumUraA6aGcpVCVDqa2eQmWAPp9FJ9N+K
	xKAR++KoCSwkcoVXc/JxDxW8RxI7vTs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0CB360018;
	Mon, 13 Jul 2026 05:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF671F000E9;
	Mon, 13 Jul 2026 05:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783919906;
	bh=iGwWLHG2HI2aF2mm7hMfqXTCZbUeB2ycMtb8n8Isk/o=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=MdXhKMpB6K+2Eb6+Lz7bRBVkpv4xk4hmSOACm20LbDSpzGQM97+q/gby+KBwR1S+h
	 YGlPHRSoIzFTGjLkCZH/gXsPaReZYPIkKkT8IjGElIPznL+eMrlpg9RStxCYWBrsPS
	 H9ReDNKC3FsTHur4Wcr8OE5r3cWb4uOPgA3tlInrnwx0ZOrhHrbwu7hjvynhgGxalo
	 gr5jrfqwSDGJD4zMCegr60xpee6PMgZGRr0RV9hdO21VUezkzqMDJOmVGGSWGxVS4k
	 Zhu9WpFUWnysECs6NT3XkMfX1foZTv8LlB1XWviKPU5J11QC28v9xxDpyH1QfQe2tX
	 LqES7WvY6SOoA==
Message-ID: <f2def8bd-4eb8-4e5f-a22f-4061297ddb03@kernel.org>
Date: Mon, 13 Jul 2026 14:18:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
Subject: Re: [RFC PATCH] slab: don't assume alignment on allocators that may
 return ZERO_SIZE_PTR
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20260712120728.96628-1-kmehltretter@gmail.com>
Content-Language: en-US
In-Reply-To: <20260712120728.96628-1-kmehltretter@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------OOPb532Tho3aQ04vlVQWZzyi"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6703180002
X-Stat-Signature: zcyrnuf77uygus6ohrqns7kffuiy1x5w
X-HE-Tag: 1783919907-384860
X-HE-Meta: U2FsdGVkX1/sSS53qrvYWJwxv0j6OWmeQZOWxIa86D0LZYyaNSyvIRwM30f+tLpaU+QHE1jeQPR6H5vtbQaSBC/GWHln94CTIw4KxeyIwUmPnFwN2/060J9dmNKuOZI4Mr68zNd/oSGKP6ftDbh6i34qDEumEgv6rQwwOuTfEWXTGl8b4P2V/2uLztYNfPoXhaRXplaY5mI38Jp5EXyQXxhvt00lQDfD9UKk33aUn/JliYE2+PdnOU1jZlXLL0Fp3ySKUruMb0NRGQZhVFq7BhHLMwePuobApXfnAQcBVP+0M5g75ktkP12U276dP5nhGgoirZ39eosmdM9moyIlXWkBoJg/OnQMamuwlZOsWj4qSfHkahIoj5TGMh7RRfeWBvINB1//dYcWp+bObhr7ncXJXWwzoHH/hk3J5vehGiYOx1QK1QmrMdK5Evwz8YutomM9/L9j8f5GyXuJQnS4ku8Ev2E7nXxNreqmEhplkHB46pTIb2hWMKj3u4Y5Mq5An8evY+z76YUHyOtw79nStQ8mQuRtI5T4lOE1DdgO12U7zJP7lON8MGMKIvQf1r+PQEM+o3YJ/FDtAGePODxKJCLng5t4+BHKRXsY4Vcc32HJaMJu+zogcczZrRtSM1+DTSHhqsq7j40AeXeM0PXip6Gm2O/GP5WrabQMkGm34AFq+AUpyRYetkYDLvP/d4Y9d/6Kxtm4z7MM98lnHKmyp+FQ19P7Z+tF8JFXYcPhNd/kTnm1SFzF6LRoQyH1KYhz+8V0D02Uhas5QyIhTmjzV5PXgb/VpUXubqxbafpncY7Ajnra0wPE8DDWTkbDRI6QsU1T6ooZb4qCqWT6h9vlCiwSq9W6omSDTCQsnXYK6hvQUIQrkEan5uMnEbTGnbLoGrQ+T1mGJAja6R+JSGj0ZvbIY+nQ04W2mk6crOJlP60ihVfkTTfaoLM04qC8dLlSuXrrem6SrtUc7R6moG2
 4yjGkwjE
 gZ5WGXUDnbWXoiBTZXap7jMh1lMtmxNcUJ8yldg/pLZtvUdrhc8w47zatQxVul55JtaPKl3Ts/iBt23HGF5a2gQr95w0+VfpHStV2Fm6Y2LrIG8V2UYWw/VZpKQ10uLhiADcArQ6/VkLOsl/+aWUcFJJXSdmDGSpAUFfQdCqC5H1Vql5Jf58fTuVUhb1Xz8qvW47UzDAFcQfh7j602WmvO1Jy0nIWeLMorUfgLpMJWJbnDvHRIzpJAp0KwVum+5EZgKwU+WfKQ7CnaqcXsa/TOti49/XqWCwHdgZ2kZGg6LyTqtidOPXmUU1FUgVDsFtzWkD0U74OmeheOSuIIShfWAKF3UKL9sNpsszvQUJZiG6zh3jkai9U87M0W+CEr93xG17o8IwKZGirQke9VBdwEcQlBDDfogqwmWa/w/k5tSxoGNzJzddvrjpLrszudWf7TTp7aOZLiuSxDkxn8xi9KUwgFBzBzqSqZ9bTB2BgBA5FTc1MMGVx3Yv2ZU17qtOjTfTdWp75dyHBglXZ9CIXkoNxEAzJ5T42gK3CJY0cHy3t754=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------OOPb532Tho3aQ04vlVQWZzyi
Content-Type: multipart/mixed; boundary="------------sNkF6h0hvJAlWAsgk0NU70Gv";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <f2def8bd-4eb8-4e5f-a22f-4061297ddb03@kernel.org>
Subject: Re: [RFC PATCH] slab: don't assume alignment on allocators that may
 return ZERO_SIZE_PTR
References: <20260712120728.96628-1-kmehltretter@gmail.com>
In-Reply-To: <20260712120728.96628-1-kmehltretter@gmail.com>

--------------sNkF6h0hvJAlWAsgk0NU70Gv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


[+Cc Catalin for ARCH_KMALLOC_MINALIGN bits]

On 7/12/26 9:07 PM, Karl Mehltretter wrote:
> __kmalloc_noprof(), __kmalloc_node_noprof(), and __kmalloc_flags_noprof=
()
> are annotated with __assume_kmalloc_alignment, which expands to
> __assume_aligned(ARCH_KMALLOC_MINALIGN). All three can return
> ZERO_SIZE_PTR, currently (void *)16, for zero-sized requests. When
> ARCH_KMALLOC_MINALIGN exceeds 16, this contradicts the annotation.

Ouch.

> Compilers may use this false assumption to reduce ZERO_OR_NULL_PTR() to=
 a
> NULL check, losing recognition of ZERO_SIZE_PTR. Current GCC and Clang
> retain the existing range check through kmalloc's inline wrapper, so no=

> functional miscompile was reproduced with the current source form. Howe=
ver,
> both eliminate an exact ZERO_SIZE_PTR comparison on the same return val=
ue.
> With Clang, UBSAN also reports the invalid alignment assumption at boot=
=2E
>=20
> Changing ZERO_SIZE_PTR to satisfy the annotation would make its value a=
nd
> the range accepted by ZERO_OR_NULL_PTR() architecture-dependent. Avoid =
that
> semantic change by dropping the annotation from the general kmalloc ent=
ry
> points. Retain it on the cache helpers, which cannot return the sentine=
l.
> Allocation behavior is unchanged.
>=20
> Kernels before v7.2 do not have __kmalloc_flags_noprof().
> Backports to those kernels only need the include/linux/slab.h change.
>=20
> Fixes: 94a58c360a45 ("slab.h: sprinkle __assume_aligned attributes")
> Fixes: f6d50ab29afd ("mm/slab: introduce kmalloc_flags()")
> Cc: <stable@vger.kernel.org> # needs adjustment before v7.2
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>=20
> Notes:
>     This is RFC because the alignment contract can be corrected in thre=
e ways:

I think it's still worth having at least a weaker alignment guarantee
and would like to vote for option 3 (or option 2, if 3 turns out to be
infeasible) unless there's something unexpected that prevents us from
doing that.

>       1. Remove the annotation from entry points that can return ZERO_S=
IZE_PTR
>          (this patch). On armv5 this increases .text by 1120 bytes (0.0=
2%);
>          no measurable change was seen on arm64.
>    =20
>       2. Cap the assumed alignment at 16. This preserves some alignment=

>          information but couples the annotation to the current sentinel=
 value.
>
>       3. Change ZERO_SIZE_PTR to satisfy ARCH_KMALLOC_MINALIGN. This ma=
kes the
>          long-standing sentinel architecture-dependent and either expan=
ds the
>          range accepted by ZERO_OR_NULL_PTR() or requires changing that=
 macro.

Some code (e.g., kmem_dump_obj()) performs (addr < PAGE_SIZE) check
either NULL or ZERO_SIZE_PTR) to see if the address is valid.

Bumping ZERO_SIZE_PTR to something smaller than PAGE_SIZE should still
work: (addr < PAGE_SIZE) check still works, and accessing it still
causes a fault. No arch should have ARCH_KMALLOC_MINALIGN >=3D PAGE_SIZE?=


--=20
Cheers,
Harry / Hyeonggon


>     On armv5, Clang UBSAN reports the invalid alignment assumption duri=
ng boot;
>     the report disappears with this patch.
>    =20
>     Clang 22 and GCC 13 retain ZERO_OR_NULL_PTR()'s existing range chec=
k through
>     _kmalloc_noprof(), so no functional miscompile was reproduced in cu=
rrent
>     code. This is an optimizer limitation, not a guarantee. For a kmall=
oc return
>     value, writing the check as "!p || p =3D=3D ZERO_SIZE_PTR" causes b=
oth compilers
>     to remove the ZERO_SIZE_PTR comparison. Built into an armv5 kernel =
with that
>     form, a zero-size allocation is then no longer recognised and is de=
referenced:
>    =20
>       Unable to handle kernel NULL pointer dereference at virtual addre=
ss 00000010
>       Internal error: Oops: 805 [#1] ARM
>       PC is at __fc_init+0x3c/0x60
>       Kernel panic - not syncing: Attempted to kill init! exitcode=3D0x=
0000000b
>    =20
>     Without the annotation the comparison is retained and the kernel bo=
ots.
>    =20
>     Would the slab maintainers prefer removing the annotation or retain=
ing a
>     weaker, valid alignment guarantee?
>
>  include/linux/slab.h | 12 ++++++++----
>  mm/slab.h            |  3 ++-
>  2 files changed, 10 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 51f03f18c9a7..1c63048f6467 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -632,8 +632,12 @@ static inline unsigned int arch_slab_minalign(void=
)
> =20
>  /*
>   * kmem_cache_alloc and friends return pointers aligned to ARCH_SLAB_M=
INALIGN.
> - * kmalloc and friends return pointers aligned to both ARCH_KMALLOC_MI=
NALIGN
> - * and ARCH_SLAB_MINALIGN, but here we only assume the former alignmen=
t.
> + * Objects allocated by kmalloc and friends are aligned to both
> + * ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN, but here we only assu=
me the
> + * former alignment.
> + *
> + * This guarantee does not apply to ZERO_SIZE_PTR, which is not an all=
ocated
> + * object.
>   */
>  #define __assume_kmalloc_alignment __assume_aligned(ARCH_KMALLOC_MINAL=
IGN)
>  #define __assume_slab_alignment __assume_aligned(ARCH_SLAB_MINALIGN)
> @@ -939,10 +943,10 @@ unsigned int kmem_cache_sheaf_size(struct slab_sh=
eaf *sheaf);
>   */
> =20
>  void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
> -				__assume_kmalloc_alignment __alloc_size(1);
> +				__alloc_size(1);
> =20
>  void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t=
 flags, int node)
> -				__assume_kmalloc_alignment __alloc_size(1);
> +				__alloc_size(1);
> =20
>  void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t flags, size_t=
 size)
>  				__assume_kmalloc_alignment __alloc_size(3);
> diff --git a/mm/slab.h b/mm/slab.h
> index 281a65233795..aea1373c7f83 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -28,9 +28,10 @@ static inline bool alloc_flags_allow_spinning(const =
unsigned int alloc_flags)
>  	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
>  }
> =20
> +/* Can return ZERO_SIZE_PTR, so not tagged __assume_kmalloc_alignment.=
 */
>  void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t fla=
gs,
>  				  unsigned int alloc_flags, int node)
> -				  __assume_kmalloc_alignment __alloc_size(1);
> +				  __alloc_size(1);
> =20
>  static __always_inline __alloc_size(1) void *_kmalloc_flags_noprof(siz=
e_t size,
>  		gfp_t flags, unsigned int alloc_flags, int node, kmalloc_token_t tok=
en)

--------------sNkF6h0hvJAlWAsgk0NU70Gv--

--------------OOPb532Tho3aQ04vlVQWZzyi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalR1GwAKCRCGXBN6rc5S
1sepAQCPSq/Lft9j3v5RFHcjgM5D2FnjBSgJxmunq0Y6hpDAqgD/TgeJtVhYFwt0
vuqShKFRlbK8hVusIQBWqp3nlJdkEQE=
=u9zc
-----END PGP SIGNATURE-----

--------------OOPb532Tho3aQ04vlVQWZzyi--

