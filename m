Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A29FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 23:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C420F6B0092; Sun, 26 Apr 2026 19:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30386B0093; Sun, 26 Apr 2026 19:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A90E6B0096; Sun, 26 Apr 2026 19:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 875F46B0093
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:16:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A9398C0A7
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:16:33 +0000 (UTC)
X-FDA: 84702268266.22.73E01F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B1BFB2000A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:16:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dJkTEiD/";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777245391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Df5/uWUExlNepLRc/WmaWmPyXM6qwz9mJ9fgjrI3TMo=;
	b=WJ6ejYy9ALDrfCEhpMKF98QGMiHozx8rbhxSVGMaI9oGWfLV1whBjvh8JVzA783y5Jgdmm
	3U4Ggg0uef6p6OwjSg0tHCoDfu3BYl5a7HhxPI5pPRbNSJ+Bl+gSB5jgJGxeB9grrBKzN9
	fzYB4GnI33MDdac4hCOSJ2RFx5073/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777245391; a=rsa-sha256;
	cv=none;
	b=2DKShS2q+eCbuC2WxM1HKCtKnEm4Kfscdg01dcNzT5bgOUmFZtXkrn3+4wlaA5jEMScM+Y
	vQDLm7aqFwQiq92KY4V9o2ruJGMXDo57DwJ7YXut5DFsDr77v0IQFd5j6cfIpfzkAB2Q+Z
	b/HlyXecSXTxjjV356Ynamm2qMPZbJQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dJkTEiD/";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3411860580;
	Sun, 26 Apr 2026 23:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCA3C2BCC4;
	Sun, 26 Apr 2026 23:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777245391;
	bh=9YE+I9oyMLDWrax5J73tcs4Z0G5Qgydawv3W19tJHVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJkTEiD/MB1C5su+HVsYIpFroT51qwmn2v7M/Z9FUzT1hf6SaG5EXQtvx8A5bxZ+w
	 umc6cy9zI24KU3P3puw3N5yzNF8wRSTCHScWbK++HW6nj97+NY6VRpylIteWEGc9gY
	 NPbEPHZwKhd7C7kIHoiPnYcByKv/K1v1eetZmlc+o+hKACbVdikK/o3sH8B9XEsugC
	 NaeizqyLt18+2fruhFKreFRalXEVDPgj6vxNt+7gUEi/OuB1oeq1c5NJIhqk1E8hC8
	 tjaU9d7065VycLvnog/XZBdklfwiPly8kXpfFCy0u76eX5crJn6sKNHEhDJ/9n0X5z
	 9RfXBnjqhjwXA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 4/4] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Sun, 26 Apr 2026 16:16:17 -0700
