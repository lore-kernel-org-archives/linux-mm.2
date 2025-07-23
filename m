Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD8DC83F34
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4816B009F; Wed, 23 Jul 2025 09:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385336B00A2; Wed, 23 Jul 2025 09:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29B376B00A4; Wed, 23 Jul 2025 09:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA826B009F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:18:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C37EF806ED
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:18:15 +0000 (UTC)
X-FDA: 83695582950.10.53AD57C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf11.hostedemail.com (Postfix) with ESMTP id 26A0240003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:18:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PMXNajEv;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753276693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhiYwIebSeScAgaHKIQ/iBJqXSOJiOZNWDMEkjFvm64=;
	b=2NLNGLTxc7sOD48Q1hrD3tMPMD0jU10K6L1oqUVbNd/HFI6YXLWPEdyUsrr7VFQfZwjr3X
	YhcJ3n596WOzymDzq9Aplgdqv4ezzfxBRedWE4hO1z+BOJOksGFzTRE9qjejQQLe+4T+gW
	HnIt/yqtRotfGiFFinDL+LLdU4OYkEk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PMXNajEv;
	spf=pass (imf11.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753276693; a=rsa-sha256;
	cv=none;
	b=Z8wQPD1m29Ax4EA9lhPXB1RBs50uRBOq+bAXTZ2rPNIGUD+AeFcIec1fus8MSl4lZG8D9M
	bz85kUCyVLnpUipSzEYyUOMTl881BYdVDjSh33gmL9equBCZUUSmyjo9ovVrdZU6XMAEjz
	eN9bbS3vIJF4Bt8+OXvHp8Y1RIAfCM4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753276693; x=1784812693;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JuCOMhLM9PT+7bVlHvKxgBRdvL5A5XXp3gxInuZG5+g=;
  b=PMXNajEv9Vd3XyrmvNWb0qCJJWEtpeB9WVMMsbq+W+MnuEJEog/ACGK0
   8Vb0QWmtyEqXCy36SE1TVi0LAY1HhWUhfiok+BrL6TFjHp2NyotzDYdAV
   KJ6XQX5fN7uft/Jah8ljZ3PphWFwXGbtsirYHlpscYjpuaSzxUm5JTzCh
   rRHFJrziOiSXx7bgII6rs1gVuHetOsoPLblQCrEVwXQcdjquAm000bNyl
   SrB15Iqsn4DTfay5RCrQ81HrXGFUhOtuTVMadLJheVDi8J5Reg9qM80rn
   2GsH8A/xWFTTxOVGQ5O4g0TD5wMeAzYTw2BgZnFnP9TQubsPc1zFGs0fH
   w==;
X-CSE-ConnectionGUID: phuaqlSlTiW+gbClJM9wiQ==
X-CSE-MsgGUID: yIuRyPy1QiikPycQj4BlbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66629612"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="66629612"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:18:11 -0700
X-CSE-ConnectionGUID: qyogbtXBSYm7LrZ68itXEA==
X-CSE-MsgGUID: b/X5geGiTVeMbzIzY8ASsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159615523"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:17:56 -0700
Message-ID: <5cf448d2-ebd5-4a60-b865-a8be7982bbd8@intel.com>
Date: Wed, 23 Jul 2025 21:17:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 03/22] KVM: x86: Select KVM_GENERIC_PRIVATE_MEM
 directly from KVM_SW_PROTECTED_VM
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
 <20250723104714.1674617-4-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-4-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 26A0240003
