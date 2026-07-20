Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 467ACC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6B36B008A; Sun, 19 Jul 2026 23:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E0F6B008C; Sun, 19 Jul 2026 23:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D986B0092; Sun, 19 Jul 2026 23:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C393B6B008A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:03:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 448521A070B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:03:49 +0000 (UTC)
X-FDA: 85007660178.29.7646B96
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 828CFC0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:03:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nVSZBLG+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784516627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69Ct5gp9rT21SAwaHS4XMcVk/1fLHoPDTQLb0SWSnDU=;
	b=g/ZAwfjpn9O+oWvMqVddl289kg0xKVgwej5ntSTFbgWa/eQ3XjvH+vOCAauDLv+AJUmfu6
	jfjlzoULClZ5Ffa5ZSuTWj4NIhCp6j71Rf52HgKt9hs7yIRZsXCb6VI+fmfmfkPpcy5dlt
	EwEVL3OeTFlIRTC9hZN4HV/DPz75y70=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nVSZBLG+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784516627;
	b=7cs9cjYQkcVUjM992IVoUQCH6R6hoTUpF2fEm2CBiewR3i2saZvLdZV/ZFp0p3XGVljaq+
	Jj5jozygRbujTISBzSJqRqnW7UWfhZmugdFn1Dqe+wH2xqjAvfZ2Az2QZbab/TD39Ok4CC
	h4MgBUZ95lK+wR8a4M1IIHtvBtJihr0=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cad4170e8eso129899585ad.3
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 20:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784516626; x=1785121426; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=69Ct5gp9rT21SAwaHS4XMcVk/1fLHoPDTQLb0SWSnDU=;
        b=nVSZBLG+Tl/WrRlLF0I9g6BvanB/pGnlY8D/8eLaOu6fO8IMQLRR6LWkKVsBbF1Jh8
         ngliPmed1v/7wg/jgo92ERrvtFwme4zJRCqUl1OC+vbVoZN8OzGGaTMh/ERnWOodTG4Y
         iketieTypnLCFwHaG13QSn0x2iK2lptSRoHBu4n6HaxH1mnBiM6DDNPqoKeGpoR6Pkyr
         IaiLnrpfHuAboQxMjDHyGR4KRz/zn4xlRj6scYbHY5sXccMNplFQ1ak/u6rkKVgj41TO
         7ibEMoDnNKGjP15hSXlLi1xUMWkZQNec/5h0TgLC7nYkXcRuFdvcNLH6vpTT7gsUP9VN
         kfow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784516626; x=1785121426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=69Ct5gp9rT21SAwaHS4XMcVk/1fLHoPDTQLb0SWSnDU=;
        b=kXCHFsOi4IdlozlslJ71SZDt1fRAR+ZyPEBJwE2doX+a2c1F5+Y/y8EAsqNSwd0fhC
         ULxTjOIWcXB/vt3JNUAbBz+ZgLGoyl+0EC7gO3hu05WPz9w7OlhVibMA+epCzQeeCue7
         WI5ty6sEBEgBeqsBI+6gUb0VXX8TvwDD0+gazZtXTrwLcRn0GW5OX/zdaK3RS86vuR9g
         WFADViGx6j97Kkrvft9GpOIw1jE5UlhJKjCvt29I3Og1VNv9v1rdYNLDOK8QaVOB5hFs
         mlQUGDm9CSnUefXdn0s5vT8HrlduLNbgTw0RcDxwgxvQJMRxXzAlk0MtSoYiOkX62S/m
         rlzQ==
X-Forwarded-Encrypted: i=1; AHgh+Rohv4LYtRZvKlWx0Oukzc+foNmbu1xer7EzCs2K9jvrNrtDpAoXqH5O37NqelN2CaaP3zABCEgw1A==@kvack.org
X-Gm-Message-State: AOJu0Yyq1MP6H1F1CZ5DNoOCWvonPgyUX+dXcthUwh3gWBFuS3lhvFHJ
	+Zjq7ErzKVYXChzfhzObKiNzV5AfzyV6z2lIrYojVzD2wVDeCZLyQ2oK
