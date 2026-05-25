Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12793CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE016B0098; Mon, 25 May 2026 12:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7859C6B0099; Mon, 25 May 2026 12:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64DA56B009B; Mon, 25 May 2026 12:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEA26B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:56:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC3C4C05C9
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:56:17 +0000 (UTC)
X-FDA: 84806545194.04.9634572
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 65196140010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:56:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmqaK4LqKCe/xIrhytH667Jrj1b6r62UHANrxg3Hcws=;
	b=sL6VlxN3o9D/JHjUJ8HqxqWF0OcZJVeM54no+FnIG6/3YalbmWJq5h55IBu91b8u1nEJwb
	3AORfHipMCNARtOiCIoONgspW23/9v1WWwoO1aP+PNEQFkcXeRqWcvmuRr6hmh9LheYLlP
	VTgRaONto9e9sF38Hi+rUKyh23xEAjw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728175; a=rsa-sha256;
	cv=none;
	b=fn5e3Z+DAlfxT6DxqNhDPVTdwLX805drhSvwQS4t1EsZG98+9BdvDQTmVbfwN6MCUQMIYs
	J0hzAlhhoq87wydBK47GfsFGfhz192x1lVlFXhJXe3udzwJfVumtroGtVEfssalGuzjs9p
	5uH5JvuZJ70/TI6yI9ynzOdQ37kyGaw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 562A264DF7;
	Mon, 25 May 2026 16:55:48 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E36BD59D4B;
	Mon, 25 May 2026 16:55:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cPJTNRN/FGrlRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 25 May 2026 16:55:47 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH v3 7/8] mm: Make /proc/pid/pagemap use the new generic pagewalk API
Date: Mon, 25 May 2026 18:55:27 +0200
Message-ID: <20260525165528.184397-8-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525165528.184397-1-osalvador@suse.de>
References: <20260525165528.184397-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 65196140010
X-Stat-Signature: tey468sxkqajb93qoakap8rhsrx4a3h7
X-HE-Tag: 1779728175-214468
X-HE-Meta: U2FsdGVkX18X53Jr9sEf7K4PG5zsZ+oBRwvmKhJTf1DlQT0EP/YyJ2B7T7Dr5eov8gXS3AKJHM4sVkX7QCPdw5kP1d5EVOJpvZsOmoPu5mLSewp5u7ObfqcA7QuzG1AnmHInt0tZ2eu/IUe3/E6ZKJeXGdvjL0qKhWDk1uXBqNUiuYukJzeuNrlBjmbxwn9YQONbVU61d+qAslSU+Zh50EKw+vfbRDrbaO9nMYFZWrUENNSr44SYa4EseC+42VCXOXxloInBMib3gRyUFdfCM+fmbqdIMKyUeyqjSoM4NQMlaAe7S9K6ZZSTRnhi/fbYOoRbTsPAC27WNQxpRpYf05TVSeI53ic/PLrtjEHhskgb1hq0Vn/wWiRpiiGb8LsC8DizrBglL8fPmLc/UD6LYSGEQT9X3BRhCniglxuNribfZkRfqRDkK973l2nJn3NHi41Vevww8j479unORj4mL1MvWgtGPBf1DJPwXWJv4GwrXbL5JgWBsPkwXQKA3BDizaF1OHtw7EZPcoCHFWYor3O2MbNR9yE5N7/DbcmyU/FrtQhl9WN3fGsjayc7A3ZdJXaEFSynmb6PCt6IQuWxTyT+sBtRCBGwQwzpatSCdzxWQ46P+6DjM+gdJVzqaT2mNVPLUzMDwO589hTzzqAme1TPkwez4A6aOBD8g1TU9gdzc8duQd2uJ6dr3LYUY/Rs3ub/IwizSLHklZOghLHksy3XlY/UcCVZ8BEExdNlZHojpiYGRDtfbnn0wenWvBl+YebWibjx2X+OYy6KKyul42heUXc629VmeMHCtOG2NPGiaif5xxn5AgUKQdV5oR04Im30EAZMKasKyc/h3nFR16mui/+qH55wx7a58YuO8o/naWXwshlQqJ2FcjSFyzFnjolRRjAKMDx/N9ttpY/TDMTdyitkw+ge0k59l936YloqguwQAQumMMR3WZwb1aoIg3c4WeFQ2w8DbG8I/zx
 OkkcQnRP
 OSZE4fQko7NKgeF/SVFQl/olXjxHfTxEc6kqwLaCQ5wLp1HlcH9Wo2qJsjIRellfnBEMa8GroyzZemjmDDEbCPOXw5SrYDkmNU6WAnx1an9XUPKNpW/eMYQGuOaeSppZnJtR5qo35G7My7XSrtb4zvdWBvgHOOMytmL6XZXJ1uU2s+QgBMMweN9BLSBfcnm2itXU3
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
 arch/arm64/include/asm/pgtable.h |    9 +
 arch/x86/include/asm/pgtable.h   |    5 +
 arch/x86/mm/pgtable.c            |   18 +-
 fs/proc/task_mmu.c               | 1749 +++++++++++++++---------------
 include/linux/leafops.h          |   13 +
 include/linux/pgtable.h          |   30 +
 mm/pgtable-generic.c             |   21 +
 7 files changed, 986 insertions(+), 859 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7a3c109b9e99..71719929e2e8 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -639,6 +639,7 @@ static inline pmd_t pmd_mkspecial(pmd_t pmd)
 #define pmd_pfn(pmd)		((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT)
 #define pfn_pmd(pfn,prot)	__pmd(__phys_to_pmd_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
+#define pud_mkinvalid(pud)	pte_pud(pte_mkinvalid(pud_pte(pud)))
 #define pud_dirty(pud)		pte_dirty(pud_pte(pud))
 #define pud_young(pud)		pte_young(pud_pte(pud))
 #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
@@ -1527,6 +1528,14 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 }
 #endif
 
+#define pudp_establish pudp_establish
+static inline pud_t pudp_establish(struct vm_area_struct *vma,
+				   unsigned long address, pud_t *pudp, pud_t pud)
+{
+	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
+	return __pud(xchg_relaxed(&pud_val(*pudp), pud_val(pud)));
+}
+
 /*
  * Encode and decode a swap entry:
  *	bits 0-1:	present (must be zero)
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index a3cf289948a0..7903485df8c3 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1392,10 +1392,15 @@ static inline pud_t pudp_establish(struct vm_area_struct *vma,
 }
 #endif
 
+#define __HAVE_ARCH_PUDP_INVALIDATE_AD
+extern pud_t pudp_invalidate_ad(struct vm_area_struct *vma,
+				unsigned long address, pud_t *pudp);
+
 #define __HAVE_ARCH_PMDP_INVALIDATE_AD
 extern pmd_t pmdp_invalidate_ad(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp);
 
+#define __HAVE_ARCH_PUDP_INVALIDATE
 pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		      pud_t *pudp);
 
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index da7f0a03cf90..85b912397afa 100644
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
index b9ca47f0bc18..20ffb26692cc 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1785,46 +1785,6 @@ static bool __folio_page_mapped_exclusively(struct folio *folio, struct page *pa
 	return !folio_maybe_mapped_shared(folio);
 }
 
-static int pagemap_pte_hole(unsigned long start, unsigned long end,
-			    __always_unused int depth, struct mm_walk *walk)
-{
-	struct pagemapread *pm = walk->private;
-	unsigned long addr = start;
-	int err = 0;
-
-	while (addr < end) {
-		struct vm_area_struct *vma = find_vma(walk->mm, addr);
-		pagemap_entry_t pme = make_pme(0, 0);
-		/* End of address space hole, which we mark as non-present. */
-		unsigned long hole_end;
-
-		if (vma)
-			hole_end = min(end, vma->vm_start);
-		else
-			hole_end = end;
-
-		for (; addr < hole_end; addr += PAGE_SIZE) {
-			err = add_to_pagemap(&pme, pm);
-			if (err)
-				goto out;
-		}
-
-		if (!vma)
-			break;
-
-		/* Addresses in the VMA. */
-		if (vma->vm_flags & VM_SOFTDIRTY)
-			pme = make_pme(0, PM_SOFT_DIRTY);
-		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
-			err = add_to_pagemap(&pme, pm);
-			if (err)
-				goto out;
-		}
-	}
-out:
-	return err;
-}
-
 static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
