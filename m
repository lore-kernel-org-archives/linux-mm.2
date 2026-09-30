Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4BF7CA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 19:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14EBA6B0088; Wed, 30 Sep 2026 15:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1242C6B0095; Wed, 30 Sep 2026 15:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDDCE6B008C; Wed, 30 Sep 2026 15:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A72DF6B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:35:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 109D98011D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:35:40 +0000 (UTC)
X-FDA: 85271433240.19.C49B011
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf05.hostedemail.com (Postfix) with ESMTP id 03D58100007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:35:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=UWUOxSWc;
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf05.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790796938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZNT40kMMmQsLfWsdnWmdKdkeVlJ/tQq17QZr/ljVmM=;
	b=Qin2VxvvTQbELvLyHiWciRFBB9pFoRK2xp2EjTy11E4HDSnOCcFuPatDvws+B9ylz5EWz7
	h6+h+l0xl5I1Q9mVH+ls89yQ5uKUor0tLBmXmJlzcyryZIJL0sZl/DgnGpj22qOvPVQ0fU
	mzn/oh3W7bvC2aPD7gLqIcx3fRfU+zQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=UWUOxSWc;
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf05.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790796938;
	b=d/ZzRnOhnS1zOwGbIiIWD3wuh0GdJV/uF923pEc4HKk8IGnm9tsO08xQ6J+1iJlllFYxfE
	bDifgxcB3re6AKZD/PoyURJBA6WGePz2dlDcjX9+aLNGstRkdMm9q0jC+urS1fqkYGrS87
	GcstQ7UP7R8QrRh9L+SwQ5dFRE1Erxg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790796937;
	bh=RZNT40kMMmQsLfWsdnWmdKdkeVlJ/tQq17QZr/ljVmM=;
	b=UWUOxSWcJrpmQ5M0gk5NfNRpMI/f1rYFjOc8Pj5UMd4gZB/Da4n5JsgG0fpGG+J4hALa
	FLf903NJEVMkD0BfLjmFOxycMu6bu4+ScpB4bVIE/PZGIczGugkk/11L4u9TIQwLmvXBx/
	J1SldyZkZ6mC5VgmEdcwiVosfY5/j9qKYKWunJvbNhig6YFYMEFFkrLuUnsksJX0FumyaI
	awSRqHxEC/+75FfFeTWamOTBTkdAeVv0xfN6/5pvLI9Eo65RbRMS56hcqcV8kMEoEzJE8g
	FKmJRkwHMFHhpokUKSPrFgbeAHWbrIRfjZpPi3JDbNyiKWv40Byw6ZmmNb0PrTsw==
Received: by recvd-6cd5f4b4b8-8rsqc with SMTP id recvd-6cd5f4b4b8-8rsqc-1-6ABD6488-F4
	2026-09-30 19:35:36.891619089 +0000 UTC m=+95694.696487392
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-6 (SG) with ESMTP
	id P6Dj4YSyT_WDY3Gt71wefA
	Wed, 30 Sep 2026 19:35:36.848 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Wed, 30 Sep 2026 19:35:37 +0000 (UTC)
