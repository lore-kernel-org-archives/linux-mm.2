Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD685606A8AF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aKP381w+
Received: by kanga.kvack.org (Postfix)
	id B01C26B06CA; Fri, 13 Nov 2026 07:00:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9C96B06CC; Fri, 13 Nov 2026 07:00:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F0096B06CD; Fri, 13 Nov 2026 07:00:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F8EA6B06CA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:00:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 094BD1C335A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:35 +0000 (UTC)
X-FDA: 85429953630.29.C61F9D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2AE7DC000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aKP381w+;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571233;
	b=217BLfeRRbmaB1nN9Xj122MS9n9LB0o9xOiwbSMsXbiVCoZYhB1trm/fvIgdQPXYYgaT3y
	1F4W5WER1q3NoRE3JBAp4jkD/PQOHgQ8vipOkr7dJoHGkZq0SU94bdrslXZAf6Dvo0ru4a
	pj4eS0uz9nruFGmZWeT4x36VuxKxWkQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aKP381w+;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oqh8CIFVwGBHK8clrACgtNCviF+uFx6j/x8wryZ5Iac=;
	b=wjeMZPVoeCxM/WYQd63lc9SN935igUFJFBSd0Wxqm8eT07bNDRF3n54ASyOH7iu19eTXo9
	Kn5ubUMpo3yh7/rbqB6wHbX/eqb7Wj1i4WIxqPIUJvZDUhcprv4mYx1Ra7cP64qBh8MvNv
	gOEfXGphOfmlhNNsxxv4lskmHHL2lYU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BE06421F3;
	Fri, 13 Nov 2026 12:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E6E1F000C6;
	Fri, 13 Nov 2026 12:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571232;
	bh=Oqh8CIFVwGBHK8clrACgtNCviF+uFx6j/x8wryZ5Iac=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aKP381w+4eTMLnFMK2YV2I2xii3UpqGqu0k3wyBeoUakLZDHZ3/0dVhQAD12uofah
	 3nV5XzunXf9GQTkzWYtSUYx1YIxsZ3b6ZC1Ecmmq+Oi3MGn44jy63NJXPHY1r3syR9
	 LdYwNE52Uajn1/jD8qedtUz57/62jgl9BsN/F26nOL1bXLWxAzWurRs/AuZyFNqcjn
	 Fd6anE7bdiWIEpfFnWrzPPt+6y/sT7tML19MUTG7WCqE+0uGQYEB7McDlfa8cVW3aC
	 roiHKaOfA8V3MNfg4YPwpSoXgBr7MCrxaAJ0nsYzggcFG5tZThZNT1XrHP0JIh1I3e
	 Tl3vJYUf/j5hw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:01 +0100
