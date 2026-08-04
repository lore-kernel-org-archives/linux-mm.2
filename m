Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60390C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64ABB6B00DB; Tue,  4 Aug 2026 10:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621D06B00E7; Tue,  4 Aug 2026 10:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5377D6B00E8; Tue,  4 Aug 2026 10:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2379F6B00DB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:13:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DED921A0157
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:55:42 +0000 (UTC)
X-FDA: 85063583724.30.778381C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id F0D61100006;
	Tue,  4 Aug 2026 12:55:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="b1Kg/eLb";
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf14.hostedemail.com: domain of BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785848140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BQEuAZ2arJsGFIE3GuxvC06xXOl5VMmGb4FBQO07XKY=;
	b=6cqt09AThSXylm7niO60ZiLlydXzQwwf8ujNSSgx1/1sL6RXHh2V6TwO4rkz7xy6fY2Zu3
	+x6i6tajfO3ACDbaG0Hv6/CLlmE3KEeBlH3B/7hyAmGwSTRFjOXZUYkaYYs8SITTSRPbd4
	aucx26lDp7cypRKOgozRsT3yLGnpQ4g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="b1Kg/eLb";
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf14.hostedemail.com: domain of BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d7a51db447a6f215910b+8381+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785848140;
	b=xylAFOlaSafCTp9GiVFwl0vbeIOvlkSXI1hpLsMMMgJXgWywOJK8BcL+plH+7cSOnGAEiW
	IxNDw1nWweGNYxaTcnDpiorvUFHf2ZPSWrOB+gRAFf4mjazjG/YNhkIsJiAx0y/ipCKDtw
	q9v9Q4+PxAosrox428OyjehesB0QGQQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=BQEuAZ2arJsGFIE3GuxvC06xXOl5VMmGb4FBQO07XKY=; b=b1Kg/eLbQE46Mycpi8QoVjlByI
	LGn3HirFzkV2qSe1TSSpfgTYscLDSRlwATfmKCgZ/A/NCno4UEBnQ3T7zu60xllabtu/zrdRGJg2S
	0au+adsn9CB/H6BvWWN8rxh/OeVRaAVibTKEjrD6igjhbslGBSJMWRBshrbr4xPpjF2u8pq3ST9D2
	N4hpWxi+4QPb/84GIsJyh2Sl1h6SRc0V6NCKTZddrTC/6QeNDTgoWCjUNz1bIOuAMzQ9enek+vkkw
	gE/wbGS2NR3GNLbmweIsumcImXt6Qlq4loYRfB/Yoz9F44Thq/j+GM/DcnVAyPB0g1+rgWW5yV5jh
	y8JavISA==;
Received: from [93.123.20.94] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrEg8-00000001rUa-45ES;
	Tue, 04 Aug 2026 12:55:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-mm@kvack.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2] block: split out a new blk_plug.h header
