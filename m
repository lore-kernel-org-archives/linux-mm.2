Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA82F46137
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EABD96B008C; Mon, 23 Mar 2026 10:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34D26B0092; Mon, 23 Mar 2026 10:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71DB6B0093; Mon, 23 Mar 2026 10:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA07F6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:58:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 738031A0BAC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:58:18 +0000 (UTC)
X-FDA: 84577633476.05.5B85155
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9584E80010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:58:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf02.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774277896; a=rsa-sha256;
	cv=none;
	b=LvikgtJbbL9uN0WaIHYFjFvE3VE+QhzEzEWhplGCc94bOSqBxQypIbTtGf6M95Qzw2QcWE
	u8K98Bo7t4SYHsdjmfUpdsKgq2i4k74e+E8ceMlFfOId3eVGH+CGlBTjQu/kr1evPRsG6P
	Q5FJX4EUbP9OW0RPQj2tplm5QtyKa6g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf02.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774277896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Fr9WbRB+R4X0dkxGs62oUznlSfvV7dDKBzgS8W6pN1w=;
	b=GMuZAhWJYzMjJZXXjILdC6wNomYIvEqaHMrAkPmmBBCc7IkQa3pMXfndiFNSfQkV80TbBJ
	+X0081CxYljTExaFxk5vqDujdNnf2gdkZjQzxJjuR2Qm6JqSZUQYW+giXRn4MSwZfJnWhY
	i1xIqHf/bGmNlvf/xwvYYC6fIh0XN9I=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ffbrZ6H1QzJ46Dc;
	Mon, 23 Mar 2026 22:58:06 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 4479340572;
	Mon, 23 Mar 2026 22:58:12 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 23 Mar 2026 17:58:11 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 1/1] This patch set introces a new action: DAMOS_COLLAPSE.
Date: Mon, 23 Mar 2026 14:56:45 +0000
Message-ID: <20260323145646.4165053-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: c1dd8texoae77ptg5n4n71b3ju3ntdi9
X-Rspamd-Queue-Id: 9584E80010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774277896-210492
X-HE-Meta: U2FsdGVkX19cicIJj8rnshM8Dc7vm3YP7CDcUsp7vOLBNfriNQwJs46PnOmFUwboyelZNDgmRv1K9GQUwDO9Ubw9umz2FCrsVOoza63nPs+6Q4liFGO4VCRrGrTwThs0T/3rsb+B7GjETlgAAH7SoSPeyapwu+BfYsor6228wsmPA3sm4bJ192KpkDN62ggeN7gzYm/Z2zWlsINL6pc549VEHt31tYPgLM5B683E3I3XWyVTva2q1+D4qYbBFbGK54VwMF0LpRhTcDOQQsepX+WasHwoFaTVLpnvoGEBSLnAJmxBikX7gl6iWCPWrN9VE6sG2SI/GNidWlA9eU75GuzQsDqI+gXeXtmQXLZu6CsKBMW+dZ076CLThlg8lx/VdKTrFvJvvCTOqUesLmf79IAhr14HbikmH9Xfs4Z/zSnjJpcXi3SnRherSB93cdKmxqVpuc30JimJq7SWUjgxYrb1Hlq9OicHHKzOOmcnt9xQ2THXYfTu0H91ZxdNFR5WANFEaUeFr57dGx80CJc0a3Coge+zh6GtVquopWspnt4ggp8oyC5mkysVap7ODa5CKtlRbEFFGZ8JNGv3CCEWOPHl0DYFJ0v8/LuE6BtlY3pIwEjytmK8Xi1t2FHRAF/GmF2mRutjOSiBBqoj+T8Uq3lN36qngMkAmjk2veilTOuhtFC2FqeDcMFzg76/JSoECvTw9lrR8/gkCNPxkVcVw9nArzeDERPxFTTcd7UBmo//G2IA938VmtGAJomVTF32+2btgOL8/R5DuxOKt5jE4FG0bA0qx7hPenrVUrNln9Ljp8GwJdFvvsYEJ6IMo9fxXvJSqYb3FibtvJiGAXkhLbG0gsHpYF2Tq5MXT+EkoJRaZnXrVFtU2N197PLn61on60A4Cbyp7cIiJjq1mkS01t0seZOUPRR/izcTfljaJsIJVY4l8R/T6TnEK2OeEEYUG7NOuUgPQqydtZnF7P8
 RpdWRxZt
 vMrMV/hIrAJhVkXU43Y3zxixZpeTvXZLcWO3XlbzT/qKipqNAg8zB3jJE89qBWxgf4/pw/SKJFXrPqv6kR9gc5Enp0MLTLbi8endnLVrX6uA7nr+Wj809b7A6Yt+VRTejtP36WD1CbRzJpyXGXWk8JiMqTYtrkVFertS/Kigi7LCD4c3GSsQ5ZehfeDQZ0VwCcmhsIA33YhADS9Yl2B9yJxAcWOkFH/f4HomOErRaAC6EX058aGEsCNi92NRQpPnVnTh2Q0Fp+bEYAqgyu3TEbA1oBbDjkCt+iNulN+C7ZShmo0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
working, since it relies on hugepage_madvise to add a new slot. This
slot should be picked up by khugepaged and eventually collapse (or
not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
enabled, khugepaged will not be working, and therefore no collapse
will happen.

DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
the address range synchronously.

This new action may be required to support autotuning with hugepage as
a goal[1].

[1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/

---------
Benchmarks:

T n: THP never
T m: THP madvise
D h: DAMON action hugepage
D c: DAMON action collapse

+------------------+----------+----------+----------+
|                  | T n, D h | T m, D h | T n, D c |
+------------------+----------+----------+----------+
| Total memory use | 2.07     | 2.09     | 2.07     |
| Huge pages       | 0        | 1.3      | 1.25     |
+------------------+----------+----------+----------+

Changes
---------
v1-v2:
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
index 3aa5c91548a5..c6476e63f4fb 100755
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
+            'collapse': 5
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


