Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA12CA5FD9
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 23:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDBA76B008A; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64676B0096; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9904E6B008C; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6649F6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBE781205D4
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:50:24 +0000 (UTC)
X-FDA: 85275703968.20.DA63AC4
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7B6E4C0002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:50:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b="VgP/LZ22";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf10.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790898622;
	b=uuo0svBMh7vJLCrpIk6RuJfe7wgYgx/LMEZHrQkz9VwMS/GmYmeq5uvZ2yViPfQNqcNzpx
	LZeWGFLIEaQ9ovTYCbJP2W72lFCK7XfOsm/gh8c2BtGGXjpeQU/C3ch+EFkjNv2Ox2GTEe
	Pg0N722orkhPFFjS1J2UOjM9/xRjq/Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b="VgP/LZ22";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf10.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790898622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkbgVn0hOl8J2PyYZEx2HrVzjihEzD82JKgo+2yW3e8=;
	b=g7o9CraDU9gOwb1ttpxdl3DK+lUBxRnu/u9f/lB5S00lQAkkAnkUNpAZSxk88wLenzvv+w
	TZiHFhGSbQGbFuOJ8+0pvvJVwhzmS49fWsoibRr51eI3L0akp1uxU7mzOBFgk2D/GweRNU
	lODLUlrqM4j+UZp3jspIW7PuQSVCD6A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790898621;
	bh=VkbgVn0hOl8J2PyYZEx2HrVzjihEzD82JKgo+2yW3e8=;
	b=VgP/LZ22umVCarSZDkK0kSgFrASQCagne30lPoX3u7kbQUE9VLJO/V+pcVKj84x/Iw0z
	dLDmhb/1ZcKBBJ6iXNPaZpPqyvDqrIYjj2oOPp5HR01KGAXRsYvhwziAXJkhB1s8YrHlaH
	Gf8L7gXq46ckxfR08JcB357kNjguDsi40aAoE4mXd34lFn6FDy8A+kjuwfTs2TI7tD4qvU
	xPBlFNlmBcAO3UjqN2sA1tLhxEUWW6wOFGue2FjBLxTbP7gqvUbbKnHAHp5Vi0pQ5j+Ihg
	Rs7uqo/TNQBVAcxzXRqhQQ3i4v7NQuWu7+pUIxT4rWmCPSegZgZaZlH+XPlqZAXA==
Received: by recvd-96bfbbbf8-f72m9 with SMTP id recvd-96bfbbbf8-f72m9-1-6ABEF1BC-9E
	2026-10-01 23:50:20.67012799 +0000 UTC m=+197347.827624094
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-1 (SG) with ESMTP
	id VYbtiOCrT9Oaypks3jsUOg
	Thu, 01 Oct 2026 23:50:20.653 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Thu, 01 Oct 2026 23:50:21 +0000 (UTC)
