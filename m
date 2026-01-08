Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5E5D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C039B6B0092; Thu,  8 Jan 2026 12:14:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD72E6B0093; Thu,  8 Jan 2026 12:14:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4196B0095; Thu,  8 Jan 2026 12:14:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4B86B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:14:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CA63573C3
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:00 +0000 (UTC)
X-FDA: 84309444240.08.75F0A29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 93E9318000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:13:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M2tNeCP8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892438; a=rsa-sha256;
	cv=none;
	b=M0occpvo5bHD1wk8rHzwMD2X9ijC3seb7Rc+UcfHMc891TxvEGtMjAerI3E0ISWMysMIoH
	xY/fwaNkvw9NpgjZJmL5f3mOi/jv89QB5z9Hdrw8k0I2Kf8XstcqCEBgTxxkW6pO0KlWjY
	D4QtQFDl+oDBQgbBcX432G8skknLIng=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M2tNeCP8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kp0cU5EsDXHx5F5vjjnuc2Y9kqH0FLsz82OIU+nqh4A=;
	b=14/JfR5sql2eRTHV0p3NaEqS81O9QevtbzlEKMSQFBwUuWyLoHF3NYMnFkEWMHjzp91Y2K
	8gyI91vn8Pq//y3oY3QAuJ6A4XWbnZRquDrIq3LHDtuqNd2md7ZToP6suhhEp7a0smf/XP
	BGDX73Bku9zWeedzdLvJ75zml7hYejo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB9F660133;
	Thu,  8 Jan 2026 17:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFF7C2BCB2;
	Thu,  8 Jan 2026 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892437;
	bh=Pwijv5Tuh+c+DiE+MHlFZRInxzA5YXBkChKqagFjptw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=M2tNeCP8JvCAJC9IUlu2e0zizZP6ZQBZzWNHPfmEbBZ0zetXBKM296NJhSU7YqSpn
	 LteILbCxA57A7S+IeYEMwiideMe3sfW/5gv7fDscFgTzPh5AYvo8Ujt78vUZkXiSAq
	 m50i91DWk2yAUn0Wttdfcm4F0FCACyOm4gftTSpYTz65kZKap5L1nyrcppapkoefLG
	 6fC+lCadiEiJ+EQxkokfsvynFT8eNPgBYsf4u+HfENvfgtRSO1SFmQrfASP2UE3kgZ
	 ZPn7g9odE8Y1aCsATQnyJnrCkGD+QdO7d41CD4Pf0PJGo4XJP2HaCvnDm6S43fg6rg
	 Tht7Vqc7FmdcQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:12:57 -0500
Subject: [PATCH 02/24] affs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-2-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1645; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Pwijv5Tuh+c+DiE+MHlFZRInxzA5YXBkChKqagFjptw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W5Y9ye+Dm/rtqwxFL2Hdd+tE3YmpGaoSkLN
 ZcMw6xn0rGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/luQAKCRAADmhBGVaC
 FeCBEACsTpjyfgcjG/GsZ4xzpgWq74Juli0DXZ1WVIUf0ss6GvOpMkY+uxFacz45n1ArzsjFBYA
 qSoTluOJD41qHwdDKGAdhFEsGj26fA3v7FUhqoN+IA0XCM7Q5JilKfVic1Jb7GnApj7qMRdR6gU
 B5xmOIsaXas0JxxmsF6a74mqSRmXo3ohjUjkSGHB0dYxgwAhQl6frG8PJmO6BmdhMf6j+Qcvjf4
 +pWs8jy2sS+8Vn5ZYPzH46DiFJ6bNqoETmBwWpG9FTmQ8zzlV8lq+QBuQTPpg9JMmE87T3mY79A
 PB3woVowC2Voz820ZEbCuByTzSYq3zU+nMBlhGuaAtPjtqF2/6aP1yCzRxJ8VoiE4KO0gyHUkFs
 84qO4+ZPqv/lRUPEXn+z28VYVWtzy6SV9Bxwx1K4iIKZLcwHj03Tk5Ay3OwbUdHHvmJea70tKU/
 Pnd8p8r3Zh3wZ0Zm3SHFL7CyUryOZe3NayKJMBsSodI8c6BqEpcbGSM/IwmjtuuuSt9aFAENA/t
 LqZWDcQTC8onUUXMCy0ila0bxBHfF2VUouHTVvO47koLUMpxSRy/v4XjRZyRDFIyv21c3Ja9RFB
 SSA/Pejl2la0pHZH2Ld420/K4HhPpbvOeD+lB6GWqkw69u+rZ5I9HhHwUM2EGpaC9H305b1sO18
 jw5ReV+iUjgSjOQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 93E9318000A
