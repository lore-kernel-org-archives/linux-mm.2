Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34DC0CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622186B0005; Tue,  9 Jun 2026 03:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2F86B0088; Tue,  9 Jun 2026 03:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8356B008A; Tue,  9 Jun 2026 03:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC666B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:35:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBAE88DD74
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:35:37 +0000 (UTC)
X-FDA: 84859564314.06.B2AF445
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id C69DC180009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:35:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gvrdzP3y;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780990536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gk3JhjhwjaG+hbsv6elTe4+9mGScd2BJt8E1LIcKxKI=;
	b=7zGh33KoFAjhgVD3f3Pm3fLCtiuB7CgoA9kr/QN4Rs1vfgAHJlPwOuXkuYvE2NP95JyObo
	2IL+OpsZGvuw721HZ43K/B0EXFPWTa3sqCT2sYVqHNm8T/r7IW7LpMo5ZwNBC+QEI9L5Xx
	WsgbhnjcHatWvmyqwmBU1vONPrC0u6I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gvrdzP3y;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780990536;
	b=GhX4B68ISNqWi/ETii3G72kvXtYnxAlRtg0no8+QMYoY4gaKgeKFOLBIkfw5ea54Zpr/vo
	mUsH4GAgdcx7V7MYs72QgHqy2NxjRn24z5eQPB5iGbBuURThMzrTtEUDmk4ZDrCWzJoH3e
	bKRQWecMGrpLKwGTTODSXpFOOtQ/kf8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFADF2681;
	Tue,  9 Jun 2026 00:35:29 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7F5D3FE53;
	Tue,  9 Jun 2026 00:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780990534; bh=t7LyY66ObPUhmzXfpHxNBogsKJvH4OAwhcmhM1yZypY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gvrdzP3yuN0iknaXSdc/FlxI4W4atfnPrROM7UXc3JyCAW05aG6EFxqt9Nmt8CZk+
	 UjNgO8vj9kLD+x6LjTsxROVb8i27zGOQWX7Rjl5ezK7jrqbqccFqUfwM4x8PLQ6TUk
	 m7K1ys3EexmsiTzbpn2lGl2WkrUy4DXq/Mug064I=
Date: Tue, 9 Jun 2026 08:35:29 +0100
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
Message-ID: <aifCQbaAZLkH2GJY@e129823.arm.com>
References: <202606022131.112319f2-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202606022131.112319f2-lkp@intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C69DC180009
X-Stat-Signature: mgia4siu1gkj476zc1543k856i7p7mpy
X-Rspam-User: 
X-HE-Tag: 1780990535-924110
X-HE-Meta: U2FsdGVkX18b/IeJNeaMrvqNlwgV7Ukaoja+Qngs6CRl4KMHCQ7RKodZty3jo8dhsARn1BUWFwbLhu4zxSatDCBSNeV61nY5D/d0FRBMG8/O7tzf7OuPKnQJfHgFBYcjOkDQRoock78tAItlF7oBuITlEE7lzm/WQhUrFJT/aBWE6LV7cHWMjv/vNmFlGS9tK0sF2sxbpZj1OAGuf5Vo+tXg+mT4FP1eAzDr50j4Lf+BkVunJ8KcL1pNeVIjo3PJ4WemLdX7ycbePVeS2n2CGK5tds00KMqUttpHmJc77z1swmnSFo1eOxTGCQuvSuZjG6gMcSCbS9D9Y0NkvDWV0tNIAJ+VU6FXmaPEwz8Ku/0osbXewuCqMZTeoZ5FGCtogPZrgYnMZpNHtrsV9D6rrxDc2NtyznAAtEPnzX1WCZ9uMwpQnQE+HsMJyZpCS3p7XO+OZJKFnAbuEcMVa0A1z3G1BcwlSaVJdXNGVxgzDCzzMFmD9Cc3NErx9Q5g04n9ZXWiB1E4vdTEkDUJpXgdu8zRSoFsWMpTJ0BoLIqkocSJHyxAYlBAcQdhar2WiNDh5RX0f+XpBwYOZw46wxJFTDdFceNVilNw2MdwVFARz3sgHtZecwqxGIZz8wD85lw/nXZKJvAE9k26WFQEoJWO6F+dmND3DA06AVjBJlZOv41aZ+NlmfRR/RuBnf9r97ELSq4zFvEnKSHGkQEw7KnGgywo6hgME+4ql+i/WuJ1/Jjvdf9+76f2BSRSYceib1jZVh0iB/mnrn7NkQurGEGf5+BZqF7GRXQNiM8+9s7u/unbw7jwVSiWGf1xg0jM+xV++YnvkL5froAdTkbB3OASpenOcO9bYFmYvS/xRi7TGCZqnbD7WEA3z6f27EWwqnFXVwCDp1Vkv/AmnLVSc0F3l8kxrKrpuLky16fAaCYLUKABHn1y7sS5JVRxm4Ij+iL2PnBdbfmgMRcCC4z19SN
 RslsVmXH
 7t6hZq1Wzd419w6HImAytTca5uQcvtixnq/sza5e7cPzjtwkWDrf98DogLunSTqlJsgoelhjmwZ8DacZEnbInZHd1eWkL9asIU1OCR+ZChWlzeEWsDJZQf1RsbszFSx1qoyEd3s6D+KKaJxjyVktafa5PmwlvN+00VPCZnOcDAALqG2NPyqOBhhEHJdNV+njfLbsaA9F3DLsyZz66k0v6pUR5YI+BHbNFTGp2plIzR3c1IhI2Twd8K19tyMlbFDC/YQHiMgDn0+GLSBMYhSI2ksRSMlZlnWs6dJJOMmwU1k4oEGQVNipFs3Fe1v+XJP/nsR9J/eLTcy3ocVNgLQwz5JBcW3XpdR64ppFs9VmeDRbtNZ8yZiFXVFsa7RCy/gZ+kMKV6Qc14kTSl7MyI1s3u+1JcI7yFzSwsCrrI8pOFXnNzzKsr3jRqDzjL5fufZCrA8PFJOULQ75mqmjqlJ7rIE3fIeJbnbhOzkbk4McxLLNhu5wow7btqfuD5SzO7z43KA6I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> 
