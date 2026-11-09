Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73C6C606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 15:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SKgc2LkN
Received: by kanga.kvack.org (Postfix)
	id 961EA6B05C2; Mon,  9 Nov 2026 10:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9391C6B05C3; Mon,  9 Nov 2026 10:08:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FD66B05C4; Mon,  9 Nov 2026 10:08:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6F36B05C2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:08:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E83FE1206A5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:08:36 +0000 (UTC)
X-FDA: 85415912232.12.42CD30F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0DC86A0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:08:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SKgc2LkN;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794236915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sd2qM6+PDFRCO8BLs2DGMh7GhcX/ulkjEDLXnk+kxUA=;
	b=UJsW9OS00IykvdVD8JcjHS2e6rwAKW3XPM+syvM3GAENgPDvGWQ5u8FGY2BquVzx20Wiur
	3bOC9V4062D9bQDmRIhE2Pu+3C1qzWx6MSMPFf05DOXiGKPkZsTVkdIKdPAb7DE7Tr9fqt
	bYHpt3ENJbuxGAumSexYC6v6+2V9bVc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794236915;
	b=3alaKBYXZChnF5noIvtm69vBYmRFF+rOpi20fTSyBkOc7gQOOJEshXWMh68sZCmyGSNYKK
	PoXX9QqOcrHq2YYbN22i4p9ZTSqSgohhH1uDyHEkeNr3OlTvhxZtkRuw7nFg6NVAYfPK9V
	S/kFzEAjHM9VciCv+JG+YLv4SlC3qSo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SKgc2LkN;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CD794402A;
	Mon,  9 Nov 2026 15:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430B91F008A4;
	Mon,  9 Nov 2026 15:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794236914;
	bh=Sd2qM6+PDFRCO8BLs2DGMh7GhcX/ulkjEDLXnk+kxUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SKgc2LkNZGyEX0Gy5P7smNbb1wHNkIgKilphlpHL9cBlesnaHKPrBoPtYdYYGLKZ/
	 S0LSKQGm4pCJ9h1Zwf/j5Ji8+pC/lndtFbwLRLaD0KKopxqSb1FlWv7Ap0BifOLzuD
	 2KzrScbkVNr7CsD929bxREjX1DGHPcFSvId3xgjb0K389RsLtcds/kChaHNL2rH8gc
	 oW+XTesVNeLK1htElh5LeJuJOB3illKFWZ6bRP9cvSBA2oz7gWIxoSRgqjdDsetXuM
	 kn4T3SUUtb87c0Yh2lzEwYyDwa892/7hCZoRJfbByqgXFcnC6xr5IAu5/oiQDMfQUj
	 Xr4Li0+udWeIg==
Message-ID: <28b818cb-f038-43ce-a2e2-a9c97befba09@kernel.org>
Date: Mon, 9 Nov 2026 16:08:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/khugepaged: check for empty PTE tables before
 retracting
To: sashiko-reviews@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Peter Xu <peterx@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
 <20261107-b4-uffd_marker_loss-v1-2-82926b22704c@kernel.org>
 <sashiko-outbox-203403@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <sashiko-outbox-203403@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bc9idwsncgbcdjf56zj9hiafnbiaaqqy
