Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354F7606A339
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 02:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=j4dFgkdZ
Received: by kanga.kvack.org (Postfix)
	id 216B96B00EF; Sun, 15 Nov 2026 21:01:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0A46B05B0; Sun, 15 Nov 2026 21:01:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6E16B05B1; Sun, 15 Nov 2026 21:01:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB3DE6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:01:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2718DA081C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:01:23 +0000 (UTC)
X-FDA: 85439330046.10.D9C9BEE
Received: from mta0.migadu.com (out-251.mta0.migadu.com [91.218.175.251])
	by imf06.hostedemail.com (Postfix) with ESMTP id 090BF180004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:01:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j4dFgkdZ;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.251 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794794481;
	b=hJ5DjEMd/TW6zjUpqhwvhI0QisDT6lgwnss1oNUPn0RIal8zeElVRn8sUJtagSzLMK+X8X
	XYhYt9ECz66OQ/1snKzzrvEpGkV8bfC1Tvb7lO9XzFjhC4xD+m+u63/qHQSavmT2N6Di58
	mw5OhcBpEe+5PcDHBGCD2JMsGBCSeyI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j4dFgkdZ;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.251 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794794481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oT6p9IiKU91ZvAcaQZmWvOZAnFk+N0TACpK4N2ej6Vk=;
	b=tWvHhHlT5V6oOj17oF+70KwnnzW9QxC3C5FaH3KkTbViI3kijhufWl7btjYRFzIFKSJ03j
	br/+2OLNC2uc9acCvbN/X5AHKTTiVbO4qiEcmrx5vn0jMVMpAsuzhZA6zghOVzBJj3TP5y
	glN6hbhDH1si+LAnxM5ogRIl03QDvok=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rrbl0nuDaW+pJdbFjfWrda5kId++kZCiqnbSpTRa/Zs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794794479; v=1; x=1795399279;
 b=j4dFgkdZfKiV8dYFY6aHoukrw1qGeJ5EV+SHf9HMY7e4In+tI2A4vru5HJT+hcO5kbHM+tod
 44d4AoVpzbK94NIpdYEz+mhNIjq6q0n6CCS4JMcC0nUVlCKMkF+/wjJxxFQv5sTAosP1J5NqfOk
 8oQQKrAHI2CKhi0yPKLvhLEQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5099c89ec1dbd413;
	Mon, 16 Nov 2026 02:01:19 +0000
X-Mizu-Trace-ID: 5099c89ec1dbd413
X-Migadu-Flow: FLOW_OUT
Message-ID: <bc6ffcff-3aaa-43da-91b4-82f27513c761@linux.dev>
Date: Mon, 16 Nov 2026 10:01:15 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] mm: hugetlb: fix CMA-related issues
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, muchun.song@linux.dev,
 akpm@linux-foundation.org, osalvador@suse.de, azpijr@gmail.com,
 lance.yang@linux.dev
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
 <b1c1c835-180a-49e2-86c0-bc3f65981728@kernel.org>
 <7e733c3b-2aa2-406e-a5ca-cd9a2c872f9f@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <7e733c3b-2aa2-406e-a5ca-cd9a2c872f9f@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9xcb4mqrpnk59rcwpg1zox45txux4aoe
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 090BF180004
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794794480-115316
X-HE-Meta: U2FsdGVkX1/9EOI59FSiGVdI1dPWCSLuvK8IyZ5ji2FC3dgi9ljsDR0qxaNWw1JGArTkClwMeFZl3/FozEJZmSGvDPMypjPR4hc/z18/NhC6YdoJhPktW4miq+WSfEOuKXIUjvF3ojkr+XUk+AZLPa1bN17ESkAAAZI0mSl5903vm95gXS0IBP/gpIqa73GUeyQjSxqWHTL62+TYHFDGeYcvvp688ehYk+lZ87Hk2vMEIWmM1tZd7meqaqCohlOqs/3D3bixGi+DD0NxgEkEfxJQkNObCJeKmswnR7f0arUWYtqsK9TcK77WmkN3aqplIRe58H9LtVY5c9XbWaLuVte3Wk3youD9LIbxYhWRrlRd6VNJltQXIJolI/YqXE2hP9xcK1uHW1yuT4ilQdFfBxhHQCYEXjuRvvQbeUnUKhoTL5yv7H8jRIQhUsFlJUAcrdPV+iCJ91sCvHSEQK0Pf3cS0Uz8m8flx0MaDka8tww3Xr3NwYzYZ96aat9WeHimtCnCyrYFIaBsgYpMou3oyUPI+CTVYL9wG27EgO0gPN0FFsjkTUHEd4HWQUaP0xqXh/giU2y7NC9y1rOzmRmnJPstpOD3puYjCaltM4QkXO/9Tuj8Mw3bow6mIWCGsMG9oOPPguy84PQiMPr9WMLQJa//xH4csH39FasMWBuuUc5XPmO3W1xBLHgCXA0qkNbVUxgOXr+51mtB87LJ4tmYiSa4kVEWQuev90mv02p2FPmBuZbtVyWNCnuZPLcBy3uTUe459WhjvO0uwr1u4drJsVHnlEoR5k/Qm9uPOLFbFYiYzlRe/3eq8Xmaw6u0l+WwDL+PIZQIpX7S1KO9HZKJoHknf2X7P11OCfAG5ZprpJ9Ed7XLV3J+U01SxdEtAQxZT0MyxbrQ8dAEWuyZm614MHmvpGmkdrfLVHnppWE4I6qwbcPsOZBbdMPdD3bkbSin7DVG7OQuZ1Y1OaK6xbl
 D60XuzPZ
 crWjoi+u89Y1V/dWSVznZ1eaEcK7BMWEcAXkGNBJiHpqRv37cg9tKLUJ6OSEy/FpLnmnCdQb2xXNoFK1xyyDyGjB/Apwh0oK5OSMJZ+2y4l7NTNRCIghE74383M6C6MTA/VSXKzw/LqzJ4QU5/EB7Zh2vaIj/o7pa0mHbwxfKfIcgzS44jtWrQLDmp0bkzoxFNIFe8i9of6+RDLDjC+m/FoWzjNowVy9EoOZdh1Dm4UNnLQPEg+3SL1cZDAR+euL4fim0xK9uqSpBaAgFr1dXG6Km8yQ2vsLWmbPhxYjjEtR1xOCLs8/3DBT2D8yjSwwnSJQrqyhxcuUqyoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 11:25 AM, Qi Zheng wrote:
> Hi David,
> 
> On 11/12/26 6:05 AM, David Hildenbrand (Arm) wrote:
>> On 11/7/26 11:30, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> Hi all,
>>>
>>> This series fixes three CMA-related issues in HugeTLB reservation,
>>> long-term pinning and allocation:
>>>
>>
>> Can I hand you over another CMA-related hugetlb problem?
>>
>> On arm64, we can end up allocating 1GiB and 32MiB hugetlb folios from the cma
>> region.
>>
>> Doing that dynamically is not a problem. Doing it during boot doesn't quite work.
>>
>> cma_reserve_early() does not handle any kind of alignment.
>>
>> So if you allocate a 32M folio followed by a 1G folio, the 1G folio will
>> suddenly start at offset 32M, not being naturally aligned in physical address space.
> 
> Yes.
> 
>>
>> Likely cma_reserve_early() must be taught to align (and maybe consume an order
>> instead of a size), similar to how the dynamic cma allocations work.
> 
> However, simply adding alignment would leave gaps that the
> current activation code cannot distinguish from actual reservations.
> 
> The early allocation path would become:
> 
> hugetlb_cma_alloc_bootmem()
>     -> cma_reserve_early()
>          pfn = ALIGN(cmr->early_pfn, nr_pages);
>          cmr->early_pfn = pfn + nr_pages;
>          cma->available_count -= nr_pages;
> 
> For a CMA range starting at 4 GiB, reserving 32 MiB followed by 1 GiB
> would produce:
> 
> 4 GiB       4 GiB + 32 MiB             5 GiB             6 GiB
> | 32 MiB used |------ 992 MiB gap ------| 1 GiB used       |
>                                                           ^
>                                                       early_pfn
> 
> Later, cma_activate_area() marks the entire prefix below early_pfn as
> allocated, including the gap:
> 
> count = early_pfn[r] - cmr->base_pfn;
> bitmap_count = cma_bitmap_pages_to_bits(cma, count);
> bitmap_set(cmr->bitmap, 0, bitmap_count);
> 
> It only initializes and frees pageblocks after that cursor:
> 
> for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
>        pfn += pageblock_nr_pages)
> 	init_cma_reserved_pageblock(pfn_to_page(pfn));
> 
> The gap therefore remains reserved and marked allocated. Releasing the
> two HugeTLB folios only clears their own ranges through
> cma_release_frozen(); neither release covers the gap. Those 992 MiB
> would be permanently lost from usable CMA capacity.
> 
> So we would also need to track the gaps, clear their bitmap bits during
> activation, and initialize them as free CMA pageblocks.
> 
>>
> 
> Another possibility would be to give 32 MiB pages their own pool,
> similar to the separate PMD-sized pool proposed in the other series. On
> arm64 with 4 KiB base pages, 2 MiB, 32 MiB and 1 GiB allocations would
> then use separate pools.
> 
> This could work during early boot too: hugetlb_cma_reserve() establishes
> the CMA areas and their ranges before hugetlb_bootmem_alloc() runs.
> Although the bitmaps are allocated later, each range already has its
> own early_pfn. With naturally aligned ranges and one allocation size
> per pool, the cursors would stay aligned without creating gaps.
> 
> What do you think?

Hi David, gentle ping.

I’d like to update to v5 so that I can continue advancing the support
for 2M hugetlb CMA. Regarding this issue, would you like me to include a
fix in v5? If you agree with the "split pool" approach, we can handle it
as part of the patch set for 2M hugetlb CMA support.

Thanks,
Qi

> 
> Thanks,
> Qi


