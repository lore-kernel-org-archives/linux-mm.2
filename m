Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3324B606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ab83gmrU
Received: by kanga.kvack.org (Postfix)
	id 75C2C6B0701; Fri, 13 Nov 2026 07:02:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733D46B0703; Fri, 13 Nov 2026 07:02:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670F46B0704; Fri, 13 Nov 2026 07:02:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 339A46B0701
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:02:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8409F12023A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:19 +0000 (UTC)
X-FDA: 85429957998.10.3CD5655
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A398712000D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ab83gmrU;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rS1m6Cp+lH+e/iHXkx5HAKDceJmj2j6LhhW3qVbCZW4=;
	b=IFihFsAoQHfrCAGoFwzaDfTrEDsTSnlEZ9svT/t6PdD5ELHUj0xbnP7h5v24JXXIfBTcZE
	ky9adc7jSejIl8mhvY/P+LR9u1ngYx2jtZhMydXtZwhqT1Jzv5/KHfojae+1YnOoyR95PP
	6ipN6lzndV8PtGISTvIyW1GMW4LdpxM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571337;
	b=8dkxTV389cFbuCgFgS1Y+SHrdUgpVyijMTkBx09Vr6DYkKkGLMmYTXB4yK38zkhSVFtzAy
	kKhLqwopuGqhK+IqyDJfCBnl72K5ScGCfeFwHRweglfsV24vtPf44wQWw4m9fvG0FSsJTb
	Gu8oXpxGWLAJG1CRk3hlR6orMP9qe3o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ab83gmrU;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DBCA62236;
	Fri, 13 Nov 2026 12:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1E41F000C4;
	Fri, 13 Nov 2026 12:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571337;
	bh=rS1m6Cp+lH+e/iHXkx5HAKDceJmj2j6LhhW3qVbCZW4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ab83gmrUpzh805E0hYE9wXyEirCMlxpG5/m5wWElyk1lwxlfo4B4O3MxfGYxZt6l8
	 09dfQssQ+WkFWAIpI11SMv0HX8EzkPZEZrEx9evH9V/FyqX/9Sw0yl7lzD6nnCSFMd
	 O/OHVg27YfeRoj0w2nMtmyevJPrskpK7G+g2xeGkWS08ADCV3aGN3u0KFYLN6kx4Tz
	 tzF/S4PfkL2ziROzev1RRF8i71wXgY/MKGxPdW4/3SVE3JjHTB29DJCK9j1hlckSwf
	 SFxaFn8HiWaq7Fhtd4NZ8Fh+NpyGhq+YxTiOT6Ojsxh+UXG2jc/ZJxduokvOwlNOhE
	 jT8wxOXakn9cw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:25 +0100
Subject: [PATCH v3 29/33] efivarfs: stop using SB_RDONLY for read-only
 efivar ops
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-29-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7550; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/72VFxS3I/CxjnoeReimw+DEGd3eAwaOhrR+5ycR15E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73nwoslG7XsBMXfysYIvXxhmf35Nss5h7+WN8+kt
 ua9j56a0FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAnCTDRgZXq7pe6s1a7LQibbO
 KS9YQuPDjp8Qnex1db740bpVxRFXkhh+s6TcX5VQXrR3wYaS0y7RLewCqzj2sPZdWRjy86/za7m
 33AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7krfpjzqmrxhba6uyr1u3xwmxymxujia
