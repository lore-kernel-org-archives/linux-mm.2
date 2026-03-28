Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A3310F3DF9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552496B0099; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502016B009E; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0856B0099; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3C26B0096
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF62F1A0198
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:34 +0000 (UTC)
X-FDA: 84596519028.24.224221A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CB86740005
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lDRm5yFN;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727553;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mEBYzDkTdKQpSMjrdkyLipTKsngICUr2nPkztyJZpg8=;
	b=ovCl5B2M1qHJ7jer9D4jiuD9XLF0GHF3S7NFqIaqdh03hJiFn+t6y3m9w6j4Epx3/me+Lo
	U4cP6zSJS3+3+NcPcoieex8si9gkSCTVHG1945bYmYJLL8ecSlklfLxGh7UV7SXNFr2EBj
	KLM5Mt/LMPiHdgOvw+knoszBDPbWjls=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lDRm5yFN;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727553; a=rsa-sha256;
	cv=none;
	b=pnxReFfno4jYlNCgISdsxRdgC9hDeWQ+nMW3KxA7VtP9giWpoy7UDbshcLIKJmJq0HRPrJ
	cETKScDveDn1Yh2ihGXzjOcQskOq+gq9o3LhVV/w+ex4DqOyewOLChPxnpPw0M/+S9Fc+q
	mfHw+2CDYzusJoD1udAdMzFm2N0K0nk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AB4D44441;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24087C4CEF7;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=35yLS4uOo5XTtIbJNZAJxiJKNivR5w1dba4z/A6nZec=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=lDRm5yFNiYuk2PpX5xQjCViUY6TX+wa2s2ltFlQlzonbq4m+c+MoFO7sKl/GuLBuM
	 udvvLZK1KLXx70dW/G6QF75r1C6UYeUTJlwYiH9gwUXxJmPPJNSx1+pm9ST51MPrjK
	 ZZXZl2V2FpYL2NPTnVfQYu61HGD66DcncSeFzUTsOftjEdEKuBY/azvZJNEBJSMEex
	 +qOB7hYHDBDc7Pvkfm0wB5ckDtw+par+KzqdqGL2d+NgDiEssz8iaMugiIlhEg2Zu3
	 atvDpbAHkVLB//Rq2TgPE2EvrWydoQnt2Fga0XLQ6ST7aGwQfOnb6c2j+LgDloONOn
	 tnOu8IoagqFJw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DE610F2866;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v2 00/12] mm/mglru: improve reclaim loop and dirty folio
 handling
Date: Sun, 29 Mar 2026 03:52:26 +0800
Message-Id: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13MQQ6CMBCF4auQWVvT1raCK+9hWOAwwCRQTFuJh
 nB3K4kbl/9L3rdCpMAU4VKsEGjhyLPPoQ8F4ND4ngS3uUFL7eRJGTH1Y3iKQDg2PAmFVWtsg/b
 cOcifR6COX7t3q3MPHNMc3ju/qO/6k8o/aVFCCo3GdRXdpZXlNZFH8umI8wT1tm0fPCJ17awAA
 AA=
X-Change-ID: 20260314-mglru-reclaim-1c9d45ac57f6
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=9146;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=35yLS4uOo5XTtIbJNZAJxiJKNivR5w1dba4z/A6nZec=;
 b=ialMt7ZZ2TGQLCQ8GGwjo9DV92CJSOOYZoTQi8QqoZ700iVBS10BwZOedF0p5UKd5L6d5X37v
 DtsZ28J1rF6Ayj+ljF53LFHRL+GMLuAqTNcPiXyo93njuer316o8sXx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: fs5b9ioq91byj7uix43xj3y6n5f33o5s
