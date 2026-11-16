Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDCB606A792
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k7kWHuk0
Received: by kanga.kvack.org (Postfix)
	id E51E66B060C; Mon, 16 Nov 2026 06:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB4C6B060D; Mon, 16 Nov 2026 06:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA39E6B060E; Mon, 16 Nov 2026 06:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 940D66B060C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:10:27 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01B2480519
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:27 +0000 (UTC)
X-FDA: 85440713694.04.97F818A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4D4C41C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7kWHuk0;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONDS26Fc5ZAikzBy5Yq3BJDGMgD90Mtcybw+v7fvrMI=;
	b=0uWAYFN9vNqZWPxz7MDjTvD+ynYtLr0OKNsX7GP1RXA8tEJsmeOSziKccpYceT9M0Irq6k
	aYrY04PIsZ11JlP+gP609c6IRLlCz2mmwueG53hUYOu/o1QenARFKzbSL315kuGNVoXVlu
	q73bKi0Vm1R913YPbtDdqQDrljIB9M4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827425;
	b=tQXS9v2a7/jp0YQTNYpKV+KOq4akUwLi72G64spwcurqW3jcATlrZyn0m1PnefyBZQX2T0
	i5gBImb/VHi/eJRlE3qh5tcuVX365P8DJ4JW0HPy+RmANQMvejC7fR92Ah3AJYpeQt0PJ/
	4fAxplRU7aywu5LL5+ZQ/PKL3FuXb5g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7kWHuk0;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDCA662932;
	Mon, 16 Nov 2026 11:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F061F000C8;
	Mon, 16 Nov 2026 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827424;
	bh=ONDS26Fc5ZAikzBy5Yq3BJDGMgD90Mtcybw+v7fvrMI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k7kWHuk0vT1TU02u6FNnXUqb9m9PljW9HH7vb2QE/IgCRzadel7KvX8DtuilQwcGt
	 yc9BN5YAt3E2rq3hJ2IuK/1cnO5yBFpB5J/a/QYkEw3HWAJaGxBQ3b/nLndLrnjkQR
	 wes6PZ3bkDfTEdq0NHQdQhz/wfkgAEpiH8rIRcqvSHf+NIKem69czEwilAoCTqubWF
	 PdUa+rVjClCKEIl1BiVeB828bGW19Y3XLEM17DUuRIHtySa9jtiOqM3qJ4EAKDirz5
	 iYtgDTA48smqXWey1P5lvRxDKDFzobQ8FHnt/JwTp8R6w2fQIj02S3gzllm9EW4Ekp
	 5f5LtDGqnCZcA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:08 +0100
