Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFD3CF259E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 08:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4266B00A2; Wed, 19 Nov 2025 03:52:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B756B00A4; Wed, 19 Nov 2025 03:52:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1046B00A5; Wed, 19 Nov 2025 03:52:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9C646B00A2
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 03:52:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47CFF13AB2D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:52:27 +0000 (UTC)
X-FDA: 84126740334.27.6B1E047
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 05ECFA0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:52:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763542345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=YD7I5Jcs69vLbIT2krq3Zlf0iG7ECwTQcD324vfja78=;
	b=j9T6X1vPvLEIdKk3mw0lbZTvZlqVgt6LkK8EkjRaUBhZaEOyc9ZJBr94oVXHJ0fY6/A1wO
	lM8rZnknL2o7Iaae3khxXYwgcMfKSrovwYlF9+dqOTu8Xrk1n23xEDxM5waFqkgENywVzW
	IcWCWrQyU66UPnXCXg1e4af5KJRrwd0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763542345; a=rsa-sha256;
	cv=none;
	b=polaNprsjSy4XhRURfPBreD5hyn5bL7r6tL0VGmUafZtbPg8hJ8vOa8spx1GDEOKCxajhD
	IWC2CILXgdCfc57CqV72V4NfoFFnxcmz/PfLtVf69hq28CEA8svz7egiui5hwQuB00+71g
	EphNsj39WJ646nDmShohCuKF+pRz/gQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dBFb84HwXzKHMnv
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:51:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 7F9911A0A9A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:52:16 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgDXf3Y5hR1pCbIYBQ--.49555S2;
	Wed, 19 Nov 2025 16:52:16 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huawei.com
Subject: [RFC -next] memcg: Optimize creation performance when LRU_GEN is enabled
Date: Wed, 19 Nov 2025 08:37:22 +0000
Message-Id: <20251119083722.1365680-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgDXf3Y5hR1pCbIYBQ--.49555S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw4xKw4fXw4Dtr45Ar1UZFb_yoWxXFWxpF
	Z8G3sI9a95Jr43Kr43Jr4DC3ZIyw18XryYvry7Ga4akr13Gry8K3W8KF4jyFW5ZrZ5urs7
	Wry5tw17GayUK3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8
	ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU0bAw3UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: pwrs93d98eun98bok3prerdgd79xgsft
X-Rspam-User: 
X-Rspamd-Queue-Id: 05ECFA0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1763542340-784467
X-HE-Meta: U2FsdGVkX19l0vV71bgvPZtT635QPV8HieGH6C0yOnvyGa+dIW5GskpLxCHiMZddCJd0KmNJXED+/KzitMZ1Wgxy6f9x5T9Rh8R8bxtz8jvoj4NLbY7wa+X9s4Ie1Fwam9igGEp2Z6Pi/QLoRpbJ15OaK0sCU8FK0ieslPEnW1FPzNkb4dWABakSBHYlciUf8motRtPuuwrOKiRf2hD0b5UUNBK27OMBTDN4pry89s9t+DELZGm2Q8o9O39SWs5eS/xQhso4nv0rzEM5xwJzDQcYgu4PrIgGvt6oztedppjH6YB358zNjsevupYZeIWM/R4YZOvwsxHkhZzyTDOH1HcGRfi7X2UGcttWh6HM/zi5D5LSz0SKHWaREscb5loPA5mRXJyCPsxucn/uNyNHcrcvVWqrCjlN7cL+COWRsn88U6hTsFRQmheA7/V8ITf9kNanvPOg0BJ5Z1aV8mmcJM4/JJa01IsWACexd7DmedHOB3EwNg7TzU7K4nO8lManNxCcvM8ppMREohF5MFlGzX/C5nK3yeN3bmTwDAcI4NiG9BGo+uHBmcGIEMn8Z9ftXlPyUaTtiWv9R4lT/NYqOMAJZ4b226UqjEZQNBzyQt0x6X+ji6P10r79ITv/KXsUyh6H3DgzUdnqPG8EW0ei8mCqRd+hJwlfU+SvEZ9rHXOHrvszuD09vnZByEYanwO9wcHKFJN21UtGa8bJ6+Mwiy4hIz4zhSBlADTubN2AeTIj+crRNMrJTBJrwnu7E0PNIH3dHvjhJyXp+yR7bClJIaTqwCUIO96rZoPO46x6e+1yNVVRff8KabmUUczUg93gqd+FCHcxcEkbRae6bqrCaNpGhr6IhUhDYgdQYYDaCJLjyuTcs5O0nIFwVz3/u50LZ0TXMhvbaw8U1LChbsS33SYE8pDIa2giLObUOWGdJme+K6+cH/jQTdr0iUKwQx8FKVXjB1SfKP+zrkeQnO4
 7oL50Qdv
 WNt3jrJ2vfP8/f3wjDuvruztpb7nsRI+xoup/TwIEnlsQoduN42ibeWlGL6np7k+lU0JBAEmh63vSMhCv1D/rJ9mDivIj4rg5yqEZuSO9PdOVJlrcRSUCTpCxzkgQ9VY+2/xv4YbCE1aqr8bMBxk/OIfjtO6a5xIc1InMSyqiXO6NaSIm4gSPo7G9wQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

