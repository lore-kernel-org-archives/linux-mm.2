Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DAAD106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8726B0109; Thu, 26 Mar 2026 05:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061466B010B; Thu, 26 Mar 2026 05:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C256B010A; Thu, 26 Mar 2026 05:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD5C56B0108
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8338C160C79
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:39 +0000 (UTC)
X-FDA: 84587759718.05.7241BB1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37FF740002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2Gqog0u7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fqFTVCwX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2Gqog0u7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fqFTVCwX;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+ZUth1tKXX0ZiI7up2I/VhlTIHl09BJjUwtjTmNbDA=;
	b=N63h3gs8z94f8FX4dISssJfbAJKBZfXDW8Etpo2MkhVnhQNHeJNDqDqZrcmm0oFWMblUen
	nNoVUFnzH+6yNPjciP/iVgRCnOXZTi7IZYyGRhhSA4X3axeFxhJOnt0VfSwEjgx6PzhFU1
	2KA4aSa4+CG5eqWVYUaNKMT8zqwVLOw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2Gqog0u7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fqFTVCwX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2Gqog0u7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fqFTVCwX;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518997; a=rsa-sha256;
	cv=none;
	b=emEuBmlUyuMP6OkDuT3SV93zQNXcNlxHMtvXWQFFe601tx0dZ/OYG961z6qETfzOqvVsM9
	a3UUWDkvD6gqVQCynlXocFgGNm3Q7NbVoq3t9SJFJkcYYV8U7gDkHQ3BFJBsVcaperrjGF
	iMEHy1oCX94LYMfDQ5dGrwgLWlbILpA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C7BD5BDB3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6+ZUth1tKXX0ZiI7up2I/VhlTIHl09BJjUwtjTmNbDA=;
	b=2Gqog0u7qh4PuOZBKtKWV2lIxV8WwiuElfirq7GgaRyO1nAHuBlCL/An4bY3C2LBp4cA6Q
	8JWvz3OiLsrbG+ZIQ4UFku6G53TiaY/rJvXrA+Ieod4hqg24GrDevWVeMpn0WNm0tthRqP
	qZo+ntsh6Bm5jjP0vKYco6E7cBVmKj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6+ZUth1tKXX0ZiI7up2I/VhlTIHl09BJjUwtjTmNbDA=;
	b=fqFTVCwXQpzIFmejXE3OB8AgfRlxJ4yXBHDJQhRf4kyFut0c6DmOBcIzVNFOPFTBxnIEKU
	Br4hNdjHH06BxBCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6+ZUth1tKXX0ZiI7up2I/VhlTIHl09BJjUwtjTmNbDA=;
	b=2Gqog0u7qh4PuOZBKtKWV2lIxV8WwiuElfirq7GgaRyO1nAHuBlCL/An4bY3C2LBp4cA6Q
	8JWvz3OiLsrbG+ZIQ4UFku6G53TiaY/rJvXrA+Ieod4hqg24GrDevWVeMpn0WNm0tthRqP
	qZo+ntsh6Bm5jjP0vKYco6E7cBVmKj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6+ZUth1tKXX0ZiI7up2I/VhlTIHl09BJjUwtjTmNbDA=;
	b=fqFTVCwXQpzIFmejXE3OB8AgfRlxJ4yXBHDJQhRf4kyFut0c6DmOBcIzVNFOPFTBxnIEKU
	Br4hNdjHH06BxBCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6EC5B4A0A8;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nWD/GnUCxWnrYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 84FBAA0C74; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 30/42] fs: Move metadata bhs tracking to a separate struct
