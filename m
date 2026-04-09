Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C082CF31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28156B0005; Thu,  9 Apr 2026 11:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9036B0089; Thu,  9 Apr 2026 11:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEF66B008A; Thu,  9 Apr 2026 11:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCDA66B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:03:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03C821A013E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:03:16 +0000 (UTC)
X-FDA: 84639335634.01.9850387
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3D6F2C000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:03:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775746995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=aNgrGME/79oOCyPHHzapXv03eBfjtxiEh7jfHkrTRgA=;
	b=zxOaabPHusdOvkINVmW0wi9QPBBaZLZQe5hEUcMI55j25WOZG4R3ifW5N2tmcdkueWchu/
	vC/Of9y8rflhTQ8Wc061AHmTM8OXMiyQ0Ij7RLhCmpRteQ8O8la5WIQ+wEHCn6b0Wknsml
	pnFi2JMDjlqYSPvQQsk9Yt/pdyUs78k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775746995; a=rsa-sha256;
	cv=none;
	b=DBWdl0hmIYf35LRkTZGTzPkOFu+4gYDr9qSWMHjpQeq6d9+uS+XZ1CoHahb3IOV4It78Sm
	9IfIWXw7dTuMVkObK60tEqRSW7zRh9ZVnvu3bCNbCQIV6mqNvusgJzq0yXKsWzs6TVDZQY
	2bqHti55QvC/ySDg3DBO5TTq3NNBrtc=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fs38T2bl4zHnHB7;
	Thu,  9 Apr 2026 23:03:05 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id B6C2D40584;
	Thu,  9 Apr 2026 23:03:09 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 18:03:09 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Thu, 9 Apr 2026 15:01:28 +0000
Message-ID: <20260409150128.1566835-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3D6F2C000F
X-Stat-Signature: yfwhjdncznoapazcb3zob9pbqjf349ts
X-Rspam-User: 
X-HE-Tag: 1775746993-640470
X-HE-Meta: U2FsdGVkX1/VoBmiC31DxG25qT+ff+KZXsg+6f1mBIct1mX7kz8Z7kkIpeiXrwWsiHnZyOaRFcSFV99PxALyb63srnNA4hL0vEr68biRCeCNhZfO/qN0q9oYYWA+VsFbD1eDm40MxZpCnnW9TQ45SjhRvjefsxS4NjcO+cwkyq337LBeoufJnhE3HmAZnltaMrpAqW5gIkN5im6gs57HkZiv8IlW4D3sGLgNgUWWXlO6X0Pf/Bv4ZkyPs4VJDK4pYWsbhCOjTxZIF+mGz2DIWKBrPJRJxA1c0b5kji3ttNZCuxVZJucwqTFsLI45W5/X7rmYPn1dHHxG1hynrR8Ownn+IlFfMU8fJkQbr7gYmiMWf/iWgXF7oVAtsySUxpbEvAPRHFxvDDPf6ogNUWKcpEGC7ES0BZFODpagMTHk24pGHRJW3RHPtR47F1BmZSALy/VGGWRhoRJwUC+XkVjDoc1C6qaztiSrStT2zjcQxBIb9m0tGjL3aZ5VrF1W6PV/AdLafCBn37zqp87owz2hE/McemAkcH4yl9R+qwT7g1HiIqiXmkU+1FHuysZKomZV4i6KzqabpeCp+ILopxf2vPQE3zTA3MInonPxxPi6T99yJ1WFLUs+ug0jSqdzzSJvcJVj0btsiV8Zi383FTdPvDcx3bl5ai5W1dsWShi4w8+8CvpZbJCul/kCkIu9Pei0eSg3MUaTsaQvVNmKzOlrJW2TMF1AuWURAg2uLe2jQZ6A7jliDyQWFO2xyX7MCuyyB+Ig8T2l/i0XKyCwA8pKFmBft6fwmkD0cdtIX0cwoiGA6k37XYNqvvNqaLcLtnFsdkjOHOlV42ku8pEVtFIqkErJRSZ+/78G9TlqFsaip+4h5wMobBCPjDIPoj5a6B6sJdrtTbEOKErfT/KMkoasrqOU8Pk1pMkZtC1qdsW4wI6DjUiryDgwfUofBIyduUtsohjut5Zpna6xlQMghZy
 97pnFZuL
 6qsfDLPi1I8gFSD9xApKNY78W7EfjFd5TlrVbFcNbkCCZp7qPfFtcraFzHJbzxAxT67hOZ2PI6h98A9BWwTK+qaNrzVKoMkLQNmNPGQgnAredH7Ebe/JmZIIuaFVyJ/0f4Snf56pn8QGzPz4FSuRLlB2fhAoDB76fNudMiSvWqwVfG+hFBdRKtL3XrxRTc2iB6aPEoVBlFtISHZ9u1c2GECrZAgutpucRfT7BtSetlUcIGIZ+1L4r6zy6L/SeLZvQ09aQptYcoxo7+9lQAGJNgTh/SSpiaUYTJ7LoZBim8R+fYgU=
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

Changes
---------
v1[2] -> v2:
Added masim benchmark
Added performance benchmark for MariaDB

RFC v2[3] -> v1:
Fixed a missing comma in the selftest python stript
Added performance benchmarks

RFC v1[4] -> RFC v2:
Added benchmarks
Added damos_filter_type documentation for new action to fix kernel-doc

[1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
[2]: https://lore.kernel.org/damon/20260330145758.2115502-1-gutierrez.asier@huawei-partners.com/
[3]: https://lore.kernel.org/damon/20260323145646.4165053-1-gutierrez.asier@huawei-partners.com/
[4]: https://lore.kernel.org/damon/20260316183805.2090297-1-gutierrez.asier@huawei-partners.com

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 Documentation/mm/damon/design.rst      |  4 ++++
 include/linux/damon.h                  |  2 ++
 mm/damon/sysfs-schemes.c               |  4 ++++
 mm/damon/vaddr.c                       |  3 +++
 tools/testing/selftests/damon/sysfs.py | 11 ++++++-----
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 838b14d22519..405142641e55 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -467,6 +467,10 @@ that supports each action are as below.
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
index d9a3babbafc1..6941113968ec 100644
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
index 5186966dafb3..aa08a8f885fb 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2041,6 +2041,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
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
index b069dbc7e3d2..dd5f2d7027ac 100644
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
index 3aa5c91548a5..72f53180c6a8 100755
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
2.43.0


