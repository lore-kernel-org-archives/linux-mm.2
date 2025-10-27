Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D63CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F0D8002B; Mon, 27 Oct 2025 05:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F9C8000A; Mon, 27 Oct 2025 05:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E028002B; Mon, 27 Oct 2025 05:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01CFE8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:17:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9675EC0559
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:17:53 +0000 (UTC)
X-FDA: 84043342026.25.7BB00B0
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id C11391C0003
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:17:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a7VpjxJd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761556672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dm/mUbcMAMZo9wS8DsBcQxN0CKzM7e2WXj+TwSYfMcs=;
	b=mdcwZO+2SUnOsSATR7JDAjPaptVNhtd7yuhp2JWNvdMWOa+3lqj5WLlLisrjdOCWshd5kc
	Nm8ogU0qEZ5/CrZJzyDf57I9nfyPDuE0kmmMV+XKw1YSdSA6qE7IcZA8/fGgU8yu4JtArZ
	JmXXnXkbHTUujxEwri9TOkzsvnckuH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761556672; a=rsa-sha256;
	cv=none;
	b=0AJ7vtkMEJkAd0i9ZTcrOz+HbWcGhi4R8QKf/gGefqxYyg5cuxwR53w63YvtAhwcCpD8y7
	CcQotFw4KPBz6G1i+VzpxUstsE2ZAz2ZbgB0M+tSnC0uPdWkFOywS6F/oj3UqruciXBHxC
	YALgBP46TIecXK0UxGdm4qEy9wE/3XY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a7VpjxJd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <703b22dc-0123-42ba-9984-074b9cda468c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761556668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dm/mUbcMAMZo9wS8DsBcQxN0CKzM7e2WXj+TwSYfMcs=;
	b=a7VpjxJdsAE7IaId8HUK0fWulHLBBBlPdBgisXLI8HsC5jSpnqn0RWI3TOiFJ+HoLyFGKb
	fOsLV6/nyVa7CRopxslpJS2jE6iPH3Y7UVgkHeh1oxU5h/DTMIp9n83ksu3aSf5DB9BdIe
	AAPk02rr8BVzg6VEVgfCPY6Y71vljfo=
Date: Mon, 27 Oct 2025 17:17:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v12 mm-new 05/15] khugepaged: generalize
 __collapse_huge_page_* for mTHP support
Content-Language: en-US
To: Nico Pache <npache@redhat.com>
Cc: david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 vbabka@suse.cz, rppt@kernel.org, jannh@google.com, pfalcato@suse.de,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-6-npache@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251022183717.70829-6-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: p938d1rifih3kkgim9wegjsfa3toke6u
X-Rspam-User: 
X-Rspamd-Queue-Id: C11391C0003
X-HE-Tag: 1761556671-470958
X-HE-Meta: U2FsdGVkX19hqDRowI48MmCR0B1tzxAfskVDg0MdCzfebXdsOTapfPm9jnl7ZccRIR3k50VLLuLYE73DHVMBm/hVGsXMLKGE87KpYJUAOSvUV2Hk7b1ObgQs0SHfQw2xdiHtk89/9imdW3ur33Lmg9F6MNAmFTD+6zmpqCzhiPSUPhjAc8E6Fxp9v31nyfrw7N0kgIC4RjIEcNbpoSHloaRs9IznoBgZVABN1nbUIdfunANb144dQRSgAKBb5Qyo4C9m4Aujn4G2wj7O0hK0yP01tUfz63u4eS5RRrkylL8abKbdKwK/zzy8lf0g8tv133/7W5QLPukyPVcdeNAW+hWEU71wQ+tRKwSXWCqMhvc1/JHUWVwuSFL6ZBxdSq7NnK3TILrlDAQQBGdV2JEWQohW1AE8KTFC2mzAjpXJYaaneVCh/lxG7qiG1ClcFJoUkO/E2QIvxFZizPf2QtQTAiSrA/8P77DFrinOTBmXjodFHJDJc+C8X9tJnUHngFMjtSAYsHitrFv0QsHanrXSCyH8bH17m/RstJU+yI3+phJGtRXY0bOu/ucfG7k2kGOM7dpn7zcKJ2JL5QWFshGO9vBtqwfefxnnHtOE+SEjLGLQfFJv4hbx6qlzv+zFflXMpLlK5xh2GQY016xdHvOhJUIphd5vUalXn2c182pDshCc/981dNWqJ6XrAB8Iujqt01BgFd9Y7A/pPgWzLIxvfMTPPOsfxBF++UZB6hohv2haWrBfrMVuWHW5FYnwN4FesVGEcSzxxOZog8fq21Spfv7ScjoTPh+3Zb2a6jTkVh0ho89VbiyeYqqxRiKUUa4J8LU5ZDCYMb6sa4KYEq2sTucjgyN4wkA/zLX/BQG5QkyM1DnZHJI4FABDJONSDaUtXl4BLswsXWZsA+Gk3ZO7Hv54eDk2udcihYVXGIVJXz9+aaoIjkjWO09LXSggX4tBi9/MGeDOzE3MUZLCYbj
 BKKFDgFt
 LbjV9yNB+o5yr/+QRscMbUCDkLzSnLc4XeAO6W1zRa5vVLgDG9t8Ize4FWXDcWZqfwV9plDu3uodN2mYiByYBMIOudx4I+ZIlXe8N2hmbqnlLKkWfyA66MRUl28cYSczsW80WIjViui9KhU/NyaSZK+0/UN3d7ChiL9QZSFn5VcGKogjdZs8f8NOa1Q/qIyjC4zK7/ytGiTH9l5ddKwp6pN6DfY1/0ekMsLrYIquymXi2gnoMUPgTyV6JXRhfB8jYqH4CAK+TdTmS29yu6WHhiv8MrBGIhl8yNOPdyA9Na5c86k5rhs1EfhFc2XG0Rab3Vvcsc96w+ExlBinIugiBCAssOVVi8NCP86G47GKx3unVLyMcMCbtDD8g5e3oM/GFZj6V0IEja2Fqwe7GRA30bQmlB+O5EHD4cQes5dWbnS1NhUasjltLBI3mtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/23 02:37, Nico Pache wrote:
> generalize the order of the __collapse_huge_page_* functions
> to support future mTHP collapse.
> 
> mTHP collapse will not honor the khugepaged_max_ptes_shared or
> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
> shared or swapped entry.

Yeah, IMHO, it's the right call to avoid the complexity of potential
"collapse creep" at this stage and get the core functionality right first ;)

> 
> No functional changes in this patch.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

Cool! LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>


>   mm/khugepaged.c | 78 ++++++++++++++++++++++++++++++-------------------
>   1 file changed, 48 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 36ee659acfbb..4ccebf5dda97 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -537,25 +537,25 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>   }
>   
>   static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> -					unsigned long start_addr,
> -					pte_t *pte,
> -					struct collapse_control *cc,
> -					struct list_head *compound_pagelist)
> +		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
> +		unsigned int order, struct list_head *compound_pagelist)
>   {
>   	struct page *page = NULL;
>   	struct folio *folio = NULL;
>   	unsigned long addr = start_addr;
>   	pte_t *_pte;
>   	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
> +	const unsigned long nr_pages = 1UL << order;
> +	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
>   
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> +	for (_pte = pte; _pte < pte + nr_pages;
>   	     _pte++, addr += PAGE_SIZE) {
>   		pte_t pteval = ptep_get(_pte);
>   		if (pte_none_or_zero(pteval)) {
>   			++none_or_zero;
>   			if (!userfaultfd_armed(vma) &&
>   			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> +			     none_or_zero <= max_ptes_none)) {
>   				continue;
>   			} else {
>   				result = SCAN_EXCEED_NONE_PTE;
> @@ -583,8 +583,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   		/* See collapse_scan_pmd(). */
>   		if (folio_maybe_mapped_shared(folio)) {
>   			++shared;
> -			if (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared) {
> +			/*
> +			 * TODO: Support shared pages without leading to further
> +			 * mTHP collapses. Currently bringing in new pages via
> +			 * shared may cause a future higher order collapse on a
> +			 * rescan of the same range.
> +			 */
> +			if (order != HPAGE_PMD_ORDER || (cc->is_khugepaged &&
> +			    shared > khugepaged_max_ptes_shared)) {
>   				result = SCAN_EXCEED_SHARED_PTE;
>   				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>   				goto out;
> @@ -677,18 +683,18 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   }
>   
>   static void __collapse_huge_page_copy_succeeded(pte_t *pte,
> -						struct vm_area_struct *vma,
> -						unsigned long address,
> -						spinlock_t *ptl,
> -						struct list_head *compound_pagelist)
> +		struct vm_area_struct *vma, unsigned long address,
> +		spinlock_t *ptl, unsigned int order,
> +		struct list_head *compound_pagelist)
>   {
> -	unsigned long end = address + HPAGE_PMD_SIZE;
> +	unsigned long end = address + (PAGE_SIZE << order);
>   	struct folio *src, *tmp;
>   	pte_t pteval;
>   	pte_t *_pte;
>   	unsigned int nr_ptes;
> +	const unsigned long nr_pages = 1UL << order;
>   
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
> +	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
>   	     address += nr_ptes * PAGE_SIZE) {
>   		nr_ptes = 1;
>   		pteval = ptep_get(_pte);
> @@ -741,13 +747,11 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>   }
>   
>   static void __collapse_huge_page_copy_failed(pte_t *pte,
> -					     pmd_t *pmd,
> -					     pmd_t orig_pmd,
> -					     struct vm_area_struct *vma,
> -					     struct list_head *compound_pagelist)
> +		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> +		unsigned int order, struct list_head *compound_pagelist)
>   {
>   	spinlock_t *pmd_ptl;
> -
> +	const unsigned long nr_pages = 1UL << order;
>   	/*
>   	 * Re-establish the PMD to point to the original page table
>   	 * entry. Restoring PMD needs to be done prior to releasing
> @@ -761,7 +765,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>   	 * Release both raw and compound pages isolated
>   	 * in __collapse_huge_page_isolate.
>   	 */
> -	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
> +	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
>   }
>   
>   /*
> @@ -781,16 +785,16 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
>    */
>   static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>   		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
> -		unsigned long address, spinlock_t *ptl,
> +		unsigned long address, spinlock_t *ptl, unsigned int order,
>   		struct list_head *compound_pagelist)
>   {
>   	unsigned int i;
>   	int result = SCAN_SUCCEED;
> -
> +	const unsigned long nr_pages = 1UL << order;
>   	/*
>   	 * Copying pages' contents is subject to memory poison at any iteration.
>   	 */
> -	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +	for (i = 0; i < nr_pages; i++) {
>   		pte_t pteval = ptep_get(pte + i);
>   		struct page *page = folio_page(folio, i);
>   		unsigned long src_addr = address + i * PAGE_SIZE;
> @@ -809,10 +813,10 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>   
>   	if (likely(result == SCAN_SUCCEED))
>   		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
> -						    compound_pagelist);
> +						    order, compound_pagelist);
>   	else
>   		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
> -						 compound_pagelist);
> +						 order, compound_pagelist);
>   
>   	return result;
>   }
> @@ -985,13 +989,12 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>    * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
>    */
>   static int __collapse_huge_page_swapin(struct mm_struct *mm,
> -				       struct vm_area_struct *vma,
> -				       unsigned long start_addr, pmd_t *pmd,
> -				       int referenced)
> +		struct vm_area_struct *vma, unsigned long start_addr,
> +		pmd_t *pmd, int referenced, unsigned int order)
>   {
>   	int swapped_in = 0;
>   	vm_fault_t ret = 0;
> -	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
> +	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
>   	int result;
>   	pte_t *pte = NULL;
>   	spinlock_t *ptl;
> @@ -1022,6 +1025,19 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>   		if (!is_swap_pte(vmf.orig_pte))
>   			continue;
>   
> +		/*
> +		 * TODO: Support swapin without leading to further mTHP
> +		 * collapses. Currently bringing in new pages via swapin may
> +		 * cause a future higher order collapse on a rescan of the same
> +		 * range.
> +		 */
> +		if (order != HPAGE_PMD_ORDER) {
> +			pte_unmap(pte);
> +			mmap_read_unlock(mm);
> +			result = SCAN_EXCEED_SWAP_PTE;
> +			goto out;
> +		}
> +
>   		vmf.pte = pte;
>   		vmf.ptl = ptl;
>   		ret = do_swap_page(&vmf);
> @@ -1142,7 +1158,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   		 * that case.  Continuing to collapse causes inconsistency.
>   		 */
>   		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced);
> +						     referenced, HPAGE_PMD_ORDER);
>   		if (result != SCAN_SUCCEED)
>   			goto out_nolock;
>   	}
> @@ -1190,6 +1206,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
>   	if (pte) {
>   		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> +						      HPAGE_PMD_ORDER,
>   						      &compound_pagelist);
>   		spin_unlock(pte_ptl);
>   	} else {
> @@ -1220,6 +1237,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   
>   	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
>   					   vma, address, pte_ptl,
> +					   HPAGE_PMD_ORDER,
>   					   &compound_pagelist);
>   	pte_unmap(pte);
>   	if (unlikely(result != SCAN_SUCCEED))


