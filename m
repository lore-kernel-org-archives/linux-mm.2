Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E39606A33B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bPqw6NbJ
Received: by kanga.kvack.org (Postfix)
	id 22AC76B05B6; Fri,  6 Nov 2026 11:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203366B05B7; Fri,  6 Nov 2026 11:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117EC6B05B8; Fri,  6 Nov 2026 11:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC9D26B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:52:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AD0816014C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:52:00 +0000 (UTC)
X-FDA: 85405286400.15.41998B1
Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4616140009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:51:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bPqw6NbJ;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793983919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ih+iDlrj3r7NL7Ai+FglogMaI8/aMZhKxMjTZ6H5+5U=;
	b=KWWDUFf9tS6ovIKAs4XqSwwcluwhxg/zruwsqiJH7jf4UmligSHq/Iqau/IIK68fPSOpX3
	VeJ0q5xJOrPLWj70MOFrhSk/AeUhk9insBV4i/zU7lUMj5ZAcxsJrF7pMvOuZimz16eLCn
	g2+xAxICsChkkgMWB06425cLoWcBL6o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793983919;
	b=YOiRMMywcQBDu+sapbdj24ZnPaYmAoCbTOk1sYsBUNntmkFV3uGraH3/pA1i4EFEDcIAnB
	KZVAvEGyCkoTBgmjviapy+t2KpVF6JEi9lZ0+R3PvWTqOP6rZOyOq450B5VZMg4H0pdHn6
	Bjyw1ZN1QhQMclEPOqViy3NmNe5b2nM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bPqw6NbJ;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RV6/M9ghU95I4P0I347Vc9s9wi8pglint13ZRPe8DNI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793983916; v=1; x=1794588716;
 b=bPqw6NbJ3HteiGer8MDq5/ZVAm+E4Ht5PGUjOLbQNpV9rJNWn48Uv7/2zePASEUgslkoAdnB
 qJeecuSKIwz7bmt54QcoQ3Vc0+0NebzQcpVMK52lKuG+x2YZFCjpO7M+HKqUBgP5C6sp1WpLr7c
 wRp0VQschG6Snuhs9iq0+kKA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 41e0a40f040e2912;
	Fri, 06 Nov 2026 16:51:56 +0000
X-Mizu-Trace-ID: 41e0a40f040e2912
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	jbohac@suse.cz,
	sourabhjain@linux.ibm.com,
	ruanjinjie@huawei.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	zaslonko@linux.ibm.com,
	brads@mainlining.org,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2] mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory
Date: Fri,  6 Nov 2026 08:51:42 -0800
Message-ID: <20261106165142.2847916-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ec6q6jrp8aywy4cfossn9mbz476hcssc
X-Rspamd-Queue-Id: 4616140009
X-Rspam-User: 
X-HE-Tag: 1793983918-656411
X-HE-Meta: U2FsdGVkX1+p9223wHpjmGPg4WrR5y7SGPxcvU+IH2PtzRKiIHw/Lcb1doZOIqFwviRDtHJKobTMjEN5AzCqkFmfGMCzBEXIZ8ZOWmhDPIE+i299DkHrgjEMDreXuGNBIDB6qO/RWOWyyt/Dg3qcXcvAShXcIISlcED6JtJmeioCSKWj4A+cS69hnhun/1nfk+MgJFEnqF0qjKb4gAwAbKKzdC6CDxleE9lYU7q533anE8HkHaKxmDb1EbMwxHQh5VmWhpinz3f+mcECg5qBAKrJ9Yn1qFabs40DDG5yr9pyHGtQeWYhmHPsgJAMVvHA1nRsHb5gWe+ICdTTHDvvQQ/M0wS6zqNfi/l3+uCF/8uINeBbMF12I8wmMll/yTEfSB3gliiBWRDU5aVt+poefMAuDSbysRoeh8LI5FMdW+nMBNKfKRIXn/t9VOrkR7l3vRfqAFp3RnjgPDUcEJ6K06/MpEiAU+zl89TiLnjEipjtxd4chZGkFyaJrzDCQceEGFQLVVmIflvBJut/JctNUNqDt50AL5OYOPy3JMHCzgV2O6AgjYkIkb8OkVS9zLrTMu2ird7cCqUV14+5dazSzT2TFmcjwurauLjfqGclDsDMriAtAZecCA5vt6gWfeH9BFpB9igwR2+h9mPTXfz6E92R8K+wCRoOk2ZEot8osrzJyl0uZNUZ+H7chvvennRk6lnA0QWIHPXrELsPKvbyJzc1iTVwS6vo02++08Rk08auEh0nm+mU105RMACB2g8Ez55Vbx6sSbMS8Uxt0pKAjXQeRQzFn8ByVeTisCyli+BQ6CeRbNwFDJHG1xS4E25Hv6C9V5a/XcQXub/hhu+UmcX56wjt4IZRq/Dr0fN4v+rB4m264oq9EjoMTjPmUzAasw3MPfeqmQGlBeWiiA1eD7o7IO3v7zGsxH4lWUgYn2eo5h370CD72PXqvUSg/tOURq14dLI7Kkf4eiw8DZn
 Vp0sRrCZ
 k7Ks+UH64FLEMIfx0XW5Ma/20CK+9Nb5DN1ezKYRaD8JW0OwQPGdEGzPuKlq/YWipA3m9kSbwtHxsNrmhLUfAFLBc4Bkki0DwtXWkOFJwm1lD9C8nTiQgi2b3Irr5bRdije6O243V4dQ/M7OoR0E95vCeP6P6Pxnx4gOhmQd7zXMaj02beUBnbK44bzUnb4oiYhWLivBhLC3RGuqL0C45iVgDrmY7ZttzSUYsk6hofelPjHKu9eeaXSUiUvc7RlK5v7IBUMLgMe731g9M3sXaDSZ4xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

