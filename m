Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC4BC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8440D6B00A9; Sun,  2 Aug 2026 12:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81AB56B00AA; Sun,  2 Aug 2026 12:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731846B00AB; Sun,  2 Aug 2026 12:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4575E6B00A9
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:27:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3801A1C45
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:27:19 +0000 (UTC)
X-FDA: 85056859398.06.DFB823E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 385B9140007
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:27:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RbsnRO84;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKjc3TaK187Ow1jc4cqwdroCBKbKjzdu63N3TTnN2as=;
	b=UEu2b7l+zcsAzn22sM0UhXaN1VRgP/uNEtwC1UO48hGh9bFip/4TeFmwrWPjYghuTBDTAP
	Ly8O9rhDk9bmJijlUpbnLSFFL4bCGlapCehMNBTmcjYDBYHxdvjdiP7pkKDGC9oWo6GyLJ
	eRi/OpCOFhI2PeipyE1AS7ZbdzaD/bk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688038;
	b=otsHY2x7OpGIoA22bKPGosDb/XyL/MmeUPPxPet3LYVkHjHOqNF2iuiu9pnUN6Yo5tt5+F
	erBQ1wGFLUu6Y2s8aWvJw9fYnUGJ7Vz+5XM1MrOZBmmMxo/XZKl0jmOSjFXSElqUXGKoSV
	Y7NR9q6q4wiBurnQESspopCEBlAFKW4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RbsnRO84;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF29160DED;
	Sun,  2 Aug 2026 16:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909551F000E9;
	Sun,  2 Aug 2026 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688037;
	bh=QKjc3TaK187Ow1jc4cqwdroCBKbKjzdu63N3TTnN2as=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RbsnRO84nLwR4FAQU8isvBanq+9uIEjaWVHqRGSnEcSY5h79Hm8Q2OLK4170/JC/B
	 JHQ3uYGTUGHGwlbeMU1gDQxxBSFnidulo0wBL0l8XxXR502oxxhffoYmf8ArRz0DLK
	 fGFPU8X8f42GYccZWwF1HRZSK3uVAy/gEPvC4MsP6KbaML/pIXhV7wGTwHK89JVUVf
	 pjSqvAzVOIy3vTxEbPPOfS6XSdxyuhNHnuRZ3WNMoB0NTA+LQlh8edg/OI3AqhLnfe
	 yz8YAGrmD/gdPAG/7XR/UvqMLRFJFHZzw8kcGLRXlYiAB8BmEyj6zpGKU6XMyInr4J
	 LwTM9v9h7Me5w==
Date: Sun, 2 Aug 2026 19:27:05 +0300
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
Subject: Re: [PATCH v3 07/26] x86/mm: introduce mm-local region
Message-ID: <am9v2bAyhWXgv4Dd@kernel.org>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-7-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-7-6f5729aa9832@google.com>
X-Rspamd-Queue-Id: 385B9140007
X-Stat-Signature: ctk1oeb94rwz3pobjgq99d61mcimen69
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785688038-590556
X-HE-Meta: U2FsdGVkX18UsWMUUB3wYO+Nm8UrTGUcYWwhstA5nC6OjNcV2zbY9XkAv9PQNdXZ9Rrbmo8rHKb1Gcpaz2z/2U71m+MpXEv0/7eaQM4LV9VkigXHOk+EsU+LeeazUMdHspLNCtgh8YQJFNLULIDJNrig1bl73kzp0GPiSP8LMD1MW8u+/7KkYdkDyIHzkTFgtDdyoyvDo56tyBT12UuGN7auWPrxk2hDz/w+t5IlYBfn4xvQy8eloqzvlm+dnGw8JIO/ojEzeyP23UbTaOmPcBM0BEsyHPyAgN3c9Bkm/TuO/WfpWzMLQO5CFucld63AH0yFhOcIupPhvdYPqM+sE3C/MOuXSGM6Cuv15g/r3N6QwKxZE2sl2euxZy28Qb7+z6kWyCfH28n1xmsBxM1VEknNDULl3MdU/5G3A96rpfw4/TqOnw3SuiTPPPLFpcmHt2+nuwFiBJ7E+4rPiZ5hEMN/Il3N+i+XOzWmn+ZqtSw8vSlwyzoU2Yw8bsom2+xXVN7t6QKK28P4rPeHGboerGc2QMCzGoYYPRrEvF+vegipv3VkbBMhoVgap+utI5a2nm+Hb/UQ89qZ8RCQZvNO1Mf7+xRbOjV9tuNMgCh8bMDqw3b0RueuRlxs5ZbE+fxTbO0DgezFaIaNsEoB9XkStpOhX8BpKqt52XS+JxfEnWZ7G491iIGJBp71Rbtp0AYD65FpA8p1C/wGs5IJ5X0s9XDcbZFhkuzWa9dmbhlg40NYLuSrGiy+OyVP9xkCjC+zAGFoINPP+nooELYA7vyoiFUBbBWu3j+dvvprUtduZuMEWaIZxbL7uFLhznZ7IvSqBQOIvIh8a52pTjlcFD2omYIT2dJwESb5tF38rly6tB9I/a5Sxcdbqq9FIDaNC4uWADcQ64LEDrdK71OkKCHKDQ/8AEYe8paL22BQJuBjQ8FVRETyvtV9uM0r0jXuamn3kQZmecbhFYtgjJ8Oev6
 9nS1Xmw2
 sE1DeDEIl9JazEHIxB6ob7W2p9oj5hgBAPZ9t6JnTlmV+vGvONpg7Pw9A0p8R3zgF4cZDDoNOfEf7yeQHWiHeYLwc/BrmBVvlcbyvXyZyD6WSIiSwCqtAnOaJCnnooPrMpxw9P4BHF74z8sJFkA2o8oqwIjVpQW9++G5L1KOucj15B5DMvm532XpSJrhLjN/kz8PclXaMEa0fYIA1lRP994n3JhIui1K/PPC4dz4QFHHDlvndybzVUydR5xQ5l1l7FXyL+zaxo5PtvH1UiD0X8TYi0UFSH/CuYudB5cf+y7twIeJBS8uj07J75jR4XBrJZ5j6Tzt47jj4cHHzIVjBXH5ZHYMdCmtucVdVmzheouMwvsW8DHXspu80jHLcjN0fcWVS
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
> +static inline pmd_t *pgd_to_pmd_walk(pgd_t *pgd, unsigned long va)

There's very similar mm_find_pmd() in mm/rmap.c and I bet a bunch of other
places walk from PGD to PMD and return PMD in the end.

Can we put this function into, say, mm/pgtable-generic.c?
Finding all the places that do such walk and sticking it there should not
be a part of this set IMNHO, but having it in the generic code is a good
start for a future cleanup.

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

-- 
Sincerely yours,
Mike.

