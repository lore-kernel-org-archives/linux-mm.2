Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BB9C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0E46B00EA; Wed, 23 Jul 2025 09:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271A46B00EB; Wed, 23 Jul 2025 09:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160928E0002; Wed, 23 Jul 2025 09:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0529C6B00EA
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:56:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF75AC06FB
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:56:13 +0000 (UTC)
X-FDA: 83695678626.20.EB12E47
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7A50940012
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:56:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kq89YRKZ;
	spf=pass (imf27.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753278971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/IErEt1WJfSIvUDGJZUa2vOJ7JVthl4LZcTfzRz1Jc=;
	b=LFNLR5kp/oyuzjLXmZ3JJ7kqU061fSDKlGPRyDZtu1od+n53TVJGjJlfkezJTyUc5lCcQD
	e0TmWqbHCW/dLDWymou4D7Wgm7OEdbGIGwOD8EBbwqyWj4N8KI6SNGb3XSQYnrbYGA5R04
	OVt8zu/ptWySXT6joHIAhe34CJr0YuU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753278971; a=rsa-sha256;
	cv=none;
	b=2B8NIBxwp65tD4Bap03dJnH9HlQUnRa9cGT0plysiuSV1CXnDajo44/0k8HOFtkJCrkn+8
	e6vpN1CWm0zkzwACQC9mmmFd1IkKTxJ7/pIU6QtjsS3CXMm/qQYI5ACr+XFFQjLtQY6V+i
	lgwJr6dPtg+4gMiqZW7UCPCI2QhcmTs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kq89YRKZ;
	spf=pass (imf27.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753278971; x=1784814971;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=c8kuwhSWCLXC+0Y2fVqX0LnjkpKYcmdlz+rgqy/SZtc=;
  b=kq89YRKZiQf7+3Co6j0R+yHCiJNOJS+j6XwK3gduamZen0pymSRM88Bw
   bKTETdsQ25FTg5dHH8S6hWDBQR5QXK5CtQy8w0k69dhEivSqvIwD4yOmB
   HIP0QbLcGRODgEyOcCLa7Tc6gpzb+ZRITmNFKAxU4F4KPYZhupytbP5up
   i/Ns0XoTSD/yBaUr0TQdkK+l4MDRwIB9l3Q07IiSHXI6SxYPCH2Nc8jRA
   xl35k8kzM5VT+G/1m5B05EqSoGxXcAEnYJM2P195q69h5JJZXS0j8GZMT
   MvEIQyCw6rkKKgrifCQC2rXdirGuo1kYumA/Cayf1ITYl967qWRZ0VIy1
   g==;
X-CSE-ConnectionGUID: tHdijQJsTt6ffKJC8CAMnA==
X-CSE-MsgGUID: sPbd+NDqTMCKGSeI/xs83Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="78098955"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="78098955"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:56:09 -0700
X-CSE-ConnectionGUID: FUy24KQQTXSLB7tBu314zA==
X-CSE-MsgGUID: wepDHHHERX67GzCbFIqzPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="158797033"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 06:55:56 -0700
Message-ID: <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com>
Date: Wed, 23 Jul 2025 21:55:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
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
 <20250723104714.1674617-15-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-15-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7A50940012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: u3zcx1buoiq4gjm9w85z7bq9xmn5z7rf
X-HE-Tag: 1753278971-27167
X-HE-Meta: U2FsdGVkX1+8S1Mi2BmKslp1YcHqeHcEu+ZpP6o5rIhSeRALqA2EC9zAADGpAyVKrZDNgfyl12p7jOznG6X/jgPvWxonTRvhNa86NxdALPon82dkcHzRYCBfiOxUqLFxEWkx4/UgFKilQOXxyR3AOsP2qkBTeFT050MJfl1laQQkxMi3LTjNQ5BOl0Q6m4QAnNDbzaHL3NqOR+uGc9mQCMwmr1mJiGSO7wh4QsHrWfAg2aVSP8cdWCDO0c8MBA/fATQiE1ZRlqr1o6ZMaaPhZxvDf75p02pSa6k+5vcuNgjW7Pj+SXpCPIHJUshJoX6wgvbxdkrG2ay/9bkmQVpkkvcH45QUePFgGmpJadNqXe4jEL2KIfxBVxG9HEKFqxtfn1oE+ROakJCle+GZaTisotvWSkQsQZaMOGEROE9vRyuYZ4oB17ghu7xcD5ep/fiRt0g/ygvcz8/NP+pCxCT3VYB2WKgYNwPs5puHmrtqEPKoy5gs1POiTZxDz3E/ZwXfjjaXmzURiYJ0JrJSvL2XtyjXWa1Q3vev9jrlp2Zxz+Lvcvl2/Jbw8KLSh4mbgBD8Dx/M6S2BSdhvEY+3CeNuLSSV/r7i/n59EPXWKnWUbFe82i6AARr0MKl2cTmrWjm35+loWFArfZeDiG7zgAL5A/2DlTMkUKIfCzU1XthnzXbxw2nHGZNahNYQjvg+wBZDA/hdX/wWgswY9ep0RLtDlZqxVt9iC4A+PZDR4irdTxzBAY4HY7d3DYlTBUlmIPtftfj5lnAajrCd9bMKAAIk1oTmecqCj8CNFOIdO1STSGYBh3/ag8Fb48d0UvILvYem5uFHWSSKEl0S8sLxfBOEYRhnrONRckp0I7HfhmrsYZY8kas00OFDEfYNp/IpbGVF8UqEMWDuQHQv/Nkkbt50i1DVkyp1+npDPvOytfocZzj4mwAgz4ytgbwiWkJlie/xObPxqs0/5/VmkIebLmN
 q2pZR2eD
 SX/sFgdyHYJRGG1dzp6WoC4OTQw==
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
> Rework kvm_mmu_max_mapping_level() to consult guest_memfd (and relevant)
> vendor code when recovering hugepages, e.g. after disabling live migration.
> The flaw has existed since guest_memfd was originally added, but has gone
> unnoticed due to lack of guest_memfd hugepage support.
> 
> Get all information on-demand from the memslot and guest_memfd instance,
> even though KVM could pull the pfn from the SPTE.  However, the max
> order/level needs to come from guest_memfd, and using kvm_gmem_get_pfn()
> avoids adding a new gmem API, and avoids having to retrieve the pfn and
> plumb it into kvm_mmu_max_mapping_level() (the pfn is needed for SNP to
> consult the RMP).
> 
> Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
> as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
> i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
> exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
> of the gfn.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c          | 83 +++++++++++++++++++--------------
>   arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>   3 files changed, 50 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 20dd9f64156e..6148cc96f7d4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3302,31 +3302,55 @@ static u8 kvm_max_level_for_order(int order)
>   	return PG_LEVEL_4K;
>   }
>   
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -					u8 max_level, int gmem_order)
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +					const struct kvm_memory_slot *slot, gfn_t gfn)
>   {
> -	u8 req_max_level;
> +	struct page *page;
> +	kvm_pfn_t pfn;
> +	u8 max_level;
>   
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> +	/* For faults, use the gmem information that was resolved earlier. */
> +	if (fault) {
> +		pfn = fault->pfn;
> +		max_level = fault->max_level;
> +	} else {
> +		/* TODO: Constify the guest_memfd chain. */
> +		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
> +		int max_order, r;
>   
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> +		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
> +		if (r)
> +			return PG_LEVEL_4K;
>   
> -	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> -	if (req_max_level)
> -		max_level = min(max_level, req_max_level);
> +		if (page)
> +			put_page(page);
>   
> -	return max_level;
> +		max_level = kvm_max_level_for_order(max_order);
> +	}
> +
> +	if (max_level == PG_LEVEL_4K)
> +		return max_level;
> +
> +	return min(max_level,
> +		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
>   }

I don't mean to want a next version.

But I have to point it out that, the coco_level stuff in the next patch 
should be put in this patch actually. Because this patch does the wrong 
thing to change from

	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
	if (req_max_level)
		max_level = min(max_level, req_max_level);

to

	return min(max_level,
		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));	

