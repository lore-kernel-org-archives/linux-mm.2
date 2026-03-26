Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1E4106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81536B00E9; Thu, 26 Mar 2026 05:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D596B6B00EC; Thu, 26 Mar 2026 05:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10C76B00EA; Thu, 26 Mar 2026 05:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADE26B00E7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68790160C6D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:33 +0000 (UTC)
X-FDA: 84587759466.08.49D93FA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 42F77180009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1KFb45Lr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6xTkVKDh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1KFb45Lr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6xTkVKDh;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jAwTJiih2qv21x1zDcNiAZklPoPTM0eb+px5UJF6lw=;
	b=fl7A/4XyhxsYrwTRHIyxpmMVVDdazZQlrTM4X/XOgMIIYYD7r2b8aVyJwOo2LGsClHTZhC
	PJa521DA2kHKJYUvRZj2gPYuuCEUDym009H7092zJS67IUh8DzYcfLxYGLF2klS3pnB5xV
	CaiPFEwSrbYtxumxfU1NtxImAOaHBkc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1KFb45Lr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6xTkVKDh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1KFb45Lr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6xTkVKDh;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518991; a=rsa-sha256;
	cv=none;
	b=ngYwIYzqpwhDq0uaZ/Us9wMUFNEVnNTjeMJf1PImBUtJ8cGC1td+7MOV2qlYcJWwrrkW/3
	t18ZMqlseLdH8YP2+ekymFqWVNxmvmiOKn+pBNT+p8+os/IbutyI0L3KF8nj95GQPWgJhU
	svxWYEuEF+pGoNQ7CfG+0acnXTPXUK8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 983144D2A8;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jAwTJiih2qv21x1zDcNiAZklPoPTM0eb+px5UJF6lw=;
	b=1KFb45LrnT8VIPgsdivFPrty/BUxLgOlZo80pw3zDyw8z+OrkemNHV9xfBeXLg1clgznU4
	bO4IaDPM53POGTPM0lq8h2sEEo+UN+DkjINj48GpX8KR5Dz4Q1nVNBBZKbMgbbFXbkh/rK
	r9P3BU+qNd+IN4mfnLdbWLq/8cfa8OI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jAwTJiih2qv21x1zDcNiAZklPoPTM0eb+px5UJF6lw=;
	b=6xTkVKDhkLp/nrKzffvXSnrEWBZ3/Mu8iWnDAkMusNaL8hIA79mplmN/Q7do0mZcOM68Ep
	2arG/PBdXwSFj8BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jAwTJiih2qv21x1zDcNiAZklPoPTM0eb+px5UJF6lw=;
	b=1KFb45LrnT8VIPgsdivFPrty/BUxLgOlZo80pw3zDyw8z+OrkemNHV9xfBeXLg1clgznU4
	bO4IaDPM53POGTPM0lq8h2sEEo+UN+DkjINj48GpX8KR5Dz4Q1nVNBBZKbMgbbFXbkh/rK
	r9P3BU+qNd+IN4mfnLdbWLq/8cfa8OI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jAwTJiih2qv21x1zDcNiAZklPoPTM0eb+px5UJF6lw=;
	b=6xTkVKDhkLp/nrKzffvXSnrEWBZ3/Mu8iWnDAkMusNaL8hIA79mplmN/Q7do0mZcOM68Ep
	2arG/PBdXwSFj8BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BC4E4A0A9;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wa0eInUCxWn6YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B37DFA0C7A; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 35/42] affs: Track metadata bhs in fs-private inode part
