Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E43EC01CB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFBEE6B008A; Mon, 23 Mar 2026 07:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E855E6B008C; Mon, 23 Mar 2026 07:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D0D6B0092; Mon, 23 Mar 2026 07:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA1686B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:31:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56E738CCD0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:31:20 +0000 (UTC)
X-FDA: 84577111920.10.1F80307
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A4F06140012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:31:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dtG+Avfk;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774265478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3kBRsV0w1WS1AOM85vIp3zMujueq/XXn0Ng7SnRhX8=;
	b=PC1/NeCK073ERT4UL4cIPH56zFXzw+Es/fJVaidaPtPTh0dO6tuTQLEdNOUUolR6q8KFZI
	2UGkb3gZxu6OoAjXE06iC62k37OPtWN9snmqZ4xikb/Q0m4dN8q3SHGL9qpeR+8tVKushl
	A6L2rPr8P/BAfT9XU41kyly/MvbTdgc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dtG+Avfk;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774265478; a=rsa-sha256;
	cv=none;
	b=OP8Yff7hlvUQbHYEyv5qUUAqgzznZu3ZYEiLt5wBHG7qaCPMVcb/ZDWQczJNWeaaTMtUSt
	jGfnZcuYH1N9drp6b4Gw5fooI1RYTR+VuIZKB+F4+YUMdz9KyB7cMenWxr4ED7fHnb+9se
	FuEWTZXyw8ArAPsKOcqjtfy04jLnpYI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F249F60051;
	Mon, 23 Mar 2026 11:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C75CC4CEF7;
	Mon, 23 Mar 2026 11:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774265477;
	bh=kUB2by9Sg2Aa20ewEla3G89dUXvxfSD4cfHOiJClJEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dtG+AvfkyFgUcS4Iibzsw3UfR4C27iMk2xxRUhRDjBXPC4rtNsMiykr8mi/6jM0rq
	 KUF+ewPZxhIrhg3ojIqVrX0KVmC8NKM/yYAa0a2k2g+Mjt8k34aV/34XogrCfin4x2
	 Ba70KGsdhWmW54fkHqIKEIra9fmvvsWqC3smh/GSBij2zQhYUKTijBn9pod+hKZmbh
	 nNNS9KdLwSTvopWBYhrQmmvpmBFT0GuX8CsB9pnpLddASonywEC5/si41kpeY2+57A
	 +fnRQF8fQNUyTuCMTaud+ac2xBsRBJgZ5buV+QXWUxzJ2Pahja6oIGnB91RFzyOkfp
	 E8ffKdvc5OtQA==
Date: Mon, 23 Mar 2026 13:31:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Message-ID: <acEkfaycrJI-kWjk@kernel.org>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
 <48b497e5-1545-4376-a898-f3813a6ef989@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48b497e5-1545-4376-a898-f3813a6ef989@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A4F06140012
