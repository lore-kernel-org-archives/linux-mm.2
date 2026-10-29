Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B3760A2612
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CAbb5DUl
Received: by kanga.kvack.org (Postfix)
	id 8483C6B05E9; Thu, 29 Oct 2026 12:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81FFE6B05EB; Thu, 29 Oct 2026 12:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E81E6B05EC; Thu, 29 Oct 2026 12:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA646B05E9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:08:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA164160475
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:53 +0000 (UTC)
X-FDA: 85376147346.07.10F4542
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D73E92000F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CAbb5DUl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYLTRB96LN7RebiK7hFKBZ3h+lwWyZev+AxtatE8lJc=;
	b=ckv+ZCGVsiAh+QxKjrQtKeVCHk8BIQncjV79tFEwNdlV3xu6ZcfdRUTGykwH1rqmUU210e
	Qr+EvLxHnDHR+TAM6Q9OTW91PtEKLlqCc5MDnBL47ONiOPJyGysMY2q+RsnI/3RZf6Ajv0
	sw6RDnooW5AYawst+Vm3YDbuvLpP6kg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CAbb5DUl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290132;
	b=0XrUzaBtEHiO/LRUS9DJqsWlNekijLVxiCddzNFcE5p4YrujxiXz+KI0t2hOkb/n0ZvzSo
	UmD6iwpTbVEzpIIE4Nus2MqS+o1dVipnTz8pAL1lbMUM1BYvA87mYQVyBblcXKazs5ZA7z
	Z9MUC8vJgVGUbW216YS0CSADCL1XwEg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 437CE4163F;
	Thu, 29 Oct 2026 16:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319001F01816;
	Thu, 29 Oct 2026 16:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290131;
	bh=fYLTRB96LN7RebiK7hFKBZ3h+lwWyZev+AxtatE8lJc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CAbb5DUluPoHDa9s81xrNaUrrMVZGOhJEsr3nOf5L11RYO1az07kuHlQC+sqJ2waE
	 cKzYKUJATJ2hUTdX4GEC4InIrN5bsfrITO9yP0SsmPTbgSFuTQA2A/TEIjTK7ginCQ
	 m9l/mopoDv48kMJaNh4X9HHavXRZRI4Tf/yEYkoMoSrfMAZfqQnfwK8UszXwf+/y9J
	 4pV7wquhaaklkMbg0cC8jzaUtwx5sdUt8sSe9nVoMo49iMrnIe5No35nU5ePgqGfF7
	 PEhiKIJw5APmAPaLOZ3ivb/zM8Z0ntpogljyeQG1MrmuUvdoohlqlCbcvPz5MjoxZ+
	 pnfcprOoFUvPw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:12 +0100
Subject: [PATCH v2 21/34] zonefs: don't set SB_RDONLY after I/O errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-21-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=8256; i=brauner@kernel.org;
 h=from:subject:message-id; bh=lOaOSG9XUps4OEG0IvNRy9lQ1UJIH7otMWSnFL7mfmQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjfwYP4201UoTDjBIPvicfazLu8MXGv08q41bGdfv
 lrpxaGUjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIn8FWH473Rx2ZVGb87r2/x/
 sUV/tp7s3PNTcq3S18fsTyyU5oqwvmL4H3fl6V/ZpC7diTybaw7Z8xg6lSnHyBkZTZqz65JF2gs
 JFgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D73E92000F
X-Stat-Signature: bk8rijnqeijaufg435c5noxsuykk6p4f
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793290131-335393
X-HE-Meta: U2FsdGVkX1+hM7936BH1Cn1ydANMywljWRkd88neteI6bCNvIARY7JFhPE1bZ2uj3fW6JeTYu7PcT/HueBAjmiRzV/Po1ctF0U5hgYVNMFtrATMHEEm12mLLAPxZ3465xFBgncpdWpkI6bQUgZIIVtC47IDe3Ps+zZ/znRC1H2XLPVWkHxHZ+X0vEAJNCFeADU/men7nMqjxBJy4//NQrsLCW5pAKl3xTKK+I1dcKauBpgDX2PSela+1UcllmC7sB4R97EonTzW6rPyVy7LwxmpxAp4JBFUVy9olmwOxgPUKQbYfJ2Pj4a2tbIblgQPVpY396diyrdarnFYKI2eP8uSTPuo2vNF4yK7sTeozo0IYzUPvhXzKSpNrrkJF/oDPlxv8AtE5PDST/JUiha/gMXm/beVbR8vIQ7R/pXKzWAv7y2DlPSkjD4BlmPJar4Pz/7GddX7ciW0v0mVMwMMh3vcmZwspN3ReAnUviKNzmIL+FbgKOukwTvLlPAlHnbNKw14LUqZecCqSza+24sXl/xMTWqT/2jgd0INkQaKwAD7LmUd5DrFQ8DZTPynJCBv5HnycCrNbRzJpCtYrHA05eQoFsNpHdg/0QIsu6soQNBnjW53fxeDHwhF+aXsUUx5MiWdbMngRH6V5TmECISAy66OseVEpTTaWaDIsUfbkWGJ4gOp9VCeqokszj5xRczG3m3v387pq77OxG8j5C99vniPUXPHGTpeJuO2rNFhyglxH5utvsopDYv/p2Tx73R3qGvuvGvxnvu7NBHBJzo6YIy42HgBZ4m9ywHbHUZnHplS3RzE1xQ+xqNJdFOP65OSI5qd2O3Cau1sJ+TlOSXpcYsGQZKEB5QMob1h2eOyuScOG90yI5nqa1GxPrm4cNWiEgxbLoIw3ivQerftpPKnFSjehVS8Feq/SDDbOTTcxERa4eO22JNJxnT4abYx0c6SX8xtTFMfD2rYw+LOuyuC
 RL5AoBKZ
 O/0Kc2SjZhKA+MCjx60dF0nFvkcQ58O7INFcbsbGuzOoAGWMpvDngTY8nCff24eqO+Ut0VAb3Zl/a65xlk/EfNfry6SjHevgO5kuK6S7tAfCfr4rf5tB96LRnrkD/b+mRYTHFeU2uo4WOGrcNMAPT/c++yZCpw1ktpW+U32VZZOb2714rJv+7ZixH7bSpIZTN+N48pZAHkc9h01HZlSLmB2cDPA/yZ5CrmUu3LYYcRQXK/1POfiM+beVJAvfQEy5jlKDJE5I92NBd+FkTDuAg4s5/7jCLzqc/TYWrXnPPItyAmHIX4IkMtUZHX447dXCTFLtcZ421cLR/K5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zonefs sets SB_RDONLY from its I/O error handling without holding
