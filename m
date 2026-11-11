Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6998606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qqEf33XQ
Received: by kanga.kvack.org (Postfix)
	id 009BD6B05C1; Wed, 11 Nov 2026 03:21:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23226B05C2; Wed, 11 Nov 2026 03:21:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39856B05C3; Wed, 11 Nov 2026 03:21:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C35B06B05C1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:21:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AC351A023E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:21:25 +0000 (UTC)
X-FDA: 85422143730.18.A174EA1
Received: from mta1.migadu.com (out-103.mta1.migadu.com [95.215.58.103])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8C4724000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:21:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qqEf33XQ;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.103 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794385283;
	b=pHgYUxkjiMSlrP6uaYsZzeLRDBiNcVJXzaySDd4PS8bbTdOS8xP5wiJjCNL2kuzjbH67Nd
	vjraKNaigKopDAdDKlOzYIXvPg2J9d1uf9BmoTZoccyuqXMnKT2ovBm2BFm6ZwYwLN3oTA
	MXTBf2nSm40EvKtge2YUR1PWph6QvTA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qqEf33XQ;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.103 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794385283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrlVr5jqaYxs2RX5lW/+H54QUYUUFOV3KkaDRJj2vZM=;
	b=IaH1LbugKQ7/Q6NV+t/ChOQLWBXMGm5j2HtlrbFKXod5YZx+sN6eDDHewDNpQVtNIWgwrw
	CdqJdz+2v0nhSLLpkatkd5obtKy9F+B7qZiUWXgBB3JQP1fTHjAf/4Kq3JW5iWtegd1seH
	xCEzMw0kffseMeakKDIMMcrTSgxrHzI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cBjbNmnBhAc/1YCUbMzQQQwg2p5v2yxhI3AVX1PNB6Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794385277; v=1; x=1794990077;
 b=qqEf33XQ+mYO2MSog0PvSr9K3GHCJhXZTcwCk6BSIh1PTY5sGB0hmZlsUHqf6I2lbbm1X1hg
 PEUdZ5IpDf0hz+hl4CTaFM3E+ZAoPR2jU4/h9wLF0uBBhAilnosh1UiQK3ggdDT01ISELRl3Qu2
 smt2MnCIq/FIqUWlaBGlLdEE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7f1be61d3be57328;
	Wed, 11 Nov 2026 08:21:17 +0000
X-Mizu-Trace-ID: 7f1be61d3be57328
X-Migadu-Flow: FLOW_OUT
Message-ID: <493d9088-35fb-480f-a531-75979f4ce485@linux.dev>
Date: Wed, 11 Nov 2026 16:21:04 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap
 init
To: Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>, linux-mm@kvack.org,
 sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org,
 apopple@nvidia.com, balbirs@nvidia.com, david@kernel.org, osalvador@suse.de
References: <20261110114859.76343-1-lizhe.67@bytedance.com>
 <20261110114859.76343-3-lizhe.67@bytedance.com>
 <sashiko-outbox-207133@kernel.org>
 <0bb7599b-b20f-4bba-a7b8-fca2a093fcf9@bytedance.com>
 <000a2613-6643-4ac1-8378-a3e7df0b211a@linux.dev>
 <avQkQKRkYV32Qkxp@kernel.org>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <avQkQKRkYV32Qkxp@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rurdcgixpfukcerj9z7dxkqzrn7wfmaa
X-Rspamd-Queue-Id: 8C4724000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794385281-148111
X-HE-Meta: U2FsdGVkX18NuVs/Wwb5HHLtL4ZVbDqLx4kWZyh0ZgFG4HJXUoiv8KIMs/aIGqiZtvux063MKMCW7ojNLL3EopyCZSuJCZB+GBi6Kr786cmz1M1lk0AOyUdPv1rTyKhgA1yoD2sr8C5xNJ2nAW+KAXDcTIo//NMDGtZkrvWx9ca27f2L4+kYNgGZ9d1rTrBtvbQRCUyUJcL/wHPaoFwlooOmybr3M4V/75bUYGjjqdTKHzDHVMvl8MZ2HvDx4jTsWO0Jd1/blzl3DDte6WaoOJfVSILvig4XbUH5PL66dTJku6yxwSGazPLQclB8d7/OheiF1Tn4GvPkM3aC927tAVIkXaPJs2wskcZFakBTIw+kSv4crd2/woXDj645DuzJEbKC3Y9FXH5NYbMLY4ZSU2bd2Iuve4cWyEmbgKD7iCfo30NS6ql/q43hgmSBv3v38Ni4eAj6ZiXXSmSKxXlwolKs/wq6yObMsoyxi/h3kbwhJdJeVWl/w12lG2zU2fE7L5C0OBBb4yolmD2N/Je6WdwN6VfWeKERuL+pAYoAbygWFFBWsgL+DdJhoJCzok2zkZ/vDXfJMR/9Vj9rT/FQU2SUn74pZJ1tdDsyZcsynUphLqixnexKJYjZGQzqtNOjQbuoerJCuScWuMcq+XteBEpKOdNYG3KBdV4oktdVkUYwrJ+xBI2wA/oWK1jk5zUlbtaxDepUb/+p8Vem/U4jGrejmcsodGtXMi+xQJcswWDNYCNvkOY2bNqq7hInpPMjg6cGL0o8voW/nyAR1dEizp9qIq4Mi/qv7ib1qkf4w7jwtzjywAlzQi1Su48wdqS1AfjMeRej3IKdoqbPhllxlk2DdYhLduq2VervKS9QYuCzo2FiXsBbHwh7I8KF8xYjHt62rC9hHkshyBIaYs3/Zp+Rdqew4D/g+7EME1CiH5wXB4ODKqzI03+n9jZbUt5Pbq1ruRVRmRgV500/eYH
 pqIkQ/pe
 O0udOuTFL4Ofj5xgnWteTy02hori4vPudPqPuF2kBla6uzcZ++OtoAPMwKepbFKXRUIXW+iieEuWQtiH5QQH0QzAeVAECamiCzvc9Q1bN/O3CKyzN6I/gEe3n5XKJy5dOm7wrhazcUUe7Bo/d/3LQMBdpzhFKvJU14J0U1ORbSFzXqyD3ABsBFUtt/3pIdHNN9kG/Z0KCGOu/RdnHHXdhdmnxwRjT03LfoLozGxUZbDv0pcD9GBwgQUfJPDPwMJZaATMOr8of7Puofro6QYLu5kEOnqWRk9Mdnz0n8JbNYeX18I0mqs0pejj0bH0ihbXpvEBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/11 16:16, Mike Rapoport wrote:
> Hi,
> On Wed, Nov 11, 2026 at 01:28:50PM +0800, Muchun Song wrote:
>> On 2026/11/11 11:14, Li Zhe wrote:
>>> On 11/10/26 9:35 PM, sashiko-bot@kernel.org wrote:
>>>> Thank you for your contribution! Sashiko AI review found 1 potential
>>>> issue to consider:
>>>> - [High] mm/hugetlb: out-of-bounds write in
>>>>      hugetlb_folio_init_tail_vmemmap()
>>>> --
>>>>
>>>> commit 5be89b38412d58045fd600596787f54c7559d32c
>>>> Author: Li Zhe <lizhe.67@bytedance.com>
>>>>
>>>> mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>>>>
>>>> This commit optimizes bootmem hugepage tail struct page initialization by
>>>> seeding a template from the first tail page and initializing the remaining
>>>> tail pages via memmap_init_page_from_template().
>>>>
>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>> index cb2de24affdc4..6ae5d2679e3aa 100644
>>>>> --- a/mm/hugetlb.c
>>>>> +++ b/mm/hugetlb.c
>>>>> @@ -3239,6 +3239,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>>>>     	enum zone_type zone = folio_zonenum(folio);
>>>>>     	int nid = folio_nid(folio);
>>>>>     	struct page *page = folio_page(folio, start_page_number);
>>>>> +	struct page template;
>>>>>     	unsigned long head_pfn = folio_pfn(folio);
>>>>>     	unsigned long pfn, end_pfn = head_pfn + end_page_number;
>>>>>     	unsigned int order = huge_page_order(h);
>>>>> @@ -3247,11 +3248,20 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>>>>     	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
>>>>>     	 * we must initialize them ourselves here.
>>>>>     	 */
>>>>> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
>>>>> -		__init_single_page(page, pfn, zone, nid);
>>>>> -		prep_compound_tail(page, &folio->page, order);
>>>>> -		set_page_count(page, 0);
>>>>> -	}
>>>>> +	pfn = head_pfn + start_page_number;
>>>>> +
>>>>> +	/*
>>>>> +	 * Seed a template from the first real tail page and refresh only
>>>>> +	 * PFN-dependent fields before copying it.
>>>>> +	 */
>>>>> +	__init_single_page(page, pfn, zone, nid);
>>>>> +	prep_compound_tail(page, &folio->page, order);
>>>>> +	set_page_count(page, 0);
>>>>> +	memcpy(&template, page, sizeof(template));
>>>>> +
>>>>> +	for (pfn++; pfn < end_pfn; pfn++)
>>>>> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone,
>>>>> +					       &template);
>>>> [Severity: High]
>>>> Can peeling the first iteration out of the loop overwrite the struct page
>>>> past the end of folio when start_page_number >= end_page_number?
>>>>
>>>> Previously, the loop was a no-op when pfn >= end_pfn.  Now, when HVO does
>>>> not optimize a gigantic folio, prep_and_add_bootmem_folios() calls
>>>> hugetlb_folio_init_tail_vmemmap(folio, h,
>>>> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES, pages_per_huge_page(h)) after
>>>> gather_bootmem_prealloc_node() has already initialized the first
>>>> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES pages.
>>>>
>>>> On configurations where a gigantic page has pages_per_huge_page(h) <=
>>>> VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES (for example, powerpc
>>>> mpc885_ads_defconfig with 16 KiB pages, MAX_PAGE_ORDER == 8, and 8 MiB
>>>> gigantic hugepages of order 9, where both values are 512), this
>>>> unconditionally initializes folio_page(folio, start_page_number) and marks
>>>> the adjacent physical page's struct page as a compound tail of folio,
>>>> corrupting mem_map.
>>> Thanks for the report. This looks valid.
>>>
>>> I will restore the empty-range check before seeding the template in v3.
>> Go ahead. I will end up removing this empty-range check here [1].
>>
>> [1]
>> https://lore.kernel.org/all/20261109095807.41547-8-songmuchun@bytedance.com/
>   
> Maybe you'll pick these two patches into your series since you anyway
> change the same areas?

Good point! I'd like to do this.

Thanks,
Muchun

>>> Thanks,
>>> Zhe