Subject: [PATCH v4 1/2] writeback: let foreign flushes reach dying cgwbs
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-wb-dying-cgwb-flush-v4-1-bde637803a96@honeycomb.io>
References: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
In-Reply-To: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11107; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=jKrYWwk4onhmgmY5DmeqhqvtAbrL5u/RIlGh8+c8pyg=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqvWSIBVzHo5qdjRMPWTu+yKAV6CkqxWq68egAc
 XF2f8YAK7uJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCar1kiAAKCRClztTjl62v
 wicSB/0bZq4NrYtmbCxzwKSyMY1OnYMWJQ3m30vnpgkkikBpd7OZGPmJdIdjGBxIFY1aNUeXgDO
 21wf+OubxOfzF4dD7Ppiia1nkGPgClnJi4Jbbd6vNbUztdUuEorZW7LPvFec/EvhnGn0ZNKvoWy
 mTSCgDv9haWg39qB/WkpRt2rqCLDIIsL10hB6dbCNpVkVfxxbo7AnmOMMI0MNDhRDM67o+SVyUp
 rHDiuwVKIdbepLUhnRzX/gQcAOHV2KQdo9J4d8+cPUceNuk4mX2ls3kh0mfjdIjScgxBbCj55by
 yvebik44STXbNP6tJ4u/Kjp+uIJQgXbMXIB/o/Gi5Twyj6KE
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmed02bYO7=2FYQC?=
 =?us-ascii?Q?ZivW1+V+v6u807eM5Q+nYN=2FH5UukAlUEFJYHhI9?=
 =?us-ascii?Q?bzyynNtLy1uiShXLFPtzy01jbqhfw+VrMJ2UsZQ?=
 =?us-ascii?Q?kAoolbH7QbjTUdWDJKObC+d=2Frvm08To+qYWFveg?=
 =?us-ascii?Q?ssVCxxb+sc4sGgKo+7vdqY=3D?=
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun Heo
	<tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
X-Stat-Signature: 5mj831ykdzkxzssjc6eugxedsujyssqt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03D58100007
X-HE-Tag: 1790796937-486156
X-HE-Meta: U2FsdGVkX18xVU0ONHjq+8TDPQamDi4EvjN+MqIBoPzxjboCH6Dy0NijPTutaMv+TpWZpoM0thd0PB2Pw9G+24+VX9louiF0xn+44IsRvZXl4xr9VGNflXTn/kCwVPj4/RcQLGtRy5wNNg9JPjo5+aWg6Sr+QTkFUleDrZByPjNUooq2ZkvEY4PHSNM8e1cSOGfxQbpQgFR1rGunmDBL2pnWVDiwqOYlrWLYmBh4yKsVjPqAIA1/RsKNcrNE5lhw7KkpGzxccGZLQvWGWAx5AqpnuIfpwXqFRZGK94xzyhvWnJcJLs6A+L4MuRw8rPrNvV3YRGrokoa+YYubPpNyfgK/SFFh+1n1ZNypvuFj5S5fXPnqXr8WRx851oCTrLTtFDHsTLzeRKJHpVUTbI2Z2hgW4eC0lmBYoyFZI2sbOLx3+XMivH1UESdwDE/gh0jklcRKOwsnNNVfOlgLxgZAQ0lBPLNnVpGM5G94SPiYNPp5+8QCeXkzQXqd4WHClLPgEx8hgfW0xSeSWkmVGBQofLrN9/hGSK3XJnXrYklB34qGr//IxcPZfKWNO10XNf2718RkuBQNHJceCa3W2GRHigPR2V8MR/sV0QfjIIAqc1mf8JocnSUe7df7gUlakhrVJcipeJdg7FJC7gBGiyIhMGL10YOzwvdXuLpjIUBuOtT3prcHeV6jLhsdGSZifobnYl7VYI0QTJJdGGPf0OdGUkIOA6K/i4Ls8tlVErTX5TVxeVqIZyO8ZWjHqMRI0tu+qLNzGChiL0zQixG5d8f0jcwJAjcUq3CzXENEpng2m+KkypQq7N6CJxEWHOnt4pw8rbxiM2fzrwJngsv+WzoqET4FKFzIb0FctqphNxE7CzQ3NdetnUhMtePpHHZwR+d1QZOcbug8ijgn2KjwRH2Vca/aEBbiS0CNwLBkZkxd6rAenl2+RREDjjvjs3iaUkKrWEtPmtWudJD4IGuSigH
 7GeXb4+/
 szrzelmOmuDhj7QcLvvbZjUCl0Dt58iXsvnYm8OwEJncdx7IFVCo0HPyANwadhK31kdSNLBHRMme/hb1NdqjwREBJO/YRj/GmipkH2w5Zyh5PQCbMOu7Mx7f2ZgxX1BGLXlmX2und1MyFg5kPotrAWEnvDInSQSsGGVPLG5k+V1xtQEXfbDPfAmr1iIGpNoyljEyd96vE+0Mn5aeZongTby3hGnj9vfzF2IB3+qIkyeuVJv+iMiTJqFYJ8ex7GR7Wxm/wkYBjwBpjW5Ric5TjseLKjXk+XNxqeGdllyEodcX5OP6giuEzQQ4ong98ZXBeBFJuu3chlJw2MLwIXZ9KD48O2xOPmsNLFbhQ9ygSeWP37Rkx3tA4g2YEh3/tXbXrYdNkLeMghuRMElpCnpDyhnZwzJEAl6QEbKzZ0ZgGZbIIVr7lFLAhdvRG7WL3baspSgX20WvIgeJuaasrWRCixHzqBkzX5aJBHcUIFUVHEYVMlXviEjfisfimjVB1ecoQCYGHXWi1N7phuA0cTTsSmqcIV5p3mw359wq+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a container is replaced and the new one keeps appending to files