@@ -1891,357 +1851,173 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 	return make_pme(frame, flags);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
-		unsigned long end, struct vm_area_struct *vma,
-		struct pagemapread *pm)
+struct pagemap_scan_private {
+	struct pm_scan_arg arg;
+	unsigned long masks_of_interest, cur_vma_category;
+	struct page_region *vec_buf;
+	unsigned long vec_buf_len, vec_buf_index, found_pages;
+	struct page_region __user *vec_out;
+};
+
+static bool pagemap_scan_is_interesting_page(unsigned long categories,
+					     const struct pagemap_scan_private *p)
 {
-	unsigned int idx = (addr & ~PMD_MASK) >> PAGE_SHIFT;
-	u64 flags = 0, frame = 0;
-	pmd_t pmd = *pmdp;
-	struct page *page = NULL;
-	struct folio *folio = NULL;
-	int err = 0;
+	categories ^= p->arg.category_inverted;
+	if ((categories & p->arg.category_mask) != p->arg.category_mask)
+		return false;
+	if (p->arg.category_anyof_mask && !(categories & p->arg.category_anyof_mask))
+		return false;
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
-		flags |= PM_SOFT_DIRTY;
+	return true;
+}
 
-	if (pmd_none(pmd))
-		goto populate_pagemap;
+#ifdef CONFIG_HUGETLB_PAGE
+static void make_uffd_wp_pud(struct vm_area_struct *vma,
+			     unsigned long addr, pud_t *pudp)
+{
+	pud_t old, pud = *pudp;
 
-	if (pmd_present(pmd)) {
-		page = pmd_page(pmd);
+	if (pud_present(pud)) {
+		old = pudp_invalidate_ad(vma, addr, pudp);
+		pud = pud_mkuffd_wp(old);
+		set_pud_at(vma->vm_mm, addr, pudp, pud);
+	} else if (pud_is_migration_entry(pud)) {
+		pud = pud_swp_mkuffd_wp(pud);
+		set_pud_at(vma->vm_mm, addr, pudp, pud);
+	}
+}
+#else
+static void make_uffd_wp_pud(struct vm_area_struct *vma,
+			     unsigned long addr, pud_t *pudp)
+{
+}
+#endif
 
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
+static void make_uffd_wp_pmd(struct vm_area_struct *vma,
+			     unsigned long addr, pmd_t *pmdp)
+{
+	pmd_t old, pmd = *pmdp;
 
-	if (page) {
-		folio = page_folio(page);
-		if (!folio_test_anon(folio))
-			flags |= PM_FILE;
+	if (pmd_present(pmd)) {
+		old = pmdp_invalidate_ad(vma, addr, pmdp);
+		pmd = pmd_mkuffd_wp(old);
+		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
+	} else if (pmd_is_migration_entry(pmd)) {
+		pmd = pmd_swp_mkuffd_wp(pmd);
+		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
+}
 
-populate_pagemap:
-	for (; addr != end; addr += PAGE_SIZE, idx++) {
-		u64 cur_flags = flags;
-		pagemap_entry_t pme;
-
-		if (folio && (flags & PM_PRESENT) &&
-		    __folio_page_mapped_exclusively(folio, page))
-			cur_flags |= PM_MMAP_EXCLUSIVE;
+static void make_uffd_wp_pte(struct vm_area_struct *vma,
+			     unsigned long addr, pte_t *pte, pte_t ptent)
+{
+	if (pte_present(ptent)) {
+		pte_t old_pte;
 
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
+		old_pte = ptep_modify_prot_start(vma, addr, pte);
+		ptent = pte_mkuffd_wp(old_pte);
+		ptep_modify_prot_commit(vma, addr, pte, old_pte, ptent);
+	} else if (pte_none(ptent)) {
+		set_pte_at(vma->vm_mm, addr, pte,
+			   make_pte_marker(PTE_MARKER_UFFD_WP));
+	} else {
+		ptent = pte_swp_mkuffd_wp(ptent);
+		set_pte_at(vma->vm_mm, addr, pte, ptent);
 	}
-	return err;
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
-			     struct mm_walk *walk)
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE)
+static void pagemap_scan_backout_range(struct pagemap_scan_private *p,
+				       unsigned long addr, unsigned long end)
 {
-	struct vm_area_struct *vma = walk->vma;
-	struct pagemapread *pm = walk->private;
-	spinlock_t *ptl;
-	pte_t *pte, *orig_pte;
-	int err = 0;
+	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	ptl = pmd_trans_huge_lock(pmdp, vma);
-	if (ptl) {
-		err = pagemap_pmd_range_thp(pmdp, addr, end, vma, pm);
-		spin_unlock(ptl);
-		return err;
-	}
+	if (!p->vec_buf)
+		return;
+
+	if (cur_buf->start != addr)
+		cur_buf->end = addr;
+	else
+		cur_buf->start = cur_buf->end = 0;
+
+	p->found_pages -= (end - addr) / PAGE_SIZE;
+}
 #endif
 
+static bool pagemap_scan_push_range(unsigned long categories,
+				    struct pagemap_scan_private *p,
+				    unsigned long addr, unsigned long end)
+{
+	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
+
 	/*
-	 * We can assume that @vma always points to a valid one and @end never
-	 * goes beyond vma->vm_end.
+	 * When there is no output buffer provided at all, the sentinel values
+	 * won't match here. There is no other way for `cur_buf->end` to be
+	 * non-zero other than it being non-empty.
 	 */
-	orig_pte = pte = pte_offset_map_lock(walk->mm, pmdp, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
-		return err;
+	if (addr == cur_buf->end && categories == cur_buf->categories) {
+		cur_buf->end = end;
+		return true;
 	}
-	for (; addr < end; pte++, addr += PAGE_SIZE) {
-		pagemap_entry_t pme;
 
-		pme = pte_to_pagemap_entry(pm, vma, addr, ptep_get(pte));
-		err = add_to_pagemap(&pme, pm);
-		if (err)
-			break;
+	if (cur_buf->end) {
+		if (p->vec_buf_index >= p->vec_buf_len - 1)
+			return false;
+
+		cur_buf = &p->vec_buf[++p->vec_buf_index];
 	}
-	pte_unmap_unlock(orig_pte, ptl);
 
-	cond_resched();
+	cur_buf->start = addr;
+	cur_buf->end = end;
+	cur_buf->categories = categories;
 
-	return err;
+	return true;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE
-/* This function walks within one hugetlb entry in the single call */
-static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
-				 unsigned long addr, unsigned long end,
-				 struct mm_walk *walk)
+static int pagemap_scan_output(unsigned long categories,
+			       struct pagemap_scan_private *p,
+			       unsigned long addr, unsigned long *end)
 {
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
+	unsigned long n_pages, total_pages;
+	int ret = 0;
 
-		if (!folio_test_anon(folio))
-			flags |= PM_FILE;
+	if (!p->vec_buf)
+		return 0;
 
-		if (!folio_maybe_mapped_shared(folio) &&
-		    !hugetlb_pmd_shared(ptep))
-			flags |= PM_MMAP_EXCLUSIVE;
+	categories &= p->arg.return_mask;
 
-		if (huge_pte_uffd_wp(pte))
-			flags |= PM_UFFD_WP;
+	n_pages = (*end - addr) / PAGE_SIZE;
+	if (check_add_overflow(p->found_pages, n_pages, &total_pages) ||
+	    total_pages > p->arg.max_pages) {
+		size_t n_too_much = total_pages - p->arg.max_pages;
 
-		flags |= PM_PRESENT;
-		if (pm->show_pfn)
-			frame = pte_pfn(pte) +
-				((addr & ~hmask) >> PAGE_SHIFT);
-	} else if (pte_swp_uffd_wp_any(pte)) {
-		flags |= PM_UFFD_WP;
+		*end -= n_too_much * PAGE_SIZE;
+		n_pages -= n_too_much;
+		ret = -ENOSPC;
 	}
 
-	for (; addr != end; addr += PAGE_SIZE) {
-		pagemap_entry_t pme = make_pme(frame, flags);
-
-		err = add_to_pagemap(&pme, pm);
-		if (err)
-			break;
-		if (pm->show_pfn && (flags & PM_PRESENT))
-			frame++;
+	if (!pagemap_scan_push_range(categories, p, addr, *end)) {
+		*end = addr;
+		n_pages = 0;
+		ret = -ENOSPC;
 	}
 
-	spin_unlock(ptl);
-	cond_resched();
+	p->found_pages += n_pages;
+	if (ret)
+		p->arg.walk_end = *end;
 
-	return err;
+	return ret;
 }
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
 
-/*
- * /proc/pid/pagemap - an array mapping virtual pages to pfns
- *
- * For each page in the address space, this file contains one 64-bit entry
- * consisting of the following:
- *
- * Bits 0-54  page frame number (PFN) if present
- * Bits 0-4   swap type if swapped
- * Bits 5-54  swap offset if swapped
- * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
- * Bit  56    page exclusively mapped
- * Bit  57    pte is uffd-wp write-protected
- * Bit  58    pte is a guard region
- * Bits 59-60 zero
- * Bit  61    page is file-page or shared-anon
- * Bit  62    page swapped
- * Bit  63    page present
- *
- * If the page is not present but in swap, then the PFN contains an
- * encoding of the swap file number and the page's offset into the
- * swap. Unmapped pages return a null PFN. This allows determining
- * precisely which pages are mapped (or in swap) and comparing mapped
- * pages between processes.
- *
- * Efficient users of this interface will use /proc/pid/maps to
- * determine which areas of memory are actually mapped and llseek to
- * skip over unmapped regions.
- */
-static ssize_t pagemap_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *ppos)
+static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
+					   struct vm_area_struct *vma,
+					   unsigned long addr, pte_t pte)
 {
-	struct mm_struct *mm = file->private_data;
-	struct pagemapread pm;
-	unsigned long src;
-	unsigned long svpfn;
-	unsigned long start_vaddr;
-	unsigned long end_vaddr;
-	int ret = 0, copied = 0;
+	unsigned long categories;
 
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
-
-static int pagemap_open(struct inode *inode, struct file *file)
-{
-	struct mm_struct *mm;
-
-	mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR_OR_NULL(mm))
-		return mm ? PTR_ERR(mm) : -ESRCH;
-	file->private_data = mm;
-	return 0;
-}
-
-static int pagemap_release(struct inode *inode, struct file *file)
-{
-	struct mm_struct *mm = file->private_data;
-
-	if (mm)
-		mmdrop(mm);
-	return 0;
-}
-
-#define PM_SCAN_CATEGORIES	(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
-				 PAGE_IS_FILE |	PAGE_IS_PRESENT |	\
-				 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
-				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY |	\
-				 PAGE_IS_GUARD)
-#define PM_SCAN_FLAGS		(PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC)
-
-struct pagemap_scan_private {
-	struct pm_scan_arg arg;
-	unsigned long masks_of_interest, cur_vma_category;
-	struct page_region *vec_buf;
-	unsigned long vec_buf_len, vec_buf_index, found_pages;
-	struct page_region __user *vec_out;
-};
-
-static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
-					   struct vm_area_struct *vma,
-					   unsigned long addr, pte_t pte)
-{
-	unsigned long categories;
-
-	if (pte_none(pte))
-		return 0;
+	if (pte_none(pte))
+		return 0;
 
 	if (pte_present(pte)) {
 		struct page *page;
@@ -2284,122 +2060,7 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 	return categories;
 }
 
-static void make_uffd_wp_pte(struct vm_area_struct *vma,
-			     unsigned long addr, pte_t *pte, pte_t ptent)
-{
-	if (pte_present(ptent)) {
-		pte_t old_pte;
-
-		old_pte = ptep_modify_prot_start(vma, addr, pte);
-		ptent = pte_mkuffd_wp(old_pte);
-		ptep_modify_prot_commit(vma, addr, pte, old_pte, ptent);
-	} else if (pte_none(ptent)) {
-		set_pte_at(vma->vm_mm, addr, pte,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
-	} else {
-		ptent = pte_swp_mkuffd_wp(ptent);
-		set_pte_at(vma->vm_mm, addr, pte, ptent);
-	}
-}
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
-					  struct vm_area_struct *vma,
-					  unsigned long addr, pmd_t pmd)
-{
-	unsigned long categories = PAGE_IS_HUGE;
-
-	if (pmd_none(pmd))
-		return categories;
-
-	if (pmd_present(pmd)) {
-		struct page *page;
-
-		categories |= PAGE_IS_PRESENT;
-		if (!pmd_uffd_wp(pmd))
-			categories |= PAGE_IS_WRITTEN;
-
-		if (p->masks_of_interest & PAGE_IS_FILE) {
-			page = vm_normal_page_pmd(vma, addr, pmd);
-			if (page && !PageAnon(page))
-				categories |= PAGE_IS_FILE;
-		}
-
-		if (is_huge_zero_pmd(pmd))
-			categories |= PAGE_IS_PFNZERO;
-		if (pmd_soft_dirty(pmd))
-			categories |= PAGE_IS_SOFT_DIRTY;
-	} else {
-		categories |= PAGE_IS_SWAPPED;
-		if (!pmd_swp_uffd_wp(pmd))
-			categories |= PAGE_IS_WRITTEN;
-		if (pmd_swp_soft_dirty(pmd))
-			categories |= PAGE_IS_SOFT_DIRTY;
-
-		if (p->masks_of_interest & PAGE_IS_FILE) {
-			const softleaf_t entry = softleaf_from_pmd(pmd);
-
-			if (softleaf_has_pfn(entry) &&
-			    !folio_test_anon(softleaf_to_folio(entry)))
-				categories |= PAGE_IS_FILE;
-		}
-	}
-
-	return categories;
-}
-
-static void make_uffd_wp_pmd(struct vm_area_struct *vma,
-			     unsigned long addr, pmd_t *pmdp)
-{
-	pmd_t old, pmd = *pmdp;
-
-	if (pmd_present(pmd)) {
-		old = pmdp_invalidate_ad(vma, addr, pmdp);
-		pmd = pmd_mkuffd_wp(old);
-		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
-		pmd = pmd_swp_mkuffd_wp(pmd);
-		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	}
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
 #ifdef CONFIG_HUGETLB_PAGE
-static unsigned long pagemap_hugetlb_category(pte_t pte)
-{
-	unsigned long categories = PAGE_IS_HUGE;
-
-	if (pte_none(pte))
-		return categories;
-
-	/*
-	 * According to pagemap_hugetlb_range(), file-backed HugeTLB
-	 * page cannot be swapped. So PAGE_IS_FILE is not checked for
-	 * swapped pages.
-	 */
-	if (pte_present(pte)) {
-		categories |= PAGE_IS_PRESENT;
-
-		if (!huge_pte_uffd_wp(pte))
-			categories |= PAGE_IS_WRITTEN;
-		if (!PageAnon(pte_page(pte)))
-			categories |= PAGE_IS_FILE;
-		if (is_zero_pfn(pte_pfn(pte)))
-			categories |= PAGE_IS_PFNZERO;
-		if (pte_soft_dirty(pte))
-			categories |= PAGE_IS_SOFT_DIRTY;
-	} else {
-		categories |= PAGE_IS_SWAPPED;
-
-		if (!pte_swp_uffd_wp_any(pte))
-			categories |= PAGE_IS_WRITTEN;
-		if (pte_swp_soft_dirty(pte))
-			categories |= PAGE_IS_SOFT_DIRTY;
-	}
-
-	return categories;
-}
-
 static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
 				  unsigned long addr, pte_t *ptep,
 				  pte_t ptent)
@@ -2424,497 +2085,535 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
 		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
 					     huge_pte_mkuffd_wp(ptent));
 }
-#endif /* CONFIG_HUGETLB_PAGE */
-
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE)
-static void pagemap_scan_backout_range(struct pagemap_scan_private *p,
-				       unsigned long addr, unsigned long end)
+#else
+static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
+				  unsigned long addr, pte_t *ptep,
+				  pte_t ptent)
 {
-	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
-
-	if (!p->vec_buf)
-		return;
-
-	if (cur_buf->start != addr)
-		cur_buf->end = addr;
-	else
-		cur_buf->start = cur_buf->end = 0;
-
-	p->found_pages -= (end - addr) / PAGE_SIZE;
 }
 #endif
 
