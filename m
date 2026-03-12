Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F959106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11D96B00A6; Thu, 12 Mar 2026 16:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDCE76B00B9; Thu, 12 Mar 2026 16:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8106B00BB; Thu, 12 Mar 2026 16:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B80FD6B00A6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:56:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B0FA1B7EA6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:56:30 +0000 (UTC)
X-FDA: 84538619340.02.41059F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6A36F80004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:56:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G9sTpk5z;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bI4UA4DImA2JZwZroL9IYbKS1jn0L73o8UKDvikYv6g=;
	b=oahQP6qOLtskG4PrMktcY9QL0nRym/gF4okaJA4ZTi88UlDhS0t5h5kcQ45ZWMRgLVUW63
	cx4tJ5sy+vGGWx5irDtbOyTCgmLMFbxzyOUkM9s2CwDeHBs1nB6VeGoFCqogoNr4rYk7wl
	v34//utsDwOuEXD9wwoRFeM9y3lbO84=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G9sTpk5z;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348988; a=rsa-sha256;
	cv=none;
	b=iPGfhrGz+ecTBOTlJ+x6VWLc5XuLHZ1GCy3MlbDqJfvsLAqwwE3QJYe01fXIWnrMYLNlc+
	9iq+XkaGMn3fP1ZYiAYvJzdfoMUxpXyOOoy/w5snVmKNDRvSXwMqbOHIUsK2CxkgX4ql1M
	9aFPN9KLbRKL12yYr3Vntxh4bZdBS18=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5623740593;
	Thu, 12 Mar 2026 20:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A26FC4CEF7;
	Thu, 12 Mar 2026 20:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773348987;
	bh=7lxlc48hj+4RafLXUV6lXTchWoi4gWJzoSgwunrQEdw=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=G9sTpk5zYZuE0nSRQXdbeEpm0Y6ouos+94lIQA8HP8cXP4BMkV0cRc+wTMlElLuU7
	 6nstxesDDEr07Kp722aYic7++IYUangZrwUrj/6TKwNHVbSkEfl/YUz92YyvS1io1F
	 S9xRlEFZuQtVz2U8gHFtt5qRX6QoEAmzlDV2g13TsCbmS3XOsTGaHRKG/yydQqHigG
	 LILbLPTXdwJzz7oeolmS2rZ5kCNp7v4GmIBzQWg24+p6zwaB02EPkHFc7bu3DdLM9B
	 flCz0RWzsvgK62yqyhuYlakbQxt0Sv1JFTu/aNwpEKzikNemNHOp98KkB2kOBG4k4M
	 18hr/2s15a9fg==
Message-ID: <c4e80668-9018-48fc-883c-5d52a5950065@kernel.org>
Date: Thu, 12 Mar 2026 21:56:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 03/13] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032347.232939-1-npache@redhat.com>
 <8a4568de-e0f9-471b-bc94-1062d4af3938@kernel.org>
 <ee39e605-0d9f-433b-9dfa-f70fd92edfac@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ee39e605-0d9f-433b-9dfa-f70fd92edfac@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6A36F80004