Subject: [PATCH RFC v3 35/44] fs: add file_check_backing()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-35-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5551; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QP5rfW7L1Yos2/x0K40PE01xt91j5V7LTt4ZJzVPG/Y=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etyuku+3S1tIM0eP1+SXfJZdp4pxm7nDn1Pqm/xOX
 PLuUTzeUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMBHD0wz/U31s969ybu+0msX7
 oVX5sFVRMLeRt+oa/QeKnJn+lys2MjKs83kTq/XL/fD051nzGfV2/y9wtJwrv2brTYVXVdu8F+Y
 xAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: t47cuojfznf6orq1uhaxzbixe9hqfyew
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4D4C41C0004
X-Rspam-User: 
X-HE-Tag: 1794827425-313211
X-HE-Meta: U2FsdGVkX18+JqDhijHVFlGNi6zJCUirXTj7TXhCYvFZBWFK7nyGrbDCw8EbqzPPAkHwW6BqnxGG/mLXqSFVKZ+DmxGT6jDskfWgCLp5kG0g8j7bAPDVxw3K2DkC7lzraLvQ5iDyJo2gqWF84v6Vlb2efEEvk0wVxdtH81dSlDHVs2Tnm3MGksAwRcf9V1AzNmyEk74nItwKCqiYaFO0mAutDx7rRcMlroqcJ3EAAp/s3oEKo8+2fbE72rDXREBKCgilvH1TqhpXCbv7FHnKqtTuE6sVW1JEZAv765rjtojw+q1cGeWaJEEO58nqqykypbWpXRkfxhk8tIfrRbV83U0LoKFVqjbvRB0CLqRPyq7eQV6n1WILQs6826yyhlL1tyAm+gLiXPsldLAC676uAIAL2Jfk1bHTr2qSQlel7sJcwqVfR7nZRIYLk22KqchmzYrnrYGDc7RkRRGrbj2F89iqv1UhWM95K+Os6rdJ/zOVOGvMmUtCE7iCDYj7kZuGv2EoNgFLM2iVZQWy6qkupS8zzPJwlVLQDgDQE9NNjdzeXArYcRuDqA/af4GIJShCkWx4rWxS52+lgDGqqbeNf8HzehkgOTJXzHwtenJIpiQ/qlQ/XRQKMD/13dKwHOUuPklvGFUsLN4bjPqpNCKcxYj1zsF/cIhsWa4oPY6gRWijzlUyDrRgglxQ2O1dX/fWLD1ZnH8by/qQ5FDC4h7Q1mP4Pj065DbL2XXUklp/02BskQ0AahMbQFaCdlwQTUxTNgr6BH07QzJyWwESzO/whAmUSVv/F417Pz1np08a3Uf0j9afKBf1dDq//7mpSzk3j3CzIZKQ7aaAp2vm1MBJF0UDWiSkeUxsVr6ADwY+pnWEGzaV4jGdyCTtkUiC4DDY25OmCU1TG82XCygUtiUBqkx8hKod/q8YVmWPf+tEgoV7JYttUwGvmqNhmiOXAvltQutQz+ZzFIx5bJC5cZ4
 4T4xQyW+
 0TdGckfiKb/+x18MPVeIATk52NRNGWsskllVgQkBw+tJcjpQQBKQDKPnLoU4vxrbZEBBgCwlOGJdTEv40Ypjv3d0inRGjkTY8N0as+9JpPMHPQQyBSSG4uExcZ2aqA3uvx9aHItM0ZlZNda86YotGRIU9CkSDhWaD+6qKqTHoalZnMeNnGHiP8Z8px9aWEKhYgl7NNSpAqRQlAqQjhHKwbmYPl4SKlmdWILv1kzGYIzwGlIiJSom0GoswCkYShh2Hq3oekL70PmBQx4GKoqhM/2fD5OH7W0SfwDhtfqiyQ9AxX4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Loop, zloop, the nvme target, the scsi target, fuse passthrough, the usb
mass storage gadget, erofs and acct all take a file from userspace and
use it as storage. Currently, each of them has its own idea of what to
check before using a file like that:

- loop and the gadget check for a regular file or a block device, the
  nvme target, the scsi target and zloop take any file type
- loop checks the open mode, the gadget checks FMODE_CAN_READ, the nvme
  target, the scsi target and zloop only check for ->read_iter() and
  ->write_iter()
- apart from acct which refuses procfs and sysfs files none of them
  cares whether the file is a kernel interface

Add a helper that does all of it in one place. It only accepts regular
files and, if the caller passes S_IFBLK, block devices. It refuses files
on pseudo filesystems. And it checks that the file is open for what the
caller is going to do with it and implements ->read_iter() for reading
and ->write_iter() for writing.

O_PATH files are refused unless the caller passes FMODE_PATH. That is
for callers that only need the path of the file. fuse passthrough is
one of them and has accepted O_PATH file descriptors since commit
efad7153bf93 ("fuse: allow O_PATH fd for FUSE_DEV_IOC_BACKING_OPEN").

Block devices are fine even though bdevfs is a pseudo filesystem. A
block device that userspace hands in is a device node on devtmpfs or
some other filesystem. Files on bdevfs only come from
bdev_file_open_by_*() and never end up here.

