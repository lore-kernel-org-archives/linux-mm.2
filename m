Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1617ECD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BA56B0095; Wed, 10 Jun 2026 23:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704E36B0096; Wed, 10 Jun 2026 23:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B686B0098; Wed, 10 Jun 2026 23:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 509F26B0095
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:20:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 124DB8DEED
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:20:04 +0000 (UTC)
X-FDA: 84866177928.03.EB7ADF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 76B73180006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:20:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CaRcdCYL;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781148002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lV1GNdkgro/OqOIjQyGXZb45UgCwfe6cngFGPzUwNKU=;
	b=U3vBnD/+vQcFJb1/oLQqq/h8y+nGWRD7f5LWyOXQkbaGWq1ioDdlUu/1xkt9nNVO8dVRFm
	DzjP3pobde07jR8dALwlt8dl9wcjXtqanTeqIeMX2wG4NV2cYtWcS8IkTEA+cXZUBOWgPI
	+2t/C5UhI4owVXpUeFmceORavDEl4Ik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781148002;
	b=6BbK4D5ZSsOCm7ecy/d00yze9o63k+cidfk0QLWqJzgI541fOEM5HJ2vRaXRanGrPExK+y
	gG/lnWCLvjRdUYmvUXqlEIcVaBk+Y3EX19z9a551YdApGUTBUpautXCag19fn0QgTC7QSL
	hp4fh1yXoYDxr6qlMV+0eyhME0TYhqg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CaRcdCYL;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A0AD60208;
	Thu, 11 Jun 2026 03:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4601F00893;
	Thu, 11 Jun 2026 03:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781148001;
	bh=lV1GNdkgro/OqOIjQyGXZb45UgCwfe6cngFGPzUwNKU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CaRcdCYLdFBMG2U0OECS83QNk048Ism+paiOtvsAKH++R3QsX0t6aHJx5kzKDDAY5
	 Jd/cHpiorQfNr2F8d+GBgsA4fw7EFZUEhAaLgEBKXY+HHK56a0LtZ7uxuTv0eO6WCr
	 sUFd9YiN00yIdieybG1oRiOSP9OYYquwMrxpHKYI1XlywKjROHnXtTB2+B6X1DVirQ
	 0phrB9TVcE+LS/Kn7EpIgxgJr3pmMrC5lr14XFwXaT1xdTyr98VMxlGDr2cV3mQKuq
	 6gWZND2hRwBZqLiLdSJx3g46wqJmIW65bUGbxSTKLWMXPV428arsMxnmlvwYXISs4s
	 bbizqDHPU8LMw==
Message-ID: <b6530e92-d648-4028-9e77-0df8c3ab166d@kernel.org>
Date: Thu, 11 Jun 2026 12:19:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/16] mm/slab: do not init any kfence objects on
 allocation
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------NNY604SA5UiiZSV2yXEUe0od"
X-Rspamd-Queue-Id: 76B73180006
X-Rspam-User: 
X-Stat-Signature: kj8g5hymzdchj1sg4n5ch8i9sm95w45d
X-Rspamd-Server: rspam08
X-HE-Tag: 1781148002-18997
X-HE-Meta: U2FsdGVkX19KF/bKC2021YUbee8Yd4RajZg0hxftvluTJUMpR1IzOxySLDi7rPuXUVP0eRPMNLgZcLYx4f5g9rE/VOKliCWJi1c069/J9Tbipn9vhsxXANZLTjVozuVGx++bSxjjhC2Z1tM2ZWxktYY9K2SraQ6FWS5YWb0k5FNjvJ0IRPFuqySCKj4MzWg0vG0ful89p8y5ETdzslNuPFRYknIWFuudBWRYInNmMCCJ1qtjKyf5DLriGa8eHCRBpppSUTz02tfB8aKVSgTnf9hLrJCgsho1Esek6NCKoeesF126zGpFBN7NIsDZqAbYAIJJygHdzxiltNkeqqrmrzvDHu4x7TKEp0OY4eyYpnhadkXK8PTB7OQBlX2666jZYQLQck0MNNo9TbG90zG4S4CD0ecLOSSJ/KjUOfF46zkEQcy/ynlgtfzagqJcgydDBS304fT9GM1JC8fpP78W1x6cgdTlErOUc7YBfi6jcTywCfptINbtSCT+XK+iWotCnHFDWohykx/irMYuH8GDa7r+b9o7otesxXVJiG8JjusC2QjrK8IfQDOiXIK44qKYAobOGc+Wv9mJg1IJhOvXP3rLdOm6lfW1hxk5F71Z1SLhcnkIFoT9gyKlV89VflNfI9UWQr0tkdKIjpTVToDIwkgeMVsMtTer4QMPJXTgdfB99B66LQazrUt8XFwjKTE9vq4wr52dmfvJP0YdoBxORgTV1PINB5+ZEtHFAaRj+p9llHC/h4Z1yD/IMp+fErbxOJvaZ7lQYiJrO/3WlMHMnk/v/2LyE5fkOwCZYDTiAfI7i5ajReqWwI6+oTWE/9al5ILqN9Gcef/QCXqZoVx3TyIDS+cqQWnc9GrDSTAakLMSzDDQXnhW5QdQv2vmLl1O44DWq4hw8ei/FRWaZe2Fx569Wc1GhYL5Vat58hcCwULjrPZpZdK1Ngrrg1DSmYK4HwCwr5eWHuhUzkGRhv7
 9QyvkIFx
 MasMK8QO4IynXLgR4F7iNSkNfGvapVl/RihVQoaiEptfF6odlUexY9jqJlddRoqlPF3CGFB/Iy4gWSSJ5JDH4dhMlbdro9rgUPad81AfE7tTZCIOuzMVSZ9OlDiK96VIQ3UxtNAM8mGNrz8logV/Z8y8zdtEwoNsGYPzmvtSFSUh2BOirWe+HPBsu/JOC5h+cq0J+oGgtrxvGbpaypXMCMAVLo4zTmp8p5XWocdIq2fbuR/aaYUvuIb3A409cs0YsyLKWcIGYZuHHUvmJWgyFJDCYOMyo0YKvLJ+99sjkUswnM2E3Dlr4Xhi6CTqXVqLZV5x7k+dAgt1V9pVwTxmhTnVQk4dgvjLiI9uY7mFRJIQlZ080JAiqxFNk8rwZLZMiM50hrppoJmf2pQL3+mCHRqcPKSDaoEY0my1UftqHQISVw9Ev8gfTwlnii94EJEMd+jhluvTdwvl4tzlP81Al4mY4560SujdY7u3J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------NNY604SA5UiiZSV2yXEUe0od