X-Rspamd-Queue-Id: 0DC86A0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794236914-996112
X-HE-Meta: U2FsdGVkX18NivJ9F5sdXzSWdbeAQJeHKOb9/FpQcT1LjvC+wgLtmNoql+E6MUK7JuYLXq5X9jgTmugIb2gEogLUkm50PjlHLLnHtFXW1mvqKcujl11Q3ZSSW/4sgf+WLuAAceVDD5A1cL52dv0Ehp+6w3/cOfjrRgHvmHydWiTOgQ4gPuiCoqWiCiVfs1S1CGw7D2+fTTELOlloyO6RkFB0FjE/79Xkab4e/w2MZamb5Bw6cRoGGY5veTERMafB84ELhafpn9TtVN1n9yIdepsAAgMjKGXK703JH5wyGQO02i0I+nEyeehuL+wc6YCfZveEp3/ivTAGI964uzRJhoMDBVgmADa9Fp5vRpg+st5+AHr1W32SLsXR7AZ8S8ulsgFtR46oh+Qb7xkY4+QLlfx9ANiyUKwRo6lcepJRJCZ85AU6qfbQoc/aaMQ2Ys+2l1ojyRXq5dcg2FdSop+wA3Tg/asCuDSrZhnFj0koUSMxdwo/3EOu/k5Ixbo4UYsebVHIkhP07iYSlNYzPFCBi11HFDg7gU4mjPtJ/LMVuCOzJv5iOQs7suU9gA5V5NHGWw+OW3l6gI35tXAvMu6a1MffhsoWlcDF0BiMt7HvA806kihOKOL2dzWr3yhxriTJdZeU3wF57OudMcZ/ePZifuVNyBMNzM5n8CmD25/pteixkokYP7Bg7vHqw5H+lxWvXoXenwP3BBSbNlfwNOdnYD4D3aJndcAgi9kOf6FvxBby7jgVh/iac6Y3HWtMS/yWP9oVh8ViPhFnu0h8HtgjrxCwXPSSt35ADDXIRxbrA2y8MFW/8sD/4su/yAParD600PjFK+ocD7/PXMp68jVtcoBj4n0mWDUfzheco+F427kigmyNhcadleWkNdtPserZz3Z6RTjQM0gxAfoMAy+PG73zS/qPksw7+nJUlfn2dFU0D7dxFwX/C+L1YtQGSq/wIWvWDhz/neP0AJx610l
 a+D6tfV2
 G/Yd7jO3bSY59csJcUT5g3Q6Me/ngnUvnpTz/J+hpPuUDWN1ToZzVP5YDhwoo8kW2vlWbwnOH0IqmbcEL9JT8zb9McZ7Tv2FR6E3i/ZBKOeFeoK7Ndlm22mnVlXDVVGgqzihFqWhwnkPr6WVp27+mIwfNCMkKFxfjlry324S6pfr+0PTOfJaLEb6U0yYfDsHsqljIShDJVST/C6eAHMNbN93gyWK05dsLzEsGvxRleRtCDYgHZWlNeZ0nA5D2n5mh2Ii+VStKXepPuEE63S+7R7ZNX/wnH+2AZvUt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/8/26 00:51, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] mm/khugepaged: race between retract_page_tables() and
