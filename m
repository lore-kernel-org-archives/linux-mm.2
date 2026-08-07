Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E0BC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E4F6B008A; Fri,  7 Aug 2026 05:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F086B0092; Fri,  7 Aug 2026 05:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41166B0093; Fri,  7 Aug 2026 05:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C75716B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:18:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EAAEA1CA1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:18:00 +0000 (UTC)
X-FDA: 85073921520.16.6C0A81C
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 68F54180008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:17:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="fn7o/Br1";
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786094278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nE9EpAT+paxZNLOvuqRoG+/4E3IKgvzJcMoz26cdk1M=;
	b=lfvOcw7kvlb4KmTK20Vly8JPJJjUEymnoW2hQW1bWN2WccZIXRV6xv0FRBJ/lV70NkePlV
	OjD8Yuz20DF7yNt7+qEXsp2n4sWOSI100UmH0UPveanVr9pXTS5Ff98zOrsIE/vPdOUIyb
	4QxyIsOE+MD5v5EwMpqF+v5QmKp/7RI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786094278;
	b=Mxs22nx8Nvo4lKS9T+tQ+tbLEulHDCBEDt9ggITULxFOERr704GquS+Q5hmd9x0U05NrW1
	WUbpNPYCu5tM7rRvH664bHS5Qjolyna03xNEExVE3KnqT/etuot4zE0Ct0lirW0U4pjLX0
	fL8j+ObHTSKJQ7Yfl6UY4lvLqr51cCI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="fn7o/Br1";
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-496b7622a83so26355115e9.2
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 02:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786094277; x=1786699077; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nE9EpAT+paxZNLOvuqRoG+/4E3IKgvzJcMoz26cdk1M=;
        b=fn7o/Br1Ca6gWaR6zFeDeCs/RfNj/r6kH97x7ZmBM/azqXf5IUgJOdmIKnJOL2LYbY
         nFC8FMMrkmsyLQMXwGXFTvqIW1euQuGB2LljOY57fCXCavEX9+is7LhVN8jFhphNAeGw
         wLktlZRLzHHyINN7CkRm74yqLW8aooK1Ierlobeej65zqBfqabAtFwhyN6s7EFc4mU5F
         CkaG1l18O1xkYNGi+jpPvSfUARcGT2P01RNE1C/ca46YXLpA3C1nBkM4mFLuxy/JRb6n
         zVymBXB/3hfA7ujFmPW35RUYb4efw+MrwSrOQjf2gdEXbufuNDIH3q8HidQDeD7M3D5A
         4tzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786094277; x=1786699077;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nE9EpAT+paxZNLOvuqRoG+/4E3IKgvzJcMoz26cdk1M=;
        b=sR1QJvd8wpaNDj6TsuxLBZv+W5m+jFTdq/tHwip41kTfrlpfge4ml/EUjyhmnMkX0n
         PMz1vqvoCdQYYQ4h4zsN9y1MGu2fC5uwETrjNSzwBLOj0ooEvJeqyNwEpWxVw+D5V0Vc
         UCgp2EuqM8+B4TuDBTCj191zueR3TIJX/LN06/zXLMnzStvcl50gIjxJlSw1jqFCk+P6
         mQymaNFwm2qM9FespxllBR/e3l5ZcuDPVbIFVjetyudcAdCIEIU3sFfox6idmS0j9zLH
         OcLYerN+8eBE7r42tZikboapaGtZa4hjCmNlnjnEIHegnFi1v4x+xMY6QlMljrXJAo9w
         67xQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq7cNgbS28tooHkFmIImp3lqtFzTdBySiCbb4wUuYfRbEbWL1eHLxI7j/WZ9EYrCCt8niqX/1p92A==@kvack.org
X-Gm-Message-State: AOJu0YwNDTtSTFOxRHdFOeSWnxw3tLJfjAQrKpH6AdNAgWEcMXweYg4h
	VZKqT0ByZp5OWizA6JIerTbsh60/BNHa525h4E9Sk3pvt/pfHHEJ+Y8c9Ccx5lVCbVg=
