Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFE2C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 22:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86BEC6B007B; Mon,  3 Aug 2026 18:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81D6B6B0088; Mon,  3 Aug 2026 18:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70BDD6B0092; Mon,  3 Aug 2026 18:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 330176B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:29:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A22D61A0859
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:29:57 +0000 (UTC)
X-FDA: 85061402034.04.715F040
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 105BA10000D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:29:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7OOZ0Kh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785796196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D33URDR7Up2gYdJAYzC9FmjKy9QME9VyblsVQUlA6N8=;
	b=eXPMROAEqSvs0Q+CTQxCpX6wS96KTn3t/VTSCf+ZS/WsfSA0A4DOt3Z/YQ/Ao4x3XJN+GA
	FMwLf5visHkVV+1ib80sLuRF9jnNhD9x9Bdsc82U1KrYLAb90fyWw9L9er6dMYUQe6ZyJs
	EbWUh9mfA+Hoh82X8pQ9K60w7bxwSjs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7OOZ0Kh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785796196;
	b=7Uvr+gHRxzwDxYiL8v4yz2a515h373iT0RBW3PlnfxRc1I8uvRgLQm9ZFheKwSBkaLnhtk
	+1Ab6LnXW7rJsPnO96ijJZBb4lQm+wJKUiIHdqyT7SIfJqkmgeRm2g+mUm9GQLWokNejXR
	zcsQDFlmH2XizvsnBaA2NMtlUH07nPY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4233560A59;
	Mon,  3 Aug 2026 22:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041A81F000E9;
	Mon,  3 Aug 2026 22:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785796195;
	bh=D33URDR7Up2gYdJAYzC9FmjKy9QME9VyblsVQUlA6N8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U7OOZ0KhW3B1w3vFNRTeLAS68PmHxiZEJ/yC14LJ6XgPOxSWh+1i4au0ZEBrBorJH
	 iQvPfKqtM/T8qSr14U3X5ad0qbbVO6rmNsiTITPTL0FGtNeSKB6KMbNkanDsVLRCI2
	 WlYWORe5domL50oGACXU6F3jSPqdwJ0k9EwlwBlYlIc6S1NoYYeD3OUQNvNZpZQVXa
	 8J842so7EDDWe4opMyvPiNx9vUEyfEzLdBeEH41qvAqay0/UluYI6X39M3yIvJzhQT
	 DEEE6qqKyedkSTBi/MODCqwQP9bVWa+gfD5J0GFHBFSGMUVIZm/5qfJybz9Df55zi6
	 MJMSDK9h81e0w==
Date: Mon, 3 Aug 2026 22:29:52 +0000
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
Subject: Re: [PATCH v3 07/26] x86/mm: introduce mm-local region
Message-ID: <anES7O7T_PN2bV0v@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-7-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-7-6f5729aa9832@google.com>
X-Stat-Signature: r9n81k1mutqg1xw95thteaf95941uz4y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 105BA10000D
X-HE-Tag: 1785796195-970803
X-HE-Meta: U2FsdGVkX18+Hd0lbEgEDHbjySaYD52IRHvVmjmJN+7CzPiNi/8bXCCoVH7I6H7xkE6S/Unpo43gX8HCrSO2iKD3mrhMeX0d6rHD79uzQOGLVw9IgO2HRhExXIVH9zSzFNxm429DZKzGP3GyF6iuGroaU4zAbq4XJnBrFWN7fQMl2QEpOLFOOrKCQ7FbgruhUFW7JvYFD43b+yViIPUg7eM8Ab7FlrVu8WnQQYhk5IEiO2geqWAkxCzTon0SNXjCdd2HtVUXNlX0jufr92GCN+xnLe6Mo/a/ZELA+WHhhQaqLP3a94dvBU923wPQLhnoc/4rTbDry48mpWPQGXySBC/7YAJSxRrKQFk9xrnQxBP+eCL11tiJ88M/TgkdFGSACW9wjoUKOMMbSRi0cbRRRxc3VrL1uD3tbMNV7NhDs9rVwJ6uI3kZz54I/ZWd/ICp9fek5/y4+RK++4MjmOFlFNmNQm9A/MQA1Ndh7+UM2adnEwvlL3jMjytz3FcHCcMgJUWQbc++ickSfWk+ExoFeIVFAVpWfP1ynZB1FALA6hCTF7Pv+gOV4jwY5N0bD8+iuQ7oz89hXtgh/PyJJs+Rh5jnKy8WmUQX2RvN8UDRXaAcmDgdZSiL3tUfleOs7YYX7hWFZLvGxGIrsflNsaj6Hd5d+cLvL+3pwUr+qm2/zubdb9yTKOrr5/Sr24ChHqVLNn5MV3Bz+d7yBDhJuJqnF1SKjaehtztt7dF62p10ZoRIBAyQUbsx7TcJPXx4x6d06R18nN3wwx/xa8NVsw8vHR+hrNYJIXxyKeaSgZOayY191ktbThhn4IVjJpFiBNZJ64toxbiRBlEHeDKGPfRSRjswI3C05nO1fHJ1wfkaVioRkNVi92yK1Q0MZHVFrqqGnq5IYmKOx7zvMGYF9OaDu7v4G/krZUoJ7JSziPyrm78VruI4GkcZbI4NJQ5oygq1N0gp0VeWwFLkmyfUvBa
 JpXNKk7x
 kBQHMGBmN4OEQ/O7JDFRBlpSbyGbOXFhPghLMPMV1rnvr0i0Nz/Ejp0Le0yWRj6/T5RbP+4Lp45XMjzdd50KaJc+eUATKHJSbeUxONE6t1ej6zKOAsJ3tihIAhxJmw9TmArltitpuC3fvBqRtK29e9Pe4PcCaijzDa0ylKXtWEBipDyTVKgu+vurY1Dc/HEAGb6bkBlX1oyyEOwq2vGi+P8CNmvyELUxT5V8PBNTfjrBUiZTrL4+IwvwL7cyD5XzMNz11s5xXlblqVwtNV+8E02jay0/8JNO7ppYZe+87Txd1QnJ/swfZvVP4oR4GfUAc3/REjUj+YFDIk06JJpkbABt9fiYQJWJdQLG31nH26nZ1jp2hS6/ZIWsFtWPTd8tlNzgV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:40PM +0000, Brendan Jackman wrote:
> Various security features benefit from having process-local address
> mappings within the kernel. Examples include no-direct-map guest_memfd
> [2] and significant optimizations for ASI [1].
> 
> With the currently envisaged usecases, there will be many situations
> where almost no processes have any need for the mm-local region.
> Therefore, avoid its overhead (memory cost of pagetables, alloc/free
> overhead during fork/exit) for processes that don't use it by requiring
> its users to explicitly initialize it via the new mm_local_* API.
> 
> As pointed out by Andy in [0], x86 already has a PGD entry that is local
> to the mm, which is used for the LDT. In a subsequent patch, the LDT
> remap will be unified with the general mm-local region, but to help
> keep the patch to a manageable size, first just introduce the mm-local
> region.
> 
> On 64-bit, give the mm-local region a whole PGD. On 32-bit, just give it
> one PMD. No investigation has been done into whether it's feasible to
> expand the region on 32-bit. Most likely there is no strong usecase for
> that anyway.
> 
> In order to combine the need for an on-demand mm initialisation, with
> the desire to transparently handle propagating mappings to userspace
> under KPTI, the user and kernel pagetables are shared at the highest
> level possible. For PAE that means the PTE table is shared and for
> 64-bit the P4D/PUD. This is implemented by pre-allocating the first
> shared table when the mm-local region is first initialised.
> 
> [0] https://lore.kernel.org/linux-mm/CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com/
> [1] https://linuxasi.dev/
> [2] https://lore.kernel.org/all/20250924151101.2225820-1-patrick.roy@campus.lmu.de
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  arch/x86/Kconfig                        |   2 +
>  arch/x86/include/asm/mmu_context.h      | 118 +++++++++++++++++++++++++++++++-
>  arch/x86/include/asm/pgtable_32_areas.h |   9 ++-
>  arch/x86/include/asm/pgtable_64_types.h |  12 +++-
>  arch/x86/mm/pgtable.c                   |   3 +
>  include/linux/mm.h                      |  13 ++++
>  include/linux/mm_types.h                |   2 +
>  kernel/fork.c                           |   1 +
>  mm/Kconfig                              |   7 ++
>  9 files changed, 161 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index fb298e2191792..3efab3524a6cf 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -132,6 +132,8 @@ config X86
>  	select ARCH_SUPPORTS_LTO_CLANG
>  	select ARCH_SUPPORTS_LTO_CLANG_THIN
>  	select ARCH_SUPPORTS_RT
> +	# LDT remap temporarily clashes with mm-local region, can't have both.
> +	select ARCH_SUPPORTS_MM_LOCAL_REGION	if X86_64 || X86_PAE && !MODIFY_LDT_SYSCALL
>  	select ARCH_USE_BUILTIN_BSWAP
>  	select ARCH_USE_CMPXCHG_LOCKREF
>  	select ARCH_USE_MEMTEST
> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
> index ef5b507de34e2..3d4f54673014f 100644
> --- a/arch/x86/include/asm/mmu_context.h
> +++ b/arch/x86/include/asm/mmu_context.h
> @@ -8,8 +8,10 @@
>  
>  #include <trace/events/tlb.h>
>  
> +#include <asm/tlb.h>
>  #include <asm/tlbflush.h>
>  #include <asm/paravirt.h>
> +#include <asm/pgalloc.h>
>  #include <asm/debugreg.h>
>  #include <asm/gsseg.h>
>  #include <asm/desc.h>
> @@ -223,10 +225,124 @@ static inline int arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
>  	return ldt_dup_context(oldmm, mm);
>  }
>  
> +#ifdef CONFIG_MM_LOCAL_REGION
> +static inline void mm_local_region_free(struct mm_struct *mm)
> +{
> +	if (!mm_local_region_used(mm))
> +		return;
> +
> +	struct mmu_gather tlb;
> +	unsigned long start = MM_LOCAL_BASE_ADDR;
> +	unsigned long end = MM_LOCAL_END_ADDR;

These declarations should probably go at the beginning of the function.

> +
> +	/*
> +	 * Although free_pgd_range() is intended for freeing user
> +	 * page-tables, it also works out for kernel mappings on x86.
> +	 * Use tlb_gather_mmu_fullmm() to avoid confusing the
> +	 * range-tracking logic in __tlb_adjust_range().
> +	 */
> +	tlb_gather_mmu_fullmm(&tlb, mm);
> +	free_pgd_range(&tlb, start, end, start, end);
> +	tlb_finish_mmu(&tlb);
> +
> +	mm_flags_clear(MMF_LOCAL_REGION_USED, mm);
> +}
> +
> +#if defined(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION) && defined(CONFIG_X86_PAE)