Date: Thu, 26 Mar 2026 10:54:29 +0100
Message-ID: <20260326095354.16340-77-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10960; i=jack@suse.cz; h=from:subject; bh=bsmd8IOBMIFaPT0W+pgoe4ypivIyXU5noYASi9PAuxg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJQlWRcYLVKxJbqE33CN0oN/AVB/vHClHwPo 9t6RsiJXgeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCUAAKCRCcnaoHP2RA 2Vk4B/0TyH0Z5mLeLwjQ2zOsaG9TKLBjN6ujI1cPJkSKkDmtcJ115R8ReHxbaTsTk7AqSlwTRA7 ZZ3t1Q5nPOt6p+oEEhVOQGOkmuFNq7cHBoSswcJJ5D+BB+FY0oGxMEcdXzOihkK/lSu14SMVa4U YMgDZjVsT864+4SM5W6mD8S2YjU4o23ZAzNsS+QbMhZQbazSDYXlW6EYoUUlLRqtx0fW/ejb8u8 xYeEi7J0z+Sv1nguvWI9O4IWa9ZKWQOaCNiFhJwUty39WcNRAqJm3rH3KJK23nB3nfmGhb4+iSF BhON42bFO5TpaSheNcXZ/KXWs27jsWlKMOPdePUYQ1AaEfRU
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: t19b7ep9hq4jipzsp3htbr6c3ktwe7ws
X-Rspamd-Queue-Id: 42F77180009
X-Rspamd-Server: rspam09
X-HE-Tag: 1774518991-513523
X-HE-Meta: U2FsdGVkX1/UT2z4lgahsBfctkgvhrJ35iODVuM0os9MBZzcBxQsy+Tv2JMX/WOC61TrcwZaZBPsyPLaPbKeth2nABJlD34l8y6+lQKnZHtY6JVONcP4MdXnGBxigTiCA3K9u1nDsCTFy9BpOk3VgnORFTb5/jhbozZLk/u56byExUx2gT92bbOK05PzL9+6j738B9HE1UeXYUSoUcMq5232X6soaT50RgwKhpK/Vlu3q0rnBriGTSrlRonbmn1ykcNi03/Fvrpfgm0hMpGRJcx5ODIE2OeLrJXqXUzh+FTwNye3XHyC8bgirw7DL8H+mmelctSgKDMi9qAgUBAey7xbyvVwOpRTEkC+nHotZgW9n7p/yv4sKZJxSVrO74sWnSq5r4kGyRmy2IODBHWACXAUiVfJTYA4ULgr13/RzE4sXddbGIxQ1mdd3vuZgKV8UCfTEbD+5YvoJcfpoogrHj1f+ugBr67/gTrtakp2FZRDA1t45ROZ+zGxK7iDxE4qsV2AYIOjjf+wpGvk4Y/uYeIbWrKxbQ9+4f0rouTJPqEowd+POVk6+wNlW0TcLZyyCs42Bl39AyWgw+SA3/f+gQF6mnvoK74X0lXr603yrA+p+SsRE1k6VPZhyl61cvVjTfinRrqGJeCse/mK2EB932uU130npmE7NcINfrj7Ufnt0jllL5p+6J/0NXKeJAFuvdCX/2iherEakXpK1SDc3EKQ03++fs6VokEbfCwAlNeTkH+34WsAaxKSwegHFMCyBsKfZqRGun+i2THjj2ViraVdhWkcEawS8PGyiz6VrsCkB/nihhCPDEVDpVU5MBMxMhVVlP1FkMN7LXlvdjtVZJKSEouVnkUasJ5RhgIsJZSFbKUHg3vfiCDO0jBOqfYfQ1RU+ChEoYFu8e0W0HEZdEvrEhuMhJG1llU20GvJebfm6ZEAWBZgHaxj5bO7nxgxg1J/zs8MUXh0esl2lyZ
 TgWzIpIz
 u2O7RHwaoc0tcHr7ohCg+n70lB7PJPz+B9kkZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/affs/affs.h     |  2 ++
 fs/affs/amigaffs.c | 12 ++++++------
 fs/affs/file.c     | 25 ++++++++++++++-----------
 fs/affs/inode.c    | 14 +++++++-------
 fs/affs/namei.c    |  9 +++++----
 fs/affs/super.c    |  1 +
 6 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index ac4e9a02910b..a1eb400e1018 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -44,6 +44,7 @@ struct affs_inode_info {
 	struct mutex i_link_lock;		/* Protects internal inode access. */
 	struct mutex i_ext_lock;		/* Protects internal inode access. */
 #define i_hash_lock i_ext_lock
+	struct mapping_metadata_bhs i_metadata_bhs;
 	u32	 i_blkcnt;			/* block count */
 	u32	 i_extcnt;			/* extended block count */
 	u32	*i_lc;				/* linear cache of extended blocks */
@@ -151,6 +152,7 @@ extern bool	affs_nofilenametruncate(const struct dentry *dentry);
 extern int	affs_check_name(const unsigned char *name, int len,
 				bool notruncate);
 extern int	affs_copy_name(unsigned char *bstr, struct dentry *dentry);
+struct mapping_metadata_bhs *affs_get_metadata_bhs(struct inode *inode);
 
 /* bitmap. c */
 
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index fd669daa4e7b..13a914c1d8b7 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -57,7 +57,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 		AFFS_TAIL(sb, dir_bh)->hash_chain = cpu_to_be32(ino);
 
 	affs_adjust_checksum(dir_bh, ino);
-	mark_buffer_dirty_inode(dir_bh, dir);
+	mmb_mark_buffer_dirty(dir_bh, &AFFS_I(dir)->i_metadata_bhs);
 	affs_brelse(dir_bh);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
@@ -100,7 +100,7 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 			else
 				AFFS_TAIL(sb, bh)->hash_chain = ino;
 			affs_adjust_checksum(bh, be32_to_cpu(ino) - hash_ino);
-			mark_buffer_dirty_inode(bh, dir);
+			mmb_mark_buffer_dirty(bh, &AFFS_I(dir)->i_metadata_bhs);
 			AFFS_TAIL(sb, rem_bh)->parent = 0;
 			retval = 0;
 			break;
@@ -180,7 +180,7 @@ affs_remove_link(struct dentry *dentry)
 			affs_unlock_dir(dir);
 			goto done;
 		}