>   copy_page_range()
> - [Medium] mm/khugepaged: retract_page_tables() breaks uffd RWP on file
>   and shmem VMAs
> --
> 
> commit 15ea4d4b6e2586260561871f9acd4c3bff3278ec
> Author: David Hildenbrand (Arm) <david@kernel.org>
> 
> mm/khugepaged: check for empty PTE tables before retracting
> 
> This commit replaces the VMA flag checks in retract_page_tables() with a
> scan under the PTE lock to verify that the PTE table is empty before
> retracting it.
> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 2a5ee8fc42335..f39ea3d076554 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
> [ ... ]
>> @@ -2081,48 +2082,6 @@ void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>>  	try_collapse_pte_mapped_thp(mm, addr, install_pmd);
>>  }
>>  
>> -/* Can we retract page tables for this file-backed VMA? */
>> -static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
>> -{
>> -	/*
>> -	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
>> -	 * got written to. These VMAs are likely not worth removing
>> -	 * page tables from, as PMD-mapping is likely to be split later.
>> -	 *
>> -	 * Can't use vma_has_anon_rmap() here as the VMA may be stabilised
>> -	 * by the file rmap lock.
>> -	 */
>> -	if (READ_ONCE(vma->anon_vma))
>> -		return false;
>> -
>> -	/*
>> -	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
>> -	 * the page table because there may be pte markers installed.
>> -	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
>> -	 * and cannot be recycled to a shared PMD. Other vmas can still
>> -	 * have the same file mapped hugely, but skip this one: it will
>> -	 * always be mapped in small page size for these registrations.
>> -	 */
>> -	if (userfaultfd_protected(vma))
>> -		return false;
>> -
>> -	/*
>> -	 * Preserve guard and poison markers when retracting page tables.
>> -	 *
>> -	 * These flags are set atomically on marker installation under mmap/VMA
>> -	 * read lock, and here we may not hold any VMA or mmap lock at all.
>> -	 *
>> -	 * This is therefore serialised on the PTE page table lock, which is
>> -	 * obtained on marker installation after the flag is set, so this
>> -	 * check being performed under this lock excludes races.
>> -	 */
>> -	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT) ||
>> -	    vma_test_atomic_flag(vma, VMA_MAYBE_UFFD_POISON_BIT))
>> -		return false;
>> -
>> -	return true;
>> -}
>> -
>>  static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>>  {
>>  	struct vm_area_struct *vma;
>> @@ -2133,10 +2092,18 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>>  		struct mm_struct *mm;
>>  		unsigned long addr;
>>  		pmd_t *pmd, pgt_pmd;
>> -		spinlock_t *pml;
>> -		spinlock_t *ptl;
>> +		pte_t *pte;
>> +		spinlock_t *pml = NULL, *ptl;
>>  		bool success = false;
>>  
>> +		/*
>> +		 * Skip private mappings that have been written to: we'll likely
>> +		 * split them as soon as we CoW later. Use READ_ONCE() because
>> +		 * we are neither holding the VMA lock nor the mmap_lock.
>> +		 */
>> +		if (READ_ONCE(vma->anon_vma))
>> +			continue;
> 
> [Severity: Medium]
> Can removing the VM_COPY_ON_FORK flag checks here cause retract_page_tables()
> to race with copy_page_range() during fork()?
> 
> In dup_mmap(), the child VMA is linked into mapping->i_mmap and
> i_mmap_unlock_write(mapping) is dropped before copy_page_range() runs.
> vma_needs_copy() copies page tables not only when vma_has_anon_rmap() is set,
> but also when VM_COPY_ON_FORK flags (VM_MAYBE_GUARD, VM_MAYBE_UFFD_POISON,
> VM_UFFD_WP, or VM_UFFD_RWP) are set on a file or shmem VMA whose anon_vma is
> still NULL.

Ah, try_collapse_pte_mapped_thp() runs withe the mmap lock, whereby
retract_page_tables() only holds the rmap lock.



> 
> mm/memory.c:copy_pte_range() {
> 	/*
> 	 * copy_pmd_range()'s prior pmd_none_or_clear_bad(src_pmd), and the
> 	 * error handling here, assume that exclusive mmap_lock on dst and src
> 	 * protects anon from unexpected THP transitions; with shmem and file
> 	 * protected by mmap_lock-less collapse skipping areas with an anon rmap
> 	 * (whereas vma_needs_copy() skips areas without one).  A rework
> 	 * can remove such assumptions later, but this is good enough for now.
> 	 */
> 	dst_pte = pte_alloc_map_lock(dst_mm, dst_pmd, addr, &dst_ptl);
> 	if (!dst_pte) {
> 		ret = -ENOMEM;
> 		goto out;
> 	}
> }
> 
> Because retract_page_tables() no longer skips VMAs with VM_COPY_ON_FORK flags
> set, it can retract the newly allocated empty dst_pmd in the child between
> __pte_alloc() and pte_offset_map_lock() (or across cond_resched() before a
> non-empty PTE is copied):
> 
> CPU0                                      CPU1
> dup_mmap()
>   mapping_rmap_tree_insert_after(dst_vma, ...)
>   i_mmap_unlock_write(mapping)
>   copy_page_range(dst_vma, src_vma)
>     ...
>     copy_pte_range()
>       pte_alloc_map_lock(dst_mm, dst_pmd, ...)
>         __pte_alloc(dst_mm, dst_pmd)
>                                           collapse_file()
>                                             retract_page_tables()
>                                               pte_table_empty(pte) == true
>                                               pmdp_collapse_flush(..., dst_pmd)
>         pte_offset_map_lock(dst_mm, dst_pmd, ...)
>           --> returns NULL
>       ret = -ENOMEM;  <-- fork() fails spuriously
> 
> On the parent side, retracting an empty src_pmd concurrently with
> copy_pmd_range() can also clear *src_pmd between pmd_none(*src_pmd) and
> pmd_bad(*src_pmd) inside pmd_none_or_clear_bad(src_pmd), triggering a false
> pmd_clear_bad() report.

Yeah, that would likely need a different handling.

> 
>> +
>>  		addr = vma->vm_start +
>>  			((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
>>  		if (addr & ~HPAGE_PMD_MASK ||
>> @@ -2150,52 +2117,48 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>>  		if (collapse_test_exit(mm))
>>  			continue;
>>  
>> -		if (!file_backed_vma_is_retractable(vma))
>> -			continue;
>> -
>>  		/* PTEs were notified when unmapped; but now for the PMD? */
>>  		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
>>  					addr, addr + HPAGE_PMD_SIZE);
>>  		mmu_notifier_invalidate_range_start(&range);
>>  
>> -		pml = pmd_lock(mm, pmd);
> [ ... ]
>> +		pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
>> +		if (!pte)
>> +			goto unlock;
>>  
>>  		/*
>> -		 * Huge page lock is still held, so normally the page table must
>> -		 * remain empty; and we have already skipped vmas with an anon
>> -		 * rmap and userfaultfd_wp() vmas.  But since the mmap_lock is not
>> -		 * held, it is still possible for a racing userfaultfd_ioctl() or
>> -		 * madvise() to have inserted ptes or markers.  Now that we hold
>> -		 * ptlock, repeating the retractable checks protects us from
>> -		 * races against the prior checks.
>> +		 * The folio lock prevents file faults from modifying the
>> +		 * page table, but other things (userfaultfd, CoW, guard
>> +		 * markers) could have modified the page table until we lock it
>> +		 * and check.
>>  		 */
>> -		if (likely(file_backed_vma_is_retractable(vma))) {
>> -			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
>> -			pmdp_get_lockless_sync();
>> -			success = true;
>> -		}
>> +		if (!pte_table_empty(pte))
>> +			goto unlock;
> 
> [Severity: Medium]
> Does checking pte_table_empty() instead of userfaultfd_protected(vma) break
> userfaultfd RWP (and WP) on file and shmem VMAs?
> 
> Unlike VM_UFFD_WP on write-protected PTEs, try_to_unmap_one() does not
> install PTE markers for VM_UFFD_RWP (or for VM_UFFD_WP PTEs that are not
> currently write-protected) when collapse_file() unmaps the small folios.
> pte_table_empty(pte) is then true and retract_page_tables() clears the PMD to
> pmd_none, even though try_collapse_pte_mapped_thp() still refuses
> userfaultfd_protected(vma).
> 
> Once the PMD is pmd_none, the next fault in finish_fault() installs a huge
> PMD before checking userfaultfd_armed(vma):
> 
> mm/memory.c:finish_fault() {
> 	if (pmd_none(*vmf->pmd)) {
> 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
> 			ret = do_set_pmd(vmf, folio, page);
> 			if (ret != VM_FAULT_FALLBACK)
> 				return ret;
> 		}
>     ...
> 	/* Using per-page fault to maintain the uffd semantics */
> 	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
> 		nr_pages = 1;
> }
> 
> When userspace later issues UFFDIO_RWPROTECT on that file or shmem VMA,
> change_pmd_range() sees pgtable_split_needed() is true and calls
> __split_huge_pmd(), which zaps the file huge PMD back to pmd_none without
> populating a PTE table (since pgtable_populate_needed() is false for
> MM_CP_UFFD_RWP), so RWP protection is lost and subsequent accesses fault the
> unprotected huge PMD back in without delivering RWP faults.  Installing a
> huge PMD also causes PAGEMAP_SCAN to report all 512 pages as accessed or
> written after a single 4KB page fault.

"Since pgtable_populate_needed() is false for MM_CP_UFFD_RWP" I think RWP also
needs proper uffd marker support, independent of the change here.
-- 
Cheers,

David

