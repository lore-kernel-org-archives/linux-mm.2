Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C47B3FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76266B0088; Mon, 27 Apr 2026 14:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07046B008A; Mon, 27 Apr 2026 14:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEECC6B008C; Mon, 27 Apr 2026 14:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B43FE6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F77616023D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:07 +0000 (UTC)
X-FDA: 84705117294.10.F0EC19C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 267C4A0013
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bzosTLRz;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313225;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BT5UZ8hktiymu67nM/evCdMoYki47w27cbz6CwKDki8=;
	b=eZ5uklqS9xuVE9LH9m/hSPc0a7AB0CVFdhKs6k7JnLkUVBvtgo6iRhctaZF2fp+NasHHJj
	0lDmAd0Fahsqw1Z437QJBEAxskmpmYokQPlAdUBBMEgvYhc38LR6dvaXqZbtSCzPJJXwC/
	C4BikHrfNgc5M4S5l+H5dnDQG43RvEM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bzosTLRz;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313225; a=rsa-sha256;
	cv=none;
	b=nGE9I6xb0WrMRIYGralXpRIZOVohd4gTGMzH0SLSB7Mxr2gJ3T0/BUw+YgHSh2KHGsSdvJ
	G1KSA0YkTWxecA7UT+lDcqppfIbevMqmKc5sltkgsX26qfRHeWBuDTUsrgnOV4gyghssyN
	i6NX5NBKYnfxbCR39C2tBeM4t2x78q4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E4AC4410D;
	Mon, 27 Apr 2026 18:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FCFFC19425;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313219;
	bh=w1IFnN74oI3NnQujD8SxvS6ZH/EFjcSNdbfeokMpUA0=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=bzosTLRznJWbEFRTpvr+l1eG9UeByt982P3dWiDQ3j2IgJ/ed6ffiT2pKf6FrZ1js
	 zZil6WXnReKUrpb+RPHV6T9jhizWl5q9wLwPS+Nq8fbJHsBJq91ugS+d3Oh2kZVqkS
	 hbXbqqtxIMCKFmSFTQhVqZ175YWUqh+fhFhVKzrkJkqk94paN+8MKZjsDI4TS2/zyS
	 Ez1u7V5Air1Z4inzqKzW3UTz1SFdtR7bzw4w9s3RhMyfgdQu+OlSEjZA/g2BzzUKkb
	 aRj7AIZerAYkJ9osidrNkktIW+O9PYGQIWBhqW+oSP4+IpsxXSyI6Rsc0iWuIsS14y
	 73JL8Hhihp2NA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631F7FF8865;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v7 00/15] mm/mglru: improve reclaim loop and dirty folio
 handling
Date: Tue, 28 Apr 2026 02:06:51 +0800
Message-Id: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XRS2rDMBSF4a0Ejaui96Oj7iN0IF9dJYLYLrIrU
 oL3XjlQ6trDI/h+CfQgE5aME3k7PUjBmqc8Dm3YlxOBaxguSHNsmwgmDJNc0f5yK1+0INxC7ik
 HH5UOoG0ypJnPginfn73zR9vXPM1j+X7mK19Pf0tuV6qcMipAmeSxY5q59xkHwGF+hbEna6uKj
 Rd+70XznZZBGus0l3D08s8rJvdeNh+E05iiScnzo1dbb/deNe8dJBnBeM390euN54f7dfMOAwb
 oYgSljt5svNj/RDXr+7U1QkRrGcj/flmWHxavJg/sAQAA
