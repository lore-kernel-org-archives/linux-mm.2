Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73D2CCD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544176B00D0; Thu, 18 Jun 2026 05:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4696B00D7; Thu, 18 Jun 2026 05:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BD56B00D9; Thu, 18 Jun 2026 05:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04BDE6B00D0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:37:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34AD71667FC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:30:56 +0000 (UTC)
X-FDA: 84892514112.12.30CE79A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id B52EC1C000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:30:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IyVm5ASd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SgCog+oe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IyVm5ASd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SgCog+oe;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781775054;
	b=Dl/U0u/GTI/YvAMa/JQ+5WaR5saKQQmK0WVNAEN1ENjQq0v4n/+D4gR3kNYiUlt+yArDvM
	8ccZsrdK2i1gVT8ShiaOh1519RfpOt+PWyTLMgcZc1MCM/JbMY8L9TrPwvMAar714FwMim
	i1eoCScyS06Fwe+FE6Edn/318R5ZKgA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IyVm5ASd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SgCog+oe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IyVm5ASd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SgCog+oe;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781775054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jy6/lY/NpgroWbd+mDmLXysMTCYaLlZK8pTXTY7oCKk=;
	b=nTPggJulE8+i3THCAtigRFlfvpPG1TOpjtd/LR+88/TbmoRtlXwotw8o4Th9u0XybVDjt2
	fegB88/S6sDK0cYhLb5LQgGimfZNEGz61p8Wu0/JluEGkvJI5vQ13wbPgKZwKaVxh0iPXW
	3XU2JaOgl7dXwAA9KzTtpkOwXEV4460=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2183D75E7D;
	Thu, 18 Jun 2026 09:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781775052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jy6/lY/NpgroWbd+mDmLXysMTCYaLlZK8pTXTY7oCKk=;
	b=IyVm5ASdDqN3iIRQmGXExNxYxhhcksmY4hOxk39G9soc8AVp93iH0Eozk5ZnTE+bYnPvjo
	mdQW8qMCFiI65DdPS63+T7DOJZ43kmSFaj0auhQyYdS3sNQ9P4Lyv3a2BwpxBL/5MdumAe
	DcQW3gSZYda19uu7YvudaXmv/lUkAAY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781775052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jy6/lY/NpgroWbd+mDmLXysMTCYaLlZK8pTXTY7oCKk=;
	b=SgCog+oervILvxLOB0qLY3oIKJMeB6z6rRFI2aqQgcHpxKDyQoTJuW8/xkBTyh4+qy6njR
	8w109EiMd837d4DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781775052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jy6/lY/NpgroWbd+mDmLXysMTCYaLlZK8pTXTY7oCKk=;
	b=IyVm5ASdDqN3iIRQmGXExNxYxhhcksmY4hOxk39G9soc8AVp93iH0Eozk5ZnTE+bYnPvjo
	mdQW8qMCFiI65DdPS63+T7DOJZ43kmSFaj0auhQyYdS3sNQ9P4Lyv3a2BwpxBL/5MdumAe
	DcQW3gSZYda19uu7YvudaXmv/lUkAAY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781775052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jy6/lY/NpgroWbd+mDmLXysMTCYaLlZK8pTXTY7oCKk=;
	b=SgCog+oervILvxLOB0qLY3oIKJMeB6z6rRFI2aqQgcHpxKDyQoTJuW8/xkBTyh4+qy6njR
	8w109EiMd837d4DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 13762779A8;
	Thu, 18 Jun 2026 09:30:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z8K9BMy6M2qPbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 09:30:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A8765A0EC0; Thu, 18 Jun 2026 11:30:47 +0200 (CEST)
Date: Thu, 18 Jun 2026 11:30:47 +0200
From: Jan Kara <jack@suse.cz>
To: kernel test robot <oliver.sang@intel.com>
Cc: Frederick Mayle <fmayle@google.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	Jan Kara <jack@suse.cz>, Kalesh Singh <kaleshsingh@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Suren Baghdasaryan <surenb@google.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm]  7b32f64bc5:
 pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Message-ID: <6z2rqmo7b6m2rdhqurspwya25ps4dj7lctdygnmq3rn4xt6h3i@57kiiy72epgd>