X-Rspamd-Server: rspam06
X-Stat-Signature: dgexrusnd96iwugriimu5wtx88ekwnca
X-HE-Tag: 1753276692-333528
X-HE-Meta: U2FsdGVkX18tRcwgoXRmJJ82i04YfD1QN4CR4tdIRQyqzzsPW7nIZ3903C1DpCdUR1u9PNIh4ME0+Ra3AxwIRt9EhtUK8SRjZ6TmfEneXWJJD4/uN17tCkZ4QanviyM4HIjq6f97n0D+k3zuYN8TVaBVuHwrJnmy5Gpr5MWv+utDRCoZU53X3PSArGryRMOAwdM/UvhIewCGU3FyjAlwa8nhyPX+47HrqMSjleXqmKvQtfYvpKyR13fieBnuLCRGDjSgz1Cg+BauGWvX2QGrHDGA5IV6iyTzqm4+jFjLUxAWykSCjQLAAGeZyeG7gzr9hjPJZJG605IR0OsAVSpS2SCoyg8gc4+BIRIeAKwT09dGo6/vReBFebZOwUgas2L44YWb1fsTpRjLKGR2K2zQ+i8mR+0ZNG6mN9+akqJpkm/jinw5UOApislv/wr1c+GzU3poyqnxkaUzfQSNCUsJXSMHv71BI3QF/GOBPM6Kvpa7lyG/q0JhmD2wsKolkEQu6RDtEk9Ec9cKTRFRnsPyG39efh5Oip4lwLXDztTjTFUrWeAMIpaYCMFJq4v6hB3Niiqn+FZWDvTRYN5a2+1TZHdETHylktDBr7YdsDXrtZzpfdrcyOpXwD5pLytJ+roVK1enRntkIMCyO805mzfdkY+OKoupzC8Vghero/TgJA0ddtouV8WUJffueJtalDo2kRdZoDGQraD0eeBAKGUwAwJe4rtc9qPiohNVqp6KlQ1Nm69XoEI4VhoUjOMTHWqZi2U3W0El11/Z3/LwQ2o8BP/vL1mNISKzVnc2ZpSWbIZZm7RHu4/HwU3lwWuDdLgJaLRAOHPSYlhORscTlTXwgSm01P97KRpf16BXHC2sWhewLcqIkncujCh73noZZGzA9THIs0HWITq3pL+s0xU+rY1oWuENojhvkT6NC8lpVDWEyb5jmltNuXOyvMcvRv2iJak+mXJzM7jHSTj+XaI
 9eEItoCV
 aOd0lS/7MMtsBEPSzg9Zl2kDRwqA7gLxfA9vg8yr6K0LkZEd97gQEE4eSIke+NgycGomrMXRajHUQL7tnqeKvjZANxVza+WHlfXkB6r/Gv6phTItewWD5WIiF0xC2zo8C2WsD6bYNuaDQAvZugzqeMeZyxul/pyPFyy+QI/3QQV5YTCXwiBCGwyNsAxw1ArscIPJQvreh1NDakYX/lD2HacO9olmBWItkSszzTIkcXuKBXx4dJzX0XANUVrIwasXiQPFm5wrsmZU2oaDsJeeAA6f0Ym8G4sya0iZjqcu885I6qdPHDVsSKA7PQjIgdI2No7wHxWC+HtsGRFDD9SHW6IttLTRIdgNVbtqbaz6cVIyqcFA=
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
> Now that KVM_SW_PROTECTED_VM doesn't have a hidden dependency on KVM_X86,
> select KVM_GENERIC_PRIVATE_MEM from within KVM_SW_PROTECTED_VM instead of
> conditionally selecting it from KVM_X86.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 9895fc3cd901..402ba00fdf45 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -46,7 +46,6 @@ config KVM_X86
>   	select HAVE_KVM_PM_NOTIFIER if PM
>   	select KVM_GENERIC_HARDWARE_ENABLING
>   	select KVM_GENERIC_PRE_FAULT_MEMORY
> -	select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
>   	select KVM_WERROR if WERROR
>   
>   config KVM
> @@ -84,6 +83,7 @@ config KVM_SW_PROTECTED_VM
>   	bool "Enable support for KVM software-protected VMs"
>   	depends on EXPERT
>   	depends on KVM_X86 && X86_64
> +	select KVM_GENERIC_PRIVATE_MEM
>   	help
>   	  Enable support for KVM software-protected VMs.  Currently, software-
>   	  protected VMs are purely a development and testing vehicle for


