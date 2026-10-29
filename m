Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E122606A330
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kZO5mYTz
Received: by kanga.kvack.org (Postfix)
	id 5872E6B05BA; Thu, 29 Oct 2026 12:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538FC6B05CA; Thu, 29 Oct 2026 12:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFF86B05CB; Thu, 29 Oct 2026 12:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 133726B05BA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:08:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CC41A7FF5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:11 +0000 (UTC)
X-FDA: 85376145582.09.76804EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C96561A0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kZO5mYTz;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290089;
	b=PoqaCw4VLEnCOJDc7I0ESd1pyZ+11X7V/ay3wmsK22YXTn2qvAL2yR1LIcc7+m4T46BcdC
	5OBP/jvAK2kWKgqNmLfB1qP96tsnzIfsxKZJ5JDab6WLlX3SD+K9L1aKW6H2zpDUT+cw+q
	IT7g2rb5iq7XmH7q0BwO+4BM9Prk2ZI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kZO5mYTz;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBop/I1sxHpMBXqMpx8CeeDCXAySNjKC9aKMSnGOGFQ=;
	b=R8vK/vqjS5Xq3Cr9LHrpN6eNkRzG6RsBb2u6pFxj1ft5Qtm1Sz8Ub9PhJub4MApQVc/IYh
	j+nkFpa1EN9Q3B2Md7q23pQ8f446scaesEhM0kJ3M9YsdRcvbFMROUU7ff3BSqX6ifd2aF
	EoB/OQ7K/y1Z0ledwlw/O4Et+44oVVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24F1640D73;
	Thu, 29 Oct 2026 16:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE57B1F01816;
	Thu, 29 Oct 2026 16:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290089;
	bh=gBop/I1sxHpMBXqMpx8CeeDCXAySNjKC9aKMSnGOGFQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kZO5mYTzBw+bB49203RNqrZShEkSe1zbH+JYICABROEOUOKcZxUyKwL21VlIz949g
	 8P0TKIU4MoKSvpQ9r/pggJVZEncvfQ1FCyOYTUA3zQnBGopFR0jGxtfJdFRUkTER79
	 j5nCbTz0QHVL9XjTGxU2siFqxYijE7KIvPZPZw3iaa4wt1LntPYb3r82axhYTCPoLu
	 A7K/zwy8E02Ogjk10TWH9uSNhF1G0d25BTYqfX6Ibh3KXf/m1MAWZNTGk/JOizPYG1
	 L96RWx+/zkOq3kR9O3gKPw1x0YKu5WA4QiNz/Tfg30VOXnAVbvBAdkfMNO73u2Xm9p
	 vwrohQFhCcRBg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:02 +0100
Subject: [PATCH v2 11/34] hfs: don't set SB_RDONLY after MDB write errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-11-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Viacheslav Dubeyko <slava@dubeyko.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=10556; i=brauner@kernel.org;
 h=from:subject:message-id; bh=0FHakpkA1BemddUf6W1nU0XfKFfXqMtaY9XbXpS/Erw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztfPe+bzZ3rpowel9wLjzk/rubasonDVJbe8jx6uZ
 34uXdl3pKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi0V6MDO9PuDzXeVlt6pqY
 xvj420tF5fvcql9ylcrC2mZrFV9cIcHwP2hei4/H9b2dFa9095jIGeya8zHm4h3GP1tvvI+4e7R
 wAxMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: C96561A0006
