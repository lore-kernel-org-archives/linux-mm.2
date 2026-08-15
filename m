Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A1C8C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 19:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E5B6B07E8; Sat, 15 Aug 2026 15:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFA86B07E9; Sat, 15 Aug 2026 15:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04C06B07EA; Sat, 15 Aug 2026 15:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 987596B07E8
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 15:20:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 289CE1C11B1
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 19:20:41 +0000 (UTC)
X-FDA: 85104470682.07.0715807
Received: from mta1.migadu.com (out-157.mta1.migadu.com [95.215.58.157])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9B5E6160006
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 19:20:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jl+8FvhG;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786821639;
	b=vtwvbY3RRK1JjgELSl2aHA/a0S6lfUX7pDU1/D5ETUfq7AjBAJdv/jOL8w9miL3TIqvXcC
	UCG5fGPaK5GzUs7Mts+ldMtjyZqtBF754DK1DwswXtJvJwJo815mMg3mqtbUS50RanRBUH
	xsUuwiOypJ7fUj2RESrJ22IgGEDQqT8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jl+8FvhG;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786821639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIIWwITVweyr6u15y3UunA4nvI4/p6UIh1g4JvVQcN4=;
	b=Uc+S/DA8qT/vTmE1viZcnbqJhMvb0WwUNuuYSiGpCpN8+asYkw93dXo8SNCbF65cGYYGu3
	gfQlJumPafKavBq7UXmCt5piqq8BPawP7ZZ7dp9qK7K7R9xVr0aEbRbgGOpwfANqH2ws9T
	+zIsCAiICCYlN2xytRawEBIU4h/j+mo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=es1upZSfw+GDFk7iS7KckxveC0HgwWL/IhQ9PsbGcAE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786821636; v=1; x=1787426436;
 b=Jl+8FvhGx3kpIZCxHjJetRYmc6kMunmQ4atH8GFX/KrQNrDajqjZ4Kjo69DI2jBykHJM2iSw
 2+Npp5tcug1SyI1Ff+tadIbCAck+sFUK4cP5n1+q8HAg+JRceSDo1Dsp4gzfCS/XukDKCR7ngRV
 gFzVMMvUL5J8ucX06uWfgigk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:16::)
	by smtp.migadu.com with ESMTPS id 1201a916540915ec;
	Sat, 15 Aug 2026 19:20:26 +0000
X-Migadu-Flow: FLOW_OUT
Date: Sat, 15 Aug 2026 12:20:21 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kernel test robot <yi1.lai@intel.com>
Cc: Usama Arif <usama.arif@linux.dev>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Subject: Re: [linux-next:master] [mm/vmpressure] ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
Message-ID: <aoC7k_AULngjkHQ-@linux.dev>
References: <202608131743.c6a7dda4-lkp@intel.com>
 <an34C2N-yqfok2Nn@linux.dev>
 <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev>
 <an3-aksL0MZPM3ZJ@linux.dev>
 <f330dd75-d9b8-4259-a02f-9e3ff4bcdc1e@linux.dev>
 <aoAABX59IzUXz/Rv@ly-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoAABX59IzUXz/Rv@ly-workstation>
