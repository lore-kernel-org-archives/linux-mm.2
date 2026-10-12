Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FAE0CA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA04A6B0098; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C007F6B009F; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC89E6B00A0; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB0E6B0099
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E005B1609E8
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:16 +0000 (UTC)
X-FDA: 85313286912.11.DB46BBB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id A1C3640006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nyouNAxc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Y+vVDIBH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="r/pu49cZ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xqc0PAPK;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793454;
	b=kVc2dACStACC+wvwiQ96+MTjElQbpQU6YX4g+v40pR1AkaBsPTDYiGC5PS+/EFDpmaVl3Y
	SJ9v/FRHqBTh7yuE37nAfYdjIJyjQ5Vtb4K3USi0hh+OIzD+karVH4qTxKN7S+ZHGW3tlx
	0Au+KyWLlnAD6eJQ2g1nHQs9uh6bChM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nyouNAxc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Y+vVDIBH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="r/pu49cZ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xqc0PAPK;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3jXehY5XmEN8WMphPUYMu009gEUXyBxUGy3zqUxv8A=;
	b=HgG6h1D9VGcykWcFEPwoiLrpXoed9hD+utp2w+Q84+VWkyj8osEqOoN1tW8ouNuAk1XkHX
	hYHRs9raWV7UrCoOIL5/7wwzujPukvW9mI8tVEUHPA82scku76XCmiDnLA1eYu4ywKXZ+7
	NYFlroS/4N4E99xJ8o+kM3fWPYUUjmk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B9C111F76C;
	Mon, 12 Oct 2026 08:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791793453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3jXehY5XmEN8WMphPUYMu009gEUXyBxUGy3zqUxv8A=;
	b=nyouNAxcusCdSVWMvXSECzDoTSLyZqcfBH5W/lTtJGcovqpZ7L4cEiyiyjaoE0G9kM+KY0
	PlDXnCXpl5+5rbne5+sAGOX8w6MIoBtM26x6SzxNC1+rRUlVYZd6wXfsh6Ef8TJAGK8htT
	9bRGF6XGjQaBJkRykoOJdEvJ/b/E6yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791793453;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3jXehY5XmEN8WMphPUYMu009gEUXyBxUGy3zqUxv8A=;
	b=Y+vVDIBHZYbXYs6Yk9TRcD8YWq83xBGpha4KUkzxSwab2eteSXpiRrj91WzozM2777iJc9
	e1yMuDXFdlR9nVDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791793451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3jXehY5XmEN8WMphPUYMu009gEUXyBxUGy3zqUxv8A=;
	b=r/pu49cZ+ARlyZuP9mSK8irqNX9TSIR1nTa/LstMkQF+e7ywTBHPbw3XjkFVH5/4yZTjdp
	yQx+8TPy5/9J+wYitKcz9XJwAH/DfTO2s0fL3NdyEBTwMHXtuH7Nr7y8DTZ/uHLCOAx+0t
	F9IOHpCMprA1/SsWn7fuSAq2q5Grr9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791793451;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3jXehY5XmEN8WMphPUYMu009gEUXyBxUGy3zqUxv8A=;
	b=Xqc0PAPKRV3zBEk+SVyFJCIMdHs1BN6sR/8qH0+DFwOu6NRpMKyd5v6+h1i0ccUuMd7pYc
	IIHrfoyecadsNACQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C72513408;
	Mon, 12 Oct 2026 08:24:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aIbHDSuZzGoLHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 08:24:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9C230A140A; Mon, 12 Oct 2026 10:24:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 3/7] fs: Basic infrastructure for offloading inode reclaim
