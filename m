Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B093C1073C85
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 10:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B0A6B008C; Wed,  8 Apr 2026 06:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12C76B0096; Wed,  8 Apr 2026 06:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FB66B00A4; Wed,  8 Apr 2026 06:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86E286B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:13:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C9481607FC
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:13:12 +0000 (UTC)
X-FDA: 84634975824.29.9ED81C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 52FA3180003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:13:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pRBecdiB;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775643190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODHh88Ae43DaynJJBqJPusj4TZP9WBFENf6rP5BT4+g=;
	b=okajohoirQQY+RSHAmwdS0ZGy/LLFmtBK8MIUKFTBW3U+7ZS64cyQZP/CH7oTDxnNx92Nw
	1XYzfcJ9V0F+AKdo3qdKNyPu2/RWWjtU/XoWWENZLxVUr/dZITzBjnQ966qBONwTJrXneN
	aGi7N1Z+d/LAH+ATKdrnMhwovXp13Lc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pRBecdiB;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775643190; a=rsa-sha256;
	cv=none;
	b=8L9v+Ebs3IctnEawTWzVgueYAG2xcZa74g7cGpxx/FyRSKAItSBml9V+olRYiZhgffflsc
	thm8XailyGGBDdY9q/BH5BPw1ISZuks9/bytIE3s7DDKNmCdyFt2dUtO9Pu+lfnLHGyFSy
	Fnw2FUsbyjhgAMmuSpuk/BkdZY9F14E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 53F6343974;
	Wed,  8 Apr 2026 10:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8523CC19421;
	Wed,  8 Apr 2026 10:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775643189;
	bh=f6ombUBCsvxVfv7YT8Tcc6uNl3Xn7OaKSpvqae9Fh0g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pRBecdiBm0H7dht7ssV5TmpE++IDqBcqEZn70LgSTETDBHJ6fLuBqgpv0SE+zG5u3
	 VqLd2rb0yQRYxLKAPmpLAxh7t4lezU4DV4T2riEGJn0rsJWIUpRGBvD9JH9DkiJNgX
	 qlnlH+FfFHExzYMyR41c/wTYCnl/1+tpeI1w0v1qqcMjmQb/HtdDmHxvaSd7VIH+iM
	 J0Ig6FeUm3zA90LoX7JPrX7V6IOHoYppanlmM/Tx/H+9BhZdBGZgaTE4Ld4mRlWdw1
	 CpOyevKHOu9q55kftqi7Bj8f+7OusZK7yMJXvCrDSvTF6PiXuU9FOjBBr3R9wtD9xk
	 Q57IlBF5HyCVg==
Message-ID: <a9129d39-f9dc-4f09-b951-203c8e28b600@kernel.org>
Date: Wed, 8 Apr 2026 12:13:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kas@kernel.org, shakeel.butt@linux.dev,
 usama.arif@linux.dev, kernel-team@meta.com
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
 <a55afddd-8c6b-4a7a-bfd9-5140013c764c@kernel.org>
 <ac5urCFeEB9oyUiD@gmail.com> <adUhtrhU7c1TJQww@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <adUhtrhU7c1TJQww@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52FA3180003
