Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD03CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2546B0098; Mon, 12 Oct 2026 06:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA34C6B0099; Mon, 12 Oct 2026 06:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9B06B009B; Mon, 12 Oct 2026 06:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93B376B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:11:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08B4B160AA3
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:11:00 +0000 (UTC)
X-FDA: 85313555880.15.9FA334C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id E2049160007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:10:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DvXiZiA7;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791799858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ul9wcWmxhs7gK/jxe5ZorrUQLrKV/w+O1oYAR807APo=;
	b=ozoV4m3slMip0zQvGKp8xwmqeDrAUkkvAvjbmK6d8aDsVTyCHYnZpt1VT1bjHsfLdKS6S3
	k8K4wO+p5k/brGOqE02HcVYzDfczTjVmcEnjo8TMwqrNV5bmppP3SdGezZLwodwXJZgU13
	9oJ/vDvxB4WFk65gw4bHfD5wXMlTkZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791799858;
	b=IlBoSq3YcRGDiT1hRUIHLWCe1ZsArUpu3Ickoqrz0vtlEwwUk7dOYihEAOprvzo3d1fZnZ
	md5yGDCKZ9HvWVQ6WJHLEjryMhty36E7PoxbpCtP2oe5iYTNwOVG/9TpzFTOIz4vONfKD8
	ivYC5mQryTerqtiPYu2at7plFW4MVg4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DvXiZiA7;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BEAC1655;
	Mon, 12 Oct 2026 03:10:53 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 463C73F66F;
	Mon, 12 Oct 2026 03:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791799856; bh=4s/xDJjI5Yi3Iie/JSApNyADbuBLred0RCuvDLjnYQ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DvXiZiA7IANGTjiIi3p929DkASucYMvkwq4IfgM2nN09ccEJXPslThneXVPDOLdo+
	 Fvky6tsgCxSGCOyHjUj+OX8BvZsv7PcLNfYpogG+I1XrsoWl7HgnS18Vet/UhguEU/
	 2AGsP8zLuClFigtTBv3WG4aRyLDjfzKeXUKaLwTw=
Message-ID: <89700b93-e646-4263-bca3-a2df7636f6bc@arm.com>
Date: Mon, 12 Oct 2026 15:40:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC NO CODE] [DISCUSSION] Anti-fragmenting ordered buddy
 allocator
To: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, ryan.roberts@arm.com, riel@surriel.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, brendan.jackman@linux.dev
References: <20261011215412.1181172-1-dev.jain@arm.com>
 <DM2DV199T6N4.19MU82DJBDOF9@nvidia.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <DM2DV199T6N4.19MU82DJBDOF9@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E2049160007
X-Rspam-User: 
X-Stat-Signature: g4ceryy3sswiae6nb9axkzdxbaukzuwz
X-HE-Tag: 1791799857-993124
X-HE-Meta: U2FsdGVkX1/lrJgmTAugT/g/LHXpss6JU10WXc4qA7d1h6E60yNm/J2SgQvWrpzhXQ8lZkLRZ/po/rtLa43O7u/me9QOl95cNGVcz2Ih7YovNjshCG9/aEbzU+lMSkPwGz187Bp6pfmqu2dP6qOedFxZiwpM94/FPheqmRsK1EQNc046F7K00Z2Ug9EiEdqiLkM5AxEdZBWjqRAU5QievVavSZC/9uNeXP4BSGlqfaPd+08wdjo8VfgybHobvAeUVvG8K+H7uPVw6x3QveWyDIUrY/vmoAfq1FUpyowOz5Kl5ltzqHBBK02uSiN8+KHuWD1vS0D/D3OzM0/4GyFRccowlLqihJrO+gMUXXJaZnvGtVw5MRUNerJfNocyB1cX8WXkMVqWfkY1gH5cTj69NdIxBzBXH+nsTI/8IY9hTGK5mii7gnt/l8eR6+pk1uBxDu6ZbLuTrdQ/dptnwGIbmxBu4YHTSY6MffmsMret9bGLvVK3YY18U79SxV42DysjO6vedatzT58GlkhxHyQk0j7oa5QfZ99N/MAxx4q6on6QBjSVUNtO4eNvpM87XJFWFYLTKIlOPvs7KOP/wkFjnVPVMCoRR1cjzAAoTEhzkcDh2OlZ/2uJdldIWCmF5u6u59jey+OvohQn4C5awsZ0qUVAqm7LY2gDN47fGpgC5FZhbh72dhMNc+Eu3N+5keWqAzJTJ1PHzr3LfXbxnVf1mlGsquVTTVkIpmA8mglRjlvT1Tdn04ZoQzmW6homEXyq4cuaLROFCpXQ48e0wToF9o5bo/Rag8n8hOdtvytwXMU1uo/jypN/r/6ivL6Ksdy4niZkgs2+Cl4Oeiur/vQPBLrGAAv9ifn+xogcRU+wUlX9cLH6LwB1J57p0ECvr82fsHe+qccUSu4xjoTFDtY3597kzvIG6MstbigUQFSfXRcDrLcKeOzYVhUtrDIgKeexUhiZfg9KM5XNqRM9DXQ
 3wba3+VY
 BT+kWa5my/L2MY+pQXbVQl8dsWtGqzvpSX2YMozEzQGdMnem7Rg7Ro+KQpNHLsiHwDuKFtpDUlkas2BGNx3YGp0eIZtx8dCHa7tYYTW5Xvfe47NzsJyydanJR+Gnkx/I2BPChCvEAVbrrOiPzMQ16w5x/+3lAQVF1vRqQUTEWcIgDHd5skUfEKyCbx5668LqJYezZcSnzjA/dIaHYyo15cwcg9SZ9bJp0BA8DaHgKwThuMbR6AWBPdt3a+p2sNT1fwyoOuIwzlPuITJtHP/ziSbBIiRSr1nO8wRCJxYy6LBbBlhS002NXR6oJGW/CjIYXJ7SXhcoLlknnq+mYLpDzfqt5Siiu78sh/19iamfnXi9l1l93RnvioqKndBvTkadotJNS+So4UTAmUsXuOe38rEa9ayd3aytnzJUSjwQZlCMpyVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/10/26 4:34 am, Zi Yan wrote:
