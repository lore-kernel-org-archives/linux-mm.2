Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78DD1061B09
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A36B6B008C; Mon, 30 Mar 2026 10:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B266B0095; Mon, 30 Mar 2026 10:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9D06B0096; Mon, 30 Mar 2026 10:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF2E16B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:59:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 966BCBA56C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:59:37 +0000 (UTC)
X-FDA: 84603038394.18.C9D206D
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6CBCB100004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:59:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774882775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=PTNxb6Etn5WzbggTULw5IA9naJw19ig+MxlkE2r34ZQ=;
	b=rX2e2Rq4oFL9EdNVX0cgAvmqInee2eHiN46d02RsklP8NuOhDGjPDetXebI56irWZk1mZG
	/NSqPwIQ0vvaXf4FjfA+KQzKtTOJ7Tw+Zfta7ZZvzy7pwjrrzffdeoTqQ0t4V8WddkUJE3
	YJX7Bjrakd/Ut1ZV23R/MUTHGsXUWto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774882775; a=rsa-sha256;
	cv=none;
	b=wpiRmtgHwKwypK59SJHXQ8U+qdWrZtZbUlB2cewQ8oYphd2/vZb1P8XHqi/nGNmKyCllZQ
	zU998Wh9CpUJSNwiHySpR0ZLZA+pa7HXIYG4nOpfD6RzzCdzDkfSToOov9QuVmBSi8GMhf
	msAchV6viStwcqgsqGOGdD1L5p1Y7xs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fkvX506BTzHnH6r;
	Mon, 30 Mar 2026 22:58:45 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 67DDC40572;
	Mon, 30 Mar 2026 22:59:30 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 17:59:29 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Mon, 30 Mar 2026 14:57:58 +0000
Message-ID: <20260330145758.2115502-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam12
X-Stat-Signature: je4hsdo8mkwcafiagwjuiraata5dtdtw
X-Rspamd-Queue-Id: 6CBCB100004
X-Rspam-User: 
X-HE-Tag: 1774882774-927189
X-HE-Meta: U2FsdGVkX191ZgXk4LJ05k9YEAENV1u8QmuEh4a9m/0ciVU56c7mpmps7LayG6SJM+KBBC6KOGEAzXPRjGw2nV87E8AbSNT4g8i4bD9oUrrwKXmXhwjlaewDrMfsa0R3+ya2Q5CIguon08/smrd88Fb1+ImqjC8zse5i+5FXSeINcNuheqYadugRGL4vOvFFZZ+kfGtjOdkPo5jg8ej3JfuxmZFe2YyMXbiw5sjRYu067IzH/l2j7h/s7ZPbFAszELWrB9dShWdtsNHJ/u5NICXNoESiZsBptHZNtOqfq3aOQW0uVG31hfP4BbKg+gGlxtW8kV5wbI3T55nnygYVqf9efePTopVmURVZh/Tt9UUWadlLf0hBSWK3rxYw44X9SdaqVeU/gK3h6aFhHzZ42ihCw7rbToK4er5SD89asJerCWru3gpm7iZzcuObJz3PRWlVeIZG0P0OjKvmUL6TjsW7ze34nM6mJFXt5xfhh20dXEB/QF9g1c8qgQMh3bu6/IwvIlt09UiHZ+rRdT6lT+01EQV7Q/E9Dzi0zjELmfSAuOKZunDFLjU6BSlFyhohsSQcvUmr5pVWUg/ICNof6UzkJ7v7o1OVMF2pIrxrH3l9OfXHMloOj1uv4Zn0X5koFA5DzzWV6qrB7wPKR3qw26GEqRCd2dkRHgexsje7JQymfkRLjPEfPEZP2PTAgdhQ8vrq8W8Emwvk1uekiM5tx3UF4UIFD1Y9EpoJiKc44hwQrdmPtiGxysgd3VbZ08ocMExiuZ6o6mvs2O7UxmSe6YxVsj47nG+HdERrsj23PWm20CHrU4zLLsaMYbHVhEogCXfNHKnoXXe44BUOiiGFmwPW4nHFkbvTL3lWAsG0L6qwZ8aJvKrG7clduW7ZdrxurrUquh61D4LLQsaCo+swUVizVk+1ff1UwR0uAhMNjqbw+jymQMgfH/PXSpUDwjqiEK37cUCOtoG007ztb6L
 r3Pe+OGH
 O7S6wFH/p/PsDXWYjfFAVduuA5Xxrpl9EOSXdaDnjVfVKKEp7emjrLwRgJzOIrfWf2QeWBD0xapn3oc0T8S1r1H6HeDVgBp8bkqvZDUXsZl47yCUg1n7SpUdZYrl/7J4YVyKQaQTA7VwEYLx3GT0ZV16SVWca6ujRalw9Rf6qP/k4TEwext+SKD7W4T8aoDgZ7f39PujdgG6QFX0F+MmaSvI8QSmWmc0Jifz3F2fSy3t4XetFy5ywMFgrCNGYhrljqoiN1hLM/YDwjBrS/ktA2CXs5XMCoQccWfWKeXpnsnsyTfA=
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
the address range synchronously.

This new action may be required to support autotuning with hugepage
as a goal[1].

[1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/

---------
Benchmarks:

Tests were performed in an ARM physical server with MariaDB 10.5 and 
sysbench. Read only benchmark was perform with uniform row hitting,
which means that all rows will be access with equal probability.

T n, D h: THP set to never, DAMON action set to hugepage
T m, D h: THP set to madvise, DAMON action set to hugepage
T n, D c: THP set to never, DAMON action set to collapse

Memory consumption. Lower is better.

+------------------+----------+----------+----------+
|                  | T n, D h | T m, D h | T n, D c |
+------------------+----------+----------+----------+
| Total memory use | 2.07     | 2.09     | 2.07     |
| Huge pages       | 0        | 1.3      | 1.25     |
+------------------+----------+----------+----------+

Performance in TPS (Transactions Per Second). Higher is better.

T n, D h: 18324.57
T n, D h 18452.69
T n, D c: 18432.17

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

- We can see that DAMOS "hugepage" action works only when THP is set
  to madvise. "collapse" action works even when THP is set to never.
- Performance for "collapse" action is slightly lower than "hugepage"
  action and THP madvise.
- Memory consumption is slighly lower for "collapse" than "hugepage"
  with THP madvise. This is due to the khugepage collapses all VMAs,
  while "collapse" action only collapses the VMAs in the hot region.
- There is an improvement in THP utilization when collapse through
  "hugepage" or "collapse" actions are triggered.
- "collapse" action is performance synchronously, which means that
  page collapses happen earlier and more rapidly. This can be
  useful or not, depending on the scenario.

Collapse action just adds a new option to chose the correct system
balance.

Changes
---------
RFC v2 -> v1:
Fixed a missing comma in the selftest python stript
Added performance benchmarks

RFC v1 -> RFC v2:
Added benchmarks
Added damos_filter_type documentation for new action to fix kernel-doc

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


