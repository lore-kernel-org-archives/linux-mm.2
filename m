Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4FD606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=I/XzacrR
Received: by kanga.kvack.org (Postfix)
	id 53D4A6B05B2; Mon,  2 Nov 2026 03:46:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF4F6B05B3; Mon,  2 Nov 2026 03:46:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD1B6B05B4; Mon,  2 Nov 2026 03:46:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7116B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:46:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03E8CA845A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:46:43 +0000 (UTC)
X-FDA: 85389548328.26.24ED138
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 16ADD100008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:46:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="I/XzacrR";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793609202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhbTInRgkBXlbPXlXEHaIHOTP4lL/qI0/4M9rSDHTRQ=;
	b=pUaoc+Jl7o76yuqhRWzccbNeRwJR8ZYnB8UIh56xDTYhPRe0loEe9QzMm2+x/SyCEXNZDO
	1ZabpQntfd3e22wA0WwHdTR1vi4wlxMec58kJcfw9QJAta4xl7mT+1XB2B6AarBpVdlixd
	gPjV3Wssgyj6AeV6s4PvqEJzEEKmik8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="I/XzacrR";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793609202;
	b=ourfeqd78lSQgX5SoCY/RuK4AM44pexw15cM8DhsQslW3q298aDiRYI8GIf4F9BwHk4qVu
	k4gB1ecy+nzziMPgtr9VpXFpt0/9A/7sUyu1D5T2yFI/QM/oAOlvX/Oq/qPtwFD+hmbH2J
	WNWsyHi6qllKwlS/1h1PJwJnHmBLHMo=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e0d1c095dso1350611f8f.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 00:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793609200; x=1794214000; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LhbTInRgkBXlbPXlXEHaIHOTP4lL/qI0/4M9rSDHTRQ=;
        b=I/XzacrRTxVpMf/EvrVy5ivMfFJt+sJcC8bUu0yFXY/fcD9gmR6Tx3CnX1m03d/wZK
         3DFYr3OA58N3DYpu2TbVXtJ0pdnD/tinR+oZH/0PREZwBdE0HKjVyGvufFko3MUmuDbz
         IXnrkQoyk4gkM/k9qPR3j/f3A+Ij6IhhE2xRJrR+Vi7a/RFWa5RYq3UkvOpoIJb6lor+
         4ixgCQ2TYV8PjNNgYfOkOi0enZvBzfKbvVFWWjeFJgbLf/0dR30fhVhbtPpaONCqFXuT
         FyY89HeFA6Z+Pjyz2g520hb5P2bMb+Amj4VKL7WkUBTbQDapXHMcLKhCfO+pOefJ7m6t
         DyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793609200; x=1794214000;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LhbTInRgkBXlbPXlXEHaIHOTP4lL/qI0/4M9rSDHTRQ=;
        b=XBGS9HK3c5rLkaYy9ocCif9/tm0L/Ac7TCA4IwQY7HqYbxsLPdJW63tvqFfQD9hpvy
         5PBUi40EHkYY4MLC/mlZ5rPDNHkK/hRcChlHRgH6i/k6Eto6BnneoyFnzSRSRzluF93x
         ALRah70um5YlM1entS6VxdWAV3mImyMyaj9zzmR98o/R16+ptbK7i/k04a2/0pyrFoaw
         tRcG+7MjmKNkdmsL/CvXI1OIZWR7aLX3mJxJVOCAtfkny4g1TSB07Asw+6Fh2ZPtWgb2
         ur+T8+f3Y95fWQYBOKZ/2aJH7iu4W6FH+1tU4xpXd8bWecmji/fVwkxqKLHJ3s7FcW8r
         sX+Q==
X-Forwarded-Encrypted: i=1; AKwUvBwHga5Xm7y5i+2kddJsdyHsgHJfs/vqMcISw1DD9AspwG1RqAtt60l+9tTDx1po9d2MoKfWO8njlQ==@kvack.org
X-Gm-Message-State: APuU4Z8DuaMEGpj0dS/9wHWleFdmrlX83vKKCAD6gW5X6n7C40QkJMQs
	ka4HuBBchCx0Wean54Pzb1RKkgpDf91JZC+Pziyv7Kb0sbGXbH6bpNp2xzvZX3qZBjg=
