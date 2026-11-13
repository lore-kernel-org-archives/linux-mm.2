Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FFC1606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KoCgLK4q
Received: by kanga.kvack.org (Postfix)
	id 320446B065D; Fri, 13 Nov 2026 05:05:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7EC6B0678; Fri, 13 Nov 2026 05:05:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235206B067B; Fri, 13 Nov 2026 05:05:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 005286B065D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:05:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 214E41C3A8B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:05:12 +0000 (UTC)
X-FDA: 85429662864.24.903784A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7BD2540008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:05:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KoCgLK4q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564310;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ai03mBHmQfa//L0tvpjPqopLuHNb0ED4KuaPu2+u4NU=;
	b=8ft008g3U89ZCeTM8EhHR1yO8pgW+zUIO8w4nrfpKHgfezLLZNLXTvbKnFJ1INIayO7Zke
	cUivDLXCpQb8jopQv3iw8fPaEZlfmAeWpan3B2lFnX9q9jzjCk/xa7dwwmHFKKn8adWHjk
	P0LNBbwFceSztx9y27VjGUmUeXPBe5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564310;
	b=C3L7amGFUcMQxDl4bi6s7sucVhE0wkAy4K24Sq+StPG/jS+Uk+bld/+gUpfOGRuHilIOk4
	9pO0D07TisEO1PI0v0XMesEU1Xj2DHXqqZlu+EFfsByWDQ9B3sCGYG0+Rjk33462rGn636
	TwXhuE9pn6mLOnpoWBvvpkCJ5d8oAGE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KoCgLK4q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0113C625D6;
	Fri, 13 Nov 2026 10:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F271F000C4;
	Fri, 13 Nov 2026 10:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794564309;
	bh=Ai03mBHmQfa//L0tvpjPqopLuHNb0ED4KuaPu2+u4NU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KoCgLK4qZXUPbfKgsIfZQCKqKLtI/8gRqDvPBdYAhiEUZhff5p3b3sJNDj8QhUwzp
	 CFMou9MxOjx2+RU3vvSgdFc+OgZZmBinGxAcpbIHRTU3rn6VKmXku79Rf+0GGjNUB5
	 C4OnW6n7xNTLwo0q3+UeAUHvQyR/LRJxmHYByogAHaPhd2UcLZIUWUZmprl2H4RTna
	 EeD8oyxjs7a19+ocyZ2VX9sKGlEM0rXS4En7FXtuqPCippsp8RLu/HBAw8B0jZaqPI
	 damAUhgrgzEMyRhOvBAv5eAxaUI2Y/YyU6rw/kWTddFqtIyG59bRzsQVBxy2KUELrs
	 TjUH/4PAx01kQ==
Message-ID: <sashiko-outbox-212599@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] slab: allow sheaves for SLAB_NOLEAKTRACE caches
Reply-To: sashiko-reviews@lists.linux.dev
To: "Breno Leitao" <leitao@debian.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kernel-team@meta.com, "Catalin Marinas" <catalin.marinas@arm.com>
In-Reply-To: <20261112-kmemleak_sheaves-v1-1-e40e3d73b253@debian.org>
References: <20261112-kmemleak_sheaves-v1-1-e40e3d73b253@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 10:05:08 +0000
X-Stat-Signature: f45k114heftikagpxc7omgonpp71w6jg
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7BD2540008
X-HE-Tag: 1794564310-98411
X-HE-Meta: U2FsdGVkX1/4C4VJCUMbjK8HnRcATinTzvPGH6sNXa6rIKYQdStSrdc7a4hB7fe5XcRLgCtMgxv29aWrSleIjMFGrduVDTC3q8L/Tj2l7pB8+p43ZmjFG+oRbSrdk3lmvYKA6Prg/EdWDoYdn2PLyezWYsRjF/o4x5ac+cfxvigl+o4Xa5UBmRw7stqZz/5EMfd88LwohFhyCx15Vly0OHwRz9V6tvG5q/xsM5qo2ZnYO5KLqZMcHWTbfUeZZt7UZi1H04IjxWLEqjBAbk22sXkBe5WtG9gg/FdVTYZl6qXQQvQEqh6KBC9p+MUhuLUxD2kRnE6BGXPgZBwjjaPmJrD/36tQ1KFUXvoMYa/DCzSExqarwnf1u7hbtuft357ym70rN311Wpv33VpqoeOYRAG86CTho765VS7rxyFCLx4puQQd9vDuozs50x0vWzEMelzin7KNPEaqzLasLKfbXMOeltE02WsRmbAE5af6sK5mdn0nznI5lXfukd24KqztRtq166vUQ//F6r/Czf0QCY1Hz9bdLUkrZyx4uIjOg7bpywJn+d145aVbcBv2nu2x8eVZWqiAi4rgmR2faUFTefTj5rS9nJALIZKoEwEhH6jhbGHEkYji9cugS9mGvt8jeqqCAV66/hIlGAJCLR2UDUWdqTXYX1O077aqmW5kOLtPUmRnbEKKQ3Stql1aOpfz4gjfU4IDcUAeO89uXx1mKBDPznaxK+Ijsf5n7nhcAPcymV1w6daKqDgK7ocy/dx0shWFBPvgy47dNFNDhBxytrI5qwxHK2PQ41vmjtmRu89U2PgjtHRpMuv7FxhAKxdlDMf+znKT3mJE9iVboZ+H6poA27wEuIkezn71bvlSUl17ewbYnJwoYFAbyvcXk6FAfQ2kxG8otC6J6iSbvRyV4IUVMI1vKavX/S873IeDPEY8ngF8mFddJl81UoCMNtebFtIA3FU+YrwYoIqbpyG
 P6A/kZzq
 Jo34+nzvC4ON0NJxTVS5h1AYvLXo6YTxAfMj570ae2sOdDs4N7pV3T8TlBIRMsTDV0WtlfCf49V6HCq+XGM+kJyPu2R5z8qPSMV0vf7gQx3MsgbpslpfUW0JB2L92xKsWPZ0/Z2cpp8ji0yK0GvnpJAAbLjS/WjemBacJ5f1G+e3Nrodzuk6S/YGjbSl5XA+/IEXR9AIxh1B/ZWxcjfjXrJv2RgEZTjDq4k1NsUfiXwtIbGmARbeWR814MYxOWT7iAPPkPbCtS6jvaSyhxLWUpj9sGa7O3915EnrApbDTGHLbREE1jEdOrCkIOvChC00lx4kaSeylkgNQB8s+1kji1caP5dyexRriK3fOYQgrB9PJBnLoYLAwj43OiOHU+iAALoCdtEisi2OhQPhLiFHtlnL7bYTPOGme0DNIBWQhLuJnnitdZy3EaDGm+Gd6gX/ywWWYUH0bFRQvd6vHXNCL3VtQ3MHPbyY+KLWawDLKWKGrlNK2pzP1ApTKLXjvDY7OkU/cgT00jBeb+Kz6GLTD9lk8/jqEsYWUI+sSWM4hYdFhJKHQMsxCphd6J8YHEYWKXmlG6Z3yHmWgrQCDchEAtY5P1jVK+pFwT6kRhVXfCQGraLty6PT9kcSVeeRTO0tiVkdgbYyIpyAejjlDc27l7D5AI5XbxRzmB63HRlcLgrYpAWeztN39wiR2Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/slub: SLAB_ALLOC_NO_LEAKTRACE leaks into nested sheaf
  allocations
