Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73E6EA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 19:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544686B033F; Sun, 19 Apr 2026 15:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CBB6B0340; Sun, 19 Apr 2026 15:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431EB6B0341; Sun, 19 Apr 2026 15:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 31DB06B033F
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:00:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFAA78C4A0
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:00:18 +0000 (UTC)
X-FDA: 84676220916.07.D85B6C0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id D6DF240012
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:00:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=USR7gxlG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625217; a=rsa-sha256;
	cv=none;
	b=2QbY37/5/fOzDW2FrVFltCuTPETJyO7Yp66cMdX7ou36Wr1rhyerlA9xAFAyv2izzL2yPq
	hRZUNYG+de4P3wQsaosFj7EFC69Wt+7PtbOdKnwKv4ZZT9Y2wpkM2tI+WmyxUzijEwr/pk
	5XSaQYJIiZYgZ2HYciA028CAtTAeQqc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=USR7gxlG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKz4Kxt5SwykyMCkEEHu47ipnDsdhZipTsFPCayWNsk=;
	b=dhQuZ42CWvXW8YwXCQ1WiSHmyYJbH9P3Cq9vRTKTn76Rk0fzvG5eyABAEVFTx0LP0Tuk/m
	lG63h7sa2L2GTWFUk8AXo4QmDwl7DucLJtvTlCs8gxgSwEdZ6CLC2eFkTGOEbkLENmEOJ/
	0LKdft1LvXcbBtMCooShYP2hdza1AXs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LKz4Kxt5SwykyMCkEEHu47ipnDsdhZipTsFPCayWNsk=;
	b=USR7gxlGEQg7X4PMni7VXbh84xDnjaXFCNUjuHQZEAsA6i3UnoVaGv3Shy97GU21a86flV
	ByLEbwtL67i0dvmh+8SIOV/wggsWy5P9P82CUC3E0HRwPSGj2xMnLgHdbLstX+uEaZm54z
	xvjeYQZxag694YkvQdIAAFuI1TVYZeE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-QXaHzJMJPWuz-_0VEhczpQ-1; Sun,
 19 Apr 2026 15:00:13 -0400
