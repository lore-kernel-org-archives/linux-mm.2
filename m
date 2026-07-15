Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33660C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 333C96B0099; Wed, 15 Jul 2026 01:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4C86B009B; Wed, 15 Jul 2026 01:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221D16B009D; Wed, 15 Jul 2026 01:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D21166B0099
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:09:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15050A05EA
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:09:04 +0000 (UTC)
X-FDA: 84989831808.27.8FF4051
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5FB7020005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:09:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iunZP1wj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784092142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBTO7kI0cCt+N+gZ2oCWuzRF/4HzC9s9GIhJ0lJULgg=;
	b=n6EkrlUcOwB7g2tiISYUycDmSRYkTn75957GO9PFryQ8bNXECKNN90c9QELxS70OsDGm7O
	kgYjGRM/68KzqOdD/PVYWiGFb5JrkkSykAVCL2wM/LKGlrqc8gYcs9NeW51McTKB3kBhIv
	Do3h0rcaNth7/WSS62Fd++xpXVcF2i0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iunZP1wj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784092142;
	b=zqHIXu6TdnDfj2Fd9mZUGIP2Heb+e5hvpW7+Etc5ZmtCMs9wuI+k7zCyvolPsIpyXVAeNz
	A/6iJXjQWYsYt98jZxgfmfLlxS608nXmSb+ZZvPSVPJ4uoktccIKpiFKS+KXFp/y8zlqe/
	9TadD6h9+nv/rIw0IoYDJH4gUfUBWRU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1A9040785;
	Wed, 15 Jul 2026 05:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9FF1F00A3D;
	Wed, 15 Jul 2026 05:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784092141;
	bh=NBTO7kI0cCt+N+gZ2oCWuzRF/4HzC9s9GIhJ0lJULgg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=iunZP1wjRURokwrc7lD6htANpgl9YOuV9GNqSnQi9n8uJ6dv2LnBg1Ujpa+xtftyq
	 IDquJ7NsaboyDxD7DNQy9VeUfbjtTOOAHMK0POVABC+crXO6F+wVAOsunWrZh80BE3
	 uy89yUvsVIQGoEqF/zwm/Dn+sCPTHUyWY/wv/buNBlUrkrGpYHpsqeVnhu4h3x7pDG
	 Dwh+JALpm2tYfk49ZqrdwIItjaPCd/xtkm0lstphDRjK+OQDCW301uqwOAy0U9Jt/7
	 VyeZ9oEl2SZSl7taIY5JyVO2LpOL1i+zHb1+8SGuIS1/Kx1xA8qjAphFHt2xWq44dd
	 wV0RoOGjkk4WA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 06/17] mm/sparse-vmemmap: support section-based vmemmap
 accounting
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
 muchun.song@linux.dev