Content-Type: multipart/mixed; boundary="------------1ImZQKiu5FF50fcbIpGt8ndW";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <b6530e92-d648-4028-9e77-0df8c3ab166d@kernel.org>
Subject: Re: [PATCH v2 02/16] mm/slab: do not init any kfence objects on
 allocation
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org>

--------------1ImZQKiu5FF50fcbIpGt8ndW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
> When init (zeroing) on allocation is requested, for kmalloc() we
> generally have to zero the full object size even if a smaller size is
> requested, in order to provide krealloc()'s __GFP_ZERO guarantees.

Oh, today I learned...

> When we end up allocating a kfence object, kfence perfoms the zeroing o=
n
> its own because has its own redzone beyond the requested size. Thus
> slab_post_alloc_hook() has an 'init' parameter which has to be evaluate=
d
> in all callers (via slab_want_init_on_alloc()) and should be false for
> kfence allocations.

TIL again :D

> For kfence allocations in slab_alloc_node() this is achieved by subtly
> skipping over the slab_want_init_on_alloc() call.

Indeed subtle and I didn't realize this.

> Other callers (i.e.
> kmem_cache_alloc_bulk_noprof()) however evaluate it unconditionally eve=
n
> if they do end up with a kfence allocation. This is only subtly not a
> problem, as those are not kmalloc allocations and thus the "requested
> size" equals s->object_size and thus it cannot interfere with kfence's
> redzone.

Right.

> There's just a unnecessary double zeroing (in both kfence and
> slab_post_alloc_hook()), but it's all very fragile and contradicts the
> comment in kfence_guarded_alloc().

Right.

> Remove this subtlety and simplify the code by eliminating the init
> parameter from slab_post_alloc_hook() and make it call
> slab_want_init_on_alloc() itself. Instead add a is_kfence_address()
> check before performing the memset, which will start doing the right
> thing for all callers of slab_post_alloc_hook().

Great, more straightforward!