Would it be clearer to have nested #ifdefs instead?

#ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION

#ifdef CONFIG_X86_PAE
...
#else /* CONFIG_X86_PAE */
...
#endif /* CONFIG_X86_PAE */

#else /* CONFIG_MITIGATION_PAGE_TABLE_ISOLATION */

#endif /* CONFIG_MITIGATION_PAGE_TABLE_ISOLATION */

Maybe not, just thinking out loud.

> +static inline pmd_t *pgd_to_pmd_walk(pgd_t *pgd, unsigned long va)
> +{
> +	p4d_t *p4d;
> +	pud_t *pud;
> +
> +	if (pgd->pgd == 0)
> +		return NULL;
> +
> +	p4d = p4d_offset(pgd, va);
> +	if (p4d_none(*p4d))
> +		return NULL;
> +
> +	pud = pud_offset(p4d, va);
> +	if (pud_none(*pud))
> +		return NULL;
> +
> +	return pmd_offset(pud, va);
> +}
> +
> +static inline int mm_local_map_to_user(struct mm_struct *mm)
> +{
> +	BUILD_BUG_ON(!PREALLOCATED_PMDS);
> +	pgd_t *k_pgd = pgd_offset(mm, MM_LOCAL_BASE_ADDR);
> +	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
> +	pmd_t *k_pmd, *u_pmd;
> +	int err;
> +
> +	k_pmd = pgd_to_pmd_walk(k_pgd, MM_LOCAL_BASE_ADDR);
> +	u_pmd = pgd_to_pmd_walk(u_pgd, MM_LOCAL_BASE_ADDR);
> +
> +	BUILD_BUG_ON(MM_LOCAL_END_ADDR - MM_LOCAL_BASE_ADDR > PMD_SIZE);
> +
> +	/* Preallocate the PTE table so it can be shared. */
> +	err = pte_alloc(mm, k_pmd);
> +	if (err)
> +		return err;
> +
> +	/* Point the userspace PMD at the same PTE as the kernel PMD. */
> +	set_pmd(u_pmd, *k_pmd);
> +	return 0;
> +}
> +#elif defined(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION)
> +static inline int mm_local_map_to_user(struct mm_struct *mm)
> +{
> +	pgd_t *pgd;
> +	int err;
> +
> +	err = preallocate_sub_pgd(mm, MM_LOCAL_BASE_ADDR);
> +	if (err)
> +		return err;
> +
> +	pgd = pgd_offset(mm, MM_LOCAL_BASE_ADDR);
> +	set_pgd(kernel_to_user_pgdp(pgd), *pgd);
> +	return 0;
> +}

