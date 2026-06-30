Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC1CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5716B00B0; Tue, 30 Jun 2026 06:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC2B6B00BF; Tue, 30 Jun 2026 06:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4DA6B00C2; Tue, 30 Jun 2026 06:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3F76B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:55:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 120791C3388
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:55:34 +0000 (UTC)
X-FDA: 84936272988.19.8BDE5E7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf16.hostedemail.com (Postfix) with ESMTP id A2D32180006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:55:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HU4nsEpy;
	spf=pass (imf16.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816931;
	b=ORr77qGGVpMUTgY1MJmAWYjQQEYnhlAimkOXf4nKqnjglGmGsJ3/K9FI+f6KXmAl+C00yJ
	NUlfJnzsTZkO/o4bvANM5JiLWfbey9ryG/2blUS0d1pxZQjKjrf2R0wHOdaTJKI0EK7t5j
	TVqdcpP0PmvjsGDv8Ab+WMYFc410as8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6O/KKbPhRO4ME+/g0zmg2cuKAbtwzkbNCMGa4wJcPDc=;
	b=LGQnQhRDmxbvUfNVjzbZX5OpOqs8932GqL+rFK3sl+i3dt2ESCq0ycTqKt0efgdoyAHO1z
	xqngmRx1zyLamLT7qPlJbxPHtoR6YuQKOBu3EwOYa97HTCIINVnU+C3viqUK6JMoI34o06
	SgKqSkggWbiLNRQ8EX4OBGPf5X8+gxA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HU4nsEpy;
	spf=pass (imf16.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782816932; x=1814352932;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OinqCn7yZwhhZsCKKCwIFGV4JtEuLIbKl0RX5IPXpt0=;
  b=HU4nsEpyZFVubkTkW/GtIp+Q6UfQRT/qtAsyb5s8qD5w8pnUWeFy/I5F
   jxtY8sU8I0YHRKK2orDN5Ej+HnRAOIRaBiUxYZhFfXCoppxV8+netiYmq
   XLpvfXByf3TKzDbKPHSEil7gNrWW6Xo6Lc5wE2oqXtNltBGjAhOwIL1Qn
   FvCEQyB1Lf0jEAiKK/qW96g0XXwNNXK2Z+Y7U7kNYl4xeat8cohBYmZ4M
   +wYeJGPsEHuLUCnjixDrhuhZrSjC0CGUa1NBvzdQYIl7gJ5Cp/A6a3p3w
   vKdvNCgYPkyifJPW2AHBVVMTOrkVp+AmFFgRi9mdQZMs0pllqP/CXuCbQ
   w==;
X-CSE-ConnectionGUID: gRvkvT+hT/Os4E73hH0U+g==
X-CSE-MsgGUID: Lkk7MzM5S/2R0PkuuqHPmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="94677496"
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="94677496"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 03:55:31 -0700
X-CSE-ConnectionGUID: QRJE9D0fTAuqi24otunImw==
X-CSE-MsgGUID: xXZpy8SqQASrfl6ZIk3hPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="290361286"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.239.158.70]) ([10.239.158.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 03:55:17 -0700
Message-ID: <39671141-d317-40ab-8c50-66252015514c@intel.com>
Date: Tue, 30 Jun 2026 18:55:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/46] KVM: Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 selectable
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-5-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-5-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ijgbz7mgytbmqyq3aers7nrcgof3tt53
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A2D32180006
X-HE-Tag: 1782816931-236827
X-HE-Meta: U2FsdGVkX1/alIiicVrkSPILbDpImYIVqK91LmuLKW7jw5lG/jGOOzwh7cILEzTfFgsPQuIAnQEtvHtp502AZmSbaZfGB78x3j2KeyEODrNFMn17JTioNxDqS0OBQ0uRQJZL8s+7QmaxMOfFqN9FHs9yXchPvOQEQHctjwkxjf0sxx3HxhXF6cBOnHm4dmRDPXuMDhF54a4Lwwy4PTf+P8IgL5u5MFqw0K9iQMzfxzCd/BJelKX69NT71ZcGnoLkYS7VYG/9zdg/DCgB216j0pMFs/EcZZqDs2J/uK923tmkX92akuJzC/7k5Vwj5R2EPA7EGKhvzL7djYFjDVbmXCrhRRhdVlJ/YkzXCASO/sr62UQiPShlmRJGujz3Cr/ehTZ8vfKZYD9WEuAaDxYO3j/dSDrmr5hZx7cD+VA10cmmuSx4IW4ibwKaO3NQk67EkrNCIc3kjA6hlPJ/XUl0JWnB0XrF+A4BbZ2u4i8a1o1UAqITO0g21IbRAYL9qRNnt0UtjdVMs672S884wZqPYrCvMEMGZCYFafXGux5wrsO/twBIjZ0Cn951O41viMy6qlzRSrOJB+wgrh3Xi5JE7v4oNz/7SMmpxDvnFR0w6O3WueNcoy4xQYBd152uhCQPvqe7RDcB4rCCp6tphfgBmiUWpLk9iO9LYcqNEfwKbVoWA5XnfRvp9SrrqKOt78uTMEIo3i8PK0LXnykUNfHCYyT+WWw9xPuDWdpkbUOQKy+Hq1DD6xSGA05Ov6xHSVhO8u/cfH/bUvYSVzzxKveXHBqLN7vPLceyhkUfHF9p4tr69IU690x6ZiyQLojc7NcB5C93rsZi7NMGQo1Zz3xZXZX0MKT5DOsLmz62Peoxl6o5Zbff80/BfXi+qgXqJ86Yr9b1Ih5Vmn6BXRPPrTyuzMlMgoEobVMT5Ff9bJGPD4eAARVQG/U8jmen/T+7WZqBLdqYex7MIXLIDe8sG60
 1szR6eDO
 O4FJLX5PYU13X1JscFbtkPQ38mbF+9HcxzkfhsJ1OQgOr0iN4C3sBnMpL47sjmeqA9xSqGDuJY/OmjEpbwzX7uB4jsGHRmerJFXKt/uuzMmUwA2rK1DbcUINNM98lNiZ0WWU4z7Wu893e0i038zzJ/VQF6Q5vub6wTzBJjIRCW+IpbrOi75/GzewAsy5BBnCjHX4BbvZ2Ev4jaqc5sfSvfTYC0hAe2yZtO6pqHrazfLopISPlaGr3QpVvCcRlhVx+5w4g4mc1eMEHzjePIhwhlU8+FYJ13o4FVpSIdz4wN8FrhGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable, only for (CoCo) VM types
> that might use vm_memory_attributes.
> 
> Also document CONFIG_KVM_VM_MEMORY_ATTRIBUTES to specifically be about the
> private/shared attribute.

I think this patch needs to be moved later after per-gmem shared/private 
attribute is implemented. Because so far, TDX/SEV indeed depend on 
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

Not to discuss if it makes sense to report TDX as supported VM TYPE when 
CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not enabled, this patch just fails 
the compilation when

   CONFIG_KVM_VM_MEMORY_ATTRIBUTES = n

and KVM_INTEL_TDX/KVM_AMD_SEV is enabled:

arch/x86/kvm/../../../virt/kvm/guest_memfd.c: In function 
‘__kvm_gmem_populate’:
arch/x86/kvm/../../../virt/kvm/guest_memfd.c:918:14: error: implicit 
declaration of function ‘kvm_range_has_memory_attributes’ 
[-Werror=implicit-function-declaration]
   918 |         if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
       |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/Kconfig | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 24f96396cfa1c..c28393dc664eb 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -81,13 +81,16 @@ config KVM_WERROR
>   	  If in doubt, say "N".
>   
>   config KVM_VM_MEMORY_ATTRIBUTES
> -	bool
> +	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
> +	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
> +	help
> +	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
> +	  memory attributes.
>   
>   config KVM_SW_PROTECTED_VM
>   	bool "Enable support for KVM software-protected VMs"
>   	depends on EXPERT
>   	depends on KVM_X86 && X86_64
> -	select KVM_VM_MEMORY_ATTRIBUTES
>   	help
>   	  Enable support for KVM software-protected VMs.  Currently, software-
>   	  protected VMs are purely a development and testing vehicle for
> @@ -138,7 +141,6 @@ config KVM_INTEL_TDX
>   	bool "Intel Trust Domain Extensions (TDX) support"
>   	default y
>   	depends on INTEL_TDX_HOST
> -	select KVM_VM_MEMORY_ATTRIBUTES
>   	select HAVE_KVM_ARCH_GMEM_POPULATE
>   	help
>   	  Provides support for launching Intel Trust Domain Extensions (TDX)
> @@ -162,7 +164,6 @@ config KVM_AMD_SEV
>   	depends on KVM_AMD && X86_64
>   	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>   	select ARCH_HAS_CC_PLATFORM
> -	select KVM_VM_MEMORY_ATTRIBUTES
>   	select HAVE_KVM_ARCH_GMEM_PREPARE
>   	select HAVE_KVM_ARCH_GMEM_INVALIDATE
>   	select HAVE_KVM_ARCH_GMEM_POPULATE
> 