X-Gm-Gg: AR+sD10HhCHYJIVsQe73Y4X0ITJSBv1BdXrPzHA/RTi1VQPNZpHEb3l8LzqbflCcBws
	vVbbRFVFSkk3F8xctqHxFu5ilrFYNOc38XHYnT0CW6USR0z2S8Qrp8hATsdATrcjk07RDsvk3jw
	C6+vgtdnE315haMJQI2Z5VKqDpGK5r5Spn8KVvELeMe/7Tw+bDqcWcPWl6Z2o5KsllXPzp0C1vU
	Usox8VAgErRexPks3LgfQwL6Bmm3RXNDbekHSfqMzvr/beUTRn7Ff4Laq8pTBLcwAZXSWFqvRhx
	LfmUptrTz+SBzkOAtzBLy51VUSjXH5jfzflO8b2G6D5uPOqjeVRzCUDulKSL8EstgZXrrENYCRV
	WkLth6iOMHs8vMgwk+Kin7Ql349f2XneKPpG880YNBPm8aE+wz+E0NZbz6jMKWdIU6aeS6CxO0I
	ltRQ2xTwuvpSRUrFvaswK1Zgwa+rgTzfkvgksHJhWeK53F1syZGGTKIDHbhgIEIUMnNF2YZqY1X
	cc=
X-Received: by 2002:a05:600c:3586:b0:499:49f3:77b1 with SMTP id 5b1f17b1804b1-4994e728283mr284725245e9.3.1786094276825;
        Fri, 07 Aug 2026 02:17:56 -0700 (PDT)
