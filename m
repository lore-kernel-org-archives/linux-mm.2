Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57F39EE3695
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 15:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841706B0005; Thu, 12 Feb 2026 10:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF566B0089; Thu, 12 Feb 2026 10:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A69A6B008A; Thu, 12 Feb 2026 10:38:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5894E6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:38:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14C3C85E7A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:38:47 +0000 (UTC)
X-FDA: 84436212294.01.CCA7D71
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5651018000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:38:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N+o54+yK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kKHFIOue;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N+o54+yK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kKHFIOue;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770910724; a=rsa-sha256;
	cv=none;
	b=TWLymqBHFPEMcODY/Hd8FNFg9elS3yB/TfBX3gs4b6LnyiI6BULrIOwrIan/dXePuu+HQJ
	6OdLB09x+muhS/NYO8rUuYpVvqvhuaDMtqn5v4n3YcLZY57El/l1SfTgwbNYS8jEBxlDFj
	+T6P2WucR2M5YShQNsGx0RN9yE2cNx8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N+o54+yK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kKHFIOue;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N+o54+yK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kKHFIOue;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770910724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PfGWL/rt1aEsogXnh1AKwuqYNfzYprrXYng+9VXrqZA=;
	b=2BNFQfrQkKtCvSr09VlbQpHHgwaRUhGuBl3o/9x9pcIOKfVr8HPLrmmZ3ltHCvfHldiFxn
	rhBH7uoYrJBnIjyw16/OAfW/FwfhQLG3k+mx7LpWwWuXTjkH0RglVnoShR1GmpK0mth6gN
	/TVBcHLnrzePuKYgJLKwa7AluFovQEE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A1EE63E6D6;
	Thu, 12 Feb 2026 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770910722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PfGWL/rt1aEsogXnh1AKwuqYNfzYprrXYng+9VXrqZA=;
	b=N+o54+yKYeJrHDujmqUh7RpIiTYQkQejcc4VLsn0GiJ0tj8PliQ3ZZsIClejDZFDMpzorx
	7qmBhMUJ8nlfmoudtU+2KjDQBQlX3/El+km+KXyRhSjsJxxY8fqrsjUHdmJpvttdiL01YJ
	pbf7GgYuHnXLQimzMxLoBRtMV0ZwMdM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770910722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PfGWL/rt1aEsogXnh1AKwuqYNfzYprrXYng+9VXrqZA=;
	b=kKHFIOueeKtor6Ch0xJ1mQiqzOlhtqapCU6UMmytxmcWNqcEAVXuEgh1NmKHQCII2m/vem
	ad/qv/iCiy8oDkAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770910722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PfGWL/rt1aEsogXnh1AKwuqYNfzYprrXYng+9VXrqZA=;
	b=N+o54+yKYeJrHDujmqUh7RpIiTYQkQejcc4VLsn0GiJ0tj8PliQ3ZZsIClejDZFDMpzorx
	7qmBhMUJ8nlfmoudtU+2KjDQBQlX3/El+km+KXyRhSjsJxxY8fqrsjUHdmJpvttdiL01YJ
	pbf7GgYuHnXLQimzMxLoBRtMV0ZwMdM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770910722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PfGWL/rt1aEsogXnh1AKwuqYNfzYprrXYng+9VXrqZA=;
	b=kKHFIOueeKtor6Ch0xJ1mQiqzOlhtqapCU6UMmytxmcWNqcEAVXuEgh1NmKHQCII2m/vem
	ad/qv/iCiy8oDkAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6051E3EA62;
	Thu, 12 Feb 2026 15:38:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QgJZFgL0jWkaFgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 12 Feb 2026 15:38:42 +0000
Message-ID: <fab33f4e-494e-4f21-8c1b-1a19e455b6f6@suse.cz>
Date: Thu, 12 Feb 2026 16:38:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v8] mm/page_alloc: boost watermarks on atomic
 allocation failure
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
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>,
 Qiliang Yuan <yuanql9@chinatelecom.cn>
