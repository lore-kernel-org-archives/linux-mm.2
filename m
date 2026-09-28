Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F334FCA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 21:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D451C6B0088; Mon, 28 Sep 2026 17:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5816B008A; Mon, 28 Sep 2026 17:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5256B008C; Mon, 28 Sep 2026 17:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE5B6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:59:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 185EB1C2758
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:59:30 +0000 (UTC)
X-FDA: 85264538100.21.6DA38D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 30CFC120004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:59:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XRFFKlye;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790632768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bptGM1fKGnl+cc8ny1xQF3hb7TIUTlchLwZhZ8N3zQ=;
	b=iO1JtwRoiY6UvMljyP0bnVsWAu8B+sAfou5qaI93RvXizZxtFoisyz2azObUqtooxYqlmr
	wKrYc55JinsZq687YMiVCRC/ptFl9wcve75YD2xcPofqr8YqLTZn6mcXas0IN0EisuSeSV
	EbqxkVBVgBJ6RD6Mmi44xc6pgSwSts4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XRFFKlye;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790632768;
	b=aWiVLcqgwwyOPCzeXeGExqxMi1BmUYKR6vEGA5B8JhMg1ePKcyycMSWwhij3Sq+36vHqQ2
	YfEP6aPASIfSxrqMCblji9E8FMk8kjCVrxFlYUG86N1VI3kvmI0tkUYuKrKyi554Mp1aPO
	FYqJzopkNfWusizqQ09wQk9BsbaMh0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A20641B03;
	Mon, 28 Sep 2026 21:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFB21F000FF;
	Mon, 28 Sep 2026 21:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790632766;
	bh=4bptGM1fKGnl+cc8ny1xQF3hb7TIUTlchLwZhZ8N3zQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XRFFKlyepqyheX2Km7Q+XxEuES6Qp4HIv0rBVXX5feEGi4yb85+o2D6XgqDNIDXff
	 0f6TvaFT7BZPgJYpoxnuBKac0FOkV6FaoGm5mxwj6wamzp11006xT6i3xyAXF/BtrU
	 E3ZXU3P3d1Sp47V21HX2UOu2F+IgW3wf/nVIYnQ8=
Date: Mon, 28 Sep 2026 14:59:25 -0700
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
Subject: Re: [PATCH v4 00/13] mm/collapse: separate a collapse from its
 callers
Message-Id: <20260928145925.c2cdfd752099f137422e6ac2@linux-foundation.org>
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 30CFC120004
X-Stat-Signature: tzu5xets9pung5mo6ntjyu5opt9pzatf
X-HE-Tag: 1790632768-156340
X-HE-Meta: U2FsdGVkX18NB+mxM6aimIy0Nt10/YXldKUtwf9dtpG5ZJGn767lt3RcS6OST1ZGFqJB0k/7B8Qvka8mMHd+5NpRZR6sTOuXoqXTeTj0vMlL3FqaOot1xCmGb1ssMfkhSUOoz8W1TNVDOoZvoCHEGfWpDLZQFlJBacXXtmPzCjbREmhEw2y60q2t7X4uJxHuH5iHI2Kw29BMKYvvbzmFk4TJ9q/GlAHStygq2hpo53cSx03QsBUPholnd7RRHqkZM9s4nfMSjzCe/7Bnem1TI2RWBkV5ZN2gnc+gSuLRZVmlKDE4SyO1bJ4MHssFeN3jEF+r66846PwR2jXfmWr/94KH2lLj4IVksQOSP0YQV0csXRPcGnjO/p8V0j1eAkRPfm4ntvCa51+IoZTi1iMP8wVULrSnDWKeADW2+UC7p/EYD/Zgu5T+GCBlrllH3GdXPmaGAvpGpoFTi0JVVjrO3xntJpHjLpoXruE7nXlkcm3SePUjxAcDK5s6aOrl5Iog6KRsJCMlcXpQBgTYJJw+UEaP603mGmFQ0fC6tRfDfpF6Axf2G+pO9ex+U+tB9/Lz5uHNjXCddeU+0NkbORp2bSmxW4akeTRwXXv18Rq/FS7/6Eikqn6Qpn/OFESNhOJ1LYcbwuQg991Uj8FZA7T8X0gQgJmyreMj4EiAZJLILP85+lcVRJv00BAo1cJ70od6+wsFyUop0dDMU57m1XTbvQgi+Qe4DhqJaj6RYuFRt8tn9kmDlQno0KPq+gI69v88znGOOvVT01bVi63K2A+p6xacQkuHly/9pmbhTqq0slNGx0CbRublc1OYvCHSLEGF1iluCQTGo7Nn626llqW5DzWGnTRh/Qee9jSbSLeVhZCwnjzHK1YjrM66hytzov/C41rxleo/uNffhWk6dcgafBUb6q+bAKEF+syi8W8WeNKAhHnU6zUGM8510KWORltpPitlT/ZmB1F7t0OZ9uV
 CzQ5jWs0
 4//drsdpwB770qowbluUhOeFj3s91Z8b0IOcVEyPcKi6VKZPLI2oq+L/U3n05iSO6pqamh9hyBMGIyqaeiHFx9sVCZWU+wry0pov/xji0MmgMxC+KIGOq5IwaWGhYsSj8Zl08emGk+n3XJXv9v4+pZR7vud2FqTbaXpJANG8uvQL0nK0AdsrLNp3rViMB4ZSWLqwOJdBE+0PJKmP1cr6WkHgNYGaTJvLvz1wB/ZnODTaWgKnE4y7mPKNfcZ7mzTq68CUmzvjEWKTIrf7oXauRQWat2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 11:06:14 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

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
> What the engine offers is then three calls, with the lock state written
> down against each, and a policy the caller fills for itself:
> 
>     collapse_control_init(cc)         once, before the first table
>     collapse_policy_*(&cc->policy)    what this caller allows
>     collapse_scan_pmd(vma, addr, ...) per table, under mmap_lock
>     collapse_run_pmd(mm, addr, ...)   when a scan found work, no mmap_lock
> 
> The engine stays in khugepaged.c for now; what changes is that it has an
> interface, and that neither half has to ask about the other.  madvise.c
> gains the operation it should have had all along.

