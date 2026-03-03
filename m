Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2AC0EC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F1A6B011D; Tue,  3 Mar 2026 05:35:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2826B011E; Tue,  3 Mar 2026 05:35:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085DC6B011D; Tue,  3 Mar 2026 05:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7DEC6B011E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A307E1A03FD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:46 +0000 (UTC)
X-FDA: 84504395892.15.B33F1E8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5720B160004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CyzlAe4L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DvK+DTiT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CyzlAe4L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DvK+DTiT;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayutdjATkfIJsyi9w7bhVOmHaFZZfPEvqi93VrREg+I=;
	b=aZ3BPUiRCL1FYf70cl/YG84FagLtIXyuvCr3LM4Zg055Lh0VMOOnefaP4xY8G+w14JnQfc
	Vcz8w2ywwusfuwSj1uHLr2G9K2nUowiYM6R/S8jTjuDl8fjEhFN2K0b/+qK4V6oZrBGBcW
	SDRa3wBOFeKR70K5tYwfNNHF1i/jnPc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CyzlAe4L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DvK+DTiT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CyzlAe4L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DvK+DTiT;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534144; a=rsa-sha256;
	cv=none;
	b=EhbYsQ7gJFskE+dt+khyzkj8/07AP9XwBCtpgiBiCfk9E20g9iM1GpQ5trtchGFNob4ual
	yUyaKFeEUQcWv6ZZ6C0e8wXZA5wrQ28UPoWIQa5cpHYmBOfO0iasyFjpSBasRX/TrmsH0f
	8WdAcNU+xZG1/NsacYzzFaknLrgJqz4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2F9D23F929;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ayutdjATkfIJsyi9w7bhVOmHaFZZfPEvqi93VrREg+I=;
	b=CyzlAe4L3HqgIZiyZrYlmfOTNprQP6+SvArWyc9E5oQFYf012FxA3BtI1HbO45NcH/L2ti
	d2/+6Kunl7+ts64jGrCfrGhzzoI1bWSmGAMdgak8DlIiv9YmTX6kd7Y3ymHAHpfuNzBJs5
	OPoacYYPQnXACdBGf/mI1J14tfYVrO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ayutdjATkfIJsyi9w7bhVOmHaFZZfPEvqi93VrREg+I=;
	b=DvK+DTiTmQkSAKFjj2D2jqh/HRRXgvMyfCseBN8se/zRRqAnWTsBztdOnq2FD/y1CtToCZ
	9fPpL595ZYW++fAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ayutdjATkfIJsyi9w7bhVOmHaFZZfPEvqi93VrREg+I=;
	b=CyzlAe4L3HqgIZiyZrYlmfOTNprQP6+SvArWyc9E5oQFYf012FxA3BtI1HbO45NcH/L2ti
	d2/+6Kunl7+ts64jGrCfrGhzzoI1bWSmGAMdgak8DlIiv9YmTX6kd7Y3ymHAHpfuNzBJs5
	OPoacYYPQnXACdBGf/mI1J14tfYVrO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ayutdjATkfIJsyi9w7bhVOmHaFZZfPEvqi93VrREg+I=;
	b=DvK+DTiTmQkSAKFjj2D2jqh/HRRXgvMyfCseBN8se/zRRqAnWTsBztdOnq2FD/y1CtToCZ
	9fPpL595ZYW++fAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22E653EA69;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8yqECEW5pml9FQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C8F9DA0AE1; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
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
Subject: [PATCH 16/32] fs: Fold fsync_buffers_list() into sync_mapping_buffers()
Date: Tue,  3 Mar 2026 11:34:05 +0100
Message-ID: <20260303103406.4355-48-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7504; i=jack@suse.cz; h=from:subject; bh=iAQYf1Qy8SGxN1+aEnxN/hmRSnVqswowuoNdYM87ou8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkret9/c1xpxPu/HVbqz9oF76wD6wt3S0VAk fZSs6HxtgCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5KwAKCRCcnaoHP2RA 2aDRB/9ONHR3CHXaC9Dt8EF2Alucrv+2KoC6QvP67hC5JUwzvTa04STNFTHTv7npgR30ioCCpK+ 7zu9PYgTPbCFxHvL/sswxIxHIFcUWDC30dN3vJ64bCztTB8UpfvcMKi4XlhX8oWbG4XXVDXyxb/ Y05ivmiBrVYouoa6YO1dSos2EL3Rx0cldyxvOaGh+78+gB6EX9EVOyTSrRECvHRNg+X044PWRbn TwWWZea+fqAt1U0FRMJP0o2FxOdEg+Rj+pl9QA9CO8A8eoI+bhK/MEnbkzZ+oklCkKxGYoTHEbf joYLTGBG6fqUxjxIJRqHZgbA+0IWj5gArfSKoTAX85VsJ1EW
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5720B160004
X-Stat-Signature: g5ez1ebeqj5z3187nyuf1m1dd4wpzmgu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772534144-530749
X-HE-Meta: U2FsdGVkX19Ioj3I20heFBt6DOOJNiTbjD+WL7+PczBcTRDrwVfUauvlJ5TnwZslsPtQjaMeQNeRUQViqLZR13hogoDm6QwAAXZW0810SGX5VRC5ctrQaFGuRSlurAwBavJq6rH3POtw3NVaWiDkmFVAHYeI1p+OQMTAm1jRk6N0ExENgE3qvkLwy6rnhJNpPaZBlOxcwyR9pjQG0GBbpAWmzexGt5tSey6q09yLSUNN4TMVItLR2DRI6NKlEUJ+UGNLpxMdb4ebtrq1EF9wmVNIjGMro4Pql6d1cr6IhS2sAUwNMNv0s/yUQ0ADgJKDEa5B9Aw5Wv9Zn3pGhphS7VtL6HwwRpj2sLynIGL7Y7q0L5hPuwtnA7n0vwThc+vow1TysUrxLsxx12z8HVqtTcUu/N1xC408+H+KV51CA2UGUMX4gW8Pg1UPZk4U4Wb74N/rY3IGD7OQNERlfJTR7AnPisO/qE4aC4r+dKgjMDN/ciEIJvuPChpBLMHsoKkEd8fPpJDyHDcsVEeEIJwUry3m9gOjkjKy6ndnnZtoYfIjmjWsfc2q8nThmZrUPe/pZgqN3hzuXKr7DCLtfivZ8c7ojpQbwDiU50vT6N0TixvwRwzOd0gnSWS5H4eSukSyut1624m4jD9Q2bnLKVpZJhN8PJ/fYwa6mpcQpNO7uyCO3lyWP+REZXHCp/1vF0cHy3q2WV4iLrLVpNmSaSa3uMU5Mnu9pA0cwzf/gd1rEds3eM+NcUpq5CZ9LNOt2B0/3anCUnnjNjy+y32bD2pp0U1hQ7QR/uSuh4yQP5sTFCBI20uE+sL32mfNGdt/uWivt6oMnWnyCCMVgQkRZVJlBA6oRlGHYPui6lWt4znpnNd3q4UusTWyiv50UzHj+HTr44rUNj5eXImEptTMLRr0V57G1pZlYb2uKE8xR0r6p8fJDBHgoiG7hrcy3pAqOIQxeOtr2OW2OJ9G3vOp3/S
 w/ZY9deX
 wAi5Cvlzn2oQ6pUMFF2q4rvCQ4qRGc9ko18c5oV0zyuwfNsUQfX8T3CGoYkbYXlP8VqLPJRKH/VEoLmCCulL73EdMAC+qhFCD+dMuwPXS11Pro26BGzFWQqckT+9fvLb8DME3Wrw+LEuK6cDKz8yCw7LZqa0jxC9WaltVbZI99c9/M6IWB2jZj0Q4u7uVREXpCFzM62WmqZ4RAe/x5r04R5XHX6rN/Jrw5DG1ycnyUPJSjyYrevZraNMYBSN8sl42kELi95SbQ4aJ1/6ClBdeIffSkMdTGtca0R5QIkp9DRXHLauYIjSgP8iMOsuFb46Q4CYp0kkuqyYYkVhoShwVYWzkn88V58JarR/OgDEK0RBFQw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's only single caller of fsync_buffers_list() so untangle the code
a bit by folding fsync_buffers_list() into sync_mapping_buffers(). Also
merge the comments and update them to reflect current state of code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 180 +++++++++++++++++++++++-----------------------------
 1 file changed, 80 insertions(+), 100 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1c0e7c81a38b..18012afb8289 100644
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
+		bh = BH_ENTRY(list->next);
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


