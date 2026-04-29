Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81989CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5256B0092; Wed, 29 Apr 2026 14:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EACA46B0093; Wed, 29 Apr 2026 14:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2F96B0095; Wed, 29 Apr 2026 14:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC5B86B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:01:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67EB34036B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:01:32 +0000 (UTC)
X-FDA: 84712360824.29.A1F81AB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id AF9E640022
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:01:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B63E5BD5F;
	Wed, 29 Apr 2026 18:01:13 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E15C593B2;
	Wed, 29 Apr 2026 18:01:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1VP+AmlH8mnSOwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 29 Apr 2026 18:01:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B3185A0B58; Wed, 29 Apr 2026 20:01:04 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] fs: Avoid inode dirtying on last iput
Date: Wed, 29 Apr 2026 20:00:51 +0200
Message-ID: <20260429180056.29598-5-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260429174850.18223-1-jack@suse.cz>
References: <20260429174850.18223-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4387; i=jack@suse.cz; h=from:subject; bh=SSEDyQSsnTljBuZkH4G76XXlupHO6EhbkJWul7NRrlc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBp8kdYM83n7MKMaejGcSupGo8FHCBBGMrASXZnR /A+BdOTtneJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCafJHWAAKCRCcnaoHP2RA 2cmzCADB6U4KLmNFroc11BkAzf28Dd0hxbaEgGq9+otmvm/noWWNGMnyTwQT8b/ttGdMAtfZGoj oiQhYXDjd0Ld9tW6oPld5JxLiaVxZC+X13RS1i6WtWKDiIb/UvGAoEpKQujmxAxRV3vtJJXHnP/ ra06nnfsBY4ULOuYHYYKh2/UZAGCEv1m2QXqyv0N5H4fvOBeObTGvvPov97ZeL3dwetdMqjjk7R SeoOItISyUzrTWfPlpKADPWoXeS6GLXX8JPfMvNtcNWoye4VDPlyU9X1Rh4wxpNBQzHdQdl36kt VYYW1w/GDuf5G0pQcXSOROuBqUIbuzNd5OUzXTQU6M4sJ/pZ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AF9E640022
X-Stat-Signature: gyu1a873igutmgefxc9ocomumtq7utqq
X-HE-Tag: 1777485681-929092
X-HE-Meta: U2FsdGVkX1+zqxcAyeQ39nRQimuXh7Ab/yMjybKy+rrLRN7G8YpLY0CJYak/ahT9POrcIbm29rm69UjA2pFpY1JyrdiqhxG9tR5aKSnSdIiaWIg5pvVzTIrfqYilCfbU/adFSXJGHaowM+XGVv0SS9XebqurG9007oxftKw4PjAKV34RzbJ/fldQquQxRgeZnCirHLP99uw/KtTqUs9HTLzx6mJhjPb071MzTXuxfRjwyGNgVqGfOPkq82okMEsvRrxXtvS/jWrHEnCCs27GSOZCa0qkN4RaR/5Tuo2aa0285lVBCOYBvN0h8rvlDPW9lnf/vnkul/u4ZGOl+egTi1Kjnwa/YVuCToGeRst0cy9y+PvaUB6vd5mJlhAgzeh+reBbq3nWtc9KSSqOA1mtmDg5bKPglCFGbHl7d9d2yys0Rfv2yt39thEQ4xWxFvBoS8zTL8fBBX6OhKBsvNvC76l2xFwMm/qs0RcMpJKK3v+9QCwmELjKHnKA8OkZJJnMVO4CMyV+u/cGCc53l0xpSeE78UpaYdNelhWrwWlTad3OwrXseFKck1HPo7a0tNd4RJ1avBupKKt+KSb3Zuv/cmpEIxE/Zkn3y2ra1Aldd/Xk/AkV7V7qI1tykOIFkdbKaZkdf6AiUAnvxUszwsQFLy0qBYyM5O386gKXcc+V5jldvFOXjKGNLyHuKe6wJypi6k+/Hfc0JU8cCdM3W63XIIE1WoJJegoZSYCYFs2uuvXm0MpnFf8uTyyE8zl84IznBmSDvH4DhtaFX3zO9FvW2fwA5LDHuMBg5x2O+aGBiUZMt23DbJqdqMdjILVlBQZeUOUpS0Db0vCMcGe337Y4JeAG7v0IFaz+jAcMzER3Au3TT1wpUbcE9sgNkC+VI3OneDkf81B5Jn7F01mI95n3VG8fFdQKYp5selRxypt40LIAx5fDknOB/XBLJ0fOVkxub2pD7JKmhEkHXV21ZAR
 dO388sJQ
 F4oQIkDMCqOzoFGXBZuZlWrjDAjku4x3J1zOVh60ZtDyb+IfxgQUJmsrU8dH/yCdeZEdNNc5KblwZgrs65HXwj/x0QUdjF/7WbaTr1YdTYhlYpl7hAUJlLMB07n5E5XXiXGN8jXgupm0s9PfoXVbmbRVYPOUhnENJCQvbH19QxHaHEodd6dfy51OyUXTtF7544UQ9lDwNCChn1Nl5aEBWn/gIX0kXFxTtesL3izoJjXi2DOBm9AAQmX274ixKi/tcigGe6JQWKI5PxDOb9WT4iZLDX8Q3bXMY1tBar0GOJct1nBanWoxV8MIWkuRrRJbF6qQEw4CizM31m8RUOa6u+QzJGob7XzCQd3g7Z0px18MOamnJWxAzHczO7Ot+EW3oxUFCpTtCEJWXBcKg1sGqdvaPZ4qA4yYHfO7wCZoJfrhDzK7PGgZgR8Zm6mMu5rxMHRCdNXfeLc0LVifn3zixgdTNhk/ZPwW4hOuNV7JlgZJU1Ykm7oG8JPdtraIDAnSzRNxM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When inode has dirtied timestamps, we currently call sync_lazytime() on
