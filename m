Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA1FCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641DC6B0099; Thu, 14 May 2026 10:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619086B00B8; Thu, 14 May 2026 10:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52EB76B00BD; Thu, 14 May 2026 10:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0A26B0099
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:45:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFC531603CE
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:45:27 +0000 (UTC)
X-FDA: 84766298694.25.B036559
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0DA5D80008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:45:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qkiw0DSf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778769926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIbjxO7sGvr4NUGrIB0FuK0goVl3veHaL+9IlfuWNLI=;
	b=L4JfQttYH659HHNjqgdX/9Uh7wsYTpSOfuL+oo/iO9l+euD2cVDSWLqGHSPoYd3a9SH8M8
	fJyZJNlYbQ327yEcUVBNtv5xkQyRYBEJ7fQmmKYp53Cw9kL9RAr2SgSem1Xv75t/XoDT2S
	fPlbCD9kBbfCE+ypVC34FKPbl4CVt04=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778769926; a=rsa-sha256;
	cv=none;
	b=sje/Vhq1WVLOsNMilZFUpyrOZkVldHAeNc2h1AtptIfrGBeSGNTh7MPeG2CgWrU1SfQnLa
	qx/Ky6B29u0QolQdNxhibgx72V72SqYIha6owtt++1vaFtu7Q2YbdUk7n3nJJRsffmPbwT
	VqDtnwrdU+Orb8D8tWyjlQONrN3bdUs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qkiw0DSf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4506C60132;
	Thu, 14 May 2026 14:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BABC2BCB3;
	Thu, 14 May 2026 14:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778769925;
	bh=9ZTmyCliP67U/zopx+UlqQWEcHusRAKC3KSOIhgf+wE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qkiw0DSf3YlTXhrGOdfoxpRIO7SBUPiY3YTQ/WsmP8AB/Pp3EDZsCEA67D8yRT8DE
	 pZOfPaZyK7SAZMiMrTBtoqCWlci5hSLAnKCBnGyffDx5tFr4Tl1G/1fk9ZeH/3uDwW
	 uBNA+aDFFqKvXIMKV52lSF2/Ig/mqwAJjUCp/VWzRlCMwoVJYq4IOQ1zSHLYU/A8Nu
	 YMvS1SzLml0+9gU1sSXM2OzGUoVf7kHTKnAwRewhOWv2ncbKka8ZYcvu7KPcunzeuQ
	 HUkoBa9l9PvyipRyruBeS/1IlqCt6vv4Uh0xsf5d6UNkTXo5LeRbCuta65lPqkCdkI
	 jbr1WLpOkzn8g==
Message-ID: <90bf195e-45fb-423c-b686-49be9cadbd11@kernel.org>
Date: Thu, 14 May 2026 16:45:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm, slab] 298cdbf5f7:
 will-it-scale.per_process_ops 6.3% regression
Content-Language: en-US
To: kernel test robot <oliver.sang@intel.com>,
 "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Hao Li <hao.li@linux.dev>,
 linux-mm@kvack.org
