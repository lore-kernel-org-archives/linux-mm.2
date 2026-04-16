Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C1C4F8E497
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 23:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43EF6B0088; Thu, 16 Apr 2026 19:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3AB6B0089; Thu, 16 Apr 2026 19:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E27C6B008A; Thu, 16 Apr 2026 19:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7136B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:54:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 480328C996
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:54:18 +0000 (UTC)
X-FDA: 84666075396.16.6FED1DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F046040005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:54:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u01eqPN6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of "SRS0=40xI=CP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=40xI=CP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776383656;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Ma/YEM34/TjnsjtTALjS1v2HjUmbXrMzGxb4PxbtKY=;
	b=UQdkeHP0MAWIJJy/3U3AHL3A6r2KydLzE0CpuBUoace8yzzXHzuVJFoatMXPqWMStqsPGO
	3zlxB+31VWxB43mwLy45qUt+AExPRu3Dq8DjSVZ4iQZMBc3ChzjksZ4OUMH2Sx/bid0KKa
	YfqbegyaFu9LOit/UeNQWSZyt8/0LrY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u01eqPN6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of "SRS0=40xI=CP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=40xI=CP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776383656; a=rsa-sha256;
	cv=none;
	b=FuEGFnlHuRLp1f4Xv719FWzrdmhZ1Q0wMeac1kbrfM8k/J6T7ysU/OzY1b9sa7DzP/4fAN
	RXHleaEub75j/Aa8nSBGQjoEjApDBFY77KcBaU3ZIDIUzwM3w4kWvkXAWmlBbM1CW8bedZ
	s9Cm1yz2LTu29wcJ483iDSBZscuHtew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F00F60128;
	Thu, 16 Apr 2026 23:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFD1C2BCAF;
	Thu, 16 Apr 2026 23:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776383655;
	bh=TXSRIJ/h22avk7murAB6glIED87kidjbJTYSFQI5SwI=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=u01eqPN68WSsjD3cD/F6AL+NPCxKGMcCe+WzvehEPA6ul0uV7ztfDDsEJ+a5IcinX
	 UPPadarOwbfuJr8QzuLi2mxLddeRIBJ3bcfV6pHDieviyeDAvnMoG55BhEYB0DhO8l
	 0g8J5C9jfCx+YxBkCqAiO7vYYclrHUVBmGFEzEWPLK8nkf3fgqb77lh+ZBvJ2s7yT5
	 CFIhEwQ5DPGyrxGDnFqdP3YeuOG0l7qRzCsZw+f983jkklXWRSJz9PDgeg+7eD+kfh
	 bfUQIMRk2dAB2NCWcX9Dsbuc1zuPUW9vVsKYuqVLlyyvSsQocAH6Rd2FiPZaUJmybt
	 YeG6PDph5XO0w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id C2A87CE08B2; Thu, 16 Apr 2026 16:54:14 -0700 (PDT)
Date: Thu, 16 Apr 2026 16:54:14 -0700
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
Subject: Re: [PATCH v5 5/7] locking: Add contended_release tracepoint to
 qspinlock
Message-ID: <2bc24e26-7b01-4e43-8f96-35334237397b@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <cover.1776350944.git.d@ilvokhin.com>
 <af285ffefa3fa2f73b73a39e9f06fb176009e047.1776350944.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af285ffefa3fa2f73b73a39e9f06fb176009e047.1776350944.git.d@ilvokhin.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F046040005
