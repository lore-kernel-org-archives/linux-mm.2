Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B07C106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1986B00E8; Thu, 26 Mar 2026 05:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B04D6B00EC; Thu, 26 Mar 2026 05:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E443A6B00EE; Thu, 26 Mar 2026 05:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFE1C6B00E8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 709F85CA17
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:33 +0000 (UTC)
X-FDA: 84587759466.05.7660780
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 238AC180008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ASU5o0/Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pUfVOkmG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ASU5o0/Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pUfVOkmG;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518991; a=rsa-sha256;
	cv=none;
	b=XdvMu4Pvie8h2989LKGsFnTlPfZ4GgHvwO2byMdcjyZl9tYPpecIN/VfNGZShJlWcVHEjl
	ssOHCm39mV3Sb1+NO26/wO6dQyNoVvenfCJWeSo54dLvWqisz8xHGDiJHlKzfZeY+JmOut
	QNG74vjNzsNa7EqrA0NGEgXJMCPeLfw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ASU5o0/Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pUfVOkmG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ASU5o0/Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pUfVOkmG;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=byWU+6eyDTGDwPUjgaBLCOfLPFKdylFnJfWF0eWyWuE=;
	b=pQH7vlPvCJa079Dr/simv3ydbbeo1Rv8oThbECJWmGhmpAzhQ2QVbW3PIQiI/7PSOidCWZ
	KIUBILH9ctid8Wa5MqETXYAf65b0DS9Csdsxxhby6RoCaUP67mV24VJ+v4rmB7edqdU0oa
	+vUmI8Q7lGHvYu//S70Kp3DINiFNiH8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7E0485BDBB;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byWU+6eyDTGDwPUjgaBLCOfLPFKdylFnJfWF0eWyWuE=;
	b=ASU5o0/YYWXbVR26pgaXFebCL3930P3+EUIlfiuWBRdfhgqtM2Qjg7UaRPJJzW4ZreAFxR
	GT1Y6RIvQKE4QxCDaEVPmm1NH7AYvZWQJAD4VNO7SJye5TunzbhZMbuykOWifh1qSZCCcP
	gZXucSGJrLv1j2Bf6MCLIIBAQUa8+gY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byWU+6eyDTGDwPUjgaBLCOfLPFKdylFnJfWF0eWyWuE=;
	b=pUfVOkmG7lb1lIZtjgEhqeCJUz6PcAJezbQNUrhi0HJ2Cy6ieRhpb3OcVwB5qVh8RDLep3
	mSsVjQWUchYWvQDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byWU+6eyDTGDwPUjgaBLCOfLPFKdylFnJfWF0eWyWuE=;
	b=ASU5o0/YYWXbVR26pgaXFebCL3930P3+EUIlfiuWBRdfhgqtM2Qjg7UaRPJJzW4ZreAFxR
	GT1Y6RIvQKE4QxCDaEVPmm1NH7AYvZWQJAD4VNO7SJye5TunzbhZMbuykOWifh1qSZCCcP
	gZXucSGJrLv1j2Bf6MCLIIBAQUa8+gY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=byWU+6eyDTGDwPUjgaBLCOfLPFKdylFnJfWF0eWyWuE=;
	b=pUfVOkmG7lb1lIZtjgEhqeCJUz6PcAJezbQNUrhi0HJ2Cy6ieRhpb3OcVwB5qVh8RDLep3
	mSsVjQWUchYWvQDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 712924A0A6;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8rSfG3UCxWntYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7C650A0C73; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 29/42] fs: Fold fsync_buffers_list() into sync_mapping_buffers()
