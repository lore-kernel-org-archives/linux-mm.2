Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D82E7AD4B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 23:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BCEA6B0092; Thu, 25 Dec 2025 18:21:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A1E6B0093; Thu, 25 Dec 2025 18:21:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193A76B0095; Thu, 25 Dec 2025 18:21:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 088A16B0092
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:21:54 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 669E513BA0F
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:52 +0000 (UTC)
X-FDA: 84259568064.22.0EB5151
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id B5CB940002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wylAyIn8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766704910; a=rsa-sha256;
	cv=none;
	b=pTOPk/4skPEaLEiaX4QfMlnxUykZUrNQl+R+GCOfeQiN9pgNpcvjYqxmCblqNnWzWjNkmK
	gmM/n7nea5Y0MCCJoU2joHi1V/jaMHzfMD+FlV/WI0SC52/dj5zpbYhRZ5t1MmXnwJ50Tg
	Kq5y78bI9CdOLrB1fWFEB6a/pnGLaFc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wylAyIn8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766704910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHLUPExoPKnJu0oj7221nxhPbwe4fH4Njx6PIRBvWXw=;
	b=ydm0UAI1JYHRnp0Jm0zwv0autZR11E83HCb21Lg21eUwIYGDlppgBfx3HhVlJa8dWW/lCg
	+rjJm86I77Js5zAi25z8DTnni7e1KTaOjsYg5k/MZNP0EdEfIZkEx/l+Y1iXZ3zWY4H2AD
	Lu3J9vcCUWg1TzQJ4JZvGAsi/cuOyzw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766704909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WHLUPExoPKnJu0oj7221nxhPbwe4fH4Njx6PIRBvWXw=;
	b=wylAyIn8SEF0kBQem+PiUWjgcrj8RTvksgBmWjmdsjlPCewjVoa5/4qRUwLPRZOatWv5DT
	PJJCCmjYTPrTF01gdMkY9TnG6ZoaVWfWaH6T+4WDk/wsvXmE1VTbhbXqBWcdN2+nYpJN7G
	h8VaIoHLozD6gKU1RUvpW2Aqci9G5P4=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] memcg: use cgroup_id() instead of cgroup_ino() for memcg ID
Date: Thu, 25 Dec 2025 15:21:12 -0800
Message-ID: <20251225232116.294540-5-shakeel.butt@linux.dev>
In-Reply-To: <20251225232116.294540-1-shakeel.butt@linux.dev>
References: <20251225232116.294540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5CB940002
X-Stat-Signature: b3auk77br5hd5qtqhc8enwfn3dyr371x
X-Rspam-User: 
X-HE-Tag: 1766704910-963106
X-HE-Meta: U2FsdGVkX1/9dR6vntQqWhsSp2sAKtasHeti2zJ4Q3hp0qwPGv3vlKPCeBMKOe7bJLDSzi4SG9hRaqhvS7pYLzKWNkltWF/NFcqW/IaYq3hjxuiMHCG78GCQYog0GSIhLkU3yRj8ZeBgli3qpDsHZ+Ph2lISeW+Gj9WSmdt4RNIxIbTYOMuI7UpjoEpxt1IBRJ/TPcRJDOTkakOcCib/6UQWuVLdZbMZPLwIOJOnTlBwD1DYY87NoyVLF7QVE0uPDGlvXx2It5D7BPrvdUcHhttvijkzxJBrO7WngJGq8sWKzd8VNu2DWO9Lo2ZAB4kvcDvK7Jv5mmcMmtl73PHihO+BELXuSEDU+f4lW38wggiQ93Yhf9YRwV0s2iPEK1L4k3hTWKUrvZELfZOvXT5ijObhA7Hwqgqlz+a2O9PhJqk3yHoiSZkPrh+8LojXbgwRuT+QMiFA9hxf4EEt0YnMdLa7CIi64SCJVjCORZ7EVq24+WkyNQxBFZnK79/irQQgnjfNOhgPxD8x1QT1iXd6BXFfygjahkzCpJU4va3iwkItwHZeQd7OIWcVmUp+ajtYWRqyUtXSe3Vhe/yzphAVvtXq1ZInfM2LrmwRaoP71DPdYxG0XtN0cifZfHmtlS+NkCH20EeN3oJDSqcumk5VbKAC/zDOnVTUJd/5WlkbL7zQpyESPvgAEo+eha8MZngn2hTN8fzrBDxWQhPq66/QOTo1W2JQq1ntTSxyI7EvrwYHFyPwxyrf3hJ65vMtyZacoTqsK7eNUgpw/FOfiaclGXXRpaV512CvkFlWfpIs1FocF3FZCtbgCObTQWig0n/MjcEmPU4nLdUMb2CBedCoaXoG8L3bWIjhZVDcQ+MG92pSzAgSja2t1L0P2htKjvX6j8s2t2G2VOuJrbZmOVpG5XlIhnW2k8dkCNVgFz1NZWSs/UWoTPNqZPO/H9w++ihTEAUKeNUK5iSDWdm785N
 NEOHzsqC
 jb7FQVMHH1bJAEN3zzHl+hKIZIWcPZawr9UX2Apvp2+kglaKQqJCHnXhN1dcroY5ck7pBKp0N6KPPBWoi4/S8/DxoNiALcTgQqUctrD22eJgqdAGLWFEqfSqYb7AtnksPHxm5xL0wyy1cVaoCEswSuSCRW7ubp3wBuy5kvWAjIpsCuR4zSV4PQjdHgbhtHIQaDbIqApqo0YTHq40Fo3IqauR4Z5gaL2YvEMQA5kTKpQmIe3i5IL6mcKEzhF6f1FR+VawMvo3Hx/pId9MbnliLtVuACQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch mem_cgroup_ino() from using cgroup_ino() to cgroup_id(). The
