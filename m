Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CC43C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2D46B00A7; Tue, 22 Sep 2026 08:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC246B00A9; Tue, 22 Sep 2026 08:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2AA6B00AA; Tue, 22 Sep 2026 08:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E44756B00A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:50:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5587912046A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:50:32 +0000 (UTC)
X-FDA: 85241381904.12.085B4E6
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id 83EED1C0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:50:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lYfwYfDe;
	spf=pass (imf18.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0InqCD2bFX5rmcrNzb8mSPBMc5yqyI94TSlu34y088=;
	b=PvRVa7LqXFe0Fw7tEcpmfbMX9e040CJhsk+cS/xYSNmCmuwjBu8LL9APp6E2CHuo2RilaU
	AlC5y1fUA3ppv3hCRZNVz3WJF26inNvDA0PguYFJgV3U9kyzYzVGF5BYySl3Z//yuT0SkX
	zZGcmRdZy46Owk4dwqwEsOWkyn0C9oc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081430;
	b=QLZ4ACZWJqpfaKcNy0KuIUDXdiEFM5LTw0WsGrPFbT0lXi5IS+P/TVv+g7FQOmcC7y+U3r
	BrQY/iOjatT8XpnZGq0e8/uxfwU6NTIWaBjP4Zx+1U+X4DPjlrvZ3/wX+6yocEq/GYDvRS
	quBOoIpUh3daUmGPo8/gcRNpcKOo204=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lYfwYfDe;
	spf=pass (imf18.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so3025090a91.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790081429; x=1790686229; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T0InqCD2bFX5rmcrNzb8mSPBMc5yqyI94TSlu34y088=;
        b=lYfwYfDeciX05fcqZUizIkgfkvKLeeQ7owx7b4OHLO83TS7AQ8cUkSp6vXD7R0imQ6
         efGoAVr+txjNfNnGw6omOiewPsVSxuZ1ju+bofP8L1lrDwKIX9WFtcGC7u4qKee/+HpB
         v+oTUL6uuw0WKH1ciTnlOIeGR+emNVY7b9QGaUFGDHz2m3rW00gkRISW0SlfMZW8m+XP
         q9/iuX3ctPKlNMPCy5AoH6SN68UI3xxgTArHksL8voonJVrRRIqxFKf1A7jb0TdIiUkE
         OAw9jGvz1QP/Z8v6cW1zAtXsoLLIEpH8r0B4KqoOpSCuC0ixxiM7Npyq/HHoBkNiMPnB
         6cBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081429; x=1790686229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T0InqCD2bFX5rmcrNzb8mSPBMc5yqyI94TSlu34y088=;
        b=mwGSdmSH0BeK9pRPU9xrcch6M+LDGGsvRE/d+8rAHAeNyIYchYaThB6R0ZkbJy2tZv
         YAywA/zrPPn2BLfyJkjgDi7cA7NQQ1Vqc8d4P3wAgqlTMBPcLvaZNPsQlLbUgMDzpr/A
         DDtvxdqKBBuD1tJYBJRW2uaT7C+6MAjJcDeJWAQMTJoTZwDcEOQB2YkuWWnBdtP8JHto
         RSGVIBXA2TEgxaevHPFbKEdCvr7uGRxzx2AOvqRaLa00ikPwPbzZoVhnfoAkuIhq2Lrz
         EzOeqUMFosof0WkiSBYA9lXJ6ekJVZUnfw/PVmpBrzB524QEySPM5A0TjTF67d4FtuvU
         +Bsg==
X-Forwarded-Encrypted: i=1; AKwUvBwqskncvmMdYTSQYZ+q5JdN3mwlGiHlmvGPhzZPTtP7O1H2dqHm2j6+SLUc9V4h6/ECocH8Fv0y0A==@kvack.org
X-Gm-Message-State: AFuF++nx83RFlhreDPg83+uaYvGYlKtdURHx/Sxh8/gbz/9TvmzmIOw3
	74iiYUyPGGD0cj9QcyzP34PNP6cfk3ARvfLabzURivE7brkZPocguv0pTe7vTmjXn7Q=
X-Gm-Gg: AYBFou0yAgYxSE5ZeFscA4smDzvFgf20i7VZYTQ24tw66sfkP4CXKXjpc2pI8xdhR9g
	RH7ETOE+Do174nGD7DvsxO3eAawohYBsciSwnFUDN8GtPWE0CySzx3f5t/AeUhqRPxQMvNcvRQT
	V5DsfFiAfpR5voIM5vfJ2r/qCbyhh2h1SK8uulB4TzwdkjaZxV/GzFhiOA/0HTxCRJyBqRbkgbC
	yWa6QlRqmCcZs16LPRNKrZGPnti6e9tRx1eN0paKuo12A2LVMm74gVYXbVcdwsujrCp+3u+twOy
	4VGXJMoiRs5OTD3yApB4ocN6IV3m3NRy9FCSgHDuM8ie20Szt7c/AZTSlQkKfTeyoSJC4uGp8RX
	AWkLnjHT7ZjMGqSsoEtskidEJ4E1Apsz7yjlY7NylDDXQsq9g51HXa3DdY99EQ3SGBUswjhSvxT
	ZbfLayhWGwMBSJATscCblL9h4PGlCEURix9X80jXOMvVnIieszXjLAZb+EwA9mchXKMBL0OxnWf
	K4=
X-Received: by 2002:a17:90b:54cb:b0:39e:6a81:f34c with SMTP id 98e67ed59e1d1-3a073200371mr1048612a91.38.1790081429096;
        Tue, 22 Sep 2026 05:50:29 -0700 (PDT)
Received: from localhost ([106.38.226.140])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06cb7159fsm1246162a91.4.2026.09.22.05.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:50:28 -0700 (PDT)
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
Subject: [PATCH v8 2/3] memcg,writeback: flush foreign bdev mappings separately from owner wbs
Date: Tue, 22 Sep 2026 20:50:14 +0800
Message-Id: <20260922125015.3435215-3-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260922125015.3435215-1-sunjunchao@bytedance.com>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ai1d4ya66yjj1adysq5hdsaosg763hky
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 83EED1C0004
X-HE-Tag: 1790081430-608108
X-HE-Meta: U2FsdGVkX19glO6wQoQDa3aqOWdw4HUhajKVdEDt0SdjQ/Q6jgZDg8iL+k57ZaifBxfoN8AiuTGfv3aDQbs7w9lQudj2dLo8TV1D/g66UpKEQXQCRDEORCk44rxB+mPA6BK2DMKektHrWu2umESAapJZjeZq9SjX6MEBy0vIKRdO5ltbNsavZq3siLNw98pM+ndSK92sMAXy1J9gzDtB8957T2cej7PZ8Z+Yzv6ri3oDgOKnYKb9PYilM5tQosKJHj0xzC/Hb4CVX4GPoqTQpB3zRzf7kDquwW+ynCQwprXo0HXwNdW3izoqMdqnr0CY08U+yp2FIen2TTax7BuhqOesYCVWcWXdqISRslTa76acnKmyKHROP39dWX2KwEQuyhUaU0ZUQ1f+wOCfRf/M30+R2+cwMIdbjxVHMeBI8q1SelQrV4BPGdT+peFGL+i2eIF2GblH3Wi4iTEeF673UUfQt3e7aCQWgJ8GuIhwPbXrj67rc8ZO1xSXGKV7OdBvNsTrak0pAEz3hBA/fbIO5nn0/bHvJwMpb2cjZ/Q8EZKnUv9dvTOBfz4oD3S0yIwK6xtVlVj3r2dqg9VMrOpcxBBRvRd1XsrU6eqb1fVUDfxxRmZ6Yloaxtg2DjXOWHDCIFOHOAomkgNHiZEPABWsn5Ix3n2vek4nszy5UPSkTyPzvg0Rl/FShfk7y2I+ti9HHWcSHdWU+hrk76NSelDiIzUvbpOkin2MkNcF8CtrrEg3FtIbzCzRNye+hukiWTrdBX7npmIGzVzQqOHlUDVtb9Vn1T4hrtTDdatQC94zsn2Zi1rfT8EUzROhvxTBw/VDxsRlRGUfMOHyXo/Y1NYYkq0Nc6gtxw3o7/dd5bUqKBBZ8atTZUIrt1xb3R9IbiN9CCZChohtdd+3EGKHdqIyv5Hj7QCBDFEGM6PFvEOmFTTeZKju+CZazqu3cQ6yHusueLFzNU63ux2YVIEVEbT
 jRGAMDga
 h7U26zE5P6tJzGhbm7qBOHGi9iu5dJEE1QcMnQXckz2DAX4oHENljpmilTuI76NLimpkeukHrjpt1BczZKcahGi8ajMGdQsLJuIF6whOupoUYAKkqRYcWQP9+0J/yEt5vZ6R6wVVgeVemAyvVWMdDhIrsIQy32yNdZlFPn32W9T/uYnzr5EylsuB+IXgynloo0k1gqQe1eCqdYVVuPqOjxe862A/nkPTVgXGzTlIi4yUvtJ5z1ffthFR2o1XVvP0IOewtwGyeutyLSCdYn0kESF6RoZvj0nXz2TNqkoaM9jSnrh/4vmqNsDHEc0hQKj1tMM+6hsUz8JJh7wT3GmRXqG73XSZnzsofjx7O3fehqcj7EzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bdev inodes are routinely shared by multiple memcgs. Recording their
owner wb as foreign can flush unrelated file data when a source memcg
enters dirty throttling.

Record bdev device numbers separately and queue work on
memcg_bdev_frn_flusher to write only their mappings. Keep the existing
foreign-wb mechanism for non-bdev inodes.

Use fixed per-memcg slots. Tracking uses oldest-first replacement and
expiry after dirty_expire_interval. Further dirtying during an ongoing
flush can trigger another flush after it finishes.

Tracking is best effort: record only dev_t without holding device or
inode references. Records are updated under the mapping->i_pages lock
with IRQs disabled, but dropping a bdev reference can sleep. Also, since
foreign flushes are triggered by dirty throttling, a memcg that never
throttles could retain an unused record and pin the device object
indefinitely. Recording only dev_t avoids these lifetime constraints,
but device removal and device-number reuse may race with lookup. Such
races are expected under the best-effort semantics.

Bdev writeback submission can block for a long time on congested devices,
with up to four work items outstanding per memcg. Use a dedicated unbound
workqueue to give these flushes a separate max_active budget, so they do
not exhaust a shared workqueue's active slots and delay unrelated work.
If the workqueue cannot be allocated at boot, bdev inodes continue to use
the existing foreign-wb path.

This primarily affects filesystems that keep metadata in the bdev page
cache, such as ext4 and other buffer_head users, rather than the usual
metadata writeback paths of XFS and Btrfs. This also covers buffered writes
to raw block devices. The decision still does not account for how much of
the memcg's dirty memory belongs to the bdev. Even a single dirty bitmap
block can trigger writeback of the entire bdev mapping when the memcg
enters dirty throttling.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 include/linux/memcontrol.h |  12 ++++
 mm/memcontrol.c            | 117 ++++++++++++++++++++++++++++++++++---
 2 files changed, 120 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..c2699a1b82a2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -176,6 +176,17 @@ struct memcg_cgwb_frn {
 	struct wb_completion done;	/* tracks in-flight foreign writebacks */
 };
 
+/*
+ * No extra memcg reference is taken: this work is embedded in the memcg,
+ * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
+ */
+struct memcg_bdev_frn {
+	struct work_struct work;
+	dev_t dev;			/* dev_t of the foreign bdev inode */
+	u64 at;				/* last recorded dirtying time in jiffies */
+	atomic_t inflight;		/* flush work is queued or running */
+};
+
 /*
  * Bucket for arbitrarily byte-sized objects charged to a memory
  * cgroup. The bucket can be reparented in one piece when the cgroup
@@ -279,6 +290,7 @@ struct mem_cgroup {
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
+	struct memcg_bdev_frn bdev_frn[MEMCG_CGWB_FRN_CNT];
 #endif
 
 #ifdef CONFIG_LRU_GEN_WALKS_MMU
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..6042c694d56c 100644
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
@@ -3875,20 +3877,72 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
  * most recent foreign dirtying events and initiating remote flushes on
  * them when local writeback isn't enough to keep the memory clean enough.
  *
- * The following two functions implement such mechanism.  When a foreign
- * page - a page whose memcg and writeback ownerships don't match - is
- * dirtied, mem_cgroup_track_foreign_dirty() records the inode owning
- * bdi_writeback on the page owning memcg.  When balance_dirty_pages()
+ * When a foreign page - a page whose memcg and writeback ownerships don't
+ * match - is dirtied, mem_cgroup_track_foreign_dirty() records the inode
+ * owning bdi_writeback on the page owning memcg. When balance_dirty_pages()
  * decides that the memcg needs to sleep due to high dirty ratio, it calls
  * mem_cgroup_flush_foreign() which queues writeback on the recorded
  * foreign bdi_writebacks which haven't expired.  Both the numbers of
  * recorded bdi_writebacks and concurrent in-flight foreign writebacks are
  * limited to MEMCG_CGWB_FRN_CNT.
  *
- * The mechanism only remembers IDs and doesn't hold any object references.
- * As being wrong occasionally doesn't matter, updates and accesses to the
- * records are lockless and racy.
+ * Bdev inodes are commonly shared by many memcgs. Flushing their owner wb
+ * can write unrelated file data, so each memcg tracks foreign bdevs
+ * separately in MEMCG_CGWB_FRN_CNT slots keyed by dev_t. These records
+ * use the same expiry policy, but trigger writeback of only the bdev
+ * mappings.
+ *
+ * Both kinds of records only remember IDs and don't hold any object
+ * references. As being wrong occasionally doesn't matter, updates and
+ * accesses to the records are lockless and racy.
  */
+
+static void mem_cgroup_track_foreign_bdev(struct mem_cgroup *memcg, dev_t dev)
+{
+	struct memcg_bdev_frn *frn;
+	int i;
+	int oldest = -1;
+	u64 now = get_jiffies_64();
+	u64 oldest_at = now;
+
+	/*
+	 * Pick the slot to use.  If there is already a slot for @dev, keep
+	 * using it.  If not replace the oldest one which isn't being
+	 * written out.
+	 */
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		frn = &memcg->bdev_frn[i];
+		if (frn->dev == dev)
+			break;
+		if (atomic_read(&frn->inflight))
+			continue;
+		if (time_before64(frn->at, oldest_at)) {
+			oldest = i;
+			oldest_at = frn->at;
+		}
+	}
+
+	if (i < MEMCG_CGWB_FRN_CNT) {
+		/*
+		 * Re-using an existing one.  Update timestamp lazily to
+		 * avoid making the cacheline hot.  We want them to be
+		 * reasonably up-to-date and significantly shorter than
+		 * dirty_expire_interval as that's what expires the record.
+		 * Use the shorter of 1s and dirty_expire_interval / 8.
+		 */
+		unsigned long update_intv =
+			min_t(unsigned long, HZ,
+			      msecs_to_jiffies(dirty_expire_interval * 10) / 8);
+
+		if (time_before64(frn->at, now - update_intv))
+			frn->at = now;
+	} else if (oldest >= 0) {
+		/* replace the oldest free one */
+		memcg->bdev_frn[oldest].dev = dev;
+		memcg->bdev_frn[oldest].at = now;
+	}
+}
+
 void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 					     struct bdi_writeback *wb)
 {
@@ -3898,6 +3952,14 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *inode = mapping->host;
+
+	if (memcg_bdev_frn_wq && sb_is_blkdev_sb(inode->i_sb)) {
+		trace_track_foreign_dirty(folio, wb);
+		mem_cgroup_track_foreign_bdev(memcg, inode->i_rdev);
+		return;
+	}
 
 	trace_track_foreign_dirty(folio, wb);
 
@@ -3941,6 +4003,16 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	}
 }
 