X-Rspamd-Server: rspam08
X-Stat-Signature: zfb1ptukdcdypqgapt4iz73d4jjjp4t1
X-HE-Tag: 1774265478-178170
X-HE-Meta: U2FsdGVkX18IONo1CMDA7EmfK5nkzov+1YcqjxEkBk2BElMAePSzmJgEMrra4aJhhI+Te92aNgD8/mjle5w0iFb1ZbmtLfwCttiPI3FtbNF81Jx+Z2kxoOwNwks+J40Xt6RNpObYPUPnPf2ezqjZpKWo22MuYLLqBd/1teqQB46+PwePLys+WLV5DRin7OjvGlc3E06F0h39p4YdO+1kCcQYkW4HuaYHeNCyoPX3e6UDHx9afkdMkfHJk158PDgipAjZVXBd5TmPq14P5JfYixz5mzuCZTTLMA6ZPonIpYSYpMY9xFVpjyjle5lI15TnBa6X0HyHXdpbrwELzO3XzDxGtsx1rw2tknvknLUZHAdNEKVAFj1k6hiSa5VKpRGVbyC0OSpJ8GPVpU8QKzIuT6lgzrZLBsfPzTyl3GGdKAq6LIjHlL6f2S2GNGrdrtNd2vjQcgRaEsi+7Re+Pqm6PxXQ0PtuUYS6POyg/ym5xQuzQHzkIscZBq2bxj32SQbkiyacOx4egSB/Aevb3VhXcLxtphSoWdzAquZ7mieyrWVJBjqtCDp/+0Fk5ZPQ20VyftHVp4SIqMs+uwQHqsRs21Dy3GswXApBGWcIhAReYKsbrJQAF2iSTwS3wSmSE4vtf9xq7zFBaboBlKT8EZkR5xxMMApFgA07G64DzeKcpvjvf7qlS4fj593t5OGE40P0y1voqv8pHpBw69INJc1vJ3tX3XQQDCUWtJCNlBPm9L/0IY6LqB7d35ruTqlF/DRezNYSBs8cWq1MKfCZWABjFMNhplYGsXlO4+YEqNrjCz80j5V0pkMUm1ksbUqC1YlNw0lkTXeVZ43h3/gS3UsE5w0PeSqMjIKhq+XNtYD4179Jwvrsa/e5WDXpt8nfjpfegz0XT3OPF8ibkRe3q2UzNIDPvEB7mfCTWL1xFUYfwpC8xeqHiNmaevYslZtusuLjWBseY61Fyk755hCtHWY
 wbwX04pg
 ZBduqBKKjiwxkmtmRms1Kjp3yaLbuGokPv0EPa9EQ5v4qrkUiq5uPDPxHNhijb4tfX7UsjKhLjwtgHW3LGReYamt26IQuc3BqSXiUw2yXwVLaNXWCxbzIv8UGpoYIna7vOtzRCsQJgfku+u8nrTZmTYyN3tykZxP4EqJAIkd8hkpx7YS5+tSe+zllx2JfSJKXrbbTEZKtY0Yr9MLOTeYn4/bwlIajnlbcUbMdvZFxbzKKwPojGNEbIfsPt+DzNSWYGal3AGW7g3VCNYVFwkHladxscD2VdO981ji9Zy5E3IK1YUPsH6Au+jW/WsOplFRhmDH+7oJaygp9UhdHvIAC3K4i4Vs03n6dY0xN23HBVzGKmp1SFkXZUAOf0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:56:35AM +0100, David Hildenbrand (Arm) wrote:
> On 3/19/26 10:56, Yuan Liu wrote:

...

> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index df34797691bd..96690e550024 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -946,6 +946,7 @@ static void __init memmap_init_zone_range(struct zone *zone,
> >  	unsigned long zone_start_pfn = zone->zone_start_pfn;
> >  	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
> >  	int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
> > +	unsigned long zone_hole_start, zone_hole_end;
> >  
> >  	start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
> >  	end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
> > @@ -957,8 +958,19 @@ static void __init memmap_init_zone_range(struct zone *zone,
> >  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
> >  			  false);
> >  
> > -	if (*hole_pfn < start_pfn)
> > +	WRITE_ONCE(zone->pages_with_online_memmap,
> > +		   READ_ONCE(zone->pages_with_online_memmap) +
> > +		   (end_pfn - start_pfn));
> > +
> > +	if (*hole_pfn < start_pfn) {
> >  		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> > +		zone_hole_start = clamp(*hole_pfn, zone_start_pfn, zone_end_pfn);
> > +		zone_hole_end = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
> > +		if (zone_hole_start < zone_hole_end)
> > +			WRITE_ONCE(zone->pages_with_online_memmap,
> > +				   READ_ONCE(zone->pages_with_online_memmap) +
> > +				   (zone_hole_end - zone_hole_start));
> > +	}
> 
> The range can have larger holes without a memmap, and I think we would be
> missing pages handled by the other init_unavailable_range() call?
> 
> 
> There is one question for Mike, though: couldn't it happen that the
> init_unavailable_range() call in memmap_init() would initialize
> the memmap outside of the node/zone span? 

Yes, and it most likely will.

Very common example is page 0 on x86 systems:

[    0.012196]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.012221] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.012205] Early memory node ranges
[    0.012206]   node   0: [mem 0x0000000000001000-0x000000000009efff]
 