Date: Tue,  4 Aug 2026 05:55:10 -0700
Message-ID: <20260804125524.740996-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: ogbzfaanby8ohghi4hp4jmk54jiaw8a5
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F0D61100006
X-Rspam-User: 
X-HE-Tag: 1785848138-583944
X-HE-Meta: U2FsdGVkX1+w/EB1CN6BPggneyf2dFknV3RIh1hGn7ADr7aI1OiNdYj4vj5tAbwg2Z0E5S4pPS94IlEo9YPlqt0cQd+dd/FOo/YrgoEQsWzAljBpFKHhmKNvPZ1Q4i5AIu4bSU/20TETPXTQheNbgch+KdGFtVQ6LUsoB9fOaucBCOcWpEXj7UklhddrvmY3EdotOKMhpB/baB330Fz6vrDHyMC7gHCiPx6eqHskoKVNRdc2q9oXFhrIPlJ1efSasdqKgsmyX8QdKUNuR32rovhxIYds9Of5S42+GR2nS7SD5Xt/Vgwcfh79WGawuef1m3QGgxjxQERR5Y+zP9+6IatJBEaXkiwwwfUC4blYidi8IanRNPHqLIAUIRsLNyOT1RsCaWm9F/XCQ0yxr6dXSGEwhBdivlOyb6Ho7Gl9aau65LMKYNh8CecXgppgMPW5JmzyV1cLELn6XrbiYwPvCo0kCfDKhn8ic7Gu1ufR7EuNLnjuIV3z8Bp7/QhU8yY/qZLs1JRBk5zpvYUZLWJyuk3H8Eny07K0bAvg/veAu7mUHCTvwO1FQG/tnBxnIuyF8GmH4wlRlX3dxKIuhKQtD9SzlqszuWaaLIvBOzkiCLeOtcmN3MBccWtYSHmk8l6C+yC79dxHcmV8UfWOsWLCxKlF+TWPPM4/KYHSesk/cdEfZBDxHczYn65xPZavO6POrKfQcWBKkIDTlQgxNAxEF+04/Tsweo7IR7O5y7Yz0SbNBqx8mhuz0T4ZhEuzMms/QUh0m5diC0dXabmYB0k0cF/6VT6Ot5crSNNCJHfmFDJIUziOQx/En9+bqBrRzGtfG4NcrLAb5BpZYop5/UcH9xPY7cwWghgu1AyGKiShkLpP3XJ7Xs87nsJhVtU8tRmXU5WZR1DyISlkNfKCOT5beJo/S3+K+tRksldm9ZcRapJ9eP/Qg1sGMnf7mk65xS10fTL1Jr70DEGG89f+kaT
 VjMpLpTB
 mBaOZ7gG0xikAVkdbVjrMS/YxMe0QuP+/n9lR+vfjKOEk4rgpo3JnuLqvIC0Aoh0LJMJBw3u0K4gSlP3Gs15+5SWZxd/zkNudRSHCvDKAYPzj/7Hoi5whzHv7ng+eqGq8u0ToNTYC6+QZEzXhcfixxAOHWVOk7hO+XfCEyVI+4avbATko3nL9wrnLoufUqNKFEh9p+Nk13LdWHOuu6xdyCjK3pBt/apYctooTMHzA2nlI579SsJE/jhmoQacrcKJWnvcWqdROAnKf86HbrWmpqY7W9V7paG/kaHy4fjxfkZRi9izzYLovE5JuAM/Kn+SkhKEI5IoOcSUs+LDNBjBVKwMndukzeKHLgbZgFBP+bwKpXpwzEWeD8sPsUE6x+cYmNTlyDSILFUDP02w26hrzy014uXvU/Oh0k9CDqiCwZw4ofwydumpxKmwNgGcZDdEBUlNHkuEqj+GfpTK/7x0xh+kKHyFwv1VJpDbzGZAdwvrfP6rSO6N2cQKHGu3W+5ahSs1id47JjLINyQhuH04F7lsRJYcX28lzIZIjj7qOJ/xc0XxWYjgKRJxNIgrc1an6PTUIofTR1cnA7yBpS6LKm1pPoPCBF/Wsz/5l3vZ/25MPh573LEwv7ztvaU8iGjesAgcZWP1pKb6kB3+0FxTIjauV0oXjvUmd4+rju3Ym7kSFVxnSrqsyTXPXNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

blkdev.h gets included in various places outside the block layer just
for struct blk_plug and related plugging functions.

Split blk_plug into a separate helper to reduce the amount of code
that needs to get rebuilt when blkdev.h changes and to slightly
reduce compile times.

In io_uring this requires pulling in a few other headers explicitly that
previously were implicitly included through blkdev.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---