X-Change-ID: 20260314-mglru-reclaim-1c9d45ac57f6
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=13523;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=N7fc+nNzqGG+TU9ZKFZ+7d242WyOgwXJfjKVn+D3Vrg=;
 b=0EHweKg+IJmXx1Qdmeek4c41r1vF0JbmXeZtk2VX4B06s7AcbniFR+8wsP+m0mEJvI8xSglBb
 v0vV+k+fV5GA5uuTyNb/PPMs6Hmh+a9OOuIW0P85U/4FMwBoi/o9c7t
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 267C4A0013
X-Stat-Signature: scc7wmybzmefewr1tdbqmbq8zksiinq6
X-HE-Tag: 1777313224-709050
X-HE-Meta: U2FsdGVkX1+IL5F20SrnjbdM15hQwLA7tYQLvh0eeB6vqk3oX3PwWnVs0HQGNlFRmvdbNFEXbv9nNllPthX97x7GK9jVgBwVlx1Vxs3eb15RJyxjr6gRRD1cOiGLAg9K4M+/hwQN+fUoIFFA0HTNuiBu8QJz7D0op5y8I3OmoepJJFUoakAjqA9dEGx5ruQDWYFg+3d/PKLTpHh2uytK8vzl0VEirDvnX45sTLegkXwGLpSyy9jKG8cWfaOphO2AjowD/7oOyeOOn1jIcO4RrRhzG/7MmqKLIqtOq7g4pCostgXsMccrz8JyvkvRToLzCgSvp62oopKjFKMs0AljmFNjczhDVuqUj/6hX6ykX8551ub+NIyt//wGSdKRJhA+hkzkp48dCQeQVutjCc1T4q0lrGFvMhkdcvV7115wL2jd+wie2dwULxg9Wlbb3KO9U6u7N4hkSQueeYsWArT5RPFCF6tOGnEflzHriZspWpQ8Gay8RP0pi5kXhxT4fQVuHXRVVgWCCSomnaXAbTfDHW8cb68Z8H0KKTNhApIfg0DGE87D7VFypFcYxUEPTdTfuFckI8NCGi0eBSX1zSf2jaTKe6GAPBmQgpg8VIokJIoHx2/Xan83wfXUlA6HkNYlxb+Mxido07qWHst2WdGEuGHORabKY6DyqzZfViU+e/1xlgxBUAFa1nfBKTo2powyvDRwyhzwKX9Idy458wUw7YZlzvLp0WhgDmzIvX78qrME5HvCI0Sto7yGE/6RR3QSaJVT+MvJ1mUOvzFnmZ+acFhxe6e4B+8UERNpXK/GHuVDq3NE3jKh/fay+aNumlAS4Hfe7OLSDHRD21a9bMxvU6++NVgZqvPUZuhLmIbVApbwiXHK0O4CqlWApibgTNtkN+CrwpZCl4Ny7k74L49CpoFqZGfbuWlQ1h+3C3BOQ4LnL7vQJ+1F0OrmAMBN+neBd+bk2sI+Mwj7Y6Yu4rL
 TK46aWRc
 o52NssXflqTZ6GpIyGJjaHlaYCzT9krTvYdOR2hLsMB/nTq+MkV05LdDjv5Q4zeBks/MXcauu9yxmbmRdQ3iEp4iYHZhO/3942ghXXRpbGJXBAJnZD+L+F14cY9bchTKAO/18Sm06GgbCHV61n+0NRvxeGjOsaA+YqMR+ujkLqxcY+IP1X8zaYu8qMifgGLGRZ2RwI7je6xLwXo1OHDqLSTZN83wO4ArC3+HfjTVlOq+GniFiEM7g9za0yVFJpd7Hfw+bqTAQaKhIf9EEd55T27CUPLDxdHLHijznVvw7REx5sdtr0Rlsunja2PjwjAbwBocp53TulpZY/uVQcPEh9ECha31dhIvrkLiXuh41dw9cNQONFcIOfdgAWMNujyP/AZP9hRqIAc7CDRu7WaOIBco+hlRBjN4SX9hvTz7SvuzwlT0zoaGvlnPElHW+bDGEyoHKtG2rY+Z+qlQ98IaPO86Xg63g+xUCm00Vpy2e4BdivxD7jA/E/Vz1EJHmfPOU4CfadS0EcV3d1yQHqcxGcKFTPou+p0U+U5V/+Ia35KXlzeczeJhPpmUiee+rmVDVOn3iHjfo4TIn/0RFvDY71ZwnzlVkibEH7DloMFv8VuzapSlPxeVyBmOoWueENaRnq1Cb6KhGaKvJjBi5NK/6/1t5wtc/2JZBn1MZAsUXDjDHuXg4rzaoqTzEuz+z9dgxpzLGd7J6PhfVGsSlSo6ko4/H0ihp6/hwUxuJo5MyUI5yfGNYm/OasAGwQ/4XO5+eTmqj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

This series cleans up and slightly improves MGLRU's reclaim loop and
dirty writeback handling. As a result, we can see an up to ~30% increase
in some workloads like MongoDB with YCSB and a huge decrease in file
refault, no swap involved. Other common benchmarks have no regression,
and LOC is reduced, with less unexpected OOM, too.

