Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4A3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709DA6B012A; Tue, 30 Jun 2026 11:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA116B012C; Tue, 30 Jun 2026 11:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582D36B012E; Tue, 30 Jun 2026 11:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 321B06B012A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:08:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B630A8C956
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:08:09 +0000 (UTC)
X-FDA: 84936909498.24.0F841C7
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2C39D140007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:08:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DdA85Oso;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782832088;
	b=hzodlGnl34ZW19hJ36j6TLD9rf54UfEFZm9FQ6a2bBfhd67OZCyXXg9XSI/ucKWP8jCxLt
	CVom1HXepz2UthwYyDlRIro1IscW2E9Sq+TdYC50PnXoNHNOPK8LM8ikgwkkkEOfpcKK7Y
	drMbrx4pdLUzXugXWB0QWZSnbjfLmpY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782832088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHtO69diIM0k7S0Wj5v0VMDMfaI21iwZjDPJcsxigLA=;
	b=wY6queWD5yICbiFroJR1JWEwUfOvFe/YjB8gfAsJO/5D6CNhJkLfNsfNv964pVMeKHXXhn
	swA7lQ7VCmHZAMX9hZYmEX0pD6nGRNySI5p7af42Bm1pnsOzus3nX7bp7AhcSN0COgB9HR
	DwutUeg2ybTiHZZfEAXNZf2I9+W2GOk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DdA85Oso;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 30 Jun 2026 08:07:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782832082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gHtO69diIM0k7S0Wj5v0VMDMfaI21iwZjDPJcsxigLA=;
	b=DdA85OsoBrLMdEteQcGdKeX0AzDe/7nYRg6vYyk+ql7QNoPRZhPyh6W4lrwEt3aIUsY85A
	JE813+iwrtqbl676jixEw8tFQvESMIQJk7/QjLpMcGpXjiQKc/SGLfsaN5zJ4egZANbrfF
	VdBlPwM6d0VpkL2r/zLQAQQmH4qak78=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RESEND PATCH v2] mm/memcontrol: Avoid stuck
 FLUSHING_CACHED_CHARGE on isolated CPU
Message-ID: <akPbL3HZrvWy8O3Q@linux.dev>
References: <20260630070004.470181-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630070004.470181-1-hui.zhu@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 879keeo5exa1o4uwatgkhf6wmnf39d3s
X-Rspamd-Queue-Id: 2C39D140007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782832086-601398
X-HE-Meta: U2FsdGVkX19pXN+ADSaT4B7Ln4a84/kRVXoswDMlgk7goTZZNqqx+eHZitr22jSsodtQTZkuMAa6xQ5W4Q8+t4Y5hEqPKEZpgW2pstbYQoBPfcZCzaKxY+RuUXpDVDtpntuIlYqDWUwNQO30STcn97GFxcGes0rSe4d8sOUPzIx/hBIcQXBOAE55IodyyUJNkj5zIyGtcttIg5ZSGcDuq/dBHtjvLZulATvpkmjN9+z8jfDCcWM3/TIrRQ+tM75/tnqtJ8GXywW0e2DwvmsxGnpTJxin8a8kuCgVeFcXUeVvwVsrhXRlXGE939938WU/13B5ZVcTH/+TxgCsQwwlt6RKmmVxw19WQ0/9KhM21qKcsVLdMWVcr/zCqJpLLjDnOIk97bwB36mG3kbe92ug7xSneXagZBw/EXAVdh7WiUiUgrxBMZ2zYyLlQF/DCjHkqepiYWDVKxYrvdQeNwy5OhcqOzpeP06zVJRzxENV9o1P4PZ8TzxgcW2sI1S16PXFwd2o42fQMQWaEVJ8LERcz4G6f1PBeFoqtQ7wWABqVf1Wsg9m6NCM5bfrn/F/ZusuFCtblPUTzyH6YNf81sZOUNEuQFD5SanM5BsA8oAZhv43I0be/xGb8OKFVWYTJShmSLLNk5FEqGq+xfQENnrdUUm0493dT5+Aq/fjpZQo1kx4ciJi2TVyMJKR3TRADmbT2/hg3v9rjTH6d/fQq8NCgDoNozsnc+k8TcXmzaXvBZSp9JOY2PJWsS9+Wt6H0Y3YtdLJQrL2jwvmCT/NsDeg9TbsgFFKlSMgdLxe+zlByCRxC4yzaagpuw8qIah4HXUjF0b8RardGjSWkOcpXt5vThHXleRLDEQYUUcgiDjyGR869dKjILAIDZnftTngXwsXx9ufopfTUMVp1qG5rCbyq+/6WQxc8RWj4rSRLBtFBryaSr92/WrTTE6saOdf3qKC86YbpJItYEBIY5cPVC+
 6fsYAa62
 Rxmf7b7ushXzHzPAvgNyqC3tD8pZNr3p0remBzSLbuBRXqhwOl1Vc3i6l24CzeybCIvB8+3pP5A/l7LFCCTHhuKCL4gsh7pvjerHfUEL62uHw5Z4qgziUndH850GR4QYrn2uOkD2h5dCLvSVtNl3oD9TbnZLkEgIHrhY7bbNiIQvnpp80zTTvcQUIVmXQ9SDKfHsoRiTPXAz7ZS6Phy3/qnqW/qYH28eL2ovO7kuDnUjYatbnsKvLUF762tUmV9P5eU7P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 03:00:04PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> drain_all_stock() sets FLUSHING_CACHED_CHARGE before calling