X-Gm-Gg: AfdE7clJazMBqB9F5oC4tqRQae/IBnoOjm3gF8Mw5gxG2FbftKq8Q8eKjtAGhRGGXmR
	ta645GMafj8MLQaR/xdEeRS6wGgLHK36GymSOaIGUADML/Gt2Zkv37KLGauYGxzbqVY48uf41oe
	1exBRIuN0QCzNq6zxJ+1vOXwnJIWB8gMhtb9lXKlYR5gUAKFLSMhsYo1EcWuVozupO4l006m+HN
	t+eSuYfAAfGDNHA0M52kJ3a5YtL0Vm7y0MhYtNFv+18mBKxl39/AYd7EZYghUcDnUs8yTWoHsTc
	9A8HlZA7l7wSImJJPUStIWd/Bf+QuODJScghHlIXuLmaSc8A4nlR/0XdARMrY3Hk8p01TfoMdmA
	a9LgOwqNxIUC8lglgojb4MfEbCnmWhwsF3hro71DKZigrnIn3nuvP9GFm7Lj/vsbeGwy8tAiTtm
	9fcDTEe5qewnwFMteNcCYZRy+dThU=
X-Received: by 2002:a17:902:fc85:b0:2c9:bd37:ae76 with SMTP id d9443c01a7336-2cf34a3ef59mr139624465ad.47.1784516626163;
        Sun, 19 Jul 2026 20:03:46 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344d80e6sm47783065ad.29.2026.07.19.20.03.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jul 2026 20:03:45 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	daichaobing@sangfor.com.cn,
	wangkefeng.wang@huawei.com,
	gutierrez.asier@huawei-partners.com,
	zengheng4@huawei.com,
	kasong@tencent.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	lianux.mm@gmail.com,
	lianux.wang@processmission.com,
	kunwu.chan@linux.dev
Subject: [RFC PATCH v3 1/3] mm/damon: introduce DAMOS_SPLIT action
Date: Mon, 20 Jul 2026 11:03:25 +0800
Message-ID: <20260720030327.80153-2-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720030327.80153-1-lianux.mm@gmail.com>
References: <20260720030327.80153-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 828CFC0004
X-Stat-Signature: 3anekxkuq3ebtguu6n6mbzu39d3az4rs
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784516627-464457
X-HE-Meta: U2FsdGVkX19TsZsoYVg4WfA4XduAXqf8WUjFpwdeIEcpsn7vn1c5+KhJ0ZH6GjJ9qWvEGoqg9xWcC0sI1C3+zdnmKosqarL8AI/OPVQg6auSEQUtTec9cHrDx8E5cxat3XzuJ+Z7AsnxEHPJbixEvWKCcBTJafcpNqL7XJ2FWV5tqwOxGsoKZauWDo4RsyebqIH6jQVcno2fXXKuLTEGOQknH/3l+rfUoKtwfDZunuomRVMEUkSI8+GSWzaTOVptN0Hc7Rm/PhpsheQPc0I5UDnpurmKWzA4tErpOCT+elIh7NUV33zRVGpQrnA1FlLmjySRml7FfyAlRZ7/U8FDn3TUKIJiIAxmYEvjHzZ3xG2ul3F/eM+HDlRp3HhibwxKYtGFntB2O/iNeWk6GRibUVpHeAZJzQuiWwHPAJK56m0whtuF+3AXYNTF0zB15jN5QsS9qgjixwLP2Dl3ovnE40tKwT6+tXZtD9rmGWhI9F1YkWFMLm5apWhMHVOtHdVVkVgBpsz822JggOT060yMR1yNE8u5huMtuTkDf6U3n46LItL8nQLmPgc0b4wZhqICBEOydkaYZ9BHselbZ7r2I/TUBa13VhwqMqwuAhVT4cQtpPBcVke9OUqeK/tOoVmX/mYGjTxsAj3qQ/R/D9mpPlQ1zeNRBO0nc9YgndYxflJNz+QAtVK/cHSJQwhFBQiaqsNlaOcrtjK0nfRd0zH+qyVfUhwb8SvgfeEiyylZYKEkdz7LeqMKLmItaf2BJIgXzJM3dWlZFUlcalUyZdlnDtQ5VYXKde29D2f4R660v/svhO8lnwae8123i2YQEJQx0GnchE/aa5uMxe1PZuc8metR5Z+SFJ6ztRZJk323wMhkyqLUz9+wvrh1YVcauc5GwjtFwnLa0/3zRVn3Jmh6Abb9PPU1IFeAXl2QTS5I6TOcNElsZxiI41LSsWzZxmoR+GcCO638GngbzLHhF3L
 JWLnFmeb
 J7gKMRGPZHyRZ90AJZX/AqB19KOs0fJVN8w9uqc9fXjFZUs6fFwVRdZNVrqwAgou7EtunGV9+9fl+JRBbLN1IZ5cBZvi5OTbaUDWAOTnTq79JTw3oIupjzGqJKoRkZKRvl4tCFL8MrC19srsIx6BhPzp3G9UG+Fnnxto1ESJ/eircoDA4T4q/YRtdGIsSb7/6G7aBS/ommhMYc1ps8xfntj7/8iI57/dZD148pfQim/bSx4YCTUc0zQE8D2HRqeL5WO+VcWLwNYRm9Rw0d8SV3R+SLGggqhsdQ7iAO3Cn7TioK4zfPGCv4gSV+TwUgpPBM62Y6ouQmRA6wUkNCmQrj4P/VU2h/hEC5WIZwKRKURj8O8fTiHs4FbRNOiWsCpVtqciToJQWvK8lT0Lh3+6ed5EBDw5PAxFCiQx4Y7PY7tpvagsORqNd8WJckjN4+RFZXz7ZW0EKshHnpAKncQW2grej7PA1Tt8klHoTjA6xPycBjgAoDBJu6T7loWtByiwm5iUhayNAc09RIyp9iXQd9HJMOGqLhrC5W8cjmMzAlQ/K8oeFG/N+EFjolO+ThPWigohMFjxLcurt7TQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new DAMOS action, DAMOS_SPLIT, that splits large folios in the
