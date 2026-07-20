Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80990C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77926B0099; Mon, 20 Jul 2026 08:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E025C6B009B; Mon, 20 Jul 2026 08:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43446B009D; Mon, 20 Jul 2026 08:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F94F6B0099
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:01:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A6BB4015D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:01:53 +0000 (UTC)
X-FDA: 85009016106.20.DE63EDD
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1AA2180010
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:01:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=THkjetyy;
	spf=pass (imf30.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784548911;
	b=aGN9xkTfOpE9xfHCIgTWfpXgGp8+6aD2rJFB9inuUuYQBKrUGsGwMt9P5SgWVcDFgvq7Ao
	U2n7EmSUTqlo0LOzP9Zh2mHb/aep1vGLL/hZySTdPZCS+LMeuFECzunyoogUexokgKsSM7
	KrpE32yxn3pBghYr6lhMdtjzY2gYI9Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=THkjetyy;
	spf=pass (imf30.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784548911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fxufxts4l0xop5qBFk1SYkKe79xL5E2Hzs1Xfk69AyE=;
	b=0UvUvrPp68kz5oJDFLhhrR1IJqlzBPtHG0qRTHe4hJoDzsgvxoDuh3jor/lvdBxYQE32cj
	nt/VLu787pFp2cesCnDFxRpD58wlxE9fM+/wGoVCkQWThczYpsvDNDODVCPSemMs9tRY8q
	aUIg+bnX7/9Uuq4Cz/FJUToXsBtUAak=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fxufxts4l0xop5qBFk1SYkKe79xL5E2Hzs1Xfk69AyE=;
	b=THkjetyynnM0NEAoCOEJiV4g8Jzwx9IyW4XK87MCEPy+zap5mrmJRa1Mq/inphPWNOq8dGXEG
	NxaJN4yqzDASOY7pF2j9l+77ohtqm5zcjQwVIRCG/cLyXbelOE6DRz7yOGGJ3l5QPK+FJ+E/hFt
	D9HVPV8WhsiC+uYanQn13EI=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h3fHn2p1KzJ467w;
	Mon, 20 Jul 2026 20:01:25 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D794040570;
	Mon, 20 Jul 2026 20:01:43 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Jul 2026 15:01:43 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Mon, 20 Jul 2026 12:01:37 +0000
Message-ID: <20260720120140.881468-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1AA2180010
X-Stat-Signature: zetzfi1g8smnjxdoxkzdwjy8zb935thn
X-Rspam-User: 
X-HE-Tag: 1784548910-608596
X-HE-Meta: U2FsdGVkX1+2oa2RGVAHcQlmK6geYJumjzINkjZEYGPAUYpXT2XpZv7pShvHKYNKBEgnVtndqKDad108J5EtjlbZsgFFLo52lUfbGHP2Ba4e7M2GU4sVWatQLo4rUle9lMn/oigSre4WDLqVvYo8dkSB/nJf7Hkg3DNvpDSlcOHWcRswNcmICPKmPPx+QRdDtRcm77bdJ5PBOyUCt5DiLSDilY3A7eebWUjln2X+k0FmFUxADW1SFi1dQWBhwnT5EwJNK9VhQ8BIUflL5gtdi7T6z2Z4xXbUB8JOA8VVje/AhtvbdutrLDCDsyJKZGESQkKpaBfXhTrWqoFE7PIm2BvauAbU25XDrHfOZD9yE03iWn2ZyzaUh2k8V+ErGY6EAO/1/6txDF39WAPM1YPIx+KF8krL4UAADJdY0RS4biCiGXUVll8D/FfAmVG3W3NV8+l4qRXoasRqg3Vh68itHvDQ02bkoiJiOMyfnLrrpO7bQLUohynsQg0raSnoZBN4mIeaRWNQPRRxk+6t8HWA4PAG8b5l9jIxXNqCg/M6WzMLvoJTgVQkPSDF3zGRdAhUGRQhrRaD2NyRcUj3BxMpqjpuZazMWeWqkNHQCavd/V4ZnLS1Y2i+d8e08lw4PPHWU8V0FYjWGE1dkQdQM78SDe2vaIwyzn49MgC7/qZtCtVanzkZfIDAKuyOT0bQpfF8aJGmfnqovMQRr+8qCgfQMd/KioSoTmggdrHR1mHo2AJaT/L/qMawIgvvV76JBOcCLEL7XtKn7+UJC4J/aavf4fDV3YTJiOWAAEFbutPTguqteq/xcE6VKx3VpEOHA2qDuGzDW59lfj0pILQKJ60NxZtIkgn4Xe+gGAU3XFvnzStplCOPjdhvU+oTMj7pxgLi2Rx728wKtMnGs3kseEm7vuc7pvm4NOYDkP0UOJ9+xCpJxDiow7lw3I2YVph/NReU5g5ozlEPq/4JwQ6pFLS
 gpMuynoI
 tryTGAgM8hTFnGR+BIywTBeLW2F/TZO7iTrhl0abU77nFF/NoOBwEFXkpRoX3LV7GCbwhFSB2NlSWYn5nmbha1rNHraE13hvfVxM9N+Kf7PJscyZuE0fdAR6xm+IljLXNMZuBpdu0G76ho1roUUMZaqEyS1aeRNA3ahnSkwSzBivh3yh2vg1pQGew4sk/Chr1VpScHWbmOHTIBQo+KuoHRLmt2k/JRgbMOwPlsxOibWON/ar+cOQqLH3g/r0VqIPmrocMSHkLSi6ma5gcrX7X/HDBuZigwBYt+Y9qX0mkRKDMdTiHNqIG70QzqSR7OY8u04rLWad2wTs30LfUKeux+xjD3SfaiYF6PJyowFBCAkNzmZtKbizb+o1e7XugRXWWAz4EFDHEm7Sam/0nywnhuKC8V0FvQ/hSLE4xMSULPW2XeZw=
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

Selective huge page collapse per process is possible using prctl and a 
launcher. However, this does not solve the issue with hot region detection.
Additionally, it the sysadmin should create a launcher that uses PRCTL to
enable THP for a particular process.

We can use the DAMON support for DAMOS_HUGEPAGE and DAMOS_COLLAPSE, to
target a certain process. DAMOS_COLLAPSE can also target the hot regions in
that process.

Still, there is an issue with the amount of huge page consumption. Since
huge pages can lead to memory fragmentation and waste, there should be a
way to limit the amount of huge page consumption. There is hugetlbfs, but
it requires changes to the application code or the use of libhugetlbfs.

DAMON has now a way to autotune some of the variables and adjust quotas
automatically, so that DAMON is fired only under the right circumstances.
It would be nice to have something similar, but for huge pages.

Solution
========
A new autotuning quota goal[2], damos_hugepage_mem_bp, is introduced,
which checks the huge page consumption to total memory consumption. This
new quota mechanism reuses current autotuning architecture.

In order to test this new mechanism, a sample module[3] was created, but
not included in this patch series. To demonstrate the tool, damo user
space tool was modified[4], which sets up huge pages collapse autotuning.

Benchmarks
==========
Setup: physical server with arm64 processor with 4 NUMA nodes,
1 TB RAM and running mariaDB 10.5.29. Sysbench was used for the
benchmark, with 20 tables and 3 million rows per table. The database
was pinned to one of the nodes, and the benchmark framework to a
different node. No network traffic involved in the benchmark.

Damo user space tool was forked and hugepage_mem_bp support added[4].

DAMON was lauched using this command line:

sudo ./damo start $(pidof mariadbd) \
--monitoring_nr_regions_range 10 1000 \
--monitoring_intervals 5000 100000 60000000 \
--damos_quota_time 0 --damos_quota_space 128000000 \
--damos_quota_interval 1000 \
--damos_quota_weights 0 1 1 \
--damos_quota_goal hugepage_mem_bp <target> \
--damos_quota_goal_tuner temporal \
--damos_apply_interval 50000 \
--damos_access_rate 0 max --damos_age 50 max \
--damos_action collapse --debug_damon

<target> was 1000 to taget 10% hugepage to total memory ratio, or
2500 to target 25%. Tuner was also tested with consistent and
temporal.

Results
=======
After the last timestamp, there was no change in huge page use, and
the total huge page to memory consumption ratio barely moved.

hugepage_mem_bp: 1000
goal tuner: temporal

+-----------+----------------+----------------+----------------------+
| timestamp | total mem used | huge page used | percentage hugepage  |
+-----------+----------------+----------------+----------------------+
| 0         | 16945.04297    | 0              | 0                    |
| 7         | 17008.69531    | 74             | 0.435071583          |
| 8         | 17036.40234    | 194            | 1.138738074          |
| 9         | 17017.01563    | 314            | 1.845211916          |
| 10        | 17029.67969    | 434            | 2.548491856          |
| 61        | 17111.30859    | 584            | 3.412947623          |
| 120       | 17071.05859    | 694            | 4.065360072          |
| 180       | 17133.88281    | 804            | 4.692456513          |
| 203       | 17088.16406    | 916            | 5.360435426          |
| 204       | 17126.34766    | 1046           | 6.107548562          |
| 205       | 17093.84375    | 1176           | 6.879669764          |
| 206       | 17142.77734    | 1298           | 7.571701913          |
| 209       | 17149.17969    | 1686           | 9.831374041          |
| 210       | 17097.30859    | 1754           | 10.25892462          |
+-----------+----------------+----------------+----------------------+

hugepage_mem_bp: 1000
goal tuner: consistent

+-----------+----------------+----------------+----------------------+
| timestamp | total mem used | huge page used | percentage hugepage  |
+-----------+----------------+----------------+----------------------+
| 0         | 16955.24609    | 0              | 0                    |
| 34        | 17039.71875    | 106            | 0.622075995          |
| 78        | 17009.47656    | 554            | 3.257007927          |
| 90        | 17048.92188    | 596            | 3.495822225          |
| 150       | 17092.90625    | 706            | 4.130368409          |
| 180       | 17053.08984    | 764            | 4.480126517          |
| 233       | 17100.50391    | 1496           | 8.748280216          |
| 239       | 17098.89063    | 2216           | 12.95990511          |
| 240       | 17135.44531    | 2334           | 13.62088908          |
| 245       | 17132.55078    | 2932           | 17.11362212          |
| 246       | 17117.95313    | 3052           | 17.82923448          |
| 250       | 17163.12109    | 3532           | 20.57900763          |
+-----------+----------------+----------------+----------------------+

hugepage_mem_bp: 2500
goal tuner: temporal

+-----------+----------------+----------------+----------------------+
| timestamp | total mem used | huge page used | percentage hugepage  |
+-----------+----------------+----------------+----------------------+
| 0         | 17010.31641    | 0              | 0                    |
| 9         | 17063.6875     | 50             | 0.2930199            |
| 10        | 17051.75781    | 170            | 0.996964664          |
| 60        | 17133.85547    | 572            | 3.338419663          |
| 90        | 17192.07813    | 626            | 3.641211932          |
| 120       | 17221.44531    | 682            | 3.960178647          |
| 181       | 17199.76172    | 790            | 4.593086886          |
| 208       | 17222.77734    | 1206           | 7.002354939          |
| 214       | 17245.17969    | 1904           | 11.04076637          |
| 215       | 17240.45703    | 2024           | 11.73982799          |
| 220       | 17234.79688    | 2624           | 15.22501262          |
| 228       | 17222.83594    | 3584           | 20.80958103          |
| 231       | 17247.55469    | 3944           | 22.86700968          |
| 235       | 17229.37109    | 4424           | 25.67708349          |
+-----------+----------------+----------------+----------------------+

hugepage_mem_bp: 1000
goal tuner: consist

+-----------+----------------+----------------+----------------------+
| timestamp | total mem used | huge page used | percentage hugepage  |
+-----------+----------------+----------------+----------------------+
| 0         | 17125.85156    | 0              | 0                    |
| 38        | 17081.23438    | 76             | 0.444932716          |
| 39        | 17133.11719    | 196            | 1.143983304          |
| 40        | 17119.83984    | 316            | 1.84581166           |
| 60        | 17109.72656    | 554            | 3.237924335          |
| 90        | 17164.11328    | 628            | 3.65879664           |
| 180       | 17177.66016    | 792            | 4.610639591          |
| 220       | 17180.86719    | 1378           | 8.020549749          |
| 226       | 17187.82031    | 1980           | 11.51978531          |
| 233       | 17143.48438    | 2818           | 16.4377319           |
| 240       | 17137.38281    | 3656           | 21.33347921          |
| 250       | 17175.5        | 4856           | 28.27283049          |
| 260       | 17199.66406    | 6056           | 35.20999002          |
| 270       | 17203.98438    | 7254           | 42.16465118          |
| 275       | 17207.21875    | 7762           | 45.10897498          |
+-----------+----------------+----------------+----------------------+

More detailed tables are provided here[5]

From this, we can conclude that the huge page autotuner works fine, achieving
the target. When using consistent autotuner, it actually over-achieves the
target, which is expected, since quota esz_bp is not set to 0 to cap the
DAMOS policy.

Patches Sequence
================
Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
Patch 2 -> sysfs support for the new quota goal
Patch 3 -> Document hugepage_mem_bp parameter

Changes from previous versions
==============================
v2[6] -> v3
  - Reworked the cover letter to make more clean the intents,
    design choices and results.
  - Added a guard in damos_hugepage_mem_bp in order to avoid
    potential division by 0.[7]
  - Fixed a typo in the documentation.
v1[8] -> v2
  - Rebased onto updated mm-new
  - Removed the sample module altogether, since it will
    increase maintenance costs[9]
  - Document hugepage_mem_bp in design.rst

RFC 4[10] -> v1
  - Renamed config to SAMPLE_DAMON_HPAGE, file to hpage.c and
    functions to damon_sample_hpage_...
  - Make the module depend on TRANSPARENT_HUGEPAGE, since
    the module will need some THP functions anyway
  - Removed documentation, since this is just a sample module
  - Removed DAMOS_QUOTA_HUGEPAGE_MEM_BP from
    damos_sysfs_add_quota_score
  - Added a short description of the module in Kconfig

RFC 3[11] -> RFC 4
  - Simplified the module
  - Removed unnecessary parameters
  - Renamed DAMOS_QUOTA_HUGEPAGE_MEM_BP to unify the
    naming style
  - Switched to DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
  - Updated the documentation
  - Removed new interface for context creation with
    DAMON_OPS_VADDR

RFC 2[12] -> RFC 3
  - Module moved to samples
  - Change autotune to monitor total memory and hugepage
  - Added performnace benchmarks to the cover letter
  - Bail out gracefully when trying to start disable
    the module after the monitored task exited. This
    issue was discovered by sashiko [13]
  - Fixed typos and added quota_sz to the documentation
    discovered by sashiko [14]

RFC 1[15] -> RFC 2
  - Rebased into mm-new
  - Use DAMOS_COLLAPSE instead of DAMOS_HUGEPAGE
  - Fixed an issue that returned silently an error when the PID
    didn't exist in the system.[16]

[1] https://dl.acm.org/doi/pdf/10.1145/3307650.3322227
[2] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
[3] https://lore.kernel.org/20260616150316.580819-3-gutierrez.asier@huawei-partners.com
[4] https://github.com/asierHuawei/damo/commit/79ae1a4ab1c012a7161db85a000d14f08fa36736
[5] https://lore.kernel.org/all/03f678dd-9ef3-4b97-b753-c2e4554c5159@huawei-partners.com/
[6] https://lore.kernel.org/all/20260714150116.382521-1-gutierrez.asier@huawei-partners.com
[7] https://lore.kernel.org/all/20260715151615.99767-1-sj@kernel.org/
[8] https://lore.kernel.org/20260616150316.580819-1-gutierrez.asier@huawei-partners.com
[9] https://lore.kernel.org/20260618150806.4633-1-sj@kernel.org
[10] https://lore.kernel.org/20260611150244.3454699-1-gutierrez.asier@huawei-partners.com
[11] https://lore.kernel.org/20260604150338.501128-1-gutierrez.asier@huawei-partners.com
[12] https://lore.kernel.org/20260522145518.158910-1-gutierrez.asier@huawei-partners.com
[13] https://lore.kernel.org/20260522171210.900B11F00A3D@smtp.kernel.org
[14] https://lore.kernel.org/20260522171633.AAF5B1F000E9@smtp.kernel.org
[15] https://lore.kernel.org/20260430134139.2446417-1-gutierrez.asier@huawei-partners.com
[16] https://lore.kernel.org/all/20260430154338.E22E6C2BCB3@smtp.kernel.org/

Asier Gutierrez (3):
  mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
  mm/damon/sysfs: support hugepage_mem_bp quota goal metric
  Docs/mm/damon/design: Document hugepage_mem_bp target metric

 Documentation/mm/damon/design.rst |  2 ++
 include/linux/damon.h             |  2 ++
 mm/damon/core.c                   | 21 +++++++++++++++++++++
 mm/damon/sysfs-schemes.c          |  4 ++++
 4 files changed, 29 insertions(+)

-- 
2.43.0