References: <202605112204.9382cecf-lkp@intel.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <202605112204.9382cecf-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DA5D80008
X-Rspamd-Server: rspam04
X-Stat-Signature: gs5dm3ndwd3bj611o93f1mhuyniutft1
X-HE-Tag: 1778769925-878939
X-HE-Meta: U2FsdGVkX1+5Zfj3NBLYv9X4Mo4r0gbnPbOr9vNoSObdxfVwMiWUxhTPm+WKhCYJIX7pWncZ68oINoSoQmaM7NpQC5LZjGwwsJm3ofFWRLHID2RwDD+fixl8fV8FFLoZlxNjuChmWNXtCVhlh65fd0m5lEgoHbbZZwb3p2suauBVyee3lE4Mgz8k1ZwU020zlag+sBEEfc2dN26UHCNJZneCH/LEcg7EEihNG+Mc8WIbiSBJ9/YwiT2HEpCgVtxK6JtKh6g3TA5cnyBhw5S8JnyXzFRwwghtgYMlGEmEYyVKkgGhuXDBKlAkoLJW2vyzW5g+Z/y3qDj8roHEAAf6zxL4I9It68iNCUBjQieyXXK+stSk+G8KYG7+bemn6vGld5nwZsWwBzn+ZXqFNc4uGvdgMXH9w//iHkIJ+e6LIm0xX+ptSB5TXHnXCsIscHaGtOVXV168K+bieV3usmxVYgkHb6CARu8NT5ZAjaRvU6lcXxNjIS3098qAeO/T0pQU5eKG3UhzoXzu6OWEtLiMttFeQy6pATXKKYKyNghdYOTlKPYOIz8Bb69IQz4oGGTqmbsEN36XsegXw1mUg2o7aIwyVNYX4PlEYg4sBfxich9xBWAHR9TcHA7uxMkYCWr8E5lubWbCjrPIzjAfJc3ExjBTws1M2dot4IRxkz8GxGIz/OIe9Pp9ZbZjF1/QbnvlqjOMzQ90P8oI9aFgasevsT11N4TQAx+rxnPEKhuCcp54bKFznVrL9uaoyxEeS3Sm9N3t62Jyfix95x5lGdXpPgzGsZIuBDeipXnr4VPy8L7DiLJWIszA4Kt/PnpYZLM/ZjZGcU0AysxoWXikv0VdhG2O7T+304yg30OCGE7wK7xmYOZaJczGs6NewhXUzQe0qtzFK111/WLGEDC+QjudUESLF3up4UiPqI2bVpjKCOjW74IQEgFciCxFDFAHQO7zhwn+8PtocSqb49bFord
 szIsSsCl
 OdmgS7gaKEzX6i1oPOhxqbid45IwXbdI+/VYdWGPwQ4Id/jwt6MmZbT8PWBtDKiStdGKSD8aN5uDKjv6ZpIanvVi6VQdC+fi+AKHUlcZw/ASYsPjx5Q3Bp3Y7cVah4Zu6b7W0CTrcakqU12gTt0pDlm2nqimvC3Ir00Ew1LQOtSOmSPFVNCeK1foJ4TUXua71j5Izg7N45XDlflO6bBZdsnAgsfEI0m+tXA0RSvydqCb6NAbmJdO8lJRb/ZrZWFNcmmkLAn8vMP83nJkqTl6qz7VTfzXtJ0LSHuxfdpucE6M2Tb89Uf2JwiPELBlhFXKPSKbzKkX7btNFwDg++eQYQrFFgIJKWyBWZuEN6IY+oXcbfYCan6m+fkTv9GhuL6iqTah78UR2IuTDL96k9UNcLDf+u64d0SfUri5RuUI0ZB6MyzGrobHiii7Tiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 16:45, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 6.3% regression of will-it-scale.per_process_ops on:

Yay for an optimization that was supposed to have no tradeoffs :)

> commit: 298cdbf5f7c9e19289f46710ed5ab3da4e711150 ("mm, slab: add an optimistic __slab_try_return_freelist()")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [still regression on linux-next/master 4cd074ae20bbcc293bbbce9163abe99d68ae6ae0]
> 
> testcase: will-it-scale
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
> parameters:
> 
> 	nr_task: 100%
> 	mode: process
> 	test: mmap1
> 	cpufreq_governor: performance
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202605112204.9382cecf-lkp@intel.com
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260511/202605112204.9382cecf-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
>   gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap1/will-it-scale
> 
> commit: 
>   1f7c8e1d52 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
>   298cdbf5f7 ("mm, slab: add an optimistic __slab_try_return_freelist()")
> 
> 1f7c8e1d52428cbf 298cdbf5f7c9e19289f46710ed5 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>   35417967            -6.3%   33202379        will-it-scale.192.processes
>     184468            -6.3%     172928        will-it-scale.per_process_ops
>   35417967            -6.3%   33202379        will-it-scale.workload
>      21873 ±  2%      +8.0%      23628        vmstat.system.cs
>       3957 ± 19%     -64.8%       1392 ± 13%  perf-c2c.DRAM.local
>       1016 ± 20%     -46.9%     540.33 ± 34%  perf-c2c.DRAM.remote
>       0.71            -5.6%       0.67        turbostat.IPC
>     430.37            -1.2%     425.33        turbostat.PkgWatt
>       0.13            -0.0        0.12        mpstat.cpu.all.irq%
>      18.38            +1.4       19.79        mpstat.cpu.all.soft%
>       1.64            -0.1        1.54        mpstat.cpu.all.usr%
>       7.06 ± 14%     +26.0%       8.89 ± 12%  sched_debug.cfs_rq:/.load_avg.min
>      18788 ±  2%      +7.2%      20147        sched_debug.cpu.nr_switches.avg
>      16273 ±  3%      +7.6%      17503        sched_debug.cpu.nr_switches.min
>    3418653           +97.9%    6765264        numa-numastat.node0.local_node
>    3479092           +96.6%    6839697        numa-numastat.node0.numa_hit
>    4424809 ±  2%     +79.1%    7922798 ±  2%  numa-numastat.node1.local_node
>    4564748 ±  2%     +76.3%    8048580 ±  2%  numa-numastat.node1.numa_hit
>    3478940           +96.6%    6839185        numa-vmstat.node0.numa_hit
>    3418501           +97.9%    6764752        numa-vmstat.node0.numa_local
>    4565277 ±  2%     +76.3%    8048347 ±  2%  numa-vmstat.node1.numa_hit
>    4425338 ±  2%     +79.0%    7922564 ±  2%  numa-vmstat.node1.numa_local
>     189874            -2.4%     185345        proc-vmstat.nr_slab_unreclaimable
>    8051058           +85.0%   14892463        proc-vmstat.numa_hit
>    7850680           +87.1%   14692248        proc-vmstat.numa_local
>   25073981          +109.6%   52554060        proc-vmstat.pgalloc_normal
>   23597828          +116.6%   51111380        proc-vmstat.pgfree

