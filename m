Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48658CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01FBE6B0005; Wed, 17 Jun 2026 09:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F397D6B0088; Wed, 17 Jun 2026 09:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27F06B008C; Wed, 17 Jun 2026 09:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2BF36B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:02:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1789814040D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:02:43 +0000 (UTC)
X-FDA: 84889419006.04.ECB9B47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3941F1C000F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:02:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtJolJDj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781701361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6E26+5kY6MoXFl8u/iTM2G6jwrUJYyzdip1Sef576w=;
	b=VLv1v3ybA7Jj9y3lk7FwoEPigbroz5eeIXb3sdYyQ1VsnLjzv8FSoP6CLOW21duaIV8qbw
	cPJrY5RKKcxlIn4yf1NMlzZELlXWFVOVktqA5cpob5MtGxDJStGaxFZbt2n/WxHnfGcBbr
	Nv3/z9s8tGKTo+CBoILLkLD+eajUVzA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtJolJDj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781701361;
	b=1+KazJDqcxvroyuYWTcR01paI9LKVk2ONNL/F6WTvuzkyiP3gMuv68vUBYBKk2SZV370GK
	bXQQih+P40DdGBL8kd/1MNazxDnsFtpt6CSI+2S1/w1ulpXcHlD+wlqSb3sCtH5qVuDgCY
	8XHIy7JjAMcaOg202EYXcKD+dU1Ym2Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E6B64360D;
	Wed, 17 Jun 2026 13:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392FE1F000E9;
	Wed, 17 Jun 2026 13:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781701360;
	bh=w6E26+5kY6MoXFl8u/iTM2G6jwrUJYyzdip1Sef576w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FtJolJDjfI4fRWuEzyBZ8pejQV8Hom0Ou5bwcdOYJdhycs/Vxs7W5uggCLnAffeDu
	 PiijzstzA0ZaLy3ZzmtxfknefD8r4589HF96L3pV0YoGOX5K/SXyXnkQ+ibwjXyjZk
	 DqvTmBJRMCiiRekUJblLwf+lESOcsF1R32Dl52WCKUqteqsd0JVuVK3gRvW4BuAoah
	 x+P/1McfOEGUo2BruleXU6VvisWyx4gGQQekSRHprj9bjiFOdx8UW0uuRZJ6wLE3vI
	 2JWiXRuqUBpUTYwycBZgcxLJTRI6scZ2hCGCXdjLlq2m5CGpDh3GBdnCNFwDasPNQh
	 TwV0sylHWqb0w==
Message-ID: <fa69e7f3-45da-4722-b47f-e6fcd38717c7@kernel.org>
Date: Wed, 17 Jun 2026 15:02:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: use existing highatomic reserves on the
 buddy fastpath
