Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F2DDCD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38726B0005; Thu,  4 Jun 2026 06:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA6D6B0088; Thu,  4 Jun 2026 06:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF336B008A; Thu,  4 Jun 2026 06:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6FD6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:21:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 168BB40511
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:21:42 +0000 (UTC)
X-FDA: 84841838844.06.E8E6E3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7AF1C4000A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:21:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TePkBcmi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780568500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BGk+iXT1H3gZNp8a7X8SEMwSO53zQZ3DLb34lm32RY=;
	b=rRxhOUc+kfntPlp8OVLChkKgAT5ahaRmMXq0mhp3gwMvdxC+FvZWDVFW9SNxtoayw3iZWf
	KZNeHfJGb3usqnsBdPJj0n0boCiKrQW7kmsa9AKXUxcoI9/qrmvxlGR/P+TIsAYMyaFIhH
	uj9qUrBgyib/ta2swHAnw4nMNUq6zH8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TePkBcmi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780568500;
	b=OJcouf1MQt4sH7KSCeLZUXslA/fKOo7/8asTCqdl3OziohHKXVRyPoEjbm8p8SOAZnInPB
	R0yBo3JkestWen/FCzzRD+Gy35DR080UIOFgawMguZ5DkAoC2Nr4KL9KLd4NixPTz4hbDo
	u4tP+eiBa8tGOJJFog78qghc0gF9GQI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AF1460222;
	Thu,  4 Jun 2026 10:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967F41F00893;
	Thu,  4 Jun 2026 10:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780568499;
	bh=7BGk+iXT1H3gZNp8a7X8SEMwSO53zQZ3DLb34lm32RY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TePkBcmixLqys+AlrJsq0/gDzV1vbWzus63AbF5/NrD+F22GVvGDaXMXhCsjBw6K6
	 OFk8w3GR8nOEl8HqZ3UWoH9mDuASLC8md+/PIpoUKV3nts5bd1RDl5Lg313+zSqNwt
	 fH3ID5Uhv7nAkoFcspV+dKOM4VFDDer2cgJX8ExFkwiwIMjWT5O6e7DU4tzm30Ni+n
	 z2kgkMjvV0nPLpxaX2f8etFmHZyZ0F2rC6Vbu3WsIZqj3MZsv7qboXWTel6S7bgRkD
	 5QrRIpf5yZ5whtgSIE2y4WYuntPMlwNKYqapgx5CmBUZvbzfE7yqKy6XhWUmAhQOYG
	 nGEBeRprbsODw==
