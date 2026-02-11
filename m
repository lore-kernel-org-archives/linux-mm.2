Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5BA4E9E309
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B746B008C; Wed, 11 Feb 2026 08:47:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413856B0092; Wed, 11 Feb 2026 08:47:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33FFB6B0093; Wed, 11 Feb 2026 08:47:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 213FF6B008C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:47:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E39831403F0
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:47:34 +0000 (UTC)
X-FDA: 84432303228.05.A358F62
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id F080618000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:47:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ePR8jNxW;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770817653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q94aU8hVrD2Cz9Q+Vt3sOezauMMhEOzzF4ikGazY7U8=;
	b=1bwM3Pw6T88cYKYfkrFvpb3Y4FNDb7w8c7kGBN25659JaoLfZICxNEtl0G2HEqvRKisnxL
	0eawUt3yQH93pSvAv7W5nZ1sZC8m+bFAvdFmdUl35U8SE2sFa70TppGlWB8Wl7EmtXV1AP
	IfECwzm9Itnbfiwm8ymJnfl7z1Drwm4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ePR8jNxW;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770817653; a=rsa-sha256;
	cv=none;
	b=svE1Z1Aj2VFwLvBJfnNiTKyXgVlqZNyBIqKkqONTqGxg869BdWo0JbX2BZZBGteoCL7xNT
	Bx1TiL98Eb8o26WKRb68IqUt7g6wfrymxcjUlWfmL3JfVMqUymzkxblPmR4jjqRojeg9Jn
	czBG2CBSv2BRjZRzEjkpnBAcFFEW14s=
Message-ID: <82d2de0a-c321-4254-aca0-7d63abd4f1af@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770817649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q94aU8hVrD2Cz9Q+Vt3sOezauMMhEOzzF4ikGazY7U8=;
	b=ePR8jNxWp/RuWD44UuIUtV57CJJ7MC5AGmEzSnqV3vvJ03qCM00qY4daJZSFUJSXAwKwsd
	Tio7FkevYDNIuek/76fxn2jECMZfh3KDngQhN1FcqvsD8FlX9ODOgwh5xckVXBiGBaYI1L
	BdOX+hd8CPTcKWowjtGFEvdxtokg3OY=
Date: Wed, 11 Feb 2026 13:47:16 +0000
MIME-Version: 1.0
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-2-usama.arif@linux.dev>
 <66386da6-6a7c-4968-9167-71f99dd498ad@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <66386da6-6a7c-4968-9167-71f99dd498ad@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F080618000F
