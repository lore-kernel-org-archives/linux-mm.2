Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A83F1D31A16
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3496B0092; Wed, 14 Jan 2026 02:27:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197C16B0093; Wed, 14 Jan 2026 02:27:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D586B0095; Wed, 14 Jan 2026 02:27:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA1BC6B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:27:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 974538B8C3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:27:52 +0000 (UTC)
X-FDA: 84329739984.24.180A75E
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8B77380004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:27:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b="U/MxLTb8";
	spf=pass (imf02.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoLWp43HOYjwRJyNJsc67cs6D8z3kCKzn/0ykuDh8HA=;
	b=bt59Lhu9bVUEvxPJJ4+1m+tiTzZzTT3iOkzd0Dkh/s1kQP2jhwXJxxabv9AL+sh8p0X1Zd
	KL2tyzY4+gvJFYlaAx63Wgl0G4uYrXsb8j8nXiovkJerggsI0qNzYGfjLAav5LDxPtoQDR
	gfoznroK4cxLWk/owXZOWgovg3z2u3w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b="U/MxLTb8";
	spf=pass (imf02.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768375670; a=rsa-sha256;
	cv=none;
	b=4xbxVsT6Q5b+Fc+jMyw2xpc4tIFpAZErL601XPKW4C3svjRJ/Ov/PBybSeiBTAG64KKYCF
	ZhaBzi9Byu/ETKWY7BFyc+jywzoEpYdCb9gH+02c9hVL5VNmjP10KCmEgl8LCDKCNkZd1f
	Fn+ADhEGb9ScgDbtiJOWldmu6h92QTY=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4drd4P0pSdz1DR2x;
	Wed, 14 Jan 2026 08:27:49 +0100 (CET)
Received: from [192.168.0.25] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4drd4M6G39z1DDdR;
	Wed, 14 Jan 2026 08:27:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1768375668;
	bh=JoLWp43HOYjwRJyNJsc67cs6D8z3kCKzn/0ykuDh8HA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U/MxLTb8zVdLMDfDaOBJbtayShpVqfmLzNsYBnvb64wtspGFMsgZTsrPC3wOoIaLu
	 kywwgDewFftKwA6/dELQHSxQdr6U4eCgbU5b2Xv1hnprAYzD6M28R5fasXD6TsgefO
	 KmidDVQEATQE2TP78neAQZVbaqPpTu5dP9dDpFmN85FmL+ftYaO/Rrjcs0ASbXQD2y
	 W24XwIYxbWV0LDjwKC7UzmRqMIEpZwEprXedMxQaZGak44dCLvtMH16KyfU1yvIpsR
	 AKhv2uLMHt2sI3Gcd+z9fbTl4EjeW/ZFS3inFDmkwr/j1qOMllDjqxmUZAxnM2akcS
	 wSePWEQv/mSSw==
Message-ID: <45e4a43d-8996-4296-9df9-d5f2a8efcefd@gaisler.com>
Date: Wed, 14 Jan 2026 08:27:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/14] mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
 <20251215150323.2218608-7-kevin.brodsky@arm.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <20251215150323.2218608-7-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 39tqt7qb8pjtxwaujt3kgjeb65cbeb8b
X-Rspamd-Queue-Id: 8B77380004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768375670-916621
X-HE-Meta: U2FsdGVkX19VBK3BL4mUJQwAyLO9eN8yRnbODZ2XFzWSrsLMuZDyu5BljOekSzaq2gUz+6e/xuhGSSgnLxCdiA7eSysBrte0jFy1RDoW11VzNHyJLhiz3xJ7mvWl0Eu6rb9W8Camc+LhYiR6NXyAtlf7Nt9LEybYew6Fl3RiOuofMUTlp+w1L/839d2VDU5+nsCqnF00VN93f29GvlrPG4OJm8mkh2iu6zcdVuXGc0nCdHQ5hxMwWieQL4uKLD5goBzmo1I56LsqNgrnpGQS6DL8k/8eSQKWNgMTYogOMpIH5pc0g7KEj0EWwKdornvGde/iJttp5+4rPT5E4CqcvjAWTl5a0dKwtHX3o34bXhmS33jP+msCIwQBkZBYuBdRIjRuMrlEosSkOnugUl/LJ0xvC4hQi2pFC2mcT9lcpmTXhJ7sMsHpke6tyFFt3t0RDO9nIYVbSUVErhbyLpky9zPELV7/GUoVRjAWEizul6g/wybLmbiTQto3yOYwTesBPPiuQTvobEUowbTux54dqNCFDLzwLpu+da/3koKLkBzZdnKU2sIMjZXSLsd+UWFrF9QbwYyrRJj1j4G+Xff7y6eEaBTLko4V7ibM4vYV054bphVkpWBLg6PfXUZf9NJyH012+ht54SQjc8ACdV5QmKnzlJP9NIoxa23KXauhV8UrY7XYhpUSKGuEqxWwy7E1ST2SZJTCVVcbvID2knBu9Q3RTvsBGg0lRC91Bc7+2ywEUyE8EflN9u/2nVAWlrKas96MUPW5946HpBu2xshTJvuYFSmLOv3CyGBWVIVdosgqcr2WyO6f3Dukrno78f81VrjF9F0PYlXLQYIJqMaCU++mpNuQUnB2ntIr2kT7Io9h6dcRCtkHLebo4o0I7RtS+7StwuhobU8lEuenzajzC++zbp+XZkHBgocB+Vddw0uszDINmwyJMs/Qy71w32oAqlpGODTUF117LA0kNUx
 h9tJEdDa
 8m1L3+80Kkgek+WZNDrZFSrZnxvJQY2F/of03Sc6pvcpYGOyARCssjXULuCKErC1QP+tf5LwlpLANQQIzbYyzLm7/X5g6nxFCZDhpH/C2bIw+Mse3SOSCEqN2UrLDbFU5B0bRDVaHMi9DWllqaVG7LKliuhnyWRKtFo8vHVyZ/3KFKiJBQoY3bJwjuK9+Vr/RNeoHhykdHEuQ4XU2W8A65ot+BJcprrVkc+SuMwvLRg5mm8umEPKQ5/HuPKgXRCMoXWqlJofI3lUd3JldYKJWaizSsMJWRiXBCkRB6Y246oMFQAy9AU4acz+51m+Tuu7hl4VYgNFh/CkOsY6AUvRZ7QDMnh2WkfFJAIJ9+j5a2GE++sKCOy2ovcPAf8KPpHwTOeFXWJmgi32/62DfXKqI0RvAOjeZVO3wuMboTaRNhMYBGzCftEVuDVk9qzUZ7pdffhIYU/MOpxyLCDoK+dqzf9c40kpJaiClQGcDGvyoVodK0uN0V+AFee/woiQTiBhaShDqEgpLi4aIFKWnhGKcGK/QnRh6RPAv1XqFmPdjnaj3+WwLg4K5wS3jkl32AVEat93MBtAu/tznUmDfoAOwCrtlpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-15 16:03, Kevin Brodsky wrote:
> Architectures currently opt in for implementing lazy_mmu helpers by
> defining __HAVE_ARCH_ENTER_LAZY_MMU_MODE.
> 
> In preparation for introducing a generic lazy_mmu layer that will
> require storage in task_struct, let's switch to a cleaner approach:
> instead of defining a macro, select a CONFIG option.
> 
> This patch introduces CONFIG_ARCH_HAS_LAZY_MMU_MODE and has each
> arch select it when it implements lazy_mmu helpers.
> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is removed and <linux/pgtable.h>
> relies on the new CONFIG instead.
> 
> On x86, lazy_mmu helpers are only implemented if PARAVIRT_XXL is
> selected. This creates some complications in arch/x86/boot/, because
> a few files manually undefine PARAVIRT* options. As a result
> <asm/paravirt.h> does not define the lazy_mmu helpers, but this
> breaks the build as <linux/pgtable.h> only defines them if
> !CONFIG_ARCH_HAS_LAZY_MMU_MODE. There does not seem to be a clean
> way out of this - let's just undefine that new CONFIG too.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/Kconfig                                 | 1 +
>  arch/arm64/include/asm/pgtable.h                   | 1 -
>  arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 2 --
>  arch/powerpc/platforms/Kconfig.cputype             | 1 +
>  arch/sparc/Kconfig                                 | 1 +
>  arch/sparc/include/asm/tlbflush_64.h               | 2 --
>  arch/x86/Kconfig                                   | 1 +
>  arch/x86/boot/compressed/misc.h                    | 1 +
>  arch/x86/boot/startup/sme.c                        | 1 +
>  arch/x86/include/asm/paravirt.h                    | 1 -
>  include/linux/pgtable.h                            | 2 +-
>  mm/Kconfig                                         | 7 +++++++
>  12 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 93173f0a09c7..3fb4603c0e16 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -35,6 +35,7 @@ config ARM64
>  	select ARCH_HAS_KCOV
>  	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
>  	select ARCH_HAS_KEEPINITRD
> +	select ARCH_HAS_LAZY_MMU_MODE
>  	select ARCH_HAS_MEMBARRIER_SYNC_CORE
>  	select ARCH_HAS_MEM_ENCRYPT
>  	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 64d5f1d9cce9..f7d66c261347 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -80,7 +80,6 @@ static inline void queue_pte_barriers(void)
>  	}
>  }
>  
> -#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
>  static inline void arch_enter_lazy_mmu_mode(void)
>  {
>  	/*
> diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> index 2d45f57df169..565c1b7c3eae 100644
> --- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
> @@ -24,8 +24,6 @@ DECLARE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
>  
>  extern void __flush_tlb_pending(struct ppc64_tlb_batch *batch);
>  
> -#define __HAVE_ARCH_ENTER_LAZY_MMU_MODE
> -
>  static inline void arch_enter_lazy_mmu_mode(void)
>  {
>  	struct ppc64_tlb_batch *batch;
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index 4c321a8ea896..f399917c17bd 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -93,6 +93,7 @@ config PPC_BOOK3S_64
>  	select IRQ_WORK
>  	select PPC_64S_HASH_MMU if !PPC_RADIX_MMU
>  	select KASAN_VMALLOC if KASAN
> +	select ARCH_HAS_LAZY_MMU_MODE
>  
>  config PPC_BOOK3E_64
>  	bool "Embedded processors"
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index a630d373e645..2bad14744ca4 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -112,6 +112,7 @@ config SPARC64
>  	select NEED_PER_CPU_PAGE_FIRST_CHUNK
>  	select ARCH_SUPPORTS_SCHED_SMT if SMP
>  	select ARCH_SUPPORTS_SCHED_MC  if SMP
> +	select ARCH_HAS_LAZY_MMU_MODE
>  
>  config ARCH_PROC_KCORE_TEXT
>  	def_bool y
> diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
> index 925bb5d7a4e1..4e1036728e2f 100644
> --- a/arch/sparc/include/asm/tlbflush_64.h
> +++ b/arch/sparc/include/asm/tlbflush_64.h
> @@ -39,8 +39,6 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
>  
>  void flush_tlb_kernel_range(unsigned long start, unsigned long end);
>  
> -#define __HAVE_ARCH_ENTER_LAZY_MMU_MODE
> -
>  void flush_tlb_pending(void);
>  void arch_enter_lazy_mmu_mode(void);
>  void arch_flush_lazy_mmu_mode(void);
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 80527299f859..2427a66cb0fe 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -808,6 +808,7 @@ config PARAVIRT
>  config PARAVIRT_XXL
>  	bool
>  	depends on X86_64
> +	select ARCH_HAS_LAZY_MMU_MODE
>  
>  config PARAVIRT_DEBUG
>  	bool "paravirt-ops debugging"
> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
> index fd855e32c9b9..4f86c5903e03 100644
> --- a/arch/x86/boot/compressed/misc.h
> +++ b/arch/x86/boot/compressed/misc.h
> @@ -11,6 +11,7 @@
>  #undef CONFIG_PARAVIRT
>  #undef CONFIG_PARAVIRT_XXL
>  #undef CONFIG_PARAVIRT_SPINLOCKS
> +#undef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>  #undef CONFIG_KASAN
>  #undef CONFIG_KASAN_GENERIC
>  
> diff --git a/arch/x86/boot/startup/sme.c b/arch/x86/boot/startup/sme.c
> index e7ea65f3f1d6..b76a7c95dfe1 100644
> --- a/arch/x86/boot/startup/sme.c
> +++ b/arch/x86/boot/startup/sme.c
> @@ -24,6 +24,7 @@
>  #undef CONFIG_PARAVIRT
>  #undef CONFIG_PARAVIRT_XXL
>  #undef CONFIG_PARAVIRT_SPINLOCKS
> +#undef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>  
>  /*
>   * This code runs before CPU feature bits are set. By default, the
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index b5e59a7ba0d0..13f9cd31c8f8 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -526,7 +526,6 @@ static inline void arch_end_context_switch(struct task_struct *next)
>  	PVOP_VCALL1(cpu.end_context_switch, next);
>  }
>  
> -#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
>  static inline void arch_enter_lazy_mmu_mode(void)
>  {
>  	PVOP_VCALL0(mmu.lazy_mode.enter);
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 1abc4a1c3d72..d46d86959bd6 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -235,7 +235,7 @@ static inline int pmd_dirty(pmd_t pmd)
>   *
>   * Nesting is not permitted and the mode cannot be used in interrupt context.
>   */
> -#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
> +#ifndef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>  static inline void arch_enter_lazy_mmu_mode(void) {}
>  static inline void arch_leave_lazy_mmu_mode(void) {}
>  static inline void arch_flush_lazy_mmu_mode(void) {}
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bd0ea5454af8..62073bd61544 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1464,6 +1464,13 @@ config PT_RECLAIM
>  config FIND_NORMAL_PAGE
>  	def_bool n
>  
> +config ARCH_HAS_LAZY_MMU_MODE
> +	bool
> +	help
> +	  The architecture uses the lazy MMU mode. This allows changes to
> +	  MMU-related architectural state to be deferred until the mode is
> +	  exited. See <linux/pgtable.h> for details.
> +
>  source "mm/damon/Kconfig"
>  
>  endmenu

Acked-by: Andreas Larsson <andreas@gaisler.com> # sparc

Cheers,
Andreas


