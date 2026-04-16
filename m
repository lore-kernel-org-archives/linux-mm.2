Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9C7F8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295466B008C; Thu, 16 Apr 2026 05:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CD86B0092; Thu, 16 Apr 2026 05:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA0B6B0093; Thu, 16 Apr 2026 05:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBD56B008C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:10:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8701A1B8996
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:40 +0000 (UTC)
X-FDA: 84663848640.03.FDFB832
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id F24274000E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VzdTm8vy;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+yQRhV0phqeAJCBPLtT4nnWEBpdmOW+oAMK7klqeDo=;
	b=vaOVoorPLIq4S1fFx3KH0TeQX99GOBqQI5ThzB5FYUGy7VE+kxnt2fg69c/16eNURxFDNO
	xCiZ4ri6CaVOZNtgdnqL/JOCkRG826JqzvOAGWTFaHVZMBaLIANvV5HhDxSU4JzfZ+YSD7
	sPyYCh6bvLvj3HdrNUqrFH0AuvL0xU8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330639; a=rsa-sha256;
	cv=none;
	b=YdEQMZkKNNvn+cC+TakHQbosIK/VGGuXrNy7+pltenKqprCTjwKZO3/DY1ifYFcAbSjhfK
	8uHf/jjZ+e4zkOwW0NzpeJ7b2NO8xdu9v2/NuOLxLQfNBI3o3s+DXs6y4yybxXld3l4+Aa
	KVfdBbYDNzZDvc/AnVP7XeT0QdAVyXs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VzdTm8vy;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 593EB6012A;
	Thu, 16 Apr 2026 09:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DAEC2BCB5;
	Thu, 16 Apr 2026 09:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330638;
	bh=CMip4eFbasUIvlR3P/M8MgeOoWuXxQ2+h4ESc3P+fLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzdTm8vymSC+VxFzOo1Js3YnTi6dVF6shbZ6l/VJDehvH/mQ1FrHfa06im1VSLnJC
	 UKPyCeGUetbib07DdztNDaTtGQ+RyjZqxdmk7/SkahysloCxhkVRolOuwCugLHeISm
	 bTV1AS9MBHO5LMrw+mnGhRm2AVYRvdUaDsR5vAO6oRSpMfz+SU6r15xYfqlrcYNUjj
	 iJhxgw3rvBza0tjOxcML1wa/b5eh93tzfG2CBU5DkL/EaFMQPdus6usWbwcfN7qNwN
	 uSPVlTf50zFBhZ0duMG5ZpDY8E5ZK7Kk34ksviN9v/UCufWPZr+O2alERbWvMIRekI
	 d/uRojROwSwSA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] mm/slab: move kfree_rcu_cpu[_work] definitions
