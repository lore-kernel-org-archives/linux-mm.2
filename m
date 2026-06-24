Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE5B7CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 08:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95766B0088; Wed, 24 Jun 2026 04:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46C16B008A; Wed, 24 Jun 2026 04:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34536B008C; Wed, 24 Jun 2026 04:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFB86B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:02:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F356C4028D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:02:14 +0000 (UTC)
X-FDA: 84914063388.21.45717DC
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	by imf26.hostedemail.com (Postfix) with ESMTP id 119E1140008
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:02:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=ECp2rThK;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf26.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782288133;
	b=xrSguBB9PrUZ9fL2QPoTRkW4C44aI2euw7d2fHQJhFdMbublDJjLtOttKvrF3cOenTnjV+
	UlRDwnZEFMPH0VgvalZzX6J0JB7hAByA2eUHGCP1IgLEmPVOt1IFGgYSA0sscFb9S667L6
	aVvdgATxxnFY5ozEfxmOxAFlyAEJHwo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782288133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oy+hzHbAJ+zIjfXmcA1SBk+6PTg4CnWRHTU906A5ejQ=;
	b=qmnU+lRJ++QMDO2tG5K6sKwp0+6OsT0GHyscOTNYHAlP+x4MjcGZsMD8f/8e4kf9M7zk/7
	5zlltZPe7l0LzgUdirglOcTX+j2nYvAaDarbxNgQOLTLBOb4t9WRLZlhyqbhxdB3hkVQv/
	YKMlgIIdMK4cZATV20NpSPndZRxjMQU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=ECp2rThK;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf26.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782288107; bh=oy+hzHbAJ+zIjfXmcA1SBk+6PTg4CnWRHTU906A5ejQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ECp2rThKXYqS3OfJzeXqOmQtEtSibT/nxW+7HYX1CKDjkzOxYz3ty1F2876GUJ2xj
	 +WfgHPfSv4G6z8CCXad8AVbRvvX80FgKCjj+m1T3nqryUyqCtHzKumZrYFN/xDkU/Y
	 VL3wudk61ylK9JeA+gDyIzSxdfLBDu3IyjkhRNms=
Received: from [10.46.141.45] ([36.112.3.68])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 6C038E8; Wed, 24 Jun 2026 16:01:44 +0800
X-QQ-mid: xmsmtpt1782288104tsy0lew2v
Message-ID: <tencent_E78A67F3A41E6F2352375E164D5C1FCF2208@qq.com>
X-QQ-XMAILINFO: MhK4DKsBP06i90+RqJMonSre0TH9++Ebbnp+PvKBpRydCA6r9cgvuYTLlMdYZR
	 HwiJ1Rp5okx22KcafDtqvHzLzkbqVYmcYFCgQGHJID0NEtEBdK7fANmleQQkr7Q1afv+tNa7QF3D
	 GDMWcngWgQcANiiPhNk6M/fTzmY3PHhpoWEvCQhaq16UQs1fXcWev5lAjXNODpaeeufVXujd4kRp
	 anBMH12xFBE+yqXVBfvRfZmqtLg13+X6NsaMSfZvnNQFWFKXnMQ4+bl3kM2haHpL8muP1m8YAt4T
	 mPHi6xz4Gg0j76yRE4TMrEXXqmdyakYZh7pRrughyxm1cOqbD5ND5/JUryHfmQj3XgbKUodFsKUe
	 YFeyl/MEPmIuxpvt24oJP2wJKnirc51svUY11nSS0qqRS3F/e9lVDDwg2St5qoKU5ywlHCLHMEw1
	 1lyWAQ/85/4bh0K2wLiod+gZgAznPhTspyx1f5B/P6SRVuYt3d5MYDZm/lzVbFwku8569CXT7wZ2
	 V4mV7FlTOg4tIdpHTYrfOhfhw/hBaUdqQh8r9w5T2XAI0drHlUWdspMBigSvhET+f1Pl0FEjrZJt
	 2jIweagjGxADMCX5PafCuyKqAiAqdNCj96EDkKs3cHlIey3wZdOst1+H/yacvkmPdT8mkOelzMaE
	 G9udXY+bX+EEgU/b+vtSJz2wZl77gsmgauglhENQcNaC/AeBrxokWrteil5p50uZbcmA+5nKwgQS
	 Hz3EkBc5/7J9Fn8/gtRBq6D5npKAcJHEJHVwL4gGcQPCUrOx/c5ui+As1CdwMGy4cPOTBu3B0eeE
	 lFXb6Q0AL0pmrsXMHoFZWc9ryJFpfzfcXaR7ZjXiVFLAGtWzUaOZVP9nwfM5xSpu1E290TSk9FGF
	 MYgvmMQ0fWO6gMtTgtPM3ov+P2Td60oR8obkUR5bQ5fESjIYtJMiGgrlcg0yox0Zo4ZASEeiN2+/
	 So8w7UTTd01MWoG1nM4CJeFuIZoN0m5buDxpKB0GBQ9oR7Vg3HG8f1yBNgViy5/BlAY2Kxon/uDJ
	 i+UcTrSkxlmG9WxCzhWoBGUG0kpjALDigPZvJDV7VZFeWkxR5x
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-OQ-MSGID: <4feffd96-9351-4091-b78a-bfd8c6d72cde@qq.com>
Date: Wed, 24 Jun 2026 16:01:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm/filemap] 0b9c0aeba9:
 pts.graphics-magick.Swirl.iterations_per_minute 8.6% regression
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
 Vishal Moola <vishal.moola@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <202606172137.52c5fa5e-lkp@intel.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <202606172137.52c5fa5e-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 119E1140008