References: <202606181547.617a6967-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202606181547.617a6967-lkp@intel.com>
X-Rspamd-Queue-Id: B52EC1C000B
X-Stat-Signature: c18zn1yck6kt6kodnzrphuc191xa7qh4
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781775053-259750
X-HE-Meta: U2FsdGVkX1/BDQEvl8PB/Y7B2SQfL1V7xIGWU9z78O1Oozpbi1/9yi+6VTKWAIZ7wrZ0d0yFlo4xMnFVh5XfMliIlyWWu1wRjeG+J77xNPVArAcv2GfLZLkUqm6oPX03vTq1rZt62wwrf5t2MM8Va1fATj8N1bOQjJdZ5+tklO3Hjt37jc6WP77k94tePo6J0hO5Pc+knE6pqvBWTOO1b11YR04adzsKca2vTmmDDgFBsKPy8MeIhFTVRf7vrT7RVXi21ZEDipBe/aqCSRQ5/HYpD8nPkedm2/SRoBpVVyRHYQNid8AHSofT2tzq5PEG0g7iwVOHOEjaMNGb3jkQ0EHMPCObArDhsdhn4W12WSnvwBoGLrHVVIohk8Flwm6MSw/8C3lmz79sl2H4holfiiVqwHLwdw4ehJPXEOvNnv4NxKWyMppxcU2XfBWolTfhEGQ26PTwN64BtgJPeWr3NsvpX6+ywEg7N+AmDj24Gz17mBaQgF1s02oQtNiz3mgyZRPAdBTj7HWEWcWenPRQZgvBxsD9BIjnFb8D/Ta2A2B7zq3Pk5x2RSxQVR5W3XQj3+gByZ6FatdycI/F9oL174CSw2xqFg12j/WRHR/upkeY6w0Vi2JRi96MD2BxPQZpvfdPH8sIwB3tT9FIYELPZS8Hs771GK7NERorztqhvLXsjIDEqvhDwBQQrRLq3j+Y1yXommHvVR3AdTY02Hssz9HOjfMXXt7DJ7Qa7/LEkI6MfrtdZQ+nsL4uzAx63SSqr8epj7GesYPCu1sMaq1dqL3i5Lv+/93+wmP6T3fzmzLo4erqdYUcB0CEKW+pOdmIvA3VmFy2i80+g5e8xvtIXhn9LPUFrA4WATvh7IKbnAkx6nD1viuwrc3vtoJ0Wi0uq9osz9L0j0AkBFYjGxpsfSGnPtTv0iKXSGUf2XVqvBAP1/NZcVyO9cFGksJxKGXgay1K2mS7EpRGiEMq9jv
 n/EkEdrB
 MRZJYkE+nJ3FQEpYk5/RFOHKPJ/5LY4XnSnsamIWq84ZM3oJo6QkUj6Gn2K/aNPcAw6wsElZDVVb4IRHE7K2z6YC6UBFkHAJJtlbiQ/XVWunnNuI+kxibyN9TkeGuTTpwdyyvwi06C6ycnBqYR+9L8sKr01VLUBkL8+omi0kEMThe+gKKQvv9nqg7A/z0KAq0Coba97xEva2rz88MGE0Qp1Nx2NMjDKzHvOtZa4R7cYa50X6aQzNc6GKqDbUW9MLvlve+j+xWJ6+rZvkI9tUTM7v5MDn3P38uTP19k8vrVZTfHaWrUSkNk0ymRjMB6MwngdTytRzbeuXRk/4SWQSLdKaxikeJduheFI12ngq2pBhYPk/pxYTiBm/yif8+h/f8SXgRDqi3uLp+O5DLKyCS3ebfypOonbu8nwD0unv4ZptlcejbCwzYgn/3l7hJLfOoN/fJEbjCWYmYPHR5cfg/UuBmP6HjH/tTvLkGtkIVk1cWqM0Y83i1d1BtPKWnkHK5BaBFNq4QSNZyVqoMu2vriufbFZmFlVcsULVe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 18-06-26 16:00:42, kernel test robot wrote:
> Hello,
> 
> kernel test robot noticed a 45.8% regression of pts.svt-av1.Preset13.Bosphorus4K.frames_per_second on:

This one looks serious enough and real. It would be good to figure out what
happens in this benchmark that it benefits from the readahead across VMA
boundaries so much...

								Honza


> commit: 7b32f64bc512b40b268776c5ac4d354b325b3197 ("mm: limit filemap_fault readahead to VMA boundaries")
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
> 	test: svt-av1-2.11.1
> 	option_a: 1
> 	option_b: Bosphorus 4K
> 	cpufreq_governor: performance
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202606181547.617a6967-lkp@intel.com
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260618/202606181547.617a6967-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/option_a/option_b/rootfs/tbox_group/test/testcase:
>   gcc-14/performance/x86_64-rhel-9.4/1/Bosphorus 4K/debian-12-x86_64-phoronix/lkp-gnr-2sp3/svt-av1-2.11.1/pts
> 
> commit: 
>   0b20c36c11 ("mm/madvise: reject invalid process_madvise() advice for zero-length vectors")
>   7b32f64bc5 ("mm: limit filemap_fault readahead to VMA boundaries")
> 
> 0b20c36c118d2122 7b32f64bc512b40b268776c5ac4 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>     169.95 ±  6%     -45.8%      92.15 ± 10%  pts.svt-av1.Preset13.Bosphorus4K.frames_per_second
>     220.57 ±  3%    +870.9%       2141        pts.time.major_page_faults
>    5898121            -3.7%    5682645        pts.time.maximum_resident_set_size
>    1408522            -1.3%    1390537        pts.time.minor_page_faults
>     370.43 ±  3%     -12.1%     325.57 ±  6%  pts.time.percent_of_cpu_this_job_got
>     645228 ±  2%      +7.6%     694407 ±  3%  pts.time.voluntary_context_switches
>     162542 ±  7%     +22.4%     198946 ±  8%  sched_debug.cpu.avg_idle.stddev
>     274573 ±  3%      -9.3%     249101 ±  3%  vmstat.io.bi
>  6.779e+09 ±  3%     +11.3%  7.545e+09 ±  4%  cpuidle..time
>    7639156 ±  3%     +10.5%    8439210 ±  3%  cpuidle..usage
>       3.73 ± 39%      -2.2        1.52 ± 52%  perf-profile.calltrace.cycles-pp.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state
>       0.65 ± 87%      +1.8        2.47 ± 60%  perf-profile.children.cycles-pp.link_path_walk
>       0.24 ± 46%     -80.9%       0.05 ±143%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       0.65 ± 18%     -33.7%       0.43 ± 17%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       0.02 ±  7%      +0.0        0.06 ±  8%  mpstat.cpu.all.iowait%
>       1.08 ±  4%      -0.2        0.93 ±  6%  mpstat.cpu.all.usr%
>      22.00 ±  2%     +14.3%      25.14 ±  2%  mpstat.max_utilization.seconds
>      10.00 ±  3%     -40.5%       5.94 ±  2%  mpstat.max_utilization_pct
>    5916248            +6.9%    6324576        meminfo.Active
>    3659476 ±  2%     +11.4%    4078190 ±  2%  meminfo.Active(anon)
>     760816 ±  3%     +16.9%     889730 ±  3%  meminfo.AnonHugePages
>    2263661 ±  4%     +18.5%    2682180 ±  3%  meminfo.AnonPages
>    6611024           +11.9%    7400589 ±  2%  meminfo.Committed_AS
>   11386404            +5.1%   11964152        meminfo.Memused
>      21554            +5.6%      22770 ±  2%  meminfo.PageTables
>     916081 ±  2%     +11.4%    1020691 ±  2%  proc-vmstat.nr_active_anon
>     567129 ±  3%     +18.4%     671694 ±  3%  proc-vmstat.nr_anon_pages
>     370.88 ±  3%     +17.2%     434.57 ±  3%  proc-vmstat.nr_anon_transparent_hugepages
>      48477            +1.6%      49272        proc-vmstat.nr_kernel_stack
>       5399            +5.4%       5691 ±  2%  proc-vmstat.nr_page_table_pages
>     916081 ±  2%     +11.4%    1020691 ±  2%  proc-vmstat.nr_zone_active_anon
>    4614742            -1.5%    4547741        proc-vmstat.pgalloc_normal
>    1667517            -1.0%    1650517        proc-vmstat.pgfault
>    2150014            -2.9%    2087812        proc-vmstat.pgfree
>     224.57 ±  3%    +862.1%       2160        proc-vmstat.pgmajfault
>       1021            -7.2%     948.14        proc-vmstat.thp_fault_alloc
>  2.679e+09 ±  3%      -7.5%  2.477e+09 ±  2%  perf-stat.i.branch-instructions
>       0.80            +0.1        0.86        perf-stat.i.branch-miss-rate%
>   27722463 ±  3%      -8.0%   25498433 ±  2%  perf-stat.i.branch-misses
>   47056892 ±  6%     -11.2%   41804370 ±  6%  perf-stat.i.cache-misses
>     397.43 ±  3%      -7.4%     368.14 ±  2%  perf-stat.i.cpu-migrations
>       0.03 ±  4%      +0.0        0.03 ±  4%  perf-stat.i.dTLB-load-miss-rate%
>    3146082 ±  5%     -13.9%    2707716 ±  5%  perf-stat.i.dTLB-load-misses
>    1739613 ±  5%     -12.5%    1521663 ±  4%  perf-stat.i.dTLB-store-misses
>       9.97 ±  5%    +712.5%      81.01 ±  3%  perf-stat.i.major-faults
>      40.27 ±  4%      -8.2%      36.99 ±  3%  perf-stat.i.metric.M/sec
>      58347 ±  4%     -11.5%      51627 ±  3%  perf-stat.i.minor-faults
>      63.09 ±  6%      -5.8       57.29 ±  8%  perf-stat.i.node-load-miss-rate%
>    6474191 ±  5%     -14.1%    5560267 ±  5%  perf-stat.i.node-loads
>      58356 ±  4%     -11.4%      51708 ±  3%  perf-stat.i.page-faults
>       0.98            -0.0        0.96        perf-stat.overall.branch-miss-rate%
>     435.13 ±  3%     +10.0%     478.43 ±  4%  perf-stat.overall.cycles-between-cache-misses
>       0.06 ±  2%      -0.0        0.06 ±  4%  perf-stat.overall.dTLB-load-miss-rate%
>       0.08 ±  2%      -0.0        0.07 ±  2%  perf-stat.overall.dTLB-store-miss-rate%
>  2.646e+09 ±  3%      -8.7%  2.415e+09 ±  2%  perf-stat.ps.branch-instructions
>   25808992 ±  3%     -10.2%   23188954 ±  2%  perf-stat.ps.branch-misses
>   45057464 ±  5%     -14.4%   38574053 ±  6%  perf-stat.ps.cache-misses
>  1.428e+08 ±  3%      -9.7%  1.289e+08 ±  2%  perf-stat.ps.cache-references
>     367.11 ±  2%      -7.4%     339.78 ±  2%  perf-stat.ps.cpu-migrations
>    2972584 ±  5%     -17.3%    2458144 ±  5%  perf-stat.ps.dTLB-load-misses
>  4.801e+09 ±  3%      -9.2%  4.359e+09 ±  2%  perf-stat.ps.dTLB-loads
>    1715051 ±  5%     -14.7%    1462728 ±  4%  perf-stat.ps.dTLB-store-misses
>  2.193e+09 ±  3%      -9.2%  1.992e+09 ±  2%  perf-stat.ps.dTLB-stores
>   2.06e+10 ±  3%      -9.2%  1.871e+10 ±  2%  perf-stat.ps.instructions
>       8.54 ±  4%    +768.3%      74.19 ±  2%  perf-stat.ps.major-faults
>      59802 ±  3%     -11.0%      53218 ±  3%  perf-stat.ps.minor-faults
>    6145046 ±  4%     -17.9%    5046537 ±  4%  perf-stat.ps.node-loads
>      59810 ±  3%     -10.9%      53292 ±  3%  perf-stat.ps.page-faults
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
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

