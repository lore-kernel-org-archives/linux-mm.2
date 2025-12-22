Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421ACE674AA
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 13:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9458E6B0088; Mon, 22 Dec 2025 08:03:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3046B0089; Mon, 22 Dec 2025 08:03:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CADB6B008A; Mon, 22 Dec 2025 08:03:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACBE6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:03:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF08B13552A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:03:47 +0000 (UTC)
X-FDA: 84247124094.17.A889D9C
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf09.hostedemail.com (Postfix) with ESMTP id 53559140026
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:03:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1eEDp7Tp;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766408625; a=rsa-sha256;
	cv=none;
	b=jeclrn6/J16DyxFG/esKwNQNBWvNVnyUEJIX7tcOqMh0PYeoqWtNG3OzYcLJojKyp0optL
	qcYObHwD87Qpp4ZolvnOnZcIpdiUWVS5mOuMcJ+337kUfg/+LBxzOR/2ZERnc/QJzgaWwH
	RlGe8GtYwKrVCfZ6dyew6hAfGr9w+gE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1eEDp7Tp;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766408625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUT7cuLxrk0NyHCwQdOG74hUQUopTzurGyqodkxPKfI=;
	b=MhzSERJBbD7NzIgM6PxJVmhdpDG9vbOIEtjoRXTbSqCha0eHW3ijBsRHpeBJE9HN581Oj7
	FT9OuGj9qOil7+eJq9/xB2s+DqggzdLUrRINq22uAdHC5/VOrNj7tuuiqwzJ071zlTDNzo
	LnBDoDvM/0LwiG5I9W9xDjvzYDn1PqA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RUT7cuLxrk0NyHCwQdOG74hUQUopTzurGyqodkxPKfI=;
	b=1eEDp7TphmOf+WGZ+96M+u4M24uEa7x7xvmsiud528Zlhjbs1xuqffDCZWMbMqA1IUeZTSsHf
	5qHV5RH8Xyo6nKeILyFogTh7kXvUryXaY4GJiqby7kGqfzL7SIx/WWMhIKWsKyj9A9K7yUh5SjU
	k3uOgXqITJkcRg44vE98sa0=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dZdXr4Kg1zRhRm;
	Mon, 22 Dec 2025 21:00:28 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C4F05201E8;
	Mon, 22 Dec 2025 21:03:34 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 21:03:33 +0800
Message-ID: <9e3643fe-1744-47a2-9ab3-714ab9f29dd0@huawei.com>
Date: Mon, 22 Dec 2025 21:03:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>,
	<jane.chu@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
 <4B10600F-A837-4FCA-808D-6F8637B073F7@nvidia.com>
 <0eb081b8-3982-48aa-a9ba-9cdde702b4df@huawei.com>
 <A276ED1B-89C8-45A0-8DA9-9D5CA1D8E2FF@nvidia.com>
 <6e7df7a8-aaf4-4960-82be-dea118c5955c@huawei.com>
 <0168824D-37E8-4E22-AAF5-43DDB38F0FED@nvidia.com>
 <3627fca8-4133-40b5-9883-5163dcbc91aa@huawei.com>
 <FB368603-C871-48A4-951D-B8B605DC4583@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <FB368603-C871-48A4-951D-B8B605DC4583@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 53559140026
