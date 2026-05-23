Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F62CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 15:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF126B0096; Sat, 23 May 2026 11:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FF46B0098; Sat, 23 May 2026 11:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CB16B0099; Sat, 23 May 2026 11:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43DFB6B0096
	for <linux-mm@kvack.org>; Sat, 23 May 2026 11:12:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C88ECC34B2
	for <linux-mm@kvack.org>; Sat, 23 May 2026 15:12:46 +0000 (UTC)
X-FDA: 84799026732.22.0D67400
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 17CD280014
	for <linux-mm@kvack.org>; Sat, 23 May 2026 15:12:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2FJ4aZDG;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf30.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779549165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Myg1tl30/7kM6tmk+zneEJGFOpU3f3rcS+xKvSTU4wY=;
	b=279cutY3D2aN5dgzudzy7QyfJcZB/hlsUw8Ghr7Q+cdXPQ/GSi+pw2Swv2R5gZGu7GpsiP
	ZtGWKH8uCacT3494DTTCucBg9lWW58F4xSqTPgfa8XZyqBP2uGstJBRBdDo4J5wBqQalqV
	XeLvW6ouJ5/u8ZrfZg7OIa9gu6V2aAw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2FJ4aZDG;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf30.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779549165; a=rsa-sha256;
	cv=none;
	b=ih9UhPyCxJF5PeF5gQrE7Lh/+BAbPS8Guk78taiCOnPU4odtrmmxJUJai4GKV4TK29qR+M
	koFcLFpkhjnUNOAEKpSke3zMwvXhyAkZnMYg3BpW69B0QtHGjD0D73cPbXRcaKtVDsHqiq
	uRSFxjVmO6KW3aDsPfVF21A8feEUKrs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Myg1tl30/7kM6tmk+zneEJGFOpU3f3rcS+xKvSTU4wY=; b=2FJ4aZDGqoLFj0pCF2d5vMtriM
	in9yk9l3JAtJc8EfLPSb80n2uq8irr4eEmLjQKwRX45XyPrLjLcXVnNMYZZh/besOlZUeOkbFqIdq
	1ybdW+Y6kaqf3vVySDy2ZBuQ1F0XiLfa5ovjYYSMr+pkkfONftlurtqbklWQNC7xDA+QpG3vxFKPl
	x6BbESfmNpfEnB+g45B4ZVx3WAZN68Wh779ueObwI61GWzJX9iSpNTJjsDZWkbnrzi3aETU5pZne+
	Y7aZxcE0E3lEveAXEGo7c3tQQcDqvlG5pyghNgd/0bWpm9MTx++ahoHBNYBmsfHyD25Tmm8aEKFfJ
	JjwppYqA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQo1b-0000000DTXy-1QrC;
	Sat, 23 May 2026 15:12:27 +0000
Date: Sat, 23 May 2026 11:12:24 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Oliver Sang <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Matthew Wilcox <willy@infradead.org>, 
	SeongJae Park <sj@kernel.org>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org
Subject: Re: [linus:master] [maple_tree]  280b792cac:
 will-it-scale.per_process_ops 6.0% regression
Message-ID: <wbgsjfbbiwmx2glp72ifomyb6fb7uc4lwffwg5z2inv4tzskbf@ufgets7hbskz>
References: <202605131554.92e7df6b-lkp@intel.com>
 <22y6gvr7yzwdocwpd3wxrxfykmpvhbxytiiuht32db3dh7w522@pglkrpqognjk>
 <agV3Q2fBlQrB5v9w@xsang-OptiPlex-9020>
 <g7pvhqnuloifqhbvjgtgydbitcrvmxibferexj7cunsmagttps@oxjvs3aa3l3s>
 <ahFciGk6LfkOU2en@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahFciGk6LfkOU2en@xsang-OptiPlex-9020>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17CD280014
