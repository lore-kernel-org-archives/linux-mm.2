Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB53D1D480
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545BC6B00BF; Thu,  8 Jan 2026 12:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505896B00C1; Thu,  8 Jan 2026 12:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC156B00C2; Thu,  8 Jan 2026 12:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3C46B00BF
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:16:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2FA8160215
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:16:24 +0000 (UTC)
X-FDA: 84309450288.01.818B523
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 09AB740003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:16:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+KAwUSN;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxI57s6/K+xSGvKm8JB2Aq9p64eelY1MHz0jZWF74oU=;
	b=gi1iP52W4q3+FGncQY0nCj9uBCr3INsEZugH9NQApYvC4VYZrUt7b3WpC8cWU0MAqvM9zT
	Z47StS9wk/6VeeqqmNJfhbVUxGzv8ti7YcjN1yk7thGcM/Wi18+GGps30nJNdkxidctcAk
	m0O/vdS0PQzkN9eX0K6Vq3OB6sr1CFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892583; a=rsa-sha256;
	cv=none;
	b=O517UKjFMhIy2XlSS4ZWTDrskP5YH26Df/517PZYvP47T5rmevPR320GZNJ/Tuddzk0FPg
	yJIOS0tU+TKT3jdFg4KhSCshWtlat+XV+xvarLXjsdAdERiuzPCX6KJW9pniXAoCSK9Adf
	sNxH53JGYKrQUDYbdT6ul7qTcPkzYK4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+KAwUSN;
	spf=pass (imf04.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3859A42BAD;
	Thu,  8 Jan 2026 17:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9066C2BCAF;
	Thu,  8 Jan 2026 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892582;
	bh=uKAoYiUzb2k4mWk3DPDn1qw2MlMadC9ZK+Ro0COSfEk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=N+KAwUSN5aLOeh58U18x1Ce3wnLpBZV5zhe4kxwBm8fPRX5wOYoSQkrqxYodHIYXJ
	 aw/tNdkO6s3F+xmbKKmGdGwZPQ7OcAFF6cZu+pkYIBzXkHIXu/l1HGZ9m9oVzb233T
	 pb1QsAcwbdSOEG0g3hYn9b8h5rMA3FQ1auQxixaZPSb3Gnid38yhHfa7DN45lRpFNy
	 HnYLVP3j5rN6nuQ5tFXKqOBNLvl4XnhrEDVD/oaSpKYeACD6sLQ5WeBkAwtRRf89Oj
	 Mszb3PGelES2eFWGjjvA1vTJCZKTNjzsErMgOooBsTzqIDIIX6sREpum3rJfPfbZjq
	 ncrWyVUiaiNNQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:16 -0500
Subject: [PATCH 21/24] ufs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-21-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1554; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=uKAoYiUzb2k4mWk3DPDn1qw2MlMadC9ZK+Ro0COSfEk=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W9x3bW7J65LYqA4RAoS8vIXUjkwwPn2jjsp
 UmXLATAbCmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/lvQAKCRAADmhBGVaC
 FSNEEACZcBsWRq9qFYTe80h8vRRw2k3rdL23HiT2BsxfSAAZFyBsEvwK9+kuhY3wgeDrU4j9WnH
 /GIsJmvdTFgf55rZbEZRkM+UjSpTNkca8KYJYfCKqOUpyDrGNxHkRKAibGXOuEhKan0kUm3i96K
 UpbDBsdke1UPupTK3TAK6QO1LnUpZROD/waUOPEAqTpxmgOGUircRjljFXwTtS4WNtwDpwaw9/v
 59rhsifvhQg50TiVS3DGlyav9p3uOTznw2pu1n016JFbPDKtUHQQTKWCFllVRGBBN0SrVjUZCvZ
 ysFLmyL6FEXsBc06lpevB/4OZTOHEMAKH6GCviniXzi/Q9mNaGzw7SywSs2UpLRuBEl1F0o2nC/
 gSEYJYJtSUyPrcLRO+sqctPdB0z0c9N5ja1qbzwPysDOGONbqHHZRAwl+/fAm03pvjcgj+Ek4y1
 z4l9I32yHoGA0elIfZ94CnUbSLjHhHp99E6+gneCtLeJNF/V2UdqW8YbC7syjZmYsL9/32uBR+F
 Y05Bwybcvu6omNnCSV8mOat6qwJVat/Xp9cczO7bcMz5ufYYpeQfx8tSA4zKqAhTV7fCQ+3WbrC
 B4bB30ktO7leILwAVHcE6hs0zFGzhxVYBn5+WP2mhpy5Eq42GL6xsEhdCeW6GB9eJoBmuml53dB
 1zKY0MNAGgIkj8w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 09AB740003
X-Rspam-User: 
X-Stat-Signature: q9x59b6dnndi4i9qmfbhiamyx8f5uxpd
X-HE-Tag: 1767892582-975145
X-HE-Meta: U2FsdGVkX19jYrxoKY9hFitDRCm3cBWMZwNnH4fo485zKqVibEvupXuXNy1Y4IizP87ScFU7voVA2Jj7zjlBzyXHNcbo1zBAUIZd598kW17QFdz5sTJb8iNWlb9/cWDZ4intvfrV8wELUp5dH0jOL5bLkQV6jgiv4A93ejpStYTj7N2HhMDRptg1kx1plyS8vwGiklRjRuCyHJVijkF0c2yc577uD/brfs0sZXvod/Vf7DQvCYe1NX4E5UjMttbehv+s63xCrwKo+VRWMZKmK3q7J0IjJlPyrgcPRCP38K5gatqe+yHA82UxwAfvVwSsm6vWuNQWLTzId9Svjk0jbKLnhy8dQ6Q+zBZz1D8aVwWkC1itHkfSHQe850xOWO8BaRPCAD5jD1wNtFhcZ/ap0MmKBWRKVTOeBb8LKjo0Y29V+F2DGHqNnc+KHUwxxVqdt/V+iq3u61Vdp4OjfiYPKdGDTdtzAhvG9gdqcVFxOTK1u7qHTYr314MHkMtUv+F49q/BC9kPfayqb3daMb6F1DmmvyGv2GpAngpzpCYhdR8pAy5BhsoFknFCma/wzAjXyPLeNqVIB3b48nt+/Hkiw5Rk0dXlwBvVKmJkfcC5kTIlapKtG3i2dtO8hqFLgRJSAfFBltdzUq6QCgocR9Ig52S4xnWCeiXnzhc+Qzlaj33gBbh+4P+uNlRn8WWZiKO6SiXd68jdMyxPgr0sDZ1cO563F7Ndf298cNqt8UKpF5xbiSjtzjkKXMXhwZhSX2cmx0NQ639eOEC7X4GoWEQskACSYkwWbYTDZm94IC8BTuVP5aDFTpeNujGkJh2Vd/4wAIjco4qqBcJE64t4mjriudH+xBvQuVeQEaNVOBDJc78ThOnZ7kP38D3QBzc2T1wDOtjdPcr2sgPT8fq3WBbx/EQICXF31QqkDJL8UEPgmGleAFyIpGua66QTRgsKZypv8LGiXRW24/4Kd6fRMTE
 lNTKqNey
 1D9pgkcfG4zGEjsl0x8kR7bmUbqZRexpbQxuSimX5zhKURZqqQM1LRjs4KTrnwH97Y4fA2BmG7bcvAgxW0ETdHK6JxUbWXV1QmZVOBcezsOGt2ulNlYy9N1dZVTuvmeOp2aNN42uFacXkQwzOC2oYL4InQMTWkXl1dajENoqaajoXXNAInm84G+m5hNWi9Pdd1PH1JbvFAT3Xu5ZhO0RMS5dBmuqk30d+H+PG8LfHdiVZdSivbfS86A37rJdUYgNX34DytBf5tzDb0PA+xFfu2SNHMqoXa+oWLImC0+P9vYwUrY8revTm1+cxHv7J7eEAR/X7UxgSXB0bz6kyNeL6j/pvDXQM4R6mATlKxymGOddAupO9SsMdVVv/GQp8g7lJKyC+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation pointing to generic_setlease to the ufs
file_operations structures. A future patch will change the default
behavior to reject lease attempts with -EINVAL when there is no
setlease file operation defined. Add generic_setlease to retain the
ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ufs/dir.c  | 2 ++
 fs/ufs/file.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 0388a1bae326ba41bc03471fcb7ed01098a707d8..43f1578ab8666a9611d4a77f5aababfce812fbe4 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -19,6 +19,7 @@
 
 #include <linux/time.h>
 #include <linux/fs.h>
+#include <linux/filelock.h>
 #include <linux/swap.h>
 #include <linux/iversion.h>
 
@@ -653,4 +654,5 @@ const struct file_operations ufs_dir_operations = {
 	.iterate_shared	= ufs_readdir,
 	.fsync		= generic_file_fsync,
 	.llseek		= ufs_dir_llseek,
+	.setlease	= generic_setlease,
 };
diff --git a/fs/ufs/file.c b/fs/ufs/file.c
index c2a391c17df7f34d9961973909d1985f5f786e92..809c7a4603f863025caa947b2e08f0c2922ad619 100644
--- a/fs/ufs/file.c
+++ b/fs/ufs/file.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/filelock.h>
 
 #include "ufs_fs.h"
 #include "ufs.h"
@@ -43,4 +44,5 @@ const struct file_operations ufs_file_operations = {
 	.fsync		= generic_file_fsync,
 	.splice_read	= filemap_splice_read,
 	.splice_write	= iter_file_splice_write,
+	.setlease	= generic_setlease,
 };

-- 
2.52.0


