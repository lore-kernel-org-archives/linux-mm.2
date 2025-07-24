Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D16C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733286B0358; Thu, 24 Jul 2025 19:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70AFE6B0359; Thu, 24 Jul 2025 19:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FACB6B035A; Thu, 24 Jul 2025 19:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4736B0358
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:21:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0494A133B50
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:21:19 +0000 (UTC)
X-FDA: 83700731520.27.F512604
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 41A2040003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:21:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gX7xxIsz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 37L-CaAsKCMEhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=37L-CaAsKCMEhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753399278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FtxjXfgxpDTfPuT5P5fzUWtA1Sv02FqXCCsZ6XDi+Ns=;
	b=ArTuSKRvHJyBrJu0rKxKPK7T8Bosq6Er2nVsnUVdJRJiRSrjWjn8rRv5zEoRVmm4/6mmDN
	C5d8vuvGImpJyynfa/iEVzwl22VD8pMnq+k/8kssm2P01guiJmpdeClK9wnCECGyCHT6X4
	sVAbydpPqa2t3zGjbHTD0xb5joT92/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753399278; a=rsa-sha256;
	cv=none;
	b=rDtHldy2vlOC1I2+eTePi/xkv7NVOerCZJP/Qtsa93XJ//zLa6r6IjnGS4xeZusCu9TplP
	Jeuc8lXbmlY9JsUrx6seNw9AIWu6loHMaA+SOOyczsocaOEqlP0/00QDoYDAkMPKAPIp9S
	RhMjPiZX1/AgD36Kkhyhve5DV5A/Bi4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gX7xxIsz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 37L-CaAsKCMEhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=37L-CaAsKCMEhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-749177ad09fso665201b3a.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753399277; x=1754004077; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FtxjXfgxpDTfPuT5P5fzUWtA1Sv02FqXCCsZ6XDi+Ns=;
        b=gX7xxIszQBywp0rGHydkykfyfoZG7G04PpO/OXZEUFBFg6/haN3Qc1Zh1hOqrR8Lab
         aqwpFGPUyn/gE1AG3vRqhBreeN/ZLKhDzah/XDeJYsaQ0hO6ombTQyFELRIF26FrZcV7
         wNNYnv319yJIRBPVqaNwTmnn5GG8tOBhTPA7IRgBRjQ6enBYnasND+9M5gq30QShK43I
         6UM3Jzf3BWvh7Wk1v4LsMCyCQAaWeyEntWCnTSqF8dp6oFNUyEsBvtrbmrsSJpYjiO+/
         WTiaTzMgeK7q9FwMORw1IGuuZQOY+seCM8mj1ktv0S4vHa3Y68KL+U7MDdtWBiFrQaLA
         rLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753399277; x=1754004077;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FtxjXfgxpDTfPuT5P5fzUWtA1Sv02FqXCCsZ6XDi+Ns=;
        b=DyXfYVgMXCQUj/uCcQnti3qjElqiB+c7C+gkoSpuQQZkf6we7soAYJ4UF+mb1m6KKK
         j1i0rgyq8Ag/YyzZCAWPrKEI2jP+SGvdFqQsEMW4eGt0cFz/reWgdzy4bb/NejS3aiCs
         lWz4njfYgrhQE1OXu/gquDQfMbb2kBw1W7AIJ1tdvlAVnYDKshowkLP09TzjX0y274AI
         YWNGImg9hK1n8B05IPtNbQOmXKh2oSKA3prvIvE4A7eNMfIjHWo8yILqAx4vWR3NBqsc
         x0gfPA3cuSUGaJq0HE97mWt4kWjUi+QNNybg7tQ+Q/Cx7sCtq6GK0fyzB7Bb284CxVO4
         Cp2w==
X-Forwarded-Encrypted: i=1; AJvYcCW9j0Fg31LTrwYz18rM6qggIKSrAxXjv8gnyucdce9cnFR8GQdejQJBBjcAAoPvIG+FSjfYbIyQPQ==@kvack.org
X-Gm-Message-State: AOJu0YyETXohABKUFvT6K9XBqeSXOZOt0FRQjHwuAdDvClteGTdvcU+2
	A0afjvd0lD+F4BXhBMonTsjfu1QoHHo51ea7933eRjhRQqqBk1BpEuY46Wgny4K+95unPeLb+qv
	aJZPd9tJi/+Hfjfz7Oy/5DlLBNg==
