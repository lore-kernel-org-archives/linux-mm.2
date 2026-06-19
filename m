Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57AA9CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 21:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6ABD6B0088; Fri, 19 Jun 2026 17:45:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C3D6B008A; Fri, 19 Jun 2026 17:45:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A906B008C; Fri, 19 Jun 2026 17:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BBB76B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:45:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B5ADC2856
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 21:45:43 +0000 (UTC)
X-FDA: 84897994566.26.381F1A1
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id B959CA0007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 21:45:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=igLvyTBD;
	spf=pass (imf25.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781905541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9wsoGdtM/rriUfhfqHHYROa08PvJ2l1e+wS2rgW6qM=;
	b=NUnyek05aLe79KwrQW43VX9k7vfPrHKZYcQT4phOiZt+yWwpuDbuO7NkMeeZnx4PyMu5jW
	hXu78dOwkdnHBUdc58lr7krx1C75ki0iI4RVBBoQWSjL6OP9Ok2E5mCsTbatee3Uz3dQYy
	3s0GSVLLKh6vAEJmIvo+Lihh4NQWn+g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=igLvyTBD;
	spf=pass (imf25.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781905541;
	b=f/Ko5D47sXkC7vN/dkBYuoqsi+Trob7neDQWp8OKOlZ5HbewH1jIxyYIL5FZGvwNamoIgq
	TOylRsvfnDQPX7+Vk0II7V/QCpyHdWcpnh8E0ni6+GLIzKzchmbNDS5A04+DsQ9uSvlOGw
	2JZUO0E75CdO/20Z/xdwxiojBPlFMyk=
Message-ID: <e4dce2d7-5808-4e48-b15b-9cd41f033b40@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781905538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N9wsoGdtM/rriUfhfqHHYROa08PvJ2l1e+wS2rgW6qM=;
	b=igLvyTBDrMp86NHF/c7BIFmuVtnvKzYVpbxXmSc62NzN28l54/GemZL/8CjN+NYbAh4K7b
	oRbv/NKYUMlP338abfXMx87YY2Q3j44D9DwUq307Kb8yU5rW8oyLbjyAs8GzXjwxLVFa32
	UNxsN78Pqxpv9kSfwe1eYT1Rf1Ppt8E=
Date: Fri, 19 Jun 2026 14:45:31 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/page_alloc: use existing highatomic reserves on the
 buddy fastpath
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, fvdl@google.com,
 linux-mm@kvack.org, shakeel.butt@linux.dev, usama.arif@linux.dev,
 linux-kernel@vger.kernel.org
References: <20260617234958.150339-1-jp.kobryn@linux.dev>
 <ajQ6bY8R1sOy9X52@cmpxchg.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <ajQ6bY8R1sOy9X52@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B959CA0007
X-Stat-Signature: 9bw6f8ezm5wy9r9i3w5wborzxw9xbpho
X-HE-Tag: 1781905540-885797
X-HE-Meta: U2FsdGVkX190ebuM/4AN7QfS/cQLRSd1LF1oixUyiFoIfhv3f+Q7ZZ5M3oLhIK8u4Q8hgIXdckHNcbuk3LYjZ9wf90UyULjVjwjR6P/WiISS/vJZaWoxQTI4nUlHo8Ta2rTNVdLH6CC+My5FEJ6BYgcgMgqBTdpVYNCxnsANTDOjzmXAe7UwknXQeWSR6UrQV9tqNN7rUcnZDN01qHGbPHqzmQx6dJyO8UpoXeyQJFl0JK7JTX0isuIXj1qPvQg7A5Y8EuRajL+u6gOeKuUFyxjTDHqenUYjdbkabMdP00PjPVO4ToLjSsbVah3i0BmYLG9Tfl3dRJ2kjvDG3g+iS1s1P9X+ZBQEV3gcAlIxlj+P+zQ5oXB0etARVUbiu3MrlKZD975pCyXTFoJlrdtXWJ9pvKufV5Ntd0E+6tHtpLpR8vQLpR0Ok+FzACDfG8pO/xatx14nnR3XuVToZcTAKTp9xXnFzE53Rjv0zUUq6jStiULSMMDm0eRwpKu26GgIKp2fEWW/SQSCD8K475LFw+zcpzj1rKu3Mh17dLGGItxZQcuvS9ZY4doKNnN9+77zjjWtBQzpKC8xaEOwyGg4F7M09IVtK7+VuzYvQX1UZVvyAVt9W3blLotdl/MejE/wnJpH+HK0YoZ1zdS6uyu8CtuF3yuQiJeeT6DAB1183PpxN6ivqKnna4bv3wP7AVMy5DxofkiF63jrJbCIKS0QR7laSzgqfdIQtCu4teUDptoZcmKEzvp0DvyH5Dp2u63mwrm59X88Jz3LSTSBZOzsdIG0RUamwGUQvDMvrtFT4kvJizuyRIEOh68GSRI3SZaFlOl+ZWbrlvqV/oiMXytIKp/z7r7aLumci0UJIsJg7TsPum4Gvi2WMQETn977VAqeUwjkJeduyYygcWJh2fmwKZcWfn0U+RfTmJn1+98KqHc+vG/rbJdWMWgIOB2IpqJDPCHuuy49IiOr+qpaEe3
 fW6Q3q86
 PJuuHjzhYkUTDUiis8sPlgHlwPUQLEugHRUKIc3AnKKhX2RhBb+ch/XUXQeUTQ0wbwc1me1EFzB+yI9Jp1su22zZaCPquMftGNeIGIMkHFt2b+iesAfcVn6BJAk5Z/cSMhLkVlb1qjSCVyWxXs2EPq01ekR+wF1zd0fV4mRyZosEtFH8I2UzCVCND1Rs+ZGknPwllZO1zXmJSUbzmQC2LeMnw/ggVnylFAkkEiff0MHi+ZHZKd5/lNp1SYW4/eq3pIYfFnZXiGU3nYZbMbpu/PIEXZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 11:35 AM, Johannes Weiner wrote:
> On Wed, Jun 17, 2026 at 04:49:58PM -0700, JP Kobryn wrote:
>> ALLOC_HIGHATOMIC currently provides both access to MIGRATE_HIGHATOMIC free
>> pages and permission to create new highatomic pageblock reserves. This
>> makes it unsuitable for the fastpath.
>>
>> However, the fastpath can reach rmqueue_buddy() while MIGRATE_HIGHATOMIC
>> reserves have free pages available. In this situation, the allocation can
>> fall back to other migratetypes without trying those reserves first.
>>
>> Allow high-priority non-blocking allocations above order-0 and up to the
>> costly order to use existing MIGRATE_HIGHATOMIC reserves on the buddy
>> fastpath. Change the semantics of ALLOC_HIGHATOMIC so that it only allows
>> access to the reserves without permission to grow them. Add a new flag
>> ALLOC_HIGHATOMIC_RESERVE that specifically allows growing the reserves.
>>
>> A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
>> available in the target zone. Before this patch, the workload did not
>> consume these blocks. With this patch, eligible order-1 allocations
>> reaching the buddy path consumed existing MIGRATE_HIGHATOMIC pageblocks,
>> with no highatomic misses observed. The workload did not grow highatomic
>> reserves and NAPI page-frag allocations remained healthy with no failures
>> or order-0 fallbacks.
> 
> Thanks for digging deeper into this! That's a great find.

Thanks :)

> 
>> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>> v2:
>>   - decouple use semantics from ALLOC_HIGHATOMIC_RESERVE
>>   - update changelog to reflect above change and reword test paragraph
>>   - adjust comment in PCP path
>>   - rebase onto Linus' tree ~v7.2-rc1
>>
>> v1: https://lore.kernel.org/linux-mm/20260616191420.52556-1-jp.kobryn@linux.dev/
>>
>>  mm/internal.h   |  1 +
>>  mm/page_alloc.c | 30 +++++++++++++++++++++++++-----
>>  2 files changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 5a2ddcf68e0b..6700659615e8 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1478,6 +1478,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
>>  #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
>>  #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
>>  #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
>> +#define ALLOC_HIGHATOMIC_RESERVE	0x1000 /* Allows growing MIGRATE_HIGHATOMIC reserves */
>>  
>>  /* Flags that allow allocations below the min watermark. */
>>  #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index d49c254174da..ed919e2ac99a 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -3238,7 +3238,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>>  	 * If this is a high-order atomic allocation then check
>>  	 * if the pageblock should be reserved for the future
>>  	 */
>> -	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
>> +	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC_RESERVE))
>>  		reserve_highatomic_pageblock(page, order, zone);
> 
> You could check ALLOC_WMARK_MIN to determine the slowpath. This way
> you wouldn't need another alloc flag:
> 
> 	/* Slowpath (precarious) high-atomic allocation. Maybe reserve block */
> 	if (unlikely((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_WMARK_MIN)) == (ALLOC_HIGHATOMIC|ALLOC_WMARK_MIN)))
> 		reserve_highatomic_pageblock(page, order, zone);

