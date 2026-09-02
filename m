Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF7FC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8F46B00D8; Wed,  2 Sep 2026 12:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89E26B00D9; Wed,  2 Sep 2026 12:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A5D6B00DA; Wed,  2 Sep 2026 12:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB9B6B00D8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:47:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 272EA160270
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:47:18 +0000 (UTC)
X-FDA: 85169402556.05.6C09076
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	by imf11.hostedemail.com (Postfix) with ESMTP id 09E1D40008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:47:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f0XoB4DU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788367636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aiNB/pW9cE5KFwsqGrgP6Ks9w7p+Fnft+mpM/vD5sqA=;
	b=qWlT5QOgDUMl43u7o3zIc1ibva+RRgVsMaHCnsf011YKiwHS84XIlf5umpsot9kIj0LElO
	6nnCAcdopnkPzrwo1D8u6MtaBrOcGD/AZBFGUKHW27mw7TYvqii7yvEDt93IahT0I6hQu1
	8HrCBnnjJC2YfcSGS2UyIjZuyRZkN7w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f0XoB4DU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788367636;
	b=MDcChiF0MO/xrP1ANoEen3Fe5qWR8el7bSZ7sE0bJ0A2iAUkbbQoSK/JvUV6mlByonTaem
	GefCxTaF49oVmBFmpPNVL7JywdMK8m56rfVa3ZC+0/hyd7Wm+0zylRqFn8WRDRLwwYdd3I
	YO71a1FsDfxRVy6mX8Ok/KM5fZdtD5k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Y4pHs4Y3EiBbkU7VVftsLC18a5d9QR/DWz6/s/ZFOvw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788367633; v=1; x=1788972433;
 b=f0XoB4DUONwwosIt9VVgUyLKwM8B/LT1Cav6ciQpYXg9QlGL1BAMqNUWPpetB+fJKjkrhUv+
 cdgOaOnYzX9sRFk6V41dMHJEUyBmn5JCQ6wQzS3xPgITKehWiS8PsOVnrigs4YIIx5wVWGoLivo
 95pMQp6opvv0JKKwzivrf01A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b46acf156380a251;
	Wed, 02 Sep 2026 16:47:12 +0000
X-Mizu-Trace-ID: b46acf156380a251
X-Migadu-Flow: FLOW_OUT
Message-ID: <583c4718-f763-41f0-b757-02b46655c0b5@linux.dev>
Date: Wed, 2 Sep 2026 17:47:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
To: Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: Nimrod Oren <noren@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Hugh Dickins
 <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260901204449.GK3004@cmpxchg.org>
 <C8541A2F-D6A9-41B0-A3FE-52339A6601F0@nvidia.com>
 <20260901220917.GM3004@cmpxchg.org>
 <69C018F5-A1C8-47AD-9567-3497AA6808EC@nvidia.com>
 <20260902160417.GN3004@cmpxchg.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260902160417.GN3004@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cexrjz65qb4mzsdk6qqg3kws59674tyc
