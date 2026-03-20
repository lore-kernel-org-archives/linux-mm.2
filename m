Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 257D41098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F846B00F4; Fri, 20 Mar 2026 09:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8FE6B00F2; Fri, 20 Mar 2026 09:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48326B00F3; Fri, 20 Mar 2026 09:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 832EB6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55B171C96A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:30 +0000 (UTC)
X-FDA: 84566558580.30.EE9C888
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 00A1D1A0015
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m8G9ent1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Do5n+BIc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m8G9ent1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Do5n+BIc;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ih/LSfzfUTul03zRfWemc9NlyPTmO34RzLYWY0S+QYM=;
	b=HVRb4rTzfOK1gegKGa1YOz97tGb2VfQPl17AiSpZOQFeBoOofYTWC7AcAZpsMcUsg7iRfu
	e9ypt/UTh4wrc7XdMTvHd8INXF1Fi6ArDg8b6JXfnN2DPhPE2FX/6W7btLh8X2mC0N73zI
	bEv/JqT0n2cVgVmAxCHaUVOE522T+oA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014208; a=rsa-sha256;
	cv=none;
	b=f0h4FiBA1RshH0cz6Bd2QMca7b4m4DRp9TvchTJjXnrHxdsH0g68VAM97DpMWf6BRwQaNU
	VKMiDDcSgyv1if4u2sHSOZbQjMG57Gh8MVI82Ztpl8+9c4CCMlqYaSKdzvzqF2VO89rIqp
	uIcPI83FO2GkcpVUK98/8/srt5RivBA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m8G9ent1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Do5n+BIc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m8G9ent1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Do5n+BIc;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B68B04D428;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih/LSfzfUTul03zRfWemc9NlyPTmO34RzLYWY0S+QYM=;
	b=m8G9ent18Hr51S1MO1GBbVci/SYlK4Kp8G1jWCTdhZ8frR9mmzB2sL2eIlN/GTCgNvujKx
	HModd3zoGtxodt/x5nsb0Yirzk5I4ze9y3T6Q2ey/Qz2H95v0PrE8HG2UDOAZDSA4WPC2C
	m6SVRclEgNeM7qyxf2U0NMpTusdZSXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih/LSfzfUTul03zRfWemc9NlyPTmO34RzLYWY0S+QYM=;
	b=Do5n+BIcfQAoPpkKy3HZRs2YApSdH88Wfu4p+tkWC9Iikehe16RlRty+TsOfez5Pl3bM5R
	RAXC/iMOfHISsNDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih/LSfzfUTul03zRfWemc9NlyPTmO34RzLYWY0S+QYM=;
	b=m8G9ent18Hr51S1MO1GBbVci/SYlK4Kp8G1jWCTdhZ8frR9mmzB2sL2eIlN/GTCgNvujKx
	HModd3zoGtxodt/x5nsb0Yirzk5I4ze9y3T6Q2ey/Qz2H95v0PrE8HG2UDOAZDSA4WPC2C
	m6SVRclEgNeM7qyxf2U0NMpTusdZSXM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih/LSfzfUTul03zRfWemc9NlyPTmO34RzLYWY0S+QYM=;
	b=Do5n+BIcfQAoPpkKy3HZRs2YApSdH88Wfu4p+tkWC9Iikehe16RlRty+TsOfez5Pl3bM5R
	RAXC/iMOfHISsNDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9EA5E4281F;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fCC6JplOvWmNCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6A2DAA0B3C; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 32/41] ext2: Track metadata bhs in fs-private inode part
