Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89FAC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 06:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D215A6B0093; Sun, 13 Sep 2026 02:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8AC6B0095; Sun, 13 Sep 2026 02:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C106E6B0096; Sun, 13 Sep 2026 02:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1EAD6B0093
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 02:55:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0905C048E
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:55:34 +0000 (UTC)
X-FDA: 85207828188.24.40F4FE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3117140003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:55:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1GYpsNA;
	spf=pass (imf17.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789282533;
	b=IHWjDV5x6dS1Bz+IOLC/tBNG3rxzRV1X1pQkdP4BdbHO5Ku+0KkXmlDt+EYfK95F2fCAOa
	NRxvoTgD+rmbISW14BWdJJpRjzGud+d3ELTHiLKenOK2I+WWuhKtoAz9swPLcxjBysVT3J
	mpDHgM/2rdQ4CkNDOdDWUgnpG9NnBJ4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1GYpsNA;
	spf=pass (imf17.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789282533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wT6gN/IxgPOdTmMhpo1rniCpWE+wufTMXpH4Yd2onlI=;
	b=7Rc/p6OXX14EsD80tkvSzPC3+gerkiuWTa4H9NFog0TYtgMzmHwyaBApGmYqp7oGOwZnkm
	xQw57B4/SAl1bG9yJ0l+SpF+C8+Z6/4eOB11U6INCDYFdrTMHUm8H7sGsjsvv+LzHRdJyR
	dn2lCsqxlRrATTMkSVKAoF8SfeBzvlE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBF7B60D87;
	Sun, 13 Sep 2026 06:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313601F00893;
	Sun, 13 Sep 2026 06:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789282532;
	bh=wT6gN/IxgPOdTmMhpo1rniCpWE+wufTMXpH4Yd2onlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1GYpsNAcUx0FM53lU9XD7zterbc/p52NIZV+fMTVTYJ6erepuX41g85L5n7PvkJJ
	 8DyqyQIpmcHLylqfO6XWSo0DEA74+IpDKPoFtNYUtRB2pWX32grlDMgBXojD3u4IRA
	 gRyjRQo1pb8uRFp4YpNOf1t41jIGgXTqlRrEqjT/OXqf1ggIqCgLWhKi941OwoGx35
	 DFO0DSBsqJJL6qE9ZmvHNqdpd4Jp5KJ0wFJRbWNE0xbxnJ861QQSROnV/Z28ij51aB
	 FNQN15OXDwCd1LRcPVcXgP3w52Grw6b/cwXBW5KAkci5pkWdZe4ltunpTvsVf82b6P
	 11r3CWL8qVYeQ==
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
Subject: [PATCH v2 3/3] blk-cgroup: move async bio punt state to blkcg
Date: Sun, 13 Sep 2026 14:54:40 +0800
Message-ID: <326e4904402440323532168095f2eb0c6f697836.1789237877.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1789237876.git.yukuai@fygo.io>
References: <cover.1789237876.git.yukuai@fygo.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3117140003
X-Stat-Signature: 5g3j5k64xqbz3dgua55ncb9kcwug7p7c
X-HE-Tag: 1789282533-846304
X-HE-Meta: U2FsdGVkX19JoQuPJ/314iKZhiX2oejsp2W4BOVpCCC22NlD/QNGZRnDVTq3deu+KLsVX7+a9nar9bcJtfsjUCDOu3W4J0l2tGcbW+oenwVFVmwFQNQ3RWsMTdUdJ0G86I0k+yP3UoCUaqyyJDeabZj/9VcdWCOqUleYIoEDUuEsLONs1uxQQhyR8BAdenM/CXO5JeAvXpFglPOFulxd/1SghZrHTX/LC8LZtHJYffdrFL/nrTkCgF3+Ack8gTdLElPt2XMzd9NEPbYJuCMUgJwokMQg10N85JP5pza+uJCb8Xgeo2TP1NpFfndly0ckTm7PhUZ0JIoaKE61BI3X+yeJqo/mpGxi7O5mu7g5ol7oelaMFpzlA20mfF/U895hMERio2mHC0hPCcCKnGHgQYr9ZfoOfY6O/I4y0Iat7wFHzTdGgfxt/dXRqSa1xuLCspkQq4PQf2Yq4kr2XE+ThUvQrnvsEczBRZ5RmoF1z4KgJi5ByNgg0jJXN+X1J3Gjy3f464/8ggwaaHUuxhdCvoIjoEskzjIZlN2NE/W3IpmjWYY18KziBDSydv4rOFVVRrEsef87QTL/XF19HiJo9c/WRLRwoCZ2wh8MkFD+xKlEV0sh98PLLwXLPm9TUgLmHhz2iyNX7n1VXPQR62vgMFd2Rgem6OuRAGoC4RfFI4TVsviCxTPs3E5LEI0T/TSBwTqobNGdWaXjkxmS8s7cLkHRYfPnxjPN/LPG/Ac0OQoz9LUHN0t5gNuDcDolpX3Q0DqpOa+IMVqJkEgT1qh9ZolMhYHCpYxl4nigKVve9ewZsDP61//94bzucdrU6cx1bB92FFcPZgzd3P3WbIgDLqqRuzbJsxNwO2Q9/p79CGrLlHmfGBZmJkhv8eGn0zymnTrGf2rqGeDABTEwEL3z264UrOR4MtD02JmNA6BKlK5W3IGnQSxUfd7noiTs/KTc/JR5scORyGYPadzAwVj
 dYdrFHHO
 IVhZAfssg9IYw7rjvQef2yFWRnMQcbuDIbXYFjvG05CTJHmWUJRBBluULfZHwEDbFKxVkzgavVupwhDSP5vSR58cdLRvvqZPSLhL2UiqN+sT3Wl7SHYd3uNtyW2+l4AR/a7+8/ZlyOqid4SDK35kWhyitVZm+tgZnO/PA2BcWMbuKWTc=
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
 block/blk-cgroup.c | 52 ++++++++++++++++++++++++++--------------------
 block/blk-cgroup.h | 14 ++++++-------
 2 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 59ccfefe16a8..aa3cee107ebe 100644
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
@@ -226,23 +222,23 @@ static void blkg_release(struct percpu_ref *ref)
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
+	{
+		guard(spinlock)(&blkcg->async_bio_lock);
+		bio_list_merge_init(&bios, &blkcg->async_bios);
+	}
 
 	/* start plug only when bio_list contains at least 2 bios */
 	if (bios.head && bios.head->bi_next) {
 		need_plug = true;
 		blk_start_plug(&plug);
@@ -259,19 +255,20 @@ static void blkg_async_bio_workfn(struct work_struct *work)
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
+		{
+			guard(spinlock)(&blkcg->async_bio_lock);
+			bio_list_add(&blkcg->async_bios, bio);
+		}
+		queue_work(blkcg_punt_bio_wq, &blkcg->async_bio_work);
 	} else {
-		/* Never bounce if there is no non-root blkg to queue on. */
+		/* Never bounce if there is no non-root blkcg to queue on. */
 		submit_bio(bio);
 	}
 }
 EXPORT_SYMBOL_GPL(blkcg_punt_bio_submit);
 
@@ -350,15 +347,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
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
@@ -1399,10 +1391,16 @@ static void blkcg_css_free(struct cgroup_subsys_state *css)
 		if (blkcg->cpd[i])
 			blkcg_policy[i]->cpd_free_fn(blkcg->cpd[i]);
 
 	mutex_unlock(&blkcg_pol_mutex);
 
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	{
+		guard(spinlock)(&blkcg->async_bio_lock);
+		WARN_ON(!bio_list_empty(&blkcg->async_bios));
+	}
+#endif
 	free_percpu(blkcg->lhead);
 	kfree(blkcg);
 }
 
 static struct cgroup_subsys_state *
@@ -1447,10 +1445,18 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 	}
 
 	spin_lock_init(&blkcg->lock);
 	refcount_set(&blkcg->online_pin, 1);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
+#ifdef CONFIG_BLK_CGROUP_PUNT_BIO
+	spin_lock_init(&blkcg->async_bio_lock);
+	{
+		guard(spinlock)(&blkcg->async_bio_lock);
+		bio_list_init(&blkcg->async_bios);
+	}
+	INIT_WORK(&blkcg->async_bio_work, blkcg_async_bio_workfn);
+#endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&blkcg->cgwb_list);
 #endif
 	list_add_tail(&blkcg->all_blkcgs_node, &all_blkcgs);
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index f68ea21958f5..7d73085503d5 100644
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


