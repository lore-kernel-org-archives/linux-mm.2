Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 868FF606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Q4fUY0+g
Received: by kanga.kvack.org (Postfix)
	id 9F7596B05B2; Wed, 18 Nov 2026 03:10:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A76E6B05B3; Wed, 18 Nov 2026 03:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897E36B05B4; Wed, 18 Nov 2026 03:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54ABA6B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:10:34 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8714A8202
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:10:33 +0000 (UTC)
X-FDA: 85447517946.22.F06C305
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id E2CBE20004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:10:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q4fUY0+g;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794989432;
	b=BMD0Af8zuydzxvCgGNQT5Jd4Z+gHdpNtmEBVLRKLPOgyo+TtVUzXK26FObwJH9PTwYa/Y3
	cEYDuTXalWMZWm6akH78qEloc8332fgpU1crN+qKAugK+N0XB91MZ1qHTfuL/83GVvowxk
	9BfRG1JowGV0bwjpnoAYr9p+Gxub0LE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Q4fUY0+g;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794989432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hj2AtJ5fdbFUi8EuCznDfKlHT8DybaNFg1VurQsunj0=;
	b=ra0S6J0RxVceuOfFPwEkrw1FBpz4JSWmdG56Pu2GUU2xmyIeCJSjKl6iH/A0HGV03bIdoM
	fQfVx5FivAEhdF0PNdcHZzhgDuFilba98lgzFRe6DPQdA/2n7OUCv2kX5U/DMneQ1bBJ9U
	XO256oFPw+YA82+WlXK4QLKnqa6apws=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4C791596;
	Wed, 18 Nov 2026 00:10:26 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B10C3F882;
	Wed, 18 Nov 2026 00:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794989429; bh=0H51ijbzjs6BiH+IRFtsYcS5mGGhZK4y1Kx0/tr2CTk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q4fUY0+gWsCb9QiVpjNWATFAKLE6lh/hQh84bHsTCsALikTwDBGlwktRcFOn5qP8d
	 6ZhyC/tO9w9jYhfsy76lfpgoaiomucKgKTuNNqYvkMovfmw/4tWOT748Lle1pSdDS0
	 GzZcwrr9RtkPTQMuyvfABvyavwPc6jAnC8Gk5qqo=
Message-ID: <a066d403-1608-4c0b-b06b-0b786e71b12d@arm.com>
Date: Wed, 18 Nov 2026 13:40:17 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: page_alloc: make the high-order watermark
 check honour ALLOC_NOFRAGMENT
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261116125103.2894162-1-kas@kernel.org>
 <20261116125103.2894162-3-kas@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261116125103.2894162-3-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E2CBE20004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 86x6xa5synnx8qw633uw8y5z9ce4j49e