-		mark_buffer_dirty_inode(link_bh, inode);
+		mmb_mark_buffer_dirty(link_bh, &AFFS_I(inode)->i_metadata_bhs);
 
 		memcpy(AFFS_TAIL(sb, bh)->name, AFFS_TAIL(sb, link_bh)->name, 32);
 		retval = affs_insert_hash(dir, bh);
@@ -188,7 +188,7 @@ affs_remove_link(struct dentry *dentry)
 			affs_unlock_dir(dir);
 			goto done;
 		}
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 
 		affs_unlock_dir(dir);
 		iput(dir);
@@ -203,7 +203,7 @@ affs_remove_link(struct dentry *dentry)
 			__be32 ino2 = AFFS_TAIL(sb, link_bh)->link_chain;
 			AFFS_TAIL(sb, bh)->link_chain = ino2;
 			affs_adjust_checksum(bh, be32_to_cpu(ino2) - link_ino);
-			mark_buffer_dirty_inode(bh, inode);
+			mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 			retval = 0;
 			/* Fix the link count, if bh is a normal header block without links */
 			switch (be32_to_cpu(AFFS_TAIL(sb, bh)->stype)) {
@@ -306,7 +306,7 @@ affs_remove_header(struct dentry *dentry)
 	retval = affs_remove_hash(dir, bh);
 	if (retval)
 		goto done_unlock;
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 
 	affs_unlock_dir(dir);
 
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 6c9258359ddb..606630d6f5f7 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -140,14 +140,14 @@ affs_alloc_extblock(struct inode *inode, struct buffer_head *bh, u32 ext)
 	AFFS_TAIL(sb, new_bh)->parent = cpu_to_be32(inode->i_ino);
 	affs_fix_checksum(sb, new_bh);
 
-	mark_buffer_dirty_inode(new_bh, inode);
+	mmb_mark_buffer_dirty(new_bh, &AFFS_I(inode)->i_metadata_bhs);
 
 	tmp = be32_to_cpu(AFFS_TAIL(sb, bh)->extension);
 	if (tmp)
 		affs_warning(sb, "alloc_ext", "previous extension set (%x)", tmp);
 	AFFS_TAIL(sb, bh)->extension = cpu_to_be32(blocknr);
 	affs_adjust_checksum(bh, blocknr - tmp);
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 
 	AFFS_I(inode)->i_extcnt++;
 	mark_inode_dirty(inode);
@@ -581,7 +581,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		memset(AFFS_DATA(bh) + boff, 0, tmp);
 		be32_add_cpu(&AFFS_DATA_HEAD(bh)->size, tmp);
 		affs_fix_checksum(sb, bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 		size += tmp;
 		bidx++;
 	} else if (bidx) {
@@ -603,7 +603,7 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(tmp);
 		affs_fix_checksum(sb, bh);
 		bh->b_state &= ~(1UL << BH_New);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 		if (prev_bh) {
 			u32 tmp_next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
 
@@ -613,7 +613,8 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 					     bidx, tmp_next);
 			AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 			affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-			mark_buffer_dirty_inode(prev_bh, inode);
+			mmb_mark_buffer_dirty(prev_bh,
+					      &AFFS_I(inode)->i_metadata_bhs);
 			affs_brelse(prev_bh);
 		}
 		size += bsize;
@@ -732,7 +733,7 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 		AFFS_DATA_HEAD(bh)->size = cpu_to_be32(
 			max(boff + tmp, be32_to_cpu(AFFS_DATA_HEAD(bh)->size)));
 		affs_fix_checksum(sb, bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 		written += tmp;
 		from += tmp;
 		bidx++;
@@ -765,12 +766,13 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-				mark_buffer_dirty_inode(prev_bh, inode);
+				mmb_mark_buffer_dirty(prev_bh,
+					&AFFS_I(inode)->i_metadata_bhs);
 			}
 		}
 		affs_brelse(prev_bh);
 		affs_fix_checksum(sb, bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 		written += bsize;
 		from += bsize;
 		bidx++;
@@ -799,13 +801,14 @@ static int affs_write_end_ofs(const struct kiocb *iocb,
 						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
 				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
-				mark_buffer_dirty_inode(prev_bh, inode);
+				mmb_mark_buffer_dirty(prev_bh,
+						&AFFS_I(inode)->i_metadata_bhs);
 			}
 		} else if (be32_to_cpu(AFFS_DATA_HEAD(bh)->size) < tmp)
 			AFFS_DATA_HEAD(bh)->size = cpu_to_be32(tmp);
 		affs_brelse(prev_bh);
 		affs_fix_checksum(sb, bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 		written += tmp;
 		from += tmp;
 		bidx++;
@@ -942,7 +945,7 @@ affs_truncate(struct inode *inode)
 	}
 	AFFS_TAIL(sb, ext_bh)->extension = 0;
 	affs_fix_checksum(sb, ext_bh);
