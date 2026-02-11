Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B9CE9E305
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0E96B0005; Wed, 11 Feb 2026 08:35:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5925B6B0089; Wed, 11 Feb 2026 08:35:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D2F6B008A; Wed, 11 Feb 2026 08:35:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3D36B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:35:19 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFDF11B396C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:35:18 +0000 (UTC)
X-FDA: 84432272316.29.1933985
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2C48840004
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:35:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mUK/uJK3";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770816917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WYe65kEJv25W5VctRtTznpXvT2ux0PZlKEoVAl2eds=;
	b=Krb+AOY/F4DZVZLU+apBvA9YpVieKs1EllFD+bolUekVBz0+KspBqMW8rqtCExaTTEAjPr
	JY/1F0MddzTQ6FCwaZcOT68QAaw97wSCL2L+GO0J6uMukgriSzYgRW/Tn7ao3oOBqo640H
	KZfWLr/Ra/mSD7NjJFJLUAvw6/TqO2s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mUK/uJK3";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770816917; a=rsa-sha256;
	cv=none;
	b=RVeTeKz1a/TQlfF6jeotGUL4A6JJfPlYORLkWANxbtxVmECRs9O6y6GXCmml1UKF7dxuEJ
	M/IY09/t8CGXdbkzSxWqjafkf85RN3zxXlti4bCsp/AcrUR9+Tn16XnlBdVstUGIo5qRJp
	ea5yNrF7kF0SxrRMmPBBGQOai1s4bRo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 520D960053;
	Wed, 11 Feb 2026 13:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C0AC4CEF7;
	Wed, 11 Feb 2026 13:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770816916;
	bh=BJ0mA1FEB8uqahQO36Gkw8mhFt4DFrXpwQlMzc9n+SA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mUK/uJK3m9IEFcno8iYB7s7kQ5bC/tAUxIOrG75xFAaLWV7IXg6ULaFxZQhJOckqh
	 xnamNvLYGjhPIA+4CRatvP3gXjjkri0e50nSn/oVyPVWwS3B0YAzmWmDdyCcHI8Gi+
	 0DMzTCzRvQZ4kzkxjdR9u94JdimyQBfMvw9LCJrrqt2fgsVqiS/GZZSh+srR78GNxf
	 WxH70PyGw4vbKUHBXGO/XW1FkhvLnoA7Y3DnN47l2feVsHhtNXlu7/N857zuH1vTjH
	 IZ3pcEhJvgvnmIRS/5kTwdZq/1Th8CJoD0QXVPnnpdTJkUR+SKQVkGUKbU7Dgfdd1k
	 6jMH/hPJR1q0A==
