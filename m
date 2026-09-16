Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E28C982CD
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 22:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D18C6B0093; Wed, 16 Sep 2026 18:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AAC86B0096; Wed, 16 Sep 2026 18:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E98D6B0098; Wed, 16 Sep 2026 18:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 457C06B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:49:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 763F0A3F6D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:48:30 +0000 (UTC)
X-FDA: 85221115980.16.8C530D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id AEFC840008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:48:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tTsPbADd;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789598908;
	b=cHKwKNhIhvni9zdU+Y98V1dQcVlyUUAT2nGe9/+ljXv10R7tcycwburtm5JFMnq+ow6jBS
	djBMnBslTre/cRZQ7fqRV164voez+9/ezexGjysoNBU/7TBzRxPIhoSQI+ZomInLvG14R9
	abMFwEiBsENdV/xJPSxZrZkChSQhPoo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tTsPbADd;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789598908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr6G4HR6gssKDvZLJbrl7iMpk+X5B1Klk19IdKnrbTk=;
	b=fgCN0lbw92BGLSlTcQvYfGUPxFLEXN0EOV7OeXK7ceKpaCdo5SqFMq/K+/VtPZIVszxNHm
	k8nic9Ta4cTQ+S5+IOjgVIuBrzrtHshPbgi1CA5092lI7E/CWvWH774XOfTy8Fi0nviM0g
	UBAEOIV+gcPh47Mz4I1QjaByXt4X8nQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D743601FD;
	Wed, 16 Sep 2026 22:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A0D1F000FF;
	Wed, 16 Sep 2026 22:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789598907;
	bh=Gr6G4HR6gssKDvZLJbrl7iMpk+X5B1Klk19IdKnrbTk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tTsPbADd2vbJGs8j9CuXwRioWPBsKhyHDmwstWDn+NeOO92bnB6XSO9iawTZcN9Yq
	 Dwr13WjGddnOtgWB2ByK9MoBlzFpHZhNj7n27mTeX6B0ol0wwO5y7vd+fazinpR1cC
	 uN9ehqNKXj/xtUMDdWqHXY8fR4S0P5FQmWKylEG8=
Date: Wed, 16 Sep 2026 15:48:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>
Subject: Re: [PATCH v3 00/12] mm/collapse: separate a collapse from its
 callers
Message-Id: <20260916154826.a55591eec86b5514dab898ca@linux-foundation.org>
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AEFC840008
X-Rspam-User: 
X-Stat-Signature: 3t1siojmfm9qsy4nh5ei7ohj3kcfo7rk
X-HE-Tag: 1789598908-122423
X-HE-Meta: U2FsdGVkX1+f4/VzHihrWOvT/cpqplGA9Vk3RWuus0+E3OVAZvmfAB1n6wnFBMncqidTmvo7bAx9ENHWbBaMWiGUmlXeJc26DHg2LQm6F5UHiHCDGcjWiETguNEtLKQV/fTeoQ4c7sd5kJrJhpglCRYU29cWghbZLMwZ1n77xHJjV09bSvZOqUHQR78VN80dQ8vARQ1j4jvwPcLpP+z07XNLWWO3qQXMHJkOmDAGTLtPDTSxmhHom3tFu57AlRDpNNK9bVAZlT3QhW5qLgHbpxq5b2JpakRtek2QubBYnH3anzpn3tHS06teJ2G4Yw72uSd2hkMrLHnQn9wYy0RQxWU04+L/evXpVrIZRHRHcANjypicOB/M3/NiC75jpSAuFsqFk+t5BlHcSmflUGmSQJyvPTKblRvre8zahVlionfvJ2ad/BQ+d8Oz5vZ2KQFXE5kttNynzdRN6GEhOLBbUYJ5BgybcGi48WmT3TQvWdj8bqCgqty/hbU9fZrP489DVrTmWmRawkA1WmAIisdCwuEfA91fc7nxiISPNTxDIk13cuR/+hp6peZRHfLWVWXTlBjrQFaWU6V5QZZI/7wTMVdSZqbw66enmAiISaK1+kEnazHIgw7srEsEhsHKGE1ZZjr9BgU0hK5oRYkSorDzJ3iin7JPtV4vtkUYRpg5ds8jVFJlJ+m66iBV7uMLbwVh/49/zI/gyivsuTaREn76ct9mLfJp3Uns1hUxy/uj6ZJ8FS0h9m23G3TeUZPGZEWXCJ2v6Qk3x2HtlnqWUxfG8pvWrUKnqsoiAbtdvFfYX4r5+1kV7TK/3/amRsBEJRPPFl9qZjJo/4o597GLtPF/IIhrFW3Ak5KhOj/5yg4AKprFNI2s7BhWgJDtKKFZD4hUGo82VHXc/ZM0wQjyH+XlhY+9AQ6JKxTm7tkWBMzcww3sX2tq7Rpv0bi4ZFz800Jiu3lDny6oGDwL/STHsWu
 kUVmw23k
 v8M5Us7X/qBnzR1wJT5BGxIllouUWJXvhduDB86T6WPYZnU8dzIKNN7Y+JHngbz230wFufcJkmwsXNrap7lzJZey+TVwTJEQHXcRRz3msTRLluDc4/AS+OjtkqQLoa8yfGrohq0dzoZwMlU9ac5CL9W+k4RxgA+dMVJ4z8grhuOwGQUnRvtWbsmCNd2BqakE8liK/SfIaK//9zSkMub+PbaY/4P8+UR/AqR1AHu6JDlJp7BJrXnszjQsPEtLpmo1jawub91ySr000pFD9JgJXw7ipjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 10:31:27 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> [ This is the first of the cleanups I said I would front-load ]
