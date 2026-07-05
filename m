Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26EFEC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C341B6B00A0; Sun,  5 Jul 2026 16:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEBA26B00A2; Sun,  5 Jul 2026 16:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFBB16B00A1; Sun,  5 Jul 2026 16:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7730D6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:57:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2BEAC0B51
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:55 +0000 (UTC)
X-FDA: 84955934910.08.41DA7E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 59EC9A0003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMENlORB;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285074;
	b=Ocotc/FHoQKBjguT99ZE0mQ1eESFDheaMlPuzGRz4CWuwyk8lclD+WsRhw4yENt2MC+xGA
	hmqS6dn7P3xVKUnL909cr3K+t2hTYnaAdKsYwRP03Fz72zyQ9/4gTO2S/D5HUrqIESyqIo
	1aWYEumobvPULU7Ch4xYAqll9q8pyfg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMENlORB;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ljhXdB25UIMpi4HZYViOqTzfk2jkh8D136DetA33OqU=;
	b=Ey9F4w0NMis6K7V/rEcWwV79AFvVueTry/CGM7xfFxU3p2Yy77QqItWatNMwaQ4LIr8I6Z
	0b/x+iWtS0ukAU3qROta1jo8iaiNA2ihQ02gfEZ04UOePRm6KrKyBQOxU3MG5eBoLo/uie
	tyif1WsT3nxWFeQZjh401Adr7gNzrBI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C40B460018;
	Sun,  5 Jul 2026 20:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00391F000E9;
	Sun,  5 Jul 2026 20:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285073;
	bh=ljhXdB25UIMpi4HZYViOqTzfk2jkh8D136DetA33OqU=;
	h=From:To:Cc:Subject:Date;
	b=kMENlORBAwN/Tz4JK1FTBBlzpKfdbs6G0jbL+oKxWxOEnoCvPGvHKGaDvBLa3bzz7
	 fE9fikj1I+lwqpNRkhXUobSb/eNp0wVug0Cvd2bFHyG0RaJ2aHQ8hUjet8PgH0ZGts
	 W/6Pu/WBw5do4XFu4IOfew6awh9GBvhVJqqNfgRDI6V3FPtS7/zhUaOpFJ6i2zKfWw
	 mRxiktuQ+SGqm0ZpTYIFXO/NUQoG0CeI3fESubunWFIOILBBtsjwS06OjMFL6KqHq1
	 mhOlP/rT44jvZv4SsfzhHRR641V3q8i5Koyi2Ipd368urehsD/LBSWyHT5mYXCT8Dn
	 FJnxFlr1zq8yg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 00/16] mm/damon: introduce data attributes only monitoring
Date: Sun,  5 Jul 2026 13:57:22 -0700
Message-ID: <20260705205743.98656-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59EC9A0003
X-Stat-Signature: 8nqh9fk13wkbezkz4ps5c83wmoqf5qxc
X-HE-Tag: 1783285074-13291
X-HE-Meta: U2FsdGVkX1/3Ycf+82NySqdnX2psAa2YHeAlbIdKl5xVRIqDf/tAvBrHx23QvkLe7ktmv1YafRfEVHFyLii4Wa3kyax8aGMBRcEVUrma79kmfmSGDrA7jAi+ENcAeQLgs794/MQIRyL7cxmRtr1JcE4PHHhVJu90v8XI6Y3j5Pm/C/EBqf6GFbwy77ze1IvMOth/TU1YxFFuSUws49golilLs3lhe5ZIl11zUNu6axD2xG723YJKDygcaXTPI+gD3LUA5s//5Tf5SWKO43VGAb3MwDiRBJ01B0FyofOhR2K2P5Q7Tf2yG0EqwxFef+Qd6JW9WuSqeTitDKdTFoGfLLEwmWsXH6NvAAhljsJTu4bhW02Q/LwJg1KDU1TNUoJZtDWgFTUQzQmzU3TImnGqzh5usNBjhOnEJY8cIVG7YdxFEsNxqZyUC+zlLiiE9EI3ew3Q3OpOuz3u7etTmj4cvYrgBnkcD/wWeLdvbIv3mYMsSeKIod6IUKq9hPgeVajAdcDhiBfr4wizQXl19m9ysdjVaYYKkY3qGS31L0p2nkRoaP/hVutxEfX2ivmWy48LqVw3tJRbPW3Hmra9tzu/Zi0KZ48x/GMX1V8ANd2iJmuXAekjjizUuCp33k5V2fe/6Qq9QiZ8rgfNgCPrXd/hU9NTxw2bavgVBtrWjsSpCVnmi1nJql9bkE0aL8TluxSVCfLnWXef24XCkhM0UGmDcSny91pIDNi+OuCFQYRIbLT0Ft88orp6/+5PXyf6/HdP4u0/q+j9B44JJhEbWFFV1tbbuBQC+ukz5+9r2pmRsw5wcz3AjwLwynQbOsUGERMynZO+0jHL01HYzQpBK5wiHLxVGoHjSx+jN/DIfVL5gl8LRITe/fYkayYqwjdLXBzND2IzbhupUq+qOpwn8Cxo8O9d4Xc8BT5o3p1ZtEga40sTAo5JTL09KAjoZ9N0QCyqE1HK39yT6XiSj1Qwcsy
 uMdj/sKx
 9LS77EIED63I8N+BRGq38YGGtNLpx/0r/1IQ31zhuMTefFBhIpKJQwKij/KHXC5VKSGXmW+KuzGGSRk7tDZiieAQ/EC2A1zmfMjnfuxpB1RXF6ZT0vnsngAtLZqLl66ocxuU/qVAarQyfd8humpI7qN75nvNJrMLbjwO2FSB78rlU1GF1E5uZQUXuS12/5qwCv+F3Dkhif8aFyMoWflL4jaPohASM4G8rq5mYafYipQsXvZPh1nScEsNDRBEmjJiHAMAq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR: Introduce a way to get DAMON's best effort accuracy monitoring of
