Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE3CCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442226B0095; Thu, 11 Jun 2026 11:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3308D6B0093; Thu, 11 Jun 2026 11:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247486B0095; Thu, 11 Jun 2026 11:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1584D6B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:03:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D00E2C2581
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:03:45 +0000 (UTC)
X-FDA: 84867951210.04.21D2BA0
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id E018A8000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:03:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf02.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781190224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=2Fse+o4T1Pc/3qZX74UMOJlveQtCm0Vy3dnfVGikXUo=;
	b=BZYsIua7pE+4gt/VEifoVM0RqTYQLDik46WHbWrc17VCip2t+oU8j369pLG8Z37y/y5KJM
	tehcXnGHAo4pa7yyvwRnwUTkDuw+F0n2oG8+6kJ3HdmdYMCPaMa7/yMrVoKL4JHBpVWkf8
	u/FoSg6RRk4S2/1t6Cudv7U3Oi6sfWE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf02.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781190224;
	b=1xVtrxc3q1GinoaouH7cB6e7MLaJxZQP+mkBoqJb4hKxVnINQxFCaNY690A44apj6z944N
	GTcF1bU2aBPCvr6Iv8YoyOyEFdlHVpKcyJA/zW0XPnW5ISonffXiZDG+l+wJXy5ga/H0mJ
	CIZqxMFqY2+hgCTRn7kLi+PwjzuAgMc=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gbm9l00MfzJ467c;
	Thu, 11 Jun 2026 23:03:22 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 405AD40569;
	Thu, 11 Jun 2026 23:03:38 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Jun 2026 18:03:37 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 0/4] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Thu, 11 Jun 2026 15:02:40 +0000
Message-ID: <20260611150244.3454699-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E018A8000B
X-Stat-Signature: fihu3mtxj56q1zbxwk569dobdogkhsgk
X-Rspam-User: 
X-HE-Tag: 1781190223-803658
X-HE-Meta: U2FsdGVkX1+y4hywmnUuYNvxNDkPoaoDWrZg9JADIpF7cggs3vc88GT8ceilDdTujrXe/mJkCfyrUqYwOOaY0ryL00B362DiFDQXKCZ4U7/KfSv1sYQP8eiq6PFa2cgxmn3EBPqVVYXM7N2RRGSMQ5xtb478qn/r/vPQVVEVOkQSe7yueXMyJxtIkyg33llVfkO8cryPKlXAiLLoFX/87U3cvd1T83kSffQ29qiYZ3c0HlQONsa6Aj2XcWGIOXFP865OxbWb726h+on2xf4+IpVmgbAtXeEig6pqOADuwM0u6R2ErNjwVhdcaPjhTCApxC88bnQksQd6cPqVjTKqPJ6nZXkr807ZBMCQ2t93lQBzH0k8XqSyQwUPw3cm/sJ0k5NAKgcNADQqJoPRm0HY9vjlr6mVdkhaCC5zZ2VfhqssCrZuPU0iG2+58D6Lvd71DWTYmgnvYRDBDAsk1WZh67rf+vvwrM2BBWk7F7cYAdBORqhFPIwmV3fbd/sI0C0nqWFJIQKDSJosPB7LeqJgWm7f8Yb3X2P0ceN+KeVpA9H5WQlrhiY2zps+3fOvs2VoJps9wLZ/EN3LT5sDj0wOmYIspBSF5G0rRr+P4kB1kgpsnZWFACzuYV9rl02XpLzm7UsQJoZ+vDF+alUUEkOx/GCbzeIn9aEmjIu1qR9umFEWRK+Il94/GXe8SfQat72N33UTjqieEYvi/TkuFZbYfgxXMj7lEvS8NAPCHq4qayyFbhwUS4qTjL1Kv1UYcfvjwFN5qg3ZoAyjOVN2BE9V2G+e7aY1CED9hPUnzK16bT0ShUSU7ts58VxhY9gLKCHbwiCzR9TK+10ICd1PLJYVh3gs+SVUukak6E8hI6imJ6MXzWNC+9hf5dxIyqQZ9KyFm7F6MYq6QekEg5rVKx7ject3QpXnNb/iMXzoBd+bfPsGIdc296UMUSn2cD2JL/BAUWHFGZqE2WS4abKR8Jc
 KYvF5mMw
 d6j3zXW64GCs4lGBUvZltCgkCeAGmt7850YanNIPOAdcverALeO7A+dN5wsJnYOQAR1pHn9KGHVnAhf+c4NGMK3TrgIu/kGAkaco5tfVQl0nLVgwMaXn48pjP1ThfPxtFbpCm/3d8Wm2wcPGDegbPFqC5H58rzOWFJ1nVIhcx43wG10eOAFbeUpIsJKckyZDhOLHwlYrMAwXM+GYFVB5htigb7PHKp6QYjobUgPnKxDZCMEHPGjfstJuCQE9XS0uevmVoKamxG3/XcZbzTkwS7nq36g==
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

