Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0AB9CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 02:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F249D8E0003; Tue, 21 Oct 2025 22:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC3B8E0002; Tue, 21 Oct 2025 22:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39E38E0003; Tue, 21 Oct 2025 22:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4B498E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 22:15:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7708B5A759
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:15:55 +0000 (UTC)
X-FDA: 84024134670.30.BAF397E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id DC19BA0009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:15:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z9sc0WbR;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761099353; a=rsa-sha256;
	cv=none;
	b=0ZFO0eYDMyqS44zFj0NJo7Bsd4Tev2v7RqFa9LoSPtFA7ZoQ5RSLUjmT/Z4YiuQMw5Yj/Y
	nurRSOnQEgStNHsAOHblfvoRVOhnoSNuzzo5czrQlq5UeZ6PVqOMK98CKwVURfDrO8kcTC
	vbxHC+QlF8js0+BZWL+3B3WKf507y64=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z9sc0WbR;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761099353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFAbcLrFQsd63pDILnMR73sN62PanFgBkD1x9WceHsc=;
	b=xV+XBrQnPCXjXL/7KyOe5PohkqmLJoEUISk/TjQdACCdT4NHFb4x1+32AxFNHLiCSRgUIE
	Vox03P28sX7J7cZu8V5K0+jUUaicNNyBmZr0unWcVvAH6EITYb5E8/QFPsDY0HcdNxKi/A
	eeHe+GzxG675vIo2XysvOVUFC2ezDq8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 36B9160322;
	Wed, 22 Oct 2025 02:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA5EC4CEF1;
	Wed, 22 Oct 2025 02:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761099352;
	bh=K8KyPpuWFb8QcJ7XXOwUi5j8hUUNg/w4R0Rxk5mqPqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9sc0WbR5vWlhZcCkAalZUcE8a6choXCT7cZiw3CKT+J/5fC9T7v5u8AnSqXnYbsV
	 P7P2b6ik+JssEgaNDkNe2XnMW4PsoELzAWa2A70O8bYwKlVoCYveujBcfn2DN4GtuH
	 MtHpRjUE6qp40ZhvgbtLft0TF6MRQ4LrPNFHLLcWBElzO1sWuP5sZDzcxyqfyB6kKd
	 elTIYyj9yvVuubI/W/MSif1lULq9VXO5m4e9ogOmWMceGRX4NKD8H9fwlcT7ds2NBq
	 W+tjZ3+hUcvB8bsnj7q6LbFpYZppFs72qrTfn98svYFY45qzgLUFnjHr+RByRQO4aA
	 r1dgolbERzVsQ==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: manually uninline __memcg_memory_event
Date: Tue, 21 Oct 2025 19:15:49 -0700
Message-ID: <20251022021549.129413-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3h26sozqgksxn4fvh7i6qjhtbnrtzit6eluyieyhsvycs3fbs5@ddblsq2crkit>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: i67pe5gz8fr9dqzijk1fujuc8xpzi5ti
X-Rspamd-Queue-Id: DC19BA0009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761099353-73050
X-HE-Meta: U2FsdGVkX19kqBOkopfJBe88lX57sNZPwFh8frVNpjYmQSLHxzXFnLWk0Tpk80h6EycA4k66Gi8CA6KpXiEI5T5sjna0OsyMLMG6PG+W8BYa8Uv3ASUGG4K0WG8uTLJXjHxN2V0CUZ/4JejPfWZ0lM/W/9JD69bn6ZcAYkrHQ85XSxzerHdgCFSmoSmDyoQg1zzjJ36rqxeXOkZce9b1rIbaYfzHV8VAIhuhT4WRxKEWued3pMR4TUffLE/zQdq97jHccL94m/uslvEuusW+YrYTRZPiB6xctSjfa9Oxd99M6p56ZdD7Phel+jy9Jh/LrIjPiySTkJ6eV6rn9Vb98a2/cjb22IfQTdv8KSU6ObDlCkuaIvgFSabC1i1uGQiax4idPEtccppg0ukpN9GYL4C8fxP39tZPg9vZTXgFY6SpvyQNy4yLVtW0VZRBwUfokUoKQo1mM7ubbkcvpXWAuHssztWzVCPhDxDmx7DRfShCGGSxBW5egE8XOlNHS4zEM1EGLmlf7itVI4chyXu0grSf55wo/Lq6+ss8sjzWZ/jTEAzvX43hax7ex6IHlEmcsDgKsNz312qKPFlVMwfXreYmdmcP1D5W4AEIDrp7mi6rjNjOce+23D5D+hzfPiRIU3LcM3eWv65GjFHGUmfjoRgyajVNEabTnWvywrjkSkdp1lGSzKMXdj0aiw9zc3N3IjIF9k8fb+V9DsacSPWS25d0RV34OBTHoRgB18xTWzfdmK3uKXJNGb89NCEtES2c+q+mmDejy+k9w0dv64yXLhpjK+G7PQUJ3VT7+g0kPij7oaJ3BIrhZ6dv3oS24U4SINPAXVjdp3IYwZLA5miewbv4tpODIYd4kWiHO4QZsMFFRn5W0X6tI6HE4yxiKdnctyIBdkRsJ67JVLh7zArsNRMJ46gmfyQRUohhRory91ve7Di18qaJdaBEDWtYLWLe963a65E6x5QYOmez2hy
 WM1QQtj8
 wO19B3ziMDvX0A8jDskteNOaFJ3yCd8v0JTGRRgKmcceYsVixAz6d9hjjz3rQxQ9uZQZ1HckV/x+dK4lnOXouJiehEU1tB7yT5aSbA6r4XmRzEawN8iHihGWCwiizwpI0YNH2AUPZPNSxj8x+WWXbGdroGuAYgExfJh79CyP+gK9CKYajdZftpAeGApDdQE/vj4E9rd5x1OfY5f799rNMnPKQSyEAHPvbyvc7eEObmBZAYDJr72+N9EUe2vPJxEcLCgWEw24UEFXO/ZeL06OKepsPhw1R5elPTwwfA93xbQSRXL67t4VWojLv2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 18:28:02 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Tue, Oct 21, 2025 at 05:58:00PM -0700, SeongJae Park wrote:
> > On Tue, 21 Oct 2025 16:44:25 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
> > > The function __memcg_memory_event has been unnecessarily marked inline
> > > even when it is not really performance critical. It is usually called
> > > to track extreme conditions. Over the time, it has evolved to include
> > > more functionality and inlining it is causing more harm.
> > > 
> > > Before the patch:
> > > $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
> > >    text    data     bss     dec     hex filename
> > >   35645   10574    4192   50411    c4eb mm/memcontrol.o
> > >   54738    1658       0   56396    dc4c net/ipv4/tcp_input.o
> > >   34644    1065       0   35709    8b7d net/ipv4/tcp_output.o
> > > 
> > > After the patch:
> > > $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
> > >    text    data     bss     dec     hex filename
> > >   35137   10446    4192   49775    c26f mm/memcontrol.o
> > >   54322    1562       0   55884    da4c net/ipv4/tcp_input.o
> > >   34492    1017       0   35509    8ab5 net/ipv4/tcp_output.o
> > > 
> > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > ---
> > >  include/linux/memcontrol.h | 32 ++------------------------------
> > >  mm/memcontrol.c            | 31 +++++++++++++++++++++++++++++++
> > >  2 files changed, 33 insertions(+), 30 deletions(-)
> > > 
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index d37e7c93bb8c..8d2e250535a8 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -1002,36 +1002,8 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
> > >  	count_memcg_events_mm(mm, idx, 1);
> > >  }
> > >  
> > > -static inline void __memcg_memory_event(struct mem_cgroup *memcg,
> > > -					enum memcg_memory_event event,
> > > -					bool allow_spinning)
> > > -{
> > > -	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
> > > -			  event == MEMCG_SWAP_FAIL;
> > > -
> > > -	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
> > > -	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
> > > -
> > > -	atomic_long_inc(&memcg->memory_events_local[event]);
> > > -	if (!swap_event && allow_spinning)
> > > -		cgroup_file_notify(&memcg->events_local_file);
> > > -
> > > -	do {
> > > -		atomic_long_inc(&memcg->memory_events[event]);
> > > -		if (allow_spinning) {
> > > -			if (swap_event)
> > > -				cgroup_file_notify(&memcg->swap_events_file);
> > > -			else
> > > -				cgroup_file_notify(&memcg->events_file);
> > > -		}
> > > -
> > > -		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > > -			break;
> > > -		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> > > -			break;
> > > -	} while ((memcg = parent_mem_cgroup(memcg)) &&
> > > -		 !mem_cgroup_is_root(memcg));
> > > -}
> > > +void __memcg_memory_event(struct mem_cgroup *memcg,
> > > +			  enum memcg_memory_event event, bool allow_spinning);
> > >  
> > >  static inline void memcg_memory_event(struct mem_cgroup *memcg,
> > >  				      enum memcg_memory_event event)
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 1a95049d8b88..93f7c76f0ce9 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -1626,6 +1626,37 @@ unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
> > >  	return page_counter_read(&memcg->memory);
> > >  }
> > >  
> > > +void __memcg_memory_event(struct mem_cgroup *memcg,
> > > +			  enum memcg_memory_event event, bool allow_spinning)
> > 
> > Seems this function is called only from memcontrol.c.  Why not making it a
> > static function?
> 
> There is a recent code where this is called (indirectly) from networking
> stack for MEMCG_SOCK_THROTTLED.

Thank you for enlightening me.  Apparently the code is from
https://lore.kernel.org/20251016161035.86161-1-shakeel.butt@linux.dev.

> 
> > 
> > > +{
> > > +	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
> > > +			  event == MEMCG_SWAP_FAIL;
> > > +
> > > +	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
> > > +	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
> > > +
> > > +	atomic_long_inc(&memcg->memory_events_local[event]);
> > > +	if (!swap_event && allow_spinning)
> > > +		cgroup_file_notify(&memcg->events_local_file);
> > > +
> > > +	do {
> > > +		atomic_long_inc(&memcg->memory_events[event]);
> > > +		if (allow_spinning) {
> > > +			if (swap_event)
> > > +				cgroup_file_notify(&memcg->swap_events_file);
> > > +			else
> > > +				cgroup_file_notify(&memcg->events_file);
> > > +		}
> > > +
> > > +		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > > +			break;
> > > +		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> > > +			break;
> > > +	} while ((memcg = parent_mem_cgroup(memcg)) &&
> > > +		 !mem_cgroup_is_root(memcg));
> > > +}
> > > +EXPORT_SYMBOL(__memcg_memory_event);
> > 
> > Also, seems there is no reason to export this symbol?
> 
> The networking code needs this export.
> 
> Thanks for taking a look.

Again, thank you for clarifying.

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

