Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F072C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 05:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7556B02E1; Fri, 14 Aug 2026 01:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FCF6B02E6; Fri, 14 Aug 2026 01:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0679C6B02E7; Fri, 14 Aug 2026 01:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF3226B02E1
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:58:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2DB00120357
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:58:16 +0000 (UTC)
X-FDA: 85098819792.02.49202EA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id 155DA40005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:58:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Enqwr2mb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786687094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVZd2LmhNqXCc70yfJNOOAQV141QuGsFpAbHyxz92lo=;
	b=ikQ8PdnKGWEWuevzqrO+jXXJJBxNFdVFEfBn49Rlgenqq+LSZpAPixXw6Yzeg3fZhS9bJ8
	3KMK3qxzpYDbeLzDznTXYQUtUJ96046f0p0SqTlhwlRRXtNZ2Z9B6HZVxlbXVMgtdnvwoj
	jdUPA0sP9NFTLdqk0Rs8ssgoHVXRumQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Enqwr2mb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786687094;
	b=kMEH/MmYJmNDjrKO4lwx1oC/YGCMXEG6iVTxyPcmGCJInV6Hu2NgewXI5ayJT2qgx67W7D
	8PZonkZE5ib+te/pUnV2FPgJ/BPGQKDRvXnNccyEyBWQAhLHalQgSPLVrTiU4EJcQ+gH60
	RTWGQhMIbSUJipiarhFuCzUrtjO7BKU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786687093; x=1818223093;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QC5S96Wlg2aYg9zmHkHBo/+oJKFdCtwv78fz5ZqTCcY=;
  b=Enqwr2mb+vwBnJVgQ1LZlMqBXuJrqRMDp4UjsMCmfGT1q6Nn9U/+QzdN
   EMrn2ABiS7Ky2W3aXUnOghAL4W3Abykx98zTBzsU0dcts2W5of6F5LOG9
   wylASDkjULYU/YTLTRk4XqZzMtVuIpBvyGshQ4ILYpuQ7t8Bhs1+VCuIC
   4rBVxST3Xjc+F2x2DplMpMBabVuU+QA33EEjgeWIoJpv56ccfdtVi7OYF
   DRonHhLoV0eEWsINh2Hur6ZO9oGyh5XsYSgtXfpj5OnKYJCCQS3v19IbM
   FY6BdD2G68TVKl4h74AUiO0IGe0fizKodGwb4i9ipLscdXNF1Q5Ax+H3w
   Q==;
X-CSE-ConnectionGUID: FN75dfaOTJeoky/0PB8k8Q==
X-CSE-MsgGUID: iXAbLythT7CDxnm+AHx0UQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="110053718"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="110053718"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 22:58:11 -0700
X-CSE-ConnectionGUID: cUW8aUaXR5u17W+d+k7SFQ==
X-CSE-MsgGUID: D9N+GuVcQ1SFu1yh9D48qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="257921021"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.245.162]) ([10.124.245.162])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 22:57:57 -0700
Message-ID: <36baf0ec-0b7c-4ffd-9a1e-dfe9617e057d@linux.intel.com>
Date: Fri, 14 Aug 2026 13:57:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 18/41] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
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
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-18-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-18-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 155DA40005
X-Rspamd-Server: rspam07
X-Stat-Signature: 3wh7uicmug9hz8cryerjups3j5gf7k4p
X-HE-Tag: 1786687092-138055
X-HE-Meta: U2FsdGVkX199nrWHIhHl9TqVpOiplyzI/94PgcbmibLHyKqv3nZE25SeP5mSgn/KRJjBfYv8Ie3y3+2d0i7iFxrC6HlI6pvA97wPmyl8QacI70zm3mbKSHrwKNqMlZErN4zEdj+poEGg3aeHTuC8uVm8jSjP7S3dC5KyHrtz4zHmuq0V3XyDYAoJKhw8a4q0ZpmAu1hIECmJVoO0Uw/mucIydtvVme48MJNxM/Bg+Urqj0uRMwlPED6jRJitYOyrnn65Bge8qVmL60opC11zOdsjjWfWpIt9SwVoA0UVHAP8xfg5H9kxO8OD4PlvOZ7o3XsigIF3afrkKRy6MeHUtOkJNpfNCeesbg6jt7+VyrFhJjQZn12rgzfQcAnsVx7k+IUmRogIxK4St5dImWUCU6qdpbRi22aqgxe5TLF43mi/1aDgPkXXkRW9fPwN9zUPbj85DexsT8Iyx2pqTqC+Q5AVoZWor7bUR5mHad+xITvItU+PKcIAVbbhcB2Dkuweo/IVSy6RliNMrl3vZhC73NJc8QwJXkyFKQ7arorC5uqaei/UYQKTyTwbtHRFokqeoc48iF3PVFHRQCHegVlMblEvEAnN+hhK/jF1khcyfEGYTwZMe0RtTiarkJ0tpVu56Om47l2/KIgN7cSQBMk/aDeNgCPWOpeWcbNaE1yu5kk0vIMOb6XHgnUpw/6MDnyWOZRR5J+F8/5G9LgbXn18l/VNH7DvyiTjYtS5zlvWWFNlSJXAQqYqPstTJsVcnIAaXE4zZJoY3mara+/CEIVfB5DnaRVm/IXVg6sD1HpG2wwbKevh30lAyj7QAx8O6e5DbuCtDXMmvgQtg59+LgWpBGbcQvS8iEAvDfycwcMI/ipNL0B6RJCwA8v0y3JLqn8xDH4dOYH2OZyEXgjlje2MTm5HM9EnTUGr36rjO9xyRnt7vBWCNuRXkushjZxQhOfaThqi2rHsy101i5449mp
 UVvGddan
 nsPsjXQ3qPv8vUykBtnXqy8L9nOT2ga/luWjfHH5yFsDT47vBHQx7aSFqM5fK3lJMjYg0DCBGrY/rVwvebrFafD+hL4x5QtsfeBsIcP3ycKzpP6hxpBjCMBnjiDW/RwMr1QTSu8GkojmckueeBpa3E5ekbGJRrGT2Vuy/nLAAnEAfysJrR3v3+am3aoHXXcjSxYKTanfCH2fOw9h9KDEw2KfOM3Bni2e6d2cEwHCKJKtV6ZEPtsCoQt0wxIkcMCThlzFUv3EFanieLKPpd1LgZwHB6WdJrp3YOSOieRBPCzM2zZxz02QMEZ6Kg3ATRc0d8wDO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Update tdx_gmem_post_populate() to handle cases where userspace requests
