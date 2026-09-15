Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FDB9C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5FD6B009E; Tue, 15 Sep 2026 04:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6099A6B009F; Tue, 15 Sep 2026 04:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA086B00A0; Tue, 15 Sep 2026 04:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20D456B009E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:34:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A8001C21D1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:34:23 +0000 (UTC)
X-FDA: 85215334806.13.13E9A97
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf25.hostedemail.com (Postfix) with ESMTP id E1ACCA000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:34:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S23T0V5M;
	spf=pass (imf25.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789461261;
	b=64E41hN8SVvUyGdn208PjW4dD0App+FBRz6qdrJd/7tMD8JSPqN3sTjdrFGp4JJ76i3qXp
	BDRxVvpj01eeZvcTbAhQJtnqseYvS+z9nGYFqdXuu0QEJjTCDaa50xSAWpKCMFpREteMhQ
	pRCcxjJSyW3hZ6MBOq1dbHkA5cgrmJU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S23T0V5M;
	spf=pass (imf25.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789461261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18B+mnf3gIsI3ZPyV0XbtWA76VI7+e4SAQ+2YXTfHcE=;
	b=8SnMIHx0kBM25yRN3qi+jHzfdjACpqdUNwECXaBhhsrh2TXlYYjptNlrg48fxg0u0x3f69
	O84G5JxJX91K8Eaou6pjNBM7KjrAKsol4rI8agIO6P3R0sz6FY9E1I+np7IHymR7qQPEKe
	C0VGZbx7Z/CowjuOVjKxBA16xD8RHGE=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b35611so1680566b3a.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789461260; x=1790066060; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=18B+mnf3gIsI3ZPyV0XbtWA76VI7+e4SAQ+2YXTfHcE=;
        b=S23T0V5M3Zrj+8Qd5OYctR8aeTW3dEwQ+KFJJ5dzp+cqAcR0Ir2oJbMUhc9DZ4OqEh
         Dh3chB2l7FD/ZW3jN7ySa3U7qP5STUCfN/ExSQxeTrfNg+gokOvTuZVLW7W9SPHYReok
         06ELwiSSZd5btspayJLr9OcLDM6jGDa4IqXE1xj4b9zCWQpbCUPeds2jY9lWbWxEiuoJ
         SeM+lh/uaCDqpfdOWNy953uPYn6jE+DKgqSlSvw9pvZjImZcZYHWEykDZlDCUGJ4y04z
         VibiycAdOEQRUpIsR1qsdpfjz/PbBPoBqeNsqDx4ZgJnFtHPEzlMz/RnCzamirAz/hAS
         r5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461260; x=1790066060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=18B+mnf3gIsI3ZPyV0XbtWA76VI7+e4SAQ+2YXTfHcE=;
        b=UZQYwBIe38x6o8C55eQ7u1tUYhGNJmH4ZiZaOKrG88v51RqdVwuXJ6tMU2eWl5IZ3z
         Igo1FDjhuyeQHdYN90V+2Yf/2skRPPGDRQQU1bcG5E+CNXrJtAfMm3MDgrrSC+5Jb+dL
         dRTcDJaZIgHmEm6q0fy29fAtAKwkY+B4mRq6zKo6+1NxBioQ5VuendsAlMTnguRUaWdo
         HL0HScpr4uauDzLGKw8QSJ3dT9z4HiHmxGQ8EtX3OJ5jAj1RR2/RK+yOIcDbDcQTa65v
         l6rtPNEDGUg7ck860WKtct56grRkE3+HbAwAz+gPdse3GCrbHVkNYmP6dEbJCwIih7SP
         OtXg==
X-Forwarded-Encrypted: i=1; AKwUvBy/oz329CeLEeGDU4fkG7XXiG5rl7aicA2r7vA1+S/MTYDpiXTxiqXzI0lyZBxu7QLGkZf9CHBJOQ==@kvack.org
X-Gm-Message-State: AFuF++nsuYb90+6sUX4I/HeujlLoHmeiN6bgIHkJ5GwUGFBPpPc9H+Ng
	VXQHRKi2VLZNmzvkXGwt8vAoPeJ1ZlfPMJhmdgzKnqfjXRfrkBy7TY6oy8wAC5Mf84A=
X-Gm-Gg: AYBFou2iJrsEzGgGp8TEqv7H7iTMqfODxMc4LSqyEaxvMTwJ8rMAk50bBC3p/0zA1ol
	+7agy4nHHBhUKgx2FlP4f/q2ybZ1iY51jaOCHkl7U1jZQEJGmff+J8O1VowbBeL05t5ehVH1dsn
	xHzg0EqXAbTsjdB/io0hs/POsvRoSlI1erQ6R+vyY0G0DRsG+EoSBWDGRVomgACavyUyV5RLjhH
	eIlqQqGmhWsUaLJI1qT1diTYUkwbDdjWJy1TqQONjIQMfNM1Acvg6GproVa/T0ZrePA8irbuKWo
	0CJoOwsUX7Fv5UGcYgomJw2RAxheN3DqDDWxy8SXFPXS8aM+G6OJUWUC38zo7WJ9XGsRHk+P/2F
	/YPmZDi54eY+PEKftbq8SG9g1e/k5WS7G1pCpB1X+duM3lnVl+hNX+u9g9hhWQHZR7wAM1WWxuV
	mUAnej5kDsmEJ9iQyHmVCJjYm11Z0JPRx8B8hMKNmoGhE1cqjCeiqbRkStS2MF1My2cvbSAl6xr
	GA=
X-Received: by 2002:a05:6a00:1950:b0:82f:38df:681c with SMTP id d2e1a72fcca58-86f82f524c7mr12906512b3a.6.1789461258753;
        Tue, 15 Sep 2026 01:34:18 -0700 (PDT)
Received: from localhost ([106.38.226.183])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29dc09d4sm5702332b3a.47.2026.09.15.01.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:34:18 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH v5 2/3] memcg,writeback: flush foreign bdev mappings separately from owner wbs
Date: Tue, 15 Sep 2026 16:34:05 +0800
Message-Id: <20260915083406.3471036-3-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915083406.3471036-1-sunjunchao@bytedance.com>
References: <20260915083406.3471036-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E1ACCA000A
X-Rspam-User: 
X-Stat-Signature: 7u9c1z3fsxc5qzywkt5tcm1eqrrabgom
X-HE-Tag: 1789461260-495931
X-HE-Meta: U2FsdGVkX1+0i/EIMlgIHHZ2f3Yw1Ga1S+Qla8aT412gewPYtjcJb7CHvwApI/LIO5vkDcoPJv3C/teCN3/vGBaNlQIYSJ7y11AmrRGY2nMw/0Fvb+HHo6FAeRTDCQxa6ysPYOnnzP1YFXNdWG8RIss4GmEVEoVqPbtESThXSfa5p8k0k458ZbMaxWlqXgTcDi9/h7RwF0srBqmac0h/7N03VHAeKYgY7g9GVaVErkHotbPpbacYVdI7xVYLBBQSfEqilUKMq5kYd/015jKLyF4LYGttqxLrXSKHl4Se1JoRzcKCHT2t9EBd215yJQCmZR7wFjOVmvadkLA3JMLyxGNeMbYXz57xhDJEh1qFwl+4048oXqhF5PJU+s381YSudZ2JDLQBt839BTNnlbab/J4Okzbng8IXmsMZJiIKVnKmdU4wzulVtP+wTqvxzHxWWNNlMkbPNjq7OgvmXa1A9pbkp8RfJoEQCARRqbKzeVKJOayYM0YvkcIF1+0R3bxLk9zLrhXr69AE/mBZ/ap8A5rt/aqcT4QZ/AMxR9D8hlk2Kr1wdh5Vwbmq7KImiJfpz9HEZJsSUai2RI+zS5CMdpy7obrI6WdITSZTexA5FuOSEk760E8ihIEcBfDLUheT6IfNEE+8FU+ircaaWVBhhDFQ1socbNbTKMjnJ3XtRwZn1pKHs4wXj6EZpHjaWvpL+iiIslhQrhNrkCqDOYZfcnM/a6D/R4XuraKXhwDgkyh1MssdpXXw4cJSGmkP6tT1St6TTXRZ3Dd5z+9xu9KCVS0iaQQh6u2MaZPYrcIFxw8/xU0rgL+M1MJMQwjxkRhRhreddphLjyybcc6O5/IcW4B0wxW8cy86axEGecJpp4ujR/+kJkCUDTE1alJwIA9wP+nxB7jJLpQgfZ0o7MYzDPfACd4ap9vIwa30ffdqPNzxCc+EnL3hkG4shxjibG9YmVHMZaoAIdR+rXLGBMV
 7RcLmXFt
 5ryTucf8lKs1mlNoNafrzAe4vrh7syJImt5MtcAhQ0iFf9n9d4bM8zaF6Xcxqr14EZlAu9/CM0ttlspTnympQCC0hzDJieR5B2DRyBCauucXR3Ftu5WTIhhR8crTTh87kYze+AlZGgOBzxF0Lh3EujRldk9Qp/ONOclxsH5x4ghsDre12QPO52JkDP8b9WvFQId9NdPyKrflcRHkg04uoUsV7de7/ipX5R5oqJ9TJaBTLUdcdhMTmydBpY7yyOcPE2F2+xdN42R3K9mWLoVw1GdoOk+6NVPCssEkJYDSFvDbDkwskRGflzfx+pw2SsfJaPRhADdZ/IQAhGRi/9dPiJDyL0yFOx7f5Ii8Evz/oMmptc19SIv+4zvCsFumE4n0J4pC9chQf6eqrrGz5zZMIfoRHpA4szLNiRzR3+I+5AGjLao5YbFAYOaYxFAeKM6nIdN9V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bdev inodes are routinely shared by multiple memcgs. Recording their
owner wb as foreign can flush unrelated file data when a source memcg
enters dirty throttling.

Record bdev device numbers separately and queue best-effort work on
memcg_bdev_frn_flusher to write only their mappings. Keep the existing
foreign-wb mechanism for non-bdev inodes.

Bdev foreign flushes can be triggered frequently. Use a dedicated
workqueue to avoid interfering with tasks on existing workqueues. If
allocation fails, retain the existing foreign-wb path.

Use fixed per-memcg slots, with a shared lock protecting device records
and in-flight state. Tracking is best effort: record only dev_t without
holding device or inode references. Skip closed devices or devices whose
open_mutex is busy. Device removal and device-number reuse may race with
lookup.

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 include/linux/memcontrol.h |  15 ++++++
 mm/memcontrol.c            | 106 ++++++++++++++++++++++++++++++++++---
 2 files changed, 113 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..3cd90913773b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -176,6 +176,18 @@ struct memcg_cgwb_frn {
 	struct wb_completion done;	/* tracks in-flight foreign writebacks */
 };
 
+/*
+ * frn_lock protects dev and inflight.
+ * No extra memcg reference is taken: this work is embedded in the memcg,
+ * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
+ */
+struct bdev_frn_flush_ctx {
+	struct work_struct work;
+	dev_t dev;
+	bool inflight;
+	struct mem_cgroup *memcg;
+};
+
 /*
  * Bucket for arbitrarily byte-sized objects charged to a memory
  * cgroup. The bucket can be reparented in one piece when the cgroup
@@ -279,6 +291,9 @@ struct mem_cgroup {
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
+	struct bdev_frn_flush_ctx bdev_frn[MEMCG_CGWB_FRN_CNT];
+	/* Nests inside mapping->i_pages in the dirty tracking path. */
+	spinlock_t frn_lock;
 #endif
 
 #ifdef CONFIG_LRU_GEN_WALKS_MMU
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..61ebe4ab744f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -39,6 +39,7 @@
 #include <linux/smp.h>
 #include <linux/page-flags.h>
 #include <linux/backing-dev.h>
+#include <linux/blkdev.h>
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/limits.h>
@@ -104,6 +105,7 @@ static struct kmem_cache *memcg_pn_cachep;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 static DECLARE_WAIT_QUEUE_HEAD(memcg_cgwb_frn_waitq);
+static struct workqueue_struct *memcg_bdev_frn_wq __ro_after_init;
 #endif
 
 static inline bool task_is_dying(void)
@@ -3845,6 +3847,41 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	}
 }
 
