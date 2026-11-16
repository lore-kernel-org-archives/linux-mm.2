Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3BD3606A885
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=I0N9Ijti
Received: by kanga.kvack.org (Postfix)
	id CBD0B6B05B4; Mon, 16 Nov 2026 14:43:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94616B05B5; Mon, 16 Nov 2026 14:43:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83446B05B6; Mon, 16 Nov 2026 14:43:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECAB6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:43:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02D86160119
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:42:59 +0000 (UTC)
X-FDA: 85442005320.28.A256F2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5234D20006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:42:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I0N9Ijti;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794858178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=6s46FiAbZPD3iPvKsxT2Q7dzUW9EViWY//jRixbMCPM=;
	b=VMTcSxEDX3PQVvmTzy730Gue5Zes9NsDex/RnbsCqpjTdj6zpHAP8evmCLPlXWM2guiha0
	g604QeoFlo9ZxbmZ6xCNEovMjHdY5ObvqIv+FyAhRpbFEPG3F2lImJDoJcCM6GyaA6b/gb
	1GeiQccTddqDr+k7yfTG2Qw8k0KIDo4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794858178;
	b=8JpI5uUQli4lPM22uI3XS3cKr92kOSS4pY2mfg0RkAfY7sOKQEt77cBXolKnYdv1uZWfSD
	FyuW2YXsCjwFdl3I9bSjGmZda+MhS950GgCyoYzcSFzjlsw24/tE4JXaK8GnfhlcJdsYXa
	s8MgXCAEu9iRWW2hjJh7oJO/crho+54=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I0N9Ijti;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 953FB631A9;
	Mon, 16 Nov 2026 19:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3C51F000C4;
	Mon, 16 Nov 2026 19:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794858176;
	bh=6s46FiAbZPD3iPvKsxT2Q7dzUW9EViWY//jRixbMCPM=;
	h=Date:To:Cc:From:Subject;
	b=I0N9IjtikyrmJNBrkzfkt1fUHUKy4XVOsrgkLBX7R241dWKtRZMow9Q50CDxKHast
	 gfD9APc6tbsTheorwzSOBfu/IMjHHvHs2iAfiDw/5Ib3ogWiog2att/YsF0h2he8yG
	 LyFfaJwSwRW+HdOsl/NyDKqs60kwqBqkTyVgtTjY=
Date: Mon, 16 Nov 2026 11:42:55 -0800
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usama.arif@linux.dev>, Breno Leitao <leitao@debian.org>,
 Bradley Morgan <bradley.morgan@linux.dev>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, ruirui.yang@linux.dev,
 Jonathan Corbet <corbet@lwn.net>, skhan@linuxfoundation.org,
 Randy Dunlap <rdunlap@infradead.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Jiri Bohac <jbohac@suse.cz>, Sourabh Jain <sourabhjain@linux.ibm.com>,
 Jinjie Ruan <ruanjinjie@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Mikhail Zaslonko <zaslonko@linux.ibm.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <ee0918f4987c4914abea1d486043011c.1@linux-foundation.org>
