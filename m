Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D2311075274
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BFB16B042E; Thu, 19 Mar 2026 04:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797176B0430; Thu, 19 Mar 2026 04:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3F36B0431; Thu, 19 Mar 2026 04:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E12A6B042E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:20:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAC501A0436
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:20:31 +0000 (UTC)
X-FDA: 84562115862.23.A792DAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7EBE3A0002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:20:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ncs5z7CT;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773908430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lA6R2iFm4989CJymVljNoKm90cwa7w5F8WADAAuxE+w=;
	b=N9AUdFhI+rxagut2NVULdlScs/+VrQEi8jmHH/PDJzpjjpgpfyroKd8iyhIn0eMC/1yXv7
	LN4vbJoBCXUGLH62etlicGEPDnnWZm0TnAJuWee2eLNsGu2m7lKdUvrhxTyBv2adV3oFGf
	UGjne1ERgTaCvrNhTWdvGliQz/yjkrI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773908430; a=rsa-sha256;
	cv=none;
	b=yhHOobR8FlbtkR4mTPWeKmtY0mU7N3D1pCnhx79u/70jul/B2G9mbA0jHctZdhOkW+gGdA
	F5OKfOTpNoOn4UM85cyuPsTcucrLyzieotGIEn0ajJPNtMCgaT5fZU/AGq5pbt2pK40bYW
	nENJC5r2a8Mz4JYoJ4W+fG7sY1PaGNw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ncs5z7CT;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 62D5B60126;
	Thu, 19 Mar 2026 08:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB51CC19424;
	Thu, 19 Mar 2026 08:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773908429;
	bh=klUwCUSCdgbV1tZfxsphb/dv7F/GAnfibv0j756H5s0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ncs5z7CTqhJIhBNQChRHYmFCx/Gw02cZqph0yX7SmRTDgJm2DLn2WyIwLTWtTffwk
	 FlIgvvlw2O7wMiIl4sIdqv1PPMfQyjp+lEiO6kSyoZuT8mUfKTQ58kd1Xm4OxGQKdT
	 p9pxFkdizBdGPWKy4V3zTtFizqjONEz3nDGPvqv0/GEHaaK8ekD7oZsfIu7ePeci/k
	 AkZs2QIi6CuvEPo3LuCzwztW4AlExyadOcFwBMGWiJ1FQkRF+eqDtaMkeokzzcKOUb
	 dymhmxUCovijWR/aJHZBLNT2MH6nnIGjbCu14vm9SHNCQW3yrPxcgl7Y5pxQ2yt0YG
	 ENQ7VsLW8LzDQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 19 Mar 2026 09:19:40 +0100
