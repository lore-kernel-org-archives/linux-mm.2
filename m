Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEBFECD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36FBF6B00D1; Mon, 11 May 2026 14:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321366B00D3; Mon, 11 May 2026 14:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236826B00D4; Mon, 11 May 2026 14:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 137906B00D1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:51:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 886CE140276
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:51:23 +0000 (UTC)
X-FDA: 84756032046.04.5B09C51
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 06E0AC0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:51:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M8MWcBa4;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778525481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJpqTLCSY6a8IiyYKlv3L/IX5Pb3aauwa2emRO+XwqY=;
	b=O6bRIarlx22SBpHYThrp6VJAweNKaCSpVn6n/cWt/bR45OXCLpqFd+cUFgYkmykM3c1AAt
	N8ZT8+1fb94enLuHTEmR4iCTv2jzQsjCVhj7OHvEtYe1ktbFTUVC7qLhxrNlR/eq/uzfHS
	nMmpLFsga2IF61QLCoF5y/x32A8/jTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778525481; a=rsa-sha256;
	cv=none;
	b=bOuDIm0YTHKo1cVheeXrOLqb8j0H2L/yqpbxb2uq3R8x0CogTF+dWsk3GfOniovDkN1eKU
	vQ+iKcePjzV7XQP6NIcfJruaFw+NzF1M+OSllMhGcs/CeZfbSfoJov3XGDUeXR1BtSss6Y
	aT9oJdxayK1qp5vnLuUS0Kd7bTW09RM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M8MWcBa4;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 11 May 2026 11:51:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778525476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TJpqTLCSY6a8IiyYKlv3L/IX5Pb3aauwa2emRO+XwqY=;
	b=M8MWcBa4cMnaUJEQFl0IHKgVy+h94nxrvroIu1XzXrSTCDBBMUq32rUR++/rM20zhB9BF3
	v3oUqDra2atT8Sur9BggufiGZRsRAI0WxXM3OD9DcCvfirTWGk5+2QSCxBFiv3b5Zgam04
	e11TI/0enEn1vOpDILS26xVvXwT+HLs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <ryncsn@gmail.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 00/15] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-ID: <agH7qYcyFgRzkQDB@linux.dev>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 06E0AC0005
X-Rspam-User: 
X-Stat-Signature: eun3hupchfaty4a97ny8s1qk57n1dwpu
X-HE-Tag: 1778525479-677690
X-HE-Meta: U2FsdGVkX19FbIXgpEC8f0Fm89Oy2ExshuYCTSwwmhkXvo338HJWh3k3A3YHTd/QRRtRsHaLSGe6vr9KaujGv1wIKYE7/DlTW1l1xn9Zggc9xmaq5hSuGep77yWN7L4mOzEUyDClFusrfp/vp+vlfmjuu6vDnXRVEbp5lRbCP5RAG6EirLpPI2mgZsfSqbuNrnOoykJISwv8UKJn7oLQqxqAmhojDn65ccycaKVVlPpAI+yIVZjdyeviGLiTLBqvdx6Myz9stHwBw0GvX+TrXiuGuP+m51PBxJTIm2xbKvmTqP4ehHxuO/wuctY8Ab83delF6SXSpHO7LN5yFLzPXMYaLyeoqC87RJ9lqZMzcO3pNIT0PgT2fGAloX8bT403L3o/OwsmWinHGM+IwNyfoSIEvHO5ebmWTMBtrxXb0dGXwyImELsiNmyyKg7bTr9bBNMvlq+vl4HZ5coz1L7ZZBqZa/SdIh0GgAJGOymrsd6M520lUZZ4EXK5LHgzgSwp88yOupCDwvlnVvOZ3XGAz5Qe9pt2WVSM+Lvz9oVb1yFoa7j9Pu5QSJiPMtiRnLCb9x5jtB1XF+tc/z1CEKHF5gJ9rWltjrcn3BJ+CbG6BMrhO2izzrspc0q4nly/wNcsFBm6C/BaE1B4VHYbBtmf9GGmw0obIlHSZs3j2ldd6tiuaVauzuyX0jhgUselLQdAnTTay1KKQxg/ZpyTs+tV6b3Kt85ie/5AIgAn7wBwMnK4XruTiu6O+3SFkR98rXyrMTKKmZqT8ngMa8Ln1JGwyNKRr6cPSCnubgOGnaG+Oudoew3OPV9nbvd1PLM4TBLlQqSK+IM3g2ee7YIPsNKG51VneWGlD45jXl6Caq0gFwp5S3kObhNh06o1uT+tMsy6pkdOovSm8yNRU1jsIu9qUdMj9h8/65FoIRXB2hUVQ9Vk5pCMvVw6qQmdr7lwZFrJSF/98Vl90sapIDnL8ID
 TuhAkWt5
 nba/HCfcE1luSppNHxar3I5mu4QVhpmlXOp8Y4Wn6RZmWw/MP2Pv/HwfJ8ZEV72CPuMSxuujHsgwXjG3SlLKPErEJd0VXe9wZAOqK3XQ0qk6VyAZ5QrobB+8UdoUV4CpRqqBTI3aDit5fj3m6c1rD+ON+lpxKXQ8hb+ga72fIx9+LALDmoQPdWrRYxEnPClD+FO+w95Coa96CTCERysGTyi1jCIzdwhIZSlbZJl3BevpvElTY0Rku52gPXY+qCSBeYb2tHw/ajy8GOHjyj7QVcW1Qo+mPmwqOeWyZCJw+/qR7UlauRWvh0RH76w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Kairui,

