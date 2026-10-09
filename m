Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A70A2CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0B26B0092; Fri,  9 Oct 2026 10:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777ED6B0093; Fri,  9 Oct 2026 10:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6006B0095; Fri,  9 Oct 2026 10:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4301C6B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:06:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9309A732D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:06:00 +0000 (UTC)
X-FDA: 85303261680.19.17384F1
Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	by imf12.hostedemail.com (Postfix) with ESMTP id 22C944000C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:05:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vc3tnERI;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791554758;
	b=lM1ssFop0/qQnBZWk+a3G9Z1VUM9k5NimTMwWbpy2Cbi1OPueZV3SpYTwOfmE1mZo4H8/d
	DBP0HENzpP+BjuFmxqFqapme/8C1jMmyIF+s1SWb1zy+NyDHBwyxw7JjFLRI9wKNe94KVQ
	gckkoJ6YnNbSlT2jtF0tiSwEmPUYa2A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vc3tnERI;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791554758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAB95bWwx3X8UgeCAaVcBkrbETP6pgJcxetZBkyLDs4=;
	b=NcAryMYcprp3rIySYguw4rUbgTq5iFzZZi/DNIG8Sxn0ohiWyxiYgDA52zaCKOwSm1MgSt
	9IQfha23F5vX10a+AXI2YUkKUPLSdtFuXiPfoSGRR8gqA7fH/7RakG6YjthZPUqPYHKEGu
	UNoSeXrztv7rgKSDbGztA8ufChmyRTs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=S/CJoQ6h8dM6bvOekOhXaJ1D4NhgPmP4sTYIwx5h4vw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791554756; v=1; x=1792159556;
 b=vc3tnERIjqp7uh4ESphNz9ZrEtCr3dUje5+8j7NLo5aG+ElLDbmKfD6vCPnOKQeqc2zM4gCf
 msExhwnRz8fjHpdnmOal2V/xnr2KPi8uKMTrqc8LPnenTO9vvzXKETETlk3sD5wr39gdGh3dKHd
 t6GrCgiQY7siMn6z3Tz7ILBU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a5ec3c62b9adca70;
	Fri, 09 Oct 2026 14:05:56 +0000
X-Mizu-Trace-ID: a5ec3c62b9adca70
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the promoted order
Date: Fri,  9 Oct 2026 07:05:47 -0700
Message-ID: <20261009140549.541127-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261009125503.126202-1-kas@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 22C944000C
X-Stat-Signature: pcpdyeeozphxj5bd5gj3kft57kxn3zf9
X-HE-Tag: 1791554757-635637
X-HE-Meta: U2FsdGVkX1/FEEjvZsxPavV8p5AVJFison9xdHNH7NHqk9FRrGPrVkSZrx0YIc01pQP9tpZU+/3BQPEAf2ZKN1OgnsXEngUUMRxQlf0jbWsmCFr+V5iOYuKTlD6fXYGLCBycYVY836OhZu9K5DXhZv19gHxK9je01P6gm2Lj5A+VkwU2L++4m7n9eo1t724aqfI0Gk+wlmb0hEEtweL2bm3MFUkCxH3x+Dfl4ZlVUB8JRLsme4aGKRNK/kV09KQ0ZsH0JourZB6U9iSLdm1VPAXbQdOyxhDdjHrWxfnk689AYitin6IzNsfMDbDTx0s8IZhEQDNrJpWbUYmb+SGsGSRgUk1qsJ/RVHBWKwBV9Q3ux4oJvH8BMwP+GbCfMFQiflVbRLabq/vh4x02atWVqRc7r/iKWqm0jMtMhJVv9b/IiJsGGaeOK+0NeAO0e9bg9S8sg2azbIo3DcupvucnbJN9o4OOjerCaJjMUA8+2UefP0D+VF9hNID68JOCReZGGo36TRCmR5iTtsTQWmhLI7mczsZjUyeLfTYs2r40+Iu+PsWW7GMPqAgwjLELo/VQYYMMiCqXiFec54aoEcb0Yq8TPtScTNHlVo0zsmY57JSMJID2aTnxYwsSVPpiS/M0SWvtCJCaOc1VJUReOqme4Ig3jgZi2qlQNYyPe1xlabF/p5XBGRG9bg75VpzPr0sSKU3kWlkPuiUpp+DtdHC9fy1nqGpgAlrmjQvOYE3QR0p33v4b7533AkSZ2ipN1KDkMc4F8AjZhKe7eXrsvPUeVTyNm0D36OXuo+dMsg56KMpiba+CUROaNIjOtST0eGbksRlSOyiYo2etgp2Zd7i7bWe4jzJsA8mOKeVJsaZ5KL5Md2V8fdLt2KMVOmCYYq1fnPFAybg4JGWo1B3Uigqnc9H7nYZFMXlCT2PkWi7XPc/XhkncItBHJRpnmEEPbKfb55ldOcHvdkR2M16uJ7V
 /wFWUIoQ
 5qxq5GrRjJJjtYlHMLSr+31eNBEMWCrG9Lb/hkzOxnK6WYOFwr2fvhy+4hefxKtsQ4Z6ziJ39/U5aqdoExPZGpwZ27F/m9ZcCmIi5SgsRUCaz6goJfSKhpD1bJguZ9oj/ZX2pqkNJwElYE2a6znJzaQ0rbxhEGcrD08Z3Tc1YgMjdWaItp3UkEGQxUxJKHfy/YI2t+abR4a2QWAUurSzAq9Xjn7w7iBg00Vk4WFrMXYYKpEGjaxInIQR4wrstD+MEjmA7peCRU9P5dkN9T6BAMRrVXE9D1amiPEYeGJUlw0NUYFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Oct 2026 13:55:02 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
