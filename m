Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40EE910F6FBF
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2626B0088; Wed,  1 Apr 2026 11:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA536B008A; Wed,  1 Apr 2026 11:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972496B008C; Wed,  1 Apr 2026 11:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 842A56B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:24:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 287148C71F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:24:07 +0000 (UTC)
X-FDA: 84610357734.22.760CBF9
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 325394000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:24:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PKEmrArh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775057045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bgKpzn8XxryGiVAnWC5zFvW5iObgW7oiW/vycCAsgs=;
	b=wKyd2ZnR6iFLoIUdBiYC+jD1+8QOeDcWOi5tNxQwAYibutz1FO/7kq4Uw88eA6t75UySwA
	+LafVhxMp310P0cKHcB8KvRTTAgaL6Y7POUrCxM/6PpL8tuFISvHrS/Os5OVNo/0TzuZkW
	iY730k1gX1SUwAW1XkNJFP0mCIjEV7k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775057045; a=rsa-sha256;
	cv=none;
	b=CAnXY43Fn+sAhwqLAMuYmK/IZRsmp6iuUIJSiG/bRdh2H1YtgqYmOAfMotW7InJ55QlZk0
	mrrQvhXwwGVLwlcEUvOtHBO8pkn/r7lg/KCpTpI7IAcVaK3m/PToYe98asAWqzURTT5xuG
	PBbVetUGn9mIU7j/JLPYEroSIYNGqRg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PKEmrArh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775057042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7bgKpzn8XxryGiVAnWC5zFvW5iObgW7oiW/vycCAsgs=;
	b=PKEmrArhr4S5xmd8rRqYloL1+Gt1Ok+SavD1QVhWSjom+r1bFhwk5YVaSqJ2OKwKJ2nT1X
	vC4I+46Ulmu69eV6yS6Z1Q3rWZC3oK1ErmO8ThVkAXLFbYQiS4wwX74dRLHo/84LYGxdQY
	uThg9XrqZVMC2zSzmzFIZOI51P7zJaw=
From: Usama Arif <usama.arif@linux.dev>
To: Breno Leitao <leitao@debian.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat interval
Date: Wed,  1 Apr 2026 08:23:40 -0700
Message-ID: <20260401152343.3294686-1-usama.arif@linux.dev>
In-Reply-To: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 325394000E
X-Stat-Signature: dnajin3gjognphn596og5yrijssbnu7p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775057044-607043
X-HE-Meta: U2FsdGVkX18pfTcF6Zi6777Nq1TgkMwPP7d7Kr3VO6/o7BuI8YmmrIWbQyr8x26m++Jel50arnHfHsczersTkAozZ49Pyi99+7zAQObUq1GEelBpwjGBkn1KiDloN7YjW5voKwRhBPM7KvIe0SQPAhMTy1bgGc92gKbwRcl4SbaLeCng4EoHq0MBw7CuANIihTTYf58CI89dU59IorVRCsSgJ6e52w9ohgUljvwfs+ngwblvWlsBf1rE4WsOfDUPrrVUld3E5GGYiv79tn8L/r+qzjvMfwhElALo8dEqrkQx8El1cQbv1DGguHG0OX1C7lcNGCWjzlu7sgNzMgqvVIAQqg5mVpQVfBSlgMZ8kTapernnUFP94FxvLdmGj6T3gIToprIpkWzADLqBvyOEB2UyzMuKgEJFanG3NbZkGSmVVltSsTOwnB/UfPa3fn6czA9D/pdTS7E+dKS0H8JwSXh7QtmNhQDSJcmtwfCdDNDUOz9BA7RY7dp9+bND6n7pDglnooposNgvzSARuiRTPXCmtlGohur4k0RTrPWcrSHKp1NLinMgTAhIKAwJ6/x52Hjqduf51GY5j9raZYnjdDfu6UduS7W2xGRGqnn2URG3NqE+60G7GcMf6xbRnVO0MUsgLfsCgovqhXXxp27IaWKtjnnq9UPd4G3ne6kjIHkrjXnaOEQA5HdRO932WutoCNOcI7jHQ6Sd2IgqMFofjub5ObCVKQToaEQ/STWZkSfU/L+9VMVOBJAyaYmvXWvYjAG5koUpXz9L1Y3s6NHWpvVfEctOeLkz2v5Ce94RTdQzgy1u8/pdaf7Clyie7yxoytfY1YzsYgiSMnM1tn0J4Ru3Ml95gBcfufTh9OUKsLpb7SHaF1Nqdmw5ieVzvqiiLYQtVeqkbRelIjTKrVOTPBc8wKDbLCPOOays6PICMqt1OCT+aHW8jrvIALNOpK7V6FYoLtBTXVWiNSwlWr2
 rkYHonpn
 Ue06JKy9a/fNFEdh5HWr983UROZypOamOQS5fbb/ViTdTrl+MsFGLu8UI6c8hzAqJeOq+BYM6pPr8aNAIEu2pcTrnTwigX7OwdhFebkWUsXvInCOf9ZcDpKVb5ocfjjKsjG36anqmP8/9Zsb1WxmeGoNhsVqqFERTJLPGgDXx8hJ5P0HsOUGCVgcOcMD+5HnEDYbJYh/letYO/nAeFsWSbyyRtqTjGnI/hSQU60F5RwbjtYzvEThCM9JZmjJ2YGSOzKLWBlnomhF8JYRj/bVloQXKJ/z7ggcg5LG5bPUIjSg/Rwn+DZ2AWNDlNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 01 Apr 2026 06:57:50 -0700 Breno Leitao <leitao@debian.org> wrote:

> vmstat_update uses round_jiffies_relative() when re-queuing itself,
> which aligns all CPUs' timers to the same second boundary.  When many
> CPUs have pending PCP pages to drain, they all call decay_pcp_high() ->
> free_pcppages_bulk() simultaneously, serializing on zone->lock and
> hitting contention.
> 
> Introduce vmstat_spread_delay() which distributes each CPU's
> vmstat_update evenly across the stat interval instead of aligning them.
> 
> This does not increase the number of timer interrupts — each CPU still
> fires once per interval. The timers are simply staggered rather than
> aligned. Additionally, vmstat_work is DEFERRABLE_WORK, so it does not
> wake idle CPUs regardless of scheduling; the spread only affects CPUs
> that are already active
> 
> `perf lock contention` shows 7.5x reduction in zone->lock contention
> (872 -> 117 contentions, 199ms -> 81ms total wait) on a 72-CPU aarch64
> system under memory pressure.
> 
> Tested on a 72-CPU aarch64 system using stress-ng --vm to generate
> memory allocation bursts.  Lock contention was measured with:
> 
>   perf lock contention -a -b -S free_pcppages_bulk
> 
> Results with KASAN enabled:
> 
>   free_pcppages_bulk contention (KASAN):
>   +--------------+----------+----------+
>   | Metric       | No fix   | With fix |
>   +--------------+----------+----------+
>   | Contentions  |      872 |      117 |
>   | Total wait   | 199.43ms | 80.76ms  |
>   | Max wait     |   4.19ms | 35.76ms  |
>   +--------------+----------+----------+
> 
> Results without KASAN:
> 
>   free_pcppages_bulk contention (no KASAN):
>   +--------------+----------+----------+
>   | Metric       | No fix   | With fix |
>   +--------------+----------+----------+
>   | Contentions  |      240 |      133 |
>   | Total wait   |  34.01ms | 24.61ms  |
>   | Max wait     |   965us  |  1.35ms  |
>   +--------------+----------+----------+
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/vmstat.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 2370c6fb1fcd..2e94bd765606 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2032,6 +2032,29 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
>  }
>  #endif /* CONFIG_PROC_FS */
>  
> +/*
> + * Return a per-cpu delay that spreads vmstat_update work across the stat
> + * interval.  Without this, round_jiffies_relative() aligns every CPU's
> + * timer to the same second boundary, causing a thundering-herd on
> + * zone->lock when multiple CPUs drain PCP pages simultaneously via
> + * decay_pcp_high() -> free_pcppages_bulk().
> + */
> +static unsigned long vmstat_spread_delay(void)
> +{
> +	unsigned long interval = sysctl_stat_interval;
> +	unsigned int nr_cpus = num_online_cpus();
> +
> +	if (nr_cpus <= 1)
> +		return round_jiffies_relative(interval);
> +
> +	/*
> +	 * Spread per-cpu vmstat work evenly across the interval.  Don't
> +	 * use round_jiffies_relative() here -- it would snap every CPU
> +	 * back to the same second boundary, defeating the spread.
> +	 */
> +	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
> +}
> +
>  static void vmstat_update(struct work_struct *w)
>  {
>  	if (refresh_cpu_vm_stats(true)) {
> @@ -2042,7 +2065,7 @@ static void vmstat_update(struct work_struct *w)
>  		 */
>  		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
>  				this_cpu_ptr(&vmstat_work),
> -				round_jiffies_relative(sysctl_stat_interval));
> +				vmstat_spread_delay());

This is awesome! Maybe this needs to be done to vmstat_shepherd() as well?

vmstat_shepherd() still queues work with delay 0 on all CPUs that
need_update() in its for_each_online_cpu() loop:

      if (!delayed_work_pending(dw) && need_update(cpu))
          queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);

So when the shepherd fires, it kicks all dormant CPUs' vmstat workers
simultaneously.

Under sustained memory pressure on a large system, I think the shepherd
fires every sysctl_stat_interval and could re-trigger the same lock
contention?
 
>  	}
>  }
>  
> 
> ---
> base-commit: cf7c3c02fdd0dfccf4d6611714273dcb538af2cb
> change-id: 20260401-vmstat-048e0feaf344
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 
> 

