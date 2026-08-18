Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE2F0C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7306B014D; Tue, 18 Aug 2026 03:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACEFD6B0152; Tue, 18 Aug 2026 03:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6056B0154; Tue, 18 Aug 2026 03:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 794726B014D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:08:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1D18C0B50
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:08:22 +0000 (UTC)
X-FDA: 85113511644.28.B44E1F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 663892000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:08:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSCMDPJG;
	spf=pass (imf13.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787036901;
	b=hlfa2RiiCNmSae3SPL2eggyyph0PULeYuiYZea5hMLxZyOZyaz7+xrGLsAU0SpLXVT0D9p
	e9Vc3dQXdy8CSMBBOUfA2ljAu9rVHyT7NpChKZ9i6KkNU8rrJRj505ccrwDP9JQFKFhYGZ
	hYi7J8KhnU9pg9BI1ubS6LTVpbOay8c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSCMDPJG;
	spf=pass (imf13.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787036901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJWwT1pxPD5QyI83sGp5gqWWT9hcHXQl/xlvBToC+M4=;
	b=fOQuaxvxqA4pQEC8Bbrrr7e8OQvGUQvycIvhNdDu6ISkRjEFb7WdUhbSkwHteyZYe5SeFj
	gPRCHlNDJ0c8E1weNCH/xhjFGGUXfz0c3nA3yE1iU8J0MqCpiLPMjQPUPoWXZoDAn+JQIj
	PE3kRtW98Bdu8fWyxFhdNWqHBzMD6OA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECA53601E9;
	Tue, 18 Aug 2026 07:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290911F00A3A;
	Tue, 18 Aug 2026 07:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787036900;
	bh=OJWwT1pxPD5QyI83sGp5gqWWT9hcHXQl/xlvBToC+M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSCMDPJGbrCHu+5p6+1Yq0H+yk9h9W6iFybV4rFgnQno9h0F2tkL1xxTRCOXsbyhA
	 fmyoBJQ/wWZDqrPaETcNPFbv1CNmX37EZoacfK5lSakac/i8jTsEQZ15jrp/Xz47l4
	 +ZlnWVQXnvyZH4Ytw+IJ3fsSHWNHnO0jdKdmuX53p92tR31iYhHk1W4pjOM/k0yqxc
	 6pmXx2dHtP5SPJHztg1sHsZ2/2n1tSe9hIv+SideG6NRMZZO7pxiuv+tjwnBCqN/a3
	 hYuRdhESoKBVH/etd/f7NfjXfj5tasjwDwoCy3u6UfraO+20hK+wae63kB59llewbG
	 MOrvBAW2eCEQg==
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
Subject: [RFC PATCH v3 3/3] blk-cgroup: move async bio punt state to blkcg
Date: Tue, 18 Aug 2026 15:06:41 +0800
Message-ID: <20260818070641.756747-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260818070641.756747-1-yukuai@kernel.org>
References: <20260818070641.756747-1-yukuai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 663892000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: c7jtq68fgjea3iqkgcax4ycpihdit4ii
X-HE-Tag: 1787036901-232459
X-HE-Meta: U2FsdGVkX18hGiBtmCU5j4khhufSFLDf+piAHWqvD+trHJrhhsNM0G7rEBx6NRPmB3vjHbNzTE3JFT6GxhpTvfkaeAMIgJrX8skr/dGwMYe80qednRMpwE7kqb6Nyz0y46Lj++zaCo2fwDCqMexFFFGW5D2kXedeX7QJxUNXRqn74JKFoVONz+9IEsbh954U1VX7d1GBI0FwV4QfwRwekwTGp3bSC2IllxmFTJ2x06qmtiAy85jNAyAca8RmPCs5IwV/LnIhzoLzaCmWruWo9hTlVQLAa29GqNbntqy8/zo4tegHrSRN5nbmlBxnTxF9gKPK4zfbjweq/N3DUSFwVHk74T/svWzl1wOY6D9QfTyRq/8PGZfkOPY1454jt32qMOlzLs3k5OSMfjWIPMfIdm5nzu+0QzPDsPl0pK/N16R6MFzAp0ABxnpa6RTHK0YrUmM7viC5Wm/YC4kydHmCSsZVezwVRT3di8DDGlrRxqsHq0UA62rSLRUKgY7qBs+idTFTNebLGB/7HoRQcgFnkYTM5OBfOPKs37scrcURkthnSccDW0pUDbm9e5KkH5TyZUroDIGBsxS3QNrRAwc3sFRMoqyxZnchZw+FJN7zLOOLrLAHFaSnZ4NHhVx0cGNj52/sE0Ge1VVDYkvSqiHe143IM8WeeDH3AsTN/mM87RdllqqoVvluxE8hpp3Qb74Tf+ZMP0Q0/Fiyp4d5E4GsJsa3zCXsGOWxt6yTyznTudQtW+f5Fpucb2E3DpE81T+aGcDAC3HzkQeOp46O46AMyO5+1fkptx9p0HXEhvOWPankCvw5VOZw+hJioa7dyJLxOuaiZFaxFK6Ezfv0o5idmtppq6tu2kBcNttOJA21wr0xhVGNkoCeZ6QXpCAOUbhLOrlfJSd8nh4FiwimmKNrdci9jCCCQj23Z2aGA1Q5QaLtQtNsOtAVGUgKGUcftn/lsQfXpe0wk9pveMxKjzS
 zeiNgK2k
 4I5tu4ni32u/u9NLvZvX2xD0kE3ru13o4aoQwGqQhD1oojG5BpdC5rqKuk8d1OJu1JtWWZKuSGCRd3attHJjdf+CpJYoho11Q+14Of09OW0S0B0LhwbE0IWT7YBM85G0qyfo/X+rS6QJ81exlYfR+OqCn+F0ShJwr/yA2hFz2fxn4CBSRFVVyq85o3J4c7vD9toyTRdRhEdgmcwK8pnhUbR1Dh3R4VDNJEJsheTE4/hzrxrzgCbvkP6+xyZX8HhUQK4pI6NQ9e5ktG4lHEsnjcYdLr1EKN15p6sUHyRnYVN6zfIgqvCs8QCJedykF8T68bImuUYBMUh8IEW6hfgGCCw/PdE8AwW4Ao7zHrUef1kuzgQjcqkq6H38813qktEsUHDKrrHwhjJvPNidCEhB86DhOvg==
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
index c3bbcb3e7e58..2c758c26bce6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -178,14 +178,10 @@ static void blkg_free(struct blkcg_gq *blkg)
 
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
@@ -224,23 +220,22 @@ static void blkg_release(struct percpu_ref *ref)
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
@@ -257,19 +252,19 @@ static void blkg_async_bio_workfn(struct work_struct *work)
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
 
@@ -348,15 +343,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
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
index 936428b6127e..eb76cc38b41b 100644
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


