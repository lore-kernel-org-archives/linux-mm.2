Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F065606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZILsJYw
Received: by kanga.kvack.org (Postfix)
	id AE1D66B05B0; Fri,  6 Nov 2026 07:21:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A933F6B05B1; Fri,  6 Nov 2026 07:21:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8666B05B5; Fri,  6 Nov 2026 07:21:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71EEA6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:21:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A70C0A8B44
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:21:33 +0000 (UTC)
X-FDA: 85404604866.21.37F2588
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EE2DDA0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:21:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZILsJYw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793967692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRzTH+yd4d8od9LM7sI2UHx2nrHb7DkZirOlIhvtcmU=;
	b=VJIqEqIQbJVld2VIBgdAHP1B3gC2KArJ8OVqXqBMmAZUqJ4iJwn0nKIm32G3/GY0ounwh+
	fsyfk+sB4wNEybTx1+xWJIjEG3VQX7Jh1YccQNqXtO/Y2FJ5+TQKa6KBA1e13/PZOfyqRm
	KfWxGv2wIXKeJnf2AHrXduqNiNloo4I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZILsJYw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793967692;
	b=kpHr/TMFe0R0psvIdlVFZVUNRqxOefzmnm66kp1cyJ3xQvUuus+/vFHr/nAlpZyXTSg5Tt
	AXHwfRKGmSviISJl/Wjl1wkBer8SZrHBO1qkum1bWB9oQY3pQOj6A6hEzfTHeaHT+20lxn
	I5GD/+1HgCBJ79vOSFwO1JdjHVi1CSM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F80B40533;
	Fri,  6 Nov 2026 12:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F25F1F0089F;
	Fri,  6 Nov 2026 12:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793967691;
	bh=cRzTH+yd4d8od9LM7sI2UHx2nrHb7DkZirOlIhvtcmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GZILsJYwu5BayQcmz0opObBE0Ra84AH2emZVoDsYwET5lsnXq/90QfHCKSiuVcyng
	 QK6GS6TxvENK+/sND0HJk/pISIlyglRaJyq+yYhObAQDtBYNHdEpVa63IlVAN5jN2n
	 Bl71ZLc1hzVRPjVqVBic13CoXv5zTenBbEqK2e4ETjWnl2nEyM+OP3mMgP/jgfMMhI
	 gkeW+EK9keSGXtJBvkIbdh35aMPfca1IHC/jAU7w9xnDnPoyviV3mUPcSBB7hkElxv
	 wte2pRHKe9ddWnUtU/1XJDkCxQk3YddRhQ4Og723Jd8cfqg3VuPHeQIezaf2h/RZEN
	 Fe1/F8bvxLhzA==
Date: Fri, 6 Nov 2026 12:21:28 +0000
From: Harry Yoo <harry@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, vbabka@kernel.org, 
	paulmck@kernel.org, qiang.zhang@linux.dev, akpm@linux-foundation.org, 
	hao.li@linux.dev, cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 2/2] mm/slab: don't queue the page cache work under
 krcp->lock
Message-ID: <au3ELzm_s9vhs7UO@thinkstation>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
 <au2fUYzBLv3uvj_2@milan>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au2fUYzBLv3uvj_2@milan>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE2DDA0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 686mx88sj4bxei5eaj7xrk56etyrgni6