> "no source page". To handle "no source page", populate (perform
> TDH.MEM.PAGE.ADD) using memory in-place at the target PFN.
> 
> Allow "no source page" only when gmem_in_place_conversion is enabled,
> because retroactively adding support for out-of-place conversion would mean
> requiring a userspace update for a feature that's being deprecated.
> 
> Also, KVM supporting "no source page" without in-place conversion would
> effectively be an obscure zero-page optimization that relies on the page
> being zeroed when it is allocated by guest_memfd.
> 
> Rejecting "no source page" without in-place conversion scenario is valuable
> for KVM developers since it helps newcomers understand what exactly is and
> isn't possible.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Nit:
Is Sean's SoB intentional here?

> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by:Binbin Wu <binbin.wu@linux.intel.com>

> ---
>  Documentation/virt/kvm/x86/intel-tdx.rst | 4 ++++
>  arch/x86/kvm/vmx/tdx.c                   | 8 +++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> index 6a222e9d09541..d8d9409120e61 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
>  Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
>  provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
>  
> +If guest_memfd in-place conversion is enabled, pass 0 for @source_addr
> +to represent "no source page". A source page is required if in-place
> +conversion is not enabled or not supported.
> +
>  Note, before calling this sub command, memory attribute of the range
>  [gpa, gpa + nr_pages] needs to be private.  Userspace can use
>  KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b272c20586a74..7654a9f5fa128 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3189,7 +3189,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>  		return -EIO;
>  
> -	kvm_tdx->page_add_src = src_page;
> +	kvm_tdx->page_add_src = src_page ?: pfn_to_page(pfn);
>  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
>  	kvm_tdx->page_add_src = NULL;
>  
> @@ -3235,7 +3235,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>  	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
>  		return -EFAULT;
>  
> -	if (!PAGE_ALIGNED(region.source_addr) || !region.source_addr ||
> +	if (!PAGE_ALIGNED(region.source_addr) ||
> +	    (!gmem_in_place_conversion && !region.source_addr) ||
>  	    !PAGE_ALIGNED(region.gpa) || !region.nr_pages ||
>  	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
>  	    !vt_is_tdx_private_gpa(kvm, region.gpa) ||
> @@ -3266,7 +3267,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>  			break;
>  		}
>  
> -		region.source_addr += PAGE_SIZE;
> +		if (region.source_addr)
> +			region.source_addr += PAGE_SIZE;
>  		region.gpa += PAGE_SIZE;
>  		region.nr_pages--;
>  
> 


