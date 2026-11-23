Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F51606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a8V4yGNy
Received: by kanga.kvack.org (Postfix)
	id 7E9096B05B0; Mon, 23 Nov 2026 08:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A976B05B1; Mon, 23 Nov 2026 08:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664106B05B2; Mon, 23 Nov 2026 08:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8FD6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:44:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD672A84F7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:44:39 +0000 (UTC)
X-FDA: 85466503878.18.D2F5048
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DAAB5120004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:44:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a8V4yGNy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441478;
	b=ejx7zGxk8KwXUYt2Y5asnIKj30cQLmuLtjbosZDsmsiOuPE4Sjd/Nx7C6GfrD5T2gdl0em
	pHe8Na6p0d29B0AvWEC/o0Q9M5jW4JLMotpGAvmID62yZZghrwLImLR9svO7/bzdX7+3oc
	BVNI1hibOzZN2urk4zS90cm5pj6tbXI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aeATg/C6+u5WbdgJDkkdrdcdGDGBApcx6FQ6+a1h6zs=;
	b=NcCGSWoEZKiOPVwSvcQ6BhPLOMH94ZomtxA2JVNiDJuvaEC3A5qxVRKIHRvN1QKUO6aSTz
	/FJV8cZzo/SUmftjJLgCwN3aTvwamLRX9lpwCGlJYEhVEKd6+Hti1GGleper7ToEyvPFQZ
	jhlsaTwrE0kYCtPTdPClS2vPYtOuN5Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a8V4yGNy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 18CBD4099A;
	Mon, 23 Nov 2026 13:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976781F000D3;
	Mon, 23 Nov 2026 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795441476;
	bh=aeATg/C6+u5WbdgJDkkdrdcdGDGBApcx6FQ6+a1h6zs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a8V4yGNyzyn8nZxCZhrrGdrQPGa6IeAIFbjZII6EVAC1MZGZSZr2g5+U6nnlmmqnt
	 DxP5Na6TH0ADJiHPtmWxPzIkGJ2qa3H/COi2GY+I2PBSbD2gZHygKbpk0pf2bf/BJR
	 U87WrL28YRDos7xMPVRV/I90xVLrWodB2MdlGLafAGKPAJ0hU2udI0NKPCsWUOGkRv
	 ImfbioFaIC/TjhSn3ONnXXgZ3qSvwA7Oz2MhRe1TGoTAlSmyr6yTATyREjNQjckree
	 er9v0/WKAXTX1CKu494iOEZq2AWk/+jIaN+fM4jk2wXnZOFB5/rFlU8Awu1lU7sHc7
	 AArSB3Uvw81uQ==
Message-ID: <84ba8739-1f1c-4838-b607-e6181fe55002@kernel.org>
Date: Mon, 23 Nov 2026 14:44:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/vmscan: consolidate promo vs. high watermark
 checks
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261118230539.3789231-1-joshua.hahnjy@gmail.com>
 <20261118230539.3789231-3-joshua.hahnjy@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261118230539.3789231-3-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DAAB5120004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: fosnf45aytdjeenqj76f7qbzo8ed3ixh
X-Rspam-User:
X-HE-Tag: 1795441477-420192
X-HE-Meta: U2FsdGVkX18yGgTSLBTsFhLySl9cRfBle8uofOXgAWzegqvcm9jKDMbwLh6DM6C/eBP2xw65pLZhbG6Tr8IZSyml2ZVxKkdxhWIvYUCFBEibWqZA5GgYhNCmJ8OX1Kz27ZgoKGHQNjcmLEYwzaB/Ma2Ai7LPqJLBBxGztBMkfFI+F3Wu9vMfpf8xUFJ2NZNtXYQm+Rl519oyPNzffJ7Nd7jeFKvjajXpuO6ZJYFzrWDbn31hQqZwXHmhq8+LcKdYaNacKow3C604Nh5YjifqietkE1Lnt2npDtnQjERGAl8mgmOx1oHiCa92XTF9mavb7c19crWSfo9MZv6CvFQKcvIDzqLYSGtUB5risWy2dmsx0liy0FgfIVlnnYhPAnsM9byC7pXRiZDTKBM0NMpwyIRKcmNibwVfFgswpeAcvv+UTHk7nPukjTMNs2MxPVzIwL0iEWlj/b715FsyW34oQexoNHMYQZsQj1reCYuwKYAJn8rmgRWGr2Y9rNjegMZZFcw45hN2S+3MwsvryxHnQlpYFHQ7VNjx/dgMqjeuu9/NT5UL+2+/J/2BfSqM4CsxD+g4kF6fFmaOk4S5u4P/WlA96wwoapdiCRhOBTXh1Mzgn/CTm2dblbO8lq/HoaHyvrDEGSeoqfPahFed24wKdbs5uOaSbuZ5OazviWLZMaVZpP9JH5bkBzwMAB6IONHRVWrrzaraoePFyqUjMl6KBNYBDatmDfaWrBI6k32deP1gqsqBoC3SinmFvPM0e5QKUXf36fb7JBgEmLBUDrmZhlXOKYQd1dSplRCuoPjAsKc/AcxcLd48hg+6MCjWp8bG9VVxxEN4xW1vbf+AqwKj5hFqw2SOvuTmNOgdxs+gGQ50+Y90qKzaYqiw9ctd9EcS2Pzc2VGbELNFynElCdIhmdtl8KrH3v23jeYvuTpcMpTEnM3pWyV7qfP0XryRhIRREGzn0LG4b8S59dBKnDI
 aUwymSgB
 o6YL7ltE1LI4HGZEGnFuvfsO+5KHZz69ZYEidJ4c2ZnOE4Y9HwZXaDd5R1WUpajWtvDnk5n1lnx/aVkkSeUdBYEEJI5wrCsEYjC7opsAZ2UIVEKHEc9Vp8DsQ/lqRgcG0Tg3MdY4BUg3zGpiUKKXsR9Vl/ct9JzaNlAndf282A1eY52ChE0BjfczIIR/9OLzv9wVmwUOb3fZqnYIJ/qyE+vm4C+VlRUCWnH0WSg69TIEOqJ/XBn+R4eCDTEnY1Hx6SwH8NBSPG706mWEuEDTZsn3LXbJQSFOODbKJeo1YnBfUV6hRXRZIT/jS36LerwJL3M2mUdLg7MSQi9qYMgypDZGyQwDd7f37ZHbmLY33ImR4WZtOqsW23pBIHe4ByhG8wmYt0uvYzeNy1/Q6XuRiTvWy9ZRO/Q8505DPaYVw517Vy74vyVvm1I2yG0VHFSwFEFCkKcydvN+4aBRlddS08cFhIomst96sC1f5IHByoszXUnfjHrclPgBcsq1KLHC8C62JJOt8J26QOQ/Lc3GA38xf+IW6pCHlXjIjPvZUTAMbSWmdssJuW+vqlLPVJvqn6nKeOURKy/+peJrSZoo48BjPP8Ilc8Q9bXP/LMqG8jP+kyVQdNvxlELAy3WSVtD0MsTFVmMkTTS9WvFmnJrIikqxWdBtFCKqmAyoqI0DVFipkLCDEgxIau6hcpScK7MMbrlBupGqHnepVCn3zlCQ4/6spYs1Sj18uv6TI9mUVkmPKSqur07E9Cuezw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 00:05, Joshua Hahn wrote:
> There are three sites which all check the watermark that kswapd reclaims
> zones up to, which is the promo watermark when NUMA balancing memory
> tiering is enabled, and the high watermark otherwise.
> 
> Consolidate the pattern into a helper function. While at it, remove the
> include for <linux/sched/sysctl.h> in mm/page_alloc.c now that the
> dependency on sysctl_numa_balancing_mode has been abstracted into
> vmscan code.
> 
> No functional changes intended.
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Tested-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/internal.h   |  1 +
>  mm/page_alloc.c |  6 +-----
>  mm/vmscan.c     | 22 +++++++++++++---------
>  3 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 566cbd2dce485..8beb5b263ca1f 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -68,6 +68,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  				gfp_t gfp_mask, const nodemask_t *mask);
>  unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
>  			      int zone_idx);
> +unsigned long kswapd_wmark_pages(const struct zone *zone);

Can we inline it? Seems wasteful to make the allocation fastpath call to
vmscan.o just for this.
I'd probably put it in mm/page_alloc.h as we're trying to split out the
monolithing mm/internal.h
It shouldn't be a problem to include include/linux/sched/sysctl.h there for
sysctl_numa_balancing_mode, hopefully.

Thanks.

>  
>  #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
>  #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e7a7863e381ab..31a670eb4832c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -45,7 +45,6 @@
>  #include <linux/mmu_notifier.h>
>  #include <linux/migrate.h>
>  #include <linux/sched/mm.h>
> -#include <linux/sched/sysctl.h>
>  #include <linux/page_owner.h>
>  #include <linux/page_table_check.h>
>  #include <linux/memcontrol.h>
> @@ -3805,10 +3804,7 @@ should_skip_kswapd_zone(struct zone *zone, unsigned int order,
>  	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
>  		return false;
>  
> -	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> -		mark = promo_wmark_pages(zone);
> -	else
> -		mark = high_wmark_pages(zone);
> +	mark = kswapd_wmark_pages(zone);
>  	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx,
>  				    0, gfp_mask);
>  }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce83..9af50783fc824 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -478,6 +478,17 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone
>  	return size;
>  }
>  
> +/*
> + * The watermark kswapd reclaims zones up to. With NUMA balancing memory
> + * tiering, kswapd keeps room above the high watermark for promotions.
> + */
> +unsigned long kswapd_wmark_pages(const struct zone *zone)
> +{
> +	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> +		return promo_wmark_pages(zone);
> +	return high_wmark_pages(zone);
> +}
> +
>  static unsigned long drop_slab_node(int nid)
>  {
>  	unsigned long freed = 0;
> @@ -5212,7 +5223,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
>  static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  {
>  	int i;
> -	enum zone_watermarks mark;
>  
>  	if (unlikely(sc->proactive && signal_pending(current)))
>  		return true;
> @@ -5224,12 +5234,9 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  	if (!current_is_kswapd() || sc->order)
>  		return false;
>  
> -	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
> -	       WMARK_PROMO : WMARK_HIGH;
> -
>  	for (i = 0; i <= sc->reclaim_idx; i++) {
>  		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
> -		unsigned long size = wmark_pages(zone, mark) + MIN_LRU_BATCH;
> +		unsigned long size = kswapd_wmark_pages(zone) + MIN_LRU_BATCH;
>  
>  		if (managed_zone(zone) && !zone_watermark_ok(zone, 0, size, sc->reclaim_idx, 0))
>  			return false;
> @@ -7131,10 +7138,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		enum zone_stat_item item;
>  		unsigned long free_pages;
>  
> -		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> -			mark = promo_wmark_pages(zone);
> -		else
> -			mark = high_wmark_pages(zone);
> +		mark = kswapd_wmark_pages(zone);
>  
>  		/*
>  		 * In defrag_mode, watermarks must be met in whole


