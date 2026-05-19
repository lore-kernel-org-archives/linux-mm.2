Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32908CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 23:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B06E6B0005; Tue, 19 May 2026 19:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 261876B0088; Tue, 19 May 2026 19:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E976B008A; Tue, 19 May 2026 19:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 058296B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:25:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C57E40C37
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:25:55 +0000 (UTC)
X-FDA: 84785754270.26.5C163FC
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf07.hostedemail.com (Postfix) with ESMTP id 38C354000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:25:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oBp3J+Q2;
	spf=pass (imf07.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779233153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YlOgClpXkeAqGbaQuJOr4v8l9JGbtUu2G0NG2GKshGY=;
	b=eaT0MR2Ja1OlgG98Rzk5eut1vj7i9GPrMF/2k02o+pIImQeiIDtnJelaQRgixZkdae5RK+
	2Nele0HI4Q1MsYUPtKBDbBDVZzJq4c9LH773FYmrPoC5ecw8KlwbQlOgO+lNGp3bt1BCJc
	yf5PY0kDGFMzTKiAWFsnudXjqrvZntQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779233153; a=rsa-sha256;
	cv=none;
	b=wM4ePpyOWKW84uN+L6enCQyCDT9E/X9/4HCpMPpKcx832dEAtm3slkEGOGvkQE5JkCZ2HW
	iuGB5+uUxgD/yRpvYZBH3Q5zQIoeuKiNXf8xNL8Y1+OhcnRvJTBByhhVoB294mtP0H6IWq
	583MIgxwAGM4oJ/G/rSahJXkH03ycF8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oBp3J+Q2;
	spf=pass (imf07.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <8e3586e2-1683-4db2-802d-2478293423aa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779233151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YlOgClpXkeAqGbaQuJOr4v8l9JGbtUu2G0NG2GKshGY=;
	b=oBp3J+Q2ZfWVrq2k5fOTHKRvAaWeFwxYjYHpbDdf3UOzFRx7vfm5Xrp59Jg6kCMYB90AO1
	Ueweaqyq51L29fNjCxCwAsFitMd37N5vGHEOndsp9OcMDRclRfQcGuJvjW7+TEw9FgVHTu
	MbB+hnQ8hwa8+Vhth4FPTKBGxq12cK8=
Date: Tue, 19 May 2026 16:25:45 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/page_alloc: skip high atomic reservation at or below
 costly order
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 usama.arif@linux.dev, kirill@shutemov.name, willy@infradead.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519012532.272770-1-jp.kobryn@linux.dev>
 <20260519122711.1afe69455bcaf22a0962dce8@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <20260519122711.1afe69455bcaf22a0962dce8@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38C354000A
X-Rspam-User: 
X-Stat-Signature: crgkwcj4jifcqczx7m3gpcn89s1nabds
X-HE-Tag: 1779233153-164731
X-HE-Meta: U2FsdGVkX1+PccpuiNNJSYxaq3rkSaX1iG+35umal9sgkQ0rok4IZgY1iY4dfLkqmRY7rc3aRN6npdwljwOrurLn0yL8ckAabEwam2St2IRbehvm/qzrxs06z71LLqPqP4YhWun4vzeypw7YXzup+k6d0OlondsWm4yv78o7PNtl3P/CDsCbw53XOczJJZhFIF3uQBampqH9qLk0EVTuvx6uUblcybvO8OaRLSK1JQttPYEZ1/DJXFj2cX5X6cP3w14Rca+sb8VliSmAHjJ5/rE0dXBgWSn1L8g7tqImi367rMtpIqUePY2ipn0BIVZW5bC7Y3VgxX+oq3zE+Kor5DMZKufzQU13qtODYP9td3ouKroL7d1llPax3ML2ucZQNcfqDW8rNlaUdO//JYJkK+76WxHLDjdv2M6bflGpjGRri1Zte1RRzZUSmVYBQssJyIZ3vBYJ7AEJP9dPA/hoIctbn08Lc8BOmV5cql8V2uGq8dP0LF8flC8Hj0XDB8Uh6FxeMlFhnYw6QLBc/EE7F9KjohrQUyrlcR0P0eW2JzSIW+3npNx/99i2Ul6TdXYijDNEh6bIQd4z7bju0W1e1FlqoEf82a9IwfgjouGn5AomFE7XaspdS7r+PaEfRwggeiAK3RIVxAV0rTfoRGNV7PiSpttIguRLeG71i6sCW3u6OX6pkYyImC9u5ay2W2o6XNNsLF54zo5XHPv63GxifBj58na5aMeTkrntqYCN+ZvFIsU84hdrMnsitDA4SjWSszpdOkDfDc8w0BrxGn1/cctwBwuyrDYGlMhcJVZCgD+RLc100/1ijT6Vw2LmXGoXund9R2glaEOzvwEaKQX/aWJ42ZuBnud3Lg9Xup01ymsGV1WXGWUuePb2GwuuXdryappSVEOqmxAW53tqGPuSF8G9bnj7smjceI4FdTXgvzizz3wjcvrVrtjIAEe82D0wszlv4tUeEpAsbVOpfAG
 hnhV+m5L
 TeePyVTOcXs4NYplMhc+oPb7CQY2tbyiQUi+VJyfgaL3MvrIslmMqRZT7j/JDB3+A6mPrlmPHYGHKxpkHb718Kbu/yLH4/Dj6N3XzuVp6UwhxvjP5NIhsss8G6bzqEtDhbA7Xk0HYIKAzY2ukgDly6ZTuiNA1hdTuV+xE+9J7CVB6KsGH/nAsm1dz0ljykX+POasbsP2dEFyWrT1+/y1PtKOh7z0KJDr3Hs/otmp8gV8E5nb/W23x80qTqAT9jt7vYFS3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 12:27 PM, Andrew Morton wrote:
> On Mon, 18 May 2026 18:25:32 -0700 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:
> 
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
>>    ...all order-9 blocks in HighAtomic
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
>>
>> Note that for this workload all atomic allocations were order 0-3
>> originating from the network stack, btrfs, and scheduler.
>>
>> ...
>>
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -3446,6 +3446,13 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
>>   	int mt;
>>   	unsigned long max_managed;
>>   
>> +	/*
>> +	 * Don't reserve a pageblock for lower orders.
>> +	 * Order 1-3 allocs should not capture a huge page size block.
>> +	 */
>> +	if (order <= PAGE_ALLOC_COSTLY_ORDER)
>> +		return;
>> +
>>   	/*
>>   	 * The number reserved as: minimum is 1 pageblock, maximum is
>>   	 * roughly 1% of a zone. But if 1% of a zone falls below a
> 
> Sashiko asked
> 
> : Does skipping the HighAtomic reservation for orders 1-3 break the
> : anti-fragmentation guarantees for these atomic allocations?

The data included in the changelog supports the claim that the reserve
does not provide a benefit at these orders. Even on fragmented systems,
orders 1-3 have plenty of pages available.

> :
> : The MIGRATE_HIGHATOMIC reserve protects high-order atomic allocations
> : from failing under fragmentation by taking ownership of the entire
> : pageblock.

In the experiments, there were no failures for orders 1-3 despite a
fragmented system and no reserved pageblocks for these orders.

> :
> : If order-1 through order-3 atomic allocations fall back to stealing
> : pages, but the pageblock remains in its original migratetype, won't
> : order-0 non-atomic allocations consume the remaining contiguous space?

With the patch, these pageblocks stay movable. So if fallback is needed,
moveable pages can still be taken. But the patch actually improves
compaction so contiguous space is increased overall.

> :
> : Under memory pressure, this could leave no contiguous blocks for atomic
> : allocations to steal.  Because these atomic allocations cannot trigger
> : direct reclaim or compaction, they might fail, potentially leading to
> : dropped packets or I/O errors in subsystems like the network stack or
> : BTRFS.

Reserved HighAtomic pageblocks are not currently treated as a precious
resource. Under real memory pressure, the kernel already gives them up -
the unreserve mechanism kicks in and converts the HighAtomic pageblocks
back to their original migrate type.

> :
> : Could background compaction or khugepaged be used to unreserve
> : HighAtomic blocks dynamically instead of disabling the reserve for
> : these orders?

This would call for extra scanning/overhead/stats. The patch reduces
reclaim, for example. A new scanner feels like going in the opposite
direction.


