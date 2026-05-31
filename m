Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B68FCD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8796B0123; Sun, 31 May 2026 05:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562886B0124; Sun, 31 May 2026 05:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403C96B0125; Sun, 31 May 2026 05:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFEF6B0123
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:40:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE5B78DCD2
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:40:02 +0000 (UTC)
X-FDA: 84827218644.07.9A6F178
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id DCC992000D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:40:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cBPRo2xp;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780220401; a=rsa-sha256;
	cv=none;
	b=Z98bQ2ZFA+ZwV3vgybBRZ0PHXc9y5ZU6yTWSXopTdQbKQlxeDBEqhaTBr1qNdZjNT4iA1S
	a+VTPvI9v8sUMLA/RQ64hcxAuAxWIO7zr1iEnOz1Tk4aAiCp3K4s76xUMleSYFIGOJ2QKU
	hmj321IcLFgphCwnrbiDnpqI5q/x1Qk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cBPRo2xp;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780220401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDqpOm4GUMbmXnNlKMQcoCkHdGOfT4SYZ50geLI7x88=;
	b=b3dVSkI2nWglK9bc+xOk3rQMpiKPRoyTSt1n7pX07TUiQWuoeaN4/rotWKtBEzjS2D58ic
	7p99K5YuQbgtbXonzMh2EGkZv8j/kcV3/1oWkL4wZo7Dmf3iYqSvygNzG7X23ZQ/m3H4p+
	78sROq0sBRPcrdpNlxKI4l5POa0Y/Ac=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780220398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDqpOm4GUMbmXnNlKMQcoCkHdGOfT4SYZ50geLI7x88=;
	b=cBPRo2xpHgEFrS06avLHNIBZGggrrVtlB5XZ+WsYxzDe2PXPZRngmY+/U1AUH7pR5wkT2Q
	vnplr+blS3IBIuHIWL4br9MlrOAlw02LleDz+ZfMpxxHTb4BA8VqAyZsPGwW+psK0U3mb2
	to1DOY5Cw2X6iSU8cz4Otw+jhAK5KGg=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
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
	liam@infradead.org,
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
	zokeefe@google.com,
	usama.arif@linux.dev
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Sun, 31 May 2026 17:39:42 +0800
Message-Id: <20260531093942.19644-1-lance.yang@linux.dev>
In-Reply-To: <20260522150009.121603-7-npache@redhat.com>
References: <20260522150009.121603-7-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DCC992000D
X-Stat-Signature: 1sn8xcscc9edi5oke4s11yo3he36aabp
X-HE-Tag: 1780220400-78973
X-HE-Meta: U2FsdGVkX19YPebJQr6Hy+loC9GIkdvQMjwEpuKM2MMF+4SHTE0nCMrhn/tCjJlao2+Sfakei+cl4jR/nZ0GwxBLDL/bFB02FzsPvsNqmUaDs6DKZVjOsy3ktj+yCbPraL4TGGTO9rfIiB5HqnxoryGrghNRAwHWFgHmG9my+AVzJbHuc72sz98fcmW9Z46wxeMxGyJUBZn650YYwENOqQ0ZCLvdUO4d5JdEbHT/1o4IHgXyjj2kEnHB0Jiurj5T+CPfAmTZzxFkoRYvEIIsc/bkA4sZlXhd2O7JgSWpC7Cs/Rzzb6rra1BegmDkbF4aKFp8CCREJf6YBTURfmiVOdYgAl16BJfKwSFwMqXbQukbA28ug8rkXLvU8bw9rlD/dQB0jGWI0j2CFMo26ueS8V7iyZibTajs5d5leu+q4vh0qAO8prrWO1T6lfeo7H4vfSNb5fHuQPtOFSZgGSGt5nQJ2kEcoj2IuvPXUHu+s1Zza/KpjIN4hLwlsVxx5y14PJKTAvng9vmGosVy7+oV3YM7wBWBHTWuq4cZ2saNCmALKKYWUxJU5vNK6yia3+1PUELUmF/kDJwQZwpqDT6je1fnNaj48WtorKzHcG/qO9qWpbwuzTVF00kgxAxlIL2bZ7u2XPyszCUHKJwkQ5AKe7ZwyPkcRYDQbsvtMB6+nQwyndwSTK8feCebNKtKuwkaDqsKBtAzX4drA+BkygK171RVmHny+rB7hjeX5tPvSzawXvQ3ejuY7Hr5O4YcXA12ALE3XeQJ9cFcycY5t7tB0KOv1OFEAMeud5awqBy4xv0Un0T4vuGlkUO4bxbnQ/lEx5/E8uzyDezZg+Fa3LU86oq6JPQHx2j9pTvGz5mPpo6GS+XY/uoE+dGPTcL28lNH9IWOLrfRjCh76ZnLMEw05oANP589yPd4bjqfPDuTaNoMLGdUxyftyq/dqIIfZEW3y52Ra4DP0Nps37y+xi2
 8qQD/cbd
 iq8jwu8+un7unz8x5q1xHsJr8kNTXW59rEgtbsovVK1cm1Uxlq9vggw5W7+theLJ5kl6aOFDo8+diqSDPOx0EFUs3eTFDXArmvEo/FtKPDcr2xD0TwlXxdiqv89EbF2E2hLHMn8i7BDjPlc1HhViGk2KFgs+lOWI1y99brKk6fwksN3eiSWnl2UlbUwsKUB6XKgfzcgYyb3tx0it/YXGkow+GwVSh1vyFXTsfMUGusVdcJtCGl/NFQBQkunaO3GCR0BDh2TOt6/Qpe8Ngk9pWRlXHaHOWZMOVJgysJDuCRZzxoKWRaNXYf5D/Npd1UwAzwNtnHr/ULb9a+fLLFMjSryIQIggje+RrZ9Isdna0fPSBsDQRG5lOBQbK8TLxZDwT/vCA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 22, 2026 at 09:00:01AM -0600, Nico Pache wrote:
>Pass an order and offset to collapse_huge_page to support collapsing anon
>memory to arbitrary orders within a PMD. order indicates what mTHP size we
>are attempting to collapse to, and offset indicates were in the PMD to
>start the collapse attempt.
>
>For non-PMD collapse we must leave the anon VMA write locked until after
>we collapse the mTHP-- in the PMD case all the pages are isolated, but in
>the mTHP case this is not true, and we must keep the lock to prevent
>access/changes to the page tables. This can happen if the rmap walkers hit
>a pmd_none while the PMD entry is currently unavailable due to being
>temporarily removed during the collapse phase.
>
>Acked-by: Usama Arif <usama.arif@linux.dev>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---
> mm/khugepaged.c | 93 +++++++++++++++++++++++++++++--------------------
> 1 file changed, 55 insertions(+), 38 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index fab35d318641..d64f42f66236 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1214,34 +1214,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  * while allocating a THP, as that could trigger direct reclaim/compaction.
>  * Note that the VMA must be rechecked after grabbing the mmap_lock again.
>  */
>-static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
>-		int referenced, int unmapped, struct collapse_control *cc)
>+static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
>+		int referenced, int unmapped, struct collapse_control *cc,
>+		unsigned int order)
> {
>+	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
>+	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
> 	LIST_HEAD(compound_pagelist);
> 	pmd_t *pmd, _pmd;
>-	pte_t *pte;
>+	pte_t *pte = NULL;
> 	pgtable_t pgtable;
> 	struct folio *folio;
> 	spinlock_t *pmd_ptl, *pte_ptl;
> 	enum scan_result result = SCAN_FAIL;
> 	struct vm_area_struct *vma;
> 	struct mmu_notifier_range range;
>+	bool anon_vma_locked = false;
> 
>-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>-
>-	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
>+	result = alloc_charge_folio(&folio, mm, cc, order);
> 	if (result != SCAN_SUCCEED)
> 		goto out_nolock;
> 
> 	mmap_read_lock(mm);
>-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
>-					 HPAGE_PMD_ORDER);
>+	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
>+					 &vma, cc, order);
> 	if (result != SCAN_SUCCEED) {
> 		mmap_read_unlock(mm);
> 		goto out_nolock;
> 	}
> 
>-	result = find_pmd_or_thp_or_none(mm, address, &pmd);
>+	result = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
> 	if (result != SCAN_SUCCEED) {
> 		mmap_read_unlock(mm);
> 		goto out_nolock;
>@@ -1253,8 +1255,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> 		 * released when it fails. So we jump out_nolock directly in
> 		 * that case.  Continuing to collapse causes inconsistency.
> 		 */
>-		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
>-						     referenced, HPAGE_PMD_ORDER);
>+		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
>+						     referenced, order);
> 		if (result != SCAN_SUCCEED)
> 			goto out_nolock;
> 	}
>@@ -1269,20 +1271,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> 	 * mmap_lock.
> 	 */
> 	mmap_write_lock(mm);
>-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
>-					 HPAGE_PMD_ORDER);
>+	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
>+					 &vma, cc, order);
> 	if (result != SCAN_SUCCEED)
> 		goto out_up_write;
> 	/* check if the pmd is still valid */
> 	vma_start_write(vma);
>-	result = check_pmd_still_valid(mm, address, pmd);
>+	result = check_pmd_still_valid(mm, pmd_addr, pmd);
> 	if (result != SCAN_SUCCEED)
> 		goto out_up_write;
> 
> 	anon_vma_lock_write(vma->anon_vma);
>+	anon_vma_locked = true;
> 
>-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
>-				address + HPAGE_PMD_SIZE);
>+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
>+				end_addr);
> 	mmu_notifier_invalidate_range_start(&range);
> 
> 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
>@@ -1294,26 +1297,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> 	 * Parallel GUP-fast is fine since GUP-fast will back off when
> 	 * it detects PMD is changed.
> 	 */
>-	_pmd = pmdp_collapse_flush(vma, address, pmd);
>+	_pmd = pmdp_collapse_flush(vma, pmd_addr, pmd);
> 	spin_unlock(pmd_ptl);
> 	mmu_notifier_invalidate_range_end(&range);
> 	tlb_remove_table_sync_one();
> 
>-	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
>+	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
> 	if (pte) {
>-		result = __collapse_huge_page_isolate(vma, address, pte, cc,
>-						      HPAGE_PMD_ORDER,
>-						      &compound_pagelist);
>+		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
>+						      order, &compound_pagelist);
> 		spin_unlock(pte_ptl);
> 	} else {
> 		result = SCAN_NO_PTE_TABLE;
> 	}
> 
> 	if (unlikely(result != SCAN_SUCCEED)) {
>-		if (pte)
>-			pte_unmap(pte);
> 		spin_lock(pmd_ptl);
>-		BUG_ON(!pmd_none(*pmd));
>+		WARN_ON_ONCE(!pmd_none(*pmd));
> 		/*
> 		 * We can only use set_pmd_at when establishing
> 		 * hugepmds and never for establishing regular pmds that
>@@ -1321,21 +1321,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> 		 */
> 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> 		spin_unlock(pmd_ptl);
>-		anon_vma_unlock_write(vma->anon_vma);
> 		goto out_up_write;
> 	}
> 
> 	/*
>-	 * All pages are isolated and locked so anon_vma rmap
>-	 * can't run anymore.
>+	 * For PMD collapse all pages are isolated and locked so anon_vma
>+	 * rmap can't run anymore. For mTHP collapse the PMD entry has been
>+	 * removed and not all pages are isolated and locked, so we must hold
>+	 * the lock to prevent neighboring folios from attempting to access
>+	 * this PMD until its reinstalled.
> 	 */
>-	anon_vma_unlock_write(vma->anon_vma);
>+	if (is_pmd_order(order)) {
>+		anon_vma_unlock_write(vma->anon_vma);
>+		anon_vma_locked = false;
>+	}
> 
> 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
>-					   vma, address, pte_ptl,
>-					   HPAGE_PMD_ORDER,
>-					   &compound_pagelist);
>-	pte_unmap(pte);
>+					   vma, start_addr, pte_ptl,
>+					   order, &compound_pagelist);
> 	if (unlikely(result != SCAN_SUCCEED))
> 		goto out_up_write;
> 
>@@ -1345,18 +1348,32 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> 	 * write.
> 	 */
> 	__folio_mark_uptodate(folio);
>-	pgtable = pmd_pgtable(_pmd);
>-
> 	spin_lock(pmd_ptl);
>-	BUG_ON(!pmd_none(*pmd));
>-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
>-	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
>+	WARN_ON_ONCE(!pmd_none(*pmd));
>+	if (is_pmd_order(order)) {
>+		pgtable = pmd_pgtable(_pmd);
>+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
>+		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
>+	} else {
>+		/*
>+		 * set_ptes is called in map_anon_folio_pte_nopf with the
>+		 * pmd_ptl lock still held; this is safe as the PMD is expected
>+		 * to be none. The pmd entry is then repopulated below.
>+		 */
>+		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);

