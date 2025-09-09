Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92322CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12D28E0009; Tue,  9 Sep 2025 03:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AC048E0001; Tue,  9 Sep 2025 03:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B2F8E0009; Tue,  9 Sep 2025 03:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A54D8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:29:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D72AC03D8
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:29:33 +0000 (UTC)
X-FDA: 83868886626.06.3F66C05
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3AF3C40004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:29:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757402971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g/wRsGBT0QM1bX+hT3VQTZF2wxQX1HuM3In+J/kYUUI=;
	b=0SWemgyBR0e7fhCtmySeBCNWyw4uYW4R9IYLBkc3dQZYhdIMEpBVw5o36yGGnDgvhG6/r4
	eQlBcZzdzMheJMF3uiGIW6vU+vAebUG25LC1P/ZEfleIvWieTaaQ21KOXMy+E3FmbAxWRW
	iOJx4ORnnNocFHS7fs33twP3K1NmQ9o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757402971; a=rsa-sha256;
	cv=none;
	b=PxHxz3PExBNfJeDVesWjTmpJsqMkHZ0WxjYuc21/rWHDD2nPGCobym7RKrKUKhXL3NVLWx
	AJgDAcXTQfBt33HP3izexBjnw5sV6qD4tGCN2+Cgsg27eEvEm/uRaPm515F0089F6KVb9Z
	QlV30q40FIZcDFDtYt1uBVMswoPu3s0=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cLb6b1gYlz14Mpx;
	Tue,  9 Sep 2025 15:29:11 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id F24A7180485;
	Tue,  9 Sep 2025 15:29:23 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Sep 2025 15:29:22 +0800
Message-ID: <d23b0e37-2f67-46dc-badc-fc6807512c2e@huawei.com>
Date: Tue, 9 Sep 2025 15:29:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] mm: page_alloc: add alloc_contig_frozen_pages()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
 <298B40E0-8EA5-4667-86EF-22F88B832839@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <298B40E0-8EA5-4667-86EF-22F88B832839@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 3AF3C40004
X-Stat-Signature: jr1qjr8d9w3qqybhgrhggkc11ixa7h74
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757402968-995439
X-HE-Meta: U2FsdGVkX1/pf/5q16b5lw6h35f/9ALViFIp+r62Bg8sWpf18fCsIeGI2dNB3GatWRcX+YG1Ot/W5/wnJrnqvKEj+EPtCrjJPponoIQ77lewF4tF3UKYMj/TY6bPZI/HR+YoDzfwVR2gjwO3u42hI9BFyqpihhk3ZbujMjrjl8Kwd1nn69Q4PmrKBInGAdacRxzCeY39/9QfBpYl55O1Yvu/uSSPzvbrCWecOXaZy1dutYzokaTgJhRMADvzh2wy/d6lY9ceOLorWAxF3vDZ1wlGCNRVDm79gRha5YJ+dAqIThQltR9FtuEDfK/7E5asGwMk8zJxBbe/m6w1ECNdpO0fnuSjSoGVtD0oCIdHPijO90SLAbvWbYGPUbnpayBmzmDv0xdw/b+OYtuGhTlMKOP960sHaITWgsXtPB9/acScFfX0tUqyx+9jT9r0zeZt3EOD1zm+J6Tp9DmUtwFq2bkCyoAK6nhtcjz1DOKqewuQneqhF1Y4Due0Db7/Ef0EpuaGqyhdknxffZz79xBIFVZIOh954vkqHRmb3EQnTi7GZJkpD2iIE5l/6TeH5FKgQL+/SsUpyWP/MdaKLXBowIsIpRuAJspdJsaFyO1iiUeKycRNsT9JRUlKvu9By96g9hCNIwcps3Dg1On7iIhcOxlIm2B1IcT8KgC6UBoEjHcP71bIoYpA8DtPSMG90E67NgIkbdl6Zb8wPO5egPpTHqCx7XA/stv6pTRa9ubUZoIYRHVIH51/QdD4JkGRyaUKl4HXNQUIzzXF0yjM0eaZrhmgnw04e2NejvhM1NGY0jNA9om8y0LfQr2f5JZMo7X23FHVTl4ZcNJBjI3O4K8+zv3laT9KH0BLhHKkZ+Hh8gMG3Z6rWEnD3NrrhPmdD2KH3bdI6v59nYzcIkcy7E8kJVuT6rDsht1pEtp2VLZYDCPfakzEBvnknzXdGVYM8xba9tnKxOQ3xxAn0QdAifP
 j2kDg5D2
 8LtQp98PiOznEdD/Ia5QNRCOXPzeFZaaRWy6rJ9SgbmZ+mfNco8jfb4JGLuJfB8l/28T2r0Ath+fpvW/JunOEmwUylKs4Ugsju1HCPKYxEvl7vfwTl7UbTlNLIaws09MasXUNrtbdqa9GxSHZixsjGZjQ3D73NC64X7orcrnYHLZhbeC+YmRWXw/8wFcUcQGu0CJeHfb2Hea/LA1fdJOrO+wMCGr1PUlqN5eBp0GTCIMsZW13Dy/90ESSsrTL37eTGEPq+SEEjNYPmr6uaym5PDK1Yy+gpeHbN1UzR+3uEko/iq7o3QPKTYqIUYsDNcyoU1CrV1/L2UewH91/a9LAgjpuhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/9 9:44, Zi Yan wrote:
> On 2 Sep 2025, at 8:48, Kefeng Wang wrote:
> 
>> Introduce a ACR_FLAGS_FROZEN flags to indicate that we want to
>> allocate a frozen compound pages by alloc_contig_range(), also
>> provide alloc_contig_frozen_pages() to allocate pages without
>> incrementing their refcount, which may be beneficial to some
>> users (eg hugetlb).
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   include/linux/gfp.h |  6 ++++
>>   mm/page_alloc.c     | 85 +++++++++++++++++++++++++--------------------
>>   2 files changed, 54 insertions(+), 37 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index 5ebf26fcdcfa..d0047b85fe34 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -427,6 +427,7 @@ extern gfp_t vma_thp_gfp_mask(struct vm_area_struct *vma);
>>   typedef unsigned int __bitwise acr_flags_t;
>>   #define ACR_FLAGS_NONE ((__force acr_flags_t)0) // ordinary allocation request
>>   #define ACR_FLAGS_CMA ((__force acr_flags_t)BIT(0)) // allocate for CMA
>> +#define ACR_FLAGS_FROZEN ((__force acr_flags_t)BIT(1)) // allocate for frozen compound pages
> 
> ACR_FLAGS_FROZEN_COMP might be better based on your comment.
> But maybe in the future, we might want to convert non compound part
> to use frozen page too. In that case, it might be better to
> remove “compound” in the comment and then

Will drop compound.

> 
>>
>>   /* The below functions must be run on a range from a single zone. */
>>   extern int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>> @@ -437,6 +438,11 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
>>   					      int nid, nodemask_t *nodemask);
>>   #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
>>
>> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
>> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask);
>> +#define alloc_contig_frozen_pages(...) \
>> +	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
>> +
>>   #endif
>>   void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index baead29b3e67..0677c49fdff1 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6854,6 +6854,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>   	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>>   		return -EINVAL;
>>
>> +	if ((alloc_flags & ACR_FLAGS_FROZEN) && !(gfp_mask & __GFP_COMP))
>> +		return -EINVAL;
>> +
> 
> ... add a comment above this to say only frozen compound pages are supported.

Sure.

