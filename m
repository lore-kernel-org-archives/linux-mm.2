Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03825CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134196B0093; Fri,  2 Oct 2026 20:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10BF26B0096; Fri,  2 Oct 2026 20:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 048576B009E; Fri,  2 Oct 2026 20:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6AB26B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:32:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2F35A040A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:31:59 +0000 (UTC)
X-FDA: 85279437558.18.BB0E585
Received: from mta1.migadu.com (out-154.mta1.migadu.com [95.215.58.154])
	by imf09.hostedemail.com (Postfix) with ESMTP id 160FE140004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:31:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.154 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OoYnYWf+PYmK04tW0pkTwdmvZWIUo6NAeSZX53RSbkg=;
	b=x37nAi+Grs2Wko4tPngMyT+Huc9oHWggR5vr3XotWMc+Iq+3JcaEqVwieeTvTBv0PfgyZp
	cXK+YnL2oKBPaWI18o33tobPJTwVHnZq1wIbP2Z2yVfvqdHkXINN+44R1+qfqtL9561n/D
	vqeYzAYXWGao6Gwq56W9dteoXq7SStY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.154 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987518;
	b=ci/CVjhpryxTO3BjBxgyPX6D9yF4zjWB/qQEjI2tE20kQQ5Nqpi3rXTSMDY4QYqn4FRGzz
	aXqvEOhnhUkrh/PBMkuctO3GIrcISRiW1UCmQ77oiOxpwG28eg1FzDQ4n7LbxGBRiyPT0r
	0r5Tianos0O8CFDfgs6VENwvOjbOmcw=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id b0ba51972060d7de;
	Sat, 03 Oct 2026 00:31:56 +0000
X-Mizu-Trace-ID: b0ba51972060d7de
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v4 02/14] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
Date: Sat,  3 Oct 2026 08:31:24 +0800
Message-ID: <20261003003136.750633-3-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ac6hqfhw4aue9pz6gq5y9tg7pfdwnpfn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 160FE140004
X-HE-Tag: 1790987517-341021
X-HE-Meta: U2FsdGVkX19RMekt4z5UFkmtnXShkaY+1vwfsVgHtYBBDywNPFZSo9XI8g5Jyr/CCmaNrrc+yH64lC/VfHqsI9Oat5IYI094kHirzvjD5h4wnTYaT3LTPoqDB9OW7UTCGY9EeWL2di3hygHasypylMR+bzDxLVDhh21/P4qWP7IAQ/7zShrnv5uhc8OBgVW6WpYj0xUtBJKAbPv4ZhONQdPsmC5J1jQ7gojjjtpOriVTtij96F8DDMXFNLK7jtbOQxRJJURi9ecLyTPj6d6sxNxZUwuI+41Rjw6+bMw43HPyRKjVn2rzfOH3mnKEM6tmnC+kDzFh7ISxOfJ4VilbmVw5s0umKms+Uf6WmofjavYe0ZpkwjDTdd9IP9VWFgVw0wPTJU3KrZWB9StEaup6ctTZ43LV00Jiqo9msfL4ls8WB4GuGynYrA6374ySXIza6yBiA9zcWZtbknkc+Id5OJ0mL9QQFsmXrvUJFeHbDt6aned5ZbnpdVuk4pquCG0W6V+dNjDrgCSA5Ku6UVYaY+GcQQMBCF9BiB3vmb4wYIRfkGMmb6qZnTW5TBvmlice1MahBI/bKbmvB9gv9eYea1DNPSKYfNqCibXSsMBo2xgghT+HzOZp1qr4+gcIZbPTquAJqs5mOXu2f2UnBx4BdsysuP+gTGpXnV/6276oXjToxVW8qLlrKjJnUxllnEXZ/QcBChCP0el9atzdRbmXDmUNnMrHRI1JL42cY9JJdB4bDJnkQg0AouhKTb33Z4hHuAKh/Ptm6h1q6HruUePiA8me4piiPEpCi2/uy7KYSGQld3OQiBnTpY91ADeKGvt+37fsvkY4gTiW2/2eQPkot16pZK6EReATl8Sb4KkuPh5dc6Sb6WIp1BAoPHSmI+XoqnLmcOQMt7h1mNFyfQ93Q2Vp3fr20r7NzTDTWS2GbQzpsGzjuLkUaKYYZxs0BUxOv3MJoJmhoz1/p5Mbn0P
 +i9Rxyvk
 2VuW97BJDk1w8LZ6HD+zSbYdHFkp29LYw/YZutCK6lLjO7YVRYQoB65iCF5XfWRNORE0U2aSrx+hUQA7vEkep1H9FGPX5hnF8DGvTqDPtHHUm+BZBaXZNADgtF1GoZ3nDAaygzvnP3Bg+oYT91EM7Z7RU3HNJDc00OuZ/rFW6yZ0mmwkUXNmL+lT582tsFPhG5XkqrFZ2DfSUjQF+bQCK4WW3ERRn7H7HStMoxjlk4F3th0R/B7YV0mubboVOXE1ypeV/LtpSPp6llnPVH+cQfbj3UsXDhjB7YDvkAgZllxhSF0FKlYQclNs1l2ojxM2ohOL8aP5VP4bJhqSJq8y7W+Do5uQiGG08S65FjObvcMfc0PXC81YefkH8kQ==
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
Reviewed-by: Chris Li <chrisl@kernel.org>
---
 mm/swapfile.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 32c3133e1211..13ec5c0f3c2f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3144,14 +3144,17 @@ static void wait_for_allocation(struct swap_info_struct *si)
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
@@ -3163,6 +3166,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		spin_unlock(&ci->lock);
 	}
 	kvfree(cluster_info);
+	si->cluster_info = NULL;
 }
 
 /*
@@ -3190,11 +3194,9 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
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
@@ -3286,10 +3288,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
-	maxpages = p->max;
-	cluster_info = p->cluster_info;
-	p->max = 0;
-	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
@@ -3297,7 +3295,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(p);
+	p->max = 0;
+	p->cluster_info = NULL;
 
 	inode = mapping->host;
 
@@ -3664,6 +3664,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	if (!cluster_info)
 		goto err;
 
+	si->cluster_info = cluster_info;
+
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
@@ -3727,7 +3729,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(si);
 	return err;
 }
 
@@ -3949,7 +3951,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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


