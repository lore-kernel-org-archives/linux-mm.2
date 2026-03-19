Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB57F109022E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33BD26B04CC; Thu, 19 Mar 2026 10:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC936B04CE; Thu, 19 Mar 2026 10:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202D26B04CF; Thu, 19 Mar 2026 10:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11F446B04CC
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:11:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B19CC1FF1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:11:50 +0000 (UTC)
X-FDA: 84563001180.05.4402500
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5EB7C0006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:11:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UerHPcIh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773929508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62uEef/BkeK/5loUdRkhgtOa4Jww3WVIsDAkK87TFQ4=;
	b=S+AAJvlDB8tcjKS7GPNL/XOvu6/5nljqiL4t5fT/w1xy7p5JYV6LkjbbhtP9jWEG9OKQoE
	cdm0BaaiT4XGPqDdpLfhWQMIR13L5IUoMAhqE/mrd25xgSj8LpCKhtW793awkr3du/unbU
	Q5WkuzCK9Wm+q7wrqxVtmatzDOOMmAU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UerHPcIh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773929509; a=rsa-sha256;
	cv=none;
	b=KMaCzY8dQCBcTHk1QXiBf7jkgJnLCbLnZyAeRBR5mXeynfVuWm1wh9j0XaTAcPwr52U5t1
	tx45fXLklY/sc+epi39HDPA1Ue9Kqk9NExOgnJXf/WYyr0n/R5hdtULpF/a2cB0oNO2VUB
	bNHjPxoqnbIdJfzfbTcF81pvC3B2fQg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B92D440BCE;
	Thu, 19 Mar 2026 14:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664A8C19424;
	Thu, 19 Mar 2026 14:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773929507;
	bh=MivZjiW5NvagivYMYH70K18NXOP+4XjdCcrtxZRKzWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UerHPcIhZf5iw1L4uJ064Sm5pT3BEiIczGzptBjlWHw2pf3d+tNXIabR0FlPqyIRk
	 i5A/s8jANJQ+6DUKj9E72Pk/lWL3jerwH8bHCa5SFCaU4jhsmeb+7/x+Ua9i0WELOr
	 Ul+vuoba3lTnp86TRF2Gqt6t+s9MBbPodYgntONPFxSLb6c4CzdLpTzVBK9FDDgtpb
	 GtbHzfXlvHPbrSvV7xXFxD3nRPfQ6pzF6z2CrsaJL1o1mZx8i0TVCMMHxmzlmccQr2
	 TxqxhEmmNyEKoFOHBIAHTBuL5gqIQSxljyLvzzcUAdFWSowUlBD6xMHugYmz7rRveT
	 VQko93pO+Dwtw==
Date: Thu, 19 Mar 2026 14:11:34 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
Message-ID: <2b23080c-0af9-4269-958b-957e7c093258@lucifer.local>
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
 <20260319-config_migration-v1-1-42270124966f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319-config_migration-v1-1-42270124966f@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C5EB7C0006
