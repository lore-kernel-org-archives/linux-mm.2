Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FADBCCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7A538E001D; Wed, 15 Oct 2025 05:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B468E0002; Wed, 15 Oct 2025 05:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41978E001D; Wed, 15 Oct 2025 05:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9082A8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:08:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 318181A0B5C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:08:17 +0000 (UTC)
X-FDA: 83999772234.25.A322ABF
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf30.hostedemail.com (Postfix) with ESMTP id E6F8D80002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:08:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bpXnKfq0;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760519295; a=rsa-sha256;
	cv=none;
	b=xd+tKrAXNlC1PY5uDBFHRnx1YZ2hjVa+iRpZt0p1bZLkWTKE3h5u4eJ4XIbgKPN7DWm73E
	WjDExJH3Dt1VEa1ewdTascCxUR82Sth8YWNqPjPzph/uVwurDxbO3EygG5fNhennhd1w3w
	CKHTDzUpRwalGQN/WXL8nYvsN7ZjwTw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bpXnKfq0;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760519295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBv4vZFGFDoCDQH8BpSpEQDx7bGnlZaAWGhk2rAOOXI=;
	b=ThJLBJrbBy7cZXsm8sKvXc2IMTtG/5NONBJ8i4bqOQKsm6Epn3fn3esTHsNJbPrlJxbAMO
	SGnobh9ZljWa0ofSJKAxMUNl/8NxG0cKCX9B48pxg6tKKcfgW9TaE2gDlWnLNfK/mliEKF
	eZfeqHRM8BOz9nkMnZzoR5pBCDBVeyI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jBv4vZFGFDoCDQH8BpSpEQDx7bGnlZaAWGhk2rAOOXI=;
	b=bpXnKfq0SoHUJ6hQR1TRkhvV9iciBtK1ANxaaXo3cDcq4Bl+XQaKcdOl0bAJbhbY/HlcNrn7h
	1f9tUm0hCM4d7Ia/bB8LMscvCyAolG+dUY0TomHn+GcWuA6ufCynsMDsESK2EqM+N3Gk6twALkb
	wfqk+r2jkHuQJYaFvlL17oo=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cmlbm2Z8yzmV6g;
	Wed, 15 Oct 2025 17:07:48 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 92CCF1A0188;
	Wed, 15 Oct 2025 17:08:08 +0800 (CST)
Received: from [10.174.178.114] (10.174.178.114) by
 kwepemj100016.china.huawei.com (7.202.194.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 17:08:07 +0800
Message-ID: <a5349a28-bf32-4b26-a55f-af53f4c225b8@huawei.com>
Date: Wed, 15 Oct 2025 17:08:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<axelrasmussen@google.com>, <yuanchu@google.com>, <weixugc@google.com>
Subject: Re: [RFC PATCH] mm: vmscan: wakeup kswapd during node_reclaim
To: <akpm@linux-foundation.org>, <david@redhat.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <zhengqi.arch@bytedance.com>, <shakeel.butt@linux.dev>
References: <20251011062043.772549-1-mawupeng1@huawei.com>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <20251011062043.772549-1-mawupeng1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.114]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E6F8D80002
X-Stat-Signature: 8sjwohxjrmqgnwb8uj44e1gcbtt7hkgr
X-HE-Tag: 1760519293-499971
X-HE-Meta: U2FsdGVkX18J9nJDw9Krp6uplEFWYd5bYptcM25r9DuLOVmecex6xJ/VTXw4Yd9BYD+mLg814LCt956nXA5LYdBUbpCqCD5SIySQd9TzB110gKw4SKUJ7RIFYKhYvmwPxzawCZ5neDPYauYrXVx1STGqnps3Gl9piDa+gdT0Eb5P4MoepEV/RA9fxlQnMXWZPL2UVGqMMCtIUzhUdSdGGClZNKOXJX9c3Q3UamT26erwsDtONfFWxqqgc7InEDhfAY8PcHRVFya4VawYiU02uBHkDjaJBTfEGP8jpoMpwY1LQZSgnRng3QiHJhkj2ahtYKcSCLHJXFSNDO/aB9WXvgKkQ0BHYajeucLT9D+MG1wFchbA4o9EoXwLmKy4ig4zevtGmbD+txeNuXKnts5xYWLQ6iQdpznSxsJrJwdxek/PfeUfH3+Rt25jdt9m6IGz9pxr9tnhx/E9+fekZB1Glg/4e/gWYnRBv1AIS4we9Tt0NOJFnxsuLU8/1R539I3iIEC19AQl7KQDZdjyccqg3Ui/aiS/cBZDLFSqtJkX966Ux5vlOovhutOYlMyGfSDXrGTCgGdlYA54YbBhMhxU0IupL0GiATyGjH46hcfIRRxXAg1xFltNfqNP5x8VDpWC10oxuhq2fdrKhby2Mm6lH8zMjx12ZRymd9zYTOHluc1NF6bErHZ4qJGEU2RlsyhYa3GkORNIOMf5F/75cmJz8Vgr9YAHvHBebWyUl8FvdDwGwAhDjOfrugq+kb6pcIdBNKXSTe8xPNBj/yKmlM7VQ6OHbEgk05wAUOg2SbqiIZ4+CNo+D6d1G08JgvQ2PZGZh+z8f4oeX1XNx1BuR6iiv040ijkgV2zgF5yvoHRXXF6YEKB63altyyE9bjqoLSH/3FJQClDLZ1iuCxvZw6/8Wscu27V2rgVv+j/02aLYLvZ4cTZhHtskNREyoph69tO5FI7fxWY/7o9NooQC+vf
 mlKT2cSA
 cEMeyGZ9zdPxVvPTIT7JQfqlwFSw5DmgvD88uXFA/2VOALkR8L5t65oDzJ1DILiMlQ5+ELVlY3Njfx80tnVrraJylB4hPuBIdPKYmLi+E4XpzFqtnKH2afBKcX1aTAQ7qC5hdxqSuj4HaBf9cLPI3/4lwO+pfg+rC/Bxk5cF5vpMvntKsHNu0yuwB/4jcwcVXvfPSVsbq6Z4JKM5UpnBkuP9dFkpI87HTlak7X4QZ3LTJ2AT5ByfV/It0Vw8EdkeYYY4/bessto6IlFUHXWKx0TQuWHLZXd3Lwtyf+EYXDrHLgzgeDiZqrPz26sFKzdJf2ff1E3jfVPD6v+fNrRuW5WLcuRnACLSLkXuYrhVTYvnJsYxpj5RJtEbJGpqR90rVbwtvtHe41wKjMKWjT4wWIXV3ym+mQcmohkGT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Reviewers:
	kindly ping, cc more reviews.
	
