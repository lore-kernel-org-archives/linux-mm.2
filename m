Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A68B7CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960026B0095; Fri,  9 Oct 2026 16:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9107B6B0096; Fri,  9 Oct 2026 16:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FFAA6B0098; Fri,  9 Oct 2026 16:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58CFA6B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:55:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDD561C394B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:55:14 +0000 (UTC)
X-FDA: 85304292948.18.34C3CEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2040B100002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:55:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MyI9u/to";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791579313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Bvt+Xsa7sXVl1fng5tFEayRF5yMEOd/Tzvn8BVb9qI=;
	b=UEVXKZOrIdJ/lQ56XbGwpnQUCCw48+KCD81YPeadFtQJFKQVERRDPBw3w9d4ith4FrPYX+
	j8LqZwueS2soC62pZmBziBeFV3Qos/2Z8Hc4DtgPvA8nlyttGRot1eaKPIL7Wvhv6qq4/d
	aqE6Bbs5OwrOkHexAHRkZfYWoWmU3VM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MyI9u/to";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791579313;
	b=12OGfBGpzcv7HY834N4DFWjWpIf8K4i3lXMBXH/9BkZEOqI0B/oZSQZYcOm7EBkeyt2XcA
	ZPDi//C27fRxSxGI1twzk+ixV8Ix7vObhdQpFUt2nAldlJNJftYtF2WdA++I76R7KPEXRQ
	ioMAxmpy+SnryAKKwaTLfj3bnGfV0wY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03B3143C2C;
	Fri,  9 Oct 2026 20:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893391F000FF;
	Fri,  9 Oct 2026 20:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579311;
	bh=9Bvt+Xsa7sXVl1fng5tFEayRF5yMEOd/Tzvn8BVb9qI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MyI9u/to/xTOcMPWlUQbiGOT3v8o/iNOpYRWNH4gz7+sgcbhLJ947FpiF8oINFqwH
	 p/9Nd7nkxASalFk2NWrnH17gHaF/A+JVAAXBThFQZQDMbzRMqEVk3AfYq67TfSa2vV
	 WVPtLY+fDREnfFuJQsAiQBGXf4tWaQu5z7y6bcJTNg/nGjjlVv7f3LMDAFXuaOlvTD
	 l0J4iLDoFFE1Ar50jDUljIkEjZ3EOLkOjaV21XNDQwWenew+l5CtZs4xeV+ZgH3UJ/
	 3CEbRx9e87dzk0y/W4a7lua24GyPC/5+EMLiohjsazE0f53jKThEPmVAnKmV3agU+I
	 9SDkknHP/+QyA==
Message-ID: <df588805-6f97-4ef6-a64f-39222669bf3a@kernel.org>
Date: Fri, 9 Oct 2026 22:55:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] mm: pass alloc_flags through folio, filemap, and
 bulk allocators
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 willy@infradead.org, vbabka@kernel.org, brendan.jackman@linux.dev
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 kernel-team@meta.com, jack@suse.cz, akpm@linux-foundation.org,
 ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, surenb@google.com, mhocko@suse.com,
 hannes@cmpxchg.org
References: <20260923211041.3127588-1-gourry@gourry.net>
 <asdTptfeLkuypU8t@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <asdTptfeLkuypU8t@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 757598rdb5mgbohd8s5fdu53eyayifkh
X-Rspam-User: 
X-Rspamd-Queue-Id: 2040B100002
X-Rspamd-Server: rspam08
X-HE-Tag: 1791579313-264678
X-HE-Meta: U2FsdGVkX1/k3LV1mIrbniwZ4rRzQFtQvLV/PHU57WDLDi4BDq2qD+SpLVYYKTiaKsv0VpXNCulyXF3BY60poDyW9A6V2dsvyxmLFoL/BLXQt/pSDJM8f6SjzBb9mc4HWOBZYXDsLthISvF62kW/lTyyIW5f0swvcJeCC9Z5jDOVQmmOPJ2JzPEw8sgXV+e76qV3zMAKV/Wn46E3Tsas54WVhwmMP9uMQ+JvgRMp4hb+YUFH/e405MrqlAizx3sdtpLIlCKTxNPxz0XJUEUvDo3yd/GokCzEh+eFU+KFHYRzJX8KhUl3ZOYo6/1pDGxFLsnyfScwz+v2b2xlUWvdXYAHyVyVpvAVojl02Pt1B7Olkw9PeQkqpy7n3YWC7ATXJZ34IJBHz5w6oeeUTFKCgC2RMgSB368JMtmVa18Cz+wLaKH+WLBnjJDjAesMq7bV42OH8cC9AR6G8a+9uLV1aWUb1z5nO2PigrMDxPNMlxO3gzfrQHAiIvFuKL/q1+QYIuS/+WKhRzjHrWh+sXo4UXVyL+ezg7/us0z+j8Sn7DeIhy1g6/w7nelhbx9fLOhXjUp7aPPl1VUwnif3SP6ubGvb/hlMGy7QbZkVnV4E/HiUhQ7aGYVwsZmFsCaHxLj8Nf68dV86GvwVVpQNUwLDFrFy2OTHEdOfKReeuk8hgHUGXFMrbZhjkUBjoC2oMfKQyVfrdSxfjR6cFLH2aE7sWzLo0k+C/RC7qAWfYvsi7jqp0LlCWBQaTcXEMBUk9V5Wy3/f3jH6YjIpu5V36swvcJ4REZIiW9i1uPoNz9NXIflrKovMpg0uZ2v24XQtEWWZetrprKvvZ5T5Lwa774D3HtDziEsAlB1wISuwmlrGXvg5k1x43E225kclA49BLblsM5HrBM1hfLfwS/7w6tziLU+FPscuBFTd0B6UYZNa8BFXriWWU8RLQMHOqcstpaPmGXqofk1Xl1LQHpYXcru
 T+S40ldr
 3cvszMc9map5CPdnvdet4/SU9wu/2m529I3M5Lq6pD6Rq3sunPD0rGtlVDkOYOBKpolHGaTllaNGw9luJLrtzeQGCGaaAYkirxHM4iu80fStsjgeGg4hGB62huxAZjaKJoHTO9KugwAr7N+9WzvhClgcw5XEjhONbGlzQ4k3LSMaiQIF6ytzFDQkckgkfVAC6eYS7xCFw2dMW0kqMnzfv7TeX6V84udBKViQyXPijr0rK1+em3DKviXwYrzEb0kmAdop5ALRhAi/PWaMbSDsY+jiFfsUW+bk8bO1d6RluuYSGozsaICmic+1l44TK31fWcTT0apvJtbCTnsfbFLeqMwzSde2XI9FbgzG07xojTqMIlvdI232XerT1jsd4oLRvFMmn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/8/26 11:10, Gregory Price wrote:
> On Wed, Sep 23, 2026 at 05:10:34PM -0400, Gregory Price wrote:
>> This six-patch series first separates allocator behavior flags from
>> the bulk allocator fast-path flags and shares their validation and
>> preparation. It then passes alloc_flags through the MM-internal folio,
>> NUMA policy, filemap, and bulk helpers.
> 
> I had various discussions this week regarding ALLOC_ZONELIST_PRIVATE and
> ALLOC_UNMAPPED, and whether adding alloc_flags to the APIs is a good/bad
> idea and what the alternatives are.  I'd like to summarize the notes
> here and try to find a way forward.
> 
> recommendations that were made:
> 
> 1) re-use unused GFP flags
>    #define __GFP_X  __GFP_DMA
>    or simply delete/replace __GFP_DMA

If so, I think the latter,

> 
>    There presently are no truly unused GFP flags, though there may be
>    some users who can be shuffled around if we are willing to add
>    functions.

I once had patches to convert __GFP_SKIP_ZERO and __GFP_SKIP_KASAN to alloc
flags instead. Nobody outside core-mm should be setting these, ever.

> 
> 2) alias 2+ incompatible GFP flags to make a new one
>    #define GFP_A (__GFP_NORETRY | __GFP_RETRY_MAYFAIL)
>    #define GFP_B (__GFP_NORETRY | __GFP_NOFAIL)
>    #define GFP_C (__GFP_NOFAIL | __GFP_RETRY_MAYFAIL)
>    #define GFP_X (__GFP_DMA | __GFP_DMA32)
>    #define GFP_Y (__GFP_DMA | __GFP_HIGHMEM)
>    #define GFP_Z (__GFP_DMA32 | __GFP_HIGHMEM)
> 
>    These are all nonsensical combinations.
> 
>    Downside: We should probably just forbid these, otherwise the function
>    contract just ends up being confusing - i.e. (__GFP_DMA | __GFP_DMA32)
>    should just warn / return NULL.
> 

Not a fan of this.

> 
> 3) expose alloc_flags as mm-internal only flags (this series)
>    in addition - convert some GFP flags to ALLOC flags
> 
>    In 99% of callers they would simply add ALLOC_DEFAULT (0).
> 
>    The upside - it seems like there are 2-3 GFP flags that may be
>    good candidates for conversion to alloc flags:
>      __GFP_WRITE
>      __GFP_ZEROTAGS
>      __GFP_SKIP_ZERO

Yes, as mentioned above that was my plan.

> 
>    And the zone/zonelist selectors seem like candidates to free up GFP
>    flags by turning them into internal-only flags and giving drivers
>    some kind of explicit API, e.g.:
>      __GFP_DMA/__GFP_DMA32 -> dma_alloc(...) -> intenal ALLOC_DMA|32
> 
>    I considered whether __GFP_THISNODE should actually be broken up,
>    as it actually means two things (don't oom, use thisnode zonelist)
>    Something like:
>      ALLOC_NO_OOM
>      ALLOC_THISNODE_ZONELIST  (or keep __GFP_THISNODE)
> 
>    The downside is yet another flag interface in the page allocator.
>    Note: This is basically 1/2 way done, this series finishes it.

I do agree that two sets of flags is suboptimal, but likely more flexible. I
guess an alloc_flags only interface is not easily possible ...

I do wonder whether it should be:

	typedef int __bitwise alloc_flags_t;

instead of "unsigned int alloc_flags".

... while at it

-- 
Cheers,

David