X-Google-Smtp-Source: AGHT+IHB77mlV+C/lxJnFswBhZIBjpoebt2RisPAbpgmjhqANzR11md/pPeaB4Bg/c91nZg90YvmvN58T9blmmYEFg==
X-Received: from pfjj11.prod.google.com ([2002:a05:6a00:234b:b0:746:30f0:9b33])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:88ce:0:b0:75d:8e1a:6db9 with SMTP id d2e1a72fcca58-76034012811mr12157154b3a.7.1753399276748;
 Thu, 24 Jul 2025 16:21:16 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:21:15 -0700
In-Reply-To: <aIK0ZcTJC96XNPvj@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
Message-ID: <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 41A2040003
X-Stat-Signature: y6fiwdfy8cx1jey387aggmbuy7z481qs
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753399278-571440
X-HE-Meta: U2FsdGVkX19XxFldMl98/HtpfoL9mQLtQE/B/eGCNUrHk4Dskr2lBCqOVvJG2AoJ7A5BYn8ZtftF3SPj6PcMP6C44jS2+GLQn9wvzo3SxHEl7lz3W+JR3vD/qe490+Awoyn80+5he0Jlu4vq0fX69bQ+1U2fgDPv9z5EAtQCt9NBSUU19XVg2NG8/Y8eoBuw/RD6nszbkv++YnhCLtBVA8iiuBmxD0scm3QJMae45VtQdKaMX+XKxxAmBLrH0fNfXvdCtuvxj+N2PiBKqXy8VpmBsmEUzeR+TJsz02joi5B9ns0k6TEdszIENrr6amGveX9V6MkjQWDlb8O+6+vf/SprP7oNSqZcbBo8ny7JsJ/TSiHV4Kx2srtnAodFRjPNVF43pEqEse3lHZ0NeJMbQeFwZN9MrPcoySSVGNN+1fuMANJxI6toElKmwc45FoWPoq05VYUe+Id3nq/bYHyNmjJt3jd8O+Itv8SbJwyd1vIZk6M2JGARsdrPKuIBQ5DsnWS+MFR8hhALSDpVeA3UBmbsim+EDZsFE4WfVO7dNLdlUDnhH6+AexUFrDj0HN0NRTIrNryvw0Tiom5bOw8MXR/P8R4Q4sUzf4YfQl1OZ1Nv8d80ugzUlR+TQcazEZR81yCjMOJhTojGY30sXnSiBWgpXWITNAuj1goxb+qUKdu2f0NKcuEHN/WzaCnuHFAL8xwJNTaiLi2bZscqlxSCXKEMKArD0hwjEZDRTJGqdFZV/uuIK+BYgX9vSvRR4vdbyl4HjcTN7KujFrm0W+kJNTxwTF1DcYvxC+bI9kuClmNlEP4TwG1N3U4V4c3hK765dtZXuQf4xDtSGxr96B4I5DpZEX0RaJ+e0+/zYJKVJJ1N0M2+ZmjgWQarlK7ZCSlHE392oAjG72H+5uv7im/L0sam+TbPt8JG708FS29K0/EnavogueAABTqidryVm3pC1xvxH7vpqwjfpVyw+Tc
 1MxJK4/2
 42Eh80+7QYbyI0fswNwWQgv9BkyVG949LJPIJ3Uw9mpbAdrAKv9sAaJnhBOZY9jtbYapZjV9nemEVxdSm4SUKgZwXj6Tf8qyLhDtn+DOqf0ZC1hZia+gHgeqbXpxUR/o/mWF4mAsE/S7+1sYpCCvsVCSwTnPiDK583Z3u+1z7HZH4gl0LVtpGcPyogmmrESpO0GOP2IioQmtWZZ/auHwtmppZhP58JLHionqa1GQccw5w2/BWeejptZ5n+X5iS1tC+4vt6rPo3fKnLoGcxrjoOCvlI6t+Cg2xfZN1p47DYdiyXFb1cX27Haa4I2KmzkaCKlbXkMYGNsdkKQORBwHHdJIRB1S8fwvC+QljLuh/3sNtABUHj6vcHR9O++dOmTBjghDQyw8EpbG4jpGl+zrJL8TiCQqHAHAmnvDCY1g5pFMVdCzzdT9xm8SCFHpUc1JoDLayfw6+gVcjDKbN56hj0Vf5Gfd8S/QPJavPjlZijZf0KF7GI7tzfMwL2vSHmT1Szy3Noig8nZEXaowhlw8c8NN08nEvaqtph3NwYmSMu6HdYG+C4KkxbzGF+1OhsVy2GvlfiWOomgIwaDRF4DnyVeuSPk7sIY8Syi4NONNn+XwKlkgRbCafo2xhLhy8adRi6n/mabEhZ2NgXl/yq/TV1XbwvueHL/ALYuhjnMe7ZZPoNOIr5fNnJVD3GklLMpiw5Nv+fyTO55XSoXI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jul 23, 2025, Xiaoyao Li wrote:
