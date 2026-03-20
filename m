Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1B851099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A416B0095; Fri, 20 Mar 2026 14:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6520B6B0096; Fri, 20 Mar 2026 14:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541416B009D; Fri, 20 Mar 2026 14:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43A3E6B0095
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:07:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC6A614035B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:38 +0000 (UTC)
X-FDA: 84567224196.08.9D3ED09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4833C40011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oawTQ/US";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9ydDlfRC5eJ8PPItqqZbisgcmG/bmMVDQUkg8vuiEY=;
	b=CLYCBvW8uTFIW8KlctJ9PgBAnGmyRxu1OjCt96Ud07q0JlVJwyqPLELiMvT3sMzONV9dEA
	93ggAgAsStDDOiOTa1GxG4NsABbhav9QeTX+f2DII9lGRezoXyTkSoT/MX80s8DDLKgTGN
	bl5NYvWtthT/qMxPTO/bkvnPlTVTlIE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oawTQ/US";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030057; a=rsa-sha256;
	cv=none;
	b=QY5sJchP1yoNV/FZ2WK9g0ydulN2SxlEb+gSv6dDZKvmeeGVvUab85eGrp84danjhUMPX5
	d1vlBK7cnhRWadDnE37mzFb65+OtBdzq+NYl3v/+IrtO8OF+DrFp4NpyLwohSfWGzhqJ5B
	mKguZWXY2nrc6LcZgcAmvywEp2Kfd0M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4712C42B00;
	Fri, 20 Mar 2026 18:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75BDC4CEF7;
	Fri, 20 Mar 2026 18:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030056;
	bh=4U83wxJSN0UvnMmG6gmIbCq9G1O39b23blfys7NRzY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oawTQ/USDOI+bBk/Avv+KVeaY20yO81RjkQvmlkgxNHTsQlu9LbTaivaiWjnRA+b1
	 G5WdrtIcbc0NRE/4uiWq4tNmDt5Ea3mYygKsL97OFSEjVNdMdqg6KeDbPHAgu5t3Bo
	 3HGj2k0NDsFaMUYlShx6FqdpAMieNNgv15Rwa+Cmlfd0bUX6GyTqsaW9fS4quYWusq
	 wVICpBDG6r4LoKUqWWAJiKdnQ5ofLqAZjMk85D2kiGfD7504yLBH+uxcuq4kkVOC2v
	 KspSLh5nHcK7m4gppd5c2SYZhrwW6FAjjlSC+U0r3VShwIdYiZgS6k+wb9a3I10hz3
	 6yHswKWehCEBQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/13] mm/huge_memory: simplify vma_is_specal_huge()
Date: Fri, 20 Mar 2026 18:07:18 +0000
Message-ID: <d2b65883dc4895f197c4b4a69fbf27a063463412.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4833C40011
X-Stat-Signature: g5srqudxea6kgs7xyw6oszp9iyuhspkg
X-Rspam-User: 
X-HE-Tag: 1774030057-253424
X-HE-Meta: U2FsdGVkX1+B0sInK3tdkvA+ABFrZDgfG+AlwYYPtwCbE7njGoN6f2Le665E2nw4a98WCF8hD6tRNvRlSuT6mSM5atgfVtNoG2RJRq+eeNtJOTRvF7wkFQUuAnU3Y+tNQs6Y5qN/oyI478i+zp9T4foiqvZ7XKi5fUydXWWnS8Xje/+Vx/vKxFHs0BMTAPStNE1/lPqEs0Ni2SHHH2+8xhFJhiIDIb/5WBuohGyWoaQMQB1hDZpvBXDMCENsp1lMo0Y9KMlLBF6L2CabRYeh9cMEZOJQ/q9IE8c/mbZd76afbIVkSgXQaKCJs2AxTn8P8EMO1JAcZj4o92RY5Yyo9PgjQA2rXKm8X38o7p7UllpfS0ZeM+XC4qrDltA9upY8Aol+tjIt5btRIJzfG1LDt8A0efHDWu+DvE4c7z0TBrY7cx4UR07xDGDBGfHZYF9OWC3Bu9KaE3eIqrMD8Fnl1wMw0Fnux1pyhr1OQtZjyMj4wb2zITDpH4GhL8d4iMC9QW7D5rbyIudMZQn7iQuueqEGZq5cum6Gg6MgE8xxkFY9bG5WQtb4L4cedcC1613wqKSBY7qJ9bHgV1MjzxyjexfVn6LKIZ80/x4W68HadcjImgVMoZdGl1+xvd7I7jQ/t0Hin8Y/5b6N5XFqLoKPO/McbSnkyKbczt+uHQGu3aUSz981lr1lDnk0jGfr/dO80QZ0k1rBIcMI7/GbESfriTCZXQ3U0uRe15Fq+5VEPujWD8fGK7DApurO814fURtgELKTXg/IdYW4MYPKc8H7RdMrPZRzpAws2k9pTy5aq2uo4tNpAUBRAR4JCwZ8lhNTRCrSxxvup/d9irELgZ24ectkR3cQO2V0llKPnCU9+5DhzOVx0ilKuOCliXK+WoaX8qoAVq8jQkfIHzw//Q4fNOZ+Ym03BSQngePoJZ21nrFm36GFVL6CV7cihKS1x2Hwtuw1uvkbcjt0udF8rgO
 cvKK+QT8
 rxIFlRtVkVAZHYgrc0zMhUMkgFjypamsVVBWFYh52PTi8ngg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function is confused - it overloads the term 'special' yet again,