X-Stat-Signature: 5pk73wdya3rjok5581zrij3ecfft673s
X-Rspam-User: 
X-HE-Tag: 1779549163-761200
X-HE-Meta: U2FsdGVkX1/RQIoS6hVFzm7Txug6IEOehpyG2dBUBF3wgvM87v5eYavSrzh1CMl8n352SbUDS+OZ5906x2z2aRL+PWjveNzTtAjUuLaUN8S0veXckKF3/NemP7/MBuY8H1kid+Hza+eO92Z4uoPWRQ/YgzKjE7t99KUsZeTgcct8b0x0IFhqcHgHoAVYJAdf5eIhFfgvw0xa6dQjg9JhlqaEu+uG5Rh0d+HUx8DPgYMjHkdoAg19QFeag/ZbU2UHk/ZVrMi/t6pic3VFvegSqQbzEAoWmETr77Gp52mFws4izGaSCVAl7T7kaUGgK3TSiV7cD2j9PDanEh/gKXSvQesKfUN1nHJmCe9x9DSDOET2XqHmJLW8sl5R8iJ6KypAQi86/Li8VGyAdVKaJqBgI4CwDFrsch1ogAeCr7qw1hOsT+ViYlMEMSrhOxvvG2i9zOwy3+DQ5SCfoszam9XWfzmM9wfuyF0/b158MedKRX0XKGvOEBQIDei+HGf0+53bF0yoVP7Go8hgYx6Galoc2QWbnKlm7B1prYVy0iNK4t4RS8/5kh4/ji9XJPPRCOLOhXuHULfXpsynx1FwsPRKU3y/6FehY6U4RTnZezl63MsOrg5hvqQJZFZIz+r3Ex89x6H3YjeeK8YcpbCj9DMvF8xvDojEdeW+rx9BVNOBLZ7t4/abTIBv2e2JFT/PlzbJHMrnFSQWUXCskGjr5aAmCM9+kJ+eI7RO0XiMCDz/b3Or15HCD89uJkMuQ7yTJ4HdTSWSDir/kUQTQNVjKDdigUa0Ax6WKEdgUvahQYgTyxP0vRffWJZ54MEjnMFaVSww5DDhvHI3HFMgQbz6DtDeRovv3Y6ikk9MlXGQt+m89TWBaEGs7Z5xL4h8JQLRxNrdA1yCir+2v97YDBXDztMR+EYB6ugdQTXU9C09vD7JEBW3GNCZoFosbBkgUwRUC/+uP8GZzqUpvfQufAdPtCs
 9PojmgnJ
 8tloiorqZ9Og/DIMKa0IQA1LEZyqVnLmO7AiwRpSSkgWN6HD7kfeDfTNvuYaCLw8AhzrnOiFNz9T1efhtgs5KoM8YaliNaXbedkXARMHNBmfT2o+u8VRByjsyKZxodisytFMT1qTLllKc22TWYYJXGE8PQAkPevEYZ0t0sYJBZfLHq3MULZIuE91ojUARE5TJnXDeNiFXCbBBZOQZpBnbx7mCkSubnGF5gQOfK0B4o+VukZp6bfv8ur/WlondLOIs0QKevv2GWiAf63yLH9CWNxGMNChLGaaryNX+pdJDWIsLp9k8Xr42/cGR64NKsED7fqc3obDRUSWNcDYwG92Q0hpIM59L61OHS/yhlOXr/Wj5touSOOhT7FPFmF1GVlyyMHIAPpGMZiL9iBn/xoE2YmTwGd1eVB8auEk+jp79qXNUmDyaiM8wmWtiNJ/dIPwuOk86ginvbMFCWTyxGUI73UHBag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/23 03:51PM, Oliver Sang wrote:
> hi, Liam,
> 
> On Thu, May 21, 2026 at 11:45:05AM -0400, Liam R. Howlett wrote:
> > On 26/05/14 03:18PM, Oliver Sang wrote:
> > > hi, Liam,
> > > 
> > > On Wed, May 13, 2026 at 08:16:42PM -0400, Liam R. Howlett wrote:
> > > > On 26/05/13 03:40PM, kernel test robot wrote:
> > > > > 
> > > > > 
> > > > > Hello,
> > > > > 
> > > > > kernel test robot noticed a 6.0% regression of will-it-scale.per_process_ops on:
> > > > > 
> > > > > 
> > > > > commit: 280b792cac62ddadca2935766ca870b438c86323 ("maple_tree: use maple copy node for mas_wr_split()")
> > > > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > > > 
> > > > > [still regression on linus/master      5d6919055dec134de3c40167a490f33c74c12581]
> > > > > [still regression on linux-next/master e98d21c170b01ddef366f023bbfcf6b31509fa83]
> > > > > 
> > > > > testcase: will-it-scale
> > > > > config: x86_64-rhel-9.4
> > > > > compiler: gcc-14
> > > > > test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
> > > > > parameters:
> > > > > 
> > > > > 	nr_task: 100%
> > > > > 	mode: process
> > > > > 	test: mmap2
> > > > > 	cpufreq_governor: performance
> > > > > 
> > > > > 
> > > > 
> > > > Thank you for the report.
> > > > 
> > > > 48 threads on a 2 socket E5-2697 v2 looks to be 12 cores (24 threads)
> > > > per cpu (so x2), or exactly one mmap2 process per hyperthread.
> > > 
> > > this is the cpu information:
> > > 
> > > Architecture:        x86_64
> > > CPU op-mode(s):      32-bit, 64-bit
> > > Byte Order:          Little Endian
> > > Address sizes:       46 bits physical, 48 bits virtual
> > > CPU(s):              48
> > > On-line CPU(s) list: 0-47
> > > Thread(s) per core:  2
> > > Core(s) per socket:  12
> > > Socket(s):           2
> > > NUMA node(s):        2
> > > Vendor ID:           GenuineIntel
> > > CPU family:          6
> > > Model:               62
> > > Model name:          Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz
> > > Stepping:            4
> > > 
> > > > 
> > > > Is this across all process counts and peaks at 48, or just 48?
> > > 
> > > just 48. the run script is in
> > > https://download.01.org/0day-ci/archive/20260513/202605131554.92e7df6b-lkp@intel.com/repro-script
> > > 
> > > cd /lkp/benchmarks/will-it-scale
> > > python3 ./runtest.py mmap2 295 process 0 0 48
> > > 
> > > > Is this across many runs?
> > > 
> > > we run 6 times for both parent and this commit, the data looks stable
> > > 
> > > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json:  "will-it-scale.per_process_ops": [
> > > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143595,
> > > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143474,
> > > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    144104,
> > > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    142796,
> > > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143081,
> > > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143623
> > > 11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-  ],
> > > 
> > > 
> > > 280b792cac62ddadca2935766ca870b438c86323/matrix.json:  "will-it-scale.per_process_ops": [
> > > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    134451,
> > > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135089,
> > > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135080,
> > > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135039,
> > > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    134082,
> > > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135301
> > > 280b792cac62ddadca2935766ca870b438c86323/matrix.json-  ],
> > > 
> > > 
> > > > 
> > > > My testing didn't produce anything like this.  I'll have a look into
> > > > this when I can, but there isn't anything obvious that sticks out as a
> > > > likely cause.
> > > 
> > > if you want us to test any debug patch, it will be our great pleasure. thanks!
> > 
> > It looks like the result of the shape of the tree changing.  Can you try
> > the attached patch against Linus' tree?
> 
> I appled your patch upon below mainline tip commit when I checked.
> 6779b50faa562 ("Merge tag 'pci-v7.1-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci")
> 
> then build kernels with attached config.
> 
> but found a big regression introduced by your patch.
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
>   gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap2/will-it-scale
> 
> commit:
>   6779b50faa562 ("Merge tag 'pci-v7.1-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci")
>   942596e1c1037 ("maple_tree: Restore old tree layout using new scatter-gather node copy")
> 
> 6779b50faa562e6c 942596e1c1037f014638541bce4
> ---------------- ---------------------------
>          %stddev     %change         %stddev
>              \          |                \
>    7023559           -42.9%    4007886        will-it-scale.48.processes
>     146323           -42.9%      83497        will-it-scale.per_process_ops
>    7023559           -42.9%    4007886        will-it-scale.workload


