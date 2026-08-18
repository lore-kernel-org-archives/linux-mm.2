Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A29FCC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921276B08EB; Tue, 18 Aug 2026 03:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8F76B08ED; Tue, 18 Aug 2026 03:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9156B08EF; Tue, 18 Aug 2026 03:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45B9D6B08EB
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:07:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2A311C1A1B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:07:43 +0000 (UTC)
X-FDA: 85113510006.05.7628D57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0F808120005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:07:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YvfXglB8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787036862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aV3Nyw+uuXYnDQ19BsvV3cneH7udoWaV/e/vJiD9II=;
	b=cqAqZTWSQO905Hgeb53lSIayJIpDQHsE6rg5CM6hYZqMqRmV97AmOzD6A64DmJd3OFnO/f
	u81seH7dkMAKJlIjbk7dcnVf21Y2SKN/SGY62Z4CiSNN/wwEt3WjlirTR+oIbl1MKWLz3y
	RlzfO1407dSDqB+LvbMDrdlJqRx/i24=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YvfXglB8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of yukuai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787036862;
	b=dNuttOwx9yaiinjN7k31rT0fG31MJG0vUc0Im9I80+DU3uQ5gsrFKxrThWL3fDV0qIs+Ay
	qC7Jn86JySz22xu9VzSKcPIuT0KUnooBfKy6j0/Dx0Pv4YJ6pVwJVgBPXAz4aRFLHDtJtW
	D9+uLkkk2h5ir4dvKe40mI0X/ZOtWHs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D447600AB;
	Tue, 18 Aug 2026 07:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FD41F00A3A;
	Tue, 18 Aug 2026 07:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787036861;
	bh=9aV3Nyw+uuXYnDQ19BsvV3cneH7udoWaV/e/vJiD9II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YvfXglB8Hz6MxfcsuYQoc8iQqqPlA0AC5U8Kmt2FiOzWVfTmddXI51YIpG5VFwemG
	 c+wt8dLkgCUAC+cXPXEEo/i11NZtqrFkng3fnoldSxNwKwsjisWjQ0qjOOArrNzpEf
	 zwq8RlA8fL9/pdosHFQysdyf0VkGXeQkoVvpNVcM3hP1+qKgj1e3QjHdbPo2LrwJ2G
	 ziJfdIhrXHzKUKBzopimSdMXsmStRoHTiSmzaMk4Foxg/mcUwmffyhynmdda4FwZGX
	 1L8mqtct3z9HtGMntsK/FgUOXTtSl5eBryJbfgZXWMbKt2sIztaet/Ze5LsE338JfY
	 74ORQ0tJ2/7LA==
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
Subject: [RFC PATCH v3 1/3] blk-cgroup: use a request_queue rhashtable for blkg lookup
Date: Tue, 18 Aug 2026 15:06:39 +0800
Message-ID: <20260818070641.756747-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260818070641.756747-1-yukuai@kernel.org>
References: <20260818070641.756747-1-yukuai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F808120005
X-Stat-Signature: 1hiaq5yifiecf1a97rk3oihzrgtmjxr6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787036861-866208
X-HE-Meta: U2FsdGVkX18l9VJGAiMI2R0z0nLqjFg6gJeiiP8lXT/IUeQDVeLcC9bq/wLZNUgV463/1RkCVuVO6Tnh5RK1jUcOuACX2CDqxwYYSyaggsMnef4rhIrehS2Df9ak4Ue9fMriwCyeyCkZMRQ39EKLjjNnVeb6s2kYc6iJTZqogYPTxQDTgEuPT1abeHdllTRXJjLimpqcaxlCcNl5cTs+9BcqPLJRsNAPVsBcm7ppZ0E4ZiARPswivs3fcMd2pxEQYNzG8ddugiI3eCWrQCPaluuw7gtmkwChhXxFreENoPjR00esFkUFMyHcxeUpVkwejkyNidyxsjQREKb9ypbU02b9D3O+Fjc1OsbMSjtrF34xp9pXlOmv05hCd0OTTTUqCEkq4kHOGZErnIRWbjzwh4gjbIL+0Grc/UEgjPf8uPjEZLgztzCwo1RAojk2VjW2GAawCYGeR+cCGiKdDWTyVHMHaISDiWHxI1b46hZAS/181Cuf4f9BwWkP+Zm0wfvNaPH/hmRYcef8JXPQkmGj66oIHlB8T8+M4YeV05Kl8do3l93wXcWn6DHCjFmo61pmlFxvYkLf0run9op4OXFESHKqjwDxjefMvFoyOo2kPAKHDo+TwFIWbuZgZh+d9mDY6Ubow8Klly8XYRLPTLnLJePrnLPhS6n07IHKSoR4JcvaBHt/NLAB99Tzs753YYK+iO77ZmGw6EBKLeSmAl3hnFdb6WcrO6FRduET/yoQJDWo2FsSDwASclFFMLo+Ojs+8/fPnSUtJPy/pYW+UckftxjeMkrtvacvCzm81Xst8hUCX6atLgeCMZVXZldIa8qVGph126OFkbk4hBbjBoOBpeLP0CpaBg4K46sTho4yMjH0GHJJx5qRvUvOrZXpGRc3ph7VuwDQIaTf9M0rnqHgjtR7/ZeQy3iupVt8D+Dsttj/tbb1sUXkyVBLxKIsIBbFpRiBC6ik5mCimtjtt0E
 tf+2xjhG
 R0cb2QTYHno/vYVa+pFNOf0aKIi6H/VKK0zE6UQBznA4hGQNbfa07M8JLr2oun3lxHkyD97/Tebf+SrBsq3Q/9eeEIGAw+4n+qzsWe2XEdFasfL6ZOwskPin60eR46PvKkYwO7lCX9HFgCRKNyAjUDlHinxdQCRlrWH3L8iKuLaArQqBPmXCHvvtsE76AqB6bSTEaV4pkmHiUBc35I5yR9wAiuMiUHHj0x545evGz9nYk5ErD5m5DQ9N5h5s19EX11uH2ykTU+0K41B5cy3uVYWPAIIcUNh0bIt09q4Pc6ewjlPd5cNA0zETsCc4kiRHol1Fttuyj8st6k2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

