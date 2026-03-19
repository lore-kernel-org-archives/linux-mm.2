Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BD51090223
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3DF6B04AA; Thu, 19 Mar 2026 09:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BACD06B04AC; Thu, 19 Mar 2026 09:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A056B04AD; Thu, 19 Mar 2026 09:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 957466B04AA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:00:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D1E0140590
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:25 +0000 (UTC)
X-FDA: 84562821210.15.C25A6C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 750ED40017
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:00:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AVywcXQ4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/EPPj/qENadD13MhmNkPOczK+sxaKOrqQ5hwGY13Yc=;
	b=vnkeUl7lfBEuOfrHBcmgIgn+HVLTWv2YmVf1TR2E9dfA4EHXsMXniAz8QZ9SR1PYV667Ex
	VeWcZJUVpPQg+iPFxvON4PxlOxQE70gzwTCUrYcrqIyh1Gn6SegSJdPZ69zN4gt8fAKCFe
	e+MV7c/Xk5hMJsk5CrsYgPu2wb2ZZLo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925223; a=rsa-sha256;
	cv=none;
	b=QRhYQGb/wCfEQE79KjTmS7dCeSszEB89BhjRk7NAj6zGqm6TxR6FuA4DAWUmzxw3eq5EaK
	CQYfeBGto5l98nKJ/8lLP9wS6xxvgD68+2AWNjYaHk3bCvErvhjS3jA5+leZUtAk+6VW9F
	rzKCSayypTuBaC9ba0rs8UoWUoQiLts=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AVywcXQ4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A15CB444B3;
	Thu, 19 Mar 2026 13:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D5AC19424;
	Thu, 19 Mar 2026 13:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925222;
	bh=Aa0MO4lda9XCau+hln7tuomgpTWeyeT58RJMegaGG+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVywcXQ4xyaMmk35dU9vt3sVUC8+3+RXnmasPLE7vAPaUiApGuweTyBcOqmS+aQj5
	 mSBtldqBENq7G4WQrYatZPICYJHIfKWzuuv5Y//N6NHpMhMUj3iXtyM6z8UTtC0FTb
	 fY5e4QOlVZV0lnVKL25CLldjvdQY0ldGfiBsQ5Cni7I0XgQY2Eodl5nK7gUWk+aYaG
	 cV5+bjBc/0sDjyd7/6VzgRO29ry0alPh9iHQmSWP2NaInvZLZ8NyfJFQnm4GAKwXb4
	 PY6oQGgVKoutrmdOO+K9QsIzWOqtSiq5DCrBd9PZ7fpwtOnTFEBELjKGDsCIXfN1dp
	 ApHvEkXJSEt8g==
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/9] mm/huge_memory: simplify vma_is_specal_huge()
Date: Thu, 19 Mar 2026 13:00:07 +0000
Message-ID: <613669b1b2082d34f5632907003ae3874eff2ed9.1773924928.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773924928.git.ljs@kernel.org>
References: <cover.1773924928.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 750ED40017
X-Stat-Signature: usrj936rgeewbdst9ewg7mo85hb8q3xp
X-Rspam-User: 
X-HE-Tag: 1773925223-465842
X-HE-Meta: U2FsdGVkX1+EKRs3ZdqNrHDl9Ny/OQgrJzte+DjresoIyRoiLDpp9qmKaSsp0oWckUKw2otHkLdTEFSzusfXqzPgnsThkd1ouZKINP/OxiiyAk+gOeG1o5fpFwfT3w91lpkAmoZmILp/dVW5TJyV/AuA6i3XnfUHBJAcTmzW+my4hn2M+AauX6HUbdkr9esKQJLZzztI0xq0dUsdpl1XrP+cSVj4cOh90/xwNKfk8G+wi9i3AInajq+cZCKAP3sGd9tU/3rkvRyL2aSOCljsal4rko7gQbDwbbeDGQBCCosVMmldRZg/jd4McT//WlkGxtW1gqPHzif6Rzw+TZeKu6WRDExyAENBrGBfg1XuNy2GlOc752VaarQvQUhKMaGuqyrmWaSL4yhAkIWWCL2uZM22TSyWF/Yncm0yBft7pYA+O/UBsQ71jEM5i83p3bPi/Wh03kI6mS5GK/LNlu61ZOqSKzcgKTTGRiRUmPLanzz6ILxaWIoE5hfosas2j3IzBt7abMj0gobEAGt/B6BIg2JhglVKfK8R02tBt2LsJazz4RSRhH+XID81Oh3l4/1aUfOYzEo+W/BgmkXdjmhtBbRxKLwqIZ7Fx31xffa0VLy6AaepSbP6pKXoSIlCLvs6tRuLKBoXA1K4xqLC1FR5mjYvvH+YKtg16gmajEs8LoeMUL2smKPM8Mm7HXq4soVaAgsIWsNZDxo81WNdzGpgEpSApx7UkDWAqq9lYk2Y1Vr5PXiSDiStGzrf66QWWlxiks4lBW7ZTBRj8UGqeLMH9b4tDuI1+2t+bjA3pX+gKH4h7iSTDHFQEbtV7lXGWooxfUuGZhOzQRQWFGbghjONlmBrta6karZR8EBEuueilYYxZgNxR70wz4/XTFZoEogv8sCnmpfPIsPyAjmzI2rzH+H245sTUwCK5tZOO7+dz08fHZptKLqUJD5amp6ViMCQHrT5/nKirZdqauIDNO6
 ypK3OStj
 UFvIS+cSL1tZr7461gKisbGf2jZkkXjRvApKql3DvJx/QlYOPAIrxOxGC/Ny4JfewsHEhJdKZBNvRHwA5vrp/lWZyZoRM+iGwPd2O9SO/8DzokMzDp3E+yeb9pEDrkMuArse4MEuW702SDiSbixcKRXmlkAmLupla6lV9hl9io9p9HJ90/O+Bmtx9SKEuGQDA83sByT/LmIfaiaMKriAkP+avq5dNiKSAbxzbKyPQyYBh4cbsg1IAc80umcFxlZ6jKbgYvzkjOdL+ynVJDmx7as0ijw==
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
vm_normal_page(), as DAX actually does potentially have retrievable folios.

Also there's no need to have this in mm.h so move it to huge_memory.c.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/huge_mm.h |  4 ++--
 include/linux/mm.h      | 16 ----------------
 mm/huge_memory.c        | 30 +++++++++++++++++++++++-------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bd7f0e1d8094..61fda1672b29 100644
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
index 6f0a3edb24e1..50d68b092204 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5077,22 +5077,6 @@ long copy_folio_from_user(struct folio *dst_folio,
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
index 3fc02913b63e..f76edfa91e96 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -100,6 +100,14 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
+/* If returns true, we are unable to access the VMA's folios. */
+static bool vma_is_special_huge(struct vm_area_struct *vma)
+{
+	if (vma_is_dax(vma))
+		return false;
+	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
 					 enum tva_type type,
@@ -113,8 +121,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_special_huge(vma))
-		supported_orders = THP_ORDERS_ALL_SPECIAL;
+	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
@@ -2431,7 +2439,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 						tlb->fullmm);
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+	if (vma_is_special_huge(vma)) {
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
@@ -2933,7 +2941,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
+	if (vma_is_special_huge(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3084,7 +3092,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
+		if (vma_is_special_huge(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4645,8 +4653,16 @@ static void split_huge_pages_all(void)
 
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