Changes since v1:
 - spelling fixes

 fs/aio.c                       |  2 +-
 fs/fs-writeback.c              |  2 +-
 include/linux/blk_plug.h       | 95 ++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h         | 86 +-----------------------------
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.h            |  1 +
 io_uring/kbuf.c                |  1 +
 io_uring/rsrc.h                |  2 +
 io_uring/rw.h                  |  1 +
 kernel/exit.c                  |  1 -
 kernel/sched/core.c            |  1 -
 mm/madvise.c                   |  2 +-
 mm/page-writeback.c            |  1 -
 mm/readahead.c                 |  2 +-
 mm/swap_state.c                |  2 +-
 mm/vmscan.c                    |  2 +-
 16 files changed, 108 insertions(+), 95 deletions(-)
 create mode 100644 include/linux/blk_plug.h

diff --git a/fs/aio.c b/fs/aio.c
index f57fa21a2503..ebdb0e5b95fd 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -35,7 +35,7 @@
 #include <linux/workqueue.h>
 #include <linux/security.h>
 #include <linux/eventfd.h>
-#include <linux/blkdev.h>
+#include <linux/blk_plug.h>
 #include <linux/compat.h>
 #include <linux/migrate.h>
 #include <linux/ramfs.h>
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fdb8766d275a..d064072284f4 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -25,7 +25,7 @@
 #include <linux/pagemap.h>
 #include <linux/kthread.h>
 #include <linux/writeback.h>
-#include <linux/blkdev.h>
+#include <linux/blk_plug.h>
 #include <linux/backing-dev.h>
 #include <linux/tracepoint.h>
 #include <linux/device.h>
diff --git a/include/linux/blk_plug.h b/include/linux/blk_plug.h
new file mode 100644
index 000000000000..2ac1265662ad
--- /dev/null
+++ b/include/linux/blk_plug.h
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BLK_PLUG_H
+#define _LINUX_BLK_PLUG_H
+
+#include <linux/sched.h>
+
+struct blk_plug_cb;
+typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *cb, bool from_schedule);
+
+struct rq_list {
+	struct request *head;
+	struct request *tail;
+};
+
+#ifdef CONFIG_BLOCK
+/*
+ * blk_plug permits building a queue of related requests by holding the I/O
+ * fragments for a short period. This allows merging of sequential requests
+ * into single larger request. As the requests are moved from a per-task list to
+ * the device's request_queue in a batch, this results in improved scalability
+ * as the lock contention for request_queue lock is reduced.
+ *
+ * It is ok not to disable preemption when adding the request to the plug list
+ * or when attempting a merge. For details, please see schedule() where
+ * blk_flush_plug() is called.
+ */
+struct blk_plug {
+	struct rq_list mq_list; /* blk-mq requests */
+
+	/* if ios_left is > 1, we can batch tag/rq allocations */
+	struct rq_list cached_rqs;
+	u64 cur_ktime;
+	unsigned short nr_ios;
+
+	unsigned short rq_count;
+
+	bool multiple_queues;
+	bool has_elevator;
+
+	struct list_head cb_list; /* md requires an unplug callback */
+};
+
+void blk_start_plug(struct blk_plug *);
+void blk_start_plug_nr_ios(struct blk_plug *, unsigned short);
+void blk_finish_plug(struct blk_plug *);
+
+void __blk_flush_plug(struct blk_plug *plug, bool from_schedule);
+static inline void blk_flush_plug(struct blk_plug *plug, bool async)
+{
+	if (plug)
+		__blk_flush_plug(plug, async);
+}
+
+static __always_inline void blk_plug_invalidate_ts(void)
+{
+	if (unlikely(current->flags & PF_BLOCK_TS)) {
+		current->plug->cur_ktime = 0;
+		current->flags &= ~PF_BLOCK_TS;
+	}
+}
+
+struct blk_plug_cb {
+	struct list_head list;
+	blk_plug_cb_fn callback;
+	void *data;
+};
+
+struct blk_plug_cb *blk_check_plugged(blk_plug_cb_fn unplug, void *data,
+		int size);
+#else /* CONFIG_BLOCK */
+struct blk_plug {
+};
+
+static inline void blk_start_plug(struct blk_plug *plug)
+{
+}
+
+static inline void blk_start_plug_nr_ios(struct blk_plug *plug,
+					 unsigned short nr_ios)
+{
+}
+
+static inline void blk_finish_plug(struct blk_plug *plug)
+{
+}
+
+static inline void blk_flush_plug(struct blk_plug *plug, bool async)
+{
+}
+
+static inline void blk_plug_invalidate_ts(void)
+{
+}
+#endif /* CONFIG_BLOCK */
+#endif /* _LINUX_BLK_PLUG_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9213a5716f95..20cb8ed7d987 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/blk_types.h>
+#include <linux/blk_plug.h>
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/llist.h>
@@ -21,7 +22,6 @@
 #include <linux/rcupdate.h>
 #include <linux/percpu-refcount.h>
 #include <linux/blkzoned.h>
