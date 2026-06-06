Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD3ACD6E7D
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 00:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3D96B008C; Fri,  5 Jun 2026 20:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7848B6B0092; Fri,  5 Jun 2026 20:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6732C6B0093; Fri,  5 Jun 2026 20:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 552C86B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:38:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06F7A8D2CE
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:38:52 +0000 (UTC)
X-FDA: 84847627704.04.C8EF729
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00D98C0003
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:38:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="N3W/lCja";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780706330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2C3zfl86Y/ZbweEP0YrvTlodlE4cFwzCztBvaJcfGZY=;
	b=LrSTooNNqpw7fUFvFpI4/rcZQ4+gmM0YxNBP/LCKMEOuUsRJQOVxoz2cuMDBXV+s6lH6fu
	6gq3BjWJPAW/MAh8/109fCMheMpEn1MWmohYE/7+ih9/A+Ik1xu4nLMj45ruins0FCiuYF
	VzLEcKViE9JVC/6wZCxtxVyLrwGCx2U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="N3W/lCja";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780706330;
	b=VeEMLsl5cYXm2W0q+afzwD4xCio+8EeC/axvtuL1sVDvkiKQPlmyZ8xzvcm+oN4+tfc9kE
	rzfypzD9LVGZGV0e21mEKCPnz6mDU7cL0wvPBJBBbIeBeidIDSrjeu3/NLb2J/i+taybCE
	OFZklEKmSzte2JsfcVrLplXKj6YAMsg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8A7443CC3;
	Sat,  6 Jun 2026 00:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A4F1F00893;
	Sat,  6 Jun 2026 00:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780706328;
	bh=2C3zfl86Y/ZbweEP0YrvTlodlE4cFwzCztBvaJcfGZY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=N3W/lCja3vMQi7/1tb7yiyQ6mgDphyKTWoJhGjjsXON7/+3BbP2oiq3zf8TjVri1U
	 ri3MT7w470ebrbxtbFQR7eRLIc6r3z/HqJvW3xtAOFMvBsq+nWoEF7BM2ejKQLORqm
	 1jieFilxQ/hgHrxZhSx+/muBR8D8ORG8LAFRLTKc=
Date: Fri, 5 Jun 2026 17:38:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 00/14] khugepaged: add mTHP collapse
 support
Message-Id: <20260605173846.e403cd63c59c385d60268132@linux-foundation.org>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 00D98C0003
X-Stat-Signature: 3s1oxh3dun7mxfkwfpgfs8u19cx4sfu7
X-Rspam-User: 
X-HE-Tag: 1780706329-54409
X-HE-Meta: U2FsdGVkX1+P6LM7WT2C8ccT7KLtOWNMT5GY15KV5WnhnOnhZQ/D8i9Zdn1zioRwQvddJ5FEyP9fkPxauFqAo7DnQSXYwH8cyfpXcYD+49cRM1rstFtxfAWFErR1eEvn1XBu9RRt4ASwCssjGtzB6jvYk3gNCn2SNIOD3PuY3mmD/i22QUgmER+dwUdH1C2zijtbdTPoQ8CiNOQ4PyEGtdHFrkoCjFaxHqXbvU1l+vXlLkfCaV0P8G2SbItDVEu2jz37elhs98E+onYDal8r/uR5T/HrRoIRSxIhveCwn1kjqB1+kyNpsPyzMCLhmkswLf5INAcCN8FpuqUGsIVfSd460g7s8xD8NrYl1thrmxKVuyRZz0GX6GpsYztYG4WofFYhsvV8KQqPYva3FSk1+0pu3822cwji9EEDfFFFWrSK1OftkrNDzd6K8PssAz36MqKwVvzgrfP0ggPcP1lHNlbwNtx0yyRYRsAxunnwGgldYnzqrwVTVL/smSKgHoRTq8G8b3aPqYMCdX8CNwrSnkeJ2BbHOEWyzg5LdCWlqb19pTpikMnDbiIQzONjRSoUjalI9ifRY0N+rrsQ9khc2bhVcZMsleCjCjXqHNgj1M3l/4fabPKUNb4YFjjJ5o2wKlT2iOJmDM46euJnQNGldKECWgCn7dt/ALlFCaQyhoXYAfQ/YOJULj4wh3vQXmYR+jcTUyQCf0JT+40ZthUL19vPQbdV+PYv8LHgV/QfMjQ0hQIfq5JP4mPK4CHaJbwJMa0lfZTKXdDNKy04dJJsZkUx6O4eDUo34d3b8/s0yssvHe2GD32Y9kuLKVVVvTH/rPeBRhtf7uNxnHKqtCc3Fo46KDOVJZVscyFO98lZMoyB0yWaUUseH+b00q8EPKTWuL3yfcbvd4l5QbTBgzSA4FZiSOeBGdkKm3XmlfDiudnNuBQHyMAqGuyS9tX04fmMQE/RcJleegKTr77UoHQ
 Z10jz9ol
 nSq91EODEdV4RFqSQQlvrJJRhKaqd3o+6zk5BUj/ObyQ+jkUjevudQTnZF9JUXiaXcTeYv4tGkqrzMSkwjA86YTEx0zFHcLXgrSIf0+jdvN5mF11txjKO+j+YUTl4WbMoxsxNbJo3b4FwhX4+VLd7YX3FjRX0BUR0sApy/F7H+MOG74GTit91MM4l9POzam6eUx2HdEy/3Qs2ZCkxM7SNM5ZEy4lz0JbTQuqwNZ26RPERVpBv0CuraFR8uTumQj1zrIDDD3dIGC0q0iVFoRwHHhItNhNSQS+dipiSb4QMT7SHfpY7U4RDCxUKYEXR0vjNvmzLssMj1JfLti3XnexV78Y9TXzBfLFZZG8b+FGscTVrEQ7Na22vUsMfVp3hohI39DyWX+b6wXjYktUvUOS9fcnGGNOYHYULUhXu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  5 Jun 2026 10:14:07 -0600 Nico Pache <npache@redhat.com> wrote:

> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.

Thanks, I updated mm.git's mm-unstable branch to this version.

Sashiko said things:
	https://sashiko.dev/#/patchset/20260605161422.213817-1-npache@redhat.com

> V19 Changes:
> - Rebased onto mm-unstable (base: 9282f9bdbdf2, where v18 was based)
> - Added RBs/Acks
> - [patch 04] Make max_ptes_none const; guard pr_warn_once with
>   check so we only warn for non-zero intermediate values and use a single
>   "return 0" path (David)
> - [patch 06] Add comment explaining the mmu_notifier_range covers only
>   the modified PTE range (David); change BUG_ON to VM_WARN_ON_ONCE
>   (David); fix update_mmu_cache_range() arch safety issue: reinstall
>   PMD via pmd_populate() before calling map_anon_folio_pte_nopf() and
>   hold the PTE lock nested inside pmd_ptl during the operation (David,
>   Lance); drop the now-unnecessary smp_wmb() as __folio_mark_uptodate()
>   provides the required ordering (David, Lance)
> - [patch 07] Clarify commit message: "mTHP to a folio of equal or
>   smaller size, possibly resulting in a partially mapped source folio"
>   (David)
> - [patch 08] Add Lorenzo's RB and David's Ack; move TODO comment about
>   shared pages to patch 4 (David)
> - [patch 10] Rename collapse_allowable_orders() to
>   collapse_possible_orders() and add collapse_possible() boolean wrapper
>   for callers that only need a yes/no answer (David)
> - [patch 11] Major rework: replace the DFS stack-based algorithm with a
>   simpler linear forward-walking approach using offset + order (David);
>   remove mthp_range struct, mthp_bitmap_stack[], stack push/pop
>   functions, and MTHP_STACK_SIZE; add max_order_from_offset() helper
>   using __ffs(offset) for natural alignment; rename mthp_bitmap to
>   mthp_present_ptes (David); remove temporary mthp_bitmap_mask and use
>   bitmap_weight_from() directly (David); fix result propagation so
>   mthp_collapse() returns enum scan_result and properly propagates
>   SCAN_ALLOC_HUGE_PAGE_FAIL and SCAN_PTE_MAPPED_HUGEPAGE to callers
>   (Lance); fold in v18 fixup for potential use-after-free of vma in
>   mthp_collapse() by passing NULL to collapse_max_ptes_none()
> - [patch 12] Rework to match new linear algorithm; expand the set of
>   failures that allow retrying at a lower order
> - [patch 14] Re-add note about file/shmem still only collapsing to
>   PMD-sized THPs (David)