-static bool pagemap_scan_is_interesting_page(unsigned long categories,
-					     const struct pagemap_scan_private *p)
-{
-	categories ^= p->arg.category_inverted;
-	if ((categories & p->arg.category_mask) != p->arg.category_mask)
-		return false;
-	if (p->arg.category_anyof_mask && !(categories & p->arg.category_anyof_mask))
-		return false;
-
-	return true;
-}
-
-static bool pagemap_scan_is_interesting_vma(unsigned long categories,
-					    const struct pagemap_scan_private *p)
-{
-	unsigned long required = p->arg.category_mask & PAGE_IS_WPALLOWED;
-
-	categories ^= p->arg.category_inverted;
-	if ((categories & required) != required)
-		return false;
-
-	return true;
-}
-
-static int pagemap_scan_test_walk(unsigned long start, unsigned long end,
-				  struct mm_walk *walk)
-{
-	struct pagemap_scan_private *p = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	unsigned long vma_category = 0;
-	bool wp_allowed = userfaultfd_wp_async(vma) &&
-	    userfaultfd_wp_use_markers(vma);
-
-	if (!wp_allowed) {
-		/* User requested explicit failure over wp-async capability */
-		if (p->arg.flags & PM_SCAN_CHECK_WPASYNC)
-			return -EPERM;
-		/*
-		 * User requires wr-protect, and allows silently skipping
-		 * unsupported vmas.
-		 */
-		if (p->arg.flags & PM_SCAN_WP_MATCHING)
-			return 1;
-		/*
-		 * Then the request doesn't involve wr-protects at all,
-		 * fall through to the rest checks, and allow vma walk.
-		 */
-	}
-
-	if (vma->vm_flags & VM_PFNMAP)
-		return 1;
-
-	if (wp_allowed)
-		vma_category |= PAGE_IS_WPALLOWED;
-
-	if (vma->vm_flags & VM_SOFTDIRTY)
-		vma_category |= PAGE_IS_SOFT_DIRTY;
+/*
+ * /proc/pid/pagemap - an array mapping virtual pages to pfns
+ *
+ * For each page in the address space, this file contains one 64-bit entry
+ * consisting of the following:
+ *
+ * Bits 0-54  page frame number (PFN) if present
+ * Bits 0-4   swap type if swapped
+ * Bits 5-54  swap offset if swapped
+ * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
+ * Bit  56    page exclusively mapped
+ * Bit  57    pte is uffd-wp write-protected
+ * Bit  58    pte is a guard region
+ * Bits 59-60 zero
+ * Bit  61    page is file-page or shared-anon
+ * Bit  62    page swapped
+ * Bit  63    page present
+ *
+ * If the page is not present but in swap, then the PFN contains an
+ * encoding of the swap file number and the page's offset into the
+ * swap. Unmapped pages return a null PFN. This allows determining
+ * precisely which pages are mapped (or in swap) and comparing mapped
+ * pages between processes.
+ *
+ * Efficient users of this interface will use /proc/pid/maps to
+ * determine which areas of memory are actually mapped and llseek to
+ * skip over unmapped regions.
+ */
 
-	if (!pagemap_scan_is_interesting_vma(vma_category, p))
-		return 1;
+/*
+ * /proc/pid/pagemap - an array mapping virtual pages to pfns
+ *
+ * For each page in the address space, this file contains one 64-bit entry
+ * consisting of the following:
+ *
+ * Bits 0-54  page frame number (PFN) if present
+ * Bits 0-4   swap type if swapped
+ * Bits 5-54  swap offset if swapped
+ * Bit  55    pte is soft-dirty (see Documentation/admin-guide/mm/soft-dirty.rst)
+ * Bit  56    page exclusively mapped
+ * Bit  57    pte is uffd-wp write-protected
+ * Bit  58    pte is a guard region
+ * Bits 59-60 zero
+ * Bit  61    page is file-page or shared-anon
+ * Bit  62    page swapped
+ * Bit  63    page present
+ *
+ * If the page is not present but in swap, then the PFN contains an
+ * encoding of the swap file number and the page's offset into the
+ * swap. Unmapped pages return a null PFN. This allows determining
+ * precisely which pages are mapped (or in swap) and comparing mapped
+ * pages between processes.
+ *
+ * Efficient users of this interface will use /proc/pid/maps to
+ * determine which areas of memory are actually mapped and llseek to
+ * skip over unmapped regions.
+ */
 
-	p->cur_vma_category = vma_category;
+static int pagemap_open(struct inode *inode, struct file *file)
+{
+	struct mm_struct *mm;
 
+	mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR_OR_NULL(mm))
+		return mm ? PTR_ERR(mm) : -ESRCH;
+	file->private_data = mm;
 	return 0;
 }
 
