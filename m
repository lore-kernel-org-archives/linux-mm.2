Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBEAC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0996B0092; Thu, 27 Aug 2026 12:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B517A6B0095; Thu, 27 Aug 2026 12:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B056B0096; Thu, 27 Aug 2026 12:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76EEB6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:58:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BCD91A010E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:58:03 +0000 (UTC)
X-FDA: 85147656846.26.C428797
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8C6601A0005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:58:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ivqhg7pH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787849881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsgdxAZ6noNKq0rZ05Y3MNO3C15Zq2KoJCzUnq1N14k=;
	b=s7BscR4s25LKxNWikPxeXt0RpAfdmj7PXEG/dInV80O60QP2Kp3RIQbFrhbkzUKHs7DINL
	9xthyHzatxg39gs1EKYzSPLYdlVUtqcvItGEEr7aAUiI6P9uoIwdzIa/+hdJ7wG6APPggO
	gIRypIbYzzJaexNP7kyZCPrEKUlY75M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ivqhg7pH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787849881;
	b=CZMeTZkGWa3/LP1a7UzBxuvPkoerQ/AIvwvmGHEzM7Wrigmm757NlsUH/u6JIctAB/DRu0
	fRDPUSgNSmQdup3gaZDiM8Ox9O9ejEVcfacoJLZWRrnAXi7G2GLT9q5HzpB0O6u5gxd0iZ
	M3HlePy3H0xhfeVSKBNu95KR93/S91k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/QFykKqY4DddYYy1JGcan4kcCBGwtGcv3+RRD0IyIGI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787849879; v=1; x=1788454679;
 b=Ivqhg7pHLNsyndpaARYlFqDnmbpn1BaiBSqdHDcYc9yhz/pIdu9VmkV5j55SLDNmXNtPJZaE
 0Cl/Y9gc7tdKLsmud+OSnZkVge2QVvg3J0MR5gK6zz1fqKDFmtUFJimwlAa2EPUAXtYxmz3vToK
 vR7Mlb767U8AJY2CwUqm/o74=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1ee3e873e45b78e8;
	Thu, 27 Aug 2026 16:57:59 +0000
X-Mizu-Trace-ID: 1ee3e873e45b78e8
X-Migadu-Flow: FLOW_OUT
Date: Thu, 27 Aug 2026 09:57:53 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during
 offline
Message-ID: <apBsMXzLXltN9MTd@linux.dev>
References: <20260827124211.3b94b103@fangorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827124211.3b94b103@fangorn>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C6601A0005
X-Stat-Signature: iee65te5h3z1u3cq4m78w4r148omb99c
X-Rspam-User: 
X-HE-Tag: 1787849880-298829
X-HE-Meta: U2FsdGVkX19Mpsdr/RR102SnEsZ/3hT3BCSUw3PI6ZKVan0dl7/WeCrATfEPsEDaPURaPyYa3CE/MLYXNMbylR+L8o+LtiHUEs8MkGV/jOdvSv+J1hi5U+prGxR9wClsky9LuuVXXs9Ar2aLpweg+nfY65N+FKprgr7NxEd5tpRvlXerVw/+yEW4V3NwyLFMYKe6hk+ptuE0r0+k/MQcYawFN3qYf8P1OqVijEjc157JDr8v1tCmn9WoZu+8KWRNFUqmqHy/t1KjprC8xKZ5nMwVtzhMc+qvhdCUbv28b9lLTKnAx+X6SD/edKYTBrrJE32x75Q8d/vx4PcSePitZ7+zsggW269MdnRcjQsorLtKqt0zj3OTVrLsExQaoLqcBsV13P3+4EAURSWKZOwaxkbJw1CZlDL6Qqi0Fqhlz23Hpe9nqsibGNJYBDNuo7j4rOmTRAzLi6pCku7+wILB5RJSXiZ2jxShpl76Y1EYO+k+z4+THJ9VKXnNGyrDsWHQZeTQrAnTT8H4DZ8O1QrzLVtPLZ84HKF7hVVP+wxOfFuN3bAoawtUQeJLDy4czFw3PDET2PL2QIOxxEpzbfsFLPGoAOe+j3kDsr2Gysv7EkoC5TkyAVk16lJr4+073cP+ua+bz3bpDk2pfiO8C+2bxNv6tOZIZcfVblSQ2j/HUsVkYxTVMfr9BVMq6VAyoAvZRKRCUfBaAp04bIh48nCoGBC+ivJpjkjCsQhUx/Ilsvx+PRWAcFlC9nEE/Kd1YPFG5J/AGVVEHXLjQAH+eoQ26mI3Vu6mdXef4kpOy9nBxSlgB23uRzUpRMCS3sEAJzNWT6EI6MD6TbXNsKrv8HqBtvIEILs0CuVeordJqPfsHi3OwIJEptWuKMZncF2Q5xRrWA/ILZx+vQNvB2xr4mpAdKpTgojQIM2HzeQ31Zw+iXwYUcQO6JevdZYDkN7yramjjH8Q7A6eC4KjA4TZU6u
 SaIwlUhA
 0DKMl3daiT63ugcU2fMlYmao2uX5Z1ndsBLn3uNT4T40SLbmpO0iMJFFfLahj95dIIOBTq0LcS2gqNp52wb3juhNQEkmE1UzgsPjxmcbq81a9DKOuN9Hi4RExEJ6qLR6jXcJwT78IaHh+dBaTfXE9GjDyZ0kgF5amq757T3Ran1KS5AqgCVuOTZQ+zzBEWjjqdaKyOk5yhvqvIOt50x7NRmZAb3xsfylQQ5AzL4QbHTCNgSOfNmImnuSAxsAGAYdY8xc/AObnjudGnxKHYlgtGgT9RaFh6hdqpgGT3Yz1I6Ep004WjVGpmZKWQaDkn2UVsRlJJytp2mvXGvGRoIu/vPZ6EnDGfs49p8HMyblOETY8dLlqydb96E12VqRvw3YWhbMbnObhYWcn4YleXAwWWgqKuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 12:42:11PM -0400, Rik van Riel wrote:
> drain_all_stock() queues drain work on remote CPUs via
> schedule_drain_work() -> queue_work_on(memcg_wq) and returns
> immediately without waiting. The worker, drain_local_memcg_stock()
> / drain_local_obj_stock(), dereferences per-CPU stock caches with
> READ_ONCE(stock->cached[i]) and does css_put() / obj_cgroup_put().
> 
> mem_cgroup_css_offline() calls drain_all_stock(memcg) to
> optimize reclamation latency, but never flushes memcg_wq. If
> that races with cgroup removal, free can happen while workers
> are still pending, causing UAF. The drain work could also have
> been queued by somebody else before offline started (e.g. high
> throttling), not just by the offline path itself.
> 
> Timeline illustrating the race:
> 
>   CPU0 (rmdir + offline)                CPU1 (charge cache holder)
>   -------------------------             ----------------------------
>   cgroup_rmdir()
>     cgroup_destroy_locked()
>       kill_css_sync()
>       ...
> 
>                                       refill_stock(victim)
>                                         css_get(victim)
>                                         WRITE_ONCE(cached[i]=victim)
> 
>   percpu_ref kill confirmed, css_killed_ref_fn() called
> 
>   css_killed_work_fn() [offline_wq]
>     mem_cgroup_css_offline(victim)
>       drain_all_stock(victim)
>         is_memcg_drain_needed()
>           READ_ONCE(cached) -> victim
>         queue_work_on(CPU1, memcg_wq, work)
>         // no flush!
>       mem_cgroup_private_id_put()
>     css_put() -> refcnt may hit 0

Why would refcnt hit 0? CPU1 stock has a reference.

> 
>   [RCU GP]
>   css_free_rwork_fn()
>     mem_cgroup_free(victim)
>     // victim struct freed
> 
>                                         // worker delayed by scheduler/
>                                         // WQ concurrency
>                                         drain_local_memcg_stock()
>                                           old = READ_ONCE(cached[i])
>                                           // UAF: old == freed victim
>                                           memcg_uncharge(old)
>                                           css_put(&old->css)
> 
> Fix by having the offline path wait for the workqueue to be
> done with the memcg, before freeing the memcg.
> 
> Found through a code audit with kres.
> 
> Fixes: 591edfb10a94 ("mm: drain memcg stocks on css offlining")
> Cc: stable@vger.kernel.org
> Assisted-by: Hermes:muse-spark-1.2 kres
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/memcontrol.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..c95a1f6ec799 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2273,12 +2273,18 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
>   * Drains all per-CPU charge caches for given root_memcg resp. subtree
>   * of the hierarchy under it.
>   */
> -void drain_all_stock(struct mem_cgroup *root_memcg)
> +static void __drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
>  {
>  	int cpu, curcpu;
>  
> -	/* If someone's already draining, avoid adding running more workers. */
> -	if (!mutex_trylock(&percpu_charge_mutex))
> +	/*
> +	 *  If someone's already draining, avoid starting more workers.
> +	 *  Synchronous callers need to guarantee all the last things
> +	 *  are flushed, e.g. before a memcg is removed.
> +	 */
> +	if (sync)
> +		mutex_lock(&percpu_charge_mutex);
> +	else if (!mutex_trylock(&percpu_charge_mutex))
>  		return;
>  	/*
>  	 * Notify other cpus that system-wide "drain" is running
> @@ -2316,6 +2322,21 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  	mutex_unlock(&percpu_charge_mutex);
>  }
>  
> +void drain_all_stock(struct mem_cgroup *root_memcg)
> +{
> +	__drain_all_stock(root_memcg, false);
> +}
> +
> +void drain_all_stock_sync(struct mem_cgroup *root_memcg)
> +{
> +	/*
> +	 * Make sure the workqueue is done with this memcg
> +	 * before freeing it.
> +	 */
> +	__drain_all_stock(root_memcg, true);
> +	flush_workqueue(memcg_wq);
> +}
> +
>  static int memcg_hotplug_cpu_dead(unsigned int cpu)
>  {
>  	/* no need for the local lock */
> @@ -4305,7 +4326,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  	wb_memcg_offline(memcg);
>  	lru_gen_offline_memcg(memcg);
>  
> -	drain_all_stock(memcg);
> +	drain_all_stock_sync(memcg);
>  
>  	mem_cgroup_private_id_put(memcg, 1);
>  }
> -- 
> 2.55.0
> 
> 

