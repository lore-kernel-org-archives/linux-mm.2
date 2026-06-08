Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B55CCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1396B0096; Sun,  7 Jun 2026 23:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71C56B0098; Sun,  7 Jun 2026 23:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60836B0099; Sun,  7 Jun 2026 23:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9442B6B0096
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:43:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E7AA12014D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:08 +0000 (UTC)
X-FDA: 84855349656.06.B4FA463
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 648A2140007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLcEnJ6r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780890186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hTBs93fx+NbCSeVyVNxz5n85uGxtYn/Sbx45vo9Kgc=;
	b=gDCfsloCHT3HhnytTbNZ3fnZVLuxjxgEVIsfgpnDcD42xDSd+wOZi76pq1cMAZARTtKVzP
	i1dq96sKj/Pj3AGvHmyylLfA7IJ40BQNFVBh0DT3VuwTAthifV3S8Dhci07mgKzxAupg6H
	frHunAaO9l+IX1JFefeVI6dPU77/L74=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLcEnJ6r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780890186;
	b=URA2rbklGx7VE/oLaCCErZkCg4eDCVPdDyfXdLT0L8dzzyXWLQyKcGC9f76j2XGIDnsnLI
	syZw41/Q0JAsCvsEoHG2BOtGUw9kbGJmzDFB0b7f5Fejld0nA1UV9PpJX8tU5rQf9Q8fkQ
	DX/2ZtG/wcSvzM8CpE5gHbTHbi5ZOtA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F25D8601E8;
	Mon,  8 Jun 2026 03:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EE71F00899;
	Mon,  8 Jun 2026 03:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890185;
	bh=1hTBs93fx+NbCSeVyVNxz5n85uGxtYn/Sbx45vo9Kgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLcEnJ6rbEwe6kb0bDhr5znxOm3FiQdH0IHu3VNVC3u4JtQExIVMbN5gDnLN6+88y
	 TbAKMqqoFHpPmdkivLGrmrSFciAXauyxsUswFMrtauGKTSqTrianUeyRrjDFnIBrFg
	 LkT6tXcA+d1jXzBX7cZxzrvjeuoeN62S6mORmgUJxS2Vga5BpxNle0wQ28pmjISLRM
	 rrGPSkZqDtesR5xfyQvmIqcbV991IafyL9bXzRCUE3ahdQfNm+JaJQJy/iqn7c5HTD
	 rOFEl887SMJDZhkIDG+0IN/DoXFJQJ27ZzYLr1dmDgMLuOvxii2EJWT+Wi3H30HqQ7
	 o6LnuxYqWR5pQ==
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
Subject: [PATCH 2/8] blk-cgroup: delay freeing policy data after rcu grace period
Date: Mon,  8 Jun 2026 11:42:43 +0800
Message-ID: <e20e5d984b41a026d61851966bed35eb094c4bff.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fxyhwyaxnmp774wqy5thdycmztohok1m
X-Rspamd-Queue-Id: 648A2140007
X-HE-Tag: 1780890186-289760
X-HE-Meta: U2FsdGVkX18DtdbyJ3ktEoBowHF05N0VuGmFDj6Vr7wjBPstKJFVs7VM8cQMNPyT6JXvxRNo4v2EIE4fx1a7fbw3eHdctnsDCZ6gz6TOHJqap7raFWKhNWDrhC5L3Z9LOkWm5yiSBYgPreRb963nRnDM489/Ykc0NmymuYwOJ7AyGN1+d+ElzI3eGLNFmpI72z82706exvQyyR7CCejbKJaS28kWQNo8FCKBWVfs2KO82AkrVLM7lpTY6oFkCrAhJK+PhTc4fqABJ26uzvl0N//s2fs5qFu5xEGvqh8jo55MoxmCzJVQwvFT+KIIj+Jo0g8N/Ln6LoOBV0JrJYMNTA6hs39aXVVgMeSeGr84QvOWAyv9gwSi6zEuY+Mm91CXxJdQRU2W9YENIdC0HvHZS0WCJlZaUElB9bDrTpIG8h9B4b1V2/c03Vw1SB3MbIpDiU2E5q4khFuk1kc559kuZaQHny87CE8mAu4OMW4HSY9CzNzvM/zIoQ5Es+LppjQCFuyAKHpl/MphWKIogtoy5qeEiwD31R7q4aF9PGZD1AsSdGyILF5LQHoKs20y7yD9am/wmoSI/PKVu/WoalhBSTf+PERRHSl6jNIJCQQIf3WWyPLkIoMmBC5b/bsx+cJnr4pH8m85LyJbcSV0Mp3C18G8GCeYwyGnAC41ZhagnhQEpycZ7+3euCwSPz+7hVcPoRQWt2sVcTup4CMpcIVeRr1GaCurYD+HzxpAh+Qt1ADI2lYZSsLHmtTcrdI83oL7KUF30GgjI5bsVKEN2nydBigbDlmOz4omeK5QplHTioUY8XA197scU+2B4zsT3/BY6T/Q6NvvEgbSZZqKCM35nt90XGf5gRAKvy56JXhOlxE3WHRisnRdZFKSrifkOnMGUv9QxAYyZ595+7v7R8psFcKnnSjrOP00OXDsibB5jsVOKFha2Ecm3E+T3s7IwLjuKzmh02OyMoS0xESNBz8
 wQYg71dM
 xFNkc82kqYa/CmTgbeb3n4sx3by7wOA97zc7q9PNzxd31mItzFRdwyCLb9KNVQPKpQAx8GVCeFzE8CneNlcLiUL/aNqa/oqFfXeZVta7znTAzfKc0MeTvDIdVSTg/4sUxpyD+onlg9flRUT3OhbQubHmXgAd0dC6xd13ixK+N1Rqj3Xjowpqyh5QWbRDhxK1JiQN0uM8WiMrXtlEsmtJgrT4oz1skTRns+2uUpTEDeF+EbjEBCjm0XjYYQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

