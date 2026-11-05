Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA13606A335
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q1+1ya2D
Received: by kanga.kvack.org (Postfix)
	id 2C5116B05C6; Thu,  5 Nov 2026 13:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C306B05C7; Thu,  5 Nov 2026 13:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0556B05C8; Thu,  5 Nov 2026 13:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D21166B05C6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5960080BC8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:07 +0000 (UTC)
X-FDA: 85401932574.16.B7BDDB8
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6471D18000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q1+1ya2D;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZjI7KWNJ54cabdi0ZP5V04L0+LspguNONHqe73wuXBs=;
	b=s0w9Ia/w4954czMQjz5Pn+SmidDI66G6ZHZcz+iJPjdF9RZjqDGJ8HW8NxTzDWIPsVTgZx
	1oi/YnWKoPq7ZGbgUc8Buo0+ELzWtms0riKMFXwHvGVxFWTOtXkedQb1jH2YTTwt7cTMph
	Vp4GXFo89+dqOOn2lzawuTUPsqYZeso=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q1+1ya2D;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904065;
	b=4JZiyG///x1dX8nOaCBQDCA/OoPh5rLqV20NSfs5hTScgKgZLpMRLpwehBYvCA+IL1xY7k
	aXN/NULyHlmxrb4JFQoDwSc7Vw/DxMmjL3LHvAfgGwDy4qJQPFStNp0BzQYQeSbzEtqeia
	j//YBv9+lmE7KqctoJzZ/Qe6lxh4vAU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=722XgLzDCs2QKSSlSsiQWGB561wiO3WhGCQ/qnB0OO4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904064; v=1; x=1794508864;
 b=q1+1ya2DGGGneEzptSs2mpp4eOFK5vtoT0jCGx/7hND/4i66/4ET3s8OKT4BTy6Y7n/hHpl2
 83uCHnVkNUd/Smee+e4nJeCKdhR62eGsD8oyO/eOYzYZbZydZhS+As9L1edEkNw2D0QZjmUaDvP
 cDNbpbGQkgzwdwJPFcd9uiYY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f66312ce63d0c71f;
	Thu, 05 Nov 2026 18:41:04 +0000
X-Mizu-Trace-ID: f66312ce63d0c71f
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 11/32] mm: make PMD migration-entry splitting explicit
Date: Thu,  5 Nov 2026 10:38:55 -0800
Message-ID: <20261105183940.2236717-12-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6471D18000B
X-Stat-Signature: e5ckhydi9dysmprf8547ycppmw1z33n7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793904065-768972
X-HE-Meta: U2FsdGVkX1995Ld/2w/YB1Wcg6H/qdOevTBHCuZqTJo3b17ySw0MZTH7WWu+x7AL0lhX0wBP/iDL+pGPeTE1Iyt6flsf5RbT+6ypVcbElS5nM9iHVpjO+H9PG3GG4o1i7fy6uAeujmKXsyShsMa/HtO/YX8zkbNL+Z3gajkP8jJ0+nqGVA7L5LjvLi1Fb1/VOXQpmWaZvdH1C+opRtTfyK6fPcDb7m0EfWLY0XSKe0exM8nx0t+BEmnkjb6F/niy+SoRqNMmFIxSU4lyr/yRuSFfOBrmgfYTpic+RN13SVHpaIbtr3cMemiXFiQNo6a2iyvgh8Fm/Q8FLQdkmGADbAhEn37mO0T4TK1emO4ukZ7xlWlHoribY5I44Rj09e0CKxfr5GvrKqbIKA5m/lb8IpJ6Je+wbrb5SwIZu23SkN7ETv7qrWvec05JirFU23/6i8+y8fL36sRiMnz+SbL/wuU4bkFPGWnUQ4GZaKF27GhsWlqknNO8OT3URm3fLXX8Z4bFVjADVYeF7ZSvMBZroqoHdCsJiiZyupmGznz5ItD1K1adsev3M4ca9Rr9AxLRqWepRt4syw0y529XgLK/DjOHsjq8t53kdo6b8GVibM0yWv7fGbpfgyfYVuUgm6uEKBgPe7RXAnv79kacqhllxAbdt/PznH8dg+eaSStFkjLZHFiDvtBZtbQR47iDXtzuAYgbNXXzaqL2NK0xwfX/rln8Tff9l2inqZ57hrKqIww97LEyMQMZI6hgA0cBb7zubaJX+7eJsSD3W5ZYd18Wx25UT4z1f4c6hOs+dIKgUmyidV631wFTCwLh9rIXd82bzC9ZEg3FPm/ws3sHpXRdhqALaYPWWHXQ6xtNDbdPibzX8C4v0Ms6fuTCqyt9q4O1oLOl5szZyJpSiPDFRL9OprLxUUbyvebdAqi8T+x53YZfPmQ+itUqI3IL3XNDxqlJMdGnEsterKTFiJgnjHh
 MAvV+zxR
 7Sn/VP+9AehMSoo8L1WKkJn2358y/Jt2JAfuYwdsSHNoiQ4/b53ywbZo1xC62zgpk8IZsc5Hs+SpFQ4NI7Z8OrSBhJngkAGqDpPPjsmI3CXxH+rLaOBCa+f4Mn7FERKOF003icEqEXnPhLwLPhQHY5oFPb6nYs/sANq2/UHnpFuvqiApbxm5zPG09I+tokJd98mtu2EF+n9ahRfOX4t19wfx0oTWZys+58e1H0sDOD70NHYkATmNv8lOdQkpxDwum08lB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__split_huge_pmd() and friends take a "freeze" boolean that every caller
