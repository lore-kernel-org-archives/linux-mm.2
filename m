Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E981ECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04F546B00D4; Tue, 26 May 2026 10:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BCF6B00D7; Tue, 26 May 2026 10:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7ED06B00D8; Tue, 26 May 2026 10:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7AD76B00D4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:02:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43441C19FC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:02:22 +0000 (UTC)
X-FDA: 84809735724.24.27DB601
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A185180026
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:02:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nrlkvr9v;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779804140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olRyDIWDVt94Et94okGR5N0tVLkrWfcKRwlMa0WrF+Q=;
	b=iko4RPk7EXaO6buQhzaOMFLtXQ4rN0kDM3SbyDXNB7nG31QuaNLHAbWY8wyMOV1vP2BOGO
	JlxPOY2P5YstgdZvg17IllXAemFKLZBxRvwaQtIIl7X1lKRKuWfKhyZtB9SPupsZIo0a+S
	8ifR8fWpOtLCD3K74gZv3UxK6XscVL8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nrlkvr9v;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779804140; a=rsa-sha256;
	cv=none;
	b=0BFdKt6CsnsEtWZLkKMCoMDTn2Hh3jnwL+EfWWYhJZqbsSVQRD4DwB0rcyextFfRKYhcpo
	wEXWQmbMArfdvlzKTfkADdL6+Uz+yUtO5HDLI/NUHbkKYGt72yFDbqZ77GEV4KnENE8ozW
	iVcs8m+bOqXJghFZkPVU50axJOPcZSI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779804133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olRyDIWDVt94Et94okGR5N0tVLkrWfcKRwlMa0WrF+Q=;
	b=nrlkvr9vBa53M5tscHlEhA6gWAQPA+H42NoA278tXHDzttbduf1L0MiBw8I/tWgPsxm+oo
	cDZc5SqYpzh7r2egRXflh9hOMfUtxIeUuWja96l7M25tnYMlmS7H+o7kwcE30XVDQFP3yS
	43kuF+gxcqvI9XvjXbl7EDjYib+4QWs=
From: Usama Arif <usama.arif@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	fvdl@google.com
Subject: Re: [RFC PATCH 05/40] mm: page_alloc: remove watermark boost mechanism
Date: Tue, 26 May 2026 07:02:03 -0700
Message-ID: <20260526140204.1390573-1-usama.arif@linux.dev>
In-Reply-To: <20260520150018.2491267-6-riel@surriel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pqkfkidr1cibgb3spiyb79j5ajenzpsn
X-Rspamd-Queue-Id: 4A185180026
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779804140-737058
X-HE-Meta: U2FsdGVkX18fJKeCbL3QOOUC6ZSMhM/THnRqEiwYsY2gE2SEuyRvJuKSnPZ1zVAHPNOV6mKHXJwdQVu8biOIfX3JB4wDbt1TL9JgUtD3zc78LIzWwnxUyF1HithCWR/XUAOOjUok3heMeA3g95SfVYaFcDbdEv38WGeFkKQpjxXmQFVmkd/MUsA5FfeO3Rpj38l5DjE3zFalkaIF2iHGXiZFSocAba39R18n5aOI7hovhG1yLA6HyODqSomG9LKhob2LU+cu/3K2z6O2eMBUy1D4xWOys15v57XQDLQyum6VZKaICbpOZFNiGhOJoomRQSpBI6OnjwwNsMIZqLBKBhkogT8/H1wtWGvke0i4wYc51CKy+ksmn14rT8pVDWL757zryDKf/r358A01fQC+bFvGwW3YjsdmIZfeVYZLits9kR+TFlHVXT+Lv8fpNZkF8V7ZjMbIek/crIXazHKdtSMnXRFV1zHerRJq4G/i+i5xDFyZlcQQD1JWSBiMdtmP3HQU6xAt6n7/5o3wB8fioIC+iC/yy/DlMbA/sD6KxeeOqRVa0qfHjubV1Qom875QliBZqaqndcrt7X6bayHqONCAZLFZ/TVmzERnPdbTm4zfFj0dWG0f1tk4j8okehThsz5fML3EO9njvHS8V6VU/Mv2VWfYrHTugI5k8Vo1rqq0hB9Eg+tDrlV0c8DxITh5Umo0AGezkOb9CE81eun/SJTCKOo3efQ8lH/ARwRnE+5yvoL95aGU0kNMQriqgMiDzTfRXvc5qKQloo5MjGpb2878ZSlOX7tZgjvcSaOu0FGl3cg0bTIDX4rvZDJTW+Nrd3QphAmv/VuYdrT25aOdGNaA2zXPr9SA7IDeo0k3UMjrLXh8ODeV4Xvxx9tVmhm/KB2ehTcuw9/yncniK+jHVmvxEMFSy46IqsP861+jGQhFHWymiTXiHUAIbm7TXYnRbo/bkvV3UdHHOdBDo6P
 NBoGCi16
 JRKMuetBCZhbW87rdymRTL2cQqg8l5E9YIm9idR8dDosNdxuyjLb18fhnSNIZSLGIXXht3Y/mYsw/u0AQND8twbII4spJ/wTP1KKSjv3iv0PZ2exvFeuIJxyB3tifW5g1Wv+16tZZVemL6sni+iC/YPgWfhkd7yCzjNSV8Gfwd5s/XzGWpFv9YvANoDm0cxsyyKE3Nm/seJyGCwUNJrm3F60ot2VEC/QTsJBphBK8xw0ZTngPnFQbbU0YFAPE1DW4K/y9vNuA+1dqnx6fZFdOCO5AIxnaOcsnwZOeY7hpN8hgT/vMJ+E/qyl5Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 10:59:11 -0400 Rik van Riel <riel@surriel.com> wrote:

> watermark_boost was introduced to react to fragmentation events at the
> pageblock granularity: a sub-pageblock cross-type fallback would raise
> the zone watermark and wake kswapd, on the theory that reclaiming some
> order-0 pages would reduce future fallbacks.
> 
> With superpageblocks, anti-fragmentation is enforced at 1 GiB SPB
> granularity, and the meaningful signals (CLEAN->TAINT events, empty SPB
> count) live there.  Sub-pageblock fallbacks inside an already-tainted
> SPB do not change the fragmentation picture, and order-0 reclaim does
> not unmix a pageblock or surface a fresh clean SPB.
> 
> Worse, the boost is applied in try_to_claim_block() before the success
> path is decided.  When option 1 (no UNMOVABLE/RECLAIMABLE pageblock
> mixing) rejects a cross-type relabel, the boost has already been
> applied and the next rmqueue() will wake kswapd to drain memory back
> to high+boost - even when free pages are tens of times the high
> watermark.  Real workloads showed bursts of >150 wakeup_kswapd/min,
> all order-0, with stack traces consistently arriving from rmqueue()
> through the boost-cleanup path.  Free memory at the time was 38x the
> high watermark.
> 
> Drop the mechanism entirely:
> 
>   - boost_watermark() and its callsite in try_to_claim_block()
>   - the ZONE_BOOSTED_WATERMARK flag and its set/clear in rmqueue()
>   - zone->watermark_boost and the boost addend in wmark_pages()
>   - the __GFP_HIGH boost-bypass path in zone_watermark_fast()
>   - the watermark_boost_factor sysctl
>   - boost-aware logic in balance_pgdat() (nr_boost_reclaim,
>     zone_boosts[], pgdat_watermark_boosted, the boost-restart goto,
>     no-writeback for boost reclaim, the boost-only kcompactd wakeup)
> 
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Assisted-by: Claude:claude-opus-4.7 syzkaller
> ---
>  Documentation/admin-guide/sysctl/vm.rst |  21 -----
>  Documentation/mm/physical_memory.rst    |  13 +--
>  include/linux/mmzone.h                  |   6 +-
>  mm/page_alloc.c                         |  82 +----------------
>  mm/show_mem.c                           |   2 -
>  mm/vmscan.c                             | 115 ++----------------------
>  mm/vmstat.c                             |   2 -
>  7 files changed, 14 insertions(+), 227 deletions(-)
> 
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 97e12359775c..3ddc6115c89a 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -76,7 +76,6 @@ files can be found in mm/swap.c.
>  - user_reserve_kbytes
>  - vfs_cache_pressure
>  - vfs_cache_pressure_denom
> -- watermark_boost_factor
>  - watermark_scale_factor
>  - zone_reclaim_mode
>  
> @@ -1073,26 +1072,6 @@ vfs_cache_pressure_denom
>  Defaults to 100 (minimum allowed value). Requires corresponding
>  vfs_cache_pressure setting to take effect.
>  
> -watermark_boost_factor
> -======================
> -
> -This factor controls the level of reclaim when memory is being fragmented.
> -It defines the percentage of the high watermark of a zone that will be
> -reclaimed if pages of different mobility are being mixed within pageblocks.
> -The intent is that compaction has less work to do in the future and to
> -increase the success rate of future high-order allocations such as SLUB
> -allocations, THP and hugetlbfs pages.
> -
> -To make it sensible with respect to the watermark_scale_factor
> -parameter, the unit is in fractions of 10,000. The default value of
> -15,000 means that up to 150% of the high watermark will be reclaimed in the
> -event of a pageblock being mixed due to fragmentation. The level of reclaim
> -is determined by the number of fragmentation events that occurred in the
> -recent past. If this value is smaller than a pageblock then a pageblocks
> -worth of pages will be reclaimed (e.g.  2MB on 64-bit x86). A boost factor
> -of 0 will disable the feature.
> -
> -
>  watermark_scale_factor
>  ======================
>  
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index b76183545e5b..c4968db6e77c 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -394,11 +394,6 @@ General
>    to the distance between two watermarks. The distance itself is calculated
>    taking ``vm.watermark_scale_factor`` sysctl into account.
>  
> -``watermark_boost``
> -  The number of pages which are used to boost watermarks to increase reclaim
> -  pressure to reduce the likelihood of future fallbacks and wake kswapd now
> -  as the node may be balanced overall and kswapd will not wake naturally.
> -
>  ``nr_reserved_highatomic``
>    The number of pages which are reserved for high-order atomic allocations.
>  
> @@ -527,11 +522,9 @@ General
>    Defined only when ``CONFIG_UNACCEPTED_MEMORY`` is enabled.
>  
>  ``flags``
> -  The zone flags. The least three bits are used and defined by
> -  ``enum zone_flags``. ``ZONE_BOOSTED_WATERMARK`` (bit 0): zone recently boosted
> -  watermarks. Cleared when kswapd is woken. ``ZONE_RECLAIM_ACTIVE`` (bit 1):
> -  kswapd may be scanning the zone. ``ZONE_BELOW_HIGH`` (bit 2): zone is below
> -  high watermark.
> +  The zone flags. The bits are defined by ``enum zone_flags``.
> +  ``ZONE_RECLAIM_ACTIVE`` (bit 0): kswapd may be scanning the zone.
> +  ``ZONE_BELOW_HIGH`` (bit 1): zone is below high watermark.
>  
>  ``lock``
>    The main lock that protects the internal data structures of the page allocator
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 732e4dd181b9..13e29b2ebb86 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -978,7 +978,6 @@ struct zone {
>  
>  	/* zone watermarks, access with *_wmark_pages(zone) macros */
>  	unsigned long _watermark[NR_WMARK];
> -	unsigned long watermark_boost;
>  
>  	unsigned long nr_reserved_highatomic;
>  	unsigned long nr_free_highatomic;
> @@ -1167,9 +1166,6 @@ enum pgdat_flags {
>  };
>  
>  enum zone_flags {
> -	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
> -					 * Cleared when kswapd is woken.
> -					 */
>  	ZONE_RECLAIM_ACTIVE,		/* kswapd may be scanning the zone. */
>  	ZONE_BELOW_HIGH,		/* zone is below high watermark. */
>  };
> @@ -1177,7 +1173,7 @@ enum zone_flags {
>  static inline unsigned long wmark_pages(const struct zone *z,
>  					enum zone_watermarks w)
>  {
> -	return z->_watermark[w] + z->watermark_boost;
> +	return z->_watermark[w];
>  }
>  
>  static inline unsigned long min_wmark_pages(const struct zone *z)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 47d314e77151..6e01e58aca54 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -267,7 +267,6 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
>  
>  int min_free_kbytes = 1024;
>  int user_min_free_kbytes = -1;
> -static int watermark_boost_factor __read_mostly = 15000;
>  static int watermark_scale_factor = 10;
>  int defrag_mode;
>  
> @@ -2340,43 +2339,6 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
>  
>  #endif /* CONFIG_MEMORY_ISOLATION */
>  
> -static inline bool boost_watermark(struct zone *zone)
> -{
> -	unsigned long max_boost;
> -
> -	if (!watermark_boost_factor)
> -		return false;
> -	/*
> -	 * Don't bother in zones that are unlikely to produce results.
> -	 * On small machines, including kdump capture kernels running
> -	 * in a small area, boosting the watermark can cause an out of
> -	 * memory situation immediately.
> -	 */
> -	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
> -		return false;
> -
> -	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
> -			watermark_boost_factor, 10000);
> -
> -	/*
> -	 * high watermark may be uninitialised if fragmentation occurs
> -	 * very early in boot so do not boost. We do not fall
> -	 * through and boost by pageblock_nr_pages as failing
> -	 * allocations that early means that reclaim is not going
> -	 * to help and it may even be impossible to reclaim the
> -	 * boosted watermark resulting in a hang.
> -	 */
> -	if (!max_boost)
> -		return false;
> -
> -	max_boost = max(pageblock_nr_pages, max_boost);
> -
> -	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
> -		max_boost);
> -
> -	return true;
> -}
> -
>  /*
>   * When we are falling back to another migratetype during allocation, should we
>   * try to claim an entire block to satisfy further allocations, instead of
> @@ -2477,14 +2439,6 @@ try_to_claim_block(struct zone *zone, struct page *page,
>  		return page;
>  	}
>  
> -	/*
> -	 * Boost watermarks to increase reclaim pressure to reduce the
> -	 * likelihood of future fallbacks. Wake kswapd now as the node
> -	 * may be balanced overall and kswapd will not wake naturally.
> -	 */
> -	if (boost_watermark(zone) && (alloc_flags & ALLOC_KSWAPD))
> -		set_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
> -
>  	/* moving whole block can fail due to zone boundary conditions */
>  	if (!prep_move_freepages_block(zone, page, &start_pfn, &free_pages,
>  				       &movable_pages))
> @@ -3839,13 +3793,6 @@ struct page *rmqueue(struct zone *preferred_zone,
>  							migratetype);
>  
>  out:
> -	/* Separate test+clear to avoid unnecessary atomics */
> -	if ((alloc_flags & ALLOC_KSWAPD) &&
> -	    unlikely(test_bit(ZONE_BOOSTED_WATERMARK, &zone->flags))) {
> -		clear_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
> -		wakeup_kswapd(zone, 0, 0, zone_idx(zone));
> -	}
> -
>  	VM_BUG_ON_PAGE(page && bad_range(zone, page), page);
>  	return page;
>  }
> @@ -4123,24 +4070,8 @@ static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
>  			return true;
>  	}
>  
> -	if (__zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
> -					free_pages))
> -		return true;
> -
> -	/*
> -	 * Ignore watermark boosting for __GFP_HIGH order-0 allocations
> -	 * when checking the min watermark. The min watermark is the
> -	 * point where boosting is ignored so that kswapd is woken up
> -	 * when below the low watermark.
> -	 */
> -	if (unlikely(!order && (alloc_flags & ALLOC_MIN_RESERVE) && z->watermark_boost
> -		&& ((alloc_flags & ALLOC_WMARK_MASK) == WMARK_MIN))) {
> -		mark = z->_watermark[WMARK_MIN];
> -		return __zone_watermark_ok(z, order, mark, highest_zoneidx,
> -					alloc_flags, free_pages);
> -	}
> -
> -	return false;
> +	return __zone_watermark_ok(z, order, mark, highest_zoneidx, alloc_flags,
> +					free_pages);
>  }
>  
>  #ifdef CONFIG_NUMA
> @@ -6919,7 +6850,6 @@ static void __setup_per_zone_wmarks(void)
>  			    mult_frac(zone_managed_pages(zone),
>  				      watermark_scale_factor, 10000));
>  
> -		zone->watermark_boost = 0;
>  		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
>  		zone->_watermark[WMARK_HIGH] = low_wmark_pages(zone) + tmp;
>  		zone->_watermark[WMARK_PROMO] = high_wmark_pages(zone) + tmp;
> @@ -7187,14 +7117,6 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
>  		.proc_handler	= min_free_kbytes_sysctl_handler,
>  		.extra1		= SYSCTL_ZERO,
>  	},
> -	{
> -		.procname	= "watermark_boost_factor",
> -		.data		= &watermark_boost_factor,
> -		.maxlen		= sizeof(watermark_boost_factor),
> -		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_minmax,
> -		.extra1		= SYSCTL_ZERO,
> -	},


