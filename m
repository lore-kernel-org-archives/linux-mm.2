Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF25C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36FE8E0021; Wed, 23 Jul 2025 09:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7138E0002; Wed, 23 Jul 2025 09:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0228E0021; Wed, 23 Jul 2025 09:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8CC58E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:27:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55F9180702
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:27:33 +0000 (UTC)
X-FDA: 83695606386.05.030C793
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf26.hostedemail.com (Postfix) with ESMTP id EA28E14000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:27:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MHG24sMG;
	spf=pass (imf26.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPkVhJESqQPPIM8VSRdKyTFaF2aUzFYIxIy9aX3sHU8=;
	b=HfpnN0g1yCm84GGAUWv88c8czpsyaJeUKowfpytjsLdcLwE6iGG6Ls71sxQipzRKf7hCIh
	7k5IbUesh+rJChgLw0tgKzgwGv5i3Lk8X+dPE9xIM8lf9uHRIVkbWQYHYOS0m/LgN76+jw
	CobwzODHn8mYh/8lQlj1FOgmHDcHkN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277251; a=rsa-sha256;
	cv=none;
	b=4a56a/des/p96assUc4++8B56b6JPl/8qUQuZeCdmrbRrt/fHJO1lGA4M9kesKB0dgqS8F
	fbBfhHL4aEv5z6OxIu6lBlyqHrf/GqFK8ItJk6zaLB107FqGO46ofQQe+j+NvEv5KUP7hm
	h3RvJo4RBnJxOBLqmddHvatJDUIc6wA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MHG24sMG;
	spf=pass (imf26.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753277251; x=1784813251;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=chDTWX5a3R65VeyMPmWT/vUkB2Kxq9PV37cbFxZXFmA=;
  b=MHG24sMGKxGa6UjdV3RBIaavt4brKz0ik8hzpF0dI3/gw7uloSrfTfXd
   ndyu7NQJriG+5ULgvTY0cfFhil6v74HsDSNqxsZ53qr5vplWB2dPth4vT
   pCNA1eqMwELeyXUliMNWqstJlDNAl8P/SQvvHSsDamg4NFTEuVDitZUIC
   ZP+bIncLPh7Zzxh6+8fMxq8UlOBwP/r8KODGSEozr9zbpaX7hvMFrILQr
   wPFnUQK/qaBVtOPCF/SGaAfDCj0uMQI+Ame1doIDSW6NKb4wLG8bcAUPb
   sBsu6frrWxiAYEz1wCbr2LGdIyfi7ZfEixDNZQcYjzNnbl1E4SEhewHxe
   w==;
X-CSE-ConnectionGUID: w9C654FpR8K8/6u+aAtmyQ==
X-CSE-MsgGUID: 0DvNwpxeTXSi34q3KJCUwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="58173883"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="58173883"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:27:29 -0700
X-CSE-ConnectionGUID: SWccDMwzSMqd/Mz7ntxyHA==
X-CSE-MsgGUID: rSy2YXBLRKqFAWkzayDTnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159275110"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:27:13 -0700
Message-ID: <a438c189-4152-4ad4-977e-6a5291a7dd40@intel.com>
Date: Wed, 23 Jul 2025 21:27:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/22] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
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
 <20250723104714.1674617-6-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-6-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EA28E14000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: t7s1dq3fj14fxga7bcxphsjjherpcjfr
X-HE-Tag: 1753277250-152814
X-HE-Meta: U2FsdGVkX19T2PXFO88BaLZ63T6tNiRrKyL/13JNCaPMNApVKK5vu8ViOx0dT0bLcHponWXl+kRw0kHyFjam2m1LlurriV7IxJrM+pKEA9hntqJ464K/N/XUF8zMXabu8RqOu5pIVxCcvyJJMsuZ2WqwcEq8u6ZEP7kOTtyyDTcxbQk2Op6GcauAJEwaJcUrKkk8HlxeAnbL0JCkgGwYq6yq/ccbnWkmm32ij1GelmFGUkJ8E7VH4rZSVeaSnXuCs1uKoKAjUKr0cibHcgV/qW9Th0fT7P0+nQr5bBrc4t4/IGO0ehj3+/dbQbFNFSR06URK+Fern/Z85ZMcBY8UYk2PqX5DSAsD1eS48xNsfintlNnBqQszytiWQDMohAZuCrgiM+0fNR/gwcHp78ok4cEJzRBJQsHnBtHncH9962Ts6WZ0CVpgym0Fqt39S3OZIzrLD6drLJwkoeGWxwYZ9hjHS6J4fP7261wrUK8r4rQn7dJT8UE9iCVHz2G3BQFzuB05k8//kDfmDUK0Y/HHDhNwvh4IEjqzstypLudbqokrNze4Q7poURfCTmbkGfpHp0C/pznHPUCTY4qUeV6OCs34OBjgQxotI2xLhrPn4BDlC0Hmzd7seiOiPV+ORbvaGw5eBZxjzS9tT4yczuze/xe+xXEVMUmfeowyy4E/2ZZVzAHfcIit4Nnvj8/uYai3pRW2G6upb3ahUwGDls0pD2bTHTYiEpvthe9bHA9UHYnDvtXZLun3USceIaMwUl/XjV1pXCVvFT8omTdkT66wgbsI48Tyx/vn0d9yVNJYyFQoRs/KEBBfUlDJQsXHoi5h0UJt0IfOm1GEdi90JVnb3DAgvkftg0Aad9Geg6akMldqScx0Yvn1bNbw+J3bfULjrty254v9EOm/xz6e5hx7+dWI0MpFkpvCGRXpUCxdmOJBHF8vfdpEsQTFkU2mGcyM6YD88kA8Pcc/piQJ6Ow
 eKpEvA7+
 Y8y6PxbRQwe9DHKWLI4WHMnVn6I1ifvrTTORsxZYzYPBkhinflX52TvCaN8hXKbRVO4GbOzdtWcj1ErCpn8tatf9UK1unbhrySi5rZtoBdttbsv//+1k5LpaVm45PrrUThBmgitdiAd0d/bK1D6QU0yWeO9F+GfGk7FMCLldwvAJx4rdDsFXGRJc4/df7gskbAoUASInGJKM9SJMM3LE1CqPahZpGCdF5n1OAdh8LTeFMqM9qn8xNV7srKntBDXBqdExHu8UmmOc6gjXw8AeRBaSXMgBsQwtsU7iEhGDBLQi3EF3ZQdmOrKewKd8u76Qpy967OklFhiWd0q9tUTkW41p/W7e0m5NGueBlyv8Q/+iZ8JNQgjQo/XQrstqVvFil/zWoqxJW+Ui4T+YI3a/3Z6hbinNfrv08a/Ud
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/2025 6:46 PM, Fuad Tabba wrote:
> The original name was vague regarding its functionality. This Kconfig
> option specifically enables and gates the kvm_gmem_populate() function,
> which is responsible for populating a GPA range with guest data.
> 
> The new name, HAVE_KVM_ARCH_GMEM_POPULATE, describes the purpose of the
> option: to enable arch-specific guest_memfd population mechanisms. It
> also follows the same pattern as the other HAVE_KVM_ARCH_* configuration
> options.
> 
> This improves clarity for developers and ensures the name accurately
> reflects the functionality it controls, especially as guest_memfd
> support expands beyond purely "private" memory scenarios.
> 
> Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
> function. Therefore, ensure that the correct configuration is selected
> when KVM_SW_PROTECTED_VM is enabled.

the changelog needs to be enhanced. At least it doesn't talk about 
KVM_X86_PRIVATE_MEM at all.

If Sean is going to queue this version, I think he can help refine it 
when queuing.

> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/Kconfig     | 14 ++++++++++----
>   include/linux/kvm_host.h |  2 +-
>   virt/kvm/Kconfig         |  9 ++++-----
>   virt/kvm/guest_memfd.c   |  2 +-
>   4 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 13ab7265b505..c763446d9b9f 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -79,11 +79,16 @@ config KVM_WERROR
>   
>   	  If in doubt, say "N".
>   
> +config KVM_X86_PRIVATE_MEM
> +	select KVM_GENERIC_MEMORY_ATTRIBUTES
> +	select KVM_GUEST_MEMFD
> +	bool
> +
>   config KVM_SW_PROTECTED_VM
>   	bool "Enable support for KVM software-protected VMs"
>   	depends on EXPERT
>   	depends on KVM_X86 && X86_64
> -	select KVM_GENERIC_PRIVATE_MEM
> +	select KVM_X86_PRIVATE_MEM
>   	help
>   	  Enable support for KVM software-protected VMs.  Currently, software-
>   	  protected VMs are purely a development and testing vehicle for
> @@ -133,8 +138,8 @@ config KVM_INTEL_TDX
>   	bool "Intel Trust Domain Extensions (TDX) support"
>   	default y
>   	depends on INTEL_TDX_HOST
> -	select KVM_GENERIC_PRIVATE_MEM
> -	select KVM_GENERIC_MEMORY_ATTRIBUTES
> +	select KVM_X86_PRIVATE_MEM
> +	select HAVE_KVM_ARCH_GMEM_POPULATE
>   	help
>   	  Provides support for launching Intel Trust Domain Extensions (TDX)
>   	  confidential VMs on Intel processors.
> @@ -157,9 +162,10 @@ config KVM_AMD_SEV
>   	depends on KVM_AMD && X86_64
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>   	select ARCH_HAS_CC_PLATFORM
> -	select KVM_GENERIC_PRIVATE_MEM
> +	select KVM_X86_PRIVATE_MEM
>   	select HAVE_KVM_ARCH_GMEM_PREPARE
>   	select HAVE_KVM_ARCH_GMEM_INVALIDATE
> +	select HAVE_KVM_ARCH_GMEM_POPULATE
>   	help
>   	  Provides support for launching encrypted VMs which use Secure
>   	  Encrypted Virtualization (SEV), Secure Encrypted Virtualization with
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8cdc0b3cc1b1..ddfb6cfe20a6 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2534,7 +2534,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
>   #endif
>   
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>   /**
>    * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
>    *
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index e4b400feff94..1b7d5be0b6c4 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -116,11 +116,6 @@ config KVM_GUEST_MEMFD
>          select XARRAY_MULTI
>          bool
>   
> -config KVM_GENERIC_PRIVATE_MEM
> -       select KVM_GENERIC_MEMORY_ATTRIBUTES
> -       select KVM_GUEST_MEMFD
> -       bool
> -
>   config HAVE_KVM_ARCH_GMEM_PREPARE
>          bool
>          depends on KVM_GUEST_MEMFD
> @@ -128,3 +123,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>   config HAVE_KVM_ARCH_GMEM_INVALIDATE
>          bool
>          depends on KVM_GUEST_MEMFD
> +
> +config HAVE_KVM_ARCH_GMEM_POPULATE
> +       bool
> +       depends on KVM_GUEST_MEMFD
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 7d85cc33c0bb..b2b50560e80e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -627,7 +627,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   }
>   EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
>   
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>   long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>   		       kvm_gmem_populate_cb post_populate, void *opaque)
>   {


