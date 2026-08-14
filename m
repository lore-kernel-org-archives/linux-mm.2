Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 332A6C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 06:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D88B6B02E7; Fri, 14 Aug 2026 02:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390E26B02E8; Fri, 14 Aug 2026 02:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277856B02E9; Fri, 14 Aug 2026 02:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F38216B02E7
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:30:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53F7D80367
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:30:46 +0000 (UTC)
X-FDA: 85098901692.06.D41C1DC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf21.hostedemail.com (Postfix) with ESMTP id 33FCA1C0009
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:30:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UkfPgko+;
	spf=pass (imf21.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786689044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wdZOt7dUVnA8o6s5yjLHvyw97/pXx3crb+kO0PV8uE=;
	b=EZxrPO1/So9ssFQweLjA2LEtAS9KHm5teLvspXBQQkVtRJT013zr7R0TPor/YcME431jgq
	uAagtBAj0fqsiajHLjVm+7NFQUgaRFf3Iydvw+lBIHCkQSOioDONCsyHI6h9TYULCOB8gY
	wo8paWNlYgaNudkOc1PdTrWUlAEUA5E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786689044;
	b=Nrc0beuMmYsmpd4SbziBrE9V9TGTbwAIh67B0qDjA24N0ptXoDxXXfjVPUrRLTTScx9MOS
	FDG5R5BdlAZOl+kL3WuF/+5wssV4mgfLcgSQRz+52UZqpXEsrFa6hNxkYHUaVO1JPxeXrq
	SuymZ7nTrqG7goggaAIVCOe3KmKh06A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UkfPgko+;
	spf=pass (imf21.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786689043; x=1818225043;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lvF7pJW1VM34mjkgORqlnrodCT6IZU0t2OrgLf/yWf8=;
  b=UkfPgko+JTgFtv6FxWuO+1J5MLD1pVbc2d5ljNVLj/4wpbnBWGg7d/r7
   rtKKM84fkwMkLoA0FcGLOGYtw4YpzlWqMH10s4FLuXfi2J24/8l1hIktw
   4pCty51+CcNhNjvQrePIAJOO8X4Zx4M5p2SyinbvAWUK87Qnje/lVWViu
   V7IgzKnsDsxk2EG84+Tz5iq4YLaVKYtYKpjFn07S+U69QwoXjLqF4b0TE
   9L+neOysGWOmZl1cw38RvF0BRkb0+7RJFESOumZmwyttLY8+ZG7+QcPTL
   qjX7L0zdHleeaIkv7FFT0oLQ88yOPH8a1ABdRbp1Y+NFJCab0x3acgss8
   A==;
X-CSE-ConnectionGUID: 3rgbKxJGTpOsg4ejwLRJDA==
X-CSE-MsgGUID: twUh3z4WSNOb9gy3yXwM2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="97858874"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="97858874"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 23:30:41 -0700
X-CSE-ConnectionGUID: Dbj20DsZSw+g4w0B3MfgWw==
X-CSE-MsgGUID: TWw3KlovS5Ot+mNiNFDdEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="288934258"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.245.162]) ([10.124.245.162])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 23:30:26 -0700
Message-ID: <f41624da-8461-45cf-b555-241091faeb63@linux.intel.com>
Date: Fri, 14 Aug 2026 14:30:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 20/41] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-20-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-20-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: cdgzuu1cz58ciqt87z3o1ssbabxifjyr
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33FCA1C0009
X-HE-Tag: 1786689043-662921
X-HE-Meta: U2FsdGVkX1+rwZM/57nPnDnngaiVmkQA8UdPGHUEJMUsXncuWciuyTUCB/Szk30a3fRuhbyVU2b6mgmDx2jd9hXutQemWqilfdCB7Y2iaOkvemDeJLatrfe6PZGMPgQnpeLl2oXe+5YHmkOd0y9kz5tFe1Es4re2o5t8B9vuBtwddT48m2kcDAWXrZzcMmW2UQfYXRnE6o+a/k32qCmerBJLd2zT/DxMcykXY4OlPUHWTxDb7CkEaLV1UNBu/oeQC+Pt+Hje+HbCg4gfBqTU1jo4mMs8/tAKrx9jip6PM4Stl7ioFrc15ELvV/yQ9cUj5bpjde9UKltX9AUqHR59zjtLUWI2Wu/JUjt1pziFFWKzODYmND3iV+F71PzP59+HS5LB1uf9y9zQ3zN+StxrjuQpGVw9UI2npA0dCi3zDkqhv69mnY11YwJICwclCWCewMPjkzufPdjjCaoItkiVhr6rhK/ZVTXqYm6ISrxXXj4s5n5oGFJ5lLpdYDlKenSdS+eB93wKUjsrkp9WwxL1BQ1JK3JmDn7FoDRKeG6xZ3POwsh37hEy1rHKh/9Z4qEajoHPX38Ser9XhPe+ZuOM83sS3ovhfAFEW/73ksGUfGuHSyicdaGFi+JA8Qd616MQCmPy0Z06dkqgHz9eYKNpjr9IYnWaLFbx5kHZI1h1Nz3PFwefgjYv0TuV73nkh1/AWdJ7gD1XMyIW5tW8rFkJ+tJJYtOdHfpkCALqW4toJx2EfcUyFHs/VLBvNVij4DE+/9zhqWL8w4mzQGcyx7ZqJ8SD9UbbuRGD8Y1SAJwDzHnj7vBfN8zNyDuPCqPkjeSGKhWRJQvg3pQrmKv0zEIYHwNPh42HKznvZH5iHKgd5fB3mERBF0K+5sH1OaG3K3yA0hejzK4M12s+GEpmIzK1BpgmQ+O6arX9zdUcvZycvJDqsrYg3/ixeUpxFYzGvFN/Tt1ol/cgV1H5IyljWPb
 F5oN7x19
 C4I4S5XvjnOgevMa0NXz4PqV+2rB2akAteCjI7RS+Vf2OqAJnSTefHzVgj2J4zOJIFtTZLC8RyEbtLSsMhaX0aSUaS8ZSEM86bYkYtkF8gBIoaZho9iX3sWIacogwFpoYGgDRvN6IbTzWOOXSq+cY5lj3GS/NfQSJLSdbq0ZeCQMCX6rkROnx2goyGL8qMPGX8TwEBgl4wcoBPQgZ6esRCLWy7ZoKIRtat0aWnCaXdZ0byRIEunrHqZGdAK1zDegZsyyS62i+3u2AaEb91dRWyQPPAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Make gmem_in_place_conversion a module parameter so that userspace can