-#include <linux/sched.h>
 #include <linux/sbitmap.h>
 #include <linux/uuid.h>
 #include <linux/xarray.h>
@@ -1169,94 +1169,10 @@ extern void blk_put_queue(struct request_queue *);
 
 void blk_mark_disk_dead(struct gendisk *disk);
 
-struct rq_list {
-	struct request *head;
-	struct request *tail;
-};
-
 #ifdef CONFIG_BLOCK
-/*
- * blk_plug permits building a queue of related requests by holding the I/O
- * fragments for a short period. This allows merging of sequential requests
- * into single larger request. As the requests are moved from a per-task list to
- * the device's request_queue in a batch, this results in improved scalability
- * as the lock contention for request_queue lock is reduced.
- *
- * It is ok not to disable preemption when adding the request to the plug list
- * or when attempting a merge. For details, please see schedule() where
- * blk_flush_plug() is called.
- */
-struct blk_plug {
-	struct rq_list mq_list; /* blk-mq requests */
-
-	/* if ios_left is > 1, we can batch tag/rq allocations */
-	struct rq_list cached_rqs;
-	u64 cur_ktime;
-	unsigned short nr_ios;
-
-	unsigned short rq_count;
-
-	bool multiple_queues;
-	bool has_elevator;
-
-	struct list_head cb_list; /* md requires an unplug callback */
-};
-
-struct blk_plug_cb;
-typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *, bool);
-struct blk_plug_cb {
-	struct list_head list;
-	blk_plug_cb_fn callback;
-	void *data;
-};
-extern struct blk_plug_cb *blk_check_plugged(blk_plug_cb_fn unplug,
-					     void *data, int size);
-extern void blk_start_plug(struct blk_plug *);
-extern void blk_start_plug_nr_ios(struct blk_plug *, unsigned short);
-extern void blk_finish_plug(struct blk_plug *);
-
-void __blk_flush_plug(struct blk_plug *plug, bool from_schedule);
-static inline void blk_flush_plug(struct blk_plug *plug, bool async)
-{
-	if (plug)
-		__blk_flush_plug(plug, async);
-}
-
-static __always_inline void blk_plug_invalidate_ts(void)
-{
-	if (unlikely(current->flags & PF_BLOCK_TS)) {
-		current->plug->cur_ktime = 0;
-		current->flags &= ~PF_BLOCK_TS;
-	}
-}
-
 int blkdev_issue_flush(struct block_device *bdev);
 long nr_blockdev_pages(void);
 #else /* CONFIG_BLOCK */
