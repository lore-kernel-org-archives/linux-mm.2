Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1830A606D80D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=w+UlVKYZ
Received: by kanga.kvack.org (Postfix)
	id 2A5086B05BC; Mon,  9 Nov 2026 00:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D266B05BD; Mon,  9 Nov 2026 00:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA796B05BE; Mon,  9 Nov 2026 00:55:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F216D6B05BC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:55:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A6EA405D0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:55:49 +0000 (UTC)
X-FDA: 85414519218.19.AE35BC8
Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5FF7F120008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:55:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w+UlVKYZ;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GIo2UkpkdP7onxkxyabBA7g4HiK1e7Qvtr70HBzPDc=;
	b=Rc8CmA+RgTH5O2XtYaGs4BHunBGK4/q4zJx5tuuAVWWHcbVXJWdxs0LEMzdvPWRSp43B1w
	BRITMs2VcozZ4d716KCkpwKUbxcsayxZvwUsZTOX5t95gyT5/Ic/2v5zhYx/gswtKqT4rm
	aGERnNfT130PmWqBOHQgY1TNSJW6uM0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203747;
	b=kcdjkPmXrRbz+UlWT4oqUqTyWy/LLC7bxtorBhjT5EPrGd+JfWcI/psX7k6KADljbMQzBL
	811E5LtHqjpcQV+QRXq3KgmAB6+xGdcKwTXDNJC3NgkVxZLtaU+LV3Ve596vU7sUwcBhbL
	hydDizJfcasXvKqt6Tvf4QDx2dPe8dg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w+UlVKYZ;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2b09xWFiKgnG0Sfu7a8FAk8GskA1FlvJgr+XW/Xe4eg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203746; v=1; x=1794808546;
 b=w+UlVKYZY3kvM9chYcGa0PAfejNc99rHDQ4pHIDZ03nw4J6KoxihAy/2lnh8fxnMup6YoMkK
 KIRzxK2yPqgtx4qYXExvaBwRDzrI2nlsJxBwA/BD1yj0b9JDQIOx34pUd52l9A8/TOV63jNcNWi
 vVddIJxxIa4TscmLPo6HuQ2E=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 50ffbfaeaaba1c97;
	Mon, 09 Nov 2026 05:55:24 +0000
X-Mizu-Trace-ID: 50ffbfaeaaba1c97
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH v5 02/19] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
Date: Mon,  9 Nov 2026 13:54:38 +0800
Message-ID: <20261109055455.536925-3-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5FF7F120008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 57ip7qkeut4diza1bnbt5n31qqwb84g7
X-Rspam-User: 
X-HE-Tag: 1794203747-193812
X-HE-Meta: U2FsdGVkX1+iUZBYJioAIshqnubLxFjHTugIqhkfNj030idQYnR3/IhFFR+pvsQsTWtOeStwC7vler5hTkOGN9XMS4ptBMGyE3DDGIxTkZdRRTMQYYVcxNzy8/r76vmRlKL/Zwb+AFY+ECaAwlJiuBK+7lBXkb01HYOT45vRKC0gHrvIbxkJ4NP4hfw/p92XuIhcK1vAWiRRVc/NE5Mzfa6beYwin5vT1FuHdXGPsuHDcChGjIPbT6zCv51ryisoC8TenQ9UT1cSnrta1IOYiHEOBZUQHAEyRkAc0oV3ds9m3f8AhYf1ePcYP4B/a+Oi6h9El88ywOXl5i4bVXUbELB+u4JsVNnVKiglgsuwB/7AaQmigKKX0gVZu0XxQVciD0j4/ozAsV0s36x/mYxq7NQWkIh4hg57/ojp+ZUxA2pFuBFa7f35G8qel/YW8Y2XRxysjIQfpRci9C311MNUGqbts/P6VqBJwccN9NEMuu4vi+uyYrkzUQFvi+o1dVrZ3RR2pdcR+2oFSr8I2JVgWDBQZSAnFCz3rZWp/nUKt1ziDvClCGqnBa+HnZl1ihj3qciSnqxHv0eEp543ojWR/vIINd73mxVzYSOxxEcp+/eJB6XVFK5CXd0FdZgBkAO0wIb+yVfR7PdpXkUTmFWuHZcyWrL3rUKrbnjB77OYInHDiqmUqjfGPpp4iCYYMOs/gzzbG5/flyvL7a4pwEdpWBhzzaxk+eYj8ViX77s4vyphKCzlofwNM0PZGNR/M+6A56dPOYmppzyuLz0MipPLoI0wKs2Ft7q5fzuY9AhcHcy2YQVD1g7N3R568D8KmxVs3+RQxcpSHS2V1lw9Wfc3gVryGdcrzWlkgPFUfQzfaBrYM05xoJLahuOLwXEMAEbIjUGJwX509j72hWdpF3QhP0GYgZNZwRJ7PDun6jWs6rtTKgXYX59Scc/TWkvfsd7FaZYQhwArY90lxbEYUEJ
 +NJtbSLU
 q34kLS3s1gqxZjXh+uo2sio0KPVctWv0piIVyuV15mE+AuDwELotbYfJ5SeFYyHlOr/t+yC+RRcm396m/BI3iv+nkHF/++d53qUViUszVYOvFop7VzUv029/lmgAlcX9MGehbG+1KWvGLV+KfmlwbYtIYF/1kbOldeO7gbyKEvL7p2Tflx0XOxiRwITPj4BOT8MWOwP0gqFLnzT3XEH24Trbm0czF9NTEMnNVqmLlGzZ5HG5O0Yd7qYwqqUL1bzQuElJDNGGO3plSnWn9sl4mU7Q220C6zsZ0R2XEGuPjFb2NBAIKa9wENxf9aOpD0IWi5BIZAlV4BvrTcOiuS4N9fnXa9V5pXJKYlDK3C5hbV4e6svzG9bIFNSeKlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Change free_swap_cluster_info() to take struct swap_info_struct* instead
of (cluster_info, maxpages). It now extracts the fields from si and
clears si->cluster_info after freeing to avoid a double free on the
swapon() error path.

The new parameter also lets the xswap path access si->flags in the
function.

Reviewed-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0b1fef65b6a0..619bd5305120 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3155,14 +3155,17 @@ static void wait_for_allocation(struct swap_info_struct *si)
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
@@ -3174,6 +3177,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		spin_unlock(&ci->lock);
 	}
 	kvfree(cluster_info);
+	si->cluster_info = NULL;
 }
 
 /*
@@ -3201,11 +3205,9 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
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
@@ -3297,10 +3299,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
-	maxpages = p->max;
-	cluster_info = p->cluster_info;
-	p->max = 0;
-	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
@@ -3308,7 +3306,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(p);
+	p->max = 0;
+	p->cluster_info = NULL;
 
 	inode = mapping->host;
 
@@ -3675,6 +3675,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	if (!cluster_info)
 		goto err;
 
+	si->cluster_info = cluster_info;
+
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
@@ -3738,7 +3740,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(si);
 	return err;
 }
 
@@ -3960,7 +3962,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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


