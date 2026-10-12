Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FAD7CA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A006B009F; Mon, 12 Oct 2026 04:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FBB6B00A2; Mon, 12 Oct 2026 04:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598E16B00A4; Mon, 12 Oct 2026 04:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0466B00A1
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:24:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94703A09D5
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:18 +0000 (UTC)
X-FDA: 85313286996.20.938DEFD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 74741180006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3hwr8EE48ck2V2cc3KZ8D8FmUzHH272sOcK2JSqmSSQ=;
	b=VUSvaaitZ+uI4I5i87jGFRr9KX+eu1+0vDpoGUjL5VabiyOvgmbXRMykau17ZkGXvdjUhx
	SfjlJZHwKx5nQqOmUSu6EkDi3bqaBz4Kgf/XgkTOryUQ8Ud5iFQOFi6LDhY2QOwGgyn5PI
	kWNcvB0xXui78n7F3iuDVTBa4dbOOMQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793456;
	b=5T91Gxo4kp5HF+LRmbCihw9jEjRg5ZKUSkA6oNqH/b2/IKPVDMClojuvoVJ77rYku1g02m
	UCjpAQdRArJKfBv0sQQdzMVnHYsMLxdnDOJyFBB6hLM3OHk65MCs3o0koRkTzCRul5o14G
	v/U1K7xusRLKbBx0zGZ2MpGUY4ubEfA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5E45921E5D;
	Mon, 12 Oct 2026 08:24:15 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DA6C139AF;
	Mon, 12 Oct 2026 08:24:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +OlEBy+ZzGorHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 08:24:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 962DCA1409; Mon, 12 Oct 2026 10:24:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 2/7] fs: Avoid inode dirtying on last iput
Date: Mon, 12 Oct 2026 10:23:40 +0200
Message-ID: <20261012082356.3121725-9-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261009133253.20102-1-jack@suse.cz>
References: <20261009133253.20102-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4455; i=jack@suse.cz; h=from:subject; bh=mN6+LZ2gdI6BA2Woogl/LRUCfZMYtRtQjXIydTfQo94=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqzJkdCCO3AAJS09xXaYP2rhj+O/DJgaVQfhdCw AQfOsLy4jSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCasyZHQAKCRCcnaoHP2RA 2UxvB/4rbDCNaOhesIyBlx/dXNJe9UYncnqOAkOL2GgkWRvHgOIEauu0EOa35PV5sAomz5vheR4 jNMvFPGBPYsr4sU2jwSJZsvK5Pz9tR0M31+3umwn8jh3fw8I3VwccLj8rsHQjOwkeFs9tqfDqqx xsCC7ZjdRzT9FMYDevNwZL7A7QTUOZq4vr3Nn3UYo/nK6H9T53kw2kHtI43Z8vbOD38Ar5nqGDS AXCYZVW68IuGdBgOjZ11qNrThbWQeHguzxTTMhtLKfIoTAD65WiASCIbG7sMVmJ8TBjvvJFSXfQ zEKmmZ0PatEgDFmHl7qUlnlCKnZ2s4qa3Wsv06VbbxY5bW/Q
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 74741180006
X-Rspam-User: 
X-Stat-Signature: d4ti79kyfco96n35ycgt79gn9eo7jeur
X-HE-Tag: 1791793456-522114
X-HE-Meta: U2FsdGVkX1/JPRCNlZ+52NQrvu0d+tVNa0qz3Q/PydNJglhs78AT8Q5H4RjYtT9BXTQchvfSrkZhakPmhxFzpy8bIOc8RRnEvl2mV/xbZarj8XRDcgz2jb3b/jkgkxPkHqMw/DW+MyQF+sJVex802+cOnbwGNpe3+kRHeWdJ6ONGKAeu2xs0yQWpTlsUkF4578kRUDxnwobOZsFbTVah/8bkm4oVkNke94rh7Y+/nL+/kJM4VDw3B0JehG9GAMFUSyhJ4mil9Wp8Qu2I8dZ12UBzJx67XtJHDKEBWeEaGyqA1Jmkf8/9UGcjKdddyBQLGls2Xjv63thf6i310mwzF9shWHMmSdPvURsJDF5m6laKbiMy6jgVuE5exmCUYG+jzFOGcKC9RqXfkAvUNkxOxuj1DJ+rQUDO0e00F5QELT5XHJZKirocBZbVYcs0nI80NPIjE7g0HpoBaSeNVBvW9W2OTgLVOTbDo/ORliXPh+bJqpytAA/fJkdLx89nRdE82mvcssPcKQGszfqVgybo09xkj/SLBORH1VL3TOrt5W1JxbQ7+EEA9CLf97S34qKPXZvUC1W3EbvDldyK2QvoXv9L2wmEtsAG5FTKwMQXt6dfw1+8i4ckXjjWwkJuYk2nDthZhqRf0r6XT6W7SqQXIghorAGs20DjoR3NqJJyjEv9sdr9G+T8aBujCfMTQaNgcUVbVmJ4Lgvb3Kfw5e7gEcaUH0OOQNDtwQhQEvtC6aD+7YYIBh3vfRHU1LlYUlj7zm3YMjBFRTB95371fHqdYiqIK2H9knxfs2WQ9T2cTQUUmcP0eJHjTjrfC8faOQ0jL8fJp8mUighmT+shFpOvEu1AzhXOE07SDuNsgFZXGZeoMVgGXSL0v0q5HLI+mpkdg41wP47WsWD7nNjsEQWuhduWrTI+baBstOo/OCoCsO38LKKq4k8esQKdjJjdh9z5jRuiLvRroqf5P+xfguK
 2vaXc39z
 Pm7MaVYN2kYxDpZ3lSZVyiD0wvz4EBNFP9ZvPkbn8HpMpyxXHsWu8aDBuwmhMa+ItiWsqP0qS3Xn8TWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When inode has dirtied timestamps, we currently call sync_lazytime() on