+static void bdev_frn_flush_work(struct work_struct *work)
+{
+	struct memcg_bdev_frn *frn =
+		container_of(work, struct memcg_bdev_frn, work);
+
+	bdev_flush_by_dev(frn->dev);
+
+	atomic_set(&frn->inflight, 0);
+}
+
 /* issue foreign writeback flushes for recorded foreign dirtying events */
 void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
@@ -3949,6 +4021,21 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 	u64 now = jiffies_64;
 	int i;
 
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct memcg_bdev_frn *frn = &memcg->bdev_frn[i];
+
+		/* Keep the workqueue availability check explicit. */
+		if (memcg_bdev_frn_wq && time_after64(frn->at, now - intv) &&
+		    atomic_cmpxchg(&frn->inflight, 0, 1) == 0) {
+			/*
+			 * Clear now so dirtying during writeback can refresh
+			 * the timestamp for a later flush.
+			 */
+			frn->at = 0;
+			queue_work(memcg_bdev_frn_wq, &frn->work);
+		}
+	}
+
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
 		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
 
@@ -4202,9 +4289,13 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	memcg->kmemcg_id = -1;
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
-	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct memcg_bdev_frn *frn = &memcg->bdev_frn[i];
+
 		memcg->cgwb_frn[i].done =
 			__WB_COMPLETION_INIT(&memcg_cgwb_frn_waitq);
+		INIT_WORK(&frn->work, bdev_frn_flush_work);
+	}
 #endif
 	lru_gen_init_memcg(memcg);
 	return memcg;
@@ -4386,8 +4477,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
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
@@ -5703,6 +5796,12 @@ int __init mem_cgroup_init(void)
 	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
 	WARN_ON(!memcg_wq);
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+	memcg_bdev_frn_wq = alloc_workqueue("memcg_bdev_frn_flusher",
+					    WQ_UNBOUND, 0);
+	WARN_ON(!memcg_bdev_frn_wq);
+#endif
+
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
 			  drain_local_memcg_stock);
-- 
2.39.5


