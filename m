Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 365D2EF48E8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 08:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4922E6B0005; Fri, 13 Feb 2026 03:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440156B0089; Fri, 13 Feb 2026 03:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7996B008A; Fri, 13 Feb 2026 03:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7A76B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:46:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2393013AD41
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:46:19 +0000 (UTC)
X-FDA: 84438801678.26.47C7DA5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id A35BE160006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:46:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IfuFinF9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7bFjfbm7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HaAgs4JF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iCuEZKSA;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770972377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M6CtYIdpGRPdr5YJBB51g/H26wkAcNK4Ssdrvyg0HpU=;
	b=xCZt76p8wPPIAdys2dYXHEmFvrKi1AePXJIwKFJM95CJnBmYBPl1/5n2DJ46IQ5L7azFVn
	4U2NK5GU7Pj0rShAvwKXj5pdwuuF7SVqcbUYZhGKYvRb2wV/Q4SJOdxMhHOD0uhGxwpxw1
	Knu83iQp7S2RClK7LJjDS1vQ8lD+73M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IfuFinF9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7bFjfbm7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HaAgs4JF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iCuEZKSA;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770972377; a=rsa-sha256;
	cv=none;
	b=Kau99ADiqzqHEunQem5/QRudIlsmfIGpg9+5EgHyBNYDdI0CBwpjQN4pJqu6EkLjoZ2n+R
	OxjQxnCraCESCQ0kTorrKSR2FWjfZUwyyIl3XAegCJ4kxet1aI5/OWvrtnOMK/OYpzYUd8
	MOjJZ5E1WZ4fDGcOxqISn3YzZqH3aMw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B8CB65BCC4;
	Fri, 13 Feb 2026 08:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770972375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M6CtYIdpGRPdr5YJBB51g/H26wkAcNK4Ssdrvyg0HpU=;
	b=IfuFinF9bZM04PjikfvkhahiDsVKI4RCmXM9xqk8pcd2UaCuvrDeLVXhnWMBeb2J8gNS1x
	EMG9jVzhIkaHtMoabtyoMu1X4K23rwVI0amDLjNNhsX6hQGFPYByLiZlWWnXm0YhG2RciN
	9uv/6GazI+QhV1iqNNi/k7WmdmckZDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770972375;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M6CtYIdpGRPdr5YJBB51g/H26wkAcNK4Ssdrvyg0HpU=;
	b=7bFjfbm7azFrch5t22beas6meSFYyvoJq3cmXtxZtpdLFCpuvaNNe8AaAYVMwmzFpVQguq
	xdvnZN9Sv02oK+Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770972374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M6CtYIdpGRPdr5YJBB51g/H26wkAcNK4Ssdrvyg0HpU=;
	b=HaAgs4JFQk/w+uSkmmKxOgZaFG13shzu/gE7pRO0txjbZ9a5rPn1BNf3vTRHvDl9XGcUI3
	/l4NcL44dUX5/xtcEuTh3I96ofyPmz0mpjzhG9y4dKPLY6adSfjQIXNkFks/qN5sWxcQHx
	50jpvYIvhKmqxSUh+z29nioVmPBzboY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770972374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=M6CtYIdpGRPdr5YJBB51g/H26wkAcNK4Ssdrvyg0HpU=;
	b=iCuEZKSABPYTXxrtHBx+i6jJY9t2wDqw8s6NR1g2H32fk0M8liXbY1t4WUEQ4UfRPR2M51
	rUQ9+1po6jFeZ7Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E54C3EA62;
	Fri, 13 Feb 2026 08:46:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BCMhItbkjml6MQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 13 Feb 2026 08:46:14 +0000
Message-ID: <c2388a14-9ef1-419b-b86a-56629708be15@suse.cz>
Date: Fri, 13 Feb 2026 09:46:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9] mm/page_alloc: boost watermarks on atomic allocation
 failure
