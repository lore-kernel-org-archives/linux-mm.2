Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B70606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 11:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XqZP6eek
Received: by kanga.kvack.org (Postfix)
	id C7DB86B05BB; Sat, 14 Nov 2026 06:07:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54D96B05BC; Sat, 14 Nov 2026 06:07:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92986B05BD; Sat, 14 Nov 2026 06:07:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 990466B05BB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:07:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 251B11C34F9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:07:06 +0000 (UTC)
X-FDA: 85433447652.05.69D89A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B42B1C0007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:07:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XqZP6eek;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794654424;
	b=UxAypCRBhpVqeVNQXzUj0elgKPbvdXBsnrnxoLXSVAOlvKivKAKk/J1t3xE8kDQnJPxlTt
	HR6EPe9ncvnkryxmf6/e2iFMyHfujk1TnPGS4itRE8f9CgXvOUWqJ+EYC5qDnut5lDOfNX
	ubHmQwYTBXsaoIzO0Jx0lpsBgO+wCc0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XqZP6eek;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794654424;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MC8zKvDsyTnvhNHUpHdD+gR3SeL25MWggURQs/EgWIE=;
	b=K7OX6vPxrC6yr8Y+TUCIxJ3zNPwxglHrc7AkxehRY7dxLxaEb2+pN/WXqkNuUL6ad8V2I2
	Fuai9MqjC+wmK4gREGgF7IJbILo0DH6DnPbLzxqDZKOGT4+Cwhv/10iSkGx790RvlxDqm6
	wwGPsPi/9n5MVdt7BadJ9Dei0xqjyUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28D4D60DA2;
	Sat, 14 Nov 2026 11:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD981F000C4;
	Sat, 14 Nov 2026 11:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794654423;
	bh=MC8zKvDsyTnvhNHUpHdD+gR3SeL25MWggURQs/EgWIE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XqZP6eek03pKgCdJN5IkpT77ebGOzP+Mf6jtlKBFZ6u3llrYLpMP2VWL5G5Xgx3+C
	 xeQBrvtxRrPpXDSH1hmErz8xxkjaG2qcQh4RE9E1aDqeShMWCMBTBNqQIBaM4y6Y8q
	 1dQtPQ2GcfxdLcKIqrjOga5UraG9uQVSX74FgG2VUPIh5/Bh9xyGilOy32qqvP8cIE
	 Ntu873atouqG2SNsWGNaPiVItLysXB+UfcZk+aPo5OxgAYk4zYdBD99wa0fNTHFgGG
	 orlNlfjMY+Ct39YtehAH/m2QKeMCwiVth8JJAMyJ2K0YIJ4ESCq5UmcIuJ64ZC0bHp
	 njHPX6cwmS19w==
Message-ID: <sashiko-outbox-214389@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.12.y 3/3] mm/page_alloc: avoid direct reclaim and
 compaction for costly __GFP_NORETRY allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Salvatore Dipietro" <dipiets@amazon.it>
Cc: dipietro.salvatore@gmail.com, "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, linux-mm@kvack.org
In-Reply-To: <20261113110611.2915381-4-dipiets@amazon.it>
References: <20261113110611.2915381-1-dipiets@amazon.it>
 <20261113110611.2915381-4-dipiets@amazon.it>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 11:07:03 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8B42B1C0007
X-Stat-Signature: rwwi8wa7mmu3p33e8q59trdkojkdag8u
X-Rspam-User: 
X-HE-Tag: 1794654424-381219
X-HE-Meta: U2FsdGVkX1+vNGjVWYXYUvtsumAnaCXBX/rsfMIKUUYZPOJ3tPqmEuJDfreSCSIjEyyuSXT8gTa5ta5pgcEXMcdFqNzcfoMO+ZYwIdijJL51jbBK4gv2zhngjguIMZ7s0CfPihe/Q+6kyXN/KNVScNfq+S6Sq2Ly7OeTeq7/VcA9hQXPVWBm96wSjUD7qI3FpYsFyC2Jppu3X3CoWLaiTyRj7kWUEOeeYKXtYgsqsCpYWsrh5gmANxCAA4XtUzw74jmBZfoSLNmOlxbFUEuF68RJznH5/KkNrjN+iVUZDfzB8ctjHPbIK/vIe3m3n5BuXuFH2yzjF5ioI4XTJksghfrAGf3evgG223RdkMNWCRlnSqYwmaxuDz7MF7mzVjMuFpGV8Z5R71DETUlRfV7p4qHQzKiTFESVmrJwamM9YgStOv67/RQFo6q4DOjIw77aJKF7d7E9UKWZoEsabTRaoJz21ox/gf6XulGo2tTfaLPLnBgVcj7uYuK7dZ2ACgwe5yDc968wwk7gbhJaGONkiqjcZArrACPUXcl2qXJ4GKNJrOGnlWcGNvzczta12P9utZ4+mhyd3GLAldfP6c43HEMz7t01Rqni1p+PEQoL9eXy0EBF5qrPW1MwcgYLZZtzW+saZSbNbYhTSTOaQZnlF15/xrzxZCAsqdy3G3R3PhGz1Df0gt5Gz3qJ6BlFxkqJ4zBjPj3D6NhC6Qg96MvpHBnjrGAFpzSPTKP7eUXb0EwzAIQYJHPoKQgSMVK5mhBafFGRTjMuFZOZyrDw7BkLcvAga1Ihnu6f1DaTTrsaz12Gh9PAGupZarVfI00kgyCXMnLz304nr8P3s0kVokyim6OizlrUR24ETuZCZ59UZdy5kfiv5iykYnL6NGs+FzMI1PQyJRgK2XMJczPKJci6FAumou5ACouRsjE6/MuyUFEUMyPVzKcJGaOJADsU/kGH0fpl6olLxbBdU9F67SC
 lyv3+8a2
 Mj0g2gRMbaWHvdinYLD9m69mYoArvkgEPXXNbzEvLI2rlw5HEDEUCbeVQ9ciG+rmYjiQnqNB/Iz1QEJ/VXEL6RM9Xb2gq8kW2kAwt+vg1TuG2NuYPwBL3OOjh45L9u3iGEdRIG92RkU8xcXUHPtMDUu2P6vO+chzE8Nd//6ANPqTIb7tPQMSl1+P3/cog9msc/RdeQGARiZQ6u5KAKvFMhWmFHDzXRxMEIn/GFxcyO1T6vdfdwcfYBjhzd+0Z7K+HiILTf8Mw8ujnaBHxuZGNxR74mWNSxkWNsp+pMtgdSnzDWkWLtOBmzpPOBFna2V6ZZDXRikJEZ1HGLefaUI7HQzpN7AT2wmm4h8aB+ZPRTT4vLxJG+cyyUlbjBfBJLtJP9vSaANJuSMxUSKWzztk31tvqCbCsCDrKEN8UqoifnDN7rVJyrY8U1kJqNTi3wkBzk8NtrZYnskHL8qv6jwui84pFH9nVW5LJmzkuSell7XA0fnjDIAVnGThOPdZAuY59bMzo5mJ4fXdlq3cAq5JRNGqz+r2WIzbwsRlZUfBiLsiZDFhBVbsPYNtboeKcVLUOlKvfNzl+lqDV9u58l89vMrH7yKam5fae5V1fSVct/+djBiVZwJB/5iLEb3AbigC82p6BuRce2KGhoRJMzjVG4jE0q4XInI9plod7nUtoTH9pIxV6KGsrY9RqtEChOEoMqKFFwReXjVNR0aY=
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
- [Medium] mm: __alloc_pages_slowpath() breaks THP/mTHP defrag=3Dalways
  and leaves dead code
