Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BC5AFEA806
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 04:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5404F6B0005; Wed, 25 Mar 2026 00:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1936B0089; Wed, 25 Mar 2026 00:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DFB86B008A; Wed, 25 Mar 2026 00:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2990D6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:50:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 499E713B91F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:50:05 +0000 (UTC)
X-FDA: 84583358370.27.415ABB9
Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
	by imf02.hostedemail.com (Postfix) with ESMTP id 54EFA80004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:50:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cachyos.org header.s=dkim header.b=eJ5t2YyC;
	spf=pass (imf02.hostedemail.com: domain of dnaim@cachyos.org designates 202.61.224.105 as permitted sender) smtp.mailfrom=dnaim@cachyos.org;
	dmarc=pass (policy=quarantine) header.from=cachyos.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774414203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6CpHWVxYNZYdO+SdOyWY6UD9PFu4+HfovQM9VH5QOU=;
	b=3ZxTHU6sgjZ+dDoXzJcLT5wrLxOjsYbJgou7Rq2kBSrHl0Opv+PuswHVVWPbHjRZoZmHKW
	pHo0fVh1eaJGau8+6/RVgRGHggoe4+84mPUhtXIBLcwfMdEUePJn681D/PnZnxodaBO4eN
	1emtP5Emef4Z9AUcUOwOeimCjLQtaFo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cachyos.org header.s=dkim header.b=eJ5t2YyC;
	spf=pass (imf02.hostedemail.com: domain of dnaim@cachyos.org designates 202.61.224.105 as permitted sender) smtp.mailfrom=dnaim@cachyos.org;
	dmarc=pass (policy=quarantine) header.from=cachyos.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774414203; a=rsa-sha256;
	cv=none;
	b=G0pZYf4DtT94Qgh/nhtAvAVnwCwjrrH/wvLEDAHXzMYUHYfvyB3aONrHUQxjnH/VvJYMZ8
	Y36/hzi7RYPpKlpofl6CG2WV5md6uIk2aLFebiSyj4zs6ecbFvgmFIT/El1debI5z8zGix
	tKvGxGMxIP87zdp5MITuSw7VEkhW4Eo=
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 23A25285ED2;
	Wed, 25 Mar 2026 05:49:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
	t=1774414201; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=j6CpHWVxYNZYdO+SdOyWY6UD9PFu4+HfovQM9VH5QOU=;
	b=eJ5t2YyCL2ExllCslNHW/V/erNF9BEkohnit2jVngDyw6INE+cgBn+OlLIGXqWHUkZ6GbM
	jbMrzNy5q9I7tTPaf2L25W9f5ZDhP8Z7WSOcHQPPULqfSzoJQDwRm7lolbkcK0lUr3/P4s
	pwDRwb2iEvy58aiRZc8LdKQ6S/TSVkU5hJ0Cf7i1SMn+Ve1lQ4iongsGHuKmBVOlXFpKoh
	mJR9ZPmbZZ7F+mjPHmtaaK6E3flnx+kGO1ydjZ1eDFuwJG0CnWGeQvu4nziNqhgZ7kw1Bh
	QkeY0+Hx/tQkxPPSsiQ7FxCO+mpdaSsvAYEl+fpMKsudPF7iIzV3yMLK6eL8BQ==
