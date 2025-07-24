Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80ECCC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02758E00C2; Thu, 24 Jul 2025 19:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9D98E007C; Thu, 24 Jul 2025 19:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEFEE8E00C2; Thu, 24 Jul 2025 19:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CEA0D8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:04:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C6141A0554
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:04:23 +0000 (UTC)
X-FDA: 83700688806.20.AB4CC0D
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8D5E480011
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:04:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bzBmTYst;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 39LuCaAsKCMEhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=39LuCaAsKCMEhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753398261; a=rsa-sha256;
	cv=none;
	b=23OraRMP0BsE1JGWhvXqlaIwP2TqsLa/KubR4o01aP/b8rP1dh60KAuoLf65Y3sLSZ3SOZ
	LWCIHUGiz1MUOEPsTLfcru+Y6NsxwKpUZEal2UXVkZaMc19NgvzBegI43ryEa0r/YGt+jT
	R5KZ29zBu4KVnN1eHsj/ITtS7+vFApU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bzBmTYst;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 39LuCaAsKCMEhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=39LuCaAsKCMEhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753398261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTJvoVT99m3CIaUayqF3P9earEQjE3s9Azx4PZBgqLw=;
	b=MjN0b0WVjRfYOyiTc205m+FxlNXUY9jNYQeevrSBkT1fnPXIEiQ10IImqjVR4vtgQ+I9uU
	eJyh4nWiLyADGFtNj+Tqh5etJqfzEToitHAAnYHb3SAZko21SbF37xyHZijTT+9o1ixw/4
	yomXPFG7oS74f+7a9YgCNvB8qFKPIH0=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31cb5c75e00so1283095a91.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753398260; x=1754003060; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NTJvoVT99m3CIaUayqF3P9earEQjE3s9Azx4PZBgqLw=;
        b=bzBmTYstm8SXAEz6EGLygS05Ez5YXqde6Vm6kN+2JuhTR5Lld6zytsJ77gNeVe+Tr8
         VGFFmYcsIVw9hTPnGJjelFQSlP7h8aLlAGK2EhlkY0eox/vg0YSREotA/LRhfwyk7X9F
         o8iP+v8kxC/9ulYFEoIC1VaNRUWW5KGYa1Ze3JAt5tXKl6cH5d0T3tbilEWg2OgaXJt6
         9lWwW2FKsOwp5SXTOjW39z4gIwCQ6yLcAQBkrHamX0D7NweRcBYJNSysNp9H4pFgUF4n
         qWorjy1zX/ryPgwHqDsVMSabc2Cqrq6pujQU+lp2WycVq3cn7r4kSoL0QnIoaCuQ+wI/
         vz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753398260; x=1754003060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NTJvoVT99m3CIaUayqF3P9earEQjE3s9Azx4PZBgqLw=;
        b=lAysNbLOv5ns7WHpvZ/+0Nq0N44k+DTRH4s8UhS3DuMdbA+h3n8FdR/BibKAw1Fk+9
         JxrkGe1Cr4O3ayFjwhUmxqcZ0GG3FR5NXLVI3WiceyOMBCQ8sdOzdkx3b+soR/eNtFFQ
         qolkhVxXm2SE4caqCm4OHsPRythpWKtcn+YbrkX0E/aftbXQu31d+9wxCTBfX2NsRLbB
         ecBMu2cZJ2KvVZxbL+OCD8zjjboPTTKhd4J5SWQGkzUKHJ6QPxjGepcv3aMuJrYARsXf
         6TkT/klDa4wDBZD7jvKpsyh1JvbLP5q7vSllZFQTIjIB0UqVAXKAgmtXsuvGfBOCxO1H
         09xQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgqeXHrM/uKaKmTQkaI3hDkP0v4c3iUhXZRfuB4CSRpBjjR5YvxePUrJgQDMJAD/SBsIWC6u6guw==@kvack.org
X-Gm-Message-State: AOJu0YwmcHF/xoeKBlyk1ip8lB3Ax9+BJJY4h+uPBc+JS/OYuXDm3Fil
	GYEkEzq8AJ9Yo+V6/1xoObIANO6C14+0B8+ZZ8qg/JnsJWOmR/8J3FcSxEBeTClenuCJ6Yz6REq
	1btjxLeXW2uUOVPJJ8SLYwxRHng==
X-Google-Smtp-Source: AGHT+IE+Py7qsCB31cPaqiCQRQWGyNOq4FjwR+05A19/Rt6iIKCBE8SZxnpYdzgkdn8Fx+/T4+FL2T1bJ7x1sq1aHQ==
X-Received: from pjbrr3.prod.google.com ([2002:a17:90b:2b43:b0:311:eb65:e269])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:52c7:b0:30a:9feb:1e15 with SMTP id 98e67ed59e1d1-31e6624301cmr5597762a91.8.1753398260233;
 Thu, 24 Jul 2025 16:04:20 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:04:18 -0700
