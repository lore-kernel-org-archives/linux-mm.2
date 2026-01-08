Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1512DD1D480
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE876B00B5; Thu,  8 Jan 2026 12:15:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730F66B00B7; Thu,  8 Jan 2026 12:15:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64ABB6B00B8; Thu,  8 Jan 2026 12:15:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 53B296B00B5
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:15:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFE63C1222
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:46 +0000 (UTC)
X-FDA: 84309448692.08.168814B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0786E120002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:15:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SJag7iH3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892545; a=rsa-sha256;
	cv=none;
	b=pH1KToq7VmpyqbmlS+zPduXiS+yX0t9e3G/NwkG26HnDPns1Dh7FCWwauyGSFdF2aNJ6XD
	jJrbvLf/hIrz9aJRUcX3fI7WbzSwg5FxfQmAURr78gwRqNpo+Z08j/rKZ2jki8mETEhPjz
	FwaHDqNSlTadKjaUoFY0RjwKVUEYBwg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SJag7iH3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XcFh/czpyXOajdzHyALx2Xni8o9OGe6EhHADm2EuoZg=;
	b=nc4yPJzRTR54+AGdpzdEUPSeY8GSV8KCRgGo5dZR54797ztAnq6/9bDumFPHQvz4Qo2oeF
	htcAJbi7B0ryFFKZLR9DbZH6KJRqH577J/bExbPqTw/zrwZdSSXh288tG8vM3D3fF7MEf7
	gQu+E0+MXassysIjvP+ppDmMsL0OrCQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81A2F6014E;
	Thu,  8 Jan 2026 17:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEF5C116D0;
	Thu,  8 Jan 2026 17:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892544;
	bh=yVN7kiv7Ur9Q7AnxVgFewkb0L/ZX8mnNajC6Hfb4ItY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SJag7iH3Ulhau+TT2S0OSUAXBwy5iFmcU6Lcje37qhWyUrVVIS0QTH2e5wxI2OWuV
	 uM0Dam7qLl6fl4teot25YDB/0LrIoV6VDVLM3R3t7DnQHbujCZPv6ddb9BKAedtSKV
	 t7+lntHNYOrLgAPao6XUgZGgqu8HjC4jex629eXoSfP4riBGPiL79zD76/2NIF5M+N
	 uX1qwg88WzADWZnJTDvKeIPDL1RrhDcY9+1Tyo7ILZF8wYpjcPUZbG8Kk/7gsRnW7M
	 UsjdAKxfEW+GG6kp5DFxc22CxtnZQjt0Ua7js1IxpNyLl6YAFmV6M9UkWWvJcPJkR3
	 TovnFOD6YpvAA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:11 -0500
