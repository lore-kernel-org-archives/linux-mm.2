Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CFADC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 04:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53E9E6B009F; Mon,  6 Jul 2026 00:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C33B6B009E; Mon,  6 Jul 2026 00:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BB06B00A0; Mon,  6 Jul 2026 00:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 051086B009F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:11:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 728ACA028F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:11:35 +0000 (UTC)
X-FDA: 84957027750.08.B0C1FBC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 50640140003;
	Mon,  6 Jul 2026 04:11:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ArKOzEqt;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf23.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783311093;
	b=0pith4wt0qc1vLgWL8zmxfcWIQjrX6MojF4NuYASJzf89iSCQi6HChR+OETx+CHfmyb4qE
	96x8sdx9c+vrOrF1ODJBHEYUN3A1ZtEOnwFo3Y7QmBNjs0VXr38VsNhBM7VHI4ppAd7mgK
	MmKBSTOrLho9RWaIFKvlhx8Aw5wMd/k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ArKOzEqt;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf23.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783311093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qgSk7nCZFkI9gf+sjMVY+BqFP42Rck99sMffUrmwwfg=;
	b=G1RDd4HLIqglW7D2TXkYD3a15TXO2Jv47Ka40DuS4eXRiYQTrRHBiXAq9eAas+G2bggxZr
	sKSBC0HWbVNDfXLbsvY/EGdpKT+cYpvZoHrnlSUlDAxnnKzNtqusNt2ymbnz6mz9lIBHoi
	KGj7esjGcplxM3saS+emsexQGx35vnA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=qgSk7nCZFkI9gf+sjMVY+BqFP42Rck99sMffUrmwwfg=; b=ArKOzEqtp6QZoSPinq7HOSwi5m
	w4LqP2g0XqjGd9BI9gPUJl8+zoEmIaecaA5ejxvaXM60J4JumdgUwo++7cabDl4jUYwSzj3nG5JsI
	n3GF5DvNL18gKpHRfpn4sgoRGxWsV07kzrOFyZBjw9+FZ7ECrJCUcOd7OrV4l1cYk9zIsMHjhsEAt
	lXjoVem7E6PvMc96WjCaNby+tzbjab9gErQxkwn+9hSk7mk4eW5AhteQmMLe6EmJJ+S66QdE6f8+B
	81wSemkMPL2l1qGf/FVTo/MWeuRjPIoU8EbVsSq64g2b3Aio1uCaLu70kHeZlmI4UnzULgeh0oRxm
	w/B0VRGg==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgag6-0000000BUGu-0PkE;
	Mon, 06 Jul 2026 04:11:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] block: split out a new blk_plug.h helper
Date: Mon,  6 Jul 2026 06:11:25 +0200
Message-ID: <20260706041125.642097-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 50640140003
X-Rspam-User: 
X-Stat-Signature: b6349dn7hy4rfe84m9uhaqahs871csd6
X-Rspamd-Server: rspam03
X-HE-Tag: 1783311092-247795
X-HE-Meta: U2FsdGVkX1/jio2CYl3MpddOnprZhUTKyjP8yk6NHx8XEOAR/2bNuJvXPTese+Td6bGsj2tkX7nv578Qe1eW6KEnsKoakMUHgqUBy6n3/7P7bttzPTC9XXEhrRMcglXCBKy5U6XOv5y+UryxtqTw9n/EIYErPz1aXrf4xQEW/zzoPaBk12JOF/3rf+SvSswi/K/YZFp8ivPr7ejKQdJUFnB60mqlYdPepzB8LaxMwyB8ibQDl8BbSCZNNax07Njr7aQU8mFxZD13a4vl0HwqXJEORRVPaY9oGtbbydz6fmBTSp7Vba+qHnejQpXlNnCGMJJuRUMX61wDfYtX1ubJRoOPRHdfgRFOHlktk22Dnp30ikVQ97PlEQKGsE/FhQflIsRJCgAN2VYjYbUuCls749hrQRQy3Os0M0+NuOjRFgoVVRW6I50aORoFXY4ET/hyu+oBMqT/k8OKwsW8Tp+Um967l05idktr1MlztrGsUIl6Ap8zVo0KvBlZW9HyoDjXvZtfrwJXEe4ofwT6LgYf/meHNTVjIjjMIubKfSu/PBhTvcXILTHkXzpUb+0sNO5E/X6K87U4Zqu7zrRjywdf54829s1TNRLwum3JykoAt87dRKQUVTh/0wTQgho/GQm+5f33AajLcaDKEWsVmNUCWswMa+irwdZdJVVLzwDyP2U4jNF0Vny9KQzWtH0MF9GzdqIcVhvpY2uIFzK7WK+rXXCdmgRQ+vpwuCBCmIdV+2QQFSFAax8wf9nbfgJvECU1Lra2c8w4uwMu5izV47cVX0QN6ebu/DbTZ6lLPZltOHtpjubtLA++iT/q/N8Fkn+XK4MdP0u2qHASTksunRis/R8IVCy/OrSvWcYEi/Gec2xfwBTA8wMnp+r0A434ezE3Pk7D4Oxrhp5rfTwdltct+SP66s1J3+fIE+Wbzpi7HWir3wowF//1YkrStKIEpDb1Ou74dTDycDIRB+ohJKi
 Gb0HtIlO
 Kcwmd0pjx4gfTfjJcb5RX5KKhFJ5MLqzktpfIrQUojYCCenb5AsMuqUrnRlQiW3pMOqLCdeKyxy0Vrk2LpZjnKuWnZ+8Ppa0cgGN+8cbbsnPD26us1scobDL96oHddDRNjLfMldMqkCDwE7+hM/EIrQERFZz/yAN9GmAkYYvDlG6Yd0zRlW4QJXkP6s32As2QwpsbAxYTR5cJ9LjxizAVzir4ZLTnOeJr21t1Kls1OISb3hbBoEYv0cFqW1hIYCvao9WolKJzgobqmhI3xviIMjeeojhGlqeTe1qDBR6ZIH4cec4cWrK1e7tQL2pfj6V3+95KotyezhkybnNGHEKJf7+7O6+8pxGQvOq175/BMhI9d9pua+ad0DppW0u5WeFY+qKi3oo7IbfQAz99lrOQ0W6daWomLYXA+CJuhdyE8HaKlsFC4R/OLsJgpAapW5g84NmMWwLCjZ5MiXf5qCstQIp567YIe1s/3xcydq5dgqZ+26RoZ6jx8DxTWlKFrPfHnxGK6/qCoV2xknooQVWRnSUhqelDsLsw/0tgXmu80CeuE7QlseaIXZ4rkGf3wNiCrZOAvmz+9bxuDcnqs/dtBvf2brAqqHn4umvrEkXeXxMhEiY=
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
---
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
index 3cd29477fff2..e58bff9037f1 100644
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