On 2025/10/11 14:20, Wupeng Ma wrote:
> During testing, we observed that memory allocation with node_reclaim_mode
> enabled becomes extremely slow when a large allocation is attempted on a
> node whose free memory is mostly occupied by clean page cache.
> 
> The slowness arises because during node reclaim, only direct reclaim-like
> behavior is triggered — recycling only 32 pages at a time — without
> waking kswapd, even when the watermark levels and alloc_flags already
> satisfy the condition to activate kswapd.
> 
> This patch wakes kswapd during node reclaim, allowing background reclaim
> to bring free memory up to the high watermark and avoid excessive node
> reclaim overhead.
> 
> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
> ---
>  mm/internal.h   | 14 ++++++++------
>  mm/page_alloc.c |  6 +++++-
>  mm/vmscan.c     | 19 +++++++++++++++++--
>  3 files changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..5303123dd0a8 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1196,21 +1196,23 @@ static inline void mminit_verify_zonelist(void)
>  }
>  #endif /* CONFIG_DEBUG_MEMORY_INIT */
>  
> -#define NODE_RECLAIM_NOSCAN	-2
> -#define NODE_RECLAIM_FULL	-1
> -#define NODE_RECLAIM_SOME	0
> -#define NODE_RECLAIM_SUCCESS	1
> +#define NODE_RECLAIM_NOSCAN		-2
> +#define NODE_RECLAIM_FULL		-1
> +#define NODE_RECLAIM_SOME		0
> +#define NODE_RECLAIM_SUCCESS		1
> +#define NODE_RECLAIM_KSWAPD_SUCCESS	2
>  
>  #ifdef CONFIG_NUMA
>  extern int node_reclaim_mode;
>  
> -extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
> +int node_reclaim(struct pglist_data *pgdat, gfp_t mask, unsigned int order,
> +		 int alloc_flags, struct zone *zone);
>  extern int find_next_best_node(int node, nodemask_t *used_node_mask);
>  #else
>  #define node_reclaim_mode 0
>  
>  static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
> -				unsigned int order)
> +		unsigned int order, int alloc_flags, struct zone *zone)
>  {
>  	return NODE_RECLAIM_NOSCAN;
>  }
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 600d9e981c23..2472000cab78 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3859,7 +3859,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
>  				continue;
>  
> -			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
> +			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order,
> +					   alloc_flags, zone);
>  			switch (ret) {
>  			case NODE_RECLAIM_NOSCAN:
>  				/* did not scan */
> @@ -3867,6 +3868,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  			case NODE_RECLAIM_FULL:
>  				/* scanned but unreclaimable */
>  				continue;
> +			case NODE_RECLAIM_KSWAPD_SUCCESS:
> +				/* kswapd reclaim enough */
> +				goto try_this_zone;
>  			default:
>  				/* did we reclaim enough */
>  				if (zone_watermark_ok(zone, order, mark,
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b2fc8b626d3d..ebee8b6330a8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7680,9 +7680,11 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
>  	return sc->nr_reclaimed;
>  }
>  
> -int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
> +int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order,
> +		 int alloc_flags, struct zone *zone)
>  {
>  	int ret;
> +	enum zone_type highest_zoneidx = gfp_zone(gfp_mask);
>  	/* Minimum pages needed in order to stay on node */
>  	const unsigned long nr_pages = 1 << order;
>  	struct scan_control sc = {
> @@ -7693,7 +7695,7 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
>  		.may_writepage = !!(node_reclaim_mode & RECLAIM_WRITE),
>  		.may_unmap = !!(node_reclaim_mode & RECLAIM_UNMAP),
>  		.may_swap = 1,
> -		.reclaim_idx = gfp_zone(gfp_mask),
> +		.reclaim_idx = highest_zoneidx,
>  	};
>  
>  	/*
> @@ -7729,6 +7731,19 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
>  	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
>  		return NODE_RECLAIM_NOSCAN;
>  
> +	if (alloc_flags & ALLOC_KSWAPD) {
> +		unsigned long mark;
> +
> +		wakeup_kswapd(zone, gfp_mask, order, highest_zoneidx);
> +
> +		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
> +		if (zone_watermark_ok(zone, order, mark, highest_zoneidx,
> +					alloc_flags)) {
> +			clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
> +			return NODE_RECLAIM_KSWAPD_SUCCESS;
> +		}
> +	}
> +
>  	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
>  	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
>  