X-Rspamd-Queue-Id: CB86740005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774727552-858862
X-HE-Meta: U2FsdGVkX18rKR/V6GJxiF0fWW6fmS+4phToOIMB6z8lfV6QQCHKvTgAknkveHJxU3izCLlVehzUsfYgkIUJ9G/e+sEbXAaWOsiG8EQGrCKoMi05EQHQB92fM2yXOcWQcHInsQXrWZa+UDLXXOdy6Z6eRto1QbNpENLLkg+5kMtu7Te2Tu+BYPvDGBwRENFOOpuJW3CxJiFyoozOJohYxbtP+KYnsaemRighH8fu1Td713G2+57mdVyQwGZ6IZoPiGMbAWaWZ7VPEXObBSr1AAA5s1IsemepP1LvQ5Znm0vV69aniHxoMqBdrOcDPIbxXMdjIo36qK8WkITwqIorR2BtC1Xo6UlUCokpWz4P+ZW1Po7dyJlKXJK+mPbjU5iDQOZueChzdu2U+8w7RJlSJMzXnmAgfAt8SnbtG8UNGLecFBg8Y+oQYyDhNQ9P2YPo0WWhvvv66TSs/VXlqEg58wFlNM6EJ7Rista3MH5/TNBeqaPf8mwLyBmopzcoaFf2nmkUUgRU9CcsTzKYBJQVxhaz0RJV+xouDsQ83igEiEUB3C6YbAng9cRhj6adNwT1kVFbRmRuxsgtfLFiIndpDZRhg4nlqDtF0BKvQbg+ZFZRWeyE3O1dIDrxkYOOu7ZQUehNG4h8zQnnF+6OPJqNZU/BzZECv1UcFXvGhhaxwZuH5z50qT3i8pPzhLdqPO6KU8BEIdG4U9YvW1r0LRQ34vqiy36R6rQO25lQTwKPGl0nzTKRFxDXFgX5aNgucgPFzx/h8LMSB/vTLHYaCoNAOIM+tyANIFq4Y5haySNTTnReoQGlh5V1ygWe8v5uKPfRNEdIaA4mmzlDTFs1oK7L4Hlek/jz8LOmOa1f3SeeNNCsDItLQBR80SzmtUOrGIzRNrY/NWGdkd9H5aoGmFNRKAhcQQKdptrs2KTUptKCqV+NAWQcuBGyX4bposvFtQiokHK64VaUzvVuPPbXvwb
 y5A+YQK0
 QBs/dhjBRvM9COy0qFdlkMo07EmWT2gfy4W33UaYuR7cqug7pxFXjO6UR49ADbGEFL3ziycLn2M0cueHJyXu3um5IUCQkC7C0ZSZCVMa5mmWFgPiyLqrTLXVdFu+qyc2CfNnUMC4mBd6OQhvoJFHDJRnn6CQpMgnvPUoKL8lDpGNdIcY516YPR6QvO9QnhY0mt0W/7OZAJW7qKhRDUx/aUMxKKJqn3tTWeVYaaxG0llfbJvsnedpBkYhpes+f/M06sSdSYXNlWnjLLu/kzb8ctUnf2+wnwkm1W0HcE5+NSpE9Nr5atSzFpjaXE8nqAL1vmstfE8XxGzIhh33WrJiiZQfw15z9ZQ9SwE9wjX7EVF3ubHCDayS9BRvMsumtXUfO0Q2k4phPk0vhDUCgoZo3X3jSql+y3QR9bxk3ovtbXXDwV8Y70WKgHaYPsC+SHZ19v3X8+D7z8Xu/M9F+n8NjRaT+v4Rfjpuzit1O3V9AEu4SYuRHLmWoCld9fHQoZsuTZPfRbXTTAuBqzq1qt5XiAN0Q847Ey+YaEt2WVjSPjjTpeDDu9jQnwAcwPiqTJIxlmj0FKoqUTSNKyPDLoOYldPjgfaTf7ycDJFU3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is based on mm-new to avoid conflict with Baolin's Cgroup V1
MGLRU fix.

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

Median of 3 test run, results are stable.

Before:
Throughput(ops/sec): 63050.37725142389
AverageLatency(us): 497.0088950307069
pgpgin 164636727
pgpgout 5551216
workingset_refault_anon 0
workingset_refault_file 34365441

After:
Throughput(ops/sec): 79937.11613530689 (+26.7%, higher is better)
AverageLatency(us): 390.1616943501661  (-21.5%, lower is better)
pgpgin 108820685                       (-33.9%, lower is better)
pgpgout 5406292
workingset_refault_anon 0
workingset_refault_file 18934364       (-44.9%, lower is better)

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
Total requests:            81832
Per-worker 95% CI (mean):  [1248.8, 1308.4]
Per-worker stdev:          119.1
Jain's fairness:           0.991530 (1.0 = perfectly fair)
Latency:
[0,1)s     27951   34.16%   34.16%
[1,2)s      7495    9.16%   43.32%
[2,4)s      8140    9.95%   53.26%
[4,8)s     38246   46.74%  100.00%

