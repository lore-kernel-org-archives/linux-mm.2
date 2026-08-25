Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72251C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721226B00B6; Tue, 25 Aug 2026 08:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8226B00B7; Tue, 25 Aug 2026 08:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7086B00B8; Tue, 25 Aug 2026 08:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 220A46B00B6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:24:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8372DC0334
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:24:03 +0000 (UTC)
X-FDA: 85139708766.07.F7C09A1
Received: from mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	by imf15.hostedemail.com (Postfix) with ESMTP id 26746A000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:24:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dIMNKCfg;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.8 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787660641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6a0WL1oZQxgEhJn1xUDX5yA/br3++2lhcWpu26dc1IE=;
	b=d+YD16tYPDcHasQ/XmcPy4BnXDQKEgRkYsEA5bLJ0exuFcurDBnE/ini7+VW0ZhPP/h9Jx
	bN+k+VirngEHyF3I2EsDU4Yp5aBuezf8ITr9NEOWU5WaP8r7ZAA9kSSLfL4qBmk2R96FIZ
	+I8GFXPQI8HylcS+SZ6ZTqHqKr2JiBk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dIMNKCfg;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.8 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787660641;
	b=pW5IWzsOo9ZthKwF77iH5ze4/dQNXmS81sj2Vr4I7kZgpUMlILukVtNGVNEWnHh/YAV5XT
	CsLNIxscNQGlbb2owxgAN8vw6ar2kQdHCtFW73gBSULLajuCtfegsm0q5CEj/eYGDWhawu
	Sg7wFZyrI4s5zQJhpia/78MpLsfKGBU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JiDl8+rRZvEx3bnQnR/RfiWHkTkG5g/aS9NhKFJB3N4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787660639; v=1; x=1788265439;
 b=dIMNKCfgaqGIc/cA2lPQ9/RS/2cur8EN9iDIesLlMIElAIn3Pqv6pDj7/kttKJikRViM1E8Y
 ox2npj8qs5zrdPK3i+/ZTzEB7ZhrARH4sV2yczPlJp/1eX5MFcZFRQp3nUNtLz9LdXHdeB+sRk2
 mMmb+4Mmg+N8b2muZjPZoUso=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id a44e0ee79fd3e8ed;
	Tue, 25 Aug 2026 12:23:59 +0000