X-Stat-Signature: u5qkeu8fw7xc99j1q41p8cpjn7httmww
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793290089-30025
X-HE-Meta: U2FsdGVkX18R/C1HL8gLTWM7HxXNdVangw6emiH1R26jT8gADFFEBmMy5Yu0ep1re6Xbgz9x2F6jxZzpo3bj4JTMbFHBT/18s+y3WtQMQyXR3u6YdAkTo04WxWw8FrsYO3p/c7/SNJ3WD/Nn3TiDM9BN/saK+OW7Yg2Ybb1kwF7i4zpSICddlu7Y8T5+HlFSI18G7jCO57p5sFixZeNDszCCJTQ2qkCIyrhRygKDqIVeE6aksp7StFDWENjFGljFz+cI0+0hn610EuEw8dDuVbZC+KdCxjQfHK4gPQEZ5pt9RCWs+mGi91KPJ0A+tHpEL9TUHs/olfCaHAlnBTGaJAJbAqhJRI12CCGhw9AGPnMXjEvlIxW1iInPX7CEzjxg9jgPMB3Pj0aEYev/7/Uj8Vo5e37can0Q9KSc+LjmCNVkGW5z5eR98HUTicjkr05V5lp65qohpWCy9oZ2CHp1MHh73cOXhybOLRPgK2ZqQEbOUGnZ5sG3x+w77khSTPZg+3fxLyevjrCA8tVUFddaW2BJrBbgaBQzoq7PBIkghuGYRe7+CAsJx2rZVU0dxl3toORxHAa3C7lTKR62ypHNaMM6ZQJ+1lSRotl5hAIbvrE87x/bo5+fCCOjFySzwxD95Wt31tk24pUMHrvAhumoHcpltru04buelS3K5CxmrhRRU8OjivjuQ0Q3kmUuGLcZ7aaQ98GLuy0IhbRY4EKU+NHlD9CNAu4+c8iWiWP6AMHIP68VKQ7mu6Qb23WQb1rVhdZqpwKrvZHmx24tIetUhDqWbLyg9CMx8X9ULBSpg85ufpC65D66RSj0CqQOt0gnlhrxrNsW2e8Lzqukbz0LLeldhyvQrwBA2K7LyPZVAxaTEQ+1YqYS1+nlS6D1ep6CLuz12PHB/HBOmJxkBFqrbmMFCkYv6zscSIeOgVOn+BK9dzGLpzKNTKPMGIt0OuJcTYLLd9Zd9arsJDKjmC3
 muxm7Dlf
 dS01qFVlosJGsgXXkX/ucMRI2hOZAtmq5pNP+7O3TRvwMTyr5DdRg4kDJsHxyaw5wHdIkjnx+HbvPlNM3H/3f863IjBFaDrn2d+532hHif+m1+MEXexlbQ4ArD5qNYKbQd+QenqdeuqO/SRhEXmIVGYJsx0IuPpZw/V8xOUHToJYY6JKzByWTirm/lRMIgiF6kCGWm97qRGXfxJ9dqJXSQ1JzWhUnEt5qnKUQd1/VVtG4JXj3PSJ5jclOOD51nQJwUylT1BD22H5206E965KCfyzRbg4xMLXuM7ILPif0DIfCDZkNcUOEGKuAzgCrwYoSrE0BiMEpbnve0nQhU1uRqKucRednOAF5bUAoDkwjEywL3ZiSDvN8dMRx5+slsHiHPgrEIUnpY2yWpHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit fdbb95ff89b2 ("hfs: don't re-dirty MDB buffers after a
write failure") hfs_mdb_commit() sets SB_RDONLY when a write of the MDB
failed. It runs from the flush_mdb work and from ->sync_fs() and neither
holds s_umount exclusively. freeze_super() decides from sb_rdonly()
whether to take the s_writers rwsems and drops s_umount while it waits
for writers. A sync(2) in that window sets SB_RDONLY, the freeze
completes with the rwsems held and the thaw never releases them.

So record the condition in a new HFS_FLG_EMERGENCY_RO bit instead. Later
calls of hfs_mdb_commit() return early like they did for sb_rdonly() and
the MDB is never marked cleanly unmounted. hfs refuses modifications
with EROFS itself: the namespace operations, setattr, the hfs.type and
hfs.creator xattrs, opening for write, write_begin, O_DIRECT writes,
block allocation, hfs_file_truncate() and writing inodes back.

B-tree growth isn't refused. A read can need a new b-tree node when it
writes back a cached extent record, and failing that would make such
reads fail with EIO until umount. That's also why the extents and
catalog b-tree headers are still written.

A remount to read-write fails with EROFS, a remount to read-only works
and /proc/mounts keeps showing the filesystem read-write.

Fixes: fdbb95ff89b2 ("hfs: don't re-dirty MDB buffers after a write failure")
Cc: stable@vger.kernel.org
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hfs/attr.c   |  3 +++
 fs/hfs/dir.c    | 12 ++++++++++++
 fs/hfs/extent.c |  5 +++++
 fs/hfs/hfs_fs.h | 11 +++++++++++
 fs/hfs/inode.c  | 30 ++++++++++++++++++++++++++++++
 fs/hfs/mdb.c    | 16 ++++++++++------
 fs/hfs/super.c  |  5 ++++-
 7 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/fs/hfs/attr.c b/fs/hfs/attr.c
index 6d737a085461..bd9a1289d8c5 100644
--- a/fs/hfs/attr.c
+++ b/fs/hfs/attr.c
@@ -129,6 +129,9 @@ static int hfs_xattr_set(const struct xattr_handler *handler,
 	if (!value)
 		return -EOPNOTSUPP;
 
+	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	return __hfs_setxattr(inode, handler->flags, value, size, flags);
 }
 
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index f6b97da19788..f0d8ddb07503 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -189,6 +189,9 @@ static int hfs_create(const struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	int res;
 
+	if (unlikely(hfs_emergency_ro(dir->i_sb)))
+		return -EROFS;
+
 	inode = hfs_new_inode(dir, &dentry->d_name, mode);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
@@ -219,6 +222,9 @@ static struct dentry *hfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir
 	struct inode *inode;
 	int res;
 
+	if (unlikely(hfs_emergency_ro(dir->i_sb)))
+		return ERR_PTR(-EROFS);
+
 	inode = hfs_new_inode(dir, &dentry->d_name, mode);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
@@ -252,6 +258,9 @@ static int hfs_remove(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	int res;
 
+	if (unlikely(hfs_emergency_ro(sb)))
+		return -EROFS;
+
 	if (S_ISDIR(inode->i_mode) && inode->i_size != 2)
 		return -ENOTEMPTY;
 
@@ -290,6 +299,9 @@ static int hfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
 
+	if (unlikely(hfs_emergency_ro(old_dir->i_sb)))
+		return -EROFS;
+
 	/* Unlink destination if it already exists */
 	if (d_really_is_positive(new_dentry)) {
 		res = hfs_remove(new_dir, new_dentry);
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index 26357086517f..dacf7ce1ffe4 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -356,6 +356,9 @@ int hfs_get_block(struct inode *inode, sector_t block,
 		if (block > HFS_I(inode)->fs_blocks)
 			return -EIO;
 		if (ablock >= HFS_I(inode)->alloc_blocks) {
+			/* No new allocations after an error. */
+			if (unlikely(hfs_emergency_ro(sb)))
+				return -EROFS;
 			res = hfs_extend_file(inode);
 			if (res)
 				return res;
@@ -491,6 +494,8 @@ void hfs_file_truncate(struct inode *inode)
 	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
 		inode->i_ino, (long long)HFS_I(inode)->phys_size,
 		inode->i_size);
+	if (unlikely(hfs_emergency_ro(sb)))
+		return;
 	if (inode->i_size > HFS_I(inode)->phys_size) {
 		struct address_space *mapping = inode->i_mapping;
 		void *fsdata = NULL;
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index fdfa5d303d5e..325214573d91 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -143,6 +143,7 @@ struct hfs_sb_info {
 #define HFS_FLG_BITMAP_DIRTY	0
 #define HFS_FLG_MDB_DIRTY	1
 #define HFS_FLG_ALT_MDB_DIRTY	2
+#define HFS_FLG_EMERGENCY_RO	3	/* read-only after an MDB write error */
 
 /* bitmap.c */
 extern u32 hfs_vbm_search_free(struct super_block *sb, u32 goal, u32 *num_bits);
@@ -293,6 +294,16 @@ static inline const char *hfs_mdb_name(struct super_block *sb)
 	return sb->s_id;
 }
 
+/*
+ * Writing back the MDB failed and the filesystem stopped all modifications
+ * until unmount. SB_RDONLY isn't used for that because it must not change
+ * without s_umount.
+ */
+static inline bool hfs_emergency_ro(struct super_block *sb)
+{
+	return test_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
+}
+
 static inline void hfs_bitmap_dirty(struct super_block *sb)
 {
 	set_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 40c169d67664..6ea3b8ffb284 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -54,6 +54,9 @@ int hfs_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 	loff_t total_capacity;
 	int ret;
 
+	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	total_capacity = (loff_t)sbi->fs_ablocks * sbi->alloc_blksz;
 
 	if (pos >= total_capacity)
@@ -139,6 +142,10 @@ static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
+	if (iov_iter_rw(iter) == WRITE &&
+	    unlikely(hfs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	ret = blockdev_direct_IO(iocb, inode, iter, hfs_get_block);
 
 	/*
@@ -472,6 +479,20 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int res;
 
 	hfs_dbg("ino %llu\n", inode->i_ino);
+	if (unlikely(hfs_emergency_ro(inode->i_sb))) {
+		/*
+		 * Writeback still writes the b-tree nodes. Keep the headers in
+		 * sync with them so the trees on disk stay intact.
+		 */
+		if (inode->i_ino == HFS_EXT_CNID)
+			hfs_btree_write(HFS_SB(inode->i_sb)->ext_tree);
+		else if (inode->i_ino == HFS_CAT_CNID)
+			hfs_btree_write(HFS_SB(inode->i_sb)->cat_tree);
+		else
+			return -EROFS;
+		return 0;
+	}
+
 	res = hfs_ext_write_extent(inode);
 	if (res)
 		return res;
@@ -619,6 +640,8 @@ void hfs_evict_inode(struct inode *inode)
 
 static int hfs_file_open(struct inode *inode, struct file *file)
 {
+	if ((file->f_mode & FMODE_WRITE) && hfs_emergency_ro(inode->i_sb))
+		return -EROFS;
 	if (HFS_IS_RSRC(inode))
 		inode = HFS_I(inode)->rsrc_inode;
 	atomic_inc(&HFS_I(inode)->opencnt);
@@ -650,6 +673,9 @@ int hfs_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct hfs_sb_info *hsb = HFS_SB(inode->i_sb);
 	int error;
 
+	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	error = setattr_prepare(&nop_mnt_idmap, dentry, attr);
 	if (error)
 		return error;
@@ -701,6 +727,10 @@ static int hfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 	struct super_block * sb;
 	int ret, err;
 
+	/* Inodes aren't written back after an error. */
+	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	ret = file_write_and_wait_range(filp, start, end);
 	if (ret)
 		return ret;
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 277de712f9d4..1a56cf5ea56e 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -322,8 +322,8 @@ int hfs_mdb_get(struct super_block *sb)
  *   NONE
  * Returns:
  *   0 on success, -EIO if the MDB or alternate MDB buffer is no longer
- *   valid (e.g. after a prior write error), in which case the volume is
- *   remounted read-only.
+ *   valid (e.g. after a prior write error), in which case the volume
+ *   refuses all further modifications until it is unmounted.
  * Preconditions:
  *   'mdb' points to a "valid" (struct hfs_mdb).
  * Postconditions:
@@ -338,12 +338,16 @@ int hfs_mdb_commit(struct super_block *sb)
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 	int ret = 0;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
 		return 0;
 
+	/*
+	 * SB_RDONLY needs s_umount and a remount. Set on a frozen superblock
+	 * it makes thaw_super() leave s_writers locked.
+	 */
 	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh)) {
 		pr_err("primary MDB is corrupt, mounting read-only\n");
-		sb->s_flags |= SB_RDONLY;
+		set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
 		return -EIO;
 	}
 
@@ -377,7 +381,7 @@ int hfs_mdb_commit(struct super_block *sb)
 	    HFS_SB(sb)->alt_mdb) {
 		if (!buffer_uptodate(HFS_SB(sb)->alt_mdb_bh)) {
 			pr_err("alternate MDB is corrupt, mounting read-only\n");
-			sb->s_flags |= SB_RDONLY;
+			set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
 			ret = -EIO;
 			goto out;
 		}
@@ -428,7 +432,7 @@ int hfs_mdb_commit(struct super_block *sb)
 void hfs_mdb_close(struct super_block *sb)
 {
 	/* update volume attributes */
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
 		return;
 
 	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh))
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 5e6d66ff4bee..bcc19c3a4f6b 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -82,7 +82,7 @@ void hfs_mark_mdb_dirty(struct super_block *sb)
 	struct hfs_sb_info *sbi = HFS_SB(sb);
 	unsigned long delay;
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
 		return;
 
 	spin_lock(&sbi->work_lock);
@@ -131,6 +131,9 @@ static int hfs_reconfigure(struct fs_context *fc)
 		return 0;
 
 	if (!(fc->sb_flags & SB_RDONLY)) {
+		/* After an MDB write error it stays read-only until unmount. */
+		if (hfs_emergency_ro(sb))
+			return -EROFS;
 		if (!(HFS_SB(sb)->mdb->drAtrb & cpu_to_be16(HFS_SB_ATTRIB_UNMNT))) {
 			pr_warn("filesystem was not cleanly unmounted, running fsck.hfs is recommended.  leaving read-only.\n");
 			sb->s_flags |= SB_RDONLY;

-- 
2.53.0


