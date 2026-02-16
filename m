Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80656E7BD8C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 10:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6B86B0005; Mon, 16 Feb 2026 05:59:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94ABB6B0088; Mon, 16 Feb 2026 05:59:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860BB6B0089; Mon, 16 Feb 2026 05:59:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 742936B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 05:59:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA8E35CECD
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:59:15 +0000 (UTC)
X-FDA: 84450023070.08.FF906AD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id B864220003
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:59:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771239554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=et0M9QIeKYJpMWLDuEx7jjkufYlirGMPzyVJS1cazuA=;
	b=PVbeKPbZlggxdehbXUgGq15GSydDBNmr2/OCJ7CvPDRMFcQMLNvCON1ycYSZJtcZEfs2JF
	Zd2WTHYlEr1Hj1JdMFP4BEe4ZsbiUIQ9hH3R8IxrwlRwmXSDWx8S+6EsmTblwjlr7TZSYK
	b4RB9j8jroApNzVZjfK0uKNIbQjSszI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771239554; a=rsa-sha256;
	cv=none;
	b=MLGVvd4IJFS3f1jQA/t7k44IOMRw2jopZjmJingOCt3XjIRbUN6yVmvd8NNteEE2ZHjScM
	5G7iq6xHFHxlk46PIVUYKx7T2wyDstK1/M5J5WRom6Pt84FHPoZkAo2CbzrVNgBqP4tJrI
	VlwbnsGnivslFtrTR9AnmIXRNBE2deE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 666D11570;
	Mon, 16 Feb 2026 02:59:06 -0800 (PST)
