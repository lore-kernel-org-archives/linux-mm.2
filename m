Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F01C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6446B0092; Sat, 27 Jun 2026 03:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CD9C6B0093; Sat, 27 Jun 2026 03:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C676B0096; Sat, 27 Jun 2026 03:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23CB66B0092
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:13:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99BE61A0460
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:13:48 +0000 (UTC)
X-FDA: 84924827736.15.8FA6BD6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 69DA040002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:13:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YoAljMYl;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782544426;
	b=wnI/A2zGRt7rTuwFy4i7mscgp48mFj1/BX5ctiZuO1LcVYNn0oL40s4hlzlDw3rlnMLGhz
	01r2HxJaTLkrH//CTlCpZBS2pE/mKCeDIXkkAMbaxLkETXN3ywcLgm/fBjYbEgcrR6oW6+
	NcNwwzFSkEUZsGWR9gd9a4Tc13Q5rNI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782544426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOdSpA3wposle3Rm+E57Ywcku8iRVBjyEZ9SSpSpikA=;
	b=VGWGBtvQ8H0XdlzuHiOO2F/x13djKU+D3ZP5Crur7M6Y4PZb5fCGwKui6iszAXR7E7DY5U
	UeUWJ05n8LQEDlNwsHhq7MipfyL0XKYsnP+Xhyexby7RrYwM5QBRsLJRUbK8tAQbZK7MFo
	UZUn9vBjZARHEOAh0HDEEWDUg3Du5Sc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YoAljMYl;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B16DA288E;
	Sat, 27 Jun 2026 00:13:40 -0700 (PDT)
