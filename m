Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C30D46608
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0124D6B0093; Thu, 15 Jan 2026 12:48:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB006B0096; Thu, 15 Jan 2026 12:48:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9FB46B0098; Thu, 15 Jan 2026 12:48:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C353A6B0093
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:48:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 795C0B9803
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:11 +0000 (UTC)
X-FDA: 84334931982.20.F43F603
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id CCA1E180010
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VOFwUkEJ;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499290; a=rsa-sha256;
	cv=none;
	b=09BMbVmg3JvSrRQicO2MqtQtlXUf6MzFfG2Y0k2A1cR/YiN9xftDMqZli+nHGGUUVcpgur
	nfKpDR48bJdbKyxUiOHzLRAVitZDGKORFlYbvLE1PA9QyEIlscY/rJItlTI3l5st0NxAhd
	Y3k3ONbgrCBpi1PIOO2kR+PQaUvgZTk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VOFwUkEJ;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqvPPwty7daKeSHyhIolVfaHuj4QmIwyhDjw7DvVsKg=;
	b=69vCYDiOOmoCSUrdvmctTRw5VsIV2h3E5u+peLs0DVKpHOxmW6dK+2xg96aIb55EDFlick
	7VTd0/YGfHwZRCvUIipvdcx5hGXcapdW4fdhhSTgWl2ULGPLb7uImDkfzwEFXlbBWZr/9m
	xUd5D8EqDm+J2eL/IqvL41KLF8KCd9U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E875144322;
	Thu, 15 Jan 2026 17:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76392C2BCAF;
	Thu, 15 Jan 2026 17:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499288;
	bh=RatR/m42YXTf7CDA2CRhGedueCSbBBqPoEedVs8C9UA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VOFwUkEJYHXeJXZRL0zb6eR6uUkxRN6kee6xDzHjmgu/5n0uJWSJAGIa3iEZf2Lg5
	 lrmFB48PnhjOkIGftUE7FVsqT4OhDUbx7K94Awns52sziz0jZpwHnSwAotvQh9go6G
	 Zo5qVJrJCTeW+EYm8RkT1AHIIjI4FEVXimKg+J0MhIDVSiFaPKoaNwen3lqywhgu7/
	 6LXz5VvJpXQJcRFroHj6/0MKUhMKcD4/ei6N/XtrqN80C8gSBdoXmdkSxh52BGo+am
	 jWfhM+WqcPi6cHCYVvHnXDhmoAc7qwGGCr9+E9m6pasHToUBBOCqkijjTvFPBJ55ff
	 ezWMduEtFCLPg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:32 -0500
Subject: [PATCH 01/29] exportfs: add new EXPORT_OP_STABLE_HANDLES flag
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-1-8e80160e3c0c@kernel.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
To: Christian Brauner <brauner@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, 
 Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
 Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Dave Kleikamp <shaggy@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
 ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
 linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
 linux-f2fs-devel@lists.sourceforge.net, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2664; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=RatR/m42YXTf7CDA2CRhGedueCSbBBqPoEedVs8C9UA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShEw8HrDl/7ZIM2OU/hVtFHsnd81WblzyW/e
 yPqA+8+5UGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRAAKCRAADmhBGVaC
 FYotEACEnxwn1zEGzienetvotgfcnP0KEaEoc3vEq4xPjrvl8qD8AzHl5lAD9pOV95V0vyU1jWl
 F+LEfCXY/wJ0q8m3Y2mFHyBxMY8nD5PoBm5N4fXW/WYFI8u99g9N4VNJkrMQ9HTzKeVAKTl/M1J
 mrbI22t/onu2ymRGzRqNb/kAFe3UnZKq5nzacFwoBRbfAKrjqjfaJPjermi4aUlVjCjekIh0TEE
 Ds0g+E5VMeObKsUc14iLHgf2OKqEIRvMP8DaK6mlvpMXaAD3YHzptTey4nYKQUZRFFZcleYPplo
 SWrEuNsKUdPrwdG65vHBuaIE9yEzchlvNdGyIGc7aqrMOax0dCU8qPoLhlLadC25xQrrazgFoH2
 l/Y92N1//yzg8uUwnicfsrF77KdgC9ImgrgBPrbAboDvmBqOCGgIiepgsb7Q62IXUYph956Fup4
 YiuHKS6eRp+flNlvzvNOVL21skn3W1rV/ffia9WkmS52EfWCBJLfMVFLlM5Fxs+XfASNsPkZcjk
 7A3T0E92BC/sj2ln5xSO/2PWamRs0o+Fjo1zTnuo4iAMVwDZQ5EpZMWc7wQnI3KnxwLfagRAPXu
 7gOokL39dJc1Puy9BUCKYlRaUcifcB3ctHJTgr0/wiT5j/Fovcjx2nirH3rLSgIbyorjoAiOcP2
 f+X4rzQbvEzY5lw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: ifkjejzswya53rqha5h1mo5hpqnotoqc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCA1E180010
