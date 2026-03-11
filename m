Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47281125857
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB44B6B0005; Wed, 11 Mar 2026 13:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5BDA6B0089; Wed, 11 Mar 2026 13:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3CE26B008A; Wed, 11 Mar 2026 13:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD90C6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:12:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C34558505
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:12:11 +0000 (UTC)
X-FDA: 84534425262.09.521EF1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 607331C0012
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:12:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bXU1UkAN;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773249129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Krd0Ou2lcXnOcWsyAbZouxAMAXVNnl16XR99cKHpK5I=;
	b=zwhCWSINC7R6bJkn2DB4L5ozj+zB5S7QqbL72H61dHakFDyBo5SS+5EM1yWk2wrVM+Mx/H
	tEZztNVXct3VLrR4MdxUrj794QhIC8NpvSxJcomhMsFtzILT1X25ruv/zXKUovohMEY3rr
	zYqIU0hYQaggTzjnfv+PhnT1jy8qmdE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bXU1UkAN;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773249129; a=rsa-sha256;
	cv=none;
	b=7+bDorwadG8OG3pkrjUe/Xq/2GorHtF90pa+AUs6n/ZNl14v1J3Y7tOEnYIE6RX/yVKddp
	bJs4Xm2Ing7x5qMFifTCZ5YEZ61Gk3tgyGNwwU4ksDGp2G+dsOk/3+fXSofUIdpUX2lVZz
	hua6BOLFhVjcq13ttOyGLQW3jpO+Fl0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AB1A40499;
	Wed, 11 Mar 2026 17:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8A2C4CEF7;
	Wed, 11 Mar 2026 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773249128;
	bh=1qsen+BIDFcJTKG9rR5nd47KNhJgSLjAdYmUpgme+N0=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=bXU1UkANsLtiTFEqU16cMgLlWkkMfnWEC6WxvCOu4XBSuCNpDC4eJiSxWAqZBKdLL
	 ++FDtHGp5oDe7BG7QOjTg8u6g06fv3WWyv4JBtdfaPCQpHcfSmGsRNQoHLjBrHzMJp
	 lMRSNkak1Zqm7Y0nSWFlrwOpg2z5OwA8aqjCA0QcBBCzBN6KaILFNqRMKB2eaoACHO
	 NltnJMpR5uOZW0WucbnDDfomHSNi9F3JXu0eVI/8GDZ/wT2Oy3WCraaGv/S35Pjpe0
	 QF7+NhccL5GaynzkoPoNEp4XwvjuqhHt8V2A4GLpelV3QfGytNTH4CUge5kI4fbNsP
	 i0asqe+vm19CA==
Message-ID: <9b4526f4-a492-498f-97d3-0c9c6178f12a@kernel.org>
Date: Wed, 11 Mar 2026 18:12:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [linus:master] [mm/slab] fb1091febd:
 will-it-scale.per_process_ops 132.5% improvement
Content-Language: en-US
To: kernel test robot <oliver.sang@intel.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Ming Lei <ming.lei@redhat.com>, linux-mm@kvack.org,
 Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
References: <202603112232.f53ebe5d-lkp@intel.com>
In-Reply-To: <202603112232.f53ebe5d-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 607331C0012
X-Rspamd-Server: rspam07
X-Stat-Signature: wuqzigh6xs9pzxp5eizbj9imsw1bokts
X-Rspam-User: 
X-HE-Tag: 1773249129-33245
X-HE-Meta: U2FsdGVkX18/XjiAglD4+8jIuOx/s8r9egw91r4tZDLqgmVRcQxaZP1hr+c2w1fsw8OXE12n1qRk6x2Bd0F58SIkwqhHQ3jlxFWB4SHj6WiOUEy4Fa/HSQSg8jX5+VSQk3D2MWAJsILTXm2fNtJOdpmBkPHPDQcF1Kv7kRCwRv782wLnLNLg1N5/i7zLrkmKjsfpUjqStj5c3DvCS6xbXWbIo7q8mNs7HzIiABMPMV3XHa7mOZiqpj0Ueu3ssT/BgRc1GvT/W3kCOk35oG/5DBV8771tiJ58XPQLEqRgjNiLVAzE4QColC24o3wdGVm3s1ScnWhDS3vZsCCmpuiyaLdUz/YDBAMBYSK1E+8+B5b+fuy7JmrLXj73LHr/gWj24bu3VQmovPXaBuQ2hyEZVHx5AH1oKM3VgpYdhTU0mAgFB2JzPx/LUIi4AQRo5b9r7mN/c1ns3eqifUrFbFHKE3wzhdixihhCCvvphFR7e1WxiqXBBjPKlVSD6lxTozOohvCLWYPRojhM/ykaFfw81kC6Rf4Yu7mdkqcw6MX66B62BA3cZWp2wPz1ZaHUK5Jl43KMMtHbfvjOSmgt+LyuIL88hdhAl3lNlR87bT4nuTU1eZa+5LgbqH5HNn9lPSeE8010D0xDNbmtq50/J40Zmp1tKfAa753kgbXgWKCntDfLSoVaKuLzIq8Dfo0ymldtbiG84IcKExfgXjfV3nsS4QtLu3xINnxoATRDjawG/fJN7ipDF4p/nXjOGOTORLTvq3kvXwwxTXSsFUiZ5BTyJbteZrseZDvAhlt9C5SA/aIqQqbpM7rdAKI4eOUQBt5RQRh26Vm2KTUvd5dw22NbWw9DyW2BWfJUeu0+IkjUXKOM969atvwQahc9rxjorkbtvfxiAuZ6GujsrDqHhesQiAANRDBm2aGRv5cYDJqqXHzmiJOJO5ZIYP5hwu2tJiBNakDbf7zDMWcZVhr4heg
 ap867unN
 SP5xlQhEQJmCBAKoiCSPAq2SVAN6ge1nnJwHPE07UCicCwftyefaIeAjGN8yT3ofG+R19/e7m0k/3byXEFY/UeTqmph8OOqGsvClk8CY8gH67LQYj8rjkQUM4bR3i0AO2dQ3TO+wLypi7mUpblAqh4WQfT4Q64HJHFD6rbZTiP59sAWklc0wlR3HtVSQ5RkPZcicAiyyrQFwFBQbgrAZXPZAC+t2HFPgp21VydVC/B4tg0b86UUSf1sDl03fPdbRpGwLJHQDgBjagFI68VUqH+5a0fQ4csK6U6QGH6S1UbqFVKWAfvQMdoTLlkcExSuQyGv06Tp6Zq6fdUtUb/yYaiv7rUw9Tk1YTxFDuGySqfTeQdphejbD/7ZhHd5VCdFQJXDJ9UVDWGJ+5BZfh60tsycOWSCWs1AYfI1211XVA2/nJeiNkAmsHhlTLoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 15:51, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 132.5% improvement of will-it-scale.per_process_ops on:
> 
> 
> commit: fb1091febd668398aa84c161b8d9a1834321e021 ("mm/slab: allow sheaf refill if blocking is not allowed")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

+CC more people

> testcase: will-it-scale
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
> parameters:
> 
> 	nr_task: 100%
> 	mode: process
> 	test: brk1
> 	cpufreq_governor: performance
> 
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260311/202603112232.f53ebe5d-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
>   gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/brk1/will-it-scale
> 
> commit: 
>   48647d3f9a ("slab: distinguish lock and trylock for sheaf_flush_main()")
>   fb1091febd ("mm/slab: allow sheaf refill if blocking is not allowed")
> 
> 48647d3f9a644d1e fb1091febd668398aa84c161b8d 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>    9079134          +132.5%   21109974        will-it-scale.48.processes
>     189148          +132.5%     439790        will-it-scale.per_process_ops
>    9079134          +132.5%   21109974        will-it-scale.workload
>       5.83          +246.4%      20.21        vmstat.cpu.us
>    5015917           +17.1%    5875075        vmstat.memory.cache
>       1452 ±  2%    +506.2%       8801 ±  2%  vmstat.system.cs
>       1.17            +0.1        1.29        mpstat.cpu.all.irq%
>       2.92 ±  2%      +1.9        4.77 ±  3%  mpstat.cpu.all.soft%
>      89.32           -16.2       73.08        mpstat.cpu.all.sys%
>       5.98           +14.3       20.26        mpstat.cpu.all.usr%
>     172.58            +5.3%     181.69        turbostat.CorWatt
>       0.24           +58.3%       0.38        turbostat.IPC
>     202.24            +5.4%     213.25        turbostat.PkgWatt
>      12.35           +67.0%      20.63        turbostat.RAMWatt
>     200.00 ±  9%     +86.8%     373.67 ±  7%  perf-c2c.DRAM.local
>     145.83 ±  9%     -45.7%      79.17 ± 16%  perf-c2c.DRAM.remote
>       8096 ±  4%     -94.1%     479.33 ±  4%  perf-c2c.HITM.local
>     141.17 ±  8%     -74.5%      36.00 ± 24%  perf-c2c.HITM.remote
>       8237 ±  4%     -93.7%     515.33 ±  5%  perf-c2c.HITM.total
>       0.57 ±  9%     -66.6%       0.19 ±  3%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       0.57 ±  9%     -66.6%       0.19 ±  3%  perf-sched.total_sch_delay.average.ms
>      53.40 ± 10%     -61.9%      20.35 ±  5%  perf-sched.total_wait_and_delay.average.ms
>       9605 ± 11%    +309.7%      39354 ±  5%  perf-sched.total_wait_and_delay.count.ms
>      52.83 ± 10%     -61.8%      20.16 ±  5%  perf-sched.total_wait_time.average.ms
>      53.40 ± 10%     -61.9%      20.35 ±  5%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       9605 ± 11%    +309.7%      39354 ±  5%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
>      52.83 ± 10%     -61.8%      20.16 ±  5%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       0.18 ± 13%    +333.5%       0.79        perf-stat.i.MPKI
>  1.089e+10           +48.8%  1.621e+10        perf-stat.i.branch-instructions
>   44860845           +49.9%   67266443        perf-stat.i.branch-misses
>       4.26 ± 13%     +32.4       36.65        perf-stat.i.cache-miss-rate%
>    9391325 ± 13%    +582.9%   64131079        perf-stat.i.cache-misses
>   2.22e+08           -21.2%  1.749e+08        perf-stat.i.cache-references
>       1418 ±  2%    +521.6%       8819 ±  2%  perf-stat.i.context-switches
>       2.77           -36.9%       1.75        perf-stat.i.cpi
>     196.34 ±  2%      -5.8%     184.90 ±  4%  perf-stat.i.cpu-migrations
>      18904 ± 14%     -88.2%       2224        perf-stat.i.cycles-between-cache-misses
>  5.131e+10           +58.3%   8.12e+10        perf-stat.i.instructions
>       0.36           +58.0%       0.57        perf-stat.i.ipc
>     363.96 ±  4%     +28.2%     466.62 ±  6%  perf-stat.i.minor-faults
>     363.98 ±  4%     +28.2%     466.65 ±  6%  perf-stat.i.page-faults
>       0.18 ± 13%    +331.0%       0.79        perf-stat.overall.MPKI
>       4.24 ± 13%     +32.4       36.66        perf-stat.overall.cache-miss-rate%
>       2.77           -36.8%       1.75        perf-stat.overall.cpi
>      15320 ± 11%     -85.6%       2213        perf-stat.overall.cycles-between-cache-misses
>       0.36           +58.3%       0.57        perf-stat.overall.ipc
>    1704731           -32.0%    1158643        perf-stat.overall.path-length
>  1.086e+10           +48.7%  1.615e+10        perf-stat.ps.branch-instructions
>   44644009           +50.1%   67000848        perf-stat.ps.branch-misses
>    9377842 ± 13%    +581.8%   63942004        perf-stat.ps.cache-misses
>  2.214e+08           -21.2%  1.744e+08        perf-stat.ps.cache-references
>       1412 ±  2%    +522.3%       8787 ±  2%  perf-stat.ps.context-switches
>     195.57 ±  2%      -5.8%     184.17 ±  3%  perf-stat.ps.cpu-migrations
>  5.115e+10           +58.2%  8.093e+10        perf-stat.ps.instructions
>     362.16 ±  4%     +28.3%     464.76 ±  6%  perf-stat.ps.minor-faults
>     362.18 ±  4%     +28.3%     464.78 ±  6%  perf-stat.ps.page-faults
>  1.548e+13           +58.0%  2.446e+13        perf-stat.total.instructions
>      62.33           -62.3        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_from_partial_node.___slab_alloc.kmem_cache_alloc_noprof.mas_store_gfp
>      61.50           -61.5        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_from_partial_node.___slab_alloc.kmem_cache_alloc_noprof
>      33.79           -33.8        0.00        perf-profile.calltrace.cycles-pp.___slab_alloc.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
>      33.71           -33.7        0.00        perf-profile.calltrace.cycles-pp.get_from_partial_node.___slab_alloc.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
>      33.24           -33.2        0.00        perf-profile.calltrace.cycles-pp.___slab_alloc.kmem_cache_alloc_noprof.mas_store_gfp.do_brk_flags.__do_sys_brk
>      33.16           -33.2        0.00        perf-profile.calltrace.cycles-pp.get_from_partial_node.___slab_alloc.kmem_cache_alloc_noprof.mas_store_gfp.do_brk_flags

