Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C726FC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FCD16B035A; Thu, 24 Jul 2025 19:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4668E007C; Thu, 24 Jul 2025 19:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411126B035C; Thu, 24 Jul 2025 19:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3155B6B035A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:31:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D81BB133742
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:31:26 +0000 (UTC)
X-FDA: 83700756972.07.57B2FEC
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2048180004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:31:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LxpX2eIK;
	spf=pass (imf30.hostedemail.com: domain of 3S8KCaAsKCCYCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3S8KCaAsKCCYCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753399885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yp627SOn/U3DKHH0cx4CozafOSeA3JpbkyrsZdpeeic=;
	b=NnQ8ysieMRdNxspUVIml+JikJZq046kWnbK3wMtJPfZCqy2DZAk3ZyuI1MNgSJ3GeUKLpm
	hy00a9KzmFtW2/5LdF8UqeN0Bp0m80PKgY61tVSBQfvTVAvrVILs+x8JrFprHUHV9jSGqw
	jA/fuC+Ech//5UkGQzQyVcc317LnG5g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LxpX2eIK;
	spf=pass (imf30.hostedemail.com: domain of 3S8KCaAsKCCYCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3S8KCaAsKCCYCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753399885; a=rsa-sha256;
	cv=none;
	b=laiIllgOe/KH2O6PQ5dEWk6YMGZ5pFIGDb5021HgDpeIb7LsFLYYLRkmnbWrlcx0O6s9ay
	rm1gddlCrOmXvbtMVFRskex4hP9TbNvMyORJfRLrlTJtPWDrQnOosCmbDsennNudS0kM08
	WxUgNIqHUIqrGAUmybY6XfCwRQl2vj8=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31cc625817so1933498a12.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753399884; x=1754004684; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yp627SOn/U3DKHH0cx4CozafOSeA3JpbkyrsZdpeeic=;
        b=LxpX2eIKUkJ0suEnvFP5tspm7bTtAYYdDTVg7Nz5rj8oL4EUO851cVLT7Q3twhcdEX
         Wos3dEQtZOayhkm8tuMZ3LYSvC0eMduaNSLe2nMs07l9uq38BZmPgs3sueFBijXMgPc9
         2BZa9Um7CZ+Fagb3j/mvWhhw/oEkQ1GHWXSdWyc2YSavnfl4apD/nh+eF0M0Bn+nAwtN
         ObX8TdAA+1p4rMDQMvGyHsKDqCopuABHc7cYxg4TsKddWEpK61dLhqrzbFkUA1Fa9PH9
         yDmsTpvhOyy0xjwDlN0zr6hkX/RbnPLa9yd/JZb/SqxJmQ9E8duaIeVpw7TwHXc7Eyr/
         uP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753399884; x=1754004684;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yp627SOn/U3DKHH0cx4CozafOSeA3JpbkyrsZdpeeic=;
        b=mcwxxUg33KxvJ10QL6Z4vPwrnG/LHhgdNhySsBbC/Bbi5qim/kxTtA0NnaG/Sl5g2u
         JFQkzP7MELyzLE+bC5tnOq/fbY2r5qLS6xFXdM2nQDoeZaCssoYWn80FH3MkIkrHdjE0
         0E5HQY74O2s0F2+vxFoGKCqPxEhS5cxRnswG+MGB3YZBE/q/01kUcfaaFawIxTTIcrfP
         GNqeP8mu6Ys5P4xJ0oqRVc+8f67Oq3TdIXOminLOd0q11SOWn33yhzDo7HmtPOG3CFaD
         PiB5HNCSXJ2op/9DoBpGrBE9CV4cx7NaQ8LxDVAOBmWQBE9kEifCAJWl0pwku2aWJjoZ
         rwyw==
X-Forwarded-Encrypted: i=1; AJvYcCWbdvoP46aDpnyc/dN3w9QI0+Nqqf8C7b+Vr8cCD3Iw5mLrHcnpKNX+9BTJPUoRz/6sUF90JQoSew==@kvack.org
X-Gm-Message-State: AOJu0YwEDymdcHG9I/p7h6qFFW8FQWDPOeYmt6QvO2hoMImj96PCYMEH
	qPnPfIe93dBjPJAWh5aBvR0ppqb1UlGNOeIbItjxd0PPNq4cIsBAnY5hRVBhpvITh0qbRguFpyX
	6Iif6BscbSTK9JdYzLMJiUklpbQ==
X-Google-Smtp-Source: AGHT+IFvui1Pst0YKPd1yfVqz+NO19tPVE9VTZojkGV++wZpfN6iqbBP+KKwokgJWixSu42pVoJTFycmKkH5wKz+CA==
X-Received: from plei4.prod.google.com ([2002:a17:902:e484:b0:235:e734:e93e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e84a:b0:234:986c:66cf with SMTP id d9443c01a7336-23fa5d33199mr56305505ad.16.1753399883467;
 Thu, 24 Jul 2025 16:31:23 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:31:22 -0700
In-Reply-To: <20250723104714.1674617-16-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
Message-ID: <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
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
X-Stat-Signature: oyy96sd5tmm7qrkjw4trs9cwnnw1w9mc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2048180004
X-Rspam-User: 
X-HE-Tag: 1753399884-573821
X-HE-Meta: U2FsdGVkX19hoJLSyHLrLulQqzinGVkcS7Oje2IzjBhOexATAs2B+MppjmY62Z3q1+w2y9yXFLvv5OkGEkr7W2Mo3hFFsRNGaFy/CRr8OhdiurnFLZlTsrcBin9fW1uA3P6hxZUnf0mcChn59YMsL8zBTE8NHYxDRHOC4ZdyY5MuACHQMLLXOooG5JP6K4fHX+THqtIOD7Dky9SJ1YqMEchl6z0t7Ohhd+uRgBv7FAtVPgs3GI09FBkOmUn5lYBcsBOy6YPOkcXQW6jEbjbzMarAyOJ9VeN/sdX5Fkv6cHkrqSXlN76Pc/fiU6ZuiXjrY71iHUBxEx7huQhfDZQiSrdXVlzm4v/bFc1yjDjqqYYi0WLTfrY45TTqbXKUje222RKWfX7P6mjbDH2rVri51l6QdRh4iPTVvoRiray47Ztn+C3OuboEoP2sCRbFnZ4sO/0xbNFQrbpfdYpdDMbBp0Z0vr3zNl02fF+nWBnj+bOtaBC3YcXpx2lUcmGlSuLB1sOH03lIDXB0DdJKwyVsr0tb1YaT3vNknkNXhFWwhibbUM68gpTTyyEy+/j2UBbF6kTMUfWU2OGaOr/XZq6NIQnQmBdjNyC9AXpuO34v3v2s40QClBBOizUsLGn+cftDQfbBHtOdWrJ+bZ6rytRx3Vu0O/ohjNt8q/Tlt1rQy5i4wko1yLJSwWmUdsicqks5N6P3CPq0DYk3qjynz6TB043t9L8bB5w/EWOUaY2j7FJ71TrQnR7ySGQ3I1A1VZ897kjFxoprBIPm25pbHgKjgm2tfcdPKQzeWIj2cca95K4f7IeEZANZbJWxD5iz+lSamkz7y6rgFjOdnQqu7NQhj3SDEBTxTILzDgSVl82GqLe7dyeryhiTW4K6gHUC9ocM7YAFKDHNlz2wqBlup9yRiCvuggGQrV6eu5nmzaCp4tgzUvtjjqEQvuyiIfvNNXaZqpnzRzKhqRB9rrD7Cv5
 pGpO4GWz
 701LiDd0GM21Gx++TU/Anw9LGnqLvxGwkrDb+l6Wfb6ql0euLjCQrBEWQBT0s3POIoDNxMMCpZenxmbM8f+x7WT4H4FF6/RkxMRNFrDI/HnvxOnAVCibUwfnkU1ClpnKRSx+WJLh+EGj9WKdVloyK1lexASP5+ZRWEXTJxk2nBeWzmCTQNJo2S5psIvriQdtzfz8Ujz7g1wB+73kepWTdL4oKRDLcDBml87M3qrK31OG0Bgv0V28c75CFrgVxWc5w5mMiy3r18GdQNQZpguEUK9kpOmOQIFkqdmzg4He5Pj96s1N4Cq52noB1RQf4EmH5muVvL58Kcp7u4FlmwLcyPtTZB9eFGwatx9UyV7EXZzURCdxBkkaC2qnF/CnfmrSwB3S+8CC6p0TlqwZKX21wZxy5UTwbGnIzKM2hU1LXj1DEA0ns8buSjBaClBq8OcZDxPdA/ZWg51YauGkTCBUEV3nyXgBFAZ+KkMn8FenamYI45RV62hQe0iJD/UI1ooXv33gzs6QWyNc47Vjle11CmTg7P9vewnbDhHRUud3nvxtEKT7hJZxxHSg+x6AfhatQXXUzVGu7yXI7OlKbGyeBzWxM2dKmPHX36UnNnEpjnAcqOucWIH/W3I01FSXMITsKQJ64KKIAFZHQtRdAnGN+w0VI5K6Vb3daN60OvFSl3kSiO/TW5rxM2X6mOA==
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
> Rework kvm_mmu_max_mapping_level() to consult guest_memfd for all mappings,
> not just private mappings, so that hugepage support plays nice with the
> upcoming support for backing non-private memory with guest_memfd.
>
> In addition to getting the max order from guest_memfd for gmem-only
> memslots, update TDX's hook to effectively ignore shared mappings, as TDX's
> restrictions on page size only apply to Secure EPT mappings.  Do nothing
> for SNP, as RMP restrictions apply to both private and shared memory.
>
> Suggested-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 24 +++++++++++++++++-------
>  arch/x86/kvm/svm/sev.c          |  2 +-
>  arch/x86/kvm/svm/svm.h          |  4 ++--
>  arch/x86/kvm/vmx/main.c         |  5 +++--
>  arch/x86/kvm/vmx/tdx.c          |  5 ++++-
>  arch/x86/kvm/vmx/x86_ops.h      |  2 +-
>  7 files changed, 29 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c0a739bf3829..c56cc54d682a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1922,7 +1922,7 @@ struct kvm_x86_ops {
>  	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>  	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> -	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
> +	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6148cc96f7d4..57c18ab91646 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3302,12 +3302,13 @@ static u8 kvm_max_level_for_order(int order)
>  	return PG_LEVEL_4K;
>  }
>  
> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> -					const struct kvm_memory_slot *slot, gfn_t gfn)
> +static u8 kvm_gmem_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> +				     const struct kvm_memory_slot *slot, gfn_t gfn,
> +				     bool is_private)
>  {
> +	u8 max_level, coco_level;
>  	struct page *page;
>  	kvm_pfn_t pfn;
> -	u8 max_level;
>  
>  	/* For faults, use the gmem information that was resolved earlier. */
>  	if (fault) {
> @@ -3331,8 +3332,16 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *
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
> +	coco_level = kvm_x86_call(gmem_max_mapping_level)(kvm, pfn, is_private);
> +	if (coco_level)
> +		max_level = min(max_level, coco_level);
> +
> +	return max_level;
>  }
>  
>  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
> @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;
>  
> -	if (is_private)
> -		host_level = kvm_max_private_mapping_level(kvm, fault, slot, gfn);
> +	if (is_private || kvm_memslot_is_gmem_only(slot))
> +		host_level = kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> +							is_private);
>  	else
>  		host_level = host_pfn_mapping_level(kvm, gfn, slot);

No change required now, would like to point out that in this change
there's a bit of an assumption if kvm_memslot_is_gmem_only(), even for
shared pages, guest_memfd will be the only source of truth.

This holds now because shared pages are always split to 4K, but if
shared pages become larger, might mapping in the host actually turn out
to be smaller?

>  	return min(host_level, max_level);
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index be1c80d79331..807d4b70327a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4947,7 +4947,7 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>  	}
>  }
>  
> -int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
>  {
>  	int level, rc;
>  	bool assigned;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d84a83ae18a1..70df7c6413cf 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -866,7 +866,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
>  void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> -int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
>  struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
>  void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
>  #else
> @@ -895,7 +895,7 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
>  	return 0;
>  }
>  static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
> -static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +static inline int sev_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
>  {
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index dd7687ef7e2d..bb5f182f6788 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -831,10 +831,11 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  	return tdx_vcpu_ioctl(vcpu, argp);
>  }
>  
> -static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +static int vt_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> +				     bool is_private)
>  {
>  	if (is_td(kvm))
> -		return tdx_gmem_max_mapping_level(kvm, pfn);
> +		return tdx_gmem_max_mapping_level(kvm, pfn, is_private);
>  
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 0d84fe0d2be4..ff44f4bd76b5 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3338,8 +3338,11 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  	return ret;
>  }
>  
> -int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> +int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
>  {
> +	if (!is_private)
> +		return 0;
> +
>  	return PG_LEVEL_4K;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 6037d1708485..4c70f56c57c8 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -153,7 +153,7 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>  void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
>  void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
>  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
> -int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
>  #endif
>  
>  #endif /* __KVM_X86_VMX_X86_OPS_H */
> -- 
> 2.50.1.470.g6ba607880d-goog