Date: Thu, 26 Mar 2026 10:54:24 +0100
Message-ID: <20260326095354.16340-72-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11992; i=jack@suse.cz; h=from:subject; bh=YdvQcXpzVIE/5wk9piV7s051s369O9z8dW1705+xcWs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJM0hqf0FzMkktcRWAJkssblEBwKXGuf60WU DPDaNoDyl+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCTAAKCRCcnaoHP2RA 2Z2TCADfLqtlAel4HKSFv4LI0HZ2GGiVoRpDlSw1eEMTS9QJ74CWIJfBK7c0i/510E3RDh/wlEn 7/O06yC1/NCnJhENUvZbyTlXvECDT9QsunJ8jtuZRZ8oHy9ddOFaJulsvh43LnKFRU+10QBSeG2 IGefxqOi4sTvPvc0R/19OFJ6xiOtSZiQPWeKk2L2yT4Kmc6DN13xMSj8feKC1SiAzmEPCICGGaU +Fu6AzYECsHU0Ie4BTpdDgZBoYBr7NhH7I2LR0XwqI8IzOaF80iahbpv7lxkaYUs7NxCItt9evf 6kkkslGpcqjOy2uBncw9MhxdjIuJoFpwqha8WGY1vvZD8wXf
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: p85zhcgq46zsmc734zqrerjwqaxawq8r
X-Rspamd-Queue-Id: 37FF740002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774518996-71691
X-HE-Meta: U2FsdGVkX1/gtzAMG3sv/xRTaOhp9seTw+gfCPjlUGFU0G79L4jxXtskFMvtPJRDmTt86+uc9/gnCm8tcV9LrOKFbc0eX0UB2+l98YYRlRk3aYGEl9grTU54QkvVuJsNbwf6DPX6FhHWf+qGRwD+wGd3ouAN7lInrdsxnQXWdL9NyygWBsbuT8xrC1VrIIBhDv5LdJQULGdy1ydozroWClpFw9sdBGl9UPZL1TKoo4WhycJDIaocFKMv6Y1qKTkiWi2j3Z3lyQRsfzSPMxxgZqN4zuNcdBzpqS7NS9HW7DeLQtDn/Ipkaa/j83xvFhswDB7elbE8H2YMKozJLIsjhLu0s0uyd4AvRvUib0q501ynHr7urYZzTf1XUGgljv+DzQtG7bPBsbZwYWlgUA/pmnm6b6ZIH7xLs/Zm0qYwYUAgxoI/7sWraQv6cUqKrutjQHo93Ci/7zCQJ74lQZ4MiEeakl+aD9R9EhZ5dP+44seyCHJ91kgXXpSgH9cCDZrNKprCMooaQu682rOnZ3Z5aL8hwYgcUoNOpVsuKcN5sRiP1+9YAxDQ4CejCSLEyKL4MDN4RrvEDCz+PmbXdsSmKUy0b/ulcZUHPADBj0HMJw345QrIgPFaqtDD0Y0L5Viq8ggDTUDZCMFsKW3hfpskKln9MkEdJoTe0V6RieT/4R1uen8Oz1DEw7/huiyR3QEDCNqVsMv0C8zJYG3EBn6h7nvUesEBKKRHQ+zghNOQhm5vilf+cWp4HRzJfL12L2mNawiOkELhmD7j+tq3hE6WLhLswpmhwidsI4uafPgOeak+Ayug551KFRu8f9bP2XaW4HwQ5VdMfwEd5rDf54bnSTymhiQ2kQmGZbJJrAsVeqWrA3MI44ikycuQ2ZGFYZ4Y9TQ184qYfLYEiCS2Fmm+aBF3Ui35Ap71A3WSfHCr0zOi+zbycLRRQOH4J/C7br2sUygcN1kT85ahwpZbZY/
 Wh3zunP6
 edNhlZtAWjgyLR+CpN6Sc50zWxXFoU7gvn4pnKLTWabqvIuAVBxpumrYQ1nJmZ+x9Nd/jl0ggx5wmL9v/pF3XwrAFLXEoVQpt7fkT5ZgeY0QnSE7vvSDi+WQNwdg94yAbz74ZEiO9MAQ7Dp9i0WWLzR4xFeuu4qO8qelWf4FFOTXRD8p9ztvRlMriM9XlfT36YA7l51gxhIwt0I7Df4Z2PcOJuL0HEMBG8XjyebGLutK3YOEH6d97iTU6XgE4+Fn21d1/1mLbLBRayvfVDrpgiY3uFtxq51y+Zbz83U7rcrkTWuxv7X9hLXcrxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of tracking metadata bhs for a mapping using i_private_list and
i_private_lock create a dedicated mapping_metadata_bhs struct for it.
So far this struct is embedded in address_space but that will be
switched for per-fs private inode parts later in the series. This also
changes the locking from bdev mapping's i_private_lock to a new lock
embedded in mapping_metadata_bhs to untangle the i_private_lock locking
for maintaining lists of metadata bhs and the locking for looking up /
reclaiming bdev's buffer heads. The locking in remove_assoc_map() gets
more complex due to this but overall this looks like a reasonable
tradeoff.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c        | 138 +++++++++++++++++++++------------------------
 fs/inode.c         |   2 +
 include/linux/fs.h |   7 +++
 3 files changed, 74 insertions(+), 73 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index fa3d84084adf..294f9cd07f42 100644
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
+	 * The locking dance is ugly here. We need to acquire the lock
+	 * protecting the metadata bh list while possibly racing with bh
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
index d488459396f4..76360b0040e0 100644
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


