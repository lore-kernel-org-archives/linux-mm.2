Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F480C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 09:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480C16B0098; Sun, 20 Sep 2026 05:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454E06B0099; Sun, 20 Sep 2026 05:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345A46B009B; Sun, 20 Sep 2026 05:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 056876B0098
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:24:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C9A61A040A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:24:36 +0000 (UTC)
X-FDA: 85233605352.13.2DB6F7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8AA0C0003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:24:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OopB1Mkw;
	spf=pass (imf10.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789896274;
	b=H2mFVaczv64mf/EByJ0iwkidYThwlzDXRQUZ0llQ0nRC0iz6PFPcAD1jiH/k1rO2NWfTSK
	xIgM0cSg2woyi/IyzVRo8EHgyHmhmxUiPQhz0K8jSrsYGnxLHTvgd/95so/zA4GD+8sOkK
	wuZhx0hhtTA3MKw96eD7BpQ3GGE57kE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OopB1Mkw;
	spf=pass (imf10.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789896274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0bHm3iAFJ2FAvo7Q79lhKrYFqfJ7Dsy6ioYDke8xPA=;
	b=x8RCwH8gKof9TsnV3BV3MH8VZ75LW5qp9xtVekQY4BwqyqAwE67oPxm275vgtbb7PqReJq
	Do6evgCzuNlwixRDuAjy9mebmg+4kUblwNo2nxiwPErQHf9Epr+tv99Ly9p/In4wVQymbV
	dMzbPS7GDIPXrkGlLNpYDsOPZ3GTQ1M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1898943226;
	Sun, 20 Sep 2026 09:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A5C1F00898;
	Sun, 20 Sep 2026 09:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789896274;
	bh=P0bHm3iAFJ2FAvo7Q79lhKrYFqfJ7Dsy6ioYDke8xPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OopB1MkwmNP66l97NW/PpwUHNZl0w89lNP+o8JrKcD0jQOFEmM8f8vVum5nGuwlcM
	 mpqlUqXrBg1gI0RYbkRVlNDpN6ERIxKgGGcoiAjp9hgJ0Tr+mXYSP8YgrP6P/dG3Cf
	 RhpOPbP27LY3xqL56uGr7NrVWRslUPx6Dh8lrYyMxncsAaZc3NXDv23pw4cT8gRgOd
	 u/1jXOUn3dnsUcxxKmN6ZyzQ31N9Rl0ZkbmowGsWBH+MfVB/iAYeLdV330E/ZINe+e
	 J3wZFse1QIMTaeYcqqtZbfr47zVmw5NbxvS4EF4X6xFgBmBNcJ+vtR7GIo5kiMKbZF
	 fp6CfuBLNutcA==
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
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
Subject: [PATCH v4 3/3] blk-cgroup: move async bio punt state to blkcg
Date: Sun, 20 Sep 2026 17:23:51 +0800
Message-ID: <20260920092351.2434283-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260920092351.2434283-1-yukuai@kernel.org>
References: <20260920092351.2434283-1-yukuai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8AA0C0003
X-Rspam-User: 
X-Stat-Signature: tab1xt7ujmeefbmr75ijjgks359px3bg
X-HE-Tag: 1789896274-824337
X-HE-Meta: U2FsdGVkX19PwRxFmQv3HVRzJ5DXj2qT2PCZPik/CifOWnyj5kc6Hxr5CSdNiUXntvIlSp7YJ8nk5ML5yIgFYEs4g9r9b3ZxYRM08O/UFGL21zX+k4eAqvkzgNBpazO88EOhIPeSB+fOXmYLAtjstv0dFyUydtxq42PiLL/8BKppIK/SFQH+qMVh7/rI1ST8Q6o1YADpjDvkQrnkMesJeeCq4iX6vh4omLMfew5BAGgluWZ0hLlzAqd41BPwjHcapflxS9gS1jl2xdMAwD4a+XcHy3AlQnLe58tq9aqksTQ+SskMPN2mFmb9uV1APZCrydzo2MEAJsHsRQ4NK1u3BXLve6Fi6IXNj1MIerg7Zp06pGs+/sWX0RDATuAlUGTj6FTyyK8M4svZQmUdqZHsV4PBjckJJdm/U5rJZPldDl15gd7g0usBl8L78ACbPEWKIOX/9AZNW5/rb2yPdJZLVpixWE8oQKczU0Gh6nAu+Xq59u2cyFyiX2VliXZ6zNVDpex5Da9ku6BVK42Ad3EvhlH4fl38ByvcvvTqJ7JOI3Td2KCnW8Lo1xXfEBO4df80Sk+g5e1mNLZP4pZ0fk2NCcx39wi+qyvyqCyvrqkS59s2PeyPh/gvokPZX1cHpAiSmUFV83OiD1VOeSYZddpcl5Ccvgd9bqf0VDpLNiCeRxbR0EZh1BnFi9ziw4c2CA89mR9W4kHXMtXLtvj1QSz9vov1WPsFQLjKEWA1doy6VL0g60FzVYbr6KmQSu4tdkoSkL2is2f/OEb14lpbU6cCJRqFkLxIPtvozqUcAQuaXMh/MAKj9Unm2KE37vPB9SzFOAnpQTQoKFjSg15DMUPOg8GnJSeGrDjUlXEH2MEDsj71CTyYFFNBNSgwTLNfRQm9uHxgeBsOvavdSU8J5oP/6xr7gc7JTbbevuEW1TFbXokGPUbDRNXbzZyp4IX9Yf6O/53zLlaxc3yWMvz7IU1
 hzzIESpN
 f+0AADXKJaAp956mmX2VScaRt5g9A6rI3PQtSv0mjPhdOtP3e3csCvYcI1o43hOtGWF6MC7OLOvXflCgwRx+t0SlmuP4Js2pxAb6y1TOx/0EP1al5s2hVFebDA2VuExSZ1MhHoPmpgu44dliLRf/VbWsigATmUz99H/07MIpkuqTQydbl/FS177lgoqYD9bv/uz2yXkdgTTmSsL2K5won1jOO6NjQJoRsaxzTgg+LojhmiuA=
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
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c | 40 +++++++++++++++++-----------------------
 block/blk-cgroup.h | 14 ++++++--------
 2 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index aa84b603d4ce..43bd682f91a1 100644
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


