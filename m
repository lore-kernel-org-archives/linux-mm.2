Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B23ECD1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E2C6B00C1; Thu,  8 Jan 2026 12:16:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CE846B00C3; Thu,  8 Jan 2026 12:16:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7306B00C4; Thu,  8 Jan 2026 12:16:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF8606B00C1
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:16:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8EA95139D85
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:16:32 +0000 (UTC)
X-FDA: 84309450624.06.2B08602
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D430E4000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:16:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ka0wy7tf;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTP2GMbNVlF1e3foN13NRmrwrf+3zjUemaOdq32B5HY=;
	b=mve1Swc0G3O3U9JEsgN/0GYHHk6KJckSQZfxxEL40WOL5O6jPQnek/BP4crsuuWjcnINjq
	SDgpJQ7cH8IgK7TdDSXn4X5vhMAfiMIzUge9SYemfohDG79jEhHHs4kUX5HPpCgFIzRiVE
	NtwIbEnVuZiUpUxss3zoOOLcHsuaJRg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ka0wy7tf;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892590; a=rsa-sha256;
	cv=none;
	b=MgB0CH1OfbFFWwTNHL+DUvOkQh9lllqDrA/DzJEAAiyLnJj7Chm8cN8DXF2tRq7JSTmRMW
	zDbPlhDJJLMV0V8toWL5xvdoX1iOZgt2SIeETS7TrSaEL8BGZ5F162bGRWKRrLKcwpz8/V
	uDFsJHh5IoQARhRNG/v5kydA9KsDwqw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F3396014F;
	Thu,  8 Jan 2026 17:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5037FC19422;
	Thu,  8 Jan 2026 17:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892589;
	bh=31kaSpuGA79pOQvjYXOIwkMusZ5I/9kl0pI7vxo79B0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ka0wy7tfVbqJ8biZkl1dnF7zdBNpw2I/HL9Z4qvT7canG8yWttWmWRQ8y2bA5H2Ne
	 Hg1kLSaeL/MJqN/eLQrJ+0D74nyBul/1dg48cm4KybwYHPFxN2jDA0DG0JbZS9GgJH
	 YX0bgPuTqTt2qOuABV3Sh0WjERkrVZ8mA5j1puaJ7vvJQEjbKd1eF8mVQZSJI+ZJKN
	 +fRHCYR9Jhj0ZnSLSNSehLByTqec+/NNwTFW6FjkwP2zNBKgrJjpIbdazH4MUrGCoN
	 YFM4uhC2WPpbzqLdGmh6J9z/myyIQ398y3DCiuGgy6lIDUaJ/QXycwYIOEvZGejZ9n
	 yymoliwZ3EoMw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:17 -0500
Subject: [PATCH 22/24] xfs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-22-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1348; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=31kaSpuGA79pOQvjYXOIwkMusZ5I/9kl0pI7vxo79B0=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W+/CMV6M0nr3SG7lwo2cpM9G7b0LqWdi9Ol
 v2q/8PSRRqJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/lvgAKCRAADmhBGVaC
 FVSQEAChykiIZZ2qCoDgb3e10KiOX4j3Kq9XSCEqphrg9Pr8U0yza5P36Vy+bUEGsdgKPjDLqTQ
 q/949XOcYbiBcP+IEI7/gYaaYVJMEiIGImK6lABXNO2oMGOM6vLmEd3C+hnmhZlK8h2vCSnhIkw
 CqkUAOpj20VyRsjZhxXC62TQQO8/8Y1QDjwRM24rZXa9NLMVNIb9Nn085XnNY8+Ppa3eFSktXW9
 ihb7fODPt1Vn6Y+eTsFtU5FsC6SwCxOTMnfRJEfY2C9Yl+7ldIyvY+NSWFbd1iWDZ7EmBaqU6PK
 qrBu72lJYpbsDQz6g8wjru4v4bG8N8o0uQm0wo9K5ZDw3DyjYaa3ja3+c2uHUSiA7BKqCAx4smU
 Q5mE5CbEcfBU8OthZWBuIhfbrZeYXgiGW0722Wz/sF8uiPVXx0NNUtIVMw1iSvsgI2McyL2JLrj
 4VZm70XFpXu8ld9+0yoAZ/mUgmn4HBfNNG5qyOqJfFnnEteSMeBnpbPbC7mihmnqF+bUwfFMpx2
 rPK/34X8VljljNjLqhFk7XbPZz6v6m6AhuTblY7PbDlKBRzMM6jNhafVfVXrC23FeDGkeeeS0wq
 afbmnpmPSBOCXki9yf314rYtODExHP9j/c/bZvezn9USBq8VM89wiKzdf3Lm2UXyjR/QYwfw5Or
 Ae8nSsnmq7yvMOQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: wn87fe1brmy67dea1mow1inrth6onpwq
