Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A80D1D484
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F17C6B0095; Thu,  8 Jan 2026 12:14:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9346B0096; Thu,  8 Jan 2026 12:14:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEC16B0098; Thu,  8 Jan 2026 12:14:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F20546B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:14:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 714381A914
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:15 +0000 (UTC)
X-FDA: 84309444870.14.7C5D920
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 93E8DC0006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j99SvAIt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kkg71EWSeprcImfa5ddRfKn2RSTuMpwmSFgyDbj1AnQ=;
	b=IXMUudazEv9hL0hPqvqmmfAHYEwle5HsxDEjwljQoLmLnr9LbK1KnMid5gqoImn89kJpmj
	XhHlXlr8d5CSPhtPSNFqMM+X6djML81css7Hc7JGuufywM5vzKOI4V3/alibI0kBAJiCiN
	Ad5mK9fHRAqt1Z2EsPcb+cB3+8EGjQA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892453; a=rsa-sha256;
	cv=none;
	b=kn2QdeQ7xaddJc20aVNa6TCdAoGD+fQ//1aZLN/wbX5bAm+0ub5/B6COUQwue01uIBzGzv
	iMYUnvRJRwby1p7nBWFx0f03pn/0UqevdccyDwnL8Oryud/Vx0OdQBzUxXhFLdNhZbaP3X
	HBnbhgukMYCUqxZ5NwlWtzEsPZwqg9A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j99SvAIt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF05844447;
	Thu,  8 Jan 2026 17:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4074CC19425;
	Thu,  8 Jan 2026 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892452;
	bh=VftDczW/RHsJtQlFSh7tMNcNMgHiKsCQqbNqeRwhe8M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=j99SvAItuEybJQBvSLRmS84TU6WfiMXcwP4088ncl0dJj+X259KHWw6MyQaVA6kzG
	 oPECA4FMVMlKYCaehvDpXJop8Q5F9GB6xcIpkmXdQfwEeHYkZKRbSQo/tX0X0Vod+F
	 YwJ8wOS73tcNHPzcd/R3k0xGjyff89YBIGM88fZxZiGqpb1rNl4GH4X0MfrQbUz5X/
	 deIlelXnp2vAuxtcCCSrk8BdHKA7r5LVJ4LthrAmFJ6fKW4CsejZe4y3BBnBYmqLEo
	 B5FNDOVl5khkljZAkIaZIcl517lxY8NW1YoU4ftIV+/iXX2kw7jQlQAxoYIM0yzy85
	 WjVk+AL/vpoKw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:12:59 -0500
Subject: [PATCH 04/24] erofs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-4-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1708; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=VftDczW/RHsJtQlFSh7tMNcNMgHiKsCQqbNqeRwhe8M=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W5D39raWTfk9/NpmK8oPAiQK6j/fZNQTiK0
 mXiB1deOuGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/luQAKCRAADmhBGVaC
 FbTRD/9xYLwsFFCpMX2yKeF7C19Mw/69euFVil3d3rGhY6NZgqpWQsWs+JPk6AGiudh1ympKi5w
 KDV+WfIgFEJmQLVRx4btFU2+9X7RuD8uopNt2+hBQ9T04zGegtApypSIVLnGs1+r9L4qJl3HyIS
 uFJEFRe2WEdQMdw75UuDMHDhTG4JauCXcBvhHzNkUJ929nJ2ydpltqDWjFB+0DpLJ7azASrMhyb
 krcESpUqm0OlIHWMdMjbnGjzyPJCqQ8hCoF3VzawdQKOgREhTJjubThh1DEd0yHIp+IHGoZ0wc8
 +u56IZBx9vRkFGSfFplpt859W+e30+UTK6xtuPKcctDAT3jzkQUPcm9U3vHJfCajQkRp1BmCXBS
 WsSqysXEnUswTRGrUYEOXJoyumVWdylrjPfxGAWgI8dFJGz9hlkCzbMkX+HLFcvprO1JUqkpN5F
 QPlVLf+TnsluOr22vHgTLRlGSJ9nipt+5o0qpPTapb+lL0rrnjQYmW66aW7Vo13m0r6awIecRPL
 Ce4ct5XpiPQhWFVrIoB2IgvkQ5jt9+F4VUtIRTXttAYxGyrYjRT/5UwkyQmJgSuGZePp/Ui3unG
 0fryUPfSGOknDKNo1Rkpn48p7/uO4AnZ/pW355qfgq3htYkBkKrNbtxG6WL/qG03/mNBF7dnRxn
 F798ZpjLR9Wc1wg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 93E8DC0006
