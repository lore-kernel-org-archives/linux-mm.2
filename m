Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D77C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DBD6B0088; Mon, 31 Aug 2026 10:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34E06B008A; Mon, 31 Aug 2026 10:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A717C6B008C; Mon, 31 Aug 2026 10:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74D776B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:47:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C435714016C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:47:43 +0000 (UTC)
X-FDA: 85161843606.29.7C6F60B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 482FB1C0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:47:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YVCZraL+;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788187662;
	b=fQuYzLCCAcMhHBDjjIdO3QNWejh3KqBCZuhTdgJByWBr6PIaCRz2wWuYTsPSAsMGTFwdYh
	J/xz/4KahF6VtIr+885BBtqsFIOFjv6ciOZDEO47HWq6ymT003/2iHakNVNhEt28neWeHF
	y4AIQwJto8eE8mNqM1c4RroU+bg9Kew=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YVCZraL+;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788187662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xhmwl9JHB2IkWqifzSdi9Ztd8FkooRsXdBNJtN34y6o=;
	b=eKNbsF9Wo3QpmJMy6u0pZ+RH09dSXamqjdaY8SIxsgjGTxuHoN0N3M5EUHZzj/rkChKN/E
	1Dva8xIrz9fA5/gQ2kduAXd85UbRaygkmNeYcUltckfmODhfnRLylvcPC84mEf6lGKpSIM
	+NqKpgronZeMmJhbf085TX2ctzsJC+I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDE95601FD;
	Mon, 31 Aug 2026 14:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5271F000E9;
	Mon, 31 Aug 2026 14:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788187661;
	bh=Xhmwl9JHB2IkWqifzSdi9Ztd8FkooRsXdBNJtN34y6o=;
	h=From:To:Cc:Subject:Date;
	b=YVCZraL+1CF3ljGPOXiXzPK12Y3o9O1PPUq8fd7+ZAZBjca4i+L6L8N9i285SQGew
	 Zo4E2VL5Qh658Ak63BYMbDrJy4l7a2nZ6wM6lZYT36QMkSmXK7FLw3IWPlNKk5ct+f
	 7hGxGuUOhSCd5yZAwd1LJh8tWNDEDL78GzTzDqv8aqbQjXUauQNlOpfIFWoqdgco5f
	 AFVc96jzCRxqrmvESToqlD8n/SAcfVtRAlS8yY5Bk/0gYH1X8z4pMa5vEFxlvdUIC7
	 2b4GzxTmVhDRyv48PXZ4QEnbIjpUHxtibpH9N6ZKKtnMpZQhCE5QLwx90pLtE73Ch8
	 8uU0Tw5wTifRg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Mon, 31 Aug 2026 07:47:27 -0700