> On Sun Oct 11, 2026 at 5:54 PM EDT, Dev Jain wrote:
>> (I am not posting code yet since it is in experimental stage.)
> 
> Thank you for posting the idea.

Thanks for replying Zi.


>>
>> TL;DR
>> -------
>>
>> I am proposing "ordered/bucketed buddy allocator": we divide the buddy
>> freelists into buckets, and prefer lower buckets for allocation.
>> This reduces external fragmentation (and, further reduces it when we
>> reverse the ordering for unmovable and reclaimable allocations) at the
>> cost of regressing the alloc and free paths, which depends on how many
>> buckets you partition into. I think we can partition into 4 buckets and
>> do some tricks to remove any regression.
>>
>> Design 1 is the simplest and the most upstream-friendly method in terms of
>> allocator speed. Design 2 tries to scale better with the number of buckets.
>>
>> INTRODUCTION
>> -------------
>>
>> Apart from dividing the freelists between migratetypes, little attempt
>> has been made to change the algorithm of the buddy itself to reduce
>> external fragmentation proactively (termed as "anti-fragmentation" in
>> academia). Linux has defragmentation (compaction). The analysis below
> 
> Like Rik suggested, it is better to focus on one thing at a time. I
> think improving anti-fragmentation at pageblock level is high priority
> at the moment.

The premise I started with was to improve chance of mTHP allocations; I would
like to point out the benefit of ordering.

I was first looking at the problem from the perspective of finding already
populated blocks to allocate, within the same migratetype (an implication
of trying to do that was, reverse the order for non-movable, which is not
the premise I started with).

If we bias allocations towards the left, we give more chance for pages at
the right to get freed and make contiguous free blocks. So maintaining an
ordering is a good approximation for biasing w.r.t fragmentation score.
This delays compaction triggers, and even if compaction is triggered it may
exploit some sort of ordering - it knows that sparse blocks are to the right
with good probability.

Essentially we are trying to do a bucket-sort here.

Think of the allocation stream as a *probability distribution* -
I am trying to skew that to one direction.


> 
>> is *not* to claim that compaction does a bad job; I just took up the
>> challenge of anti-fragmentation (because I like to torture myself) and
>> kept digging the rabbit hole.
>>
>> There have been academic papers about replacing the buddy with bitmaps -
>> I did not want a hard NAK from upstream at any attempt to do that, so
>> I preserved the buddy freelists.
>>
>> IDEA
>> ----
>>
>> There is a correlation between allocating from one side of memory, and
>> reducing external fragmentation. Biasing on one side implies the
>> probability we fragment already fragmented sections is high. This may also
>> enable smarter compaction by directing the free-page scanner toward
>> higher-address regions. This also circumvents the discussion around
>> a "fragmentation score" which is dependent on the size of the
>> block we are considering.
>>
>> The idea itself quite obviously improves clustering of allocations: I
>> observe reductions in 'compact_stall' and 'anon_fault_fallback', and some
>> large improvements when the number of buckets is high (like, compact_stall
>> going down from 4000 to 5 with almost no hit in execution time for a kernel
>> compilation). The obvious downside being slowing down the allocator (which
>> needs to be tested more widely). The content below is mainly on how
>> to minimize that.
> 
> I am not sure how your bucket idea is better than the existing pageblock
> design, because the biggest issue in anti-fragmentation is unmovable
> pages spreading across the entire physical memory space to prevent high
> order page allocation and I do not see how your idea could contaminate
> unmovable pages.