Some of the problems were found in our production environment, and
others were mostly exposed while stress testing during the development
of the LSM/MM/BPF topic on improving MGLRU [1]. This series cleans up
the code base and fixes several performance issues, preparing for
further work.

MGLRU's reclaim loop is a bit complex, and hence these problems are
somehow related to each other. The aging, scan number calculation, and
reclaim loop are coupled together, and the dirty folio handling logic is
quite different, making the reclaim loop hard to follow and the dirty
flush ineffective.

This series slightly cleans up and improves these issues using a scan
budget by calculating the number of folios to scan at the beginning of
the loop, and decouples aging from the reclaim calculation helpers.
Then, move the dirty flush logic inside the reclaim loop so it can kick
in more effectively. These issues are somehow related, and this series
handles them and improves MGLRU reclaim in many ways.

Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
and a 128G memory machine using NVME as storage.

MongoDB
=======
Running YCSB workloadb [2] (recordcount:20000000 operationcount:6000000,
threads:32), which does 95% read and 5% update to generate mixed read
and dirty writeback. MongoDB is set up in a 10G cgroup using Docker, and
the WiredTiger cache size is set to 4.5G, using NVME as storage.

Not using SWAP.

Before:
Throughput(ops/sec): 62485.02962831822
AverageLatency(us): 500.9746963330107
pgpgin 159347462
pgpgout 5413332
workingset_refault_anon 0
workingset_refault_file 34522071

After:
Throughput(ops/sec): 79760.71784646061 (+27.6%, higher is better)
AverageLatency(us): 391.25169970043726 (-21.9%, lower is better)
pgpgin 111093923                       (-30.3%, lower is better)
pgpgout 5437456
workingset_refault_anon 0
workingset_refault_file 19566366       (-43.3%, lower is better)

We can see a significant performance improvement after this series.
The test is done on NVME and the performance gap would be even larger
for slow devices, such as HDD or network storage. We observed over
100% gain for some workloads with slow IO.

Chrome & Node.js [3]
====================
Using Yu Zhao's test script [3], testing on a x86_64 NUMA machine with 2
nodes and 128G memory, using 256G ZRAM as swap and spawn 32 memcg 64
workers:

Before:
Total requests:            79915
Per-worker 95% CI (mean):  [1233.9, 1263.5]
Per-worker stdev:          59.2
Jain's fairness:           0.997795 (1.0 = perfectly fair)
Latency:
Bucket     Count      Pct    Cumul
[0,1)s     26859   33.61%   33.61%
[1,2)s      7818    9.78%   43.39%
[2,4)s      5532    6.92%   50.31%
[4,8)s     39706   49.69%  100.00%

After:
Total requests:            81382
Per-worker 95% CI (mean):  [1241.9, 1301.3]
Per-worker stdev:          118.8
Jain's fairness:           0.991480 (1.0 = perfectly fair)
Latency:
Bucket     Count      Pct    Cumul
[0,1)s     26696   32.80%   32.80%
[1,2)s      8745   10.75%   43.55%
[2,4)s      6865    8.44%   51.98%
[4,8)s     39076   48.02%  100.00%

Reclaim is still fair and effective, total requests number seems
slightly better.

OOM issue with aging and throttling
===================================
For the throttling OOM issue, it can be easily reproduced using dd and
cgroup limit as demonstrated and fixed by a later patch in this series.

The aging OOM is a bit tricky, a specific reproducer can be used to
simulate what we encountered in production environment [4]:
Spawns multiple workers that keep reading the given file using mmap,
and pauses for 120ms after one file read batch. It also spawns another
set of workers that keep allocating and freeing a given size of
anonymous memory. The total memory size exceeds the memory limit
(eg. 14G anon + 8G file, which is 22G vs a 16G memcg limit).

- MGLRU disabled:
  Finished 128 iterations.

- MGLRU enabled:
  OOM with following info after about ~10-20 iterations:
    [   62.624130] file_anon_mix_p invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
    [   62.624999] memory: usage 16777216kB, limit 16777216kB, failcnt 24460
    [   62.640200] swap: usage 0kB, limit 9007199254740988kB, failcnt 0
    [   62.640823] Memory cgroup stats for /demo:
    [   62.641017] anon 10604879872
    [   62.641941] file 6574858240

  OOM occurs despite there being still evictable file folios.

