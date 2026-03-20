Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F7E1098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C982F6B00D0; Fri, 20 Mar 2026 09:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C3E6B00CC; Fri, 20 Mar 2026 09:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981A46B00CC; Fri, 20 Mar 2026 09:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9326B00CE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30C0BC106D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:58 +0000 (UTC)
X-FDA: 84566557236.23.9CA353E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id D379C100015
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZf2ZBFpRjnWHatooisRljOocXg8yOtT5Jsbi6q6OWo=;
	b=wkQ86xoeY5qLT74695lo5w8NvUky41kiJHqLU0vYdqG/TqgoiscK64eQ7708Y5GhBOk5wz
	X+K6a9prH+9eIqXPI1CSYuaR0Fe+l08oQ1ZjEZIE5Aoj0SiEig1ni8kBfbumsD6rfeeBkP
	Iae8qDed5pSfSM5D7hfqgln1lUZ59eU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014176; a=rsa-sha256;
	cv=none;
	b=yuygodJgW1XRsCLeCI0gleraOjXpSGIDwGKApl63apTvHMBTdEizIzfcdL7Ri4+Lvm3HAb
	/hdWYWkItBndJ9vCXndCbAgHalnT5sSJk+C1a5EoCFLUhixT/7OEVwyQ93eInuZy5uTqWq
	KbA/92f1rPYeSod1jGT+JI611Rc8Uu8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8B9454D423;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E5DA42819;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9xHZHplOvWmFCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 49596A0B51; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 28/41] fs: Move metadata bhs tracking to a separate struct
Date: Fri, 20 Mar 2026 14:41:23 +0100
Message-ID: <20260320134100.20731-69-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11936; i=jack@suse.cz; h=from:subject; bh=d4wfbnQsGzeBo94sho0FVhxTGYKJVm6lS2ISpL9b2VQ=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGDL3+rVcvbrAaU6pzK6TNf6GtUv/FbG1iHgW9IssfdPZI f2T4XtlJ6MxCwMjB4OsmCLL6siL2tfmGXVtDdWQgRnEygQyhYGLUwAm8tyN/b//zTh2gzVMEl1v e/uyzSdw7Pv/T3F79AKr1/7Lbs/ilVOW42lcKaDlVvezvix7ZYxH/atcSeFo7dx9Yhc4ee/YsHx cU10Wcci0kVFi6ZTTdkZnszm3fMnXsTuuelZ4z61eYR1ZrZ4CA/dgHXeOe1K3VCzW7s92SNzyVa vaav1dfe6794O27rqjbHDjnS/vZh9mi6lLpvtsXtv9uqL2vKHGlL1Vqp0//nJVxntV739qvWrHZ zGzNomFb/5zbeu2cE2W+eWxUvpDOc9uu6UqByoOJ5yTVVvG4c2WeEmu1v+GdvbjW8nxU1cJBxtu 7DSo3vXCYFKz23c3sx4pnyt8B75vY2kP+LnRQ/pEUk4pAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: 4ru9m4gm4zqjq8fy4tdgachm11rqnssw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D379C100015
X-HE-Tag: 1774014175-122689
X-HE-Meta: U2FsdGVkX1/xjQt29kc7vK2aSNK0PrLvPK64LkjfqU2gRcG7qoKrV71eWj/alfBmY4Zz0sK06uQXOUZ/tFevmo6YlqmtE+LvvOXsq71NnRUVGmIRhsHe1BupwULKI15H90nxQc8zVHWMiYzxbbrJ8Et60qmUq/k/Jy+OA8dA2F7WerQkGAY/Ql50hBZocD0e8BWJDpT+lX+Kr/b0kLg2S1tZefI2kWI4L24QKFHiavPzgiJwP/GXPh8GL17V4bGCUNyV0RfPV5rKh7rmpVKEwvFnGpGUzKohUavY6gTt2daPIHXVR8CK69PbQIwAfBSOYD5ZOY8RP9mtVgKdM2NVpQxgz5Fy4iTPSFYefEIQ34rPbHgM/0LWWZro5tE9U+vQkoGI/cj8I3nP2v4TSzr/olJYpLybM4czgLfaEqCjAnI52GJdHodQoNIvSamAtVKOh9NeQ3ccF8QWC6+X4I0PYhyGRJqZwH5T2fqCaYK58KOD5o6eTwZn06yoVCnGk41j84YODuD0O2NPyEXwJ0kDMGw/SrEIWy5eEIcpgngW+zbBq3W6Igls8sRWe1MaQFGONBIWRnXlNRp3Oeeb1VW3V32CcqdxWirrhmc4ndbdOxVCkznosZ2M6KbX2BGQS+nHuTivzfdxJwu1oyw1rLPuhwCqKfoMSQro9jgjbNyNQE5lI4S1etDTLvl+gJR/AAI7gKEsEUAtiezGAqRmFNzA7EAehMNXKW6r/uiIbgM98VtCyfkDbDDHsXMQeLHNoMQyDKa1clPLPvmXcgam28wS6ExhyX7iljcJnG1EbeMj25quK6FibsXyxBuz8tgSzzVpBIEaqhQbJHAvemEesBu/3hEd9z/RGD6cb1vLsAhZHeosKyyGObddSPHxu1e8CaSiDJNzfZiZIA2GrwCnZ81arp8MuLcNpW2Ujo5MbvT2XLXNLXGkMCfEQkw3LaufXA94s2COay04Ty0VJdNoh4H
 ZUH8Uuka
 fgq3smWSPESzjnxcywutljSKsPsVRxMeBRiXCFM8ObPOoTlUzinbBrc6IdjagCTMQKVl4WFYR92Z5ly6ljrixWIWKqO+tKLna8dOGB97y1rgkwWSEmUcHc5DRomLwJqoJFoMpBkEXN3VLZebqFn+61g/RtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of tracking metadata bhs for a mapping using i_private_list and
