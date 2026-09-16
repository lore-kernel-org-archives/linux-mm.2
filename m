Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC6B4C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D754F6B00A5; Wed, 16 Sep 2026 06:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4DF16B00A6; Wed, 16 Sep 2026 06:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C630B6B00A7; Wed, 16 Sep 2026 06:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A74C86B00A5
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:21:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C403E1406B4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:21:16 +0000 (UTC)
X-FDA: 85219232952.23.9272D54
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	by imf06.hostedemail.com (Postfix) with ESMTP id DEDF5180002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:21:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y6uBj1Olos038W3KvsSLXsIiIaenLd2/Eedbt/JhXQI=;
	b=WSO1fnrZnZISN0F+CBflTyFiR/ZgVcCJtXp/0BnMFwX4S7prFhvr45ORHumiGDZd+bWgjG
	k0DxmV+VA2o/t2EzFNi2vg3Q3nuh7K/mbXlEL+maR+Ez4B4qWIdxzLVb+e+406Jt1UacC0
	SaODGwuxZQbM1c95k9LWCI7WB8mstgc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554075;
	b=7XNdzqsoaij942gNKxjcOq2OTpQYunBMsCA8nYRYMyEH1O6DepHSWyPxRdfnBuYdWLnZ4z
	UbjB7Scbv7AeSM7w86puEWog2soR4WVwEIAI2ocmPF7BQ/RsNWvD25XeX5HqvA1bMWmoUi
	Jt4CFCSY0+LOTmwVJTL77/oejwn694Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8cb4c72123f0ed8d;
	Wed, 16 Sep 2026 10:21:13 +0000
X-Mizu-Trace-ID: 8cb4c72123f0ed8d
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 12/14] mm, swap: cap xswap growth at nr_clusters
Date: Wed, 16 Sep 2026 18:19:19 +0800
Message-ID: <20260916101929.149106-13-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DEDF5180002
X-Stat-Signature: h3gf9jqh8tasu4yewjghpbfzacobt9u3
X-Rspam-User: 
X-HE-Tag: 1789554074-900231
X-HE-Meta: U2FsdGVkX1+DOQESN3mF6aWA6BZfKzyZW43u64p+1HK13RBLvIAlI5oynJOwlyfS/Y3lQpaDD34Ph7UsYR2wphVeKEryto5sekKI6HEleyg9UbC1PHQ5TpAzyU31Ov5u254mCpe8FUpPK0XzfOJpubLwG9sx1XBKBfoH+jEYUIOqqfMYAd7oZ1N4rwCCXUTEm0cxXwnBr1b5/sUqMsYwwfJlZzrOlirWMMeNtDvKXxyyLptPZNLtihA0w4QkDYyy9RPT1AjLjoMepcKmJXBDneWHwbPUU8HZRO4/gbUJseqRaVgaRUa+GnWEJVTLKYLgurKhrz05cOc86IVKocJMas4OBSyupK4Wc/WRV8lsmmuq4cplSowK0mBP19ftVWDoCLmxRLlBXo2eSzgyUTJvBmI/AB5UVvd5FuLS8Jsj8gl/K4jeptIwzfy0AmxdfwQRm/rcYgC8YNgka2HjEFQXVCANrT53dhJpJ39vAiuSL84zg0Ae0GWSTdzk77yWWtFlueePa5dawBwY/b4wuC/Z7Ll0HhvFw1BkBFBunpZIkMFB7/RJDOHVVGQn+wm9QLQvpov9j9LmRBzVK/X9obSk7msFagWmSDjw1/QHvi1HqbcRL2qKIyHsXLWxRU3blYh0zVA5Hm/X2/ckGz6Cn5MSwiHNY6dGu269bs5LSq0vzh+L1qBz93rR71yb2wO+mjC2h26MRGrt8g8zWek6wLdxbMVcpiM5qIL1+c4UkdShZpHXprs4wZ/nEpuUQTu6GTytYtZl1oIKgknpTEezFytOa6X8pf1Khuar1qt7zcLgsahxiVXZl5ISvM4Pty1g+/nsZON35auCzbEketM9KI8FsyyeK9oNyh0LRq1ULpylLneUS8vHdJPyvq7rbSj+EoQpdod6OYIbMUyWkYxKZG9zzoW5hxt7Xy+kY+RIRaMf5Iey3FiTnYViuw8dGJrKVsWgSFYXULb0gaWzHwydVYj
 OW7CWEuq
 YvsVErEiejQr4xVvuBeBQllS6MNlIxXsjjG17UyvDHw7jJQBISdanRI8dxSKbL+ortFzUdaq+Yx1JT5f51A8SH1uQ8yGwozgbhdQJ+2+Dhp9F8ddhFCQRUdiOZwqULM6A5blwuZjWC/iT3Hmn5OtRHcVadBdCB+mHmK4Erj5nzOGynxxV+a7hyyvz1GVdpq/26jZSSX9e2gIxUtWiaCuLc/aoOmPfhnpMxlBW9Z1HUUbFd8df+DlznPI48zBjU7sOmsSUaR2ruK3sMk32jPKoSHHahP8zD8srane/7K7K/gZUlCrUEMnEl9QmnYzgSMn5pzIiqDlgeEdq0J6CXqC46OXK+mhM6mqv4Efo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add si->nr_clusters as the ceiling for the cluster_info array's growth.
It starts at the whole address space, so nothing changes yet.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  1 +
 mm/swapfile.c        | 19 +++++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 30642bb481df..9fe82d0f1740 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -245,6 +245,7 @@ struct swap_info_struct {
 #ifdef CONFIG_XSWAP
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for cluster_info */
 	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
+	unsigned long		nr_clusters;	/* how far the array may grow */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	struct work_struct	xswap_shrink_work; /* deferred shrink trigger */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cac084bc72d6..2cf6ba0bd0c0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1319,16 +1319,18 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 
 #ifdef CONFIG_XSWAP
 	/* For xswap: grow the cluster_info array, then retry. */
-	if (!found && (si->flags & SWP_XSWAP) &&
-	    READ_ONCE(si->nr_clusters_mapped) < READ_ONCE(si->nr_clusters_max) &&
-	    list_empty(&si->free_clusters)) {
-		unsigned long nr_new = min(READ_ONCE(si->nr_clusters_max) -
-					  READ_ONCE(si->nr_clusters_mapped),
-					  XSWAP_GROW_CLUSTERS);
-		unsigned long start = READ_ONCE(si->nr_clusters_mapped);
-		unsigned long i;
+	if (!found && (si->flags & SWP_XSWAP) && list_empty(&si->free_clusters)) {
+		unsigned long ceiling = READ_ONCE(si->nr_clusters);
+		unsigned long mapped = READ_ONCE(si->nr_clusters_mapped);
+		unsigned long nr_new, start, i;
 		int ret;
 
+		if (mapped >= ceiling)
+			goto done;
+
+		nr_new = min(ceiling - mapped, XSWAP_GROW_CLUSTERS);
+		start = mapped;
+
 		/*
 		 * Mapping pages can sleep.  The lock only guards the per-cpu
 		 * cluster cache, which this path does not touch.
@@ -4294,6 +4296,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		cluster_info = vm->addr;
 		si->cluster_vm = vm;
 		si->nr_clusters_max = nr_clusters;
+		si->nr_clusters = nr_clusters;
 		si->cluster_info = cluster_info;
 
 		/* Must be initialized before xswap_map_clusters() locks it. */
-- 
2.54.0


