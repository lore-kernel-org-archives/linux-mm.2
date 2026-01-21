Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D05C44528
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462466B0005; Wed, 21 Jan 2026 07:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42CA96B0088; Wed, 21 Jan 2026 07:52:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365F36B0089; Wed, 21 Jan 2026 07:52:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20FA06B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:52:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD39888E97
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:52:32 +0000 (UTC)
X-FDA: 84355959744.20.E303433
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf13.hostedemail.com (Postfix) with ESMTP id E2E0D2000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:52:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PCyoJaHp;
	spf=pass (imf13.hostedemail.com: domain of zhao1.liu@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768999950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpkD0z4M68ZfTMWJgSMbZuMpf1IUusaTld3FCOXfu8U=;
	b=lBL8CNZKBYOb2IOH6TpW++enmweDOPzwRjLhQPXhXXZNuBOg4Lq7R7u1+/p5Vto1TYEEOu
	vjm2mXlwc1i9CnnZBP7uywbv7ftjfzTLmYPAUFVDYs7qYApfdVFf7c6jx7KkDMZ3iOH6yE
	DNGY4A2x6Dzs7caGrTZN/It5pucHELQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PCyoJaHp;
	spf=pass (imf13.hostedemail.com: domain of zhao1.liu@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768999950; a=rsa-sha256;
	cv=none;
	b=i7SkljzJpmVA3zVhwGYDyiZoXVji5gp6NFPFKuaz3lWPirAtnUID2KjceVVw4K4c+yhapA
	V/v9aFTrhu3qsQSTCsQSlmWpl+pM4tlTUWPZMxwuHstdbANSgtTXVCnL2Qgvaud7QQOg2I
	8hJ2YpwSR5OzAeH2nf2bREsxGMYMcLM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768999950; x=1800535950;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=93qVCOReLolQAzWDuV7FilpZk3VhIeJNRhIl5LgLvD4=;
  b=PCyoJaHphTecEciAzMcluqsOHPRsGmHGH2yEFEG+ioFt92Fei+OVthUt
   iIbFCGG+gBKEzs8BtI7mKpjGXHDIexVjVC+VtfJ3Raf5VFRAT82+a/8p4
   oM3deUou5QCWBZSbDvoyF5/6J9AvmPd654/GpeHf7LDG+6CmshEf6kVDS
   8XwAo7C3sP12sNM8g5mOIe8v4j5MGzPR0rIwe5l+XysTgco+X/NRj2KEg
   ZqTdcIHCB+QORvRG6Tm6Y4Mw4ZpwYJIz33pgOb6tF/b5bDRDTotbBohCm
   C4nc5Yp5sgL6VRl5Kp2TDSJ63abcDG930hYRDaWIRS9l7MVN8BAv8Sih3
   w==;
X-CSE-ConnectionGUID: vQt7DM/sTk+5Vy1XcPqcJw==
X-CSE-MsgGUID: p3HEtlzuSb2flr6iJQQiNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="69242543"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="69242543"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 04:52:28 -0800
X-CSE-ConnectionGUID: 7urcOYczRA2ACdjtwuqQDA==
X-CSE-MsgGUID: uG1TQmSuTnyH84e42KJ33w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206506618"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 21 Jan 2026 04:52:25 -0800
Date: Wed, 21 Jan 2026 21:17:56 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Hao Li <haolee.swjtu@gmail.com>,
	akpm@linux-foundation.org, harry.yoo@oracle.com, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, tim.c.chen@intel.com,
	yu.c.chen@intel.com
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <aXDSBD09n7jYAX9i@intel.com>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
 <aWi9nAbIkTfYFoMM@intel.com>
 <3ozekmmsscrarwoa7vcytwjn5rxsiyxjrcsirlu3bhmlwtdxzn@s7a6rcxnqadc>
 <aW86/Nc2+bkopFd7@intel.com>
 <rey5elthflgiygw4lf5zqldlof6nd5b2mq5is7zbgec7zqvr7a@izbte4jmotrq>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <rey5elthflgiygw4lf5zqldlof6nd5b2mq5is7zbgec7zqvr7a@izbte4jmotrq>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E2E0D2000B
X-Stat-Signature: 116ih17r3qimtodxzs1id1y3bth79o7f
X-Rspam-User: 
X-HE-Tag: 1768999949-835219
X-HE-Meta: U2FsdGVkX18Z85nbzSJ/koWmhLF+T2s4OIWp7Z7ojKTvc0/7e/J1fseoC8GsoeMOVETSL+8WtrHgPwlspWg1ksQTtTnekOnAH5H/yd/++6cyLx2Zc71iCXcP/HDCcWu4Qkz5Vrhpsx495YKy17hav4TyPgoQukFPjtzS7yFafW7/P3FNphcU2HUmdYmIcUJ7lVRmz3H9F/EVhPKO3v1Ua1T0qPcZij9OUUbhnrieVbNZ8rMEvPNEATeA0MLKPv9drMUM576ijJzOQTeBChoeZcXkfAB7G6vGbYCwmcIDRE9B7yWviZME7m6Ev6Qqq0TwqiXcRyjN8JQys4/Jdi8eQPGp2umFljzMddkIMAyuxoZzyXqWoKo+Kjw3Qy0ZRZP6jZCzAIW5VMTKODjjU1ciq4OzFQ7Q5HjC9p8267yjH0w16vJNskdDE7wWJlXMCyK4wURPU0xrsffmttFdz9H9wdbBkkug1aR3rqDnbV+wFkB5fZA86EhbbJPIFwOct2Sj0x0qKcE6s77jclnJjOhWorHBE18MzEjKc5OPiVZlexbx7SErvFKsOa3RbF8YkUz/vPdZvx5j9pzrENnXAV5jgxzLIwZSxiFrpDOY3DoOZE5sPrfo2s3beNaymcsuGhUU4dCqJ2a8WSGrifNrg6g+E8hHLW5nFFo/Ch8xfRm9O4rhCG2jvBL5vkZhFNPTMrFOnHs+fUaZM4ENS+ENB1ezzGXFv1+wlb9b96FM7O+kW0BGGjBFcl8Xpso5LJotuD1NlofeQNo5kot5QJ/bWOTEpDiwZuMG/ka2Y5CAJVUvviuw38ddV8gPS6+EIRQKg6cYOTIJH+qLZNaN9T41zaRtqt37UazmWBo6M3IvTtYuw+r8jmZz2JF3HYqhJuz3w6Qw5Rrdqq2hUf5jviiaBA8GLagnHw4J+Jk8vPwwXKw1lslVPGdgTZGCFSbBjpk1kkTuCccjD8bQPW9XM0MnLcX
 KtQx+mAF
 G2RBVLGiv/NyrxcT+IQ0caK+t+WGT/GpYIIZMxv7Z7vJDW2ZQh5ULZAtz9f2VLIkXNWzpcuWC0ZxP/sOAaMNNrS8R5Gg+S6ibIF6b5koMh/8x0K1nWuf+s7Pc1Pev1cpWmj7hVppvHG+b8g7u8zDd8cx6TLQhp8OiRsIcaDqdbNHPjeaohUFuJtJL95zkg2TrxGHy650c4dK3NLD1lq5WKCcCgZ/Q4FkAmgN0PJ6q2Il+N8iDRm40orTmgyK6DLYiCQoCklTx1V407342txKondE/bK5rumrcyOSbVtmfQc3HThnEoeabS5Ms/TFasiBif3cUijX72ep061iE30cTkGdwhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Thanks again for your thorough testing and detailed feedback - I really
> appreciate your help.

You're welcome and thanks for your patinece!

> > It seems like this is a GNR machine - maybe SNC could be enabled.
> 
> Actually, my cpu is AMD EPYC 96-Core Processor. SNC is disabled, and
> there's only one NUMA node per socket.

That's interesting.

> > For lkp, smt parameter is disabled. I tried with smt=1 locally, the
> > difference between "with fix" & "w/o fix" is not significate. Maybe smt
> > parameter could be set as 0.
> 
> Just to confirm: do you mean that on your machine, when smt=1, the performance
> difference between "with fix" and "without fix" is not significant - regardless
> of whether it's a gain or regression? Thanks.

Yes, that's what I found on my machine. Given that you're using an AMD machine,
performance differences arise due to hardware difference :).

> > On another machine (2 sockets with SNC3 enabled - 6 NUMA nodes), there's
> > the similar regression happening when tasks fill up a socket and then
> > there're more get_partial_node().
> 
> From a theoretical standpoint, it seems like having more nodes should reduce
> lock contention, not increase it...
> 
> By the way, I wanted to confirm one thing: in your earlier perf data, I noticed
> that the sampling ratio of native_queued_spin_lock_slowpath and get_partial_node
> slightly increased with the patch. Does this suggest that the lock contention
> you're observing mainly comes from kmem_cache_node->list_lock rather than
> node_barn->lock?

Yes, I think so.

> If possible, could you help confirm this using "perf report -g" to see where the
> contention is coming from?

No problem,

-   42.82%    42.82%  mmap2_processes  [kernel.vmlinux]          [k] native_queued_spin_lock_slowpath                                                      ▒
   - 42.17% __mmap                                                                                                                                         ▒
      - 42.17% entry_SYSCALL_64_after_hwframe                                                                                                              ▒
         - do_syscall_64                                                                                                                                   ▒
            - 42.16% ksys_mmap_pgoff                                                                                                                       ▒
               - 42.16% vm_mmap_pgoff                                                                                                                      ▒
                  - 42.15% do_mmap                                                                                                                         ▒
                     - 42.14% __mmap_region                                                                                                                ▒
                        - 42.09% __mmap_new_vma                                                                                                            ▒
                           - 41.59% mas_preallocate                                                                                                        ▒
                              - 41.59% kmem_cache_alloc_noprof                                                                                             ▒
                                 - 41.58% __pcs_replace_empty_main                                                                                         ▒
                                    - 40.38% __kmem_cache_alloc_bulk                                                                                       ▒
                                       - 40.38% ___slab_alloc                                                                                              ▒
                                          - 28.62% get_any_partial                                                                                         ▒
                                             - 28.61% get_partial_node                                                                                     ▒
                                                + 28.25% _raw_spin_lock_irqsave                                                                            ▒
                                          - 11.76% get_partial_node                                                                                        ▒
                                             + 11.66% _raw_spin_lock_irqsave                                                                               ▒
                                    - 1.00% barn_replace_empty_sheaf                                                                                       ▒
                                       + 0.95% _raw_spin_lock_irqsave                                                                                      ▒
   + 0.65% __munmap                                                                                            

> > Back to my previous test, I'm guessing that with this fix, under extreme
> > conditions of massive mmap usage, each CPU now stores an empty spare sheaf
> > locally. Previously, each CPU's spare sheaf was NULL. So memory pressure
> > increases with more spare sheaves locally.
> 
> I'm not quite sure about this point - my intuition is that this shouldn't
> consume a significant amount of memory.
>
> > And in that extreme scenario,
> > cross-socket remote NUMA access incurs significant overhead — which is why
> > regression occurs here.
> 
> This part I haven't fully figured out yet - still looking into it.

This part is hard to say; it could also be due to certain differences in
the hardware itself so that your machine didn't meet.

> > However, testing from 1 task to max tasks (nr_tasks = nr_logical_cpus)
> > shows overall significant improvements in most scenarios. Regressions
> > only occur at the specific topology boundaries described above.
> 
> It does look like there's some underlying factor at play, triggering a
> performance tipping point. Though I haven't yet figured out the exact pattern.

For details, on my machines, test where nr_task ranges from 0, 1, 4, 8 all the
way up to max_cpus, and I plot the score curves with and without the fix to
observe how the fix behaves under different conditions.

> > I believe the cases with performance gains are more common. So I think
> > the regression is a corner case. If it does indeed impact certain
> > workloads in the future, we may need to reconsider optimization at that
> > time. It can now be used as a reference.
> 
> Agreed — this seems to be a corner case, and your test results have been really
> helpful as a reference. Thanks again for the great support and insightful
> discussion.

It's been a pleasure communicating with you. :)

Thanks,
Zhao