Content-Language: en-US
To: JP Kobryn <jp.kobryn@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, fvdl@google.com, linux-mm@kvack.org
Cc: shakeel.butt@linux.dev, usama.arif@linux.dev, linux-kernel@vger.kernel.org
References: <20260616191420.52556-1-jp.kobryn@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260616191420.52556-1-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: g8gm35hy1e8meate63equkn4jdyw8yhy
X-Rspamd-Queue-Id: 3941F1C000F
X-HE-Tag: 1781701361-499705
X-HE-Meta: U2FsdGVkX1/lwzq6DCaWJb8nHZf0u4s3hlfeUhbq4kHGcE7xONJvnCapZSJOtyrxLlgm336nIFEjqJe4wGnXusvikF8mSX1dcJVsNklNqcj1zB6OyICSPNOwhIFE5mAU4UOmmm0BuIBTltfaOnTnqEacgrwbMl/a5Pab+81f8JyuIdpizmFzduvXjhsNJFBhWVJOm8QxWmc5Qzc00uEv6y57QYeN4sCCpFtE2r6IEhmWN5n943Q/cL+W+bXIlVjWWdWAMplyDlEqdXlMYE5SpNh0YDI02Kw38EFo2nbgbGpLagZlShJ816yQf9R1S0gt9X81ICVg3onMDCbWqqvuFhEbGOZbKSZwgyBv8IKGecWaJ3H2kC4zJxWPZKzFvY4GjjBETzZzqrdu+UjDVA0cVwBzvDRqW2/I6gfW13Bo1X+O3KUS9+qQW+exMg4gyxBkuYC+ic4BCYPlal3/gssIC7kOZRtXijKaDsXR4XjYTBiMdZZ0L9escwtPX5kKvgDlBub5iG5JYN1Vlk5ojtmPlcs4mQFjE7PvnIsvK7OLUK6sBIR4gQAGeMduudN9+sn6h1vTTCyUu5jaepWmnkLR/wY+RrREBOZWaGwYwRaWwSXTJNxKHpZuAo1fzDjt/Ibwb5FZuK84HwCn+QORqcSPBM6yKVkq3TpJZGQ7ZdXVj9kYE8w2ieu/Cx2ndChaxVc7C5ocxI/iP1tbAaOUDiDgZqJO62H/ycpZ2+J+PbJSLTWJCMyTrBPB8BQRSSJEC/U99l98PNe7+vQ23cpdotsGejyu0oR6xRFMeTdTWYOuyf/UcXLNvz56z5WFjnvH4OtMTj4PFpNz28Ik++AKuIFqpBxpl3LFGwdl+cKMNT8iGUBjlpsH+WEn+kuFNKCxIK4U2GNyPBsJAivGv2p0c3LDMfQAY35mijG63PxTkii2oorJKG6sL5Zt2XR68/8l7qulAGSAKyEcnjYy9WjBYPa
 ltqFfyec
 4pdZv5vKFENz1s+4NjExvp5lTVumsaY4nHB0Yd+pbzY0h8nwB/l3vpce032XdzHylwzFlSSYHZjsj5QPdVOi3IUhg/jxT1ZsBXd0bNvB6ATQtFChZz8q1aU9szVzfWm8bAvLz6GRT3F4btb6q0tCGJ6unXmR0SLhGODCa0DvWqJMzItJlil/ishH8tHZadoG9J3WwW7X2RfF2DmlcXHV/UDKy6eYoIGwfJuTnZxxZxT5FBRimupU5uRPUdy9PO/gWBLjhNyHcQ4e6iZxeQ4hMTm+2oFuQX88mGWQTG9ZdQMgBJjIPmFw24pLMgnFTof8z0zh8cP3iPpcrz4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/16/26 21:14, JP Kobryn wrote:
> ALLOC_HIGHATOMIC currently provides both access to MIGRATE_HIGHATOMIC free
> pages and permission to create new highatomic pageblock reserves. This
> makes it unsuitable for the fastpath.
> 
> However, the fastpath can reach rmqueue_buddy() while MIGRATE_HIGHATOMIC
> reserves have free pages available. In this situation, the allocation can
> fall back to other migratetypes without trying those reserves first.
> 
> Allow high-priority non-blocking allocations above order-0 and up to the
> costly order to use existing MIGRATE_HIGHATOMIC reserves on the buddy
> fastpath without granting permission to grow these reserves. Add
> ALLOC_HIGHATOMIC_RESERVE for allocations that may both access
> MIGRATE_HIGHATOMIC and grow the reserves. Change the semantics of
> ALLOC_HIGHATOMIC so that it may only access the reserves.
> 
> A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
> available in the target zone. Before this patch, the workload did not
> consume these blocks. With this patch, comparable runs consumed available
> blocks for 96-100% of eligible order-1 atomic allocations reaching the
> buddy path, with no highatomic misses observed. The workload did not grow
> highatomic reserves and NAPI page-frag allocations remained healthy with no
> failures or order-0 fallbacks.

Great.

> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>

LGTM, I have just one style suggestion. If you agree and apply it, feel free
to add:

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

... and (unless other reviews raise something) send v2 rebased to 7.2-rc1
once it's released. Thanks!

