Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73C6A606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BMqxbTrz
Received: by kanga.kvack.org (Postfix)
	id C15C46B06E1; Fri, 13 Nov 2026 07:01:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4C26B06E3; Fri, 13 Nov 2026 07:01:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5C16B06E4; Fri, 13 Nov 2026 07:01:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0C26B06E1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F09461A01E0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:13 +0000 (UTC)
X-FDA: 85429955226.23.8F6369C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3BD888000D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BMqxbTrz;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6iD7sstrNdnZdsGoW8MRvlzxFqMzWlzeZ0tM3s4uA9c=;
	b=adF7t1PMfmHc78obFxR+J10vSFfP6QBYaVGERqtXET6osfF5TIIU71de2AjAt3uLLJH2x3
	4mPh3HO7QfU8UY01Z42r1wNMiRQusuzWE8kGKaC+fJPYnqsGLDoXepp5Cnx9D01BLy+YRI
	O9n23TdlN5d1UnREe3HBtdZPUD3xj6c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571272;
	b=FpNTrIB+4oWWhOZOdNNkX2zqkKY0o0l6na1ib/ENx3565hLKPTBYU9qv/9Y12qGghVeJpb
	lpDSFNKfwSWP28MbpLVbpUS9sU5BILZ68zOXaUMyr0m9K5yHVdpjC65fBBb0zwnx36DtVo
	49CezU/DL+Aes9OM+/lphv1bebkdJCo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BMqxbTrz;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4D0D625B5;
	Fri, 13 Nov 2026 12:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7F41F000C5;
	Fri, 13 Nov 2026 12:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571271;
	bh=6iD7sstrNdnZdsGoW8MRvlzxFqMzWlzeZ0tM3s4uA9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BMqxbTrzVCboEKs2MS7YiMDuvFz/B9F7N6ntAC3JqYwRY2fkHbJKIHpX/XrK7TJ/K
	 gIuZhB7YK2k4gZ/apiEObn68R/8KgOohRxW7mD7OgVYPyyl0C04PKAiPQXIeVBLFab
	 BJYWN/PhCxKRmM3QmW5SnFh5vp+xasQfasRv83nmjs2sd1H7ius3tGEqWKaR9Di9DI
	 OV/dMm4REteTi73PmSOB3+yrlWxT159xnpqobPHw7N4rdx0xQLNB06VjChsFeJXRLT
	 5toImAztVZYz+AX9K7G3A4thEzuSxq8hrBeFgW1SJt9zhj9CUCHoBWrK8YYr2y/SG8
	 /dQNci1u69VgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:10 +0100
Subject: [PATCH v3 14/33] hfs: use the generic emergency read-only state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-14-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Viacheslav Dubeyko <slava@dubeyko.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=8251; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dZGJW8u7u4x/QzeOZT2uu6h5vPsYTWe6mpgxZFR76tA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+70q70ZiwoVe9pXmjrxOcVf8F7bOX7WDXez6/Kxf0
 29vm37HuaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiefUM/12fhma7HzBJK+Jl
 1jtu8Phy285NGZWPDS8riqd2XtRTu8nwV0rGRITPM4abO1Kh5pJVmHL3OnsNzbRK5a9am7eHpSv
 zAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: cqct1zobxyxpdoyau3z3te81xa4jbdc8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3BD888000D
