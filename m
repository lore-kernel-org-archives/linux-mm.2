Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D52606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijWrPILZ
Received: by kanga.kvack.org (Postfix)
	id B2D816B05E1; Thu, 29 Oct 2026 12:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05636B05E3; Thu, 29 Oct 2026 12:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F46A6B05E4; Thu, 29 Oct 2026 12:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 695C46B05E1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:08:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDDF9A800C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:36 +0000 (UTC)
X-FDA: 85376146632.19.0A6F47E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0FF3514000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijWrPILZ;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290115;
	b=L2DI2pwDSo6I/9naS7u836Wptie2+4Evh8/lEf0QGLPqry0oOJxZz3Kfxap7OShuA29GnU
	MVEcZW3CSJ4TZB0rmUy024qgjMKTXutvdwNHbkXARZpihI/6DTC+oGQaZgFCMq2SjslkCC
	unYvWgQ8nb9eYHxmW0N41JVQmON8GLg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijWrPILZ;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9JRT5OO9f0IC/XELtyByEfDld98sA5FkrUFDYw28kk=;
	b=E7CyyxYLr4Sk6N8mJbl5vuMwhEFSKvaHwqAZ7oOAwDBPQd5Cv0lEqZCU5rx2MtJQsDw2ke
	UQTpkNqluyAgZ3KqLULf1brG2RJe8LzOFWf6Ez0WU+2pqcMRYl1zyu6r597QnQMmIfOK5U
	N9Lst8aIe2xPhG6iK4PQhC3vUZ8Rov8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FDAE419AE;
	Thu, 29 Oct 2026 16:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A62D1F01816;
	Thu, 29 Oct 2026 16:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290114;
	bh=i9JRT5OO9f0IC/XELtyByEfDld98sA5FkrUFDYw28kk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ijWrPILZuxBYqhiNIou3gnLLtvplQruEBPKEmkZUHhVDxcaMuOoc6L42Pqdj/aS6r
	 6qLGfehx+LLXq0krCbchJokLCHAP2k/kJgJ41tz+rqjy9S+nyDCDaGXWDDZ0eEXhg2
	 hzPXVfQeQDaE/Z9c68srhbHpVKpXThgZAnfn6k19TzjTYxF0padmo/QYnKPnoQJezA
	 ovvOkhWf+sl43nr2gzrltYYfO5ejEeKhjSxBReuoIrpPL6TxslMLexxft6rZXE4PdN
	 s37IsfbOf55UJh6pA0rhuTl8kE1ZU8rBghmKn+SOrMAgkfo4m7zZaOiHJzuddTuV8s
	 pwo+7sr6nLbLw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:08 +0100
Subject: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=23274; i=brauner@kernel.org;
 h=from:subject:message-id; bh=r676ZnqaWi8UC5WS71LLfmQ6zhPF9ceXOlShsPSC1yg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztdfb3I077eAYLSE99PlYd+mhgfxqVa+b/zzuprtw
 Ccm90sJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOJzGH4ZzLjr29+1rs21+zK
 dxtO6Umc9W410XuyJ8w05mfKTu7FJxgZrs2P+Oy4Pedl3saFizQ+705iPtklIy6l+1BQNtdYuTi
 YFQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FF3514000B