References: <20260212-wujing-mm-page_alloc-v8-v8-1-daba38990cd3@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260212-wujing-mm-page_alloc-v8-v8-1-daba38990cd3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5651018000D
X-Stat-Signature: 1dpu5buc7f1xpfizawrze4oi3h55tkth
X-HE-Tag: 1770910724-955700
X-HE-Meta: U2FsdGVkX1/v8ybz5bqrrAbNW2c3yf6yk7iMT8JUtmeaxVJd8yEgCdEKkYKtOe0rdUZLU/ELAio4IL3u2rj1jtL1LUVYRFlDK5iixrz3Lc1N6CGeGv7tQPG1AY/8JdoYx+BdwjkdBgh+D+X5D3UKipoFb8sZlquG81cRFExDdlsVzvbwrEdHJNLpX5TcH6tIQyAZajmodihI5H9Qza7CLuhXxQcmeykZBPj53SQmuMtitgdLSeHoDqpl56gSh8Vvvgu+uDrwlMf/mtjXc9pNeV9X/MPSuStiA5VKaK4JJ4upVseTscjBSeHFNR/zt6hhgYXelyzK9iPPVb85rEhPAaAt56plMZVm9av7fb5XN410auie1oOkbYaFO5XIZzRx6hG6wWfHyVyp7jXAV0d+WRBtvAnbC55Eddhw9Fptnolid5sHjPNQcG1kPXDDgRy/dqdBMWSurEnDpW5tkC690fzEyCD+rRD6kGLeEssLnuEB2Fz/atZvM7qaLXpGd1qUFRr7CWi2SiFdcORv8IzZ4Z5po6zjwPwBE8lbGp025KsxrKYAsiaxxmfePfk1Zhq1NOJC+aDUcgwyR6xL0CDU0YjETgIUtuZgwSw7UXq3Px7VQR5wf/VQejkR3lw48Q5AA+uwsLgOA2KV5cryRayw0UKf9rZhn0+244kx0M0bRHwsFoytnarpIfdMVI4gzyHu67iz2mir6OwKbILgLagv9+j/g1+9Jeyi8vQkV3L3Ij6uBJjezYcRNdYqp3VFPRGENhlLUNmXTstWYkDQrgK4pbAgBlGh1HFpHkmmoJslqoLJdIvBXHL2rrIvQhvL2zaJ3s9oGrA5O0z2XRHYNMnzKgBTErPJS/CHxmgZbgK0bvwKr8vmsL4WvdKZw4Y/Se0N0V0U7e0NPnAhjrkgxkJ3dcIO545AEAJPj6L1cy7W55QLy8UwVbYBUjPbZMViMmDGzl6QBkS7XLxL0CxVIJu
 Ekeg6Ch6
 Sw07Sv5LiEKQfVIDQEVaWQdF3IuFzPERvD/zdoVmjxcyVp1z5JZt9uW7YSR+BEJkjANL1RwhR9t39dsaQimDc5AEuaER12HYyd7Z1i5Njz8+sPINw7Mk9WrEoCRqB1Rs6Ih1zqOZg3X0yzwGp9As/smnzn5lqIRdkfeheaFb+4ZDyoKPb7u+/5eX44OMCxbjLQ+mlvUhSfRNbmM/gsY/46dX3rkVE6a2EJ+xqBNhJpjpXNbBJKTSUC5jJVvJWdLqMHFB9m/KbT8Y4NC3xrz/T27kZ53ETd15l+bVRZcEAxv2XGdWvKpqZ4Fms4NF3qKaqk3UoIkaG7ZlCuw1E7ivVSIVHBDMDeWJ2duY9qjgulq1tDR3ihDcIQkyKQjQKcqgaKgmFZkKgLMB7RVVuO1hFbyIH8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 08:27, Qiliang Yuan wrote:
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
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202601271341.5d24a59f-lkp@intel.com
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Nit:

> ---
> v8:
> - Use spin_lock_irqsave() to prevent inconsistent lock state (softirq-on
>   vs in-softirq) as reported by LKP.
> v7:
>   - Use local variable for boost_amount to improve code readability
>   - Add zone->lock protection in boost_zones_for_atomic()
>   - Add lockdep assertion in boost_watermark() to prevent locking mistakes
>   - Remove redundant boost call at fail label due to 1-second debounce
>   - Link: https://lore.kernel.org/all/20260123064231.250767-1-realwujing@gmail.com/
> v6:
>   - Replace magic number ">> 10" with ATOMIC_BOOST_SCALE_SHIFT define
>   - Add documentation explaining 0.1% zone size boost rationale
> v5:
>   - Simplify to use native boost_watermark() instead of custom logic
> v4:
>   - Add watermark_scale_boost and gradual decay via balance_pgdat
> v3:
>   - Move debounce timer to per-zone; optimize zone selection
> v2:
>   - Add debounce logic and zone-proportional boosting
> v1:
>   - Initial: boost min_free_kbytes on GFP_ATOMIC failure
> ---
>  include/linux/mmzone.h |  1 +
>  mm/page_alloc.c        | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 47 insertions(+), 2 deletions(-)
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
> index c380f063e8b7..7dc1e056a082 100644
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
> +#define ATOMIC_BOOST_SCALE_SHIFT 10
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
> @@ -2189,12 +2199,42 @@ static inline bool boost_watermark(struct zone *zone)
>  
>  	max_boost = max(pageblock_nr_pages, max_boost);
>  
> -	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
> -		max_boost);
> +	boost_amount = max(pageblock_nr_pages,
> +			   zone_managed_pages(zone) >> ATOMIC_BOOST_SCALE_SHIFT);
> +	zone->watermark_boost = min(zone->watermark_boost + boost_amount,
> +				    max_boost);
>  
>  	return true;
>  }
>  
> +static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
> +{
> +	struct zoneref *z;
> +	struct zone *zone;
> +	unsigned long now = jiffies;
> +	bool should_wake;
> +
> +	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
> +		/* Rate-limit boosts to once per second per zone */
> +		if (time_after(now, zone->last_boost_jiffies + HZ)) {
> +			unsigned long flags;
> +
> +			zone->last_boost_jiffies = now;
> +
> +			/* Modify watermark under lock, wake kswapd outside */
> +			spin_lock_irqsave(&zone->lock, flags);
> +			should_wake = boost_watermark(zone);
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +
> +			if (should_wake)
> +				wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
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
> @@ -4742,6 +4782,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (page)
>  		goto got_pg;
>  
> +	/* Boost watermarks for atomic requests entering slowpath */
> +	if ((gfp_mask & GFP_ATOMIC) && order == 0)

I'd also test && !can_direct_reclaim, we don't want to boost for allocations
that can reclaim and yet specify __GFP_HIGH.

> +		boost_zones_for_atomic(ac, gfp_mask);
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