X-Stat-Signature: knhie4oqsbtsxmonhe4cw44d8d1w7d5z
X-Rspam-User: 
X-HE-Tag: 1773929508-335156
X-HE-Meta: U2FsdGVkX19rKBlOMUF0mpIvMYmjIpFwyXTWFFOMZULXfNdsH+f/Q94nTfkIWl8HlNlLtYU1SZ99g3ubTH2p3Vo5a4lMUNRSCCPEk33/Z4EpuijMjXeMmNQMJS4FQNFlxljGitgVoo+pGNWehata8Lu72w6bvCITiCQzhdw1ZOENICjvJBONdRSOIC/Ho7Cv9TBufoqLt5R4b7YnffDooL4aQlVP0YiBOx5vMtCFqfQ35TV78jFNL1MsWhA6s21UMuHhq3FC0oY0JTvL4JqQ333ShEsweyzrmVqTy5iNmMNd+3nYHMUWrWgZnMI6UyXR7beORWCKeSW0k36wkomTxYO1DNCfoSAB4j7D4mkBFDif4HUxWzyO1GaGleAHs8DqNzn8KvYoJD3inxQI0Wq3+QJqBwRJtsLdB5oilHitFW6feAAn4Zv5EAPMvdSMgaYnT1DW6KAXWMLJCLUf0pEcjNfu15qU7hntgaG6Mcsp4sBEH+F228w8Y3eieG7dSE0perc0pxppY1R9QZJtkxc+atgAT99+CnXJjYgSBn7sGGUyokVslVlInOlQSe3JdJoAV682tgESMXjFeQlWiT55LK2eYGVgVptzs0KS0GD6J+Xz9QAmFgbcAQuGIlZpScYXU5jcHu9IkuHIZMELzHiKivygYm1TkP6fPyJBfYaIAchK7rA3zroxhU3oB/BaDDBJNSHrRE+GWKbHSn2/nzG2BKdjna43Bf1XSU2l52Ob5xr4yGCWUIbY5aORT/aiFhpIPRyL8UClgRbvoZVP0Q0U4MY+nGgBEqbV9jCn3ePDoCGUANhxXyUI/P7aZZCU/IyFjJ0XLnnloVs2R3ClZUwipoGxwS0roA5PrZa2sKgMsnZBGDPLAi2U8K8iq0bUAayFzdAmclPMqzJzAb2X6VDTeWwe14dVeBoAng7oN8si250G73DPphRCtQ3V2WKjEVtgAmxWvOE50KNOEGK3QgB
 krsCvped
 iXKJ3xfEguv0e1WQXNCRIPHtXIdqcpfzFQ97K1yn2L7B+9R8MjJ+TWpzrSvnIl47xpLWuJy7pE7qjcjjPJdH3CJtAHQLRLVSaSBLV4nivLGpBR5a5Qkxr+JcKZntoE6I8FkqR33Gx5QQBY2O5gES8FiDfUefpZfb+jS5r7gqs7XPNtdStW+BtHjvSv2S8muSrRNXUVFXkiiPVvTxIrEGTZeFFl3Be451+eHG3La8G+htv85XUb0eCh6qKGk9TKJQ2qAzru+116xvlZ/FJ5CS4RjKu+AwIjC2v2ayo9Hy4Q3f60a5NU3oexoJJS+H14RZ2U/SFiSzcjqe7SIwbzqiSLPjtine5BVrnZP3o7UQseMkEMsiYFqnRgtWuHfxVcdzIPTC5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 09:19:40AM +0100, David Hildenbrand (Arm) wrote:
> All architectures that select CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE also
> select CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG. So we can just remove
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE.
>
> For CONFIG_MIGRATION, make it depend on CONFIG_MEMORY_HOTREMOVE instead,
> and make CONFIG_MEMORY_HOTREMOVE select CONFIG_MIGRATION (just like
> CONFIG_CMA and CONFIG_COMPACTION already do).

Makes sense!