With LRU_GEN=y and LRU_GEN_ENABLED=n, a performance regression occurs
when creating a large number of memory cgroups (memcgs):

	# time mkdir testcg_{1..10000}

	real	0m7.167s
	user	0m0.037s
	sys	0m6.773s

	# time mkdir testcg_{1..20000}

	real	0m27.158s
	user	0m0.079s
	sys	0m26.270s

In contrast, with LRU_GEN=n, creation of the same number of memcgs
performs better:

	# time mkdir testcg_{1..10000}

	real	0m3.386s
	user	0m0.044s
	sys	0m3.009s

	# time mkdir testcg_{1..20000}

	real	0m6.876s
	user	0m0.075s
	sys	0m6.121s

The root cause is that lru_gen node onlining uses hlist_nulls_add_tail_rcu,
which traverses the entire list to find the tail. This traversal scales
with the number of memcgs, even when LRU_GEN is runtime-disabled.

Fix this by adding a per-lru_gen tail pointer to track the list's tail.
Appending new nodes now uses the tail pointer directly, eliminating full
list traversal.

After applying this patch, memcg creation performance with LRU_GEN=y
matches the fully disabled baseline:

	#time mkdir testcg_{1..10000}

	real	0m3.368s
	user	0m0.025s
	sys	0m3.012s

	# time mkdir testcg_{1..20000}
	real	0m6.742s
	user	0m0.085s
	sys	0m5.995s

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 include/linux/mmzone.h |  4 +++
 mm/vmscan.c            | 78 ++++++++++++++++++++++++++++++++++++++----
 2 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4398e027f450..bdee57b35126 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -513,6 +513,8 @@ struct lru_gen_folio {
 	u8 gen;
 	/* the list segment this lru_gen_folio belongs to */
 	u8 seg;
+	/* the bin index this lru_gen_folio is queued on */
+	u8 bin;
 	/* per-node lru_gen_folio list for global reclaim */
 	struct hlist_nulls_node list;
 };
@@ -610,6 +612,8 @@ struct lru_gen_memcg {
 	unsigned long nr_memcgs[MEMCG_NR_GENS];
 	/* per-node lru_gen_folio list for global reclaim */
 	struct hlist_nulls_head	fifo[MEMCG_NR_GENS][MEMCG_NR_BINS];
+	/* cached tails to speed up enqueueing */
+	struct hlist_nulls_node *tails[MEMCG_NR_GENS][MEMCG_NR_BINS];
 	/* protects the above */
 	spinlock_t lock;
 };
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8890f4b58673..6c2665e48f19 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4299,6 +4299,66 @@ enum {
 	MEMCG_LRU_YOUNG,
 };
 