X-Mizu-Trace-ID: a44e0ee79fd3e8ed
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: hughd@google.com,
	kirill@shutemov.name
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 19/57] mm/collapse: install a PMD leaf as the terminal layer
Date: Tue, 25 Aug 2026 20:23:54 +0800
Message-Id: <20260825122354.98021-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260816224609.308019-20-kirill@shutemov.name>
References: <20260816224609.308019-20-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jffsjri8ia6yqbkmr6pr1uzb31d84iw4
X-Rspamd-Queue-Id: 26746A000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787660640-969212
X-HE-Meta: U2FsdGVkX18J1iWCVj8tfPgOlM1BF4UJOhTZtRzjDAXXiFogbCjC2Dvivyk6W/J1LR/XNLl5QEQHU8J/B3dY9qLF9qasjHB6gNOP2dG9CnUUbcH+aoWo7Hpe8fGXrkkk1qyw2oMLchAxLUbvsoQncKmsbz5GOFFrSTQRp6sJSSsj4zOYuYf5DI888o9Jv5OPEGqGVJVep/4xxkIx8+xOCo4z3I/qOhp1hHwhxG97z92sIcFfpFwFoIhiakKquUXzsqKRZ5uqdgVypIFqRXwU/2tw8CsBPCckAv6TfloEwQS2ixF8oWGiu6i9Fp2Qujx/iSd78tW1H/mFccgx4jq/7LWSeoiU05pTS55bg6jnlRC2zbcxZT+7ycIvCsGbDQ///sUx5CxA5WESD/XTX1L6vUcwDT1eXAsnTgWZ4WlOIXI1JRSGK/J9/IOYlkj3hVQ93hSVJ90BvFL5SuxAOzKVlouUCHwtyh+gZgsAsvNMxRkKLMX5t/wjFPAV1lmCzQs7Lczpq56lLeDrLXvnofHLHju0bZhPWXrMGM/ID2xkQboR4sNS60i2SqJZfAs0FRcorupkXONemzCoHltHAg77r2VkpBPxM7mofF6T21bqysj5KSiXKTeyMoc5Jp/ZmbcxbLAs2s0B1MwulU216WK3hCAQ/JAdf3rXW0GKMEdsmr85h+cwE1B2kxpDhhEzsjmg22zBUjWu3hVvdo7NHtGy/ohbEmlOQT4S3Oe1PK2VNAfb6/M4VRAF7b8g7qn1ed3ZCwyG7/NggXY5McAZMOsiO5700xz59hEw7HxP5KTMKzEZYvQVl9TyICZ0oAdsveJlmtHIyBQsgt6o2Ttzm0QudI017lJP6e2Jte9AotHWtvdiCXB8Q0i6fUAkiV+SB42xk+vVwRWyloZmihQ6Ia8GRcWSDhjtu8ShCa3QTEf3umCjKgUp4u8w5jB2CW9Xgv2Wq94y5XmFS6v52UNfa/5
 5dt0t9UP
 vQGzCAxcRa0yDHSoJydqlZhplFWWhTjw8IFZMBNQopZbaKS0PTOyx0DTiGYjAAuo/JwKEObDlAXaDztGwlGozyqs33XL6qgfq4EajCs5i16e15FFBOUgG0hHA7ww4561A9BjTtQOlCX1on6LfKZB4uMKB0OORnwF4An57FD7t+GcDsRX7Ad7hSUWOAdDbctyVfJo3RJG6WxBz+E/SnckbraiSXViz7Fwasu/jSqLrlLl0tpqG+e69jdWoU3oiMQ2ZZHahe63sFEEdmiw9MAJeN8AoU6df8/nWWEamO9Ea+XsDviAxvIw8qLIqtDkfSJYDoy+XDY74KzFzyNDs92WLnCXtUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

@Hugh, who added pmdp_get_lockless_sync() for the PAE case in
146b42e07494.

On Sun, Aug 16, 2026 at 11:45:31PM +0100, Kiryl Shutsemau wrote:
>From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
>Fill in the PMD install.  Under the pmd lock, with the pte ptl nested
>inside it: verify, detach the table with pmdp_collapse_flush(), deposit a
>fresh one and map the leaf.
>
>That is one atomic section, so no pmd_none() window ever exists: faults
>stay held down at pte level by the migration entries throughout.  It is
>what lets PMD collapse run under mmap_read like everything else here.
>
>Two things force that nesting, which is the one the tree already uses to
>reinstall a table.  A racing zap of a frozen entry takes the pte ptl, so
>the verify has to hold it.  And the table must not come apart between
>verify and detach, which is the pmd lock's job.
>
>Nothing leaves the section early, aborts included.  An abort only
>restores PTEs and would need no pmd-level exclusion of its own, except
>that its pte pointer came from pte_offset_map_rw_nolock(), whose caller
>must establish that the pmd is stable.
>
>The deposited table is the freshly allocated one, never the table just
>detached.  A deposited table has to be quiescent, because whoever
>withdraws it frees it immediately with nothing to hold a lockless walker
>off first, and a table that has never been reachable is quiescent by
>construction.
>
>The detached one is not: GUP-fast and RCU pte walks that read the old PMD
>may still be inside it, and on broadcast-TLBI architectures the flush
>expels nobody.  Quiescing it would need an IPI, which has nowhere to go
>here -- outside the pmd lock it opens the pmd_none() window this design
>does not have, inside it is a broadcast under a spinlock.  So the
>detached table goes to pte_free_defer(), which holds the free until those
>walkers finish.  One transient table page per PMD collapse is the cost.

Well, git history spells out why pmdp_get_lockless_sync() is needed here.

146b42e07494 added PAE safety because pmdp_get_lockless() can assemble a
pmd_low + pmd_high pair that never belonged to the same PMD value.

