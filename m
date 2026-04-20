Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB29CF588DE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD126B0088; Mon, 20 Apr 2026 10:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3844B6B0099; Mon, 20 Apr 2026 10:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A3A6B00A1; Mon, 20 Apr 2026 10:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8936B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:21:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9314C3205
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:21:10 +0000 (UTC)
X-FDA: 84679146300.11.2C6D5C3
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7314A0006
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:21:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kmERDZB5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776694869; a=rsa-sha256;
	cv=none;
	b=jOG82j8ckJw4/T0S4ojxrp3rJLfbS28uDvlWERu4qoj4QmpFwMxnT2a1Tub9NHfHgoQg4H
	AvihfBr6QY2hjY/7dztEIVs7uvygWBTrjaaQCAfh475+i6IrsJ5RWfdWLmxrjNGeWCKDH9
	Dm//sMDe56GkjB95Z/FO8htkmRxwvzU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kmERDZB5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776694869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvXNdOlMFU/uewuZYAJBagQMjRJClhViZSSCNL7E9EE=;
	b=eQf2WKHX1bGUZzILSTraAo6bvtRS+6qBLI9X5FQzz4HT58q3CvxHWXaedlaDSQGKytfSMx
	kmDsSvEkZh5RYHgll579MTvN4rvUlf4bB1AV7VDwSN3jSLxqLufX9ibZARVigsfOn1ApCd
	M1poD10EDfqbezUp6B0zb2XRSpy/ci4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776694866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvXNdOlMFU/uewuZYAJBagQMjRJClhViZSSCNL7E9EE=;
	b=kmERDZB5fpic6fpNcgoHoXNyAiM8IQNl1tBv84N+qSvlbUe7sCeeXdnHLiLU8kMKLp7cF1
	3kM1GF3t7sfE6xKc0eUoWnEFinrDuhX+qZj2DaKmDnK/1aSV2yw5e9r0YX4JnblTkYBDqW
	ZFqSDKgdM6GdGhPalPqfTPTuF2Ke550=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 05/13] mm/khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Mon, 20 Apr 2026 07:20:54 -0700
Message-ID: <20260420142057.392263-1-usama.arif@linux.dev>
In-Reply-To: <20260419185750.260784-6-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E7314A0006
X-Rspamd-Server: rspam12
X-Stat-Signature: zxfysu3q3i5x5rt6r6xf6ntsw4grrx4y
X-Rspam-User: 
X-HE-Tag: 1776694868-58747
X-HE-Meta: U2FsdGVkX19Z0lhTjRl7w4y5J/XHI56lEe+ahylGfC+TbjiM/3n3FlIZ9JZRsOuh7YZhIMvmtsUUleSUCIY7ACpaSOCw+phnsEko2byYKMx0pN91t4zWFywuPFrbk6XoUWHwsnjZswWj3PBaaZqbGlw1PVnVPyi2h2t3DokgvaoHAGWgVAEbyKFDovpGtBJYvh4u+o3e26R7bJl4tAt5EHB6K059Q6CJwRJn7TWOj6Noyl0fw60Lte9AW32NWOTxDZawdAoxJYDumsIKDaHZvp3V7AJYGUB0gdJu6naNg4+M86DYFyDQpYQKIrG0DAtSgGlqaMpqNagVInLNVxgYUHOEnyxy1di1GPFWeofUENMQvua2dEXRlTtFxLN7nygynqtw2KFjMEdvA9keaLGe3FRQVb7Zb/UNDvNzFbYJEDQGLtpcl1P0CqA37LSs6Y53vXAPunsy0BZ4/UljatWB80PdzJiOcIgDq749w3t2RRe3FOhseDDe1btes7mXrnKRrVYMxVlhrrJCKUfnX/avXE4Wvp7oa/z3ho/LXNY3OmUDpWnyTy042Llp4lRUQ9oLWAGCXsZ+yd2NmZbs0vJH7r8nRYBAglC6z0bi4ZWRMHiMwBNyvNi3h2zJwS8vfIQ0Cu8C5GP1301Sin2wwXMsyp7g4wpOVTyC5CCjv4ZOv6byJpI7pC9ZtoTYMJUypQXA/3/21qGfJxoRdWolq0PsJSXodlzoe9ncs+rGuIn2Fz5FZnFkD47hnaut5sD2I/4isebyIMbP5YdrDQkAkPoyLjiKG8cSCe8xo4mNhYch2u2OREG4MP/3stTZSX1Cdxsug+F5VWT69ox6n0kVlb84bSXsoFtP5N6J0qYf98v93KlbSXgPbWzrns/63nDQz3Ombrg6GpdAK8g3Jz0R9HwkWVmWUU9JTxsBjc0iaCBAiN1K7HiL1NDj4s3xBH9wfmweRgG7avG/Vjwld5GSIxn
 +odbJbcY
 vHpkwbnA10VPQUr/CSLPJ0zaq6PjKnAiUeO3AovF4TQ9eIO2dg8k6a94z0LH/drHcfz4HqAMKtysmlfPcd6ZOytpgF4WxJu63aeClAnF9/Hm8+t/UNEN+c0hgqco0LM5zPEkUpRMbsChc2gaBECFp8lR6DEN4cA6Pcc50MNhkijr1fGNF+L5yOG3/FbfYkrfa5j7H+aNN0E1DgaujD9utOMGdsNe67SE/m01+7sMEgbZEYJl5ee3OYxqMmtglr3Bbyl+HdSJ+3rN5EcHTxJmTVSOdHtFC4ExPXKhR3MX01GfYYRt1ckIplJxBQ2aJBeEt96MGbWnU+el7A3y0kAmu5bxr+C1ApiXfM8MKGbiZTvrfwjM5HRcx7yVHzAFja4GCswo6vtStZ4sFmj1Wz0tR2djLlY0oPQAIV3yS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 12:57:42 -0600 Nico Pache <npache@redhat.com> wrote:

> Pass an order and offset to collapse_huge_page to support collapsing anon
> memory to arbitrary orders within a PMD. order indicates what mTHP size we
> are attempting to collapse to, and offset indicates were in the PMD to
> start the collapse attempt.
> 
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> the mTHP case this is not true, and we must keep the lock to prevent
> access/changes to the page tables. This can happen if the rmap walkers hit
> a pmd_none while the PMD entry is currently unavailable due to being
> temporarily removed during the collapse phase.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 103 +++++++++++++++++++++++++++---------------------
>  1 file changed, 57 insertions(+), 46 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 283bb63854a5..ff6f9f1883ed 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1198,42 +1198,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	return SCAN_SUCCEED;
>  }
>  
> -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
> -		int referenced, int unmapped, struct collapse_control *cc)
> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> +		int referenced, int unmapped, struct collapse_control *cc,
> +		unsigned int order)
>  {
>  	LIST_HEAD(compound_pagelist);
>  	pmd_t *pmd, _pmd;
> -	pte_t *pte;
> +	pte_t *pte = NULL;
>  	pgtable_t pgtable;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
>  	enum scan_result result = SCAN_FAIL;
>  	struct vm_area_struct *vma;
>  	struct mmu_notifier_range range;
> +	bool anon_vma_locked = false;
> +	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
> +	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
>  
> -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> -
> -	/*
> -	 * Before allocating the hugepage, release the mmap_lock read lock.
> -	 * The allocation can take potentially a long time if it involves
> -	 * sync compaction, and we do not need to hold the mmap_lock during
> -	 * that. We will recheck the vma after taking it again in write mode.
> -	 */
> -	mmap_read_unlock(mm);
> -

My understanding now is that the caller will need to drop the mmap_read lock?

This needs explicit documentation at the start of the function IMO. I think
there are callers in later patches and its very easy to miss this.


> -	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
> +	result = alloc_charge_folio(&folio, mm, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
>  
>  	mmap_read_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> +					 &vma, cc, order);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
>  		goto out_nolock;
>  	}
>  
> -	result = find_pmd_or_thp_or_none(mm, address, &pmd);
> +	result = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
>  	if (result != SCAN_SUCCEED) {
>  		mmap_read_unlock(mm);
>  		goto out_nolock;
> @@ -1245,8 +1239,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 * released when it fails. So we jump out_nolock directly in
>  		 * that case.  Continuing to collapse causes inconsistency.
>  		 */
> -		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
> -						     referenced, HPAGE_PMD_ORDER);
> +		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
> +						     referenced, order);
>  		if (result != SCAN_SUCCEED)
>  			goto out_nolock;
>  	}
> @@ -1261,20 +1255,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * mmap_lock.
>  	 */
>  	mmap_write_lock(mm);
> -	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> -					 HPAGE_PMD_ORDER);
> +	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
> +					 &vma, cc, order);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  	/* check if the pmd is still valid */
>  	vma_start_write(vma);
> -	result = check_pmd_still_valid(mm, address, pmd);
> +	result = check_pmd_still_valid(mm, pmd_addr, pmd);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  
>  	anon_vma_lock_write(vma->anon_vma);
> +	anon_vma_locked = true;
>  
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> -				address + HPAGE_PMD_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
> +				end_addr);
>  	mmu_notifier_invalidate_range_start(&range);
>  
>  	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> @@ -1286,26 +1281,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * Parallel GUP-fast is fine since GUP-fast will back off when
>  	 * it detects PMD is changed.
>  	 */
> -	_pmd = pmdp_collapse_flush(vma, address, pmd);
> +	_pmd = pmdp_collapse_flush(vma, pmd_addr, pmd);