Message-ID: <7ab8edd7-381f-4db2-9560-b58718669208@cachyos.org>
Date: Wed, 25 Mar 2026 04:49:00 +0000
MIME-Version: 1.0
Subject: Re: [PATCH 0/8] mm/mglru: improve reclaim loop and dirty folio
 handling
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
From: Eric Naim <dnaim@cachyos.org>
In-Reply-To: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54EFA80004
X-Stat-Signature: c1dnd75htb61ks8roh6yghmf36bn783q
X-Rspam-User: 
X-HE-Tag: 1774414203-368161
X-HE-Meta: U2FsdGVkX1+mIhxxfeYAYEmZhm+k3m6QLYVCibyGPbzbtDySYThPsR4Um2V7ah42mwVl9oyG45s/uu5TBVhuo0i1RDimMp5/W5GfX2uUGrMn67aQHJaUsEt0qi5vVHgwixTV91eNSAIyOK9cwa7VATKcw3K25KKtbaa1MzSkhmZJLxEaai88Z9RXnVvXf9aOSK0z20HzJqn3AZl98FF/F1dSe5k4yqV6uVKCXf58mSRDcYTQyAZ3al4wupKCBwiihkGwRUlSoNnZgw/6fymgevb0KIajpvogMQM+O+YtQM5MpjKHwTjcAV/2Q3f34JgFChjBfeNq3eIgx9oab+6sHySLSiRRiPc80QbPLUOzCU+46mOw9M+rpHaHAxEH1hByO0CPwuFv/8fRbAYAueOFiEEM3nwsiOKOsRqKCY2ByQp+1n3N6gV1zA8XmWpRw1Y3kvw5k97eqaHu0K3C9YBLuojMJc80eJ7VwEzAGSGhMBavtf/rg1bYVcm/UKk6gtCZ2FxJGj/O+u5wTl71qM343lVqyZLnKuV9TI/jdU6ibh9kYr2oUNTMe0hkvlTUwvI5/s+mmuxya+rurLA4BJJ/Qgvi+d1HaPxOPZKRq69cbVgyJLsJi7Zp1rH8LY8LCYYlVms4wK7EM+fE1elR53wc+yzhyaGAhwtzt1yVTEz1WHR9tZazfcVwAnWtH2WE/JI3Uz6UVEO5SfB6vdCHaY4mWManeXf+MIXmU4gUuGxrMu0hXhvpnSI8JLIujpTb1KkfrUlh253Qh1b70SCwHtxfeAVWKufvbJWGtIK2PTBiOBeHllq8Fq3um7WmzdH+WOJ508J81mzlT2DIGNRxL3gHWsEzLBnLvyJwkjxR8bPygGsPFLbYiS1X4VymBGWX3FJTpFRvo9GE6utEcxgpN6WomGS1W0A86pJ0uzym4VQLUlKEHSTOHbbpWRPiwUW0Ai2LkkXF3rZuofWSNVQCL5s
 nUZZCTwm
 s3DLbIs86MU0n3OnicQjgXDKM0YQhZ3y8Zg44VDJzHIR1NXogkOMpj0g3qng3ZV0mc+sIbZzxl47E6wwjBbPourefRuW1boqTBeDSw0aRN54wXbqeBZcPPWnVr/WIKVhf+/YlbiFHIyUN7wLceVeaveEfe4BEqZH/cagfPyNFKloczu4DHGpOXpMlJLgvE8pwhmVECFJXn8srJEPGnmlINHSvak0qKYKt70+kgPKugIUW80k+4Q+1B+ssuQexL5hMlde5c3n+jehJ/NHWIRYPTNEGtzEAVBvbyXeRe/tSog9XsgoTo/IDy8Xh8o1fQzuaDlr6OErF/f4pAOj6+zv0ZXPaMO/bpH+MmD6p8DCHAdo26K3mGlQHTyVJmrukZtZQ5ImDI7s2Gfz0d11oByKuEB9rqKujpj8fnkjlSjGYoKQhCSnuiZ4b1ekMk7aF3GyWsxYt4c9xmB5ucXkS5hB+5gGwPENDtVRHDKyF4zZ4Zafa1fQ6ap8hQHF+N820Qh79o2JV17pNhQY7VxN1C/epTEvSbHJ8gfedoWZJW+IpmMydu+7sTQMdtpHpNTNBM6w3ZtKD0fuC59FYIv0p1MtZUeiuMDF0kTVhIvF6eu7i8kWI/tP6YQILIH7m4NLXFfq0xjxQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