X-Stat-Signature: 1p4sdnpewsrszb35tbqk1x9p8dwt56yh
X-HE-Tag: 1767892453-97211
X-HE-Meta: U2FsdGVkX18PfW2VAV1qxSNLgMShbYFEM21D7pxXviG8RJrXhEC7avITfMEEpIUYe0LMR74jrqk46OEJa1GdvlZ/5B0Q7rEcxhbi4uuw7kVCILMDKPLONwQxsr6hFifKkA7cMt8R2GWppxNiKG8vtk/jSXn1l6Zw31hpxTylh5XkKtm9RB32A1WpnODP/Wb24zdOBL2R7KK3IwjJRLEGr68fpzPzfajm7PWWKx/XK0gSsN2cOOhXWh4PkGz9gtAmt2bOO5eUqb8yTxOHpQHFduSypky4d04Z8k1cH6RmN/CP/EOUIT8MybuJaFR/119rk5zZqbexfzqT5UBmDqE9a1+eqESELob/rPEqsdlHztPpLDUzxs3HXDh9vNn0Vdmh3+36mpEkEcs9XU/k1tsA8KzRe+o3CEx2wgDmmzl8TwiJA4ztG0ePoFSH3iQ0qUuDSY9L3CIBQMor0xoLy551fXM5KVR1SpgGhNxECAyRrnC5erNTgF/iLaYTdLlO5yrT0kiHGMoT83nAIxyfn2OTDGnPPVY7rcxkuMAt6Uc60MAxB/CTuvAqR+bWEKgxvkeClhOixaeGXLMvK5m3zBI2uQaWrQG/Pn1t8yFlE6skYyovtBxwVhIlbvHxl4tl77FRnB9Gi5VAkYdGOM8YjKJUp8IABAFUguZeLWAZak1zHLfiWmvgf0CAmboe64Ip0OR81ur9GCs7+RqS6BRNbV5E5qxriYsGJiI0RN9DK1ylOoYJH6UM3LKyNdHRkF2q8FnbcszTdMFXa48ZmZboyYRJy5JubRRTiF3Wdffwq6p+9ToHELg5dkokmGdRaQMkuoFxNOwxQ1VqOnY86hTuu3AzdLOyzgX5LWOXGOx25LTmKPcSabPbFywXy3PW//DwExuECNDz7W8pPihavHyeF8vHhW9AjV/r4SyEm7PGzc623BcELELfFOHZ2xH3c5DI+7lZ+vw72sY4srOVk6FYBQM
 exJAKar4
 vOJUEcMmei3Ysjy4WE5/o6mP+35r9lXXyceyhM+iWA5Qep/9snTc1zI6eDDh8ltYnuNKKKOg7NY8ftHTPGgR+IVljj5AoVQ64dEZmPdcT7Supv9nlnYy1Jgt+uI257IeFFvS+9G56TUfQXHlNfQA0iuZOJkkDoVtEOx/6mkUkIlhFaW+aW1fgswYBgU8fUDiR2Y6XNSuz/GBPKxis1w5eSjEiGDsUzv3TVInKKQO4zh0xaEpojlt4GBSiRcPqR1J69qAxCxs/mJND8kOkuyG0qTCEM4eMaecD8GUo6FpGvJWfOIYBA5mThy/Aw2cHbKdwTA1gjJI1iWVmLVkBYfWtsu9RoBHFKL0UR9uZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to erofs_file_fops and erofs_dir_fops,
pointing to generic_setlease.  A future patch will change the default
behavior to reject lease attempts with -EINVAL when there is no
setlease file operation defined. Add generic_setlease to retain the
ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/erofs/data.c | 2 ++
 fs/erofs/dir.c  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index bb13c4cb845563492a616fc000910112b92df555..e2941b4715616528ddede2dbb9c0744db5d11be5 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2021, Alibaba Cloud
  */
 #include "internal.h"
+#include <linux/filelock.h>
 #include <linux/sched/mm.h>
 #include <trace/events/erofs.h>
 
@@ -483,4 +484,5 @@ const struct file_operations erofs_file_fops = {
 	.mmap_prepare	= erofs_file_mmap_prepare,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= filemap_splice_read,
+	.setlease	= generic_setlease,
 };
diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
index 32b4f5aa60c986dc2acf209960ff6df4077c7aa1..e5132575b9d3ef958a8acbe80bd0d2ddbd865135 100644
--- a/fs/erofs/dir.c
+++ b/fs/erofs/dir.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2022, Alibaba Cloud
  */
 #include "internal.h"
+#include <linux/filelock.h>
 
 static int erofs_fill_dentries(struct inode *dir, struct dir_context *ctx,
 			       void *dentry_blk, struct erofs_dirent *de,
@@ -127,4 +128,5 @@ const struct file_operations erofs_dir_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = erofs_compat_ioctl,
 #endif
+	.setlease	= generic_setlease,
 };

-- 
2.52.0


