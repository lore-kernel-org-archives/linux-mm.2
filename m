Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 510BCD111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 06:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0466B0008; Mon,  1 Dec 2025 01:21:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75FD86B000C; Mon,  1 Dec 2025 01:21:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64F1A6B000D; Mon,  1 Dec 2025 01:21:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CBBA6B0008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:21:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F8C8140A44
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:21:44 +0000 (UTC)
X-FDA: 84169906128.25.C64B2DE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13483C0007
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:21:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764570102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GwZqCci0XesdEsRMxqflMc5VG3lhqbE3Ht/3ezIyxL4=;
	b=eQTdy3MtkjMjna4GEnGvK9iYs0cFBTq/onCqo6Vwf7JYfzPQ2OrDqBekQSgUqg6UF1L4M0
	m8EjAFx4JSvDyHIS+P2duvsOU3XB8h4eiLwkFusedwMXo7EuVv/EIpC9kS8VRqTmQUEce/
	DEHpYndH0irYLexHC/ANhbnNtof+SWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764570102; a=rsa-sha256;
	cv=none;
	b=Pz7yqe4oTPIXoAKDCVRlZIC4LqAJ6f6wdaKoPb+pNwnAfuL33JrAbyN2iuFFBsbI3Rq4xp
	ejtuwY1FqIqS1zHkSYHT8jk6KjCfAnnWUpGfmlNmyTK0h3T15z77a8XjpLsUTynbILiXIt
	x1kl5wxxhUcCHMq7HzzfEKGgAGVaWDI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 755C2497;
	Sun, 30 Nov 2025 22:21:33 -0800 (PST)
Received: from [10.163.49.14] (unknown [10.163.49.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C9083F73B;
	Sun, 30 Nov 2025 22:21:29 -0800 (PST)
Message-ID: <8d9ed1f1-77da-45af-85b5-78a5da66f1cc@arm.com>
Date: Mon, 1 Dec 2025 11:51:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/12] mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
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
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-6-kevin.brodsky@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251124132228.622678-6-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: umhssbf6pz6uuuuebyfudxkmqgpsqeyn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 13483C0007
X-HE-Tag: 1764570101-112239
X-HE-Meta: U2FsdGVkX19BXpm4QE4yTAFK+/3o+FDWtP7hUErzMiX7OABvNVx/qIZWZsgLumy3X3zuN4Ll8xAzwsp6J2Bni2YoFJoiXULfeCfFbnhZeJGLf/1fxiJE2Q2HyeSpxoG0AtGJz30g4vxV829RTCeTsYv/veo9g0JDGzsL1iGE6dHDJKaJ3hYBgtit9IwTkxGYlUNUbIeTR5M6wQNjyXloaHN5xepMmx5TA+Tvut7h0GrzlkfhSXanFK5LVuetYNkmxEl+pAQ/0wkwu+LdVixw12i5+1nuKpGoiKarzVIIrnTRFHrQYF0VCC1xhpv2t2LlXrYMNoSK3QaqHualSix362qRPLxdmDg7AOgWPN6eM6nKzofxzamlv+4hoUKZ8pN5vvmAqOE6UJJoSs2lXqaOj3Q8wSnBUDiTXrS4KAXjlLUPOeCnydYjeSTgcfU9NgaIXpERx/ieGZ0hmlifiWEExvrV+ydGcYDywAlREG3IlqRWbSX4/O+05cv1W8sdMsJMAUUvr5dTvF+tFprl/VyWGtTbeJLVxiaFr6z75Nmgv+VBq6KJ1QRdaa6diAr8u3X1JBRHllVCPYvhrirmOGz5ki8DAyzAAxunDYhzC1JgnJv2mimJA0oMWPiRpnmyhygQtTzfqVmcX3dwb9BVYmbFcjlhl5+ufEdjXkDvY5LrwtBZyJ1m0fBtUNMkchWojwTMCJTcCYzS4ccXT1RpZ/QGz8JGTmLJxqSLUavAGfWlj8ifpBTBlpi4uZoOmqbSEi4aY5RyG7/pjVfuHmCEbNp7AgHrOJeKZ1d6PrmlPEtLtmZGt51C72Z1ltr+EQMKMHi5G5/2GFfC4EabfRYhYn7KfK85EV1A/5t72EpEw9le7U89JIIK/ErvYtqJvYLIar+gLkPOIreIejf+LAauK0LUh8/1sNPmuGofH2225upTzzPeA/ih0stcf6sT1SWN98y82za/Np9Cky1VuYvRxel
 ttLTtlKF
 kZjh8vtrho/WCRo08Omn9S3hSPHLtAEyWQCshP5mqnU6LyKunJfoabhpjcjjFK8a4BtL8v91Gjtit3mbvc9olYIEW354eKJlUoJff3vS8I6/mnIIBne19M+6qVtOPcImtkT2W3QZIvl56FClXNL+Z/h89eXdbahyaOBYaW+/Bzqe07j8+ukQQkHALtMRhewthqJ7RucSxZ5wpLO2VmOec9/qz1/qIG11dW4uNEEotAMV5nkKSkgkPkR4i3pUu4H1vPljTNhM60lNKygH8hlGlKlDdkiYhtbpVCq1+jixqB+qRv370DXIFO2r/JDdTJTX2x76zUb/FddTy4y07xs2Uj91HTLsQbW/dHXS10Fl+zNepJ35JLxa/1s+sTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/11/25 6:52 PM, Kevin Brodsky wrote:
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
>  mm/Kconfig                                         | 3 +++
>  12 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 6663ffd23f25..74be32f5f446 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -34,6 +34,7 @@ config ARM64
>  	select ARCH_HAS_KCOV
>  	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
>  	select ARCH_HAS_KEEPINITRD
> +	select ARCH_HAS_LAZY_MMU_MODE
>  	select ARCH_HAS_MEMBARRIER_SYNC_CORE
>  	select ARCH_HAS_MEM_ENCRYPT
>  	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 0944e296dd4a..54f8d6bb6f22 100644
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
> index a3700766a8c0..db769c4addf9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -805,6 +805,7 @@ config PARAVIRT
>  config PARAVIRT_XXL
>  	bool
>  	depends on X86_64
> +	select ARCH_HAS_LAZY_MMU_MODE
>  
>  config PARAVIRT_DEBUG
>  	bool "paravirt-ops debugging"
> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
> index db1048621ea2..cdd7f692d9ee 100644
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
> index b13b6f42be3c..de7d2c7e63eb 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -231,7 +231,7 @@ static inline int pmd_dirty(pmd_t pmd)
>   * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
>   * and the mode cannot be used in interrupt context.
>   */
> -#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
> +#ifndef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>  static inline void arch_enter_lazy_mmu_mode(void) {}
>  static inline void arch_leave_lazy_mmu_mode(void) {}
>  static inline void arch_flush_lazy_mmu_mode(void) {}
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bd0ea5454af8..a7486fae0cd3 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1464,6 +1464,9 @@ config PT_RECLAIM
>  config FIND_NORMAL_PAGE
>  	def_bool n
>  
> +config ARCH_HAS_LAZY_MMU_MODE
> +	bool
> +

Might be worth adding a help description for the new config option.

>  source "mm/damon/Kconfig"
>  
>  endmenu