Date: Thu, 4 Jun 2026 11:21:24 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Message-ID: <aiFRVb4zhrRw-yw5@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-7-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522150009.121603-7-npache@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7AF1C4000A
X-Stat-Signature: ibrf9zyji3z5con8xdxrj81b555hhui8
X-HE-Tag: 1780568500-746980
X-HE-Meta: U2FsdGVkX1+tHWTjm4D/s3ZtrFPdqOpjL/Ena3kNIbtLEP70An5Q5W1IIeAXWxeb76HRaVI4e9mg4/qRPGTeqNqGlI+wOCVJvcBlN7bWr4Qz7RncNnwhLUTVHDwWxSFwZWCqubPaOIgHWYHKokJ3LCJI/cXdEidkDdFOygtQj8m5e6wuA7EtnEgevZxp3is0yMCm6i4/qlg2217oaI2nXGeD2wxrdTw550Di6uRITatPSn+jAPip33Sl16+NbA9Xq5fGeO3n/iNH8iSWR2R7B4qwLYtNZngPeKRbRvk9ojlfq9BnMF+4pB6cRODiY94ml0yWJWTFB62TOHsXdw/ulCfLhxNmCMA+AR+5Ozy/BBce3u2d+iWwEn2f7SdODvqUzKQM+BKaCh/lJ49crGdNCbwckIRrxs9pkvDXmoNO4e1YpKI4PnTc0BK3xhj6I19i+oC1quBqPVLsRQ5eKHTZunGmtJqI35vqcJ50B/hFzo6aE6lLDD0ztBCeB9TiqBEaVI20wYwYnfOJjrQWL2Y1PEQx5MCLTomeHXC/6UFkz+t/WSG5VOHUI3PhXKApGpH1m7ri5hefG88EivQlPhKPKyNuRqz6ITszA7Sb3tEl/hryMZvHu1mnM+cZUvGWGqctfA02dkt2IzsO3R93c2L7i1Pv2WTw1iWhcuY/+/zHSDdj7L0ZIQ37vfIYhvEq5RZQh5N2+ex43FLN4J4CrswtQ1bCSDFDE4UgbqBH/DQxL9P+Fhz7OAWgfPlWUVkxWNtyF43qauAQY7Qs55W+PvsKCoI7JJCnHcn+yA1knjbtQgsS66PAs1tQeSzgVHQ4f0EEOh+AYwAZqiVGUdtgPoNLxEfQPfxNOvVUPDI92tsm/1EB/PhG/7lV+ZcFy2lsjJABq81swRmjr7hxSnsG6PZEL46tRU5+MxhJW6s5YzCxS+FDA0Dha1BOTnbW7dl/6DKVQytquPBSOFrVLrr451O
 x3vE6P46
 XrKtGgYL7PJhGvPKhJdcEJq/f+YKqlpjxkPiQIEYCZlnVHJXQPJ9DrKgb3TwAdEqNXgLQyS2/+PfMo7a7ndZkMxDddgsyHQOK0S7H4v2vaaEQdZbFjgdp/B3UtEJ/zG00RtJLqiWPybcDiAiae3G/1hvfsznZI/tQTcJ81sKFQU22Y7JIlDr+Ophp99MN+hzACnHOLAlgWAnKhB0PPEFezFArsH+/m64U1IRdSg7kbCed/GSTl7/Q4E5Gfzhrs5ChWqDtF90YfgMFbSj6INilbTOGCAluo/hVDQcU0n0R4eEF1NcFjBDBMN80P3IRMTsOhTrlxwPvN5gCY4q7I5+Uo82w4Jw4dZzM9I8rSDbsYs1V+RBDuBMir/4XZEAjdhhwXjVt9ArGBuosgNeY1lBhLnGqRXvut56d7839
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 09:00:01AM -0600, Nico Pache wrote:
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
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 93 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 55 insertions(+), 38 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fab35d318641..d64f42f66236 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1214,34 +1214,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>   * while allocating a THP, as that could trigger direct reclaim/compaction.
>   * Note that the VMA must be rechecked after grabbing the mmap_lock again.
>   */
> -static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
> -		int referenced, int unmapped, struct collapse_control *cc)
> +static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> +		int referenced, int unmapped, struct collapse_control *cc,
> +		unsigned int order)
>  {
> +	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
> +	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
>  	LIST_HEAD(compound_pagelist);
>  	pmd_t *pmd, _pmd;
> -	pte_t *pte;
> +	pte_t *pte = NULL;

Hmm, this part of the patch wasn't taken, and now we have uninitialised state
being dereferenced (see [0])

[0]:https://lore.kernel.org/all/aiFO1RlpZ7Ki44y1@lucifer/

Did a review comment here somehow cause this to be changed in the patch?

Andrew - was there an error in applying the patch somehow?

Thanks, Lorenzo

>  	pgtable_t pgtable;
>  	struct folio *folio;
>  	spinlock_t *pmd_ptl, *pte_ptl;
>  	enum scan_result result = SCAN_FAIL;
>  	struct vm_area_struct *vma;
>  	struct mmu_notifier_range range;
> +	bool anon_vma_locked = false;
>
> -	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
> -
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
> @@ -1253,8 +1255,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
> @@ -1269,20 +1271,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
> @@ -1294,26 +1297,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * Parallel GUP-fast is fine since GUP-fast will back off when
>  	 * it detects PMD is changed.
>  	 */
> -	_pmd = pmdp_collapse_flush(vma, address, pmd);
> +	_pmd = pmdp_collapse_flush(vma, pmd_addr, pmd);
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
>  		/*
>  		 * We can only use set_pmd_at when establishing
>  		 * hugepmds and never for establishing regular pmds that
> @@ -1321,21 +1321,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
> @@ -1345,18 +1348,32 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
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
> +	if (is_pmd_order(order)) {
> +		pgtable = pmd_pgtable(_pmd);
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> +	} else {
> +		/*
> +		 * set_ptes is called in map_anon_folio_pte_nopf with the
> +		 * pmd_ptl lock still held; this is safe as the PMD is expected
> +		 * to be none. The pmd entry is then repopulated below.
> +		 */
> +		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
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
> @@ -1536,7 +1553,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		/* collapse_huge_page expects the lock to be dropped before calling */
>  		mmap_read_unlock(mm);
>  		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc);
> +					    unmapped, cc, HPAGE_PMD_ORDER);
>  		/* collapse_huge_page will return with the mmap_lock released */
>  		*lock_dropped = true;
>  	}
> --
> 2.54.0
>

