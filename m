Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8079BD1D480
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1FC36B00AF; Thu,  8 Jan 2026 12:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD73E6B00B1; Thu,  8 Jan 2026 12:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47146B00B2; Thu,  8 Jan 2026 12:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B429D6B00AF
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:15:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A0248A939
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:31 +0000 (UTC)
X-FDA: 84309448062.21.AB6DF70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AC11DC0013
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o6pSqLEj;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIkGxSckJddzOm5mr5N7BySxqdSOcwEmn39dA60iKok=;
	b=GOVxMZ7YJ9g7OTtnEWqHHKBz6RY2CEqdBC0z0fANQ0D+TBHkkCvQAM0J4fO4EVsWhpUPuu
	ef2NUjvN5g964gdSg6PeqWVZmjviK73yPfdvqG5jhN1eYBTAQpQvoD+HHEkDw2M6CanT3m
	G3NGAB0uhZ71n2mcAlrFZP7ynI+GPEw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o6pSqLEj;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892529; a=rsa-sha256;
	cv=none;
	b=m9b/E/Kx5ceLtLug9kZZvLc9tD+3F1wUGKS2eItFsqeRxiLnOmR2wwAjtH1XMLM+vLKanJ
	4UQ3YqwqbcDAj5/kp3rN2nJANMykNki+egG33OXoOTmmATlwRUmP3CiGZSFVEe1SvVeGG0
	/JAXXre0KHxP8T41CQu5ONY/cD5KX/A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F4BE60149;
	Thu,  8 Jan 2026 17:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1798C116C6;
	Thu,  8 Jan 2026 17:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892528;
	bh=lPmy5m2b6fstUP4HTh/TkAWFgE8sM8Qul7SD/NBtEMM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=o6pSqLEjn8qK7qYNebbAPkZ/JyIkQW++u82AhUwHi9H+QW2iAyt2/YV8OGsxZd1A9
	 ENrWknJg3NuxCTQ3tUkQ1nzJNdFeu2kkZmIWZslXtUy6vu4vYwlwaK2LDvMonkrRhF
	 3DHPRixwdk37Z3HJCNoiFPBNw4693o6PHwWpI06acd0vWqBNZaKtDxOBBL5GKH39ZA
	 mbERBl79ANFf6jGKxR6nRABJR3U3eh0aPlvqDAYupbvpmt5OfNovh+dgAcWgFcY9LU
	 VS2ZwmFVEW/NiRBVP3QjkmbYkj70bOwxmxx8gLNaqaMxaDmsgaKB3rvo5lQYD+x3aZ
	 OaVj5eawcoMtg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:09 -0500
Subject: [PATCH 14/24] ntfs3: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-14-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2198; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=lPmy5m2b6fstUP4HTh/TkAWFgE8sM8Qul7SD/NBtEMM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W8LwtRNR2sBvsfy/GEh9ZefE4EjXAmzXj3h
 zdKm8qXc5GJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/lvAAKCRAADmhBGVaC
 FbfXEADAKoRXZYBYCpltQSV7jdjNKk/JyP9tf3Coi/d7GV8fbo+eZK1ue3cTjR/mnT8hTfpD1xc
 5iB3iihAi3kCkIJSXzhpU5KSj5hFQCw343IkafmT3BIx5qzB72aiZMDoAsWRpM3GIreEyEh1sl3
 5Ox+8W9SmDsCzuHZ6gkAXHoarhyBNbRNlsYF+9XHx12xDx2EPVsr7cNp2IEOTtznxjB4k+JBIHG
 UlXRMlUV2UsOWJuS5EheCi2MMjIz+jrNb10YTMZO/ViLSG5b4xfU4a0BjaxfLJmzlNuVxFt5u47
 jJE74krY8s7YAOgW6N5+RB4czfrDPInVhccAdJcQYtAooHkgCDp+mTfMqlqZR7yyjeJf76atjl+
 +u8kOrnz9IXqT0pc8a1QsuAMA7SsW0nBEHcoGbobIpfstwgPDADr+lEqBOAu/SO2hbsAvBVN5n8
 Cx3bipjsINEhrXXbawsgNTUG/Ju8P6zGspNVcDL9yp9ry86Vnp/+WihRVDWnd7/O3XrcpKNtQ9e
 0xmTkabjcapHBXNsYeAA+dnMdTzCt3N16zrQsDrFEw2RublZKzJfg5f2O6eRXDt8/yXbFJ86oxp
 QBcIiI+HCS2lppFLxe4GtpIu69t48Rv29J2fKJ3q5RTb3WDfYDxGbNkeift5ZptZ9QJ7hvm8Lam
 SG2twaW+WuHsXSQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: AC11DC0013
