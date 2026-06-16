Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD420CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A144F6B0098; Tue, 16 Jun 2026 16:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ECAD6B00B9; Tue, 16 Jun 2026 16:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9296B6B00BB; Tue, 16 Jun 2026 16:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB4E6B0098
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:56:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1DF0140266
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:56:04 +0000 (UTC)
X-FDA: 84886983048.13.0B65564
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA5E7120005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:56:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JtqzoA8V;
	spf=pass (imf29.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSaf42jn3+fLsDQCSMpWQgJLjHRCHodZ2YaUk+EncNo=;
	b=yLhhr6cbwHY2NE7Ed3juaw1s3Jg14UceWiPjVpTpLHmP4McYpQ5JS3Nu1iGBkZR4T3NAdX
	xrDfEsx41ybltDneKjZl9JnKS0BwVneguZnN6V9K7njgN54tGQtRsfsc8i0tf+ElJ0nAT6
	k4k19iq8MwLcaJMsoT9iyFJEQhS1CeQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781643363;
	b=bCgKtQ9/SpCUm4w8cWkJGVjgKJVSkjfkK0CXUO2w91gdbMVzgHTlMLgIEfW9RhZy4vHrXO
	maMXIiJVLpvYvpqwA78EIR+iZbmXR5sWndnZW1qjf7UCpfsma1u4/HIBy5PtfP60xNA5l5
	VCyGsion1CQ1dkh+wcNDfOYfHt7A4TY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JtqzoA8V;
	spf=pass (imf29.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <bb1e9f4c-be28-4bc8-8a45-a59b3af888f0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781639951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gSaf42jn3+fLsDQCSMpWQgJLjHRCHodZ2YaUk+EncNo=;
	b=JtqzoA8VKjIknorG9Pb5x3/2DDERgweH5lFIkkFecJxVUyFViaJepzDV3BzXOqWP2BCAPb
	f85KZIXyMPYiNn3emkIe/aV0Z70wAo9ykhyTOHct2bK0NN9ZXQ+0ozwPTJLAXf9ZGIiQxX
	KJrrnf3/62eg9z5cIYgclQe22sUDKgo=
Date: Tue, 16 Jun 2026 12:58:48 -0700
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
Subject: Re: [PATCH] mm/page_alloc: skip high atomic reservation at or below
 costly order
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Mel Gorman <mgorman@techsingularity.net>
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 usama.arif@linux.dev, kirill@shutemov.name, willy@infradead.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519012532.272770-1-jp.kobryn@linux.dev>
 <agzH5BCkTMaK19Tx@cmpxchg.org>
 <c467595c-31a4-4d23-abee-0fdf90f8d505@kernel.org>
 <7a906c76-6dd9-4bd6-8bab-cb69eb0a3db6@linux.dev>
 <ae742ae6-a7b4-424b-bc87-c18200d9d203@kernel.org>
Content-Language: en-US
In-Reply-To: <ae742ae6-a7b4-424b-bc87-c18200d9d203@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DA5E7120005
X-Rspam-User: 
X-Stat-Signature: fj5g8yiwrhgt1g8g5cdqd8ibeeyx8xqk
X-Rspamd-Server: rspam08
X-HE-Tag: 1781643362-902593
X-HE-Meta: U2FsdGVkX18XjMsXpRh9l8GdObxSicV1jooN9rhJfDWVheqizOJpGQ4Ut7J3IYT6kARqQfKzpa5RrJBUiBqWidp37pPHr56+cRfeymEYu4X9pUbp7285tIINsbLeJG0HqCi3V3bc8WMIJWGEUZvCpD/vVVspf0AR+rERVDzlZHV/1zPhzev8PMtWY3jwzpUdpAa0begSfzBK7reVoB2v9TTOw9mPNR/5gvQbB7MsVCJ6e8YBD5cnGXUccYud9xvkbP/lUm87r9TToVlhx4G3t6JtTqISjqnuQXiyWUfRZHAauQvfe+HaMR2Nkn9Jx4R4UPfFll1JDk0Mn823NIZ63G69pHWjHTD0gIQEcSSXr5JQPaKqDsjqXDMUNELBaBP15/nlYSKBDilEUmAUAJweBC5gbsNqCfEepOrKoqmfqhn4Xj+vDn09V2niQrCtawnynHRxzx0HzHocIz6p0eRLY/Fjxd3/uBSY3AUDNBX7jhX3yMtTxYJ8xWeHWmv6aTCpDE0RsKYqBloPyqWXyN8dvxUQ4NOTWE+KlkMBZmkqVBLQzd/ybVZlAsjI6krNkIkHcKff6Z/I0xN0Mg7/O3zrNjq9lpUHSX7G/HgxfvWVbN+evJ4fmenmt1KkvzMS9XBeRjADg4wa/fhM9AOGfBJEr1QG01+TkvedaFWelqCxzBNflDP6+05cAUPXtWl2bynNuUDmjr+ey1wGYUkOrfstaXPHXxE0jVvvNFhCa0uJAZDkjIN/UjB6+ST9qTEUT7AeAEzdVGZbFZuI84nYQNCGDxRseoPNM0MFnpiio6lKQJWYAjA61S5IC4jwtvzb7hFTzO3n8ErLJXIVu2GTOPE4+PXqZRrXBevsX8b8UtEdgBN6sVSNr0LZikqZajODp1xyeiiiD0XFbgfZREFErgaePjQoNnhB3Fz951aOe788z83nu7l1ZOgj6WU95TFUG8THiy3CDbmKZrwlDkmJ6S/
 fAOgQEG2
 2yIIDhu0gbZWbGNWsVq93jdQuACBPp56wjzr6pUqXwYKDaZH5TokghOlv4iMM/AE25yj7+xDcOfNdzXO6v86GzGyDMRk9qAkGKGGLMgB85/WcwavsxVm5eVNP7etUnO6rOhp5sYYdUVfEuLesvau2Y+X15mjuzxNvSkPTm/HHq+jnEIST94XWjm6UJiz/iafbFDP/REuRR9e9SSbQrKv0pc9LmjZtFkKtbNmhb9A42lw2XfPS5RPmG+rTS4D5VDezdX6kLk+FLn4LXcEsvSIm97zW+ANo/KHVjuYjTO7uY5C8iW4NMhW0rFjxSrRBRRQoMjD5e2AFDtgKFzy2JDP5+8EsRzphsgL+n2n8rzuJjqh/lCU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 6:57 AM, Vlastimil Babka (SUSE) wrote:
> On 5/27/26 07:57, JP Kobryn wrote:
>> On 5/25/26 2:11 AM, Vlastimil Babka (SUSE) wrote:
>>> On 5/19/26 22:28, Johannes Weiner wrote:
>>>> On Mon, May 18, 2026 at 06:25:32PM -0700, JP Kobryn (Meta) wrote:
>>>> This is an interesting patch. A couple of thoughts:
>>>>
>>>> 1. You disabled the highatomic reserve for this workload and it didn't
>>>> seem to matter. Presumably <costly orders don't need the protection.
>>>>
>>>> 2. Maxing out the reserves is odd. ALLOC_HIGHATOMIC allocations will
>>>> try reserved space first,
>>> Hmm, but if the allocation succeeds before entering slowpath,
>>> ALLOC_NON_BLOCK won't be set.
>>> But reserving another block should mean we already exhausted the 
>>> reserved ones.
>>> Unreserving is only done when direct reclaim made some progress but failed
>>> to produce a page. But if it works, or kswapd does the job, we won't 
>>> enter it?
>>
>> There was just no real pressure to invoke the unreserving. Let me know
>> if I'm misunderstanding the question.
> 
> Sorry, it was more thinking out loud about Johannes' point than a question.
> Yeah it seems there was no real pressure to invoke unreserving.
> 
> The reserving side is probably fine. Highatomic allocation will not try the
> already reserved blocks in he fastpath, which is maybe not ideal. But they
> will try them before reserving another block, and that's the important part.
> 

I sent a patch [0] that addresses this.

>>>> and I'd expect things that are commonly
>>>> highatomic to be short-lived. Why don't we stop with a couple of
>>>> claimed highatomic blocks that get continuously recycled?
>>> Maybe it's some big burst of highatomic allocations that leads to the
>>> reservations and then they stay around "forever"?
>>
>> I should add to the changelog the missing info that high frequency
>> net allocations are responsible for these high atomic reservations.
>> Even though the allocations are not necessarily long-lived, the
>> pageblocks remain high atomic.
> 
> OK, thanks for the info.
> 
>>> If that's the case I think we should be perhaps looking at the unreserving
>>> being done more proactively, rather than limiting things to costly order.
>>
>> What are your thoughts if we instead look at it as: should we be reserving
>> full pageblocks for small allocations?
> 
> Well, since migratetypes operate on the pageblock level, so do the
> highatomic reservations. It at least groups them together and not scatter
> all over random pageblocks?

Right, that's the trade-off. I'm not going to pursue this approach.
Instead, I've been looking for a more targeted fix in the relevant
allocator paths. See this patch [0].

> 
>> It seems to come down to whether we want the disproportionate protection 
>> of full
>> pageblocks (below costly order) for high atomic allocs vs letting them 
>> coalesce
>> in the buddy path. Is the data not enough to justify the latter?
> 
> I still think the data shows we might be too lax in unreserving.

Ack.

> 
>>>> 3. The impact on THP and compaction success rate is pretty
>>>> extreme. How can 1% of memory throw such a wrench into the gears?
>>> Maybe if ~all free memory is in the highatomic blocks, compaction can't be
>>> effective much. Or some suitability check somewhere in reclaim+compaction
>>> wrongly assumes the highatomic blocks are usable, so it won't do the work.
>>
>> I could be missing something, but I spent some time tonight looking into
>> this and didn't find an issue in the compaction/reclaim suitability path.
>>
>> __compaction_suitable() calls __zone_watermark_ok(), and that path
>> subtracts free MIGRATE_HIGHATOMIC pages from usable free memory for
>> callers without reserve access:
>>
>>   /*
>>    * If the caller does not have rights to reserves below the min
>>    * watermark then subtract the free pages reserved for highatomic.
>>    */
>>   if (likely(!(alloc_flags & ALLOC_RESERVES)))
>>       unusable_free += READ_ONCE(z->nr_free_highatomic);
>>
>> So free highatomic pages are removed from the usable free count there.
>>
>> Also, the suitable-free-block check in __zone_watermark_ok() only treats
>> MIGRATE_HIGHATOMIC as usable when alloc_flags includes
>> ALLOC_HIGHATOMIC (or ALLOC_OOM). __compaction_suitable() passes
>> ALLOC_CMA here (not ALLOC_HIGHATOMIC), so I don't think compaction is
>> incorrectly treating free highatomic blocks as usable.
> 
> OK, thanks for checking.
> 
>> The only caveat I noticed is the fragmentation accounting side:
>> fill_contig_page_info() / fragmentation_index() appear to count
>> free_area[order].nr_free across migratetypes, so fragmentation scoring
>> may look better than they really are. But that seems adjacent
>> to this patch.
> 
> Right.
> 
>> I think though that by the time we consider reclaim or compaction we're
>> dealing with the aftermath. The patch prevents the problem from occurring
>> up front.
> 
> But I think as a result the highatomic feature is effectively dead. Your
> results confirm there are no more Highatomic pageblocks and zero Atomic
> order-4+ allocations (actually it's weird there's still 1 highatomic
> pageblock with zero allocations that would reserve it, or is that a rounding
> error due to calculating average across multiple hosts?).

Likely a rounding issue.

> 
> I think it's not a surprise that there are no costly highatomic allocation
> attempts, we've always said they are too easy to fail, so likely nobody even
> tries them. MIGRATE_HIGHATOMIC was introduced by Mel [1] and evaluated on
> order-1. Even the non-costly orders can fail of course and should have
> fallbacks, highatomic reserves are just supposed to make the success more
> likely as that improves e.g. the networking receive performance, and they do
> use non-costly orders.
> 
> Did you observe no increase of net receive fallbacks due to this patch?
> Would that be an universal outcome? I.e. did highatomic reservations become
> obsolete thanks to other improvements to the page allocator since they were
> introduced? That would be great as we could remove it completely and
> simplify the code, but we don't know that yet.

See the separate patch [0] which takes a targeted approach on the
allocator path. It accounts for net fallbacks and should help napi/page
frag allocs in the fastpath.

> 
> If there are still benefits, they probably should stay, but that means keep
> them working for non-costly orders, and we should fix the observed problems
> differently. I can see two directions to try in that order.

Ack.

> 
> - You say there are "high frequency net allocations" so I assume they are
> ongoing. We could try modify the fastpath __alloc_frozen_pages_noprof() to
> properly evaluate ALLOC_HIGHATOMIC and let them prefer the reserved blocks
> in cases that do not end up in __alloc_pages_slowpath(). This should ensure
> the reserved blocks are actually being used even if we are above low
> watermarks and don't enter the slowpath.

Yes, this can be seen in the separate patch [0].

> 
> - If that doesn't help and we still have unused highatomic pageblocks,
> figure out how that happens - is the highatomic allocation frequency higher
> at some point, resulting in their increase, and then it drops and they stay
> around? If yes, think about how to make the unreserving more aggressive than
> it currently is.
> 
> [1]
> https://lore.kernel.org/all/1442832762-7247-10-git-send-email-mgorman@techsingularity.net/
> 

The patch below improves the allocator path. I'll explore opportunities
for unreserving.

[0] https://lore.kernel.org/all/20260616191420.52556-1-jp.kobryn@linux.dev/

