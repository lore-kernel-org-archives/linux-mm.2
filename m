Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CDBFCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 09:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52DE66B0062; Fri, 29 Aug 2025 05:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE366B007B; Fri, 29 Aug 2025 05:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5A56B0088; Fri, 29 Aug 2025 05:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5106B0062
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:08:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9F7659A95
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:08:11 +0000 (UTC)
X-FDA: 83829218382.11.2CB78B2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4343240013
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:08:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pppokbhl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SiyTGGrA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cTIBeHeG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TDPf2kZW;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756458489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kT8tkb1gHxlcF3Nk61gZQsdQdGjnax6ZQU5myl5eEUU=;
	b=BESPHJxdXpP8oicb+KVEm3UzbH2PK0EhRpmkWvaqye5t0PniD2wqhN/6DS30JO2O0TmtPn
	AcDx2ipWJa7iu6Nu9QhhJFjpDQEOx3GX7DjDoSIcT+qFbtXN9HaBVd9OfUHhNZsbVUHCkq
	GIXjQ2/THEtGcY2doypNRd2c9gxH1Wo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pppokbhl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SiyTGGrA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cTIBeHeG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TDPf2kZW;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756458489; a=rsa-sha256;
	cv=none;
	b=l9Td7+ueM7YDilMIKfxuQG84coy6Znk+tKyVwxQWILgHQjNNgSj/I7C8vdzwD+Nj7fa2I7
	+kmlhHhUM4LF1J/NEg2pqm9xq45zzc+IrEe83Vdge74OAP4QJ9HgMEpy3fPfyiIOb/g8xc
	fXcUiJ32HdhuDYwbC97t02tK4zUE+H8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C9C2933C9B;
	Fri, 29 Aug 2025 09:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756458487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kT8tkb1gHxlcF3Nk61gZQsdQdGjnax6ZQU5myl5eEUU=;
	b=pppokbhl3LG2+41EjAhE4SWGZpLpdJ7e6ZVc3Cw5PQcm2GRJQunTCn+AHAIoWDLEivBsuY
	79f6KU3tg5y9CyoyTqQ/9Cl+cnKw9g3l5aFDfxsTOh6gOMAhbqE6C5Ywc8StGauWxfijoe
	iIyGvcqjPyyfvjF4XVDHHFWhHUZuYWI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756458487;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kT8tkb1gHxlcF3Nk61gZQsdQdGjnax6ZQU5myl5eEUU=;
	b=SiyTGGrAZ9+TqBz/fvZSbuBEEZRnpa1VAPd2qiERGHbSZwn2RAGM1aXQgb0dNEx6A070Wt
	iOaGpKTlKEy3QlDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756458486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kT8tkb1gHxlcF3Nk61gZQsdQdGjnax6ZQU5myl5eEUU=;
	b=cTIBeHeGDHlahJaVESv8Nc4Exc4+6XVH4pmTYDBHp52w/QXG7SWs69UknE4pBzwBR/lqsk
	SxIfVnbJi0Wzf7kWo+hvZhikrVvC33W8ZnAImSdEWOwqLSQqHP85Q9z35StNU01qhMFQXs
	OBARi2VfbAJzuUfD66iahmR4LOIG8Tc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756458486;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kT8tkb1gHxlcF3Nk61gZQsdQdGjnax6ZQU5myl5eEUU=;
	b=TDPf2kZW5U7YaePioRdo2EfdQDBj4S+1/Dm4kZMQc85S/9eNJdru/j23tDYVHwysAGH+4a
	i5qiWlOE7SqaZ6AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A86213326;
	Fri, 29 Aug 2025 09:08:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id trXZJPZtsWhjKgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 29 Aug 2025 09:08:06 +0000
