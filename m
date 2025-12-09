Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF774D3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288D06B000C; Mon,  8 Dec 2025 20:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101646B0010; Mon,  8 Dec 2025 20:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6BA96B0007; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B25C86B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:41:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A96616035A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:41:18 +0000 (UTC)
X-FDA: 84198229836.21.DD6C747
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 104F5C000C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:41:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765244476; a=rsa-sha256;
	cv=none;
	b=mRmcovERuyo6fKOdwigtoh6p0SJraO5ts2EIiqanZoxm8/p73Xxggja4hQyOoRmZBO5PpA
	D2dKWbtVS8dD0GbUjlVULb+1pmUAOCs1VgYR6Le/qnSI357EaKW5N+oEIXxYgeza/lNAKt
	TanZlxGtYPXOA3E6dkr1VvCU+QcaY60=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765244476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tzg/suMrrT15eggoQJa2hdYy247PJdxnyOUJS7ZXk4U=;
	b=5JuCvLHUa54VszKHaZ0aWlXmRBqUitgQtECGxJmXQpo7vFUAFCGWZAutlqVPRrKDrXd0Oa
	Cw6YvHxlVXJuI3fhOI90xXAmVfw4DMps4yME1dYuFaD3PpuIcbnQ6Wh5tJf6AJQ8wd9yzw
	fapkWQU3CR+qkBnGN3lGFKYHEUEypic=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dQM4p2nRzzYQtkD
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:40:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 112EB1A1552
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:41:11 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgBnRlAafjdpkF9fBA--.23909S5;
	Tue, 09 Dec 2025 09:41:10 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com,
	zhongjinji@honor.com
Subject: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen and non-lrugen
Date: Tue,  9 Dec 2025 01:25:55 +0000
Message-Id: <20251209012557.1949239-4-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251209012557.1949239-1-chenridong@huaweicloud.com>
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnRlAafjdpkF9fBA--.23909S5
X-Coremail-Antispam: 1UD129KBjvJXoWxJF1kArWUtr43KF1rGF45ZFb_yoWrZry7pF
	ZxJry2ya1rArnIg39avF4kWw1Yyw48Gr13Ary5C3WfAFyfJFyFya47CrW8CryUC3s5ur9x
	Ar4avw1UW3y0vF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2
	KfnxnUUI43ZEXa7sRiuWl3UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 104F5C000C
X-Stat-Signature: 8d5dytmghk9uu3scjrjgurk1brqasd7y
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765244474-54813
X-HE-Meta: U2FsdGVkX1/mxWVs0ejimfXbllfmGn1Zrww0QuXeLCAifVExN2iQZS8mG6yB5Q++coM4eMI0j1RVE55pZ0nDp/KU5eGrLp2myh2tBQ2wmjTTU9icF0PGDeyAIOZv8FdXLMq2/ovUeccbntWDkZZgXUFjgBzw9T+PyjpEMcHKUL2gYgmwgu/EE5aYTM5A0j7+QBExu4FkLaKtptsBmjC9sPCIkR18hxA1G3hX97SWN5Lp7R+59OmmjonMpP70/S0nN0ul/cXj9BtokwEQJEDDeruBbYQ7y1Pys9s3Eh0VOhj42PIZ0zDSpaEYRYCQZJFcit4f7pZYkfAsADpZ5Uwx2vbJ2U9/LDwUIyQFwAHXILhNUOcM79YI1SVkdXyYtDJpkwEMP2em9kmEmhIdpaP5Bb8qqlr7pDJqlOzBYfe9O5OIj86uByLzXzASd0UrBNopNAPAqrXMcSYV+MDSXUlMhKvsLeFIHq3u40a+mHwrZyw9SvykWBna4LWEhCSTq0lHxaRAfiCjVPR5WtPzCIrDPh2PudyD6ei0bLV3E6mxfxy7DJXv5Vn229k40KPlc4IAPXPp5yEYyVIu+KkLOElcLzouBzrkW++ZFFmmzDj2Rg1HYKSPD566Od5U1rYmEMjdW9RqDB9xERXRGdby6e+dLMEpmWvZ5zXKcnXYw6VvWqIyPY/wqbZk84KzMIu2TEZBbBQOX3uZhklyPIvAsQfom3jcnWltho8Ri+vwRv9fANyNNOpC+/yRpRZiUYczkdjVRGIVPg360NyTRILj50vXUcbtLgGh+HCX77W6BT8rEK+d5SObkJJEamaASJs/sjp5BEm5gmsLb2v+FoI2zQEEGLpSbrwqEP3zpGvS9qkWAxw+2e6H1+1qvEbx8zEI7duGDBbEWBLKqAseRoNFHUiqMdjspT3HDuLRX0z5JapzqBQAAhBmnWLesfJomYal5l9HCshUREzSqdiESNAbj5W
 r9R/+qbP
 QuALKDEU3M5w5hLj+EJQizU+0Sct09bncBsREWFMeOWbHE0dVnjhw1QtdoIradaC1Su+cyMfrglKo4nv5YABEspLarFSY212tmetjqmGE2IcLG5DACOWcHMGuitR/2ULkouC7kmVqc52t0MWYwz4vXqzGAlGcZSLs3o61UGmYecbfQIfgz2lrupDolFQJs1+RcI6E4/4y1LSNSXRW+g0Tumbb3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

