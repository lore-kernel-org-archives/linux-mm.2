Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A71B3C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C136B0088; Fri, 10 Jul 2026 09:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C016B008A; Fri, 10 Jul 2026 09:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93DAE6B008C; Fri, 10 Jul 2026 09:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6BE6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1432FA0441
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
X-FDA: 84972993126.18.28EDF8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 701E41C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=De6YCh9k;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=F5AOmdAHXog1rg+jz/2akDmqr4uv17auS4VY00P0nsk=;
	b=xoHv6QNPa6X06SL83jtkovI9pUt7Ay6EjsT8AKYk8Lfg1U6Z29btHMjWFbhJzZ9EFZIu7p
	6Atdxb8Tx08c+iJlzE8G8whNLFT/NsgMub/+YS4kMFnaa7a3GiHc8QR4neeqpqw4K3zYSP
	400jYSVtVHZUvDewqD+5aBtOfV1B0uM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=De6YCh9k;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691221;
	b=eDZJBF91XY9SDiXAg/1kJ9FC9G25+ln1Fg1UUg+6NfT6P0238mO5bP+UnZdkvuq8nUPTuO
	/E6jBHA422J+ujpfvdGVMvBPpdUkHn1KAKBe1JTqB4tTc7/uhZCIm3Ig+UqAmYo/027gJd
	n5K9PXKsZYBMJHajAJnvAX6gL9sdRKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9667C418E3;
	Fri, 10 Jul 2026 13:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703C91F000E9;
	Fri, 10 Jul 2026 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691220;
	bh=F5AOmdAHXog1rg+jz/2akDmqr4uv17auS4VY00P0nsk=;
	h=From:To:Cc:Subject:Date;
	b=De6YCh9k2DWS+HtnAc27vzQ8a+Rt9P/ruPDPlwlvxY5Faj8i3fvrqluq4bS5rXYP9
	 O3SKjrfjJAaAd+4IQX6tcCj10QlrIoMZ9Kih1OloYAffq3Ske8THiIesHu5Gu4vSGW
	 xZPZljpw+OqSywpKmRGWuo/lEVfvpsch5wcjN/+341HaTzUfh2Vt8mwJPTJwT+wDAu
	 jSk7N3bRrJrh7Cq7LMYd3xgeLzRHaSScB7kBjNjYfOtxwOO9qGT8LbM/cVGbINJRfP
	 rEGhOotmLrzxUxVilzaEgE4Yeu+kpGC3AOI5byQCdJ4wYOw5F+mWelq4ubQHZ2nJlQ
	 d6bKBh6iX+OwA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 00/19] mm/damon: introduce data attributes only monitoring