the old one left dirty, the new one can stall in balance_dirty_pages()
for seconds to minutes, with little CPU use and its write lag growing
linearly before it recovers. This matches a 30-60s stall after each
deploy of a container at Honeycomb that reads from Kafka and writes
columnar files to a host volume.

Trigger: a cgroup dirties files and is removed while they are still
dirty, and a sibling keeps appending to the same files under a parent
memory limit. cgwb_kill() takes the removed memcg's wbs out of
bdi->cgwb_tree, but the inodes stay attached to them, so the sibling's
foreign flushes fail with -ENOENT in wb_get_lookup().

Keep killed wbs in bdi->cgwb_tree until they are released, so that
cgroup_writeback_by_id() finds them through the regular lookup. The
creation paths skip dying wbs, and a new wb takes over the slot of a
dying one when a live memcg's blkcg association changes; release only
removes a wb that still owns its slot. cgwb_create() also refuses to
link a new wb for a dying memcg, so a removed memcg's dirty wb can't be
replaced before wb_memcg_offline() kills the new one. The blkcg
association check moves from wb_get_lookup() to the creation side: once
a memcg with io enabled is removed, cgroup_get_e_css() returns an
ancestor's io css and its dying wb would not match.

With commit 168a8c13159c ("writeback: size foreign flushes by target
wb dirty pages"), the flush is then sized from the wb's own dirty
pages and writes out what the replacement dirtied.

Test, on top of that commit: a cgroup appends to 1000 files at
250MiB/s and is removed, then a second cgroup keeps appending to the
same files under a 4G parent limit. Worst lag of the second writer
behind schedule over 120s, in three runs:

  without this patch   85.3s  46.9s  52.1s
  with this patch       1.0s   1.4s   1.0s

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 include/linux/backing-dev-defs.h | 13 +++++-
 include/linux/backing-dev.h      |  2 +-
 mm/backing-dev.c                 | 92 +++++++++++++++++++++++++++++++---------
 3 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 4f1084937315..035d25f5b81b 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -196,7 +196,7 @@ struct backing_dev_info {
 	struct bdi_writeback wb;  /* the root writeback info for this bdi */
 	struct list_head wb_list; /* list of all wbs */
 #ifdef CONFIG_CGROUP_WRITEBACK
-	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
+	struct radix_tree_root cgwb_tree; /* radix tree of cgroup wbs, incl. killed */
 	struct mutex cgwb_release_mutex;  /* protect shutdown of wb structs */
 	struct rw_semaphore wb_switch_rwsem; /* no cgwb switch while syncing */
 #endif
@@ -229,6 +229,17 @@ static inline bool wb_tryget(struct bdi_writeback *wb)
 	return true;
 }
 
+/**
+ * wb_tryget_live - try to increment a wb's refcount if it hasn't been killed
+ * @wb: bdi_writeback to get
+ */
+static inline bool wb_tryget_live(struct bdi_writeback *wb)
+{
+	if (wb != &wb->bdi->wb)
+		return percpu_ref_tryget_live(&wb->refcnt);
+	return true;
+}
+
 /**
  * wb_get - increment a wb's refcount
  * @wb: bdi_writeback to get
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c2284466e7aa..f7ef5895625a 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -222,7 +222,7 @@ wb_get_create_current(struct backing_dev_info *bdi, gfp_t gfp)
 
 	rcu_read_lock();
 	wb = wb_find_current(bdi);
-	if (wb && unlikely(!wb_tryget(wb)))
+	if (wb && unlikely(!wb_tryget_live(wb)))
 		wb = NULL;
 	rcu_read_unlock();
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index cecbcf9060a6..a370dd94b6a4 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -614,6 +614,12 @@ static void cgwb_release_workfn(struct work_struct *work)
 						release_work);
 	struct backing_dev_info *bdi = wb->bdi;
 
+	scoped_guard(spinlock_irq, &cgwb_lock) {
+		/* a newer wb may have taken the slot, see cgwb_create() */
+		radix_tree_delete_item(&bdi->cgwb_tree, wb->memcg_css->id, wb);
+		list_del(&wb->offline_node);
+	}
+
 	mutex_lock(&wb->bdi->cgwb_release_mutex);
 	wb_shutdown(wb);
 