In-Reply-To: <20250723104714.1674617-14-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-14-tabba@google.com>
Message-ID: <diqzikjhdwct.fsf@ackerleytng-ctop.c.googlers.com>
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
X-Rspamd-Queue-Id: 8D5E480011
X-Stat-Signature: mykcb7hogcofwjxfxbr5pjbmqkdxmrw5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753398261-269569
X-HE-Meta: U2FsdGVkX1/BwGiiHr/hv9ZQ+jre/4mDO57C/1ggYf7Ggackl/6GWaUvFPDrJ6YId6jae/AshIHFk5yYZFq2LB6M1/83MLNiD2dr+fz4By03Ycai7XleWu/9FiVlmgjvF18bn+HVg8/NuMWkT2ZADiODeq5yAIDLbD2ny51iE8bePvrjEAxUf5Co41S5fKbhw2sWBrZfjfUeHYM87pn+m1lYlGLIWO80WYF815jHXUvqnGjO9iFXhY4P0ZZLgl1jdRVDXumQkLbxHtuCAaVFqT3Ijxv7hB41S00NZ0ISrHkr1a/QrjicEn9IL1XNKsfiEeozKyWfPz+MyMxtjaU27S8cM/7gnGIW/9V5BoKOaRV1VDjACJ2jD/rupt+NMR7AcODIGPCKIIwCcG0wCAG2qKVg/3boaMVag5bUsxq7a+LD4V2On44K/c0PwAUaHvUtoPXQA29hr3rY55fQbL8smfQGWdWXGbnZltWvCBWBmPt0cTdBJCqvxqHgka0Bb6sxd3b2xzfUipBj8vcKkhXNC1mwSTEfQV712bu/9oHtDWTLgkX4E1hNaTzPWNOE0fiM8JhcBHb7+TgOhLJW6NVxt7ic9E+YDFOqr4ybgYqSYxQR3vNPDCf/fhvNJ52P/9A7N5Ni3+dcw/638BPC05XAiMU2aFYEdv3qnp0u7X+wMqIGXEX7IWhCpqqzIfIOYKgT5UCJH6O/iLtI9cihEgB1MqiRxEYrfG6396rmEvXhVJqPq7MU6LWJRLlUwKm7KhYltDn/6osit7vGJppjlwpfK9YKB+Zodk9czzzR+li2rJ+kua1PJCQhWbwAX/mutFvy489PQla/gh3s/shEdkrooTxvAp+idG+ocWBXTMndf3MNotIKpJkSnBCAC1ajEXadD7tk9g29KlY/g07XQl2iPK9x1i0Hcd5JFQE1k7KoGONOni1r4Ka9zqDzZ3OU6hbOkpYd9ew0pjVEPdneGTw
 /qyUzrzE
 CMXugiGpMZKb7pY/s2F4uaLeZwHngrDpR46JVx9Se2UARXLKn2oJbE962nbKXmit3KDgsY4R+qH1EKpWyqGO2WByTYlKY95Y/lf372IjjCMx7Q7XZhuNf0pPeZaO+isGNH7jC9rEpXKA1KktHJSv73H5vTVTSgGntSXl01B3QhMhmd2spkK1K4DXPYsZ5O10GQjzDwdlvwFiCM/1SaLxJW0Y8DUZKvil2YsXcS9aAGIrgX3Sx93IjJiKPrnXfajJ2IiMb1CcjQl6R5kkE5NmyPvw913B6fvo/pvv7Wk1cyX/kDwXMCE4XksyUzvlH3sGuhEcTUTvjx37h6rb7LjOI3OwRD/VuLmutw7G02nSOTkcREMvvZwvYsT0cwXUbBEHXvKK7Nai0llOkynBpkYl1XoHp+WKExI41p+RusFWxBatzeiCMjdrofOI/3+4Ga2ihpB1WnCXBe0OrqEqTXQkgNGX5h9nAq710TU8feiaE6K7t9l5j3XMEgdMz0y1pcINKgPCG/8dgdjPobgxDIUOtd2CH0FFTlqXVQuWtnQTlcviQDM9RgraeyCJ0CXJSAxV9NeFp3ZO8zKuorrn4J4lzX9MLrG7BEcwD0dwj5Jgi1cp33zX+Sot8kbLTI8XNNIu+a3ywprcuwx9dvLD7RBNsmcaBtoE2OzWYw57cDo7a00x12WhLFgqjb8EDu2vYEkfjpxPL+JUodI9l1YHRkNtvNJ9tRw==
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

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

