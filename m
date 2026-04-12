Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 585B4E937EF
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 17:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43576B00A3; Sun, 12 Apr 2026 13:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4DB6B00A5; Sun, 12 Apr 2026 13:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2C16B00A6; Sun, 12 Apr 2026 13:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9929C6B00A3
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:43:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52BD659B7D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:21 +0000 (UTC)
X-FDA: 84650625402.22.259AF48
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18414180004
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KTOS5NuL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zNAQHat7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o3fYM61i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MYt7rd32;
	spf=pass (imf16.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776015799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFdvXCfTfqe+GIJUnVe1dTR0RpJ/i5W7x3fsTp932Uw=;
	b=ZDofgdSu5aRalNnTpoUDdEEmU5FoVlASl4L6QEhlC1FBRDdNvhuVhsKnt/+Whgdg0clM6q
	nucY6EveM92qFztk9zvnOs2oDGW7bYhJ2VEN1o1I6DHM6l80Aji2euo4vqVP2D4kE4m7U6
	Fz4vb2rkJ5QyT5xHUKP3RjrGNNNFgWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776015799; a=rsa-sha256;
	cv=none;
	b=0JWsrcWo9l55NLRciGlUn887MzPXbjBAL1kMOzIBddcjUFh1tEPGhSvs44j7+iD5/cuXCL
	/dYOdgT+paiMC//FdDhYtk/4273ed0ouMu7Pw3IgLjqhRPhqNnnE3eamNeVLRqdXX8FmO6
	LJbf54sU67VTwxMAE5cfy7pFy0UuV98=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KTOS5NuL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zNAQHat7;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o3fYM61i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MYt7rd32;
	spf=pass (imf16.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EF8C46A871;
	Sun, 12 Apr 2026 17:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFdvXCfTfqe+GIJUnVe1dTR0RpJ/i5W7x3fsTp932Uw=;
	b=KTOS5NuL4ag9rZ0dUn49H1eSqO5c58rSdgTQNerEOUw/e8dnHHAsf7ozUezxeed9T5Pvpf
	4YD57Pyowi/WBbxT/3wHKATN3RTagl8ga7w1u0PiiuZQzQg3QEsj/EEM1LQzz+p5djde5j
	TjpvX48LgrJxXLN4pmwobX4cXGp4m3M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015785;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFdvXCfTfqe+GIJUnVe1dTR0RpJ/i5W7x3fsTp932Uw=;
	b=zNAQHat7URyXcf54NYyEmUJWII2OWBWKRsurpazDSWJYr8Jc/VkEktJiNBoHQrEvIpkZIb
	pHZX0FZfMGJCcACA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFdvXCfTfqe+GIJUnVe1dTR0RpJ/i5W7x3fsTp932Uw=;
	b=o3fYM61iqk6X2r2qWto3FR5Soks6aVxNovdYrARmrr1XrOUq4DikSt7jTeSGGlhrIpN6gM
	En8s6zYAhIsQr/n2/FKHjSnjQV2Ahouvn72+eTsAob8vIiwwiWiRYduzlhs/dJ7rigdS7R
	DFQ/rHXfxeu1JeDjgkYJbERoGskwr6g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFdvXCfTfqe+GIJUnVe1dTR0RpJ/i5W7x3fsTp932Uw=;
	b=MYt7rd32gxaTTKESI+hVkX3kSC5o9khTJMpYQOb2hJGXXm+zXnd0dwBa7irWyykbKaxnRL
	z6r/Wvf2M1HpaxBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7908C4AA4A;
	Sun, 12 Apr 2026 17:43:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OHnoGqjZ22miRQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 12 Apr 2026 17:43:04 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH 7/7] mm: Make /proc/pid/pagemap use the new generic pagewalk API
Date: Sun, 12 Apr 2026 19:42:44 +0200
Message-ID: <20260412174244.133715-8-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260412174244.133715-1-osalvador@suse.de>
References: <20260412174244.133715-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: t6rfqujbqpmkp9hhwc5t7tncrq131r9i
X-Rspamd-Queue-Id: 18414180004
X-Rspam-User: 
X-HE-Tag: 1776015798-616300
X-HE-Meta: U2FsdGVkX1+yy9GPZleiN+yTpC5AwsTAqmrFz5U2NYKcGBNTF2cUZwzeMH6EmS0Vxy0KxBJzS7nLWtxQhpcyQ/KBdHx6wcU9L3P8x4mdLOfC+AmTRG5WNVFx6l6afD5nlcRVg0tlZvTevKw35pBdsCZNWZHAtKibqRh7iTWuaOluPPDTUX/3PyWetuidvkyMiMFSuAzm90BNrYGkY/cEXP8qC6S5DtcQmMkpeycRBEY3DWh0e1I6Suw/GZJ9s1AUy1TIn/ku0O6ibB9HVHPJPOFaQ9+z6BWZU3G2NOGW+gWKPSZAk7YTlpLot+TS/IiDxdKlY972NMIHddwj4MLj/tpBm0zgXpCgQXqB7neKaUkh5iWN2ajJb2AZMJRxI1cH3HJw7a4nbAr8NqqeZpkOqk8r6g66nXHeKf2U06yf5Kf1uSMuA+LJWTqAe4VE7A3JrdK9oDaKGrVF3VlrB/qwkVTGAMH8KFJ2z0jRdpVDBv523prTccCQB8lu3pUNH2bbqa8DJDEpbKxpZwsBxn78iVDoRVMgfSm4w6y5GGrr8yBxzmGeh+BUrOdC3u5EtsjGeQEEJvDcNZu8c/hNZXA1f6RHO61FuTUvrla0tIjeM+Rhcw5lwmgw292XB66znCo49W+0bAWanwbXylb0ndE3PZbJsWWf3lhezVGtWn1D19Ezh14s8iajDqcUu7wAtGMff8miX4uk6LJOfzDeNUrCPEByv0kwIN/W8fVKq0OnNZMAIJTkbJGxK4PRTC16x5Inbvsu74OMJNqy5vH8CrcGIGZ2nQ2Upn+gsPjVLvpfJa0uPQUz4dwGTI5sMDdZdB+i+HIe8pg7kq0JPhYW/ZkLC7TqfdsEwPRuiN7kCSBEQcwgBPMMlelxpnB2v1ryMExAqTx6jOG1mnCdrhkpxJDQVcEQorcEidpRjYgdQORgwyURj+wCM6ZaQjXexn0fJRbdLeqGU1BfBsFbQR40Y16
 vBWrMYZA
 tW8DF1/zP/Vyjk6nM6Y0HJmwgetkPO9FSlq6ZcSuDq7OiFQ63z9XDlv+2AFqJ5Kc0NH+HcZvTX05YTJghRXryMoXEdD5m+jLrPxMmV6HcYETk29a7RE+ZdRbnRWJk5e9x0HPqeppkEyyea/cvGwMVj4puuz8re4OBLRWBRFKQu3bxhOpfHTbnb8Eidd2hDERLRoZGsCZvVgvItG5E3N5M6t7KogRYAvuAovy2eX46gXibWhcrWFrmhRv1SEHrRD4ENxz5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Have /proc/pid/pagemap make use of the new generic API, and remove
the code which was using the old one.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 arch/x86/include/asm/pgtable.h |   4 +
 arch/x86/mm/pgtable.c          |  18 +-
 fs/proc/task_mmu.c             | 906 +++++++++++++++------------------
 include/linux/leafops.h        |  13 +
 include/linux/pgtable.h        |  30 ++
 mm/pgtable-generic.c           |  10 +
 6 files changed, 481 insertions(+), 500 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a68ff339cd56..1d18f6177784 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1400,6 +1400,10 @@ static inline pud_t pudp_establish(struct vm_area_struct *vma,
 }
 #endif
 
+#define __HAVE_ARCH_PUDP_INVALIDATE_AD
+extern pud_t pudp_invalidate_ad(struct vm_area_struct *vma,
+				unsigned long address, pud_t *pudp);
+
 #define __HAVE_ARCH_PMDP_INVALIDATE_AD
 extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp);
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 2e5ecfdce73c..828f5ca9195e 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -530,8 +530,22 @@ pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
 }
 #endif
 
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
-	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+#if (defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)) || \
+	defined CONFIG_HUGETLB_PAGE
+
+pud_t pudp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
+			 pud_t *pudp)
+{
+	VM_WARN_ON_ONCE(!pud_present(*pudp));
+
+	/*
+	 * No flush is necessary. Once an invalid PUD is established, the PUD's
+	 * access and dirty bits cannot be updated.
+	 */
+	return pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
+}
+
 pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pud_t *pudp)
 {
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 776e7a6baf00..6b6d5a39cd5a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1856,192 +1856,6 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 	return make_pme(frame, flags);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
-		unsigned long end, struct vm_area_struct *vma,
-		struct pagemapread *pm)
-{
-	unsigned int idx = (addr & ~PMD_MASK) >> PAGE_SHIFT;
-	u64 flags = 0, frame = 0;
-	pmd_t pmd = *pmdp;
-	struct page *page = NULL;
-	struct folio *folio = NULL;
-	int err = 0;
-
-	if (vma->vm_flags & VM_SOFTDIRTY)
-		flags |= PM_SOFT_DIRTY;
-
-	if (pmd_none(pmd))
-		goto populate_pagemap;
-
-	if (pmd_present(pmd)) {
-		page = pmd_page(pmd);
-
-		flags |= PM_PRESENT;
-		if (pmd_soft_dirty(pmd))
-			flags |= PM_SOFT_DIRTY;
-		if (pmd_uffd_wp(pmd))
-			flags |= PM_UFFD_WP;
-		if (pm->show_pfn)
-			frame = pmd_pfn(pmd) + idx;
-	} else if (thp_migration_supported()) {
-		const softleaf_t entry = softleaf_from_pmd(pmd);
-		unsigned long offset;
-
-		if (pm->show_pfn) {
-			if (softleaf_has_pfn(entry))
-				offset = softleaf_to_pfn(entry) + idx;
-			else
-				offset = swp_offset(entry) + idx;
-			frame = swp_type(entry) |
-				(offset << MAX_SWAPFILES_SHIFT);
-		}
-		flags |= PM_SWAP;
-		if (pmd_swp_soft_dirty(pmd))
-			flags |= PM_SOFT_DIRTY;
-		if (pmd_swp_uffd_wp(pmd))
-			flags |= PM_UFFD_WP;
-		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
-		page = softleaf_to_page(entry);
-	}
-
-	if (page) {
-		folio = page_folio(page);
-		if (!folio_test_anon(folio))
-			flags |= PM_FILE;
-	}
-
-populate_pagemap:
-	for (; addr != end; addr += PAGE_SIZE, idx++) {
-		u64 cur_flags = flags;
-		pagemap_entry_t pme;
-
-		if (folio && (flags & PM_PRESENT) &&
-		    __folio_page_mapped_exclusively(folio, page))
-			cur_flags |= PM_MMAP_EXCLUSIVE;
-
-		pme = make_pme(frame, cur_flags);
-		err = add_to_pagemap(&pme, pm);
-		if (err)
-			break;
-		if (pm->show_pfn) {
-			if (flags & PM_PRESENT)
-				frame++;
-			else if (flags & PM_SWAP)
-				frame += (1 << MAX_SWAPFILES_SHIFT);
-		}
-	}
-	return err;
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
-static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
-			     struct mm_walk *walk)
-{
-	struct vm_area_struct *vma = walk->vma;
-	struct pagemapread *pm = walk->private;
-	spinlock_t *ptl;
-	pte_t *pte, *orig_pte;
-	int err = 0;
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	ptl = pmd_trans_huge_lock(pmdp, vma);
-	if (ptl) {
-		err = pagemap_pmd_range_thp(pmdp, addr, end, vma, pm);
-		spin_unlock(ptl);
-		return err;
-	}
-#endif
-
-	/*
-	 * We can assume that @vma always points to a valid one and @end never
-	 * goes beyond vma->vm_end.
-	 */
-	orig_pte = pte = pte_offset_map_lock(walk->mm, pmdp, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
-		return err;
-	}
-	for (; addr < end; pte++, addr += PAGE_SIZE) {
-		pagemap_entry_t pme;
-
-		pme = pte_to_pagemap_entry(pm, vma, addr, ptep_get(pte));
-		err = add_to_pagemap(&pme, pm);
-		if (err)
-			break;
-	}
-	pte_unmap_unlock(orig_pte, ptl);
-
-	cond_resched();
-
-	return err;
-}
-
-#ifdef CONFIG_HUGETLB_PAGE
-/* This function walks within one hugetlb entry in the single call */
-static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
-				 unsigned long addr, unsigned long end,
-				 struct mm_walk *walk)
-{
-	struct pagemapread *pm = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	u64 flags = 0, frame = 0;
-	spinlock_t *ptl;
-	int err = 0;
-	pte_t pte;
-
-	if (vma->vm_flags & VM_SOFTDIRTY)
-		flags |= PM_SOFT_DIRTY;
-
-	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, ptep);
-	pte = huge_ptep_get(walk->mm, addr, ptep);
-	if (pte_present(pte)) {
-		struct folio *folio = page_folio(pte_page(pte));
-
-		if (!folio_test_anon(folio))
-			flags |= PM_FILE;
-
-		if (!folio_maybe_mapped_shared(folio) &&
-		    !hugetlb_pmd_shared(ptep))
-			flags |= PM_MMAP_EXCLUSIVE;
-
-		if (huge_pte_uffd_wp(pte))
-			flags |= PM_UFFD_WP;
-
-		flags |= PM_PRESENT;
-		if (pm->show_pfn)
-			frame = pte_pfn(pte) +
-				((addr & ~hmask) >> PAGE_SHIFT);
-	} else if (pte_swp_uffd_wp_any(pte)) {
-		flags |= PM_UFFD_WP;
-	}
-
-	for (; addr != end; addr += PAGE_SIZE) {
-		pagemap_entry_t pme = make_pme(frame, flags);
-
-		err = add_to_pagemap(&pme, pm);
-		if (err)
-			break;
-		if (pm->show_pfn && (flags & PM_PRESENT))
-			frame++;
-	}
-
-	spin_unlock(ptl);
-	cond_resched();
-
-	return err;
-}
-#else
-#define pagemap_hugetlb_range	NULL
-#endif /* HUGETLB_PAGE */
-
-static const struct mm_walk_ops pagemap_ops = {
-	.pmd_entry	= pagemap_pmd_range,
-	.pte_hole	= pagemap_pte_hole,
-	.hugetlb_entry	= pagemap_hugetlb_range,
-	.walk_lock	= PGWALK_RDLOCK,
-};
-
 /*
  * /proc/pid/pagemap - an array mapping virtual pages to pfns
  *
@@ -2070,99 +1884,6 @@ static const struct mm_walk_ops pagemap_ops = {
  * determine which areas of memory are actually mapped and llseek to
  * skip over unmapped regions.
  */