Date: Thu, 16 Apr 2026 18:10:17 +0900
Message-ID: <20260416091022.36823-4-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260416091022.36823-1-harry@kernel.org>
References: <20260416091022.36823-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qinjtgycm5x65hg6qg3wzkwu1ry4bsiq
X-Rspam-User: 
X-Rspamd-Queue-Id: F24274000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1776330638-523829
X-HE-Meta: U2FsdGVkX1+XkdQJYbONKW332UA5qbJj5ZBj8oORUQqpl9/W6mVrN8PYuJbAXi9Xx/4mCpxIYQzr2EA0bbiUntWvIGrGOQn6/rOr0XLXKnieFEPQTkzot1sMzpym9ov73fJ6GhaEA1SW6vYf1AvSkxCmM/SO/6InNW6Gpp8kpYZ333oyBdfQnJaG1nKSxxSJDvLLgsDb6JXpJt/aUbPAD79BrHp/xIJ7bhnHGiDJXjthtGXpDMhi2GRhFr8ekD7LeAOnALUS/f1+TdDlUjkU9r0082NWJKOoF6k03R6xWm9Qjdh/iWaKOHTZAUhKG5c5ZxBXerMTwBNrWwgdi7nZJOH4Ph66O5Cm4WrCXZjTu6g5g35btI3xA2tw+CJm6utg9zN7JBsnX9KUymebObDv4ypalMDJ3k6fANkTDBCaVgZPjiXqHtEYchuy/9ZSXS2UeKp+33dftoEMuYsmGfDwBytu/eYfvWQlXSM1BlLNqXcPyXPTQ4RZOXxwiuod88itxr/Zg6fmb8Vnqw4kePRX/ctXV1JEgJ62WSaiVtWg7j+V2dxVeDv4UVVQsQGzmpwmK9pIvZM72afZDgMmp7z9rNqSlthD5tU2Dtk5uEZs4KQcUz+1ba2ycD6UUiSVd/GdqsbCjkJR+7bmPiQ/xXjrWJ3I9bu6gU7AAZgUkmtP7AMhmDw6lV7edkhW491mF8DDzSWMyIh/pCEfmm/LnN9PpIpfjiEZB9Sqh3B/fVEDHKCN8aQV2ShvmosFxtMl3YFaJ+H1LKUNse17A1mibmQoBWy2HwRiQS6ZoOYiKgHPBEpM8eGNtJU63sIGDjSnov2wxYfawumAThheuTj4t23eyZYBcpAPrAriuEJZyRXn4hWYmfrLtqKG78JpY08AOXJzF0BYwTpAg2lvn9hv0kJ0CrOXVxMTxh3RerlV3eLTVJiK0p2Dfu1ZqfwtWTfqeM+q3GScxrCuoLo06n90qKW
 9j8wIeOr
 2glAurePNJKfVVPNi01Pb4TjrezuVCg5+tNpfTGAy586JajspBoNIiGkXHNBofb45+wjgNoijzAAwoszO1Z7zvivCphlpmd/DMbYjygW/mR/l0f1DvzO0xGYdOszC7qli9bDIe9c/3sJDVu9pXIRM1vFGG/dwxOC5N6OB3Ejpx5v5m6NJTgoafMIrDdjW1InxyHOhN4R9u3wXUUw0bwYS0EeGQg+qbIvg2moGpjmMX7G86meiu/SqNKHql180UHX5ompHkAVPZzTQUkbfOU1fXEcWsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for defining kfree_rcu_cpu under
CONFIG_KVFREE_RCU_BATCHED=n and adding a new function common to both
configurations, move the existing kfree_rcu_cpu[_work] definitions to
just before the beginning of the kfree_rcu batching infrastructure.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab_common.c | 142 ++++++++++++++++++++++++-----------------------
 1 file changed, 72 insertions(+), 70 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 85c9c2d0620e..cddbf3279c13 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1263,78 +1263,9 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
 EXPORT_TRACEPOINT_SYMBOL(kfree);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
 
-#ifndef CONFIG_KVFREE_RCU_BATCHED
-
-void kvfree_call_rcu_head(struct rcu_head *head, void *ptr)
-{
-	if (head) {
-		kasan_record_aux_stack(ptr);
-		call_rcu(head, kvfree_rcu_cb);
-		return;
-	}
-
-	// kvfree_rcu(one_arg) call.
-	might_sleep();
-	synchronize_rcu();
-	kvfree(ptr);
-}
-EXPORT_SYMBOL_GPL(kvfree_call_rcu_head);
-
-void __init kvfree_rcu_init(void)
-{
-}
-
-#else /* CONFIG_KVFREE_RCU_BATCHED */
-
-/*
- * This rcu parameter is runtime-read-only. It reflects
- * a minimum allowed number of objects which can be cached
- * per-CPU. Object size is equal to one page. This value
- * can be changed at boot time.
- */
-static int rcu_min_cached_objs = 5;
-module_param(rcu_min_cached_objs, int, 0444);
-
-// A page shrinker can ask for pages to be freed to make them
-// available for other parts of the system. This usually happens
-// under low memory conditions, and in that case we should also
-// defer page-cache filling for a short time period.
-//
-// The default value is 5 seconds, which is long enough to reduce
-// interference with the shrinker while it asks other systems to
-// drain their caches.
-static int rcu_delay_page_cache_fill_msec = 5000;
-module_param(rcu_delay_page_cache_fill_msec, int, 0444);
-
-static struct workqueue_struct *rcu_reclaim_wq;
-
-/* Maximum number of jiffies to wait before draining a batch. */
-#define KFREE_DRAIN_JIFFIES (5 * HZ)
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 #define KFREE_N_BATCHES 2
 #define FREE_N_CHANNELS 2