Date: Mon, 12 Oct 2026 10:23:41 +0200
Message-ID: <20261012082356.3121725-10-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261009133253.20102-1-jack@suse.cz>
References: <20261009133253.20102-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11285; i=jack@suse.cz; h=from:subject; bh=+A4HEm+b0MtHph46IzBRR49b0KKgVIC7sLdZ0BdCVMs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqzJkeK2cPhL38nq1/Y7ieVGuAjzzrxor9TSEJX RHeVHNmQI2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCasyZHgAKCRCcnaoHP2RA 2StRCACoZsJK65yB/EVLXVN+zRSUuAuFX/ZUtHOZ/oc7NO4pEVVosxDlFuL8BdP8NZK0Zq6+aHe OTLtsq2c68jtzxgWeC6D3JAdSngn3qPoJsBeCLbknxDOV6JOXT4TG639GXgrdrp7He33sFbJZen /kLGTluGbKUbHpavNAASJFpyHpMvjWsp+IH8clxUCrOR3w236Af2SX74LJ/HYQUS1om3nbQ5Uzz ISA/+kxxLeVSeLG0gUapf7fPxxqmci2AbCi2r03bZzaf1fuM5U8obgFPuwLr2OJGK+AwismFFHu qMMVLrJBarMBMygbSSMIsU2PYZlUFhwyJF4vFAaPSATj80x/
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tcu8jfx7asu6dazatoa8xfxcjfcohemq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1C3640006
X-HE-Tag: 1791793454-293839
X-HE-Meta: U2FsdGVkX196Ow8zswGhBVvGk6OosFSqk4T9XuOBBCxwWZO6U63uqmIRslt7yHg0+suCNHUWLjASfLalMgrSYwTt/OrF08UFOiBBPJe4xn3eBE4CeI9myNCnhAd1d7pBf8YfhGrCMxC7euEHZBL3GnDPl5aVP9DerxrYls44Mw/AQ1EJ3L6BxFCmpSBWadXrCwK/PBr/WFMK8G2HshE9Er4wrhNSc8yL1fmBhq3yGvteBWloJO9l7yv20y20NicLwy8UIoIvuhF6lJrNQnR0HgpS0WT6MzspV5nbxLeTBTV4GnkZscBTdPoZ6sSp/uH8DGhZjlbOZt9099lb/kqOk2MJr2U8ONO4CyhY+2mc0F205zJpI+uVmogExPXM4xEi8SRmjTz4DkJBctCm6UBwSrQUvahVtFBaQozuwUZK2XSTv+yuuthlKssOMCl/tyKlYHI4Pd6bovGpMQoecVJa8BSBUYsTKSAckrzK5v/UJJ/FIaJkvZtteu4apRFUIFoC2s7lVWglsXpZuXkjxhodmcitB1lekUgFY7IjQX7KWnjK7WMVaWKRv2NQatsZfgzqub1PDde7DE9cQ7YXG8JLavCpvCJC5YyFL6c5ikWeHxIZ75DtB/7Z35akOJGwd/0dfhRIvkgDYCplzonJqVMKnoVXdLHkJcumfXBGRaY/9ssTHMB96L0PeWLXNqn8IoGA+fbvqqh8nMSepLVZa4FJwobkpj1u05ysb2XbsOXo7vW/xTSaFDz+6pv4zcF8qV9jWbuidTfklCSgyTD5pBVj0aoHQZmhMs5oUcwSvjb+6kUDrZaFtjkPQfVLHSyZQCOsm+anWYC2mN1351j9B3WK/JXm3PDShijwoa27j8vvCTEaI30hhK4QXsJHnJp/CWFDp5uki6rz3eNcRxC5hRDWk0+GRb33qZQWW2+xZvTxjXdFREE8buoSj6W58nft/tGtqck0ooxyEF+vfA4rBgi
 eSDVwfYW
 2X5XkH2v6RvKtJ5Z1wDYPYqugajC/Uf9qzk6koLArZtRSbfy2l8SEgGoUkpBEQmG4H7aMtx8OGiYehPVyQdeFVtLvsLdOmeGtyStc92hx8PMHn7y+dGQMZ+58CuwjGgyLsC9Sj3E1EvkVED/o60gfxxZeJBisQmP60lG3kAVvu7prfmXH4lyJ2r17RvhEEPfy07KIgX0carbjc+no0r2QuihLGKW+O+zDDgI0IZ8fYitwdvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reclaim of some inodes is rather complex requiring running transactions