+static void memcg_lru_add_head_locked(struct pglist_data *pgdat,
+				      struct lruvec *lruvec, int gen, int bin)
+{
+	struct lru_gen_memcg *memcg_lru = &pgdat->memcg_lru;
+	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+	struct hlist_nulls_node *node = &lruvec->lrugen.list;
+	bool empty = !memcg_lru->tails[gen][bin];
+
+	hlist_nulls_add_head_rcu(node, head);
+	lruvec->lrugen.bin = bin;
+
+	if (empty)
+		memcg_lru->tails[gen][bin] = node;
+}
+
+static void memcg_lru_add_tail_locked(struct pglist_data *pgdat,
+				      struct lruvec *lruvec, int gen, int bin)
+{
+	struct lru_gen_memcg *memcg_lru = &pgdat->memcg_lru;
+	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+	struct hlist_nulls_node *node = &lruvec->lrugen.list;
+	struct hlist_nulls_node *tail = memcg_lru->tails[gen][bin];
+
+	if (tail) {
+		WRITE_ONCE(node->next, tail->next);
+		WRITE_ONCE(node->pprev, &tail->next);
+		rcu_assign_pointer(hlist_nulls_next_rcu(tail), node);
+	} else {
+		hlist_nulls_add_head_rcu(node, head);
+	}
+
+	memcg_lru->tails[gen][bin] = node;
+	lruvec->lrugen.bin = bin;
+}
+
+static void memcg_lru_del_locked(struct pglist_data *pgdat, struct lruvec *lruvec,
+				 bool reinit)
+{
+	int gen = lruvec->lrugen.gen;
+	int bin = lruvec->lrugen.bin;
+	struct lru_gen_memcg *memcg_lru = &pgdat->memcg_lru;
+	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
+	struct hlist_nulls_node *node = &lruvec->lrugen.list;
+	struct hlist_nulls_node *prev = NULL;
+
+	if (hlist_nulls_unhashed(node))
+		return;
+
+	if (memcg_lru->tails[gen][bin] == node) {
+		if (node->pprev != &head->first)
+			prev = container_of(node->pprev, struct hlist_nulls_node, next);
+		memcg_lru->tails[gen][bin] = prev;
+	}
+
+	if (reinit)
+		hlist_nulls_del_init_rcu(node);
+	else
+		hlist_nulls_del_rcu(node);
+}
+
 static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 {
 	int seg;
@@ -4326,15 +4386,15 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	else
 		VM_WARN_ON_ONCE(true);
 
+	memcg_lru_del_locked(pgdat, lruvec, false);
+
 	WRITE_ONCE(lruvec->lrugen.seg, seg);
 	WRITE_ONCE(lruvec->lrugen.gen, new);
 
-	hlist_nulls_del_rcu(&lruvec->lrugen.list);
-
 	if (op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD)
-		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
+		memcg_lru_add_head_locked(pgdat, lruvec, new, bin);
 	else
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
+		memcg_lru_add_tail_locked(pgdat, lruvec, new, bin);
 
 	pgdat->memcg_lru.nr_memcgs[old]--;
 	pgdat->memcg_lru.nr_memcgs[new]++;
@@ -4365,7 +4425,7 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg)
 
 		lruvec->lrugen.gen = gen;
 
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[gen][bin]);
+		memcg_lru_add_tail_locked(pgdat, lruvec, gen, bin);
 		pgdat->memcg_lru.nr_memcgs[gen]++;
 
 		spin_unlock_irq(&pgdat->memcg_lru.lock);
@@ -4399,7 +4459,7 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
 
 		gen = lruvec->lrugen.gen;
 
-		hlist_nulls_del_init_rcu(&lruvec->lrugen.list);
+		memcg_lru_del_locked(pgdat, lruvec, true);
 		pgdat->memcg_lru.nr_memcgs[gen]--;
 
 		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
@@ -5664,8 +5724,10 @@ void lru_gen_init_pgdat(struct pglist_data *pgdat)
 	spin_lock_init(&pgdat->memcg_lru.lock);
 
 	for (i = 0; i < MEMCG_NR_GENS; i++) {
-		for (j = 0; j < MEMCG_NR_BINS; j++)
+		for (j = 0; j < MEMCG_NR_BINS; j++) {
 			INIT_HLIST_NULLS_HEAD(&pgdat->memcg_lru.fifo[i][j], i);
+			pgdat->memcg_lru.tails[i][j] = NULL;
+		}
 	}
 }
 
@@ -5687,6 +5749,8 @@ void lru_gen_init_lruvec(struct lruvec *lruvec)
 
 	if (mm_state)
 		mm_state->seq = MIN_NR_GENS;
+
+	lrugen->bin = 0;
 }
 
 #ifdef CONFIG_MEMCG
-- 
2.34.1