> 
> There is no line between the collapse engine and the callers that ask for
> a collapse.  khugepaged.c holds both, and they reach into each other.
> 
>  - Sixteen tests through the collapse path read cc->is_khugepaged to work
>    out what they are allowed to do, when every one of those decisions was
>    made by the caller before it asked.
> 
>  - collapse_single_pmd() does both halves of a collapse behind one call and
>    drops mmap_lock somewhere in the middle.  Which of its paths dropped it
>    is not something a caller can see, so it hands back a bool and the
>    caller keeps track.
> 
>  - MADV_COLLAPSE's implementation -- the walk over the user's range, the
>    per-PMD loop, the errno translation -- sits in khugepaged.c, which is
>    the daemon's file.
> 
> So: draw the line.  State what a caller allows in a policy, split the call
> in two with the lock as the boundary, and move the syscall to madvise.c.
>

Thanks, I updated mm-unstable.

> Changes since v2
> ================
> 
>   https://lore.kernel.org/all/20260910120238.2529819-1-kirill@shutemov.name/
> 
>  - Patch 8: the file scan returns SCAN_PTE_MAPPED_HUGEPAGE as it is and
>    the run is handed what the scan returned, so it goes straight to
>    retracting the PTE table when it sees it.  The scan_retract_only flag
>    and the result round trip go, and the two copies of the file put become
>    one helper (Zi).  Patches 9-12 follow the new signature.
> 
>  - Patch 8: mthp_collapse() and collapse_huge_page() read the orders and
>    the referenced and swapped-out counts from collapse_control instead of
>    taking them as arguments (Baolin).
> 
>  - Patch 11: each interface function is documented where it is defined,
>    with the lock state on entry and exit.  The overview in collapse.h
>    stays (Zi).
> 
>  - Reviewed-by from Zi Yan on 8 and 9, and from Zi Yan and Baolin Wang
>    on 5 and 10.

Here's how v3 altered mm.git:


 mm/collapse.h   |   21 ++++----
 mm/khugepaged.c |  118 ++++++++++++++++++++++++++--------------------
 mm/madvise.c    |    6 +-
 3 files changed, 82 insertions(+), 63 deletions(-)

--- a/mm/collapse.h~b
+++ a/mm/collapse.h
@@ -95,15 +95,13 @@ struct collapse_control {
 	 *
 	 * The file side takes a reference while it still has the VMA, since a
 	 * file collapse works on the page cache and never sees one; the run is
-	 * what gives it back.  A scan that found the PMD folio already in the
-	 * cache leaves only the PTE table to retract.
+	 * what gives it back.
 	 */
 	unsigned long scan_orders;
 	int scan_referenced;
 	int scan_unmapped;
 	struct file *scan_file;
 	pgoff_t scan_pgoff;
-	bool scan_retract_only;
 };
 
 /* Which orders a VMA may collapse to, zero when it may not collapse at all */
