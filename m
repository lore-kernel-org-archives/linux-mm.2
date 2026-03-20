Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F911098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679C46B0109; Fri, 20 Mar 2026 09:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603956B010A; Fri, 20 Mar 2026 09:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2B06B010B; Fri, 20 Mar 2026 09:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9FF6B0109
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:44:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00164140205
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:44:00 +0000 (UTC)
X-FDA: 84566559882.22.1C00F17
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id B9126100005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eXF3Nlx97L/BJSoTWrHqJI0dI7P/hpjeS1S4hNknqYk=;
	b=E52kOmi3YKSt9nXOgknS1b5n9lZXYh6SBXl3djBiDfwz0YizPlZcUwvEHiXXVXdYc3V4vd
	NXHbklwa2EvLxp+Nmzpt4gUgKFYf/1LRydAsjSWciBkMmh8st97XZ5tCJfsf3YuTixxM/q
	2Uh0ugezObggSjKzSsnfCrR5vhJCNxE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014239; a=rsa-sha256;
	cv=none;
	b=NCBD0A1JA6t4W5LNlIVPmmxruksJrnCZL28UcTW9wKsW/dm7Zt3upqq3mDEtxI0b+L9kwE
	5+WWyQXn8vFv3LOsT6Bg/JI2YhYmj9jqt9JnDDioR/oX8Vm6FFwSQlnPDeajgezcpKwjsm
	2UAX/O5wIBrSoAJCnw/nUrkgr3TeA2E=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00D984D430;
	Fri, 20 Mar 2026 13:41:46 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E75CC4281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E0N5OJlOvWmgCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B40BAA0A81; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 41/41] fs: Unify generic_file_fsync() with mmb methods
Date: Fri, 20 Mar 2026 14:41:36 +0100
Message-ID: <20260320134100.20731-82-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10120; i=jack@suse.cz; h=from:subject; bh=u3porfR07OCSVbnK5mwmJNrIjfzwKCHhr+GnDb/R8VQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6PfWFNF+k1rQzIhgJAYYebiqgveBacW4oG8 qimx8h0nMmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OjwAKCRCcnaoHP2RA 2cTLCACwh4E0JVe7BO+48vRSYOUK8hnfU856Oyx3btgU/BDTI49z5bh2XML2yiFpSgWzTSsoYH8 WdAo6pdqwRuihDoPDRVbGOw+vzMzm9+4S4i/e51Gf4MnjPi0JfmYxR8imaaiDxb1ad8wPU9Hzcs 9uAG1BUQqCm7nnN62hSA1AxqqA33vyMMlPp32DDis2B/jC268SLTiWcjaqUt5LvrRkBIIKT/ZJV jz6FojU4Jfhes0T7iG7G3lLkAQs+4FYgnla/P19Af/WEGDWfSwqXlQV8d5eJ8C1rnvdAbU4Uf6d 4Xoe8e6DjRa1Js4mT9uxlwtvoeylfEjgDQsFYt3eKJqqC4VP
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B9126100005
X-Rspamd-Server: rspam07
X-Stat-Signature: prrpaso54r43ytpzont9migfubqyawji
X-Rspam-User: 
X-HE-Tag: 1774014238-449930
X-HE-Meta: U2FsdGVkX18KP+VitvL1tGA2oUvxErBePLyT2KzkwL8To8SsyNi3epQFpaW5y/3mtFrPXMxbZ0MKiED2PrseHQr76GOI5u1c8ieKBReN8bXto8+8fB4oPaTFmMwXEjxH2hZTRTkbBKfc5IHfkVMWsvLNzWIyCwgmnWvXCPa3iztq/p7PiLr6acoNyt/RmA9rWnvwN/ioiucGL15rGk4pa8JcqyjZUrYnR34BF/i2z/taKhRYp2IK1buOBH3WMmty+i87yWOUdx8DBHCauW0EsyknWWsRhWO/SMyUF6w07O4HzcP8K+BLR1LA6XXyQH9ZLXLMH8C4llXnsxYefl11hSTKq+MQC2TMWZEc6eUXIG5lqvSkM4pyJQzAeBkLT1i/tOXRnmwJhioRJkr1yG9IkKL52d1dox24ArJUompdThIuRtEEIpE2vuCxjYcE0J+94xqtKGYGhlOdVxtYQIicWetrIka1APeRC0Uv3KLnHUq7AdlkwjhAJFLWug1Wt2A9qT/E+nxZ9sv+RXBjCsxWLldrF2XaWMk9phhlERllL40V2ASdl9RRboeAyHb+49eAnFHJ3gg7UOjDCODD7DGjgGNm9I6Wud1j84XyruxROPlo2tRyWgyHIEc3vlzY6v3sQlLVcCcToixYIc2B+Q78aSCzusJFDUFi2VGA0mLCPZwDzQnOtKnYEMDGsRUpnUnQhV0yLOS3GfaSqdtWLusW8DQTC57oDTZ/WU3TvA2p1P/4o6dK4weiKH86RFL/Y7gidTHbo5xaAkHYMbsKvMIaum1wosFkcLcDFGltSO1629NTvpV8lj2WjS+uQKdsV4FYBsTAbrvKFPWHUJJybBRHM1pE2TsXh7OU6EsXNhl3w1WkUzgJXDTezXUkBFGPaT/ogjQIhu8NyYUomdQt9bS9yOS46c8MJXOQlvxHhcJBcswR27KFCxxSs8D7P7UHD3ToPyr0puhoI3fqv1Yv5lV
 fp7AG49U
 wPEmzenrXKIW4G/qYGk7d1fBHfPbSEXYYRsMfXGMc7N9MPh4Keue5TK2qJ3ly5ZCa2T3y5+WDQPRBV1hUbqKpigjmwzMKu8I9RAu/jUPKzopOXd0S+95Afa4V723sPKhie55ImUwLHciH403pPQ1mPfLn0kvGqZucuX8pU1a/7sSwYUMKB4mGPY1q65dUZ8iV6YBS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__generic_file_fsync() is practically identical to
