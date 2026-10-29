Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621EF606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ov6yHIEg
Received: by kanga.kvack.org (Postfix)
	id 845636B05B2; Thu, 29 Oct 2026 12:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CB66B05BE; Thu, 29 Oct 2026 12:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70BCB6B05BF; Thu, 29 Oct 2026 12:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 426976B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:07:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF08F120449
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:07:32 +0000 (UTC)
X-FDA: 85376143944.01.8879604
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EDE5DC0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:07:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ov6yHIEg;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsodWLg6d4leaTd8y1mFAnryBLI0o8mneeaJ96WpEgw=;
	b=aZ1DbEtBQGN32+uQuI/XKHWBl/XifUdXqb0uoUa/6thEN1uhKMqbJ22wzpazQulbohgHUu
	ziqBhgbKqPp80C2g1oHhFPXcnrM7I5dG3e79CGWS4yqcYJYv52sVQNcRQ2+dbCa1XmKiMO
	28OO30odqCkBlINeuMzB7UXmwzYjKQA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ov6yHIEg;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290051;
	b=ZEayewv3YklvcRz8aXwhLo/tAGapopl9PSy3d70OF/U6N0v1ifYbCnUR4ZWiAU4rCL+bme
	vT3ANVQ0wg74u7gqQHvY0sewlgjxVuwHzp7b6Z35evoLZwpTaLarZRHr5Kc9YoByOkL9eY
	t/ovBNV0B5928DwbS6LqyfIB46TRNqc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCA0840308;
	Thu, 29 Oct 2026 16:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34131F031E3;
	Thu, 29 Oct 2026 16:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290049;
	bh=AsodWLg6d4leaTd8y1mFAnryBLI0o8mneeaJ96WpEgw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ov6yHIEg2RVAwCeDDw6SBsSA7/QgZf/B5/RZ+PrMyoNOlA2ZFmSH/HKL8sVmK2f7b
	 paPyD9rKVu3SoDYAvkbGdQ60kGw6aE4htgXVTuYKQRynd6t9zK3zIdBZsV9v85O8Mj
	 2ZRTQUuihevFeV6XRWctzeju09DfAgoRcuUFzl7KLn0bTZ7zPJjn6OOgakAvdaM7a6
	 QgnFcumIS838qomnB///YdjPCH8tNlkCX/+WJs2K/GYt484cIeqBWgwy3q387QZMzR
	 MaytrDuBlhRxSOEioOdPv+FD/AbxS2zlbH2JtGCuu9f/zNnLX4OROrSaartpR5wSz7
	 ePpSVjFpYsTjQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:53 +0100
Subject: [PATCH v2 02/34] ecryptfs: fall back to a read-only lower file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-2-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4207; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Q9NmeDgR8pX/q3aRMUMx4MDSxJG0gbR0HOUiW8m3gzc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztfzO7FQbbLu/eafPDoTRBe/dTCvTTqz75Umw0rlj
 8vT7LfodZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExE9ADD/xz3jHfC+/K/JTn4
 /Fys/Ot5co9KRsezW9Hf8yvtHtzck8rwz6Js96wDArEOB9apt5RemxK6a57UmabMmXI9J/+ttQ8
 p4QMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EDE5DC0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 14so8cw9nfcssurwsddsqyrjm6xiubir
X-HE-Tag: 1793290050-326790
X-HE-Meta: U2FsdGVkX1/xV9QHstW6j+Y1FOui5IkiBP8odoClG+h72NE0X+Lv6L2oLDqsgVq40I/YJMQhS/g/8v8xXYnRvlufd14rLEW+EJ/zruWospwvas7lLRMV9Hr575fUCQPcMG75czPTmHf5AgYSVRMyfEQkdxfJ2mxRa1nxUmVuFl0ms7PsYeS1oMFaB8S/X7rwVUbjwpi4eWOKJ1NPwAvQbEqfXVaJlpUmMkTdVce2mFiJcLod6bMkuw8TDOeM7FWKwlKPhIwh55rdaqvAz5Uu9jpTsUsMiC0cuaXnmqDyf8pc6lK4Rk9uSP2i/K3+3rM9DFbAxSckrscVbY/vbIRiHGPFF/a2zEidBoB/VaUP0WTy2bI123goqfkNRtxIF1UnzQRWPUmNjdYybrHhKhPDsez7MygiscVsyb7nk3zqgW3fM+dVxkU15it/BXeVAv6mblDo6kd6gDDvS43G/w3c+6b/2gadgTYZ8wgWxZGlWi7ZJB5jcE3i7n6N6E5n0i6nc2XeoT99BiT0DeY9ulS/bQ0Cgg8mUp9ATU3m7kY1uLkxYOt6xBvHC86ML4pQNirceYkzyG1zNd70zroF7zrxVBBPtiESx0pg9WnB4laYAFbccFGNaOVrW6hjW/L86orFZuIJ10P1FwTrFy8rpQvAUTMCi7u9Z+eXdZ3LYAzuID3qUgZ8jZ2wZBg+f6eWOuO2bYAVF5TjPrb1w/msaeVk91e+jGywU0ixQpBWJ//iLldpmrAOZCvpcI2jnVcntoM5egRgL8VMZzPNTY3i3LerBQiKilCSZGmIbLz5DGH0cl5MDkTdARaC5NS5aBeP/3h3N0k0SJVxaaftQ4PS9a3XNCZgJ3zLCje1C0LJAp+r87BpAU3LM5be7ix1VdAvhaYXHDXxo+511i4upYLUw7cVEh63XL8TG5mAQ2DqkRyHjHiq/6s1+BAIQoQAmiBi2QvSKLc0jFKyLAYNYy8Yti+
 R7M1b7oZ
 hf+V9LVTXhLBSOmxeCK1/8hH9SQAyDHz0rL3FfEJc4eu8fJ2gH+cmA2Wps5jEpGzbKam7M5mZBdLMDxRAZpCsLQ20SKoggYP1zFjOdJN2HnvbmEGmc20TLXDIJNL7Ux9uFkY31lCvwtMCN41j4CynZbb4WoHNP8TIKnudTRzxV2DzCJhsAoPcUwyDwbckGCJedEJkJIsZ4S/XqPMCv/rPrurvY+rX8Guis9nXR05qJ+Zp9+8UXMLtxoAbdNJUff6cY7b1ZrHVXu4IDrbU1cTzJT5Mt8q86fFI7FS1
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

truncate(2), creating a file and opening an empty file still write to
the lower file and would trip the WARN_ON_ONCE() in
__kernel_write_iter(). So let ecryptfs_write_lower() and
__ecryptfs_truncate() refuse that with EROFS.

Note that ecryptfs never takes write access on the lower mount. On a
read-only bind mount that was only a problem for directories so far.
With this regular files can be unlinked and changed through it too.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ecryptfs/inode.c      |  8 ++++++++
 fs/ecryptfs/kthread.c    | 15 +++++++++++++--
 fs/ecryptfs/read_write.c |  3 +++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 3a966348a578..35afb94143b8 100644
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
index ae4cb4e2e134..d381d56baa90 100644
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
index b3b451c2b941..b3956ae50ff6 100644
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