Date: Fri, 10 Jul 2026 06:46:29 -0700
Message-ID: <20260710134651.18084-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 701E41C0003
X-Stat-Signature: 79jr6ox3zzzgqjyse4ax8iikpryx7sow
X-HE-Tag: 1783691221-866236
X-HE-Meta: U2FsdGVkX19lXi0Mp9NyHoIK4R5MlPis+nzYTwAHraMJBvobnqwm9Yz+0Z2ulWJ+6YjyAW7lDFDhqtVA7BvLo5tniIm4JdBdoZ8onN2lACyPU0lewNsO9yzEWcD7UZ40c4Y2p/Quii/EISvLJ1Qte52qHh3av3Ji8y6ze1XMDfRgcrXxtmiUUtIlRkUdfUZG1DeMj+8pGgib0zfF/o94vCZ6dWo4tZtsSdEdlm8sn36iD6EmuBNTldEMjptXpLU2kU1TPfsqSjqrRIEsT22p7angBN2KBzJFCrYHSyt1mpiVGC0oFeUIT9u0cnlcbvOFq+KJDy+5ZLu+iUxQKU0jSkohtqEDKMiYfLZV4hnk75oSbnDb5tkDMw84umB3A9+P3Rlvdp62n9Wjtb40rsxM2jrM4rUa8wn01L73vDvmyCRJVACTFPHwkTCqY3fLg6mnqQ8TktYhbBuB2rImsAC9ya2bmZ6MOUcR+JgbZAouYuHZeAtX51fv0MopFx5hwd7CPbbkh1y7YjABoCqSaz5pF8UUzqgwNFVB0Sb93L+Ee9pcz3TFLsHzfDgW0gP66Muu7pUh9PrSwEzeDQjkPKFxxe47ZQhopBob7L7FQoGtr3leF4/dAIca7jlIMglGsvp6qfMJVuwQB4lMUt7NHhEs2imO8ClNaKoUHu4vY+WszLz+Lfajj/qZvYiMcYTepZOn8Q9+xV8LRMTPsfo4H+yDsBU/r7IdCXt+WmMdbm0deXYcE42RJ2+x+AqvVhnF72Nwwl4oQI+fNTFbeBV8NDt9yXMssZS/Ist0sBclll0UZ23X445i2lO654HLdu9P4TLOnbY+bmyduI8a76fkng6ajyWjEmrkkfaqu6i6XGAJlKbWvGPI3EW2S1F0FfnQUM7IXP9l7bDkIRd3xtWqflJc9Rk+SiONyciQpeL3moJCMpqJhJ/fhP5SrHlUoqw6TDmiYehfAvMC2QofFmFCuo/
 2CqxgIUv
 75KMWGtkHQ1jGarLKQ8ofckjYRQYpVytptzlqNIk9sXJ1YawyiHwpJ/udiVBIEzbvvGtF9s/WC8yQb70BLarkuG376a3lI4qigx1LYHy+TR4wxCjPGrHE0XfQkbk3VjpVVLgA4lqFca7Mkl9YMyfGbrKXyvhg+YvTo9YGyIF1vGvi1LiFFAM9PZkgxcqHsEVF14MAMBUhiAnRi0Os9WK/GX/4qgS1fNrLsdZHZlH9JJmYvSSs2k4uAGNhqvfVAv8jd6P4
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
efficiently support the new mode.  Patch 7 fixes wrong use of abs() in
the regions merge code.  Patch 8 extends regions merge function to work
with probe hits in the mode.  Patch 8 also introduces the function for
detecting the mode enablement but always returns false, for safe and
incremental changes.  Patches 9 and 10 adds user parameters validation
to prevent theoretical overflow of probe hits and the weighted sum.
Patches 11-14 incrementally update kdamond_fn() to support the mode.
Patch 15 completes the mode detection function implementation, so that
the new mode really works.  Patch 16 introduces a new sysfs file for ABI
users.  Finally, patches 17-19 respectively updates design, usage and
ABI documents for the new feature and interfaces.

[1] https://github.com/damonitor/damo
[2] https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org/

Changelog
=========

Changes from RFC v1.3
- RFC v1.3: https://lore.kernel.org/20260710002349.111414-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260709140600.90950-1-sj@kernel.org
- Fix two typos in comments.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260706141912.88445-1-sj@kernel.org
- Fix typos in comments.
- Fix wrong use of abs() with abs_diff().
- Prevent probe hits and its weighted sum overflow.
Changes from RFC
- RFC: https://lore.kernel.org/20260705205743.98656-1-sj@kernel.org
- Add kernel-doc comment for damon_probe->weight.
- Fix typos in kernel-doc, design and usage documents.

SJ Park (19):
  mm/damon/core: introduce damon_probe->weight
  mm/damon/core: ask apply_probes() ops callback to set sampling address
  mm/damon/paddr: set samples in apply_probes() if requested
  mm/damon/core: ask apply_probe() to return max probe hits weighted sum
  mm/damon/core: implement damon_probe_hits_wsum()
  mm/damon/paddr: respect return_max_wsum
  mm/damon/core: use abs_diff() instead of abs()
  mm/damon/core: extend merge function to work with probe hits
  mm/damon/core: disallow probe_hits overflow on attrs only monitoring
  mm/damon/core: validate params for probe hits weighted sum overflow
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
 mm/damon/core.c                               | 139 +++++++++++++++---
 mm/damon/paddr.c                              |  11 +-
 mm/damon/sysfs.c                              |  25 ++++
 mm/damon/tests/core-kunit.h                   |  13 +-
 8 files changed, 217 insertions(+), 25 deletions(-)


base-commit: 6af40ebf40984a5ea1bbf273c65c9ad4b6e73291
-- 
2.47.3

