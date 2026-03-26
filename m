Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 623E9106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F296B0111; Thu, 26 Mar 2026 05:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236666B0115; Thu, 26 Mar 2026 05:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03AF86B0111; Thu, 26 Mar 2026 05:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBAC06B0112
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 849A113C12C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:45 +0000 (UTC)
X-FDA: 84587759970.14.CB4B1D0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 318B120007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N96OunMJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UA96zSZT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N96OunMJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UA96zSZT;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774519003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4dA7bzxeJg32q4HGmMXYWKaVsPPNa/KgHdhJnJEenLY=;
	b=2RPT7u6rR3NnQqAkYkyUssvWeU4wsv7qDHzaE2rDjJXvla/goHL5+rL0TUq8+t1fjKl0ie
	UFKVBQco5dLoVOKrUTZ2EzI4oVI2iFAsLfR/TRIhmLWJw5mb1Mvki3hDnakPayxsZTktfi
	NyS5LEH/FXGGaPNWdWsRuUWcaHSEQ2w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774519003; a=rsa-sha256;
	cv=none;
	b=qE8LUWl6LuvkAS2PN5OJjyQMhGE6klylZKBqddry6p0eKDQs+RgZC8GijINUHwE9a932QM
	TT83HuV+P4NI1V/2P3GWkgdGFIq5j6tmHM/XF9FRn8cD+dzC96YqiMn6KtsJgLwLKB7KZ6
	AVz9wUV+YI0tTimPHHy81Du2oyZ5WAU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N96OunMJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UA96zSZT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N96OunMJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UA96zSZT;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F2025BDC1;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dA7bzxeJg32q4HGmMXYWKaVsPPNa/KgHdhJnJEenLY=;
	b=N96OunMJKejP0kYY3O/3COuZ88wamClfurT3YbNFIVmzBY4NQ4SEU8E/xDB8QRuqIKcnhM
	3+LQgCFKQ9bCEsuaVkmwN/Pz7+ggAbPTnVknbuZHDzzbYvmqJg4oLVnIRY/lyJ0J2MVHpr
	nCxicR9mz5KvMDfJU67h/6JVSmAJMSU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dA7bzxeJg32q4HGmMXYWKaVsPPNa/KgHdhJnJEenLY=;
	b=UA96zSZThOauNjseqcwNekij7l0cvJwO+cnqGB1r7HGOUrCSvqYjJkeyWY/+WIeqB0LmvR
	yWyV9eGPNxb2AzDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dA7bzxeJg32q4HGmMXYWKaVsPPNa/KgHdhJnJEenLY=;
	b=N96OunMJKejP0kYY3O/3COuZ88wamClfurT3YbNFIVmzBY4NQ4SEU8E/xDB8QRuqIKcnhM
	3+LQgCFKQ9bCEsuaVkmwN/Pz7+ggAbPTnVknbuZHDzzbYvmqJg4oLVnIRY/lyJ0J2MVHpr
	nCxicR9mz5KvMDfJU67h/6JVSmAJMSU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dA7bzxeJg32q4HGmMXYWKaVsPPNa/KgHdhJnJEenLY=;
	b=UA96zSZThOauNjseqcwNekij7l0cvJwO+cnqGB1r7HGOUrCSvqYjJkeyWY/+WIeqB0LmvR
	yWyV9eGPNxb2AzDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B79A4A0A7;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fFMjHnUCxWnyYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A0AF4A0C77; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 33/42] fs: Provide functions for handling mapping_metadata_bhs directly
