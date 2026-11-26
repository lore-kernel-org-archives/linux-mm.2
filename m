Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E64F606A696
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=adyXU8A4
Received: by kanga.kvack.org (Postfix)
	id 2163A6B0603; Thu, 26 Nov 2026 06:21:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC816B0604; Thu, 26 Nov 2026 06:21:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102C36B0605; Thu, 26 Nov 2026 06:21:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6F546B0603
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:21:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 711491603BF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:07 +0000 (UTC)
X-FDA: 85477028574.08.081735E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A5183160008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=adyXU8A4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692065;
	b=LPH5tdcO2eqRSQyrlNynyWr4KeuC/V1JPva8QruOUplwhc93vhmgcqPGQfJ4rbGhSma7uE
	yHWvq89y/PeNLWNPg2S4x8pFYy2xiAQTJJYAqHtz/16M3XBLVJnNFrBK8OTp66nT2FZmji
	+zsmRRSCGiJIHC+zqevkH+77hwxzU6M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcH4qZMB5orcMEC0zIuy9P+600nvSbyhLpBWmGzi+gs=;
	b=NE09GD1HRWHPaKfDEyMd242c+4BcVJNd/IvTKreZUknghCZ4yKAPFcnZCfAeRWIMbFzXYa
	9ycVv+Q0K7+RNbHw0pZ6yOrVVdbyNNWibp6WSfpWDvl4zCI0lUbn/eb1RMYtsf/hVuvBze
	A//wEqABw/QAdmWuHKTNI3SmRwifWVw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=adyXU8A4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E44D941737;
	Thu, 26 Nov 2026 11:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A852C1F000E6;
	Thu, 26 Nov 2026 11:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692064;
	bh=CcH4qZMB5orcMEC0zIuy9P+600nvSbyhLpBWmGzi+gs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=adyXU8A4NuJONMA8Q7VJgDp23oFvH2FZLV/uHrSOE2zILfsx/dN1lCLk1qNu3OA7o
	 mHCLjvdUuw36ARH7DxpayccSk03eXupZSXwfnfXDHkMNsv06fjAOSnzMM078zeGcxr
	 RuciB9SLO+QaxO54EZTsnEC6nkHM9BHFVWxnp33fr9YXZz+wNgpQE1XZH/mQH5o/8C
	 ANaUpfZ7SudYf2ln+k2OavaJRVo3l5QJWxFUJJSbHswcFsCMem/HJ8rOTPMMprTs9E
	 wweGlLnF9KA/AJ8TsxRxSv+JX9dkm2cz6ri75admhNozqM37YzRh3VGIuDMq7HXa8d
	 L/i7B7UF2AAhg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:54 +0200
