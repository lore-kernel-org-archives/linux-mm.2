Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F67DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 18:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08BF46B00A8; Wed,  1 Jul 2026 14:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03BB96B00A9; Wed,  1 Jul 2026 14:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47706B00AB; Wed,  1 Jul 2026 14:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B00306B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:06:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EA1F1C7327
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:06:09 +0000 (UTC)
X-FDA: 84940986858.15.607A60F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D0D514000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:06:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZURaPkY2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782929167;
	b=pSOkzNzdQN/RPPnHvoVoyVhJenSeb/GIXzECk9QE8PBuG+eKvoyO/KTjUdAfBiCu0n2fiW
	HIhJlfYHKXcBORQJOUhJDdXRRtbn9twTuWaCC8UuXXHlbhuv1h+zi7Itq+AWn1W6ws6Ctf
	g67kqAkvM5P9BVTJLiKfy/hOsLywwhY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782929167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuA2FTNwmdGy2rQ0QcpN6ZB+Fxg1RJq84PH1vLawc0s=;
	b=5sXJtxtx0+vnZNxwCJuZPtkz+UyZysHtEdfe+upcQRuOMnPOuBuEW9qtij12R4qKztpp+8
	pEEgfZ49kP3GWk6FAC2AtvapyZR7kXkHjg5VT0w5uOBpyHm7cFqNEAz5nGEWFPUpp7nUup
	Z2mQYxl+J3vpIo+OfXecygYXSAi7DWE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZURaPkY2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDCD960122;
	Wed,  1 Jul 2026 18:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4218F1F000E9;
	Wed,  1 Jul 2026 18:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782929166;
	bh=SuA2FTNwmdGy2rQ0QcpN6ZB+Fxg1RJq84PH1vLawc0s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZURaPkY2uJOehVBnRPiiPXsP7PP52P8XysPOSeAFDjLOgD89E2ZdhQC/x2pWnSSz9
	 yToaai+by31hvZQ9AdanEK69PSBwmJtcOIeycSUt67S6cOF/WDTaXgE0dmxFrAl6/p
	 0KpCe6E5/tFpvOLNbKdwJh6YDufB3w/DgZs39KIu5B+lejzPUql5eQ0EILrtNk7UI8
	 qfqz1cwEQmvEUTAXh7+tS/Yd2oAEHNqkGwGDWoweL9vMa1mEQrp1E6SVHuZPp8yUur
	 CKPP29p9K1328WYBdmUYHXSGFkGrE9tDO25tEvhg5xcFnGCj9p4aHqNUXi/4/E6hRY
	 vaxySkU29dYSw==
