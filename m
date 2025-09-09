Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC182CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E17BC6B000C; Tue,  9 Sep 2025 05:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1158E0015; Tue,  9 Sep 2025 05:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1B1F6B0011; Tue,  9 Sep 2025 05:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA4E06B000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:14:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5585D119FC8
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:06 +0000 (UTC)
X-FDA: 83869150092.09.7260FD4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id EC006C0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bhTTxulJ;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/IUdjMztn2lEK5HOnU9D0CF10p+pvtJH5MIMXBxLW58=;
	b=OTBp3SEnEOL5kMYHCTBMWaF2m0PWi8+hJebIXojG2Cyfa/hn3piMJxjsyC3MMSTdHtp9wf
	EZAhpsK4mYnGVEZeX8CTqaEyyjbFmpBITkrtpbGN6NnVkqdhixHKnKNEyT0GyVMe9dfrR6
	l4FqhKTWbcPiIsLl/LLDbQnzmYmg3ss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409244; a=rsa-sha256;
	cv=none;
	b=Jyd+SBwW4kp/uNTKiJaO9yeADh/kQBByLDKqtDu4MG1oiurSkmqVBYFzt7B6yqjTV1y1Mz
	SJxKI7LHnE4WHD2qstFsYpejDMNVciAbaAEJMcuVNcXDTY5NDMCu03j2J/Eslv69pkaVQd
	HSST/i2uL8koBH3HvYVVjgZ2Nmcqta0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bhTTxulJ;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757409243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/IUdjMztn2lEK5HOnU9D0CF10p+pvtJH5MIMXBxLW58=;
	b=bhTTxulJFCryXqYTiiNOdRzm3aSiXDRHPgClsz8i/sVgLgWqWn47/A3CWW10HPRgVFpurX
	Dm2LKRPAtdB8lx6oa8/goHNbbsKN+KQe3gyZ21f8h6AVOJe0bjGMjqRcRaXHTZANFgaydA
	I6oLXDzNI6xqSAO1T4tLYjSZVmnHAWY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-Htnu7hKrPx6mEv8wzIhSug-1; Tue, 09 Sep 2025 05:14:02 -0400
X-MC-Unique: Htnu7hKrPx6mEv8wzIhSug-1
X-Mimecast-MFC-AGG-ID: Htnu7hKrPx6mEv8wzIhSug_1757409240
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3df3e935ec8so2494234f8f.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409239; x=1758014039;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/IUdjMztn2lEK5HOnU9D0CF10p+pvtJH5MIMXBxLW58=;
        b=Z/sKEdVkEgHG8ub+zPlZz2ZU44DdbG2iNR59vhOY+LbeZig/rBmTmaFcjnkZMoM45G
         NXvLN3f55T2zCimq1S6WVZJKw5pZtXmeXNJa5Ih0Svnazl1EJ7gOmfu1grKcG9CQ1ZlP
         6YgingXFdYWFcIVm1WZh3RqrtwiQ71vhZnrS4BtGvhjUR5hNta0TM0s/nFTVAEQ+M126
         2el2z9PxPZeS53kacSVzmyMMzwGQ/p5MoZ0yljk+pdszbWLK00QLl/LAxaIOfYyU0U/M
         cvkIjy5FpjE28lTHu3uF4SiL2P+WISips4BYJxWWiF6aBEfZ8qwaWQog/CmRn7htboUK
         kD2A==
X-Forwarded-Encrypted: i=1; AJvYcCUBlHc11yCG/xoHd/DX+QT9Dxo+9ARRK9gXo5IB+HiP/0u++MAhjbLCEijJQ0WIoNcZIdAhpjMeRQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4EnjxC5dcTfpp6UuBO54N2SRoIxhD11Qie2K21FAOVvGwr49P
	SOE7XX1SNwElUfMfXCeKeJ43yb8wlCAz8DYfHlsOPirgr+dqnLxoIswzBx7eaTUIYWc1jR6o5wx
	KsBUwgsERMD0uR5F/a+A6I0pmsvQsvIf9Dwl6DzYRTj82lr+7qvcU