X-Rspam-User: 
X-HE-Tag: 1768499289-400752
X-HE-Meta: U2FsdGVkX19S/veWPFH/WMKJk6fZ6EtKtsY2sA7uuAPMCC5TI5I+6JcLrWhOOur90NMp4UK0/mDXBGWhuu6trPNgEUOM/DYhsfFt7Yuhg2BXvS0qCQ8eLYy3eKh3cZjIu2+e0g0Cvf4ou3c/1341Trw1fhy3nl9InZTFInwxWo9wdArwxyLwzgdzJjXB8bul9yTENmqWjmUnlbQ+EmZoG/ErZFOhZ9CryVyv/R3C+6II6G1M8T3fEwNXKJWSR6SrEP0RE9FYl0od2BYXqt79YC6TQTY0SdJms5+Rw9jBzIHN9dp0TVsKsuZXR1dxxpnE/l8BssbF/pkuyvdr/5iH/+fbLVnVnxC6bDweLUF4Zym99TifdXwH56LHumkKXGKRCcXwe/W4i/YlyOpRihV/Ct0dweAHucR7IBjTrAuOR+QRaai9cry/VwzQ8wNc6L35irwGLp8kr0RXiYTCQyDalKpNHY9Tl/vBmK93i/REXuq4i8isdys1pCBbdUaH3JTyywxPTJL7CRhDbhsHrGmLhfjgB8J1UC/5L2viBhCI2nY4QBl81dVaDcgQf57aT1jewoHKUlgI5K8OORMzOPAhD+/yOjdt8BFBy+5QZNHJlverBayEJZMkFka5fqV5C4BsH/sBmjXcU34qPbZ1qSDHznkXYeFMDSCHK/g/N3/BxzajTr2IhxFET1S29GexF6J2Q0mfrCfUKILtoFefeBa2tpvQ1nNkjPAGnWlD9xh7YR/rEEEsDvoAlsudyl9ZkRT7WZyTMgIxCMcJfz3HcMHjJACBEGV3kYw0CErgHM+qt0PPOzNnaZgpzbdnCRPBcl3Oh/zBMKnVJ55fZbIaItxVHuVr8MncClkzYhCn19zpCzArXZf/ghhwew6UNL3BltSRyOjpvs+Ypr9bk9y+NlrTNLvOWEeYE164CAF99qeBHrtqIVcJ2qTKVXdvFZab1r4cJpDcCGBsEu4io8PWod8
 56DBV6QB
 S0eK9Atfl6okj/ZqygTcM2uViI4/djygP5bN1TQx8iKbzpWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At one time, nfsd could take the presence of struct export_operations to
be an indicator that a filesystem was exportable via NFS. Since then, a
lot of filesystems have grown export operations in order to provide
filehandle support. Some of those (e.g. kernfs, pidfs, and nsfs) are not
suitable for export via NFS since they lack filehandles that are
stable across reboot.

Add a new EXPORT_OP_STABLE_HANDLES flag that indicates that the
filesystem supports perisistent filehandles, a requirement for nfs
export. While in there, switch to the BIT() macro for defining these
flags.

For now, the flag is not checked anywhere. That will come later after
we've added it to the existing filesystems that need to remain
exportable.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/exportfs.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index f0cf2714ec52dd942b8f1c455a25702bd7e412b3..159b679ef176dc710e9d0107ff9315534c44f715 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -3,6 +3,7 @@
 #define LINUX_EXPORTFS_H 1
 
 #include <linux/types.h>
+#include <linux/bits.h>
 #include <linux/path.h>
 
 struct dentry;
@@ -277,15 +278,16 @@ struct export_operations {
 			     int nr_iomaps, struct iattr *iattr);
 	int (*permission)(struct handle_to_path_ctx *ctx, unsigned int oflags);
 	struct file * (*open)(const struct path *path, unsigned int oflags);
-#define	EXPORT_OP_NOWCC			(0x1) /* don't collect v3 wcc data */
-#define	EXPORT_OP_NOSUBTREECHK		(0x2) /* no subtree checking */
-#define	EXPORT_OP_CLOSE_BEFORE_UNLINK	(0x4) /* close files before unlink */
-#define EXPORT_OP_REMOTE_FS		(0x8) /* Filesystem is remote */
-#define EXPORT_OP_NOATOMIC_ATTR		(0x10) /* Filesystem cannot supply
+#define EXPORT_OP_NOWCC			BIT(0) /* don't collect v3 wcc data */
+#define EXPORT_OP_NOSUBTREECHK		BIT(1) /* no subtree checking */
+#define EXPORT_OP_CLOSE_BEFORE_UNLINK	BIT(2) /* close files before unlink */
+#define EXPORT_OP_REMOTE_FS		BIT(3) /* Filesystem is remote */
+#define EXPORT_OP_NOATOMIC_ATTR		BIT(4) /* Filesystem cannot supply
 						  atomic attribute updates
 						*/
-#define EXPORT_OP_FLUSH_ON_CLOSE	(0x20) /* fs flushes file data on close */
-#define EXPORT_OP_NOLOCKS		(0x40) /* no file locking support */
+#define EXPORT_OP_FLUSH_ON_CLOSE	BIT(5) /* fs flushes file data on close */
+#define EXPORT_OP_NOLOCKS		BIT(6) /* no file locking support */
+#define EXPORT_OP_STABLE_HANDLES	BIT(7) /* required for nfsd export */
 	unsigned long	flags;
 };
 

-- 
2.52.0