Date: Thu, 26 Mar 2026 10:54:23 +0100
Message-ID: <20260326095354.16340-71-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7567; i=jack@suse.cz; h=from:subject; bh=f6izt04fZCFJQSkSrf7dTi/3Cbur8ValvknA2hTJ8Bo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJLlQqRFKEeG5RqvmZU02Tl0MdB1/bLQi5a0 XfukSttZ9yJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCSwAKCRCcnaoHP2RA 2UhsCADJWf4qvR904MZ1Xs38Xnpv48CssgT5ZAAeT7048r9JjF3XKdrMqvfzxCMuDzpsYW2/TVJ zvp1pyOmzdfjFtAe5JJOvE3lm1DbibJ092f9I6J3V2DHMf/0cggTc4flNIyaL4QuIepoKD0Upwu Ubpc3wJiKVNBzCmPZbFHlMJLvCwdfk14YCirMSwn22iEAXxQAwCVZz+i3VZRI+gA04oQCCmBEF0 SKC/ZcSUoPTPYuVp9YTQZEoAycs64RrnYdN2yy5HO1vW7mrjWFz1Mq6JVmFlWps30mM9tmCQcej XpVTUVLDxz1snBUc37I2ZAmOttVFWGkWJvzF2RHIb7gUJkgU
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: 5s3jeenw36sq3zxn9ru4os9oxzfnj1kx
X-Rspamd-Queue-Id: 238AC180008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774518990-54934
X-HE-Meta: U2FsdGVkX1+Ndy4gn4FXIfngnQSeWa9hjM3VEhIkMup3CavAMm3pBmhawyzc0RyVKETmQn4tOplHRLAXpi2QlMCrfCwjVNCrFFUrtVJW2PpiIqvU/xQaQ7Uyv8SLK/eZQxIEaBl7AJH0r+erYJeay10rfQPrjzYjfYu9kGEQOD6g5nrb9raImlPEeY8UI2dWocS8vzrpXRFFBGTMjxB2lN3T0YDqHT18o0OmwNRPRTsXDNOtwgb4g1bPQ8/PF78aCnGCvhxCbZRSClay+vy+Hr9YGzB/2fiF4f+/oFIqxjgZEpmzXMR6paAxqeUeFKELPJ8tKc3JW6/1MlcW1d8GSxzxEOQbgAk/l2wPod43rnfKzec4JbTfIfyifEj1TfbwxgY3dW8WzEjJ4IrZg6Arpgt7fcxtgDu9AFQoHTJdaaLOwQFueFqskKS+R0pbNw/MyrurniSeLPCDmgbxDELL5IVAzV5C0/prAjcm78W/4xH2G7QtvdsStHfSCoHi1JlEJTbjUXkWVSwuSBwpqx8E4Kz66p9mVF3QaAPxVv7AP99Jnl1U9vOUCgDDRgqwV+LOMw6DGJDn2GuQ5sM6Aow5H2ByCJ79gwnGvI4e/nkS2PN5mLEUYa+qVC42p5dAixbfjAu6BRly7YNWT+nE/A8tuTZJ7OXLJ2WzKYyN2LaP6+r1an7MzOCKQI1XALJUnS+TrqX8GeN8N54fbT6D2nrXViuYe0Mc5JM46c1+pE88uU8ueRy/M198CveHCOpZpzP7D5PHXT8+vw4/kfYGQOVXQPVtNE9mPy9Z16DPFol9fB4LhCIzPpLlT3cdV+YJGlNF2y/q6ekhxFzFHaNnMZ97bhAmYaRSTPS9/RE9HQWJYmwSaE+nq+X2XA/BSFFzDVgdKUFMupJpiH09A03AsY/V7ZbNEOpKGhmkOY0LkKXdGqrWEbr0pIR7xwxVOi+Db3h91tl/B6wRUrLHZ5bRu4T
 sY10jNJK
 i0aGyXEzAUDhUfX4kvrIASbBokKI6D3B+gGY+qWXPAR/GNPjebTX7vX3j2FI5hVTY3BSEKRJtkxkxGrkFplIu0cxvEcbXuS5P6pXjxholj2I7TcndiPssq2vA0kujXUY1IXrZ+tGUl20qzIwd22Sr6DfHSF/MqwtPY8jqQbHS5/C3jmLgAxz4pc+AJxAomGFw8LSmmDQLXkAhlQv7vnH3TGPaj2s1TQOP71wsXuEJk8Q5hZhek0KchSGWHdAO2WiVNt1oGDm/+tdILBUjDA0WC/ACTdZ9WtGAMPA955G9jhyUadP6P28s2XiXzFwc2df01sktrK1qZS9Ev4Zi88+JCOO9JSQ8hkCQebF03ePWdj65YmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's only single caller of fsync_buffers_list() so untangle the code
