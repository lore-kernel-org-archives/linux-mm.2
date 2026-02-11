Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 716BEE9E303
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 12:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE096B0089; Wed, 11 Feb 2026 07:55:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A689B6B008A; Wed, 11 Feb 2026 07:55:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967F26B008C; Wed, 11 Feb 2026 07:55:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 804256B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:55:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36ED0B8BF9
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:55:32 +0000 (UTC)
X-FDA: 84432172104.04.D98E574
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf01.hostedemail.com (Postfix) with ESMTP id 46F1540006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:55:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7eNjFTs;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770814530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VoRpH/aPogp3RWnInx80M/XPtYXjz2/CnXOtBqYfR7c=;
	b=MIEWpwWO/UGazz9olUzrWiOb7EGNZ5cDcXQ6bee2d61SWnwL3pwdE41nCgWrgz8axfigkV
	g3Eu5lCebD47wRU2PJCvuFrju5fIAaUPstNPrSA/Z0iiSlvjwbgTqx/WCwNh/MVrE6RG7h
	6gjiKzb5dZc2O3hU9gJanxSw5MpWxpY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7eNjFTs;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770814530; a=rsa-sha256;
	cv=none;
	b=MzNID5f1pvx2JN9DDklkWWSO7cjmBp992YJ/EvDm8X2YMIje8wnZflDHxNcF6Rk6cj7/MF
	OiW91kgIpsWs9ED/q58EbW4VAQkmvqCpwMaMYDKRproJVfV6267iR/bDVg6a+kLyUwNhLM
	/bYcE/F3Ump1N7FUeUA7Yn6RIYTe1Uo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770814528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VoRpH/aPogp3RWnInx80M/XPtYXjz2/CnXOtBqYfR7c=;
	b=t7eNjFTstXGk3MpP6Cbx3LyJdeh9ghl1l3sphPyCFsOi4ni/airGRstdLBu6OGZq8Sy2x/
	gb7BGarAiubQw4S69Ss11eiwggVkMUblm7W1m9099dqG6JOiz4I0tqLpD9SX9mPGmvhbqg
	3PihA8zJcNOeZbgQgAYA3fdXUgh5uHQ=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
Date: Wed, 11 Feb 2026 04:49:45 -0800
Message-ID: <20260211125507.4175026-2-usama.arif@linux.dev>
In-Reply-To: <20260211125507.4175026-1-usama.arif@linux.dev>
References: <20260211125507.4175026-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 46F1540006
X-Stat-Signature: weig99ukoiqca4awgeq6b6wq84xxowg9
X-Rspam-User: 
X-HE-Tag: 1770814530-494446
X-HE-Meta: U2FsdGVkX1+zhDxjNZfO1h2vsPWvH2W4p3PX0JupIKKxg2hBtXZs/SF1YhxF4rYVUDGUNjz+WH612yBzAK7cDMLybjOm8dq+sElSKHfFEqv7l4ifhHLCHRybTGu/+/+dWbcWafQGZPm1Xa/D1FgPjKLlhcKZWM95mw3BSMu4gzxZ54PU06/9CHmJF6ZxIrTELAZOnqfoGYXMKA3qE4ElXiaFUdKtdgoHV2OURSXXIo5nUVCZereKdmYJr65yeVq0llvnLIPvHigbt2Le7huferCGyozjjOUYxn3zvobKfY6CIXcmMvVx3Fj0TCv8YU4hmU64JQ7d9LKRNhVbebQkHldXp8vFH1hxBmFeDao7h9LieGLNw7Ccb8TChW8Q46NIcS+A0/pDuPl2l6sPmHekQLIY5RJgo3J5EHzHJzPb7WwyjvpX1XiElgBVwwvM81Cr0k3UBsKxL+LYRvB00OfO2VpDKxfK9kP56wqlxKdIGa7m5eIa1Z7A48XOjWf6gZ7K9IklnkgfQzCg5EJHay0kwM+952jvoCStM07wsRpLXZkLHXxh71JrZAfIDh2B9GlHPzPGqc6BG+G6aLewt6U8xifOYjTuCK2moYm2xWThDWszOSPhzlIQMC+s3NqZxWiAeY15x1czSJSLNuUGleNjoTYxilPOQNiLE6YfpQeoejIrAGR+RPTZuYunBN7mbTZElNmbWqBygJ+mOygF5sv/vyxMlmVhLuwjst0E8zVJi2NUH/grc4CoNZFJGN3tXuFeM1/RMDknJ540RE8Yem0qf2CxjT6+ZyYHFniENlZbZ8pTeAt+8307LyjYs2zv35HGrbdJKKp9JxvD3M5jWOHLYmso6PgGUAQGBbNos65qH05KP2LJ6pGoJog2hKOEbRzBRf4bhhjS9k0cnSZjm82pdsWwFKhSxs2qKBPLbPsliJN69y5qWq7UQbXlahqc7A3Kdd8EGlJEKUaMu3/Gq3D
 epINyDrf
 vcilT0y6AP6/dp5Wu6c6QAOJNs/60R8ttXkBIRrYUMI7VuorD4Yzhq4DzpBsfYDld1y5JoBaMM7juiOn1s4kzjY2APGZGUFUrCf9rgMM/kPJu4PyI5IzumZpZpB9FWwIN58unnl+MhxK6Byq9tLxYlDjrCgOiMlZtbFlqyvZO2E2DYeET3z4fCkFdk3vdGi4lqF8QvV5qz/o5o3/GN92DqKppkIvcpPNGbnP/XNmbPQyNgyMpUNNoJFK00IcoyfXZzadThMrWDxqKUjfV0ubpyUwlU9X/+vdpfCwk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the kernel creates a PMD-level THP mapping for anonymous pages,
