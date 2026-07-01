Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DDC5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 18:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2FB6B00A8; Wed,  1 Jul 2026 14:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562A66B00A9; Wed,  1 Jul 2026 14:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A746B00AB; Wed,  1 Jul 2026 14:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 131066B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:03:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 937D4A048F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:03:02 +0000 (UTC)
X-FDA: 84940979004.06.5AFF3E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A7537A0013
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:03:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LqVbdaSM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782928980;
	b=7ef7a/wzbeAJ5CakmUzQXYxLeBOQ3S9klLUXcWgO+iX5xj1vBMfoiqxHUl+GJ51xzFrkpg
	p8zE5KOlISU42KfRdN+ouRPwD/kHn+eocUKvzQSLem0hw5bRBuUviWu4EwhRFQWP4gblqv
	bw6r8KAufpysyx3Ebth58KACgW2PinY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782928980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eREqeUP0xgJeEasKEkO8ipVJNCzjqtzLfhGVHKMiv0A=;
	b=WqXUhBxl0VLGs8CKpQXF8KYrVqTuqOehzhjnrpEJbWRoip3BuDvZRawsxfXRBq8OrmkYGZ
	YcMi8XLJxpzZ+22rJoTmqOf4BzyS18DgBtk07YXplNutvEg3odvmVw94D/n0spHXJfpIQr
	l6YyASL9qM+7ClzV7ia3d9jxFt3sJDA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LqVbdaSM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD06D41402;
	Wed,  1 Jul 2026 18:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B491F000E9;
	Wed,  1 Jul 2026 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782928979;
	bh=eREqeUP0xgJeEasKEkO8ipVJNCzjqtzLfhGVHKMiv0A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LqVbdaSMfsPoOBAFGgM5H2zcw4clr0Fj+YEHYz5Nl73DELl7oZoEW5VDvQbCG0oFT
	 JjKG6ZX6W8mfJYUBrO0IQS2/vc3SJ0eP7BS0UnrbI5JtqKRMIAR0VKUsD2HhUCipya
	 vFFau4JZ7jmY7cNgMVgsFRcqzOSbRkivPSs4EmQg15+L7ABj3dC5HS3/WWSyjo659Z
	 X8igFve7aJHpWO2btgZUfmLqVtm3LEqB1HCMakrfgvFTBBs56gQceCWMPaVOyKE/M3
	 soD15VbmR6sqDQu1v/NzkOtAMQR6joGuTuWmvtNBUfZZny07iLTL7vC2WuLHKzBwqZ
	 vU2Xz6JP1l0GA==
Message-ID: <c11c73ba-4422-4ef1-834d-6cc230146dea@kernel.org>
Date: Wed, 1 Jul 2026 20:02:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: page_alloc: move capture_control to the page
 allocator
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-4-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260626182215.1107966-4-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7537A0013
X-Rspam-User: 
X-Stat-Signature: s95fouoaq1j8rqppcsua9z19p5phtf74
X-HE-Tag: 1782928980-950201
X-HE-Meta: U2FsdGVkX19P+N4iReGndT3I8i0zau24DKbHQAX3H67n6h+ums0lMXjDmBt60rI6yUQBlI+VHLe+4wMhlfZr2ruy6gtUX4OKf/TSIOipneaDiHw1nS2q9rlIfi3wWoZtOOU6lYaVAfielSy0Gay5S9ePmUnNp6pvdanQ2SnrZ6AI97ZF5tsMTX/5MABsFXmeFpyjtNFk4J4EEfsRO2mXJoq+ogm0ZKs9/Ph7J9eJ88Dvbk1fhmUEJheffhPCD3H41OxflcH4WYrwFaL36pz4ksWJWpw9sVazSrffOP9bYsax28+Z5zCIs+JxCoIma7cwF3x4If0Ky7B8Ete6q+S0Sh6DqTwhERX/D0cas0N+ZylL77RYRIl/LjuneYCKQwS1DQ8uE3jLUz9bTFNWYz6q320dskrpZtOy9h3VVaDFUzEQOq3kHKglyFVSyMemgsaf44n8+GFJieZxK4CBlxixRxepuHZqG+844YvXeLLGreQMthUVYxuez5LgAOdwWxsq1PUYeFQAQhYOSQ4S+fcZBZqRWuuRrIa5YCNBPI/YrJ3thL48ENA8YTN7Gdktzzl45ApNorlVhanGNs8eNf4O8ho2WhXQvrq1QkPo6c2esgziclpgYlzrWAjFPGWTqmo9wsEz7yk1VnxUniyUSnzxJro6oAQ/vWwU/8Ojw8ftsbsuh1cMTa6SMT4stQNZ2262EXnhXbwPvtUvQYTj30p2DeZlQWHlXNCSy9Xg2I2WCPqx4/b8TGDv7+4gPbsjhdv6ddJSUvibvgtGJ5gLNcKG3H7KhXB40K889VcxrgmT3C6V3rJPVW7lXGklgv0pjphUzWAcsLEdZlVsodAS65mXFl+0EcTi5rE7gpjTkKoqFPqS15PKm3Uz5LlrKL8VBDgKibi6bqZgtfIt48rvYy7tOlA+3wiPDaeApRYpPLTheIzim+XZQS+yt2PfwbxDavG0uIx0poFw0sGHiKlWGCF
 HfgOYg5T
 rM7Ikv53owzxyuj1WNeapIok+cwHeKQ6hur6/Wx7RtYIggN7ZTngbbt1fvn58v4WjHmFmSSUMvKkOsBZOSlcAA9a5vDFACQ9Jpx4O3+81fBF45RkObOGQyhQkw03Qyz20G7yJQrCfYz22V4HSsKArb5wyF3LEAOkpk0+yarKTFKWN9oN1qDfZRW61wHXU/KS4Ibs7Bl3jZ00ShqN95sbTIk1gmUWRhZwYAFbepwnRBXUwBc/iFdVqOQGj4D5iWVWD60NmXIndcybG7goEGRNfxXVvOPx3z7YEnhYSy8CSejzmbMZWkSWWu3DTkcCKfz0EUSaRnDM+xMlCajCBLEQ/IZ8xZXemN6ycdSM9K9D7FkPfJ/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 20:21, Johannes Weiner wrote:
> The compaction capturing code assumes the allocation request order
> and compaction target order are the same. That won't be true once
> defrag_mode promotes sub-block allocations to pageblock-order
> compaction: compaction targets the larger order, capture should
> remain at the original allocation order.

Well I guess you could also try to capture the whole-pageblock page and then
deal with it as with whole pageblock stealing? But this works too and
perhaps it's simpler.

> Move the per-task capture_control to the page allocator, so its
> fields can carry alloc-side information that compaction's
> compact_control does not. Pass the capture_control through
> try_to_compact_pages() / compact_zone_order() instead of a bare
> struct page **; compact_zone_order() sets capc->cc while running.
> 
> task_capc() now also checks capc->cc to handle the new
> not-yet-running state.
> 
> No functional change.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/compaction.h |  3 ++-
>  mm/compaction.c            | 33 ++++++++++-----------------------
>  mm/page_alloc.c            | 23 +++++++++++++++++++++--
>  3 files changed, 33 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> index f29ef0653546..66a2f70e9e01 100644
> --- a/include/linux/compaction.h
> +++ b/include/linux/compaction.h
> @@ -58,6 +58,7 @@ enum compact_result {
>  };
>  
>  struct alloc_context; /* in mm/internal.h */
> +struct capture_control; /* in mm/internal.h */
>  
>  /*
>   * Number of free order-0 pages that should be available above given watermark
> @@ -92,7 +93,7 @@ extern int fragmentation_index(struct zone *zone, unsigned int order);
>  extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
>  		unsigned int order, unsigned int alloc_flags,
>  		const struct alloc_context *ac, enum compact_priority prio,
> -		struct page **page);
> +		struct capture_control *capc);
>  extern void reset_isolation_suitable(pg_data_t *pgdat);
>  extern bool compaction_suitable(struct zone *zone, int order,
>  				unsigned long watermark, int highest_zoneidx);
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 7df3a85d43af..c2701bf1d04e 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2791,7 +2791,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
>  static enum compact_result compact_zone_order(struct zone *zone, int order,
>  		gfp_t gfp_mask, enum compact_priority prio,
>  		unsigned int alloc_flags, int highest_zoneidx,
> -		struct page **capture)
> +		struct capture_control *capc)
>  {
>  	enum compact_result ret;
>  	struct compact_control cc = {
> @@ -2808,35 +2808,22 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
>  		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY),
>  		.ignore_block_suitable = (prio == MIN_COMPACT_PRIORITY)
>  	};
> -	struct capture_control capc = {
> -		.cc = &cc,
> -		.page = NULL,
> -	};
>  
> -	/*
> -	 * Make sure the structs are really initialized before we expose the
> -	 * capture control, in case we are interrupted and the interrupt handler
> -	 * frees a page.
> -	 */
> +	/* See the comment in __alloc_pages_direct_compact() */
>  	barrier();
> -	WRITE_ONCE(current->capture_control, &capc);
> +	WRITE_ONCE(capc->cc, &cc);
>  
> -	ret = compact_zone(&cc, &capc);
> +	ret = compact_zone(&cc, capc);
> +
> +	WRITE_ONCE(capc->cc, NULL);