Message-ID: <3f013cf5-008a-4207-85ce-d6f7c0296d99@kernel.org>
Date: Wed, 1 Jul 2026 20:06:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-5-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260626182215.1107966-5-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7D0D514000E
X-Rspam-User: 
X-Stat-Signature: yues6y53zr8fupsyiza81ap7nzcy6ujk
X-HE-Tag: 1782929167-805188
X-HE-Meta: U2FsdGVkX1/APi83lmjFggXprsqqjtU12V8KgPEOI1ee800yrexj3o1OsyH7en95PU/3b623PBgfkzUnK4bT+UYBm0Mpw84mQ3scDPAPW+yOj6Nt9yVTb6ZN/G7Jnc8ZYpEcJg7xkTXBQYn0vQPhvcMUtChGXxMDbiaW5k+CZP3yVXgEJmvlu/5+jPJn63I1UBYkH+BXXnUxxPvPCeVrnjG768GelSHGIJfVyQaETV7b0ixKh+w+pN1Pg7lih11tU2g4vMBeBk7qYr89NCsUUZqK+bB88Rak4+VL70Pwo747aH5XAVaEvtNP21chmE3WxhyT5gz8Z7akNoK1Sgbgi7SNSfwQK/Wcqrl6uJv+ELa3+SJF890NThH3tt/YuHI6xR39OPDLTB4pHsyYtwBKCE2SQi25JneERrbQ4i+em3OiwhjkKMd2MihJSof97nabl0OIy0xFcoby0xquO7xKWpfHum32AXkvQzqgifyJOYeVblQJU0TINS49gKiRLFkQfF8a15ubHKTNQF/mLYeYPnVWiDLqF9pKwtPUCaIvRtmMukWKYcZ08344jWr6pl7Oa2kJZOWz5Jzyexab9JseYv9yUWADR6pG4/Hz68nNZqLGB2omDui68ww2htqfC43LlGKpyp5ey9MZCAmYPL9OcL5/S6Ojck8lmACNe5oM9+v2HDBEGV840guJ+MKqlSYYKhHJgig12UF3NOZ6AXxgIlHFqAWQXG0mO9eRcXfRFdpl61h5rR6m7yMM/UaRNHSkZsfWbNVd82nqjOhsIT6U/WMbN31AjxMiMPZVqfi5bijJgk7I2fqWH5YvHgzxKzO5yqnn3DY5NR5ka403ML7BIMwV7bnnK1AMkl3LnRuRY6bpIWIvY3IRLFZgZqAGPpRoTyHRKp11Z1wYg1YxAn72BA7ZM8VPBYDESPEDSEGNDORjO+9kekKfsHDac0yKxPip2t1yOAfWF2tVkQ4AX2a
 cnRoA1Ka
 GCUjNNqKImDAu4IutL20oORZubkERxnXbEZWPkcmMw4kZd93F+LwFNPa8yWdjLj1CZD/XxboRqD92JEI7KqU1u9goiPB3iAJIFpOl30CCTmmB0eQuFybvPvDxzxeMk7bz8tPEybzRK+vLUBQRxY3RqFv19RbaMntyVjwc3VtJH3ibSKkujzKxpKFDBjuUHcRm1vGe8i95jY/YQfPIROQT4bzQ6FjzIVkb5KBt2a7LRjCdaLqLu9hsehJnOD+y8izdc46OrBhmLq+OvOwV1nzKKdDx46F1OEaiIPnbZ7XhJPv3bEwxGXk0w8mKUCuTPXH4e4BJOVVMwlY8hdKZjKWGO8uSPd+F2uzdkZbCLCYvz85scG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 20:21, Johannes Weiner wrote:
> As we deployed defrag_mode into Meta production, pressure spikes and
> excessive swapping were observed on some workloads. Tracing confirmed
> that this is unmovable/reclaimable requests spinning in the allocator
> and direct reclaim, causing excessive amounts of swap.
> 
> The initial plan for defrag_mode was to rely on kswapd/kcompactd to
> produce blocks, and if those are overwhelmed under high pressure, let
> the allocator fall back (__rmqueue_steal()) after its retry loops.
> However, that retrying results in more reclaim on some of these
> workloads than we'd hoped, sometimes excessively so, spurred on by the
> !costly order conditions in should_reclaim_retry().
> 
> The storms are dependent on the request type. Reclaim will inevitably
> make room in existing movable blocks, since that's where the LRU pages
> live. So if movable requests retry on reclaim, they make progress.
> 
> When non-movable requests spin in reclaim that isn't productive. They
> cannot use the individually freed pages, and the process is unlikely
> to accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.
> They spin and overreclaim excessively, which tanks performance and
> triggers userspace guards like swap exhaustion or pressure based OOM.
> 
> To fix this, send non-movable requests, regardless of order, into
> pageblock reclaim/compaction. This way, they help move things along to
> meet the ALLOC_NOFRAGMENT bar. After this patch, the reclaim storms
> and excess OOM rates are no longer observed in production.
> 
> The longer-term plan is still to have all requests, including the
> movable ones, help make blocks to spread the cost of defragmenting
> more evenly and fairly; combined with proper watermarking to reduce
> allocation latencies in the common case. However, doing this naively
> unearths scaling and concurrency limitations in compaction that need
> to be addressed first. Promoting just non-movables for now is the
> minimally viable bug fix for the above issue.
> 
> Fixes: f38356df6474 ("mm: page_alloc: introduce defrag_mode")

