Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6BD8606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CQJekbjU
Received: by kanga.kvack.org (Postfix)
	id 196546B0AE1; Thu, 22 Oct 2026 23:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E726B0AE2; Thu, 22 Oct 2026 23:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05D5A6B0AE3; Thu, 22 Oct 2026 23:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFE486B0AE1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:58:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5282CC0277
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:58:57 +0000 (UTC)
X-FDA: 85352535114.20.E489C64
Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0D1A3140005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:58:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CQJekbjU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792727935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSGGcWSknPo+lf5UkWyamUe8j/Nkv4Dn4WtHUpxHvu4=;
	b=m1fhDmgWMITD3RJIRImb83Cb4wO/Oet+mhQg7RCUkTo79st63O7jB4WsjAIZCql1yIz3+e
	R7Fkwh0QWPGjrXXmpbPNGJyuQV8Q9qzew8hn/5RrQLzfzD+1PRGvhS4tqvkDnSBM417fB0
	3JC4EVprwTGfLlHBHi2quXLJXLRtdaU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CQJekbjU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792727935;
	b=zyiwR33OiGyi2aSDVzYnkaQ1ubqE7H3MtWnSHgeW1a9whUDbAirIN9/4BSatBRGbtwm7aW
	uJBaBCdnngWheSI/LNEHTe+bYqLfNaWDkkKYapCHb/c9Hm3N2hAyWPuuax8S9YvUhP77Qc
	AJoR5PVkmFzkFAYEIMvEA4QZnW6Dx+A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=usMhOa4kJEpoNozXrGaTkLUWHcNqguBASe33U6okgtk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792727933; v=1; x=1793332733;
 b=CQJekbjUBUGvE000P0fCTruIX4FpIQ7hmj1qoJUdRpEH0k/aM0DeCbjhT/2IFLKZHpj3xSKN
 uPkvJzPpTOfbDEwX2DCD2jvyPkKFxh/h/qHYhhFC3KAgWcx0HPE36/gtKlrdQO4trDFe2v/V+ej
 1QD4CGbpkxe+r1JTwSvj4ApE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ec97eec7ac5e72fb;
	Fri, 23 Oct 2026 03:58:53 +0000
X-Mizu-Trace-ID: ec97eec7ac5e72fb
X-Migadu-Flow: FLOW_OUT
Message-ID: <8570a18a-2ed3-4b31-98ae-c7f2a46eda44@linux.dev>
Date: Fri, 23 Oct 2026 11:58:50 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/12] mm: hugetlb_vmemmap: make vmemmap restoration
 folio-oriented
To: Lance Yang <lance.yang@linux.dev>
Cc: osalvador@suse.de, akpm@linux-foundation.org, rppt@kernel.org,
 qi.zheng@linux.dev, jthoughton@google.com, david@kernel.org,
 songmuchun@bytedance.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261020115824.823278-9-songmuchun@bytedance.com>
 <20261023034655.37422-1-lance.yang@linux.dev>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261023034655.37422-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0D1A3140005
X-Stat-Signature: hp7cae18ae1toskudgdpxhycpr8yo56s
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792727934-332284
X-HE-Meta: U2FsdGVkX1/Z5uYHKTf5soJIqSwM3skeFbZFAVvwKQV53VWEvdNE/vMqwbBnJnKhG0ZVvANtL2SiUBPHj3lM5/fuf9TnTQ4zSZQquZnI5UndjAxpixVMXw4y7L7dGQWqFT6ds4I5+RXn1oh4nlKzDUqt+2nZalpIxdhlG1A8RIL/hiNjutj1cfNqqmUWgWsxqwLFemdlS184zMfhb5WSyIQvIEi6xlHbq+Z5TwjUVqJ+1U0/NBpbGeQJGgHHyCbRy1YJsiBk9X7o7Jk+sReNWorLqzDzoegYiRcWRrjz4HD0M9JWVr1N4/xnU7EZO10rjo0eNXYZH6wDKXM7/FILp1TcTN4m7yXqtRqVkJ1LgP+JR1Esm3fsQ/lFliKOZ161DPzk4rzzHehY9Og94kkc5QkBmocJkwsaXak9BBhw2gAAn5GL8u2mY01GC3VqmSv2yn/0+RHf9L+Bb/Ae76b13tlkYik5K6ZcsWhCfjqdv+o7ooat+qKdWzzye8GYiU0/X5WF3F+YVvhBbs3mkF9B3nHy0Ai5wvhmBEF8tIcGF57o8W2cxwrO02d9OPpxKakIyTQfdptCwS0pWh502J0OcDKSRMIk53uf69DSZfWcJrQZUz02gJ5rUIQN/QTkjsCr1gXZ4Sosl0P+843tIzPGCBR8xEZw/YZoioMStOZZSNWxvduET/JcXJwSQQU6wmsLi79WHzA1eA6v41M6c1CDeSJpfoPhVHaZyyX3X2EPs4Pe8vxpWO/8jJKqm9iYZhU8STm3RznZVSU3fecAws1Y0TjhTGVco9yncTuNoh7uhbEVw63edWVz5W8r4RdXrXK4OgbzTBB1PrWp24yiTdfks8Tux9b3WIzTZzgtUFPA6b7zbAmvDepVolDSYDn/R7B3EY6nq9bcVm0HHRiAOX3lS38iLoAAvmG9TxBgW7XG+ZaxyaavluWMuhyh8OGEjvhtE6u8LOwkfN5Ytw95ACp
 wYbu0L3E
 ZxLMoyUEKGQEmnSKSP9W6tHHXXgDQt+nT1A1tLZRJFgMPUMGSVvL4N+0UBY2FJhrfJevHBLSl2B6f5sGI9HBzTICEAucGZxvYv50M2LEin4XIq0Y6PPEiwAsBo8SPQIi/MpTdqpUmHakkT7yWmlu2uvPufPP6itfkmoW3r2VRM7PJGX5zhL4sMtL3EvuNJdWgEKuOhcZFxR7atCNEJxsBEoX809QHG9IIs7aeTCdJGTV03+yEwHF0MycIDZ/CEONIb7NeOpCljLY3P0/D5TckIjG9yLSRVHplVXEzINEC7zGpic9MvLVT2Rm42crxEowsgoGqrfsk/WqOLdbbp0atfR+xHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/23 11:46, Lance Yang wrote:
> On Tue, Oct 20, 2026 at 07:58:22PM +0800, Muchun Song wrote:
>> Like optimization, vmemmap restoration operates on one folio at a time,
>> but the current interface exposes a raw address range and requires the
>> HugeTLB caller to prepare part of the operation.  This splits the common
>> mechanism across layers and obscures its natural unit of work.
>>
>> Make the folio the unit of vmemmap restoration and move the common
>> mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
>> eligibility and state in the caller and gives both directions of HVO
>> consistent folio-level interfaces.
>>
>> No functional change intended.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/hugetlb_vmemmap.c | 37 +++++++++++++------------------------
>> 1 file changed, 13 insertions(+), 24 deletions(-)
>>
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index b76203e34881..97748a9cefe2 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -360,28 +360,29 @@ static int vmemmap_optimize_folio(const struct folio *folio,
>> }
>>
>> /**
>> - * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
>> - *			 to the page which is from the @vmemmap_pages
>> - *			 respectively.
>> - * @start:	start address of the vmemmap virtual address range that we want
>> - *		to remap.
>> - * @end:	end address of the vmemmap virtual address range that we want to
>> - *		remap.
>> - * @flags:	modifications to vmemmap_remap_walk flags
>> + * vmemmap_restore_folio - restore the vmemmap backing of a folio
>> + * @folio:	folio whose vmemmap pages should be restored.
>> + * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
>> + *
>> + * Remap @folio's vmemmap so optimizable entries are restored from the shared
>> + * tail page back to distinct backing pages allocated for @folio, while
>> + * non-optimizable entries remain unchanged.
>>   *
>>   * Return: %0 on success, negative error code otherwise.
>>   */
>> -static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
>> -			       unsigned long flags)
>> +static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
>> {
>> 	LIST_HEAD(vmemmap_pages);
>> -	int nid = page_to_nid((struct page *)start);
>> +	int nid = folio_nid(folio);
>> +	unsigned long start = (unsigned long)folio_page(folio, 0);
>> +	unsigned long end = start + folio_vmemmap_size(folio);
>> 	struct vmemmap_remap_walk walk = {
>> 		.remap_pte	= vmemmap_restore_pte,
>> 		.vmemmap_pages	= &vmemmap_pages,
>> 		.flags		= flags,
>> 	};
>>
>> +	start += VMEMMAP_OPTIMIZATION_SIZE;
>> 	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
>> 		return -ENOMEM;
>>
>> @@ -399,7 +400,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
>> 					   struct folio *folio, unsigned long flags)
>> {
>> 	int ret;
>> -	unsigned long vmemmap_start, vmemmap_end;
>>
>> 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
>> 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
>> @@ -407,18 +407,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
>> 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
>> 		return 0;
>>
>> -	vmemmap_start	= (unsigned long)&folio->page;
>> -	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
>> -
>> -	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
>> -
>> -	/*
>> -	 * The pages which the vmemmap virtual address range [@vmemmap_start,
>> -	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
>> -	 * When a HugeTLB page is freed to the buddy allocator, previously
>> -	 * discarded vmemmap pages must be allocated and remapping.
>> -	 */
>> -	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
>> +	ret = vmemmap_restore_folio(folio, flags);
> Nit: we don't use h in __hugetlb_vmemmap_restore_folio() anymore. Could
> we drop it from that helper while at it?

You're really thorough. That's actually something on my follow-up series,
so I didn't include it in the current one.

>
> Otherwise, LGTM!
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thanks.


