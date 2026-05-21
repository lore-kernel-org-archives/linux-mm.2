Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C33CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28AFD6B0088; Wed, 20 May 2026 23:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262FB6B008A; Wed, 20 May 2026 23:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178CC6B008C; Wed, 20 May 2026 23:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 051A96B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:18:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9833BC15BF
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:18:15 +0000 (UTC)
X-FDA: 84789968550.16.5F55553
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9C41940009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:18:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MCJQX5Iu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779333493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qu9iir3pCu4cSscjSYZYfAghrF1OMpQoowsUczWvTmY=;
	b=HEK+enxjqpmJNZ4oGLre5PbKbEl2K5FtVA/6ykanES2u3qy5HqHNvejuZTgPsCHfbyquQ+
	Yhlelfu5ZzfTWFYGFTHw4WCc8Cjy7G74yXCwemqb8bENaq5FNVffxaN38qFluY0yl1V8q2
	3wzNSKAXNoHgLsBLfeK0doOH/rkZKI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779333493; a=rsa-sha256;
	cv=none;
	b=I1xvfKO4Ogo4J3+U7YJ3aHz5N+IWOTq+luX8VTdAOFmBWVztreYRSGOD08RN2VTTzQvmeP
	tHwrt49HohvOaFxVwHC7yD+aNdb3ZsLIV24tywEPS9RD+zniFHneTtpmRBIokB8VwdOu4a
	7I9V9Jh/T0MaJygr5aG0pLCp4f5xWwM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MCJQX5Iu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ba17c8cfacso52691615ad.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 20:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779333492; x=1779938292; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :mail-followup-to:references:in-reply-to:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qu9iir3pCu4cSscjSYZYfAghrF1OMpQoowsUczWvTmY=;
        b=MCJQX5IueQbjTaYoOavL5iJ9BXZQXnY6iH84CTFtVfLUySuar82CRUzVCqKbuKM6bi
         8OFT0FtjTqSmthRKfXrAG+nddHCzrQQi/Bjqj0Lo9baTNHWP3ruDMd6ZRQI93bnRxsuE
         kEb40gMMdfvSxryI4Y61Hh9HM4Pv7Ob14scvy9JvbjePhQGSiV5rGSFA3/6GuCNfV4nK
         SLFHDwrhvxxBzbAOIepqTLK9zceBJ056vpePyC5vDB4nkZcbFycsB3lxteiOeUlZUQnk
         q+9fBP4S3h+t0YVOHI4wk6am3CxJ7co+t07S/+w7fcEWQbIO05gjqDJJn2mlVLoqGHNb
         ZtYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779333492; x=1779938292;
        h=content-transfer-encoding:content-disposition:mime-version
         :mail-followup-to:references:in-reply-to:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qu9iir3pCu4cSscjSYZYfAghrF1OMpQoowsUczWvTmY=;
        b=NKFOL7AdstOYRi0R8zLN/9kyaBy8X964c+VGDOBS6LizIunp5v6sAdpUGfw8Q+CWJU
         F2VH3rQZ7ks2DjMu0BAevR7o+pszVF/oH8Roy/p83sFB5N6zaq0EKKP5auP0i88Z6Tl6
         +/4sg/W26WoyXe1I3eBQBPeSk8rGPPcHHIfltHaKb9uTmMMFHkn9AbCSJdc9Dm4g7CUy
         ahjWstm5qQKIkB0vl826vzNAz85zzaYk3drtgWfBXWTX3viw8UZE63Jn0XQWjaBoh4Sa
         gqc9s8Rk5srWsTRj6r07201trlIHc6eE8ZBoL6yvMHvQVRJ2n52flNyvdI5qa45D9/Fe
         z6zQ==
X-Forwarded-Encrypted: i=1; AFNElJ+fgql3OI9qUxS6KmYqnwlRi1MmbtImWwGYfrUGNn8czFxtHeYbwsHHd5pYopZQa6HjXid4MHx5tQ==@kvack.org
X-Gm-Message-State: AOJu0YwHSIHBN9VnmVt61KI4hxJePCsV8jr25AX73yuCLKK4ZkHm+0s8
	RVUdHe0QH+KOzjlpsZVWSKPLEHewnkU5n/P7H1qJ1maCc38Zx8jcfjFvxW/mM7ER
