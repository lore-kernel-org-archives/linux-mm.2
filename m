Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 712F8106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C416B0114; Thu, 26 Mar 2026 05:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1AE76B0112; Thu, 26 Mar 2026 05:56:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70166B0115; Thu, 26 Mar 2026 05:56:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A456B6B0111
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73A498CE25
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:45 +0000 (UTC)
X-FDA: 84587759970.18.3BB1326
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2F14640002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yjkZaXGO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XKCdYjPu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yjkZaXGO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XKCdYjPu;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774519003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cm90rdUlWxy4QnRmbQ6DrHQpjRNXGV5jhYymyeB6abI=;
	b=z0NJux3a8WZWGYpobErGprRMvEpNvAtm6weiF08CvF2oo7jbrYBjjWPQ1E2A1EsiDcO+aM
	w8AMv8gB1SNmJwWcA17p05/Z3PHCCepIoZdCcfw2FL/higK0ee1iFExkj9VENx52YkO/yx
	vIMmkpNU5GhNhP6hMJ+0ljkgpLTr7kU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yjkZaXGO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XKCdYjPu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yjkZaXGO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XKCdYjPu;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774519003; a=rsa-sha256;
	cv=none;
	b=gmDmx4Xwt+txugxDNbedRLvnGVnncsiY/xgezMCcs887coaIaekA5zzHoEGWpw45a2Db2/
	GZbpJTF8LQRVcv8dQAeN48ukFpkXokfbtdKR3IEToqPlSyI6uxqdgBRlW/OU7QfeR87Tfy
	UDa69HEgOFjSWVOIMIeD43ZmaBuAxwI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A79DB4D2AD;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm90rdUlWxy4QnRmbQ6DrHQpjRNXGV5jhYymyeB6abI=;
	b=yjkZaXGOf8YRShUXbyxUW7cbiFEoOK+76pi6ZrmpY0lnRn0QZQ/hgyHjpUcw1l7jrD2GqS
	5qzct4bTvOfzLIydO+6bE0bx75qEmS8ylgIa0LgtP3M+o6/0MPgSWUpr1vgrHuf/BS6E+M
	0xsKWDxYtCdZ1uISd/mhg1QBVEIwgK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm90rdUlWxy4QnRmbQ6DrHQpjRNXGV5jhYymyeB6abI=;
	b=XKCdYjPu1A+14grGsWLA549acStjCWsj38dAoJd3igr7p1zts8guCf6yPs21oSj4UnmPNV
	2GY07oSk2Yx0nvBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm90rdUlWxy4QnRmbQ6DrHQpjRNXGV5jhYymyeB6abI=;
	b=yjkZaXGOf8YRShUXbyxUW7cbiFEoOK+76pi6ZrmpY0lnRn0QZQ/hgyHjpUcw1l7jrD2GqS
	5qzct4bTvOfzLIydO+6bE0bx75qEmS8ylgIa0LgtP3M+o6/0MPgSWUpr1vgrHuf/BS6E+M
	0xsKWDxYtCdZ1uISd/mhg1QBVEIwgK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cm90rdUlWxy4QnRmbQ6DrHQpjRNXGV5jhYymyeB6abI=;
	b=XKCdYjPu1A+14grGsWLA549acStjCWsj38dAoJd3igr7p1zts8guCf6yPs21oSj4UnmPNV
	2GY07oSk2Yx0nvBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D2B14A0A8;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zwBeJnUCxWkBYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E0CECA0C80; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 40/42] ext4: Track metadata bhs in fs-private inode part