Thanks, I updated mm-unstable to this version.

I added a note in order to track David's v3 comment at
https://lore.kernel.org/abd32250-6ba1-443b-b8e4-7772bcdd325a@kernel.org

> Changes since v3
> ================
> 
>   https://lore.kernel.org/all/20260916093145.4022188-1-kirill@shutemov.name/
> 
>  - Patch 5: the PTE limits come as two sets, struct collapse_limits for a
>    PMD-sized window and one for anything smaller, and the strict_sub_pmd
>    flag goes.  The warning for a max_ptes_none between 0 and the maximum
>    moves to where khugepaged fills its policy.  The fields only one side
>    reads are prefixed anon_ or file_.  collapse_policy_forced() is
>    collapse_policy_madvise() (David).
> 
>  - Patch 8 is new: collapse_file() is called from collapse_single_pmd()
>    rather than from inside collapse_scan_file(), so the file scan stops at
>    the decision before the scan/run split.  The writeback retry and the
>    tracepoint change move into it, so patch 9 is only the split (David).
> 
>  - Patch 9: no collapse_control_release().  It had nothing to release in
>    this series; it comes back with the engine, where init allocates.  The
>    check that the last scan was run stays at the top of collapse_scan_pmd()
>    (David).
> 
>  - Patch 10: the changelog says why the lock boundary belongs to the
>    caller (David).
> 
>  - Patch 11: both callers pass their TVA type as the literal it is rather
>    than reading it back from the policy (David).
> 
>  - Patch 12: kerneldoc on every function collapse.h declares (David).
> 
>  - Acked-by from David Hildenbrand on 1-4, 6 and 7; Reviewed-by from
>    Baolin Wang on 10.  Reviewed-by dropped from 5 and 9, which changed.

Here's how v4 altered mm.git.  It's substantial:


 mm/collapse.h   |   38 +++++---
 mm/khugepaged.c |  199 +++++++++++++++++++++++-----------------------
 mm/madvise.c    |   25 +++--
 3 files changed, 139 insertions(+), 123 deletions(-)

