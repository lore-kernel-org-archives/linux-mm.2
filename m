Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5693CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8886B0099; Sun,  7 Jun 2026 23:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9FB6B009B; Sun,  7 Jun 2026 23:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF116B009D; Sun,  7 Jun 2026 23:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1798F6B0099
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:43:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8E289241A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:12 +0000 (UTC)
X-FDA: 84855349824.07.7083668
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 220F380008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGykHSqt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780890191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Boc58LQ8eways719MPbdaMHI7qUS76tyUmczFyDCIns=;
	b=EO0ZhKv77sQ279kY2za7/zsOVRHyiV80k5tgmAz0u2XE/Vjmo+rwUK7YPPeY1OAlyZDvf1
	1WrTyF/C/HhpaBR0hhc7XufDti5ST22/eED+eKNxogRdnXSyGBsueed8FsAxSAV1Uo2UlH
	PYe+o9cf0Jojhw41s2K4/A10fGA6gtQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BGykHSqt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780890191;
	b=3BBJ67RJFn9QAWUPX59VMoIAhQvKseB9lcNcc24K6Zty/nnU3Mjo9BQvfOLUlZIAVCyWsm
	PH/T4uiGU0sS2c0NpRfhogdTgXTShbcD0kLSEwe//AUt+X26JNDtdQndcHmpR28XjfOHwt
	ohi5/D12Zqqa2tdk4j0aaI55lfQOwQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7D316001D;
	Mon,  8 Jun 2026 03:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF0C1F00893;
	Mon,  8 Jun 2026 03:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890190;
	bh=Boc58LQ8eways719MPbdaMHI7qUS76tyUmczFyDCIns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGykHSqt6dcfNwZflW5GcYVWGTiKqD1A/i3JQJExaYJ2SKcKI6C9rkv81jJjuZf1x
	 gEcvN2f0iyk2SeyNnKus8r/dD7dZMjmA4kqN7hz3diXu3aA5ZLe9ATXPCGChp76SZV
	 e3F7LUMbCCy9+qcJyc5EZe+0sFyfNIME2oPXWm4O1H1lyIQTzEcW6IsLYGGpjVqnFt
	 3BtBYulFD/DoKo3JKb5JbKjcaSuy4y0TteaHXo96iVNlmf2n8P5GL/aUaQ+hRbMncz
	 9bQyEx7P4o7XTs1dPVSTmp78zNVuoRfeks8KXVO6qhXfvD2qDAO2In/6x+9O9hYBa0
	 HLfCIHUPPsiTg==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] blk-cgroup: don't nest queue_lock under rcu in blkcg_print_blkgs()
