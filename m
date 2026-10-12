Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C64C8CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8E36B0092; Mon, 12 Oct 2026 06:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB15A6B0096; Mon, 12 Oct 2026 06:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE526B0098; Mon, 12 Oct 2026 06:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79BC96B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:35:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E923160A96
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:35:05 +0000 (UTC)
X-FDA: 85313616570.28.A288436
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1214B180008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:35:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=icMAw4S7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791801303;
	b=CkOHEgjSOZxbloId8e1+tZYQBXD190kXxgj8DODAgTxV3KJ27K4iqjKB4JEs2tN0NELxEN
	UI/C73xDL7gBN+kNydQ7TgEPp8s6BsUiNFh4znOLCjindkwoiPeJWbLukPp8f0KEBJub43
	FbHGp6HwKdVJ4IHP9OLKaH4fI3v/zNY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=icMAw4S7;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791801303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6l70delbeHtJqbMpekvIGZfg1rRBNasfeeMNINA9mA=;
	b=l8sk+wpbsHITRiVJvm/PCDkZwZWGdB4srRGpVDI345/J58R4SoSKEBW4PZ3UsnVXkDkEec
	U974j+MMFRUAkujQF6hl6v511zgaSv04ZeAFJ32H28j/ikkQD9FGWpa38jIJNG37zcoV6g
	llIWzzDzeieEvZy35r7vb0Qs0cwc+To=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96C2E1655;
	Mon, 12 Oct 2026 03:34:58 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A9703F66F;
	Mon, 12 Oct 2026 03:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791801301; bh=7mPoOADKUkvYW5ZVuoA7QdKSncxImw2HU3nvjwRhcXM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=icMAw4S70hvgPizVJkQABJCxtd+gmFfyDPnnDMNKclV5o0WnmKAApqsQl/20ZNxXu
	 imeF/mYQKnQcQfc9BKxpsxnSyeJSk22sgaIY1E9MaXMTOZMS2XBG9wyWpehI3sHHEx
	 fg9p5DpQht1bU7Xw7QTSe0Ns0sjHKalma2s4QFtM=
Message-ID: <facd12d4-c1cb-4b9c-ac70-303581e43eb6@arm.com>
Date: Mon, 12 Oct 2026 16:04:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC NO CODE] [DISCUSSION] Anti-fragmenting ordered buddy
 allocator
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 riel@surriel.com, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, brendan.jackman@linux.dev,
 ziy@nvidia.com
References: <20261011215412.1181172-1-dev.jain@arm.com>
 <asyUgZVSauks3Vwd@pedro-suse.tail5790ac.ts.net>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <asyUgZVSauks3Vwd@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: he6nwd7q4ygqrcanpwboyf3yt51z7tiq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1214B180008
X-HE-Tag: 1791801302-709722
X-HE-Meta: U2FsdGVkX18FX8jzO2zc1CSjs7WbnPm6ZaxA7xLZpKoM2xaOq6rMfhZlBQIKo7hf7irkgljaRrmuOlxDahI4wWz17oLIBNh3ACyrUInVdirG2kNsWpgJSjoMqBvgqiFbUUpWwenzkdK8KQiU9tg9pIxe/sdbOCJozMgU7xvhZkhHjMghZeCaH8divyJiMtXfvTAYNZ2cG/mEXSy64l/JID34qyKSZK75ql1NB2/tXcMu5+SQGmP+yPmi0RrDu6xsMTxTiy8yL045wrvgpeNUfmR5YddLGrzW028uGnp2+7TQxdCFeWSpYjEc3Z00LgBEqdqiB4MJXDjNyZFsJXpbkIXnRG7cXFK5WT41MEF6ZQP6F2WFgQMxLKmO/tJBItRe20v7nlQCmxy4DV9KQI2wiQcWrsHLy/ubOWzBghipoDkBYs33jBu6e28s2WqnKzsBOALdQPlcAAS/HJyB4AwOEiLwKvLYDC+VUVKaXule+HOrfYHtsy4djY389LB8cx9NLUtwlTnv5a8Y8+61i7Zgvcst1RFP9RC9oMU4tM2g/QQrg0EqfoBh/53pqg98gvwEusOCDsA0hr8eYiigXX6KHnNw1U6oTKmagGzpSJFAC9r4M4MLMC+RhBlLB3PIi5A6G9KqH0LZDKCjZ4+ddTLZiFCAlFhdqYa4FDVjISpqGhnFE81g40Xt1hzhft7kF3IZ1uvs116LpFhC6IijOgTbHrMksbwoMDUy6bwTH4R3m4GQD/gH4ObY0arPh02+fJjGBgCnOx/pwMLoHq5lvdDMGZmgWo7boEjWdrB3p4yrxW4cI+hczc3eWzervWeyDecSXPWuWvsKgZPyB09hM3DyoiVtwDR3zvhJg2Ha7xqxViMHq0zlGVOi1MErKg6Cpv0pWj+F+tw12sw1r+0sGVrF/8Nb5GT4r7dUA6mQArwYfsYu80mAJvGsbCsA9+upcfZW51f61p4lpPEsYheCC1K
 5Uh7FzZO
 8WTxhe8xq69So9qT7XxisGKKBIENjIDTX3xWkLqQBOPQQLdhAUHnljH4pSzQ1qhZckw3pG3ZKCwbwIf92Un4sCGARt1SbDn/fnU+LBFbUEFKvLMJh8M3xzRHojwmJ9jcI7shuR51XDxyALePavORQ0QHrBwEOZk23H6ibYBUatQB9RRCWIBFsM/80YSjIJEU9s3dfgRTyAFZGdJRo2/xyTO0eta5w+7YAYVNGi8vN1iBNljk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/10/26 1:55 pm, Pedro Falcato wrote:
> Hi,
> 
> On Sun, Oct 11, 2026 at 09:54:11PM +0000, Dev Jain wrote:
>> (I am not posting code yet since it is in experimental stage.)
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
>> is *not* to claim that compaction does a bad job; I just took up the
>> challenge of anti-fragmentation (because I like to torture myself) and
>> kept digging the rabbit hole.
>>
>> There have been academic papers about replacing the buddy with bitmaps -
>> I did not want a hard NAK from upstream at any attempt to do that, so
>> I preserved the buddy freelists.
> 
> So, I've been looking at LLFree (one of those novel page allocators with
> no buddy and just a bitmap) lately. A few thoughts:

Hi Pedro,

Right, David H. had sent me that paper : )


> 
> LLFree basically divides memory into 2MB pageblocks (with a free pages
> counter), and then later organizes these pageblocks into 64MB "tree roots".
> These tree roots are then borrowed by each CPU and made local (pretty much
> like old SLUB used to do). This localizes most of your allocations and
> pretty much avoids conflicts/cross-talk across CPUs.
> 
> Yes, there is a bitmap. I don't think it's required, and it might actually
> be misguided. The paper itself has other side-goals. One of them is easy
> persistence in persistent DRAM; we don't need that. Another one is minimizing
> the cache footprint of the page allocator; this is misguided (IMO) because
> allocating pages has the side effect of you actually needing to initialize
> the struct pages after the fact; whether the allocator core hangs state off
> the struct page or not is not important, and in fact using struct page there
> might provide cache benefits.

Yeah I had skimmed over it and did not understand the cache benefit claim; the
main benefit seems to be the lockless design.

The critical section under zone->lock is extremely cache efficient right now
as, when it pops a page from the head, it touches 1) the list_head sentinel
of the list which is hot, 2) the page to be alloced whose fields are going
to get touched anyway, 3) the next page's prev pointer, so warming up this
page for the next allocation.


Right now we bounce on different cachelines once the lower order freelists get
empty. The current design is to first index by order, and then by migratetype.

I vibe coded to do the reverse and it does improve cache hits in general. But,
it has a collision with the free_area->nr_free which maintains total free blocks
per order (hence, summed across migratetypes). I'll see if I can send this
patch separately.

> 
> The bitmap does not work well for random order allocations.
> The paper itself was written on Linux 6.0, which (probably) relied quite a
> lot less on things like mTHP (and random-order file pages) than we do now.

Indeed.

> 
> In any case, this paper doesn't necessarily address your fragmentation
> problems, but it does attempt to address fragmentation (and SMP performance)
> through borrowing these pageblocks. I would not be surprised if it had
> a sizeable (positive) impact in fragmentation. I firmly believe that a
> direction similar to the buddy allocator, but with more buddy work pushed
> to the pcpu side (like Johannes's pcp buddy allocator series) is there right
> approach and could have a meaningful effect.

Exactly which I wrote in the other email : ) A cpu is the natural approximation
of tying lifetime together.


> 
> Of course, it doesn't solve other problems like lifetime mixing in allocations,
> and things like slab migration are insanely complicated to pull off.
>  
> 