X-Stat-Signature: kismk1xfh4a9fcgk17i8ej45or1f9m68
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793290114-107630
X-HE-Meta: U2FsdGVkX197EywHxafXiVzy7Zr0ZS4Wi53sgKmbAyo41npVunvVqpqoXk46bg6lcV5AUSRklp9mJBysA3OwwKKl1HnrXK6yXPM036zNc8zB8uPJRl7IcbIdEkXU5o3Z3uvtc/7X3G03cbBJorAyLVGyNADlTUomJG2oRpguHIbEJK6qAfZuMEV6bDpa4rglFoUo1JsPZJAnlTyX1hrS8eepgOk1ix9/DnAf2sdcbeFSua77aqwFMDRPV7AnCq4o73Z5mH5swL3yvNUDA9eDV9aplH9WLmXglHKwx6KoNQczCxMixuib6/f0lkQUjXmLkLrgp8SMrVOt9Ka98c2rTg7MwGgjBp3qG/gmNKFrUWTaA/SUuKerL8vfcqekHIVCG+CDd2mwPQCuxXTDnRdqmGnPwmSo/6VcKvRKufbundDJHT2y/IBgFBedl5Cp0MV36RrR9QxTMKWmxUMJyVNVH1LeHfyf4yAyHVZzquS5oppiWLnkuFRBuMaAOsR1+0vHaSCYn1HHb66aiBgZvfJIIpXJRR4ctoKXQTpqWFY0LAX9JYFx3i6ykTjVnNfdYWHn5ebxNChyELlvgH+Ou0P3Z5vFILe8U8B8nZr2Q9ANdLlZVmdgXJPi+9nzKCwN80XF0c1vog5E9nFDE/qaWjIDZo55h98GaaSAUVD0O+vSeVjuvQXUt0D8G18y+n1+nyljOxHi2Igw0NjQ/5b932nyu59W8XxR/70AzwS0lVmExpkAZ2yadU5NFjPFnG6ej24fYqpQERyFV8eD5GgDDxcJpTIEmAb9ESoB2IsgSzbe9UNPoKxdJ+fYMjH4bxow5vQWt5hF0teSdzfimGK1EKZh2vKZahNYslrHJLWEVRVM1Kfi0uwEUHIbzvGltiuy3yb3rGCjNkmlzzp6Sq+o9LBwZ8wqRUwEAG8rV60nTGJgzqq7VAav/OzK92pg9c2VE9ZIDyAXVkuDORTBBI3XvAg
 tGlOx8ZP
 LIN8nuaHiyVuUAvEKLXaG+xRQ5Gj06OVnek1ioZYH8o8I2m+A5TRiIHQS6uMMCpum7VgHEWrcDP+QbTikoZaSRGIesxBQM9g7j4GjDkZxwxsIB/daMeT69L+GiVOyEz/DUaH6kTvzEA6HjLnROh3ta3WE/vBvkT3BAZrTHG4hwHu+5MJ9XSHXg5PBnVikW90csNSF2ziMBox5dWqZ3WTBv5I6iU/cvlco0Nvxu++L+MsGUiSSI/q1Blfx03YpYwVaisXQSFBRayGExdzRkffL3GNn51nK8OtPJ1VnB1iJCRqhfXGa8aeHuq6O1OsYvMCRsR1UQfOGm2AN6oI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With errors=remount-ro every ntfs_error() ends up in ntfs_handle_error()
which sets SB_RDONLY without holding s_umount. If that happens while the
volume is frozen through bdev_freeze() thaw_super() sees a read-only
superblock and leaves the s_writers rwsems locked so every writer hangs.

So set NV_Errors and a new NV_EmergencyRO flag instead like ext4 does.
ntfs_emergency_state() returns EIO after a shutdown and EROFS after an
error and the write side shutdown checks use it now. fallocate,
->set_acl(), FS_IOC_SETFSLABEL, FITRIM and ntfs_mft_record_free() get a
check as well. Errors while mounting still set SB_RDONLY, nothing can
freeze the superblock before SB_BORN.

