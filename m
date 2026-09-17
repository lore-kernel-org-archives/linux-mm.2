Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D91F7C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 07:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC29C6B009E; Thu, 17 Sep 2026 03:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C744E6B009F; Thu, 17 Sep 2026 03:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14A06B00A0; Thu, 17 Sep 2026 03:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 884A06B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:01:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 621C8C0223
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:01:28 +0000 (UTC)
X-FDA: 85222358256.01.31D8151
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id ACEED14000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:01:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="cQPD3kg/";
	spf=pass (imf23.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789628486;
	b=ZaluGi1bpGOx7n21kGdcLAycZIbX0HIUrMWXp+AdlhZNwj3S8SHHZcDXBPoayIM16Ackdu
	yhevLLY9P0MLC4Xigq93NHyoN4d1Qhsrh1fwfZni4ZOBUROejsf051gzliT0HtTvSTWrZO
	FdEn6VCLzLf7LVPMmGuMwH5XjfOQf2U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="cQPD3kg/";
	spf=pass (imf23.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789628486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9DYHgRIJqpSed6YVO3OWCRp9w7bsaWXZECFIVVOSjzY=;
	b=1mSd7BgWVVUjK3AVKdsu+QcEjDREAmxJaE4LRS295g/jU2BVb8IB6MRBaWbAVdCDWNdjyA
	HIxI7oRtLz8xzqv3PSnIr4w744y0lEOU1tLYe90i3aPg4QPLV9pNjakS5su3t4O+AYtk+G
	/QoXNpU25PTgRmmoJZGZQ+vbad8co2U=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so416823a91.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789628483; x=1790233283; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9DYHgRIJqpSed6YVO3OWCRp9w7bsaWXZECFIVVOSjzY=;
        b=cQPD3kg/cFaRQWIis9CarPdSaI4annr24fNJNj35dQGDj8VdbGWFAA9A9gV7kvKIP6
         vuZYdbxRNVNz8OKdTedH7J+I9cydkI4pfXTQJM+CzEQmJUoxUbuQlTjqEmc2mfTMouO1
         drilM0xoqkMU3tnSwpCYzTJ/8bvp5GCswW6B3zjrLhN74DlzodShXLsugNkUPhM45wY/
         HkuXYqljnRhlEaHPjTK9tbID4vMKLtXiVYnphV9ix+QyOXBFtMrOexQbRzW/1W+b8Kwy
         JbsiNz9TAbDclscW7j2SEt1Hx+I+UM5qlcF3KPxudUEXQliroalgb9OJzM17CMf049g2
         nbxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789628483; x=1790233283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9DYHgRIJqpSed6YVO3OWCRp9w7bsaWXZECFIVVOSjzY=;
        b=pJNY0iXiBw2Y9cU83FcJH7f5wQLzyzT9vdg1aMQ/7XLLSm52aqzz8hMsmtwmboY5uY
         IB1oowBIgHJrIw83SX9PlAkCkqSnunf3q/aCd/uN6GnZo9ink3H7+poAYE5EOkOsNeUM
         UWYyk7Lm8Ct40yKzm5ewi0MFsD9N/Ws1gPoN0BXuOlzdzOmBwPAhOGyY2EpJ60yl7639
         TjBXJhkkdgkk0bWkHgn0oDd6naM4neFW8dY79F+vYyJcTiZtGmpbwYgW9TS7x1ZQldYM
         +aRgYSmB5Wb6HXuTOY5i1TyYv4ieOUtlYSDaOD/n670SYrZsu8dbKqZXtX9zCa8iWTfM
         phAw==
X-Forwarded-Encrypted: i=1; AKwUvBzvfGdnT6zVGyKHhojXpwJlxSRpbNP0mPiqIKRnN/XpqgEYs25GOo41eKg6/X3M+JVT7uieQ8jO+Q==@kvack.org
X-Gm-Message-State: AFuF++kTrBafitUyEjaKyjh9lop/ZmkNs0wfK+U6nZlPUeg7MlMlbmG6
	zajJyVbOuXaLS9jaGVk7wL5bb0I4R46mfXLuTbTO69IjCCisR4cgWEHkoBwYP9kNAoE=
X-Gm-Gg: AYBFou0LA5BcduHiDzllYiYEvzK0nO6d2nI2+jPqYIIjtU6L0zWgXT6h/+00z6mtIH7
	Jdy0AK6eVPhRcMxeLX60QzYKrHtcGY1PYi7vjHFe8OQ9+q81y+LGwgWoOlVqLkciiSM5jyIO0Gk
	ANopZVGEwL+GFQrBUmffC4szdpnrskwXyy4fkIOYBG1/5I3cA75P7e+8kRrqGELfYjuRfpCNstW
	lRh7vbybOHyw8mbnABzBBtsGk+gBalNzlq9QEafG+wbYUrfBg8/LxCnwnN2iv9LsPA39c4GBRQF
	Pltz0SOhsz2TnzU1PQsGIeoKTlogYeBEr5kEXuHKWGiFf10oP1mgY6/IcztJHmlT/hWX1n+ycU7
	EED1qxAunPh1sDBpYdNVLLOBnZmPxo5zuAXcMDMrFWsWR/4czGVy30Ys23rg0/bR6rYNbU5+I+h
	87qdyVGULz2stNA4Idg2uP7jLGSLKbpbCbYhqcMt+XIOrCxVpVGZ0dXRck4zIzca1C/JPOSPtek
	g==
X-Received: by 2002:a17:90a:10c1:b0:39e:1ec9:dc8d with SMTP id 98e67ed59e1d1-39e1ec9e479mr8576309a91.24.1789628482980;
        Thu, 17 Sep 2026 00:01:22 -0700 (PDT)
Received: from localhost ([106.38.226.67])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e362ea35asm3420728a91.16.2026.09.17.00.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 00:01:22 -0700 (PDT)
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
Subject: [PATCH v6 2/3] memcg,writeback: flush foreign bdev mappings separately from owner wbs
Date: Thu, 17 Sep 2026 15:01:18 +0800
Message-Id: <20260917070119.2648123-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260917065759.2643940-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ACEED14000A
X-Rspam-User: 
X-Stat-Signature: 5nhdbndnky43p6mehnbiaidkc4je6ani
X-HE-Tag: 1789628484-306534
X-HE-Meta: U2FsdGVkX18iPuDCYORxzAsXBXVm7ftHGzIYkBj6rC+p1IIdZsggjR68lCz4aLuIVB6eP95Fc+9t7hGrZyNgNkMWBDsGr68y3yReFMd5YZHwGuaikocIAFWMANd6e2aJkGRYHG+YNh4WJSLwQm1URluWeRyV4bnLN640Lag7aD4KdngmdnkhOrp/dIiMWV4LBJPiNKRn6ZzFS2KwM9OJW4nK5N15qtESwl1De1U563ibvnBO02fpWfU6jkyNzAE+bNTPnfmWumA0UVQUjhM2f7t1ugtkUMz4sGP2gwA98cHbjWeiYQ8Qja4Sa+sG6EYIJxVy6vKZAKoL7XkC8HcVzcMG9HjprDYGFaty4hIgboohdNDxPlpABzEUJv1bhNEhjAGRRe9TV3bDb3c3Oly8y5ApFY7TnVSHLVONUumxU9WOMXVub2Auu9PyBtdaNlO6cr2J5zOsAgczF7YqIX9prQyxgfAg391EhkFjoS8Mg0Zg6IbaRZ3puANib8UULyU2qKhpkubAuThbS6a54M2K2fvRoTAmQHrdJs4nfISX0CuT00gn3LPV7JkesbncAuOpJCichME/Ntx6M9HAOfiCyRGhLV8lGt5Pn3ZTtJN8WBdhw2XDA6ABnpExSUlsGycUqNrYJKgpE2vRzfbxG9AQIrBGqCz71JrssIFXEvGgqhAvA5LBRe+SNfWJnUW/BzHmrKJ+LCOqZx5JLoUZAWhJBEVssvDi/PWOcdFREHnt7M8iHoJXupmGnDZ/bO9no6RC+SQ8fmY9ZjSIS2nEI9/oaxIeTh3MiSLF8PD/HuTn3oIVBSgKVZhUG/2uoRQE8Xd+283aKTCxB4K9vtkxPBJnY6Ewb2qy6k/Bqi/m+LxTImVh40xBGnWo3VOL49QjLZ7zmj1fLcTp5tJvqFi7OQ0cf8o16FmZEbCNx/BNMQEJ/okPpt7Q9aLlUbpaeTL0Kjn6XV1PdkK+xqplULf7gkL
 r30dQLnP
 tX0saVWF8kTFK75FoIyqe/qpwZNz1MzvqsijfzvTew1zlrOeFUNDYaSPA1xCTVcHVYew05yWIVAB2eQ4yfj66Xb2XrZlir7QHwPWE1rwN6v9jc2ugKZTGqxA2XFh63PxwfeoRKg2u21bnr2L6JuyWoPIzR0ucO2meqqdtKp5a4Mp6bZWoB8WY94jUT5JpMun0L2jd4iAINYA7T2N4FlUUMVDfPw+PpF181LLUlYb4SSVpm5rSCex2F8u3ciVaEtCiUuIEidTo02CGIC++I9mX7cCn4x/PcX3Xmxe7d4MNQVC5/UNbfpKoLlqt69DY2OVJ3FS68xTFN2WuvBl24mGuM/zxA6U5MHmvCDtXxF6BPzNzuWI=
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
 include/linux/memcontrol.h |  15 +++++
 mm/memcontrol.c            | 117 ++++++++++++++++++++++++++++++++++---
 2 files changed, 124 insertions(+), 8 deletions(-)

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
index 1271d390b617..55bd5d100caa 100644
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
@@ -3845,6 +3847,52 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
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
+	int slot = -1;
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
+	/*
+	 * Tracking is best effort, so losing hints when all slots are occupied
+	 * is expected.
+	 */
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		ctx = &memcg->bdev_frn[i];
+		if (ctx->inflight)
+			continue;
+		if (slot < 0)
+			slot = i;
+		if (!ctx->dev) {
+			slot = i;
+			break;
+		}
+	}
+	if (slot >= 0)
+		memcg->bdev_frn[slot].dev = dev;
+out:
+	spin_unlock_irqrestore(&memcg->frn_lock, flags);
+}
+
 /*
  * Foreign dirty flushing
  *
@@ -3875,17 +3923,17 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
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
@@ -3898,9 +3946,17 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
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
@@ -3941,6 +3997,25 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
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
@@ -3949,6 +4024,18 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
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
 
@@ -4202,9 +4289,15 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
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
@@ -4386,8 +4479,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
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
@@ -5703,6 +5798,12 @@ int __init mem_cgroup_init(void)
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