Received: from [10.163.169.90] (unknown [10.163.169.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 82A553F836;
	Sat, 27 Jun 2026 00:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782544425; bh=yRcIUZDb9qKuUQnLFd+ReKJj5Icp/O6BCQEU3OKwLUQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YoAljMYl9iNda7vAS8dBUIz4EirPI6ctqUn5dx7zY9xMkmZW6DEJYPeF0vuZZDQ6Q
	 n4jYHioUUcRIeMy3crLUHOfSmQBOVSyB66DqmYHjT5+VXBlfvOA0KOsp7Kse8LbzXP
	 tTDw7axhmhHktS5IEVPDiFsI3khCFUlIAbi5EaQg=
Message-ID: <82395f5a-31d4-406b-b7ec-10d1a9d067d4@arm.com>
Date: Sat, 27 Jun 2026 12:43:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
To: Lance Yang <lance.yang@linux.dev>, linmiaohe@huawei.com
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 ljs@kernel.org, david@kernel.org, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcampbell@nvidia.com,
 apopple@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, mel@csn.ul.ie,
 nao.horiguchi@gmail.com, ak@linux.intel.com, j-nomura@ce.jp.nec.com,
 pfalcato@suse.de, dave.hansen@intel.com, tglx@kernel.org,
 jpoimboe@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 stable@vger.kernel.org
References: <e6d1b813-0893-458e-9d58-8d3a9bd979c4@arm.com>
 <20260626141031.14309-1-lance.yang@linux.dev>
 <61e9fcf7-02a5-4285-948b-62fba4dcd69c@arm.com>
 <edee8461-34c6-41e9-ae0c-076380d92ebb@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <edee8461-34c6-41e9-ae0c-076380d92ebb@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kn6d79mfurazgjfswwjwgu6rkupcoxge
X-Rspamd-Queue-Id: 69DA040002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782544426-895414
X-HE-Meta: U2FsdGVkX1+8K6jOeosSFKq72Lu8YPE5EVADsPPTSJbSYyGowgMYXV7HqFdlPtg/YN7iHrUEI4baFqWV5hJO1QyrCR8tN5RymCjfIHpGFSOjuwjr4QXiFx1Bfladtqtk3s23Mw5pFz5ijtImk9rugNd36SKL2720J2t1JNUuRwPLudpIO7zjGPybZXjAtTa99mbTlMw7Jfl+37D2/p2N+0ZwFee82sMC5CWOFZJoUa2lS1CUg2i2I7kjnfQnhyTBFlEi0p3fvIpgAjMTJlMa8pC9zAqpFKmEQsgus40cIZt3V0Fa5+t8cerMN7crs5UpIgp4zxIsx3BoxuGbzYfjHW9Gb1F7zu9L+G3bJ9GBhxjUmPkWBcV8o67IR/u5KqCiEMeKJu8i+K4EwcaK5zueFk+YyJ++EeH+nznSY27G9Cy0c97wJIIZQjF9wQ1L4qfur8/pL6R9LCJ0QcnCh/p36PPUR+iwfx8KcBjXl+lF2RTE71PRXzAxZhwbIkpCNRU+tYXQ/Lo+jOFEOdEf2/wuaB/JMdPxNmopCtBy2yy4/trkGHWvgTTvUZVyQ6Vz/9HtvQHSfoSivltpK2UmiZUu4zQo2YWdL6+Zbv2Y2aCEQ4HUket5rPeyL2g0vUc8XFbOQiat0ZE7PsOXYoX/t9mNMZvXlmdAGjsiqaWoFamF9d5daUD3b1V9g3R0C15a0MB6Y3pk8dtcAj7ibIMGjpoSbQcKVePRUKy7grsBNcd7+KjoajaMMHMb8NQr0r4dNIusRo8EOmkCitspldVAWI05uJJCbAJf9HahoUyIUiEwsaP6VbjLrm2tEQkWlCqlqFTZ1hjOegfXdIOtzrTqwqk3SnFV0hahsSoHB9Mt9Igx5L1WfwECpzgiQmi1gszGLf/xVBIAiip2pOB0w4XP5fYnubArK10VXowndA6w//lYNcezW9NNOuRUSHPA3WsKlM/PlCR/Ac7hxGR+qD7Relc
 FMsFiERt
 JKNyOJcsmoTNaGorHFIPaXp0IDQLMpAmjBLJRV3gWPI5bEMcntCck+OO/FvsKfFbiknmEbzGRXsQAKGKjiyv2j1/9u1G5xp9jUi76RdNLhtTFIQQZ6/UVQ6Dl5A4xcxTTVh86AvI0VXBiVqg9RJ/0hbM7vuhHPqHMA/gEAY+1UPpFloSOUU5EXTgLE2pNY5F4XoRtT8VjX037bomk7mcQeo9oNqAId62r3uecCBsYisgwsQeimn+7Ff0+xhfO4l7/6bvvI1TYo5UKNXTZbKKYKC1/tCknkADvg7GlhSRNADHkteKShWYW0KLcZQnw+VmHM15xXSR1Eazy/afvZIV3cLi4wA1jviF5DWWyXaYn9j+eYQNxzqLC77015CarEz9OHVxvemnH8hyd7svvFVfmWfbIN+kolRFwaxO+15vhUjNHmlVsQI6LM/eT4qLJKbBHTS6m5bqt3oekdccd+yxft3SP+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/06/26 10:16 pm, Lance Yang wrote:
> 
> 
> On 2026/6/26 23:26, Dev Jain wrote:
>>
>>
>> On 26/06/26 7:40 pm, Lance Yang wrote:
>>>
>>> On Fri, Jun 26, 2026 at 06:53:10PM +0530, Dev Jain wrote:
>>>>
>>>>
>>>> On 26/06/26 1:18 pm, Lance Yang wrote:
>>>>>
>>>>> On Thu, Jun 25, 2026 at 11:29:53AM +0000, Dev Jain wrote:
>>>>>> check_pte() is the final validation step in page_vma_mapped_walk().
>>>>>> It reads pvmw->pte with ptep_get() to decide whether the entry maps
>>>>>> the PFN range being walked. For hugetlb VMAs, that pointer refers
>>>>>> to a hugetlb entry.
>>>>>>
>>>>>> On arches which provide their own huge_ptep_get() to dereference a huge
>>>>>> pte pointer, accessing via ptep_get() would cause pte_pfn(),
>>>>>> pte_present() etc to misbehave.
>>>>>>
>>>>>> It is not clear whether this has a trivially visible effect to userspace.
>>>>>>
>>>>>> Use huge_ptep_get() to dereference a huge pte pointer.
>>>>>>
>>>>>> Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>>>>> ---
>>>>>> mm/page_vma_mapped.c | 8 +++++++-
>>>>>> 1 file changed, 7 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>>> index 2ccbabfb2cc17..18e1d341f463c 100644
>>>>>> --- a/mm/page_vma_mapped.c
>>>>>> +++ b/mm/page_vma_mapped.c
>>>>>> @@ -107,7 +107,13 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>>>>>> static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>>> {
>>>>>>     unsigned long pfn;
>>>>>> -    pte_t ptent = ptep_get(pvmw->pte);
>>>>>> +    pte_t ptent;
>>>>>> +
>>>>>> +    if (is_vm_hugetlb_page(pvmw->vma))
>>>>>> +        ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>>>>>> +                      pvmw->pte);
>>>>>
>>>>> I think check_pte() can pass a wrong address to huge_ptep_get() ...
>>>>
>>>> Won't this be handled by rmap_walk_anon/rmap_walk_file - they are the ones
>>>> performing the rmap traversal and passing address to try_to_unmap_one/folio_referenced_one
>>>> etc ...
>>>
>>> Right, that should cover the rmap callbacks. The bit I was worried about
>>> is page_mapped_in_vma() though.
>>>
>>>>>
>>>>> Not sure that is wrong in the first place. For memory failure,
>>>>> page_mapped_in_vma() can be called with a poisoned tail page of a hugetlb
>>>>> folio. In that case, pvmw->address need not be hugepage-aligned.
>>>>>
>>>>> @Miaohe
>>>
>>> For hugetlb memory failure we start with the poisoned PFN:
>>>
>>> static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>>> {
>>>     ...
>>>     struct page *p = pfn_to_page(pfn);
>>>     struct folio *folio;
>>>     ...
>>>
>>>     folio = page_folio(p);
>>>
>>>     ...
>>>
>>>     if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
>>>         ...
>>>     }
>>>
>>>     ...
>>> }
>>>
>>> and pass the same p down:
>>>
>>> static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
>>>         unsigned long pfn, int flags)
>>> {
>>>     ...
>>>
>>>     collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
>>>
>>>     ...
>>> }
>>>
>>> static void collect_procs(const struct folio *folio, const struct page *page,
>>>         struct list_head *tokill, int force_early)
>>> {
>>>     ...
>>>
>>>     if (unlikely(folio_test_ksm(folio)))
>>>         ...
>>>     else if (folio_test_anon(folio))
>>>         collect_procs_anon(folio, page, tokill, force_early);
>>>     else
>>>         ...
>>> }
>>>
>>> So collect_procs_anon() still gets the poisoned page, not &folio->page:
>>>
>>> static void collect_procs_anon(const struct folio *folio,
>>>         const struct page *page, struct list_head *to_kill,
>>>         int force_early)
>>> {
>>>     ...
>>>
>>>     pgoff = page_pgoff(folio, page);
>>>     rcu_read_lock();
>>>     for_each_process(tsk) {
>>>         ...
>>>        
>>>         anon_vma_interval_tree_foreach(vmac, &av->rb_root,
>>>                            pgoff, pgoff) {
>>>             ...
>>>             addr = page_mapped_in_vma(page, vma);
>>>             ...
>>>         }
>>>     }
>>>     rcu_read_unlock();
>>>     anon_vma_unlock_read(av);
>>> }
>>>
>>> page_mapped_in_vma() then builds pvmw for that page:
>>>
>>> unsigned long page_mapped_in_vma(const struct page *page,
>>>         struct vm_area_struct *vma)
>>> {
>>>     const struct folio *folio = page_folio(page);
>>>     struct page_vma_mapped_walk pvmw = {
>>>         .pfn = page_to_pfn(page),
>>>         .nr_pages = 1,
>>>         .vma = vma,
>>>         .flags = PVMW_SYNC,
>>>     };
>>>
>>>     pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
>>>     ...
>>> }
>>>
>>> and page_pgoff() includes the subpage index:
>>>
>>> static inline pgoff_t page_pgoff(const struct folio *folio,
>>>         const struct page *page)
>>> {
>>>     return folio->index + folio_page_idx(folio, page);
>>> }
>>>
>>> So if the poisoned PFN points to a tail page, pvmw->address can be offset
>>> from the start of the hugetlb mapping by
>>>
>>> folio_page_idx(folio, page) << PAGE_SHIFT
>>>
>>> Should check_pte() pass the hugepage-aligned address to huge_ptep_get()
>>> for that case?
>>
>> Thanks! This looks correct.
>>
>> I can indeed fix this up in check_pte. But in the memory-failure path
>> it has always been confusing to me for hugetlb folios why we are bothering
>> with the tail page. I am sure that area can also be simplified. But for
>> now I'll just do a simple fix here itself.
> 
> Just thinking out loud: given that huge_ptep_get() already assumes that
> addr matches the huge pte, at least on arm64, would it make sense to
> have a small hugetlb wrapper around it that takes hstate and aligns
> the address before calling the arch helper?
> 
> Might make the rule clearer, and a bit harder to get wrong again :)