How many runs did you do?  The same 6 runs with 48 processes on a 48
thread machine?  My results vary from this dramatically (+13% increase,
minus the 6% regression so 7% gain over what existed before).

> 
> 
> full comparison is as below [1]
> 
> however, it seems the performance regression is really recovered at commit
> 6779b50faa562, though the configs are not same.

I do not understand your statement here.

Are you saying that the current code isn't producing the regression
after 6779b50faa562?  Because 6779b50faa562 has nothing to do with my
code, so I don't understand why that affects the results at all.

> list the regression we reported
> for refererence.

Are you listing the regression in the applied patch for reference, or
was the initial report for reference?

This also means that I don't need to work on this now, right?  Because
there is no regression?  I'd like to clarify that before I spend more
time trying to fix this, especially since I saw nether of these
regressions in my testing - that is, I cannot reproduce your findings in
either code base.

> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
>   gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap2/will-it-scale
> 
> commit: 
>   11e7f22f5e ("maple_tree: add cp_converged() helper")
>   280b792cac ("maple_tree: use maple copy node for mas_wr_split()")
> 
> 11e7f22f5e85058b 280b792cac62ddadca2935766ca 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>    6885401            -6.0%    6472359        will-it-scale.48.processes
>     143445            -6.0%     134840        will-it-scale.per_process_ops
>    6885401            -6.0%    6472359        will-it-scale.workload
> 
> 
> 
> [1]
> =========================================================================================
> compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
>   gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap2/will-it-scale
> 
> commit:
>   6779b50faa562 ("Merge tag 'pci-v7.1-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci")
>   942596e1c1037 ("maple_tree: Restore old tree layout using new scatter-gather node copy")
> 
> 6779b50faa562e6c 942596e1c1037f014638541bce4
> ---------------- ---------------------------
>          %stddev     %change         %stddev
>              \          |                \
>    7023559           -42.9%    4007886        will-it-scale.48.processes
>     146323           -42.9%      83497        will-it-scale.per_process_ops
>    7023559           -42.9%    4007886        will-it-scale.workload
>       0.66           -12.7%       0.58        turbostat.IPC
>      18.34            +5.3%      19.31        turbostat.RAMWatt
>       0.42            +0.0        0.45        mpstat.cpu.all.irq%
>       2.66            +3.3        5.93        mpstat.cpu.all.soft%
>      14.68            -5.9        8.81        mpstat.cpu.all.usr%
>      14.62           -40.2%       8.75        vmstat.cpu.us
>    6222969           -10.4%    5575283        vmstat.memory.cache
>       7082           +38.9%       9835        vmstat.system.cs
>    2474044 ±  6%    +298.0%    9845581 ±  6%  numa-numastat.node0.local_node
>    2496926 ±  6%    +295.0%    9862610 ±  6%  numa-numastat.node0.numa_hit
>    2770972 ±  3%    +255.1%    9840248 ±  5%  numa-numastat.node1.local_node
>    2797815 ±  3%    +252.9%    9872775 ±  5%  numa-numastat.node1.numa_hit
>     224.50 ±  7%     +79.4%     402.75 ±  2%  perf-c2c.DRAM.local
>     130.88 ± 10%    +104.5%     267.62 ±  5%  perf-c2c.DRAM.remote
>     477.25 ±  8%    +306.6%       1940 ±  5%  perf-c2c.HITM.local
>      86.75 ± 17%    +190.5%     252.00 ±  5%  perf-c2c.HITM.remote
>       7083           +39.2%       9857        perf-stat.i.context-switches
>     243.71           -17.4%     201.31        perf-stat.i.cpu-migrations
>       7059           +39.2%       9824        perf-stat.ps.context-switches
>     242.83           -17.4%     200.61        perf-stat.ps.cpu-migrations
>    2432336 ±  3%     -30.0%    1703846 ± 12%  numa-meminfo.node1.Active
>    2432227 ±  3%     -30.0%    1703734 ± 12%  numa-meminfo.node1.Active(anon)
>     456558 ±  7%     -60.7%     179634 ± 20%  numa-meminfo.node1.Mapped
>       5874 ±  5%     -10.6%       5254 ±  6%  numa-meminfo.node1.PageTables
>     111108 ±  6%      +9.8%     121989 ±  6%  numa-meminfo.node1.SUnreclaim
>    2014977 ±  2%     -34.3%    1324406 ± 12%  numa-meminfo.node1.Shmem
>       0.26 ±  4%     -16.5%       0.22 ±  2%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>       0.26 ±  4%     -16.5%       0.22 ±  2%  perf-sched.total_sch_delay.average.ms
>      33.78 ±  5%     -41.3%      19.83 ±  2%  perf-sched.total_wait_and_delay.average.ms
>      25847 ±  5%     +73.3%      44801 ±  2%  perf-sched.total_wait_and_delay.count.ms
>      33.51 ±  5%     -41.5%      19.61 ±  2%  perf-sched.total_wait_time.average.ms
>      33.78 ±  5%     -41.3%      19.83 ±  2%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>      25847 ±  5%     +73.3%      44801 ±  2%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
>      33.51 ±  5%     -41.5%      19.61 ±  2%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>    2718564           -24.0%    2067012        meminfo.Active
>    2718343           -24.0%    2066792        meminfo.Active(anon)
>    6132342           -10.5%    5486698        meminfo.Cached
>     504163 ±  2%     -55.1%     226137 ±  2%  meminfo.Mapped
>    7551345            -8.6%    6901581        meminfo.Memused
>      11026            -5.9%      10375        meminfo.PageTables
>     232673           +11.1%     258411        meminfo.SUnreclaim
>    2036572           -31.7%    1390925        meminfo.Shmem
>     321293            +7.5%     345548        meminfo.Slab
>    7698968            -8.1%    7076107        meminfo.max_used_kB
>    2496631 ±  6%    +295.0%    9862492 ±  6%  numa-vmstat.node0.numa_hit
>    2473748 ±  6%    +298.0%    9845463 ±  6%  numa-vmstat.node0.numa_local
>     608040 ±  3%     -30.0%     425868 ± 12%  numa-vmstat.node1.nr_active_anon
>     113181 ±  7%     -60.5%      44658 ± 20%  numa-vmstat.node1.nr_mapped
>       1466 ±  5%     -10.5%       1313 ±  6%  numa-vmstat.node1.nr_page_table_pages
>     503740 ±  2%     -34.3%     331036 ± 12%  numa-vmstat.node1.nr_shmem
>      27840 ±  6%      +9.9%      30585 ±  6%  numa-vmstat.node1.nr_slab_unreclaimable
>     608040 ±  3%     -30.0%     425868 ± 12%  numa-vmstat.node1.nr_zone_active_anon
>    2797544 ±  3%    +252.9%    9872464 ±  5%  numa-vmstat.node1.numa_hit
>    2770701 ±  3%    +255.1%    9839937 ±  5%  numa-vmstat.node1.numa_local
>      98407 ±  8%     -16.6%      82034 ± 12%  sched_debug.cfs_rq:/.avg_vruntime.stddev
>     584720 ± 55%     +82.9%    1069238 ± 20%  sched_debug.cfs_rq:/.left_deadline.stddev
>     584716 ± 55%     +82.9%    1069230 ± 20%  sched_debug.cfs_rq:/.left_vruntime.stddev
>     584717 ± 55%     +82.9%    1069231 ± 20%  sched_debug.cfs_rq:/.right_vruntime.stddev
>      98406 ±  8%     -16.6%      82034 ± 12%  sched_debug.cfs_rq:/.zero_vruntime.stddev
>       3696 ± 22%     -53.0%       1736 ± 28%  sched_debug.cpu.curr->pid.min
>       1080 ±  8%     +22.1%       1320 ±  7%  sched_debug.cpu.curr->pid.stddev
>      24404           +36.7%      33355        sched_debug.cpu.nr_switches.avg
>      35594 ±  5%     +26.6%      45073 ±  6%  sched_debug.cpu.nr_switches.max
>      19226           +47.9%      28429        sched_debug.cpu.nr_switches.min
>     679722           -24.0%     516709        proc-vmstat.nr_active_anon
>    1446664            +1.1%    1462897        proc-vmstat.nr_dirty_background_threshold
>    2896867            +1.1%    2929372        proc-vmstat.nr_dirty_threshold
>    1533216           -10.5%    1371700        proc-vmstat.nr_file_pages
>   14575614            +1.1%   14738179        proc-vmstat.nr_free_pages
>     126756 ±  2%     -55.4%      56505 ±  2%  proc-vmstat.nr_mapped
>       2757            -6.0%       2592        proc-vmstat.nr_page_table_pages
>     509273           -31.7%     347755        proc-vmstat.nr_shmem
>      22155            -1.7%      21783        proc-vmstat.nr_slab_reclaimable
>      58291           +10.7%      64524        proc-vmstat.nr_slab_unreclaimable
>     679722           -24.0%     516709        proc-vmstat.nr_zone_active_anon
>    5296571          +272.6%   19736811        proc-vmstat.numa_hit
>    5246846          +275.2%   19687252        proc-vmstat.numa_local
>    9465911          +307.2%   38547209        proc-vmstat.pgalloc_normal
>    8803386 ±  2%    +332.6%   38087100        proc-vmstat.pgfree
>      19.27            -5.7       13.54        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
>      15.16            -5.1       10.07        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>      54.50            -4.2       50.33        perf-profile.calltrace.cycles-pp.__mmap
>       8.54            -2.9        5.66        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
>       8.04            -2.8        5.22        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
>       9.39            -2.6        6.83        perf-profile.calltrace.cycles-pp.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       6.62            -2.5        4.12        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
>       8.69            -2.3        6.34        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff
>       8.36            -2.3        6.10        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap
>       5.66            -1.9        3.72        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
>       3.90            -1.7        2.20        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.__mmap
>       3.76            -1.6        2.13        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.__munmap
>       2.99 ±  3%      -1.6        1.39        perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
>       3.68            -1.3        2.39        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
>       3.38            -1.2        2.18        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
>       2.86            -1.0        1.81        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
>       6.25            -1.0        5.24        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
>       5.95            -1.0        4.95        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       2.77 ±  2%      -0.9        1.85 ±  2%  perf-profile.calltrace.cycles-pp.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
>       2.41            -0.8        1.65        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region
>       1.53            -0.7        0.85        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.__munmap
>       1.50            -0.6        0.85        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.__mmap
>       4.86            -0.6        4.23        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
>       1.67 ±  4%      -0.6        1.05 ±  4%  perf-profile.calltrace.cycles-pp.prepend_path.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_complete
>       1.37            -0.6        0.75        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
>       1.36            -0.6        0.76        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
>       1.78            -0.6        1.22        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
>       1.69            -0.6        1.13        perf-profile.calltrace.cycles-pp.shmem_mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       4.11            -0.5        3.60        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
>       1.23            -0.5        0.72        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
>       1.38            -0.5        0.89        perf-profile.calltrace.cycles-pp.touch_atime.shmem_mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff
>       1.37            -0.5        0.89        perf-profile.calltrace.cycles-pp.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
>       3.96            -0.5        3.49        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
>       1.46            -0.5        1.01        perf-profile.calltrace.cycles-pp.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       1.10            -0.4        0.67        perf-profile.calltrace.cycles-pp.security_vm_enough_memory_mm.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       1.11            -0.4        0.73        perf-profile.calltrace.cycles-pp.unlink_file_vma_batch_process.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
>       0.97            -0.4        0.60        perf-profile.calltrace.cycles-pp.atime_needs_update.touch_atime.shmem_mmap_prepare.__mmap_region.do_mmap
>       0.95            -0.4        0.58        perf-profile.calltrace.cycles-pp.vma_merge_new_range.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       2.41            -0.3        2.07        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
>       1.71            -0.3        1.40        perf-profile.calltrace.cycles-pp.__build_id_parse.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
>       0.80            -0.3        0.55        perf-profile.calltrace.cycles-pp.pte_offset_map_lock.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas
>       1.20            -0.2        1.00        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       0.81            -0.2        0.63        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
>       1.97            -0.2        1.79        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
>       0.76            -0.2        0.60        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff
>       1.15            -0.1        1.01        perf-profile.calltrace.cycles-pp.freader_fetch.__build_id_parse.perf_event_mmap_event.perf_event_mmap.__mmap_complete
>       1.48            -0.1        1.36        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
>       0.90            -0.1        0.78        perf-profile.calltrace.cycles-pp.freader_get_folio.freader_fetch.__build_id_parse.perf_event_mmap_event.perf_event_mmap
>       0.77            -0.1        0.66        perf-profile.calltrace.cycles-pp.khugepaged_enter_vma.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
>       1.93 ±  2%      -0.1        1.82        perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       2.20            -0.1        2.11        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
>       0.66            -0.1        0.58 ±  2%  perf-profile.calltrace.cycles-pp.__filemap_get_folio_mpol.freader_get_folio.freader_fetch.__build_id_parse.perf_event_mmap_event
>       1.17 ±  3%      -0.1        1.10        perf-profile.calltrace.cycles-pp.perf_session__process_events.record__finish_output.cmd_record
>       1.17 ±  3%      -0.1        1.10        perf-profile.calltrace.cycles-pp.cmd_record
>       1.17 ±  3%      -0.1        1.10        perf-profile.calltrace.cycles-pp.record__finish_output.cmd_record
>       5.13            +0.1        5.20        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
>      44.84            +0.2       45.05        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
>       0.70            +0.4        1.07        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       0.20 ±129%      +0.4        0.60 ±  2%  perf-profile.calltrace.cycles-pp.ordered_events__deliver_event.__ordered_events__flush.perf_session__process_user_event.perf_session__process_events.record__finish_output
>       0.22 ±129%      +0.4        0.64 ±  2%  perf-profile.calltrace.cycles-pp.__ordered_events__flush.perf_session__process_user_event.perf_session__process_events.record__finish_output.cmd_record
>       0.22 ±129%      +0.4        0.64 ±  2%  perf-profile.calltrace.cycles-pp.perf_session__process_user_event.perf_session__process_events.record__finish_output.cmd_record
>       0.13 ±173%      +0.5        0.59 ±  2%  perf-profile.calltrace.cycles-pp.perf_session__deliver_event.ordered_events__deliver_event.__ordered_events__flush.perf_session__process_user_event.perf_session__process_events
>      43.80            +0.5       44.30        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
>       0.00            +0.5        0.52 ±  2%  perf-profile.calltrace.cycles-pp.node_finalise.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
>       0.00            +0.6        0.56        perf-profile.calltrace.cycles-pp.memcpy_orig.node_copy.cp_data_write.mas_wr_spanning_store.mas_store_gfp
>       0.00            +0.6        0.58        perf-profile.calltrace.cycles-pp.memcpy_orig.node_copy.cp_data_write.mas_wr_split.mas_store_prealloc
>       0.89            +0.6        1.47        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       0.00            +0.7        0.66        perf-profile.calltrace.cycles-pp.mas_next_node.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap
>       0.65            +0.7        1.31        perf-profile.calltrace.cycles-pp.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
>       0.00            +0.7        0.67 ±  2%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_topiary_replace.mas_wr_spanning_store.mas_store_gfp
>       0.00            +0.8        0.78        perf-profile.calltrace.cycles-pp.node_finalise.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region
>       0.00            +0.8        0.82 ±  2%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
>      42.40            +1.0       43.37        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
>       0.00            +1.0        1.00 ±  2%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_topiary_replace.mas_wr_split.mas_store_prealloc.__mmap_new_vma
>       0.00            +1.3        1.25        perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_topiary_replace.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap
>      41.16            +1.3       42.42        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       0.00            +1.3        1.26 ±  2%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
>       0.00            +1.3        1.31        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__prefill_sheaf_pfmemalloc
>       0.00            +1.4        1.40        perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
>       0.00            +1.4        1.44        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__prefill_sheaf_pfmemalloc.kmem_cache_prefill_sheaf
>       0.00            +1.5        1.45 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
>       0.00            +1.5        1.46 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
>       0.00            +1.5        1.47        perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
>       0.00            +1.5        1.47        perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
>      45.00            +1.5       46.50        perf-profile.calltrace.cycles-pp.__munmap
>       0.00            +1.5        1.50 ±  2%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
>       0.00            +1.7        1.73        perf-profile.calltrace.cycles-pp.node_copy.cp_data_write.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap
>       0.00            +1.7        1.73        perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
>       0.00            +1.7        1.73        perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
>       0.00            +1.7        1.73        perf-profile.calltrace.cycles-pp.ret_from_fork_asm
>       0.00            +1.8        1.82        perf-profile.calltrace.cycles-pp.node_copy.cp_data_write.mas_wr_split.mas_store_prealloc.__mmap_new_vma
>       0.00            +2.0        1.95        perf-profile.calltrace.cycles-pp.dst_setup.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
>      33.18            +2.6       35.81        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
>       0.00            +2.9        2.88        perf-profile.calltrace.cycles-pp.cp_data_write.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
>       0.00            +3.0        3.03        perf-profile.calltrace.cycles-pp.dst_setup.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region
>       0.00            +3.3        3.31        perf-profile.calltrace.cycles-pp.mas_topiary_replace.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region
>       0.00            +3.6        3.59        perf-profile.calltrace.cycles-pp.mas_topiary_replace.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
>       0.00            +3.9        3.87        perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__prefill_sheaf_pfmemalloc.kmem_cache_prefill_sheaf.mas_store_gfp
>       0.00            +3.9        3.91        perf-profile.calltrace.cycles-pp.cp_data_write.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region
>       0.00            +4.6        4.64        perf-profile.calltrace.cycles-pp.refill_objects.__prefill_sheaf_pfmemalloc.kmem_cache_prefill_sheaf.mas_store_gfp.do_vmi_align_munmap
>       0.00            +4.7        4.71        perf-profile.calltrace.cycles-pp.__prefill_sheaf_pfmemalloc.kmem_cache_prefill_sheaf.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
>       0.00            +5.1        5.10        perf-profile.calltrace.cycles-pp.kmem_cache_prefill_sheaf.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>      36.19            +5.6       41.79        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
>      36.00            +5.7       41.69        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
>      35.15            +6.0       41.13        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
>      35.01            +6.0       41.03        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
>      34.08            +6.3       40.39        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      32.43            +6.8       39.26        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
>      12.68            +8.9       21.54        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       4.77           +11.2       16.00        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
>       7.25           +12.6       19.89        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
>       0.00           +13.7       13.69        perf-profile.calltrace.cycles-pp.mas_wr_spanning_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       0.00           +14.8       14.81        perf-profile.calltrace.cycles-pp.mas_wr_split.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
>       8.17            -8.2        0.00        perf-profile.children.cycles-pp.mas_wr_node_store

It looks like the slow path is taken 100% of the time in your run, for
all processes, always.

I understand why that is happening and I can work to avoid it (nudging
the write deeper into a split node), but I'd like clarification of my
questions above before I keep going here.

...

Thanks,
Liam

