Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC7CEF06ED
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 11:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177C06B0005; Tue, 10 Feb 2026 06:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F586B0088; Tue, 10 Feb 2026 06:44:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B316B0089; Tue, 10 Feb 2026 06:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E65A56B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:44:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CD8113B1E1
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:44:18 +0000 (UTC)
X-FDA: 84428363796.08.704F37C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D4811A000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:44:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L2WSgoei;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770723856; a=rsa-sha256;
	cv=none;
	b=es24TFkdHmB/vJbEwj5fXDSF52D3SezmWigfoMz8daVZP8AGeOWiY+l7kVYBg3wqzP8lJr
	6TtfWcxaGRWznvDKcNXoAfnWEC69DjAh4gS/d5aNz1Psgu/wLSNi60ID1xJNX2+VCTCqcw
	TdTr4rTofhB189ar3V7N6VZgSmOG41o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L2WSgoei;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770723856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DhfA+f26qy91GaqS70Xa5ZE/hVgVxhlLrt4vzPLjP+o=;
	b=S5c4m2Nb22c05R7EqMtfZc4FUBpgysUZ3/plH/3timLcug3sUiiRdGqoH+/QqWUCkqnvzz
	66Rf7UtUWN6/0l4T/J+CDGWODIgQIldIH+Ls7Tt+0aO9t1vRXr+amAwqauaJSHeS7gBf+s
	REWPi1PxC8o/old0OEpYN32MaVpPfZ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E669B60097;
	Tue, 10 Feb 2026 11:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F44C116C6;
	Tue, 10 Feb 2026 11:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770723855;
	bh=c/LuO3h/ogw7+uxXHVt9bSCf4zxpAHJmVI4//b+328k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L2WSgoeivO7hQ8rAteqrSiA4TPLeyzNT//Os4ZOCS3fjeqsDF3XViQQO2KGiy+zYX
	 8vGdIcQAuGd3TzUIZZ+WZEccw5I8H6vq3U0h2eIujPuMR/dGFo2u8SrbDsKUM/AhS9
	 ZxIJxLiEFR7J3hkN3c/q8glgYKto5zY6skueot3HuZoIS5BzrFORIy4zN0/qYtd1Qu
	 C0yhDy8Bsk8V/MWWnHzkwta/Kw/pxBFPhcO/W99DGdhUneu535ZZ1YldZ4Ze08//e1
	 mlAsDcbgqg/b4Tg7h7ATyF8W2Inffqnad9u3dZb6Zq7fJl3reu0glUQfy5QKsncSGG
	 WC0OOy9qz4AWw==
Date: Tue, 10 Feb 2026 13:44:06 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
Message-ID: <aYsaBkMecDG595Xg@kernel.org>
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
 <aYjmcZ4hg9bNbmiY@kernel.org>
 <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
 <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D4811A000C
