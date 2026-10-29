Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BED606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JQ1QbLtc
Received: by kanga.kvack.org (Postfix)
	id 4EB2D6B05BE; Thu, 29 Oct 2026 12:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4231C6B05BF; Thu, 29 Oct 2026 12:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EDD06B05C0; Thu, 29 Oct 2026 12:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08D4B6B05BE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:07:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95EAE80470
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:07:36 +0000 (UTC)
X-FDA: 85376144112.15.8F58DDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C3D6A1C000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:07:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JQ1QbLtc;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9feQNBzIm3vUzxHz7cpGYpHOGPLRMQXLQfHNl7di0wE=;
	b=rWe2QjCImGu9dQmNUWDURi9sCTmS8lJUvpE6d/vwKsQk5B+FTTYZY1U3Qhl3XMAlY/OrVR
	QLqNrfyHijA8p3BXgUranA++zjhtrdnu0sNz6Qi6d3MTW/sEXGYnTou1NhZOkdgLEwDBzc
	aM3vxF1+hrB+XwncHbB4XE8Mgj1ia+Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JQ1QbLtc;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290054;
	b=1Q/NpiDNXR9fJZ0iXr05WWhSH0GCYvGhrgIMOVv0hRjiZAXFtYEnEws9GM5qH15aONnJc2
	2lT9zTalRz9DYhNYqXzGSGmTsydAjDML9/ClDwaKsOmyGXQkyoAVnPQL37j+rBjEIhYXv6
	GrWR+CXlvx5t4aVBQ2HoJiB13RWYDdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51F70600DA;
	Thu, 29 Oct 2026 16:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337D81F01816;
	Thu, 29 Oct 2026 16:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290054;
	bh=9feQNBzIm3vUzxHz7cpGYpHOGPLRMQXLQfHNl7di0wE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JQ1QbLtclJ5Mp95vmtg6jfht5eWEVEYKj3VmRTxRgjthDI8t+CIM+Mwgdwc9LRhNy
	 AXqSHTbUaBbvPYO8y39RIveaCzkVlTmfkBRPXHbRTBi5JeJisqlBp0UsdtXiEiQlnu
	 Yoc5KNsjIbrGa8TIA1gEWo1m2Ycj5IAPgbowOfWDFYCiL2p70T9FLeihJVMtkGYNf7
	 gcspNXTvzeOwY6VQyLNV0Q2FYjzcTHH9m5Cjnxnt3mTZV+AWSBEzUeQwf5YzU0womv
	 Kd+iiFBI+EXC4eWnLvhnMVkh9LmGsqKFtYxPeTufTym2qDZsYgpM5+D+XMR51uWFfS
	 zDk9UKqcGWczQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:54 +0100
Subject: [PATCH v2 03/34] fs: add a generic emergency read-only state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-3-2f44f64f0b66@kernel.org>
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
 Jan Kara <jack@suse.cz>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=16131; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HzZRrXtDryPZx5BkLgBkUM5zs9xMC4a+1DcuKEzxQiY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zte7cyNp9p4Jancdp24NPe2tfJ3pEGdCb//z1/n18
 0rsbWSkO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACai1MfI0LiLcSE/S/3PZ4Fs
 85XKon589Z609pwDW6QIxyMzueN6wYwMvUu3d3lyX/jaIK37rafUNEw58P7f1jOdtk4/jy78VXm
 DBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C3D6A1C000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: u1uqetmu638fdq915op4xzipsiwc4d9a
