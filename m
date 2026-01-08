Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B333D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC2A6B0093; Thu,  8 Jan 2026 12:14:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086AD6B0095; Thu,  8 Jan 2026 12:14:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBE1E6B0096; Thu,  8 Jan 2026 12:14:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB1746B0093
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:14:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7B2A1AE53
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:07 +0000 (UTC)
X-FDA: 84309444534.25.D937BA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD723140010
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qr7TVxvj;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ommrtXllry4Rl2LM+IwJb1/6AWt5QR3CgIf+tO8IrVU=;
	b=0cJEmGBBn7WzdDCK5qO/K6xTkZ4Mp6MOyZkF0LGHShXayISp/67sHwK1Bf3jKQyLvYIs3n
	GQej9ve2IApj0bWAQU9Z9ACBdfsmyboIZyWz9yQGZEo5w55W5hAlPWrSZDOqt7vi7v8s6t
	qa4WYXNJlc3oPv7tESeM3j2pZets7hg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qr7TVxvj;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892445; a=rsa-sha256;
	cv=none;
	b=nRtONLEBbsNvF8cErcCLKl7la1bgepUmogz332BGmOCWLVPtOkZvCfUgw4fwdb+3FZuYKh
	+r+pgFJylbQbcSptJVkosAjhoZnqd0z+tDQYTlSBZqWuL0TCtpICEWU49gGhd71dg4oyTt
	5Mu4kx3GuzzbHku6fedmu8ryQCnPHgI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C6A06012B;
	Thu,  8 Jan 2026 17:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8029C116D0;
	Thu,  8 Jan 2026 17:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892445;
	bh=r6yK8bK+kkMgdLh1w8q65yIEqjkb/IjmfMvjzt63UDI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Qr7TVxvjzjLDifiDNwgbz5Utlv1xXYOFRFXz45doMG8Cdh5Klxpemaa34l6LJokhA
	 LFa84+w6J2qISvcYOsLfUBUSL9MwYOCY+AMEM0SAde8YfqlKywdQkHZSg+Ogf9pjzQ
	 aFpq+UOCKzyyuR2vxCOphzBHlhmhgOw3MDspuwMRqEYAJz9tNnga4+EJpK1D2ociJW
	 SANMkPyTno9YLvlxnw/Lsx6RGruAjUhICO986WMabplDp+6TiuUuX2xPPwNcBFGQfF
	 69HtUgtVBqbMsF7uMl1/aNC1vnXN6NRGfWYioeAlTU2AE6rPRYyHHQqJes8E1lstCt
	 KWb4D2+xXXgCQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:12:58 -0500
Subject: [PATCH 03/24] btrfs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-3-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1874; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=r6yK8bK+kkMgdLh1w8q65yIEqjkb/IjmfMvjzt63UDI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W59KQJzkynnqRywsxn8vf6E7WkYLaalZHcn
 hqXE1iesQmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/luQAKCRAADmhBGVaC
 FaJdD/4l9fv7mklHKjKkjTHpTVCuJPpIKuHhUtEoAqSprUNpwgQfDYLR6f54jMEQA9jS1LBj+Dy
 QyeVCVp55DoP+wWIXayOwD+klKX2cjtKHEwQH5WNOE+citJTM6zNMzIBsDuWMPletL+BrqbrBxR
 HQDrOyGoBCNw3T1Y3bJodEqe17RMpbrM5KQW+uFl//FLm8KIwd3cLbRjHZuex9cILVJooiBg9l7
 hUE52fcXEYxfjxHGR+zyVf6kogJj4y74vQx4i8b8B2Ji0IdoaBOVwiZpxIuDdQRGx00T4PkN5pE
 bI0JaolvkVkIP58mQT0gLpRrctVhJ7Fm0DRISz+BmhTcfaaeTwcgO2m35EL5Df2ExhjnuyRvPIR
 79MM+Z+RIyV4mUCgXq2Ew49Qxpsd50AoG1moCPbZ/o5bQwqkL1OW1HDV8svhp7gU1n4Pmsf5he6
 U8/NR75X8fqtFciebf0UxTzmneWSw0zcIw2QKAsBUmQukDXYH/gJYnWSF9UAj/JrIC3fNunArUq
 llAH6702SuQcGU6kAt4IxAZNCFIjdu1g5UiVgOaxJcCh3emmvOFhVMzCWpAuGiOFbdbwEed/7pH
 iNMhOMoloJOXkThvtx3egvJavKsX+vhYLTgSnhPuQ83dhuILLuHFQaySEbcaXOac64sdVpwJc3b
 Yr+dTsCBfX540XQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: DD723140010
