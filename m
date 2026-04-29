Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9B9FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9C9B6B0005; Wed, 29 Apr 2026 14:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4DAC6B0093; Wed, 29 Apr 2026 14:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE326B0095; Wed, 29 Apr 2026 14:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A9EA76B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:01:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 646B21602C3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:01:39 +0000 (UTC)
X-FDA: 84712361118.12.587A809
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 601C940007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:01:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CvYCDdqp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k4qN3aKj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CvYCDdqp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k4qN3aKj;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777485696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cklHMklyuItTZV8ao77zjF0U5CZlwBoE5/zLT3mlMFU=;
	b=REMdcpDadWVjQCc6UyRO4PvSFUDdiX24j4QGe8pzfLjgJgjdQotTVZkW6mWRxRhB0aXEAe
	GB7VLQLlcLS1cspKmMc3xTUxyLyfX38rheLWd/8jDleAXDEMBSSUqGNnrXp9uZOWijUl5y
	8ZPN1TQRWSXbRGn0v/UzVHY/6wKYH+k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CvYCDdqp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k4qN3aKj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CvYCDdqp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k4qN3aKj;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777485696; a=rsa-sha256;
	cv=none;
	b=PodInjpacnWBChw4VI1YNmKhrkdNdTUWYla97OTf3+y+oEAkiVb1mbR/Uq934vitLufpQz
	geN02BG7x+QjDhg0UYUq0lCfTkMuTjJwn+jikSHW4EIFmg5eZsdz97LcRPGnP0AlALHm6N
	/N0GKq8LX2vN4kY2fWhVMlGgtXjpxsw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 269E65BD69;
	Wed, 29 Apr 2026 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777485673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cklHMklyuItTZV8ao77zjF0U5CZlwBoE5/zLT3mlMFU=;
	b=CvYCDdqpvzHqpz2CdBqdHqqOJvGOBCQikaWV/6+iJrKt04keMqXZq0HYu/CVngOCiz3lYJ
	otybJ9y69h4RqGmEBtps77mTpiQeOl9DyrrgU94u7Xm+VLYhgiv8opMCvZkxOTrgBGRm+h
	12CRgek6ZcEAedLC0+qOJ3yoZ4GAjS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777485673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cklHMklyuItTZV8ao77zjF0U5CZlwBoE5/zLT3mlMFU=;
	b=k4qN3aKjrfCgc04jBjoeWs8I1KDD5NlcFheP+LM8oMy49tfRhS03N9BfTf69kre49B01iS
	SvKEIFAcuTcRPXCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777485673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cklHMklyuItTZV8ao77zjF0U5CZlwBoE5/zLT3mlMFU=;
	b=CvYCDdqpvzHqpz2CdBqdHqqOJvGOBCQikaWV/6+iJrKt04keMqXZq0HYu/CVngOCiz3lYJ
	otybJ9y69h4RqGmEBtps77mTpiQeOl9DyrrgU94u7Xm+VLYhgiv8opMCvZkxOTrgBGRm+h
	12CRgek6ZcEAedLC0+qOJ3yoZ4GAjS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777485673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cklHMklyuItTZV8ao77zjF0U5CZlwBoE5/zLT3mlMFU=;
	b=k4qN3aKjrfCgc04jBjoeWs8I1KDD5NlcFheP+LM8oMy49tfRhS03N9BfTf69kre49B01iS
	SvKEIFAcuTcRPXCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11285593B3;
	Wed, 29 Apr 2026 18:01:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LtDRA2lH8mnWOwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 29 Apr 2026 18:01:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C2E23A0B77; Wed, 29 Apr 2026 20:01:04 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] fs: Add throttling to deferred inode reclaim