That's from 6.15. Do you intend any stable backporting, or we just mark it
as a heads up for anyone who tracks fixes and might consider it.

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

LGTM but as my suggestion for 3/4 would change it a lot, will wait with
formal tags.

> ---
>  mm/internal.h   |  7 +++++++
>  mm/page_alloc.c | 36 +++++++++++++++++++++++++++++-------
>  2 files changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a2..1f636cfc859a 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1060,6 +1060,13 @@ struct compact_control {
>   */
>  struct capture_control {
>  	struct compact_control *cc;
> +	/*
> +	 * Allocation request order. May differ from the compaction
> +	 * order: defrag_mode promotes sub-block allocations to
> +	 * pageblock-order compaction; capture still matches at the
> +	 * original allocation order so prep_new_page() is consistent.
> +	 */
> +	int order;
>  	struct page *page;
>  };
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9dee1c47e795..575a99a4c723 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -728,7 +728,7 @@ static inline bool
>  compaction_capture(struct capture_control *capc, struct page *page,
>  		   int order, int migratetype)
>  {
> -	if (!capc || order != capc->cc->order)
> +	if (!capc || order != capc->order)
>  		return false;
>  
>  	/* Do not accidentally pollute CMA or isolated regions*/
> @@ -748,7 +748,7 @@ compaction_capture(struct capture_control *capc, struct page *page,
>  		return false;
>  
>  	if (migratetype != capc->cc->migratetype)
> -		trace_mm_page_alloc_extfrag(page, capc->cc->order, order,
> +		trace_mm_page_alloc_extfrag(page, capc->order, order,
>  					    capc->cc->migratetype, migratetype);
>  
>  	capc->page = page;
> @@ -4147,10 +4147,27 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	unsigned long pflags;
>  	unsigned int noreclaim_flag;
>  	struct capture_control capc = {
> +		.order = order,
>  		.page = NULL,
>  	};
> +	int compact_order = order;
>  
> -	if (!order)
> +	/*
> +	 * If fallbacks are not permitted (defrag_mode), we either
> +	 * need to reclaim space in a block of matching type, or clear
> +	 * out an entire block to allow __rmqueue_claim() to convert.
> +	 *
> +	 * Reclaim by itself is primarily freeing space in movable
> +	 * blocks, since that's where the LRU pages live. So this
> +	 * works for movable requests, but not for others.
> +	 *
> +	 * For those, promote the order to help make blocks, instead
> +	 * of spinning in reclaim alone unproductively.
> +	 */
> +	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
> +		compact_order = max(order, pageblock_order);
> +
> +	if (!compact_order)
>  		return NULL;
>  
>  	/*
> @@ -4166,8 +4183,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	fs_reclaim_acquire(gfp_mask);
>  	noreclaim_flag = memalloc_noreclaim_save();
>  
> -	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
> -					       prio, &capc);
> +	*compact_result = try_to_compact_pages(gfp_mask, compact_order,
> +					       alloc_flags, ac, prio, &capc);
>  
>  	memalloc_noreclaim_restore(noreclaim_flag);
>  	fs_reclaim_release(gfp_mask);
> @@ -4203,7 +4220,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  		struct zone *zone = page_zone(page);
>  
>  		zone->compact_blockskip_flush = false;
> -		compaction_defer_reset(zone, order, true);
> +		compaction_defer_reset(zone, compact_order, true);
>  		count_vm_event(COMPACTSUCCESS);
>  		return page;
>  	}
> @@ -4443,9 +4460,14 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  	struct page *page = NULL;
>  	unsigned long pflags;
>  	bool drained = false;
> +	int reclaim_order = order;
> +
> +	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
> +	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
> +		reclaim_order = max(order, pageblock_order);
>  
>  	psi_memstall_enter(&pflags);
> -	*did_some_progress = __perform_reclaim(gfp_mask, order, ac);
> +	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
>  	if (unlikely(!(*did_some_progress)))
>  		goto out;
>  