--

commit 7da9d1d54f05d33de4e779dda137bfa95c2a403c
Author: Breno Leitao <leitao@debian.org>

slab: allow sheaves for SLAB_NOLEAKTRACE caches

This commit introduces SLAB_ALLOC_NO_LEAKTRACE so sheaves allocated for
SLAB_NOLEAKTRACE caches skip kmemleak tracking, allowing those caches to
use per-CPU sheaves without recursing into kmemleak.

Link: https://lore.kernel.org/all/aW_NK2NXVgtuzCVH@gmail.com/ [1]

> diff --git a/mm/slub.c b/mm/slub.c
> index 8369853ddca72..f19e20b6f9a4f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2850,6 +2850,13 @@ static struct slab_sheaf *__alloc_empty_sheaf(stru=
ct kmem_cache *s, gfp_t gfp,
>  	if (s->flags & SLAB_KMALLOC)
>  		alloc_flags |=3D SLAB_ALLOC_NO_RECURSE;
> =20
> +	/*
> +	 * kmemleak allocates its metadata from SLAB_NOLEAKTRACE caches, so
> +	 * tracking their sheaves would recurse into kmemleak.
> +	 */
> +	if (s->flags & SLAB_NOLEAKTRACE)
> +		alloc_flags |=3D SLAB_ALLOC_NO_LEAKTRACE;
> +
>  	sheaf_size =3D struct_size(sheaf, objects, capacity);
>  	sheaf =3D kmalloc_flags(sheaf_size, gfp | __GFP_ZERO, alloc_flags, NUMA=
_NO_NODE);

[Severity: Medium]
Does SLAB_ALLOC_NO_LEAKTRACE leak into nested sheaf and slabobj_ext
allocations for the backing normal kmalloc cache?

When s is a SLAB_NOLEAKTRACE cache (such as kmemleak's object_cache),
s->flags & SLAB_KMALLOC is false, so __alloc_empty_sheaf() passes
SLAB_ALLOC_NO_LEAKTRACE to kmalloc_flags() without SLAB_ALLOC_NO_RECURSE.
If the backing normal kmalloc bucket needs a new empty sheaf in
alloc_from_pcs() -> __pcs_replace_empty_main() -> alloc_empty_sheaf(),
that nested sheaf allocation inherits SLAB_ALLOC_NO_LEAKTRACE and is not
registered with kmemleak.

Because kmemleak never scans that untracked normal kmalloc sheaf:
- If the sheaf is later used as pcs->rcu_free in __kfree_rcu_sheaf(),
  kvfree_call_rcu() returns before kmemleak_ignore(ptr) while freeing is
  deferred, so kmemleak_scan() misses pcs->rcu_free->objects[] and reports
  queued objects as false-positive leaks.
- Any tracked kmalloc sheaf linked between two untracked sheaves on
  barn->sheaves_full or barn->sheaves_empty is unreachable during
  kmemleak_scan() and is also reported as a false-positive leak.
- In slab_post_alloc_hook() -> alloc_tagging_slab_alloc_hook() ->
  prepare_slab_obj_exts_hook() -> alloc_slab_obj_exts(), the slabobj_ext
  vector is likewise allocated with SLAB_ALLOC_NO_LEAKTRACE still set,
  skipping kmemleak registration before calling kmemleak_not_leak(vec).

Setting SLAB_ALLOC_NO_RECURSE along with SLAB_ALLOC_NO_LEAKTRACE (or
clearing SLAB_ALLOC_NO_LEAKTRACE before nested allocations) would prevent
the flag from propagating into the normal kmalloc cache's own metadata.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-kmemleak_s=
heaves-v1-1-e40e3d73b253@debian.org?part=3D1