> 
>>   	/*
>>   	 * What we do here is we mark all pageblocks in range as
>>   	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
>> @@ -6951,7 +6954,8 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>
>>   		check_new_pages(head, order);
>>   		prep_new_page(head, order, gfp_mask, 0);
>> -		set_page_refcounted(head);
>> +		if (!(alloc_flags & ACR_FLAGS_FROZEN))
>> +			set_page_refcounted(head);
>>   	} else {
>>   		ret = -EINVAL;
>>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
>> @@ -6963,15 +6967,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>>   }
>>   EXPORT_SYMBOL(alloc_contig_range_noprof);
>>
>> -static int __alloc_contig_pages(unsigned long start_pfn,
>> -				unsigned long nr_pages, gfp_t gfp_mask)
>> -{
>> -	unsigned long end_pfn = start_pfn + nr_pages;
>> -
>> -	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
>> -					 gfp_mask);
>> -}
>> -
>>   static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>>   				   unsigned long nr_pages)
>>   {
>> @@ -7003,31 +6998,8 @@ static bool zone_spans_last_pfn(const struct zone *zone,
>>   	return zone_spans_pfn(zone, last_pfn);
>>   }
>>
>> -/**
>> - * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
>> - * @nr_pages:	Number of contiguous pages to allocate
>> - * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
>> - *		action and reclaim modifiers are supported. Reclaim modifiers
>> - *		control allocation behavior during compaction/migration/reclaim.
>> - * @nid:	Target node
>> - * @nodemask:	Mask for other possible nodes
>> - *
>> - * This routine is a wrapper around alloc_contig_range(). It scans over zones
>> - * on an applicable zonelist to find a contiguous pfn range which can then be
>> - * tried for allocation with alloc_contig_range(). This routine is intended
>> - * for allocation requests which can not be fulfilled with the buddy allocator.
>> - *
>> - * The allocated memory is always aligned to a page boundary. If nr_pages is a
>> - * power of two, then allocated range is also guaranteed to be aligned to same
>> - * nr_pages (e.g. 1GB request would be aligned to 1GB).
>> - *
>> - * Allocated pages can be freed with free_contig_range() or by manually calling
>> - * __free_page() on each allocated page.
>> - *
>> - * Return: pointer to contiguous pages on success, or NULL if not successful.
>> - */
>> -struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>> -				 int nid, nodemask_t *nodemask)
>> +static struct page *__alloc_contig_pages(unsigned long nr_pages, gfp_t gfp_mask,
>> +		acr_flags_t alloc_flags, int nid, nodemask_t *nodemask)
>>   {
>>   	unsigned long ret, pfn, flags;
>>   	struct zonelist *zonelist;
>> @@ -7050,8 +7022,8 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>>   				 * and cause alloc_contig_range() to fail...
>>   				 */
>>   				spin_unlock_irqrestore(&zone->lock, flags);
>> -				ret = __alloc_contig_pages(pfn, nr_pages,
>> -							gfp_mask);
>> +				ret = alloc_contig_range_noprof(pfn, pfn + nr_pages,
>> +							alloc_flags, gfp_mask);
>>   				if (!ret)
>>   					return pfn_to_page(pfn);
>>   				spin_lock_irqsave(&zone->lock, flags);
>> @@ -7062,6 +7034,45 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>>   	}
>>   	return NULL;
>>   }
>> +
>> +/**
>> + * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
>> + * @nr_pages:	Number of contiguous pages to allocate
>> + * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
>> + *		action and reclaim modifiers are supported. Reclaim modifiers
>> + *		control allocation behavior during compaction/migration/reclaim.
>> + * @nid:	Target node
>> + * @nodemask:	Mask for other possible nodes
>> + *
>> + * This routine is a wrapper around alloc_contig_range(). It scans over zones
>> + * on an applicable zonelist to find a contiguous pfn range which can then be
>> + * tried for allocation with alloc_contig_range(). This routine is intended
>> + * for allocation requests which can not be fulfilled with the buddy allocator.
>> + *
>> + * The allocated memory is always aligned to a page boundary. If nr_pages is a
>> + * power of two, then allocated range is also guaranteed to be aligned to same
>> + * nr_pages (e.g. 1GB request would be aligned to 1GB).
>> + *
>> + * Allocated pages can be freed with free_contig_range() or by manually calling
>> + * __free_page() on each allocated page.
>> + *
>> + * Return: pointer to contiguous pages on success, or NULL if not successful.
>> + */
>> +struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>> +		int nid, nodemask_t *nodemask)
>> +{
>> +	return __alloc_contig_pages(nr_pages, gfp_mask, ACR_FLAGS_NONE,
>> +				    nid, nodemask);
>> +}
>> +
>> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
>> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
>> +{
>> +	/* always allocate compound pages without refcount increased */
>> +	return __alloc_contig_pages(nr_pages, gfp_mask | __GFP_COMP,
>> +				    ACR_FLAGS_FROZEN, nid, nodemask);
>> +}
>> +
> 
> When all contig page allocations are converted to use frozen page,
> alloc_contig_pages_noprof() can do similar things as __alloc_pages_noprof():
> 
> struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> 		int nid, nodemask_t *nodemask)
> {
> 	struct page *page = __alloc_frozen_contig_pages_noprof(...);
> 	if (gfp_mask & __GFP_COMP)
> 		set_page_refcounted(page);
> 	else {
> 		unsigned long i;
> 
> 		for (i = 0; i < nr_pages; i++)
> 			set_page_refcounted(page + i);
> 	}
> 	return page;
> }
> 
> And ACR_FLAGS_FROZEN will be no longer needed.
> 
> I looked at the code briefly, it seems that we need:
> 
> 1. remove set_page_refcounted() in split_free_pages();
> 2. a new split_frozen_page() to do split_page() work without
>     set_page_refcounted() and split_page() can just call it;
> 3. a new free_frozen_contig_range() and free_contig_range()
>     calls it.
> 

Yes, I think this way before, but no users for !compound for now, let's
keep it simple.

> Anyway, with the comment change mentioned above,
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks.

> 
>>   #endif /* CONFIG_CONTIG_ALLOC */
>>
>>   void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>> -- 
>> 2.27.0
> 
> 
> Best Regards,
> Yan, Zi