- MGLRU enabled after this series:
  Finished 128 iterations.

Worth noting there is another OOM related issue reported in V1 of
this series, which is tested and looking OK now [5].

MySQL:
======

Testing with innodb_buffer_pool_size=26106127360, in a 2G memcg, using
ZRAM as swap and test command:

sysbench /usr/share/sysbench/oltp_read_only.lua --mysql-db=sb \
  --tables=48 --table-size=2000000 --threads=48 --time=600 run

Before:            17303.41 tps
After this series: 17291.50 tps

Seems only noise level changes, no regression.

FIO:
====
Testing with the following command, where /mnt/ramdisk is a
64G EXT4 ramdisk, each test file is 3G, in a 10G memcg,
6 test run each:

fio --directory=/mnt/ramdisk --filename_format='test.$jobnum.img' \
  --name=cached --numjobs=16 --size=3072M --buffered=1 --ioengine=mmap \
  --rw=randread --norandommap --time_based \
  --ramp_time=1m --runtime=5m --group_reporting

Before:            8968.76 MB/s
After this series: 8995.63 MB/s

Also seem only noise level changes and no regression or slightly better.

Build kernel:
=============
Build kernel test using ZRAM as swap, on top of tmpfs, in a 3G memcg
using make -j96 and defconfig, measuring system time, 12 test run each.

Before:            2873.52s
After this series: 2811.88s

Also seem only noise level changes, no regression or very slightly better.

Android:
========
Xinyu reported a performance gain on Android, too, with this series. The
test consisted of cold-starting multiple applications sequentially under
moderate system load. [6]

Before:
Launch Time Summary (all apps, all runs)
  Mean 868.0ms
  P50 888.0ms
  P90 1274.2ms
  P95 1399.0ms

After:
Launch Time Summary (all apps, all runs)
  Mean 850.5ms (-2.07%)
  P50 861.5ms  (-3.04%)
  P90 1179.0ms (-8.05%)
  P95 1228.0ms (-12.2%)

Link: https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com/ [1]
Link: https://github.com/brianfrankcooper/YCSB/blob/master/workloads/workloadb [2]
Link: https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/ [3]
Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure [4]
Link: https://lore.kernel.org/linux-mm/acgNCzRDVmSbXrOE@KASONG-MC4/ [5]
Link: https://lore.kernel.org/linux-mm/20260417025123.2971253-1-wxy2009nrrr@163.com/ [6]

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v7:
- Fix swappiness not being effective with a standalone fix patch
  from Barry Song. It's OK to be a standalone fix since that is not a
  major bug but an unexpected behavior change, and shouldn't effect any
  bisecting. I slightly adjusted the commit message as the subjcect is too
  long and getting truncated for mail:
  https://lore.kernel.org/linux-mm/20260425205759.1701-1-baohua@kernel.org/
- Remove the min limit for calculating nr_to_scan:
  https://lore.kernel.org/linux-mm/aet1hd9DfRH4aSOO@KASONG-MC4/
  Instead just revert to V1:
  https://sashiko.dev/#/message/20260318-mglru-reclaim-v1-3-2c46f9eb0508%40tencent.com
  Everyone was fine with that, the min limit in later version was
  introduced to cover sashiko's review on V1, but now think again, that's
  actually not a bug and instead could be beneficial. This min
  check doesn't always make sense and there isn't any practical issue observed.
- Retest still looking very good in every case.
- Link to v6: https://patch.msgid.link/20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com

Changes in v6:
- Avoid potential over rotation of tiny cgroup (<16M):
  https://lore.kernel.org/linux-mm/CAMgjq7ArnmmoHOGRt6Wc8hu7tjx_t583-UVzJK+HOHgjjetQ9g@mail.gmail.com/
- Avoid potentially skewed stat counter:
  https://lore.kernel.org/linux-mm/CAMgjq7DCn8p_yMMhiejFjX6sdybZKYOw8qJbq=+OCsZ=AfJnFA@mail.gmail.com/
- Update a few comment and varible name as suggested by Barry Song.
- Tested over days, also tested on my Android phone, everything still
  matches the cover letter description. And add test result from Xinyu.
- Link to v5: https://patch.msgid.link/20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com

Changes in v5:
- Add back a more moderate minimal batch limit for each reclaim loop:
  https://lore.kernel.org/linux-mm/adYP81AhpNf0znp3@KASONG-MC4/
