Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DCFCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61DCB6B02E4; Mon,  1 Jun 2026 04:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE8F6B02E5; Mon,  1 Jun 2026 04:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD4B6B02E6; Mon,  1 Jun 2026 04:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3957D6B02E4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:59:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAF2F120524
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:59:52 +0000 (UTC)
X-FDA: 84830746224.03.F30856D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13AFEC0008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:59:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b2CW/Rq8";
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780304391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYCwGT0dlz7zUrwC4bUk/y8SmCvJ8n+sjToxU1QLoXY=;
	b=XRZ9BZSTr7eZNM0aBO2wZ11b2iBoNTYOlVVc5y6ht6vqhr0OC/tzSntUs4+b9nVjp+jhgr
	lAJfVh20VkiCxkYT0Vfk8Kdm3xflYe2Np7MvPAeJQh0kMsmvZRNUHFMePKm3q0JxIDY7jh
	LYXBOvcGuvAzLq0MVJKeYTsjm9ApM5w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b2CW/Rq8";
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780304391; a=rsa-sha256;
	cv=none;
	b=ab5H2ugyPMDJe9RhB1iFHb7MyVA4heBqzEe1kW0q1r9R+vE+oTXoX7t+80ZH3LFd0TyV0h
	0sTTb9csbsCyEqf7ar6ZlPln13cF5QbmKtwQwMKSWB0kxVpxaA0uLxkDGb75+Reb5QPgEz
	1AZW6cVa5jjbi+DmCXhW6eO8OA55w6k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76A21601D9;
	Mon,  1 Jun 2026 08:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AAB1F00893;
	Mon,  1 Jun 2026 08:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780304390;
	bh=BYCwGT0dlz7zUrwC4bUk/y8SmCvJ8n+sjToxU1QLoXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b2CW/Rq81dBsqMYMxNnYo9grQKxgqnJu9fa2DJ8t7IunVOGoSUJ0+O+Q4X8AuBjtl
	 a5p4DaG+8WhEAW8ayJOxgKRl6sL6uY6L3QkdkTBRqd8all8NelhyhFWVoRCoBt369P
	 GvP+PfI+b1Cc2LGJIzic4mxOjR7S9yqPZJ8nYs1QQuXR80SU/kHqdrACI/cmZ7xI/o
	 F1Ua7ZArd0khTqtRFJKZMAEwelb1gdtgixIu3Z63EvWXn6ZxvMHnFVOYKlm2Z0kwDC
	 X4a+B2ooTvaMlM4x5MMsGCkmZTCRPgyKvWXCvTVm1wzmo7MaKX+HxE9wlvfCH6O9W9
	 nyAy7njWi2q0g==
Message-ID: <27da4fd7-195f-4086-992e-287f79eb974b@kernel.org>
Date: Mon, 1 Jun 2026 10:59:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/22] mm/page_alloc: implement __GFP_UNMAPPED
 allocations
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-19-28bf1bd54f41@google.com>
 <7bfda0d8-2a7a-4337-8b55-d0c158df7839@kernel.org>
 <DIJEIELZ5DJU.26LYHOT4WR7A2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DIJEIELZ5DJU.26LYHOT4WR7A2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: euzd5h1poxcmoyhy8u18hdzou77qe8a6