blkg lookup currently uses a per-blkcg radix tree keyed by request queue
ID, plus a lookup hint for the common case. This spreads the queue-local
blkcg association index across every blkcg and requires radix-tree
preloading before creating a blkg while holding q->queue_lock.

Replace the radix tree and lookup hint with a request_queue-owned
rhashtable keyed by the blkcg CSS ID. Cache the ID in each blkg; the blkg
holds a CSS reference until after it leaves the hash, so the ID cannot be
reused while it is hash-visible. The integer key also reduces hashing and
comparison work relative to a pointer-sized key on 64-bit systems.

Keep entries until blkg_release() and provide blkg_lookup_any() for callers
which need to find dying entries. blkg_lookup() filters offline entries so
existing lookup semantics remain unchanged.

Keep q->blkg_list for ordered policy and scheduler walks. All current
walkers are cgroupfs or sysfs slow paths, so they can move to rhashtable
iteration once the q->queue_lock to q->blkcg_mutex conversion lands.
Initialize and destroy the hash with request_queue, and remove the
radix-tree preload paths which are no longer needed.

blkg_release() removes the hash entry only when the blkg was successfully
inserted into q->blkg_list; the list_empty case covers allocation or
creation failure before insertion.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c     | 64 +++++++++++++++++++-----------------------
 block/blk-cgroup.h     | 49 +++++++++++++++++++++++---------
 block/blk-core.c       |  9 ++++--
 include/linux/blkdev.h |  2 ++
 4 files changed, 74 insertions(+), 50 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2b5c29434e42..753a8022a283 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -64,10 +64,17 @@ bool blkcg_debug_stats = false;
 
 static DEFINE_RAW_SPINLOCK(blkg_stat_lock);
 
 #define BLKG_DESTROY_BATCH_SIZE  64
 
