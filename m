Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB42606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hYOuMxLC
Received: by kanga.kvack.org (Postfix)
	id 2DC8F6B0271; Wed, 21 Oct 2026 19:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28DCF6B0272; Wed, 21 Oct 2026 19:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A34B6B0276; Wed, 21 Oct 2026 19:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E27146B0271
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:35:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3714640743
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:35:06 +0000 (UTC)
X-FDA: 85348241412.26.2D379A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 81FA018000B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:35:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYOuMxLC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792625704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEOUCmLCD5QmSlPVT91FgaQC8nC2swbBcRqpaDjjQfI=;
	b=tkLDOxy1bwm4QMKO4a20pb8o3N6Y9zFgclt4QWTpJFSEl/M3xaGErM6xzZlKhs7/h6MXWP
	T2hc2SA2Q1khDm54+YX5J5hzM8siOkiq5CemXk0/Hed1do93dD64vdFBH3gYUQ4p8m5gdo
	eGlyAfRLHybF/pMxfgd8AdGuT7pAczU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYOuMxLC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792625704;
	b=lUj9ZbCQ9nufwLvsYIsLoD8O7pdKRE8CF8YKJAkmh2VoCQuP39Wt3iXIV81GRrsHZrBDWb
	z5DxmBLAOjkxwKnpO17ImBNAAouCj1Yk9bA5Pg07W4vvFv6cU6TBsV/jLlzG96Dz2C3l8D
	BAIKnKeEDHTrXzw/4XrIuvA6Oz4Mie4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF62D44792;
	Wed, 21 Oct 2026 23:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1136D1F000C5;
	Wed, 21 Oct 2026 23:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792625703;
	bh=DEOUCmLCD5QmSlPVT91FgaQC8nC2swbBcRqpaDjjQfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYOuMxLCYjqvimZsnFLqsnr3/JOHhHgPWYktNKOG+xa58rA/PdajZ93TkVMaAE9u/
	 z9wRqTy3u+ueUpn1AjkmWnuIiREYvygff12YHIlpDGJRkBqLF2CGRhYj0ncj+oXmNl
	 LzcvebJMEjfbpM6b2VaBVlQ83xSjdC2YAEbS5eRPaPpZUkKOoXSr3nQWGM2ot83rwK
	 GCFlL0IW+gillXAiO0AeOMcgiiiDbPU/aLiP08fQbq5A9ulC3iRYnDI0B4NnGt4Gy/
	 MTaybh72CKj1z5smIElrxh74E0jVGtMDfTVB5XQwIVDbB1sOrh76/0j6SgpLB0VS5Q
	 D0NkMloHM9pzw==
From: Imre Kaloz <kaloz@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Stian Halseth <stian@itx.no>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: [PATCH v3 3/4] sparc64: flush vmalloc ranges from the D-cache on map and unmap
Date: Thu, 22 Oct 2026 01:33:39 +0200
Message-ID: <55b4691ea87be7f4a679197bc2ec35b81b45d233.1792609488.git.kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1792609488.git.kaloz@kernel.org>
References: <cover.1792609488.git.kaloz@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81FA018000B
X-Stat-Signature: gpn5r5w4n3nitb6jpbh5uoue44yx8dju
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792625704-471242
X-HE-Meta: U2FsdGVkX1+M3i18Jxh5ZZE7/wzvjWOHjyKB77Lj8YvcpA/ODzAObMPgwnmLLZtIUZBBEd628+w4h/J2AyP4hyKm+7/HTJ0KEMcGEDlKAobBY0HfWyOCBlFe57NA9nIPryu42dPKsdOHNZifNNYKqEWFNVTHibHDUKPf6GA/x5e56dRrsr/vkcrBtWeqoeBKqoZ8LONX50IIi0NoYn/5XsiyG4xNGNlNm5GmFhnbQP8T7N+7yR6Io3RawwZBGl56TfkXeK0ZtTbdsF/2UeWx1OOx3JWe1g4Seca0LeEhH7gHUUfDuh8SpdonZXO/Ln1xvIm52Zlb9QHVyhsJHXtISJDUgyFEVl3GNXtga1sVT4WQSqZZdY5oEwZ6JX9uTR2IqJWvpehFxTkIfCzs5lS0ac8qHGsOUuy0Q5BqDkvsL9RWOaGcAJ0kQ0q6yvZd6Wr+ALrvA3+utT5WCDXPdDhRdi41c4uwvejShBwJ2SmQI+kql3PNVjAO0SEGOjSPVu6bO3kesvTiEAe6sL7hwx8eZ2DgKGLWcG7ycNLkvCo4Eo5eNGPhiESqDRS/UHbr/LpphUEvVpzR3zoYVsWqsg1Imkla2Ay9kr2/tIAslBUekaNdZLQ20s3w49NsWPWM3/+MLg/Wnx+xrEP57SY8QTQuzmWOqEy/C40OoW/Zi3m6pxcxS2kSVicC9uwDPiafpNWE3wX3J+hnGrO6kma0oQEJ2eiwlW2CyzTO/+icS3eMxUtymhnQzMZsSf5TaOLEbG8yJK5azorWC27ijqIcQmNzzT8jNCpfz16RWrv3LwrKvuk1SbR90o4YWjRPkt3sRcT3gEnKlQdkJe9HDt81ar71R/FMN3GNaZjN1n68I3OMQ3DbZ+TbwIOo/078ouB35kEdjBQDj9DHn2lfrLxG90LOjoOqvgZY9gthpWsySNNaD9Y78PuMH1GuMk/1nyaspHBmVSgekztjmbwG2qLn0Yh
 FOV9ErxR
 1xnTpFvy7KUgb2vTRJjCSBaII5YSHBW2bTnM44i0EqCUPmagFIyoapTWvH4i6uynGs/VeOeDxPdoISQ6brFbrQ1qqQ/bwWhR38GYWJCOXC+bDrZdR/amwJjBy6Tg9iSfZyhUIKXzL8d0+En97G+0JUxLYo4MC0d0nFZdU36aLkKj9K1uqXlL+SmvVOcNSGelkVQjebLoubSBfTpayXjgQzNgrK8DYZK0zoKY/p52p3bGqj1qZrmeT0rEDwE4v8MRQlDvI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The L1 D-cache of Spitfire and Cheetah is indexed with VA bit 13, but
