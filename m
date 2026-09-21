Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD161C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D99816B00E2; Mon, 21 Sep 2026 08:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D724A6B00E3; Mon, 21 Sep 2026 08:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5FED6B00E4; Mon, 21 Sep 2026 08:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FB2B6B00E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:08:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FF7C12017E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:07:16 +0000 (UTC)
X-FDA: 85237644072.08.68BA63C
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id BB0B6C0007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:07:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VCMYJlDY;
	spf=pass (imf22.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789992434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJc8Za2aPZMoiI3lBKhq481v++PjI0BiwI3io/gwLcM=;
	b=RLaTrtqSOXw2JI7l0tJ1fFnWuWyEXK7djpflqKIpoFai7mafn5cQDrOyX325Nrvzx0RngJ
	qjEFSWRtbtP980fhQorRTVueMegnENPi6lKZtnpZ31eCS3hYUBI7Cweq7GOSX2y1+Q4kFx
	1NTB0/kBu/IhHqzbWdK0ghCOvHMyXSI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VCMYJlDY;
	spf=pass (imf22.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789992434;
	b=G0V1YGwkvFfpYkngjOZ+DXNru8IQZn5gTSOQzSj18oWVldWqV/d/RPA8zP94PoegpLl7r3
	lvdEuag3Y+HnAhdeLycLK0+czr5wDkcnfxx7hOS3ldLQMwdVkMVj7GhgxT89XWNcEF4EwF
	T50P1WD83H48w+yyH+JOzjoWInPaK1c=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb1a990so2558141a91.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789992432; x=1790597232; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tJc8Za2aPZMoiI3lBKhq481v++PjI0BiwI3io/gwLcM=;
        b=VCMYJlDYo6T70WD+1YDnM2gtRbSfxlzTP36tFAYUevP369+PGNgNI7IWZhueBgJPP+
         mByZaxZKN9lnKINVCFrh5ROFRPkCQlD3wcGrLoZ1TYwr9DhoALQncNGgPzMaEiVdurTG
         PQ+Yi6RpRP3Ea4/TrIOcPU+S7Oe8h8eZUKYgxM8B3mLNcjLvq39cJKJYRoKd6ZtQydj0
         PTB8SqEr/pqr+VKS+vjsqPoNmubRu3li0+CmbOVXXw/tLVwh7snwlSThUYR8zLANhxDM
         RzYG5BoOu/qkzMRsnOXBH9LeyRefyODgjN3a4YLTjoN4zHucwwnk0oikWFSbwnBgpNmE
         us6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789992432; x=1790597232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tJc8Za2aPZMoiI3lBKhq481v++PjI0BiwI3io/gwLcM=;
        b=zJ1uwZSS0lmJSfv7fGbxTkhETBPFhDMcoSN62MT5pSMp401OpK/qlTPKN+dVB3mlxs
         vckxM2tQjNuEaMJew8OO3QBYj9DxCNnSIIAdrJwmDFmlms0M7hxaJ9kMbYmV6lcZbVmu
         mAbZuErED1r76KTI6I9hMqmtiGBYzUgk0S/8MDcpKQMOJgDfSzWt0XdXrqcdK20k7UJh
         WAoI6VWZvJgbDEPYQzJUUSDIMji1B87tWB9xANPM7kUvhH/n+TfjmES3CIqXVJ9azanu
         m7oWb4MEeyjY026lqEZ4ek1+n7qU08he0pDXruvk1P6yxRwrTMArzv/dYXyKOsbMF06K
         4pSw==
X-Forwarded-Encrypted: i=1; AKwUvBw4VWAoEwpDGfUd4ns+ffuHxjQO4qpA+enPT5PBV4/IFKvkWcFAw/hxjQO6t5EZOx1Xk6Xrb9BjAQ==@kvack.org
X-Gm-Message-State: AFuF++nvhbbgEAAxvMX6Sa9pEdFURFWlRXQ89eCE3aIhdSfd4v/YJebZ
	MqVG8XRs1Qjv2GNsyiAnDiQ2NQbNTmHvGwgORqpSwGhcxPPYqr7m3pX8ZP15yY4CRfbx+FoUPUd
	8yUPknQA=
X-Gm-Gg: AYBFou27Ju4zXwZCYdR2sV4ZAMp9VmbHRDOxOwyXuw87lnDN5R3+Z3z+TmN7RsmJynw
	9oXtNqjACD7sb51vYwGlQU1Jxt2Ug7XSx24FjcF/ILZJgrvkYCG5ndtU7EhlvDKC5O9eLBorMHs
	+5cMfDpMwHkTMAqc2SULy/sVHmEUoB1bI+3jpKoCerryemG6eXSvMchmY7aGi7d03ZQv3R4T9R4
	5t0Hkj0U/5klKCmOBpg8KQsNizsAqtxFABPxrqvc3/S5jOqfYk0VbRuF+zOOHCZ+6TkX7IZJesq
	4qCxOmosY+ojCGjjgvuxkEqIVpeVRq8egoFERNTGxlyAOcn5MrTtOdhQVGasYhwiIdHDiBfFvJw
	TmDFbmIcT3CKj08pvWx8WYMsZELIUSsyh+GH4MF+q6zi1C65PMebW93b4PSmlaFLyB0uVJTIBvM
	laJE2RFutT+0r3tAkghC0Pb9YT5Bm6wcwPpj3YZs24D0XfXochZTUZIvh8jZQfUYKm9/0vqUFqN
	g==
X-Received: by 2002:a17:90b:280c:b0:39e:6c6a:657c with SMTP id 98e67ed59e1d1-39e6c6a680emr10210435a91.63.1789992431963;
        Mon, 21 Sep 2026 05:07:11 -0700 (PDT)
Received: from localhost ([106.38.226.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cb3607csm14484008a91.16.2026.09.21.05.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:07:11 -0700 (PDT)
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
Subject: [PATCH v7 2/3] memcg,writeback: flush foreign bdev mappings separately from owner wbs
Date: Mon, 21 Sep 2026 20:06:57 +0800
Message-Id: <20260921120658.1627992-3-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260921120658.1627992-1-sunjunchao@bytedance.com>
References: <20260921120658.1627992-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB0B6C0007
X-Stat-Signature: epp38wd8haobaaco3ewfrw1dxmg3ymzk
X-Rspam-User: 
X-HE-Tag: 1789992433-947826
X-HE-Meta: U2FsdGVkX18xhHcOi2kW12IHSs26exDDna6P+HrZFSnJpuWYL/A1VB9EO7C2v0PCLj25OfA3GnILHAtWmzrMp4TIOFfV7V/+ee4AOOVLj3ivb2d6UZhvh/NK4NAB9fpPDToSH9eb6hMSifzBQ1cdNtk+N1XheiZ3YkiEQlD6CU9EmZ8ahLT7IM1cWS2akRcAAnAGpLCl6xwzcANVfmcBXE+ZXIObpJghOo+fMZJQEWieBYqZ6/ZJl1VJtGvZ1VOy4sZwmf3ApQ8RyPb/G1Yw0dT3qJjNB4pj4gojBNDZgGCWODWVLqAL+2f8O1hWPLnsEEVYwfxIrCDT+aoZiE2F9jMeG+y+3f6xh7CkUBrE2oNk7XhPYwPYlrvpoU4bP6fY4/5/mLE4UaGM3hbRMzuXoUU36lmHGFm8earu+1TiGK+AY6VVT4Tz4uDVw+srCp0sBKKHDVh3gjWBUWivMl3tazvMlG4kiO06ZHkKZERDIaMcIh20jZyQ5wLmoqlKmKroEWsDjYpyd3daLW6s8A3Wkh/EdpNP8A/vea4YtKlECs918PyQTl0Qa+thUECFB3UEsSgReglnZ9KJ90uc/pkv99XWSaJeRL0jUb1LnWoCV+4YYPmPjFFnvXLtpATWa/Pgzd4ZEMSMPtMYGxrPzfai14lsfFuFAzTekl0Q3i5izLi/ijLaBs+R/2+rJir2vD2G8D5m08WtlbWeBOeyw0AJ6ophxHLxBYhB7IcJTERkQqk7hRB1RjCfRQSYiN5R3sKeWk1cj6+tVkvdZQRwqpiWBXZJz/qA3DNsBIT7nmNRoNC6ooeCzadH6klSu7e9+QWO48OSw33xCbFoW3eTSINLwjxBDULLYbFKAN3ZNWmeWdRJEDejhSC45h+iY1GXcurhU+7Rdv4FoVvlck92i5b4No3n+KOP92ZjpoLbFWhv3jE2+VCMETdapTQCnZoi9/gvYbZW0TQKejKhfMXh927
 zctHGI2I
 BbL2BL8BuVuJ2jpR78ct667EMIvY9EqAP5ajuICWhg9ux2lltqFuFAPVRx4wvUNZOt9x4bGFwrQMLIszkkeYbgGJqbzQUVaX8M4EGkIuyFlxULwCdc5bH16GFJuGHMJlb9pzUDDUn3zoPxbDvpwjYEjLkMst/mNIZyzE/80gVWvXain8M6gohubEBvALQkO/FsW4dPP4fqaYPatK5u3jcSqetEoMK72jhu5U81tgdvoTBfbpQisz8orMaS+MLaF2dnoI0Ub8AqQN6+aE8EFXpLayyGVTzlg/c0NVOwqd5xrQH0jXVm8NXwjVZ3mZgbTNHlR36SZ3uu8+XgP9OhMPNeWsTabze2870D47Xzmx9ZyJNmd4=
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

Use fixed per-memcg slots. Tracking is best effort: record only dev_t
without holding device or inode references. Records are updated under
the mapping->i_pages lock with IRQs disabled, but dropping a bdev
reference can sleep. Also, since foreign flushes are triggered by dirty
throttling, a memcg that never throttles could retain an unused record
and pin the device object indefinitely. Recording only dev_t avoids
these lifetime constraints, but device removal and device-number reuse
may race with lookup. Such races are expected under the best-effort
semantics.

Bdev writeback submission can block for a long time on congested devices,
with up to four work items outstanding per memcg. Use a dedicated unbound
workqueue to give these flushes a separate max_active budget, so they do
not exhaust a shared workqueue's active slots and delay unrelated work.
If allocation fails, retain the existing foreign-wb path.

This primarily affects filesystems that keep metadata in the bdev page
cache, such as ext4 and other buffer_head users, rather than the usual
metadata writeback paths of XFS and Btrfs. The decision still does not
account for how much of the memcg's dirty memory belongs to the bdev.
Even a single dirty bitmap block can trigger writeback of the entire
bdev mapping when the memcg enters dirty throttling.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 include/linux/memcontrol.h |  12 ++++
 mm/memcontrol.c            | 117 +++++++++++++++++++++++++++++++++----
 2 files changed, 119 insertions(+), 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..30d0c5d0da14 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -176,6 +176,17 @@ struct memcg_cgwb_frn {
 	struct wb_completion done;	/* tracks in-flight foreign writebacks */
 };
 
+/*
+ * No extra memcg reference is taken: this work is embedded in the memcg,
+ * and mem_cgroup_css_free() waits for it to finish before freeing the memcg.
+ */
+struct bdev_frn_flush_ctx {
+	struct work_struct work;
+	dev_t dev;			/* for bdev inode, device hint */
+	u64 at;				/* last recorded dirtying time in jiffies */
+	atomic_t inflight;
+};
+
 /*
  * Bucket for arbitrarily byte-sized objects charged to a memory
  * cgroup. The bucket can be reparented in one piece when the cgroup
@@ -279,6 +290,7 @@ struct mem_cgroup {
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
+	struct bdev_frn_flush_ctx bdev_frn[MEMCG_CGWB_FRN_CNT];
 #endif
 
 #ifdef CONFIG_LRU_GEN_WALKS_MMU
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..494540cf6278 100644
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
@@ -3875,20 +3877,74 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
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
- * As being wrong occasionally doesn't matter, updates and accesses to the
- * records are lockless and racy.
+ * Bdev inodes are commonly shared by many memcgs. Flushing their owner wb
+ * can write unrelated file data, so record device numbers separately and
+ * flush only the bdev mappings. Tracking is best effort: record only dev_t
+ * without holding device or inode references, so it may race with device
+ * removal and re-addition. A resulting flush of the wrong device is
+ * acceptable under these best-effort semantics.
+ *
+ * These wb/bdev_inodes records only remember IDs and don't hold any object
+ * references. As being wrong occasionally doesn't matter, updates and
+ * accesses to the records are lockless and racy.
  */
+
+static void mem_cgroup_track_foreign_bdev(struct mem_cgroup *memcg, dev_t dev)
+{
+	struct bdev_frn_flush_ctx *ctx;
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
+		ctx = &memcg->bdev_frn[i];
+		if (ctx->dev == dev)
+			break;
+		if (atomic_read(&ctx->inflight))
+			continue;
+		if (time_before64(ctx->at, oldest_at)) {
+			oldest = i;
+			oldest_at = ctx->at;
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
+		if (time_before64(ctx->at, now - update_intv))
+			ctx->at = now;
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
@@ -3898,6 +3954,14 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *bdev_inode = mapping ? mapping->host : NULL;
+
+	if (memcg_bdev_frn_wq && bdev_inode &&
+	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
+		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
+		return;
+	}
 
 	trace_track_foreign_dirty(folio, wb);
 
@@ -3941,6 +4005,16 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	}
 }
 
+static void bdev_frn_flush_work(struct work_struct *work)
+{
+	struct bdev_frn_flush_ctx *ctx =
+		container_of(work, struct bdev_frn_flush_ctx, work);
+
+	bdev_flush_by_dev(ctx->dev);
+
+	atomic_set(&ctx->inflight, 0);
+}
+
 /* issue foreign writeback flushes for recorded foreign dirtying events */
 void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 {
@@ -3949,6 +4023,16 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 	u64 now = jiffies_64;
 	int i;
 
+	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
+		struct bdev_frn_flush_ctx *ctx = &memcg->bdev_frn[i];
+
+		if (memcg_bdev_frn_wq && time_after64(ctx->at, now - intv) &&
+		    atomic_cmpxchg(&ctx->inflight, 0, 1) == 0) {
+			ctx->at = 0;
+			queue_work(memcg_bdev_frn_wq, &ctx->work);
+		}
+	}
+
 	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
 		struct memcg_cgwb_frn *frn = &memcg->cgwb_frn[i];
 
@@ -4202,9 +4286,14 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
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
+		atomic_set(&ctx->inflight, 0);
+	}
 #endif
 	lru_gen_init_memcg(memcg);
 	return memcg;
@@ -4386,8 +4475,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
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
@@ -5703,6 +5794,12 @@ int __init mem_cgroup_init(void)
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


