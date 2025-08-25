Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91631CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 19:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBFF8E0069; Mon, 25 Aug 2025 15:41:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3B18E0038; Mon, 25 Aug 2025 15:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00678E0069; Mon, 25 Aug 2025 15:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAA988E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:41:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50C3259263
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 19:41:18 +0000 (UTC)
X-FDA: 83816298636.28.6B5CF97
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id 49B53140005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 19:41:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Od9hXyeB;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756150876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaBOeTNdTjLlU52HNYXZjxccsI5utUG+maXgRXm46HY=;
	b=4+wuGlhO1x40Gv4Jyit9tjTa+aecXKFLXC0ScIOwSHl0F4h1Bd04jh1nDLrOOAxUm/7VgS
	ThqygSR6MLspvF2ovOO4slFfHT5lGZT/gJvgnFJdZxtHAS/uzecNBZ2KF1rruE7QfhivZ6
	QQKZ102bYTRmDZaszBZGR2kJdTaErPg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Od9hXyeB;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756150876; a=rsa-sha256;
	cv=none;
	b=rbA5Gva48O3kIiOjM2GKnOwEafBGYmCDvVWk3rGRl8kv7EC5lumYlVkzu8LWUmOhFk76zN
	zn9/ON+pHK6Vy+ouW0XnSQTZkP5bUuqugvj1iZsZpJsqfWLCrd0dwG40Lq9ciKgD8gqP7w
	MQBa7sr5cZruUzUg0jD5To5RdBdwWVE=
Date: Mon, 25 Aug 2025 12:41:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756150874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DaBOeTNdTjLlU52HNYXZjxccsI5utUG+maXgRXm46HY=;
	b=Od9hXyeBDyV69Pof8vMx+qvOo82ai07aCUAO1EJ1QkJzqhMLQ7bfgvI6AibxQBCAOpJxGb
	WLboMc9Gu9foPdbGmBM5RmDRFzvBJ789zQQN1qv5isxftajqdtgxKQCH1ZnZubGJLQkbUL
	KU2Dx4eXZN2eWKIX8jCubinBW/wd4gA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	liam.howlett@oracle.com, lorenzo.stoakes@oracle.com, liulu.liu@honor.com, 
	feng.han@honor.com, cgroups@vger.kernel.org
Subject: Re: [PATCH v5 1/2] mm/oom_kill: Do not delay oom reaper when the
 victim is frozen
Message-ID: <jzzdeczuyraup2zrspl6b74muf3bly2a3acejfftcldfmz4ekk@s5mcbeim34my>
References: <20250825133855.30229-1-zhongjinji@honor.com>
 <20250825133855.30229-2-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825133855.30229-2-zhongjinji@honor.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 49B53140005
X-Rspam-User: 
X-Stat-Signature: 46hp7nk673jf8c4schxmdg3x3hu9yhau
X-Rspamd-Server: rspam09
X-HE-Tag: 1756150876-486311
X-HE-Meta: U2FsdGVkX1/5zTM7CTDSsQginPe11mACGtZw32oJIjtCjO3B24Cnq7IWOfVeYz4yToiSv8zdD3PL1nuMiT+I5NGJn8Q1+bQVPdCd+CaHZ1xbPhx7nmhOUXTN3yE+w8zRyp7A1hQtwzpWVWSTRsTR3niJ5jEDqutCvSDzVrFMtlRF310SyTc4bnMp7MxLzzhmf5jhodMf2/B7sTNs2YdQAMvNUssoMUiu6jYGOMiRfACPuOkWcQoZc3+vD9wv2Y6CByfO/WWoH3RPcXtP5WyuQsrx756qDyXoODNIBu/cERNczdOPMhOLlIjht59ZSSUasJbQctLeYkVGod5LslGSa+tO15LEHYriAIexESmU1eQf/G8QHLVTY1vdkA7xICKxbN5WUvs+HoKz0FYVSw1ofs3bfa/wDwMLWjQ3aTl5uesR3hfbs/ot3cw5RkurTIjZKe89T1cffuw5KI86KkR5IPrfCWjXeOzcLvG4jfWUac+omkvLBdbcTVz9qrDMvCw18FzweFH4cbbVrJUxNi3hx/TMa3xh1/3ydBweHKKQa543FBdT/KWWm67eGh9yUK6vFtTU/+Yr64110M9abmpXE83Aregmg537uC37Exe6nkxgqTDn1i5dTdEmk7jmQli28f4xCbJSpZV6RGhT3v7bxT7ePrFTsOr4YApf3jenlOiPDmhrMG2jnOUgJWrYD7KhTNpElu9SEXbukYVmEWvZaDcX3ZbM4YhdjzfcEBLlbj+0wpI6sijWiA7LIUSngzunETu1k5aWneYyuxgOM85AoKDl8HgVa5JdeW4IbTGFPl5Aq3VE3mZMJzVz1f+rwJJ7anv4CH4J7qG6Vwxl0OUyW/XFUE3ddWv1O7Jm5WQOIyGIBkwp44ll9DrUrHZFf5Cr1DVunplgtwav86tqtSTIm+yBl/t6iV7EQ68iDEuvjmolXThlTyDRlw1R0Ec6u8yxAAaeJaruR7P23WJ2DS6
 vA0VMSag
 AuhxWAEIS2e41PBhAMDA1eQ2JSjWv1Urm8fJbh5CvdGheg7Rv5nRlUHrO3oOBg12uKbmtpn5Q7uv0I2mWGZdaMCjURbjcjRbOl5OXwDp5v2X7SQFc4cQvshaKQrzKAYBNWeWxygsTOVMLUH7O7cp7ndS/zVdkXQAGm7aB+jK+xJp+PuCSTzckUAwUE67GaeSKdNGPyMv7fBI8jVC6X90Z8nV8h75YiGpuONe+6khbqtJAB3f00T3Te4uCCPfmuuV+cxsRShLjoAoKde1ws0NDGR9/PFnMDIeXd//h2P/axsKuvbooXIaa4zeGLajclKF0VlTUCHQJyv5U2URVGXDCe9K6arFYBF6Crrg3JX/zLJQyAdSKBZVnw/dGS/wKbUSfSysL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cgroups