Date: Thu, 26 Mar 2026 10:54:27 +0100
Message-ID: <20260326095354.16340-75-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12578; i=jack@suse.cz; h=from:subject; bh=sXhxY5oIVAvA3ZZOll63xAi+RxkOdCbAxoLzbD6vFBo=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGDKPMvkVKLOJyIhbnjBb/TDx+edE52KrmsMaYTfW6i536 f7XpSPdyWjMwsDIwSArpsiyOvKi9rV5Rl1bQzVkYAaxMoFMYeDiFICJ/P/N/k/nW16liHRy48pk sVfOaq89G91lNjzLOqfE9LIq/mGO5GOJXJ0jFz2k0xRLOO9ltwu7Mj9WXbJHIiTr5WP+LXuTnnq bp6/JcGiO/Tsp8Ai7kNCrlJmxaiLbRb0U2h/sSSspN7GVzvfMCmvMaL6muuAIe7z66dQ9F5dMKp fPlj5damykKyMvFjzrSNyJM8V9mfsiHC9kLpmgH/yP/8oqe442Bcamyd1ef8409LE/tnuRvMR3l +EXn6ta0wOfTlbb6Ze4bBV75pVN3QonpHZNid+zU/jpluUf3m3k5LjJKPz1U3nmZqPcI3On+1XI J7U8lyrj4HXkY/ng4Mkwe9tra7lrgRd8p6plLtwoEyUAAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 318B120007
X-Stat-Signature: 44j8ec5nci68j3fky5zmxqxt9n3r5a9j
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774519002-547120
X-HE-Meta: U2FsdGVkX1/xPthBlWxcyezz9J2QxIHPZkGLpIQLhi1XZdHrXQ+dr8VIqb7Z/mBKBvpWbigFklTKB9JQC7vxhRVuBmN1j9wPoClo+wpdlzfCDnAiASCQOIBNiiOc4hn8BphoAKtRjLKQ2cYbpSUGnZf4GwOTTzRuLmmNEVIZRI49kN1JrXjboVIzFIH89gCT57BT5bxrtG1jzgKdulKPVo6v/Z3GEqti7m5moG1+g1OOyZjTlBbv0stTyHb54syfER102WCD5k+Pix9D8/xUI5pbLezi9jXllwe1VCZ96qqRseJWZOnj9uTiMkq4Nu5opEjYnv0iijbvy4bEiXRWFi8Npqi7NH4MLL78pz3dvnuaQ4KLYvUjYBSOTRbfTlcmNWDUbToV5SEvBO9Ze8Z/MywqnfUcr+xs4JcpFeUmW88ZxDCeS28+jmRk+RGxtVZBGT6Lgx8afGQYnxikGYukHNRJtg3Kv6qkqepxjmLYX70r+H3Frn8o6aB/5NPKMh9lQ9YYWflEaceUhOmoo4B3IAl8mTNBxC0lMTnCYhgEEHUQEoxN9dGlOeyqj89dMfpkDwKegQrowp4Gorygx0g+zeFNug9fvNZpA2FrNzEGJPIMNDZcu5pVMkCia1v6B+Ff8EXFq3lfQNkaXjFBj7Q0uXAdv5f02dLGsVRNEOYqADlfyWnWsAMYiDmEu0L1Vupji72EumvQupTbmJ3bK9B37/lNyLRDYZ5pNhl09yjHdlnToygKwTvtmDeG1/jxaDJikkithCnj1s2TyASZML1wTfP5CJ3wChgMgjutY9dUQWC7ETdjCmD6HhZ49hYtwS5DZCpSeTaQa6R5zlvu++EDn4V20LI6Z0YhKic4ijBFdJbGG+TAThvwoaLU7+REQBQjwYVcKae7+sA9S1OX1IXzEUHKnuZaPfJZ39vHsIbU/swh3FPcNCe70AzVwYf5RDUi2fSeubDGsaeHAVnoLD7
 ShxR+bQm
 tyWeUs9BRym91/B7aEUNij9IPcxtWHVP28XpWz7kIMcEqHN6sRNexTG+wz3cSTfM8QqZ52zsxgWlgSGMfPheXMt/MIG4d5sfvuItGx3DdpTfBhNayfLh+M/NvcnMeAIZXhUljGongzeho252zzzcjVRggUlQg22vpNgCjqXMS3JRxcSAeyi3o5qLRNt9krcLk/WGG3/Q2sef6cQaxuiccTklRZlG5BZelYXLiFuV2H2J7LkYvVV8MpYlGJAJugcyRB3ajKKLf9ZkCzA4nanefnvrIpvMtqjVljtp0CDJfDaoADAeNhd4DcM8AoP3rjnb+IWRY0pYPeBMixqcwKSNRq9w/2l5UYGs7Izc910BQn2T+pRQ=
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
 fs/buffer.c                 | 110 +++++++++++++++++-------------------
 include/linux/buffer_head.h |  44 ++++++++++++---
 2 files changed, 87 insertions(+), 67 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0436481d0f1..cbed175f418b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -467,31 +467,25 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * a successful fsync().  For example, ext2 indirect blocks need to be
  * written back and waited upon before fsync() returns.
  *
- * The functions mark_buffer_dirty_inode(), fsync_inode_buffers(),
- * mmb_has_buffers() and invalidate_inode_buffers() are provided for the
- * management of a list of dependent buffers in mapping_metadata_bhs struct.
+ * The functions mmb_mark_buffer_dirty(), mmb_sync(), mmb_has_buffers()
+ * and mmb_invalidate() are provided for the management of a list of dependent
+ * buffers in mapping_metadata_bhs struct.
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
+ * mmb_sync - write out & wait upon all buffers in a list
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
+int mmb_sync(struct mapping_metadata_bhs *mmb)
 {
-	struct mapping_metadata_bhs *mmb = &mapping->i_metadata_bhs;
 	struct buffer_head *bh;
 	int err = 0;
 	struct blk_plug plug;
@@ -626,33 +619,35 @@ int sync_mapping_buffers(struct address_space *mapping)
 	spin_unlock(&mmb->lock);
 	return err;
 }
-EXPORT_SYMBOL(sync_mapping_buffers);
+EXPORT_SYMBOL(mmb_sync);
 
 /**
- * generic_buffers_fsync_noflush - generic buffer fsync implementation
- * for simple filesystems with no inode lock
+ * mmb_fsync_noflush - fsync implementation for simple filesystems with
+ * 		       metadata buffers list
  *
  * @file:	file to synchronize
+ * @mmb:	list of metadata bhs to flush
  * @start:	start offset in bytes
  * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
  *
- * This is a generic implementation of the fsync method for simple
- * filesystems which track all non-inode metadata in the buffers list
- * hanging off the address_space structure.
+ * This is an implementation of the fsync method for simple filesystems which
+ * track all non-inode metadata in the buffers list hanging off the @mmb
+ * structure.
  */
