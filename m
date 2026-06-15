Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A9CCD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 09:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1DE6B0005; Mon, 15 Jun 2026 05:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272E96B008A; Mon, 15 Jun 2026 05:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188B26B008C; Mon, 15 Jun 2026 05:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 072766B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:51:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 701A01209B9
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:51:57 +0000 (UTC)
X-FDA: 84881680674.13.1884048
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 52B341C0007
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 09:51:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TGcTVpd7;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781517115;
	b=xkVihC68B3Xq1+6xOxZVsyUmnE0NH6dQOn6Ty9EwjJTUa9WWr8XdbPcSm0B4eWRuR/Vp57
	zbMyaYWwJ+ESOXMfmarB/DQuz7+qpEHJ5Un52I6gjKdbbqGMntZzLJyPkxASInnZTDQrpM
	gYneJL79zhCaOj603jB1XEYjP+yWLD0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TGcTVpd7;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781517115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3d2yUwZAQzTpx8kn2j0duwhBKHz1ZKDy84hga+pY2M8=;
	b=70a6m0AcMvy2VG4AvLTKttAWqYb77P5TcmRVog1o446pYVeOl9xwl2SkjNsHv10h+DqkAT
	ywIjbSITfiIi0XquJ4QmG4u1BfNl0drg5x1A8s4dIhcbC4tkr+UFBZ2+9xW6jyzg9cPJVW
	Nqy7vOhrrJ8v6MzfzoQqdTxVhlW+2FE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7233E1BF3;
	Mon, 15 Jun 2026 02:51:49 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D0DDB3F915;
	Mon, 15 Jun 2026 02:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781517114; bh=HYXebXdKjDTNEbMCxVKBHEJ7a6iNwBF9Jex41GnLWm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TGcTVpd740LxgmO2SukgwG5lf1Zqy1MrIRxZvdyYoMWupVUugl1I4IHwo0MMe6DEL
	 b0B1M699xMRsJAD1v6cMx2Cj91sre5Q9jIjrcE99rnjciCAD5LzSonN81/1DqILhSB
	 8XMtKS6F3HOniPN2l5sGzi6FRUUBzcZ/lmVVE6sg=
Date: Mon, 15 Jun 2026 10:51:48 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Sterba <dsterba@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Liam Howlett <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Nick Terrell <terrelln@fb.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [vmalloc]  60ced5818f:
 stress-ng.shm.ops_per_sec 7.2% regression
Message-ID: <ai/LNIg42JYckH2B@e129823.arm.com>
References: <202606022131.112319f2-lkp@intel.com>
 <aifCQbaAZLkH2GJY@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aifCQbaAZLkH2GJY@e129823.arm.com>
