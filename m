Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D2ACD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407BE6B0093; Thu, 21 May 2026 03:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DEDB6B0095; Thu, 21 May 2026 03:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B526B0096; Thu, 21 May 2026 03:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9F06B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:04:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C04FC14054A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:04:53 +0000 (UTC)
X-FDA: 84790539666.21.459AF06
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D92C4000E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:04:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=rTEG3Unb;
	spf=none (imf27.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779347092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x50blBBEh1e8KVa5ZRCDfRRnzgZM/gDu9glUwswplyY=;
	b=3yUWi437kRj7uT3SmQ5fEjkQa7/6CxW0Na1XuU+k9NKc/PhPSzy/na3SHFqYRKfbMEWu5D
	vqDtjq1zwvHsEn/TccZlcxatnLSEbrK5CXn+fKPabUMPtIOjwAt0BOS69YffaNTgdZjkuR
	fOqxGrgojBGll20RMQGzinGD9OC4hAM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=rTEG3Unb;
	spf=none (imf27.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779347092; a=rsa-sha256;
	cv=none;
	b=5KJ2rAWHhN+1OrdJhoQ6JIf0QaQTwWBfh/bxguLCds51oTOJbCc4wbtky/0ClhgVWcXG7u
	3cfAdpso/tYL38gYsVuOyYMqaFcrtmdHEFCQwz+JbXngYKW7jzuwA6YbA0lN3W7dNXyy8v
	aTI6RMtosmxkmf9c0W8skutnX7QA8ww=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x50blBBEh1e8KVa5ZRCDfRRnzgZM/gDu9glUwswplyY=; b=rTEG3Unb87EY3k9vOcIDMPJ5Hm
	b+lB5aWsNIS71plFnT8fY+rPveHFkuGn5NBEEeVUdW6oM2rOD+bq+nMh95mQkZXcUgJHPe4QKQEOU
	LgfdKnaxdLewiT6s6UCAXptn/F+oOUS6lCHn+Emfp0Mdv2tnr68exEGqYFDdTtSpLf3nmgb24cV3/
	Ir4IRVDxoK+TgrczqsFHAHCv2Te9fXk+xcds2PomiasmhDOkR4WWyUKFZqPXfY6j4UCvvOTarHNvL
	oB/R2DQUe5hoQYGSIHyqphDbEGQ5kY+Y1JCVqJh5oeCaspIHfUKN77J3KUr5GPi+H5OpeWBzLfGxu
	WQe2Ux7g==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPxST-000000012Uv-2oOU;
	Thu, 21 May 2026 07:04:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 26E7F300446; Thu, 21 May 2026 09:04:40 +0200 (CEST)
Date: Thu, 21 May 2026 09:04:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Guanyou.Chen" <chenguanyou9338@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Kees Cook <kees@kernel.org>,
	chenguanyou@xiaomi.com, linqiaoting@xiaomi.com,
	chunhui.li@mediatek.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] sched: restore timer_slack_ns when resetting RT policy
 on fork
Message-ID: <20260521070440.GD3126523@noisy.programming.kicks-ass.net>
References: <20260521025250.1469390-1-chenguanyou@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521025250.1469390-1-chenguanyou@xiaomi.com>
X-Stat-Signature: e8ew44zspphfakt89611951o6e9zkmhf
X-Rspamd-Queue-Id: 2D92C4000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779347091-2135
X-HE-Meta: U2FsdGVkX18BnpGJ8AasnUkClk01z+PJmo2/7ESCWyxHXkM2lAjVvb2XqtfmjUq0Yw0hxtMmBI+Th13ThUeVz1wCACn/DoEY3Ek7NK7sz6hDnae5mM3ojMSQEijaVaWLuLLqAnkXO6o82ag2KvjC7gOgvfjO7VtxxViMGcwMlVp4BUUkDU4h+i44nD4GlEijSa0009gz+FkY7myIKCQ7yHriF53ZcAOJprnxswv4a+g928r86+lZuBssE6Xga0BUE6rXSuVprPm7mNSKIYDIgN1CxpALE6HqXt3t/bW+1wK6ea/ejH0rouvu6FChWrVBTLhuiJUzS1hE6kDFBzQKsD+tUHXXHApTZ2aAj3h+QMK/QelkK00MLjQ9YzFPB+vHyhF5B7heHj9uSzBApiLV+BeICS2xRZx8o4G1Xen7Opnx2oiBKxrgrGiXI71JWNUIxvdbXHwZBVsp6oVy9HYjiIKcBR3NxOu41fdaq6735D8d2hZ1vwXYzCh6v/JqmcXTZ+FrKhQ3rvdVnjKZt/4aHS2T1l+WFG0MzWqYgzGiUjqOO5ahBHLC1sg6GH/4M44yN4kKPzcpVO+IVGyGLHn2RYcRD2E6S/RinOfiaEuxYPcZdtrgf7vEb4Eql9zy0PQqOtYfxoGNwzShyiI2Kx/sO3VHjKHO9K0UXEH05OTt61bTnyFg6blFVJm/Gp/jFKOjn1S6b40sR0/zyGVznrYRuedVuqFZCWcryNiiNa7NW9yevSRyhVOlAVvaWHJofOceaDnBDG9Ot1vpWqsgS0nfr7Njv+QQVYvWNvu5YU9Rf1bnoWmBCr+UGq5KEAn4pkiQdbgUlXrkpRDl6eAi3Jh5aaKdpeZxcWoPMaHUjQO3SaFKUo033/G1UlvDf3aZYZKLiQhXUC4SOEamy7rN+Mdu/sjAlXRmqLXQI+o+ec7QRaNFEH297AQc9/FY8FTwkdT0K+ozKAS3HJjYHijbQ8m
 nEAbmidK
 N1Q0X0w1T189p0DY+bXiEx8xiRUCVoeAD8zPUZ+KkyOVdJJIMj6CMLa+FkZ7C2Di3yEh9m0nu83CG2/l81TV3xv9SChARpenS5hWyTQX9SQLrpdssvsQyEXJBnPQQGJNThYQNQPX0f7oe+vpi9MFOmMIXSBhNjGnc5ezAK71x+KXfu3w20vkaM2AGW2ykxH52vwEi9Z/yi/lKGbLX2iC1A8d+vJ3UgKNol9+HAKoZo25uVlnidM+ZpYjZdF2qizr3J5zSdQE0sbq2KJUD0GGRf4/MpEeGxrYjPE9b2r5qP010RJumzlLwLxc4yMxMCDKcACbv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 10:52:50AM +0800, Guanyou.Chen wrote:
> diff --git a/init/init_task.c b/init/init_task.c
> index 5c838757fc10..57ff8dae9bfb 100644
> --- a/init/init_task.c
> +++ b/init/init_task.c
> @@ -170,6 +170,7 @@ struct task_struct init_task __aligned(L1_CACHE_BYTES) = {
>  	INIT_CPU_TIMERS(init_task)
>  	.pi_lock	= __RAW_SPIN_LOCK_UNLOCKED(init_task.pi_lock),
>  	.timer_slack_ns = 50000, /* 50 usec default slack */
> +	.default_timer_slack_ns = 50000, /* 50 usec default slack */
>  	.thread_pid	= &init_struct_pid,
>  	.thread_node	= LIST_HEAD_INIT(init_signals.thread_head),
>  #ifdef CONFIG_AUDIT
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 65113a304518..8358df80e11d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2133,8 +2133,6 @@ __latent_entropy struct task_struct *copy_process(
>  	retval = -EAGAIN;
>  #endif
>  
> -	p->default_timer_slack_ns = current->timer_slack_ns;
> -
>  #ifdef CONFIG_PSI
>  	p->psi_flags = 0;
>  #endif

Cunlong makes a good point in that this changes behaviour. That said I
do find the current behaviour 'odd'.

*IF* we want to change this (and changing behaviour is always dodgy),
then it should be a separate patch with a separate justification.

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b7f77c165a6e..b1a241810ce0 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4649,6 +4649,7 @@ int sched_fork(u64 clone_flags, struct task_struct *p)
>  			p->policy = SCHED_NORMAL;
>  			p->static_prio = NICE_TO_PRIO(0);
>  			p->rt_priority = 0;
> +			p->timer_slack_ns = p->default_timer_slack_ns;
>  		} else if (PRIO_TO_NICE(p->static_prio) < 0)
>  			p->static_prio = NICE_TO_PRIO(0);

Yes, this matches __setscheduler_param(). And yes, this wants to be
done.


Anyway, while looking at all this I found that the manpages specify
RESET_ON_FORK to apply to CAP_SYS properties; which is a tad awkward,
esp if we end up allowing unpriv access to DL (or even FIFO/RR when
isolated in a bandwidth group).

Additionally, it doesn't look like PR_SET_TIMERSLACK is CAP_SYS guarded
itself, so this is all a bit of a mess.