>> On 7/23/2025 6:47 PM, Fuad Tabba wrote:
>
> ...
>
>> > +	if (max_level == PG_LEVEL_4K)
>> > +		return max_level;
>> > +
>> > +	return min(max_level,
>> > +		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
>> >   }
>> 
>> I don't mean to want a next version.
>> 
>> But I have to point it out that, the coco_level stuff in the next patch
>> should be put in this patch actually. Because this patch does the wrong
>> thing to change from
>> 
>> 	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>> 	if (req_max_level)
>> 		max_level = min(max_level, req_max_level);
>> 
>> to
>> 
>> 	return min(max_level,
>> 		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
>
> Gah, nice catch.  Let's do one more version (knock wood).  I have no objection
> to fixing up my own goof, but the selftest needs to be reworked too, and I think
> it makes sense for Paolo to grab this directly.  The fewer "things" we need to
> handoff to Paolo, the better.
>
> The fixup will generate a minor conflict, but it's trivial to resolve, and the
> resting state should end up identical.
>
> As fixup:
>
> ---
>  arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6148cc96f7d4..c4ff8b4028df 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3305,9 +3305,9 @@ static u8 kvm_max_level_for_order(int order)
>  static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>  					const struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> +	u8 max_level, coco_level;
>  	struct page *page;
>  	kvm_pfn_t pfn;
> -	u8 max_level;
>  
>  	/* For faults, use the gmem information that was resolved earlier. */
>  	if (fault) {
> @@ -3331,8 +3331,16 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
>  	if (max_level == PG_LEVEL_4K)
>  		return max_level;
>  
> -	return min(max_level,
> -		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
> +	/*
> +	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
> +	 * restrictions.  A return of '0' means "no additional restrictions", to
> +	 * allow for using an optional "ret0" static call.
> +	 */
> +	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> +	if (coco_level)
> +		max_level = min(max_level, coco_level);
> +
> +	return max_level;
>  }
>  
>  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>
> base-commit: f937c99dad18339773f18411f2a0193b5db8b581
> -- 
>
> Or a full patch:
>
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 23 Jul 2025 11:47:06 +0100
> Subject: [PATCH] KVM: x86/mmu: Enforce guest_memfd's max order when recovering
>  hugepages
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
> ---
>  arch/x86/kvm/mmu/mmu.c          | 91 ++++++++++++++++++++-------------
>  arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>  3 files changed, 58 insertions(+), 37 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 20dd9f64156e..c4ff8b4028df 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3302,31 +3302,63 @@ static u8 kvm_max_level_for_order(int order)
>  	return PG_LEVEL_4K;
>  }
>  
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> -					u8 max_level, int gmem_order)
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +					const struct kvm_memory_slot *slot, gfn_t gfn)

Would you consider renaming this kvm_max_gmem_mapping_level()? Or
something that doesn't limit the use of this function to private memory?