> schedule_drain_work() to queue per-CPU drain work.  When the target
> CPU is isolated (cpu_is_isolated() == true), the work is silently
> not queued, but FLUSHING_CACHED_CHARGE stays set.  Every subsequent
> drain_all_stock() then sees the bit and skips this stock entirely,
> so the entry is effectively pinned until something else on that CPU
> runs drain_local_*_stock() and clears the bit -- which on a long-
> isolated CPU may never happen.
> 
> The original idea was to actually perform the drain from the calling
> CPU on behalf of the isolated one, by adding a lock around the
> per-CPU stock so that a remote drainer could safely touch it.  In
> practice this turned out to be intrusive: the stock data structures
> and their fast paths (consume_stock(), refill_stock(), the obj_stock
> helpers) are deliberately designed around current-CPU-only access,
> and retrofitting cross-CPU serialisation onto them adds non-trivial
> locking and PREEMPT_RT concerns for very little gain.
> 
> Looking at the actual amount of charge that can accumulate in a
> single per-CPU stock, it is bounded and small, so leaving an
> isolated CPU's stock undrained for a while is not a real problem.
> The only real bug is that the stuck FLUSHING_CACHED_CHARGE bit
> prevents future drain_all_stock() callers from re-attempting once
> the CPU is no longer isolated.
> 
> Fix this minimally by clearing FLUSHING_CACHED_CHARGE when the work
> could not be queued because the target CPU is isolated.  The cached
> charge itself is left in place; it will be released the next time
> the CPU runs drain_local_*_stock() (e.g. after leaving isolation,
> or if the isolated CPU itself calls drain_all_stock() -- in that
> case cpu == curcpu causes drain_local_memcg_stock() to be invoked
> directly), and the next drain_all_stock() call is free to retry
> instead of skipping the stock forever.
> 
> Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changelog:
> v2:
> According to the comments of Waiman Long, updated fixes.
> 
>  mm/memcontrol.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..2e66b4a2c25d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2256,7 +2256,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>  	return flush;
>  }
>  
> -static void schedule_drain_work(int cpu, struct work_struct *work)
> +static void
> +schedule_drain_work(int cpu, struct work_struct *work, unsigned long *flags)
>  {
>  	/*
>  	 * Protect housekeeping cpumask read and work enqueue together
> @@ -2264,9 +2265,22 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
>  	 * partition update only need to wait for an RCU GP and flush the
>  	 * pending work on newly isolated CPUs.
>  	 */
> -	guard(rcu)();
> -	if (!cpu_is_isolated(cpu))
> -		queue_work_on(cpu, memcg_wq, work);
> +	scoped_guard(rcu) {
> +		if (!cpu_is_isolated(cpu)) {
> +			queue_work_on(cpu, memcg_wq, work);
> +			return;
> +		}
> +	}
> +
> +	/*
> +	 * The target CPU is isolated: the drain work was not queued.
> +	 * Clear FLUSHING_CACHED_CHARGE so that future drain_all_stock()
> +	 * callers can re-attempt instead of skipping this stock forever.
> +	 * The cached charge is left in place; it will be released the
> +	 * next time the CPU itself runs drain_local_*_stock() (e.g.
> +	 * after leaving isolation), or by a follow-up mechanism.
> +	 */
> +	clear_bit(FLUSHING_CACHED_CHARGE, flags);

Let's do something like the following.

	guard(rcu)();
	if (cpu_is_isolated(cpu)) {
		clear_bit(FLUSHING_CACHED_CHARGE, flags);
		return;
	}
	queue_work_on(cpu, memcg_wq, work);

>  }
>  
>  /*
> @@ -2299,7 +2313,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  			if (cpu == curcpu)
>  				drain_local_memcg_stock(&memcg_st->work);
>  			else
> -				schedule_drain_work(cpu, &memcg_st->work);
> +				schedule_drain_work(cpu, &memcg_st->work,
> +						    &memcg_st->flags);
>  		}
>  
>  		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
> @@ -2309,7 +2324,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  			if (cpu == curcpu)
>  				drain_local_obj_stock(&obj_st->work);
>  			else
> -				schedule_drain_work(cpu, &obj_st->work);
> +				schedule_drain_work(cpu, &obj_st->work,
> +						    &obj_st->flags);
>  		}
>  	}
>  	migrate_enable();
> -- 
> 2.43.0
> 

