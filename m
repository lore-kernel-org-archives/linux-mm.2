Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0AE9606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=g0n52dAO
Received: by kanga.kvack.org (Postfix)
	id 13A6D6B05B4; Wed, 18 Nov 2026 10:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112B46B05BA; Wed, 18 Nov 2026 10:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A326B05BB; Wed, 18 Nov 2026 10:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D03E76B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:57:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 713D8140794
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:57:24 +0000 (UTC)
X-FDA: 85448694408.27.27A9F44
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 77114180007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:57:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=g0n52dAO;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795017442;
	b=RqKr6q3q5sGBr/mYMRgASe5PEZ/Mf1SvCq0yH1jgM5tCmpNybHPyrH7iJzOygE+C0gAdea
	h1GrTvKI1su0VV5MXMOMzSNUvo5PYsYETvGd4S8XTDNO1B63aCVPocX+fOL1xGbpB6y9vq
	D4en3/B39C0mHr4Vg6NucvdKUkg4DHQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=g0n52dAO;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795017442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKXyYdXEIrl9wXJLW3IWBVcu7N8UHhxwJAb10Vz4gsY=;
	b=z0QIEu/xthbT+BrAwnUiA5KiN7sy9euPuxyi3R8KOtCLM84P+I92tmqEroj0jrGKb5teYZ
	sHAkZ1k4qFxo0oP2jwfufDVeCIXVRmHo+HPkR4cuUFolnAWG6cfiylbJJx/a5wT49Fsg2x
	zaXkp/GNrl+claZMGZHO4kBY9XcCMyM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65C04339;
	Wed, 18 Nov 2026 07:57:18 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1441A3F632;
	Wed, 18 Nov 2026 07:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795017441; bh=27Z82//x5IJjvNfiCnD9RSWBkqpaK0b4bZQs4O+BDd8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g0n52dAOWxfruPOCCgDFQmbzbJt2Bd2gTv/xYYpqWJrDb4cuetsMwmMxqrU8qdlEb
	 fbqUFicH5cFJ1FZPYXVeih+/HLpcOCU7nsIvFKioK0PI5EOc3lpofyCL3XmJ9gvJnl
	 5vL7RLFACVpZi5yfZWGs4Po9RLcq4SXq4kf7Fqtc=
Message-ID: <9e327000-afea-4f6c-8121-913301803233@arm.com>
Date: Wed, 18 Nov 2026 21:27:12 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/vmscan: consolidate promo vs. high watermark
 checks
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
 <20261116232346.788145-4-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261116232346.788145-4-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77114180007
X-Stat-Signature: hhrzj6djxwygum7ftmr8gixcfi1bin61
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795017442-279639
X-HE-Meta: U2FsdGVkX191D2HSvVi4F1Aith7kj0/Z9Rv1Snb75/wpjjM6qzlzQFU9ixP4USzBNZ1tS8c9x1hHLxLuqLv34Ox+WxhReUeFgvIotYUvLcqGbMuwlKZOjPISWbTUFHuIIFdh5imWhv/17gJfyqVkDsbon5aSJ8nzuldjOghIXeyeTGxm9KCXpjHvgC/AmW5oi+rnUvkD/TuaPjotdwzhBEx2hm64mbeNTh9tOuRq3kz/u8gvLgpjWgTFLSJnEx7CBTVUa1gI0Sjs2s7ywzt4ihnQ1x9xnO2PU4Yd91cY4dls34scu76vkezaX29vMz3U/CGzGtykP3A4Ch8WzNO0tvj9cFrUm5dbiclk3DIN7BfiS0aBDlOKGUlrkjPvqX/IjRdKuKoP4n60ETPfMAwEyXC0rErA8OPQkxXgXGdx7vC6wz0KNDiT9MzWLJhnStrnUdZlE0MJJ1rT6vAky57blnnHNnOPDqCPo3cYg/VMurmW8851lm116K0+fGR0/Tw6UaE/ufBS2yeDaakYgf4mGS1eprIf5ggu8TtPq/eMZy65i/zvT7hxv71IZZiiViU/DjGxXVdf9+ylW8tyrymSknmcMHWRmKGJhe/2RqMX7VPp63VMJf6Fojp9+niJ06cRqK6Xq92X4GfVKVsKu+Wp8ELSq8NN3eyVvl+xptU8oCbzPT5Xyuy1JgH8Hbqaf2PgliBlK7CNwmCMLOrmqavTiYrmqmfF6T2VL5PFVYedDCk5mcXNMFUbxZC/TYWvLZDFi1fJpVevFsMkxmMDyGzGkKyb1uQwO3/0uRhEEqS3dqDD5FMKI43thpODHzlR5K4EnYvkcrKak8pcA/9TYXxySUSDL02AICZzfQGy+6Gkzaj5LjPL575AlGl0wiYghOfU65QIbDiosovH3kCV8V49M44gi8oDu4GXiyuxEj2h3Gd+2T9F5ZMMeeOsySnUsAv/9M0WMxYMRX8+q0M6mj7
 hBAfRGVd
 GhEPvDJr3/rQhiARDGyDEe3wPduXrDKjp1qq3HOCN/ehD1XHo/8T/vdWy+Z+bQA6vdOlVb892QCzjfl4xkfsZjPwL9h7kjbpkNlqkWhtRb/UAiMobRkBHW463d1iFjbqteVvVRIo39BIW51VCHed7PJWiuFdAsY9IuL+bBGjlk9LmGuypS5jxPbC9P0vj0LMBIiRzz47h3WiPTV2eoCsyVvAg17ydFoqRtyf1TirVwMF2eN5O9JYACXyUnnJuZFWpvdcAA0IjETxYtd7a94pJ2ZbEr9I5ibaxgffm8Zjb93z+2OAr0EctHG+tBpUw2+MDCiPcBIvW0Y6Edsh3CjkICC7rfoJeerOTIxm6LzqmoZuhWmkRlP1ylBO3ak8gI1clms7qJBguHWXedGPAp2th6p6Y6X3C53jZ1l3+PhLoxIDp8XsJSKgkwTXl2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 17/11/26 4:53 am, Joshua Hahn wrote:
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
> Tested-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


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
>  
>  #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
>  #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 43929faffb989..d7320566a9509 100644
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
> @@ -3804,10 +3803,7 @@ static bool should_skip_kswapd_zone(struct zone *zone, unsigned int order,
>  	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
>  		return false;
>  
> -	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> -		mark = promo_wmark_pages(zone);
> -	else
> -		mark = high_wmark_pages(zone);
> +	mark = kswapd_wmark_pages(zone);
>  	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx, 0);
>  }
>  
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