Hmm so we just use watermark low vs min to determine fast/slow path. We
would need to mask out the watermark bits since ALLOC_WMARK_MIN is zero,
but I think the idea can work.

> 
> [ we really ought to generalize gfp_has_flags() ... ]
> 
>>  	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
>> @@ -3320,8 +3320,9 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
>>  			 *
>>  			 * Instead, direct it towards the reserves by
>>  			 * returning NULL, which will make the caller fall
>> -			 * back to rmqueue_buddy. This will try to use the
>> -			 * reserves first and grow them if needed.
>> +			 * back to rmqueue_buddy. There it will try to use
>> +			 * the reserves first and grow them if needed and
>> +			 * permitted by the ALLOC_HIGHATOMIC_RESERVE flag.
>>  			 */
>>  			if (alloc_flags & ALLOC_HIGHATOMIC)
>>  				return NULL;
>> @@ -3768,6 +3769,24 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
>>  	return alloc_flags;
>>  }
>>  
>> +/*
>> + * Let high-priority non-blocking allocations above order-0 and up
>> + * to the costly order try to use existing MIGRATE_HIGHATOMIC
>> + * reserves on the fastpath.
>> + */
>> +static inline unsigned int
>> +alloc_flags_highatomic_fastpath(gfp_t gfp_mask, unsigned int order)
>> +{
>> +	if (!order || order > PAGE_ALLOC_COSTLY_ORDER)
>> +		return 0;
> 
> There seems to be a mismatch between this and gfp_to_alloc_flags()
> (slowpath), where slowpath is still allowed to tap highatomic reserves
> for costly orders. Is that on purpose?

Yes, the intention was to improve allocator outcomes for frequent net
allocations. So I kept the policy narrow. But I thought about this some
more and agree it's worth removing the order cap. With the cap, if a
costly+ order atomic allocation reaches the buddy path there may be two
non-ideal outcomes: fallback to some other migratetype in the fastpath
or enter the slowpath and make use of any available reserves. In the
latter case, the slowpath could have been avoided altogether. So I'll
make this change in v3.

> 
>> +	if (!(gfp_mask & __GFP_HIGH))
>> +		return 0;
>> +	if (gfp_mask & (__GFP_DIRECT_RECLAIM | __GFP_NOMEMALLOC))
>> +		return 0;
> 
> This duplicates gfp_to_alloc_flags() logic which seems fragile. How
> about the below:
> 
>> +
>> +	return ALLOC_HIGHATOMIC;
>> +}
>> +
>>  /* Must be called after current_gfp_context() which can change gfp_mask */
>>  static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
>>  						  unsigned int alloc_flags)
>> @@ -4495,7 +4514,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>>  			alloc_flags |= ALLOC_NON_BLOCK;
>>  
>>  			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
>> -				alloc_flags |= ALLOC_HIGHATOMIC;
>> +				alloc_flags |= (ALLOC_HIGHATOMIC | ALLOC_HIGHATOMIC_RESERVE);
>>  		}
>>  
>>  		/*
>> @@ -5215,7 +5234,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
>>  	 * Forbid the first pass from falling back to types that fragment
>>  	 * memory until all local zones are considered.
>>  	 */
>> -	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
>> +	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp) |
>> +			alloc_flags_highatomic_fastpath(alloc_gfp, order);
> 
> 	alloc_flags |= gfp_to_alloc_flags(gfp, order) & ALLOC_HIGHATOMIC;
> 
> Or factor gfp_to_alloc_flags_nonblocking() from gfp_to_alloc_flags()
> and reuse that here, to save a few cycles in the fast path.

This should be possible now that I'll be removing the order cap.

> 
>>  	/* First allocation attempt */
>>  	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
>> -- 
>> 2.54.0


