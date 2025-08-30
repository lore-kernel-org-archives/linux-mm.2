Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69626CA0FFE
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 07:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2D46B0027; Sat, 30 Aug 2025 03:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA206B002C; Sat, 30 Aug 2025 03:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C00D6B0031; Sat, 30 Aug 2025 03:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B96A6B0027
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:59:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3766B119F89
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:59:08 +0000 (UTC)
X-FDA: 83832673176.14.A849B1A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id D1849140003
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:59:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=07nse3Gv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KAWMnW1a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WL63TICa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R907s8od;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756540746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8G5u7p+krPqozve1gIrj1loYM9L0j9YkyF6aK4YOtQ=;
	b=JOE/t/uKYNCV1bLMjYRiFNTtnGRlcdgTGSWcgKEdpzDWpmb6UZmKuEbCQm3BNkBR77gRnb
	BpGQiGvNqAh1CCSOLNUU1400nckqtycDrPW9853OguLa0BY1fNqey8Cssgqa84hgDp+kjj
	kLUi86iThcXgNfWaxi21hKO37PW2d/4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=07nse3Gv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KAWMnW1a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WL63TICa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R907s8od;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756540746; a=rsa-sha256;
	cv=none;
	b=OCkjTrlYVhk5dJVfmgPsv5AgLCv7sx7BGlhgv9qzAOLdQuUXH892Vz/vU4U/gzRzgCwadE
	zpYsQKWwj47yi2R44hxdwJStf2AweT45KJzgnipuzRWgLnTEShqnrowrhqElX/i1NiAQ6t
	okaV+57LjRp5L9a0QFNJl12JyVzoDiY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EA9D21F44F;
	Sat, 30 Aug 2025 07:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756540744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X8G5u7p+krPqozve1gIrj1loYM9L0j9YkyF6aK4YOtQ=;
	b=07nse3GvCFE6CoI/WHIWKQ4N7n3LynZbFoQwSLiEiIMu0MZEslcALuaK4P/3BRZRagNmnH
	yHrHjej065py4MRUB2LTYg49CzTBd4Uc7dtqPnHeaLhuLJF3Wn3vqLCC7I2A0tAJaMp4WP
	4Chc+eOIrbSDl3T/DK8VO20umwN7dUo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756540744;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X8G5u7p+krPqozve1gIrj1loYM9L0j9YkyF6aK4YOtQ=;
	b=KAWMnW1agj0GhUHmhtie8hBnXThp7IaJHnMICNTHPGOAbUGZ7BvNzO28yMboD80NNvkQnu
	8KoauSTYWFBegLCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756540743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X8G5u7p+krPqozve1gIrj1loYM9L0j9YkyF6aK4YOtQ=;
	b=WL63TICa8pQYgOJkaqazgjW9EGrttQoeEIzI2z/Q7dXw1dO16JCegsqUbYZ+0Y6pk0z8zz
	/h3+28NPvPquIjNFQJH+dpB4yRsnv3QR5QTEqLcaFYKHlxqHod5ucpRl+KI+z4OI+1PR/N
	qhoskY0Khg43MyjGw2wcpeyWnvvKJbE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756540743;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X8G5u7p+krPqozve1gIrj1loYM9L0j9YkyF6aK4YOtQ=;
	b=R907s8odvCsU9KujHAwcEqihVuKM8xaPcWRapFVPHQUcVjWHFuhhTZXCLDONOtnim32hfm
	VP5VpC0ucG//wTAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B47B0139B1;
	Sat, 30 Aug 2025 07:59:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QpTjKUavsmh/IQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sat, 30 Aug 2025 07:59:02 +0000
