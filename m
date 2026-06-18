Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E2CCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 18:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B616B0088; Thu, 18 Jun 2026 14:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E252D6B008A; Thu, 18 Jun 2026 14:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E666B008C; Thu, 18 Jun 2026 14:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0E16B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:35:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F60F120244
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:35:33 +0000 (UTC)
X-FDA: 84893886546.16.F8150AC
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id EBF4F40009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:35:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=TMKFQqlL;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781807731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbQc+XBYiLsPD08oE5SvttVMwckAlDDcKCSnF5heN+s=;
	b=yxRlh5wl7fN4nhKPeRANtVxxZaiPOTU9gJaanOUhoW2htbG87b9s3yeV7CvcEXXSEYMFv+
	5z7zl4FT2WhJME7CIwbVZpfkr5L9YRmNPh/m7vnnqqaLiJUlCP4TtvHpq43pBte0yVHpKc
	gB/067UVbk2wkQWBMVf/hqMppY5hIKE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781807731;
	b=ySqLe11Ghe/ffsZnnOwLixECp9jt3Zer5f+fgIlqPP4NwdegWerwCP7tf+hUMyv2tVeHDY
	YimZjb3ynbUpo+ytx16Jxd5+Qm9XCejPMYMD8ohrkTM3qKygskJJqaGTjzsMIJgob1+aP2
	X38Rj5srmvVz8+P7SRWwYBza87JzZfk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=TMKFQqlL;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9204711e831so29927885a.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1781807730; x=1782412530; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jbQc+XBYiLsPD08oE5SvttVMwckAlDDcKCSnF5heN+s=;
        b=TMKFQqlLDhfaotiQRHVmGm2edEUtDOIepxUJD/ZRrORQAm4lPqcGVWixSLnTkoMeRk
         OzO1kg6qPsaWUnl1INuAKvVqQWQfP1/LrS8i7X2g4qwgvDuWfyyrvQDX/Rco9Nu3cDrk
         X5VQN2AE5XmSRETmdTT/5gl78nvA+Sh9r+mSEO8aHFtiyUf7yKUeG0KVpOy2Z5YSPUOW
         We0ZaT1j926zBR5JrqsW8ZwWu9WPC4R8/MhVVVtefL4yfDhbW2E2hCdDA2tE6/ofvzXj
         4iWtxnFA73ns+PNmbYnK5AgYHt8e1aczC1Mk3Pxz18bd6ob4w+GnFC/7Sfy21Fo2fAZl
         BJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781807730; x=1782412530;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jbQc+XBYiLsPD08oE5SvttVMwckAlDDcKCSnF5heN+s=;
        b=Bey/Mnjg8X8/FWS/QZBXwvvUu0hy68jmHQSWpo9P6u8k+q/EXYlMPbWy5J/ev9vdVn
         wNHzIzkGj5n+Xl92spr1fgoGlO5M701ymfxG/iIRC5scCCxGdA4z4RjVFiUxA+DUf6KE
         oQiixcOnRuNs5EFTfJ17PbdwFyy0pzXsBarkGpMVROjBt9r5y1I8d/krkd9MwtujW+QU
         VJJ+5Z/92aB614Ckn2E1yhCoJNHL+pwDwMUBdU/3cIaHsZLhhHZ52QXxl9ep3hRYjgij
         5eqLWLVnR8520moYFyaTSE97+KkgzS6s9sI0c/0FNkkPNTR4GMv3PJijAgwrxigeeEa5
         iR/w==
X-Forwarded-Encrypted: i=1; AFNElJ8opfAyXb0FJbliuYqi0qoxzERLnYiJDyjhhseRAVVwBOd3vxrHd9Z6NO6t25+aQ8Z/mTRxiIjHzg==@kvack.org
X-Gm-Message-State: AOJu0Yw04GWcQmhokcupy/aahFRvpE1hCBsvQI1olpU/GHtD383nHa8B
	hHk47v431QsqbCYgL7HewxEs5GHSC3vwen/CZ6ZCKT0/1TU7f0Ds1sKsRahVXPtgZN4=
X-Gm-Gg: AfdE7cmEry2jzhyKWJNXrWTOun5NU0sWoEKNavdAKuZwv6C25yVlFtDClu4L4cY4ip7
	dxxBPRgmvEXW/vSRyVDYQkBmYSI0JLrkE+WdIGF0O/ixfZUZyLzJ3MVMXAt18xzeJcP7j44bqEz
	NFpTA+30aQrHxYvtiSMhRXNidSRv0XnkBpUWbDwbeLGB40bObi0a1uz2YY2mwgkSl0nlBbEiwmL
	SNICy5+qm4VIRj1GxJGVQ5gxx6a8RsI/qomc/Yu5ek9gqHdzPvay6IFJq6V1266fuAeqHD/y1vO
	WGzmuZxnQDBROOMUgH57ui8g/CVZLYXxiH/OWfalh9jP4S5w9m4eWPp6JtmmDU3UTM4NGfga2Ox
	IJYxrQq0UMtYCddwA3Xamb/izHCJfAT8qDJZ8jWB9GkiplF+skSysvvzZKDnNZsagLAyVFKLtcH
	MUHDcmcINnbnI=
