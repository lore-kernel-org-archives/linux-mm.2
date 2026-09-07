Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF8D3C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A266B00A2; Mon,  7 Sep 2026 03:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31686B00A3; Mon,  7 Sep 2026 03:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46CF6B00A4; Mon,  7 Sep 2026 03:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B15B6B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:30:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FB8B4066C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:30:18 +0000 (UTC)
X-FDA: 85186142916.24.68A328F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DEA8180007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:30:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IWaarEKX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788766216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tpCXcNTxR15hZHrvxHbLtYdqjcKUmFt0AW82RaDF3k=;
	b=OTubB8dtnTOZ9PUh9RhNlxWkDMDBpqurkhn3R/4YlwWF4JsfH3YRPgE+NrHnnA7JUgffvw
	N1tEF3VNC1Gn5LpBJq5B1wlo6nf13RtRt5oNEU3Mf7u0r538KwgoF0Uz2S85MwCK16eEmb
	Ceujx1+HdKRuJy990XHTo5Ei+XvqUqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788766216;
	b=KnJJZnFHZG03vVl9lSbIemcIo6/QP/TLLi9uQJV8v81KqlGAHnZOQX4dftwneXP0m1phgJ
	uRtXjAR1ucf1sPp+Pi+no6pIQ6PIJbj9BHkk4Yxx6wPp0dNMqbR6j7y/6qOo1D4C1oK3o7
	yXS9K7upBg1Esl59Lz+/Tfqc+aTOEhA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IWaarEKX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C445D601F9;
	Mon,  7 Sep 2026 07:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62B91F00A3A;
	Mon,  7 Sep 2026 07:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788766215;
	bh=/tpCXcNTxR15hZHrvxHbLtYdqjcKUmFt0AW82RaDF3k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IWaarEKXnNsEq4AcRA76zzMw/cQHTWhq7UWcw9YuwNblXvg8j4PlTUHPN8PEWn2xC
	 1wFD/4Fd41C+wcqMHghpq/qHvHpCLTSDGJpVbmeXtLeHHIjjbRydk/Rb+WqMEBUz6i
	 33b2zxNXWaS6Ml36srWf+a+CPCMG23XL5PWAVA95mb48jzYymhdfKAy9jtZ1C0QEfH
	 OjGhjewr+IB7RWw49omorVydBu4d0SM8xpBc94OsjQM07kkjTP4d8GKqVx5fjG9rTX
	 4q8Gl7uv82jqI4CXOdKTfKzlZbMKdfRHZSuqHPd7Y8+jG0RAqqR5WKuHtzakBRX/Qs
	 oKMJLkHg8VwEg==
Message-ID: <be13228a-f35e-4868-9b56-6452c34abc60@kernel.org>
Date: Mon, 7 Sep 2026 09:30:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Salvatore Dipietro <dipiets@amazon.it>,
 linux-kernel@vger.kernel.org, hch@infradead.org
Cc: abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, dgc@kernel.org,
 dipietro.salvatore@gmail.com, djwong@kernel.org, hannes@cmpxchg.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, David Hildenbrand <david@redhat.com>,
 Christoph Hellwig <hch@lst.de>, Brendan Jackman <brendan.jackman@linux.dev>
References: <20260904115629.3993331-1-dipiets@amazon.it>
 <8cc503d9-04a1-4d90-874c-ada6c0ac5147@kernel.org>
 <DL6MKKOOL5DX.1R3Q77UTXBFYT@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DL6MKKOOL5DX.1R3Q77UTXBFYT@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DEA8180007
