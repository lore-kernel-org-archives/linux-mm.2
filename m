Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE5D6CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2F086B0092; Thu, 15 Oct 2026 07:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07196B0095; Thu, 15 Oct 2026 07:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCDB16B0096; Thu, 15 Oct 2026 07:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3346B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:40:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E1A61609ED
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:40:51 +0000 (UTC)
X-FDA: 85324668702.17.F364840
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf14.hostedemail.com (Postfix) with ESMTP id EE95A100008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:40:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=ED7E6pCD;
	spf=pass (imf14.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792064449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzdjeW3U5iYSc9UlhhANALmazAl1WFbkgMQQE/uB9R8=;
	b=U09rQCgQJkNTdtj9Q1rxeO1d53S5O22urRsqX4hD5+OUI7nftqg+yXGwymHFJ/dwZl3KYp
	lt5omIFwMZ0uQxY9klREYEF9wF9LjU9PgmsI/KapXeM1AFDvBGdN6x6x9E7VvQa6A8r+xT
	G6qhh6m+lWLckM0f2a31lDmEnYXolLs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=ED7E6pCD;
	spf=pass (imf14.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792064449;
	b=40w8S13M/0zdXFKLhxWQ91pX45JwabKL79AiZVG51a5vnwzCLD3BQJuNFhREu01cLDECD4
	ArbxKdPgEB41DY6nwBpeg/ZKZl5Hv8NoLu+y/YROg8C+8GJQ57SANLSGQflblXCGtax724
	AAQCR3Iuv0hoahbz1hs0kmYzGY7n29Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1792064448;
	bh=RzdjeW3U5iYSc9UlhhANALmazAl1WFbkgMQQE/uB9R8=;
	b=ED7E6pCDZ9E3NddvBkiDAeRfFDhwRevyv0sk27ZIeeVlEWk0eLvzEqHVN88Y0Wl2+Y9X
	h9D8JDY64TOlmWw+ThcLUM8/7bKkHqvOk3K4dyk7euRc+0c8/bZTboGkVWiL90erFVCg84
	7ZeSc1aikEoiq8eyL8bcljyxO8lmGOFIQsMEZ1Q66RfN+NlmclAcpbfOQXoEzbAggO37XT
	7X40YZcwcITshnjdu35P1pE1uGnrdtEZ4tNLWdj2gKqHoZzrhQlttB7Qn6CsG7AyDRRkGc
	3KvgxasnmcuTrUQM2F9aowKcOFC1MdLowV5FWs14f/zX0MWZ5MliGjtLvpAWjo4w==
Received: by recvd-569578f769-lx66h with SMTP id recvd-569578f769-lx66h-1-6AD0BBBF-97
	2026-10-15 11:40:47.887096221 +0000 UTC m=+1363195.448437516
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-34 (SG) with ESMTP
	id LoJ_VN_dSUO18XbpkEy_-w
	Thu, 15 Oct 2026 11:40:47.815 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Thu, 15 Oct 2026 11:40:48 +0000 (UTC)
Subject: [PATCH v7 2/3] writeback: let foreign flushes reach dying cgwbs
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-wb-dying-cgwb-flush-v7-2-9278d9ebaf5d@honeycomb.io>
References: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
In-Reply-To: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12048; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=KpZtVcE0e93c8SSc9s2GJpU+FeKJqfZm1yKTRBZwwoM=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBq0Lu8K/v4KoBE/vIKtWWmebyTaNtPOK8U4log0
 mRWfVnOvhOJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCatC7vAAKCRClztTjl62v
 wgTSCACPZ7/uHHXOtB3n/GcA6BvGlQxFAASYnD/C98Vlwej7JIVam/1bvLvaecEVbGyRt4T2ptf
 YV9Rku3DFB47t01Ht54ZWTpqOD+rAZz5y5mPQdDwhmzpOmjM0XqLgat6vh4YC+Bm2L58RKtJjGG
 OQSfnWVp9P2jZqMob+p4RbLNCmarh2iC+1mm0w7tjPFY5ZPfw8Dn2S0ldWi11ZPho5EeC2hm585
 sa2QO6k29xX4zZkSf2m+zFkUas7LRYRJJdLHNKZhlCWaPpdypVglot402q+ZVSODaHrTBN0iJk5
 6a9FqrvTGmi9ySG8SNldFFkmrwEx/VES0Z348YpbezOLvh3j
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeZ0YSzsY9DTf?=
 =?us-ascii?Q?DvVSKj0dU7yEZMF2m9tZskb8d+oJwMDVHdcKQuF?=
 =?us-ascii?Q?oh3Ja7OflLxlUUz0KeHuplAH0tbgy+V5MjWPtkK?=
 =?us-ascii?Q?YPC+0aUlIz1UL32pc7njC8tWzF9i3IqK+x7GuGd?=
 =?us-ascii?Q?t53jpueIA2ITa8cD+yYi4ZgSGg5XQvu10powu=2FW?= =?us-ascii?Q?a5SK?=
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE95A100008
X-Rspam-User: 
X-Stat-Signature: bu5i4dpgkj7qwgd1psbh5i339bhs18n5
X-HE-Tag: 1792064448-457519
X-HE-Meta: U2FsdGVkX19cJVE9TFqH6Gk5ckx3+Y/1O08jhD74P3mFtRM/y8bIOQ+PZ6blah6vXVm9sVtNByxVnSbWXKTe3MMDaIJz+lb906gzzthOYEVn2QyNWRIuaRW5z3Comaq+CRichWGQ0AMDFOH34HnEEjjOwn7uzb5Z3nNQfbv3mfxEAwOI7TuHFd2OZZOCNkh7hYlWG44XJoiSh/MXAkZ1o++rFdNCsFT7Ut1UW4mGPWq+9po5tN7GO0dEGY2SbpUV88f48JOwPUXHD2szT3opU5TF1fdx88DDtAzrpiH3LE9QYFhCUl8XHJAQNrpcTq5/QaMcGpOLFNHaydhlR4JXBjYEXTUhL2sFjyPnv9ZxfwbXqJNk99SQYOeLYfrE/3z2SvV2RkgcusRkYohAubpCoETnLauohKDV8YcyuqwiD5gPvASc65KIt4oDDHa0d1fgVgOCn0aRPfxVJdjgb1V9n/1/zEpl9+2u11tkAMuQUe+vf8H2/5FjG5Yu1N6DyNzJAXTWj/5eBl9uW1MJ8OMfYgDFe4v2hAbE44DiSfZgOMXEZJSboo4wXPiFlxbWghS0YZ9gQGeqXRIXSAzyX7J49dNLVYH2sMpBQ4zDOvbdCNkdC56MF3avYSnoB83DvzAdYkFiPwjJXB985MAD3/vIv4VG9hA6OP0TJlzM4WTmji6h/04Q0neYMXgUTpZdfVey61Vi+F2zhb2DRJ7HEOp72rxdrxlgGSu/4e4xOS/JWO9bblMnpbrRueT3Dcjr0Mwx7ilzDd8snxXTcuSgWA/shgj3UPVs+4EnX1DCJfA0QfslXSn/fmGSYg67iCqvFQRaPxruzpIo8rozPkBs5OCxM+Nyh6ndafC70Vob7eWwRdVzTIP25WeKHRyFzq7+KuylJLC6AczYjZVJMozibsWL6th1TrO2NjM37GwbySB9dR0dI+SDzqgKU26jxD7X8oI3VORJ2b6Vcn+5MJLWIg9
 ibljbZGw
 WrlX8Gku3G1xpT9IkaTx0G2+vl5EuUar4lKAcA5cMF04kahGY3ZaxP1viApN+FoVY0lxs+ziJZ+h35n83BRt/LMrWH6p/SX7RXIC47AP5iIbQFt1eJ+P1j/DZcbHnkza/8JySwG98U880JvhSu+tjWaVfbZcJ17NpFwzBSrxxT+Xz8gKRpQvMTlLT35C/xGOjVUJCLz4QrpMzNMdZ9SpcX+iDmvB8R8y9bHQGc6LWV/tK9KjyKIZvqdkjcl7o78NwhVV8BIeeT57c8M98CPyumIgaejnuQMmaDyVKZgMO8U6WtdONFA8yW33NaPDqbB1Yi4RALbKg3oXvOog/4tygf6C+iJKyCcrbcWSbJDIzBo04xTvwKugWVo48eJd4UuxV4MzpcGkrZtccFFptR+KpBDf5Kq46017dE45AU3o0eCJGP3WYS4sve2rmF/jrlD6nT6AXObmFKdcmi9e5EYM8egaRDh1DFlu+yx7ot+eloS5YWjj354Dykv0EExoYzvL3rog4thYi9S7QlA4JBtj+oYpB0vo+dm8QEzL0
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
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 include/linux/backing-dev-defs.h | 22 ++++++++--
 include/linux/backing-dev.h      |  2 +-
 mm/backing-dev.c                 | 90 ++++++++++++++++++++++++++++++----------
 3 files changed, 86 insertions(+), 28 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 4f1084937315..33e06b1b1e1c 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -100,8 +100,10 @@ struct wb_completion {
  * refcounted with the number of inodes attached to it, and pins the memcg
  * and the corresponding blkcg.  As the corresponding blkcg for a memcg may
  * change as blkcg is disabled and enabled higher up in the hierarchy, a wb
- * is tested for blkcg after lookup and removed from index on mismatch so
- * that a new wb for the combination can be created.
+ * is tested for blkcg after lookup and killed on mismatch so that a new wb
+ * for the combination can be created.  A killed wb stays in the index until
+ * it is released or a new wb takes over its slot, so that foreign flushes
+ * can still reach it.
  *
  * Each bdi_writeback that is not embedded into the backing_dev_info must hold
  * a reference to the parent backing_dev_info.  See cgwb_create() for details.
@@ -196,7 +198,7 @@ struct backing_dev_info {
 	struct bdi_writeback wb;  /* the root writeback info for this bdi */
 	struct list_head wb_list; /* list of all wbs */
 #ifdef CONFIG_CGROUP_WRITEBACK
-	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
+	struct radix_tree_root cgwb_tree; /* radix tree of cgroup wbs, incl. killed */
 	struct mutex cgwb_release_mutex;  /* protect shutdown of wb structs */
 	struct rw_semaphore wb_switch_rwsem; /* no cgwb switch while syncing */
 #endif
@@ -229,6 +231,17 @@ static inline bool wb_tryget(struct bdi_writeback *wb)
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
@@ -271,7 +284,8 @@ static inline void wb_put(struct bdi_writeback *wb)
  * wb_dying - is a wb dying?
  * @wb: bdi_writeback of interest
  *
- * Returns whether @wb is unlinked and being drained.
+ * Returns whether @wb has been killed and is being drained.  A dying wb may
+ * still be in bdi->cgwb_tree, see cgwb_kill().
  */
 static inline bool wb_dying(struct bdi_writeback *wb)
 {
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
index cecbcf9060a6..85b2c95a920c 100644
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
@@ -765,13 +789,27 @@ static int cgwb_create(struct backing_dev_info *bdi,
  * @bdi: target bdi
  * @memcg_css: cgroup_subsys_state of the target memcg (must have positive ref)
  *
- * Try to get the wb for @memcg_css on @bdi.  The returned wb has its
- * refcount incremented.
- *
- * This function uses css_get() on @memcg_css and thus expects its refcnt
- * to be positive on invocation.  IOW, rcu_read_lock() protection on
- * @memcg_css isn't enough.  try_get it before calling this function.
- *
+ * Try to get the wb in @memcg_css's slot on @bdi, killed or not.  The
+ * returned wb has its refcount incremented.
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
@@ -783,8 +821,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
  * each lookup.  On mismatch, the existing wb is discarded and a new one is
  * created.
  */
-struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
-				    struct cgroup_subsys_state *memcg_css)
+static struct bdi_writeback *cgwb_get_live(struct backing_dev_info *bdi,
+					   struct cgroup_subsys_state *memcg_css)
 {
 	struct bdi_writeback *wb;
 
@@ -798,7 +836,7 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
 
 		/* see whether the blkcg association has changed */
 		blkcg_css = cgroup_get_e_css(memcg_css->cgroup, &io_cgrp_subsys);
-		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget(wb)))
+		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget_live(wb)))
 			wb = NULL;
 		css_put(blkcg_css);
 	}
@@ -813,8 +851,12 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
  * @memcg_css: cgroup_subsys_state of the target memcg (must have positive ref)
  * @gfp: allocation mask to use
  *
- * Try to get the wb for @memcg_css on @bdi.  If it doesn't exist, try to
- * create one.  See wb_get_lookup() for more details.
+ * Try to get the live wb for @memcg_css on @bdi.  If it doesn't exist, try
+ * to create one.  See cgwb_get_live() for more details.
+ *
+ * This function uses css_get() on @memcg_css and thus expects its refcnt
+ * to be positive on invocation.  IOW, rcu_read_lock() protection on
+ * @memcg_css isn't enough.  try_get it before calling this function.
  */
 struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 				    struct cgroup_subsys_state *memcg_css,
@@ -825,7 +867,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 	might_alloc(gfp);
 
 	do {
-		wb = wb_get_lookup(bdi, memcg_css);
+		wb = cgwb_get_live(bdi, memcg_css);
 	} while (!wb && !cgwb_create(bdi, memcg_css, gfp));
 
 	return wb;
@@ -858,8 +900,10 @@ static void cgwb_bdi_unregister(struct backing_dev_info *bdi)
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


