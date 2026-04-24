Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 720CAFE5204
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 10:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46A66B0005; Fri, 24 Apr 2026 06:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD03A6B008A; Fri, 24 Apr 2026 06:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98016B008C; Fri, 24 Apr 2026 06:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E38F6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:32:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F6BE1B89A3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:32:36 +0000 (UTC)
X-FDA: 84693085512.16.912188E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2485E180002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:32:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LLlpaU0O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777026754; a=rsa-sha256;
	cv=none;
	b=k9albXWmJXvqWXoPJqCttPOzONNfHCWSagM372UTfUoMn6VGH7nOXqCLvAzpqXEezA//wq
	7vxwEdWNeXI4Eo7f6esPjFVL1+bSQnVYFd70SZMuRpCnVMi3Gfu9pkv5JkPBeOYTPiEBNc
	sllB7wsUYsiGahrSQyp/0cEaPmuplrs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LLlpaU0O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777026754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juJQr9IXiS8I9QK99oKrxDM1waYq/+7E8xFl/tItc9E=;
	b=cUWCMeBq2jqVy8ncHPpvs+I0ELwwJNMOHdSBaI4YaUfIyCGrlHqbBcq6KpzLVfcjZsRlfO
	carQlyGOBYpYgxuhsvp5svh26dW6koD/cDOYB0gKDR/xM3tVYTGuHHV3wcPf9Ef5voTbd2
	YI+Q5yAAnhk7GkFEtFjN4p4s0GlaGGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3F7E4456E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41E5C2BCB4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777026752;
	bh=+KZy7ScTYXdiyLkOa4oV7lwdlAynavZiiqKf6UQgZmk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LLlpaU0OnWnPvq9YcPPgGNFf7TFTMIV2s5bebzbmtCRxjnTUz/V4W32HLyMqdcJ7E
	 46BSfNnYuDfISLHiepE/ipXCVg6TfkAoRFiDm56VG5GpFMhRXS8VRtlrmbAvd37pWK
	 DXdlJUXUY5f+9xOuyLU4IRHcQR4W46Mp5XDIWZPI3cN3HS/cp1nRKUlXGNZ5I2y6oo
	 beuaUzd1lFao6V1gN7zlr9TeMSeNeEHZ35kQY9idI3fqWl7+wJZeOQoKf36g+r34Hl
	 vnAaAc1iK7BPl1ml106Kfld5q7pEopPvPcEkD94V1VtLxPWppHzKMrp20b9SD6bfkq
	 kooNbqfIBgwiw==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8aca2726f61so91825286d6.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:32:32 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx5Xw+4ynDwQtLppW+8ms8tJF62IADh+feZuf3BGHLfFiabvrcE
	v971eTH0tr5xfgHxozoJ7JarkF+9ezROU9ZFh0skGGQStEV7i+bwUYyBcm8MDZo8pO3f4SJZcmo
	ak4xA5AflVRkGVpcw/Uqz/sxv20UYWBs=
X-Received: by 2002:a05:6214:470c:b0:8a5:104b:e361 with SMTP id
 6a1803df08f44-8b0281693c3mr414223586d6.50.1777026751640; Fri, 24 Apr 2026
 03:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 24 Apr 2026 18:32:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wLc15iF4sa6z+i812vaoabAGHS5ErPpjRyjLGMP=44AA@mail.gmail.com>
