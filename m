Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2836CC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80206B035C; Thu, 24 Jul 2025 19:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57FA6B035D; Thu, 24 Jul 2025 19:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D4B6B035E; Thu, 24 Jul 2025 19:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86D046B035C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:34:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B687133BA2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:34:21 +0000 (UTC)
X-FDA: 83700764322.17.DA6E1CE
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id 60F9320002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:34:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=19kQxBGO;
	spf=pass (imf13.hostedemail.com: domain of 3-sKCaAsKCNU13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3-sKCaAsKCNU13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOC/P/oGXAoRRZqdH8GHzQvdWeyyCWYievctnkwxwC4=;
	b=wIMEIyGAZYUc14HFsW9RBQ4I8wOOcxIIehE+0rFjeAo1JcC2JAx7FX0WPTGnnMFrNUdYv0
	MWqdfy9JubwL832iJ3RKLGOC40hRyIZ69CARediD02C7DYxqyy+T2VIt5YrS1TOeD6Fu+j
	uf0EXKWqVhDsxdSF+wac2t2yO/1WftQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400059; a=rsa-sha256;
	cv=none;
	b=OAKCR7mmoNMXY1GQCIuKnO7282rdPapWrh2onIzAGhYslLdUiunrV9khzEgN2AdL2p60WD
	huYfUxrowyJmL2E3Qsp8ZLmdqV/WYg8M5XejukWtCimaj3cDc7oDEdCXKTp2CgmhgYWhq6
	HrnduIl7q7P433NMhOX4EjAQrcK5ZB4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=19kQxBGO;
	spf=pass (imf13.hostedemail.com: domain of 3-sKCaAsKCNU13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3-sKCaAsKCNU13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-749177ad09fso668999b3a.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753400058; x=1754004858; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AOC/P/oGXAoRRZqdH8GHzQvdWeyyCWYievctnkwxwC4=;
        b=19kQxBGODnNFiyeIxwyTdk1m8/eDXJreZFeBUhAYmbylW+K29vQw2T/P9d835l2brq
         sWWgd0wBv86xcArINK9dDWnu24fatdUbB35hq234GLe6vsnK8DHd1V9DF+zXWVZX5jU1
         7tsZPnWy6qBqMcpUTPa5duExrRfuRwY5hdRXrui6OEzKhyN1blYkBdUgJ897EOmpwMi5
         MjxjtcEaMGp4yRKMRU+wZljCQwX+A4mOosKn+ceLA4pF1xXIufl598iz4OcdjxUMW9S8
         1l3G/1bjbGCV78vQEiXcLCnva+Z3lQCpnr8JbkjcDevG6c0v4BNgqWrUBcYgB0kKgfjL
         kDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400058; x=1754004858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AOC/P/oGXAoRRZqdH8GHzQvdWeyyCWYievctnkwxwC4=;
        b=u7/Ou9CpF+L91+/carNmv2ILvWXy8nPBbXQ/i5aYMUGV2aoil+2g+a96W4IvjQECvy
         +QgD8x2efP7+69wsqbaYzEW0TqJioLi9RbPNGumr+tClFMkfseN/9yGE9HcMyfb5S0/h
         WVwTyCNwkeC3MUoHLWiUWQHxjjrtu/XavTSXH3ZDQeL7+QtTxXnkbn6c6Vod95YSffcb
         mM8QpfYFZ5Fr528OKWT7+8am7guuSV7O3Sv0e9Bsik5Kjg7HW9IptWG+ol6JayUTWKbr
         9O6R6L0CXhpAsO9+0CtgqHCAtUOaCNNZwWnXa/gl9gqdJ+h5TQQpzWOLnEykFEJ7MRKt
         heAw==
X-Forwarded-Encrypted: i=1; AJvYcCW+c+nfN2Ddp3YvAMTmP6NHpXFSvknVtESI9qLURUGomS/DlEPfkQ3jQCST+8nTEgfDtgfRTpHM/g==@kvack.org
X-Gm-Message-State: AOJu0YznVP+5kdNvnRIIQsNGrm/Svao4U2RCZ+tDZQ9uqj3YoRwBDZe6
	cz6VQiAVmGL3UikXiXUQPIStOO8X3PrSwjq/NjNfdeYyhEe3SUFNw4aSxIV/IJXJs2HrBqZW8kt
	SOYFthFAH7Q409YlkOHIwKd5TmQ==
X-Google-Smtp-Source: AGHT+IHY5fZQ+2KvhBreA+9T2uYUREVCLpgYaImwQk0f+GpHuDd/3+UjiagOjIEkhCM9MDPNsi5LdrO2naMGArQC7A==
X-Received: from pfbfj9.prod.google.com ([2002:a05:6a00:3a09:b0:748:e8fc:e9f0])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:c85:b0:736:51ab:7aed with SMTP id d2e1a72fcca58-760353d0942mr12321101b3a.16.1753400058101;
 Thu, 24 Jul 2025 16:34:18 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:34:16 -0700
In-Reply-To: <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
 <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
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
X-Rspamd-Queue-Id: 60F9320002
X-Stat-Signature: g6zr61w4u3di41w54eeyrs5bnzdxkq6q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753400059-969622
X-HE-Meta: U2FsdGVkX1/hQcNSa6wKFKRc+bCLsl5CL293KzAzZO2qFz3CB44L+NdIoQdTMMerSwaE1wO2MF+r5rQmQzucgdQZr1jZ1kbH1kgVKJx1Hx6b19SoNGNvVcn9CmfNMQuS6cjpoIFQojdGJ0rYoCTuKq3wZGzwl5puX0tF2742ZX9wJYImHJTTB8G1oYxMHWV4GG5V5dPfQLwKi9f2f3F4Q8DLa6vt0eqaV0wzThGWwc0IWXOzA6EWvZW8cnm6AAySZ4UR/qG+VikNZ7bYKaEMA/EdDcdSgHLG0Y1KIcnNxCvVduL5jpNvJ7lNG+5RzoQ3l7fi4OoEyAjDalgKGinhtJxKaDnDhNTKJkqp5dmKkUHXcjkiFZ+l8E2BvRqx7wAO/rOsTvOSn9R/hAjBO8BkRZTvyEAj+cyvDqMl9iJtVTRuavnMmlh85ChHf9v+9CESjoQffcN2poCv7Mmusi1k0b93O2jzkeb3oV47AH8ZBHko617TlO3wSp+jkRjkln33q3OVHp5NpMAa5S12zfVpzn3Q/xv8IvwtOd2RKalbKh5RPjtaYgI5mMvqcOjs+gac3iieRYNH/cdtuutlIw471/U7/SSt1bJbpGM/IABIIbygVPm6w0pwz1nX/MdN4Y7mVPzlNnVZ3/rjxgMDEzaUaEMRhrsDWZHNC2d35SyjpftB62DvufMK3CPuLQLUCjQoGpsejvR2oa6tQJoRCPK/povqdKCmX+HAMJWbwsQyNcpqBFQdr84FVqrdfDBQuJYJI/KgLz/42nutzLcro9nmqdSZguPL2qXGuDU6ZavQCvGrkrdCaP/fxq7Z/ERXvAfOgY866vgVWf+/qxxh3RQIH3eEkqatw3E/4Na8iXrKge4PYNZq7kv5G3QqiIXM9EMq/tYUOdplOdkXhxPy77qDBhnFa239bTHyDrQHbEsGCL57BHmgas8WaYvb0Ly5+TaLI1i2lfvGa1q3dgMLb1F
 ao5nl0Dc
 dfVSuYCC5UbgwTDSg2naLvKMpd6UsAEaB8JXIuSt9bcQr8r3QwIPS0bUEAv4ClAMxl82zivhWe4mLxz1wFsgPvUFsxGO/wz8N8CSmtu1bOoNB9HAmVBBKsa4cy2I3J0DtAnRxSnjlfq0GjhpthvEp2HsEY/6wCziM8yW+cY78h+Z0avd90hqo2qsjM+NC3wg2201Ij56IGczeE0woa6SZp7XQ1xdn/RMyWcfpiit13lX1TgEyIA/1IIcHAOa0U9D0DMY5oKf+pPZHrkgn3hGH8prHf/6obtJLEPO8LYauwgsXrFz/u4aJD8c246m67d7hTtDvcuNB2MNCVuBYODSZlTn54rVOgrJYzBFYdAoshxOTcRy2UbmT+49UKbvNg/715OLQSv3LiP02BcdxGZcMzDK03q/vSwqWTp7FQOzP5sfpYwetiCluHfUrD+BjJAvd3G3sns7j+qSwX+a9Tl+TDVp0P1JuqtExQlXSMo/9s1k3opgJUv5dBlABKM9TOLnP+2CxM1FVeslbpAZWhHDGGfyszQoOnt+75C/Vdnj1Nm6KgI54OHsLhGyW0++HJM5ibocZTHFoT3Cu8TRMHE+R7Pk8aekPVGDRJCARW56v1E9vxdsu+OwM0xwePbUN77Sr5SxFELxWQ674VCa6MMdoDHWHlb3I3VwcerCsrwFHjC+G2t4/L1aeiKtz1vpDTZO0x49Y9/Z44hm09iM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Sean Christopherson <seanjc@google.com> writes:
>
>> On Wed, Jul 23, 2025, Xiaoyao Li wrote:
>>> On 7/23/2025 6:47 PM, Fuad Tabba wrote:
>>
>> ...
>>
>>> > +	if (max_level == PG_LEVEL_4K)
>>> > +		return max_level;
>>> > +
>>> > +	return min(max_level,
>>> > +		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
>>> >   }
>>> 
>>> I don't mean to want a next version.
>>> 
>>> But I have to point it out that, the coco_level stuff in the next patch
>>> should be put in this patch actually. Because this patch does the wrong
>>> thing to change from
>>> 
>>> 	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>>> 	if (req_max_level)
>>> 		max_level = min(max_level, req_max_level);
>>> 
>>> to
>>> 
>>> 	return min(max_level,
>>> 		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
>>
>> Gah, nice catch.  Let's do one more version (knock wood).  I have no objection
>> to fixing up my own goof, but the selftest needs to be reworked too, and I think
>> it makes sense for Paolo to grab this directly.  The fewer "things" we need to
>> handoff to Paolo, the better.
>>
>> The fixup will generate a minor conflict, but it's trivial to resolve, and the
>> resting state should end up identical.
>>
>> As fixup:
>>
>> ---
>>  arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
>>  1 file changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 6148cc96f7d4..c4ff8b4028df 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3305,9 +3305,9 @@ static u8 kvm_max_level_for_order(int order)
>>  static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>>  					const struct kvm_memory_slot *slot, gfn_t gfn)
>>  {
>> +	u8 max_level, coco_level;
>>  	struct page *page;
>>  	kvm_pfn_t pfn;
>> -	u8 max_level;
>>  
>>  	/* For faults, use the gmem information that was resolved earlier. */
>>  	if (fault) {
>> @@ -3331,8 +3331,16 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
>>  	if (max_level == PG_LEVEL_4K)
>>  		return max_level;
>>  
>> -	return min(max_level,
>> -		   kvm_x86_call(gmem_max_mapping_level)(kvm, pfn));
>> +	/*
>> +	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
>> +	 * restrictions.  A return of '0' means "no additional restrictions", to
>> +	 * allow for using an optional "ret0" static call.
>> +	 */
>> +	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>> +	if (coco_level)
>> +		max_level = min(max_level, coco_level);
>> +
>> +	return max_level;
>>  }
>>  
>>  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>>
>> base-commit: f937c99dad18339773f18411f2a0193b5db8b581
>> -- 
>>
>> Or a full patch:
>>
>> From: Sean Christopherson <seanjc@google.com>
>> Date: Wed, 23 Jul 2025 11:47:06 +0100
>> Subject: [PATCH] KVM: x86/mmu: Enforce guest_memfd's max order when recovering
>>  hugepages
>>
>> Rework kvm_mmu_max_mapping_level() to consult guest_memfd (and relevant)
>> vendor code when recovering hugepages, e.g. after disabling live migration.
>> The flaw has existed since guest_memfd was originally added, but has gone
>> unnoticed due to lack of guest_memfd hugepage support.
>>
>> Get all information on-demand from the memslot and guest_memfd instance,
>> even though KVM could pull the pfn from the SPTE.  However, the max
>> order/level needs to come from guest_memfd, and using kvm_gmem_get_pfn()
>> avoids adding a new gmem API, and avoids having to retrieve the pfn and
>> plumb it into kvm_mmu_max_mapping_level() (the pfn is needed for SNP to
>> consult the RMP).
>>
>> Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
>> as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
>> i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
>> exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
>> of the gfn.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>  arch/x86/kvm/mmu/mmu.c          | 91 ++++++++++++++++++++-------------
>>  arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>>  3 files changed, 58 insertions(+), 37 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 20dd9f64156e..c4ff8b4028df 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3302,31 +3302,63 @@ static u8 kvm_max_level_for_order(int order)
>>  	return PG_LEVEL_4K;
>>  }
>>  
>> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
>> -					u8 max_level, int gmem_order)
>> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>> +					const struct kvm_memory_slot *slot, gfn_t gfn)
>
> Would you consider renaming this kvm_max_gmem_mapping_level()? Or
> something that doesn't limit the use of this function to private memory?
>
>>  {
>> -	u8 req_max_level;
>> +	u8 max_level, coco_level;
>> +	struct page *page;
>> +	kvm_pfn_t pfn;
>>  
>> -	if (max_level == PG_LEVEL_4K)
>> -		return PG_LEVEL_4K;
>> +	/* For faults, use the gmem information that was resolved earlier. */
>> +	if (fault) {
>> +		pfn = fault->pfn;
>> +		max_level = fault->max_level;
>> +	} else {
>> +		/* TODO: Constify the guest_memfd chain. */
>> +		struct kvm_memory_slot *__slot = (struct kvm_memory_slot *)slot;
>> +		int max_order, r;
>> +
>> +		r = kvm_gmem_get_pfn(kvm, __slot, gfn, &pfn, &page, &max_order);
>> +		if (r)
>> +			return PG_LEVEL_4K;
>> +
>> +		if (page)
>> +			put_page(page);
>
> When I was working on this, I added a kvm_gmem_mapping_order() [1] where
> guest_memfd could return the order that this gfn would be allocated at
> without actually doing the allocation. Is it okay that an
> allocation may be performed here?
>
> [1] https://lore.kernel.org/all/20250717162731.446579-13-tabba@google.com/
>
>> +
>> +		max_level = kvm_max_level_for_order(max_order);
>> +	}
>>  
>> -	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
>>  	if (max_level == PG_LEVEL_4K)
>> -		return PG_LEVEL_4K;
>> +		return max_level;
>
> I think the above line is a git-introduced issue, there probably
> shouldn't be a return here.
>

My bad, this is a correct short-circuiting of the rest of the function
since there's no smaller PG_LEVEL than PG_LEVEL_4K.

>>  
>> -	req_max_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>> -	if (req_max_level)
>> -		max_level = min(max_level, req_max_level);
>> +	/*
>> +	 * CoCo may influence the max mapping level, e.g. due to RMP or S-EPT
>> +	 * restrictions.  A return of '0' means "no additional restrictions", to
>> +	 * allow for using an optional "ret0" static call.
>> +	 */
>> +	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn);
>> +	if (coco_level)
>> +		max_level = min(max_level, coco_level);
>>  
>
> This part makes sense :)
>
>>  	return max_level;
>>  }
>>  
>> -static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>> -				       const struct kvm_memory_slot *slot,
>> -				       gfn_t gfn, int max_level, bool is_private)
>> +int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>> +			      const struct kvm_memory_slot *slot, gfn_t gfn)
>>  {
>>  	struct kvm_lpage_info *linfo;
>> -	int host_level;
>> +	int host_level, max_level;
>> +	bool is_private;
>> +
>> +	lockdep_assert_held(&kvm->mmu_lock);
>> +
>> +	if (fault) {
>> +		max_level = fault->max_level;
>> +		is_private = fault->is_private;
>> +	} else {
>> +		max_level = PG_LEVEL_NUM;
>> +		is_private = kvm_mem_is_private(kvm, gfn);
>> +	}
>>  
>>  	max_level = min(max_level, max_huge_page_level);
>>  	for ( ; max_level > PG_LEVEL_4K; max_level--) {
>> @@ -3335,25 +3367,16 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>>  			break;
>>  	}
>>  
>> +	if (max_level == PG_LEVEL_4K)
>> +		return PG_LEVEL_4K;
>> +
>>  	if (is_private)
>> -		return max_level;
>> -
>> -	if (max_level == PG_LEVEL_4K)
>> -		return PG_LEVEL_4K;
>> -
>> -	host_level = host_pfn_mapping_level(kvm, gfn, slot);
>> +		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
>> +	else
>> +		host_level = host_pfn_mapping_level(kvm, gfn, slot);
>>  	return min(host_level, max_level);
>>  }
>>  
>> -int kvm_mmu_max_mapping_level(struct kvm *kvm,
>> -			      const struct kvm_memory_slot *slot, gfn_t gfn)
>> -{
>> -	bool is_private = kvm_slot_has_gmem(slot) &&
>> -			  kvm_mem_is_private(kvm, gfn);
>> -
>> -	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
>> -}
>> -
>>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>>  {
>>  	struct kvm_memory_slot *slot = fault->slot;
>> @@ -3374,9 +3397,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>>  	 * Enforce the iTLB multihit workaround after capturing the requested
>>  	 * level, which will be used to do precise, accurate accounting.
>>  	 */
>> -	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
>> -						       fault->gfn, fault->max_level,
>> -						       fault->is_private);
>> +	fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, fault,
>> +						     fault->slot, fault->gfn);
>>  	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
>>  		return;
>>  
>> @@ -4564,8 +4586,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>>  	}
>>  
>>  	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
>> -	fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
>> -							 fault->max_level, max_order);
>> +	fault->max_level = kvm_max_level_for_order(max_order);
>>  
>>  	return RET_PF_CONTINUE;
>>  }
>> @@ -7165,7 +7186,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>>  		 * mapping if the indirect sp has level = 1.
>>  		 */
>>  		if (sp->role.direct &&
>> -		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
>> +		    sp->role.level < kvm_mmu_max_mapping_level(kvm, NULL, slot, sp->gfn)) {
>>  			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
>>  
>>  			if (kvm_available_flush_remote_tlbs_range())
>> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
>> index 65f3c89d7c5d..b776be783a2f 100644
>> --- a/arch/x86/kvm/mmu/mmu_internal.h
>> +++ b/arch/x86/kvm/mmu/mmu_internal.h
>> @@ -411,7 +411,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>  	return r;
>>  }
>>  
>> -int kvm_mmu_max_mapping_level(struct kvm *kvm,
>> +int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>>  			      const struct kvm_memory_slot *slot, gfn_t gfn);
>>  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>>  void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
>> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
>> index 7f3d7229b2c1..740cb06accdb 100644
>> --- a/arch/x86/kvm/mmu/tdp_mmu.c
>> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
>> @@ -1813,7 +1813,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
>>  		if (iter.gfn < start || iter.gfn >= end)
>>  			continue;
>>  
>> -		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
>> +		max_mapping_level = kvm_mmu_max_mapping_level(kvm, NULL, slot, iter.gfn);
>>  		if (max_mapping_level < iter.level)
>>  			continue;
>>  
>>
>> base-commit: 84ca709e4f4d54aae3b8d4df74490d8d3d2b1272
>> --

