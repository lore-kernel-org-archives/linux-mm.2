Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA355C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 12:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662598E0005; Tue, 22 Jul 2025 08:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612748E0001; Tue, 22 Jul 2025 08:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501658E0005; Tue, 22 Jul 2025 08:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8908E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:32:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F180D111D0B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:32:33 +0000 (UTC)
X-FDA: 83691838986.27.4F9F10D
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id EFD53A0002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:32:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WeLHgmXx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753187552; a=rsa-sha256;
	cv=none;
	b=v0jmdku2TNwRk+dl+fxeN28WDi+l6VgtSKY3EFsMwydztFLLbHz3rkyKKoyH8eBuPEhIvW
	yLG6E2fW/3LqhMB1kuY/CjUhmNRMmDEP/rZlggEk86vx411laR58NnZ24pnGZm6asvAcUM
	p15qVhOWTWNWVMT/74Irkigbx57wPOc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WeLHgmXx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753187552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MMMOAOPjOBlhMHrulLMPV/ml/XegyxT79zgI8vdaQc=;
	b=v5TlwYLInkq/zDGm6wg7CvdzU3N46o9RFrHGRokpvEfjW8DKfo/Y/u2xf9yrL/G4miAsjp
	v9RvXh+F4aQ9YbV8KMqtju0N6I8kQ5NAdMzql3NZGoFdasjrVr1PJff99fD/xomlAdt4f1
	mFIIqrNrQKIGp706lkbN07dVmHOOyxc=
Message-ID: <07976427-e5a4-4ca4-93e9-a428a962b0b2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753187549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7MMMOAOPjOBlhMHrulLMPV/ml/XegyxT79zgI8vdaQc=;
	b=WeLHgmXx0r97gR/zn1eWenIdriuOSpYVj9Enitmu+wk6hPYUCHXPbtDMke+K2iZ8CfIEli
	L2PPPUlUHtpcnh+fY+glHgeelj+WuvAribXpZM+k/8swY851tIbGWUVGWzbcfzmko35xvp
	bSykaR5ROyJfWZ7ZJwWd2TTVDWbPsEs=
Date: Tue, 22 Jul 2025 20:31:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v15 16/21] KVM: arm64: Handle guest_memfd-backed guest
 page faults
Content-Language: en-US
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
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
 <20250717162731.446579-17-tabba@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kunwu Chan <kunwu.chan@linux.dev>
In-Reply-To: <20250717162731.446579-17-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EFD53A0002
X-Stat-Signature: 6uc791ie4pz51zw7m39qan66ht41wggb
X-HE-Tag: 1753187551-798053
X-HE-Meta: U2FsdGVkX185j0+i3cxy5UAt1XmnicVy8op8b3Ux17gIxQS6wxbQAw+nSp/mxRgr54BkI1bwF3h6awVgf8HcHMpCAbxtHcdnhTbWx7GheJ99Uit0wjzjFandyFeni+3EfyoGM0IWFt6W6yobf+nEZF6mpeSJYSD8jy7xB4ZHhwEN475S6JbtjN7kJJWmaoU7ISFDxeQVcIVwNbMNwApgRWUKOsrG1X3SXfCtWVW3hWp5r4HtUCRUUNEG4c6HuPz4k505veRMHp+ozB57NQCGI1ccQbwlEeYBs/lmTVHmt/HQxJplggqCw6HqbQgehwgLFO8yf0xQPQtWiCQGwIqxN+/HgtWTZws47OhH3Paonxmgfznuag4/aMe2o8XV+J7JPMZbHWx6NjAxcg7UahTMTvmjmX6p8UKQZCBNWcqXyG6NB1hNhHLf7KsozQZyYSAKcLa+6ISqqgNKycbFYcIyrKoJOVdTzL6wrpkO9ZoGGIFmcsJra+QH273a0vfrqLlbumicghN2vvNbTzdDL5rkZnCIBxP6zjy7Xg7SpZSH3Tv4msILSadraqK2uk0Wqg/020mqKFzZJA9MVqcV2T1DMEkD79FkPQoMibtUwMvcFqZ2dFjS6mV8oMYXMetBxpuoNMyGVMRoawdvZN9Ti3DXyVMSAr+6k8KlSjqhabh5iKmH9oaKuI02ednIQV0ZrxMYRG6lNpP3b1UvAyFrRnpOZ9LOe6gV3jKAdd4/jAh6bKNpaiAKC4zpKc7x/YKQ2nC9Xzx81zpJsGhUf2BLz4GF+xkMZcWoX+PxMXmLldXzLSE0Y7ORoCxPlh47LySJs11qWxJBW1FU4bXN/11/DGOCZm0Ug5JOjqOC8SiOpmvDiO3H3Q+g/oetAqewcQY2iL/Pv2w0H8v42racAF/buRhUaAAkSHu0vMokYE4+CUYRkQcFEs6hmJUO+usDGS1I3y2GiFYDbBmq+Y2hRqcAaUt
 SEB/fkqE
 9R1lxhviD5AvKqW+Rpz7Bmham9GkTBMVqVNYKY/YmtdZRSJ9Qg35yaVZ6imHkM2ETb15O3YHKaF3pYvK9QlXjsCeGYK7l5GV3kRhLy1I74jpblDyscaEE1jizgzacadOjJsT90o7tXsKrkGEFhbz8aTFBKpfgTncuJ5ne86GZa22FgAPYAsTH4U2I9wgeE+WOJCXU8kbTEhkMUvONe++2RHNW2rqGx6wrElUy0RuOOsnyVczdg1CUtop3idqZXx6uWIwBXVHY18tfZIiP7JoKKMii602PpPJ/uswEyRCOqY8mVMu3AVKwyou/orGS6CT9pr+Jt90XqNMxhA64zOtif/OZ5krNMzSX/mLREs9bdSTAJQnQLkhKIc3KFRNE63QUszsh//Xx773n2145M18FenWBwLLgqBUBga7B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/7/18 00:27, Fuad Tabba wrote:
> Add arm64 architecture support for handling guest page faults on memory
> slots backed by guest_memfd.
>
> This change introduces a new function, gmem_abort(), which encapsulates
> the fault handling logic specific to guest_memfd-backed memory. The
> kvm_handle_guest_abort() entry point is updated to dispatch to
> gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
> determined by kvm_slot_has_gmem()).
>
> Until guest_memfd gains support for huge pages, the fault granule for
> these memory regions is restricted to PAGE_SIZE.

Since huge pages are not currently supported, would it be more friendly 
to define  sth like

"#define GMEM_PAGE_GRANULE PAGE_SIZE" at the top (rather than hardcoding 
PAGE_SIZE)

  and make it easier to switch to huge page support later?

> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 86 ++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 83 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index b3eacb400fab..8c82df80a835 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1512,6 +1512,82 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
>   	*prot |= kvm_encode_nested_level(nested);
>   }
>   
> +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> +
> +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> +		      struct kvm_s2_trans *nested,
> +		      struct kvm_memory_slot *memslot, bool is_perm)
> +{
> +	bool write_fault, exec_fault, writable;
> +	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> +	unsigned long mmu_seq;
> +	struct page *page;
> +	struct kvm *kvm = vcpu->kvm;
> +	void *memcache;
> +	kvm_pfn_t pfn;
> +	gfn_t gfn;
> +	int ret;
> +
> +	ret = prepare_mmu_memcache(vcpu, true, &memcache);
> +	if (ret)
> +		return ret;
> +
> +	if (nested)
> +		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> +	else
> +		gfn = fault_ipa >> PAGE_SHIFT;
> +
> +	write_fault = kvm_is_write_fault(vcpu);
> +	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> +
> +	VM_WARN_ON_ONCE(write_fault && exec_fault);
> +
> +	mmu_seq = kvm->mmu_invalidate_seq;
> +	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
> +	smp_rmb();
> +
> +	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> +	if (ret) {
> +		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> +					      write_fault, exec_fault, false);
> +		return ret;
> +	}
> +
> +	writable = !(memslot->flags & KVM_MEM_READONLY);
> +
> +	if (nested)
> +		adjust_nested_fault_perms(nested, &prot, &writable);
> +
> +	if (writable)
> +		prot |= KVM_PGTABLE_PROT_W;
> +
> +	if (exec_fault ||
> +	    (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> +	     (!nested || kvm_s2_trans_executable(nested))))
> +		prot |= KVM_PGTABLE_PROT_X;
> +
> +	kvm_fault_lock(kvm);
> +	if (mmu_invalidate_retry(kvm, mmu_seq)) {
> +		ret = -EAGAIN;
> +		goto out_unlock;
> +	}
> +
> +	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
> +						 __pfn_to_phys(pfn), prot,
> +						 memcache, flags);
> +
> +out_unlock:
> +	kvm_release_faultin_page(kvm, page, !!ret, writable);
> +	kvm_fault_unlock(kvm);
> +
> +	if (writable && !ret)
> +		mark_page_dirty_in_slot(kvm, memslot, gfn);
> +
> +	return ret != -EAGAIN ? ret : 0;
> +}
> +
>   static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_s2_trans *nested,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
> @@ -1536,7 +1612,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>   	struct kvm_pgtable *pgt;
>   	struct page *page;
> -	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
> +	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
>   
>   	if (fault_is_perm)
>   		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
> @@ -1961,8 +2037,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
>   			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
>   
> -	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> -			     esr_fsc_is_permission_fault(esr));
> +	if (kvm_slot_has_gmem(memslot))
> +		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
> +				 esr_fsc_is_permission_fault(esr));
> +	else
> +		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> +				     esr_fsc_is_permission_fault(esr));
>   	if (ret == 0)
>   		ret = 1;
>   out:
LGTM!

-- 
Thanks,
   Kunwu.Chan(Tao.Chan)