-static ssize_t pagemap_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *ppos)
-{
-	struct mm_struct *mm = file->private_data;
-	struct pagemapread pm;
-	unsigned long src;
-	unsigned long svpfn;
-	unsigned long start_vaddr;
-	unsigned long end_vaddr;
-	int ret = 0, copied = 0;
-
-	if (!mm || !mmget_not_zero(mm))
-		goto out;
-
-	ret = -EINVAL;
-	/* file position must be aligned */
-	if ((*ppos % PM_ENTRY_BYTES) || (count % PM_ENTRY_BYTES))
-		goto out_mm;
-
-	ret = 0;
-	if (!count)
-		goto out_mm;
-
-	/* do not disclose physical addresses: attack vector */
-	pm.show_pfn = file_ns_capable(file, &init_user_ns, CAP_SYS_ADMIN);
-
-	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
-	pm.buffer = kmalloc_array(pm.len, PM_ENTRY_BYTES, GFP_KERNEL);
-	ret = -ENOMEM;
-	if (!pm.buffer)
-		goto out_mm;
-
-	src = *ppos;
-	svpfn = src / PM_ENTRY_BYTES;
-	end_vaddr = mm->task_size;
-
-	/* watch out for wraparound */
-	start_vaddr = end_vaddr;
-	if (svpfn <= (ULONG_MAX >> PAGE_SHIFT)) {
-		unsigned long end;
-
-		ret = mmap_read_lock_killable(mm);
-		if (ret)
-			goto out_free;
-		start_vaddr = untagged_addr_remote(mm, svpfn << PAGE_SHIFT);
-		mmap_read_unlock(mm);
-
-		end = start_vaddr + ((count / PM_ENTRY_BYTES) << PAGE_SHIFT);
-		if (end >= start_vaddr && end < mm->task_size)
-			end_vaddr = end;
-	}
-
-	/* Ensure the address is inside the task */
-	if (start_vaddr > mm->task_size)
-		start_vaddr = end_vaddr;
-
-	ret = 0;
-	while (count && (start_vaddr < end_vaddr)) {
-		int len;
-		unsigned long end;
-
-		pm.pos = 0;
-		end = (start_vaddr + PAGEMAP_WALK_SIZE) & PAGEMAP_WALK_MASK;
-		/* overflow ? */
-		if (end < start_vaddr || end > end_vaddr)
-			end = end_vaddr;
-		ret = mmap_read_lock_killable(mm);
-		if (ret)
-			goto out_free;
-		ret = walk_page_range(mm, start_vaddr, end, &pagemap_ops, &pm);
-		mmap_read_unlock(mm);
-		start_vaddr = end;
-
-		len = min(count, PM_ENTRY_BYTES * pm.pos);
-		if (copy_to_user(buf, pm.buffer, len)) {
-			ret = -EFAULT;
-			goto out_free;
-		}
-		copied += len;
-		buf += len;
-		count -= len;
-	}
-	*ppos += copied;
-	if (!ret || ret == PM_END_OF_BUFFER)
-		ret = copied;
-
-out_free:
-	kfree(pm.buffer);
-out_mm:
-	mmput(mm);
-out:
-	return ret;
-}
 
 static int pagemap_open(struct inode *inode, struct file *file)
 {
@@ -2267,6 +1988,23 @@ static void make_uffd_wp_pte(struct vm_area_struct *vma,
 	}
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static void make_uffd_wp_pud(struct vm_area_struct *vma,
+			     unsigned long addr, pud_t *pudp)
+{
+	pud_t old, pud = *pudp;
+
+	if (pud_present(pud)) {
+		old = pudp_invalidate_ad(vma, addr, pudp);
+		pud = pud_mkuffd_wp(old);
+		set_pud_at(vma->vm_mm, addr, pudp, pud);
+	} else if (pud_is_migration_entry(pud)) {
+		pud = pud_swp_mkuffd_wp(pud);
+		set_pud_at(vma->vm_mm, addr, pudp, pud);
+	}
+}
+#endif
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
 					  struct vm_area_struct *vma,
@@ -2539,216 +2277,6 @@ static int pagemap_scan_output(unsigned long categories,
 	return ret;
 }
 
-static int pagemap_scan_thp_entry(pmd_t *pmd, unsigned long start,
-				  unsigned long end, struct mm_walk *walk)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	struct pagemap_scan_private *p = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	unsigned long categories;
-	spinlock_t *ptl;
-	int ret = 0;
-
-	ptl = pmd_trans_huge_lock(pmd, vma);
-	if (!ptl)
-		return -ENOENT;
-
-	categories = p->cur_vma_category |
-		     pagemap_thp_category(p, vma, start, *pmd);
-
-	if (!pagemap_scan_is_interesting_page(categories, p))
-		goto out_unlock;
-
-	ret = pagemap_scan_output(categories, p, start, &end);
-	if (start == end)
-		goto out_unlock;
-
-	if (~p->arg.flags & PM_SCAN_WP_MATCHING)
-		goto out_unlock;
-	if (~categories & PAGE_IS_WRITTEN)
-		goto out_unlock;
-
-	/*
-	 * Break huge page into small pages if the WP operation
-	 * needs to be performed on a portion of the huge page.
-	 */
-	if (end != start + HPAGE_SIZE) {
-		spin_unlock(ptl);
-		split_huge_pmd(vma, pmd, start);
-		pagemap_scan_backout_range(p, start, end);
-		/* Report as if there was no THP */
-		return -ENOENT;
-	}
-
-	make_uffd_wp_pmd(vma, start, pmd);
-	flush_tlb_range(vma, start, end);
-out_unlock:
-	spin_unlock(ptl);
-	return ret;
-#else /* !CONFIG_TRANSPARENT_HUGEPAGE */
-	return -ENOENT;
-#endif
-}
-
-static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
-				  unsigned long end, struct mm_walk *walk)
-{
-	struct pagemap_scan_private *p = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	unsigned long addr, flush_end = 0;
-	pte_t *pte, *start_pte;
-	spinlock_t *ptl;
-	int ret;
-
-	ret = pagemap_scan_thp_entry(pmd, start, end, walk);
-	if (ret != -ENOENT)
-		return ret;
-
-	ret = 0;
-	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, start, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
-		return 0;
-	}
-
-	lazy_mmu_mode_enable();
-
-	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
-		/* Fast path for performing exclusive WP */
-		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
-			pte_t ptent = ptep_get(pte);
-
-			if ((pte_present(ptent) && pte_uffd_wp(ptent)) ||
-			    pte_swp_uffd_wp_any(ptent))
-				continue;
-			make_uffd_wp_pte(vma, addr, pte, ptent);
-			if (!flush_end)
-				start = addr;
-			flush_end = addr + PAGE_SIZE;
-		}
-		goto flush_and_return;
-	}
-
-	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
-	    p->arg.category_mask == PAGE_IS_WRITTEN &&
-	    p->arg.return_mask == PAGE_IS_WRITTEN) {
-		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
-			unsigned long next = addr + PAGE_SIZE;
-			pte_t ptent = ptep_get(pte);
-
-			if ((pte_present(ptent) && pte_uffd_wp(ptent)) ||
-			    pte_swp_uffd_wp_any(ptent))
-				continue;
-			ret = pagemap_scan_output(p->cur_vma_category | PAGE_IS_WRITTEN,
-						  p, addr, &next);
-			if (next == addr)
-				break;
-			if (~p->arg.flags & PM_SCAN_WP_MATCHING)
-				continue;
-			make_uffd_wp_pte(vma, addr, pte, ptent);
-			if (!flush_end)
-				start = addr;
-			flush_end = next;
-		}
-		goto flush_and_return;
-	}
-
-	for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
-		pte_t ptent = ptep_get(pte);
-		unsigned long categories = p->cur_vma_category |
-					   pagemap_page_category(p, vma, addr, ptent);
-		unsigned long next = addr + PAGE_SIZE;
-
-		if (!pagemap_scan_is_interesting_page(categories, p))
-			continue;
-
-		ret = pagemap_scan_output(categories, p, addr, &next);
-		if (next == addr)
-			break;
-
-		if (~p->arg.flags & PM_SCAN_WP_MATCHING)
-			continue;
-		if (~categories & PAGE_IS_WRITTEN)
-			continue;
-
-		make_uffd_wp_pte(vma, addr, pte, ptent);
-		if (!flush_end)
-			start = addr;
-		flush_end = next;
-	}
-
-flush_and_return:
-	if (flush_end)
-		flush_tlb_range(vma, start, addr);
-
-	lazy_mmu_mode_disable();
-	pte_unmap_unlock(start_pte, ptl);
-
-	cond_resched();
-	return ret;
-}
-
-#ifdef CONFIG_HUGETLB_PAGE
-static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
-				      unsigned long start, unsigned long end,
-				      struct mm_walk *walk)
-{
-	struct pagemap_scan_private *p = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	unsigned long categories;
-	spinlock_t *ptl;
-	int ret = 0;
-	pte_t pte;
-
-	if (~p->arg.flags & PM_SCAN_WP_MATCHING) {
-		/* Go the short route when not write-protecting pages. */
-
-		pte = huge_ptep_get(walk->mm, start, ptep);
-		categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
-
-		if (!pagemap_scan_is_interesting_page(categories, p))
-			return 0;
-
-		return pagemap_scan_output(categories, p, start, &end);
-	}
-
-	i_mmap_lock_write(vma->vm_file->f_mapping);
-	ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, ptep);
-
-	pte = huge_ptep_get(walk->mm, start, ptep);
-	categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
-
-	if (!pagemap_scan_is_interesting_page(categories, p))
-		goto out_unlock;
-
-	ret = pagemap_scan_output(categories, p, start, &end);
-	if (start == end)
-		goto out_unlock;
-
-	if (~categories & PAGE_IS_WRITTEN)
-		goto out_unlock;
-
-	if (end != start + HPAGE_SIZE) {
-		/* Partial HugeTLB page WP isn't possible. */
-		pagemap_scan_backout_range(p, start, end);
-		p->arg.walk_end = start;
-		ret = 0;
-		goto out_unlock;
-	}
-
-	make_uffd_wp_huge_pte(vma, start, ptep, pte);
-	flush_hugetlb_tlb_range(vma, start, end);
-
-out_unlock:
-	spin_unlock(ptl);
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
-
-	return ret;
-}
-#else
-#define pagemap_scan_hugetlb_entry NULL
-#endif
-
 static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
 				 int depth, struct mm_walk *walk)
 {
@@ -2773,13 +2301,6 @@ static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
 	return ret;
 }
 