X-Received: by 2002:a05:620a:27d5:b0:915:aa7d:4295 with SMTP id af79cd13be357-9208f161133mr27116385a.12.1781807729640;
        Thu, 18 Jun 2026 11:35:29 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d9f22974f5sm102436976d6.22.2026.06.18.11.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 11:35:28 -0700 (PDT)
Date: Thu, 18 Jun 2026 14:35:25 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	ziy@nvidia.com, fvdl@google.com, linux-mm@kvack.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: use existing highatomic reserves on
 the buddy fastpath
Message-ID: <ajQ6bY8R1sOy9X52@cmpxchg.org>
References: <20260617234958.150339-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617234958.150339-1-jp.kobryn@linux.dev>
X-Rspamd-Queue-Id: EBF4F40009
X-Stat-Signature: mosyui3g99oy1psdhr15n3zz6p58zwez
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781807730-198033
X-HE-Meta: U2FsdGVkX19ngzHxHfKXo27zKvIq0Y7TWRctpWtQ3IZd+/jZzVd1Jbm/zMjGxsF5cVJQ1sm2Hb2i98jt2QPP4N4AfVADBzGbHEcKsxORgyalbpP8pCKBc2glDBWDCMaQnECnJCanOeWAybuJim4U1nyLtoVXX/wbqOgcsUprC0DASsmaRKZCttPRO1X5ZbP8CmvhdjyNNC9bWxhS0HD+Wbj6qcoUWU+j4cWhZz0e5j0SAf9GXdOSuHlvie0jsg5NC2Z9m6BvGHofklfrC6p2JRnLdLkyEcT48CYYFpCecS58IkTuToWMggCDif3Sof35PVXCPd4dumjUzl49viX5TNOHNLIPuT6vaJlc9ur2ST+Y9xN6wPshgoTWLGHytfCqu1lcfNYSJDAtAnhE3ChvN3mk007zF7pL0m3Fc4lNROcdtrYhD9LUXdhzTyKRznQAzMLdJLM+JeFIjKhxc18nGabHkUaGncrr2VNUBAgyyDL/C2rfIvztRV6wyHX16j4XiIKhbpkDqcXZYQt5rYkyUWbI1wf0RNFYV2XrT2mFRxLraaHS9J/yQRvBWOF1fmSo+zUYCV3KehwLNxhPlomiFbus1Iej3u/tXaHkJ/2XT0R9/RQObRmfzcEynQp9P+HTQX2YDi4vzeOUikblSdPi77QVMtOvzaQtf5b8nFpccmW7ePntalz1qNJ4cS2lWoWdPZ/N4fwLr0IcJEf42081wsKUkguElUJG7xKo21mrDCfdV55IFlFPbPdrZM4EYVfYqlGHpwuF+U8Il5vfd7O3fodHzi4XRhcrIOfoZplqN70jhEH/RTdVs31QkgQoV1uRouBXcre5asktkqhyFExuLFQcVZ18/NPg70Tp15Ri4PueSX7Ayhs6XF74e6juYgdPYD6SQqS/q//aEqQrDMmXogEg9UGFYpWVCrDmdC5MVN5XYrAQwqEhvRCmyCey7weFq1cNdct4VdOpZQY6qR3
 jV62jWHo
 yhK8H481uzdpvn37jxN879W/H4H/lg5Ofyvbw7DAKV7EU8W5HOS/oGPRBpsavPiGk7PduSSmqqLsV8vn1WF/MvK+11u3oPsFQAveorQ+TMLU/PdXvQ+tdfwTt5BHP0XcKetO7nduY+ibN9dYht2N7Am4+cdRcdOxNscY0+djVe5hgtCIxGzwTnVRlDGPCFb3FMWMEbPwPTj0fCfgl+kNAtos6kLGobqjdwYMKYXAq7GhVOIr4zys99Tx333UH+RL9/egyVeAh1Ho81w8ugTdhNm+YppjiJJX0VWMHfk/B0SWPOauxwkF2XP2eQtWrUEB/wL4AI1oUHZlCagRrSEOhphl2+JFE0kCLfB2hS5XehYSIK9RoB/7DLe5/EahI0Ww6X9DiMXAqJ8gJp8lQDJtfBBJtV38eG2tmPOOhDc5dE2FHon4D3lxsxaaRfbTI3dxhkR2U4B3nmCev9xyyhCPT5azQCzY0UcuglOh5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 04:49:58PM -0700, JP Kobryn wrote:
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
> fastpath. Change the semantics of ALLOC_HIGHATOMIC so that it only allows
> access to the reserves without permission to grow them. Add a new flag
> ALLOC_HIGHATOMIC_RESERVE that specifically allows growing the reserves.
> 
> A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
> available in the target zone. Before this patch, the workload did not
> consume these blocks. With this patch, eligible order-1 allocations
> reaching the buddy path consumed existing MIGRATE_HIGHATOMIC pageblocks,
> with no highatomic misses observed. The workload did not grow highatomic
> reserves and NAPI page-frag allocations remained healthy with no failures
> or order-0 fallbacks.

