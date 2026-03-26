Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0EE106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA556B00E4; Thu, 26 Mar 2026 05:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569996B00E5; Thu, 26 Mar 2026 05:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431E36B00E7; Thu, 26 Mar 2026 05:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 281206B00E4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE710BD069
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:27 +0000 (UTC)
X-FDA: 84587759214.02.91F4A65
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5B902140005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OADSHKW5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l16TjtdG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OADSHKW5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l16TjtdG;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHiAer5S6vrbYMpKx0xYeQ/j67Qu5LHB+GVrhSFoFt4=;
	b=grnoDn0MAqbZ77AhbnADzv2ww83i44ete/ltJz/pdsHJJoFOi+Jb5WSLkgaIFVMp98j6wZ
	lzswY3TL66NtDKMaFTlZTL5AJXgAWPUHst4tx/zwPXPtKAiUAa1ZvmSEVTMw3a4THdJ6Iw
	anR1vgE0keX+DBGFhV9JROVMgFuMZdM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518985; a=rsa-sha256;
	cv=none;
	b=17PqsJartSsSRe53WxSDUjVtfFwrvrYVfH6AhHihpGFt7N8X47Fbh0EGm9TGOkQ8bLbvOS
	J9KTMumwSIAE9Rkrk0HwaXksYjg0g/7m2x6soGuLboxBZEepvQ5llTNf795tLiszriXSpv
	8ZAPl8iiwaTfCIGcDFy16e8+WGyZmyc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OADSHKW5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l16TjtdG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OADSHKW5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l16TjtdG;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E45F4D295;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IHiAer5S6vrbYMpKx0xYeQ/j67Qu5LHB+GVrhSFoFt4=;
	b=OADSHKW5/LfJD4Vr9FPQoAJQ+WdhB8yoqRcj7UoiGQGQ1j9OG8ww9OlzmGjCQsDXjqlsUb
	+/NjkG+EpKVG5bZDa09w5AJ5LEbBsZYKE9BFYzpom8e3My7kxx8zhH91mPcXeIlaa/yw7B
	8jPQP7g9nyvpOIxPWb/CoVH1iFTrkm4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IHiAer5S6vrbYMpKx0xYeQ/j67Qu5LHB+GVrhSFoFt4=;
	b=l16TjtdGw+T0j7IUL5SgycSjYmBmMJOYKp4v0ARxHd0DWjR1MbP9QQjac3O2LVHKdG+Gl0
	2JON3bIbrlqOl5Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IHiAer5S6vrbYMpKx0xYeQ/j67Qu5LHB+GVrhSFoFt4=;
	b=OADSHKW5/LfJD4Vr9FPQoAJQ+WdhB8yoqRcj7UoiGQGQ1j9OG8ww9OlzmGjCQsDXjqlsUb
	+/NjkG+EpKVG5bZDa09w5AJ5LEbBsZYKE9BFYzpom8e3My7kxx8zhH91mPcXeIlaa/yw7B
	8jPQP7g9nyvpOIxPWb/CoVH1iFTrkm4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IHiAer5S6vrbYMpKx0xYeQ/j67Qu5LHB+GVrhSFoFt4=;
	b=l16TjtdGw+T0j7IUL5SgycSjYmBmMJOYKp4v0ARxHd0DWjR1MbP9QQjac3O2LVHKdG+Gl0
	2JON3bIbrlqOl5Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7609F4A0AF;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GUnQHHUCxWnwYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8CF90A0C75; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 31/42] fs: Make bhs point to mapping_metadata_bhs
