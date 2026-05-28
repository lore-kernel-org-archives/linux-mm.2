Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CCAECD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93E26B0088; Thu, 28 May 2026 09:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45456B008A; Thu, 28 May 2026 09:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A326B008C; Thu, 28 May 2026 09:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85CDC6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:57:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28E271A0863
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:57:13 +0000 (UTC)
X-FDA: 84816980346.29.D8869B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 526BA16000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:57:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a+VZ/FZw";
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779976631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdC0iNfkaJv9U3wkyc7Vbqv6WIBU6jPLq9YB1438JXg=;
	b=19TA7BEVbHwqjw6psIdxVslKyGSvLFyOaL38fidffJBSjeUEQQGfOc/StIUaSkZt+u/s7q
	wWqsUf8xsA9Q5y1tLSAM8SL2u9qBWxnZO7B4htCdD8kMS5dThLttr7bA8C1Y65OROu7Ok7
	GM8bclqPijnWHJsZnsxkZpSZv3+nJQM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a+VZ/FZw";
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779976631; a=rsa-sha256;
	cv=none;
	b=yudUSaxDVvdRvEeRoqIcZAd57zqNX4/yxDLKq2XBTUaLQd2HMNuGb1pRl+gNY1Q2hb2pDL
	KWu0TCbp7VP09CPfV6UmPrlGOIN3b8y6m0tyE7CseNiYMuwiA3+heBXI1TvQUTgrmK2iQ2
	5x3VL5OtWw5OEOg3WloE7MEfTsn+EZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A0A24379A;
	Thu, 28 May 2026 13:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8468B1F000E9;
	Thu, 28 May 2026 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779976630;
	bh=JdC0iNfkaJv9U3wkyc7Vbqv6WIBU6jPLq9YB1438JXg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a+VZ/FZw3uerJfzsLQ8iqKGH4Jm2napobTMs3O8K5+7VFlFz0ISndrM6McjngDkzj
	 hYkM/AqGEG1rSdmQT6WtQuwdgI1frLc58rA8H2lx7vPfEe710pDvZliuwdveP/bIaH
	 DpHfEfcTPOciglKY+vzDbbN3/sYhlL5rjufd5us3NO9OjmXCAMJ9Q9q4u4zK++bg4R
	 D/bNkZ/XDqpeg2ZAEFaFpWzb05JJcse7mLdpECfbRDIgXJIdD84+mdz7uCNjsyywFH
	 yCFZIGii6+QElQ8sTtanJX3ii/lth/r8I1oQ7yRDX12JFW6dgkhetTKERyktOMFzyn
	 aRX+6Ro/v0ygQ==
Message-ID: <ae742ae6-a7b4-424b-bc87-c18200d9d203@kernel.org>
Date: Thu, 28 May 2026 15:57:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: skip high atomic reservation at or below
 costly order
Content-Language: en-US
To: JP Kobryn <jp.kobryn@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Mel Gorman <mgorman@techsingularity.net>
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 usama.arif@linux.dev, kirill@shutemov.name, willy@infradead.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519012532.272770-1-jp.kobryn@linux.dev>
 <agzH5BCkTMaK19Tx@cmpxchg.org>
 <c467595c-31a4-4d23-abee-0fdf90f8d505@kernel.org>
 <7a906c76-6dd9-4bd6-8bab-cb69eb0a3db6@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <7a906c76-6dd9-4bd6-8bab-cb69eb0a3db6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 526BA16000D