has to pass and almost every caller passes as false. The name says nothing
about what it selects, and the one thing it does select - PTE migration
entries instead of PTE mappings - is only ever wanted by the rmap migration
path.

Rename it to to_migration_entries, keep it private to mm/huge_memory.c,
and add split_pmd_to_migration_entries() for try_to_migrate_one(), the only
caller that wants it.

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
 mm/migrate_device.c     |  2 +-
 mm/mprotect.c           |  2 +-
 mm/rmap.c               |  8 ++---
 6 files changed, 65 insertions(+), 46 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 421217aca4ed8..34307bda8071b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -431,7 +431,7 @@ int folio_memcg_alloc_deferred(struct folio *folio);
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long address, bool freeze);
+		unsigned long address);
 
 /**
  * pmd_is_huge() - Is this PMD either a huge PMD entry or a software leaf entry?
@@ -463,12 +463,10 @@ static inline bool pmd_is_huge(pmd_t pmd)
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
@@ -593,7 +591,9 @@ static inline bool thp_migration_supported(void)
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
-			   pmd_t *pmd, bool freeze);
+		pmd_t *pmd);
+void split_pmd_to_migration_entries(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmd);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
 void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
@@ -693,12 +693,13 @@ static inline void deferred_split_folio(struct folio *folio, bool partially_mapp
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
index e425a5b05aa2e..82a4fa9342672 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2031,7 +2031,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
-		__split_huge_pmd(src_vma, src_pmd, addr, false);
+		__split_huge_pmd(src_vma, src_pmd, addr);
 		return -EAGAIN;
 	}
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
@@ -2255,7 +2255,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 	folio_unlock(folio);
 	spin_unlock(vmf->ptl);
 fallback:
-	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
+	__split_huge_pmd(vma, vmf->pmd, vmf->address);
 	return VM_FAULT_FALLBACK;
 }
 
@@ -3176,7 +3176,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 }
 
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long haddr, bool freeze)
+		unsigned long haddr, bool to_migration_entries)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
@@ -3194,6 +3194,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
 
 	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(*pmd) && !pmd_trans_huge(*pmd));
+	VM_WARN_ON_ONCE(to_migration_entries && !pmd_present(*pmd) &&
+			!pmd_is_device_private_entry(*pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -3277,10 +3279,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
@@ -3330,13 +3332,14 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
@@ -3345,10 +3348,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
@@ -3373,7 +3376,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (freeze || pmd_is_migration_entry(old_pmd)) {
+	if (to_migration_entries || pmd_is_migration_entry(old_pmd)) {
 		pte_t entry;
 		swp_entry_t swp_entry;
 
@@ -3406,8 +3409,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
@@ -3455,7 +3458,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 	if (!pmd_is_migration_entry(*pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
-	if (freeze)
+	if (to_migration_entries)
 		put_page(page);
 
 	smp_wmb(); /* make pte visible before pmd */
@@ -3463,15 +3466,33 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
@@ -3481,20 +3502,19 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
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
@@ -3506,7 +3526,7 @@ static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned
 	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
 	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
 			 ALIGN(address, HPAGE_PMD_SIZE)))
-		split_huge_pmd_address(vma, address, false);
+		split_huge_pmd_address(vma, address);
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index 6fe0b7dab927c..85bd1b08a1a2a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2099,7 +2099,7 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 		next = pmd_addr_end(addr, end);
 		if (pmd_is_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
-				__split_huge_pmd(vma, pmd, addr, false);
+				__split_huge_pmd(vma, pmd, addr);
 			else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
 				addr = next;
 				continue;
@@ -6491,7 +6491,7 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 
 split:
 	/* COW or write-notify handled on pte level: split pmd. */
-	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
+	__split_huge_pmd(vma, vmf->pmd, vmf->address);
 
 	return VM_FAULT_FALLBACK;
 }
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 3286bb8a4b73e..1096319aa8166 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -920,7 +920,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	unsigned long flags;
 	int ret = 0;
 
-	split_huge_pmd_address(migrate->vma, addr, false);
+	split_huge_pmd_address(migrate->vma, addr);
 	ret = folio_split_unmapped(folio, 0);
 	if (ret)
 		return ret;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index e18d4e12fc341..e0e28bbddbadd 100644
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
index 1131b76bbbc28..9d6353e98e7c7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2280,8 +2280,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				 * We temporarily have to drop the PTL and
 				 * restart so we can process the PTE-mapped THP.
 				 */
-				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, false);
+				split_huge_pmd_locked(vma, pvmw.address, pvmw.pmd);
 				flags &= ~TTU_SPLIT_HUGE_PMD;
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
@@ -2506,13 +2505,12 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 
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