+const struct rhashtable_params blkg_hash_params = {
+	.key_len		= sizeof_field(struct blkcg_gq, blkcg_id),
+	.key_offset		= offsetof(struct blkcg_gq, blkcg_id),
+	.head_offset		= offsetof(struct blkcg_gq, q_hash_node),
+	.automatic_shrinking	= true,
+};
+
 /*
  * Lockless lists for tracking IO stats update
  *
  * New IO stats are stored in the percpu iostat_cpu within blkcg_gq (blkg).
  * There are multiple blkg's (one for each block device) attached to each
@@ -192,10 +199,20 @@ static void blkg_release(struct percpu_ref *ref)
 {
 	struct blkcg_gq *blkg = container_of(ref, struct blkcg_gq, refcnt);
 	struct blkcg *blkcg = blkg->blkcg;
 	int cpu;
 
+	/*
+	 * A blkg that was never inserted into q->blkg_list has no hash
+	 * entry.  This happens when allocation or creation fails before
+	 * rhashtable_insert_fast() succeeds.
+	 */
+	if (!list_empty(&blkg->q_node))
+		WARN_ON_ONCE(rhashtable_remove_fast(&blkg->q->blkg_hash,
+						    &blkg->q_hash_node,
+						    blkg_hash_params));
+
 	/*
 	 * Flush all the non-empty percpu lockless lists before releasing
 	 * us, given these stat belongs to us.
 	 *
 	 * blkg_stat_lock is for serializing blkg stat update
@@ -325,10 +342,11 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 		goto out_put_queue;
 
 	blkg->q = disk->queue;
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
+	blkg->blkcg_id = blkcg->css.id;
 	blkg->iostat.blkg = blkg;
 #ifdef CONFIG_BLK_CGROUP_PUNT_BIO
 	spin_lock_init(&blkg->async_bio_lock);
 	bio_list_init(&blkg->async_bios);
 	INIT_WORK(&blkg->async_bio_work, blkg_async_bio_workfn);
@@ -421,11 +439,12 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 			pol->pd_init_fn(blkg->pd[i]);
 	}
 
 	/* insert */
 	spin_lock(&blkcg->lock);
-	ret = radix_tree_insert(&blkcg->blkg_tree, disk->queue->id, blkg);
+	ret = rhashtable_insert_fast(&disk->queue->blkg_hash,
+				     &blkg->q_hash_node, blkg_hash_params);
 	if (likely(!ret)) {
 		hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 		list_add(&blkg->q_node, &disk->queue->blkg_list);
 
 		for (i = 0; i < BLKCG_MAX_POLS; i++) {
@@ -474,13 +493,10 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 	struct blkcg_gq *blkg;
 
 	rcu_read_lock();
 	blkg = blkg_lookup(blkcg, q);
 	if (blkg) {
-		if (blkcg != &blkcg_root &&
-		    blkg != rcu_dereference(blkcg->blkg_hint))
-			rcu_assign_pointer(blkcg->blkg_hint, blkg);
 		rcu_read_unlock();
 		return blkg;
 	}
 	rcu_read_unlock();
 
@@ -544,21 +560,12 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 		}
 	}
 
 	blkg->online = false;
 
-	radix_tree_delete(&blkcg->blkg_tree, blkg->q->id);
 	hlist_del_init_rcu(&blkg->blkcg_node);
 
-	/*
-	 * Both setting lookup hint to and clearing it from @blkg are done
-	 * under queue_lock.  If it's not pointing to @blkg now, it never
-	 * will.  Hint assignment itself can race safely.
-	 */
-	if (rcu_access_pointer(blkcg->blkg_hint) == blkg)
-		rcu_assign_pointer(blkcg->blkg_hint, NULL);
-
 	/*
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
 	 */
 	percpu_ref_kill(&blkg->refcnt);
@@ -880,47 +887,37 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		if (unlikely(!new_blkg)) {
 			ret = -ENOMEM;
 			goto fail_exit;
 		}
 
