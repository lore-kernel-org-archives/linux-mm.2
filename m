Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1812CDC173
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 12:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1860D6B00A5; Tue,  6 Jan 2026 07:03:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143976B00A6; Tue,  6 Jan 2026 07:03:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D9F6B00A7; Tue,  6 Jan 2026 07:03:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EDDBB6B00A5
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:03:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77DD4C20A9
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:03:41 +0000 (UTC)
X-FDA: 84301404642.28.D8CC206
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id BFA081A0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:03:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fo304lb7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767701019; a=rsa-sha256;
	cv=none;
	b=MUeui6AeZ8D0m06B5Gzg7TZwadsVgxLowXCVM1eGrux8ABgajSgGgyq5zRyAIGNYZi0MiW
	pfP7DoEke0FITkzd1NYwFVsL7wdLT4iyqF2QiQlAlCb9WRsfkXcbTjjXpbFeXnJWkJ8pbH
	sTXv0hkJQibeMGKrmICbOd+t+bIy8OA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fo304lb7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767701019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ASH9sKA9CqH12pO8t+a39xF1o8l7wjDesRLJzYo7jDg=;
	b=Bui7Rdabltqt+Pji7H2QGaEIRp/sY3sqNhwHYX8tE1flP0TgN3b0Tw6xFZ7GiDQr7vQQzO
	C3ex+c1iNTdoOH5V5SBrcYicZoBudU6UBIASL5fil38Jt9ej1XsTBRFKwKtNqjHUVEFUyG
	hmCOpPls03skEA54yRgus4JghPc9XEM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767701017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASH9sKA9CqH12pO8t+a39xF1o8l7wjDesRLJzYo7jDg=;
	b=fo304lb7fgHQnNMaAp0eWFliAX6uJd4wd2knSySDIY2+gt6Vy5knfQqlLvBSXULyi0N5Gz
	zPSV6/59lOxtsFjv7ze9iE9PbL4fVnhF5TrAi9Yyg0+4Ms09KExMZlIiWrtsTZgHHsPO8C
	40Kx9pgYSXvBBiwN1Q5zlWe1kfD9t/U=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RESEND v3 2/2] mm: introduce pmdp_collapse_flush_sync() to skip redundant IPI
Date: Tue,  6 Jan 2026 20:03:03 +0800
Message-ID: <20260106120303.38124-3-lance.yang@linux.dev>
In-Reply-To: <20260106120303.38124-1-lance.yang@linux.dev>
References: <20260106120303.38124-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BFA081A0005
X-Stat-Signature: 34k4j883m48cy7dttgzzkrhdwyjgcojr
X-Rspam-User: 
X-HE-Tag: 1767701019-314047
X-HE-Meta: U2FsdGVkX19yzpcvxgyen4OJYOBgWG3aSP7m/eeS8+SyxaPNgqXSYYgn8rvYTRriTh43eo3S54S+fRPSIp9Gb0aGUHX9yTyy7/7gswpXrpdIjUecLyZtsFG5hElgQ8GgpG9H+x/JsbW3Wr0LEb2JqWxic/9pzXefxRI3e4KXnSIucV0+rOGkglNeBiAy+0ALLj3Tc0a5PILy62PXGQO85bleionVaPNvKpnIXtDReacwUs+40HDxeErMwcxbm17Fi9j+tgxgH34juPLkZsd/cVZYM+cqXBMDTof3/E5nNmhI3BLrw+UXrLCV5H8rvXXs98JIXCt0xD/ZlULjlPN/CwLqbCZzFdNWaJMGf8Osl7WSys/tsD9uxzG9BduNRvG0s+STZpyayXwy7b8n5+hAwkbDLn/ZT3HG+TGc5vE+rIaRi5G7J290QwLeJizEK3E5hg8zC0HNtbTJQH3soD6QlXEEkhmOV/NLCAo2/XOutZ84uoL/xsJEQwBW2RsNT+HQWA8zoJQnrSEv2Zwf68127MJtZjcGJr9aIPGx7ADNFgiK4ZokAuzqibpbCFK16FuOUA02FA2q/V7eRoTc0syjW/1lnp9XzGvRAx90Kn7g6a+ihCPwfKwlzaSXPiDna+dDTNT0auayQsDojGQ8nxIXmXx3hxmsR8XzDTYcV/G5xrzv7HJXnXa8P+hYS7n9W3ug/DH8WXxoFfR7LmklVZX5g6qpeTT0FuB8OuhP0SicbBqnvLInUwKHx3pz9jJ420DGLmhNZICeydQhFI5uo03SGC/Aqnu6oSjQf6nyFTbWVzwpgZ4y0TcfhWvqlflHM9Hp4xxAtjpDjwEbW28ZmyeVsaltHROxvLBYAKtTDs52lA3729q8x5F/b49UhAvNBLayu/nSjnwS/dQyZq9uaHtRPfMMTyl/Qcang5yqDZet3iavDfqK2hk1kjEz+iHMg2TfEHUVoJ7kOsdLdqdNsYP
 cGNpX63P
 n6v0D5ebUgh2O+mEfQerNiXkAiKM4VkJnFZg3MQJLB3jPBfRpmRQ8hbsi/c5Rklp803JVxL+Q2FMMdL25dlPdXc/ES3KbYl0qxeLNZ9jfs3E9mUU5o47z4gttRLiQgK79hyYi1oobfXHpFnmsdo9kFquzY7fOhA/zwj17nxFC6m7M/MncdRYcxfWvRE/iZK7gG0wlq2Bocpul4MEFO0UrZfSeEJWsYy3XtisOpPqSngPGUbBsAp0FsQBJkJEZRJ5cipH5bvUv2OYZZHzsF/B2Of3f5GwQvfyNcKd5BM5bIYm4HZp0Otudrdov3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