checks for DAX but in many cases the code explicitly excludes DAX before
invoking the predicate.

It also unnecessarily checks for vma->vm_file - this has to be present for
a driver to have set VMA_MIXEDMAP_BIT or VMA_PFNMAP_BIT.

In fact, a far simpler form of this is to reverse the DAX predicate and
return false if DAX is set.

This makes sense from the point of view of 'special' as in
vm_normal_page(), as DAX actually does potentially have retrievable
folios.

Also there's no need to have this in mm.h so move it to huge_memory.c.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/huge_mm.h |  4 ++--
 include/linux/mm.h      | 16 ----------------
 mm/huge_memory.c        | 30 +++++++++++++++++++++++-------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8d801ed378db..af726f0aa30d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -83,7 +83,7 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
  * file is never split and the MAX_PAGECACHE_ORDER limit does not apply to
  * it.  Same to PFNMAPs where there's neither page* nor pagecache.
  */
-#define THP_ORDERS_ALL_SPECIAL		\
+#define THP_ORDERS_ALL_SPECIAL_DAX	\
 	(BIT(PMD_ORDER) | BIT(PUD_ORDER))
 #define THP_ORDERS_ALL_FILE_DEFAULT	\
 	((BIT(MAX_PAGECACHE_ORDER + 1) - 1) & ~BIT(0))
@@ -92,7 +92,7 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
  * Mask of all large folio orders supported for THP.
  */
 #define THP_ORDERS_ALL	\
-	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
+	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL_DAX | THP_ORDERS_ALL_FILE_DEFAULT)
 
 enum tva_type {
 	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8aadf115278e..6b07ee99b38b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5078,22 +5078,6 @@ long copy_folio_from_user(struct folio *dst_folio,
 			   const void __user *usr_src,
 			   bool allow_pagefault);
 
-/**
- * vma_is_special_huge - Are transhuge page-table entries considered special?
- * @vma: Pointer to the struct vm_area_struct to consider
- *
- * Whether transhuge page-table entries are considered "special" following
- * the definition in vm_normal_page().
- *
- * Return: true if transhuge page-table entries should be considered special,
- * false otherwise.
- */
-static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
-{
-	return vma_is_dax(vma) || (vma->vm_file &&
-				   (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)));
-}
-
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
 #if MAX_NUMNODES > 1
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e90d08db219d..2775309b317a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -103,6 +103,14 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
+/* If returns true, we are unable to access the VMA's folios. */
+static bool vma_is_special_huge(const struct vm_area_struct *vma)
+{
+	if (vma_is_dax(vma))
+		return false;
+	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 enum tva_type type,
@@ -116,8 +124,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_special_huge(vma))
-		supported_orders = THP_ORDERS_ALL_SPECIAL;
+	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
@@ -2338,7 +2346,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 						tlb->fullmm);
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+	if (vma_is_special_huge(vma)) {
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
@@ -2840,7 +2848,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+	if (vma_is_special_huge(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -2991,7 +2999,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
+		if (vma_is_special_huge(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4517,8 +4525,16 @@ static void split_huge_pages_all(void)
 
 static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
 {
-	return vma_is_special_huge(vma) || (vma->vm_flags & VM_IO) ||
-		    is_vm_hugetlb_page(vma);
+	if (vma_is_dax(vma))
+		return true;
+	if (vma_is_special_huge(vma))
+		return true;
+	if (vma_test(vma, VMA_IO_BIT))
+		return true;
+	if (is_vm_hugetlb_page(vma))
+		return true;
+
+	return false;
 }
 
 static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
-- 
2.53.0