Subject: [PATCH v5 2/3] writeback: let foreign flushes reach dying cgwbs
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-wb-dying-cgwb-flush-v5-2-8361eb8c65c6@honeycomb.io>
References: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
In-Reply-To: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10836; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=aMKn3POyA9v/Cmui986qH6VkeVxGP8hDnOmgyTpKojA=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqvvG74zwfqEpi1bDr1z5v9BWSVr6Heu3vUvS4U
 2P4nLE/+J2JATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCar7xuwAKCRClztTjl62v
 wh6GCADrlLKwxbOCf4D8t48PS/2oX6LGs9d9sq1LzHE+AhFreqoaHn3tEnzyMu3yT19gRAiiTdF
 d2ye2YCmVrQzW8bsTozjILI3xbEaZwzy4ETSMycOQEPdpGc4Suwq+U2aYczZxotbg21JNSzgwVN
 7ZMncxW2VY67RT5cTn/T7a3QVeazJnb1uwRk43BhRCv4bCSnK2Shs6zVIg1EYtKQ3EWMR+P0ZFc
 7iQfQqjHv0Me4qHS9psKT7EkB+WBurJOaH/FltBj5EErMMwllpPJ10yhU9xdeEQGSpM/UY12/6K
 vKVv7oyJrji46qecrGHEidI8tizQo6euXCK+s9HMGCEuvk3K
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeZIowubUQn2g?=
 =?us-ascii?Q?k1flu2AkSiL6NhVr7emZgSmw8mBuSKW=2FdNsH43G?=
 =?us-ascii?Q?vEA=2FPpKvmMS1P61DClb2ngt0vWMup5OpiUaxEV7?=
 =?us-ascii?Q?SNa8k78cIE2hpv2aEg8E6h7qSdcgO26paUzn1ki?=
 =?us-ascii?Q?gY8X4bb2bksQzPLS3GWiOc=3D?=
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
X-Rspamd-Server: rspam06
X-Stat-Signature: btu3r5nizd5jkhhazj5fjo9f54yu7ea3
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B6E4C0002
X-HE-Tag: 1790898622-290999
X-HE-Meta: U2FsdGVkX1/p3AiMqHepoCG1BKU2t4Z8SpTPynuH5yk6FziSlhVrIAC1yv393RAXBqrjqASs1Km+lbFvmTQTdvf7OLXQDAGaUYjhWMajPtX5hnCgf7DH9D0Il6NzXgBw6vkH20oC8UFerSBha3vPxi80zYoc6dyDIVAo6/E904WItQeWJS+FrbBFsumhIC2pnroj8YUXqLYpHdoGp2L5CqbQMWsyDmtNKF3lp8LuyWD6AftE6e8dK5k0BMbAoJ4ORLKZlDtptIHvIjI3CFTEwH4dTFcplrWWcIPHX1X1l6blOhsNK/1MzqkRiz90DaKOlulaye2jkoVTsfUx9FJkbrV7P9MSWLFIDHmiVqL4BYp+SqaU7aHjS4X1k4LdOyS95+g2QPAHIJ1+caNf6y9s9yVuKlwQCL/+A/HJutv0yLRpk1HEWzdEWHS7EPI1S82xagrqP6/usL+dzmVIW5CergRR8TvVHI8mrZ3GwSw72mksfDvc2+IXWWKCMMzgOnTQGlC0c2uP81rjqX1wfCI1Aj6nzW4GpUI2YyiPyTpuRweKZEYYhbmwMJHK964117NfnowNy6nUwaaQwtYpKObwXE+jsvMsps2HbyPDhXQinZbmy5VIE32pCPZzp0KxwWWLpK3fL+oXkhFiccPrtGS/ARAzmlRfo7fxo41lMCgRtkjKAtH+5hfHm+rCl59hVE/y4+hO1bE/Ah0rIxX2gHl6t2qWxeIoXyqd6qnms9bIqIw5JgGBnPEe9uORMPrXPwtz0lV+KWXvKm2mJC978/JRQebOkrAOTd29aVuFywNBxPXbBSMYLpW8n+k0njyNsjxtHvV5Mel10djWDqFFuG0FTn5dhBvIcUmoejqm97JKdIRY0IQ0LiQvnawS9MgA75tUs2ULmPb4jMHt2QY7S7GBACHaWZZLG6PZ9MUDbvYiHn989RST2h/TPtxqGgMIWlxl7OVnkKiyURITkpRsGPa
 PogmjN50
 6gRckSZ5Jpq9oVuAQaS6NkmRzcn6BhzBzVMRuFATcxhHWF8q7A4sB1eVHpRnhahZchZLOQ0+1BTY9/Dq/1yJQDMObw2JCYu8CVHdCAwHwlk3yW1CaKg6ig0u+gicspzBqLU4B2D6r9xOUupwcMcMftsyzE+rO33c/rGbyw7rPYwDWP9q1lA//qja4QEXNso6xF2mHnxC4l71rXJOnIgShOVNiIQ39L5fLLy4y3Gc7iQSZDGmD0zqAj6uc1X/YLXYwJ5bqGBExSxmoBF7kX5MDrpM0JWfGrVMsZYXSMMA1Wf3iOnr0UwlxloPdyvLD65M8LXabw24vyvpNk4xW0meeiSUP1wVRVT8udgDyPLPInM8OWng29lGeCZIlg8SxqUuj6c7a+VQ943Hpccbh+6kSfApnJLLsxZZsw55s7sc3f8sVINofuM7ob9w51zbHW/kbkXX6UUQprOrqK8prP/qGh6HmYIwFc5Pu4tbywU4p2Z6AonitudJlvdPoEkraf0MU1Cjfk72sCujG9oIIEvilNcfW34ipSC7cZYFu
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
dying one when the memcg's blkcg association changes; release only
removes a wb that still owns its slot. The blkcg association check moves
from wb_get_lookup() to the creation side: once a memcg with io enabled
is removed, cgroup_get_e_css() returns an ancestor's io css and its
dying wb would not match.

With commit 168a8c13159c ("writeback: size foreign flushes by target
wb dirty pages"), the flush is then sized from the wb's own dirty
pages and writes out what the replacement dirtied.

Test, on top of that commit: a cgroup appends to 1000 files at
250MiB/s and is removed, then a second cgroup keeps appending to the
same files under a 4G parent limit. Worst lag of the second writer
behind schedule over 120s, in three runs:

  without this patch   85.3s  46.9s  52.1s
  with this patch       1.0s   1.2s   1.2s

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 include/linux/backing-dev-defs.h | 13 +++++-
 include/linux/backing-dev.h      |  2 +-
 mm/backing-dev.c                 | 89 +++++++++++++++++++++++++++++++---------
 3 files changed, 82 insertions(+), 22 deletions(-)

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
index cecbcf9060a6..839a3c476c5b 100644
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
@@ -727,8 +737,22 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	spin_lock_irqsave(&cgwb_lock, flags);
 	if (test_bit(WB_registered, &bdi->wb.state) &&
 	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
-		/* we might have raced another instance of this function */
-		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
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
@@ -768,10 +792,29 @@ static int cgwb_create(struct backing_dev_info *bdi,
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
@@ -782,9 +825,13 @@ static int cgwb_create(struct backing_dev_info *bdi,
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
 
@@ -798,7 +845,7 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
 
 		/* see whether the blkcg association has changed */
 		blkcg_css = cgroup_get_e_css(memcg_css->cgroup, &io_cgrp_subsys);
-		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget(wb)))
+		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget_live(wb)))
 			wb = NULL;
 		css_put(blkcg_css);
 	}
@@ -813,8 +860,8 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
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
@@ -825,7 +872,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 	might_alloc(gfp);
 
 	do {
-		wb = wb_get_lookup(bdi, memcg_css);
+		wb = cgwb_get_live(bdi, memcg_css);
 	} while (!wb && !cgwb_create(bdi, memcg_css, gfp));
 
 	return wb;
@@ -858,8 +905,10 @@ static void cgwb_bdi_unregister(struct backing_dev_info *bdi)
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