On 3/18/26 3:08 AM, Kairui Song via B4 Relay wrote:
> This series cleans up and slightly improves MGLRU's reclaim loop and
> dirty flush logic. As a result, we can see an up to ~50% reduce of file
> faults and 30% increase in MongoDB throughput with YCSB and no swap
> involved, other common benchmarks have no regression, and LOC is
> reduced, with less unexpected OOM in our production environment.
> 
> Some of the problems were found in our production environment, and
> others are mostly exposed while stress testing the LFU-like design as
> proposed in the LSM/MM/BPF topic this year [1]. This series has no
> direct relationship to that topic, but it cleans up the code base and
> fixes several strange behaviors that make the test result of the
> LFU-like design not as good as expected.
> 
> MGLRU's reclaim loop is a bit complex, and hence these problems are
> somehow related to each other. The aging, scan number calculation, and
> reclaim loop are coupled together, and the dirty folio handling logic is
> quite different, making the reclaim loop hard to follow and the dirty
> flush ineffective too.
> 
> This series slightly cleans up and improves the reclaim loop using a
> scan budget by calculating the number of folios to scan at the beginning
> of the loop, and decouples aging from the reclaim calculation helpers
> Then move the dirty flush logic inside the reclaim loop so it can kick
> in more effectively. These issues are somehow related, and this series
> handles them and improves MGLRU reclaim in many ways.
> 
> Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
> and 128G memory machine using NVME as storage.
> 
> MongoDB
> =======
> Running YCSB workloadb [2] (recordcount:20000000 operationcount:6000000,
> threads:32), which does 95% read and 5% update to generate mixed read
> and dirty writeback. MongoDB is set up in a 10G cgroup using Docker, and
> the WiredTiger cache size is set to 4.5G, using NVME as storage.
> 
> Not using SWAP.
> 
> Median of 3 test run, results are stable.
> 
> Before:
> Throughput(ops/sec): 61642.78008938203
> AverageLatency(us):  507.11127774145166
> pgpgin 158190589
> pgpgout 5880616
> workingset_refault 7262988
> 
> After:
> Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
> AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
> pgpgin 101871227                        (-35.6%, lower is better)
> pgpgout 5770028
> workingset_refault 3418186              (-52.9%, lower is better)
> 
> We can see a significant performance improvement after this series for
> file cache heavy workloads like this. The test is done on NVME and the
> performance gap would be even larger for slow devices, we observed
>> 100% gain for some other workloads running on HDD devices.
> 
> Chrome & Node.js [3]
> ====================
> Using Yu Zhao's test script [3], testing on a x86_64 NUMA machine with 2
> nodes and 128G memory, using 256G ZRAM as swap and spawn 32 memcg 64
> workers:
> 
> Before:
> Total requests:            77920
> Per-worker 95% CI (mean):  [1199.9, 1235.1]
> Per-worker stdev:          70.5
> Jain's fairness:           0.996706 (1.0 = perfectly fair)
> Latency:
> Bucket     Count      Pct    Cumul
> [0,1)s     25649   32.92%   32.92%
> [1,2)s      7759    9.96%   42.87%
> [2,4)s      5156    6.62%   49.49%
> [4,8)s     39356   50.51%  100.00%
> 
> After:
> Total requests:            79564
> Per-worker 95% CI (mean):  [1224.2, 1262.2]
> Per-worker stdev:          76.1
> Jain's fairness:           0.996328 (1.0 = perfectly fair)
> Latency:
> Bucket     Count      Pct    Cumul
> [0,1)s     25485   32.03%   32.03%
> [1,2)s      8661   10.89%   42.92%
> [2,4)s      6268    7.88%   50.79%
> [4,8)s     39150   49.21%  100.00%
> 
> Seems identical, reclaim is still fair and effective, total requests
> number seems slightly better.
> 
> OOM issue [4]
> =============
> Testing with a specific reproducer [4] to simulate what we encounterd in
> production environment. Still using the same test machine but one node
> is used as pmem ramdisk following steps in the reproducer, no SWAP used.
> 
> This reproducer spawns multiple workers that keep reading the given file
> using mmap, and pauses for 120ms after one file read batch. It also
> spawns another set of workers that keep allocating and freeing a
> given size of anonymous memory. The total memory size exceeds the
> memory limit (eg. 44G anon + 8G file, which is 52G vs 48G memcg limit).
> But by evicting the file cache, the workload should hold just fine,
> especially given that the file worker pauses after every batch, allowing
> other workers to catch up.
> 
> - MGLRU disabled:
>   Finished 128 iterations.
> 
> - MGLRU enabled:
>   Hung or OOM with following info after about ~10-20 iterations:
> 
>     [  357.332946] file_anon_mix_pressure invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
>     ... <snip> ...
>     [  357.333827] memory: usage 50331648kB, limit 50331648kB, failcnt 90907
>     [  357.347728] swap: usage 0kB, limit 9007199254740988kB, failcnt 0
>     [  357.348192] Memory cgroup stats for /demo:
>     [  357.348314] anon 46724382720
>     [  357.348963] file 4160753664
> 
>   OOM occurs despite there is still evictable file folios.
> 
> - MGLRU enabled after this series:
>   Finished 128 iterations.
> 
> With aging blocking reclaim, the OOM will be much more likely to occur.
> This issue is mostly fixed by patch 6 and result is much better, but
> this series is still only the first step to improve file folio reclaim
> for MGLRU, as there are still cases where file folios can't be
> effectively reclaimed.
> 
> MySQL:
> ======
> 
> Testing with innodb_buffer_pool_size=26106127360, in a 2G memcg, using
> ZRAM as swap and test command:
> 
> sysbench /usr/share/sysbench/oltp_read_only.lua --mysql-db=sb \
>   --tables=48 --table-size=2000000 --threads=96 --time=600 run
> 
> Before:         22343.701667 tps
> After patch 4:  22327.325000 tps
> After patch 5:  22373.224000 tps
> After patch 6:  22321.174000 tps
> After patch 7:  22625.961667 tps (+1.26%, higher is better)
> 
> MySQL is anon folios heavy but still looking good. Seems only noise level
> changes, no regression.
> 
> FIO:
> ====
> Testing with the following command, where /mnt is an EXT4 ramdisk, 6
> test runs each in a 10G memcg:
> 
> fio -name=cached --numjobs=16 --filename=/mnt/test.img --buffered=1 \
>   --ioengine=io_uring --iodepth=128 --iodepth_batch_submit=32 \
>   --iodepth_batch_complete=32 --rw=randread \
>   --random_distribution=zipf:1.2 --norandommap --time_based \
>   --ramp_time=1m --runtime=10m --group_reporting
> 
> Before:        32039.56 MB/s
> After patch 3: 32751.50 MB/s
> After patch 4: 32703.03 MB/s
> After patch 5: 33395.52 MB/s
> After patch 6: 32031.51 MB/s
> After patch 7: 32534.29 MB/s
> 
> Also seem only noise level changes and no regression.
> 
> Build kernel:
> =============
> Build kernel test using ZRAM as swap, on top of tmpfs, in a 3G memcg
> using make -j96 and defconfig, measuring system time, 8 test run each.
> 
> Before:        2881.41s
> After patch 3: 2894.09s
> After patch 4: 2846.73s
> After patch 5: 2847.91s
> After patch 6: 2835.17s
> After patch 7: 2842.90s
> 
> Also seem only noise level changes, no regression or very slightly better.
> 
> Link: https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com/ [1]
> Link: https://github.com/brianfrankcooper/YCSB/blob/master/workloads/workloadb [2]
> Link: https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/ [3]
> Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure [4]
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>

I applied this patch set to 7.0-rc5 and noticed the system locking up when performing the below test.

fallocate -l 5G 5G
while true; do tail /dev/zero; done
while true; do time cat 5G > /dev/null; sleep $(($(cat /sys/kernel/mm/lru_gen/min_ttl_ms)/1000+1)); done

After reading [1], I suspect that this was because the system was using zram as swap, and yes if zram is disabled then the lock up does not occur. Anything that I (CachyOS) can do to help debug this regression, if it is to be considered one as according to [1], zram as swap seems to be unsupported by upstream. (the user that tested this wasn't able to get a good kernel trace, the only thing left was a trace of the OOM killer firing)

[1] https://chrisdown.name/2026/03/24/zswap-vs-zram-when-to-use-what.html

-- 
Regards,
  Eric

