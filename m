Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15847CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 01:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6B08E0006; Tue, 21 Oct 2025 21:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567A08E0002; Tue, 21 Oct 2025 21:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4678E0006; Tue, 21 Oct 2025 21:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C70C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:28:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0ECB211AB6A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:28:19 +0000 (UTC)
X-FDA: 84024014718.10.38B17C6
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id E5349A0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:28:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gBNL3dOQ;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761096497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbZbIYaArDkWKOuqj+k7VxfsSO/LaVRV6EW0i8CqmOI=;
	b=ukibMeWB+NZNShEWV020mK8KPyNB6TRgjNuV9RKA4ijP78Jvz/jsfCWMt93YWRJAb4XNco
	m/sK346S8/LUBUzGxPEZ0mH8rQB5pf+2iA7+1vay95du2JA9pQMvs+ZKPcc5THP6ewrCL3
	o3yDbkVewFuLyv3wI6RnlVf9xOvtxIw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gBNL3dOQ;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761096497; a=rsa-sha256;
	cv=none;
	b=f+yEaIwF+GOjsOaF4UTG9RNxBL4YgJ+1ZeEgJJAu8u7/0g4YWxzETiFH0Ee/+JCh/KS+0F
	xgunpHyJGYsaDpR3OyMWxEUUt8XxvEFruQm2LmG0wxBdO1zigHxJnCYBU5Mb8yYKFd4WE4
	U4r8uECGN+IqJ3rvQ1lpNCDGsgGS5SQ=
Date: Tue, 21 Oct 2025 18:28:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761096494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cbZbIYaArDkWKOuqj+k7VxfsSO/LaVRV6EW0i8CqmOI=;
	b=gBNL3dOQAR7TzV0Wvx3oL5xWfRBqCvgcdlTkhXXM6WB3p1zSQjOZ5d6mpbXrf9Mamy8tlG
	htlYBhABwh0jdKIY3/hV3Mp+Y0/esz2qacnO0Az2oxEcYKivo+DJ2l3WXF5FD4kUa9/t+O
	rRCR9XWbRsPGDdc+IXNmPV/V7tDUuRM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: manually uninline __memcg_memory_event
Message-ID: <3h26sozqgksxn4fvh7i6qjhtbnrtzit6eluyieyhsvycs3fbs5@ddblsq2crkit>
References: <20251021234425.1885471-1-shakeel.butt@linux.dev>
 <20251022005801.120250-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022005801.120250-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5349A0006
X-Stat-Signature: yqjh8aps8qiyz7dccqjdhmuaoeq5udpe
X-Rspam-User: 
X-HE-Tag: 1761096496-905347
X-HE-Meta: U2FsdGVkX1+7odFPZYLF7Q6ECTBvrh2P20TEHy5tjPovvWhBx9WGboju9WbKwp6dwys5gde1ggtO+Be64T/OsEGuHy71iDErZWQnrBP33CQgBkQXyzLISsHnlsJecFrldiIEn3W68DHnal6pbd3amM/ju7G7AXDHMJMHCZaVpCw6ZDDLQ56LAzEcFA9V7xz+MUu4TCz8JV7tNwqmFhk0OtS8CGeLuu7NmYb4qC5v5rjN2MBz1+XgmdaZ7hUZO5ZmxwKY2n4yeCAlCYpfyDAUP3/HSSgOLrym25QKnrw5lJOoUmV+3cs9OuBVdIUIuSMe9unv4cNMZKP7vHUb5b4VioMnY2Ccmidh6n4OZCVwuac5lrKSggpapXF44ZORp0nyGBRBiL/VrN2lhnXZvHr5YSJBsLbXpMlN59bjsjCH1OUplCW5TXEhn0gQVLCYrv+I5vgSznVxVwb1tsfuMWztmL1evjav/nvJjWLlER9SBXUwq57XraZKH/RflQy0/GYbkpjM4kEQzCFp2c6sfPMq42df7xpFx5VWF2WcqcsAslJCE0MPYF2YbzpGmgytMOUlMzMLZHfMdaPAq72bOkrybHRvHarhAI+6nQ66+nJA9U7swcQWzvyrX4/nDW/tBgkxs04K/Rvv/HqghOBOWCIkTqjQufYAb8fUJWJajM13np92W7zoJWaw5kts0KeOzgSwtowOLMgPotTdb86MrNYqyXahNe2zOfUq7nmIBcwejIYaVbhhNRcXwLO4/a1x/6y9OuNTph55RgC24qogu59+rUJcwqhw9EnAMxQxCcXYA6NMykYmIfD8aeymr8hFXjIvogmEH0iYnWcxChktQ4BNzH45Jg20+BQszFhPc2e3JPsCtTUgvA9Hqrn6TEu18IGgdNZlJhBHNQDE6kHem4/HdnTEkljrsqK9kchVsQfoEOsVKOoH/HfboG8HzxseTdAgw45EetMSvBBHY6IwJE3
 rX8+6Pr7
 B6d0DJxRsSn4Hs8+UYSxNPwHKU/z3TwJtUvQbKv8DIz0apsLrpJcP1IIQ+mz3l5gShdAbM5w3qSTu2b90paIosfu/rMWz/934EHe7V+7WJAoBYNQkWkOP1QCO00i8NPmRfpEh0L31TrmrYdUUmWOJolyAcg7ZNMwgnxFLXVihwdr6o3m4RQw/mLYXDlo1M168klNyWFoa5uoUEWJVo09x6dh8tlINM4NlYAimvoqPI4DpXi5OoYc+n2FzjjJXTfklyKQ6/LUjbsQvEgdDl0t33eyS3F63WXAF/YjI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 05:58:00PM -0700, SeongJae Park wrote:
> On Tue, 21 Oct 2025 16:44:25 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > The function __memcg_memory_event has been unnecessarily marked inline
> > even when it is not really performance critical. It is usually called
> > to track extreme conditions. Over the time, it has evolved to include
> > more functionality and inlining it is causing more harm.
> > 
> > Before the patch:
> > $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
> >    text    data     bss     dec     hex filename
> >   35645   10574    4192   50411    c4eb mm/memcontrol.o
> >   54738    1658       0   56396    dc4c net/ipv4/tcp_input.o
> >   34644    1065       0   35709    8b7d net/ipv4/tcp_output.o
> > 
> > After the patch:
> > $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
> >    text    data     bss     dec     hex filename
> >   35137   10446    4192   49775    c26f mm/memcontrol.o
> >   54322    1562       0   55884    da4c net/ipv4/tcp_input.o
> >   34492    1017       0   35509    8ab5 net/ipv4/tcp_output.o
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  include/linux/memcontrol.h | 32 ++------------------------------
> >  mm/memcontrol.c            | 31 +++++++++++++++++++++++++++++++
> >  2 files changed, 33 insertions(+), 30 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index d37e7c93bb8c..8d2e250535a8 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -1002,36 +1002,8 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
> >  	count_memcg_events_mm(mm, idx, 1);
> >  }
> >  
> > -static inline void __memcg_memory_event(struct mem_cgroup *memcg,
> > -					enum memcg_memory_event event,
> > -					bool allow_spinning)
> > -{
> > -	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
> > -			  event == MEMCG_SWAP_FAIL;
> > -
> > -	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
> > -	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
> > -
> > -	atomic_long_inc(&memcg->memory_events_local[event]);
> > -	if (!swap_event && allow_spinning)
> > -		cgroup_file_notify(&memcg->events_local_file);
> > -
> > -	do {
> > -		atomic_long_inc(&memcg->memory_events[event]);
> > -		if (allow_spinning) {
> > -			if (swap_event)
> > -				cgroup_file_notify(&memcg->swap_events_file);
> > -			else
> > -				cgroup_file_notify(&memcg->events_file);
> > -		}
> > -
> > -		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > -			break;
> > -		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> > -			break;
> > -	} while ((memcg = parent_mem_cgroup(memcg)) &&
> > -		 !mem_cgroup_is_root(memcg));
> > -}
> > +void __memcg_memory_event(struct mem_cgroup *memcg,
> > +			  enum memcg_memory_event event, bool allow_spinning);
> >  
> >  static inline void memcg_memory_event(struct mem_cgroup *memcg,
> >  				      enum memcg_memory_event event)
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1a95049d8b88..93f7c76f0ce9 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1626,6 +1626,37 @@ unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
> >  	return page_counter_read(&memcg->memory);
> >  }
> >  
> > +void __memcg_memory_event(struct mem_cgroup *memcg,
> > +			  enum memcg_memory_event event, bool allow_spinning)
> 
> Seems this function is called only from memcontrol.c.  Why not making it a
> static function?

There is a recent code where this is called (indirectly) from networking
stack for MEMCG_SOCK_THROTTLED.

> 
> > +{
> > +	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
> > +			  event == MEMCG_SWAP_FAIL;
> > +
> > +	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
> > +	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
> > +
> > +	atomic_long_inc(&memcg->memory_events_local[event]);
> > +	if (!swap_event && allow_spinning)
> > +		cgroup_file_notify(&memcg->events_local_file);
> > +
> > +	do {
> > +		atomic_long_inc(&memcg->memory_events[event]);
> > +		if (allow_spinning) {
> > +			if (swap_event)
> > +				cgroup_file_notify(&memcg->swap_events_file);
> > +			else
> > +				cgroup_file_notify(&memcg->events_file);
> > +		}
> > +
> > +		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +			break;
> > +		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> > +			break;
> > +	} while ((memcg = parent_mem_cgroup(memcg)) &&
> > +		 !mem_cgroup_is_root(memcg));
> > +}
> > +EXPORT_SYMBOL(__memcg_memory_event);
> 
> Also, seems there is no reason to export this symbol?

The networking code needs this export.

Thanks for taking a look.

