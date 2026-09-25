Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A490C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FBE6B0092; Fri, 25 Sep 2026 02:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF9E6B0093; Fri, 25 Sep 2026 02:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580F46B0095; Fri, 25 Sep 2026 02:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A1B06B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:44:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB78380519
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:44:58 +0000 (UTC)
X-FDA: 85251347076.15.0A63BF8
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf10.hostedemail.com (Postfix) with ESMTP id 636A3C0003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:44:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BTozaL2g;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790318696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W028e/7qHpdafGaaElswgV9Bz8E8q5pXxlsv2HaAUwg=;
	b=Vy008IsG6awo2frUUYd6wsluU80T0fLzYd2WjtrEn1aUl3teVHIXDFQrNBrpoO2FnogGBg
	0nEkfhxgP65Z7BmHRdrlLoMY4s0UEjxGGHqN9Vj//RuYsLvqMmNe6BueYXX4iDY2h8qLWk
	/h7ZrLdzvKzXdNlAG749Gh1/B7NnxqA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BTozaL2g;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790318696;
	b=Z0ogIKJU2WDRd2LuOapqoz863hcDCUqfGu3u3hz1Ft9CFTqsoPs1YI5JhTbn3lCLuTtATZ
	srPgoFom7Qs3BUiH4RDSlnXrG3C2kHkCc0BsU27BZ08KGRTQyJKkXKqIOq6cIYuSgxPnA1
	sedkZLMeA2cRLxD52X/e+g/ojKnz9qI=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd5cf02so328369a91.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790318695; x=1790923495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W028e/7qHpdafGaaElswgV9Bz8E8q5pXxlsv2HaAUwg=;
        b=BTozaL2g1JQEXUbxWSexjl8yBX83vz285kJEG1q2XFa/1nDri8+DpXG9oLT8m/1DuS
         9ScY/dpo4E2etacZc0jM3QFDanON8jXQczp3actZ1MLsz4RXQon3oItTJ37qXr211IAD
         BbZwJubik3x6v5R/EXHE/nXgM8bDZsMfhKEg3xKG0kAmHih0aVeMrhSSfcOLotCvI8Ki
         Agt0vjmrRch1DzC+bpXn/9R1PR+IcOTh+WR5RgsCBuPu/wtrSkS0Mo3q6J6OJ90i4+EI
         h1VEWS1kQJ5hXaQ5TkAkY3d8baBzMJCMs4PD/w8nrI5quPQczwqqjPfvPP6R+7H4U1Pl
         kHXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790318695; x=1790923495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W028e/7qHpdafGaaElswgV9Bz8E8q5pXxlsv2HaAUwg=;
        b=L8/32L5SfFtO1xizKTct5Spudfdx2zQRNkUlkJ6E5C6R3/qVIWjPMaW8tUrq+F66Fh
         86DvgKWw8MUM56B3RjeO1zkycSBzq8qLp9dLC6yyBbQu3a2cLICgCFGsRIDHJJHazaPk
         qGseFSkVueDCznRFKbZRuCZavgSWsDCO+8EgFmHOS6t/fwKbnXml96FVfTL4TU4VwGDz
         g0TzR/cW9cgalUZyNh22SzYA2DxMkRlAk9QDph2eAloeHrm0TLVLRhbghxnuWTBWYoi1
         yxksxKEZ0Pny4kSxKVVC4QRoBV3SP/N50RXIj4oQgHMkCyE6V80nZ3IxsGmbwjQzfIzi
         8rUA==
X-Forwarded-Encrypted: i=1; AKwUvByQBmvVQKLqp8bMRC7hiGGbP5ogC/5CKEJ7tEq1YyogD2ws8DLfpBXEp7SN9sIMoti04mC2J5mNAg==@kvack.org
X-Gm-Message-State: AFuF++n4vRESEkI+6fUVO3W1k6gdQZwP3JU9xlNfb9OBxOvVca34OAC4
	lN2N7NNHuflc1osIx8IBW2I2y7tzjp7gMmsyjz9dSpFrwYTfwachDwnrM06FpcQLW5c=
X-Gm-Gg: AYBFou08RZz3AhpGmadtq7LaFmnbPwGAbYwR56IXyJo22Qy6wpbKlTwisI49GE8na5q
	hYB/tp5k8hiS85Dam5dYzERn3nM2KGJ5lZ/sD745Nm9ftwXGPX642qBV1m+krQNDQN7YKfml5VH
	zmQEDg7VUv5CS/bn4HVrjkmVfWCPnPLNj3pr5VvqBErBYAyfyO23MbHp+o3CQgyDqOcZ4xSTHB8
	Jd2Zvpkhu4cMlL87jd7VMsWVpLwtm2MTXVwRrg0m0x6OZyHsAw3fsOyJuAk2IMLWN61IAzNAEtO
	rCd8X/teAPa/dsBi4Vi3RKEQ/g8oQ4CJAsL/22By3YSJResxMlgogJ0kFcV1Qh4s4/n8xLsvQcc
	YakZBgXwkjXt9jMvBt2826BvSs/q+xVF2c1xpPTkSTn799YWI+HJih+3mdVswWKs+k+LO1Cki6b
	DOOLmQMKfq9qsNp952fYKZnLX92grQ/9i5eKzcBHNt0ooZMO92jW3p6ckE3xG166+Tln2DoT+j2
	uo=