Message-ID: <f4f92543-98c7-45f6-9f53-ab340d980a49@suse.cz>
Date: Sat, 30 Aug 2025 09:59:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE counting
To: Ruan Shiyang <ruansy.fnst@fujitsu.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lkp@intel.com,
 ying.huang@linux.alibaba.com, y-goto@fujitsu.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, mgorman@suse.de,
 vschneid@redhat.com, Ben Segall <bsegall@google.com>,
 Li Zhijian <lizhijian@fujitsu.com>
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D1849140003
X-Stat-Signature: gnu35j3c3y5iw3ityopfxjty5ypmwwrm
X-Rspam-User: 
X-HE-Tag: 1756540745-186346
X-HE-Meta: U2FsdGVkX19Wf0cvqW49AJVWUeTVGYU/IQW0+gZHzRF/nb7WrEAN/t8rlQrEu2ODoi4dk71a27t/RlVmVWw9s+NMkmKYfbD2LPYYEASRVIzHOCfkg948mzMNjcj4SF4TGst6Q9RbO+eYqGhACJq6i4aVPc6YZSxipiML73gpnRoC4oRGy0PMhDDySK74Hs56tAMvt+SpQQPH8gbTjxzet+H2uUouhAoDRnDclxsGeiRlM0+zpOev7QbPj8qZz4Ywi1ok9GN9v8XhPW8qZJ8HixWiGFoYNunzTxBwF6POnWxDDZy1tedQ0nAlqhyCHrOEGSyONe0OcHSnzWRAGaDJAX5oGsV41AIZnOzwu5tS0ipLYER0mUOyzKmx0/oC5x32OH2041TQoBAsaVMzGmBDv8cJglrzCdU7KTyj1jUIkJ7/B5vROyd7GxLDRN9QewRou3DarPxXOGJM/3BWKSuMAZ5oUkTLo8AW3bMYqFT9TCyL5+ZgKe62G8gm8vRL88SvlWDnKCFvVYGa8Um+H3LOkc5AhnJ+xuGxo5mlS0zIMD6UH5vI/adSWqAzT8dO1lrFjkgCgZsBnJihFDk0UTS3kCZt8LPwJLkMHgTr1jJY7hLdBYBjkb0mN1Ng/Rc/FCTNmTl832oT4ZyxNGc33OCOzTKxR/fWFR0QmrDd+omHRHb5ex2tbHbuZwz8T4lIqBv1nPYy4OSMvp9HX9G8ibmfgbUwPbj9/cryJYzroWryZ6CDu80dZwkoezragayYERUHQXZ2E3HunVBZ8SbLH7mGtDBw+qRSE7xZsoOh0TxPG+DrW1SygdkYHKIyAjlvBZ+I9e4mP7CNLp87JQCxr7UVCkwzjZ4EiKk5yxzwGRZr26M3n0JmMu25o5HuEb/pwmX1dZokHqcENfz929a6HFmDDq3g8+INpkzr3Xm2N/1a8sUxrHLr9VCZZeN49CLnPq0+gn8d3n1mjA1PLdbg4JE
 RJb0VBzG
 0X5B054afbnw4RhV1ckRN2c4o5xEfXiQ74Nrjtuh6augGqBA1czhZCEK7YuDq9XJOJYknL9LT7E3tmqQvmf8IxED+6jt+HfW+HRWtJGEvBWwmGc7DzRFk3VfGCEsj2IFHnuTBf2aq4MxeLQnS/tpdvGEn16+FUXRkEH5OMY6l+rvVT4dlCP0v1u/o/ox9oqQg1FQj7TnozicFkJgFEvFpZXmv1gK0nxWfFxAmr0FDw/UnSk5Bz3MvRgddIoRrZU3OXWDFf0sep7zhoFF6xdf+nLZSSE4WgZVW6ZW0Z6PeB4+TVK7Dp01i+A7yNJHouAFcHJOpjIbxxEcGJSBW2aZhZBue4dtecN6iM0Qvsdga8mzk1cXE1htOWmQ7Ibhge+1yUtk6Jup5LPvnvY7x6NFrBTbOZzMJqmJb6ThHqxnKudSdqcn16e8qV0HJmnetP4rQVB30IwStDpnWBO7Rv90VVqCQGr7Q1zz+Dtu6qyd9wO1sEjXH2kLqAlf2vN6dkVzYkJ6Y9W+BPYAqqkD3r29/cyGHJpLZdovAZj27W9QJ8ASVnos+sO4Z5/yk+/GUND9V9lvMB0uIZl1Mew+CfpeatlScQURj6Tnj6BTMhMOxTXrJ5l+0zakRFZiyWfPejtOd6HX/v3UrqvV9H5au1exVtJKslUItwBoEATmZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/25 05:51, Ruan Shiyang wrote:
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
> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>

Besides my nit, LGTM.

Acked-by: Vlastimil Babka <vbabka@suse.cz>

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