X-MC-Unique: QXaHzJMJPWuz-_0VEhczpQ-1
X-Mimecast-MFC-AGG-ID: QXaHzJMJPWuz-_0VEhczpQ_1776625208
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3B5B19560AD;
	Sun, 19 Apr 2026 19:00:07 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 32837195608E;
	Sun, 19 Apr 2026 18:59:50 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
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
	npache@redhat.com,
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
Subject: [PATCH 7.2 v16 05/13] mm/khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Sun, 19 Apr 2026 12:57:42 -0600
Message-ID: <20260419185750.260784-6-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IDBre6w0PFahsphwvFcdOZN6FsZ0L8csqbU96Lcwprw_1776625208
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Stat-Signature: toxkzdksdacsfisrahwds75f1tu6gsar
X-Rspam-User: 
X-Rspamd-Queue-Id: D6DF240012
X-HE-Tag: 1776625216-83013
X-HE-Meta: U2FsdGVkX1+y9/tSHp2GaYUJveeqdSGzP+d6dHu0Y4DKfzMQKi70PZ/vnYPDMtaPGjkow9ZDSMGi6z4IqZIRfYQfHvsi58cBwl65HaWY83uop+ARKecSKt/OdXFik5FE0Adq8++ktNT6kxmiOXGp+C2rFl6gmjjARJKq1VGAjarWLcq+vg/qxpzQyrVOQwoIkiA/Hi+boRA3nOzXVM00QObRiyNeIPIVqSiGh8vKu8A9gmB2EpD2jkpEes+54i8Yc31tS9Yh96ecEz+Blblgf6IQXrUpYqfNfH6iv8MDzrSgwiYya7FjUpF5OM0YsiWzuKORbxf6b+oqLN75ajMehaArewe7Z1DSncCJsrzpk8rJ0c1oeGdEewzHqKAz55ancmyOCh2baIMfV88M59pd/S78d2Geaipyu17VALei8cADZS3SYHHGI5TyiV7mPWwi9YLbuYyIH22LkSM2EVfv8O0HMEVX/Fl5qGf4NO8+nSTmfLhj3xdY3UWHL8UkA5pqm/CPySczu3cT+gfIOLuainwkkd1zU2EMNwipx07JkgeE5R51ZscuteTAHaowIImQPAZM5MFKkal9twhkKXEtY5eLi+H5UALbgdbaLD+hLOzBT01chYI4GbiCHKeLxdKBn4b35fi4XI7fft6dJJVGuYHq13A0QB+bb7afxqa7u6EM9KXtihXbD9yUDgWv3r5YTMOUN0zT7Y+zI2kowqGkwvboWMSN05gZsGrfGgB4Qc2Ei0UsyaRVQLzIHmEFIGwAIZte/FYQGzVsQ6O9DA2W4sp0ngOP9spplD8ZqGSE7DHFRJ/Z/4NKeo5eyCj4aHaWJ6NPpsm3BHk1LOnYzPJVlzPgitLAq7WcWdNyq0RU0oXY/L1BKlTGvB19paZ4zds8XJ2MjjNwSrzIXIiIOZ7FnH0qcD1K3kKYMly//9MqNaXhn7GFLzrOWe7Fadg7D6xQrJFqIqllNUw4RvGr7wC
 V+8BDZD4
 vMJFAb1aoJe6gShn3hQybw8BF7O0KRe7RPd5F9fEMvRQugEur3KeHCSLFo3IxeruGDEtpp3Cls3ETyFSITLtTP1vXZKFqgJ9CWQMXtkyQQr15eUqWGs3nteoRvX32TM985aGYsGmMGx4672alaHnwlyCpMLJxabUDDykmWbnTmbV66v57lUQHq4FStHUvhl0FRvYf1MAX+5EzOg+KHIpcCS5JrD90f9/Ts0eL00KlS7wfgtC9Oq1RaZvQVJ+eybKd6qyVJ2gKQLNIfgqTKFxTECeQ8dN78irf7Mbr4foPTS/rRjL7663TEHMaQwKmia2Zo4gLlFU8TW6ry9IiKcREjYYn9mzEx+v+pRAAodZHGv9+FdlbVhde+4z+jc7Nuu1ZM+U5YnS1Jnxc/WqeENxJW7KbX6Rh9FfpyedrH3dcPd5hIlbsAhDLrF/RFrF35Kja7uwWA6BGtQPzXsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass an order and offset to collapse_huge_page to support collapsing anon
memory to arbitrary orders within a PMD. order indicates what mTHP size we
are attempting to collapse to, and offset indicates were in the PMD to
start the collapse attempt.

For non-PMD collapse we must leave the anon VMA write locked until after
we collapse the mTHP-- in the PMD case all the pages are isolated, but in
the mTHP case this is not true, and we must keep the lock to prevent
access/changes to the page tables. This can happen if the rmap walkers hit
a pmd_none while the PMD entry is currently unavailable due to being
temporarily removed during the collapse phase.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 103 +++++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 46 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 283bb63854a5..ff6f9f1883ed 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1198,42 +1198,36 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	return SCAN_SUCCEED;
 }
 
-static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
-		int referenced, int unmapped, struct collapse_control *cc)
+static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
+		int referenced, int unmapped, struct collapse_control *cc,
+		unsigned int order)
 {
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
-	pte_t *pte;
+	pte_t *pte = NULL;
 	pgtable_t pgtable;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	enum scan_result result = SCAN_FAIL;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
+	bool anon_vma_locked = false;
+	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
+	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
 
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-
-	/*
-	 * Before allocating the hugepage, release the mmap_lock read lock.
-	 * The allocation can take potentially a long time if it involves
-	 * sync compaction, and we do not need to hold the mmap_lock during
-	 * that. We will recheck the vma after taking it again in write mode.
-	 */
-	mmap_read_unlock(mm);
-
-	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
+	result = alloc_charge_folio(&folio, mm, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
-					 HPAGE_PMD_ORDER);
+	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+					 &vma, cc, order);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
 	}
 
-	result = find_pmd_or_thp_or_none(mm, address, &pmd);
+	result = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1245,8 +1239,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
-		result = __collapse_huge_page_swapin(mm, vma, address, pmd,
-						     referenced, HPAGE_PMD_ORDER);
+		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
+						     referenced, order);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1261,20 +1255,21 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
-					 HPAGE_PMD_ORDER);
+	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+					 &vma, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
 	vma_start_write(vma);
