Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF71C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577076B009D; Tue, 11 Aug 2026 08:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527CE6B009E; Tue, 11 Aug 2026 08:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379EE6B009F; Tue, 11 Aug 2026 08:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5B26B009D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:49:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8832E1403D3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:32 +0000 (UTC)
X-FDA: 85088969784.19.008BE76
Received: from out-181.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf23.hostedemail.com (Postfix) with ESMTP id E3E63140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NUHw6mgB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of nico.pache@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S0naQZB/DpgBMpRSB18moV5dYuwkkCVZRrrnKUkrNGc=;
	b=aRhQxG98kOjUpbnPkYCRziFNjkrgUaBgeDEk6xtZaHUBkoVJj4N8+TUJsyDMXkZeNOUwKU
	aOHEQAWKenrPedNU1p5xFlX1neZy8UN9ZaIAQqk7nVJlCQdLhIJbRLxtHY/QeJqvdTVqj2
	nXcwCfJ+F/IXImxAayda+b4kKQY3yCw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NUHw6mgB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of nico.pache@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452571;
	b=zN9YwzbSofsBYA2+FSjOT54XoU9pdPk0QsL9IgeEXNBj2UxcYBRtHku7bmu98Hf/vy2+7u
	tcDlvxaz5pavawNy281zIj5GFcX1Re5SoSm32H/bI1OzgSob7W6C/WsvUNxx4C8BlNqHiP
	aGIw9/yIagd8ChlPvjPIaAEb02DhQWo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786452569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S0naQZB/DpgBMpRSB18moV5dYuwkkCVZRrrnKUkrNGc=;
	b=NUHw6mgBxJCSbQkBC2lPDn37fHG4Qr2OrJl1bVwuRY5/JrSTKjQJlrUb6FCXScmuLpLmOT
	7GXOPIq5oRWik7b6gpAVWFavUX/TH6GFRb34FNHHjLK0hEbI1LQn7bZ7l2CJbzD+NS3PnR
	mFcwR2B02FA0LFe8uVmEjzcAhvZMj6U=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 11 Aug 2026 06:48:36 -0600
Subject: [PATCH v4 4/7] mm/khugepaged: fix outdated comments
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3E63140004
X-Stat-Signature: qptt15m4rnkc3n1x6m1tcdm9wbuy7myp
X-Rspam-User: 
X-HE-Tag: 1786452570-910465
X-HE-Meta: U2FsdGVkX1/5QOyjbc9wlStXlvfQE66D05hKT4sfsrG4Dx1lmR0d3yqK20pI67V/RsaxRtSsGaySGoctfeA1HKHjI/fkvpcIF+O0X+BGhr1TGdVa4ZZagUOFhiRi4e9WkZP6StVb7AiCZGiH/yKCiEauIS53UEM8uhiLAY/u9OELIDy1DMGmMrDLg7O7kS32G9Tz28voDsVxQMz/QHZKglZaM4rzqla19V2VPQ2pIyIXqheSNEknWYDIPYgvy9hCpXNcygk7UbVN0cgaqMEY7kWz6aEQPSarrVWE7g3W+HSMjrZltH1PkZiP6RYgncEy4nO7/AIhA3bMkYVgg/zD8WTjK2vsIDJII2e7OoRmA/VS1kGowvtTj2AY0H3JhUj3dzKZ4RaxvJlyu2HL3B+bIgE7p1kjOxG1eklJdbMd5E4hn4t4yVgr3gpedJ4sBQoHE2cZ2J0XXp8hvIen8nLJKY/YeankmVRZwH+BesA1k7m3hNXpY5jeAhkeYsJhQpzyifuSmrz/kOMW6t3Cbhe3vWZY0m5V7zU+ZuuP7z+qhBTR+qYf7ZOh68sgFF34GXhPkTkndi9ILHRjBb5nblnhp3IJPmRqavOuM72ezHfgM8uNthHMXkqEMeLU1a3oAumPXKQpAP2u4TwqAztwdpYNh+ExL7A8cMlvlV8Bh1X7pdnNfhx9lbUYo8fRZ+oJRNF+soyE8L3RvU6qJW0Bxwmn0Kdp9S6fb16q8eBwzsL+3z4nZQvwADBo1tT/zQoyLC7PTMiMEEFDoR0Q1SFhEHBx/AmSWBPUHBpARYoRaswjxtUCPW2UHEtvt6upZ+mJ+rAwA3mkevGTbjzWa0jg960K9uRgBLTso9wR0FhnUhnD8bpA8mxDilXKB4qVfWnPoigLhtwDOKIfC4W6Seney004zg9uhZIYpmcEoxPDLal7qslqzXkcpeUIpblU5tmERbxJ3hoZkzuW2bWwMS6kffb
 NHp2u3+D
 pkcSjUkaCvPBiG8cuSnd0tt3vP6IemQ7O6v22amkHGV6OJ2//kOPKbiS+CgAsv5C7PGSzzCny9UqogMlEetWvR/p7fTOhdhvf/Ntk7y1ULV+oPqV0hnmE6AkAJUXv1/tuXSH34WvG7swQQwLn4OdK1Tq8Yp4rW7AgFfWpcTxk40hs1ifihuofcxYiCiLRXgQCievf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix comment in collapse_scan_pmd() that still described the old
folio_mapcount() > folio_ref_count() check and a "512" false-positive
scenario. The code now uses folio_expected_ref_count() != folio_ref_count()
which doesn't suffer from the same limitation.

Fix comment in collapse_huge_page() that referenced ptep_clear_flush,
when the code actually uses pmdp_collapse_flush.

Fix comment in __collapse_huge_page_swapin() that referenced the old
function name khugepaged_scan_pmd, now collapse_scan_pmd.