X-Rspamd-Queue-Id: 52B341C0007
X-Stat-Signature: ntgp8adxumxbkcjyfrayarzpfeh77ykh
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781517115-98814
X-HE-Meta: U2FsdGVkX1/16N1Kv2UdQZwf7kEYpWuMC1JY2fkbWb7ds6YKCR5xeUNLCXVA7citz8EisuLTqlsdT2mo40IXBu6hawciwiUzTJya1TbsJL6MpS69plWF/RAQ6ekglsePlDHr9goPbe29NzDMiNUBaDvQ+Gg6+eiYXwcJmxdooZgzHUk9ewd9OPttSYzDQv8dvN85dm01E/QyrrI5UOoGJhvQd4Ff5ezhUJr7RoKLIYHDwzfRgsLC1LubZd/6CNIHU4JwL9HElnQabp7g0jlzaiGIJ03SmY9tT8hGpD54mXlEl4lFRhl1WWmPoGTVo06hNFl+KDwYkMir2izPxFOCxgKTLojzbvm2eTYKGqTDPZxt/f6X2o8eTn5kYahuanDVVoqlCcNTDzzX3jvzzqeWMKs8gt1glnaxYTliixqMCD45cUhCplFyxwupoC8VOxnKv8HvSsVdHjk+rjjhY7X2GfsYm0LeWbvdodW4Eg+gIYVdd6nA6fruSKbUmkePERWwujEmLioJY2vZzphGBy3Pd96oSG1VF3Th1+3nr/MTkU7ChGDJr+Rud+ci4sFwREQ7K8S9fgeWhTr0MNfRiM81D4Zu2o9a9rmYYorMtPJEda3KauuQTHfJJ8It/umFJAJwODipbEO9Vg5T6tFdhHZNVk3LeW7/mFdh3t0VSKfzv1XMadYwp3yvlrag1Cn4w/wBHmWIQqVuu/x0VZFqPakMsLuy3tYdugAKP4C6BXGKC6IR21EiU3FYUkUwlwbkWyYNzg1LF/IJQJGppJ4LWpDwM7xKVq8qwd8cqwUU9tt74HeGDZ9VkVQOm1YJqr/8rcSS35FQ39cEviHMIKVlhcFaS+BCAoETiygrNnSABqdrEDkNGpfD8eZt99wKQUgUbKj+H1u6yieMYWRT2hfIVgswWLVD2zudfadYnhxtPsyjcZxuADjlP9S1Qr6g2F+QJ3GFiGmDOAMKDcFCoRxFCxU
 fMzy8kwg
 3y1gPTjvnlBV7D6hOMj5bGOtXFmRQzvjftrwmMsPiRkezpBacoR+Bvk0bLU6P0GXh2RbHgkG3QVlcAZh+JEss0yMyAmJB5KE1n5LYcvt+CADl5//QB0d2PkMGxf02Y0cey5GOAVVIZPjLLxmX6eUkgmN2ruiEco4VT06lEXMQnm02z8KIN4KH4xra4kbA5dzy14626UDvg32rmmXeK4Vn66+GRH7IoeFKBNcx7wskeFi6Iz72gWKwcNtLB73DSDEFwOLp3hRjSiqYbN7zSo9TwCaRjc+VxPV4Y2BIJVEmNQgFLqpUU9KnSGIRw4822eYVODFRuV8rpSxj9+DeXjBLkHr8b5/3tDpVBDHhH85yGNiJ/x/RLULYjPdffwYGSC/YG0wA+zAPFZOX84ayvNqRe99JX+SpYLgHmWjZEZwcH6b65VVx1KEx/PK3ldDxhpeLyxdOyOM2o2PaO5NMG5VfQlap+Kf+by4qvXsc6zNkpGGcP+emOiu/+1Wf158jEIcZUtwnA2tcyBZ4RtglvycekrjT/i0Q8Am4cGlGGrYZN0MTbIvj/3V/pupYEaxltvNbjSwo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed a 7.2% regression of stress-ng.shm.ops_per_sec on:
> > 
> > 
> > commit: 60ced5818f64ac356620d1ad3e0d473c457dbf5b ("vmalloc: optimize vfree with free_pages_bulk()")
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> > 
> > [still regression on linux-next/master 7da7f07112610a520567421dd2ffcb51beaefbcc]
> > 
> > testcase: stress-ng
> > config: x86_64-rhel-9.4
> > compiler: gcc-14
> > test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
> > parameters:
> > 
> > 	nr_threads: 100%
> > 	testtime: 60s
> > 	test: shm
> > 	cpufreq_governor: performance
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202606022131.112319f2-lkp@intel.com
> > 
> > 
> > Details are as below:
> > -------------------------------------------------------------------------------------------------->
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20260602/202606022131.112319f2-lkp@intel.com
> > 
> > =========================================================================================
> > compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
> >   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp3/shm/stress-ng/60s
> > 
> > commit: 
> >   4aa4abf1f1 ("mm/page_alloc: optimize free_contig_range()")
> >   60ced5818f ("vmalloc: optimize vfree with free_pages_bulk()")
> > 
> > 4aa4abf1f14bd6d0 60ced5818f64ac356620d1ad3e0 
> > ---------------- --------------------------- 
> >          %stddev     %change         %stddev
> >              \          |                \  
> >    1103082            -7.2%    1024016        stress-ng.shm.ops
> >      18394            -7.2%      17072        stress-ng.shm.ops_per_sec
> >    2084775           -23.1%    1602693 ±  3%  stress-ng.time.involuntary_context_switches
> >  3.076e+08            -7.3%  2.852e+08        stress-ng.time.minor_page_faults
> >      14759           -21.1%      11646        stress-ng.time.percent_of_cpu_this_job_got
> >       8806           -21.1%       6946        stress-ng.time.system_time
> >      86.08            -7.5%      79.66        stress-ng.time.user_time
> >    2799689            -1.3%    2762252        stress-ng.time.voluntary_context_switches
> >  1.125e+09 ±  6%     +42.3%  1.601e+09 ± 13%  cpuidle..time
> >    2089564 ±  3%     +25.6%    2624591 ±  2%  cpuidle..usage
> >     360.33           -22.5%     279.35 ± 44%  turbostat.PkgWatt
> >      36.35           -22.6%      28.12 ± 44%  turbostat.RAMWatt
> >     198.28 ±  2%      +9.2%     216.55        vmstat.procs.r
> >     131962            -6.3%     123686        vmstat.system.cs
> >   14039730 ±  2%     -18.1%   11503879 ± 18%  numa-meminfo.node0.MemUsed
> >     175943 ± 13%    +114.1%     376780 ±  2%  numa-meminfo.node0.PageTables
> >     184811 ± 13%    +105.7%     380127 ±  4%  numa-meminfo.node1.PageTables
> >       9.32 ±  5%      +3.2       12.57 ± 11%  mpstat.cpu.all.idle%
> >       3.69 ±  9%      +5.6        9.29 ±  4%  mpstat.cpu.all.soft%
> >      85.37            -8.6       76.73        mpstat.cpu.all.sys%
> >       1.38            -0.2        1.19 ±  3%  mpstat.cpu.all.usr%
> >  4.555e+08            -7.4%  4.216e+08        numa-numastat.node0.local_node
> >  4.557e+08            -7.5%  4.217e+08        numa-numastat.node0.numa_hit
> >  4.493e+08            -6.8%  4.187e+08        numa-numastat.node1.local_node
> >  4.494e+08            -6.8%  4.189e+08        numa-numastat.node1.numa_hit
> >     193547            +7.4%     207908 ±  3%  perf-stat.i.cpu-clock
> >     193547            +7.4%     207908 ±  3%  perf-stat.i.task-clock
> >     135837            -8.5%     124266 ±  2%  perf-stat.ps.context-switches
> >    5141774           -11.4%    4555341 ±  2%  perf-stat.ps.minor-faults
> >    5141776           -11.4%    4555343 ±  2%  perf-stat.ps.page-faults
> >     194174           +12.8%     219047        meminfo.KReclaimable
> >   24232028            -8.6%   22159275        meminfo.Memused
> >     354997 ± 14%    +111.6%     751255 ±  4%  meminfo.PageTables
> >     194174           +12.8%     219047        meminfo.SReclaimable
> >     563220           +16.5%     656030        meminfo.SUnreclaim
> >     757395           +15.5%     875078        meminfo.Slab
> >     350188           +11.4%     390033        meminfo.VmallocUsed
> >   26142507            -9.8%   23588567        meminfo.max_used_kB
> >      43483 ± 14%    +119.0%      95246 ±  2%  numa-vmstat.node0.nr_page_table_pages
> >      43257 ±  3%     +12.4%      48605        numa-vmstat.node0.nr_vmalloc
> >  4.557e+08            -7.5%  4.217e+08        numa-vmstat.node0.numa_hit
> >  4.555e+08            -7.4%  4.216e+08        numa-vmstat.node0.numa_local
> >      45890 ± 13%    +109.3%      96035 ±  4%  numa-vmstat.node1.nr_page_table_pages
> >      44555 ±  4%      +9.3%      48699        numa-vmstat.node1.nr_vmalloc
> >  4.494e+08            -6.8%  4.189e+08        numa-vmstat.node1.numa_hit
> >  4.493e+08            -6.8%  4.187e+08        numa-vmstat.node1.numa_local
> >       0.16 ± 16%    +707.7%       1.30 ± 44%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
> >     346.29 ± 85%   +1061.2%       4021 ± 38%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
> >       0.16 ± 16%    +707.7%       1.30 ± 44%  perf-sched.total_sch_delay.average.ms
> >     346.29 ± 85%   +1061.2%       4021 ± 38%  perf-sched.total_sch_delay.max.ms
> >       7.34           +58.2%      11.61 ± 13%  perf-sched.total_wait_and_delay.average.ms
> >       4478 ±  6%     +49.6%       6697 ± 20%  perf-sched.total_wait_and_delay.max.ms
> >       7.18           +43.6%      10.31 ± 10%  perf-sched.total_wait_time.average.ms
> >       4477 ±  5%     +29.7%       5809 ± 17%  perf-sched.total_wait_time.max.ms
> >       7.34           +58.2%      11.61 ± 13%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
> >       4478 ±  6%     +49.6%       6697 ± 20%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
> >       7.18           +43.6%      10.31 ± 10%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
> >       4477 ±  5%     +29.7%       5809 ± 17%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
> >    1975577            -4.0%    1896474        proc-vmstat.nr_active_anon
> >     973349            -2.6%     947803        proc-vmstat.nr_anon_pages
> >      46138            +3.1%      47546        proc-vmstat.nr_kernel_stack
> >      90193 ± 14%    +110.0%     189399 ±  4%  proc-vmstat.nr_page_table_pages
> >      48563           +12.8%      54769        proc-vmstat.nr_slab_reclaimable
> >     140817           +16.5%     164023        proc-vmstat.nr_slab_unreclaimable
> >      87646           +11.2%      97438        proc-vmstat.nr_vmalloc
> >    1975576            -4.0%    1896478        proc-vmstat.nr_zone_active_anon
> >  9.051e+08            -7.1%  8.406e+08        proc-vmstat.numa_hit
> >  9.048e+08            -7.1%  8.403e+08        proc-vmstat.numa_local
> >  9.069e+08            -7.1%  8.421e+08        proc-vmstat.pgalloc_normal
> >  3.538e+08            -7.5%  3.273e+08        proc-vmstat.pgfault
> >  9.061e+08            -7.1%  8.414e+08        proc-vmstat.pgfree
> >      29261           -10.3%      26241        sched_debug.cfs_rq:/.avg_vruntime.avg
> >       0.58 ±  5%     +13.8%       0.66 ±  4%  sched_debug.cfs_rq:/.h_nr_queued.avg
> >       0.58 ±  5%     +13.4%       0.66 ±  4%  sched_debug.cfs_rq:/.h_nr_runnable.avg
> >       4034 ± 33%     +53.7%       6200 ± 13%  sched_debug.cfs_rq:/.left_deadline.avg
> >       4034 ± 33%     +53.7%       6200 ± 13%  sched_debug.cfs_rq:/.left_vruntime.avg
> >     583523 ±  4%     +13.7%     663177 ±  4%  sched_debug.cfs_rq:/.load.avg
> >       0.58 ±  5%     +13.7%       0.66 ±  4%  sched_debug.cfs_rq:/.nr_queued.avg
> >      14.14 ± 22%     +45.5%      20.57 ± 15%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
> >      67.99 ± 17%     +33.5%      90.77 ± 13%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
> >      13.66 ± 23%     +43.0%      19.54 ± 14%  sched_debug.cfs_rq:/.removed.util_avg.avg
> >      66.93 ± 17%     +31.0%      87.71 ± 14%  sched_debug.cfs_rq:/.removed.util_avg.stddev
> >       4034 ± 33%     +53.7%       6200 ± 13%  sched_debug.cfs_rq:/.right_vruntime.avg
> >     554.59 ±  2%      +8.7%     602.90 ±  3%  sched_debug.cfs_rq:/.runnable_avg.avg
> >       1553 ±  7%     +26.1%       1959 ± 17%  sched_debug.cfs_rq:/.runnable_avg.max
> >     266.15 ±  7%     +25.4%     333.85 ±  6%  sched_debug.cfs_rq:/.runnable_avg.stddev
> >       0.03 ± 76%    +526.1%       0.19 ± 31%  sched_debug.cfs_rq:/.spread.avg
> >       2.81 ± 88%    +377.6%      13.40 ± 48%  sched_debug.cfs_rq:/.spread.max
> >       0.24 ± 77%    +426.2%       1.26 ± 34%  sched_debug.cfs_rq:/.spread.stddev
> > -6.962e+10          -329.4%  1.597e+11 ± 20%  sched_debug.cfs_rq:/.sum_w_vruntime.avg
> >  1.654e+12 ±112%    +407.7%  8.398e+12 ± 18%  sched_debug.cfs_rq:/.sum_w_vruntime.max
> >     106852 ± 31%     +74.1%     185984 ± 11%  sched_debug.cfs_rq:/.sum_weight.avg
> >      29261           -10.3%      26241        sched_debug.cfs_rq:/.zero_vruntime.avg
> >     516.36 ±  3%     +85.2%     956.40 ±  3%  sched_debug.cpu.clock_task.stddev
> >     551602            -7.0%     513143        sched_debug.cpu.curr->pid.max
> >       0.59 ±  4%     +12.6%       0.67 ±  4%  sched_debug.cpu.nr_running.avg
> >      74120 ± 14%     -29.8%      52067 ± 25%  sched_debug.cpu.nr_switches.max
> >       4844 ± 18%     -36.8%       3062 ± 31%  sched_debug.cpu.nr_switches.stddev
> >       0.08 ± 47%     +83.8%       0.15 ± 20%  sched_debug.cpu.nr_uninterruptible.avg
> > 
> > 
> > 
> > 
> > Disclaimer:
> > Results have been estimated based on internal Intel analysis and are provided
> > for informational purposes only. Any difference in system hardware or software
> > design or configuration may affect actual performance.
> > 
> > 
> > -- 
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> 
> Thanks. I'll check it.

