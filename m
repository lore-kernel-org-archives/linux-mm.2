Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE77606A329
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UU43cvTm
Received: by kanga.kvack.org (Postfix)
	id 056A26B05C0; Thu, 29 Oct 2026 12:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EC06B05C1; Thu, 29 Oct 2026 12:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5EF46B05C2; Thu, 29 Oct 2026 12:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C30896B05C0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:07:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 653C8140491
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:07:45 +0000 (UTC)
X-FDA: 85376144490.13.D89E242
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8936E40010
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:07:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UU43cvTm;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6xEl5vN8EuvEulvkIp6GQ6S1/TdAJIG4nKa9XNObos=;
	b=NJRiIDJCAkTgO/1bMM/PL/EjUn6+LC66+/h++EaHGBkGJfHbaLz26AFM2qljPeaqrZqAR7
	hdF2Qmf0UA1XJsPp1mJW7ebB1CT+XKgz/XEDKUs4+zMZV4Cu9uY/7JezHbMNw5dOKYY05N
	mKnK95gZpm+7gX2MM2f2szaTQE16Yg8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UU43cvTm;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290063;
	b=d7W3h0y6rUQfhoXqG5xEaMvSaVlx/kdWKwveKcjeewr64n45oHqLP6rmlDLwalHhpidL/j
	CvylzgWISv936CjOsM44nKmSremI4AIsGPKxC7qy0P/h7vpPfPkQVfJiqmtP8Iu1JMsNJ4
	tCGTtwCao1nIAJU0iAnUzGZNewk1+kU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C94474148D;
	Thu, 29 Oct 2026 16:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11F81F01825;
	Thu, 29 Oct 2026 16:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290062;
	bh=U6xEl5vN8EuvEulvkIp6GQ6S1/TdAJIG4nKa9XNObos=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UU43cvTmE1lqx+/ula8mBnoWM+Rng/GOyo0rS6HF96vBkbudL83EP54WZEq/vw2pN
	 gUi04QOD64emHEFXBD9mMAbMO+VBYeAgs9/eGZyoW8+ycNqXD11ljP/oiHfGDvo0uK
	 hz7bWWWOgGFaTHQcVtlNWe7VJEpFUOs27AIfnnkymELZ4eDSGf4XlyubRwcJhkqmxU
	 gFf/xSGP/X9j8mzy7Q0/8G7WbK4JocS8/jtO+kCgdCD9UDYTyibqaGXew8MFXzvpdF
	 EB0c+7yGJ3BhKVmHBJxDcr4kB+TGkxLQ/2IDKhQKHgztbPzDK099Cgn5lnNjeNINt6
	 3p/HCz9d7odbA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:56 +0100