X-Rspam-User: 
X-HE-Tag: 1794571272-497219
X-HE-Meta: U2FsdGVkX18reaUGWhCiK6hYFGvlk8/MESHYCnLPRksmS/N5FMkFXhCsW4OYKXRAI67Qm02ep2/xKrm/VW9zZKVMbjsWjtzrcUWRIbP7sjsd5dJ4zugEknDloLiuySaknoK7EnJ++cvCMvyPRkXAtUmOJMwYLud1XEMhgkj4vPOxAJ+5pDY0RCB/ypqq7Lit+TMQhA4a4abwHcbBAH4nXUPmQVGQK21/ANT6D61E3YIALRcAtw/7fTTmbOnkYijIU/3MYIhJm/Jw4BurDG0Dm6uJW9v5CjXrRBA6ZFE+NwvRUh5E/XnmUQRROkyeajFewvoO2UeWmsvnKz5gaWHsFkV7kmctxVFdk+3L+VV5xtQBE9LGnxV/t/mS0jDdMoZUPFy9eJXe1leQgvLD5GhSkEqC5ksxVWYGx2T8TRkIPhEgA/IIhULWHeuRHKcUGZ69MJTqpQHqqtUaKtEAGeqXToX8hiwBaMa8NlqAy6Vyg7KNwEJxCBkeEgF7JTxFDRucCIjHljaw4k8MR6dU1Or6P9p+jrMyoqmAjPPJ3B2iNb2H99tFjDSMy01700l1k8zMuYHRJ9VPtyNjmVRX4iUjPy/VH6CDWKa2gBeIVhyDcrYP4od6mDefuEbMAMiWPGcEm0Eooa+eyKTCq2hfaeZA061oqGO4HQeS0E4s3T7ufDea6GZkaMXzz3ylpXUm1noI2cBn4tGl9QO7h9Slqi2hu5Fhzg2RX378Gefp75dBEJ3R1VE15BBLZa7/j4fF1AGoK9X/lEFw1/EWUaOoQemWjRH84KjlWH3Kvp+HxfP8vDxLZVwRZgv6yPpY6NY/wnLTXX/aohIyF/Ret1lyq1O2lxAzmhqheicQRxYKUboG1mAIHjWTgfTK4pyDllcpwsexEyvlAEtXJMjx/AXVKqVquP4l1xF5jBrg/hmv5ZX7PR4GrCKTOPvrOtjvbDN7LrF4lUb8JqKiBW5cA8Smcim
 9RYs+Mh8
 8x63bk2dMq7eqMVMCSAkqNBMf35LIMgleavUQQE+SSEDvPWYkjIxJBOjTXOIEQyiH5IXDNRpz0vIAXXBptDI1y3dfViMsuLV4d2BYeijkPmBD/tyXnD9vheF8uVbwPsA3zpCoBYVK8FUfWBwY2+zYxCYjlkqd+flE7BoposBTT+g/dd6Ow6+DkTCCiLCb8jeTdIGe3IEfDsmbUb3g1Y4XCXKwR9byFeqpXIU/oemNp1C4TxTfUxk/DIJeTscu2xaUY+rTZAiJvtLhi/WcYAeDHZ57AfXSvK4YSMPnMp6frsooI+IK3lcV9f0d2r0CXiAZvTV5Pn/Vs/cut0RkZFIqkY9MWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Set SB_STATE_EMERGENCY_RO instead of a private bit and drop the checks
the VFS does now. What's left is hfs_get_block(), hfs_file_truncate(),
write_begin, O_DIRECT writes, the hfs.type and hfs.creator xattrs and
the MDB commit, close and dirtying paths.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hfs/attr.c   |  2 +-
 fs/hfs/dir.c    | 12 ------------
 fs/hfs/extent.c |  4 ++--
 fs/hfs/hfs_fs.h | 11 -----------
 fs/hfs/inode.c  | 13 ++-----------
 fs/hfs/mdb.c    |  8 ++++----
 fs/hfs/super.c  |  5 +----
 7 files changed, 10 insertions(+), 45 deletions(-)

