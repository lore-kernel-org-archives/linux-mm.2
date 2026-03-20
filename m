Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5357B1098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B886B00EB; Fri, 20 Mar 2026 09:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84DB46B00EC; Fri, 20 Mar 2026 09:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE146B00EE; Fri, 20 Mar 2026 09:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 514446B00EC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 291B71390A0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:25 +0000 (UTC)
X-FDA: 84566558370.17.B9C2570
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id CA82820010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eJts8GzO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oGJS91mi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eJts8GzO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oGJS91mi;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AERyFtb7R53Rm5I4b3SM6B/UYnagvrWNXUEJtFe56Tg=;
	b=CSSYao7khjR+TBDozrUHq7jKBuTfyzks3kVQVtHC+gwZGpArSPe6RJO1axiDSxgDLhTalo
	lvYZqixVE10Q9Ejrb0yPDLP1qnDDhnpyXY945xUKWetrZxg7nXuNxuNk7KW0vAMuEDH1Kx
	qtCnfsiJAAO6mU6feMAGSlW0AQbxthw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014203; a=rsa-sha256;
	cv=none;
	b=iN0gker2IR5NMsBCd2Qc6KZialmWBxTPLGIdJjI98mSZr67FIg91TgxXIOv3X3lu0Y0Ty5
	f/0kVgcnU67jTsQzgkR3qrMKclJTfO09MsvljMHOnLTZFBNzZtfPwY6aE86sZCBd5edOe9
	sW0xD/fb6kZ9Ql/q8PKZrYiSlg5deYA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eJts8GzO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oGJS91mi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eJts8GzO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oGJS91mi;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A73755BEE5;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AERyFtb7R53Rm5I4b3SM6B/UYnagvrWNXUEJtFe56Tg=;
	b=eJts8GzOlvsf8KrhxeUXrxnPrguwV27Xc49JFb9GdOaDIC7tIU37XOF4nPhP8doxIwLbj3
	lm8/6IbZaDMJ+E1ve/umpSFQDVFgG+i7o34vsf6HDxi6QdEQHOOp8lUo+y9ITbnmrnqD1D
	dZS+W+ESrqp+Oej0dkx6mWxQzlTUg/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AERyFtb7R53Rm5I4b3SM6B/UYnagvrWNXUEJtFe56Tg=;
	b=oGJS91miOqJkqMjL4P3wLdAmaTws5pgP0lD4JchVU3a58HCSAqWLR14iZJJN+i7YM+SOXJ
	zaerWS4irElvnNDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AERyFtb7R53Rm5I4b3SM6B/UYnagvrWNXUEJtFe56Tg=;
	b=eJts8GzOlvsf8KrhxeUXrxnPrguwV27Xc49JFb9GdOaDIC7tIU37XOF4nPhP8doxIwLbj3
	lm8/6IbZaDMJ+E1ve/umpSFQDVFgG+i7o34vsf6HDxi6QdEQHOOp8lUo+y9ITbnmrnqD1D
	dZS+W+ESrqp+Oej0dkx6mWxQzlTUg/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AERyFtb7R53Rm5I4b3SM6B/UYnagvrWNXUEJtFe56Tg=;
	b=oGJS91miOqJkqMjL4P3wLdAmaTws5pgP0lD4JchVU3a58HCSAqWLR14iZJJN+i7YM+SOXJ
	zaerWS4irElvnNDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 956594281C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1AB6JJlOvWmLCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 621D1A0B54; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 31/41] fs: Provide functions for handling mapping_metadata_bhs directly
