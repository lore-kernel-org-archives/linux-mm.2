Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE78C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 13:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D20236B00A0; Sun, 23 Aug 2026 09:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0E56B00A1; Sun, 23 Aug 2026 09:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC18C6B00A2; Sun, 23 Aug 2026 09:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3CE6B00A0
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 09:32:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34494120291
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 13:32:53 +0000 (UTC)
X-FDA: 85132624626.26.BCAB4A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7FB97C0004
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 13:32:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BKuh8fCa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787491971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KYwjYDmJgv3DnzDOpRmS3OQgAUfeEON5RSUmmX7LeU=;
	b=VHGAsbVApzuLpsba2BGAL4KSQktNeXHAW4bA8UxULnjmAU/ZNQ0veDAo4YGKtIBFM0L+vG
	W/KHyGGp/WXx48eRMkOg1H/bqCBJ/JIndDK70sNESG1Q7akGn8g1NMCVdeEEvvFCO72v2H
	X1WoZ6lJrvBGLv1oqwtzu4qAi4GfCu0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BKuh8fCa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787491971;
	b=g03ogJmvNo8e+N0FXIMawoX+E7UbssRzRvg7LN1tmHG3gqCX4WLPNdhcdHydE1T26SZcqD
	ttSJGGbv+8d+JArsZfHCfzKjpPcH1BxKXPCfbZw7o4V6b18hp9THBFjDoJjEfTZLJVVTYC
	h/3OBW/vG8qyvvpLB+xps5mVDu9gOF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA18041B2E;
	Sun, 23 Aug 2026 13:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76171F000E9;
	Sun, 23 Aug 2026 13:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787491970;
	bh=8KYwjYDmJgv3DnzDOpRmS3OQgAUfeEON5RSUmmX7LeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKuh8fCaInrcFBcT9JPPeKYinLYc2/Ia8kito9c/k0yLMh5AhnPIFZ8GENBhUoLAR
	 nVavT+qzK13I5dM4nIDPuwNy7K/X5Q47M9zNUaap/0IMn4B/NAqh6y87WoDfihWTt4
	 G4+jZPoNfLVWWvHeKZYmPFyY9mSz1v+4dswZns26zYXfIssVpHrLauPKJh3zDA3j3a
	 a7zZ6NlpV/raMgv0PGK6tkXI8qCx5Mf4Rukx/POzB8lcSM1xIyhimElgsM+1iwPA/7
	 P6+idTUXgWpua3+INzz/HMMc6QJzmpdO0g0gUFonMEPJytHLedsGkCDMwvT46VMrn5
	 O9zVPjthG2MdA==
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
Subject: [PATCH 3/3] blk-cgroup: move async bio punt state to blkcg
Date: Sun, 23 Aug 2026 21:30:45 +0800
Message-ID: <20260823133045.970199-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260823133045.970199-1-yukuai@kernel.org>
References: <20260823133045.970199-1-yukuai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 669r3grgug5hedkw68toqtyrm1qtcg79
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7FB97C0004
X-HE-Tag: 1787491971-389855
X-HE-Meta: U2FsdGVkX18VC4OM1heEX7Qhu7SQWuy+39LD0PtbvDVBueKy6svUyrltKexmbEhf4FEq2wl9LoiaGW+VIFDfzEoG4BjbD7nxVDPVB9dpCDzeY843B5gQ49LNhzTQeGZlI+OiHW5VdiUVqa5G8oSn0aJK/cuaUt/J7DotjTKkJacvPUQAY6LqRhhdQ9f/eMpt2fIhEl/dDUv37LilH6F/vwREk1HC0/KBSEpEvgfefbg/Mie9mQPU/2VCSJJeB7QgYrWUzigifGxzlELtRHLZ6QUU+5GFh2qm/uCkOZACnuoWcYFfDqvetvMmP7LLC0V62Cz7aMQyviCAR8KNF3Ky9pi77lcyblbIDglKaGGn7INYajbz3Osam3vvSBfk483h1JIZDHgtY16EGfK4zJd6W8aoQ5vErUMH8j3HX2q/pzJS5j9T+4trlbanlMxgSqb0e3NnhDjw/oNP4sroniPvris6R86Do+iHHtNCaZUztq0ftu0whwCrFbdUeYYfgUdQXmvE0a2tLGOq+b5NujcqMOaeJmmWEToaxNFgRu7IGAB99hiSnN6EAh9F+UCt/I0VT8LtfhIE0VqYpubBsrHVQlebmdOtvfSJk1ut5FqbTDa+FNEEFMHhxk84OmaGtWBbYZ1bQFnAGET893FNCCLqIo9L+DH8qoKi/IZ4TyTY7JJG9ze6RIWsK9TQairz5L+f79YCOJt3FPRYPKn3YWZehPFFFmOah+rPI+ukNTzNDzpgtpyFj512267FcTW8X+jHcxrALV/uJjwJ80Cgisgr+50CTTJx0WDQ2Vbet+6uLb6wehLj1cvqQF0dyCL8MUBFo1dqqie67jeXSZizubwn0LDXz0Av+0DNeETR7qgLB2p1Q6uPDHfUSzZqpFFiD1KKeCOw7JMqFnTSrJLpPDsbVPw2xlmr8usqxGZ7nBgdQKOdC3YcHeUeDHZobuaVNz6Iu+hAoZP6OzTX8y3h9Lh
 hazlWmUq
 RuXPkDt1pDmX+0QAto9mwcVI70+DkxHciL+myfTKquieWLYyPNRzvWmvudWzYj2GZMCEq5V0l+aT3JF73V4Buuagc9s8GTmkVd/7PPWuez4jAydZtbLSKZX9q7ZykixuSFd2sy6DdJvuwV2E+2CJoIrdUM7cfbcyg65vW2zs7FfZKWcznh+Rx06avBm3r1QYOzNoQD8295xrxBST3ym46Am93cDSo6fUBZdLdKx8ZP1q02jpBWip+PKc9/n/OwYZxvOfVzXM6bRhPMAnxw7Xk+A/dZqbM5zlEB7j6Wwh/INonacqEtPvWsDyHd+bnZwpjYNbxK3/sqbgTytoX77ij/8JYKMWGDzi5H7J1njWScsvQpgyfmqxUUCkOvBRuurAwM5bT7Lh7+6Ry9tjGiSBpceV3eg==
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
index b23f1e2d568d..1bd91223367c 100644
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
@@ -1388,10 +1378,13 @@ static void blkcg_css_free(struct cgroup_subsys_state *css)
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
@@ -1436,10 +1429,15 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
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
index 8d0df8ed5813..1925420154c1 100644
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