X-Stat-Signature: ahptf7bgiajn83mzn7wfw13jp4wk8s5x
X-HE-Tag: 1779976631-469303
X-HE-Meta: U2FsdGVkX1/pMHU0GvAyOXOh/iMeB3OwEmg6NTJi8+6x8ASq+f6kWNeFBe+Isbbhr5l2hN7a9uSqmFDSD50yT4ztG63HdbXWzG3On1n7b9zU9obGGhi12VhwxxEfD83gLFk/him7cyVJZuE//YeWK23BUMJniAyKhSA6TH0rYLGoGnKorke+wuaUDaJvpu5b4P/vOcdEvFrxx48ZB6RE3bJg0K7fDV/mvukaW4+5h89iZsdTnncGYcTu8TpJkgFKXG5ddKUZiXT8clbTXfFJ9rRAqZu4Ul623NgIGoE15slF5zkuTN0NFIoZvXgETXzRG8P9JtXjKR5DAIXjEdPATe+lImvdvxoyAU+/nLEQZauTeNPvt3N6InJc8aSXyxxmNjKcQcv7CDRkpdjA9d2uslUiW4wZ4HHLasCV6DLHa2jRl8mh1dLVtj1RpudXC/9X/sCGbuPZeELP19IzMRpMuWuAahTgoSUiLdBvhUt9NxP4fwy1Pdybj/FovWQadRf/VA/aQ2qoT0oaBqa/XeuUNPHqXRG2a/G9XJggtpu0uXl0zB61ptufhLO0O6bPFKjYyDgcWV5r/+9mZ/4rNatb7VrxCn5jps7/cr/+5/qPawAUky8Hld5mz8/3AeKhAK+50wBJehXrg7YW8NMo32GVfedK/hvZh3yEY85Lv+A2rTSxEz9OFTf/aOFUVMyBJPeDN+PZg/LKSDemD+lA9H050X3lkHmtFrKex4rMyypaxj5PqhSNPnplG68/4O2Uqi2ejZqPKS/TlHRN3FEtYdiogpCwm45VpCnQHECfIQtqmQnXNLWiT7DF8jSrBX1oy7AuYy/iUzDwYstqsG5LPbJCwlR5eD/PkYBnsxchpGCT4Rjuac6Pf52Vaxux1Q7OpvNwC0vPkOpnNVkfvgwP5h+E/Cs3jite5VcCnxknDgPm/coB4ZQXY3B4HetndXDRIJ+Rk/9ErWDERol6q/tkrWf
 v3E3159W
 qRQHTg88Dn8EvOOOOhUJLdGYFwZpA2JSQXZ+qivPiXwi0I632aAzFvp6a5nKmWe48ek9eiFGboJE6iWftV8NKWGmr234887DUJh+mfE6CWZCyNF/vdx/BrQZ8GaZgVrRAFmeyY7qTMPqPqe4vI2hxmF6S7c4m2ebDfz4khciJewKmqyGWLwGqe4VxK27/3H/o6IMUBDXr/PrgfcOjBD5F9QdC2KSitENVdR2LPpdo++kSNYjm50XXLi7JXLyTDhcTu54QwS1C9B0c/LLkd2gnpBZ+3i/zxjNbcdDO0ihnBGWAr41mWQWdBRbiXwvp2B7BSvjc/8K/rO8mIjxxU/adXcl3YGlUFnSzX8AkQC93QMk4pdBhHIpnIdAnjJfkmEaYvtEHIQ/1V5t8uiZJJPK7lilWOWeCTjJBQ9tx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 07:57, JP Kobryn wrote:
> On 5/25/26 2:11 AM, Vlastimil Babka (SUSE) wrote:
>> On 5/19/26 22:28, Johannes Weiner wrote:
>>> On Mon, May 18, 2026 at 06:25:32PM -0700, JP Kobryn (Meta) wrote:
>>> This is an interesting patch. A couple of thoughts:
>>>
>>> 1. You disabled the highatomic reserve for this workload and it didn't
>>> seem to matter. Presumably <costly orders don't need the protection.
>>>
>>> 2. Maxing out the reserves is odd. ALLOC_HIGHATOMIC allocations will
>>> try reserved space first,
>> Hmm, but if the allocation succeeds before entering slowpath,
>> ALLOC_NON_BLOCK won't be set.
>> But reserving another block should mean we already exhausted the 
>> reserved ones.
>> Unreserving is only done when direct reclaim made some progress but failed
>> to produce a page. But if it works, or kswapd does the job, we won't 
>> enter it?
> 
> There was just no real pressure to invoke the unreserving. Let me know
> if I'm misunderstanding the question.

Sorry, it was more thinking out loud about Johannes' point than a question.
Yeah it seems there was no real pressure to invoke unreserving.

The reserving side is probably fine. Highatomic allocation will not try the
already reserved blocks in he fastpath, which is maybe not ideal. But they
will try them before reserving another block, and that's the important part.

>>> and I'd expect things that are commonly
>>> highatomic to be short-lived. Why don't we stop with a couple of
>>> claimed highatomic blocks that get continuously recycled?
>> Maybe it's some big burst of highatomic allocations that leads to the
>> reservations and then they stay around "forever"?
> 
> I should add to the changelog the missing info that high frequency
> net allocations are responsible for these high atomic reservations.
> Even though the allocations are not necessarily long-lived, the
> pageblocks remain high atomic.

