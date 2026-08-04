Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9623DC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC136B00DA; Tue,  4 Aug 2026 14:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86CBD6B00DC; Tue,  4 Aug 2026 14:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734626B00DD; Tue,  4 Aug 2026 14:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 464C26B00DA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:38:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D12071402C5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:38:14 +0000 (UTC)
X-FDA: 85064446908.16.48E991E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3DEE72000D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:38:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZTkwvkM;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785868693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8t28ipOYqVld9QVuPYSa05O/S+LvOrzn5ZMqJM5/0c=;
	b=j8r07+1l3ZHP2xqCDSTWtjBVGbaClf5Kg4Gq2nQGE+8YKaCy16o9pTqsy1inv7d/wuYAex
	dvMftgq9hH0guYaVqjrJBI+g9iHFimZWA6eV6ibnsXMsqaVyxQaJO0nQ+538H0Rfc7lyIk
	USWw4HugwcrMck8/+o+qk3a/VPA0qCA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785868693;
	b=XUWrqlV0W1BF5aulg/5NYyJvC9uxVlcX558P0o11RRIlrFOArlLfSI2pcEJpczZP/7OE5P
	8/r49lb54BBxkQOzSOrjkpt8s6dyvJkzHAr0PkE4O4l0tSDxjJqaO/JikOEKA3Xg/YcwL0
	8YeJ9LciRaroXQZN837gEnTLg47lvBU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZTkwvkM;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 932C860A78;
	Tue,  4 Aug 2026 18:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CBE1F000E9;
	Tue,  4 Aug 2026 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785868692;
	bh=v8t28ipOYqVld9QVuPYSa05O/S+LvOrzn5ZMqJM5/0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MZTkwvkMXPRBOxkolkIt5NLwvvrIkVnJ9GcqPQvTgHYT/r2kr8YXntWEj7k+dCKVb
	 9MKLfFbdNz5Rx1BHCoZ+fitpazDWTnpc3i7/s/EXYklV37hjHCIT+uUB6EPMTGZXiA
	 S4oySIFsfcwiFvTCyyRJYLmNoFPPrvEaURIGd5g2t6ivKWOJb4ZnxjSvrQ02fi7ILI
	 NlLO+BSDlhrNb0HHd/lKuh+Tqvfvf+f3kMnpltPcpDUSS5o0LxOFzKfEGzsW80/e9b
	 E/mdnaKe2HFsnhrswAgYGkVZNCEHttl5vKeX0+aQfQqF9krmEPJRE13Ut+fobMPAOd
	 XTbyu3W7WX+jg==