The code above bears a lot of similarity to the LDT code removed in
patch 8, and reviewing them separately is annoying. I realize that they
were a single patch in the previous version and Dave complained that it
was too large.

What if we go a different way:
1. Move the LDT functions that will be repurposed to mmu_context.h.
2. Rename the functions to the mm_local_* domain where needed.
3. Actually perform the switch for LDT to use mm local region.

Maybe (2) and (3) should be combined, depending on what the git diff
looks like.

I think this will make the diffs much clearer, for example
mm_local_map_to_user() mainly differ from map_ldt_struct_to_user() in
preallocation.

> +#else
> +static inline int mm_local_map_to_user(struct mm_struct *mm)
> +{
> +	WARN_ONCE(1, "mm_local_map_to_user() not implemented");
> +	return -EINVAL;
> +}
> +#endif
[..]
> diff --git a/arch/x86/include/asm/pgtable_32_areas.h b/arch/x86/include/asm/pgtable_32_areas.h
> index 921148b429676..7fccb887f8b33 100644
> --- a/arch/x86/include/asm/pgtable_32_areas.h
> +++ b/arch/x86/include/asm/pgtable_32_areas.h
> @@ -30,9 +30,14 @@ extern bool __vmalloc_start_set; /* set once high_memory is set */
>  #define CPU_ENTRY_AREA_BASE	\
>  	((FIXADDR_TOT_START - PAGE_SIZE*(CPU_ENTRY_AREA_PAGES+1)) & PMD_MASK)
>  
> -#define LDT_BASE_ADDR		\
> -	((CPU_ENTRY_AREA_BASE - PAGE_SIZE) & PMD_MASK)
> +/*
> + * On 32-bit the mm-local region is currently completely consumed by the LDT
> + * remap.
> + */
> +#define MM_LOCAL_BASE_ADDR	((CPU_ENTRY_AREA_BASE - PAGE_SIZE) & PMD_MASK)
> +#define MM_LOCAL_END_ADDR	(MM_LOCAL_BASE_ADDR + PMD_SIZE)
>  
> +#define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
>  #define LDT_END_ADDR		(LDT_BASE_ADDR + PMD_SIZE)
>  
>  #define PKMAP_BASE		\
> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
> index 7eb61ef6a185f..1181565966405 100644
> --- a/arch/x86/include/asm/pgtable_64_types.h
> +++ b/arch/x86/include/asm/pgtable_64_types.h
> @@ -5,8 +5,11 @@
>  #include <asm/sparsemem.h>
>  
>  #ifndef __ASSEMBLER__
> +#include <linux/build_bug.h>
>  #include <linux/types.h>
>  #include <asm/kaslr.h>
> +#include <asm/page_types.h>
> +#include <uapi/asm/ldt.h>
>  
>  /*
>   * These are used to make use of C type-checking..
> @@ -100,9 +103,12 @@ extern unsigned int ptrs_per_p4d;
>  #define GUARD_HOLE_BASE_ADDR	(GUARD_HOLE_PGD_ENTRY << PGDIR_SHIFT)
>  #define GUARD_HOLE_END_ADDR	(GUARD_HOLE_BASE_ADDR + GUARD_HOLE_SIZE)
>  
> -#define LDT_PGD_ENTRY		-240UL
> -#define LDT_BASE_ADDR		(LDT_PGD_ENTRY << PGDIR_SHIFT)
> -#define LDT_END_ADDR		(LDT_BASE_ADDR + PGDIR_SIZE)
> +#define MM_LOCAL_PGD_ENTRY	-240UL
> +#define MM_LOCAL_BASE_ADDR	(MM_LOCAL_PGD_ENTRY << PGDIR_SHIFT)
> +#define MM_LOCAL_END_ADDR	((MM_LOCAL_PGD_ENTRY + 1) << PGDIR_SHIFT)

Any reason not keep the current formula (i.e. MM_LOCAL_BASE_ADDR +
PGDIR_SIZE)?

> +
> +#define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
> +#define LDT_END_ADDR		(LDT_BASE_ADDR + PMD_SIZE)

Looks like the LDT area was silently changed to PMD_SIZE here. I assume
this is to give the rest of the pgd-mapped address space to the mermap,
but maybe we should call this out explicitly, or do it when the mermap
is introduced (or separately)?

>  
>  #define __VMALLOC_BASE_L4	0xffffc90000000000UL
>  #define __VMALLOC_BASE_L5 	0xffa0000000000000UL
[..]

