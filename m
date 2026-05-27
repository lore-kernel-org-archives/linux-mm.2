Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F29CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 05:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFD76B0005; Wed, 27 May 2026 01:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A1C6B008A; Wed, 27 May 2026 01:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632DF6B008C; Wed, 27 May 2026 01:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB3E6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:58:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E836A1204DF
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:58:17 +0000 (UTC)
X-FDA: 84812144634.22.56A68D3
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id 36FBD18000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:58:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KAfpJMd7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779861496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXPZ9KBSGUZco0FpHy5iFOVu7XECcR41lekBkKihw/Q=;
	b=fT2p9PsmLfAJDHpxKr9B8n2/Rjo/BdBD5z8wm9onwXWMdOpF+PluDUuEvqCRq2C9YE84s1
	duGbC9RfA9/YgypZioqCIWqHr7cr5xSG6rpoMQljDHGVwB17njWAa8RRDVrLB1rF+0MhJ3
	B+BHkjWXVw7ALcBM4Ga2Q7DZYt9XhYE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KAfpJMd7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779861496; a=rsa-sha256;
	cv=none;
	b=mm4HjRv4YWwQ7lEXO45co6SZFGxB6qsGpigiIJXN30z5YZi/+U8Q8W3NnapyjNgPCBE74v
	VxhHXWk7mDucVhX7HzU+bOxGHyI19fT0HDIV7dJ/xqDTmYV6hrH0a6ioNy9OaqhlougY9F
	uHcpofhQwE5YmdqDk/poHqhmr6LsIhc=
Message-ID: <7a906c76-6dd9-4bd6-8bab-cb69eb0a3db6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779861492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FXPZ9KBSGUZco0FpHy5iFOVu7XECcR41lekBkKihw/Q=;
	b=KAfpJMd7pHUbnqNb+MfY88nbqyBdJzYmw9YZ7qRQa1TQi75kXh3mCczaFUC4xY/Yjzs0/p
	dn1su51q/OsgXKaH2qFMnFV9lVmxGleoqgIz7E/pCkXWEBRBfspZlQ9slktCsCbr4zYk7H
	pS7gPobUaxkQHZhY5bHc6GTzezrykOw=
Date: Tue, 26 May 2026 22:57:58 -0700
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
Subject: Re: [PATCH] mm/page_alloc: skip high atomic reservation at or below
 costly order
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 usama.arif@linux.dev, kirill@shutemov.name, willy@infradead.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519012532.272770-1-jp.kobryn@linux.dev>
 <agzH5BCkTMaK19Tx@cmpxchg.org>
 <c467595c-31a4-4d23-abee-0fdf90f8d505@kernel.org>
