Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F179CCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC30B6B00A6; Fri,  2 Oct 2026 05:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4B7A6B00A9; Fri,  2 Oct 2026 05:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5796B00AA; Fri,  2 Oct 2026 05:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EDAE6B00A6
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2356C1C37C1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:29 +0000 (UTC)
X-FDA: 85277231298.28.B8F096A
Received: from mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id 231A080008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GujSCMly;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFygK3L3N6n1aJSae6YirU87IOC1ESh/NsRNxGdi2Ss=;
	b=MuLaupqYg09FIQHmblXv4MqSErUF3EDl4x3Lyr3YaIWbWWx3YCqKtieY2LJ/BguARmttdN
	+QoAoSne6mHUj+nUfRndwjx/d1GvJjfQ3/4lDnObDiIDum+3OMgLa2s1JsnjcG2glbwmnG
	imfXbZ4gtmJjOEjvFeoto2qE9aecQq0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GujSCMly;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934987;
	b=Fl64qlUTH3wZY/PTJKi3ty923PFIhAbTihgCD4LYIEeRtXHP35DMAfsIguF8iFnbdjhv+V
	77rPNlgwBWvelcyUPJf4avRz1c1axx7X5fXPbGEcwkLhC3Di6/LHkrj+zK7NsXrgAGhewe
	2i09rnRNbubwWvhUmen7qLiENwaq7JM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RdJTYr6OKJbLWLNbx2o8CV3+A/Nml1b19Dh5ux2PFP0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934986; v=1; x=1791539786;
 b=GujSCMlyoLHXlIOPMhpkqqLm2+CTlX/+YbGwUh2qv/O/Dd5jICCSOhiPlgVfrKqB9UMqlzrE
 Y8f8NMWS4eEfor+gGyDL3/t6/sp317DEo9zT49Ni+5STreN6dvtvWcoP5fjqMzaomBSBkfK9Aam
 j+doKELlZ4II81gGT1ZOrbpI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 048a65e94bd5d350;
	Fri, 02 Oct 2026 09:56:25 +0000
X-Mizu-Trace-ID: 048a65e94bd5d350
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 10/30] mm: make PMD migration-entry splitting explicit
Date: Fri,  2 Oct 2026 02:52:24 -0700
Message-ID: <20261002095503.3585565-11-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: p445rutj89u4j4z1hsp1jx54qgxyja3m
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 231A080008
X-HE-Tag: 1790934986-863267
X-HE-Meta: U2FsdGVkX18RAeGwObBPRVdIuXuJ9Pm9H/Y+en8hJZfArAQUC+VCCq9aBNAI7E2CJfLWDKhLM8An7PM6B+wqzx7/ABDjxhg9B4Q9+eiPxGEdNblkj5KcyzTvzdw88REMmZbz+I8fCT+Rf5SBOBnxxKy54oGX9XRJVc9TwZiHGtZeNk2Kjw1HrZ+uRSueJiuSKAN0IkPU93iJFyEwSpaTSAhaiRgOb/vFflUui+CfhTgN/Zxbxjag84YDP5N9eItZlPd8Zug4qChZHtTkACegDNUh0gdTFOdHJFHpKsbsxPEmbgHR5zeBb+4wP17rIZDI6fDFL+DEZyZB9Gf7zokoUgpPuKEgjVkrfTP0VTeORjBNP5AplFuejOGCfO1Uya3SZ4pFZGfJHVPoVqJDlDfq562+gaEAmXXuKMn2ok50+Z29ayG5d40ISLd3/Xjq1AShevL5LLHHTL3PrOvSoe1fZ20K3icXmL9XsCCF02Lg2iYzrEMxx+B5SITmJGh84B8aR5xtNzRSVhxts+rSArddhcH/EzTOt4Hwzu4ts+CAif9mmFKIQ2rgzYCX3NQ6UUqYfj9E/1PcByLrBa5ANjobNIoARN1qBciuyrg7tl1wSlRFjxBXEEB/UUiGWH2Hx9SVYoHoNDJnjSlSIPRrCgwpMPz0ot2AUmaONZjbS4i+WNml9gXLuPNTGNeC2vVCPO/1brYNhh8jkUm/Fmp2WRaREuSsd9B60nnTD9W0X6qtYeUIBd0RyHbgjcKax24zNBTAn1qT8wYygrcK2ktn5VPU+AxtBqwF9RSIaCXPXr+s/qClpMQs4lnKlR0JbcCyvUHbNojdGMQ6h4riOJjof8ikaThHYVVvp5vGgZpVZx3RvysnRKytI53yEz/CpL8b21NxnB3yxpmIga+EZ81DQPfLvPejVNtDsKZGSpt8osEgJJJ82MhEo5sFafdQYFmO9PxbcaFGIDx2uKi7hEKmI+l
 hsDpqL4g
 TrByjoL/IBYTgL9WSLKAEVfCSOq40YtOgThC/63RoyoCK0ekUT7gG9BS7FshzgCusJzW0LSTjs0aPmf6xE2s4ki9rSSwCVfWCRSTS7X8ZAzPaB3JP9HVns601dDMw1jhaNKOS0BlQcfRDqcXyo1xFgUppsxFENiV3ALNqF75/IUpYBbo2kYrpncSG8JNqFeVcSuCsmt16KHJ3X4za41eb6pvSEoFKPVHavi5Z2bKhDG401r8zsourmKWX98z5s4SbQiLX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__split_huge_pmd() and friends take a "freeze" boolean that every caller
