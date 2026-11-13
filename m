Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B88606A8A3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ecvOoYRF
Received: by kanga.kvack.org (Postfix)
	id 2788E6B06F5; Fri, 13 Nov 2026 07:01:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232746B06F7; Fri, 13 Nov 2026 07:01:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118EC6B06F8; Fri, 13 Nov 2026 07:01:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D957E6B06F5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73A7F1C3B29
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:53 +0000 (UTC)
X-FDA: 85429956906.28.372B826
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 93551140004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ecvOoYRF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTGla4CtFvb+dugW9nafTcLMXkmjQU/PDOgQAyjt7Jo=;
	b=vjLcMZYXsIgIsEOx7gZ7duVqFYnR7QxuTlOa2HXv1aDa/EZFwh77qFPcScxWHLpcEWLnXz
	W3mrn8qUybWhjSOd85//XSjnXQ+ZV+H9hyGO+BW40BlJOZku6lB7jRAap0jgcyAvutoUGg
	jvM4c+c6RrmAoQm52htAzicdUuKVxGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571311;
	b=wZ7TOy7yGTovGEscUGVaRO+L2SmDRSEwvwTTE5wWS56qvQ3PFyPdO596cpN7G2msMuHPQs
	nlWxw9TB+2l7abNiMSLjX1EluTrvmZZcgqtmdjboQ9Ytd1VxKpZ10buTRa505uv9GdrJvY
	VkRXTIk3hLRMfY1p3nOZwUF7llgUN7Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ecvOoYRF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3E504195A;
	Fri, 13 Nov 2026 12:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C991F000C4;
	Fri, 13 Nov 2026 12:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571310;
	bh=fTGla4CtFvb+dugW9nafTcLMXkmjQU/PDOgQAyjt7Jo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ecvOoYRFQCL1qexCm7IrwfE7f8bCv1J2psh7CFJnYRZi1VhV5gSbhZCTCwi32MJdX
	 ftg3Pmul+sESIQkOwCQ/Qd2KF+OQJIYDSaMGZQpiU7+0K8mCXhrvBu4fYPRqB3YkBl
	 cibcGPQugQDLwXDB2kAuDCtu3DIVOq66kD4hlO5PfsGFeNLAI5TJxgqRsa1u2yd82H
	 EXbhkC6/q1wi1twseoxmHvOYlcpwxWaqgLC2Gu0bfl+sDqEibJtNAgvDHOB4gRrHg0
	 O4VJPWHKu/lYGQSGynCZyenbPSS5Bw4+y6+G6Ju/UtjMFE0Q2FCww3QK0VPhRQ/HGe
	 7H+2d2JPbIbrg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:19 +0100
Subject: [PATCH v3 23/33] zonefs: don't set SB_RDONLY after I/O errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-23-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=8264; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oOYP1ME9aUUUSkqsl/HC06d8SfymwB765CSw4pOC/SQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+711q89T89ezFeZx/rIp6xM/q7nlk9l/z9s2MzkWa
 gcV1y4J6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIt1ZGhgb3kl8dlyYvYDzI
 fuMwN+vsBXP1qtkvqv4sOHb9RPaTVR4M/6vPfJc9O7Hl8y6BX73zGA5tFDOVmRS547rtadPahYe
 tQ9gA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ejq17eokttfy9ef3khc68jdi5bxzgdr9
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 93551140004
X-HE-Tag: 1794571311-106817
X-HE-Meta: U2FsdGVkX1+6MKV1awUmHdA05jW9oHei0zzR3X65IUZ/lc+btXYu+Tq2kPYp3O/BPHW8YWv58g0ZUYaH69AcYz3MrA7Uwr3Ub34lzrnWgjFUt3uQv7aBv3lJKdkuE1v0M6KMggflwePFSCFBqib15eTw/jx7uvMhtBTRuDEPavub91CgLn1Zmf65i5RMaSGB6TKeGx2KJonJXUyhp3QIi3FIKJhU3sb9C5X1STrPj2tR93UGIPTX8b/7FkVrpzN1Zm9sXbQu8Wuh2NUnjRvNsus+6ICtQg854xTe4SwRVT9qBLl1KN1TX2VBHUu7M1RphI4aV9s/evsopX1DRAUQqq880XHZHDSHQEAD4sXp2MJTCk5d+RNhrmTA7wKnuA/O4kDoxxQ3cJrblA2ZECNvE0I+0uXg4CTAnmZMoGNr1TwZiZ1jzb7mmgPnszuDOz7lQvSkNaQWYAryEsKfbb4lhTgNlG8XjtScpX4m0j6qYXkuCjTHUfixZpL2E22HYw2C9CTEax9vXcTT8Sw/UWhDBe53hldLceuv27YVVrzXcjF/aqesupNJzDcEG3q/rYj3uwAZZTzjlY4Y2AiyoutT967zZjrOqNe6xcv/ZtPAADajqQfk0zN6F9gbYZK0Ag0jGFacvtMAdYJDhh3S0Np5yRFhh4a8c7cvEEaA0EY5zhJo9oykcqzfqHoiIFCSo+Z3nPfEpxUpScEoivKrPe2Dzk82wQs9GREUktfMElhwmC7kz2q4rm4fBl2UgVh7hp4YiDxrFRFilcSRep+t1ccWkWNFVEmwR9mDW+f1xcvaGrz2OnODOIT6egEHF9Cj8puzjqi6N21vrFICYXijPYfE01dc1bwxRfJkMvS4LemZEwSBXGFn2Tu1ltijXM62ICG4p412dE19NYaAaPmyRUuWELZDr8UzOpwXREDIZ7jCoJefv5BnFwg5DNA+Z/YXt3YyIngcjKscOMfa8gMfhij
 tcJCl1aj
 AKS4f/85Lj/qgMUPqzmtttowC9EkY4aORUlpOvNZC/rwl78frXPJlUhLVfh7ry89uy1lny0ueLqAQNaJQE/342uAqaqjzH1QyXHuHE4kB2LBA9UboTFnBti1uscFCd7mjIM1h9nu86FlkIEvgbDiQTYR8bHWtZurAqAflfnM3I/sx3wkdC25ngpk3jPcQR8fwJjbZo+fG9S7mOimE859THEm1OuA/r6XRMCE605ewhrI1/J+YZLOjdQQsaQDRgzyfKkApFXNLr6mvRJu+qMF0TbOQWaQiKLLt07puadBdp3l1rntgo3p+tANCrIXUx53QiKB87JodMo0alh0=
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
index c22124c2213d5..55ca0f2ef2b2a 100644
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
index 5b34849be7a2c..8959b6b36a83a 100644
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
index b97f1f2b8dda2..e7c97b75c6013 100644
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
index 8175652241b5c..b14822cb9c02e 100644
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