Content-Language: en-US
In-Reply-To: <c467595c-31a4-4d23-abee-0fdf90f8d505@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 36FBD18000A
X-Stat-Signature: ci6ay14upn1ureqtp49s1pngjeedntri
X-Rspam-User: 
X-HE-Tag: 1779861496-565264
X-HE-Meta: U2FsdGVkX1/AJ0nT3dEBEB/Z1FgJYasGNOGlinQr4CCpX0FgyPIvI/HjWt/lo9slfaTN65I7DnSEPO9aUPnvL/jNP+M56KONiwsoM8QNQkh0QwGBXkcBYtyo/B65+SDvIW6qkAnqs3PglkukOXaDdvFBm0RK7g1CNtJxThja2rUvFCQmzVKev8IjhG0NCrl+ZIMmlL09WmI02yOqjQ1xTa/edzJedF2P+WI+/PxRaNYBoQBm/PuYZBYtGKsnKuy++DlBS4QlJrnBgu2x9kevM2AJ5TAuFpGkXfES/S7Pix60BejSg283pIR9MpmBqlQvefBPoB143UznajwuJZwKF9zu4hr4eXfIzElKaMXtPoG5jo9Es0gWc5JXcPUGSlUWrgOstxHlfEHRj8B5hIZYTf1vJd74aqEG0iGBQK32Wzh2nfyYfc0Y7Jkbmn/G/nBR7+EaEA/gNxMU7R6YSiRFOHW/63eMLCoxwzHsgw7lMoKtS2yoD8HHZIHMAORfbYqWBnzgPIqjrZCI0Q4JfqoB+4NZphBrcVIDdYIftvyZrLoPpnbmIoVuGFkweHeSO7BjuZQuS2x4geU/IEN2oYpSo5DOwQFneEb/nBiOzlnpUbqs4slOdXEjK8Y3Cny9nqXGc2WyC23bSnWcEJYFb6CBKI8/58SlSmz68hFnn2odORoDO48wgXkIOtEyJF8zSeu0DkMG6hwtXpafi3Obj4NiZqWyhuvkZNxmtDIl6Ry8zaiQNTAhrGPQzO6wDBP1c/lYAfwUOyQMsqOilE0PxtZMhcnpDBqAo6YbqLXP2UXKP5uTBZR+i7nsKU2MqMW+6bZd2jnTg5yLyEIQ7dbmVyWT9wXXwTSkYqzzWl9x3tec31x+CPtXpMFldWvj+cLgWESg27UmPU5PyHmbExppSvOqjwD+wiROiC9AjOuoYJRNSlVmPEjbSmANuGScCLW2MzMNJYsESuXA+GtFHPgpBPc
 GqW2aavI
 Gu0jQ4YEk/x4wg2HnDmRwdnuWvmd/iunHfeuiU3w4LrvOc8w1QBIWxFMhsPICZrh/aOWu054gSAiwcr/eQywRQCdh693W0sP2p/XNhlIjljP3KdekvYA1JU2awZmgFu5zp3DAkJ2G67fQ68tLhumrP7Nusk92V9tEwA96YPH4e93HJlgl02Ji5a1ptqDpirkQmUmLZ34nhyK5zo/bDf7bHCQwfXGEjAg/Eymu11oEr9hHHYPxqW1IdkSGvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 2:11 AM, Vlastimil Babka (SUSE) wrote:
> On 5/19/26 22:28, Johannes Weiner wrote:
>> On Mon, May 18, 2026 at 06:25:32PM -0700, JP Kobryn (Meta) wrote:
>>> We're seeing a pattern in production where 2MB THP order-9 
>>> allocations are
>>> failing due to fragmentation and triggering reclaim on systems with 
>>> plenty
>>> of free memory. Over time, the success rate of these THP allocations 
>>> do not
>>> increase at all.
>>>
>>> Inspecting zone->vm_stat[NR_FREE_PAGES] via kprobe on 
>>> compaction_suitable()
>>> indicated the given zone had sufficient free pages for order-9 
>>> allocations,
>>> yet they were going unused. Drilling down into the zone and inspecting
>>> /proc/pagetypeinfo revealed why. Order-9 blocks were accumulating in the
>>> zone's HighAtomic bucket (while zero were present in Movable). THP is
>>> unable to draw blocks from HighAtomic since that bucket is not in the
>>> fallback list.
>>>
>>> The heuristic for reserving pageblocks in HighAtomic is that any atomic
>>> allocation greater than order-0 will result in the full pageblock being
>>> captured. This means that an order-1 atomic allocation will 
>>> over-reserve by
>>> 256x, a full 512 pageblock.
>>>
>>> Gate the reservation on order. Skip for allocations at or below
>>> PAGE_ALLOC_COSTLY_ORDER. This prevents smaller atomic allocations from
>>> reserving entire pageblocks, and significantly helps when THP is in 
>>> use on
>>> a fragmented but otherwise healthy system.
>>>
>>> Testing was performed using an A/B instagram workload receiving prod
>>> traffic. Each side had ~60 hosts with 64G memory. The patch resulted in
>>> several gains:
>>>
>>> Unpatched
>>> HighAtomic pageblocks per host: 309-312 (1% of zone or 620MB),
>>> ...all order-9 blocks in HighAtomic
>>> THP success rate: 1-6%
>>> Compaction success rate: 0-2%
>>> pgscan_kswapd (total across ~60 hosts, per minute): ~70.2M
>>> Atomic order-4+ allocations: 0
>>>
>>> Patched
>>> HighAtomic pageblocks per host: 1
>>> THP success rate: 44-78%
>>> Compaction success rate: 24-47%
>>> pgscan_kswapd (total across ~60 hosts, per minute): ~29.9M
>>> Atomic order-4+ allocations: 0
>> This is an interesting patch. A couple of thoughts:
>>
>> 1. You disabled the highatomic reserve for this workload and it didn't
>> seem to matter. Presumably <costly orders don't need the protection.
>>
>> 2. Maxing out the reserves is odd. ALLOC_HIGHATOMIC allocations will
>> try reserved space first,
> Hmm, but if the allocation succeeds before entering slowpath,
> ALLOC_NON_BLOCK won't be set.
> But reserving another block should mean we already exhausted the 
> reserved ones.
> Unreserving is only done when direct reclaim made some progress but failed
> to produce a page. But if it works, or kswapd does the job, we won't 
> enter it?