Looking at the patch [1], the regression reported by lkp [2] appears to
be caused by a lack of order-0 pages in the PCP lists,
which increases zone-locked allocations (mm_page_alloc_zone_locked).

On my reproduced setup (an x86_64 workstation), most pages freed through
free_pages_bulk() were order-2 pages (nr_pages == 4), including
vmalloc-backed stacks. With patch [1], these order-2 pages are returned to
the order-2 PCP lists, unlike commit 4aa4abf1f1 (“mm/page_alloc: optimize free_contig_range()”),
which effectively populated the order-0 PCP lists.

Since the shmem workload appears to fault memory at PAGE_SIZE granularity,
the reduced availability of order-0 pages in PCP lists seems to increase
zone-locked order-0 allocations, which may explain the regression observed by lkp.

Performance comparison (5 runs):
  - perf stat -e 'kmem:mm_page_alloc_extfrag' --filter 'alloc_order == 0' \
              -e 'kmem:mm_page_alloc_zone_locked' --filter 'order == 0' \
              -e 'kmem:mm_page_alloc' --filter 'order == 0' -- ./repro-script

Metric                               4aa4abf1f1           60ced5818f        Difference

------------------------------------------------------------------------------------------

Zone-locked Allocation Ratio (%)     46.39 ± 0.17%       48.31 ± 0.37%       +1.92 pp

  - Ratio = (mm_page_alloc_extfrag + mm_page_alloc_zone_locked) / mm_page_alloc × 100
  - Values are reported as median ± relative half-range across three runs.

