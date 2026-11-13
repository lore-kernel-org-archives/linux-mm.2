Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9165860A3804
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQlbwT0U
Received: by kanga.kvack.org (Postfix)
	id 55BBA6B06C8; Fri, 13 Nov 2026 07:00:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CE46B06CA; Fri, 13 Nov 2026 07:00:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422F56B06CB; Fri, 13 Nov 2026 07:00:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2429C6B06C8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:00:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF325801A6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:30 +0000 (UTC)
X-FDA: 85429953420.22.126F953
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2E41160010
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQlbwT0U;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWzXWzq1v3XoYX3vwCfbSUj0i+mCKEVSA6Mgkp1L8Uc=;
	b=eDMT5TajwiS7LLKmzU7ccOjd6dvcXmOWNK/3xGQBNoJkJKdscojPMFVMEMELc1X/oYzR1e
	xFiI1imCx+ENZ5HuB9NiU/E78US4BSBD3smZG5RK7Xbfx82WO7t6Yi4qe0PvD4JkM3LXvk
	WwWrQ6KL8BpNtE3Y+q+0/xShGvdwsgg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQlbwT0U;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571228;
	b=c4vlBG02HUcAooKXsjnignLl/Et7Pec7SGNxrU5rALiZ8RhbzfS748h+jOYhICwOjLbKWj
	q2+XaEk+nl/CkoLw7EdbxVCZtkKzhmfyMIkqLCVd/jrQdrm17E2hv9HfNA6kuRu9TjBvtQ
	Q8MFq5c3hFQEwIltAa5nM2frEUW5GlU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BB1143098;
	Fri, 13 Nov 2026 12:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475E51F000C6;
	Fri, 13 Nov 2026 12:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571228;
	bh=kWzXWzq1v3XoYX3vwCfbSUj0i+mCKEVSA6Mgkp1L8Uc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IQlbwT0U22yZRhpbmLVl+YLgOuwLPGZNu8Jjr5LWoleO6zccNYti5Oe0o1F24oMRH
	 nc2LWwniww4QkKJ3d052ea5oSbqw2zpR4Zs2HsjQGBWfGPcg1hq3Cm3Nk6dNoiAb2w
	 tDsUh29BL4Q3Q3NdzxBFF7dVcY1x/t7DpJQBdnSxUxz5mMBbVLM7hGleT7083sY7OP
	 amZrUNXUtFcI6GxvtNJsjC7QQJPlruHnr96mhlpOZ7i4fBJHOJfQwSJIjgaqb/SJ7B
	 IycFfQGEpHbkoBSsenJp5oAVw9oT7Nra81YI83OQgZJtnh5XK1VF4A5719NEG6Z2f/
	 M8/IpuFceU24g==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:00 +0100
Subject: [PATCH v3 04/33] ecryptfs: fall back to a read-only lower file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-4-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5054; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6aWyDCVSWKskTQggaDwc4XmhKC4rMH1xBzHPr2v1ST0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+z1P4eXbLA8XNWndlvsJFkUvfm9iihR6dv0vT7CZ4
 MUDPueud5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEIo7hf943jfsXNOLyl37m
 Ewq5q7kk/IEVb5GC+dk85kZBBQXjGYwMH/7t3rpDMXBV2pkLd8ydjt+v/TVpVctH1UdCsob6pfy
 neQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 137cjehixd9yukerrroeyhynewj946d6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C2E41160010