I wonder if it makes sense to continue having capc->cc and this whole dance
in two functions. AFAICS (after patch 4/4) we access only capc->cc->zone and
capc->cc->migratetype. migratetype is stable in the whole
try_to_compact_pages(), could be part of capc. Order can be added by this
patch (with no semantic change to it) and not the next one. Zone varies, but
could be also in capc and set by try_to_compact_pages() before every call to
compact_zone_order(). Then compact_zone_order() doesn't have to set up any
capc fields anymore?

>  
> -	/*
> -	 * Make sure we hide capture control first before we read the captured
> -	 * page pointer, otherwise an interrupt could free and capture a page
> -	 * and we would leak it.
> -	 */
> -	WRITE_ONCE(current->capture_control, NULL);
> -	*capture = READ_ONCE(capc.page);
>  	/*
>  	 * Technically, it is also possible that compaction is skipped but
>  	 * the page is still captured out of luck(IRQ came and freed the page).
>  	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
>  	 * the COMPACT[STALL|FAIL] when compaction is skipped.
>  	 */
> -	if (*capture)
> +	if (capc->page)
>  		ret = COMPACT_SUCCESS;
>  
>  	return ret;
> @@ -2849,13 +2836,13 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
>   * @alloc_flags: The allocation flags of the current allocation
>   * @ac: The context of current allocation
>   * @prio: Determines how hard direct compaction should try to succeed
> - * @capture: Pointer to free page created by compaction will be stored here
> + * @capc: The context for capturing pages during freeing
>   *
>   * This is the main entry point for direct page compaction.
>   */
>  enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
>  		unsigned int alloc_flags, const struct alloc_context *ac,
> -		enum compact_priority prio, struct page **capture)
> +		enum compact_priority prio, struct capture_control *capc)
>  {
>  	struct zoneref *z;
>  	struct zone *zone;
> @@ -2883,7 +2870,7 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
>  		}
>  
>  		status = compact_zone_order(zone, order, gfp_mask, prio,
> -				alloc_flags, ac->highest_zoneidx, capture);
> +				alloc_flags, ac->highest_zoneidx, capc);
>  		rc = max(status, rc);
>  
>  		/* The allocation should succeed, stop compacting */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cb422505c6ef..9dee1c47e795 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -718,7 +718,7 @@ static inline struct capture_control *task_capc(struct zone *zone)
>  {
>  	struct capture_control *capc = current->capture_control;
>  
> -	return unlikely(capc) &&
> +	return unlikely(capc && capc->cc) &&
>  		!(current->flags & PF_KTHREAD) &&
>  		!capc->page &&
>  		capc->cc->zone == zone ? capc : NULL;
> @@ -4146,23 +4146,42 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	struct page *page = NULL;
>  	unsigned long pflags;
>  	unsigned int noreclaim_flag;
> +	struct capture_control capc = {
> +		.page = NULL,

You didn't set .cc to NULL explicitly...

> +	};
>  
>  	if (!order)
>  		return NULL;
>  
> +	/*
> +	 * Make sure the structs are really initialized before we expose the
> +	 * capture control, in case we are interrupted and the interrupt handler
> +	 * frees a page.
> +	 */
> +	barrier();

So either an implicit { } NULL / zero initialization + barrier() is enough
(I hope so) and we don't need to set NULL / zero in every field explicitly.
Or not and then we should set every field and not just page.

> +	WRITE_ONCE(current->capture_control, &capc);
> +
>  	psi_memstall_enter(&pflags);
>  	delayacct_compact_start();
>  	fs_reclaim_acquire(gfp_mask);
>  	noreclaim_flag = memalloc_noreclaim_save();
>  
>  	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
> -								prio, &page);
> +					       prio, &capc);
>  
>  	memalloc_noreclaim_restore(noreclaim_flag);
>  	fs_reclaim_release(gfp_mask);
>  	psi_memstall_leave(&pflags);
>  	delayacct_compact_end();
>  
> +	/*
> +	 * Make sure we hide capture control first before we read the captured
> +	 * page pointer, otherwise an interrupt could free and capture a page
> +	 * and we would leak it.
> +	 */
> +	WRITE_ONCE(current->capture_control, NULL);
> +	page = READ_ONCE(capc.page);
> +
>  	if (*compact_result == COMPACT_SKIPPED ||
>  	    *compact_result == COMPACT_DEFERRED)
>  		return NULL;