X-Stat-Signature: 1dufpkb6fpy1f6f1hnzkxeo43bfea449
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775643190-779121
X-HE-Meta: U2FsdGVkX1/R40kSN8SPHOo0anMF6GUZPT1NS+BO1t19VheNlIsGBnzodjwWtJSttc1F4GD+cn5KxLKFpk/M2dvUB/rbrlaUbNSN4FbIW1PVTP98sq4z20W/JQZO4yVRo1ikhdal7ULpeUpCed9/2HPddwF0KAamAmpjG49aVNYO5ljk7kYIoUrtsCh9Ps1vR0Dk9o1KJ7nsIcyy0/e00OBEZoD+8CAyRLhAnXg52PsGsJmK6DB1VZqg4eAiMyLBxJ5lFV95+uqneLljbywKyPnd0QOA9LTW6y3wYmnd4l9Yl5hyZOIb6gXUkdpIt+aO5NC0vkmw4ntucBwAmLyTrAqPYLY4RbAkPEyqLoTjkuGISVsgBd3uoPXVQah3J1pQx6m6I+gxWhgreI3rFLJzHT6xjvWYcpNE9gU4kiP5GuOd12QzJ7mMDE5Dhy5asm3FSsxvdWMbGLkMOPWXst496TgiuaYb9l2r+CAYWTN5Oom60+JF239BcUdk8zW83021cpsWfuF3zG/ZYpmolVw4LtFBPmxKIT8CU5Y3uqdzLMv4IBxnBB/1iTZLL97YKnf1T1KQIb+3/cOMkiddREVxKuwzBhilp4AwgFdjJ5COMbYkVbVjcZyzywFgTH8c2R3+QUlxhzd0NGKMoms44McpWK+m016nfz3VfFNAek1bU9cB/LXUBwFJXJxlpGgVBAnH90Cq0r4dCHiwFSTas0pdDHWXGCifYYDkUw3xLm65zKql24Z8nSIgTpSv0vbByBqLyXJj++VQwOA+qgCszZvOMjM+FrdVHIUU6asGFAkitH6ugFpwX0X6+aAfTff/MnL5dCmbm6CIs0Zk2KV4oBP9jAas/zj2sCHRpvqkiTE3pYJ2o0MvyCPlIRiGZilqTy+s8WhasuZKekjsNJslOu1njAu8sJH72BU+tsGTDlQuroTaKbsSH61cUFC3Of3B79O2pcc74kRgT8Ko5N82rUb
 RT2/SjU4
 9pcY2SR5SxD+nfyHpuPIS2ar63d3eF+othiuWb2l9jF1R6Hnk+98G9S2FtcAY1CqYCULu9AX9D/r2sLohSfsyPGvJC7BofTuJnq62MmUMjw/cs5zxMSXbmGX9JzKEdE7RWqk69ceH2mei5OWCY4IioHly8fVTgk6L3IlS6B6rqNYdDvv8vVIXxiQzMKgJmz210kchT8h5SJ5oTMnSkdyUGD9lGzJUBvyQNBB5TvXyIXqQS4CME9FFJu19dDx/CfUc2Ulh/vxGRh0vnf1fU4p+uyDrjcv2na+XKySGUIWaEoZsIrUZLNDa1jTA1rAbDOax79YkJj7Tgf00bGlnVguEcYiPsjYgjdT0KSU5ChBEiqaV9bYCbmt2VBcHV+BvtVEXtBim
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 17:39, Breno Leitao wrote:
> On Thu, Apr 02, 2026 at 06:33:17AM -0700, Breno Leitao wrote:
>> > >
>> > > Cool!
>> > >
>> > > I noticed __round_jiffies_relative() exists and the description looks like
>> > > it's meant for exactly this use case?
>> >
>> > On closer look, using round_jiffies_relative() as before your patch
>> > means it's calling __round_jiffies_relative(j, raw_smp_processor_id())
>> > so that's already doing this spread internally. You're also relying
>> > smp_processor_id() so it's not about using a different cpu id.
>> >
>> > But your patch has better results, why? I still think it's not doing
>> > what it intends - I think it makes every cpu have different interval
>> > length (up to twice the original length), not skew. Is it that, or that
>> > the 3 jiffies skew per cpu used in round_jiffies_common() is
>> > insufficient? Or it a bug in its skew implementation?
>> >
>> > Ideally once that's clear, the findings could be used to improve
>> > round_jiffies_common() and hopefully there's nothing here that's vmstat
>> > specific.
>>
>> Excellent observation. I believe there are two key differences:
>>
>> 1) The interval duration now varies per CPU. Specifically, vmstat_update()
>>    is scheduled at sysctl_stat_interval*2 for the highest CPU with my
>>    proposed change, rather than a uniform sysctl_stat_interval across
>>    all CPUs. (as you raised in the first email)
>>
>> 2) round_jiffies_relative() applies a 3-jiffies shift per CPU, whereas
>>    vmstat_spread_delay distributes all CPUs across the full second
>>    interval. (My tests were on HZ=1000)
>>
>> I'll investigate this further to provide more concrete data.
> 
> After further investigation, I can confirm that both factors mentioned
> above contribute to the performance improvement.
> 
> However, we certainly don't want scenario (1) where the delay varies per
> CPU, resulting in the last CPU having vmstat_update() scheduled every
> 2 seconds instead of 1 second.

Indeed.

> I've implemented a patch following Dmitry's suggestion, and the
> performance gains are measurable.
> 
> Here's my testing methodology:
> 
> 1) Use ftrace to measure the execution time of refresh_cpu_vm_stats()
>    * Applied a custom instrumentation patch [1]
> 
> 2) Execute stress-ng:
>    * stress-ng --vm 72 --vm-bytes 11256M --vm-method all --timeout 60s ; cat /sys/kernel/debug/tracing/trace
> 
> 3) Parse the output using a Python script [2]
> 
> While the results are not as dramatic as initially reported (since
> approach (1) was good but incorrect), the improvement is still
> substantial:
> 
> 
>   ┌─────────┬────────────┬────────────┬───────┐
>   │ Metric  │ upstream*  │    fix**   │ Delta │
>   ├─────────┼────────────┼────────────┼───────┤
>   │ samples │ 36,981     │ 37,267     │ ~same │
>   ├─────────┼────────────┼────────────┼───────┤
>   │ avg     │ 31,511 ns  │ 21,337 ns  │ -32%  │
>   ├─────────┼────────────┼────────────┼───────┤
>   │ p50     │ 2,644 ns   │ 2,925 ns   │ ~same │
>   ├─────────┼────────────┼────────────┼───────┤
>   │ p99     │ 382,083 ns │ 304,357 ns │ -20%  │
>   ├─────────┼────────────┼────────────┼───────┤
>   │ max     │ 72.6 ms    │ 16.0 ms    │ -78%  │
>   └─────────┴────────────┴────────────┴───────┘

