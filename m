Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AB8C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 05:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1C98E0002; Tue, 22 Jul 2025 01:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9BC8E0001; Tue, 22 Jul 2025 01:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B90E8E0002; Tue, 22 Jul 2025 01:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F08CC8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:36:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8A8D1110AC
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:36:20 +0000 (UTC)
X-FDA: 83690790120.12.B4118C3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf03.hostedemail.com (Postfix) with ESMTP id C46912000E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:36:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RP36Th+V;
	spf=pass (imf03.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753162578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TrtMq8QK8JnacWkhZRm7nvkCBwJlbohSWNzq0soMCVU=;
	b=oXqIdKOY6FjNeFibfPwFcsnebFHIx+AMBNxi8aHwpUh7WBIXP5KFTtoCpQL6/6CWcGPA1T
	yYm3lj0OoJvh9tBGoppvWCsRxSb8yG4ioCO7YQFpTTz9ZmA5i451/IN28h5TYXtrQeuYA6
	27guGnOFRpt63sp6ssOocdg93wMSb8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753162578; a=rsa-sha256;
	cv=none;
	b=mK+JhoebvguPd+nFWG+6Gzj4E0TgGRdE+kdISVBD8OO8D61c45kAAoJ3/hRx2iiq8fCmya
	sn0A+zeHFPzXlRAvK6LFZufmU40Ki36Fj8AkRjtOa/vrdcEeKlMB5PuOWcvu68Pk0coL2q
	M/b+LK8wvZuPkbze60tjE543HNHDY1Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RP36Th+V;
	spf=pass (imf03.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753162578; x=1784698578;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ht84lyhmPROJj1BSFrangSyvdmx5lyxfxrorEw0o2wI=;
  b=RP36Th+V73/f1FFtkrZYD/ZM13sQfhc5R3hwtiK3EoFkeSzSWDV1nd8i
   67tovjshHuRU4EZw6Q3tUj3GgpyELUUrwAIu/BS8ZesXr8uUhqRNp2hbg
   PEwQ3pygzmZelqvITS8jkCKARB2P4faCAfA2GEHVQJe9qMmGbvHT2hh0p
   miPUyc4cHxhYedGLPkfi20MvMAqeaBSltmuKSH7nj4kubl4Vv4BN8jaKq
   UOiaHcwbnD8LQ6CssiyHmrF2WWGz2UDhBxVUmcwn2Fk7AaGsestvrkIkF
   TAzYmUwDDX+kzIC0760OkfiNsjesj1DdssAEHVeh8p7FMNpomrxAXg3dh
   Q==;
X-CSE-ConnectionGUID: 8L8MUWslSw+AEeZndBicQg==
X-CSE-MsgGUID: ee9Mr3k3R+CCkbcmNDbY5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="72965827"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="72965827"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:36:16 -0700
X-CSE-ConnectionGUID: uQSKd6e7REGkUoyHhth1Jw==
X-CSE-MsgGUID: SUFj1nRtTTCLJch9qpJRPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="190020035"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:36:01 -0700
Message-ID: <c35b8c34-2736-45fe-8a97-bfedbf72537e@intel.com>
Date: Tue, 22 Jul 2025 13:35:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 11/21] KVM: x86/mmu: Allow NULL-able fault in
 kvm_max_private_mapping_level
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-12-tabba@google.com>
 <8340ec70-1c44-47a7-8c48-89e175501e89@intel.com>
 <aH7KghhsjaiIL3En@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aH7KghhsjaiIL3En@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C46912000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 9omihrdrrkzgam5dxdsc44eteqnhzyc7
X-HE-Tag: 1753162577-297274
X-HE-Meta: U2FsdGVkX18qXUv5is3wqOjafRceO+s7BXssdA3A/0zOHsLyseR49w7eh87+/jvu09LMk28l5oht/wk8v7o2kZzmP+oU9xJSkUiJTTC8tW4+dIUnPo3gviFwnIzvMt04jKpZan7+gFEw0hLT7+8U9QjUFd0T9sh5JI+tWytXv9J/b+dKADjfdl039kopSl3kKuVDa5y6uVheDDuhUs5y95GpYmeBcsV8hGRP5Ga/oWnkMbp8gQmDX8ruFj2YYm6kBbljIlebyeGshuO32qd6lUutRgN7utB/V343+HV8/NI097JeUE/C4W9bMOX2JzSs0WZ4xJZTQUJF0AAFm7xT5utGwKIFLpuqG5ytjAJ+Kba72y2Ny3qgGz7LH26VMLY/UzDIDihqfl1mEvsWqQDjSKHifWGJU1GOsO/4OhkcKP5NgRzkqco7vuaYrIHEwItB7td25JufDcdmgVB970J9EVcebfDCfymzOwsCCk9PYgbmVy1I+yXcHeOLWrO1UHDXf32XNQZUMMz3yf7pvcIBm9wBD/OYoNcdgrCfoeGatTaiQaKclk6PZrYmeOCBkotzhULUFbHRZFK3iMhH1TkM6zE0kbvvdgPUirFCkxH1I5i8kLw0NVv4JUabkW+lzE/yN+9U+9iI8RJIyyOONeW5hVR46gM1mdYsFQZWs61znvcGoYJ7N2PXEtfYukqkT7HOprLKn2sLyJ4jabF+ZNnh5S+vbSiPkMSrKNHfhHvzpu5V5acXbhysNUbKMYP4ZWQlC6Rs+7W1nFuMPBTsrZx/XvadJCqm2a9kjBa+GaKxy8reOCRa1r75caCF3JDBrEBNlUDf8tc/VL4ESXJxuFxyA/ftmlBC+B2HX050r3+wcTv+apIvaD6jOa6s56ju7oRpNhgFAV0S5CpjZCHt+1ms+1mb2Qh2bawdgLgJKXAfzpV/3pmvqwocn6KdAvkoRlTa6Nu8jTZK4JYdzR4f1Bz
 yMkJQcST
 KGo+Uee+wA94z84VbM0U67ZpHDnwVuDS2hkWiJN0I4/YRMwNXHv7Gz8cXISuIfOBNPh+ru0cvM+FnNSMD6DW80JrJ77VC305jiG6hpMjy7wvDQUngp56/S8BlcV/s/IP3MuZ7/rxKXjJnWljltxxusxLVRSk1SRvbWfZbJqzqwgPL4W0QzIvQCX7HSHeJXzr9ytftqTW13spd3d1Yl63Zmrj82uyORhYAQbYwtDYQ18bclggmIP10j6m4TBOyM9sE2EJ4GyrG29peipafrweeQEzef7MzVOxoBLcmSHn93Mir2bO6D7KOWuXt/hhkr/J0AhSuCLZrhoJY0xaGyM9dhyJ+uZWexbOoAbvzLYgJy1zACnqmA21GX91iug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/2025 7:17 AM, Sean Christopherson wrote:
> On Fri, Jul 18, 2025, Xiaoyao Li wrote:
>> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>>> From: Ackerley Tng <ackerleytng@google.com>
>>>
>>> Refactor kvm_max_private_mapping_level() to accept a NULL kvm_page_fault
>>> pointer and rename it to kvm_gmem_max_mapping_level().
>>>
>>> The max_mapping_level x86 operation (previously private_max_mapping_level)
>>> is designed to potentially be called without an active page fault, for
>>> instance, when kvm_mmu_max_mapping_level() is determining the maximum
>>> mapping level for a gfn proactively.
>>>
>>> Allow NULL fault pointer: Modify kvm_max_private_mapping_level() to
>>> safely handle a NULL fault argument. This aligns its interface with the
>>> kvm_x86_ops.max_mapping_level operation it wraps, which can also be
>>> called with NULL.
>>
>> are you sure of it?
>>
>> The patch 09 just added the check of fault->is_private for TDX and SEV.
> 
> +1, this isn't quite right.  That's largely my fault (no pun intended) though, as
> I suggested the basic gist of the NULL @fault handling, and it's a mess.  More at
> the bottom.
> 
>>> Rename function to kvm_gmem_max_mapping_level(): This reinforces that
>>> the function's scope is for guest_memfd-backed memory, which can be
>>> either private or non-private, removing any remaining "private"
>>> connotation from its name.
>>>
>>> Optimize max_level checks: Introduce a check in the caller to skip
>>> querying for max_mapping_level if the current max_level is already
>>> PG_LEVEL_4K, as no further reduction is possible.
>>>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> Suggested-by: Sean Christoperson <seanjc@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    arch/x86/kvm/mmu/mmu.c | 16 +++++++---------
>>>    1 file changed, 7 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index bb925994cbc5..6bd28fda0fd3 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -4467,17 +4467,13 @@ static inline u8 kvm_max_level_for_order(int order)
>>>    	return PG_LEVEL_4K;
>>>    }
>>> -static u8 kvm_max_private_mapping_level(struct kvm *kvm,
>>> -					struct kvm_page_fault *fault,
>>> -					int gmem_order)
>>> +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, int order,
>>> +				     struct kvm_page_fault *fault)
>>>    {
>>> -	u8 max_level = fault->max_level;
>>>    	u8 req_max_level;
>>> +	u8 max_level;
>>> -	if (max_level == PG_LEVEL_4K)
>>> -		return PG_LEVEL_4K;
>>> -
>>> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
>>> +	max_level = kvm_max_level_for_order(order);
>>>    	if (max_level == PG_LEVEL_4K)
>>>    		return PG_LEVEL_4K;
>>> @@ -4513,7 +4509,9 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>>>    	}
>>>    	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
>>> -	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault, max_order);
>>> +	if (fault->max_level >= PG_LEVEL_4K)
>>> +		fault->max_level = kvm_gmem_max_mapping_level(vcpu->kvm,
>>> +							      max_order, fault);
>>
>> I cannot understand why this change is required. In what case will
>> fault->max_level < PG_LEVEL_4K?
> 
> Yeah, I don't get this code either.  I also don't think KVM should call
> kvm_gmem_max_mapping_level() *here*.  That's mostly a problem with my suggested
> NULL @fault handling.  Dealing with kvm_gmem_max_mapping_level() here leads to
> weirdness, because kvm_gmem_max_mapping_level() also needs to be invoked for the
> !fault path, and then we end up with multiple call sites and the potential for a
> redundant call (gmem only, is private).
> 
> Looking through surrounding patches, the ordering of things is also "off".
> "Generalize private_max_mapping_level x86 op to max_mapping_level" should just
> rename the helper; reacting to !is_private memory in TDX belongs in "Consult
> guest_memfd when computing max_mapping_level", because that's where KVM plays
> nice with non-private memory.
> 
> But that patch is also doing too much, e.g. shuffling code around and short-circuting
> the non-fault case, which makes it confusing and hard to review.  Extending gmem
> hugepage support to shared memory should be "just" this:
> 
> @@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>          if (max_level == PG_LEVEL_4K)
>                  return PG_LEVEL_4K;
>   
> -       if (is_private)
> -               host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> +       if (is_private || kvm_memslot_is_gmem_only(slot))
> +               host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> +                                                       is_private);
>          else
>                  host_level = host_pfn_mapping_level(kvm, gfn, slot);
>          return min(host_level, max_level);
> 
> plus the plumbing and the small TDX change.  All the renames and code shuffling
> should be done in prep patches.
> 
> The attached patches are compile-tested only, but I think they get use where we
> want to be, and without my confusing suggestion to try and punt on private mappings
> in the hugepage recovery paths.  They should slot it at the right patch numbers
> (relative to v15).
> 
> Holler if the patches don't work, I'm happy to help sort things out so that v16
> is ready to go.

