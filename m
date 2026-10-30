Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96651606AC2D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 11:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gFmP0aln
Received: by kanga.kvack.org (Postfix)
	id AEF456B05B7; Fri, 30 Oct 2026 07:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACBC86B05B8; Fri, 30 Oct 2026 07:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC846B05B9; Fri, 30 Oct 2026 07:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 774376B05B7
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:00:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C67B1A06A5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:00:02 +0000 (UTC)
X-FDA: 85378997844.22.5423A34
Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	by imf04.hostedemail.com (Postfix) with ESMTP id 18DA740009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:59:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gFmP0aln;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793358000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRw0eONyMI0aesv8iSIZvQMhm1F3UrNmZKIZy63sJCU=;
	b=0BbdZbimtF2C1OAXHitQ3KN7l+WhWmQwURXmB7MLARJNYfIjKu92B2We9UWRENkroHnbe+
	vDzNlLr72yjkkj/IrdWaXY2vJIUeFhK9pI1nEUqTX75ho4GMxnb2fKCLmB6Hla50qwV2nh
	2DOJjEH/jy/bbVUGGSH3eGfYkvA0nHU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gFmP0aln;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793358000;
	b=OCK1OXc1JFGOtyYBLgDOaT1WpbEHixvuWoirZkO+oI/9bQlCS3a7RtVYIMHsMa2RJoHvXY
	tPCys2ykJvc/hKXYS/p3c0EppT3RtJ/Utn13SxtNLUBtL1FHA+rjy7oh+fUTIO8GWmATjw
	JX6oN96HZDUpwyMvZEzUxTgFY4XylRk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Xvi5KNjnUNgFYmy8o8KNB4Su4NYMJfcH+HIyAbsvVmY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793357998; v=1; x=1793962798;
 b=gFmP0alniqK3Q0vS/ktp6PiXW0dA1EMgfRWdUgU9LyHjzTEttQaVOAlP+fzz1O+MVqRCjMmH
 f52mdQwGXsRq4uQJ8u88wl3preiqWL7ysZrwnUNwwpK+ajYxdHAzU09TiYG2PnIKV+XjDPgir9F
 jnirJFu1ie973VRPZF65DrtI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 79fb9df180a5e2f4;
	Fri, 30 Oct 2026 10:59:58 +0000
X-Mizu-Trace-ID: 79fb9df180a5e2f4
X-Migadu-Flow: FLOW_OUT
From: Jackie Liu <liu.yun@linux.dev>
To: akpm@linux-foundation.org
Cc: palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	glider@google.com,
	dvyukov@google.com,
	elver@google.com,
	pjw@kernel.org,
	alex@ghiti.fr,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com
