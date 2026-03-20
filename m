Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B241098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BE936B00FA; Fri, 20 Mar 2026 09:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085956B00F7; Fri, 20 Mar 2026 09:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3D36B00F6; Fri, 20 Mar 2026 09:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1DB86B00F3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98DBE1C9E8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:36 +0000 (UTC)
X-FDA: 84566558832.08.98289C0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5277240011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KhUzaLHg+OLOZbhWiHDNOxpEYIIhembkQfX6Xqdkb1k=;
	b=mNwM8IHB17+g9kmCPmQg+l/ClSZjBC7bQaeACeRDOo9iGTzWYY9DKfE4wkIFUpNV3JmlW6
	Ah0qM5RgBdDDXQbAWLa1Lno6wC8VLrwiAhufZnHg5SUbabxnyveQtIZk7CVcYU2oHyI2U3
	EuU805Avpx6voySMNk1V51E6EEXkOfU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014214; a=rsa-sha256;
	cv=none;
	b=uqXgDH110kn5bgff1Ll4KB52SQlDIXg6Hs9I5ebzKZLFa9HI73/H3djKlKFzTeMXDWGFmo
	LUe8jh+28/RPxUAhMrtwNTq+WgaLI8DqDumaem2AZcNj8kItPX6WHwmvkmoqH6wNzz2fYJ
	rh07m1NNFDPFr1HHxTrsjayj1hNs8Qk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6F774D429;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB2144281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Hs6tLZlOvWmUCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 83373A0A9E; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 35/41] fat: Track metadata bhs in fs-private inode part
Date: Fri, 20 Mar 2026 14:41:30 +0100
Message-ID: <20260320134100.20731-76-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8966; i=jack@suse.cz; h=from:subject; bh=QgGjN7c4BxfRd0ABPBq3l3E98TILcHEVPdX1WPwyso4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6KVzjrAXwYd+c5QPGypEMK4TFB8QYv8MQul UtIQkDZw9CJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OigAKCRCcnaoHP2RA 2cobCADKwUSnOjgiClgfB6psXW26C/z1qDULnxQ4+nohcpiWLODZ5u/jUz/absOxIH3a/RR0ORD CszYoOlHuEiUPvW4W0XId15Drh8UpbZ4BttnRPPZpiGOy2kHHpOXlbnTpQNGFpwQPQ6rj+r6V3a oGsrYoU/AuqU0pBRPay2gIx8+vQ53FQyp1i1FLguPs2GKkywxVHBJXfHKJV6Fk/Nxe58G879VK3 k1Nu8Ga1tY9bi7H79XRzo8jGRv2eb37QMLaMlqmH0kZNTkO4MzrO7eD3+bk8QI6RBM/N/5RW/CK lvRKb9MGwueLLaEULyKe8HjkvecUVLYxMSG4CESE0E2TUiGN
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5277240011
X-Stat-Signature: pd6cf85hywbcqermmtffagbsi6fjobwp
X-Rspam-User: 
X-HE-Tag: 1774014214-844833
X-HE-Meta: U2FsdGVkX1+DUGTuKR6TgZwoRtZcGb531MvzZNCQ0ok/IaY/QDjwS2zssP726AWJCwz79oyzrBln1ExuxAp2UaC4C7qtFAiNSWLZYpHcdXMew1A0mPzeb5YyP6xWc9BB08ZbgqqYN0vK06OrTs9wGgO/puh4nQkj7fcAiVirC5upy521ly037cE/KxKfBLLKuii5nubi2sp5Um3O9aJjn8VjmOXSVP1Z2/lb1SMiuCIvDgz4EPOtKpWSUEu1XnwPV3V3QdtJu1Ky+EDpxG0jtbsycvPmjmp0nZopowX4ipyeytRpznZ28YAykpekRA9OudVzLJx3BmBnXut/I5JqE/ZQCq1CL5oRL6O9959St6iEJpb+F4xMrxIfNQhaUV6CMgzFSh3MbnRIDKgEdtgeBU5WvQLg1BivxfZZQ9FerBrpIBgVqFyw0p6wHmxLu09i+8GwOF7B+ov1C24RcFJ4KsD5EpnMSD+ms5EyveWx3HnZ8rxazDbP4AZO1zuEWiSJSHZll6POSJiryWV8ew8Gb3Yy1hPNmTTELMptN3Y7IzCNkMYGtKoNXgI3uHTZmjBwBkOAYVfbzVPb7R8Nfg9SRxA+FGnM7bUSQU8dEtKI1OIBup6ZnIwd/spVGkhf7XKR6Ksv+MHEmUfs4Tqn067+KDgBuKlFsuN7EXNe9NY8WIgcp9mCdlL289G47Bro5e4bZ/DPaGQJyIrfDpprMIbCHrFRsushcF/RU1AeVeeUuyj5kRTisOIsMjw+KVHXsZZ4nrfOc9999spPfgbrw4aQiwBGbJ+ZvobJLHh+V8EI98PiG1UkIbVzQ1x/tC2jigtd9uzWa8UJV9ghfpWUXsSowaglqpdsibWm9IxhviuaXrBOEAdGW7NLfPTQveytrnMVSOZYdzsMe+HEoCri2cGqoD/ou3RCePKd8hGJRg7/D+XGrUDlEo+e0YjDemvBScEmoAJFN+i4RjluvZEYrIC
 sVTUE+FF
 iLaBc1hsaKXhswIjZFEmFh/lnAG7RwIXC2Djw+dHsdQMvkatmLEc++jRQyaJCHKTV1OV7bVEPoOzno1IBuMDm25pbzDTptWMDT/jJHP7Icr1yyKfFtRCctLmO0jamTlId0COYxZpkS3+GeyVvsC5FzQ7QNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/dir.c         | 17 ++++++++++-------
 fs/fat/fat.h         |  1 +
 fs/fat/fatent.c      | 15 ++++++++++-----
 fs/fat/file.c        |  8 +++++---
 fs/fat/inode.c       |  5 +++--
 fs/fat/namei_msdos.c |  6 ++++--
 fs/fat/namei_vfat.c  |  2 +-
 7 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 4b8b25f688e4..4f6f42f33613 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1027,7 +1027,7 @@ static int __fat_remove_entries(struct inode *dir, loff_t pos, int nr_slots)
 			de++;
 			nr_slots--;
 		}