X-HE-Tag: 1793290054-607342
X-HE-Meta: U2FsdGVkX1+jH/pxenMG4z4YS+RYVinkt9MrKNmGKF4DjHyZkNNYh77zYyfWSq7qE52gyzf4HHyj+Z13WCrox9NB8pOZwmahl2ZnwsdXaRk+mUW73QhW77pUHridCSYA7i1f2c8COxk7mmn2uL8/sVNp50ubjgK+HLSLEhCfS1L5q7VADBKLjKrG4Vk9rxbLRBDnx0JLeq5/niS7e2iBe/gHVgbtBt4UwQNjU/RhPj3O6YOuiBEOqa6PI7+C32eCr97dp8Vo+pG+4TjMUcs6jc5vKaTunxFnE5FEfUv37pxbvRA0osrvVnv5BTSzOU14th6aIXqOeF5kdu5YLTE/2HgGhZpcWthI8FaEdA2nmiNDPzSo5gr2855V+bvxFW3NuGnRu1SsAgLx9GaMokMEhfIvzfdmRJnXQYc8bUeiMdPC6OsIXS3b5ppWnfFvD7VMrKIbHuT3EGKMZiGcuZ0/v6YZdtoZMRFwfzyYDS3vMvo6xqMXta7mN1oK+i/fPNFpi2Ac+18K4IibfzaLTp1Zi0pv0M0kR3UlozIeIloPBJemmkNU0cP1zI163v05qX8MqXAxPLbubwoznL+6y44pAHlr3uoJTwaQzxVB3Sf4e60lSvN6ttZRg7I3cORsWEhWnzLSUmo5rXvVrbZNTsztZRX+z8VLzi1rE8MyX2Sh3ymM0jH+3extL8AqkCN2xAqk8FqAosAXLqjZG6V+d+2OKH+HNui0i9URm2TRnVSaAmL9x8shKQovDlxsK0+O/gNba81jHHyheQ/wRGul26oGEIujwMzrXYRfPKn+6/v/31lrc4OWj4g6QTgWwHOjAwWMsg5d2DUj9rApIHsHOeFLCjPhy4+MlEoYBZcHhfn448okHRgx9EQSYiZtlY0YuQLP6Rz6IFIaZ3Bnp8ddhdxSgiWtF7rgLJqUuEG+TWmgRXxrANvSSIQGBKzeOxyoTLMlZfioUvuvsEa7rjOpjgM
 FGerADfJ
 eqeauU8m00cR8JdTDT3c58HzZ747va67ZvRoSL9nhEatvDlRDO/SF4GMcEBOIBcQUP6N0ChRi8SEEq6Xc/ZxvbUzV9DFAj2s7QB+agL0yGmeXO0ukIyD+FBrG33z4Zt89iN5ZVtuGm8l7vBZHvexoT87+YCYWEy5TBuNZqOS0dFbv2k7tjvKGad09PeN0PAKoUSUcWG9G2+T6jnR5Cvv+nlQU9IMiYipVg5Qp3l5cudyI9B0Us4WjvxjqIXicyxiFZPpGY5Mt1SIxszV3GBX6lpSLevie5TJX29UD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ext4 and f2fs don't set SB_RDONLY after errors anymore and refuse
modifications themselves. Doing that in all the other filesystems means
the same checks in ->open, ->setattr, ->fsync, the directory and quota
operations and ->reconfigure everywhere. Jan suggested a flag in the
superblock instead so the VFS can do it once (cf. [1]).

So add sb->s_state with SB_STATE_EMERGENCY_RO. It's only ever set and
never cleared and SB_RDONLY stays untouched. A filesystem calls
sb_set_emergency_ro() where it used to set SB_RDONLY and the VFS refuses
modifications wherever sb_rdonly() would:

- __mnt_is_readonly() and sb_permission()
- notify_change(), rw_verify_area(), remap_verify_area(),
  vfs_fallocate(), vfs_fsync_range() and do_page_mkwrite() for files
  opened before the error
- reconfigure_super() going read-write
- the dquot code and quotactl(2)

/proc/mounts, statmount() and statfs() report the superblock as
read-only. "emergency_ro" isn't shown as a mount option because remount
helpers pass the shown options back.

The filesystem still has to refuse what doesn't go through the VFS: its
allocators, its journal, deleting unlinked inodes and its own writeback.
ext4 refuses all writeback in that state but jfs has to commit the
allocations that were under way or evict BUG()s. The VFS can't decide
that.