X-Stat-Signature: oqckdxpycxafkc3pxf6y3w9raspgcjmc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773348988-861739
X-HE-Meta: U2FsdGVkX1/lqIJhPmcE3tWZ0xErkcoVPYFZF4YVZrGOwg7ijWlLq33zMjYvZfpIRwNZYgCIWcLXjwqNtAEcfX51c4/yxUHM9FvAHiuIzbwXhM/c3KERXQOUsBDnfvqz2W807sbP/zYd4LGBa+/kxTKJSLRDJv1EQQUTJinQxpVC0MgUTvKQFALFf31JayrXg+5gxhY+tA5ExDHodkX95Dn/RCsodVaMUgsUgT0UTt3VF5Wr8LB27X8o3XBnkL3B+iEXUDjAf5L6mwTlItGnlS/O7sLqBDbB8ZgSeZ6x6GGkHA/QshGDYbSH/21aGL5qZd0S/CnzC2/nM542yzmpqjfUxhmt1M6ZGdegW9gCg9mx8PAXju2IEnOYZOABnKEHB2mGmY1Olhk6aswEFPANwhxSMGUbF4k/IWgDZBOaNXIqGyEV5xJ2UtNee7dviXkqxIUuP73tU12KTIuZk/xDJ81q9CpgqIlBwVdBsI63BsHMnX7WuNRo1hfcfoZcH22pQPVmBPlqY8BfbLaH+1uuoyuN5lExf0+zznlXuNCWYSTR/sX/awpjENdiE0JZQGFW/reuZ6d1y2XV98z5cTMpFBqU80SrCca/e/jK6ZWHpDJFil4lJ7O/HN/minjrVWqMIMp+/V+ObkgGJIp4sA+PFf7EXAbooE5yXGmEqz1+s/hNdi13Qdx4JeeBjH/38fDcI4pd3Fvq/SdDIeWQciL+l+SiOMQ5WnAdq3ldK72jUM05dCvSz9p8YJgTlsjKA9eH/vING3MXaT7AbZw7fYd6C3JJfpOBERr/P2Yc7OP/7fwJxVJbUhs9EtmsiIG+EZXZxGSikXul6E74eGjmNnOxAISEwiE0aLz9DrigSVUSvc5ssBDoFWbmXG9EYk841fdIsIt4z+hLtbWLnjJiRnno7xMag9vhuF1dOn50jgoy3X0gUI1pRRfCddAzzzf2qLo43yYRQNS+nHXSJYI+W9m
 d/OOP99s
 9TLMShKVkXBj0Z8g1cuj9xDeYAEecvKklR2qNr4bLG81YezZqoxCJX8+7SBVgYHLAfNyO4lJZdAcj1wNAtf/B+f3z3rzNc7TICCU5tqPDtP3b3ArJCCflickztLfmfQ4EZOS1YCj6gPcgqPoRWPRuRqFHobJ/gxOS6IIRW7lMIbpEbzSxv2El5StWlLL7No7LdE2Akf9KcLV5dVK5fVjz3+9Of+VQ1CDC70c9llpys4sQh6GwpZa6neDLyMY6lhK70AopQw3FzXVDHMtFVAjvWfozvbsN+Bq2Cu6qryO8NI/tjzoDA7VdHJ6diW1TQT4QiN+zq1k51TlFLSv5M3AkCARoIlsKYIaqA/OpQOtLKkmTID8UWlZAtm0yFtBdeh3VTZZrXMCPusJpLVuXUKx9ewZYI+9wRkvc8rNJAFiIDy2gMdNMQNT+giH9iMT5cjsRh3aMnv1eAZE/3C6q2gCF/eFlDRaV+vNdpZR4+TQPfZZz80RXIPNjwjysOdOBevg5XevnF0XUURqV4fdgF2nML7TY68bYlUS/B/zng2gpMpWyXG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 21:36, David Hildenbrand (Arm) wrote:
> On 3/12/26 21:32, David Hildenbrand (Arm) wrote:
>> On 2/26/26 04:23, Nico Pache wrote:
>>> generalize the order of the __collapse_huge_page_* functions
>>> to support future mTHP collapse.
>>>
>>> mTHP collapse will not honor the khugepaged_max_ptes_shared or
>>> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
>>> shared or swapped entry.
>>>
>>> No functional changes in this patch.
>>>
>>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Co-developed-by: Dev Jain <dev.jain@arm.com>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>>  mm/khugepaged.c | 73 +++++++++++++++++++++++++++++++------------------
>>>  1 file changed, 47 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index a9b645402b7f..ecdbbf6a01a6 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -535,7 +535,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>>  
>>>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>>> -		struct list_head *compound_pagelist)
>>> +		unsigned int order, struct list_head *compound_pagelist)
>>>  {
>>>  	struct page *page = NULL;
>>>  	struct folio *folio = NULL;
>>> @@ -543,15 +543,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>  	pte_t *_pte;
>>>  	int none_or_zero = 0, shared = 0, referenced = 0;
>>>  	enum scan_result result = SCAN_FAIL;
>>> +	const unsigned long nr_pages = 1UL << order;
>>> +	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
>>
>> It might be a bit more readable to move "const unsigned long
>> nr_pages = 1UL << order;" all the way to the top.
>>
>> Then, have here
>>
>> 	int max_ptes_none = 0;
>>
>> and do at the beginning of the function:
>>
>> 	/* For MADV_COLLAPSE, we always collapse ... */
>> 	if (!cc->is_khugepaged)
>> 		max_ptes_none = HPAGE_PMD_NR;
>> 	/*  ... except if userfaultf relies on MISSING faults. */
>> 	if (!userfaultfd_armed(vma))
>> 		max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
>>
>> (but see below regarding helper function)
>>
>> then the code below becomes ...
>>
>>>  
>>> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>>> +	for (_pte = pte; _pte < pte + nr_pages;
>>>  	     _pte++, addr += PAGE_SIZE) {
>>>  		pte_t pteval = ptep_get(_pte);
>>>  		if (pte_none_or_zero(pteval)) {
>>>  			++none_or_zero;
>>>  			if (!userfaultfd_armed(vma) &&
>>>  			    (!cc->is_khugepaged ||
>>> -			     none_or_zero <= khugepaged_max_ptes_none)) {
>>> +			     none_or_zero <= max_ptes_none)) {
>>
>> ...
>>
>> 	if (none_or_zero <= max_ptes_none) {
>>
>>
>> I see that you do something like that (but slightly different) in the next
>> patch. You could easily extend the above by it.
>>
>> Or go one step further and move all of that conditional into collapse_max_ptes_none(), whereby
>> you simply also pass the cc and the vma.
>>
>> Then this all gets cleaned up and you'd end up above with
>>
>> max_ptes_none = collapse_max_ptes_none(cc, vma, order);
>> if (max_ptes_none < 0)
>> 	return result;
>>
>> I'd do all that in this patch here, getting rid of #4.
>>
>>
>>>  				continue;
>>>  			} else {
>>>  				result = SCAN_EXCEED_NONE_PTE;
>>> @@ -585,8 +587,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>  		/* See collapse_scan_pmd(). */
>>>  		if (folio_maybe_mapped_shared(folio)) {
>>>  			++shared;
>>> -			if (cc->is_khugepaged &&
>>> -			    shared > khugepaged_max_ptes_shared) {
>>> +			/*
>>> +			 * TODO: Support shared pages without leading to further
>>> +			 * mTHP collapses. Currently bringing in new pages via
>>> +			 * shared may cause a future higher order collapse on a
>>> +			 * rescan of the same range.
>>> +			 */
>>> +			if (!is_pmd_order(order) || (cc->is_khugepaged &&
>>> +			    shared > khugepaged_max_ptes_shared)) {
>>
>> That's not how we indent within a nested ().
>>
>> To make this easier to read, what about similarly having at the beginning
>> of the function:
>>
>> int max_ptes_shared = 0;
>>
>> /* For MADV_COLLAPSE, we always collapse. */
>> if (cc->is_khugepaged)
>> 	max_ptes_none = HPAGE_PMD_NR;
>> /* TODO ... */
>> if (is_pmd_order(order))
>> 	max_ptes_none = khugepaged_max_ptes_shared;
>>
>> to turn this code into a
>>
>> 	if (shared > khugepaged_max_ptes_shared)
>>
>> Also, here, might make sense to have a collapse_max_ptes_swap(cc, order)
>> to do that and clean it up.
>>
>>
>>>  				result = SCAN_EXCEED_SHARED_PTE;
>>>  				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>>>  				goto out;
>>> @@ -679,18 +687,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>  }
>>>  
>>>  static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>>> -						struct vm_area_struct *vma,
>>> -						unsigned long address,
>>> -						spinlock_t *ptl,
>>> -						struct list_head *compound_pagelist)
>>> +		struct vm_area_struct *vma, unsigned long address,
>>> +		spinlock_t *ptl, unsigned int order,
>>> +		struct list_head *compound_pagelist)
>>>  {
>>> -	unsigned long end = address + HPAGE_PMD_SIZE;
>>> +	unsigned long end = address + (PAGE_SIZE << order);
>>>  	struct folio *src, *tmp;
>>>  	pte_t pteval;
>>>  	pte_t *_pte;
>>>  	unsigned int nr_ptes;
>>> +	const unsigned long nr_pages = 1UL << order;
>>
>> Move it further to the top.
>>
>>>  
>>> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
>>> +	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
>>>  	     address += nr_ptes * PAGE_SIZE) {
>>>  		nr_ptes = 1;
>>>  		pteval = ptep_get(_pte);
>>> @@ -743,13 +751,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>>>  }
>>>  
>>>  static void __collapse_huge_page_copy_failed(pte_t *pte,
>>> -					     pmd_t *pmd,
>>> -					     pmd_t orig_pmd,
>>> -					     struct vm_area_struct *vma,
>>> -					     struct list_head *compound_pagelist)
>>> +		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
>>> +		unsigned int order, struct list_head *compound_pagelist)
>>>  {
>>>  	spinlock_t *pmd_ptl;
>>> -
>>> +	const unsigned long nr_pages = 1UL << order;
>>>  	/*
>>>  	 * Re-establish the PMD to point to the original page table
>>>  	 * entry. Restoring PMD needs to be done prior to releasing
>>> @@ -763,7 +769,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>>>  	 * Release both raw and compound pages isolated
>>>  	 * in __collapse_huge_page_isolate.
>>>  	 */
>>> -	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
>>> +	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
>>>  }
>>>  
>>>  /*
>>> @@ -783,16 +789,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>>>   */
>>>  static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>>>  		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
>>> -		unsigned long address, spinlock_t *ptl,
>>> +		unsigned long address, spinlock_t *ptl, unsigned int order,
>>>  		struct list_head *compound_pagelist)
>>>  {
>>>  	unsigned int i;
>>>  	enum scan_result result = SCAN_SUCCEED;
>>> -
>>> +	const unsigned long nr_pages = 1UL << order;
>>
>> Same here, all the way to the top.
>>
>>>  	/*
>>>  	 * Copying pages' contents is subject to memory poison at any iteration.
>>>  	 */
>>> -	for (i = 0; i < HPAGE_PMD_NR; i++) {
>>> +	for (i = 0; i < nr_pages; i++) {
>>>  		pte_t pteval = ptep_get(pte + i);
>>>  		struct page *page = folio_page(folio, i);
>>>  		unsigned long src_addr = address + i * PAGE_SIZE;
>>> @@ -811,10 +817,10 @@ static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *foli
>>>  
>>>  	if (likely(result == SCAN_SUCCEED))
>>>  		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
>>> -						    compound_pagelist);
>>> +						    order, compound_pagelist);
>>>  	else
>>>  		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
>>> -						 compound_pagelist);
>>> +						 order, compound_pagelist);
>>>  
>>>  	return result;
>>>  }
>>> @@ -985,12 +991,12 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
>>>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
>>>   */
>>>  static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>>> -		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
>>> -		int referenced)
>>> +		struct vm_area_struct *vma, unsigned long start_addr,
>>> +		pmd_t *pmd, int referenced, unsigned int order)
>>>  {
>>>  	int swapped_in = 0;
>>>  	vm_fault_t ret = 0;
>>> -	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
>>> +	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
>>>  	enum scan_result result;
>>>  	pte_t *pte = NULL;
>>>  	spinlock_t *ptl;
>>> @@ -1022,6 +1028,19 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
>>>  		    pte_present(vmf.orig_pte))
>>>  			continue;
>>>  
>>> +		/*
>>> +		 * TODO: Support swapin without leading to further mTHP
>>> +		 * collapses. Currently bringing in new pages via swapin may
>>> +		 * cause a future higher order collapse on a rescan of the same
>>> +		 * range.
>>> +		 */
>>> +		if (!is_pmd_order(order)) {
>>> +			pte_unmap(pte);
>>> +			mmap_read_unlock(mm);
>>> +			result = SCAN_EXCEED_SWAP_PTE;
>>> +			goto out;
>>> +		}
>>> +
>>
>> Interesting, we just swapin everything we find :)
>>
>> But do we really need this check here? I mean, we just found it to be present.
>>
>> In the rare event that there was a race, do we really care? It was just
>> present, now it's swapped. Bad luck. Just swap it in.
>>
> 
> Okay, now I am confused. Why are you not taking care of
> collapse_scan_pmd() in the same context?
> 
> Because if you make sure that we properly check against a max_ptes_swap
> similar as in the style above, we'd rule out swapin right from the start?
> 
> Also, I would expect that all other parameters in there are similarly
> handled?
> 

