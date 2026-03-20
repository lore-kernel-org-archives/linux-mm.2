Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71DAC1098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7326B00DB; Fri, 20 Mar 2026 09:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0F06B00DC; Fri, 20 Mar 2026 09:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0896B00DE; Fri, 20 Mar 2026 09:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA156B00DC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA7BA86C97
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:11 +0000 (UTC)
X-FDA: 84566557782.25.640B151
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DC6D40005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D7FnOwOI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uf4ahYfU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D7FnOwOI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uf4ahYfU;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oX/JsvXwPm/CAxn2sGZiEEbiTcloxq4ZGOeTqxutKB4=;
	b=r4jfFGMTH8sKVX2jIv8+C/3lryoQqkj9woqeREb2FvheI/rvhXpaCol932dzY2jSll14j0
	w3s/s3FIYMdoedejc3wWzIoI58dSz/Uv8mU6m8PWEKY94UsjNsvbIhEJimWeT9Ghdyfjxl
	9mH4VIo3/CllPUJ4czLOWJevMfeuxeY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014189; a=rsa-sha256;
	cv=none;
	b=b5dSNVjaQtBoIf196eswiAcSE0ZpD7xO3B1ydCLGjjt4QOsxS5G0etutvIgXXLmZAOex9V
	cZYMKkzq/K7oY3n66crR1hYcdzlLhhu7CLdxz/CvvhfLiRBFiRfaqtNZepqzazda0GQfNe
	jKkOu7RbgOtIaOX1Nk8PQcpBySBUvIE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D7FnOwOI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uf4ahYfU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D7FnOwOI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uf4ahYfU;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 821B44D422;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oX/JsvXwPm/CAxn2sGZiEEbiTcloxq4ZGOeTqxutKB4=;
	b=D7FnOwOIvl44uigTgjxjb7eeoZKN2Xf1sdrO6INVERm5jsCooPW0DIyZQlPGrOk/jOFH42
	mSuqmZ+EKg+3R7TjkaD5Y5PqUUNiSdOkDm+KrP7RHN1roEixKt8wYqSl2avEIexfL2K1Zf
	GS5R2It3/gxvNY81tfEagMLOw4rt0f8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oX/JsvXwPm/CAxn2sGZiEEbiTcloxq4ZGOeTqxutKB4=;
	b=uf4ahYfU4yJZTPRzSJ/nsD0y0+cs//RFp48RznNG1HNwkDtjucyxEtUrNeezV20Q95/noe
	tnyuuLAkOa+c5EBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oX/JsvXwPm/CAxn2sGZiEEbiTcloxq4ZGOeTqxutKB4=;
	b=D7FnOwOIvl44uigTgjxjb7eeoZKN2Xf1sdrO6INVERm5jsCooPW0DIyZQlPGrOk/jOFH42
	mSuqmZ+EKg+3R7TjkaD5Y5PqUUNiSdOkDm+KrP7RHN1roEixKt8wYqSl2avEIexfL2K1Zf
	GS5R2It3/gxvNY81tfEagMLOw4rt0f8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oX/JsvXwPm/CAxn2sGZiEEbiTcloxq4ZGOeTqxutKB4=;
	b=uf4ahYfU4yJZTPRzSJ/nsD0y0+cs//RFp48RznNG1HNwkDtjucyxEtUrNeezV20Q95/noe
	tnyuuLAkOa+c5EBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 740C34281E;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SPZUHJlOvWmDCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3E69AA0B2E; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 27/41] fs: Fold fsync_buffers_list() into sync_mapping_buffers()