Subject: [PATCH v2 05/34] jfs: don't set SB_RDONLY after filesystem errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-5-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Karl Mehltretter <kmehltretter@gmail.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=10151; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jpCwIyV383uyAN1j45EGMVLzYH3R+yIi9RVXDVcMURE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztc7uSPuQMaq1yL3vnvs3/Ure5JK7/Z1TYvfnRTbc
 uette9+gY5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJpM5m+O+w7/eUTx48b545
 sVqcltFYUKClp+zpGGNtmeTstHuHrynD/9ojP0V61+7UM77P+Uo7tV/EuyRi6Z4z1a9Pfwou4lo
 ewQwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8936E40010
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a8zczmujf9fu7x57kcjgqizks893mp5u
X-HE-Tag: 1793290063-637930
X-HE-Meta: U2FsdGVkX1+3p6NiXf8WPvVjDYLPTZjS8dh1KZN6orNiChIONA49/OdVbFTTbdJ3616B2qQJ4794I+ckjYV2utlGMbgZqpSkFPlV9rftbG2KnAyg2sKJ+lZqxZnAyn3JNHrqjexlLKwkNwq3AgsGa3gqb4Rvx4nmzqPf5VgKvMN+ah7J1MJO/R6mScLd+OgDZ2WK5ILO9nSwQTx9DXSoR3Itar3j92Gou+G7SmVVghhiLtxjjvLcDu4/HKwCT84zvJjYkavFOwokFL6mmPpXIS7Ivo0A0zubaKfae82tObTAVX3I3YpuO/iupUMlzVFZHiyTb5YZkmbMy64NcAXKAZMDBTPVE4GdyLwxtp/JRkHA6aoeGAIqEjvf0jvltyPZOwgtuUA+Ql9yLB2FzGZPY6XaudvOB7KGByJSN3f6Wcw/cZoxX6bnKuuw83g4739Ccr46NcFqbOOhuyfrCJj4vu3myb1IaekmwvaW/NfJJmGdMgrAA/xbpREUlw9W4XyVGOwa/9yq6ZclRx1r1XVuQJ1fEci+VwR+7yO1RwzwOUqmdsjPzGoaYegoQNZUNc7/bmdpRkGjjOpVwz+FnFUgmhVmDCShi81pBYuW4GHq8ZqNeXcRpjie89IGot3Phhs+4B4sFh7QgNgY//qYiFvXNZ7wlUAD3+k0qlx4xdpTUF1V1hVgxSRz6Lb+TY6fLABuPRAHf3jVBVfUmxBSG3z1HfBOpOB98Z7JjrRSOOlt9SWq2gn+cIkaTSRDtaEEAovBi7ye6XuqkyD94N2pIvDVdnEsjWczvVb4jhicK73wg42AFKYFnCTi5wUmaB9L2PrJEzRADOZT+o7tHPdke1FYPtkjtW5x5cUIZ+uX4iH76yv6tBlNssGV9jLWALCxxx5JRJOQzauasMO08CYFsSMi/kLYxjtuzBsqsx5UzTea2F1rJckIlkV73uuvZCHob6ovE2xjr7JtetCxwda6n+W
 V1LI6fgr
 LTj7RxLU6pC7jQf33zzDJEGHKtzaZzzchmNqnr2M2FjczJQsPQ8PxA9z3Rg8FF3ikGESPMGAmU4xZFb0NOBTguTarWnY/bgltHVErJb5RV/7b78YH+NSmW1AJtoitwLAkhHzCP5KJ1Szpk4nRXUa1Rgyxo/EUiWJ7kahA2RWRn/HKymvC5LaJnivkFQj83lK6p0Irg212NLWXW19GOmTnpKTadeX9ilZlZCHk/GEbA/JAHvVkjvPe706S+W52l71Ibe+53/UAfN8a7lkFsC786U+Ry/0gnEOeIaLD6M7llF2QJOpt0OevD6fbj8uRPDvKCpDlTvEraUYCp+CiRBE91YYzyR0nKjRrUkV5U18EocnJDRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With errors=remount-ro, the jfs default, jfs_handle_error() sets
SB_RDONLY from whatever context hit the error and without holding
s_umount. If that happens while the filesystem is frozen thaw_super()
skips jfs_unfreeze() and leaves the s_writers rwsems locked. Writers
hang and umount shuts the log down a second time and crashes.

So call sb_set_emergency_ro() instead and let the VFS refuse
modifications. jfs_unfreeze() used sb_rdonly() to tell whether
jfs_freeze() shut the log down. Track that in JFS_FLAGS_LOG_SHUTDOWN
instead so thaw undoes exactly what freeze did.

jfs refuses inode and block allocation and the xattr and ACL setters
itself, before txBegin() because failing txCommit() with tlocks held
trips an assert. Allocations that were under way when the error hit
leave anonymous tlocks behind and jfs_evict_inode() BUG()s if they're
never committed. So jfs_dirty_inode() still queues commits for those
inodes and extRecord() marks the inode dirty like extAlloc() does.
That's also why a remount to read-only still syncs.

While at it give slow symlinks jfs_symlink_inode_operations like
jfs_symlink() does so a chown doesn't skip dquot_transfer().

A remount to read-write fails until umount and writes through file
descriptors opened before the error fail with EROFS.

Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/acl.c        |  3 +++
 fs/jfs/inode.c      |  6 +++++-
 fs/jfs/ioctl.c      |  4 ++++
 fs/jfs/jfs_dtree.c  |  3 ++-
 fs/jfs/jfs_extent.c | 10 ++++++++++
 fs/jfs/jfs_incore.h |  6 ++++++
 fs/jfs/jfs_inode.c  |  3 +++
 fs/jfs/super.c      | 35 +++++++++++++++++++++++++++++++----
 fs/jfs/xattr.c      |  3 +++
 9 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/fs/jfs/acl.c b/fs/jfs/acl.c
index 6e0a7feb6c80..ab4c07db7b4a 100644
--- a/fs/jfs/acl.c
+++ b/fs/jfs/acl.c
@@ -98,6 +98,9 @@ int jfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	umode_t mode = inode->i_mode;
 