last iput. This is done because inode with any dirty bit set is not
inserted into LRU and dirty timestamps expire only after many (12 by
default) hours so these inodes would be sitting outside of LRU aging for
a really long time. However this can result in doing IO and consequently
GFP_NOFAIL allocations from dentry reclaim making MM complain. Sample
trace for ext4 is:

prune_dcache_sb
shrink_dentry_list
__dentry_kill
iput
sync_lazytime
__mark_inode_dirty
ext4_dirty_inode
__ext4_mark_inode_dirty
ext4_reserve_inode_write
ext4_get_inode_loc
bdev_getblk
__filemap_get_folio_mpol

Avoid this dirtying on last iput by reshuffling unused inodes to the
beginning of b_dirty_time list and clobbering dirtied_time_when instead
so that they get written during next periodic writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/inode.c        | 15 +++++++--------
 fs/internal.h     |  1 +
 3 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f6fe797a41b4..68c65a74a330 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2852,6 +2852,50 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
+/*
+ * If inode has dirty timestamps to write out, make sure flush worker writes
+ * them out during its next periodic writeback writeout.
+ */
+void queue_dirtytime_writeback(struct inode *inode)
+{
+	struct bdi_writeback *wb;
+	unsigned long new_time;
+
+	lockdep_assert_held(&inode->i_lock);
+
+	wb = locked_inode_to_wb_and_lock_list(inode);
+	spin_lock(&inode->i_lock);
+	/*
+	 * If inode writeback is already queued or inode got dirty, we have
+	 * nothing to do and we mustn't touch writeback lists anyway.
+	 */
+	if (inode_state_read(inode) & (I_SYNC_QUEUED | I_DIRTY))
+		goto out_wb_lock;
+	/* Written back while we dropped i_lock? */
+	if (!(inode_state_read(inode) & I_DIRTY_TIME))
+		goto out_wb_lock;
+
+	/*
+	 * Move inode to the beginning of dirty queue and clobber dirtied time
+	 * so that it gets written out during the next periodic writeback.
+	 */
+	new_time = jiffies - dirtytime_expire_interval * HZ;
+	if (!list_empty(&wb->b_dirty_time)) {
+		struct inode *first = wb_inode(wb->b_dirty_time.prev);
+		unsigned long first_time = READ_ONCE(first->dirtied_time_when);
+
+		if (time_before(first_time, new_time))
+			new_time = first_time;
+	}
+	inode->dirtied_when = new_time;
+	inode->dirtied_time_when = new_time;
+	list_move_tail(&inode->i_io_list, &wb->b_dirty_time);
+	/* Wake up flush worker to ensure timely flush of the inode */
+	wb_wakeup_delayed(wb);
+out_wb_lock:
+	spin_unlock(&wb->list_lock);
+}
+
 /*
  * The @s_sync_lock is used to serialise concurrent sync operations
  * to avoid lock contention problems with concurrent wait_sb_inodes() calls.
diff --git a/fs/inode.c b/fs/inode.c
index a9d37be390a1..43f3b2cb1ebb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2029,7 +2029,6 @@ void iput(struct inode *inode)
 	if (unlikely(!inode))
 		return;
 
-retry:
 	lockdep_assert_not_held(&inode->i_lock);
 	VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR), inode);
 	/*
@@ -2042,14 +2041,14 @@ void iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
-	if (inode->i_nlink && sync_lazytime(inode))
-		goto retry;
-
 	spin_lock(&inode->i_lock);
-	if (unlikely((inode_state_read(inode) & I_DIRTY_TIME) && inode->i_nlink)) {
-		spin_unlock(&inode->i_lock);
-		goto retry;
-	}
+	/*
+	 * If inode has timestamp updates pending, queue flushing them now as
+	 * otherwise the dirtiness could be preventing the inode from entering
+	 * LRU for hours.
+	 */
+	if (inode->i_nlink && inode_state_read(inode) & I_DIRTY_TIME)
+		queue_dirtytime_writeback(inode);
 
 	if (!atomic_dec_and_test(&inode->i_count)) {
 		spin_unlock(&inode->i_lock);
diff --git a/fs/internal.h b/fs/internal.h
index c658c8a5ebd5..eae0e2bb5d1c 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -219,6 +219,7 @@ bool in_group_or_capable(struct mnt_idmap *idmap,
  */
 long get_nr_dirty_inodes(void);
 bool sync_lazytime(struct inode *inode);
+void queue_dirtytime_writeback(struct inode *inode);
 
 /*
  * dcache.c
-- 
2.51.0


