Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61AA5E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF8A6B0088; Wed, 18 Feb 2026 03:36:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775E16B0089; Wed, 18 Feb 2026 03:36:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D246B008A; Wed, 18 Feb 2026 03:36:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48FC86B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:36:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5C258B875
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:36:11 +0000 (UTC)
X-FDA: 84456920142.27.D970510
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 53502C0007
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:36:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZtGjmUVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/hrEmmrF";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZtGjmUVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/hrEmmrF";
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771403769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKVgZE9hqWLTM2F33iHCDVoIXlIkCwugb1loxQYMiaw=;
	b=xxs19cy2kop9zZlhEvdPaWxZbhk+8m4ND3xUwnWA/9okOIu7sw0lq3Tnau5X/SRdo/Ac8z
	yGJNYj3/Seu5mClAo2B8q4WmT27JKPIxT2YVvK7KhYGRZ1zeKDgunpADZviBqu3e7M6W7i
	cVoHlIaqw27AdjTygsfjvGhlQmyrD9w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771403769; a=rsa-sha256;
	cv=none;
	b=pHFm/uWu15ad0l01v9RnWlCwpHT9jJkxKD/NqkEy44swhOdqefaLyN3egHrCta8PMxrTn+
	ew8WhQp1suMpETMSTe/B8gnJsVW3/MSPw54SY47MGd4Y5JY/lR/hhKyBhrXybFbv9nbu/+
	V2uQkRNlyzxn/C2ShU/BZ7Auex20QTU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZtGjmUVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/hrEmmrF";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZtGjmUVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/hrEmmrF";
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 84E815BCD3;
	Wed, 18 Feb 2026 08:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771403767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FKVgZE9hqWLTM2F33iHCDVoIXlIkCwugb1loxQYMiaw=;
	b=ZtGjmUVrOCRCfGrG24Soe3RUgsKU7JsXlteG5IwkH7HIvTljsPsaifXkqZdo3m50+VvYRw
	mNzMo9w0ZeU0o2U8IXD43gv6CRZ1J8ka+eRJEOgn6O3uf7osgf1x0F8MRotF2ReWSict4O
	nQdiGBXYS+6HT0QLLix4tsP53FiuLmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771403767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FKVgZE9hqWLTM2F33iHCDVoIXlIkCwugb1loxQYMiaw=;
	b=/hrEmmrFjZsXVJU5uL5Mdnf4b8ET+TKddaDqZgPqaV1aAX3uuKL4Wtdu8jeZMvGpMVMTC8
	IQzpqbOcRttirADA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771403767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FKVgZE9hqWLTM2F33iHCDVoIXlIkCwugb1loxQYMiaw=;
	b=ZtGjmUVrOCRCfGrG24Soe3RUgsKU7JsXlteG5IwkH7HIvTljsPsaifXkqZdo3m50+VvYRw
	mNzMo9w0ZeU0o2U8IXD43gv6CRZ1J8ka+eRJEOgn6O3uf7osgf1x0F8MRotF2ReWSict4O
	nQdiGBXYS+6HT0QLLix4tsP53FiuLmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771403767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FKVgZE9hqWLTM2F33iHCDVoIXlIkCwugb1loxQYMiaw=;
	b=/hrEmmrFjZsXVJU5uL5Mdnf4b8ET+TKddaDqZgPqaV1aAX3uuKL4Wtdu8jeZMvGpMVMTC8
	IQzpqbOcRttirADA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 503AA3EA65;
	Wed, 18 Feb 2026 08:36:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j0CrEfd5lWnsLAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 18 Feb 2026 08:36:07 +0000
