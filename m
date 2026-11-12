Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54B1606A331
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=uB8oXxc7
Received: by kanga.kvack.org (Postfix)
	id 0FBCF6B05B1; Thu, 12 Nov 2026 12:05:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2B66B05B2; Thu, 12 Nov 2026 12:05:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D236B05B3; Thu, 12 Nov 2026 12:05:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0F3C6B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:05:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5538F160637
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:05:46 +0000 (UTC)
X-FDA: 85427093892.22.7DDD66B
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2B6E34000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:05:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uB8oXxc7;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794503144;
	b=NfidYmZp3fNlwM+Rv0/KdvCx24fW6mIUtvMCEH2Z6w6KYR/QPCJlK0fqvGdA2LeBce5Gw8
	Vj39Wg9Ouh8fpHDdiXukFQw126yEpGZUt8tLJYnX4iQ0uhwyVgdJ2CAZAbJio4YVpr3aRi
	fAfRamrRjjMrBoYbm8wsVl6nR7tOzM8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uB8oXxc7;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794503144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajEkIDRsMbSYP9W1fSmDVGsJqeBJMiTtjhcoDQq9P8E=;
	b=8CkKbotzXSDvWLLuCnhn8X9JszlHXTrfjk20Zk1YPMdmXnh0q0MjxljW8CuCH+pOTl2YLG
	4mYc5jZLMOnSZClUVAzCOfoXiiFuRts0+jfiuB6j5g5rBykJG/DkF09TvPYoKOOF0T/f3g
	SyupTcsPL3TzApf13Bv3mYTcNfNLfsc=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b335eeb340so1074697b3.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794503143; x=1795107943; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ajEkIDRsMbSYP9W1fSmDVGsJqeBJMiTtjhcoDQq9P8E=;
        b=uB8oXxc78goL1IPSaya5S8bjDMy2PymWabKGqa1MQOvo8Rg93LCR6YD3cpTRkRZDM9
         sitXMGGy0/seTyS+IgN3TKX8HqCHQzR0464z9px5//sgdPfB+JwrHHvP9soE1LiVKLXJ
         8cc9W6fJFq3K0N2gLeAdti/vOt0KEyyOasRPdPpa3IpNn1yTexYB67MBOXaxUpZdwYHw
         IcunpommuKDludPbY5SNHsd1Mxz0q9o9Ns78O7mSZhvuz3SVC9sHsV2oH2IO8ZvS8Uss
         wOFCOZNahjNEx5xzYj13iHVYsaPQPgd6br5k4AIa6W8W1EN0YL/IBdjAyydcjE3XAR6K
         twzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794503143; x=1795107943;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ajEkIDRsMbSYP9W1fSmDVGsJqeBJMiTtjhcoDQq9P8E=;
        b=c41BpOWyccaMk5SlrUyIRs4mZ6s6kH4bcSCwx0QHgV8soeM/Z+ANAOtebsRnqjW5G5
         DjEZc7eZfNtL/H3C5zR1jm48QVCSXTZ4h2q9LmCKejIMAGoUWY8MNEiKm2HaCc4RyeVa
         xQsA0318NG/S6BE1yb8YispIsHW09C/jctO2QNzMpNS07cti5B/pbxgtHD0ig7ZaduX+
         KNM1ijVenV/nzrDWXEdwxwttHu9CpvvoBUlL6tKAyog2DuUI6m7jlMZMa9yI2qyBNb1j
         t5f1GqqALjN9lQvPPmhSI95fXzBAiZ2N+sSNlbnP6VEWs8fXr8YjLkQh99prl2ZsKzF+
         rdxw==
X-Forwarded-Encrypted: i=1; AL+hErEgeg0ulz/uX0uPI0vijo9zxaUB0nY06BCqugJSM7gW41HziJLZEZBlIa2joMeZPkpVvdKu0OmOaQ==@kvack.org
X-Gm-Message-State: APuU4Z8FtOfaCac2qbyhn/TWn8ztunnGG2x2MpDeIPLyIznY/YaVI5rN
	2JCesDWmf1Wixf2i9oswsp5sV3X128RVZbdyCeYcZg20wtKfeYKJw7tEaBIsG5k8Aio=