it pre-allocates a PTE page table and deposits it via
pgtable_trans_huge_deposit(). This deposited table is withdrawn during
PMD split or zap. The rationale was that split must not fail—if the
kernel decides to split a THP, it needs a PTE table to populate.

However, every anon THP wastes 4KB (one page table page) that sits
unused in the deposit list for the lifetime of the mapping. On systems
with many THPs, this adds up to significant memory waste. The original
rationale is also not an issue. It is ok for split to fail, and if the
kernel can't find an order 0 allocation for split, there are much bigger
problems. On large servers where you can easily have 100s of GBs of THPs,
the memory usage for these tables is 200M per 100G. This memory could be
used for any other usecase, which include allocating the pagetables
required during split.

This patch removes the pre-deposit for anonymous pages on architectures
where arch_needs_pgtable_deposit() returns false (every arch apart from
powerpc, and only when radix hash tables are not enabled) and allocates
the PTE table lazily—only when a split actually occurs. The split path
is modified to accept a caller-provided page table.

PowerPC exception:

It would have been great if we can completely remove the pagetable
deposit code and this commit would mostly have been a code cleanup patch,
unfortunately PowerPC has hash MMU, it stores hash slot information in
the deposited page table and pre-deposit is necessary. All deposit/
withdraw paths are guarded by arch_needs_pgtable_deposit(), so PowerPC
behavior is unchanged with this patch. On a better note,
arch_needs_pgtable_deposit will always evaluate to false at compile time
on non PowerPC architectures and the pre-deposit code will not be
compiled in.

Why Split Failures Are Safe:

If a system is under severe memory pressure that even a 4K allocation
fails for a PTE table, there are far greater problems than a THP split
being delayed. The OOM killer will likely intervene before this becomes an
issue.
When pte_alloc_one() fails due to not being able to allocate a 4K page,
the PMD split is aborted and the THP remains intact. I could not get split
to fail, as its very difficult to make order-0 allocation to fail.
Code analysis of what would happen if it does:

- mprotect(): If split fails in change_pmd_range, it will fallback
to change_pte_range, which will return an error which will cause the
whole function to be retried again.

