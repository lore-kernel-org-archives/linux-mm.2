Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E0CDCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 11:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698A76B0088; Mon, 12 Oct 2026 07:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649606B008A; Mon, 12 Oct 2026 07:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53ABE6B008C; Mon, 12 Oct 2026 07:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3906B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:40:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8A85A0BCD
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:40:44 +0000 (UTC)
X-FDA: 85313782008.22.7222181
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C6DED4000B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:40:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VK8MeTSi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791805242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oh9Ei+qP6U9FrDZiNh4NKHoeoiIreiapZDZWAguR3tw=;
	b=lC+gWCMPDE+CkzyTdVVxAdAI8W1dFNw85Eqc8uSWFRCPxEPkzHh0unTzc8cgZbiQWyvfMN
	L4aiVEr2NuvXxkWfsWn61raBIBow68a4/0zHxS/jmcUmChh688khC3VnE3fn6+CAsI7wpf
	VaT+Knk4YIXa8cR8DdfC4AAwqdKW8j0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VK8MeTSi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791805242;
	b=cT9HCRk7kHDoGiKcYGDp/9Y327NZDCLafpxKOdXf2SC/ORDHsYL/LXWMb3VFJHo9gGxplY
	d/NnepqIA9FiOHAwfdEeX/aON4KkL8sAdP/8Tt2l7So8PSylR9h8YCmd8ln5YnoUhlGx+3
	7/SDVF45ztHGV7Pfyjy2Rgmhwy4Ffxo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92DA340AAC;
	Mon, 12 Oct 2026 11:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628A11F0089B;
	Mon, 12 Oct 2026 11:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791805241;
	bh=Oh9Ei+qP6U9FrDZiNh4NKHoeoiIreiapZDZWAguR3tw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VK8MeTSiVkOV0o/3FjcKoSYGTT+rE03j7mwWNG0G4Ap/R/z3Ly9WStkcEqoB6GG0G
	 xx3+hJPa3GScGXQTl5ji+FaPoedo4wGox6GweyXM7OUPLiZhGsOoCdjD2bsA7jyigV
	 Chcdd4Kh3nRr1CbAYIfh1DVwF441A510AXwpBr6XhoYSASizNIk8kC2tWX8cMyynXL
	 b/apNThdNaCduP8mJUHTExMfzE6Vd/qbzUnezLGDAfltGYJh5OJcLv8nSENHWf1h7f
	 IKIrPTExExZTlm0vevTO0vTDAnpoLfj7MGaN7HMmi1rj0yO2Q97VE/DdyxkgIzQ5Bt
	 4e9so2yv5ysIA==
Message-ID: <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
Date: Mon, 12 Oct 2026 13:40:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Content-Language: en-US
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, kernel-team@meta.com
References: <20261009125503.126202-1-kas@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261009125503.126202-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C6DED4000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 8r5ki4atum6zr5sa1b4y1ysjn5edox7u
X-HE-Tag: 1791805242-949738
X-HE-Meta: U2FsdGVkX19UNHejbPIVo5eced8rZpSCQh5eGlOhYiwnteWojG2v0Yg+EIZr3Zoh2T2ZBifvWVtG9Db9KWgUVB/taliz4YuSVp9ZHA+aOkWuQeGUD6KnL9uNfg40otGeyzXVw9Zuk1w9HjnWwVQradswNK78V6sX/KqlL9RkuXVk81IqrNQ3VNfJKpyxLCmgVZkUu/lgCExSGtGfBx9csBhUCwIiyb+dlnx0gJYPPMWygkrsR/VwKam3Vp0m+PfMfwoSw5G96ABIon0zXqngfaoMr82jG/FZazzbPE2rdg9wysirj18YOznImJUnWi4wQ32FJGI/O2dz0f/gAPweMyzYx16ZUbfRHf4u201Wie2BW1D+97EY8o8v7yLrdZEtXxIgQZzkVPYxppa8g7+qYyd2Cz3iichFmppnS9CFveByyYYAD2+74FK1nVK3Sp5B1NbNALacEbw8RWUI03Q7jcNQa48fZqikG2kWB/1o/q0QLsGsLbuF4gytKA0XkOxrfZgjF0yFTZM9zPrLeOf8YRKDbCUv6+Y2sIV1QPINBTsamKyEpiTYUc8665OFjvD1xY8d2auIDSn5dknMxO6VdLvc8+NZEfcJ8gJY0zDFvQS38KCOOYGLmH3J27ROLdzKf7ADwMDXHtBpxXdRIiWMjY+xUv4uhW6blZbzowXG2hloyxnkf8JDCk6CMUByDbwESc7qK2hxzKzU6+Nt3wpyJHsSfg+GxkzN5Z/KtAYEm3XqfmIWNMGUVSU52x9MK058nVc4moleSwDsO4Dt5x2vRfC16kJLDQaeqn4knmauaVCAsMEYdSHOKlI8yWrq1509m3rXF+Wc1y7AzBOMQsVKKR+m/JCS1+nlFQR2lNUGxmj2FuRwW9Wr/LS8cp405APC3oJuRykPb06ECUHgzx6O2c5sJmCXGoOkPn1Mfb3HqoCTWQQFAdzrgI2hFOoq7fP6840Bom3DqCQkwKKNdFN
 nUuPGXAM
 3Z2kJWLSO53S13XGXT7c27HCjjdNLitDfdARzrB9aFW1+7HUy98W6hn7QpQ3ZCAXwJSwYThbD6FJMAYcBsq0RH9+OKOQYBS2Ns+Uw2fTwnjlTussVPF0+qa01zD8AW8lhdMxnucSlxrq1e3DxOfUNzbMfGiSoyfT/TzwKOxTxaabaM8nshY78NxkULf5QdHQ8Ubd4Mi0WVKGjmiva0oywE5wkoeTL2b5TH2CtUliA/k/2/0TNPRQCgbf5uTnmdAe/rGOEXXGUmr0jMGFwGy8MVC1adiEYIJ0gg8Bd7M8IbN9b633LMMVt2lrdr+nOF52tD4CbIV5BKHBK6us=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 14:55, Kiryl Shutsemau (Meta) wrote:
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

LGTM, but I think we could simplify and get rid of all the function
parameter additions by adding a field to alloc_context instead? We could
call it e.g. reclaim_compact_order.

The function nofrag_promote_order() probably doesn't need to exist, given it
has just one caller, could be just open coded.

What could be useful instead is wrapper for comparing order vs
ac->reclaim_compact_order. E.g. something like bool
order_nofrag_promoted(order, ac) ?

Vlastimil

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


