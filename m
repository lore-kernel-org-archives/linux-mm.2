Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C2360A3803
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BK4mBoWq
Received: by kanga.kvack.org (Postfix)
	id 477CC6B05ED; Thu, 29 Oct 2026 12:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CFF6B05EF; Thu, 29 Oct 2026 12:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C4E6B05F0; Thu, 29 Oct 2026 12:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E65C46B05ED
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:09:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3A8CC047B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:01 +0000 (UTC)
X-FDA: 85376147682.20.67965DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 104B380005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BK4mBoWq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BRw3zwpqOSWZwDl5SSKDl6DdQ83Q27IXTTC8q0I+MM=;
	b=JkJzf0wzUBDHSNcLxUFJDXwNwHsArfWuxFZJgDPLrn7LjaVElvDhPrBfRQ1ALGN+pypDOt
	x2zENNOy6HSwkm+CCwxd1xP0mKRzmnWMPW2vHyGcWjnOORokDp3x2EhaMjEIiZjxWw7TLB
	RuQLlDzci0U7guHqIYnwOO3dgZyD2nU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BK4mBoWq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290140;
	b=HlFCwKWb1OqC6KMYNb/zntbDo0nIGE9ft7sbPJ7osQezVPNOSuz26E/RVvIBk17qpUnrJq
	lOK8qvKBkWmzoI49twJKwKHZu3v2sgV2MtdkjbvvzcW36m2ml8j45rhjG2vyWBcmi+FtZt
	EBFjIJFmiMdlYxIM0+4bnuGDi+nO9XI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9469760627;
	Thu, 29 Oct 2026 16:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B433F1F01816;
	Thu, 29 Oct 2026 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290139;
	bh=7BRw3zwpqOSWZwDl5SSKDl6DdQ83Q27IXTTC8q0I+MM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BK4mBoWq5PNr9zCiGHhyJAczACYpVODG+qBfg8ooJ81XVq3KJ5knIFHqRBRNMdMFF
	 Q6HIJY83vtuGWSMeP681tYNmLuftHmCSI1TvVGJ4HB6yFtOcPQg2x0N/U4nNQFy2HS
	 LqOxNOdA5IjsE+/VMReNWXjecJze0uEpq5U/8yXfLEi1+3lFl2HWD0j9avAE46MTK7
	 1C7sWJYmOOsVo7K9ttCZ3aOsLRZo36AlimuvY7du37X/C84t+uRK0b3D1ntku4rgKg
	 3GJDC3C0TZ9Ux39XiRuhl8v9sn88TYcxFTJ0vsQ8TwWx9TnOC4iSQuZNnT87p00oCE
	 2ljv8YTsZFjaQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:14 +0100
Subject: [PATCH v2 23/34] btrfs: check BTRFS_FS_STATE_RO instead of
 SB_RDONLY at runtime
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-23-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=14055; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MgT1spkvxgPt3hEvDfh3TXgbNtgvxemeRhl6B04s1vQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjfwj72ldfz2XOedYsV2cdkSXzdOELqRrGwqlCv/u
 LGWb69nRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESWvGD4HyY7ea7NVafcEn6t
 deUKZS9kNWUC908+cZ+xYP35htnJ2owMP83fnmpZtF5n5z+TP6VHrHirJu7zeinb0zx5DpOR9Gp
 XDgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 104B380005