Date: Fri, 20 Mar 2026 14:41:27 +0100
Message-ID: <20260320134100.20731-73-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4156; i=jack@suse.cz; h=from:subject; bh=aRvj4AtIW+ddyd7UxwbPw41jZ9lNjYBY0OWJr0OT+ZQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6H7CaeB32tQjJNhqeawy4/l/6sm7mJJ+IL7 /s5ToIoGN+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OhwAKCRCcnaoHP2RA 2QHZB/9+wZG/S4W1bL987nyIE4g21LzXGKf9ozYzcj8lrO9KHnal5LDi+7tfr41ET2QNORSkw59 VEih7xn49DZ6lmBCFxEVSI2NVIIay/Ua741x+g7dpohVclYnboKtLzwA/VA7f+uzLLabH/7kR0y ITGOB3aUTQtUGVad7mt6AtAnP8CjTx5DtJW3AHiLEneIBPz5JP0G9AwqJYJA5UgxdQ+fgqfnnsY gSMpr7IJ0BNofn+Yo8l4CsG90EJ+Qh3FLEFaG1IulNx5CfxHqKopZOgJ70HZ99wKMs6PtYQ+Tzn ZjfFJFrg0CDLrvhw3ZZs/Gm33X8VLAf9aZOn/OspsJ5fv1e0
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aj15uhhop63z15bdqp4esfuorqsna88i
X-Rspam-User: 
X-Rspamd-Queue-Id: 00A1D1A0015
X-Rspamd-Server: rspam12
X-HE-Tag: 1774014207-830561
X-HE-Meta: U2FsdGVkX19lmEOFcSxdRRf4VXWW05sTnzirZBsNUy+9x7jh6d0kf2ftc7lcXK/5Rq4vENuoS0NWoUsmbND2X0eKfBFNfrAAv7zpzahG+sP+Af5MOHUvVqERmD9blDSzEhZ5kCl0aXhmDH8E7yg0bz3nH3pEXwu4ex6HE9eA3BNvWRAth01oAbYiAP71c4BWXSCETPWB7FlXfD4q5fFW+G//Y8gAAaH9Ep7R1FLEP3LuOaBojaoWPVZnhCE3XpCQA+vkne/DC2s9DhJ9QVcMH6B8w2l4t1fNWGL4qLrWpvb5ah04vXnWVSRe5lENY1OOY/ca7G1T6NFWzr0bmwoLvl7GVjHt5zfPJriaTFVLaLDos3aBnTnFHiiffuNewm4wcVxUiRLc/yljQGoDLulFIcrR2gsjPiMpZIoXU4+zTsTT7fHe25s15WnmYAD1zcriBYp3/AbmYscHJhGyyJWJHH2yWIbeGs2dK1YC1SWZLD4YnXduE11y2YvMzwoltjcks9K44xZ5ut2aAmI3na9SCe5Y7wQiXSbqlTHTuEbfwNxBs/OJUMYk2YVz9nB+uwLC29nRYTvRFO/44GaZcZQnP7OFvO4mDPGtT3/aQhqNIpINwA3ljtDKibjBwqb0WyqQV30ziGoXm+14wMJG6kgL3+QyjyQKJLBAPO9Cs0KdNDP8AY3K6+TaYZkAcpmhp2ypA7P32XiCXZYpxcv0APu0/9HRd8WZP7tx7kl++GTLR6yD/9xk3m2Y4S1IL91sthwRlZ67jqx713HXrJwtB98kj4e0CPSUITckhsqqXOBoED7hmZIumJ+C5rivcH5r7Uj47L2EznjZBNb2vqacbfJixPNwOFVDb8CKd6NDM5ZyaW7QmvOncGqJG/nK56v4iI5eLXC0ZVQUYJQqTtNPHSsZko36/d5VS650PAGfjjd/77+ZNhpJsu9EPIZF13kzxAufhsVwLjBWBNcPPhQYpph
 ofnAumJ3
 TXzsj5yijYtTF77vykRPQnvEhL1ndidZWvyZIQH8XdYa58A9E3skFe2F2fofgJzbQcvQSouzltbeem7BjV6sDZOGTWfrMH0uVZoyiLPgB7BiYiPOiPkmfD5dQyCbho/Nl3Jix9qR2FzhvyzIjmfYWN5SbLmD7EwtQkSNWDQKFm6H6ADCxc6rwyF+CvuOklyskjNQP34X6rP5gtmMRk10MnvXVnbLxkLnZqExwJZ/Mq1BnN+91XryZZj6KiuVpvGUejN/ZLELob/BzaPcuTcNYxn7jDZBJNa0pkxCTheI8o1Cz/JHmaiDaSWTqeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ext2.h  |  1 +
 fs/ext2/file.c  |  6 ++++--
 fs/ext2/inode.c | 16 +++++++++-------
 fs/ext2/super.c |  1 +
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 5e0c6c5fcb6c..3eb1f342645c 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -676,6 +676,7 @@ struct ext2_inode_info {
 #ifdef CONFIG_QUOTA
 	struct dquot __rcu *i_dquot[MAXQUOTAS];
 #endif
+	struct mapping_metadata_bhs i_metadata_bhs;
 };
 
 /*
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index ebe356a38b18..629133f0e8ae 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -156,9 +156,11 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 int ext2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	int ret;
-	struct super_block *sb = file->f_mapping->host->i_sb;
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
 
-	ret = generic_buffers_fsync(file, start, end, datasync);
+	ret = generic_mmb_fsync(file, &EXT2_I(inode)->i_metadata_bhs,
+				start, end, datasync);
 	if (ret == -EIO)
 		/* We don't really know where the IO error happened... */
 		ext2_error(sb, __func__,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index fb91c61aa6d6..dfed87fbbccd 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -95,9 +95,9 @@ void ext2_evict_inode(struct inode * inode)
 			ext2_truncate_blocks(inode, 0);
 		ext2_xattr_delete_inode(inode);
 	} else {
-		sync_mapping_buffers(&inode->i_data);
+		mmb_sync_buffers(&EXT2_I(inode)->i_metadata_bhs);
 	}
