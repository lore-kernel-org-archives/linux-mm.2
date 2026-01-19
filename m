Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93BAED2ECF4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 22:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3DE26B02EE; Mon, 19 Jan 2026 17:07:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16156B02F3; Mon, 19 Jan 2026 17:07:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9C86B02FA; Mon, 19 Jan 2026 17:07:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCCAA6B02EE
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 17:07:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71FCF1602C9
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:07:19 +0000 (UTC)
X-FDA: 84350100198.02.42BDE3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A245914000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:07:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLvk1sih;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768860437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yba6DtMRXe6mQwFZw+1uQlEi0TmB2he0lws0TpXh7ho=;
	b=bz9ZSYNX0IxrZ8avn7Jyk/OFZW4WyhQcdnY/kI6Oz9bxJO4vKtbMp07tMCN7R1gCiTszd7
	M2DdQYRCm0xvLFtI2FyQ7HjJ4+IidpoXaKUyr7VlKL55V24cOGQe7I0/ZehT6vmoUh4kof
	n0h/J5YXWs5iRlfJzSFKOSoRSTfJBMQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLvk1sih;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768860437; a=rsa-sha256;
	cv=none;
	b=BxsAhpdhqN982eaRD/SY2Ve/HlnADKK9i6kATAKcY63bG5AcyJyTtZxtOE9zpEzxeSYSfe
	N3p/ZDq5J2ZcqYLsZdYCzFBp2MDYR6Bu2fG/HUsrKSULpUqtxjyBqq6jvGpU/t+kwkXVN1
	Y/bLQFuzBiBaOv9fcVLHc09kspdPghQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE66C41815;
	Mon, 19 Jan 2026 22:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09C2C19422;
	Mon, 19 Jan 2026 22:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768860436;
	bh=6S73vOd5UI/VdrU0A44F+umXZrxl6lMbP+XMOUHhvwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLvk1sihBmhLNqGYOrWl1P7Kw1zbXh0a/WibGYGBJWG/wR4GOOs4Du3QtEXlr5cUW
	 MWcLRK0eayhgnz/5gbIG4C+ZvxXLfUht3UJ71f/wLDIHEJR/wXiwxh5hKWUsbgY8OD
	 6TT9tuseGPWEur3xLRTn9vz+Cuq6WQljYgkyqjJUrN9bi89j8FEH3FBccDYsCIt6Ka
	 dmbdHf/UL9h/6JbGJECapaG/DQ89XY2TKGYIQRPAUfiiFZKc5WzlZGxXDhLcnQpFv2
	 5uoA5ur8LNLZYJT/D9TVGiUCSew3hqT07U5YyvJ2jicSxHHZsPkpIBlyHW1EPlBzs6
	 SufBVr7O0WNFw==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: [PATCH v1 1/2] mm: move pte table reclaim code to memory.c
Date: Mon, 19 Jan 2026 23:07:07 +0100
Message-ID: <20260119220708.3438514-2-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119220708.3438514-1-david@kernel.org>
References: <20260119220708.3438514-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n18g6m9op3uo69659hj7qkeaeiyossn1
X-Rspam-User: 
X-Rspamd-Queue-Id: A245914000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768860437-144085
X-HE-Meta: U2FsdGVkX1+JZhbnEYR4Y9Qc07wzYhny+d6+N3ltyisg+X5/0cgkIqD70XjHXv4XrnjUbYm43quCTOLFGJ0EuHWZeEIUh6TtlbW28S89QAptTmPsectdyTI1Vl5e9ngPS95EzMlTfw9T4S52PgIs26rV7Osa/+RMjnU1wYv8Iu4JIR352w6W9CDnwHNFJnz2ZgCn+0R9DA8U5sa4W7PzHnZ40AxsIrnz8gTevF/X2eeqO2fR6wI6pFXdWihQg3rlVkU9y9BDU7hVbRR/asUB9DR8N/gL78MZkDVeiOGSlJwkOVsn+v8argkETEuHWAuGxvbNdnSIL/mEYxw79gcK7a6TexmC8g3NgiJOMdpxbsdDLOznQC+rWu534NaXb4xqrwa3ud2ixlHBghKbUqS0GwMoCkMoh4sJ125qhZCEJeUJPE9ZpmodxRGX63UdUkkkBaimQ1ymDVWS2qj1m7qPOIF/+V2gBVKCLQ1F4aMGGDz8roEIEIHn5rCK08+Gsc/ZJEPP/9yf+rTHaoMADcI+97Nc1j+OYkVphfJlTJqEAT9pBe+ue75gFyXfsPNp7We5R2j4CoVH1Q3x7GEoAu9IY7iiyFk2FpCXUj6XQBh+zZk1gr+8fPvw+PHO9Wjd/C9MDkbQ9g78qU8oV6PpZ1FXstMlMc24LFxKfVV5ny3xDLdhVz1yNcxnwCKjgfY3nvurz9UFAoRSE7E5OypuyMLBiMREGRvffSTgEre2HflVF+iDSBPmazPROSuKgyh5b9WzqNm7nxe/bqIz0pEbGqBTh/9e/59mL3vAaIKGjk6RUeIdTeJ0te8055sR1athx6FTb5yMGlXVPR1V64oVFuH+AfPpxM4PWTP0GJgX1QgbDr2OA24l2sLDaUKAQD/Ip12MZZIlQXgKt822rvilHi4voaybXjCB7x6L7A2YpDFa1tGbEFWwLrgBzSMyEmdeM2I7WGxG2n31BLxJW6Dfhm5
 A/B8sC6b
 4O91FjqoNhGT8Sxw00y8rmVCGYc07/+xQTa1iuW4Dtmgr4WT6Zc8qiAKiiEFkG8e/E/I+8d8ETPQyIqzPOucplcs5ZuMld8jAYk09p9MK2Sq5J2ExYelaZjbprbOAZAsSiyBooG8B4ZpZhf9kx34OPqA5QrZNs41sgwHv7N4LtFU2Y/OY548TjigZBRsZbKXw3zUQdI/C/ZICuq6JBOrcOsv80DGYfetQaPssBK9D93kc5tUon9nxOKx+G9z2fHQttf6Ql2XVQMM/pp0CyuUPQHrv2z7UNCjaFATuH1lx3pI4IsrSgQS4nZMMTTJYHbabXvc+JM/qXhAkZahCNb7Vh6bgbmErdmHXMEbu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pte-table reclaim code is only called from memory.c, while zapping
