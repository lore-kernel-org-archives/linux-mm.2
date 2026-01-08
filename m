Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 594D7D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67A26B00B1; Thu,  8 Jan 2026 12:15:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1EE06B00B3; Thu,  8 Jan 2026 12:15:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E8C6B00B4; Thu,  8 Jan 2026 12:15:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 916BC6B00B1
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:15:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 384A21AA6C4
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:39 +0000 (UTC)
X-FDA: 84309448398.14.63BA63D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6A2A21A0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FEfgxOSR;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPEBBYiLs5UpRatTHzdR858ldBQc1bQKs9678P4woJo=;
	b=NvuYIneTmCqyaQeDeoKbmTN4vHR1/V/8qaR7GJ10RqHDvXnd8IVBKJEQb61vlEJReEzwUC
	M5ciwpIN9uI3xUY8Or7QHykI2Eq3sqQVFhV0mZcvNy45ZFbNdGUOmZGanSY5sLyPpxjyWK
	fd9UHJCLvQUEzwxKOoijP93Qrdaz5U8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FEfgxOSR;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892537; a=rsa-sha256;
	cv=none;
	b=6vxu6vxHKGFhiP/rfcA7ZKruOLB49osfQkFdWbfGbCzYINf6v6guYTAF68JSgC2/zOHJ8i
	1Iq6rLf1hvrvtoyv83e7xHEfA94TykZQLWZsNVpp1P0/l1kk3wbLFR2ht3bH0HtdqBKfIv
	3xx6VXJ1m3PxHJ8jGzom/5tMb1+kz/0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C71DD60147;
	Thu,  8 Jan 2026 17:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30428C19423;
	Thu,  8 Jan 2026 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892536;
	bh=MiPWr2DLJcKasX6F9v8+9rGglnlyvJqPKW48zd1al60=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FEfgxOSR26Tj6ECCXQ1kDI71xuD1hXG0pdgsfNZC4qjP9PM5lbfSx+Yybs1gCcecZ
	 5xVezzMwDcSNmCAOhMvgtKsCodYaQQ0THMfjeYU1Lka0ZfBQvNJSo7ZROk/8DWqqwS
	 z9CfvD4AgySuAldM2dO7tTufE31f/BCPAdnxWn1/LB9kJnwnj1jV/Nw1ca2KACETGl
	 J8f4IuU7G8YKWo7cRmlJQR4C0vPm9DRtuy04I5l4PODkstZAHL3jw8Nx1K9gAKC3OK
	 YiODwtzqw2h8Mvyvp8pwAs4PfIZ4y1YWFa7ryDGScMUbzDbIQyzQGIbkZGDOaQEX+r
	 xeKOdpkRHCqKw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:10 -0500
