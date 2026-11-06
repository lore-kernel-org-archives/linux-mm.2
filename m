Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75AE0606F8F6
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 11:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uAh/rscF
Received: by kanga.kvack.org (Postfix)
	id 99CC16B05B2; Fri,  6 Nov 2026 06:33:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94D0D6B05B3; Fri,  6 Nov 2026 06:33:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83B6A6B05B4; Fri,  6 Nov 2026 06:33:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F49A6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:33:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECBBA120C92
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:33:04 +0000 (UTC)
X-FDA: 85404482688.20.2203431
Received: from mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id C425140002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:33:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uAh/rscF";
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.46 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793964782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jUYdZrEkjrMq6IR/U7hgRh3o6mcETEnWphbPhg2wWw=;
	b=S5DBrTVRLQTTER4LgsadA+AfwEdlEwDQpzm65ced6P8KEnoX5GCLJgtG9QvDg/ru++d16s
	wyV71J7JoYymKVafWvZ7rDU6Cr5ikNHwVwzAWr9U7CllvmO7JW/7JOOLoOnN6DhzftPj86
	sV5A3ZdVj1wHX6S9NzmKyKGKQECGJ6g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793964782;
	b=t3ihVb+byMAre6aPvtbORYgsbykNAM07/K1XK4LpYmiBCn5dUgSVFm7y4i0k4mOXLJobIc
	9zc6rCK9GvPevobIpcc4vbsZX6Vmu/kgA/xBYTbqJFTgQJjoNeZo5LYCMgr3gOe3SLG8Py
	Kd0J09qcl01/TUd6gVv2ejtVd3VVWiU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uAh/rscF";
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.46 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GwHFqDFLj3G24ers9Fd8pFCaPPZSSUfX8U/u7WtHQmU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793964777; v=1; x=1794569577;
 b=uAh/rscFFhisTP9HlCD+0tRO3XPNijIP1QIJyTobv41JPTXex2txhnpl+ZlpimVsYDYKxdXN
 voPEar/jSKh1FzcAeEuj5wI0iO0dhKXcLdf50PvBF0cK5iiZK5p687OKWC7+KjM3huIk1FzqP20
 T+Nza2yU3qzTDtntrmYfmVD0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 33a186fbf79cc617;
	Fri, 06 Nov 2026 11:32:57 +0000
X-Mizu-Trace-ID: 33a186fbf79cc617
X-Migadu-Flow: FLOW_OUT
Date: Fri, 6 Nov 2026 19:32:46 +0800
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, vbabka@kernel.org, 
	urezki@gmail.com, paulmck@kernel.org, qiang.zhang@linux.dev, 
	akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 2/2] mm/slab: don't queue the page cache work under
 krcp->lock
Message-ID: <au24uW1sxT2Kb_Qb@fedora>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
 <auifTNDwbBTJeu81@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auifTNDwbBTJeu81@thinkstation>