OK, thanks for the info.

>> If that's the case I think we should be perhaps looking at the unreserving
>> being done more proactively, rather than limiting things to costly order.
> 
> What are your thoughts if we instead look at it as: should we be reserving
> full pageblocks for small allocations?

Well, since migratetypes operate on the pageblock level, so do the
highatomic reservations. It at least groups them together and not scatter
all over random pageblocks?

> It seems to come down to whether we want the disproportionate protection 
> of full
> pageblocks (below costly order) for high atomic allocs vs letting them 
> coalesce
> in the buddy path. Is the data not enough to justify the latter?

I still think the data shows we might be too lax in unreserving.

>>> 3. The impact on THP and compaction success rate is pretty
>>> extreme. How can 1% of memory throw such a wrench into the gears?
>> Maybe if ~all free memory is in the highatomic blocks, compaction can't be
>> effective much. Or some suitability check somewhere in reclaim+compaction
>> wrongly assumes the highatomic blocks are usable, so it won't do the work.
> 
> I could be missing something, but I spent some time tonight looking into
> this and didn't find an issue in the compaction/reclaim suitability path.
> 
> __compaction_suitable() calls __zone_watermark_ok(), and that path
> subtracts free MIGRATE_HIGHATOMIC pages from usable free memory for
> callers without reserve access:
> 
>   /*
>    * If the caller does not have rights to reserves below the min
>    * watermark then subtract the free pages reserved for highatomic.
>    */
>   if (likely(!(alloc_flags & ALLOC_RESERVES)))
>       unusable_free += READ_ONCE(z->nr_free_highatomic);
> 
> So free highatomic pages are removed from the usable free count there.
> 
> Also, the suitable-free-block check in __zone_watermark_ok() only treats
> MIGRATE_HIGHATOMIC as usable when alloc_flags includes
> ALLOC_HIGHATOMIC (or ALLOC_OOM). __compaction_suitable() passes
> ALLOC_CMA here (not ALLOC_HIGHATOMIC), so I don't think compaction is
> incorrectly treating free highatomic blocks as usable.

OK, thanks for checking.

> The only caveat I noticed is the fragmentation accounting side:
> fill_contig_page_info() / fragmentation_index() appear to count
> free_area[order].nr_free across migratetypes, so fragmentation scoring
> may look better than they really are. But that seems adjacent
> to this patch.

Right.

> I think though that by the time we consider reclaim or compaction we're
> dealing with the aftermath. The patch prevents the problem from occurring
> up front.

But I think as a result the highatomic feature is effectively dead. Your
results confirm there are no more Highatomic pageblocks and zero Atomic
order-4+ allocations (actually it's weird there's still 1 highatomic
pageblock with zero allocations that would reserve it, or is that a rounding
error due to calculating average across multiple hosts?).

I think it's not a surprise that there are no costly highatomic allocation
attempts, we've always said they are too easy to fail, so likely nobody even
tries them. MIGRATE_HIGHATOMIC was introduced by Mel [1] and evaluated on
order-1. Even the non-costly orders can fail of course and should have
fallbacks, highatomic reserves are just supposed to make the success more
likely as that improves e.g. the networking receive performance, and they do
use non-costly orders.

Did you observe no increase of net receive fallbacks due to this patch?
Would that be an universal outcome? I.e. did highatomic reservations become
obsolete thanks to other improvements to the page allocator since they were
introduced? That would be great as we could remove it completely and
simplify the code, but we don't know that yet.

If there are still benefits, they probably should stay, but that means keep
them working for non-costly orders, and we should fix the observed problems
differently. I can see two directions to try in that order.

- You say there are "high frequency net allocations" so I assume they are
ongoing. We could try modify the fastpath __alloc_frozen_pages_noprof() to
properly evaluate ALLOC_HIGHATOMIC and let them prefer the reserved blocks
in cases that do not end up in __alloc_pages_slowpath(). This should ensure
the reserved blocks are actually being used even if we are above low
watermarks and don't enter the slowpath.

- If that doesn't help and we still have unused highatomic pageblocks,
figure out how that happens - is the highatomic allocation frequency higher
at some point, resulting in their increase, and then it drops and they stay
around? If yes, think about how to make the unreserving more aggressive than
it currently is.

[1]
https://lore.kernel.org/all/1442832762-7247-10-git-send-email-mgorman@techsingularity.net/