-		mark_buffer_dirty_inode(bh, dir);
+		mmb_mark_buffer_dirty(bh, &MSDOS_I(dir)->i_metadata_bhs);
 		if (IS_DIRSYNC(dir))
 			err = sync_dirty_buffer(bh);
 		brelse(bh);
@@ -1062,7 +1062,7 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 		de--;
 		nr_slots--;
 	}
-	mark_buffer_dirty_inode(bh, dir);
+	mmb_mark_buffer_dirty(bh, &MSDOS_I(dir)->i_metadata_bhs);
 	if (IS_DIRSYNC(dir))
 		err = sync_dirty_buffer(bh);
 	brelse(bh);
@@ -1114,7 +1114,7 @@ static int fat_zeroed_cluster(struct inode *dir, sector_t blknr, int nr_used,
 		memset(bhs[n]->b_data, 0, sb->s_blocksize);
 		set_buffer_uptodate(bhs[n]);
 		unlock_buffer(bhs[n]);
-		mark_buffer_dirty_inode(bhs[n], dir);
+		mmb_mark_buffer_dirty(bhs[n], &MSDOS_I(dir)->i_metadata_bhs);
 
 		n++;
 		blknr++;
@@ -1195,7 +1195,7 @@ int fat_alloc_new_dir(struct inode *dir, struct timespec64 *ts)
 	memset(de + 2, 0, sb->s_blocksize - 2 * sizeof(*de));
 	set_buffer_uptodate(bhs[0]);
 	unlock_buffer(bhs[0]);
-	mark_buffer_dirty_inode(bhs[0], dir);
+	mmb_mark_buffer_dirty(bhs[0], &MSDOS_I(dir)->i_metadata_bhs);
 
 	err = fat_zeroed_cluster(dir, blknr, 1, bhs, MAX_BUF_PER_PAGE);
 	if (err)
@@ -1257,7 +1257,8 @@ static int fat_add_new_entries(struct inode *dir, void *slots, int nr_slots,
 			memcpy(bhs[n]->b_data, slots, copy);
 			set_buffer_uptodate(bhs[n]);
 			unlock_buffer(bhs[n]);
-			mark_buffer_dirty_inode(bhs[n], dir);
+			mmb_mark_buffer_dirty(bhs[n],
+					      &MSDOS_I(dir)->i_metadata_bhs);
 			slots += copy;
 			size -= copy;
 			if (!size)
@@ -1358,7 +1359,8 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 		for (i = 0; i < long_bhs; i++) {
 			int copy = umin(sb->s_blocksize - offset, size);
 			memcpy(bhs[i]->b_data + offset, slots, copy);
-			mark_buffer_dirty_inode(bhs[i], dir);
+			mmb_mark_buffer_dirty(bhs[i],
+					      &MSDOS_I(dir)->i_metadata_bhs);
 			offset = 0;
 			slots += copy;
 			size -= copy;
@@ -1369,7 +1371,8 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			/* Fill the short name slot. */
 			int copy = umin(sb->s_blocksize - offset, size);
 			memcpy(bhs[i]->b_data + offset, slots, copy);
-			mark_buffer_dirty_inode(bhs[i], dir);
+			mmb_mark_buffer_dirty(bhs[i],
+					      &MSDOS_I(dir)->i_metadata_bhs);
 			if (IS_DIRSYNC(dir))
 				err = sync_dirty_buffer(bhs[i]);
 		}
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 0d269dba897b..5a58f0bf8ce8 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -130,6 +130,7 @@ struct msdos_inode_info {
 	struct hlist_node i_dir_hash;	/* hash by i_logstart */
 	struct rw_semaphore truncate_lock; /* protect bmap against truncate */
 	struct timespec64 i_crtime;	/* File creation (birth) time */
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index a7061c2ad8e4..f0801d99dd62 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -170,9 +170,11 @@ static void fat12_ent_put(struct fat_entry *fatent, int new)
 	}
 	spin_unlock(&fat12_entry_lock);
 
-	mark_buffer_dirty_inode(fatent->bhs[0], fatent->fat_inode);
+	mmb_mark_buffer_dirty(fatent->bhs[0],
+			      &MSDOS_I(fatent->fat_inode)->i_metadata_bhs);
 	if (fatent->nr_bhs == 2)
-		mark_buffer_dirty_inode(fatent->bhs[1], fatent->fat_inode);
+		mmb_mark_buffer_dirty(fatent->bhs[1],
+				&MSDOS_I(fatent->fat_inode)->i_metadata_bhs);
 }
 
 static void fat16_ent_put(struct fat_entry *fatent, int new)
@@ -181,7 +183,8 @@ static void fat16_ent_put(struct fat_entry *fatent, int new)
 		new = EOF_FAT16;
 
 	*fatent->u.ent16_p = cpu_to_le16(new);
-	mark_buffer_dirty_inode(fatent->bhs[0], fatent->fat_inode);
+	mmb_mark_buffer_dirty(fatent->bhs[0],
+			      &MSDOS_I(fatent->fat_inode)->i_metadata_bhs);
 }
 
 static void fat32_ent_put(struct fat_entry *fatent, int new)
