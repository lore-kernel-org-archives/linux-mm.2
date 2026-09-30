Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C8BCA5FC4
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 19:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060716B008A; Wed, 30 Sep 2026 15:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0106D6B0088; Wed, 30 Sep 2026 15:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3E76B0092; Wed, 30 Sep 2026 15:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4E2D6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:35:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13BD2C01EC
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:35:40 +0000 (UTC)
X-FDA: 85271433240.08.499472B
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0AFEC1C0003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:35:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=OozwD2Xr;
	spf=pass (imf21.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790796938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfQLOxnziLTxjQKL8Pf0AVd4fh6mbAmq6Tdocr9SWDc=;
	b=BU0MqaKYJp9Bi4KgZYyO9ZpyJ1hnFlppBQD8BAm2Dk096bwYlI1IMaNG0oufWnQxaQP6AS
	7Ut1Pqo7PEUZXD7UMjIx79y21X3fWoecTxdMMhwqRXfZDZ/Dc8t6uEet1ORrAs5/N+UqLI
	UQD4SvEFZjXv0cM+qQmx/mxWZY+u+Fg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790796938;
	b=IwozF6Aqo3ZGtDz3pfZeavTaIOVuZ840JKv9w78hkgHVP+sFX6LY7p99ekVN8Stpq4eXmQ
	hN+h7CDdPGU3aOXJ63RcN48h/ZLVz2kvOOB2QHc2LGO3vfq5/UiECkTYVuvBBeX2giZ2Ie
	c5Krj4jtf9Jx0Du+X3Ruvr60BZ8WR0w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=OozwD2Xr;
	spf=pass (imf21.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790796937;
	bh=YfQLOxnziLTxjQKL8Pf0AVd4fh6mbAmq6Tdocr9SWDc=;
	b=OozwD2Xrel8r3DcyjV7mqg/UkrmrQMyMD0oIXGCoT7vvicTgsV60MK3dq3ykWSCqqsfR
	qLJ1jTqrc+gpXoZ2rSrq1SCoI2orR9CitRxeIX1k7+nlvvSW3S7zDULhEayMPdQ+6MATcv
	028jy3g1A9SD5OvqP1MkR7jEcqcdz0t5rQ8WlQgL2t2Y85ggV50djMX9RznWhZ5iu8ChOd
	ko8udnG/nqQxXBbxuwfkyCqEb1DUfXakIooxBQIjQYYFVUWL5yTkHiCNrvHlLcf2uNwdaj
	xsjvynLoaXKt4r6k9bOhqgIXnpP1W9pkZhvBZFEt/mmTPwmD8S8AGNPTa2LVpTPw==
Received: by recvd-canary-66cfcd45bd-9jvv4 with SMTP id recvd-canary-66cfcd45bd-9jvv4-1-6ABD6489-22
	2026-09-30 19:35:37.098483822 +0000 UTC m=+95717.896768965
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-6 (SG) with ESMTP
	id vYi8QUmxR7GSbccC0Qr4Kg
	Wed, 30 Sep 2026 19:35:37.043 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Wed, 30 Sep 2026 19:35:37 +0000 (UTC)
Subject: [PATCH v4 2/2] writeback: switch a replaced cgwb's inodes to its
 successor
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-wb-dying-cgwb-flush-v4-2-bde637803a96@honeycomb.io>
References: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
In-Reply-To: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7266; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=OWMqHTRcSCq9JRpd/cUEN865093Q27Hfcw/XSt9HYl4=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqvWSI8vzgoChHJ9XeclnXBBr/7u3BtXFZTIxwM
 O68DEmqEyaJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCar1kiAAKCRClztTjl62v
 wj95CADsEIfLtgtsxcIq8sUVgfwFfEjJeZcH3drAw/AbFa/wt33Rh6La1C6aGx1TtAEhbBoU3Y0
 m+6UQ47xJ9NYCOUF0zGW1PxdkOen6qHFMvBlOUb7Y3m9k+01ggaxyzN7jxPWaqWzTNgZrD/DDsl
 IJBFerEOpcfx6tv8iJGrLvy/SSv1EO3qK8fDc+T6J6nFPPzvUZKj5MduQbuCkt3E6mV2DyqAwwE
 rVW1nvzkzY8HDXvaRzuyA3OxESZzZLQeAB8fPIEJJpxnVJaerfIfjgCgvIl2makETz/AcNAMR4i
 ZGRhVND+nkDIw2sGqUB2Zxozg8iWfvfj/qMJkceWmtJPHIu0
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmefilDisU+bGm?=
 =?us-ascii?Q?pq2O0nD2+F2p8kpM21yy=2F7jQVtDYVedx9losOTt?=
 =?us-ascii?Q?wou+Q+V56IqDHpiS3nxB5+LEYExB5SvreUSKpN9?=
 =?us-ascii?Q?bN4E=2FKHXI3pH98Y2zeP9jlIzGKkyeH5IJCQ3Q=2FG?=
 =?us-ascii?Q?OAYOYhMoGQGgO3vqO22ERvXY1Z0FuhfL8a5Ukzf?= =?us-ascii?Q?BleN?=
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
X-Rspam-User: 
X-Stat-Signature: ufkcphajjidgs4dqg9jmgo94hqrte9d4
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0AFEC1C0003
X-HE-Tag: 1790796937-425345
X-HE-Meta: U2FsdGVkX19jt1HL5thAchq4jhjiWOr16odR7obAuQwRt/y0BagFBBKv8K+cCUeNim+ZiIVr7+B4NPIg4t4JOfj9F+cP0yf3c69HGp3cNGVzf70GVfmpEcXsjf86sO7wTsqjoWqiJA3iSWKC48ONNcjAIdWJbAxKYDxPGMsX4V+5OHYPkbGrZaXbj23+QShetHd25IAzvZdDr6/5f4XBC9wNw+EDTUTZ5m9kH3TT3iIGodo1/TmMRRuurroyxCawE+tF0xDxPkmSn/C+x/xAHgMdzu9OeqDhtuGJLwPkbt47xeC+0UxE6fEGKIj2UkT3n+9dPSEKKUa+SL5gHg138Gx4xsaHPD1hFdG+ULAMpLSafm2cytWq8Ljvu/IOOBqFKtiJs3FtOLCDf4Kr+9/Qo4yvmgVg2tSkGMGREjmAi8C1f5gJFTBrKxiC9cxm2551EsdnfHNsTA4oCsrzjj9N2qbh9+Gb+9gHb75FmXWoQKqc7vRJ781T8HNJJdArts9HRPBdA3Dn7fsKT+dZfsQWpne6+pibPAcAogwp83YVFxC3pUaaXws59n8EK7fuTaHvasMLyccEhOWPZGziUaCuP5T4kmot0VCAJD1LOgRR7/QoGy7FvS5ZJ9Fv6RyzMmh91rtOhMI6x9Ob0ab1Tf5iqPq2kufOiqoClBUoGLu72Y/yCgdazgIQdtew225xPRVud7C9wiNj47UgRP9NnpX93Y6jd7ecAHNKPKBTE4pu3/X8s+K6d5W+WGPz2p73MlLbvc7i3YAz+nUhiWzJJ0DxOHoQdfp73mLj6MVdMlKuX2Wi3jz0nVuI4JpqbOxIK8viaZYf7UEy6nwf72hp039ZOyNl0p8F7KKDxbcbmsXQkZs7shbS85ykaSMyvv3MVO9QQaIXkr4mEDibQs4Y5pPPUM2Zi2IHM0eMayj1KP9XCt5fVlTQP1wgDqTKPAds3f/cd1e73np/OdGlIxFF2Os
 idOYFHg0
 posdG+n30LvaiuIdhnSPd3QddcBi7mzoDjlwaTfYFqx4PR3PRG1u9Yk3VtJSdr6fm/UlGh3J23NRhA97WdbNwQtbtjYrKXfaiAA5RA+70yzbXwv4oWezJHURLp8JGDgven2maL7dj/drRKvTvLVzvEyprDWIlJbkQ/X2uRcKk5dwffB1A8oHM7hdGxl0utSxrAPxblqFROGFCaeve4sxp0Nx0fNNpcgMKPlUwcEPVPYqcnuumxeRvUjaXRFzcPNw0y0gXK3uEKV4PH/juS6W7Yus0wzkKwBgrUNWjOZzLAhGJ/DBI1ir2oC5rcURgH1k3GPeMgbfM2w6yRkNRBNMcRJGxH2TAO7ns1Z9hxBnya/6OfqeT3F/ubic96TDTEUMZDu80mR11t/mBfyZcWwWQzaQlR9/5zXwjGohf37mhOtKu3BPF9eOWNZ7Ox8s0x6GTdnwe7nDtU2VQhzuSBHVm7dkBsgUrzLP/5mKMjWfNF9LRYcT8H08+1f3vbCoGh+xgNhN2c+fUZSzXy35te3m8IHiKI1NjWBaZJrXx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a live memcg's blkcg association changes, cgwb_create() replaces
its killed wb in bdi->cgwb_tree. Foreign flushes for the memcg then
find the new wb, but the inodes, dirty or not, are still attached to the
old one, and they only move over as they are written back (see
wbc_attach_and_unlock_inode()). Until then, other memcgs appending to
those inodes stall in balance_dirty_pages().

After the takeover, queue a work item that switches all of the old wb's
inodes to the wb foreign flushes now find, like cleanup_offline_cgwb()
does for b_attached and b_dirty_time, but including b_dirty, b_io and
b_more_io. The switch carries the dirty and writeback page counts, so
nothing needs to be written back first. cgwb_create() can run with
interrupts disabled (folio_account_dirtied() -> inode_attach_wb()), so
it only queues the work, after dropping cgwb_lock.

Test: a live cgroup appends to 5000 files on XFS at 250MiB/s, io is
disabled on its parent so its wb is killed, it creates a file (the
takeover), and a sibling keeps appending to its files under a 4G parent
limit. Worst lag of the sibling behind schedule over 30s, in three runs:

  without this patch   16.6s  28.7s   1.6s
  with this patch       1.3s   1.4s   1.0s

Switching all 5001 inodes took 40-60ms per takeover, with up to 139MiB
of the old cgroup's pages dirty.

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 fs/fs-writeback.c                | 53 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  1 +
 include/linux/writeback.h        |  1 +
 mm/backing-dev.c                 | 27 +++++++++++++++++++-
 4 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d26b2cf05283..1d26a137e8e4 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -803,6 +803,59 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 	return restart;
 }
 
+/**
+ * switch_replaced_cgwb - switch a replaced wb's inodes to its successor
+ * @wb: target wb, replaced in bdi->cgwb_tree by another wb of its memcg
+ *
+ * Switch all inodes attached to @wb, dirty or not, to the wb that foreign
+ * flushes now find for @wb's memcg.  The switch carries the dirty and
+ * writeback page counts, so nothing needs to be written back first.  Returns
+ * %true if not all inodes were switched and the function has to be restarted.
+ */
+bool switch_replaced_cgwb(struct bdi_writeback *wb)
+{
+	struct inode_switch_wbs_context *isw;
+	struct bdi_writeback *new_wb;
+	bool restart;
+	int nr = 0;
+
+	new_wb = wb_get_lookup(wb->bdi, wb->memcg_css);
+	if (!new_wb)
+		return false;
+	if (new_wb == wb) {
+		wb_put(new_wb);
+		return false;
+	}
+
+	isw = kzalloc_flex(*isw, inodes, WB_MAX_INODES_PER_ISW);
+	if (!isw) {
+		wb_put(new_wb);
+		return false;
+	}
+
+	atomic_inc(&isw_nr_in_flight);
+
+	spin_lock(&wb->list_lock);
+	restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_attached, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_io, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_more_io, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time, &nr);
+	spin_unlock(&wb->list_lock);
+
+	if (nr == 0) {
+		atomic_dec(&isw_nr_in_flight);
+		wb_put(new_wb);
+		kfree(isw);
+		return restart;
+	}
+
+	trace_inode_switch_wbs_queue(wb, new_wb, nr);
+	wb_queue_isw(new_wb, isw);
+
+	return restart;
+}
+
 /**
  * wbc_attach_and_unlock_inode - associate wbc with target inode and unlock it
  * @wbc: writeback_control of interest
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 035d25f5b81b..0d9a113f6fd6 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -160,6 +160,7 @@ struct bdi_writeback {
 					 * to this wb */
 	struct llist_head switch_wbs_ctxs;	/* queued contexts for
 						 * writeback switching */
