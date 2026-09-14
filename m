Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39335C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCD56B00A5; Mon, 14 Sep 2026 08:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394346B00A6; Mon, 14 Sep 2026 08:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AAC26B00A7; Mon, 14 Sep 2026 08:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0345C6B00A5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 760D31203E7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:27 +0000 (UTC)
X-FDA: 85212303414.08.14F7EA3
Received: from mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6BB6440017
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="On/2qC4F";
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+wLh7Uo2d1l8gn3sY24WPKPqtbphkGZ7ajT06ObVxc=;
	b=0hVyk+Roj1WfwFDGn0Q2CfHvWAa08dsG3mJMtfrgkWomcmW5dhn0wncezrFKyt3doJ9Lzc
	fzyfk/4jFm9XOB/vVdXgXk4UJSErM6zjLclRO0hFdMgaEwRSmrZvuNznzpAbObwuP5Rz8v
	jlxUmj+UVWhNKP6dfyRDb3cJ66ZYKns=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389085;
	b=cCTMz6ba1fcg96O1l2bboA/EoRahewLYBqT3lH+ZFBowQavSJi6e6VyevSLVlsopdjGVHZ
	0wECWd7fA0g/gOkLys2k8jJKwsG2J6yIGZVpWnBw9UtBMowWkZ0niFqhSD4qB5jtuZbA8S
	YaIcFYWCNi0VpBkZiMzb3WKNbkrvvgM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="On/2qC4F";
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3XNEzeVU1O8SWrgui6NV2H1NKonCjPLxXmf/sJyhnNo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389084; v=1; x=1789993884;
 b=On/2qC4FRxiKg8BKss9FvrqxQfRXdEZVS+/Yd2Y8ReSiHpF5mbnzY43jFaDf7VlbtDspCMoq
 MJkZgU23BsVbPL+LgwpfcwJifc2DwirapYwEUf0UbdjcV21p7XBhrp/plSXIwjx3F+fyvGYRQ4y
 O/HXT3+7tXl0dcK2Fwl71B18=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 178b94f0694f8731;
	Mon, 14 Sep 2026 12:31:23 +0000
X-Mizu-Trace-ID: 178b94f0694f8731
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
Subject: [RESEND v7 10/29] mm: make PMD migration-entry splitting explicit
Date: Mon, 14 Sep 2026 05:28:00 -0700
Message-ID: <20260914122950.3283997-11-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: mfpao3935f3ot4ub3is6hkmsqc1sjptd
X-Rspamd-Queue-Id: 6BB6440017
X-HE-Tag: 1789389085-924855
X-HE-Meta: U2FsdGVkX1/DEZqCVrKFkvx2arwTNzsswQaH7z1DlBu1UbznHeUZHfo+s90ygXU6jcQxbC2Y6unF75XV9sEjWyqjPQe6MUCCQk8TGXZEffHeNLHE9SHoxkpguHhZFVXOesGmrG7XQYyhZ+IxtVBAwKUEBiPogOsJEysx8WIOigwWaWCUMM1MJRy3fpUl1iv8jt70/pxM/48rD6DIFaQ20LXUrLFcUAJ48dSKvhux4Y43b9AlKzL8D1sb6qnmelWyszbobZy5RLlpl2AA8FXGRJRLp1D/FIZc4ZLcUVWg8+YTaJmSaibc6iD1TOkhJHxiqBaxETXIkCvejBUHG9VfiC1rIU+vfAp3eoJPAZNUEoJCTXLxk+wk8Zoi2frgH6WZse53jBOSEGmehPvLtMOMf7kr0zLRz2OHLlKkZGY5lGN3R+0eCEUyM0xSOgrKvzhtWy4x3tFARJxmzqBypPP8cO351uSDglt787lV0ru9/BraCfaSGoUHRiXBbbPJ5kX1CMmUNiXsWW0svCV1bdqhKumYCzjtSnnsrIXdD6SOAV2IwFsUJmy7digSIOgwdxnd4ZOk1hyWosxIZC92AEGTDFkAOb2pMFx5nnYmMgtmdoJHp1Yw8mkmY0tkWwcW2lyRmbv9g1BlXcM3XV6aKda/QWTK8hN1FUu3hDWdjrbaGMaVt0AlSY2zpibbfq37fd3L/E/zCsgmgnmOUGU0QVLmFCD7KPfN78ye14WzEzMhIw4TGrpAjYkljvtKeuGvUwPY4VXhsxJp64xxgfX8w2imBF3ybE9Ln2LOYKYqqmZ1P4+oyYRilZvopniG/6maJ09SMKYWY39pbuR6Ntb3bsb9EKkYgyzYDNsQoPp47pgoRD2r6pNoGxNzmhNpaKdK6joUqlK6jMZas3J89KzFkfyfJOxVHhTPCFf+vpTUDVoNiwatlF/jwhaTnAdVB2xrEcgh2R8thOd9zSHWrlfTCq5
 lZ7T9uj6
 be/bI9+MDXXOQns8BCiVbDDS976QM3fcMGhT7t/LplyxTTP4EAaiVZUqIWVYojAEASd7nSNS/W4eIN+pPIHURT3kguK1Yyr1c3zADhd3k3nafvN15rsK0PlcMn64qCLAJrJ/Uq/o0p7u4kzzSsB/SPSSADiN2ITE5OjxP6t+2c+ZKB+TM8wfTFaotP819iWwKqMNkGnzqJH9GOocvzd1bg+SdpbXL29bXXv+91RpyW6cOVc8SyhuokxMYJRRfiP//7RZD
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