X-Stat-Signature: zr4yazbda8yoggoe1xfg759sgwjfdn4z
X-Rspam-User: 
X-HE-Tag: 1776383655-40229
X-HE-Meta: U2FsdGVkX19e33tk9hk8PqMFUM7bMKccZTJ+UYwhg/rJBHdKE5tt19f5f/Qxj2/bS9pZ0/hCmYQ8BVvpL/M3Wst4VweZMjhG7lfAYNE6ESXv8gSV161Y49IeO/0KZrb68p+iXv1nK0wwOyXLYuoeirpYnuFLyRhtiyPEXXWbiKfppz1MgNYc55rzB4roD4+z7TN6qGj38+BfLZ1Ivf/qTWJ+Zm+8wz4CAS0k4jm/E3gnsj9hi+pkn+IbC+6lR1FK9BQaQbWEwphgfw4fIsKwXFqTShvnWtT7f0+RQKdlS/RDHpg/4JNslblJ9IKsX3ydiFbHjwje/sJhx5mwTqPXiUG4yd8EBcwVFutdH+wq1PvT2PyicESAVZI9Ij8SR4cZKEXgVF2PBvYOoLQH/Y955huGDQ40TJ1qeW38kbkqqJZyGn/bLLA4ZdoWSmh8HyvT6mOwaksW0lyQXlPE10dxogxl/JPvyY182JmjWg5K2+0Bs5DquWP+ljQegaRtMQBTVLbPqADth/lkCpa2vkGb11gfSkEMcMk3S5BieJ3ZOE8O99LlC16qv1doczCJZHhX3+2vmQns9OyluSUovGWnO3qh+bw5tK1G6INDjTWcSp/lWt/cw1utZAAtaRp3bD3gRLCqSd0YM8Ve7bCS5UhiqUMeLvhZD84LTOrJ2IzELDAg9C8iXslIpuT9ZMtCFMJ3m3caCSpnIgw7eNnTeZbLx75oFbvG1OzGSw9EvxKVdvgndEX3k6gx27hJE0oEoxz5Bdl3J0I7lUptdAgmmccFl6w/w8+ym0SdihMlD4WYMCJpKah2JsljhLSLySeWImyBjJ5fo2I+55WTtHAMZbm07Diwrc5R2SfQSBEgGLbVbKzaHbmGfOHuUtsoqGfmaWQOhUIlJ61+JLSu/K7nXsU8AViKZ+M5xguvQcZfXthKibdektj09rXSi0iu3QE0yGZMjyv/xoU4cX9ECmjghWK
 1nu2lkZi
 CX8aJVJI7vAyI0vPtdZBJU93HwsVgOpwCQhHhxmWQU5wZbdouFD5nvpZNSILG1+EhMICdc7HLdJWo40bV69Jgk7e6ffsJaEmPJLPCuYlwMp1ILrv+0o1/Iw41UXCvcSihEsqPt1ziCu/2tTq084FFCI/9gzHj+Z6nqVj6kSYHiOI2b333bwcqLEzz5Wp8XIb/djpcLq2AQk/g+tPW2Giac2esCu1DWUeep+arhUTPskfe3eUCi7WGdGa7mF0/k0cCgcQMM4enuYVZZgynJ/GVAjKRimMrKyyxRh59/N4JC6SRbaJ5I3/zWgghtyNL2Vmht+8JvVlBGpwrsyHNofr8TNQa4Q379Le3LSBCjBwCnY31sZEk1b/X55o3tytk57Rmo5MURaXdbpeYxnyemeikwJxG8FzX06nllmL1f+95FqtOydBXJCOoUft3PpwFRTlYHK2ecYkzjnXGmbEZyLY8S4Ha6c5aP/97amF97QvepcT+QJhieHdqJ0skuqu/cW2sHV+dJ6bPFKl/DxvpG/V75i1lnlQtk0DvamKY99ApQm+wVydkDwKYgzTcqp907XoTqM2XD7J7x28AW9bzrnFGOMhMhscgajmoCYpA5qQO3uhDMG4bGAX8xLBdT5GHrrvvo7TtWR8dxtHrk3h17O/Fhf1efG8VrlsQ/f/TBW1cZN9BMEHlMDnNmrYgK+dJkNzvYxaYTiioGamRHi4XjGZAd9821yaZdifTsM1X97yUbPYPh5ZvU/TcSjtQk8h5FdXpSzYN6rPhXPNSXj5fTiUWJPdwFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 03:05:11PM +0000, Dmitry Ilvokhin wrote:
> Use the arch-overridable queued_spin_release(), introduced in the
> previous commit, to ensure the tracepoint works correctly across all
> architectures, including those with custom unlock implementations (e.g.
> x86 paravirt).
> 
> When the tracepoint is disabled, the only addition to the hot path is a
> single NOP instruction (the static branch). When enabled, the contention
> check, trace call, and unlock are combined in an out-of-line function to
> minimize hot path impact, avoiding the compiler needing to preserve the
> lock pointer in a callee-saved register across the trace call.
> 
> Binary size impact (x86_64, defconfig):
>   uninlined unlock (common case): +680 bytes  (+0.00%)
>   inlined unlock (worst case):    +83659 bytes (+0.21%)
> 
> The inlined unlock case could not be achieved through Kconfig options on
> x86_64 as PREEMPT_BUILD unconditionally selects UNINLINE_SPIN_UNLOCK on
> x86_64. The UNINLINE_SPIN_UNLOCK guards were manually inverted to force
> inline the unlock path and estimate the worst case binary size increase.
> 
> In practice, configurations with UNINLINE_SPIN_UNLOCK=n have already
> opted against binary size optimization, so the inlined worst case is
> unlikely to be a concern.
> 
> Architectures with fully custom qspinlock implementations (e.g.
> PowerPC) are not covered by this change.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Much nicer split out!

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  include/asm-generic/qspinlock.h | 18 ++++++++++++++++++
>  kernel/locking/qspinlock.c      |  8 ++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
> index df76f34645a0..915a4c2777f6 100644
> --- a/include/asm-generic/qspinlock.h
> +++ b/include/asm-generic/qspinlock.h
> @@ -41,6 +41,7 @@
>  
>  #include <asm-generic/qspinlock_types.h>
>  #include <linux/atomic.h>
> +#include <linux/tracepoint-defs.h>
>  
>  #ifndef queued_spin_is_locked
>  /**
> @@ -129,12 +130,29 @@ static __always_inline void queued_spin_release(struct qspinlock *lock)
>  }
>  #endif
>  
> +DECLARE_TRACEPOINT(contended_release);
> +
> +extern void queued_spin_release_traced(struct qspinlock *lock);
> +
>  /**
>   * queued_spin_unlock - unlock a queued spinlock
>   * @lock : Pointer to queued spinlock structure
> + *
> + * Generic tracing wrapper around the arch-overridable
> + * queued_spin_release().
>   */
>  static __always_inline void queued_spin_unlock(struct qspinlock *lock)
>  {
> +	/*
> +	 * Trace and release are combined in queued_spin_release_traced() so
> +	 * the compiler does not need to preserve the lock pointer across the
> +	 * function call, avoiding callee-saved register save/restore on the
> +	 * hot path.
> +	 */
> +	if (tracepoint_enabled(contended_release)) {
> +		queued_spin_release_traced(lock);
> +		return;
> +	}
>  	queued_spin_release(lock);
>  }
>  
> diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
> index af8d122bb649..c72610980ec7 100644
> --- a/kernel/locking/qspinlock.c
> +++ b/kernel/locking/qspinlock.c
> @@ -104,6 +104,14 @@ static __always_inline u32  __pv_wait_head_or_lock(struct qspinlock *lock,
>  #define queued_spin_lock_slowpath	native_queued_spin_lock_slowpath
>  #endif
>  
> +void __lockfunc queued_spin_release_traced(struct qspinlock *lock)
> +{
> +	if (queued_spin_is_contended(lock))
> +		trace_contended_release(lock);
> +	queued_spin_release(lock);
> +}
> +EXPORT_SYMBOL(queued_spin_release_traced);
> +
>  #endif /* _GEN_PV_LOCK_SLOWPATH */
>  
>  /**
> -- 
> 2.52.0
> 