-int generic_buffers_fsync_noflush(struct file *file, loff_t start, loff_t end,
-				  bool datasync)
+int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
+		      loff_t start, loff_t end, bool datasync)
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
+		ret = mmb_sync(mmb);
 	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
 		goto out;
 	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
@@ -669,34 +664,35 @@ int generic_buffers_fsync_noflush(struct file *file, loff_t start, loff_t end,
 		ret = err;
 	return ret;
 }
-EXPORT_SYMBOL(generic_buffers_fsync_noflush);
+EXPORT_SYMBOL(mmb_fsync_noflush);
 
 /**
- * generic_buffers_fsync - generic buffer fsync implementation
- * for simple filesystems with no inode lock
+ * mmb_fsync - fsync implementation for simple filesystems with metadata
+ * 	       buffers list
  *
  * @file:	file to synchronize
+ * @mmb:	list of metadata bhs to flush
  * @start:	start offset in bytes
  * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
  *
- * This is a generic implementation of the fsync method for simple
- * filesystems which track all non-inode metadata in the buffers list
- * hanging off the address_space structure. This also makes sure that
- * a device cache flush operation is called at the end.
+ * This is an implementation of the fsync method for simple filesystems which
+ * track all non-inode metadata in the buffers list hanging off the @mmb
+ * structure. This also makes sure that a device cache flush operation is
+ * called at the end.
  */
-int generic_buffers_fsync(struct file *file, loff_t start, loff_t end,
-			  bool datasync)
+int mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
+	      loff_t start, loff_t end, bool datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int ret;
 
-	ret = generic_buffers_fsync_noflush(file, start, end, datasync);
+	ret = mmb_fsync_noflush(file, mmb, start, end, datasync);
 	if (!ret)
 		ret = blkdev_issue_flush(inode->i_sb->s_bdev);
 	return ret;
 }
-EXPORT_SYMBOL(generic_buffers_fsync);
+EXPORT_SYMBOL(mmb_fsync);
 
 /*
  * Called when we've recently written block `bblock', and it is known that
@@ -717,20 +713,18 @@ void write_boundary_block(struct block_device *bdev,
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
@@ -797,14 +791,12 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 EXPORT_SYMBOL(block_dirty_folio);
 
 /*
- * Invalidate any and all dirty buffers on a given inode.  We are
+ * Invalidate any and all dirty buffers on a given buffers list.  We are
  * probably unmounting the fs, but that doesn't mean we have already
  * done a sync().  Just drop the buffers from the inode list.
  */
-void invalidate_inode_buffers(struct inode *inode)
+void mmb_invalidate(struct mapping_metadata_bhs *mmb)
 {
-	struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
-
 	if (mmb_has_buffers(mmb)) {
 		spin_lock(&mmb->lock);
 		while (!list_empty(&mmb->list))
@@ -812,7 +804,7 @@ void invalidate_inode_buffers(struct inode *inode)
 		spin_unlock(&mmb->lock);
 	}
 }
-EXPORT_SYMBOL(invalidate_inode_buffers);
+EXPORT_SYMBOL(mmb_invalidate);
 
 /*
  * Create the appropriate buffers when given a folio for data area and
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 44094fd476f5..e207dcca7a25 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -205,12 +205,30 @@ struct buffer_head *create_empty_buffers(struct folio *folio,
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
+int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
+		      loff_t start, loff_t end, bool datasync);
+static inline int generic_buffers_fsync_noflush(struct file *file,
+						loff_t start, loff_t end,
+						bool datasync)
+{
+	return mmb_fsync_noflush(file, &file->f_mapping->i_metadata_bhs,
+				 start, end, datasync);
+}
+int mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
+	      loff_t start, loff_t end, bool datasync);
+static inline int generic_buffers_fsync(struct file *file,
+					loff_t start, loff_t end, bool datasync)
+{
+	return mmb_fsync(file, &file->f_mapping->i_metadata_bhs,
+			 start, end, datasync);
+}
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
 static inline void clean_bdev_bh_alias(struct buffer_head *bh)
@@ -515,9 +533,18 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
+void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping);
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
-void invalidate_inode_buffers(struct inode *inode);
-int sync_mapping_buffers(struct address_space *mapping);
+void mmb_invalidate(struct mapping_metadata_bhs *mmb);
+int mmb_sync(struct mapping_metadata_bhs *mmb);
+static inline void invalidate_inode_buffers(struct inode *inode)
+{
+	mmb_invalidate(&inode->i_data.i_metadata_bhs);
+}
+static inline int sync_mapping_buffers(struct address_space *mapping)
+{
+	return mmb_sync(&mapping->i_metadata_bhs);
+}
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
 bool has_bh_in_lru(int cpu, void *dummy);
@@ -527,6 +554,7 @@ extern int buffer_heads_over_limit;
 
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
+static inline int mmb_sync(struct mapping_metadata_bhs *mmb) { return 0; }
 static inline void invalidate_inode_buffers(struct inode *inode) {}
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
-- 
2.51.0