or doing other IO. Consequently filesystems end up doing GFP_NOFAIL
allocations from kswapd or even direct reclaim which is problematic
because forward progress of these allocations isn't guaranteed. Add
infrastructure for marking inodes whose reclaim is difficult and offload
reclaim of such inodes into a workqueue to not block kswapd with
difficult inode reclaim. The processing of the queued inodes happens in
parallel from several work items so that the reclaim has higher chances
of keeping up with the inflow of inodes if reclaim of some inodes
progresses slowly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c                       | 212 ++++++++++++++++++++++++++++++-
 fs/super.c                       |   2 +
 include/linux/fs.h               |   3 +
 include/linux/fs/super_types.h   |   3 +
 include/trace/events/writeback.h |   3 +-
 5 files changed, 219 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 43f3b2cb1ebb..0128db61217e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -74,6 +74,25 @@ static DEFINE_PER_CPU(unsigned long, nr_unused);
 
 static struct kmem_cache *inode_cachep __ro_after_init;
 
+struct deferred_reclaim_queue {
+	struct list_head list;
+	spinlock_t lock;
+};
+
+/* Inodes for deferred reclaim */
+struct inode_deferred_reclaim {
+	int workers;			/* Number of parallel workers */
+	struct workqueue_struct *wq;	/* Workqueue for workers */
+	struct work_struct *work;	/* Workers */
+	/*
+	 * Queue of deferred inodes. The number of queues is the same number
+	 * as the number of workers
+	 */
+	struct deferred_reclaim_queue *queues;
+};
+
+static struct inode_deferred_reclaim deferred_reclaim;
+
 static long get_nr_inodes(void)
 {
 	int i;
@@ -949,7 +968,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	 * sync, or the last page cache deletion will requeue them.
 	 */
 	if (icount_read(inode) ||
-	    (inode_state_read(inode) & ~I_REFERENCED) ||
+	    inode_state_read(inode) & ~(I_REFERENCED | I_DEFER_RECLAIM) ||
 	    !mapping_shrinkable(&inode->i_data)) {
 		list_lru_isolate(lru, &inode->i_lru);
 		spin_unlock(&inode->i_lock);
@@ -994,6 +1013,38 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	return LRU_REMOVED;
 }
 
+/* Number of inodes to process in one reclaim batch */
+#define INODE_RECLAIM_BATCH_SIZE 16
+
+static int get_deferred_sb_id(struct super_block *sb)
+{
+	return hash_ptr(sb, 32) % deferred_reclaim.workers;
+}
+
+static void queue_deferred_reclaim(struct super_block *sb, int count,
+				   struct list_head *list)
+{
+	int id = get_deferred_sb_id(sb);
+	struct deferred_reclaim_queue *queue =
+					&deferred_reclaim.queues[id];
+	int i, wake_count;
+
+	spin_lock(&queue->lock);
+	list_splice_tail(list, &queue->list);
+	atomic_add(count, &sb->s_deferred_reclaim_count);
+	spin_unlock(&queue->lock);
+
+	/* Queue works to process inodes we've added to the list */
+	wake_count = DIV_ROUND_UP(count, INODE_RECLAIM_BATCH_SIZE);
+	if (wake_count > deferred_reclaim.workers)
+		wake_count = deferred_reclaim.workers;
+	for (i = 0; i < wake_count; i++) {
+		queue_work(deferred_reclaim.wq,
+			   &deferred_reclaim.work[id]);
+		id = (id + 1) % deferred_reclaim.workers;
+	}
+}
+
 /*
  * Walk the superblock inode LRU for freeable inodes and attempt to free them.
  * This is called from the superblock shrinker function with a number of inodes
@@ -1003,14 +1054,166 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 {
 	LIST_HEAD(freeable);
-	long freed;
+	long freed, deferred = 0;
+	struct inode *inode, *tmp;
 
 	freed = list_lru_shrink_walk(&sb->s_inode_lru, sc,
 				     inode_lru_isolate, &freeable);
-	dispose_list(&freeable);
+
+	list_for_each_entry_safe(inode, tmp, &freeable, i_lru) {
+		if (inode_state_read_once(inode) & I_DEFER_RECLAIM) {
+			deferred++;
+			continue;
+		}
+		list_del_init(&inode->i_lru);
+		evict(inode);
+		cond_resched();
+	}
+
+	if (!list_empty(&freeable))
+		queue_deferred_reclaim(sb, deferred, &freeable);
 	return freed;
 }
 
+static void __get_inode_reclaim_batch(int *start, int end,
+				      struct list_head *list, int *count)
+{
+	int i;
+
+	for (i = *start; i < end; i++) {
+		struct deferred_reclaim_queue *queue =
+						&deferred_reclaim.queues[i];
+		struct list_head *entry, tmp;
+
+		if (list_empty_careful(&queue->list))
+			continue;
+		spin_lock(&queue->lock);
+		list_for_each(entry, &queue->list) {
+			if (*count >= INODE_RECLAIM_BATCH_SIZE)
+				break;
+			(*count)++;
+		}
+		list_cut_before(&tmp, &queue->list, entry);
+		list_splice_tail(&tmp, list);
+		spin_unlock(&queue->lock);
+		if (*count >= INODE_RECLAIM_BATCH_SIZE)
+			break;
+	}
+	*start = i;
+}
+
+/* Move a batch of inodes from queued lists to our private list */
+static int get_inode_reclaim_batch(int *id, struct list_head *list)
+{
+	int count = 0;
+	int orig_id = *id;
+
+	__get_inode_reclaim_batch(id, deferred_reclaim.workers, list, &count);
+	if (count >= INODE_RECLAIM_BATCH_SIZE)
+		return count;
+	/* Wrap around */
+	if (orig_id > 0) {
+		*id = 0;
+		__get_inode_reclaim_batch(id, orig_id, list, &count);
+	}
+	return count;
+}
+
+
+static void inode_reclaim_deferred(struct work_struct *work)
+{
+	struct inode *inode;
+	LIST_HEAD(inode_batch);
+	/*
+	 * We start with the list corresponding to the work but rolling a dice
+	 * would work as well
+	 */
+	int id = work - deferred_reclaim.work;
+
+	while (1) {
+		if (!get_inode_reclaim_batch(&id, &inode_batch))
+			break;
+		while (!list_empty(&inode_batch)) {
+			struct super_block *sb;
+
+			/*
+			 * inode_batch list is private and I_FREEING flags
+			 * protect us from anybody else trying to remove the
+			 * inode from the LRU list. No locking needed.
+			 */
+			inode = list_first_entry(&inode_batch, struct inode,
+						 i_lru);
+			list_del_init(&inode->i_lru);
+			sb = inode->i_sb;
+			evict(inode);
+			/*
+			 * The elevated s_deferred_reclaim_count keeps sb alive
+			 * until we drop it
+			 */
+			if (atomic_dec_and_test(&sb->s_deferred_reclaim_count))
+				wake_up_var(&sb->s_deferred_reclaim_count);
+			cond_resched();
+		}
+	}
+}
+
+/* Maximum number of inode reclaim workers */
+#define MAX_RECLAIM_WORKERS 16
+
+static void __init deferred_reclaim_init(void)
+{
+	int workers = MAX_RECLAIM_WORKERS;
+	int i;
+
+	/* Scale down the number of workers for small systems */
+	if (workers > num_possible_cpus())
+		workers = num_possible_cpus();
+
+	deferred_reclaim.workers = workers;
+	deferred_reclaim.work = kmalloc_objs(struct work_struct, workers);
+	deferred_reclaim.queues =
+			kmalloc_objs(struct deferred_reclaim_queue, workers);
+	if (!deferred_reclaim.work || !deferred_reclaim.queues)
+		panic("Failed to allocate deferred inode reclaim queues");
+
+	deferred_reclaim.wq = alloc_workqueue("deferred-inode-reclaim",
+			WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			workers);
+	if (!deferred_reclaim.wq)
+		panic("Failed to allocate deferred inode reclaim workqueue");
+
+	for (i = 0; i < workers; i++) {
+		INIT_WORK(&deferred_reclaim.work[i], inode_reclaim_deferred);
+		spin_lock_init(&deferred_reclaim.queues[i].lock);
+		INIT_LIST_HEAD(&deferred_reclaim.queues[i].list);
+	}
+}
+
+/*
+ * Mark inode for deferred reclaim. When slab reclaim path will be freeing the
+ * inode, it will not call evict() directly but rather offload it to a worker
+ * in a workqueue. This is useful when inode reclaim is expected to take a
+ * long time (e.g. because it needs to do IO) so that it doesn't block kswapd
+ * or because it needs allocating memory (which cannot be guaranteed from
+ * reclaim path).
+ *
+ * Note that we currently don't provide a way to unmark inode for deferred
+ * reclaim. It could be done but the benefit is unclear. The rationale is that
+ * to make inode hard to reclaim, relatively expensive things like writing data
+ * to the file have to be done and in such case the additional CPU overhead and
+ * latency of offloading the inode reclaim is negligible in the overall load.
+ */
+void mark_inode_reclaim_deferred(struct inode *inode)
+{
+	if (inode_state_read_once(inode) & I_DEFER_RECLAIM)
+		return;
+
+	spin_lock(&inode->i_lock);
+	inode_state_set(inode, I_DEFER_RECLAIM);
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL_GPL(mark_inode_reclaim_deferred);
+
 static void __wait_on_freeing_inode(struct inode *inode, bool hash_locked, bool rcu_locked);
 static bool igrab_from_hash(struct inode *inode);
 
@@ -2658,6 +2861,9 @@ void __init inode_init(void)
 					 SLAB_ACCOUNT),
 					 init_once);
 