cgroup_ino() returns the kernfs inode number while cgroup_id() returns
the kernfs node ID. For 64-bit systems, they are the same. Also
cgroup_get_from_id() expects 64-bit node ID which is called by
mem_cgroup_get_from_ino().

Change the type from unsigned long to u64 to match cgroup_id()'s return
type, and update the format specifiers accordingly.

Note that the names mem_cgroup_ino() and mem_cgroup_get_from_ino() are
now misnomers since they deal with cgroup IDs rather than inode numbers.
A follow-up patch will rename them.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 10 +++++-----
 mm/memcontrol.c            |  2 +-
 mm/shrinker_debug.c        |  7 ++++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 77f32be26ea8..c823150ec288 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -836,12 +836,12 @@ static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 }
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
 
-static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
 {
-	return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
+	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
 
-struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino);
+struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino);
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1306,12 +1306,12 @@ static inline struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return NULL;
 }
 
-static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return 0;
 }
 
-static inline struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
+static inline struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
 {
 	return NULL;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 92beb74482fa..1ff2f9bd820c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3620,7 +3620,7 @@ struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 	return mem_cgroup_from_private_id(id);
 }
 
-struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
+struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index 8aaeb8f5c3af..7ef16a0b2959 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -70,7 +70,7 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
 					       memcg_aware ? memcg : NULL,
 					       count_per_node);
 		if (total) {
-			seq_printf(m, "%lu", mem_cgroup_ino(memcg));
+			seq_printf(m, "%llu", mem_cgroup_ino(memcg));
 			for_each_node(nid)
 				seq_printf(m, " %lu", count_per_node[nid]);
 			seq_putc(m, '\n');
@@ -106,7 +106,8 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 					   size_t size, loff_t *pos)
 {
 	struct shrinker *shrinker = file->private_data;
-	unsigned long nr_to_scan = 0, ino, read_len;
+	unsigned long nr_to_scan = 0, read_len;
+	u64 ino;
 	struct shrink_control sc = {
 		.gfp_mask = GFP_KERNEL,
 	};
@@ -119,7 +120,7 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 		return -EFAULT;
 	kbuf[read_len] = '\0';
 
-	if (sscanf(kbuf, "%lu %d %lu", &ino, &nid, &nr_to_scan) != 3)
+	if (sscanf(kbuf, "%llu %d %lu", &ino, &nid, &nr_to_scan) != 3)
 		return -EINVAL;
 
 	if (nid < 0 || nid >= nr_node_ids)
-- 
2.47.3