X-Stat-Signature: 7z3p1yz9wg5jprchuoge1an9ctc5fmm5
X-Rspam-User: 
X-HE-Tag: 1770817652-66160
X-HE-Meta: U2FsdGVkX18nFx3HJTfwUl0WKfZWeRxyPwZk2l528J8OtqcZdPQQ0LxssCyyxtxOy+xmVR8GRiwKJhQ7oFrDUhPec0ZN6VY7ZKT17ZUiR9xDwXz/IdJ1W9I1YOKQtS1DUW2cl0P8WNHrrsVk5BMbek9/Bhxc0aafjkxqw0iBJk1WeR4YT6itlEcdP1qL+hThqfJRYPFaGAKWVER1EBfhMUp+Y7DT706hA4eo/MhdEzBAXik9fEO9Ywv52Sxs3+I8m/7TqXCB2T47nmAPVEGjTo1Al6hptLtQWhzytvhfkd33qrLAlveJTZW6I8RxhqYaB3vk0aMjEfD/n0oz8oFqftQf0tV/3XwHIZvv734ipDJdB6g0dk0/AEoh5mc++htwWecSDO/l7QnXjbYJTvwMhWwXWadsQt8LZevWcETAa+PUXKOsfqcPV2RO/iNPvj1LWsy3tV4GRbfT7x0u8KNHjPgKB4BicRXjnWWh2VDhNnPgn3kXNn7FlGJUj+MGYma9nOgtciU5O9Rgz9KbfzClS1osqTnsxZqX5bEHyhy1QtC7ijs2oA55pR480WWIs/Oi3/KNlkcBCG7awTgvZEQ81ptHsdEHUSRZg+bMB75Ti0rWyPSdVnWQQzxOwz4H5sTtbAio/A7+nMAkOoePq+cSiMiJ6VBeR+2wOEN4Wx1NRe0DiB8K4Jd2TnML2fOT64A2jKYIW1qAYDSlp2Q7NW8QPJ/x024gs+qYbDQQ+2rJLKsA2CWW4+RZLKikRAEawcaAdjUuewAnE4xy5NJ2Y/85y98c+CjVfIttQwIAk/puL/JmKUV+uak18PWds4iYqOgY/KaiZ/dDLoIA1Jq4Uj6IBcc1YFl98txFUZ+wLl7sBIi2j//Y3KAWVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/02/2026 13:35, David Hildenbrand (Arm) wrote:
> On 2/11/26 13:49, Usama Arif wrote:
>> When the kernel creates a PMD-level THP mapping for anonymous pages,
>> it pre-allocates a PTE page table and deposits it via
>> pgtable_trans_huge_deposit(). This deposited table is withdrawn during
>> PMD split or zap. The rationale was that split must not fail—if the
>> kernel decides to split a THP, it needs a PTE table to populate.
>>
>> However, every anon THP wastes 4KB (one page table page) that sits
>> unused in the deposit list for the lifetime of the mapping. On systems
>> with many THPs, this adds up to significant memory waste. The original
>> rationale is also not an issue. It is ok for split to fail, and if the
>> kernel can't find an order 0 allocation for split, there are much bigger
>> problems. On large servers where you can easily have 100s of GBs of THPs,
>> the memory usage for these tables is 200M per 100G. This memory could be
>> used for any other usecase, which include allocating the pagetables
>> required during split.
>>
>> This patch removes the pre-deposit for anonymous pages on architectures
>> where arch_needs_pgtable_deposit() returns false (every arch apart from
>> powerpc, and only when radix hash tables are not enabled) and allocates
>> the PTE table lazily—only when a split actually occurs. The split path
>> is modified to accept a caller-provided page table.
>>
>> PowerPC exception:
>>
>> It would have been great if we can completely remove the pagetable
>> deposit code and this commit would mostly have been a code cleanup patch,
>> unfortunately PowerPC has hash MMU, it stores hash slot information in
>> the deposited page table and pre-deposit is necessary. All deposit/
>> withdraw paths are guarded by arch_needs_pgtable_deposit(), so PowerPC
>> behavior is unchanged with this patch. On a better note,
>> arch_needs_pgtable_deposit will always evaluate to false at compile time
>> on non PowerPC architectures and the pre-deposit code will not be
>> compiled in.
>>
>> Why Split Failures Are Safe:
>>
>> If a system is under severe memory pressure that even a 4K allocation
>> fails for a PTE table, there are far greater problems than a THP split
>> being delayed. The OOM killer will likely intervene before this becomes an
>> issue.
>> When pte_alloc_one() fails due to not being able to allocate a 4K page,
>> the PMD split is aborted and the THP remains intact. I could not get split
>> to fail, as its very difficult to make order-0 allocation to fail.
>> Code analysis of what would happen if it does:
>>
>> - mprotect(): If split fails in change_pmd_range, it will fallback
>> to change_pte_range, which will return an error which will cause the
>> whole function to be retried again.
>>
>> - munmap() (partial THP range): zap_pte_range() returns early when
>> pte_offset_map_lock() fails, causing zap_pmd_range() to retry via pmd--.
>> For full THP range, zap_huge_pmd() unmaps the entire PMD without
>> split.
>>
>> - Memory reclaim (try_to_unmap()): Returns false, folio rotated back
>> LRU, retried in next reclaim cycle.
>>
>> - Migration / compaction (try_to_migrate()): Returns -EAGAIN, migration
>> skips this folio, retried later.
>>
>> - CoW fault (wp_huge_pmd()): Returns VM_FAULT_FALLBACK, fault retried.
>>
>> -  madvise (MADV_COLD/PAGEOUT): split_folio() internally calls
>> try_to_migrate() with TTU_SPLIT_HUGE_PMD. If PMD split fails,
>> try_to_migrate() returns false, split_folio() returns -EAGAIN,
>> and madvise returns 0 (success) silently skipping the region. This
>> should be fine. madvise is just an advice and can fail for other
>> reasons as well.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>   include/linux/huge_mm.h |   4 +-
>>   mm/huge_memory.c        | 144 ++++++++++++++++++++++++++++------------
>>   mm/khugepaged.c         |   7 +-
>>   mm/migrate_device.c     |  15 +++--
>>   mm/rmap.c               |  39 ++++++++++-
>>   5 files changed, 156 insertions(+), 53 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index a4d9f964dfdea..b21bb72a298c9 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -562,7 +562,7 @@ static inline bool thp_migration_supported(void)
>>   }
>>     void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>> -               pmd_t *pmd, bool freeze);
>> +               pmd_t *pmd, bool freeze, pgtable_t pgtable);
>>   bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>>                  pmd_t *pmdp, struct folio *folio);
>>   void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
>> @@ -660,7 +660,7 @@ static inline void split_huge_pmd_address(struct vm_area_struct *vma,
>>           unsigned long address, bool freeze) {}
>>   static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
>>                        unsigned long address, pmd_t *pmd,
>> -                     bool freeze) {}
>> +                     bool freeze, pgtable_t pgtable) {}
>>     static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>>                        unsigned long addr, pmd_t *pmdp,
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 44ff8a648afd5..4c9a8d89fc8aa 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1322,17 +1322,19 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>>       unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
>>       struct vm_area_struct *vma = vmf->vma;
>>       struct folio *folio;
>> -    pgtable_t pgtable;
>> +    pgtable_t pgtable = NULL;
>>       vm_fault_t ret = 0;
>>         folio = vma_alloc_anon_folio_pmd(vma, vmf->address);
>>       if (unlikely(!folio))
>>           return VM_FAULT_FALLBACK;
>>   -    pgtable = pte_alloc_one(vma->vm_mm);
>> -    if (unlikely(!pgtable)) {
>> -        ret = VM_FAULT_OOM;
>> -        goto release;
>> +    if (arch_needs_pgtable_deposit()) {
>> +        pgtable = pte_alloc_one(vma->vm_mm);
>> +        if (unlikely(!pgtable)) {
>> +            ret = VM_FAULT_OOM;
>> +            goto release;
>> +        }
>>       }
>>         vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
>> @@ -1347,14 +1349,18 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>>           if (userfaultfd_missing(vma)) {
>>               spin_unlock(vmf->ptl);
>>               folio_put(folio);
>> -            pte_free(vma->vm_mm, pgtable);
>> +            if (pgtable)
>> +                pte_free(vma->vm_mm, pgtable);
>>               ret = handle_userfault(vmf, VM_UFFD_MISSING);
>>               VM_BUG_ON(ret & VM_FAULT_FALLBACK);
>>               return ret;
>>           }
>> -        pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
>> +        if (pgtable) {
>> +            pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd,
>> +                           pgtable);
>> +            mm_inc_nr_ptes(vma->vm_mm);
>> +        }
>>           map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
>> -        mm_inc_nr_ptes(vma->vm_mm);
>>           spin_unlock(vmf->ptl);
>>       }
>>   @@ -1450,9 +1456,11 @@ static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
>>       pmd_t entry;
>>       entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
>>       entry = pmd_mkspecial(entry);
>> -    pgtable_trans_huge_deposit(mm, pmd, pgtable);
>> +    if (pgtable) {
>> +        pgtable_trans_huge_deposit(mm, pmd, pgtable);
>> +        mm_inc_nr_ptes(mm);
>> +    }
>>       set_pmd_at(mm, haddr, pmd, entry);
>> -    mm_inc_nr_ptes(mm);
>>   }
>>     vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>> @@ -1471,16 +1479,19 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>>       if (!(vmf->flags & FAULT_FLAG_WRITE) &&
>>               !mm_forbids_zeropage(vma->vm_mm) &&
>>               transparent_hugepage_use_zero_page()) {
>> -        pgtable_t pgtable;
>> +        pgtable_t pgtable = NULL;
>>           struct folio *zero_folio;
>>           vm_fault_t ret;
>>   -        pgtable = pte_alloc_one(vma->vm_mm);
>> -        if (unlikely(!pgtable))
>> -            return VM_FAULT_OOM;
>> +        if (arch_needs_pgtable_deposit()) {
>> +            pgtable = pte_alloc_one(vma->vm_mm);
>> +            if (unlikely(!pgtable))
>> +                return VM_FAULT_OOM;
>> +        }
>>           zero_folio = mm_get_huge_zero_folio(vma->vm_mm);
>>           if (unlikely(!zero_folio)) {
>> -            pte_free(vma->vm_mm, pgtable);
>> +            if (pgtable)
>> +                pte_free(vma->vm_mm, pgtable);
>>               count_vm_event(THP_FAULT_FALLBACK);
>>               return VM_FAULT_FALLBACK;
>>           }
>> @@ -1490,10 +1501,12 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>>               ret = check_stable_address_space(vma->vm_mm);
>>               if (ret) {
>>                   spin_unlock(vmf->ptl);
>> -                pte_free(vma->vm_mm, pgtable);
>> +                if (pgtable)
>> +                    pte_free(vma->vm_mm, pgtable);
>>               } else if (userfaultfd_missing(vma)) {
>>                   spin_unlock(vmf->ptl);
>> -                pte_free(vma->vm_mm, pgtable);
>> +                if (pgtable)
>> +                    pte_free(vma->vm_mm, pgtable);
>>                   ret = handle_userfault(vmf, VM_UFFD_MISSING);
>>                   VM_BUG_ON(ret & VM_FAULT_FALLBACK);
>>               } else {
>> @@ -1504,7 +1517,8 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>>               }
>>           } else {
>>               spin_unlock(vmf->ptl);
>> -            pte_free(vma->vm_mm, pgtable);
>> +            if (pgtable)
>> +                pte_free(vma->vm_mm, pgtable);
>>           }
>>           return ret;
>>       }
>> @@ -1836,8 +1850,10 @@ static void copy_huge_non_present_pmd(
>>       }
>>         add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>> -    mm_inc_nr_ptes(dst_mm);
>> -    pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
>> +    if (pgtable) {
>> +        mm_inc_nr_ptes(dst_mm);
>> +        pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
>> +    }
>>       if (!userfaultfd_wp(dst_vma))
>>           pmd = pmd_swp_clear_uffd_wp(pmd);
>>       set_pmd_at(dst_mm, addr, dst_pmd, pmd);
>> @@ -1877,9 +1893,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>       if (!vma_is_anonymous(dst_vma))
>>           return 0;
>>   -    pgtable = pte_alloc_one(dst_mm);
>> -    if (unlikely(!pgtable))
>> -        goto out;
>> +    if (arch_needs_pgtable_deposit()) {
>> +        pgtable = pte_alloc_one(dst_mm);
>> +        if (unlikely(!pgtable))
>> +            goto out;
>> +    }
>>         dst_ptl = pmd_lock(dst_mm, dst_pmd);
>>       src_ptl = pmd_lockptr(src_mm, src_pmd);
>> @@ -1897,7 +1915,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>       }
>>         if (unlikely(!pmd_trans_huge(pmd))) {
>> -        pte_free(dst_mm, pgtable);
>> +        if (pgtable)
>> +            pte_free(dst_mm, pgtable);
>>           goto out_unlock;
>>       }
>>       /*
>> @@ -1923,7 +1942,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>       if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, dst_vma, src_vma))) {
>>           /* Page maybe pinned: split and retry the fault on PTEs. */
>>           folio_put(src_folio);
>> -        pte_free(dst_mm, pgtable);
>> +        if (pgtable)
>> +            pte_free(dst_mm, pgtable);
>>           spin_unlock(src_ptl);
>>           spin_unlock(dst_ptl);
>>           __split_huge_pmd(src_vma, src_pmd, addr, false);
>> @@ -1931,8 +1951,10 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>       }
>>       add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>>   out_zero_page:
>> -    mm_inc_nr_ptes(dst_mm);
>> -    pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
>> +    if (pgtable) {
>> +        mm_inc_nr_ptes(dst_mm);
>> +        pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
>> +    }
>>       pmdp_set_wrprotect(src_mm, addr, src_pmd);
>>       if (!userfaultfd_wp(dst_vma))
>>           pmd = pmd_clear_uffd_wp(pmd);
>> @@ -2364,7 +2386,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>               zap_deposited_table(tlb->mm, pmd);
>>           spin_unlock(ptl);
>>       } else if (is_huge_zero_pmd(orig_pmd)) {
>> -        if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
>> +        if (arch_needs_pgtable_deposit())
>>               zap_deposited_table(tlb->mm, pmd);
>>           spin_unlock(ptl);
>>       } else {
>> @@ -2389,7 +2411,8 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>           }
>>             if (folio_test_anon(folio)) {
>> -            zap_deposited_table(tlb->mm, pmd);
>> +            if (arch_needs_pgtable_deposit())
>> +                zap_deposited_table(tlb->mm, pmd);
>>               add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
>>           } else {
>>               if (arch_needs_pgtable_deposit())
>> @@ -2490,7 +2513,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
>>               force_flush = true;
>>           VM_BUG_ON(!pmd_none(*new_pmd));
>>   -        if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
>> +        if (pmd_move_must_withdraw(new_ptl, old_ptl, vma) &&
>> +            arch_needs_pgtable_deposit()) {
>>               pgtable_t pgtable;
>>               pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
>>               pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
>> @@ -2798,8 +2822,10 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>>       }
>>       set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
>>   -    src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
>> -    pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
>> +    if (arch_needs_pgtable_deposit()) {
>> +        src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
>> +        pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
>> +    }
>>   unlock_ptls:
>>       double_pt_unlock(src_ptl, dst_ptl);
>>       /* unblock rmap walks */
>> @@ -2941,10 +2967,9 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>>   #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>>     static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>> -        unsigned long haddr, pmd_t *pmd)
>> +        unsigned long haddr, pmd_t *pmd, pgtable_t pgtable)
>>   {
>>       struct mm_struct *mm = vma->vm_mm;
>> -    pgtable_t pgtable;
>>       pmd_t _pmd, old_pmd;
>>       unsigned long addr;
>>       pte_t *pte;
>> @@ -2960,7 +2985,16 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>        */
>>       old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
>>   -    pgtable = pgtable_trans_huge_withdraw(mm, pmd);
>> +    if (arch_needs_pgtable_deposit()) {
>> +        pgtable = pgtable_trans_huge_withdraw(mm, pmd);
>> +    } else {
>> +        VM_BUG_ON(!pgtable);
>> +        /*
>> +         * Account for the freshly allocated (in __split_huge_pmd) pgtable
>> +         * being used in mm.
>> +         */
>> +        mm_inc_nr_ptes(mm);
>> +    }
>>       pmd_populate(mm, &_pmd, pgtable);
>>         pte = pte_offset_map(&_pmd, haddr);
>> @@ -2982,12 +3016,11 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>   }
>>     static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>> -        unsigned long haddr, bool freeze)
>> +        unsigned long haddr, bool freeze, pgtable_t pgtable)
>>   {
>>       struct mm_struct *mm = vma->vm_mm;
>>       struct folio *folio;
>>       struct page *page;
>> -    pgtable_t pgtable;
>>       pmd_t old_pmd, _pmd;
>>       bool soft_dirty, uffd_wp = false, young = false, write = false;
>>       bool anon_exclusive = false, dirty = false;
>> @@ -3011,6 +3044,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>            */
>>           if (arch_needs_pgtable_deposit())
>>               zap_deposited_table(mm, pmd);
>> +        if (pgtable)
>> +            pte_free(mm, pgtable);
>>           if (!vma_is_dax(vma) && vma_is_special_huge(vma))
>>               return;
>>           if (unlikely(pmd_is_migration_entry(old_pmd))) {
>> @@ -3043,7 +3078,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>            * small page also write protected so it does not seems useful
>>            * to invalidate secondary mmu at this time.
>>            */
>> -        return __split_huge_zero_page_pmd(vma, haddr, pmd);
>> +        return __split_huge_zero_page_pmd(vma, haddr, pmd, pgtable);
>>       }
>>         if (pmd_is_migration_entry(*pmd)) {
>> @@ -3167,7 +3202,16 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>        * Withdraw the table only after we mark the pmd entry invalid.
>>        * This's critical for some architectures (Power).
>>        */
>> -    pgtable = pgtable_trans_huge_withdraw(mm, pmd);
>> +    if (arch_needs_pgtable_deposit()) {
>> +        pgtable = pgtable_trans_huge_withdraw(mm, pmd);
>> +    } else {
>> +        VM_BUG_ON(!pgtable);
>> +        /*
>> +         * Account for the freshly allocated (in __split_huge_pmd) pgtable
>> +         * being used in mm.
>> +         */
>> +        mm_inc_nr_ptes(mm);
>> +    }
>>       pmd_populate(mm, &_pmd, pgtable);
>>         pte = pte_offset_map(&_pmd, haddr);
>> @@ -3263,11 +3307,13 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>   }
>>     void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>> -               pmd_t *pmd, bool freeze)
>> +               pmd_t *pmd, bool freeze, pgtable_t pgtable)
>>   {
>>       VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>>       if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
>> -        __split_huge_pmd_locked(vma, pmd, address, freeze);
>> +        __split_huge_pmd_locked(vma, pmd, address, freeze, pgtable);
>> +    else if (pgtable)
>> +        pte_free(vma->vm_mm, pgtable);
>>   }
>>     void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>> @@ -3275,13 +3321,24 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>>   {
>>       spinlock_t *ptl;
>>       struct mmu_notifier_range range;
>> +    pgtable_t pgtable = NULL;
>>         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>>                   address & HPAGE_PMD_MASK,
>>                   (address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
>>       mmu_notifier_invalidate_range_start(&range);
>> +
>> +    /* allocate pagetable before acquiring pmd lock */
>> +    if (vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()) {
>> +        pgtable = pte_alloc_one(vma->vm_mm);
>> +        if (!pgtable) {
>> +            mmu_notifier_invalidate_range_end(&range);
> 
> What I last looked at this, I thought the clean thing to do is to let __split_huge_pmd() and friends return an error.
> 
> Let's take a look at walk_pmd_range() as one example:
> 
> if (walk->vma)
>     split_huge_pmd(walk->vma, pmd, addr);
> else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
>     continue;
> 
> err = walk_pte_range(pmd, addr, next, walk);
> 
> Where walk_pte_range() just does a pte_offset_map_lock.
> 
>     pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> 
> But if that fails (as the remapping failed), we will silently skip this range.
> 
> I don't think silently skipping is the right thing to do.
> 
> So I would think that all splitting functions have to be taught to return an error and handle it accordingly. Then we can actually start returning errors.
> 

Ack. This was one of the cases where we would try again if needed.
I did manual code analysis which I included at the end of the commit message
but agreed, its best to return an error and handle accordingly.
I will look into doing this for the next revision.