>
> We'll clean up CONFIG_MIGRATION next.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  arch/arm64/Kconfig     | 1 -
>  arch/loongarch/Kconfig | 1 -
>  arch/powerpc/Kconfig   | 1 -
>  arch/riscv/Kconfig     | 1 -
>  arch/s390/Kconfig      | 1 -
>  arch/x86/Kconfig       | 1 -
>  mm/Kconfig             | 9 +++------
>  7 files changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 38dba5f7e4d2..bcd9f5bc66e2 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -16,7 +16,6 @@ config ARM64
>  	select ARCH_BINFMT_ELF_STATE
>  	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
>  	select ARCH_ENABLE_MEMORY_HOTPLUG
> -	select ARCH_ENABLE_MEMORY_HOTREMOVE
>  	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
>  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
>  	select ARCH_HAS_CACHE_LINE_SIZE
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index d211c6572b0a..dbf65ad512f1 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -12,7 +12,6 @@ config LOONGARCH
>  	select ARCH_NEEDS_DEFER_KASAN
>  	select ARCH_DISABLE_KASAN_INLINE
>  	select ARCH_ENABLE_MEMORY_HOTPLUG
> -	select ARCH_ENABLE_MEMORY_HOTREMOVE
>  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
>  	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
>  	select ARCH_HAS_CPU_FINALIZE_INIT
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index ad7a2fe63a2a..9f3417b75b2b 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -126,7 +126,6 @@ config PPC
>  	select ARCH_DISABLE_KASAN_INLINE	if PPC_RADIX_MMU
>  	select ARCH_DMA_DEFAULT_COHERENT	if !NOT_COHERENT_CACHE
>  	select ARCH_ENABLE_MEMORY_HOTPLUG
> -	select ARCH_ENABLE_MEMORY_HOTREMOVE
>  	select ARCH_HAS_COPY_MC			if PPC64
>  	select ARCH_HAS_CURRENT_STACK_POINTER
>  	select ARCH_HAS_DEBUG_VIRTUAL
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 90c531e6abf5..61a9d8d3ea64 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -21,7 +21,6 @@ config RISCV
>  	select ARCH_DMA_DEFAULT_COHERENT
>  	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
>  	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM_VMEMMAP
> -	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
>  	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
>  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
>  	select ARCH_HAS_BINFMT_FLAT
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index edc927d9e85a..d01800962d84 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -85,7 +85,6 @@ config S390
>  	select ARCH_32BIT_USTAT_F_TINODE
>  	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
>  	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
> -	select ARCH_ENABLE_MEMORY_HOTREMOVE
>  	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
>  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
>  	select ARCH_HAS_CC_CAN_LINK
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e2df1b147184..c290fe363f27 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -69,7 +69,6 @@ config X86
>  	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
>  	select ARCH_ENABLE_HUGEPAGE_MIGRATION if X86_64 && HUGETLB_PAGE && MIGRATION
>  	select ARCH_ENABLE_MEMORY_HOTPLUG if X86_64
> -	select ARCH_ENABLE_MEMORY_HOTREMOVE if MEMORY_HOTPLUG
>  	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if (PGTABLE_LEVELS > 2) && (X86_64 || X86_PAE)
>  	select ARCH_ENABLE_THP_MIGRATION if X86_64 && TRANSPARENT_HUGEPAGE
>  	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
> diff --git a/mm/Kconfig b/mm/Kconfig
> index c012944938a7..b2e21d873d3f 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -465,9 +465,6 @@ config HAVE_BOOTMEM_INFO_NODE
>  config ARCH_ENABLE_MEMORY_HOTPLUG
>  	bool
>
> -config ARCH_ENABLE_MEMORY_HOTREMOVE
> -	bool
> -
>  # eventually, we can have this option just 'select SPARSEMEM'
>  menuconfig MEMORY_HOTPLUG
>  	bool "Memory hotplug"
> @@ -540,8 +537,8 @@ endchoice
>  config MEMORY_HOTREMOVE
>  	bool "Allow for memory hot remove"
>  	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
> -	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
> -	depends on MIGRATION
> +	depends on MEMORY_HOTPLUG
> +	select MIGRATION
>
>  config MHP_MEMMAP_ON_MEMORY
>  	def_bool y
> @@ -636,7 +633,7 @@ config PAGE_REPORTING
>  config MIGRATION
>  	bool "Page migration"
>  	default y
> -	depends on (NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE || COMPACTION || CMA) && MMU
> +	depends on (NUMA || MEMORY_HOTREMOVE || COMPACTION || CMA) && MMU
>  	help
>  	  Allows the migration of the physical location of pages of processes
>  	  while the virtual addresses are not changed. This is useful in
>
> --
> 2.43.0
>