X-Stat-Signature: nky4juomq943owtt4pwz55ndynidfhdk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767892529-952590
X-HE-Meta: U2FsdGVkX184l4CphrmqH+OHdL5LBRn5PzHHq6gsat4YOmFnGcwkI55zPGlNVTCdUCwbO1K1bq6WYKEAFzQZUXlB0RYEixv+Be+hmE2wbMBnR9p5pxSiS5tFBLkkEa32ZA2GWlEKAOaZp2sC5B5MG5QgjZIIVIllj2hxj0rWZH3Kg18rMg8Sesjf7YCHMtFu/nFTrylVkSBNhTn55XdYJKRxhn0i7yZT4TNNmsz9ALiE8gVI74H50kdDL3ewhD5NFoXCdttP+7RJ5fqD9BlF6/4vmyrroQoxl4O0so66YjUKWH1q+MkFosjwKulWCCjFA+PEbtc6i82kHzrT/Sd4X4lJ2xUUIsfsCvsUBcFqiICud0d/ZSxBKBBbgt2KFrv31jkLLpX2cZi3ZT/rnVTnDk0oflMVEX4Mx1//J8wuUMZ+epgJF/FKPw/R+XS8zjvku/C2jBhfm7UPndqXcsjJF6e3cD5mabkG97dPQmNh/QFPfAAmDApk3RHTZdDRjf9r5e48q4swYAQtsTrddevRe61o8OGuCRlRN4KQkpY1nLH04ZbKIa38hZyNBBJpCxcBp9L6Lmr9XHdj+vMTqcbEyfOSEjPfWAQZl28CMjjGXqpyNr9nDWsI1am8xmCE94HQ4aLdGokuzn5ZLH5QbMxgJBrC7rSMbxN3WKXN9ZzLC1YmoPQ50Ay24lMZqTVLyehpbH8CVtrwPfDtRkkHqeWKvTIgNtuyKKSzKKiWD+y+hT0z1+iGebbM5yCwH9rjU9yAu3DES4gw3Xmkdsx36sgrKUZwWccv8TBmb8PnOKpPhjzXX+tlk512t/IcZ3kczCUT5ee9o8u0JIYaF5oR+/IWhJC2QAlS2reOVd5lvdBjVm1DeyWksv3ENsAb6q2hz4iBMM5WEahJPjl0O88WLqE/sw5DD8JIULGhGLCVYCBcnaaxew4SqRRR+VuQaWEaH02FfEX59MFWSQeqxCecoBW
 YjpLNnT3
 3g5dT3GsynmUYOe9lal9DoMv1nbUv8zrrqVTnVjdQiy1PXSovC1iOnl1svbxdaQrlAO5yRd/vnOLRk9FIrMEfynDMEWOuW2kLDDOsgaQ31hiUEdNVME0aoPfJJk60TBLnZer3kVx4xqU91uyh8qDdupxNmh/lSHlF/tm5kzh6e012SLffXNEEtYVa1MIdRUR+3FMfG+jE72MXSmLWHqbgGNw75kW/fIXX5wGHxpSbDlKpMElGmrFNJiQYEr/rT8elJCXqDc80Nt7lad35/Fs56q7f2TXbQbMPukp+TjTn/Ae5rpNC3Tg1eF+Cq4wR8NysKBWgJWyfivcO2zYfDTMW2E9MxSVXq+HAiCPyYA9h8vKgNCo3VGl191iNqBE5WqIhwhR8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to ntfs_file_operations,
ntfs_legacy_file_operations, ntfs_dir_operations, and
ntfs_legacy_dir_operations, pointing to generic_setlease.  A future
patch will change the default behavior to reject lease attempts with
-EINVAL when there is no setlease file operation defined. Add
generic_setlease to retain the ability to set leases on this
filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ntfs3/dir.c  | 3 +++
 fs/ntfs3/file.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index b98e95d6b4d993db114283a0f38cf10b1a7520a9..b66438e34bbb84483c5e6a5dde437251339d4335 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/filelock.h>
 #include <linux/nls.h>
 
 #include "debug.h"
@@ -630,6 +631,7 @@ const struct file_operations ntfs_dir_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = ntfs_compat_ioctl,
 #endif
+	.setlease	= generic_setlease,
 };
 
 #if IS_ENABLED(CONFIG_NTFS_FS)
@@ -638,6 +640,7 @@ const struct file_operations ntfs_legacy_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= ntfs_readdir,
 	.open		= ntfs_file_open,
+	.setlease	= generic_setlease,
 };
 #endif
 // clang-format on
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 2e7b2e566ebe18c173319c7cfd4304c22ddd2f28..6cb4479072a66dc9c3429be1c4bcebce176e5913 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -14,6 +14,7 @@
 #include <linux/falloc.h>
 #include <linux/fiemap.h>
 #include <linux/fileattr.h>
+#include <linux/filelock.h>
 
 #include "debug.h"
 #include "ntfs.h"
@@ -1477,6 +1478,7 @@ const struct file_operations ntfs_file_operations = {
 	.fsync		= ntfs_file_fsync,
 	.fallocate	= ntfs_fallocate,
 	.release	= ntfs_file_release,
+	.setlease	= generic_setlease,
 };
 
 #if IS_ENABLED(CONFIG_NTFS_FS)
@@ -1486,6 +1488,7 @@ const struct file_operations ntfs_legacy_file_operations = {
 	.splice_read	= ntfs_file_splice_read,
 	.open		= ntfs_file_open,
 	.release	= ntfs_file_release,
+	.setlease	= generic_setlease,
 };
 #endif
 // clang-format on

-- 
2.52.0


