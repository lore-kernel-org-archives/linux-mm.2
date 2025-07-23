Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 513BCC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03758E0023; Wed, 23 Jul 2025 09:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BC18E0002; Wed, 23 Jul 2025 09:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C537D8E0023; Wed, 23 Jul 2025 09:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE24B8E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:51:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F9CBBAB9F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:51:23 +0000 (UTC)
X-FDA: 83695666446.27.6B4A0BF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id AB0FFA000F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:51:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WzKGZ8WP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753278681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4zQ+76oJdWedF8P83PLBJIlkekHGBNe0+VBwKXOJ9Y=;
	b=D86pgQMPOknqppSxXGCezkfgqo6jixJorTvJ2HdHYuel9tNgXFFbO6/Grq23JBTzhy2pUS
	snzzJcZB5duuACjJZ4kAcxYGqQMhqNlr0R3KFPcI7YmFs+wT/RpKqVQiAorXxYEA7y5fcd
	zMAKeX7AZY1iAMllFlhy72GlH86WFTk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753278681; a=rsa-sha256;
	cv=none;
	b=l/Mmet5SeRmYNzj2oMEZvJy3CyxqsKgAwCwnGaenwkk7j4Q0/NmMrUgQZw3EpJiqupNHxI
	1kYqDSWTYAienTPGUxzQAtH5BJgxUJ4BK1RV9KpiRpB2NvLEgjJbEPE73jjIJa3gt1mSID
	IHBGwQXBXSauT449IcK60dw0jNxCM3s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WzKGZ8WP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753278681; x=1784814681;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eQrNVexDn6gUiI8N7okzCFGkwbMEVNClA27i2DhdkWo=;
  b=WzKGZ8WPpW9p3V8ERMIOCEwcRWp03rYo0cFvu3PY9ZO9qv5TwrvXx01V
   5sbvBbteKc5A14rfBUf6bZ1ntTNMd5zMxKB5fd4QK3z7spSqdESvTBjJX
   no038iKqhJaJ7gw3yKOtKG0m4+aiLMLrpvI3NQeQvLMXJO6LNPufXNUa7
   UkhqaDnFcPualZrTR5R1IvcdMZoB/SbOGytHoWkOz2mvGwlvQQOFdEffe
   E7AmEbxuNIQUUNcaDIf2/GHSxdTqsSr8bIk1s5mQ+Ulkp5sGhdOdI8nOn
   PV0Zi/RQiWWx2NmovfBUzrXhtQKlj4+jvpMFdoWcHql5OVbXmpjqDSU4q
   w==;
X-CSE-ConnectionGUID: X8LiwWtLQYSV0HcxB0QKJA==
X-CSE-MsgGUID: tFJQCTlGTS2/cV89ZG+f3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55708244"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55708244"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:51:19 -0700
X-CSE-ConnectionGUID: TqfLCK0vTki0sojT2hF0Tw==
X-CSE-MsgGUID: QVf4ei8jTF2AYxkxP3WBhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="160067185"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:51:05 -0700
Message-ID: <a3602530-1050-4868-814c-19592b215127@intel.com>
Date: Wed, 23 Jul 2025 21:51:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 13/22] KVM: x86/mmu: Hoist guest_memfd max level/order
 helpers "up" in mmu.c
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
 <20250723104714.1674617-14-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-14-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: btg91ibf9wauma8na5op5bouxaebdwys