+	struct work_struct replaced_work;	/* see switch_replaced_cgwb() */
 
 	union {
 		struct work_struct release_work;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b749a9a5a5ee..88e4b5049698 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -209,6 +209,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 			   enum wb_reason reason, struct wb_completion *done);
 void cgroup_writeback_umount(struct super_block *sb);
 bool cleanup_offline_cgwb(struct bdi_writeback *wb);
+bool switch_replaced_cgwb(struct bdi_writeback *wb);
 
 /**
  * inode_attach_wb - associate an inode with its wb
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index a370dd94b6a4..1acda0233e69 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -637,9 +637,20 @@ static void cgwb_release_workfn(struct work_struct *work)
 	bdi_put(bdi);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
 	WARN_ON_ONCE(work_pending(&wb->switch_work));
+	WARN_ON_ONCE(work_pending(&wb->replaced_work));
 	call_rcu(&wb->rcu, cgwb_free_rcu);
 }
 
+static void cgwb_replaced_workfn(struct work_struct *work)
+{
+	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
+						replaced_work);
+
+	while (switch_replaced_cgwb(wb))
+		cond_resched();
+	wb_put(wb);
+}
+
 static void cgwb_release(struct percpu_ref *refcnt)
 {
 	struct bdi_writeback *wb = container_of(refcnt, struct bdi_writeback,
@@ -676,7 +687,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	struct mem_cgroup *memcg;
 	struct cgroup_subsys_state *blkcg_css;
 	struct list_head *memcg_cgwb_list, *blkcg_cgwb_list;
-	struct bdi_writeback *wb, *old_wb;
+	struct bdi_writeback *wb, *old_wb, *replaced_wb = NULL;
 	void __rcu **slot;
 	unsigned long flags;
 	int ret = 0;
@@ -724,6 +735,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	INIT_WORK(&wb->switch_work, inode_switch_wbs_work_fn);
 	init_llist_head(&wb->switch_wbs_ctxs);
 	INIT_WORK(&wb->release_work, cgwb_release_workfn);
+	INIT_WORK(&wb->replaced_work, cgwb_replaced_workfn);
 	set_bit(WB_registered, &wb->state);
 	bdi_get(bdi);
 
@@ -749,6 +761,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
 			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
 			if (wb_dying(old_wb)) {
 				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
+				if (wb_tryget(old_wb))
+					replaced_wb = old_wb;
 				ret = 0;
 			} else {
 				ret = -EEXIST;
@@ -764,6 +778,17 @@ static int cgwb_create(struct backing_dev_info *bdi,
 		}
 	}
 	spin_unlock_irqrestore(&cgwb_lock, flags);
+
+	/*
+	 * The replaced wb is out of foreign flushes' reach but may still have
+	 * inodes attached, dirty or not.  Switch them over to @wb.  We may be
+	 * running with interrupts disabled, so use a work item.  A replaced wb
+	 * never returns to the tree, so its work can't already be pending.
+	 */
+	if (replaced_wb &&
+	    !queue_work(system_dfl_wq, &replaced_wb->replaced_work))
+		wb_put(replaced_wb);
+
 	if (ret) {
 		if (ret == -EEXIST)
 			ret = 0;

-- 
2.53.0