--- a/mm/collapse.h~b
+++ a/mm/collapse.h
@@ -45,27 +45,37 @@ enum scan_result {
 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
-/* What a collapse is allowed to do, decided by the caller that asks for it */
-struct collapse_policy {
-	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
+/* How many PTEs of a window may be missing, swapped out or shared */
+struct collapse_limits {
+	/* Counted over a PMD-sized window; HPAGE_PMD_NR means "no limit" */
 	unsigned int max_ptes_none;
 	unsigned int max_ptes_swap;
 	unsigned int max_ptes_shared;
+};
+
+/* What a collapse is allowed to do, decided by the caller that asks for it */
+struct collapse_policy {
+	/* Limits for a PMD-sized window */
+	struct collapse_limits pmd;
 
-	/* Take no swapped-out or shared PTE into a sub-PMD collapse */
-	bool strict_sub_pmd;
+	/*
+	 * Limits for a smaller window.  Its max_ptes_none is either 0 or
+	 * COLLAPSE_MAX_PTES_LIMIT, the latter meaning all but one PTE of the
+	 * window whatever its order; any other value counts as 0.
+	 */
+	struct collapse_limits sub_pmd;
 
 	/* Leave clean lazyfree folios to reclaim rather than collapse them */
-	bool skip_lazyfree;
+	bool anon_skip_lazyfree;
 
-	/* Refuse a range with no sign of use */
-	bool require_referenced;
+	/* Refuse an anonymous range with no sign of use */
+	bool anon_require_referenced;
 
 	/* Map the PMD over a file collapse instead of leaving it to a fault */
-	bool install_pmd;
+	bool file_install_pmd;
 
 	/* Write dirty pages back and retry once instead of refusing them */
-	bool writeback_dirty;
+	bool file_writeback_dirty;
 
 	/* How hard to try for a destination folio */
 	gfp_t gfp;
@@ -115,14 +125,13 @@ unsigned long collapse_possible_orders(s
  *     collapse_control_init(cc)              once, before the first table
  *     collapse_scan_pmd(vma, addr, ...)      per table
  *     collapse_run_pmd(mm, addr, result, cc) when a scan found work
- *     collapse_control_release(cc)           once, when done with the control
  *
  * The caller holds mmap_lock for reading over the scan and passes an address
  * within @vma, aligned to the PTE table to scan.
  *
- * The scan returns with that lock still held.  It only reads, and almost every
- * table it is offered has nothing to collapse, so a caller walks a whole VMA
- * under the one lock it took to get there.  SCAN_SUCCEED means there is
+ * The scan returns with that lock still held.  Almost every table it is
+ * offered has nothing to collapse, so a caller walks a whole VMA under the one
+ * lock it took to get there.  SCAN_SUCCEED means there is
  * something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache
  * already holds the PMD folio and only the PTE table is left to retract.
  * Both are work for the run, which is handed what the scan returned; anything
@@ -140,7 +149,6 @@ unsigned long collapse_possible_orders(s
  * gives it back.
  */
 void collapse_control_init(struct collapse_control *cc);
-void collapse_control_release(struct collapse_control *cc);
 enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders);
--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -314,27 +314,17 @@ static bool pte_none_or_zero(pte_t pte)
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
-	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
+	unsigned int max_ptes_none;
 
 	if (vma && userfaultfd_armed(vma))
 		return 0;
-	/* The limit as given, at the PMD order and wherever it is not capped */
-	if (is_pmd_order(order) || !cc->policy.strict_sub_pmd)
-		return max_ptes_none;
-	/*
-	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
-	 * scale the maximum number of PTEs to the order of the collapse.
-	 */
+	if (is_pmd_order(order))
+		return cc->policy.pmd.max_ptes_none;
+
+	/* Below PMD order: all but one PTE of the window, or none */
+	max_ptes_none = cc->policy.sub_pmd.max_ptes_none;
 	if (max_ptes_none == COLLAPSE_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
-	/*
-	 * For mTHP collapse of values other than 0 or COLLAPSE_MAX_PTES_LIMIT,
-	 * emit a warning and return 0.
-	 */
-	if (max_ptes_none)
-		pr_warn_once("mTHP collapse does not support max_ptes_none"
-		     " values other than 0 or %u, defaulting to 0.\n",
-		     COLLAPSE_MAX_PTES_LIMIT);
 	return 0;
 }
 
@@ -350,13 +340,9 @@ static unsigned int collapse_max_ptes_no
 static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
 		unsigned int order)
 {
-	/*
-	 * A sub-PMD window held to the strict rule takes no shared page at all:
-	 * an mTHP is not worth the CoW-breaking.
-	 */
-	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
-		return 0;
-	return cc->policy.max_ptes_shared;
+	if (is_pmd_order(order))
+		return cc->policy.pmd.max_ptes_shared;
+	return cc->policy.sub_pmd.max_ptes_shared;
 }
 
 /**
@@ -371,13 +357,9 @@ static unsigned int collapse_max_ptes_sh
 static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 		unsigned int order)
 {
-	/*
-	 * A sub-PMD window held to the strict rule takes nothing non-present:
-	 * reading pages back to build an mTHP is not worth the latency.
-	 */
-	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
-		return 0;
-	return cc->policy.max_ptes_swap;
+	if (is_pmd_order(order))
+		return cc->policy.pmd.max_ptes_swap;
+	return cc->policy.sub_pmd.max_ptes_swap;
 }
 
 int hugepage_madvise(struct vm_area_struct *vma,
@@ -494,9 +476,16 @@ void __khugepaged_enter(struct mm_struct
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-/*
- * Check what orders are possible based on the vma and collapse type.
- * This is used to determine if mTHP collapse is a viable option.
+/**
+ * collapse_possible_orders - which orders a VMA may collapse to
+ * @vma: the VMA
+ * @vm_flags: its flags, passed separately where they are about to change
+ * @tva_flags: who is asking, as thp_vma_allowable_orders() spells it
+ *
+ * khugepaged may collapse anonymous memory to any enabled order; everything
+ * else collapses to PMD order only.
+ *
+ * Return: the orders as a bitmask, zero when the VMA may not collapse at all.
  */
 unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
@@ -658,7 +647,7 @@ static enum scan_result __collapse_huge_
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			goto out;
@@ -747,12 +736,12 @@ static enum scan_result __collapse_huge_
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		if (cc->policy.require_referenced &&
+		if (cc->policy.anon_require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 
-	if (unlikely(cc->policy.require_referenced && !referenced)) {
+	if (unlikely(cc->policy.anon_require_referenced && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -957,14 +946,28 @@ static inline gfp_t alloc_hugepage_khuge
 /* khugepaged collapses on its own initiative, so it obeys its own settings */
 static void collapse_policy_khugepaged(struct collapse_policy *p)
 {
-	p->max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
-	p->max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
-	p->max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
-	p->strict_sub_pmd = true;
-	p->skip_lazyfree = true;
-	p->require_referenced = true;
-	p->install_pmd = false;
-	p->writeback_dirty = false;
+	p->pmd.max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
+	p->pmd.max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
+	p->pmd.max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
+
+	/*
+	 * A sub-PMD window takes no swapped-out and no shared PTE: reading
+	 * pages back or breaking CoW is not worth it for an mTHP.  Empty PTEs
+	 * it takes all or nothing, since anything in between would let one
+	 * collapse feed the next.
+	 */
+	p->sub_pmd.max_ptes_none = p->pmd.max_ptes_none;
+	if (p->sub_pmd.max_ptes_none &&
+	    p->sub_pmd.max_ptes_none != COLLAPSE_MAX_PTES_LIMIT)
+		pr_warn_once("mTHP collapse does not support max_ptes_none values other than 0 or %u, defaulting to 0.\n",
+			     COLLAPSE_MAX_PTES_LIMIT);
+	p->sub_pmd.max_ptes_swap = 0;
+	p->sub_pmd.max_ptes_shared = 0;
+
+	p->anon_skip_lazyfree = true;
+	p->anon_require_referenced = true;
+	p->file_install_pmd = false;
+	p->file_writeback_dirty = false;
 	p->gfp = alloc_hugepage_khugepaged_gfpmask();
 	p->tva_type = TVA_KHUGEPAGED;
 }
@@ -995,11 +998,20 @@ static int collapse_find_target_node(str
 }
 #endif
 
-/*
- * Find the VMA at @address again once mmap_lock has been given up and taken
- * back, and check it still allows a collapse of @order there.  The VMA has to
- * span the whole PMD whatever @order is; with @expect_anon it also has to be
- * anonymous and have an anon_vma.  *@vmap is the VMA found, if any.
+/**
+ * collapse_vma_revalidate - look a VMA up again after mmap_lock was dropped
+ * @mm: the mm
+ * @address: an address within the PTE table being collapsed
+ * @expect_anon: the collapse started on an anonymous VMA
+ * @vmap: the VMA found, if any
+ * @cc: the control, for the policy that says who is asking
+ * @order: the order the collapse is going for
+ *
+ * Called with mmap_lock held, for reading or writing, once it has been given up
+ * and taken back.  The VMA has to span the whole PMD whatever @order is; with
+ * @expect_anon it also has to be anonymous and have an anon_vma.
+ *
+ * Return: SCAN_SUCCEED, or why a collapse of @order at @address is off.
  */
 enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
 		bool expect_anon, struct vm_area_struct **vmap,
@@ -1667,7 +1679,7 @@ static enum scan_result collapse_scan_an
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			failed_pfn = folio_pfn(folio);
@@ -1733,11 +1745,11 @@ static enum scan_result collapse_scan_an
 			goto out_unmap;
 		}
 
-		if (cc->policy.require_referenced &&
+		if (cc->policy.anon_require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
-	if (cc->policy.require_referenced &&
+	if (cc->policy.anon_require_referenced &&
 	    (!referenced ||
 	     (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
@@ -2592,7 +2604,7 @@ immap_locked:
 	 * caller that wants the PMD mapped now is told to go and do that.
 	 */
 	retract_page_tables(mapping, start);
-	if (cc->policy.install_pmd)
+	if (cc->policy.file_install_pmd)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 	folio_unlock(new_folio);
 
@@ -2749,44 +2761,34 @@ static enum scan_result collapse_scan_fi
 	return result;
 }
 
-/* Set up a control before its first scan; cc->policy is the caller's to fill */
+/**
+ * collapse_control_init - set up a control before its first scan
+ * @cc: the control the caller carries across its scans
+ *
+ * cc->policy is the caller's to fill.
+ */
 void collapse_control_init(struct collapse_control *cc)
 {
 	cc->progress = 0;
 	cc->scan_file = NULL;
 }
 
-/* A scan that took a file reference should have been run */
-static void collapse_put_scan_file(struct collapse_control *cc)
-{
-	if (WARN_ON_ONCE(cc->scan_file)) {
-		fput(cc->scan_file);
-		cc->scan_file = NULL;
-	}
-}
-
-/*
- * Done with a control.  A scan that found something has to have been run by
- * then: the file side takes a reference on the file while it still has the
- * VMA to take it from, and the run is what gives it back.
- */
-void collapse_control_release(struct collapse_control *cc)
-{
-	collapse_put_scan_file(cc);
-}
-
-/*
- * Scan the PTE table of @vma at @addr for a collapse candidate.  @addr is
- * aligned to the table; @orders is what the caller allows there.
+/**
+ * collapse_scan_pmd - scan one PTE table for a collapse candidate
+ * @vma: the VMA the table belongs to
+ * @addr: start of the table, PMD aligned
+ * @cc: the caller's control
+ * @orders: the orders the caller allows for @vma
  *
- * Called with mmap_lock held for reading and returns with it still held.  It
- * only reads, and almost every table it is offered has nothing to collapse,
- * so a caller walks a whole VMA under the one lock it took to get there.
- *
- * SCAN_SUCCEED means there is something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE
- * means the page cache already holds the PMD folio and only the PTE table is
- * left to retract.  Both are work for collapse_run_pmd(), which is handed
- * what the scan returned; anything else is why there is nothing to do.
+ * Called with mmap_lock held for reading and returns with it still held.
+ * Almost every table it is offered has nothing to collapse, so a caller walks
+ * a whole VMA under the one lock it took to get there.
+ *
+ * Return: SCAN_SUCCEED when there is something to collapse;
+ * SCAN_PTE_MAPPED_HUGEPAGE when the page cache already holds the PMD folio and
+ * only the PTE table is left to retract.  Both are work for collapse_run_pmd(),
+ * which is handed what the scan returned.  Anything else is why there is
+ * nothing to do.
  */
 enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
@@ -2797,7 +2799,10 @@ enum scan_result collapse_scan_pmd(struc
 
 	mmap_assert_locked(vma->vm_mm);
 	/* Whatever the last scan found has to have been run by now */
-	collapse_put_scan_file(cc);
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
 
 	if (vma_is_anonymous(vma))
 		return collapse_scan_anon_pmd(vma, addr, cc, orders);
@@ -2820,15 +2825,20 @@ enum scan_result collapse_scan_pmd(struc
 	return result;
 }
 
-/*
- * Collapse the table a scan found work in.  @result is what the scan
- * returned.
+/**
+ * collapse_run_pmd - collapse the table a scan found work in
+ * @mm: the mm
+ * @addr: start of the table, as given to the scan
+ * @result: what the scan returned
+ * @cc: the control the scan ran with
  *
  * Called without mmap_lock and returns without it, taking what it needs in
  * between: what it does -- allocate, isolate, copy, flush -- is slow enough
  * that a writer would wait behind it.  The caller gives the lock up first,
  * and with it the VMA and anything derived under it.  The run revalidates for
  * itself rather than trusting what the scan saw.
+ *
+ * Return: what the collapse made of the table.
  */
 enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
 		enum scan_result result, struct collapse_control *cc)
@@ -2845,12 +2855,12 @@ enum scan_result collapse_run_pmd(struct
 
 	/* The scan found the PMD folio in place: nothing to collapse */
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
-		goto retract;
+		goto put;
 retry:
 	result = collapse_file(mm, addr, file, pgoff, cc);
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
-	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	if (cc->policy.file_writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
 	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
 		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
 		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
@@ -2859,7 +2869,7 @@ retry:
 		triggered_wb = true;
 		goto retry;
 	}
-retract:
+put:
 	fput(file);
 
 	/*
@@ -2872,7 +2882,7 @@ retract:
 			result = SCAN_ANY_PROCESS;
 		else
 			result = try_collapse_pte_mapped_thp(mm, addr,
-							cc->policy.install_pmd);
+							cc->policy.file_install_pmd);
 		if (result == SCAN_PMD_MAPPED)
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
@@ -2928,7 +2938,7 @@ static void collapse_scan_mm_slot(unsign
 		}
 		/* One mask for the whole VMA */
 		orders = collapse_possible_orders(vma, vma->vm_flags,
-						  cc->policy.tva_type);
+						  TVA_KHUGEPAGED);
 		if (!orders) {
 			cc->progress++;
 			continue;
@@ -3032,7 +3042,6 @@ static void khugepaged_do_scan(struct co
 	lru_add_drain_all();
 
 	collapse_control_init(cc);
-	/* One policy for the whole pass, so every table is treated the same */
 	collapse_policy_khugepaged(&cc->policy);
 
 	while (true) {
@@ -3065,8 +3074,6 @@ static void khugepaged_do_scan(struct co
 			khugepaged_alloc_sleep();
 		}
 	}
-
-	collapse_control_release(cc);
 }
 
 static bool khugepaged_should_wakeup(void)
--- a/mm/madvise.c~b
+++ a/mm/madvise.c
@@ -910,16 +910,18 @@ bool madvise_dontneed_free_valid_vma(str
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 /* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
-static void collapse_policy_forced(struct collapse_policy *p)
+static void collapse_policy_madvise(struct collapse_policy *p)
 {
-	p->max_ptes_none = HPAGE_PMD_NR;
-	p->max_ptes_swap = HPAGE_PMD_NR;
-	p->max_ptes_shared = HPAGE_PMD_NR;
-	p->strict_sub_pmd = false;
-	p->skip_lazyfree = false;
-	p->require_referenced = false;
-	p->install_pmd = true;
-	p->writeback_dirty = true;
+	p->pmd.max_ptes_none = HPAGE_PMD_NR;
+	p->pmd.max_ptes_swap = HPAGE_PMD_NR;
+	p->pmd.max_ptes_shared = HPAGE_PMD_NR;
+	/* Never read: MADV_COLLAPSE collapses to PMD order only */
+	p->sub_pmd = p->pmd;
+
+	p->anon_skip_lazyfree = false;
+	p->anon_require_referenced = false;
+	p->file_install_pmd = true;
+	p->file_writeback_dirty = true;
 	p->gfp = GFP_TRANSHUGE;
 	p->tva_type = TVA_FORCED_COLLAPSE;
 }
@@ -984,7 +986,7 @@ static int madvise_collapse(struct madvi
 	if (!cc)
 		return -ENOMEM;
 	collapse_control_init(cc);
-	collapse_policy_forced(&cc->policy);
+	collapse_policy_madvise(&cc->policy);
 
 	lru_add_drain_all();
 
@@ -1010,7 +1012,7 @@ static int madvise_collapse(struct madvi
 			vma = found;
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 			orders = collapse_possible_orders(vma, vma->vm_flags,
-							  cc->policy.tva_type);
+							  TVA_FORCED_COLLAPSE);
 		}
 
 		result = collapse_scan_pmd(vma, addr, cc, orders);
@@ -1056,7 +1058,6 @@ out:
 		mmap_read_lock(mm);
 out_locked:
 	mmap_assert_locked(mm);
-	collapse_control_release(cc);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
_


