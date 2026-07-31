Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA54C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2DAB6B00CE; Fri, 31 Jul 2026 04:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF0D6B00CF; Fri, 31 Jul 2026 04:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4906B00D0; Fri, 31 Jul 2026 04:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2166B00CE
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:48:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17B4F1A0370
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:48:56 +0000 (UTC)
X-FDA: 85048446672.02.A96FD10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf16.hostedemail.com (Postfix) with ESMTP id C1C5C180006
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:48:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bVQWvKQJ;
	spf=pass (imf16.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785487734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4xreLdHalJRb94aukDrLwoFtKVRR50G0bMgELuvhUY=;
	b=74ieSwD5CQLFyqcmj9oWjACkjzGa5/rdnWth8dJGwrNR+Ko88oBdV8jSDWGFs+Rj4VFO1Y
	BhWdvO9/9fyAWC0S0dDOz4tFxgbAXXsyBjQabhySWCxTxSJ0XzprOze6eCg8+g6dlZ3qTF
	bPizEFd84EcASt3GU5/pj1CSCkKkUTw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785487734;
	b=gVHL6AJn5l51LlGOcmiMr3xMu53Bk5MatMusn9Pt21cfqdqUa3405SX5CuJOXCI2HiO7vz
	PVF+yD0M98TwOnKi1Yf1xJN5gLvzW+ajSvhQX2W4rcIzAaoAF46GZ4tXgqw04SgP1DxI+1
	XRsaQ5d5rhYopW4jsNnb6VC4q5I26iE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bVQWvKQJ;
	spf=pass (imf16.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785487733; x=1817023733;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HUslESBRwUMZ0nIYtDZHqU/vSK5vrxqzYKo2GaPJ8E4=;
  b=bVQWvKQJ/9EOM5QWnt56uQ/CdnC/FbpVq7PPfQJdX/FgAdKXWDko2mfq
   HaJOULV5La10UcitbnHe6ey14V5/pWlf6e4I01KThEZtxLvXwO+rVk/g0
   kXDZac+6zAUHeCYx+v005Yw3ZNGRmYSY503rzWuOaQU4KcEmylUVDcqHA
   DfrzZ8kNV9s3FxLf3pa5/Fmh9vjvKoBmAT+kQLF8DlXaWgQMHMF6/RnWe
   KSzpBu36gxIBtw44HVozyR7HDBDwKpowg3d5ESOzx+tUzRQYaQ9IvXzfQ
   Jnwv8VRSx3L/JTIwW4wGKrrTrUnKlVCdSiLBeXog3IbPGv5PnEGRcuxh4
   w==;
X-CSE-ConnectionGUID: 0pI5h2alSSu5ytSa8Jw78w==
X-CSE-MsgGUID: EU8WDN++RcKNco29SKwkGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="86062841"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="86062841"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 01:48:51 -0700
X-CSE-ConnectionGUID: u7DGKLPZS/eJ51NjhAIFwA==
X-CSE-MsgGUID: ExP7CWv0QIW+0DfJQgeuiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="262491487"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.248]) ([10.124.240.248])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 01:48:35 -0700
Message-ID: <7f23d149-b7f0-465a-a9c0-5c7484e289d2@intel.com>
Date: Fri, 31 Jul 2026 16:48:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 20/41] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-20-35f9aec2aed2@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-20-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C1C5C180006
X-Stat-Signature: kpxqxmyoydofqriih4qbxdonoee9xnfx
X-HE-Tag: 1785487732-112563
X-HE-Meta: U2FsdGVkX19wuMN64+cf04B5zEMj62g18o9tzACQu5o5ssdy/subUmQ6NRXQ6U6eHzfhNI/IUV+leNpH0lqGkJcBrB6p5TCKpw35UTPWnFrFWBDrYVUeYTbN5viGIm7EEt3omJHJ7vvd22k8BJ+tL7EEN7MNVaqoXCqPNnkXUaLbCaFrFJabnH8NtCth7Vn5NgvamNi1R0ixXeNvJyLRI5p0YFV4zFshSJbgXsDVEHQq1mvCB1GeVmrCYPgKvg78qTBdF34G9DGjZskdGLFde0FbgGNu/pGY78hna5xaCFzSPlXbrC8PteMhF5p7XWsZgvmynnJqZBu2fH8IiFNcH53lWqgWtuca/FkkWxlwmHyVPsCd5aYUNaEFXDETRqNzLP38g9lQOUBpepToh7545/kjqpYB1ZVltLdiPpbmb9Yxt8htLDP2YdkrEJQZ6TvFC9rTXwP/pCKpDK8qSU/Ib6W5Q89VSg5IShsRdbysqXxXE/eHDY/XBmUv0hj1GCALcURU3kNMO9dEOkarphLX69HoYWK+kI0R207Cw5WH99vm71IBNXK0ycrd6m34qD3ogJhW+2T5kA6MT996f11IHx6Xp1ywfDvJQQTD9onzgwfeF9dUf+Udz53hrRnIYZGYPct7+YSlgoT01WLiw2hewIGlIm/avbnHeVGQKRBp++rNnUS9MpHqGPmfIdBOImF00BtLbMK2n9PzOdIGr1Ps2Mnu2uiPni8kxzdSIbxtwIJde8ozqsAKv9OJ5rNu+zdsr4h9xAt65z0mBQQu1Rp++UVYi0s/Ao4EM8LBKCS1ox3hILh51/tKafJndbyg4SkEdlk1eulXBcRRb/OuholDpyLflQgsbbnI49zZZf+W8Uets7qtYBpnDCpkoN9QG/PxWPmPHc6Tk5oCmNWHnySgwfS7Karjirc+rucVhXLOE4C4YStnfBRE+UwNPemQlYEpn7qWPEdZcHWtaUEQz6w
 TyEMTFFx
 fIyL74gYjBh7ek60dj0lwzyFplSYFwBPdWcmP0DO0xyWxjWh+5Zgr+SXUnYXwgXuB/y2TG0hoHbeRpp3W8v2G0XJYBd1Zho59tnE8GbyMF92JI/0uLTDwJyyTgOmvQ5BsBVdgqbJpG0o6oPuQfG/aI1JhL5KHjbCmQwDu8i41Qvhvsr+jnDsJMGMX400wYhpm97+lChEkAgCQtq2REgf6uXVlTqNoy22+ZqFOHfBeVtQmuq8RMXTlxjl8Iid7pMh8yYHigjQvMn2G6/JT25SJIQuTEQ+Y3rKCHkCuBDY/8WLsNVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Make gmem_in_place_conversion a module parameter so that userspace can