Subject: [PATCH RFC v2 41/54] riscv: use the generic CPA core
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-41-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A5183160008
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jsyxz87dmbxbse7coz7dy3nwrq6hha7s
X-HE-Tag: 1795692065-683742
X-HE-Meta: U2FsdGVkX1+eX36WUUCxns30O46oUW43E+33Dyek7zk9D6uItT2sM2b3lBQoVKNba8O7SGEj6Zx0WTlzC+mDd+zI5Apc5N7jYlr5y7Fe2oaYe/QKTf6BQA1dmN/ydAlH3vWZlwr+6/X/aIwwlNsFHXF5xHKY62XgF3KN6hCxMRcLR6/064kdTsAByUjnQqg1f+mBTsTSlO/LiLXB68P9NkoHSUNnkTAHcmUXEMv0qSLo2WDhQEUoZpM9ey2v52Ts8tvwFk5DF3zRL4IaLeYG0+2OCNg3SsjaGFI39Bq8mk39nqkSLkeot09DqC7MTPI4wLrbTfyl9I8Vh9Y/q1hnLkmATo49FfKmzvzplxWUFbhd2UDOUL8wX9/jJ7IMtx67XtJI/giQ0QYzfXWSGzd44phoBnd3YGJKkBUcM6KrLVexkhcJ9txUqPqy8gnkb86hCaccaxqgGm3fCxVTfs69u21mBEykdFnzIfZSh/S+aHe1A7Kpv6lsQP1C5Ur6Z1UPPeFVq6serrYy6QSDfbsQBE20+LqzwonksCMLZ31TPrftH2lp9XXvew4XtX4WYRlKJBUhJeL06rrwJTXRs0WSi0fhIi96VWaUSG3CdD3zpVnbi+pkcIE7L0eIbwgZ1731sz0MN/CXnreILPE8j3B67HD9nNUHTW8tNbOt9MNZDec3fkoLIGfRypTj0F3+5ubjXvjzINmChjFH9ugSUDv3iWM0SJ2EJk/qHX8AktHreDHf+xgT/1gitqo9G92r+8gaeoS0b1V+5eg5ET8Ud115OmvRuDjF2op4OVYmCCaGorctenw1tp3s/s2tH9yISLlc+FwUnCRu8vqK8/rWlznKq532XHOciDvo2zgNZtTuHMSSSlVSiUz9THck+fsIU8kxo6LE0vzv43GITdDXRJjScjFL2kGTMme5ON88ssXUKCxvMDEQ1L1VD1Ll4H//x/Z8Y3ARxcC1ye4b+uZkdEF
 IrzZK3a/
 J7ngmOI+VbaTVhe9g9yQLAqCWw5RR2WZVGHZeNjzMH+97O2RBdYPScgyrHrPlPukOsFB7F05UdH/JTjcMzcftsQZQHbBcxXrVBi6esNeV/zMCYTBhqkSzFU/mZ847ByiUKsqCyhi4ba7XLxEMx0eUhWhU74o/FIF11GcepW4P0ipCRKEJltfR6lbWXwK4W3t3MuH9r4KFG9SqdEDpa1BaYU+Ex6Yi/bFGQDSi+7dp4hjWThwFV7k41d1RcO6Xs1g2D16TtS2llL2Jpy7g4KHvNHnkzWL+7AwSkv5xe8+z1SaFkCvHWCoZUZ+4pkcjjoxjVScWjO948ul+w8Oh1E1L8/dIRoW0zaUM/xat1T1ijQCNk6DJxfPA2geZznxK6WtWA6JP7av40PkN4Pj+ZcoBX1eWVBN3ZYPT2EWLV4mDwATELffDVyCPm8jCkHWhEzd/nXQM1rmqdi9xbaizwaopHOiQB316+tF9JPv7Gd+7hZwPedtZLNJjuZVr0WiRXubp4ZDZdFPlU79zdXY1bXPRjYV14g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

riscv changes kernel page protections with a page table walk of its own,
and the walk gets several things wrong:

* it splits a large page that a request covers in part even when the
  request does not change it, like the linear map alias for set_memory_x()
* it splits the linear map alias of a vmalloc area down to PAGE_SIZE, page
  by page, even when the area is mapped with large pages
* it writes every entry in the range, including the empty ones
* for memory that is mapped but is not RAM, like ioremap(), it dereferences
  a NULL page array when it looks for the alias
* it flushes the entire TLB on every request, even for
  set_direct_map_*_noflush(), whose callers flush themselves

The availability of the generic CPA core makes riscv's implementation of
set_memory_*() APIs unnecessary and it can be replaced with several hooks
required by CPA core.

This way the core can manage the policy decisions and the architecture only
has to take care of the page table manipulation.

Switch to the generic CPA core and its set_memory() entry points, which
correct all of these:

* a large page is split only when a request changes a part of it, both in
  the requested range and in its alias
* an empty entry in the range is reported with a warning and -EFAULT
* memory that is not RAM has no alias to walk
* a request flushes the TLB for its range, and the entire TLB after a
  split, a change of an alias or a failure
* set_direct_map_*_noflush() flush only what they must: a split, and on
  32-bit an entry that becomes valid

Other changes that come with the core:

* requests are serialized by the core, rather than by the init_mm write
  lock; the page table dump may now run during a split, which never frees a
  table, and sees either the leaf or a complete table
* lazily unmapped vmap areas are purged before a request, so that they do
  not keep stale TLB entries with the old protection
* set_memory_rox() is a single request instead of set_memory_ro() followed
  by set_memory_x()
