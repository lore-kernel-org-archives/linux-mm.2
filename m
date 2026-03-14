Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DD0105F79E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 09:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DB246B0088; Sat, 14 Mar 2026 05:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488EB6B0089; Sat, 14 Mar 2026 05:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394A26B008A; Sat, 14 Mar 2026 05:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 273A46B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:39:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAE6CBBD58
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:39:39 +0000 (UTC)
X-FDA: 84544171278.25.E5750BD
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB62A40007
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:39:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773481177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=uN/zxNZubz/uKysS78yjb9+i0tKZgrsRIbGkmRKYObI=;
	b=aFefXEwBPZ4UL4ydXB0+/ZiHDD0uvtAAH4eofQfCxyPVAVI4YGUCACS47Dc01/Z+jA0B1z
	ZYOP4SiuQFAhe5tIoEypT1tJUqkRdXKYyCAbtVbbE81KcLh5URw6lGbgSiHSLr0rUTB6Qg
	gtOewdEqHP1Ao7VDWGUH9TH2gE2yBFE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773481177; a=rsa-sha256;
	cv=none;
	b=cWsBvrIPI0+lgR7xgfVuDTM1SXRw1qwcTGKq4rTrDXA6Rn7bJfnzCHzFHVnBBn0FEie9L3
	Wf6A+ryYl7NIFdvaJ+Px10Ho/2UNoPWikdLcL70V8Cwk20n6CFmHtKthCAczaMJ7oEIYjd
	iAAOr/8JBKmD3WGjsWBEsR/CbOEFr30=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fXxB74vcVzJ46ZK;
	Sat, 14 Mar 2026 17:38:39 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 9BCE940086;
	Sat, 14 Mar 2026 17:39:30 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 14 Mar 2026 12:39:29 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1] mm/damon: guard THP-specific DAMOS actions with CONFIG_TRANSPARENT_HUGEPAGE
Date: Sat, 14 Mar 2026 09:38:12 +0000
Message-ID: <20260314093813.1359737-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB62A40007
X-Stat-Signature: t6ifir6wt15w7krc491riyjkepdrtmsw
X-Rspam-User: 
X-HE-Tag: 1773481176-615466
X-HE-Meta: U2FsdGVkX1/8knqe7SNYOQTs3K34dFl3l7ZXkKCVeWbBuXqsDJlH27qWBbDI6Bp3MJZ25EOB2iNyoRPcc6wvkqBZJEvgILiHggg+P5DmgSk+krzsSElQqfNGQDaQR4M4EKq3CCLydSbEw5GlknMtJAaADz6EadDjiyXv/CcAGBSlASBaL/Ur/TheZ4iMKgLcofU7mrRJv25RCUNmvltpJpxkzZmK2y1foaDenKbooKSiyKIsZ5MYMIWeYkuWedoIDJPmSEzjIaIU7eoRJvqgapADC5Sll0hBn3r6qBNNkvmLgfXpalV20CgBhISwAbopeNlLeFE/gIGiGP55eBgR3tcweWKN6dyeiKCsyCnryr4cw7cdqIg7VWk+2xIjGk6IM2GYwgnNwOBqafiob1pd8WZEkDbw0q847vsIj+Cf1nTCV0xT7ZHkEVKk0VgdZUudnT/JawuDNUXT1LnT8xCxPMh9SwohD6wpvmfZ43jcHURS1FcHnArYOub9KcA/a/0LUzkKyEIdUL6STEOcr/rQwuIWdu6RACBuGWBiIyysDfQ2DwAYW6ncxDqpldxePQ2ONy4xG4YHm/TFjw9cSIzNkYJA2vEHbRQ8Ewfc4r4qHTe2hwghfutNSYUzLw2Q/MkX+32H1x/0IApU4HBgFdrhoR7HULRN56IXs2klGVhOh/o+a6ZO2bRuxmXn8Aa6W3mzH5RdIHEn/YE9zooLK2dZ//uD1BJHXfEP8S12lReTuMIEByxWt4AZdXHfBhiOBrvMa/Wc4+dX2ciH+dZ/iGO+f09mUkbdN0BiEi1deyFKXNByWmbiQnZr7/c3++EDY7eAOVXcJ3FDzv64v18rgAcNZiD+/I8J+bnkI5U9R71GXDzbvzUOeEzoV3vvInFHj21O0oThgWLdSBTkSnmLLrWD9Ao+GqlhiBaYKhS9kvv9Ck+wlGt3Dn0oWU+w91HZYpUpOPLwLQCNo+knNhLOvSL
 VvjRLCLh
 JxpOfcf1RRJCk/fWmEqC/6OiPWfZs5vraAvT5jrja/6J1w+k66an6EgxD62JZA4t3clqVerggVUNwPZepkUGn30MqscHgqcJYRVYYPVRceVkzHOtBjptr1H4YspmdrIWoCxxw3NjNg9gQ+PQDDd8aA7BW/v9XxsIRNwnHrwROa85OqVdIYUNgHylyUm+mtqRgoAzvfmpdNFb/5oURyrmngH3RgK4fXdw0Z5UxzduOi6OnjMHy71GH2CNybgpjIRyeibi8+959oLtbKKF86RYzO4E2qen/5MiGLzz6NZBDIz/ZaIlIXJQOJlYK/E2wOebsiF5W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

MADV_HUGEPAGE and MADV_NOHUGEPAGE are guarded and they are not
available when compiling the kernel without TRANSPARENT_HUGEPAGE
option. Therefore, DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE shouldn't be
available to the user either.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 Documentation/mm/damon/design.rst | 6 ++++--
 include/linux/damon.h             | 2 ++
 mm/damon/sysfs-schemes.c          | 2 ++
 mm/damon/vaddr.c                  | 2 ++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 29fff20b3c2a..207219ee10d4 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -460,9 +460,11 @@ that supports each action are as below.
  - ``pageout``: Reclaim the region.
    Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
  - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
+   Supported by ``vaddr`` and ``fvaddr`` operations set when
+   TRANSPARENT_HUGEPAGE is enabled.
  - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
+   Supported by ``vaddr`` and ``fvaddr`` operations set when
+   TRANSPARENT_HUGEPAGE is enabled.
  - ``lru_prio``: Prioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3a441fbca170..b3fcbe84b5d7 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -138,8 +138,10 @@ enum damos_action {
 	DAMOS_WILLNEED,
 	DAMOS_COLD,
 	DAMOS_PAGEOUT,
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
+#endif
 	DAMOS_LRU_PRIO,
 	DAMOS_LRU_DEPRIO,
 	DAMOS_MIGRATE_HOT,
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 5186966dafb3..05e57c7ca2b6 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2033,6 +2033,7 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
 		.action = DAMOS_PAGEOUT,
 		.name = "pageout",
 	},
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{
 		.action = DAMOS_HUGEPAGE,
 		.name = "hugepage",
@@ -2041,6 +2042,7 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
 		.action = DAMOS_NOHUGEPAGE,
 		.name = "nohugepage",
 	},
+#endif
 	{
 		.action = DAMOS_LRU_PRIO,
 		.name = "lru_prio",
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b069dbc7e3d2..19c488660027 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -897,12 +897,14 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_PAGEOUT:
 		madv_action = MADV_PAGEOUT;
 		break;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	case DAMOS_HUGEPAGE:
 		madv_action = MADV_HUGEPAGE;
 		break;
 	case DAMOS_NOHUGEPAGE:
 		madv_action = MADV_NOHUGEPAGE;
 		break;
+#endif
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
-- 
2.43.0


