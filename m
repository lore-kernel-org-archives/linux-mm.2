Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3825C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9BFC6B009F; Thu, 24 Sep 2026 09:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6E086B00A0; Thu, 24 Sep 2026 09:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10A46B00A1; Thu, 24 Sep 2026 09:12:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D23D6B009F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:12:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 383EA1A035E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:12:42 +0000 (UTC)
X-FDA: 85248695364.09.C139F2A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 98148180009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:12:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jP960BVS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790255560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAMLPGm2RHR+Bu0yJN94tFRfL657HQ8QW3uoIgAkc7I=;
	b=bhdQpmj/U9mbjOIOGVRaZaiZZ8L4C8xgtyfmq80RJ++mwnZqDxBvVLrqbhcSSvBD20kTdm
	dLnt62Hl948+Z0JxzysRAgVAcyNF9MOXG/E79DiQCs4MWUzvFHiMlqHgUfgbqrl42w8tJC
	kzpSRRTDTd8QPf2BJPAp77Z8Kfn2xp8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jP960BVS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790255560;
	b=jcDg/B/0Mi7VgTqE9JE85MvYpAMPB8mAdb22Xp+lLsx01azyf/D5EOkU6UZX7sA9DP14A/
	s/RjvMSnvXOAILxDWCdflAKKdSW1JOxklfaxhWhviWBcrxMZ7hD3DikCTcARj2u7PdzD7i
	WsrOZPX8gFPutHuI5SaDIFTmvTd2Qd4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38E671C14;
	Thu, 24 Sep 2026 06:12:36 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 964643F86F;
	Thu, 24 Sep 2026 06:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790255559; bh=rKlBajLDFkN2AhByG94LAOJ8WdXEzVoumoEj/FiHf8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jP960BVSqgyxTgDWZPsvCQbDyJePhK8xvAxDnAB52vhEKQOxjZMKBeLajhfcJDwNp
	 T6iYh+Lf0LsI37GDyEv25pgdadsx8eRWwkksQYEbgm6exutQP0v6ATCTsyRNdQEvJN
	 eG+1UldqwEENt1HdcTcUDvYDbjM9nebJVX508sv4=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	jgg@ziepe.ca,
	thuth@redhat.com,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 9/9] mm, sparc: batch arch_unmap_one()
Date: Thu, 24 Sep 2026 13:09:37 +0000
Message-ID: <20260924131106.1730494-10-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924131106.1730494-1-dev.jain@arm.com>
References: <20260924131106.1730494-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 85c7i6aerdghsrteusdpz9btqxgamdtk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 98148180009
X-HE-Tag: 1790255560-989459
X-HE-Meta: U2FsdGVkX19rly3b6HWiJDk2AQSy+V2olzhYE0k6J/GXa+8ti/GuVdapgE43rLhGgTJ8iignOJrzeUBQwq20vWMfo1eDHsxAvY/mT6Ejo9hfcRnETR1y66gLOV8KuZ2flwkFC1yqKYgVdI9SJ/H1p8H7iYOCKD/KoSJ0O33lWx9RdJBUgU/dpnsKFXldFS6m/2LbeT80IWdH4+BtsONW0VtLas7n6aeYTrkER6heZ3sLr9MEFRzi95vunwS0Dfu4YY+9a5ArFyzShs1jwBgaZ0Zp2TuWAvASHkIWYnGFMWq5b25n5R2XNvH7NZqo8GmwD/WNImia+IJBA6PwrRun4qqLlgxQWB7r6SZZ8xNqOyCMj6+g0wc4iimj20OgomOWF4GuaN5NCb16gdqVe4RFranzbedhEVO+Vb90ZVX54l8HhMYl0OeJrXnSlh14jsUE+oLPu8U0US4lLCmLYilp3/lRO0fqxfKvNF+F4Gu8hPqLMyQu3kzhl/DjhmY38Z3yZw58wBp6waeqq5iDrUd2q8nI7SkwtGRrt0OrTBvf8CbVh0RJTFbdjcQhE9S80tWXfOlBk8YZgpYiR+/vLrMl+sUieHCfgv1XRgukMDt9gxiFcAqvtAyHQUb8Z5gqdTFklfSzTcwKjPkEKy5IWrOAHAhOuRGknMrMzRGNl5js6+bJbgfXzPPk2hNZsLnADRkoOi1yEBe8iN/7KHooWQKebpSxw1TyyRQlLkmbg5Fo1qIOfrZHL/sBOuD/gSky+WF+D3+b2xWDL2P0feVv0V0050JycdRxof/muW6xRhsQM06iY7RTzEkkyudrE9cBJ0p2Vlfh2WJoCBQCRQDpEIXO1rT3etfbuCs07vOM+2KlLOx9rUyAT/Xl6L0yuWH1+41UKVwIwdOE56dqP6rnKdHSq+a4oyy24VJ7ca81sNBVzUksknComDke1pdX0RuIb2bdLdVq7F7iHEr1q49ZuY9
 EPClcGNy
 JZKgqBuZ/sYMVYKeK4JmoFzWffCNdtUL4SrDICLYAin+tHNyD3P9d7hdXBAVjZBg3hJRUD+1SA0EUi6klHrDX3rY1GFAlgDiXQ2Ck/PFVgpS0FrIjrfZRn21cAQyWEcqDSDAlQrwwnX8ONHxcYTqQ7GuG8+mrH7J7KjssjCWc2OfHTDBwR9tVRrE6gutfJhTUoi6H5sTwri7O3G8SkOTheILAPZdwfA8muFgqTL3Bq8DEqaywAMHsjjSEfevJlLPhysa6vm4u4z/G+rB/ccHOe2X2bzoPDpF2e+wIVxsWRswpV2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The anonymous large-folio unmap batching path can clear and replace