> configure enable or disable the use of VM-level memory attributes. The
> module parameter is only available if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is
> enabled.
> 
> To avoid inconsistencies in the way memory attributes are tracked in KVM
> and guest_memfd, the vm_memory_attributes module_param is made

The description is stale, since there is no module_param called
vm_memory_attributes?

> read-only (0444).
> 
> Since selecting CONFIG_KVM_VM_MEMORY_ATTRIBUTES disables in-place
> conversion, 

"selecting CONFIG_KVM_VM_MEMORY_ATTRIBUTES" doesn't necessarily disable
in-place conversion, it also depends on the setting of
gmem_in_place_conversion.
To be accurate, maybe add "by default"?

actually make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable. Make
> the config only selectable for (CoCo) VM types that might use
> vm_memory_attributes.
> 
> Since memory attributes are trackable in guest_memfd, the concept of having
> private memory is no longer dependent on
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES. Define kvm_arch_has_private_mem() based on
> platform config, so that having private memory is dependent on (CoCo) VM
> type.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> [Define module_param only if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is enabled]
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 +++-
>  arch/x86/kvm/Kconfig            | 14 ++++++++++----
>  virt/kvm/kvm_main.c             |  5 ++++-
>  3 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 497da6aaf2942..bb2c1ade62cf9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1851,7 +1851,9 @@ enum kvm_intr_type {
>  	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
>  	 (!!in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
>  
> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
> +    defined(CONFIG_KVM_INTEL_TDX) ||		\
> +    defined(CONFIG_KVM_AMD_SEV)
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #endif
>  
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index abb108886733a..2c3c22aeafa54 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -81,13 +81,21 @@ config KVM_WERROR
>  	  If in doubt, say "N".
>  
>  config KVM_VM_MEMORY_ATTRIBUTES
> -	bool
> +	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
> +	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
> +	help
> +	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
> +	  memory attributes.  Using per-VM attributes is deprecated in favor of
> +	  tracking PRIVATE state in guest_memfd.  Select this if you need to run
> +	  CoCo VMs using a VMM that doesn't support guest_memfd memory
> +	  attributes.
> +
> +	  If unsure, say N.
>  
>  config KVM_SW_PROTECTED_VM
>  	bool "Enable support for KVM software-protected VMs"
>  	depends on EXPERT
>  	depends on KVM_X86 && X86_64
> -	select KVM_VM_MEMORY_ATTRIBUTES
>  	help
>  	  Enable support for KVM software-protected VMs.  Currently, software-
>  	  protected VMs are purely a development and testing vehicle for
> @@ -138,7 +146,6 @@ config KVM_INTEL_TDX
>  	bool "Intel Trust Domain Extensions (TDX) support"
>  	default y
>  	depends on INTEL_TDX_HOST
> -	select KVM_VM_MEMORY_ATTRIBUTES
>  	select HAVE_KVM_ARCH_GMEM_POPULATE
>  	help
>  	  Provides support for launching Intel Trust Domain Extensions (TDX)
> @@ -162,7 +169,6 @@ config KVM_AMD_SEV
>  	depends on KVM_AMD && X86_64
>  	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>  	select ARCH_HAS_CC_PLATFORM
> -	select KVM_VM_MEMORY_ATTRIBUTES
>  	select HAVE_KVM_ARCH_GMEM_CONVERT
>  	select HAVE_KVM_ARCH_GMEM_RECLAIM
>  	select HAVE_KVM_ARCH_GMEM_INVALIDATE
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c8faf1cb82167..85dfc3f5af805 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -103,7 +103,10 @@ static bool __ro_after_init allow_unsafe_mappings;
>  module_param(allow_unsafe_mappings, bool, 0444);
>  
>  #ifdef kvm_arch_has_private_mem
> -bool __ro_after_init gmem_in_place_conversion = false;
> +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +module_param(gmem_in_place_conversion, bool, 0444);
> +#endif
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
>  #endif
>  
> 