Also clean up some simple typos and stale terminology (mmap_sem ->
mmap_lock, PG_lock -> folio lock, page -> folio, grammar).

We also clarify a comment regarding where the max_ptes_none check is
deferred to in mthp_collapse() from the original collapse_scan_pmd check.

Update all comments that references a function to include parentheses.

Acked-by: Usama Arif <usama.arif@linux.dev>
Assisted-by: Cursor(claude-sonnet-4):4.6
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index cae510aa2914..90d6e595d282 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -620,7 +620,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 		/*
 		 * This is required to serialize against
 		 * collapse_test_exit() (which is guaranteed to run
-		 * under mmap sem read mode). Stop here (after we return all
+		 * under mmap_lock read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
 		 */
@@ -788,8 +788,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/*
 		 * We can do it before folio_isolate_lru because the
-		 * folio can't be freed from under us. NOTE: PG_lock
-		 * is needed to serialize against split_huge_page
+		 * folio can't be freed from under us. NOTE: folio lock
+		 * is needed to serialize against split_huge_page()
 		 * when invoked from the VM.
 		 */
 		if (!folio_trylock(folio)) {
@@ -815,7 +815,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		}
 
 		/*
-		 * Isolate the page to avoid collapsing an hugepage
+		 * Isolate the folio to avoid collapsing a hugepage
 		 * currently in use by the VM.
 		 */
 		if (!folio_isolate_lru(folio)) {
@@ -927,7 +927,7 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
 	 * Re-establish the PMD to point to the original page table
 	 * entry. Restoring PMD needs to be done prior to releasing
 	 * pages. Since pages are still isolated and locked here,
-	 * acquiring anon_vma_lock_write is unnecessary.
+	 * acquiring anon_vma_lock_write() is unnecessary.
 	 */
 	pmd_ptl = pmd_lock(vma->vm_mm, pmd);
 	pmd_populate(vma->vm_mm, pmd, pmd_pgtable(orig_pmd));
@@ -1101,9 +1101,9 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
-	 * remapped to file after khugepaged reaquired the mmap_lock.
+	 * remapped to file after khugepaged reacquired the mmap_lock.
 	 *
-	 * thp_vma_allowable_orders may return true for qualified file
+	 * thp_vma_allowable_orders() may return true for qualified file
 	 * vmas.
 	 */
 	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
@@ -1159,7 +1159,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if khugepaged_scan_pmd believes it is worthwhile.
+ * Only done if collapse_scan_pmd() believes it is worthwhile.
  *
  * For mTHP orders the function bails on the first swap entry, because
  * faulting pages back in during collapse could re-populate PTEs that
@@ -1227,7 +1227,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 		pte = NULL;
 
 		/*
-		 * do_swap_page returns VM_FAULT_RETRY with released mmap_lock.
+		 * do_swap_page() returns VM_FAULT_RETRY with released mmap_lock.
 		 * Note we treat VM_FAULT_RETRY as VM_FAULT_ERROR here because
 		 * we do not retry here and swap entry will remain in pagetable
 		 * resulting in later failure.
@@ -1291,7 +1291,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 }
 
 /*
- * collapse_huge_page expects the mmap_lock to be unlocked before entering and
+ * collapse_huge_page() expects the mmap_lock to be unlocked before entering and
  * will always return with the lock unlocked, to avoid holding the mmap_lock
  * while allocating a THP, as that could trigger direct reclaim/compaction.
  * Note that the VMA must be rechecked after grabbing the mmap_lock again.
@@ -1338,7 +1338,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 
 	if (unmapped) {
 		/*
-		 * __collapse_huge_page_swapin will return with mmap_lock
+		 * __collapse_huge_page_swapin() will return with mmap_lock
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
@@ -1351,8 +1351,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	mmap_read_unlock(mm);
 	/*
 	 * Prevent all access to pagetables with the exception of
-	 * gup_fast later handled by the ptep_clear_flush and the VM
-	 * handled by the anon_vma lock + PG_lock.
+	 * gup_fast later handled by the pmdp_collapse_flush() and the VM
+	 * handled by the anon_vma lock + folio lock.
 	 *
 	 * UFFDIO_MOVE is prevented to race as well thanks to the
 	 * mmap_lock.
@@ -1409,9 +1409,9 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 		spin_lock(pmd_ptl);
 		VM_WARN_ON_ONCE(!pmd_none(*pmd));
 		/*
-		 * We can only use set_pmd_at when establishing
+		 * We can only use set_pmd_at() when establishing
 		 * hugepmds and never for establishing regular pmds that
-		 * points to regular pagetables. Use pmd_populate for that
+		 * points to regular pagetables. Use pmd_populate() for that
 		 */
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
 		spin_unlock(pmd_ptl);
@@ -1643,7 +1643,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
-	 * scan all pages to populate the bitmap for mTHP collapse.
+	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
+	 * is then checked again in mthp_collapse() for each attempted order.
 	 */
 	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
 		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
@@ -1764,12 +1765,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		/*
 		 * Check if the page has any GUP (or other external) pins.
 		 *
-		 * Here the check may be racy:
-		 * it may see folio_mapcount() > folio_ref_count().
-		 * But such case is ephemeral we could always retry collapse
-		 * later.  However it may report false positive if the page
-		 * has excessive GUP pins (i.e. 512).  Anyway the same check
-		 * will be done again later the risk seems low.
+		 * Here the check is racy, but such case is ephemeral and
+		 * we could always retry collapse later. Anyway the same
+		 * check will be done again later the risk seems low.
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
@@ -1790,7 +1788,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		/* collapse_huge_page expects the lock to be dropped before calling */
+		/* collapse_huge_page() expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
 		result = mthp_collapse(mm, start_addr, referenced,
 				       unmapped, cc, enabled_orders);

-- 
2.55.0