diff --git a/fs/hfs/attr.c b/fs/hfs/attr.c
index bd9a1289d8c5d..337b22f282086 100644
--- a/fs/hfs/attr.c
+++ b/fs/hfs/attr.c
@@ -129,7 +129,7 @@ static int hfs_xattr_set(const struct xattr_handler *handler,
 	if (!value)
 		return -EOPNOTSUPP;
 
-	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+	if (unlikely(sb_emergency_ro(inode->i_sb)))
 		return -EROFS;
 
 	return __hfs_setxattr(inode, handler->flags, value, size, flags);
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index f0d8ddb075034..f6b97da197887 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -189,9 +189,6 @@ static int hfs_create(const struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	int res;
 
-	if (unlikely(hfs_emergency_ro(dir->i_sb)))
-		return -EROFS;
-
 	inode = hfs_new_inode(dir, &dentry->d_name, mode);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
@@ -222,9 +219,6 @@ static struct dentry *hfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir
 	struct inode *inode;
 	int res;
 
-	if (unlikely(hfs_emergency_ro(dir->i_sb)))
-		return ERR_PTR(-EROFS);
-
 	inode = hfs_new_inode(dir, &dentry->d_name, mode);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
@@ -258,9 +252,6 @@ static int hfs_remove(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	int res;
 
-	if (unlikely(hfs_emergency_ro(sb)))
-		return -EROFS;
-
 	if (S_ISDIR(inode->i_mode) && inode->i_size != 2)
 		return -ENOTEMPTY;
 
@@ -299,9 +290,6 @@ static int hfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
 
-	if (unlikely(hfs_emergency_ro(old_dir->i_sb)))
-		return -EROFS;
-
 	/* Unlink destination if it already exists */
 	if (d_really_is_positive(new_dentry)) {
 		res = hfs_remove(new_dir, new_dentry);
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index dacf7ce1ffe4a..fd874a93a92f5 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -357,7 +357,7 @@ int hfs_get_block(struct inode *inode, sector_t block,
 			return -EIO;
 		if (ablock >= HFS_I(inode)->alloc_blocks) {
 			/* No new allocations after an error. */
-			if (unlikely(hfs_emergency_ro(sb)))
+			if (unlikely(sb_emergency_ro(sb)))
 				return -EROFS;
 			res = hfs_extend_file(inode);
 			if (res)
@@ -494,7 +494,7 @@ void hfs_file_truncate(struct inode *inode)
 	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
 		inode->i_ino, (long long)HFS_I(inode)->phys_size,
 		inode->i_size);
-	if (unlikely(hfs_emergency_ro(sb)))
+	if (unlikely(sb_emergency_ro(sb)))
 		return;
 	if (inode->i_size > HFS_I(inode)->phys_size) {
 		struct address_space *mapping = inode->i_mapping;
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 325214573d91d..fdfa5d303d5ef 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -143,7 +143,6 @@ struct hfs_sb_info {
 #define HFS_FLG_BITMAP_DIRTY	0
 #define HFS_FLG_MDB_DIRTY	1
 #define HFS_FLG_ALT_MDB_DIRTY	2
-#define HFS_FLG_EMERGENCY_RO	3	/* read-only after an MDB write error */
 
 /* bitmap.c */
 extern u32 hfs_vbm_search_free(struct super_block *sb, u32 goal, u32 *num_bits);
@@ -294,16 +293,6 @@ static inline const char *hfs_mdb_name(struct super_block *sb)
 	return sb->s_id;
 }
 
-/*
- * Writing back the MDB failed and the filesystem stopped all modifications
- * until unmount. SB_RDONLY isn't used for that because it must not change
- * without s_umount.
- */
-static inline bool hfs_emergency_ro(struct super_block *sb)
-{
-	return test_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
-}
-
 static inline void hfs_bitmap_dirty(struct super_block *sb)
 {
 	set_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 10f72c0536a07..7e590e1308eac 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -54,7 +54,7 @@ int hfs_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 	loff_t total_capacity;
 	int ret;
 
-	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+	if (unlikely(sb_emergency_ro(inode->i_sb)))
 		return -EROFS;
 
 	total_capacity = (loff_t)sbi->fs_ablocks * sbi->alloc_blksz;
@@ -143,7 +143,7 @@ static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t ret;
 
 	if (iov_iter_rw(iter) == WRITE &&
-	    unlikely(hfs_emergency_ro(inode->i_sb)))
+	    unlikely(sb_emergency_ro(inode->i_sb)))
 		return -EROFS;
 
 	ret = blockdev_direct_IO(iocb, inode, iter, hfs_get_block);
@@ -626,8 +626,6 @@ void hfs_evict_inode(struct inode *inode)
 
 static int hfs_file_open(struct inode *inode, struct file *file)
 {
-	if ((file->f_mode & FMODE_WRITE) && hfs_emergency_ro(inode->i_sb))
-		return -EROFS;
 	if (HFS_IS_RSRC(inode))
 		inode = HFS_I(inode)->rsrc_inode;
 	atomic_inc(&HFS_I(inode)->opencnt);
@@ -659,9 +657,6 @@ int hfs_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct hfs_sb_info *hsb = HFS_SB(inode->i_sb);
 	int error;
 
-	if (unlikely(hfs_emergency_ro(inode->i_sb)))
-		return -EROFS;
-
 	error = setattr_prepare(&nop_mnt_idmap, dentry, attr);
 	if (error)
 		return error;
@@ -713,10 +708,6 @@ static int hfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 	struct super_block * sb;
 	int ret, err;
 
-	/* Inodes aren't written back after an error. */
-	if (unlikely(hfs_emergency_ro(inode->i_sb)))
-		return -EROFS;
-
 	ret = file_write_and_wait_range(filp, start, end);
 	if (ret)
 		return ret;
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 1a56cf5ea56e6..19dfc7a13d8c4 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -338,7 +338,7 @@ int hfs_mdb_commit(struct super_block *sb)
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 	int ret = 0;
 
-	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
+	if (sb_rdonly_any(sb))
 		return 0;
 
 	/*
@@ -347,7 +347,7 @@ int hfs_mdb_commit(struct super_block *sb)
 	 */
 	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh)) {
 		pr_err("primary MDB is corrupt, mounting read-only\n");
-		set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
+		sb_set_emergency_ro(sb);
 		return -EIO;
 	}
 
@@ -381,7 +381,7 @@ int hfs_mdb_commit(struct super_block *sb)
 	    HFS_SB(sb)->alt_mdb) {
 		if (!buffer_uptodate(HFS_SB(sb)->alt_mdb_bh)) {
 			pr_err("alternate MDB is corrupt, mounting read-only\n");
-			set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
+			sb_set_emergency_ro(sb);
 			ret = -EIO;
 			goto out;
 		}
@@ -432,7 +432,7 @@ int hfs_mdb_commit(struct super_block *sb)
 void hfs_mdb_close(struct super_block *sb)
 {
 	/* update volume attributes */
-	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
+	if (sb_rdonly_any(sb))
 		return;
 
 	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh))
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index bcc19c3a4f6bc..7abc0e61a222f 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -82,7 +82,7 @@ void hfs_mark_mdb_dirty(struct super_block *sb)
 	struct hfs_sb_info *sbi = HFS_SB(sb);
 	unsigned long delay;
 
-	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
+	if (sb_rdonly_any(sb))
 		return;
 
 	spin_lock(&sbi->work_lock);
@@ -131,9 +131,6 @@ static int hfs_reconfigure(struct fs_context *fc)
 		return 0;
 
 	if (!(fc->sb_flags & SB_RDONLY)) {
-		/* After an MDB write error it stays read-only until unmount. */
-		if (hfs_emergency_ro(sb))
-			return -EROFS;
 		if (!(HFS_SB(sb)->mdb->drAtrb & cpu_to_be16(HFS_SB_ATTRIB_UNMNT))) {
 			pr_warn("filesystem was not cleanly unmounted, running fsck.hfs is recommended.  leaving read-only.\n");
 			sb->s_flags |= SB_RDONLY;

-- 
2.53.0