The unavailable page in zone DMA is the page from  0x0 to 0x1000 that is
neither in node 0 nor in zone DMA.

For ZONE_NORMAL it would be a more pathological case when zone/node span
ends in a middle of a section, but that's still possible.
 
> If so, I wonder whether we would want to adjust the node+zone space to
> include these ranges.
> 
> Later memory onlining could make these ranges suddenly fall into the
> node/zone span.

But doesn't memory onlining always happen at section boundaries?
 
> So that requires some thought.
> 
> 
> Maybe we should start with this (untested):
> 
> >From a73ee44bc93fbcb9cf2b995e27fb98c68415f7be Mon Sep 17 00:00:00 2001
> From: Yuan Liu <yuan1.liu@intel.com>
> Date: Thu, 19 Mar 2026 05:56:22 -0400
> Subject: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check when
>  changing pfn range
> 
> [...]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  Documentation/mm/physical_memory.rst |  6 ++++
>  drivers/base/memory.c                |  5 ++++
>  include/linux/mmzone.h               | 38 +++++++++++++++++++++++++
>  mm/internal.h                        |  8 +-----
>  mm/memory_hotplug.c                  | 12 ++------
>  mm/mm_init.c                         | 42 ++++++++++------------------
>  6 files changed, 67 insertions(+), 44 deletions(-)
> 
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index 2398d87ac156..e4e188cd4887 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -483,6 +483,12 @@ General
>    ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
>    is initialized by ``calculate_node_totalpages()``.
>  
> +``pages_with_online_memmap``
> +  The pages_with_online_memmap is pages within the zone that have an online
> +  memmap. It includes present pages and memory holes that have a memmap. When
> +  spanned_pages == pages_with_online_memmap, pfn_to_page() can be performed
> +  without further checks on any pfn within the zone span.
> +
>  ``present_early_pages``
>    The present pages existing within the zone located on memory available since
>    early boot, excluding hotplugged memory. Defined only when
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 5380050b16b7..a367dde6e6fa 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -246,6 +246,7 @@ static int memory_block_online(struct memory_block *mem)
>  		nr_vmemmap_pages = mem->altmap->free;
>  
>  	mem_hotplug_begin();
> +	clear_zone_contiguous(zone);
>  	if (nr_vmemmap_pages) {
>  		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
>  		if (ret)
> @@ -270,6 +271,7 @@ static int memory_block_online(struct memory_block *mem)
>  
>  	mem->zone = zone;
>  out:
> +	set_zone_contiguous(zone);
>  	mem_hotplug_done();
>  	return ret;
>  }
> @@ -295,6 +297,8 @@ static int memory_block_offline(struct memory_block *mem)
>  		nr_vmemmap_pages = mem->altmap->free;
>  
>  	mem_hotplug_begin();
> +	clear_zone_contiguous(mem->zone);
> +
>  	if (nr_vmemmap_pages)
>  		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
>  					  -nr_vmemmap_pages);
> @@ -314,6 +318,7 @@ static int memory_block_offline(struct memory_block *mem)
>  
>  	mem->zone = NULL;
>  out:
> +	set_zone_contiguous(mem->zone);
>  	mem_hotplug_done();
>  	return ret;
>  }
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index e11513f581eb..463376349a2c 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1029,6 +1029,11 @@ struct zone {
>  	 * cma pages is present pages that are assigned for CMA use
>  	 * (MIGRATE_CMA).
>  	 *
> +	 * pages_with_online_memmap is pages within the zone that have an online
> +	 * memmap. It includes present pages and memory holes that have a memmap.
> +	 * When spanned_pages == pages_with_online_memmap, pfn_to_page() can be
> +	 * performed without further checks on any pfn within the zone span.
> +	 *
>  	 * So present_pages may be used by memory hotplug or memory power
>  	 * management logic to figure out unmanaged pages by checking
>  	 * (present_pages - managed_pages). And managed_pages should be used
> @@ -1053,6 +1058,7 @@ struct zone {
>  	atomic_long_t		managed_pages;
>  	unsigned long		spanned_pages;
>  	unsigned long		present_pages;
> +	unsigned long		pages_with_online_memmap;
>  #if defined(CONFIG_MEMORY_HOTPLUG)
>  	unsigned long		present_early_pages;
>  #endif
> @@ -1710,6 +1716,38 @@ static inline bool populated_zone(const struct zone *zone)
>  	return zone->present_pages;
>  }
>  
> +/**
> + * zone_is_contiguous - test whether a zone is contiguous
> + * @zone: the zone to test.
> + *
> + * In a contiguous zone, it is valid to call pfn_to_page() on any pfn in the
> + * spanned zone without requiring pfn_valid() or pfn_to_online_page() checks.
> + *
> + * Note that missing synchronization with memory offlining makes any
> + * PFN traversal prone to races.
> + *
> + * ZONE_DEVICE zones are always marked non-contiguous.
> + *
> + * Returns: true if contiguous, otherwise false.
> + */
> +static inline bool zone_is_contiguous(const struct zone *zone)
> +{
> +	return zone->contiguous;
> +}
> +
> +static inline void set_zone_contiguous(struct zone *zone)
> +{
> +	if (zone_is_zone_device(zone))
> +		return;
> +	if (zone->spanned_pages == zone->pages_with_online_memmap)
> +		zone->contiguous = true;
> +}
> +
> +static inline void clear_zone_contiguous(struct zone *zone)
> +{
> +	zone->contiguous = false;
> +}
> +
>  #ifdef CONFIG_NUMA
>  static inline int zone_to_nid(const struct zone *zone)
>  {
> diff --git a/mm/internal.h b/mm/internal.h
> index 532d78febf91..faec50e55a30 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -816,21 +816,15 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
>  static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>  				unsigned long end_pfn, struct zone *zone)
>  {
> -	if (zone->contiguous)
> +	if (zone_is_contiguous(zone))
>  		return pfn_to_page(start_pfn);
>  
>  	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>  }
>  
> -void set_zone_contiguous(struct zone *zone);
>  bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>  			   unsigned long nr_pages);
>  
> -static inline void clear_zone_contiguous(struct zone *zone)
> -{
> -	zone->contiguous = false;
> -}
> -
>  extern int __isolate_free_page(struct page *page, unsigned int order);
>  extern void __putback_isolated_page(struct page *page, unsigned int order,
>  				    int mt);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 70e620496cec..f29c0d70c970 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -558,18 +558,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>  
>  	/*
>  	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
> -	 * we will not try to shrink the zones - which is okay as
> -	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
> +	 * we will not try to shrink the zones.
>  	 */
>  	if (zone_is_zone_device(zone))
>  		return;
>  
> -	clear_zone_contiguous(zone);
> -
>  	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>  	update_pgdat_span(pgdat);
> -
> -	set_zone_contiguous(zone);
>  }
>  
>  /**
> @@ -746,8 +741,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  	struct pglist_data *pgdat = zone->zone_pgdat;
>  	int nid = pgdat->node_id;
>  
> -	clear_zone_contiguous(zone);
> -
>  	if (zone_is_empty(zone))
>  		init_currently_empty_zone(zone, start_pfn, nr_pages);
>  	resize_zone_range(zone, start_pfn, nr_pages);
> @@ -775,8 +768,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>  			 MEMINIT_HOTPLUG, altmap, migratetype,
>  			 isolate_pageblock);
> -
> -	set_zone_contiguous(zone);
>  }
>  
>  struct auto_movable_stats {
> @@ -1072,6 +1063,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
>  	if (early_section(__pfn_to_section(page_to_pfn(page))))
>  		zone->present_early_pages += nr_pages;
>  	zone->present_pages += nr_pages;
> +	zone->pages_with_online_memmap += nr_pages;
>  	zone->zone_pgdat->node_present_pages += nr_pages;
>  
>  	if (group && movable)
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index e0f1e36cb9e4..6e5a8da7cdda 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -854,7 +854,7 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>   *   zone/node above the hole except for the trailing pages in the last
>   *   section that will be appended to the zone/node below.
>   */
> -static void __init init_unavailable_range(unsigned long spfn,
> +static unsigned long __init init_unavailable_range(unsigned long spfn,
>  					  unsigned long epfn,
>  					  int zone, int node)
>  {
> @@ -870,6 +870,7 @@ static void __init init_unavailable_range(unsigned long spfn,
>  	if (pgcnt)
>  		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
>  			node, zone_names[zone], pgcnt);
> +	return pgcnt;
>  }
>  
>  /*
> @@ -958,6 +959,7 @@ static void __init memmap_init_zone_range(struct zone *zone,
>  	unsigned long zone_start_pfn = zone->zone_start_pfn;
>  	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
>  	int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
> +	unsigned long hole_pfns;
>  
>  	start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
>  	end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
> @@ -968,9 +970,12 @@ static void __init memmap_init_zone_range(struct zone *zone,
>  	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
>  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>  			  false);
> +	zone->pages_with_online_memmap = end_pfn - start_pfn;
>  
> -	if (*hole_pfn < start_pfn)
> -		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> +	if (*hole_pfn < start_pfn) {
> +		hole_pfns = init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> +		zone->pages_with_online_memmap += hole_pfns;
> +	}
>  
>  	*hole_pfn = end_pfn;
>  }
> @@ -980,6 +985,7 @@ static void __init memmap_init(void)
>  	unsigned long start_pfn, end_pfn;
>  	unsigned long hole_pfn = 0;
>  	int i, j, zone_id = 0, nid;
> +	unsigned long hole_pfns;
>  
>  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>  		struct pglist_data *node = NODE_DATA(nid);
> @@ -1008,8 +1014,12 @@ static void __init memmap_init(void)
>  #else
>  	end_pfn = round_up(end_pfn, MAX_ORDER_NR_PAGES);
>  #endif
> -	if (hole_pfn < end_pfn)
> -		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
> +	if (hole_pfn < end_pfn) {
> +		struct zone *zone = &NODE_DATA(nid)->node_zones[zone_id];
> +
> +		hole_pfns = init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
> +		zone->pages_with_online_memmap += hole_pfns;
> +	}
>  }
>  
>  #ifdef CONFIG_ZONE_DEVICE
> @@ -2273,28 +2283,6 @@ void __init init_cma_pageblock(struct page *page)
>  }
>  #endif
>  
> -void set_zone_contiguous(struct zone *zone)
> -{
> -	unsigned long block_start_pfn = zone->zone_start_pfn;
> -	unsigned long block_end_pfn;
> -
> -	block_end_pfn = pageblock_end_pfn(block_start_pfn);
> -	for (; block_start_pfn < zone_end_pfn(zone);
> -			block_start_pfn = block_end_pfn,
> -			 block_end_pfn += pageblock_nr_pages) {
> -
> -		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
> -
> -		if (!__pageblock_pfn_to_page(block_start_pfn,
> -					     block_end_pfn, zone))
> -			return;
> -		cond_resched();
> -	}
> -
> -	/* We confirm that there is no hole */
> -	zone->contiguous = true;
> -}
> -
>  /*
>   * Check if a PFN range intersects multiple zones on one or more
>   * NUMA nodes. Specify the @nid argument if it is known that this
> -- 
> 2.43.0
> 
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