X-Rspam-User: 
X-HE-Tag: 1794989431-779286
X-HE-Meta: U2FsdGVkX1/6lFzYly/QYwNwYLgqcoph7UJeVGzTyuHtfRFg8Tjh2h6N8PU9s2W7aRbL/EXjmExwZLllolgqP6gBbY8eKQES7RDclGxbEXFWMgitJwXhecxv68UgICuBi24NrRRyI6kbRYARzJZmnW7CgaGWbwbCV3K2/x6xoue2gLY0MTZFgXS3H6MWfLzM9YcreuiNZHWXv6VLBv8R4D/nxxrpQ7+eB3W0l7yccPrIbUGqlDH98JxfT+tATYMC/hLk2wAin+mEDyRF+6lwJSDRRBwr8eRea+0KXmfhdj/7jWzszEMcYNtNss4oZYZ3eb57rkUyOOuLGVCshM0d1RsVZCZu2wrqDGebEyugo0aKUXmfF9Pe6NX0qlfL6a9cYkfufV7MtG/PMyLalmBttVzPX0Qp3q6qsdEA6bQKK5WRpyLE0cRQ60D374K/d35x8bQvTaksXLhT+radi6aWsq0PyJhabHPtiPhYIfc6imKodUxf65FrRJBrxSQmnsYbsawpEyKekmdRS43rh4I9rccrIztjk+C3wVhNbXgN41X5oQ9zRrmmpvAI+c+GnpMoeN9zKFUF0v09aDSlXo4RU5l/f3QtCwkX/l7i2ggUeoqjzWpthwk6/NvmgaZL3LPMpZnJtqN7nxKaG0dgI7yriHN2h8vLbM6JWVwP5AkP0+dORepdNdD/5qY7+vyG61xoFMGftE87knl5eM0yYx3xxq0mk0BlKcwjN5jXgwXHG2XTTPR9JPlmgF5Xvnp3mINstAoLqhyYbHuPt/38MY7rqfaUHEQqDcFQ9vn3eQ37Oypo37+AgtLOdfjSiXIQ4OhiP28wyHAjY/iUs1u7UEVra8StznDyY37Iqn9iUaqA6Jk4G0P88zxuIY5MsECDZe64IAU15FYyjeMOyDK5ZUXQTKGRlcGRqjD5OYHU+cqLorrHMM0cJDr8SsG6bMXhqJNcccVpvRoMx3ZeAW1gz4R
 oqoiCS9y
 jNYHjL8mbTU41wxEx/YYODPBQoJRcjxBUuopsryLXzr1uU/bLOcsL73T4g1DZlHo9DaI6NrCEznhFhPmOgDe4J0ga+YP5cM/E7sFvnJqLw3IByfOAIJsURPIxG9QQjiaH7+Oxb/o+TxrbvMAy+qlEbuSpcD61VSTTrw4pukgWv6SYvUipXSpJMPPP/qtTHTX3Ahve0uRakZWpqb6bAtiDBJBkKgMLSAz3Tu6sPJd8CLajumTfPlPcJdQgUQyGxLxTuKigyKVaZAezot1DQMgFZeoTM45897wueuP/GRIGRYLRdxcXpUVJKZctGz1iUR3T1Q216+yU9ZSGo0lelzqFKn5zJhewll2LZ8xTsTq1ph1Z6WGvPfutY5eReA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 16/11/26 6:21 pm, Kiryl Shutsemau (Meta) wrote:
> With defrag_mode, every slowpath allocation carries ALLOC_NOFRAGMENT.  A
> request below pageblock_order may take a page of its own migratetype or
> claim a whole free block, but not steal from another migratetype's block.
> For a high-order request, the watermark check still accepts a free page
> of any migratetype.
> 
> Under memory pressure, movable allocations take free movable pages as
> soon as reclaim frees them.  Free space in unmovable and reclaimable
> pageblocks is off-limits to them under ALLOC_NOFRAGMENT, and builds up.
> The free pages of order 4 and up end up mostly in those pageblocks.
> 
> A 64K mTHP fault cannot take them, but direct compaction's up-front check
> counts them and returns COMPACT_SUCCESS without compacting anything.  The
> allocation then fails.  Because compaction "succeeded", it is never
> deferred, and every fault stalls in it again before falling back to small
> pages.
> 
> Dev Jain's benchmark faults 64K mTHPs under swap pressure, in a 7G VM
> with only the 64K size enabled.  With defrag_mode, those faults stall in
> compaction 18 times as often and get about a third of the folios
> (medians of 15 runs):
> 
>                               defrag_mode=0  defrag_mode=1  defrag_mode=1
>                                                             + this patch
>     compact_stall                      1690          30669          2607
>     compact_fail                        621          30531           906
>     64K faults allocated              20750           7391         11538
>     64K faults falling back to 4K       725          13832          9945
> 
> Make __zone_watermark_ok_mt() skip other migratetypes' free lists below
> pageblock_order for an ALLOC_NOFRAGMENT request.  Give
> __compact_finished() the same rule for its fallback test, so that
> compaction, once it runs, stops on a page the request can take.
> 
> zone_watermark_fast() calls __zone_watermark_ok_mt() too.  With
> defrag_mode, an allocation now wakes kswapd and starts reclaim or
> compaction as soon as the free lists hold nothing it can take.  For the
> orders the per-cpu lists serve, that is earlier than before: the check
> does not count their pages, so the allocation no longer uses up the local
> list first.  A request that may not wake kswapd or reclaim, such as an
> mTHP fault with THP defrag=never, falls back to a smaller folio instead.
> 
> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> Reported-by: Dev Jain <dev.jain@arm.com>
> Closes: https://lore.kernel.org/all/4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com/
> Tested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

