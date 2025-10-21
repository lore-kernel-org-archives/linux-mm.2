Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF4BCCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 08:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65318E0011; Tue, 21 Oct 2025 04:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3CCA8E0002; Tue, 21 Oct 2025 04:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B795D8E0011; Tue, 21 Oct 2025 04:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A864D8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:41:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11A2358DDE
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:41:32 +0000 (UTC)
X-FDA: 84021477624.25.8D59372
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf06.hostedemail.com (Postfix) with ESMTP id DA55D18000F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:41:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oWWj5r+8;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761036090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zqW7tJ6RJg1+PgV58tTVxJvmLRgEfmAdl4kMOOadf4=;
	b=rAuyNdBmc8FetXnppHquCmKEFPPpPCST/puUrpSLfASKkdZjhiPlR1MilYuOjhQMOQJeE+
	EuFtr0O8+6MTqzJ7YIjSfllE9YojGSLtWvysohZf7Ie6LdVVsBGYQuXK1NkSmt8w9YBicN
	iznFu0WT4gSOcGCJXISiw0hVFvgxnNI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oWWj5r+8;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761036090; a=rsa-sha256;
	cv=none;
	b=YJ/+NqV0rAJU/cNnxP6RL2ib6YtZcL73gBgYazd4PVZh71FV2ETvfztJ/ik6eif8StN4XJ
	btuNoYoVimVLN+3gThmPzteig8DXK9yTJ7+t4zVEhN0PabL+QnvvntyOTr6e4gaABeDHTI
	B8F1R9O+cmyHkEfMmpIiK4sO9RmP/yg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2zqW7tJ6RJg1+PgV58tTVxJvmLRgEfmAdl4kMOOadf4=;
	b=oWWj5r+8je5TfilmO4+11CRBLi2qKMeeUnnwytxLErdUCQ9CcBZ57gg7b2GuR+GKVZa4OkmPv
	Cbp06wXwALm11l2xjp3tBTCifkaLHtqgOH7BSjdrA8pm9P4o3SPrSydGHRu0Nvs/u4whQ91aBSQ
	PAdH5rlAdx1Bt4GuzQ0mhFY=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4crQk42LWnzLlVq;
	Tue, 21 Oct 2025 16:41:00 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 46665140155;
	Tue, 21 Oct 2025 16:41:24 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Oct 2025 16:41:23 +0800
Message-ID: <3ee89484-9cdf-4c50-a5db-79b9f2ca6886@huawei.com>
Date: Tue, 21 Oct 2025 16:41:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand
	<david@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
 <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
 <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
 <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
 <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
 <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
 <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: DA55D18000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4wg69th8aszimoomf4995m8tzg3frtbd
X-HE-Tag: 1761036088-610242
X-HE-Meta: U2FsdGVkX1+PgazPftLW8I5Ia/K89CKAAlo8l2CG0ZLCCtxlAQdLLAuEs83hDlLJyf2ftKcIDRhPKk0EOnPs8pTXfGw7f2o3yKyHOWsYT4E4ClYB2De4DcgwBkYjygYmS99aIAaX09HWusPN+2wuzk8JkBf+05SX+/F3lkXEFK3yopdiqK6U8Dil/0l8PpbxWG2mvv4x0gR8WPd+EnFcKPAz+MXFkzYWZDkhUYCC1uNclMBnl9zYgHChSisQlNNbAlGydjFC5l/+bS6BKubn6Thr1Ugo5Si/PJdZCi/lY+uC6Ob6qJkjhtjY4P0AJ2BNbZEhDAVahxqdHJO6fuz/qtknz2CNl7YAgq2yo1B8eOOLxp2/91CdabIh3VQhU4ZRvYoLmEPdXyE366Wf2RUYFUwkXHPghXyZnD+CjXKr4KrAkYj0nvG4y3trE51kv610YRqEbYG1FFvoDoB/kE6wm/rg4O1SshJjPB6Gq5YwHvqsUFFWH+aTcJGzotVBk07rNT4vPZJwJa8W2lkHG8hI7YjjhInEIQzJtFK/tipNuH85CRQ3Jm2uDPQYCu7MovF2bkG0HEDpupsCceJjrwEOGJeOetkeTSLJMBs2ev7R22sZu5oDF/c4oZVmade4CcTPu2Eaet+pg8USw1Sn0jTzhdlKgI/fgIlQi0d2abW4yDYOJdHphprn5MVgYYGVOHQPJUdUMhFoArug0G6adw6Hl8qKmKUTMyr78BxinzImLbQKjpw0FaFX8pO7JEoqwE/pGYypABqSVms+t8VUKIxHb3Id91TP2Vvcx+b4oPpairq0Ols5e87w+966NzdSZLWRjRKPrUrqczZFsQzolszimBPyE/rI4omBv3CdI+nxQXTVL5xpy6cs6mU7MNE/wnMWExZuuOW/CUWKHSPlt80mADdajFCIy5Tv+uZQOTrAUlpexByPXFUnR5xj56+8hVpt30UOqj3etsET/DOyHM/
 4g7ckJrK
 ifPOjFfLKOSK8SAdIBwlke6gc860asQcpNzpeFiESktE+P9aafraODWVhdHIYfd33BKkEZWiQX2XfTbz4VAIYh7hxcfuLWiBGcLIgggS92H+c/jBmOvtKveW6nC+d6ADe6NrgFJjtlzW7dXhXI68U448+tYJzEXMO+O6a7i1/npV+QJNu3NB24JY/f3CO6fKUGIaSjgkEgftGSnDeIKqOIIhRNJE7QtWi0vdHBB+TEXdms8RI4SCa41q7QjSZKpXumj9pMKwfJP4PX2ZEWVtnyf4D+B80pAk2gUTT/wfH5lXCFS9Bw7O8M7C7mP+hpIlFgqoQP/WXklPzTAcQ/LxZzKr6VhDjZgRaqO1cq/I78baxCW4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/21 2:56, Lorenzo Stoakes wrote:
> On Mon, Oct 20, 2025 at 08:12:08PM +0200, David Hildenbrand wrote:
>> On 20.10.25 19:49, Lorenzo Stoakes wrote:
>>> On Mon, Oct 20, 2025 at 07:34:51PM +0200, David Hildenbrand wrote:
>>>> On 20.10.25 17:14, Kefeng Wang wrote:
>>>>>
>>>>>
>>>>> On 2025/10/20 21:10, Lorenzo Stoakes wrote:
>>>>>> On Mon, Oct 20, 2025 at 02:18:44PM +0800, Kefeng Wang wrote:
>>>>>>> The prot_numa_skip() naming is not good since it updates the folio
>>>>>>> access time except checking whether to skip prot NUMA, so rename it
>>>>>>> to folio_needs_prot_numa(), and cleanup it a bit, remove ret by
>>>>>>
>>>>>> Hmm not sure 'folio_needs_prot_numa()' is any better in terms of indicating
>>>>>> that you're updating the access time to be honest.
>>>>>>
>>>>>> Also it seems to suggest that you're determining whether a mapping of the
>>>>>> folio should be made a NUMA hint by the folio alone rather than the reality
>>>>>> that the mapping is being considered for NUMA hinting and you're checking
>>>>>> to see if you actually have to do it.
>>>>
>>>> ... because the folio doesn't need prot_none protection for NUMA hitning? :)
>>>
>>> folio_xxx() impliles to me that the folio independently has proeprty 'xxx'.
>>>
>>
>> I would agree if it would be a folio_has_* or folio_test_*.
> 
> folio_is_zone_device()
> folio_is_zone_movable()
> folio_needs_release()
> folio_needs_cow_for_dma()
> folio_memcg_kmem()
> folio_memcg_charged()
> folio_pgoff()
> folio_pos()
> folio_contains()
> folio_mapcount()
> 
> etc. etc. etc.
> 
> All properties of the folio in particular, not folio_has_*() or folio_test_*().
> 
> I mean the pattern is established in the kernel. Including folio_needs_*()!
> 
> I honestly wonder if the original formulation was correct - check for exemptions.
> 
> So something like folio_exempt_from_prot_numa()?
> 
> Or this way around folio_suitable_prot_numa()?
> 
> I think this is an English thing. 'folio needs prot numa' reads as 'this folio
> _needs_ prot numa' right?
> 
> Oh - folio_can_map_prot_numa()? Something like this?
> 
>>
>> To me the folio is really just the main entity we are querying information
>> about. Not the VMA, not the target node, but the folio.
> 
> OK, I guess folio_needs_cow_for_dma() does the same thing with MMF_HAS_PINNED.
> 
>>
>>> So it's like saying 'here's a folio, does it NEED prot numa?' right?
>>
>> I'd say: "here is a folio, does it need numa protection in this vma". So I
>> still don't understand your point, unfortunately.
> 
> Again I think it's an English thing. As I said above.
> 
>>
>> And keep disliking prot_numa_hint_needed() ;)
> 
> Well you are very particular about naming :)
> 
> I similarly dislike folio_needs_prot_numa()...
> 

Maybe folio_needs_protnone_mapping()? if there are no better options,
we'll leave it as is.

>>
>> But again, I won't fight for it if you have strong opinions on it.
> 
> It's not the biggest issue in the world. Equally if you insist I won't lose
> sleep over this...
> 
>>
>> It would be better if we could have discussed that as part of v2 to avoid
>> having Kefeng go back and forth. Maybe v3+v4 were sent out a bit too quickly
> 
> At v2 I had just got back from holiday (+ being sick) and had a >1,000 mail
> backlog, sorry.
> 
>>
>> --
>> Cheers
>>
>> David / dhildenb
>>
>>
> 
> Cheers, Lorenzo
> 