-static bool pagemap_scan_push_range(unsigned long categories,
-				    struct pagemap_scan_private *p,
-				    unsigned long addr, unsigned long end)
+static int pagemap_release(struct inode *inode, struct file *file)
 {
-	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
+	struct mm_struct *mm = file->private_data;
 
-	/*
-	 * When there is no output buffer provided at all, the sentinel values
-	 * won't match here. There is no other way for `cur_buf->end` to be
-	 * non-zero other than it being non-empty.
-	 */
-	if (addr == cur_buf->end && categories == cur_buf->categories) {
-		cur_buf->end = end;
-		return true;
-	}
+	if (mm)
+		mmdrop(mm);
+	return 0;
+}
 
-	if (cur_buf->end) {
-		if (p->vec_buf_index >= p->vec_buf_len - 1)
-			return false;
+#define PM_SCAN_CATEGORIES	(PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |	\
+				 PAGE_IS_FILE |	PAGE_IS_PRESENT |	\
+				 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
+				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY |	\
+				 PAGE_IS_GUARD)
+#define PM_SCAN_FLAGS		(PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC)
 
-		cur_buf = &p->vec_buf[++p->vec_buf_index];
-	}
+static bool pagemap_scan_is_interesting_vma(unsigned long categories,
+					    const struct pagemap_scan_private *p)
+{
+	unsigned long required = p->arg.category_mask & PAGE_IS_WPALLOWED;
 
-	cur_buf->start = addr;
-	cur_buf->end = end;
-	cur_buf->categories = categories;
+	categories ^= p->arg.category_inverted;
+	if ((categories & required) != required)
+		return false;
 
 	return true;
 }
 