Rename it to use_migration_entries, keep it private to mm/huge_memory.c,
and add split_pmd_to_migration_entries() for try_to_migrate_one(), the only
caller that wants it.

migrate_vma_split_unmapped_folio() also passed freeze=true, but only ever
runs on a PMD that is already a migration entry, which the generic helper
expands into PTE migration entries either way. Its folio_get() only existed
to balance the put_page() that freeze=true performs, so both go.

No functional change intended.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h | 22 ++++++++-------
 mm/huge_memory.c        | 60 ++++++++++++++++++++++++-----------------
 mm/memory.c             |  4 +--
 mm/migrate_device.c     |  7 +----
 mm/mprotect.c           |  2 +-
 mm/rmap.c               |  7 +++--
 6 files changed, 55 insertions(+), 47 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8ca0fa3be2acb..64b6a2eea899d 100644
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
+			   pmd_t *pmd);
+void split_pmd_to_migration_entries(struct vm_area_struct *vma,
+				    unsigned long address, pmd_t *pmd);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
 void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
@@ -690,12 +690,14 @@ static inline void deferred_split_folio(struct folio *folio, bool partially_mapp
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
+					 unsigned long address, pmd_t *pmd) {}
+static inline void
+split_pmd_to_migration_entries(struct vm_area_struct *vma,
+			       unsigned long address, pmd_t *pmd) {}
 
 static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 					 unsigned long addr, pmd_t *pmdp,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ee8d46827ffdc..873887aed0bc2 100644
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
+		unsigned long haddr, bool use_migration_entries)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
@@ -3291,10 +3291,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 * folios w.r.t anon exclusive handling. See the comments for
 		 * folio handling and anon_exclusive below.
 		 */
-		if (freeze && anon_exclusive &&
+		if (use_migration_entries && anon_exclusive &&
 		    folio_try_share_anon_rmap_pmd(folio, page))
-			freeze = false;
-		if (!freeze) {
+			use_migration_entries = false;
+		if (!use_migration_entries) {
 			rmap_t rmap_flags = RMAP_NONE;
 
 			folio_ref_add(folio, HPAGE_PMD_NR - 1);
@@ -3344,11 +3344,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
 		/*
-		 * Without "freeze", we'll simply split the PMD, propagating the
-		 * PageAnonExclusive() flag for each PTE by setting it for
+		 * Without migration entries, we'll simply split the PMD and
+		 * propagate the PageAnonExclusive() flag for each PTE by setting it for
 		 * each subpage -- no need to (temporarily) clear.
 		 *
-		 * With "freeze" we want to replace mapped pages by
+		 * With migration entries we want to replace mapped pages by
 		 * migration entries right away. This is only possible if we
 		 * managed to clear PageAnonExclusive() -- see
 		 * set_pmd_migration_entry().
@@ -3359,10 +3359,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 * See folio_try_share_anon_rmap_pmd(): invalidate PMD first.
 		 */
 		anon_exclusive = PageAnonExclusive(page);
-		if (freeze && anon_exclusive &&
+		if (use_migration_entries && anon_exclusive &&
 		    folio_try_share_anon_rmap_pmd(folio, page))
-			freeze = false;
-		if (!freeze) {
+			use_migration_entries = false;
+		if (!use_migration_entries) {
 			rmap_t rmap_flags = RMAP_NONE;
 
 			folio_ref_add(folio, HPAGE_PMD_NR - 1);
@@ -3387,7 +3387,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (freeze || pmd_is_migration_entry(old_pmd)) {
+	if (use_migration_entries || pmd_is_migration_entry(old_pmd)) {
 		pte_t entry;
 		swp_entry_t swp_entry;
 
@@ -3420,8 +3420,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
 			/*
 			 * anon_exclusive was already propagated to the relevant
-			 * pages corresponding to the pte entries when freeze
-			 * is false.
+			 * pages corresponding to the pte entries when
+			 * use_migration_entries is false.
 			 */
 			if (write)
 				swp_entry = make_writable_device_private_entry(
@@ -3469,7 +3469,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 	if (!pmd_is_migration_entry(*pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
-	if (freeze)
+	if (use_migration_entries)
 		put_page(page);
 
 	smp_wmb(); /* make pte visible before pmd */
@@ -3477,15 +3477,28 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 }
 
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
-			   pmd_t *pmd, bool freeze)
+			   pmd_t *pmd)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
 	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
-		__split_huge_pmd_locked(vma, pmd, address, freeze);
+		__split_huge_pmd_locked(vma, pmd, address, false);
+}
+
+/*
+ * Split a present PMD into PTE migration entries, for the rmap migration
+ * walker.  Like split_huge_pmd_locked(), the caller must hold the PMD lock and
+ * must already be inside an mmu_notifier invalidate range.
+ */
+void split_pmd_to_migration_entries(struct vm_area_struct *vma,
+				    unsigned long address, pmd_t *pmd)
+{
+	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
+	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
+		__split_huge_pmd_locked(vma, pmd, address, true);
 }
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long address, bool freeze)
+		unsigned long address)
 {
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
@@ -3495,20 +3508,19 @@ void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
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
@@ -3520,7 +3532,7 @@ static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned
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
index 5332c52909be1..feb751e29b992 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2290,7 +2290,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				 * restart so we can process the PTE-mapped THP.
 				 */
 				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, false);
+						      pvmw.pmd);
 				flags &= ~TTU_SPLIT_HUGE_PMD;
 				page_vma_mapped_walk_restart(&pvmw);
 				continue;
@@ -2515,13 +2515,12 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 
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


