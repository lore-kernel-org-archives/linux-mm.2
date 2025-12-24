Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B1AE74ADE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 07:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A450E6B0096; Wed, 24 Dec 2025 02:45:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916A46B0098; Wed, 24 Dec 2025 02:45:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB176B0099; Wed, 24 Dec 2025 02:45:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 665FB6B0096
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:45:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3493859993
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:49 +0000 (UTC)
X-FDA: 84253580418.16.758FFFB
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id B987D16000D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:45:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766562347; a=rsa-sha256;
	cv=none;
	b=iYCXnydj9L64lLjzVY8BcbI2JY0X5bzPUrN7IyaSwW7YPllfjDQbvPWccWeyKjsKXc47mi
	6yUItVbTx7hXRQOHkOUMGynTM/VvuoZTekHd38FXnAy2tm0wfmgTCE6WS/ZKHOUNr6HWvH
	w5rPM540ufJ6OCZ7rORqMxcFCYnrQT4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766562347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVla/pBiCWthS9fsALraBzF7XniXml7SQm1x2wkcLbM=;
	b=XYszRQignJumXtdkUqvM2zOjXIzNvZuQdaHTtBsFgxYnSCcOe1CUtHWs6OLLffnGLKI4hj
	fbbTPiE1coiyJ+wWoe36IhGPkzjcDvwWTHApVFAYX13IzqIf2JAW8Qv0TIRvZFpoPJhm/W
	OZgPH0NlQqrDTyP8j76w5rmAhpvSiUI=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dbkRr6HWFzYQtpZ
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:44:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 352F540590
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 15:45:35 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgA3l_cMmktp9pcvBQ--.63051S8;
	Wed, 24 Dec 2025 15:45:35 +0800 (CST)
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
	zhengqi.arch@bytedance.com,
	mkoutny@suse.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: [PATCH -next v2 6/7] mm/mglru: combine shrink_many into shrink_node_memcgs
Date: Wed, 24 Dec 2025 07:30:31 +0000
Message-Id: <20251224073032.161911-7-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251224073032.161911-1-chenridong@huaweicloud.com>
References: <20251224073032.161911-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3l_cMmktp9pcvBQ--.63051S8
X-Coremail-Antispam: 1UD129KBjvJXoWxGFyDGw1fGFW5ArW8CF4fGrg_yoWrXFWUpF
	ZxJry7ZayrAFsIgw13ta17ua4Skw48GrW3Ary8J3WxCr1Sqa4rGa42kryxCFy5CF95urnx
	Zr909w1UWw4jvF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B987D16000D
X-Stat-Signature: 4tsz368dxznwof1pe19qgjnrh9saei5n
X-Rspam-User: 
X-HE-Tag: 1766562346-392374
X-HE-Meta: U2FsdGVkX1/4KwVc5lzeVSqO6ffunH+u5mMUI5LThfEFdSboksQwAe+xMSHUfqIVGUkAA0y6ojSEFZWzqkFmDfL6lW35ZT4albwZGTn79qrWcBa+BLMoe5z+ExSniWfwPbjbdRmtLdAICL00OcE5odyTJiBUvpQkfjXDhOdoxUpGO0AMiQuLF7Uz7cBYIit0mZdOp7tZvvaxtZgHXxNqRXf4IORc3pYDwxhqr5EediR+WMC5Gt5kAGC5CnIYTKs0/zq1FOf/N6N+pU3xTtlUQ7rzyBZXZb5t3RnwJB2mgyJEelMykrW/77xBBib48p6KYN1B+EVxjAdfSpKVa61QtXrbuJ+dtXrPK6FcQznQwhEtDuB7NYdSDcOVNg5qRucKUZD9sGvWt81UfHX/ssndeIVjWfSHs1ahl8bYeKKeOVE2t0OeNV6R1Nz8iPUijpfOr6moj2ud6wZfXIrX44SCOHSnQOCDRqVAmGXbhKjlh8s5k5LPbMgX4Yr1lKqtl6IDoGGiwDFGOZAidb12GXdVHNqw4WobU0MB/jcyB9k0R5kWMBDG8pI5QkRH7QOBcto5OJyuq8qjw1iYSpawI19GAyxs8fK2di3Z4mLBzBDYcNBPTrFbmcyfh2C2u3IQ79Uc7TH5F5WEvttOodU5LzBOex+ZExeGTSmz0r9MSv3LB/odME7D/zsRWPloLn9BsLUaNAlu/sUXyTN3m49udeHMiTcbPRZ0uK8qTGTaXchSxrbAWczM7adck99JNvyOyFdgO6BamHrFfwV9BvvZ8uwOC3uhGcTKt6K//6yxn+4V8za5zMhin1cAlnv5k8zUiBMDq+m0dN7Bmo+D/M2E3F6DEsKu8MNMeuN6wRHnppis1cdaUIjL9kybDOcph9v8KATL8OC6R9oG2fYIz+9epCmN32n363MVnNQy+AF9BWJE+ILkeLCH3oA9mEvotfNboWix0QK2JkWtqF4qwm+hl69
 AOMXNQNO
 x0K7SFr1vM26ASuOXDAnJ5UUEU/h04MICebiWCP64ev1x82W89tCSRSgkbg1eRb3yuT340LRXOSN6AqfebDDhmccmMENu02NNrdDo6Mmj8TSADLPyMS1XegOQR1Wvp2uCi8fDG6ghsy2uEXKoT8gUYNWlxY1Lw9TYPTEz6oxJWXcFUzegDOA1Bd927A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