@@ -627,10 +633,6 @@ static void cgwb_release_workfn(struct work_struct *work)
 
 	fprop_local_destroy_percpu(&wb->memcg_completions);
 
-	spin_lock_irq(&cgwb_lock);
-	list_del(&wb->offline_node);
-	spin_unlock_irq(&cgwb_lock);
-
 	wb_exit(wb);
 	bdi_put(bdi);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
@@ -645,11 +647,16 @@ static void cgwb_release(struct percpu_ref *refcnt)
 	queue_work(cgwb_release_wq, &wb->release_work);
 }
 
+/*
+ * A killed wb stays in bdi->cgwb_tree until it is released or replaced in
+ * cgwb_create(), so that foreign flushes can still find it through
+ * wb_get_lookup().  Inodes attached to it can keep collecting dirty pages
+ * from other memcgs until they are written back and switched away.
+ */
 static void cgwb_kill(struct bdi_writeback *wb)
 {
 	lockdep_assert_held(&cgwb_lock);
 
-	WARN_ON(!radix_tree_delete(&wb->bdi->cgwb_tree, wb->memcg_css->id));
 	list_del(&wb->memcg_node);
 	list_del(&wb->blkcg_node);
 	list_add(&wb->offline_node, &offline_cgwbs);
@@ -669,7 +676,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	struct mem_cgroup *memcg;
 	struct cgroup_subsys_state *blkcg_css;
 	struct list_head *memcg_cgwb_list, *blkcg_cgwb_list;
-	struct bdi_writeback *wb;
+	struct bdi_writeback *wb, *old_wb;
+	void __rcu **slot;
 	unsigned long flags;
 	int ret = 0;
 
@@ -681,6 +689,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	/* look up again under lock and discard on blkcg mismatch */
 	spin_lock_irqsave(&cgwb_lock, flags);
 	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
+	if (wb && wb_dying(wb))
+		wb = NULL;
 	if (wb && wb->blkcg_css != blkcg_css) {
 		cgwb_kill(wb);
 		wb = NULL;
@@ -726,9 +736,24 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	ret = -ENODEV;
 	spin_lock_irqsave(&cgwb_lock, flags);
 	if (test_bit(WB_registered, &bdi->wb.state) &&
-	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
-		/* we might have raced another instance of this function */
-		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
+	    blkcg_cgwb_list->next && memcg_cgwb_list->next &&
+	    !css_is_dying(memcg_css)) {
+		/*
+		 * We might have raced another instance of this function.  A
+		 * dying wb keeps its slot until released; take it over.
+		 */
+		slot = radix_tree_lookup_slot(&bdi->cgwb_tree, memcg_css->id);
+		if (!slot) {
+			ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
+		} else {
+			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
+			if (wb_dying(old_wb)) {
+				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
+				ret = 0;
+			} else {
+				ret = -EEXIST;
+			}
+		}
 		if (!ret) {
 			list_add_tail_rcu(&wb->bdi_node, &bdi->wb_list);
 			list_add(&wb->memcg_node, memcg_cgwb_list);
@@ -768,10 +793,29 @@ static int cgwb_create(struct backing_dev_info *bdi,
  * Try to get the wb for @memcg_css on @bdi.  The returned wb has its
  * refcount incremented.
  *
- * This function uses css_get() on @memcg_css and thus expects its refcnt
- * to be positive on invocation.  IOW, rcu_read_lock() protection on
- * @memcg_css isn't enough.  try_get it before calling this function.
- *
+ * The wb may have been killed and its blkcg association may be stale.  This
+ * is what foreign flushes want: they target the wb that owns the dirty
+ * inodes, which can be a killed one.  Use wb_get_create() to get a wb to
+ * attach inodes to.
+ */
+struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
+				    struct cgroup_subsys_state *memcg_css)
+{
+	struct bdi_writeback *wb;
+
+	if (!memcg_css->parent)
+		return &bdi->wb;
+
+	rcu_read_lock();
+	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
+	if (wb && !wb_tryget(wb))
+		wb = NULL;
+	rcu_read_unlock();
+
+	return wb;
+}
+
+/*
  * A wb is keyed by its associated memcg.  As blkcg implicitly enables
  * memcg on the default hierarchy, memcg association is guaranteed to be
  * more specific (equal or descendant to the associated blkcg) and thus can
@@ -782,9 +826,13 @@ static int cgwb_create(struct backing_dev_info *bdi,
  * both the memcg and blkcg associated with it and verifies the blkcg on
  * each lookup.  On mismatch, the existing wb is discarded and a new one is
  * created.
+ *
+ * This function uses css_get() on @memcg_css and thus expects its refcnt
+ * to be positive on invocation.  IOW, rcu_read_lock() protection on
+ * @memcg_css isn't enough.  try_get it before calling this function.
  */
-struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
-				    struct cgroup_subsys_state *memcg_css)
+static struct bdi_writeback *cgwb_get_live(struct backing_dev_info *bdi,
+					   struct cgroup_subsys_state *memcg_css)
 {
 	struct bdi_writeback *wb;
 
@@ -798,7 +846,7 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
 
 		/* see whether the blkcg association has changed */
 		blkcg_css = cgroup_get_e_css(memcg_css->cgroup, &io_cgrp_subsys);
-		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget(wb)))
+		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget_live(wb)))
 			wb = NULL;
 		css_put(blkcg_css);
 	}
