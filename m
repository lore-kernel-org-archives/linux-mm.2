Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF5FC982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 17:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50E76B008A; Thu, 17 Sep 2026 13:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01D56B008C; Thu, 17 Sep 2026 13:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EFF56B0092; Thu, 17 Sep 2026 13:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 621476B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:16:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B367A1403E3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:16:47 +0000 (UTC)
X-FDA: 85223908854.11.26E1808
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf15.hostedemail.com (Postfix) with ESMTP id E647AA0012
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:16:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kuNNxtjx;
	spf=pass (imf15.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789665405;
	b=Lb3STlCi63H5pkP1IQPsFtzU/TPjMPnxIBOqp9qLDeJEOD0OQfyZvOgRUik8q6eCp39fTR
	7pNEie3K5qjQEMnmcdSHjibyNE6MB0DTb0OPiMG56tzmYXathVcFTyJL+TnT/Pz+Y9+PLx
	tUzDgSKgcXcI+oQ0WSe2vUgVGzQmPo0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kuNNxtjx;
	spf=pass (imf15.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789665405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lvc4+TpMUxQ7MOz+O0C7vMiwmJqsd+n4APfPejatdr0=;
	b=Lo1OPIGxq0yVuLicOS4CMg73K7AoCO/+bPTBFzBbyaJowCerBYEFjIScb+DN7kK6v0ylqK
	P/6dF9wbaZSijcZp5DUDm85Pgwo6x6pHJqHuNcrACtqp3iauEbj0Q57WpRvXPmvw+YwFUs
	O1xGrhTCmyPQW4LnkqC8VhP0T5ITydU=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843796e373so653483f8f.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789665404; x=1790270204; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lvc4+TpMUxQ7MOz+O0C7vMiwmJqsd+n4APfPejatdr0=;
        b=kuNNxtjxtkxLsOU9vHpSSSRUv84qsVw4Pn51h6p7UIcd7s5VZoszgDcbt4V1zggZvy
         oEgCaPJGLrtXTA3ddFD4Y82VZEKheMccttzfR1xFFVGwVfaVxDKWnE0PYJomHtf5FUtq
         2YdvC258CJ5oVtD2932Qcta88LZXWw1aNZlUeNOoOIBzw+95VGx0YToWP3ExBBZYDNCp
         q1fzbgkruxffR3u7WbKINCQfrqlx5tRd713AxNVVml2IUPAMtNQjyXmwIb3pnbEzMlaK
         dq3vMaSHPi2ArBz56zFEJ0onJxl+b0g/jcBnFUfIZI5kjYxlLzl9xa3a8Mmu9CFs1Xq+
         QDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789665404; x=1790270204;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lvc4+TpMUxQ7MOz+O0C7vMiwmJqsd+n4APfPejatdr0=;
        b=dN5A0iuvtRlHb5NdcSM0lYnfMZeGcFPZjPjJJ1AR0ZnRv1ONnPIrVzWoROsk/KBnmY
         DPloNcSPyWCH102N9Bs7mYtDKdOf2wQdgnWuL8xqeWtmoMgANl5uFAt0Tf1umRilkeaQ
         SXh2OytYLMBk2yZNJrJGMfFJWHihF1s8IkPnPisIi8PpcEArfLHBPYXhPjk/uz0LtY9E
         xac1ab82clbBx89+DXjdBEw95yfAXDOU7fK4gciLYBL0SXcW/a4xM6///+pKbXVgcdIO
         inExvVwIcZsW7Rq325rklB5hXlYckNynRJ4dUFDfg81y7mmnRHt2DmusMgWrZpAM/R7W
         y0mw==
X-Forwarded-Encrypted: i=1; AKwUvBwKQINNd6BXbDLmBg3eu1xLUw3TdoRmYpQU/zuWpS7cMffGbDkWqYA7Belac7jVmFieYdm+TbqDuA==@kvack.org
X-Gm-Message-State: AFuF++m2pp/hEtnBQzt4gNOP3tgDCZK/579EvH2EdHCbRgzclq+YI51f
	BN+HSpwmYhAFxW/cY1Ytn/2PXShFezo7I7skV3FI8BuNTUdSUNWujwx1
X-Gm-Gg: AYBFou0GKOwFGVDf3rFoYc6ZxoyYDGi5fhDRQznbhjuQyNUDpDge7rT55EKFq5bfJCW
	uAF/qW9H4/SNFX3TlikuOQ4dcOL9DKiJn60LXfv9IzQsOngEGqL7k7O03c97C1AFhxJz0HB8jSP
	COFLvktBihmKQIaOJgpV/jACGRhDMped/iBuMtxklOmT1CkB8J0Bs5NytU5rMNm4gUNIxMDZ4uV
	+ZISiVMORDJHjjlPX03wujBKN/NzbCpJYJK5ZN8RImiWaKqcqLhhjaZRKjtiw2P3R7F7C4XpifI
	L2GUGVG3UIkooZyLel0xOqPy+kCNrEMHNiMgFnioMlteP2b9xJ63XmH5DvkRnj5nccY5RKczy4M
	PlaA6je4vHBEk0/qwyTFU0pnTxtcOcEfsXAJ3O5UZIBqUvGFrf6FtB+daB77Fgwn1dhonfF9wPn
	t5Vq4KkdSSZ8NcEUEA61mAWbFEBZEdLeNylBqqsfARfFhrv+9btMBCIZZrDMzhmVWiiFZk35pBX
	u2oYjrbL8+ls5nvnmF3mWGLRYXgVbX5r8hDHuYwvKYMJZ5saSr/b1f153EgezmZyQ9VuZFc
X-Received: by 2002:a05:6000:2997:10b0:485:c240:20ec with SMTP id ffacd0b85a97d-4870d26961cmr7299030f8f.37.1789665404188;
        Thu, 17 Sep 2026 10:16:44 -0700 (PDT)
Received: from localhost (pat-125-254.wlan.net.ed.ac.uk. [192.41.125.254])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf37e69sm16896117f8f.29.2026.09.17.10.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 10:16:43 -0700 (PDT)
Date: Thu, 17 Sep 2026 18:16:42 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, david@kernel.org,
	surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
	hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org,
	liam@infradead.org, rppt@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	zhaonanzhe@xiaomi.com, lipengfei28@xiaomi.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [RFC PATCH 4/4] mm: adjust free_pages to make
 __zone_watermark_ok() mTHP-aware
Message-ID: <20260917171642.b4pkhqmvjwnq3vmq@wrangler>
References: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
 <20260825043833.2659350-5-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825043833.2659350-5-zhangbo56@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E647AA0012
X-Stat-Signature: qotwcutudog3t6pn8innqdxsdtargxzp
X-HE-Tag: 1789665405-687516
X-HE-Meta: U2FsdGVkX18K0mbAkUEqojFe3fCLCUVzzW4JIB+QRBzvqWkiCAiYqUI1nm76BQjRgHaD8Fo8NHp4+vE8Pe3Zp2urCEaDeFUUD5jZWTFHqLngdPOgGkYBVJHxPFaaudE8Lt6XcfZwLZIksD8ZQkwEiFeLWoZcT8mZWq4v0mQTFxVvN/ErkcJ86+Bei4djDpsK6wFZYfVD00MnIXDgszRhtxmP9/cyHt9R9/3Y3bYtNQCLlw4zbISyRMUxGbh9rjyL2f7TZygC7wB/fIYD3mxYoiVyeM0ZEIWN8drmL1E56NB5naFWIbuhVlT8ZUpqvdiLWDd6RBZzK5XJR3gk+Le0Q0UEsRaBz85H+/oYpS8RZkiYpV5Sfs/2ZptHPRhQJr19kSu+ddm92xSLE90Sq1Rn8S4Dr6qPmsiGGCoxTrLhs/wvXhR/KbgyIjK7p+oJeuKiDtWuWN5Xhulk/IkUMRriGaTXGgAM3j+DJ9I0cwxkiku6v5+sW/wI6Crnldj3wOIjDPaHoOk/L1mNhUcvS7sEXEW5+k8aFLOtOhLvoJfSNN6FjEoVPcSKSvzPZ3a+Owr/sOBaduXlfigjI9j+BGWRN6MPjRZsgm+3dJwe8Dd9GeZ83QkA1GcFYXTEZLm0tLsJCGtGiqLUw4R2ubcCgqJTQKe4oAX3prB0Eh2oQ2BDNZG/L2tAsxHnFCqKs4rA6rvDo+jhoP4UJ2KZn8DaMr7XYhDz5jxkI7/OsnKnkzVpv873dXVJrlZtg2U4p0VvlCn/XhGP8aD5LDbjdXx2V310KImBVXi3w36gXQyWBgRRId+3Q1sztN6rDYytQKqBXK8rRwe6iWGZUB0mgANRU++pZCLuurOua4xxcvgXaHz9Jw1okC8eruFLSk35Qz0B+9NvsIKzRy2v8gIAMg7Sjt0ocwDNtvLNCjNOFasKq1kAPiDjetVPOao7/CgJZuJiIbKXTHsG20WwtSUfsmElw/G
 MahBaZBH
 sSF2JvbhFsLUaUmA5B2I8OuB1fic0uvfuFPFSwxrb5WiMZgrtJwenpLykq7zobe35fLfdXbD0YDZ9+B/jEueiH3n2gP0CP5YPaLDYyBUVeVsysWTxQhMejnkIDqpMdNtv5HPtZU1aZmixp0inPgZ+ojpG24NcBw7b7MHfwDHGSE/pshgWprdDHTjrPjT1/1UU4lRJ+FCECgImHWQaUYQ0rwqfpFba6ewZGdBnHgac919yaZEK2D8x4cVPy3/Jyjor9E3LEuHcmtkX0IEFfHMVpcEG0eXZUF0oQxtYS33Cmi8MKHmSDFxaHCn+110+VIj1lMM/kmOSJ5o6A/dvRMkE/kGvpoxrukrrz/R/BOgVC6aL77JJsuMN7Vm1xcrGodZmLg/7KG93EJih0y+NReuM7LUjAHouAvuN5u2AlRBPhAUN39/5O24Fk3izZkhN/JgXoGZWa3hUNOD3fgTKQME00Ghatsnntcw9R2dBA31OHr6hhlC1wQZYLXTQaNoPcgD2v5EXcB0DxbLOR1dOjrZ6rz46PVLSKImr6Wg6sGxeRzH7sq2dkZNHLkhtAtmh3OLJzG83/dnzCnC3NiulS71GX6Dj0G+RS0fMA9hWieR7BpykHZMfSGBTbr68a8uYHuNPo6XW5g45OiTmQ29oavF6f3VokPWUn6yusV7Ntk9Ihg47ZT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 12:38:33PM +0800, Bo Zhang wrote:
> To improve the mTHP allocation success rate and reduce
> fragmentation over time, introduce
> zone_effective_free_pages() for mTHP-aware free page accounting.
> 
> Refactor the free page counting logic used by pgdat_balanced() and
> compaction_suit_allocation_order() into a shared helper function
> zone_effective_free_pages().
> 
> The function selects the appropriate free page metric based on context:
> - defrag_mode: use NR_FREE_PAGES_BLOCKS (whole pageblock accounting)
> - mTHP always-enabled: count only free pages in buddy blocks >= the
>   minimum always-enabled mTHP order, since smaller fragments cannot
>   satisfy mTHP allocations
> - otherwise: use NR_FREE_PAGES
> 
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> ---
>  mm/compaction.c | 38 ++++++++++++++++++++++++++++++++++----
>  mm/internal.h   |  3 +++
>  mm/vmscan.c     | 23 +++++------------------
>  3 files changed, 42 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 15b92475562a..29be72597415 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2528,6 +2528,38 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
>  	return false;
>  }
>  
> +/**
> + * zone_effective_free_pages - get free pages relevant to allocation order
> + * @zone:       target zone
> + * @order:      allocation order
> + * @use_blocks: if true, use NR_FREE_PAGES_BLOCKS
> + *
> + * In defrag_mode, watermarks must be met in whole blocks to avoid
> + * polluting allocator fallbacks. kswapd usually cannot accomplish
> + * this on its own and needs kcompactd support.
> + *
> + * When mTHP always-enabled orders are configured, count only free pages
> + * in blocks >= min mTHP order, as smaller fragments cannot satisfy mTHP
> + * allocations.
> + */
> +unsigned long zone_effective_free_pages(struct zone *zone,
> +					unsigned int order,
> +					bool use_blocks)
> +{
> +	if (use_blocks)
> +		return zone_page_state(zone, NR_FREE_PAGES_BLOCKS);
> +
> +	if (READ_ONCE(huge_anon_orders_always) && order == compact_hpage_order()) {
> +		unsigned long free_pages = 0;
> +
> +		for (int o = order; o < NR_PAGE_ORDERS; o++)
> +			free_pages += zone->free_area[o].nr_free << o;

I understand that you don't need a precise value here, but in every
instance in the kernel source tree where nr_free is accessed, it's
accessed under the zone lock. Do we need to use READ_ONCE()?

> +		return free_pages;
> +	}
> +
> +	return zone_page_state(zone, NR_FREE_PAGES);
> +}
> +
>  /*
>   * Should we do compaction for target allocation order.
>   * Return COMPACT_SUCCESS if allocation for target order can be already
> @@ -2543,10 +2575,8 @@ compaction_suit_allocation_order(struct zone *zone, unsigned int order,
>  	unsigned long free_pages;
>  	unsigned long watermark;
>  
> -	if (kcompactd && defrag_mode)
> -		free_pages = zone_page_state(zone, NR_FREE_PAGES_BLOCKS);
> -	else
> -		free_pages = zone_page_state(zone, NR_FREE_PAGES);
> +	free_pages = zone_effective_free_pages(zone, order,
> +					       kcompactd && defrag_mode);
>  
>  	watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
>  	if (__zone_watermark_ok(zone, order, watermark, highest_zoneidx,
> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c9..14bb9543879b 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1654,4 +1654,7 @@ static inline bool can_spin_trylock(void)
>  	return true;
>  }
>  
> +unsigned long zone_effective_free_pages(struct zone *zone,
> +					unsigned int order,
> +					bool use_blocks);
>  #endif	/* __MM_INTERNAL_H */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1404a59523d..a419a2c2fca4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6966,7 +6966,6 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
>  	 * meet watermarks.
>  	 */
>  	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
> -		enum zone_stat_item item;
>  		unsigned long free_pages;
>  
>  		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> @@ -6974,21 +6973,6 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		else
>  			mark = high_wmark_pages(zone);
>  
> -		/*
> -		 * In defrag_mode, watermarks must be met in whole
> -		 * blocks to avoid polluting allocator fallbacks.
> -		 *
> -		 * However, kswapd usually cannot accomplish this on
> -		 * its own and needs kcompactd support. Once it's
> -		 * reclaimed a compaction gap, and kswapd_shrink_node
> -		 * has dropped order, simply ensure there are enough
> -		 * base pages for compaction, wake kcompactd & sleep.
> -		 */
> -		if (defrag_mode && order)
> -			item = NR_FREE_PAGES_BLOCKS;
> -		else
> -			item = NR_FREE_PAGES;
> -
>  		/*
>  		 * When there is a high number of CPUs in the system,
>  		 * the cumulative error from the vmstat per-cpu cache
> @@ -7001,9 +6985,12 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		 * counter won't actually be per-cpu cached. But keep
>  		 * things simple for now; revisit when somebody cares.
>  		 */
> -		free_pages = zone_page_state(zone, item);
> +		free_pages = zone_effective_free_pages(zone, order,
> +						       defrag_mode & order);
>  		if (zone->percpu_drift_mark && free_pages < zone->percpu_drift_mark)
> -			free_pages = zone_page_state_snapshot(zone, item);
> +			free_pages = zone_page_state_snapshot(zone,
> +					defrag_mode & order ?
> +					NR_FREE_PAGES_BLOCKS : NR_FREE_PAGES);
>  
>  		if (__zone_watermark_ok(zone, order, mark, highest_zoneidx,
>  					0, free_pages))
> -- 
> 2.34.1
> 

-- 
~karim