Date: Mon,  8 Jun 2026 11:42:44 +0800
Message-ID: <db7633d5e263dd1c2bf9b901762545a84b7d714e.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 220F380008
X-Stat-Signature: hs3saxyoyktnz16bggipq5eqmcojq8aj
X-Rspam-User: 
X-HE-Tag: 1780890190-33065
X-HE-Meta: U2FsdGVkX192AveEtLU/KV4u7/HySG4AW9UvBTXH9heBZUXLTpz3YYUQMSzGmnwxKxUojCQhJwlZ8vkwjrBKjLZGPFGR3X8h4lM0EI1H5UbwB4PmWDqjALEoJprl2JR4eA8xFUfiPZuFwRWCYAMl5bHu78Sn0jkUhmxjFqfTxexLt7PiFrU4vNUfVRGGIU+nw1/4YyLrtS0FbP0mImZqoGaSh/M7Vo8v+IjDyHX0yR9VflpoGEPp+mNpgeG5NPoWvj3CkVYvnrVMve0N0kZnS9IpVnFxzo2wY9qnn3w0RcQWus6o9heiV9YdxSGMUU92MudHu9f7gyQ+FeOCBUWKfpugyS3SdyPIfaxGB47qetMpo4GAsPBkW5YodiwILxqGjajkfhnidFPWfAndgZIkxF/lSu5nqbg/J6BCK1hpLLUw8QsvpND6p7XV9Kr5gMSkbP6gebjwkWBZVvTd5lpXe5eU8okfTM/jVSfcfrtKlKWS8S4F7Y1W0D5fj1EDDtxeUNB6qdUceYqR0FhS8MbeZ0mr4UMjGtnVk7kMwcwjaOmU4500619BdfvLxfOwpEjfvxoPcTBWD0S6TBy7p93HossiKKs4zX7gDHM4GvdO94u4pCWC8WQZE3/9TZg86p4oGI2NImJMf4TEK9JJS3LpK0BvCZ752fEBcyUjfcyXb+aK+ILp3By+Kyv4YD6NLErvUeU3+mtwReVoz6YWvkF2B9dWfDBIFPS4vYkVPCHhHEwW+Qcl+GLeB93Nit6ouUQuPcLOuKNSwNw5L37iPC1ujN/EyZrZiedWjIAX3UXydWIct6gPVi1TYk1+oEVadYLexOj5PudHBmywC6X3BTZ/A/Z7HeklI+t5pcEDkPb9c2RCxThTHRjjupcJPG+wDmlVDroU06TvA/MbQViHWVxHCMyJRhcFmQhJg8rNO9tXoFxV9YG21aF1boNn2qyTD7VnUA5ufwxoFfjAIMipOFf
 9EJ2hoeI
 nGXeczBYAYCpjwArNEU4UMYRftJHQBNFX6/WiYX/KSXDsAspFguIvEUaN9JmoOaFo1xQB9yDBGdu0SK7id/SGjbR5kE9i4t1KZB9e6pkLOYfAM7mlRgXVqk7pMT5b9jvTWJytIeMrLtX55H3NrxpNqeVPAhmSZBEBb8XewceGWPRn1b0qlG2jEGBkPrlUpd7TPLYCn1qF8jindxQF5xfAa3oNHxyLMJf+th2CqAIH9ytuAdhKzen1KN4gUGiLHfDJWgghvd9Ap37ZuFv+pAMyX/aijbYatEOFTQ21
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

With previous modification to delay freeing policy data after an RCU grace
period, prfill() can run under RCU instead of taking queue_lock. However,
policy teardown can still clear blkg->pd[plid] after blkcg_print_blkgs()
observes the policy enabled bit.

Load policy data once with READ_ONCE() and skip the blkg if teardown
already cleared it. Do the same in recursive stat walks for descendant
blkgs. Remove the stale BFQ debug queue_lock assertion because
blkcg_print_blkgs() no longer calls prfill() with queue_lock held. This
also lets ioc_qos_prfill() and ioc_cost_model_prfill() use IRQ-safe
ioc->lock locking without re-enabling IRQs while queue_lock is still held.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/bfq-cgroup.c        |  8 +++++---
 block/blk-cgroup-rwstat.c | 15 +++++++++------
 block/blk-cgroup.c        | 22 +++++++++++++---------
 block/blk-cgroup.h        |  6 +++---
 block/blk-iocost.c        |  8 ++++----
 5 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 56f60e36c799..904d9e0d9029 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -1146,20 +1146,22 @@ static u64 bfqg_prfill_stat_recursive(struct seq_file *sf,
 	struct blkcg_gq *blkg = pd_to_blkg(pd);
 	struct blkcg_gq *pos_blkg;
 	struct cgroup_subsys_state *pos_css;
 	u64 sum = 0;
 
-	lockdep_assert_held(&blkg->q->queue_lock);
-
 	rcu_read_lock();
 	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
+		struct blkg_policy_data *pd;
 		struct bfq_stat *stat;
 
 		if (!pos_blkg->online)
 			continue;
 
-		stat = (void *)blkg_to_pd(pos_blkg, &blkcg_policy_bfq) + off;
+		pd = blkg_to_pd(pos_blkg, &blkcg_policy_bfq);
+		if (!pd)
+			continue;
+		stat = (void *)pd + off;
 		sum += bfq_stat_read(stat) + atomic64_read(&stat->aux_cnt);
 	}
 	rcu_read_unlock();
 
 	return __blkg_prfill_u64(sf, pd, sum);
