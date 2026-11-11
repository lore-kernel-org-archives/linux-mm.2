Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5DD606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 05:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SK4bRdud
Received: by kanga.kvack.org (Postfix)
	id 440D06B00EF; Wed, 11 Nov 2026 00:29:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1936B05B0; Wed, 11 Nov 2026 00:29:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308186B05B1; Wed, 11 Nov 2026 00:29:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06EFA6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:29:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D68C14017E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:29:06 +0000 (UTC)
X-FDA: 85421709492.13.DF98205
Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	by imf18.hostedemail.com (Postfix) with ESMTP id D7F331C0002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:29:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SK4bRdud;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.40 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794374944;
	b=uAA07Y2hswM+hcrOkFAgZWq23teM621+PRWqYA+ruaG7L4XXch0qziycZLliL+sFGfZ4BT
	Sxy9duGDvNtd1cfOW+EYK4iiVO++rNHsn5h5nQqyRD0kY9R7uq/PdJOAFzcoY3ZZVOPqFK
	MOzRAFssTsJqrfjpQBdJK4OHt7kXfxI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SK4bRdud;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.40 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794374944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwksgTw9I8PjraaWt8ZlC3K1PQ8zcFO2I1Y4bvOFsQo=;
	b=fXUA7dc7f2flZ5ZuLPyLObEkM1JLvG4O1z1/1aIWtuVFPQ8w6BsOeN169HcVmV9joIGIzv
	rw14AQP1kgzVaXwvzSzAup6gT2NotTkkTiQYA/7RE46OMSsbU8g6S+zmhZLZ30t4MfRNDM
	r/c9gTimwk/XHqGGqwQnReEhLLxXUdQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=H/pkuNYA9Q/UTwaD/maO8VJWbP/0UM/v9RxeBIjqa8U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794374941; v=1; x=1794979741;
 b=SK4bRdudskRS14K6AyaMFjXPpr7wn+Q4DqtjLpoRXUIj319yhLPOTE8DQ3LpRogflQ4FXyH0
 ABD6l0W42a7CvlXzkWl0XfPOXEDaLG0CsxWsHIZuiu16j2wBudf3DuOp8xPrSOrQRknb27dJg30
 H7g7l9hVD+i6pZcKHgiJRt7A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f7fb7a3319c0cf62;
	Wed, 11 Nov 2026 05:29:01 +0000
X-Mizu-Trace-ID: f7fb7a3319c0cf62
X-Migadu-Flow: FLOW_OUT
Message-ID: <000a2613-6643-4ac1-8378-a3e7df0b211a@linux.dev>
Date: Wed, 11 Nov 2026 13:28:50 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap
 init
To: Li Zhe <lizhe.67@bytedance.com>
Cc: linux-mm@kvack.org, sashiko-reviews@lists.linux.dev,
 akpm@linux-foundation.org, apopple@nvidia.com, balbirs@nvidia.com,
 david@kernel.org, osalvador@suse.de, rppt@kernel.org
References: <20261110114859.76343-1-lizhe.67@bytedance.com>
 <20261110114859.76343-3-lizhe.67@bytedance.com>
 <sashiko-outbox-207133@kernel.org>
 <0bb7599b-b20f-4bba-a7b8-fca2a093fcf9@bytedance.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <0bb7599b-b20f-4bba-a7b8-fca2a093fcf9@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: csu3s37kr9fpu1iqphoepc5ubuqkhpsg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D7F331C0002
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794374943-827998
X-HE-Meta: U2FsdGVkX1+TfZ3idUNFT9rWeKhjzsJm3Hu9QmJ5W0rIzu83PGMlgbNDptSrOe6ERSWo9l4V+Q5ve9JpJcpm5K511Z+y9th9euIeVkAv+gvQDI7vz7Gflm93KKblUj5h2DhJbvHWvVMNzeq7OoC8nCSut62yQIsa9bOkN/fYQ26IuyMDCq83YWkg7Ti+ERHT9QQS64JNxLswZflJghZkUkXKXEbGtQfgSCiqu3nrzOzIYXMmoyCg7aHiqz6cuMqhPrR5/gjN84iGOp66pe9qGefe4oqeD8KVw5cbAv8Ba+0zZkVRQuuc3Z/fhvPGAS1nBd5enr224XfAMWh1V6Md8VA15AKNGdPykT6khy9Gj2yMDmTlPIuspST3Q4p/gbUMRYCGNKgpKe/PRuDifW55eWSDVFf6miiQOyKjUj8O4RTVsJh1EWnfAtYTrdlgsswxzd0oT2hEcrOJjtm7xkFiPaEiapx45IyC7lSfDbTdt/+Ta5QiPvNFeKwzI7O/BPexU/+Q4mhJvjInMRDf2RpQQTrYYKwQUPR43dWMVbr6bdcbozFXPC3BXjTLsM4A8BP7rTpdfG6msOku+Me+1xcDQB9P79i+2p5LS+otsxpUbERnJp5KOy89hrZVhF7ciYYw5rGiueLLZZeRDp5dltHqbvFTW1vT8BjMcusoymlWEtAdd6Ju4ctrw9F4kGqkJn9usFWK0sqeK94dDTOJ01mP1WunJYIEU3TD7nRHIV3ddYcsRAU4mbiuzrUxlhNsbjLOcrBC/nA4VLJrcTjmhCnFRaV9jHE4KGQWOLuf04Md+9uTHoIZXHdbCeL+egIr+7blJRHVHo+iFwYTISFNfui5YRMzE5wcvX3V4ymPHhiMZc9/uvw5Zo2pJohl65n8HoV6qt4evAL+Mz90m1bKlZdyLzuYu82IHMWU634iPMVCvv0WyOzA7g08MSviGKUpzW3MQ6wj6cR70CNehhIAhHX
 9/Ao4pAD
 xlv8MXtHWNQALRTyhkz/OnCHtD19VZ0mpsiVwJUUHbTQIau0XO0EaCJEc2KDxiJLnJjuw4Joc4SCPVBaQwaKVQ1iYmkaBP4JF+DHURZDc2LOnrVisWi4Jzy4M0WoPotVLo2ySuHPR2/YqkkSBVX8KdZYc7qVJ7a5GGsNg4ClEtjviTGNmhunxIhddqypuWpppLtcx9NH7icwY/GvBhNn2M/OyydVx+LB9ggdNH7NuCC1LJAndNpsRrJgkcrrceo7tCUav01wcJ5C3120iScHVTD/peiunQNaJ5ptvjhUkfMZ+q2r8bl1wXGy38mALWBNFAbc2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/11 11:14, Li Zhe wrote:
> On 11/10/26 9:35 PM, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential
>> issue to consider:
>> - [High] mm/hugetlb: out-of-bounds write in
>>     hugetlb_folio_init_tail_vmemmap()
>> --
>>
>> commit 5be89b38412d58045fd600596787f54c7559d32c
>> Author: Li Zhe <lizhe.67@bytedance.com>
>>
>> mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>>
>> This commit optimizes bootmem hugepage tail struct page initialization by
>> seeding a template from the first tail page and initializing the remaining
>> tail pages via memmap_init_page_from_template().
>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index cb2de24affdc4..6ae5d2679e3aa 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -3239,6 +3239,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>>    	enum zone_type zone = folio_zonenum(folio);
>>>    	int nid = folio_nid(folio);
>>>    	struct page *page = folio_page(folio, start_page_number);
>>> +	struct page template;
>>>    	unsigned long head_pfn = folio_pfn(folio);
>>>    	unsigned long pfn, end_pfn = head_pfn + end_page_number;
>>>    	unsigned int order = huge_page_order(h);
>>> @@ -3247,11 +3248,20 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>>    	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
>>>    	 * we must initialize them ourselves here.
>>>    	 */
>>> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
>>> -		__init_single_page(page, pfn, zone, nid);
>>> -		prep_compound_tail(page, &folio->page, order);
>>> -		set_page_count(page, 0);
>>> -	}
>>> +	pfn = head_pfn + start_page_number;
>>> +
>>> +	/*
>>> +	 * Seed a template from the first real tail page and refresh only
>>> +	 * PFN-dependent fields before copying it.
>>> +	 */
>>> +	__init_single_page(page, pfn, zone, nid);
>>> +	prep_compound_tail(page, &folio->page, order);
>>> +	set_page_count(page, 0);
>>> +	memcpy(&template, page, sizeof(template));
>>> +
>>> +	for (pfn++; pfn < end_pfn; pfn++)
>>> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone,
>>> +					       &template);
>> [Severity: High]
>> Can peeling the first iteration out of the loop overwrite the struct page
>> past the end of folio when start_page_number >= end_page_number?
>>
>> Previously, the loop was a no-op when pfn >= end_pfn.  Now, when HVO does
>> not optimize a gigantic folio, prep_and_add_bootmem_folios() calls
>> hugetlb_folio_init_tail_vmemmap(folio, h,
>> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES, pages_per_huge_page(h)) after
>> gather_bootmem_prealloc_node() has already initialized the first
>> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES pages.
>>
>> On configurations where a gigantic page has pages_per_huge_page(h) <=
>> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES (for example, powerpc
>> mpc885_ads_defconfig with 16 KiB pages, MAX_PAGE_ORDER == 8, and 8 MiB
>> gigantic hugepages of order 9, where both values are 512), this
>> unconditionally initializes folio_page(folio, start_page_number) and marks
>> the adjacent physical page's struct page as a compound tail of folio,
>> corrupting mem_map.
>
> Thanks for the report. This looks valid.
>
> I will restore the empty-range check before seeding the template in v3.

Go ahead. I will end up removing this empty-range check here [1].

[1] 
https://lore.kernel.org/all/20261109095807.41547-8-songmuchun@bytedance.com/

>
> Thanks,
> Zhe