X-Rspamd-Queue-Id: AB0FFA000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753278680-133900
X-HE-Meta: U2FsdGVkX19XTf3iPbCGHOVnHqLc1VItKDfAkvCXiGOYRrIbao0fnhHO8u2o/3QL1t20K0LulNajAXM8TuWu/CEzP/kg7OmDwOsRM9xWhx+RQ0UQCt0V2tIdjBuWuGRMolOLiaz9KW9+mV7g5OIp+SGawbzzMfwDpfP55Zygy9uqVZdVlsZQrmgZvD4+lVocuEYKLAbYtJ9Dlflz27yDSTsYi7AE1ucaD588SB42Y2T1Dd1FNL78SkZV1zdWsD8RNijPX9st3kkmsUcQE9bEjc3bIQePvvrYaAYaDqqEpqk8KksPqa2s46R+hg2Ll0pjrUxFoKHxhEd7QwQnQbfk2f6maPkIWPfPKZviu6jlMUGQZSdx4ZOZP9yay2uqzvPqIl1PH/RoVbfqvDa9w3DHVqOcD5VeRTRBjnL+iU11KH9x85mLlUyclQmbhpats6xjvOEr3Z52HQYry66QEhuhocU5dhw2/bZqR9PdwK3ygmb6qOAT+bfoD6YDLS37bOwQq8XZHf3QkyueVj1Sl8hEbDbtqDei7BsdUXa19h2uFeZRDpDxBsPwxnBo4a27SGMW9RNjC99BQGpWzIpFGJ2dehn6ZAeawPyLwM/BBHl0F25vwTjyxOXHN4/WaNEYq64wSP6sXAkSKuhVc99vxyl0Yf2ysUsTUN5IoxuzBMiU1VU85QtUjwG+NIK+FTEQRhPERRj7fuvItS8mGYUJkx8VTP/bwi7vtlqkOjUQil2l+5+DFp8effPDCxKCNcO6Cx91qR3TxisID9xTvuQFjw2p5FqMMS+m8ldIvz7J0XL8+w9d/f/ixbGisXnb0QIyiXs9C9KM3ilZ5ycDkPpUn4+iSPrt3OJ0x0II3k1PihdkYVulOCYvSvu0Tcs6ss+1DG+O6a5SUI1J1++sFwD+EhQswZyP3arkkseMHb3ju4dvlnMag5ri7lQZmOHQ9yHSZLF/H5ClCm/shcv7d7g6vuB
 lpNrlVwH
 LZKfRmp5s7ZEflfWLwtt4y2KDbjLCGfl82iKeLkd2XG9KdBQh3AlhRIlpz4cu6+uRs8CT4oKVZONwo4TNwkMveB+Us/60vv2CuBi062TLevUWvkQJR68oApNEjS+j0KNo7FVWt0cJX0W3H+2MVZLO1D9tPayP7hCz7asQrJyUlE85tNniplv0qAqW+Xz+iuhylbuzOpJwF/PdtHCdQQfmSgxpEGYFHeEcNCOjXhza4to3CdofCgqxQ7Wk6HhWabSpf/PpnBBEWhDzHoom7Y9RYWQY6cMj4aKwr/G+amXCuNa1LTwP/oE7L+1sk0KBDpk7w3M7GR3/MMQire6vU9kXsuukeyADbITku2JShSdw6nw8P7svd5Tb+i48Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/2025 6:47 PM, Fuad Tabba wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Move kvm_max_level_for_order() and kvm_max_private_mapping_level() up in
> mmu.c so that they can be used by __kvm_mmu_max_mapping_level().
> 
> Opportunistically drop the "inline" from kvm_max_level_for_order().
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 72 +++++++++++++++++++++---------------------
>   1 file changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b735611e8fcd..20dd9f64156e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3285,6 +3285,42 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
>   	return level;
>   }
>   
> +static u8 kvm_max_level_for_order(int order)
> +{
> +	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> +
> +	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
> +			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
> +			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
> +
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> +		return PG_LEVEL_1G;
> +
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}
> +
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> +					u8 max_level, int gmem_order)
> +{
> +	u8 req_max_level;
> +
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
> +	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
> +	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> +	if (req_max_level)
> +		max_level = min(max_level, req_max_level);
> +
> +	return max_level;
> +}
> +
>   static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>   				       const struct kvm_memory_slot *slot,
>   				       gfn_t gfn, int max_level, bool is_private)
> @@ -4503,42 +4539,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>   		vcpu->stat.pf_fixed++;
>   }
>   
> -static inline u8 kvm_max_level_for_order(int order)
> -{
> -	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> -
> -	KVM_MMU_WARN_ON(order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G) &&
> -			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M) &&
> -			order != KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K));
> -
> -	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> -		return PG_LEVEL_1G;
> -
> -	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> -		return PG_LEVEL_2M;
> -
> -	return PG_LEVEL_4K;
> -}
> -
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -					u8 max_level, int gmem_order)
> -{
> -	u8 req_max_level;
> -
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> -
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> -
> -	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> -	if (req_max_level)
> -		max_level = min(max_level, req_max_level);
> -
> -	return max_level;
> -}
> -
>   static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>   				      struct kvm_page_fault *fault, int r)
>   {


