Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D3BBCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 18:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2B36B0088; Tue, 29 Sep 2026 14:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7923C6B008A; Tue, 29 Sep 2026 14:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680856B008C; Tue, 29 Sep 2026 14:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B61B6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:39:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EDCF1A05E7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:39:46 +0000 (UTC)
X-FDA: 85267663572.24.EB9080D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8C1B72000E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:39:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bsq+MtNW;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790707184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoY6gHtBmU6a534BKFQNg6hiDEc/4mQhGdZ4OCtJxeQ=;
	b=3AKLnvbZ4FUM8OnfVYhtdq98DygXdUxCt9TL45a6wGD9Np4g/oNQgeFe/KIcisj0EFANAO
	scRNz0EzEyVLGMyYD0bwTe4XqdDsPSbrso3+GV7Y+piPiFhgS2EXrDQeY/xmn+vZ5pY3pq
	C0nEVs56MWb6v6P8jsI1GXPfKxqtc2Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790707184;
	b=kwNmXhTnPmuKjhniZ5y+dbYpdq69DnrftxpadU8Xqa0WMddAEACpin0IVw77MA7PHfcvrs
	SlLQ2mwEaTLHfvf5+oIKmYSvBzBAdVKPf7reIShmz3hIF7UYCeuVV5acN0tr6P9YcQLt/Z
	V0KUnPg0IJfjFv4o5Ovma0cyIG9NWNE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bsq+MtNW;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 797AA40841;
	Tue, 29 Sep 2026 18:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10C51F000FF;
	Tue, 29 Sep 2026 18:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790707183;
	bh=eoY6gHtBmU6a534BKFQNg6hiDEc/4mQhGdZ4OCtJxeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bsq+MtNWtOdA2aq+jJuJnDVkljsirbp93Y5SrZcHi14dt0uaKoWpyhZ/rbbQBd7vt
	 XVyIEV0VOlNgIor4uAWUz/xisoDqPgJJPxHNmWSBSgyAn50jJwS3oy8atqrVH2Nuai
	 XaIk6M37xjlp6hWy61bSibBbRVBiljmy6yQTzmcrEMaa5eMjcZGMamnFDKNM+9s+5Z
	 N2DfxO52obWbANfCpTuRhA2brNAZ7RLFiWIGMuOdPYBeG+1WnCtb1uSIsEgcSkPaOY
	 ChyUj47kxyIld535jBIctREbkI6Dj5g0tymHTgh+L1cVoDtftXbdRcmb3bcxQgBKAW
	 dAYoJMRNTM1vA==
Date: Tue, 29 Sep 2026 19:39:41 +0100
From: Harry Yoo <harry@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <arv8J7ysrdazJmfY@thinkstation>
References: <20260929174553.175333-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929174553.175333-1-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C1B72000E
X-Stat-Signature: b9hykcbtbrxanzzyua89nukuie4883p9
X-HE-Tag: 1790707184-777761
X-HE-Meta: U2FsdGVkX18pvSXt/nHq2EwoSbvCJAYnHgf5Qa5IsOUomKu4i64HGWi5bB2yDiNLuudayR5cxeyZbRjwoU30Ax+Ae/cMfYFtF3V0V/AutCd73ojkYw/zUP4AzQ1wjLd+bIA9u1lg7+Kw8BHHWiiT/DFoqx5NHPvglO8EOaEb8LzvcBuHwyGKrHmmRxYMHCgZZiV0PXCjx0lslFxGVKhAAbxdn55puPGWNpxyOZ+K6D0IXxbKuuo8+MeuLDNVxnnVvR7mGHmRAMobG6rMqKK1fNvFsZKsp0XZr0A1vDlnt7tryXUK/moFVoeNRWulfS5aiwp7nuzd4wlzRY4TPJduv5dL/T/elyLL9YgASsS3DDGWTSn1Nd1/7O6rzJlKEZEXpJaxgp0zbfBL6voUAQ+/Ij+1mnitcixfctAVgtaToe0gbAXNlgI699wwSFZSt+9dlSmMwHI9qATJNHecekYbfR3jVRp1kAnJQquInQAMTzKnp1NELzOFwZpqvUT9pNYF6lL1b6GhtgH9FqhqRYTqcfujs0yLuOELTsF/EYyIjag48arcyHsBgdt6tP3ayzO2qzav/bGDYldT4BWeepCoacY5T73lPkgV+kvcZK1r8rw6wMF2qOU/D+zE2DqrB4N6zlM+oniznvAAQduejaxnhbCNW8cRRSuqFbPRLdcG9GXQzKawWWE/+eK1zmpd/+5AdOLU3kXD1oaR0eEcHMG9klSmMhC52ddJy2cnWNqi8vpAOaOyfcHRL1inJujZ4XN2sB2kV09IZaBC6gJYMRnEa0h12jHfMiHShdAYqO6kxIURDfRgIFjcqPyknE/f/ZN29zmSi4Cmyb5A8/wRmAfSaTRcaLIAPyE9UfInf2OJARIC5okmAGWdzR6r7+BxX2xxq76Nh6w9s3qGNJOYLYx3kY40BY8QP4ZJq6HKzYtQTxW2r0IJ522SJA62dejv69tILXUsdeWEoWqYdRaMr0S
 PLqxghPy
 tCgWhdQOWoYI+shb4gxDAeAae3smYex2FgMGIDAUloubsqRf9O0fB9Y1VFP7Sh5kTTcrJhNBqZTkg+0LP/UZivdADeg0Pkayg6URR+AJJqtNJQcEAea6RNwRcp5WQ/0kN8YN++SrpZjEN4dvNGZnsaLcFDPBcpA22/ukecaWCGXZZrkDhKQuEVbUO9QL8Rp7yZlm6aoeezWpuIRbUcvEhTI80RQhgVeQom07S3PRTNlL7lazXCSgPO13lFYFTbb/SYUbB+ZV4GiTp9C5oE/fZ5SXq5HXoqkq2X0cS0fecaWfcUp+W8hg9HOr58e1+oLNczQG7ENkKEMKSWDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 06:45:51PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