Date: Wed, 29 Apr 2026 20:00:53 +0200
Message-ID: <20260429180056.29598-7-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260429174850.18223-1-jack@suse.cz>
References: <20260429174850.18223-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7925; i=jack@suse.cz; h=from:subject; bh=gsWzr+H1ymTOyBF3QVYLRNhN+/vGEl5Nzp/a3LYbOlQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBp8kdag706q4HDCNkOexUtc77pH3FYK1VOsHkZ4 UU3n1wCkX2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCafJHWgAKCRCcnaoHP2RA 2Z+ZCACKGQXldhrF1YN4QvqGicFOR2Xgx+RpXCQ4+8ucHwiHmzGJZUklNN9VjIz9+K4wfZ/u5HS vw6qBigtVLZ9hy5CiKcayhfyupef39C06zMpDK6UsLuzXNM4IFq8fegp9PYgYVvHLPUzStS1uJX qUIFA0cNogFooKozQHBjK0M5NwNKT/bVMSQD0m1ZyoxJPklSOkIoLZ9XlOtOYr9Kjd3ONwh2P1E e2XN8g93pPnvas9unvyu6M0tm6Xxi0famIzlm0RhESTjYxKzYyEXesjqSaOQ504cGLn8u6C2Vhh jHPiLZgcz+DHi2YtQPyPO+F0MEIUOd5Xtce0IReamQUmpNee
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 601C940007
X-Stat-Signature: 61esjhjabrwfqq6sj3xmgh9d81kbmzmw
X-HE-Tag: 1777485696-67725
X-HE-Meta: U2FsdGVkX1//HXTqdauWxi+eMyvFOddaR/BWYV75f6Hvg1gaXBVAxBrPFD2Z99C4SdRdwvkW8AmoPsEzD2+eA6DLAlEkkIH9KkHhI0Qqbc7cfB+OXz5sg0ae5LuclTMygoO1f6Ox0zJ385KMLCY8h+EAO9QpM1/CZmh6EbsC2H0MBPgO5W93MrrcpQPLl4/aLXMWQEo8hcDPmFuFbDeqwym5icPzyWf15Qnb3mA1KH3fWLw8wfjWj/5wDBhaZj/v4/I8ANubVDZ7upvQ5boLss2K5TMproStn9z4ryORHuPYX0V/pnl5jzdOWHsxdarwWMSjv6KbTFDRnJpCw8k1GjSvrjs73+0CyXoxrxUah77rk5Qv080U4pTifLlMTqpQidjp9iumW3490AwxCXa0heiYrYJFGTWVikVm8GT38dM6FRWMJ15vQBTApY67I661DCjNIK/9vF3hTPbJlYAOtES5xkl6KMIs2iQTMboxNqUgy7kPmSSuWmSPVu+CpOMOjCDNXDkF46eahe59lsIoeqUmuz6+NrmtYaTpSqETIRHScDkwlrXyjNCeXRH7tjngLBKZSf9aSktte1uWkM8uWrjuB4AhUJQireXpo/9Cm2kzxw+4dEf0Cf25qOPjAAYHyN0e0tNJSN78p3SHi1/C5ZG7otGFnENXzTQSt31K56fki1rezSNTZ/8toqP/fNQCOac/rZkwSY5zAkUCDS4KFyTh6aHABrr9M2nYr+lTHJhhFQCOdoiVd6X/+lUTDEvVZUJDJ48HME3F4pMB27ZLauyPhxsB8OrbMAHmYZUBbNVEsno7nyJ918DNzN/P3bd207ifoDbgW4C0Yp6jpILo5jMrmDSJkLSTpnupq+aXo7aFCbYHbr1x/pZoRORBUl/HyneMfrhF9+x0U7BPfEp2NiRCFtbqdJCI7Lk9U5bLfrgQP3LJfNCC8LElQiwVMs5sSAy+xubEmQAuPsUGnlk
 IJ1IWPbS
 4J/z61+3+zBLbIWyReIeK6k5rLbbGJJrYw3pOvpXaRBNoLr5m7qkYBp/btelscKF8oFE+F20ANLFFeUm8mJWLHQHw5gMebSybDZyz5XbT4slCYJ/W+OgQ9TYt7+znTP8t7EE/shR/oOXWGvgHdWoehIDO3ArAtys9mMhyFN1x1eNumT+VljUXRQo6sln6JMhKOpk1MxO7zfyeG42uEQaEbFYuE3l+DkCfcZwunkfpl64PZg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deferring difficult inode reclaim from prune_icache_sb() to a workqueue
removes the natural feedback loop of blocking tasks in direct reclaim
until they make space for new allocations. This can result in the list
of deferred inodes to grow beyond any bounds and possibly push the
machine to a reclaim storm or OOM.