target region down to a smaller order.  A new per-scheme field and sysfs
file, target_order, selects the split target: 0 for order-0 base pages,
or 2..HPAGE_PMD_ORDER-1 for a smaller mTHP order (order-1 is rejected at
store time since anonymous THPs cannot be split to order-1).

Unlike DAMOS_COLLAPSE which builds large folios, splitting only dismantles
them; it allocates nothing, copies nothing, and no THP admission policy
applies.  khugepaged deliberately refuses to collapse a folio to a
smaller order, leaving the shrink direction to callers like this one.

This patch adds the DAMOS_SPLIT action, the ``order`` field (placed in
the existing union alongside target_nid and migrate_dests), its sysfs
interface, and documentation.  The vaddr operations set handler is added
in the next patch.

Link: https://lore.kernel.org/20260605161422.213817-9-npache@redhat.com/
 ("mm/khugepaged: skip collapsing mTHP to smaller orders")



Co-developed-by: Kunwu Chan <kunwu.chan@linux.dev>
Signed-off-by: Kunwu Chan <kunwu.chan@linux.dev>
Signed-off-by: Lian Wang (Processmission) <lianux.mm@gmail.com>
---
 .../ABI/testing/sysfs-kernel-mm-damon         |  7 +++
 Documentation/mm/damon/design.rst             |  5 ++
 include/linux/damon.h                         | 15 ++++--
 mm/damon/core.c                               |  2 +
 mm/damon/sysfs-schemes.c                      | 48 +++++++++++++++++++
 tools/testing/selftests/damon/sysfs.py        | 11 +++--
 6 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 907a504fb64c..ee8e260a631c 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -265,6 +265,13 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Action's target NUMA node id.  Supported by only relevant
 		actions.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/target_order
+Date:		Jul 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Target folio order for the ``split`` action.  Large folios in
+		the target region are split down to this order.  Valid values
+		are 0 (order-0 base pages) and 2..HPAGE_PMD_ORDER-1.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/apply_interval_us
 Date:		Sep 2023
 Contact:	SJ Park <sj@kernel.org>
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aed6cb1cf483..87a801954b1b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -549,6 +549,11 @@ that supports each action are as below.
    Supported by ``vaddr`` and ``fvaddr`` operations set. When
    TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
    fail.
+ - ``split``: Split each large folio in the region down to the order specified
+   by the scheme's ``target_order`` (``0`` for order-0 base pages, or
+   ``2..HPAGE_PMD_ORDER-1``).  Supported by ``vaddr`` and ``fvaddr`` operations
+   set. When TRANSPARENT_HUGEPAGE is disabled, the application of the action
+   will just fail.
  - ``lru_prio``: Prioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
