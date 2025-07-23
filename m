Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1D3C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FE36B00AA; Wed, 23 Jul 2025 09:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7736B00AB; Wed, 23 Jul 2025 09:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FCE76B00AC; Wed, 23 Jul 2025 09:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 904E66B00AA
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:06:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0960BAA1D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:06:37 +0000 (UTC)
X-FDA: 83695553634.01.15C162F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0C02EA0014
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:06:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MWJbRehx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753275995; a=rsa-sha256;
	cv=none;
	b=QwBe1trs7+9EcvGJh0RwBCD5gpIiGUEYMvIPVajK4/NdRF5kq6mU9cCbK9yUdIV+l7l74s
	ozkMejFAmL6xfMv2VAJHw6DD+vU6cqEB9qGMDjOjzySihRhJvxXRsrH7no4TAJz2R34dE1
	yP8GkwmxUvfqj1lkWfvsVph3AG2LcHw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MWJbRehx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753275995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QeIZDkG0RwEOIGFNWmIqmvW1q/UYpjnFfkt2zqeXRrA=;
	b=D8O7b+td+IBId5om9SquWc/BLZrYSN9niuQJ85wNdOjhpvbJz2az7cijSC+52W0WFQJqi/
	kouUrhRKoDjeuY5WexKtKSG+vS+zQaYwcSBaty/BhxuIHg3bsXYs+b1VKYDWOcmYIdBF0F
	ba8j51k26Ymnkhjh+xQk2n3f7XZAabQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753275995; x=1784811995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xpGnh9YJZRPC8hRQsB+1pAq5rzC1Pd9l2Hu5tdw8+wM=;
  b=MWJbRehxC+H2Lhq1nMJDf0/YAKEYLyx39MrOabx8Jnp0DXQSmOqzajxZ
   YexpkBFF8xFLSLwvfkAwHvebRcye1mbjSvEDyIHsncpC6+Ru2NOYaDiIR
   xRFus4gsaI/q/0K6GxM3H58x2xL+BOYPzKu5qqD0fnoZfOl/2kSvVhKFi
   43pMyYe7CR56s/NVEYgCVI93JP9Lmy8K0RhGOeKkkbeFcNO78oBCEOf+1
   tIVcJ1XwHUiwxtQ27C9Aq5GAxKsNwzUtP7OXRvrcPQr7QFr/PviKEMa9p
   FiKJuOb7JxIWkzunPZiADP3If4qqYYJsXpFBGgGgCQA/0wC/5G8+X+TR2
   w==;
