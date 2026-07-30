Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DFFC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 04:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB766B0088; Thu, 30 Jul 2026 00:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AAF06B008A; Thu, 30 Jul 2026 00:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2546B008C; Thu, 30 Jul 2026 00:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3905C6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:37:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B75A71608C3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:37:18 +0000 (UTC)
X-FDA: 85044183756.14.94CA378
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id C2D6A1C0002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:37:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aLag2t32;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785386237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jt+GOWxdRbvsR3onEzesDNIgXdjOGzHQPiH/YZFcDak=;
	b=HvWjiOREXmvtZytdFANqyT53fScAHqkpEH6IqfsTry5C/K+RDSsE1LB4m7ap3y9+7q3m4k
	gCWSG+czCY2EPC7TlD0HHnVfrAwdEo3ydRPju0FLG8NfpG56p210aovbJseFfDgF+4SsFb
	rdxNSbFjZkuviBQHebH/uTj/cVd7Fig=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aLag2t32;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785386237;
	b=hhU4rPp1VDEAquFpjlAhivffJj8omxFoUA7p3ulsCjbabek5mYZ2GcelI8OI0uOqshu5QZ
	IXh1M85oIP5je0HFfzW8SFuC3WI1AFX44Mo22K6V0NB2UmbxrHR0YkXwSZNKlbYDBhnK8U
	4o3aawZYXhfkvrMkNRFXycaXbjAD+Cc=
Date: Wed, 29 Jul 2026 21:37:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785386234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jt+GOWxdRbvsR3onEzesDNIgXdjOGzHQPiH/YZFcDak=;
	b=aLag2t32vo0HfGP+4yMkIaDPGDwCBapLHur4aYP5Nt1ZKrQjTIqeEcs8OQeP5zD+rYiZL5
	daMZ14jAhD8xRyrlmKNkle9b7uCgKjSB0rEktoDzU8GFT7zv+T7WQUEu3b0xZ0ymfU3Zy2
	prKvb0ifiK/Vg7kjbGCDrxeVufDzBcY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Rik van Riel <riel@surriel.com>, Nhat Pham <nphamcs@gmail.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: bypass the reclaim and oom killer for dying tasks
 once oom_reaper is done
Message-ID: <amrUQZDNNJMdl_aP@linux.dev>
References: <20260729024612.3369005-1-shakeel.butt@linux.dev>
 <20260729181349.fd41f1a09ec19c9cfb0c412f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729181349.fd41f1a09ec19c9cfb0c412f@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C2D6A1C0002
X-Rspam-User: 
X-Stat-Signature: tcxwq3dgdq7sk5yxmjkthdxkb4pnwdwq
X-HE-Tag: 1785386236-87774
X-HE-Meta: U2FsdGVkX18boB/lhXCyvAEPPiuj/ATYg8vkbGV9q0FzuE6QwyYSOl4wGOkgdMRI4iJuEiArSOEnsYqh+4Ljk3hhS563Zsoh7Y97LKPAxHrbfOHFxbDyJuep38CIvx5tZBWGnvCv1MLmewbUsbrS35St7Sy2Dn74m6OTCI+jjBDnkTkmCMLaqY1z3FHAKnP5kiMsQQBmIUFwboUhuVPXNZn2I+EapkUYvl9V8LQ+cx8gIpu5GnDAZbhViI+CNzFeQrgMkGYpJ3H7tMeWNQbH9Fou4fQuOIx45kuf0i/j1EB+mva7r+nr30h+HebcMI+ObU+HSJd/KaIl+HjY0ZLy9WgYFMy7ddpd5ZnKznuiOYrQpsTmvoSvE20YQyD/z79VsIg2otqRWWj7Xp8Vj2Gs9NDkt1eSxShJAIizrS2GV12LWO3Dxkceg+n5Vg3Rt2uiCHmnJBmOCzz6Wg5MCZauqudugbIbG3zbW3xPqBxuXgb+XB8+NGFum+KyPGMWzAz5CohqcK0OPyPhydoGGMCLUlF6QQyM/5H5gZMNJr4zq6mibEXkJ17f3mT16dnjtSEo3xh2Q4pDsvMk5QQpQYxTeC2Bx50GhHiTPs7VWMW3ge7On19d4OgY06GmhIg2aNc6cPb3SLHXnEztnRlppnJfvAX4poLpFVE6cepk7jLW2HjD2gIMRUBvbFGPHaQxXcuU1w0CbMX8CHOTAddhZVJl1zqTMD/nHL4Fdlo+Jch+OzsggRpdaTVFdRbAa/WgZRe33CKOoAn7kR6PQn+LayIVGWl1vs8lBUKDm1pxHZiE5509XBaifk42vT77/Cr1/Tw1eseLNIyP77P7geTubASB04S4+gPZgmTO2NZq0xAsgzHUBq07+pKaJ54kRvZEro2vELU9CQmSkxrXBezd8aeJ69EnTSrusO8InWlxb5tmWaxR9XoKcmQtqSj7GyMPGVhuPTzHup/Y47/gSYO3Agh
 k4esMkmh
 Ypqg1Ks/IDBujGM5rdBAwRR1mlfJVAqyOjXPYOTSEJQCEV/FNd+weUu0Z7MiIWAhIZNNwosYrRncCJfvP1TV9A9OP1AV5blevMtP0u8+BE2cIFBEZg0p81Z48u9xfLuw4oiAhCJn/8KYPDkwBPopA243rldi96OTfanQi4I7xXQJ1Tb34ZuNtb1S0QI4OKEUNb9lXUCOjqyZgNRIsfAG34U7GUjCx3YIBZ8uTIsjtvYR8BsUE/MywrmrWslS1U+4jjxA/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 06:13:49PM -0700, Andrew Morton wrote:
> On Tue, 28 Jul 2026 19:46:12 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > At Meta, we are seeing instances where an OOM killed job is stuck in the
> > exit path for several hours. In one particular case, the job was stuck
> > for more than 8 hours and I had to manually remove the memory.max limits
> > to allow the process to exit.
> 
> Not seeing the problem here - that sounds like normal kernel behavior ;)
> 
> > Reproduced with 20k threads, each parking a robust futex head on
> > its own zswapped page, OOM-group-killed while a sibling holds mmap_lock
> > for write so the reaper gives up and sets MMF_OOM_SKIP. Tested on
> > next-20260728 and baseline show ~90 seconds exit time while with the
> > patch the exit time reduced to ~3 seconds.
> 
> Very positive.
> 
> But it doesn't sound like you're fully confident that the problem is
> fully solved?

Yes as I am not able to reproduce multi hour stall, so I might be missing
something else. The patch at least fixes the issue which I am able to reproduce.

> 
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2653,6 +2653,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	if (!gfpflags_allow_blocking(gfp_mask))
> >  		goto nomem;
> >  
> > +	/*
> > +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> > +	 * help but it might fail on mmap_lock contention. If the victim is a
> > +	 * large thread group then all exiting threads might compete on oom_lock
> > +	 * just to learn that there is nothing really killable anymore. Bail
> > +	 * out early and fail the charge to expedite their exit. They are
> > +	 * considered fully reclaimed by the oom reaper and they shouldn't
> > +	 * contribute further charges.
> > +	 */
> > +	if (tsk_is_oom_victim(current) &&
> > +	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
> > +		goto nomem;
> > +
> >  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> >  	raised_max_event = true;
> 
> Should we backport this?

I don't have any strong opinion. I wanted to deploy this patch in Meta fleet to
get some exposure. Maybe backporting will give more exposure to it.