In-Reply-To: <20260702093821.2740183-7-songmuchun@bytedance.com>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-7-songmuchun@bytedance.com>
Date: Wed, 15 Jul 2026 08:08:42 +0300
Message-Id: <178409212283.638342.6610895811767474932.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Stat-Signature: 5yjxpymqzeepmms76j9f8gy5oqs7tduh
X-Rspamd-Queue-Id: 5FB7020005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784092142-588291
X-HE-Meta: U2FsdGVkX1/Vp6tQ4/Rg8JZkJH0dW38ljtixCAB2CWAEC8SiOuSc200yN/YwUPOtThAdAdGTL0ML1B15A88t+gJsx5G2vqnYK3hg4jVAvtUX+PpTQU4QK3xqywIshFIIfRfBfrjMbWdsJtocTYyIz2HWSa+95jO9OghrFd6ubP89pqhpHKc7pj4zZ1vtBR3O8B3VLUmlffJ0UjfgNVGlkDY5epP1Zo5jSF6VwAHPZYzzBrv43lyQ6Z2HvYaM01ZtZHLzgAiEv0Cp7C+HYm6C/ExdvTuAgGP3wd+czLkM3bee2Li3MTCf7BYA8W5QxEc364HlgFeO9+6H3LRPrPANoA0gbus4HKWkQRa6OV/3zivbWrxtCeG00kk8ZwqqiBUlhKU/hLwALr2Z0/g21ccvfBUy6BbjfYUAziOVyVZar0SME2l0tvVUE3luKsjLshtw99sCMJM01WQWnWgBGM0aHvzWYzobZbyqYbA4dVi9TiOLaJ8X2/9HyaAx11CgIFVzltDsIEQ8W7vR5EbWPl0SyNQQlhR46QuyvgpJ/W5PeVo6649uCoGSdFPG2Qbo1JMZx3Zgj99+zZ3mqbDzcIYWaaaFHkBgW+VxrdyHiubgi9c8WOya2KnLhuTZnToHoJIuewZ0CxESA8Cr5li6+P9pT+a8jUtScl4GyCOrMqkeiYSmQ4l1hd2QPD58nw1unKWoJUNTvAfSp1rhMC9qUaN5cNSpeBdR5LRQUCLcRmYQjfHov/uD7rro29VlY6MVcPMsmGhi0qKnVYGx/IsLcj6kBubU3udl7QwHqvl5OzardqUIU9Q3syNAzF6HiDhAqoyMPbHz9wFHMBdrnTgyo8ZF7WtvF1DcgDwnuSuveWIKk46+Ri9CQUagNMB6o+0U/kfg81o6g4gPoHrVrdOLLZZxL4UMOinvrkEpZbcNqnXt2Xwm1pKxnAwN6+86j0e3WbA2TWtobqftI4zWXiMvSwZ
 lGW5ANgN
 m16mdFCSGA05Cu9lj3racStZM0uZ2T7hxLLj0PCKQ/5fogmmGQaK6hVIgOBu4D2I4pD+AYTrDem3KgowcC7GCmW1RCcg58V/XWVjeVfj9T5FJh8+zcoID9Bp+ailsiMOeAiHBjgpgD/hH6w5skag/ACxmSKF/O1vPh2hkSqhEQ88jRcdSZAJyDE38kAe0OlsUwqt5cIregfOL4kfnNk8c4haW+XF3c5jF6LWGLsE1bHE2nBjoDgpaqKCt3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> section_nr_vmemmap_pages() is used to account the vmemmap pages consumed by a
> memory section, but it currently only understands the ordinary case and the
> pgmap-provided optimization case. That is not enough for section-based vmemmap
> optimization, where the compound page order is carried by the memory section
> itself and tail vmemmap pages may be shared.
> 
> Make the helper report the actual vmemmap footprint of a section, so it can be
> used as the common accounting path for both ordinary and optimized sections.
> 
> Teach section_nr_vmemmap_pages() to use the section order when there is no
> pgmap, and to account only the vmemmap pages that are actually needed for an
> optimizable section. This keeps the accounting consistent with section-based
> vmemmap optimization.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 6fa6e7f0abf9..41a1ebbe5e85 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2403,6 +2403,14 @@ static inline unsigned int section_order(const struct mem_section *section)
>  }
>  #endif
>  
> +static inline bool section_vmemmap_optimizable(const struct mem_section *section)
> +{
> +	if (!is_power_of_2(sizeof(struct page)))
> +		return false;
> +
> +	return section_order(section) >= OPTIMIZABLE_FOLIO_MIN_ORDER;

Like with page_vmemmap_optimizable() I think it's not obvious that
section_order() is enough to gate vmemmap optimization.

> +}
> +
>  /*
>   * Fallback case for when the architecture provides its own pfn_valid() but
>   * not a corresponding for_each_valid_pfn().
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 77154e9da08c..99f59394feab 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -645,24 +645,29 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
>  		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
>  {
> -	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
> +	const struct mem_section *ms = __pfn_to_section(pfn);
> +	const unsigned int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
>  	const unsigned long pages_per_compound = 1UL << order;
> +	unsigned int vmemmap_pages = OPTIMIZED_FOLIO_VMEMMAP_PAGES;
>  
>  	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
>  	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
>  
> -	if (!vmemmap_can_optimize(altmap, pgmap))
> +	if (vmemmap_can_optimize(altmap, pgmap))
> +		vmemmap_pages = VMEMMAP_RESERVE_NR;

I'd put it below the next if ...

> +
> +	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
>  		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);

... and make it

	vmmemap_pages = vmemmap_can_optimize() ? VMEMMAP_RESERVE_NR : 1;

-- 
Sincerely yours,
Mike.