Date: Thu, 26 Mar 2026 10:54:25 +0100
Message-ID: <20260326095354.16340-73-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5968; i=jack@suse.cz; h=from:subject; bh=Nvg4SCHyCit7oFGSW4/ka9vNUJnfInqRbSSrUnWjLQw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJMh1XYdCxYppUDWbSf/NfZsEg51iPLas0o9 xJVAHKXQN6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCTAAKCRCcnaoHP2RA 2XOJB/0TLlZpSrZiy6tJf3KvPLed0uJyzwfcoBXKkIVZddDE4RePitBsmW7X5SEiC5vVYvl/qV4 IE2s0vJl3T9zsvIt7pG26kOYBWAgXSRUv6rziD3HD9Py1wU7eLNdtEzxRVjWXdD1vusRcAqojjf P7kbyEFmQjSBmN5e6ISTFXXfXepiz2b4lTvpiwPvWbYHmtjvptn5F6w5HGwP7U5bPnj/gIFh3aD Od2wEEYD8V5Dt76/47r0MkJEWSRvhH7qLDPaZRrGfL64d631FIhAQJoBWYxM+mLQ3Vb/C86GTjx gFe/hYnjtXjg0GKMNtOBCQCWri9ZjTfFUAwp+GxGQReadbpd
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5B902140005
X-Stat-Signature: dx9nqphr1ko5kyjnjtder8px9w6jbw5m
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774518985-402120
X-HE-Meta: U2FsdGVkX1+8lZXtD/hJzlMILWY49XosuYL7zbRYHJBGmx45+q/BvhA431qaM7pwH8N1jqAfFFttXlSP5EKn32oPJ7xoEyT/fktmaDl6UcJmiPBQXoFXWkFHSc9fbPw32glcsCcoxsASV1R5m+VZegs3AKJqJaWx94WPbd2Dl8jI3hoohnm8TaXeaJzSWJI+yH+dOGD+v4r04npGQOV/cGyeoB4iHiu0EFQjenaU+l54YCrZIV8o1ooLXpivMOCrKaIFGm7p1COw8A1Tav3doH7h+/lKkKRTUofexhC7Oq4yoJoP8J0mCfsWBSOErGZCz1wVTuZe6Esw2p5IBRVLSaN51D4tz1CtTj0WaxbJu/pBGwWPf37wPZZPAmOr+LnVs4w0nxB5CjpKOeiPgX76sQokky4lT47DrJQckr6WHcEi293dlRDNCn0t5Bs0GDsFwttN/VuwKoLBL5a9lbZ/zqud41e53XzUPR2ZuDdEZ1Sqr9000IEFObgWZ1oiT7PF9N/QNJiwmoGclxFjn+Fstn0CVBLP84fUW3kNw6rxSJI3QrTgeWpwRLnp1u4ALMmcoeXdDrr0PxBcN/RWBHPTAwyjRm+qMACV1H3FfqIm7XOmAWNna/wT7SipFKugCfJ6TzSTrrsKaJtWpZdWNERbMf11YSF8V4CPe63CKhQfQvw9laweC0hngqXpPdQb76R9u4hgppHK7BY28xH2Ez8fsLIAUKVmZ2MZE/VuUhgX5508yHSP6/uzo74bIQ5QDEEiHo77EjBStBwuA0FKY/XKyB0DgXf64BBHz/jtpUtXZEO33fICYB/Snqmi6MSTA/yb1iqiiouLTz7L7Pnm4ITPWJkIJy1FzE5nAz2ydXpXjtjAEzopxf4lUk6T8+Yi6o+NEqaaaPjoNlqkUQBIAA6GHdHGMGuXaUJ/SYbc/X4P3dCuOf6kLvVUHh4dR+62kuqdny/hsPG131kd7pZhFJH
 zPkd/VGY
 5tujQ4gMMxuX2RYM620dP5o8kiVxt3oXf5BUb06O2nu4fd3TWz8lYAW1ZUsuVw0VNIRNOrlqsC4ORcl2e86SDwfBg2RKzAbxZl6VNOwhMwNXPNgTdDcOwsrL5rzMqENdIDK4qyaRy8uBWJrtBcywzIQjJhxD/EAOmp6kGm0p1yN8v6NWeTxFkZtb1cZZYAGf4gcFK1oPD0roXOKmYUuw/QyFU2ajkcuT7OIGgHeAUc2f/2lCuenqfj9aivHOVLLWeJS196J9mgcvPPqVy/tXhAigvdgaU1+jCl35FBdqe7jWGZCnyFir/mBNQ555lgBbT+/iqcPUArK5OMXMhdPC8bpP4glZd29O+0zMY7pNTHu8Kx5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make buffer heads point to mapping_metadata_bhs instead of struct