X-Rspamd-Server: rspam10
X-Stat-Signature: jeqfjaoxuo7auba3om6hb8ptxnh9r5fa
X-HE-Tag: 1766408623-624035
X-HE-Meta: U2FsdGVkX1/6lt7us9hA0YsKHEONLIUzWkXIB4IHCqaCJcWE5BiuQsX9gJ0xYn14+hQJYFVLAlPJrohstP5JGWs3ioxHtLFyhP12Fzw68NUv2+xciUuKzymltDY6vcF6DI9w7amyOmBmaPtVIHX5+AWp3VNXXX8OA3aoS6bRbQ0VFWnXmUkpsRh/FrRLz15zdwQR4xC1+ZiFLOTXLxEyvfXpIbD13Wh+Cm3lqNAHMqkr2wy/907AxOITPlHwCqC+mVD59DrdwRmZ9TK1xGpfR1A7hPj33UmhKTMq814B/czDD58r+RrxeBfJ/iU1/ibXsmESS2aodOJOtLC/6w6V0WhDNtXW4XW/dBntAEve+9w0cLt0cu9XOB9meYXwmS7SCrjmz2SIMU6Q74W0FMx8QvMZCo2+NXKUpOo4sb6zQ00IiaMzVqKWIAcpGdexLMOst5cYL1YOVjbJKRubgKHDeT0LFGxyXKEUDA/xM6hD1QhXDKBow19EgpBQXuJsApE2YA2/MVyHm0GHN6e4ouBbbhR4go844IVo7fvSLwlnNttcFUAIoO45trshBr9dOiinLCeD4e+3+/SxNDQUM2oNOfggqeDyWkf24l8coTKUvIAKqYj8rFrzbAwT+mYeRA3Idg1g9hPeOP+eeKkM0NB3CthdJKKyGnJhTHcjF+8go0m40lx7OrCoDoLJ4IwOPSKX4s5kCwMF1yashB4FlRtBXG3okXlla8+ygykeGGYsbVETmz00WqjIoKC2KBTl2jTmdupMoMnixkgHVtlbsTohiZl06+L2aHICCZ1ytpF69mO6uyvK9RzQEb04gxK5mQDLFUqdmthMByPgVwR2mCn2ae8Po6eaDeWjqhHP7pnvRSMLvafseGi8VR+lRsef4m+JaYEEPkkU1MMoDrIvY/C7iXp0g9RM2SO0vCnWpmYMTRmuCMYRoXrNFxmSwuBffN0VAS6ailO29tCkLKJDDdF
 uAoZSX+j
 vIQGCc3ywpOHlXeKKXYItWv+Yqj6o028WRXCjqJzxuI9nyjiJW9sbfq7gY9BrzGv+VakqjTz0hJHcKxrUAHJV+srVhuTJxnHHld+jd0K4K3kkBTW8mGU4OO7kegKSR0T/OflaK2A0W3me0Yu+XjPzrbuAA6ZdzJorEX4A0wN5DbiDyQOVCnVAkGksbahCuyZHX8zFNm1EVYndB1IMk7w3xPLX63gfsNIIQQAkIEHLMoggjiZHdLcrzjeCGXdr/lfeUf7hrLnziXVrhOHSNtiDqZU35Z56fciTzDXMcS29okDZ3j6hfBuc4aISwMBMdpGozEQnnd7CVKAYyOcB5/RbUosC1XRPzz0em5CyKNlu4Quo+NjvM5+VX4GJG31ouB9sA4sRRB2+fyBWIHUVqhymchpJTfXNyUOE98v8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/22 10:30, Zi Yan wrote:
> On 18 Dec 2025, at 23:09, Kefeng Wang wrote:
> 
>> On 2025/12/18 23:52, Zi Yan wrote:
>>> On 18 Dec 2025, at 7:54, Kefeng Wang wrote:
>>>
>>>> On 2025/12/18 3:38, Zi Yan wrote:
>>>>> On 17 Dec 2025, at 3:02, Kefeng Wang wrote:
>>>>>
>>>>>> On 2025/12/17 2:40, Zi Yan wrote:
>>>>>>> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
>>>>>>>
>>>>>>>> Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
>>>>>>>> incrementing their refcount, then convert hugetlb cma to use the
>>>>>>>> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
>>>>>>>> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
>>>>>>>> into mm/internal.h since no outside user.
>>>>>>>>
>>>>>>>> The set_pages_refcounted() is only called to set non-compound pages
>>>>>>>> after above changes, so remove the processing about PageHead.
>>>>>>>>
>>>>>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>> ---
>>>>>>>>      include/linux/cma.h | 26 ++++++------------------
>>>>>>>>      mm/cma.c            | 48 +++++++++++++++++++++++++--------------------
>>>>>>>>      mm/hugetlb_cma.c    | 24 +++++++++++++----------
>>>>>>>>      mm/internal.h       | 10 +++++-----
>>>>>>>>      4 files changed, 52 insertions(+), 56 deletions(-)
>>>>>>>>
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>>>      static bool __cma_release(struct cma *cma, const struct page *pages,
>>>>>>>> -			  unsigned long count, bool compound)
>>>>>>>> +			  unsigned long count, bool frozen)
>>>>>>>>      {
>>>>>>>>      	unsigned long pfn, end;
>>>>>>>>      	int r;
>>>>>>>> @@ -974,8 +982,8 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
>>>>>>>>      		return false;
>>>>>>>>      	}
>>>>>>>>
>>>>>>>> -	if (compound)
>>>>>>>> -		__free_pages((struct page *)pages, compound_order(pages));
>>>>>>>> +	if (frozen)
>>>>>>>> +		free_contig_frozen_range(pfn, count);
>>>>>>>>      	else
>>>>>>>>      		free_contig_range(pfn, count);
>>>>>>>
>>>>>>> Can we get rid of free_contig_range() branch by making cma_release() put
>>>>>>> each page’s refcount? Then, __cma_relase() becomes cma_release_frozen()
>>>>>>> and the release pattern matches allocation pattern:
>>>>>>> 1. cma_alloc() calls cma_alloc_frozen() and manipulates page refcount.
>>>>>>> 2. cma_release() manipulates page refcount and calls cma_release_frozen().
>>>>>>>
>>>>>>
>>>>>> Have considered similar things before, but we need manipulates page
>>>>>> refcount only find the correct cma memrange from cma/pages, it seems
>>>>>> that no big improvement, any more comments?
>>>>>>
>>>>>> 1) for cma_release:
>>>>>>       a. cma find memrange
>>>>>>       b. manipulates page refcount when cmr found
>>>>>>       c. free page and release cma resource
>>>>>> 2) for cma_release_frozen
>>>>>>       a. cma find memrange
>>>>>>       b. free page and release cma resource whne cmr found
>>>>>
>>>>> Right, I think it makes code simpler.
>>>>>
>>>>> Basically add a helper function:
>>>>> struct cma_memrange* find_cma_memrange(struct cma *cma,
>>>>> 		const struct page *pages, unsigned long count);
>>>>>
>>>>> Then
>>>>>
>>>>> __cma_release_frozen()
>>>>> {
>>>>> 	free_contig_frozen_range(pfn, count);
>>>>> 	cma_clear_bitmap(cma, cmr, pfn, count);
>>>>> 	cma_sysfs_account_release_pages(cma, count);
>>>>> 	trace_cma_release(cma->name, pfn, pages, count);
>>>>> }
>>>>>
>>>>>
>>>>> cma_release()
>>>>> {
>>>>> 	cmr = find_cma_memrange();
>>>>>
>>>>> 	if (!cmr)
>>>>> 		return false;
>>>>> 	
>>>>> 	for (; count--; pages++)
>>>>> 		VM_WARN_ON(!put_page_testzero(pages);
>>>>>
>>>>> 	__cma_release_frozen();
>>>>> }
>>>>>
>>>>> cma_release_frozen()
>>>>> {
>>>>> 	cmr = find_cma_memrange();
>>>>>
>>>>> 	if (!cmr)
>>>>> 		return false;
>>>>>
>>>>> 	__cma_release_frozen();
>>>>>
>>>>> }
>>>>>
>>>>> Let me know your thoughts.
>>>>
>>>> Yes, this is exactly what I described above that needs to be done, but I
>>>> think it will add more codes :)
>>>>
>>>> Our goal is that convert all cma_{alloc,release} caller to
>>>> cma_frozen_{alloc,release}, and complete remove free_contig_range in cma, Maybe no changes? But if you prefer above way, I can also update
>>>> it.
>>>
>>> If the goal is to replace all cma_{alloc,release}() calls with the frozen version,
>>> there is no need to make the change as I suggested. Are you planning to send
>>> another patchset to do the replacement after this one?
>>
>> There are few callers, the following can be straightforwardly converted
>> to a frozen version.
>>
>>    mm/cma_debug.c
>>    drivers/dma-buf/heaps/cma_heap.c
>>    drivers/s390/char/vmcp.c
>>    arch/powerpc/kvm/book3s_hv_builtin.c
>>
>> For the DMA part, we suppose there is no driver using the page refcount, as too many drivers are involved, maybe there is a very special usage in the driver，I can't be sure.
>>
>>    kernel/dma/contiguous.c
> 
> Even if drivers are not using page refcount, these allocated cma pages should
> be still have a elevated refcount to indicate they are in use, right? So
> cma_alloc() and cma_release() can be converted to frozen + refcount manipulation,
> right? I am not sure letting drivers use froze pages directly is the right move.

OK. I previously simply believed there might be an opportunity, but it
seems it might not be that straightforward.

> Frozen pages should only be changed by the one freezes the pages and no one else
> should touch it.

Anyway，thank for sharing your points, I will change cma_release()
according to your suggestion in next version.

Thanks.

> 
> Best Regards,
> Yan, Zi
> 