X-Rspam-User: 
X-Rspamd-Queue-Id: 13AFEC0008
X-HE-Tag: 1780304390-767957
X-HE-Meta: U2FsdGVkX189R7+4jbgaWgTYBhlXFUdE3ebhbPdQV9EDrY816JWe97Y3OTGitllkWZvjNKkmg30VbCMl+igTFfZRm3IxHXb943wm6octoPZHhBUsrXKwiZ1yrVaLxgwM6RFwqHjrmT8F1RKLA62wZDh5EEbU0kUoXv95KEXehtru1GaVqCmo8EbXaRGbieLXP2W/KsYHNEpfVn28qpuO8idv7fcilk/V3O3K/i7SgP1EkGATR4x22kh1ahl1yA1B9M6hneyQ99WOEHs31h3r2VL9GTD6ToTy2nlyMLHYJBiqaBp25Z7XqKAo1HgYAc/50oLGAXjC4ax323sClPPMCeUSkFeUzvIvJBmfRLozzn18QNLZsK7jUs5z0Ov5tXnm2bKtuuqBW7G4HMEC95nNKb6XCA9qu4JP9BxW3rCiRiCBHlHp19y0IsmCaJA5yFSu39S31+aVZOOCPJv9AYtU6t7M13U7VlwKpDNN5n6kcdZBOAvUuLCvTGnTGeUK0GOSWw06wK1VdB6BzoJM0jKU8+AljEZ3TdgQs3h0PYg/3TsBF01Q7Xy4jwG95UQ7PArFl6OuqPTge5pbgBZnCrh5aJpmO0un4lW1EJ7ILnRj9s8gBnn2TG7/en7kra1qTTWQT1fOc85subj1TNW8QTo1OweBeEPverorBofwmJ2qKXX2LkyOplCkBEGH9FgjUgR1IWv0AYgxo5do0Thc0OfLEVY9ubEJxNroTk3ouzT/TRm1NSfwGiSODwacW7L9eVLr067GeiWAvdC0UmcVupEKlikDftHVMzcCc08nZ3q4hshLOdKk5WnxaYt6+VhcyDBX8fsGy0HTo2z81WLmxANXes0NLCjW4kSGFl12l2eweh7lU4Z9WwGZVPpKWEQgXX1SQr4NIiXfdDCI3vI8C76/uhzDEYkY+tgyFwxIKfgqEROslIu3G+c568H7xuwVplN5BMyriczq7HcjJCrC3/V
 M3KRQP1x
 gVCTov+4M+we18/5hFbKezXURw6jryccMrzoHjFDL6uXpROQcULOGsZS35rBuCMTd1H9K1ENi5ApBIa48j8O4cY6NKFbFNbWmWkLyJHobR/LbWMooxSt4yS4ATX7knE7Zu8V6jWpPlfYtFGzhLTCoakdbxTzpRdPb3+ZLHKqzpdyymyxAA8+W54AZQf9oOXGMGneV5RaffCXa+TRqEUGHEX4w0a9iSy+WB6YnhCtQb5yxicYWuY6cWgAzattMDpQ0Ltq+KaFvm6hMg6O9SLhc4mRZHqbiJFnuXUqwfaUtLRv0qu1IHBNgHGyOQd48PCto66zyywv6GwcIf5eHb5VrDuWImuxKEIeoHxziKipN0fNIqpniPLMsm/T7m5K+QB/uhJ0V3NSDg7Rlw4AXgm9oQODjp10jYJbHsn3Z3gR6mcGca+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/15/26 18:46, Brendan Jackman wrote:
> On Wed May 13, 2026 at 3:43 PM UTC, Vlastimil Babka (SUSE) wrote:
>> On 3/20/26 19:23, Brendan Jackman wrote:
>>> Currently __GFP_UNMAPPED allocs will always fail because, although the
>>> lists exist to hold them, there is no way to actually create an unmapped
>>> page block. This commit adds one, and also the logic to map it back
>>> again when that's needed.
>>> 
>>> Doing this at pageblock granularity ensures that the pageblock flags can
>>> be used to infer which freetype a page belongs to. It also provides nice
>>> batching of TLB flushes, and also avoids creating too much unnecessary
>>> TLB fragmentation in the physmap.
>>> 
>>> There are some functional requirements for flipping a block:
>>> 
>>>  - Unmapping requires a TLB shootdown, meaning IRQs must be enabled.
>>> 
>>>  - Because the main usecase of this feature is to protect against CPU
>>>    exploits, when a block is mapped it needs to be zeroed to ensure no
>>>    residual data is available to attackers. Zeroing a block with a
>>>    spinlock held seems undesirable.
>>
>> Did I overlook something or this patch doesn't do this whole block zeroing?
>> Or is it handled by set_direct_map_valid_noflush itself?
> 
> Oops. At some point I was planning to defer the zeroing to another
> series. I changed my mind about that but, apparently I forgot to
> actually add the code back.
> 
> The code I deleted was in __rmqueue_direct_map() like this:
> 
> 	if (want_mapped) {
> 		<zero the block>
> 	} else {
> 		unsigned long start = (unsigned long)page_address(page);
> 		unsigned long end = start + (nr_pageblocks << (pageblock_order + PAGE_SHIFT));
> 
> 		flush_tlb_kernel_range(start, end);
> 	}
> 
> But actually I'm not sure that's what we want: At the moment, there's
> actually a race condition when allocating __GFP_UNMAPPED|__GFP_ZERO:
> 
> 1. Take page off freelist
> 2. Mermap it
> 3. Zero it
> 4. Mer-unmap it
> 
> I don't know, but some sort of CPU attack might support exploiting the
> gap between 2 and 3 to leak any data left behind from a prior
> allocation. (Like, maybe you can get the data into a uarch buffer during
> the race window, then leak that data afterwards at leisure).

I can't imagine how it would work, but then novel CPU attacks might be
beyond my imagination :) But I think we can ignore hypothetical CPU attacks
for now?

