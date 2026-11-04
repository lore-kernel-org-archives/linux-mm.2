Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73915606E822
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=PaTrJHI2
Received: by kanga.kvack.org (Postfix)
	id 94B3C6B05BE; Wed,  4 Nov 2026 15:03:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923646B05C0; Wed,  4 Nov 2026 15:03:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A5E6B05C3; Wed,  4 Nov 2026 15:03:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 562E36B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:03:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBFB680861
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:03:47 +0000 (UTC)
X-FDA: 85398512094.02.EF993DA
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id B77CDC0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:03:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=PaTrJHI2;
	spf=pass (imf28.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BgNivbmmhoO5tLBQFwSmEVuFg0Qcp+1r+afWMf1Jss=;
	b=hwBRo2zms/uzXoGtZEIf0gyDMZU03X4WG88/lrc/huKBfAtHLV1k7xKGLLPeF4Kq+d+jCI
	fbMfeQLIXY0axkFgB4XBSkLEwmPfO5I/2GxAeFWgIqm+/YxXsL0SQO02ttJDe1guGpjpo7
	VK0dwbQjnHoThRIIMUc7qcjyVX9y2RI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822626;
	b=QFfVLiPn/pqlD2l0dSqPFfDZa68CXTlnr+3B6Pmor6rU0YSclGJuXwvYnP1iDKkK1zmtq7
	IKJjjS12gQVWnw/1JYepoZBWYXNguOW6MVDz/AzQaiWiVVbXs/J6s6p84yH6o7+yvin7Ji
	Ngu9WnWn5ZDYsquz06Jv+rzmsC7Ahf4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=PaTrJHI2;
	spf=pass (imf28.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	From:Reply-To; bh=6BgNivbmmhoO5tLBQFwSmEVuFg0Qcp+1r+afWMf1Jss=; t=1793822625;
	x=2109182625; b=PaTrJHI2XDUWJaPrAkMTJuGJny2KhJdIv21KyfIjatLJadUyBOWTSGQNcfYnm
	yVcyG/TpgfR8FOpsCXxYAdyoyY6tzGxD/FTAG2qzAm/54HtErklSOimEHJC2LVkHZy0T65EdEES0u
	xdFR7MeROBjuSIXBdTijwmSZ/G+y90jk+DAX1hLS+8pbMDYJqcQzvhKGpjynD9yhK45zRUSjL/vfX
	CIXYm5WUKSIWWZg9fAhU7SXS8/SVV2SVnjBwXCf57dLMxeSDymLnh6D++taqKeMpCFEZ4DHbseLEg
	Jt1qxi77aAQQKC3MqUD0N4XAvnsmozPQ/zvxSVMrqP47GQQbyA==;
Received: from 179-125-72-1-dinamico.pombonet.net.br ([179.125.72.1] helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xOhCh-002cQL-Rb; Wed, 04 Nov 2026 21:03:28 +0100
Date: Wed, 4 Nov 2026 17:03:18 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Frank van der Linden <fvdl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, vmscan: make kswapd unreserve highatomic pageblocks
Message-ID: <auuPhqCcgZBt_lUR@quatroqueijos.cascardo.eti.br>
References: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ucr5zycr57k8rcqkwxw4hzxs6fgqtseo
X-Rspamd-Queue-Id: B77CDC0008
X-Rspam-User: 
X-HE-Tag: 1793822625-861866
X-HE-Meta: U2FsdGVkX1/rhgMUVwwVbxqdqs4Ab2N3ssi2I9Z/k4ltefEQxWrMuV/2L922eRlik+tZu7U216C6rWOnD6+OdC0iH9lvWb2/AkH1fZeWbdUac9ykAks3Zi1P7n69AagGAoTO/w7bjul3pm2dPca1mdNmio7XfMBYfcdj9Vadbcu6znPx47/8KQk6luInIELlEEWIoapLIA5C4tG30SBFywRUcxZULdIBW6GS7oeSl5brqdYd2semBFuOfHAq6MHRetIU01UOZmjGUtoa+Ofo6Y2HVnviFKxhOTbkEaUCu3ni64UuYnyBxrmXOL2mKxahv8ue2e5IJIvHZQ52JvsTNxgTiiYsFJ/TQVulxgFtQT9xvHdc/7ajMmQv9z0zR6Y5i9YCsIQhVTn+m8LSJHpmzHVQHOvcGn29ohSzItogkJm23Rbusnh6Bl/nCT6PdUU9LZYoNYLVJRCmMsn2ogMZJDnMmHfPB7UotbxaZ6pCskeEnH6ume63X3/SU/qG82fHY7qbNRegN/si7XH/4dL9eR+6aRcBZnRDO8eK/wAbS2yAF7lTIzlV8aKuKjumnFNguElC8uAk7DT71s24NTxXcradEui9c1+0ZX+kUekeVpUYl/zFyODhjY4QqOzD+SQYBArZfP5R6p2VkPZbNzxMWi+oHRWugvc7/CQdWWkjQ9++hrFVB2sHP7Zm/nLtXzYaeoJI03MjuvDBpJi7RtME6m4ggqPD8AAJwPosn7zutufRKTx6hihJo59jG9XyxYI1SdaE/x0h0iw6ArffT3lSsnsf3oPvQsw0eQTDA7x6O3xUXs0PRvPO+2xrXKqAkiFwhcySjF8QlzVcWOejFJMdd2oqaNiz4LPGl1YKXOVTUoNmOXNAc2fOpcPYPLVPpmNpKM2yrgKo2Hx0gbDgiRMTp7HsDiUHzM2GSH1+rywx5MpXomkfFPn7fwMQ4q5XeG6VCUy0s3l22dD8nO9+P9o
 xNa1Fy3y
 lSzi8tWqMh2yCm2cU30tWbbeT29BGTj19Fw/OMge/EMtw2sfYtjz4TW9AIQ7Ou7EnKkNMqritn4MKAM6/Mo+5XQrZUXtZ3A/soRuPcFFcVF6/nvBSQ4fh7eXz+eCIsowMosGphbzv3cCuhz2+QHeWGhePOWXrv3hAa2ZSFEa9YMc4Nzq6AVh+0XF63S30G9TGowsNsMLKEudQ3flmL38RDbjoqVOYNd3/3uekYlnM1QzACj2QMPoJ8PcN2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 07:38:44PM +0100, Vlastimil Babka (SUSE) wrote:
> A customer has reported excessive reclaim activity despite memory above
> high watermarks. Analyzing support data (including sar log) revealed the
> following scenario:
> 
> - the system has almost all memory reserved as 1G hugepages for kvm
>   guests, and operates normally
> - due to a spike of memory pressure from userspace, highatomic
>   reservations occur (probably due to e.g. concurrent network receive
>   activity)

I think you might mean 6a204d4b14c9 ("mm/page_alloc: only set
ALLOC_HIGHATOMIC for __GPF_HIGH allocations") as one of the fixes you
mention below.

In that case, GFP_NOWAIT (which is typical for network activity, AFAIR)
would be one candidate that would produce such reservations. But I agree
that if any other real highatomic allocation burst would happen, it might
produce such reservations.

> - on one of the 8 NUMA nodes, this creates a situation where free pages
>   are above high watermark, but when __zone_watermark_unusable_free()
>   considers highatomic pageblocks, the result appears to be below the
>   low watermark
> - pgdat_balanced() is false, kswapd hopelessly keeps trying to balance,
>   spending cpu time and disrupting the system. It has nothing to reclaim
>   because the node is filled with hugetlbfs hugepages.
> - since the overal memory pressure is under control again and there are
>   no allocations restricted to the affected node, they are satisfied
>   from other nodes without going through direct reclaim
> - since direct reclaim is the only code that calls
>   unreserve_highatomic_pageblock(), this never happens and nothing fixes
>   the situation
> 

I am trying to understand what is going on here: so allocations on that
node are only !__GFP_DIRECT_RECLAIM? That would explain the highatomic
reservations in the presence of the bug just mentioned.

> Note this was observed on a 6.4-based kernel and there have been recent
> fixes upstream limiting the highatomic reservation side, but I don't
> think they can prevent the same happening in mainline, only perhaps
> lower the chances. Nothing seems to prevent the issue completely.
> 
> For example, while we limit the amount of highatomic pageblocks to 1% of
> the zone, this calculation does not subtract the amount of hugepages or
> otherwise permanent allocations, so the highatomic pageblocks can end up
> taking much higher share of actually reclaimable memory.
> 
> The most targeted fix thus appears to be to allow kswapd perform the
> highatomic pageblock unreserve to match direct reclaim. It's also
> somewhat similar in principle to how kswapd reduces watermark boosting.
> 
> Hook this highatomic unreserve to the moment we are increasing kswapd
> reclaim priority, as that is when kswapd is struggling to make progress
> and it should roughly match the case of direct reclaim failure.
> 

I tried considering a different approach, making the allocation do the
unreserve in the absence of __GFP_DIRECT_RECLAIM, but I don't see why not
let kswapd do it.

Regards.
Cascardo.

> The only caveat is that direct reclaim knows which migratetype it wants
> to allocate and thus changes the highatomic pageblock to. Kswapd doesn't
> track that, so use MIGRATE_UNMOVABLE. Highatomic allocations usually are
> not movable, and this will avoid creating nominally movable pageblocks
> polluted with unmovable pages, so it should be the least problematic
> default.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> We interrupt the regular stream of AI fixes by something a bit
> different. RFC to get agreement on the approach. Haven't tried
> reproducing the issue in mainline, but it seems quite clear to me from
> the data I've seen.
> ---
>  mm/page_alloc.c | 126 +++++++++++++++++++++++++++++---------------------------
>  mm/page_alloc.h |   3 ++
>  mm/vmscan.c     |  16 ++++++-
>  3 files changed, 83 insertions(+), 62 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a8cac5e01066..785a13570788 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3476,6 +3476,68 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
>  	}
>  }
>  
> +bool unreserve_highatomic_pageblock_zone(struct zone *zone, int migratetype,
> +					 bool force)
> +{
> +	/*
> +	 * Preserve at least one pageblock unless memory pressure
> +	 * is really high.
> +	 */
> +	if (!force && zone->nr_reserved_highatomic <= pageblock_nr_pages)
> +		return false;
> +
> +	guard(spinlock_irqsave)(&zone->lock);
> +	for (int order = 0; order < NR_PAGE_ORDERS; order++) {
> +		struct free_area *area = &(zone->free_area[order]);
> +		unsigned long size;
> +		struct page *page;
> +		int ret;
> +
> +		page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
> +		if (!page)
> +			continue;
> +
> +		size = max(pageblock_nr_pages, 1UL << order);
> +		/*
> +		 * It should never happen but changes to locking could
> +		 * inadvertently allow a per-cpu drain to add pages to
> +		 * MIGRATE_HIGHATOMIC while unreserving so be safe and watch for
> +		 * underflows.
> +		 */
> +		if (WARN_ON_ONCE(size > zone->nr_reserved_highatomic))
> +			size = zone->nr_reserved_highatomic;
> +		zone->nr_reserved_highatomic -= size;
> +
> +		/*
> +		 * Convert to migratetype and avoid the normal pageblock
> +		 * stealing heuristics. Minimally, the caller is doing the work
> +		 * and needs the pages. More importantly, if the block was
> +		 * always converted to MIGRATE_UNMOVABLE or another type then
> +		 * the number of pageblocks that cannot be completely freed may
> +		 * increase.
> +		 */
> +		if (order < pageblock_order)
> +			ret = move_freepages_block(zone, page,
> +					MIGRATE_HIGHATOMIC, migratetype);
> +		else {
> +			move_to_free_list(page, zone, order,
> +					  MIGRATE_HIGHATOMIC,
> +					  migratetype);
> +			change_pageblock_range(page, order, migratetype);
> +			ret = 1;
> +		}
> +		/*
> +		 * Reserving the block(s) already succeeded,
> +		 * so this should not fail on zone boundaries.
> +		 */
> +		WARN_ON_ONCE(ret == -1);
> +		if (ret > 0)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  /*
>   * Used when an allocation is about to fail under memory pressure. This
>   * potentially hurts the reliability of high-order allocations when under
> @@ -3491,70 +3553,12 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
>  	struct zonelist *zonelist = ac->zonelist;
>  	struct zoneref *z;
>  	struct zone *zone;
> -	struct page *page;
> -	int order;
> -	int ret;
>  
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->highest_zoneidx,
>  								ac->nodemask) {
> -		/*
> -		 * Preserve at least one pageblock unless memory pressure
> -		 * is really high.
> -		 */
> -		if (!force && zone->nr_reserved_highatomic <=
> -					pageblock_nr_pages)
> -			continue;
> -
> -		guard(spinlock_irqsave)(&zone->lock);
> -		for (order = 0; order < NR_PAGE_ORDERS; order++) {
> -			struct free_area *area = &(zone->free_area[order]);
> -			unsigned long size;
> -
> -			page = get_page_from_free_area(area, MIGRATE_HIGHATOMIC);
> -			if (!page)
> -				continue;
> -
> -			size = max(pageblock_nr_pages, 1UL << order);
> -			/*
> -			 * It should never happen but changes to
> -			 * locking could inadvertently allow a per-cpu
> -			 * drain to add pages to MIGRATE_HIGHATOMIC
> -			 * while unreserving so be safe and watch for
> -			 * underflows.
> -			 */
> -			if (WARN_ON_ONCE(size > zone->nr_reserved_highatomic))
> -				size = zone->nr_reserved_highatomic;
> -			zone->nr_reserved_highatomic -= size;
> -
> -			/*
> -			 * Convert to ac->migratetype and avoid the normal
> -			 * pageblock stealing heuristics. Minimally, the caller
> -			 * is doing the work and needs the pages. More
> -			 * importantly, if the block was always converted to
> -			 * MIGRATE_UNMOVABLE or another type then the number
> -			 * of pageblocks that cannot be completely freed
> -			 * may increase.
> -			 */
> -			if (order < pageblock_order)
> -				ret = move_freepages_block(zone, page,
> -							   MIGRATE_HIGHATOMIC,
> -							   ac->migratetype);
> -			else {
> -				move_to_free_list(page, zone, order,
> -						  MIGRATE_HIGHATOMIC,
> -						  ac->migratetype);
> -				change_pageblock_range(page, order,
> -						       ac->migratetype);
> -				ret = 1;
> -			}
> -			/*
> -			 * Reserving the block(s) already succeeded,
> -			 * so this should not fail on zone boundaries.
> -			 */
> -			WARN_ON_ONCE(ret == -1);
> -			if (ret > 0)
> -				return ret;
> -		}
> +		if (unreserve_highatomic_pageblock_zone(zone,
> +							ac->migratetype, force))
> +			return true;
>  	}
>  
>  	return false;
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index e238ee91ed24..9fba6480b18d 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -282,6 +282,9 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
>  	return list_empty(&area->free_list[migratetype]);
>  }
>  
> +bool unreserve_highatomic_pageblock_zone(struct zone *zone, int migratetype,
> +					 bool force);
> +
>  /* Convert GFP flags to their corresponding migrate type */
>  #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
>  #define GFP_MOVABLE_SHIFT 3
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9959ca158ce8..91c622068d99 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7460,8 +7460,22 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		if (nr_boost_reclaim && !nr_reclaimed)
>  			break;
>  
> -		if (raise_priority || !nr_reclaimed)
> +		if (raise_priority || !nr_reclaimed) {
> +			/*
> +			 * Similarly to when direct reclaim is retrying, try to
> +			 * unreserve highatomic pageblocks on the node. Convert
> +			 * them to movable ones as kswapd doesn't have a target
> +			 * migratetype, and passing unmovable should lead to
> +			 * least permanent fragmentation.
> +			 */
> +			for (int i = 0; i <= highest_zoneidx; i++) {
> +				struct zone *zone = pgdat->node_zones + i;
> +
> +				unreserve_highatomic_pageblock_zone(zone,
> +						MIGRATE_UNMOVABLE, false);
> +			}
>  			sc.priority--;
> +		}
>  	} while (sc.priority >= 1);
>  
>  	/*
> 
> ---
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> change-id: 20261030-kswapd-highatomic-unreserve-7e6629ec65d0
> 