has to pass and almost every caller passes as false. The name says nothing
about what it selects, and the one thing it does select - PTE migration
entries instead of PTE mappings - is only ever wanted by the rmap migration
path.

Rename it to to_migration_entries, keep it private to mm/huge_memory.c,
and add split_pmd_to_migration_entries() for try_to_migrate_one(), the only
caller that wants it.

migrate_vma_split_unmapped_folio() also passed freeze=true, but only ever
runs on a PMD that is already a migration entry, which the generic helper
expands into PTE migration entries either way. Its folio_get() only existed
to balance the put_page() that freeze=true performs, so both go.

split_pmd_to_migration_entries() is only ever handed a present or
device-private PMD, so assert that in __split_huge_pmd_locked() instead of
silently skipping anything else.

Other than that assertion, no functional change intended.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/huge_mm.h | 21 ++++++------
 mm/huge_memory.c        | 74 ++++++++++++++++++++++++++---------------
 mm/memory.c             |  4 +--
 mm/migrate_device.c     |  7 +---
 mm/mprotect.c           |  2 +-
 mm/rmap.c               |  8 ++---
 6 files changed, 65 insertions(+), 51 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8ca0fa3be2acb..8205e83f27771 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -430,7 +430,7 @@ int folio_memcg_alloc_deferred(struct folio *folio);
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long address, bool freeze);
+		unsigned long address);
 
 /**
  * pmd_is_huge() - Is this PMD either a huge PMD entry or a software leaf entry?
@@ -462,12 +462,10 @@ static inline bool pmd_is_huge(pmd_t pmd)
 	do {								\
 		pmd_t *____pmd = (__pmd);				\
 		if (pmd_is_huge(*____pmd))				\
-			__split_huge_pmd(__vma, __pmd, __address,	\
-					 false);			\
+			__split_huge_pmd(__vma, __pmd, __address);	\
 	}  while (0)
 
-void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
-		bool freeze);
+void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address);
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long address);
@@ -590,7 +588,9 @@ static inline bool thp_migration_supported(void)
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
-			   pmd_t *pmd, bool freeze);
+		pmd_t *pmd);
+void split_pmd_to_migration_entries(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmd);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
 void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
@@ -690,12 +690,13 @@ static inline void deferred_split_folio(struct folio *folio, bool partially_mapp
 	do { } while (0)
 
 static inline void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long address, bool freeze) {}
+		unsigned long address) {}
 static inline void split_huge_pmd_address(struct vm_area_struct *vma,
-		unsigned long address, bool freeze) {}
+		unsigned long address) {}
 static inline void split_huge_pmd_locked(struct vm_area_struct *vma,
-					 unsigned long address, pmd_t *pmd,
-					 bool freeze) {}
+		unsigned long address, pmd_t *pmd) {}
+static inline void split_pmd_to_migration_entries(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmd) {}
 
 static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 					 unsigned long addr, pmd_t *pmdp,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ee8d46827ffdc..1df4f619620b4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2033,7 +2033,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
-		__split_huge_pmd(src_vma, src_pmd, addr, false);
+		__split_huge_pmd(src_vma, src_pmd, addr);
 		return -EAGAIN;
 	}
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
@@ -2257,7 +2257,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 	folio_unlock(folio);
 	spin_unlock(vmf->ptl);
 fallback:
-	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
+	__split_huge_pmd(vma, vmf->pmd, vmf->address);
 	return VM_FAULT_FALLBACK;
 }
 
@@ -3190,7 +3190,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 }
 
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long haddr, bool freeze)
+		unsigned long haddr, bool to_migration_entries)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
@@ -3208,6 +3208,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
 
 	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(*pmd) && !pmd_trans_huge(*pmd));
+	VM_WARN_ON_ONCE(to_migration_entries && !pmd_present(*pmd) &&
+			!pmd_is_device_private_entry(*pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -3291,10 +3293,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 * folios w.r.t anon exclusive handling. See the comments for
 		 * folio handling and anon_exclusive below.
 		 */