Date: Fri, 20 Mar 2026 14:41:22 +0100
Message-ID: <20260320134100.20731-68-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7522; i=jack@suse.cz; h=from:subject; bh=rLj2k8FC5Tey+MdE0VfUZj3+Y5rWoTAvVRz1Fch+n/c=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6DlCp9UTpHdt1UkLQXTnr+fUisFYJHI+1Da skt7bJqQneJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OgwAKCRCcnaoHP2RA 2SjECADZ/AZUhmJibhL/fxZh7Xl+8rRaEw7FOUlq47Zky0nr29CR2tbaJ7BDYJLQ4JPzM5qLiwv iktX6OPkxdT8MbOT9W4BjSaB72eVrBQufgQFhkmrp3xcksckct9uUc8ll36o+fMqlM5k62hgheu 5ElO/bc6TVvvG/Iu6jYesvvAcZl78ziVXI7NPzIlS6FwGPCAztC7bVpWpj0LGnROceh2b15c/Da yZFlkUfX67vBsOTG/FZjUUQLIDM+H9YOhaNwKP08RBb3/nuG6R+WYph/8+FbaIWHv0XxmdWqb/J X5jLst0caltmwm0AIi04oqX2rqSL/VeKD32XpO42ZbAgD+3B
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6DC6D40005
X-Stat-Signature: dtt78rxeajs4kkwhi9e1fwhs1pyu9uni
X-HE-Tag: 1774014189-552498
X-HE-Meta: U2FsdGVkX19DU36gsby6gFiT3oDA7bXmD7TsRZ0UtUbhPFP36RToa63JsxMSrBjP8DOPE0mQkI896V56fASSRm4Nqc/zVvtARPf0+1n32Y4u75hF4cIP0U78Wbpx23ZZJXQE1Bl82J0j/8X1FTtdlsK58PfHMnnyUilNiSBiWbw/MzV3fyqxSWYrH4ZZUPt3NjmZ6wpKHIvSC+Qtq1nKnBYfppuZJHLT9LpSBSGpcGxTH61VsEi3OyMrFRTR+57aakr0Y+mR4EyHUNQYXwwgqjJ+jow+0J+7gTmud4YKF3s6JLjuB0uZcF0Yb9Gl9/h4FXJSN6MhwVCLf/g3D0Gnj7xMM18+dGbsI30nPm3L9x2GfzmxUwvtzh87iDmw+xRuPjLXZgjWot4GESJWtv2ajK0nREfKpiAfsL/tIv2snYxearmZpIhoml0S4ff5AZNWsuhrlN5hFH9uFyIvHSrIiEXs6Z2F9AjiHiQFwePlm6pyhDwDoA1y4fC9skxphJ9z9SFfu1oyUirSzIwop1UjOznQ/TiwNy675I7sIaYfHQKRoftg/cOEYVpzVeKhVkjXnxw/jKDgagiQolNXoa/iUzHwKdn7LzcijVBM6TtV6SbmH+02crRDBzfk9dq/opro9/1lFz/k4mb9F3sgLGDHRaLOeKpzO+NJVdxcvp6bdh5756kp8NT9yDtgYs25mx7prZb4eBI1LCNe4tErrvCVNgloCnLmzitqsFARHKpAXDcEx99Y8vcQiINC8rJrWjF2LSxJx+pPR6Y7ZWyYKVt5myqWow+Tz/Vp94HWl9P7wiuyznBSV7z2kwM7hL+lXD8yv6xpOLnP7n/gJHhrigZpr4S/37rmKETEQ2NyVfos3tZ4YV90sE6SKjKN9BIlEsmGQ5SJVmjTG4o8KUV+ZMJmu/OMyE4E5z+n2uG5GkbAKqcU8g01k4GgzhjP6g3tTXMDxog1D7SuTX2NwwwFBgt
 mBkfZ1e3
 wdHNrTGb5/uwQ5wa/365oY4L4S8uHeQF3No/cc54RNA+q7W01PtdhqV8LlkMvjZGuKwnrlY3gntfNJtFpuhZUWWC6DAmsHHnw5fmXZDR4Mjmxg9PU8kRV7K//fSIkxDM5t/+uAs8Hq6cFPB/EBhwNeKTGoMhT/QYxEoQTnJQNvOgMM3cHk3m8JKsT1oZ9a+XffS5XQOFz0IIzmvGMbn27RL1gI0/KXn8RRxaej1CNTzJw6UZuwL55wxohqCICbhUxV/TAxS1HAytKU0ITP6aSedplO9P4+jtzd/Aj/jDZT2Jl6wMbilbm0vO50NbGiWx50yWZ+XlBu7xJLlXE4Uq0JGWbmNhh6jjfReJbYHniYoqBrb8=
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