Date: Tue, 4 Aug 2026 18:38:09 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 11/26] x86/mm: introduce the mermap
Message-ID: <anIkIJg11jDdSUqT@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-11-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-11-6f5729aa9832@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: twbjc9cg68meh7ewxfq9cxp5f3cqq3fh
X-Rspamd-Queue-Id: 3DEE72000D
X-HE-Tag: 1785868693-995449
X-HE-Meta: U2FsdGVkX1+cXPcWhfy90T1UyGlMDhQpzoya7XNlkfgFrTczvvFYk39FdQQLti0pjY7gZuLBoBqVYjzChWq68IFG9Y3THcg1NQAT/Y38Bpo0tQ6JyGv8q0T275XKZ9Ul/kXVeVVvtuAQsjesl5Gr4xlVsBaU0AX64/Ds1Q4suotfD6CYdzoIRbuDo08ABB4gB2yHhGm4BotWwPfkliARXkPA46ZjV/d8wFyE8nNFOOpjSWDCEICmWwGjveAhKW7vC/gLmVNNP+JfRF/QuOU9T6lSq1avduc1uBtsnzaaQna6NUIE7+Fu33UBnCt1vESow4I4HOvuRlQqzNR4CkUDDLLZ/JuPONVgNtFVEKv4bBaZXq885YhMAt66odZ4vtKX/Eimup28BiCa9JIOb1wV2Tlyris7pwnNxqLhNam5QoxLRmBh71sj4GEOmHBBxPeEuw+0uYNWNj75PznXKYVvuf+DxLbVOQR2kTjywEaZkjB8LVmF36xVO14sUPZh50wHO9V5uu0XV4AplGshh/H/q5J46oNq78OXFWYtGqlhZqaQ8oWin+zZI/pdiNYaZOGTYiaV+fAq5L70jTwFRxhtsB1LSVsgdi9xI6DEEfo/jttbmoBkQB5RShM6SXlh5yF6hY0gNZ3sn2SV2HiQvZrbFNQ+nb3nMRoqt1w2EGyIFIFrOWp2Aaq4EaOeD1DESPsQqVjj7lqQ9fvp9BIH/IoIi7dByCnmnmhQBJzgR6UrNkO2se03iPLbZmoJ3oMWWsY8cnPezyLwCxxW9yH8bis6DXM5/mLOmx2kVgpwcuaTvwyznjGM2PPxLWBqwokPV34IdG3IeADDf3JEWZdc+sF6ewpdoQGw8dt5BAiHdcKC4ek4ktx0UhUxMrmAGioNkwc1s99SUUle02LAMAYPmjDmIR4oJcmkcNF9B+u6C1+Zx5P4sMMW72KPZjNVHWWfZK3NRGDGBqRfK4U+R4bk4ec
 tTvkr+rb
 Wk+a5bJKSK13ahI0xi9kHo9jnwuLEY5qd6tywjje4VO2/uaOsuH9Txm2oYGfcgmiSmKPQe2ZZjTzkDDwVOnmnQBvQUFTOCgY9G31msvi0I1+3qEojGwiHu0M9XcHgL0DyfcGNaNMepXeWjPlRD8NpmxRnd4aW5Vubopw3XMIGE8EDZUxtQ3yy+y5+vq1xZeJKzHh12/8hCvi8f5bMTe8pGMVlcZIdYEvxcipCBBX3hqJFSu2Tb1OKOwlkaKP/yLPDfI3SWeSuXMD+MI0D53H59OePgSzUjxw/X8T4dh8U8/ujSVk5Gt9Y11fh/0e44FKnEsi7N2/UKCVi8UFff3Z4Z1gFR9VrSFmXJsRQpEGBkfbUemI=
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

I guess we defer/batch/coalesce/minimize shootdowns, not completely
prevent them.

> 
> Because the virtual region is CPU-local, allocating from the mermap
> disables migration. The caller is forbidden to use the returned value
> from any other context, and migration is re-enabled when it's freed.

I think this is stale, the caller now needs to disable migration. I am
not sure why this change was made tho? Isn't it more reliable for the
API to directly disable migration?

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

The subject should probably use "mm: mermap" or something as the prefix
as this mainly an MM change not an x86 change.

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

Probably 'local' or 'cpu' somewhere in the name would make it clear this
is flushing the local mappings, not the TLB shootdown that would be
needed before a page is freed.

