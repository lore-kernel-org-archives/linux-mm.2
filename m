Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E659D64083
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5646B0005; Wed, 17 Dec 2025 02:17:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73C86B0089; Wed, 17 Dec 2025 02:17:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F996B008A; Wed, 17 Dec 2025 02:17:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 936C16B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:17:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3747C12EBC
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:17:16 +0000 (UTC)
X-FDA: 84228106872.20.63CC505
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE44D20016
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:17:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EcgWcv02;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765955834; a=rsa-sha256;
	cv=none;
	b=ktuRO5upIglt+/R2po9pzR21wWfzrKFeq2fAaN5q4SdYox8yhfvyAG6MHI2DvrNnXxzbEi
	W0tJ5LYgfIeRWka1aV4XDBz2wMwfsFG7/vtL4Ndv5Vmp8E349rG8a1N5zgAlFFICxnRJnt
	eBPBacH9bPJ0hulGtxxeV3fScgKRdQ8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EcgWcv02;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765955834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PrHFfJYMIPDhhwJpjWQ6xnZTYISDD6byaYr0SpXuF24=;
	b=ZImS5NbibOSaAplJrGDhIvtESaam0YxadxNd6bJwEAsePnnh1dDV2Bryk6q0uFPn6Aqeh7
	obmZIGBBDpbGbfOwF9IVO7h6FxNiEp3Uph9YL/Zbdkq1qRGLDj2UH4qgVpk+Q/vDxr7xNh
	6gkJ8WsX0mjPs9lpV7TypSx3NFhMgZk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=PrHFfJYMIPDhhwJpjWQ6xnZTYISDD6byaYr0SpXuF24=;
	b=EcgWcv02e2jjYDAZTfTpQaXBPgI6blYsM9XxDRz6HNitvdb8CAZLk6dGfha1bIDjDjsEXjSvR
	Fp+m9e1bPRrrM/Bzbe3MIuQi1X0xJEJLd6Up4feHoh/XBALHl2MbprjU5nQnTrZPX1yCQcgEFPU
	GcdvQqdAAJ0n1d+BoKsPzBU=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dWQ5W0FDWz1K968;
	Wed, 17 Dec 2025 15:14:07 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 916B71A016C;
	Wed, 17 Dec 2025 15:17:07 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Dec 2025 15:17:06 +0800
Message-ID: <d7275c36-f5bb-4baf-8a94-b8522d4aef21@huawei.com>
Date: Wed, 17 Dec 2025 15:17:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] mm: page_alloc: add
 alloc_contig_frozen_{range,pages}()
To: Zi Yan <ziy@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>,
	<jane.chu@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-5-wangkefeng.wang@huawei.com>
 <D90F7769-F3A8-4234-A9CE-F97BC48CCACE@nvidia.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <D90F7769-F3A8-4234-A9CE-F97BC48CCACE@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE44D20016
X-Stat-Signature: podhfas5zpy8cr4pjnd14fd37i44mqf1
X-Rspam-User: 
X-HE-Tag: 1765955832-872361
X-HE-Meta: U2FsdGVkX19b7xAwgOeo8V6A8EjIJCJ0hN7YmkJEJLIIIc+5JgSLe2wpNJ728GCnmMFfsW3CxhpkjfWiv6y0L/yGB0nSQb5w8X/CqijyzAyKFmZEPQAgut9i7N31ns21mSZPrlMuai4wFBR1lPoHjdUcW0OHnqu9sA2atOqjvtt/U2GgamNon5zY/Sq3i2jwh292735bWJgVCLAwFSaGyS61zKnhFPEs2i3YTjQql+a5D9BcFw3/+8kUY4DtjfJIjo4NSULXnKVR9V4zmVGnoddZR9Pw7CzDaCOWdvcGo6vLSRCxt2v0B4fZUuyej0tETQB3HDOU9YJHaIVpesuo5J/WX5ZUXyKXAgN4Ziqg6PIdHUlwPVGmN61/OhCv+a2lQwapSNeF1KSNuWql5ULda5PIwooEiPq/AN1BxhdrE6gpfk8QZbsziryoowr0r2GKDb7hS4cGDieCTUjRHBXU8QfYpPUVRijsnmsWJvKZBKL/fsQlRla3wFiKRdUKeChvbv9ZA2aCpRfPqK0S7VwQi251nHtcBp8DhUGIFA0rAIzwEThufmu2U18VZk/YGBg1uAGpgmknJBvqUCrdnt2XYNKBsM702jyoETKM5EZTC6DosdHlM/rGXGckht3DxM7eJsDvQPIpdn0WAMWgbOudmEAUaEC2CPjZDFNz0mlXhGWx/lAF7iBKncBy0I3fYxZ4LFpdq3nQLLr2pnZa9bILF2334iWoRzYTcP1sUPWFEgqwCenfs4QNwuIs2QSx5jd8G3gt6MaERHhRUAZ2eSu7Sot6RhhFTW1bEf0Ubfd6Ynw749VCyBEqZkogGZPTj3LP+/4pZF8/DkRj07Kn52AN3pcn8lOV5ULJr9vUtKG46ZW/VBMZ/6h7x9gPzKfE2oFjPGle8Hc/hou+kd42T5r3pe7KIT9iiMYbLeVshIjyA9PRPf3jvltw8e535B7mp7Z/sdvucC8V5SOWrWLzqbf
 8ULeeOq0
 DS1bJAysNaAivWPYr+3G6MTN4k3vpHB3XvD3dRbupwO7lKKsFU5V/+aenYhz2fKd8DP5G45DzGiIoiiwFo+RFm5ODKC26udjNpbqN69qnJpBN/Nb+v6nitie3xuMLbuAyw13rGvuAO8doY/yy+X6tsqHiiYjQrzyntwthzN7GE16ecCP5JINTw41tDM8qcaCbmvLdFADOsr/SbcRNsH5TmeCqAzyAUMhO0eUXB//W3COo7oaCDTjI4+u4BnqAHMRIvWzr1RSZEQdMpTD1xgtoVOraw+I7mfTuCsFYUnMQzKUWy/Fp1+PFcsUEl2Y+gRZK/4bARuhFqZlNAfLlkEPJKNuSRvc+IArKJKxCsBUkQ2XDBwFSvV2UAC6H6tww7kEAyJEA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 1:20, Zi Yan wrote:
> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
> 
>> In order to allocate given range of pages or allocate compound
>> pages without incrementing their refcount, adding two new helper
>> alloc_contig_frozen_{range,pages}() which may be beneficial
>> to some users (eg hugetlb).
>>
>> The new alloc_contig_{range,pages} only take !__GFP_COMP gfp now,
>> and the free_contig_range() is refactored to only free non-compound
>> pages, the only caller to free compound pages in cma_free_folio() is
>> changed accordingly, and the free_contig_frozen_range() is provided
>> to match the alloc_contig_frozen_range(), which is used to free
>> frozen pages.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   include/linux/gfp.h |  52 +++++--------
>>   mm/cma.c            |  15 ++--
>>   mm/hugetlb.c        |   9 ++-
>>   mm/internal.h       |  13 ++++
>>   mm/page_alloc.c     | 183 ++++++++++++++++++++++++++++++++------------
>>   5 files changed, 184 insertions(+), 88 deletions(-)
>>
> 
> <snip>
> 
>> diff --git a/mm/internal.h b/mm/internal.h
>> index e430da900430..75f624236ff8 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -513,6 +513,19 @@ static inline void set_page_refcounted(struct page *page)
>>   	set_page_count(page, 1);
>>   }
>>
>> +static inline void set_pages_refcounted(struct page *page, unsigned long nr_pages)
>> +{
>> +	unsigned long pfn = page_to_pfn(page);
>> +
>> +	if (PageHead(page)) {
>> +		set_page_refcounted(page);
>> +		return;
>> +	}
> 
> This looks fragile, since if a tail page is passed, the refcount will be wrong.
> But I see you remove this part in the next patch. It might be OK as a temporary
> step.

Yes, this temporary.

> 
>> +
>> +	for (; nr_pages--; pfn++)
>> +		set_page_refcounted(pfn_to_page(pfn));
>> +}
>> +
>>   /*
>>    * Return true if a folio needs ->release_folio() calling upon it.
>>    */
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index aa30d4436296..a7fc83bf806f 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
> 
> <snip>
> 
>>
>> +static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +	for (; nr_pages--; pfn++)
>> +		free_frozen_pages(pfn_to_page(pfn), 0);
>> +}
>> +
> 
> Is it possible to use pageblock_order to speed this up?

It should be no different since the page order always zero, maybe I
didn't get your point.

> And can it be moved before free_contig_frozen_range() for a easy read?
> 

It is used by alloc_contig_frozen_range too, put it here could avoid an 
additional declaration.


> <snip>
> 
>> +
>> +/**
>> + * free_contig_frozen_range() -- free the contiguous range of frozen pages
>> + * @pfn:	start PFN to free
>> + * @nr_pages:	Number of contiguous frozen pages to free
>> + *
>> + * This can be used to free the allocated compound/non-compound frozen pages.
>> + */
>> +void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +	struct page *first_page = pfn_to_page(pfn);
>> +	const unsigned int order = ilog2(nr_pages);
> 
> Maybe WARN_ON_ONCE(first_page != compound_head(first_page) and return
> immediately here to catch a tail page.

Sure, will add this new check here.

> 
>> +
>> +	if (PageHead(first_page)) {
>> +		WARN_ON_ONCE(order != compound_order(first_page));
>> +		free_frozen_pages(first_page, order);
>>   		return;
>>   	}
>>
>> -	for (; nr_pages--; pfn++) {
>> -		struct page *page = pfn_to_page(pfn);
>> +	__free_contig_frozen_range(pfn, nr_pages);
>> +}
>> +EXPORT_SYMBOL(free_contig_frozen_range);
>> +
Thanks.
> 
> Best Regards,
> Yan, Zi
> 