@@ -189,7 +192,8 @@ static void fat32_ent_put(struct fat_entry *fatent, int new)
 	WARN_ON(new & 0xf0000000);
 	new |= le32_to_cpu(*fatent->u.ent32_p) & ~0x0fffffff;
 	*fatent->u.ent32_p = cpu_to_le32(new);
-	mark_buffer_dirty_inode(fatent->bhs[0], fatent->fat_inode);
+	mmb_mark_buffer_dirty(fatent->bhs[0],
+			      &MSDOS_I(fatent->fat_inode)->i_metadata_bhs);
 }
 
 static int fat12_ent_next(struct fat_entry *fatent)
@@ -395,7 +399,8 @@ static int fat_mirror_bhs(struct super_block *sb, struct buffer_head **bhs,
 			memcpy(c_bh->b_data, bhs[n]->b_data, sb->s_blocksize);
 			set_buffer_uptodate(c_bh);
 			unlock_buffer(c_bh);
-			mark_buffer_dirty_inode(c_bh, sbi->fat_inode);
+			mmb_mark_buffer_dirty(c_bh,
+				&MSDOS_I(sbi->fat_inode)->i_metadata_bhs);
 			if (sb->s_flags & SB_SYNCHRONOUS)
 				err = sync_dirty_buffer(c_bh);
 			brelse(c_bh);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 1551065a7964..3bac06b41420 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -186,13 +186,15 @@ static int fat_file_release(struct inode *inode, struct file *filp)
 int fat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = filp->f_mapping->host;
+	struct inode *fat_inode = MSDOS_SB(inode->i_sb)->fat_inode;
 	int err;
 
-	err = generic_buffers_fsync_noflush(filp, start, end, datasync);
+	err = generic_mmb_fsync_noflush(filp, &MSDOS_I(inode)->i_metadata_bhs,
+					start, end, datasync);
 	if (err)
 		return err;
 
-	err = sync_mapping_buffers(MSDOS_SB(inode->i_sb)->fat_inode->i_mapping);
+	err = mmb_sync_buffers(&MSDOS_I(fat_inode)->i_metadata_bhs);
 	if (err)
 		return err;
 
@@ -236,7 +238,7 @@ static int fat_cont_expand(struct inode *inode, loff_t size)
 		 */
 		err = filemap_fdatawrite_range(mapping, start,
 					       start + count - 1);
-		err2 = sync_mapping_buffers(mapping);
+		err2 = mmb_sync_buffers(&MSDOS_I(inode)->i_metadata_bhs);
 		if (!err)
 			err = err2;
 		err2 = write_inode_now(inode, 1);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index ce88602b0d57..1e54091c80fc 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -658,11 +658,11 @@ static void fat_evict_inode(struct inode *inode)
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
 	} else {
-		sync_mapping_buffers(inode->i_mapping);
+		mmb_sync_buffers(&MSDOS_I(inode)->i_metadata_bhs);
 		fat_free_eofblocks(inode);
 	}
 