- Collect review-by.
- Link to v4: https://patch.msgid.link/20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com

Changes in v4:
- Remove the minimal scan batch limit, and add rotate for
  unevictable memcg as reported by sashiko:
  https://lore.kernel.org/linux-mm/ac8xVN82LBLDZpIO@KASONG-MC4/
- Slightly imporove a few commit messages.
- Reran the test and seems identical with before so data are unchanged.
- Collect review-by.
- Link to v3: https://patch.msgid.link/20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com

Changes in v3:
- Don't force scan at least SWAP_CLUSTER_MAX pages for each reclaim
  loop. If the LRU is too small, adjust it accordingly. Now the
  multi-cgroup scan balance looked even better for tiny cgroups:
  https://lore.kernel.org/linux-mm/aciejkdIHyXPNS9Y@KASONG-MC4/
- Add one patch to remove the swap constraint check in isolate_folio. In
  theory, it's fine, and both stress test and performance test didn't
  show any issue:
  https://lore.kernel.org/linux-mm/CAMgjq7C8TCsK99p85i3QzGCwgkXscTfFB6XCUTWQOcuqwHQa2Q@mail.gmail.com/
- I reran most tests, all seem identical, so most data is kept.
  Intermediate test results are dropped. I ran tests on most patches
  individually, and there is no problem, but the series is getting too
  long, and posting them makes it harder to read and unnecessary.
- Split previously patch 8 into two patches as suggested [ Shakeel Butt ],
  also some test result is collected to support the design:
  https://lore.kernel.org/linux-mm/ac44BVOvOm8lhVvj@KASONG-MC4/#t
  I kept Axel's review-by since the code is identical.
- Call try_to_inc_min_seq twice to avoid stale empty gen and drop
  its return argument [ Baolin Wang ]
- Move a few lines of code between patches to where they fits better,
  the final result is identical [ Baolin Wang ].
- Collect tested by and update test setup [ Leno Hou ]
- Collect review by.
- Update a few commit message [ Shakeel Butt ].
- Link to v2: https://patch.msgid.link/20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com

Changes in v2:
- Rebase on top of mm-new which includes Cgroup V1 fix from
  [ Baolin Wang ].
- Added dirty throttling OOM fix as patch 12, as [ Chen Ridong ]'s
  review suggested that we shouldn't leave the counter and reclaim
  feedback in shrink_folio_list untracked in this series.
- Add a minimal scan number of SWAP_CLUSTER_MAX limit in patch
  "restructure the reclaim loop", the change is trivial but might
  help avoid livelock for tiny cgroups.
- Redo the tests, most test are basically identical to before, but just
  in case, since the patch also solves the throttling issue now, and
  discussed with reports from CachyOS.
- Add a separate patch for variable renaming as suggested by [ Barry
  Song ]. No feature change.
- Improve several comment and code issue [ Axel Rasmussen ].
- Remove no longer needed variable [ Axel Rasmussen ].
- Collect review by.
- Link to v1: https://lore.kernel.org/r/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com

---
Barry Song (Xiaomi) (1):
      mm/mglru: avoid reclaim type fall back when isolation makes no progress

Kairui Song (14):
      mm/mglru: consolidate common code for retrieving evictable size
      mm/mglru: rename variables related to aging and rotation
      mm/mglru: relocate the LRU scan batch limit to callers
      mm/mglru: restructure the reclaim loop
      mm/mglru: scan and count the exact number of folios
      mm/mglru: use a smaller batch for reclaim
      mm/mglru: don't abort scan immediately right after aging
      mm/mglru: remove redundant swap constrained check upon isolation
      mm/mglru: use the common routine for dirty/writeback reactivation
      mm/mglru: simplify and improve dirty writeback handling
      mm/mglru: remove no longer used reclaim argument for folio protection
      mm/vmscan: remove sc->file_taken
      mm/vmscan: remove sc->unqueued_dirty
      mm/vmscan: unify writeback reclaim statistic and throttling

 mm/vmscan.c | 341 ++++++++++++++++++++++++++----------------------------------
 1 file changed, 149 insertions(+), 192 deletions(-)
---
base-commit: 22f2053a471467342c51eb2e4ffd7daf601118d2
change-id: 20260314-mglru-reclaim-1c9d45ac57f6

Best regards,
--  
Kairui Song <kasong@tencent.com>