To make it clearer, I have observed improvement even without clustering
movable and non-movable to opposite ends, and simply clustering *all* allocations
to the left.

Note that all of the pageblock claim/steal algorithm of the buddy
remains the same - an unmovable allocation will still try to take the
largest order block free in movable buddy lists and try to claim it
instead of stealing, so the existing algorithm works. So we first
cluster by migratetype, then cluster by pfn bucket.




> 
> Unmovable pages can sometimes take majority of the memory of a system,
> leaving the entire memory space fragmented, for example a burst of
> dentry allocation. Roman wrote a small userspace app to do this [1], and
> you can give it a try. Afterwards, some of these unmovable pages might
> be freed after their use, but there is no guarantee that the freed
> unmovable pages can create contiguous free pages. Unless we do unmovable
> page lifetime prediction and group unmovable pages with similar lifetime
> like Yu Zhao proposed[2].

Thanks for mentioning [1] and [2].

You are right regarding [2]: I had also concluded that the most correct
way of looking at external fragmentation is lifetime prediction. I had
written a reply to Johannes' PCPbuddy patchset (my intuition says it
will also improve on fragmentation):

So basically we need to give contiguous pages to an "allocator context". The
allocator context examples are a file filling its pagecache, a slab filling
slab pages, a VMA faulting in memory, etc.

Currently a file does readahead to ask for contiguous memory which is good,
but it would have been great if we could reserve a pageblock worth of memory
and keep fragmenting it for the same file, tying allocations together.

Perhaps we can think for the file case specifically since pagecache has
been observed as a huge bottleneck for fragmentation: after reclaim,
the pages freed are scattered. And, they may immediately be taken again
by pagecache allocations.

(One way is, at least for filesystems not supporting large folios, we
can still do high-order (non-compound) allocations, the order
dictated by the write()/read() syscall, or the readahead ra->order.)

Then, the next programmatic approximation (losing accuracy) of
the "allocator context" is a task_struct. A task_struct reserves
a pageblock and allocates from it.

If you think about it, there is a correlation between allocator-context
and task_struct, since at a time the task is doing similar things in
a time frame, be it userspace allocation or even kernel allocations
triggered from userspace.

Then the next and more natural approximation (losing more accuracy)
is of a cpu. The cpu reserves a pageblock, and we hope that the
cpu is continuously used by the same allocator context for enough
time before migration.


> 
> IMHO, pageblock is already acting like bucket, limiting allocation
> range. I see each pageblock a small bucket for allocations and it is
> better than growing allocation from one end to the other end, because
> the latter means unmovable allocation can keep pushing the boundary and
> the boundary might be able to move back if there is a long live
> unmovable page sitting at the boundary.

I think what you are trying to say is that a long-term unmovable allocation
at the boundary will pin the boundary. But that is fine. That boundary is
not a hard limit (I am not claiming a bucket for a certain type of allocation),
the point of bucketing is to skew the probability distribution
(allocation distribution) to one side.

Codewise, the loop looks like

migratetype = gfp_migratetype(gfp);
choose zone->free_area[migratetype]

In that, choose the least bucket:
zone->free_area[migratetype][bucket]

Which has list_head[NR_PAGE_ORDERS].
> 
> At the moment, anti-fragmentation is only preventing mixing
> movable and unmovable pages in a pageblock. Rik's series[3] is doing
> additional work to keep unmovable page allocation within a unmovable
> pageblock, further reducing fragmentation. That is probably what we want
> to get in first.

Indeed, agreed that the bigger problem is pageblock mixing.


> 
> Maybe you can compare your idea with Rik's series and tell us the pros
> and cons of both. :)
> 
> 
> [1] https://github.com/rgushchin/fragm
> [2] https://lpc.events/event/18/contributions/1779/
> [3] https://lore.kernel.org/all/20261007021250.1665929-1-riel@surriel.com/
> 
> 