Currently, flush_reclaim_state is placed differently between
shrink_node_memcgs and shrink_many. shrink_many (only used for gen-LRU)
calls it after each lruvec is shrunk, while shrink_node_memcgs calls it
only after all lruvecs have been shrunk.

This patch moves flush_reclaim_state into shrink_node_memcgs and calls it
after each lruvec. This unifies the behavior and is reasonable because:

1. flush_reclaim_state adds current->reclaim_state->reclaimed to
   sc->nr_reclaimed.
2. For non-MGLRU root reclaim, this can help stop the iteration earlier
   when nr_to_reclaim is reached.
3. For non-root reclaim, the effect is negligible since flush_reclaim_state
   does nothing in that case.

After moving flush_reclaim_state into shrink_node_memcgs, shrink_one can be
extended to support both lrugen and non-lrugen paths. It will call
try_to_shrink_lruvec for lrugen root reclaim and shrink_lruvec otherwise.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 57 +++++++++++++++++++++--------------------------------
 1 file changed, 23 insertions(+), 34 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 584f41eb4c14..795f5ebd9341 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4758,23 +4758,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	return nr_to_scan < 0;
 }
 
-static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
-{
-	unsigned long scanned = sc->nr_scanned;
-	unsigned long reclaimed = sc->nr_reclaimed;
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-
-	try_to_shrink_lruvec(lruvec, sc);
-
-	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
-
-	if (!sc->proactive)
-		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
-			   sc->nr_reclaimed - reclaimed);
-
-	flush_reclaim_state(sc);
-}
+static void shrink_one(struct lruvec *lruvec, struct scan_control *sc);
 
 static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
 {
@@ -5760,6 +5744,27 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
 	return inactive_lru_pages > pages_for_compaction;
 }
 
+static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
+{
+	unsigned long scanned = sc->nr_scanned;
+	unsigned long reclaimed = sc->nr_reclaimed;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+
+	if (lru_gen_enabled() && root_reclaim(sc))
+		try_to_shrink_lruvec(lruvec, sc);
+	else
+		shrink_lruvec(lruvec, sc);
+
+	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
+
+	if (!sc->proactive)
+		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
+			   sc->nr_reclaimed - reclaimed);
+
+	flush_reclaim_state(sc);
+}
+
 static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *target_memcg = sc->target_mem_cgroup;
@@ -5784,8 +5789,6 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 	memcg = mem_cgroup_iter(target_memcg, NULL, partial);
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		unsigned long reclaimed;
-		unsigned long scanned;
 
 		/*
 		 * This loop can become CPU-bound when target memcgs
@@ -5817,19 +5820,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 			memcg_memory_event(memcg, MEMCG_LOW);
 		}
 
-		reclaimed = sc->nr_reclaimed;
-		scanned = sc->nr_scanned;
-
-		shrink_lruvec(lruvec, sc);
-
-		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
-			    sc->priority);
-
-		/* Record the group's reclaim efficiency */
-		if (!sc->proactive)
-			vmpressure(sc->gfp_mask, memcg, false,
-				   sc->nr_scanned - scanned,
-				   sc->nr_reclaimed - reclaimed);
+		shrink_one(lruvec, sc);
 
 		/* If partial walks are allowed, bail once goal is reached */
 		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
@@ -5863,8 +5854,6 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 
 	shrink_node_memcgs(pgdat, sc);
 
-	flush_reclaim_state(sc);
-
 	nr_node_reclaimed = sc->nr_reclaimed - nr_reclaimed;
 
 	/* Record the subtree's reclaim efficiency */
-- 
2.34.1


