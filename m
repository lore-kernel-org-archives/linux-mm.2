Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D07FC5B570
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3E06B0098; Tue, 11 Aug 2026 02:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564C56B0099; Tue, 11 Aug 2026 02:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456ED6B009B; Tue, 11 Aug 2026 02:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4556B0098
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:51:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE54440373
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:51:46 +0000 (UTC)
X-FDA: 85088068212.17.D888019
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1FDC0C000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:51:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iczf3uij;
	spf=pass (imf10.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786431105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0ui+uRBvO4M0yd8KG2s22NLotks3BCDPbqh+26w/yM=;
	b=GiHX4Sok9/Rbnuay9pje+mSNepJvIyPISQlH/6LQoFup887BLScqcrp/nLbm/ophb0ZVxK
	qpaR5rDZi3AjYF781G05AQvLD/Qrw1D0ag4pMELzaKk8KhFofEh+IEgqGGDU15BUo75gWp
	h8TzyYmYcuAQDCA8tMgVEaOhcpoNhSo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786431105;
	b=oci8Lj8zmPles/B3sm8uOZuCxjsOg2ZPjUdFpU7A+iwMmlF9VGt5Oo/r7FZpJYSNgUNxia
	fk6WgGN7cYWD1KLbw+bGVNRijHDpU4fyPNjlE2AhOeGYgiTBnLGXRbEUWEi9h6xTdkjuqP
	td5jxo1dnB87vbDH8h4PvQNnz/7nErY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iczf3uij;
	spf=pass (imf10.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 905C6600BC;
	Tue, 11 Aug 2026 06:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097C91F000E9;
	Tue, 11 Aug 2026 06:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786431104;
	bh=Z0ui+uRBvO4M0yd8KG2s22NLotks3BCDPbqh+26w/yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iczf3uijRgzjcA6B/j/Tqrmvx+RsfZ3ic3oyBMPLcYvnCHOsXKyP9Uc1mt+/kKnnw
	 aCg+5WRQK3xX+vxyURFmuUZHcSElN7klIvjPQE6mDsVw1YZ5AFDf1AAtA0XwzjL8wn
	 +V2QyfyO6vno/fnpnsGTHl2ZEAO2dG8ITTJty28KpY7y6myWHuzx9uKF6XML/6ocWn
	 xvqP6MKXEWsqi/kbkY12AbVGGUnwkZKeU30q1clDS3JVvAqF5/4amoYAcBdl8PAJcy
	 L5zGAiYTsbSph5NkP7VwbiyncINSGTTNYAtDbuitLlkDswP1sKH01tBnohL9UMffqh
	 dcTwXOi8G8ajw==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Tao Cui <cui.tao@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 4/4] blk-cgroup: move async bio punt state to blkcg
Date: Tue, 11 Aug 2026 14:47:44 +0800
Message-ID: <20260811064744.1139446-5-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260811064744.1139446-1-yukuai@kernel.org>
References: <20260811064744.1139446-1-yukuai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1FDC0C000A
X-Stat-Signature: cp7dihitbczenng6pbs4nbdkjd5e6pf8
X-HE-Tag: 1786431104-59339
X-HE-Meta: U2FsdGVkX1+0g5D5L7oM1gbJgSmlY3RuPDj5ZxeNCbmvZk07dR52StHmBWtHOgNjAbVhksR73zzpDq9Y10kWdM/512yNiiqZBX2gPsdQ4Xvf0hL1zr8A0/HZ79B12MGqQMwAc6O0QXrQTTc+7xWfgqSpvhmZeR/1I72RWvT1x6CAxZhgltdiS3Mm3dAsSnE09gxCLRI+3oaXbL8BZ+gjIXA83vIL5oD/Ks27v50D7d1VJRCUGnPRBLHpTkYKDekdL+F+7guIdBilWO53m7+Kvg4rGlMD57obLM4EGxw/Ls5jC7+SCF/2HBFe1fl6bfwHbz89ZWCoULfNef/1F0UeAwEfgJKj4EjDiLZOPAcEZCPmII2/j7uxg3sS69EyQucJga3xUs04MHxaaBaiehw4lhTqIkgR4de6AWVDM6YUdHBUREC6fWzcbXM7wlm23xaZdM7S4MUDQ6Pxz5YkeTwkPNAmQEWDnwFTRgg2tkt+uLmT3rXKmJ8fDAfJ5UT97UuXUkTITIoToFQb6rKlPOe1wMnjirMzzquPO00to0UzFCYOIfvUmvPw0K70lj+7XNP6j2ywAJdDtg1mHFdx+itaoxd3e8PJD2CQtdgX8ZYe/vuAAfYKAHGTur36JaYlO2YmN8yw5Pl7wVVqKUVLoC0hnxhTJM5GNdkbe6df1QX1kFs7qIOHK7CQE51sv1shKBDSN1mGp2iGJ9KsAE7tn7VziL0W9rD8ePF1dwB1iqc8oNrijBG561GxWLwRVBCR3MVZ+QKFu8/MU4815AODa8krGTBZL29z0eyfVAYDnDZ95myiW28uzYDIn0PmEUZi6BZQkB+dKR6k15IAtr/azTqRufMIVhJJib205FM7m2c/x5ztxvafGH9JIm7yuOsPjbAZJ0dT18J6UbA2wG6wPcrcyWL9t5VVSZ4UL74Nr+gu9wBcNLKXdpQuPgm7NAzisU+2TP7SaBqc6zKAutgaBS2
 mMbrMfUQ
 llo1gUMsIOguimQ4ooeLPoMz23h5Bgi/2cpHcAvdPdux5Nu6ZDcqysUiLiFIHrvT/QY8JLYh4GNIz8RhT4jUsC1MewyWbnbWoWC9dXGPyFkWS9fClBsU13UXdLMnXmGHxhvpF8gcBGBJC1CQVytwxvn7oLOlDr0YnLxqTmps5LwjpXGvp9esPGUv2EeHtIth4VLoyLpEJHesz1iHjDCBja3srx3yFdjm2ZfkhN/sQoNGsEdTQzuG85xL6Pg7eQ6atF9gQ+VpybTUzDuDGVEboMpioVSG29or5v2yI
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
 block/blk-cgroup.c | 44 +++++++++++++++++++++-----------------------
 block/blk-cgroup.h | 14 ++++++--------
 2 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1de2f2433d11..e76e9a52f95d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -177,14 +177,10 @@ static void blkg_free(struct blkcg_gq *blkg)
 
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
@@ -218,23 +214,22 @@ static void blkg_release(struct percpu_ref *ref)
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
@@ -251,19 +246,19 @@ static void blkg_async_bio_workfn(struct work_struct *work)
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
 
@@ -342,15 +337,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
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
@@ -1370,10 +1360,13 @@ static void blkcg_css_free(struct cgroup_subsys_state *css)
 		if (blkcg->cpd[i])
 			blkcg_policy[i]->cpd_free_fn(blkcg->cpd[i]);
 
 	mutex_unlock(&blkcg_pol_mutex);
 
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	WARN_ON(!bio_list_empty(&blkcg->async_bios));
+#endif
 	free_percpu(blkcg->lhead);
 	kfree(blkcg);
 }
 
 static struct cgroup_subsys_state *
@@ -1418,10 +1411,15 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 	}
 
 	spin_lock_init(&blkcg->lock);
 	refcount_set(&blkcg->online_pin, 1);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	spin_lock_init(&blkcg->async_bio_lock);
+	bio_list_init(&blkcg->async_bios);
+	INIT_WORK(&blkcg->async_bio_work, blkcg_async_bio_workfn);
+#endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&blkcg->cgwb_list);
 #endif
 	list_add_tail(&blkcg->all_blkcgs_node, &all_blkcgs);
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 3d113f6f6d25..efef0967d39e 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -74,18 +74,11 @@ struct blkcg_gq {
 
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
@@ -110,10 +103,15 @@ struct blkcg {
 	/*
 	 * List of updated percpu blkg_iostat_set's since the last flush.
 	 */
 	struct llist_head __percpu	*lhead;
 
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	spinlock_t			async_bio_lock; /* protects async_bios */
+	struct bio_list			async_bios;
+	struct work_struct		async_bio_work;
+#endif
 #ifdef CONFIG_BLK_CGROUP_FC_APPID
 	char                            fc_app_id[FC_APPID_LEN];
 #endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head		cgwb_list;
-- 
2.51.0