> To mitigate that, we might want to effectively enforce
> want_init_on_free() for unmapped blocks. And, if we do that, we
> don't actually need to zero the block when flipping it back to mapped,
> since there shouldn't be any user data in there.
> 
> Any thoughts on that? I have not tried to implement it yet, I might be
> missing something that makes it impractical. Also I haven't read that
> series that's doing zeroing through user addresses either, this might
> have an interesting interaction with that.

I think let's try the simplest way first.

>>>  - Updating the pagetables might require allocating a pagetable to break
>>>    down a huge page. This would deadlock if the zone lock was held.
>>> 
>>> This makes allocations that need to change sensitivity _somewhat_
>>> similar to those that need to fallback to a different migratetype. But,
>>> the locking requirements mean that this can't just be squashed into the
>>> existing "fallback" allocator logic, instead a new allocator path just
>>> for this purpose is needed.
>>> 
>>> The new path is assumed to be much cheaper than the really heavyweight
>>> stuff like compaction and reclaim. But at present it is treated as less
>>
>> Uhh, speaking of compaction and reclaim... we rely on finding a whole free
>> pageblock in order to flip it. If that doesn't exist, the whole
>> get_page_from_freelist() will fail, and we might enter the
>> reclaim/compaction cycle in __allow_pages_slowpath(). But since we might
>> ultimately want an order-0 allocation, there won't be any compaction
>> attempted, because that code won't know we failed to flip a pageblock. And
>> the watermarks might look good and prevent reclaim as well I think? We
>> should somehow indicate this, and handle accordingly. Might not be trivial.
>> Or maybe reuse pageblock isolation code to do the migrations directly in
>> __rmqueue_direct_map?
> 
> Ah, thanks, I suspect you are right.
> 
> I did fear there would be some sort of case where this "not-quite
> reclaim" interacted badly with the actual reclaim, and I tried to test
> it by running some stuff in parallel with stress-ng (allocating
> __GFP_UNMAPPED via secretmem), and I didn't see a difference in the
> effective availability of memory. However, I suspect testing this is
> quite a deep art my "run these two commands that I copy pasted from an
> LLM suggestion" test was just crap.
> 
> Do you have any workloads you can suggest for evaluating this kinda
> thing? We would definitely see it in Google prod (I think we see this
> kind of issue with our shrinker-based internal version of ASI distorting
> reclaim behaviour in ways even more subtle than this) but that is not a
> very practical experimental cycle...

Your test seems a good way to start.
I realized afterwards that the solution might be something similar to how we
handle ALLOC_NOFRAGMENT.