Subject: [PATCH 2/2] riscv: Prepare late KFENCE pools with PTE mappings
Date: Fri, 30 Oct 2026 18:59:33 +0800
Message-ID: <20261030105933.4180-3-liu.yun@linux.dev>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030105933.4180-1-liu.yun@linux.dev>
References: <20261030105933.4180-1-liu.yun@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 18DA740009
X-Rspam-User: 
X-Stat-Signature: 87zwm8pdferkiaub9xsjucq6g868i8y8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793357999-930925
X-HE-Meta: U2FsdGVkX19oO4R6U7fn/q9UrUH28JvVKVguA9kXyT+wMAX4D/0Bt0xwHpGBrJ3Eeu3ZjQSqtGWnL6EyejKqmHtJExooVwCZ6yoVB+LsN0gQt9YWD8J0aP3WYE7JnoNchoYhWYKie/FOUNGyElG9CdqHB4u79wIoWtWjvDq74VW94Oe6ebGGvAw88swGax3ggyW+3aQQ1YDJV3nIxyaHkgbphIwig3l/fo4g22vXBauclfh+cDBdm6BQNCOiZu5i4sIkFhyWito3cU2bZmwnhIb2hhuHGdxte+0tCz82iDrxI1slUgFoCTBaD1nRC2RkR6ncIDgK3G1TQKhPtFyKhufAOqQ5Qq/cmB5xV7KMWSy0tBr049fReFMhqlpyOU09SLIWFE7axB42FhjXAJBtUGwF2sw6V7WmL1KYnVRJ4l7TdFOQnulsTJmPg1Q075Q4iHVkuf4hL04ZkEfclVwx9Zd+PnduQoCHP6lfO0xlItU1/35TQsWsDtUfASIzz4kAicrQIStMT4k3hlnfslL1N9egu8KXAru9tDJ45jt8vHVK+ckmfaKdxS7zc+PMA0Brtrnraf5rc4Wao7F7FEw4kHXlYS10jsh2d4D7x8bLaSxDoCGYcGhjFuPAqozVrgCC7gQnKN4J5zda13DsAU6w6UT2u+4h/iTUnROgvWIGwJu0o7WJ2J0o1JspJkKjYjF0D5NPmDo3nQKSVTM1U5JUKhmO4xI8THBR7NHbUmn6k3eqQSc+QGSQWOBzuDH0lFq8QgQbv2XW710R2EI8+6QkewBC9eR0fHxTZ9ZbXNP0tnJlJ19XohZa3OOK3aB71bmp/zuwQ5h5NvpYBp3qhzDi1yLAjRrkevZnjT80sPiOXp9iSziPzDLdulxelJtyKpw/yrQc04332BpU03U3HsNSfky6nMrraovSgVt2M1V9MjnVwINd7ed6h5QUZV0wnQydC40c4rVJDvuqeBi1xIF
 bQF0MHIU
 W+byFTo1zSV7MfkFhlbebIZ6POhDeOgD3sDkAdNw+k/b7tS2RPEEHkTdmEpNakJlm33X1sqiTwgg4ZzuKmXudFVADRh2o+D/jlqlmOGnE5IOzXin/UYRNNgBAwFoJ1OVJIRGafdqtTAOaxKATgfvZ1sZp+x4A529F62Zq3cvkS9+Zugktb40CHoemfu1rmkEsm6XOpzo3taaktxN9ESPtjs+j9RgIq/v3riTqnJ/eAiTiPOykdsy5nMz93qVkcnYh6YdY0kUqLtonSD1IfBZCnsNJqXJjBlwr32UR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jackie Liu <liuyun01@kylinos.cn>

RISC-V preallocates a PTE-mapped KFENCE pool, but pools allocated after
boot may use huge mappings. arch_kfence_init_pool() leaves those mappings
unchanged, while kfence_protect_page() requires PTEs.

Use set_memory_4k() to prepare each pool. Add a force_pte mode to the
linear-map splitter so fully covered huge mappings are split as well.
Preserve permissions and flush the TLB even if splitting fails partway.

Keep the early PTE mapping to avoid boot-time page-table allocations.
Release that pool when boot parameters disable sampling, so late enabling
initializes a fresh pool. If reservation fails, continue booting with
sampling disabled to avoid an unprepared fallback pool, while allowing
a later retry.

Link: https://lore.kernel.org/all/sashiko-outbox-190189@kernel.org/
Fixes: 25abe0db9243 ("riscv: Fix kfence now that the linear mapping can be backed by PUD/P4D/PGD")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 arch/riscv/include/asm/kfence.h     |  4 ++-
 arch/riscv/include/asm/set_memory.h |  3 ++
 arch/riscv/mm/init.c                | 23 +++++++++---
 arch/riscv/mm/pageattr.c            | 56 ++++++++++++++++++++---------
 4 files changed, 65 insertions(+), 21 deletions(-)

diff --git a/arch/riscv/include/asm/kfence.h b/arch/riscv/include/asm/kfence.h
index 29cb3a6ee113d..d7bc84cc5107a 100644
--- a/arch/riscv/include/asm/kfence.h
+++ b/arch/riscv/include/asm/kfence.h
@@ -8,10 +8,12 @@
 #include <asm-generic/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
+#include <asm/set_memory.h>
 
 static inline bool arch_kfence_init_pool(void)
 {
-	return true;
+	return !set_memory_4k((unsigned long)__kfence_pool,
+			      KFENCE_POOL_SIZE / PAGE_SIZE);
 }
 
 static inline bool kfence_protect_page(unsigned long addr, bool protect)
diff --git a/arch/riscv/include/asm/set_memory.h b/arch/riscv/include/asm/set_memory.h
index e9f9960c19477..dfd41466265f3 100644
--- a/arch/riscv/include/asm/set_memory.h
+++ b/arch/riscv/include/asm/set_memory.h
@@ -11,6 +11,9 @@
  * Functions to change memory attributes.
  */
 #ifdef CONFIG_MMU