1d65b771bc08 then put pmdp_get_lockless_sync() right after
pmdp_collapse_flush() (with pmd lock + pte lock held), and 1043173eb5eb
used the same placement in collapse_pte_mapped_thp().

Current implementation spells out the reader-side rule as well:

#if CONFIG_PGTABLE_LEVELS > 2
static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
{
	pmd_t pmd;

	do {
		pmd.pmd_low = pmdp->pmd_low;
		smp_rmb();
		pmd.pmd_high = pmdp->pmd_high;
		smp_rmb();
	} while (unlikely(pmd.pmd_low != pmdp->pmd_low));

	return pmd;
}
#define pmdp_get_lockless pmdp_get_lockless
#define pmdp_get_lockless_sync() tlb_remove_table_sync_one()
#endif /* CONFIG_PGTABLE_LEVELS > 2 */

#if defined(CONFIG_GUP_GET_PXX_LOW_HIGH) && \
	(defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RCU))
/*
 * See the comment above ptep_get_lockless() in include/linux/pgtable.h:
 * the barriers in pmdp_get_lockless() cannot guarantee that the value in
 * pmd_high actually belongs with the value in pmd_low; but holding interrupts
 * off blocks the TLB flush between present updates, which guarantees that a
 * successful __pte_offset_map() points to a page from matched halves.
 */
static unsigned long pmdp_get_lockless_start(void)
{
	unsigned long irqflags;

	local_irq_save(irqflags);
	return irqflags;
}
static void pmdp_get_lockless_end(unsigned long irqflags)
{
	local_irq_restore(irqflags);
}
...
#endif

pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
{
	unsigned long irqflags;
	pmd_t pmdval;

	rcu_read_lock();
	irqflags = pmdp_get_lockless_start();
	pmdval = pmdp_get_lockless(pmd);
	pmdp_get_lockless_end(irqflags);

	if (pmdvalp)
		*pmdvalp = pmdval;
	if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
		goto nomap;
	if (unlikely(pmd_trans_huge(pmdval)))
		goto nomap;
	if (unlikely(pmd_bad(pmdval))) {
		pmd_clear_bad(pmd);
		goto nomap;
	}
	return __pte_map(&pmdval, addr);
nomap:
	rcu_read_unlock();
	return NULL;
}

Hmm, Patch #19 still has the present table PMD -> none -> present leaf
PMD transition. collapse_install_pmd() does pmdp_collapse_flush() and
installs the new PMD through map_anon_folio_pmd_nopf() without
pmdp_get_lockless_sync() in between. pte_free_defer() keeps the old table
alive for RCU readers, but it can't stop pmdp_get_lockless() in
__pte_offset_map() from assembling halves across that transition.

FWIW, pmdp_get_lockless_sync() is an empty inline when pmdp_get_lockless()
doesn't use the pmd_low/pmd_high reader. On x86,
CONFIG_GUP_GET_PXX_LOW_HIGH is selected only by X86_PAE, so other x86
configs wouldn't pay the IPI cost.

@Hugh, do I miss something?

Could we keep pmdp_get_lockless_sync() right after pmdp_collapse_flush(),
before map_anon_folio_pmd_nopf() (and while the locks are still held)?

Maybe:

---8<---
diff --git a/mm/collapse.c b/mm/collapse.c
index 7c10888031f7..cf4e57b598f9 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -1585,6 +1585,7 @@ static void collapse_install_pmd(struct vm_area_struct *vma,
 	 * is why the helper shoots down a pte range rather than a pmd.
 	 */
 	old_pmd = pmdp_collapse_flush(vma, cand->addr, pmd);
+	pmdp_get_lockless_sync();
 	old_table = pmd_pgtable(old_pmd);

 	/*
@@ -1601,14 +1602,11 @@ static void collapse_install_pmd(struct vm_area_struct *vma,
 	 * construction, which is why collapse_alloc() secured one.
 	 *
 	 * The detached table is not.  GUP-fast and RCU pte walks that read the
-	 * old PMD before pmdp_collapse_flush() may still be inside it, and on
-	 * broadcast-TLBI arches that flush expels nobody.  Quiescing it would
-	 * take an IPI (tlb_remove_table_sync_one()), which has nowhere to go
-	 * here: outside the pmd lock it opens a pmd_none window a fault can fill,
-	 * inside it is a broadcast under a spinlock.  So it goes to
-	 * pte_free_defer(), which holds the free until those walkers finish, as
-	 * retract_page_tables() does.  One transient table page per PMD collapse
-	 * is what that costs.
+	 * old PMD before pmdp_collapse_flush() may still be inside it.
+	 * pmdp_get_lockless_sync() keeps split-PMD readers from observing
+	 * unmatched halves across the transition, while pte_free_defer() holds
+	 * the free until RCU readers finish.  One transient table page per PMD
+	 * collapse is what that costs.
 	 */
 	pgtable_trans_huge_deposit(mm, pmd, cand->deposit);
 	map_anon_folio_pmd_nopf(cand->new_folio, pmd, vma, cand->addr);
---

Cheers, Lance

>No anon_vma_lock_write() is taken, unlike the mechanism being replaced:
>
> - rmap walks on the sources are unreachable, their refcounts frozen and
>   their folio locks held from freeze to putback;
> - non-rmap pte walkers see migration entries;
> - pmd-level observers see either the old table or the leaf, never an
>   intermediate;
> - fork, mremap and munmap take mmap_write, which the mmap_read held here
>   excludes.
>
>Assisted-by: Claude-Code:claude-opus-5
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---
> mm/collapse.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 118 insertions(+)
>
>diff --git a/mm/collapse.c b/mm/collapse.c
>index 842adc30aeb0..ab7476471b8d 100644
>--- a/mm/collapse.c
>+++ b/mm/collapse.c
>@@ -1232,6 +1232,124 @@ static bool collapse_verify_candidate(struct collapse_candidate *cand,
> static void collapse_install_pmd(struct vm_area_struct *vma,
> 				 struct collapse_control *cc, pmd_t *pmd)
> {
>+	struct collapse_candidate *cand = &cc->candidates[0];
>+	struct mm_struct *mm = vma->vm_mm;
>+	spinlock_t *pmd_ptl, *pte_ptl;
>+	pgtable_t old_table = NULL;
>+	unsigned int nr_populated;
>+	pmd_t old_pmd, pmdval;
>+	pte_t *pte;
>+
>+	if (cand->state != CAND_FROZEN)
>+		return;
>+
>+	/* No destination: the provision pass could not spare one */
>+	if (!cand->new_folio) {
>+		pte = pte_offset_map_lock(mm, pmd, cand->addr, &pte_ptl);
>+		collapse_abort_candidate(vma, cand, pte);
>+		if (pte)
>+			pte_unmap_unlock(pte, pte_ptl);
>+		return;
>+	}
>+
>+	/*
>+	 * The pte ptl nests inside the pmd lock, the nesting the tree already
>+	 * uses for reinstalling a table: a racing zap of a frozen entry takes
>+	 * the pte ptl, so the verify must hold it, and the table must not come
>+	 * apart between verify and detach.  pmd_same() rechecks are unnecessary,
>+	 * the pmd lock being held across the whole section.
>+	 */
>+	pmd_ptl = pmd_lock(mm, pmd);
>+	pte = pte_offset_map_rw_nolock(mm, pmd, cand->addr, &pmdval, &pte_ptl);
>+	if (!pte) {
>+		/* Table gone under us; see collapse_abort_candidate() on @pte */
>+		spin_unlock(pmd_ptl);
>+		cand->result = SCAN_NO_PTE_TABLE;
>+		collapse_abort_candidate(vma, cand, NULL);
>+		return;
>+	}
>+	if (pte_ptl != pmd_ptl)
>+		spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
>+
>+	/*
>+	 * Every exit is inside that section, the aborts as much as the install.
>+	 * An abort needs no pmd-level exclusion of its own; it only restores
>+	 * PTEs.  But the table it works on came from pte_offset_map_rw_nolock(),
>+	 * which leaves its caller to establish that the pmd is stable, and the
>+	 * held pmd lock is what does that here.
>+	 */
>+	if (cand->result != SCAN_SUCCEED) {
>+		/* Machine check during the copy */
>+		collapse_abort_candidate(vma, cand, pte);
>+		goto out_unlock;
>+	}
>+
>+	if (!collapse_verify_candidate(cand, pte, &nr_populated)) {
>+		cand->result = SCAN_PTE_NON_PRESENT;
>+		collapse_abort_candidate(vma, cand, pte);
>+		goto out_unlock;
>+	}
>+
>+	/*
>+	 * Nothing fallible sits past here.  No anon_vma_lock_write either: rmap
>+	 * walks on the sources are unreachable -- refcounts frozen, folio locks
>+	 * held from freeze to putback -- non-rmap pte walkers see migration
>+	 * entries, pmd-level observers see the old table or the leaf and never an
>+	 * intermediate, and fork, mremap and munmap take mmap_write, which our
>+	 * mmap_read excludes.
>+	 *
>+	 * The flush inside pmdp_collapse_flush() is the round's second over this
>+	 * range: the freeze displaced every leaf here and flushed before dropping
>+	 * the ptl, and the verify above proved nothing has been mapped since.
>+	 * What it covers is the paging-structure caches -- a CPU may still hold
>+	 * the pmd-to-table link, for a table that is about to be freed -- which
>+	 * is why the helper shoots down a pte range rather than a pmd.
>+	 */
>+	old_pmd = pmdp_collapse_flush(vma, cand->addr, pmd);
>+	old_table = pmd_pgtable(old_pmd);
>+
>+	/*
>+	 * The smp_wmb() in __folio_mark_uptodate() orders the copied data before
>+	 * the install below publishes it.
>+	 */
>+	__folio_mark_uptodate(cand->new_folio);
>+
>+	/*
>+	 * Deposit a freshly allocated table, not the one just detached: a
>+	 * deposited table has to be quiescent, because whoever withdraws it frees
>+	 * it immediately (zap_huge_pmd()) with nothing to hold a lockless walker
>+	 * off first.  A table that has never been reachable is quiescent by
>+	 * construction, which is why collapse_alloc() secured one.
>+	 *
>+	 * The detached table is not.  GUP-fast and RCU pte walks that read the
>+	 * old PMD before pmdp_collapse_flush() may still be inside it, and on
>+	 * broadcast-TLBI arches that flush expels nobody.  Quiescing it would
>+	 * take an IPI (tlb_remove_table_sync_one()), which has nowhere to go
>+	 * here: outside the pmd lock it opens a pmd_none window a fault can fill,
>+	 * inside it is a broadcast under a spinlock.  So it goes to
>+	 * pte_free_defer(), which holds the free until those walkers finish, as
>+	 * retract_page_tables() does.  One transient table page per PMD collapse
>+	 * is what that costs.
>+	 */
>+	pgtable_trans_huge_deposit(mm, pmd, cand->deposit);
>+	map_anon_folio_pmd_nopf(cand->new_folio, pmd, vma, cand->addr);
>+
>+	/* Slots with no source gain anon memory that no zap accounted */
>+	if (nr_populated)
>+		add_mm_counter(mm, MM_ANONPAGES, nr_populated);
>+	cand->deposit = NULL;
>+	cand->new_folio = NULL;	/* ownership: the mapping */
>+	cand->state = CAND_INSTALLED;
>+
>+out_unlock:
>+	if (pte_ptl != pmd_ptl)
>+		spin_unlock(pte_ptl);
>+	pte_unmap(pte);
>+	spin_unlock(pmd_ptl);
>+
>+	/* The deposit balanced the detached table, so the count is already right */
>+	if (old_table)
>+		pte_free_defer(mm, old_table);
> }
> 
> /* Publish each destination folio in place of the sources it replaces */
>-- 
>2.54.0
>
>