X-Rspam-User: 
X-Stat-Signature: z9dic66yfyy81kfycnziyj3zakxpe9jh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793290139-653581
X-HE-Meta: U2FsdGVkX192YlsywKka++JQlwGkREXMcMRadveBtYzNhOs6XnGhOgMvKuw3WIlQfbESmpKOwgQJDDOkJSM8lKMVhVYCQp742P9wkiDN5wpQfI2BJnHNs7E/p4NegRk2rivUR9h457Sbu3HTDK+jJ5tExJVe9ZWBHGSUfCyYsGxRaDHMS6+DHxfAXBhMObRr3qNukehsyZX210qDUWYMgHmojsVCf9geunppZJ89mzBQ16VTW05jI/zChiW2DUvA9ML0QJGuTKyGcYcC0XBi9YPUvfO23Kagm2gN7wgWTeWXKSOqeDNJoZf5kn+7SNVIpj7qClDmF7T5dTVJBZzr8ebfOGpFQ2H6eujZQtmzIEDsN7lGiMQot6n13VX0CHYZUGaHE98mxS9MexUDMeDgtZBWE08Or/vZG/juFCzX0AVOwjtd5138qIaRzW0alCYKqI/Dle+JlpsE0D2v3N7pHKRQdhveEPbp58fxD0er2dxX2BZ+gx6KSgCan3LcjgUMBQsuAgbndd25bJ6k7qQpeCwDiUL5mzjko2149vS3nqIRphGm8DY5WJoUmOBDPbRHSLcTfaga2epts3QrxE+t7jal+KdvcM/5fgAZlE/xn9S3nWWwLCyXLzWRiaS3mt2lhIC08XY0xmInj6Vor2w2a2fyHbLmRIPS1D6hsNaKCeCR9zEEJln61eSQAwVM/tpyFaPiP5C9gdhIhBhahliLaELybDkCM3WfdykPm2mIyurvJ6WbADEEvU+fdnDFWZ7Mxfk44NO/Ew/eykIFrVqQDTKIO/tawO06DuGe7dvLV/hWXHSGIoL1cHV1dCDYnrLIuOW+dm7pi+p/M4hbpmHNYykCFRn0Gk1ZCS5MyJA2W0Wx1V3sg0wBlKfnSzKfamOAjat7jj8qtFyaEUilbEQp64qIIiAZv0WxlkuC4+LGsCGU6AnRwlddBav1txddwkLBQOTQZIwpY4tnIfRDxAl
 izQTgje7
 dUWIrwGgke1a9SXOmlaj5vGoO9YKPGP6RnY60z4FRipJFRJvc+AoStJI9+CmC9IjTxAJxECPgwB3siKFEu3aYJ8zShYgCotz4duAEIMJ5R4NAKWvCJJEBH3VQpTB1E9/UfFphj2L0GNfKXdp36QD+spsyws650AZY82Ba/om50EtygQR3pSqqMtzWzrwpl9040XWSU4E7qRp8Pv87xdLikiayak4pfBMByAqZwdS8tJfOfvI5cYCN9FIw7z36UMjDQmDDp21F/ugbkX4xXKQCE+qKd+FLNaxx1iPZ74UUFY+ggRH7vJ0z39ekZi/LcD0fHIoNJjLBHGD7Er0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add btrfs_fs_rdonly() which tests BTRFS_FS_STATE_RO and use it instead
of sb_rdonly() wherever btrfs checks for a read-only filesystem at
runtime: the error handler, read repair, async discard, close_ctree(),
btrfs_inc_block_group_ro(), check_inode_item(), device replace and add,
cancelling a balance, the sysfs label and force_chunk_alloc stores, the
qgroup PERTRANS conversions and the subvolume orphan cleanup. And check
it next to every btrfs_root_readonly() check that guards a modification,
e.g. in btrfs_permission(), btrfs_setattr(), btrfs_update_time(), the
xattr and ACL handlers, btrfs_fileattr_set() and
btrfs_remap_file_range_prep().

BTRFS_FS_STATE_RO has always been set and cleared together with
SB_RDONLY. The remaining sb_rdonly() users are mount and remount paths
plus btrfs_is_full_ro() which only matters for rescue mounts.

This prepares for not setting SB_RDONLY from the error handler. Until
then the only difference is that ftruncate() and FICLONE through files
that were opened for writing before a forced remount to read-only, e.g.
by sysrq u, fail with EROFS now instead of modifying the filesystem.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/acl.c          |  3 ++-
 fs/btrfs/bio.c          |  2 +-
 fs/btrfs/block-group.c  |  2 +-
 fs/btrfs/dev-replace.c  |  2 +-
 fs/btrfs/discard.c      |  2 +-
 fs/btrfs/disk-io.c      |  4 ++--
 fs/btrfs/fs.h           | 10 ++++++++++
 fs/btrfs/inode.c        |  8 ++++----
 fs/btrfs/ioctl.c        |  8 ++++----
 fs/btrfs/messages.c     |  8 ++++----
 fs/btrfs/qgroup.c       |  4 ++--
 fs/btrfs/reflink.c      |  3 ++-
 fs/btrfs/sysfs.c        |  4 ++--
 fs/btrfs/tree-checker.c |  2 +-
 fs/btrfs/volumes.c      |  4 ++--
 fs/btrfs/xattr.c        |  8 ++++++--
 16 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 10a0d733bfd1..8bf11da118f7 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -107,8 +107,9 @@ int btrfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 	int ret;
 	struct inode *inode = d_inode(dentry);
 	umode_t old_mode = inode->i_mode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 
