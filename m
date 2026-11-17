Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F485606A89E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 03:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HbqWS3zd
Received: by kanga.kvack.org (Postfix)
	id 32EDA6B05B3; Mon, 16 Nov 2026 22:11:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF856B05B4; Mon, 16 Nov 2026 22:11:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CFD86B05B5; Mon, 16 Nov 2026 22:11:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D97EB6B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:11:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60BBE80310
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:11:48 +0000 (UTC)
X-FDA: 85443136296.16.83299CC
Received: from mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 35B3340005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:11:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HbqWS3zd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794885106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQu7ydPyiXxJnszdjAuda6MBtG/hw6yFx+eKHBW3+tU=;
	b=wfpfxz0x1SEfbdCajFlWmQ15pkCkoAj0GVxBuQe7f6RXQPzE6YnGov6wyqRFT79HNkiMh1
	ExtEm+idn3rg8H7YBmeUBbcN9nn+k+8G8gnoABhBjMCzu2LIkasDq3+B0WD2G4NOcgWvI0
	XRQGv+yjhokKBqT9M8DCkihpCKMVz14=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HbqWS3zd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794885106;
	b=KcuxCb7em8JzFIlQmM17YrxIfwHKTrBHfR8OC6js/f90sF9jFrgcS3XfeiX5Gtq4+3DI9G
	+XPoLVc4qpuwItrYDtfHILW2uhz76HnEHfQlQFfUKRevl5mqDKcRoj9Cv++eSMhpyy6vjC
	Wzm2dpBu0+cJnmf+uzkH1GYPdjadR9g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=do3iUEHsRUOXXkxYyuNnpPjohxgfsv86UsfgKD2v+UQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794885104; v=1; x=1795489904;
 b=HbqWS3zdfE+jWBSrnRQkLRJchmm5y5sku8Gby1ASLwABW9VHwQaFtJKFUi9yuDW6gtawAcpE
 dWzySC02stEvXMD+lSvf3Q3eNbg0l8WZV1rUeUAdqkVfyVeDVj5FJGHT1x7DNUnIegmtlLjXY49
 C1phM7X6Rr+rxf1VMyffK/Lg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 546bf800db40f8e2;
	Tue, 17 Nov 2026 03:11:44 +0000
X-Mizu-Trace-ID: 546bf800db40f8e2
X-Migadu-Flow: FLOW_OUT
Message-ID: <f618fc7e-371e-4f83-92fd-ee97db4b682f@linux.dev>
Date: Tue, 17 Nov 2026 11:11:33 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/14] mm/mm_init: factor out frozen compound page
 initialization
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, James Houghton <jthoughton@google.com>,
 Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-7-songmuchun@bytedance.com>
 <179482576829.2379196.14870002582501235383.b4-review@b4>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <179482576829.2379196.14870002582501235383.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 35B3340005
X-Rspam-User: 
X-Stat-Signature: 5imtdn46duq348rzk5sncdrot6euf7j8
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794885105-889362
X-HE-Meta: U2FsdGVkX18hTbJcp6WA5p5cVwYylVvHniWK2cTTqUCzUi+QW2ymOPdmWvGexD//4Gnx9U36WaolTeGABUgWBiGKQOW001sHZfF4cRPZM3UYL8xaxDFMF/lQUxtxECJXHhHVKvdDZKOKDtmrlX+ZkJXG+X8eI9NchgGy0LaUuuTdIeJzFkMUQR0TK29IYeNgOb2Qm6kbwSSCnoTFJ/xiJqqAuPIn9Kgyc36UknPcSykcvSZS6FPYMiuAocfCXy9YA/hptreaMlMsc/gLGzlVkpIZ8fcVNYtFUqzp9maD321IeXda3iqxO3eLrau+KwBMZL0qKq7P7Ox3geys1udf5qImJ+qnJWcEaJQNmC2fhAO2OhEqcwGNW3xhIO09gTTE6OlU/R1SY5mkXAcexKZ/LChGG2B2RpPuGy3I2RoW8i54oP0LXtHkozy36RmuG01b7Ly2UO9YocHeRndeB+NYFYBfFPW29gR+8AapqF3TE9gWz6CdhFz50EQ/dIWPWkzx0R9L8MI4DwmJjDjSzIDK5jleYmEidZdexbtWcxRURkWp+/jStb/P87E5FZ8KQj21dDoIjrlpF4x9o1sY/dCpz3WbjWgom7hGctYpa+BatfAd/EdV7Kwfpn512meAy9MW/gmx6ARiL0ar7X1f0yN4OvkY5vdRvGxqGXN3gHqmtc0ddpHwy+O2aOeuvNPFmRs77vAKzr6MdqJjsbCh845UnlLY73XLPy/cOLop/6hdW5WHJQeEseGTsT3uFGimXDHAr62iwqeOFp4pZdH1MCQqcFMFvJQKWflnqOU/NJkP3DGM/f15t22jU4N1hGAuYkh3B3XYHpTwVSgHkelGeXZ9HpMOEp2V4prJk69GKNVCEhtBfBdc9IVSKVG5mD9qPTDx44doq8vCo5HxF6/agfVAggaEKXjLmI0IRkudBOsBgiOmr0bD+OtFg1J39hsONXta8MX/VMvNm5DQuPGDvTh
 MAticzG1
 ReyRPuxqOizw5jeYUtTQxBYAuARNpV9Jl+ssRx4TiMpKOC8sGOhcr4mx1FvOe/fAzZ4gwZiU1E9hlRNPsQ3QuAT44kDpEWwmTXOxTRPCs4633nFhoe2iz95rNJhoZsfX85lyQ9ITkUaUP4xSuNUPwaWjwAKmKs5Oux5bgakHTs9yPqbQTNxjrjpCvgy2fB5SUjQ9Myt+3migaPnMUOr7AUolJ/GSqjvC//Tuddw+PBxVkFh/s5fqZobXSpI+jMLP/KroX3N6rDdQwhvtIyuUZJ7uYm3w1WNETicG2+AFPfkZOvlPrQTIZhrIm3KgFTUizpQZ+CT9ZTemZQ+ywKQ2sTeel5s9OoOA7Jak/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/16 18:42, Mike Rapoport wrote:
> Hi,

Hi Mike,

>
>> ZONE_DEVICE initializes compound struct pages while their refcounts remain
>> frozen. The setup is open-coded in memmap_init_compound(), including the
>> per-page initialization and compound tail preparation.
>>
>> Factor the common setup into memmap_init_compound_page_frozen(). Keep the
>> pgmap association and MEMORY_DEVICE_GENERIC refcount handling in the
>> ZONE_DEVICE-specific path.
>>
>> This provides an MM-internal helper for other early memmap users to
>> share.
>>
>> No functional change is intended.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v2:
>> - Rebase on memmap_init_page_from_template().
>> - Rename memmap_init_zone_device_head_page to memmap_init_zone_device_head_fields.
>> ---
>>   mm/mm_init.c | 114 +++++++++++++++++++++++++--------------------------
>>   mm/mm_init.h |   2 +
>>   2 files changed, 59 insertions(+), 57 deletions(-)
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index bf943ae72a3e5..f1e539aec3d91 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -738,6 +738,28 @@ void __meminit memmap_init_page_from_template(struct page *page,
>>   	vmemmap_optimization_verify_zone(page);
>>   }
>>   
>> +void __meminit memmap_init_compound_page_frozen(struct page *head,
>> +		unsigned long pfn, const struct zone *zone, unsigned int order)
> Do we really need the _frozen suffix here?

Maybe not. I can remove it.

>
>> +{
>> +	unsigned long nr_pages = 1UL << order;
>> +	struct page template;
>> +
>> +	memmap_init_page_common(&template, zone_idx(zone), zone_to_nid(zone));
>> +	prep_compound_tail(&template, head, order);
>> +
>> +	/* Initialize the head page. */
>> +	__init_single_page(head, pfn, zone_idx(zone), zone_to_nid(zone));
>> +	set_page_count(head, 0);
>> +	__SetPageHead(head);
>> +
>> +	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
>> +		nr_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
>> +	/* Initialize the tail pages from PFN-independent template page. */
>> +	for (unsigned long i = 1; i < nr_pages; i++)
>> +		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
>> +	prep_compound_head(head, order);
>> +}
>> +
>>   struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
>>   {
>>   	pg_data_t *pgdat = NODE_DATA(nid);
>> @@ -1063,44 +1085,39 @@ static void __init memmap_init(void)
>>   }
>>   
>>   #ifdef CONFIG_ZONE_DEVICE
>> -/*
>> - * With compound page geometry and when struct pages are stored in ram most
>> - * tail pages are reused. Consequently, the amount of unique struct pages to
>> - * initialize is a lot smaller that the total amount of struct pages being
>> - * mapped. This is a paired / mild layering violation with explicit knowledge
>> - * of how the sparse_vmemmap internals handle compound pages in the lack
>> - * of an altmap.
>> - */
>> -static inline unsigned long compound_nr_pages(unsigned long pfn,
>> -					      struct dev_pagemap *pgmap)
>> +static void memmap_init_zone_device_head_fields(struct page *head,
>> +		struct dev_pagemap *pgmap)
> I can't say I like this name. Essentailly we initialize ZONE_DEVICE
> folio here, so maybe it can be
>
> 	memmap_init_zone_device_folio(struct folio *folio)

Make more sense.

>
>>   {
>> -	const struct mem_section *ms = __pfn_to_section(pfn);
>> -
>> -	if (!section_vmemmap_optimizable(ms))
>> -		return pgmap_vmemmap_nr(pgmap);
>> -
>> -	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
>> +	/*
>> +	 * MEMORY_DEVICE_GENERIC pages start with a refcount of one; other
>> +	 * ZONE_DEVICE pages raise it when handed out. Use atomic_set() because
>> +	 * @head may be a stack template, while init_page_count() expects a
>> +	 * memmap-backed page.
>> +	 */
>> +	if (pgmap->type == MEMORY_DEVICE_GENERIC)
>> +		atomic_set(&head->_refcount, 1);
>> +	/*
>> +	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer and
>> +	 * zone_device_data. It is a bug if a ZONE_DEVICE page is ever freed
>> +	 * or placed on a driver-private list.
>> +	 */
>> +	((struct folio *)head)->pgmap = pgmap;
> ... and then we won't need this cast and the caller will just pass
> page_folio() here.

Right. Initially, I thought using page_folio on the template page might
be problematic when compound_info_has_mask() == true. However, I found
that the template page happens to be order-0, which avoids the issue.
So, we can safely use page_folio.

>
>> +	head->zone_device_data = NULL;
>>   }
>>   
>> -static void __ref memmap_init_compound(struct page *head,
>> -				       unsigned long head_pfn,
>> -				       unsigned long zone_idx, int nid,
>> -				       struct dev_pagemap *pgmap,
>> -				       unsigned long nr_pages)
>> +static void memmap_init_zone_device_basepages(unsigned long start, unsigned long end,
>> +		const struct zone *zone, struct dev_pagemap *pgmap)
> _basepages sounds odd for me, maybe _pages will do?
>

Sounds good.

Thanks,
Muchun

