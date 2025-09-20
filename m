Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40315CAC5A5
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 12:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAB88E0005; Sat, 20 Sep 2025 08:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B908E0001; Sat, 20 Sep 2025 08:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671B38E0005; Sat, 20 Sep 2025 08:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51F268E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:32:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E01E4514DB
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:32:10 +0000 (UTC)
X-FDA: 83909566020.03.4434FDF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id CEDD180004
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:32:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758371529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E67EhJc11NAqZq0YXhDXh54+CObuM/iIVSAG/ORjN6o=;
	b=EnbHjquR/PwOARQli2KTNFb220RRjdaSxJTcSG5qbtSEMYNWAMocz+MrREAiwcxEUB1hkB
	72MkJfJyECxxah8l4Tw8LQFQCTiw1CB2qxl8yNjkhFLW0CqIxsaIKM2wAVPPTELDAWlCSs
	PDt+cWXZgBl05+7GR4bUb2RufDwea9I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758371529; a=rsa-sha256;
	cv=none;
	b=1e1yrH3RDmGdp55YJ257+kHUtuEgN4MK0JBrTEc0NcW+RTd0zKSn7IMEpn+uvliPJQZVvu
	PUlIig9hLo8YQuOwT9v9kKzu4NAXVyGWFrqeLFXiFQ9MEgeEhZB1jaQo3DGk2qmWWJhY4i
	xApAy7MhUT2BqT1rWhsrVLy8Jvrr9JY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83C9B1688;
	Sat, 20 Sep 2025 05:31:59 -0700 (PDT)
Received: from [10.163.75.160] (unknown [10.163.75.160])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 834F43F673;
	Sat, 20 Sep 2025 05:32:03 -0700 (PDT)
Message-ID: <93095f34-d7ac-40c7-87c7-60d2c64d4800@arm.com>
Date: Sat, 20 Sep 2025 18:01:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
 <4fb37530-3826-4ff5-ad7a-dc9dac4937de@arm.com>
 <20250920090228.lovkrpwj23bqdamj@master>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250920090228.lovkrpwj23bqdamj@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: atddkus7xq83gxzbtc469y1tftqgd7kt
X-Rspam-User: 
X-Rspamd-Queue-Id: CEDD180004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758371528-985928
X-HE-Meta: U2FsdGVkX1/fk1CQ2DIhk10pLO7h0d0tu5WL8sjuh76/2WDt1Buy6vDmI0T7FqdjpiLPBanUldC03V5+zfGSXbYKexfOz1qOO3upYeqEr8aAHFdj7jEVFdkiryWBk0Pi+m5XEMJKiy04svjlQXAVEfUH2niy6rbk7OVcD0tErJcTEQ8qYtESLYig0fBktxZ8d9Q2nnoHKSysQsbs+tvaJNMPNJgGqSaDwhuXoVk0EUH6PRESoWJQT36PGytSpesAJNMOcq8fd2pk+l3J7kMPSHQNsURMd5oKjwYqD9oySnKGgwbWXdWJ33Sqsl6TD/3ffmb6BaP4SvKfvWAhYrIDxxzP6A+534AITZDpe3nFgMdPnCK1Uuir6v/+pt20+EfQJdk1LZu2nm1yzyRx1jAwjZyUjkVA+OWEGVfBrKpx/tbAnVhRNJZ5S6Jyz94OM/tI3UwMthCMW3d3yG32X6TRaP1yzzlUfKllWfyucIx+ivpvKXa0+0YJvN2Ad78Rao6AfFgiH8i08GSRlbS5o/yZSWg0xNzjqPDwBOitVeW5fsGfPVxQsRatomO7mItHzfkkbuv01g2P6vZEQA12MYPuV8viVU5x14vC9ajgRIa13+vX22KWiW3vxWG6to39LyZXHoG/qYDBDkN4oHelIMpTIIrTwgWhG1jYxRl4icdN3CjR17BBxAflg2dBQ6+H3yiRT88BcvErKr4e4aLafc8FOHUpCTHIyVaa2vNubzC5I5rmu5OnZtkoPsFcJ9Pclrivumq9He0Nl/RcWIrNpebCXp4Pmzsy8PBygECG2wCpAgs66MAVzaJ/FopcNF7qSw8cXYA1GpJD7tVNzSqKFUOEuG9gR9C9p2756A4tKKw7hm5KuHpgwLGcAy/gLNoafJ7+C83SzR8/y9ArB6kJ0Y6ASi9rWpSDabCkeydTi8rkkeNyUEImv9HMLqSJTYQbBGFBYNXmfgRvwfycygRSFTt
 d5NiPdmy
 0cxuJSFyYA1v/uK5rdC1Ll2S9DQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20/09/25 2:32 pm, Wei Yang wrote:
> On Sat, Sep 20, 2025 at 10:21:56AM +0530, Dev Jain wrote:
>> On 20/09/25 6:24 am, Wei Yang wrote:
>>> When collapse a pmd, there are two address in use:
>>>
>>>     * address points to the start of pmd
>>>     * address points to each individual page
>>>
>>> Current naming is not easy to distinguish these two and error prone.
>>>
>>> Name the first one to pmd_addr and second one to pte_addr.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>    mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
>>>    1 file changed, 22 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 4c957ce788d1..6d03072c1a92 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>>    }
>>>    static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>> -					unsigned long address,
>>> +					unsigned long pmd_addr,
>>>    					pte_t *pte,
>>>    					struct collapse_control *cc,
>>>    					struct list_head *compound_pagelist)
>>>    {
>>>    	struct page *page = NULL;
>>>    	struct folio *folio = NULL;
>>> +	unsigned long pte_addr = pmd_addr;
>>>    	pte_t *_pte;
>>>    	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>>>    	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>>> -	     _pte++, address += PAGE_SIZE) {
>>> +	     _pte++, pte_addr += PAGE_SIZE) {
>>>    		pte_t pteval = ptep_get(_pte);
>>>    		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>    			++none_or_zero;
>>> @@ -570,7 +571,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>    			result = SCAN_PTE_UFFD_WP;
>>>    			goto out;
>>>    		}
>>> -		page = vm_normal_page(vma, address, pteval);
>>> +		page = vm_normal_page(vma, pte_addr, pteval);
>>>    		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
>>>    			result = SCAN_PAGE_NULL;
>>>    			goto out;
>>> @@ -655,8 +656,8 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>    		 */
>>>    		if (cc->is_khugepaged &&
>>>    		    (pte_young(pteval) || folio_test_young(folio) ||
>>> -		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
>>> -								     address)))
>>> +		     folio_test_referenced(folio) ||
>>> +		     mmu_notifier_test_young(vma->vm_mm, pte_addr)))
>>>    			referenced++;
>>>    	}
>>> @@ -985,21 +986,21 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>>>     */
>>>    static int __collapse_huge_page_swapin(struct mm_struct *mm,
>>>    				       struct vm_area_struct *vma,
>>> -				       unsigned long haddr, pmd_t *pmd,
>>> +				       unsigned long pmd_addr, pmd_t *pmd,
>>>    				       int referenced)
>> Will this be a problem when mTHP collapse is in? You may have the starting
>> address lying in the PTE table.
>>
>> Personally "haddr" is pretty clear to me - I read it as "huge-aligned addr".
>> I will vote for naming the starting addresses everywhere as "haddr", and use
>> addr as the loop iterator. This is a short name and haddr will imply that it
>> is aligned to the huge order we are collapsing for.
>>
> So your suggestion is
>
>      pmd_addr -> haddr
>      pte_addr -> address

pmd_addr -> haddr
pte_addr -> addr


>
> right?
>