Subject: [PATCH v3 05/33] fs: add a generic emergency read-only state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-5-0be92bb73709@kernel.org>
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
 Jan Kara <jack@suse.cz>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=20172; i=brauner@kernel.org;
 h=from:subject:message-id; bh=g6FfAfeu7o13DYhSSLPpeAPq4KFIrqCa4AjywOurf+I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+z2/0pA7TlHuuZTJzy1aajFljoHWjGdOMJtJH1p+b
 3YWqzNvRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES232NkWPh482Grqx2hfKEH
 zp9x3NDDdP5LZU3YtkWMx5oPTPdqtmf4n+1VuO2Uqwrz5fbbVlG8MgqS1377TLyf9MR8563besq
 dXAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: dpw345xrecd1uoh6dwt1njwtak9xua6f
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2AE7DC000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571233-488854
X-HE-Meta: U2FsdGVkX188j22Y50nhQzKkaPM8GzxPpz4dHPo52Dtj/f2yNXdrG/BaWwwf4/bH1a7IEAng2egsWeHHoMn5brtKlGx8XBVhGjkudMN3fCVRb3Q49QUBhMdQ7++w4kHTP6aYPW31Kphrj06POgH86MbQ7lvPFjaaHYvm3mnInru12y1Ifj1JrKL3vFRmMIU4fHE+3l1G+iKcUd1UkgYGzpVySlk6C0YBh5YCKpLUlz7y9PV813qVs+PMrw4DBT/Y+D120jlHNjxjXKduVNKNSJbOuHeOY6nFe0ILDkH7hKUq46sSGhBbyAJvPdH7Q/9FJpKtw5EBuepF9RxKl5EAG3vbJ5AKSntsI37elTAARvocTurnMgD4oHFGOJT9wdlR7Exv52MbBwxqmoBugsKuvJEEyfKEUPqam8/7yfKvgS4LKCE3Js2BglehW+q58d2WbX7wHIzr1PVhsaHf1R+rLJDn3HBEGd+YSORupbFUOPlNARPiFrF1i/+MlKinEBUS4+0ut80R/9acC3zvHhLRsS8L/hJNzHYytzip2UeCJzFD/nvjgXAGZkf8h/Y55L9X/Mzz0bHIjyIvrW5G463u3RT07YEwhRcmTTlBUuVS4shHMYAIc77hyCTUwoNiHxzaqFr45G+9xfRfa+lmjZuYUTZcRnfR9jjQkAFJLYxZv/jI58UQ7+yyonCE48sWphqHDSHvpJ7F++5TKIUZVZhZxvIHyTFHnDjMn4jqQPjqPdrteSGnUuZGHgCvY6OgxBdvEGRHnZzojnq1WXgd67jEZnl/d9tc7rsLv2v1LpSSToqx1eycQX4wkfPVTcSs04JdiX/hU0MbsSwUwK4WsDWUA28Y++6/TsLEdEpSq68Hf+EqFMNZqYuGj9s54svzS+RjVT3wQvYv+bYfW+l6il1RYjxJ/xxrjXavFIbX7N63wALVAsj9vDcRWFfScNUNywwn12gQAFyHsQd1Q2UZ8q9
 StVjkwYc
 DMu20EBK5azm2vlZo2qbuxJ6FgJutv4Ztwaziu6Q37M3mNM0V40r0tB1dZfTAtM0mq5jnlH8KnjVPb5mFObrnaC8nzxBq4cyU/zbwIlHaYRqNxJDNcM4VJ64LWtZgtQZqZZOBuwveN1/fYBOP2nsRiokF181X8ZV5qu5Jpejaabskd0y1WSvpz4XpeGC/NdyJSU5llGp2mWrgnClcRXzHTgG2/+D2zFE4HHPCtKOETKHsc+5dVG1Fwd+45t9pwfPwBpPbx2falQkjU/3WBrw4NoHZvqudVT7ooBcV
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

- __mnt_is_readonly() and sb_permission(), so everything that takes
  write access through mnt_want_write(), mnt_want_write_file() or
  mnt_get_write_access()
- notify_change(), rw_verify_area(), remap_verify_area(),
  vfs_fallocate(), vfs_fsync_range() and do_page_mkwrite() for files
  opened before the error
- reconfigure_super() going read-write
- the dquot code and quotactl(2)
- sync_filesystem() and the per-superblock passes of sync(2)

sb_rdonly_any() is true for a read-only mount and for the emergency
state so nobody has to open-code the pair.

So umount and the ->reconfigure() implementations that sync first don't
write such a superblock anymore either. syncfs(2) and Q_SYNC fail with
EROFS so userspace learns that nothing was written. Jan suggested that
(cf. [2]).

freeze_super() refuses a new freeze with EROFS. Nothing is synced
anymore so the flusher would keep writing to the frozen filesystem.
Joining a freeze that's already in effect still works and thaw_super()
is unchanged so an error while frozen is undone cleanly. FIFREEZE and dm
suspend with lockfs fail on an errored filesystem now, like they already
did for ext4.

/proc/mounts, statmount() and statfs() report the superblock as
read-only. "emergency_ro" isn't shown as a mount option because remount
helpers pass the shown options back.

