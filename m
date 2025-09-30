Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75461CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E218E000B; Tue, 30 Sep 2025 01:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE5F8E0002; Tue, 30 Sep 2025 01:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD928E000B; Tue, 30 Sep 2025 01:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC378E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:29:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F071BA50B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:29:29 +0000 (UTC)
X-FDA: 83944788858.03.43CC13A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 828AE40007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:29:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759210167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6a7nF/Zm+qVrnFfForPcR7ff6+QOW/ZD4srf5I8XNrA=;
	b=ab1IygH26Sv7zLhXyLTWzYdpYGqDKxn4BF6hbSHN1jqFOsHDTt07BzOeLKB8uf7N64JnyO
	x+u4DDlHDLirAbkPvKyylxGkqVhDyU6sATOSIY6ELnk77W+oJXVKepExnopRJ0KYpfqCvl
	7Yg4S2f9zM5mtG3oLYCkni7Fh/OCMPQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759210167; a=rsa-sha256;
	cv=none;
	b=lQDZLJv3Ye17VaS/sA/F95XHxC94yneZsHrM/2JbXRt871yJgkkcwTsALhY0teG6sfKkv4
	dKsun6IX9SrsjudyfxGSOu7sTuKWO7RSG4aFA6NLZ4q0BAIYTh4gzIV4wceObgzkMI1BbD
	DsSIbShYu55Cmg/agSQbE5aihW6eN5Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95FEA1424;
	Mon, 29 Sep 2025 22:29:18 -0700 (PDT)