+/*
+ * Bdev inodes are commonly shared by many memcgs. Flushing their owner wb
+ * can write unrelated file data, so record device numbers separately and
+ * flush only the bdev mappings. Tracking is best effort: record only dev_t
+ * without holding device or inode references, so it may race with device
+ * removal and re-addition.
+ */
+static void mem_cgroup_track_foreign_bdev(struct mem_cgroup *memcg, dev_t dev)
+{
+	struct bdev_frn_flush_ctx *ctx;
+	unsigned long flags;
+	int i;
+
+	/*
+	 * __folio_mark_dirty() takes mapping->i_pages with xa_lock_irqsave()
+	 * before reaching this helper. Use irqsave here as well so frn_lock's
+	 * IRQ protection does not depend on that outer locking.
+	 */
+	spin_lock_irqsave(&memcg->frn_lock, flags);
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		if (memcg->bdev_frn[i].dev == dev)
+			goto out;
+	}
+
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		ctx = &memcg->bdev_frn[i];
+		if (ctx->inflight)
+			continue;
+		ctx->dev = dev;
+		break;
+	}
+out:
+	spin_unlock_irqrestore(&memcg->frn_lock, flags);
+}
+
 /*
  * Foreign dirty flushing
  *
@@ -3875,17 +3912,17 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
  * most recent foreign dirtying events and initiating remote flushes on
  * them when local writeback isn't enough to keep the memory clean enough.
  *
- * The following two functions implement such mechanism.  When a foreign
- * page - a page whose memcg and writeback ownerships don't match - is
- * dirtied, mem_cgroup_track_foreign_dirty() records the inode owning
- * bdi_writeback on the page owning memcg.  When balance_dirty_pages()
- * decides that the memcg needs to sleep due to high dirty ratio, it calls
+ * For non-bdev inodes, when a foreign page - a page whose memcg and
+ * writeback ownerships don't match - is dirtied,
+ * mem_cgroup_track_foreign_dirty() records the inode owning bdi_writeback
+ * on the page owning memcg. When balance_dirty_pages() decides that the
+ * memcg needs to sleep due to high dirty ratio, it calls
  * mem_cgroup_flush_foreign() which queues writeback on the recorded
  * foreign bdi_writebacks which haven't expired.  Both the numbers of
  * recorded bdi_writebacks and concurrent in-flight foreign writebacks are
  * limited to MEMCG_CGWB_FRN_CNT.
  *
- * The mechanism only remembers IDs and doesn't hold any object references.
+ * These wb records only remember IDs and don't hold any object references.
  * As being wrong occasionally doesn't matter, updates and accesses to the
  * records are lockless and racy.
  */