user-demanding non-access data attributes.

Background
==========

DAMON was initially designed for only access monitoring.  It turned out
users want to get the information together with more data attributes.
For example, some users want to know how much of a hot memory region
belongs to huge pages or specific cgroups.  Page level properties based
monitoring was introduced with commit 626ffabe67c2 ("mm/damon: clarify
trying vs applying on damos_stat kernel-doc comment") to fill the gap.
Because it works only at snapshot level and snapshot capturing in the
mode can induce high overhead, commit 45c49d9fd608 ("mm/damon/core:
introduce struct damon_probe") introduced data attributes monitoring.

Data attributes monitoring treats the attributes as only additional and
subordinate information.  Data access monitoring is always turned on,
and regions are adjusted for best accuracy of the access information. In
some cases, users may be primarily interested in the attributes more
than the access.  They might even not care about the access information
at all.  Because DAMON treats data accesses as the only primary
information, such users cannot get high quality attributes information.

Design and Implementation
=========================

Introduce another way for treating data attributes as the primary
information.  Add 'weight' property to each data attribute probe.  When
any of the weights are set, the mode is enabled.  Data access monitoring
is completely turned off in the mode.  For region  adjustment, the
weighted sum of probe hit counters is used instead of the nr_accesses.

Using the weights, users can specify to what attributes they are
interested in to what degree.  DAMON will adjust the regions and provide
the best-effort quality monitoring that is optimized for the user
demands.

Extend damon_operations for efficient use of probe hits.  Update regions
merge and kdamond main logic to support the new mode.  Add a new struct
field and a sysfs file for API callers and ABI users, respectively.

Test
====

On ~7 GiB memory idle system, run a simple AI-assisted program.  The
program allocates and faults 2 GiB anonymous pages.  Then, it does
nothing but wait until the user terminates it.  Hence, the system ~2 GiB
of anonymous pages with no active accesses.

Monitor the distribution of the anonymous pages using DAMON attributes
monitoring mode, using DAMON user-space tool, damo [1].

    $ sudo ./damo start --probe_filter allow anon
    $ sudo ./damo report access --dont_merge_regions
    heatmap: 00000000000000000000000000000000000000000000000399999995111111146666666666666666
    # min/max temperatures: -2,470,000,000, -1,620,000,000, column size: 99.800 MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    #   <start>      <size>       <freq> <age>         <probe hits>
    0   4.000 KiB    79.840 MiB   0 hz   24.700 s      2
    1   79.844 MiB   718.562 MiB  0 hz   24.700 s      8
    2   798.406 MiB  793.148 MiB  0 hz   24.700 s      7
    3   1.554 GiB    797.828 MiB  0 hz   24.700 s      7
    4   2.333 GiB    794.668 MiB  0 hz   24.600 s      8
    5   3.109 GiB    791.117 MiB  0 hz   24.500 s      0
    6   3.882 GiB    785.312 MiB  0 hz   24 s          2
    7   4.649 GiB    787.867 MiB  0 hz   16.200 s      6
    8   5.418 GiB    784.477 MiB  0 hz   23.300 s      6
    9   6.184 GiB    783.820 MiB  0 hz   18.200 s      9
    10  6.950 GiB    797.730 MiB  0 hz   18.900 s      7
    11  7.729 GiB    69.625 MiB   0 hz   18.900 s      0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

Note that the line after the line starting with "intervals:" is not
provided by the current version of 'damo'.  I manually added the legends
line for easier understanding of these results.

Each of the 12 lines after the legend line shows the DAMON-found
regions.  Each line shows 1) index of the region, 2) start address of
the region, 3) size of the region, 4) access frequency of the region, 5)
age (how long the access frequency on the region was kept) of the
region, and finally 6) the probe hit count.

Because data access is the primary information that adjusts region for,
and there is only nearly zero access on the system, regions are naively
adjusted with the same size.  Still <probe hits> show different
distribution of the anonymous pages, but it is obviously very rough
information.