X-Gm-Features: AQROBzCXuS7RVpXsuLEox2B-bj4MehW1oFwy7deS2p0t3mYIoIw01rTgnguXOxY
Message-ID: <CAGsJ_4wLc15iF4sa6z+i812vaoabAGHS5ErPpjRyjLGMP=44AA@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: p1trn3psac8dek3g9i8qpu6hwebigjth
X-Rspam-User: 
X-Rspamd-Queue-Id: 2485E180002
X-HE-Tag: 1777026753-760559
X-HE-Meta: U2FsdGVkX1+Vxtjs4j/bZB+jC21eDywdv2AIE2ZkZzh0WnrntTA41L5s/ovU5BmIxgvc4YjpFmzp3brTUdMjfi2UGARbpKugCfTC/gCz2M1+7xxA2D5pVPa9k2+YsDbcytbHpvsEz/fu3uyp0riQknOLmwAPJy6LZYHe0asjI/+UNiRNVFz1ZHW6sGtDBfL5iTDS98WkWRqielQVsR3kNU5oj3v6basl//sXofXhY2uqDimPoMyEaOvlQVDINH91aONYOi157TVS/oLvCTl+XrWUJjMUohRAWyCrea14RS021/dvtaiXINqBEWuJrXQmMze/q0m1tAL5/WUfY5DhjSxMaBS4jwUTSaluic9oJ7Al2dSSAe761aZOX8GqYMfKcFrI6jhGjNmi/X/yTnuwfASxLaTs/j3T9za23MAzRuudvRKrpyFiXooWSWNUdNL9QiiIi29/SaekhQVPHZD7k7vIp6AfKLpxyOO/NnTJpoa6JpvQjGDrP3TIkoR6PIlpQvblNr4I8CrbKn8gVhE7Y/kZZB49/yYtxPNT7ibOQdy9NGONxH9Htykx01iEFfDadkJH+dS8IMxjQC8H0oawwGe44/Op7n9wHL8WUkri99tdKjcRvo9bWVMTMnrMXU8TbUqVpFhrHOLpy72AEJU3jZwh/n5TsiR7l7PkOqI4+LC9u/maDbj1s34c3DELH+9B1HhcrjHnrSRGF2VKPAljLPt6nhkc6jNUDyT6SNreUMKQUZgmQ/mC87lKmGSc0H7B2OTAOEkplfAVKE4eiKvVvvniZ8mu/RiBzxpwy5+U6E76j0+PCOSCVfVgWiVAol3DaVvGYNrIVXivIYbnXqFjICdwuSUlIrDujpSMSuEieEUJG4uMcE+Nig5VuaB0uzVxW+sHDy6vZRRaf97xi6pt/rDxCURIxj5sAMknM1x2In8vNEAPlxN8j9755Xzo7Tc6MCLHPh3Ugxa/R5htDSW
 pqF8zn0o
 uf2t8e5ChOTSqjvY1VX6OZ25KpQYHUppEGGHkj/XAPOwjt4JDHGFsbQeu2uY3M73qm+WT/BmF0308tFQdA97O2HHlSBGPFIHdmQodUlY9f7T5u6WH7HrTkNCVVVxE+cHJ38WkcPkt1ve0oB6dHj8f+XW2JF3mBpCWerE+3aj/kbi+gjJULlpbvPef580AlhTuqaB66ishSajYo/zjMq3Z4obQXnzPyz04K2qCkZQGJs0Uq6wvJI5B1VuJjRAdcdQrs/7PEHrQcA2sbB9HJE5DeHa8pZref44COFh15rclXf4mgBH01JG0QvACcLKTPjN69acYWJHfdsyfwHSkeZ6jbpXhSwvIwqyNTgNpWU+VyW6PECbS9IKtLv/Z0aTz0goifNonGhsRkuGIPt16TYAziCqtsn7QJ5tUTScIZkUaPSuoDHitXrTuorsrTszfgeJUies/g9aZu6qNRVCUc79pKiYT2Gaj7snEO79EnE74Px4dNlHoAPYkDx4GhyVwok6CwDUHq/lTX8whrpFCx1V7hI3GgHzgDdUx97HsmdO0S9gY9pQg9011bvMXCGyjKaXTGj76dV8D9llEJ0jsVi6tHXRoFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 1:43=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
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
>
> MongoDB
> =3D=3D=3D=3D=3D=3D=3D
> Running YCSB workloadb [2] (recordcount:20000000 operationcount:6000000,
> threads:32), which does 95% read and 5% update to generate mixed read
> and dirty writeback. MongoDB is set up in a 10G cgroup using Docker, and
> the WiredTiger cache size is set to 4.5G, using NVME as storage.
>
> Not using SWAP.
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
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Using Yu Zhao's test script [3], testing on a x86_64 NUMA machine with 2
> nodes and 128G memory, using 256G ZRAM as swap and spawn 32 memcg 64
> workers:
>
> Before:
> Total requests:            79915
> Per-worker 95% CI (mean):  [1233.9, 1263.5]
> Per-worker stdev:          59.2
> Jain's fairness:           0.997795 (1.0 =3D perfectly fair)
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
> Jain's fairness:           0.991480 (1.0 =3D perfectly fair)
> Latency:
> Bucket     Count      Pct    Cumul
> [0,1)s     26696   32.80%   32.80%
> [1,2)s      8745   10.75%   43.55%
> [2,4)s      6865    8.44%   51.98%
> [4,8)s     39076   48.02%  100.00%
>
> Reclaim is still fair and effective, total requests number seems
> slightly better.
>
> OOM issue with aging and throttling
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> For the throttling OOM issue, it can be easily reproduced using dd and
> cgroup limit as demonstrated in patch 14, and fixed by this series.
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
>     [   62.624130] file_anon_mix_p invoked oom-killer: gfp_mask=3D0xcc0(G=
FP_KERNEL), order=3D0, oom_score_adj=3D0
>     [   62.624999] memory: usage 16777216kB, limit 16777216kB, failcnt 24=
460
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
>
> MySQL:
> =3D=3D=3D=3D=3D=3D
>
> Testing with innodb_buffer_pool_size=3D26106127360, in a 2G memcg, using
> ZRAM as swap and test command:
>
> sysbench /usr/share/sysbench/oltp_read_only.lua --mysql-db=3Dsb \
>   --tables=3D48 --table-size=3D2000000 --threads=3D48 --time=3D600 run
>
> Before:            17260.781429 tps
> After this series: 17266.842857 tps
>
> MySQL is anon folios heavy, involves writeback and file and still
> looking good. Seems only noise level changes, no regression.
>
> FIO:
> =3D=3D=3D=3D
> Testing with the following command, where /mnt/ramdisk is a
> 64G EXT4 ramdisk, each test file is 3G, in a 10G memcg,
> 6 test run each:
>
> fio --directory=3D/mnt/ramdisk --filename_format=3D'test.$jobnum.img' \
>   --name=3Dcached --numjobs=3D16 --size=3D3072M --buffered=3D1 --ioengine=
=3Dmmap \
>   --rw=3Drandread --norandommap --time_based \
>   --ramp_time=3D1m --runtime=3D5m --group_reporting
>
> Before:            9196.481429 MB/s
> After this series: 9256.105000 MB/s
>
> Also seem only noise level changes and no regression or slightly better.
>
> Build kernel:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Build kernel test using ZRAM as swap, on top of tmpfs, in a 3G memcg
> using make -j96 and defconfig, measuring system time, 12 test run each.
>
> Before:            2589.63s
> After this series: 2543.58s
>
> Also seem only noise level changes, no regression or very slightly better=
.
>
> Android:
> =3D=3D=3D=3D=3D=3D=3D=3D
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
>
> Link: https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=3D8=3D75su3=
8w=3DHD782T5E_cxyeCeH_g@mail.gmail.com/ [1]
> Link: https://github.com/brianfrankcooper/YCSB/blob/master/workloads/work=
loadb [2]
> Link: https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.=
com/ [3]
> Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mi=
x-pressure [4]
> Link: https://lore.kernel.org/linux-mm/acgNCzRDVmSbXrOE@KASONG-MC4/ [5]
> Link: https://lore.kernel.org/linux-mm/20260417025123.2971253-1-wxy2009nr=
rr@163.com/ [6]
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Hi Kairui,