Subject: [PATCH 1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260319-config_migration-v1-1-42270124966f@kernel.org>
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
In-Reply-To: <20260319-config_migration-v1-0-42270124966f@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, 
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, linux-mm@kvack.org, 
 linux-rt-devel@lists.linux.dev, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: 9iwbz617gqwupgdpdwz9mni9f5ef9chr
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EBE3A0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773908430-685771
X-HE-Meta: U2FsdGVkX1/pBtNMA+4YDQ/aFNgFFXa4rZBS/Cer4FEABpgLaPV4i2qEXxFZbcfy2LOhTbd+tGT8O6RUlT//mVNfw8rBesRYzfC9GroFsPhQSlqvt0Jg+01pkVyWH4FxUVXva2KO5bfFogo4BJSG0ygSB3gOcmoQjkQcJH+NMhPAke2NoSbrdjhh1ymNdbL2ulLkdq+ozJVEBpkJd/HjQb+bMox+QIuGrTyzcXWinhiNjPCxtXg5uk6eh/Sod/jK9M7Ykj2isHM2NTOvT7gLHvEVUITsV4yfBNNqj8WglJ3Tbq9299+8wt0JjY3tjUWuFHfplLogjdZ7VLTBgeIjL1Bu8WozUMV+/XtrxYj3/S1Sa3095++BBq5mZ/vM6FfIR+uM2xbjjF6DROkBkzF+G80u4CYiEIgPtZ+ZKiJA3hmA/EUdclw2efLlianWbT0ePqW4Sbh5YZLYHEsM+SSsOtqJbKtsSpwO6E3Z44SKcLgdc9ueLtAXtzguVr4m2t9jyG7ebJ0p6DcXgtankU8znu53Bp1u36fJfCQX/RZnCM7uX/SENafBsnSuh1bWDbhpkBUMz0aAGcLZs5uwS7K9ztcISz0onscZbEpC/jzAkJvOyD9MyTproAjKM+2XMlmq5pQGVvSjnB9TMRwApNHuuwWcP3vD7WcEJMvE3mvgQMaD7EM0zaYulZeUAasE02J+xKrBAv3rc34y4gtfNh1aDWqmGRUu/gFyIVguuNGfnQfpt/Mu13kqkTM8dHSxOniUAWASehV0ndYPNcDhxO6g2IUPBYQ+O49xpKS/AyEA1HH6OPX4qO4T4SzhneE8Xj/+UdPYV/qP4qBq5zUsGyvKzWt+DT6Z30oNArxFSoYN41HuGCNgZLtW5IB3qIhqf8tsx6wc4qPlwA6WfIQo4OlDc22r1i/jDG87u4b14l/ER61WGwxr/UF5tCYQ+sSXePEjZYkENb+xDLoomukttaw
 koexy6v6
 w/7ogIEDzLz1kz9Rmd3jY2KmypNMwTkf6vyOZFQ4//lEMaeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All architectures that select CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE also
select CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG. So we can just remove
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE.

For CONFIG_MIGRATION, make it depend on CONFIG_MEMORY_HOTREMOVE instead,
and make CONFIG_MEMORY_HOTREMOVE select CONFIG_MIGRATION (just like
CONFIG_CMA and CONFIG_COMPACTION already do).

We'll clean up CONFIG_MIGRATION next.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm64/Kconfig     | 1 -
 arch/loongarch/Kconfig | 1 -
 arch/powerpc/Kconfig   | 1 -
 arch/riscv/Kconfig     | 1 -
 arch/s390/Kconfig      | 1 -
 arch/x86/Kconfig       | 1 -
 mm/Kconfig             | 9 +++------
 7 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 38dba5f7e4d2..bcd9f5bc66e2 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -16,7 +16,6 @@ config ARM64
 	select ARCH_BINFMT_ELF_STATE
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG
-	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CACHE_LINE_SIZE
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index d211c6572b0a..dbf65ad512f1 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -12,7 +12,6 @@ config LOONGARCH
 	select ARCH_NEEDS_DEFER_KASAN
 	select ARCH_DISABLE_KASAN_INLINE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
-	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_CPU_FINALIZE_INIT
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ad7a2fe63a2a..9f3417b75b2b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -126,7 +126,6 @@ config PPC
 	select ARCH_DISABLE_KASAN_INLINE	if PPC_RADIX_MMU
 	select ARCH_DMA_DEFAULT_COHERENT	if !NOT_COHERENT_CACHE
 	select ARCH_ENABLE_MEMORY_HOTPLUG
-	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_HAS_COPY_MC			if PPC64
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 90c531e6abf5..61a9d8d3ea64 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -21,7 +21,6 @@ config RISCV
 	select ARCH_DMA_DEFAULT_COHERENT
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM_VMEMMAP
-	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_BINFMT_FLAT
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index edc927d9e85a..d01800962d84 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -85,7 +85,6 @@ config S390
 	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
-	select ARCH_ENABLE_MEMORY_HOTREMOVE
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CC_CAN_LINK
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e2df1b147184..c290fe363f27 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -69,7 +69,6 @@ config X86
 	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
-	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
 	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
diff --git a/mm/Kconfig b/mm/Kconfig
index c012944938a7..b2e21d873d3f 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -465,9 +465,6 @@ config HAVE_BOOTMEM_INFO_NODE
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	bool
 
-config ARCH_ENABLE_MEMORY_HOTREMOVE
-	bool
-
 # eventually, we can have this option just 'select SPARSEMEM'
 menuconfig MEMORY_HOTPLUG
 	bool "Memory hotplug"
@@ -540,8 +537,8 @@ endchoice
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
 	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
-	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
-	depends on MIGRATION
+	depends on MEMORY_HOTPLUG
+	select MIGRATION
 
 config MHP_MEMMAP_ON_MEMORY
 	def_bool y
@@ -636,7 +633,7 @@ config PAGE_REPORTING
 config MIGRATION
 	bool "Page migration"
 	default y
-	depends on (NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION || CMA) && MMU
+	depends on (NUMA || MEMORY_HOTREMOVE || COMPACTION || CMA) && MMU
 	help
 	  Allows the migration of the physical location of pages of processes
 	  while the virtual addresses are not changed. This is useful in

-- 
2.43.0