-
-/**
- * struct kvfree_rcu_bulk_data - single block to store kvfree_rcu() pointers
- * @list: List node. All blocks are linked between each other
- * @gp_snap: Snapshot of RCU state for objects placed to this bulk
- * @nr_records: Number of active pointers in the array
- * @records: Array of the kvfree_rcu() pointers
- */
-struct kvfree_rcu_bulk_data {
-	struct list_head list;
-	struct rcu_gp_oldstate gp_snap;
-	unsigned long nr_records;
-	void *records[] __counted_by(nr_records);
-};
-
-/*
- * This macro defines how many entries the "records" array
- * will contain. It is based on the fact that the size of
- * kvfree_rcu_bulk_data structure becomes exactly one page.
- */
-#define KVFREE_BULK_MAX_ENTR \
-	((PAGE_SIZE - sizeof(struct kvfree_rcu_bulk_data)) / sizeof(void *))
-
 /**
  * struct kfree_rcu_cpu_work - single batch of kfree_rcu() requests
  * @rcu_work: Let queue_rcu_work() invoke workqueue handler after grace period
@@ -1402,6 +1333,77 @@ struct kfree_rcu_cpu {
 	struct llist_head bkvcache;
 	int nr_bkv_objs;
 };
+#endif
+
+#ifndef CONFIG_KVFREE_RCU_BATCHED
+
+void kvfree_call_rcu_head(struct rcu_head *head, void *ptr)
+{
+	if (head) {
+		kasan_record_aux_stack(ptr);
+		call_rcu(head, kvfree_rcu_cb);
+		return;
+	}
+
+	// kvfree_rcu(one_arg) call.
+	might_sleep();
+	synchronize_rcu();
+	kvfree(ptr);
+}
+EXPORT_SYMBOL_GPL(kvfree_call_rcu_head);
+
+void __init kvfree_rcu_init(void)
+{
+}
+
+#else /* CONFIG_KVFREE_RCU_BATCHED */
+
+/*
+ * This rcu parameter is runtime-read-only. It reflects
+ * a minimum allowed number of objects which can be cached
+ * per-CPU. Object size is equal to one page. This value
+ * can be changed at boot time.
+ */
+static int rcu_min_cached_objs = 5;
+module_param(rcu_min_cached_objs, int, 0444);
+
+// A page shrinker can ask for pages to be freed to make them
+// available for other parts of the system. This usually happens
+// under low memory conditions, and in that case we should also
+// defer page-cache filling for a short time period.
+//
+// The default value is 5 seconds, which is long enough to reduce
+// interference with the shrinker while it asks other systems to
+// drain their caches.
+static int rcu_delay_page_cache_fill_msec = 5000;
+module_param(rcu_delay_page_cache_fill_msec, int, 0444);
+
+static struct workqueue_struct *rcu_reclaim_wq;
+
+/* Maximum number of jiffies to wait before draining a batch. */
+#define KFREE_DRAIN_JIFFIES (5 * HZ)
+
+/**
+ * struct kvfree_rcu_bulk_data - single block to store kvfree_rcu() pointers
+ * @list: List node. All blocks are linked between each other
+ * @gp_snap: Snapshot of RCU state for objects placed to this bulk
+ * @nr_records: Number of active pointers in the array
+ * @records: Array of the kvfree_rcu() pointers
+ */
+struct kvfree_rcu_bulk_data {
+	struct list_head list;
+	struct rcu_gp_oldstate gp_snap;
+	unsigned long nr_records;
+	void *records[] __counted_by(nr_records);
+};
+
+/*
+ * This macro defines how many entries the "records" array
+ * will contain. It is based on the fact that the size of
+ * kvfree_rcu_bulk_data structure becomes exactly one page.
+ */
+#define KVFREE_BULK_MAX_ENTR \
+	((PAGE_SIZE - sizeof(struct kvfree_rcu_bulk_data)) / sizeof(void *))
 
 static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
 	.lock = __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
-- 
2.43.0