Seems like mas_store_gfp is doing those allocations that don't allow
blocking and thus were impacted. I see it calling mas_wr_preallocate()
and that doing mas_alloc_nodes(mas, GFP_NOWAIT);

This was AFAICS introduced by 9b05890a25d9 ("maple_tree: Prefilled sheaf
conversion and testing").

I vaguely recall we mighth have discussed this, but it's unclear to me, why
e.g. a perfectly cromulent do_brk_flags -> vma_iter_store_gfp(GFP_KERNEL) ->
mas_store(GFP_KERNEL) results in GFP_NOWAIT allocation.

Here mas_alloc_nodes() AFAIU allocates only one node via mt_alloc_one() and
results in a slowpath instead of sheaf refill. But that slowpath could fail
due to lack of reclaim? Or if we needed more nodes and did
mt_get_sheaf(GFP_NOWAIT), we could be failing too?

Oh I see, mas_nomem(actual_gfp) would have handled that, IIUC. So it was
just a potential performance issue. Maybe it explains some of the
regressions reports we saw for will-it-scale and attributed to the loss of
double caching with cpu (partial) slabs.

TL;DR should be fine now, but it means fb1091febd66 ("mm/slab: allow sheaf
refill if blocking is not allowed") is an even more important perf fix than
we thought.

>      34.48           -31.5        3.02 ±  9%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
>      33.95           -31.2        2.74 ± 10%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_store_gfp.do_brk_flags.__do_sys_brk.do_syscall_64
>      37.06           -25.9       11.12 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_gfp.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      37.65           -25.8       11.83 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      90.38           -21.0       69.37        perf-profile.calltrace.cycles-pp.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
>      91.24           -19.1       72.10        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
>      91.43           -18.8       72.66        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.brk
>      41.96           -15.8       26.12        perf-profile.calltrace.cycles-pp.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
>      45.03           -12.0       33.08        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
>       2.01 ±  4%      -1.1        0.91 ±  3%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
>       1.98 ±  4%      -1.1        0.90 ±  4%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
>      99.45            -1.0       98.44        perf-profile.calltrace.cycles-pp.brk
>       1.81 ±  5%      -1.0        0.86 ±  4%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
>       1.50 ±  6%      -0.8        0.74 ±  4%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
>       1.25 ±  7%      -0.7        0.55 ±  5%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
>       0.00            +0.5        0.52        perf-profile.calltrace.cycles-pp.security_mmap_addr.__get_unmapped_area.check_brk_limits.__do_sys_brk.do_syscall_64
>       0.00            +0.5        0.52        perf-profile.calltrace.cycles-pp.mas_find.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
>       0.00            +0.6        0.56        perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
>       0.00            +0.6        0.56 ±  5%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_brk_flags
>       0.00            +0.6        0.56 ±  3%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
>       0.00            +0.6        0.58 ± 12%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
>       0.00            +0.6        0.58        perf-profile.calltrace.cycles-pp.arch_exit_to_user_mode_prepare.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
>       0.00            +0.6        0.58 ± 12%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
>       0.00            +0.6        0.58 ± 12%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
>       0.00            +0.6        0.58 ± 12%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
>       0.58 ±  2%      +0.6        1.17 ±  2%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_brk_flags.__do_sys_brk
>       0.00            +0.6        0.61        perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_gfp.do_brk_flags.__do_sys_brk
>       0.00            +0.6        0.61 ± 11%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
>       0.00            +0.6        0.62        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.__get_unmapped_area.check_brk_limits.__do_sys_brk.do_syscall_64
>       0.00            +0.6        0.63 ±  2%  perf-profile.calltrace.cycles-pp.static_key_count.security_vm_enough_memory_mm.do_brk_flags.__do_sys_brk.do_syscall_64
>       0.00            +0.7        0.67 ±  6%  perf-profile.calltrace.cycles-pp.queue_event.ordered_events__queue.process_simple.reader__read_event.perf_session__process_events
>       0.00            +0.7        0.68 ±  7%  perf-profile.calltrace.cycles-pp.ordered_events__queue.process_simple.reader__read_event.perf_session__process_events.record__finish_output
>       0.00            +0.7        0.68        perf-profile.calltrace.cycles-pp.can_vma_merge_left.vma_merge_new_range.do_brk_flags.__do_sys_brk.do_syscall_64
>       0.00            +0.7        0.68 ± 11%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
>       0.00            +0.7        0.68 ± 11%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
>       0.00            +0.7        0.68 ± 11%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
>       0.00            +0.7        0.72 ±  6%  perf-profile.calltrace.cycles-pp.process_simple.reader__read_event.perf_session__process_events.record__finish_output.cmd_record
>       0.00            +0.8        0.77        perf-profile.calltrace.cycles-pp.__vma_start_exclude_readers.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
>       0.62            +0.9        1.49        perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
>       0.00            +0.9        0.87 ±  6%  perf-profile.calltrace.cycles-pp.perf_event_mmap_output.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.do_brk_flags
>       0.00            +0.9        0.88        perf-profile.calltrace.cycles-pp.pte_offset_map_lock.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
>       0.00            +0.9        0.92 ±  3%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.brk
>       0.00            +0.9        0.92 ±  4%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.brk
>       0.00            +0.9        0.93 ±  3%  perf-profile.calltrace.cycles-pp.down_write_killable.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
>       0.00            +1.0        0.96        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_store_gfp.do_brk_flags.__do_sys_brk.do_syscall_64
>       0.00            +1.0        0.97        perf-profile.calltrace.cycles-pp.vma_merge_new_range.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       0.00            +1.0        1.02 ±  3%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.brk
>       0.55 ±  2%      +1.0        1.57        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
>       0.00            +1.0        1.02 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.brk
>       0.44 ± 44%      +1.0        1.48        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
>       0.00            +1.1        1.05        perf-profile.calltrace.cycles-pp.memcpy_orig.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
>       0.00            +1.1        1.10        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
>       0.57            +1.1        1.67        perf-profile.calltrace.cycles-pp.security_vm_enough_memory_mm.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       0.52 ±  5%      +1.1        1.65 ±  4%  perf-profile.calltrace.cycles-pp.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
>       0.00            +1.1        1.13        perf-profile.calltrace.cycles-pp.memcpy_orig.mas_wr_node_store.mas_store_gfp.do_brk_flags.__do_sys_brk
>       0.00            +1.1        1.13 ±  6%  perf-profile.calltrace.cycles-pp.reader__read_event.perf_session__process_events.record__finish_output.cmd_record
>       0.00            +1.1        1.13 ±  6%  perf-profile.calltrace.cycles-pp.perf_session__process_events.record__finish_output.cmd_record
>       0.00            +1.1        1.13 ±  5%  perf-profile.calltrace.cycles-pp.cmd_record
>       0.00            +1.1        1.13 ±  5%  perf-profile.calltrace.cycles-pp.record__finish_output.cmd_record
>       0.00            +1.1        1.14        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
>       0.00            +1.1        1.15        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
>       0.58 ±  3%      +1.2        1.76 ±  3%  perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_alloc.do_brk_flags.__do_sys_brk
>       0.55            +1.2        1.74        perf-profile.calltrace.cycles-pp.check_brk_limits.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
>       0.00            +1.2        1.21        perf-profile.calltrace.cycles-pp.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
>       0.68 ±  2%      +1.2        1.92        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.unmap_region
>       0.34 ± 70%      +1.3        1.61        perf-profile.calltrace.cycles-pp.__get_unmapped_area.check_brk_limits.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       0.00            +1.3        1.32        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
>       0.84 ±  2%      +1.5        2.36        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
>       0.00            +1.6        1.55 ± 16%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_brk_flags
>       0.77 ±  4%      +1.6        2.42 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
>       0.00            +1.7        1.74 ± 16%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_brk_flags.__do_sys_brk
>       0.89 ±  2%      +1.8        2.68 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.do_brk_flags.__do_sys_brk.do_syscall_64
>       0.00            +1.8        1.79 ± 13%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
>       0.65 ±  6%      +1.9        2.56 ±  2%  perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.do_brk_flags.__do_sys_brk
>       0.00            +2.0        2.01 ± 13%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
>       1.06 ±  2%      +2.0        3.07        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       1.08            +2.2        3.26        perf-profile.calltrace.cycles-pp.vm_area_alloc.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       0.60            +2.4        2.97        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_safe_stack.brk
>       1.31            +2.4        3.70        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
>       1.31 ±  2%      +2.5        3.86        perf-profile.calltrace.cycles-pp.mas_find.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
>       0.00            +2.9        2.94        perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
>       1.65            +3.1        4.74        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
>       1.32 ±  2%      +3.2        4.49        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.do_brk_flags.__do_sys_brk.do_syscall_64
>       1.53 ±  2%      +3.6        5.12        perf-profile.calltrace.cycles-pp.perf_event_mmap.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       1.82 ±  2%      +3.6        5.41        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.brk
>       1.60            +3.7        5.28        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.brk
>       2.30            +3.9        6.18        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_brk_flags.__do_sys_brk.do_syscall_64
>       2.30            +4.1        6.38        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
>       2.52            +4.7        7.20        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
>       2.61            +5.0        7.56        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       3.36            +6.7       10.02        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.brk
>       4.40            +8.2       12.62        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      67.04           -67.0        0.00        perf-profile.children.cycles-pp.___slab_alloc
>      66.95           -67.0        0.00        perf-profile.children.cycles-pp.get_from_partial_node
>      63.85           -61.7        2.16 ±  5%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
>      62.92           -61.3        1.64 ±  7%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
>      69.33           -60.9        8.46        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
>      75.21           -50.8       24.39        perf-profile.children.cycles-pp.mas_store_gfp
>      90.42           -20.9       69.48        perf-profile.children.cycles-pp.__do_sys_brk
>      91.30           -19.1       72.18        perf-profile.children.cycles-pp.do_syscall_64
>      91.49           -18.8       72.73        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
>      42.00           -15.8       26.24        perf-profile.children.cycles-pp.do_brk_flags
>      45.05           -11.9       33.12        perf-profile.children.cycles-pp.do_vmi_align_munmap
>       2.43 ±  4%      -2.3        0.15 ±  3%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
>      99.67            -1.8       97.90        perf-profile.children.cycles-pp.brk
>       0.29 ±  3%      -0.1        0.19 ±  3%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
>       0.16 ±  4%      -0.1        0.10 ±  5%  perf-profile.children.cycles-pp.barn_put_full_sheaf
>       0.09 ±  5%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.task_tick_fair
>       0.05            +0.0        0.09 ±  4%  perf-profile.children.cycles-pp.mas_nomem
>       0.26            +0.0        0.31 ±  4%  perf-profile.children.cycles-pp.tick_nohz_handler
>       0.23 ±  2%      +0.0        0.28 ±  4%  perf-profile.children.cycles-pp.update_process_times
>       0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.__x86_indirect_thunk_rax
>       0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.arch_vma_name
>       0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.memset_orig
>       0.00            +0.1        0.06 ± 13%  perf-profile.children.cycles-pp.process_one_work
>       0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.unlink_file_vma_batch_add
>       0.00            +0.1        0.06 ± 11%  perf-profile.children.cycles-pp.worker_thread
>       0.34            +0.1        0.40 ±  3%  perf-profile.children.cycles-pp.__hrtimer_run_queues
>       0.00            +0.1        0.06        perf-profile.children.cycles-pp.__mt_destroy
>       0.00            +0.1        0.06        perf-profile.children.cycles-pp.__schedule
>       0.40            +0.1        0.46 ±  3%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
>       0.40            +0.1        0.46 ±  3%  perf-profile.children.cycles-pp.hrtimer_interrupt
>       0.00            +0.1        0.06 ± 11%  perf-profile.children.cycles-pp.evlist__event2evsel
>       0.00            +0.1        0.06 ± 11%  perf-profile.children.cycles-pp.evlist__parse_sample
>       0.08            +0.1        0.14 ±  4%  perf-profile.children.cycles-pp.barn_get_empty_sheaf
>       0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.schedule
>       0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.unlink_file_vma_batch_init
>       0.06 ±  6%      +0.1        0.13 ±  2%  perf-profile.children.cycles-pp.remove_vma
>       0.00            +0.1        0.07 ± 10%  perf-profile.children.cycles-pp.flush_tlb_batched_pending
>       0.00            +0.1        0.07 ± 14%  perf-profile.children.cycles-pp.finish_rcuwait
>       0.00            +0.1        0.07        perf-profile.children.cycles-pp.build_id_parse_nofault
>       0.00            +0.1        0.07 ±  6%  perf-profile.children.cycles-pp.__refill_objects_any
>       0.00            +0.1        0.08 ±  4%  perf-profile.children.cycles-pp.unlink_file_vma_batch_final
>       0.00            +0.1        0.08 ±  4%  perf-profile.children.cycles-pp._raw_spin_unlock
>       0.00            +0.1        0.08 ±  5%  perf-profile.children.cycles-pp.__call_rcu_common
>       0.02 ±142%      +0.1        0.11 ± 12%  perf-profile.children.cycles-pp.map__new
>       0.06 ±  9%      +0.1        0.15 ±  3%  perf-profile.children.cycles-pp.__pte_offset_map
>       0.00            +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
>       0.00            +0.1        0.10 ±  6%  perf-profile.children.cycles-pp.ksm_vma_flags
>       0.07            +0.1        0.17 ±  2%  perf-profile.children.cycles-pp.mas_next_setup
>       0.02 ±141%      +0.1        0.12 ±  5%  perf-profile.children.cycles-pp.userfaultfd_unmap_prep
>       0.05 ± 47%      +0.1        0.16 ± 10%  perf-profile.children.cycles-pp.brk@plt
>       0.06 ± 13%      +0.1        0.18 ±  4%  perf-profile.children.cycles-pp.mm_get_unmapped_area_vmflags
>       0.06 ±  7%      +0.1        0.18 ±  2%  perf-profile.children.cycles-pp.unlink_anon_vmas
>       0.02 ±141%      +0.1        0.14 ± 11%  perf-profile.children.cycles-pp.__x86_indirect_thunk_r12
>       0.08 ±  4%      +0.1        0.22 ±  4%  perf-profile.children.cycles-pp.cap_vm_enough_memory
>       0.08 ±  4%      +0.1        0.22 ±  6%  perf-profile.children.cycles-pp.__x64_sys_brk
>       0.08 ±  5%      +0.1        0.23 ±  2%  perf-profile.children.cycles-pp.strlen
>       0.00            +0.2        0.15        perf-profile.children.cycles-pp.__kmalloc_noprof
>       0.10 ±  3%      +0.2        0.25 ±  2%  perf-profile.children.cycles-pp.__pi_memcpy
>       0.00            +0.2        0.16 ±  3%  perf-profile.children.cycles-pp.__alloc_empty_sheaf
>       0.07 ±  6%      +0.2        0.23 ±  8%  perf-profile.children.cycles-pp.testcase
>       0.07 ± 12%      +0.2        0.24 ±  4%  perf-profile.children.cycles-pp.is_vmalloc_addr
>       0.07 ± 84%      +0.2        0.23 ± 13%  perf-profile.children.cycles-pp.machine__process_mmap2_event
>       0.09 ±  5%      +0.2        0.25 ±  3%  perf-profile.children.cycles-pp.free_pgd_range
>       0.09 ±  5%      +0.2        0.27 ±  2%  perf-profile.children.cycles-pp.__account_obj_stock
>       0.00            +0.2        0.19 ±  9%  perf-profile.children.cycles-pp.setup_object
>       0.10 ±  6%      +0.2        0.29 ±  7%  perf-profile.children.cycles-pp.cap_capable
>       0.10 ±  3%      +0.2        0.29 ±  2%  perf-profile.children.cycles-pp.is_mergeable_anon_vma
>       0.09            +0.2        0.29        perf-profile.children.cycles-pp.may_expand_vm
>       0.12 ±  9%      +0.2        0.32 ±  4%  perf-profile.children.cycles-pp.x64_sys_call
>       0.12 ±  4%      +0.2        0.33        perf-profile.children.cycles-pp.userfaultfd_unmap_complete
>       0.12 ±  6%      +0.2        0.34 ±  7%  perf-profile.children.cycles-pp.vm_get_page_prot
>       0.00            +0.2        0.23 ±  9%  perf-profile.children.cycles-pp.shuffle_freelist
>       0.13 ±  6%      +0.2        0.36 ±  6%  perf-profile.children.cycles-pp.percpu_counter_add_batch
>       0.11 ±  5%      +0.2        0.34 ±  2%  perf-profile.children.cycles-pp.strnlen
>       0.18 ±  2%      +0.2        0.41 ±  3%  perf-profile.children.cycles-pp.vm_area_free
>       0.10 ±  3%      +0.2        0.34        perf-profile.children.cycles-pp.unmap_single_vma
>       0.34            +0.2        0.58 ±  4%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
>       0.11 ± 85%      +0.2        0.34 ± 13%  perf-profile.children.cycles-pp.perf_session__deliver_event
>       0.14 ±  4%      +0.3        0.40        perf-profile.children.cycles-pp.tlb_finish_mmu
>       0.00            +0.3        0.26 ±  8%  perf-profile.children.cycles-pp.allocate_slab
>       0.13 ±  2%      +0.3        0.39        perf-profile.children.cycles-pp.__vm_enough_memory
>       0.14 ±  2%      +0.3        0.40 ±  2%  perf-profile.children.cycles-pp.up_write
>       0.16 ±  2%      +0.3        0.43        perf-profile.children.cycles-pp.mas_wr_store_entry
>       0.12 ± 85%      +0.3        0.39 ± 12%  perf-profile.children.cycles-pp.__ordered_events__flush
>       0.13 ±  3%      +0.3        0.40        perf-profile.children.cycles-pp.downgrade_write
>       0.15 ±  2%      +0.3        0.42        perf-profile.children.cycles-pp.mas_prev_setup
>       0.11 ± 85%      +0.3        0.39 ± 11%  perf-profile.children.cycles-pp.perf_session__process_user_event
>       0.16 ±  2%      +0.3        0.46 ±  3%  perf-profile.children.cycles-pp._raw_spin_lock
>       0.16 ±  3%      +0.3        0.47 ±  4%  perf-profile.children.cycles-pp.kfree
>       0.16 ±  4%      +0.3        0.46        perf-profile.children.cycles-pp.mas_prev_range
>       0.18 ±  2%      +0.3        0.48        perf-profile.children.cycles-pp.mas_next_range
>       0.17 ±  2%      +0.3        0.48 ±  2%  perf-profile.children.cycles-pp.tlb_gather_mmu
>       0.15 ±  2%      +0.3        0.46        perf-profile.children.cycles-pp.cap_mmap_addr
>       0.17            +0.3        0.48        perf-profile.children.cycles-pp.sized_strscpy
>       0.14 ±  8%      +0.3        0.46 ± 13%  perf-profile.children.cycles-pp.obj_cgroup_charge_account
>       0.18 ±  2%      +0.3        0.51        perf-profile.children.cycles-pp.up_read
>       0.18 ±  2%      +0.4        0.55        perf-profile.children.cycles-pp.security_mmap_addr
>       0.21 ±  2%      +0.4        0.60        perf-profile.children.cycles-pp.mas_prev
>       0.21            +0.4        0.60        perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
>       0.19 ±  3%      +0.4        0.63        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
>       0.17 ±  9%      +0.4        0.60 ± 13%  perf-profile.children.cycles-pp.refill_obj_stock
>       0.25            +0.4        0.70        perf-profile.children.cycles-pp.can_vma_merge_left
>       0.22 ±  2%      +0.5        0.67        perf-profile.children.cycles-pp.static_key_count
>       0.24 ±  3%      +0.5        0.76        perf-profile.children.cycles-pp.mas_leaf_max_gap
>       0.31 ±  2%      +0.6        0.90        perf-profile.children.cycles-pp.pte_offset_map_lock
>       0.00            +0.6        0.58 ± 12%  perf-profile.children.cycles-pp.run_ksoftirqd
>       0.06 ± 87%      +0.6        0.67 ±  6%  perf-profile.children.cycles-pp.queue_event
>       0.00            +0.6        0.61 ± 11%  perf-profile.children.cycles-pp.smpboot_thread_fn
>       0.06 ± 90%      +0.6        0.68 ±  7%  perf-profile.children.cycles-pp.ordered_events__queue
>       0.31 ±  2%      +0.6        0.93 ±  2%  perf-profile.children.cycles-pp.__vma_start_exclude_readers
>       0.30 ±  4%      +0.6        0.93 ±  3%  perf-profile.children.cycles-pp.down_write_killable
>       0.50 ±  2%      +0.6        1.14 ±  4%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
>       0.35            +0.6        1.00        perf-profile.children.cycles-pp.vma_merge_new_range
>       0.07 ± 86%      +0.7        0.72 ±  6%  perf-profile.children.cycles-pp.process_simple
>       0.23 ± 11%      +0.7        0.89 ±  6%  perf-profile.children.cycles-pp.perf_event_mmap_output
>       0.00            +0.7        0.68 ± 11%  perf-profile.children.cycles-pp.kthread
>       0.00            +0.7        0.68 ± 11%  perf-profile.children.cycles-pp.ret_from_fork
>       0.00            +0.7        0.68 ± 11%  perf-profile.children.cycles-pp.ret_from_fork_asm
>       0.44            +0.8        1.21        perf-profile.children.cycles-pp.free_pgtables
>       0.41 ±  2%      +0.8        1.21        perf-profile.children.cycles-pp.mas_update_gap
>       0.19 ± 86%      +0.9        1.13 ±  6%  perf-profile.children.cycles-pp.reader__read_event
>       0.19 ± 85%      +0.9        1.13 ±  5%  perf-profile.children.cycles-pp.perf_session__process_events
>       0.19 ± 85%      +0.9        1.13 ±  5%  perf-profile.children.cycles-pp.record__finish_output
>       0.21 ± 82%      +1.0        1.16 ±  6%  perf-profile.children.cycles-pp.cmd_record
>       0.49            +1.0        1.46        perf-profile.children.cycles-pp.__vma_start_write
>       0.53 ±  5%      +1.1        1.65 ±  5%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
>       0.53            +1.1        1.67        perf-profile.children.cycles-pp.__get_unmapped_area
>       0.60            +1.2        1.76        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
>       0.58 ±  3%      +1.2        1.77 ±  3%  perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
>       0.56            +1.2        1.76        perf-profile.children.cycles-pp.check_brk_limits
>       0.60            +1.2        1.81        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
>       0.69 ±  2%      +1.3        1.95        perf-profile.children.cycles-pp.zap_pte_range
>       0.69 ±  2%      +1.3        1.98        perf-profile.children.cycles-pp.mas_prev_slot
>       0.73            +1.3        2.05        perf-profile.children.cycles-pp.mas_next_slot
>       0.78            +1.4        2.20        perf-profile.children.cycles-pp.mas_wr_store_type
>       1.20            +1.5        2.70        perf-profile.children.cycles-pp.kvfree_call_rcu
>       0.86 ±  2%      +1.5        2.39        perf-profile.children.cycles-pp.zap_pmd_range
>       0.73            +1.6        2.30        perf-profile.children.cycles-pp.memcpy_orig
>       0.77 ±  3%      +1.7        2.43 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free
>       1.70 ±  8%      +1.9        3.56 ±  2%  perf-profile.children.cycles-pp.__slab_free
>       0.66 ±  5%      +1.9        2.59        perf-profile.children.cycles-pp.perf_iterate_sb
>       2.67 ±  5%      +2.2        4.84 ±  3%  perf-profile.children.cycles-pp.__irq_exit_rcu
>       1.09            +2.2        3.28        perf-profile.children.cycles-pp.vm_area_alloc
>       1.18 ±  2%      +2.2        3.41        perf-profile.children.cycles-pp.mas_walk
>       3.09 ±  4%      +2.2        5.33 ±  2%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
>       3.12 ±  4%      +2.2        5.36 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
>       1.97 ±  7%      +2.4        4.35 ±  2%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
>       1.32            +2.4        3.73        perf-profile.children.cycles-pp.unmap_page_range
>       2.39 ±  5%      +2.6        5.04 ±  2%  perf-profile.children.cycles-pp.rcu_free_sheaf
>       2.64 ±  5%      +2.7        5.37 ±  2%  perf-profile.children.cycles-pp.rcu_core
>       2.60 ±  5%      +2.7        5.34 ±  2%  perf-profile.children.cycles-pp.rcu_do_batch
>       2.66 ±  5%      +2.8        5.42 ±  2%  perf-profile.children.cycles-pp.handle_softirqs
>       0.00            +3.0        3.04        perf-profile.children.cycles-pp.__refill_objects_node
>       0.74            +3.1        3.80        perf-profile.children.cycles-pp.__pcs_replace_empty_main
>       1.66            +3.1        4.76        perf-profile.children.cycles-pp.unmap_vmas
>       1.38 ±  2%      +3.3        4.64        perf-profile.children.cycles-pp.perf_event_mmap_event
>       0.00            +3.4        3.39        perf-profile.children.cycles-pp.refill_objects
>       1.54 ±  2%      +3.6        5.13        perf-profile.children.cycles-pp.perf_event_mmap
>       1.85            +3.7        5.52        perf-profile.children.cycles-pp.syscall_return_via_sysret
>       1.99            +3.8        5.81        perf-profile.children.cycles-pp.entry_SYSCALL_64
>       2.27            +4.3        6.58        perf-profile.children.cycles-pp.mas_find
>       2.54            +4.7        7.23        perf-profile.children.cycles-pp.unmap_region
>       2.65            +5.0        7.67        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
>       3.77            +7.4       11.20        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
>       4.68            +8.1       12.74        perf-profile.children.cycles-pp.mas_wr_node_store
>       4.43            +8.3       12.71        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
>      62.91           -61.3        1.64 ±  7%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
>       0.93            -0.4        0.49        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
>       0.43            -0.3        0.09        perf-profile.self.cycles-pp.__pcs_replace_empty_main
>       0.09 ±  5%      +0.0        0.11 ±  4%  perf-profile.self.cycles-pp.barn_replace_empty_sheaf
>       0.05 ±  7%      +0.1        0.10 ±  3%  perf-profile.self.cycles-pp.remove_vma
>       0.00            +0.1        0.05        perf-profile.self.cycles-pp.__kmalloc_noprof
>       0.00            +0.1        0.05        perf-profile.self.cycles-pp.unlink_file_vma_batch_init
>       0.00            +0.1        0.05 ±  7%  perf-profile.self.cycles-pp.build_id_parse_nofault
>       0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.__mt_destroy
>       0.00            +0.1        0.06 ± 11%  perf-profile.self.cycles-pp.evlist__event2evsel
>       0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.__call_rcu_common
>       0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.flush_tlb_batched_pending
>       0.00            +0.1        0.07 ±  7%  perf-profile.self.cycles-pp._raw_spin_unlock
>       0.00            +0.1        0.07 ± 13%  perf-profile.self.cycles-pp.finish_rcuwait
>       0.00            +0.1        0.07        perf-profile.self.cycles-pp.mas_nomem
>       0.04 ± 44%      +0.1        0.12 ±  6%  perf-profile.self.cycles-pp.__x64_sys_brk
>       0.00            +0.1        0.08 ±  6%  perf-profile.self.cycles-pp.barn_get_empty_sheaf
>       0.00            +0.1        0.08 ±  6%  perf-profile.self.cycles-pp.security_mmap_addr
>       0.00            +0.1        0.08        perf-profile.self.cycles-pp.check_brk_limits
>       0.05            +0.1        0.13 ±  2%  perf-profile.self.cycles-pp.__pte_offset_map
>       0.00            +0.1        0.09 ±  4%  perf-profile.self.cycles-pp.ksm_vma_flags
>       0.06            +0.1        0.15        perf-profile.self.cycles-pp.mas_next_setup
>       0.00            +0.1        0.09 ±  5%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
>       0.00            +0.1        0.10 ±  8%  perf-profile.self.cycles-pp.rcu_free_sheaf
>       0.10 ±  5%      +0.1        0.19 ±  9%  perf-profile.self.cycles-pp.vm_area_free
>       0.00            +0.1        0.10 ±  4%  perf-profile.self.cycles-pp.__pi_memcpy
>       0.00            +0.1        0.10 ±  7%  perf-profile.self.cycles-pp.userfaultfd_unmap_prep
>       0.00            +0.1        0.10 ± 13%  perf-profile.self.cycles-pp.__x86_indirect_thunk_r12
>       0.06            +0.1        0.16 ±  3%  perf-profile.self.cycles-pp.unlink_anon_vmas
>       0.03 ±100%      +0.1        0.14 ± 15%  perf-profile.self.cycles-pp.brk@plt
>       0.07 ±  6%      +0.1        0.18 ±  4%  perf-profile.self.cycles-pp.cap_vm_enough_memory
>       0.02 ±141%      +0.1        0.14 ±  3%  perf-profile.self.cycles-pp.mm_get_unmapped_area_vmflags
>       0.08 ±  6%      +0.1        0.20 ±  2%  perf-profile.self.cycles-pp.strlen
>       0.07            +0.1        0.20 ±  3%  perf-profile.self.cycles-pp.__vm_enough_memory
>       0.08 ±  6%      +0.1        0.22 ±  4%  perf-profile.self.cycles-pp.free_pgd_range
>       0.07 ± 14%      +0.1        0.21 ±  4%  perf-profile.self.cycles-pp.is_vmalloc_addr
>       0.07 ±  5%      +0.1        0.21 ±  7%  perf-profile.self.cycles-pp.testcase
>       0.09 ±  4%      +0.2        0.24 ±  3%  perf-profile.self.cycles-pp.__account_obj_stock
>       0.08 ±  4%      +0.2        0.24 ±  6%  perf-profile.self.cycles-pp.obj_cgroup_charge_account
>       0.00            +0.2        0.16 ±  8%  perf-profile.self.cycles-pp.setup_object
>       0.10 ±  4%      +0.2        0.27 ±  2%  perf-profile.self.cycles-pp.is_mergeable_anon_vma
>       0.10 ±  5%      +0.2        0.27 ±  7%  perf-profile.self.cycles-pp.cap_capable
>       0.08 ±  5%      +0.2        0.26        perf-profile.self.cycles-pp.may_expand_vm
>       0.10 ±  4%      +0.2        0.29        perf-profile.self.cycles-pp.pte_offset_map_lock
>       0.10 ±  3%      +0.2        0.29        perf-profile.self.cycles-pp.mas_next_range
>       0.10 ±  7%      +0.2        0.28 ±  2%  perf-profile.self.cycles-pp.mas_prev_range
>       0.10 ±  5%      +0.2        0.29        perf-profile.self.cycles-pp.vma_merge_new_range
>       0.12 ±  4%      +0.2        0.31        perf-profile.self.cycles-pp.userfaultfd_unmap_complete
>       0.10 ±  4%      +0.2        0.30 ±  4%  perf-profile.self.cycles-pp.x64_sys_call
>       0.11 ±  4%      +0.2        0.31 ±  8%  perf-profile.self.cycles-pp.vm_get_page_prot
>       0.12 ±  4%      +0.2        0.32        perf-profile.self.cycles-pp.mas_prev
>       0.12 ±  7%      +0.2        0.32 ±  6%  perf-profile.self.cycles-pp.percpu_counter_add_batch
>       0.10 ±  3%      +0.2        0.31 ±  2%  perf-profile.self.cycles-pp.strnlen
>       0.09 ±  4%      +0.2        0.31        perf-profile.self.cycles-pp.unmap_single_vma
>       0.15 ±  3%      +0.2        0.36 ±  2%  perf-profile.self.cycles-pp.mas_wr_store_entry
>       0.14 ±  2%      +0.2        0.38 ±  2%  perf-profile.self.cycles-pp.can_vma_merge_left
>       0.34            +0.2        0.58 ±  4%  perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
>       0.12 ±  6%      +0.2        0.36        perf-profile.self.cycles-pp.tlb_finish_mmu
>       0.13 ±  2%      +0.2        0.36        perf-profile.self.cycles-pp.mas_prev_setup
>       0.13            +0.2        0.37 ±  2%  perf-profile.self.cycles-pp.up_write
>       0.15 ±  3%      +0.2        0.39 ±  6%  perf-profile.self.cycles-pp.kfree
>       0.12 ±  3%      +0.2        0.37 ±  2%  perf-profile.self.cycles-pp.__get_unmapped_area
>       0.14            +0.2        0.39        perf-profile.self.cycles-pp.unmap_region
>       0.10 ± 10%      +0.2        0.35 ± 13%  perf-profile.self.cycles-pp.refill_obj_stock
>       0.12 ±  3%      +0.3        0.38        perf-profile.self.cycles-pp.downgrade_write
>       0.14 ±  3%      +0.3        0.39 ±  2%  perf-profile.self.cycles-pp.unmap_vmas
>       0.16 ±  4%      +0.3        0.42 ±  3%  perf-profile.self.cycles-pp.zap_pmd_range
>       0.16 ±  3%      +0.3        0.43 ±  3%  perf-profile.self.cycles-pp._raw_spin_lock
>       0.15 ±  2%      +0.3        0.43        perf-profile.self.cycles-pp.sized_strscpy
>       0.14 ±  3%      +0.3        0.41        perf-profile.self.cycles-pp.cap_mmap_addr
>       0.17 ±  4%      +0.3        0.45        perf-profile.self.cycles-pp.mas_update_gap
>       0.16 ±  3%      +0.3        0.45        perf-profile.self.cycles-pp.tlb_gather_mmu
>       0.19            +0.3        0.48        perf-profile.self.cycles-pp.free_pgtables
>       0.17 ±  2%      +0.3        0.47        perf-profile.self.cycles-pp.up_read
>       0.16 ±  4%      +0.3        0.47        perf-profile.self.cycles-pp.perf_event_mmap
>       0.18 ±  5%      +0.3        0.50        perf-profile.self.cycles-pp.__vma_start_write
>       0.19 ±  2%      +0.4        0.55        perf-profile.self.cycles-pp.static_key_count
>       0.20 ±  2%      +0.4        0.56 ±  5%  perf-profile.self.cycles-pp.vm_area_alloc
>       0.20            +0.4        0.58        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
>       0.20 ±  2%      +0.4        0.58        perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
>       0.18 ±  3%      +0.4        0.58        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
>       0.22            +0.4        0.63 ±  2%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
>       0.21 ±  3%      +0.4        0.64        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
>       0.23            +0.5        0.69        perf-profile.self.cycles-pp.mas_leaf_max_gap
>       0.24 ±  6%      +0.5        0.74 ±  9%  perf-profile.self.cycles-pp.kmem_cache_free
>       0.29 ±  2%      +0.5        0.80        perf-profile.self.cycles-pp.do_vmi_align_munmap
>       0.27            +0.5        0.80 ±  2%  perf-profile.self.cycles-pp.__vma_start_exclude_readers
>       0.35 ±  3%      +0.5        0.87 ±  5%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
>       0.28            +0.5        0.82        perf-profile.self.cycles-pp.perf_event_mmap_event
>       0.32 ±  3%      +0.5        0.86 ±  2%  perf-profile.self.cycles-pp.zap_pte_range
>       0.33            +0.6        0.89 ±  2%  perf-profile.self.cycles-pp.vms_complete_munmap_vmas
>       0.21 ± 11%      +0.6        0.78 ±  6%  perf-profile.self.cycles-pp.perf_event_mmap_output
>       0.05 ± 91%      +0.6        0.62 ±  7%  perf-profile.self.cycles-pp.queue_event
>       0.29 ±  3%      +0.6        0.87 ±  2%  perf-profile.self.cycles-pp.down_write_killable
>       0.61            +0.6        1.24        perf-profile.self.cycles-pp.kvfree_call_rcu
>       0.36 ±  5%      +0.7        1.02 ± 11%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
>       0.41 ±  2%      +0.7        1.14        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
>       0.40 ±  4%      +0.8        1.16 ±  4%  perf-profile.self.cycles-pp.do_syscall_64
>       0.43 ±  3%      +0.8        1.22 ±  8%  perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
>       0.46 ±  2%      +0.8        1.28 ±  2%  perf-profile.self.cycles-pp.unmap_page_range
>       0.32            +0.8        1.16 ±  2%  perf-profile.self.cycles-pp.__kmem_cache_free_bulk
>       0.56            +1.0        1.55        perf-profile.self.cycles-pp.do_brk_flags
>       0.54 ±  2%      +1.0        1.54        perf-profile.self.cycles-pp.mas_find
>       0.47 ±  5%      +1.0        1.51 ±  6%  perf-profile.self.cycles-pp.brk
>       0.66 ±  2%      +1.2        1.82        perf-profile.self.cycles-pp.mas_prev_slot
>       0.41 ± 12%      +1.2        1.58 ±  5%  perf-profile.self.cycles-pp.perf_iterate_sb
>       0.69            +1.2        1.87        perf-profile.self.cycles-pp.mas_next_slot
>       0.76            +1.3        2.06        perf-profile.self.cycles-pp.mas_wr_store_type
>       0.68            +1.3        2.01        perf-profile.self.cycles-pp.__do_sys_brk
>       0.64            +1.4        2.04 ±  2%  perf-profile.self.cycles-pp.__slab_free
>       0.70            +1.4        2.13        perf-profile.self.cycles-pp.memcpy_orig
>       0.95            +1.8        2.70        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
>       1.10            +2.0        3.09        perf-profile.self.cycles-pp.mas_store_gfp
>       1.13 ±  2%      +2.0        3.16        perf-profile.self.cycles-pp.mas_walk
>       0.00            +2.1        2.06        perf-profile.self.cycles-pp.__refill_objects_node
>       1.76            +3.4        5.18        perf-profile.self.cycles-pp.entry_SYSCALL_64
>       1.85            +3.7        5.50        perf-profile.self.cycles-pp.syscall_return_via_sysret
>       2.26            +3.9        6.16        perf-profile.self.cycles-pp.mas_wr_node_store
>       3.73            +7.4       11.09        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
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