Message-ID: <20260426231619.107231-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426231619.107231-1-sj@kernel.org>
References: <20260426231619.107231-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B1BFB2000A
X-Stat-Signature: 8we983icjzende35eoktp88qbpnp9ynw
X-Rspam-User: 
X-HE-Tag: 1777245391-217348
X-HE-Meta: U2FsdGVkX1/XP985pj76JQZFQRGg7aTRwaGDhU/lzwUukm/KNAcLdgm9ODd+A2ZHpSjeMYOEZYCgQxWrr7DJZ/6/MJGPmuqy0dNGRGQOspb/qAY5yOIB0lLKt8qOJgLUlB3absVdjyZhZlrQkwEEVLdR8shQu+DOZJS8uO9YYxcUNxLPo1PzZxYpkm00ysVBUax4uqUlwszcxHbD+dmRUXxA1EpEDI6JSyP/TCgne3AUZsCkr07qMU2NHQQZ4Oqn+4YwG3J7xg4rRJxeicRjVQcgP2D+ZyXQ2pWy7luzRHtfjT85wz0ulNclUIom1HtspyRCJjq3WIK5iMXN+FiV9JsRYvkVjwxHmfSNOdIrXQbuDssZYw1TK7PxkeiCvuqpok986c/2iJJdsfL8PPKz7xfQxMEv+qTZ4YEDsPl1g0j+Dy95TpwWc12u8ZZnnP1ZqqP7wCzZrm9TZWMvTTUOWYouDswmpc0TyLxPAv7YI0F1V/UcVQm2ap8C5RO4Q07uIVzUAvlzLaRo0aqb+vUAAEQz1Cp4QQ/TzbXd5xPIUjj6/aVx/lCauhqYw/UYwmd/u+KVCnfZ0BJNLG25bzEjUPzEWsHz8RPItEcd8Y1ks+CPODENTfMD9kTWRFP+ZUE9lpK3k/BDrUt5xssAi/2YRt9PSZXpTxVNztGTDVPvbTUmYr1JGM+XcdDhpezrL6ZjfmubP0jlxSq4AssXKBCdkNqZI0S7lWogf1T98UvxSfhGqEzVDZ/d7Xm26Qqmp3EltLSOTwO2XiNt7TaILaLHGiIQh5ldYJ9M0bQUz0T0pidEFnUowQDF9Q+pQa9VrhDkwXDmowdtHqNbn8jv2mSDTzkHF61/8KHu1vwFy4VonudvFhKh5whKY18elYkjepGg83SNjknFBd5ZtiHD4JoV1/RS/7EhNInZuF5nh+AOhU4fgqVkNMufDgWkdDtOkNNo+1W15o7B06PY4kJzzJs
 TR9wYO0o
 g4CglXflc/N0AciIy1a+2Q1Qqw5tgvyTgUGeDfwrDq6STx1TZjt+eODO2rcxGf1SPwiWIcSbxyETg3m+kvo9WsdZ/OO82WBzSST/U3/9ZQfdf6iKh/VH+wfsURtQTQVF4yo/usoMiKpMjWepKgiiH4v+yNKGBJ43Yeda4MVWUBILZF3X94oV4nEXrhbyQaGr3XWTa6YeTUnyw5qdmrnsnf0CflJiwkcJ8gcGVg/RAJJ1uzrq08YAcc8C4lj1c07CxMzdgFG/ZbljLkCV57LVQk1tQnaWlS5cKm/6ystf5W9Ei4QMOxN0n4QXfhsEhYs9Bdj2voUNJHU9FQWzfYAUik/PVKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

This patch set introces a new action:  DAMOS_COLLAPSE.