Add a throttling mechanism slowing down tasks in
mark_inode_reclaim_deferred() if the list of deferred inodes to reclaim
grows over limit. We measure average time it takes to reclaim inode on
deferred list and block tasks proportionally to that.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c                       | 94 +++++++++++++++++++++++++++++---
 include/linux/fs/super_types.h   |  2 +
 include/trace/events/writeback.h | 51 +++++++++++++++++
 3 files changed, 139 insertions(+), 8 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 448e3d7ee48e..fe39f96fbc80 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -941,6 +941,7 @@ EXPORT_SYMBOL_GPL(evict_inodes);
 struct inodes_to_prune {
 	struct list_head freeable;
 	struct list_head deferred;
+	int deferred_count;
 };
 
 /*
@@ -1013,9 +1014,10 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	WARN_ON(inode_state_read(inode) & I_NEW);
 	inode_state_set(inode, I_FREEING);
 	/* Inode will take long time to cleanup. Offload that to worker. */
-	if (inode_state_read(inode) & I_DEFER_RECLAIM)
+	if (inode_state_read(inode) & I_DEFER_RECLAIM) {
 		list_lru_isolate_move(lru, &inode->i_lru, &lists->deferred);
-	else
+		lists->deferred_count++;
+	} else
 		list_lru_isolate_move(lru, &inode->i_lru, &lists->freeable);
 	spin_unlock(&inode->i_lock);
 
@@ -1052,27 +1054,58 @@ long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 		if (list_empty(&reclaim->list))
 			queue_work(system_dfl_wq, &reclaim->work);
 		list_splice_tail(&lists.deferred, &reclaim->list);
+		reclaim->len += lists.deferred_count;
 		spin_unlock(&reclaim->lock);
 	}
 	return freed;
 }
 