Message-ID: <23765f70-e869-4ef6-8ddd-24c0b1548fb2@suse.cz>
Date: Fri, 29 Aug 2025 11:08:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE counting
Content-Language: en-US
To: Ruan Shiyang <ruansy.fnst@fujitsu.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, lkp@intel.com,
 ying.huang@linux.alibaba.com, akpm@linux-foundation.org, y-goto@fujitsu.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 mgorman@suse.de, vschneid@redhat.com, Ben Segall <bsegall@google.com>,
 Li Zhijian <lizhijian@fujitsu.com>
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k6bhs7ftz48bydtg5ijmsryfabz1zya9
X-Rspam-User: 
X-Rspamd-Queue-Id: 4343240013
X-Rspamd-Server: rspam01
X-HE-Tag: 1756458489-101078
X-HE-Meta: U2FsdGVkX191QZiqmwK+6mbvwJpwZvSAM8eCP9Zm4mMvxyEmWyKhJ7KTwulfcGnhefVoRz7z9NKuUEnS5TdlffKC0L4ceR5Dl93o/a0+jVrXz+MzwzgpRFeMvE6tkhB0QI2usybnGZ2F/GzsEw8XKQ4/liqJTUJRoQNDWCJXcIOtJYPP53vmV1xnNae6vrLQ9/QWLMDqTDPFF2Yp7OgsNuHplevJvaxPNxsLfw8t5uCLAPu8T+HML06CAi7dI9NJHGi6s66m0nhYPoE01pdJEd7LfId4dkrgoHZg4cuqj1xFkx3GDpdgRULiGlg9MJDRjJERUVo+Fy7PD7VGz9s6zxASJKkQ4I1EI2tvakPguDWf6SQn9BIX2sMoDi5/juEvzzI3lUB7fvwXlx01pDIdccmjjKat++cOSTq+07YOcgi0y6nnBDvM1edSqMOmOl3Wi6+PU1OJ0km5tYz/SuDsIdfv/IJue0ZwUSPcteJ0QLYTh7CJi2+5ZcZVuc6w+roiq7JkO/f10igy0xYJ7YOEsOmx5dSeqcnb9YPiSWzTf164sP0ovkMQ/BfKK+cjpEOiGPCp2f/nCMKcqJjMyvxoPbRDwFS5D8qzEjQzVdq6BEHkW2UnYNA4ZAfUdiqJHu5jFQ4dvv0iFQf7AX9AZcbmFDTYxhD6DoGlhSttv9v1gBpCaTs7c8eMqnzfFDeNU5jqX96vjGQPkPwMcrXNWY9AB0QiJqQtS1iXtF1uRy4h/U2L+m3efVOW9wVRtVEqOctbW/Q/oSLo6M4EhgTYwlt3P1/KYmOL6XJveBZHGgu3t4sq/I7EbU1kdyD5rsPLoWEFUkgfCqkfmTN3Q1xHspurQsdridspqDrEU3I9YMq76WvXp0NewXIjzFXqX5mbdzhxxpaozZ1FUpb81deVWxO4F2ucU1BA7h8F9U/OdfYqH4W2HyRjXrgeMxmR4XLs1xh0r0OBv1zmQORyMUF46Gn
 BhRo1JAv
 xCwMJckRkFYcHnB/2UH1n8QDSIfxBeO3B1bNUEqRmmL8BN0f/8JVeCABwsXy9UHg/Dh428eM0WmCT/H2cU6/THfUOSq9ePjsWgRpozFuKwRq92QhNfkyTnAcPS2gDCJ7b1sgaS0T7CAXPFTd27jWLbdqBfa4BkD85vOwTjo9XfEEQqVkXiNc35hPYXts3ru47+SINoCpF1KOERriD34pYC4uXtsO7qABnHRJCmxi+Kn0zQMN5YUC8T4t361wWWpehTl97dTOGY3VFOzac2WE5TSHd/kQhmDVYV3KC2uFaMQ2I7B9uYemAsZqjTYBWKsjumV5dEpNlwnEc4JVye8i9JTory1XPYcN+0AStga7FRnIv2RCX4OVKXtCWIcnBt2mO/m+skKJtosr6qSbD5ZGBLCi3Qol5o5REiI9/QER3kJtZezTN9hlS9b8gFFVAuLer57/34wjYxxIGHKDDgDGxcFQLKSkIulbtEilpTBJpjaxy3pudkqV/nhBasTSSxgfvS2NP3jX1bHG5dZs3q+CRUJFp2Tkg/rF4ZT9Nxp9V1VDRkpjWS6nUc+UGKAfmfjoukZVn+HApsjVmEl77ZTUwlqC3XQKvaTkLvZYxqwn3w1ZYJtHDFNW23h5AMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/25 05:51, Ruan Shiyang wrote:

A process nit: your RFC v3 had:

From: Li Zhijian <lizhijian@fujitsu.com>

and this one doesn't.

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
> To solve this confusing statistics, introduce this PGPROMOTE_CANDIDATE_NRL
> to count the missed promotion pages.  And also, not counting these pages
> into PGPROMOTE_CANDIDATE is to avoid changing the existing algorithm or
> performance of the promotion rate limit.
> 
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
> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

So the S-o-b from Li doesn't match anything now.
You can either reinstate that "From: Li ..." or add a "Co-developed-by: Li
..." right above the "S-o-b: Li ..." - that's for you two to decide who is
the main author.

More details in Documentation/process/submitting-patches.rst

> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
> ---
> Changes since RFC v3:
>   1. change the naming of new added stat to PGPROMOTE_CANDIDATE_NRL.
>   2. improve the description of the two stats.
> ---
>  include/linux/mmzone.h | 16 +++++++++++++++-
>  kernel/sched/fair.c    |  5 +++--
>  mm/vmstat.c            |  1 +
>  3 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 283913d42d7b..4345996a7d5a 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -230,7 +230,21 @@ enum node_stat_item {
>  #endif
>  #ifdef CONFIG_NUMA_BALANCING
>  	PGPROMOTE_SUCCESS,	/* promote successfully */
> -	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
> +	/**
> +	 * Candidate pages for promotion based on hint fault latency.  This
> +	 * counter is used to control the promotion rate and adjust the hot
> +	 * threshold.
> +	 */
> +	PGPROMOTE_CANDIDATE,
> +	/**
> +	 * Not rate-limited (NRL) candidate pages for those can be promoted
> +	 * without considering hot threshold because of enough free pages in
> +	 * fast-tier node.  These promotions bypass the regular hotness checks
> +	 * and do NOT influence the promotion rate-limiter or
> +	 * threshold-adjustment logic.
> +	 * This is for statistics/monitoring purposes.
> +	 */
> +	PGPROMOTE_CANDIDATE_NRL,
>  #endif
>  	/* PGDEMOTE_*: pages demoted */
>  	PGDEMOTE_KSWAPD,
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7a14da5396fb..4022c9c1f346 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1940,11 +1940,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>  		struct pglist_data *pgdat;
>  		unsigned long rate_limit;
>  		unsigned int latency, th, def_th;
> +		long nr = folio_nr_pages(folio);
>  
>  		pgdat = NODE_DATA(dst_nid);
>  		if (pgdat_free_space_enough(pgdat)) {
>  			/* workload changed, reset hot threshold */
>  			pgdat->nbp_threshold = 0;
> +			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
>  			return true;
>  		}
>  
> @@ -1958,8 +1960,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
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
> index a78d70ddeacd..bb0d2b330dd5 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1272,6 +1272,7 @@ const char * const vmstat_text[] = {
>  #ifdef CONFIG_NUMA_BALANCING
>  	"pgpromote_success",
>  	"pgpromote_candidate",
> +	"pgpromote_candidate_nrl",
>  #endif
>  	"pgdemote_kswapd",
>  	"pgdemote_direct",