Received: from localhost (109-81-83-166.rct.o2.cz. [109.81.83.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800215078asm3937193f8f.12.2026.08.07.02.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 02:17:56 -0700 (PDT)
Date: Fri, 7 Aug 2026 11:17:55 +0200
From: Michal Hocko <mhocko@suse.com>
To: Audra Mitchell <audra@redhat.com>
Cc: david@kernel.org, jocolema@redhat.com, raquini@redhat.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unbounded loop within try_charge_memcg
Message-ID: <anWiw0Zb66jyhzBU@tiehlicka>
References: <20260806182429.1841095-1-audra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806182429.1841095-1-audra@redhat.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68F54180008
X-Stat-Signature: goijmat6yru96osgqmjotzigix4sjutj
X-Rspam-User: 
X-HE-Tag: 1786094278-819224
X-HE-Meta: U2FsdGVkX1+KmcZ2iIjAQubUkAjhN1tELWhzFpsGxwb+xEvmP8FVLsXz+a5xSSnYIwL8sxpjfCr1gmVz5tzb7G/NTV05PVXqlxQjo1mg22/mBYncdO7jCxPfLR5Ltpeo5kaZ69FBEcII7QJFTw03if27TcTXMqWJ4yua4fr4/+vNQAgrThasfUZFQtnmQWgj1bq0rE7HQchamcnHVCJ4b4sAE69mQItAhYqyeRL9baK0o4Pzbnb5lZ/aThFO/QY1Un8uua4pav6D349o2q51kGYhm14lIpARwDHKx0CMU+R/1yUJwS/bOlwwYJxLStP/SbAmzpife5T8M6p1EfcSxs7DgF+fy6w1PdGZkqjfekSZbGmDiuHXlk7wNMioQ8KbImor3rN1qZp37QKlxUS29CRfQV2UaG4B+Ai9UorrupEdG1bhqzQP70QXZwtpo7KNlMeLIsUXToo2Y2nRRIGVS8ZpxEu0unHx2/Xg4SEAZOhTuxTG/rwU3C1mM7UCSE1PDQ/+2kvNRscR0b/aTmKi+2ZoT55FBS/QQg/lyOtVxGqsTdfYf4c8iwlrTPiiZAYhZMGLb54AvlpHYjqYCzUnLyWGZmr0IVcz+sZjUUj94zQ7euSYdZHZwpT5FnMQzSBTyFod3QqQzk8tR3CFb8ZlRoydFw4XdwjL0y5e9cPfzi1gHY7AMYSvEEsHiXyO8Fp4Hy+7x6Rz3M74PaWBOttvcXg4MWAitJYqa1JfyUOAxPUKZbKB4STLsQeFreGfWPgmyCADZwtx58aLvO14vJmyaNkWVXRa8rH7AvN9kJEDSwOU/A7LdHANpw0PTMWVDJME5T0uAvOg+Ekk8cHJVCn+MT05NvpJRsPq9w2llrlz1J+pUS/a5fRkp7lOVhnUYnGLCsJohljQb8SM8haR1LSpqMUHsDBYGJthdGhXOSSSv+nKmZCuJ/jXr+dFklTPngu83qf++4i9naIANGO6/RR
 smEEZYFY
 8c+f7rutEpAUaLL/1NOkzKzF2aF5UR7JuAIG2UhUZCjNR6EF+rODOkYTsULsuguvGNBqKKp2sbYGs6d8nyVw4fPyZIWM9Q/SqsQlRgGd01gdAa0WaUrHRsNK8Th9BKSViX3x3lxAcKFAe7TOJFZm1K+Kb9t/x6186ueEP632MFpVoDu+nhjUV//BUDkPHaHoOSSHilTcknMoa7EutagTwvJ3M02uEvkfjfCxMnw65SYcznaDKewQer297pjlT/RiGJuuM1nUpeQzTTbyROMSdrO4Mbwh1WmjLgtucwED7dIWolkoWSGic27m6u+t4hpqe5okqzli0+hDcJQX8kU7g5EjAgPFo1kSPribvLR17A8ZDXW3gLgh1euqGwAwsEYRZmuO2SkkqCpLxSXVeLUGedzZP5UraL+FWyDu5P3qAOpDitRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 06-08-26 14:24:28, Audra Mitchell wrote:
> Originally nr_retries was actually nr_oom_retries and we used it to track (and
> limit) the number of times we entered the mem_cgroup_oom path and then attempted
> a retry. The purpose of nr_retries counter changed with the introduction of
> 9b1306192d33 ("mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL
> charges") so that the oom-disabled and __GFP_NOFAIL charges would also continue
> to retry within the desired nr_retries threshold. Later d977aa939fca
> ("mm, memcg: unify reclaim retry limits with page allocator") changed the
> nr_retries counter from 5 to 16.
> 
> As the function has evolved we now have multiple paths that have a goto retry
> path and we have lost the original purpose of the nr_retries counter, allowing
> us to take a goto retry path an unbounded number of times.
> 
> Fix the unbounded retries by nesting the code in a loop and decrementing the
> nr_retries counter correctly.

Are you trying to fix a theoretical problem spotted by the code review
or is there any actual problem that you are trying to fix?

> 
> Signed-off-by: Audra Mitchell <audra@redhat.com>
> ---
>  mm/memcontrol.c | 153 ++++++++++++++++++++++++------------------------
>  1 file changed, 76 insertions(+), 77 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..781bcced5848 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2607,98 +2607,97 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	unsigned long pflags;
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
>  
> -retry:
> -	if (consume_stock(memcg, nr_pages))
> -		return 0;
> +	for (; nr_retries >= 0; nr_retries--) {
>  
> -	if (!allow_spinning)
> -		/* Avoid the refill and flush of the older stock */
> -		batch = nr_pages;
> +		if (consume_stock(memcg, nr_pages))
> +			return 0;
>  
> -	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> -	if (!do_memsw_account() ||
> -	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
> -		if (page_counter_try_charge(&memcg->memory, batch, &counter))
> -			goto done_restock;
> -		if (do_memsw_account())
> -			page_counter_uncharge(&memcg->memsw, batch);
> -		mem_over_limit = mem_cgroup_from_counter(counter, memory);
> -	} else {
> -		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
> -		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
> -	}
> +		if (!allow_spinning)
> +			/* Avoid the refill and flush of the older stock */
> +			batch = nr_pages;
>  
> -	if (batch > nr_pages) {
> -		batch = nr_pages;
> -		goto retry;
> -	}
> +		reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> +		if (!do_memsw_account() ||
> +		    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
> +			if (page_counter_try_charge(&memcg->memory, batch, &counter))
> +				goto done_restock;
> +			if (do_memsw_account())
> +				page_counter_uncharge(&memcg->memsw, batch);
> +			mem_over_limit = mem_cgroup_from_counter(counter, memory);
> +		} else {
> +			mem_over_limit = mem_cgroup_from_counter(counter, memsw);
> +			reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
> +		}
>  
> -	/*
> -	 * Prevent unbounded recursion when reclaim operations need to
> -	 * allocate memory. This might exceed the limits temporarily,
> -	 * but we prefer facilitating memory reclaim and getting back
> -	 * under the limit over triggering OOM kills in these cases.
> -	 */
> -	if (unlikely(current->flags & PF_MEMALLOC))
> -		goto force;
> +		if (batch > nr_pages) {
> +			batch = nr_pages;
> +			continue;
> +		}
>  
> -	if (unlikely(task_in_memcg_oom(current)))
> -		goto nomem;
> +		/*
> +		 * Prevent unbounded recursion when reclaim operations need to
> +		 * allocate memory. This might exceed the limits temporarily,
> +		 * but we prefer facilitating memory reclaim and getting back
> +		 * under the limit over triggering OOM kills in these cases.
> +		 */
> +		if (unlikely(current->flags & PF_MEMALLOC))
> +			goto force;
>  
> -	if (!gfpflags_allow_blocking(gfp_mask))
> -		goto nomem;
> +		if (unlikely(task_in_memcg_oom(current)))
> +			goto nomem;
>  
> -	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> -	raised_max_event = true;
> +		if (!gfpflags_allow_blocking(gfp_mask))
> +			goto nomem;
>  
> -	psi_memstall_enter(&pflags);
> -	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> -						    gfp_mask, reclaim_options, NULL);
> -	psi_memstall_leave(&pflags);
> +		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> +		raised_max_event = true;
>  
> -	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
> -		goto retry;
> +		psi_memstall_enter(&pflags);
> +		nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> +						    gfp_mask, reclaim_options, NULL);
> +		psi_memstall_leave(&pflags);
>  
> -	if (!drained) {
> -		drain_all_stock(mem_over_limit);
> -		drained = true;
> -		goto retry;
> -	}
> +		if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
> +			continue;
>  
> -	if (gfp_mask & __GFP_NORETRY)
> -		goto nomem;
> -	/*
> -	 * Even though the limit is exceeded at this point, reclaim
> -	 * may have been able to free some pages.  Retry the charge
> -	 * before killing the task.
> -	 *
> -	 * Only for regular pages, though: huge pages are rather
> -	 * unlikely to succeed so close to the limit, and we fall back
> -	 * to regular pages anyway in case of failure.
> -	 */
> -	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
> -		goto retry;
> +		if (!drained) {
> +			drain_all_stock(mem_over_limit);
> +			drained = true;
> +			continue;
> +		}
>  
> -	if (nr_retries--)
> -		goto retry;
> +		if (gfp_mask & __GFP_NORETRY)
> +			goto nomem;
> +		/*
> +		 * Even though the limit is exceeded at this point, reclaim
> +		 * may have been able to free some pages.  Retry the charge
> +		 * before killing the task.
> +		 *
> +		 * Only for regular pages, though: huge pages are rather
> +		 * unlikely to succeed so close to the limit, and we fall back
> +		 * to regular pages anyway in case of failure.
> +		 */
> +		if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
> +			continue;
>  
> -	if (gfp_mask & __GFP_RETRY_MAYFAIL)
> -		goto nomem;
> +		if (gfp_mask & __GFP_RETRY_MAYFAIL)
> +			goto nomem;
>  
> -	/* Avoid endless loop for tasks bypassed by the oom killer */
> -	if (passed_oom && task_is_dying())
> -		goto nomem;
> +		/* Avoid endless loop for tasks bypassed by the oom killer */
> +		if (passed_oom && task_is_dying())
> +			goto nomem;
>  
> -	/*
> -	 * keep retrying as long as the memcg oom killer is able to make
> -	 * a forward progress or bypass the charge if the oom killer
> -	 * couldn't make any progress.
> -	 */
> -	if (mem_cgroup_oom(mem_over_limit, gfp_mask,
> -			   get_order(nr_pages * PAGE_SIZE))) {
> -		passed_oom = true;
> -		nr_retries = MAX_RECLAIM_RETRIES;
> -		goto retry;
> +		/*
> +		 * keep retrying as long as the memcg oom killer is able to make
> +		 * a forward progress or bypass the charge if the oom killer
> +		 * couldn't make any progress.
> +		 */
> +		if (mem_cgroup_oom(mem_over_limit, gfp_mask,
> +				   get_order(nr_pages * PAGE_SIZE))) {
> +			passed_oom = true;
> +			nr_retries = MAX_RECLAIM_RETRIES;
> +			continue;
> +		}
>  	}
>  nomem:
>  	/*
> -- 
> 2.52.0
> 

-- 
Michal Hocko
SUSE Labs

