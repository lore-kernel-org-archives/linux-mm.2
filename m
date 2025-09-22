Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7ADDCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE5D8E0010; Mon, 22 Sep 2025 04:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C66F8E0001; Mon, 22 Sep 2025 04:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DC0F8E0010; Mon, 22 Sep 2025 04:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D01C8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:27:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA8B81DF9E9
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:27:02 +0000 (UTC)
X-FDA: 83916205884.28.E93B934
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id C6D4640002
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:27:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758529621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Np8lIknaB07HiYyqUuK/i2Yr+BN6l5nqhzXoQa9Vo9E=;
	b=3iVuSj8SumNfUWSLg9jX1Z3zvQaDEUKmIezzxTiagFQSyJ30Vr7Jbgoc7xU4P24fmGal6L
	qZ4oKQ09oE5m8v3I+jYFvLy5odJXZR0M6/CPrIeZ7BUCCjFD159vB3FaJanv7JZAzjDb8H
	h3YC3WJ1FBrn0L7wADDe55zGSlUqfYg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758529621; a=rsa-sha256;
	cv=none;
	b=tkxsaEcTiIJbuzOQcjDv+MaB/BiTNkhsU8CYp2gvqmhbN82sRT1U3gcuxqHBTvMgKaUaZw
	5Ll0yDLt0ax9LXyk+2Go5PfLqavTdw+Yf8uRBXDuVmGoJyUWjKIp+iryvD24by6hc4Ooaa
	fZB8kcWmwRPd76Z4k9YpOxrna7NJ8A8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B699E150C;
	Mon, 22 Sep 2025 01:26:51 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D66A33F66E;
	Mon, 22 Sep 2025 01:26:56 -0700 (PDT)
Message-ID: <433cba08-e33f-43ba-bccc-a2b1f2b1cd50@arm.com>
Date: Mon, 22 Sep 2025 13:56:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
To: David Hildenbrand <david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
 <4fb37530-3826-4ff5-ad7a-dc9dac4937de@arm.com>
 <20250920090228.lovkrpwj23bqdamj@master>
 <93095f34-d7ac-40c7-87c7-60d2c64d4800@arm.com>
 <20250922081226.hsglokm74lh2eng6@master>
 <89afa6d6-0a02-4825-8923-3752397b38dc@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <89afa6d6-0a02-4825-8923-3752397b38dc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pt9wkbmrwf5bx7t5kb1te5jejhz33o9d
X-Rspam-User: 
X-Rspamd-Queue-Id: C6D4640002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758529620-620207
X-HE-Meta: U2FsdGVkX19Vy/PGL7ZHm/j734CU/Mq94VJvh393yE+CGnvI9E256PjbX6WV54xIrNsnpVDvW1Bj2OwSFEmAqEHO+uNO7HD7c4sJm9LssLfxb3yB5lWy8k5bn823rRqEF7Fl1qd+e3dllJeVyRNaVXIVXXU+LPCraTdYlu2iGIM/l+AOURPSxnvcm6AxeNBjMVgINYgw1tHKBishTfgLXyrJw99E45BgviKYxLRAgaWv26gxJ980+vjD1Dvy4u2KMI/ccTyZQH1Chv8fuUo6yj35P9lumYzCZkGh6Ih1O5Vx6MVyFLWaXMjVk4zQxMONrIP6K3ZtkgEhmMljKb3CAdKT33rtEEn5UN4tHxmPMeJ/b2QZIr6GTKLdxM4T5nxqrxLzteagYDU9FHh/d/hDRFb/wp3x6yDYq5TB6368M51zOEUH28YBtgG5wCTVdhES8Hz+enQytrd0EN8W9S4mX4ed6is11RcIcNCTJftdwsQi1ST6WN1XXvTDTbn7Zz5b8JV6JKZia+cFyVXLvA50Vty32S30aBFsRyKBMo8zcW33Uhl0NaeEPJ3LNl/tvb5AoLEaHemprQhNyMMXpgvL91AzlO4gHAA4+7o5VB+6Q+PVqj+E8YrfL3kuG1toz56lbGy/sVCD7fSgSae6aOArjTgFLN+6SO6g2ZGh9vVQL0vA9WMirJUjC7zPGjrCt7LKYrpwoHDShez1p+BcvnViubc2E/NLmqBs41mwZe7R1YVjFl9WkolI6Y2qVPTdSmlhTnQ8VrjwjL3HXwERfHRAm/LbK+AmOlGHQ2mB6QbUet3W9IQm0VvA38A38Ne7YCfasTiw0VeiAgSGnBlUD5E3gffQmnYjT4Qbr417gi9gWm9WDwgJo3YYAg6oM2Jv626IVWKvfSyzeIV7ioBsEs3+TuvyM5NtgvDbjMuMaWChfzSupnm3LftiZbb3LE0pAShg8tuJOkR4doa7spTttvt
 THmzlVVy
 2LuHx+WjVSNXJjF+scSPBMR9yGd51A86qLy4+n7KRNsYdqmnloFmnRWGR3LiilBxYf6EEat6XoaHgbVpcZ343CROZYaUZYY2Qgnb7SRb+nWYN3V+YYWrjs779B6Be7wgslieVnSBAXF5zSlKaTJo21TqFra+cogSuWi3vgOA2dlQbh99smG19LhqxeqI08GUh86peRrullCOBIeMgXvK9nvrSUZhL/45GSU2VS6y8QNh9rkrpx9unYSKqeqhBOATo1LxkoPY+A4598r8FSw/BGKgPcmSvOTitBgBq6fzSXe/gT/tuXtl5EMLc/kOtuizvUu64Kgq3+XoCUjwSrgXQj8P3HrurdsmSduKp3TAptEz4VVpNLOuLcAdebw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 22/09/25 1:46 pm, David Hildenbrand wrote:
> On 22.09.25 10:12, Wei Yang wrote:
>> On Sat, Sep 20, 2025 at 06:01:59PM +0530, Dev Jain wrote:
>>>
>>> On 20/09/25 2:32 pm, Wei Yang wrote:
>>>> On Sat, Sep 20, 2025 at 10:21:56AM +0530, Dev Jain wrote:
>>>>> On 20/09/25 6:24 am, Wei Yang wrote:
>>>>>> When collapse a pmd, there are two address in use:
>>>>>>
>>>>>>      * address points to the start of pmd
>>>>>>      * address points to each individual page
>>>>>>
>>>>>> Current naming is not easy to distinguish these two and error prone.
>>>>>>
>>>>>> Name the first one to pmd_addr and second one to pte_addr.
>>>>>>
>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>>>> ---
>>>>>>     mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
>>>>>>     1 file changed, 22 insertions(+), 21 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>> index 4c957ce788d1..6d03072c1a92 100644
>>>>>> --- a/mm/khugepaged.c
>>>>>> +++ b/mm/khugepaged.c
>>>>>> @@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, 
>>>>>> pte_t *_pte,
>>>>>>     }
>>>>>>     static int __collapse_huge_page_isolate(struct vm_area_struct 
>>>>>> *vma,
>>>>>> -                    unsigned long address,
>>>>>> +                    unsigned long pmd_addr,
>>>>>>                         pte_t *pte,
>>>>>>                         struct collapse_control *cc,
>>>>>>                         struct list_head *compound_pagelist)
>>>>>>     {
>>>>>>         struct page *page = NULL;
>>>>>>         struct folio *folio = NULL;
>>>>>> +    unsigned long pte_addr = pmd_addr;
>>>>>>         pte_t *_pte;
>>>>>>         int none_or_zero = 0, shared = 0, result = SCAN_FAIL, 
>>>>>> referenced = 0;
>>>>>>         for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>>> -         _pte++, address += PAGE_SIZE) {
>>>>>> +         _pte++, pte_addr += PAGE_SIZE) {
>>>>>>             pte_t pteval = ptep_get(_pte);
>>>>>>             if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>>>>                 ++none_or_zero;
>>>>>> @@ -570,7 +571,7 @@ static int 
>>>>>> __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>>>>                 result = SCAN_PTE_UFFD_WP;
>>>>>>                 goto out;
>>>>>>             }
>>>>>> -        page = vm_normal_page(vma, address, pteval);
>>>>>> +        page = vm_normal_page(vma, pte_addr, pteval);
>>>>>>             if (unlikely(!page) || 
>>>>>> unlikely(is_zone_device_page(page))) {
>>>>>>                 result = SCAN_PAGE_NULL;
>>>>>>                 goto out;
>>>>>> @@ -655,8 +656,8 @@ static int 
>>>>>> __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>>>>              */
>>>>>>             if (cc->is_khugepaged &&
>>>>>>                 (pte_young(pteval) || folio_test_young(folio) ||
>>>>>> -             folio_test_referenced(folio) || 
>>>>>> mmu_notifier_test_young(vma->vm_mm,
>>>>>> -                                     address)))
>>>>>> +             folio_test_referenced(folio) ||
>>>>>> +             mmu_notifier_test_young(vma->vm_mm, pte_addr)))
>>>>>>                 referenced++;
>>>>>>         }
>>>>>> @@ -985,21 +986,21 @@ static int check_pmd_still_valid(struct 
>>>>>> mm_struct *mm,
>>>>>>      */
>>>>>>     static int __collapse_huge_page_swapin(struct mm_struct *mm,
>>>>>>                            struct vm_area_struct *vma,
>>>>>> -                       unsigned long haddr, pmd_t *pmd,
>>>>>> +                       unsigned long pmd_addr, pmd_t *pmd,
>>>>>>                            int referenced)
>>>>> Will this be a problem when mTHP collapse is in? You may have the 
>>>>> starting
>>>>> address lying in the PTE table.
>>>>>
>>>>> Personally "haddr" is pretty clear to me - I read it as 
>>>>> "huge-aligned addr".
>>>>> I will vote for naming the starting addresses everywhere as 
>>>>> "haddr", and use
>>>>> addr as the loop iterator. This is a short name and haddr will 
>>>>> imply that it
>>>>> is aligned to the huge order we are collapsing for.
>>>>>
>>>> So your suggestion is
>>>>
>>>>       pmd_addr -> haddr
>>>>       pte_addr -> address
>>>
>>> pmd_addr -> haddr
>>> pte_addr -> addr
>>>
>>
>> Take another look into the code.
>>
>> The change touch three functions:
>>
>>    __collapse_huge_page_isolate()
>>    __collapse_huge_page_swapin()
>>    hpage_collapse_scan_pmd()
>>
>> Use pmd_addr/pte_addr look reasonable for hpage_collapse_scan_pmd().
>> And haddr/addr would be suitable for the other two.
>
> haddr vs. addr is just nasty.
>
> Can we call the aligned one "aligned_addr" or something like that?

This works. Let us use aligned_addr/addr everywhere then.