-	mark_buffer_dirty_inode(ext_bh, inode);
+	mmb_mark_buffer_dirty(ext_bh, &AFFS_I(inode)->i_metadata_bhs);
 	affs_brelse(ext_bh);
 
 	if (inode->i_size) {
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 84afa862f220..51c71c7523a3 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -206,7 +206,7 @@ affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		}
 	}
 	affs_fix_checksum(sb, bh);
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 	affs_brelse(bh);
 	affs_free_prealloc(inode);
 	return 0;
@@ -268,10 +268,10 @@ affs_evict_inode(struct inode *inode)
 		inode->i_size = 0;
 		affs_truncate(inode);
 	} else {
-		sync_mapping_buffers(&inode->i_data);
+		mmb_sync(&AFFS_I(inode)->i_metadata_bhs);
 	}
 
-	invalidate_inode_buffers(inode);
+	mmb_invalidate(&AFFS_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	affs_free_prealloc(inode);
 	cache_page = (unsigned long)AFFS_I(inode)->i_lc;
@@ -306,7 +306,7 @@ affs_new_inode(struct inode *dir)
 	bh = affs_getzeroblk(sb, block);
 	if (!bh)
 		goto err_bh;
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 	affs_brelse(bh);
 
 	inode->i_uid     = current_fsuid();
@@ -394,17 +394,17 @@ affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s3
 		AFFS_TAIL(sb, bh)->link_chain = chain;
 		AFFS_TAIL(sb, inode_bh)->link_chain = cpu_to_be32(block);
 		affs_adjust_checksum(inode_bh, block - be32_to_cpu(chain));
-		mark_buffer_dirty_inode(inode_bh, inode);
+		mmb_mark_buffer_dirty(inode_bh, &AFFS_I(inode)->i_metadata_bhs);
 		set_nlink(inode, 2);
 		ihold(inode);
 	}
 	affs_fix_checksum(sb, bh);
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 	dentry->d_fsdata = (void *)(long)bh->b_blocknr;
 
 	affs_lock_dir(dir);
 	retval = affs_insert_hash(dir, bh);
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 	affs_unlock_dir(dir);
 	affs_unlock_link(inode);
 
diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index f883be50db12..23d00d85cf21 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -373,7 +373,7 @@ affs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	}
 	*p = 0;
 	inode->i_size = i + 1;
-	mark_buffer_dirty_inode(bh, inode);
+	mmb_mark_buffer_dirty(bh, &AFFS_I(inode)->i_metadata_bhs);
 	affs_brelse(bh);
 	mark_inode_dirty(inode);
 
@@ -443,7 +443,8 @@ affs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	/* TODO: move it back to old_dir, if error? */
 
 done:
-	mark_buffer_dirty_inode(bh, retval ? old_dir : new_dir);
+	mmb_mark_buffer_dirty(bh,
+			&AFFS_I(retval ? old_dir : new_dir)->i_metadata_bhs);
 	affs_brelse(bh);
 	return retval;
 }
@@ -496,8 +497,8 @@ affs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = affs_insert_hash(old_dir, bh_new);
 	affs_unlock_dir(old_dir);
 done:
-	mark_buffer_dirty_inode(bh_old, new_dir);
-	mark_buffer_dirty_inode(bh_new, old_dir);
+	mmb_mark_buffer_dirty(bh_old, &AFFS_I(new_dir)->i_metadata_bhs);
+	mmb_mark_buffer_dirty(bh_new, &AFFS_I(old_dir)->i_metadata_bhs);
 	affs_brelse(bh_old);
 	affs_brelse(bh_new);
 	return retval;
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 8451647f3fea..079f36e1ddec 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -108,6 +108,7 @@ static struct inode *affs_alloc_inode(struct super_block *sb)
 	i->i_lc = NULL;
 	i->i_ext_bh = NULL;
 	i->i_pa_cnt = 0;
+	mmb_init(&i->i_metadata_bhs, &i->vfs_inode.i_data);
 
 	return &i->vfs_inode;
 }
-- 
2.51.0