X-Rspamd-Queue-Id: 09E1D40008
X-HE-Tag: 1788367635-958487
X-HE-Meta: U2FsdGVkX1/4ZFa/35TjkvuuobHApRo20+dw0rOX4nCeSfPWLyvS8HOkwRwshfGc1iUEqM4WTOg0M6bHjwPw8Xt3lKKkykl9ozgSlD6mueyV0Z/q0q3GrJrrigosv9XMQrnJ98S/7tbSDTE5PGc/0OzDeqmanJvaC7TjxfZE/TSg85dKBjj20UPgeIvDYfF0ssWCTqqwepAGWdoBW9JtpLMlbW0q4a0bGbbD2qdltS+pGxEHwOix1VzNfxKTDr5+svv2OyRkXLaI2ms1ebO4D3NMcnGByD58WxRw6cCUt7+cCgZI8pqef1g2JZMonvE5SbosmlfICChjek0b2yRIMvdvVBQzQHWYhA888qIlrzBZOLp3Xg64zx3xUPFdfneqv0cPMrNj4Ejr89eBXFp5n/k+NEfK7Vh14ZuGjKKd57wvhoPq5KeEYRrkWwG9rhBy+uyKJxAQ+JZo266/2WFHFuRIUpLf0YrUv0sfBzuPQ/IHVEQhJ4Od+cDc5ZMEVw1+WExqeXI10Aud3fpJY5F0OC5RiFULyn7HDpnojErTfWGANpY88MEWJho6WewLsAeAo5jXoltm7shBw+EIRAY02D4FrGqYu48/VKACfZr08x+jXQk5z/GiB00KiWrzeqaumVAyTTChTuoEsP5f45zYVRviu5lleKbfZyE2Ot3gIoy9Jc1Y5zgIwmmdZATyPykfnmMIB0geNEIQER9ZVMNTLl4dpN2IrjuV3+xC6aiUHbeJ3GH15fv8et2I9mcEklc+/PJ5M+d6xWh8YrUORG79HYnAdI5vt+b0rG9LpF6fFlEG664cZGvIUaaQk/9ZjfYBuoxeK3C1BOJea0egyUM5rb/JPwreSgG7/jz5rv1slRZ+THB8DQPJ5RS+s17Pr16pQWxHOq34e3HkpHfiG3VDjYR7SnGOKLLuRwZn7a16ch7CDf3d88u1NLPOVvHocb2atD++8wCSIXA3+f2dGKS
 K6G4BPYs
 PEGJOWp2VblzmUUE3d/ABeIU834YO3FtxMnBT3UENVY5Ergq0V6hokoiRiPymnN5udcTAf+i/eNreQdwrDZI8hptR2ok/f27bm3jqYXfRhqO9Cofd0hBeGM+BRuW8fufOPPWj4JP4gUX2Q5KTwqWY8dv12G4xAliO5sYxkDiyIDsizd2Cmm0JOpd7C8z8yyXTc7D3E3z2Mn/NSJIbc6lEPEgeV5xDopAhBumdbLOBQSg3RBypUcNOu3S1g5eXExCLHpYlbUXJRfiwpjRhghOis7Lll9kXEn0GS0RNZeAFK/vrcol1VkwWPABoaemWmkU4ZCAvl7PwhweVZwo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/09/2026 17:04, Johannes Weiner wrote:
> On Tue, Sep 01, 2026 at 09:49:58PM -0400, Zi Yan wrote:
>> On 1 Sep 2026, at 18:09, Johannes Weiner wrote:
>>
>>> On Tue, Sep 01, 2026 at 05:09:52PM -0400, Zi Yan wrote:
>>>> On 1 Sep 2026, at 16:44, Johannes Weiner wrote:
>>>>
>>>>> On Tue, Sep 01, 2026 at 10:01:23PM +0300, Nimrod Oren wrote:
>>>>>> When THP is enabled, set_recommended_min_free_kbytes() may raise
>>>>>> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
>>>>>> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
>>>>>> heuristic to help keep pageblocks free and reduce fragmentation for THP
>>>>>> allocations.
>>>>>
>>>>> We've had problems with compaction before when min_free_kbytes was too
>>>>> small on large machines. Competing free space scanners do a lot of
>>>>> work only to fight over a very small set of possible target pages.
>>>>>
>>>>> So I'm a bit uneasy that you didn't include any benchmark numbers with
>>>>> this that prove basic functionality on larger hosts isn't regressed.
>>>>>
>>>>>> The recommendation scales poorly with larger base page sizes. With the
>>>>>> default arm64 pageblock sizes, the contribution per eligible zone
>>>>>> before applying the existing cap of 5% of low memory is:
>>>>>>
>>>>>>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>>>>>>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>>>>>>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
>>>>>
>>>>> I question whether pageblocks need to be 512M on those machines to
>>>>> begin with. After this patch, you're still asking the page allocator
>>>>> to optimize grouping such that 512M pages can be allocated at
>>>>> runtime. Only now you took away part of the mechanism to do so.
>>>>>
>>>>> If you're using 512M THPs, I would kind of assume it's on machines
>>>>> with a memory size where 5.5G for defrag purposes isn't devastating.
>>>>>
>>>>> And if you're not, it would make more sense to lower the pageblock
>>>>> size to the mTHP size you're actually using. And that would fix the
>>>>> "excessive" min_free_kbytes issue as well.
>>>>
>>>> But lowering pageblock size requires a kernel compilation. That means
>>>> maintaining two sets of kernels for different needs.
>>>
>>> That depends on whether anyone actually wants 512M pageblocks...
>>>
>>>> The ultimate solution is to enable better compaction to generate
>>>> THPs bigger than a pageblock size, like Rik's super-pageblock
>>>> proposal.
>>>
>>> ...or whether we can say, at that point, use gigablocks/cma+hugetlb.
>>>
>>> And then the static pageblock size for the fallback logic etc. can be
>>> a smaller, saner default for everybody.
>>>
>>> Because the point you didn't address: it doesn't make really sense to
>>> have 512M pageblocks on smaller machines, beyond the min_free_kbytes
>>> issue: Fragmentation events will poison half a gig at once,
>>> should_try_claim_block() becomes harder which results in less
>>> conversions and more allocations falling through to stealing, page
>>> isolation is more likely to fail, compaction locks and operates on
>>> oversized chunks which is bad for latency and concurrency...
>>
>> I actually wonder why such a big pageblock would still result in a lot
>> of fallbacks.
> 
> If you look at try_to_claim_block(), you need half of a block to be
> free or compatible with the requested migratetype in order to convert
> it. When memory is full, LRU pages are scattered all over, and
> compaction is not involved (order-0), this gets more difficult the
> bigger the block is. You can get into a situation where LRU reclaim
> will not clear sufficient room for conversion in any given pageblock
> anymore and you're stuck with the type distribution. A large share of
> buddy requests then go permanently through the slower fallback path.
> 
> Usama knows more about this, but we have seen this on GB300 hosts, and
> have JUST started to deploy kernels with smaller pageblocks (2M).