On Tue, Apr 28, 2026 at 02:06:51AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> This series cleans up and slightly improves MGLRU's reclaim loop and
> dirty writeback handling. As a result, we can see an up to ~30% increase
> in some workloads like MongoDB with YCSB and a huge decrease in file
> refault, no swap involved. Other common benchmarks have no regression,
> and LOC is reduced, with less unexpected OOM, too.
> 
> Some of the problems were found in our production environment, and
> others were mostly exposed while stress testing during the development
> of the LSM/MM/BPF topic on improving MGLRU [1]. This series cleans up
> the code base and fixes several performance issues, preparing for
> further work.
> 
> MGLRU's reclaim loop is a bit complex, and hence these problems are
> somehow related to each other. The aging, scan number calculation, and
> reclaim loop are coupled together, and the dirty folio handling logic is
> quite different, making the reclaim loop hard to follow and the dirty
> flush ineffective.
> 
> This series slightly cleans up and improves these issues using a scan
> budget by calculating the number of folios to scan at the beginning of
> the loop, and decouples aging from the reclaim calculation helpers.
> Then, move the dirty flush logic inside the reclaim loop so it can kick
> in more effectively. These issues are somehow related, and this series
> handles them and improves MGLRU reclaim in many ways.
> 
> Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
> and a 128G memory machine using NVME as storage.

Please include traditional LRU results for all of the following experiments as
well (where it makes sense).

> 
> MongoDB
> =======
> Running YCSB workloadb [2] (recordcount:20000000 operationcount:6000000,
> threads:32), which does 95% read and 5% update to generate mixed read
> and dirty writeback. MongoDB is set up in a 10G cgroup using Docker, and
> the WiredTiger cache size is set to 4.5G, using NVME as storage.

Can you add a sentence here on why this workload is chosen and is important for
evaluation?

> 
> Not using SWAP.

Any specific reason to not have swap in this test?

> 
> Before:
> Throughput(ops/sec): 62485.02962831822
> AverageLatency(us): 500.9746963330107
> pgpgin 159347462
> pgpgout 5413332
> workingset_refault_anon 0
> workingset_refault_file 34522071
> 
> After:
> Throughput(ops/sec): 79760.71784646061 (+27.6%, higher is better)
> AverageLatency(us): 391.25169970043726 (-21.9%, lower is better)
> pgpgin 111093923                       (-30.3%, lower is better)
> pgpgout 5437456
> workingset_refault_anon 0
> workingset_refault_file 19566366       (-43.3%, lower is better)
> 
> We can see a significant performance improvement after this series.
> The test is done on NVME and the performance gap would be even larger
> for slow devices, such as HDD or network storage. We observed over
> 100% gain for some workloads with slow IO.
> 
> Chrome & Node.js [3]
> ====================
> Using Yu Zhao's test script [3], testing on a x86_64 NUMA machine with 2
> nodes and 128G memory, using 256G ZRAM as swap and spawn 32 memcg 64
> workers:
> 
> Before:
> Total requests:            79915
> Per-worker 95% CI (mean):  [1233.9, 1263.5]
> Per-worker stdev:          59.2
> Jain's fairness:           0.997795 (1.0 = perfectly fair)
> Latency:
> Bucket     Count      Pct    Cumul
> [0,1)s     26859   33.61%   33.61%
> [1,2)s      7818    9.78%   43.39%
> [2,4)s      5532    6.92%   50.31%
> [4,8)s     39706   49.69%  100.00%
> 
> After:
> Total requests:            81382
> Per-worker 95% CI (mean):  [1241.9, 1301.3]
> Per-worker stdev:          118.8
> Jain's fairness:           0.991480 (1.0 = perfectly fair)
> Latency:
> Bucket     Count      Pct    Cumul
> [0,1)s     26696   32.80%   32.80%
> [1,2)s      8745   10.75%   43.55%
> [2,4)s      6865    8.44%   51.98%
> [4,8)s     39076   48.02%  100.00%
> 
> Reclaim is still fair and effective, total requests number seems
> slightly better.

