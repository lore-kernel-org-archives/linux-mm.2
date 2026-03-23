Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E2A0F46139
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28F26B0088; Mon, 23 Mar 2026 10:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9DC6B008C; Mon, 23 Mar 2026 10:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF2D6B0092; Mon, 23 Mar 2026 10:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D68D6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:58:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 574C11EE27
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:58:18 +0000 (UTC)
X-FDA: 84577633476.17.B26C4AD
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1DE8AC0004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:58:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774277896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sNsIVatcWFMLFxooESbbmvJL/fQ7XNaFIEB34HY07NQ=;
	b=FWRKlYxkxhz9VtU/hoA7HBQCjJEa9byspzaz0igC3xTdUd9FnV7rpJA2IJqfDA/6D1BwyU
	Qidvl8pGG/jLmVquuLk/7Ofo3lmrbhxSS3VdlUtFkYhG3c3z9eQU759qhlNWpPcLjCPYG9
	3EqHUMmLrA/LZwSnc49axg82XBFSj80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774277896; a=rsa-sha256;
	cv=none;
	b=XEOpo/RXeap1aW5d1iO3JEyBVOg4Q9v4hFWEFMrM2JlD1pJ4in0J8v50oLswFEaCevjvQZ
	GKfuLkWHaCLaGpTIYhsOa6Pz98VS9QhiONnssTjwNVDWM7udrAZtL4oyHkgbgp6rLGK1er
	PEd7wRsqlmpN5PqZbvwrfitJXuqOetQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4ffbr45g9RzHnGdd;
	Mon, 23 Mar 2026 22:57:40 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A78A40573;
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
Subject: [RFC PATCH v2 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Mon, 23 Mar 2026 14:56:46 +0000
Message-ID: <20260323145646.4165053-2-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323145646.4165053-1-gutierrez.asier@huawei-partners.com>
References: <20260323145646.4165053-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 1DE8AC0004
X-Stat-Signature: difum7pj6u4iybbhdnsf48nje3m9hq5i
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774277895-395036
X-HE-Meta: U2FsdGVkX18T/oFjHB1ylPBmfxia1muEKdZQtEa9/VMjNOgemkRlMiSyLo8KUrB+e3AbOlD56KSBK6xrqkABT+od/zIc3EgzthyJsLxlHuYo1mGDKjKvAq1iSt7FEdXuVWkOu0m0DgeR8pR7amR0nRMujnZYxXc6JTm+lEWg/rI90ydzhmAhodL3TMVGQDeZPcNqBPxdrx5nDboLUCF9o4ODBRmekRb0eVh6Xr84ULCO0SMMUNGhRgL/oqD2gnHgxeozRaGXZ/11c90H5j8ViKK7xrQl90HFZUTuIjzoKM/KI2lwuwR0fWhtneujjPrvnjwe9/Zl4707CK7RIDnPRcHWaQl39DO13pAd5i40IpaiPSxE3LS38gthDgtB/Q8S0vv5LPEXKJ7Q8WIfzk+9mtjoCE1X/Z7gmq8an5dCdrIDRJGShFfbJiG700hoinLylYfa5JzLn8YrVQ7JNyxULtHRNjGBXn591IXBa5/PKfv4cjmdeHoJUKdL+R69BrmFe/b+bT5+Gp/z1MPPIUPSe+WXmXT9iwaTQvkCIKM0Jp52jj9d7nwM5t0lAWcvAsOdgaeXLI01CaJRPqjCYRiHeuvXEspnVmRQYDSMVgZi0ip5YQBQPLKL0ild8rb1gzfDzc1VNL5ih2SjJnqh2wfwKpOepiOsem87ZaEzPI47z4PPbfzahYxkud/egAOqdOhf74kjDO3dTowjYnJcsV6ZXecsk4l/VPk1pPtb8Yaea1+LFjLLED1L0ji8vH38gIVu+2jVP4U0t/GP2vVnrdiU3Z5D9y6zGFx4mxX2FYuZIPeq7Le8I5XMTpUv2fy/hRPZBAjLx4CYagcWMQWH8EIX6soS5Ddh+UwNmLpylgg0wNSfL6bqon1La/zNzie75bGkeJMl4Pt6TXx6PpARco7U73dLJw8TmYd4gkR2ckZVsA7k3icQeV3+WZFVvtt8wWQdhmKowMarGuFbUy/2ErQ
 8v/VRhX3
 C3+HhQhddtWhc8ZWRF50107WMgCqd5ghrDgjJ4gbGX1+4Gws+3BGMOzNFNQ4sT7KB44Mbsm8axgNA5t7KLfv36Q2pyYAXVwHhflpE8qHr+V3QFtW1Vo+EvsgYvgx8xNx9o84eg/qxN6ASUTev7KE614k+/sLJxLpRi0ImZKn5WkRo2gvbF0zwQMFYcE67V136HyVnGhjR0wJN6fbucNpRcFasYLT6cRZhAuClAJZgmZZRkwKEgLgN4LYVOMXFT5Ub8R85vH7oVWzqkVVnjf5xz/zudIXvihUYhWccHFYCI/e6Wfs=
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
v1 -> v2:
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