A new module is introduced to demonstrate the use of huge pages
collapse autotuning. The goal is to collapse hot regions of a given
process into huge pages. The module launches a kdamond thread for a
certain task provided by the user through monitored_pid module argument.
Hugepage goal autotuning will automatically adjust the aggressiveness
of hot region collapses.

This module also has a user autotuning knob which allows the user to
adjust the aggressiveness of page collapsing.

Benchmarks
==========

Huge page collapse autotuning was tested in a physicial machine with
MariaDB 10.5.29 and sysbench as the benchmark framework.

The hugepage module was set up in the following way:

# echo 1000 > min_age
# echo 1000 > quota_percentage_hugepage
# echo $(pidof mariadbd) > monitored_pid
# echo on > enabled

The goal was to achieve 5% of the total memory used as hugepage.
Since the database was not very big, we may not be able to achieve
high amount of huge pages per total memory consumption ratio.

The table below shows the memory consumption over time. Gaps in the
timestamp means that no changes in the hugepage consumption happened
over that period of time in MB.

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

Performance:
Baseline -> 18,124.1 transactions per second
Hugepage autotune -> 18,163.64 transactions per second

TODO
====
- Support page splitting for cold hugepages.

Patches Sequence
================
Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
Patch 2 -> Module that demonstrates how to use
           DAMOS_QUOTA_HUGEPAGE_MEM_BP and DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
Patch 3 -> Support for DAMOS_QUOTA_HUGEPAGE_MEM_BP in sysfs-schemes
Patch 4 -> Documentation

Changes from previous versions
==============================
RFC 3[3] -> RFC 4
  - Simplified the module
  - Removed unnecessary parameters
  - Renamed DAMOS_QUOTA_HUGEPAGE_MEM_BP to unify the
    naming style
  - Switched to DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
  - Updated the documentation
  - Removed new interface for context creation with
    DAMON_OPS_VADDR

RFC 2[4] -> RFC 3
  - Module moved to samples
  - Change autotune to monitor total memory and hugepage
  - Added performnace benchmarks to the cover letter
  - Bail out gracefully when trying to start disable
    the module after the monitored task exited. This
    issue was discovered by sashiko [5]
  - Fixed typos and added quota_sz to the documentation
    discovered by sashiko [6]
RFC 1[7] -> RFC 2
  - Rebased into mm-new
  - Use DAMOS_COLLAPSE instead of DAMOS_HUGEPAGE
  - Fixed an issue that returned silently an error when the PID
    didn't exist in the system.[8]

[1] https://dl.acm.org/doi/pdf/10.1145/3307650.3322227
[2] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
[3] https://lore.kernel.org/20260604150338.501128-1-gutierrez.asier@huawei-partners.com
[4] https://lore.kernel.org/20260522145518.158910-1-gutierrez.asier@huawei-partners.com
[5] https://lore.kernel.org/20260522171210.900B11F00A3D@smtp.kernel.org
[6] https://lore.kernel.org/20260522171633.AAF5B1F000E9@smtp.kernel.org
[7] https://lore.kernel.org/20260430134139.2446417-1-gutierrez.asier@huawei-partners.com
[8] https://lore.kernel.org/all/20260430154338.E22E6C2BCB3@smtp.kernel.org/

Asier Gutierrez (4):
  mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
  mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
  mm/damon/sysfs: support hugepage_mem_bp quota goal metric
  Documentation/admin-guide/mm/damon: add DAMON-based Hugepage Management

 .../admin-guide/mm/damon/hugepage.rst (new)   | 113 ++++++++++
 Documentation/admin-guide/mm/damon/index.rst  |   1 +
 include/linux/damon.h                         |   2 +
 mm/damon/core.c                               |  14 ++
 samples/damon/Kconfig                         |  12 +
 samples/damon/Makefile                        |   1 +
 samples/damon/hugepage.c (new)                | 207 ++++++++++++++++++
 7 files changed, 350 insertions(+)
 create mode 100644 Documentation/admin-guide/mm/damon/hugepage.rst
 create mode 100644 samples/damon/hugepage.c

-- 
2.43.0

