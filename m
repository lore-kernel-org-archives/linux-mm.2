Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2624C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209508E00C1; Thu, 24 Jul 2025 19:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0A58E007C; Thu, 24 Jul 2025 19:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7418E00C1; Thu, 24 Jul 2025 19:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3D1E8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:03:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 605521A0326
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:03:46 +0000 (UTC)
X-FDA: 83700687252.20.C6221F1
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id B1C06120007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:03:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=waQjaUE7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3z7uCaAsKCJw68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3z7uCaAsKCJw68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753398224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISsvFCUycsXMABHVDYSoSHE4WtWUnZpEr5ejibgkla0=;
	b=FUe3fXQEu0pHx8DDGwEISZihpj6IqwVLV3Iou5HyI7tfhKQojvcWLG6qG1JAg5pB/Vzraf
	fI2Dxy+T/YGwimgwGrXtyQjo6uDGL0M3fQLUGv5F6CK8TkRoPO2BXWaLCLsUTtUzDSeDUj
	IhPdtKDM7eCSWioZ3BS3WCzrD8lCVFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753398224; a=rsa-sha256;
	cv=none;
	b=MDpJ6ZhDkMp5ZA6Tn953UlnOo/aE8sgNDlugfVI2XdBtU9LSoKO2xEgHYnNrcaHI8K7GvP
	fr+1v7Uba9RJMWEjUBhW/zw9Hnkksbrr8I9w5OmINTxWkkzpiIxHgjzrsqYHYUaI+lnLma
	v7wwZQNAlufJS0CCXdZJhfCMdaiYNe8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=waQjaUE7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3z7uCaAsKCJw68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3z7uCaAsKCJw68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31bd4c3359so925545a12.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753398223; x=1754003023; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ISsvFCUycsXMABHVDYSoSHE4WtWUnZpEr5ejibgkla0=;
        b=waQjaUE7ucgj0Rh6r6njO021VNg01LhqtXffzjQ4nEJtrozLbkibZF9Znp8jzm3ZJC
         2B5iled/lp11rOofSSsRtcUIzsBwUhZsYjS+J+7/OoZEOnvngm7DYVnXadKrpnlfUWqJ
         MctUCsOYGDpNp0pcKNIM1uEAAoGo0VB4eDcKmiCTUxpOrBiv1uvvJP9wjO/I+RIZvlxl
         eVLxofeL+iGbF2QoOfzPln3mshoZRRU2nKgEYPARKtPeyuIkhANLRqdOU2PgbpxtZDV7
         sCa4RJ4zSQeVDopzj4SMp7y9PSWJdahUQ92EM+4SjEZmRrb3pu1h+ReNAcRW/1MS5pQ6
         Dimg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753398223; x=1754003023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ISsvFCUycsXMABHVDYSoSHE4WtWUnZpEr5ejibgkla0=;
        b=fkxvU7yNqkpyWYnvU76faG1690M4Jb7JikURCu49BqVbK5QAy4jXTD+BVpBHW4H3TU
         JRZwYiYN+0VsC2EtMMEydvU1i3ZTBxJ3hqdjlXwQs07/w5Ra8TSK003J1DVqt0SsEnjP
         YcmpwDVElB7WWlVq2HD2Of661pmSayJpx+MlGP1tBljQ/6Mr3yXRmGTUsUsRSexEr9AR
         zIs24A5sRHQEl8RkCxc3Nu5Ecd7BhIUt1TTjLdwAg4KYeJWH6+XmEmVr5FEBuewHel+z
         7RKskAa2/MJ0xvBBK/Gag9zPJlAWLMrD2kowKT60vbCBYXs1tZkYztFSYv8OpfYonzZr
         Fd2w==
X-Forwarded-Encrypted: i=1; AJvYcCVTZJPio7HHiM0nDNpXwsCpHxjFfwJ5gvV42CLMPOU4vQZqjXf0gAotKEegK1zokoXItXDsQ+8QVQ==@kvack.org
X-Gm-Message-State: AOJu0YzfrSlQbvvWlNbprGwCc14L28cTbw/FsLrCrhGXhkwQixl+Pr9i
	iCpGjGI6oAZJoEW6EqSgr/NOv2cQt3fQLaEEogmnYCn2bH646hSAajusWa9Q16A8i7T+2HPQkXf
	GWunFro/WEXaJVZd38XrZ5Nf3yw==
X-Google-Smtp-Source: AGHT+IHz2z61bSSBHE5WkJFRSn/f5Uz7Cdl50VxK06WJGcmxGFRErbOEdHF7gB/snCT71JrhZi9xeqGE6W9rTkxcyA==
X-Received: from pgam17.prod.google.com ([2002:a05:6a02:2b51:b0:b2f:5023:640d])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:998f:b0:239:eed:43a6 with SMTP id adf61e73a8af0-23d491220ecmr15740822637.22.1753398223391;
 Thu, 24 Jul 2025 16:03:43 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:03:41 -0700
In-Reply-To: <20250723104714.1674617-14-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-14-tabba@google.com>
Message-ID: <diqzldoddwdu.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 13/22] KVM: x86/mmu: Hoist guest_memfd max level/order
 helpers "up" in mmu.c
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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
	pankaj.gupta@amd.com, ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B1C06120007