-static const struct mm_walk_ops pagemap_scan_ops = {
-	.test_walk = pagemap_scan_test_walk,
-	.pmd_entry = pagemap_scan_pmd_entry,
-	.pte_hole = pagemap_scan_pte_hole,
-	.hugetlb_entry = pagemap_scan_hugetlb_entry,
-};
-
 static int pagemap_scan_get_args(struct pm_scan_arg *arg,
 				 unsigned long uarg)
 {
@@ -2877,6 +2398,135 @@ static long pagemap_scan_flush_buffer(struct pagemap_scan_private *p)
 	return n;
 }
 
+static unsigned long pagemap_set_category(struct pagemap_scan_private *p,
+				   struct pt_range_walk *ptw,
+				   enum pt_range_walk_type type)
+{
+	unsigned long categories = 0;
+
+	if (ptw->present) {
+		categories |= PAGE_IS_PRESENT;
+
+		if (type == PTW_FOLIO && !PageAnon(ptw->page))
+			categories |= PAGE_IS_FILE;
+		if (type == PTW_PFN)
+			categories |= PAGE_IS_PFNZERO;
+	} else {
+		categories |= PAGE_IS_SWAPPED;
+	}
+
+	switch (ptw->level) {
+	case PTW_PUD_LEVEL:
+		if (ptw->present) {
+			if (!pud_uffd_wp(ptw->pud))
+				categories |= PAGE_IS_WRITTEN;
+			if (pud_soft_dirty(ptw->pud))
+				categories |= PAGE_IS_SOFT_DIRTY;
+		} else {
+			if (!pud_swp_uffd_wp(ptw->pud))
+				categories |= PAGE_IS_WRITTEN;
+			if (pud_swp_soft_dirty(ptw->pud))
+				categories |= PAGE_IS_SOFT_DIRTY;
+		}
+		break;
+	case PTW_PMD_LEVEL:
+		if (ptw->present) {
+			if (!pmd_uffd_wp(ptw->pmd))
+				categories |= PAGE_IS_WRITTEN;
+			if (pmd_soft_dirty(ptw->pmd))
+				categories |= PAGE_IS_SOFT_DIRTY;
+		} else {
+			const softleaf_t entry = softleaf_from_pmd(ptw->pmd);
+
+			if (softleaf_has_pfn(entry) &&
+			    !folio_test_anon(softleaf_to_folio(entry)))
+				categories |= PAGE_IS_FILE;
+			if (!pmd_swp_uffd_wp(ptw->pmd))
+				categories |= PAGE_IS_WRITTEN;
+			if (pmd_swp_soft_dirty(ptw->pmd))
+				categories |= PAGE_IS_SOFT_DIRTY;
+		}
+		break;
+	case PTW_PTE_LEVEL:
+		if (ptw->present) {
+			if (!pte_uffd_wp(ptw->pte))
+				categories |= PAGE_IS_WRITTEN;
+			if (pte_soft_dirty(ptw->pte))
+				categories |= PAGE_IS_SOFT_DIRTY;
+		} else {
+			if (!pte_swp_uffd_wp_any(ptw->pte))
+				categories |= PAGE_IS_WRITTEN;
+			if (pte_swp_soft_dirty(ptw->pte))
+				categories |= PAGE_IS_SOFT_DIRTY;
+		}
+		break;
+	}
+
+	return categories;
+}
+
+static int pagemap_scan_walk(struct vm_area_struct *vma, struct pagemap_scan_private *p,
+			      unsigned long addr)
+{
+	int ret = 0;
+	struct pt_range_walk ptw = {
+		.mm = vma->vm_mm
+	};
+	enum pt_range_walk_type type;
+	pt_type_flags_t flags = PT_TYPE_ALL;
+
+keep_walking:
+	type = pt_range_walk_start(&ptw, vma, addr, vma->vm_end, flags);
+	while (type != PTW_DONE) {
+		unsigned long categories = p->cur_vma_category |
+					   pagemap_set_category(p, &ptw, type);
+		unsigned long curr_addr = ptw.curr_addr;
+
+		if (pagemap_scan_is_interesting_page(categories, p)) {
+			unsigned long end;
+
+			end = ptw.next_addr;
+
+			if (~p->arg.flags & PM_SCAN_WP_MATCHING)
+				goto keep_walking;
+			if (~categories & PAGE_IS_WRITTEN)
+				goto keep_walking;
+
+			ret = pagemap_scan_output(categories, p, curr_addr, &end);
+			if (curr_addr == end)
+				goto out;
+
+			if (end != curr_addr + HPAGE_SIZE) {
+				if (is_vm_hugetlb_page(ptw.vma)) {
+					/* Partial HugeTLB page WP isn't possible. */
+					pagemap_scan_backout_range(p, curr_addr, end);
+					p->arg.walk_end = curr_addr;
+					ret = 0;
+					goto keep_walking;
+				}
+				if (ptw.level == PTW_PMD_LEVEL) {
+					pt_range_walk_done(&ptw);
+					split_huge_pmd(ptw.vma, ptw.pmdp, curr_addr);
+					pagemap_scan_backout_range(p, curr_addr, end);
+					/* Relaunch now that we split the pmd */
+					goto keep_walking;
+				}
+			}
+
+			if (ptw.level == PTW_PUD_LEVEL)
+				make_uffd_wp_pud(ptw.vma, curr_addr, ptw.pudp);
+			if (ptw.level == PTW_PMD_LEVEL)
+				make_uffd_wp_pmd(ptw.vma, curr_addr, ptw.pmdp);
+			if (ptw.level == PTW_PTE_LEVEL)
+				make_uffd_wp_pte(ptw.vma, curr_addr, ptw.ptep, ptw.pte);
+		}
+		type = pt_range_walk_next(&ptw, vma, vma->vm_start, vma->vm_end, flags);
+	}
+out:
+	pt_range_walk_done(&ptw);
+	return ret;
+}
+
 static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 {
 	struct pagemap_scan_private p = {0};
@@ -2897,6 +2547,7 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 	for (walk_start = p.arg.start; walk_start < p.arg.end;
 			walk_start = p.arg.walk_end) {
 		struct mmu_notifier_range range;
+		unsigned long next;
 		long n_out;
 
 		if (fatal_signal_pending(current)) {
@@ -2915,8 +2566,21 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
-		ret = walk_page_range(mm, walk_start, p.arg.end,
-				      &pagemap_scan_ops, &p);
+		do {
+			struct vm_area_struct *vma = find_vma(mm, walk_start);
+
+			if (vma) {
+				ret = pagemap_scan_walk(vma, &p, walk_start);
+				if (ret)
+					break;
+				walk_start = min(p.arg.end, vma->vm_end);
+				next = walk_start;
+			} else {
+				walk_start = p.arg.end;
+				next = p.arg.end;
+			}
+
+		} while (next < p.arg.end);
 
 		if (p.arg.flags & PM_SCAN_WP_MATCHING)
 			mmu_notifier_invalidate_range_end(&range);
@@ -2950,6 +2614,251 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 	return ret;
 }
 
+static int pagemap_read_walk_range(struct vm_area_struct *vma, unsigned long start,
+				    struct pagemapread *pm)
+{
+	int err = 0;
+	struct pt_range_walk ptw = {
+		.mm = vma->vm_mm
+	};
+	enum pt_range_walk_type type;
+	pt_type_flags_t wflags = PT_TYPE_ALL;
+	pte_t *ptep;
+
+	wflags &= ~(PT_TYPE_NONE|PT_TYPE_PFN);
+
+	type = pt_range_walk_start(&ptw, vma, start, vma->vm_end, wflags);
+	while (type != PTW_DONE) {
+		unsigned long end;
+		u64 frame = 0, flags = 0;
+		struct page *page = NULL;
+		struct folio *folio = NULL;
+
+		end = 0;
+		switch (ptw.level) {
+		case PTW_PUD_LEVEL:
+			end = pud_addr_end(start, vma->vm_end);
+			if (vma->vm_flags & VM_SOFTDIRTY)
+				flags |= PM_SOFT_DIRTY;
+
+			if (pud_present(ptw.pud)) {
+				page = pud_page(ptw.pud);
+				folio = page_folio(page);
+				flags |= PM_PRESENT;
+
+				if (!folio_test_anon(folio))
+					flags |= PM_FILE;
+
+				if (pm->show_pfn) {
+					unsigned long hmask = huge_page_mask(hstate_vma(vma));
+
+					frame = pud_pfn(ptw.pud) +
+						((start & ~hmask) >> PAGE_SHIFT);
+				}
+			} else if (pud_swp_uffd_wp(ptw.pud)) {
+				flags |= PM_UFFD_WP;
+			}
+			break;
+		case PTW_PMD_LEVEL:
+			unsigned int idx = (start & ~PMD_MASK) >> PAGE_SHIFT;
+
+			end = pmd_addr_end(start, vma->vm_end);
+			if (vma->vm_flags & VM_SOFTDIRTY)
+				flags |= PM_SOFT_DIRTY;
+
+			if (pmd_present(ptw.pmd)) {
+				page = pmd_page(ptw.pmd);
+				flags |= PM_PRESENT;
+
+				if (pmd_soft_dirty(ptw.pmd))
+					flags |= PM_SOFT_DIRTY;
+				if (pmd_uffd_wp(ptw.pmd))
+					flags |= PM_UFFD_WP;
+				if (pm->show_pfn)
+					frame = pmd_pfn(ptw.pmd) + idx;
+			} else if (thp_migration_supported() || IS_ENABLED(CONFIG_HUGETLB_PAGE)) {
+				const softleaf_t entry = softleaf_from_pmd(ptw.pmd);
+				unsigned long offset;
+
+				if (pm->show_pfn) {
+					if (softleaf_has_pfn(entry))
+						offset = softleaf_to_pfn(entry) + idx;
+					else
+						offset = swp_offset(entry) + idx;
+					frame = swp_type(entry) |
+						(offset << MAX_SWAPFILES_SHIFT);
+				}
+
+				if (!is_vm_hugetlb_page(vma))
+					flags |= PM_SWAP;
+				if (pmd_swp_soft_dirty(ptw.pmd))
+					flags |= PM_SOFT_DIRTY;
+				if (pmd_swp_uffd_wp(ptw.pmd))
+					flags |= PM_UFFD_WP;
+
+				VM_WARN_ON_ONCE(!pmd_is_migration_entry(ptw.pmd));
+				page = softleaf_to_page(entry);
+			}
+
+			if (page) {
+				folio = page_folio(page);
+				if (!folio_test_anon(folio))
+					flags |= PM_FILE;
+			}
+
+			break;
+		case PTW_PTE_LEVEL:
+			end = pmd_addr_end(start, vma->vm_end);
+			break;
+		}
+
+		if (ptw.level == PTW_PTE_LEVEL) {
+			ptep = ptw.ptep;
+			for (; start < end; ptep++, start += PAGE_SIZE) {
+				pagemap_entry_t pme;
+
+				pme = pte_to_pagemap_entry(pm, vma, start, ptep_get(ptep));
+				err = add_to_pagemap(&pme, pm);
+				ptw.next_addr = start + PAGE_SIZE;
+				if (err)
+					break;
+			}
+		} else {
+			for (; start != end; start += PAGE_SIZE) {
+				u64 cur_flags = flags;
+				pagemap_entry_t pme;
+
+				if (folio && (flags & PM_PRESENT) &&
+				    __folio_page_mapped_exclusively(folio, page))
+					cur_flags |= PM_MMAP_EXCLUSIVE;
+
+				pme = make_pme(frame, cur_flags);
+				err = add_to_pagemap(&pme, pm);
+				if (err)
+					break;
+				if (pm->show_pfn) {
+					if (flags & PM_PRESENT)
+						frame++;
+					else if (flags & PM_SWAP)
+						frame += (1 << MAX_SWAPFILES_SHIFT);
+				}
+			}
+		}
+		type = pt_range_walk_next(&ptw, vma, vma->vm_start, vma->vm_end, wflags);
+	}
+	pt_range_walk_done(&ptw);
+
+	return err;
+}
+
+static ssize_t pagemap_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	struct mm_struct *mm = file->private_data;
+	struct pagemapread pm;
+	unsigned long src;
+	unsigned long svpfn;
+	unsigned long start_vaddr;
+	unsigned long end_vaddr;
+	int ret = 0, copied = 0;
+
+	if (!mm || !mmget_not_zero(mm))
+		goto out;
+
+	ret = -EINVAL;
+	/* file position must be aligned */
+	if ((*ppos % PM_ENTRY_BYTES) || (count % PM_ENTRY_BYTES))
+		goto out_mm;
+
+	ret = 0;
+	if (!count)
+		goto out_mm;
+
+	/* do not disclose physical addresses: attack vector */
+	pm.show_pfn = file_ns_capable(file, &init_user_ns, CAP_SYS_ADMIN);
+
+	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
+	pm.buffer = kmalloc_array(pm.len, PM_ENTRY_BYTES, GFP_KERNEL);
+	ret = -ENOMEM;
+	if (!pm.buffer)
+		goto out_mm;
+
+	src = *ppos;
+	svpfn = src / PM_ENTRY_BYTES;
+	end_vaddr = mm->task_size;
+
+	/* watch out for wraparound */
+	start_vaddr = end_vaddr;
+	if (svpfn <= (ULONG_MAX >> PAGE_SHIFT)) {
+		unsigned long end;
+
+		ret = mmap_read_lock_killable(mm);
+		if (ret)
+			goto out_free;
+		start_vaddr = untagged_addr_remote(mm, svpfn << PAGE_SHIFT);
+		mmap_read_unlock(mm);
+
+		end = start_vaddr + ((count / PM_ENTRY_BYTES) << PAGE_SHIFT);
+		if (end >= start_vaddr && end < mm->task_size)
+			end_vaddr = end;
+	}
+
+	/* Ensure the address is inside the task */
+	if (start_vaddr > mm->task_size)
+		start_vaddr = end_vaddr;
+
+	ret = 0;
+
+	while (count && (start_vaddr < end_vaddr)) {
+		int len;
+		unsigned long end;
+		unsigned long next;
+
+		pm.pos = 0;
+		end = (start_vaddr + PAGEMAP_WALK_SIZE) & PAGEMAP_WALK_MASK;
+		if (end < start_vaddr || end > end_vaddr)
+			end = end_vaddr;
+		ret = mmap_read_lock_killable(mm);
+		if (ret)
+			goto out_free;
+
+		do {
+			struct vm_area_struct *vma = find_vma(mm, start_vaddr);
+
+			if (vma) {
+				ret = pagemap_read_walk_range(vma, start_vaddr, &pm);
+				if (ret)
+					goto out_err;
+				start_vaddr = min(end, vma->vm_end);
+				next = start_vaddr;
+			} else {
+				next = end;
+			}
+		} while (next < end);
+out_err:
+		mmap_read_unlock(mm);
+
+		len = min(count, PM_ENTRY_BYTES * pm.pos);
+		if (copy_to_user(buf, pm.buffer, len)) {
+			ret = -EFAULT;
+			goto out_free;
+		}
+		copied += len;
+		buf += len;
+		count -= len;
+	}
+	*ppos += copied;
+	if (!ret || ret == PM_END_OF_BUFFER)
+		ret = copied;
+
+out_free:
+	kfree(pm.buffer);
+out_mm:
+	mmput(mm);
+out:
+	return ret;
+}
+
 static long do_pagemap_cmd(struct file *file, unsigned int cmd,
 			   unsigned long arg)
 {
@@ -2972,6 +2881,7 @@ const struct file_operations proc_pagemap_operations = {
 	.unlocked_ioctl = do_pagemap_cmd,
 	.compat_ioctl	= do_pagemap_cmd,
 };
+
 #endif /* CONFIG_PROC_PAGE_MONITOR */
 
 #ifdef CONFIG_NUMA
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 122ac50aeb09..6444625c6fbb 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -618,6 +618,19 @@ static inline bool pmd_is_device_private_entry(pmd_t pmd)
 
 #endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
+#ifdef CONFIG_HUGETLB_PAGE
+/**
+ * pud_is_migration_entry() - Does this PUD entry encode a migration entry?
+ * @pud: PUD entry.
+ *
+ * Returns: true if the PUD encodes a migration entry, otherwise false.
+ */
+static inline bool pud_is_migration_entry(pud_t pud)
+{
+	return softleaf_is_migration(softleaf_from_pud(pud));
+}
+#endif
+
 /**
  * pmd_is_migration_entry() - Does this PMD entry encode a migration entry?
  * @pmd: PMD entry.
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 6f01d5ed73f6..6f8e83a5bb08 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1229,11 +1229,21 @@ static inline pmd_t generic_pmdp_establish(struct vm_area_struct *vma,
 }
 #endif
 
+#ifndef __HAVE_ARCH_PUDP_INVALIDATE
+extern pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
+			    pud_t *pudp);
+#endif
+
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE
 extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 			    pmd_t *pmdp);
 #endif
 
+#ifndef __HAVE_ARCH_PUDP_INVALIDATE_AD
+extern pud_t pudp_invalidate_ad(struct vm_area_struct *vma,
+				unsigned long address, pud_t *pudp);
+#endif
+
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE_AD
 
 /*
@@ -1776,6 +1786,21 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
+static inline pud_t pud_swp_mksoft_dirty(pud_t pud)
+{
+	return pud;
+}
+
+static inline int pud_swp_soft_dirty(pud_t pud)
+{
+	return 0;
+}
+
+static inline pud_t pud_swp_clear_soft_dirty(pud_t pud)
+{
+	return pud;
+}
+
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
 	return pmd;
@@ -1818,6 +1843,11 @@ static inline int pmd_soft_dirty(pmd_t pmd)
 	return 0;
 }
 
+static inline int pud_soft_dirty(pud_t pud)
+{
+	return 0;
+}
+
 static inline pte_t pte_mksoft_dirty(pte_t pte)
 {
 	return pte;
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index af7966169d69..f390c93b98b2 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -206,6 +206,16 @@ pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 }
 #endif
 
+#ifndef __HAVE_ARCH_PUDP_INVALIDATE_AD
+pud_t pudp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
+			 pud_t *pudp)
+
+{
+	VM_WARN_ON_ONCE(!pud_present(*pudp));
+	return pudp_invalidate(vma, address, pudp);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE_AD
 pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma, unsigned long address,
 			 pmd_t *pmdp)
-- 
2.35.3


