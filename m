Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFCB0CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 09:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5187B6B0088; Mon, 25 May 2026 05:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0E06B008C; Mon, 25 May 2026 05:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42CB76B0096; Mon, 25 May 2026 05:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31CC76B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:11:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C177A401E8
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:11:16 +0000 (UTC)
X-FDA: 84805373352.24.F03AE6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1FF914000E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:11:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A21LqXUs;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779700275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/3YwuR3pOuMJcREwqo1Stxq68Iks4DEidfzj/cnmA8=;
	b=CPMG4QN2Ee6DrETC831/0G/3wadWfqnIYsiWjavJ+qBIOydsMEOmCZpLgorhwVT6sIKhP4
	hWX396roTFAwul/AMgXLqBXH+x7gqls50L6lWwdWhNAbLJUGOIyNZwz+orSh3PBDp+ZxaT
	57UHSCCDhYDlwA1+g+AEWJOG6qWnc4c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A21LqXUs;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779700275; a=rsa-sha256;
	cv=none;
	b=ex0PdLj0RNMNrJ/3FRL+xn/t6rGkT+qvI+35v1IMQpRH1qREUpvAj9Bb4OkduTyaOrCPdy
	m/BkhAM7oLyJujm+1+SbI/fKmDruqd4/31iuSU+6mYms/b0k4ts0oFSoBAuUArluTOuBh1
	k9rr7oSNfFTJlYSAYdu6pPV8Sozx/Xs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84AD7600BB;
	Mon, 25 May 2026 09:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CF41F000E9;
	Mon, 25 May 2026 09:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779700274;
	bh=6/3YwuR3pOuMJcREwqo1Stxq68Iks4DEidfzj/cnmA8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A21LqXUsHs9WkANqSp30wt7TgFZJcNduejcxaYdnhFfU+b9SVhlTrU/pyVKqAEVl4
	 TmxIvojGO97H72XFqvUdVsHhsDSlPU0sBTjxGWAjpGysU7HD1SvKIV3MBn2gZD96DH
	 U8w3WmXbZsmmu1FZ3wEpLq0VzLx41X2380+nq4sMvhaMr7i7VOL5JUcKmSPLMNHR1s
	 rxmZOi9MKKnxbwe/U2pxOi15Ar1FHljSybjxQ90G1EHrbC5bHXIXz2VrdR1xGtd5oM
	 vFu9bqMaCeMilEdvfpEgLBgHyxtCgiQfQnYR6+IXOHjpVn5tykgVsNBvB7gYGsEnrL
	 3Oo6LAhct1Sow==
Message-ID: <c467595c-31a4-4d23-abee-0fdf90f8d505@kernel.org>
Date: Mon, 25 May 2026 11:11:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: skip high atomic reservation at or below
 costly order
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 usama.arif@linux.dev, kirill@shutemov.name, willy@infradead.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519012532.272770-1-jp.kobryn@linux.dev>
 <agzH5BCkTMaK19Tx@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <agzH5BCkTMaK19Tx@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kg9wjgha8995mg3z351fcxikmrr4eszs
X-Rspamd-Queue-Id: 1FF914000E
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779700274-616746
X-HE-Meta: U2FsdGVkX19r+qEzr4G5gg+VJJ8NpGYVmUHwz91xwBmUJyea3pSRVbKitoEobILkvUUG9+YZS5XED9p6KLLcfUBDiy7JnK1sLMv2AIUIGQ37ioi1YFVEG87eiLOvyJ79YvcMx/px+4dWCSUa1zg3fu6rd1pm1aUoZ8eteJpSKesGwFsmyT+j6Oj2aW2LPcxEfKboa6Hj+/4aNFnNYqLqu8X8MUC2abL8bF9gxk1RehvhPouqhZChFGCH+1opUMk96x6ext2DygPMtVd58+Dr+OzVaXKWHD0mrEupH/q9rdoGjAsysL4vINmmINDL+CGRj9ErG4dRpbda1E9pQxAsCdaz8+cVKyiDrXS7gA7nTq1QoYoqVlUHxW04Roe8lYDYABCea/fejHdk40PSGG3HkYvG3BAVNwBsoIM2ShpNV1nmmvIYqB5mkAgVBxBbGoWONYcqcwEZ+s5r+LjFO9mUhGrFvY+IL4oExsWu+KiLqsgEh89D/QQHQwmHwz+yk//wIP7PYN4sYYvXXq2WeSkNy7D+9nU3bQas+d16F/FUqsZnXTLVraEfbTHVF7WBfAKk4WlhpA78Im5/cipckBEZK2a9i52wd/6NJBrlzjL/R/YkBU0Mal2RtkLgNkd80h06+uNm89um2X8uw66j5RJFg/5rkyfLMxpJ1zgTzhRG4LHksyj5QhwQ/zGKvfTvnpzjeeguk1K84deBvDJG4RJc9M3/IizZ1eWgskKhAofBb3qwopMBOiRMUWAS9qo0IcVV3uFt4jmqVgADlHjg4enXUF/qggnngNh/714VCVp8aJ63MvACmmapeUCuzKFmaO7Xf0HnR8N69vZfYiAAsC78lscvPuYaQF9PpxOkKR/GonB/vd81A2xUU4RyPhUjeAZa6xiaxI+yI9tTOi5weFOW6O0JtKEzvxzIidOuVeAFOGfvmzhyQG8MM9Qal5FcBf4liitKdqC3CGGhT7fmZ46
 d4K5BiG5
 EWg4zjuQqwrRd5L/U3raGs8I7iD8IMQ1uECi6N+sRN4SGCDf8Lcfw/PK2NracznyvGa0gNH1mC1UisjGBVWX69SQ5XHLXmIhuFGJy9KgngDoz2QZ5sJUJJbVIA2rnyp7m457/H5yHq4SpIAAChVbnBSuUvSDpDol+IjxsQBQiTFOqvXkoae13U7/jWaykPcfU0OAgoYnzDpEGhXs6GIMgGYC+Ixgm3SdnGhuCFX8TAf5ycSS4S3DtrW+ddbt9+mSyDMxVL6at9d18RPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 22:28, Johannes Weiner wrote:
> On Mon, May 18, 2026 at 06:25:32PM -0700, JP Kobryn (Meta) wrote:
>> We're seeing a pattern in production where 2MB THP order-9 allocations are
>> failing due to fragmentation and triggering reclaim on systems with plenty
>> of free memory. Over time, the success rate of these THP allocations do not
>> increase at all.
>> 
>> Inspecting zone->vm_stat[NR_FREE_PAGES] via kprobe on compaction_suitable()
>> indicated the given zone had sufficient free pages for order-9 allocations,
>> yet they were going unused. Drilling down into the zone and inspecting
>> /proc/pagetypeinfo revealed why. Order-9 blocks were accumulating in the
>> zone's HighAtomic bucket (while zero were present in Movable). THP is
>> unable to draw blocks from HighAtomic since that bucket is not in the
>> fallback list.
>> 
>> The heuristic for reserving pageblocks in HighAtomic is that any atomic
>> allocation greater than order-0 will result in the full pageblock being
>> captured. This means that an order-1 atomic allocation will over-reserve by
>> 256x, a full 512 pageblock.
>> 
>> Gate the reservation on order. Skip for allocations at or below
>> PAGE_ALLOC_COSTLY_ORDER. This prevents smaller atomic allocations from
>> reserving entire pageblocks, and significantly helps when THP is in use on
>> a fragmented but otherwise healthy system.
>> 
>> Testing was performed using an A/B instagram workload receiving prod
>> traffic. Each side had ~60 hosts with 64G memory. The patch resulted in
>> several gains:
>> 
>> Unpatched
>> HighAtomic pageblocks per host: 309-312 (1% of zone or 620MB),
>>   ...all order-9 blocks in HighAtomic
>> THP success rate: 1-6%
>> Compaction success rate: 0-2%
>> pgscan_kswapd (total across ~60 hosts, per minute): ~70.2M
>> Atomic order-4+ allocations: 0
>> 
>> Patched
>> HighAtomic pageblocks per host: 1
>> THP success rate: 44-78%
>> Compaction success rate: 24-47%
>> pgscan_kswapd (total across ~60 hosts, per minute): ~29.9M
>> Atomic order-4+ allocations: 0
> 
> This is an interesting patch. A couple of thoughts:
> 
> 1. You disabled the highatomic reserve for this workload and it didn't
> seem to matter. Presumably <costly orders don't need the protection.
> 
> 2. Maxing out the reserves is odd. ALLOC_HIGHATOMIC allocations will
> try reserved space first,

Hmm, but if the allocation succeeds before entering slowpath,
ALLOC_NON_BLOCK won't be set.
But reserving another block should mean we already exhausted the reserved ones.
Unreserving is only done when direct reclaim made some progress but failed
to produce a page. But if it works, or kswapd does the job, we won't enter it?

> and I'd expect things that are commonly
> highatomic to be short-lived. Why don't we stop with a couple of
> claimed highatomic blocks that get continuously recycled?

Maybe it's some big burst of highatomic allocations that leads to the
reservations and then they stay around "forever"?

If that's the case I think we should be perhaps looking at the unreserving
being done more proactively, rather than limiting things to costly order.

> 3. The impact on THP and compaction success rate is pretty
> extreme. How can 1% of memory throw such a wrench into the gears?

Maybe if ~all free memory is in the highatomic blocks, compaction can't be
effective much. Or some suitability check somewhere in reclaim+compaction
wrongly assumes the highatomic blocks are usable, so it won't do the work.

> Have you tried this with other workloads?