Date: Fri, 20 Mar 2026 14:41:26 +0100
Message-ID: <20260320134100.20731-72-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12186; i=jack@suse.cz; h=from:subject; bh=WZugQ2Fndy6gye1t3Hfakk0HbjUHGh+F3qYszb5YB0Q=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6Gjk72DX/tnYi3hOlBDnETcNsWqIa/jrBCw rI3+sHnNwqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OhgAKCRCcnaoHP2RA 2Su+CACxb81rcrWhsybOMUE+f/cyFWbelIn0UQa1LHhthA8L7xqCma+1S1T80Wo349YM/4AD/Ie mqHzP8LEU+ZKlFlY3MGBDgRyTyFGiugh4WDJX1G1GWLtP/aCwPvFvRHu4zJEpaiCUjNYqIKmaEd QC2agJD08ssntEkfeGJaWfRboOZOCAzol1LwV0zCP2D7xV3GPuyC3Z08BtZINQKwHE9XBroVH3d Na/o6JXa/97xd04EOOQBD1jgKH83pWjyUiiN93So72mC0r9T8cjhw9ioOhOx8GnR1phrWettN8/ Gq2B+byBgcKCrAPqgq1rFXBtWpv2syn8iaBkEtbtKvWZkg/H
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3nq39y8uomob3wbxek5fi31ty3ce3bfc
X-Rspam-User: 
X-Rspamd-Queue-Id: CA82820010
X-Rspamd-Server: rspam12
X-HE-Tag: 1774014202-28560
X-HE-Meta: U2FsdGVkX1+JVbFUv/aqdq3gvkFW/sCegmbUFg3HnKXCei844MzbZffj0JHiyQUBlqm3SPTgCvfPTkLt+u2KLCRoqz5KrG2FTYX7EBd8mB9AiU8d+vWAqAPec82zAdWOlBN80xwKJF6+O4Q5CPZam1UnXCU3XwZzwvAUB37bHh9y8gQaheMFC1pdf8YW61QU5/W4ZpQ7+aPB2ESGZDybAcyZPqo8YQBgthwGpn8PhlhdiKov1aWtXCblFaoDKgN4Zd361k9J++gds5Qhwj/HtOJDyuHriqNsk8F9V6JRYKmEUv7M8sKAJDD1wdhDjTjIit0c8PJRCjwgGN5AxwlxhlPra31/icJg1ht7OCHNxj2EYv7RHuvjY7KmbwYF6PDlykaKBW0h4FZXjZXXrMPvDMjlYF4MbCiUwwLxph+hy7c5Y1epVg72AzwiWf/7VdXmVAo4x+9oMqjyLIChbNOJ9z+FKBowu6LY/3hhl5F9g2PC1vOayLz8FBT5C1D5vrH/NnTNMWxh1Khe+AgWq/RqhiM9MEiEmnKvCOVzmEeKPV40ljfF9ABt4D2TMg1+eyS2K9dgT+r23O7lwmW8pawjZV/FLhZZOp4eSzeWlvvUAF190WbY0A+bWTvDzB1AxAelItbOVkWECNhQwKTUBB37e1n5xr/PPGHpE75stbkCUhqcTgYCaOHxJPTnW/qo24QdUNvqVIaJJw5M8F4vfbPGumyspGBv66s2HOcATRMgnQQchmlLD7ksXX/1YPrxfS6wH49PbLdtr9jB14cr5HxWiLqIFy31PGrHGy1I1HNIIHbxl+eMA290/iAtHgPrrY02rjfiLvTkGnhUH31zJvgYFtRc2fEgz/ZVwAXhOH2hCRMEf7X7/tT0aRs1FV0cOQIRtxN4AtBOaSDPctFEcumOekw+g4BTzdNU6hoHvwllrvngNT/GQmDVr00wiv4S8TqnkNgzQ0harO5TvdFy99w
 gSzYHNE3
 OqsMypBPj1DEB9vQxyQKBqfZF1VAX13zthn30i66TVmjdh4FxzNX+SAuWloJr72ocQ4d/YNV9PBBHM5ZbwB0fZdlq/wGRTe6LTUjdwSRxGYCQwQKHg3POobeIcYfrfO0uXAesz1C6HW4KyNLOZH9tfk+CT0eAIvWJv4CR9ZuVqcWyUWEDouDklgDtOhBGYDiZNdqH/spHkrI2hpe4ljTSVmO4E7v3AyOLR/KCQUipdAjgshN9EEvosPjLZeC6i0qf282nU3Oh+iL/mjS/svi5XLxuEQZBAFtO2SPC8fLzIXd95AVEgVJY9A4LDjZbRb4JSBgyPkcPS6LhnHkqihMcVPhhjclzhDP4QliOcpuuK2+75635iX2s2FOB/OASjiBMj3L40xP3RtwbH34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of transition toward moving mapping_metadata_bhs to fs-private