> ---
>  mm/internal.h   |  4 +++-
>  mm/page_alloc.c | 34 +++++++++++++++++++++++++++-------
>  2 files changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a2..a7693a9fdd29 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1477,9 +1477,11 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
>  #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
>  #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
>  #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
> +#define ALLOC_HIGHATOMIC_RESERVE	0x1000 /* Allows growing MIGRATE_HIGHATOMIC reserves */
>  
>  /* Flags that allow allocations below the min watermark. */
> -#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> +#define ALLOC_RESERVES (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE | \
> +	ALLOC_HIGHATOMIC | ALLOC_OOM | ALLOC_HIGHATOMIC_RESERVE)
>  
>  enum ttu_flags;
>  struct tlbflush_unmap_batch;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee902a468c2f..e1c28bc0ba3f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3222,7 +3222,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  		} else {
>  			spin_lock_irqsave(&zone->lock, flags);
>  		}
> -		if (alloc_flags & ALLOC_HIGHATOMIC)
> +		if (alloc_flags & (ALLOC_HIGHATOMIC | ALLOC_HIGHATOMIC_RESERVE))

I'd keep checking only ALLOC_HIGHATOMIC ...

>  			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
>  		if (!page) {
>  			enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
> @@ -3250,7 +3250,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  	 * If this is a high-order atomic allocation then check
>  	 * if the pageblock should be reserved for the future
>  	 */
> -	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
> +	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC_RESERVE))
>  		reserve_highatomic_pageblock(page, order, zone);
>  
>  	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
> @@ -3333,9 +3333,10 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
>  			 * Instead, direct it towards the reserves by
>  			 * returning NULL, which will make the caller fall
>  			 * back to rmqueue_buddy. This will try to use the
> -			 * reserves first and grow them if needed.
> +			 * reserves first and grow them if permitted by
> +			 * the ALLOC_HIGHATOMIC_RESERVE flag.
>  			 */
> -			if (alloc_flags & ALLOC_HIGHATOMIC)
> +			if (alloc_flags & (ALLOC_HIGHATOMIC | ALLOC_HIGHATOMIC_RESERVE))

Here too ...

>  				return NULL;
>  
>  			alloced = rmqueue_bulk(zone, order,
> @@ -3653,7 +3654,7 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
>  			return true;
>  		}
>  #endif
> -		if ((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_OOM)) &&
> +		if ((alloc_flags & (ALLOC_HIGHATOMIC | ALLOC_HIGHATOMIC_RESERVE | ALLOC_OOM)) &&

... ditto ...

>  		    !free_area_empty(area, MIGRATE_HIGHATOMIC)) {
>  			return true;
>  		}
> @@ -3773,6 +3774,24 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
>  	return alloc_flags;
>  }
>  
> +/*
> + * Let high-priority non-blocking allocations above order-0 and up
> + * to the costly order try to use existing MIGRATE_HIGHATOMIC
> + * reserves on the fastpath.
> + */
> +static inline unsigned int
> +alloc_flags_highatomic_fastpath(gfp_t gfp_mask, unsigned int order)
> +{
> +	if (!order || order > PAGE_ALLOC_COSTLY_ORDER)
> +		return 0;
> +	if (!(gfp_mask & __GFP_HIGH))
> +		return 0;
> +	if (gfp_mask & (__GFP_DIRECT_RECLAIM | __GFP_NOMEMALLOC))
> +		return 0;
> +
> +	return ALLOC_HIGHATOMIC;
> +}
> +
>  /* Must be called after current_gfp_context() which can change gfp_mask */
>  static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
>  						  unsigned int alloc_flags)
> @@ -4504,7 +4523,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>  			alloc_flags |= ALLOC_NON_BLOCK;
>  
>  			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
> -				alloc_flags |= ALLOC_HIGHATOMIC;
> +				alloc_flags |= ALLOC_HIGHATOMIC_RESERVE;

And only here add both ALLOC_HIGHATOMIC and ALLOC_HIGHATOMIC_RESERVE.
I.e. ALLOC_HIGHATOMIC_RESERVE would not be a superset of ALLOC_HIGHATOMIC,
but access to reserves and ability to grow them would be decoupled. The
comments on the flags actually suggest that's the case.

>  		}
>  
>  		/*
> @@ -5298,7 +5317,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  	 * Forbid the first pass from falling back to types that fragment
>  	 * memory until all local zones are considered.
>  	 */
> -	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
> +	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp) |
> +			alloc_flags_highatomic_fastpath(alloc_gfp, order);
>  
>  	/* First allocation attempt */
>  	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);