On Mon, Aug 25, 2025 at 09:38:54PM +0800, zhongjinji wrote:
> The OOM reaper can quickly reap a process's memory when the system
> encounters OOM, helping the system recover. If the victim process is
> frozen and cannot be unfrozen in time, the reaper delayed by two seconds
> will cause the system to fail to recover quickly from the OOM state.
> 
> When an OOM occurs, if the victim is not unfrozen, delaying the OOM reaper
> will keep the system in a bad state for two seconds. Before scheduling the
> oom_reaper task, check whether the victim is in a frozen state. If the
> victim is frozen, do not delay the OOM reaper.
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>
> ---
>  mm/oom_kill.c | 40 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..4b4d73b1e00d 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -683,6 +683,41 @@ static void wake_oom_reaper(struct timer_list *timer)
>  	wake_up(&oom_reaper_wait);
>  }
>  
> +/*
> + * When the victim is frozen, the OOM reaper should not be delayed, because
> + * if the victim cannot be unfrozen promptly, it may block the system from
> + * quickly recovering from the OOM state.
> + */
> +static bool should_delay_oom_reap(struct task_struct *tsk)
> +{
> +	struct mm_struct *mm = tsk->mm;
> +	struct task_struct *p;
> +	bool ret;
> +

On v2, shouldn't READ_ONCE(tsk->frozen) be enough instead of mm check
and checks insode for_each_process()?

> +	if (!mm)
> +		return true;
> +
> +	if (!frozen(tsk))
> +		return true;
> +
> +	if (atomic_read(&mm->mm_users) <= 1)
> +		return false;
> +
> +	rcu_read_lock();
> +	for_each_process(p) {
> +		if (!process_shares_mm(p, mm))
> +			continue;
> +		if (same_thread_group(tsk, p))
> +			continue;
> +		ret = !frozen(p);
> +		if (ret)
> +			break;
> +	}
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  /*
>   * Give the OOM victim time to exit naturally before invoking the oom_reaping.
>   * The timers timeout is arbitrary... the longer it is, the longer the worst
> @@ -694,13 +729,16 @@ static void wake_oom_reaper(struct timer_list *timer)
>  #define OOM_REAPER_DELAY (2*HZ)
>  static void queue_oom_reaper(struct task_struct *tsk)
>  {
> +	bool delay;
> +
>  	/* mm is already queued? */
>  	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
>  		return;
>  
>  	get_task_struct(tsk);
> +	delay = should_delay_oom_reap(tsk);
>  	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
> -	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
> +	tsk->oom_reaper_timer.expires = jiffies + (delay ? OOM_REAPER_DELAY : 0);
>  	add_timer(&tsk->oom_reaper_timer);
>  }
>  
> -- 
> 2.17.1
> 