> storm in defrag_mode"), direct reclaim and compaction for non-movable
> requests under defrag_mode run at pageblock_order, to produce the whole
> blocks that ALLOC_NOFRAGMENT needs. The retry decisions that follow
> still use the request order. An order-0 request can therefore retry
> indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:
> 
> - Reclaim at pageblock_order gives up after one pass as soon as a zone
>   looks compaction_ready(), and do_try_to_free_pages() then returns 1
>   even though nothing was reclaimed. It returns before the retry that
>   would reclaim memory.low-protected cgroups, so when most memory is
>   protected, the pass that did run finds next to nothing.
> 
> - Compaction at pageblock_order fails or is deferred.
> 
> - should_reclaim_retry() takes the reported progress as progress for
>   the order-0 request and resets no_progress_loops. The request
>   retries.
> 
> Order 1-3 requests loop the same way, and should_compact_retry() also
> checks their pageblock_order compaction result against the request
> order.
> 
> On a production host (64G, defrag_mode, memory.low covering most of the
> workload), 95% of direct reclaim runs were order-9 runs that returned 1
> with nothing reclaimed, at up to 60k runs per second. Across ~200M
> should_reclaim_retry() calls in a day, no_progress_loops never left 0.
> The spinning allocations were SLUB slab refills for inode and dentry
> caches. The time spent registers as memory pressure, and pressure-based
> OOM killing takes down both workloads and system services.
> 
> For promoted requests:
> 
> - Reclaim progress does not reset no_progress_loops, as for costly
>   orders.
> 
> - should_compact_retry() checks the compaction result at the promoted
>   order and does not retry COMPACT_SKIPPED, since the request can fall
>   back. The compaction priority floor and the COMPACT_SUCCESS retry
>   limit stay those of the request order, so a non-costly request still
>   gets its COMPACT_PRIO_SYNC_FULL pass before it falls back.
> 
> When a promoted request takes the fallback, reset the retry counters,
> so that the fallback attempt gets a full retry budget before the OOM
> killer is considered. A request whose reclaim was not promoted spent
> its budget on the request itself and keeps its counters, as Usama Arif
> pointed out.
> 
> __alloc_pages_slowpath() computes the promoted order once per iteration
> and passes it to direct reclaim, direct compaction and the two retry
> helpers next to the request order, so no callee has to recompute it.
> Harry Yoo asked for the two orders to be explicit rather than derived
> in each callee.
> 
> In a VM reproducer (32G, defrag_mode, inode churn under memory.low):
> 
>                                         before    after
>     should_reclaim_retry() calls           63M     293k
>     peak memory pressure (PSI some avg10)  99%      12%
> 
> File creation runs 5.7x faster.
> 
> Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Acked-by: Usama Arif <usama.arif@linux.dev>