Here's how v19 altered mm.git:


 mm/khugepaged.c |  222 ++++++++++++++++++++--------------------------
 1 file changed, 100 insertions(+), 122 deletions(-)

--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -100,28 +100,6 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_s
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
 #define KHUGEPAGED_MIN_MTHP_ORDER	2
-/*
- * mthp_collapse() does an iterative DFS over a binary tree, from
- * HPAGE_PMD_ORDER down to KHUGEPAGED_MIN_MTHP_ORDER. The max stack
- * size needed for a DFS on a binary tree is height + 1, where
- * height = HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER.
- *
- * ilog2 is used in place of HPAGE_PMD_ORDER because some architectures
- * (e.g. ppc64le) do not define HPAGE_PMD_ORDER until after build time.
- */
-#define MTHP_STACK_SIZE	(ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER + 1)
-
-/*
- * Defines a range of PTE entries in a PTE page table which are being
- * considered for mTHP collapse.
- *
- * @offset: the offset of the first PTE entry in a PMD range.
- * @order: the order of the PTE entries being considered for collapse.
- */
-struct mthp_range {
-	u16 offset;
-	u8 order;
-};
 
 struct collapse_control {
 	bool is_khugepaged;
@@ -136,10 +114,7 @@ struct collapse_control {
 	nodemask_t alloc_nmask;
 
 	/* Each bit represents a single occupied (!none/zero) page. */
-	DECLARE_BITMAP(mthp_bitmap, MAX_PTRS_PER_PTE);
-	/* A mask of the current range being considered for mTHP collapse. */
-	DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
-	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
+	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
 };
 
 /**
@@ -584,8 +559,11 @@ void __khugepaged_enter(struct mm_struct
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-/* Check what orders are allowed based on the vma and collapse type */
-static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
+/*
+ * Check what orders are possible based on the vma and collapse type.
+ * This is used to determine if mTHP collapse is a viable option.
+ */
+static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
 	unsigned long orders;
@@ -599,11 +577,17 @@ static unsigned long collapse_allowable_
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
+static bool collapse_possible(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags)
+{
+	return collapse_possible_orders(vma, vm_flags, tva_flags);
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled()
-	    && collapse_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED))
+	    && collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
 		__khugepaged_enter(vma->vm_mm);
 }
 
@@ -844,7 +828,7 @@ static void __collapse_huge_page_copy_su
 		struct list_head *compound_pagelist)
 {
 	const unsigned long nr_pages = 1UL << order;
-	unsigned long end = address + (PAGE_SIZE << order);
+	unsigned long end = address + (PAGE_SIZE * nr_pages);
 	struct folio *src, *tmp;
 	pte_t pteval;
 	pte_t *_pte;
@@ -1074,7 +1058,13 @@ static enum scan_result hugepage_vma_rev
 	if (!vma)
 		return SCAN_VMA_NULL;
 
-	/* Always check the PMD order to ensure its not shared by another VMA */
+	/*
+	 * We cannot collapse VMA regions that do not span the full PMD. This is
+	 * due to the potential of the PMD being shared by another VMA leaving
+	 * us vulnerable to a race condition. Always check the PMD order here to
+	 * ensure its not shared by another VMA. We'd need to lock all VMAs in
+	 * the PMD range to support this.
+	 */
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
 	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, BIT(order)))
@@ -1390,7 +1380,7 @@ static enum scan_result collapse_huge_pa
 
 	if (unlikely(result != SCAN_SUCCEED)) {
 		spin_lock(pmd_ptl);
-		WARN_ON_ONCE(!pmd_none(*pmd));
+		VM_WARN_ON_ONCE(!pmd_none(*pmd));
 		/*
 		 * We can only use set_pmd_at when establishing
 		 * hugepmds and never for establishing regular pmds that
@@ -1433,13 +1423,18 @@ static enum scan_result collapse_huge_pa
 		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
 	} else {
 		/*
-		 * set_ptes is called in map_anon_folio_pte_nopf with the
-		 * pmd_ptl lock still held; this is safe as the PMD is expected
-		 * to be none. The pmd entry is then repopulated below.
+		 * Some architectures (e.g. MIPS) walk the live page table in
+		 * their implementation. update_mmu_cache_range() must be called
+		 * with a valid page table hierarchy and the PTE lock held.
+		 * Acquire it nested inside pmd_ptl when they are distinct locks.
 		 */
-		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
-		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
+		if (pte_ptl != pmd_ptl)
+			spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
+		map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
+					  /*uffd_wp=*/ false);
+		if (pte_ptl != pmd_ptl)
+			spin_unlock(pte_ptl);
 	}
 	spin_unlock(pmd_ptl);
 