@@ -3898,9 +3935,17 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *bdev_inode = mapping ? mapping->host : NULL;
 
 	trace_track_foreign_dirty(folio, wb);
 
+	if (memcg_bdev_frn_wq && bdev_inode &&
+	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
+		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
+		return;
+	}
+
 	/*
 	 * Pick the slot to use.  If there is already a slot for @wb, keep
 	 * using it.  If not replace the oldest one which isn't being
@@ -3941,6 +3986,25 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	}
 }
 
+static void bdev_frn_flush_work(struct work_struct *work)
+{
+	struct bdev_frn_flush_ctx *ctx =
+		container_of(work, struct bdev_frn_flush_ctx, work);
+	unsigned long flags;
+
+	bdev_flush_by_dev(ctx->dev);
+
+	/*
+	 * The dirty tracking path takes frn_lock while holding mapping->i_pages.
+	 * Disable local IRQs here to avoid deadlocks with I/O completion
+	 * handlers that also take mapping->i_pages.
+	 */
+	spin_lock_irqsave(&ctx->memcg->frn_lock, flags);
+	ctx->inflight = false;
+	ctx->dev = 0;
+	spin_unlock_irqrestore(&ctx->memcg->frn_lock, flags);
+}
+
 /* issue foreign writeback flushes for recorded foreign dirtying events */
 void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
