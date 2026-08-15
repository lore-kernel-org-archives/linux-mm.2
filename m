Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77B3C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 05:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78626B078D; Sat, 15 Aug 2026 01:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29D26B078F; Sat, 15 Aug 2026 01:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917D86B0790; Sat, 15 Aug 2026 01:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD6D6B078D
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:58:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE8C140307
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:58:40 +0000 (UTC)
X-FDA: 85102449600.30.0C25DA4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf01.hostedemail.com (Postfix) with ESMTP id 31BB440003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:58:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y9pW4+aB;
	spf=pass (imf01.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786773519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHlllpYGSplQ0P630meBrmRH75/+nl1XJLw2LsJ/LNA=;
	b=3Y4S45XmqEHuLc/zY54EJvzMmn6yMIPrnKBeQOTM90SW0MF2qM2Piagw7+uQuRNWUFocwM
	hG+v+UwTX9ZlRvGcvqNSJf1fF2hNYxberTraxA49SXpgTat9QavWfA8d4A5WLE7MVWFDo4
	I7PeyAlrwp0FLGG8uwIGgtD7IWLx674=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y9pW4+aB;
	spf=pass (imf01.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786773519;
	b=iTdAKzoneKbUFdcduz+TgXKfDiYHGAjXbsKcOdfWPqMYmkMfMw1+Blny3t9iL+gFeJIE8P
	ox9azhX410JVkn919grmZenRp/+qBpVEEC46C2vJRNtn29sT7OURBbW/lwp49jDDWHIosG
	Kh6mpvE2p6Mi1vpmeEbTkH68an7bjnY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786773519; x=1818309519;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gjNgyi75mKSLP0qFZKF47roDus09J1ZqRh7z5MgfQmQ=;
  b=Y9pW4+aBwB9MHBC5oaZoe49Mca4vO9Y6xYurUKZZRxHqtVwFY3PYwAIq
   bxVj6lAIZCGBz/6ImpFE7nW4KIIxHs/ny4QAT9A6kDrBja/MoQkBISyhC
   5mViq7HQgOxhUDRA7n25ijkTLF+KWkvAK4GgI5cBGQoHkkzk+K5kznYlZ
   f7azNu+UGZYbSkIVc/mWZpz+vIpw7tZbh7Wl2YR/ILX25dk03vHs4+fwH
   0dw8E6N6gQmJcyvcxaH+6aP8Xp1Vk/iQjh/VF9/iujCWDgvhgDvFuRkjx
   gtI6uup6ziqVqJfDV9EV+X4z8CUa187CnnlNpFlL8tGdc7PR1XTXvyPFI
   A==;
X-CSE-ConnectionGUID: vhCHoYrqQ1WYvX20ytuS5A==
X-CSE-MsgGUID: EUZEEEgjQxqsTxzN54ASDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="87264106"
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="87264106"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 22:58:37 -0700
X-CSE-ConnectionGUID: uehPhlSGQi6zUjC9n0w1tA==
X-CSE-MsgGUID: 4PqaEcKTS7G8yfZBQqcEMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="302647734"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 22:58:33 -0700
Date: Sat, 15 Aug 2026 13:58:29 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, oe-lkp@lists.linux.dev,
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	cgroups@vger.kernel.org
Subject: Re: [linux-next:master] [mm/vmpressure] ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
Message-ID: <aoAABX59IzUXz/Rv@ly-workstation>
References: <202608131743.c6a7dda4-lkp@intel.com>
 <an34C2N-yqfok2Nn@linux.dev>
 <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev>
 <an3-aksL0MZPM3ZJ@linux.dev>
 <f330dd75-d9b8-4259-a02f-9e3ff4bcdc1e@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f330dd75-d9b8-4259-a02f-9e3ff4bcdc1e@linux.dev>
X-Stat-Signature: d41nq8hkqebq9cmjt71opfnypincz5j9
X-Rspamd-Queue-Id: 31BB440003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786773517-131401
X-HE-Meta: U2FsdGVkX1+aTSi6Nb/0o9mYA/TUj7KobJ73zJ1JZC16Q02yJB/CQqNzWKjQrws7PtGzQtGLZVpz/xaOlY6OeNBB3iwY5PYQf1q1TH19BGBdRV665QvqMXhsBeJESqNObBtM3fPromx776AFlznLM6LVtX5eUqNGEWuPIToiHBOZC8AB95OjMsPbPZK2vAf0rSxbu9JoW/p2Y5BIIz9nEvvZSsvrSZ07mlibMhdf8jNT6dEceh/I2wVZyFkeGoXQmJoLbPkCyr9akgmcV4QMJpTW9YOiuNuchggFkGUWyNOl3lpqtsnohbnsxYhkUZrCUOEAymhgv1PfwoNTJn1OlMWiVDrEI01P/J1ezzd44clw/14gHu8ME6fxoNrtilTusCy9RY0gj7eid8Q6zcLlAoC0W+j7Z4ww9CTgituCup8NbcDC/vwexl7M0AYxEG28sx/ONRetjbiwK/2sC0wI2gP3g0J8dLNGIWITY6B6AS7MAwzCVU4QE3hOZCVLkInUjDfPmrEPYabCJRL/aFIm5+kDEoc1XRyY8zVQu2sRjzgoBAzkml6cUKZ7i+v2jhiawUJx54wkLsKCyGctKvsJ1DJZgH3cXUmoNMWeVC1Ux/h/UM5nMKSCGNFXFMqM8Caagjvc93hjjtlPhqY9jF5c/9/mNyP9mWz0XuiCZUyS2cCExXvmIuBrDUQlgoC9CSmZwC+yiryD6FKgEW2Wtg/d0xefIG1w5ZcKisaieTlOBLFapt4R77OSVq6XqDQLSxGUsO9f9MOYSwFmA5k2GcDpThEuSh0tcEAsLNAnqma5jh+/iaabpsvw7HsL+evP7HCDw0WuHD4T95NeV/hlrrOPsKbxefsQUsL+LOkV+2Gh9cMxSnial2MmICjWDtA6Xz19iiPqUnkreqvLcLjUlGFrwpxw9yvFX/DnuYjYy6x+thJJVN+wozNF7U+t2xruhoX8PRJ1XnJJiY7wisYzyz1
 gfj3YDj+
 Dkuxn0bqx918SLz78U1ZpDy0F9W6lEakNPHIshAZFCWOZwW6IJWENIfTEqzn/JMhNajXl5ryNzcR0KhE5In0/LyD3JKa616jI5RVVnoW+WArX/0p/nWsRmFTjULbyDNTQCtYWyqROvRQkUc2eZ0IxbvOerfb1nw21PDxfUdNpjbHRTKA5f01Hr4GIXNFSBMsLNBqJDnil2i0PltkZM+D4Yy+BryueJ/mWBxj6HIiBIQ4c8RE0pmGsr1mG3rHH2Bc1cZRPGEKXwg/d/jv48ntuaW/riXXAEkoywemP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 11:32:09AM +0100, Usama Arif wrote:
> 
> 
> On 13/08/2026 18:29, Shakeel Butt wrote:
> > On Thu, Aug 13, 2026 at 06:14:50PM +0100, Usama Arif wrote:
> >>
> >>
> >> On 13/08/2026 18:01, Shakeel Butt wrote:
> >>> On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
> >>>>
> >>>>
> >>>> Hello,
> >>>>
> >>>> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
> >>>>
> >>>> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> >>>>
> >>>> in testcase: stress-ng
> >>>> version: stress-ng-x86_64-29ce10a2c-1_20260712
> >>>> with following parameters:
> >>>>
> >>>> 	nr_threads: 100%
> >>>> 	testtime: 60s
> >>>> 	test: mremap
> >>>> 	cpufreq_governor: performance
> >>>>
> >>>>
> >>>>
> >>>> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
> >>>> compiler: gcc-14
> >>>> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
> >>>>
> >>>> (please refer to attached dmesg/kmsg for entire log/backtrace)
> >>>>
> >>>
> >>> Hi there,
> >>>
> >>> Can you please test the following patch and see if it fixes the regression?
> >>>
> >>>
> >>> From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
> >>> From: Shakeel Butt <shakeel.butt@linux.dev>
> >>> Date: Thu, 13 Aug 2026 09:38:28 -0700
> >>> Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline
> >>>
> >>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> >>> ---
> >>>  include/linux/memcontrol.h | 10 ++++++----
> >>>  1 file changed, 6 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> >>> index e78bc98ab229..e25d5b9a1db8 100644
> >>> --- a/include/linux/memcontrol.h
> >>> +++ b/include/linux/memcontrol.h
> >>> @@ -246,8 +246,13 @@ struct mem_cgroup {
> >>>  	/* handle for "memory.swap.events" */
> >>>  	struct cgroup_file swap_events_file;
> >>>  
> >>> -	/* memory.stat */
> >>> +	/* Read-mostly. */
> >>>  	struct memcg_vmstats	*vmstats;
> >>> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> >>> +	int			kmemcg_id;
> >>> +
> >>> +	/* Write-hot from here on; do not let it share with the above. */
> >>> +	CACHELINE_PADDING(_pad_);
> >>>  
> >>>  	/* memory.events */
> >>>  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
> >>> @@ -266,9 +271,6 @@ struct mem_cgroup {
> >>>  #if BITS_PER_LONG < 64
> >>>  	seqlock_t		socket_pressure_seqlock;
> >>>  #endif
> >>> -	int kmemcg_id;
> >>> -
> >>> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> >>>  
> >>>  #ifdef CONFIG_CGROUP_WRITEBACK
> >>>  	struct list_head cgwb_list;
> >>
> >>
> >> I was currently testing this diff, not sure which one would be better.
> > 
> > I was just checking if false sharing of vmstats_percpu is the cause. If your
> > patch does not increase the struct size, we can go with that as a backportable
> > fix. I am planning to rearrange fields of struct mem_cgroup more drastically and
> > have it more stable as future work as we continuously see these regressions keep
> > popping up.
> > 
> 
> 
> Yes this makes sense. I did not expect such a big change in a benchmark
> with my patch, although I feel like the microbenchmark is probably not
> that realistic.
> 
> I think another issue is that its a 4 socket system.
> I only have access to a single socket system, and I see a 4.38% regression.
> 
> Do you know if there a way for kernel test robot to test the below patch
> on its host?
> 
> 
> >From b862e84e7bd6a54b1546b7f21a6cf991253def18 Mon Sep 17 00:00:00 2001
> From: Usama Arif <usama.arif@linux.dev>
> Date: Thu, 13 Aug 2026 11:42:05 -0700
> Subject: [PATCH] mm/memcontrol: avoid false sharing between vmstats and events
> 
> Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
> struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
> This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
> vmstats_percpu pointer onto the same cacheline.
> 
> The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
> disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
> 60-second run on a 176-CPU test system.  Those writes bounce the line
> while memcg statistics paths load vmstats_percpu.
> 
> Move cgwb_list into the existing alignment gap and cacheline-align
> vmstats_percpu.  This separates the pointer from the event counters
> without increasing the size of struct mem_cgroup in the tested
> configuration.
> 
> The blamed commit reduced median mremap throughput by 4.38% on the
> test system with one socket. The patched kernel brings the performance
> to within 0.5% of the parent which is within the observed boot-to-boot
> spread (up to 1.2%).
> 
> Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
> Reported-by: kernel test robot <yi1.lai@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/memcontrol.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e78bc98ab229b..215e2e87f42b2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -268,10 +268,15 @@ struct mem_cgroup {
>  #endif
>  	int kmemcg_id;
>  
> -	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> -
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct list_head cgwb_list;
> +#endif
> +
> +	/* Keep the hot per-CPU stats pointer away from memory event counters. */
> +	struct memcg_vmstats_percpu __percpu *vmstats_percpu
> +		____cacheline_aligned_in_smp;
> +
> +#ifdef CONFIG_CGROUP_WRITEBACK
>  	struct wb_domain cgwb_domain;
>  	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
>  #endif
> -- 
> 2.53.0-Meta
> 
>

Tested the patch on the same test machine. Here are the test results
from stress-ng mremap benchmark (60s, 256 instances):

	Commit Avg.ops_per_sec
Base	a33b5c91	57311.85
Reregression ea928e9e	36542.09
Fix	582a7676	57089.22

The performance regression introduced by ea928e9e is resolved.

> 
> >>
> >> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> >> index e78bc98ab229b..215e2e87f42b2 100644
> >> --- a/include/linux/memcontrol.h
> >> +++ b/include/linux/memcontrol.h
> >> @@ -268,10 +268,15 @@ struct mem_cgroup {
> >>  #endif
> >>         int kmemcg_id;
> >>
> >> -       struct memcg_vmstats_percpu __percpu *vmstats_percpu;
> >> -
> >>  #ifdef CONFIG_CGROUP_WRITEBACK
> >>         struct list_head cgwb_list;
> >> +#endif
> >> +
> >> +       /* Keep the hot per-CPU stats pointer away from memory event counters. */
> >> +       struct memcg_vmstats_percpu __percpu *vmstats_percpu
> >> +               ____cacheline_aligned_in_smp;
> >> +
> >> +#ifdef CONFIG_CGROUP_WRITEBACK
> >>         struct wb_domain cgwb_domain;
> >>         struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
> >>  #endif
> >>
> 