* a NAPOT block changes as a whole and is never split: a request on a part
  of one fails with a warning and -EINVAL; no kernel mapping uses NAPOT
  blocks yet

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/riscv/Kconfig                  |   1 +
 arch/riscv/include/asm/pageattr.h   |  17 ++
 arch/riscv/include/asm/set_memory.h |   8 +-
 arch/riscv/mm/pageattr.c            | 448 ++++++++++--------------------------
 4 files changed, 137 insertions(+), 337 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index e7891a2a89da..0453c665fc64 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -122,6 +122,7 @@ config RISCV
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
+	select GENERIC_PAGEATTR if MMU
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SCHED_CLOCK
diff --git a/arch/riscv/include/asm/pageattr.h b/arch/riscv/include/asm/pageattr.h
new file mode 100644
index 000000000000..137af4296ebb
--- /dev/null
+++ b/arch/riscv/include/asm/pageattr.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_RISCV_PAGEATTR_H
+#define _ASM_RISCV_PAGEATTR_H
+
+#ifdef CONFIG_64BIT
+#define cpa_is_direct_map(addr)	is_linear_mapping(addr)
+
+bool arch_cpa_can_split(struct cpa_data *cpa, struct cpa_leaf *leaf);
+int arch_cpa_split_leaf(struct cpa_data *cpa, struct cpa_leaf *leaf,
+			void *table);
+#define arch_cpa_can_split arch_cpa_can_split
+
+int arch_cpa_process_alias(struct cpa_data *cpa);
+#define arch_cpa_process_alias arch_cpa_process_alias
+#endif
+
+#endif /* _ASM_RISCV_PAGEATTR_H */
diff --git a/arch/riscv/include/asm/set_memory.h b/arch/riscv/include/asm/set_memory.h
index b9a8c7033c7a..edbf7d46f809 100644
--- a/arch/riscv/include/asm/set_memory.h
+++ b/arch/riscv/include/asm/set_memory.h
@@ -11,10 +11,8 @@
  * Functions to change memory attributes.
  */
 #ifdef CONFIG_MMU
-int set_memory_ro(unsigned long addr, int numpages);
-int set_memory_rw(unsigned long addr, int numpages);
-int set_memory_x(unsigned long addr, int numpages);
-int set_memory_nx(unsigned long addr, int numpages);
+#include <asm-generic/set_memory.h>
+
 static __always_inline int set_kernel_memory(char *startp, char *endp,
 					     int (*set_memory)(unsigned long start,
 							       int num_pages))
@@ -38,8 +36,6 @@ static inline int set_kernel_memory(char *startp, char *endp,
 }
 #endif
 
-int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
-int set_direct_map_default_noflush(struct page *page, unsigned int nr);
 bool kernel_page_present(struct page *page);
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 433ac98234ed..bb8629da0d1d 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -3,386 +3,172 @@
  * Copyright (C) 2019 SiFive
  */
 
-#include <linux/pagewalk.h>
+#include <linux/pageattr.h>
 #include <linux/pgtable.h>
 #include <linux/vmalloc.h>
+#include <linux/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/bitops.h>
 #include <asm/set_memory.h>
 