diff --git a/block/blk-cgroup-rwstat.c b/block/blk-cgroup-rwstat.c
index a55fb0c53558..aae910713814 100644
--- a/block/blk-cgroup-rwstat.c
+++ b/block/blk-cgroup-rwstat.c
@@ -99,26 +99,29 @@ void blkg_rwstat_recursive_sum(struct blkcg_gq *blkg, struct blkcg_policy *pol,
 {
 	struct blkcg_gq *pos_blkg;
 	struct cgroup_subsys_state *pos_css;
 	unsigned int i;
 
-	lockdep_assert_held(&blkg->q->queue_lock);
+	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	memset(sum, 0, sizeof(*sum));
-	rcu_read_lock();
 	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
 		struct blkg_rwstat *rwstat;
 
 		if (!pos_blkg->online)
 			continue;
 
-		if (pol)
-			rwstat = (void *)blkg_to_pd(pos_blkg, pol) + off;
-		else
+		if (pol) {
+			struct blkg_policy_data *pd = blkg_to_pd(pos_blkg, pol);
+
+			if (!pd)
+				continue;
+			rwstat = (void *)pd + off;
+		} else {
 			rwstat = (void *)pos_blkg + off;
+		}
 
 		for (i = 0; i < BLKG_RWSTAT_NR; i++)
 			sum->cnt[i] += blkg_rwstat_read_counter(rwstat, i);
 	}
-	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(blkg_rwstat_recursive_sum);
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b55c43f72bcb..46fc65050c38 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -699,13 +699,13 @@ const char *blkg_dev_name(struct blkcg_gq *blkg)
  * @data: data to be passed to @prfill
  * @show_total: to print out sum of prfill return values or not
  *
  * This function invokes @prfill on each blkg of @blkcg if pd for the
  * policy specified by @pol exists.  @prfill is invoked with @sf, the
- * policy data and @data and the matching queue lock held.  If @show_total
- * is %true, the sum of the return values from @prfill is printed with
- * "Total" label at the end.
+ * policy data and @data under RCU read lock.  If @show_total is %true, the
+ * sum of the return values from @prfill is printed with "Total" label at the
+ * end.
  *
  * This is to be used to construct print functions for
  * cftype->read_seq_string method.
  */
 void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
@@ -717,14 +717,18 @@ void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
 	struct blkcg_gq *blkg;
 	u64 total = 0;
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
-		spin_lock_irq(&blkg->q->queue_lock);
-		if (blkcg_policy_enabled(blkg->q, pol))
-			total += prfill(sf, blkg->pd[pol->plid], data);
-		spin_unlock_irq(&blkg->q->queue_lock);
+		struct blkg_policy_data *pd;
+
+		if (!blkcg_policy_enabled(blkg->q, pol))
+			continue;
+
+		pd = blkg_to_pd(blkg, pol);
+		if (pd)
+			total += prfill(sf, pd, data);
 	}
 	rcu_read_unlock();
 
 	if (show_total)
 		seq_printf(sf, "Total %llu\n", (unsigned long long)total);
@@ -1591,11 +1595,11 @@ static void blkcg_policy_teardown_pds(struct request_queue *q,
 		if (pd) {
 			if (pd->online && pol->pd_offline_fn)
 				pol->pd_offline_fn(pd);
 			pd->online = false;
 			pol->pd_free_fn(pd);
-			blkg->pd[pol->plid] = NULL;
+			WRITE_ONCE(blkg->pd[pol->plid], NULL);
 		}
 		spin_unlock(&blkcg->lock);
 	}
 }
 
@@ -1683,11 +1687,11 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 		spin_lock(&blkg->blkcg->lock);
 
 		pd->blkg = blkg;
 		pd->plid = pol->plid;
