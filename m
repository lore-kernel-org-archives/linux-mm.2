Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18A08CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1761B6B0095; Fri, 19 Jun 2026 10:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101B56B0096; Fri, 19 Jun 2026 10:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EFA6B0098; Fri, 19 Jun 2026 10:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A83006B0095
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:59:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E9151C4EC7
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:59:31 +0000 (UTC)
X-FDA: 84896970942.05.10B7A42
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id F26648000B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:59:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781881169;
	b=GUGn8vz7JXNjYdJD7vrqGSm3iU9H7YD8DEEbDI4AcuXuIzwQo07GA96GrSWJnI/Zop3w29
	UQbCd4iR/M/ZacgxjfaFhUen0+vomYS19D4tzuJzOMisjBm5SMt0IZEwahq1Ny9sxdHuqT
	kbaiOx0rPbivU79Xx6cWejBGbugjW8c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781881169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=3BGTuvlyOro4y5zsQyj05HLxBQ6GRBEddvxkZofi7z8=;
	b=5Bb5ffegvUHsc07ZzAP0H3LVCRa6iZz+nQqV5e4xS4V1JTomplvfQxHSUYnM6JgYf+NEf9
	rDqH0uNH+JePdxoejd6gBQcUUQt/GlctMFxbvB7R7uKX1hozOqBw/yOPIWAqKIh7sL2oGb
	JgLsH7oqDQ8fhoVf9/vWaXEkruOIWLk=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ghghs5JTpzJ467K;
	Fri, 19 Jun 2026 22:58:53 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 3634140571;
	Fri, 19 Jun 2026 22:59:22 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Jun 2026 17:59:21 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Fri, 19 Jun 2026 14:58:18 +0000
Message-ID: <20260619145821.2109933-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: jsk7xeb7ejfe66uqjstqhw4d33mf99bu
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F26648000B
X-Rspam-User: 
X-HE-Tag: 1781881168-454159
X-HE-Meta: U2FsdGVkX18vkaESsVAzZOzw6VH0Z2i4OOg7N3ngcp70xacG5VWvFSWBjJziP4MmlMN+8GlYzI1qQLghMSO4t0WmF6FrXwusEn4ISRwmOzAvqxH/Dc2XB3G6hx6hVbkD/RGraHTz0wFprEaNCqzKMyB0OIr8pofelfGyIShwA3LBNkcMhkDvTu9HimzAZeAl359zbOgK/T0nuUHbygv7bPXm4bABsrMmRaowuKOPEr8wif1grFIy4KLZk5dTwBZ1tpzaYEHPtFLuXPbluyXZdkjWVICRkLkY6cWX0enWMZQ4ay6OFsQ8SP5ZuSNwDsH614sIuDIAad4ggK5naEfGy3pI8D/wPELxpvMuwAyTRwmmx6tkTCK5Hy+QUdjqTVQU7C/2grurXyaOdnmaXkO9/bnxEmh5ELOW2zhwi/9eookSQ/M5UYTs9Lkk74Qf3oEVj0PSKffMvNYshC+qSIe0lt8q5UsiomnAP/zdgwy1JnVH0xq6/VAdRxjqJcAmkEwEoG1PNWNddCAUF42RvFZm+Hpj1y3jhcN+quh1WnBqg5qsohqGwFUxIpE6apaMpkXowxCMsjk3DIryph81meTZU3Wv/MNc52TzUjFmj2T2SqDPl2+yITaqTz5l3Z6rmWjjJQQYjBna97vXPEVlnCcp3RjHj+paTGATtAEx7nz2f9gx7Q58zb+g1tGwky99etpgzeCpLPfxXytj3FBpDAmrq77dF/ayXigM2z0Bgl/eiVqEbe9zSQ5HsFGY/2TTHW9QdXl+X0Gr7gPFx7GOfqyvpWhAxuUmwQ+HL5nC4QjqqNXhQlmuO4Bs3h8QmbVE7bLe3a456O63sTsaOmoJjQsjNP1MvmHyyhd2lgH/c25kYYrIUpurUA84b89NGk6zWfSURiSt9TWkpIrlh8N85J1FRWXcMgDQjWvgz4IpMO6iCG41lFF6FgJ4Qa/UV6SiqKhjo0VUC8pYJh/AgmBrmZq
 J5s5ZF8v
 d0MPMxbqTeqphahccw3WqF6mx1rJdEsvxH3cnGYC7NlAtMj0pRL/PVhvIP97rN+UgT/lZ1/ce6G6dQhqBqD0riSJKLxaOda4jbU6XnBzZO65tqy087XSq4bFbHzxXUbFpm6M+wXOLKBQXJEq2g5G5XpO9w6lAtrYcpDglKx6+Fw1a1n97MPOsGx3NJskbfyT/D4FD478+w+rHnEAd/XK1kpEXyviaXl7+Fo39iqTU8e2SLcs2t6Pcl4rq/qQaxqVs371KBHo9FnUc+mLYL4Uvl4S+QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Overview