I haven't identified the exact commit, but this patchset seems to
make MGLRU's swappiness behavior more erratic.

In mainline, MGLRU does not show as strong an effect as the
active/inactive LRU, but it still behaves roughly linearly: higher
swappiness leads to more swap activity and fewer file refaults.

With this patchset, however, the behavior becomes non-monotonic as
swappiness increases. I observed clear up-and-down fluctuations.

I reproduced this by running a kernel build in a memcg limited to
1GB, with swappiness set to 35, 70, 105, 140, and 175.

this is mainline using MGLRU:

*** Executing round 1 ***
set swappiness to 35

real 1m49.247s
user 25m30.484s
sys 3m37.203s
pswpin: 933731
pswpout: 3365968
pgpgin: 5649320
pgpgout: 13786572
swpout_zero: 794960
swpin_zero: 10594
refault_file: 354998
refault_anon: 944323

*** Executing round 2 ***
set swappiness to 70

real 1m49.313s
user 25m31.643s
sys 3m40.661s
pswpin: 1049052
pswpout: 3565887
pgpgin: 5694288
pgpgout: 14582200
swpout_zero: 840947
swpin_zero: 12029
refault_file: 242973
refault_anon: 1061033

*** Executing round 3 ***
set swappiness to 105

real 1m48.611s
user 25m32.198s
sys 3m37.210s
pswpin: 981095
pswpout: 3396069
pgpgin: 5283940
pgpgout: 13898988
swpout_zero: 795932
swpin_zero: 11249
refault_file: 202432
refault_anon: 992295