-struct blk_plug {
-};
-
-static inline void blk_start_plug_nr_ios(struct blk_plug *plug,
-					 unsigned short nr_ios)
-{
-}
-
-static inline void blk_start_plug(struct blk_plug *plug)
-{
-}
-
-static inline void blk_finish_plug(struct blk_plug *plug)
-{
-}
-
-static inline void blk_flush_plug(struct blk_plug *plug, bool async)
-{
-}
-
-static inline void blk_plug_invalidate_ts(void)
-{
-}
-
 static inline int blkdev_issue_flush(struct block_device *bdev)
 {
 	return 0;
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a2c623a67a25..f302bb3fcf8e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -1,7 +1,7 @@
 #ifndef IO_URING_TYPES_H
 #define IO_URING_TYPES_H
 
-#include <linux/blkdev.h>
+#include <linux/blk_plug.h>
 #include <linux/hashtable.h>
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cb736b815422..9771d4557ed3 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -3,6 +3,7 @@
 #define IOU_CORE_H
 
 #include <linux/errno.h>
+#include <linux/file.h>
 #include <linux/lockdep.h>
 #include <linux/resume_user_mode.h>
 #include <linux/poll.h>
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 1cf5be62bb65..7c309173dd19 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
+#include <linux/uio.h>
 #include <linux/vmalloc.h>
 #include <linux/io_uring.h>
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 98ae8ef51009..eacfdb70f203 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -2,8 +2,10 @@
 #ifndef IOU_RSRC_H
 #define IOU_RSRC_H
 
+#include <linux/bvec.h>
 #include <linux/io_uring_types.h>
 #include <linux/lockdep.h>
+#include <linux/uio.h>
 
 #define IO_VEC_CACHE_SOFT_CAP		256
 
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 9bd7fbf70ea9..1179506f929f 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -2,6 +2,7 @@
 
 #include <linux/io_uring_types.h>
 #include <linux/pagemap.h>
+#include <linux/uio.h>
 
 struct io_meta_state {
 	u32			seed;
diff --git a/kernel/exit.c b/kernel/exit.c
index 1056422bc101..2140d0515f9e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -48,7 +48,6 @@
 #include <linux/audit.h> /* for audit_free() */
 #include <linux/resource.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/blkdev.h>
 #include <linux/task_work.h>
 #include <linux/fs_struct.h>
 #include <linux/init_task.h>
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 96226707c2f6..616774777dea 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -40,7 +40,6 @@
 #include <linux/sched/rseq_api.h>
 #include <linux/sched/rt.h>
 
-#include <linux/blkdev.h>
 #include <linux/context_tracking.h>
 #include <linux/cpuset.h>
 #include <linux/delayacct.h>
diff --git a/mm/madvise.c b/mm/madvise.c
index cd9bb077072c..f6b7ef0f8b1b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -25,7 +25,7 @@
 #include <linux/ksm.h>
 #include <linux/fs.h>
 #include <linux/file.h>
-#include <linux/blkdev.h>
+#include <linux/blk_plug.h>
 #include <linux/backing-dev.h>
 #include <linux/pagewalk.h>
 #include <linux/swap.h>
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e98748112d1e..d1fd6ba58ae5 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/blkdev.h>
 #include <linux/mpage.h>
 #include <linux/rmap.h>
 #include <linux/percpu.h>
diff --git a/mm/readahead.c b/mm/readahead.c
index 558c92957518..6e5563290287 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -113,7 +113,7 @@
  * ->read_folio() which may be less efficient.
  */
 
-#include <linux/blkdev.h>
+#include <linux/blk_plug.h>
 #include <linux/kernel.h>
 #include <linux/dax.h>
 #include <linux/gfp.h>
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9c3a5cf99778..727a17ee7821 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -17,7 +17,7 @@
 #include <linux/pagemap.h>
 #include <linux/folio_batch.h>
 #include <linux/backing-dev.h>
-#include <linux/blkdev.h>
+#include <linux/blk_plug.h>
 #include <linux/migrate.h>
 #include <linux/vmalloc.h>
 #include <linux/huge_mm.h>
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..b957664abb26 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -25,7 +25,7 @@
 #include <linux/vmstat.h>
 #include <linux/file.h>
 #include <linux/writeback.h>
-#include <linux/blkdev.h>
+#include <linux/blk_plug.h>
 #include <linux/buffer_head.h>	/* for buffer_heads_over_limit */
 #include <linux/mm_inline.h>
 #include <linux/backing-dev.h>
-- 
2.53.0