X-Stat-Signature: hke9ockcjrzz7wecn1tkgfanh91r3itn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767892445-336251
X-HE-Meta: U2FsdGVkX1+pfr0rTaH8r6Nraaiq9L3p8Rl89GFs2nMPbFZAIqsI8kMHq/JlaCK0OFnAO5F1jj81b+mVnZZgJ5Ui9CGMKxsWiH7zAHdqFKfZZ8c450r7xeUC8gAAN6qfUG036xq8zT77vkd3XwGHk2RXTjLuCk2AVjSIdG/ZFyp6o+JF7h5BPiNa+ug1+vIxbEJ8xBrvlCVYvNW0O6v4mWBAuOqxA5O/QvksGNxD4Mc42LhMmWMmcQMD1pMF85ujU2vwywfY93yWB4SbRhIGJfSy7UrHHSzY1k1YWOTKIsUpTustScr9dPhOLZPmm5m5riLu4O/DQlMx+tr5jRBiUNk6W8QcnPDN6mFYl0u5vGTAUFe42wzxiMHvbvZUXvIa00PH2osbKeBBblvhck3SW1Ruo7BuGQC2jeqdyYMJxssLbEFhkkpn1BS8e0KpWxt/9Vuuo4bCkGcMmGzo194ofz9nXeNkxzV+I0S/SiDNs2p+OKv9QOEcldPYnLQEAXRlHZWrnWJDrI8/DobThYqnFYoCWYOE6LGSOAMC2IIGxL2vyWhnsoEXJhNKWlkR0UyOHwYhTwLLTmqH4AVUGdCzSStms6iv/3MlEZlFIKBSJi4WR0IF6rjC9SaG8BS2/8eSX4Taks8EZbVsqEJLAVdlPGHJ26nVTyUWm8vBS4s4npU9ydvmq/RFHkAFvxPb7XOSAJNQVi2tbvNo1xYVq3vhFEvTBs7X9RNdxELJs90PDXhwrGs0aOrbfy98rGoyQybTFqxnXOj/k9XvoEnuMdlbpFAAfeoniSy6TGvWj0c27IS9/DwwRH2HuhinAPCTg0RUui/FPAZG3rhYQZNB+1LvcKFefMBdnpKkg3wb7nfiuop6Q6VUIxNb6r9ldg50YYUIi7EIKIUAQVzvYyckyc+WJPU0OEpAaTaeIzwluwYsvsXlsKwgpLjiXUXONnNVF3bwr47KwR4QSNOffs/tR2F
 pFDHdavY
 sXQ6eL0FkHzmvwUwZVTSg06/jspOiJyiu3L4Bk8VbG5GZJ1OPnv+44Eg4BfnVgVd+TDAqREKKCh6JzWmB9H9awEbvAhfOU/MXRZX3M3hGFbW7bsOKRhqXuskRpDoDor1L8hTNrq/JtvFeDjfrtWaV3Zgz1UkM1v2VybhJqHXMf8KSn7IZZbGromBJu5l128NSuHthSn5bylMfmpGxABT/2WJk83n2sbrIxFSSdd96I/Pj4r1IAlxU98SKs0eT2ciWZHfkbtpbLcm+WYIsh4oMZfcEzGuQDeSZb7F8B5tbmBFhvyVM1RY1UEertuXrHxdKr1gqgdGpeq0RTctl1ghcjUsHYUFk6xzqmAB1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to btrfs_file_operations and
btrfs_dir_file_operations, pointing to generic_setlease.  A future
patch will change the default behavior to reject lease attempts with
-EINVAL when there is no setlease file operation defined. Add
generic_setlease to retain the ability to set leases on this
filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/file.c  | 2 ++
 fs/btrfs/inode.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1abc7ed2990e0e956dc0550cba8b0cfc90109e65..aca2b541e72df3638bdc6cd7551a018ae959039b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -10,6 +10,7 @@
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
+#include <linux/filelock.h>
 #include <linux/writeback.h>
 #include <linux/compat.h>
 #include <linux/slab.h>
@@ -3867,6 +3868,7 @@ const struct file_operations btrfs_file_operations = {
 	.remap_file_range = btrfs_remap_file_range,
 	.uring_cmd	= btrfs_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC,
+	.setlease	= generic_setlease,
 };
 
 int btrfs_fdatawrite_range(struct btrfs_inode *inode, loff_t start, loff_t end)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 599c03a1c5737ee4129c0bc1743b345847fa5dfc..5d1bdc862ed2711e349af085512f3bda6cb63278 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8,6 +8,7 @@
 #include <linux/bio.h>
 #include <linux/blk-cgroup.h>
 #include <linux/file.h>
+#include <linux/filelock.h>
 #include <linux/fs.h>
 #include <linux/fs_struct.h>
 #include <linux/pagemap.h>
@@ -10573,6 +10574,7 @@ static const struct file_operations btrfs_dir_file_operations = {
 #endif
 	.release        = btrfs_release_file,
 	.fsync		= btrfs_sync_file,
+	.setlease	= generic_setlease,
 };
 
 /*

-- 
2.52.0