pmdp_collapse_flush() may already send IPIs to flush TLBs, and then
callers send another IPI via tlb_remove_table_sync_one() or
pmdp_get_lockless_sync() to synchronize with concurrent GUP-fast walkers.

However, since GUP-fast runs with IRQs disabled, the TLB flush IPI already
provides the necessary synchronization. We can avoid the redundant second
IPI.

Introduce pmdp_collapse_flush_sync() which combines flush and sync:

- For architectures using the generic pmdp_collapse_flush() implementation
  (e.g., x86): Use mmu_gather to track IPI sends. If the TLB flush sent
  an IPI, tlb_gather_remove_table_sync_one() will skip the redundant one.

- For architectures with custom pmdp_collapse_flush() (s390, riscv,
  powerpc): Fall back to calling pmdp_collapse_flush() followed by
  tlb_remove_table_sync_one(). No behavior change.

Update khugepaged to use pmdp_collapse_flush_sync() instead of separate
flush and sync calls. Remove the now-unused pmdp_get_lockless_sync() macro.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/linux/pgtable.h | 13 +++++++++----
 mm/khugepaged.c         |  9 +++------
 mm/pgtable-generic.c    | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index eb8aacba3698..69e290dab450 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -755,7 +755,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
 	return pmd;
 }
 #define pmdp_get_lockless pmdp_get_lockless
-#define pmdp_get_lockless_sync() tlb_remove_table_sync_one()
 #endif /* CONFIG_PGTABLE_LEVELS > 2 */
 #endif /* CONFIG_GUP_GET_PXX_LOW_HIGH */
 
@@ -774,9 +773,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
 {
 	return pmdp_get(pmdp);
 }
-static inline void pmdp_get_lockless_sync(void)
-{
-}
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -1174,6 +1170,8 @@ static inline void pudp_set_wrprotect(struct mm_struct *mm,
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp);
+extern pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma,
+				 unsigned long address, pmd_t *pmdp);
 #else
 static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 					unsigned long address,
@@ -1182,6 +1180,13 @@ static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 	BUILD_BUG();
 	return *pmdp;
 }
+static inline pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma,
+					unsigned long address,
+					pmd_t *pmdp)
+{
+	BUILD_BUG();
+	return *pmdp;
+}
 #define pmdp_collapse_flush pmdp_collapse_flush
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f790ec34400..0a98afc85c50 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1177,10 +1177,9 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * Parallel GUP-fast is fine since GUP-fast will back off when
 	 * it detects PMD is changed.
 	 */
-	_pmd = pmdp_collapse_flush(vma, address, pmd);
+	_pmd = pmdp_collapse_flush_sync(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
-	tlb_remove_table_sync_one();
 
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
@@ -1663,8 +1662,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 			}
 		}
 	}
-	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
-	pmdp_get_lockless_sync();
+	pgt_pmd = pmdp_collapse_flush_sync(vma, haddr, pmd);
 	pte_unmap_unlock(start_pte, ptl);
 	if (ptl != pml)
 		spin_unlock(pml);
@@ -1817,8 +1815,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 * races against the prior checks.
 		 */
 		if (likely(file_backed_vma_is_retractable(vma))) {
-			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
-			pmdp_get_lockless_sync();
+			pgt_pmd = pmdp_collapse_flush_sync(vma, addr, pmd);
 			success = true;
 		}
 
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index d3aec7a9926a..be2ee82e6fc4 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -233,6 +233,40 @@ pmd_t pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long address,
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
 }
+
+pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma, unsigned long address,
+			       pmd_t *pmdp)
+{
+	struct mmu_gather tlb;
+	pmd_t pmd;
+
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	VM_BUG_ON(pmd_trans_huge(*pmdp));
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
+
+	flush_tlb_mm_range(vma->vm_mm, address, address + HPAGE_PMD_SIZE,
+			   PAGE_SHIFT, true, &tlb);
+
+	/*
+	 * Synchronize with GUP-fast. If the flush sent IPIs, skip the
+	 * redundant sync IPI.
+	 */
+	tlb_gather_remove_table_sync_one(&tlb);
+	tlb_finish_mmu(&tlb);
+	return pmd;
+}
+#else
+pmd_t pmdp_collapse_flush_sync(struct vm_area_struct *vma, unsigned long address,
+			       pmd_t *pmdp)
+{
+	pmd_t pmd;
+
+	pmd = pmdp_collapse_flush(vma, address, pmdp);
+	tlb_remove_table_sync_one();
+	return pmd;
+}
 #endif
 
 /* arch define pte_free_defer in asm/pgalloc.h for its own implementation */
-- 
2.49.0