i_private_lock we create a dedicated mapping_metadata_bhs struct for it.
So far this struct is embedded in address_space but that will be
switched for per-fs private inode parts later in the series. This also
changes the locking from bdev mapping's i_private_lock to lock embedded
in mapping_metadata_bhs to untangle the i_private_lock locking for
maintaining lists of metadata bhs and the locking for looking up /
reclaiming bdev's buffer heads. The locking in remove_assoc_map()
gets more complex due to this but overall this looks like a reasonable
tradeoff.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c        | 138 +++++++++++++++++++++------------------------
 fs/inode.c         |   2 +
 include/linux/fs.h |   7 +++
 3 files changed, 74 insertions(+), 73 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index fa3d84084adf..d39ae6581c26 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -469,30 +469,13 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  *
  * The functions mark_buffer_dirty_inode(), fsync_inode_buffers(),
  * inode_has_buffers() and invalidate_inode_buffers() are provided for the
- * management of a list of dependent buffers at ->i_mapping->i_private_list.
- *
- * Locking is a little subtle: try_to_free_buffers() will remove buffers
- * from their controlling inode's queue when they are being freed.  But
- * try_to_free_buffers() will be operating against the *blockdev* mapping
- * at the time, not against the S_ISREG file which depends on those buffers.
- * So the locking for i_private_list is via the i_private_lock in the address_space
- * which backs the buffers.  Which is different from the address_space 
- * against which the buffers are listed.  So for a particular address_space,
- * mapping->i_private_lock does *not* protect mapping->i_private_list!  In fact,
- * mapping->i_private_list will always be protected by the backing blockdev's
- * ->i_private_lock.
- *
- * Which introduces a requirement: all buffers on an address_space's
- * ->i_private_list must be from the same address_space: the blockdev's.
- *
- * address_spaces which do not place buffers at ->i_private_list via these
- * utility functions are free to use i_private_lock and i_private_list for
- * whatever they want.  The only requirement is that list_empty(i_private_list)
- * be true at clear_inode() time.
- *
- * FIXME: clear_inode should not call invalidate_inode_buffers().  The
- * filesystems should do that.  invalidate_inode_buffers() should just go
- * BUG_ON(!list_empty).
+ * management of a list of dependent buffers in mapping_metadata_bhs struct.
+ *
+ * The locking is a little subtle: The list of buffer heads is protected by
+ * the lock in mapping_metadata_bhs so functions coming from bdev mapping
+ * (such as try_to_free_buffers()) need to safely get to mapping_metadata_bhs
+ * using RCU, grab the lock, verify we didn't race with somebody detaching the
+ * bh / moving it to different inode and only then proceeding.
  *
  * FIXME: mark_buffer_dirty_inode() is a data-plane operation.  It should
  * take an address_space, not an inode.  And it should be called
@@ -509,19 +492,45 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * b_inode back.
  */
 
-/*
- * The buffer's backing address_space's i_private_lock must be held
- */
-static void __remove_assoc_queue(struct buffer_head *bh)
+static void __remove_assoc_queue(struct mapping_metadata_bhs *mmb,
+			         struct buffer_head *bh)
 {
+	lockdep_assert_held(&mmb->lock);
 	list_del_init(&bh->b_assoc_buffers);
 	WARN_ON(!bh->b_assoc_map);
 	bh->b_assoc_map = NULL;
 }
 