X-Rspamd-Queue-Id: D430E4000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1767892590-71255
X-HE-Meta: U2FsdGVkX18NwcXUnUN1u72Txy0u8g42jn0E4eNUjB7FZbJFUX/FMKyLC38mAreYHlzZdNa+PN6m2PvXJI6v3glCvBaQmU6/kCkE/uPr+jRwNqWTxFMxPVIQQ22aN3B82OD45ksbC9rAqck+ybdEk2EI0bczoi5yAazJNwasxgvZiG1bMYlTbrktCgjXpiEdwt8nX1IE3a3WxBCg50T4x4cKX6V8huVmyI0NTPRzlTWiva9n7FgpYj5UIWBGnVEYae87qI2QkC6sIJX3dBQVHkL5TPcXr/8regCtosVuBefRuT4rYMzQDVAicvvG/0+ooC1uLI0s7F+m1vxDFEbeDQQ7UyrqobQy/ZKLHplcnHh584LKF71pAFS2ZA/8iqZyKJne7y+Nq9abVOoTh+LsDe6t8Zy4gP9MbRVrTucar0+nSq0UPAEAZ8eoZA8lOEMdhBwv4WgFijJ88iZDvTi6vD5kuPR3QIyi80nOzCNxIFjD9VUK3y9PGr6xr/c8AVxLd9SXRMiOi/7HIWH3D8DhV/sJI8hUv/Pa36zeNP//SP9nwPa3IRRoD2tkZuNpgewIqGZXnUVFrpbqjcSIRmCsn4KKsNUOapZOOLdPM6vZTP0h+2Rs4+MQvSQywhBXbbsdRTroPUnu5LYK0feKxqFn22tQ2Ud+HcKo70xYi8uWgcEgXYz3zdSaSmorHQod7sSXBVIIcJyn27ELqcTfEnaZrMCTOlexCtHN83OMBvJtm9ayLKhgVmUN0RavJ/SfOMoskgbuhHyvLE2d5k4LjQpf+O0l1shfsnkd25tt7TB1fyB5UMFkVhh0RgTawz8abuANStSMQGQTaxDp+Zlp+HYiaS+47zstNktcqWAuDlNpWHmfCdjD8Us/bHJ9h9cvyMJE/JtasZ3zzkjz2MYsa2j2ngj+MEPTer+SGaC7TBYt86lshprBdiGg6yKixRnt+Q6e/QJSKM1ejnXEWYu3ncS
 f2NUruUV
 juPL5PC6ql/yK3aD4ln80d+QSUs+PrVJ/tsLPXm5i1FDBv3pqTfi5QntPe8jjZKPPkkN2u/0SWCpUZjAB03uo5bKDXJMJjYKv2HvVIPMnGTQ6b+sQOYKCGXIZvHz8n2TGDlHC4w2qQU5Euhi+gnYYf/1oEvMNywKKTokvoD3zp8sw2uCaGh3v7CwvcM+hDQeG93qWrIrylwuWA/LhuqiN6gu9iXQcIMY76sXtviUlU80u1fsLmPgp2bJeNGih8TCZoMHUwa7NNsHiMkro1upRUtAGhLeNciBTLQBM5jkaLSqoSH5Rc1bDgdUDNU4aVRW2Yyx0H96H77y3CvEwKAYi/nb9LRJdRzu3Yfph
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation pointing to generic_setlease to the xfs
file_operations structures. A future patch will change the default
behavior to reject lease attempts with -EINVAL when there is no
setlease file operation defined. Add generic_setlease to retain the
ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/xfs/xfs_file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7874cf745af372fe8d90af09c6916d4c635472e0..ecd7bf42446b38e075986d1c774dea4e8c0c0d01 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -36,6 +36,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/filelock.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -2007,6 +2008,7 @@ const struct file_operations xfs_file_operations = {
 	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
 			  FOP_BUFFER_WASYNC | FOP_DIO_PARALLEL_WRITE |
 			  FOP_DONTCACHE,
+	.setlease	= generic_setlease,
 };
 
 const struct file_operations xfs_dir_file_operations = {
@@ -2019,4 +2021,5 @@ const struct file_operations xfs_dir_file_operations = {
 	.compat_ioctl	= xfs_file_compat_ioctl,
 #endif
 	.fsync		= xfs_dir_fsync,
+	.setlease	= generic_setlease,
 };

-- 
2.52.0