X-Stat-Signature: sassfht65sdtk9n1w7rm9aytnfrgt5bt
X-HE-Tag: 1782288131-67472
X-HE-Meta: U2FsdGVkX18UE3EltYklWm0K89vJD1b4OCKWz7gYYZBGaSJBLytl1MZ21Bjqmv0YCuSeqRmcOJbEWS0t47bJLgfDlEtHYzt1HN93PsYMuIpU9HAIYOyO0bxmI6PSw57srTGVlDZOKu33+5yG5PYSe9Uoo+00856UEbjgAA6bAn0Il0fNnpNeBHGyb5RgrCW0vZ/EIyPO1mkjE33L+FgUGfgQ0gwF2jHWj8xq/3Gyu+c2oEK/XMogmcPIq7TwHg2tqZN3oT7y6CsiZwKhffIJmqC0lMENiWDA51J4o01Y87HQipbZoDmwcWMqKNrXJ1wqWVyWDpSzm6d6gtJ0kYVadeNANebIAJxXXtK36lxiW2rWgIPiP6MT7uMXHH6eZzOeB2P8iA83W00mQbcK3rzLJ12FZRzokCruSEeSEoliiDX6+uWpLkz+CSvoH2KKywXkDdWQHxs5ImEAslHlvPbv6w3toOdOgODf+CsLGk66FslxrDGhYqlUUaKxeQoVWM6AvHqiE0fGP6aDYBLaEPC/cOS4BqRsgRgL7PuDa2D0x58TeLS7Q2FhTW/7wVOtUx2/KanHt66EHsFPyYsiyGCSh8RImGiuRbMvgTm3exycCmQWOtWKAOshKaQTFvVXVJFZcAMYJFvPZltDF7Y5L3z3gSWJUOSEpC9bPOytEga9BPAZdsRCTMYRLn50Q0oWcZeU4yb3QzDjQNG1XxbWGsksX7f2FJ93slgTYjj2P96l9r/gE72wgxOH0SLltlnXZkluc3L0f66rpUV9BZfV+R6Dej2UAAJpJP50FcVjZyaoAH553ny7X/5Mg7snieusWGUnjh18+4youI6MvaNsU71rPomWctNUXxxiSy6CMdWEknpyL80vfnU04EBPF62fKKifZNjd6oBbcVruBjKBqEshjs1Sr/HfDYkaUjSds/gAKh5Hs7VjJ4c0bcyLNzJ8pVPo8t5MTLm+sFp7wbVNrXY
 WkZT10A9
 a/dtFhInqLa7n1hUrgO/f2ztNl8lEZhmdKHHDXJXqkND5SWg1DaYR0jaQonEcIrb8hJp5OjAoOD0ieGF2MfR19G/pT6TP76iLZCFX/w8UTHXErOpYRlskUdvT0BEI1Y7rdgTcuyqPXy8zrkXYGxzPXzG9PKFZ1BPjZdDc1/paMVdHLCZZPNnm85MrKNufBFMnf4ZPfA14mHgw7kj66wwIhECH0M4yRXbY7KKX/CBYLyJzX80rTZfzuz8e4niwZOjZScbwwASRXm9LlL/bhEhaUQdvj38SzlFDhTvulTrnCE++QnMn78GH6/XNx/jlMtV9k8V6AqxsTuqZO9fFIJp5VDDnvS+rrQF31ID9ryGfRGSloGBjCyIslV/C6W25C4s91KoDfZ0iZUgEIZyYBsexMek5wqlW/jjmyBXfy5nrQU1rucPM5kalWVreYHFFYWi5SLqPpDv/JlM/teyPsgJEZ/iX3YbB6N3qweWJ0j0s2F4XpRDWQ43CRTIJMyetsy71Vt6qlhb1+D6rmpGZYQa3EwX/833uYD1owHXS5FE3rlUO7+wMjjS9UlsXocqFyXf2SKvjVddAjNe2/0iDFYcpkDWocR/Q6Fk7glAE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/17/2026 10:26 PM, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 8.6% regression of pts.graphics-magick.Swirl.iterations_per_minute on:
> 
> 
> commit: 0b9c0aeba938aad9964f855df00bf929b83a484d ("mm/filemap: count only the faulting address as a mmap hit")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [still regression on linux-next/master ec039126b7fac4e3af35ebccaa7c6f9b6875ba81]
> 
> testcase: pts
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6767P  CPU @ 2.4GHz (Granite Rapids) with 256G memory
> parameters:
> 
> 	test: graphics-magick-2.2.0
> 	option_a: Swirl
> 	cpufreq_governor: performance
> 
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202606172137.52c5fa5e-lkp@intel.com
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260617/202606172137.52c5fa5e-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/option_a/rootfs/tbox_group/test/testcase:
>   gcc-14/performance/x86_64-rhel-9.4/Swirl/debian-12-x86_64-phoronix/lkp-gnr-2sp3/graphics-magick-2.2.0/pts
> 
> commit: 
>   95b8e43226 ("mm: use zone lock guard in __offline_isolated_pages()")
>   0b9c0aeba9 ("mm/filemap: count only the faulting address as a mmap hit")
> 
> 95b8e432265f61bd 0b9c0aeba938aad9964f855df00 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>     814.83            -8.6%     745.00        pts.graphics-magick.Swirl.iterations_per_minute
>      55127 ±  5%     -10.3%      49460 ±  3%  pts.time.involuntary_context_switches
>       2153 ±  5%   +5894.6%     129074 ±  6%  pts.time.major_page_faults
>   12775652            -8.5%   11686096        pts.time.minor_page_faults
>      15099            -8.1%      13876        pts.time.percent_of_cpu_this_job_got
>       2124            -4.0%       2039        pts.time.system_time
>       9036            -9.2%       8207        pts.time.user_time
>    4500789            -4.4%    4301829        pts.time.voluntary_context_switches
>      12315 ±  4%     +10.6%      13616 ±  4%  meminfo.PageTables
>    1828588 ±  5%     -10.9%    1629373 ±  2%  numa-numastat.node1.numa_hit
>    1828671 ±  5%     -10.9%    1629233 ±  2%  numa-vmstat.node1.numa_hit
>       1.34 ±  3%      +0.2        1.55        mpstat.cpu.all.iowait%
>       0.10 ±  3%      +0.0        0.12 ±  3%  mpstat.cpu.all.soft%
>      78.37            -6.7%      73.12        mpstat.max_utilization_pct
>       2.44 ± 66%      +4.8        7.24 ± 58%  perf-profile.calltrace.cycles-pp.sw_perf_event_destroy.__free_event.perf_event_release_kernel.perf_release.__fput
>       2.98 ± 59%      +5.8        8.81 ± 33%  perf-profile.calltrace.cycles-pp.__free_event.perf_event_release_kernel.perf_release.__fput.task_work_run
>       2.44 ± 66%      +4.8        7.24 ± 49%  perf-profile.children.cycles-pp.sw_perf_event_destroy
>       2.98 ± 59%      +5.8        8.81 ± 33%  perf-profile.children.cycles-pp.__free_event
>       3149 ±  2%      +7.2%       3376 ±  2%  proc-vmstat.nr_page_table_pages
>     443579            -1.9%     435060        proc-vmstat.nr_shmem
>    3584637 ±  3%      -7.2%    3324877        proc-vmstat.numa_hit
>    3319585 ±  3%      -7.8%    3060170        proc-vmstat.numa_local
>  3.533e+08           -13.0%  3.075e+08        proc-vmstat.pgalloc_normal
>   13271607            -7.4%   12294786        proc-vmstat.pgfault
>  3.527e+08           -13.0%  3.069e+08        proc-vmstat.pgfree
>       2086 ±  5%   +6047.5%     128277 ±  6%  proc-vmstat.pgmajfault
>     166303            -8.6%     152057        proc-vmstat.thp_fault_alloc
>      28.46 ±  2%      +1.0       29.44        perf-stat.i.cache-miss-rate%
>       3164 ±  6%     +24.3%       3933 ±  2%  perf-stat.i.cpu-migrations
>      28.98 ±  7%   +5995.2%       1766 ±  6%  perf-stat.i.major-faults
>       0.44            +2.6%       0.46        perf-stat.overall.MPKI
>       0.01            +0.0        0.01        perf-stat.overall.branch-miss-rate%
>       1719            -1.6%       1692        perf-stat.overall.cycles-between-cache-misses
>      59.55            +1.9       61.43        perf-stat.overall.node-load-miss-rate%
>       3138 ±  6%     +23.7%       3880 ±  2%  perf-stat.ps.cpu-migrations
>      28.03 ±  7%   +5980.2%       1704 ±  6%  perf-stat.ps.major-faults
>  5.496e+13            -8.5%  5.028e+13        perf-stat.total.instructions
>       1.41 ± 36%     +83.3%       2.58 ± 11%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       1.17 ± 34%     -82.8%       0.20 ±169%  perf-sched.sch_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
>       7.34           +11.2%       8.15        perf-sched.total_wait_and_delay.average.ms
>     366839            -7.5%     339473        perf-sched.total_wait_and_delay.count.ms
>       7.32           +11.2%       8.14        perf-sched.total_wait_time.average.ms
>       3.58           +24.1%       4.45 ±  2%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.futex_do_wait.__futex_wait.futex_wait.do_futex
>       0.38 ±  2%     +48.1%       0.57 ±  2%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.io_schedule.folio_wait_bit_common.filemap_fault.__do_fault
>       4.64 ±101%    +192.3%      13.57 ± 23%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk._raw_spin_unlock.__do_huge_pmd_anonymous_page.__handle_mm_fault
>       7.14 ± 45%     +73.8%      12.41 ±  3%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault
>     339.44 ±  3%     +18.1%     400.91 ±  3%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0
>      58862            -8.3%      53992        perf-sched.wait_and_delay.count.perf_trace_sched_switch.futex_do_wait.__futex_wait.futex_wait.do_futex
>     294758            -7.6%     272232        perf-sched.wait_and_delay.count.perf_trace_sched_switch.io_schedule.folio_wait_bit_common.filemap_fault.__do_fault
>     113.17 ±  4%     -12.1%      99.50 ±  2%  perf-sched.wait_and_delay.count.perf_trace_sched_switch.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0
>       7.56 ±100%    +191.1%      22.02 ±  3%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk._raw_spin_unlock.__do_huge_pmd_anonymous_page.__handle_mm_fault
>      15.87 ±  3%     +36.3%      21.64        perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.cpu_stop_queue_work.stop_one_cpu.migrate_task_to
>      14.18 ± 45%     +67.2%      23.71 ±  6%  perf-sched.wait_and_delay.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault
>       3.55           +24.2%       4.41 ±  2%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.futex_do_wait.__futex_wait.futex_wait.do_futex
>       0.37 ±  2%     +49.8%       0.56 ±  2%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.io_schedule.folio_wait_bit_common.filemap_fault.__do_fault
>       2.43 ± 14%     +91.5%       4.66 ± 16%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.irqentry_exit.asm_exc_page_fault.[unknown].[unknown]
>       6.68 ± 50%    +103.0%      13.55 ± 23%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk._raw_spin_unlock.__do_huge_pmd_anonymous_page.__handle_mm_fault
>       8.24 ±  8%     +50.0%      12.36 ±  3%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.preempt_schedule_thunk.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault
>     339.33 ±  3%     +18.1%     400.81 ±  3%  perf-sched.wait_time.avg.ms.perf_trace_sched_switch.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0
>      15.55 ±  3%     +52.0%      23.65 ± 14%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_exc_page_fault.[unknown].[unknown]
>      14.33 ±  6%     +53.7%      22.03 ±  5%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.irqentry_exit.asm_sysvec_call_function_single.[unknown]
>      15.24 ±  5%     +44.4%      22.01 ±  5%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_irq.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_user_addr_fault
>      12.27 ± 44%     +79.4%      22.01 ±  3%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk._raw_spin_unlock.__do_huge_pmd_anonymous_page.__handle_mm_fault
>      15.86 ±  3%     +36.3%      21.63        perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.cpu_stop_queue_work.stop_one_cpu.migrate_task_to
>      14.53 ±  3%     +45.3%      21.10 ±  3%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.do_read_fault.do_fault.__handle_mm_fault
>      15.90 ±  5%     +41.6%      22.51 ±  2%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault
>      10.27 ± 61%    +100.7%      20.61 ±  2%  perf-sched.wait_time.max.ms.perf_trace_sched_switch.preempt_schedule_thunk.stop_two_cpus.migrate_swap.task_numa_migrate
>    4282234           -17.3%    3541405        sched_debug.cfs_rq:/.avg_vruntime.avg
>    4735201 ±  2%     -13.9%    4076046 ±  4%  sched_debug.cfs_rq:/.avg_vruntime.max
>    4115256           -17.0%    3417248 ±  2%  sched_debug.cfs_rq:/.avg_vruntime.min
>     423.15 ±  2%      -9.6%     382.71        sched_debug.cfs_rq:/.runnable_avg.avg
>     420.53 ±  2%      -9.6%     380.35        sched_debug.cfs_rq:/.util_avg.avg
>       1190 ±  4%      -9.6%       1077 ±  3%  sched_debug.cfs_rq:/.util_avg.max
>     286.15 ±  7%     -14.4%     244.91 ±  7%  sched_debug.cfs_rq:/.util_est.avg
>    4282232           -17.3%    3541404        sched_debug.cfs_rq:/.zero_vruntime.avg
>    4735201 ±  2%     -13.9%    4076017 ±  4%  sched_debug.cfs_rq:/.zero_vruntime.max
>    4115256           -17.0%    3417248 ±  2%  sched_debug.cfs_rq:/.zero_vruntime.min
>    4263217           -16.9%    3544690        sched_debug.cfs_rq:/init.scope.se->vruntime.avg
>    4263686           -16.8%    3545475        sched_debug.cfs_rq:/init.scope.se->vruntime.max
>    4262749           -16.9%    3543905        sched_debug.cfs_rq:/init.scope.se->vruntime.min
>    3220012           -14.8%    2744219        sched_debug.cfs_rq:/system.slice.avg_vruntime.avg
>    3545518           -10.9%    3160659 ±  3%  sched_debug.cfs_rq:/system.slice.avg_vruntime.max
>    3158026           -15.2%    2679207        sched_debug.cfs_rq:/system.slice.avg_vruntime.min
>     448.40 ±  2%      -9.4%     406.19        sched_debug.cfs_rq:/system.slice.runnable_avg.avg
>     448.42 ±  2%      -9.4%     406.17        sched_debug.cfs_rq:/system.slice.se->avg.runnable_avg.avg
>     445.86 ±  2%      -9.3%     404.18        sched_debug.cfs_rq:/system.slice.se->avg.util_avg.avg
>       1190 ±  4%      -9.6%       1077 ±  3%  sched_debug.cfs_rq:/system.slice.se->avg.util_avg.max
>      17612            -8.0%      16195        sched_debug.cfs_rq:/system.slice.se->sum_exec_runtime.avg
>      17072            -8.4%      15640        sched_debug.cfs_rq:/system.slice.se->sum_exec_runtime.min
>    4282329           -17.3%    3541763        sched_debug.cfs_rq:/system.slice.se->vruntime.avg
>    4734174 ±  2%     -13.9%    4074191 ±  4%  sched_debug.cfs_rq:/system.slice.se->vruntime.max
>    4115719           -17.0%    3417711 ±  2%  sched_debug.cfs_rq:/system.slice.se->vruntime.min
>     445.87 ±  2%      -9.3%     404.21        sched_debug.cfs_rq:/system.slice.util_avg.avg
>       1190 ±  4%      -9.6%       1077 ±  3%  sched_debug.cfs_rq:/system.slice.util_avg.max
>    3220012           -14.8%    2744218        sched_debug.cfs_rq:/system.slice.zero_vruntime.avg
>    3545518           -10.9%    3160649 ±  3%  sched_debug.cfs_rq:/system.slice.zero_vruntime.max
>    3158026           -15.2%    2679207        sched_debug.cfs_rq:/system.slice.zero_vruntime.min
>    3201153           -14.7%    2731311        sched_debug.cfs_rq:/system.slice/containerd.service.se->vruntime.avg
>    3249048           -13.6%    2808484 ±  3%  sched_debug.cfs_rq:/system.slice/containerd.service.se->vruntime.max
>    3153595           -14.8%    2685843        sched_debug.cfs_rq:/system.slice/containerd.service.se->vruntime.min
>      56.08 ± 17%     -29.3%      39.67 ±  9%  sched_debug.cfs_rq:/system.slice/containerd.service.tg_load_avg.avg
>     128.83 ± 17%     -25.5%      96.00 ± 24%  sched_debug.cfs_rq:/system.slice/containerd.service.tg_load_avg.max
>      25.42 ± 31%     -34.4%      16.67 ± 30%  sched_debug.cfs_rq:/system.slice/containerd.service.tg_load_avg.min
>      27.90 ± 11%     -35.1%      18.10 ± 26%  sched_debug.cfs_rq:/system.slice/containerd.service.tg_load_avg.stddev
>      17409            -8.0%      16022        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.avg_vruntime.avg
>      16929            -8.3%      15524        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.avg_vruntime.min
>     157.14 ± 19%     -60.4%      62.15 ± 57%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_deadline.avg
>      17300           -23.2%      13285 ± 44%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_deadline.max
>       1631 ±  9%     -45.1%     895.75 ± 47%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_deadline.stddev
>     157.13 ± 19%     -60.5%      62.14 ± 57%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_vruntime.avg
>      17298           -23.2%      13283 ± 44%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_vruntime.max
>       1631 ±  9%     -45.1%     895.61 ± 47%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.left_vruntime.stddev
>     504.25 ±  3%      -8.3%     462.57        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.load_avg.avg
>     157.13 ± 19%     -60.5%      62.14 ± 57%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.right_vruntime.avg
>      17298           -23.2%      13283 ± 44%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.right_vruntime.max
>       1631 ±  9%     -45.1%     895.61 ± 47%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.right_vruntime.stddev
>     449.13 ±  2%      -9.2%     407.68        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.runnable_avg.avg
>     448.89 ±  2%      -9.3%     407.10        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->avg.runnable_avg.avg
>     446.27 ±  2%      -9.2%     405.04        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->avg.util_avg.avg
>       1190 ±  4%      -9.5%       1078 ±  3%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->avg.util_avg.max
>      17428            -8.0%      16038        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->sum_exec_runtime.avg
>      16954            -8.3%      15542        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->sum_exec_runtime.min
>    3220022           -14.8%    2744222        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->vruntime.avg
>    3545518           -10.9%    3160659 ±  3%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->vruntime.max
>    3158026           -15.2%    2679207        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.se->vruntime.min
>     117383            -8.5%     107420        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.tg_load_avg.avg
>      93409 ±  4%     -12.8%      81492 ±  2%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.tg_load_avg.min
>      11146 ± 12%     +23.7%      13782 ±  4%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.tg_load_avg.stddev
>     504.19 ±  2%      -7.4%     467.07 ±  2%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.tg_load_avg_contrib.avg
>     446.38 ±  2%      -9.2%     405.51        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.util_avg.avg
>       1191 ±  4%      -9.5%       1078 ±  3%  sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.util_avg.max
>      17409            -8.0%      16021        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.zero_vruntime.avg
>      16929            -8.3%      15524        sched_debug.cfs_rq:/system.slice/lkp-bootstrap.service.zero_vruntime.min
>    3219034           -15.3%    2727012        sched_debug.cfs_rq:/system.slice/redis-server.service.se->vruntime.avg
>    3233948           -15.3%    2739777        sched_debug.cfs_rq:/system.slice/redis-server.service.se->vruntime.max
>    3203580           -15.4%    2711785        sched_debug.cfs_rq:/system.slice/redis-server.service.se->vruntime.min
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

Thanks for the report.

The large increase in major faults does look related to this mmap_miss
accounting change.  The patch avoids counting all fault-around-installed
neighbouring PTEs as mmap readahead hits, but this workload may have
useful spatial locality where that feedback matters.

I will look into this and try to narrow down a suitable fix.

Thanks,
fujunjie