> storm in defrag_mode"), direct reclaim and compaction for non-movable
> requests under defrag_mode run at pageblock_order, to produce the whole
> blocks that ALLOC_NOFRAGMENT needs.

> The retry decisions that follow still use the request order.

Indeed, good catch!

> An order-0 request can therefore retry
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

Makes sense to me.

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
> Treat promoted requests like costly orders:
> 
> - Reclaim progress does not reset no_progress_loops for them.
> 
> - should_compact_retry() checks the compaction result at the promoted
>   order. It does not retry COMPACT_SKIPPED, since the request can fall
>   back, and it does not escalate compaction to COMPACT_PRIO_SYNC_FULL.
> 
> When the fallback is taken, reset the retry counters, so that the
> fallback attempt gets a full retry budget before the OOM killer is
> considered.
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
> Cc: <stable@vger.kernel.org>
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/page_alloc.c | 85 ++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 56 insertions(+), 29 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..608487672d93 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4127,6 +4127,31 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
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
> + * compaction results - must account for the promotion as well, see
> + * should_reclaim_retry() and should_compact_retry().
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

I think we should start distinguishing order and compact/reclaim_order
in __alloc_pages_slowpath(). Silently overriding it makes it harder to
follow and easy to make a mistake.

>  /*
>   * Maximum number of compaction retries with a progress before OOM
>   * killer is consider as the only way to move forward.
> @@ -4256,8 +4266,11 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
>  	bool ret = false;
>  	int retries = *compaction_retries;
>  	enum compact_priority priority = *compact_priority;
> +	unsigned int compact_order;
>  
> -	if (!order)
> +	/* Check the compaction result at the order compaction ran at */
> +	compact_order = nofrag_promote_order(order, alloc_flags, ac);
> +	if (!compact_order)
>  		return false;
>  
>  	if (fatal_signal_pending(current))
> @@ -4299,7 +4316,7 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
>  	/*
>  	 * Compaction failed. Retry with increasing priority.
>  	 */
> -	min_priority = (order > PAGE_ALLOC_COSTLY_ORDER) ?
> +	min_priority = (compact_order > PAGE_ALLOC_COSTLY_ORDER) ?
>  			MIN_COMPACT_COSTLY_PRIORITY : MIN_COMPACT_PRIORITY;

This would change how hard we try to compact with defrag_mode in direct
compaction as it won't try compaction with MIN_COMPACT_PRIORITY anymore.

It doesn't make much sense to change that as part of this fix?

>  
>  	if (*compact_priority > min_priority) {

-- 
Cheers,
Harry / Hyeonggon