part of the inode, provide functions for operations on this list
directly instead of going through the inode / mapping.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 93 +++++++++++++++++--------------------
 include/linux/buffer_head.h | 45 ++++++++++++++----
 2 files changed, 80 insertions(+), 58 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c70f8027bdd1..43aca5b7969f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -467,31 +467,25 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * a successful fsync().  For example, ext2 indirect blocks need to be
  * written back and waited upon before fsync() returns.
  *
- * The functions mark_buffer_dirty_inode(), fsync_inode_buffers(),
- * mmb_has_buffers() and invalidate_inode_buffers() are provided for the
- * management of a list of dependent buffers in mapping_metadata_bhs struct.
+ * The functions mmb_mark_buffer_dirty(), mmb_sync_buffers(), mmb_has_buffers()
+ * and mmb_invalidate_buffers() are provided for the management of a list of
+ * dependent buffers in mapping_metadata_bhs struct.
  *
  * The locking is a little subtle: The list of buffer heads is protected by
  * the lock in mapping_metadata_bhs so functions coming from bdev mapping
  * (such as try_to_free_buffers()) need to safely get to mapping_metadata_bhs
  * using RCU, grab the lock, verify we didn't race with somebody detaching the
  * bh / moving it to different inode and only then proceeding.
- *
- * FIXME: mark_buffer_dirty_inode() is a data-plane operation.  It should
- * take an address_space, not an inode.  And it should be called
- * mark_buffer_dirty_fsync() to clearly define why those buffers are being
- * queued up.
- *
- * FIXME: mark_buffer_dirty_inode() doesn't need to add the buffer to the
- * list if it is already on a list.  Because if the buffer is on a list,
- * it *must* already be on the right one.  If not, the filesystem is being
- * silly.  This will save a ton of locking.  But first we have to ensure
- * that buffers are taken *off* the old inode's list when they are freed
- * (presumably in truncate).  That requires careful auditing of all
- * filesystems (do it inside bforget()).  It could also be done by bringing
- * b_inode back.
  */
 