Thanks for digging deeper into this! That's a great find.

> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> v2:
>   - decouple use semantics from ALLOC_HIGHATOMIC_RESERVE
>   - update changelog to reflect above change and reword test paragraph
>   - adjust comment in PCP path
>   - rebase onto Linus' tree ~v7.2-rc1
> 
> v1: https://lore.kernel.org/linux-mm/20260616191420.52556-1-jp.kobryn@linux.dev/
> 
>  mm/internal.h   |  1 +
>  mm/page_alloc.c | 30 +++++++++++++++++++++++++-----
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 5a2ddcf68e0b..6700659615e8 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1478,6 +1478,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
>  #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
>  #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
>  #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
> +#define ALLOC_HIGHATOMIC_RESERVE	0x1000 /* Allows growing MIGRATE_HIGHATOMIC reserves */
>  
>  /* Flags that allow allocations below the min watermark. */
>  #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d49c254174da..ed919e2ac99a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3238,7 +3238,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  	 * If this is a high-order atomic allocation then check
>  	 * if the pageblock should be reserved for the future
>  	 */
> -	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
> +	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC_RESERVE))
>  		reserve_highatomic_pageblock(page, order, zone);

You could check ALLOC_WMARK_MIN to determine the slowpath. This way
you wouldn't need another alloc flag:

	/* Slowpath (precarious) high-atomic allocation. Maybe reserve block */
	if (unlikely((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_WMARK_MIN)) == (ALLOC_HIGHATOMIC|ALLOC_WMARK_MIN)))
		reserve_highatomic_pageblock(page, order, zone);

[ we really ought to generalize gfp_has_flags() ... ]

>  	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
> @@ -3320,8 +3320,9 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
>  			 *
>  			 * Instead, direct it towards the reserves by
>  			 * returning NULL, which will make the caller fall
> -			 * back to rmqueue_buddy. This will try to use the
> -			 * reserves first and grow them if needed.
> +			 * back to rmqueue_buddy. There it will try to use
> +			 * the reserves first and grow them if needed and
> +			 * permitted by the ALLOC_HIGHATOMIC_RESERVE flag.
>  			 */
>  			if (alloc_flags & ALLOC_HIGHATOMIC)
>  				return NULL;
> @@ -3768,6 +3769,24 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
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

There seems to be a mismatch between this and gfp_to_alloc_flags()
(slowpath), where slowpath is still allowed to tap highatomic reserves
for costly orders. Is that on purpose?

> +	if (!(gfp_mask & __GFP_HIGH))
> +		return 0;
> +	if (gfp_mask & (__GFP_DIRECT_RECLAIM | __GFP_NOMEMALLOC))
> +		return 0;

This duplicates gfp_to_alloc_flags() logic which seems fragile. How
about the below:

> +
> +	return ALLOC_HIGHATOMIC;
> +}
> +
>  /* Must be called after current_gfp_context() which can change gfp_mask */
>  static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
>  						  unsigned int alloc_flags)
> @@ -4495,7 +4514,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>  			alloc_flags |= ALLOC_NON_BLOCK;
>  
>  			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
> -				alloc_flags |= ALLOC_HIGHATOMIC;
> +				alloc_flags |= (ALLOC_HIGHATOMIC | ALLOC_HIGHATOMIC_RESERVE);
>  		}
>  
>  		/*
> @@ -5215,7 +5234,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>  	 * Forbid the first pass from falling back to types that fragment
>  	 * memory until all local zones are considered.
>  	 */
> -	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
> +	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp) |
> +			alloc_flags_highatomic_fastpath(alloc_gfp, order);

	alloc_flags |= gfp_to_alloc_flags(gfp, order) & ALLOC_HIGHATOMIC;

Or factor gfp_to_alloc_flags_nonblocking() from gfp_to_alloc_flags()
and reuse that here, to save a few cycles in the fast path.

>  	/* First allocation attempt */
>  	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
> -- 
> 2.54.0