-static int pagemap_scan_output(unsigned long categories,
-			       struct pagemap_scan_private *p,
-			       unsigned long addr, unsigned long *end)
+static int pagemap_scan_get_args(struct pm_scan_arg *arg,
+				 unsigned long uarg)
 {
-	unsigned long n_pages, total_pages;
-	int ret = 0;
+	if (copy_from_user(arg, (void __user *)uarg, sizeof(*arg)))
+		return -EFAULT;
 
-	if (!p->vec_buf)
-		return 0;
+	if (arg->size != sizeof(struct pm_scan_arg))
+		return -EINVAL;
 
-	categories &= p->arg.return_mask;
+	/* Validate requested features */
+	if (arg->flags & ~PM_SCAN_FLAGS)
+		return -EINVAL;
+	if ((arg->category_inverted | arg->category_mask |
+	     arg->category_anyof_mask | arg->return_mask) & ~PM_SCAN_CATEGORIES)
+		return -EINVAL;
 
-	n_pages = (*end - addr) / PAGE_SIZE;
-	if (check_add_overflow(p->found_pages, n_pages, &total_pages) ||
-	    total_pages > p->arg.max_pages) {
-		size_t n_too_much = total_pages - p->arg.max_pages;
-		*end -= n_too_much * PAGE_SIZE;
-		n_pages -= n_too_much;
-		ret = -ENOSPC;
-	}
+	arg->start = untagged_addr((unsigned long)arg->start);
+	arg->end = untagged_addr((unsigned long)arg->end);
+	arg->vec = untagged_addr((unsigned long)arg->vec);
 
-	if (!pagemap_scan_push_range(categories, p, addr, *end)) {
-		*end = addr;
-		n_pages = 0;
-		ret = -ENOSPC;
-	}
+	/* Validate memory pointers */
+	if (!IS_ALIGNED(arg->start, PAGE_SIZE))
+		return -EINVAL;
+	if (!access_ok((void __user *)(long)arg->start, arg->end - arg->start))
+		return -EFAULT;
+	if (!arg->vec && arg->vec_len)
+		return -EINVAL;
+	if (UINT_MAX == SIZE_MAX && arg->vec_len > SIZE_MAX)
+		return -EINVAL;
+	if (arg->vec && !access_ok((void __user *)(long)arg->vec,
+				   size_mul(arg->vec_len, sizeof(struct page_region))))
+		return -EFAULT;
 
-	p->found_pages += n_pages;
-	if (ret)
-		p->arg.walk_end = *end;
+	/* Fixup default values */
+	arg->end = ALIGN(arg->end, PAGE_SIZE);
+	arg->walk_end = 0;
+	if (!arg->max_pages)
+		arg->max_pages = ULONG_MAX;
 
-	return ret;
+	return 0;
 }
 
-static int pagemap_scan_thp_entry(pmd_t *pmd, unsigned long start,
-				  unsigned long end, struct mm_walk *walk)
+static int pagemap_scan_writeback_args(struct pm_scan_arg *arg,
+				       unsigned long uargl)
 {
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
+	struct pm_scan_arg __user *uarg	= (void __user *)uargl;
 
-	categories = p->cur_vma_category |
-		     pagemap_thp_category(p, vma, start, *pmd);
+	if (copy_to_user(&uarg->walk_end, &arg->walk_end, sizeof(arg->walk_end)))
+		return -EFAULT;
 
-	if (!pagemap_scan_is_interesting_page(categories, p))
-		goto out_unlock;
+	return 0;
+}
 
-	ret = pagemap_scan_output(categories, p, start, &end);
-	if (start == end)
-		goto out_unlock;
+static int pagemap_scan_init_bounce_buffer(struct pagemap_scan_private *p)
+{
+	if (!p->arg.vec_len)
+		return 0;
 
-	if (~p->arg.flags & PM_SCAN_WP_MATCHING)
-		goto out_unlock;
-	if (~categories & PAGE_IS_WRITTEN)
-		goto out_unlock;
+	p->vec_buf_len = min_t(size_t, PAGEMAP_WALK_SIZE >> PAGE_SHIFT,
+			       p->arg.vec_len);
+	p->vec_buf = kmalloc_objs(*p->vec_buf, p->vec_buf_len);
+	if (!p->vec_buf)
+		return -ENOMEM;
 
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
+	p->vec_buf->start = p->vec_buf->end = 0;
+	p->vec_out = (struct page_region __user *)(long)p->arg.vec;
 
-	make_uffd_wp_pmd(vma, start, pmd);
-	flush_tlb_range(vma, start, end);
-out_unlock:
-	spin_unlock(ptl);
-	return ret;
-#else /* !CONFIG_TRANSPARENT_HUGEPAGE */
-	return -ENOENT;
-#endif
+	return 0;
 }
 
-static int pagemap_scan_pmd_entry(pmd_t *pmd, unsigned long start,
-				  unsigned long end, struct mm_walk *walk)
+static long pagemap_scan_flush_buffer(struct pagemap_scan_private *p)
 {
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
+	const struct page_region *buf = p->vec_buf;
+	long n = p->vec_buf_index;
 
-	ret = 0;
-	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, start, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!p->vec_buf)
 		return 0;
-	}
 
-	lazy_mmu_mode_enable();
+	if (buf[n].end != buf[n].start)
+		n++;
 
-	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
-		/* Fast path for performing exclusive WP */
-		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
-			pte_t ptent = ptep_get(pte);
+	if (!n)
+		return 0;
 
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
+	if (copy_to_user(p->vec_out, buf, n * sizeof(*buf)))
+		return -EFAULT;
 