X-Gm-Gg: AYBFou3poDRatbNzIkpRAIU0kbYoiSlxMFdxNuQw9gUPj+sdSl28trlu9t9sYxTyfp2
	70DdY6IPEjG+zB8IzVCEX/ZDk7fxKQqw4Fv1qislRJOklkC6UVUOFOMAxndUH+n2m0ZBmQs70Cn
	TDPJRnYdGCJmyC9MRQGvHh0YBQ6ptoPLQioSq/TJBDDjVwYtRoWRd2MhIDJ/PfZ8rX54E8hRlDI
	Ko/ULtHV1Nswce9+4eP9yOUCLNcJIbFOWcSG3PddnEh2jlPm2148K46MBgEZncq5JQUsKVQdkLp
	N4xPiW7T10/Z8hTdZGW9UcnU92PhLHLYOJfM/Qm87wTYIfhtpaspJWy5qGKcNWHDMbotTP0QsG1
	/b94fwof0HDiKwk5by/NqzfBT3P/22pza9WW0qPPlcZb2XzMeQs1v18SfREl6Sa51os9f5CT9VC
	FS9nkInCHLwgbogILQsX/Rpij4gzrg9qVhv+3Tby2sS9wzyAMb8yoN0YVDrwS5zP+Bl+qRY9Ek7
	sPDnQTq1+EpaghWdYm+U/6g0v3kqq3aG2eYSdMzn1QGURi+cpvkUlavMqePm6QKynp0WJOQNqxE
	ByQ1lCvQKEJshMDNO6phdVmo0RhR3raFUFclcZE=
X-Received: by 2002:a5d:64c4:0:b0:488:7787:469d with SMTP id ffacd0b85a97d-48e6e4fca0amr22529624f8f.25.1793609200314;
        Mon, 02 Nov 2026 00:46:40 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8c0b6sm18086023f8f.41.2026.11.02.00.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 00:46:39 -0800 (PST)
Date: Mon, 2 Nov 2026 09:46:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] memcg: force charges from reclaim before trying
 the limits
Message-ID: <auhN7v127jwy-q-W@tiehlicka>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-3-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030205418.341214-3-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 16ADD100008
X-Stat-Signature: fe1ay4635kq7njecd4q9dm4neksih4kk
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793609201-661427
X-HE-Meta: U2FsdGVkX1+ARlAsc2/Q8GZw9j429kn0nsWK/j+05YxTEmqyzB4voOpJj9IswmhXu7k5OiAo8nXr/sfd4UiC9yW04llluyyIodu4Ng54Qf3wwye+RHzNKzegDwB+gTxxEBTcI5lNt0vobMqGu/TRNUl7lhmJrqkfR8D69PdgxStE1dKd8AczZzX65VPiZfEznN7UNR3nt4Gp43wDnME7fzj9ZS9wn0vTpkNt/nXJSM9Q0myWEHfEcd0Kze13WTBoxjgQ6q46y15EPwTieProySPgUvDz/1eeWKdtci8KnIFwJuH34lhh2c4CXOXS9a9RFqi7MUFeFbxSURWSPVAVyl5d9xl5pxNY5HE5CXmCCROWBwK1dJJ9Kvq2A5895zzXbPr33INEIGCy21BGQiBdj8hyPZFzh75SHOWgkZwLLIJno5Lm1tIpx3Tn+P7+OfPnGxbe86nelANafki9nwOnyLzCjb8RM53ag42YhQf/436apVExLnUFAmTaPDt3yvYRqMa3l0kCwhw1J6SvP2TzPlYj4DaGkkNy3EC0mKRNrlZn4yBlrBHenqxTR3W1jahpwKqFoLvmyS/14sGTe5kU4TMjZXqdWs+KUNgc/HUTXcMwWp1kg1GcF49TMNxodAkcES0kyo85ROpxyq8RTuJan02C3ZgN2M8olanOWSERTcwU0hMt+ILa57Pi0qvdsndeFxI/odAVpbH2UuKdA3ApQglG9buEqbKHvd4V+f8CNjS7ccsD/HQiONPMj1SYoIBEazY23ZP9bYB8T68iVWrcbz1zo27tLmtpTSgSeD3zS0WSxTYn5iVZuUcxqd5CSQr7vOrZgH6lejKrhsHVbATS0HiFD8MJeBZRrGbYlP8FsTNLn7IX97lOqyWBc6E0Xfqo/g+6Z5w0q2l4zZEyAaBqNNRqyRBiC/JnjX3qyJR3r6h5Q/nfw50qHHgyYBQWg9Z8/n1b1lUvyCYAoL5Jap8
 Lra5uDaH
 da31ycERG5QtS9io5/fV64DIKBoZx8FwecLmjiPYfYyKmUPpEj2SOuV4bo3zgJXZHd5QZJC1mUFoPk5keP744zMRBsT6D9Qwy4SbVNoX/gL5zf4NzcEnY0spGKZGhcLSSjoV02VuVCAStkgpn4RlorMwkzA8dQV0pjbv98sdA4GtJuaACX7D4rpRpDtIZ4uhN8dzncv4UkJMCSbbUpu0FdGsjTA56zPPF+BCLq2042CZ+E8hI4nhoNknjD78PHm+yDGVFkLqcKeyBT0+qFJ7tz39pvuaVy+4mmusHxvqZ6udymDtXKn5F8HjMMXNLKbX9aUVeg+49jcB32SkC9lOJzQLUv3cKG2o3aw/EsXfa7dSEfNGZP8spmOKJL7VTcBhojTYWxfCJBXNOfX+Wiw/bo3qXDxZib39rLw5i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 30-10-26 13:54:13, Shakeel Butt wrote:
> Reclaim can charge memory, for example when zswap stores a page.
> try_charge_memcg() forces these PF_MEMALLOC charges, but only after
> they fail at a limit. A charge that fits still has memory.high
> enforced. That can make a task in direct reclaim do more reclaim and
> sleep longer later, and kswapd records overage that it never handles.
> 
> It is also a problem for the next patches, which make kernel threads
> queue high_work. The worker charges memory from its own reclaim, so it
> can queue itself again. With those patches but not this one, the worker
> queued itself in 118 of 284 runs in a VM test with incompressible zswap
> data.
> 
> Check PF_MEMALLOC before trying the limits. Reclaim charges then skip
> memory.high, as they can already go over memory.max. Drop the
> PF_MEMALLOC check in memcg_enforce_high(), which no longer sees them.
> 
> Other effects:
> - As before, the check reads current, so it also catches interrupts on
>   a PF_MEMALLOC task such as kswapd. Softirqs set PF_MEMALLOC
>   themselves for swap over network, so the check can't be limited to
>   task context.
> - These charges no longer charge a batch or refill the per-cpu stock.
> - MEMCG_MAX still goes to the first cgroup that the charge puts over
>   its limit. On cgroup v1, memory.failcnt no longer counts them.
> - high_work can still run again and again when there is nothing left
>   to reclaim. This only stops reclaim from queuing more reclaim.
> 
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/memcontrol.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0e484f7f823a..af95a4574a0f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2762,7 +2762,6 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  	 * when it rechecks the overage and simply bail out.
>  	 */
>  	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
> -	    !(current->flags & PF_MEMALLOC) &&
>  	    gfpflags_allow_blocking(gfp_mask))
>  		__mem_cgroup_handle_over_high(gfp_mask);
>  }
> @@ -2787,6 +2786,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (consume_stock(memcg, nr_pages))
>  		return ret;
>  
> +	/*
> +	 * Reclaim may need memory to free memory. Let it go over the
> +	 * limits for a while rather than fail or OOM kill. Doing this
> +	 * before trying the limits also skips memory.high, so the
> +	 * high_work worker can't queue itself from its own reclaim.
> +	 */
> +	if (unlikely(current->flags & PF_MEMALLOC)) {
> +		/* Find the cgroup this charge puts over its limit, if any. */
> +		for (mem_over_limit = memcg; mem_over_limit;
> +		     mem_over_limit = parent_mem_cgroup(mem_over_limit))
> +			if (mem_cgroup_margin(mem_over_limit) < nr_pages)
> +				break;
> +		goto force;
> +	}

This is racy. Not a huge deal as we would get a false event in the worst
case but I think it would make more sense to check the margine after the
charge is forced. So this would become
--- 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..bd202ec05acf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2653,13 +2653,20 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool passed_oom = false;
 	unsigned int reclaim_options;
 	bool drained = false;
-	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
 retry:
 	if (consume_stock(memcg, nr_pages))
 		return 0;
+	/*
+	 * Reclaim may need memory to free memory. Let it go over the
+	 * limits for a while rather than fail or OOM kill. Doing this
+	 * before trying the limits also skips memory.high, so the
+	 * high_work worker can't queue itself from its own reclaim.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		goto force;
 
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
@@ -2683,15 +2690,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
-	/*
-	 * Prevent unbounded recursion when reclaim operations need to
-	 * allocate memory. This might exceed the limits temporarily,
-	 * but we prefer facilitating memory reclaim and getting back
-	 * under the limit over triggering OOM kills in these cases.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC))
-		goto force;
-
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
@@ -2712,7 +2710,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto nomem;
 
 	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
@@ -2773,13 +2770,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
 		return -ENOMEM;
 force:
-	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
@@ -2789,6 +2779,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
+	/*
+	 * If the allocation has to be enforced, don't forget to raise
+	 * a MEMCG_MAX event.
+	 */
+	for (mem_over_limit = memcg; mem_over_limit;
+	     mem_over_limit = parent_mem_cgroup(mem_over_limit))
+		if (!mem_cgroup_margin(mem_over_limit))
+			__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+
 	return 0;
 
 done_restock:
-- 
Michal Hocko
SUSE Labs

