Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2DE6D1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370D06B0089; Thu,  8 Jan 2026 12:13:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AB56B0092; Thu,  8 Jan 2026 12:13:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2103C6B0093; Thu,  8 Jan 2026 12:13:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10D356B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:13:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0361B6FFB
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:13:52 +0000 (UTC)
X-FDA: 84309443904.17.21EF165
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id CE42F1C0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:13:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=niOHr0KO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892431; a=rsa-sha256;
	cv=none;
	b=S2/HqcrxoJswIsgvS9f1MHkuDbOolizBXKHw2eRHWTi0sb/dzF5SDCWsaN+PXM0FRAXVm5
	2quUjhxGhrnbFM5miHmg/MpSK11oj8fKeTyGzWeWQNTs7k8D7ckZm5F3J1IyWuN6BtgVNO
	3iuQuY7LNSqFtw8I0L15AdEbO2E9fBA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=niOHr0KO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RuAZBJ1oaIr11Ri/QyKum/SHXSmRYb3aBEBbC54Mgw=;
	b=t2gJI5fg291MV8CYMl6obXWveSzd5xOh3WkddpNBm8xXMQT0xU69zojqSp3YCBCFfDUP62
	E4/WYhPk6SwA791404tNrE03LPVZZ0WCLaNqvdgpqEJlANEUhoIoi9iEVMFbRPK4Fdla4B
	9kb85xZyu1JsTfOPAvyAryem/6FNDIA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E862D42A85;
	Thu,  8 Jan 2026 17:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785E6C116D0;
	Thu,  8 Jan 2026 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892429;
	bh=q6ECGD1+wntgmlJSkidx4XZzYvMNc2stbnRPzbVswr4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=niOHr0KOpKsPbW3zcxSPJ4+HdeaSJcF9n2piB+6bV/P08brOPZY60SMqx3j4YVoxN
	 HY23AKzQOBHv5xbyCZODtdGvk8Iyuq3I5ZhrhCWp660sKVFvTkxAtvo6+2zeBPFcwG
	 4+6DEmOnuyk0FwVI8/H5Oeq3cw+B1HbnX3m1q/5DUy6tvj/EncQX0MDAdhOTB66vc6
	 Wa9Tx54LFEZPpTtzwjNRcJGznRwseKdLJWb0bgDU2EpAXO0/KhhvkoQcHVprarCLt0
	 WqAdXqVBexp4OOG3pfKO1KsQRyYLMdnkS6aXHz6qetxafVfPy72aJqgerrIX0uQpWw
	 vTe+PlRm/5SWg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:12:56 -0500
Subject: [PATCH 01/24] fs: add setlease to generic_ro_fops and read-only
 filesystem directory operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-1-ea4dec9b67fa@kernel.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