> configure enable or disable the use of VM-level memory attributes. The
> module parameter is only available if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is
> enabled.
> 
> To avoid inconsistencies in the way memory attributes are tracked in KVM
> and guest_memfd, the vm_memory_attributes module_param is made
> read-only (0444).
> 
> Since selecting CONFIG_KVM_VM_MEMORY_ATTRIBUTES disables in-place
> conversion, actually make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable. Make
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
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  4 +++-
>   arch/x86/kvm/Kconfig            | 14 ++++++++++----
>   virt/kvm/guest_memfd.c          |  2 ++
>   virt/kvm/kvm_main.c             |  5 ++++-
>   4 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ceb2abf43b76f..766eb094eaae6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1849,7 +1849,9 @@ enum kvm_intr_type {
>   	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
>   	 (!!in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
>   
> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
> +    defined(CONFIG_KVM_INTEL_TDX) ||		\
> +    defined(CONFIG_KVM_AMD_SEV)
>   #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>   #endif
>   
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index abb108886733a..2c3c22aeafa54 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -81,13 +81,21 @@ config KVM_WERROR
>   	  If in doubt, say "N".
>   
>   config KVM_VM_MEMORY_ATTRIBUTES
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
>   config KVM_SW_PROTECTED_VM
>   	bool "Enable support for KVM software-protected VMs"
>   	depends on EXPERT
>   	depends on KVM_X86 && X86_64
> -	select KVM_VM_MEMORY_ATTRIBUTES
>   	help
>   	  Enable support for KVM software-protected VMs.  Currently, software-
>   	  protected VMs are purely a development and testing vehicle for
> @@ -138,7 +146,6 @@ config KVM_INTEL_TDX
>   	bool "Intel Trust Domain Extensions (TDX) support"
>   	default y
>   	depends on INTEL_TDX_HOST
> -	select KVM_VM_MEMORY_ATTRIBUTES
>   	select HAVE_KVM_ARCH_GMEM_POPULATE
>   	help
>   	  Provides support for launching Intel Trust Domain Extensions (TDX)
> @@ -162,7 +169,6 @@ config KVM_AMD_SEV
>   	depends on KVM_AMD && X86_64
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>   	select ARCH_HAS_CC_PLATFORM
> -	select KVM_VM_MEMORY_ATTRIBUTES
>   	select HAVE_KVM_ARCH_GMEM_CONVERT
>   	select HAVE_KVM_ARCH_GMEM_RECLAIM
>   	select HAVE_KVM_ARCH_GMEM_INVALIDATE
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index ea2752989f8bd..df67a6188aa99 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1137,10 +1137,12 @@ static bool kvm_range_is_private(struct file *file, pgoff_t index,
>   {
>   	struct inode *inode = file_inode(file);
>   
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>   	if (!gmem_in_place_conversion)
>   		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>   							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
>   							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +#endif
>   
>   	return kvm_gmem_range_has_attributes(inode, index, nr_pages,
>   					     KVM_MEMORY_ATTRIBUTE_PRIVATE);

With my suggestion[1] on patch 7, this diff block can be dropped.

[1] 
https://lore.kernel.org/all/dd4201f2-3660-46ad-958f-c70feb1ab1c3@intel.com/

The code looks good to me,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e961cc297ba2a..eb9f433278d2f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -102,7 +102,10 @@ static bool __ro_after_init allow_unsafe_mappings;
>   module_param(allow_unsafe_mappings, bool, 0444);
>   
>   #ifdef kvm_arch_has_private_mem
> -bool __ro_after_init gmem_in_place_conversion = false;
> +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +module_param(gmem_in_place_conversion, bool, 0444);
> +#endif
>   EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
>   #endif
>   
> 