This is a userspace-visible removal. Writes to
/proc/sys/vm/watermark_boost_factor will now return -ENOENT instead of being
accepted, breaking userspace.

I am not sure whats been done in the past, but we need to add a
Documentation/ABI/removed/ note explaining what replaces it (SPB steering).
and also maybe keep the sysctl entry as a no-op with warning for a few
cycles before deletion?


>  	{
>  		.procname	= "watermark_scale_factor",
>  		.data		= &watermark_scale_factor,
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 43aca5a2ac99..d08f1263480a 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -302,7 +302,6 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  		printk(KERN_CONT
>  			"%s"
>  			" free:%lukB"
> -			" boost:%lukB"

The boost: field in /proc/zoneinfo and the show_mem output also disappears.
Something similar might need to be done for this as well.

>  			" min:%lukB"
>  			" low:%lukB"
>  			" high:%lukB"
> @@ -325,7 +324,6 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			"\n",
>  			zone->name,
>  			K(zone_page_state(zone, NR_FREE_PAGES)),
> -			K(zone->watermark_boost),
>  			K(min_wmark_pages(zone)),
>  			K(low_wmark_pages(zone)),
>  			K(high_wmark_pages(zone)),
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..461e70f9c9f0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6883,30 +6883,6 @@ static void kswapd_age_node(struct pglist_data *pgdat, struct scan_control *sc)
>  	} while (memcg);
>  }
>  
> -static bool pgdat_watermark_boosted(pg_data_t *pgdat, int highest_zoneidx)
> -{
> -	int i;
> -	struct zone *zone;
> -
> -	/*
> -	 * Check for watermark boosts top-down as the higher zones
> -	 * are more likely to be boosted. Both watermarks and boosts
> -	 * should not be checked at the same time as reclaim would
> -	 * start prematurely when there is no boosting and a lower
> -	 * zone is balanced.
> -	 */
> -	for (i = highest_zoneidx; i >= 0; i--) {
> -		zone = pgdat->node_zones + i;
> -		if (!managed_zone(zone))
> -			continue;
> -
> -		if (zone->watermark_boost)
> -			return true;
> -	}
> -
> -	return false;
> -}
> -
>  /*
>   * Returns true if there is an eligible zone balanced for the request order
>   * and highest_zoneidx
> @@ -7111,14 +7087,13 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  	unsigned long nr_soft_reclaimed;
>  	unsigned long nr_soft_scanned;
>  	unsigned long pflags;
> -	unsigned long nr_boost_reclaim;
> -	unsigned long zone_boosts[MAX_NR_ZONES] = { 0, };
> -	bool boosted;
>  	struct zone *zone;
>  	struct scan_control sc = {
>  		.gfp_mask = GFP_KERNEL,
>  		.order = order,
>  		.may_unmap = 1,
> +		.may_writepage = 1,
> +		.may_swap = 1,
>  	};
>  
>  	set_task_reclaim_state(current, &sc.reclaim_state);
> @@ -7127,18 +7102,6 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  
>  	count_vm_event(PAGEOUTRUN);
>  
> -	/*
> -	 * Account for the reclaim boost. Note that the zone boost is left in
> -	 * place so that parallel allocations that are near the watermark will
> -	 * stall or direct reclaim until kswapd is finished.
> -	 */
> -	nr_boost_reclaim = 0;
> -	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
> -		nr_boost_reclaim += zone->watermark_boost;
> -		zone_boosts[i] = zone->watermark_boost;
> -	}
> -	boosted = nr_boost_reclaim;
> -
>  restart:
>  	set_reclaim_active(pgdat, highest_zoneidx);
>  	sc.priority = DEF_PRIORITY;
> @@ -7173,39 +7136,14 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		}
>  
>  		/*
> -		 * If the pgdat is imbalanced then ignore boosting and preserve
> -		 * the watermarks for a later time and restart. Note that the
> -		 * zone watermarks will be still reset at the end of balancing
> -		 * on the grounds that the normal reclaim should be enough to
> -		 * re-evaluate if boosting is required when kswapd next wakes.
> +		 * If there are no eligible zones, no work to do. Note that
> +		 * sc.reclaim_idx is not used as buffer_heads_over_limit may
> +		 * have adjusted it.
>  		 */
>  		balanced = pgdat_balanced(pgdat, sc.order, highest_zoneidx);
> -		if (!balanced && nr_boost_reclaim) {
> -			nr_boost_reclaim = 0;
> -			goto restart;
> -		}
> -
> -		/*
> -		 * If boosting is not active then only reclaim if there are no
> -		 * eligible zones. Note that sc.reclaim_idx is not used as
> -		 * buffer_heads_over_limit may have adjusted it.
> -		 */
> -		if (!nr_boost_reclaim && balanced)
> +		if (balanced)
>  			goto out;
>  
> -		/* Limit the priority of boosting to avoid reclaim writeback */
> -		if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
> -			raise_priority = false;
> -
> -		/*
> -		 * Do not writeback or swap pages for boosted reclaim. The
> -		 * intent is to relieve pressure not issue sub-optimal IO
> -		 * from reclaim context. If no pages are reclaimed, the
> -		 * reclaim will be aborted.
> -		 */
> -		sc.may_writepage = !nr_boost_reclaim;
> -		sc.may_swap = !nr_boost_reclaim;
> -
>  		/*
>  		 * Do some background aging, to give pages a chance to be
>  		 * referenced before reclaiming. All pages are rotated
> @@ -7249,15 +7187,6 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		 * progress in reclaiming pages
>  		 */
>  		nr_reclaimed = sc.nr_reclaimed - nr_reclaimed;
> -		nr_boost_reclaim -= min(nr_boost_reclaim, nr_reclaimed);
> -
> -		/*
> -		 * If reclaim made no progress for a boost, stop reclaim as
> -		 * IO cannot be queued and it could be an infinite loop in
> -		 * extreme circumstances.
> -		 */
> -		if (nr_boost_reclaim && !nr_reclaimed)
> -			break;
>  
>  		if (raise_priority || !nr_reclaimed)
>  			sc.priority--;
> @@ -7273,12 +7202,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		goto restart;
>  	}
>  
> -	/*
> -	 * If the reclaim was boosted, we might still be far from the
> -	 * watermark_high at this point. We need to avoid increasing the
> -	 * failure count to prevent the kswapd thread from stopping.
> -	 */
> -	if (!sc.nr_reclaimed && !boosted) {
> +	if (!sc.nr_reclaimed) {
>  		int fail_cnt = atomic_inc_return(&pgdat->kswapd_failures);
>  		/* kswapd context, low overhead to trace every failure */
>  		trace_mm_vmscan_kswapd_reclaim_fail(pgdat->node_id, fail_cnt);
> @@ -7287,28 +7211,6 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  out:
>  	clear_reclaim_active(pgdat, highest_zoneidx);
>  
> -	/* If reclaim was boosted, account for the reclaim done in this pass */
> -	if (boosted) {
> -		unsigned long flags;
> -
> -		for (i = 0; i <= highest_zoneidx; i++) {
> -			if (!zone_boosts[i])
> -				continue;
> -
> -			/* Increments are under the zone lock */
> -			zone = pgdat->node_zones + i;
> -			spin_lock_irqsave(&zone->lock, flags);
> -			zone->watermark_boost -= min(zone->watermark_boost, zone_boosts[i]);
> -			spin_unlock_irqrestore(&zone->lock, flags);
> -		}
> -
> -		/*
> -		 * As there is now likely space, wakeup kcompact to defragment
> -		 * pageblocks.
> -		 */
> -		wakeup_kcompactd(pgdat, pageblock_order, highest_zoneidx);
> -	}
> -
>  	snapshot_refaults(NULL, pgdat);
>  	__fs_reclaim_release(_THIS_IP_);
>  	psi_memstall_leave(&pflags);
> @@ -7542,8 +7444,7 @@ void wakeup_kswapd(struct zone *zone, gfp_t gfp_flags, int order,
>  
>  	/* Hopeless node, leave it to direct reclaim if possible */
>  	if (kswapd_test_hopeless(pgdat) ||
> -	    (pgdat_balanced(pgdat, order, highest_zoneidx) &&
> -	     !pgdat_watermark_boosted(pgdat, highest_zoneidx))) {
> +	    pgdat_balanced(pgdat, order, highest_zoneidx)) {
>  		/*
>  		 * There may be plenty of free memory available, but it's too
>  		 * fragmented for high-order allocations.  Wake up kcompactd
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index f534972f517d..7b48b84287a7 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1769,7 +1769,6 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
>  	}
>  	seq_printf(m,
>  		   "\n  pages free     %lu"
> -		   "\n        boost    %lu"
>  		   "\n        min      %lu"
>  		   "\n        low      %lu"
>  		   "\n        high     %lu"
> @@ -1779,7 +1778,6 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
>  		   "\n        managed  %lu"
>  		   "\n        cma      %lu",
>  		   zone_page_state(zone, NR_FREE_PAGES),
> -		   zone->watermark_boost,
>  		   min_wmark_pages(zone),
>  		   low_wmark_pages(zone),
>  		   high_wmark_pages(zone),
> -- 
> 2.54.0
> 
> 