X-Gm-Gg: AYBFou01i7VaoZqslYfvGc9eJ1Xg4Px2JVuRUgQV1mamaho5SjLQJDMut8upL0yn4ra
	L+6vN2abqxQSRo4htbJBrO8lP6SM1n/RWsuMMLCMFUj7sC1/eWzpNatcBOOky+07qRbpqTG4e71
	qKnTffg3nq/7U+KEtykUrn8UWeoS9nCQlH6mMiTmrJLkWKgd2HV6z4QwuwtVSZsURLfmpO6/jcK
	yj6fQ3gzWlS2vQFR767QUZvK/gOHgFJhKOsHmzjlNqoz6ShAAscJGeN26dxQdRuj4rCP6E86hUi
	17nKd2+hMeW22CvmlOtBRBiYayoSsJoEuE9n/FtIvzq1KPm3mfGdWBJ0UTdLnVXp9oGK22NK7gw
	LRp+FYgshlu1cu83m39olLpCxLB9PyjNSM1TmA1AKm8ho7igSttMcDDfYZn8ITKsQFF4W5qb8ff
	Av0BTA+uvK5xcrgSztBusITV+xQsFD/R7SrqPGZ+TTzt1yR7GviP1IJr342nWloamieC+j4dvoY
	RdtwI615uJ/SjqU8dcsW8u65DnZrxps3sInpDOGG2SZe1oCh0zmoT760jpLWBIKA6DnUO77b9QL
	+J12rRfd0rWKpVR+yMihgRVsdixL
X-Received: by 2002:a05:690c:f96:b0:8b3:5f41:3c16 with SMTP id 00721157ae682-8b4aa0e029dmr1440637b3.8.1794503142921;
        Thu, 12 Nov 2026 09:05:42 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa9da90bsm201707b3.37.2026.11.12.09.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 09:05:40 -0800 (PST)
Date: Thu, 12 Nov 2026 12:05:36 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
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
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm, vmscan: make kswapd unreserve highatomic
 pageblocks
Message-ID: <avXx4CYde8zIelkK@cmpxchg.org>
References: <20261109-kswapd-highatomic-unreserve-v2-1-6587ca75c77f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-kswapd-highatomic-unreserve-v2-1-6587ca75c77f@kernel.org>
X-Stat-Signature: zhm6ogpx9udfep1ne19pmt1trww8djt8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B6E34000C
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794503144-816244
X-HE-Meta: U2FsdGVkX1/6ByWd6m6Q/gI7+mNKm7yOil6PXAv4XRYeF7RDBlFyrunCMHkbOYjDBSSKEvTEQ9wG8LfjOhDjPGI/Q4bjE/h7OTJ/CogL5F9DrUHHTPCM5H77R1E9tNwLSlnKA308fuHN7oUGHkmi8qZAKIAgIvkqC/Lp3icE+D505XfIIgwIqhvhnUaaGvrBfxPmLQEPq0cz/xRIU2M87RnynJs4VklWGaj7Z2+GHIv/6J9nkI+8EvVosohO21S1b/HiGFEzBSDEGW+SUWbR127wsbmrCnhsfXNvMyqLEY2SoDPrde/6vMb1ljEBGWHGLZKpaSSjXksTBkB5cc966m2/i3q2q7bp9dZ9IUfuKxEcBL6NqlAni7Y/fBNT0210iE+6CwazYi8C2GiRQSzeUHDJyRh9gX+/4dkl+/XWJYYF4GOMyQouJhxJBDUVrBmeUEqdxXgJRZBOe1isBY63jKjbuWwyNZ1dcGH9yefqeu/hvJpxmoCBgHCyFbvzm6yLpGd0rxekmWwRI3GvdhmoBDtXhx+mT1ABSPcbpoUS3fvSyW2KroNKiSOdWFRgEVvkP7OhhuvoO7d7B/xXIeREW6Prq+WLd+TnvchnPqTZC33rJEH9pmKPpYrtMvR3EBuYs7TsrjFOIqTaGJmrkmB31lFTPPH863tfHHJQqIKy6IZ1rDto30Yj7EzgvmRgD3syT8QvHz9In27+Cw3nsjkB8wCsI+/YBZfQ7GPrsRSoJvSVcKRZqhA+m69upZVpqZHbzHCVYhvJGVvZ7QtC9i4LLFxSuKH+AEB+0aJ/LFF9iv/3I9SiwsDV9fWw91oSndwkYSFVUqlnlBRelewRoWvaM0JEK29R7WBMJxRoVaa5CeECWK0vzRCPhyu85Tyrih21Mt4uDfAUtQsDegY6e+AQopSA7tSWdoWBIpq75OgXq4gXZ2sd20nNM6sTsLGCB7DdnuTvEAq+YO3WCRh/qzL
 U91+Scev
 IkfYI189CI4nBo4uu2D5Ao8BwSulFnD4muReS3CexwKc6fNImzSgJgc8uLoc+bfo+V0Yk7SocZcnTtT8cmGq7SNY26ERgp6SZD4Krw6pZSacAxDzrxcSBKGqxTFo8n95+fV6Fon1lBXQXJIlOjDPL1l1StoyRJsXzqEcVO7k//jtxgV2mspr+5xC3wYISHNTCDclhHy8Zk8uoE6v3xASSWdlm0FCWrQ3xKKJf9mNQFOKD4ohyQl1P1yeJBXpWv9gkGNGG05k/Zw70G5HocOcIgyvqk8+1LkZeXq0HknM4lAbM559rZww9HDA0AUMcWFddEAI1/NAjZif9tqqg92LRD0pTYB/6QGbBlex7lmajH4zLXOzMvzYWwROn6J/rRkQGCAorPXUpaT5Sygt8u8bWZ1/XL6JPzb+fbp/L9TrNAMnBCRHCbDbn61xb08UDc3cYayJkzsandBNNI3Rn9z4tuVrsNHLd3kcebnrQapoLHQuHtNGvh0OESFJkEc3D8qVZdqkk3kAdiXSOoYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 11:20:59AM +0100, Vlastimil Babka (SUSE) wrote:
> A customer has reported excessive reclaim activity despite memory above
> high watermarks. Analyzing support data (including sar log) revealed the
> following scenario:
> 
> - the system has almost all memory reserved as 1G hugepages for kvm
>   guests, and operates normally
> - due to a spike of memory pressure from userspace, highatomic
>   reservations occur (probably due to e.g. concurrent network receive
>   activity)
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
> Hook this highatomic unreserve to the moment we exit the loop in
> balance_pgdat() due to exhausting reclaim priority, which means pgdat
> was not balanced and the last kswapd_shrink_node() attempt returned
> false or failed to reclaim anything. Even if that last attempt made the
> pgdat balanced, kswapd was struggling enough, so unreserving is far from
> premature. This should be a more conservative variant of when direct
> reclaim failure triggers the unreserving. Pass force as true to make
> sure repeated failures fully unreserve everything. Also make sure we
> don't count kswapd failures until then. Don't restart immediately as
> the kswapd() loop will call balance_pgdat() again if the unreserve does
> not lead to a balanced pgdat.
> 
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
> Changes in v2:
> - Don't unreserve prematurely (Jose, sashiko)
> - Fix movable->unmovable in comment (Jose, sashiko)
> - Prevent exhausting kswapd failures (sashiko)
> - Link to v1: https://patch.msgid.link/20261104-kswapd-highatomic-unreserve-v1-1-38be5106adf5@kernel.org
> ---
>  mm/page_alloc.c | 126 +++++++++++++++++++++++++++++---------------------------
>  mm/page_alloc.h |   3 ++
>  mm/vmscan.c     |  24 ++++++++++-
>  3 files changed, 91 insertions(+), 62 deletions(-)
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
> index 9959ca158ce8..af3079c6e32d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7317,6 +7317,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  	unsigned long pflags;
>  	unsigned long nr_boost_reclaim;
>  	unsigned long zone_boosts[MAX_NR_ZONES] = { 0, };
> +	bool has_highatomic = false;
>  	bool boosted;
>  	struct zone *zone;
>  	struct scan_control sc = {
> @@ -7342,6 +7343,8 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  	for_each_managed_zone_pgdat(zone, pgdat, i, highest_zoneidx) {
>  		nr_boost_reclaim += zone->watermark_boost;
>  		zone_boosts[i] = zone->watermark_boost;
> +		if (zone->nr_reserved_highatomic)
> +			has_highatomic = true;
>  	}
>  	boosted = nr_boost_reclaim;
>  
> @@ -7478,13 +7481,32 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  	 * If the reclaim was boosted, we might still be far from the
>  	 * watermark_high at this point. We need to avoid increasing the
>  	 * failure count to prevent the kswapd thread from stopping.
> +	 * We also don't want to stop unreserving highatomic pageblocks,
> +	 * if there are any.
>  	 */
> -	if (!sc.nr_reclaimed && !boosted) {
> +	if (!sc.nr_reclaimed && !boosted && !has_highatomic) {
>  		int fail_cnt = atomic_inc_return(&pgdat->kswapd_failures);
>  		/* kswapd context, low overhead to trace every failure */
>  		trace_mm_vmscan_kswapd_reclaim_fail(pgdat->node_id, fail_cnt);
>  	}
>  
> +	/*
> +	 * We exhausted all reclaim priority and didn't balance pgdat (except
> +	 * perhaps during the last attempt, but it's unlikely), even if we
> +	 * reclaimed something. If there are highatomic pageblocks, unreserve
> +	 * some.
> +	 * Convert them to unmovable ones as kswapd doesn't have a target
> +	 * migratetype, and unmovable should minimize permanent fragmentation.
> +	 */
> +	if (sc.priority < 1 && has_highatomic) {
> +		for (int i = 0; i <= highest_zoneidx; i++) {
> +			struct zone *zone = pgdat->node_zones + i;
> +
> +			unreserve_highatomic_pageblock_zone(zone,
> +					MIGRATE_UNMOVABLE, true);
> +		}
> +	}

I think the direction makes sense. Sashiko already said it but these
blocks should be reordered, gate forward progress on unreserve
actually returning true.

I do wonder if priority dropping to 0 might be too late, given how
kswapd is not as eager to escalate as direct reclaim. But I think that
can be fine-tuned empirically.