@@ -1459,58 +1454,23 @@ out_nolock:
 	return result;
 }
 
-static void collapse_mthp_stack_push(struct collapse_control *cc, int *stack_size,
-				     u16 offset, u8 order)
-{
-	const int size = *stack_size;
-	struct mthp_range *stack = &cc->mthp_bitmap_stack[size];
-
-	VM_WARN_ON_ONCE(size >= MTHP_STACK_SIZE);
-	stack->order = order;
-	stack->offset = offset;
-	(*stack_size)++;
-}
-
-static struct mthp_range collapse_mthp_stack_pop(struct collapse_control *cc,
-						 int *stack_size)
+/* Return the highest naturally aligned order that fits at @offset within a PMD. */
+static unsigned int max_order_from_offset(unsigned int offset)
 {
-	const int size = *stack_size;
+	if (offset == 0)
+		return HPAGE_PMD_ORDER;
 
-	VM_WARN_ON_ONCE(size <= 0);
-	(*stack_size)--;
-	return cc->mthp_bitmap_stack[size - 1];
-}
-
-static unsigned int collapse_mthp_count_present(struct collapse_control *cc,
-						u16 offset, unsigned int nr_ptes)
-{
-	bitmap_zero(cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
-	bitmap_set(cc->mthp_bitmap_mask, offset, nr_ptes);
-	return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
+	return min_t(unsigned int, __ffs(offset), HPAGE_PMD_ORDER);
 }
 
 /*
  * mthp_collapse() consumes the bitmap that is generated during
  * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
  *
- * Each bit in cc->mthp_bitmap represents a single occupied (!none/zero) page.
- * A stack structure cc->mthp_bitmap_stack is used to check different regions
- * of the bitmap for collapse eligibility. The stack maintains a pair of
- * variables (offset, order), indicating the number of PTEs from the start of
- * the PMD, and the order of the potential collapse candidate respectively. We
- * start at the PMD order and check if it is eligible for collapse; if not, we
- * add two entries to the stack at a lower order to represent the left and right
- * halves of the PTE page table we are examining.
- *
- *                         offset       mid_offset
- *                         |         |
- *                         |         |
- *                         v         v
- *      --------------------------------------
- *      |          cc->mthp_bitmap            |
- *      --------------------------------------
- *                         <-------><------->
- *                          order-1  order-1
+ * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
+ * page. We start at the PMD order and check if it is eligible for collapse;
+ * if not, we check the left and right halves of the PTE page table we are
+ * examining at a lower order.
  *
  * For each of these, we determine how many PTE entries are occupied in the
  * range of PTE entries we propose to collapse, then we compare this to a
@@ -1520,35 +1480,30 @@ static unsigned int collapse_mthp_count_
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
  */
-static int mthp_collapse(struct mm_struct *mm, unsigned long address,
-		int referenced, int unmapped, struct collapse_control *cc,
-		unsigned long enabled_orders)
+static enum scan_result mthp_collapse(struct mm_struct *mm,
+		unsigned long address, int referenced, int unmapped,
+		struct collapse_control *cc, unsigned long enabled_orders)
 {
 	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
-	int collapsed = 0, stack_size = 0;
+	enum scan_result last_result = SCAN_FAIL;
+	int collapsed = 0;
+	bool alloc_failed = false;
 	unsigned long collapse_address;
-	struct mthp_range range;
-	u16 offset;
-	u8 order;
-
-	collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
-
-	while (stack_size) {
-		range = collapse_mthp_stack_pop(cc, &stack_size);
-		order = range.order;
-		offset = range.offset;
+	unsigned int offset = 0;
+	unsigned int order = HPAGE_PMD_ORDER;
+
+	while (offset < HPAGE_PMD_NR) {
 		nr_ptes = 1UL << order;
 
 		if (!test_bit(order, &enabled_orders))
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
-
-		nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
-							       nr_ptes);
+		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
+						      offset + nr_ptes);
 
 		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
-			int ret;
+			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
 			ret = collapse_huge_page(mm, collapse_address, referenced,
@@ -1560,8 +1515,11 @@ static int mthp_collapse(struct mm_struc
 				collapsed += nr_ptes;
 				fallthrough;
 			case SCAN_PTE_MAPPED_HUGEPAGE:
-				continue;
+				goto next_offset;
 			/* Cases where lower orders might still succeed */
+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+				alloc_failed = true;
+				fallthrough;
 			case SCAN_LACK_REFERENCED_PAGE:
 			case SCAN_EXCEED_NONE_PTE:
 			case SCAN_EXCEED_SWAP_PTE:
@@ -1572,27 +1530,48 @@ static int mthp_collapse(struct mm_struc
 			case SCAN_DEL_PAGE_LRU:
 			case SCAN_PTE_NON_PRESENT:
 			case SCAN_PTE_UFFD_WP:
-			case SCAN_ALLOC_HUGE_PAGE_FAIL:
 			case SCAN_PAGE_LAZYFREE:
+				last_result = ret;
 				goto next_order;
 			/* Cases where no further collapse is possible */
+			case SCAN_PMD_MAPPED:
+				fallthrough;
 			default:
-				return collapsed;
+				last_result = ret;
+				goto done;
 			}
 		}
 
 next_order:
-		if ((BIT(order) - 1) & enabled_orders) {
-			const u8 next_order = order - 1;
-			const u16 mid_offset = offset + (nr_ptes / 2);
-
-			collapse_mthp_stack_push(cc, &stack_size, mid_offset,
-						 next_order);
-			collapse_mthp_stack_push(cc, &stack_size, offset,
-						 next_order);
-		}
-	}
-	return collapsed;
+		/*
+		 * Continue with the next smaller order if there is still
+		 * any smaller order enabled. When at the smallest order
+		 * we must always move to the next offset.
+		 */
+		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
+			(enabled_orders & GENMASK(order - 1, 0))) {
+			order--;
+			continue;
+		}
+next_offset:
+		/*
+		 * Advance past the region we just processed and determine the
+		 * highest order we can attempt next. Since huge pages must be
+		 * naturally aligned, the max order we can attempt next is
+		 * limited by the alignment of the new offset.
+		 * E.g. if we collapsed a order-2 mTHP at offset 0, offset
+		 * becomes 4 and __ffs(4) == 2, so the next attempt starts at
+		 * order 2.
+		 */
+		offset += nr_ptes;
+		order = max_order_from_offset(offset);
+	}
+done:
+	if (collapsed)
+		return SCAN_SUCCEED;
+	if (alloc_failed)
+		return SCAN_ALLOC_HUGE_PAGE_FAIL;
+	return last_result;
 }
 
 static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
