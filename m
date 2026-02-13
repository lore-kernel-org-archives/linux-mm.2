Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E1F2EF99D1
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 19:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A843A6B0005; Fri, 13 Feb 2026 14:36:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A654D6B0088; Fri, 13 Feb 2026 14:36:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964596B008A; Fri, 13 Feb 2026 14:36:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 840DA6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:36:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FFA31A065F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 19:36:28 +0000 (UTC)
X-FDA: 84440440056.26.3F777B3
Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com [209.85.222.195])
	by imf18.hostedemail.com (Postfix) with ESMTP id CA0AA1C000E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 19:36:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=F2sK7ybn;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.195 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771011386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llkjJOAUSGkOBuN7S3aJDNNVSVBODvl4G/+bNRBiTNs=;
	b=IhHybY53kIMGS/yGE52rmZF/15uTKRNPDFMsLQpIQlrfNFkUr+lugaIidvu+fBMENqkRNX
	HUVVxoDttLnLLiq8IPpC3Nu0OHj4e5f/OU6gNGiwEq2qiPinTaD91EkBCRK95408T8GWg5
	O1iwJjZHwfjEqkzGGmB0UnQNixV1lXM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=F2sK7ybn;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.195 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771011386; a=rsa-sha256;
	cv=none;
	b=w5tv3S5lMdrTwIrRcLS05S0TAXyhtNsQn3Yxi9pr0vRM3D7CQtSu4KVK76NwLnXuFbaVlb
	3fAUEzzpBOfP1LVmvAcRgzTaM7dAJofLnFwNxHcPGpExxp3xKUeAi8TQ8Xy5z3I3ULGWRf
	iF3q8KCRCv8o/eKom0JrnxQ/TBM4AtQ=
Received: by mail-qk1-f195.google.com with SMTP id af79cd13be357-8cb3bae8d3eso140779585a.1
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771011385; x=1771616185; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=llkjJOAUSGkOBuN7S3aJDNNVSVBODvl4G/+bNRBiTNs=;
        b=F2sK7ybnZ32kuWkj0Ce+hD4Jn1emjANu3WmMcyMZCXCI4XDZp04MCPdi3aDBPhJqSk
         I6JQC+/2vga4TpaL41H0Xjc2/SuoLozFcrM6j/qYO4qqE3Qd7GMOse8lJ0wbQEDeNvV2
         TB9kYTa1dLyqlPHTZAQ7xGjEFgX2LPQ8eK2BBV7uYg9e5fVpvwfgcpOVUgWgoqT/JGnf
         QqIoIk9HVjlj58HWbdCtCeuCfjCWRGi1z6WFmjGzyZrNyREFqpGPk60Gmh3ocX4Cf9cJ
         uhvx9fM+1XXPmjk1tRIufPDggRU0XdmleraydNLvyMvukHwSnmogF4x0VUxW/Nz9CWy4
         8ljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771011385; x=1771616185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=llkjJOAUSGkOBuN7S3aJDNNVSVBODvl4G/+bNRBiTNs=;
        b=CYGS/gEbsLgTKlm5hkBzggKIhbc2wGjVk+3hFpxqu3LI0fAaHHryOTblv05payAXLZ
         CYzjQIsj79c6GB7XdRNfPTnXx4LrJ2wgNnIfisKGq0k3FzYgdKm0LT0+MPvsiwkQDEX4
         40vX44d9goZaO4L85ZQvh8TLPmk6HMpp/4jGchKLUpJ8K4k1nem8dkaev0dsbWFNM8oA
         L4dveudexHpbyc73y4zwZQ9d7RvJZGVR07SUAmImBv9P7tREdMmn772k/HmTwkByfDdx
         zrsxtMGwCEJxeC7Q+WU0aQOgVE9N8CL+IjSLOy2N3qt1mFYLiS8s7c008S6BT/yL7KM7
         QaUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/spgOg3/F+xHmikiCrBeDVkvOJw7X90+dbV7Jw+M+/HLP9npWP85M2jyxASvdHu+Y/O3Abng1hA==@kvack.org
X-Gm-Message-State: AOJu0YyDmaKlLXe5keDSRM77sUreobdgXPLl4D15lMCr6rEo4znOv+0Y
	5sx1Fd/RQgDNd+S4MjrKXCMMwF2oFM4QUfDt58RZ3nV+HeLJ6dNX4AB+dwagIQ8JWMU=
X-Gm-Gg: AZuq6aLXJaNpFCdqwFtVSrUTZj1cZhmgpiRfIMnDlPtJ9daMgsfIrJUASNxfYBdMV8d
	zmCt7yte3LTm7pYCDRH6iIl5URIJzr4Y8SJXNq+J+RzDL9ONQvNQV1UEFIZnAnuoMwP6fFmL/An
	YiZuqyBS0b/CWMIV0iJmT1FemNieUy0Odpg74SIKAL4J4/ikk7B8BmprIDyV4RBFsPdSuHIbopj
	ko+Lz+nHwxZHyLAkW+l5NvdUNlubbEsHfde3o+LYJcBr3bKXLnI2cQrk/z+zc2Y7e4PTv8OcaiC
	MpJdG1wGLyTLnqtNcjw9yn8j8CMcSjLJk//SLEIY4ACzoc8hVMpzY1GxyVXBmaq+IqBqpFMFAUb
	FsNTzk7bJGz/yeY0FQVlC/GjolkqOtB8mTxeHtsUIQB81zq61C/npqbFDC/SDLJwt9wsGHK8RAQ
	4ZAO5GDjBMNM92D2AyYwpLVA==
X-Received: by 2002:a05:620a:4505:b0:8cb:2b04:85fa with SMTP id af79cd13be357-8cb4081f6c3mr456742285a.13.1771011384548;
        Fri, 13 Feb 2026 11:36:24 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b0f38afsm675777385a.22.2026.02.13.11.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 11:36:23 -0800 (PST)
