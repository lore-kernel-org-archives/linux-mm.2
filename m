Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF92C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 04:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBAFD6B0099; Fri, 18 Sep 2026 00:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C935F6B009B; Fri, 18 Sep 2026 00:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B446B009D; Fri, 18 Sep 2026 00:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 819956B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:18:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0671120565
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:18:31 +0000 (UTC)
X-FDA: 85225576422.23.E62F410
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 405F580005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:18:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAwWiY7D;
	spf=pass (imf02.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789705110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfppJp8zrxHMpzyaV8VLzykkmDT25fBzST+B7CKyroc=;
	b=PPLjBt8myV3Wn9SZbZAmLuXX4ZklfS7mdPDsSMYo8WWEDvyDauvwYee0TAZSTmMqb0pU2S
	6RnfZqoInGZfIcvG7ODB39wmgxLKOHQhIzPnctlPsWZi8JfLu/gAq5SeVwT49LRyHPGLK9
	3ICQuSJX+71VLcwpjs5UWNhNqM8Ic64=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789705110;
	b=PqHNJvXJ0cWkJfe8ufyx4Z37OHDlkZAee6TMLQHcNltzDc/5Ebc3ALqbl1Y7WylPImZ8R+
	J2cW9NDA6veME7clZLauVPk9rrUyMfg51GaM6ACIAl/60Z2EzquWIUh3l7fbElDtVm9+by
	jz1+d32c4Z4XndYQk2qAu/CuBDOVo90=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAwWiY7D;
	spf=pass (imf02.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A09D1407AF;
	Fri, 18 Sep 2026 04:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F02D1F00893;
	Fri, 18 Sep 2026 04:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789705108;
	bh=IfppJp8zrxHMpzyaV8VLzykkmDT25fBzST+B7CKyroc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAwWiY7Deif7+Op6gb6GTVrcArdtHpbZNbaSOIvOLfg6xNsYUstfjsHxncwqEtpfl
	 QLB+whWLHYdrRa0XmEoYUgIakQ72eSVY/qdZErsXoAIWvfs6KmDM3fdiX2gm9Ov4hy
	 ntu71EE3AAu0PcI3ZCImhPon24ne5FPDnPVuEEJZOnJvLytoTHvkQY1qaqNYNUN1er
	 UOu9VQwtWOG4Om8WSjVYir9knzzfaf1GUkJKbfj3qPoKbx5E4Aq67QCPLdhnCyNTF1
	 opEYoRB3bzAQMyYxtaF1HHsVaSX0js+vBicMtWeMmAzZ7GU0pWjqQgHpRLKogLEJmM
	 4C+DutKsVjfAA==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cuitao@kylinos.cn>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: [PATCH v3 3/3] blk-cgroup: move async bio punt state to blkcg
Date: Fri, 18 Sep 2026 12:17:44 +0800
Message-ID: <20260918041744.1526924-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260918041744.1526924-1-yukuai@kernel.org>
References: <20260918041744.1526924-1-yukuai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 405F580005
X-Stat-Signature: rm8ictjn8tr9tq5ssukgu4wrtut397iy
X-Rspam-User: 
X-HE-Tag: 1789705110-981592
X-HE-Meta: U2FsdGVkX1/dggiGtTQDqXrCvkBnOzOm1RUlIsA9gzBKlbnMoLjoO+YgR9TmAPtNUP6zj+xn4qivYCW/v99QIkIqkeVo0SZfrC+2gPCEXTm92VGkubvIz8hSyFlHS9660iRtnYGFVmxKUySuq1kyb8umWNtc+rEpGVvUUp1xpYYlmXIieSdsOEPb+Lry8yHsB9XFd4Dpm/aL7BVcajFX73hxjwJanlzAeJJrNNEzrYP4wdzl1zs6qBUkom3NyZh+p4FL2QR5k/C3nRGvsuyYu+v2xpGeZ/bpywoy6imD7wC9gMPI3KevMOHGhqXTmYpcz7+g3R7zW+Hw48AmAzv/jBQMDLBr621jsb2NYbBlrJdiFxO93DeVnlxYOMbST70QMsEaK8ftFmnr2NKusRsWTnrF7HbiMUJ5ap2+Pha2Y0mSqE/dmPf0YGG3i72otOwFqnjEzzvoQOFfkOsgxiODtWmCzSdtP3uMYnL9LgQ8j4Zx2uY2yXq2OZpOOU0kOKdRmo3JAixAajr8w+wWasSrTKwGaLG+zeHyEBttPLg4fIoMGnXcCW7nNIy1BlYz3AllzbqzKOTnrZYyX/ZWEYxS6mTtDtxEZ2030NPqWORNpnouOzHPI5jy4T8sJ5SKcyTU2Rc83Hm3noX1uYnR/jiBVyhk6QntcCAZZOKs5bRz3OVN0LKtAzRQ9YjK22NqZSKmqU/N7DRk9gFvfM1JvV9Hws5e4smNt2e37YBta9eHnp2499cE9yLei1do57/W8nhPfe3GXMqiPfViwPDIDWSGRYT0g1s2jymoYFn+dM/DqBTV4cxtzre1AagodhbWLxnoxdxFjkD+BEcGV8Etpdmd0t6hK3VOfUJFVs3LdO4/eJqCkp8XRRH7ML9otpwpSG2vIGBtfDFOpBgcyaqxtRyCZ9mFZaKgN+SFsdvYv8lphp4+I59Xx14LJD+mg7WR2S0iuTcdrO80vcdS5jwb9Un
 CuijLUI9
 LSko+v8u6TKN/KE1aHYlcZDQ+9+tW8wL3dTcpGX2XWcWSG8xeGtozR4bq7pxqP7u8W8iw4y3IKfJJitl4V+3pyDDzKGMdZrxJcxgA0jrxVnxWIzUO5nMI87uxg3BAI6wfRG8sJtJAct+NSKdz/Z49glV027DHXX5W3KKaqk0f4xI4w6iynp6N+7Ld9NN9rUOpqfTrP6RopYFGx2rupjPDVXOVOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

blkcg_punt_bio_submit() currently queues punted bios on blkg->async_bios,
so it has to call bio_blkg() to find or create a queue-local blkg.  Bios
now carry and pin the blkcg css, so punted bio lifetime no longer needs to
be anchored by a blkg.

Keeping the punt state in blkg can instantiate a blkg even when no blkcg
policy is enabled, just to bounce submission from a shared kthread.  Move
async_bio_lock, async_bios and async_bio_work to struct blkcg, and queue
punted bios on bio_blkcg() for non-root cgroups.  Root or unassociated bios
are submitted directly.

This preserves the priority-inversion avoidance while preventing
blkcg_punt_bio_submit() from creating blkgs that are not needed by any
policy.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 40 +++++++++++++++++-----------------------
 block/blk-cgroup.h | 14 ++++++--------
 2 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 59ccfefe16a8..32e82880893b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -180,14 +180,10 @@ static void blkg_free(struct blkcg_gq *blkg)
 
 static void __blkg_release(struct rcu_head *rcu)
 {
 	struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq, rcu_head);
 
-#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
-	WARN_ON(!bio_list_empty(&blkg->async_bios));
-#endif
-
 	blkg_free(blkg);
 }
 
 /*
  * A group is RCU protected, but having an rcu lock does not mean that one
@@ -226,23 +222,22 @@ static void blkg_release(struct percpu_ref *ref)
 }
 
 #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
 static struct workqueue_struct *blkcg_punt_bio_wq;
 
-static void blkg_async_bio_workfn(struct work_struct *work)
+static void blkcg_async_bio_workfn(struct work_struct *work)
 {
-	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
-					     async_bio_work);
+	struct blkcg *blkcg = container_of(work, struct blkcg, async_bio_work);
 	struct bio_list bios = BIO_EMPTY_LIST;
 	struct bio *bio;
 	struct blk_plug plug;
 	bool need_plug = false;
 
-	/* as long as there are pending bios, @blkg can't go away */
-	spin_lock(&blkg->async_bio_lock);
-	bio_list_merge_init(&bios, &blkg->async_bios);
-	spin_unlock(&blkg->async_bio_lock);
+	/* as long as there are pending bios, @blkcg can't go away */
+	spin_lock(&blkcg->async_bio_lock);
+	bio_list_merge_init(&bios, &blkcg->async_bios);
+	spin_unlock(&blkcg->async_bio_lock);
 
 	/* start plug only when bio_list contains at least 2 bios */
 	if (bios.head && bios.head->bi_next) {
 		need_plug = true;
 		blk_start_plug(&plug);
@@ -259,19 +254,19 @@ static void blkg_async_bio_workfn(struct work_struct *work)
  * cgroup.  Use this helper instead of submit_bio to punt the actual issuing to
  * a dedicated per-blkcg work item to avoid such priority inversions.
  */
 void blkcg_punt_bio_submit(struct bio *bio)
 {
-	struct blkcg_gq *blkg = bio_blkg(bio);
+	struct blkcg *blkcg = bio_blkcg(bio);
 
-	if (blkg && blkg->parent) {
-		spin_lock(&blkg->async_bio_lock);
-		bio_list_add(&blkg->async_bios, bio);
-		spin_unlock(&blkg->async_bio_lock);
-		queue_work(blkcg_punt_bio_wq, &blkg->async_bio_work);
+	if (blkcg && cgroup_parent(blkcg->css.cgroup)) {
+		spin_lock(&blkcg->async_bio_lock);
+		bio_list_add(&blkcg->async_bios, bio);
+		spin_unlock(&blkcg->async_bio_lock);
+		queue_work(blkcg_punt_bio_wq, &blkcg->async_bio_work);
 	} else {
-		/* Never bounce if there is no non-root blkg to queue on. */
+		/* Never bounce if there is no non-root blkcg to queue on. */
 		submit_bio(bio);
 	}
 }
 EXPORT_SYMBOL_GPL(blkcg_punt_bio_submit);
 
@@ -350,15 +345,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	blkg->q = disk->queue;
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
 	blkg->blkcg_id = blkcg->css.id;
 	blkg->iostat.blkg = blkg;
-#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
-	spin_lock_init(&blkg->async_bio_lock);
-	bio_list_init(&blkg->async_bios);
-	INIT_WORK(&blkg->async_bio_work, blkg_async_bio_workfn);
-#endif
 
 	u64_stats_init(&blkg->iostat.sync);
 	for_each_possible_cpu(cpu) {
 		u64_stats_init(&per_cpu_ptr(blkg->iostat_cpu, cpu)->sync);
 		per_cpu_ptr(blkg->iostat_cpu, cpu)->blkg = blkg;
@@ -1447,10 +1437,14 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 	}
 
 	spin_lock_init(&blkcg->lock);
 	refcount_set(&blkcg->online_pin, 1);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	spin_lock_init(&blkcg->async_bio_lock);
+	INIT_WORK(&blkcg->async_bio_work, blkcg_async_bio_workfn);
+#endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&blkcg->cgwb_list);
 #endif
 	list_add_tail(&blkcg->all_blkcgs_node, &all_blkcgs);
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index f68ea21958f5..7fee8555e713 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -75,18 +75,11 @@ struct blkcg_gq {
 
 	struct blkg_iostat_set __percpu	*iostat_cpu;
 	struct blkg_iostat_set		iostat;
 
 	struct blkg_policy_data		*pd[BLKCG_MAX_POLS];
-#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
-	spinlock_t			async_bio_lock;
-	struct bio_list			async_bios;
-#endif
-	union {
-		struct work_struct	async_bio_work;
-		struct work_struct	free_work;
-	};
+	struct work_struct		free_work;
 
 	atomic_t			use_delay;
 	atomic64_t			delay_nsec;
 	atomic64_t			delay_start;
 	u64				last_delay;
@@ -111,10 +104,15 @@ struct blkcg {
 	/*
 	 * List of updated percpu blkg_iostat_set's since the last flush.
 	 */
 	struct llist_head __percpu	*lhead;
 
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	spinlock_t			async_bio_lock;
+	struct bio_list			async_bios __guarded_by(&async_bio_lock);
+	struct work_struct		async_bio_work;
+#endif
 #ifdef CONFIG_BLK_CGROUP_FC_APPID
 	char                            fc_app_id[FC_APPID_LEN];
 #endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head		cgwb_list;
-- 
2.51.0


