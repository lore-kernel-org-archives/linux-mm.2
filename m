Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62EA0D1D484
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C391C6B00B9; Thu,  8 Jan 2026 12:16:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8E56B00BB; Thu,  8 Jan 2026 12:16:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD15D6B00BC; Thu,  8 Jan 2026 12:16:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6306B00B9
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:16:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CAC3139D1E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:16:02 +0000 (UTC)
X-FDA: 84309449364.16.9C6DA03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8288FC0013
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:16:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seVFw8zU;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOlou/EGobK7lr+WHPiAS5+sabSAacC9g7Qx8GUB6SE=;
	b=slKZQNwvGVQRpyuK1yJw548TykV2koCcZK3zxsbDzcktAl/Az+ZRYJsCiMPM3/bmRj6XyT
	qk0rycMusaPq59KKcXQcCoPtUN+L77vhxvFMYBqtrm7QMSJJBPbDXJ0SZYhH/he60Nk2Yl
	vHLMG+WerinEvLOIbj4RRQd+2s4+flw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seVFw8zU;
	spf=pass (imf28.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892560; a=rsa-sha256;
	cv=none;
	b=OAt1YzxP8hMh/nTZosVoP1L5ZNtyMFJTU2RUJbgyzvk/iHShxfGciTLE+zDzDuWmuHJF/r
	/toM4p5KPVMPe/9ttl6iYA/pvxpnthkMZyIj02gdcAzrkio/Z3OFoSaqwZK40w1GTCzCS8
	TgLimam26Ax65BPyOh8+I4n3lXSwrq4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 645C340B1A;
	Thu,  8 Jan 2026 17:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FABC19423;
	Thu,  8 Jan 2026 17:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892559;
	bh=9+zOdW5lNGHcGX85wb9WeocgdTAcTrprGG0z5Bzi+RE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=seVFw8zUXzlt4ulIQql8YFbNPIjR9Rf/DPANtIaUVgMB7HrEOnOdJqRINwwlm0c8z
	 AvANMGxK1reP6TvY6s1YHftUbyPa1a4D7XQr5wqGFyxwsTfK+cqKWqN9ST57dkVbsO
	 SMKtfsN9QT6PXI/gKFQrYHJqE+Lk/Gs6kj6Hvg3XgESuxAUelqN0C73lD4B6KPr95m
	 JpqHj+JRZQ0rAggZG1yobkaAZfi3PHEVb3k5rKu0rV7A0tLPvGctl/0eI3eBTKXMGS
	 pd8AFhLZOqZHzJMNSVhNeDhMxSBfrogUoW8EaHeLTlg6D3ZEhNgHnFWQ5i2xZhNPw9
	 lByRPSrHlyiUw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:13 -0500
Subject: [PATCH 18/24] squashfs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-18-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1734; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=9+zOdW5lNGHcGX85wb9WeocgdTAcTrprGG0z5Bzi+RE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W99/HrvAnnmzGcblpLXD7F4um4fHAJVhg4+
 LzfwmzDW3eJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/lvQAKCRAADmhBGVaC
 FUmtD/4jEvDoFR4qieUNgn8rr/UtKPrGyvRvQMWHMSrHBhqUd+/caCds+/vOgFJuPUUC8BBPKaN
 PpWJr3+bB+63HgaLFL5kjBBI84UDuHXUsAdKojmsuX46XRIFCdY4HiLsBRwNlCL3EOFRZb7QMNA
 CLXuPKbYzRdJ5vIeg0PfhFnEee9jhOdU7PhkAlUByzRLB4aRTSgqIksyQLdZtEcq43Mt4+08iOE
 03e8Lyi8MUEQ40+6qwWiOrSbb0RVCZtmy3jlJUPmrRBFnaaSbyXBwQ5pIpRC7Zpjtk9XwyatLAT
 bE7MsYykcOYo7FuP+Eeb0IkX1pY5/khOn3jb8NDXsKQG0ExLeybRnT5n4UB74WPa1yl9VN+yqO3
 QlSW3ny4UUjj19ZXN4Q7048K5CeEiAQBfXtwvEd5vIX7ErHKQXL+VAeFjO3jcXrMc2y9UCvEcfK
 nDXsszCFcuM/T6/I/XGZXHHOGA/FUVvHC/oFF/nix3OCXccHGPKgcXJX8tHP1+t0xqnFretZz8d
 5CypPiszzqEX0oF54cIJjyIzVhzWNzjfhi47ao5Ab42Lu1n7ea420e2etzoD35ai1nWJURpgrC6
 9S21HSVhuCfUGGAqiahZXCHQPulLW/N1GNp7FFtV71kFlOoBok5C+bkbkjXp2uz+F7s/PU8fOEX
 9ml0VlbuQF2h4zA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 8288FC0013
X-Stat-Signature: wqne4hcn7iac6wu4iiifdbt46ngj1shi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767892560-947448
X-HE-Meta: U2FsdGVkX18gX0zCXbMhV2Zecfedv0zphhzvQ9NRIGTZKwqz1FDRk3P21pYKQx1STP7Eg2tbfxYKYBgvSRXJD3n6YDzfuIqH1C6l2Ogkelao1zNllflpaPh7ai5q7zUzBtCLmrnuoZXumBl/w6vASujiwY5dp7NUBcuyZUrWE5CuIbIZAsXQpSfAE0dWKfrD/a9i3iHYexdbf9uWY2vhmJJ3LPTgVTO04+UFeAOFt4JbOvSoS9+rz0JJfgihF5qtDl7X0420LZ1NTHpHVYm/STDiNRlk4iQj8zysAh6KNbKBmwsorTwsiUoCLzDTu71TpetEK1ajmLCPd3jN/WXdgZJ6cT1KV3PTBWyLH4vRwDKzNKGOJGYDPQgCPhGQk4a9f7NBF9278+bmAIoWp/+jK7IR3o6/pwOs8C+lamIT0A8RYLyiRMIJV+IlloF0Y3/29Qt+2+fCXnd52BbsnDIO7WfSz9x2jxD91Brh2bEgVu7Zg+kM4tTRgz5J32+PabhGhTkWtTm4uV0rlmTnTeZxf0m3QO5EQ9aM5rYBeYH+ctMputqV4G1cEfSnUbraA/Sc8t14Jzo2Xqg7VOkzwG9X1u1K8u98JLOvJsnTiuBBPxz4d3FX8MxUqdd7sGcktpy6Vp1kSeose1/LLzko0T4XHy9kFWUy+G+FQpoH2Qm6UsA1diqGP9mDeYkL09C53SmhV6cq8jIcwi4YtCKifTDpQkNJPVRqJYkFuCsmoE2UqyXKRpa3qW8uL04a0asj0Azm++C/I2T9sIVxKNKGbURwKI2BK2oeyBtATkjiidQUQlUmLCMDz7WfxZjHoCwEODyGuQ06VHxDL+gOxdUEINK8IVCguNB83S8ks/oz4T4kP+j+GpBpRjvqdnF6Uv8l50ghWB8uJqwxef+whAunG/TsG+KKGGH2HEN21E8chZ3bj5ZXJfvjfaSMgVaugdMWyCJtR0vkaeoGrRZu2nZUwIC
 h54X5cr0
 gmDBOeq1OujOKq3/j4DBEYq1LOkBi92YsR4nQoaM4h+Y11AXdwlq52K+LagYxXWoChVRLlLKq24qldn4C8nQAvfWrLCM4338taC5nbuXDec1f7bYI3iitkZ0UstU2HrKBfRXylEAT7VyH07tlMYXR2XgxqUkpVQFnQyH6rcrBspn/hwSSQ7oxvmtenmIeWqQSM+kIDeChuaYv7TC6ra+7pxFTb7an15d7hXCgYMiG/hemqQ6r13r4f3KKxHUMMig1GxOFWuTRJf1p5pzVHuxYSHLlk2sUzK62Khi5VMGOpwhcDLdv7IyBgm+N90YYXt4mUAbGuAs4MRnfsMnO02QfzLy93pKanA+MehUD2FlcuA5LpDZu89fsVDdkcKNRYpbB4xX4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation pointing to generic_setlease to the
squashfs file_operations structures. A future patch will change the
default behavior to reject lease attempts with -EINVAL when there is no
setlease file operation defined. Add generic_setlease to retain the
ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/squashfs/dir.c  | 2 ++
 fs/squashfs/file.c | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index a2ade63eccdf38cd7829a1e79efbb6cb607fa54f..cd3598bd034f01c74eb2e840187e14cb05b640f3 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/filelock.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
 
@@ -220,4 +221,5 @@ const struct file_operations squashfs_dir_ops = {
 	.read = generic_read_dir,
 	.iterate_shared = squashfs_readdir,
 	.llseek = generic_file_llseek,
+	.setlease = generic_setlease,
 };
diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index 1582e0637a7ec87c02afee845dce052259e6af1b..4be92206e755dc6b385bc9de456449c5ed4385b7 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/filelock.h>
 #include <linux/vfs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -775,5 +776,6 @@ const struct file_operations squashfs_file_operations = {
 	.llseek		= squashfs_llseek,
 	.read_iter	= generic_file_read_iter,
 	.mmap_prepare	= generic_file_readonly_mmap_prepare,
-	.splice_read	= filemap_splice_read
+	.splice_read	= filemap_splice_read,
+	.setlease	= generic_setlease,
 };

-- 
2.52.0