@@ -3949,6 +4013,18 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 	u64 now = jiffies_64;
 	int i;
 
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct bdev_frn_flush_ctx *ctx = &memcg->bdev_frn[i];
+		unsigned long flags;
+
+		spin_lock_irqsave(&memcg->frn_lock, flags);
+		if (!ctx->inflight && ctx->dev) {
+			ctx->inflight = true;
+			queue_work(memcg_bdev_frn_wq, &ctx->work);
+		}
+		spin_unlock_irqrestore(&memcg->frn_lock, flags);
+	}
+
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
 		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
 
@@ -4202,9 +4278,15 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct bdev_frn_flush_ctx *ctx = &memcg->bdev_frn[i];
+
 		memcg->cgwb_frn[i].done =
 			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
+		INIT_WORK(&ctx->work, bdev_frn_flush_work);
+		ctx->memcg = memcg;
+	}
+	spin_lock_init(&memcg->frn_lock);
 #endif
 	lru_gen_init_memcg(memcg);
 	return memcg;
@@ -4386,8 +4468,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	int __maybe_unused i;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
 		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
+		flush_work(&memcg->bdev_frn[i].work);
+	}
 #endif
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
 		static_branch_dec(&memcg_sockets_enabled_key);
@@ -5703,6 +5787,12 @@ int __init mem_cgroup_init(void)
 	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
 	WARN_ON(!memcg_wq);
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
+					    WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	WARN_ON(!memcg_bdev_frn_wq);
+#endif
+
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_memcg_stock);
-- 
2.39.5


