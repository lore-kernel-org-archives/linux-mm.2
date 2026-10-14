Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 293BECC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90006B0095; Wed, 14 Oct 2026 13:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C405D6B0096; Wed, 14 Oct 2026 13:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56706B0098; Wed, 14 Oct 2026 13:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9AE6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:55:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D733140704
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:55:37 +0000 (UTC)
X-FDA: 85321984314.15.111B288
Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	by imf06.hostedemail.com (Postfix) with ESMTP id E6CE0180002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:55:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AKkjKY88;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.233 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792000535;
	b=Tts7iPzeHPVUzK46cBswnCRLIY7/z0KflQb6MCQV4oJopGGR8yo3qM4WmCw8JwLbWUI/8L
	2sh5r6iv4XNumgMtltV3Br/b1YzSrEYPrVNCB9Ah1QCn9vAVA4AZnVmPjLjfWudVUVy4k4
	stdArG+9rFqYvPmDe7yz7V9JUrGCen0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AKkjKY88;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.233 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xge1vc0jb6fmUlw7unH5OfQOnZovf/7ujkD1+U1EnOo=;
	b=G75KQxrh4o20UQgp4ux6yvK16A2g/kZR6mEglRdt3cLg2YgvrjcrizfJSwib9fKmk1DShY
	vbddRtFIygR665pa3QRXi4kbBsJvGuwW8fxUxwYRQ65CkM/E9R7wa/bEzN4GPj9VU3cKZ4
	V1OtPx0mZTfab1HAGVsqvlp51EKn5wc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eaVf8DiKWy+Ej0oOi27k8+cbzyMwGdVNwHvpr7Pf3+Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792000533; v=1; x=1792605333;
 b=AKkjKY88BP8jUI9Gc3I6okeGZb/a7o378A/ApJqOdDcQwYE1gt3N6LVXPayoYOin3sCXrvgc
 yHk/PJxd0LmP6YamEGIRT4XbBOPd+FXgX0uuXN6rsL33qy8pDar8nkRL0+4eb9eUWQrqEKX2qzb
 ElHPuSg8MiFF4EZ6mo3As3wI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 071c26393a68de4d;
	Wed, 14 Oct 2026 17:55:23 +0000
X-Mizu-Trace-ID: 071c26393a68de4d
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 10:55:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as_AxtUlV8K2fkNu@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
 <as9p2uFqCQprwdnI@tiehlicka>
 <as97Nzob4XuzO9Ss@linux.dev>
 <as-08j9_1C2F_N8s@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as-08j9_1C2F_N8s@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E6CE0180002
X-Stat-Signature: ur39tjwj6onao1fdqa16wozguhzqy7tc
X-HE-Tag: 1792000534-751363
X-HE-Meta: U2FsdGVkX1+Y+7UvAY9JgEU4oGK2v0QxAGGmO9m9Tb/LDq2TIlRNs9Y9/M8n5R/0ysNY5fpYLv9zE/HDKzsYww/TK9A+LQGgBk/MifrQqSXvcFPZnUqonaHZy/qQNOOHKkjjMiiHw3icE1BEbXYm1HXCbPo1hHDAlde55bccNSSIkWptAFqtMJihgF/q4HNUAhZcueuTJT54Uu5f6VDF2ahuQsTqtfnOPAU5t8xx1qGYEx+Hb1Pt32rK6RENnd7Qve5pwGSyNroQnD65YbUfCeNd7KUxBXlNgFokj+FAWDB0hnI0GWXC8VRb+Qk4saemQFF1PBHNiWuNPOuD5xYRmf+LCnrPDT6WRwX54w6IiF+VCUZT8eNn30DBxkDcDXBCFhwaoiho/mu9B+lqr0MHwXwX+bECLUAa9Bvqb6LCUPPJID8WzrgKg4bj5HypHBaBvqLF6baC4MgmuXn4AmzRP7rbNuYc5Zm8lj1ebWymIwSg+q71/gqZ94dOmrKX52DiGH0UmfOfUBfMlYk1XEVa09eVjDhQOLaS+cr755G2/Fo0z6yi2fJ1osWjpqlR6Am2n/OUWwyvIn7sL3q4aLEltboAFN8604T+/ZIr9iEOWKMR6lEYYm1mXGzy2Nxbf4zO8IN5pdKh/NmbskOEHZCIj3Z5zO4LREX9FSPdqvNZpyESb1WT6Ug2auFUG3CdZWu7YJh/orMCGSqOGFhGOJmqd3YkWivStKIURlYppLeWtpA+4fI335r9Y2IK0iJoHWxAnF/AtawB65f7ShBeATeP4muG2yZ2w4SVR9ESuYb7wwDNGJ3OZRcaS3hlM/zq2jfB9tPyfgqmkTBAprcepz/d/1LiZZ7hlXiMS38rgn1f2BJCpU10GAgzgJd9JaSyi1gRHCLCm/yAgMVQz1RI5R7zKR1hwxtNbXctOmbJ5fXmNf6I9zEuMb1RE/zsyxLV+1nYl87HJ2GSmg48z1aScjb
 3PFNSEhA
 PeWrM+xIqLkDhWVzobUuGneLJxLiHQ4rmL6WFrMjj4e911+uMnBXqCyh8Nx6rYZlOV5bsqxZqxBflI97OexnWpXyjjoA35pdm44JhslR3are2u8min3U4chI/xFwuVt3Io6h1HKk3M0xJZybVZQXpZMh9hZW485T+hEivNd6+uWckm0moXFkOnWZOBLmCzLn0cM2svquqPTYyzwCUetqFM2qMFTZUr0bAiRAiDGBWf5SI5a8K2J5gDTgexZVfzvrZTmSqQvACsnyENjDfz0WEImcDbu/oJ5ip096dlv8uWX21IJSrrV6+hWxXPcqIjACDrN8c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 06:59:30PM +0200, Michal Hocko wrote:
> On Wed 14-10-26 09:06:00, Shakeel Butt wrote:
> > On Wed, Oct 14, 2026 at 01:39:06PM +0200, Michal Hocko wrote:
> > > On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> > > > Kernel threads and remote chargers use high_work when memory.high is
> > > > exceeded. Their allocations during reclaim can also charge memory,
> > > > for example when zswap stores a page.
> > > > 
> > > > Without a check, the high_work worker can queue itself from its own
> > > > reclaim. The pending bit is cleared before high_work runs, so each run
> > > > can queue another run.
> > > 
> > > What does that mean really? Does this delays the actual run?
> > 
> > It will not delay the actual charge request. This mainly means that we keep
> > enqueing the high reclaim work even from high reclaim context and can
> > potentially keep wasting CPU if high reclaim is not very successful.
> 
> Hmm, so is there any practical problem if we do that? What exactly do you
> mean by "keep wasting CPU"?

More specifically if high_work kworker keeps enqueing high_work, most probably
the memcg does not have reclaimable memory and keep retrying it wastes CPU.

>  
> > > > Skip memory.high enforcement for charges from task context with
> > > > PF_MEMALLOC set when they would use high_work. This covers kernel
> > > > threads and remote charges. The memory is still charged. Interrupt
> > > > charges keep their current path.
> > > > 
> > > > In a VM with incompressible zswap data, the worker queued itself 163 times
> > > > without this check.
> > > > 
> > > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > 
> > > The patch itself looks OK. I am wondering whether we can unify the check
> > > with the existing one which forces the allocation through in main
> > > charging path.
> > 
> > The force charge (and ENOMEM) paths bypass the memory.high enforcement
> > altogether.
> 
> Exactly. Isn't that exactl what we want to achieve here as well?
> 
> > Only successful charges (done_restock label) goes through
> > memory.high enforcement. So, even if we move this check in try_charge_memcg, it
> > will still be a separate check before calling high enforcement function. I think
> > this check is very high_work specific and better to be in the high enforcement
> > function.
> 
> I meant something like the following

Oh ok this makes sense. Do you want to send a patch or should I add this in this
series replacing the 4th patch?

> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 856a7d07586c..832b40ee5b6f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2653,7 +2653,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool passed_oom = false;
>  	unsigned int reclaim_options;
>  	bool drained = false;
> -	bool raised_max_event = false;
>  	unsigned long pflags;
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
>  
> @@ -2661,6 +2660,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (consume_stock(memcg, nr_pages))
>  		return 0;
>  
> +	/*
> +	 * Prevent unbounded recursion when reclaim operations need to
> +	 * allocate memory. This might exceed the limits temporarily,
> +	 * but we prefer facilitating memory reclaim and getting back
> +	 * under the limit over triggering OOM kills in these cases.
> +	 */
> +	if (unlikely(current->flags & PF_MEMALLOC))
> +		goto force;
> +
>  	if (!allow_spinning)
>  		/* Avoid the refill and flush of the older stock */
>  		batch = nr_pages;
> @@ -2683,15 +2691,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto retry;
>  	}
>  
> -	/*
> -	 * Prevent unbounded recursion when reclaim operations need to
> -	 * allocate memory. This might exceed the limits temporarily,
> -	 * but we prefer facilitating memory reclaim and getting back
> -	 * under the limit over triggering OOM kills in these cases.
> -	 */
> -	if (unlikely(current->flags & PF_MEMALLOC))
> -		goto force;
> -
>  	if (unlikely(task_in_memcg_oom(current)))
>  		goto nomem;
>  
> @@ -2712,7 +2711,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto nomem;
>  
>  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -	raised_max_event = true;
>  
>  	psi_memstall_enter(&pflags);
>  	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> @@ -2773,13 +2771,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
>  		return -ENOMEM;
>  force:
> -	/*
> -	 * If the allocation has to be enforced, don't forget to raise
> -	 * a MEMCG_MAX event.
> -	 */
> -	if (!raised_max_event)
> -		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -
>  	/*
>  	 * The allocation either can't fail or will lead to more memory
>  	 * being freed very soon.  Allow memory usage go over the limit
> @@ -2789,6 +2780,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (do_memsw_account())
>  		page_counter_charge(&memcg->memsw, nr_pages);
>  
> +	if (mem_cgroup_margin(memcg))
> +		__memcg_memory_event(memcg, MEMCG_MAX, allow_spinning);
>  	return 0;
>  
>  done_restock:
> 
> -- 
> Michal Hocko
> SUSE Labs