-	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 
 	if (type == ACL_TYPE_ACCESS && acl) {
diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 2c6234f6182f..987f29b1ac46 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -924,7 +924,7 @@ int btrfs_repair_bbio_failure(struct btrfs_bio *bbio, const struct bvec_iter *or
 	 * The fs either mounted RO or hit critical errors, no need
 	 * to continue repairing.
 	 */
-	if (unlikely(sb_rdonly(fs_info->sb)))
+	if (unlikely(btrfs_fs_rdonly(fs_info)))
 		return 0;
 
 	if (btrfs_repair_one_zone(fs_info, logical))
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 9a98e291769c..04c0c0b0c489 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3138,7 +3138,7 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group *cache,
 	 * In that case we should not start a new transaction on read-only fs.
 	 * Thus here we skip all chunk allocations.
 	 */
-	if (sb_rdonly(fs_info->sb)) {
+	if (btrfs_fs_rdonly(fs_info)) {
 		mutex_lock(&fs_info->ro_block_group_mutex);
 		ret = inc_block_group_ro(cache, false);
 		mutex_unlock(&fs_info->ro_block_group_mutex);
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index cdfe093e5c5c..943ce620a046 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -1115,7 +1115,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	int result;
 	int ret;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index 1c304bf473e5..e5c029813228 100644
--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -86,7 +86,7 @@ static bool btrfs_run_discard_work(const struct btrfs_discard_ctl *discard_ctl)
 						     struct btrfs_fs_info,
 						     discard_ctl);
 
-	return (!(fs_info->sb->s_flags & SB_RDONLY) &&
+	return (!btrfs_fs_rdonly(fs_info) &&
 		test_bit(BTRFS_FS_DISCARD_RUNNING, &fs_info->flags));
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c45cda4290d5..3dcacf7e4d1d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -177,7 +177,7 @@ static int btrfs_repair_eb_io_failure(const struct extent_buffer *eb,
 	struct btrfs_bio *bbio;
 	int ret;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	/*
@@ -4483,7 +4483,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	/* Cancel or finish ongoing discard work */
 	btrfs_discard_cleanup(fs_info);
 
-	if (!sb_rdonly(fs_info->sb)) {
+	if (!btrfs_fs_rdonly(fs_info)) {
 		/*
 		 * The cleaner kthread is stopped, so do one final pass over
 		 * unused block groups.
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2dd167c32d61..024c3ec7d058 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1194,6 +1194,16 @@ static inline int btrfs_need_cleaner_sleep(const struct btrfs_fs_info *fs_info)
 		btrfs_fs_closing(fs_info);
 }
 
+/*
+ * Check whether the filesystem is read-only. BTRFS_FS_STATE_RO is set and
+ * cleared together with SB_RDONLY on mount, on remount and when an error forces
+ * the filesystem read-only. Use this instead of sb_rdonly() at runtime.
+ */
+static inline bool btrfs_fs_rdonly(const struct btrfs_fs_info *fs_info)
+{
+	return test_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state);
+}
+
 static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
 {
 	clear_and_wake_up_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index abaa33471456..415c5145fcbe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5433,7 +5433,7 @@ static int btrfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
-	if (btrfs_root_readonly(root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 
 	ret = setattr_prepare(idmap, dentry, attr);
@@ -6058,7 +6058,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
 			return ERR_CAST(inode);
 
 		down_read(&fs_info->cleanup_work_sem);
-		if (!sb_rdonly(inode->vfs_inode.i_sb))
+		if (!btrfs_fs_rdonly(fs_info))
 			ret = btrfs_orphan_cleanup(sub_root);
 		up_read(&fs_info->cleanup_work_sem);
 		if (ret) {
@@ -6421,7 +6421,7 @@ static int btrfs_update_time(struct inode *inode, enum fs_update_time type,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int dirty;
 
-	if (btrfs_root_readonly(root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 	if (flags & IOCB_NOWAIT)
 		return -EAGAIN;
@@ -9316,7 +9316,7 @@ static int btrfs_permission(const struct mnt_idmap *idmap,
 
 	if (mask & MAY_WRITE &&
 	    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))) {
-		if (btrfs_root_readonly(root))
+		if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 			return -EROFS;
 		if (BTRFS_I(inode)->flags & BTRFS_INODE_READONLY)
 			return -EACCES;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f3e2afe221be..2063075906c8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -291,7 +291,7 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	u32 inode_flags;
 	bool prop_set = false;
 
-	if (btrfs_root_readonly(root))
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	if (fileattr_has_fsx(fa))
@@ -2453,7 +2453,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	if (ret)
 		return ret;
 
-	if (btrfs_root_readonly(root)) {
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info)) {
 		ret = -EROFS;
 		goto out;
 	}
@@ -3191,7 +3191,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 
 	switch (p->cmd) {
 	case BTRFS_IOCTL_DEV_REPLACE_CMD_START:
-		if (sb_rdonly(fs_info->sb))
+		if (btrfs_fs_rdonly(fs_info))
 			return -EROFS;
 		if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_DEV_REPLACE)) {
 			ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
@@ -3927,7 +3927,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 		goto out;
 	}
 
-	if (btrfs_root_readonly(root)) {
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(fs_info)) {
 		ret = -EROFS;
 		goto out;
 	}
diff --git a/fs/btrfs/messages.c b/fs/btrfs/messages.c
index 0704be7be871..cedca4050831 100644
--- a/fs/btrfs/messages.c
+++ b/fs/btrfs/messages.c
@@ -132,10 +132,10 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 #endif
 
 	/*
-	 * Special case: if the error is EROFS, and we're already under
-	 * SB_RDONLY, then it is safe here.
+	 * Special case: if the error is EROFS, and we're already read-only,
+	 * then it is safe here.
 	 */
-	if (error == -EROFS && sb_rdonly(sb))
+	if (error == -EROFS && btrfs_fs_rdonly(fs_info))
 		return;
 
 #ifdef CONFIG_PRINTK
@@ -168,7 +168,7 @@ void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function
 	if (!(sb->s_flags & SB_BORN))
 		return;
 
-	if (sb_rdonly(sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return;
 
 	btrfs_discard_stop(fs_info);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a0651fbfe778..dc96c6aca1a9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4658,7 +4658,7 @@ static void qgroup_convert_meta(struct btrfs_fs_info *fs_info, u64 ref_root,
 
 		qgroup_rsv_release(fs_info, qgroup, num_bytes,
 				BTRFS_QGROUP_RSV_META_PREALLOC);
-		if (!sb_rdonly(fs_info->sb))
+		if (!btrfs_fs_rdonly(fs_info))
 			qgroup_rsv_add(fs_info, qgroup, num_bytes,
 				       BTRFS_QGROUP_RSV_META_PERTRANS);
 
@@ -4688,7 +4688,7 @@ void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes)
 				      BTRFS_QGROUP_RSV_META_PREALLOC);
 	trace_btrfs_qgroup_meta_convert(root, num_bytes);
 	qgroup_convert_meta(fs_info, btrfs_root_id(root), num_bytes);
-	if (!sb_rdonly(fs_info->sb))
+	if (!btrfs_fs_rdonly(fs_info))
 		add_root_meta_rsv(root, num_bytes, BTRFS_QGROUP_RSV_META_PERTRANS);
 }
 
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index b5d2c094941d..de9bc8ba5028 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -857,7 +857,8 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (!(remap_flags & REMAP_FILE_DEDUP)) {
 		struct btrfs_root *root_out = inode_out->root;
 
-		if (btrfs_root_readonly(root_out))
+		if (btrfs_root_readonly(root_out) ||
+		    btrfs_fs_rdonly(root_out->fs_info))
 			return -EROFS;
 
 		ASSERT(inode_in->vfs_inode.i_sb == inode_out->vfs_inode.i_sb);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3ac1fa608d3b..c7522aafde1b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -751,7 +751,7 @@ static ssize_t btrfs_force_chunk_alloc_store(struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	ret = kstrtobool(buf, &val);
@@ -980,7 +980,7 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	if (!fs_info)
 		return -EPERM;
 
-	if (sb_rdonly(fs_info->sb))
+	if (btrfs_fs_rdonly(fs_info))
 		return -EROFS;
 
 	/*
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 9cd79d97b9b5..6cce0e6c759e 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1325,7 +1325,7 @@ static int check_inode_item(struct extent_buffer *leaf,
 			       "unknown incompat flags detected: 0x%x", flags);
 		return -EUCLEAN;
 	}
-	if (unlikely(!sb_rdonly(fs_info->sb) &&
+	if (unlikely(!btrfs_fs_rdonly(fs_info) &&
 		     (ro_flags & ~BTRFS_INODE_RO_FLAG_MASK))) {
 		inode_item_err(leaf, slot,
 			"unknown ro-compat flags detected on writeable mount: 0x%x",
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d3e6a9b429dd..47879cc2160d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2964,7 +2964,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	bool seeding_dev = false;
 	bool locked = false;
 
-	if (sb_rdonly(sb) && !fs_devices->seeding)
+	if (btrfs_fs_rdonly(fs_info) && !fs_devices->seeding)
 		return -EROFS;
 
 	/* Forbid freezing until the device is a committed member (or unwound). */
@@ -5297,7 +5297,7 @@ int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
 	 * mount time if the mount is read-write. Otherwise it's still paused
 	 * and we must not allow cancelling as it deletes the item.
 	 */
-	if (sb_rdonly(fs_info->sb)) {
+	if (btrfs_fs_rdonly(fs_info)) {
 		mutex_unlock(&fs_info->balance_mutex);
 		return -EROFS;
 	}
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index cbee10b6b49a..c38ddee78636 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -365,7 +365,9 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
 				   const char *name, const void *buffer,
 				   size_t size, int flags)
 {
-	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 
 	name = xattr_full_name(handler, name);
@@ -409,7 +411,9 @@ static int btrfs_xattr_handler_set_security(const struct xattr_handler *handler,
 					    const void *buffer,
 					    size_t size, int flags)
 {
-	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (btrfs_root_readonly(root) || btrfs_fs_rdonly(root->fs_info))
 		return -EROFS;
 
 	name = xattr_full_name(handler, name);

-- 
2.53.0