After:
Total requests:            82413
Per-worker 95% CI (mean):  [1241.4, 1334.0]
Per-worker stdev:          185.3
Jain's fairness:           0.980016 (1.0 = perfectly fair)
Latency:
[0,1)s     27940   33.90%   33.90%
[1,2)s      8772   10.64%   44.55%
[2,4)s      6827    8.28%   52.83%
[4,8)s     38874   47.17%  100.00%

Seems identical, reclaim is still fair and effective, total requests
number seems slightly better.

OOM issue with aging and throttling
===================================
For the throttling OOM issue, it can be easily reproduced using dd and
cgroup limit as demonstrated in patch 12, and fixed by this series.

The aging OOM is a bit tricky, a specific reproducer can be used to
simulate what we encountered in production environment [4]: Spawns
multiple workers that keep reading the given file using mmap, and pauses
for 120ms after one file read batch. It also spawns another set of
workers that keep allocating and freeing a given size of anonymous memory.
The total memory size exceeds the memory limit (eg. 44G anon + 8G file,
which is 52G vs 48G memcg limit).

- MGLRU disabled:
  Finished 128 iterations.

- MGLRU enabled:
  OOM with following info after about ~10-20 iterations:
    [  154.365634] file_anon_mix_p invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
    [  154.366456] memory: usage 50331648kB, limit 50331648kB, failcnt 354207
    [  154.378941] swap: usage 0kB, limit 9007199254740988kB, failcnt 0
    [  154.379408] Memory cgroup stats for /demo:
    [  154.379544] anon 44352327680
    [  154.380079] file 7187271680

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

Before:            17237.570000 tps
After patch 5:     17259.975714 tps
After patch 6:     17230.475714 tps
After patch 7:     17250.316667 tps
After patch 8:     17278.933333 tps
After this series: 17265.361667 tps (+0.2%, higher is better)

MySQL is anon folios heavy, involves writeback and file and still
looking good. Seems only noise level changes, no regression in
any step.

FIO:
====
Testing with the following command, where /mnt/ramdisk is a
64G EXT4 ramdisk, each test file is 3G, 6 test runs each in a
12G memcg:

fio --directory=/mnt/ramdisk --filename_format='test.$jobnum.img' \
       --name=cached --numjobs=16 --buffered=1 --ioengine=mmap \
       --rw=randread --random_distribution=zipf:1.2 --norandommap \
       --time_based --ramp_time=1m --runtime=5m --group_reporting

Before:            75912.75 MB/s
After this series: 75907.46 MB/s

Also seem only noise level changes and no regression.

Build kernel:
=============
Build kernel test using ZRAM as swap, on top of tmpfs, in a 3G memcg
using make -j96 and defconfig, measuring system time, 12 test run each.

Before:            2604.29s
After this series: 2538.90s

Also seem only noise level changes, no regression or very slightly better.

Link: https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com/ [1]
Link: https://github.com/brianfrankcooper/YCSB/blob/master/workloads/workloadb [2]
Link: https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/ [3]
Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure [4]
Link: https://lore.kernel.org/linux-mm/acgNCzRDVmSbXrOE@KASONG-MC4/ [5]

Signed-off-by: Kairui Song <kasong@tencent.com>
---
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
Kairui Song (12):
      mm/mglru: consolidate common code for retrieving evitable size
      mm/mglru: rename variables related to aging and rotation
      mm/mglru: relocate the LRU scan batch limit to callers
      mm/mglru: restructure the reclaim loop
      mm/mglru: scan and count the exact number of folios
      mm/mglru: use a smaller batch for reclaim
      mm/mglru: don't abort scan immediately right after aging
      mm/mglru: simplify and improve dirty writeback handling
      mm/mglru: remove no longer used reclaim argument for folio protection
      mm/vmscan: remove sc->file_taken
      mm/vmscan: remove sc->unqueued_dirty
      mm/vmscan: unify writeback reclaim statistic and throttling

 mm/vmscan.c | 308 ++++++++++++++++++++++++++----------------------------------
 1 file changed, 132 insertions(+), 176 deletions(-)
---
base-commit: e4b3c4494ae831396aded19f30132826a0d63031
change-id: 20260314-mglru-reclaim-1c9d45ac57f6

Best regards,
--  
Kairui Song <kasong@tencent.com>