zone_watermark_ok_mt is a bad name, I am having a hard time figuring out when
to call zone_watermark_ok and when to call zone_watermark_ok_mt. Let us look at
what zone_watermark_ok answers currently, according to the comment above it:

a) "Return true if free base pages are above 'mark'."
b) "For high-order checks it will return true if the order-0 watermark is reached
    and there is at least one free page of a suitable size".

So there are two uses: whether we have enough free pages, then, whether
we have enough free pages *and* we can also allocate.

So let us do something like: we have zone_watermark_ok_for_alloc. It will call
zone_watermark_ok, which will only handle the watermark computation (so this is a
refactor for the code ending at if (!order) line in current zone_watermark_ok).
Then it will also scan the freelists for the correct order, correct migratetype etc.

Then at the callsite we clearly know whether we are just looking for enough free memory,
or whether we are looking for an allocation too.


>  mm/compaction.c |  5 +++++
>  mm/page_alloc.c | 21 ++++++++++++++++++---
>  2 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 6c553d0e90f8..7312f7515c53 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2365,6 +2365,11 @@ static enum compact_result __compact_finished(struct compact_control *cc)
>  			!free_area_empty(area, MIGRATE_CMA))
>  			return COMPACT_SUCCESS;
>  #endif
> +		/* An ALLOC_NOFRAGMENT request may only claim a whole block */
> +		if ((cc->alloc_flags & ALLOC_NOFRAGMENT) &&
> +		    order < pageblock_order)
> +			continue;
> +
>  		/*
>  		 * Job done if allocation would steal freepages from
>  		 * other migratetype buddy lists.
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0ebfbbb5d7c5..6e75c03b303b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3587,6 +3587,11 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
>   * will return true of the order-0 watermark is reached and there is at least
>   * one free page of a suitable size. Checking now avoids taking the zone lock
>   * to check in the allocation paths if no pages are free.
> + *
> + * Under ALLOC_NOFRAGMENT, a request below pageblock_order can take another
> + * migratetype's page only by claiming the whole block, so only free pages of
> + * @migratetype count below pageblock_order.  Without ALLOC_NOFRAGMENT,
> + * @migratetype is not used.
>   */
>  bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
>  			    unsigned long mark, int highest_zoneidx,
> @@ -3649,6 +3654,9 @@ bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
>  			continue;
>  
>  		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
> +			if ((alloc_flags & ALLOC_NOFRAGMENT) &&
> +			    mt != migratetype && o < pageblock_order)
> +				continue;
>  			if (!free_area_empty(area, mt))
>  				return true;
>  		}
> @@ -3677,8 +3685,12 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
>  			 int highest_zoneidx, unsigned int alloc_flags,
>  			 long free_pages)
>  {
> +	/* Serving an ALLOC_NOFRAGMENT request needs __zone_watermark_ok_mt() */
> +	VM_WARN_ON_ONCE(order && order < pageblock_order &&
> +			(alloc_flags & ALLOC_NOFRAGMENT));
>  	return __zone_watermark_ok_mt(z, order, mark, highest_zoneidx,
> -				      alloc_flags, free_pages, MIGRATE_MOVABLE);
> +				      alloc_flags & ~ALLOC_NOFRAGMENT,
> +				      free_pages, MIGRATE_MOVABLE);
>  }
>  
>  bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
> @@ -4693,10 +4705,13 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
>  
>  		/*
>  		 * Would the allocation succeed if we reclaimed all
> -		 * reclaimable pages?
> +		 * reclaimable pages?  Count free pages of all migratetypes.
> +		 * Compaction can then free a whole pageblock for the
> +		 * allocation to claim.
>  		 */
>  		wmark = __zone_watermark_ok(zone, order, min_wmark,
> -				ac->highest_zoneidx, alloc_flags, available);
> +				ac->highest_zoneidx,
> +				alloc_flags & ~ALLOC_NOFRAGMENT, available);
>  		trace_reclaim_retry_zone(z, order, reclaimable,
>  				available, min_wmark, *no_progress_loops, wmark);
>  		if (wmark) {