+static void inode_reclaim_update_stat(struct inode_deferred_reclaim *reclaim,
+				      struct super_block *sb, unsigned int n,
+				      u64 start)
+{
+	u64 end = ktime_get_ns();
+	u32 delay;
+
+	delay = div_u64(end - start, n);
+	/* Smooth delay updates with exponential moving average */
+	reclaim->delay = (63 * (u64)reclaim->delay + delay) / 64;
+
+	trace_inode_reclaim_update_stat(sb, n, delay, reclaim->delay);
+}
+
 static void inode_reclaim_deferred(struct work_struct *work)
 {
 	struct inode_deferred_reclaim *reclaim =
 		container_of(work, struct inode_deferred_reclaim, work);
+	struct super_block *sb = NULL;
 	struct inode *inode;
+	u64 start;
+	unsigned int batch = 0;
 
 	spin_lock(&reclaim->lock);
 	while (!list_empty(&reclaim->list)) {
 		inode = list_first_entry(&reclaim->list, struct inode, i_lru);
 		list_del_init(&inode->i_lru);
+		reclaim->len--;
 		spin_unlock(&reclaim->lock);
+		if (!sb)
+			sb = inode->i_sb;
+		if (!batch)
+			start = ktime_get_ns();
 		evict(inode);
+		batch++;
+		/* Batch stat updates to avoid excessive computations */
+		if (batch >= 64 || need_resched()) {
+			inode_reclaim_update_stat(reclaim, sb, batch, start);
+			batch = 0;
+		}
 		cond_resched();
 		spin_lock(&reclaim->lock);
 	}
 	spin_unlock(&reclaim->lock);
+	if (batch)
+		inode_reclaim_update_stat(reclaim, sb, batch, start);
 }
 
 static struct inode_deferred_reclaim *inode_deferred_reclaim_alloc(
@@ -1091,20 +1124,65 @@ static struct inode_deferred_reclaim *inode_deferred_reclaim_alloc(
 	return sb->s_inode_reclaim;
 }
 
+/*
+ * Size of deferred reclaim list from which we start throttling tasks creating
+ * inodes marked for deferred reclaim.
+ */
+#define INODE_DEFERRED_RECLAIM_LIMIT 8192
+
+static void throttle_inode_deferred_reclaim(struct inode *inode)
+{
+	unsigned int len;
+	struct inode_deferred_reclaim *reclaim =
+				READ_ONCE(inode->i_sb->s_inode_reclaim);
+
+	if (!reclaim)
+		reclaim = inode_deferred_reclaim_alloc(inode->i_sb);
+
+	/*
+	 * If inodes with deferred reclaim are accumulating too much, slow down
+	 * tasks creating them. This doesn't provide any kind of guarantee on
+	 * the length of the deferred list since lots of inodes with
+	 * I_DEFER_RECLAIM can be already present in the inode cache and we
+	 * have no control when they reach the deferred list. But if the
+	 * pressure on the deferred list is sustained, the balance should
+	 * eventually be established.
+	 */
+	len = READ_ONCE(reclaim->len);
+	if (len > INODE_DEFERRED_RECLAIM_LIMIT) {
+		u64 delay = READ_ONCE(reclaim->delay);
+
+		if (!delay)
+			return;
+		/*
+		 * Scale the delay based on how much we exceed the limit. Wait
+		 * at most 4x as long as estimated time to reclaim the inode.
+		 */
+		len = min(len, 5 * INODE_DEFERRED_RECLAIM_LIMIT);
+		delay = div_u64(delay * (len - INODE_DEFERRED_RECLAIM_LIMIT),
+				INODE_DEFERRED_RECLAIM_LIMIT);
+		trace_mark_inode_reclaim_deferred_throttle(inode, len, delay);
+
+		schedule_timeout_killable(nsecs_to_jiffies(delay));
+	}
+}
+
 void mark_inode_reclaim_deferred(struct inode *inode)
 {
-	struct inode_deferred_reclaim *reclaim;
+	bool throttle = false;
 
 	if (inode_state_read_once(inode) & I_DEFER_RECLAIM)
 		return;
 
-	reclaim = READ_ONCE(inode->i_sb->s_inode_reclaim);
-	if (!reclaim)
-		reclaim = inode_deferred_reclaim_alloc(inode->i_sb);
-
 	spin_lock(&inode->i_lock);
-	inode_state_set(inode, I_DEFER_RECLAIM);
+	if (!(inode_state_read(inode) & I_DEFER_RECLAIM)) {
+		inode_state_set(inode, I_DEFER_RECLAIM);
+		throttle = true;
+	}
 	spin_unlock(&inode->i_lock);
+
+	if (throttle)
+		throttle_inode_deferred_reclaim(inode);
 }
 EXPORT_SYMBOL_GPL(mark_inode_reclaim_deferred);
 
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index 00744ae5be18..533256892550 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -133,6 +133,8 @@ struct inode_deferred_reclaim {
 	struct list_head	list;
 	struct work_struct	work;
 	spinlock_t		lock;
+	unsigned int		len;
+	u32			delay;
 };
 
 struct super_block {
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index bdac0d685a98..c0ae39b4dc7b 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -879,6 +879,57 @@ DEFINE_EVENT(writeback_inode_template, sb_clear_inode_writeback,
 	TP_ARGS(inode)
 );
 
+TRACE_EVENT(inode_reclaim_update_stat,
+	TP_PROTO(
+		struct super_block *sb,
+		unsigned int n,
+		u32 batch_delay,
+		u32 avg_delay
+	),
+	TP_ARGS(sb, n, batch_delay, avg_delay),
+
+	TP_STRUCT__entry(
+		__field(dev_t,		dev)
+		__field(unsigned int,	n)
+		__field(u32,		batch_delay)
+		__field(u32,		avg_delay)
+	),
+
+	TP_fast_assign(
+		__entry->dev = sb->s_dev;
+		__entry->n = n;
+		__entry->batch_delay = batch_delay;
+		__entry->avg_delay = avg_delay;
+	),
+
+	TP_printk("dev %d,%d batch size %u batch delay %u ns avg delay %u ns",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->n,
+		  __entry->batch_delay, __entry->avg_delay)
+);
+
+TRACE_EVENT(mark_inode_reclaim_deferred_throttle,
+	TP_PROTO(struct inode *inode, unsigned int len, u64 delay),
+	TP_ARGS(inode, len, delay),
+
+	TP_STRUCT__entry(
+		__field(u64,		ino)
+		__field(dev_t,		dev)
+		__field(unsigned int,	len)
+		__field(u64,		delay)
+	),
+
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->len = len;
+		__entry->delay = delay;
+	),
+
+	TP_printk("dev %d,%d ino %llu deferred list len %u delay %llu ns",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->len, __entry->delay)
+);
+
 #endif /* _TRACE_WRITEBACK_H */
 
 /* This part must be outside protection */
-- 
2.51.0