s_umount: with errors=remount-ro, when the zone report fails and when
closing an explicitly opened zone fails. If that happens while the
filesystem is frozen through bdev_freeze() thaw_super() sees a read-only
superblock and leaves the s_writers rwsems locked. Writers hang and even
a remount to read-write doesn't help because the next freeze blocks
forever.

So record the error in a new ZONEFS_SB_EMERGENCY_RO bit instead. All
three places go through zonefs_set_emergency_ro() which keeps printing
the warning once. Write opens, write_iter and setattr fail with EROFS
and page_mkwrite with SIGBUS. An error on a read-only mount doesn't set
the bit.

The state lasts until umount and zonefs.rst says so. A remount to
read-only works and writes nothing. /proc/mounts keeps showing the
filesystem read-write. ftruncate() and write faults through file
descriptors and mappings from before the error are refused now too.

Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/zonefs.rst |  4 ++--
 fs/zonefs/file.c                     | 17 +++++++++--------
 fs/zonefs/super.c                    | 34 ++++++++++++++++++++++++++--------
 fs/zonefs/zonefs.h                   | 16 ++++++++++++++++
 4 files changed, 53 insertions(+), 18 deletions(-)

diff --git a/Documentation/filesystems/zonefs.rst b/Documentation/filesystems/zonefs.rst
index c22124c2213d..55ca0f2ef2b2 100644
--- a/Documentation/filesystems/zonefs.rst
+++ b/Documentation/filesystems/zonefs.rst
@@ -285,8 +285,8 @@ Further notes:
 * The "errors=remount-ro" mount option is the default behavior of zonefs I/O
   error processing if no errors mount option is specified.
 * With the "errors=remount-ro" mount option, the change of the file access
-  permissions to read-only applies to all files. The file system is remounted
-  read-only.
+  permissions to read-only applies to all files. A file system mounted
+  read-write refuses all writes until it is unmounted.
 * Access permission and file size changes due to the device transitioning zones
   to the offline condition are permanent. Remounting or reformatting the device
   with mkfs.zonefs (mkzonefs) will not change back offline zone files to a good
diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 5b34849be7a2..8959b6b36a83 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -299,7 +299,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	vm_fault_t ret;
 
-	if (unlikely(IS_IMMUTABLE(inode)))
+	if (unlikely(IS_IMMUTABLE(inode) || zonefs_emergency_ro(inode->i_sb)))
 		return VM_FAULT_SIGBUS;
 
 	/*
@@ -601,7 +601,7 @@ static ssize_t zonefs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
-	if (sb_rdonly(inode->i_sb))
+	if (sb_rdonly(inode->i_sb) || zonefs_emergency_ro(inode->i_sb))
 		return -EROFS;
 
 	/* Write operations beyond the zone capacity are not allowed */
@@ -788,6 +788,9 @@ static int zonefs_file_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
+	if ((file->f_mode & FMODE_WRITE) && zonefs_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	file->f_mode |= FMODE_CAN_ODIRECT;
 	ret = generic_file_open(inode, file);
 	if (ret)
@@ -825,17 +828,15 @@ static void zonefs_seq_file_write_close(struct inode *inode)
 			/*
 			 * Leaving zones explicitly open may lead to a state
 			 * where most zones cannot be written (zone resources
-			 * exhausted). So take preventive action by remounting
-			 * read-only.
+			 * exhausted). So take preventive action by making the
+			 * file system read-only.
 			 */
 			if (z->z_flags & ZONEFS_ZONE_OPEN &&
-			    !(sb->s_flags & SB_RDONLY)) {
+			    !sb_rdonly(sb) && !zonefs_emergency_ro(sb)) {
 				zonefs_warn(sb,
 					"closing zone at %llu failed %d\n",
 					z->z_sector, ret);
-				zonefs_warn(sb,
-					"remounting filesystem read-only\n");
-				sb->s_flags |= SB_RDONLY;
+				zonefs_set_emergency_ro(sb);
 			}
 			goto unlock;
 		}
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index b97f1f2b8dda..e7c97b75c601 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -247,6 +247,19 @@ static void zonefs_inode_update_mode(struct inode *inode)
 	z->z_mode = inode->i_mode;
 }
 