The shmem test appears to handle page faults at PAGE_SIZE granularity, which seems to amplify the impact of the reduced availability of order-0 pages.


As an experiment, I modified free_pages_bulk() to free pages individually
as order-0 pages when nr_contig <= (1 << PAGE_ALLOC_COSTLY_ORDER).
This restores behavior closer to 4aa4abf1f1 and results in almost
no difference compared to that commit.

Performance comparison (5 runs)
  - ./repro-script

Metric                     4aa4abf1f1            change             Difference
----------------------------------------------------------------------------------
bogo_ops                   656,513 ± 0.34%      656,488 ± 0.23%          -25

bogo_ops/s (realtime)      10,935.95 ± 0.34%    10,935.86 ± 0.23%      -0.09

bogo_ops/s (usr+sys time)     220.31 ± 0.40%       219.30 ± 0.21%      -1.01

The differences are negligible and essentially restore the performance
observed with 4aa4abf1f1.

Given that the regression appears to be driven by a synthetic workload that
combines frequent shmem page faults with repeated stack allocation/free operations,
I do not think this is a significant concern for typical real-world workloads.

Thanks!

[1] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@arm.com/
[2] https://lore.kernel.org/r/202606022131.112319f2-lkp@intel.com
[3] https://download.01.org/0day-ci/archive/20260602/202606022131.112319f2-lkp@intel.com/repro-script

-----------------&<------------------
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 91bef811a771..48d9eaa1a2f3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5206,13 +5206,24 @@ EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
  */
 void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
 {
+       const unsigned long nr_costly = 1UL << PAGE_ALLOC_COSTLY_ORDER;
+
        while (nr_pages) {
                unsigned long nr_contig = num_pages_contiguous(page_array, nr_pages);

-               __free_contig_range(page_to_pfn(*page_array), nr_contig);
+               if (nr_contig <= nr_costly) {
+                       while (nr_contig--) {
+                               __free_page(*page_array);
+                               nr_pages--;
+                               page_array++;
+                       }
+               } else {
+                       __free_contig_range(page_to_pfn(*page_array), nr_contig);
+
+                       nr_pages -= nr_contig;
+                       page_array += nr_contig;
+               }

-               nr_pages -= nr_contig;
-               page_array += nr_contig;
                cond_resched();
        }
 }

> -- 
> Sincerely,
> Yeoreum Yun

-- 
Sincerely,
Yeoreum Yun