Emm ... is it safe to use map_anon_folio_pte_nopf() here?

At this point pmdp_collapse_flush() has cleared the PMD from the page
tables. The PTE table we are updating is only reachable through the saved
old PMD value, _pmd, until pmd_populate() below.

map_anon_folio_pte_nopf() does set_ptes() and then calls
update_mmu_cache_range(). Documentation/core-api/cachetlb.rst describes
that hook as:

"
	At the end of every page fault, this routine is invoked to tell
	the architecture specific code that translations now exists
	in the software page tables for address space "vma->vm_mm"
	at virtual address "address" for "nr" consecutive pages.
"

But that does not seem true here yet, since the PTE table is not
reachable from vma->vm_mm when update_mmu_cache_range() is called.

Should we avoid calling update_mmu_cache_range() until after the PTE
table is reinstalled with pmd_populate()?

Cheers, Lance

>+		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
>+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>+	}
> 	spin_unlock(pmd_ptl);
> 
> 	folio = NULL;
> 
> 	result = SCAN_SUCCEED;
> out_up_write:
>+	if (anon_vma_locked)
>+		anon_vma_unlock_write(vma->anon_vma);
>+	if (pte)
>+		pte_unmap(pte);
> 	mmap_write_unlock(mm);
> out_nolock:
> 	if (folio)
>@@ -1536,7 +1553,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> 		/* collapse_huge_page expects the lock to be dropped before calling */
> 		mmap_read_unlock(mm);
> 		result = collapse_huge_page(mm, start_addr, referenced,
>-					    unmapped, cc);
>+					    unmapped, cc, HPAGE_PMD_ORDER);
> 		/* collapse_huge_page will return with the mmap_lock released */
> 		*lock_dropped = true;
> 	}
>-- 
>2.54.0
>
>