X-Stat-Signature: smkoiqmmrbhfswo6ncqbg76t3537ycsy
X-Rspam-User: 
X-HE-Tag: 1788766216-930448
X-HE-Meta: U2FsdGVkX1+fO/Q8PjbrduEy+ePk6jt+zCd5GwoanNxS01M60vdwY/ioagYAZzRZs70Da8v+o/qpgzwa4bnTFOvwlW9y9FoTC8XxYLNEyzG6eZC4p/89mt/NXsseRPUKXaQv33X5D+N3ge03kj09pLzyw3Ejz+/y6qcSqecmnN6p7MQIjJzs9zvF+jCxUiASLHoeFcN8m4JN4S709tkUiWiu9Zzj7ixbUHgsXlISm6FaMNLMUjwWBXHCH0RJLuYpA6OxmyWWfbeeSBN1Oshtg8P1GquL2M91BSk9Agr0rJl3Ufy12KvcOAZcWsDGyxkR6lX+JJ8rxU8NEbw9kE0W8LZRo5mFLQqaHkIJ7LiNAALFkKuAMZ0EiIKcLYVLLgSCdML5ewUYwim8ecu3kd/aH1TJJ130GVeIKFT8e/eCGpYiaJHRkGuXxbvH5Hj85zpjJ86d3VsS9PXisyuo4ZJblNSek5KOO5Puqohc5Zdc2aviWsGV5Aqn392DyyzJGSH8TfYsotQhGKhpGViV0Jej3lXpYvGgt2C9WiBBsBqgGtgs8ocIIbJQIJcgGsQ6GH8kHiUBpNTsd7CGnU2YBl0JM1itMUcH8Q2/y/8H119HK5H/lfzMzncyuZz5RP+ygOeydbTJGKMPCHJQAoGQbLIaNtrBdGbvBoILO67drAsQHXowT0wvmXWvGclFdWkrGoCtDSOGNAd0okzbd+GSkLCFGkjS8WSvMS/CpbfBTavMGDnbAxCmCcflXNFBCC3Rm5KFPrzCUze9+ZCGvCZGr1OD+Ot+yKwSZPbv4vPSuvd9F6HWoM8GJmNOauw/WyHCdzw2Dx1YNWvIXdUtuT8V7LpFPipM6EaydGHYCX6ZCWrMTGdiH1+IoPOuRmvfoCoMiOYYKImKl8htCbETguuIgO4+Qpli5mO7/SifrCYY4br1taDdDrfYCyDPmWR1STacsyE9FVJG9uvlIsm2o0MqWnR
 yXl5J2Ou
 sIFySYoScXhc5tuLv1PBIrD5XvLTbhdsryn/eAa5v7PClrOWcunvLQTOsZL4ycfmTdLAmuqOLoqDnvWhvY1AXy8izQzrAK2lECg+IkPaWTiU15CHV5degzibXHV40Ba7qR7bjT6t7DiiPuR+Ljx4HSQxQTBFndFZRWY66kTc+JvC9lq2jKEloG59hZhJQw5vylv2MBRTI2g1C7mrlw/jbYZ2Sqfq22UKwcZkkOOLeE7hPGWDU8rodIikbTW9wOTulsncgD/T4zN/Hjla6J0SgWENUAza6DdDIXAoVmIWPnDmttzd//UWR9Cby7t9u+umJAakMXsx7106pUfSMQFH/ZEYu1xqC5nVU65U+NoGAUaY3nL0E+Cw9qsAw55Gr8SPKDMSpfu5SO4vyV6+bpOpBHSaNaib6lYiKt+h8XXBlCS1XdX8AR2TA8kleN1aQvhZn+8R1KX+r/zn9PAPlClEx+KTlEsAqzmpWlJkjY5AyiLdpeJS6FgW8UD1c8KC50Sw+bUuvOkrmD6us5Uo29h6mIo6lwSRvl3zOisF9FWxe73OdruV+J/pUfvBuvN2TbfcRK/BXAoqhMc3lQhVrR+MhpwFH8idAbzvFWPOnsNjBr8j/KSm3U+G2jxZdmeUcXSlP5u67hVp+eUG/BwjkyVup50wAQbkUXgvaWYdAgrNyuDN8byxWZdhahX9kokijfRbA46J319588HARUzbUtFl11TXdTzZ8TbZXDYW0fO6QBUk4q9IVxA1U6l9IYin3s4FNxRIpt4Jl2B49GBs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 17:08, Zi Yan wrote:
> On Fri Sep 4, 2026 at 10:11 AM EDT, Vlastimil Babka (SUSE) wrote:
>> On 9/4/26 13:56, Salvatore Dipietro wrote:
>>> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>>> introduced high-order folio allocations in the iomap buffered write
>>> path.  When memory is fragmented, each failed costly-order allocation
>>> enters __alloc_pages_slowpath() which runs direct compaction and
>>> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
>>> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
>>> 
>>> The root issue is that direct compaction is too expensive for hot
>>> allocation paths that have fallbacks to smaller allocations.
>>> __filemap_get_folio_mpol() already marks higher-order allocations with
>>> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
>>> failure.  However, the page allocator still attempts full direct
>>> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
>>> aggressive when the caller will simply retry at a lower order.
>>> 
>>> For costly-order allocations with __GFP_NORETRY, clear
>>> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
>>> can_direct_reclaim, can_compact and the nofail checks are evaluated.
>>> This makes the entire slowpath treat the request as non-blocking: no
>>> direct reclaim, no direct compaction and no drain_all_pages() IPI
>>> across every CPU. kswapd (and in turn kcompactd) is still woken further
>>> down for background defragmentation, so compaction keeps working for
>>> long-term system health while being removed from the latency-critical
>>> direct allocation path.
>>> 
>>> Allocations that also request __GFP_THISNODE are exempted.  That flag
>>> pairing identifies the local-node-first THP attempt issued by
>>> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
>>> form transparent huge pages.
>>> 
>>> Test environment:
>>>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>>>              12x 1TB IO2 32000 IOPS RAID0 XFS
>>>   OS:        AL2023
>>>   Kernel:    v7.3-rc1
>>>   Database:  PostgreSQL 18.4
>>>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
>>> 
>>> Results (average of 3 runs, TPS):
>>> 
>>>   Config                   Avg TPS      % vs Baseline
>>>   baseline (no patch)       59,408       -
>>>   With this patch          155,409      +161.6%
>>> 
>>> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
>>> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
>>> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
>>> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
>>> Cc: stable@vger.kernel.org
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>> Cc: Matthew Wilcox <willy@infradead.org>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: Dave Chinner <dgc@kernel.org>
>>> Cc: Ritesh Harjani <ritesh.list@gmail.com>
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-fsdevel@vger.kernel.org
>>> Cc: linux-xfs@vger.kernel.org
>>> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
>>
>> I guess this will have to do until unlikely(we figure out a better API)...
> 
> We could add a "new_gfp = gfp_policy(gfp)" to adjust input gfp based on
> various policies we currently have.

Maybe with the help of alloc_flags to avoid the limitated count of gfp flags.

> Even better if callers can do that
> instead.

Not sure about burdening the callers (e.g. "every filesystem should do X"
etc), unless they are some intermediate wrappers within mm itself.
For example, THP (but only anonymous?) is now handled in such a special way,
it could be a candidate. But I also have a vague feeling this was already
done in the past. Worth investigating perhaps.

>>
>> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>
>>> ---
>>> v4: Clear __GFP_DIRECT_RECLAIM early in the slowpath and exempt
>>>     __GFP_THISNODE so THP attempt keeps using direct compaction
>>> v3: Move to mm/page_alloc.c, wake kcompactd instead of avoiding it
>>> v2: Move from fs/iomap/buffered-io.c to mm/filemap.c
>>> v1: Avoid compaction in iomap folio allocation
>>> 
>>>  mm/page_alloc.c | 18 +++++++++++++++---
>>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>> 
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 12fac9084c48..542c2ec31061 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -4784,10 +4784,10 @@ static inline struct page *
>>>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>>  						struct alloc_context *ac)
>>>  {
>>> -	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
>>> -	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
>>> -	bool nofail = gfp_mask & __GFP_NOFAIL;
>>>  	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
>>> +	bool can_direct_reclaim;
>>> +	bool can_compact;
>>> +	bool nofail;
>>>  	struct page *page = NULL;
>>>  	unsigned int alloc_flags;
>>>  	unsigned long did_some_progress;
>>> @@ -4802,6 +4802,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>>  	bool can_retry_reserves = true;
>>>  	unsigned long alloc_start_time = jiffies;
>>>  
>>> +	/*
>>> +	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
>>> +	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
>>> +	 */
> 
> Should this also be documented in gfp_types.h? It currently only says,
> 
> "__GFP_NORETRY: The VM implementation will try only very lightweight
> memory direct reclaim to get some memory under memory pressure (thus it
> can sleep)."
> 
> Otherwise,
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> 
>>> +	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
>>> +	    !(gfp_mask & __GFP_THISNODE))
>>> +		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
>>> +
>>> +	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
>>> +	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
>>> +	nofail = gfp_mask & __GFP_NOFAIL;
>>> +
>>>  	if (unlikely(nofail)) {
>>>  		/*
>>>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
> 
> 
> 
> 