X-Rspamd-Queue-Id: A398712000D
X-Rspam-User: 
X-HE-Tag: 1794571337-311709
X-HE-Meta: U2FsdGVkX1+t7Tg5Lv7r/rjRbqONn44Yq4fKGFVykThRj6lZiNH92wYxE3QZR4CzhGb7qdw1WOBgWchShFM/YXaA3ldUQMSbTo1jAHxF4A7s91TsYQnXPnsEjRlyXFbNzeXF2BWLMQXtvI49ssyCucIQsaGQw/IhgTke8P6zmsdacmzClg6XJxpl1EHmdCLwVQGv3KvvstVRZi2PL0pq/jgcdSb1wSCRtqvUOAmDIrqF3qCHKyBAdBgp0Ek2b3KHIlD7nJKuygMGMnsdQmtpkM8jDaphQp/FFUkIXaFRShPw7wdwDjK6h4V6nZvgJS9+XvlWhi4Ju7H2sz1lmfekHNrAbMXn/wQ7cbskgjxIiYfFi39AT2d8HkiqMdRAZ9rBuTGP+PjiiHM2OUzZMBbCm+l8dwfXQbKqDj03GpndtVOh8YcT0iVAS/6/ut6IvBlHiTqCwOqAFhvQmF8qWPrmCLvxa/6AIgg680HQSA07ai3Tq0+LyrW4b2vdudHUtuiB7oqtvdKvgTlC8fe5/073FASfNYntM3kAx7q71GHV2JQl1DPTd4yn8eI8z/qX2+vZO1143tH9xqXyOsD3KUXCTtMB1WFYA4drusOyH68xG1HmsXe7BZCcKODtXk2bnK/Rmq/QnuIFwUAdjyZ8uKJZearjGQJA4CIQ0mYOzJYocqkc6axtsWECEr9Z1aAdkz7P3JMpKc0YDDSvlfj2u2f+U81RS38ihBgi/mTlcWspPbUTHUEKP1r+dkwSUp6WtNwARPBdREHY+1ZexonqSfOJb9PC/WUkkCK48r6URNFqMBYyKeqJc4ms4DRyp4VsS8UrkyXokLdGsZFQ13C3KEEDGPHND7sLdKk8HKKUv1LLU2/79h5dHsEnQSepSL761l6A8HbgwWRFvZnlWBgWS7+w6RCF9Ll2kao2/EErKaczdBYbMA5Z6fOHECWyoNXSa/Zh2LQHcYPFhYyplARy9q0
 Y9ExXNBJ
 1Ir7GFji1EInT29bxErrQI7e1bv2BIB6aceoEIydrKjshpheCETLCC7OcVcFiKQZlSyiXXhsGcvHHl7MNwBMfJqj/buonYPltTVk9VfaKWccm6ZZtNcJuIT+GZukG/T+rD44HIwbkfgVUPHZ9GhW0dsntHKohy0DpTBVkGk4purt0m5KS3QIixDrvU39iWBZsm/bPGU7vG9MhUgQNAmVXbgS2GwygwRyR0qXh6dYFg60froo7CmK06RzyWxCFLqo4BLsoqE11BazkSRDZ6y7We7DAIubDJDt21CKOAS2EAoCw+tuGtIoTb1+6Kzdd+jr4zhZ9J0q3fdxr0Ro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 94f7f6182c72 ("efivarfs: automatically update super block
flag") efivarfs_ops_notifier() sets or clears SB_RDONLY whenever the
efivar ops switch between ops that can and ops that can't set variables,
e.g. when tee_stmm_efi is probed or removed. It does that at any time
without holding s_umount. efivarfs is frozen on every suspend and if the
ops switch while it's frozen thaw_super() either leaves the s_writers
rwsems locked or releases rwsems nobody holds.

So keep the state in efivarfs. The notifier sets and clears a new
EFIVARFS_OPS_RDONLY flag instead and efivarfs_fill_super() initializes
it under efivar_lock() so a switch can't slip in. fill_super doesn't set
SB_RDONLY either. systemd mounts efivarfs before tee_stmm_efi is loaded
and the mount has to become writable then. create, unlink, setattr,
fileattr_set, write and opening for write fail with EROFS while the flag
is set. Like the SB_RDONLY check this runs without efivars_lock so a
write racing with a switch can still call a NULL ->set_variable. That's
not new.

efivarfs_reconfigure() only refuses a remount from read-only to
read-write while the flag is set and returns EROFS. It used to refuse
every remount without "ro" which would break option-only remounts.

With read-only ops efivarfs is mounted "rw" now. statfs() doesn't report
ST_RDONLY anymore and access(W_OK) succeeds.

Fixes: 94f7f6182c72 ("efivarfs: automatically update super block flag")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/efivarfs/file.c     |  6 ++++++
 fs/efivarfs/inode.c    | 15 +++++++++++++++
 fs/efivarfs/internal.h | 14 +++++++++++++-
 fs/efivarfs/super.c    | 26 ++++++++++++++++++--------
 4 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index cb1b6d0c34545..a074145fa57e1 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -23,6 +23,9 @@ static ssize_t efivarfs_file_write(struct file *file,
 	ssize_t bytes;
 	bool set = false;
 
+	if (efivarfs_ops_rdonly(inode->i_sb))
+		return -EROFS;
+
 	if (count < sizeof(attributes))
 		return -EINVAL;
 
@@ -137,6 +140,9 @@ static int efivarfs_file_open(struct inode *inode, struct file *file)
 {
 	struct efivar_entry *entry = inode->i_private;
 
+	if ((file->f_mode & FMODE_WRITE) && efivarfs_ops_rdonly(inode->i_sb))
+		return -EROFS;
+
 	file->private_data = entry;
 
 	inode_lock(inode);
diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 07602cd5d33c3..be183de4b7716 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -15,6 +15,8 @@
 #include "internal.h"
 
 static const struct inode_operations efivarfs_file_inode_operations;
+static int efivarfs_setattr(const struct mnt_idmap *idmap,
+			    struct dentry *dentry, struct iattr *iattr);
 
 struct inode *efivarfs_get_inode(struct super_block *sb,
 				const struct inode *dir, int mode,
@@ -83,6 +85,9 @@ static int efivarfs_create(const struct mnt_idmap *idmap, struct inode *dir,
 	bool is_removable = false;
 	efi_guid_t vendor;
 
+	if (efivarfs_ops_rdonly(dir->i_sb))
+		return -EROFS;
+
 	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
 		return -EINVAL;
 
@@ -122,6 +127,9 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct efivar_entry *var = d_inode(dentry)->i_private;
 
+	if (efivarfs_ops_rdonly(dir->i_sb))
+		return -EROFS;
+
 	if (efivar_entry_delete(var))
 		return -EINVAL;
 
@@ -132,6 +140,7 @@ const struct inode_operations efivarfs_dir_inode_operations = {
 	.lookup = simple_lookup,
 	.unlink = efivarfs_unlink,
 	.create = efivarfs_create,
+	.setattr = efivarfs_setattr,
 };
 
 static int
@@ -155,6 +164,9 @@ efivarfs_fileattr_set(const struct mnt_idmap *idmap,
 {
 	unsigned int i_flags = 0;
 
+	if (efivarfs_ops_rdonly(dentry->d_sb))
+		return -EROFS;
+
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
 
@@ -176,6 +188,9 @@ static int efivarfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry
 	struct inode *inode = d_inode(dentry);
 	int error;
 
+	if (efivarfs_ops_rdonly(inode->i_sb))
+		return -EROFS;
+
 	error = setattr_prepare(idmap, dentry, iattr);
 	if (error)
 		return error;
diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
index f5c1a25be9969..34a0c53b5993f 100644
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -16,10 +16,22 @@ struct efivarfs_mount_opts {
 
 struct efivarfs_fs_info {
 	struct efivarfs_mount_opts mount_opts;
-	struct super_block *sb;
 	struct notifier_block nb;
+	unsigned long flags;
 };
 
+/* efivarfs_fs_info->flags */
+enum {
+	EFIVARFS_OPS_RDONLY,	/* the registered efivar ops can't set variables */
+};
+
+static inline bool efivarfs_ops_rdonly(const struct super_block *sb)
+{
+	const struct efivarfs_fs_info *sfi = sb->s_fs_info;
+
+	return test_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
+}
+
 struct efi_variable {
 	efi_char16_t  VariableName[EFI_VAR_NAME_LEN/sizeof(efi_char16_t)];
 	efi_guid_t    VendorGuid;
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 12746ced6dc63..437dfea9aa42d 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -28,12 +28,16 @@ static int efivarfs_ops_notifier(struct notifier_block *nb, unsigned long event,
 {
 	struct efivarfs_fs_info *sfi = container_of(nb, struct efivarfs_fs_info, nb);
 
+	/*
+	 * This runs without s_umount so it can't touch SB_RDONLY. The
+	 * modifying operations check EFIVARFS_OPS_RDONLY instead.
+	 */
 	switch (event) {
 	case EFIVAR_OPS_RDONLY:
-		sfi->sb->s_flags |= SB_RDONLY;
+		set_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
 		break;
 	case EFIVAR_OPS_RDWR:
-		sfi->sb->s_flags &= ~SB_RDONLY;
+		clear_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
 		break;
 	default:
 		return NOTIFY_DONE;
@@ -384,9 +388,6 @@ static int efivarfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_d_flags |= DCACHE_DONTCACHE;
 	sb->s_time_gran         = 1;
 
-	if (!efivar_supports_writes())
-		sb->s_flags |= SB_RDONLY;
-
 	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0, true);
 	if (!inode)
 		return -ENOMEM;
@@ -397,9 +398,15 @@ static int efivarfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!root)
 		return -ENOMEM;
 
-	sfi->sb = sb;
+	/* The ops can't switch between sampling them and registering. */
+	err = efivar_lock();
+	if (err)
+		return err;
+	if (!efivar_supports_writes())
+		set_bit(EFIVARFS_OPS_RDONLY, &sfi->flags);
 	sfi->nb.notifier_call = efivarfs_ops_notifier;
 	err = blocking_notifier_chain_register(&efivar_ops_nh, &sfi->nb);
+	efivar_unlock();
 	if (err)
 		return err;
 
@@ -413,12 +420,15 @@ static int efivarfs_get_tree(struct fs_context *fc)
 
 static int efivarfs_reconfigure(struct fs_context *fc)
 {
+	struct super_block *sb = fc->root->d_sb;
 	struct efivarfs_fs_info *sfi = fc->root->d_sb->s_fs_info;
 	struct efivarfs_fs_info *new_sfi = fc->s_fs_info;
 
-	if (!efivar_supports_writes() && !(fc->sb_flags & SB_RDONLY)) {
+	/* Only refuse remounting a read-only mount read-write. */
+	if ((fc->sb_flags_mask & SB_RDONLY) && !(fc->sb_flags & SB_RDONLY) &&
+	    sb_rdonly(sb) && efivarfs_ops_rdonly(sb)) {
 		pr_err("Firmware does not support SetVariableRT. Can not remount with rw\n");
-		return -EINVAL;
+		return -EROFS;
 	}
 
 	/* statfs()/show_options() read nostatfs locklessly; benign race. */

-- 
2.53.0