Switch to the attributes only mode and show how it changes the picture:

    $ sudo ./damo tune --probe_filter allow anon --probe_weight 100
    $ sudo ./damo report access --dont_merge_regions
    heatmap: 88888888888888888889888999999889999999000004888888888888889999988888898888888888
    # min/max temperatures: -4,430,000,000, 0, column size: 99.800 MiB
    intervals: sample 5 ms aggr 100 ms (max access hz 200)
    #   <start>      <size>       <freq> <age>         <probe hits>
    0   4.000 KiB    60.445 MiB   0 hz   700 ms        0
    1   60.449 MiB   1.363 MiB    0 hz   600 ms        18
    2   61.812 MiB   144.000 KiB  0 hz   0 ns          1
    3   61.953 MiB   1.922 MiB    0 hz   2.400 s       19
    4   63.875 MiB   12.133 MiB   0 hz   200 ms        0
    [...]
    500 5.132 GiB    8.000 KiB    0 hz   2 m 15.800 s  20
    501 5.132 GiB    8.000 KiB    0 hz   2 m 16.200 s  0
    502 5.132 GiB    16.000 KiB   0 hz   2 m 16.900 s  20
    503 5.132 GiB    24.000 KiB   0 hz   2 m 14.200 s  0
    504 5.132 GiB    8.000 KiB    0 hz   2 m 14.900 s  20
    [...]
    923 7.534 GiB    126.637 MiB  0 hz   0 ns          6
    924 7.658 GiB    252.000 KiB  0 hz   54.800 s      20
    925 7.658 GiB    142.242 MiB  0 hz   300 ms        0
    memory bw estimate: 0 B per second
    total size: 7.797 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

As expected, regions are adjusted to provide the best accurate picture
for the anonymous pages distribution (<probe hits>).  The region 0
(60.445 MiB memory from the address 4.000 KiB) has nearly zero anonymous
pages.  The region 1 (1.363 MiB memory from the address 60.449 MiB) is
nearly full with anonymous pages.  Region 500 (8 KiB memory from the
address 5.132 GiB) is certainly two anonymous pages.

Future Work
===========

Attributes only monitoring disables access monitoring.  We will enable
that in future, by extending the supported attributes to include data
accesses.  This patch series, and the future work are parts of the
ongoing project [2] for extending DAMON.  The project aims to extend
DAMON with primitives other than page table accessed bits such as AMD
IBS, Intel PEBS, and Arm SPE, to provide more powerful and detailed
information like per-CPUs/threads/reads/writes monitoring.

Patches Sequence
================

Patch 1 introduces damon_probe->weight for specifying the weights of
each attribute.  Patches 2-6 extends apply_probe() damon_ops callback to
efficiently support the new mode.  Patch 7 extends regions merge
function to work with probe hits in the mode.  Patch 7 also introduces
the function for detecting the mode enablement but always returns false,
for safe and incremental changes.  Patches 8-11 incrementally update
kdamond_fn() to support the mode.  Patch 12 completes the mode detection
function implementation, so that the new mode really works.  Patch 13
introduces a new sysfs file for ABI users.  Finally, patches 14-16
respectively updates design, usage and ABI documents for the new feature
and interfaces.

[1] https://github.com/damonitor/damo
[2] https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org/

SJ Park (16):
  mm/damon/core: introduce damon_probe->weight
  mm/damon/core: ask apply_probes() ops callback to set sampling address
  mm/damon/paddr: set samples in apply_probes() if requested
  mm/damon/core: ask apply_probe() to return max probe hits weighted sum
  mm/damon/core: implement damon_probe_hits_wsum()
  mm/damon/paddr: respect return_max_wsum
  mm/damon/core: extend merge function to work with probe hits
  mm/damon/core: disable access monitoring when probe weights are set
  mm/damon/core: set samples in apply_probes() if probe weights are set
  mm/damon/core: s/max_nr_accesses/max_merge_score/ in kdamond_fn()
  mm/damon/core: get merge threshold from probe hits when weights are
    set
  mm/damon/core: implement damon_has_probe_weight()
  mm/damon/sysfs: implement probe/weight file
  Docs/mm/damon/design: document attrs-only monitoring
  Docs/admin-guide/mm/damon/usage: document weight sysfs file
  Docs/ABI/damon: document probe weight file

 .../ABI/testing/sysfs-kernel-mm-damon         |   6 +
 Documentation/admin-guide/mm/damon/usage.rst  |  11 +-
 Documentation/mm/damon/design.rst             |  25 ++++
 include/linux/damon.h                         |  11 +-
 mm/damon/core.c                               | 107 +++++++++++++++---
 mm/damon/paddr.c                              |  11 +-
 mm/damon/sysfs.c                              |  25 ++++
 mm/damon/tests/core-kunit.h                   |  13 ++-
 8 files changed, 184 insertions(+), 25 deletions(-)


base-commit: 3783e23372c397a29574c34283e1f07aa420db74
-- 
2.47.3

