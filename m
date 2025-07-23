Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B841C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF9A8E0022; Wed, 23 Jul 2025 09:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2800E8E0002; Wed, 23 Jul 2025 09:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F828E0022; Wed, 23 Jul 2025 09:42:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0274F8E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:42:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A69201406FF
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:42:54 +0000 (UTC)
X-FDA: 83695645068.24.A89ADF4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf05.hostedemail.com (Postfix) with ESMTP id 742F9100009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:42:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KSsXCZDr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753278172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkGqpFJ/+zOIN5NKChBcby7PucrJJhjOWfsEGniZOTI=;
	b=fS7lqGO/avzrkLAW0qWiDiT8IE4nN8SKiWqyLrs76q3pDZbuxrN6ae656UhdHLYd9e+0Ak
	SGKnDhrjtBrAqMeqw3LZlDwAlQg7AeK7dHQqvbWQiEBpS+1DCYzoGK44mSpyrQqcXrT1Ym
	vOz5TR5qv9b947oS5YfDD5wfIcfhN1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753278172; a=rsa-sha256;
	cv=none;
	b=BEb/5FCWFhdWtQWYkwiFwM1Mep7lJZASWq5NuGn+owshTI09toKOrwIy3MLmhc0fQijgNo
	xv6IRL9mVH8JZxuNOyd27BVsYNMZFtFT1Ej9QqqfyKIKi+CkOl+kPHy87UfuT6iRkXY7Ok
	8/hO1uzPazWcyhk289Ydo2gfVyZUBG8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KSsXCZDr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753278172; x=1784814172;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aTj4lm8xWfLVsbNbqAfL0zQElnzrlfjF/NquOyDaCJE=;
  b=KSsXCZDrhn267c3ReT12aVabYTQJMLrAlCQ31c7pm36IAV///VLUuM0I
   3olAMvQidzXx7r06Pe7lGn5zPXkFdq5ArJiLiBJsex/ss4BIjFi/YVh7N
   rcxPgbnJFyhdzRwkdPTVZu3Er6nOdR985hB6eG4cg1Gq4uXEvxiOsamBq
   9pzZmUm9JFGByH65DUYrQ4JXjDMJgJVVZjCgbq+AAh0lKD6Go1ikaF+O5
   YMWrZc6gitTUJeKHtz82+tnM1/+V+U3SA6fcf1g7aQ7AVWbbb+TuBCcJB
   rxKn4ECbGCE7tsS7FpQecGTKt3dTkpnfgl/Q5djpfZ1hyI4clXzTQgKTe
   g==;