+static void remove_assoc_queue(struct buffer_head *bh)
+{
+	struct address_space *mapping;
+	struct mapping_metadata_bhs *mmb;
+
+	/*
+	 * The locking dance is ugly here. We need to acquire lock
+	 * protecting metadata bh list while possibly racing with bh
+	 * being removed from the list or moved to a different one.  We
+	 * use RCU to pin mapping_metadata_bhs in memory to
+	 * opportunistically acquire the lock and then recheck the bh
+	 * didn't move under us.
+	 */
+	while (bh->b_assoc_map) {
+		rcu_read_lock();
+		mapping = READ_ONCE(bh->b_assoc_map);
+		if (mapping) {
+			mmb = &mapping->i_metadata_bhs;
+			spin_lock(&mmb->lock);
+			if (bh->b_assoc_map == mapping)
+				__remove_assoc_queue(mmb, bh);
+			spin_unlock(&mmb->lock);
+		}
+		rcu_read_unlock();
+	}
+}
+
 int inode_has_buffers(struct inode *inode)
 {
-	return !list_empty(&inode->i_data.i_private_list);
+	return !list_empty(&inode->i_data.i_metadata_bhs.list);
 }
 EXPORT_SYMBOL_GPL(inode_has_buffers);
 
@@ -529,7 +538,7 @@ EXPORT_SYMBOL_GPL(inode_has_buffers);
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
  *
- * Starts I/O against the buffers at mapping->i_private_list, and waits upon
+ * Starts I/O against the buffers at mapping->i_metadata_bhs and waits upon
  * that I/O. Basically, this is a convenience function for fsync().  @mapping
  * is a file or directory which needs those buffers to be written for a
  * successful fsync().
@@ -548,23 +557,22 @@ EXPORT_SYMBOL_GPL(inode_has_buffers);
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
-	struct address_space *buffer_mapping =
-				mapping->host->i_sb->s_bdev->bd_mapping;
+	struct mapping_metadata_bhs *mmb = &mapping->i_metadata_bhs;
 	struct buffer_head *bh;
 	int err = 0;
 	struct blk_plug plug;
 	LIST_HEAD(tmp);
 
-	if (list_empty(&mapping->i_private_list))
+	if (list_empty(&mmb->list))
 		return 0;
 
 	blk_start_plug(&plug);
 
-	spin_lock(&buffer_mapping->i_private_lock);
-	while (!list_empty(&mapping->i_private_list)) {
-		bh = BH_ENTRY(mapping->i_private_list.next);
+	spin_lock(&mmb->lock);
+	while (!list_empty(&mmb->list)) {
+		bh = BH_ENTRY(mmb->list.next);
 		WARN_ON_ONCE(bh->b_assoc_map != mapping);
-		__remove_assoc_queue(bh);
+		__remove_assoc_queue(mmb, bh);
 		/* Avoid race with mark_buffer_dirty_inode() which does
 		 * a lockless check and we rely on seeing the dirty bit */
 		smp_mb();
@@ -573,7 +581,7 @@ int sync_mapping_buffers(struct address_space *mapping)
 			bh->b_assoc_map = mapping;
 			if (buffer_dirty(bh)) {
 				get_bh(bh);
-				spin_unlock(&buffer_mapping->i_private_lock);
+				spin_unlock(&mmb->lock);
 				/*
 				 * Ensure any pending I/O completes so that
 				 * write_dirty_buffer() actually writes the
@@ -590,35 +598,34 @@ int sync_mapping_buffers(struct address_space *mapping)
 				 * through sync_buffer().
 				 */
 				brelse(bh);
-				spin_lock(&buffer_mapping->i_private_lock);
+				spin_lock(&mmb->lock);
 			}
 		}
 	}
 
-	spin_unlock(&buffer_mapping->i_private_lock);
+	spin_unlock(&mmb->lock);
 	blk_finish_plug(&plug);
-	spin_lock(&buffer_mapping->i_private_lock);
+	spin_lock(&mmb->lock);
 
 	while (!list_empty(&tmp)) {
 		bh = BH_ENTRY(tmp.prev);
 		get_bh(bh);
-		__remove_assoc_queue(bh);
+		__remove_assoc_queue(mmb, bh);
 		/* Avoid race with mark_buffer_dirty_inode() which does
 		 * a lockless check and we rely on seeing the dirty bit */
 		smp_mb();
 		if (buffer_dirty(bh)) {
-			list_add(&bh->b_assoc_buffers,
-				 &mapping->i_private_list);
+			list_add(&bh->b_assoc_buffers, &mmb->list);
 			bh->b_assoc_map = mapping;
 		}
-		spin_unlock(&buffer_mapping->i_private_lock);
+		spin_unlock(&mmb->lock);
 		wait_on_buffer(bh);
 		if (!buffer_uptodate(bh))
 			err = -EIO;
 		brelse(bh);
-		spin_lock(&buffer_mapping->i_private_lock);
+		spin_lock(&mmb->lock);
 	}