flush_cache_vmap() and flush_cache_vunmap() are no-ops. Lines loaded
through a vmalloc address survive the unmap, and once the page is
written through the other colour, e.g. zeroed through the linear
mapping, a later mapping of the old colour reads stale data. Anonymous
user pages arrive the same way, as tlb_batch_add() does not flush them.
On UltraSPARC III this corrupts BPF programs and module data.

Flush each page on every CPU on map and unmap, or the whole D-cache in
one cross call once the range exceeds its size.

flush_cache_vmap() also runs on the vmemmap, from sparse_init() before
init_IRQ() sets up the cross-call mondo blocks. The vmemmap has no
aliases to flush, so skip addresses outside vmalloc and module space.
Now that xcall_deliver() leaves the trap block alone when there is no
target CPU, this check only saves pointless flushes. Stable kernels
lack that change and need the check, since without it
flush_dcache_all()'s cross call from sparse_init() would write starting
at physical address 0.

Link: https://github.com/sparclinux/issues/issues/29#issuecomment-5041121375
Closes: https://github.com/sparclinux/issues/issues/29
Cc: stable@vger.kernel.org # requires "sparc64: flush only the aliased page, not its whole folio"
Tested-by: Stian Halseth <stian@itx.no> # Sun Fire V240, SPARC T4-1
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
---
 arch/sparc/include/asm/cacheflush_64.h |  6 ++--
 arch/sparc/kernel/smp_64.c             | 18 +++++++++++
 arch/sparc/mm/init_64.c                | 43 ++++++++++++++++++++++++++
 arch/sparc/mm/ultra.S                  | 25 +++++++++++++++
 4 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/cacheflush_64.h b/arch/sparc/include/asm/cacheflush_64.h
index 02c969417e7b..54a2d37008e6 100644
--- a/arch/sparc/include/asm/cacheflush_64.h
+++ b/arch/sparc/include/asm/cacheflush_64.h
@@ -42,6 +42,8 @@ void smp_flush_dcache_folio_impl(struct folio *folio, int cpu);
 #define smp_flush_dcache_folio_impl(folio, cpu) flush_dcache_folio_impl(folio)
 #endif
 void flush_dcache_page_all(struct mm_struct *mm, struct page *page);
+void __flush_dcache_all(unsigned long size, unsigned long line_size);
+void flush_dcache_all(void);
 
 void __flush_dcache_range(unsigned long start, unsigned long end);
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
@@ -73,9 +75,9 @@ void flush_ptrace_access(struct vm_area_struct *, struct page *,
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
-#define flush_cache_vmap(start, end)		do { } while (0)
+void flush_cache_vmap(unsigned long start, unsigned long end);
 #define flush_cache_vmap_early(start, end)	do { } while (0)
-#define flush_cache_vunmap(start, end)		do { } while (0)
+#define flush_cache_vunmap(start, end)		flush_cache_vmap(start, end)
 
 #endif /* !__ASSEMBLER__ */
 
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 6681f5263865..ed6900b5d562 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -924,6 +924,7 @@ extern unsigned long xcall_kgdb_capture;
 
 #ifdef DCACHE_ALIASING_POSSIBLE
 extern unsigned long xcall_flush_dcache_page_cheetah;
+extern unsigned long xcall_flush_dcache_all;
 #endif
 extern unsigned long xcall_flush_dcache_page_spitfire;
 
@@ -1034,6 +1035,23 @@ void flush_dcache_page_all(struct mm_struct *mm, struct page *page)
 	preempt_enable();
 }
 