- munmap() (partial THP range): zap_pte_range() returns early when
pte_offset_map_lock() fails, causing zap_pmd_range() to retry via pmd--.
For full THP range, zap_huge_pmd() unmaps the entire PMD without
split.

- Memory reclaim (try_to_unmap()): Returns false, folio rotated back
LRU, retried in next reclaim cycle.

- Migration / compaction (try_to_migrate()): Returns -EAGAIN, migration
skips this folio, retried later.

- CoW fault (wp_huge_pmd()): Returns VM_FAULT_FALLBACK, fault retried.

-  madvise (MADV_COLD/PAGEOUT): split_folio() internally calls
try_to_migrate() with TTU_SPLIT_HUGE_PMD. If PMD split fails,
try_to_migrate() returns false, split_folio() returns -EAGAIN,
and madvise returns 0 (success) silently skipping the region. This
should be fine. madvise is just an advice and can fail for other
reasons as well.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h |   4 +-
 mm/huge_memory.c        | 144 ++++++++++++++++++++++++++++------------
 mm/khugepaged.c         |   7 +-
 mm/migrate_device.c     |  15 +++--
 mm/rmap.c               |  39 ++++++++++-
 5 files changed, 156 insertions(+), 53 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfdea..b21bb72a298c9 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -562,7 +562,7 @@ static inline bool thp_migration_supported(void)
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
-			   pmd_t *pmd, bool freeze);
+			   pmd_t *pmd, bool freeze, pgtable_t pgtable);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
 void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
@@ -660,7 +660,7 @@ static inline void split_huge_pmd_address(struct vm_area_struct *vma,
 		unsigned long address, bool freeze) {}
 static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
 					 unsigned long address, pmd_t *pmd,
-					 bool freeze) {}
+					 bool freeze, pgtable_t pgtable) {}
 
 static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 					 unsigned long addr, pmd_t *pmdp,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 44ff8a648afd5..4c9a8d89fc8aa 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1322,17 +1322,19 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
 	struct folio *folio;
-	pgtable_t pgtable;
+	pgtable_t pgtable = NULL;
 	vm_fault_t ret = 0;
 
 	folio = vma_alloc_anon_folio_pmd(vma, vmf->address);
 	if (unlikely(!folio))
 		return VM_FAULT_FALLBACK;
 
-	pgtable = pte_alloc_one(vma->vm_mm);
-	if (unlikely(!pgtable)) {
-		ret = VM_FAULT_OOM;
-		goto release;
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(vma->vm_mm);
+		if (unlikely(!pgtable)) {
+			ret = VM_FAULT_OOM;
+			goto release;
+		}
 	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -1347,14 +1349,18 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		if (userfaultfd_missing(vma)) {
 			spin_unlock(vmf->ptl);
 			folio_put(folio);
-			pte_free(vma->vm_mm, pgtable);
+			if (pgtable)
+				pte_free(vma->vm_mm, pgtable);
 			ret = handle_userfault(vmf, VM_UFFD_MISSING);
 			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			return ret;
 		}
-		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
+		if (pgtable) {
+			pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd,
+						   pgtable);
+			mm_inc_nr_ptes(vma->vm_mm);
+		}
 		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
-		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 	}
 
@@ -1450,9 +1456,11 @@ static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
 	pmd_t entry;
 	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
 	entry = pmd_mkspecial(entry);
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	if (pgtable) {
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		mm_inc_nr_ptes(mm);
+	}
 	set_pmd_at(mm, haddr, pmd, entry);
