Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E4EC5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 00:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DAEE6B032D; Fri, 14 Aug 2026 20:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2E56B032E; Fri, 14 Aug 2026 20:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0826B032F; Fri, 14 Aug 2026 20:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51A9A6B032D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:25:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB496160291
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:25:47 +0000 (UTC)
X-FDA: 85101610734.11.6EA220E
Received: from mta1.migadu.com (out-17.mta1.migadu.com [95.215.58.17])
	by imf25.hostedemail.com (Postfix) with ESMTP id 528A5A0007
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:25:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Eu7uF+EZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.17 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786753546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLTeimZZS69Ob0HoxipnUj9pCSRAdytqNdfoSRfborw=;
	b=xcBt1exSSO3FHSQEnsuuk/NJxvwnQGCZVvK5gV3uWu7likZe3fV/ohnqoHU0OgH3VusFqz
	PEG9zAxrsJUI7yLZFmgCmNLf/wAyLi9b9Q5sitlbMrAqredtFvcPe61bzVUyjuhVgxpFtX
	aY+BiNh0RmFS4nJc8wI/Kcy6GVZQohQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Eu7uF+EZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.17 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786753546;
	b=NMgHPsWPYfd3LXMHMBcny79Zx2niwTeAzdnL1k+0syxwZF3RXrEntsKDFdiglc/3hKqKX9
	hZxPQuSzTUGCmD08ozOZQt0Xo671wzJfFsyM5Zl5RfTwiW7zEzOttYl9nBkk9wm76/yieP
	a6pzfb/WybbKu+dsMId2a1PVpm1FCVU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GYuFv7CQYkZCd17N/+SeP2Qi4r1CM+EVfUZM03WzySo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786753541; v=1; x=1787358341;
 b=Eu7uF+EZUCsY1M8UchM7uP64hCh58Fd58ixSWPXIPj77Vk4FD/ElfoyCr7fYwxHWCHLkZS7s
 6gvEDUWK9VaL7+w0zZ4hCvgO81mSIUxUmzkKdh4/nnnRGxWcovgn9FI4smVQPfOB2kRXAa4MbNe
 h2kltY+QOq2OMIWNRsq6Myfg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:7::)
	by smtp.migadu.com with ESMTPS id b7d206ee5502d7bd;
	Sat, 15 Aug 2026 00:25:41 +0000
X-Migadu-Flow: FLOW_OUT
Date: Fri, 14 Aug 2026 17:25:39 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: kernel test robot <yi1.lai@intel.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, oliver.sang@intel.com
Subject: Re: [linux-next:master] [mm/vmpressure] ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
Message-ID: <an-w9UJy6y9Wg11J@linux.dev>
References: <202608131743.c6a7dda4-lkp@intel.com>
 <an34C2N-yqfok2Nn@linux.dev>
 <017721a3-5eae-449e-8b86-75cffb503dd3@linux.dev>
 <an3-aksL0MZPM3ZJ@linux.dev>
 <f330dd75-d9b8-4259-a02f-9e3ff4bcdc1e@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f330dd75-d9b8-4259-a02f-9e3ff4bcdc1e@linux.dev>
X-Rspamd-Queue-Id: 528A5A0007
X-Stat-Signature: fjkiscisfc8s5p18fwafqo4jxo9ztjuf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786753544-661605
X-HE-Meta: U2FsdGVkX1/VPUeyFBS2nZCXZosXWN9VKIQqvZIolAcD6zkLmMc8twfzKcCRF/Ao4ex7o1AMzlHCp841u+685ZGu6LfFUunfAq45KtAW3Nktq1IODhbVciSKQ96fhocw5Lts++m5WmX5TkqaKL2NFEwK6RpCkDI/0SIs1tYjNGoDfEACqu57wdBW0LCNtNUdUhZsAcDzZIbHgKLlBWETuVq8A8p30bhZcl7tCl/W8TdY9EqzXuMJg7rAS/rWjJOrE1Qe9g0z2Xxvey16WuneCBIjBQGfeCWZL0loumOtkuugcsvwEq5/1QkdQZ3jKDyeTGEWXchJVCotcSLsSGvqnDYlv17DUfIeldQyuknVf7Po2eFvGHnLiwYxuIlOvaD4SUUy24b/9oegaI09evJrY4pqZ9b5RPXSBJ8zTgU95NqHco480ipeZ26Umifwsgh2tf9l4bpArmSuPwk9rn39Z+UrQRpAbYU+CGa37PHjvNyqipSgyADkOaunyOeOYEofV8rn8Y0qVL/by+zAeNR1t3sAJLdmAsSNwWKhLWrxyRGiRgI9U/bhs+FqgRyOpbQtT6fDHMAf9nokO//pV4wop4oR+f+fUHfiBf3UZrkEetzN4tzqZv7H7QkKoGsuSBppjQxBetfifybQXI3zBRaR7MMdQ4ByCj/r0JZ+wsHkz52z/P63tWlo022tCemUgVdTWl0cUGdEVdDJC39X+IJw8EFOtNC7QXiLmsdsvJ24kqJ5nG5I+g+01BYtQmfbrt5sZFRYwY4EZ0wuiLGPok9KrVu/fza0btSujim6/TBC/FouxJoHZS2a/77I0LazRxBBxyYTcEjJhViAfaPgHziKDiqzWWVeS99f+l/onXOIvqbWzUK8v/bCLHQ8siciiKeHHNxCI+brxgSTdIDDIFFuo40awynzbO4PIS5fs+0mUJB/XXnoHueyZ9WQ0ZKHWJDQm6629prrNSgpDfUl+bE
 lOKnXNv5
 ZVm0UqbaBdRyMySP1rwIdN+f8P8YKideFrT6hDcp+w+JDmE732HRg0plzn+Pjb1ddk2xyVDOcdH6sEWq2YAUpp+cRcwvGHe+6VRS6Lww3iakqB1D/0l4RXMG1kr14jbnpvi8Vy87DloyAGu/Zng2ekbEL1vS2wE3Sv/61nA21vTIhVG2zgUQHDxG0sLbN3AanFLJkrbxDOCDxbLdGvlmH+V/FFiN4QyMBwpTfJmgQOTPHK+sgXrtIO3RqPMzarmlHL57irewtwmeVUtjOhnti6C0baNrV+YwBlH2XLYKZ+uKLkmfvevl51WtgmzEBF2qMKINukjwfM9mWOjdPY44ZnUbNihP0IKvTWFq4W5WiqF0mZMm1iudtvtwm+gsZXoYU/bcnBpTlK0XfSBh+4o158UURJ0oDmYD1COYk
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

+Oliver

I used to request Oliver to test a patch for performance regressions reported by
intel test robot.

> 
> 
> From b862e84e7bd6a54b1546b7f21a6cf991253def18 Mon Sep 17 00:00:00 2001
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