Okay, I think you should add the following:

From 17bce81ab93f3b16e044ac2f4f62be19aac38180 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Mar 2026 21:54:22 +0100
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 89 +++++++++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 36 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b7b4680d27ab..6a3773bfa0a2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -318,6 +318,34 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
 	return count;
 }
 
+static int collapse_max_ptes_none(struct collapse_control *cc,
+		struct vm_area_struct *vma)
+{
+	/* We don't mess with MISSING faults. */
+	if (vma && userfaultfd_armed(vma))
+		return 0;
+	/* MADV_COLLAPSE always collapses. */
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	return khugepaged_max_ptes_none;
+}
+
+static int collapse_max_ptes_shared(struct collapse_control *cc)
+{
+	/* MADV_COLLAPSE always collapses. */
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	return khugepaged_max_ptes_shared;
+}
+
+static int collapse_max_ptes_swap(struct collapse_control *cc)
+{
+	/* MADV_COLLAPSE always collapses. */
+	if (!cc->is_khugepaged)
+		return HPAGE_PMD_NR;
+	return khugepaged_max_ptes_swap;
+}
+
 static struct kobj_attribute khugepaged_max_ptes_shared_attr =
 	__ATTR_RW(max_ptes_shared);
 
@@ -539,6 +567,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
 		struct list_head *compound_pagelist)
 {
+	const int max_ptes_none = collapse_max_ptes_none(cc, vma);
+	const int max_ptes_shared = collapse_max_ptes_shared(cc);
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
@@ -550,16 +580,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
+			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 				goto out;
 			}