-		if (radix_tree_preload(GFP_KERNEL)) {
-			blkg_free(new_blkg);
-			ret = -ENOMEM;
-			goto fail_exit;
-		}
-
 		spin_lock_irq(&q->queue_lock);
 
 		if (!blkcg_policy_enabled(q, pol)) {
 			blkg_free(new_blkg);
 			ret = -EOPNOTSUPP;
-			goto fail_preloaded;
+			goto fail_unlock;
 		}
 
 		blkg = blkg_lookup(pos, q);
 		if (blkg) {
 			blkg_free(new_blkg);
 		} else {
 			blkg = blkg_create(pos, disk, new_blkg);
 			if (IS_ERR(blkg)) {
 				ret = PTR_ERR(blkg);
-				goto fail_preloaded;
+				goto fail_unlock;
 			}
 		}
 
-		radix_tree_preload_end();
-
 		if (pos == blkcg)
 			goto success;
 	}
 success:
 	mutex_unlock(&q->blkcg_mutex);
 	ctx->blkg = blkg;
 	return 0;
 
-fail_preloaded:
-	radix_tree_preload_end();
 fail_unlock:
 	spin_unlock_irq(&q->queue_lock);
 fail_exit:
 	mutex_unlock(&q->blkcg_mutex);
 	/*
@@ -1418,11 +1415,10 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 		cpd->plid = i;
 	}
 
 	spin_lock_init(&blkcg->lock);
 	refcount_set(&blkcg->online_pin, 1);
-	INIT_RADIX_TREE(&blkcg->blkg_tree, GFP_NOWAIT);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&blkcg->cgwb_list);
 #endif
 	list_add_tail(&blkcg->all_blkcgs_node, &all_blkcgs);
@@ -1455,21 +1451,26 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
 	if (parent)
 		blkcg_pin_online(&parent->css);
 	return 0;
 }
 
-void blkg_init_queue(struct request_queue *q)
+int blkg_init_queue(struct request_queue *q)
 {
 	INIT_LIST_HEAD(&q->blkg_list);
 	mutex_init(&q->blkcg_mutex);
+	return rhashtable_init(&q->blkg_hash, &blkg_hash_params);
+}
+
+void blkg_exit_queue(struct request_queue *q)
+{
+	rhashtable_destroy(&q->blkg_hash);
 }
 
 int blkcg_init_disk(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *new_blkg, *blkg;
-	bool preloaded;
 
 	/*
 	 * If the queue is shared across disk rebind (e.g., SCSI), the
 	 * previous disk's blkcg state is cleaned up asynchronously via
 	 * disk_release() -> blkcg_exit_disk(). Wait for that cleanup to
@@ -1483,30 +1484,23 @@ int blkcg_init_disk(struct gendisk *disk)
 
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
 		return -ENOMEM;
 
-	preloaded = !radix_tree_preload(GFP_KERNEL);
-
 	/* Make sure the root blkg exists. */
 	/* spin_lock_irq can serve as RCU read-side critical section. */
 	spin_lock_irq(&q->queue_lock);
 	blkg = blkg_create(&blkcg_root, disk, new_blkg);
 	if (IS_ERR(blkg))
 		goto err_unlock;
 	q->root_blkg = blkg;
 	spin_unlock_irq(&q->queue_lock);
 
-	if (preloaded)
-		radix_tree_preload_end();
-
 	return 0;
 
 err_unlock:
 	spin_unlock_irq(&q->queue_lock);