--

commit 1bb1bbad99e28f7629c28b25e5ea8f978d0cf1c0
Author: Salvatore Dipietro <dipiets@amazon.it>

mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY=
 allocations

This commit clears __GFP_DIRECT_RECLAIM at the start of
__alloc_pages_slowpath() for costly-order __GFP_NORETRY allocations that
do not specify __GFP_THISNODE.

Link: https://lore.kernel.org/20261001082152.2879289-1-dipiets@amazon.it
Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T=
/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.=
it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/=
T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.i=
t/T/#u [v4]
Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.i=
t/T/#u [v5]

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 44578e149a54d..75e67f7ff4b06 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4288,7 +4288,7 @@ static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
>  {
> -	bool can_direct_reclaim =3D gfp_mask & __GFP_DIRECT_RECLAIM;
> +	bool can_direct_reclaim;
>  	bool can_compact =3D gfp_compaction_allowed(gfp_mask);
>  	bool nofail =3D gfp_mask & __GFP_NOFAIL;
>  	const bool costly_order =3D order > PAGE_ALLOC_COSTLY_ORDER;
> @@ -4303,6 +4303,16 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned in=
t order,
>  	unsigned int zonelist_iter_cookie;
>  	int reserve_flags;
> =20
> +	/*
> +	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
> +	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
> +	 */
> +	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
> +	    !(gfp_mask & __GFP_THISNODE))
> +		gfp_mask &=3D ~__GFP_DIRECT_RECLAIM;
> +
> +	can_direct_reclaim =3D gfp_mask & __GFP_DIRECT_RECLAIM;

[Severity: Medium]
Does clearing __GFP_DIRECT_RECLAIM here disable direct compaction and
reclaim for THP and costly mTHP allocations when transparent_hugepage/defrag
is set to "always"?

For non-madvised VMAs under defrag=3Dalways, vma_thp_gfp_mask() returns
GFP_TRANSHUGE | __GFP_NORETRY (which includes __GFP_DIRECT_RECLAIM, omits
__GFP_KSWAPD_RECLAIM, and does not set __GFP_THISNODE):

mm/huge_memory.c:vma_thp_gfp_mask() {
	...
	/* Always do synchronous compaction */
	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepag=
e_flags))
		return GFP_TRANSHUGE | (vma_madvised ? 0 : __GFP_NORETRY);
	...
}

In alloc_pages_mpol_noprof(), __GFP_THISNODE is only added for the first
local-node attempt at order =3D=3D HPAGE_PMD_ORDER.  When that local attempt
fails and falls through to __alloc_pages_noprof() across all nodes, or when
alloc_anon_folio(), alloc_swap_folio(), or shmem_alloc_and_add_folio()
allocate costly mTHP orders (< HPAGE_PMD_ORDER), __GFP_THISNODE is not set.
Stripping __GFP_DIRECT_RECLAIM causes those allocations to skip direct
compaction, direct reclaim, and kswapd/kcompactd wakeups.

This also leaves the post-compaction fallback in __alloc_pages_slowpath()
unreachable, because reaching the costly_order && (gfp_mask & __GFP_NORETRY)
block inside if (can_direct_reclaim && can_compact && ...) now guarantees
that gfp_mask & __GFP_THISNODE is set:

mm/page_alloc.c:__alloc_pages_slowpath() {
		...
		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
			if (compact_result =3D=3D COMPACT_SKIPPED ||
			    compact_result =3D=3D COMPACT_DEFERRED)
				goto nopage;
			...
			if (gfp_mask & __GFP_THISNODE)
				goto nopage;

			compact_priority =3D INIT_COMPACT_PRIORITY;
		}
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113110611.2915=
381-1-dipiets@amazon.it?part=3D3