So you have 72 cpus, the vmstat interval is 1s, and what's the CONFIG_HZ?
If it's 1000, it means 13 jiffies per cpu. Would changing the
round_jiffies_common() implementation to add 13 jiffies per cpu instead of 3
have the same effect?

> 
> * Upstream is based on linux-next commit f3e6330d7fe42  ("Add linux-next specific files for 20260407")
> ** "fix" contains the patch below:
> 
> Link: https://github.com/leitao/linux/commit/ac200164df1bda45ee8504cc3db5bff5b696245e [1]
> Link: https://github.com/leitao/linux/commit/baa2ea6ea4c4c2b1df689de6db0a2a6f119e51be [2]
> 
> 
> commit 41b7aaa1a51f07fc1f0db0614d140fbca78463d3
> Author: Breno Leitao <leitao@debian.org>
> Date:   Tue Apr 7 07:56:35 2026 -0700
> 
>     mm/vmstat: spread per-cpu vmstat work to reduce zone->lock contention
> 
>     vmstat_shepherd() queues all per-cpu vmstat_update work with zero delay,
>     and vmstat_update() re-queues itself with round_jiffies_relative(), which
>     clusters timers near the same second boundary due to the small per-CPU
>     spread in round_jiffies_common(). On many-CPU systems this causes
>     thundering-herd contention on zone->lock when multiple CPUs
>     simultaneously call refresh_cpu_vm_stats() -> decay_pcp_high() ->
>     free_pcppages_bulk().
> 
>     Introduce vmstat_spread_delay() to assign each CPU a unique offset
>     distributed evenly across sysctl_stat_interval. The shepherd uses this
>     when initially queuing per-cpu work, and vmstat_update re-queues with a
>     plain sysctl_stat_interval to preserve the spread (round_jiffies_relative
>     would snap CPUs back to the same boundary).
> 
>     Signed-off-by: Breno Leitao <leitao@debian.org>

I think this approach could have the following problems:

- the initially spread delays can drift over time, there's nothing keeping
them in sync
- not using round_jiffies_relative() means firing at other times than other
timers that are using the rounding, so this could be working against the
power savings effects of rounding
- it's a vmstat-specific workaround for some yet unclear underlying
suboptimality that's likely not vmstat specific

> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 3704f6ca7a268..8d93eee3b1f75 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2040,6 +2040,22 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
>  }
>  #endif /* CONFIG_PROC_FS */
> 
> +/*
> + * Return a per-cpu initial delay that spreads vmstat_update work evenly
> + * across the stat interval, so that CPUs do not all fire at the same
> + * second boundary.
> + */
> +static unsigned long vmstat_spread_delay(int cpu)
> +{
> +	unsigned long interval = sysctl_stat_interval;
> +	unsigned int nr_cpus = num_online_cpus();
> +
> +	if (nr_cpus <= 1)
> +		return 0;
> +
> +	return (interval * (cpu % nr_cpus)) / nr_cpus;
> +}
> +
>  static void vmstat_update(struct work_struct *w)
>  {
>  	if (refresh_cpu_vm_stats(true)) {
> @@ -2047,10 +2063,13 @@ static void vmstat_update(struct work_struct *w)
>  		 * Counters were updated so we expect more updates
>  		 * to occur in the future. Keep on running the
>  		 * update worker thread.
> +		 * Avoid round_jiffies_relative() here -- it would snap
> +		 * every CPU back to the same second boundary, undoing
> +		 * the initial spread from vmstat_shepherd.
>  		 */
>  		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
>  				this_cpu_ptr(&vmstat_work),
> -				round_jiffies_relative(sysctl_stat_interval));
> +				sysctl_stat_interval);
>  	}
>  }
> 
> @@ -2148,7 +2167,8 @@ static void vmstat_shepherd(struct work_struct *w)
>  				continue;
> 
>  			if (!delayed_work_pending(dw) && need_update(cpu))
> -				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
> +				queue_delayed_work_on(cpu, mm_percpu_wq, dw,
> +						      vmstat_spread_delay(cpu));
>  		}
> 
>  		cond_resched();