========

This patch set introduces a new autotuning which allows to collapse
hot regions into hugepages.

Motivation
==========

Since TLB is a bottleneck for many systems[1], a way to optimize TLB
misses (or hits) is to use huge pages. Unfortunately, using "always"
in THP leads to memory fragmentation and memory waste. For this reason,
most application guides and system administrators suggest to disable THP.

Currently DAMON has DAMOS_HUGEPAGE, DAMOS_NONHUGEPAGE and DAMOS_COLLAPSE.
However, there is no way to tune the settings. It will collapse all the
hot regions that meet the access pattern. If the server is a bare metal
database or big data server, this will also lead to eventual fragmentation.

Additionally, currently THP is set globally. Ideally, there should be a
way to control which tasks can use huge pages.

Solution
========

DAMON has now a way to autotune some of the variables and adjust quotas
automatically, so that DAMON is fired only under the right circumstances.
It would be nice to have something similar, but for huge pages.

A new autotuning quota goal[2], damos_hugepage_mem_bp, is introduced,
which checks the huge page consumption to total memory consumption. This
new quota mechanism reuses current autotuning architecture.

In order to test this new mechanism, a sample module[3] was created, but
not included in this patch series, which demonstrates the use of huge
pages collapse autotuning.

Benchmarks
==========

Huge page collapse autotuning was tested in a physicial machine with
MariaDB 10.5.29 and sysbench as the benchmark framework.

The hugepage module was set up in the following way:

# echo 1000 > min_age
# echo 1000 > quota_percentage_hugepage
# echo $(pidof mariadbd) > taget_pid
# echo on > enabled

The goal was to achieve 5% of the total memory used as hugepage.
Since the database was not very big, we may not be able to achieve
high amount of huge pages per total memory consumption ratio.

The table below shows the memory consumption over time. Timestamp is in
second and the memory usage in is MBytes. Gaps in the timestamp means
that no changes in the hugepage consumption happened over that period
of time in MB. The total used memory is calculated as
mem_total - mem free. The huge page used is calculated as
huge_page_anon + huge_page_shmem + huge_page_file. The table also
shows the huge pages to total memory ratio.

Hugepage autotune benchmark:
+-----------+----------------+----------------+----------------------+
| timestamp | total mem used | huge page used | percentage hugepage  |
+-----------+----------------+----------------+----------------------+
| 0         | 3044.988281    | 0              | 0%                   |
| 22        | 3160.207031    | 2              | 0.06%                |
| 30        | 3250.90625     | 4              | 0.12%                |
| 69        | 3781.238281    | 6              | 0.16%                |
| 71        | 3822.226563    | 8              | 0.21%                |
| 72        | 3846.578125    | 10             | 0.26%                |
| 73        | 3852.402344    | 12             | 0.31%                |
| 74        | 3868           | 14             | 0.36%                |
| 75        | 3881.84375     | 104            | 2.68%                |
| 275       | 4194.175781    | 106            | 2.52%                |
+-----------+----------------+----------------+----------------------+
After second 275, no more pages are collapsed into hugepages


THP (always) benchmark:
+-----------+----------------+----------------+---------------------+
| timestamp | total mem used | huge page used | percentage hugepage |
+-----------+----------------+----------------+---------------------+
|         1 |    4489.320313 |            184 |         4.098615986 |
|        15 |    4581.871094 |            214 |         4.670580984 |
|        30 |    4757.742188 |            376 |         7.902908253 |
|        45 |    4937.574219 |            558 |         11.30109595 |
|        60 |    5147.867188 |            728 |         14.14177898 |
|        75 |      5407.0625 |            918 |         16.97779524 |
|        95 |    5668.796875 |           1040 |         18.34604455 |
|       105 |    5723.839844 |           1056 |         18.44915352 |
|       115 |     5736.84375 |           1072 |         18.68623317 |
|       125 |    5732.042969 |           1088 |         18.98101612 |
|       186 |    5753.601563 |           1184 |         20.57841488 |
|       246 |    5746.398438 |           1280 |         22.27482159 |
|       306 |    5752.128906 |           1376 |         23.92157795 |
|       367 |      5772.5625 |           1472 |         25.49994045 |
|       427 |    5832.019531 |           1568 |         26.88605536 |
|       488 |    5813.246094 |           1664 |         28.62428277 |
|       548 |    5807.621094 |           1760 |         30.30500736 |
|       598 |    5841.253906 |           1822 |         31.19193292 |
|       669 |    5982.160156 |           1854 |         30.99214918 |
|       931 |    5946.605469 |           1868 |         31.41287933 |
|       981 |    6020.207031 |           1896 |         31.49393352 |
|       991 |    5988.445313 |           1910 |         31.89475566 |
|      1011 |    5988.570313 |           1926 |         32.16126554 |
|      1032 |    6016.039063 |           1936 |         32.18064211 |
|      1575 |    6057.289063 |           1968 |         32.48978181 |
|      1606 |    6026.167969 |           2000 |         33.18858702 |
+-----------+----------------+----------------+---------------------+
I ignored some points to make the table shorter. Anyway, the amount
of memory consumption, total and huge pages, is a lot higher than
with DAMON hugepage autotuning.