X-Stat-Signature: meo13apyoyj1ufxn6xsmo7ejhtmy6mgi
X-Rspamd-Queue-Id: C425140002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793964780-212177
X-HE-Meta: U2FsdGVkX18FAmJ6TBoavPOhjPrbSHN7m5Zectm4BGEIeBJUD018ZP40ot6RvGmNhnHS8QfuRZ1Oa1u0aXCzpofVw9rkbe81/spWMAsvBGTY9Aej1XRXDrsdsWqDVylPAybLERVOSDuRq9pLXzDcPlrVf0gAgFVtHC+aJ9K65Mno+JZDVFz1UO1M5hy+OTtWbWc1wMpjO2w+AdwpN579NLN7YF4lMvKk4XId8yPXyohicbwh1iYk5KqMyoZvnWWmYSiuIWCTOdWuiite4w5BZtM6JVM5hDMUcJ65ymKVXj/1MbaqTGGVHFTuTYrLpGzbuCo4gfla9O5uBNmsTTKIGf3BJ0jBdfMNNMGOTABhapwvO1i4deBoGzQBoR3go9MtK5rctW9Dr1ez36DCEHXUa5vG1n13hoI0mLmMI57ldcgT9ItDIv1EVd8QxgJxPTKljS06BrGf6f/UYqkWLiwo8ruC6uYutGQ/e7gHGk/9Q0uoQa9QCyPQXQa4NqGL9gFU9OiLubvG3L1sK868Gz1XWYvEiV57N6Y4d4Ki9Xzs4HLlYUng6sgrE9feuliMBE0XvFMGbg9LzMUpCu9EqeDtV1u/SnLo/dWhMIChJR3qzneejLxlkG4S4PfJpk5q4Qpo2K+p+p1bA9bgQh6yKnFSjsUwggNjg6phiz9oocFeWaNmcXrYavfyBWogRX1MJjgS0zTbEZtlvdpkmXRHcfdETyMjyrhp+DPcZWJZXqZZIJ47WBJHGxpy1vb3WDa3t0GcQpT238Y0N/V/V3vWzaf1irmHtVGMuE7Qamyzq+S2Q87Xi4jfipr7FpgN/Mga2mlB4mhx4F26jB3B08O+l9V8VdcCWmTpjao3nhF2rLhPPfD19J6VeShGP27n4m/JzTIElmOMAoCHYpA7NoabMEwz8k20Har23fz2akkzudrncuHhJSHOlU0j2NFgwVdP8LH0DOSgaM68Wa6DfSN8gbQ
 eevx51oY
 Kl2P3QbO8cjLEZbyhcW4yy54yOBPMO6OJ5JHGn43yYRWlP9AR9i46hwuu23CA9zLHcReySBSCdMoDMWcD9Jm4cQ+bXQfxBueEww2a2ZVOYOtf/rRxOPdm2H56Wxulc7LvvN6TZ+uI1yWGxb9rYm6QP5upfha7NvtjgtrxxP0nla2YzkcqTfH+XC3aBMOerJYlrJ/ql0At2eZvxJO6XJKzSjTZXPNufmzK5kVwrxQFX/LuIkkom3T6O3CPpjGzg2Q3ugvL/adH5SSWh0DhbfbXealYIMMVHYz3oxidgwJ7/sjnVfk2Ij7lypoypO67sRf2XCWQL6S7uq3nx8cNVm1X/pJmmmFEY+44vyTB1b0IcdLx/cLjX21g2NtbI3tH5jOcv7E/Xd3j6Fh2FO2wPPXBf0NkjSoT257xay3OkKhg5Zdh9dk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 02:35:40PM +0000, Harry Yoo wrote:
> Here I added bit more context and adjusted comment. End result:
> 
> mm/slab: don't queue the page cache work under krcp->lock
> 
> Commit 56292e8609e3 ("rcu/tree: Defer kvfree_rcu() allocation to a
> clean context") deferred page allocations to a workqueue. To avoid
> deadlocks with the scheduler, it used hrtimer to queue the work instead
> of queueing it directly.
> 
> Commit d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory
> pressure") later added a backoff mechanism under memory pressure, but
> did not consider that queue_delayed_work() with delay = 0 immediately
> queues the work and introduced the deadlock commit 56292e8609e3 tried to
> avoid.
> 
> run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
> callers that may hold more, such as set_cpus_allowed_force() under
> pi_lock, so it kicks the refill work from an hrtimer. Under memory
> pressure it instead queues the work with a delay of
> rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
> queues it at once, taking pool->lock under krcp->lock.
> 
> With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
> pi_lock after a drop_caches makes lockdep report:
> 
>   Chain exists of:
>     &pool->lock --> &p->pi_lock --> krc.lock
> 
> Use the hrtimer when the delay is 0.
> 
> Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> Link: https://patch.msgid.link/20261028134647.3176080-2-zhanxusheng1024@gmail.com
> [ harry@kernel.org: add more context to changelog and adjust comment ]
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
> ---
>  mm/slab_common.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 41dea01a8c1f..051ca63c0b67 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1987,7 +1987,15 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
>  
>  	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
>  			!atomic_xchg(&krcp->work_in_progress, 1)) {
> -		if (atomic_read(&krcp->backoff_page_cache_fill)) {
> +		/*
> +		 * Use the hrtimer to avoid a deadlock with the scheduler
> +		 * by waking up the worker directly. queue_delayed_work()
> +		 * uses a timer to queue the work, so it's fine.
> +		 * But with delay = 0 it queues the work immediately.
> +		 * Fall back to the hrtimer in that case.
> +		 */
> +		if (atomic_read(&krcp->backoff_page_cache_fill) &&
> +		    rcu_delay_page_cache_fill_msec) {
>  			queue_delayed_work(rcu_reclaim_wq,
>  				&krcp->page_cache_work,
>  					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
> -- 
> 2.54.0

Just a thought: once this fix is applied, could we simplify the code further by
always queuing the work via hrtimer? This would make the logic more
understandable. For example:

diff --git a/mm/slab_common.c b/mm/slab_common.c
index ef5ff0a20249..e5213f952e16 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1480,7 +1480,7 @@ struct kfree_rcu_cpu {
 	struct delayed_work monitor_work;
 	bool initialized;
 
-	struct delayed_work page_cache_work;
+	struct work_struct page_cache_work;
 	atomic_t backoff_page_cache_fill;
 	atomic_t work_in_progress;
 	struct hrtimer hrtimer;
@@ -1878,7 +1878,7 @@ static void fill_page_cache_func(struct work_struct *work)
 	struct kvfree_rcu_bulk_data *bnode;
 	struct kfree_rcu_cpu *krcp =
 		container_of(work, struct kfree_rcu_cpu,
-			page_cache_work.work);
+			page_cache_work);
 	unsigned long flags;
 	int nr_pages;
 	bool pushed;
@@ -1974,34 +1974,27 @@ schedule_page_work_fn(struct hrtimer *t)
 	struct kfree_rcu_cpu *krcp =
 		container_of(t, struct kfree_rcu_cpu, hrtimer);
 
-	queue_delayed_work(system_highpri_wq, &krcp->page_cache_work, 0);
+	queue_work(system_highpri_wq, &krcp->page_cache_work);
 	return HRTIMER_NORESTART;
 }
 
 static void
 run_page_cache_worker(struct kfree_rcu_cpu *krcp)
 {
+	ktime_t delay = 0;
+
 	// If cache disabled, bail out.
 	if (!rcu_min_cached_objs)
 		return;
 
 	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
 			!atomic_xchg(&krcp->work_in_progress, 1)) {
-		/*
-		 * A zero delay would queue the work right here, under
-		 * krcp->lock and possibly the caller's pi_lock, so let the
-		 * hrtimer do it.
-		 */
-		if (atomic_read(&krcp->backoff_page_cache_fill) &&
-		    rcu_delay_page_cache_fill_msec) {
-			queue_delayed_work(rcu_reclaim_wq,
-				&krcp->page_cache_work,
-					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
-		} else {
-			hrtimer_setup(&krcp->hrtimer, schedule_page_work_fn, CLOCK_MONOTONIC,
-				      HRTIMER_MODE_REL);
-			hrtimer_start(&krcp->hrtimer, 0, HRTIMER_MODE_REL);
-		}
+		if (atomic_read(&krcp->backoff_page_cache_fill))
+			delay = ms_to_ktime(rcu_delay_page_cache_fill_msec);
+
+		hrtimer_setup(&krcp->hrtimer, schedule_page_work_fn, CLOCK_MONOTONIC,
+			      HRTIMER_MODE_REL);
+		hrtimer_start(&krcp->hrtimer, delay, HRTIMER_MODE_REL);
 	}
 }
 
@@ -2295,7 +2288,7 @@ void __init kvfree_rcu_init(void)
 			INIT_LIST_HEAD(&krcp->bulk_head[i]);
 
 		INIT_DELAYED_WORK(&krcp->monitor_work, kfree_rcu_monitor);
-		INIT_DELAYED_WORK(&krcp->page_cache_work, fill_page_cache_func);
+		INIT_WORK(&krcp->page_cache_work, fill_page_cache_func);
 		krcp->initialized = true;
 	}
 