@@ -813,8 +861,8 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
  * @memcg_css: cgroup_subsys_state of the target memcg (must have positive ref)
  * @gfp: allocation mask to use
  *
- * Try to get the wb for @memcg_css on @bdi.  If it doesn't exist, try to
- * create one.  See wb_get_lookup() for more details.
+ * Try to get the live wb for @memcg_css on @bdi.  If it doesn't exist, try
+ * to create one.  See cgwb_get_live() for more details.
  */
 struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 				    struct cgroup_subsys_state *memcg_css,
@@ -825,7 +873,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 	might_alloc(gfp);
 
 	do {
-		wb = wb_get_lookup(bdi, memcg_css);
+		wb = cgwb_get_live(bdi, memcg_css);
 	} while (!wb && !cgwb_create(bdi, memcg_css, gfp));
 
 	return wb;
@@ -858,8 +906,10 @@ static void cgwb_bdi_unregister(struct backing_dev_info *bdi)
 	WARN_ON(test_bit(WB_registered, &bdi->wb.state));
 
 	spin_lock_irq(&cgwb_lock);
-	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
-		cgwb_kill(*slot);
+	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0) {
+		if (!wb_dying(*slot))
+			cgwb_kill(*slot);
+	}
 	spin_unlock_irq(&cgwb_lock);
 
 	mutex_lock(&bdi->cgwb_release_mutex);

-- 
2.53.0