+/*
+ * Refuse writes after an error. SB_RDONLY needs s_umount and a remount, set on
+ * a frozen file system it makes thaw_super() leave s_writers locked.
+ */
+void zonefs_set_emergency_ro(struct super_block *sb)
+{
+	if (sb_rdonly(sb) ||
+	    test_and_set_bit(ZONEFS_SB_EMERGENCY_RO, &ZONEFS_SB(sb)->s_state))
+		return;
+
+	zonefs_warn(sb, "remounting filesystem read-only\n");
+}
+
 static int zonefs_io_error_cb(struct blk_zone *zone, unsigned int idx,
 			      void *data)
 {
@@ -339,13 +352,11 @@ static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
 		z->z_flags &= ~ZONEFS_ZONE_OPEN;
 
 	/*
-	 * If error=remount-ro was specified, any error result in remounting
-	 * the volume as read-only.
+	 * If error=remount-ro was specified, any error makes the volume
+	 * read-only.
 	 */
-	if ((sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_RO) && !sb_rdonly(sb)) {
-		zonefs_warn(sb, "remounting filesystem read-only\n");
-		sb->s_flags |= SB_RDONLY;
-	}
+	if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_RO)
+		zonefs_set_emergency_ro(sb);
 
 	/*
 	 * Update block usage stats and the inode size  to prevent access to
@@ -404,8 +415,7 @@ void __zonefs_io_error(struct inode *inode, bool write)
 	if (ret != 1) {
 		zonefs_err(sb, "Get inode %llu zone information failed %d\n",
 			   inode->i_ino, ret);
-		zonefs_warn(sb, "remounting filesystem read-only\n");
-		sb->s_flags |= SB_RDONLY;
+		zonefs_set_emergency_ro(sb);
 		return;
 	}
 
@@ -539,6 +549,9 @@ static int zonefs_inode_setattr(const struct mnt_idmap *idmap,
 	struct inode *inode = d_inode(dentry);
 	int ret;
 
+	if (unlikely(zonefs_emergency_ro(inode->i_sb)))
+		return -EROFS;
+
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
@@ -1369,6 +1382,11 @@ static int zonefs_reconfigure(struct fs_context *fc)
 	struct super_block *sb = fc->root->d_sb;
 	struct zonefs_sb_info *sbi = sb->s_fs_info;
 
+	/* An error made the file system read-only until it is unmounted. */
+	if (sb_rdonly(sb) && !(fc->sb_flags & SB_RDONLY) &&
+	    zonefs_emergency_ro(sb))
+		return -EROFS;
+
 	sync_filesystem(fc->root->d_sb);
 	/* Copy new options from ctx into sbi. */
 	sbi->s_mount_opts = ctx->s_mount_opts;
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index 8175652241b5..b14822cb9c02 100644
--- a/fs/zonefs/zonefs.h
+++ b/fs/zonefs/zonefs.h
@@ -241,6 +241,16 @@ struct zonefs_sb_info {
 	bool			s_sysfs_registered;
 	struct kobject		s_kobj;
 	struct completion	s_kobj_unregister;
+
+	unsigned long		s_state;
+};
+
+/*
+ * Super block state bits (s_state).
+ */
+enum {
+	/* An error made the file system read-only until it is unmounted */
+	ZONEFS_SB_EMERGENCY_RO,
 };
 
 static inline struct zonefs_sb_info *ZONEFS_SB(struct super_block *sb)
@@ -248,6 +258,11 @@ static inline struct zonefs_sb_info *ZONEFS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+static inline bool zonefs_emergency_ro(struct super_block *sb)
+{
+	return test_bit(ZONEFS_SB_EMERGENCY_RO, &ZONEFS_SB(sb)->s_state);
+}
+
 #define zonefs_info(sb, format, args...)	\
 	pr_info("zonefs (%s): " format, sb->s_id, ## args)
 #define zonefs_err(sb, format, args...)		\
@@ -260,6 +275,7 @@ void zonefs_inode_account_active(struct inode *inode);
 int zonefs_inode_zone_mgmt(struct inode *inode, enum req_op op);
 void zonefs_i_size_write(struct inode *inode, loff_t isize);
 void zonefs_update_stats(struct inode *inode, loff_t new_isize);
+void zonefs_set_emergency_ro(struct super_block *sb);
 void __zonefs_io_error(struct inode *inode, bool write);
 
 static inline void zonefs_io_error(struct inode *inode, bool write)

-- 
2.53.0