multiple PTEs at once, but architectures like sparc need arch_unmap_one()
to preserve per-page metadata before swap entries are installed.
sparc uses this hook to save ADI tags.

Extend arch_unmap_one() to operate on a pte range.

sparc uses the count to walk the PTE range and save ADI tags for entries
carrying _PAGE_MCD_4V. There is no reverse operation for a partially
saved range: saving ADI tags only records a copy for later restore, so
if a later entry fails and the core keeps the original PTEs, there is
no architectural state to unsave.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 arch/sparc/include/asm/pgtable_64.h | 10 +++++++---
 arch/sparc/kernel/adi_64.c          | 21 +++++++++++++++++++++
 include/linux/pgtable.h             |  6 +++---
 mm/rmap.c                           | 11 +++--------
 4 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 44d1333065a6a..f7dd1872884e4 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -1037,6 +1037,9 @@ void adi_restore_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 int adi_save_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 		  unsigned long addr, pte_t oldpte);
 
+int adi_save_tags_range(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long addr, pte_t oldpte, unsigned long nr);
+
 #define __HAVE_ARCH_DO_SWAP_PAGE
 static inline void arch_do_swap_page(struct mm_struct *mm,
 				     struct vm_area_struct *vma,
@@ -1057,10 +1060,11 @@ static inline void arch_do_swap_page(struct mm_struct *mm,
 #define __HAVE_ARCH_UNMAP_ONE
 static inline int arch_unmap_one(struct mm_struct *mm,
 				 struct vm_area_struct *vma,
-				 unsigned long addr, pte_t oldpte)
+				 unsigned long addr, pte_t oldpte,
+				 unsigned long nr)
 {
-	if (adi_state.enabled && (pte_val(oldpte) & _PAGE_MCD_4V))
-		return adi_save_tags(mm, vma, addr, oldpte);
+	if (adi_state.enabled)
+		return adi_save_tags_range(mm, vma, addr, oldpte, nr);
 	return 0;
 }
 
diff --git a/arch/sparc/kernel/adi_64.c b/arch/sparc/kernel/adi_64.c
index 18036a43cf568..ffa378accefe3 100644
--- a/arch/sparc/kernel/adi_64.c
+++ b/arch/sparc/kernel/adi_64.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/mm_types.h>
+#include <linux/pgtable.h>
 #include <asm/mdesc.h>
 #include <asm/adi_64.h>
 #include <asm/mmu_64.h>
@@ -394,3 +395,23 @@ int adi_save_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	return 0;
 }
+
+int adi_save_tags_range(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long addr, pte_t oldpte, unsigned long nr)
+{
+	unsigned long i;
+
+	for (i = 0; i < nr; i++, addr += PAGE_SIZE,
+	     oldpte = pte_next_pfn(oldpte)) {
+		int ret;
+
+		if (!(pte_val(oldpte) & _PAGE_MCD_4V))
+			continue;
+
+		ret = adi_save_tags(mm, vma, addr, oldpte);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3c8ab96941c5..d5c78dc938760 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1431,12 +1431,12 @@ static inline void arch_do_swap_page_nr(struct mm_struct *mm,
  * restored when the page is swapped back in. SPARC M7 and newer
  * processors support an ADI (Application Data Integrity) tag for the
  * page as metadata for the page. arch_unmap_one() can save this
- * metadata on a swap-out of a page.
+ * metadata on swap-out of one or more pages.
  */
 static inline int arch_unmap_one(struct mm_struct *mm,
 				  struct vm_area_struct *vma,
-				  unsigned long addr,
-				  pte_t orig_pte)
+				  unsigned long addr, pte_t orig_pte,
+				  unsigned long nr)
 {
 	return 0;
 }
diff --git a/mm/rmap.c b/mm/rmap.c
index cdda9efd80bc3..774ddc75194b1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1959,6 +1959,7 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 
 	if (flags & TTU_HWPOISON)
 		return 1;
+
 	if (!folio_test_large(folio))
 		return 1;
 
@@ -1969,11 +1970,6 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	if (pte_unused(pte))
 		return 1;
 
-#ifdef __HAVE_ARCH_UNMAP_ONE
-	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
-		return 1;
-#endif
-
 	/*
 	 * If unmap fails, we need to restore the ptes. To avoid accidentally
 	 * upgrading write permissions for ptes that were not originally
@@ -2168,8 +2164,7 @@ static bool __ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	 * architectures where we could have PFN swap PTEs,
 	 * so we'll not check/care.
 	 */
-	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-		VM_WARN_ON(nr_pages != 1);
+	if (arch_unmap_one(mm, vma, address, pteval, nr_pages) < 0) {
 		folio_put_swap_pages(folio, page, nr_pages);
 		return false;
 	}
@@ -2746,7 +2741,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * architectures where we could have PFN swap PTEs,
 			 * so we'll not check/care.
 			 */
-			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+			if (arch_unmap_one(mm, vma, address, pteval, 1) < 0) {
 				if (folio_test_hugetlb(folio))
 					set_huge_pte_at(mm, address, pvmw.pte,
 							pteval, hsz);
-- 
2.43.0