@@ -114,18 +112,21 @@ unsigned long collapse_possible_orders(s
  * A caller states what it allows in cc->policy and then hands over one PTE
  * table's worth of a VMA at a time:
  *
- *     collapse_control_init(cc)         once, before the first table
- *     collapse_scan_pmd(vma, addr, ...) per table
- *     collapse_run_pmd(mm, addr, cc)    when a scan found work
- *     collapse_control_release(cc)      once, when done with the control
+ *     collapse_control_init(cc)              once, before the first table
+ *     collapse_scan_pmd(vma, addr, ...)      per table
+ *     collapse_run_pmd(mm, addr, result, cc) when a scan found work
+ *     collapse_control_release(cc)           once, when done with the control
  *
  * The caller holds mmap_lock for reading over the scan and passes an address
- * within @vma, aligned to the PTE table the scan is to judge.
+ * within @vma, aligned to the PTE table to scan.
  *
  * The scan returns with that lock still held.  It only reads, and almost every
  * table it is offered has nothing to collapse, so a caller walks a whole VMA
  * under the one lock it took to get there.  SCAN_SUCCEED means there is
- * something to collapse; anything else is why there is not.
+ * something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache
+ * already holds the PMD folio and only the PTE table is left to retract.
+ * Both are work for the run, which is handed what the scan returned; anything
+ * else is why there is nothing to do.
  *
  * The run is called without the lock and returns without it, taking what it
  * needs in between: what it does -- allocate, isolate, copy, flush -- is slow
@@ -144,7 +145,7 @@ enum scan_result collapse_scan_pmd(struc
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders);
 enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
-		struct collapse_control *cc);
+		enum scan_result result, struct collapse_control *cc);
 enum scan_result collapse_vma_revalidate(struct mm_struct *mm,
 		unsigned long address, bool expect_anon,
 		struct vm_area_struct **vmap, struct collapse_control *cc,
--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -996,11 +996,11 @@ static int collapse_find_target_node(str
 #endif
 
 /*
- * If mmap_lock temporarily dropped, revalidate vma
- * after taking the mmap_lock again.
- * Returns enum scan_result value.
+ * Find the VMA at @address again once mmap_lock has been given up and taken
+ * back, and check it still allows a collapse of @order there.  The VMA has to
+ * span the whole PMD whatever @order is; with @expect_anon it also has to be
+ * anonymous and have an anon_vma.  *@vmap is the VMA found, if any.
  */
-
 enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
 		bool expect_anon, struct vm_area_struct **vmap,
 		struct collapse_control *cc, unsigned int order)
@@ -1222,8 +1222,8 @@ static enum scan_result alloc_charge_fol
  * while allocating a THP, as that could trigger direct reclaim/compaction.
  * Note that the VMA must be rechecked after grabbing the mmap_lock again.
  */
-static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
-		int referenced, int unmapped, struct collapse_control *cc,
+static enum scan_result collapse_huge_page(struct mm_struct *mm,
+		unsigned long start_addr, struct collapse_control *cc,
 		unsigned int order)
 {
 	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
@@ -1262,14 +1262,14 @@ static enum scan_result collapse_huge_pa
 		goto out_nolock;
 	}
 
-	if (unmapped) {
+	if (cc->scan_unmapped) {
 		/*
 		 * __collapse_huge_page_swapin() will return with mmap_lock
 		 * released when it fails. So we jump out_nolock directly in
 		 * that case.  Continuing to collapse causes inconsistency.
 		 */
 		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
-						     referenced, order);
+						     cc->scan_referenced, order);
 		if (result != SCAN_SUCCEED)
 			goto out_nolock;
 	}
@@ -1433,9 +1433,8 @@ static unsigned int max_order_from_offse
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
  */