+void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping)
+{
+	spin_lock_init(&mmb->lock);
+	INIT_LIST_HEAD(&mmb->list);
+	mmb->mapping = mapping;
+}
+EXPORT_SYMBOL(mmb_init);
+
 static void __remove_assoc_queue(struct mapping_metadata_bhs *mmb,
 			         struct buffer_head *bh)
 {
@@ -533,12 +527,12 @@ bool mmb_has_buffers(struct mapping_metadata_bhs *mmb)
 EXPORT_SYMBOL_GPL(mmb_has_buffers);
 
 /**
- * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
- * @mapping: the mapping which wants those buffers written
+ * mmb_sync_buffers - write out & wait upon all buffers in a list
+ * @mmb: the list of buffers to write
  *
- * Starts I/O against the buffers at mapping->i_metadata_bhs and waits upon
- * that I/O. Basically, this is a convenience function for fsync().  @mapping
- * is a file or directory which needs those buffers to be written for a
+ * Starts I/O against the buffers in the given list and waits upon
+ * that I/O. Basically, this is a convenience function for fsync().  @mmb is
+ * for a file or directory which needs those buffers to be written for a
  * successful fsync().
  *
  * We have conflicting pressures: we want to make sure that all
@@ -553,9 +547,8 @@ EXPORT_SYMBOL_GPL(mmb_has_buffers);
  * buffer stays on our list until IO completes (at which point it can be
  * reaped).
  */
-int sync_mapping_buffers(struct address_space *mapping)
+int mmb_sync_buffers(struct mapping_metadata_bhs *mmb)
 {
-	struct mapping_metadata_bhs *mmb = &mapping->i_metadata_bhs;
 	struct buffer_head *bh;
 	int err = 0;
 	struct blk_plug plug;
@@ -626,13 +619,14 @@ int sync_mapping_buffers(struct address_space *mapping)
 	spin_unlock(&mmb->lock);
 	return err;
 }
-EXPORT_SYMBOL(sync_mapping_buffers);
+EXPORT_SYMBOL(mmb_sync_buffers);
 
 /**
- * generic_buffers_fsync_noflush - generic buffer fsync implementation
+ * generic_mmb_fsync_noflush - generic buffer fsync implementation
  * for simple filesystems with no inode lock
  *
  * @file:	file to synchronize
+ * @mmb:	list of metadata bhs to flush
  * @start:	start offset in bytes
  * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
@@ -641,18 +635,20 @@ EXPORT_SYMBOL(sync_mapping_buffers);
  * filesystems which track all non-inode metadata in the buffers list
  * hanging off the address_space structure.
  */
-int generic_buffers_fsync_noflush(struct file *file, loff_t start, loff_t end,
-				  bool datasync)
+int generic_mmb_fsync_noflush(struct file *file,
+			      struct mapping_metadata_bhs *mmb,
+			      loff_t start, loff_t end, bool datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
-	int ret;
+	int ret = 0;
 
 	err = file_write_and_wait_range(file, start, end);
 	if (err)
 		return err;
 
-	ret = sync_mapping_buffers(inode->i_mapping);
+	if (mmb)
+		ret = mmb_sync_buffers(mmb);
 	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
 		goto out;
 	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
@@ -669,13 +665,14 @@ int generic_buffers_fsync_noflush(struct file *file, loff_t start, loff_t end,
 		ret = err;
 	return ret;
 }
-EXPORT_SYMBOL(generic_buffers_fsync_noflush);
+EXPORT_SYMBOL(generic_mmb_fsync_noflush);
 
 /**
- * generic_buffers_fsync - generic buffer fsync implementation
+ * generic_mmb_fsync - generic buffer fsync implementation
  * for simple filesystems with no inode lock
  *
  * @file:	file to synchronize
+ * @mmb:	list of metadata bhs to flush
  * @start:	start offset in bytes
  * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
@@ -685,18 +682,18 @@ EXPORT_SYMBOL(generic_buffers_fsync_noflush);
  * hanging off the address_space structure. This also makes sure that
  * a device cache flush operation is called at the end.
  */
-int generic_buffers_fsync(struct file *file, loff_t start, loff_t end,
-			  bool datasync)
+int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
+		      loff_t start, loff_t end, bool datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int ret;
 
-	ret = generic_buffers_fsync_noflush(file, start, end, datasync);
+	ret = generic_mmb_fsync_noflush(file, mmb, start, end, datasync);
 	if (!ret)
 		ret = blkdev_issue_flush(inode->i_sb->s_bdev);
 	return ret;
 }
-EXPORT_SYMBOL(generic_buffers_fsync);
+EXPORT_SYMBOL(generic_mmb_fsync);
 
 /*
  * Called when we've recently written block `bblock', and it is known that
@@ -717,20 +714,18 @@ void write_boundary_block(struct block_device *bdev,
 	}
 }
 
-void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
+void mmb_mark_buffer_dirty(struct buffer_head *bh,
+			   struct mapping_metadata_bhs *mmb)
 {
-	struct address_space *mapping = inode->i_mapping;
-
 	mark_buffer_dirty(bh);
 	if (!bh->b_mmb) {
-		spin_lock(&mapping->i_metadata_bhs.lock);
-		list_move_tail(&bh->b_assoc_buffers,
-				&mapping->i_metadata_bhs.list);
-		bh->b_mmb = &mapping->i_metadata_bhs;
-		spin_unlock(&mapping->i_metadata_bhs.lock);
+		spin_lock(&mmb->lock);
+		list_move_tail(&bh->b_assoc_buffers, &mmb->list);
+		bh->b_mmb = mmb;
+		spin_unlock(&mmb->lock);
 	}
 }
-EXPORT_SYMBOL(mark_buffer_dirty_inode);
+EXPORT_SYMBOL(mmb_mark_buffer_dirty);
 
 /**
  * block_dirty_folio - Mark a folio as dirty.
@@ -797,14 +792,12 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 EXPORT_SYMBOL(block_dirty_folio);
 
 /*
- * Invalidate any and all dirty buffers on a given inode.  We are
+ * Invalidate any and all dirty buffers on a given buffers list.  We are
  * probably unmounting the fs, but that doesn't mean we have already
  * done a sync().  Just drop the buffers from the inode list.
  */
-void invalidate_inode_buffers(struct inode *inode)
+void mmb_invalidate_buffers(struct mapping_metadata_bhs *mmb)
 {
-	struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
-
 	if (mmb_has_buffers(mmb)) {
 		spin_lock(&mmb->lock);
 		while (!list_empty(&mmb->list))
@@ -812,7 +805,7 @@ void invalidate_inode_buffers(struct inode *inode)
 		spin_unlock(&mmb->lock);
 	}
 }
-EXPORT_SYMBOL(invalidate_inode_buffers);
+EXPORT_SYMBOL(mmb_invalidate_buffers);
 
 /*
  * Create the appropriate buffers when given a folio for data area and
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 44094fd476f5..399277c679eb 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -205,12 +205,31 @@ struct buffer_head *create_empty_buffers(struct folio *folio,
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 
-/* Things to do with buffers at mapping->private_list */
-void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode);
-int generic_buffers_fsync_noflush(struct file *file, loff_t start, loff_t end,
-				  bool datasync);
-int generic_buffers_fsync(struct file *file, loff_t start, loff_t end,
-			  bool datasync);
+/* Things to do with metadata buffers list */
+void mmb_mark_buffer_dirty(struct buffer_head *bh, struct mapping_metadata_bhs *mmb);
+static inline void mark_buffer_dirty_inode(struct buffer_head *bh,
+					   struct inode *inode)
+{
+	mmb_mark_buffer_dirty(bh, &inode->i_data.i_metadata_bhs);
+}
+int generic_mmb_fsync_noflush(struct file *file,
+			      struct mapping_metadata_bhs *mmb,
+			      loff_t start, loff_t end, bool datasync);
+static inline int generic_buffers_fsync_noflush(struct file *file,
+						loff_t start, loff_t end,
+						bool datasync)
+{
+	return generic_mmb_fsync_noflush(file, &file->f_mapping->i_metadata_bhs,
+					 start, end, datasync);
+}
+int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
+		      loff_t start, loff_t end, bool datasync);
+static inline int generic_buffers_fsync(struct file *file,
+					loff_t start, loff_t end, bool datasync)
+{
+	return generic_mmb_fsync(file, &file->f_mapping->i_metadata_bhs,
+				 start, end, datasync);
+}
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
 static inline void clean_bdev_bh_alias(struct buffer_head *bh)
@@ -515,9 +534,18 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
+void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping);
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
-void invalidate_inode_buffers(struct inode *inode);
-int sync_mapping_buffers(struct address_space *mapping);
+void mmb_invalidate_buffers(struct mapping_metadata_bhs *mmb);
+int mmb_sync_buffers(struct mapping_metadata_bhs *mmb);
+static inline void invalidate_inode_buffers(struct inode *inode)
+{
+	mmb_invalidate_buffers(&inode->i_data.i_metadata_bhs);
+}
+static inline int sync_mapping_buffers(struct address_space *mapping)
+{
+	return mmb_sync_buffers(&mapping->i_metadata_bhs);
+}
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
 bool has_bh_in_lru(int cpu, void *dummy);
@@ -527,6 +555,7 @@ extern int buffer_heads_over_limit;
 
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
+static inline int mmb_sync_buffers(struct mapping_metadata_bhs *mmb) { return 0; }
 static inline void invalidate_inode_buffers(struct inode *inode) {}
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
-- 
2.51.0