Message-ID: <20260831144732.80910-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 482FB1C0003
X-Stat-Signature: ixtn6mn5hoh4acpbe7jxcnkupscznxdp
X-HE-Tag: 1788187662-35707
X-HE-Meta: U2FsdGVkX18d1PsKGcYwANCXVUbHHQJBT91uyTE/MLEm5yszL+YfQesGwxv93wfvqMArh3IPS4K/B6pklYYn/Dj9dwmVhdJgSxjsXWNBj4cNBIVrszt19d0XmpmIcGHFcHnX5HckccxkA17nPUnNbO6TRO19M/pHAxhovTYZ0CXsyICXD+YvTRjbzAzAmQnd8QJA/Q2q50BZTNQE/5OkKlMjtjuY0tylNo2KmZZ8TbetuT6wt/LHtY8vjicbf9R63BPqLeKZR9v2ObGRNNJZYn4ekHHoUgFvqy3acxk1qKKnK/cIHCjKUdmprnJzY70eI8PiQWN3CiVLfXaztytHjUvFc42gNNqkK0asQ40zQQ+HUC5YnrB9W25ZnNAV3FYVutucnM8rzLiC8TX4jy4BYzaxHc+altMPAxcdmZD/Bnry08VQVRssZdvaMwoL/dT9xqOdb8KyxMeMZl03p0BMJ/gtUzGlC+/Fp5rIaOrFV3vN09yTSFckNGm1km4lK12WCb8DjkZ8wUqb+lHEux5KaIeJWNRo7mSE2kZQPp8dZJJOU33fbhZLFwdetEHN4ancketA7eAMscVp1QhRAm+YRgNwEkn2gXmISRESNtxUXNXCz5S8+5b4dzz7sf0ZqdXQsSvqJQ89OC+IlpnAsE0pMg3hIwbairCxJ4/T0fhTQ+9BYbAQz+L+6V/yf+Sj8M9jE9Uoa+mdQPfK2AMHTrQRRHzqvBVNy/H6R+Tq1zPx6TY9Wo2NCnawqHwO2jX6STGSnrK8awjJfSdlgkfeP/5OTF1B6j5Ojrlt5aGgVkiQutieICr5gmVec6kZG2o2A4P3CItKS0rD2VbAzbgfq7ppaozPOpkezVP7CjkJ9oqO0UVLAz1oGK47zJpMpO4GgMqyhEMlAVR+UXRZWOujHz/GhKT5/TqCcc2PTHCnraKMzS/lxnMcVo/rZcgA2e9s0dxdtvs/B6cGOV/Dy0o1o5M
 tJnoe6cO
 C4t0gGIuB/Wb8J2K3dTeeUxXqxCaZspHtOhivsqISVBfhGjejd+kN1bWH6Br4VlrjMBqsLLIcBFlm6bdXHXyjDWDpJ2xnf2+3tWVmT/SMDdnkSsGCctNlOee07zOM+AJJryGTIX+WKUxsxZ9LJbfc/ouapOzKaqdqsZD4ae4ohmdAN3L5C8nXjWFEGpERRjeECjMhgp7urGwl+vyFjE8Fb2b6lD9MvuybsxqQb5Ds9KAcj/iaeV5I8Bb+R/U28Yb/z7vsG4yzclmSyLtEU7xpeDCzfuWD9nKiT0bnaPTnTGpG65rEPoto9shGt2nxXH6TuHNZlpwaAKVtPfNZBZ+EgcNY4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Overview
========
This patch set introduces a new autotuning which allows to collapse hot
regions into hugepages.

Motivation
==========
Since TLB is a bottleneck for many systems[1], a way to optimize TLB
misses (or hits) is to use huge pages. Unfortunately, using "always" in
THP leads to memory fragmentation and memory waste. For this reason,
most application guides and system administrators suggest to disable
THP.

Selective huge page collapse per process is possible using prctl and a
launcher. However, this does not solve the issue with hot region
detection.  Additionally, it the sysadmin should create a launcher that
uses PRCTL to enable THP for a particular process.

We can use the DAMON support for DAMOS_HUGEPAGE and DAMOS_COLLAPSE, to
target a certain process. DAMOS_COLLAPSE can also target the hot regions
in that process.

Still, there is an issue with the amount of huge page consumption. Since
huge pages can lead to memory fragmentation and waste, there should be a
way to limit the amount of huge page consumption. There is hugetlbfs,
but it requires changes to the application code or the use of
libhugetlbfs.

DAMON has now a way to autotune some of the variables and adjust quotas
automatically, so that DAMON is fired only under the right
circumstances.  It would be nice to have something similar, but for huge
pages.

Solution
========
A new autotuning quota goal[2], damos_hugepage_mem_bp, is introduced,
which checks the huge page consumption to total memory consumption. This
new quota mechanism reuses current autotuning architecture.

In order to test this new mechanism, a sample module[3] was created, but
not included in this patch series. To demonstrate the tool, damo user
space tool was modified[4], which sets up huge pages collapse
autotuning.

Benchmarks
==========
Setup: physical server with arm64 processor with 4 NUMA nodes, 1 TB RAM
and running mariaDB 10.5.29. Sysbench was used for the benchmark, with
20 tables and 3 million rows per table. The database was pinned to one
of the nodes, and the benchmark framework to a different node. No
network traffic involved in the benchmark.

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