X-Stat-Signature: npicsyth9m59oithw4c6jics9pjddfx3
X-Rspam-User: 
X-HE-Tag: 1767892438-180089
X-HE-Meta: U2FsdGVkX1+HqmK16/G5sAe33fZNdS+SSHGqi7UnPFkSSmeuVibi60xlMqBkSqUZ6R/A6Md7o3fyWtTqEP+M3ZWJylPDKEssomZfuIuDgRaRzjWVjAiPFTP8D4aLJbytOGUVo4TzGisw+PeI89it0dzZl+2cXU5f3hZdd76KCX1Efe5eOjko7K8n4+3hTUlgdsyEy99QhZIx94C4rN6tfKzQ6TBuFfChqkC6Ws1RyztxBdR3mcJC57xg7diqXgmmNw/dg4utREgGNNQUQOj2FwD23dc7Uwy/O/m+t7SXd6eM9HJgyej3Ke+AVXCqk3KQgMMolHmWb8hzLx5teAf6g0JJjzyDGiClW1+HJbYFykKlHbfG1h61Q9RyAVesa4Su0RJu65FdVvk2XuvehjAkQJnCeABYL+1palXeeu90xVr/08Vh8n3UhVL7gjenrxp7iLqq723hxSRnY8I0rYAH1sgfxrUtq5kZVpeEyci3LpLSArpMMFkyIeGWdumJbFaND8f02PCB6BSzitLPQ/UPcXgMPsBoFcfPuvjTlBEL8dd14rnxNntJe3ipBiObQdGFu6UgPCuvIM1mXcOI4aZW6DFgDBTLYLZbpaXtNq8v+fPBnmhR2W+wXX1RJhqT4/h54/uq2Ds5P/l8XuxX9MbKxaEyKwVfZ0zulnwtwp+fMLb5o3cmi1IXbVIdsRebuvYvt5dOuKmRZ7borI1HQFR02/J0NAWSQ7G/V5HazrGluyzfyjGSzn+klAaf/U6UUaJ5wnETnVwMubs8xj17p101p2k1ulzdRWgzzf5EmEEpKfX7fmNxrg9MtjxZuUp2E3DCAob5MypEUziHxIu4mic5mlVqdPI1bEcw7WjG3IK7EwzS0lUQ3TldlPaPHzbybJRcJ47A4RySW5RYpmNIDHPB53hlvuXzKCB5D1Q8inhVuwW0/60aHY09XvV2g85MhamxZ0gPO/7kY6M0+eWRpwx
 ML4ZrUB0
 keYvBVQ60c3Wa6N34TefD9Czw7brMNlnPUu53WqfqHXJ95VXJgC3TqK5cxBp0oujkH2lPGHNaqkB1fzkdb22ejeWED7fqqTT5rH2x7Ylx4oY/2FgsQWSp4iN0GgRBvvWtxDA1Wnk3p5QHBzOQpxvrle7uPu3GMQotLAziFLSDNpwlIEo0DxQs5rmtCD9lSOuRFSER8F6oYlHMrZEYgYpt8y3GWghyMgOs0V6Yj3Grea2N10IUvsO/7EL+UiYPOdgXDq8JcHBFYXxvzMpvSIfJ4HrL0T4uoQxiinho+WsrrF9POATwgdiJEIljZZHhiB/7CC4FtIWrgBFV7obVm4A05mNQt10RFpHdGaOQsaXKOpzZ/FzZPNcD5gyZg6/c0o93uUyc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to affs_file_operations and
affs_dir_operations, pointing to generic_setlease.  A future patch will
change the default behavior to reject lease attempts with -EINVAL when
there is no setlease file operation defined. Add generic_setlease to
retain the ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/affs/dir.c  | 2 ++
 fs/affs/file.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index bd40d5f0881042e7e6b15b09a76a1793169a1d50..fe18caaf4d6557c67f5c0542ad86a6fe4c512aaf 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/iversion.h>
+#include <linux/filelock.h>
 #include "affs.h"
 
 struct affs_dir_data {
@@ -55,6 +56,7 @@ const struct file_operations affs_dir_operations = {
 	.iterate_shared	= affs_readdir,
 	.fsync		= affs_file_fsync,
 	.release	= affs_dir_release,
+	.setlease	= generic_setlease,
 };
 
 /*
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 765c3443663e6f542dce2ad5d9e055e14b0574e3..6c9258359ddb9ba344976dd5a9a435f71f3fabc1 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -15,6 +15,7 @@
 
 #include <linux/uio.h>
 #include <linux/blkdev.h>
+#include <linux/filelock.h>
 #include <linux/mpage.h>
 #include "affs.h"
 
@@ -1008,6 +1009,7 @@ const struct file_operations affs_file_operations = {
 	.release	= affs_file_release,
 	.fsync		= affs_file_fsync,
 	.splice_read	= filemap_splice_read,
+	.setlease	= generic_setlease,
 };
 
 const struct inode_operations affs_file_inode_operations = {

-- 
2.52.0