-static enum scan_result mthp_collapse(struct mm_struct *mm,
-		unsigned long address, int referenced, int unmapped,
-		struct collapse_control *cc, unsigned long enabled_orders)
+static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long address,
+		struct collapse_control *cc)
 {
 	unsigned int nr_eligible_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
@@ -1448,7 +1447,7 @@ static enum scan_result mthp_collapse(st
 	while (offset < HPAGE_PMD_NR) {
 		nr_ptes = 1UL << order;
 
-		if (!test_bit(order, &enabled_orders))
+		if (!test_bit(order, &cc->scan_orders))
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
@@ -1456,19 +1455,18 @@ static enum scan_result mthp_collapse(st
 						      offset + nr_ptes);
 
 		/*
-		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in cc->eligible_ptes. Account them for the PMD-order
-		 * candidate.
+		 * Swap PTEs accepted during the scan are counted in
+		 * cc->scan_unmapped, not in cc->eligible_ptes. Account them for
+		 * the PMD-order candidate.
 		 */
 		if (is_pmd_order(order))
-			nr_eligible_ptes += unmapped;
+			nr_eligible_ptes += cc->scan_unmapped;
 
 		if (nr_eligible_ptes >= nr_ptes - max_ptes_none) {
 			enum scan_result ret;
 
 			collapse_address = address + offset * PAGE_SIZE;
-			ret = collapse_huge_page(mm, collapse_address, referenced,
-						 unmapped, cc, order);
+			ret = collapse_huge_page(mm, collapse_address, cc, order);
 
 			switch (ret) {
 			/* Cases where we continue to next collapse candidate */
@@ -1510,7 +1508,7 @@ next_order:
 		 * we must always move to the next offset.
 		 */
 		if (order > COLLAPSE_MIN_MTHP_ORDER &&
-		    (enabled_orders & GENMASK(order - 1, 0))) {
+		    (cc->scan_orders & GENMASK(order - 1, 0))) {
 			order--;
 			continue;
 		}
@@ -2721,21 +2719,45 @@ static enum scan_result collapse_scan_fi
 	return result;
 }
 
+/* Set up a control before its first scan; cc->policy is the caller's to fill */
 void collapse_control_init(struct collapse_control *cc)
 {
 	cc->progress = 0;
 	cc->scan_file = NULL;
 }
 
-void collapse_control_release(struct collapse_control *cc)
+/* A scan that took a file reference should have been run */
+static void collapse_put_scan_file(struct collapse_control *cc)
 {
-	/* A scan that took a file reference should have been run */
 	if (WARN_ON_ONCE(cc->scan_file)) {
 		fput(cc->scan_file);
 		cc->scan_file = NULL;
 	}
 }
 
+/*
+ * Done with a control.  A scan that found something has to have been run by
+ * then: the file side takes a reference on the file while it still has the
+ * VMA to take it from, and the run is what gives it back.
+ */
+void collapse_control_release(struct collapse_control *cc)
+{
+	collapse_put_scan_file(cc);
+}
+
+/*
+ * Scan the PTE table of @vma at @addr for a collapse candidate.  @addr is
+ * aligned to the table; @orders is what the caller allows there.
+ *
+ * Called with mmap_lock held for reading and returns with it still held.  It
+ * only reads, and almost every table it is offered has nothing to collapse,
+ * so a caller walks a whole VMA under the one lock it took to get there.
+ *
+ * SCAN_SUCCEED means there is something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE
+ * means the page cache already holds the PMD folio and only the PTE table is
+ * left to retract.  Both are work for collapse_run_pmd(), which is handed
+ * what the scan returned; anything else is why there is nothing to do.
+ */
 enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders)
@@ -2745,31 +2767,19 @@ enum scan_result collapse_scan_pmd(struc
 
 	mmap_assert_locked(vma->vm_mm);
 	/* Whatever the last scan found has to have been run by now */
-	if (WARN_ON_ONCE(cc->scan_file)) {
-		fput(cc->scan_file);
-		cc->scan_file = NULL;
-	}
+	collapse_put_scan_file(cc);
 
 	if (vma_is_anonymous(vma))
 		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
 	pgoff = linear_page_index(vma, addr);
 	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
-	switch (result) {
-	case SCAN_SUCCEED:
-		cc->scan_retract_only = false;
-		break;
-	case SCAN_PTE_MAPPED_HUGEPAGE:
-		/*
-		 * The page cache already holds the PMD folio; what is left is
-		 * to retract the PTE table, which is the run's job.
-		 */
-		cc->scan_retract_only = true;
-		result = SCAN_SUCCEED;
-		break;
-	default:
+	/*
+	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
+	 * the PMD folio, and retracting the PTE table is the run's job.
+	 */
+	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
 		return result;
-	}
 
 	/*
 	 * A file collapse works on the page cache and never sees a VMA, so take
@@ -2780,25 +2790,32 @@ enum scan_result collapse_scan_pmd(struc
 	return result;
 }
 
+/*
+ * Collapse the table a scan found work in.  @result is what the scan
+ * returned.
+ *
+ * Called without mmap_lock and returns without it, taking what it needs in
+ * between: what it does -- allocate, isolate, copy, flush -- is slow enough
+ * that a writer would wait behind it.  The caller gives the lock up first,
+ * and with it the VMA and anything derived under it.  The run revalidates for
+ * itself rather than trusting what the scan saw.
+ */
 enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
-		struct collapse_control *cc)
+		enum scan_result result, struct collapse_control *cc)
 {
 	struct file *file = cc->scan_file;
 	bool triggered_wb = false;
-	enum scan_result result;
 	pgoff_t pgoff;
 
 	if (!file)
-		return mthp_collapse(mm, addr, cc->scan_referenced,
-				     cc->scan_unmapped, cc, cc->scan_orders);
+		return mthp_collapse(mm, addr, cc);
 
 	cc->scan_file = NULL;
 	pgoff = cc->scan_pgoff;
 
-	if (cc->scan_retract_only) {
-		result = SCAN_PTE_MAPPED_HUGEPAGE;
+	/* The scan found the PMD folio in place: nothing to collapse */
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
 		goto retract;
-	}
 retry:
 	result = collapse_file(mm, addr, file, pgoff, cc);
 
@@ -2912,8 +2929,9 @@ static void collapse_scan_mm_slot(unsign
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 
 			*result = collapse_scan_pmd(vma, addr, cc, orders);
-			/* Nothing to collapse here, and the lock is still ours */
-			if (*result != SCAN_SUCCEED) {
+			/* Nothing to do here, and the lock is still ours */
+			if (*result != SCAN_SUCCEED &&
+			    *result != SCAN_PTE_MAPPED_HUGEPAGE) {
 				if (cc->progress >= progress_max)
 					goto breakouterloop;
 				continue;
@@ -2926,7 +2944,7 @@ static void collapse_scan_mm_slot(unsign
 			 * whatever the collapse leaves them.
 			 */
 			mmap_read_unlock(mm);
-			*result = collapse_run_pmd(mm, addr, cc);
+			*result = collapse_run_pmd(mm, addr, *result, cc);
 			if (*result == SCAN_SUCCEED)
 				khugepaged_pages_collapsed++;
 			goto breakouterloop_mmap_lock;
@@ -2984,7 +3002,7 @@ static void khugepaged_do_scan(struct co
 	lru_add_drain_all();
 
 	collapse_control_init(cc);
-	/* One policy for the whole pass, so every table is judged the same */
+	/* One policy for the whole pass, so every table is treated the same */
 	collapse_policy_khugepaged(&cc->policy);
 
 	while (true) {
--- a/mm/madvise.c~b
+++ a/mm/madvise.c
@@ -1014,8 +1014,8 @@ static int madvise_collapse(struct madvi
 		}
 
 		result = collapse_scan_pmd(vma, addr, cc, orders);
-		/* Nothing to collapse here, and the lock is still ours */
-		if (result != SCAN_SUCCEED)
+		/* Nothing to do here, and the lock is still ours */
+		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
 			goto tally;
 
 		/* The collapse takes its own locks, so give this up */
@@ -1023,7 +1023,7 @@ static int madvise_collapse(struct madvi
 		mark_mmap_lock_dropped(madv_behavior);
 		vma = NULL;
 
-		result = collapse_run_pmd(mm, addr, cc);
+		result = collapse_run_pmd(mm, addr, result, cc);
 tally:
 		switch (result) {
 		case SCAN_SUCCEED:
_


