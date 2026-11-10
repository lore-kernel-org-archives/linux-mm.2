Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5FE606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xM6aEWIp
Received: by kanga.kvack.org (Postfix)
	id 6BE586B05BC; Tue, 10 Nov 2026 11:02:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699D06B05BE; Tue, 10 Nov 2026 11:02:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ADE76B05C0; Tue, 10 Nov 2026 11:02:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 361566B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:02:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C83D18096E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:17 +0000 (UTC)
X-FDA: 85419676314.12.8451676
Received: from mta1.migadu.com (out-122.mta1.migadu.com [95.215.58.122])
	by imf08.hostedemail.com (Postfix) with ESMTP id 995A6160003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xM6aEWIp;
	spf=pass (imf08.hostedemail.com: domain of bradley.morgan@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=bradley.morgan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=5PWonIeu+b4b38uYho+IErLDdgKzi1jMM953PpZK2jY=;
	b=KKGHaC1kAuuiTWcnvfHyYhYBSKNItLZwiGb4JmzeXfQVhd/MVTqd9AuzWlp1NWfcF/qH9e
	tS70QXPyRul4rNsYH4CxD6YxjbBJLwvfJom4WYdK1DxwWt1aoyIbiuOE4l3WHwpWLpNLaK
	6WzrwwTjHSARwbiXwS/N0rsNA2J8KDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326535;
	b=KPWvwn4TxAlH66wqcAXf05tOXvhEKaqPIZv76IJJxdG2nATryKLmHM6x54D5LQxWTRW3Rd
	Cw2Fs9qmNFcI/zBp4IjoH2lYusmJ+LYrm7Ec4oXsLsaUw/Og8OyKpDrxwxiQiAvICGus3w
	YaCSKIMuNUxuliIDAHOH51c1tZwKikM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xM6aEWIp;
	spf=pass (imf08.hostedemail.com: domain of bradley.morgan@linux.dev designates 95.215.58.122 as permitted sender) smtp.mailfrom=bradley.morgan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YMwSUh3ZBT7kBHW4DSB8nyNUWPJTjrrZUu9cybkznNI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794326527; v=1; x=1794931327;
 b=xM6aEWIpEN+7JMYyMOZ4j/C/7AizbX4iWBEICexFaP0/43+vNWuPQp6unJBoHSJO9c1lvg9u
 4TcAhFZXlJqZMcyF3jWyZkBF3nHBUdgskBJY2fuXpaCw48YU0bWECFruqlH7QuBV98g4r3R+DcI
 LTQnVUTB2/aH7WNS948Rw0eo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0d6b5c4890153a79;
	Tue, 10 Nov 2026 16:02:06 +0000
X-Mizu-Trace-ID: 0d6b5c4890153a79
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 16:02:02 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: usama.arif@linux.dev
CC: akpm@linux-foundation.org, baoquan.he@linux.dev, brads@mainlining.org,
 corbet@lwn.net, david@kernel.org, hannes@cmpxchg.org, jbohac@suse.cz,
 kas@kernel.org, kernel-team@meta.com, kexec@lists.infradead.org,
 leitao@debian.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 pasha.tatashin@soleen.com, pratyush@kernel.org, rdunlap@infradead.org,
 riel@surriel.com, rppt@kernel.org, ruanjinjie@huawei.com,
 ruirui.yang@linux.dev, shakeel.butt@linux.dev, skhan@linuxfoundation.org,
 sourabhjain@linux.ibm.com, zaslonko@linux.ibm.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_mm/hugetlb=3A_allow_cra?=
 =?US-ASCII?Q?shkernel_to_reuse_hugetlb_CMA_memory?=
In-Reply-To: <20261106165142.2847916-1-usama.arif@linux.dev>
Message-ID: <A2E913AE-8C81-4B17-8354-3E7F937669BE@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: k6nbugmro87qdnuknqy5pc79tko6wnuk
X-Rspamd-Queue-Id: 995A6160003
X-Rspam-User: 
X-HE-Tag: 1794326533-485420
X-HE-Meta: U2FsdGVkX18seSWgdK1/SBnhCkc+pEs2octTX8lvew9r6dZ9K1hGzA8HYcIuU8uxC+rM2T8vZfdy2PcYrpNKnQWL6k2Ou90L9s2mDXzthE6QxVgF1BMmD0taubuB+9iJA/aFXx4mT4sV+RTwN84F8jqAIO+NL4M/X5CKs4A9EKvcFQMaVMpFUGtpZ6mpXKZfNMAgmm5rvneh4WXwDKmqB65MIWjPVGGQak1lxaTAMaJlZb0+slSChlM64xR+NSuXzQ7nS/R7WtC3DG07ik1SoxF2oDBoLsPcRAtFyzOXnOQ/gtqD2VVzFr/jErZOmwswjmwyO+aBdnNa32XloDPn2Kvwr2ucmvf9JwJUq7WmuuRPCY8rBjYiPUNYdr/raoktIPrHOaZ5Gscq8ahS+Rin/TLyCHUjuZCi3FTXur2xwyksUSiwIp+FjYCiMHy/4VHlKwjVkHjnU33n/V/3kDGkw818kcwGPfHcRbuObkQzDGlEwHdHllLs8usnPP/Puh3EFpE/P0d1lUn4YZL47evMrYw6m6S8feNyktiWdD9Njz/XyBRgcDUGa4r7SVJrA164AElyXIqQrfyP1xXLCWcp4C9LXocMBWltcmVjkywjC2qW1p3ZkiJxTGLZ0h2l3d5G9xtp5t9c52n9epWbqfqSMyqvFEOSd/Z5+rdBqMdwxsFpoTLYe0cJm6FXs08ursWBZNbye8iX02gbA4vyIg6v9wxwAlFvVA2Rk7or3t/81IGHTnmlEzARUUMmlPwXYCVnPjXFYMpQjOkluN3I7+W4AVu4ZAZrzIxIPZXXQ5oRwHSKXR+Lt1UEMBxYSluuOYxk5+bnvgbuyS40KuRlTcmaRzhBfBFGfRC0JX62qet8BQTJrNhBTlB6jZPIgH9XXEu1A/6jxueNh3Usj5cEVAk/7F/tD/kNgFFW1fvjJk02p/L7sKCTl62xWuoVcmtRGsKCWOcXboUeUZ3oqlss8re
 V9StirG6
 lAZEGbvIk78QWT1HqYo90k5KtChURB/sBNrofMGKDHOa+2wjFUKAbl1WBhJyqX6ueMWRIao3uwHATRb0Kx9yj2V63/4fclQ4HVwLXx2UyDkeugeVRaerubF4Pyj57hVLk02cJuDlnKySQw7y+jDHTCNVhoCXn1437E0okj3C1O/dkHOYezy1jXNBIYpJ8xtFKB6EjHiVDX2F2QOfXUV1eZ1AajwiJtImJXjxVrEMoyNVtGzkZyY7GBXcPgGmJYvTQG4GOpz4iUZc6ZM/W7bPI881SPeyusDFc2qlYuMnhIWoUAKxmHMul5Mmf3+8UN405rWxZBHpkQ9AjgS/0be4eS3OBRfmyBWTdiCv2miJg16WM45YxS5j7Gk1NGY5eQsxSLBhv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 6 November 2026 16:51:42 GMT, Usama Arif <usama.arif@linux.dev> wrote:
>crashkernel=size,cma reserves a separate CMA pool. On systems that
>already reserve several gigabytes with hugetlb_cma= (which is common in
>the Meta fleet), the crash kernel cannot use that existing memory as
>part of its working set. With hugetlb_cma=6G, requesting another 2G
>with crashkernel=2G,cma brings the total CMA reservation to 8G, none of
>which can serve unmovable kernel allocations.
>
>Use existing HugeTLB CMA memory first for crashkernel=size,cma and
>reserve dedicated CMA areas only for the remainder. With hugetlb_cma=6G,
>a 2G request reuses 2G without reserving more CMA. With hugetlb_cma=2G,
>a 4G request reuses 2G and reserves another 2G.
>
>The full HugeTLB CMA pool remains available to HugeTLB and movable
>allocations during normal operation. After a crash, the capture kernel
>can use the selected ranges as working memory. The conventional
>reservation is still required to hold the kernel image and initrd.
>
>The ,cma option already opts into excluding userspace memory from the
>vmcore. This includes allocated HugeTLB pages in the selected ranges,
>which the capture kernel can overwrite. The existing dump completeness
>and pending DMA risks apply to these ranges as well.
>
>Have architecture code record the requested CMA size and perform the
>reservation in mm_core_init_early(), immediately after
>hugetlb_cma_reserve(). The HugeTLB CMA areas are then available for reuse
>while memblock can still reserve any remainder.
>
>Use the existing four range slots for both reused and dedicated memory.
>Limit reused memory to the page-aligned request, account for dedicated
>CMA alignment, and report any shortfall. Ignore malformed optional sizes
>and reject requests that would overflow page rounding.
>
>Suggested-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>

>Signed-off-by: Usama Arif <usama.arif@linux.dev>
>---
>v1 -> v2:
>- Use existing HugeTLB CMA memory first for crashkernel=size,cma and
>  reserve dedicated CMA areas only for the remainder. (Kiryl)
>---
> .../ABI/testing/sysfs-kernel-kexec-kdump      |  3 ++
> Documentation/admin-guide/kdump/kdump.rst     | 22 ++++++--
> .../admin-guide/kernel-parameters.txt         | 16 +++++-
> arch/arm64/mm/init.c                          |  2 +-
> arch/powerpc/include/asm/kexec.h              |  2 -
> arch/powerpc/kexec/core.c                     | 12 ++---
> arch/powerpc/mm/mem.c                         |  6 +--
> arch/riscv/mm/init.c                          |  2 +-
> arch/x86/kernel/setup.c                       |  2 +-
> include/linux/crash_reserve.h                 | 14 ++++-
> include/linux/hugetlb.h                       | 12 +++++
> kernel/crash_reserve.c                        | 51 ++++++++++++++-----
> mm/hugetlb_cma.c                              | 50 ++++++++++++++++++
> mm/mm_init.c                                  |  2 +
> 14 files changed, 159 insertions(+), 37 deletions(-)
>
>diff --git a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
>index f59051b5d96d7..9197cbbcbe7c8 100644
>--- a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
>+++ b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
>@@ -58,4 +58,7 @@ Description:	read only
> 		the Contiguous Memory Allocator (CMA) area that are allocated
> 		to the crash (kdump) kernel. It lists the start and end physical
> 		addresses of CMA regions assigned for crashkernel use.
>+		This includes existing HugeTLB CMA memory selected with
>+		crashkernel=size,cma. These ranges remain usable
>+		by the running kernel and are excluded from the vmcore.
> User:		kdump service
>diff --git a/Documentation/admin-guide/kdump/kdump.rst b/Documentation/admin-guide/kdump/kdump.rst
>index 7587caadbae1a..91779205d1456 100644
>--- a/Documentation/admin-guide/kdump/kdump.rst
>+++ b/Documentation/admin-guide/kdump/kdump.rst
>@@ -313,9 +313,25 @@ crashkernel syntax
> 
> 4) crashkernel=size,cma
> 
>-	Reserve additional crash kernel memory from CMA. This reservation is
>-	usable by the first system's userspace memory and kernel movable
>-	allocations (memory balloon, zswap). Pages allocated from this memory
>+	Reserve additional crash kernel memory from CMA. Existing HugeTLB CMA
>+	memory is used first, and dedicated CMA areas are reserved for any
>+	remaining amount. For example, this reuses 2G from the existing 6G pool
>+	without reserving additional CMA memory::
>+
>+	    hugetlb_cma=6G crashkernel=256M crashkernel=2G,cma
>+
>+	With a smaller HugeTLB CMA pool, the remainder is reserved separately::
>+
>+	    hugetlb_cma=2G crashkernel=256M crashkernel=4G,cma
>+
>+	This reuses the existing 2G and reserves another 2G of dedicated CMA.
>+	Both kinds of area use the same limit of four physical ranges. If there
>+	is insufficient memory or too few range slots, the kernel reports the
>+	shortfall. Normal CMA alignment applies to dedicated reservations.
>+
>+	The selected memory remains usable by the first system's userspace,
>+	including HugeTLB allocations, and kernel movable allocations
>+	(memory balloon, zswap). Pages allocated from this memory
> 	range will not be included in the vmcore so this should not be used if
> 	dumping of userspace memory is intended and it has to be expected that
> 	some movable kernel pages may be missing from the dump.
>diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>index 0b3c140babd94..a1fb40e500097 100644
>--- a/Documentation/admin-guide/kernel-parameters.txt
>+++ b/Documentation/admin-guide/kernel-parameters.txt
>@@ -1100,7 +1100,21 @@ Kernel parameters
> 			or memory reserved is below 4G.
> 	crashkernel=size[KMG],cma
> 			[KNL, X86, ARM64, RISCV, PPC] Reserve additional crash
>-			kernel memory from CMA. This reservation is usable by
>+			kernel memory from CMA. Existing hugetlb_cma memory is
>+			used first, and dedicated CMA areas are reserved for any
>+			remaining amount. For example:
>+			  hugetlb_cma=6G crashkernel=256M crashkernel=2G,cma
>+			reuses 2G without reserving more CMA, while:
>+			  hugetlb_cma=2G crashkernel=256M crashkernel=4G,cma
>+			reuses 2G and reserves another 2G of dedicated CMA.
>+
>+			Both kinds of area use the same limit of four physical
>+			ranges. If the available memory or range slots cannot
>+			cover the requested size, the kernel reports the
>+			shortfall. Normal CMA alignment applies to dedicated
>+			reservations.
>+
>+			The selected memory remains usable by
> 			the first system's userspace memory and kernel movable
> 			allocations (memory balloon, zswap). Pages allocated
> 			from this memory range will not be included in the vmcore
>diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>index 4e7682dfe366c..a781cc60b4282 100644
>--- a/arch/arm64/mm/init.c
>+++ b/arch/arm64/mm/init.c
>@@ -114,7 +114,7 @@ static void __init arch_reserve_crashkernel(void)
> 		return;
> 
> 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
>-	reserve_crashkernel_cma(cma_size);
>+	crashkernel_cma_set_size(cma_size);
> }
> 
> static phys_addr_t __init max_zone_phys(phys_addr_t zone_limit)
>diff --git a/arch/powerpc/include/asm/kexec.h b/arch/powerpc/include/asm/kexec.h
>index e02710d6a2e1a..d3b5028102cdd 100644
>--- a/arch/powerpc/include/asm/kexec.h
>+++ b/arch/powerpc/include/asm/kexec.h
>@@ -117,11 +117,9 @@ int setup_new_fdt_ppc64(const struct kimage *image, void *fdt, struct crash_mem
> #ifdef CONFIG_CRASH_RESERVE
> int __init overlaps_crashkernel(unsigned long start, unsigned long size);
> extern void arch_reserve_crashkernel(void);
>-extern void kdump_cma_reserve(void);
> #else
> static inline void arch_reserve_crashkernel(void) {}
> static inline int overlaps_crashkernel(unsigned long start, unsigned long
> size) { return 0; }
>-static inline void kdump_cma_reserve(void) { }
> #endif
> 
> #if defined(CONFIG_CRASH_DUMP)
>diff --git a/arch/powerpc/kexec/core.c b/arch/powerpc/kexec/core.c
>index dc44f11be353e..1b70eb10beac2 100644
>--- a/arch/powerpc/kexec/core.c
>+++ b/arch/powerpc/kexec/core.c
>@@ -62,8 +62,6 @@ void machine_kexec(struct kimage *image)
> 
> #ifdef CONFIG_CRASH_RESERVE
> 
>-static unsigned long long crashk_cma_size;
>-
> static unsigned long long __init get_crash_base(unsigned long long
> crash_base)
> {
> 
>@@ -107,6 +105,7 @@ static unsigned long long __init get_crash_base(unsigned long long crash_base)
> void __init arch_reserve_crashkernel(void)
> {
> 	unsigned long long crash_size, crash_base, crash_end;
>+	unsigned long long cma_size = 0;
> 	unsigned long long kernel_start, kernel_size;
> 	unsigned long long total_mem_sz;
> 	int ret;
>@@ -115,7 +114,7 @@ void __init arch_reserve_crashkernel(void)
> 
> 	/* use common parsing */
> 	ret = parse_crashkernel(boot_command_line, total_mem_sz, &crash_size,
>-				&crash_base, NULL, &crashk_cma_size, NULL);
>+				&crash_base, NULL, &cma_size, NULL);
> 
> 	if (ret)
> 		return;
>@@ -133,12 +132,7 @@ void __init arch_reserve_crashkernel(void)
> 	}
> 
> 	reserve_crashkernel_generic(crash_size, crash_base, 0, false);
>-}
>-
>-void __init kdump_cma_reserve(void)
>-{
>-	if (crashk_cma_size)
>-		reserve_crashkernel_cma(crashk_cma_size);
>+	crashkernel_cma_set_size(cma_size);
> }
> 
> int __init overlaps_crashkernel(unsigned long start, unsigned long size)
>diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
>index b617b69452cd6..d6e84dc1e24c5 100644
>--- a/arch/powerpc/mm/mem.c
>+++ b/arch/powerpc/mm/mem.c
>@@ -272,12 +272,10 @@ void __init arch_mm_preinit(void)
> {
> 
> 	/*
>-	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM
>-	 * and hugetlb. These must be called after pageblock_order is
>-	 * initialised.
>+	 * Reserve large chunks of memory for use by CMA for fadump and KVM.
>+	 * These must be called after pageblock_order is initialised.
> 	 */
> 	fadump_cma_init();
>-	kdump_cma_reserve();
> 	kvm_cma_reserve();
> 
> 	/*
>diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
>index e822fce0af4b0..194045dc3fed6 100644
>--- a/arch/riscv/mm/init.c
>+++ b/arch/riscv/mm/init.c
>@@ -1357,7 +1357,7 @@ static void __init arch_reserve_crashkernel(void)
> 		return;
> 
> 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
>-	reserve_crashkernel_cma(cma_size);
>+	crashkernel_cma_set_size(cma_size);
> }
> 
> void __init paging_init(void)
>diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>index 19fc8e1714e64..8848e207780b5 100644
>--- a/arch/x86/kernel/setup.c
>+++ b/arch/x86/kernel/setup.c
>@@ -627,7 +627,7 @@ static void __init arch_reserve_crashkernel(void)
> 	}
> 
> 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
>-	reserve_crashkernel_cma(cma_size);
>+	crashkernel_cma_set_size(cma_size);
> }
> 
> static struct resource standard_io_resources[] = {
>diff --git a/include/linux/crash_reserve.h b/include/linux/crash_reserve.h
>index 30864d90d7f50..b11d7814979cc 100644
>--- a/include/linux/crash_reserve.h
>+++ b/include/linux/crash_reserve.h
>@@ -5,6 +5,7 @@
> #include <linux/linkage.h>
> #include <linux/elfcore.h>
> #include <linux/elf.h>
>+#include <linux/range.h>
> #ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
> #include <asm/crash_reserve.h>
> #endif
>@@ -31,7 +32,18 @@ int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
> 		unsigned long long *low_size, unsigned long long *cma_size,
> 		bool *high);
> 
>-void __init reserve_crashkernel_cma(unsigned long long cma_size);
>+#if defined(CONFIG_CRASH_RESERVE) && defined(CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION)
>+void __init crashkernel_cma_set_size(unsigned long long size);
>+void __init reserve_crashkernel_cma(void);
>+#else
>+static inline void __init crashkernel_cma_set_size(unsigned long long size)
>+{
>+}
>+
>+static inline void __init reserve_crashkernel_cma(void)
>+{
>+}
>+#endif
> 
> #ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
> #ifndef arch_add_crash_res_to_iomem
>diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>index 58f755e70e966..69732e4cc03e2 100644
>--- a/include/linux/hugetlb.h
>+++ b/include/linux/hugetlb.h
>@@ -1349,12 +1349,24 @@ static inline spinlock_t *huge_pte_lock(struct hstate *h,
> 	return ptl;
> }
> 
>+struct range;
>+
> #if defined(CONFIG_HUGETLB_PAGE) && defined(CONFIG_CMA)
> extern void __init hugetlb_cma_reserve(void);
>+unsigned long long __init
>+hugetlb_cma_add_crashkernel_ranges(unsigned long long size, struct range *ranges,
>+				   int *nr_ranges, int max_ranges);
> #else
> static inline __init void hugetlb_cma_reserve(void)
> {
> }
>+
>+static inline unsigned long long
>+hugetlb_cma_add_crashkernel_ranges(unsigned long long size, struct range *ranges,
>+				   int *nr_ranges, int max_ranges)
>+{
>+	return 0;
>+}
> #endif
> 
> #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>diff --git a/kernel/crash_reserve.c b/kernel/crash_reserve.c
>index eee37a11380ce..53d76ba6b3c31 100644
>--- a/kernel/crash_reserve.c
>+++ b/kernel/crash_reserve.c
>@@ -16,6 +16,7 @@
> #include <linux/kmemleak.h>
> #include <linux/cma.h>
> #include <linux/crash_reserve.h>
>+#include <linux/hugetlb.h>
> 
> #include <asm/page.h>
> #include <asm/sections.h>
>@@ -340,9 +341,9 @@ int __init parse_crashkernel(char *cmdline,
> 	 * optional CMA reservation
> 	 * cma_base is ignored
> 	 */
>-	if (cma_size)
>-		__parse_crashkernel(cmdline, 0, cma_size,
>-			&cma_base, suffix_tbl[SUFFIX_CMA]);
>+	if (cma_size && __parse_crashkernel(cmdline, 0, cma_size,
>+					    &cma_base, suffix_tbl[SUFFIX_CMA]))
>+		*cma_size = 0;
> #endif
> 	if (!*crash_size)
> 		ret = -EINVAL;
>@@ -470,21 +471,41 @@ void __init reserve_crashkernel_generic(unsigned long long crash_size,
> }
> 
> struct range crashk_cma_ranges[CRASHKERNEL_CMA_RANGES_MAX];
>+static unsigned long long crashkernel_cma_size __initdata;
>+
>+void __init crashkernel_cma_set_size(unsigned long long cma_size)
>+{
>+	crashkernel_cma_size = cma_size;
>+}
>+
> #ifdef CRASHKERNEL_CMA
> int crashk_cma_cnt;
>-void __init reserve_crashkernel_cma(unsigned long long cma_size)
>+void __init reserve_crashkernel_cma(void)
> {
>-	unsigned long long request_size = roundup(cma_size, PAGE_SIZE);
>-	unsigned long long reserved_size = 0;
>+	unsigned long long cma_size = crashkernel_cma_size;
>+	unsigned long long request_size, reserved_size, reused_size;
> 
>-	if (!cma_size)
>+	if (!cma_size || crashk_res.start >= crashk_res.end)
> 		return;
> 
>+	if (cma_size > ULLONG_MAX - (PAGE_SIZE - 1)) {
>+		pr_warn("crashkernel CMA size is too large\n");
>+		return;
>+	}
>+	cma_size = roundup(cma_size, PAGE_SIZE);
>+	reused_size = hugetlb_cma_add_crashkernel_ranges(cma_size,
>+							 crashk_cma_ranges,
>+							 &crashk_cma_cnt,
>+							 CRASHKERNEL_CMA_RANGES_MAX);
>+	reserved_size = reused_size;
>+	request_size = cma_size - reused_size;
>+
> 	while (cma_size > reserved_size &&
> 	       crashk_cma_cnt < CRASHKERNEL_CMA_RANGES_MAX) {
> 
> 		struct cma *res;
> 
>+		request_size = min(request_size, cma_size - reserved_size);
> 		if (cma_declare_contiguous(0, request_size, 0, 0, 0, false,
> 				       "crashkernel", &res)) {
> 			/* reservation failed, try half-sized blocks */
>@@ -500,21 +521,23 @@ void __init reserve_crashkernel_cma(unsigned long long cma_size)
> 			crashk_cma_ranges[crashk_cma_cnt].start +
> 			cma_get_size(res) - 1;
> 		++crashk_cma_cnt;
>-		reserved_size += request_size;
>+		reserved_size += cma_get_size(res);
> 	}
> 
> 	if (cma_size > reserved_size)
>-		pr_warn("crashkernel CMA reservation failed: %lld MB requested, %lld MB reserved in %d ranges\n",
>-			cma_size >> 20, reserved_size >> 20, crashk_cma_cnt);
>+		pr_warn("crashkernel CMA reservation failed: %llu MB requested, %llu MB reused, %llu MB newly reserved in %d ranges\n",
>+			cma_size >> 20, reused_size >> 20,
>+			(reserved_size - reused_size) >> 20, crashk_cma_cnt);
> 	else
>-		pr_info("crashkernel CMA reserved: %lld MB in %d ranges\n",
>-			reserved_size >> 20, crashk_cma_cnt);
>+		pr_info("crashkernel CMA: %llu MB reused, %llu MB newly reserved in %d ranges\n",
>+			reused_size >> 20, (reserved_size - reused_size) >> 20,
>+			crashk_cma_cnt);
> }
> 
> #else /* CRASHKERNEL_CMA */
>-void __init reserve_crashkernel_cma(unsigned long long cma_size)
>+void __init reserve_crashkernel_cma(void)
> {
>-	if (cma_size)
>+	if (crashkernel_cma_size)
> 		pr_warn("crashkernel CMA reservation not supported\n");
> }
> #endif
>diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>index cd6a64986278a..cd6f64da31a2c 100644
>--- a/mm/hugetlb_cma.c
>+++ b/mm/hugetlb_cma.c
>@@ -11,6 +11,8 @@
> #include <linux/memblock.h>
> #include <linux/math.h>
> #include <linux/math64.h>
>+#include <linux/range.h>
>+#include "cma.h"
> #include "internal.h"
> #include "hugetlb_cma.h"
> 
>@@ -387,6 +389,54 @@ void __init hugetlb_cma_reserve(void)
> 		hugetlb_cma_size = 0;
> }
> 
>+/**
>+ * hugetlb_cma_add_crashkernel_ranges - share HugeTLB CMA with the crash kernel
>+ * @size: maximum number of bytes to share, aligned to PAGE_SIZE
>+ * @ranges: crash kernel memory ranges
>+ * @nr_ranges: number of entries already in @ranges, updated on return
>+ * @max_ranges: capacity of @ranges
>+ *
>+ * The shared memory remains available to the HugeTLB allocator until a crash.
>+ * Only physical ranges belonging to successfully reserved CMA areas are added.
>+ *
>+ * Return: number of bytes shared.
>+ */
>+unsigned long long __init
>+hugetlb_cma_add_crashkernel_ranges(unsigned long long size, struct range *ranges,
>+				   int *nr_ranges, int max_ranges)
>+{
>+	unsigned long long shared_size = 0;
>+	int nid, i;
>+
>+	for_each_node_mask(nid, hugetlb_bootmem_nodes) {
>+		struct cma *cma = hugetlb_cma[nid];
>+
>+		if (!cma)
>+			continue;
>+
>+		for (i = 0; i < cma->nranges; i++) {
>+			struct cma_memrange *cmr = &cma->ranges[i];
>+			unsigned long long range_size;
>+			struct range *range;
>+
>+			if (shared_size == size || *nr_ranges == max_ranges)
>+				return shared_size;
>+
>+			range_size = min_t(unsigned long long,
>+					   PFN_PHYS(cmr->count), size - shared_size);
>+			range = &ranges[(*nr_ranges)++];
>+			range->start = PFN_PHYS(cmr->base_pfn);
>+			range->end = range->start + range_size - 1;
>+			shared_size += range_size;
>+
>+			/* Keep shared pages reserved if CMA activation fails. */
>+			cma_reserve_pages_on_error(cma);
>+		}
>+	}
>+
>+	return shared_size;
>+}
>+
> bool hugetlb_cma_exclusive_alloc(void)
> {
> 	return hugetlb_cma_only;
>diff --git a/mm/mm_init.c b/mm/mm_init.c
>index a9d848c92678b..2367af05570bd 100644
>--- a/mm/mm_init.c
>+++ b/mm/mm_init.c
>@@ -28,6 +28,7 @@
> #include <linux/swap.h>
> #include <linux/cma.h>
> #include <linux/crash_dump.h>
>+#include <linux/crash_reserve.h>
> #include <linux/execmem.h>
> #include <linux/sizes.h>
> #include <linux/vmstat.h>
>@@ -2686,6 +2687,7 @@ void __init mm_core_init_early(void)
> 	free_area_init();
> 
> 	hugetlb_cma_reserve();
>+	reserve_crashkernel_cma();
> 	hugetlb_bootmem_alloc();
> 
> 	sparse_init();
>


--- Thanks!

