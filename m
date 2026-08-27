Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49616C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC396B009E; Thu, 27 Aug 2026 05:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483856B009F; Thu, 27 Aug 2026 05:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34BD56B00A0; Thu, 27 Aug 2026 05:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 069506B009E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:45:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8ABD41A037A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:38 +0000 (UTC)
X-FDA: 85146567156.12.3506A80
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F6751C0006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nRuq8UwnwMWDvKGjwOPMN03nIdGBC3F5R2MZR4V6UDs=;
	b=3IepGocnVcv37mf/RXaURF+E23pTEufue0VemwYhZVBHdQZsBfbD7f5LmalHVs382f9rA0
	0l8jL6y/6+G9uejlcumuhrz0wu8Khv+PS5/zACwMDEsxl6ytGryRo4qz70BVs97nXyNW4a
	1E+bsiFyqNJImFffq8y1lQXPYV2gUxk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823936;
	b=6wSOsWlocesy+ZnvbxXwK8swCR3Uqy+d99nhpBQ5LgmIviFRVHi1NTCvCpGepvxMSc+C+X
	Ku032P3NIOQNxz3Dm6JUHpUle3+oKiz8Fow90AP8l1ICbxV10fuq8JypqzvrjiqW5NeSNN
	gfsQbbX34+dILUOxupiOWAoWDjd+O0E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 18403291e118a5e7;
	Thu, 27 Aug 2026 09:45:35 +0000
X-Mizu-Trace-ID: 18403291e118a5e7
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
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 04/16] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
Date: Thu, 27 Aug 2026 17:44:54 +0800
Message-ID: <20260827094509.1016740-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F6751C0006
X-Stat-Signature: 41yb6nik6334dgcrtsdx85sjwcyzpqtt
X-Rspam-User: 
X-HE-Tag: 1787823936-342082
X-HE-Meta: U2FsdGVkX1/OpGdlZ+5h533/wWjbU65C930FQ20eMPUBufrDVt0TrCNc6U+iN9MyM+SnLJYziPI2n+zeQnM1EZttusqVvkVtHO0+qdt9qyBgY8cMXnGV5V6aI1CHuIln4DXvDVZqUlVqWDbxcbU8w0F892LUTfx5r5DTHJFOOXQ2cyreAUMCjZ6t/ePXgk+0E/XHW7Z8A6GbI27+8emUCwtEwafdU2rD3PXBmVDPS80l4R5H73BZSh49D/WYj9A0Fv4Kv4HwsjWRgHW2YBshw2HSGU0etYuWUhWCBSONaOWJFIUHwFTeLQ4fGdDWhhM/1nBRmvQb+4bS1bokZjfpBCI7jtnw+HdjEfIrdC+P8llmhS1ByXszs6UasHvKYz8/kiFVtvdX7OY0MdOlVSi5tONezt61Gu87/d5MBomF0kG0yksrcdYWghFN8n7bll6QaOWebCR0ps29LvwNdibv4Z2dz4P/QU/Zm/7FBoOH7cLM34alNgI+6p8gsUPmE8gpdz7QyAHgg3PiCuTEqbz0mh2WVxxnUjRT85wVh52+vAsFMpc8CRnLKMt5hqyhdjJ6AsaGLF7Jbb2bcyEWG/+yJ+YQ9zXLd4H8OplAN+dnI6ICWmX0GYZfDi4ymIaLoWGHiFAIKOoG/aCR44BlVobQXINtfSo+jIgaVEg6ha2i7iHqg6NpQsaFJsUpZZ0aM2qZiDbpKRk9boL8E1MOSvY7mgj/cYMI7qnu3BHNhd6zk/C9BZEEK2RrnKXwFvPu87HBc+IUi0oUlci/KLWgahXWyAJQc9DKYj++PYtH+EKcINJ24usC3ikXcZzwXNZfO5L9eQyqcNPAEhuj/hyetfAgBfveuQvHQEs+y8ryzKshcd7c/+Kb8N8kml9QRpO/Ow8BsDc/Vy7f6TmesjRNJgr/n48PR3lVFj9ls6FHXxXN7h5iNEayLKrxJPGaAZDPT3E4M2VKLNqsdXFwEk7f1f2
 og0m9ofD
 Xdx9/R9sbN3CDq5RQbwaYVJjBcbfeaWYHff3gIMe20PF4DujFLgE5uiwifwTAS+Ygu1mUQ2GSqmI8Fi/XH22K4ayVHE9/pvrfQiPnXCvwHQn5+5cm7GsCfNIsbg/Bho/zdIP5vw7mUeDvPrp0N1cpt1nANY/THtKXJxJfjbaNJBCxFhO8ha+oovTvpto6EaW05uZxswxOJyVgD3vpP4fS3m99dn8vgLgA8fIlnO+ncavcE5OcNFGo+UfwwtK9WpIPRaAErfChV63FnDnnkT7eVkfO7vWqTNnrZqDiat2b7RJyyiKSU6l0xLbDRZY11zYfiMKZzN++Fv+De93EOQeZCV7thQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change free_swap_cluster_info() to accept struct swap_info_struct*
instead of (cluster_info, maxpages) directly. Extract cluster_info
and maxpages from si inside the function.  Also clean up swapoff:
remove the snapshot locals (maxpages/cluster_info) and move the
p->max/p->cluster_info clearing after free_swap_cluster_info().

This is a preparatory refactoring, no functional change. The new
signature will allow the xswap path (added in the next patch) to
access si->flags and call xswap_unmap_clusters() from within
free_swap_cluster_info().

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5aa1ffb97df8..cd7e889f073d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3054,14 +3054,17 @@ static void wait_for_allocation(struct swap_info_struct *si)
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
@@ -3100,11 +3103,9 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
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
@@ -3196,10 +3197,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
-	maxpages = p->max;
-	cluster_info = p->cluster_info;
-	p->max = 0;
-	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
@@ -3207,7 +3204,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(p);
+	p->max = 0;
+	p->cluster_info = NULL;
 
 	inode = mapping->host;
 
@@ -3574,6 +3573,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	if (!cluster_info)
 		goto err;
 
+	si->cluster_info = cluster_info;
+
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
@@ -3637,7 +3638,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(si);
 	return err;
 }
 
@@ -3856,7 +3857,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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