X-Rspamd-Queue-Id: 9B5E6160006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: okx3cf1czepyipdctwgdawn91k3ptpyc
X-HE-Tag: 1786821638-639014
X-HE-Meta: U2FsdGVkX19botVmJwC4UjVYTc0E6hYBWzEiaRs+1d6QcURkegdHn6o7HgHfPNr6y357IMAYhervFlmT88ZKTd1b8WFpjvrNBYki0SW1J3/sBEHn94/AxWD24/C1285x3m6FhxP75HJCX7tsCByavTOIej3weanFeFj4jTC7Jl9fJBmcFjfLpRQ+113Shd3culIG3jqc37HWvgRL1OQy1/dr1DBkGGqPAw8wz0AAre2jlS8kfnOSOYHaWeVM2Ix2HPz9LRtf5a3mZ06gBdbHmZjruUAeZD+gwwiCHqAeFAZYFEs3G428xrTeNTCHOJDek71FNENT7S123w8OLrB8CMnVkSrNLaXvnFxtC88s9U9K5wSOZ5vx5GFPPVMxWIca6VoTq5C+3gt6N9a2So3ajXhVOIA2Vs/R6ZJ4o+pwoaEGN2IxXmnShLwyuUt6HgTIbYecHmjZNa6KST15z7gEY+L05QI2phXDUXCVur/7tsV7dXeZ3tSRCgeG+dM5ShoKgDKKrLTWqvu46jHktuhoViO8TuRPLN9MaL7K7xOQ/8S+Qq4j0ElBz9yOne7B1Q6VNLP+ue6NBW6APyB65e8+H5uBMUtdUthx9zM0AjEbFNY5Vloh3AOc/YeMl2BDwfB6gsnTgl/y7PHLx7J3SumxHHhI4G0z8PE1Th+6P8pTvbPdVbHBtpvyZh4dcy2CRbr/j7HzFL8kcKqHWxZJgwX0QitHs3dHS6y6tgbe6d6knkAlVKLaYyN3gCkmSYJPBnuHpl6hTS3AyC+7gt8uA/69hIHD7s4I+zdh7WeaLgwJ0iBne3CUpiF+eBCQMFi6NpRTqRwDmzGpEg5T4Ht1GmyrcD2VGHpinpCMIvcvbY1zbnr39ZdP8WGfN5JS1LNIX4BN3c4cmBnPuPvEItynb/c8HU/jS/ST5bth2uzYUNGvdNQbTHvZjlTsN2vWsF7x2TPhlRfaDeaFiG+7L3TnQo+
 Ctgc8jPH
 RKKGweaS4Elps1Le64KFJ6XNl7Js6LiYZRwkZka/6nOAqG+xvF7NyubknGJuo10iXkZZd4V9Ao4xqYgJlCv+/vvGzdpEf5mfCBOaODxWTBjc5BKS1itlJNMnfep074RfJwg9q+eRfx0AmAMUFbTY77vMifO1SGJEl4xBCiwvpkgtUz9Iv8hC5iW5bjtgXf+bs/b8XpotG8WY/SKitO8abRtHSEgqKKjmKoMV9J1j7pJBNvLiiIWqdrAgDYO4YjrgpL+Oiy+NFI3clRSB3qhxyb2qHNJSX9lUau4FW6whvreISinRNWLMdRncbbRqrSqp4LJ/iqPwhabaGeq+wGYt5gmgASVQPZNMXzQ64OlqNXdtgCiCjmzjj3R3c9sKd0RGA2TSqyDiZpaNPi+7I2JdykVegSjS2MT520yim
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 01:58:29PM +0800, kernel test robot wrote:
> On Fri, Aug 14, 2026 at 11:32:09AM +0100, Usama Arif wrote:
> > 
> > 
> > On 13/08/2026 18:29, Shakeel Butt wrote:
> > > On Thu, Aug 13, 2026 at 06:14:50PM +0100, Usama Arif wrote:
> > >>
> > >>
> > >> On 13/08/2026 18:01, Shakeel Butt wrote:
> > >>> On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
> > >>>>
> > >>>>
> > >>>> Hello,
> > >>>>
> > >>>> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
> > >>>>
> > >>>> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> > >>>>
> > >>>> in testcase: stress-ng
> > >>>> version: stress-ng-x86_64-29ce10a2c-1_20260712
> > >>>> with following parameters:
> > >>>>
> > >>>> 	nr_threads: 100%
> > >>>> 	testtime: 60s
> > >>>> 	test: mremap
> > >>>> 	cpufreq_governor: performance
> > >>>>
> > >>>>
> > >>>>
> > >>>> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
> > >>>> compiler: gcc-14
> > >>>> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
> > >>>>
> > >>>> (please refer to attached dmesg/kmsg for entire log/backtrace)
> > >>>>
> > >>>
> > >>> Hi there,
> > >>>
> > >>> Can you please test the following patch and see if it fixes the regression?
> > >>>
> > >>>
> > >>> From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
> > >>> From: Shakeel Butt <shakeel.butt@linux.dev>
> > >>> Date: Thu, 13 Aug 2026 09:38:28 -0700
> > >>> Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline
> > >>>
> > >>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > >>> ---
> > >>>  include/linux/memcontrol.h | 10 ++++++----
> > >>>  1 file changed, 6 insertions(+), 4 deletions(-)
> > >>>
> > >>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > >>> index e78bc98ab229..e25d5b9a1db8 100644
> > >>> --- a/include/linux/memcontrol.h
> > >>> +++ b/include/linux/memcontrol.h
> > >>> @@ -246,8 +246,13 @@ struct mem_cgroup {
> > >>>  	/* handle for "memory.swap.events" */
> > >>>  	struct cgroup_file swap_events_file;
> > >>>  
> > >>> -	/* memory.stat */
> > >>> +	/* Read-mostly. */
> > >>>  	struct memcg_vmstats	*vmstats;
> > >>> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> > >>> +	int			kmemcg_id;
> > >>> +
> > >>> +	/* Write-hot from here on; do not let it share with the above. */
> > >>> +	CACHELINE_PADDING(_pad_);
> > >>>  
> > >>>  	/* memory.events */
> > >>>  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
> > >>> @@ -266,9 +271,6 @@ struct mem_cgroup {
> > >>>  #if BITS_PER_LONG < 64
> > >>>  	seqlock_t		socket_pressure_seqlock;
> > >>>  #endif
> > >>> -	int kmemcg_id;
> > >>> -
> > >>> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> > >>>  
> > >>>  #ifdef CONFIG_CGROUP_WRITEBACK
> > >>>  	struct list_head cgwb_list;
> > >>
> > >>
> > >> I was currently testing this diff, not sure which one would be better.
> > > 
> > > I was just checking if false sharing of vmstats_percpu is the cause. If your
> > > patch does not increase the struct size, we can go with that as a backportable
> > > fix. I am planning to rearrange fields of struct mem_cgroup more drastically and
> > > have it more stable as future work as we continuously see these regressions keep
> > > popping up.
> > > 
> > 
> > 
> > Yes this makes sense. I did not expect such a big change in a benchmark
> > with my patch, although I feel like the microbenchmark is probably not
> > that realistic.
> > 
> > I think another issue is that its a 4 socket system.
> > I only have access to a single socket system, and I see a 4.38% regression.
> > 
> > Do you know if there a way for kernel test robot to test the below patch
> > on its host?
> > 
> > 
> > >From b862e84e7bd6a54b1546b7f21a6cf991253def18 Mon Sep 17 00:00:00 2001
> > From: Usama Arif <usama.arif@linux.dev>
> > Date: Thu, 13 Aug 2026 11:42:05 -0700
> > Subject: [PATCH] mm/memcontrol: avoid false sharing between vmstats and events
> > 
> > Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
> > struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
> > This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
> > vmstats_percpu pointer onto the same cacheline.
> > 
> > The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
> > disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
> > 60-second run on a 176-CPU test system.  Those writes bounce the line
> > while memcg statistics paths load vmstats_percpu.
> > 
> > Move cgwb_list into the existing alignment gap and cacheline-align
> > vmstats_percpu.  This separates the pointer from the event counters
> > without increasing the size of struct mem_cgroup in the tested
> > configuration.
> > 
> > The blamed commit reduced median mremap throughput by 4.38% on the
> > test system with one socket. The patched kernel brings the performance
> > to within 0.5% of the parent which is within the observed boot-to-boot
> > spread (up to 1.2%).
> > 
> > Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
> > Reported-by: kernel test robot <yi1.lai@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> >  include/linux/memcontrol.h | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index e78bc98ab229b..215e2e87f42b2 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -268,10 +268,15 @@ struct mem_cgroup {
> >  #endif
> >  	int kmemcg_id;
> >  
> > -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> > -
> >  #ifdef CONFIG_CGROUP_WRITEBACK
> >  	struct list_head cgwb_list;
> > +#endif
> > +
> > +	/* Keep the hot per-CPU stats pointer away from memory event counters. */
> > +	struct memcg_vmstats_percpu __percpu *vmstats_percpu
> > +		____cacheline_aligned_in_smp;
> > +
> > +#ifdef CONFIG_CGROUP_WRITEBACK
> >  	struct wb_domain cgwb_domain;
> >  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
> >  #endif
> > -- 
> > 2.53.0-Meta
> > 
> >
> 
> Tested the patch on the same test machine. Here are the test results
> from stress-ng mremap benchmark (60s, 256 instances):
> 
> 	Commit Avg.ops_per_sec
> Base	a33b5c91	57311.85
> Reregression ea928e9e	36542.09
> Fix	582a7676	57089.22
> 
> The performance regression introduced by ea928e9e is resolved.

Thanks a lot.

Usame, can you please send a formal patch and you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

> 
> > 
> > >>
> > >> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > >> index e78bc98ab229b..215e2e87f42b2 100644
> > >> --- a/include/linux/memcontrol.h
> > >> +++ b/include/linux/memcontrol.h
> > >> @@ -268,10 +268,15 @@ struct mem_cgroup {
> > >>  #endif
> > >>         int kmemcg_id;
> > >>
> > >> -       struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> > >> -
> > >>  #ifdef CONFIG_CGROUP_WRITEBACK
> > >>         struct list_head cgwb_list;
> > >> +#endif
> > >> +
> > >> +       /* Keep the hot per-CPU stats pointer away from memory event counters. */
> > >> +       struct memcg_vmstats_percpu __percpu *vmstats_percpu
> > >> +               ____cacheline_aligned_in_smp;
> > >> +
> > >> +#ifdef CONFIG_CGROUP_WRITEBACK
> > >>         struct wb_domain cgwb_domain;
> > >>         struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
> > >>  #endif
> > >>
> > 

