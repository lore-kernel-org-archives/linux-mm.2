Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E712C88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079E86B0099; Sun, 13 Sep 2026 03:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A556B009B; Sun, 13 Sep 2026 03:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C646B009D; Sun, 13 Sep 2026 03:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCC2B6B0099
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:50:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FB9D805CE
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:40 +0000 (UTC)
X-FDA: 85207967040.24.36D86C1
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf26.hostedemail.com (Postfix) with ESMTP id ABDB7140007
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sdxYT7Z5My0+W1yVMJaoAfEEdn9WACsZDw3dQzuSGlA=;
	b=kK2SKWTSJWRlK8BUkl8b5QNOhhBQ6wuAh0HOXo53y3Zq+aNvjGWNP3ZFNF+dOVM2n8NAmC
	6m3jf/AATOLbEF/qOT51gaahqibqT8yFGCl92uQ1FE2zhASpJRbR/5Mxlp7wZpr6mUR1Qs
	WAcYTn9EQYjIOJDoPHBUrljVcuFkH0M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285838;
	b=sH0izYWqfj6V4iVSjo5D4G0wNZl48z/ORtOuOhufZbtQyhg3DIL76BB6sM7552cjadlgUO
	cNwvDe8GGZmY3v4uZQIIi6XnOBtIslrsU1Humq3p5tKQV+0qQZCUnGH5PTf3ObNO+Y/Y9j
	JjzYnlo3QtbDMMioXvvK559+xp6IqTo=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a7481ebc3d458e63;
	Sun, 13 Sep 2026 07:50:37 +0000
X-Mizu-Trace-ID: a7481ebc3d458e63
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
Subject: [PATCH v2 03/12] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
Date: Sun, 13 Sep 2026 15:50:05 +0800
Message-ID: <20260913075014.1732524-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
References: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ABDB7140007
X-Stat-Signature: pp541y3nwhh64yerumijqdpak3oezns6
X-Rspam-User: 
X-HE-Tag: 1789285838-224688
X-HE-Meta: U2FsdGVkX1/fHlUo0SR7mxvoFCYictjtr1EQww+UtCcppSWynrmulKCHm30uhxy39jJHOPIm11782qwDfzNa/7Tplnw0zbEj9CxLmlu0CAF9GQDHBovwE2HQ7o1zCJr2pN+tmJz7C8UKQ4r09m5XmYgOo5HIRp4vmGcRvBaeaa7h8RQjq/7nN7+P/LvdtfhNe8nQMTB+uJF/X8B0mz37eWdiUV/40aJSUbi20AfgTDFIXWFfhMMOkfumwXnGPT3GBU6pDYgKYfuS8DI2k/wqT+QeQdzC1iDy+EqGO5Vp9iSpMmfusym42T5N6kVoBUWRL4AT4/BCLq+rwksSCShR40Gh9pfL3Tw9yBTubhqtX7k0u9balb3UGI3oCzmvYuSg3f866EJCIT4fF+mfBtHIx9wXoTlsF/L1gPE0cRps9d89pX8GG1kQPj+NeGERJ3oyjNuJbFpgQDy6OdKQy//vtDcQe+8O7HRFzp6wqEh/iRM3qfmm/m8NxaxDrEZAKY48t/NG1CSRbkUuwTYgoEUxRHQkyh/yjmAhZ+yB1ei6BpkZTLLS5NsH9n7+NlCzVlClnwcWhpmAKqydCbjIy3/eL0obYR0el3dOWPMAgA9Q11tkZ6HCqesv805wjCqsBg2coQ6rXN0djDyyFPQ4wadgWlgz1kz6gUy4KtI0NjR5UOqNO8tMseOg9nJfH1Fjvq2VAJPsQ8zVsaBppsnrvlMUu0q9JhjWJ/uGRRx7hDZo+AggKMN2Wcf/wfmpCgFbg3YwNIatFd6XGoGOWcyOb5BotYqwUhXwuzRhPtNyPcYEoVHonkNd626QynXUYXOOqEKIgZHmp8JLcPQZ6TitODsOr/X5jE0NSb1WhbTXmjFGrzP9a5UDf9OC2ywBdpeJWje+eL+0jH3AGykUzv+lgW/vPxF96WdfvMxQ/3ritnznrK0AElOQy4refje09G1JPL6MyGwii6IgQiPAdWidJmN
 P7JomdFL
 9KJP5wqJKG5q5NXviMDi58H7j8IjyiBv35wD8/txqvLQqbyEgHpGIZ2P9LVBD/z2dha/S+qlyljdWeBiKwmph9SXHOiIaZBQxCizGi4DWlypbYftT+EBm2fZFAxyjXUBFQD7t2hmsuKnSWU8N7spXLhwoj1bo3UmIEMZxEh1gn9rwfaL7Juc9Si8S1fJ7bu1Nwtx8UxTFmRtyzVd/BEHSfLCvvsVDhIKVkdVQP6liKomT66cDhExcy1iY8keliLIDYTjnoHHsusa/eerni5Z0kBc0xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change free_swap_cluster_info() to accept struct swap_info_struct*
instead of (cluster_info, maxpages) directly. Extract cluster_info
and maxpages from si inside the function, and clear si->cluster_info
after freeing so a caller's error path cannot free it again (a
double free on the swapon() error path). Also clean up swapoff:
remove the snapshot locals (maxpages/cluster_info) and move the
p->max/p->cluster_info clearing after free_swap_cluster_info().

The new signature will allow the xswap path (added in the next patch)
to access si->flags and call xswap_unmap_clusters() from within
free_swap_cluster_info().

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 193b08a54908..25bdb2f2fe0a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3055,14 +3055,17 @@ static void wait_for_allocation(struct swap_info_struct *si)
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
@@ -3074,6 +3077,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		spin_unlock(&ci->lock);
 	}
 	kvfree(cluster_info);
+	si->cluster_info = NULL;
 }
 
 /*
@@ -3101,11 +3105,9 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
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
@@ -3197,10 +3199,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
-	maxpages = p->max;
-	cluster_info = p->cluster_info;
-	p->max = 0;
-	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
@@ -3208,7 +3206,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(p);
+	p->max = 0;
+	p->cluster_info = NULL;
 
 	inode = mapping->host;
 
@@ -3575,6 +3575,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	if (!cluster_info)
 		goto err;
 
+	si->cluster_info = cluster_info;
+
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
@@ -3638,7 +3640,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(si);
 	return err;
 }
 
@@ -3857,7 +3859,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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