a bit by folding fsync_buffers_list() into sync_mapping_buffers(). Also
merge the comments and update them to reflect current state of code.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 180 +++++++++++++++++++++++-----------------------------
 1 file changed, 80 insertions(+), 100 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1c0e7c81a38b..fa3d84084adf 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -54,7 +54,6 @@
 
 #include "internal.h"
 
-static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 			  enum rw_hint hint, struct writeback_control *wbc);
 
@@ -531,22 +530,96 @@ EXPORT_SYMBOL_GPL(inode_has_buffers);
  * @mapping: the mapping which wants those buffers written
  *
  * Starts I/O against the buffers at mapping->i_private_list, and waits upon
- * that I/O.
+ * that I/O. Basically, this is a convenience function for fsync().  @mapping
+ * is a file or directory which needs those buffers to be written for a
+ * successful fsync().
  *
- * Basically, this is a convenience function for fsync().
- * @mapping is a file or directory which needs those buffers to be written for
- * a successful fsync().
+ * We have conflicting pressures: we want to make sure that all
+ * initially dirty buffers get waited on, but that any subsequently
+ * dirtied buffers don't.  After all, we don't want fsync to last
+ * forever if somebody is actively writing to the file.
+ *
+ * Do this in two main stages: first we copy dirty buffers to a
+ * temporary inode list, queueing the writes as we go. Then we clean
+ * up, waiting for those writes to complete. mark_buffer_dirty_inode()
+ * doesn't touch b_assoc_buffers list if b_assoc_map is not NULL so we
+ * are sure the buffer stays on our list until IO completes (at which point
+ * it can be reaped).
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
 	struct address_space *buffer_mapping =
 				mapping->host->i_sb->s_bdev->bd_mapping;
+	struct buffer_head *bh;
+	int err = 0;
+	struct blk_plug plug;
+	LIST_HEAD(tmp);
 
 	if (list_empty(&mapping->i_private_list))
 		return 0;
 
-	return fsync_buffers_list(&buffer_mapping->i_private_lock,
-					&mapping->i_private_list);
+	blk_start_plug(&plug);
+
+	spin_lock(&buffer_mapping->i_private_lock);
+	while (!list_empty(&mapping->i_private_list)) {
+		bh = BH_ENTRY(mapping->i_private_list.next);
+		WARN_ON_ONCE(bh->b_assoc_map != mapping);
+		__remove_assoc_queue(bh);
+		/* Avoid race with mark_buffer_dirty_inode() which does
+		 * a lockless check and we rely on seeing the dirty bit */
+		smp_mb();
+		if (buffer_dirty(bh) || buffer_locked(bh)) {
+			list_add(&bh->b_assoc_buffers, &tmp);
+			bh->b_assoc_map = mapping;
+			if (buffer_dirty(bh)) {
+				get_bh(bh);
+				spin_unlock(&buffer_mapping->i_private_lock);
+				/*
+				 * Ensure any pending I/O completes so that
+				 * write_dirty_buffer() actually writes the
+				 * current contents - it is a noop if I/O is
+				 * still in flight on potentially older
+				 * contents.
+				 */
+				write_dirty_buffer(bh, REQ_SYNC);
+
+				/*
+				 * Kick off IO for the previous mapping. Note
+				 * that we will not run the very last mapping,
+				 * wait_on_buffer() will do that for us
+				 * through sync_buffer().
+				 */
+				brelse(bh);
+				spin_lock(&buffer_mapping->i_private_lock);
+			}
+		}
+	}
+
+	spin_unlock(&buffer_mapping->i_private_lock);
+	blk_finish_plug(&plug);
+	spin_lock(&buffer_mapping->i_private_lock);
+
+	while (!list_empty(&tmp)) {
+		bh = BH_ENTRY(tmp.prev);
+		get_bh(bh);
+		__remove_assoc_queue(bh);
+		/* Avoid race with mark_buffer_dirty_inode() which does
+		 * a lockless check and we rely on seeing the dirty bit */
+		smp_mb();
+		if (buffer_dirty(bh)) {
+			list_add(&bh->b_assoc_buffers,
+				 &mapping->i_private_list);
+			bh->b_assoc_map = mapping;
+		}
+		spin_unlock(&buffer_mapping->i_private_lock);
+		wait_on_buffer(bh);
+		if (!buffer_uptodate(bh))
+			err = -EIO;
+		brelse(bh);
+		spin_lock(&buffer_mapping->i_private_lock);
+	}
+	spin_unlock(&buffer_mapping->i_private_lock);
+	return err;
 }
 EXPORT_SYMBOL(sync_mapping_buffers);
 