Performance:
Baseline (no THP, module off) -> 18,162.45 transactions per second
Hugepage autotune -> 18,211.82 transactions per second (+0.27% improvement)
THP always -> 18,388.3 (+1.24%)
THP madvise -> 18,179.25 (+0.09%)

Improvement is due to lower TLB misses

Patches Sequence
================
Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
Patch 2 -> Module that demonstrates how to use
           DAMOS_QUOTA_HUGEPAGE_MEM_BP and DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
Patch 3 -> Document hugepage_mem_bp parameter

Changes from previous versions
==============================
v1[4] -> v2
  - Removed the sample module altogether, since it will
    increase maintenance costs[5]
  - Document hugepage_mem_bp in design.rst

RFC 4[6] -> v1
  - Renamed config to SAMPLE_DAMON_HPAGE, file to hpage.c and
    functions to damon_sample_hpage_...
  - Make the module depend on TRANSPARENT_HUGEPAGE, since
    the module will need some THP functions anyway
  - Removed documentation, since this is just a sample module
  - Removed DAMOS_QUOTA_HUGEPAGE_MEM_BP from
    damos_sysfs_add_quota_score
  - Added a short description of the module in Kconfig

RFC 3[7] -> RFC 4
  - Simplified the module
  - Removed unnecessary parameters
  - Renamed DAMOS_QUOTA_HUGEPAGE_MEM_BP to unify the
    naming style
  - Switched to DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
  - Updated the documentation
  - Removed new interface for context creation with
    DAMON_OPS_VADDR

RFC 2[8] -> RFC 3
  - Module moved to samples
  - Change autotune to monitor total memory and hugepage
  - Added performnace benchmarks to the cover letter
  - Bail out gracefully when trying to start disable
    the module after the monitored task exited. This
    issue was discovered by sashiko [9]
  - Fixed typos and added quota_sz to the documentation
    discovered by sashiko [10]

RFC 1[11] -> RFC 2
  - Rebased into mm-new
  - Use DAMOS_COLLAPSE instead of DAMOS_HUGEPAGE
  - Fixed an issue that returned silently an error when the PID
    didn't exist in the system.[12]

[1] https://dl.acm.org/doi/pdf/10.1145/3307650.3322227
[2] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
[3] https://lore.kernel.org/20260616150316.580819-3-gutierrez.asier@huawei-partners.com
[4] https://lore.kernel.org/20260616150316.580819-1-gutierrez.asier@huawei-partners.com
[5] https://lore.kernel.org/20260618150806.4633-1-sj@kernel.org
[6] https://lore.kernel.org/20260611150244.3454699-1-gutierrez.asier@huawei-partners.com
[7] https://lore.kernel.org/20260604150338.501128-1-gutierrez.asier@huawei-partners.com
[8] https://lore.kernel.org/20260522145518.158910-1-gutierrez.asier@huawei-partners.com
[9] https://lore.kernel.org/20260522171210.900B11F00A3D@smtp.kernel.org
[10] https://lore.kernel.org/20260522171633.AAF5B1F000E9@smtp.kernel.org
[11] https://lore.kernel.org/20260430134139.2446417-1-gutierrez.asier@huawei-partners.com
[12] https://lore.kernel.org/all/20260430154338.E22E6C2BCB3@smtp.kernel.org/

Asier Gutierrez (3):
  mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
  mm/damon/sysfs: support hugepage_mem_bp quota goal metric
  Docs/mm/damon/design: Document hugepage_mem_bp target metric

 Documentation/mm/damon/design.rst |  2 ++
 include/linux/damon.h             |  2 ++
 mm/damon/core.c                   | 14 ++++++++++++++
 mm/damon/sysfs-schemes.c          |  4 ++++
 4 files changed, 22 insertions(+)

-- 
2.43.0