generic_mmb_fsync_noflush() with one subtle difference:

1) __generic_file_fsync() takes inode lock when calling writing out the
inode.
2) generic_mmb_fsync_noflush() calls mmb_sync_buffers().

Taking inode lock when writing out the inode seems pointless in
particular because there are lots of places (most notably sync(2) path)
that don't do that so hardly anything can depend on it. When NULL is
passed to generic_mmb_fsync_noflush(), mmb_sync_buffers() is not called
so that difference is not a problem.

So let's remove __generic_file_fsync() and use
generic_mmb_fsync_noflush() instead to reduce code duplication. Arguably
this leaks a bit of buffer_head knowledge into fs/libfs.c which is not
great but avoiding the duplication seems worth it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 74 -------------------------------------
 fs/exfat/file.c             |  2 +-
 fs/libfs.c                  | 57 ++++++++++++++++------------
 include/linux/buffer_head.h |  5 ---
 include/linux/fs.h          | 12 +++++-
 5 files changed, 45 insertions(+), 105 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 43aca5b7969f..591aed740601 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -621,80 +621,6 @@ int mmb_sync_buffers(struct mapping_metadata_bhs *mmb)
 }
 EXPORT_SYMBOL(mmb_sync_buffers);
 
-/**
- * generic_mmb_fsync_noflush - generic buffer fsync implementation
- * for simple filesystems with no inode lock
- *
- * @file:	file to synchronize
- * @mmb:	list of metadata bhs to flush
- * @start:	start offset in bytes
- * @end:	end offset in bytes (inclusive)
- * @datasync:	only synchronize essential metadata if true
- *
- * This is a generic implementation of the fsync method for simple
- * filesystems which track all non-inode metadata in the buffers list
- * hanging off the address_space structure.
- */
-int generic_mmb_fsync_noflush(struct file *file,
-			      struct mapping_metadata_bhs *mmb,
-			      loff_t start, loff_t end, bool datasync)
-{
-	struct inode *inode = file->f_mapping->host;
-	int err;
-	int ret = 0;
-
-	err = file_write_and_wait_range(file, start, end);
-	if (err)
-		return err;
-
-	if (mmb)
-		ret = mmb_sync_buffers(mmb);
-	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
-		goto out;
-	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
-		goto out;
-
-	err = sync_inode_metadata(inode, 1);
-	if (ret == 0)
-		ret = err;
-
-out:
-	/* check and advance again to catch errors after syncing out buffers */
-	err = file_check_and_advance_wb_err(file);
-	if (ret == 0)
-		ret = err;
-	return ret;
-}
-EXPORT_SYMBOL(generic_mmb_fsync_noflush);
-
-/**
- * generic_mmb_fsync - generic buffer fsync implementation
- * for simple filesystems with no inode lock
- *
- * @file:	file to synchronize
- * @mmb:	list of metadata bhs to flush
- * @start:	start offset in bytes
- * @end:	end offset in bytes (inclusive)
- * @datasync:	only synchronize essential metadata if true
- *
- * This is a generic implementation of the fsync method for simple
- * filesystems which track all non-inode metadata in the buffers list
- * hanging off the address_space structure. This also makes sure that
- * a device cache flush operation is called at the end.
- */
-int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
-		      loff_t start, loff_t end, bool datasync)
-{
-	struct inode *inode = file->f_mapping->host;
-	int ret;
-
-	ret = generic_mmb_fsync_noflush(file, mmb, start, end, datasync);
-	if (!ret)
-		ret = blkdev_issue_flush(inode->i_sb->s_bdev);
-	return ret;
-}
-EXPORT_SYMBOL(generic_mmb_fsync);
-
 /*
  * Called when we've recently written block `bblock', and it is known that
  * `bblock' was for a buffer_boundary() buffer.  This means that the block at
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 90cd540afeaa..fe6eb391eb4e 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -577,7 +577,7 @@ int exfat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
 		return -EIO;
 
-	err = __generic_file_fsync(filp, start, end, datasync);
+	err = generic_mmb_fsync_noflush(filp, NULL, start, end, datasync);
 	if (err)
 		return err;
 
diff --git a/fs/libfs.c b/fs/libfs.c
index 548e119668df..7c1d78862e39 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -18,7 +18,7 @@
 #include <linux/exportfs.h>
 #include <linux/iversion.h>
 #include <linux/writeback.h>
-#include <linux/buffer_head.h> /* sync_mapping_buffers */
+#include <linux/buffer_head.h> /* mmb_sync_buffers() */
 #include <linux/fs_context.h>
 #include <linux/pseudo_fs.h>
 #include <linux/fsnotify.h>