Content-Language: en-US
To: Qiliang Yuan <realwujing@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260213-wujing-mm-page_alloc-v8-v9-1-cd99f3a6cb70@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260213-wujing-mm-page_alloc-v8-v9-1-cd99f3a6cb70@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A35BE160006
X-Stat-Signature: gm43pkbzk3owhwqjmje8zx3jom41jkub
X-Rspam-User: 
X-HE-Tag: 1770972376-404222
X-HE-Meta: U2FsdGVkX19BAbv2zT7xPgkKdLv+6raz/21rkezuTWsIKcZAmtD7N4OBWHQuDKtDDvu6CgPRnLnwrl3wCQhJqA0Ml4AtDDH7IQ2dxkR4PnJnU1eP5O8TLfPKKuPpqtkpqCI9/u1dhOYjX96B69EXfSaBLfveC499RzKirov92DBstUaq6yPpkpe1W2ToXoR7hqZqQzwLHRWpbKvoU+/oYS4wzRkU0X/Oy+sqW9LDLM2caSmYSzlmSsFS0bgkXaSPQ1MLZXeX8VQ7v8TJoFTMYiN+Lu1O7f0TnSI/VgnEcmz8PqlNGoUVgsyOt7oAkLgwu5WXiFE+IxMeJzSege19mbPIXiJ2Ohw08bZX46SgMgz1qSvd8sAmuWblAhZuVvYpkKRfBG9U1kFHxTpTeLGRouGl2TdKp3hfMsSejG9P2cQq6v+M/Er6F5xUi9v5rTndBTTsqNDjSK3fFPDVmgr1NRzx0ACiL2gMKJXMFKY8X0xuhqYYxT8iwlRrCPcDe5QDCcdrNb52XhLLDcFGSQy9bKDWKPFwwg1Fr9TwTFn+kZga47iw1yKgGNk6ksSSFlk878I7+ULj/1jT/2Oq5JQNbieQSsKLPwlNWEcUhY81jDLbyzI1LRXWLQAzK6o4T/lUIKYQuPPf+Fr9sCg+EiEMAkMUkoKBM/B6gOKO6mI2O52gihZRWj6aczgQ6WnpESem9PPbe6suq2XmhpqeNg9A+iBB+h4iGST8LJTyg0j03Qd9fcTHjkpZQDgsq5b+M4MTO172cp8JyHhQ2Kgi+liESEUvyz7Qke8jwgFn6nwaZVH/IsDcaO5zi+bWbOCa3DxaqOL7tMLQrfQnGJEn2V7k20ati9mu6Hz66nfJzsbnwVYmK94Zmz+uzNlwt5WdJbgK1Aw3fITzSQrb7co/dtBnZlWl9CQQybwpt4zclUDuV6DVEbjUC+2Xn2OwFk1CCuKLnzLxUZ5rV50j0bYVV5Q
 kyRw5yj1
 UytmG9S5y8wtYD3XlHnmdbwTmB5nNhkmmtlYzv/+ANio3lAlx8Knv/hJ5WgEl/jx4GeDfLGDXFkTblgp4ItZ9XsGfO3NM32t3zoIPTotvJ37rG7Zp7Kn/moTu489Gr1JUT0dzeNxRMujDWzQksz1Aqda0ucmbVo3FQhIAHPqS+sjmfey2vZO6MCHgv1jNK3O7L+BfFk/rFcKDsuw6J9DeScdaSaTQPt6MEE/j2l90y4kr4tNO9pbyxFv9sJb/S0SmQ8WRKukxOoviVohQnVqSBjHD+54afVeJhRZS5wu1gALs/Jea3fMwrUnwRP9/xATtpzoUEhzogK+A4D6J2BkzyRCAwQbg0jyf14kxvfUmCss0d2Ij2w+WoCsd+gz3u+uE4a7T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 04:17, Qiliang Yuan wrote:
> Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
> pressure as they cannot enter direct reclaim. This patch introduces a
> watermark boost mechanism to mitigate this issue.
> 
> When a GFP_ATOMIC request enters the slowpath, the preferred zone's
> watermark_boost is increased under zone->lock protection. This triggers
> kswapd to proactively reclaim memory, creating a safety buffer for
> future atomic allocations. A 1-second debounce timer prevents excessive
> boosts during traffic bursts.
> 
> This approach reuses existing watermark_boost infrastructure with
> minimal overhead and proper locking to ensure thread safety.
> 
> Allocation failure logs:
> [38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
> [38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
> [38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
> [38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
> [38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535649.655523] warn_alloc: 59 callbacks suppressed
> [38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
> [38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> ---
> v9:
> - Use mult_frac() for boost calculation. (SJ)
> - Add !can_direct_reclaim check. (Vlastimil)
> - Code cleanup: naming, scope, and line limits. (SJ)
> - Update tags: Add Vlastimil's Acked-by.
> 
> v8:
> - Use spin_lock_irqsave() to prevent inconsistent lock state.
> 
> v7:
> - Use local variable for boost_amount.
> - Add zone->lock protection.
> - Add lockdep assertion.
> 
> v6:
> - Use ATOMIC_BOOST_SCALE_SHIFT define.
> - Add documentation for 0.1% rationale.
> 
> v5:
> - Use native boost_watermark().
> 
> v4:
> - Add watermark_scale_boost and gradual decay.
> 
> v3:
> - Per-zone debounce timer.
> 
> v2:
> - Debounce logic and zone-proportional boosting.
> 
> v1:
> - Initial version.
> ---
> Link to v8: https://lore.kernel.org/r/20260212-wujing-mm-page_alloc-v8-v8-1-daba38990cd3@gmail.com
> ---
>  include/linux/mmzone.h |  1 +
>  mm/page_alloc.c        | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 48 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 75ef7c9f9307..8e37e4e6765b 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -882,6 +882,7 @@ struct zone {
>  	/* zone watermarks, access with *_wmark_pages(zone) macros */
>  	unsigned long _watermark[NR_WMARK];
>  	unsigned long watermark_boost;
> +	unsigned long last_boost_jiffies;
>  
>  	unsigned long nr_reserved_highatomic;
>  	unsigned long nr_free_highatomic;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c380f063e8b7..8af88584a8bd 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -218,6 +218,13 @@ unsigned int pageblock_order __read_mostly;
>  static void __free_pages_ok(struct page *page, unsigned int order,
>  			    fpi_t fpi_flags);
>  
> +/*
> + * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
> + * This provides zone-proportional safety buffers: ~1MB per 1GB of zone size.
> + * Larger zones under GFP_ATOMIC pressure need proportionally larger reserves.
> + */
> +#define ATOMIC_BOOST_FACTOR 1

... so now we #define 1 but it makes little sense without that hardcoded
1000 below.

> +
>  /*
>   * results with 256, 32 in the lowmem_reserve sysctl:
>   *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
> @@ -2161,6 +2168,9 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
>  static inline bool boost_watermark(struct zone *zone)
>  {
>  	unsigned long max_boost;
> +	unsigned long boost_amount;
> +
> +	lockdep_assert_held(&zone->lock);
>  
>  	if (!watermark_boost_factor)
>  		return false;
> @@ -2189,12 +2199,43 @@ static inline bool boost_watermark(struct zone *zone)
>  
>  	max_boost = max(pageblock_nr_pages, max_boost);
>  
> -	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
> -		max_boost);
> +	boost_amount = max(pageblock_nr_pages,
> +			   mult_frac(zone_managed_pages(zone), ATOMIC_BOOST_FACTOR, 1000));

I don't think mult_frac() was a great suggestion. We're talking about right
shifting by a constant 10. In the other cases of mult_frac() we use dynamic
values for x and n so it's justified. But this IMHO is unnecessary complication.

> +	zone->watermark_boost = min(zone->watermark_boost + boost_amount,
> +				    max_boost);
>  
>  	return true;
>  }
>  
> +static void boost_zone_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
> +{
> +	struct zoneref *z;
> +	struct zone *zone;
> +	unsigned long now = jiffies;
> +
> +	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
> +		/* Rate-limit boosts to once per second per zone */
> +		if (time_after(now, zone->last_boost_jiffies + HZ)) {
> +			unsigned long flags;
> +			bool should_wake;
> +
> +			zone->last_boost_jiffies = now;
> +
> +			/* Modify watermark under lock, wake kswapd outside */
> +			spin_lock_irqsave(&zone->lock, flags);
> +			should_wake = boost_watermark(zone);
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +
> +			if (should_wake)
> +				wakeup_kswapd(zone, gfp_mask, 0,
> +					      ac->highest_zoneidx);
> +
> +			/* Boost only the preferred zone */
> +			break;
> +		}
> +	}
> +}
> +
>  /*
>   * When we are falling back to another migratetype during allocation, should we
>   * try to claim an entire block to satisfy further allocations, instead of
> @@ -4742,6 +4783,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (page)
>  		goto got_pg;
>  
> +	/* Boost watermarks for atomic requests entering slowpath */
> +	if ((gfp_mask & GFP_ATOMIC) && order == 0 && !can_direct_reclaim)
> +		boost_zone_for_atomic(ac, gfp_mask);
> +
>  	/*
>  	 * For costly allocations, try direct compaction first, as it's likely
>  	 * that we have enough base pages and don't need to reclaim. For non-
> 
> ---
> base-commit: b54345928fa1dbde534e32ecaa138678fd5d2135
> change-id: 20260206-wujing-mm-page_alloc-v8-fb1979bac6fe
> 
> Best regards,