Subject: [PATCH] mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory
X-Stat-Signature: 9jzfn3bdckioy49k4gk6equrmaonjaep
X-Rspam-User: 
X-Rspamd-Queue-Id: 5234D20006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794858178-488472
X-HE-Meta: U2FsdGVkX18ktJVcQuJ4qBQP+5wbbqjXwrAdKXxCUBjWkEer5biTZCj1KaXBw0zvvOl8JQb2IGJnQfSeJzmKASQwdNXyNq4gFnaQQM+ZDiYqTrBkN3w+m8wWy95wxYPyycpoG8zcFE+uTy4YImQD7GQ73GIa61fQKewqNxmIAiS/5X6SniX5TwhFb6Nt61QBLK0Wtfx01BK8hEuIAf6K4TbBH9b076gfbSOHBMLXWhqd/Sx6crY29CENum3SsFsvrDpPzvOvddybY+//x1FKdJ2hWeEUSHfrSoYazv/WSikGgnhL9YUMtgr19DmB9gkfWH5TE+1lOV6fLneOjNQ8TUAXG1TlpxEU/JPdA1LkzCk8w7LSL4VU7tk0iZNUnIs9Tusiaze5l3mVeYqkmVva5G17y5DgrV18eUVank91Ky4lIMrmDfpzmQO1Qknj+ahQJD7rtuPAN6K0kRrGS16rxmXiTbMkLWSYXBMIJMGAW0w9klJWYnt8wtR+FHjrmDiSHTYOLu3Wq2yNtzloAcuWjVF75uMDfqPREoafjYu2nlbqxbRLAt0xJpz+XnKXeXrvntLhb0U0pewtlxWA+IjEWizwmQN4wrNNuf5jLsAwtpwpnd6E2nQ0lOwEroAh4ylEAGBfP8PFJhhZ8dTo6TcmUlZY2gy8TK0QstFM6okTZyZNWmj43cncmr7ygjBXNQt4X1/Ar5wKG4lVtuQaSuY3G6CHYPXpF0GZWXdYaEPovef+Z4DI8XGLPQCPD5DPNXvAfnyHReiq1qGc7OhlMZ9Zg+n/MK51ZhHx0eNGcEeMLwU6ZWXFS8EMM18niOiJZytWRxHcM4L/fs1Kq1IribrsL48fLVdI1rLKE0CoLD7s4xYSymJyJMAs0YXNEUJMtNYQDY+V/GMMk9xZ+5FAXehL5VLUaQrRD2GRKt8r3CeS0C1ZZSr1DlLf1N9HU8DNegDcDeS5UmHk476zk48YGmV
 gaEOiMa2
 MbCRGvD57EbINtApNpt08TFNXx/nQH/6TcoGqOJAuLdvrLUWfnkQP9F2KMEH7vvv7taYY8wHEpgyc0Yn+g5Rv5uF5m580EOY/siH4PiVJ/XPXY9kRW4bfFoaQtTA8TTt9MzlpQQ4R3LdZM+riFSSZk1bFOLTU6m2enXM3yA/8b9QiKnDW+TK7bxQtavvcucOUxQhQNh/geFq7w36+HemMqrEO2+yiXf2c9AruPk8NYEnvNXOQHR8ok9/36aR/uQ217aYvMKAsMi8Z6NurrvklOYkSYq/BE2gKkuUcTMcR5rRK81sOlcXFW1obJwOsm2kHNJXAucvs21HkfdSO0sDg/vr6k8HK4oCOsm5DJEDKao2UmaKv5uHr0jnJZ44N/3KOSdA89AzNS5TaEGWV60kjL8kCQKu4y98PQPPqc7k79YQvkCKd5vkzs22F3JHTKbIT5I3bdK6/RS/gEv/kJ17R5yboX3s7njylEjgQTyaGWGlFr4nGkeGHOwH8uEunZ7VvBsIZOlXOypqg1CAvZL/87HbmWG8q1o6BVgST8m9VV9e2Y/UCd5kxZE4ko84XgBUu2+/72goNasMD2XTPgqIpR1EwvmU0IoV8yTg7kefqq9LrWIzl7z5CHYYIwcpGq9KzXl58mdJCh406zqQqeGfxioDDZKlZt4Kks/k4EGEdJRt6MUv5fjCe04N/57SbPiF7Lr0WNdVx8LAdt/w2dGVGiOTXsf5wzotqI8D/Tg/yNw0xWgHWlrBC+GXRXiJxmDBIRyo7YB0pWSpJ7rUxkQqrERUnLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Usama Arif <usama.arif@linux.dev>
Subject: mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory
Date: Fri, 06 Nov 2026 08:51:42 -0800

crashkernel=size,cma reserves a separate CMA pool.  On systems that
already reserve several gigabytes with hugetlb_cma= (which is common in
the Meta fleet), the crash kernel cannot use that existing memory as part
of its working set.  With hugetlb_cma=6G, requesting another 2G with
crashkernel=2G,cma brings the total CMA reservation to 8G, none of which
can serve unmovable kernel allocations.

Use existing HugeTLB CMA memory first for crashkernel=size,cma and reserve
dedicated CMA areas only for the remainder.  With hugetlb_cma=6G, a 2G
request reuses 2G without reserving more CMA.  With hugetlb_cma=2G, a 4G
request reuses 2G and reserves another 2G.

The full HugeTLB CMA pool remains available to HugeTLB and movable
allocations during normal operation.  After a crash, the capture kernel
can use the selected ranges as working memory.  The conventional
reservation is still required to hold the kernel image and initrd.

The ,cma option already opts into excluding userspace memory from the
vmcore.  This includes allocated HugeTLB pages in the selected ranges,
which the capture kernel can overwrite.  The existing dump completeness
and pending DMA risks apply to these ranges as well.

Have architecture code record the requested CMA size and perform the
reservation in mm_core_init_early(), immediately after
hugetlb_cma_reserve().  The HugeTLB CMA areas are then available for reuse
while memblock can still reserve any remainder.

Use the existing four range slots for both reused and dedicated memory. 
Limit reused memory to the page-aligned request, account for dedicated CMA
alignment, and report any shortfall.  Ignore malformed optional sizes and
reject requests that would overflow page rounding.

Link: https://lore.kernel.org/20261106165142.2847916-1-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: <ruirui.yang@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>

 Documentation/ABI/testing/sysfs-kernel-kexec-kdump |    3 
 Documentation/admin-guide/kdump/kdump.rst          |   22 ++++
 Documentation/admin-guide/kernel-parameters.txt    |   16 +++
 arch/arm64/mm/init.c                               |    2 
 arch/powerpc/include/asm/kexec.h                   |    2 
 arch/powerpc/kexec/core.c                          |   12 --
 arch/powerpc/mm/mem.c                              |    6 -
 arch/riscv/mm/init.c                               |    2 
 arch/x86/kernel/setup.c                            |    2 
 include/linux/crash_reserve.h                      |   14 ++-
 include/linux/hugetlb.h                            |   12 ++
 kernel/crash_reserve.c                             |   51 +++++++----
 mm/hugetlb_cma.c                                   |   50 ++++++++++
 mm/mm_init.c                                       |    2 
 14 files changed, 159 insertions(+), 37 deletions(-)