This patch adds the lru_gen_should_abort_scan check to shrink_node_memcgs
(which is only meaningful for gen-LRU root reclaim). After this change,
shrink_node_memcgs can be used directly instead of shrink_many, allowing
shrink_many to be safely removed.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 60 +++++++++++------------------------------------------
 1 file changed, 12 insertions(+), 48 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3a266f6456af..1d13ce7338b4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4777,45 +4777,6 @@ static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	flush_reclaim_state(sc);
 }
 
-static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
-{
-	struct mem_cgroup *target_memcg = sc->target_mem_cgroup;
-	struct mem_cgroup_reclaim_cookie reclaim = {
-		.pgdat = pgdat,
-	};
-	struct mem_cgroup_reclaim_cookie *partial = &reclaim;
-	struct mem_cgroup *memcg;
-
-	if (current_is_kswapd() || sc->memcg_full_walk)
-		partial = NULL;
-
-	memcg = mem_cgroup_iter(target_memcg, NULL, partial);
-	do {
-		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-
-		cond_resched();
-
-		mem_cgroup_calculate_protection(target_memcg, memcg);
-
-		if (mem_cgroup_below_min(target_memcg, memcg)) {
-			continue;
-		} else if (mem_cgroup_below_low(target_memcg, memcg)) {
-			if (!sc->memcg_low_reclaim) {
-				sc->memcg_low_skipped = 1;
-				continue;
-			}
-			memcg_memory_event(memcg, MEMCG_LOW);
-		}
-
-		shrink_one(lruvec, sc);
-
-		if (lru_gen_should_abort_scan(lruvec, sc)) {
-			mem_cgroup_iter_break(target_memcg, memcg);
-			break;
-		}
-	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, partial)));
-}
-
 static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct blk_plug plug;
@@ -4844,6 +4805,7 @@ static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc
 	blk_finish_plug(&plug);
 }
 
+static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc);
 static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct blk_plug plug;
@@ -4873,7 +4835,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	if (mem_cgroup_disabled())
 		shrink_one(&pgdat->__lruvec, sc);
 	else
-		shrink_many(pgdat, sc);
+		shrink_node_memcgs(pgdat, sc);
 
 	if (current_is_kswapd())
 		sc->nr_reclaimed += reclaimed;
@@ -5586,11 +5548,6 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool proportional_reclaim;
 	struct blk_plug plug;
 
-	if (lru_gen_enabled() && !root_reclaim(sc)) {
-		lru_gen_shrink_lruvec(lruvec, sc);
-		return;
-	}
-
 	get_scan_count(lruvec, sc, nr);
 
 	/* Record the original scan target for proportional adjustments later */
@@ -5822,8 +5779,10 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 
 		reclaimed = sc->nr_reclaimed;
 		scanned = sc->nr_scanned;
-
-		shrink_lruvec(lruvec, sc);
+		if (lru_gen_enabled())
+			lru_gen_shrink_lruvec(lruvec, sc);
+		else
+			shrink_lruvec(lruvec, sc);
 
 		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
 			    sc->priority);
@@ -5837,7 +5796,12 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 		flush_reclaim_state(sc);
 
 		/* If partial walks are allowed, bail once goal is reached */
-		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
+		if (lru_gen_enabled() && root_reclaim(sc)) {
+			if (lru_gen_should_abort_scan(lruvec, sc)) {
+				mem_cgroup_iter_break(target_memcg, memcg);
+				break;
+			}
+		} else if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
 			mem_cgroup_iter_break(target_memcg, memcg);
 			break;
 		}
-- 
2.34.1