>  {
> -	u8 req_max_level;
> +	u8 max_level, coco_level;
> +	struct page *page;
> +	kvm_pfn_t pfn;
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
> +
> +		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
> +		if (r)
> +			return PG_LEVEL_4K;
> +
> +		if (page)
> +			put_page(page);

When I was working on this, I added a kvm_gmem_mapping_order() [1] where
guest_memfd could return the order that this gfn would be allocated at
without actually doing the allocation. Is it okay that an
allocation may be performed here?

[1] https://lore.kernel.org/all/20250717162731.446579-13-tabba@google.com/

> +
> +		max_level = kvm_max_level_for_order(max_order);
> +	}
>  
> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
>  	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> +		return max_level;

I think the above line is a git-introduced issue, there probably
shouldn't be a return here.

>  
> -	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> -	if (req_max_level)
> -		max_level = min(max_level, req_max_level);
> +	/*
> +	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
> +	 * restrictions.  A return of '0' means "no additional restrictions", to
> +	 * allow for using an optional "ret0" static call.
> +	 */
> +	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
> +	if (coco_level)
> +		max_level = min(max_level, coco_level);
>  

This part makes sense :)

>  	return max_level;
>  }
>  
> -static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
> -				       const struct kvm_memory_slot *slot,
> -				       gfn_t gfn, int max_level, bool is_private)
> +int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +			      const struct kvm_memory_slot *slot, gfn_t gfn)
>  {
>  	struct kvm_lpage_info *linfo;
> -	int host_level;
> +	int host_level, max_level;
> +	bool is_private;
> +
> +	lockdep_assert_held(&kvm->mmu_lock);
> +
> +	if (fault) {
> +		max_level = fault->max_level;
> +		is_private = fault->is_private;
> +	} else {
> +		max_level = PG_LEVEL_NUM;
> +		is_private = kvm_mem_is_private(kvm, gfn);
> +	}
>  
>  	max_level = min(max_level, max_huge_page_level);
>  	for ( ; max_level > PG_LEVEL_4K; max_level--) {
> @@ -3335,25 +3367,16 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>  			break;
>  	}
>  
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
>  	if (is_private)
> -		return max_level;
> -
> -	if (max_level == PG_LEVEL_4K)
> -		return PG_LEVEL_4K;
> -
> -	host_level = host_pfn_mapping_level(kvm, gfn, slot);
> +		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> +	else
> +		host_level = host_pfn_mapping_level(kvm, gfn, slot);
>  	return min(host_level, max_level);
>  }
>  
> -int kvm_mmu_max_mapping_level(struct kvm *kvm,
> -			      const struct kvm_memory_slot *slot, gfn_t gfn)
> -{
> -	bool is_private = kvm_slot_has_gmem(slot) &&
> -			  kvm_mem_is_private(kvm, gfn);
> -
> -	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
> -}
> -
>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> @@ -3374,9 +3397,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	 * Enforce the iTLB multihit workaround after capturing the requested
>  	 * level, which will be used to do precise, accurate accounting.
>  	 */
> -	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
> -						       fault->gfn, fault->max_level,
> -						       fault->is_private);
> +	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, fault,
> +						     fault->slot, fault->gfn);
>  	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
>  		return;
>  
> @@ -4564,8 +4586,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>  	}
>  
>  	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> -	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
> -							 fault->max_level, max_order);
> +	fault->max_level = kvm_max_level_for_order(max_order);
>  
>  	return RET_PF_CONTINUE;
>  }
> @@ -7165,7 +7186,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  		 * mapping if the indirect sp has level = 1.
>  		 */
>  		if (sp->role.direct &&
> -		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
> +		    sp->role.level < kvm_mmu_max_mapping_level(kvm, NULL, slot, sp->gfn)) {
>  			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
>  
>  			if (kvm_available_flush_remote_tlbs_range())
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 65f3c89d7c5d..b776be783a2f 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	return r;
>  }
>  
> -int kvm_mmu_max_mapping_level(struct kvm *kvm,
> +int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>  			      const struct kvm_memory_slot *slot, gfn_t gfn);
>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7f3d7229b2c1..740cb06accdb 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1813,7 +1813,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
>  		if (iter.gfn < start || iter.gfn >= end)
>  			continue;
>  
> -		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
> +		max_mapping_level = kvm_mmu_max_mapping_level(kvm, NULL, slot, iter.gfn);
>  		if (max_mapping_level < iter.level)
>  			continue;
>  
>
> base-commit: 84ca709e4f4d54aae3b8d4df74490d8d3d2b1272
> --