X-HE-Tag: 1793967691-854678
X-HE-Meta: U2FsdGVkX19h+clfoIJctNWXE3Oosi6/7HgdFPxTN57mjLiwtd8IMDLjf4LrjS+CSFZDM6qpR0vw6D99njlPSzNsfc6sur/VItKMNjIDDwpTGmQDlInJf6uYnOumDIYWbjis1FR50oWLZrGb1bDh3fKQ9EfyHdY9DUe4lLwcN5OwiYb2QU7++v5iOVXAhGHsHQ5s1YGPbutF3ztKsXtHUrv+sGKMHRutnfVQWO1fuP3kBrgs8INojce9ON+fBJXxUoEm2g0AtOTV9HmxLWzC0lqIOwIsyDbCdKfw6Rxg0VIsa3RnvL8Ts+lX0Izfw+4VljMCn6RyjNCKZc9CYxG6amR+JzVlVE6y2alxb35qGnf61/l3pzoL92o2CzXZ2QlnqqVe4kdWVRjif2ZYpUOTsB7QD8LbrRW4lF/1P2SqCQajeiNL7PzwPRauX5oSA6iloRqi5Fyh1HkQ3EuD3qHi68XbGgvjTTMN07RFvHscXjFblofkz4LR351zqCWTTf9SfjrhNGjnVX5R0lVFfMLhpoqu6ZDbavp1brAzTkr7Kls2DyBv1URW/pGwV4Pj3cYckt3Q8aXxPyM3omVnrPRcdNaV9MvNDJc3mpn3Ay2FD4Uhe/VEQvrf31dwWVoVhqarLbTacBSD2GyOU6LxiXXOkUFcEQ4m4q7ZcXChiek9FOtfHQE7HKoRxaj+bGo6aw7qjkOmGJ4jt2Lf+R0xZhixPY9e8VuYWZooCUEHvRQVnRj6bmw+hBXy0kiDOaTtE7XNP3Afl4Ed4rNfS1SaCZcmkbm759A3IOLJ2qZG243md2tnYiDUyI2/CP1+XAN3WW2AybBDixUVoD3BqF6Du416OO3GoYE9MUrZvDG2bWODyUJxEvcsQlmaMYzZwheJRh0Qao+bbteodNVADCSzIwpJQNnRTiL7m3NgTtiaJu2Amg721rp7un4JGs9eXh0XalupHqKpjAsvJfyt1YeA7AM
 zbyft+qj
 yjL0WOEh0sltWbwuYO5Qvcck8DZfZbManmlvvnIrAvHhsn7HYPNsTkzRhMBeIqOQOR1Quoz3RUwwKnNBSJYv1YO0icCVFKpRuwCjBjiCwSMGEZ9/ITVn5D2CRu/U7kRXe+Eh/MgZn5gbDgB+pjZ8Csgj6GAQBumtio9BIz6fPklCnHIgKKhc7QEpofMQ7imRWNtOLIIqSgueHcSdr4cNTGFBOTpkA9DRBo0E8egXfRVaYwH6jf+VcON99PQo34eOmPG/NCMmK3mck2xhYl3CCZ2EG9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:35:13AM +0100, Uladzislau Rezki wrote:
> On Wed, Oct 28, 2026 at 09:46:47PM +0800, Zhan Xusheng wrote:
> > From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> > 
> > run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
> > callers that may hold more, such as set_cpus_allowed_force() under
> > pi_lock, so it kicks the refill work from an hrtimer.  Under memory
> > pressure it instead queues the work with a delay of
> > rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
> > queues it at once, taking pool->lock under krcp->lock.
> > 
> > With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
> > pi_lock after a drop_caches makes lockdep report:
> > 
> >   Chain exists of:
> >     &pool->lock --> &p->pi_lock --> krc.lock
> > 
> > Use the hrtimer when the delay is 0.
> > 
> > Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
> > Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> > ---
> >  mm/slab_common.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 3729aa7a6156..ef5ff0a20249 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -1987,7 +1987,13 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
> >  
> >  	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
> >  			!atomic_xchg(&krcp->work_in_progress, 1)) {
> > -		if (atomic_read(&krcp->backoff_page_cache_fill)) {
> > +		/*
> > +		 * A zero delay would queue the work right here, under
> > +		 * krcp->lock and possibly the caller's pi_lock, so let the
> > +		 * hrtimer do it.
> > +		 */
> > +		if (atomic_read(&krcp->backoff_page_cache_fill) &&
> > +		    rcu_delay_page_cache_fill_msec) {
> >  			queue_delayed_work(rcu_reclaim_wq,
> >  				&krcp->page_cache_work,
> >  					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
> > -- 
> > 2.43.0
> > 
> > 
> Can we just clamp this to 1 - 100 seconds interval?

You mean clamp to [1:100,000] milliseconds interval?

> <snip>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 7223a7596dab..2c9236236ac9 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -2249,12 +2249,12 @@ void __init kvfree_rcu_init(void)
>  			WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
>  	WARN_ON(!rcu_reclaim_wq);
>  
> -	/* Clamp it to [0:100] seconds interval. */
> -	if (rcu_delay_page_cache_fill_msec < 0 ||
> +	/* Clamp it to [1:100] seconds interval. */
> +	if (rcu_delay_page_cache_fill_msec <= 0 ||
>  		rcu_delay_page_cache_fill_msec > 100 * MSEC_PER_SEC) {
>  
>  		rcu_delay_page_cache_fill_msec =
> -			clamp(rcu_delay_page_cache_fill_msec, 0,
> +			clamp(rcu_delay_page_cache_fill_msec, 1,
>  				(int) (100 * MSEC_PER_SEC));
>  
>  		pr_info("Adjusting rcutree.rcu_delay_page_cache_fill_msec to %d ms.\n",
> <snip>
> 
> so we forbid zero as value to use?

IMO in general we should keep existing behaviour unless we could
demonstrate setting a delay < 1ms is fundamentally flawed?

-- 
Cheers,
Harry / Hyeonggon