X-HE-Tag: 1794571228-722679
X-HE-Meta: U2FsdGVkX19OmjLKSwa8fpHyt/Wi21c1R07XV5FpTvchTZXeg09LTafa5IcueYEZddT8WLf0RjtwwEzCYUiRdtJdo/DcvxAWsblOeguBAj28WXL/bPs3sj9roQrd9Fi0wsaoaWGT2SLQtXDoSUQpXZsAv2ObdAcGRdM7CfeGPIPY4e3fucw6gmnD3KAfJsgedVeAExywqtlAcOWQlAkZ76wDlD/fo8Vs5N5+PWTcPvQqTv/Fe6MH6fdXmTpA9nnWD//UXNB3tss77PcYP4Bu13vkYdhO0Odw/wdNkNlB7gYKd7PpWVLyJ2Bp6SJCFvYL0GwBijwIfZ/x4qHhUrGbzMqEwdRuNe/dJCHgdO1DIHse5FuJBPI1/BhtlAhkycLzK1gT+j1+yGt+osJG7fHLgKdBSlDbYv815P6VINAempA3ca5TvfyxgCiblhhrLVI/Lm3nzlDtzai9sIvFNQApUTn6YDf9vV2UVIJSUT1YMyEDvfeBWm7HCLWGasmT0Oy4MoK9WtDYIn+g3+cJvO7u1lzCqpAYsUv82HgjVC4fvBeWHspEnw+xLiXknb9eg0Bil+IAkvLsN37XINfDALjT+9vBn8n30QgKiQyKxYdva8W51WJkwQzNhJqB9wJ6wjAdrqDRc/PzriM/4nO8ll06vVBDAp0gZ2agiFNyLdUWcxRGb/m8Q1sdVjYwERjofr1RsattolemkwVTgQIWrB9lWgQha8qfjNZhKKeVrNGXqbgO17UfE5aQQFy95A578F4dJIA1xQ8RVIXu7HcXiTqN72XESCmZHpGGidLkJ+5iuQPWw2omi01gQDFtdndqflOxmRhec7Z0texWVq8BGwQnVoiLkqvVZ6IS8Cuv/irKs28DYOjWIMvwjYtoNhauWmqj7CpPme8DOFOsbrQOwdTje61GsqIIK2OwM1egwRs4+R/SWwAErlN/FLSKcTCIHIcbfIa+2nQXG0EUrjG/UHP
 VXyghk5p
 G1qCDrNrF6ap0RAxrYXYaf+CWiihy5FDe1o7r4Jqz0rpicTbG4Yue/9pldBi3spoVhRa78UGGDFvKfKorKKCfgUUGEJWWpgmcytcajI4k1KKhldkrQXCviH0kx4Rdkf6u0TnxLuFKxYi+UfQFUQBVUTgRxBi9ovChGBEk6alHssCbu+8kA83/olQP/zEwo291VI3Y0wmenrn9o7yT3OBTfU31k0M9RqRURjqv0Rl9KGkw6SQXvT9HXfNzu/O5bfNrmdSZTV3nXpRJ1j7o7LXpFopRNIsuBM5oSvHC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ecryptfs opens the lower file read-write unless the lower inode is
IS_RDONLY(). A read-only mount underneath refuses that and so does ext4
after an error since commit d3476f3dad4a ("ext4: don't set SB_RDONLY
after filesystem errors"). Then every lookup of a regular file fails
with EROFS. The other filesystems are about to behave like ext4, so fall
back to opening the lower file read-only. Opening an ecryptfs file for
writing then fails with EPERM like on top of a read-only superblock.

truncate(2) and creating a file still write to the lower file and
would trip the WARN_ON_ONCE() in __kernel_write_iter(). So let
ecryptfs_write_lower() and __ecryptfs_truncate() refuse that with EROFS.
Opening an empty file doesn't try to write the header through a
read-only lower file at all, read_or_initialize_metadata() skips it and
the open fails with EIO.

Note that ecryptfs never takes write access on the lower mount. On a
read-only bind mount that was only a problem for directories so far.
With this regular files can be unlinked and changed through it too.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ecryptfs/file.c       |  4 +++-
 fs/ecryptfs/inode.c      |  8 ++++++++
 fs/ecryptfs/kthread.c    | 15 +++++++++++++--
 fs/ecryptfs/read_write.c |  3 +++
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 49b0fbe0428a2..626de51e7dba5 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -170,8 +170,10 @@ static int read_or_initialize_metadata(struct dentry *dentry)
 		goto out;
 	}
 