Message-ID: <e011c6a8-cda5-42ce-9d42-b23d1c81b26b@suse.cz>
Date: Wed, 18 Feb 2026 09:36:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10] mm/page_alloc: boost watermarks on atomic allocation
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
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260214-wujing-mm-page_alloc-v8-v10-1-bdfea431fd97@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260214-wujing-mm-page_alloc-v8-v10-1-bdfea431fd97@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Stat-Signature: 7qky7k6qpomtpo3tq4fu7on54hgo6j7i
X-Rspamd-Queue-Id: 53502C0007
X-Rspam-User: 
X-HE-Tag: 1771403769-713940
X-HE-Meta: U2FsdGVkX1/twfmnWHUvLVFtbRjwJ+1vzyW4il6vrscXkwc7lEDrP6Re8DsDEvEkoCRCTiwabBQsnTH2B7s5cq3yRdMMTxjAJhAFMRv6wEJThiYTKEswAQZhCbjPW9L/a851Ab9+c/g5oeu412RJHW+Ich3XrhNACenRsyiMVHSvLJvlf65YmIV/Lf6FQIbXyx+hpeMESLXsoFjDV5Aft1UnLFFadtQNGsmHQkWWexwfuRdJbgS8tgW1/vROqc0ZLekjRd/qbQBY/9nuaFgJHJJIQOIArjr+IBgCHtRO6dsWBbi5fqeSEO7tsf96MS5f7LRsCrQK2bBxaGMf7ml6Lct56CXxPIayfYzNI+mW0hNE+KsqZKf7ZG/HtiB6pMrEXVAFwdGQMMywBx3Evz4xfBcgLJa4V1lX2EoeaEKGcDMf+Rt/atKi+2w+q7TfwsLWVx0UWhUMzG6xSQ22Mg56ZpA9XgxlJW1YM/hQkG3kMSS1jGePf3Bsb6ZbokzbKrzUGhBY/xZqI9T/2GUCd/niZpaoyn/saFwUcK/+nvvJRvISP/WTBw7+B/f+qzyDXcxFzcxpYN/BB47oVGecR9bvlpkP88OvXnzH+h9wUfFvYRIA0S0X8t2uxBZ9m1BqWVVoAwh4OHigR/wvwv2iTLEt/j8Nl/AynfLkm9EuSA9rS3g6NRdkmUtjYk7sde41ORC9pFy8GFWHdK+z8bR1f4MfOT9RcbV3KATosGDJQNrhQ5sqlhywhPVCNmdl9rXiQCcCo62dwaWnrOtqFdpnOHxpDpHPG+2ihnbnTlMVGpBInEzAnkI6X9UkaaxjG09AoyX0sg0jFz2T1HtS0tRyNcU1nhtublrpFYWWgnKPvaJdgy1wzv1cCBjpWJs2OKnF4zQMZCDZsAeZBOcFpAtcFlf4qomP4S7N4TzCwEdVFq6g4amtQaNo4dfdqmUVVte3TYFIAKLCH466WssMRBPi31L
 ZYlv4iSE
 n8iOrik8LrC/NBeOP59FvIiaGszJm8U4H+YPTca9ZGv4mF85TRitbPDmHbGx7ovD4JYv5KuMbFxJLUbNGkTY6JxYAo9ABG37uT1sld/xZ67nP7gXv1epiAjvGBTCd23uBn6Td56TW6i986XDk3ZWh/FymIQE6xQGLnOADFPa85S4uyQA0c+VH/dBJ2V5ZxMKp7SiiIbFhx8d918Gp12Ccapo4c9ankHk6m8zHUaktvVdHeUJqwXqt+1rZQaBoEE4pjZ/vItPMZqLq5Gc3mp8616/FHVHzCmeKQ8Ho4aRaD60J5dYZ4HLgG3szS/b3bC2A4fhjy9Nb27vpgsmdU9I/JBLd3qDW7iuwBo5M1EScr+SCrebAQI5W5DpsMca8XON4W5g2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/14/26 16:13, Qiliang Yuan wrote:
> Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
> pressure as they cannot enter direct reclaim.
> 
> Handle these failures by introducing a watermark boost mechanism for
> atomic requests. Refactor boost_watermark() using an internal helper to
> support both fragmentation and atomic paths. Apply zone-proportional
> boosts (~0.1% of managed pages) for atomic allocations, while
> decoupling it from watermark_boost_factor.
> 
> Implement boost_zones_for_atomic() to iterate through and boost all
> eligible zones in the zonelist, respecting nodemasks. Use a per-zone
> 1-second debounce timer via last_boost_jiffies to prevent excessive
> boosting. Protect modifications with zone->lock and verify with
> lockdep. Integrate the mechanism into the page allocation slowpath
> specifically for order-0 GFP_ATOMIC requests.
> 
> This approach reuses existing infrastructure and ensures emergency
> reserves even if fragmentation boosting is disabled.
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

That was for an older version and the changes since were not trivial (and
about some I argued) so consider the Ack taken back now. (please do not send
v11 just to remove it)

Moreover I'm concerned that we went to v10 now, through many significant
changes, and while there are failure logs in the changelog, there's no
indication how the patch actually helps in practice (and whether there are
some negative consequences as well). How has that been evaluated? Also I
think we wanted to involve networking people in earlier versions but I don't
see them CC'd now?

> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> ---
> v10:
> - Refactor watermark boosting into mechanism (__boost_watermark) and policy logic.
> - Decouple Atomic boost from watermark_boost_factor to ensure emergency reserves.
> - Simplify Atomic boost calculation to ~0.1% of managed pages with a 10% high-WM cap.
> - Boost all eligible zones in the zonelist while respecting nodemasks.
> 
> v9:
> - Use mult_frac() for boost calculation.
> - Add !can_direct_reclaim check.
> - Code cleanup: naming, scope, and line limits.
> - Update tags: Add Vlastimil's Acked-by.
> - Link: https://lore.kernel.org/r/20260213-wujing-mm-page_alloc-v8-v9-1-cd99f3a6cb70@gmail.com
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
>  include/linux/mmzone.h |  1 +
>  mm/page_alloc.c        | 77 ++++++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 69 insertions(+), 9 deletions(-)
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
> index c380f063e8b7..9219bfca806b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2158,12 +2158,15 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
>  
>  #endif /* CONFIG_MEMORY_ISOLATION */
>  
> -static inline bool boost_watermark(struct zone *zone)
> +/*
> + * Helper for boosting watermarks. Called with zone->lock held.
> + * Use max_boost to limit the boost to a percentage of the high watermark.
> + */
> +static inline bool __boost_watermark(struct zone *zone, unsigned long amount,
> +				     unsigned long max_boost)
>  {
> -	unsigned long max_boost;
> +	lockdep_assert_held(&zone->lock);
>  
> -	if (!watermark_boost_factor)
> -		return false;
>  	/*
>  	 * Don't bother in zones that are unlikely to produce results.
>  	 * On small machines, including kdump capture kernels running
> @@ -2173,9 +2176,6 @@ static inline bool boost_watermark(struct zone *zone)
>  	if ((pageblock_nr_pages * 4) > zone_managed_pages(zone))
>  		return false;
>  
> -	max_boost = mult_frac(zone->_watermark[WMARK_HIGH],
> -			watermark_boost_factor, 10000);
> -
>  	/*
>  	 * high watermark may be uninitialised if fragmentation occurs
>  	 * very early in boot so do not boost. We do not fall
> @@ -2189,12 +2189,67 @@ static inline bool boost_watermark(struct zone *zone)
>  
>  	max_boost = max(pageblock_nr_pages, max_boost);
>  
> -	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
> -		max_boost);
> +	zone->watermark_boost = min(zone->watermark_boost + amount,
> +				    max_boost);
>  
>  	return true;
>  }
>  
> +/*
> + * Boost watermarks to increase reclaim pressure when fragmentation occurs
> + * and we fall back to other migratetypes.
> + */
> +static inline bool boost_watermark(struct zone *zone)
> +{
> +	if (!watermark_boost_factor)
> +		return false;
> +
> +	return __boost_watermark(zone, pageblock_nr_pages,
> +			mult_frac(zone->_watermark[WMARK_HIGH],
> +				  watermark_boost_factor, 10000));
> +}
> +
> +/*
> + * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
> + * This provides zone-proportional safety buffers: ~1MB per 1GB of zone
> + * size. Max boost ceiling is fixed at ~10% of high watermark.
> + *
> + * This emergency reserve is independent of watermark_boost_factor.
> + */
> +static inline bool boost_watermark_atomic(struct zone *zone)
> +{
> +	return __boost_watermark(zone,
> +			max(pageblock_nr_pages, zone_managed_pages(zone) / 1000),
> +			zone->_watermark[WMARK_HIGH] / 10);
> +}
> +
> +static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
> +{
> +	struct zoneref *z;
> +	struct zone *zone;
> +	unsigned long now = jiffies;
> +
> +	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
> +					ac->highest_zoneidx, ac->nodemask) {
> +		/* Rate-limit boosts to once per second per zone */
> +		if (time_after(now, zone->last_boost_jiffies + HZ)) {
> +			unsigned long flags;
> +			bool should_wake;
> +
> +			zone->last_boost_jiffies = now;
> +
> +			/* Modify watermark under lock, wake kswapd outside */
> +			spin_lock_irqsave(&zone->lock, flags);
> +			should_wake = boost_watermark_atomic(zone);
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +
> +			if (should_wake)
> +				wakeup_kswapd(zone, gfp_mask, 0,
> +					      ac->highest_zoneidx);
> +		}
> +	}
> +}
> +
>  /*
>   * When we are falling back to another migratetype during allocation, should we
>   * try to claim an entire block to satisfy further allocations, instead of
> @@ -4742,6 +4797,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (page)
>  		goto got_pg;
>  
> +	/* Boost watermarks for atomic requests entering slowpath */
> +	if (((gfp_mask & GFP_ATOMIC) == GFP_ATOMIC) && order == 0 && !can_direct_reclaim)
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