X-Gm-Gg: Acq92OFx2PUWJih1Ga/Z1TzCSoX5bBYGrOpUe7/9d0TTXI4WiQ0CzQPfelRjEqoIEGz
	2N9/J8ZyfrB8Cr/Vdf5EPbAq9Tv/AaL8wdA8IZDHCeN8hNgForCVS/TDLT9LsPngwjI+z0Nr6ds
	3s/xGzRXrjjp97FWmDj9TQqXyLm7kJYFaYZtt6I69PhfSCDMnAXbMx7CV8+S7yST4twz0myNAwd
	1t5aK4mEv6pzfzvWnOQAfcA7uMPVENPqr0Qv7ln1Kbm7ai2onzfkRrlswoxZJcI9l9I70vzGM2k
	1fZDthbywUu5RrjD82PDt5OcFRKhevnIgqY9was3hjUWMK+6mrsKMDXPDC46l0fczBVUS4mGYq3
	DmcNS8QXfZ96iZcsGR0Xv8PGPJLqH4CAI0Jyze+D2gUj1ONGcVqlnlCGvgpBNy2O3ka8unxc3bN
	nQYQmZc2s19nzKMNOGavVH5NMz+J9kLJnWdQ/icPE8mHjMKFI=
X-Received: by 2002:a17:903:2bcb:b0:2bc:8101:3393 with SMTP id d9443c01a7336-2bea32d0472mr8471235ad.1.1779333492397;
        Wed, 20 May 2026 20:18:12 -0700 (PDT)
Received: from localhost.localdomain ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5cfe47bdsm241094735ad.44.2026.05.20.20.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 20:18:12 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
To: "Guanyou.Chen" <chenguanyou9338@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Kees Cook <kees@kernel.org>,
	chenguanyou@xiaomi.com,
	linqiaoting@xiaomi.com,
	chunhui.li@mediatek.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] sched: restore timer_slack_ns when resetting RT policy on fork
Date: Thu, 21 May 2026 11:18:06 +0800
Message-Id: <ag55bY5OsuM7cbCB@debian>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260521025250.1469390-1-chenguanyou@xiaomi.com>
References: <20260521025250.1469390-1-chenguanyou@xiaomi.com>
Mail-Followup-To: Cunlong Li <shenxiaogll@gmail.com>, "Guanyou.Chen" <chenguanyou9338@gmail.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>, Felix Moessbauer <felix.moessbauer@siemens.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <kees@kernel.org>, chenguanyou@xiaomi.com, linqiaoting@xiaomi.com, chunhui.li@mediatek.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9C41940009
X-Stat-Signature: aantkufxt4ga8nywu8anqxgueitb8kcq
X-Rspam-User: 
X-HE-Tag: 1779333493-457443
X-HE-Meta: U2FsdGVkX19cQTJq3U/9i2BOEueWQ1SR8zdubi7XwqlLrw5eTX5/1tMOC0ozk+6+vDWSdt/7X+iwkbh9YkZ4vGsYCebXCX1zBCjB/F6n3pGXWoX+9oGTn8fKJFKF4ingzvM8kqDIUrD0faIrovdSXluYdhS/WV7NfNF/iFgjvsbzNYiG+cXNePBGZ/BdJmVuLdlpFB7udZZWvxU3AZpWAQI9/rw6Hy2wPGeiLhjzQ4nmCwS4gf96SF6sHL3PbUn7zi3d1mOyvYsZypSLqVsqs2wC76bqSVTzSkdGd4pQE08MGa9CYOj34BSXBTtRIWExkgsCy3+Su8Row3ya1n29mrSKaaoacXO8ehcezKjPEtJLnx5zVP2D/o/CtYpYV+6MGC3z+koIW/sCxciNez9q1dDOvYCVpl8kevXRYBlVttY3kIZSc7QL0060Gifp8Wq69jX6P8L1eW4nJ2ooLPrDVz4zlVsgq3j24ACzr/zPNc/I6srJ4d3GtOj2bJyBoSLtIVsXJk6K0rabosE4LlZxfIqpIJeLSPjOPwrvF9BEzWBR1oA6S3C8xCWp/mIydkmXkSFUvkP15WzaJ2auHPqHv8OjcLJzWioCXOxl0h5EEtM1xUjUnWG+82JlU7NHrEDUATnErhxv1L/7tEvRaJn9aHZl0BE9qK0f65VKEVEHCgK1b9VBu8PIrBIoswOiUwpeYA0eCWArPAbTMnblCDs6T5kExa8N81aRSjw04EDxI6CnnkjnQWSGnpKcXGmp7AciaYu5V6s2/G3gybo0KFYbH4DVCWW0e6D/0k9EPtUttzQpwTc9BId2fnnnzE0Xp8KOSVG1736gmFM1Lzwe5IAWjKjEi5TjHcp1+cuph/t7mKIkoHsdEOSccYNE4jTaVSKvZrEE8LaNCRiT/ac0h0ceBpl9L7nOCP/SQn6XORkbCLnHgIn4bpfLbis7zqrS9kOgTuh52USYf8cS+NxaBcx
 cRFpFtpm
 NZCpynn72mDtWTJ4QQx83MTdps0fvVlkLRd1nUKJKNTQ2Oiw/i8G2t6Ze8LgLTz9X4OrZ+ZmVyIxcdIsRv42iZHCD9rCqnLn4KJva4BhHd+FLoTudtjlcccec0G3uu7jTW3PzfTcpYCIjW8YjvY4m3UX0KlJBPWfvUA/17ukvLjQ/Sqr7J5ereAOCEypD8lUdUGMmBlx+3nSkI+K1SRdKW0xzuV73Q3GsKPOoG4V/z+iKY4mTQsDF9aQnDyRLs1lvyireKCHKEeCic+tB3iiH81TEmNkyRE4WR8gXZKzT5sNSyBEDrieJtVWpm64eUAlKJ50lXtKAzHg+LEQqRm1S6+5cT9S2LF8luQ1JOMks6AZzGIK9Gc6dcEU3ht8qn+yBxlR5d8JOdFi0xXi6eX8v9WWBUO48bnw2Wn/uFJgJU4i6sVWrV3PCJtS8IuXQ2vfGcRdECrt/J1ITjNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 10:52:50AM +0800, Guanyou.Chen wrote:
> Commit ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values
> for realtime tasks") sets timer_slack_ns to 0 for RT tasks in
> __setscheduler_params(). However, when an RT task with SCHED_RESET_ON_FORK
> creates child threads, the children inherit timer_slack_ns=0 from the
> parent. sched_fork() resets the child's policy to SCHED_NORMAL but does
> not restore timer_slack_ns, leaving the child permanently running with
> zero slack.
> 
> Additionally, init_task never initialized default_timer_slack_ns, so all
> processes in the system have default_timer_slack_ns=0 inherited from init.
> The original fork code masked this by using timer_slack_ns (50000) as the
> source for default_timer_slack_ns. After ed4fb6d7ef68, RT tasks have
> timer_slack_ns=0, exposing this latent bug.
> 
> This causes unnecessary timer interrupts and increased power consumption,
> as NORMAL threads with slack=0 prevent timer coalescing.
> 
> Fix this by:
> 1. Initializing default_timer_slack_ns=50000 in init_task.
> 2. In copy_process(), removing the incorrect default_timer_slack_ns
>    override (dup_task_struct already copies both timer_slack_ns and
>    default_timer_slack_ns correctly from the parent).
> 3. In sched_fork(), restoring timer_slack_ns from default_timer_slack_ns
>    when resetting from RT/DL to NORMAL policy.
> 
> Before this fix (RT parent, RESET_ON_FORK, 32 child threads usleep(1)):
>   child slack=0, avg_sleep=38us, ~832K interrupts/s
> 
> After this fix:
>   child slack=50000, avg_sleep=88us, ~363K interrupts/s
> 
> Fixes: 6976675d9404 ("hrtimer: create a "timer_slack" field in the task struct")
> Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values for realtime tasks")
> Reported-by: Qiaoting.Lin <linqiaoting@xiaomi.com>
> Signed-off-by: Guanyou.Chen <chenguanyou@xiaomi.com>
> Signed-off-by: Chunhui.Li <chunhui.li@mediatek.com>
> ---
>  init/init_task.c    | 1 +
>  kernel/fork.c       | 2 --
>  kernel/sched/core.c | 1 +
>  3 files changed, 2 insertions(+), 2 deletions(-)
> 
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
Hi Guanyou,

This changes behavior for normal (non-RT) tasks. If a process calls
prctl(PR_SET_TIMERSLACK, 200000) and then forks, the child currently
gets default_timer_slack_ns=200000 (the parent's effective slack).
With this removal, the child would get default_timer_slack_ns=50000
(the parent's original default), so a subsequent PR_SET_TIMERSLACK(0)
in the child would reset to a different value than before.
I think the fix should be narrowed to only handle the RT parent case:
	if (rt_or_dl_task_policy(current))
		p->default_timer_slack_ns = current->default_timer_slack_ns;
	else
		p->default_timer_slack_ns = current->timer_slack_ns;
Thanks
> -
>  #ifdef CONFIG_PSI
>  	p->psi_flags = 0;
>  #endif
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
>  
> -- 
> 2.34.1
> 