-		blkg->pd[pol->plid] = pd;
+		WRITE_ONCE(blkg->pd[pol->plid], pd);
 
 		if (pol->pd_init_fn)
 			pol->pd_init_fn(pd);
 
 		if (pol->pd_online_fn)
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index fd206d1fa3c9..5402b4ff6f3f 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -279,13 +279,13 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
  * @pol: policy of interest
  *
  * Return pointer to private data associated with the @blkg-@pol pair.
  */
 static inline struct blkg_policy_data *blkg_to_pd(struct blkcg_gq *blkg,
-						  struct blkcg_policy *pol)
+						  const struct blkcg_policy *pol)
 {
-	return blkg ? blkg->pd[pol->plid] : NULL;
+	return blkg ? READ_ONCE(blkg->pd[pol->plid]) : NULL;
 }
 
 static inline struct blkcg_policy_data *blkcg_to_cpd(struct blkcg *blkcg,
 						     struct blkcg_policy *pol)
 {
@@ -488,11 +488,11 @@ static inline int blkcg_activate_policy(struct gendisk *disk,
 					const struct blkcg_policy *pol) { return 0; }
 static inline void blkcg_deactivate_policy(struct gendisk *disk,
 					   const struct blkcg_policy *pol) { }
 
 static inline struct blkg_policy_data *blkg_to_pd(struct blkcg_gq *blkg,
-						  struct blkcg_policy *pol) { return NULL; }
+						  const struct blkcg_policy *pol) { return NULL; }
 static inline struct blkcg_gq *pd_to_blkg(struct blkg_policy_data *pd) { return NULL; }
 static inline void blkg_get(struct blkcg_gq *blkg) { }
 static inline void blkg_put(struct blkcg_gq *blkg) { }
 static inline void blk_cgroup_bio_start(struct bio *bio) { }
 static inline bool blk_cgroup_mergeable(struct request *rq, struct bio *bio) { return true; }
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index c136b1f46fcc..1f3f6e0f8901 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3188,11 +3188,11 @@ static u64 ioc_qos_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
 	struct ioc *ioc = pd_to_iocg(pd)->ioc;
 
 	if (!dname)
 		return 0;
 
-	spin_lock(&ioc->lock);
+	spin_lock_irq(&ioc->lock);
 	seq_printf(sf, "%s enable=%d ctrl=%s rpct=%u.%02u rlat=%u wpct=%u.%02u wlat=%u min=%u.%02u max=%u.%02u\n",
 		   dname, ioc->enabled, ioc->user_qos_params ? "user" : "auto",
 		   ioc->params.qos[QOS_RPPM] / 10000,
 		   ioc->params.qos[QOS_RPPM] % 10000 / 100,
 		   ioc->params.qos[QOS_RLAT],
@@ -3201,11 +3201,11 @@ static u64 ioc_qos_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
 		   ioc->params.qos[QOS_WLAT],
 		   ioc->params.qos[QOS_MIN] / 10000,
 		   ioc->params.qos[QOS_MIN] % 10000 / 100,
 		   ioc->params.qos[QOS_MAX] / 10000,
 		   ioc->params.qos[QOS_MAX] % 10000 / 100);
-	spin_unlock(&ioc->lock);
+	spin_unlock_irq(&ioc->lock);
 	return 0;
 }
 
 static int ioc_qos_show(struct seq_file *sf, void *v)
 {
@@ -3386,18 +3386,18 @@ static u64 ioc_cost_model_prfill(struct seq_file *sf,
 	u64 *u = ioc->params.i_lcoefs;
 
 	if (!dname)
 		return 0;
 
-	spin_lock(&ioc->lock);
+	spin_lock_irq(&ioc->lock);
 	seq_printf(sf, "%s ctrl=%s model=linear "
 		   "rbps=%llu rseqiops=%llu rrandiops=%llu "
 		   "wbps=%llu wseqiops=%llu wrandiops=%llu\n",
 		   dname, ioc->user_cost_model ? "user" : "auto",
 		   u[I_LCOEF_RBPS], u[I_LCOEF_RSEQIOPS], u[I_LCOEF_RRANDIOPS],
 		   u[I_LCOEF_WBPS], u[I_LCOEF_WSEQIOPS], u[I_LCOEF_WRANDIOPS]);
-	spin_unlock(&ioc->lock);
+	spin_unlock_irq(&ioc->lock);
 	return 0;
 }
 
 static int ioc_cost_model_show(struct seq_file *sf, void *v)
 {
-- 
2.51.0