Message-ID: <66386da6-6a7c-4968-9167-71f99dd498ad@kernel.org>
Date: Wed, 11 Feb 2026 14:35:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-2-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260211125507.4175026-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ngi55ryzf913ixaxrj7jbscjd3g3wgjr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C48840004
X-HE-Tag: 1770816917-776975
X-HE-Meta: U2FsdGVkX18euLg5xMOmJUO0R5aTDaN7HHUo5aA4lLyy42UQyEXQcPiYa/kval7+3f/3PsPxeVhYsinF+gtu0L6ruovkpYfNQWG9BikpcqrZJMdZcDnAlagUFONnqAqh//Uhh2b1QDKYa77Nsq1b05glYbZxRKVpn83acTz/X2cRKZqPvSK7/L+U/+TfYk9pCLBYCUXTJ0IuUAfZuY+S4IK6sqiJw7JMVfeFVRG9XOm/e6eyKjjxUgpiZhHdAff5sEDD0czAuC8oEsQYjmR8UYxNSjCzvHWSozEb2jTUd1ga14jiYqhbmFRntYL3KLDI3PYswweKqQXs3a76BJdpqutwaipCD3ZTViLROCTTcrK4LiGAzPl+IEqVr1L4VW0RMDcXMly2F3YSERANRjkX/LX02gNAQXfa47xO6gWWq1XL4rng/RwyTSe91WGiwIUBRRLbIz5w3JNkUE9IrHioiD3YAjO8OUEo7Q4KFAnR0WSGIh+m0Pwg//q57FF3c2OzTayXJEq1gRCrWrD7zGxJwwmE1y5HERYZbnE92SH9ysEqdyGc8iZtILTwRzTY/prM71UpVGaMvZoSJmOgjg7TrQw7rLVS8uvJJDzWT7qbiZJnuqikd9fRQybIA2Fw0ot55ixZxn6S14PXuaiqyqL/9Uiy7cGnEfozlEUULaX7yMXfE2LAeuo+rKjfHz7X7zETfC+BnEo/2P2G8GljqINt5kkF4A2phU8g5oJFE7iFiyIVTcz52uc7bv0oxsOLBGgBtJKZaKShbR1+jiTddce8C/OGBxkq8qbfFW+prEJjRxlIRwcDcsXO9jGmCkOAE6AnzjiAkZCeyVKzf0rrtGI7+dTMAH10/PF/iqJOLmm/PK9ywVNy7X4rDTXrZnC+dLDEhfPso7kKezny/qYyZ9lDXPPMhrn0l8Jcw+YE//GS+gQFsPczOuoynT/r8+Tf97ArgUYdXcvZ2p1HOsOx1yt
 bD85d64t
 MB2fLDh+DwgYopfJFoFcYfsOJ7TcX2WwTmAtLls2ylEtu85ADBQJUx3h3+uAmr0LXz2SwkBu2l283dgLMU4iKZU/N0z1/Q6ZrKcVICe7dCOr369mfCYcmB1CZTK87rRk7aGqTNQnRHO/GKaIfHHabWFncDZsRyDbJgqWXo2GPbh9i/1XZZ7xdU1fZ5unypG1MviSZgo3tO93X5K6PwKI7qKPYVqvLV+c1uGhrfYN9basrAhPBFaFDx7lbgntvRGCTNoOHSzqJDXQ3HbjURNmZTWWnjtDwGxJyL71iInDYvFbKKM2IBa/v57ltvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 13:49, Usama Arif wrote:
> When the kernel creates a PMD-level THP mapping for anonymous pages,
> it pre-allocates a PTE page table and deposits it via
> pgtable_trans_huge_deposit(). This deposited table is withdrawn during
> PMD split or zap. The rationale was that split must not fail—if the
> kernel decides to split a THP, it needs a PTE table to populate.
> 
> However, every anon THP wastes 4KB (one page table page) that sits
> unused in the deposit list for the lifetime of the mapping. On systems
> with many THPs, this adds up to significant memory waste. The original
> rationale is also not an issue. It is ok for split to fail, and if the
> kernel can't find an order 0 allocation for split, there are much bigger
> problems. On large servers where you can easily have 100s of GBs of THPs,
> the memory usage for these tables is 200M per 100G. This memory could be
> used for any other usecase, which include allocating the pagetables
> required during split.
> 
> This patch removes the pre-deposit for anonymous pages on architectures
> where arch_needs_pgtable_deposit() returns false (every arch apart from
> powerpc, and only when radix hash tables are not enabled) and allocates
> the PTE table lazily—only when a split actually occurs. The split path
> is modified to accept a caller-provided page table.
> 
> PowerPC exception:
> 
> It would have been great if we can completely remove the pagetable
> deposit code and this commit would mostly have been a code cleanup patch,
> unfortunately PowerPC has hash MMU, it stores hash slot information in
> the deposited page table and pre-deposit is necessary. All deposit/
> withdraw paths are guarded by arch_needs_pgtable_deposit(), so PowerPC
> behavior is unchanged with this patch. On a better note,
> arch_needs_pgtable_deposit will always evaluate to false at compile time
> on non PowerPC architectures and the pre-deposit code will not be
> compiled in.
> 
> Why Split Failures Are Safe:
> 
> If a system is under severe memory pressure that even a 4K allocation
> fails for a PTE table, there are far greater problems than a THP split
> being delayed. The OOM killer will likely intervene before this becomes an
> issue.
> When pte_alloc_one() fails due to not being able to allocate a 4K page,
> the PMD split is aborted and the THP remains intact. I could not get split
> to fail, as its very difficult to make order-0 allocation to fail.
> Code analysis of what would happen if it does:
> 
> - mprotect(): If split fails in change_pmd_range, it will fallback
> to change_pte_range, which will return an error which will cause the
> whole function to be retried again.
> 
> - munmap() (partial THP range): zap_pte_range() returns early when
> pte_offset_map_lock() fails, causing zap_pmd_range() to retry via pmd--.
> For full THP range, zap_huge_pmd() unmaps the entire PMD without
> split.
> 
> - Memory reclaim (try_to_unmap()): Returns false, folio rotated back
> LRU, retried in next reclaim cycle.
> 
> - Migration / compaction (try_to_migrate()): Returns -EAGAIN, migration
> skips this folio, retried later.
> 
> - CoW fault (wp_huge_pmd()): Returns VM_FAULT_FALLBACK, fault retried.
> 
> -  madvise (MADV_COLD/PAGEOUT): split_folio() internally calls
> try_to_migrate() with TTU_SPLIT_HUGE_PMD. If PMD split fails,
> try_to_migrate() returns false, split_folio() returns -EAGAIN,
> and madvise returns 0 (success) silently skipping the region. This
> should be fine. madvise is just an advice and can fail for other
> reasons as well.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>   include/linux/huge_mm.h |   4 +-
>   mm/huge_memory.c        | 144 ++++++++++++++++++++++++++++------------
>   mm/khugepaged.c         |   7 +-
>   mm/migrate_device.c     |  15 +++--
>   mm/rmap.c               |  39 ++++++++++-
>   5 files changed, 156 insertions(+), 53 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index a4d9f964dfdea..b21bb72a298c9 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -562,7 +562,7 @@ static inline bool thp_migration_supported(void)
>   }
>   
>   void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
> -			   pmd_t *pmd, bool freeze);
> +			   pmd_t *pmd, bool freeze, pgtable_t pgtable);
>   bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>   			   pmd_t *pmdp, struct folio *folio);
>   void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
> @@ -660,7 +660,7 @@ static inline void split_huge_pmd_address(struct vm_area_struct *vma,
>   		unsigned long address, bool freeze) {}
>   static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
>   					 unsigned long address, pmd_t *pmd,
> -					 bool freeze) {}
> +					 bool freeze, pgtable_t pgtable) {}
>   
>   static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>   					 unsigned long addr, pmd_t *pmdp,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 44ff8a648afd5..4c9a8d89fc8aa 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1322,17 +1322,19 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>   	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
>   	struct vm_area_struct *vma = vmf->vma;
>   	struct folio *folio;
> -	pgtable_t pgtable;
> +	pgtable_t pgtable = NULL;
>   	vm_fault_t ret = 0;
>   
>   	folio = vma_alloc_anon_folio_pmd(vma, vmf->address);
>   	if (unlikely(!folio))
>   		return VM_FAULT_FALLBACK;
>   
> -	pgtable = pte_alloc_one(vma->vm_mm);
> -	if (unlikely(!pgtable)) {
> -		ret = VM_FAULT_OOM;
> -		goto release;
> +	if (arch_needs_pgtable_deposit()) {
> +		pgtable = pte_alloc_one(vma->vm_mm);
> +		if (unlikely(!pgtable)) {
> +			ret = VM_FAULT_OOM;
> +			goto release;
> +		}
>   	}
>   
>   	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
> @@ -1347,14 +1349,18 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>   		if (userfaultfd_missing(vma)) {
>   			spin_unlock(vmf->ptl);
>   			folio_put(folio);
> -			pte_free(vma->vm_mm, pgtable);
> +			if (pgtable)
> +				pte_free(vma->vm_mm, pgtable);
>   			ret = handle_userfault(vmf, VM_UFFD_MISSING);
>   			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
>   			return ret;
>   		}
> -		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
> +		if (pgtable) {
> +			pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd,
> +						   pgtable);
> +			mm_inc_nr_ptes(vma->vm_mm);
> +		}
>   		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
> -		mm_inc_nr_ptes(vma->vm_mm);
>   		spin_unlock(vmf->ptl);
>   	}
>   
> @@ -1450,9 +1456,11 @@ static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
>   	pmd_t entry;
>   	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
>   	entry = pmd_mkspecial(entry);
> -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +	if (pgtable) {
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		mm_inc_nr_ptes(mm);
> +	}
>   	set_pmd_at(mm, haddr, pmd, entry);
> -	mm_inc_nr_ptes(mm);
>   }
>   
>   vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> @@ -1471,16 +1479,19 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>   	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
>   			!mm_forbids_zeropage(vma->vm_mm) &&
>   			transparent_hugepage_use_zero_page()) {
> -		pgtable_t pgtable;
> +		pgtable_t pgtable = NULL;
>   		struct folio *zero_folio;
>   		vm_fault_t ret;
>   
> -		pgtable = pte_alloc_one(vma->vm_mm);
> -		if (unlikely(!pgtable))
> -			return VM_FAULT_OOM;
> +		if (arch_needs_pgtable_deposit()) {
> +			pgtable = pte_alloc_one(vma->vm_mm);
> +			if (unlikely(!pgtable))
> +				return VM_FAULT_OOM;
> +		}
>   		zero_folio = mm_get_huge_zero_folio(vma->vm_mm);
>   		if (unlikely(!zero_folio)) {
> -			pte_free(vma->vm_mm, pgtable);
> +			if (pgtable)
> +				pte_free(vma->vm_mm, pgtable);
>   			count_vm_event(THP_FAULT_FALLBACK);
>   			return VM_FAULT_FALLBACK;
>   		}
> @@ -1490,10 +1501,12 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>   			ret = check_stable_address_space(vma->vm_mm);
>   			if (ret) {
>   				spin_unlock(vmf->ptl);
> -				pte_free(vma->vm_mm, pgtable);
> +				if (pgtable)
> +					pte_free(vma->vm_mm, pgtable);
>   			} else if (userfaultfd_missing(vma)) {
>   				spin_unlock(vmf->ptl);
> -				pte_free(vma->vm_mm, pgtable);
> +				if (pgtable)
> +					pte_free(vma->vm_mm, pgtable);
>   				ret = handle_userfault(vmf, VM_UFFD_MISSING);
>   				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
>   			} else {
> @@ -1504,7 +1517,8 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>   			}
>   		} else {
>   			spin_unlock(vmf->ptl);
> -			pte_free(vma->vm_mm, pgtable);
> +			if (pgtable)
> +				pte_free(vma->vm_mm, pgtable);
>   		}
>   		return ret;
>   	}
> @@ -1836,8 +1850,10 @@ static void copy_huge_non_present_pmd(
>   	}
>   
>   	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> -	mm_inc_nr_ptes(dst_mm);
> -	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> +	if (pgtable) {
> +		mm_inc_nr_ptes(dst_mm);
> +		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> +	}
>   	if (!userfaultfd_wp(dst_vma))
>   		pmd = pmd_swp_clear_uffd_wp(pmd);
>   	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
> @@ -1877,9 +1893,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>   	if (!vma_is_anonymous(dst_vma))
>   		return 0;
>   
> -	pgtable = pte_alloc_one(dst_mm);
> -	if (unlikely(!pgtable))
> -		goto out;
> +	if (arch_needs_pgtable_deposit()) {
> +		pgtable = pte_alloc_one(dst_mm);
> +		if (unlikely(!pgtable))
> +			goto out;
> +	}
>   
>   	dst_ptl = pmd_lock(dst_mm, dst_pmd);
>   	src_ptl = pmd_lockptr(src_mm, src_pmd);
> @@ -1897,7 +1915,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>   	}
>   
>   	if (unlikely(!pmd_trans_huge(pmd))) {
> -		pte_free(dst_mm, pgtable);
> +		if (pgtable)
> +			pte_free(dst_mm, pgtable);
>   		goto out_unlock;
>   	}
>   	/*
> @@ -1923,7 +1942,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>   	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, dst_vma, src_vma))) {
>   		/* Page maybe pinned: split and retry the fault on PTEs. */
>   		folio_put(src_folio);
> -		pte_free(dst_mm, pgtable);
> +		if (pgtable)
> +			pte_free(dst_mm, pgtable);
>   		spin_unlock(src_ptl);
>   		spin_unlock(dst_ptl);
>   		__split_huge_pmd(src_vma, src_pmd, addr, false);
> @@ -1931,8 +1951,10 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>   	}
>   	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>   out_zero_page:
> -	mm_inc_nr_ptes(dst_mm);
> -	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> +	if (pgtable) {
> +		mm_inc_nr_ptes(dst_mm);
> +		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> +	}
>   	pmdp_set_wrprotect(src_mm, addr, src_pmd);
>   	if (!userfaultfd_wp(dst_vma))
>   		pmd = pmd_clear_uffd_wp(pmd);
> @@ -2364,7 +2386,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   			zap_deposited_table(tlb->mm, pmd);
>   		spin_unlock(ptl);
>   	} else if (is_huge_zero_pmd(orig_pmd)) {
> -		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
> +		if (arch_needs_pgtable_deposit())
>   			zap_deposited_table(tlb->mm, pmd);
>   		spin_unlock(ptl);
>   	} else {
> @@ -2389,7 +2411,8 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		}
>   
>   		if (folio_test_anon(folio)) {
> -			zap_deposited_table(tlb->mm, pmd);
> +			if (arch_needs_pgtable_deposit())
> +				zap_deposited_table(tlb->mm, pmd);
>   			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
>   		} else {
>   			if (arch_needs_pgtable_deposit())
> @@ -2490,7 +2513,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
>   			force_flush = true;
>   		VM_BUG_ON(!pmd_none(*new_pmd));
>   
> -		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
> +		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma) &&
> +		    arch_needs_pgtable_deposit()) {
>   			pgtable_t pgtable;
>   			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
>   			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
> @@ -2798,8 +2822,10 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>   	}
>   	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
>   
> -	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
> -	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
> +	if (arch_needs_pgtable_deposit()) {
> +		src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
> +		pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
> +	}
>   unlock_ptls:
>   	double_pt_unlock(src_ptl, dst_ptl);
>   	/* unblock rmap walks */
> @@ -2941,10 +2967,9 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>   #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>   
>   static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
> -		unsigned long haddr, pmd_t *pmd)
> +		unsigned long haddr, pmd_t *pmd, pgtable_t pgtable)
>   {
>   	struct mm_struct *mm = vma->vm_mm;
> -	pgtable_t pgtable;
>   	pmd_t _pmd, old_pmd;
>   	unsigned long addr;
>   	pte_t *pte;
> @@ -2960,7 +2985,16 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>   	 */
>   	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
>   
> -	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> +	if (arch_needs_pgtable_deposit()) {
> +		pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> +	} else {
> +		VM_BUG_ON(!pgtable);
> +		/*
> +		 * Account for the freshly allocated (in __split_huge_pmd) pgtable
> +		 * being used in mm.
> +		 */
> +		mm_inc_nr_ptes(mm);
> +	}
>   	pmd_populate(mm, &_pmd, pgtable);
>   
>   	pte = pte_offset_map(&_pmd, haddr);
> @@ -2982,12 +3016,11 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>   }
>   
>   static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
> -		unsigned long haddr, bool freeze)
> +		unsigned long haddr, bool freeze, pgtable_t pgtable)
>   {
>   	struct mm_struct *mm = vma->vm_mm;
>   	struct folio *folio;
>   	struct page *page;
> -	pgtable_t pgtable;
>   	pmd_t old_pmd, _pmd;
>   	bool soft_dirty, uffd_wp = false, young = false, write = false;
>   	bool anon_exclusive = false, dirty = false;
> @@ -3011,6 +3044,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   		 */
>   		if (arch_needs_pgtable_deposit())
>   			zap_deposited_table(mm, pmd);
> +		if (pgtable)
> +			pte_free(mm, pgtable);
>   		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
>   			return;
>   		if (unlikely(pmd_is_migration_entry(old_pmd))) {
> @@ -3043,7 +3078,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   		 * small page also write protected so it does not seems useful
>   		 * to invalidate secondary mmu at this time.
>   		 */
> -		return __split_huge_zero_page_pmd(vma, haddr, pmd);
> +		return __split_huge_zero_page_pmd(vma, haddr, pmd, pgtable);
>   	}
>   
>   	if (pmd_is_migration_entry(*pmd)) {
> @@ -3167,7 +3202,16 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   	 * Withdraw the table only after we mark the pmd entry invalid.
>   	 * This's critical for some architectures (Power).
>   	 */
> -	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> +	if (arch_needs_pgtable_deposit()) {
> +		pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> +	} else {
> +		VM_BUG_ON(!pgtable);
> +		/*
> +		 * Account for the freshly allocated (in __split_huge_pmd) pgtable
> +		 * being used in mm.
> +		 */
> +		mm_inc_nr_ptes(mm);
> +	}
>   	pmd_populate(mm, &_pmd, pgtable);
>   
>   	pte = pte_offset_map(&_pmd, haddr);
> @@ -3263,11 +3307,13 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>   }
>   
>   void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
> -			   pmd_t *pmd, bool freeze)
> +			   pmd_t *pmd, bool freeze, pgtable_t pgtable)
>   {
>   	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>   	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
> -		__split_huge_pmd_locked(vma, pmd, address, freeze);
> +		__split_huge_pmd_locked(vma, pmd, address, freeze, pgtable);
> +	else if (pgtable)
> +		pte_free(vma->vm_mm, pgtable);
>   }
>   
>   void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> @@ -3275,13 +3321,24 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>   {
>   	spinlock_t *ptl;
>   	struct mmu_notifier_range range;
> +	pgtable_t pgtable = NULL;
>   
>   	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>   				address & HPAGE_PMD_MASK,
>   				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
>   	mmu_notifier_invalidate_range_start(&range);
> +
> +	/* allocate pagetable before acquiring pmd lock */
> +	if (vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()) {
> +		pgtable = pte_alloc_one(vma->vm_mm);
> +		if (!pgtable) {
> +			mmu_notifier_invalidate_range_end(&range);

What I last looked at this, I thought the clean thing to do is to let 
__split_huge_pmd() and friends return an error.

Let's take a look at walk_pmd_range() as one example:

if (walk->vma)
	split_huge_pmd(walk->vma, pmd, addr);
else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
	continue;

err = walk_pte_range(pmd, addr, next, walk);

Where walk_pte_range() just does a pte_offset_map_lock.

	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);

But if that fails (as the remapping failed), we will silently skip this 
range.

I don't think silently skipping is the right thing to do.

So I would think that all splitting functions have to be taught to 
return an error and handle it accordingly. Then we can actually start 
returning errors.

-- 
Cheers,

David