I have some feedback though the attached patches function well.

- In 0010-KVM-x86-mmu-Rename-.private_max_mapping_level-to-.gm.patch, 
there is double gmem in the name of vmx/vt 's callback implementation:

     vt_gmem_gmem_max_mapping_level
     tdx_gmem_gmem_max_mapping_level
     vt_op_tdx_only(gmem_gmem_max_mapping_level)

- In 0013-KVM-x86-mmu-Extend-guest_memfd-s-max-mapping-level-t.patch,
   kvm_x86_call(gmem_max_mapping_level)(...) returns 0 for !private case.
   It's not correct though it works without issue currently.

   Because current gmem doesn't support hugepage so that the max_level
   gotten from gmem is always PG_LEVEL_4K and it returns early in
   kvm_gmem_max_mapping_level() on

	if (max_level == PG_LEVEL_4K)
		return max_level;

   But just look at the following case:

     return min(max_level,
	kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private));

   For non-TDX case and non-SNP case, it will return 0, i.e.
   PG_LEVEL_NONE eventually.

   so either 1) return PG_LEVEL_NUM/PG_LEVEL_1G for the cases where
   .gmem_max_mapping_level callback doesn't have specific restriction.

   or 2)

	tmp = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
	if (tmp)
		return min(max_level, tmp);

	return max-level;