-	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
-	    p->arg.category_mask == PAGE_IS_WRITTEN &&
-	    p->arg.return_mask == PAGE_IS_WRITTEN) {
-		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
-			unsigned long next = addr + PAGE_SIZE;
-			pte_t ptent = ptep_get(pte);
+	p->arg.vec_len -= n;
+	p->vec_out += n;
 
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
+	p->vec_buf_index = 0;
+	p->vec_buf_len = min_t(size_t, p->vec_buf_len, p->arg.vec_len);
+	p->vec_buf->start = p->vec_buf->end = 0;
 
-	for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
-		pte_t ptent = ptep_get(pte);
-		unsigned long categories = p->cur_vma_category |
-					   pagemap_page_category(p, vma, addr, ptent);
-		unsigned long next = addr + PAGE_SIZE;
+	return n;
+}
 
-		if (!pagemap_scan_is_interesting_page(categories, p))
-			continue;
+static unsigned long pagemap_set_category(struct pagemap_scan_private *p,
+				   struct pt_range_walk *ptw,
+				   enum pt_range_walk_type type)
+{
+	unsigned long categories = 0;
 
-		ret = pagemap_scan_output(categories, p, addr, &next);
-		if (next == addr)
-			break;
+	if (ptw->level != PTW_PTE_LEVEL)
+		categories |= PAGE_IS_HUGE;
 
-		if (~p->arg.flags & PM_SCAN_WP_MATCHING)
-			continue;
-		if (~categories & PAGE_IS_WRITTEN)
-			continue;
+	if (ptw->present) {
+		categories |= PAGE_IS_PRESENT;
 
-		make_uffd_wp_pte(vma, addr, pte, ptent);
-		if (!flush_end)
-			start = addr;
-		flush_end = next;
+		if (type == PTW_FOLIO && !PageAnon(ptw->page))
+			categories |= PAGE_IS_FILE;
+		if (type == PTW_PFN)
+			categories |= PAGE_IS_PFNZERO;
+	} else {
+		categories |= PAGE_IS_SWAPPED;
 	}
 
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
+			if (p->masks_of_interest & PAGE_IS_FILE) {
+				const softleaf_t entry = softleaf_from_pmd(ptw->pmd);
 
-		pte = huge_ptep_get(walk->mm, start, ptep);
-		categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+				if (softleaf_has_pfn(entry) &&
+				    !folio_test_anon(softleaf_to_folio(entry)))
+					categories |= PAGE_IS_FILE;
+			}
 
-		if (!pagemap_scan_is_interesting_page(categories, p))
-			return 0;
+			if (!pmd_swp_uffd_wp(ptw->pmd))
+				categories |= PAGE_IS_WRITTEN;
 
-		return pagemap_scan_output(categories, p, start, &end);
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
 	}
 
-	i_mmap_lock_write(vma->vm_file->f_mapping);
-	ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, ptep);
-
-	pte = huge_ptep_get(walk->mm, start, ptep);
-	categories = p->cur_vma_category | pagemap_hugetlb_category(pte);
+	return categories;
+}
 
-	if (!pagemap_scan_is_interesting_page(categories, p))
-		goto out_unlock;
+static int pagemap_scan_walk(struct vm_area_struct *vma, struct pagemap_scan_private *p,
+			      unsigned long addr)
+{
+	int ret = 0;
+	struct pt_range_walk ptw = {
+		.mm = vma->vm_mm
+	};
+	enum pt_range_walk_type type;
+	pt_type_flags_t flags = PT_TYPE_ALL;
 
-	ret = pagemap_scan_output(categories, p, start, &end);
-	if (start == end)
-		goto out_unlock;
+start_again:
+	type = pt_range_walk_start(&ptw, vma, addr, vma->vm_end, flags);
+	while (type != PTW_DONE) {
+		bool must_return = false;
+		unsigned long categories = p->cur_vma_category |
+					   pagemap_set_category(p, &ptw, type);
+		unsigned long addr;
+		unsigned long flush_end = 0;
+		unsigned long end = ptw.next_addr;
+		unsigned long curr_addr = ptw.curr_addr;
+		pte_t *ptep;
 
-	if (~categories & PAGE_IS_WRITTEN)
-		goto out_unlock;
+		addr = curr_addr;
 
-	if (end != start + HPAGE_SIZE) {
-		/* Partial HugeTLB page WP isn't possible. */
-		pagemap_scan_backout_range(p, start, end);
-		p->arg.walk_end = start;
-		ret = 0;
-		goto out_unlock;
-	}
+		if (type == PTW_NONE) {
+			int err;
 
-	make_uffd_wp_huge_pte(vma, start, ptep, pte);
-	flush_hugetlb_tlb_range(vma, start, end);
+			if (!vma || !pagemap_scan_is_interesting_page(p->cur_vma_category, p))
+				goto keep_walking;
 
-out_unlock:
-	spin_unlock(ptl);
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+			ret = pagemap_scan_output(p->cur_vma_category, p, addr, &end);
+			if (curr_addr == end)
+				goto out;
+			if (~p->arg.flags & PM_SCAN_WP_MATCHING)
+				goto keep_walking;
 
-	return ret;
-}
-#else
-#define pagemap_scan_hugetlb_entry NULL
-#endif
+			err = uffd_wp_range(vma, curr_addr, end - curr_addr, true);
+			if (err < 0) {
+				ret = err;
+				goto out;
+			}
+			goto keep_walking;
+		}
 
-static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
-				 int depth, struct mm_walk *walk)
-{
-	struct pagemap_scan_private *p = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	int ret, err;
+		if (ptw.level != PTW_PTE_LEVEL) {
+			if (!pagemap_scan_is_interesting_page(categories, p))
+				goto keep_walking;
 
-	if (!vma || !pagemap_scan_is_interesting_page(p->cur_vma_category, p))
-		return 0;
+			ret = pagemap_scan_output(categories, p, curr_addr, &end);
+			if (curr_addr == end)
+				goto out;
 
-	ret = pagemap_scan_output(p->cur_vma_category, p, addr, &end);
-	if (addr == end)
-		return ret;
+			if (~p->arg.flags & PM_SCAN_WP_MATCHING) {
+				if (ret)
+					goto out;
+				else
+					goto keep_walking;
+			}
 
-	if (~p->arg.flags & PM_SCAN_WP_MATCHING)
-		return ret;
+			if (~categories & PAGE_IS_WRITTEN)
+				goto keep_walking;
 
-	err = uffd_wp_range(vma, addr, end - addr, true);
-	if (err < 0)
-		ret = err;
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
+					goto start_again;
+				}
+			}
+		} else {
+			lazy_mmu_mode_enable();
+			ptep = ptw.ptep;
+			if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
+				for (addr = curr_addr; addr != end; ptep++, addr += PAGE_SIZE) {
+					pte_t ptent = ptep_get(ptep);
+
+					ptw.next_addr = addr + PAGE_SIZE;
+					if ((pte_present(ptent) && pte_uffd_wp(ptent)) ||
+					    pte_swp_uffd_wp_any(ptent))
+						continue;
+					make_uffd_wp_pte(vma, addr, ptep, ptent);
+					if (!flush_end)
+						curr_addr = addr;
+					flush_end = addr + PAGE_SIZE;
+				}
+				goto flush_and_return;
+			}
 