address_space. This makes the code more self contained. For the (only)
case of IO error handling where we really need to reach struct
address_space add a pointer to the mapping from mapping_metadata_bhs.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 34 ++++++++++++++++------------------
 fs/inode.c                  |  1 +
 include/linux/buffer_head.h |  4 ++--
 include/linux/fs.h          |  1 +
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 294f9cd07f42..67b3d4624503 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -497,13 +497,12 @@ static void __remove_assoc_queue(struct mapping_metadata_bhs *mmb,
 {
 	lockdep_assert_held(&mmb->lock);
 	list_del_init(&bh->b_assoc_buffers);
-	WARN_ON(!bh->b_assoc_map);
-	bh->b_assoc_map = NULL;
+	WARN_ON(!bh->b_mmb);
+	bh->b_mmb = NULL;
 }
 
 static void remove_assoc_queue(struct buffer_head *bh)
 {
-	struct address_space *mapping;
 	struct mapping_metadata_bhs *mmb;
 
 	/*
@@ -514,13 +513,12 @@ static void remove_assoc_queue(struct buffer_head *bh)
 	 * opportunistically acquire the lock and then recheck the bh
 	 * didn't move under us.
 	 */
-	while (bh->b_assoc_map) {
+	while (bh->b_mmb) {
 		rcu_read_lock();
-		mapping = READ_ONCE(bh->b_assoc_map);
-		if (mapping) {
-			mmb = &mapping->i_metadata_bhs;
+		mmb = READ_ONCE(bh->b_mmb);
+		if (mmb) {
 			spin_lock(&mmb->lock);
-			if (bh->b_assoc_map == mapping)
+			if (bh->b_mmb == mmb)
 				__remove_assoc_queue(mmb, bh);
 			spin_unlock(&mmb->lock);
 		}
@@ -551,9 +549,9 @@ EXPORT_SYMBOL_GPL(inode_has_buffers);
  * Do this in two main stages: first we copy dirty buffers to a
  * temporary inode list, queueing the writes as we go. Then we clean
  * up, waiting for those writes to complete. mark_buffer_dirty_inode()
- * doesn't touch b_assoc_buffers list if b_assoc_map is not NULL so we
- * are sure the buffer stays on our list until IO completes (at which point
- * it can be reaped).
+ * doesn't touch b_assoc_buffers list if b_mmb is not NULL so we are sure the
+ * buffer stays on our list until IO completes (at which point it can be
+ * reaped).
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
@@ -571,14 +569,14 @@ int sync_mapping_buffers(struct address_space *mapping)
 	spin_lock(&mmb->lock);
 	while (!list_empty(&mmb->list)) {
 		bh = BH_ENTRY(mmb->list.next);
-		WARN_ON_ONCE(bh->b_assoc_map != mapping);
+		WARN_ON_ONCE(bh->b_mmb != mmb);
 		__remove_assoc_queue(mmb, bh);
 		/* Avoid race with mark_buffer_dirty_inode() which does
 		 * a lockless check and we rely on seeing the dirty bit */
 		smp_mb();
 		if (buffer_dirty(bh) || buffer_locked(bh)) {
 			list_add(&bh->b_assoc_buffers, &tmp);
-			bh->b_assoc_map = mapping;
+			bh->b_mmb = mmb;
 			if (buffer_dirty(bh)) {
 				get_bh(bh);
 				spin_unlock(&mmb->lock);
@@ -616,7 +614,7 @@ int sync_mapping_buffers(struct address_space *mapping)
 		smp_mb();
 		if (buffer_dirty(bh)) {
 			list_add(&bh->b_assoc_buffers, &mmb->list);
-			bh->b_assoc_map = mapping;
+			bh->b_mmb = mmb;
 		}
 		spin_unlock(&mmb->lock);
 		wait_on_buffer(bh);
@@ -724,11 +722,11 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 	struct address_space *mapping = inode->i_mapping;
 
 	mark_buffer_dirty(bh);
-	if (!bh->b_assoc_map) {
+	if (!bh->b_mmb) {
 		spin_lock(&mapping->i_metadata_bhs.lock);
 		list_move_tail(&bh->b_assoc_buffers,
 				&mapping->i_metadata_bhs.list);
-		bh->b_assoc_map = mapping;
+		bh->b_mmb = &mapping->i_metadata_bhs;
 		spin_unlock(&mapping->i_metadata_bhs.lock);
 	}
 }
@@ -1124,8 +1122,8 @@ void mark_buffer_write_io_error(struct buffer_head *bh)
 	/* FIXME: do we need to set this in both places? */
 	if (bh->b_folio && bh->b_folio->mapping)
 		mapping_set_error(bh->b_folio->mapping, -EIO);
-	if (bh->b_assoc_map)
-		mapping_set_error(bh->b_assoc_map, -EIO);
+	if (bh->b_mmb)
+		mapping_set_error(bh->b_mmb->mapping, -EIO);
 }
 EXPORT_SYMBOL(mark_buffer_write_io_error);
 
diff --git a/fs/inode.c b/fs/inode.c
index 393f586d050a..3874b933abdb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -276,6 +276,7 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
+	mapping->i_metadata_bhs.mapping = mapping;
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 631bf971efc0..20636599d858 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -73,8 +73,8 @@ struct buffer_head {
 	bh_end_io_t *b_end_io;		/* I/O completion */
  	void *b_private;		/* reserved for b_end_io */
 	struct list_head b_assoc_buffers; /* associated with another mapping */
-	struct address_space *b_assoc_map;	/* mapping this buffer is
-						   associated with */
+	struct mapping_metadata_bhs *b_mmb; /* head of the list of metadata bhs
+					     * this buffer is associated with */
 	atomic_t b_count;		/* users using this buffer_head */
 	spinlock_t b_uptodate_lock;	/* Used by the first bh in a page, to
 					 * serialise IO completion of other
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 76360b0040e0..fa2a812bd718 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -447,6 +447,7 @@ extern const struct address_space_operations empty_aops;
 
 /* Structure for tracking metadata buffer heads associated with the mapping */
 struct mapping_metadata_bhs {
+	struct address_space *mapping;	/* Mapping bhs are associated with */
 	spinlock_t lock;	/* Lock protecting bh list */
 	struct list_head list;	/* The list of bhs (b_assoc_buffers) */
 };
-- 
2.51.0