> ---
> v3:
>  - reset the retry counters at the fallback only for requests whose
>    reclaim was promoted; a movable request already spent its budget on
>    itself (Usama Arif)
> 
> v2:
>  - keep the compaction priority floor and the COMPACT_SUCCESS retry
>    limit on the request order, so non-costly requests still escalate to
>    SYNC_FULL before falling back (Harry Yoo, Johannes Weiner)
>  - compute the promoted order once in __alloc_pages_slowpath() and pass
>    it to direct reclaim, direct compaction and the retry helpers, instead
>    of each of them deriving it (Harry Yoo)
> 
>  mm/page_alloc.c | 126 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 81 insertions(+), 45 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..c0be88d2c3ad 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4127,6 +4127,32 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
>  	return page;
>  }
>  
> +/*
> + * If fallbacks are not permitted (defrag_mode), we either need to
> + * reclaim space in a block of matching type, or clear out an entire
> + * block to allow __rmqueue_claim() to convert.
> + *
> + * Reclaim by itself is primarily freeing space in movable blocks,
> + * since that's where the LRU pages live. So this works for movable
> + * requests, but not for others.
> + *
> + * For those, promote the order of reclaim and compaction to help make
> + * blocks, instead of spinning in reclaim alone unproductively. Retry
> + * decisions based on the outcome of that work - reclaim progress and
> + * compaction results - must account for the promotion as well, so
> + * __alloc_pages_slowpath() computes the promoted order once and passes
> + * it alongside the request order.
> + */
> +static inline unsigned int nofrag_promote_order(unsigned int order,
> +						unsigned int alloc_flags,
> +						const struct alloc_context *ac)
> +{
> +	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
> +		return max(order, pageblock_order);
> +
> +	return order;
> +}
> +
>  /*
>   * Maximum number of compaction retries with a progress before OOM
>   * killer is consider as the only way to move forward.
> @@ -4137,8 +4163,9 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
>  /* Try memory compaction for high-order allocations before reclaim */
>  static struct page *
>  __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
> -		unsigned int alloc_flags, const struct alloc_context *ac,
> -		enum compact_priority prio, enum compact_result *compact_result)
> +		unsigned int compact_order, unsigned int alloc_flags,
> +		const struct alloc_context *ac, enum compact_priority prio,
> +		enum compact_result *compact_result)
>  {
>  	struct page *page = NULL;
>  	unsigned long pflags;
> @@ -4149,22 +4176,6 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  		.order = order,
>  		.page = NULL,
>  	};
> -	int compact_order = order;
> -
> -	/*
> -	 * If fallbacks are not permitted (defrag_mode), we either
> -	 * need to reclaim space in a block of matching type, or clear
> -	 * out an entire block to allow __rmqueue_claim() to convert.
> -	 *
> -	 * Reclaim by itself is primarily freeing space in movable
> -	 * blocks, since that's where the LRU pages live. So this
> -	 * works for movable requests, but not for others.
> -	 *
> -	 * For those, promote the order to help make blocks, instead
> -	 * of spinning in reclaim alone unproductively.
> -	 */
> -	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
> -		compact_order = max(order, pageblock_order);
>  
>  	if (!compact_order)
>  		return NULL;
> @@ -4246,7 +4257,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  
>  static inline bool
>  should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
> -		     int alloc_flags,
> +		     int compact_order, int alloc_flags,
>  		     enum compact_result compact_result,
>  		     enum compact_priority *compact_priority,
>  		     int *compaction_retries)
> @@ -4257,7 +4268,7 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
>  	int retries = *compaction_retries;
>  	enum compact_priority priority = *compact_priority;
>  
> -	if (!order)
> +	if (!compact_order)
>  		return false;
>  
>  	if (fatal_signal_pending(current))
> @@ -4266,10 +4277,14 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
>  	/*
>  	 * Compaction was skipped due to a lack of free order-0
>  	 * migration targets. Continue if reclaim can help.
> +	 *
> +	 * Promoted requests have exhausted their reclaim retries at
> +	 * this point, and they can fall back instead.
>  	 */
>  	if (compact_result == COMPACT_SKIPPED) {
> -		ret = compaction_zonelist_suitable(ac, order, alloc_flags,
> -						   gfp_mask);
> +		if (compact_order == order)
> +			ret = compaction_zonelist_suitable(ac, order, alloc_flags,
> +							   gfp_mask);
>  		goto out;
>  	}
>  
> @@ -4314,8 +4329,9 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
>  #else
>  static inline struct page *
>  __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
> -		unsigned int alloc_flags, const struct alloc_context *ac,
> -		enum compact_priority prio, enum compact_result *compact_result)
> +		unsigned int compact_order, unsigned int alloc_flags,
> +		const struct alloc_context *ac, enum compact_priority prio,
> +		enum compact_result *compact_result)
>  {
>  	*compact_result = COMPACT_SKIPPED;
>  	return NULL;
> @@ -4323,7 +4339,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  
>  static inline bool
>  should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
> -		     int alloc_flags,
> +		     int compact_order, int alloc_flags,
>  		     enum compact_result compact_result,
>  		     enum compact_priority *compact_priority,
>  		     int *compaction_retries)
> @@ -4462,17 +4478,12 @@ __perform_reclaim(gfp_t gfp_mask, unsigned int order,
>  /* The really slow allocator path where we enter direct reclaim */
>  static inline struct page *
>  __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
> -		unsigned int alloc_flags, const struct alloc_context *ac,
> -		unsigned long *did_some_progress)
> +		unsigned int reclaim_order, unsigned int alloc_flags,
> +		const struct alloc_context *ac, unsigned long *did_some_progress)
>  {
>  	struct page *page = NULL;
>  	unsigned long pflags;
>  	bool drained = false;
> -	int reclaim_order = order;
> -
> -	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
> -	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
> -		reclaim_order = max(order, pageblock_order);
>  
>  	psi_memstall_enter(&pflags);
>  	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
> @@ -4638,8 +4649,9 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
>   */
>  static inline bool
>  should_reclaim_retry(gfp_t gfp_mask, unsigned order,
> -		     struct alloc_context *ac, int alloc_flags,
> -		     bool did_some_progress, int *no_progress_loops)
> +		     unsigned int reclaim_order, struct alloc_context *ac,
> +		     int alloc_flags, bool did_some_progress,
> +		     int *no_progress_loops)
>  {
>  	struct zone *zone;
>  	struct zoneref *z;
> @@ -4648,9 +4660,17 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
>  	/*
>  	 * Costly allocations might have made a progress but this doesn't mean
>  	 * their order will become available due to high fragmentation so
> -	 * always increment the no progress counter for them
> +	 * always increment the no progress counter for them.
> +	 *
> +	 * The same goes for requests whose reclaim is promoted to make whole
> +	 * blocks. At that order, reclaim also reports progress when it backs
> +	 * off for compaction without freeing anything.
> +	 *
> +	 * The watermark check below stays at the request order: it asks
> +	 * whether the request itself could succeed after reclaim.
>  	 */
> -	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
> +	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER &&
> +	    reclaim_order == order)
>  		*no_progress_loops = 0;
>  	else
>  		(*no_progress_loops)++;
> @@ -4790,6 +4810,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
>  	struct page *page = NULL;
>  	unsigned int alloc_flags;
> +	unsigned int reclaim_order;
>  	unsigned long did_some_progress;
>  	enum compact_priority compact_priority;
>  	enum compact_result compact_result;
> @@ -4934,17 +4955,22 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	/* If allocation has taken excessively long, warn about it */
>  	check_alloc_stall_warn(gfp_mask, ac->nodemask, order, alloc_start_time);
>  
> +	/* The order reclaim and compaction work at, see nofrag_promote_order() */
> +	reclaim_order = nofrag_promote_order(order, alloc_flags, ac);
> +
>  	/* Try direct reclaim and then allocating */
>  	if (!compact_first) {
> -		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
> -							ac, &did_some_progress);
> +		page = __alloc_pages_direct_reclaim(gfp_mask, order, reclaim_order,
> +						    alloc_flags, ac,
> +						    &did_some_progress);
>  		if (page)
>  			goto got_pg;
>  	}
>  
>  	/* Try direct compaction and then allocating */
> -	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
> -					compact_priority, &compact_result);
> +	page = __alloc_pages_direct_compact(gfp_mask, order, reclaim_order,
> +					    alloc_flags, ac, compact_priority,
> +					    &compact_result);
>  	if (page)
>  		goto got_pg;
>  
> @@ -4996,8 +5022,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	    check_retry_zonelist(zonelist_iter_cookie))
>  		goto restart;
>  
> -	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
> -				 did_some_progress > 0, &no_progress_loops))
> +	if (should_reclaim_retry(gfp_mask, order, reclaim_order, ac,
> +				 alloc_flags, did_some_progress > 0,
> +				 &no_progress_loops))
>  		goto retry;
>  
>  	/*
> @@ -5007,14 +5034,23 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	 * of free memory (see __compaction_suitable)
>  	 */
>  	if (did_some_progress > 0 && can_compact &&
> -	    should_compact_retry(gfp_mask, ac, order, alloc_flags,
> -				 compact_result, &compact_priority,
> +	    should_compact_retry(gfp_mask, ac, order, reclaim_order,
> +				 alloc_flags, compact_result, &compact_priority,
>  				 &compaction_retries))
>  		goto retry;
>  
> -	/* Reclaim/compaction failed to prevent the fallback */
> +	/*
> +	 * Reclaim/compaction failed to prevent the fallback. A promoted
> +	 * request spent its retry budget on making blocks, not on the
> +	 * request itself; give its fallback a fresh one before
> +	 * considering OOM.
> +	 */
>  	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
>  		alloc_flags &= ~ALLOC_NOFRAGMENT;
> +		if (reclaim_order != order) {
> +			no_progress_loops = 0;
> +			compaction_retries = 0;
> +		}
>  		goto retry;
>  	}
>  
> -- 
> 2.54.0
> 
> 