Currently blkcg_print_blkgs() must hold RCU to iterate blkgs from a
blkcg, and prfill() must hold queue_lock to prevent policy data from
being freed by policy deactivation. As a consequence, queue_lock has to
be nested under RCU from blkcg_print_blkgs().

Delay freeing policy data until after an RCU grace period so prfill() can
be protected by RCU alone.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/bfq-cgroup.c    |  9 ++++++++-
 block/blk-cgroup.h    |  2 ++
 block/blk-iocost.c    | 14 ++++++++++++--
 block/blk-iolatency.c | 10 +++++++++-
 block/blk-throttle.c  | 13 +++++++++++--
 5 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index f765e767d36a..56f60e36c799 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -548,17 +548,24 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
 	bfqg->active_entities = 0;
 	bfqg->num_queues_with_pending_reqs = 0;
 	bfqg->rq_pos_tree = RB_ROOT;
 }
 
-static void bfq_pd_free(struct blkg_policy_data *pd)
+static void bfqg_release(struct rcu_head *rcu)
 {
+	struct blkg_policy_data *pd =
+		container_of(rcu, struct blkg_policy_data, rcu_head);
 	struct bfq_group *bfqg = pd_to_bfqg(pd);
 
 	bfqg_put(bfqg);
 }
 
+static void bfq_pd_free(struct blkg_policy_data *pd)
+{
+	call_rcu(&pd->rcu_head, bfqg_release);
+}
+
 static void bfq_pd_reset_stats(struct blkg_policy_data *pd)
 {
 	struct bfq_group *bfqg = pd_to_bfqg(pd);
 
 	bfqg_stats_reset(&bfqg->stats);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1cce3294634d..fd206d1fa3c9 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -138,10 +138,12 @@ static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
 struct blkg_policy_data {
 	/* the blkg and policy id this per-policy data belongs to */
 	struct blkcg_gq			*blkg;
 	int				plid;
 	bool				online;
+
+	struct rcu_head			rcu_head;
 };
 
 /*
  * Policies that need to keep per-blkcg data which is independent from any
  * request_queue associated to it should implement cpd_alloc/free_fn()
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 0cca88a366dc..c136b1f46fcc 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3024,10 +3024,20 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	spin_lock_irqsave(&ioc->lock, flags);
 	weight_updated(iocg, &now);
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 
+static void iocg_release(struct rcu_head *rcu)
+{
+	struct blkg_policy_data *pd =
+		container_of(rcu, struct blkg_policy_data, rcu_head);
+	struct ioc_gq *iocg = pd_to_iocg(pd);
+
+	free_percpu(iocg->pcpu_stat);
+	kfree(iocg);
+}
+
 static void ioc_pd_free(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 	struct ioc *ioc = iocg->ioc;
 	unsigned long flags;
@@ -3048,12 +3058,12 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 
 		spin_unlock_irqrestore(&ioc->lock, flags);
 
 		hrtimer_cancel(&iocg->waitq_timer);
 	}
-	free_percpu(iocg->pcpu_stat);
-	kfree(iocg);
+
+	call_rcu(&pd->rcu_head, iocg_release);
 }
 
 static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 53e8dd2dfa8a..c79056410cd9 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -1026,17 +1026,25 @@ static void iolatency_pd_offline(struct blkg_policy_data *pd)
 
 	iolatency_set_min_lat_nsec(blkg, 0);
 	iolatency_clear_scaling(blkg);
 }
 
-static void iolatency_pd_free(struct blkg_policy_data *pd)
+static void iolat_release(struct rcu_head *rcu)
 {
+	struct blkg_policy_data *pd =
+		container_of(rcu, struct blkg_policy_data, rcu_head);
 	struct iolatency_grp *iolat = pd_to_lat(pd);
+
 	free_percpu(iolat->stats);
 	kfree(iolat);
 }
 
+static void iolatency_pd_free(struct blkg_policy_data *pd)
+{
+	call_rcu(&pd->rcu_head, iolat_release);
+}
+
 static struct cftype iolatency_files[] = {
 	{
 		.name = "latency",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = iolatency_print_limit,
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index cabf91f0d0dc..0f89fb03cdb6 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -351,20 +351,29 @@ static void throtl_pd_online(struct blkg_policy_data *pd)
 	 * Update has_rules[] after a new group is brought online.
 	 */
 	tg_update_has_rules(tg);
 }
 
-static void throtl_pd_free(struct blkg_policy_data *pd)
+static void tg_release(struct rcu_head *rcu)
 {
+	struct blkg_policy_data *pd =
+		container_of(rcu, struct blkg_policy_data, rcu_head);
 	struct throtl_grp *tg = pd_to_tg(pd);
 
-	timer_delete_sync(&tg->service_queue.pending_timer);
 	blkg_rwstat_exit(&tg->stat_bytes);
 	blkg_rwstat_exit(&tg->stat_ios);
 	kfree(tg);
 }
 
+static void throtl_pd_free(struct blkg_policy_data *pd)
+{
+	struct throtl_grp *tg = pd_to_tg(pd);
+
+	timer_delete_sync(&tg->service_queue.pending_timer);
+	call_rcu(&pd->rcu_head, tg_release);
+}
+
 static struct throtl_grp *
 throtl_rb_first(struct throtl_service_queue *parent_sq)
 {
 	struct rb_node *n;
 
-- 
2.51.0