The filesystem still has to refuse what doesn't go through the VFS: its
allocators, its journal and deleting unlinked inodes. Writeback isn't
stopped. The flusher, sync_bdevs() in sync(2) and sync_blockdev() in
kill_block_super() keep writing, so the filesystem decides what its
writeback still writes. Without a journal refusing only part of it
leaves the disk inconsistent. ext4 refuses data writeback in that state,
jfs commits the allocations writeback hasn't committed yet. The VFS
can't decide that.

[1]: https://lore.kernel.org/r/my2k7257m265fp5ad77n5hfndl23i56gsog3jwnsyocp3yxbnj@aphfqdiej2hs
[2]: https://lore.kernel.org/r/5qefa4mracb3x2z4vsdejmkyyfrhdcrixmmnooz4rzwcdfoejm@mqkvixj6afwp

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/porting.rst | 20 ++++++++++++++++++++
 fs/attr.c                             |  4 ++++
 fs/namei.c                            |  3 ++-
 fs/namespace.c                        |  5 ++++-
 fs/open.c                             |  4 ++++
 fs/proc_namespace.c                   |  2 +-
 fs/quota/dquot.c                      | 27 +++++++++++++++++++++------
 fs/quota/quota.c                      | 13 +++++++++++++
 fs/read_write.c                       |  5 +++++
 fs/remap_range.c                      |  4 ++++
 fs/statfs.c                           |  9 +++++++--
 fs/super.c                            | 17 +++++++++++++++++
 fs/sync.c                             | 14 +++++++++++---
 include/linux/fs/super.h              | 23 +++++++++++++++++++++++
 include/linux/fs/super_types.h        | 19 +++++++++++++++++++
 mm/memory.c                           |  6 ++++++
 16 files changed, 161 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index c38f5df755bb5..6e48015981d06 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1422,3 +1422,23 @@ helpers take a const struct mnt_idmap *. mnt_idmap() and file_mnt_idmap()
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
+modifications with EROFS, refuses a remount to read-write and a new freeze,
+doesn't sync the superblock anymore and shows it as read-only. The
+filesystem still has to refuse what reaches it without passing through the
+VFS: its own allocation and journal paths and the deletion of unlinked
+inodes in ->evict_inode(). Test sb_emergency_ro() for that, or
+sb_rdonly_any() which is also true for a read-only mount. Writeback isn't
+stopped. The flusher keeps calling ->writepages() and ->write_inode() and
+the block device is still flushed, so the filesystem decides what its
+writeback still writes. Without a journal refusing only the inodes while
+the data and the bitmaps go out loses data. A remount to read-only must not
+mark the filesystem clean in that state.
diff --git a/fs/attr.c b/fs/attr.c
index 9706d370f34af..cb1205f345e76 100644
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
index 96c65940391a5..03e7cdc9c3b2f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -607,7 +607,8 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
 		umode_t mode = inode->i_mode;
 
 		/* Nobody gets write access to a read-only fs. */
-		if (sb_rdonly(sb) && (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
+		if (sb_rdonly_any(sb) &&
+		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
 			return -EROFS;
 	}
 	return 0;
diff --git a/fs/namespace.c b/fs/namespace.c
index 9f6ec35c7b9cd..55fa09818ef90 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -396,7 +396,7 @@ static struct mount *alloc_vfsmnt(const char *name)
  */
 bool __mnt_is_readonly(const struct vfsmount *mnt)
 {
-	return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly(mnt->mnt_sb);
+	return (mnt->mnt_flags & MNT_READONLY) || sb_rdonly_any(mnt->mnt_sb);
 }
 EXPORT_SYMBOL_GPL(__mnt_is_readonly);
 
@@ -5492,6 +5492,9 @@ static void statmount_sb_basic(struct kstatmount *s)
 	s->sm.sb_dev_minor = MINOR(sb->s_dev);
 	s->sm.sb_magic = sb->s_magic;
 	s->sm.sb_flags = sb->s_flags & (SB_RDONLY|SB_SYNCHRONOUS|SB_DIRSYNC|SB_LAZYTIME);
+	/* An error made the filesystem read-only, SB_RDONLY stays clear. */
+	if (sb_emergency_ro(sb))
+		s->sm.sb_flags |= SB_RDONLY;
 }
 
 static void statmount_mnt_parent(struct kstatmount *s, const struct mount *m)
diff --git a/fs/open.c b/fs/open.c
index e43f02ff64acb..ba913e3827325 100644
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
index 036356c0a55bb..cb111f1ecf2c0 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -179,7 +179,7 @@ static int show_mountinfo(struct seq_file *m, struct vfsmount *mnt)
 	} else {
 		mangle(m, r->mnt_devname);
 	}
