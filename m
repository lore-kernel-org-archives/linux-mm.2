Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72709F9D0DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 23:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77966B0088; Tue, 14 Apr 2026 19:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50226B0089; Tue, 14 Apr 2026 19:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C406B0092; Tue, 14 Apr 2026 19:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A73866B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:11:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B56D138CE8
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:11:54 +0000 (UTC)
X-FDA: 84658710948.25.779CF14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7C1621A000B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:11:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V3PiMs9h;
	spf=pass (imf19.hostedemail.com: domain of "SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776208312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7yiQ4GuOf19tyg+Icm+bJAptf4kAy67/F8rV4Uw3eQ=;
	b=ml8UHOyf6/wa2rVKsHtWLXJ96MqH4/yEv3eNJ7CYr5CJy6Q/At3F8KdVkeuKaguVy18kEf
	SlgqCcR2WUBxWvn1uY/xRNQhtTRbaM2LUDI6HggLiZabWfXwLw+iKee31EG2kxXQPyrlc/
	Tmi0IHHpR+JE9ujwoK2Yw7Y8WuqAZMc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V3PiMs9h;
	spf=pass (imf19.hostedemail.com: domain of "SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=JV0k=CN=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776208312; a=rsa-sha256;
	cv=none;
	b=r4ahM8lceQzD0Izg71IUrpYmDbsedHQAstqavztbElTZiphIkfLniwQ0n/8tjHHRVMAzkE
	LOMYcyBI9ZN0Se/dPcqMWuZqHZ1OUD04nNnrYXdsGscT6mq+RyiU+VbqpWLQatkdOxm+Gr
	+Ky913ySBt71DgSGFYPeV2Ff0511xqc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43E6744341;
	Tue, 14 Apr 2026 23:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BED0C19425;
	Tue, 14 Apr 2026 23:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776208311;
	bh=R8XiXnmNEFMK4hw6KfSubp/WFYUzB4aHlNAwFNTNhJ8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=V3PiMs9hgRtUF05cEpSP5akhX3fb2Gfnh4UfyDoeN4U7OGQyYagrx+0aIM88025LN
	 njYj1T8JKNWYcWKEUcV11NVmN+EXo7+055JWUA/o2cnaouBSaXdHbkaLZEjXDKKOpe
	 6sRX1ILrkwQ0Ro3an5LjudM9BoL2W9fsIpcqwtmRcyz1icYqvhmyav3rBqofSfFr14
	 JsXPlB62TIKSFHJ2EvOz/DCP22f4xqPGBthRbAnitCziOwE+31HcTph0fY/8wvGCQy
	 Udx4nhbWP8WaBAtzy2THWRuQ4+RTppkXVmxHUg3ow/PcdD6NTYe7pEeYk4b4DcYDuV
	 40ehIqZB+gbXQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id B344FCE13BF; Tue, 14 Apr 2026 16:11:50 -0700 (PDT)
Date: Tue, 14 Apr 2026 16:11:50 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 4/5] locking: Factor out queued_spin_release()
Message-ID: <d0c4d8da-a9bc-4efd-9a92-553a5cbd2a1c@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <cover.1774536681.git.d@ilvokhin.com>
 <c15d0462f57722aa9e7bd4fd4ec1b48a0420c442.1774536681.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c15d0462f57722aa9e7bd4fd4ec1b48a0420c442.1774536681.git.d@ilvokhin.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C1621A000B
X-Stat-Signature: twfhd7egsqxtfkn5fgr5ptmxcuc4s5fz
X-Rspam-User: 
X-HE-Tag: 1776208312-241177
X-HE-Meta: U2FsdGVkX1/y/FzNURsgly8VJjGTlNwKfw78zblUjTTVPIIjTOfm63AqJ7orPt9dtC99kuHk0l9NsysGLgXcz4ixEdViR38P3VVu8HOt4zn/P+/wxO8lw158TxGqUuG+Q+sjthMt66zByTfars5XuRknQFLKfl1QslEXvC6EBpOqna11I1rIIXvFhMG4EJm6dXPZWErTCqnHeE/9v2n2T6c+sl8lzddzqmPCLgU6yWGoTGUnhF0cJzoY5s+JSvLmbwjQM4GXgffJI61vrjKIfKj4Q54don1VyOaTdQLXTrypu3Xdf6uTxCLQno+fIyA93mbWF3AoqLxmOZ2pSWlj5iNRx3s3h1R/r+hLjZvTxR3p4sYQSoG572hg/LnIqgZXUfiLMwWOK4YJ9i24naZ3EfKEyG3tHj/IEomdjwwj+g5+TfBpZOr+2RsT76EAGela774NR+ZLdPu7yJ1tIAZTiJc2cmr6biu/wMGze97KzEAyPoZZANx5dSa023zItcIO787GWapuMVqtbO7hTX9rUmjAMyUiv/kgIlU3QnSnngn7cVJ+9lfPnMBiQ0kjHBLelOSE5822pMzZYkWpleKkMi+xefxBNcUvZVeGSTNlDD5vMfoJcBSdKBiG7AYtKLkJyYhUpvneDJXw9M4azP+Ssw3jGgSRE9fWqD//hTCLjpBUvbI6gDK7+eIIpdB+6atRRE6L79X+XG3jSMJbkxYrWjpabW4LPF0Z9wKYUP26pkpunQkEZOoN63Q/vVzyMj4iVoNO9s8yw8fQLRtC6RSLd65gEDNlxJwuSjmAgZUd/KJkFAdgBa0B11NxnEm0AkX3bIEznuC7r9RObfqsl1rDmEuP5OR1QlTUEgmwUapxKcAwWgdZQeEf1i9d5Txm+3+MNpmcyFlhE+ng2p51TwEvp8qA06KKVPDGo+e6GhVfkqOucXQyp2HtDthyXeugyi/ENVCtxvpXWvOeRgexzJs
 Dp6kTjiO
 rpU8tFBxo2kFB9WRIefl/81tobYAeLpOjRAG+gN+xea/gKUdlsfTd6hns7Y77eMQKV/jzRU8I5esAUEuLoiSOKVPTN9BNiLrpyxkgM2qzi5e3Up22MpLlmSXHgcQ3nwb1knrAIZtDuJ8Z1LS9LfShBNe2KHgbcT31yjIyuerGWyl6XhRRVXuTX+Y3cn+LYSZ561CGR5hkiqqfFxzkAXOwTeBw+OwKDE/4uGnzim5/Vps+T/getiN45+YGswLVOYo+kGir/WYtWVlw7EtQxFS7+HygfMgKIbcBlx/ElKNlk6n/u5PSoV954+n72whWwUnEM8UNxbA4mzhzJsWXKv9tPZ/L6C3L90hLCKQvcTLyjDyEBfy+7vTMZau3HrlPEGeVaRUPxYZQOWtuuNsXvhMSx4tdeKpQTL9DUtQJodpY75e6891FvKuTpBFKo1ijVIEzxUSG7yYycVokUZrOssyWC4wSklO5EV1AOtyyXvhaXPcUf/QW3A71f8Ns75097rJtGvyrouOSm2xJJWyMe3dQmbq9ljKsEamD+t1PrnZJWG776cpntx4RuBTQGhuLNmuA74RHbA2qo4BkrebjDTvwdd+ryvC4D0Lq1nfQ4Qk2Z8k+GPhaWMUZJ42FriTAi87R4+SqLO+O8mql9icyObsiuCnkIAMamOZxDcK4w58lPAUT5WdyNQYc6DVBm1TA6EQuTyCljnGI+GGUUDD5URPnBU4PDtdUQPUi/abuCzExZbQMRpyswRtS2Q3pk3MH7bNVLjFmuGfSCvV92T/Odfd/nYCv4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:10:03PM +0000, Dmitry Ilvokhin wrote:
> Introduce queued_spin_release() as an arch-overridable unlock primitive,
> and make queued_spin_unlock() a generic wrapper around it. This is a
> preparatory refactoring for the next commit, which adds
> contended_release tracepoint instrumentation to queued_spin_unlock().
> 
> Rename the existing arch-specific queued_spin_unlock() overrides on
> x86 (paravirt) and MIPS to queued_spin_release().
> 
> No functional change.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  arch/mips/include/asm/spinlock.h         |  6 +++---
>  arch/x86/include/asm/paravirt-spinlock.h |  6 +++---
>  include/asm-generic/qspinlock.h          | 15 ++++++++++++---
>  3 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/mips/include/asm/spinlock.h b/arch/mips/include/asm/spinlock.h
> index 6ce2117e49f6..c349162f15eb 100644
> --- a/arch/mips/include/asm/spinlock.h
> +++ b/arch/mips/include/asm/spinlock.h
> @@ -13,12 +13,12 @@
>  
>  #include <asm-generic/qspinlock_types.h>
>  
> -#define	queued_spin_unlock queued_spin_unlock
> +#define	queued_spin_release queued_spin_release
>  /**
> - * queued_spin_unlock - release a queued spinlock
> + * queued_spin_release - release a queued spinlock
>   * @lock : Pointer to queued spinlock structure
>   */
> -static inline void queued_spin_unlock(struct qspinlock *lock)
> +static inline void queued_spin_release(struct qspinlock *lock)
>  {
>  	/* This could be optimised with ARCH_HAS_MMIOWB */
>  	mmiowb();
> diff --git a/arch/x86/include/asm/paravirt-spinlock.h b/arch/x86/include/asm/paravirt-spinlock.h
> index 7beffcb08ed6..ac75e0736198 100644
> --- a/arch/x86/include/asm/paravirt-spinlock.h
> +++ b/arch/x86/include/asm/paravirt-spinlock.h
> @@ -49,9 +49,9 @@ static __always_inline bool pv_vcpu_is_preempted(long cpu)
>  				ALT_NOT(X86_FEATURE_VCPUPREEMPT));
>  }
>  
> -#define queued_spin_unlock queued_spin_unlock
> +#define queued_spin_release queued_spin_release
>  /**
> - * queued_spin_unlock - release a queued spinlock
> + * queued_spin_release - release a queued spinlock
>   * @lock : Pointer to queued spinlock structure
>   *
>   * A smp_store_release() on the least-significant byte.
> @@ -66,7 +66,7 @@ static inline void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>  	pv_queued_spin_lock_slowpath(lock, val);
>  }
>  
> -static inline void queued_spin_unlock(struct qspinlock *lock)
> +static inline void queued_spin_release(struct qspinlock *lock)
>  {
>  	kcsan_release();
>  	pv_queued_spin_unlock(lock);
> diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
> index bf47cca2c375..df76f34645a0 100644
> --- a/include/asm-generic/qspinlock.h
> +++ b/include/asm-generic/qspinlock.h
> @@ -115,12 +115,12 @@ static __always_inline void queued_spin_lock(struct qspinlock *lock)
>  }
>  #endif
>  
> -#ifndef queued_spin_unlock
> +#ifndef queued_spin_release
>  /**
> - * queued_spin_unlock - release a queued spinlock
> + * queued_spin_release - release a queued spinlock
>   * @lock : Pointer to queued spinlock structure
>   */
> -static __always_inline void queued_spin_unlock(struct qspinlock *lock)
> +static __always_inline void queued_spin_release(struct qspinlock *lock)
>  {
>  	/*
>  	 * unlock() needs release semantics:
> @@ -129,6 +129,15 @@ static __always_inline void queued_spin_unlock(struct qspinlock *lock)
>  }
>  #endif
>  
> +/**
> + * queued_spin_unlock - unlock a queued spinlock
> + * @lock : Pointer to queued spinlock structure
> + */
> +static __always_inline void queued_spin_unlock(struct qspinlock *lock)
> +{
> +	queued_spin_release(lock);
> +}
> +
>  #ifndef virt_spin_lock
>  static __always_inline bool virt_spin_lock(struct qspinlock *lock)
>  {
> -- 
> 2.52.0
> 