-	invalidate_inode_buffers(inode);
+	mmb_invalidate_buffers(&EXT2_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 
 	ext2_discard_reservation(inode);
@@ -527,7 +527,7 @@ static int ext2_alloc_branch(struct inode *inode,
 		}
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &EXT2_I(inode)->i_metadata_bhs);
 		/* We used to sync bh here if IS_SYNC(inode).
 		 * But we now rely upon generic_write_sync()
 		 * and b_inode_buffers.  But not for directories.
@@ -598,7 +598,7 @@ static void ext2_splice_branch(struct inode *inode,
 
 	/* had we spliced it onto indirect block? */
 	if (where->bh)
-		mark_buffer_dirty_inode(where->bh, inode);
+		mmb_mark_buffer_dirty(where->bh, &EXT2_I(inode)->i_metadata_bhs);
 
 	inode_set_ctime_current(inode);
 	mark_inode_dirty(inode);
@@ -1211,7 +1211,8 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 		if (partial == chain)
 			mark_inode_dirty(inode);
 		else
-			mark_buffer_dirty_inode(partial->bh, inode);
+			mmb_mark_buffer_dirty(partial->bh,
+					      &EXT2_I(inode)->i_metadata_bhs);
 		ext2_free_branches(inode, &nr, &nr+1, (chain+n-1) - partial);
 	}
 	/* Clear the ends of indirect blocks on the shared branch */
@@ -1220,7 +1221,8 @@ static void __ext2_truncate_blocks(struct inode *inode, loff_t offset)
 				   partial->p + 1,
 				   (__le32*)partial->bh->b_data+addr_per_block,
 				   (chain+n-1) - partial);
-		mark_buffer_dirty_inode(partial->bh, inode);
+		mmb_mark_buffer_dirty(partial->bh,
+				      &EXT2_I(inode)->i_metadata_bhs);
 		brelse (partial->bh);
 		partial--;
 	}
@@ -1303,7 +1305,7 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	if (inode_needs_sync(inode)) {
-		sync_mapping_buffers(inode->i_mapping);
+		mmb_sync_buffers(&EXT2_I(inode)->i_metadata_bhs);
 		sync_inode_metadata(inode, 1);
 	} else {
 		mark_inode_dirty(inode);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 603f2641fe10..4118a3a1f620 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -215,6 +215,7 @@ static struct inode *ext2_alloc_inode(struct super_block *sb)
 #ifdef CONFIG_QUOTA
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
 
 	return &ei->vfs_inode;
 }
-- 
2.51.0