@@ -719,99 +792,6 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 }
 EXPORT_SYMBOL(block_dirty_folio);
 
-/*
- * Write out and wait upon a list of buffers.
- *
- * We have conflicting pressures: we want to make sure that all
- * initially dirty buffers get waited on, but that any subsequently
- * dirtied buffers don't.  After all, we don't want fsync to last
- * forever if somebody is actively writing to the file.
- *
- * Do this in two main stages: first we copy dirty buffers to a
- * temporary inode list, queueing the writes as we go.  Then we clean
- * up, waiting for those writes to complete.
- * 
- * During this second stage, any subsequent updates to the file may end
- * up refiling the buffer on the original inode's dirty list again, so
- * there is a chance we will end up with a buffer queued for write but
- * not yet completed on that list.  So, as a final cleanup we go through
- * the osync code to catch these locked, dirty buffers without requeuing
- * any newly dirty buffers for write.
- */
-static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
-{
-	struct buffer_head *bh;
-	struct address_space *mapping;
-	int err = 0;
-	struct blk_plug plug;
-	LIST_HEAD(tmp);
-
-	blk_start_plug(&plug);
-
-	spin_lock(lock);
-	while (!list_empty(list)) {
-		bh = BH_ENTRY(list->next);
-		mapping = bh->b_assoc_map;
-		__remove_assoc_queue(bh);
-		/* Avoid race with mark_buffer_dirty_inode() which does
-		 * a lockless check and we rely on seeing the dirty bit */
-		smp_mb();
-		if (buffer_dirty(bh) || buffer_locked(bh)) {
-			list_add(&bh->b_assoc_buffers, &tmp);
-			bh->b_assoc_map = mapping;
-			if (buffer_dirty(bh)) {
-				get_bh(bh);
-				spin_unlock(lock);
-				/*
-				 * Ensure any pending I/O completes so that
-				 * write_dirty_buffer() actually writes the
-				 * current contents - it is a noop if I/O is
-				 * still in flight on potentially older
-				 * contents.
-				 */
-				write_dirty_buffer(bh, REQ_SYNC);
-
-				/*
-				 * Kick off IO for the previous mapping. Note
-				 * that we will not run the very last mapping,
-				 * wait_on_buffer() will do that for us
-				 * through sync_buffer().
-				 */
-				brelse(bh);
-				spin_lock(lock);
-			}
-		}
-	}
-
-	spin_unlock(lock);
-	blk_finish_plug(&plug);
-	spin_lock(lock);
-
-	while (!list_empty(&tmp)) {
-		bh = BH_ENTRY(tmp.prev);
-		get_bh(bh);
-		mapping = bh->b_assoc_map;
-		__remove_assoc_queue(bh);
-		/* Avoid race with mark_buffer_dirty_inode() which does
-		 * a lockless check and we rely on seeing the dirty bit */
-		smp_mb();
-		if (buffer_dirty(bh)) {
-			list_add(&bh->b_assoc_buffers,
-				 &mapping->i_private_list);
-			bh->b_assoc_map = mapping;
-		}
-		spin_unlock(lock);
-		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
-			err = -EIO;
-		brelse(bh);
-		spin_lock(lock);
-	}
-	
-	spin_unlock(lock);
-	return err;
-}
-
 /*
  * Invalidate any and all dirty buffers on a given inode.  We are
  * probably unmounting the fs, but that doesn't mean we have already
-- 
2.51.0