-	mm_inc_nr_ptes(mm);
 }
 
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
@@ -1471,16 +1479,19 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
 			transparent_hugepage_use_zero_page()) {
-		pgtable_t pgtable;
+		pgtable_t pgtable = NULL;
 		struct folio *zero_folio;
 		vm_fault_t ret;
 
-		pgtable = pte_alloc_one(vma->vm_mm);
-		if (unlikely(!pgtable))
-			return VM_FAULT_OOM;
+		if (arch_needs_pgtable_deposit()) {
+			pgtable = pte_alloc_one(vma->vm_mm);
+			if (unlikely(!pgtable))
+				return VM_FAULT_OOM;
+		}
 		zero_folio = mm_get_huge_zero_folio(vma->vm_mm);
 		if (unlikely(!zero_folio)) {
-			pte_free(vma->vm_mm, pgtable);
+			if (pgtable)
+				pte_free(vma->vm_mm, pgtable);
 			count_vm_event(THP_FAULT_FALLBACK);
 			return VM_FAULT_FALLBACK;
 		}
@@ -1490,10 +1501,12 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 			ret = check_stable_address_space(vma->vm_mm);
 			if (ret) {
 				spin_unlock(vmf->ptl);
-				pte_free(vma->vm_mm, pgtable);
+				if (pgtable)
+					pte_free(vma->vm_mm, pgtable);
 			} else if (userfaultfd_missing(vma)) {
 				spin_unlock(vmf->ptl);
-				pte_free(vma->vm_mm, pgtable);
+				if (pgtable)
+					pte_free(vma->vm_mm, pgtable);
 				ret = handle_userfault(vmf, VM_UFFD_MISSING);
 				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			} else {
@@ -1504,7 +1517,8 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 			}
 		} else {
 			spin_unlock(vmf->ptl);
-			pte_free(vma->vm_mm, pgtable);
+			if (pgtable)
+				pte_free(vma->vm_mm, pgtable);
 		}
 		return ret;
 	}
@@ -1836,8 +1850,10 @@ static void copy_huge_non_present_pmd(
 	}
 
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-	mm_inc_nr_ptes(dst_mm);
-	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	if (pgtable) {
+		mm_inc_nr_ptes(dst_mm);
+		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	}
 	if (!userfaultfd_wp(dst_vma))
 		pmd = pmd_swp_clear_uffd_wp(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
@@ -1877,9 +1893,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (!vma_is_anonymous(dst_vma))
 		return 0;
 
-	pgtable = pte_alloc_one(dst_mm);
-	if (unlikely(!pgtable))
-		goto out;
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(dst_mm);
+		if (unlikely(!pgtable))
+			goto out;
+	}
 
 	dst_ptl = pmd_lock(dst_mm, dst_pmd);
 	src_ptl = pmd_lockptr(src_mm, src_pmd);
@@ -1897,7 +1915,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	}
 
 	if (unlikely(!pmd_trans_huge(pmd))) {
-		pte_free(dst_mm, pgtable);
+		if (pgtable)
+			pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
 	/*
@@ -1923,7 +1942,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, dst_vma, src_vma))) {
 		/* Page maybe pinned: split and retry the fault on PTEs. */
 		folio_put(src_folio);
-		pte_free(dst_mm, pgtable);
+		if (pgtable)
+			pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
 		__split_huge_pmd(src_vma, src_pmd, addr, false);
@@ -1931,8 +1951,10 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	}
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 out_zero_page:
-	mm_inc_nr_ptes(dst_mm);
-	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	if (pgtable) {
+		mm_inc_nr_ptes(dst_mm);
+		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+	}
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	if (!userfaultfd_wp(dst_vma))
 		pmd = pmd_clear_uffd_wp(pmd);
@@ -2364,7 +2386,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
 	} else if (is_huge_zero_pmd(orig_pmd)) {
-		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
+		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
 	} else {
@@ -2389,7 +2411,8 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		}
 
 		if (folio_test_anon(folio)) {
-			zap_deposited_table(tlb->mm, pmd);
+			if (arch_needs_pgtable_deposit())
+				zap_deposited_table(tlb->mm, pmd);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 		} else {
 			if (arch_needs_pgtable_deposit())
@@ -2490,7 +2513,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			force_flush = true;
 		VM_BUG_ON(!pmd_none(*new_pmd));
 
-		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
+		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma) &&
+		    arch_needs_pgtable_deposit()) {
 			pgtable_t pgtable;
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
@@ -2798,8 +2822,10 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
-	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
-	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
+	if (arch_needs_pgtable_deposit()) {
+		src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
+		pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
+	}
 unlock_ptls:
 	double_pt_unlock(src_ptl, dst_ptl);
 	/* unblock rmap walks */
@@ -2941,10 +2967,9 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
 static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
-		unsigned long haddr, pmd_t *pmd)
+		unsigned long haddr, pmd_t *pmd, pgtable_t pgtable)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pgtable_t pgtable;
 	pmd_t _pmd, old_pmd;
 	unsigned long addr;
 	pte_t *pte;