Subject: [PATCH 16/24] orangefs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-16-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1607; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=yVN7kiv7Ur9Q7AnxVgFewkb0L/ZX8mnNajC6Hfb4ItY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W8gf6yTM9PqdgCO6Yh8PQSc1Poy4aktqHXE
 EqXCbQwiOyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/lvAAKCRAADmhBGVaC
 FRuXD/4oWPnRKMqdVVRPF71peTc836Dva171JxklgwmgsfBGNY9Coh6fglKyMqQ9V24XwbsVH7q
 SRxFfC/rZ6jRd8MVmFU4q1T864Bnzpra/VJ4veI4DPnrg77egeKX2Jx4mb0mba4rht+TFrkFCDK
 mhcPTMUj9KmWha9AOJ4147BC7Qf3qLGG9uxvqeIxHVjUN1BTNY7/BNqyZDjaygnRUIqJCWtjTOv
 YUN4eNnfRQLRKyfHAlMfbB/dlZgDLx7Q/W7Vou66JjuFzzyB17eRnChjoMC93Q44naBsb3lFX3K
 yvzZpsHh5/dCXj0hGaJ1QYi0Jg9b96rKOyntmvJpG9LPz7ciN3od6SzIH9dIvxov45RkSSGaEpy
 IuODOTTn6S41W6SKtB8fubBQCalo87arg2F+fCtLTgaMB0MsteZMBW4HgQnOFNQ9et5q4MSGTZ4
 gD/Xf6MItMTAI4y+k66u7nf3hJ5aYHRsVtsVqjfA2nWqduNGthfEsAjx0U/R/sxbYQXikUfsiOK
 2Q/74eTQIZa2aisqeUf91C+8I05nZsfE96suNoVb/cEL/V57lNG3stvWfm+owGEN3dovr8YFNqD
 lwM/fCzJuwDoCBqjnWCQ4bOIop1NH95s7W++pbtI3bHQhWhN7B3NYsK7YTHsRJOGC1ngl5pluTK
 +CL061T+fPDjdpw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: q45ckdhzsmowzhqpni1ktpc3bzexbq9j
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0786E120002
X-HE-Tag: 1767892544-719750
X-HE-Meta: U2FsdGVkX19pICv3US+8pU/zxwYRc7MbDPwtFxg8SCziyoNuLbp+ZeI1WZ488InUzVVxXm6/4X5o+JoxSecaFQjhncknr/Npt7YgiNB3QfmcOXs0jfiMz0CCqakWQPaS8rZ/JgilDtddv9SdzpoTY+FMpFUPMGWHhKv+QTBGEBU8DQj0zi5LtMSMiTFKW5MFNBbRvvQkh/ilVefJLFPQXQsVGkdYqHmrsrxJtmAIBztVl2rYlpOGrUgVS3gHkaIm3x8cWjpir5rrh9P7Fu3hXLtNm5IUfZfNT7LNDwim4UyX895Gclk3Skl0AsE/Rvy2vrowGBfl4gmpB9/zdo9Bc5ZuAx+iVRn+cLTnKs7ryC7S6bDlqAKtVK4WnutaftO5wBafiMZ09H3ZzZd0UMerqdETAbcWnKiIkpNLrzx3mbqap/B+JDmj3rFDCwCZHpGm+Qt+ZMJsYlcTszfnK4Z3pcT5oubTYfhPnkAjllH5QoTPojBCLuz54SNHooBASgPsSA4/ofGQjKiAKUWF62yVfpU9rVwLN6Oexb8VWUXOahksZOb1yjb0/OcetwfKiDnyWaSpfZYDztlMyN46aPdT8yETAxtvwrCKlfZZMz30CInHaSm7e3Pgmk0mrl5HyppRsnTmi2MgP3GSn2nzJSSLmkLSX/PITBskTCIPokBwIXQVOL4l4Of91JPll2iPEHgDsmptKhkx47RUDw9as5qFmadZAqC58jDq+uM9XuwrKv+RcPJObANtTzPBReQWfTcyVWHF/OXLBaRa/YtH+vLq88/wmdCSrHk7VJoovcJqvDbx2dVFulCMz0qNA0t4JBhH/MFQ09ydl5DiN2voMoQ1PAgR9kTHHv21RgBhZO43S/6BDKb7lZTYJ4L3EACKxhg69e0G7rHrEzgXm2b6QN2IxcgJliMbwUCoPhpp/TIR9NouzCsZfEZ8Tp/k417IAkjVBbuc2qJE5z/r3t69Wbo
 iJ74Xszb
 YYF/rgEzOzRz/f3Zn/sPvGJvMX+kk6DYg+EH/6bxP8MjvTg5alP6lbpX8s121CGUWyUPrUEFkX4KSm9gEBxQTPlEy2ImdyRgg7YB+234B/tgIIVyi6ZC+/uS+0uzbgJ0/6hgbkxpqIzj8DneBvY2tltSELQHL0pvqJol3JwfiP9WR6ylJxeJPEtij4NFrmE3U4Dc47BB8Q2/FAunCg94nEN3dhWS7CQTbq8HwaF8pB7HOFz+GAIbs/vijXXjWfwp2gnMy3qsHM2/1Ozg791cve9uAkYPk7HBxURCZdopv8GP+5iw89oxwJxIFHlMMnWSl9RZ3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to orangefs_file_operations and
orangefs_dir_operations, pointing to generic_setlease.	A future patch
will change the default behavior to reject lease attempts with -EINVAL
when there is no setlease file operation defined. Add generic_setlease
to retain the ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/orangefs/dir.c  | 4 +++-
 fs/orangefs/file.c | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/orangefs/dir.c b/fs/orangefs/dir.c
index 6d1fbeca9d8172a2155f5b524cd19bc896748d64..3c32bf9f1296e5eb62a7a603faaf4a5493c57166 100644
--- a/fs/orangefs/dir.c
+++ b/fs/orangefs/dir.c
@@ -3,6 +3,7 @@
  * Copyright 2017 Omnibond Systems, L.L.C.
  */
 
+#include <linux/filelock.h>
 #include "protocol.h"
 #include "orangefs-kernel.h"
 #include "orangefs-bufmap.h"
@@ -392,5 +393,6 @@ const struct file_operations orangefs_dir_operations = {
 	.read = generic_read_dir,
 	.iterate_shared = orangefs_dir_iterate,
 	.open = orangefs_dir_open,
-	.release = orangefs_dir_release
+	.release = orangefs_dir_release,
+	.setlease = generic_setlease,
 };
diff --git a/fs/orangefs/file.c b/fs/orangefs/file.c
index 919f99b16834160dd8cc87faf9b8802aa02796cf..afd610a3fc68855eba1c892d91a5c0686876cfc3 100644
--- a/fs/orangefs/file.c
+++ b/fs/orangefs/file.c
@@ -583,4 +583,5 @@ const struct file_operations orangefs_file_operations = {
 	.flush		= orangefs_flush,
 	.release	= orangefs_file_release,
 	.fsync		= orangefs_fsync,
+	.setlease	= generic_setlease,
 };

-- 
2.52.0


