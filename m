Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE281077617
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1259E6B031C; Wed, 18 Mar 2026 16:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6136B031E; Wed, 18 Mar 2026 16:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F296B031F; Wed, 18 Mar 2026 16:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2C286B031C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:40:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80C4255D98
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:04 +0000 (UTC)
X-FDA: 84560350728.14.9EC8842
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B281DC000D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r663G5hF;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/EPPj/qENadD13MhmNkPOczK+sxaKOrqQ5hwGY13Yc=;
	b=yxpP6QA7pF0z1ZvI3QieBbJf/KR6hJgT0m8ctl8wFLkyWrxJRxHqsw4Ug0ohkjUCprBhzx
	4EUOX0wkpzIM0rEkR9nfZ+1Iz/j52xa2Gd4A+l7j/Qc/5hK+5//uvz8bbBxWhMHlzEifRU
	XnVtt4XDQfSOpSqBopfLTnxz3nAR4r4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866402; a=rsa-sha256;
	cv=none;
	b=aDGEV5cvAqyZzpeIJkoF356f/EmY3bGIGT0nGQ/MQ4EZokUB1D4vPcqJen4Y9tgB7SboM+
	A/wnyG4SQOffvzWF/49IQUhuhEZHa7MDe7oc7bHhBVThdnx89KzeE4t+QqLvhnO+Fw6a1d
	JJHLx352x8MI1ZCtC4KwDyT5x8QP6BI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r663G5hF;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE267440A0;
	Wed, 18 Mar 2026 20:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB34C19424;
	Wed, 18 Mar 2026 20:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866401;
	bh=Aa0MO4lda9XCau+hln7tuomgpTWeyeT58RJMegaGG+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r663G5hFuynLBWFIAVuC1rRzPlY1j+MVXVEJUwDhkUKmMZ1r2VgBjPfhWh0zp8rA5
	 mfjUebr77i3N4ny5TUqUMqhDjkiwjnmeMXRjz83xu64yBHHX9t0oa6amJnnyob4/5h
	 RrSdAUHfB5fX3/ZQyVOCMJ7PxaM8Emfnalr4PwN9GbP+7w67XR9jcRLUjCUO9HHgCx
	 0vyBQMCAMibUfzZ+IHV6Si3QGqD+tuAsbnK41FgcB5lPYh9vjWMdtUAIjjiQX1Djwm
	 bUz/uiYQKnKT337AESwIRtG8wUig/4+nXgjBhVe8A+8ReX/FLxPtUcXekriUzPcI3Y
	 RVU6rbgkgoX9w==
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
Subject: [PATCH 1/8] mm/huge_memory: simplify vma_is_specal_huge()
Date: Wed, 18 Mar 2026 20:39:23 +0000
Message-ID: <84712e37721c557f887e4a405759be31a4961100.1773865827.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773865827.git.ljs@kernel.org>
References: <cover.1773865827.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: i9dkoaim6pf1nxr9t3bjnf3x6eswepyo
X-Rspamd-Queue-Id: B281DC000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773866402-474812
X-HE-Meta: U2FsdGVkX1/IAfQyK5woQdbLGk8j9j6acZdpOSFSYl3XvHHLhuLpV+iUM1XgCrlWQuu39OJDLaM3HtU1hDH38dk1fV/7pohIGbH11RGBIiMV5aBVBCzpwO6sxJ/WL0wYu5AkgrZSxJ9VK37wBMeb+f9RS6bNTdpPJ1luY15p8Ccq6sPfkSFFBiwHH15msQAOkAJJjNbH8MUvvcqUZrA7Bi57j3SVoQ5NvnisBQtbIne+yBixqE2tEJW/0MMZ72LoVH6Kclya6K33tA2wlr9Gk/3600ZZf9iyBdAzhJ9PS1taNOL5OpIIFJ7jDYxRBAkreDDnQZKJZfUUITzFsqKAGOlxOKZdFvQ8tLYKX/TfFYMJvNKGZl75cyPZVPxz1BlzjkiRtJ0Ta42s38CArXxHUyf2au4SSTLAaIaAqtPtKpvtkoyWK0qE2OiRCm5b6mrb8wC5mOO3xJqcBlxBCDjqRJ5UUdOe0/A1QxnYdO9t9SbDQ7YE79FtG2yFzd0v9DKmWb1zUF8kbTEtYD13CWnc/hS2GYAFGlZZ1230tRWmqZaTReLZYzfWN5Xzmimc7lPlxuMsehtr2KEn7pBksp6ZSQeytYiPjRm+3LxoTac6S/L4OQFG2k7vm9wH0TV1dsQuF6N6emVF544HTJqomRjeu86ml3/5+g60nuNwtNF+G06mzMuI7Bd+qfsfhTQ+fCY3f+plZGNVcGCd9d456pxBAm1JlB+V/J8npfM/eTcftMxnRSYp76mgwIBncKGBYiS1v78FmOJJqSnneEMeyBXIj/xRdRLMxYvAIX1QW0xI1/OjM1bE737NK4CsYzAoitcxq00TNJQUeb3cBPMXgjAq8fupD3l4662Hf+ghA3gWInCC0impcv4k/uQfC/MmlVInWgXjONOWv2AuQhZKglNgU42fE6eyCPMBaaspk53Q6owT+91Xlh9axrO8hwv7fQMPFd7hEIZ8egeujCZ1Jyn
 p3vG0Tny
 vTCxkVl6kT+RlPM6Vsj/ux2j/hKAcBvU2Oa9kFZ46AYZvX3GxNxeFJpazb06vEF8ptyaWwDdTI7tzWoA2bLbPt8B0UZV1skQ372SfMg8lUmtjX2EVTHXkiAje77OoxCP6Ec+tT6/UqjbF3OBWwZrHG8aTGjPb/WidPc92Psje4le4IMgIjrpyBRzZgFc1ixXvewf0PST9t8zCTNKBlcZLgrYzBacJyRiYHq+GxZBMuR/fmAMdhSCsi8XKe1pHgaA8Z9lJ+OZ+dG0OykOx6TXZvc5eJgxsk9EYhwuODzpIwjPEMuSfsd1+AJFGjrnKL9ZXcWsq
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