Date: Fri, 13 Feb 2026 14:36:19 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9] mm/page_alloc: boost watermarks on atomic allocation
 failure
Message-ID: <aY99MytyXnECJuel@cmpxchg.org>
References: <20260213-wujing-mm-page_alloc-v8-v9-1-cd99f3a6cb70@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213-wujing-mm-page_alloc-v8-v9-1-cd99f3a6cb70@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CA0AA1C000E
X-Stat-Signature: 4ncir7b4zduy54s53bxm9f7uiua971fc
X-Rspam-User: 
X-HE-Tag: 1771011385-265239
X-HE-Meta: U2FsdGVkX196Pb9e5n/L98PgMylRq8ax0RR7NWybAtqDjKvOwq0WJxnAvfHp/xPw8MbGQ/kH5jceKAi750yM6vKGMXxnfjw5V1om0Vslqxxm8NM2et/7sVoXqOnfLsYHNBWLtMO9YcmdBDsYaXAzKPAtDd//tDOpCpNT6aK8eLiR6+OFinfuNTX3CxOA0N+lpe81PcuHorHHurBqPD53vaCeF6/TMFBy+DbOsf4ApH0GvAAQSMKlGb71X0pnOXCtcCmA7SMn6vz0skR//2Q/5Q+b2KedL/2y0Fz8zv3rroCFpcI5GptMzohX31g06ha14aq0WOxtxkiP05kljX45s7nBWq975cXV19y0AlL1u39W3uDDAxI+gbS0JpB7qQ4M67uHPjrIcJkv1974J0NNtUwGmJT3hFzwfeJ+6Ywy4SGpATaKjuOgRjDDImBbCwhtFfv/PbxNtXnqkymwxvUWrl0AMtM+6CZWtg+csr+FL+tgY21cUWufia36n4xXKOfDrLThgRCedWK59Qg6Sr17u6a0W9wIYTQ24txqYOD2HlfeMGL+N24NwgWRhS3SlnnWoEsF7nDMRhhfxFCYlYRyuzzRzXTnz8Zac8L2/o4FLJxbviw7TpUQIcby0TeJo6g2sDVNJCh6spJn+lUe6/85qShrQf/2v99g0I6YRpThzVCzlyV4/e3FNNhIlUJj5Fhksd58SaAERzFXFcMkiIWmyD1JG5vQfOazxkK6Ii8ddsiDmdu+/6zoXsgdwY0eSZvWkRQAvRtlPFV8pQGaRJdcXPjyJ2pbZ8jE1hVtpVH5oidQGQrrddLjFjfsakLOByMJlNh+l4gggANG+eHnk1klhM9FiYMSmpDzMxo2Zt6ukGeDBOkh/fDc0RR62wbxnJm0k4PL6agMSjX3Tui7dLBBJhkoj1TxEe7P4UXOXdIf0/HuwkBF1J++USHTROFAorXEDtt9oFkSR67JPDdX+zE
 Ro2xpIhX
 uJMsLYoWMsk+qmd44vYV13TT0f44fGoP7yCUQGnzyGPLZ8B6ZzdqsIzwRYRhoWDOiXjVO7cSzHetgWpGl1FD0DQ4hVpgGjvQI6aRJwxLyFTvQ9I/Z0ox8gwEWioudmIBdEW/a14Xf9cWxV/iqQJ0ZyJjBs6K+kNxbxEY51MHIcx+Ljl6CdXXKER6sokvH6qlGKqQgJlLlJZcGxt8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 11:17:59AM +0800, Qiliang Yuan wrote:
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

watermark_boost_factor is for fragmentation management. It's valid to
have this set to 0 and still want boosting for atomic.

> @@ -2189,12 +2199,43 @@ static inline bool boost_watermark(struct zone *zone)
>  
>  	max_boost = max(pageblock_nr_pages, max_boost);
>  
> -	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
> -		max_boost);
> +	boost_amount = max(pageblock_nr_pages,
> +			   mult_frac(zone_managed_pages(zone), ATOMIC_BOOST_FACTOR, 1000));
> +	zone->watermark_boost = min(zone->watermark_boost + boost_amount,
> +				    max_boost);

Likewise, you don't want to add the atomic boost every time there is a
fragmentation event. You need to separate these paths.

The mult_frac() with constants seems a bit funny to me. Just do
zone_managed_pages(zone) / 1000, drop the define, and move the comment
and move the comment here.

> +static void boost_zone_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
> +{
> +	struct zoneref *z;
> +	struct zone *zone;
> +	unsigned long now = jiffies;
> +
> +	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {

for_each_zone_zonelist_nodemask() with ac->nodemask?

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

This is a bit strange to me. By the time you boost, all eligible zones
have been tried, and ALL their reserves were found to be inadequate
for the incoming atomic requests. They all *should* be boosted.

By doing them one by one, you risk additional failures even though you
already KNOW at this point that these other zones are problematic too.

So IMO, by the time you reach here, they should all be boosted.

> @@ -4742,6 +4783,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (page)
>  		goto got_pg;
>  
> +	/* Boost watermarks for atomic requests entering slowpath */
> +	if ((gfp_mask & GFP_ATOMIC) && order == 0 && !can_direct_reclaim)

This is a bit weird. GFP_ATOMIC is a mask, so this check will trigger
on anything that has __GFP_KSWAPD_RECLAIM set (which is most things),
so in turn you then have to filter out direct reclaim again (which the
real GFP_ATOMIC implies).

	if (gfp_has_flags(gfp_mask, GFP_ATOMIC))

> +		boost_zone_for_atomic(ac, gfp_mask);
> +