-	spin_unlock(&buffer_mapping->i_private_lock);
+	spin_unlock(&mmb->lock);
 	return err;
 }
 EXPORT_SYMBOL(sync_mapping_buffers);
@@ -715,15 +722,14 @@ void write_boundary_block(struct block_device *bdev,
 void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 {
 	struct address_space *mapping = inode->i_mapping;
-	struct address_space *buffer_mapping = bh->b_folio->mapping;
 
 	mark_buffer_dirty(bh);
 	if (!bh->b_assoc_map) {
-		spin_lock(&buffer_mapping->i_private_lock);
+		spin_lock(&mapping->i_metadata_bhs.lock);
 		list_move_tail(&bh->b_assoc_buffers,
-				&mapping->i_private_list);
+				&mapping->i_metadata_bhs.list);
 		bh->b_assoc_map = mapping;
-		spin_unlock(&buffer_mapping->i_private_lock);
+		spin_unlock(&mapping->i_metadata_bhs.lock);
 	}
 }
 EXPORT_SYMBOL(mark_buffer_dirty_inode);
@@ -796,22 +802,16 @@ EXPORT_SYMBOL(block_dirty_folio);
  * Invalidate any and all dirty buffers on a given inode.  We are
  * probably unmounting the fs, but that doesn't mean we have already
  * done a sync().  Just drop the buffers from the inode list.
- *
- * NOTE: we take the inode's blockdev's mapping's i_private_lock.  Which
- * assumes that all the buffers are against the blockdev.
  */
 void invalidate_inode_buffers(struct inode *inode)
 {
 	if (inode_has_buffers(inode)) {
-		struct address_space *mapping = &inode->i_data;
-		struct list_head *list = &mapping->i_private_list;
-		struct address_space *buffer_mapping =
-				mapping->host->i_sb->s_bdev->bd_mapping;
-
-		spin_lock(&buffer_mapping->i_private_lock);
-		while (!list_empty(list))
-			__remove_assoc_queue(BH_ENTRY(list->next));
-		spin_unlock(&buffer_mapping->i_private_lock);
+		struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
+
+		spin_lock(&mmb->lock);
+		while (!list_empty(&mmb->list))
+			__remove_assoc_queue(mmb, BH_ENTRY(mmb->list.next));
+		spin_unlock(&mmb->lock);
 	}
 }
 EXPORT_SYMBOL(invalidate_inode_buffers);
@@ -1155,14 +1155,7 @@ EXPORT_SYMBOL(__brelse);
 void __bforget(struct buffer_head *bh)
 {
 	clear_buffer_dirty(bh);
-	if (bh->b_assoc_map) {
-		struct address_space *buffer_mapping = bh->b_folio->mapping;
-
-		spin_lock(&buffer_mapping->i_private_lock);
-		list_del_init(&bh->b_assoc_buffers);
-		bh->b_assoc_map = NULL;
-		spin_unlock(&buffer_mapping->i_private_lock);
-	}
+	remove_assoc_queue(bh);
 	__brelse(bh);
 }
 EXPORT_SYMBOL(__bforget);
@@ -2810,8 +2803,7 @@ drop_buffers(struct folio *folio, struct buffer_head **buffers_to_free)
 	do {
 		struct buffer_head *next = bh->b_this_page;
 
-		if (bh->b_assoc_map)
-			__remove_assoc_queue(bh);
+		remove_assoc_queue(bh);
 		bh = next;
 	} while (bh != head);
 	*buffers_to_free = head;
diff --git a/fs/inode.c b/fs/inode.c
index d5774e627a9c..393f586d050a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -483,6 +483,8 @@ static void __address_space_init_once(struct address_space *mapping)
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
+	spin_lock_init(&mapping->i_metadata_bhs.lock);
+	INIT_LIST_HEAD(&mapping->i_metadata_bhs.list);
 	mapping->i_mmap = RB_ROOT_CACHED;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 10b96eb5391d..64771a55adc5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -445,6 +445,12 @@ struct address_space_operations {
 
 extern const struct address_space_operations empty_aops;
 
+/* Structure for tracking metadata buffer heads associated with the mapping */
+struct mapping_metadata_bhs {
+	spinlock_t lock;	/* Lock protecting bh list */
+	struct list_head list;	/* The list of bhs (b_assoc_buffers) */
+};
+
 /**
  * struct address_space - Contents of a cacheable, mappable object.
  * @host: Owner, either the inode or the block_device.
@@ -484,6 +490,7 @@ struct address_space {
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
 	struct list_head	i_private_list;
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct rw_semaphore	i_mmap_rwsem;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
-- 
2.51.0


