Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D33FCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 13:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AEFF8E0011; Fri,  7 Nov 2025 08:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835D78E000D; Fri,  7 Nov 2025 08:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7241F8E0011; Fri,  7 Nov 2025 08:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5874E8E000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:56:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 226F012CA98
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:56:30 +0000 (UTC)
X-FDA: 84083960940.14.58309B8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id E5048140009
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:56:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762523788; a=rsa-sha256;
	cv=none;
	b=JNy0Jx2VxIPB/0MLIvrMCDIwIicoOmrlmk3IZhfs7utqit/d+zjlpJ1ClgFVc02Z/4tUrK
	62e3QOIZtpD6B44+MpeHpt4OP/L6pe9e68NBibJwG1myEfVOMSGhhUJlJn56fOMsm6brik
	kcfTIetKHTayY2hj4PFfUSemcv3nt04=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762523788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/N0zytyf9GWg2MCOYMZ3KiEnbTtu2OLzkkLJO68YSF4=;
	b=V5qDTPMsvv9XE3OCPjRSZgHqNbdjRMbL8fO6X8faabeqlTzXff4cdyph38kAhOrsQzhyLz
	qeIL52sQZc21d8dhZevF/qXuyigd1shzvAGPoTTettMrWxSOdUECc36pZ6Keo6uk5BrDm5
	s2lE2tA4RGzUFDAwcYQkNbUuwqjEpm0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F05461515;
	Fri,  7 Nov 2025 05:56:18 -0800 (PST)
Received: from [10.57.86.134] (unknown [10.57.86.134])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 235F03F66E;
	Fri,  7 Nov 2025 05:56:22 -0800 (PST)
Message-ID: <6a9c846f-22b6-4d5f-81dc-6cdcd4905952@arm.com>
Date: Fri, 7 Nov 2025 13:56:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/12] mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
Content-Language: en-GB
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
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-6-kevin.brodsky@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251029100909.3381140-6-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E5048140009
X-Stat-Signature: xgxocyf93ozp3k918hy64g71xnuhwnbq
X-Rspam-User: 
X-HE-Tag: 1762523787-93395
X-HE-Meta: U2FsdGVkX1/2rXFmbibgcyF8Y2YU7c8SBtkC/F2yhIa/Dnre0LyEzrxViVKbJJ5PQnU8HPcVixnQnKcDTpOk/1WYuOthmKrKoVNCjIifQ1xoZ+kStDiHQtMGnQcN4++RGUoonaM2D/78REyQ1gVqCOahiRS7nmtWk2oHhArr8XTriNE1mBmUDCRptiFAbhWT+q64C+HV2G6e5IJtTjuutp419YuRASf4Gyi26VupgeXiTPPPPDiTn+0TrzO0aM3MeZ5Kk8T4LR9lwUVSC2FiOjKwtIGGhfjKyvHCCKfEsSOOLxHORo2ZFdxWYCoe9aaoptfZSVrzrB4giOR6fllB7CnFkGldhopJ+K3ip17k9+ZeMGCeR3oRMSmOvCiSxTSTcKAU+bMdksf9AJ0eCh3BIXxZFDSErwIWK79bPHtpkeOVe/wQgszuGGVn3Fh8zWsa5xptWqAzshZzpS6C2vZnOYxquaVLXqih84HTWUoycxSECTvGR+tKC8Zv4dsJAJsNCnIcfkFYgWKwSoRE+vrouVDp0ohZUpiZyqW0yCxSx2GjtOcNLV+UsumBn/sKR23OdUV9wwE/utYW9p9H7K5eQXusu+3a2LKBeeavOE422DkTXGxM6YhcZox7CAxmncV7UOCFCTroeOF0g2jj6s5krml8Do0mR9oW2Tk4VL9bjopCseb9Iw74Zsuqy4JP4NGOyIxIgWnhMRThR/SKESg3I4qgL+hr0UvHCx2j6RZfLKaE6V0gM6D97P3gZr2wPKQNcnNz3WA813bilzD8tZSSgp7iMwQnw/jUkas5GgSIQRgxxpbPSOnAf9cak6BVcXEerDUzTc/eQ/ucLrnDVdpEm2EUnc2HZAs4ban090v3t1yJyFLfu8yBGf+fgyuuBEADkoyScRj0q0AVczhxMAmdJEPowwpFSHNku8bA8w/LwhKc2rwapNC7rnkMkNRPwAFAHT00NqUGi676d7Ai6/W
 Ya/RnYCM
 ZXhE3ImjRNfzI+983he/4jI9pO0EMUIsDnWjTMZAuZ2+tb/7hPzsuwdUI86Z3gomXKhccQndlZNMiswhU71R6xj4SM02rqhGxwcaqLi9captZ1S5XKI/OVRYzu42cjMkBr6MofknuZMlAnTdhpUuWtwn3vXhKuZ/sAnhmrSOlAnCniwoxzRlfD2dSKNjAkgfpL8iXEt2VvT9Xk230Sy+6mAVR3dPEoSvfoghg5NVde2v+gXgb+QXCF13gMsVwCgpKwh5e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/10/2025 10:09, Kevin Brodsky wrote:
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
> index 6663ffd23f25..e6bf5c7311b5 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -122,6 +122,7 @@ config ARM64
>  	select ARCH_WANTS_NO_INSTR
>  	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
>  	select ARCH_HAS_UBSAN
> +	select ARCH_HAS_LAZY_MMU_MODE

nit: This list is mostly in alphabetical order. Further up the list there are a
lot of ARCH_HAS_* entries. Perhaps move it to the correct position in that lot?
Then ARCH_HAS_UBSAN stays out of order on its own.

Otherwise, all looks reasonable to me:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

>  	select ARM_AMBA
>  	select ARM_ARCH_TIMER
>  	select ARM_GIC
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
> index 7704dbe8e88d..623a8a8b2d0e 100644
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
> index 7b527d18aa5e..2942d57cf59c 100644
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
> index fa3b616af03a..ef4332d720ab 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -804,6 +804,7 @@ config PARAVIRT
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
> index 32e8457ad535..9894366e768b 100644
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
> index 0e26f4fc8717..5480c9a1bfb2 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1372,6 +1372,9 @@ config PT_RECLAIM
>  config FIND_NORMAL_PAGE
>  	def_bool n
>  
> +config ARCH_HAS_LAZY_MMU_MODE
> +	bool
> +
>  source "mm/damon/Kconfig"
>  
>  endmenu