@@ -1539,19 +1539,22 @@ struct dentry *generic_fh_to_parent(struct super_block *sb, struct fid *fid,
 EXPORT_SYMBOL_GPL(generic_fh_to_parent);
 
 /**
- * __generic_file_fsync - generic fsync implementation for simple filesystems
+ * generic_mmb_fsync_noflush - generic buffer fsync implementation
+ * for simple filesystems with no inode lock
  *
- * @file:	file to synchronize
- * @start:	start offset in bytes
- * @end:	end offset in bytes (inclusive)
- * @datasync:	only synchronize essential metadata if true
+ * @file:       file to synchronize
+ * @mmb:        list of metadata bhs to flush
+ * @start:      start offset in bytes
+ * @end:        end offset in bytes (inclusive)
+ * @datasync:   only synchronize essential metadata if true
  *
  * This is a generic implementation of the fsync method for simple
  * filesystems which track all non-inode metadata in the buffers list
  * hanging off the address_space structure.
  */
-int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
-				 int datasync)
+int generic_mmb_fsync_noflush(struct file *file,
+			      struct mapping_metadata_bhs *mmb,
+			      loff_t start, loff_t end, bool datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
@@ -1561,45 +1564,53 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 	if (err)
 		return err;
 
-	inode_lock(inode);
+	if (mmb)
+		ret = mmb_sync_buffers(mmb);
 	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
 		goto out;
 	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
 		goto out;
 
-	ret = sync_inode_metadata(inode, 1);
+	err = sync_inode_metadata(inode, 1);
+	if (ret == 0)
+		ret = err;
+
 out:
-	inode_unlock(inode);
 	/* check and advance again to catch errors after syncing out buffers */
 	err = file_check_and_advance_wb_err(file);
 	if (ret == 0)
 		ret = err;
 	return ret;
 }