Please add a reference to Jain's fairness and a sentence on why we should care
about it.

> 
> OOM issue with aging and throttling
> ===================================
> For the throttling OOM issue, it can be easily reproduced using dd and
> cgroup limit as demonstrated and fixed by a later patch in this series.
> 
> The aging OOM is a bit tricky, a specific reproducer can be used to
> simulate what we encountered in production environment [4]:
> Spawns multiple workers that keep reading the given file using mmap,
> and pauses for 120ms after one file read batch. It also spawns another
> set of workers that keep allocating and freeing a given size of
> anonymous memory. The total memory size exceeds the memory limit
> (eg. 14G anon + 8G file, which is 22G vs a 16G memcg limit).
> 
> - MGLRU disabled:
>   Finished 128 iterations.
> 
> - MGLRU enabled:
>   OOM with following info after about ~10-20 iterations:
>     [   62.624130] file_anon_mix_p invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
>     [   62.624999] memory: usage 16777216kB, limit 16777216kB, failcnt 24460
>     [   62.640200] swap: usage 0kB, limit 9007199254740988kB, failcnt 0
>     [   62.640823] Memory cgroup stats for /demo:
>     [   62.641017] anon 10604879872
>     [   62.641941] file 6574858240
> 
>   OOM occurs despite there being still evictable file folios.
> 
> - MGLRU enabled after this series:
>   Finished 128 iterations.
> 
> Worth noting there is another OOM related issue reported in V1 of
> this series, which is tested and looking OK now [5].

Oh this is good as it seems like you are already running traditional LRU.

> 
> MySQL:
> ======
> 
> Testing with innodb_buffer_pool_size=26106127360, in a 2G memcg, using
> ZRAM as swap and test command:
> 
> sysbench /usr/share/sysbench/oltp_read_only.lua --mysql-db=sb \
>   --tables=48 --table-size=2000000 --threads=48 --time=600 run
> 
> Before:            17303.41 tps
> After this series: 17291.50 tps
> 
> Seems only noise level changes, no regression.
> 

Please add a sentence on why this specific params.

> FIO:
> ====
> Testing with the following command, where /mnt/ramdisk is a
> 64G EXT4 ramdisk, each test file is 3G, in a 10G memcg,
> 6 test run each:
> 
> fio --directory=/mnt/ramdisk --filename_format='test.$jobnum.img' \
>   --name=cached --numjobs=16 --size=3072M --buffered=1 --ioengine=mmap \
>   --rw=randread --norandommap --time_based \
>   --ramp_time=1m --runtime=5m --group_reporting
> 
> Before:            8968.76 MB/s
> After this series: 8995.63 MB/s
> 
> Also seem only noise level changes and no regression or slightly better.

Same here.

> 
> Build kernel:
> =============
> Build kernel test using ZRAM as swap, on top of tmpfs, in a 3G memcg
> using make -j96 and defconfig, measuring system time, 12 test run each.
> 
> Before:            2873.52s
> After this series: 2811.88s
> 
> Also seem only noise level changes, no regression or very slightly better.

So, the kernel source code is on tmpfs, right? Also 3G memcg means memory.max is
3G, correct?

> 
> Android:
> ========
> Xinyu reported a performance gain on Android, too, with this series. The
> test consisted of cold-starting multiple applications sequentially under
> moderate system load. [6]
> 
> Before:
> Launch Time Summary (all apps, all runs)
>   Mean 868.0ms
>   P50 888.0ms
>   P90 1274.2ms
>   P95 1399.0ms
> 
> After:
> Launch Time Summary (all apps, all runs)
>   Mean 850.5ms (-2.07%)
>   P50 861.5ms  (-3.04%)
>   P90 1179.0ms (-8.05%)
>   P95 1228.0ms (-12.2%)

It would be awesome if Xinyu can gather traditional LRU numbers but if not then
it is fine.


