Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D6EC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BE886B0093; Wed, 23 Jul 2025 04:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16F776B0095; Wed, 23 Jul 2025 04:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0368E6B0098; Wed, 23 Jul 2025 04:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDF346B0093
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:33:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91D4EC05EF
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:33:59 +0000 (UTC)
X-FDA: 83694866598.08.F963A38
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7B24C0003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:33:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hXV16EC6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of maz@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753259637; a=rsa-sha256;
	cv=none;
	b=GrBKdSP4olLGtrImEzW0CT1rzzOB7nL0j2LaSpSWxqXH8wNBukFRdHZWQMVnxrQ1CC7eGO
	ek5Enfw3eNZs3gNYZBi6ycx4MJTuyZ+anGprSdxZOia4pkuUHKuWE7b48haHmrebi8baIf
	j1gHx382NkeuxwUza0+VnOwwd8zwejk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hXV16EC6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of maz@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753259637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eETIRW4Kn9b7fHVbbNmxWqwQZSGsMZNcTcM0v9b3zKA=;
	b=hOXaduzIuqUq9GgTwgQlgOFA76ZzxuwJdyLjr2E/hUpwdtwIRgl4ZB8hpRiv+rF9qkM7pP
	3jtWm333Jl3JMpoaGBi+5YAM1Vu+ApoBaHl0/hP5ZZvtwLAuIeUDcQhRwwRnFr0MaMlBZM
	TrUXG2rfMtdfAGITRVTaJA1jLswxSlg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id BA744A512B0;
	Wed, 23 Jul 2025 08:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB3BC4CEE7;
	Wed, 23 Jul 2025 08:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753259636;
	bh=8Dj52SAogJGQh3xmjRNC4R33WTgHXzlpdB0NAScPbI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hXV16EC6m4qnERBrLnOWVlGSbOmsgOxEJhqSzFXLIfpZOppkIJfcTRfnON2d3YZy3
	 8+3PLRZG+tIv+vlRbfywyYBpOLG5PdqpqL+69smnb1t4lv563WrWTy4kdvNCgXAeZa
	 v/NhagD8XtwD0y8cCcF/esFWJvhJu/S04B18Sg69Wm4CFjiVo4IxM6mlDUSAVOZEqn
	 Ii/1iRjp6pNlXVdNQdp+qszobiL9UP4iaZdDML+RP2i+H9mFRypJXA+3ljDx+XwUyh
	 1s3bitqk69soQA1Tc/uJSK8LDhZSG1115YchQ+BW68eQ4SYZxIGjr5Xrc1nf30Ah10
	 EWhXZmS/QYvZg==