In-Reply-To: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
To: Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, 
 Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
 Anders Larsen <al@alarsen.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.com>, 
 Chris Mason <clm@fb.com>, Gao Xiang <xiang@kernel.org>, 
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
 Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
 Dave Kleikamp <shaggy@kernel.org>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, 
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Phillip Lougher <phillip@squashfs.org.uk>, Carlos Maiolino <cem@kernel.org>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
 Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
 Alexander Aring <alex.aring@gmail.com>, 
 Andreas Gruenbacher <agruenba@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
 Bharath SM <bharathsm@microsoft.com>, Hans de Goede <hansg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
 linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-mm@kvack.org, gfs2@lists.linux.dev, linux-doc@vger.kernel.org, 
 v9fs@lists.linux.dev, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6119; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=q6ECGD1+wntgmlJSkidx4XZzYvMNc2stbnRPzbVswr4=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W41MOFgO/l+aT/aQwWX6yzbWOrQUKMswYuC
 zwZ2N9iXuiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/luAAKCRAADmhBGVaC
 Fc7AEACr9C8Ts1FHYxAV8eYFq/mC6r3sgpT223unPjZiBqz0cBsE48A5R7g72u/qZwI83UTRJF1
 g0MThJcrJK2E67pZ+ZvH8T3pO2h3PKpZByut4pMdDc8HFu7Yytrz4TP4WTMD62O7eYsJLYX6N/g
 pNJ/yInFtIXZh/ysUQ6ruiczqr2LE06/01Cf7KHTZVDG+G9inw6x4jFdDmSSgmQEXxNbPFAnm1i
 TgiitrIv/g4OhfQBM9zycsFeMu1SX9hfL6aOgOJarrjgsuxErQqzjXDBvaP+/YDMkCvZdzQZHyK
 nYQkswujJYOnEZcN0GTnt7/8m6ZBIAhUwh+nh8MYp0nCy12JubPVU2a/DX2wx0bZfk2a0Tu9Uho
 INAlRmB9YHbI2XPziMpPuiHI7g4ALElxl1m1ttn6R+GBgUA0AMVmTG6gelfYyj/rAH36IO0XVtS
 W6o86sMi3zO5pVCs2ZU900ZMlh3Yq7+5XqW9e8IBoXGdhYHhyGqpN230Ws7usZnX7z1HUTdv0Og
 XQ00tTVueb23oPg9kHXoZNX9PdtOiilCirAcLAR9thMLLcvseGbqs+0AOBhOtr0jE0WUMqKewyr
 uMMPrn0ZRNxO4H9IhY13VzMbiPyBRz3WQFMnJi1DPqkZyCT8E4GaBKIGAJ/hhC4vg9x7K3AouKM
 MjNXCZhce9Ynapg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: 5z5c5trap3r6q9d3q155ooengy41w9au
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CE42F1C0005
X-HE-Tag: 1767892430-867500
X-HE-Meta: U2FsdGVkX18uNCdyfFjXKw5XkEXzEJl0skJIYIGVTWRNPAaVM10F1/TDuaQtGipvS29mTxYVS0pdfiD+X45fQSI2DlXe1wgY6xKzGozOBPR8zbeJGDHHil1c3358/naHgki5kUSnEGHH9Bpw4upuFyaqarPs9YjfNH6m7airivmcAkI7s34O1LY8KYYUgo9NZLVQcn2lLoHWMII8gZKwubaaFPgbl6yZ8flRj5pcaveF8ymPbp8UkeXY9G6MVHeby6A6zhlW9wPJyZi/K8x5IoqoJkgPCFHTm3ZS4o51QoZxkUPJhATWAYjM+aXUFL4WgKgKOLbnhQYqYIyM8ibFaaTF2HYQr9owKv/4vJx5cLE7gRcpkOrCgoSzdAej+aqdX1UP5G7SnAoFirGQ1zhjIpgRlwGD3s67yoUEcE2x1sd2sS7rywPmxKTjUX6UEC+btvssY7T46CS0WL+5o18Kflew+ePyV0FhEP7nbWycd+8maj+Lpl+RZyRFa+xhTvS5cDoAwcuDf8wt1+z+5yChwzWtdhLEv4mmvhGO4hTW7tZSbt1D6dQ3xJRSmvxhW8wmlVgNDD0W094H9uUaE/ZUBgsoSc77Q+c5T9wixhlbw4VZAGAsXk9vlA0sjlP7GubSmBCTAIr+qRmICkRj849eGY5bosM2yLaCrIzG8P2RVQ9r47Vqnq9NGOtkM1FU8rsNsRDylQz/gAMCLswpplSdGN54mWGkfkGtcYWBdMOQhxmDUZJQvU5xKFk0mW6xQBH3xA9cQb3ML944KgIkllRMcuNWmmheBRC/xWhe14nX/YFi+rc0r/BWiyNpewMe3bOGYG8NTsBsNR5pVdpGgaqbKYA+WQcQ3OcX6lTkbSwa5O/HSJxvsZRK3ZFPY4TL56+kuCxF91mLBu4vP6l3fa00wGBD98bbTS7RwaigmHrTIqGuiqsqR+dXI6Mr/6QK4Nic+3Ku+a/h9HJhW3dPcyi
 vVBQ2gl3
 PjHFnpSzS1Xo7i7sYP2VjPx4WxwIUA4MgIsd52HUsiY0sN5SKR6edq1x+iuVwAstxDQua4zSVFY/SqJLu5Bx4oXq8v34IU9NgPZ4G3YGA7jhPVrBQdid/YRDtYsD+zNZ+VM7gBSYGmiOcWrZR3ysCvqy1WUrh4V780VeLH59NUoNc1jrKzjSqURCCDYDowl1IIPuoAH+e07BkbtSRgyDJQMAIMdhcwItM/CSykH1iRlenHHAFbs8qf8OaiM4gePKusjxtPth/J1gzNFxXXfOVQP+2LX9CrFUsrGC+aY4nx2p7jqjE7pkFGBB6vOhtV0Clp6Wb0rLk6ba+glrF8IqaJxHsvT8mpTJakQxBik8Gk9fyH6Kiu9Toa2Bc8gzyON3Z0B2HFjhSnOP24ns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to generic_ro_fops, which covers file
operations for several read-only filesystems (BEFS, EFS, ISOFS, QNX4,
QNX6, CRAMFS, FREEVXFS). Also add setlease to the directory
file_operations for these filesystems.	A future patch will change the
default behavior to reject lease attempts with -EINVAL when there is no
setlease file operation defined. Add generic_setlease to retain the
ability to set leases on these filesystems.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/befs/linuxvfs.c        | 2 ++
 fs/cramfs/inode.c         | 2 ++
 fs/efs/dir.c              | 2 ++
 fs/freevxfs/vxfs_lookup.c | 2 ++
 fs/isofs/dir.c            | 2 ++
 fs/qnx4/dir.c             | 2 ++
 fs/qnx6/dir.c             | 2 ++
 fs/read_write.c           | 2 ++
 8 files changed, 16 insertions(+)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 9fcfdd6b8189aaf5cc3b68aa8dff4798af5bdcbc..d7c5d9270387bf6c3e94942e6331b449f90fe428 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -14,6 +14,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/errno.h>
+#include <linux/filelock.h>
 #include <linux/stat.h>
 #include <linux/nls.h>
 #include <linux/buffer_head.h>