-	seq_puts(m, sb_rdonly(sb) ? " ro" : " rw");
+	seq_puts(m, sb_rdonly_any(sb) ? " ro" : " rw");
 	err = show_sb_opts(m, sb);
 	if (err)
 		goto out;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 3ad19d7e472f6..75118a8359495 100644
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
@@ -769,6 +777,10 @@ int dquot_quota_sync(struct super_block *sb, int type)
 	int cnt;
 	int ret;
 
+	/* An error made the filesystem read-only. */
+	if (sb_emergency_ro(sb))
+		return -EROFS;
+
 	ret = dquot_writeback_dquots(sb, type);
 	if (ret)
 		return ret;
@@ -2148,6 +2160,9 @@ int dquot_commit_info(struct super_block *sb, int type)
 {
 	struct quota_info *dqopt = sb_dqopt(sb);
 
+	/* An error made the filesystem read-only. */
+	if (sb_emergency_ro(sb))
+		return -EROFS;
 	return dqopt->ops[type]->write_file_info(sb, type);
 }
 EXPORT_SYMBOL(dquot_commit_info);
@@ -2271,7 +2286,7 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
 		 * Now all dquots should be invalidated, all writes done so we
 		 * should be only users of the info. No locks needed.
 		 */
-		if (info_dirty(&dqopt->info[cnt]))
+		if (info_dirty(&dqopt->info[cnt]) && !sb_emergency_ro(sb))
 			sb->dq_op->write_info(sb, cnt);
 		if (dqopt->ops[cnt]->free_file_info)
 			dqopt->ops[cnt]->free_file_info(sb, cnt);
@@ -2288,7 +2303,7 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
 
 	/* Sync the superblock so that buffers with quota data are written to
 	 * disk (and so userspace sees correct data afterwards). */