Received: from 82-132-236-66.dab.02.net ([82.132.236.66] helo=lobster-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ueUvB-000bwg-Jh;
	Wed, 23 Jul 2025 09:33:54 +0100
Date: Wed, 23 Jul 2025 09:33:44 +0100
Message-ID: <87ldoftifr.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	pbonzini@redhat.com,
	chenhuacai@kernel.org,
	mpe@ellerman.id.au,
	anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	seanjc@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	xiaoyao.li@intel.com,
	yilun.xu@intel.com,
	chao.p.peng@linux.intel.com,
	jarkko@kernel.org,
	amoorthy@google.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	mic@digikod.net,
	vbabka@suse.cz,
	vannapurve@google.com,
	ackerleytng@google.com,
	mail@maciej.szmigiero.name,
	david@redhat.com,
	michael.roth@amd.com,
	wei.w.wang@intel.com,
	liam.merwick@oracle.com,
	isaku.yamahata@gmail.com,
	kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com,
	steven.price@arm.com,
	quic_eberman@quicinc.com,
	quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	yuzenghui@huawei.com,
	oliver.upton@linux.dev,
	will@kernel.org,
	qperret@google.com,
	keirf@google.com,
	roypat@amazon.co.uk,
	shuah@kernel.org,
	hch@infradead.org,
	jgg@nvidia.com,
	rientjes@google.com,
	jhubbard@nvidia.com,
	fvdl@google.com,
	hughd@google.com,
	jthoughton@google.com,
	peterx@redhat.com,
	pankaj.gupta@amd.com,
	ira.weiny@intel.com
Subject: Re: [PATCH v15 18/21] KVM: arm64: Enable host mapping of shared guest_memfd memory
In-Reply-To: <20250717162731.446579-19-tabba@google.com>
References: <20250717162731.446579-1-tabba@google.com>
	<20250717162731.446579-19-tabba@google.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 82.132.236.66
X-SA-Exim-Rcpt-To: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, qu
 ic_pderr
 in@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Stat-Signature: 93f4rtjnbscqqkghn5xx4h1tu98y8wyu
X-Rspam-User: 
X-Rspamd-Queue-Id: C7B24C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1753259637-67024
X-HE-Meta: U2FsdGVkX1/+PsWIIEjliWTlphEIj9mx9jGm4WcAEqPoD+cKDgvc60L1yhwUtti2vr2GoK69HapS+2MQcuoUu22MnKlWXR15qOE6rE22xmK4po9S36mc06//lqrCVahqeeQj/RFyJC0tJN3wsfx4IzklfR+W2yDaCppGPoiJIQbFf04lWdTBD6Zsp4w2VTNeYaiXy79zVtL2mWrG5Zvwl8ZJQJ1IcyK3/jbwNNJdiCKwlGx1nLsMLvN5HeSuAWPoCu8KsFsMA9gRNHrHlTtfbBXmeDOD6DucN5DgyCZV0BpAX5udPj/58EfzTTvLo5EyfGmlF29CFuDsQl9YCMsMu5/iRwL8/nsvNq9JguMLli/yB41hjdhW+93bS7pHTiy74Gg2hH1va1vZ5bK3QhG0mDLx4Qv1bPh4QwlxWGa4IExu8EhnOPhiQl9SL1j0acAR7XK1bksNG/nqN/YTOtHPfqGI+71lo7eKGZ8Eeh9Vbycezsnjd5WR0GCG4tMFFfH0Z+P49tsuLD6TQehlRhOXhSKyNPyyErWnn4lnkmw82D+64CMsL49qr1iEyVH+0fEKP99/TwEVR+HL0TE54jbSG59EnsG3OOJYvd++6dDhMFTZV3bK3BJM0v1m+nwb1s2XaW4Lw4l0C7pNhw3jHNx/iRj2EcZ8hic143KJMTWw/r7dEQ5lg/MZhgYZYekKv1tPWK66i7Orp/j5Kp5vhuVfE26PNGS3QucCNEvfAb5kkKdG+nzzRnf0oCUxm+p0NxzIbEPJqWmDf+7ipoCHWF9Hetcm8vG5kmZYytyCt0l4QUZCxjQdgM2aIO8HTtZfGVdeYqAXDE2P4uupaZBA3C4/P5O2uczLE5z5P3FKZnMdvnAL4oAwmzvxK/rFjpC2i5rf2Wtz8AIWhJ4xGozZIo4KYQ8qANmoNGtEc0X5oZNQioDg1FX613Lb1hrnXwpNmpXrDIGsv1t+WwpbpcPgScU
 ATQXjTbw
 j+8Q+k05f3Zd5f4ViRuEK5jN0nTInVrfjd3O2eI0w7WGdCP0cTfIlaoK48KgglBTSRQvWpr06gbulc2/zdZr2euN06H2T0XLwL9d+PMsTu7JIH+O9B08jevlubEC5Pg0SGh034yZS4tbOOhGShiRCMB67I9Wj591gz6zfCDfreRystYFVOYa4PvS3XwYylo4uYKjiCiNhuw07mafmV837RLpqnasCoHeqhejLGKaiGfM6lDXyGNWZmya+Mq+lhuWSpRuvCZwvsQHE68lbquwTcyxrKXIYQRF11boSLOgTOfaFQck1Aq57v1sQ0ETbaPaAMoELSct+fvifiDxZRM7/qREP58TWVgLAp7qEq6zvVZHjTNg5CqG8glGmR915NKmclbeMVoG7hVqhHJbtO3keicIMRFMnBmgpqw4j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Jul 2025 17:27:28 +0100,
Fuad Tabba <tabba@google.com> wrote:
> 
> Enable host userspace mmap support for guest_memfd-backed memory on
> arm64. This change provides arm64 with the capability to map guest
> memory at the host directly from guest_memfd:
> 
> * Define kvm_arch_supports_gmem_mmap() for arm64: The
>   kvm_arch_supports_gmem_mmap() macro is defined for arm64 to be true if
>   CONFIG_KVM_GMEM_SUPPORTS_MMAP is enabled. For existing arm64 KVM VM
>   types that support guest_memfd, this enables them to use guest_memfd
>   with host userspace mappings. This provides a consistent behavior as
>   there are currently no arm64 CoCo VMs that rely on guest_memfd solely
>   for private, non-mappable memory. Future arm64 VM types can override
>   or restrict this behavior via the kvm_arch_supports_gmem_mmap() hook
>   if needed.
> 
> * Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in arm64 Kconfig.
> 
> * Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Checks are
>   added to ensure that if guest_memfd is enabled on arm64,
>   KVM_GMEM_SUPPORTS_MMAP must also be enabled. This means
>   guest_memfd-backed memory slots on arm64 are currently only supported
>   if they are intended for shared memory use cases (i.e.,
>   kvm_memslot_is_gmem_only() is true). This design reflects the current
>   arm64 KVM ecosystem where guest_memfd is primarily being introduced
>   for VMs that support shared memory.
> 
> Reviewed-by: James Houghton <jthoughton@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 4 ++++
>  arch/arm64/kvm/Kconfig            | 2 ++
>  arch/arm64/kvm/mmu.c              | 7 +++++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3e41a880b062..63f7827cfa1b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1674,5 +1674,9 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
>  void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
>  void check_feature_map(void);
>  
> +#ifdef CONFIG_KVM_GMEM
> +#define kvm_arch_supports_gmem(kvm) true
> +#define kvm_arch_supports_gmem_mmap(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP)
> +#endif

nit: these two lines should be trivially 'true', and the #ifdef-ery
removed, since both KVM_GMEM and KVM_GMEM_SUPPORTS_MMAP are always
selected, no ifs, no buts.

>  
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 713248f240e0..323b46b7c82f 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -37,6 +37,8 @@ menuconfig KVM
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>  	select SCHED_INFO
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
> +	select KVM_GMEM
> +	select KVM_GMEM_SUPPORTS_MMAP
>  	help
>  	  Support hosting virtualized guest machines.
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8c82df80a835..85559b8a0845 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2276,6 +2276,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
>  		return -EFAULT;
>  
> +	/*
> +	 * Only support guest_memfd backed memslots with mappable memory, since
> +	 * there aren't any CoCo VMs that support only private memory on arm64.
> +	 */
> +	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> +		return -EINVAL;
> +
>  	hva = new->userspace_addr;
>  	reg_end = hva + (new->npages << PAGE_SHIFT);
>  

Otherwise,

Reviewed-by: Marc Zyngier <maz@kernel.org>

	M.

-- 
Jazz isn't dead. It just smells funny.