-struct pageattr_masks {
-	pgprot_t set_mask;
-	pgprot_t clear_mask;
-};
-
-static unsigned long set_pageattr_masks(unsigned long val, struct mm_walk *walk)
-{
-	struct pageattr_masks *masks = walk->private;
-	unsigned long new_val = val;
-
-	new_val &= ~(pgprot_val(masks->clear_mask));
-	new_val |= (pgprot_val(masks->set_mask));
-
-	return new_val;
-}
-
-static int pageattr_p4d_entry(p4d_t *p4d, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+void arch_cpa_decode_leaf(struct cpa_leaf *leaf)
 {
-	p4d_t val = p4dp_get(p4d);
+	pte_t pte = ptep_get(leaf->kpte);
+	unsigned long nr;
 
-	if (p4d_leaf(val)) {
-		val = __p4d(set_pageattr_masks(p4d_val(val), walk));
-		set_p4d(p4d, val);
+	/* The PTEs of a NAPOT block map one naturally aligned range */
+	if (leaf->level == PGTABLE_LEVEL_PTE && pte_napot(pte)) {
+		nr = pte_leaf_size(pte) / PAGE_SIZE;
+		leaf->kpte = PTR_ALIGN_DOWN(leaf->kpte, nr * sizeof(pte_t));
+		leaf->size = nr * PAGE_SIZE;
+		leaf->addr &= ~(leaf->size - 1);
 	}
 
-	return 0;
+	leaf->pfn = pte_pfn(pte);
+	leaf->prot = __pgprot(pte_val(pte) & ~_PAGE_PFN_MASK);
+}
+
+static void set_entry(pte_t *ptep, enum pgtable_level level, pte_t pte)
+{
+	switch (level) {
+	case PGTABLE_LEVEL_PTE:
+		set_pte(ptep, pte);
+		break;
+	case PGTABLE_LEVEL_PMD:
+		set_pmd((pmd_t *)ptep, pte_pmd(pte));
+		break;
+	case PGTABLE_LEVEL_PUD:
+		set_pud((pud_t *)ptep, pte_pud(pte));
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
 }
 
-static int pageattr_pud_entry(pud_t *pud, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+/*
+ * A hart may cache an invalid translation, and only 64-bit can defer the
+ * sfence.vma for a new valid mapping to the page fault handler.
+ */
+#ifdef CONFIG_64BIT
+static void mark_new_valid_leaf(struct cpa_leaf *leaf)
 {
-	pud_t val = pudp_get(pud);
-
-	if (pud_leaf(val)) {
-		val = __pud(set_pageattr_masks(pud_val(val), walk));
-		set_pud(pud, val);
-	}
-
-	return 0;
+	mark_new_valid_map();
 }
-
-static int pageattr_pmd_entry(pmd_t *pmd, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+#else
+static void mark_new_valid_leaf(struct cpa_leaf *leaf)
 {
-	pmd_t val = pmdp_get(pmd);
-
-	if (pmd_leaf(val)) {
-		val = __pmd(set_pageattr_masks(pmd_val(val), walk));
-		set_pmd(pmd, val);
-	}
-
-	return 0;
+	flush_tlb_kernel_range(leaf->addr, leaf->addr + leaf->size);
 }
+#endif
 
-static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+void arch_cpa_modify_leaf(struct cpa_leaf *leaf, pgprot_t prot)
 {
-	pte_t val = ptep_get(pte);
+	unsigned long nr = leaf->size / pgtable_level_size(leaf->level);
+	unsigned long pfn = leaf->pfn;
+	unsigned long i;
 
-	val = __pte(set_pageattr_masks(pte_val(val), walk));
-	set_pte(pte, val);
+	/*
+	 * Every PTE of a NAPOT block holds the base pfn with the size of the
+	 * block encoded in its low bits.
+	 */
+	if (nr > 1)
+		pfn |= nr / 2;
 
-	return 0;
-}
+	for (i = 0; i < nr; i++)
+		set_entry(leaf->kpte + i, leaf->level, pfn_pte(pfn, prot));
 
-static int pageattr_pte_hole(unsigned long addr, unsigned long next,
-			     int depth, struct mm_walk *walk)
-{
-	/* Nothing to do here */
-	return 0;
+	if (!(pgprot_val(leaf->prot) & _PAGE_PRESENT) &&
+	    (pgprot_val(prot) & _PAGE_PRESENT))
+		mark_new_valid_leaf(leaf);
 }
 
-static const struct mm_walk_ops pageattr_ops = {
-	.p4d_entry = pageattr_p4d_entry,
-	.pud_entry = pageattr_pud_entry,
-	.pmd_entry = pageattr_pmd_entry,
-	.pte_entry = pageattr_pte_entry,
-	.pte_hole = pageattr_pte_hole,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
-#ifdef CONFIG_64BIT
-static int __split_linear_mapping_pmd(pud_t *pudp,
-				      unsigned long vaddr, unsigned long end)
+void arch_cpa_flush(struct cpa_data *cpa)
 {
-	pmd_t *pmdp;
-	unsigned long next;
-
-	pmdp = pmd_offset(pudp, vaddr);
-
-	do {
-		next = pmd_addr_end(vaddr, end);
-
-		if (next - vaddr >= PMD_SIZE &&
-		    vaddr <= (vaddr & PMD_MASK) && end >= next)
-			continue;
-
-		if (pmd_leaf(pmdp_get(pmdp))) {
-			struct page *pte_page;
-			unsigned long pfn = _pmd_pfn(pmdp_get(pmdp));
-			pgprot_t prot = __pgprot(pmd_val(pmdp_get(pmdp)) & ~_PAGE_PFN_MASK);
-			pte_t *ptep_new;
-			int i;
-
-			pte_page = alloc_page(GFP_KERNEL);
-			if (!pte_page)
-				return -ENOMEM;
-
-			ptep_new = (pte_t *)page_address(pte_page);
-			for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep_new)
-				set_pte(ptep_new, pfn_pte(pfn + i, prot));
-
-			smp_wmb();
-
-			set_pmd(pmdp, pfn_pmd(page_to_pfn(pte_page), PAGE_TABLE));
-		}
-	} while (pmdp++, vaddr = next, vaddr != end);
+	if (cpa->state & CPA_ST_FLUSH_ALL) {
+		flush_tlb_all();
+		return;
+	}
 
-	return 0;
+	cpa_flush_tlb_kernel_range(cpa);
 }
 
-static int __split_linear_mapping_pud(p4d_t *p4dp,
-				      unsigned long vaddr, unsigned long end)
+#ifdef CONFIG_64BIT
+bool arch_cpa_can_split(struct cpa_data *cpa, struct cpa_leaf *leaf)
 {
-	pud_t *pudp;
-	unsigned long next;
-	int ret;
-
-	pudp = pud_offset(p4dp, vaddr);
-
-	do {
-		next = pud_addr_end(vaddr, end);
-
-		if (next - vaddr >= PUD_SIZE &&
-		    vaddr <= (vaddr & PUD_MASK) && end >= next)
-			continue;
-
-		if (pud_leaf(pudp_get(pudp))) {
-			struct page *pmd_page;
-			unsigned long pfn = _pud_pfn(pudp_get(pudp));
-			pgprot_t prot = __pgprot(pud_val(pudp_get(pudp)) & ~_PAGE_PFN_MASK);
-			pmd_t *pmdp_new;
-			int i;
+	unsigned long size = pgtable_level_size(leaf->level);
 
-			pmd_page = alloc_page(GFP_KERNEL);
-			if (!pmd_page)
-				return -ENOMEM;
-
-			pmdp_new = (pmd_t *)page_address(pmd_page);
-			for (i = 0; i < PTRS_PER_PMD; ++i, ++pmdp_new)
-				set_pmd(pmdp_new,
-					pfn_pmd(pfn + ((i * PMD_SIZE) >> PAGE_SHIFT), prot));
-
-			smp_wmb();
-
-			set_pud(pudp, pfn_pud(page_to_pfn(pmd_page), PAGE_TABLE));
-		}
-
-		ret = __split_linear_mapping_pmd(pudp, vaddr, next);
-		if (ret)
-			return ret;
-	} while (pudp++, vaddr = next, vaddr != end);
+	/*
+	 * A top level leaf cannot be split because the change would have to
+	 * be propagated to the page tables of all processes.
+	 * Sv39 folds the PUD level into the top level.
+	 */
+	if (!pgtable_l4_enabled() && leaf->level == PGTABLE_LEVEL_PUD)
+		return false;
 
-	return 0;
+	/* A NAPOT block changes as a whole and is never split */
+	return leaf->size == size;
 }
 
-static int __split_linear_mapping_p4d(pgd_t *pgdp,
-				      unsigned long vaddr, unsigned long end)
+int arch_cpa_split_leaf(struct cpa_data *cpa, struct cpa_leaf *leaf,
+			void *table)
 {
-	p4d_t *p4dp;
-	unsigned long next;
-	int ret;
-
-	p4dp = p4d_offset(pgdp, vaddr);
-
-	do {
-		next = p4d_addr_end(vaddr, end);
-
-		/*
-		 * If [vaddr; end] contains [vaddr & P4D_MASK; next], we don't
-		 * need to split, we'll change the protections on the whole P4D.
-		 */
-		if (next - vaddr >= P4D_SIZE &&
-		    vaddr <= (vaddr & P4D_MASK) && end >= next)
-			continue;
-
-		if (p4d_leaf(p4dp_get(p4dp))) {
-			struct page *pud_page;
-			unsigned long pfn = _p4d_pfn(p4dp_get(p4dp));
-			pgprot_t prot = __pgprot(p4d_val(p4dp_get(p4dp)) & ~_PAGE_PFN_MASK);
-			pud_t *pudp_new;
-			int i;
-
-			pud_page = alloc_page(GFP_KERNEL);
-			if (!pud_page)
-				return -ENOMEM;
-
-			/*
-			 * Fill the pud level with leaf puds that have the same
-			 * protections as the leaf p4d.
-			 */
-			pudp_new = (pud_t *)page_address(pud_page);
-			for (i = 0; i < PTRS_PER_PUD; ++i, ++pudp_new)
-				set_pud(pudp_new,
-					pfn_pud(pfn + ((i * PUD_SIZE) >> PAGE_SHIFT), prot));
-
-			/*
-			 * Make sure the pud filling is not reordered with the
-			 * p4d store which could result in seeing a partially
-			 * filled pud level.
-			 */
-			smp_wmb();
-
-			set_p4d(p4dp, pfn_p4d(page_to_pfn(pud_page), PAGE_TABLE));
-		}
-
-		ret = __split_linear_mapping_pud(p4dp, vaddr, next);
-		if (ret)
-			return ret;
-	} while (p4dp++, vaddr = next, vaddr != end);
-
-	return 0;
-}
+	enum pgtable_level level = leaf->level;
+	unsigned long pfn = leaf->pfn, pfninc;
+	pgprot_t prot = leaf->prot;
+	pte_t *kpte = leaf->kpte;
+	pte_t *ptep = table;
+	int i;
 
-static int __split_linear_mapping_pgd(pgd_t *pgdp,
-				      unsigned long vaddr,
-				      unsigned long end)
-{
-	unsigned long next;
-	int ret;
+	pfninc = pgtable_level_size(level - 1) >> PAGE_SHIFT;
+	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
+		set_entry(ptep + i, level - 1, pfn_pte(pfn, prot));
 
-	do {
-		next = pgd_addr_end(vaddr, end);
-		/* We never use PGD mappings for the linear mapping */
-		ret = __split_linear_mapping_p4d(pgdp, vaddr, next);
-		if (ret)
-			return ret;
-	} while (pgdp++, vaddr = next, vaddr != end);
+	/* The table must be complete before a walk can find it. */
+	smp_wmb();
+	set_entry(kpte, level, pfn_pte(virt_to_pfn(table), PAGE_TABLE));
+	/* A changed non-leaf entry needs an sfence.vma for all addresses */
+	flush_tlb_all();
 
 	return 0;
 }
 
-static int split_linear_mapping(unsigned long start, unsigned long end)
+int arch_cpa_process_alias(struct cpa_data *cpa)
 {
-	return __split_linear_mapping_pgd(pgd_offset_k(start), start, end);
-}
-#endif	/* CONFIG_64BIT */
+	unsigned long vaddr = cpa_addr(cpa, cpa->curpage);
+	struct cpa_data alias_cpa;
 
-static int __set_memory(unsigned long addr, int numpages, pgprot_t set_mask,
-			pgprot_t clear_mask)
-{
-	int ret;
-	unsigned long start = addr;
-	unsigned long end = start + PAGE_SIZE * numpages;
-	unsigned long __maybe_unused lm_start;
-	unsigned long __maybe_unused lm_end;
-	struct pageattr_masks masks = {
-		.set_mask = set_mask,
-		.clear_mask = clear_mask
-	};
-	struct pageattr_masks __maybe_unused lm_masks = {
-		.set_mask = __pgprot(pgprot_val(set_mask) & ~_PAGE_EXEC),
-		.clear_mask = clear_mask
-	};
-
-	if (!numpages)
+	/* Memory that is not RAM, like ioremap(), has no linear map alias. */
+	if (cpa_is_direct_map(vaddr) || !pfn_valid(cpa->pfn))
 		return 0;
 
-	mmap_write_lock(&init_mm);
-
-#ifdef CONFIG_64BIT
-	/*
-	 * We are about to change the permissions of a kernel mapping, we must
-	 * apply the same changes to its linear mapping alias, which may imply
-	 * splitting a huge mapping.
-	 */
-
-	if (is_vmalloc_or_module_addr((void *)start)) {
-		struct vm_struct *area = NULL;
-		int i, page_start;
-
-		area = find_vm_area((void *)start);
-		page_start = (start - (unsigned long)area->addr) >> PAGE_SHIFT;
-
-		for (i = page_start; i < page_start + numpages; ++i) {
-			lm_start = (unsigned long)page_address(area->pages[i]);
-			lm_end = lm_start + PAGE_SIZE;
-
-			ret = split_linear_mapping(lm_start, lm_end);
-			if (ret)
-				goto unlock;
-
-			ret = walk_kernel_page_table_range(lm_start, lm_end,
-						    &pageattr_ops, NULL,
-						    &lm_masks);
-			if (ret)
-				goto unlock;
-		}
-	} else if (is_kernel_mapping(start) || is_linear_mapping(start)) {
-		if (is_kernel_mapping(start)) {
-			lm_start = (unsigned long)lm_alias(start);
-			lm_end = (unsigned long)lm_alias(end);
-		} else {
-			lm_start = start;
-			lm_end = end;
-		}
-
-		ret = split_linear_mapping(lm_start, lm_end);
-		if (ret)
-			goto unlock;
-
-		ret = walk_kernel_page_table_range(lm_start, lm_end,
-					    &pageattr_ops, NULL, &lm_masks);
-		if (ret)
-			goto unlock;
-	}
-
-	ret =  walk_kernel_page_table_range(start, end, &pageattr_ops, NULL,
-				     &masks);
-
-unlock:
-	mmap_write_unlock(&init_mm);
+	alias_cpa = *cpa;
+	alias_cpa.addr = (unsigned long)pfn_to_virt(cpa->pfn);
+	pgprot_val(alias_cpa.mask_set) &= ~_PAGE_EXEC;
+	pgprot_val(alias_cpa.mask_clr) &= ~_PAGE_EXEC;
 
-	/*
-	 * We can't use flush_tlb_kernel_range() here as we may have split a
-	 * hugepage that is larger than that, so let's flush everything.
-	 */
-	flush_tlb_all();
-#else
-	ret =  walk_kernel_page_table_range(start, end, &pageattr_ops, NULL,
-				     &masks);
-
-	mmap_write_unlock(&init_mm);
-
-	flush_tlb_kernel_range(start, end);
-#endif
-
-	return ret;
-}
-
-int set_memory_ro(unsigned long addr, int numpages)
-{
-	return __set_memory(addr, numpages, __pgprot(_PAGE_READ),
-			    __pgprot(_PAGE_WRITE));
-}
-
-int set_memory_rw(unsigned long addr, int numpages)
-{
-	return __set_memory(addr, numpages, __pgprot(_PAGE_READ | _PAGE_WRITE),
-			    __pgprot(0));
-}
-
-int set_memory_x(unsigned long addr, int numpages)
-{
-	return __set_memory(addr, numpages, __pgprot(_PAGE_EXEC), __pgprot(0));
+	return cpa_change_alias(cpa, &alias_cpa);
 }
+#endif	/* CONFIG_64BIT */
 
-int set_memory_nx(unsigned long addr, int numpages)
-{
-	return __set_memory(addr, numpages, __pgprot(0), __pgprot(_PAGE_EXEC));
-}
+static const struct cpa_op_prot cpa_ops[CPA_OP_NR] = {
+	[CPA_OP_RO]	= { .set = __pgprot(_PAGE_READ),
+			    .clr = __pgprot(_PAGE_WRITE) },
+	[CPA_OP_RW]	= { .set = __pgprot(_PAGE_READ | _PAGE_WRITE) },
+	[CPA_OP_X]	= { .set = __pgprot(_PAGE_EXEC) },
+	[CPA_OP_NX]	= { .clr = __pgprot(_PAGE_EXEC) },
+	[CPA_OP_ROX]	= { .set = __pgprot(_PAGE_READ | _PAGE_EXEC),
+			    .clr = __pgprot(_PAGE_WRITE) },
+	[CPA_OP_DIRECT_MAP_INVALID] = { .clr = __pgprot(_PAGE_PRESENT) },
+	[CPA_OP_DIRECT_MAP_DEFAULT] = { .set = PAGE_KERNEL,
+					.clr = __pgprot(_PAGE_EXEC) },
+};
 
-int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
+int arch_cpa_prepare(struct cpa_data *cpa, enum cpa_op op)
 {
-	return __set_memory((unsigned long)page_address(page), nr,
-			    __pgprot(0), __pgprot(_PAGE_PRESENT));
-}
+	cpa_init_op(cpa, &cpa_ops[op]);
 
-int set_direct_map_default_noflush(struct page *page, unsigned int nr)
-{
-	return __set_memory((unsigned long)page_address(page), nr,
-			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
+	return 0;
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC

-- 
2.53.0


