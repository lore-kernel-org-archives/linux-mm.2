Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 436F4C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E766B0098; Wed, 16 Sep 2026 06:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118636B0099; Wed, 16 Sep 2026 06:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C036B009B; Wed, 16 Sep 2026 06:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0F306B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:19:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6367112068B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:19:59 +0000 (UTC)
X-FDA: 85219229718.24.72201EB
Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	by imf14.hostedemail.com (Postfix) with ESMTP id 65CA3100002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:19:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.212 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789553997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqL8f8RFMxeywYOpJaNe2pV39z08ayxuyOQMPorjAFs=;
	b=dJCJHq60Rz6+cXDWMvmh0imrysd3ZFGX8hlYU/e8nCN5KIRvB4jYAdrNNnqId5TJs0jH5z
	MwdifRbMx+lrEokoJIFNaQqUCX7iWiBnxubvYsls2c0ubaznW8U9jqX/va6bn+WgoLXX+v
	DUD73Wzsm8VzX0fWc+cBASkJ/fL4BVU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.212 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789553997;
	b=S04AOJCi0TO1awA5lgYtWIqn88VtJEUvxPWLa4L5VxgdIHNx1IEOL5b5wWGVze8mOUYqkQ
	3msnpa+Q7TpCUBFSv6NQ3hxs0atCgmFBogDjclgZznfodZ0bLULqsYwPUbJlZtJ85+rbbC
	HgokIZFnRrW5oue5DD2NVhwLNYCWpVM=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 41ccb50d5361293b;
	Wed, 16 Sep 2026 10:19:56 +0000
X-Mizu-Trace-ID: 41ccb50d5361293b
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
Subject: [PATCH v3 03/14] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
Date: Wed, 16 Sep 2026 18:19:10 +0800
Message-ID: <20260916101929.149106-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kauibwz91upufhy1ks3kmmstxzur58s3
X-Rspamd-Queue-Id: 65CA3100002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789553997-566638
X-HE-Meta: U2FsdGVkX1/bRAPDyHt/MAFisZsyLUhAzgyd/1vzdU0+G5ngRpnKvWE8UQG/M4vQoFQEJ5LnZ+zm8AwqtxFv+tjslqdUzSOKMPvd/IO/1eESoNKeHQZH9icvOYnPKZraJXlAyEA3GEX3a/KFigiQU2erz66fhZzXb7rCiIrG7v5sRx9SJu36IwHb6dO7OYQ+2zmQ14iSHNyi6B0j/YwCGjov3e851NJFuvcKYiwKVBILrgGLrVnOJGve+Pgcuj0wMF2TnsvG8i/HVZNbzgGzVzzrrxgC+lbVZ3VUGan0G0vZxdKjYSaYJyWgq5ooQQeNFIZZUa9WK4uuNAuhQh/bDNXBif6viRB/LMkkqVx8tHtjiF3V9HJAqGrA6ax6nJsS7yNYHpnyT9I9mqlxWpRemqUrd30ZYqNIYIjRyk3Yrv7Lix0EVFjYKN3WSpoOBpEJ7ZNAgjlFydYIX0+5bdfdDDv211UMcM7evQUjGQjajplRYnUbpRRevZoFpKHMoAqaDlMnb9p/MjDoi5CZfA9MN6PVP6sQD9AKX+STT4OTW2clFowKex5sOPNd7TE3Q3a6d6IgvqEJtgQl/VEqh8vMgpftC9QNNvlvSlb3lYBU76E863Pgo3WVWzBn0XndeypdV0eX0M8UoqAt1yWjLdqG9c0Magd4jYo63uX8yYW1Wf3cr2Rf4wagkyV3OnAjUBgTgKFICrdCABy37oC/AHR0qi1cp5/NUc4vPV5v6eWMPIYNeppXYCW38TiVWXv0j8fXBNW5GFYBFyf8bDDa5kiVBu8pHut35ky4c0KMTXD57f9yheuB9Z0zYzi9h1jravsMghlkmLYMR9w5TU6yVfuFSAESX/cNLL6gtBUfTeNVy97Q/LUwymz0Lv5PsJKQ3TbEM9yikf29rAWv+dKzfAEEQNE9evWWlbuhVWga8QmMVCS3o5EWeSB7kTfA9ADVVVcemsmPdBfWZU84mdiiJtX
 KfRaqWTC
 d/STufkbtjWP3x08/hn8rhBd49h10YNlec3+jvLrav9HHu5Td7nOUsRYwPaJ78Ek5lOiLcqZeREZw+dvX0f5TNOsLGli6LuI5RPa7fzQa4mWjyU3M5g4OEpK1K7KCCEBL4TfQlegyDdGAEQk3PguftyKvEAaJXb18PGVVYyyBGhVccr7+S0L31keRpfuO/FHI07ekWhiYH5s+jJodwPdqGgciFewM9NvVArnXrN4T4UWYbtgJkZ7sMUKugGKXDOJGea+9KlMTaR8FH7yzSLpan9zKnOWkVfWRvKSIzKmG+6rkNTBTCh719Yhx8jLGjyagc0KZ1n9gr7C3d91yAWV5+HiGTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change free_swap_cluster_info() to take struct swap_info_struct* instead
of (cluster_info, maxpages). It now extracts the fields from si and
clears si->cluster_info after freeing to avoid a double free on the
swapon() error path.

The new parameter also lets the xswap path access si->flags in the
function.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 13ae681acf07..4b260f9760ac 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3142,14 +3142,17 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	}
 }
 
-static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
-				   unsigned long maxpages)
+static void free_swap_cluster_info(struct swap_info_struct *si)
 {
+	struct swap_cluster_info *cluster_info = si->cluster_info;
+	unsigned long maxpages = si->max;
 	struct swap_cluster_info *ci;
-	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
+	int i, nr_clusters;
 
 	if (!cluster_info)
 		return;
+
+	nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	for (i = 0; i < nr_clusters; i++) {
 		ci = cluster_info + i;
 		/* Cluster with bad marks count will have a remaining table */
@@ -3161,6 +3164,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		spin_unlock(&ci->lock);
 	}
 	kvfree(cluster_info);
+	si->cluster_info = NULL;
 }
 
 /*
@@ -3188,11 +3192,9 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
-	struct swap_cluster_info *cluster_info;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
-	unsigned int maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3284,10 +3286,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
-	maxpages = p->max;
-	cluster_info = p->cluster_info;
-	p->max = 0;
-	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
@@ -3295,7 +3293,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(p);
+	p->max = 0;
+	p->cluster_info = NULL;
 
 	inode = mapping->host;
 
@@ -3662,6 +3662,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	if (!cluster_info)
 		goto err;
 
+	si->cluster_info = cluster_info;
+
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
@@ -3725,7 +3727,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(si);
 	return err;
 }
 
@@ -3947,7 +3949,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	free_swap_cluster_info(si->cluster_info, si->max);
+	free_swap_cluster_info(si);
 	si->cluster_info = NULL;
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
-- 
2.54.0


