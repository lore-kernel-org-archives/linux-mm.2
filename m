Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE044D74951
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 04:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201916B0088; Thu, 18 Dec 2025 23:09:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC2A6B0089; Thu, 18 Dec 2025 23:09:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8256B008A; Thu, 18 Dec 2025 23:09:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F39946B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:09:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 74E4E58C97
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:09:30 +0000 (UTC)
X-FDA: 84234891300.01.A96A124
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf04.hostedemail.com (Postfix) with ESMTP id 01E0040010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:09:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="b/uIrZq5";
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766117364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVfTIESBt0R5i9jZFdN3setpQaaFFoPM3RXBqtl21JM=;
	b=Ud++dsrWySWS09kcASoo7+6WPGro81h7VSGQJz+bcfdjUQK/CXQJO3wqQzMbpcy6/pV3q9
	9ZfaCrC5XyqQyHQqk6KlkJvXf5qsNG5ly+MlpbHg+Vw634YMbkhVoc1speyTWhIfqo0/FI
	KFfumhatIUF8RlCRMCgVIqKU2VVWhWk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="b/uIrZq5";
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766117364; a=rsa-sha256;
	cv=none;
	b=fu23lN7MjDpdIh8TfE655B6ZBag6cufKkTL92NjD8pysUMOA1myc7fvDtQk07MxLUJlCQ6
	p1xJsqAIJfPU8uHsjD97DN13R5MpD35KEx/VIcecJ1NO6PKJaAqZ13UvTZZt4qVhuhegqC
	Yyyn3y7uELeYLa2r/8hb8n9IrowdaS0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jVfTIESBt0R5i9jZFdN3setpQaaFFoPM3RXBqtl21JM=;
	b=b/uIrZq5s/XzNrX3urxQMTzB6DYPuxe97O1NE9R5A4dVa5UuzY6wxHizha0OWCvccj1Gmd358
	3aFOsA0X7/UHykoJvJDGWrbrQ23S3SOcEirASWZfEeLEfQ5991bIogyQyeoKiYWnWzMtLavC7tN
	8cwY+ehkQCIVHLTBu/NQTlA=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dXYrj0nxrz1T4G3;
	Fri, 19 Dec 2025 12:07:01 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id B9CF2140154;
	Fri, 19 Dec 2025 12:09:15 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Dec 2025 12:09:14 +0800
Message-ID: <3627fca8-4133-40b5-9883-5163dcbc91aa@huawei.com>
Date: Fri, 19 Dec 2025 12:09:13 +0800
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
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <0168824D-37E8-4E22-AAF5-43DDB38F0FED@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 01E0040010
X-Stat-Signature: j4erxyfk1gzgkp7pwodsnei3y4qzgahu
X-Rspam-User: 
X-HE-Tag: 1766117362-832961
X-HE-Meta: U2FsdGVkX18yKJZm9LbpirZxOiwcNKJC39013E9/pqGcy7v5ePvlyHW47T1M5/NIewY6wLlZIFGreLms7J1QM1VR9EER3oW3NGoVfaDXltNL78A5LKnS7S3c/22PXrfU4A4MLgFCUIjIUMP7+MsrAqeGAYILfwyEPvfaSRFXU81H8HgOwuIsVzV+qYLk9xK70lgew4UD4Pj0IwbDxBmD1NKnjSWf9z/QaF/l089Er9afMuXSi4IKU/B8TFY4wo1KxvMfj1SDK54AFNsIQz4jwVcK/1GMdDMhMQ8pgjRzjctC75IG0AKXyAhn9sE2VBHhX0gICXD3S9MUVdUwRDr5GEa7L86R4gtt5vJFnognxy6ZxGxs+DpuAEGWTwAGwH1jrI7CoVMCGe8L/OXeVCo3BuOSNbUUYYw8hDmh7B7asCz/70sJQSGU8/oSCnZLdKljB9Nl2DLvsoGn/Bf9YZTjOR1pouNoOb5NhfbVEmVMmWn5hp0BHOIWyo44MoeCH6h0Nl58R9WtFEs3gylY3ATjXVhV6DwPzP7xdRLRfIBXhNAd3X4rMiNOHvA5z3oa4nTtO6FglMvduPQfVnrNpb33w8E0rvqw0SsEQDh8FrlL8286SC9q72GxRDcXfw7E69MaRtsRwjLpVoTqxD/VEvO9Owv5n2LORH0GbOq0RSWIoB7fx810Hf8UBSYRq+B+x0KYeF413YyYViEaDQuMvF0rcyPTJ2SRqBcDHnlu5Syo8yzISclI5mod9oWux2XqVo7/l0HvLfdtSMAh7v25Q8QtSRI5UjWXmqFaKdWMiJLVdDcp3Ej7xi0PkVumBe78cADhu/Wo6pnkDDKJAxsM9XWMKimA4QdTNZirIF7Sm5gzwdPPwKZ6rV/x77Oj2ymQuOY4cXfdfA+BW6DtBs6zsNyQE5/4l4inSeU5KxXfUH19RIgrIx7X07SNfycKe66eWxkhuMadWgeLj/RF+XyWqio
 Tn4iabyx
 9420/KVDKQoxQ1EBC4vIrgW2d3U6q/O6JMXFPlyV5cgY5fvRi83Ghyrp87Juvhc22/sgPhP5qcs4SmBg2RoW7GghIAiigbxW1pfQPI70sn5VuuQJERP/D9mpLhALFnDIBvyok00HVGSkfRFLiHhksut2/mswdInsEryYQDrJIL+fiJPlJRB3OzX1o8dlDQbg9iH0jzI6h0n6vQFqP0F1FirbD0hMT6J7IvuQVGmWmgNfSfwT3pFQ9MrGRSOg2noHuEzyio0CAkN+KX2a3of2tShsk6qm4UWAhKrxmQh63I5jS7MSw3lOSyT+fk6hzYiZarNfQvCao6EfzkiBk8cN3YoitTlOK96fqpn5k9tnH8+6wq9RHumWf6OqAlkHFKlTWHZmvrwQ8ehf57Kwl1ZzZGHm3pUw9UAozkc6v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 23:52, Zi Yan wrote:
> On 18 Dec 2025, at 7:54, Kefeng Wang wrote:
> 
>> On 2025/12/18 3:38, Zi Yan wrote:
>>> On 17 Dec 2025, at 3:02, Kefeng Wang wrote:
>>>
>>>> On 2025/12/17 2:40, Zi Yan wrote:
>>>>> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
>>>>>
>>>>>> Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
>>>>>> incrementing their refcount, then convert hugetlb cma to use the
>>>>>> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
>>>>>> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
>>>>>> into mm/internal.h since no outside user.
>>>>>>
>>>>>> The set_pages_refcounted() is only called to set non-compound pages
>>>>>> after above changes, so remove the processing about PageHead.
>>>>>>
>>>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>> ---
>>>>>>     include/linux/cma.h | 26 ++++++------------------
>>>>>>     mm/cma.c            | 48 +++++++++++++++++++++++++--------------------
>>>>>>     mm/hugetlb_cma.c    | 24 +++++++++++++----------
>>>>>>     mm/internal.h       | 10 +++++-----
>>>>>>     4 files changed, 52 insertions(+), 56 deletions(-)
>>>>>>
>>>>
>>>> ...
>>>>
>>>>>>     static bool __cma_release(struct cma *cma, const struct page *pages,
>>>>>> -			  unsigned long count, bool compound)
>>>>>> +			  unsigned long count, bool frozen)
>>>>>>     {
>>>>>>     	unsigned long pfn, end;
>>>>>>     	int r;
>>>>>> @@ -974,8 +982,8 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
>>>>>>     		return false;
>>>>>>     	}
>>>>>>
>>>>>> -	if (compound)
>>>>>> -		__free_pages((struct page *)pages, compound_order(pages));
>>>>>> +	if (frozen)
>>>>>> +		free_contig_frozen_range(pfn, count);
>>>>>>     	else
>>>>>>     		free_contig_range(pfn, count);
>>>>>
>>>>> Can we get rid of free_contig_range() branch by making cma_release() put
>>>>> each page’s refcount? Then, __cma_relase() becomes cma_release_frozen()
>>>>> and the release pattern matches allocation pattern:
>>>>> 1. cma_alloc() calls cma_alloc_frozen() and manipulates page refcount.
>>>>> 2. cma_release() manipulates page refcount and calls cma_release_frozen().
>>>>>
>>>>
>>>> Have considered similar things before, but we need manipulates page
>>>> refcount only find the correct cma memrange from cma/pages, it seems
>>>> that no big improvement, any more comments?
>>>>
>>>> 1) for cma_release:
>>>>      a. cma find memrange
>>>>      b. manipulates page refcount when cmr found
>>>>      c. free page and release cma resource
>>>> 2) for cma_release_frozen
>>>>      a. cma find memrange
>>>>      b. free page and release cma resource whne cmr found
>>>
>>> Right, I think it makes code simpler.
>>>
>>> Basically add a helper function:
>>> struct cma_memrange* find_cma_memrange(struct cma *cma,
>>> 		const struct page *pages, unsigned long count);
>>>
>>> Then
>>>
>>> __cma_release_frozen()
>>> {
>>> 	free_contig_frozen_range(pfn, count);
>>> 	cma_clear_bitmap(cma, cmr, pfn, count);
>>> 	cma_sysfs_account_release_pages(cma, count);
>>> 	trace_cma_release(cma->name, pfn, pages, count);
>>> }
>>>
>>>
>>> cma_release()
>>> {
>>> 	cmr = find_cma_memrange();
>>>
>>> 	if (!cmr)
>>> 		return false;
>>> 	
>>> 	for (; count--; pages++)
>>> 		VM_WARN_ON(!put_page_testzero(pages);
>>>
>>> 	__cma_release_frozen();
>>> }
>>>
>>> cma_release_frozen()
>>> {
>>> 	cmr = find_cma_memrange();
>>>
>>> 	if (!cmr)
>>> 		return false;
>>>
>>> 	__cma_release_frozen();
>>>
>>> }
>>>
>>> Let me know your thoughts.
>>
>> Yes, this is exactly what I described above that needs to be done, but I
>> think it will add more codes :)
>>
>> Our goal is that convert all cma_{alloc,release} caller to
>> cma_frozen_{alloc,release}, and complete remove free_contig_range in cma, Maybe no changes? But if you prefer above way, I can also update
>> it.
> 
> If the goal is to replace all cma_{alloc,release}() calls with the frozen version,
> there is no need to make the change as I suggested. Are you planning to send
> another patchset to do the replacement after this one?

There are few callers, the following can be straightforwardly converted
to a frozen version.

   mm/cma_debug.c
   drivers/dma-buf/heaps/cma_heap.c
   drivers/s390/char/vmcp.c
   arch/powerpc/kvm/book3s_hv_builtin.c

For the DMA part, we suppose there is no driver using the page refcount, 
as too many drivers are involved, maybe there is a very special usage in 
the driver，I can't be sure.

   kernel/dma/contiguous.c