Subject: [PATCH 15/24] ocfs2: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-15-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1853; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=MiPWr2DLJcKasX6F9v8+9rGglnlyvJqPKW48zd1al60=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W8O17HuY23tKG5Hc516pzPRtZ6MOWS5N7vz
 r/iJxDtMHOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/lvAAKCRAADmhBGVaC
 Fa41D/9uuWhzztHYPgXgRluKnu7erDAhmYdtz6gCOWZcNAGtLmln17MgKeXnmkqDLMrPGVckwT4
 fC7PobhFhcSNz2sSkcjk425Ir4n/1vzlHrGwFkpJLw4Kn2fjqQnx7gF8IbKic0lGeIbkIQbiv/M
 8jFiA/irOYflPM9HaGteXeTCHJ8i0+ULeKKhr/udChrv8wCSN/dIEHMDqryp0IfOtpmJQTvb5RZ
 3HCC4ofBYEz4ZCwq3xOjBjH9yLnbP9AIyEGC2LegAIND0PfwLhjS46AnEIEsUDiaDbhbzFxL134
 48fiomWRdRAG+WQ+FJmxb6WzuE5z5JyudmKfckYinC3ZMkz+qNgDfidFdXNBevMLS2ukjoWJ+iJ
 2EfSfdIaSUtE9amWUXmyMljqiLZWlHGyTMebwgN+VoRxnvGxD3vd0+HDPL0R7kJzKhsfgoRwH2n
 Dgdq4fET9XNtzIN9TzuFmn3ga2hYH6AG+x8d4Ll+Nk0C2jMtDJZZI57nFOVXELVh+mTrTvljKih
 nvP/dVB9FoRi/l1JWdbfaX74VqUwinlSeT/iqLJucuPyQG0GWP6nBGRB6iYgcNBqJXT2kVB0ats
 dVPUdyWpL93BCT7a1h/PdHaO2xKWw4Phq16fB9qNI1evyBT5qrdO1Ol8oCTrYo/VZNl7rhK29IJ
 9CXrYp95PfaAsQw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: pk7gm6uueudjg7wfrg18xi77gfadhc34
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A2A21A0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1767892537-215036
X-HE-Meta: U2FsdGVkX1+WJJgcXn6mYKj/TAc777S6tIbR8tG23rZL1YAv0tQWMbAEBwbVT71oAsA/b3Go7AuuI4XzeZCrbaNPeR699YOd7qt6JeBihMVrFCOW6x/c1Y77pK4kcA8WKRENN0OOqAoTYG60FsPNMcxKC09B+M8zwGhEpIfyBQOsi77EeL91ioXX659KAdBCbW95pS/5cH3QFnkvVjuM2s1zW3JtjbdHlxrLjL0znkEzN72esbRGCxacV1ESo2DPMSs8Aqyc0K8L/0RDQnxNFka/1WKjbzGUVpMwwzG4jgF3o5UGKTZVq5wM5YrFaNpKcLBTXgmo059RrBQ4PgAZK4DXZ7DcLEADqH643uyHlkXsqLp6cwHsmwMVJzuyH3c0Jas1QS+Pn+uRKFh6nvqnKNT5iP94PjJU/FFombDRHgvjWBNAfaXbhJc4W3L9Re3RVgsIEBKJgOjL0AErfFfAc4ZNvg5ceWrpIiwwVUvWi40afKILCXr25uuR0fJlQ/kVqd8EMTQ7uo77yWsFbO1WWoZVZ3TcLUZGkqxJA5VqJIKEZklg20qUqplOxMjn56Cj8mptQ90+IPRLhO+ZVDGGicgwOppi/B4SOhn7Y84GdO2dtbfXuKHCi15MQ6b/h9QNoN//XUS0B55IoNnaEsRxwlOrXspNyZqF/+p1rMdntG1DIhGqcXh8DGCWJB8TRsRhzD0wzBo+jNLIpgKKOeIpRgygtRsT+Kqqq7vgM+YErNd2AZ7OOT0quNTwqmoXhxDidVjjIWHGCZRwa94IoqBEuhggPDjZzSbUyEn2cZLSYbphUPbFj1byDUYOG3TeQenx/Da3loWTEvBuha1UCknMjyqkIhCg7wiO6XWyt4Jyo43euMR8D7D9T3iqXm+zPvjBYIn1OD/bi0LVitQoYLBdiZhqEOzO5dvcxMlw80VcTBW7C9BhJs/OlAMJtJFooYKMuABPOkkc9lL++X/Y3Cx
 w/nGiLnA
 +LObOEiJBXjV9TqoabUUu6slPfxEXV6az/THWV7oc8+gPxhiW7xZMvZhia+0OK3n+vSdOsf8sFoMZlW/LMvuhKURi8ukKmMURezlpPPz2pIEgvLoUy6tiMvxb3/xpke0zyGMKoJILuy+mLMeHAqTYbZ+gcWm3ZJQv2ACqt3CXZK5tzJH1aq4jqZ+OGn7k9L2ihiVgKuVAtGpy+AE7W9bIxAMaMPEnoegafIt+jVwMUt3CCCFD6deWTMeij239S81v1jFfar+V+I5AqNGbVBbWrvBK9ygQ2aN14GmysP9Mv1j5hJNtzWUGGjaogNxmjLxb8K2Ee8RbHpxrAQpRP8ZnisCtepKeOO41Umh3hnMencYi8wqzcvPZf81Kqr91UT0aDtQq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to ocfs2_fops, ocfs2_dops,
ocfs2_fops_no_plocks, and ocfs2_dops_no_plocks, pointing to
generic_setlease.  A future patch will change the default behavior to
reject lease attempts with -EINVAL when there is no setlease file
operation defined. Add generic_setlease to retain the ability to set
leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ocfs2/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 732c61599159ccb1f8fbcbb44e848f78678221d9..ed961a854983d5e7abe935e160e3029c48e6fca4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -19,6 +19,7 @@
 #include <linux/mount.h>
 #include <linux/writeback.h>
 #include <linux/falloc.h>
+#include <linux/filelock.h>
 #include <linux/quotaops.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
@@ -2823,6 +2824,7 @@ const struct file_operations ocfs2_fops = {
 	.fallocate	= ocfs2_fallocate,
 	.remap_file_range = ocfs2_remap_file_range,
 	.fop_flags	= FOP_ASYNC_LOCK,
+	.setlease	= generic_setlease,
 };
 
 WRAP_DIR_ITER(ocfs2_readdir) // FIXME!
@@ -2840,6 +2842,7 @@ const struct file_operations ocfs2_dops = {
 	.lock		= ocfs2_lock,
 	.flock		= ocfs2_flock,
 	.fop_flags	= FOP_ASYNC_LOCK,
+	.setlease	= generic_setlease,
 };
 
 /*
@@ -2871,6 +2874,7 @@ const struct file_operations ocfs2_fops_no_plocks = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ocfs2_fallocate,
 	.remap_file_range = ocfs2_remap_file_range,
+	.setlease	= generic_setlease,
 };
 
 const struct file_operations ocfs2_dops_no_plocks = {
@@ -2885,4 +2889,5 @@ const struct file_operations ocfs2_dops_no_plocks = {
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
 	.flock		= ocfs2_flock,
+	.setlease	= generic_setlease,
 };

-- 
2.52.0