+			continue;
 		}
 		if (!pte_present(pteval)) {
 			result = SCAN_PTE_NON_PRESENT;
@@ -586,9 +612,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/* See hpage_collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
+			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out;
@@ -1247,6 +1271,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *mmap_locked, struct collapse_control *cc)
 {
+	const int max_ptes_none = collapse_max_ptes_none(cc, vma);
+	const int max_ptes_swap = collapse_max_ptes_swap(cc);
+	const int max_ptes_shared = collapse_max_ptes_shared(cc);
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
 	int none_or_zero = 0, shared = 0, referenced = 0;
@@ -1280,36 +1307,28 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
+			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 				goto out_unmap;
 			}
+			continue;
 		}
 		if (!pte_present(pteval)) {
-			++unmapped;
-			if (!cc->is_khugepaged ||
-			    unmapped <= khugepaged_max_ptes_swap) {
-				/*
-				 * Always be strict with uffd-wp
-				 * enabled swap entries.  Please see
-				 * comment below for pte_uffd_wp().
-				 */
-				if (pte_swp_uffd_wp_any(pteval)) {
-					result = SCAN_PTE_UFFD_WP;
-					goto out_unmap;
-				}
-				continue;
-			} else {
+			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				goto out_unmap;
 			}
+			/*
+			 * Always be strict with uffd-wp enabled swap entries.
+			 * See the comment below for pte_uffd_wp().
+			 */
+			if (pte_swp_uffd_wp_any(pteval)) {
+				result = SCAN_PTE_UFFD_WP;
+				goto out_unmap;
+			}
+			continue;
 		}
 		if (pte_uffd_wp(pteval)) {
 			/*
@@ -1348,9 +1367,7 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 * is shared.
 		 */
 		if (folio_maybe_mapped_shared(folio)) {
-			++shared;
-			if (cc->is_khugepaged &&
-			    shared > khugepaged_max_ptes_shared) {
+			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
 				goto out_unmap;
@@ -2305,6 +2322,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 		unsigned long addr, struct file *file, pgoff_t start,
 		struct collapse_control *cc)
 {
+	const int max_ptes_none = collapse_max_ptes_none(cc, NULL);
+	const int max_ptes_swap = collapse_max_ptes_swap(cc);
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
@@ -2323,8 +2342,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 
 		if (xa_is_value(folio)) {
 			swap += 1 << xas_get_order(&xas);
-			if (cc->is_khugepaged &&
-			    swap > khugepaged_max_ptes_swap) {
+			if (swap > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				break;
@@ -2395,8 +2413,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 		cc->progress += HPAGE_PMD_NR;
 
 	if (result == SCAN_SUCCEED) {
-		if (cc->is_khugepaged &&
-		    present < HPAGE_PMD_NR - khugepaged_max_ptes_none) {
+		if (present < HPAGE_PMD_NR - max_ptes_none) {
 			result = SCAN_EXCEED_NONE_PTE;
 			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
-- 
2.43.0


Then extend it by passing an order + return value check in this patch here. You can
directly squash changes from patch #4 in here then.

-- 
Cheers,

David

