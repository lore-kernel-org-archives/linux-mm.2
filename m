Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFAFEC55177
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8358D6B007B; Sun,  2 Aug 2026 12:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D106B0088; Sun,  2 Aug 2026 12:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725706B008A; Sun,  2 Aug 2026 12:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 106AF6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:40:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5952E1204F3
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:40:22 +0000 (UTC)
X-FDA: 85056892284.05.5A4D070
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A087714000B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:40:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T0ocX6qU;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688820;
	b=Dtz3pB8JmGtOxgVGzfBcfW5lBg520hjde+lJn7OgpeTD+vDSu8BJGRwNDxtZOz2mer+Y2J
	UbRLV8vMFsAX9a9axJ2XXFK2Cyv0bQcti5WI1/B7uVDa8JZ6Q6ZX2+O8+1GtazMzJwRLdd
	OXjpNoulifXbaICk/I5l3boua0Q70VQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T0ocX6qU;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8b3UfdnJJEeeFGQdIgnlmfIDDUHT1YbpdVMlmUvO3A=;
	b=Ls0wlLeLWUPj13/M156Hvey12SNcQNix/lTjKI/klVrxGG/WhvY2ChMLXd+Ye0LeNskHU6
	1NP1VNfHVxGwCyPJwOpZvJo2wE384BhBXhxnymQ4D3G33P4GQe25a1Wg0SeE9sq/jQBpqM
	LBDiGjfan2/q+WTVArWI80JNdZ77vf4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA719437BC;
	Sun,  2 Aug 2026 16:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691D51F000E9;
	Sun,  2 Aug 2026 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688819;
	bh=C8b3UfdnJJEeeFGQdIgnlmfIDDUHT1YbpdVMlmUvO3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T0ocX6qUxDmZ3q/PcvLJmn6H4G/yyITe1ui7nRRQFD2s7wzuK+n0Cqnxd+Drw5gw1
	 ySisNPeGuBCjCl4ruUolcfQEhE12ct6FoF6HwKLOaXbxuN6aiKh/MSd+JyJvOUj6za
	 ogvx7UidxwB39c0qK9DPtCbBGQaTUaCdS+CYXJ56mPYLjr80tM8o5M2nmPKiP1ddOY
	 EDk/bLZSGPhld/rGrAsxQcshoSInJDfig4lMLOMtvo3bNitNZCFTz7v2ubOO4q4Onj
	 QRJgNWPCm74Go7sAXVz6EGdXbjmH+AYD9szYBOpq5dbCj2eF8iZx+bOFVvOe214yoC
	 TXMskMaRmyybQ==
Date: Sun, 2 Aug 2026 19:40:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>, rientjes@google.com,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev,
	"Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Patrick Bellasi <derkling@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 11/26] x86/mm: introduce the mermap