X-CSE-ConnectionGUID: bXn+BjlHQnyiHqJzZSaIoQ==
X-CSE-MsgGUID: LXRcNDPuQPi3nLiQr9OUbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55407411"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55407411"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:42:50 -0700
X-CSE-ConnectionGUID: yTIVkg39RNaz72vCTkFDrQ==
X-CSE-MsgGUID: fJ/Nw4uCQcucq0aN5JJTDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="196630738"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:42:29 -0700
Message-ID: <ab349c70-1d16-4203-a63d-3fa48b7286cd@intel.com>
Date: Wed, 23 Jul 2025 21:42:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 09/22] KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit
 builds
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-10-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-10-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 175dumx41ekpmftmzgh1e48phf5hua36
X-Rspamd-Queue-Id: 742F9100009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753278171-5910
X-HE-Meta: U2FsdGVkX19isXRTN50J0aEBj18mPRNdyYn2L42jjjcNzo1LqyQ3ZO9tg0r9YPGcN6L2N8RKal2u/OadNJ0p7HfdqDwbO7u5bwrk5zp4Ia62hzk9bDByxJ17HGW3CW7P2EKvLZ5dz+0kfmqGza/lERcDQZ3Z/JyIauZyd/uaSOBaW1/U770zIZAdulqumjc/RbhICHHZPBcESCZ8/VcWWBwcFEvlWa1rfARIUOc2uc5nuR/g00W6T/RUJ+EzoNr1O0qwfcqRqnTDpAB+xxmek/v9HXZVkUiZ9JMD89AyEDRGFBG4r9bGvl55VAIffpGJ9XX30TSEaRuOrS/ZUB4NS4p5KxyMUHfxhTUEAFOsNBA5Xwu/Lcg1Vsmmp1FklBCAn2MLg2ZQfOYl2ucqpZOzFYSHCJw5vTKBTytuc8H5KydQai04OfiCSOmQDhdqak0qGs6wo9VJD7c/bru3uG7k41U2r+lFqMjG2OuaBInYGLatMKtcbWF6grFHn1MYvsTA7WX9ouQRF8oElqekiXpEwf/LaP2KJoWROCcMmGQ5jwWl6Xeq3nfZHEzKioaB+1V77xYWrUYctNOQDtX443KlHxEeYnJEs+bA8nvmuWL1E6NFbiOEF40OHc/BBw869WkqqqW8qecfTK6pmT8oQuaGmjpAgG4nDmBcq66aMDFA+5X6a3IB4VF/h2ECde0YacRV8EbFh7I2Kj1uaUg73LK4EUPJ8NmWwQLXYEZNcDmx9xQ8dj9fszlZp12LmYvaDLB4xnRCEJTIU34pkdIUsaFx14vIcS5oz40JiSfoRmUs1krBiF8dbJt7DV7R7cY3flHn/0ZwN9WkAsCD+/T1PVAjLycfhRI4HummSt2oJqvwaJMVxPAQa8jGsTYF6VfVyf8Q4BGv25O7YyEhgiTuDWrCYdEj8of7n+aksd1Gg2VfQtEcz1znOLv565jAtJbroRr341zo+M6d/Xs8YYlHFFZ
 nMzh71d8
 f/VQBuDmQNjxjStFCJDsS4o+nzrih/QXGMaS70xa0Vi03rLnCZe0kNQGauOGoVdlPS4Pb86hOB55mhz4DtefxTCXwCdpSZCdc1NqEp5a1m01zjsNx/tYGyDGsD8hUlBT1ZRPAXk3vc3WCOceUYLbm5HcUWCwQ7rCBOuBsNmIrn9vf4hGy5hwIeYnWXTaGZVFzNJPLO8DE0xyVLeC4QZcl6tJ6FwP/L7KwuMSsmCWG7p0JbwsE2IhsjiJ610sl3XdW169fYCJjMC2oiZsG/PWEYZAsovLEHCHScT//IwUK54B/3tjyANw+Do0sZtfETpOOrGe2Gq/aaTCdwpdgOD3aL+GFCxR1eT6tHkzAPYmYftOCxNtq+89sF0OTJDB7mGvxy1rNInYEliLnl4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/2025 6:47 PM, Fuad Tabba wrote:
> Enable KVM_GUEST_MEMFD for all KVM x86 64-bit builds, i.e. for "default"
> VM types when running on 64-bit KVM.  This will allow using guest_memfd
> to back non-private memory for all VM shapes, by supporting mmap() on
> guest_memfd.
> 
> Opportunistically clean up various conditionals that become tautologies
> once x86 selects KVM_GUEST_MEMFD more broadly.  Specifically, because
> SW protected VMs, SEV, and TDX are all 64-bit only, private memory no
> longer needs to take explicit dependencies on KVM_GUEST_MEMFD, because
> it is effectively a prerequisite.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

It matches with my thought on v14 that gmem can be allowed for all x86 
VM types[*]. Get rid of .supports_gmem and achieve it through 
CONFIG_KVM_GUEST_MEMFD looks much cleaner!

[*] 
https://lore.kernel.org/all/b5fe8f54-64df-4cfa-b86f-eed1cbddca7a@intel.com/