X-Stat-Signature: krkeczsas6k4pbzjhpksyedzy7r3ixio
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753398224-52531
X-HE-Meta: U2FsdGVkX1/8r+y5VdB9+06B1h36wmlR1N/Ht8QX2/Kw7IDoUGSMcNKrYZnOwf8UWJz5z7xIVvTbVf4BuVHeyQEJc7UiclUKpAjGVJdzTKXmtmy1OLkHq7qpylecsWox72MYxVDPpVfGHf00jn0IYBQfLUinlLM3ZZsoTIzBXYBLPLVcY3IU51Ku3Cuu7p9vLGsM1uWd/eeDN+VVPPJgiTwKwE8BPozZfKdU9wvbp9Wpy34J7iyzQgfT3+hMQwhyRA+AzRJPoX0JPCdDcuCnAZFUZaKg1Hz/wZIQBBmvseavcLjHvxtkm3mmvV2nCrDBsnyUT/IHhlv4K0dkFJxWOcnO13qkhPIRcbi8purcdv5UGgjZIqWTRyDG1ZT98Ux01qjWT/HFhM7rVKcbBt1Ed9d58rwy9rkfuxWQFWd0rPTrhYtqI/TjLmrId/1l8FeMbL1D2xzEi/+af7xfLuVvQwTG1/lMtRKjShWBEDNvPZFKo7RGNI8BHSrh6wKJ6FZCRiaJ95Ek/dj6mlDNhI7g8SZcDLmeQX2Tsf28+wftRwaozDH9AA8p/zqVmRDStESC0Z8BGUS6lie+UXQSmyvyg73k0SoWnQPmJOzVY9fXUwO8FXqd2NZiuMpOZ5INkRcrTjvnCFoYP9FddXmtDa7i1lR3o0PCKZ9dVl1RApLj6BNtEy5KJt0TfXHqs6qlzkRCiSN4nnpJPvHWkdnC130koI3bnowyZnGnDl5Oy5DyJ9BPtN4W/aJQZo0Bq7eqnVOb5r/h/ULHczw/qSmKj54q6EiA7d3se/0h4niP+dzZP5ev4BZHHs4LNInb3p6FrubnwC16D4LdRCepbwObq8CKMmZNrpF9y0QEVw2qTgT3qk8MIg9HhmgQDkgbSZwt7fkkdnrqppE0BS1l7g7eICZAyS8lCFZAxqPjqg+oir1sLEMCsPWCwiVkyq0TLNRvmkRfRzjHDWot+IPTZq3rJyy
 VO6ih/vR
 Hwdgw+ZvWOuEOR0amGMtJa4+wdUroOH4yp5X4Z8fTbdMxjBhF/KyFbzj9lO2emUWSxv6DDT+OZVf+eHcJyzBRWqqYG85jj5p+AgEin7cABz67SZj51IE8Dq3gWPARg2gmSV/EUEtC0605J1xf1hXbQ0KnItxi1fOKJ1H/DG9IstK4HQQkKIzM2HA3Y1dcm/Yj8ge6LQkSAjWrkqZzCOUXesnW85TflzFP+CXM3WXqRT+4gK4qzqzXcWdK3BaCRst8xa9o8ETryGoOgviZaGBHdM32x9yx+GOQLHNm6Y8QRePxON7nrQ5xuxOQgw1vSXP5ZnLAOs1FfpksR8f6LInP9Fj5pZ4Eyt60B4Bm2hqbAPVStfIGH9wggXo+dvBsP9VOZ0+kcyyXNs6BMDzwJfxt0lbr4GIFjhocvNszPgbzk18XOHfPlzFSBVUEW6oEu4wH1Twusg7VQiuGUw35EvERkvhr+p/AkG1pOM21G9wYs5Ef9TuNzYhwRDMSEipPgyEw/cRNe4oTv+a8foD5+oSboPiFWGxgBGe9T+dOuSoWapcT7PIjkECc/sfdSytukwbrbb2OgxVZDGsBz6h7cc1jPXIyx24ZerI+zRSs3Giuv3eprAc59K3cNBYZxSk07AZpYb+hYxih2XktChZqlaomqms5x6BTsNL2AK4fdwZDKDwYsLdh0rasV+GaGvj21Sc5Lb9ScNj9458t0r1ZSMp5neehEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fuad Tabba <tabba@google.com> writes:

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
> ---
>  arch/x86/kvm/mmu/mmu.c | 72 +++++++++++++++++++++---------------------
>  1 file changed, 36 insertions(+), 36 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b735611e8fcd..20dd9f64156e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3285,6 +3285,42 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
>  	return level;
>  }
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
>  static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>  				       const struct kvm_memory_slot *slot,
>  				       gfn_t gfn, int max_level, bool is_private)
> @@ -4503,42 +4539,6 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  		vcpu->stat.pf_fixed++;
>  }
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
>  static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>  				      struct kvm_page_fault *fault, int r)
>  {
> -- 
> 2.50.1.470.g6ba607880d-goog

Reviewed-by: 