Are you suggesting something like:

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index fdb7bdf7645c..xxxxxxxxxxxx 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -825,6 +825,15 @@ static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,

 #include <asm/hugetlb.h>

+static inline pte_t hugetlb_ptep_get(struct vm_area_struct *vma,
+				     unsigned long addr, pte_t *ptep)
+{
+	struct hstate *h = hstate_vma(vma);
+
+	return huge_ptep_get(vma->vm_mm, addr & huge_page_mask(h), ptep);
+}
+
 #ifndef is_hugepage_only_range
 static inline int is_hugepage_only_range(struct mm_struct *mm,
 					unsigned long addr, unsigned long len)
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 18e1d341f463..xxxxxxxxxxxx 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -110,8 +110,7 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 	pte_t ptent;

 	if (is_vm_hugetlb_page(pvmw->vma))
-		ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
-				      pvmw->pte);
+		ptent = hugetlb_ptep_get(pvmw->vma, pvmw->address, pvmw->pte);
 	else
 		ptent = ptep_get(pvmw->pte);



> 
> Thanks, Lance
> 
>>
>>>
>>> Cheers, Lance
>>>
>>>>>
>>>>> For arm64, CONT_PMD_SIZE is one supported HugeTLB size. With such a VMA,
>>>>> page_vma_mapped_walk() passes that size to hugetlb_walk():
>>>>>
>>>>> bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>> {
>>>>>     ...
>>>>>     if (unlikely(is_vm_hugetlb_page(vma))) {
>>>>>         ...
>>>>>         pvmw->pte = hugetlb_walk(vma, pvmw->address, size);
>>>>>         ...
>>>>>     }
>>>>>     ...
>>>>> }
>>>>>
>>>>> hugetlb_walk() then calls arm64 huge_pte_offset(mm, addr, sz). For
>>>>> sz == CONT_PMD_SIZE, huge_pte_offset() aligns its local addr before
>>>>> calculating pmdp:
>>>>>
>>>>> pte_t *huge_pte_offset(struct mm_struct *mm,
>>>>>                unsigned long addr, unsigned long sz)
>>>>> {
>>>>>     ...
>>>>>     if (sz == CONT_PMD_SIZE)
>>>>>         addr &= CONT_PMD_MASK;
>>>>>
>>>>>     pmdp = pmd_offset(pudp, addr);
>>>>>     pmd = READ_ONCE(*pmdp);
>>>>>     ...
>>>>> }
>>>>>
>>>>> So for that case, pvmw->pte is calculated from the aligned addr, not
>>>>> necessarily from the original pvmw->address. But check_pte() passes the
>>>>> original address together with pvmw->pte:
>>>>>
>>>>> +        ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>>>>> +                      pvmw->pte);
>>>>>
>>>>> arm64 then uses that addr again to choose ncontig:
>>>>>
>>>>> pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>>>>> {
>>>>>     ...
>>>>>     ncontig = find_num_contig(mm, addr, ptep, &pgsize);
>>>>>     for (i = 0; i < ncontig; i++, ptep++) {
>>>>>         ...
>>>>>     }
>>>>>     return orig_pte;
>>>>> }
>>>>>
>>>>> static int find_num_contig(struct mm_struct *mm, unsigned long addr,
>>>>>                pte_t *ptep, size_t *pgsize)
>>>>> {
>>>>>     pgd_t *pgdp = pgd_offset(mm, addr);
>>>>>     p4d_t *p4dp;
>>>>>     pud_t *pudp;
>>>>>     pmd_t *pmdp;
>>>>>
>>>>>     *pgsize = PAGE_SIZE;
>>>>>     p4dp = p4d_offset(pgdp, addr);
>>>>>     pudp = pud_offset(p4dp, addr);
>>>>>     pmdp = pmd_offset(pudp, addr);
>>>>>     if ((pte_t *)pmdp == ptep) {
>>>>>         *pgsize = PMD_SIZE;
>>>>>         return CONT_PMDS;
>>>>>     }
>>>>>     return CONT_PTES;
>>>>> }
>>>>>
>>>>> With a tail address, pmdp may no longer point at pvmw->pte, so
>>>>> find_num_contig() can return CONT_PTES for a CONT_PMD HugeTLB mapping.
>>>>>
>>>>> On 16K arm64, that changes ncontig from 32 to 128. So huge_ptep_get()
>>>>> can walk past the CONT_PMD entries, and possibly past the PMD table.
>>>>>
>>>>> Should check_pte() pass the address matching pvmw->pte, sth like:
>>>>>
>>>>> ---8<---
>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>> index 406fd50bbd8f..58463493bd3d 100644
>>>>> --- a/mm/page_vma_mapped.c
>>>>> +++ b/mm/page_vma_mapped.c
>>>>> @@ -109,11 +109,14 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>>>>>       unsigned long pfn;
>>>>>       pte_t ptent;
>>>>>
>>>>> -    if (is_vm_hugetlb_page(pvmw->vma))
>>>>> -        ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
>>>>> -                      pvmw->pte);
>>>>> -    else
>>>>> +    if (is_vm_hugetlb_page(pvmw->vma)) {
>>>>> +        struct hstate *hstate = hstate_vma(pvmw->vma);
>>>>> +        unsigned long haddr = pvmw->address & huge_page_mask(hstate);
>>>>> +
>>>>> +        ptent = huge_ptep_get(pvmw->vma->vm_mm, haddr, pvmw->pte);
>>>>> +    } else {
>>>>>           ptent = ptep_get(pvmw->pte);
>>>>> +    }
>>>>>
>>>>>       if (pvmw->flags & PVMW_MIGRATION) {
>>>>>           const softleaf_t entry = softleaf_from_pte(ptent);
>>>>> -- 
>>>>>
>>>>> while leaving pvmw->address unchanged for page_mapped_in_vma()?
>>>>>
>>>>> Cheers, Lance
>>>>>
>>>>>> +    else
>>>>>> +        ptent = ptep_get(pvmw->pte);
>>>>>>
>>>>>>     if (pvmw->flags & PVMW_MIGRATION) {
>>>>>>         const softleaf_t entry = softleaf_from_pte(ptent);
>>>>>> -- 
>>>>>> 2.43.0
>>>>>>
>>>>>>
>>>>
>>>>
>>>
>>
> 
> 