@@ -2960,7 +2985,16 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	 */
 	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
 
-	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	} else {
+		VM_BUG_ON(!pgtable);
+		/*
+		 * Account for the freshly allocated (in __split_huge_pmd) pgtable
+		 * being used in mm.
+		 */
+		mm_inc_nr_ptes(mm);
+	}
 	pmd_populate(mm, &_pmd, pgtable);
 
 	pte = pte_offset_map(&_pmd, haddr);
@@ -2982,12 +3016,11 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 }
 
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long haddr, bool freeze)
+		unsigned long haddr, bool freeze, pgtable_t pgtable)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
 	struct page *page;
-	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
 	bool soft_dirty, uffd_wp = false, young = false, write = false;
 	bool anon_exclusive = false, dirty = false;
@@ -3011,6 +3044,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
+		if (pgtable)
+			pte_free(mm, pgtable);
 		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
@@ -3043,7 +3078,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 * small page also write protected so it does not seems useful
 		 * to invalidate secondary mmu at this time.
 		 */
-		return __split_huge_zero_page_pmd(vma, haddr, pmd);
+		return __split_huge_zero_page_pmd(vma, haddr, pmd, pgtable);
 	}
 
 	if (pmd_is_migration_entry(*pmd)) {
@@ -3167,7 +3202,16 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Withdraw the table only after we mark the pmd entry invalid.
 	 * This's critical for some architectures (Power).
 	 */
-	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	} else {
+		VM_BUG_ON(!pgtable);
+		/*
+		 * Account for the freshly allocated (in __split_huge_pmd) pgtable
+		 * being used in mm.
+		 */
+		mm_inc_nr_ptes(mm);
+	}
 	pmd_populate(mm, &_pmd, pgtable);
 
 	pte = pte_offset_map(&_pmd, haddr);
@@ -3263,11 +3307,13 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
-			   pmd_t *pmd, bool freeze)
+			   pmd_t *pmd, bool freeze, pgtable_t pgtable)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
 	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
-		__split_huge_pmd_locked(vma, pmd, address, freeze);
+		__split_huge_pmd_locked(vma, pmd, address, freeze, pgtable);
+	else if (pgtable)
+		pte_free(vma->vm_mm, pgtable);
 }
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
@@ -3275,13 +3321,24 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 {
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
+	pgtable_t pgtable = NULL;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address & HPAGE_PMD_MASK,
 				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
+
+	/* allocate pagetable before acquiring pmd lock */
+	if (vma_is_anonymous(vma) && !arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(vma->vm_mm);
+		if (!pgtable) {
+			mmu_notifier_invalidate_range_end(&range);
+			return;
+		}
+	}
+
 	ptl = pmd_lock(vma->vm_mm, pmd);
-	split_huge_pmd_locked(vma, range.start, pmd, freeze);
+	split_huge_pmd_locked(vma, range.start, pmd, freeze, pgtable);
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
 }
@@ -3402,7 +3459,8 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 	}
 
 	folio_remove_rmap_pmd(folio, pmd_page(orig_pmd), vma);
-	zap_deposited_table(mm, pmdp);
+	if (arch_needs_pgtable_deposit())
+		zap_deposited_table(mm, pmdp);
 	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	if (vma->vm_flags & VM_LOCKED)
 		mlock_drain_local();
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa1e57fd2c469..0e976e4c975ef 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1223,7 +1223,12 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	if (arch_needs_pgtable_deposit()) {
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	} else {
+		mm_dec_nr_ptes(mm);
+		pte_free(mm, pgtable);
+	}
 	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
 	spin_unlock(pmd_ptl);
 
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 0a8b31939640f..053db74303e36 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -829,9 +829,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 
 	__folio_mark_uptodate(folio);
 