X-Gm-Gg: ASbGnctqd3obNBtAaexajNYCOtudmXjNlQ7/7JgDMQ3zWuM+lMGYrSCXURutswYE8bX
	yLpPICFiqYTogBb5Y5MMGybkGTuKPGtVCdytzZMFOc8uxKu+KfBa4cpKGlpr4hxscqrBZl54qDy
	9Vht/ihc0Szlriqdk60GToY5C6AzTMVBRbv0gEOCOwpTFGJyGG0NQ31Az8bqSDW8SGuZXKzinWP
	qUnYKu1gIBMEADQrASzNUwrEIYKABJJAr9lmRVziE7Oxd3CTRrSW941FSETHWptfdt4XNxW3qHN
	Y+QMlM6hSRjayoyGZXp0zZyd96O/SDTC/okLoUBT2nwKlLkU08WRh0jz6GtUzZ2L9HPpMMIge8O
	+hHX1TJ/3OU4om7m382WtxiC4yzo0xaFq3OoVSXkjXY1afvH9KVxbux8qSNHq1jGy1dI=
X-Received: by 2002:a05:6000:3101:b0:3e3:59cc:65ba with SMTP id ffacd0b85a97d-3e64374208dmr2787717f8f.50.1757409239543;
        Tue, 09 Sep 2025 02:13:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhnq/C72ezwSRJLO4zISvano2xfvFhth932RgVfDh+sCEuObRa/4tJAM3JVWrXDipaf397Wg==
X-Received: by 2002:a05:6000:3101:b0:3e3:59cc:65ba with SMTP id ffacd0b85a97d-3e64374208dmr2787666f8f.50.1757409238983;
        Tue, 09 Sep 2025 02:13:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e75223f2e5sm1797097f8f.52.2025.09.09.02.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 02:13:58 -0700 (PDT)
Message-ID: <aa28c1a7-82fc-42af-9904-a4d4db078a19@redhat.com>
Date: Tue, 9 Sep 2025 11:13:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] x86/xen: support nested lazy_mmu sections (again)
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-5-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908073931.4159362-5-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HSCtjvD7peGLXot_077RWq-0sAXw1BcYJjzl93T8X3k_1757409240
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pmy7e436bwsfj7udpqwg65a5s5mq5qu1
X-Rspamd-Queue-Id: EC006C0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757409243-414709
X-HE-Meta: U2FsdGVkX1+2S0fhfZ3yutnRPqOGSlRNNIR/n+1vgTnH7YkVIFp8Ux5uJJt4TeGsB/WgvW0G4Zq5BJWOQBZvyoyDUN1Ztv9bWQ5txCtzGNn6rq1k41PmQ/z72g33/y/DUmniVDyy31+9O9DZ4SFZxfjoT0oiveoGf19E+VJh3LfoQileBILUhkT6P2cfUEMSM0Ejw3e45zjXoLzJNpvO371DKP+xBBoYg8fGH5ItiKgKS/G78OaZmq1ILjIagKP2LBDUXnMZJGftahIcOXjQZEXTp0gHPk39rn/yS6Nq209hmh0O12Xjcseu+Ii6oMeOFHSWAIIYMAfhq6PJM0jt+uGiyxZ+iRHVL6m4NK7HNU+mFGJ75vW3A9KMOCVVTEOFbCysEBiRT8wBCIccpSJkCE3qbtLvNCL6GBYSbridIVaiLNjCKY75pC4g39R9wYFjfzIHo64H+PkvcfjShPMiKPrMMSwWYrXTt5yzfE9WRrAzHKy2yzhikrTXfC4HwH1CtFx7EYfPqKZvDgMn3Iv06myjYqK2XZMZ2X5Scwsnayu5ysMhyjd6VDVdPZE3Fp8ONEhzh32Yde/GKGPhDMa1ZOdEDUt+EC/KdLGtoYYedwU3HbRLxNrEW0gfaq0Bpzlnj75SVCS6FZVMd30yIyMEyniw3+QzJOaYRLEDlMkCwG7CJsDEuVSPVXwU4Ld1qqfWh+Ciunp5u1e5eeIzN1QYLIcdCeuTqiuWDLy+UqrDl3//xOaO4/MknXdIohpbbAEs6QbAHHtI0KD7cxam5/fzi5WDllx2xcyh7IxN4VRzlu5RvYmIv1cE/rRCP2M2sym9no31UGO2TxwMS2/bhg91Dr18TYKfUruR9fPCEa4byATAc4n43TArjNFfqYaaoxKNedYaQwK/jhgU8dn1gVakr3Hi6rBuesDhTuLLostL733D3D5hHB5IuNIc3agpa+oSLbD928QeHsaY8Jr1/tJ
 hsdu+XeM
 6O8YcqiYcXKHdUoYLvGG/4AbhzjuNWxQXjytghZsxzcelCeJRAOI/TG2UI4PoL6nAOqwgov5kbMTkF5Il4MGPZMTAjHvBpL++H7GvGrWDBLlM6jXvxCRa0G7LuljizJ1NMsmQum6/9p0SmAhh37A0Z8Hftvt3XRqI1lbVnrkKoMvwQtel/CbingjMQNsciCUT5P1gite5jJEHV3ZlQ7iHrtrUnmN4IUFaRVb8MCNZC+ymXeAFXWFGXgCP6zuFglYPggqK259cxXm+5hTXkDqm657sMpmoGrcN1Sb0WlfgwMWQgw8vUM2pLq7Vpd7Q6SAlDIcSHdgMwOMm2IOYnMPXBIrMaTv1TlT5lRV0ZMYU/89xGBQUg0P9HhD990MycFNxagdQhePYLJoA8P3BlJqrKPkMB53ArDCl9Gk8Lp2NWMF4L4Dc16OTtLPB1EgSaKYlnQ8MQVmepH8Kp6MfiGa0srv0W0jngCW0tJ6DgRoeh+92EDA6D9p1NYDtL0zvszFr9wRQYE9nPAa0SLqldkuvjwAz2dH5K8WSphIz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 09:39, Kevin Brodsky wrote:
> Commit 49147beb0ccb ("x86/xen: allow nesting of same lazy mode")
> originally introduced support for nested lazy sections (LAZY_MMU and
> LAZY_CPU). It later got reverted by commit c36549ff8d84 as its
> implementation turned out to be intolerant to preemption.
> 
> Now that the lazy_mmu API allows enter() to pass through a state to
> the matching leave() call, we can support nesting again for the
> LAZY_MMU mode in a preemption-safe manner. If xen_enter_lazy_mmu() is
> called inside an active lazy_mmu section, xen_lazy_mode will already
> be set to XEN_LAZY_MMU and we can then return LAZY_MMU_NESTED to
> instruct the matching xen_leave_lazy_mmu() call to leave
> xen_lazy_mode unchanged.
> 
> The only effect of this patch is to ensure that xen_lazy_mode
> remains set to XEN_LAZY_MMU until the outermost lazy_mmu section
> ends. xen_leave_lazy_mmu() still calls xen_mc_flush()
> unconditionally.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   arch/x86/include/asm/paravirt.h       |  6 ++----
>   arch/x86/include/asm/paravirt_types.h |  4 ++--
>   arch/x86/xen/mmu_pv.c                 | 11 ++++++++---
>   3 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 65a0d394fba1..4ecd3a6b1dea 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -529,14 +529,12 @@ static inline void arch_end_context_switch(struct task_struct *next)
>   #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
>   static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
>   {
> -	PVOP_VCALL0(mmu.lazy_mode.enter);
> -
> -	return LAZY_MMU_DEFAULT;
> +	return PVOP_CALL0(lazy_mmu_state_t, mmu.lazy_mode.enter);
>   }
>   
>   static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
>   {
> -	PVOP_VCALL0(mmu.lazy_mode.leave);
> +	PVOP_VCALL1(mmu.lazy_mode.leave, state);
>   }
>   
>   static inline void arch_flush_lazy_mmu_mode(void)
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index bc1af86868a3..b7c567ccbf32 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -45,8 +45,8 @@ typedef int lazy_mmu_state_t;
>   
>   struct pv_lazy_ops {
>   	/* Set deferred update mode, used for batching operations. */
> -	void (*enter)(void);
> -	void (*leave)(void);
> +	lazy_mmu_state_t (*enter)(void);
> +	void (*leave)(lazy_mmu_state_t);
>   	void (*flush)(void);
>   } __no_randomize_layout;
>   #endif
> diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
> index 2039d5132ca3..6e5390ff06a5 100644
> --- a/arch/x86/xen/mmu_pv.c
> +++ b/arch/x86/xen/mmu_pv.c
> @@ -2130,9 +2130,13 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
>   #endif
>   }
>   
> -static void xen_enter_lazy_mmu(void)
> +static lazy_mmu_state_t xen_enter_lazy_mmu(void)
>   {
> +	if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU)
> +		return LAZY_MMU_NESTED;
> +

You mention above "preemption-safe manner" above, so I am wondering,
what if we get preempted immediately after doing the this_cpu_read() and 
get scheduled on another CPU?

-- 
Cheers

David / dhildenb


