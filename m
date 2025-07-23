Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8501C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF718E0020; Wed, 23 Jul 2025 09:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C72D8E0002; Wed, 23 Jul 2025 09:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404458E0020; Wed, 23 Jul 2025 09:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 310248E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:22:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E34C51A0705
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:22:46 +0000 (UTC)
X-FDA: 83695594332.28.642A7CF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf20.hostedemail.com (Postfix) with ESMTP id 095C51C0012
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:22:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gsxQXdwk;
	spf=pass (imf20.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753276964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RiDWnNm27+dtOtGtdqA2y2MG8Xa5PWwHk3kN+Ts2nDE=;
	b=7ETZu/Y+BisaN5cUzMksb1DOhYKYX4QdVIENZVHioTuVrrlOrorbzdqK3xG3rB59E7LACx
	OIm+in1xGBHHxnfNGdUU4Ty0S5T3RxhUOVSABnkwwEfRix71bBiSPdPJJ5N5Vn30KNWlXL
	Jfy/N63QFYyhQ7CZGqQpkWGBB6UlFQ8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gsxQXdwk;
	spf=pass (imf20.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753276964; a=rsa-sha256;
	cv=none;
	b=DDLYtZS9U/TAr//nDTg7gHwSaUqi/Jj60jH+K8iyQBud5xSuSOGYvr+bhnuFbGxsqux4r4
	rpNH7m7PP51l3J8J9swalvHRdjSQ3BqXvc1zSGpYmWo01cvyZF77AjYBjhBoQdLq0pQ3mw
	6c+PrhGIV7M/1eulLoakZVCq7XvDnyk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753276964; x=1784812964;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lZwfTjcBodcwPNMmYFfMC7xLDkXH128h6IWYxQF0jWM=;
  b=gsxQXdwkv4pj2Mj+sK8gAaOJ28yFpaZ6/F+SJUHMp4sSjWJS6zoxorwh
   X/rB2K+uNg54U8zuJJRYTIG92N8S1XoFl4dFAGg+px86nE/M4Dqlpts6e
   W+YP4hWrKEtbWaGSS2FlgyMO1zuCaHrartuHppXg54VSHXVK3/gDsYQBa
   i3qlbk748NTczXncKqxDgfS/NAWainLA+5CGA07K1Qnibej0sIxJEdC/0
   +tJzNKZaIwBdUs0Sfi1LFXYbYzX7ArQ7vuXwZfi+RGHa7cXSP1vPDmcBV
   TajGjnkKNEklI055ZPw4G176Ecf6Qb+ze6YtRLsUBXJew9SO02W6NU9Kj
   g==;
X-CSE-ConnectionGUID: mKistkfqR1Cx/HxOZT3V6w==
X-CSE-MsgGUID: KWULeRMmTUinR3ZLBEp9YA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55263682"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55263682"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:22:43 -0700
X-CSE-ConnectionGUID: 7nYSh/4eTv2bYoGNAVW/Bw==
X-CSE-MsgGUID: zU8D2+MbRPm4bAv5IqzQBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159528654"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:22:29 -0700
Message-ID: <3f337306-e79f-4ac7-bb86-60b88b262e88@intel.com>
Date: Wed, 23 Jul 2025 21:22:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 04/22] KVM: x86: Select TDX's KVM_GENERIC_xxx
 dependencies iff CONFIG_KVM_INTEL_TDX=y
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
 <20250723104714.1674617-5-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-5-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zpuqtubh9qhe8bn7jund83u7o3mfucp8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 095C51C0012
X-Rspam-User: 
X-HE-Tag: 1753276963-82041
X-HE-Meta: U2FsdGVkX19Yn+MXvuKPILPcIXUq8lAHH0KyS3prV2ZR5LvwTc59znTb22fjoUrN7smcC9SNsRwXzjr8OiXLpRBHYnSJlnLieRgQWRCNpaaFtOKtz9MoEtAc0hta20F1rwDy9NARqjbDR830oWSgmGCjglznD9ViiW5O6BYcTXPmBHNxVNkDjbuZbmCq8pf4atAcVwl+BN4dDuHizsJnANCwB9pOZIda6BZ2rnSagLz1UqirS9+t6G++FerFaymxkzqtDWPmwD2a6DtjtnBe8KDrq5PMitkqICgPuH7dvNxzWgvmFZm5bW1I+4Uy4bBoxyMl1W0AVcY/AuaXnnotnJM4XXfOvnjpzBtZwgpc6MhZUTlwCQFDFMj+Juq/BN1Hv79t4rN/oOKku/G3a7BFmoBoOkFA4A11ZwHMk4AhO9hf/LpIb13u7BJLKHkr4vvBNsAi6bdHE807ItT1Tn2dcCf6GSCthp6TbDsj52EFts2xZhNGQ28EH1QqIJx26ITP/1qZmQVRI5d/DeBvX5MQW4gssLI5SennnSgaYbLBOeUalKFTSeBYMTWeaIQbjbNmxoEKiMFV/eny2FjmGXbqI2u4Nnfmq9zTThpd9iYW0+YjMW/lgoKz7F6etyBVnSyVe8P+JCLxRxtiKRH7oK/uJBv8AhUxB0A8AdLDZunUPtV4yTApdc4lRfykCMYf1zjZZerWNzf0O3x6KyzTjecJlHS42Mp91CIMr8b2YLBdqYEOSD00UuT7NraI3e53MFj5yC+MmDe73wwcvy4yb+nPMV+ja4ydd9vtTux/BY0YWdZT5KL5s0IE/8RpVTP8BZFXxPnqpyrAR1z9BpgjmAScT/okPoMPbdRaH7dDjZ2YTvW18H9v0eh+7VVVLOHdj1FFbXqRT/+vtDOoxj6svIcOJueOGpNxA9rRekDvyu8svE/g4rU5Yxn7LYydCf5uuM9YseHrcBQqwprqocuelhK
 Lc+4c+rC
 2zQLLCklrUXArCJjkKxpihhfl+Bhp01tQq1LDjT/5ONSkZeP6t65NyxocO9C8YoU95SleTHQLo49mYsxKYPWuDEqnTrC9rG26DoZna2G/7qpzd5ZduubFTGK6iDOIIoOLdn3chE1GDd1CD3kMXTsVkcIhBksFJg7noGDLWVY2AeMv466rOsjNuKgPlaAW5ycVhxnN91uPkWw8Fk72pbNLR4Aw2yDEd8lgKsZ2dkzcYF69v8NLm8M0JGPZL0h7PjpqdMUCyhDD0VPQS/EPuxSoHyatmkbuRVY17G2Enh0RRM4ypaYrFHw/PaBQUd/F7CSz3vtki59eYrfDyydCCBEJZZRb7QaG1/f6WQYT+atmvF5+AsM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/2025 6:46 PM, Fuad Tabba wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
> from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
> KVM.  There is no need to enable KVM's private memory support just because
> the core kernel's INTEL_TDX_HOST is enabled.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/Kconfig | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 402ba00fdf45..13ab7265b505 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -95,8 +95,6 @@ config KVM_SW_PROTECTED_VM
>   config KVM_INTEL
>   	tristate "KVM for Intel (and compatible) processors support"
>   	depends on KVM && IA32_FEAT_CTL
> -	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
> -	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
>   	help
>   	  Provides support for KVM on processors equipped with Intel's VT
>   	  extensions, a.k.a. Virtual Machine Extensions (VMX).
> @@ -135,6 +133,8 @@ config KVM_INTEL_TDX
>   	bool "Intel Trust Domain Extensions (TDX) support"
>   	default y
>   	depends on INTEL_TDX_HOST
> +	select KVM_GENERIC_PRIVATE_MEM
> +	select KVM_GENERIC_MEMORY_ATTRIBUTES

I had a similar patch internally, while my version doesn't select 
KVM_GENERIC_MEMORY_ATTRIBUTES here since it's selected by 
KVM_GENERIC_PRIVATE_MEM.

Anyway, next patch clean it up as well.

>   	help
>   	  Provides support for launching Intel Trust Domain Extensions (TDX)
>   	  confidential VMs on Intel processors.


