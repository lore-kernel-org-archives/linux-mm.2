Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E82FDC5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 01:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA2E6B0352; Wed, 12 Aug 2026 21:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AE66B0353; Wed, 12 Aug 2026 21:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949ED6B0354; Wed, 12 Aug 2026 21:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBC96B0352
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:09:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA55C804C0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:09:55 +0000 (UTC)
X-FDA: 85094464350.22.679B831
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id AB98BC0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:09:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Bcgyc8o5;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786583393;
	b=5uqu35q+EUp+Fw+DWmt05dz7AyiY3Ay62GjseGsoykX3KHYAS6gERwI/OKP3KXM0s2Poom
	FnILn2uK3qBAo+C2BaHrnm0uU81NvzocCCPs2BB4fz8sLaQpTRlbko3/EWF5mF0NPdVUrQ
	fuu3Ifi9qQTTBlhK+jqtrkjO6lFP2m0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Bcgyc8o5;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786583393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D08FG0YMubGacUihkTtMKOMY/B6yl/scK6bQ5SPlW8Y=;
	b=YOzmWvlO0fTdBbLRvWArtdnjc3M8gBSa7QfyRqySnidTlJ6tZIwFDjwnGR/jPsvpA5WaG9
	RqzCWBFh1LcE/H5jhXAga8t9Z4AYWxi5jJgi2nuHC5h5CueUJF0Y7BCLzya/LulRImcry2
	UdKBwnJnIwT7HvtVhXMeEYCP3ltXxgg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786583388; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=D08FG0YMubGacUihkTtMKOMY/B6yl/scK6bQ5SPlW8Y=;
	b=Bcgyc8o5PQNW4fgoOo0V590Wh1chfxI2/LkMIv7AhZ5oSZ1bPkIPCe5CFVP7LG8hYviIl8Ynn8A/j3EVBltc57E3RtMjha+xTb+W4eqjOLwqDixY6G6Glh6rjsETtwVfvuBVbS8yYIRcyHkP+FVUYNUtvxeosvBasDzIb0yFahI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8sfaKi_1786583386;
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8sfaKi_1786583386 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 13 Aug 2026 09:09:47 +0800
Message-ID: <37015686-6776-4e67-95ef-a26ac61a3b44@linux.alibaba.com>
Date: Thu, 13 Aug 2026 09:09:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mglru: Fix young counter undercount for large folios
To: Barry Song <baohua@kernel.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <20260812065933.103627-1-hui.zhu@linux.dev>
 <d18ed09c-52b7-40ac-95e8-c1530246e2af@linux.alibaba.com>
 <CAGsJ_4wE7E2G8H4ugwSWbQMF+5ecx+mrYQxXa1U6HY3utuQz0w@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4wE7E2G8H4ugwSWbQMF+5ecx+mrYQxXa1U6HY3utuQz0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB98BC0002
X-Stat-Signature: cp1izkqncpta74h5x76ud131j9kfebdf
X-HE-Tag: 1786583391-386977
X-HE-Meta: U2FsdGVkX1/O22+koCQGS/yiiyWDfgfmu0k5S5eKSgkFfjo1a0od20ioSCUEaq7VaAitWKUd3dB0mnOmOR798xzFV9o8Cs8CFOoShoHWVEXW5tteCjf3XLKr1ayEzGlW+wFnnN1xG9juHRv1ZQQyLlni5QeQYUw4c/wdSLC2ka884fr19NESUiOouwvBRBAJT+h7qAbr9plBSdTXaKsmFsgnxfyTlYQ777GzT2iz/GEXDv0An75F015UqjkU9cyKvXqKbe1jtFVSBfMPwA3aO61870ppApkWlDibUf+PO3XuOkOj9I2xVG0zhujU/wEFWe+uAtYymM6AMmgiH5cKQmk4RskRb0oKpyGrg/83kZkekQfsi+At0vMKK6R7EaN8B86tKEs8qIQCThjR7kbHOh5p+wKa1k1kdpQWKQS6joUZapmOBIYO3sc5fliqUjZu9HR6Ide9ioo6P7U78hpxWdW41IfRTlwToKVBFzV7sc50ABs3ktU4fr0fXWk3ab4gc2RrRFuu1D7ZodM35Yyle6CX/60e8ZXPijBLtifhqpzbEGMMDg3LezBP4zmbfp5FTwFyfoNIoCbjiEzRvleIo97BRH/o+jHJpKz1GyVjUWu3zX3AIQxJezmRWHqjO0HCd/rK/2jIOeGfeYYr3X0Z9OkkbryfTnasTUBYc9dvxOwQu3HGp2tt5w0MGe7W2mUGXL2fHsOM83y+ZPjZC5gyPV56s169TySEnIBdUdwngVKCxcO6mzDwrPU1XSVyJHrEiS74Y55hkVv1rjz6UDl4FYvRnIP/MpILM/HLFyGY14wXPSUtueCqIo+xkxVs4KyJKZ3C6HufHTwkeZSAPtJr4pz9vws8/ccHfHxINklkXk0IjmWcQzwEsH8xLYhkGUsp+l6z+t/tELb3wQD1GfKy19opRXKejElxtKg5xhQcLkq7LmrZb2Oj00wS1Z4K1tKRwWhmD4HoRTBDmKadl7Q
 4yC/vaIU
 zToKdONgoRWLKwO+DvszReYLjE6ncJ/Ie67cUwhaP/Jg/er+TsGLeT7AdTZ/U+5uJrYIGo6pXjk9KVZd6XcByUNVcQhDpuBHqQrKbRhdI2e7lz3yZ1lAPGl7uUzfp6HSPHQQ8YJ1Wixd/bDswTv+mH+fYYVaDHWskEtSlF2PcxZS41lOjpqC2EpWi9m1M0iKs/Yxkm8t5OBnMkKUEbaYZ9LzIa0YGVi7YaOYg+DXfT1r5fT+wXF3VO7gNxKN5gI2y2P29wA95kr/Tt8iFr7ap/OVnSj8Dme/dDP5InDT1kq6CpBzQr4LnVywxC4lI+1aE5UwLbeJV4aKHL0yN5s35nSDOT9HcjCq+uHRKzN6CBOmvDgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/13/26 8:53 AM, Barry Song wrote:
> On Wed, Aug 12, 2026 at 6:17 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 8/12/26 2:59 PM, Hui Zhu wrote:
>>> From: Hui Zhu <zhuhui@kylinos.cn>
>>>
>>> In lru_gen_look_around(), the young counter tracks the number of young
>>> PTEs.  The original folio's contribution is represented by the initial
>>> value of young: test_and_clear_young_ptes_notify() is called on it at
>>> function entry, and the function returns early if it is not young.  In
>>> the subsequent loop, the original folio is skipped (its accessed bits
>>> were already cleared), so it is not double-counted.
>>>
>>> However, young is initialized to 1 regardless of the folio size.  When
>>> the original folio is a large folio with nr PTEs, its young count is
>>> underestimated by nr - 1.  This inconsistency can cause
>>> suitable_to_scan() to return false, preventing the PMD from being added
>>> to the bloom filter and reducing aging accuracy for mTHP workloads.
>>>
>>> Initialize young to nr so the original folio is accounted the same way
>>> as other young folios in the loop (young += nr).
>>>
>>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>> ---
>>
>> Good catch. Please also add the Fixes tag:
>>
>> Fixes: 56e5b60b2114 ("mm: support batched checking of the young flag for
>> MGLRU")
>>
>> With that,
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Hi Baolin, Hui,
> 
> I am not convinced this is the correct patch. test_and_clear_young_ptes_notify()
> only indicates that there is at least one young PTE among the nr PTEs;
> it does not mean that all of the PTEs are young.
> 
> Am I missing something?

You are right. But I explained why this is done in my original commit 
56e5b60b2114:

"
Note that we also update the 'young' counter and 
'mm_stats[MM_LEAF_YOUNG]' counter with the batched count in the 
lru_gen_look_around() and walk_pte_range().  However, the batched 
operations may inflate these two counters, because in a large folio not 
all PTEs may have been accessed. (Additionally, tracking how many PTEs 
have been accessed within a large folio is not very meaningful, since 
the mm core actually tracks access/dirty on a per-folio basis, not per 
page).  The impact analysis is as follows:

1. The 'mm_stats[MM_LEAF_YOUNG]' counter has no functional impact and is 
mainly for debugging.

2. The 'young' counter is used to decide whether to place the current 
PMD entry into the bloom filters by suitable_to_scan() (so that next 
time we can check whether it has been accessed again), which may set the 
hash bit in the bloom filters for a PMD entry that hasn't seen much 
access.  However, bloom filters inherently allow some error, so this 
effect appears negligible.
"

Based on this, I think changing it to 'nr' is reasonable. For an 
accessed large folio, it's better to have the bloom filter rescan the 
PMD and keep it in memory instead of reclaiming it incorrectly.

> bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
>                  unsigned long addr, pte_t *ptep, unsigned int nr)
> {
>          ...
>          unsigned long end = addr + nr * PAGE_SIZE;
>          bool young = false;
> 
>          ptep = contpte_align_addr_ptep(&addr, &end, ptep, nr);
>          for (; addr != end; ptep++, addr += PAGE_SIZE)
>                  young |= __ptep_test_and_clear_young(vma, addr, ptep);
> 
>          return young;
> }
> EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
> 
>>
>>>    mm/vmscan.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index bc324e37c5f1..264017850a55 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -4192,7 +4192,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>>>        unsigned long end;
>>>        struct lru_gen_mm_walk *walk;
>>>        struct folio *last = NULL;
>>> -     int young = 1;
>>> +     int young = nr;
>>>        pte_t *pte = pvmw->pte;
>>>        unsigned long addr = pvmw->address;
>>>        struct vm_area_struct *vma = pvmw->vma;
>>
> 
> Thanks
> Barry