+#ifdef CONFIG_64BIT
+int set_memory_4k(unsigned long addr, int numpages);
+#endif
 int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index b50de11605c6c..aee6fc4d6c5df 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -173,6 +173,16 @@ void __init arch_mm_preinit(void)
 	BUG_ON(!mem_map);
 #endif /* CONFIG_FLATMEM */
 
+#ifdef CONFIG_KFENCE
+	/* Boot parameters have been parsed, and memblock can still free the pool. */
+	if (!__kfence_pool) {
+		kfence_sample_interval = 0;
+	} else if (!kfence_sample_interval) {
+		memblock_free(__kfence_pool, KFENCE_POOL_SIZE);
+		__kfence_pool = NULL;
+	}
+#endif
+
 	if (IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) && !swiotlb &&
 	    dma_cache_alignment != 1) {
 		/*
@@ -1230,10 +1240,12 @@ static void __init create_linear_mapping_page_table(void)
 	 *  for this region.
 	 */
 	kfence_pool = memblock_phys_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
-	BUG_ON(!kfence_pool);
-
-	memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
-	__kfence_pool = __va(kfence_pool);
+	if (kfence_pool) {
+		memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
+		__kfence_pool = __va(kfence_pool);
+	} else {
+		pr_err("failed to allocate kfence pool\n");
+	}
 #endif
 
 	/* Map all memory banks in the linear mapping */
@@ -1254,6 +1266,9 @@ static void __init create_linear_mapping_page_table(void)
 #endif
 
 #ifdef CONFIG_KFENCE
+	if (!kfence_pool)
+		return;
+
 	create_linear_mapping_range(kfence_pool, kfence_pool + KFENCE_POOL_SIZE, PAGE_SIZE, NULL);
 
 	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 32834a09a8097..35990e7f9ebe5 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -94,7 +94,8 @@ static const struct mm_walk_ops pageattr_ops = {
 
 #ifdef CONFIG_64BIT
 static int __split_linear_mapping_pmd(pud_t *pudp,
-				      unsigned long vaddr, unsigned long end)
+				      unsigned long vaddr, unsigned long end,
+				      bool force_pte)
 {
 	pmd_t *pmdp;
 	unsigned long next;
@@ -104,7 +105,7 @@ static int __split_linear_mapping_pmd(pud_t *pudp,
 	do {
 		next = pmd_addr_end(vaddr, end);
 
-		if (next - vaddr >= PMD_SIZE &&
+		if (!force_pte && next - vaddr >= PMD_SIZE &&
 		    vaddr <= (vaddr & PMD_MASK) && end >= next)
 			continue;
 
@@ -133,7 +134,8 @@ static int __split_linear_mapping_pmd(pud_t *pudp,
 }
 
 static int __split_linear_mapping_pud(p4d_t *p4dp,
-				      unsigned long vaddr, unsigned long end)
+				      unsigned long vaddr, unsigned long end,
+				      bool force_pte)
 {
 	pud_t *pudp;
 	unsigned long next;
@@ -144,7 +146,7 @@ static int __split_linear_mapping_pud(p4d_t *p4dp,
 	do {
 		next = pud_addr_end(vaddr, end);
 
-		if (next - vaddr >= PUD_SIZE &&
+		if (!force_pte && next - vaddr >= PUD_SIZE &&
 		    vaddr <= (vaddr & PUD_MASK) && end >= next)
 			continue;
 
@@ -169,7 +171,7 @@ static int __split_linear_mapping_pud(p4d_t *p4dp,
 			set_pud(pudp, pfn_pud(page_to_pfn(pmd_page), PAGE_TABLE));
 		}
 
-		ret = __split_linear_mapping_pmd(pudp, vaddr, next);
+		ret = __split_linear_mapping_pmd(pudp, vaddr, next, force_pte);
 		if (ret)
 			return ret;
 	} while (pudp++, vaddr = next, vaddr != end);
@@ -178,7 +180,8 @@ static int __split_linear_mapping_pud(p4d_t *p4dp,
 }
 
 static int __split_linear_mapping_p4d(pgd_t *pgdp,
-				      unsigned long vaddr, unsigned long end)
+				      unsigned long vaddr, unsigned long end,
+				      bool force_pte)
 {
 	p4d_t *p4dp;
 	unsigned long next;
@@ -190,10 +193,10 @@ static int __split_linear_mapping_p4d(pgd_t *pgdp,
 		next = p4d_addr_end(vaddr, end);
 
 		/*
-		 * If [vaddr; end] contains [vaddr & P4D_MASK; next], we don't
-		 * need to split, we'll change the protections on the whole P4D.
+		 * Unless PTE mappings are required, change the protections of a
+		 * fully covered P4D mapping without splitting it.
 		 */
-		if (next - vaddr >= P4D_SIZE &&
+		if (!force_pte && next - vaddr >= P4D_SIZE &&
 		    vaddr <= (vaddr & P4D_MASK) && end >= next)
 			continue;
 
@@ -228,7 +231,7 @@ static int __split_linear_mapping_p4d(pgd_t *pgdp,
 			set_p4d(p4dp, pfn_p4d(page_to_pfn(pud_page), PAGE_TABLE));
 		}
 
-		ret = __split_linear_mapping_pud(p4dp, vaddr, next);
+		ret = __split_linear_mapping_pud(p4dp, vaddr, next, force_pte);
 		if (ret)
 			return ret;
 	} while (p4dp++, vaddr = next, vaddr != end);
@@ -238,7 +241,7 @@ static int __split_linear_mapping_p4d(pgd_t *pgdp,
 
 static int __split_linear_mapping_pgd(pgd_t *pgdp,
 				      unsigned long vaddr,
-				      unsigned long end)
+				      unsigned long end, bool force_pte)
 {
 	unsigned long next;
 	int ret;
@@ -246,7 +249,7 @@ static int __split_linear_mapping_pgd(pgd_t *pgdp,
 	do {
 		next = pgd_addr_end(vaddr, end);
 		/* We never use PGD mappings for the linear mapping */
-		ret = __split_linear_mapping_p4d(pgdp, vaddr, next);
+		ret = __split_linear_mapping_p4d(pgdp, vaddr, next, force_pte);
 		if (ret)
 			return ret;
 	} while (pgdp++, vaddr = next, vaddr != end);
@@ -254,9 +257,30 @@ static int __split_linear_mapping_pgd(pgd_t *pgdp,
 	return 0;
 }
 
-static int split_linear_mapping(unsigned long start, unsigned long end)
+static int split_linear_mapping(unsigned long start, unsigned long end,
+				bool force_pte)
 {
-	return __split_linear_mapping_pgd(pgd_offset_k(start), start, end);
+	return __split_linear_mapping_pgd(pgd_offset_k(start), start, end, force_pte);
+}
+
+/* Split the direct map into base pages without changing its permissions. */
+int set_memory_4k(unsigned long addr, int numpages)
+{
+	unsigned long end = addr + PAGE_SIZE * numpages;
+	int ret;
+
+	if (!numpages)
+		return 0;
+	if (!is_linear_mapping(addr) || !is_linear_mapping(end - 1))
+		return -EINVAL;
+
+	mmap_write_lock(&init_mm);
+	ret = split_linear_mapping(addr, end, true);
+	mmap_write_unlock(&init_mm);
+
+	/* A failed allocation may still have split an upper-level mapping. */
+	flush_tlb_all();
+	return ret;
 }
 #endif	/* CONFIG_64BIT */
 
@@ -296,7 +320,7 @@ static int __set_memory(unsigned long addr, int numpages, pgprot_t set_mask,
 			lm_start = (unsigned long)page_address(area->pages[i]);
 			lm_end = lm_start + PAGE_SIZE;
 
-			ret = split_linear_mapping(lm_start, lm_end);
+			ret = split_linear_mapping(lm_start, lm_end, false);
 			if (ret)
 				goto unlock;
 
@@ -314,7 +338,7 @@ static int __set_memory(unsigned long addr, int numpages, pgprot_t set_mask,
 			lm_end = end;
 		}
 
-		ret = split_linear_mapping(lm_start, lm_end);
+		ret = split_linear_mapping(lm_start, lm_end, false);
 		if (ret)
 			goto unlock;
 
-- 
2.43.0