Date: Thu, 26 Mar 2026 10:54:34 +0100
Message-ID: <20260326095354.16340-82-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3926; i=jack@suse.cz; h=from:subject; bh=9xBH/IqErKiIiNqWXJjy809lW/6/4LgxYE6Bk76CpFo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJUDID/ZAUL5XAy2UizNNky/Yki15nrbCzj2 38rMkVQuT6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCVAAKCRCcnaoHP2RA 2Q2WB/9Y928g9eFz58LRsc7RHaB+gGxibmuIx9F4zAB0qmKEX9gGTCMxnwDKNE/J7SLaANuTjQ+ wvjW0OF0ds2gDehs56OIrYWGMpaBdqvzevym1o7KzaxxETjrgxj30OVGsWktpoyVFa0LBkvi84q n0cJ7AOIx0+nhwv9zXYIdX4mzhNjaym5qZXiK6zx4+mHr0O5Zimy0L4O2BdnnXCRcVZZAMhDHc8 xnlbnSIgtS7bC1QYftSWEnHPj/futMxcn/hV0gk4ovjAi/4bUHeTn+xXzbAJk2k9GA4jJ+skwcN MZdLjqeBm6eOr8AIIdhljKhyPfNmFfyqCVnQxyj0YDx77YIF
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: sb7ctz1drab8iy58hwsaz41qucj5z7cg
X-Rspamd-Queue-Id: 2F14640002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774519002-138003
X-HE-Meta: U2FsdGVkX1/MbQeZtRiQviv+Gxy7IQd2XZCnOg7D/kc4oLfssloec7a+NLkQj+hHr/Cl9155WU3NV1LmeA16wrBFUNOAKF0/iTsAv6S0vb0YZ/TfpST6wfX0fZpAO3IGqw4jT+KH2iJ3JNk74o/d5KpA0NAoE242yurbRoj0/2Ry9t1s0uBXTIEQDB4XIlwB9Cy4+iUzYhbb96I25P3GPBFvRLFKIJcxbD8nJHMYrCQzlHaQis1B+ZeawyTihGtUXBJdqNhl3m7eMMLQJUuYu2Att8SZN1iyWJ3ujnsQ8a+JS180jyWpzvdsyrT1xJ3gwCbDeG85n/0mdPjLBnPCMX2DFHUIjafUNBqEHYYs53lK2AsL3ccWjvAUqVVJ+2m6H6+YAxDVejDK5Q/ImYAO+jDglMN73VyxAoIH3x2JrUMfqnSoB4Jh4mBgzhJR3XVIYpn3Zma0uQtZI9m/5epxRiZ6WHzaJnON1x0PUHHfIsEEfC8rTs61+Wkw6yBCDHh0LzR6IJPabOYD6buxw0vN19ACedSGMlln0+NOxapzQl6/BqhfkgxF2zQSlXcXwpwVsyGyjr/aApkmlDpFugw6bXIz+A6drvmMQ3dPWidkQCC4c09vOMXsx4TgNSdKB8Yg4rN9JNn6HlRGTDG2H3IqiSt9UBWBbGHfdZ8LrJHGFRvKGCqpPfYgU/NHSWFae5c+gLW/oTuRBbY9c8MUEvPLk2vXxmspkhvkrL3fLYoloLV+fAnUvn0bUTfxbLl6jA/wNwwe47Rc3XLFwsXYe5M0IQZ29MTcWlvyrW5GhR0bAxa2bETGG0L/3RP0FfWXg2sBDMTTksZicTLHdpOswThJtJgP7jjkdI1kU4IjoZ7lHYGgsXk1UKT16WZ+HqvQ1q1LgOPlF7qvOYea+42LM9wOEvetEtTfhA8cYxXn1Cu5aU6MAp9bwFdMYTCg5NNV3Y14R3xPcwN8dQiWvU/E8gk
 QXZX6fJm
 BLvJmQq/t4b7MJld1KNi4uQ1aX5RhTsRXn4gRGsRonzbDle8tTQ2WyOPTnZC+0WX77UAXTAk2Ns21GjK3bQGnKBZX5OayL23X2M8b3//LtZHbgsPROmGQNPR1uhbYEJpjH4E/dRHUpP6XdHNqJdZNfYs6AsrZK3818UxwuxXrwc76BNYQGABCx9xm2V83vxqqKSJBNnchIML4TzOX8jh2qqTZEWYpLq43o+KznhIsv+Fsd1q7ZH8WRryLYsDyAvDYdheIVPcAUmweB1OeIfK4Xmnc5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode. We need
the tracking only for nojournal mode so this is somewhat wasteful. We
can relatively easily make the mapping_metadata_bhs struct dynamically
allocated similarly to how we treat jbd2_inode but let's leave that for
ext4 specific series once the dust settles a bit.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h      | 1 +
 fs/ext4/ext4_jbd2.c | 3 ++-
 fs/ext4/fsync.c     | 5 +++--
 fs/ext4/inode.c     | 4 ++--
 fs/ext4/super.c     | 3 ++-
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 293f698b7042..8df3617fd0e7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1121,6 +1121,7 @@ struct ext4_inode_info {
 	struct rw_semaphore i_data_sem;
 	struct inode vfs_inode;
 	struct jbd2_inode *jinode;
+	struct mapping_metadata_bhs i_metadata_bhs;
 
 	/*
 	 * File creation time. Its function is same as that of
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 05e5946ed9b3..9a8c225f2753 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -390,7 +390,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 		}
 	} else {
 		if (inode)
-			mark_buffer_dirty_inode(bh, inode);
+			mmb_mark_buffer_dirty(bh,
+					      &EXT4_I(inode)->i_metadata_bhs);
 		else
 			mark_buffer_dirty(bh);
 		if (inode && inode_needs_sync(inode)) {
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index e476c6de3074..aa80af2b4eea 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -68,7 +68,7 @@ static int ext4_sync_parent(struct inode *inode)
 		 * through ext4_evict_inode()) and so we are safe to flush
 		 * metadata blocks and the inode.
 		 */
-		ret = sync_mapping_buffers(inode->i_mapping);
+		ret = mmb_sync(&EXT4_I(inode)->i_metadata_bhs);
 		if (ret)
 			break;
 		ret = sync_inode_metadata(inode, 1);
@@ -85,7 +85,8 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 	struct inode *inode = file->f_inode;
 	int ret;
 
-	ret = generic_buffers_fsync_noflush(file, start, end, datasync);
+	ret = mmb_fsync_noflush(file, &EXT4_I(inode)->i_metadata_bhs,
+				start, end, datasync);
 	if (!ret)
 		ret = ext4_sync_parent(inode);
 	if (test_opt(inode->i_sb, BARRIER))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 011cb2eb16a2..c9fd1d17b492 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -187,7 +187,7 @@ void ext4_evict_inode(struct inode *inode)
 		truncate_inode_pages_final(&inode->i_data);
 		/* Avoid mballoc special inode which has no proper iops */
 		if (!EXT4_SB(inode->i_sb)->s_journal)
-			sync_mapping_buffers(&inode->i_data);
+			mmb_sync(&EXT4_I(inode)->i_metadata_bhs);
 		goto no_delete;
 	}
 
@@ -3436,7 +3436,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (mmb_has_buffers(&inode->i_mapping->i_metadata_bhs))
+	if (mmb_has_buffers(&EXT4_I(inode)->i_metadata_bhs))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea827b0ecc8d..31f787a65fac 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1428,6 +1428,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
 	return &ei->vfs_inode;
 }
 
@@ -1525,7 +1526,7 @@ void ext4_clear_inode(struct inode *inode)
 {
 	ext4_fc_del(inode);
 	if (!EXT4_SB(inode->i_sb)->s_journal)
-		invalidate_inode_buffers(inode);
+		mmb_invalidate(&EXT4_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-- 
2.51.0