> Hello,
> 
> kernel test robot noticed a 7.2% regression of stress-ng.shm.ops_per_sec on:
> 
> 
> commit: 60ced5818f64ac356620d1ad3e0d473c457dbf5b ("vmalloc: optimize vfree with free_pages_bulk()")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [still regression on linux-next/master 7da7f07112610a520567421dd2ffcb51beaefbcc]
> 
> testcase: stress-ng
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
> parameters:
> 
> 	nr_threads: 100%
> 	testtime: 60s
> 	test: shm
> 	cpufreq_governor: performance
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202606022131.112319f2-lkp@intel.com
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260602/202606022131.112319f2-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp3/shm/stress-ng/60s
> 
> commit: 
>   4aa4abf1f1 ("mm/page_alloc: optimize free_contig_range()")
>   60ced5818f ("vmalloc: optimize vfree with free_pages_bulk()")
> 
> 4aa4abf1f14bd6d0 60ced5818f64ac356620d1ad3e0 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>    1103082            -7.2%    1024016        stress-ng.shm.ops
>      18394            -7.2%      17072        stress-ng.shm.ops_per_sec
>    2084775           -23.1%    1602693 ±  3%  stress-ng.time.involuntary_context_switches
>  3.076e+08            -7.3%  2.852e+08        stress-ng.time.minor_page_faults
>      14759           -21.1%      11646        stress-ng.time.percent_of_cpu_this_job_got
>       8806           -21.1%       6946        stress-ng.time.system_time
>      86.08            -7.5%      79.66        stress-ng.time.user_time
>    2799689            -1.3%    2762252        stress-ng.time.voluntary_context_switches
>  1.125e+09 ±  6%     +42.3%  1.601e+09 ± 13%  cpuidle..time
>    2089564 ±  3%     +25.6%    2624591 ±  2%  cpuidle..usage
>     360.33           -22.5%     279.35 ± 44%  turbostat.PkgWatt
>      36.35           -22.6%      28.12 ± 44%  turbostat.RAMWatt
>     198.28 ±  2%      +9.2%     216.55        vmstat.procs.r
>     131962            -6.3%     123686        vmstat.system.cs
>   14039730 ±  2%     -18.1%   11503879 ± 18%  numa-meminfo.node0.MemUsed
>     175943 ± 13%    +114.1%     376780 ±  2%  numa-meminfo.node0.PageTables
>     184811 ± 13%    +105.7%     380127 ±  4%  numa-meminfo.node1.PageTables
>       9.32 ±  5%      +3.2       12.57 ± 11%  mpstat.cpu.all.idle%
>       3.69 ±  9%      +5.6        9.29 ±  4%  mpstat.cpu.all.soft%
>      85.37            -8.6       76.73        mpstat.cpu.all.sys%
>       1.38            -0.2        1.19 ±  3%  mpstat.cpu.all.usr%
>  4.555e+08            -7.4%  4.216e+08        numa-numastat.node0.local_node
>  4.557e+08            -7.5%  4.217e+08        numa-numastat.node0.numa_hit
>  4.493e+08            -6.8%  4.187e+08        numa-numastat.node1.local_node
>  4.494e+08            -6.8%  4.189e+08        numa-numastat.node1.numa_hit
>     193547            +7.4%     207908 ±  3%  perf-stat.i.cpu-clock
>     193547            +7.4%     207908 ±  3%  perf-stat.i.task-clock
>     135837            -8.5%     124266 ±  2%  perf-stat.ps.context-switches
>    5141774           -11.4%    4555341 ±  2%  perf-stat.ps.minor-faults
>    5141776           -11.4%    4555343 ±  2%  perf-stat.ps.page-faults
>     194174           +12.8%     219047        meminfo.KReclaimable
>   24232028            -8.6%   22159275        meminfo.Memused
>     354997 ± 14%    +111.6%     751255 ±  4%  meminfo.PageTables
>     194174           +12.8%     219047        meminfo.SReclaimable
>     563220           +16.5%     656030        meminfo.SUnreclaim
>     757395           +15.5%     875078        meminfo.Slab
>     350188           +11.4%     390033        meminfo.VmallocUsed
>   26142507            -9.8%   23588567        meminfo.max_used_kB
>      43483 ± 14%    +119.0%      95246 ±  2%  numa-vmstat.node0.nr_page_table_pages
>      43257 ±  3%     +12.4%      48605        numa-vmstat.node0.nr_vmalloc
>  4.557e+08            -7.5%  4.217e+08        numa-vmstat.node0.numa_hit
>  4.555e+08            -7.4%  4.216e+08        numa-vmstat.node0.numa_local
>      45890 ± 13%    +109.3%      96035 ±  4%  numa-vmstat.node1.nr_page_table_pages
>      44555 ±  4%      +9.3%      48699        numa-vmstat.node1.nr_vmalloc
>  4.494e+08            -6.8%  4.189e+08        numa-vmstat.node1.numa_hit
>  4.493e+08            -6.8%  4.187e+08        numa-vmstat.node1.numa_local
>       0.16 ± 16%    +707.7%       1.30 ± 44%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>     346.29 ± 85%   +1061.2%       4021 ± 38%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       0.16 ± 16%    +707.7%       1.30 ± 44%  perf-sched.total_sch_delay.average.ms
>     346.29 ± 85%   +1061.2%       4021 ± 38%  perf-sched.total_sch_delay.max.ms
>       7.34           +58.2%      11.61 ± 13%  perf-sched.total_wait_and_delay.average.ms
>       4478 ±  6%     +49.6%       6697 ± 20%  perf-sched.total_wait_and_delay.max.ms
>       7.18           +43.6%      10.31 ± 10%  perf-sched.total_wait_time.average.ms
>       4477 ±  5%     +29.7%       5809 ± 17%  perf-sched.total_wait_time.max.ms
>       7.34           +58.2%      11.61 ± 13%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       4478 ±  6%     +49.6%       6697 ± 20%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       7.18           +43.6%      10.31 ± 10%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       4477 ±  5%     +29.7%       5809 ± 17%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>    1975577            -4.0%    1896474        proc-vmstat.nr_active_anon
>     973349            -2.6%     947803        proc-vmstat.nr_anon_pages
>      46138            +3.1%      47546        proc-vmstat.nr_kernel_stack
>      90193 ± 14%    +110.0%     189399 ±  4%  proc-vmstat.nr_page_table_pages
>      48563           +12.8%      54769        proc-vmstat.nr_slab_reclaimable
>     140817           +16.5%     164023        proc-vmstat.nr_slab_unreclaimable
>      87646           +11.2%      97438        proc-vmstat.nr_vmalloc
>    1975576            -4.0%    1896478        proc-vmstat.nr_zone_active_anon
>  9.051e+08            -7.1%  8.406e+08        proc-vmstat.numa_hit
>  9.048e+08            -7.1%  8.403e+08        proc-vmstat.numa_local
>  9.069e+08            -7.1%  8.421e+08        proc-vmstat.pgalloc_normal
>  3.538e+08            -7.5%  3.273e+08        proc-vmstat.pgfault
>  9.061e+08            -7.1%  8.414e+08        proc-vmstat.pgfree
>      29261           -10.3%      26241        sched_debug.cfs_rq:/.avg_vruntime.avg
>       0.58 ±  5%     +13.8%       0.66 ±  4%  sched_debug.cfs_rq:/.h_nr_queued.avg
>       0.58 ±  5%     +13.4%       0.66 ±  4%  sched_debug.cfs_rq:/.h_nr_runnable.avg
>       4034 ± 33%     +53.7%       6200 ± 13%  sched_debug.cfs_rq:/.left_deadline.avg
>       4034 ± 33%     +53.7%       6200 ± 13%  sched_debug.cfs_rq:/.left_vruntime.avg
>     583523 ±  4%     +13.7%     663177 ±  4%  sched_debug.cfs_rq:/.load.avg
>       0.58 ±  5%     +13.7%       0.66 ±  4%  sched_debug.cfs_rq:/.nr_queued.avg
>      14.14 ± 22%     +45.5%      20.57 ± 15%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
>      67.99 ± 17%     +33.5%      90.77 ± 13%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
>      13.66 ± 23%     +43.0%      19.54 ± 14%  sched_debug.cfs_rq:/.removed.util_avg.avg
>      66.93 ± 17%     +31.0%      87.71 ± 14%  sched_debug.cfs_rq:/.removed.util_avg.stddev
>       4034 ± 33%     +53.7%       6200 ± 13%  sched_debug.cfs_rq:/.right_vruntime.avg
>     554.59 ±  2%      +8.7%     602.90 ±  3%  sched_debug.cfs_rq:/.runnable_avg.avg
>       1553 ±  7%     +26.1%       1959 ± 17%  sched_debug.cfs_rq:/.runnable_avg.max
>     266.15 ±  7%     +25.4%     333.85 ±  6%  sched_debug.cfs_rq:/.runnable_avg.stddev
>       0.03 ± 76%    +526.1%       0.19 ± 31%  sched_debug.cfs_rq:/.spread.avg
>       2.81 ± 88%    +377.6%      13.40 ± 48%  sched_debug.cfs_rq:/.spread.max
>       0.24 ± 77%    +426.2%       1.26 ± 34%  sched_debug.cfs_rq:/.spread.stddev
> -6.962e+10          -329.4%  1.597e+11 ± 20%  sched_debug.cfs_rq:/.sum_w_vruntime.avg
>  1.654e+12 ±112%    +407.7%  8.398e+12 ± 18%  sched_debug.cfs_rq:/.sum_w_vruntime.max
>     106852 ± 31%     +74.1%     185984 ± 11%  sched_debug.cfs_rq:/.sum_weight.avg
>      29261           -10.3%      26241        sched_debug.cfs_rq:/.zero_vruntime.avg
>     516.36 ±  3%     +85.2%     956.40 ±  3%  sched_debug.cpu.clock_task.stddev
>     551602            -7.0%     513143        sched_debug.cpu.curr->pid.max
>       0.59 ±  4%     +12.6%       0.67 ±  4%  sched_debug.cpu.nr_running.avg
>      74120 ± 14%     -29.8%      52067 ± 25%  sched_debug.cpu.nr_switches.max
>       4844 ± 18%     -36.8%       3062 ± 31%  sched_debug.cpu.nr_switches.stddev
>       0.08 ± 47%     +83.8%       0.15 ± 20%  sched_debug.cpu.nr_uninterruptible.avg
> 
> 
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Thanks. I'll check it.

-- 
Sincerely,
Yeoreum Yun