+	/* Deferred inode reclaim infrastructure */
+	deferred_reclaim_init();
+
 	/* Hash may have been set up in inode_init_early */
 	if (!hashdist)
 		return;
diff --git a/fs/super.c b/fs/super.c
index 1d5ccf540a9b..fc845079b3df 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -583,6 +583,8 @@ void deactivate_locked_super(struct super_block *s)
 	struct file_system_type *fs = s->s_type;
 	if (atomic_dec_and_test(&s->s_active)) {
 		shrinker_free(s->s_shrink);
+		wait_var_event(&s->s_deferred_reclaim_count,
+			       !atomic_read(&s->s_deferred_reclaim_count));
 		fs->kill_sb(s);
 
 		kill_super_notify(s);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f9d1e05e8ae6..a289402563f8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -741,6 +741,7 @@ enum inode_state_flags_enum {
 	I_SYNC_QUEUED		= (1U << 17),
 	I_PINNING_NETFS_WB	= (1U << 18),
 	I_METADATA_WRITEBACK	= (1U << 19),
+	I_DEFER_RECLAIM		= (1U << 20),
 };
 
 #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
@@ -2218,6 +2219,8 @@ static inline void set_inode_metadata_writeback(struct inode *inode)
 	spin_unlock(&inode->i_lock);
 }
 
+void mark_inode_reclaim_deferred(struct inode *inode);
+
 /*
  * returns the refcount on the inode. it can change arbitrarily.
  */
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index ecd96aeb1cee..a41bd57fc2e6 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -232,6 +232,9 @@ struct super_block {
 
 	struct shrinker				*s_shrink;	/* per-sb shrinker handle */
 
+	/* Number of inodes queued for deferred reclaim */
+	atomic_t				s_deferred_reclaim_count;
+
 	/* Number of inodes with nlink == 0 but still referenced */
 	atomic_long_t				s_remove_count;
 
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 13ee076ccd16..4a9cfe458820 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -28,7 +28,8 @@
 		{I_DONTCACHE,		"I_DONTCACHE"},		\
 		{I_SYNC_QUEUED,		"I_SYNC_QUEUED"},	\
 		{I_PINNING_NETFS_WB,	"I_PINNING_NETFS_WB"},	\
-		{I_LRU_ISOLATING,	"I_LRU_ISOLATING"}	\
+		{I_LRU_ISOLATING,	"I_LRU_ISOLATING"},	\
+		{I_DEFER_RECLAIM,	"I_DEFER_RECLAIM"}	\
 	)
 
 /* enums need to be exported to user space */
-- 
2.51.0