For an mTHP collapse covering, say, 64KiB of a 2MiB PMD, the patch still
flushes the entire PMD via pmdp_collapse_flush and tlb_remove_table_sync_one.
That triggers cross-CPU TLB shootdowns for ~1.94MiB of unrelated mappings on
every successful sub-PMD collapse. Probably acceptable as a first cut?


>  	spin_unlock(pmd_ptl);
>  	mmu_notifier_invalidate_range_end(&range);
>  	tlb_remove_table_sync_one();
>  
> -	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> +	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
>  	if (pte) {
> -		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> -						      HPAGE_PMD_ORDER,
> -						      &compound_pagelist);
> +		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
> +						      order, &compound_pagelist);
>  		spin_unlock(pte_ptl);
>  	} else {
>  		result = SCAN_NO_PTE_TABLE;
>  	}
>  
>  	if (unlikely(result != SCAN_SUCCEED)) {
> -		if (pte)
> -			pte_unmap(pte);
>  		spin_lock(pmd_ptl);
> -		BUG_ON(!pmd_none(*pmd));
> +		WARN_ON_ONCE(!pmd_none(*pmd));

Why was this turned into WARN_ON_ONCE? Would be good to add to commit message
what the reason is if it has been discussed earlier.

The next line writes a PMD entry over an existing one — that leaks the
previous page table or PMD-mapped folio and can corrupt VA mappings. BUG_ON
failed loudly and safely; WARN_ON_ONCE continues into the corruption and falls
silent after the first hit.


>  		/*
>  		 * We can only use set_pmd_at when establishing
>  		 * hugepmds and never for establishing regular pmds that
> @@ -1313,21 +1305,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 */
>  		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>  		spin_unlock(pmd_ptl);
> -		anon_vma_unlock_write(vma->anon_vma);
>  		goto out_up_write;
>  	}
>  
>  	/*
> -	 * All pages are isolated and locked so anon_vma rmap
> -	 * can't run anymore.
> +	 * For PMD collapse all pages are isolated and locked so anon_vma
> +	 * rmap can't run anymore. For mTHP collapse the PMD entry has been
> +	 * removed and not all pages are isolated and locked, so we must hold
> +	 * the lock to prevent neighboring folios from attempting to access
> +	 * this PMD until its reinstalled.
>  	 */
> -	anon_vma_unlock_write(vma->anon_vma);
> +	if (is_pmd_order(order)) {
> +		anon_vma_unlock_write(vma->anon_vma);
> +		anon_vma_locked = false;
> +	}
>  
>  	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
> -					   vma, address, pte_ptl,
> -					   HPAGE_PMD_ORDER,
> -					   &compound_pagelist);
> -	pte_unmap(pte);
> +					   vma, start_addr, pte_ptl,
> +					   order, &compound_pagelist);
>  	if (unlikely(result != SCAN_SUCCEED))
>  		goto out_up_write;
>  
> @@ -1337,18 +1332,27 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * write.
>  	 */
>  	__folio_mark_uptodate(folio);
> -	pgtable = pmd_pgtable(_pmd);
> -
>  	spin_lock(pmd_ptl);
> -	BUG_ON(!pmd_none(*pmd));
> -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> -	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> +	WARN_ON_ONCE(!pmd_none(*pmd));
> +	if (is_pmd_order(order)) { /* PMD collapse */
> +		pgtable = pmd_pgtable(_pmd);
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> +	} else { /* mTHP collapse */
> +		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);

map_anon_folio_pte_nopf calls set_ptes and modifies pagetable, while holding
pmd_ptl only. It should be safe as we expect pmd_none. But I think you should
put a comment about this?


> +		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
> +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> +	}
>  	spin_unlock(pmd_ptl);
>  
>  	folio = NULL;
>  
>  	result = SCAN_SUCCEED;
>  out_up_write:
> +	if (anon_vma_locked)
> +		anon_vma_unlock_write(vma->anon_vma);
> +	if (pte)
> +		pte_unmap(pte);
>  	mmap_write_unlock(mm);
>  out_nolock:
>  	if (folio)
> @@ -1525,8 +1529,15 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
> +		/*
> +		 * Before allocating the hugepage, release the mmap_lock read lock.
> +		 * The allocation can take potentially a long time if it involves
> +		 * sync compaction, and we do not need to hold the mmap_lock during
> +		 * that. We will recheck the vma after taking it again in write mode.
> +		 */
> +		mmap_read_unlock(mm);
>  		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc);
> +					    unmapped, cc, HPAGE_PMD_ORDER);
>  		/* collapse_huge_page will return with the mmap_lock released */
>  		*lock_dropped = true;
>  	}
> -- 
> 2.53.0
> 
> 