-	if (sb->s_op->sync_fs)
+	if (sb->s_op->sync_fs && !sb_emergency_ro(sb))
 		sb->s_op->sync_fs(sb, 1);
 	sync_blockdev(sb->s_bdev);
 	/* Now the quota files are just ordinary files and we can set the
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 33bacd7075800..b488fb1f9cc44 100644
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
index 4da846a2bf17b..1ce4124392119 100644
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
index 6eb7d845de5d4..22639af7b6aaa 100644
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
index 377bcef7a5611..05a90d5a3310f 100644
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
index a1dc4de1b6573..edc767d816597 100644
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
@@ -2287,6 +2291,16 @@ int freeze_super(struct super_block *sb, enum freeze_holder who, const void *fre
 		goto retry;
 	}
 
+	/*
+	 * After an error nothing gets synced anymore while the flusher may
+	 * still write, so a new freeze can't give a stable filesystem. Joining
+	 * a freeze that is already in effect above is fine.
+	 */
+	if (sb_emergency_ro(sb)) {
+		deactivate_locked_super(sb);
+		return -EROFS;
+	}
+
 	if (sb_rdonly(sb)) {
 		/* Nothing to do really... */
 		WARN_ON_ONCE(freeze_inc(sb, who) > 1);
@@ -2309,6 +2323,9 @@ int freeze_super(struct super_block *sb, enum freeze_holder who, const void *fre
 
 	/* All writers are done so after syncing there won't be dirty data */
 	ret = sync_filesystem(sb);
+	/* An error while we waited for the writers means nothing was synced. */
+	if (!ret && sb_emergency_ro(sb))
+		ret = -EROFS;
 	if (ret) {
 		sb->s_writers.frozen = SB_UNFROZEN;
 		sb_freeze_unlock(sb, SB_FREEZE_PAGEFAULT);
diff --git a/fs/sync.c b/fs/sync.c
index 4a84dd837b863..40ffe57360656 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -39,8 +39,9 @@ int sync_filesystem(struct super_block *sb)
 
 	/*
 	 * No point in syncing out anything if the filesystem is read-only.
+	 * After an error made it read-only nothing is pushed out anymore.
 	 */
-	if (sb_rdonly(sb))
+	if (sb_rdonly_any(sb))
 		return 0;
 
 	/*
@@ -73,13 +74,13 @@ EXPORT_SYMBOL(sync_filesystem);
 
 static void sync_inodes_one_sb(struct super_block *sb, void *arg)
 {
-	if (!sb_rdonly(sb))
+	if (!sb_rdonly_any(sb))
 		sync_inodes_sb(sb);
 }
 
 static void sync_fs_one_sb(struct super_block *sb, void *arg)
 {
-	if (!sb_rdonly(sb) && !(sb->s_iflags & SB_I_SKIP_SYNC) &&
+	if (!sb_rdonly_any(sb) && !(sb->s_iflags & SB_I_SKIP_SYNC) &&
 	    sb->s_op->sync_fs)
 		sb->s_op->sync_fs(sb, *(int *)arg);
 }
@@ -157,6 +158,9 @@ SYSCALL_DEFINE1(syncfs, int, fd)
 
 	down_read(&sb->s_umount);
 	ret = sync_filesystem(sb);
+	/* An error made the filesystem read-only. */
+	if (!ret && sb_emergency_ro(sb))
+		ret = -EROFS;
 	up_read(&sb->s_umount);
 
 	ret2 = errseq_check_and_advance(&sb->s_wb_err, &fd_file(f)->f_sb_err);
@@ -181,6 +185,10 @@ int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 
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
index 733d439f01edb..1f063769ff5c9 100644
--- a/include/linux/fs/super.h
+++ b/include/linux/fs/super.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_FS_SUPER_H
 #define _LINUX_FS_SUPER_H
 
+#include <linux/bitops.h>
 #include <linux/fs/super_types.h>
 #include <linux/unicode.h>
 
@@ -187,6 +188,28 @@ static inline bool sb_rdonly(const struct super_block *sb)
 	return sb->s_flags & SB_RDONLY;
 }
 
+/*
+ * An error made the filesystem read-only. Check this wherever sb_rdonly()
+ * gates a write but never where it describes the mount, e.g. in the read-only
+ * shortcuts of freeze_super() and thaw_super(). It can get set while frozen.
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
+/* A read-only mount or the emergency state. */
+static inline bool sb_rdonly_any(const struct super_block *sb)
+{
+	return sb_rdonly(sb) || sb_emergency_ro(sb);
+}
+
 static inline bool sb_is_blkdev_sb(struct super_block *sb)
 {
 	return IS_ENABLED(CONFIG_BLOCK) && sb == blockdev_superblock;
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index ecd96aeb1cee7..52b13cf864d58 100644
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
+ * sb->s_state bit numbers. Set with set_bit() from any context without
+ * s_umount and never cleared, so they can be tested without any ordering
+ * against the setter. Unlike SB_RDONLY which only changes under s_umount in
+ * reconfigure_super().
+ */
+enum sb_state_bits {
+	/*
+	 * An error made the filesystem read-only. The VFS refuses modifications
+	 * with EROFS, a remount to read-write and a new freeze until umount and
+	 * doesn't sync the superblock anymore. The filesystem still has to
+	 * refuse what doesn't pass through the VFS, see sb_emergency_ro().
+	 */
+	SB_STATE_EMERGENCY_RO = 0,
+};
+
 #endif /* _LINUX_FS_SUPER_TYPES_H */
diff --git a/mm/memory.c b/mm/memory.c
index 0fb676dd2bd63..96ab2096abfc9 100644
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


