Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E463C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932AD6B00A6; Mon, 14 Sep 2026 07:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B126B00A7; Mon, 14 Sep 2026 07:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD226B00A9; Mon, 14 Sep 2026 07:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8D56B00A6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:44:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C203E1C20F0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:44:14 +0000 (UTC)
X-FDA: 85212184428.16.05D6A92
Received: from mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
	by imf27.hostedemail.com (Postfix) with ESMTP id D44DD40006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:44:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fhoa6ZtX;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+wLh7Uo2d1l8gn3sY24WPKPqtbphkGZ7ajT06ObVxc=;
	b=wd3XflAT9cAByF3YzNqFdM2rLiP20hTPW60ScxU0wD60u92dOIiOWHJ0iJk4Y8VeIbiZ+q
	q4GTc5w3RB7nz9g2mD7N/S1CfkilUdqKZUiy4mqEByqB+PZKLHn8WOiCESN4DTO4HPcxnI
	ONqDwTRmR7nANM0W09uNLaJttPl+8Y8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386253;
	b=WvZwRF95olhdvjYVo++n2i0DSBsgJTjZLR5dVz3N+WwfaNJnpRQ+zm1xuDxaCMZUeWFt/f
	aPz8aXD9GeZgCBR/DQ1xKW/YhSM2BH286nKODZPrJ47zSfLTUAYVzPP2Y4k6L7qzA4grjc
	ApxtJJsC8TnlpeyyZEF8ubTgNZVAIHc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fhoa6ZtX;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3XNEzeVU1O8SWrgui6NV2H1NKonCjPLxXmf/sJyhnNo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789386251; v=1; x=1789991051;
 b=fhoa6ZtXOauQMJgnFoXqVJ0U7Maq+6jnRpScN7TqyW8epwl29fE3cqpav4sJIlpaCQ3x/xuh
 0KpTJmykCC4RhnYev8sO2Bf3FtxBPAEhCh/UqUfcyl5/YXUUgYLp0uDmTni1z7rtD6cJVqhiHXm
 C5c6hRkB5tt4RH73ews4gdzc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 1460ad6acf0457ca;
	Mon, 14 Sep 2026 11:44:11 +0000
X-Mizu-Trace-ID: 1460ad6acf0457ca
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
Subject: [PATCH v7 10/29] mm: make PMD migration-entry splitting explicit
Date: Mon, 14 Sep 2026 04:42:02 -0700
Message-ID: <20260914114320.12988-11-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: <20260914114320.12988-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D44DD40006
X-Stat-Signature: zorwz913p6q5zrecmto7z8q5odt3s33d
X-Rspam-User: 
X-HE-Tag: 1789386252-201697
X-HE-Meta: U2FsdGVkX1+PBBhrQc0Dw/Uc/ixmKtHMdBdImWuUz3WRj3J+ndlhqJkzCGvDBVnCz/LqEsuDJ6GzjCnZzB835HcW6ikSPe/d4swVj8jfwOoiaOYm4cqdfwS9x7Py9qosQfVIHL4GfLCZS3HkoI9Gnhz53Jhxne0rD9YGFsbHdc/WyqOIXZtS6eyV+uFzWvFky36Szkwkmh5KSXnrGszlVrJGhwoeL75e7g+TzXUO43mDT3ke/LlYgbwlVIOPbBqRJm8i1V0QuPrqHzzzu2zPN8LSilnOtWSw60CNVzUYickXZYNtr7OLZwklc0yACF1FNVP+axVFlaaYUhrpOUGgikkutGMLWxR05xwici8/U2JSJ+ZiEUZB8tZlXIkLw+sg6NXWAoJSp4YqFNR5SB8eZMp305qb4jz0JBVEksv0HYgFoc2jKJ5Di7DKHIwuXyyYjMesQ0j64PqFtAOEFyTlQl/J3R9OUxjkukseftFcmPkhFkYmzsyqXOOD0OyTxq0kauZO/91NIYPf64aSALAoz1ptbpbO99hxr4jIFlOcEVCRF1sqDK5b50Eg0sdNnQdlsoiCXxvpFJ/PYjfgnj6/fH7HQkLuDWjcG3AxMgrplTWRgaS4u19Me852ARxGJoSUDhd4vsQTJjRMZXv6Cq4cAlPCb8etoLww0nzI6P1rqjIkR7Ct4m9kGU9T5QYNQ39/otZ8DRgTm5Dacr+eJDlE5qkbKw3PtJTSpLJamk3yNhLwpc9uKV8z1L1aHBXRchclaNNZpbBJ9X/QkGyVj0qbXmwAgfqIkxtZV38l8WjN8VoVqhVb4MDOyeqc21APP/V5WxiQDf1h99MHJg9r+NdCv+R4v+mwxbENIx+z2u4zrcgFKXBC8x0ZMC4ZDlw3rRytcDMTz9Oftz6KFTp+/9mxe3z1G12DWtyDEIL4rg8hlhyb5FudXMtcEhyfka2IkOUoakGIU5kj4LPEEloKMbX
 EATz8lI6
 HOYDpHw+uPE800oDvogB1X38jVOUZaCkBLmHA6orO38BTX1sCo1jvvcPuHfHSACgFuki1Rq7A6/dzDtp7mJmpGt0rPMIMUyiYoWx+7pNvqTP+a4EML3dM/C5Dtgb/sk40Q2XyNpZhKtP4sQDL87rovgD3HE14Xo+omTKI/Z22bE6sMnuuYddfyseNoI83eNVRzpl8ohsm0eD/OhmeYAeocgA8lo/tWgaV03WITV4ok7uN0QOkPAKlYt8SG7pzV2Hfkw35
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