Perhaps the weirdest part, the commit shouldn't be affecting page
allocations at all.

>       0.20            +8.9%       0.22 ±  2%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       0.20            +8.9%       0.22 ±  2%  perf-sched.total_sch_delay.average.ms
>      26.54 ±  2%     -12.1%      23.32 ±  2%  perf-sched.total_wait_and_delay.average.ms
>     108336 ±  3%      +9.0%     118099        perf-sched.total_wait_and_delay.count.ms
>      26.34 ±  2%     -12.3%      23.11 ±  2%  perf-sched.total_wait_time.average.ms
>      26.54 ±  2%     -12.1%      23.32 ±  2%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>     108336 ±  3%      +9.0%     118099        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
>      26.34 ±  2%     -12.3%      23.11 ±  2%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>  9.213e+10            -5.7%  8.687e+10        perf-stat.i.branch-instructions
>  1.098e+08            -6.7%  1.025e+08        perf-stat.i.branch-misses
>      14.49 ±  2%      -1.4       13.11 ±  4%  perf-stat.i.cache-miss-rate%
>  1.059e+08 ±  2%     -12.9%   92245846 ±  5%  perf-stat.i.cache-misses
>  7.389e+08            -3.6%  7.123e+08        perf-stat.i.cache-references
>      21981 ±  2%      +7.8%      23693        perf-stat.i.context-switches
>       1.40            +6.2%       1.49        perf-stat.i.cpi
>     256.41            +3.0%     263.99        perf-stat.i.cpu-migrations
>       5815 ±  2%     +15.3%       6707 ±  4%  perf-stat.i.cycles-between-cache-misses
>  4.341e+11            -5.8%  4.089e+11        perf-stat.i.instructions
>       0.71            -5.8%       0.67        perf-stat.i.ipc
>      14.34 ±  2%      -1.4       12.97 ±  4%  perf-stat.overall.cache-miss-rate%
>       1.41            +6.2%       1.49        perf-stat.overall.cpi
>       5764 ±  2%     +15.0%       6626 ±  4%  perf-stat.overall.cycles-between-cache-misses
>       0.71            -5.9%       0.67        perf-stat.overall.ipc
>  9.183e+10            -5.7%  8.659e+10        perf-stat.ps.branch-instructions
>  1.095e+08            -6.7%  1.021e+08        perf-stat.ps.branch-misses
>  1.056e+08 ±  2%     -12.8%   92081686 ±  5%  perf-stat.ps.cache-misses
>  7.367e+08            -3.6%  7.102e+08        perf-stat.ps.cache-references
>      21840 ±  2%      +8.1%      23604        perf-stat.ps.context-switches
>     253.30            +3.0%     260.93        perf-stat.ps.cpu-migrations
>  4.327e+11            -5.8%  4.076e+11        perf-stat.ps.instructions
>  1.312e+14            -5.9%  1.235e+14        perf-stat.total.instructions
>      12.77           -12.8        0.00        perf-profile.calltrace.cycles-pp.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
>      12.68           -12.7        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main
>      12.60           -12.6        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects

The zeroes here suggest the patch is working as expected, we're avoding
__slab_free() completely here because __slab_try_return_freelist() succeeds
reliably.

>       4.81            -0.5        4.28        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
>       2.52            -0.4        2.09        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
>       7.46            -0.4        7.06        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
>       5.21 ±  2%      -0.4        4.86        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       3.50            -0.3        3.19        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
>       3.47            -0.3        3.16        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
>       5.90            -0.3        5.60        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       1.96            -0.3        1.70        perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
>       2.43 ±  4%      -0.3        2.17 ±  4%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
>       2.25 ±  4%      -0.2        2.00 ±  4%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp
>       1.27 ± 10%      -0.2        1.03 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
>       2.66 ±  4%      -0.2        2.44 ±  3%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
>       5.57 ±  2%      -0.2        5.37        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
>       1.46 ±  8%      -0.2        1.27 ±  4%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
>       1.27 ±  8%      -0.2        1.08 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
>       5.06 ±  2%      -0.2        4.88        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
>       2.48            -0.2        2.32        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs
>       2.51            -0.2        2.36        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
>       2.00            -0.1        1.86        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       2.24            -0.1        2.11        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
>       2.89            -0.1        2.76        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
>       2.26            -0.1        2.12        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
>       2.56            -0.1        2.43        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
>       2.13            -0.1        2.01        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
>       2.00            -0.1        1.88        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
>       2.74            -0.1        2.62        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
>       1.94            -0.1        1.82        perf-profile.calltrace.cycles-pp.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64
>       1.67            -0.1        1.58        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff
>       1.44            -0.1        1.36        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
>       1.50            -0.1        1.42        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
>       1.35            -0.1        1.28        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area
>       1.38            -0.1        1.30        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap
>       1.58            -0.1        1.52        perf-profile.calltrace.cycles-pp.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
>       1.44            -0.1        1.39        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff
>       0.62            -0.0        0.57        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
>       0.61            -0.0        0.57        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
>       1.06            -0.0        1.03        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap
>       0.62            -0.0        0.59        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags
>       0.64            -0.0        0.62 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       0.64            -0.0        0.62        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
>       0.88            +0.1        0.98        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
>       0.55 ±  5%      +0.1        0.66 ±  2%  perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
>       0.51            +0.1        0.64        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
>       1.52 ±  5%      +0.3        1.84 ±  2%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
>       2.16 ±  5%      +0.4        2.59 ±  2%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
>       2.16 ±  5%      +0.4        2.59 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
>       2.16 ±  5%      +0.4        2.59 ±  2%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
>       2.16 ±  5%      +0.4        2.59 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
>       2.17 ±  5%      +0.4        2.60 ±  2%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
>       2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
>       2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
>       2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
>       0.00            +0.6        0.60 ±  8%  perf-profile.calltrace.cycles-pp.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
>       0.00            +0.6        0.62 ±  5%  perf-profile.calltrace.cycles-pp.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
>      12.88            +1.0       13.87        perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
>      12.83            +1.0       13.82        perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node
>      12.88            +1.0       13.87        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main
>      12.81            +1.0       13.81        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
>      12.82            +1.0       13.82        perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
>      12.87            +1.0       13.87        perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects
>      12.81            +1.0       13.82        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
>      10.64            +1.3       11.92        perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
>      11.72            +1.6       13.30        perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
>      11.63            +1.6       13.23        perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
>      11.33            +1.6       12.94        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
>      11.20            +1.6       12.82        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
>      22.90           +14.2       37.13        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
>      22.99           +14.3       37.26        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof

Taking the spin_lock isn't avoided (and isn't supposed to be), we're just
not doing it from __slab_free() but from __refill_objects_node(). Should be
the same frequency and same amount of work under the lock (maybe less as
there's no double cmpxchg under the spin lock), we just avoid walking
freelist (outside of any lock). So it should be the same or better.

>      27.87           -10.5       17.33        perf-profile.children.cycles-pp.__slab_free
>       7.27            -0.8        6.48        perf-profile.children.cycles-pp.barn_get_empty_sheaf
>       5.91            -0.6        5.32        perf-profile.children.cycles-pp.barn_replace_empty_sheaf
>      10.36            -0.5        9.82        perf-profile.children.cycles-pp.mas_wr_node_store
>       7.58            -0.4        7.18        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
>       3.98            -0.4        3.61        perf-profile.children.cycles-pp.barn_put_full_sheaf
>       4.70            -0.4        4.34        perf-profile.children.cycles-pp.__kfree_rcu_sheaf
>       5.91            -0.3        5.60        perf-profile.children.cycles-pp.unmap_region
>       5.19            -0.3        4.90        perf-profile.children.cycles-pp.kvfree_call_rcu
>      94.66            -0.3       94.41        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
>      94.52            -0.2       94.27        perf-profile.children.cycles-pp.do_syscall_64
>       5.57 ±  2%      -0.2        5.37        perf-profile.children.cycles-pp.mas_store_prealloc
>       2.06            -0.2        1.89        perf-profile.children.cycles-pp.__get_unmapped_area
>       2.96            -0.2        2.80        perf-profile.children.cycles-pp.__pi_memcpy
>       2.55            -0.2        2.40        perf-profile.children.cycles-pp.free_pgtables
>       2.25            -0.1        2.12        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
>       2.26            -0.1        2.13        perf-profile.children.cycles-pp.free_pgd_range
>       2.58            -0.1        2.44        perf-profile.children.cycles-pp.zap_pmd_range
>       2.90            -0.1        2.77        perf-profile.children.cycles-pp.unmap_vmas
>       2.14            -0.1        2.02        perf-profile.children.cycles-pp.free_p4d_range
>       2.75            -0.1        2.63        perf-profile.children.cycles-pp.__zap_vma_range
>       2.01            -0.1        1.89        perf-profile.children.cycles-pp.free_pud_range
>       1.94            -0.1        1.82        perf-profile.children.cycles-pp.thp_get_unmapped_area_vmflags
>       1.69            -0.1        1.59        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
>       1.26            -0.1        1.18        perf-profile.children.cycles-pp.entry_SYSCALL_64
>       1.42            -0.1        1.34        perf-profile.children.cycles-pp.mas_find
>       1.38            -0.1        1.30        perf-profile.children.cycles-pp.vm_unmapped_area
>       1.36            -0.1        1.28        perf-profile.children.cycles-pp.unmapped_area_topdown
>       0.98            -0.1        0.92        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
>       1.58            -0.1        1.52        perf-profile.children.cycles-pp.__mmap_complete
>       1.46            -0.1        1.40        perf-profile.children.cycles-pp.perf_event_mmap
>       0.64            -0.0        0.60        perf-profile.children.cycles-pp.mas_prev_slot
>       0.54            -0.0        0.50        perf-profile.children.cycles-pp.mas_wr_store_type
>       1.08            -0.0        1.04        perf-profile.children.cycles-pp.perf_event_mmap_event
>       0.63            -0.0        0.59        perf-profile.children.cycles-pp.mas_empty_area_rev
>       0.54            -0.0        0.50        perf-profile.children.cycles-pp.__vma_start_write
>       0.54            -0.0        0.52        perf-profile.children.cycles-pp.mas_next_slot
>       0.43            -0.0        0.41        perf-profile.children.cycles-pp.mas_rev_awalk
>       0.53            -0.0        0.51        perf-profile.children.cycles-pp.mas_walk
>       0.64            -0.0        0.62 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free
>       0.36            -0.0        0.33        perf-profile.children.cycles-pp.__vma_start_exclude_readers
>       0.29            -0.0        0.27        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
>       0.44            -0.0        0.42        perf-profile.children.cycles-pp.vma_merge_new_range
>       0.65            -0.0        0.63        perf-profile.children.cycles-pp.perf_iterate_sb
>       0.24            -0.0        0.22        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
>       0.07 ±  5%      -0.0        0.05        perf-profile.children.cycles-pp.mmap_region
>       0.14            -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.mas_prev
>       0.30            -0.0        0.28        perf-profile.children.cycles-pp.up_read
>       0.30            -0.0        0.29        perf-profile.children.cycles-pp.vma_set_page_prot
>       0.07            -0.0        0.06 ±  9%  perf-profile.children.cycles-pp.unlink_file_vma_batch_add
>       0.08 ±  6%      -0.0        0.06        perf-profile.children.cycles-pp.__alloc_empty_sheaf
>       0.08 ±  6%      -0.0        0.06        perf-profile.children.cycles-pp.remove_vma
>       0.24            -0.0        0.22        perf-profile.children.cycles-pp.downgrade_write
>       0.20 ±  3%      -0.0        0.18 ±  2%  perf-profile.children.cycles-pp.mas_wr_walk_descend
>       0.28            -0.0        0.27        perf-profile.children.cycles-pp.down_write_killable
>       0.18 ±  2%      -0.0        0.17 ±  2%  perf-profile.children.cycles-pp.vma_wants_writenotify
>       0.07 ±  5%      -0.0        0.06        perf-profile.children.cycles-pp.__kmalloc_noprof
>       0.20            -0.0        0.19        perf-profile.children.cycles-pp.tlb_gather_mmu
>       0.07            -0.0        0.06        perf-profile.children.cycles-pp.__call_rcu_common
>       0.16            -0.0        0.15        perf-profile.children.cycles-pp.may_expand_vm
>       0.14            -0.0        0.13        perf-profile.children.cycles-pp.up_write
>       0.12            -0.0        0.11        perf-profile.children.cycles-pp.hrtimer_interrupt
>       0.15            -0.0        0.14        perf-profile.children.cycles-pp.vma_is_shared_writable
>       0.11            -0.0        0.10        perf-profile.children.cycles-pp.x64_sys_call
>       0.88            +0.1        0.99        perf-profile.children.cycles-pp.vm_area_alloc
>       0.36            +0.1        0.50        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
>       2.16 ±  5%      +0.4        2.59 ±  2%  perf-profile.children.cycles-pp.run_ksoftirqd
>       2.17 ±  5%      +0.4        2.60 ±  2%  perf-profile.children.cycles-pp.smpboot_thread_fn
>       2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.children.cycles-pp.kthread
>       2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
>       2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
>       0.69 ±  5%      +0.5        1.22 ±  4%  perf-profile.children.cycles-pp.alloc_from_new_slab
>      15.26            +1.2       16.44        perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
>      18.16            +1.3       19.49        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
>      18.14            +1.3       19.47        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
>      18.02            +1.3       19.36        perf-profile.children.cycles-pp.__irq_exit_rcu
>      60.59            +1.5       62.05        perf-profile.children.cycles-pp.__pcs_replace_empty_main
>      61.51            +1.6       63.10        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
>      20.16            +1.8       21.94        perf-profile.children.cycles-pp.rcu_core
>      20.18            +1.8       21.95        perf-profile.children.cycles-pp.handle_softirqs
>      20.14            +1.8       21.92        perf-profile.children.cycles-pp.rcu_do_batch
>      50.97            +2.0       52.95        perf-profile.children.cycles-pp.__refill_objects_node
>      15.07            +2.2       17.25        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
>      15.67            +2.2       17.86        perf-profile.children.cycles-pp.rcu_free_sheaf
>      65.82            +2.4       68.25        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
>      65.33            +2.5       67.80        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
>      51.67            +2.5       54.18        perf-profile.children.cycles-pp.refill_objects
>       2.16            -0.5        1.66        perf-profile.self.cycles-pp.__refill_objects_node
>       2.64            -0.2        2.48        perf-profile.self.cycles-pp.__pi_memcpy
>       2.36            -0.1        2.22        perf-profile.self.cycles-pp.zap_pmd_range
>       1.84            -0.1        1.71        perf-profile.self.cycles-pp.free_pud_range
>       1.78            -0.1        1.66        perf-profile.self.cycles-pp.__mmap_region
>       0.52            -0.1        0.40        perf-profile.self.cycles-pp.__slab_free
>       1.44            -0.1        1.34        perf-profile.self.cycles-pp.mas_wr_node_store
>       0.98            -0.1        0.92        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
>       0.84            -0.1        0.78        perf-profile.self.cycles-pp.mas_store_gfp
>       0.55            -0.0        0.50        perf-profile.self.cycles-pp.do_vmi_align_munmap
>       0.58            -0.0        0.54        perf-profile.self.cycles-pp.mas_prev_slot
>       0.62            -0.0        0.58        perf-profile.self.cycles-pp.entry_SYSCALL_64
>       0.17            -0.0        0.13        perf-profile.self.cycles-pp.do_mmap
>       0.48            -0.0        0.44        perf-profile.self.cycles-pp.__mmap
>       0.49            -0.0        0.45        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
>       0.35            -0.0        0.32        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
>       0.18            -0.0        0.15 ±  2%  perf-profile.self.cycles-pp.thp_get_unmapped_area_vmflags
>       0.42            -0.0        0.39        perf-profile.self.cycles-pp.__munmap
>       0.49            -0.0        0.46        perf-profile.self.cycles-pp.mas_next_slot
>       0.48            -0.0        0.45        perf-profile.self.cycles-pp.perf_iterate_sb
>       0.10            -0.0        0.07 ±  5%  perf-profile.self.cycles-pp.__get_unmapped_area
>       0.40            -0.0        0.37        perf-profile.self.cycles-pp.mas_rev_awalk
>       0.48            -0.0        0.45        perf-profile.self.cycles-pp.mas_walk
>       0.31            -0.0        0.28        perf-profile.self.cycles-pp.kmem_cache_free
>       0.37            -0.0        0.34        perf-profile.self.cycles-pp.__vm_munmap
>       0.30            -0.0        0.28        perf-profile.self.cycles-pp.__vma_start_exclude_readers
>       0.31            -0.0        0.29        perf-profile.self.cycles-pp.mas_wr_store_type
>       0.36            -0.0        0.34        perf-profile.self.cycles-pp.perf_event_mmap
>       0.37            -0.0        0.35        perf-profile.self.cycles-pp.mas_preallocate
>       0.68            -0.0        0.66        perf-profile.self.cycles-pp.mas_update_gap
>       0.32            -0.0        0.30        perf-profile.self.cycles-pp.vma_merge_new_range
>       0.29            -0.0        0.27        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
>       0.37            -0.0        0.35        perf-profile.self.cycles-pp.mas_find
>       0.18            -0.0        0.16        perf-profile.self.cycles-pp.rcu_free_sheaf
>       0.33            -0.0        0.31        perf-profile.self.cycles-pp.vm_area_alloc
>       0.07            -0.0        0.05        perf-profile.self.cycles-pp.unlink_file_vma_batch_add
>       0.38            -0.0        0.36        perf-profile.self.cycles-pp.mas_store_prealloc
>       0.26            -0.0        0.24        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
>       0.25            -0.0        0.23 ±  2%  perf-profile.self.cycles-pp.up_read
>       0.26            -0.0        0.24        perf-profile.self.cycles-pp.down_write_killable
>       0.22 ±  2%      -0.0        0.20        perf-profile.self.cycles-pp.downgrade_write
>       0.26            -0.0        0.25        perf-profile.self.cycles-pp.__kfree_rcu_sheaf
>       0.20 ±  2%      -0.0        0.19        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
>       0.18 ±  2%      -0.0        0.16 ±  2%  perf-profile.self.cycles-pp.mas_wr_walk_descend
>       0.19 ±  2%      -0.0        0.18        perf-profile.self.cycles-pp.do_syscall_64
>       0.38            -0.0        0.37        perf-profile.self.cycles-pp.unmapped_area_topdown
>       0.17            -0.0        0.16        perf-profile.self.cycles-pp.__vma_start_write
>       0.13            -0.0        0.12        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
>       0.10            -0.0        0.09        perf-profile.self.cycles-pp.free_pgd_range
>       0.07            -0.0        0.06        perf-profile.self.cycles-pp.mas_prev
>       0.17            -0.0        0.16        perf-profile.self.cycles-pp.tlb_finish_mmu
>       0.12            -0.0        0.11        perf-profile.self.cycles-pp.security_vm_enough_memory_mm
>       0.06            -0.0        0.05        perf-profile.self.cycles-pp.mmap_region
>       0.43            +0.1        0.50        perf-profile.self.cycles-pp.kvfree_call_rcu
>       0.29            +0.1        0.41        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
>      65.33            +2.5       67.80        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath

And yet it seems we spend more time spinning as a result. Can't explain it
by what the patch does, so could it be just some code cache layout effect?

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