Message-ID: <am9y50Lc_pBf4pfw@kernel.org>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-11-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-11-6f5729aa9832@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A087714000B
X-Stat-Signature: 4uzqsn37tfs3j5jemoak8yc6gjsr7qjb
X-Rspam-User: 
X-HE-Tag: 1785688820-853187
X-HE-Meta: U2FsdGVkX18bhpGsq1EusM3GUiBREL2N0H4ZMLngDwrXGozcnek8bpGwgQA3RuMM8/fiOkKotRoYCq1fTAxpbK9NJBwBBULCp60pdn6x2uB+8dJhGTfdnKIkVgdPHwfBrvPSdNJOg63hsuT+r9am7zVdo6+nBl1flelXybvhfJZOkxdKQAo2BkNvC9LJaAwz+yG7c6zJJoN70BV2D7J5sNSy0+9iB8b9q8Aah/5r2Zv+JAMJ3DdOOoN96KtsNZkbK5RyN9+YWaT3rcJ1cQ09GOSWMAkM5/fxGwpd3XK+B83vqulTACoAjA61OLwlAXIenIVCFPLXqWss0gyPX5qTzjh9ME9QVAi+Kb+JU6EYdRNmBnDUwBK9oSBtRfnUcerQsCcUEE89sKkFNurvzzX1XZVkffOlQD4oxqeseDwV+IACiTgnQllapCFTtIK/xLr6quLYNuOJ6MnHIxRjTQ7c9/ej94Yf9sXe8DEa8VM/mUQDrCNDj3xJIfRgs83tovS/H6yNBK846fQRrxrXzmN5Nx2Fz0I+cnVWKUYBBB/EYoGLTdbxYFU0uPD1PrgP310P/qopuiFSR6hJ6jeHnYaxWkqjhPa703eWybuzz0xD6LJ0Us7xd7UEKToobhw3UdkZ1pF1W9jAgKDGPEAMGOEyKHbqVk6Yq2QTDqQ2oFuiFrUDvq1eoDvwAXs69FnaQRufe1ynbS0Jq8DgCQUqhVeOr5wnt2Bxh7gMq2Xs+f1fY9JQJwczfZI1XY6eZnX+QAhIt6jR3khK9+26dIRGhOs5twtyA5e42pQ8Mnd/DtqM9nm3HrPmppvbtYVi9MuqZLaGKgvaAXsJUC+7w12AznFZoN7k8n/Ptlr+V3NPp0tR4xdyLAy1Ic5gindU+Lxwj5zg0ec9qEH1kD0XMm5AsqOo6sv+mPssNib2NVzEPmqg++QQGu6KIKdoEAurrK6DjRitpupZlT6ScpTBVeEdgeo
 Bfd/DPpS
 8jqZ4UsJ/4b30OuYtSZH8LPpYaaueDsOZdQhHO5xpxik41uEgOalWDaTBdzXDDdNRqi/lvp8vZ2lriSzlA6hoKzEabMJDo0/3DWJmv6H3MnJImG1AmEU6tVGou/tVIMkt8xrIxAP+0kINlCf9WlvHOAW2jFetVs+It5a+sBGC75rYd3oRJBRGFbWc/drFovGpV+BNpzNCcnVIzQ05rjXDK1Z2tNMelOT+CxP1xixmpPsseqnaguYwNGgFM49rUzgh61F65pb6/bUgicMTkOXlRQtdRi0QMyd6CnYuBEUTvWoNXxkJY+kQeDNq82yqDJUsnVQjutX4RnjSi1vsu6va3cKretb3qUXMZ/LOQ281ibjiu+DoMyIj+cHBpnhUBDYtqX4N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:44PM +0000, Brendan Jackman wrote:
> The mermap provides a fast way to create ephemeral mm-local mappings of
> physical pages. The purpose of this is to access pages that have been
> removed from the direct map. Potential use cases are:
> 
> 1. For zeroing direct-map-nonpresent pages (added in a later patch).
> 
> 2. For populating guest_memfd pages that are protected by the
>    GUEST_MEMFD_NO_DIRECT_MAP feature [0].
> 
> 3. For efficient access of pages protected by Address Space Isolation
>    [1].
> 
> [0] https://lore.kernel.org/all/20250924151101.2225820-1-patrick.roy@campus.lmu.de/
> [1] https://linuxasi.dev
> 
> The details of this mechanism are described in the API comments. However
> the key idea is to use CPU-local virtual regions to avoid a need for
> synchronizing. On x86, this can also be used to prevent TLB shootdowns.
> 
> Because the virtual region is CPU-local, allocating from the mermap
> disables migration. The caller is forbidden to use the returned value
> from any other context, and migration is re-enabled when it's freed.
> 
> One might notice that mermap_get() bears a strong similarity to
> kmap_local_page(). The most important differences between mermap_get()
> and kmap_local_page() are:
> 
> 1. mermap_get() allows mapping variable sizes while kmap_local_page()
>    specifically maps a single order-0 page.
> 2. As a consequence of 1 (combined with the need for mermap_get() to be
>    an extremely simple allocator), mermap_get() should be expected to
>    fail, while kmap_local_page() is guaranteed to work up to a certain
>    degree of nesting.
> 3. While the mappings provided by kmap_local_page() are _logically_
>    local to the calling context (it's a bug for software to access them
>    from elsewhere), they are _physically_ installed into the shared
>    kernel pagetables. This means their locality doesn't provide any
>    protection from hardware attacks. In contrast, the mermap is
>    physically local to the creating mm, taking advantage of the new
>    mm-local kernel address region.
> 
> So that the mermap is available even in contexts where failure is not
> tolerable there is also a _reserved() variant, which is fixed at
> allocating a single base page. This is useful, for example, for zeroing
> unmapped pages, where handling failure would be extremely inconvenient.
> The _reserved() variant is simply implemented by leaving one base-page
> space unavailable for non-_reserved allocations, and requiring an atomic
> context.
> 
> Note for Sashiko: Yes, the data mapped by the mermap is exposed to
> Meltdown-style attacks by the current process. This is completely
> intentional. Data is only supposed to be mapped there that the current
> process is allowed to read anyway.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  arch/x86/Kconfig                        |   1 +
>  arch/x86/include/asm/mermap.h           |  23 +++
>  arch/x86/include/asm/pgtable_64_types.h |   8 +-
>  arch/x86/include/asm/pgtable_types.h    |   2 +
>  include/linux/mermap.h                  |  63 ++++++
>  include/linux/mermap_types.h            |  41 ++++
>  include/linux/mm_types.h                |   4 +
>  kernel/fork.c                           |   5 +
>  mm/Kconfig                              |   9 +
>  mm/Makefile                             |   1 +
>  mm/mermap.c                             | 338 ++++++++++++++++++++++++++++++++
>  11 files changed, 494 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 33c1282bfbf93..6b4d81a280d3b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -37,6 +37,7 @@ config X86_64
>  	select ZONE_DMA32
>  	select EXECMEM if DYNAMIC_FTRACE
>  	select ACPI_MRRM if ACPI
> +	select ARCH_SUPPORTS_MERMAP
>  
>  config FORCE_DYNAMIC_FTRACE
>  	def_bool y
> diff --git a/arch/x86/include/asm/mermap.h b/arch/x86/include/asm/mermap.h
> new file mode 100644
> index 0000000000000..9d7614716b718
> --- /dev/null
> +++ b/arch/x86/include/asm/mermap.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_MERMAP_H
> +#define _ASM_X86_MERMAP_H
> +
> +#include <asm/tlbflush.h>
> +
> +static inline void arch_mermap_flush_tlb(void)
> +{
> +	/*
> +	 * No shootdown allowed, IRQs may be off. Luckily other CPUs are not
> +	 * allowed to access our region so the stale mappings are harmless, as
> +	 * long as they still point to data belonging to this process.
> +	 */
> +	__flush_tlb_all();
> +}
> +
> +static inline bool arch_mermap_pgprot_allowed(pgprot_t prot)
> +{
> +	/* Mermap is mm-local so global mappings would be a bug. */
> +	return !(pgprot_val(prot) & _PAGE_GLOBAL);
> +}
> +
> +#endif /* _ASM_X86_MERMAP_H */
> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
> index 1181565966405..fb6c3daacfeb8 100644
> --- a/arch/x86/include/asm/pgtable_64_types.h
> +++ b/arch/x86/include/asm/pgtable_64_types.h
> @@ -105,11 +105,17 @@ extern unsigned int ptrs_per_p4d;
>  
>  #define MM_LOCAL_PGD_ENTRY	-240UL
>  #define MM_LOCAL_BASE_ADDR	(MM_LOCAL_PGD_ENTRY << PGDIR_SHIFT)
> -#define MM_LOCAL_END_ADDR	((MM_LOCAL_PGD_ENTRY + 1) << PGDIR_SHIFT)
> +#define MM_LOCAL_START_ADDR	((MM_LOCAL_PGD_ENTRY) << PGDIR_SHIFT)
> +#define MM_LOCAL_END_ADDR	(MM_LOCAL_START_ADDR + (1UL << PGDIR_SHIFT))
>  
>  #define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
>  #define LDT_END_ADDR		(LDT_BASE_ADDR + PMD_SIZE)
>  
> +#define MERMAP_BASE_ADDR	LDT_END_ADDR
> +#define MERMAP_CPU_REGION_SIZE	PMD_SIZE
> +#define MERMAP_SIZE		(MERMAP_CPU_REGION_SIZE * NR_CPUS)
> +#define MERMAP_END_ADDR		(MERMAP_BASE_ADDR + (NR_CPUS * MERMAP_CPU_REGION_SIZE))
> +
>  #define __VMALLOC_BASE_L4	0xffffc90000000000UL
>  #define __VMALLOC_BASE_L5 	0xffa0000000000000UL
>  
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index af08d98be9309..f397e4311cf66 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -223,6 +223,7 @@ enum page_cache_mode {
>  #define __PAGE_KERNEL_RO	 (__PP|   0|   0|___A|__NX|   0|   0|___G)
>  #define __PAGE_KERNEL_ROX	 (__PP|   0|   0|___A|   0|   0|   0|___G)
>  #define __PAGE_KERNEL		 (__PP|__RW|   0|___A|__NX|___D|   0|___G)
> +#define __PAGE_KERNEL_NOGLOBAL	 (__PP|__RW|   0|___A|__NX|___D|   0|   0)
>  #define __PAGE_KERNEL_EXEC	 (__PP|__RW|   0|___A|   0|___D|   0|___G)
>  #define __PAGE_KERNEL_NOCACHE	 (__PP|__RW|   0|___A|__NX|___D|   0|___G| __NC)
>  #define __PAGE_KERNEL_VVAR	 (__PP|   0|_USR|___A|__NX|   0|   0|___G)
> @@ -245,6 +246,7 @@ enum page_cache_mode {
>  #define __pgprot_mask(x)	__pgprot((x) & __default_kernel_pte_mask)
>  
>  #define PAGE_KERNEL		__pgprot_mask(__PAGE_KERNEL            | _ENC)
> +#define PAGE_KERNEL_NOGLOBAL	__pgprot_mask(__PAGE_KERNEL_NOGLOBAL   | _ENC)
>  #define PAGE_KERNEL_NOENC	__pgprot_mask(__PAGE_KERNEL            |    0)
>  #define PAGE_KERNEL_RO		__pgprot_mask(__PAGE_KERNEL_RO         | _ENC)
>  #define PAGE_KERNEL_EXEC	__pgprot_mask(__PAGE_KERNEL_EXEC       | _ENC)
> diff --git a/include/linux/mermap.h b/include/linux/mermap.h
> new file mode 100644
> index 0000000000000..5457dcb8c9789
> --- /dev/null
> +++ b/include/linux/mermap.h
> @@ -0,0 +1,63 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_MERMAP_H
> +#define _LINUX_MERMAP_H
> +
> +#include <linux/mermap_types.h>
> +#include <linux/mm.h>
> +
> +#ifdef CONFIG_MERMAP
> +
> +#include <asm/mermap.h>
> +
> +int mermap_mm_prepare(struct mm_struct *mm);
> +void mermap_mm_init(struct mm_struct *mm);
> +void mermap_mm_teardown(struct mm_struct *mm);
> +
> +/* Can the mermap be called from this context? */
> +static inline bool mermap_ready(void)
> +{
> +	return in_task() && current->mm && current->mm->mermap.cpu;
> +}
> +
> +struct mermap_alloc *mermap_get(struct page *page, unsigned long size, pgprot_t prot);
> +void *mermap_get_reserved(struct page *page, pgprot_t prot);
> +void mermap_put(struct mermap_alloc *alloc);
> +
> +static inline void *mermap_addr(struct mermap_alloc *alloc)
> +{
> +	return (void *)alloc->base;
> +}
> +
> +/*
> + * arch_mermap_flush_tlb() is called before a part of the local CPU's mermap
> + * region is remapped to a new address. No other CPU is allowed to _access_ that
> + * region, but the region was mapped there.
> + *
> + * This may be called with IRQs off.
> + *
> + * On arm64, this will need to be a broadcast TLB flush. Although the other CPUs
> + * are forbidden to access the region, they can leak the data that was mapped
> + * there via CPU exploits. Violating break-before-make would mean the data
> + * available to these CPU exploits is unpredictable.
> + */
> +extern void arch_mermap_flush_tlb(void);
> +extern bool arch_mermap_pgprot_allowed(pgprot_t prot);
> +
> +#if IS_ENABLED(CONFIG_KUNIT)
> +struct mermap_alloc *__mermap_get(struct mm_struct *mm, struct page *page,
> +			unsigned long size, pgprot_t prot, bool use_reserve);
> +void __mermap_put(struct mm_struct *mm, struct mermap_alloc *alloc);
> +unsigned long mermap_cpu_base(int cpu);
> +unsigned long mermap_cpu_end(int cpu);
> +#endif
> +
> +#else /* CONFIG_MERMAP */
> +
> +static inline int mermap_mm_prepare(struct mm_struct *mm) { return 0; }
> +static inline void mermap_mm_init(struct mm_struct *mm) { }
> +static inline void mermap_mm_teardown(struct mm_struct *mm) { }
> +static inline bool mermap_ready(void) { return false; }
> +
> +#endif /* CONFIG_MERMAP */
> +
> +#endif /* _LINUX_MERMAP_H */
> diff --git a/include/linux/mermap_types.h b/include/linux/mermap_types.h
> new file mode 100644
> index 0000000000000..c1c83b223c28d
> --- /dev/null
> +++ b/include/linux/mermap_types.h
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_MERMAP_TYPES_H
> +#define _LINUX_MERMAP_TYPES_H
> +
> +#include <linux/mutex.h>
> +#include <linux/percpu.h>
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_MERMAP
> +
> +/* Tracks an individual allocation in the mermap. */
> +struct mermap_alloc {
> +	/* Currently allocated. */
> +	bool in_use;
> +	/* Requires flush before reallocating. */
> +	bool need_flush;
> +	unsigned long base;
> +	/* Non-inclusive. */
> +	unsigned long end;
> +};
> +
> +struct mermap_cpu {
> +	/* Next address immediately available for alloc (no TLB flush needed). */
> +	unsigned long next_addr;
> +	struct mermap_alloc normal_allocs[3];
> +	struct mermap_alloc reserve_alloc;
> +};
> +
> +struct mermap {
> +	struct mutex init_lock;
> +	struct mermap_cpu __percpu *cpu;
> +};
> +
> +#else /* CONFIG_MERMAP */
> +
> +struct mermap {};
> +
> +#endif /* CONFIG_MERMAP */
> +
> +#endif /* _LINUX_MERMAP_TYPES_H */
> +
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index d39fddf57edc8..bb80d60cf3498 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -7,6 +7,7 @@
>  #include <linux/auxvec.h>
>  #include <linux/kref.h>
>  #include <linux/list.h>
> +#include <linux/mermap_types.h>
>  #include <linux/spinlock.h>
>  #include <linux/rbtree.h>
>  #include <linux/maple_tree.h>
> @@ -35,6 +36,7 @@
>  struct address_space;
>  struct futex_private_hash;
>  struct mem_cgroup;
> +struct mermap;
>  
>  typedef struct {
>  	unsigned long f;
> @@ -1211,6 +1213,8 @@ struct mm_struct {
>  		atomic_t membarrier_state;
>  #endif
>  
> +		struct mermap mermap;
> +
>  		/**
>  		 * @mm_users: The number of users including userspace.
>  		 *
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 4fb23ea33b7da..7c2050e76d1bc 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -13,6 +13,7 @@
>   */
>  
>  #include <linux/anon_inodes.h>
> +#include <linux/mermap.h>
>  #include <linux/slab.h>
>  #include <linux/sched/autogroup.h>
>  #include <linux/sched/mm.h>
> @@ -1143,6 +1144,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
>  		goto fail_pcpu;
>  
>  	lru_gen_init_mm(mm);
> +
> +	mermap_mm_init(mm);
> +
>  	return mm;
>  
>  fail_pcpu:
> @@ -1186,6 +1190,7 @@ static inline void __mmput(struct mm_struct *mm)
>  	ksm_exit(mm);
>  	khugepaged_exit(mm); /* must run before exit_mmap */
>  	exit_mmap(mm);
> +	mermap_mm_teardown(mm);
>  	mm_put_huge_zero_folio(mm);
>  	set_mm_exe_file(mm, NULL);
>  	if (!list_empty(&mm->mmlist)) {
> diff --git a/mm/Kconfig b/mm/Kconfig
> index cb531c1436f77..bf8c4c6264c73 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1507,6 +1507,15 @@ config MM_LOCAL_REGION
>  	bool
>  	depends on ARCH_SUPPORTS_MM_LOCAL_REGION
>  
> +config ARCH_SUPPORTS_MERMAP
> +	bool
> +	select ARCH_SUPPORTS_MM_LOCAL_REGION
> +
> +config MERMAP
> +	bool
> +	depends on ARCH_SUPPORTS_MERMAP
> +	select MM_LOCAL_REGION
> +
>  source "mm/damon/Kconfig"
>  
>  endmenu
> diff --git a/mm/Makefile b/mm/Makefile
> index ab37ef428d98d..9cf282c154104 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -147,3 +147,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
>  obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
>  obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
>  obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
> +obj-$(CONFIG_MERMAP) += mermap.o
> diff --git a/mm/mermap.c b/mm/mermap.c
> new file mode 100644
> index 0000000000000..2bead38eadfe8
> --- /dev/null
> +++ b/mm/mermap.c
> @@ -0,0 +1,338 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/io.h>
> +#include <linux/error-injection.h>
> +#include <linux/mermap.h>
> +#include <linux/mm.h>
> +#include <linux/mmu_context.h>
> +#include <linux/mutex.h>
> +#include <linux/pagemap.h>
> +#include <linux/pgtable.h>
> +#include <linux/sched.h>
> +
> +#include <kunit/visibility.h>
> +
> +#include "internal.h"
> +
> +static inline int set_unmapped_pte(pte_t *ptep, unsigned long addr, void *data)
> +{
> +	set_pte(ptep, __pte(0));
> +	return 0;
> +}
> +
> +VISIBLE_IF_KUNIT void __mermap_put(struct mm_struct *mm, struct mermap_alloc *alloc)
> +{
> +	unsigned long size = PAGE_ALIGN(alloc->end - alloc->base);
> +
> +	__apply_to_page_range(mm, alloc->base, size, set_unmapped_pte,
> +			      NULL, PGRANGE_CREATE | PGRANGE_NOLOCK);
> +

Sorry if I missed that in previous discussions.

__apply_to_page_range() acts only on PTE mappings, and looking forward I
presume we'd want PMD and maybe event PUD mappings in guest_memfd and
subsequently in mermap.

We anyway have a ton of page table walkers, so maybe it'll make sense to
add yet another one rather than adjust __apply_to_page_range() to the
mermap needs?

Or maybe there's a suitable walk_ API in mm/pagewalk.c?

> +	WRITE_ONCE(alloc->in_use, false);
> +}
> +EXPORT_SYMBOL_IF_KUNIT(__mermap_put);

-- 
Sincerely yours,
Mike.