-	pgtable = pte_alloc_one(vma->vm_mm);
-	if (unlikely(!pgtable))
-		goto abort;
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(vma->vm_mm);
+		if (unlikely(!pgtable))
+			goto abort;
+	} else {
+		pgtable = NULL;
+	}
 
 	if (folio_is_device_private(folio)) {
 		swp_entry_t swp_entry;
@@ -879,10 +883,11 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	folio_get(folio);
 
 	if (flush) {
-		pte_free(vma->vm_mm, pgtable);
+		if (pgtable)
+			pte_free(vma->vm_mm, pgtable);
 		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
 		pmdp_invalidate(vma, addr, pmdp);
-	} else {
+	} else if (pgtable) {
 		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
 		mm_inc_nr_ptes(vma->vm_mm);
 	}
diff --git a/mm/rmap.c b/mm/rmap.c
index edf5d32f46042..c6ff23fc12944 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -76,6 +76,7 @@
 #include <linux/mm_inline.h>
 #include <linux/oom.h>
 
+#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
 #define CREATE_TRACE_POINTS
@@ -1978,6 +1979,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	unsigned long pfn;
 	unsigned long hsz = 0;
 	int ptes = 0;
+	pgtable_t prealloc_pte = NULL;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -2012,6 +2014,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	}
 	mmu_notifier_invalidate_range_start(&range);
 
+	if ((flags & TTU_SPLIT_HUGE_PMD) && vma_is_anonymous(vma) &&
+	    !arch_needs_pgtable_deposit())
+		prealloc_pte = pte_alloc_one(mm);
+
 	while (page_vma_mapped_walk(&pvmw)) {
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
@@ -2061,12 +2067,21 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			}
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
+				pgtable_t pgtable = prealloc_pte;
+
+				prealloc_pte = NULL;
+				if (!arch_needs_pgtable_deposit() && !pgtable &&
+				    vma_is_anonymous(vma)) {
+					page_vma_mapped_walk_done(&pvmw);
+					ret = false;
+					break;
+				}
 				/*
 				 * We temporarily have to drop the PTL and
 				 * restart so we can process the PTE-mapped THP.
 				 */
 				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, false);
+						      pvmw.pmd, false, pgtable);
 				flags &= ~TTU_SPLIT_HUGE_PMD;
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
@@ -2346,6 +2361,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		break;
 	}
 
+	if (prealloc_pte)
+		pte_free(mm, prealloc_pte);
+
 	mmu_notifier_invalidate_range_end(&range);
 
 	return ret;
@@ -2405,6 +2423,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long pfn;
 	unsigned long hsz = 0;
+	pgtable_t prealloc_pte = NULL;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -2439,6 +2458,10 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	}
 	mmu_notifier_invalidate_range_start(&range);
 
+	if ((flags & TTU_SPLIT_HUGE_PMD) && vma_is_anonymous(vma) &&
+	    !arch_needs_pgtable_deposit())
+		prealloc_pte = pte_alloc_one(mm);
+
 	while (page_vma_mapped_walk(&pvmw)) {
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
@@ -2446,8 +2469,17 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			__maybe_unused pmd_t pmdval;
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
+				pgtable_t pgtable = prealloc_pte;
+
+				prealloc_pte = NULL;
+				if (!arch_needs_pgtable_deposit() && !pgtable &&
+				    vma_is_anonymous(vma)) {
+					page_vma_mapped_walk_done(&pvmw);
+					ret = false;
+					break;
+				}
 				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, true);
+						      pvmw.pmd, true, pgtable);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
@@ -2698,6 +2730,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		folio_put(folio);
 	}
 
+	if (prealloc_pte)
+		pte_free(mm, prealloc_pte);
+
 	mmu_notifier_invalidate_range_end(&range);
 
 	return ret;
-- 
2.47.3