<target> was 1000 to taget 10% hugepage to total memory ratio, or 2500
to target 25%. Tuner was also tested with consistent and temporal.

Results
=======
After the last timestamp, there was no change in huge page use, and the
total huge page to memory consumption ratio barely moved.

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

From this, we can conclude that the huge page autotuner works fine,
achieving the target. When using consistent autotuner, it actually
over-achieves the target, which is expected, since quota esz_bp is not
set to 0 to cap the DAMOS policy.

Patches Sequence
================
Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
Patch 2 -> sysfs support for the new quota goal
Patch 3 -> Document hugepage_mem_bp parameter

[1] https://dl.acm.org/doi/pdf/10.1145/3307650.3322227
[2] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
[3] https://lore.kernel.org/20260616150316.580819-3-gutierrez.asier@huawei-partners.com
[4] https://github.com/asierHuawei/damo/commit/79ae1a4ab1c012a7161db85a000d14f08fa36736
[5] https://lore.kernel.org/all/03f678dd-9ef3-4b97-b753-c2e4554c5159@huawei-partners.com/

Changes from previous versions
==============================
v3 -> v4
  - v3: https://lore.kernel.org/20260720120140.881468-1-gutierrez.asier@huawei-partners.com
  - Add R-b: from SJ.
  - Handle a per-cpu count race where free pages larger than total
    pages.
  - Return 10,000 as hugepage memory ratio for the racy corner case,
    instead of MAX_INT.
  - Wordsmith commit message.
  - Rebase to latest mm-new.
v2[6] -> v3
  - Reworked the cover letter to make more clean the intents, design
    choices and results.
  - Added a guard in damos_hugepage_mem_bp in order to avoid potential
    division by 0.[7]
  - Fixed a typo in the documentation.
v1[8] -> v2
  - Rebased onto updated mm-new
  - Removed the sample module altogether, since it will increase
    maintenance costs[9]
  - Document hugepage_mem_bp in design.rst

RFC 4[10] -> v1
  - Renamed config to SAMPLE_DAMON_HPAGE, file to hpage.c and functions
    to damon_sample_hpage_...
  - Make the module depend on TRANSPARENT_HUGEPAGE, since the module
    will need some THP functions anyway
  - Removed documentation, since this is just a sample module
  - Removed DAMOS_QUOTA_HUGEPAGE_MEM_BP from damos_sysfs_add_quota_score
  - Added a short description of the module in Kconfig

RFC 3[11] -> RFC 4
  - Simplified the module
  - Removed unnecessary parameters
  - Renamed DAMOS_QUOTA_HUGEPAGE_MEM_BP to unify the naming style
  - Switched to DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
  - Updated the documentation
  - Removed new interface for context creation with DAMON_OPS_VADDR

RFC 2[12] -> RFC 3
  - Module moved to samples
  - Change autotune to monitor total memory and hugepage
  - Added performnace benchmarks to the cover letter
  - Bail out gracefully when trying to start disable the module after
    the monitored task exited. This issue was discovered by sashiko [13]
  - Fixed typos and added quota_sz to the documentation discovered by
    sashiko [14]

RFC 1[15] -> RFC 2
  - Rebased into mm-new
  - Use DAMOS_COLLAPSE instead of DAMOS_HUGEPAGE
  - Fixed an issue that returned silently an error when the PID didn't
    exist in the system.[16]

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

Note to Andrew:
Footnote references 6-16 are only used for changelog.  Hence those can
be removed with changelog.

Asier Gutierrez (3):
  mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
  mm/damon/sysfs: support hugepage_mem_bp quota goal metric
  Docs/mm/damon/design: Document hugepage_mem_bp target metric

 Documentation/mm/damon/design.rst |  2 ++
 include/linux/damon.h             |  2 ++
 mm/damon/core.c                   | 19 +++++++++++++++++++
 mm/damon/sysfs-schemes.c          |  4 ++++
 4 files changed, 27 insertions(+)


base-commit: 0ae786fcfff4cfea3290e16a65fe12f5c99a6d2f
-- 
2.47.3