X-Stat-Signature: rsujch8e3uie6s71p3619ycfxfodmhnd
X-HE-Tag: 1770723856-960927
X-HE-Meta: U2FsdGVkX18X/PmvTRdk6hp37KgU3h77tzxGegKx24d2mtBT98LUSgWM5t6WhDzBhNd8XXz5o+1aKHjaELhPx45jXrAUrC0Wv89ZXOJmHtzd7h3/w/mkYxSP6YuN2VPUJkQTnd6kvrDfPOwkgW3FHvQ/yRI3KSEthtY1K9a2/eTCmdPukn28APhgBjOcYpGr0fFgs7OTLX7QwXd0FIb0cL6GWiJv+Wb/70Xm1qEf0wXQQ0yKkWY6xF1WyHNjY2FZPS/1P5K9xfUihl6bmg5KT2O1nULtnXIiroQEvVPpz3ON+7K51btTGX6UsFqOdv01lX310sYVv/koDF9S3wuFrROv0QEHbgyJtWwmZmeHXwNjh2S5Rfq+BNNZtcCur/Cj8+6WDOe1eIxRGi4X06NiebgdnrQGCv4BdEIr4TbeWkQrVr1jX/5+IgkgL1KXakD5SyRvOv3cqQUyk9M+uM+gn7EBWbpqN/W2M6ejjCGYk5DxshXLf6zStIi1q8GGmSFMZOPg3JRKr+mwuBxqOLqUr5Z4pUv01EvimUoZDI7fOrVt0wBYYZ5UvCBrpYF4CAxQFvYJjM0+hdvML2SpMCPgJW5riWe/GiaguDq5pvy/WFwt1fAn0Bq1HcfQuk8uoFU1mgDQT95K/yHDHl4Qllg086UBRWtJVRHQLwm6b+DKDH2mvd5McUgmW3h8QqkGQZVyMIKQs0t+d2bdRDCJfnomkD2sKxX0FvqdsXHkuxulqe5p4JbscFlV4Yz8e7NoMxiRePi4/ddYoZ+O7OsjWdhz/KUHE9iEUo5Bjc/B82g6QfhX1y3rgYN/PZSXRArjPPHcq9SnYxKE8lceL9SQgL8yNrkQBGItJ4OjzLbZnMEoS0Dg9og7mBdCBt9baL1hKZaIzNDEsYUZyiRvFp21bFKMV/hBbal+IHmKpbn3addwcs0UW9sLuw/Z2ZdCMxXMCMxAioexJRzREfnJFZv67aq
 XA7aVAT1
 lgkOJdYiDdDmGz8uyq4QKh1vvdlHKzTqzKb/nONrTZKTb7NyTanaAQg947NDCEbS2farzgy1c597qKju/yFh+Q7iLuQ/a5jDzXSg/s14WD/oK1Q2Cn0avx00HcmmQ8CUkZOkBpy3WRoca0v0J9/bfI2vQjOwkjpkgoRvgz5/njsBykj9Mp1R3Eo16Zpqgnn7kUL+5f1ErgxwsAovJCVWuM0nBrTaY0OXW7Gn/tst4T08iOjH9Y+/ZVzXLsqifIvWkxFkxfp5VkZgkEZX6QTfAM60/vLf5JXkY+JtljyUav33M95FFRRn3fQLa9W9qShLy/wxMoR72mBMqtdAr+M4lD5Y+U4ojZB38wbVdRURoow11x6C0o5EWzNaFhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 01:44:45PM +0100, David Hildenbrand (Arm) wrote:
> On 2/9/26 11:52, David Hildenbrand (Arm) wrote:
> > On 2/8/26 20:39, Mike Rapoport wrote:
> > > On Sat, Feb 07, 2026 at 12:00:09PM +0100, David Hildenbrand (Arm) wrote:
> > > > 
> > > > Thanks for all your work on this and sorry for being slower with
> > > > review the last month.
> > > > 
> > > > While I was in the shower I was thinking about how much I hate
> > > > zone->contiguous + the pageblock walking, and how we could just get
> > > > rid of it.
> > > > 
> > > > You know, just what you do while having a relaxing shower.
> > > > 
> > > > 
> > > > And I was wondering:
> > > > 
> > > > (a) in which case would we have zone_spanned_pages == zone_present_pages
> > > > and the zone *not* being contiguous? I assume this just cannot happen,
> > > > otherwise BUG.
> > > > 
> > > > (b) in which case would we have zone_spanned_pages != zone_present_pages
> > > > and the zone *being* contiguous? I assume in some cases where we
> > > > have small
> > > > holes within a pageblock?
> > > > 
> > > > Reading the doc of __pageblock_pfn_to_page(), there are some weird
> > > > scenarios with holes in pageblocks.
> > > It seems that "zone->contigous" is really bad name for what this thing
> > > represents.
> > > 
> > > tl;dr I don't think zone_spanned_pages == zone_present_pages is
> > > related to
> > > zone->contigous at all :)
> > 
> > My point in (a) was that with "zone_spanned_pages == zone_present_pages"
> > there are no holes so -> contiguous.
> > 
> > (b), and what I said further below, is exactly about memory holes where
> > we have a memmap, but it's not present memory.
> > 
> > > 
> > > If you look at pageblock_pfn_to_page() and __pageblock_pfn_to_page(), the
> > > check for zone->contigous should guarantee that the entire pageblock
> > > has a
> > > valid memory map and that the entire pageblock fits a zone and does not
> > > cross zone/node boundaries.
> > 
> > Right. But that must hold for each and ever pageblock in the spanned
> > zone range for it to be contiguous.
> > 
> > zone->contigous tells you "pfn_to_page()" is valid on the complete zone
> > range"
> > 
> > That's why set_zone_contiguous() probes __pageblock_pfn_to_page() on ech
> > and ever pageblock.
> > 
> > > 
> > > For coldplug memory the memory map is valid for every section that has
> > > present memory, i.e. even it there is a hole in a section, it's
> > > memory map
> > > will be populated and will have struct pages.
> > 
> > There is this sub-section thing, and holes larger than a section might
> > not have a memmap (unless reserved I guess).
> > 
> > > 
> > > When zone->contigous is false, the slow path in __pageblock_pfn_to_page()
> > > essentially checks if the first page in a pageblock is online and if
> > > first
> > > and last pages are in the zone being compacted.
> > > AFAIU, in the hotplug case an entire pageblock is always onlined to the
> > > same zone, so zone->contigous won't change after the hotplug is complete.
> > 
> > I think you are missing a point: hotp(un)plug might create holes in the
> > zone span. Then, pfn_to_page() is no longer valid to be called on
> > arbitrary pageblocks within the zone.
> > 
> > > 
> > > We might set it to false in the beginning of the hotplug to avoid
> > > scanning
> > > offline pages, although I'm not sure if it's possible.
> > > 
> > > But in the end of hotplug we can simply restore the old value and
> > > move on.
> > 
> > No, you might create holes.
> > 
> > > 
> > > For the coldplug case I'm also not sure it's worth the hassle, we could
> > > just let compaction scan a few more pfns for those rare weird pageblocks
> > > and bail out on wrong page conditions.
> > 
> > To recap:
> > 
> > My idea is that "zone_spanned_pages == zone_present_pages" tells you
> > that the zone is contiguous because there are no holes.
> > 
> > To handle "non-memory with a struct page", you'd have to check
> > 
> >      "zone_spanned_pages == zone_present_pages +
> >           zone_non_present_memmap_pages"
> > 
> > Or shorter
> > 
> >      "zone_spanned_pages == zone_pages_with_memmap"
> > 
> > Then, pfn_to_page() is valid within the complete zone.
> > 
> > The question is how to best calculate the "zone_pages_with_memmap"
> > during boot.
> > 
> > During hot(un)plug we only add/remove zone_present_pages. The
> > zone_non_present_memmap_pages will not change due to hot(un)plug later.
> > 
> 
> The following hack does the trick. But
> 
> (a) I wish we could get rid of the pageblock walking in calc_online_pages().
> (b) "online_pages" has weird semantics due to the pageblock handling.
>     "online_pageblock_pages"? not sure.
> (c) Calculating "online_pages" when we know there is a hole does not make sense,
>     as we could just keep it 0 if there are holes and simply set it to
>     zone->online_pageblock_pages->zone->spanned_pages in case all are online.
> 
> 
> From d4cb825e91a6363afc68fb994c5d9b29c38c5f42 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Mon, 9 Feb 2026 13:40:24 +0100
> Subject: [PATCH] tmp
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/mmzone.h | 25 +++++++++++++++++++++++--
>  mm/internal.h          |  8 +-------
>  mm/memory_hotplug.c    | 20 ++++++--------------
>  mm/mm_init.c           | 12 ++++++------
>  4 files changed, 36 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index fc5d6c88d2f0..3f7d8d88c597 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -943,6 +943,11 @@ struct zone {
>  	 * cma pages is present pages that are assigned for CMA use
>  	 * (MIGRATE_CMA).
>  	 *
> +	 * online_pages is pages within the zone that have an online memmap.
> +	 * online_pages include present pages and memory holes that have a
> +	 * memmap. When spanned_pages == online_pages, pfn_to_page() can be
> +	 * performed without further checks on any pfn within the zone span.

Maybe pages_with_memmap? It would stand off from managed, spanned and
present, but it's clearer than online IMHO.

> +	 *
>  	 * So present_pages may be used by memory hotplug or memory power
>  	 * management logic to figure out unmanaged pages by checking
>  	 * (present_pages - managed_pages). And managed_pages should be used
> @@ -967,6 +972,7 @@ struct zone {
>  	atomic_long_t		managed_pages;
>  	unsigned long		spanned_pages;
>  	unsigned long		present_pages;
> +	unsigned long		online_pages;
>  #if defined(CONFIG_MEMORY_HOTPLUG)
>  	unsigned long		present_early_pages;
>  #endif
> @@ -1051,8 +1057,6 @@ struct zone {
>  	bool			compact_blockskip_flush;
>  #endif
> -	bool			contiguous;
> -
>  	CACHELINE_PADDING(_pad3_);
>  	/* Zone statistics */
>  	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
> @@ -1124,6 +1128,23 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
>  	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
>  }
> +/**
> + * zone_is_contiguous - test whether a zone is contiguous
> + * @zone: the zone to test.
> + *
> + * In a contiguous zone, it is valid to call pfn_to_page() on any pfn in the
> + * spanned zone without requiting pfn_valid() or pfn_to_online_page() checks.
> + *
> + * Returns: true if contiguous, otherwise false.
> + */
> +static inline bool zone_is_contiguous(const struct zone *zone)
> +{
> +	return READ_ONCE(zone->spanned_pages) == READ_ONCE(zone->online_pages);
> +}
> +
>  static inline bool zone_is_initialized(const struct zone *zone)
>  {
>  	return zone->initialized;
> diff --git a/mm/internal.h b/mm/internal.h
> index f35dbcf99a86..6062f9b8ee62 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -716,21 +716,15 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
>  static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>  				unsigned long end_pfn, struct zone *zone)
>  {
> -	if (zone->contiguous)
> +	if (zone_is_contiguous(zone))
>  		return pfn_to_page(start_pfn);
>  	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>  }
> -void set_zone_contiguous(struct zone *zone);
>  bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>  			   unsigned long nr_pages);
> -static inline void clear_zone_contiguous(struct zone *zone)
> -{
> -	zone->contiguous = false;
> -}
> -
>  extern int __isolate_free_page(struct page *page, unsigned int order);
>  extern void __putback_isolated_page(struct page *page, unsigned int order,
>  				    int mt);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a63ec679d861..76496c1039a9 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -492,11 +492,11 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>  		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
>  						zone_end_pfn(zone));
>  		if (pfn) {
> -			zone->spanned_pages = zone_end_pfn(zone) - pfn;
> +			WRITE_ONCE(zone->spanned_pages, zone_end_pfn(zone) - pfn);
>  			zone->zone_start_pfn = pfn;
>  		} else {
>  			zone->zone_start_pfn = 0;
> -			zone->spanned_pages = 0;
> +			WRITE_ONCE(zone->spanned_pages, 0);
>  		}
>  	} else if (zone_end_pfn(zone) == end_pfn) {
>  		/*
> @@ -508,10 +508,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>  		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
>  					       start_pfn);
>  		if (pfn)
> -			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
> +			WRITE_ONCE(zone->spanned_pages, pfn - zone->zone_start_pfn + 1);
>  		else {
>  			zone->zone_start_pfn = 0;
> -			zone->spanned_pages = 0;
> +			WRITE_ONCE(zone->spanned_pages, 0);
>  		}
>  	}
>  }
> @@ -565,18 +565,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>  	/*
>  	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
> -	 * we will not try to shrink the zones - which is okay as
> -	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
> +	 * we will not try to shrink the zones.
>  	 */
>  	if (zone_is_zone_device(zone))
>  		return;
> -	clear_zone_contiguous(zone);
> -
>  	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>  	update_pgdat_span(pgdat);
> -
> -	set_zone_contiguous(zone);
>  }
>  /**
> @@ -753,8 +748,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  	struct pglist_data *pgdat = zone->zone_pgdat;
>  	int nid = pgdat->node_id;
> -	clear_zone_contiguous(zone);
> -
>  	if (zone_is_empty(zone))
>  		init_currently_empty_zone(zone, start_pfn, nr_pages);
>  	resize_zone_range(zone, start_pfn, nr_pages);
> @@ -782,8 +775,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>  			 MEMINIT_HOTPLUG, altmap, migratetype,
>  			 isolate_pageblock);
> -
> -	set_zone_contiguous(zone);
>  }
>  struct auto_movable_stats {
> @@ -1079,6 +1070,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
>  	if (early_section(__pfn_to_section(page_to_pfn(page))))
>  		zone->present_early_pages += nr_pages;
>  	zone->present_pages += nr_pages;
> +	WRITE_ONCE(zone->online_pages,  zone->online_pages + nr_pages);
>  	zone->zone_pgdat->node_present_pages += nr_pages;
>  	if (group && movable)
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 2a809cd8e7fa..e33caa6fb6fc 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2263,9 +2263,10 @@ void __init init_cma_pageblock(struct page *page)
>  }
>  #endif
> -void set_zone_contiguous(struct zone *zone)
> +static void calc_online_pages(struct zone *zone)
>  {
>  	unsigned long block_start_pfn = zone->zone_start_pfn;
> +	unsigned long online_pages = 0;
>  	unsigned long block_end_pfn;
>  	block_end_pfn = pageblock_end_pfn(block_start_pfn);
> @@ -2277,12 +2278,11 @@ void set_zone_contiguous(struct zone *zone)
>  		if (!__pageblock_pfn_to_page(block_start_pfn,
>  					     block_end_pfn, zone))
> -			return;
> +			continue;
>  		cond_resched();
> +		online_pages += block_end_pfn - block_start_pfn;

I think we can completely get rid of this with something like this untested
patch to calculate zone->online_pages for coldplug:

diff --git a/mm/mm_init.c b/mm/mm_init.c
index e33caa6fb6fc..ff2f75e7b49f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -845,9 +845,9 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
  *   zone/node above the hole except for the trailing pages in the last
  *   section that will be appended to the zone/node below.
  */
-static void __init init_unavailable_range(unsigned long spfn,
-					  unsigned long epfn,
-					  int zone, int node)
+static u64 __init init_unavailable_range(unsigned long spfn,
+					 unsigned long epfn,
+					 int zone, int node)
 {
 	unsigned long pfn;
 	u64 pgcnt = 0;
@@ -861,6 +861,8 @@ static void __init init_unavailable_range(unsigned long spfn,
 	if (pgcnt)
 		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
 			node, zone_names[zone], pgcnt);
+
+	return pgcnt;
 }
 
 /*
@@ -959,9 +961,10 @@ static void __init memmap_init_zone_range(struct zone *zone,
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
 			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
 			  false);
+	zone->online_pages += (end_pfn - start_pfn);
 
 	if (*hole_pfn < start_pfn)
-		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
+		zone->online_pages += init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
 
 	*hole_pfn = end_pfn;
 }

-- 
Sincerely yours,
Mike.