X-CSE-ConnectionGUID: 6C5a7TOoRBKLxJAFM7SK+g==
X-CSE-MsgGUID: ge+eV1t2TEW+mnl/tLRxAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66898759"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="66898759"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:06:34 -0700
X-CSE-ConnectionGUID: o54KMjg3Q8eDVfJynjs12w==
X-CSE-MsgGUID: W8NbhIYWSAWyZKxaUBNBxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159157117"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:06:20 -0700
Message-ID: <18491db5-2e9b-4914-9464-87166a83ffde@intel.com>
Date: Wed, 23 Jul 2025 21:06:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 02/22] KVM: x86: Have all vendor neutral sub-configs
 depend on KVM_X86, not just KVM
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
 <20250723104714.1674617-3-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-3-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1ukoogk58161wh4ze8n1as1gas9fq843
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C02EA0014
X-Rspamd-Server: rspam02
X-HE-Tag: 1753275994-837131
X-HE-Meta: U2FsdGVkX198E4fXubJWIUSgxfILHkdNkPLkDp3vUZN3x5Cgk94NbN2sYs+6ansayhLro5GP5SiTzUSyxh8VNUF7E+2cHludtLkEjDL0DJeG+1tTareZFwbsNtENHJylazahGjJPD1KUschlM/QrVsaQsM3gio8kmAx9AhacrkRELIaLkNhYp065pnSBV8wKVEJcYLdkpBknQW+b9e2H0L20h/UqzrpWM+GbH0FAgRC5HTGzNGrHJwoWqvUQ1++jkeM/offlc5OvuguUHCByPc6xyTARoJ5vrCnnfckLrHMyzvYtQZGN2SqZ62lOXU4iKWSQITBH8fqbqBZrdSx86xe70wf9A1oI8zSNBicAUCkh9ZgU8rE/AyQoHmQMGJjl7dWkbK902xJsTgHqRLma5FN2ednOOJUe7wbThYYvPwrgT1KbbZ4a2+umnKBborMSYwWMIrSkbmylOfwdb1L5Xg0EBBgAYAJkPNKQ8FHuhxA1022vs8g5VH91skOECj4EbliUbidNWjJ1HeyrCkFHutslqNv7fL+YpQ02EBS15aDzksqhwZU27uvjbaxAeWnlp/6Rd1kVzGqv0711dDsPF+Nn8ISOxivHG82S6PzAAifvLMu7VLwbSlv0ZnlS9FrEy1l2RP0mobs/ghBwEc72VngsJSrIcBbz/nSNdb1xBcX8c1hBeBGUPoNMlFJPLuK+fIuS+m5Phuj6Za8V/OYzv8/EoquNba7A1O/IXOTrJyiffMw6Tf4pke7XrNIz4zym6Qec3AtKQacrFEvu4ryFSNngiYAtF8WZJnQM65GXmGKvkvg5VnAdfeFy8VxbkYTBQvHOVbFFDWzjF4pLmlz2qex3YFmP9SH3ekvymG9pNa2DDc4A+DdbPHfW5e261CpkT60s99IUWA2KrMt3RaaKSr3+5JE0qtHsw93A1O+/QNFj/UROQPrXeUp94/SkKwrd1971iik11hyn7+EMOO4
 4t3mEbIU
 CtT3SHfV4FfJqT+POKDljDtXHoVb6NdJOchkBOgt3gJPACEDScbGRADrk2j0FpTjAANvlrPybfqw+b0PHJcffCbkMmKKf7gw3uKfuvACCJ/CNh424MVQU3bBxlnbzwzc/RA1COeTnB3E9Fv12inFX6YSqJKxF9KsamDX48a805npRgAtvgeN78HqC31u+rUK2r2vg8RExZLS3TMcpsggWNZTxYmH3AmGPoSjYvh52TZr9l7Fs1twFze2SG1NBvK/n28kfAYOpwZxpV+9UP6mtIUY9Hhf/eXsuJScDYju5lIY/PGW0gkU8X7cUa8JDo1Bg/QgE0Y3B3QBSjoJXmNYnYNKWLFL+qm2ILPouEUhqkQ9i+ooY3N/m8am/znG2RmsEKwQ/53Y45IfOzsX4nXuzxQ0qEw==
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
> Make all vendor neutral KVM x86 configs depend on KVM_X86, not just KVM,
> i.e. gate them on at least one vendor module being enabled and thus on
> kvm.ko actually being built.  Depending on just KVM allows the user to
> select the configs even though they won't actually take effect, and more
> importantly, makes it all too easy to create unmet dependencies.  E.g.
> KVM_GENERIC_PRIVATE_MEM can't be selected by KVM_SW_PROTECTED_VM, because
> the KVM_GENERIC_MMU_NOTIFIER dependency is select by KVM_X86.
> 
> Hiding all sub-configs when neither KVM_AMD nor KVM_INTEL is selected also
> helps communicate to the user that nothing "interesting" is going on, e.g.
> 
>    --- Virtualization
>    <M>   Kernel-based Virtual Machine (KVM) support
>    < >   KVM for Intel (and compatible) processors support
>    < >   KVM for AMD processors support

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/kvm/Kconfig | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 2c86673155c9..9895fc3cd901 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -74,7 +74,7 @@ config KVM_WERROR
>   	# FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
>   	# Building KVM with -Werror and KASAN is still doable via enabling
>   	# the kernel-wide WERROR=y.
> -	depends on KVM && ((EXPERT && !KASAN) || WERROR)
> +	depends on KVM_X86 && ((EXPERT && !KASAN) || WERROR)
>   	help
>   	  Add -Werror to the build flags for KVM.
>   
> @@ -83,7 +83,7 @@ config KVM_WERROR
>   config KVM_SW_PROTECTED_VM
>   	bool "Enable support for KVM software-protected VMs"
>   	depends on EXPERT
> -	depends on KVM && X86_64
> +	depends on KVM_X86 && X86_64
>   	help
>   	  Enable support for KVM software-protected VMs.  Currently, software-
>   	  protected VMs are purely a development and testing vehicle for
> @@ -169,7 +169,7 @@ config KVM_AMD_SEV
>   config KVM_IOAPIC
>   	bool "I/O APIC, PIC, and PIT emulation"
>   	default y
> -	depends on KVM
> +	depends on KVM_X86
>   	help
>   	  Provides support for KVM to emulate an I/O APIC, PIC, and PIT, i.e.
>   	  for full in-kernel APIC emulation.
> @@ -179,7 +179,7 @@ config KVM_IOAPIC
>   config KVM_SMM
>   	bool "System Management Mode emulation"
>   	default y
> -	depends on KVM
> +	depends on KVM_X86
>   	help
>   	  Provides support for KVM to emulate System Management Mode (SMM)
>   	  in virtual machines.  This can be used by the virtual machine
> @@ -189,7 +189,7 @@ config KVM_SMM
>   
>   config KVM_HYPERV
>   	bool "Support for Microsoft Hyper-V emulation"
> -	depends on KVM
> +	depends on KVM_X86
>   	default y
>   	help
>   	  Provides KVM support for emulating Microsoft Hyper-V.  This allows KVM
> @@ -203,7 +203,7 @@ config KVM_HYPERV
>   
>   config KVM_XEN
>   	bool "Support for Xen hypercall interface"
> -	depends on KVM
> +	depends on KVM_X86
>   	help
>   	  Provides KVM support for the hosting Xen HVM guests and
>   	  passing Xen hypercalls to userspace.
> @@ -213,7 +213,7 @@ config KVM_XEN
>   config KVM_PROVE_MMU
>   	bool "Prove KVM MMU correctness"
>   	depends on DEBUG_KERNEL
> -	depends on KVM
> +	depends on KVM_X86
>   	depends on EXPERT
>   	help
>   	  Enables runtime assertions in KVM's MMU that are too costly to enable
> @@ -228,7 +228,7 @@ config KVM_EXTERNAL_WRITE_TRACKING
>   
>   config KVM_MAX_NR_VCPUS
>   	int "Maximum number of vCPUs per KVM guest"
> -	depends on KVM
> +	depends on KVM_X86
>   	range 1024 4096
>   	default 4096 if MAXSMP
>   	default 1024