*** Executing round 4 ***
set swappiness to 140

real 1m49.398s
user 25m35.650s
sys 3m50.656s
pswpin: 1222881
pswpout: 3935186
pgpgin: 6165024
pgpgout: 16056664
swpout_zero: 913808
swpin_zero: 13251
refault_file: 191564
refault_anon: 1236083

*** Executing round 5 ***
set swappiness to 175

real 1m49.513s
user 25m35.442s
sys 3m55.869s
pswpin: 1343139
pswpout: 4256014
pgpgin: 6557152
pgpgout: 17341452
swpout_zero: 998107
swpin_zero: 15692
refault_file: 175795
refault_anon: 1358782

this is mm-new using MGLRU:

*** Executing round 1 ***
set swappiness to 35

real 1m51.804s
user 25m38.070s
sys 4m16.301s
pswpin: 1587728
pswpout: 4932011
pgpgin: 8788688
pgpgout: 20062761
swpout_zero: 1129975
swpin_zero: 17944
refault_file: 487923
refault_anon: 1605670

*** Executing round 2 ***
set swappiness to 70

real 1m51.503s
user 25m37.581s
sys 4m18.161s
pswpin: 1743890
pswpout: 5214587
pgpgin: 8676728
pgpgout: 21178716
swpout_zero: 1185453
swpin_zero: 20016
refault_file: 317993
refault_anon: 1763904

*** Executing round 3 ***
set swappiness to 105

real 1m51.154s
user 25m37.956s
sys 4m15.017s
pswpin: 1687517
pswpout: 5073825
pgpgin: 8173036
pgpgout: 20608932
swpout_zero: 1161806
swpin_zero: 20069
refault_file: 249769
refault_anon: 1707538

*** Executing round 4 ***
set swappiness to 140

real 1m50.732s
user 25m37.686s
sys 4m16.066s
pswpin: 1671678
pswpout: 5118895
pgpgin: 7929960
pgpgout: 20790468
swpout_zero: 1171029
swpin_zero: 19596
refault_file: 193421
refault_anon: 1691228

*** Executing round 5 ***
set swappiness to 175

real 1m49.518s
user 25m37.653s
sys 4m12.619s
pswpin: 1506888
pswpout: 4789793
pgpgin: 7270448
pgpgout: 19479188
swpout_zero: 1119251
swpin_zero: 16699
refault_file: 187304
refault_anon: 1523585

The final one is classic active/inactive LRU:

*** Executing round 1 ***
set swappiness to 35

real 1m50.038s
user 25m21.911s
sys 3m42.798s
pswpin: 476994
pswpout: 2258185
pgpgin: 5247280
pgpgout: 9354640
swpout_zero: 684759
swpin_zero: 6387
refault_file: 750021
refault_anon: 483334

*** Executing round 2 ***
set swappiness to 70

real 1m48.781s
user 25m25.682s
sys 3m37.854s
pswpin: 515470
pswpout: 2306901
pgpgin: 4265500
pgpgout: 9547436
swpout_zero: 706437
swpin_zero: 6960
refault_file: 459740
refault_anon: 522381

*** Executing round 3 ***
set swappiness to 105

real 1m48.233s
user 25m26.623s
sys 3m38.843s
pswpin: 519540
pswpout: 2343897
pgpgin: 3628788
pgpgout: 9696500
swpout_zero: 743576
swpin_zero: 7782
refault_file: 303701
refault_anon: 527273

*** Executing round 4 ***
set swappiness to 140

real 1m48.800s
user 25m32.067s
sys 3m50.751s
pswpin: 605537
pswpout: 2615227
pgpgin: 3470540
pgpgout: 10776312
swpout_zero: 825446
swpin_zero: 9055
refault_file: 173236
refault_anon: 614544

*** Executing round 5 ***
set swappiness to 175

real 1m52.356s
user 25m29.727s
sys 3m55.664s
pswpin: 698228
pswpout: 2908292
pgpgin: 3602884
pgpgout: 11945332
swpout_zero: 912127
swpin_zero: 10298
refault_file: 117625
refault_anon: 708478


The build script is available here if you want to have a try:

https://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git/diff/tools=
/mm/build-kernel-with-increasing-swappiness.sh?h=3Dzram-async-gc&id=3Dd4788=
8e9

I am also debugging this. One possibility is that placing
dirty pages in the youngest generation may have affected
lruvec_evictable_size()?

Thanks
Barry