Yes, just to confirm above, unfortunately, there were too many problems
we were seeing in Meta production with 512M pageblock size for arm 64K
base page size and just had to switch to 2M.

> 
>> Basically it indicates at some point kernel allocates a lot of
>> unmovable pages that use many 512MB pageblocks and the life time of
>> these unmovable pages are so diverse, leading to all these
>> pageblocks remain unmovable and free pages spread across all these
>> pageblocks. I thought bigger pageblocks can keep unmovable pages
>> constrained within fewer pageblocks, leaving more contiguous free
>> memory.
> 
> The idea is that the pageblock maintains contiguity for the largest
> size you routinely expect to allocate.
> 
> The page allocator is very passive right now, and it doesn't work
> super reliably. But even in the current regime, smaller blocks have a
> better chance of containment.
> 
> For example, when the ever-growing page cache runs out of movable
> block space, it spills into unmovable free space. When the next
> unmovable request finds no space, it runs LRU reclaim - which is more
> likely to free space in one of the many movable blocks. And so the
> next block is poisoned. Smaller blocks have a better chance of filling
> up natively, means less pressure to spill into incompatible ones.
> 
> And the higher min_free_kbytes, the more likely there are still native
> options when the zones are down to the watermarks. E.g. better odds
> there is still unmovable free space, you just need to reclaim some
> movable/reclaimable space elsewhere to satisfy the watermarks.
> 
> I've been working on making this more robust with the huge page
> allocator / defrag_mode stuff: instead of falling back and poisoning a
> block, invoke reclaim/compaction to produce a neutral block that can
> be converted entirely.
> 
> It's the same idea as the higher min_free_kbytes and watermark
> boosting, but it is more targeted at the end result: readily available
> space in compatible or convertible blocks.
> 
> But with that active regime, oversized pageblocks are even
> worse. You'd pay ongoing compaction work to produce a level of
> contiguity that you don't actually need.
> 
>>> Seems to me the excessive min_free_kbytes is just a symptom of a
>>> deeper problem.
>>
>> Yes, our anti-fragmentation mechanism does not work as we expected,
>> so that we need an excessive min_free_kbytes to get khugepaged working.
>> I wonder why reclaim cannot get the extra free memory instead of
>> reserving it via min_free_kbytes. Maybe we need a watermark boost
>> when some consecutive THP allocations are seen to achieve similar
>> effect of boosting min_free_kbytes?
> 
> I'm just wondering what the easiest way forward is to fix the ARM 64k
> page problem.
> 
> Yes, optimally, reclaim would work to satisfy compaction space by
> itself. We've seen it fail at that before, though.
> 
> How critical set_recommended_min_free_kbytes() is today is a question
> that neither of us has a clear answer to. It's from 2011 and a lot has
> changed. However, knowing Andrea, I'm willing to bet he added this
> based on seeing a need in testing data. And I would actually expect it
> to work better now with proactive compaction, since that has a better
> chance of turning low-order chunks of that volume into pageblocks that
> can be converted instead of needing a poisoning steal.
> 
> It's a change of long-standing behavior for everybody. It has a
> regression risk and requires careful evaluation and testing.
> 
> Meanwhile, adjusting the pageblock size on 64k page arm configs has a
> much smaller blast radius, appears to be the right move ANYWAY given
> what pageblocks are for, and makes the min_free_kbytes a non-issue.