-	if (preloaded)
-		radix_tree_preload_end();
 	return PTR_ERR(blkg);
 }
 
 void blkcg_exit_disk(struct gendisk *disk)
 {
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index e67c69839129..7278a8817a49 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -17,10 +17,12 @@
 #include <linux/blk-cgroup.h>
 #include <linux/cgroup.h>
 #include <linux/kthread.h>
 #include <linux/blk-mq.h>
 #include <linux/llist.h>
+#include <linux/rhashtable.h>
+#include <linux/rcupdate.h>
 #include "blk.h"
 
 struct blkcg_gq;
 struct blkg_policy_data;
 
@@ -54,13 +56,15 @@ struct blkg_iostat_set {
 
 /* association between a blk cgroup and a request queue */
 struct blkcg_gq {
 	/* Pointer to the associated request_queue */
 	struct request_queue		*q;
+	struct rhash_head		q_hash_node;
 	struct list_head		q_node;
 	struct hlist_node		blkcg_node;
 	struct blkcg			*blkcg;
+	int				blkcg_id;
 
 	/* all non-root blkcg_gq's are guaranteed to have access to parent */
 	struct blkcg_gq			*parent;
 
 	/* reference count */
@@ -96,12 +100,10 @@ struct blkcg {
 	spinlock_t			lock;
 	refcount_t			online_pin;
 	/* If there is block congestion on this cgroup. */
 	atomic_t			congestion_count;
 
-	struct radix_tree_root		blkg_tree;
-	struct blkcg_gq	__rcu		*blkg_hint;
 	struct hlist_head		blkg_list;
 
 	struct blkcg_policy_data	*cpd[BLKCG_MAX_POLS];
 
 	struct list_head		all_blkcgs_node;
@@ -190,12 +192,14 @@ struct blkcg_policy {
 	blkcg_pol_stat_pd_fn		*pd_stat_fn;
 };
 
 extern struct blkcg blkcg_root;
 extern bool blkcg_debug_stats;
+extern const struct rhashtable_params blkg_hash_params;
 
-void blkg_init_queue(struct request_queue *q);
+int blkg_init_queue(struct request_queue *q);
+void blkg_exit_queue(struct request_queue *q);
 int blkcg_init_disk(struct gendisk *disk);
 void blkcg_exit_disk(struct gendisk *disk);
 
 /* Blkio controller policy registration */
 int blkcg_policy_register(struct blkcg_policy *pol);
@@ -247,15 +251,37 @@ static inline bool bio_issue_as_root_blkg(struct bio *bio)
 {
 	return (bio->bi_opf & (REQ_META | REQ_SWAP)) != 0;
 }
 
 /**
- * blkg_lookup - lookup blkg for the specified blkcg - q pair
+ * blkg_lookup_any - lookup any blkg for the specified blkcg - q pair
  * @blkcg: blkcg of interest
  * @q: request_queue of interest
  *
- * Lookup blkg for the @blkcg - @q pair.
+ * Lookup a blkg for the @blkcg - @q pair, whether it is online or dying.
+ *
+ * Must be called in a RCU critical section.
+ *
+ * This does not acquire a reference.  The caller must already hold one, or
+ * have the blkg pinned by I/O.
+ */
+static inline struct blkcg_gq *blkg_lookup_any(struct blkcg *blkcg,
+					       struct request_queue *q)
+{
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			 "blkg_lookup_any() requires an RCU read lock");
+
+	return rhashtable_lookup(&q->blkg_hash, &blkcg->css.id,
+				 blkg_hash_params);
+}
+
+/**
+ * blkg_lookup - lookup an online blkg for the specified blkcg - q pair
+ * @blkcg: blkcg of interest
+ * @q: request_queue of interest
+ *
+ * Lookup an online blkg for the @blkcg - @q pair.
  *
  * Must be called in a RCU critical section.
  */
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 					   struct request_queue *q)
@@ -263,17 +289,12 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 	struct blkcg_gq *blkg;
 
 	if (blkcg == &blkcg_root)
 		return q->root_blkg;
 
-	blkg = rcu_dereference_check(blkcg->blkg_hint,
-			lockdep_is_held(&q->queue_lock));
-	if (blkg && blkg->q == q)
-		return blkg;
-
-	blkg = radix_tree_lookup(&blkcg->blkg_tree, q->id);
-	if (blkg && blkg->q != q)
+	blkg = blkg_lookup_any(blkcg, q);
+	if (blkg && !READ_ONCE(blkg->online))
 		blkg = NULL;
 	return blkg;
 }
 
 /**
@@ -496,12 +517,14 @@ struct blkcg_policy {
 };
 
 struct blkcg {
 };
 
+static inline struct blkcg_gq *blkg_lookup_any(struct blkcg *blkcg, void *key) { return NULL; }
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg, void *key) { return NULL; }
-static inline void blkg_init_queue(struct request_queue *q) { }
+static inline int blkg_init_queue(struct request_queue *q) { return 0; }
+static inline void blkg_exit_queue(struct request_queue *q) { }
 static inline int blkcg_init_disk(struct gendisk *disk) { return 0; }
 static inline void blkcg_exit_disk(struct gendisk *disk) { }
 static inline int blkcg_policy_register(struct blkcg_policy *pol) { return 0; }
 static inline void blkcg_policy_unregister(struct blkcg_policy *pol) { }
 static inline int blkcg_activate_policy(struct gendisk *disk,
diff --git a/block/blk-core.c b/block/blk-core.c
index 196bccf27f58..e396a316b8bf 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -301,10 +301,11 @@ static void blk_free_queue(struct request_queue *q)
 {
 	blk_free_queue_stats(q->stats);
 	if (queue_is_mq(q))
 		blk_mq_release(q);
 
+	blkg_exit_queue(q);
 	ida_free(&blk_queue_ida, q->id);
 	lockdep_unregister_key(&q->io_lock_cls_key);
 	lockdep_unregister_key(&q->q_lock_cls_key);
 	call_rcu(&q->rcu_head, blk_free_queue_rcu);
 }
@@ -479,21 +480,23 @@ struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id)
 	spin_lock_init(&q->queue_lock);
 
 	init_waitqueue_head(&q->mq_freeze_wq);
 	mutex_init(&q->mq_freeze_lock);
 
-	blkg_init_queue(q);
+	error = blkg_init_queue(q);
+	if (error)
+		goto fail_stats;
 
 	/*
 	 * Init percpu_ref in atomic mode so that it's faster to shutdown.
 	 * See blk_register_queue() for details.
 	 */
 	error = percpu_ref_init(&q->q_usage_counter,
 				blk_queue_usage_counter_release,
 				PERCPU_REF_INIT_ATOMIC, GFP_KERNEL);
 	if (error)
-		goto fail_stats;
+		goto fail_blkg;
 	lockdep_register_key(&q->io_lock_cls_key);
 	lockdep_register_key(&q->q_lock_cls_key);
 	lockdep_init_map(&q->io_lockdep_map, "&q->q_usage_counter(io)",
 			 &q->io_lock_cls_key, 0);
 	lockdep_init_map(&q->q_lockdep_map, "&q->q_usage_counter(queue)",
@@ -508,10 +511,12 @@ struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id)
 	q->nr_requests = BLKDEV_DEFAULT_RQ;
 	q->async_depth = BLKDEV_DEFAULT_RQ;
 
 	return q;
 
+fail_blkg:
+	blkg_exit_queue(q);
 fail_stats:
 	blk_free_queue_stats(q->stats);
 fail_id:
 	ida_free(&blk_queue_ida, q->id);
 fail_q:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 20cb8ed7d987..f3b0e39d3f6b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -25,10 +25,11 @@
 #include <linux/sbitmap.h>
 #include <linux/uuid.h>
 #include <linux/xarray.h>
 #include <linux/file.h>
 #include <linux/lockdep.h>
+#include <linux/rhashtable-types.h>
 
 struct module;
 struct request_queue;
 struct elevator_queue;
 struct blk_trace;
@@ -579,10 +580,11 @@ struct request_queue {
 
 	struct list_head	icq_list;
 #ifdef CONFIG_BLK_CGROUP
 	DECLARE_BITMAP		(blkcg_pols, BLKCG_MAX_POLS);
 	struct blkcg_gq		*root_blkg;
+	struct rhashtable	blkg_hash;
 	struct list_head	blkg_list;
 	struct mutex		blkcg_mutex;
 #endif
 
 	int			node;
-- 
2.51.0