-	result = check_pmd_still_valid(mm, address, pmd);
+	result = check_pmd_still_valid(mm, pmd_addr, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 
 	anon_vma_lock_write(vma->anon_vma);
+	anon_vma_locked = true;
 
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
-				address + HPAGE_PMD_SIZE);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
+				end_addr);
 	mmu_notifier_invalidate_range_start(&range);
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
@@ -1286,26 +1281,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * Parallel GUP-fast is fine since GUP-fast will back off when
 	 * it detects PMD is changed.
 	 */
-	_pmd = pmdp_collapse_flush(vma, address, pmd);
+	_pmd = pmdp_collapse_flush(vma, pmd_addr, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_remove_table_sync_one();
 
-	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
+	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
 	if (pte) {
-		result = __collapse_huge_page_isolate(vma, address, pte, cc,
-						      HPAGE_PMD_ORDER,
-						      &compound_pagelist);
+		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
+						      order, &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
 		result = SCAN_NO_PTE_TABLE;
 	}
 
 	if (unlikely(result != SCAN_SUCCEED)) {
-		if (pte)
-			pte_unmap(pte);
 		spin_lock(pmd_ptl);
-		BUG_ON(!pmd_none(*pmd));
+		WARN_ON_ONCE(!pmd_none(*pmd));
 		/*
 		 * We can only use set_pmd_at when establishing
 		 * hugepmds and never for establishing regular pmds that
@@ -1313,21 +1305,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		 */
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		spin_unlock(pmd_ptl);
-		anon_vma_unlock_write(vma->anon_vma);
 		goto out_up_write;
 	}
 
 	/*
-	 * All pages are isolated and locked so anon_vma rmap
-	 * can't run anymore.
+	 * For PMD collapse all pages are isolated and locked so anon_vma
+	 * rmap can't run anymore. For mTHP collapse the PMD entry has been
+	 * removed and not all pages are isolated and locked, so we must hold
+	 * the lock to prevent neighboring folios from attempting to access
+	 * this PMD until its reinstalled.
 	 */
-	anon_vma_unlock_write(vma->anon_vma);
+	if (is_pmd_order(order)) {
+		anon_vma_unlock_write(vma->anon_vma);
+		anon_vma_locked = false;
+	}
 
 	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
-					   vma, address, pte_ptl,
-					   HPAGE_PMD_ORDER,
-					   &compound_pagelist);
-	pte_unmap(pte);
+					   vma, start_addr, pte_ptl,
+					   order, &compound_pagelist);
 	if (unlikely(result != SCAN_SUCCEED))
 		goto out_up_write;
 
@@ -1337,18 +1332,27 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
-	pgtable = pmd_pgtable(_pmd);
-
 	spin_lock(pmd_ptl);
-	BUG_ON(!pmd_none(*pmd));
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
-	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
+	WARN_ON_ONCE(!pmd_none(*pmd));
+	if (is_pmd_order(order)) { /* PMD collapse */
+		pgtable = pmd_pgtable(_pmd);
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
+	} else { /* mTHP collapse */
+		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
+		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
+		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
+	}
 	spin_unlock(pmd_ptl);
 
 	folio = NULL;
 
 	result = SCAN_SUCCEED;
 out_up_write:
+	if (anon_vma_locked)
+		anon_vma_unlock_write(vma->anon_vma);
+	if (pte)
+		pte_unmap(pte);
 	mmap_write_unlock(mm);
 out_nolock:
 	if (folio)
@@ -1525,8 +1529,15 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
+		/*
+		 * Before allocating the hugepage, release the mmap_lock read lock.
+		 * The allocation can take potentially a long time if it involves
+		 * sync compaction, and we do not need to hold the mmap_lock during
+		 * that. We will recheck the vma after taking it again in write mode.
+		 */
+		mmap_read_unlock(mm);
 		result = collapse_huge_page(mm, start_addr, referenced,
-					    unmapped, cc);
+					    unmapped, cc, HPAGE_PMD_ORDER);
 		/* collapse_huge_page will return with the mmap_lock released */
 		*lock_dropped = true;
 	}
-- 
2.53.0


