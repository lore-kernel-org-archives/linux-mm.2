Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A19BE7BD91
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 11:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B796B008A; Mon, 16 Feb 2026 06:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D175B6B008C; Mon, 16 Feb 2026 06:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A546B0092; Mon, 16 Feb 2026 06:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2ED76B008A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:01:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 784751A0C14
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:01:07 +0000 (UTC)
X-FDA: 84450027774.30.4CA7CD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A87C240005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:01:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pdcz32uZ;
	spf=pass (imf04.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771239665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gn2cR0H1VaG37ZT27PlZVPTmATrjKTqR6VuyqOFczKY=;
	b=Xggiq9Fd8i61gyGrEGWvKMOZ93NQ90S7NFAKsKkJjsctMU1QjyEIlCZmc4/z37e4Ww3YKR
	04mqBVAh0l/3XENFbregcaTXAF9vaHmxYZS2JRGEnNDDxPeI/FiV/x8uNSiaVydkTTGuhg
	YeGHpu8hhOw4LOW84z+rcaqjGAfEVwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771239665; a=rsa-sha256;
	cv=none;
	b=4WgXi2xPlqSXWu8dDXoJIsCPEs9K9ihWlIJMqbck5XKr1GxunOr507XXIXZJ740dnUSPfD
	e8W1msoMaJ0C9lWDnk1XuPnq/FXhpAAYCK/LQeMSYrfAeR5Y/qhzBVKbra2TJi1QT4UBcO
	XLeKOX/BBFts0R6GVHIpTZq3ZkHBTrg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pdcz32uZ;
	spf=pass (imf04.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EA3844556;
	Mon, 16 Feb 2026 11:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98832C19422;
	Mon, 16 Feb 2026 11:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771239664;
	bh=1aGpBeh4uTB95EnMRTLPvZfsnZO0+woMT4b5vKXb9oE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pdcz32uZUn9hgWq5Qk5Iruwxvu9Zmrvzsq+r/JIlJLbneE8xoBTfr4aj6UZoS1ymu
	 EXpOXsFcYyvGEXZWH5XGJugsQmslOztNOyJ/T9qZEzKUX6pjCms1Qk0+gl/BLDfwei
	 FOHVHRbdxNWXqKbA219UQKpQfGTvz6zHcp5Hu8WroHijRa7+DL76tCbDzHzR3kJPpy
	 mYg50NjO3nhBjMzz2QQ3wjol4L73oHB2zaB3Xk8Srhh3k2u1vWuSWgr6W1f564Z41o
	 jgK5yOOXhY7ccMRm6oiAEQDFLMX7g7hxIBdUtLrd/FCNNMYzDUVFJVzbH7KEFWnRKx
	 ks9+0uyPSkoUQ==
Date: Mon, 16 Feb 2026 11:00:59 +0000
From: Will Deacon <will@kernel.org>
To: Jisheng Zhang <jszhang@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, maz@kernel.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Message-ID: <aZL46z1UZkQlF3Dd@willie-the-truck>
References: <20260215033944.16374-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260215033944.16374-1-jszhang@kernel.org>
X-Rspamd-Queue-Id: A87C240005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: giyixkoa96txjq4sinbhtcx51hiuyhrm
X-HE-Tag: 1771239665-455470
X-HE-Meta: U2FsdGVkX1+gbulQXIpPA4gBA26zAMAMWwCUyxtRGDu94sdzEpwXRuOsciTLFoFT6luVeGrdPYaZzrXYByU3xiZSFpNC2gIcfhYmL4aUq7yOEIH8AJwwCYSTC7ja7dauY3lAQMk01y2jT9Hs5WHKpbjH88nboHFLk48H5lbXazbv/kZtVWYJfR8E9OhZEKrWyuKqk8+TUdv4E3k819OLtHysqDMOAFDlSZNeU7mtrcROllJMGMOHPLwTzS8QUGdmPJMIlURMoT4krZ/CQyG7xcfqVwmtmYlxAXwzNrcTZ70mZKprrrB1fOew+oLnXL2pDLGCBcZeLxt5GGag0xfraK78ldfvSoOxwALXLWL8xhsFCWQC62ANRHJmsThZk+cdxSSnnr4bz1adcEU/SgI8AOkxQq7hf+LsA5YDPfvHNPQZURw1ULsb+aEPFl05hB/US0849TmBd1H1T1ohfgpj3W6S/TDfdeB/hkgHLDhlTxoqYl0nIPCjRYi4/6Sgpds7ekeG5TtnYri0XObzRrlUDDImPKRjezvd3Wa61zPFnFxM0T7iqjQkS+kDD/jPPh7+1hf9d5U0q3jtj/dp7ZYA7H+oocR5FbOcjpUcstePddeNRtfc5XWbjqlYne9Fnkxg5gfl+EFt8KUo313E7fRCuIV7APGUaTqgPF7hsuBYJYh7V5Fu9A/b9Kv+FBWCevqSOcDjfNTe7uptr4C3vjVG/uu7pBSFDoPvlylYWzBSIiyP1LoKS3DZ0o8YAJB/awAnGkjF39R6gDnUA9WjDU151cl2zr8K+VzelprVmh7recNLvzMSCm/3dZ+y2F8XqGz8kaW5caj2tKwT/7vxRioxVAAJBMfJsAjI0GskANTdKDE0Y2kQAMokqB0IkTrDCznNpxeFAH0iQulGWnvLDkGquoun3bOoQsoYS2jWkRKNgkx4+ZwLwpQWLsAxY/FelZflMWH7rXAr8v/y6Fsd1v4
 FfrcL1w3
 jj5S+1naxvhrRORWi65yyD+uY2hkyT0UIUos1Y/U2UuheKjJUPP0YzJ6tmSGWurkGC7P7TdMBoaFBAnPrPc8EZ4leRVzhIjyc5ybr3gZiR/Qs7l+iUsJgHeV/S7MVpufKaa+7rCW2B4kMoL9KURpRhhQTFKZyQ6xCXi5Wzaohe6Mwuzc/TZeGMR0X4ZudYARCXfDY8u0rxlJuUWXbzliiOYB5G03wD7zPFy18UAL//9iPDTz54kD72+RpCPE+xtnuBLVMFFN99+5y8jC6R2vIAA8esDU0SwNe/sLVpX6cEp2NqHgRyOtJTMYqopxOTuMqSdZy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 11:39:44AM +0800, Jisheng Zhang wrote:
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
>  arch/arm64/Kconfig              |  1 -
>  arch/arm64/include/asm/percpu.h | 24 ------------------------
>  2 files changed, 25 deletions(-)

That is _entirely_ dependent on the system, so this isn't the right
approach. I also don't think it's something we particularly want to
micro-optimise to accomodate systems that suck at atomics.

Will

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
> -- 
> 2.51.0
> 