-		if (freeze && anon_exclusive &&
+		if (to_migration_entries && anon_exclusive &&
 		    folio_try_share_anon_rmap_pmd(folio, page))
-			freeze = false;
-		if (!freeze) {
+			to_migration_entries = false;
+		if (!to_migration_entries) {
 			rmap_t rmap_flags = RMAP_NONE;
 
 			folio_ref_add(folio, HPAGE_PMD_NR - 1);
@@ -3344,13 +3346,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
 		/*
-		 * Without "freeze", we'll simply split the PMD, propagating the
-		 * PageAnonExclusive() flag for each PTE by setting it for
-		 * each subpage -- no need to (temporarily) clear.
+		 * When not splitting to migration entries, we'll simply split
+		 * the PMD and propagate the PageAnonExclusive() flag for each
+		 * PTE by setting it for each page -- no need to (temporarily)
+		 * clear.
 		 *
-		 * With "freeze" we want to replace mapped pages by
-		 * migration entries right away. This is only possible if we
-		 * managed to clear PageAnonExclusive() -- see
+		 * When splitting to migration entries, we want to replace
+		 * mapped pages by migration entries right away. This is only
+		 * possible if we managed to clear PageAnonExclusive() -- see
 		 * set_pmd_migration_entry().
 		 *
 		 * In case we cannot clear PageAnonExclusive(), split the PMD
@@ -3359,10 +3362,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 * See folio_try_share_anon_rmap_pmd(): invalidate PMD first.
 		 */
 		anon_exclusive = PageAnonExclusive(page);
-		if (freeze && anon_exclusive &&
+		if (to_migration_entries && anon_exclusive &&
 		    folio_try_share_anon_rmap_pmd(folio, page))
-			freeze = false;
-		if (!freeze) {
+			to_migration_entries = false;
+		if (!to_migration_entries) {
 			rmap_t rmap_flags = RMAP_NONE;
 
 			folio_ref_add(folio, HPAGE_PMD_NR - 1);
@@ -3387,7 +3390,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (freeze || pmd_is_migration_entry(old_pmd)) {
+	if (to_migration_entries || pmd_is_migration_entry(old_pmd)) {
 		pte_t entry;
 		swp_entry_t swp_entry;
 
@@ -3420,8 +3423,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
 			/*
 			 * anon_exclusive was already propagated to the relevant
-			 * pages corresponding to the pte entries when freeze
-			 * is false.
+			 * pages corresponding to the pte entries when
+			 * to_migration_entries is false.
 			 */
 			if (write)
 				swp_entry = make_writable_device_private_entry(
@@ -3469,7 +3472,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 	if (!pmd_is_migration_entry(*pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
-	if (freeze)
+	if (to_migration_entries)
 		put_page(page);
 
 	smp_wmb(); /* make pte visible before pmd */
@@ -3477,15 +3480,33 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
-			   pmd_t *pmd, bool freeze)
+		pmd_t *pmd)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
 	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
-		__split_huge_pmd_locked(vma, pmd, address, freeze);
+		__split_huge_pmd_locked(vma, pmd, address, false);
+}
+
+/**
+ * split_pmd_to_migration_entries() - Split a present or device private PMD into
+ * PTE migration entries.
+ * @vma: The VMA containing the PMD.
+ * @address: The PMD-aligned address the PMD maps.
+ * @pmd: A pointer to the leaf PMD entry.
+ *
+ * For the rmap migration walker, which only ever hands back those two entry
+ * types.  Like split_huge_pmd_locked(), the caller must hold the PMD lock and
+ * must already be inside an mmu_notifier invalidate range.
+ */
+void split_pmd_to_migration_entries(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmd)
+{
+	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
+	__split_huge_pmd_locked(vma, pmd, address, true);
 }
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long address, bool freeze)
+		unsigned long address)
 {
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
@@ -3495,20 +3516,19 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 				(address & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 	ptl = pmd_lock(vma->vm_mm, pmd);
-	split_huge_pmd_locked(vma, range.start, pmd, freeze);
+	split_huge_pmd_locked(vma, range.start, pmd);
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
 }
 
-void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
-		bool freeze)
+void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address)
 {
 	pmd_t *pmd = mm_find_pmd(vma->vm_mm, address);
 
 	if (!pmd)
 		return;
 
-	__split_huge_pmd(vma, pmd, address, freeze);
+	__split_huge_pmd(vma, pmd, address);
 }
 
 static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
@@ -3520,7 +3540,7 @@ static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned
 	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
 	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
 			 ALIGN(address, HPAGE_PMD_SIZE)))
-		split_huge_pmd_address(vma, address, false);
+		split_huge_pmd_address(vma, address);
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index 926276d419202..477d7e359b447 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2096,7 +2096,7 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 		next = pmd_addr_end(addr, end);
 		if (pmd_is_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
-				__split_huge_pmd(vma, pmd, addr, false);
+				__split_huge_pmd(vma, pmd, addr);
 			else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
 				addr = next;
 				continue;
@@ -6382,7 +6382,7 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 
 split:
 	/* COW or write-notify handled on pte level: split pmd. */
-	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
+	__split_huge_pmd(vma, vmf->pmd, vmf->address);
 
 	return VM_FAULT_FALLBACK;
 }
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 0c437004329d9..4a0b61d50d222 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -918,12 +918,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	unsigned long flags;
 	int ret = 0;
 
-	/*
-	 * take a reference, since split_huge_pmd_address() with freeze = true
-	 * drops a reference at the end.
-	 */
-	folio_get(folio);
-	split_huge_pmd_address(migrate->vma, addr, true);
+	split_huge_pmd_address(migrate->vma, addr);
 	ret = folio_split_unmapped(folio, 0);
 	if (ret)
 		return ret;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d872..ee33bbb421008 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -530,7 +530,7 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 		if (pmd_is_huge(_pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
 			    pgtable_split_needed(vma, cp_flags)) {
-				__split_huge_pmd(vma, pmd, addr, false);
+				__split_huge_pmd(vma, pmd, addr);
 				/*
 				 * For file-backed, the pmd could have been
 				 * cleared; make sure pmd populated if
diff --git a/mm/rmap.c b/mm/rmap.c
index 5332c52909be1..b762eb85915ea 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2289,8 +2289,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				 * We temporarily have to drop the PTL and
 				 * restart so we can process the PTE-mapped THP.
 				 */
-				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, false);
+				split_huge_pmd_locked(vma, pvmw.address, pvmw.pmd);
 				flags &= ~TTU_SPLIT_HUGE_PMD;
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
@@ -2515,13 +2514,12 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
-				 * split_huge_pmd_locked() might leave the
+				 * split_pmd_to_migration_entries() might leave the
 				 * folio mapped through PTEs. Retry the walk
 				 * so we can detect this scenario and properly
 				 * abort the walk.
 				 */
-				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, true);
+				split_pmd_to_migration_entries(vma, pvmw.address, pvmw.pmd);
 				flags &= ~TTU_SPLIT_HUGE_PMD;
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
-- 
2.53.0-Meta