There was just no real pressure to invoke the unreserving. Let me know
if I'm misunderstanding the question.

>> and I'd expect things that are commonly
>> highatomic to be short-lived. Why don't we stop with a couple of
>> claimed highatomic blocks that get continuously recycled?
> Maybe it's some big burst of highatomic allocations that leads to the
> reservations and then they stay around "forever"?

I should add to the changelog the missing info that high frequency
net allocations are responsible for these high atomic reservations.
Even though the allocations are not necessarily long-lived, the
pageblocks remain high atomic.

> If that's the case I think we should be perhaps looking at the unreserving
> being done more proactively, rather than limiting things to costly order.

What are your thoughts if we instead look at it as: should we be reserving
full pageblocks for small allocations?

It seems to come down to whether we want the disproportionate protection 
of full
pageblocks (below costly order) for high atomic allocs vs letting them 
coalesce
in the buddy path. Is the data not enough to justify the latter?

>> 3. The impact on THP and compaction success rate is pretty
>> extreme. How can 1% of memory throw such a wrench into the gears?
> Maybe if ~all free memory is in the highatomic blocks, compaction can't be
> effective much. Or some suitability check somewhere in reclaim+compaction
> wrongly assumes the highatomic blocks are usable, so it won't do the work.

I could be missing something, but I spent some time tonight looking into
this and didn't find an issue in the compaction/reclaim suitability path.

__compaction_suitable() calls __zone_watermark_ok(), and that path
subtracts free MIGRATE_HIGHATOMIC pages from usable free memory for
callers without reserve access:

  /*
   * If the caller does not have rights to reserves below the min
   * watermark then subtract the free pages reserved for highatomic.
   */
  if (likely(!(alloc_flags & ALLOC_RESERVES)))
      unusable_free += READ_ONCE(z->nr_free_highatomic);

So free highatomic pages are removed from the usable free count there.

Also, the suitable-free-block check in __zone_watermark_ok() only treats
MIGRATE_HIGHATOMIC as usable when alloc_flags includes
ALLOC_HIGHATOMIC (or ALLOC_OOM). __compaction_suitable() passes
ALLOC_CMA here (not ALLOC_HIGHATOMIC), so I don't think compaction is
incorrectly treating free highatomic blocks as usable.

The only caveat I noticed is the fragmentation accounting side:
fill_contig_page_info() / fragmentation_index() appear to count
free_area[order].nr_free across migratetypes, so fragmentation scoring
may look better than they really are. But that seems adjacent
to this patch.

I think though that by the time we consider reclaim or compaction we're
dealing with the aftermath. The patch prevents the problem from occurring
up front.


