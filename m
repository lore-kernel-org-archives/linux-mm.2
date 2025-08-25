Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA4DCA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B788E0029; Mon, 25 Aug 2025 10:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F258B8E0001; Mon, 25 Aug 2025 10:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62618E0029; Mon, 25 Aug 2025 10:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D13118E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:01:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50B9814041E
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:01:53 +0000 (UTC)
X-FDA: 83815443306.26.D561F88
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7793A1C0021
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:01:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B+P4bdmi;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756130511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPgSUMJf5codEnURr4Hznq67HNZbGbqwGKL9x2Vb8KI=;
	b=R0tloo0tVtCL/QnU7gkPi/PxXbNwDB4pyRApsgA9NcQ+HFwQqghkm6ZknjtiftSjYemQcc
	QTEfnQl2mAwBh8OL/d8kc/oswUilxk+R4X9HJ1x8V4EqpmJ31kXgEUxWzKSpRsFpEgHdNH
	jt1IJ4PMqYToeY+j4GdjfSEPvwgqlXc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B+P4bdmi;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756130511; a=rsa-sha256;
	cv=none;
	b=YFUQNhqChcoM+Ll6mVdFFlDHYM+GYI2NQgTxlVmT8yHa6irKeNULuFpSTGhWmy2/xPrCZa
	V6KSa1etFD2SYZop1M3qfDqa0kQ2Bth1K1bs+R91KjVXu7GQoaX3rNeg+d5s3yrnVTawAz
	/obLzFPFKjSRc2PCG/ECAgInGp0AOlU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3EED35C5DFC;
	Mon, 25 Aug 2025 14:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D597AC4CEED;
	Mon, 25 Aug 2025 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756130509;
	bh=JYK5oZx2jKAoGrqaNkjjnyjA3UiseVMaOJbii9Eo/aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+P4bdmi9cT5ft6PawuA6vnhqp21nyGNK7WDeDtmw/FLomN9WHQc3dbJhc8Lg5HyH
	 7rb0HFOIuHa8mmRXv2Wx+Tnu5lI7xBC/AM1kAi+pGpfMM83+QiGVohyp0ecbYqQ2jp
	 Nk5UrKQDuAU3UdohGu9UC9C5Yn/SRowMZBtKLhbwtaKtc8tZbLqTvylx9zG1cTUldH
	 YFcgx2q0G2YBuHgRmwCebPdVUlkne55rdbRsNPOpFB5NhboHVIbtHXQyG28pi3Fz1f
	 dmvyqcOz+ybEWaNi3pkk10d/0vm2aXBe62lUAdUeXqJgDd/T6qCRwUAMuzVvQe+35m
	 rVYnNuaHDYJow==
Date: Mon, 25 Aug 2025 07:01:49 -0700
From: Kees Cook <kees@kernel.org>
To: Bhupesh <bhupesh@igalia.com>
Cc: akpm@linux-foundation.org, kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com,
	laoar.shao@gmail.com, pmladek@suse.com, rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
	david@redhat.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
	brauner@kernel.org, jack@suse.cz, mingo@redhat.com,
	juri.lelli@redhat.com, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, linux-trace-kernel@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [PATCH v8 4/5] treewide: Switch memcpy() users of 'task->comm'
 to a more safer implementation
Message-ID: <202508250656.9D56526@keescook>
References: <20250821102152.323367-1-bhupesh@igalia.com>
 <20250821102152.323367-5-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821102152.323367-5-bhupesh@igalia.com>
X-Rspamd-Queue-Id: 7793A1C0021
X-Rspam-User: 
X-Stat-Signature: mwh5z566tmndubokzh7ti4mmtjpgj5is
X-Rspamd-Server: rspam09
X-HE-Tag: 1756130511-724607
X-HE-Meta: U2FsdGVkX18d5el3B9fsRNxVui8cCfUAkTpBlsG1WAXFgOx/kfrQ8ALqEnp7sc0hE2t3PamwouThoVLUtVzwB6Enp3Ri75t4KVtewHzNKeMFKhzMTg6ccXFWKTVSYFd8D44L+WvsXxyNeQnaiA3VMeBlPxgBmYQxqsH1SLTIUU91iI821ZpRr04IwIW9uaYIWZGoUolV5s/g58SlZup60xxBkQSyCBF6FafnlXTb1OfcFkI6Vdttu1lUNpYnLGd0hlElfNrHDvWieIXS4jtGEk3nVXaTR2O8+N19p9h+K9+3KUAJD49rjSM8T9ub1Cm4y1EvdqmhitzAspcCP7P3j8x4G2BQrK9Sc9Ta4023ArFbrM9mQz0CWXmVqvDWlbxo6oAib0b1GMd/Zs6x3LcYPBvEVH5G1aI/0TG4056clKfTDKvzPI6eGtWviB+Z9Te17llsk55SFSpvAKb7tDqLkRxJIcXAlGsiUGs8Jub2fY8EIYlR3bJQl6EDgfSswNyny/ewH7pGa/081aNX32ivZmQxNRJzpsmGUc+7AeuSCBgnXlSINzeHBPwiMmw2rFgwQwkkjXmT/h5J3OYXyBJ5jzlWOOJX2YmLT9XrlUPKcyTUwGRcCaGgdBbPoBEW/zmLIshyLE+m41BY95WxfXQxk4E79kq9XkJbUXKiCCReb3wSQPGmylQeox6HcBQHuIAcdtRVaJe68kM0es90EX8omn6Q7dCFQs7JCoRwe/Ic6mTNSUBezDzwPWgcpwUfKgw0f1rrHFPMI32/eo3vvPBtQQA6P+4JstDjpS2vgPFOmMvLe3FBfZb7qaM+F3s44e2dkGlFVA32si+V3d1aEymzsEJcJge4VckUn7KW2q/MqV3YyZaBp/yrDtpY0/vPdSETNfbzIZ00eyg+u34UjGDfu9aAEp3YGblntOQ72GIJ+dNdD//an6DMH/4RgPouGUphrjiqxp0ubsjt4UXd0hN
 TsTBXdZr
 YcIiNv7aMCsiCytQhW/mnh87dNWGDTIiODJGUkXq4RNxgLx8+6Ytr7ErPhob/NLmvL9wm4i9H3KixQRwMkggBOAB2o65hPCGEQc9fZDAI4wS60979bbmbBbLCZWjl+cEEqQIdr7w3TBuNhBkEW/uAnn8/2QqgY+iSZrJ7txFw3oRU/N6AqmBhettKQ9mkLjIFC9iolJaVEQ1GUF+uN2NvUxk6QfNvMJniLFXI4IlcJkB3jbdfN4G0Tul8wgT7+eiCT3gt3P0BbQqFF0vHRTtkvPkNqK3Oc1m2YvMwR9IsA+XKWy44/SBqMPOIfkcBNULrgdTSAHqzLmCf6hUApXNDdePHXJ8/H6eywdpNhvUPl+OaU9MG7p7zRHcCd9VWcHiH8mdvRRuHpMO212341CUS9JEJrul2yfkBzyru/fxOvDLnZBQnDH/ldAW+RbChYO69CYdq+xd/yHcDu/+9Ka0mkJ+mvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 03:51:51PM +0530, Bhupesh wrote:
> As Linus mentioned in [1], currently we have several memcpy() use-cases
> which use 'current->comm' to copy the task name over to local copies.
> For an example:
> 
>  ...
>  char comm[TASK_COMM_LEN];
>  memcpy(comm, current->comm, TASK_COMM_LEN);
>  ...
> 
> These should be rather calling a wrappper like "get_task_array()",
> which is implemented as:
> 
>    static __always_inline void
>        __cstr_array_copy(char *dst,
>             const char *src, __kernel_size_t size)
>    {
>         memcpy(dst, src, size);
>         dst[size] = 0;
>    }
> 
>    #define get_task_array(dst,src) \
>       __cstr_array_copy(dst, src, __must_be_array(dst))
> 
> The relevant 'memcpy()' users were identified using the following search
> pattern:
>  $ git grep 'memcpy.*->comm\>'
> 
> Link: https://lore.kernel.org/all/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/ #1
> 
> Signed-off-by: Bhupesh <bhupesh@igalia.com>
> ---
>  include/linux/coredump.h                      |  2 +-
>  include/linux/sched.h                         | 32 +++++++++++++++++++
>  include/linux/tracepoint.h                    |  4 +--
>  include/trace/events/block.h                  | 10 +++---
>  include/trace/events/oom.h                    |  2 +-
>  include/trace/events/osnoise.h                |  2 +-
>  include/trace/events/sched.h                  | 13 ++++----
>  include/trace/events/signal.h                 |  2 +-
>  include/trace/events/task.h                   |  4 +--
>  tools/bpf/bpftool/pids.c                      |  6 ++--
>  .../bpf/test_kmods/bpf_testmod-events.h       |  2 +-
>  11 files changed, 54 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index 68861da4cf7c..bcee0afc5eaf 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -54,7 +54,7 @@ extern void vfs_coredump(const kernel_siginfo_t *siginfo);
>  	do {	\
>  		char comm[TASK_COMM_LEN];	\
>  		/* This will always be NUL terminated. */ \
> -		memcpy(comm, current->comm, sizeof(comm)); \
> +		get_task_array(comm, current->comm); \
>  		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
>  			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
>  	} while (0)	\
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5a58c1270474..d26d1dfb9904 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1960,12 +1960,44 @@ extern void wake_up_new_task(struct task_struct *tsk);
>  
>  extern void kick_process(struct task_struct *tsk);
>  
> +/*
> + * - Why not use task_lock()?
> + *   User space can randomly change their names anyway, so locking for readers
> + *   doesn't make sense. For writers, locking is probably necessary, as a race
> + *   condition could lead to long-term mixed results.
> + *   The logic inside __set_task_comm() should ensure that the task comm is
> + *   always NUL-terminated and zero-padded. Therefore the race condition between
> + *   reader and writer is not an issue.
> + */
> +
>  extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
>  #define set_task_comm(tsk, from) ({			\
>  	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\
>  	__set_task_comm(tsk, from, false);		\
>  })
>  
> +/*
> + * 'get_task_array' can be 'data-racy' in the destination and
> + * should not be used for cases where a 'stable NUL at the end'
> + * is needed. Its better to use strscpy and friends for such
> + * use-cases.
> + *
> + * It is suited mainly for a 'just copy comm to a constant-sized
> + * array' case - especially in performance sensitive use-cases,
> + * like tracing.
> + */
> +
> +static __always_inline void
> +	__cstr_array_copy(char *dst, const char *src,
> +			  __kernel_size_t size)
> +{
> +	memcpy(dst, src, size);
> +	dst[size] = 0;
> +}

Please don't reinvent the wheel. :) We already have memtostr, please use
that (or memtostr_pad).

> +
> +#define get_task_array(dst, src) \
> +	__cstr_array_copy(dst, src, __must_be_array(dst))

Uh, __must_be_array(dst) returns 0 on success. :P Are you sure you
tested this?

-- 
Kees Cook