[1]: https://lore.kernel.org/r/my2k7257m265fp5ad77n5hfndl23i56gsog3jwnsyocp3yxbnj@aphfqdiej2hs

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/porting.rst | 16 ++++++++++++++++
 fs/attr.c                             |  4 ++++
 fs/namei.c                            |  3 ++-
 fs/namespace.c                        |  6 +++++-
 fs/open.c                             |  4 ++++
 fs/proc_namespace.c                   |  2 +-
 fs/quota/dquot.c                      | 23 +++++++++++++++++------
 fs/quota/quota.c                      | 13 +++++++++++++
 fs/read_write.c                       |  5 +++++
 fs/remap_range.c                      |  4 ++++
 fs/statfs.c                           |  9 +++++++--
 fs/super.c                            |  4 ++++
 fs/sync.c                             |  4 ++++
 include/linux/fs/super.h              | 17 +++++++++++++++++
 include/linux/fs/super_types.h        | 19 +++++++++++++++++++
 mm/memory.c                           |  6 ++++++
 16 files changed, 128 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index c38f5df755bb..fc7161ee64df 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1422,3 +1422,19 @@ helpers take a const struct mnt_idmap *. mnt_idmap() and file_mnt_idmap()
 return one. The idmapping is immutable so nothing should have modified it
 anyway. References are taken and dropped via mnt_idmap_get() and
 mnt_idmap_put() as before, both accept a const pointer.