last iput. This is done because inode with any dirty bit set is not
inserted into LRU and dirty timestamps expire only after many (12 by
default) hours so these inodes would be sitting outside of LRU aging for
a really long time. However this can result in doing IO and consequently
GFP_NOFAIL allocations from dentry reclaim making MM complain. Sample
trace for ext4 is:

prune_dcache_sb
shrink_dentry_list
__dentry_kill
iput
sync_lazytime
__mark_inode_dirty
ext4_dirty_inode
__ext4_mark_inode_dirty
ext4_reserve_inode_write
ext4_get_inode_loc
bdev_getblk
__filemap_get_folio_mpol

Avoid this dirtying on last iput by reshuffling unused inodes to the
beginning of b_dirty_time list and clobbering dirtied_time_when instead
so that they get written during next periodic writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/inode.c        | 15 +++++++--------
 fs/internal.h     |  1 +
 3 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e1fbdf9ee769..acc27fbe4230 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2729,6 +2729,51 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
+/*
+ * If inode has dirty timestamps to write out, make sure flush worker writes
+ * them out during its next periodic writeback writeout.
+ */
+void queue_dirtytime_writeback(struct inode *inode)
+{
+	struct bdi_writeback *wb;
+	unsigned long new_time;
+
+	lockdep_assert_held(&inode->i_lock);
+
+	if (!(inode_state_read(inode) & I_DIRTY_TIME))
+		return;
+
+	wb = locked_inode_to_wb_and_lock_list(inode);
+	spin_lock(&inode->i_lock);
+	/*
+	 * If inode writeback is already queued or inode got dirty, we have
+	 * nothing to do and we mustn't touch writeback lists anyway.
+	 */
+	if (inode_state_read(inode) & (I_SYNC_QUEUED | I_DIRTY))
+		goto out_wb_lock;
+	/* Written back while we dropped i_lock? */
+	if (!(inode_state_read(inode) & I_DIRTY_TIME))
+		goto out_wb_lock;
+
+	/*
+	 * Move inode to the beginning of dirty queue and clobber dirtied time
+	 * so that it gets written out during the next periodic writeback.
+	 */
+	new_time = jiffies - dirtytime_expire_interval * HZ;
+	if (!list_empty(&wb->b_dirty_time)) {
+		struct inode *first = wb_inode(wb->b_dirty_time.prev);
+		unsigned long first_time = READ_ONCE(first->dirtied_time_when);
+
+		if (time_before(first_time, new_time))
+			new_time = first_time;
+	}
+	inode->dirtied_when = new_time;
+	inode->dirtied_time_when = new_time;
+	list_move_tail(&inode->i_io_list, &wb->b_dirty_time);
+out_wb_lock:
+	spin_unlock(&wb->list_lock);
+}
+
 /*
  * The @s_sync_lock is used to serialise concurrent sync operations
  * to avoid lock contention problems with concurrent wait_sb_inodes() calls.
diff --git a/fs/inode.c b/fs/inode.c
index 6a3cbc7dcd28..276debcd3e20 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1975,7 +1975,6 @@ void iput(struct inode *inode)
 	if (unlikely(!inode))
 		return;
 
-retry:
 	lockdep_assert_not_held(&inode->i_lock);
 	VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR), inode);
 	/*
@@ -1988,14 +1987,14 @@ void iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
-	if (inode->i_nlink && sync_lazytime(inode))
-		goto retry;
-
 	spin_lock(&inode->i_lock);
-	if (unlikely((inode_state_read(inode) & I_DIRTY_TIME) && inode->i_nlink)) {
-		spin_unlock(&inode->i_lock);
-		goto retry;
-	}
+	/*
+	 * If inode has timestamp updates pending, queue flushing them now as
+	 * otherwise the dirtiness could be preventing the inode from entering
+	 * LRU for hours.
+	 */
+	if (inode->i_nlink)
+		queue_dirtytime_writeback(inode);
 
 	if (!atomic_dec_and_test(&inode->i_count)) {
 		spin_unlock(&inode->i_lock);
diff --git a/fs/internal.h b/fs/internal.h
index d77578d66d42..7c8f452d28c6 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -219,6 +219,7 @@ bool in_group_or_capable(struct mnt_idmap *idmap,
  */
 long get_nr_dirty_inodes(void);
 bool sync_lazytime(struct inode *inode);
+void queue_dirtytime_writeback(struct inode *inode);
 
 /*
  * dcache.c
-- 
2.51.0