@@ -1606,7 +1585,7 @@ static enum scan_result collapse_scan_pm
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
-	int none_or_zero = 0, shared = 0, nr_collapsed = 0, referenced = 0;
+	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
@@ -1623,11 +1602,11 @@ static enum scan_result collapse_scan_pm
 		goto out;
 	}
 
-	bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
+	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 
-	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, tva_flags);
+	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
@@ -1730,7 +1709,7 @@ static enum scan_result collapse_scan_pm
 		}
 
 		/* Set bit for occupied pages */
-		__set_bit(i, cc->mthp_bitmap);
+		__set_bit(i, cc->mthp_present_ptes);
 		/*
 		 * Record which node the original page is from and save this
 		 * information to cc->node_load[].
@@ -1789,11 +1768,10 @@ out_unmap:
 	if (result == SCAN_SUCCEED) {
 		/* collapse_huge_page expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
-		nr_collapsed = mthp_collapse(mm, start_addr, referenced,
-					     unmapped, cc, enabled_orders);
+		result = mthp_collapse(mm, start_addr, referenced,
+				       unmapped, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
-		result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
@@ -2892,7 +2870,7 @@ static void collapse_scan_mm_slot(unsign
 			cc->progress++;
 			break;
 		}
-		if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3202,7 +3180,7 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	cc = kmalloc_obj(*cc);
_