--- a/arch/arm64/mm/init.c~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/arch/arm64/mm/init.c
@@ -114,7 +114,7 @@ static void __init arch_reserve_crashker
 		return;
 
 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
-	reserve_crashkernel_cma(cma_size);
+	crashkernel_cma_set_size(cma_size);
 }
 
 static phys_addr_t __init max_zone_phys(phys_addr_t zone_limit)
--- a/arch/powerpc/include/asm/kexec.h~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/arch/powerpc/include/asm/kexec.h
@@ -117,11 +117,9 @@ int setup_new_fdt_ppc64(const struct kim
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
--- a/arch/powerpc/kexec/core.c~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/arch/powerpc/kexec/core.c
@@ -62,8 +62,6 @@ void machine_kexec(struct kimage *image)
 
 #ifdef CONFIG_CRASH_RESERVE
 
-static unsigned long long crashk_cma_size;
-
 static unsigned long long __init get_crash_base(unsigned long long crash_base)
 {
 
@@ -107,6 +105,7 @@ static unsigned long long __init get_cra
 void __init arch_reserve_crashkernel(void)
 {
 	unsigned long long crash_size, crash_base, crash_end;
+	unsigned long long cma_size = 0;
 	unsigned long long kernel_start, kernel_size;
 	unsigned long long total_mem_sz;
 	int ret;
@@ -115,7 +114,7 @@ void __init arch_reserve_crashkernel(voi
 
 	/* use common parsing */
 	ret = parse_crashkernel(boot_command_line, total_mem_sz, &crash_size,
-				&crash_base, NULL, &crashk_cma_size, NULL);
+				&crash_base, NULL, &cma_size, NULL);
 
 	if (ret)
 		return;
@@ -133,12 +132,7 @@ void __init arch_reserve_crashkernel(voi
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
--- a/arch/powerpc/mm/mem.c~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/arch/powerpc/mm/mem.c
@@ -271,12 +271,10 @@ void __init arch_mm_preinit(void)
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
--- a/arch/riscv/mm/init.c~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/arch/riscv/mm/init.c
@@ -1357,7 +1357,7 @@ static void __init arch_reserve_crashker
 		return;
 
 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
-	reserve_crashkernel_cma(cma_size);
+	crashkernel_cma_set_size(cma_size);
 }
 
 void __init paging_init(void)
--- a/arch/x86/kernel/setup.c~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/arch/x86/kernel/setup.c
@@ -627,7 +627,7 @@ static void __init arch_reserve_crashker
 	}
 
 	reserve_crashkernel_generic(crash_size, crash_base, low_size, high);
-	reserve_crashkernel_cma(cma_size);
+	crashkernel_cma_set_size(cma_size);
 }
 
 static struct resource standard_io_resources[] = {
--- a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
@@ -58,4 +58,7 @@ Description:	read only
 		the Contiguous Memory Allocator (CMA) area that are allocated
 		to the crash (kdump) kernel. It lists the start and end physical
 		addresses of CMA regions assigned for crashkernel use.
+		This includes existing HugeTLB CMA memory selected with
+		crashkernel=size,cma. These ranges remain usable
+		by the running kernel and are excluded from the vmcore.
 User:		kdump service
--- a/Documentation/admin-guide/kdump/kdump.rst~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/Documentation/admin-guide/kdump/kdump.rst
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
--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/Documentation/admin-guide/kernel-parameters.txt
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
--- a/include/linux/crash_reserve.h~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/include/linux/crash_reserve.h
@@ -5,6 +5,7 @@
 #include <linux/linkage.h>
 #include <linux/elfcore.h>
 #include <linux/elf.h>
+#include <linux/range.h>
 #ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 #include <asm/crash_reserve.h>
 #endif
@@ -31,7 +32,18 @@ int __init parse_crashkernel(char *cmdli
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
--- a/include/linux/hugetlb.h~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/include/linux/hugetlb.h
@@ -1349,12 +1349,24 @@ static inline spinlock_t *huge_pte_lock(
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
--- a/kernel/crash_reserve.c~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/kernel/crash_reserve.c
@@ -16,6 +16,7 @@
 #include <linux/kmemleak.h>
 #include <linux/cma.h>
 #include <linux/crash_reserve.h>
+#include <linux/hugetlb.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -340,9 +341,9 @@ int __init parse_crashkernel(char *cmdli
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
@@ -470,21 +471,41 @@ retry:
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
@@ -500,21 +521,23 @@ void __init reserve_crashkernel_cma(unsi
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
--- a/mm/hugetlb_cma.c~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/mm/hugetlb_cma.c
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
--- a/mm/mm_init.c~mm-hugetlb-allow-crashkernel-to-reuse-hugetlb-cma-memory
+++ a/mm/mm_init.c
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
_