crashkernel=size,cma reserves a separate CMA pool. On systems that
already reserve several gigabytes with hugetlb_cma= (which is common in
the Meta fleet), the crash kernel cannot use that existing memory as
part of its working set. With hugetlb_cma=6G, requesting another 2G
with crashkernel=2G,cma brings the total CMA reservation to 8G, none of
which can serve unmovable kernel allocations.

Use existing HugeTLB CMA memory first for crashkernel=size,cma and
reserve dedicated CMA areas only for the remainder. With hugetlb_cma=6G,
a 2G request reuses 2G without reserving more CMA. With hugetlb_cma=2G,
a 4G request reuses 2G and reserves another 2G.

The full HugeTLB CMA pool remains available to HugeTLB and movable
allocations during normal operation. After a crash, the capture kernel
can use the selected ranges as working memory. The conventional
reservation is still required to hold the kernel image and initrd.

The ,cma option already opts into excluding userspace memory from the
vmcore. This includes allocated HugeTLB pages in the selected ranges,
which the capture kernel can overwrite. The existing dump completeness
and pending DMA risks apply to these ranges as well.

Have architecture code record the requested CMA size and perform the
reservation in mm_core_init_early(), immediately after
hugetlb_cma_reserve(). The HugeTLB CMA areas are then available for reuse
while memblock can still reserve any remainder.

Use the existing four range slots for both reused and dedicated memory.
Limit reused memory to the page-aligned request, account for dedicated
CMA alignment, and report any shortfall. Ignore malformed optional sizes
and reject requests that would overflow page rounding.

Suggested-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
v1 -> v2:
- Use existing HugeTLB CMA memory first for crashkernel=size,cma and
  reserve dedicated CMA areas only for the remainder. (Kiryl)
---
 .../ABI/testing/sysfs-kernel-kexec-kdump      |  3 ++
 Documentation/admin-guide/kdump/kdump.rst     | 22 ++++++--
 .../admin-guide/kernel-parameters.txt         | 16 +++++-
 arch/arm64/mm/init.c                          |  2 +-
 arch/powerpc/include/asm/kexec.h              |  2 -
 arch/powerpc/kexec/core.c                     | 12 ++---
 arch/powerpc/mm/mem.c                         |  6 +--
 arch/riscv/mm/init.c                          |  2 +-
 arch/x86/kernel/setup.c                       |  2 +-
 include/linux/crash_reserve.h                 | 14 ++++-
 include/linux/hugetlb.h                       | 12 +++++
 kernel/crash_reserve.c                        | 51 ++++++++++++++-----
 mm/hugetlb_cma.c                              | 50 ++++++++++++++++++
 mm/mm_init.c                                  |  2 +
 14 files changed, 159 insertions(+), 37 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