X-Received: by 2002:a17:90b:4b83:b0:398:990e:1587 with SMTP id 98e67ed59e1d1-3a0986ed065mr4476822a91.9.1790318694779;
        Thu, 24 Sep 2026 23:44:54 -0700 (PDT)
Received: from localhost ([106.38.226.129])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9355e49sm2598699a91.4.2026.09.24.23.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 23:44:54 -0700 (PDT)
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
Subject: [PATCH v9 2/3] memcg,writeback: flush foreign bdev mappings separately from owner wbs
Date: Fri, 25 Sep 2026 14:44:43 +0800
Message-Id: <20260925064444.3944820-3-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260925064444.3944820-1-sunjunchao@bytedance.com>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1utpf5yst31hoic7em6ytdq39jt9cec9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 636A3C0003
X-HE-Tag: 1790318696-746153
X-HE-Meta: U2FsdGVkX19rWgC0sTYzwfiQOxj98f/umIj09O9REiiJZ3/f8BJCXM7PuQz00/DncAbi+Q2/lfXJ8bqnOaB6u6ilniU8Z2IlIoRtiaN9GVPfw/aB4K3Xk2OAuIE7UM9171mQxS6fSx4A1uddTRmptsrxduHCq1ZaLQbS0DJYgIHL1vIyguX3mTHNVfKeU7s0buiPDuXS4LJnEZgOCR736Pf0VP+uDDc3A9mdgpVocT4JwlNm9+T1Y9htWl4bTs9bjAUNNArjahyAMixLeu3oNz/nlflCb+ODTl1Ns4T/RJQmhmJRYxUrSiPMSHtBEwm0qTqfbWaRgONxFKZ70bGQqEvDaLk5r9IpqK7mzKqompjAI4TozX3Fnpsc9GBUqkCh4nG20PhKvpU5utd/ZwKWvBeC8lEbwvD9247Fsn/lG9Gp7MBaCxRBHv5Wj9h1DynyvuNxq19uOQz4A2to1OMQn5tEUG2XX+Lb12493/b6RB7gV19vaING7+pWd/CW/RA2kAxrqqqcWg9fmXzARQFu9jK9vAVnVAp9z9QBHP0QueEgg3gBIY/BFHAWL9gSMnd/renVIr4m5OeoIyNDjsjH1slGD+EwkCqLsSWAu0xOrXIzw3kqP/KZPWMUWJAnq1RW6bH004SBuR18wB/s0jJKhOJWC5a+lRC8sSBAsZXu2ZSa1VNwB+SZ8ss49kPOivVZcPIsb6Ga1EPTujNo2QYK28zN2/d9kZPKlr6qiVhtMCv8Yt7xxlHF0h8Bzq9Nxx8uVXIeaxAtxEAnybyHbGffA5vdp4MDicl90IPBtTEMsmjanR0baTd/ppzX4/zB+OACbtD4FgcLsHh8IBgzSFZB/v7aKkeGIWM1Cc2Jd63Z/tH93doyo9Zvwt+1TpuFj0ifmlgONDhQiaZXqWigXMiwvV50477QqahcWBIjGQR0XraPHCeHQZlbfa4EAeQsKjoF2lRyxVkp09Q1y6Lth6g
 sqRqUCxg
 04x1vhXhoCXjVZi1PlTxachSZP5h+FuDrF6hcdB/I86WOpuc8XGsyp15YYK5/Ew673EuyA7ap2/BgV7IdDSwIz52CIOMxGi8YGt99GOnwbAy8/qDWplgtPZFwqACoaiz4r/IS+H3U5WRt2Sx/kmBtGBJv8ssCJFn7gOalMiYvOLHTa1Kh9pQwOCitGSppQf+fHgPFK/bSI7D9iejQOejOsyh4jdvOeP6WOEej3jmExFyr5tRHla3HasbyRt+7WMEtoDjfsCeHNlBq5c7hSZZxDuJd7j3bhr9+F82ikVLMiQ2x5hXrIgoCDnaclW3qmpba8tFjuBJGmnu3jkPAUuiYNs55DYS2IGqQDY/VZu1dydnELX0=
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
 mm/memcontrol.c            | 126 ++++++++++++++++++++++++++++++++++---
 2 files changed, 129 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..f13aa529fa15 100644
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
+	atomic_t inflight;		/* slot replacement or queued/running flush */
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
index 856a7d07586c..74677078f9b4 100644
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
@@ -3875,20 +3877,81 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
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
+	int oldest;
+	u64 now = get_jiffies_64();
+	u64 oldest_at;
+
+retry:
+	oldest = -1;
+	oldest_at = now;
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
+		frn = &memcg->bdev_frn[oldest];
+		/* Reserve the slot: it may have become busy after the inflight check. */
+		if (atomic_cmpxchg(&frn->inflight, 0, 1) != 0)
+			goto retry;
+
+		frn->dev = dev;
+		frn->at = now;
+		atomic_set_release(&frn->inflight, 0);
+	}
+}
+
 void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 					     struct bdi_writeback *wb)
 {
@@ -3898,6 +3961,14 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
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
 
@@ -3941,6 +4012,16 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
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
@@ -3949,6 +4030,21 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
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
 
@@ -4202,9 +4298,13 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
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
@@ -4386,8 +4486,10 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
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
@@ -5703,6 +5805,12 @@ int __init mem_cgroup_init(void)
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


