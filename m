Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593F6C54F5C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 06:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5FC6B0088; Fri, 20 Feb 2026 01:33:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8638E6B0089; Fri, 20 Feb 2026 01:33:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745236B008A; Fri, 20 Feb 2026 01:33:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60C716B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 01:33:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07ADF13C015
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 06:33:08 +0000 (UTC)
X-FDA: 84463867656.10.87B2D8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7271C180003
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 06:33:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MSQ82ZE3;
	spf=pass (imf06.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771569186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1A3lpYSGax/n4+5eeSy2exXTa0jNnmXhF3xXfLCX3Q=;
	b=cLIevZa5OTft09kGKWyWjksR5LR6Tsd3arHgXfMtCUOZAVTRh2jdsz/26natS+E5YRwvTE
	xnppXmDjLpke7GLtIqkERsFYxmP/VNTJ6wOgO3HvhpUHiqg2VBhWP8NugEgMNly/QoLtwR
	ObDGsIUKMvSps9XgokUs7hahqASm5Pc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MSQ82ZE3;
	spf=pass (imf06.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771569186; a=rsa-sha256;
	cv=none;
	b=Db/nsIe1jMUJAIAEGzGLjNCwe91Y5oymsm+Yut2DUMLSVvBKubhhMB27l7LFg8SH9VB3NG
	972XPKb/t5Y2KftNiAU83lY3vGSQUqxCjaIUYDrsrsxwc0EQWocU9gEvCzzfOpgPjRDAAO
	kGBJ3Amu27IswjyN9hhwyiXA7b5BiII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C0A660054;
	Fri, 20 Feb 2026 06:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F377C116D0;
	Fri, 20 Feb 2026 06:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771569185;
	bh=Fq+HYBDt87eoP9eXSUrmnldyYQ/rSkSpbFxYlUHf1BA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MSQ82ZE30LmJrrKD9PVuqMqIuJvDK2CtgGY9C3wBZmy4pRdK/jNaqXvgw0euL+3uh
	 TWiBisItCbT2PAjp8NXubp7LyHSMhZc91THpIb8TkiRcCLDucjDn5u7r7E//A0xZjg
	 z2GDqgTGQVldYvJiVPtoWJVvZUOTLQ2gU7batWFj5sr4Lh5C3W7/4tYsi4+wu3mg8h
	 FS7fGncoct/YrnchxqXEts7B03Y5RLbskDK8zxaMcNNZI6tTnGmQDj5eEwY2VwvJBX
	 T7fGP1WxXLpgcU9LbimHWcmzf9nc3jcOl90PzPAjlS2VXpSyhqQCddFgapKvE87sBf
	 UeXn97y9HivjA==
Date: Fri, 20 Feb 2026 14:14:23 +0800
From: Jisheng Zhang <jszhang@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, maz@kernel.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Message-ID: <aZf7v4Ix1ZWCXxPu@xhacker>
References: <20260215033944.16374-1-jszhang@kernel.org>
 <aZL46z1UZkQlF3Dd@willie-the-truck>
 <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7271C180003
X-Rspamd-Server: rspam02
X-Stat-Signature: ion1ss7git6ybddtq3p9cu89wexxxoz3
X-HE-Tag: 1771569186-181574
X-HE-Meta: U2FsdGVkX19uYUeyNRVjQXa6N3go8Ktj186BRDTdfljRHmM5QgHrBNOPleZNaySQbFjpawZ9+phYJECZqyzx5z50WPYqcJt0VTkByz+4qzgA+XINQuUEyc3dAvBWCAM8XPhEXL9+5C7DBV7QDk6DKMz30ha6AHPiK4q/fnBcHE7l5Tdkx+QgK0m+aTD8Zc4v8uMFJGwRBCAVeDLLRmPuCI1ZXkjVqPwKy6C3sX0w5uK6PA5uGItm9L6rzwUZTT+XH2sVN/BS8ayJmIbWLkoySikZsTrRkDcSbW5AAa0LMnw2KmbuAO/T/gjUUIlkPr7frb6/dURdVR64dEzPDBsVzt5sCftKPsEVb4IFHaP3X5pLJ9Ow6a/Fq4Fw9F4WWA4ZtwycSkEW05fBD4zaxolECi5sWHG9dF6gL3AfPcbsajp4mtS5GqyyaNZchosn0gj09GM4737qxoaMc/MGUJDeUrVT72bG54G4PFmyPmy8t07sn3zh2zZCK11iBAhRi8FsZ77YB9mkpJRMOgRd9pgvWoOGo6EkTqde6CxQCHMzcmgvnmOI4A2wymAOgx8JXQtt3yEj7d8hW52w6rPWBfL+JSy6z0UuWox73+MWxfArA5kdx4RUvNy439ArcPQ93+TTvk+tqb1jhU1rsuik6nlbAc0rjx2URt3RKC5bD1/K0Pi288SUjWAA0c0Rjcs3ct96GwEZ2DRp9n84cUOUd/ylP5scOyNy3h9CFqaSsXe8zxdst1QrMi6OyJrM9ZQUcmhxVf2+MBGpGXFzYstyqX+yMOBcKux17u9x5Ee1/QIzVgDNMGJcrjMETE5+5kbXDV9pNXku7ykOIYc7NbLcPPJ/v72obqSJmusk92mGLXxbQtp2IRn+sjdJWXRr32HCZjKRnMA9erWqV+Bk/bmUhtdFJ/DMmYospR2DgQoVWttTy0Bgz4gYFPR2+q3A1j03eDfVKlX+ZXYrvimiFB2XnA0
 xNAOIvJs
 Gm9VFM8UQ7mq0Ot2PdLsWNEtEHZnZ9x1PQxwVnOMUFFP3l5YVzVKlwGuibTZN/SjX1Ioa/GLOVS2G2RfMe+cs2sZhkJfNsPPqUqcfSIT7KjMp4BTd2Jz67iqJIxAJfSSuSro9xUkT8LOF+y8B3ST67o814zAXP5yMZLjSU8ue8Q24oo1Xh5pDlU0i9q5q6wQjVRsBrxAp/HA+njKZRC3aUJQMg+ZhluG3zsBo5tkLjWIQV2AcvHGfJqxuNVFgTNBnxDbFtE36jzLEPWhgWX1N5g/Yvi+cwE3DLSMGyfdajP2kP1SFSI2sSRpY94wyEDcuFxOnn8r6wcjxw65YYCbpAkdjpmU7yMblIWoerioYjT+v/ycjONwzalfJo+/QnwhrisbP17NX98Fzgmtsh+QyK25ZQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 08:59:17PM +0530, Dev Jain wrote:
> 
> On 16/02/26 4:30 pm, Will Deacon wrote:
> > On Sun, Feb 15, 2026 at 11:39:44AM +0800, Jisheng Zhang wrote:
> >> It turns out the generic disable/enable irq this_cpu_cmpxchg
> >> implementation is faster than LL/SC or lse implementation. Remove
> >> HAVE_CMPXCHG_LOCAL for better performance on arm64.
> >>
> >> Tested on Quad 1.9GHZ CA55 platform:
> >> average mod_node_page_state() cost decreases from 167ns to 103ns
> >> the spawn (30 duration) benchmark in unixbench is improved
> >> from 147494 lps to 150561 lps, improved by 2.1%
> >>
> >> Tested on Quad 2.1GHZ CA73 platform:
> >> average mod_node_page_state() cost decreases from 113ns to 85ns
> >> the spawn (30 duration) benchmark in unixbench is improved
> >> from 209844 lps to 212581 lps, improved by 1.3%
> >>
> >> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> >> ---
> >>  arch/arm64/Kconfig              |  1 -
> >>  arch/arm64/include/asm/percpu.h | 24 ------------------------
> >>  2 files changed, 25 deletions(-)
> > That is _entirely_ dependent on the system, so this isn't the right
> > approach. I also don't think it's something we particularly want to
> > micro-optimise to accomodate systems that suck at atomics.

Hi Will,

I read this as an implication that the cmpxchg_local version is better
than generic disable/enable irq version on the newer arm64 systems. Is my
understanding correct?

> 
> Hi Will,
> 
> As I mention in the other email, the suspect is not the atomics, but
> preempt_disable(). On Apple M3, the regression reported in [1] resolves
> by removing preempt_disable/enable in _pcp_protect_return. To prove
> this another way, I disabled CONFIG_ARM64_HAS_LSE_ATOMICS and the
> regression worsened, indicating that at least on Apple M3 the
> atomics are faster.
> 
> It may help to confirm this hypothesis on other hardware - perhaps
> Jisheng can test with this change on his hardware and confirm
> whether he gets the same performance improvement.

Hi Dev,

Thanks for the hints. I tried to remove the preempt_disable/enable from
_pcp_protect_return, it improves, but the HAVE_CMPXCHG_LOCAL version is
still worse than generic disable/enable irq version on CA55 and CA73.

> 
> By coincidence, Yang Shi has been discussing the this_cpu_* overhead
> at [2].
> 
> [1] https://lore.kernel.org/all/1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com/
> [2] https://lore.kernel.org/all/CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com/
> 
> >
> > Will
> >
> >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >> index 38dba5f7e4d2..5e7e2e65d5a5 100644
> >> --- a/arch/arm64/Kconfig
> >> +++ b/arch/arm64/Kconfig
> >> @@ -205,7 +205,6 @@ config ARM64
> >>  	select HAVE_EBPF_JIT
> >>  	select HAVE_C_RECORDMCOUNT
> >>  	select HAVE_CMPXCHG_DOUBLE
> >> -	select HAVE_CMPXCHG_LOCAL
> >>  	select HAVE_CONTEXT_TRACKING_USER
> >>  	select HAVE_DEBUG_KMEMLEAK
> >>  	select HAVE_DMA_CONTIGUOUS
> >> diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
> >> index b57b2bb00967..70ffe566cb4b 100644
> >> --- a/arch/arm64/include/asm/percpu.h
> >> +++ b/arch/arm64/include/asm/percpu.h
> >> @@ -232,30 +232,6 @@ PERCPU_RET_OP(add, add, ldadd)
> >>  #define this_cpu_xchg_8(pcp, val)	\
> >>  	_pcp_protect_return(xchg_relaxed, pcp, val)
> >>  
> >> -#define this_cpu_cmpxchg_1(pcp, o, n)	\
> >> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> >> -#define this_cpu_cmpxchg_2(pcp, o, n)	\
> >> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> >> -#define this_cpu_cmpxchg_4(pcp, o, n)	\
> >> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> >> -#define this_cpu_cmpxchg_8(pcp, o, n)	\
> >> -	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
> >> -
> >> -#define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
> >> -
> >> -#define this_cpu_cmpxchg128(pcp, o, n)					\
> >> -({									\
> >> -	typedef typeof(pcp) pcp_op_T__;					\
> >> -	u128 old__, new__, ret__;					\
> >> -	pcp_op_T__ *ptr__;						\
> >> -	old__ = o;							\
> >> -	new__ = n;							\
> >> -	preempt_disable_notrace();					\
> >> -	ptr__ = raw_cpu_ptr(&(pcp));					\
> >> -	ret__ = cmpxchg128_local((void *)ptr__, old__, new__);		\
> >> -	preempt_enable_notrace();					\
> >> -	ret__;								\
> >> -})
> >>  
> >>  #ifdef __KVM_NVHE_HYPERVISOR__
> >>  extern unsigned long __hyp_per_cpu_offset(unsigned int cpu);
> >> -- 
> >> 2.51.0
> >>