-	return ret;
-}
+			if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
+			    p->arg.category_mask == PAGE_IS_WRITTEN &&
+			    p->arg.return_mask == PAGE_IS_WRITTEN) {
+				for (addr = curr_addr; addr < end; ptep++, addr += PAGE_SIZE) {
+					unsigned long next = addr + PAGE_SIZE;
+					pte_t ptent = ptep_get(ptep);
+
+					ptw.next_addr = addr + PAGE_SIZE;
+					if ((pte_present(ptent) && pte_uffd_wp(ptent)) ||
+					     pte_swp_uffd_wp_any(ptent))
+						continue;
+					ret = pagemap_scan_output(p->cur_vma_category | PAGE_IS_WRITTEN,
+					      p, addr, &next);
+					if (next == addr) {
+						must_return = true;
+						break;
+					}
+					if (~p->arg.flags & PM_SCAN_WP_MATCHING)
+						continue;
+					make_uffd_wp_pte(vma, addr, ptep, ptent);
+					if (!flush_end)
+						curr_addr = addr;
+					flush_end = next;
+				}
+				goto flush_and_return;
+			}
 
-static const struct mm_walk_ops pagemap_scan_ops = {
-	.test_walk = pagemap_scan_test_walk,
-	.pmd_entry = pagemap_scan_pmd_entry,
-	.pte_hole = pagemap_scan_pte_hole,
-	.hugetlb_entry = pagemap_scan_hugetlb_entry,
-};
+			for (addr = curr_addr; addr != end; ptep++, addr += PAGE_SIZE) {
+				pte_t ptent = ptep_get(ptep);
+				unsigned long categories = p->cur_vma_category |
+							   pagemap_page_category(p, vma, addr, ptent);
+				unsigned long next = addr + PAGE_SIZE;
 
-static int pagemap_scan_get_args(struct pm_scan_arg *arg,
-				 unsigned long uarg)
-{
-	if (copy_from_user(arg, (void __user *)uarg, sizeof(*arg)))
-		return -EFAULT;
+				ptw.next_addr = addr + PAGE_SIZE;
+				if (!pagemap_scan_is_interesting_page(categories, p))
+					continue;
 
-	if (arg->size != sizeof(struct pm_scan_arg))
-		return -EINVAL;
+				ret = pagemap_scan_output(categories, p, addr, &next);
+				if (next == addr) {
+					must_return = true;
+					break;
+				}
 
-	/* Validate requested features */
-	if (arg->flags & ~PM_SCAN_FLAGS)
-		return -EINVAL;
-	if ((arg->category_inverted | arg->category_mask |
-	     arg->category_anyof_mask | arg->return_mask) & ~PM_SCAN_CATEGORIES)
-		return -EINVAL;
+				if (~p->arg.flags & PM_SCAN_WP_MATCHING)
+					continue;
+				if (~categories & PAGE_IS_WRITTEN)
+					continue;
 
-	arg->start = untagged_addr((unsigned long)arg->start);
-	arg->end = untagged_addr((unsigned long)arg->end);
-	arg->vec = untagged_addr((unsigned long)arg->vec);
+				make_uffd_wp_pte(vma, addr, ptep, ptent);
+				if (!flush_end)
+					curr_addr = addr;
+				flush_end = next;
+			}
+		}
 
-	/* Validate memory pointers */
-	if (!IS_ALIGNED(arg->start, PAGE_SIZE))
-		return -EINVAL;
-	if (!access_ok((void __user *)(long)arg->start, arg->end - arg->start))
-		return -EFAULT;
-	if (!arg->vec && arg->vec_len)
-		return -EINVAL;
-	if (UINT_MAX == SIZE_MAX && arg->vec_len > SIZE_MAX)
-		return -EINVAL;
-	if (arg->vec && !access_ok((void __user *)(long)arg->vec,
-				   size_mul(arg->vec_len, sizeof(struct page_region))))
-		return -EFAULT;
+		if (ptw.level == PTW_PUD_LEVEL) {
+			if (is_vm_hugetlb_page(ptw.vma))
+				make_uffd_wp_huge_pte(vma, curr_addr, ptw.ptep, ptw.pte);
+			else
+				make_uffd_wp_pud(ptw.vma, curr_addr, ptw.pudp);
+		}
 
-	/* Fixup default values */
-	arg->end = ALIGN(arg->end, PAGE_SIZE);
-	arg->walk_end = 0;
-	if (!arg->max_pages)
-		arg->max_pages = ULONG_MAX;
+		if (ptw.level == PTW_PMD_LEVEL) {
+			if (is_vm_hugetlb_page(ptw.vma))
+				make_uffd_wp_huge_pte(vma, curr_addr, ptw.ptep, ptw.pte);
+			else
+				make_uffd_wp_pmd(ptw.vma, curr_addr, ptw.pmdp);
+		}
 
-	return 0;
+		if (is_vm_hugetlb_page(ptw.vma)) {
+			flush_hugetlb_tlb_range(vma, curr_addr, end);
+		} else {
+flush_and_return:
+			if (flush_end || ptw.level != PTW_PTE_LEVEL)
+				flush_tlb_range(vma, curr_addr, end);
+			if (ptw.level == PTW_PTE_LEVEL)
+				lazy_mmu_mode_disable();
+		}
+		if (must_return)
+			goto out;
+keep_walking:
+		type = pt_range_walk_next(&ptw, vma, vma->vm_start, vma->vm_end, flags);
+	}
+out:
+	pt_range_walk_done(&ptw);
+	return ret;
 }
 
-static int pagemap_scan_writeback_args(struct pm_scan_arg *arg,
-				       unsigned long uargl)
+static int pagemap_scan_test(unsigned long start, unsigned long end,
+				 struct pagemap_scan_private *p,
+				 struct vm_area_struct *vma)
 {
-	struct pm_scan_arg __user *uarg	= (void __user *)uargl;
+	unsigned long vma_category = 0;
+	bool wp_allowed = userfaultfd_wp_async(vma) &&
+			  userfaultfd_wp_use_markers(vma);
 
-	if (copy_to_user(&uarg->walk_end, &arg->walk_end, sizeof(arg->walk_end)))
-		return -EFAULT;
+	if (!wp_allowed) {
+		/* User requested explicit failure over wp-async capability */
+		if (p->arg.flags & PM_SCAN_CHECK_WPASYNC)
+			return -EPERM;
+		/*
+		 * User requires wr-protect, and allows silently skipping
+		 * unsupported vmas.
+		 */
+		if (p->arg.flags & PM_SCAN_WP_MATCHING)
+			return 1;
+		/*
+		 * Then the request doesn't involve wr-protects at all,
+		 * fall through to the rest checks, and allow vma walk.
+		 */
+	}
 
-	return 0;
-}
+	if (vma->vm_flags & VM_PFNMAP)
+		return 1;
 
-static int pagemap_scan_init_bounce_buffer(struct pagemap_scan_private *p)
-{
-	if (!p->arg.vec_len)
-		return 0;
+	if (wp_allowed)
+		vma_category |= PAGE_IS_WPALLOWED;
 
-	p->vec_buf_len = min_t(size_t, PAGEMAP_WALK_SIZE >> PAGE_SHIFT,
-			       p->arg.vec_len);
-	p->vec_buf = kmalloc_objs(*p->vec_buf, p->vec_buf_len);
-	if (!p->vec_buf)
-		return -ENOMEM;
+	if (vma->vm_flags & VM_SOFTDIRTY)
+		vma_category |= PAGE_IS_SOFT_DIRTY;
 
-	p->vec_buf->start = p->vec_buf->end = 0;
-	p->vec_out = (struct page_region __user *)(long)p->arg.vec;
+	if (!pagemap_scan_is_interesting_vma(vma_category, p))
+		return 1;
+
+	p->cur_vma_category = vma_category;
 
 	return 0;
 }
 