index f59051b5d96d7..9197cbbcbe7c8 100644
--- a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
+++ b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
@@ -58,4 +58,7 @@ Description:	read only
 		the Contiguous Memory Allocator (CMA) area that are allocated
 		to the crash (kdump) kernel. It lists the start and end physical
 		addresses of CMA regions assigned for crashkernel use.
+		This includes existing HugeTLB CMA memory selected with
+		crashkernel=size,cma. These ranges remain usable
+		by the running kernel and are excluded from the vmcore.
 User:		kdump service
diff --git a/Documentation/admin-guide/kdump/kdump.rst b/Documentation/admin-guide/kdump/kdump.rst
index 7587caadbae1a..91779205d1456 100644
--- a/Documentation/admin-guide/kdump/kdump.rst
+++ b/Documentation/admin-guide/kdump/kdump.rst
@@ -313,9 +313,25 @@ crashkernel syntax
 
 4) crashkernel=size,cma
 
-	Reserve additional crash kernel memory from CMA. This reservation is
-	usable by the first system's userspace memory and kernel movable
-	allocations (memory balloon, zswap). Pages allocated from this memory
+	Reserve additional crash kernel memory from CMA. Existing HugeTLB CMA
+	memory is used first, and dedicated CMA areas are reserved for any
+	remaining amount. For example, this reuses 2G from the existing 6G pool
+	without reserving additional CMA memory::
+
+	    hugetlb_cma=6G crashkernel=256M crashkernel=2G,cma
+
+	With a smaller HugeTLB CMA pool, the remainder is reserved separately::
+
+	    hugetlb_cma=2G crashkernel=256M crashkernel=4G,cma
+
+	This reuses the existing 2G and reserves another 2G of dedicated CMA.
+	Both kinds of area use the same limit of four physical ranges. If there
+	is insufficient memory or too few range slots, the kernel reports the
+	shortfall. Normal CMA alignment applies to dedicated reservations.
+
+	The selected memory remains usable by the first system's userspace,
+	including HugeTLB allocations, and kernel movable allocations
+	(memory balloon, zswap). Pages allocated from this memory
 	range will not be included in the vmcore so this should not be used if
 	dumping of userspace memory is intended and it has to be expected that
 	some movable kernel pages may be missing from the dump.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd94..a1fb40e500097 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1100,7 +1100,21 @@ Kernel parameters
 			or memory reserved is below 4G.
 	crashkernel=size[KMG],cma
 			[KNL, X86, ARM64, RISCV, PPC] Reserve additional crash
-			kernel memory from CMA. This reservation is usable by
+			kernel memory from CMA. Existing hugetlb_cma memory is
+			used first, and dedicated CMA areas are reserved for any
+			remaining amount. For example:
+			  hugetlb_cma=6G crashkernel=256M crashkernel=2G,cma
+			reuses 2G without reserving more CMA, while:
+			  hugetlb_cma=2G crashkernel=256M crashkernel=4G,cma
+			reuses 2G and reserves another 2G of dedicated CMA.
+
+			Both kinds of area use the same limit of four physical
+			ranges. If the available memory or range slots cannot
+			cover the requested size, the kernel reports the
+			shortfall. Normal CMA alignment applies to dedicated
+			reservations.
+
+			The selected memory remains usable by
 			the first system's userspace memory and kernel movable
 			allocations (memory balloon, zswap). Pages allocated
 			from this memory range will not be included in the vmcore
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 4e7682dfe366c..a781cc60b4282 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -114,7 +114,7 @@ static void __init arch_reserve_crashkernel(void)
 		return;
 
 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
-	reserve_crashkernel_cma(cma_size);
+	crashkernel_cma_set_size(cma_size);
 }
 
 static phys_addr_t __init max_zone_phys(phys_addr_t zone_limit)
diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
index e02710d6a2e1a..d3b5028102cdd 100644
--- a/arch/powerpc/include/asm/kexec.h
+++ b/arch/powerpc/include/asm/kexec.h
@@ -117,11 +117,9 @@ int setup_new_fdt_ppc64(const struct kimage *image, void *fdt, struct crash_mem
 #ifdef CONFIG_CRASH_RESERVE
 int __init overlaps_crashkernel(unsigned long start, unsigned long size);
 extern void arch_reserve_crashkernel(void);
-extern void kdump_cma_reserve(void);
 #else
 static inline void arch_reserve_crashkernel(void) {}
 static inline int overlaps_crashkernel(unsigned long start, unsigned long size) { return 0; }
-static inline void kdump_cma_reserve(void) { }
 #endif
 
 #if defined(CONFIG_CRASH_DUMP)
diff --git a/arch/powerpc/kexec/core.c b/arch/powerpc/kexec/core.c
index dc44f11be353e..1b70eb10beac2 100644
--- a/arch/powerpc/kexec/core.c
+++ b/arch/powerpc/kexec/core.c
@@ -62,8 +62,6 @@ void machine_kexec(struct kimage *image)
 
 #ifdef CONFIG_CRASH_RESERVE
 
-static unsigned long long crashk_cma_size;
-
 static unsigned long long __init get_crash_base(unsigned long long crash_base)
 {
 
@@ -107,6 +105,7 @@ static unsigned long long __init get_crash_base(unsigned long long crash_base)
 void __init arch_reserve_crashkernel(void)
 {
 	unsigned long long crash_size, crash_base, crash_end;
+	unsigned long long cma_size = 0;
 	unsigned long long kernel_start, kernel_size;
 	unsigned long long total_mem_sz;
 	int ret;
@@ -115,7 +114,7 @@ void __init arch_reserve_crashkernel(void)
 
 	/* use common parsing */
 	ret = parse_crashkernel(boot_command_line, total_mem_sz, &crash_size,
-				&crash_base, NULL, &crashk_cma_size, NULL);
+				&crash_base, NULL, &cma_size, NULL);
 
 	if (ret)
 		return;
@@ -133,12 +132,7 @@ void __init arch_reserve_crashkernel(void)
 	}
 
 	reserve_crashkernel_generic(crash_size, crash_base, 0, false);
-}
-
-void __init kdump_cma_reserve(void)
-{
-	if (crashk_cma_size)
-		reserve_crashkernel_cma(crashk_cma_size);
+	crashkernel_cma_set_size(cma_size);
 }
 
 int __init overlaps_crashkernel(unsigned long start, unsigned long size)
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index b617b69452cd6..d6e84dc1e24c5 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -272,12 +272,10 @@ void __init arch_mm_preinit(void)
 {
 
 	/*
-	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM
-	 * and hugetlb. These must be called after pageblock_order is
-	 * initialised.
+	 * Reserve large chunks of memory for use by CMA for fadump and KVM.
+	 * These must be called after pageblock_order is initialised.
 	 */
 	fadump_cma_init();
-	kdump_cma_reserve();
 	kvm_cma_reserve();
 
 	/*
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index e822fce0af4b0..194045dc3fed6 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1357,7 +1357,7 @@ static void __init arch_reserve_crashkernel(void)
 		return;
 
 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
-	reserve_crashkernel_cma(cma_size);
+	crashkernel_cma_set_size(cma_size);
 }
 
 void __init paging_init(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 19fc8e1714e64..8848e207780b5 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -627,7 +627,7 @@ static void __init arch_reserve_crashkernel(void)
 	}
 
 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
-	reserve_crashkernel_cma(cma_size);
+	crashkernel_cma_set_size(cma_size);
 }
 
 static struct resource standard_io_resources[] = {
diff --git a/include/linux/crash_reserve.h b/include/linux/crash_reserve.h
index 30864d90d7f50..b11d7814979cc 100644
--- a/include/linux/crash_reserve.h
+++ b/include/linux/crash_reserve.h
@@ -5,6 +5,7 @@
 #include <linux/linkage.h>
 #include <linux/elfcore.h>
 #include <linux/elf.h>
+#include <linux/range.h>
 #ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 #include <asm/crash_reserve.h>
 #endif
@@ -31,7 +32,18 @@ int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *low_size, unsigned long long *cma_size,
 		bool *high);
 
-void __init reserve_crashkernel_cma(unsigned long long cma_size);
+#if defined(CONFIG_CRASH_RESERVE) && defined(CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION)
+void __init crashkernel_cma_set_size(unsigned long long size);
+void __init reserve_crashkernel_cma(void);
+#else
+static inline void __init crashkernel_cma_set_size(unsigned long long size)
+{
+}
+
+static inline void __init reserve_crashkernel_cma(void)
+{
+}
+#endif
 
 #ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 #ifndef arch_add_crash_res_to_iomem
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 58f755e70e966..69732e4cc03e2 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1349,12 +1349,24 @@ static inline spinlock_t *huge_pte_lock(struct hstate *h,
 	return ptl;
 }
 
+struct range;
+
 #if defined(CONFIG_HUGETLB_PAGE) && defined(CONFIG_CMA)
 extern void __init hugetlb_cma_reserve(void);
+unsigned long long __init
+hugetlb_cma_add_crashkernel_ranges(unsigned long long size, struct range *ranges,
+				   int *nr_ranges, int max_ranges);
 #else
 static inline __init void hugetlb_cma_reserve(void)
 {
 }
+
+static inline unsigned long long
+hugetlb_cma_add_crashkernel_ranges(unsigned long long size, struct range *ranges,
+				   int *nr_ranges, int max_ranges)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
diff --git a/kernel/crash_reserve.c b/kernel/crash_reserve.c
index eee37a11380ce..53d76ba6b3c31 100644
--- a/kernel/crash_reserve.c
+++ b/kernel/crash_reserve.c
@@ -16,6 +16,7 @@
 #include <linux/kmemleak.h>
 #include <linux/cma.h>
 #include <linux/crash_reserve.h>
+#include <linux/hugetlb.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -340,9 +341,9 @@ int __init parse_crashkernel(char *cmdline,
 	 * optional CMA reservation
 	 * cma_base is ignored
 	 */
-	if (cma_size)
-		__parse_crashkernel(cmdline, 0, cma_size,
-			&cma_base, suffix_tbl[SUFFIX_CMA]);
+	if (cma_size && __parse_crashkernel(cmdline, 0, cma_size,
+					    &cma_base, suffix_tbl[SUFFIX_CMA]))
+		*cma_size = 0;
 #endif
 	if (!*crash_size)
 		ret = -EINVAL;
@@ -470,21 +471,41 @@ void __init reserve_crashkernel_generic(unsigned long long crash_size,
 }
 
 struct range crashk_cma_ranges[CRASHKERNEL_CMA_RANGES_MAX];
+static unsigned long long crashkernel_cma_size __initdata;
+
+void __init crashkernel_cma_set_size(unsigned long long cma_size)
+{
+	crashkernel_cma_size = cma_size;
+}
+
 #ifdef CRASHKERNEL_CMA
 int crashk_cma_cnt;
-void __init reserve_crashkernel_cma(unsigned long long cma_size)
+void __init reserve_crashkernel_cma(void)
 {
-	unsigned long long request_size = roundup(cma_size, PAGE_SIZE);
-	unsigned long long reserved_size = 0;
+	unsigned long long cma_size = crashkernel_cma_size;
+	unsigned long long request_size, reserved_size, reused_size;
 
-	if (!cma_size)
+	if (!cma_size || crashk_res.start >= crashk_res.end)
 		return;
 
+	if (cma_size > ULLONG_MAX - (PAGE_SIZE - 1)) {
+		pr_warn("crashkernel CMA size is too large\n");
+		return;
+	}
+	cma_size = roundup(cma_size, PAGE_SIZE);
+	reused_size = hugetlb_cma_add_crashkernel_ranges(cma_size,
+							 crashk_cma_ranges,
+							 &crashk_cma_cnt,
+							 CRASHKERNEL_CMA_RANGES_MAX);
+	reserved_size = reused_size;
+	request_size = cma_size - reused_size;
+
 	while (cma_size > reserved_size &&
 	       crashk_cma_cnt < CRASHKERNEL_CMA_RANGES_MAX) {
 
 		struct cma *res;
 
+		request_size = min(request_size, cma_size - reserved_size);
 		if (cma_declare_contiguous(0, request_size, 0, 0, 0, false,
 				       "crashkernel", &res)) {
 			/* reservation failed, try half-sized blocks */
@@ -500,21 +521,23 @@ void __init reserve_crashkernel_cma(unsigned long long cma_size)
 			crashk_cma_ranges[crashk_cma_cnt].start +
 			cma_get_size(res) - 1;
 		++crashk_cma_cnt;
-		reserved_size += request_size;
+		reserved_size += cma_get_size(res);
 	}
 
 	if (cma_size > reserved_size)
-		pr_warn("crashkernel CMA reservation failed: %lld MB requested, %lld MB reserved in %d ranges\n",
-			cma_size >> 20, reserved_size >> 20, crashk_cma_cnt);
+		pr_warn("crashkernel CMA reservation failed: %llu MB requested, %llu MB reused, %llu MB newly reserved in %d ranges\n",
+			cma_size >> 20, reused_size >> 20,
+			(reserved_size - reused_size) >> 20, crashk_cma_cnt);
 	else
-		pr_info("crashkernel CMA reserved: %lld MB in %d ranges\n",
-			reserved_size >> 20, crashk_cma_cnt);
+		pr_info("crashkernel CMA: %llu MB reused, %llu MB newly reserved in %d ranges\n",
+			reused_size >> 20, (reserved_size - reused_size) >> 20,
+			crashk_cma_cnt);
 }
 
 #else /* CRASHKERNEL_CMA */
-void __init reserve_crashkernel_cma(unsigned long long cma_size)
+void __init reserve_crashkernel_cma(void)
 {
-	if (cma_size)
+	if (crashkernel_cma_size)
 		pr_warn("crashkernel CMA reservation not supported\n");
 }
 #endif
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index cd6a64986278a..cd6f64da31a2c 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -11,6 +11,8 @@
 #include <linux/memblock.h>
 #include <linux/math.h>
 #include <linux/math64.h>
+#include <linux/range.h>
+#include "cma.h"
 #include "internal.h"
 #include "hugetlb_cma.h"
 
@@ -387,6 +389,54 @@ void __init hugetlb_cma_reserve(void)
 		hugetlb_cma_size = 0;
 }
 
+/**
+ * hugetlb_cma_add_crashkernel_ranges - share HugeTLB CMA with the crash kernel
+ * @size: maximum number of bytes to share, aligned to PAGE_SIZE
+ * @ranges: crash kernel memory ranges
+ * @nr_ranges: number of entries already in @ranges, updated on return
+ * @max_ranges: capacity of @ranges
+ *
+ * The shared memory remains available to the HugeTLB allocator until a crash.
+ * Only physical ranges belonging to successfully reserved CMA areas are added.
+ *
+ * Return: number of bytes shared.
+ */
+unsigned long long __init
+hugetlb_cma_add_crashkernel_ranges(unsigned long long size, struct range *ranges,
+				   int *nr_ranges, int max_ranges)
+{
+	unsigned long long shared_size = 0;
+	int nid, i;
+
+	for_each_node_mask(nid, hugetlb_bootmem_nodes) {
+		struct cma *cma = hugetlb_cma[nid];
+
+		if (!cma)
+			continue;
+
+		for (i = 0; i < cma->nranges; i++) {
+			struct cma_memrange *cmr = &cma->ranges[i];
+			unsigned long long range_size;
+			struct range *range;
+
+			if (shared_size == size || *nr_ranges == max_ranges)
+				return shared_size;
+
+			range_size = min_t(unsigned long long,
+					   PFN_PHYS(cmr->count), size - shared_size);
+			range = &ranges[(*nr_ranges)++];
+			range->start = PFN_PHYS(cmr->base_pfn);
+			range->end = range->start + range_size - 1;
+			shared_size += range_size;
+
+			/* Keep shared pages reserved if CMA activation fails. */
+			cma_reserve_pages_on_error(cma);
+		}
+	}
+
+	return shared_size;
+}
+
 bool hugetlb_cma_exclusive_alloc(void)
 {
 	return hugetlb_cma_only;
diff --git a/mm/mm_init.c b/mm/mm_init.c
index a9d848c92678b..2367af05570bd 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -28,6 +28,7 @@
 #include <linux/swap.h>
 #include <linux/cma.h>
 #include <linux/crash_dump.h>
+#include <linux/crash_reserve.h>
 #include <linux/execmem.h>
 #include <linux/sizes.h>
 #include <linux/vmstat.h>
@@ -2686,6 +2687,7 @@ void __init mm_core_init_early(void)
 	free_area_init();
 
 	hugetlb_cma_reserve();
+	reserve_crashkernel_cma();
 	hugetlb_bootmem_alloc();
 
 	sparse_init();
-- 
2.53.0-Meta