Received: from [10.164.18.53] (MacBook-Pro.blr.arm.com [10.164.18.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50DEF3F5A1;
	Mon, 29 Sep 2025 22:29:18 -0700 (PDT)
Message-ID: <68cff704-bbdb-41a7-81d4-7195f71ba73a@arm.com>
Date: Tue, 30 Sep 2025 10:59:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
To: Lance Yang <lance.yang@linux.dev>
Cc: peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, ryan.roberts@arm.com, npache@redhat.com,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, jannh@google.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 usamaarif642@gmail.com, yuzhao@google.com, lorenzo.stoakes@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com
References: <20250930043351.34927-1-lance.yang@linux.dev>
 <0c498301-7434-4b2b-b7bc-73abe2057b67@arm.com>
 <668bfb74-014c-4fd5-a636-ff5ec17861c3@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <668bfb74-014c-4fd5-a636-ff5ec17861c3@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 828AE40007
X-Rspamd-Server: rspam05
X-Stat-Signature: jr6gjtuwgnkcwp1iesetcd8yakybwjo9
X-Rspam-User: 
X-HE-Tag: 1759210167-701944
X-HE-Meta: U2FsdGVkX191CHlTznJ8FPyysybBLCx4PuwIIENA9Mms1VenAky4NVfutZKaymIhSiSE6rMwFBEJqjiPBo7MuSfUQW9K9BmRgc1MBnr3O5KCov3uNH1gGFeuoCKYE58fifR4Mn9UPXZx5eUOf6Vw9EMyzUkuXngRnGFXlN6u60OFWuk+4Eq0iXXYxkZjs1pxKoofsZ+vJehDbam/9o9fm07PpvTdcElTblZcfdqonyaa/Fcu4On0Vld1CENPUncV8QrNaA9lt/AjS1YbZPCLbYVsfPEP84d+vWaJp82IbkkSmxL96A7x9712i0saBQ26hpeZgJj6nGQUD4Fi2w/GtcD+V4zV/K74rPQAuUCnb8Tu8TBR/Pdy/7zPg4N2IxCC8xeCtCIHAkAJC5UyYV4pdK2WOo9k3wGDwmuxUBhpJNIl3Kd9S9YXpPXVHpKJHDk4GQsYPeTiZDASexF9zEz6qbJhXxSBirPa48gm72nRG6q4zruBd7fT2o71lzMV62GeNGNHiV7W41igy7dM6efduCQrC+VSM1WrfCbZhJ2+jwsJ02ZbiX2KBtFaknRVHh+h56AKRrwaMuMRHHAXCT9XzqmrSBG3ARibhN7GfKUHw4EZLAOll8h4zepaIufDzvNLUcAV+v9F1D6jnFYXgv6bs3yBmVpzrpO0gBJIVtw58W/S+1hZ+CqcLGxsuQ27IZVrXUHipfeGW0hfRDnn9wShGi7Iu//ZqMB1oeAJMWCBExmRUnMZJ2JlNeN5gswp32o2ciW18OW714kb1qxuvVtuaFdNFsF4cCXZoQklcrprkDiX6DniMrcJmNuClR+CO25Ka1FY6IYyeh6Yh1G7tBYHn1iagwaNSssrP02EuvuGzaFSiz4vTZ7Jmh87x2xGMH54
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 30/09/25 10:52 am, Lance Yang wrote:
>
>
> On 2025/9/30 12:50, Dev Jain wrote:
>>
>> On 30/09/25 10:03 am, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> When splitting an mTHP and replacing a zero-filled subpage with the 
>>> shared
>>> zeropage, try_to_map_unused_to_zeropage() currently drops several 
>>> important
>>> PTE bits.
>>>
>>> For userspace tools like CRIU, which rely on the soft-dirty 
>>> mechanism for
>>> incremental snapshots, losing the soft-dirty bit means modified 
>>> pages are
>>> missed, leading to inconsistent memory state after restore.
>>>
>>> As pointed out by David, the more critical uffd-wp bit is also dropped.
>>> This breaks the userfaultfd write-protection mechanism, causing writes
>>> to be silently missed by monitoring applications, which can lead to 
>>> data
>>> corruption.
>>>
>>> Preserve both the soft-dirty and uffd-wp bits from the old PTE when
>>> creating the new zeropage mapping to ensure they are correctly tracked.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage 
>>> when splitting isolated thp")
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Suggested-by: Dev Jain <dev.jain@arm.com>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>> v1 -> v2:
>>>   - Avoid calling ptep_get() multiple times (per Dev)
>>>   - Double-check the uffd-wp bit (per David)
>>>   - Collect Acked-by from David - thanks!
>>>   - https://lore.kernel.org/linux-mm/20250928044855.76359-1- 
>>> lance.yang@linux.dev/
>>>
>>>   mm/migrate.c | 9 ++++++++-
>>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index ce83c2c3c287..50aa91d9ab4e 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -300,13 +300,14 @@ static bool 
>>> try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>>>                         unsigned long idx)
>>>   {
>>>       struct page *page = folio_page(folio, idx);
>>> +    pte_t oldpte = ptep_get(pvmw->pte);
>>
>> What I meant to say was, you can pass oldpte from 
>> remove_migration_pte to this
>> function. Basically define old_pte = ptep_get(pvmw.pte) in the 
>> declarations of
>> the start of the while block in remove_migration_pte and remove the 
>> existing
>> one. That will ensure ptep_get() gets called only once per iteration.
>
> Ah, got it. Thanks for the clarification!
>
> IIUC, you mean something like this:
>
> ```
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ce83c2c3c287..bafd8cb3bebe 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -297,6 +297,7 @@ bool isolate_folio_to_list(struct folio *folio, 
> struct list_head *list)
>
>  static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk 
> *pvmw,
>                        struct folio *folio,
> +                      pte_t old_pte,
>                        unsigned long idx)
>  {
>      struct page *page = folio_page(folio, idx);
> @@ -306,7 +307,7 @@ static bool try_to_map_unused_to_zeropage(struct 
> page_vma_mapped_walk *pvmw,
>          return false;
>      VM_BUG_ON_PAGE(!PageAnon(page), page);
>      VM_BUG_ON_PAGE(!PageLocked(page), page);
> -    VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
> +    VM_BUG_ON_PAGE(pte_present(old_pte), page);
>
>      if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & 
> VM_LOCKED) ||
>          mm_forbids_zeropage(pvmw->vma->vm_mm))
> @@ -322,6 +323,12 @@ static bool try_to_map_unused_to_zeropage(struct 
> page_vma_mapped_walk *pvmw,
>
>      newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>                      pvmw->vma->vm_page_prot));
> +
> +    if (pte_swp_soft_dirty(old_pte))
> +        newpte = pte_mksoft_dirty(newpte);
> +    if (pte_swp_uffd_wp(old_pte))
> +        newpte = pte_mkuffd_wp(newpte);
> +
>      set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>
>      dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
> @@ -344,7 +351,7 @@ static bool remove_migration_pte(struct folio *folio,
>
>      while (page_vma_mapped_walk(&pvmw)) {
>          rmap_t rmap_flags = RMAP_NONE;
> -        pte_t old_pte;
> +        pte_t old_pte = ptep_get(pvmw.pte);
>          pte_t pte;
>          swp_entry_t entry;
>          struct page *new;
> @@ -365,12 +372,11 @@ static bool remove_migration_pte(struct folio 
> *folio,
>          }
>  #endif
>          if (rmap_walk_arg->map_unused_to_zeropage &&
> -            try_to_map_unused_to_zeropage(&pvmw, folio, idx))
> +            try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
>              continue;
>
>          folio_get(folio);
>          pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
> -        old_pte = ptep_get(pvmw.pte);
>
>          entry = pte_to_swp_entry(old_pte);
>          if (!is_migration_entry_young(entry))
> ```
>
> ptep_get() gets called only once per iteration, right?

Yup.