-	invalidate_inode_buffers(inode);
+	mmb_invalidate_buffers(&MSDOS_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	fat_cache_inval_inode(inode);
 	fat_detach(inode);
@@ -763,6 +763,7 @@ static struct inode *fat_alloc_inode(struct super_block *sb)
 	ei->i_pos = 0;
 	ei->i_crtime.tv_sec = 0;
 	ei->i_crtime.tv_nsec = 0;
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
 
 	return &ei->vfs_inode;
 }
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 048c103b506a..4cc65f330fb7 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -527,7 +527,8 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 
 	if (update_dotdot) {
 		fat_set_start(dotdot_de, MSDOS_I(new_dir)->i_logstart);
-		mark_buffer_dirty_inode(dotdot_bh, old_inode);
+		mmb_mark_buffer_dirty(dotdot_bh,
+				      &MSDOS_I(old_inode)->i_metadata_bhs);
 		if (IS_DIRSYNC(new_dir)) {
 			err = sync_dirty_buffer(dotdot_bh);
 			if (err)
@@ -566,7 +567,8 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 
 	if (update_dotdot) {
 		fat_set_start(dotdot_de, MSDOS_I(old_dir)->i_logstart);
-		mark_buffer_dirty_inode(dotdot_bh, old_inode);
+		mmb_mark_buffer_dirty(dotdot_bh,
+				      &MSDOS_I(old_inode)->i_metadata_bhs);
 		corrupt |= sync_dirty_buffer(dotdot_bh);
 	}
 error_inode:
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 87dcdd86272b..918b3756674c 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -915,7 +915,7 @@ static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
 				 struct msdos_dir_entry *dotdot_de)
 {
 	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
-	mark_buffer_dirty_inode(dotdot_bh, inode);
+	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
 	if (IS_DIRSYNC(dir))
 		return sync_dirty_buffer(dotdot_bh);
 	return 0;
-- 
2.51.0