+
+---
+
+**recommended**
+
+Filesystems that set SB_RDONLY on the superblock after an error
+(errors=remount-ro) must not do that anymore. SB_RDONLY only changes under
+sb->s_umount through reconfigure_super() and freeze_super() and thaw_super()
+rely on that. Call sb_set_emergency_ro() instead. The VFS then refuses
+modifications with EROFS, refuses a remount to read-write and shows the
+superblock as read-only. The filesystem still has to refuse what
+reaches it without passing through the VFS: its own allocation and journal
+paths, the deletion of unlinked inodes in ->evict_inode() and its own
+writeback through ->write_inode(), ->writepages() and ->sync_fs(). Test
+sb_emergency_ro() for that. A remount to read-only must not write anything
+in that state either, in particular it must not mark the filesystem clean.
diff --git a/fs/attr.c b/fs/attr.c
index 9706d370f34a..cb1205f345e7 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -435,6 +435,10 @@ int notify_change(const struct mnt_idmap *idmap, struct dentry *dentry,
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
 
+	/* An error made the filesystem read-only. */
+	if (sb_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	error = may_setattr(idmap, inode, ia_valid);
 	if (error)
 		return error;
diff --git a/fs/namei.c b/fs/namei.c
index 96c65940391a..8ccb4be06390 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -607,7 +607,8 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
 		umode_t mode = inode->i_mode;
 
 		/* Nobody gets write access to a read-only fs. */
-		if (sb_rdonly(sb) && (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
+		if ((sb_rdonly(sb) || sb_emergency_ro(sb)) &&
+		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
 			return -EROFS;
 	}
 	return 0;
diff --git a/fs/namespace.c b/fs/namespace.c
index 9f6ec35c7b9c..512f012645e1 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -396,7 +396,8 @@ static struct mount *alloc_vfsmnt(const char *name)
  */
 bool __mnt_is_readonly(const struct vfsmount *mnt)
 {
-	return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly(mnt->mnt_sb);
+	return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly(mnt->mnt_sb) ||
+	       sb_emergency_ro(mnt->mnt_sb);
 }
 EXPORT_SYMBOL_GPL(__mnt_is_readonly);
 
@@ -5492,6 +5493,9 @@ static void statmount_sb_basic(struct kstatmount *s)
 	s->sm.sb_dev_minor = MINOR(sb->s_dev);
 	s->sm.sb_magic = sb->s_magic;
 	s->sm.sb_flags = sb->s_flags & (SB_RDONLY|SB_SYNCHRONOUS|SB_DIRSYNC|SB_LAZYTIME);
+	/* An error made the filesystem read-only, SB_RDONLY stays clear. */
+	if (sb_emergency_ro(sb))
+		s->sm.sb_flags |= SB_RDONLY;
 }
 
 static void statmount_mnt_parent(struct kstatmount *s, const struct mount *m)
diff --git a/fs/open.c b/fs/open.c
index e43f02ff64ac..ba913e382732 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -324,6 +324,10 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
 		return -ENODEV;
 
+	/* An error made the filesystem read-only. */
+	if (S_ISREG(inode->i_mode) && sb_emergency_ro(inode->i_sb))
+		return -EROFS;
+
 	/* Check for wraparound */
 	if (check_add_overflow(offset, len, &sum))
 		return -EFBIG;
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 036356c0a55b..fb81da47bb25 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -179,7 +179,7 @@ static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
 	} else {
 		mangle(m, r->mnt_devname);
 	}
-	seq_puts(m, sb_rdonly(sb) ? " ro" : " rw");
+	seq_puts(m, sb_rdonly(sb) || sb_emergency_ro(sb) ? " ro" : " rw");
 	err = show_sb_opts(m, sb);
 	if (err)
 		goto out;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 3ad19d7e472f..f469e6e18e4c 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -495,6 +495,11 @@ int dquot_acquire(struct dquot *dquot)
 	set_bit(DQ_READ_B, &dquot->dq_flags);
 	/* Instantiate dquot if needed */
 	if (!dquot_active(dquot) && !dquot->dq_off) {
+		/* An error made the filesystem read-only. */
+		if (sb_emergency_ro(dquot->dq_sb)) {
+			ret = -EROFS;
+			goto out_iolock;
+		}
 		ret = dqopt->ops[dquot->dq_id.type]->commit_dqblk(dquot);
 		/* Write the info if needed */
 		if (info_dirty(&dqopt->info[dquot->dq_id.type])) {
@@ -536,10 +541,12 @@ int dquot_commit(struct dquot *dquot)
 		goto out_lock;
 	/* Inactive dquot can be only if there was error during read/init
 	 * => we have better not writing it */
-	if (dquot_active(dquot))
-		ret = dqopt->ops[dquot->dq_id.type]->commit_dqblk(dquot);
-	else
+	if (!dquot_active(dquot))
 		ret = -EIO;
+	else if (sb_emergency_ro(dquot->dq_sb))
+		ret = -EROFS;
+	else
+		ret = dqopt->ops[dquot->dq_id.type]->commit_dqblk(dquot);
 out_lock:
 	memalloc_nofs_restore(memalloc);
 	mutex_unlock(&dquot->dq_lock);
@@ -561,7 +568,8 @@ int dquot_release(struct dquot *dquot)
 	/* Check whether we are not racing with some other dqget() */
 	if (dquot_is_busy(dquot))
 		goto out_dqlock;
-	if (dqopt->ops[dquot->dq_id.type]->release_dqblk) {
+	if (dqopt->ops[dquot->dq_id.type]->release_dqblk &&
+	    !sb_emergency_ro(dquot->dq_sb)) {
 		ret = dqopt->ops[dquot->dq_id.type]->release_dqblk(dquot);
 		/* Write the info */
 		if (info_dirty(&dqopt->info[dquot->dq_id.type])) {
@@ -2148,6 +2156,9 @@ int dquot_commit_info(struct super_block *sb, int type)
 {
 	struct quota_info *dqopt = sb_dqopt(sb);
 
+	/* An error made the filesystem read-only. */
+	if (sb_emergency_ro(sb))
+		return -EROFS;
 	return dqopt->ops[type]->write_file_info(sb, type);
 }
 EXPORT_SYMBOL(dquot_commit_info);
@@ -2271,7 +2282,7 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
 		 * Now all dquots should be invalidated, all writes done so we
 		 * should be only users of the info. No locks needed.
 		 */
-		if (info_dirty(&dqopt->info[cnt]))
+		if (info_dirty(&dqopt->info[cnt]) && !sb_emergency_ro(sb))
 			sb->dq_op->write_info(sb, cnt);
 		if (dqopt->ops[cnt]->free_file_info)
 			dqopt->ops[cnt]->free_file_info(sb, cnt);
@@ -2288,7 +2299,7 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
 
 	/* Sync the superblock so that buffers with quota data are written to
 	 * disk (and so userspace sees correct data afterwards). */
-	if (sb->s_op->sync_fs)
+	if (sb->s_op->sync_fs && !sb_emergency_ro(sb))
 		sb->s_op->sync_fs(sb, 1);
 	sync_blockdev(sb->s_bdev);
 	/* Now the quota files are just ordinary files and we can set the
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 33bacd707580..b488fb1f9cc4 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -783,6 +783,19 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 	if (ret < 0)
 		return ret;
 
+	/* An error made the filesystem read-only. */
+	if (sb_emergency_ro(sb)) {
+		switch (cmd) {
+		case Q_QUOTAON:
+		case Q_SETINFO:
+		case Q_SETQUOTA:
+		case Q_XQUOTAON:
+		case Q_XQUOTARM:
+		case Q_XSETQLIM:
+			return -EROFS;
+		}
+	}
+
 	switch (cmd) {
 	case Q_QUOTAON:
 		return quota_quotaon(sb, type, id, path);
diff --git a/fs/read_write.c b/fs/read_write.c
index 4da846a2bf17..1ce412439211 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -472,6 +472,11 @@ int rw_verify_area(int read_write, struct file *file, const loff_t *ppos, size_t
 		}
 	}
 
+	/* An error made the filesystem read-only. */
+	if (read_write == WRITE && S_ISREG(file_inode(file)->i_mode) &&
+	    sb_emergency_ro(file_inode(file)->i_sb))
+		return -EROFS;
+
 	ret = security_file_permission(file, mask);
 	if (ret)
 		return ret;
diff --git a/fs/remap_range.c b/fs/remap_range.c
index 6eb7d845de5d..22639af7b6aa 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -111,6 +111,10 @@ int remap_verify_area(struct file *file, loff_t pos, loff_t len, bool write)
 	if (unlikely(check_add_overflow(pos, len, &tmp)))
 		return -EINVAL;
 
+	/* An error made the filesystem read-only. */
+	if (write && sb_emergency_ro(file_inode(file)->i_sb))
+		return -EROFS;
+
 	ret = security_file_permission(file, mask);
 	if (ret)
 		return ret;
diff --git a/fs/statfs.c b/fs/statfs.c
index 377bcef7a561..05a90d5a3310 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -48,8 +48,13 @@ static int flags_by_sb(int s_flags)
 
 static int calculate_f_flags(struct vfsmount *mnt)
 {
-	return ST_VALID | flags_by_mnt(mnt->mnt_flags) |
-		flags_by_sb(mnt->mnt_sb->s_flags);
+	int flags = ST_VALID | flags_by_mnt(mnt->mnt_flags) |
+		    flags_by_sb(mnt->mnt_sb->s_flags);
+
+	/* An error made the filesystem read-only, SB_RDONLY stays clear. */
+	if (sb_emergency_ro(mnt->mnt_sb))
+		flags |= ST_RDONLY;
+	return flags;
 }
 
 static int statfs_by_dentry(struct dentry *dentry, struct kstatfs *buf)
diff --git a/fs/super.c b/fs/super.c
index a1dc4de1b657..0855c96b95b5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1091,6 +1091,10 @@ int reconfigure_super(struct fs_context *fc)
 		remount_ro = (fc->sb_flags & SB_RDONLY) && !sb_rdonly(sb);
 	}
 
+	/* An error made the filesystem read-only until it is unmounted. */
+	if (remount_rw && sb_emergency_ro(sb))
+		return -EROFS;
+
 	if (remount_ro) {
 		if (!hlist_empty(&sb->s_pins)) {
 			super_unlock_excl(sb);
diff --git a/fs/sync.c b/fs/sync.c
index 4a84dd837b86..da1b35bd4445 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -181,6 +181,10 @@ int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!file->f_op->fsync)
 		return -EINVAL;
+	/* Nothing is written back after an error, don't claim it is. */
+	if (!special_file(file_inode(file)->i_mode) &&
+	    sb_emergency_ro(file_inode(file)->i_sb))
+		return -EROFS;
 	if (!datasync)
 		sync_lazytime(inode);
 	return file->f_op->fsync(file, start, end, datasync);
diff --git a/include/linux/fs/super.h b/include/linux/fs/super.h
index 733d439f01ed..0fa6eaa93d44 100644
--- a/include/linux/fs/super.h
+++ b/include/linux/fs/super.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_FS_SUPER_H
 #define _LINUX_FS_SUPER_H
 
+#include <linux/bitops.h>
 #include <linux/fs/super_types.h>
 #include <linux/unicode.h>
 
@@ -187,6 +188,22 @@ static inline bool sb_rdonly(const struct super_block *sb)
 	return sb->s_flags & SB_RDONLY;
 }
 
+/*
+ * An error made the filesystem read-only. Check this wherever sb_rdonly()
+ * gates a write but never where it describes the mount, e.g. in freeze_super()
+ * and thaw_super(). It can get set while the superblock is frozen.
+ */
+static inline bool sb_emergency_ro(const struct super_block *sb)
+{
+	return test_bit(SB_STATE_EMERGENCY_RO, &sb->s_state);
+}
+
+/* True for the caller that set the state. */
+static inline bool sb_set_emergency_ro(struct super_block *sb)
+{
+	return !test_and_set_bit(SB_STATE_EMERGENCY_RO, &sb->s_state);
+}
+
 static inline bool sb_is_blkdev_sb(struct super_block *sb)
 {
 	return IS_ENABLED(CONFIG_BLOCK) && sb == blockdev_superblock;
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index ecd96aeb1cee..b444a03788f1 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -238,6 +238,9 @@ struct super_block {
 	/* Read-only state of the superblock is being changed */
 	int					s_readonly_remount;
 
+	/* SB_STATE_* bits, set with set_bit() and never cleared */
+	unsigned long				s_state;
+
 	/* per-sb errseq_t for reporting writeback errors via syncfs */
 	errseq_t s_wb_err;
 
@@ -353,4 +356,20 @@ struct super_block {
 #define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this superblock */
 #define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee data persistence on sync */
 
+/*
+ * sb->s_state bits. Set with set_bit() from any context without s_umount and
+ * never cleared, so they can be tested without any ordering against the
+ * setter. Unlike SB_RDONLY which only changes under s_umount in
+ * reconfigure_super().
+ */
+enum {
+	/*
+	 * An error made the filesystem read-only. The VFS refuses modifications
+	 * with EROFS and a remount to read-write until umount. The filesystem
+	 * still has to refuse what doesn't pass through the VFS, including its
+	 * own writeback, see sb_emergency_ro().
+	 */
+	SB_STATE_EMERGENCY_RO,
+};
+
 #endif /* _LINUX_FS_SUPER_TYPES_H */
diff --git a/mm/memory.c b/mm/memory.c
index 0fb676dd2bd6..96ab2096abfc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3876,6 +3876,12 @@ static vm_fault_t do_page_mkwrite(struct vm_fault *vmf, struct folio *folio)
 	    IS_SWAPFILE(vmf->vma->vm_file->f_mapping->host))
 		return VM_FAULT_SIGBUS;
 
+	/* An error made the filesystem read-only. */
+	if (vmf->vma->vm_file &&
+	    S_ISREG(file_inode(vmf->vma->vm_file)->i_mode) &&
+	    sb_emergency_ro(file_inode(vmf->vma->vm_file)->i_sb))
+		return VM_FAULT_SIGBUS;
+
 	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
 	/* Restore original flags so that caller is not surprised */
 	vmf->flags = old_flags;

-- 
2.53.0