diff --git a/include/linux/damon.h b/include/linux/damon.h
index f69442a9d431..88b61b900a36 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -110,6 +110,7 @@ struct damon_target {
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
+ * @DAMOS_SPLIT:	Split each large folio in the region to a smaller order.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
  * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
  * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
@@ -130,6 +131,7 @@ enum damos_action {
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
 	DAMOS_COLLAPSE,
+	DAMOS_SPLIT,
 	DAMOS_LRU_PRIO,
 	DAMOS_LRU_DEPRIO,
 	DAMOS_MIGRATE_HOT,
@@ -582,10 +584,15 @@ struct damos {
 	struct damos_quota quota;
 	struct damos_watermarks wmarks;
 	union {
-		struct {
-			int target_nid;
-			struct damos_migrate_dests migrate_dests;
-		};
+		int target_nid;
+		struct damos_migrate_dests migrate_dests;
+		/*
+		 * @order: target folio order for DAMOS_SPLIT.
+		 * Split large folios down to this order.  0 for
+		 * order-0 base pages, 2..HPAGE_PMD_ORDER-1 for
+		 * smaller mTHP.  Order-1 is rejected.
+		 */
+		unsigned int order;
 	};
 	struct list_head core_filters;
 	struct list_head ops_filters;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 806a67d02a6e..394c62455ad5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -693,6 +693,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 		return NULL;
 	scheme->pattern = *pattern;
 	scheme->action = action;
+	scheme->order = 0;
 	scheme->apply_interval_us = apply_interval_us;
 	/*
 	 * next_apply_sis will be set when kdamond starts.  While kdamond is
@@ -1446,6 +1447,7 @@ static int damos_commit(struct damos *dst, struct damos *src)
 
 	dst->pattern = src->pattern;
 	dst->action = src->action;
+	dst->order = src->order;
 	dst->apply_interval_us = src->apply_interval_us;
 
 	err = damos_commit_quota(&dst->quota, &src->quota);
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 32f495a96b17..725ed81ccf6c 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -4,7 +4,9 @@
  */
 
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/numa.h>
+#include <linux/huge_mm.h>
 
 #include "sysfs-common.h"
 
@@ -2260,6 +2262,7 @@ struct damon_sysfs_scheme {
 	struct damon_sysfs_stats *stats;
 	struct damon_sysfs_scheme_regions *tried_regions;
 	int target_nid;
+	unsigned int target_order;
 	struct damos_sysfs_dests *dests;
 };
 
@@ -2293,6 +2296,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
 		.action = DAMOS_COLLAPSE,
 		.name = "collapse",
 	},
+	{
+		.action = DAMOS_SPLIT,
+		.name = "split",
+	},
 	{
 		.action = DAMOS_LRU_PRIO,
 		.name = "lru_prio",
@@ -2326,6 +2333,7 @@ static struct damon_sysfs_scheme *damon_sysfs_scheme_alloc(
 	scheme->action = action;
 	scheme->apply_interval_us = apply_interval_us;
 	scheme->target_nid = NUMA_NO_NODE;
+	scheme->target_order = 0;
 	return scheme;
 }
 
@@ -2645,6 +2653,40 @@ static ssize_t target_nid_store(struct kobject *kobj,
 	return err ? err : count;
 }
 
+static ssize_t target_order_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+
+	return sysfs_emit(buf, "%u\n", scheme->target_order);
+}
+
+static ssize_t target_order_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+	unsigned int val;
+	int err;
+
+	err = kstrtouint(buf, 0, &val);
+	if (err)
+		return err;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/* Valid split targets: 0 (order-0 base pages) or 2..HPAGE_PMD_ORDER-1. */
+	if (val != 0 && (val < 2 || val >= HPAGE_PMD_ORDER))
+		return -EINVAL;
+#else
+	if (val != 0)
+		return -EINVAL;
+#endif
+
+	scheme->target_order = val;
+	return count;
+}
+
 static void damon_sysfs_scheme_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_scheme, kobj));
@@ -2659,10 +2701,14 @@ static struct kobj_attribute damon_sysfs_scheme_apply_interval_us_attr =
 static struct kobj_attribute damon_sysfs_scheme_target_nid_attr =
 		__ATTR_RW_MODE(target_nid, 0600);
 
+static struct kobj_attribute damon_sysfs_scheme_target_order_attr =
+		__ATTR_RW_MODE(target_order, 0600);
+
 static struct attribute *damon_sysfs_scheme_attrs[] = {
 	&damon_sysfs_scheme_action_attr.attr,
 	&damon_sysfs_scheme_apply_interval_us_attr.attr,
 	&damon_sysfs_scheme_target_nid_attr.attr,
+	&damon_sysfs_scheme_target_order_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme);
@@ -3011,6 +3057,8 @@ static struct damos *damon_sysfs_mk_scheme(
 	if (!scheme)
 		return NULL;
 
+	scheme->order = sysfs_scheme->target_order;
+
 	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
 	if (err) {
 		damon_destroy_scheme(scheme);
diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 3ffa054b6386..49d3c319dfd8 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -131,11 +131,12 @@ def assert_scheme_committed(scheme, dump):
             'hugepage': 3,
             'nohugepage': 4,
             'collapse': 5,
-            'lru_prio': 6,
-            'lru_deprio': 7,
-            'migrate_hot': 8,
-            'migrate_cold': 9,
-            'stat': 10,
+            'split': 6,
+            'lru_prio': 7,
+            'lru_deprio': 8,
+            'migrate_hot': 9,
+            'migrate_cold': 10,
+            'stat': 11,
             }
     assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
     assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,