pages, and it better also stays that way in the long run. If we ever
have to call it from other files, we should expose proper high-level
helpers for zapping if the existing helpers are not good enough.

So, let's move the code over (it's not a lot) and slightly clean it up a
bit by:
- Renaming the functions.
- Dropping the "Check if it is empty PTE page" comment, which is now
  self-explaining given the function name.
- Making zap_pte_table_if_empty() return whether zapping worked so the
  caller can free it.
- Adding a comment in pte_table_reclaim_possible().
- Inlining free_pte() in the last remaining user.
- In zap_empty_pte_table(), switch from pmdp_get_lcokless() to
  pmd_clear(), we are holding the PMD PT lock.

By moving the code over, compilers can also easily figure out when
zap_empty_pte_table() does not initialize the pmdval variable, avoiding
false-positive warnings about the variable possibly not being
initialized.

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 MAINTAINERS     |  1 -
 mm/Makefile     |  1 -
 mm/internal.h   | 18 -------------
 mm/memory.c     | 68 +++++++++++++++++++++++++++++++++++++++++-----
 mm/pt_reclaim.c | 72 -------------------------------------------------
 5 files changed, 62 insertions(+), 98 deletions(-)
 delete mode 100644 mm/pt_reclaim.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 11720728d92f2..28e8e28bca3e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16692,7 +16692,6 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-F:	mm/pt_reclaim.c
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
diff --git a/mm/Makefile b/mm/Makefile
index 0d85b10dbdde4..53ca5d4b1929b 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -146,5 +146,4 @@ obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
-obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
diff --git a/mm/internal.h b/mm/internal.h
index 9508dbaf47cd4..ef71a1d9991f2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1745,24 +1745,6 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  pgd_t *pgd, void *private);
 
-/* pt_reclaim.c */
-bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval);
-void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
-	      pmd_t pmdval);
-void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
-		     struct mmu_gather *tlb);
-
-#ifdef CONFIG_PT_RECLAIM
-bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
-			   struct zap_details *details);
-#else
-static inline bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
-					 struct zap_details *details)
-{
-	return false;
-}
-#endif /* CONFIG_PT_RECLAIM */
-
 void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
 int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
 
diff --git a/mm/memory.c b/mm/memory.c
index f2e9e05388743..c3055b2577c27 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1824,11 +1824,68 @@ static inline int do_zap_pte_range(struct mmu_gather *tlb,
 	return nr;
 }
 