Received: from [10.164.19.71] (unknown [10.164.19.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 640983F632;
	Mon, 16 Feb 2026 02:59:10 -0800 (PST)
Message-ID: <d2eb1116-44e8-4e55-bb09-e8d9af5787c6@arm.com>
Date: Mon, 16 Feb 2026 16:29:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
To: Jisheng Zhang <jszhang@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260215033944.16374-1-jszhang@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260215033944.16374-1-jszhang@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B864220003
X-Stat-Signature: g1uya4hs1ynxqgdz8aqrr6cmfpcsxs5d
X-Rspam-User: 
X-HE-Tag: 1771239553-3948
X-HE-Meta: U2FsdGVkX1+Zj7zKBq9/S7bKmGUvq7awUO5m1ZyJ7VtMGr6nA6I5EpTJDyqD4vj2dMSyB8/EEWmLZjeiwWL7Q/BEV2GreTAEled4UyJvFbniVZT3QfZDcCvBVZC9GnSDlMXXY5jyo3QzJE4ImHvfBaR74Wt10FdJhAxnRtbVcGLdlWaj7PDCjYsrr90002Xj4s+yj02X03nLzj/9GnQZhxo3XBGbMMjUWbbfdtSxmLm8NDw3zLL5CmR9QUpfKDebsEEQxpoDRUn9JjjHMMDE1jkWzWNoGD/CMOxIDu41KPOXBgO6s6dean+vnAhBfnRmJx7s6kNPos+rYqorgYHQif8iA9w52wZuHDPtFc5fv2YTKq9gG3Bu2y8gJaDJh193cOb1+7++8/5Qwkrq1a2nwt7nGPJt2qoROLVlGMRz4izw00MtbBWuzLCmOPQ/Tds6q8fY3Lipg6pGiWDFxmDkROimYPBEDuI6DppJLUVxhRYhO+Hz99RiOT1J2eFpKAfxyI/qkf+HRUvOJH0xogVqol0/eOm7LNsfI/hElRTM7Y/fqSKmTxX69taFiGVEkrZUQCT1wnbVUe8xQinHxXozwPARKvfC/za14YfGYzPUzdTdmKbGAEuZAv2CvI08aRFr+Gb8vUF3TYcJY47+Tr5otzSRt7yjU1cjW4DBTVRjMN6ajXHGsjJk5M+y37ZMFxPJyS/jSseNggNTZLpZxmfeKNRgJyWQ4Hjvfn65+OhuxUhhKjWr2sLFzk795KLbo80dXAd9zFBAaIq77LGFGj7EDw6X88wn/RldQqv/ZgSYg30g976d/xPuQy21lYyvQxyWvpFzYMKGaD0ZML/VFVRCVcp4iYC9VB4jwbTRkx6alTaDMCSXYK1FDMl4Vu98c19Ztd+iyf/OWV44sXCAE63kvun7HfHd29Xbg48aAwNq+y339eOZAnIKpH8YvgwXFf9dg+ml64vzYmyH2QLZKHt
 VF2wYNOH
 DnOOv/SgWSB7LQZVDtVUWZEurGPJywzomasTQKuHUfYsaZtEtkEB5PNc+/4rDAje3j51/bUlj0SJW3fvbmVKKDWuw0FcgAuJuV/6IgXVpPVVPoIXoULWqVofnkhIH+kh8HcJsjMTBHOdsr0rRdgsqzt9a2MeTOzvQcMuZD4Pj+VF+6KO8NX0FFrS3JJ4fgjwIzYUpFuyGLrull2Y2lZcC1IzQ1mSdKqYmco0EJdDio2F41uvxGOCQRH7KWkZCGgaMTlvIE1H2LThLlcXLfeyghDq7SmA9Ct/kq/hYV3rwquBrorM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 15/02/26 9:09 am, Jisheng Zhang wrote:
> It turns out the generic disable/enable irq this_cpu_cmpxchg
> implementation is faster than LL/SC or lse implementation. Remove
> HAVE_CMPXCHG_LOCAL for better performance on arm64.
>
> Tested on Quad 1.9GHZ CA55 platform:
> average mod_node_page_state() cost decreases from 167ns to 103ns
> the spawn (30 duration) benchmark in unixbench is improved
> from 147494 lps to 150561 lps, improved by 2.1%
>
> Tested on Quad 2.1GHZ CA73 platform:
> average mod_node_page_state() cost decreases from 113ns to 85ns
> the spawn (30 duration) benchmark in unixbench is improved
> from 209844 lps to 212581 lps, improved by 1.3%
>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---

Thanks. This concurs with my investigation on [1]. The problem
isn't really LL/SC/LSE but preempt_disable()/enable() in
this_cpu_* [1, 2].

I think you should only remove the selection of the config,
but keep the code? We may want to switch this on again if
the real issue gets solved.

[1] https://lore.kernel.org/all/5a6782f3-d758-4d9c-975b-5ae4b5d80d4e@arm.com/
[2] https://lore.kernel.org/all/CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com/

>  arch/arm64/Kconfig              |  1 -
>  arch/arm64/include/asm/percpu.h | 24 ------------------------
>  2 files changed, 25 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 38dba5f7e4d2..5e7e2e65d5a5 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -205,7 +205,6 @@ config ARM64
>  	select HAVE_EBPF_JIT
>  	select HAVE_C_RECORDMCOUNT
>  	select HAVE_CMPXCHG_DOUBLE
> -	select HAVE_CMPXCHG_LOCAL
>  	select HAVE_CONTEXT_TRACKING_USER
>  	select HAVE_DEBUG_KMEMLEAK
>  	select HAVE_DMA_CONTIGUOUS
> diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
> index b57b2bb00967..70ffe566cb4b 100644
> --- a/arch/arm64/include/asm/percpu.h
> +++ b/arch/arm64/include/asm/percpu.h
> @@ -232,30 +232,6 @@ PERCPU_RET_OP(add, add, ldadd)
>  #define this_cpu_xchg_8(pcp, val)	\
>  	_pcp_protect_return(xchg_relaxed, pcp, val)
>  
> -#define this_cpu_cmpxchg_1(pcp, o, n)	\
> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> -#define this_cpu_cmpxchg_2(pcp, o, n)	\
> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> -#define this_cpu_cmpxchg_4(pcp, o, n)	\
> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> -#define this_cpu_cmpxchg_8(pcp, o, n)	\
> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> -
> -#define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
> -
> -#define this_cpu_cmpxchg128(pcp, o, n)					\
> -({									\
> -	typedef typeof(pcp) pcp_op_T__;					\
> -	u128 old__, new__, ret__;					\
> -	pcp_op_T__ *ptr__;						\
> -	old__ = o;							\
> -	new__ = n;							\
> -	preempt_disable_notrace();					\
> -	ptr__ = raw_cpu_ptr(&(pcp));					\
> -	ret__ = cmpxchg128_local((void *)ptr__, old__, new__);		\
> -	preempt_enable_notrace();					\
> -	ret__;								\
> -})
>  
>  #ifdef __KVM_NVHE_HYPERVISOR__
>  extern unsigned long __hyp_per_cpu_offset(unsigned int cpu);