+#ifdef DCACHE_ALIASING_POSSIBLE
+void flush_dcache_all(void)
+{
+	unsigned long size, line_size;
+
+	if (tlb_type == hypervisor)
+		return;
+
+	preempt_disable();
+	size = local_cpu_data().dcache_size;
+	line_size = local_cpu_data().dcache_line_size;
+	smp_cross_call(&xcall_flush_dcache_all, 0, size, line_size);
+	__flush_dcache_all(size, line_size);
+	preempt_enable();
+}
+#endif
+
 #ifdef CONFIG_KGDB
 void kgdb_roundup_cpus(void)
 {
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 8d01aab43cc3..d1f94b8d6312 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -27,6 +27,7 @@
 #include <linux/percpu.h>
 #include <linux/mmzone.h>
 #include <linux/gfp.h>
+#include <linux/vmalloc.h>
 
 #include <asm/head.h>
 #include <asm/page.h>
@@ -234,6 +235,17 @@ void flush_dcache_page_all(struct mm_struct *mm, struct page *page)
 		__flush_icache_page(page_to_phys(page));
 #endif
 }
+
+#ifdef DCACHE_ALIASING_POSSIBLE
+void flush_dcache_all(void)
+{
+	if (tlb_type == hypervisor)
+		return;
+
+	__flush_dcache_all(local_cpu_data().dcache_size,
+			   local_cpu_data().dcache_line_size);
+}
+#endif
 #endif /* !CONFIG_SMP */
 
 #define PG_dcache_dirty		PG_arch_1
@@ -3072,6 +3084,37 @@ arch_initcall(report_memory);
 #define do_flush_tlb_kernel_range	__flush_tlb_kernel_range
 #endif
 
+/*
+ * The L1 D-cache is indexed with VA bit 13, so lines loaded through a
+ * vmalloc address outlive the mapping.  Stores through a mapping of the
+ * other colour do not update them, and a later load through their colour
+ * returns stale data.  Flush at unmap so vmalloc's lines do not follow
+ * the page back to the allocator, and at map time since anonymous user
+ * pages are freed without a flush (see tlb_batch_add()).  Past the
+ * D-cache size, one whole-cache flush is cheaper than a cross call per
+ * page.
+ */
+void flush_cache_vmap(unsigned long start, unsigned long end)
+{
+#ifdef DCACHE_ALIASING_POSSIBLE
+	/* The vmemmap has no aliases and is mapped before cross calls work. */
+	if (tlb_type == hypervisor || !is_vmalloc_or_module_addr((void *)start))
+		return;
+
+	if (end - start > cpu_data(raw_smp_processor_id()).dcache_size) {
+		flush_dcache_all();
+		return;
+	}
+
+	for (; start < end; start += PAGE_SIZE) {
+		struct page *page = vmalloc_to_page((void *)start);
+
+		if (page)
+			flush_dcache_page_all(NULL, page);
+	}
+#endif
+}
+
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
 	if (start < HI_OBP_ADDRESS && end > LOW_OBP_ADDRESS) {
diff --git a/arch/sparc/mm/ultra.S b/arch/sparc/mm/ultra.S
index 70e658d107e0..ff190670a235 100644
--- a/arch/sparc/mm/ultra.S
+++ b/arch/sparc/mm/ultra.S
@@ -242,6 +242,20 @@ __flush_dcache_page:	/* %o0=kaddr, %o1=flush_icache */
 	retl
 	 nop
 
+	/* Zeroing every D-cache tag invalidates the whole cache on
+	 * Spitfire and Cheetah alike.
+	 */
+	.align		32
+	.globl		__flush_dcache_all
+__flush_dcache_all:	/* %o0=D-cache size, %o1=D-cache line size */
+1:	subcc		%o0, %o1, %o0
+	stxa		%g0, [%o0] ASI_DCACHE_TAG
+	membar		#Sync
+	bne,pt		%icc, 1b
+	 nop
+	retl
+	 nop
+
 #endif /* DCACHE_ALIASING_POSSIBLE */
 
 	.previous
@@ -801,6 +815,17 @@ xcall_flush_dcache_page_cheetah: /* %g1 == physical page address */
 	 nop
 	retry
 	nop
+
+	.align		32
+	.globl		xcall_flush_dcache_all
+xcall_flush_dcache_all: /* %g1 == D-cache size, %g7 == D-cache line size */
+1:	subcc		%g1, %g7, %g1
+	stxa		%g0, [%g1] ASI_DCACHE_TAG
+	membar		#Sync
+	bne,pt		%icc, 1b
+	 nop
+	retry
+	nop
 #endif /* DCACHE_ALIASING_POSSIBLE */
 
 	.globl		xcall_flush_dcache_page_spitfire
-- 
2.47.3