@@ -79,6 +80,7 @@ static const struct file_operations befs_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= befs_readdir,
 	.llseek		= generic_file_llseek,
+	.setlease	= generic_setlease,
 };
 
 static const struct inode_operations befs_dir_inode_operations = {
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index e54ebe402df79d43a2c7cf491d669829f7ef81b7..41b1a869cf135d014003d6bf1c343d590ae7a084 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/filelock.h>
 #include <linux/pagemap.h>
 #include <linux/ramfs.h>
 #include <linux/init.h>
@@ -938,6 +939,7 @@ static const struct file_operations cramfs_directory_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= cramfs_readdir,
+	.setlease	= generic_setlease,
 };
 
 static const struct inode_operations cramfs_dir_inode_operations = {
diff --git a/fs/efs/dir.c b/fs/efs/dir.c
index f892ac7c2a35e0094a314eeded06a974154e46d7..35ad0092c11547af68ef8baf4965b50a0a7593fe 100644
--- a/fs/efs/dir.c
+++ b/fs/efs/dir.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/buffer_head.h>
+#include <linux/filelock.h>
 #include "efs.h"
 
 static int efs_readdir(struct file *, struct dir_context *);
@@ -14,6 +15,7 @@ const struct file_operations efs_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= efs_readdir,
+	.setlease	= generic_setlease,
 };
 
 const struct inode_operations efs_dir_inode_operations = {
diff --git a/fs/freevxfs/vxfs_lookup.c b/fs/freevxfs/vxfs_lookup.c
index 1b0bca8b4cc686043d92246042dcf833d37712e4..138e08de976ea762a46043316f27e9a031f60c32 100644
--- a/fs/freevxfs/vxfs_lookup.c
+++ b/fs/freevxfs/vxfs_lookup.c
@@ -8,6 +8,7 @@
  * Veritas filesystem driver - lookup and other directory related code.
  */
 #include <linux/fs.h>
+#include <linux/filelock.h>
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
@@ -36,6 +37,7 @@ const struct file_operations vxfs_dir_operations = {
 	.llseek =		generic_file_llseek,
 	.read =			generic_read_dir,
 	.iterate_shared =	vxfs_readdir,
+	.setlease =		generic_setlease,
 };
 
 
diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 09df40b612fbf27a1a93af2b4fbf6a607f4a1ab4..2ca16c3fe5ef3427e5bbd0631eb8323ef3c58bf1 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -12,6 +12,7 @@
  *  isofs directory handling functions
  */
 #include <linux/gfp.h>
+#include <linux/filelock.h>
 #include "isofs.h"
 
 int isofs_name_translate(struct iso_directory_record *de, char *new, struct inode *inode)
@@ -271,6 +272,7 @@ const struct file_operations isofs_dir_operations =
 	.llseek = generic_file_llseek,
 	.read = generic_read_dir,
 	.iterate_shared = isofs_readdir,
+	.setlease = generic_setlease,
 };
 
 /*
diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
index 42a529e26bd68b6de1a7738c409d5942a92066f8..6402715ab377e5686558371dd76e5a4c1cfbb787 100644
--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/buffer_head.h>
+#include <linux/filelock.h>
 #include "qnx4.h"
 
 static int qnx4_readdir(struct file *file, struct dir_context *ctx)
@@ -71,6 +72,7 @@ const struct file_operations qnx4_dir_operations =
 	.read		= generic_read_dir,
 	.iterate_shared	= qnx4_readdir,
 	.fsync		= generic_file_fsync,
+	.setlease	= generic_setlease,
 };
 
 const struct inode_operations qnx4_dir_inode_operations =
diff --git a/fs/qnx6/dir.c b/fs/qnx6/dir.c
index b4d10e45f2e41b45568fe813a3cc0aa253bcab6e..ae0c9846833d916beb7f356cfa6e9de01a6f6963 100644
--- a/fs/qnx6/dir.c
+++ b/fs/qnx6/dir.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/filelock.h>
 #include "qnx6.h"
 
 static unsigned qnx6_lfile_checksum(char *name, unsigned size)
@@ -275,6 +276,7 @@ const struct file_operations qnx6_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= qnx6_readdir,
 	.fsync		= generic_file_fsync,
+	.setlease	= generic_setlease,
 };
 
 const struct inode_operations qnx6_dir_inode_operations = {
diff --git a/fs/read_write.c b/fs/read_write.c
index 833bae068770a4e410e4895132586313a9687fa2..50bff7edc91f36fe5ee24198bd51a33c278d40a2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -20,6 +20,7 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/fs.h>
+#include <linux/filelock.h>
 #include "internal.h"
 
 #include <linux/uaccess.h>
@@ -30,6 +31,7 @@ const struct file_operations generic_ro_fops = {
 	.read_iter	= generic_file_read_iter,
 	.mmap_prepare	= generic_file_readonly_mmap_prepare,
 	.splice_read	= filemap_splice_read,
+	.setlease	= generic_setlease,
 };
 
 EXPORT_SYMBOL(generic_ro_fops);

-- 
2.52.0