-EXPORT_SYMBOL(__generic_file_fsync);
+EXPORT_SYMBOL(generic_mmb_fsync_noflush);
 
 /**
- * generic_file_fsync - generic fsync implementation for simple filesystems
- *			with flush
+ * generic_mmb_fsync - generic buffer fsync implementation
+ * for simple filesystems with no inode lock
+ *
  * @file:	file to synchronize
+ * @mmb:	list of metadata bhs to flush
  * @start:	start offset in bytes
  * @end:	end offset in bytes (inclusive)
  * @datasync:	only synchronize essential metadata if true
  *
+ * This is a generic implementation of the fsync method for simple
+ * filesystems which track all non-inode metadata in the buffers list
+ * hanging off the address_space structure. This also makes sure that
+ * a device cache flush operation is called at the end.
  */
-
-int generic_file_fsync(struct file *file, loff_t start, loff_t end,
-		       int datasync)
+int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
+		      loff_t start, loff_t end, bool datasync)
 {
 	struct inode *inode = file->f_mapping->host;
-	int err;
+	int ret;
 
-	err = __generic_file_fsync(file, start, end, datasync);
-	if (err)
-		return err;
-	return blkdev_issue_flush(inode->i_sb->s_bdev);
+	ret = generic_mmb_fsync_noflush(file, mmb, start, end, datasync);
+	if (!ret)
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev);
+	return ret;
 }
-EXPORT_SYMBOL(generic_file_fsync);
+EXPORT_SYMBOL(generic_mmb_fsync);
 
 /**
  * generic_check_addressable - Check addressability of file system
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 74fcc9a03c32..f003a1937826 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -207,11 +207,6 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 
 /* Things to do with metadata buffers list */
 void mmb_mark_buffer_dirty(struct buffer_head *bh, struct mapping_metadata_bhs *mmb);
-int generic_mmb_fsync_noflush(struct file *file,
-			      struct mapping_metadata_bhs *mmb,
-			      loff_t start, loff_t end, bool datasync);
-int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
-		      loff_t start, loff_t end, bool datasync);
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
 static inline void clean_bdev_bh_alias(struct buffer_head *bh)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index caa9203ed213..32178e53d448 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3298,8 +3298,16 @@ void simple_offset_destroy(struct offset_ctx *octx);
 
 extern const struct file_operations simple_offset_dir_operations;
 
-extern int __generic_file_fsync(struct file *, loff_t, loff_t, int);
-extern int generic_file_fsync(struct file *, loff_t, loff_t, int);
+int generic_mmb_fsync_noflush(struct file *file,
+			      struct mapping_metadata_bhs *mmb,
+			      loff_t start, loff_t end, bool datasync);
+int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
+		      loff_t start, loff_t end, bool datasync);
+static inline int generic_file_fsync(struct file *file,
+				     loff_t start, loff_t end, int datasync)
+{
+	return generic_mmb_fsync(file, NULL, start, end, datasync);
+}
 
 extern int generic_check_addressable(unsigned, u64);
 
-- 
2.51.0