> ---
>   arch/x86/include/asm/kvm_host.h |  4 +---
>   arch/x86/kvm/Kconfig            | 12 ++++--------
>   include/linux/kvm_host.h        |  9 ++-------
>   virt/kvm/kvm_main.c             |  4 ++--
>   4 files changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7b0f2b3e492d..50366a1ca192 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2276,10 +2276,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>   		       int tdp_max_root_level, int tdp_huge_page_level);
>   
>   
> -#ifdef CONFIG_KVM_GUEST_MEMFD
> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>   #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> -#else
> -#define kvm_arch_has_private_mem(kvm) false
>   #endif
>   
>   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index c763446d9b9f..4e43923656d0 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -47,6 +47,7 @@ config KVM_X86
>   	select KVM_GENERIC_HARDWARE_ENABLING
>   	select KVM_GENERIC_PRE_FAULT_MEMORY
>   	select KVM_WERROR if WERROR
> +	select KVM_GUEST_MEMFD if X86_64
>   
>   config KVM
>   	tristate "Kernel-based Virtual Machine (KVM) support"
> @@ -79,16 +80,11 @@ config KVM_WERROR
>   
>   	  If in doubt, say "N".
>   
> -config KVM_X86_PRIVATE_MEM
> -	select KVM_GENERIC_MEMORY_ATTRIBUTES
> -	select KVM_GUEST_MEMFD
> -	bool
> -
>   config KVM_SW_PROTECTED_VM
>   	bool "Enable support for KVM software-protected VMs"
>   	depends on EXPERT
>   	depends on KVM_X86 && X86_64
> -	select KVM_X86_PRIVATE_MEM
> +	select KVM_GENERIC_MEMORY_ATTRIBUTES
>   	help
>   	  Enable support for KVM software-protected VMs.  Currently, software-
>   	  protected VMs are purely a development and testing vehicle for
> @@ -138,7 +134,7 @@ config KVM_INTEL_TDX
>   	bool "Intel Trust Domain Extensions (TDX) support"
>   	default y
>   	depends on INTEL_TDX_HOST
> -	select KVM_X86_PRIVATE_MEM
> +	select KVM_GENERIC_MEMORY_ATTRIBUTES
>   	select HAVE_KVM_ARCH_GMEM_POPULATE
>   	help
>   	  Provides support for launching Intel Trust Domain Extensions (TDX)
> @@ -162,7 +158,7 @@ config KVM_AMD_SEV
>   	depends on KVM_AMD && X86_64
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>   	select ARCH_HAS_CC_PLATFORM
> -	select KVM_X86_PRIVATE_MEM
> +	select KVM_GENERIC_MEMORY_ATTRIBUTES
>   	select HAVE_KVM_ARCH_GMEM_PREPARE
>   	select HAVE_KVM_ARCH_GMEM_INVALIDATE
>   	select HAVE_KVM_ARCH_GMEM_POPULATE
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 56ea8c862cfd..4d1c44622056 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -719,11 +719,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>   }
>   #endif
>   
> -/*
> - * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
> - * enabled.
> - */
> -#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GUEST_MEMFD)
> +#ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>   static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>   {
>   	return false;
> @@ -2505,8 +2501,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>   
>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   {
> -	return IS_ENABLED(CONFIG_KVM_GUEST_MEMFD) &&
> -	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +	return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>   }
>   #else
>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index aa86dfd757db..4f57cb92e109 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1588,7 +1588,7 @@ static int check_memory_region_flags(struct kvm *kvm,
>   {
>   	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
>   
> -	if (kvm_arch_has_private_mem(kvm))
> +	if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
>   		valid_flags |= KVM_MEM_GUEST_MEMFD;
>   
>   	/* Dirty logging private memory is not currently supported. */
> @@ -4917,7 +4917,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>   #endif
>   #ifdef CONFIG_KVM_GUEST_MEMFD
>   	case KVM_CAP_GUEST_MEMFD:
> -		return !kvm || kvm_arch_has_private_mem(kvm);
> +		return 1;
>   #endif
>   	default:
>   		break;