> +{
> +	/*
> +	 * No shootdown allowed, IRQs may be off. Luckily other CPUs are not
> +	 * allowed to access our region so the stale mappings are harmless, as
> +	 * long as they still point to data belonging to this process.
> +	 */

I think this is a bit misleading. Even if IRQs are on, I think we don't
want to do a shootdown on every unmap, so it should be clear that the
goal here is only to flush the local TLB, regardless of IRQs enablement.

Also, I think having the documentation for the arch hook in one place is
helpful (i.e. only in the header).

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

This is the same as MM_LOCAL_BASE_ADDR?

> +#define MM_LOCAL_END_ADDR	(MM_LOCAL_START_ADDR + (1UL << PGDIR_SHIFT))

Unnecessary change?

>  
>  #define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
>  #define LDT_END_ADDR		(LDT_BASE_ADDR + PMD_SIZE)
>  
> +#define MERMAP_BASE_ADDR	LDT_END_ADDR
> +#define MERMAP_CPU_REGION_SIZE	PMD_SIZE
> +#define MERMAP_SIZE		(MERMAP_CPU_REGION_SIZE * NR_CPUS)
> +#define MERMAP_END_ADDR		(MERMAP_BASE_ADDR + (NR_CPUS * MERMAP_CPU_REGION_SIZE))

				MERMAP_BASE_ADDR + MERMAP_SIZE?

> +
>  #define __VMALLOC_BASE_L4	0xffffc90000000000UL
>  #define __VMALLOC_BASE_L5 	0xffa0000000000000UL
>  
[..]
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

Is this used anywhere?

> +
> +struct mermap_alloc *mermap_get(struct page *page, unsigned long size, pgprot_t prot);
> +void *mermap_get_reserved(struct page *page, pgprot_t prot);
> +void mermap_put(struct mermap_alloc *alloc);

Why not mermap_map() and mermap_unmap()?

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

I think using "allowed" throughout the code and commit messages is a bit
misleading. It gives the impression that this is enforced (e.g. the
addressed are unmapped from other CPUs' page tables), which isn't true
AFAICT.

"Other CPUs should not.." is more accurate, but maybe more concerning to
readers. Maybe "It would be a bug for other CPUs to.." or so?

> + *
> + * This may be called with IRQs off.
> + *
> + * On arm64, this will need to be a broadcast TLB flush. Although the other CPUs
> + * are forbidden to access the region, they can leak the data that was mapped

Same comment regarding "forbidden"

> + * there via CPU exploits. Violating break-before-make would mean the data
> + * available to these CPU exploits is unpredictable.

I am also not sure I understand the problem here. IIUC, on x86 we could
end up with TLB entries for the mermap mappings on other CPUs. Even
though we disable migration while accessing the memory, other threads in
the same process could be running on other CPUs with the mappings
present and nothing prevents other CPUs from creating TLB entries. The
same could happen if the same thread later runs on another CPU but
before we actually flush the mappings.

IIUC this is fine on x86 because the TLB translations are indexed by the
PCID, so threads in other processes will not use those translations
anyway. When we do free the page, we need to actually flush the
translations to prevent the process from retaining access from a page
that now belongs to a new CPU (I don't think we're doing this correctly,
more on this later).

So how are things different for arm64? Is it just the fact that we don't
honor break-before-make and need to do a broadcast TLB flush to properly
"break" on all CPUs before we create the new mapping? Is it still a
concern if other CPUs will never architecturally use those translations?

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
[..]
> +/* Call with preemption disabled if use_reserve, else with migration disabled. */
> +static inline struct mermap_alloc *mermap_alloc(struct mm_struct *mm,
> +						unsigned long size, bool use_reserve)
> +{
> +	int cpu = raw_smp_processor_id();
> +	struct mermap_cpu *mc = this_cpu_ptr(mm->mermap.cpu);
> +	unsigned long cpu_end = mermap_cpu_end(cpu);
> +	struct mermap_alloc *alloc = NULL;
> +
> +	/*
> +	 * This is an extremely stupid allocator, there can only ever be a small
> +	 * number of allocations so everything just works on linear search.
> +	 *
> +	 * Allocations are "in order", i.e. if the whole region is free it
> +	 * allocates from the beginning. If there are any existing allocations
> +	 * it allocates from right after the last (highest address) one. Any
> +	 * free space before that goes unused.
> +	 *
> +	 * Once an allocation has been freed, the space it occupied must be flushed
> +	 * from the TLB before it can be reused.
> +	 *
> +	 * Visual example of how this is supposed to behave (A for allocated, T for
> +	 * TLB-flush-pending):
> +	 *
> +	 *  _______________ Start with everything free.
> +	 *  AaaA___________ Allocate something.
> +	 *  TttT___________ Free it. (Region needs a TLB flush now).
> +	 *  TttTAaaaaaaaA__ Allocate something else.
> +	 *  TttTAaaaaaaaAAA Allocate the remaining space.
> +	 *  TttTTtttttttTAA Free the allocation before last.
> +	 *  ^^^^^^^^^^^^^   This could all be reused now but for simplicity it
> +	 *                  isn't. Another allocation at this point will fail.
> +	 *  TttTTtttttttTTT Free the last allocation.
> +	 *  _______________ Next time we allocate, first flush the TLB.
> +	 *  AA_____________ Now we're back at the beginning.
> +	 */

I think this is actually more complicated than needed. What if we just
keep two bitmaps per-CPU, one for used slots and one for dirty slots
(need flushing)?

The per-CPU overhead is roughly the same (128 bytes vs 104 bytes on
x86_64), and we can use bitmap helpers to manage allocations better
(e.g. bitmap_allocate_region()). This would be simpler and would handle
fragmentation a bit better (we can use holes between two in use
allocations).

We also don't need to track allocations internally, we can just return
the address and the caller can pass back the address + size on unmap.

> +
> +	/* Keep one page for mermap_get_reserved(). */
> +	if (use_reserve) {
> +		if (WARN_ON_ONCE(size != PAGE_SIZE))
> +			return NULL;
> +		lockdep_assert_preemption_disabled();
> +	} else {
> +		cpu_end -= PAGE_SIZE;
> +	}
> +
> +	if (WARN_ON_ONCE(!in_task()))
> +		return NULL;
> +	guard(preempt)();
> +
> +	/* Out of already-available space? */
> +	if (mc->next_addr + size > cpu_end) {
> +		unsigned long new_next = mermap_cpu_base(cpu);
> +
> +		/* Would we have space after a TLB flush? */
> +		for (int i = 0; i < ARRAY_SIZE(mc->normal_allocs); i++) {
> +			struct mermap_alloc *alloc = &mc->normal_allocs[i];
> +
> +			/*
> +			 * The space between the uppermost allocated alloc->end
> +			 * (or the base of the CPU's region if there are no
> +			 * current allocations) and mc->next_addr has been
> +			 * unmapped in the pagetables, but not flushed from the
> +			 * TLB. Set new_next to point to the beginning of that
> +			 * space.
> +			 */
> +			if (READ_ONCE(alloc->in_use))
> +				new_next = max(new_next, alloc->end);
> +		}
> +		if (size > cpu_end - new_next)
> +			return NULL;
> +
> +		mermap_flush_tlb(cpu, mc);
> +		mc->next_addr = new_next;
> +	}
[..]
> +
> +/*
> + * Allocate a region of virtual memory, and map the page into it. This tries
> + * pretty hard to be fast but doesn't try very hard at all to actually succeed.
> + *
> + * Must be called with migration disabled, and it must stay disabled until you
> + * call mermap_put().

I think it would be better if we disable migration explicitly here.

> + *
> + * The returned region is physically local to the current mm. It is _logically_
> + * local to the current CPU but this is not enforced by hardware so it can be
> + * exploited to mitigate CPU vulns. This means the caller must not map memory
> + * here that doesn't belong to the current process. The caller must also perform
> + * a full TLB flush of the region before freeing the pages that have been mapped
> + * here.

I don't think we are doing this correctly, but I will comment on the
relevant patch. I think we should provide an API to do the mermap
flushes here though, instead of relying on the callers to do a full
flush. It allows for adding optimizations later and it's easier to track
the code to see mermap-specific flushes.

> + *
> + * This may only be called from process context, and the caller must arrange to
> + * first call mermap_mm_prepare(). (It would be possible to support this in IRQ,
> + * but it seems unlikely there's a valid usecase given the TLB flushing
> + * requirements).

Why do we require mermap_mm_prepare() to be called separately? Why not
call it here? IIUC this is to support calling mermap_mm_prepare() in
contexts where we can allocate, and then calling mermap_get() in
contexts where we cannot, but do any of the users currently require
this?

> + *
> + * This is guaranteed not to allocate.
> + *
> + * Use mermap_addr() to get the actual address of the mapped region.
> + */
> +struct mermap_alloc *mermap_get(struct page *page, unsigned long size, pgprot_t prot)
> +{
> +	struct mermap_alloc *alloc;
> +
> +	cant_migrate();
> +	alloc = __mermap_get(current->mm, page, size, prot, false);
> +	if (alloc) {
> +		/* Leaving migration disabled is intentional. */
> +		return alloc;
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL(mermap_get);
> +ALLOW_ERROR_INJECTION(mermap_get, NULL);
> +
> +/*
> + * Allocate a single PAGE_SIZE page via mermap_get(), requiring preemption to be
> + * off until it is freed. This always succeeds.
> + */
> +void *mermap_get_reserved(struct page *page, pgprot_t prot)
> +{
> +	lockdep_assert_preemption_disabled();
> +	return __mermap_get(current->mm, page, PAGE_SIZE, prot, true);
> +}
> +EXPORT_SYMBOL(mermap_get_reserved);

Perhaps a bit radical, but what if we start off by disabling preemption
while a mermap mapping is active instead of just migration? IIUC, this
would remove the need for reserved mappings as we are always guaranteed
to be able to map folios (up to PMD-size) by doing a local TLB flush.

The only use case for now is zeroing, and I think we can do that with
preemption disabled. As more use cases arise we can judge if we should
relax the constraint to only disabling migration.

WDYT?

