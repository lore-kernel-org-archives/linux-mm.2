Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C60606A334
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Z0IANYz/
Received: by kanga.kvack.org (Postfix)
	id 9A05F6B05B3; Sun, 22 Nov 2026 07:40:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9510D6B05B4; Sun, 22 Nov 2026 07:40:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840696B05B5; Sun, 22 Nov 2026 07:40:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C09C6B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:40:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F4201C375A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:05 +0000 (UTC)
X-FDA: 85462712370.11.A89E07C
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	by imf05.hostedemail.com (Postfix) with ESMTP id A0207100009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z0IANYz/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351203;
	b=KFHbGuPdsbEeImC4ns1PDkFAcLvRuYJkxcLhSyyXKDkWV4lepaBdOF4J8gAzP7mCBTkXjT
	TBZbkwcrZV33M6/Dp2hUImxuFvZV7WGApsELf0ipROjmJRHBXr2VrXTg3R28qtSlULYqEc
	AEj0jemFoI/SnuvjZNhdNAcLDYCilDI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqeYfKLkqkO2fo0Ok6Kpook35o5H/Hggacweb9IUcO8=;
	b=LTQBKzJmOpvIXHGwD0BRccbAagqSfqjgg1yY1S/XHWmWmBI9DmHVnzbHr5lX8oqH7c90/V
	UPaCSMbDB6BwuvPqOQG8kEM164NWFugxi8KPB8MWp9YcqME69u/1ru6eTnovs3ibpZw6/i
	IMfXG7OJpk7w9gt1G6bQN2KbzAObnI8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Z0IANYz/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2bXaGVW2NID6qzPP0iSrWS/UKvSBqUCkOqdFi1F6OSc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351202; v=1; x=1795956002;
 b=Z0IANYz/qMR75k1/rp6RBIlOpNZ/Kmg+fx6IMKEv2g/frYx0awtZSlzS7w7oHKCXbqFzN4DC
 oTI1+qS9tDfxbR4TsrexZ+/obr1iZ91qZahpcXerqZwR7CnE351qU41L4bpIllssbBO1QWTlYvb
 G4SfdWuZta4tHIjHHxBHLxLg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f47dab14ca75afb5;
	Sun, 22 Nov 2026 12:40:02 +0000
X-Mizu-Trace-ID: f47dab14ca75afb5
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH v6 03/14] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
Date: Sun, 22 Nov 2026 20:39:07 +0800
Message-ID: <20261122123918.3486916-4-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122123918.3486916-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A0207100009
X-Stat-Signature: bssdcdsiot16mn9b1tbdizwpddei69ac
X-HE-Tag: 1795351203-832348
X-HE-Meta: U2FsdGVkX1+cRh3r+kFqizxG2W09YU5+QMjIAa1v1J+i9ww51XfY45KxtNoKVwmzcZlOXQKB0LYUeENPgu5BcuF/HbUWlgihRdGyVGOzOTKLGVhCG0SvWkwVoOdvdEGUhR0hYZDkjvlmS7tFMAQWeLMXSS5+aIA019ccNN2zJosbHo8AS1KwgOF876WveAcZetxAqOFHxQAlwZ1Bso+0vlpRdIoQXlGtkdUaAmEdBqVqc/2zfX27sdrqjMXwEjAa8umrOqt+b1XZTl8+uT+9SOH7CMJfWL1zNm7qn9Du1HCd9IY2LSZ08QrHqBI+I5ZMaUZavk0Bw/8dwVVs0vcxNyI2RJtGG23u+66LIB64EYaGgPlLcV8Gye83pRp5EUKH4ZJxhFB63dY/8iJ6Iikz96z4BzLAODI6Ql/Aeym3wBVHwOB3DL3pH9KtC2W0AiAbHmjRNyAGAXudfW8ze0pGBJrMNy/vPXI+PP1UKXqJ21fk2ePlAdDie2lKjd5Pt4mAZalAWPHtztYmaz4xnpk+trh+01m4dgW7UioM0auTB+Car15DOjsQ28zkWO3BQzi315B4l6angW8q/7/tq7KAw92LUEcGE9Heos4Vl6+FDkdMKumJOQdM8RN4RfzFPob2Pmy7Z+qcynMQ41zMTcuqzJ7/uJtKVRDbZ5aAV6NURtMn1s87HSDV8YhLh3OppEv6DZO1yn5fvLYCzFQQ7wKzln6pBcuwOQshvsRSJS60zJJ3L5DLwvntJgEYRrZMKfYS8v9hrTVn6/J5aEDVVZ6EPWNF9TIG78jslbvb0RkAYWovTV6yFK5uCguMkmTUudIe0SGnXVIjH8UW/Xv75QvA2/60sR983RGyKKxN/CUMBJN/lD/PqITidmb0j8EFCKJzFnHZAccXMXxLMYP2SuBIUpBD+pfrXQ0v7ocHqgo/WSTGBEDI73dv8EvtdFsMkpQ16uUvOftDA3wLj/OIyJY
 mKu828d5
 c7qP8SGgxUIUDNezgpR6tZ2Ki6VvH7r4m5DCx9C3wYjhTmjrbIwcA0oKl17IW2WkeYcrAUIeOAdu/xL2CYK6oR13e0hzLXrb8lylK/O1fvTadXflWpK8rBsnZ26nAdwj4mL6Sn9JxnEdj2W2IVw9TT3alZK+DhqYlw1J6Tilen0+kdGhbqMQjBe+6/ezCxEngEF3etVlkErOFoFte7h7lxMinHZa6FxCFOvUlpjL7BrdelHIWaqpND7ThkT9MBo5gF63GQCzoHPpHeLS80J//QhilxFyZrPUNie9XpUFy2038kMQpi8FFNGrlfDmD443WwDC1k45PVniqLz3viZZvszjaC8AWNLjYHZHKizoz4m5QI8ZgmJBXMSRkdbQMgkGWReYs5IaZyuRxUPjX6OySM3sN2N4wWv95cmzsK8trqowYkCDpIh/omUmwFUX4w336hch6z/Y8CdqwQ01OssqZ8rMPWXSJfpxHzfPoQ4xiqD0h9s2QqWU5Q2pfgg6B/g56W9stjRs7NrWilc97m872JdbG5CWBjHoHqPLfhxSJe9hJYGMCC2QN0j1bVD0QrPhl2RgkWLkx9UcwzhE=
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
index 558c4b75bf92..35a079f2bb76 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3208,14 +3208,17 @@ static void wait_for_allocation(struct swap_info_struct *si)
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
@@ -3227,6 +3230,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		spin_unlock(&ci->lock);
 	}
 	kvfree(cluster_info);
+	si->cluster_info = NULL;
 }
 
 /*
@@ -3254,11 +3258,9 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
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
@@ -3350,10 +3352,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
-	maxpages = p->max;
-	cluster_info = p->cluster_info;
-	p->max = 0;
-	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
@@ -3361,7 +3359,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(p);
+	p->max = 0;
+	p->cluster_info = NULL;
 
 	inode = mapping->host;
 
@@ -3728,6 +3728,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	if (!cluster_info)
 		goto err;
 
+	si->cluster_info = cluster_info;
+
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
@@ -3791,7 +3793,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(si);
 	return err;
 }
 
@@ -4013,7 +4015,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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