>>>  
>>> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
>>> +/* Try to allocate a page by mapping/unmapping a block from the direct map. */
>>> +static inline struct page *
>>> +__rmqueue_direct_map(struct zone *zone, unsigned int request_order,
>>> +		     unsigned int alloc_flags, freetype_t freetype)
>>> +{
>>> +	unsigned int ft_flags_other = freetype_flags(freetype) ^ FREETYPE_UNMAPPED;
>>> +	freetype_t ft_other = migrate_to_freetype(free_to_migratetype(freetype),
>>> +						  ft_flags_other);
>>> +	bool want_mapped = !(freetype_flags(freetype) & FREETYPE_UNMAPPED);
>>> +	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
>>
>> Why not RMQUEUE_CLAIM? We want to change the migratetype to ours as well,
>> not just the unmapped flag?
> 
> Oh right, actually I think we need to do RMQUEUE_CLAIM _and_
> RMQUEUE_NORMAL (or, some variant of RMQUEUE_CLAIM that also supports
> allocating from blocks that already have the requested migratetype).
> 
> If we just switch it over to just RMQUEUE_CLAIM right now, while only
> one migrateteype supports FREETYPE_UNMAPPED, I think that would actually
> be broken: When allocating an unmapped block, (want_mapped=true) we
> would always hit the freetype_idx<0 case in find_suitable_fallback().

Right.

> But yeah we do need to do RMQUEUE_CLAIM too otherwise we'll miss
> opportunities to allocate from other unmapped freetypes once those
> exist.
> 
>>> +	unsigned long irq_flags;
>>> +	int nr_pageblocks;
>>> +	struct page *page;
>>> +	int alloc_order;
>>> +	int err;
>>> +
>>> +	if (freetype_idx(ft_other) < 0)
>>> +		return NULL;
>>> +
>>> +	/*
>>> +	 * Might need a TLB shootdown. Even if IRQs are on this isn't
>>> +	 * safe if the caller holds a lock (in case the other CPUs need that
>>> +	 * lock to handle the shootdown IPI).
>>> +	 */
>>> +	if (alloc_flags & ALLOC_NOBLOCK)
>>> +		return NULL;
>>> +
>>> +	if (!can_set_direct_map())
>>> +		return NULL;
>>> +
>>> +	lockdep_assert(!irqs_disabled() || unlikely(early_boot_irqs_disabled));
>>> +
>>> +	/*
>>> +	 * Need to [un]map a whole pageblock (otherwise it might require
>>> +	 * allocating pagetables). First allocate it.
>>> +	 */
>>> +	alloc_order = max(request_order, pageblock_order);
>>> +	nr_pageblocks = 1 << (alloc_order - pageblock_order);
>>> +	zone_lock_irqsave(zone, irq_flags);
>>> +	page = __rmqueue(zone, alloc_order, ft_other, alloc_flags, &rmqm);
>>> +	zone_unlock_irqrestore(zone, irq_flags);
>>> +	if (!page)
>>> +		return NULL;
>>> +
>>> +	/*
>>> +	 * Now that IRQs are on it's safe to do a TLB shootdown, and now that we
>>> +	 * released the zone lock it's possible to allocate a pagetable if
>>> +	 * needed to split up a huge page.
>>> +	 *
>>> +	 * Note that modifying the direct map may need to allocate pagetables.
>>> +	 * What about unbounded recursion? Here are the assumptions that make it
>>> +	 * safe:
>>> +	 *
>>> +	 * - The direct map starts out fully mapped at boot. (This is not really
>>> +	 *   an assumption" as its in direct control of page_alloc.c).
>>> +	 *
>>> +	 * - Once pages in the direct map are broken down, they are not
>>> +	 *   re-aggregated into larger pages again.
>>> +	 *
>>> +	 * - Pagetables are never allocated with __GFP_UNMAPPED.
>>> +	 *
>>> +	 * Under these assumptions, a pagetable might need to be allocated while
>>> +	 * _unmapping_ stuff from the direct map during a __GFP_UNMAPPED
>>> +	 * allocation. But, the allocation of that pagetable never requires
>>> +	 * allocating a further pagetable.
>>> +	 */
>>> +	err = set_direct_map_valid_noflush(page,
>>> +				nr_pageblocks << pageblock_order, want_mapped);
>>> +	if (err == -ENOMEM || WARN_ONCE(err, "err=%d\n", err)) {
>>> +		zone_lock_irqsave(zone, irq_flags);
>>> +		__free_one_page(page, page_to_pfn(page), zone,
>>> +				alloc_order, freetype, FPI_SKIP_REPORT_NOTIFY);
>>> +		zone_unlock_irqrestore(zone, irq_flags);
>>> +		return NULL;
>>> +	}
>>> +
>>> +	if (!want_mapped) {
>>> +		unsigned long start = (unsigned long)page_address(page);
>>> +		unsigned long end = start + (nr_pageblocks << (pageblock_order + PAGE_SHIFT));
>>> +
>>> +		flush_tlb_kernel_range(start, end);
>>> +	}
>>> +
>>> +	for (int i = 0; i < nr_pageblocks; i++) {
>>> +		struct page *block_page = page + (pageblock_nr_pages * i);
>>> +
>>> +		set_pageblock_freetype_flags(block_page, freetype_flags(freetype));
>>> +	}
>>> +
>>> +	if (request_order >= alloc_order)
>>> +		return page;
>>> +
>>> +	/* Free any remaining pages in the block. */
>>> +	zone_lock_irqsave(zone, irq_flags);
>>> +	for (unsigned int i = request_order; i < alloc_order; i++) {
>>> +		struct page *page_to_free = page + (1 << i);
>>> +
>>> +		__free_one_page(page_to_free, page_to_pfn(page_to_free), zone,
>>> +			i, freetype, FPI_SKIP_REPORT_NOTIFY);
>>> +	}
>>
>> Could expand() be used here?
> 
> Hm, good point. It should probably look like what try_to_claim_block()
> does...
> 
> Instead of figuring that out right now I'll just say this: if that works
> I'll do it, if I find a reason why it doesn't I will add a comment
> explaining it in the next version.

Sounds good.

> BTW my thinking is that clarity is the only important factor here, I am
> confident that any speedup from this would disappear in the noise of the
> TLB flushing etc. But, if it works then yeah I think it would actually
> be clearer.

Sure clarity is important, but also if we have multiple functions doing
similar thing instead of sharing code, there's a risk a future change to the
more common code will miss the new one, etc.

> Thanks very much for this review, I really appreciate it!