+	/* The header can only be written through a writable lower file. */
 	if (!(mount_crypt_stat->flags & ECRYPTFS_XATTR_METADATA_ENABLED) &&
-	    !i_size_read(ecryptfs_inode_to_lower(inode))) {
+	    !i_size_read(ecryptfs_inode_to_lower(inode)) &&
+	    (ecryptfs_inode_to_private(inode)->lower_file->f_mode & FMODE_WRITE)) {
 		rc = ecryptfs_initialize_file(dentry, inode);
 		if (!rc)
 			goto out;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 3a966348a578a..35afb94143b8a 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -741,6 +741,7 @@ static int __ecryptfs_truncate(struct dentry *dentry, const struct iattr *ia)
 	loff_t i_size = i_size_read(inode);
 	loff_t lower_size_before_truncate;
 	loff_t lower_size_after_truncate;
+	struct file *lower_file;
 	struct iattr lower_ia;
 	size_t num_zeros;
 	int rc;
@@ -771,6 +772,13 @@ static int __ecryptfs_truncate(struct dentry *dentry, const struct iattr *ia)
 	if (rc)
 		return rc;
 
+	/* Fail before zeroing the page cache, see ecryptfs_write_lower(). */
+	lower_file = ecryptfs_inode_to_private(inode)->lower_file;
+	if (!(lower_file->f_mode & FMODE_WRITE)) {
+		rc = -EROFS;
+		goto out;
+	}
+
 	if (ia->ia_size > i_size) {
 		char zero[] = { 0x00 };
 
diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index ae4cb4e2e1348..d381d56baa90b 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -30,6 +30,17 @@ static struct ecryptfs_kthread_ctl {
 
 static struct task_struct *ecryptfs_kthread;
 
+/* A read-only mount or a filesystem that hit an error refuses O_RDWR. */
+static struct file *ecryptfs_open_lower(const struct path *path, int flags,
+					const struct cred *cred)
+{
+	struct file *file = dentry_open(path, flags, cred);
+
+	if (PTR_ERR_OR_ZERO(file) == -EROFS && (flags & O_ACCMODE) == O_RDWR)
+		file = dentry_open(path, (flags & ~O_ACCMODE) | O_RDONLY, cred);
+	return file;
+}
+
 /**
  * ecryptfs_threadfn
  * @ignored: ignored
@@ -59,7 +70,7 @@ static int ecryptfs_threadfn(void *ignored)
 					       struct ecryptfs_open_req,
 					       kthread_ctl_list);
 			list_del(&req->kthread_ctl_list);
-			*req->lower_file = dentry_open(&req->path,
+			*req->lower_file = ecryptfs_open_lower(&req->path,
 				(O_RDWR | O_LARGEFILE), current_cred());
 			complete(&req->done);
 		}
@@ -132,7 +143,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	 * lower file is fput() when all eCryptfs files for the inode are
 	 * released. */
 	flags |= IS_RDONLY(d_inode(lower_dentry)) ? O_RDONLY : O_RDWR;
-	(*lower_file) = dentry_open(&req.path, flags, cred);
+	(*lower_file) = ecryptfs_open_lower(&req.path, flags, cred);
 	if (!IS_ERR(*lower_file))
 		goto out;
 	if ((flags & O_ACCMODE) == O_RDONLY) {
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index b3b451c2b9410..b3956ae50ff66 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -33,6 +33,9 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 	lower_file = ecryptfs_inode_to_private(ecryptfs_inode)->lower_file;
 	if (!lower_file)
 		return -EIO;
+	/* ecryptfs_open_lower() may have fallen back to a read-only file. */
+	if (!(lower_file->f_mode & FMODE_WRITE))
+		return -EROFS;
 	rc = kernel_write(lower_file, data, size, &offset);
 	mark_inode_dirty_sync(ecryptfs_inode);
 	return rc;

-- 
2.53.0


