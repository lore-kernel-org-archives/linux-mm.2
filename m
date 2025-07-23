Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E479C83F27
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 03:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923E86B0098; Tue, 22 Jul 2025 23:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FBFB6B0099; Tue, 22 Jul 2025 23:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8388E6B009C; Tue, 22 Jul 2025 23:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7550B6B0098
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:09:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC055112ECA
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:09:30 +0000 (UTC)
X-FDA: 83694048900.27.2D65E14
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2F26E40003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:09:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tG0iZMlE;
	spf=pass (imf17.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753240169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8HOFYuMOPLuaVGuzeyM/bj1O2VLJd96/LwL3T7iHI0=;
	b=TWe1/68ml35+Io/gnQaOjwZJO7rMseoTGsuRFdkaXydf57Dwb8yE+AR5y9jzEVK7enlZrc
	qmNHyeER82nstRy+leZBur2daGvAFzINXlmmVuY6wYpWFk9xZhuUAFMSP8978dBK1sOSM7
	OEy+41XJtuHRu+fDqsSjoZ+21rIZEzI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tG0iZMlE;
	spf=pass (imf17.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753240169; a=rsa-sha256;
	cv=none;
	b=LqY5T0D7fD1+FNU9bJNU1EDbG1g/kb7vYa7KwZtcuilgSf8LjcBncjZlbeoUs9m0+A2DSp
	VrlSwjzYnjvp4b6dETIs+bP33To9r1gFn7XnmOSfPw2LU+WdFSYAdTHUIgmSGy8jRbL2tQ
	kR/Q14t7MWle//5e+vWhaO1OGtMu3JA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753240164; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=k8HOFYuMOPLuaVGuzeyM/bj1O2VLJd96/LwL3T7iHI0=;
	b=tG0iZMlECl5KcJQ7H+AEWOMb6oPds9L8i3E0ZkRsVuLMi2NzdEd1NxGS4F7OY5Ig5jBFFraEU+2gbJCGYA98TdKj7Ta1GKs/CBITGZ+lKiyype+CwsI2/ysuVJTigH24Viq9nhZvvP39bry61XYwLR5y3Sgw2fHyTS0b1CalHKg=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WjZkuDd_1753240162 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Jul 2025 11:09:23 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Ruan Shiyang <ruansy.fnst@fujitsu.com>
Cc: linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  lkp@intel.com,
  akpm@linux-foundation.org,  y-goto@fujitsu.com,  mingo@redhat.com,
  peterz@infradead.org,  juri.lelli@redhat.com,
  vincent.guittot@linaro.org,  dietmar.eggemann@arm.com,
  rostedt@goodmis.org,  mgorman@suse.de,  vschneid@redhat.com,  Li Zhijian
 <lizhijian@fujitsu.com>,  Ben Segall <bsegall@google.com>
Subject: Re: [PATCH RFC v3] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE
 counting
In-Reply-To: <20250722141650.1821721-1-ruansy.fnst@fujitsu.com> (Ruan
	Shiyang's message of "Tue, 22 Jul 2025 22:16:50 +0800")
References: <20250722141650.1821721-1-ruansy.fnst@fujitsu.com>
Date: Wed, 23 Jul 2025 11:09:21 +0800
Message-ID: <87cy9r38ny.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F26E40003
X-Rspamd-Server: rspam06
X-Stat-Signature: 6ee66ytryfentpbhhshhh97yjz5hkg7n
X-HE-Tag: 1753240167-218705
X-HE-Meta: U2FsdGVkX194zZQbQ2GYa+PoFOmn2PZs/OSdzpXKsq6eWsrNbaVE5r/c2pQDPnqjR2n6Nv1k/HUCV1EYORh62Uy23DEQNjGj2aobZx0JGMzI/D1VkrrTvQUo+sFcCvXDMSntjFHcRIrTOJ+4F/FP925Vn/VRPfKC+Jc9zgn4z7GU/UraKWJWo9z2+TTRzqzl2G7xM1daLNcpGrwRmqpJ8hVD6nsu61pKgiEP++s0ZDFZpPCF+RKW2xKdPhDAB0lMvPVa3kKmGP/hVnsNbtBEk+nIJL6xCsYBQosB72H9lAJ/oukJz3udA+z9SExISxYHKGMhg5EG4JY9k95NvFi5rAtwzsvE24lrqZNkYiPHuHLN4gDZKCPqg0fKKvDCBLCj0jthNsaFerGeiKdlZUzxpIu68vXzjXNUw5+3yJr3jx/v5y4lRP/cAMLs2XgSH9MrX5esGFjRU9N6gi7ix/2sRcncYoj9DtBUM9m8Pn662uSaCL+TPYh5Y1Aa1usgfMxmBpgD4J2LSV2bR8yTUwH/ifmKXVvxfjmkg515BWdlfJxUfd/Zipw7/Ou7HuQI0r+Q82pz3coIdznfxNWa7zWZLJNXoU3Sr1MTsJsDWd5nNNN+vg3FdCN/TJVL4gWJXTLWWzMES3RzrjFvAtzPquIAgJAfKi54Bd/Ho0uCLOL4GHlBKmHrYBNMGbgRV1vPc18hKBjeKjs5nmdrO987q8lygfEVy9K5VL3b4o49tuFKUQCy/0K+Y7ZITPOELWiVl41fkYk/tw+xwQcNrOMQ2HNeGjAgX3qxGSIkl0+qIwQBwkQQgstGg6uU5l8InzcVtLHh5TVr1X4TR8p8qVNc9gd0Di3mWOe9eHgYj6uN6sNBAKCoY2xAHE7HUXS1goHh1CFmw5pSkvth+HiCYfG3CS0vJ9V8ZI3zyC6Fc9ij/yMwrUIPdIW/y8r0ToVcpb7+PyEs/HDam8yT9i7gD9mVAXj
 uQmkkG2S
 AZIl8xYlNX9FH9iCVCpSbbRYtuMLNyp1gAVB2wEDy4bgJS2jNdnbuQooy2whbkY+FXDpclo/SFQAmobCyn2zmgeM+j+8LfOsoJ4KIW72HfJCr0a8SecdrA+ee+VIeVW2TA6pcokTozfYHytMA3aqYcDr2XqENWKl9ChZRP9IA7XIyQOsn/lg62SUy6/pKJJMnBkPp3hCo/oA06AvC06IRwfL/9QP8NNNEFhHt5YNrLS8QAOtptgqzzj1UcE03zaIPH8AkCVJDcQ4bZfAKO2MYk4dZpopxvUrreAzFD+l2NiqW9Lu8/PAeFu42KiVhu3yGWJxEZ46lcL83/270G6Olzs5dh15uEywXATY2AxidhxZXps241sMkXIOS/BtsCIL6DZS8E4/+2SmGZrk7H2A67dtLogDF1d15Ep5UNK5zh2jpc/ydoMWTiSSbi0WpgVb1Iij4wDroyzB9mL6tz0QMY2IGvvyUMnrS/z2p17HGvKxFgOhrc0wrV9FGemR9Nc+GhIfycZk3O2H9FpTVW8Z2FQKguwB2+HSBbN7ZoO6dCc6y0p1sMKFg0szvhog8w4PabS75NONkdpusMBk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ruan Shiyang <ruansy.fnst@fujitsu.com> writes:

> From: Li Zhijian <lizhijian@fujitsu.com>
>
> ===
> Changes since v2:
>   1. According to Huang's suggestion, add a new stat to not count these
>   pages into PGPROMOTE_CANDIDATE, to avoid changing the rate limit
>   mechanism.
> ===

This isn't the popular place for changelog, please refer to other patch
email.

> Goto-san reported confusing pgpromote statistics where the
> pgpromote_success count significantly exceeded pgpromote_candidate.
>
> On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
>  # Enable demotion only
>  echo 1 > /sys/kernel/mm/numa/demotion_enabled
>  numactl -m 0-1 memhog -r200 3500M >/dev/null &
>  pid=$!
>  sleep 2
>  numactl memhog -r100 2500M >/dev/null &
>  sleep 10
>  kill -9 $pid # terminate the 1st memhog
>  # Enable promotion
>  echo 2 > /proc/sys/kernel/numa_balancing
>
> After a few seconds, we observeed `pgpromote_candidate < pgpromote_success`
> $ grep -e pgpromote /proc/vmstat
> pgpromote_success 2579
> pgpromote_candidate 0
>
> In this scenario, after terminating the first memhog, the conditions for
> pgdat_free_space_enough() are quickly met, and triggers promotion.
> However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
> not in PGPROMOTE_CANDIDATE.
>
> To solve this confusing statistics, introduce this
> PGPROMOTE_CANDIDATE_NOLIMIT to count the missed promotion pages.  And
> also, not counting these pages into PGPROMOTE_CANDIDATE is to avoid
> changing the existing algorithm or performance of the promotion rate
> limit.
>
> Perhaps PGPROMOTE_CANDIDATE_NOLIMIT is not well named, please comment if
> you have a better idea.

Yes.  Naming is hard.  I guess that the name comes from the promotion
that isn't rate limited.  I have asked Deepseek that what is the good
abbreviation for "not rate limited".  Its answer is "NRL".  I don't know
whether it's good.  However, "NOT_RATE_LIMITED" appears too long.

>
>

The empty line is unnecessary.

> Cc: Huang Ying <ying.huang@linux.alibaba.com>

Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>

> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Reported-by: Yasunori Gotou (Fujitsu) <y-goto@fujitsu.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
> ---
>  include/linux/mmzone.h | 2 ++
>  kernel/sched/fair.c    | 6 ++++--
>  mm/vmstat.c            | 1 +
>  3 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 283913d42d7b..6216e2eecf3b 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -231,6 +231,8 @@ enum node_stat_item {
>  #ifdef CONFIG_NUMA_BALANCING
>  	PGPROMOTE_SUCCESS,	/* promote successfully */
>  	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
> +	PGPROMOTE_CANDIDATE_NOLIMIT,	/* candidate pages without considering
> +					 * hot threshold */
>  #endif
>  	/* PGDEMOTE_*: pages demoted */
>  	PGDEMOTE_KSWAPD,
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7a14da5396fb..12dac3519c49 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1940,11 +1940,14 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>  		struct pglist_data *pgdat;
>  		unsigned long rate_limit;
>  		unsigned int latency, th, def_th;
> +		long nr = folio_nr_pages(folio);
>  
>  		pgdat = NODE_DATA(dst_nid);
>  		if (pgdat_free_space_enough(pgdat)) {
>  			/* workload changed, reset hot threshold */
>  			pgdat->nbp_threshold = 0;
> +			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NOLIMIT,
> +					    nr);
>  			return true;
>  		}
>  
> @@ -1958,8 +1961,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>  		if (latency >= th)
>  			return false;
>  
> -		return !numa_promotion_rate_limit(pgdat, rate_limit,
> -						  folio_nr_pages(folio));
> +		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
>  	}
>  
>  	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index a78d70ddeacd..ca44a2dd5497 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1272,6 +1272,7 @@ const char * const vmstat_text[] = {
>  #ifdef CONFIG_NUMA_BALANCING
>  	"pgpromote_success",
>  	"pgpromote_candidate",
> +	"pgpromote_candidate_nolimit",
>  #endif
>  	"pgdemote_kswapd",
>  	"pgdemote_direct",

---
Best Regards,
Huang, Ying