The pseudo filesystem check looks at the inode that actually provides
the data via d_real_data_inode(). overlayfs accepts sysfs, cgroup2,
debugfs, tracefs, configfs and securityfs as lower layers and reads of
such an overlayfs file are served by the file on the pseudo filesystem.
Checking the overlayfs inode would miss that.

For an O_PATH file nothing might have looked up the data yet. overlayfs
only looks up the data of a metacopy file in a data-only layer when the
file is opened. d_real_data_inode() does the lookup then and if that
fails we return the error.

Note that the file type is taken from the inode of the file and not from
the host of ->f_mapping like loop and the gadget do it. A driver can
point ->f_mapping somewhere else in ->open(). It makes no difference for
block devices as both inodes are block devices.

No functional changes. Nothing calls the helper yet.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/read_write.c    | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  2 ++
 2 files changed, 55 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index 6767283108991..9f1e7bfcbd4f1 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -866,6 +866,59 @@ static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
 	return ret;
 }
 
+/**
+ * file_check_backing - check that the kernel can use a file as storage
+ * @file: file that userspace handed in
+ * @mode: FMODE_READ and/or FMODE_WRITE the kernel will do I/O with, or
+ *        FMODE_PATH if only the path of @file is used
+ * @type: S_IFBLK if a block device is fine as well, 0 otherwise
+ *
+ * Call this where a file from userspace is taken as a backing file. Only
+ * regular files and, if @type is S_IFBLK, block devices are storage. Files
+ * on pseudo filesystems are kernel interfaces and are refused. The file
+ * must be open for @mode and implement ->read_iter() for reading and
+ * ->write_iter() for writing. O_PATH files are only fine with FMODE_PATH.
+ *
+ * Return: 0 on success, -EBADF if @file isn't open for @mode, -EINVAL if it
+ * can't be used as storage, or the error from looking up the data of @file
+ * on a stacking filesystem.
+ */
+int file_check_backing(const struct file *file, fmode_t mode, umode_t type)
+{
+	fmode_t io = mode & (FMODE_READ | FMODE_WRITE);
+	/* Drivers may point ->f_mapping at something else. */
+	umode_t fmt = file_inode(file)->i_mode & S_IFMT;
+	struct inode *real_inode;
+
+	/* O_PATH files are only fine for callers that just use the path. */
+	if ((file->f_mode & FMODE_PATH) && !(mode & FMODE_PATH))
+		return -EBADF;
+
+	if ((file->f_mode & io) != io)
+		return -EBADF;
+
+	if (fmt != S_IFREG && !(type == S_IFBLK && fmt == S_IFBLK))
+		return -EINVAL;
+
+	/* Look through stacking filesystems at the inode with the data. */
+	real_inode = d_real_data_inode(file->f_path.dentry);
+	if (IS_ERR(real_inode))
+		return PTR_ERR(real_inode);
+	if (real_inode->i_sb->s_iflags & SB_I_PSEUDO)
+		return -EINVAL;
+
+	if ((mode & FMODE_READ) &&
+	    (!(file->f_mode & FMODE_CAN_READ) || !file->f_op->read_iter))
+		return -EINVAL;
+
+	if ((mode & FMODE_WRITE) &&
+	    (!(file->f_mode & FMODE_CAN_WRITE) || !file->f_op->write_iter))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(file_check_backing);
+
 ssize_t vfs_iocb_iter_read(struct file *file, struct kiocb *iocb,
 			   struct iov_iter *iter)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99caef43ff3c4..b1c7ebafbadbe 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2553,6 +2553,8 @@ static inline const struct inode *file_user_inode(const struct file *f)
 	return file_inode(f);
 }
 
+int file_check_backing(const struct file *file, fmode_t mode, umode_t type);
+
 static inline struct file *file_clone_open(struct file *file)
 {
 	return dentry_open(&file->f_path, file->f_flags, file->f_cred);

-- 
2.53.0