NV_Errors already refuses a remount to read-write and since
commit 521978c4f444 ("ntfs: sync the volume dirty bit with the recorded
error state") the volume stays marked dirty once errors were recorded.
But the dirty bit may not be on disk yet when the error hits and
writeback is refused from then on. So a work item writes it right away
because ntfs_error() can be called with mft records locked, and umount
lets a pending one run first.

Unlinked inodes are left to chkdsk in that state. Their mft records are
freed with direct bios while the index and bitmap updates of the
deletion can't be written back anymore. And writing to an encrypted file
only warns now. It called ntfs_error() which let anyone put the volume
into the emergency state.

/proc/mounts keeps showing the volume read-write. Writes through file
descriptors opened before the error fail with EROFS.

Fixes: 6251f0b0de7d ("ntfs: update super block operations")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ntfs/aops.c         |  5 ++--
 fs/ntfs/dir.c          |  5 ++--
 fs/ntfs/ea.c           | 10 ++++++--
 fs/ntfs/file.c         | 63 ++++++++++++++++++++++++++++++++++++--------------
 fs/ntfs/inode.c        | 15 +++++++++---
 fs/ntfs/iomap.c        |  6 +++--
 fs/ntfs/mft.c          | 10 ++++++--
 fs/ntfs/named_stream.c | 43 +++++++++++++++++-----------------
 fs/ntfs/namei.c        | 40 +++++++++++++++++++-------------
 fs/ntfs/super.c        | 55 ++++++++++++++++++++++++++++++++++++++-----
 fs/ntfs/volume.h       | 16 +++++++++++++
 11 files changed, 195 insertions(+), 73 deletions(-)

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index ad781674fef1..872c039f6c02 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -263,8 +263,9 @@ static int ntfs_writepages(struct address_space *mapping,
 	bool need_iput = false;
 	int ret;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	ret = ntfs_emergency_state(ni->vol);
+	if (ret)
+		return ret;
 
 	if (!NInoNonResident(ni))
 		return 0;
diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index fce10baa2b93..6314f115e6e9 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -1131,8 +1131,9 @@ static int ntfs_dir_fsync(struct file *filp, loff_t start, loff_t end,
 
 	ntfs_debug("Entering for inode 0x%llx.", ni->mft_no);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	ctx = ntfs_attr_get_search_ctx(ni, NULL);
 	if (!ctx)
diff --git a/fs/ntfs/ea.c b/fs/ntfs/ea.c
index fa5c5c625751..0cf3a63af912 100644
--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -907,8 +907,9 @@ static int ntfs_setxattr(const struct xattr_handler *handler,
 
 	if (ntfs_inode_is_named_stream(ni))
 		return -EOPNOTSUPP;
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 
 	/* Only fileattr_set may change the flags and their cached state. */
 	if (!strcmp(name, "$LINUXFLAGS"))
@@ -1193,6 +1194,11 @@ static noinline int ntfs_set_acl_ex(const struct mnt_idmap *idmap,
 int ntfs_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 struct posix_acl *acl, int type)
 {
+	int err;
+
+	err = ntfs_emergency_state(NTFS_I(d_inode(dentry))->vol);
+	if (err)
+		return err;
 	return ntfs_set_acl_ex(idmap, d_inode(dentry), acl, type, false);
 }
 
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index b2f5882d9990..fbfbd94c6092 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -55,9 +55,14 @@
 int ntfs_file_open(struct inode *vi, struct file *filp)
 {
 	struct ntfs_inode *ni = NTFS_I(vi);
+	int err;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	if (filp->f_mode & FMODE_WRITE)
+		err = ntfs_emergency_state(ni->vol);
+	else
+		err = NVolShutdown(ni->vol) ? -EIO : 0;
+	if (err)
+		return err;
 
 	if (sizeof(unsigned long) < 8) {
 		if (i_size_read(vi) > MAX_LFS_FILESIZE)
@@ -210,8 +215,9 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	bool forced_immutable;
 	int err;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
@@ -305,8 +311,9 @@ int ntfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 
 	ntfs_debug("Entering for inode 0x%llx.", ni->mft_no);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = file_write_and_wait_range(filp, start, end);
 	if (err)
@@ -459,8 +466,11 @@ int ntfs_setattr_size(struct inode *vi, struct iattr *attr)
 	int err;
 	loff_t old_size = vi->i_size;
 
-	if (stream && NVolShutdown(ni->vol))
-		return -EIO;
+	if (stream) {
+		err = ntfs_emergency_state(ni->vol);
+		if (err)
+			return err;
+	}
 
 	if (NInoCompressed(ni) || NInoEncrypted(ni) || NInoWofCompressed(ni)) {
 		ntfs_warning(
@@ -544,8 +554,9 @@ int ntfs_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct ntfs_inode *ni = NTFS_I(vi);
 	struct ntfs_volume *vol = ni->vol;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = setattr_prepare(idmap, dentry, attr);
 	if (err)
@@ -860,15 +871,16 @@ ssize_t ntfs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	int err;
 	loff_t old_data_size, old_init_size;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	if (NInoWofCompressed(ni))
 		return -EOPNOTSUPP;
 
 	if (NInoEncrypted(ni)) {
-		ntfs_error(vi->i_sb, "Writing for %s files is not supported yet",
-			   NInoCompressed(ni) ? "Compressed" : "Encrypted");
+		ntfs_warning(vi->i_sb, "Writing for %s files is not supported yet",
+			     NInoCompressed(ni) ? "Compressed" : "Encrypted");
 		return -EOPNOTSUPP;
 	}
 
@@ -1037,9 +1049,15 @@ int ntfs_file_mmap_prepare(struct vm_area_desc *desc)
 {
 	struct file *file = desc->file;
 	struct inode *inode = file_inode(file);
+	struct ntfs_volume *vol = NTFS_SB(file->f_mapping->host->i_sb);
+	int ret;
 
-	if (NVolShutdown(NTFS_SB(file->f_mapping->host->i_sb)))
-		return -EIO;
+	if (file->f_mode & FMODE_WRITE)
+		ret = ntfs_emergency_state(vol);
+	else
+		ret = NVolShutdown(vol) ? -EIO : 0;
+	if (ret)
+		return ret;
 
 	if (NInoCompressed(NTFS_I(inode)) || NInoWofCompressed(NTFS_I(inode)))
 		return -EOPNOTSUPP;
@@ -1165,7 +1183,9 @@ static int ntfs_ioctl_set_volume_label(struct file *filp, unsigned long arg)
 	if (ret)
 		goto out;
 
-	ret = ntfs_write_volume_label(vol, label);
+	ret = ntfs_emergency_state(vol);
+	if (!ret)
+		ret = ntfs_write_volume_label(vol, label);
 	mnt_drop_write_file(filp);
 out:
 	kfree(label);
@@ -1182,6 +1202,11 @@ static int ntfs_ioctl_fitrim(struct ntfs_volume *vol, unsigned long arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* Don't trust $Bitmap after an error. */
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
+
 	dev = vol->sb->s_bdev;
 	if (!bdev_max_discard_sectors(dev))
 		return -EOPNOTSUPP;
@@ -1478,6 +1503,10 @@ long ntfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (mode & ~(NTFS_FALLOC_FL_SUPPORTED))
 		return -EOPNOTSUPP;
 
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
+
 	if (NInoCompressed(ni) || NInoEncrypted(ni) || NInoWofCompressed(ni))
 		return -EOPNOTSUPP;
 
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 206db4e99ef1..6219aed945df 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2434,7 +2434,11 @@ void ntfs_evict_big_inode(struct inode *vi)
 
 	truncate_inode_pages_final(&vi->i_data);
 
-	if (!vi->i_nlink) {
+	/*
+	 * After an error the freed mft record would go out right away while
+	 * the rest of the deletion can't, leave the inode to chkdsk.
+	 */
+	if (!vi->i_nlink && !ntfs_emergency_state(ni->vol)) {
 		if (!NInoAttr(ni)) {
 			/* Never called with extent inodes */
 			WARN_ON(ni->nr_extents == -1);
@@ -2907,8 +2911,13 @@ int __ntfs_write_inode(struct inode *vi, int sync)
 	ntfs_debug("Entering for %sinode 0x%llx.", NInoAttr(ni) ? "attr " : "",
 			ni->mft_no);
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	/* After an error only $Volume is still written, see ntfs_error_work(). */
+	err = ntfs_emergency_state(ni->vol);
+	if (err) {
+		if (err != -EROFS || vi != ni->vol->vol_ino)
+			return err;
+		err = 0;
+	}
 
 	/*
 	 * Dirty attribute inodes are written via their real inodes so just
diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index 6e51cce3aeba..4dc5fa29c166 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -739,9 +739,11 @@ static int __ntfs_write_iomap_begin(struct inode *inode, loff_t offset,
 {
 	struct ntfs_inode *ni = NTFS_I(inode);
 	struct ntfs_inode *mrec_ni;
+	int err;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 
 	if (!NInoNonResident(ni)) {
 		mrec_ni = ntfs_inode_is_named_stream(ni) ?
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 89288b794348..45232f8fc089 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -2956,6 +2956,11 @@ int ntfs_mft_record_free(struct ntfs_volume *vol, struct ntfs_inode *ni)
 	if (!vol || !ni)
 		return -EINVAL;
 
+	/* The freed record goes out right away, the rest of the deletion can't. */
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
+
 	ntfs_debug("Entering for inode 0x%llx.\n", (long long)ni->mft_no);
 
 	ni_mrec = map_mft_record(ni);
@@ -3423,8 +3428,9 @@ int ntfs_mft_writepages(struct address_space *mapping,
 	struct folio *folio = NULL;
 	int error;
 
-	if (NVolShutdown(NTFS_I(mapping->host)->vol))
-		return -EIO;
+	error = ntfs_emergency_state(NTFS_I(mapping->host)->vol);
+	if (error)
+		return error;
 
 	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
 		error = ntfs_write_mft_block(folio, wbc);
diff --git a/fs/ntfs/named_stream.c b/fs/ntfs/named_stream.c
index 95a3c05f9821..64d9acd7617d 100644
--- a/fs/ntfs/named_stream.c
+++ b/fs/ntfs/named_stream.c
@@ -587,10 +587,9 @@ struct inode *ntfs_create_named_stream(const struct mnt_idmap *idmap,
 
 	base_ni = NTFS_I(base_vi);
 	mutex_lock(&base_ni->mrec_lock);
-	if (NVolShutdown(base_ni->vol)) {
-		err = -EIO;
+	err = ntfs_emergency_state(base_ni->vol);
+	if (err)
 		goto out_unlock;
-	}
 	if (NInoBeingDeleted(base_ni) || !base_vi->i_nlink) {
 		err = -ENOENT;
 		goto out_unlock;
@@ -613,10 +612,9 @@ struct inode *ntfs_create_named_stream(const struct mnt_idmap *idmap,
 		else
 			err = -EEXIST;
 	} else if (err == -ENOENT) {
-		if (NVolShutdown(base_ni->vol)) {
-			err = -EIO;
+		err = ntfs_emergency_state(base_ni->vol);
+		if (err)
 			goto out_put_ctx;
-		}
 		err = ntfs_attr_add(base_ni, AT_DATA, stream_name, stream_len,
 				NULL, 0);
 		if (!err) {
@@ -926,8 +924,9 @@ static int ntfs_stream_setattr(const struct mnt_idmap *idmap,
 	bool claimed = false;
 	int err;
 
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 
 	if (!(attr->ia_valid & ATTR_FILE)) {
 		err = ntfs_stream_claim(inode);
@@ -954,16 +953,16 @@ static int ntfs_stream_update_time_common(struct inode *inode,
 	struct inode *base_vi = VFS_I(base_ni);
 	int err;
 
-	if (NVolShutdown(base_ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(base_ni->vol);
+	if (err)
+		return err;
 	if (flags & IOCB_NOWAIT)
 		return -EAGAIN;
 
 	mutex_lock(&base_ni->mrec_lock);
-	if (NVolShutdown(base_ni->vol)) {
-		err = -EIO;
+	err = ntfs_emergency_state(base_ni->vol);
+	if (err)
 		goto out_mrec;
-	}
 	err = ntfs_stream_inode_validate(inode);
 	if (!err) {
 		err = generic_update_time(base_vi, type, flags);
@@ -1028,10 +1027,9 @@ static int ntfs_stream_finish_remove(struct inode *attr_vi)
 	truncate_inode_pages(attr_vi->i_mapping, 0);
 
 	mutex_lock(&ni->mrec_lock);
-	if (NVolShutdown(ni->vol)) {
-		err = -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
 		goto out_unlock;
-	}
 	if (NInoBeingDeleted(ni) || !VFS_I(ni)->i_nlink) {
 		remove_inode_hash(attr_vi);
 		err = 0;
@@ -1092,8 +1090,9 @@ int ntfs_remove_named_stream(struct ntfs_inode *ni, __le16 *uname,
 
 	if (!ni || !uname || uname_len == 0)
 		return -EINVAL;
-	if (NVolShutdown(ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(ni->vol);
+	if (err)
+		return err;
 	if ((ni->flags & FILE_ATTR_READONLY) ||
 	    IS_APPEND(VFS_I(ni)) || IS_IMMUTABLE(VFS_I(ni)))
 		return -EPERM;
@@ -1245,10 +1244,12 @@ static int ntfs_stream_ioctl_get_inode(struct inode *base_vi, __le16 *sname,
 	*stream_vi = NULL;
 
 	mutex_lock(&base_ni->mrec_lock);
-	if (NVolShutdown(base_ni->vol)) {
-		err = -EIO;
+	if (create)
+		err = ntfs_emergency_state(base_ni->vol);
+	else
+		err = NVolShutdown(base_ni->vol) ? -EIO : 0;
+	if (err)
 		goto out_unlock;
-	}
 	if (NInoBeingDeleted(base_ni) || !base_vi->i_nlink) {
 		err = -ENOENT;
 		goto out_unlock;
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index 62b01646c262..ebeea6ea3ac3 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -782,8 +782,9 @@ static int ntfs_create(const struct mnt_idmap *idmap, struct inode *dir,
 	__le16 *uname, *base_name = NULL, *stream_name = NULL;
 	int uname_len, stream_len, path_result, err;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	path_result = ntfs_stream_path_names(vol, &dentry->d_name, &base_name,
 			&uname_len, &stream_name, &stream_len);
@@ -1088,8 +1089,9 @@ static int ntfs_unlink(struct inode *dir, struct dentry *dentry)
 	__le16 *uname = NULL;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	if (ntfs_stream_path_has_colon(vol, &dentry->d_name))
 		return ntfs_unlink_named_stream(dir, dentry);
@@ -1136,8 +1138,9 @@ static struct dentry *ntfs_mkdir(const struct mnt_idmap *idmap, struct inode *di
 	__le16 *uname;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return ERR_PTR(-EIO);
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return ERR_PTR(err);
 
 	err = ntfs_stream_path_check(vol, &dentry->d_name);
 	if (err)
@@ -1181,8 +1184,9 @@ static int ntfs_rmdir(struct inode *dir, struct dentry *dentry)
 	__le16 *uname = NULL;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = ntfs_stream_path_check(vol, &dentry->d_name);
 	if (err)
@@ -1349,8 +1353,9 @@ static int ntfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 	struct ntfs_inode *old_dir_ni = NTFS_I(old_dir), *new_dir_ni = NTFS_I(new_dir);
 	bool new_dir_first = false;
 
-	if (NVolShutdown(old_dir_ni->vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = ntfs_stream_path_check(vol, &old_dentry->d_name);
 	if (err)
@@ -1503,8 +1508,9 @@ static int ntfs_symlink(const struct mnt_idmap *idmap, struct inode *dir,
 	int usrc_len;
 	int symlen = strlen(symname);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = ntfs_stream_path_check(vol, &dentry->d_name);
 	if (err)
@@ -1552,8 +1558,9 @@ static int ntfs_mknod(const struct mnt_idmap *idmap, struct inode *dir,
 	__le16 *uname = NULL;
 	int uname_len;
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	err = ntfs_stream_path_check(vol, &dentry->d_name);
 	if (err)
@@ -1608,8 +1615,9 @@ static int ntfs_link(struct dentry *old_dentry, struct inode *dir,
 	int err;
 	struct ntfs_inode *ni = NTFS_I(vi), *dir_ni = NTFS_I(dir);
 
-	if (NVolShutdown(vol))
-		return -EIO;
+	err = ntfs_emergency_state(vol);
+	if (err)
+		return err;
 
 	if (NInoAttr(ni))
 		return -EOPNOTSUPP;
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 71f0aea46bf8..7e3a291f4758 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -305,6 +305,8 @@ static int ntfs_reconfigure(struct fs_context *fc)
 
 	ntfs_debug("Entering with remount");
 
+	/* Mark the volume dirty first if an error made it read-only. */
+	flush_work(&vol->error_work);
 	err = sync_filesystem(sb);
 	if (err) {
 		ntfs_warning(sb, "Failed to sync the filesystem.");
@@ -434,7 +436,24 @@ void ntfs_handle_error(struct super_block *sb)
 		return;
 
 	if (vol->on_errors == ON_ERRORS_REMOUNT_RO) {
-		sb->s_flags |= SB_RDONLY;
+		if (!(sb->s_flags & SB_BORN)) {
+			/* Before SB_BORN the mounter holds s_umount. */
+			sb->s_flags |= SB_RDONLY;
+		} else {
+			/*
+			 * Don't set SB_RDONLY: that needs sb->s_umount and a
+			 * proper remount, and setting it while the volume is
+			 * frozen makes thaw_super() leave the s_writers rwsems
+			 * locked. NV_EmergencyRO makes the volume refuse
+			 * modifications instead and NV_Errors keeps it from
+			 * being remounted read-write. The error work marks
+			 * the volume dirty on disk.
+			 */
+			NVolSetErrors(vol);
+			if (test_and_set_bit(NV_EmergencyRO, &vol->flags))
+				return;
+			queue_work(ntfs_wq, &vol->error_work);
+		}
 		pr_crit("(device %s): Filesystem has been set read-only\n",
 			sb->s_id);
 	} else if (vol->on_errors == ON_ERRORS_PANIC) {
@@ -557,18 +576,18 @@ int ntfs_set_volume_flags(struct ntfs_volume *vol, __le16 flags)
  * last one, ntfs_put_super(), runs after evict_inodes() on a quiesced
  * filesystem, so a volume that is read-write at unmount time cannot
  * unmount clean.  A volume that is already read-only when the error is
- * recorded (errors=remount-ro flips the superblock on the first error,
- * as does an earlier remount-ro) has no persistence point left and
+ * recorded (an earlier remount-ro) has no persistence point left and
  * keeps whatever on-disk bit it had; that behaviour is unchanged.  The
  * residual window is a crash between the error and the next
- * persistence point.
+ * persistence point.  errors=remount-ro keeps the superblock read-write
+ * and ntfs_error_work() persists the error state right away.
  *
  * This is the single point that persists the in-memory error state to disk.
  * The runtime error paths only record NVolErrors() because they run under a
  * variety of ntfs locks the dirty-bit write cannot be taken under (runlist
  * locks, vol->lcnbmp_lock, vol->mftbmp_lock, mrec_locks); a sync of a
- * volume with recorded errors, a remount to read-only, or the unmount,
- * then persists the flag here.
+ * volume with recorded errors, ntfs_error_work(), a remount to read-only,
+ * or the unmount, then persists the flag here.
  *
  * A hibernated volume is not written from these persistence paths:
  * resuming Windows from a modified image corrupts it, so the dirty bit
@@ -583,6 +602,25 @@ static int ntfs_sync_volume_dirty_state(struct ntfs_volume *vol)
 	return ntfs_write_volume_flags(vol, 0, VOLUME_IS_DIRTY, true);
 }
 
+/*
+ * ntfs_error_work - mark the volume dirty on disk after an error
+ * @work:	the error_work of the ntfs volume
+ *
+ * VOLUME_IS_DIRTY is set lazily and may not be on disk yet when the error hits.
+ * A work item because ntfs_error() may be called with mft records locked, and
+ * sb_start_intwrite() waits for a frozen volume to be thawed.
+ */
+static void ntfs_error_work(struct work_struct *work)
+{
+	struct ntfs_volume *vol = container_of(work, struct ntfs_volume,
+					       error_work);
+
+	sb_start_intwrite(vol->sb);
+	if (!ntfs_sync_volume_dirty_state(vol))
+		ntfs_commit_inode(vol->vol_ino);
+	sb_end_intwrite(vol->sb);
+}
+
 int ntfs_write_volume_label(struct ntfs_volume *vol, char *label)
 {
 	struct ntfs_inode *vol_ni = NTFS_I(vol->vol_ino);
@@ -2080,6 +2118,10 @@ static void ntfs_put_super(struct super_block *sb)
 
 	cancel_work_sync(&vol->precalc_work);
 
+	/* Let a pending error work persist the error state first. */
+	flush_work(&vol->error_work);
+	disable_work_sync(&vol->error_work);
+
 	/*
 	 * Commit all inodes while they are still open in case some of them
 	 * cause others to be dirtied.
@@ -2998,6 +3040,7 @@ static int ntfs_init_fs_context(struct fs_context *fc)
 	init_rwsem(&vol->mftbmp_lock);
 	init_rwsem(&vol->lcnbmp_lock);
 	mutex_init(&vol->volume_label_lock);
+	INIT_WORK(&vol->error_work, ntfs_error_work);
 
 	fc->s_fs_info = vol;
 	fc->ops = &ntfs_context_ops;
diff --git a/fs/ntfs/volume.h b/fs/ntfs/volume.h
index ed5c0ccb9cd9..1ce81b260b15 100644
--- a/fs/ntfs/volume.h
+++ b/fs/ntfs/volume.h
@@ -92,6 +92,7 @@
  * @sparse_compression_unit: Size of compression/sparse unit in clusters.
  * @lcn_empty_bits_per_page: Number of empty bits per page in the LCN bitmap.
  * @precalc_work: Work structure for background pre-calculation tasks.
+ * @error_work: Marks the volume dirty on disk after an error made it read-only.
  * @preallocated_size: reallocation size (in bytes).
  */
 struct ntfs_volume {
@@ -166,6 +167,7 @@ struct ntfs_volume {
 	u8 sparse_compression_unit;
 	unsigned int *lcn_empty_bits_per_page;
 	struct work_struct precalc_work;
+	struct work_struct error_work;
 	loff_t preallocated_size;
 };
 
@@ -198,6 +200,8 @@ struct ntfs_volume {
  * NV_NativeSymlinkRel		Translate absolute Windows reparse targets (native_symlink=rel).
  * NV_MftBootstrap		Mount is still assembling $MFT's own runlist.
  * NV_StreamsWindows		Interpret the final path component as file:stream.
+ * NV_EmergencyRO		An error made the volume read-only until it is
+ *				unmounted (errors=remount-ro).
  */
 enum {
 	NV_Errors,
@@ -220,6 +224,7 @@ enum {
 	NV_SymlinkNative,
 	NV_MftBootstrap,
 	NV_StreamsWindows,
+	NV_EmergencyRO,
 };
 
 /*
@@ -261,6 +266,17 @@ DEFINE_NVOL_BIT_OPS(NativeSymlinkRel)
 DEFINE_NVOL_BIT_OPS(SymlinkNative)
 DEFINE_NVOL_BIT_OPS(MftBootstrap)
 DEFINE_NVOL_BIT_OPS(StreamsWindows)
+DEFINE_NVOL_BIT_OPS(EmergencyRO)
+
+/* -EIO after a shutdown, -EROFS after an error with errors=remount-ro */
+static inline int ntfs_emergency_state(struct ntfs_volume *vol)
+{
+	if (unlikely(NVolShutdown(vol)))
+		return -EIO;
+	if (unlikely(NVolEmergencyRO(vol)))
+		return -EROFS;
+	return 0;
+}
 
 static inline void ntfs_inc_free_clusters(struct ntfs_volume *vol, s64 nr)
 {

-- 
2.53.0