+	if (sb_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	tid = txBegin(inode->i_sb, 0);
 	mutex_lock(&JFS_IP(inode)->commit_mutex);
 	if (type == ACL_TYPE_ACCESS && acl) {
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index c7914dbc91ed..8ee227006d2f 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -47,7 +47,7 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_fop = &jfs_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
 		if (inode->i_size >= IDATASIZE) {
-			inode->i_op = &page_symlink_inode_operations;
+			inode->i_op = &jfs_symlink_inode_operations;
 			inode_nohighmem(inode);
 			inode->i_mapping->a_ops = &jfs_aops;
 		} else {
@@ -187,6 +187,10 @@ void jfs_dirty_inode(struct inode *inode, int flags)
 {
 	static int noisy = 5;
 
+	/* After an error only allocations under way still get committed. */
+	if (sb_emergency_ro(inode->i_sb) && !READ_ONCE(JFS_IP(inode)->atlhead))
+		return;
+
 	if (isReadOnly(inode)) {
 		if (!special_file(inode->i_mode) && noisy) {
 			/* kernel allows writes to devices on read-only
diff --git a/fs/jfs/ioctl.c b/fs/jfs/ioctl.c
index 27d39cddaca6..df38ab15e332 100644
--- a/fs/jfs/ioctl.c
+++ b/fs/jfs/ioctl.c
@@ -116,6 +116,10 @@ long jfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
+		/* Don't trust the block map after an error. */
+		if (sb_emergency_ro(sb))
+			return -EROFS;
+
 		if (!bdev_max_discard_sectors(sb->s_bdev)) {
 			jfs_warn("FITRIM not supported on device");
 			return -EOPNOTSUPP;
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 8ce6e4458cc2..330d291df12a 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2935,7 +2935,8 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 				if ((jfs_dirent->position < 2) ||
 				    (jfs_dirent->position >=
 				     JFS_IP(ip)->next_index)) {
-					if (!page_fixed && !isReadOnly(ip)) {
+					if (!page_fixed && !isReadOnly(ip) &&
+					    !sb_emergency_ro(ip->i_sb)) {
 						fix_page = 1;
 						/*
 						 * setting overflow and setting
diff --git a/fs/jfs/jfs_extent.c b/fs/jfs/jfs_extent.c
index 46529bcc8297..ba55e0bbecd2 100644
--- a/fs/jfs/jfs_extent.c
+++ b/fs/jfs/jfs_extent.c
@@ -74,6 +74,9 @@ extAlloc(struct inode *ip, s64 xlen, s64 pno, xad_t * xp, bool abnr)
 	int rc;
 	int xflag;
 
+	if (sb_emergency_ro(ip->i_sb))
+		return -EROFS;
+
 	if (isReadOnly(ip)) {
 		jfs_error(ip->i_sb, "read-only filesystem\n");
 		return -EIO;
@@ -258,6 +261,9 @@ int extRecord(struct inode *ip, xad_t * xp)
 {
 	int rc;
 
+	if (sb_emergency_ro(ip->i_sb))
+		return -EROFS;
+
 	if (isReadOnly(ip)) {
 		jfs_error(ip->i_sb, "read-only filesystem\n");
 		return -EIO;
@@ -270,6 +276,10 @@ int extRecord(struct inode *ip, xad_t * xp)
 	/* update the extent */
 	rc = xtUpdate(0, ip, xp);
 
+	/* get the anonymous tlocks committed, like extAlloc() does */
+	if (!rc)
+		mark_inode_dirty(ip);
+
 	mutex_unlock(&JFS_IP(ip)->commit_mutex);
 	return rc;
 }
diff --git a/fs/jfs/jfs_incore.h b/fs/jfs/jfs_incore.h
index 5aaafedb8fbc..b8d76415fae7 100644
--- a/fs/jfs/jfs_incore.h
+++ b/fs/jfs/jfs_incore.h
@@ -192,6 +192,7 @@ struct jfs_sb_info {
 	struct inode *direct_inode;	/* metadata inode */
 	uint		state;		/* mount/recovery state	*/
 	unsigned long	flag;		/* mount time flags */
+	unsigned long	jfs_flags;	/* runtime state, JFS_FLAGS_* */
 	uint		p_state;	/* state prior to going no integrity */
 	kuid_t		uid;		/* uid to override on-disk uid */
 	kgid_t		gid;		/* gid to override on-disk gid */
@@ -202,6 +203,11 @@ struct jfs_sb_info {
 /* jfs_sb_info commit_state */
 #define IN_LAZYCOMMIT 1
 
+/* jfs_sb_info jfs_flags bits */
+enum {
+	JFS_FLAGS_LOG_SHUTDOWN,	/* jfs_freeze() shut the log down */
+};
+
 static inline struct jfs_inode_info *JFS_IP(struct inode *inode)
 {
 	return container_of(inode, struct jfs_inode_info, vfs_inode);
diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index f10f295d1502..10e70b5a9c6f 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -45,6 +45,9 @@ struct inode *ialloc(struct inode *parent, umode_t mode)
 	struct jfs_inode_info *jfs_inode;
 	int rc;
 
+	if (sb_emergency_ro(sb))
+		return ERR_PTR(-EROFS);
+
 	inode = new_inode(sb);
 	if (!inode) {
 		jfs_warn("ialloc: new_inode returned NULL!");
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 8180d83d33fe..bbaba14821e6 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -63,7 +63,7 @@ static void jfs_handle_error(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 
-	if (sb_rdonly(sb))
+	if (sb_rdonly(sb) || sb_emergency_ro(sb))
 		return;
 
 	updateSuper(sb, FM_DIRTY);
@@ -74,7 +74,8 @@ static void jfs_handle_error(struct super_block *sb)
 	else if (sbi->flag & JFS_ERR_REMOUNT_RO) {
 		jfs_err("ERROR: (device %s): remounting filesystem as read-only",
 			sb->s_id);
-		sb->s_flags |= SB_RDONLY;
+		/* SB_RDONLY needs s_umount, see sb_set_emergency_ro(). */
+		sb_set_emergency_ro(sb);
 	}
 
 	/* nothing is done for continue beyond marking the superblock dirty */
@@ -367,6 +368,11 @@ static int jfs_reconfigure(struct fs_context *fc)
 	int flag = ctx->flag;
 	int ret;
 
+	/* Don't resize based on a block map we don't trust after an error. */
+	if (ctx->resize && sb_emergency_ro(sb))
+		return -EROFS;
+
+	/* After an error this only commits what was queued before it. */
 	sync_filesystem(sb);
 
 	/* Transfer results of parsing to the sbi */
@@ -415,6 +421,9 @@ static int jfs_reconfigure(struct fs_context *fc)
 		return ret;
 	}
 	if (!sb_rdonly(sb) && readonly) {
+		/* After an error nothing may be written, umount closes the log. */
+		if (sb_emergency_ro(sb))
+			return 0;
 		rc = dquot_suspend(sb, -1);
 		if (rc < 0)
 			return rc;
@@ -587,6 +596,15 @@ static int jfs_freeze(struct super_block *sb)
 	int rc = 0;
 
 	if (!sb_rdonly(sb)) {
+		/*
+		 * After an error leave the log open and the superblock alone.
+		 * Waiting for everything to be written home needs a quiesced
+		 * log, jfs_flush_journal() BUG()s otherwise.
+		 */
+		if (sb_emergency_ro(sb)) {
+			jfs_flush_journal(log, 1);
+			return 0;
+		}
 		txQuiesce(sb);
 		rc = lmLogShutdown(log);
 		if (rc) {
@@ -597,6 +615,7 @@ static int jfs_freeze(struct super_block *sb)
 
 			return rc;
 		}
+		set_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags);
 		rc = updateSuper(sb, FM_CLEAN);
 		if (rc) {
 			jfs_err("jfs_freeze: updateSuper failed");
@@ -616,15 +635,19 @@ static int jfs_unfreeze(struct super_block *sb)
 	struct jfs_log *log = sbi->log;
 	int rc = 0;
 
-	if (!sb_rdonly(sb)) {
+	/* Undo what jfs_freeze() did, also if an error happened meanwhile. */
+	if (test_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags)) {
 		rc = updateSuper(sb, FM_MOUNT);
 		if (rc) {
 			jfs_error(sb, "updateSuper failed\n");
 			goto out;
 		}
 		rc = lmLogInit(log);
-		if (rc)
+		if (rc) {
 			jfs_error(sb, "lmLogInit failed\n");
+			goto out;
+		}
+		clear_bit(JFS_FLAGS_LOG_SHUTDOWN, &sbi->jfs_flags);
 out:
 		txResume(sb);
 	}
@@ -640,6 +663,10 @@ static int jfs_sync_fs(struct super_block *sb, int wait)
 {
 	struct jfs_log *log = JFS_SBI(sb)->log;
 
+	/* After an error only freeze and umount write out the log. */
+	if (sb_emergency_ro(sb))
+		return 0;
+
 	/* log == NULL indicates read-only mount */
 	if (log) {
 		/*
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index dcc4a69d44fe..c3216a34fc66 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -936,6 +936,9 @@ static int __jfs_xattr_set(struct inode *inode, const char *name,
 	tid_t tid;
 	int rc;
 
+	if (sb_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	tid = txBegin(inode->i_sb, 0);
 	mutex_lock(&ji->commit_mutex);
 	rc = __jfs_setxattr(tid, inode, name, value, size, flags);

-- 
2.53.0