+static bool pte_table_reclaim_possible(unsigned long start, unsigned long end,
+		struct zap_details *details)
+{
+	if (!IS_ENABLED(CONFIG_PT_RECLAIM))
+		return false;
+	/* Only zap if we are allowed to and cover the full page table. */
+	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
+}
+
+static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
+{
+	spinlock_t *pml = pmd_lockptr(mm, pmd);
+
+	if (!spin_trylock(pml))
+		return false;
+
+	*pmdval = pmdp_get(pmd);
+	pmd_clear(pmd);
+	spin_unlock(pml);
+	return true;
+}
+
+static bool zap_pte_table_if_empty(struct mm_struct *mm, pmd_t *pmd,
+		unsigned long addr, pmd_t *pmdval)
+{
+	spinlock_t *pml, *ptl = NULL;
+	pte_t *start_pte, *pte;
+	int i;
+
+	pml = pmd_lock(mm, pmd);
+	start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, pmdval, &ptl);
+	if (!start_pte)
+		goto out_ptl;
+	if (ptl != pml)
+		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
+
+	for (i = 0, pte = start_pte; i < PTRS_PER_PTE; i++, pte++) {
+		if (!pte_none(ptep_get(pte)))
+			goto out_ptl;
+	}
+	pte_unmap(start_pte);
+
+	pmd_clear(pmd);
+
+	if (ptl != pml)
+		spin_unlock(ptl);
+	spin_unlock(pml);
+	return true;
+out_ptl:
+	if (start_pte)
+		pte_unmap_unlock(start_pte, ptl);
+	if (ptl != pml)
+		spin_unlock(pml);
+	return false;
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct zap_details *details)
 {
+	bool can_reclaim_pt = pte_table_reclaim_possible(addr, end, details);
 	bool force_flush = false, force_break = false;
 	struct mm_struct *mm = tlb->mm;
 	int rss[NR_MM_COUNTERS];
@@ -1837,7 +1894,6 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	pte_t *pte;
 	pmd_t pmdval;
 	unsigned long start = addr;
-	bool can_reclaim_pt = reclaim_pt_is_enabled(start, end, details);
 	bool direct_reclaim = true;
 	int nr;
 
@@ -1878,7 +1934,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	 * from being repopulated by another thread.
 	 */
 	if (can_reclaim_pt && direct_reclaim && addr == end)
-		direct_reclaim = try_get_and_clear_pmd(mm, pmd, &pmdval);
+		direct_reclaim = zap_empty_pte_table(mm, pmd, &pmdval);
 
 	add_mm_rss_vec(mm, rss);
 	lazy_mmu_mode_disable();
@@ -1907,10 +1963,10 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	}
 
 	if (can_reclaim_pt) {
-		if (direct_reclaim)
-			free_pte(mm, start, tlb, pmdval);
-		else
-			try_to_free_pte(mm, pmd, start, tlb);
+		if (direct_reclaim || zap_pte_table_if_empty(mm, pmd, start, &pmdval)) {
+			pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
+			mm_dec_nr_ptes(mm);
+		}
 	}
 
 	return addr;
diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
deleted file mode 100644
index 46771cfff8239..0000000000000
--- a/mm/pt_reclaim.c
+++ /dev/null
@@ -1,72 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/hugetlb.h>
-#include <linux/pgalloc.h>
-
-#include <asm/tlb.h>
-
-#include "internal.h"
-
-bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
-			   struct zap_details *details)
-{
-	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
-}
-
-bool try_get_and_clear_pmd(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
-{
-	spinlock_t *pml = pmd_lockptr(mm, pmd);
-
-	if (!spin_trylock(pml))
-		return false;
-
-	*pmdval = pmdp_get_lockless(pmd);
-	pmd_clear(pmd);
-	spin_unlock(pml);
-
-	return true;
-}
-
-void free_pte(struct mm_struct *mm, unsigned long addr, struct mmu_gather *tlb,
-	      pmd_t pmdval)
-{
-	pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
-	mm_dec_nr_ptes(mm);
-}
-
-void try_to_free_pte(struct mm_struct *mm, pmd_t *pmd, unsigned long addr,
-		     struct mmu_gather *tlb)
-{
-	pmd_t pmdval;
-	spinlock_t *pml, *ptl = NULL;
-	pte_t *start_pte, *pte;
-	int i;
-
-	pml = pmd_lock(mm, pmd);
-	start_pte = pte_offset_map_rw_nolock(mm, pmd, addr, &pmdval, &ptl);
-	if (!start_pte)
-		goto out_ptl;
-	if (ptl != pml)
-		spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
-
-	/* Check if it is empty PTE page */
-	for (i = 0, pte = start_pte; i < PTRS_PER_PTE; i++, pte++) {
-		if (!pte_none(ptep_get(pte)))
-			goto out_ptl;
-	}
-	pte_unmap(start_pte);
-
-	pmd_clear(pmd);
-
-	if (ptl != pml)
-		spin_unlock(ptl);
-	spin_unlock(pml);
-
-	free_pte(mm, addr, tlb, pmdval);
-
-	return;
-out_ptl:
-	if (start_pte)
-		pte_unmap_unlock(start_pte, ptl);
-	if (ptl != pml)
-		spin_unlock(pml);
-}
-- 
2.52.0