For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
working, since it relies on hugepage_madvise to add a new slot. This
slot should be picked up by khugepaged and eventually collapse (or
not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
enabled, khugepaged will not be working, and therefore no collapse
will happen.

DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
the address range synchronously. In cases where there is a large VMA
(databases, for example), DAMOS_COLLAPSE allows us to collapse only
the hot region, and not the entire VMA.

This new action may be required to support autotuning with hugepage
as a goal[1].

=========
Benchmarks:
=========

MySQL
=====

Tests were performed in an ARM physical server with MariaDB 10.5 and
sysbench. Read only benchmark was perform with gaussian row hitting,
which follows a normal distribution.

T n, D h: THP set to never, DAMON action set to hugepage
T m, D h: THP set to madvise, DAMON action set to hugepage
T n, D c: THP set to never, DAMON action set to collapse

Memory consumption. Lower is better.

+------------------+----------+----------+----------+
|                  | T n, D h | T m, D h | T n, D c |
+------------------+----------+----------+----------+
| Total memory use | 2.13     | 2.20     | 2.20     |
| Huge pages       | 0        | 1.3      | 1.27     |
+------------------+----------+----------+----------+

Performance in TPS (Transactions Per Second). Higher is better.

T n, D h: 18225.58
T m, D h 18252.93
T n, D c: 18270.21

Performance counter

I got the number of L1 D/I TLB accesses and the number a D/I TLB
accesses that triggered a page walk. I divided the second by the
first to get the percentage of page walkes per TLB access. The
lower the better.

+---------------+--------------+--------------+--------------+
|               | T n, D h     | T m, D h     | T n, D c     |
+---------------+--------------+--------------+--------------+
| L1 DTLB       | 127248242753 | 125431020479 | 125327001821 |
| L1 ITLB       | 80332558619  | 79346759071  | 79298139590  |
| DTLB walk     | 75011087     | 52800418     | 55895794     |
| ITLB walk     | 71577076     | 71505137     | 67262140     |
| DTLB % misses | 0.058948623  | 0.042095183  | 0.044599961  |
| ITLB % misses | 0.089100954  | 0.090117275  | 0.084821839  |
+---------------+--------------+--------------+--------------+

Masim
=====

I used masim with the "demo" configuration, but changing the times
to 100 seconds for the initial phase and 50 seconds for the rest of
the phases.

Memory consumption:

+------------------+----------+----------+----------+
|                  | T n, D h | T m, D h | T n, D c |
+------------------+----------+----------+----------+
| Total memory use | 2.38 GB  | 2.36 GB  | 2.37 GB  |
| Huge pages       | 0        | 190 MB   | 188 MB   |
+------------------+----------+----------+----------+

Performance:

THP never, DAMOS_HUGEPAGE
initial phase:                40,491 accesses/msec, 100001 msecs run
low phase 0:                  39,658 accesses/msec, 50002 msecs run
high phase 0:                 41,678 accesses/msec, 50000 msecs run
low phase 1:                  39,625 accesses/msec, 50003 msecs run
high phase 1:                 41,658 accesses/msec, 50002 msecs run
low phase 2:                  39,642 accesses/msec, 50002 msecs run
high phase 2:                 41,640 accesses/msec, 50001 msecs run

THP madvise, DAMOS_HUGEPAGE
initial phase:                51,977 accesses/msec, 100000 msecs run
low phase 0:                  86,953 accesses/msec, 50000 msecs run
high phase 0:                 94,812 accesses/msec, 50000 msecs run
low phase 1:                 101,017 accesses/msec, 50000 msecs run
high phase 1:                 94,841 accesses/msec, 50000 msecs run
low phase 2:                 100,993 accesses/msec, 50000 msecs run
high phase 2:                 94,791 accesses/msec, 50001 msecs run

THP never, DAMOS_COLLAPSE
initial phase:                93,678 accesses/msec, 100001 msecs run
low phase 0:                 101,475 accesses/msec, 50000 msecs run
high phase 0:                 98,589 accesses/msec, 50000 msecs run
low phase 1:                 101,531 accesses/msec, 50001 msecs run
high phase 1:                 98,506 accesses/msec, 50001 msecs run
low phase 2:                 101,458 accesses/msec, 50001 msecs run
high phase 2:                 98,555 accesses/msec, 50000 msecs run

Memory consumption dynamic (how quickly collapses occur):

It shows in seconds how many huge pages are allocated.

+----+----------+----------+
|    | T m, D h | T n, D c |
+----+----------+----------+
| 5  | 32       | 188      |
| 10 | 48       | 188      |
| 15 | 64       | 188      |
| 20 | 96       | 188      |
| 30 | 112      | 188      |
| 35 | 144      | 188      |
| 40 | 160      | 188      |
| 45 | 190      | 188      |
| 50 | 190      | 188      |
| 55 | 190      | 188      |
| 60 | 190      | 188      |
+----+----------+----------+

=========

- We can see that DAMOS "hugepage" action works only when THP is set
  to madvise. "collapse" action works even when THP is set to never.
- Performance for "collapse" action is slightly lower than "hugepage"
  action and THP madvise. This is due to the fact that collapases
  occur synchronously. With "hugepage" they may occur during page
  faults.
- Memory consumption is slighly lower for "collapse" than "hugepage"
  with THP madvise. This is due to the khugepage collapses all VMAs,
  while "collapse" action only collapses the VMAs in the hot region.
- There is an improvement in TLB utilization when collapse through
  "hugepage" or "collapse" actions are triggered. The amount of
  TLB misses is lower.
- "collapse" action is performance synchronously, which means that
  page collapses happen earlier and more rapidly. This can be
  useful or not, depending on the scenario.
- "hugepage" action may trigger a VMA split in some scenarios, since
  it needs to change the flag of the VMA to THP enabled. This may
  lead to additional overhead.

Collapse action just adds a new option to chose the correct system
balance.

[1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v2:
- v2: https://lore.kernel.org/20260409150128.1566835-1-gutierrez.asier@huawei-partners.com
- Add Reviewed-by: from SJ
- Wordsmith changelog
- Rebase to latest mm-new
Chagens from v1:
- v1: https://lore.kernel.org/20260330145758.2115502-1-gutierrez.asier@huawei-partners.com/
- Added masim benchmark
- Added performance benchmark for MariaDB
Changes from RFC v2:
- RFC v2: https://lore.kernel.org/20260323145646.4165053-1-gutierrez.asier@huawei-partners.com/
- Fixed a missing comma in the selftest python stript
- Added performance benchmarks
Changes from RFC:
- RFC: https://lore.kernel.org/20260316183805.2090297-1-gutierrez.asier@huawei-partners.com
- Added benchmarks
- Added damos_filter_type documentation for new action to fix kernel-doc

 Documentation/mm/damon/design.rst      |  4 ++++
 include/linux/damon.h                  |  2 ++
 mm/damon/sysfs-schemes.c               |  4 ++++
 mm/damon/vaddr.c                       |  3 +++
 tools/testing/selftests/damon/sysfs.py | 11 ++++++-----
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index afc7d52bda2f7..365e068a8dbe4 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -474,6 +474,10 @@ that supports each action are as below.
    Supported by ``vaddr`` and ``fvaddr`` operations set. When
    TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
    fail.
+ - ``collapse``: Call ``madvise()`` for the region with ``MADV_COLLAPSE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set. When
+   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
+   fail.
  - ``lru_prio``: Prioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
diff --git a/include/linux/damon.h b/include/linux/damon.h
index f2cdb7c3f5e6c..ac71b845bb6e8 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -121,6 +121,7 @@ struct damon_target {
  * @DAMOS_PAGEOUT:	Reclaim the region.
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
+ * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
  * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
  * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
@@ -140,6 +141,7 @@ enum damos_action {
 	DAMOS_PAGEOUT,
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
+	DAMOS_COLLAPSE,
 	DAMOS_LRU_PRIO,
 	DAMOS_LRU_DEPRIO,
 	DAMOS_MIGRATE_HOT,
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 04746cbb33272..c14a564dd8218 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2061,6 +2061,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
 		.action = DAMOS_NOHUGEPAGE,
 		.name = "nohugepage",
 	},
+	{
+		.action = DAMOS_COLLAPSE,
+		.name = "collapse",
+	},
 	{
 		.action = DAMOS_LRU_PRIO,
 		.name = "lru_prio",
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b069dbc7e3d25..dd5f2d7027ac4 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -903,6 +903,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_NOHUGEPAGE:
 		madv_action = MADV_NOHUGEPAGE;
 		break;
+	case DAMOS_COLLAPSE:
+		madv_action = MADV_COLLAPSE;
+		break;
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 3aa5c91548a53..72f53180c6a88 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -123,11 +123,12 @@ def assert_scheme_committed(scheme, dump):
             'pageout': 2,
             'hugepage': 3,
             'nohugeapge': 4,
-            'lru_prio': 5,
-            'lru_deprio': 6,
-            'migrate_hot': 7,
-            'migrate_cold': 8,
-            'stat': 9,
+            'collapse': 5,
+            'lru_prio': 6,
+            'lru_deprio': 7,
+            'migrate_hot': 8,
+            'migrate_cold': 9,
+            'stat': 10,
             }
     assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
     assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,
-- 
2.47.3

