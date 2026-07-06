Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D45DBC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12EA6B00C0; Mon,  6 Jul 2026 10:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE616B00C8; Mon,  6 Jul 2026 10:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37166B00D9; Mon,  6 Jul 2026 10:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 849DF6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1129D1A031E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
X-FDA: 84958559406.08.EC67265
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 62A2C1A0009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JeYADbsi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i87JO+gJj72UbHQzbOb/N8EEBzlxHqvP8i5Djmq/yJo=;
	b=ZIyPCkdHwa4W4SXIuUTE8oYtmeU6nkc3WeuZnDbiTTTqAUclN6rWTx4vbD6Xh4DRi+vl5X
	xh8OUjmgB6euNqnad37Afo6uJp/0zFpPnBYFeid6K5TOJKRMm/Kr2VkjWRZ+GWXhf66Zod
	yTWKIe7gzQPGdAGfRejnadlq/aVAJRo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JeYADbsi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347561;
	b=fZIW+eXpKSc5ropeA5n8yf32qlgO7SWFfBss6UY+SUDdeAREYtmszl2R0fl/KedtWRkh8S
	eTdHd7M8f9KnjnYZb46dN3hA7ZWojeVb+sgonL0T+T5XbqKp4zJ1l9dheYw4J2U4XjsoEd
	vhcLpqPTNGwR876brPhK0iWppCAKbfk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBFDA60098;
	Mon,  6 Jul 2026 14:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055221F000E9;
	Mon,  6 Jul 2026 14:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347560;
	bh=i87JO+gJj72UbHQzbOb/N8EEBzlxHqvP8i5Djmq/yJo=;
	h=From:To:Cc:Subject:Date;
	b=JeYADbsi5s9q6/eNMTz/nBCYO/5f7S7GHQL3B0f1WDRWTeg9PC4TGarR3F+ov7Bja
	 JREqATY+9eanFWJQeqjVmyzmyzdKIh7RFwSN8hJTE30cNWb1ubn3AnVTan5E3iosu0
	 A0Y63i/708h4tQcPN6wYEZLFxVj8YLnwpBkrZo6CmgXmNiLfpkTbMp5VbzQNccPBMl
	 pEP8BxF0XIlGQG7LgyzhFcBKkWoTbl/6LQ5Bs1qCv7QCTAx38XZhwFOiobClP9eg0d
	 pE5TOxBQVLM7v8InqRCUXXafNES/UXvX6dnhXCbbcFRpSZ8NIHUaSURXuuvnx/hBdk
	 HFuwcl1abDS6Q==
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
Subject: [RFC PATCH v1.1 00/16] mm/damon: introduce data attributes only monitoring
Date: Mon,  6 Jul 2026 07:18:54 -0700
Message-ID: <20260706141912.88445-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62A2C1A0009
X-Stat-Signature: xtsw6skarwp477zh91cwjjsrizkrudkm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783347561-385458
X-HE-Meta: U2FsdGVkX1/ECkGHLQiqqMxTODaGQRa0eDv6fyBhUkr+QaohO4P2AwYOJv5WNv1LNp+/XscJwLtSKOXat7Wc153gRTIZVaWFTJA3nyNCQ6w5k/B8EwSme4xqsCvLLnmC3HIfWhlz1C4j5YNdybGPKG1GUhgfQ+Ft2dwZBYsOnqzFhuKpj3IIhliNh5ZiD880BkWBVAM1cnlaimBRUoG9wWWYbXSRL7d+LiZQj0fT8IBIkxV2Ql1eBhkmqqb50hZjufpwoe3DrUGannF26SV3+LDunB70Nh6lMJHx467rABYWF/RxkQeOuX5xIE6cMME047HWCklrGynrYBCwehy5zaHShlh2wb/IBZrI9iEn0iyQFCfsWgkV18fF3C2QTmaYPyumywjGx2ngJEXosf0Fog9XriMddwbyiymxtiRfOL5QsO47aDkvlvhLS0xNPY01dMO8RyjRHERlM1AaXJvEchgybknTMx+UBSdkg4OtmoQ7TLCqlXWHJri7Bqpvv3z7n5PnJApHroX4Sp9VfBfbIid5197jgECviv3kYAabTq2rDNm+AA24w2yiGkvTX0uieNKhPmkGkGkqy/UYmHBA3y4hCsvwKNljwkFvHt/G6U3RP4kcSWv56tm0O+xbhwSJPosGEi5dg8bQtX5bBN2GvyZvFsKFO3PKrmcfY0XNcqwbEItLXTggft8YsNEbJVqLgdQ12wG7AqKxxhkYZkc4u3DZ1IBKsKruiBJeDyIDsYJTQc077KhKAS4CRZhyx91DejOwvbj+ubS0p4tYvwIv+FqjtkG0FuNSUnKtAe2uL5dWgNL4JLylwPFkk5JUQExZB6C91i+67sqClZss4vEC63TlimtkPH5K8gt6LtqcJQtz2Zc27fwTeacQwrojSEqQOIuv1aF8qI6Z+GTzqh6e2A+Mg7yX2HfI4AL8N+bT5ouBd5nLJ4LEovEWeuIQTMdDHyMPyl3yJWUVGHXeN+q
 O/kT9jNq
 eE6Ztbsq246sps5fPXNc3xs4cXZsohFH2oMKwfVQuAQlEXNPPS9zOHVJbBaGYhZ0zkTadIB5AcKgF4yuHQJYdpNlxG5aEEnn6FIjvrRnVgtLj2VSj6VAx2ddNKXm1JvPgyUky5Ht+ghf9prtZTqzMiQjNGI8rwXpEg+9PMof/NVnFMmiqZWiS1hoyYFxVBoS/IrjCJkIyZ3G4rpChu/pKf/BBvRXkYsHrzjputsBTsiKKD0GgyrdUKzJSYhX89OYHnno9
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

Changelog
=========

Changes from RFC
- RFC: https://lore.kernel.org/20260705205743.98656-1-sj@kernel.org
- Add kernel-doc comment for damon_probe->weight.
- Fix typos in kernel-doc, design and usage documents.

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
 include/linux/damon.h                         |  12 +-
 mm/damon/core.c                               | 107 +++++++++++++++---
 mm/damon/paddr.c                              |  11 +-
 mm/damon/sysfs.c                              |  25 ++++
 mm/damon/tests/core-kunit.h                   |  13 ++-
 8 files changed, 185 insertions(+), 25 deletions(-)


base-commit: 6a2e3b53ae2be579022206bf5d43b87dff04fe12
-- 
2.47.3

