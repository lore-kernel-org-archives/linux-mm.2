Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A3D8D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CDC6B00AA; Thu,  8 Jan 2026 12:15:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53BC6B00AB; Thu,  8 Jan 2026 12:15:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E446B00AC; Thu,  8 Jan 2026 12:15:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DE656B00AA
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:15:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A6B514019F
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:09 +0000 (UTC)
X-FDA: 84309447138.16.5ACD3ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E2674000C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TDNJcMd6;
	spf=pass (imf01.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8EkRoG1L9zjgQ1DOKG9mWDwPpbdMkoAIHjT4aDgnzY=;
	b=IITSD152aBvJYi85UOn20qLMycNhyYAgQ1qFKrjcMXZvApvE7smwQzvCtjwc4HFnoJanBk
	a0j7kvu4IYBn2pexA1ybUMCVyNJ4ACUOVZu7tF+c4FjRxjpczv0n+tkARyodruu4gzCo7b
	6rf3pj+VTDWMNSNgWJazdmosQ1fYnZc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TDNJcMd6;
	spf=pass (imf01.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892507; a=rsa-sha256;
	cv=none;
	b=0iKwmUNaDcFBFSfzBoWCGrz0EGtaObwaxKKHIAAIOVjW44p1uyiYXRv0TvaaVbMXZZp6dz
	hsbtvr5HKFiACpshwMLioBGoa4NpGXtK/gYhar0OK25W9qvh/n058J3oDOFcEV5bZyjd8Q
	lSLrKqFd2Mo5hRVd2OacO3zUw+88M8o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BBCF417B5;
	Thu,  8 Jan 2026 17:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6360EC2BC86;
	Thu,  8 Jan 2026 17:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892506;
	bh=f+f4o4ynYy+1SY/DeVfHq3onGDbY5zceG5AUdIXzRFo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TDNJcMd6q902mahde+BO9wSWmbW9wjddkU26c1KViTrFBxwUdgE7cFhjS0dNF3jtf
	 6Kk0r/OwVHpHX55siH6IZecEdrCSr2DCgPJoaSgr4zwLDXirwvkRHwnst7SJcRNLcL
	 WwkGp1R5Oplpg8ID0G3hFXMyazl85w3U9ThrzJUR7nvfo0YAzzC84krpqTWECQ9+lI
	 RRrPBQx4aAyUO/5pyOG0rGiL0sMaMgJkiuOt7MJqeLW4Ry9+VXvGVxqNaTjIopbLYy
	 hGMNCDe+LUdCUZ/AYoAp6mt3lNoGuFLlkAljMn08t1i7ZscD156Xj/ScCXO0oBfPnT
	 /HctkjSSFO3jA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:06 -0500
Subject: [PATCH 11/24] jffs2: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-11-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1725; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=f+f4o4ynYy+1SY/DeVfHq3onGDbY5zceG5AUdIXzRFo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W7lCQZfgywIvw59WIEginzoekcq167e9p3d
 FIoynspkAuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/luwAKCRAADmhBGVaC
 FdDKD/4znaNh5ZW6PAHUf642a8kepq5X6OHMfltH9Cc7L/Be4t+uhH2C2l8lp1cvjF3p8Rpi3oA
 fZ+dR9bUW5GRyCJ3+vRKjVS5PRDra8bHdHtEx7mCNQeTzUhsLWKmjFoTVQ+2z6Dv47T6ZmLUrOW
 vt2kqZpnLjWLWWiPlf0sOMJIeswKuv5uKd88OxRHUWG2kQSOKbcKfwQcQ4bjSnR08ZPqmkmOos0
 TrsoXeTh7E52Ttx+5nLskrvumsAUMiLfNpAYGRnh5zS9deqJ/icejX/Tnm8rp/HfMYW9lZY1JLS
 uAR1InznJLqI5Ra1WMIM+/c+6E9oW407IRy23SocSVro/Mua/BIjEJ7gOfORQmHMPu3+9VYfcyt
 Dlxsr/Vz8PDZc+xqqrW5abevesTWIHsXWA6cp0lDEJG3JmUdmpVGPJ8g8DK8clPYo/rFC+9xN2e
 w+Ol9y3A0g4mbiyDNQShnxdoWa8G24T+TC06gfvWatd7epKfvf+QiHukAAjTB1zsTXPxn1Y3LzI
 +PZQPSYmATnn8m8nyY2wkZ8htVVohDBRW85B3Mp8M3jnGgMP0L7Ea5mp1wDVPTgyjwmRTpNCdV4
 18aUPXvyTh8KR3P0CgCnGA73VzPVfWcUEJ10+JBd6hS248f5/wSH14zMU2VeB2iNpgDdkeSQKbE
 um2oXzdHyzfwuLA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: 3449okibxckc5ddigk1s5asbnpn7my6t
X-Rspamd-Queue-Id: 5E2674000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767892507-177857
X-HE-Meta: U2FsdGVkX19wZx4x+55PUXA3LA0d8SxybAhykEsDVEX7n541j8/TBP/nmrDO/YDJB8lQCRRG3WZ3H9SprsNwEX5LSfP1v1CZFeWCsV3k+Yw4kUgqoQkW5Gw0jLz4xeAoTH89ddgsZ9KabJvaEwKqsgEn0iS6YUKp3vMl3RS2yfhzCEDfl5d/pc/aiWX64bdvdFQ9wXQ6wHnNoswKfonT+roj4mxSAl1NT61wPagGde2LvrkOz2x5Gke5Nat8IlmBm6XW704acGSb7Q78foSkfhkwV7mncNglGEesGrhJnK5YaWd7qLGH3tNlqpxZABMmkdEI7A2VhpkwsxQJhXlmDKzObizR+dWu1c3aQBy8wKOKUcUNrJbmCwXdAY/5YWLC19P0QAw/5f/ldTNblkNzZCFhKGSRR6eVoiY2nm8voFTM5KU+0AjdrD3YUIIZrtx+wKkgwywniYQ/J5UzSICKe1WZ6BJuccRzRnKn4DwySXBNzMkokxN0TtEExg5yszSngMww5CU6gzQp+d4zLPD2NDh1nsY2dh2x1xymOJEv1fBJest7HruuHUuvauMl2kBtpmOYaDDUnKLFpH8xzBzyIHGp0B5UAoqmLeCFf2EXeZluwehI64pV1cGii5yfykBnVd2xqWamVFxDOJ23JM8ipDYyOkRvUi713PbFT8sDf1yXp9hIJXE+3jRO26NfPy4KQlegcIp1q+Tq8kxr0mAI7AVWP01kqbRhHQlyohgggCDhpfxCw4CTuCvnjtiYUOJbxnVzdnm3FJNRqs3f765W/lT/G47PJUiF/hXlV9yOR1wHl47MBPOlb5wX0e9AsXtnmRQsKTRfa0PwYJQOreQ6ghqKv82aPbQIcIheQgypmfXJUoqjWbkXIec/F00AlK95zXRxEf6J+MUotswmfH0rVjO//Z2h6FpLDYFInQflnC/FK9IvT9p5fiTsbAetN2bszycJ3x5lyAVmDyFyOPD
 Gqko4AEM
 LfaKNKKIhHlDLtFIQwaAWKKJ0bFNxkDDEzvKh9DMToXWrNf3r3HjjDX3hfKYeB1X9/c/QM3Qw8ZAWJJP7P9C9ZBRW0gCEy26ISiWydDAtNJc/Lb3YeXcvM6EZcEzxTFXG6KZjSd2lkgjSifGbDDFREqsIq4URthOYyfVXdC2hdsJK9CeKRZeuC+2/RDRFmI3t3vAk49TZ+yXlM3aGHHrkXYRtSgPxZp1eFbl6crOmevAeyVIWhcu6lAcL/IBgPMCL72YPRpplRZ/EX3t/q75/wLQk48X6nvVcNezV8yCqej9VsPHBSmoq9w0v1180Xim6lllvnjkBAUHCkqo03Ytu96N2vlZGSAICYbYIG04FbONJ5WFduizdB2vSxz0MfEPPLclm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to jffs2_file_operations and
jffs2_dir_operations, pointing to generic_setlease.  A future patch
will change the default behavior to reject lease attempts with -EINVAL
when there is no setlease file operation defined. Add generic_setlease
to retain the ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jffs2/dir.c  | 2 ++
 fs/jffs2/file.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index dd91f725ded69ccb3a240aafd72a4b552f21bcd9..2b38ce1fd8e8d8d59e80f6ffb9ea2935f8cb27e4 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
+#include <linux/filelock.h>
 #include <linux/crc32.h>
 #include <linux/jffs2.h>
 #include "jffs2_fs_i.h"
@@ -48,6 +49,7 @@ const struct file_operations jffs2_dir_operations =
 	.unlocked_ioctl=jffs2_ioctl,
 	.fsync =	jffs2_fsync,
 	.llseek =	generic_file_llseek,
+	.setlease =	generic_setlease,
 };
 
 
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index b697f3c259ef25171ce30785d4584d5a53751a0d..5e1ef4bc009b6e5b4818a7467639fc328c137c12 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -14,6 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/fs.h>
+#include <linux/filelock.h>
 #include <linux/time.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
@@ -60,6 +61,7 @@ const struct file_operations jffs2_file_operations =
 	.fsync =	jffs2_fsync,
 	.splice_read =	filemap_splice_read,
 	.splice_write = iter_file_splice_write,
+	.setlease =	generic_setlease,
 };
 
 /* jffs2_file_inode_operations */

-- 
2.52.0