-static long pagemap_scan_flush_buffer(struct pagemap_scan_private *p)
+static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
+				 struct pagemap_scan_private *p,
+				 struct vm_area_struct *vma)
 {
-	const struct page_region *buf = p->vec_buf;
-	long n = p->vec_buf_index;
-
-	if (!p->vec_buf)
-		return 0;
-
-	if (buf[n].end != buf[n].start)
-		n++;
+	int ret, err;
 
-	if (!n)
+	if (!vma || !pagemap_scan_is_interesting_page(p->cur_vma_category, p))
 		return 0;
 
-	if (copy_to_user(p->vec_out, buf, n * sizeof(*buf)))
-		return -EFAULT;
+	ret = pagemap_scan_output(p->cur_vma_category, p, addr, &end);
+	if (addr == end)
+		return ret;
 
-	p->arg.vec_len -= n;
-	p->vec_out += n;
+	if (~p->arg.flags & PM_SCAN_WP_MATCHING)
+		return ret;
 
-	p->vec_buf_index = 0;
-	p->vec_buf_len = min_t(size_t, p->vec_buf_len, p->arg.vec_len);
-	p->vec_buf->start = p->vec_buf->end = 0;
+	err = uffd_wp_range(vma, addr, end - addr, true);
+	if (err < 0)
+		ret = err;
 
-	return n;
+	return ret;
 }
 
 static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 {
 	struct pagemap_scan_private p = {0};
+	struct vm_area_struct *vma;
 	unsigned long walk_start;
 	size_t n_ranges_out = 0;
 	int ret;
@@ -2932,6 +2631,7 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 	for (walk_start = p.arg.start; walk_start < p.arg.end;
 			walk_start = p.arg.walk_end) {
 		struct mmu_notifier_range range;
+		unsigned long next;
 		long n_out;
 
 		if (fatal_signal_pending(current)) {
@@ -2950,8 +2650,42 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
-		ret = walk_page_range(mm, walk_start, p.arg.end,
-				      &pagemap_scan_ops, &p);
+		vma = find_vma(mm, walk_start);
+		do {
+			if (!vma) {
+				walk_start = p.arg.end;
+				next = p.arg.end;
+				ret = pagemap_scan_pte_hole(walk_start, next, &p, NULL);
+				if (ret)
+					break;
+			} else if (walk_start < vma->vm_start) {
+				next = min(p.arg.end, vma->vm_start);
+				ret = pagemap_scan_pte_hole(walk_start, next, &p, NULL);
+				if (ret)
+					break;
+				walk_start = next;
+			} else {
+				next = min(p.arg.end, vma->vm_end);
+
+				ret = pagemap_scan_test(walk_start, min(p.arg.end, vma->vm_end),
+							    &p, vma);
+
+				if (ret > 0) {
+					ret = 0;
+					walk_start = min(p.arg.end, vma->vm_end);
+					next = walk_start;
+					vma = find_vma(mm, walk_start);
+					continue;
+				}
+
+				ret = pagemap_scan_walk(vma, &p, walk_start);
+				if (ret)
+					break;
+				walk_start = min(p.arg.end, vma->vm_end);
+				vma = find_vma(mm, walk_start);
+				next = walk_start;
+			}
+		} while (next < p.arg.end);
 
 		if (p.arg.flags & PM_SCAN_WP_MATCHING)
 			mmu_notifier_invalidate_range_end(&range);
@@ -2985,6 +2719,306 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
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
+	wflags &= ~(PT_TYPE_PFN);
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
+			if (pmd_none(ptw.pmd))
+				goto populate_pagemap;
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
+		} else if (ptw.level == PTW_PMD_LEVEL) {
+populate_pagemap:
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
+		if (err)
+			break;
+		type = pt_range_walk_next(&ptw, vma, vma->vm_start, vma->vm_end, wflags);
+	}
+	pt_range_walk_done(&ptw);
+
+	return err;
+}
+
+static int pagemap_pte_hole(struct mm_struct *mm, unsigned long start, unsigned long end,
+			    struct pagemapread *pm)
+{
+	unsigned long addr = start;
+	int err = 0;
+
+	while (addr < end) {
+		struct vm_area_struct *vma = find_vma(mm, addr);
+		pagemap_entry_t pme = make_pme(0, 0);
+		/* End of address space hole, which we mark as non-present. */
+		unsigned long hole_end;
+
+		if (vma)
+			hole_end = min(end, vma->vm_start);
+		else
+			hole_end = end;
+
+		for (; addr < hole_end; addr += PAGE_SIZE) {
+			err = add_to_pagemap(&pme, pm);
+			if (err)
+				goto out;
+		}
+
+		if (!vma)
+			break;
+
+		/* Addresses in the VMA. */
+		if (vma->vm_flags & VM_SOFTDIRTY)
+			pme = make_pme(0, PM_SOFT_DIRTY);
+		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
+			err = add_to_pagemap(&pme, pm);
+			if (err)
+				goto out;
+		}
+	}
+out:
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
+		struct vm_area_struct *vma = find_vma(mm, start_vaddr);
+
+		do {
+			if (!vma) {
+				next = end;
+				ret = pagemap_pte_hole(mm, start_vaddr, next, &pm);
+				if (ret)
+					goto out_err;
+			} else if (start_vaddr < vma->vm_start) {
+				next = min(end, vma->vm_start);
+				ret = pagemap_pte_hole(mm, start_vaddr, next, &pm);
+				if (ret)
+					goto out_err;
+				start_vaddr = next;
+			} else {
+				ret = pagemap_read_walk_range(vma, start_vaddr, &pm);
+				if (ret)
+					goto out_err;
+				start_vaddr = min(end, vma->vm_end);
+				next = start_vaddr;
+				vma = find_vma(mm, start_vaddr);
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
@@ -3007,6 +3041,7 @@ const struct file_operations proc_pagemap_operations = {
 	.unlocked_ioctl = do_pagemap_cmd,
 	.compat_ioctl	= do_pagemap_cmd,
 };
+
 #endif /* CONFIG_PROC_PAGE_MONITOR */
 
 #ifdef CONFIG_NUMA
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 08646398b0fe..bda9e7971732 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -628,6 +628,19 @@ static inline bool pmd_is_device_private_entry(pmd_t pmd)
 
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
index f5291f9ce583..1512b1bb49e3 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1263,11 +1263,21 @@ static inline pmd_t generic_pmdp_establish(struct vm_area_struct *vma,
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
@@ -1810,6 +1820,21 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 
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
@@ -1852,6 +1877,11 @@ static inline int pmd_soft_dirty(pmd_t pmd)
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
index b91b1a98029c..89010192c969 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -208,6 +208,27 @@ pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 }
 #endif
 
+#ifndef __HAVE_ARCH_PUDP_INVALIDATE
+pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
+		      pud_t *pudp)
+{
+	VM_WARN_ON_ONCE(!pud_present(*pudp));
+	pud_t old = pudp_establish(vma, address, pudp, pud_mkinvalid(*pudp));
+	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
+	return old;
+}
+#endif
+
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
2.53.0


