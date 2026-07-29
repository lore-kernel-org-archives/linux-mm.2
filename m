Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D5D3C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3203A6B00B9; Wed, 29 Jul 2026 10:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1606B00BA; Wed, 29 Jul 2026 10:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14A326B00BB; Wed, 29 Jul 2026 10:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E83FB6B00B9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:02:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C0DFC035A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:02:59 +0000 (UTC)
X-FDA: 85041980478.30.131561F
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 760E114000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:02:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JLh1AUcT;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjH7kA+VtExpLGxksUgfM9iOOpmaOblODtEnyss+CH0=;
	b=sj0gPXxIbpiOt/Q6yUYquFjvqjUdtI1CL2ZNDEb9N8MAFYRrnemGQkiLlJKcaSYZEHuLOv
	Z5bCUeOG1bnWlVa2HlKX8wPioD92tzOe8HhBVgWCr6g8jKBscRJ6M/xVW2GBIKpVsj+XwM
	0q163596PSvrMhneOepuYNoN2EOjH40=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333777;
	b=S/xAPqQZurvRwOCmHmJHx1zTInT+nZRulAM6LeM2UXF//38urHvOle9utE41UeCuqFrLJj
	kSm8aX/3NWjHnio1B8NyWhX5cFuGNT0HIf0DnvQc6oxzTquPd2ZtwlpwKFYlfBdX5xFo0x
	OFeimlBJrFcRiFjT0w41DZjYunn2qRM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JLh1AUcT;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <8863eb5b-df3d-47e9-8e15-140a1d0269bf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785333775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LjH7kA+VtExpLGxksUgfM9iOOpmaOblODtEnyss+CH0=;
	b=JLh1AUcTbIviy+qK6OCfahGE8G2o1cT/rauKPILFDyvKCEu55f4hdirm31E3x4Qv5eM8r7
	wHEarv2EGWyksXMDIz7n73vQfgPdPvYS6Qo/GnwXug0PqZ3oEhmcrD5Y2s+NGU2pQUqyUB
	VNqu+ND4Sjhs2L3wtIXwFJ3EGF+bVV8=
Date: Wed, 29 Jul 2026 15:02:37 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Cc: alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <77b3b74d-c1bb-461b-8076-8729cdcf91f5@linux.dev>
 <7d841b27-f60a-496f-81db-84158a0a8f8f@kernel.org>
 <0bdb81db-5e2f-47c9-998d-bca450644ba6@linux.dev>
Content-Language: en-US
In-Reply-To: <0bdb81db-5e2f-47c9-998d-bca450644ba6@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 760E114000B
X-Stat-Signature: rrk7du8p1sh1s67owxkunwyrfrpjnftg
X-Rspam-User: 
X-HE-Tag: 1785333777-774536
X-HE-Meta: U2FsdGVkX191405FFv8yqNVFhqYkdovyWbhINvjL9sgeOxilPHcHljuQvfP+fSzprwE/Dn2vTARDCut8RXiOV+lfmL5vYUF9uysxY1yWuureuDZj9QEnTlLlnrydKyMunAcvVv7mz2NY5MdlMfac174c194TGtJkqMbnfaVMYxIEP4Czn7GzP17ChtBjWUk7JwDAG76MaV+SWECpSBXgfX6a+DlOylyfv51ZDoOt2RVn/1hbFiOxEyC/JlEsOkxmxUjgxtbSGzK1b80h4vBnTyaX2M1wp6/OHO4I9mh2mh3ig+EbNFvH/9vvWn7ac5We53RvF3L/yQudATnoSHpnMYW8Uci7Nz5h3FFccGCd+Tm8FDjIyvliQF8NviR3y+7od555gtbrH5JQvfrq/qN13FZvIfeqDCiuLypDsVtKWtInlCDucruzqpzbBBqArJGPUn8Mb5y6SG18hf+xUOtwcAgx7fdjtYjfsb48UzDFdp+aLKiS66X93IGRJcOFta/1B9bcF3kyhKocdUQBANteB0bJ9p5W7HGdQVQJkAy13fnFotlbH5cPqnXXjl/fQJmwalnmiIkeORTj3J+8Kl7rGwpYsQV5+uutr9XZ/OFpvvcEzJqCfWJg91csvK7fsqA5mqC2UHwAnlNPhTLVCxvAvsfm4ENjs3cax8UHRCE4ZHUqC8y5hsq9h6PUuFjPv4n9XrBVpPnCg7Y9cL1XvAFbvLywljSywi9YRm4ABfhXFp1E1GA35I3+UNtS8nM2i+N5fGh9kmc6Km8NvaPPMMoXJzMYJOud4hFHwbKuTRzm1XHA+8hViYcjF/jlzNTQNu8YMRFxMImXsup8BnVaFeoTkCxl16H+aDGiBkpCvXbt8Jhb63CqSIL4ZRtz33Vy305i04mthpY2afpahXRT7quDaRseKErv4xkoVh03SmhQTY3B0Z22a7bjPj2ddeRPtyWPz6QQGwS9P0apk8loiYi
 SqP3X9a1
 9Hndm/25nJDgy9PFIYVuaBzH9FRBMh5+pt/l4pstec5ZmUDgBEtJn+oWAdN5nKZj4af/SbvCbQvh0BQO818hqKbl5iDtlpt3TBfOcBxeeBWkhj5lnlw8P+tZR5J/npvfFiM1tBsRfPmuYZ6gWWIIhhg13b1YkXdK38hIMZa+JAfKWLDJ/+4ykeAbPJBjC3MVJmI9wGmXwiSViOblaqQoKLBOWzOf7DKDKr6NmCnsfTKDmWWGn2bhbWVDLAo2d4y6tbrmP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/07/2026 14:43, Usama Arif wrote:
> 
> 
> On 29/07/2026 13:36, David Hildenbrand (Arm) wrote:
>> On 7/8/26 11:58, Usama Arif wrote:
>>>
>>>
>>> On 08/07/2026 08:56, David Hildenbrand (Arm) wrote:
>>>> On 7/7/26 22:17, Joanne Koong wrote:
>>>>> Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
>>>>> to the deferred split list at fault or collapse time. As a result, a
>>>>> fully mapped mTHP folio that is mostly zero-filled doesn't get split by
>>>>> the deferred split shrinker when the system is under memory pressure.
>>>>>
>>>>> Add anonymous mTHP folios to the deferred split list so that if there's
>>>>> memory pressure, a zero-filled mTHP can be split with its zero pages
>>>>> remapped to the shared zero page and then reclaimed.
>>>>>
>>>>> To minimize overhead on the common order-0 fault path, the
>>>>> deferred_split_folio() call is guarded by an inline folio_test_large()
>>>>> check.
>>>>>
>>>>> Suggested-by: Usama Arif <usama.arif@linux.dev>
>>>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>>>> ---
>>>>>  mm/memory.c | 2 ++
>>>>>  1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/mm/memory.c b/mm/memory.c
>>>>> index 6637c5b13c9b..441d918e3dc0 100644
>>>>> --- a/mm/memory.c
>>>>> +++ b/mm/memory.c
>>>>> @@ -5259,6 +5259,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>>>>>  	folio_add_lru_vma(folio, vma);
>>>>>  	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>>>>>  	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
>>>>> +	if (folio_test_large(folio))
>>>>> +		deferred_split_folio(folio, false);
>>>>>  }
>>>>>  
>>>>>  static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
>>>>
>>>> I had a session [1] at LSF/MM about having essentially all large anon folios
>>>> part of the the deferred split queue.
>>>>
>>>> (1) I don't think this scales.
>>>>
>>>
>>> What if we only add the mTHPs for which the policy is set to always.
>>
>> That doesn't really help lock contention. And the lock contention is indeed a
>> thing, as we now also want to enable the LRU cache for smaller large folios,
>> which improves performance:
>>
>> https://lore.kernel.org/r/20260709081536.82768-1-baohua@kernel.org
>>
>>>
>>> I think it doesn't scale if someone sets all orders to always, but if you only
>>> set the 2M mTHP sysfs to always, it should be the same as what we have today
>>> for PMD order?
>>
>> I don't see a problem with large large folios, only with small large folios :)
>>
>>>
>>> The main motivation for this series is to try and bring the performance for
>>> ARM on par with x86. One of the differences is TLB misses. I imagine the lower
>>> churn in kernel by using larger page sizes will help as well. But we will
>>> run into OOMs without the shrinker.
>>
>> Can you elaborate how this change helps here? I assume you want to enable mTHP
>> in production. Which sizes? large large ones? :)
>>
> 
> One of the differences in our production between x86 and ARM hosts which we think
> should perform at a similar level (but currently aren't) is TLB misses.
> 
> On x86, we have 2M THP set to always.
> On ARM, we have base page size of 64K. 2M mTHPs should help bridge the gap due to
> TLB coalescing. We can't really set 2M mTHP to always as without the mTHP shrinker
> we will end up with severe memory pressure and a significant increase in OOMs.
> 
> We don't plan to enable other mTHP sizes on ARM, only 2M.
> 
> The series by Barry is for folios above costly order, so won't impact this.

s/above/below/
> 
> David, Joanne, Johannes: what do you think about only adding folios that are larger
> than COSTLY_ORDER to deferred split list?


