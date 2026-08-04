Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC172C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810A66B00EC; Tue,  4 Aug 2026 15:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A0F6B00EF; Tue,  4 Aug 2026 15:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D6CC6B00F2; Tue,  4 Aug 2026 15:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37EAD6B00EC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:25:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B919280265
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:37 +0000 (UTC)
X-FDA: 85064566314.25.E27C591
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1841440007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P7Gp/ksV";
	spf=pass (imf12.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785871536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVNZQR2EvvzB3NWZF+f0VH7B1f0pxu1nl3LEs0oJTSk=;
	b=yWxCrAGxYkcaTmOLoKpWTtolGpqJA0nlYnQwrvJOSbV4n2LmYP4mGXiGTI+bfIzrS2dS+O
	pYDLeVgGdUaE6P7/vBOFQJUMj4UXuvYgtG+s/3bq9HLN8PGXM1vDYvrcvMzLLFRrPCqWG3
	STIqTty85AuPJo7hM9vKY/mB8E0nFkk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785871536;
	b=vaQTsiqf61YZ6+BkhFXLi10Uj/QIX4UbiEMvqMbj0GUbkoPFytxU3Zgtyq/I05OFehF2Hq
	+8oX44KdBGmH1KbPN9LOmhdUVyh7XFNynBkNCQQhXHGtRrPGJFcSJwvVKKZy8KjGuLT6P9
	1o4Je5NIidhp3lTDm+ATfPTA6X2dOmg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P7Gp/ksV";
	spf=pass (imf12.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785871534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVNZQR2EvvzB3NWZF+f0VH7B1f0pxu1nl3LEs0oJTSk=;
	b=P7Gp/ksV7EzZq0IYi6UubLokEuLwM1e4MCaFEaPTiWAX4jonzrBfZmSdoxKiKjld3zLBp2
	v2wZ90h/NiXhTarUNaJz02CVTxpsQ8nrfRNkyNgmpLL7xXcOCgIlSofHcoXnlfEOHIoiKW
	+OziHBGop+bPmo72oYQH0LTza3TbD4g=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 04 Aug 2026 13:25:02 -0600
Subject: [PATCH v3 4/7] mm/khugepaged: fix outdated comments
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-khugepaged_pte_refactor-v3-4-0364cad642a0@linux.dev>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
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
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: cc3fnp86zppx7y1xijffqezokahrc6d9
X-Rspamd-Queue-Id: 1841440007
X-HE-Tag: 1785871535-545086
X-HE-Meta: U2FsdGVkX19nj6bwGHwC4y5IIqLsqaLvD9YZOxGvHMjSzTqfXj58o9PZsKvhX/4Lan85Ey2sPu5sb7oehbCIADxbJLYPWIKzikTXNh9RAECZrDaunoqPaubcVnrBW4FNprG9+rAJ2fw2KiF2Alz98FD/kbpj0B36vBK4Fuo3TK6IxAyw+XNvqMkMbwEMqG+ybw5zA0ZhgvK58JulGcnnTIKhRQlO7IqRgVJS8DffoOjz/g4wU5tmDsg8jaZG9d1LoqobhmYYgcFM6tVqR5zPOz7XI3TkZCc+ZFngvYUgNY56klN2GPuw1HOLv/9Y7mpUvbYklH+aFtMEg8JQE16v27bvOvzux873UmIpETivLa/otzEbpxBZoZ4uGgGS3XIQ5k0JZ1o7rmnLp94OQYgvU5f2J1nYy4dzZEbZep67k4AJfI3EQKDhfUjLS57c//jrFkEuo8B93o10o0xTUBX9pEjdgObzCTG5GUHRjGOUUltELd8rBjvVLu8XcwDPnoqLCqezQknV68JUYSTH54ywTeW7Gk5Fu7cTo3DipnDy/KMAOtVazkPA6dYQleAjv1ZN3HhGqMdSwDIsYApIrWR4LUMJu7mVHwDOrH6c72LRquwSL7VV0KfBVMeVGazciuAEFLwr1PVOB7d3kj3yiaVY9vTMV2veWIZV8qXYrjSRllybx68ESXSCt9wfa5/yDi5RX7TNQFPT3hFIymvX2nNk4J/jya3UlSgHwxd37c6aua2zny4mpRuX72oxeohl9cDatfktLHvYT6eQC0GYoOT/Ojb/eZrJsg++8qc9nC8tSCWY8h91vOY7zGz25DpRlII09/A5zp4naEzh+0kgZeOfoUsUND2SFVGEFrgMc5GW9XEGV/dgr0Vi9m8jEzslQSSOnmv2lvQ3heDUmCgxEmPli1bORYTl6M4kMmsu3IGGfUpgtTNg9EtfAv1khoeCRmf5rCkA5A3lE/9HvpBdU+q
 JhyLtiqG
 4ExDebg5D7xbl2zf4EPlCz79LZem/Z2/0dCudkvOEWqcIrPnxDqpoo5PTq95L1dg+ax+VhTmtCz5OB6uoLThT4zNtzZOl/8HCcEqE25b8Ijw0uYhg40wDncP28zC+AQQyyT4jCQqoqkpKQUEGfuV09jlRFEfyWNipF6xWVdE1fOeatJJs0ygszlP55DcDNxhjqfKFdVxrP874ro9pq8z1nybeyA==
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
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a2691587a510..dade6e68aa64 100644
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
@@ -789,8 +789,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/*
 		 * We can do it before folio_isolate_lru because the
-		 * folio can't be freed from under us. NOTE: PG_lock
-		 * is needed to serialize against split_huge_page
+		 * folio can't be freed from under us. NOTE: folio lock
+		 * is needed to serialize against split_huge_page()
 		 * when invoked from the VM.
 		 */
 		if (!folio_trylock(folio)) {
@@ -816,7 +816,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -1789,7 +1787,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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