> This potentially adds overhead of the is_kfence_address() check to
> allocation hotpath, but that one is designed to be as small as possible=
,
> and it's only evaluated if zeroing is about to happen. This means (asid=
e
> from init_on_alloc hardening) only for __GFP_ZERO allocations, and the
> zeroing itself comes with an overhead likely larger than the added
> check.
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/kfence/core.c |  2 +-
>  mm/slub.c        | 23 ++++++++---------------
>  2 files changed, 9 insertions(+), 16 deletions(-)
>=20
> diff --git a/mm/slub.c b/mm/slub.c
> index e2ee8f1aaccf..8e5264d3ddbf 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4565,9 +4565,10 @@ struct kmem_cache *slab_pre_alloc_hook(struct km=
em_cache *s, gfp_t flags)
> =20
>  static __fastpath_inline
>  bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
> -			  gfp_t flags, size_t size, void **p, bool init,
> +			  gfp_t flags, size_t size, void **p,
>  			  unsigned int orig_size)
>  {
> +	bool init =3D slab_want_init_on_alloc(flags, s);
>  	unsigned int zero_size =3D s->object_size;
>  	bool kasan_init =3D init;
>  	size_t i;
> @@ -4608,7 +4609,8 @@ bool slab_post_alloc_hook(struct kmem_cache *s, s=
truct list_lru *lru,
>  	for (i =3D 0; i < size; i++) {
>  		p[i] =3D kasan_slab_alloc(s, p[i], init_flags, kasan_init);
>  		if (p[i] && init && (!kasan_init ||
> -				     !kasan_has_integrated_init()))
> +				     !kasan_has_integrated_init())
> +				 && !is_kfence_address(p[i]))

I hope we could make it bit more verbose and straightforward,
something like:

diff --git a/mm/slub.c b/mm/slub.c
index 5d7ea72ebebd..29cf4590f9d9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4573,7 +4573,6 @@ bool slab_post_alloc_hook(struct kmem_cache *s,
gfp_t flags, size_t size,
 {
 	bool init =3D slab_want_init_on_alloc(flags, s);
 	unsigned int zero_size =3D s->object_size;
-	bool kasan_init =3D init;
 	size_t i;
 	gfp_t init_flags =3D flags & gfp_allowed_mask;

@@ -4591,29 +4590,37 @@ bool slab_post_alloc_hook(struct kmem_cache *s,
gfp_t flags, size_t size,
 	if (slub_debug_orig_size(s))
 		zero_size =3D ac->orig_size;

-	/*
-	 * When slab_debug is enabled, avoid memory initialization integrated
-	 * into KASAN and instead zero out the memory via the memset below with=

-	 * the proper size. Otherwise, KASAN might overwrite SLUB redzones and
-	 * cause false-positive reports. This does not lead to a performance
-	 * penalty on production builds, as slab_debug is not intended to be
-	 * enabled there.
-	 */
-	if (__slub_debug_enabled())
-		kasan_init =3D false;
-
-	/*
-	 * As memory initialization might be integrated into KASAN,
-	 * kasan_slab_alloc and initialization memset must be
-	 * kept together to avoid discrepancies in behavior.
-	 *
-	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.=

-	 */
 	for (i =3D 0; i < size; i++) {
-		p[i] =3D kasan_slab_alloc(s, p[i], init_flags, kasan_init);
-		if (p[i] && init && (!kasan_init ||
-				     !kasan_has_integrated_init())
-				 && !is_kfence_address(p[i]))
+		bool skip_init =3D false;
+
+		if (is_kfence_address(p[i])) {
+			/*
+			 * kfence zeroes the object instead of SLUB to avoid
+			 * overwriting its own redzone, and zeroing of
+			 * s->object_size will corrupt it.
+			 */
+			skip_init =3D true;
+		} else if (__slub_debug_enabled()) {
+			/*
+			 * KASAN never zeroes memory when slab_debug is enabled
+			 * to avoid overwriting SLUB redzones. This does not
+			 * lead to a performance penalty on production builds,
+			 * as slab_debug is not intended to be enabled there.
+			 */
+			skip_init =3D false;
+		} else if (kasan_has_integrated_init()) {
+			/*
+			 * ARM64 can set memory tags and zero the memory using
+			 * a single instruction. Since HW_TAGS KASAN uses that
+			 * while tagging the object, a separate zeroing is
+			 * unnecessary unless slab_debug is enabled.
+			 */
+			skip_init =3D true;
+		}
+
+		p[i] =3D kasan_slab_alloc(s, p[i], init_flags, init && skip_init);
+		/* memset and hooks come after KASAN as p[i] might get tagged */
+		if (p[i] && init && !skip_init)
 			memset(p[i], 0, zero_size);
 		if (alloc_flags_allow_spinning(ac->alloc_flags))
 			kmemleak_alloc_recursive(p[i], s->object_size, 1,


--------------1ImZQKiu5FF50fcbIpGt8ndW--

--------------NNY604SA5UiiZSV2yXEUe0od
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaiopVQAKCRCGXBN6rc5S
1qf1AQCkwBnwoQgxZAsuAP72uiKVtEWTPAPJ6W+HF7tj4lLdOQEA41/pwOc+hFy8
V01e9zirV/n17A0+eoEKzP2MsoFCyww=
=W0ll
-----END PGP SIGNATURE-----

--------------NNY604SA5UiiZSV2yXEUe0od--

