Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0DF3D29C46
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1E46B0276; Mon, 19 Jan 2026 11:27:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5B56B0278; Mon, 19 Jan 2026 11:27:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7D96B0279; Mon, 19 Jan 2026 11:27:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 054836B0276
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:27:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6E5F1AE34F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:37 +0000 (UTC)
X-FDA: 84349244154.22.71DDEF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB9CA40004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fFGw0Nlb;
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LBMqF0fnkOKDDiKj1UARiPJl+jkJNUF0Z0wVc1Tm3U=;
	b=BI8PDTm0EAcHcsZMcLytOyVd7fAVWdZNzhNEp2Zx1jyfei7sYXD+391UYryK2ZOxZwHT/7
	mN1Ks2UoRk8IV+pjfrpajyuIruOhJGD5DtglnoDYnvJ9n/4gPeR5S0Beq0yt6id0BgfC2X
	lYsbZfLVZQaKMdIU/g5mw5nw2xZvSUU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fFGw0Nlb;
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840055; a=rsa-sha256;
	cv=none;
	b=M+hWTVGi0MdSsqZVBVhaK8mkKIuQZvaN9Gp5ch+b+qIoauZP3IzEb3+/6ap/BCqI7tRra0
	ljnG9A9zn2Be6ZcV34Xaxou6erCqsjiDKkDMyaRHPHXsmEJpCdX1daJYtux8m4VU0xAqtf
	4cIcY5IsxRyKYyMxEYXSvvs2LOiZWvc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA21544515;
	Mon, 19 Jan 2026 16:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F16C2BC86;
	Mon, 19 Jan 2026 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840054;
	bh=WOmtIr1IsB2xi2+MQpnozeMDf4MRJ512rkEzgmzicq0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fFGw0NlbN5TsRC2ZjlZjZn9IX/42PhPSQnnYH/4v7sgwhqTBMY/MxwIMIlKkHQgff
	 IsnuLQGgFH8eWVaaGOR+eMsdGER+dvGyTUfbMzLqADvcxjbHTL48XRw/G/ojzS6ubF
	 gxWUU+M9COq59S0/XzQ0Rg2QVwbbyQSi2S57Ixy4HGcUaYn0kCzvwW32x4YptCcCne
	 TC5kQgRykkBR+Q/5D8riOm2605W/IKWQgExzxr/JW0sdu9dkxBbhSvoXfvEW1caiEP
	 Jtfr/b52H65goyMqJXxHvpQS5ggVa0+AKp5u4wRq/MKYBMwp0R6Slbqb969DTxzRNV
	 Kdv1LlGm6aQKg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:19 -0500
Subject: [PATCH v2 02/31] exportfs: add new EXPORT_OP_STABLE_HANDLES flag
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-2-d93368f903bd@kernel.org>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
In-Reply-To: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
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
 Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
 linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, 
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
 gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net, 
 linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3825; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=WOmtIr1IsB2xi2+MQpnozeMDf4MRJ512rkEzgmzicq0=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltZJJ4Erxc99mz4JD4fpPhibGNL6s9qiEaxZ
 +ast/XYA8KJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bWQAKCRAADmhBGVaC
 FRr2EACvlm3De5JtqwIRiAJ+yR+TrnRM6zVnaaBcPqW7NWtaotgXHbjPmhHalzQ2ehLlMs4pBwW
 CJdzL/0SuDHd+1ninl8HscU8YeUjTL2yuS1baFgceqGQ56wAeo1gFcMtbsngMt0UiC5VhNd5lzQ
 hisUbwG+ATmkxRNQlt1jg5Knn2k28x7ZuUBDbB9vNczmKJ2P3gR4vHlU6toocVh4tp1XLS8YnS4
 /Th6ZoeqlrAyCsLW2EjmEjXRmVT3n9bN3rhj5BRL01f5sWIKM6YimBAXNaGgfT6UVTHVYycMqid
 z8zjumO5an17putv+hHHquqigVwMPoFkl/R//xJ/wD3NuR6WXPWj/YfRuSTQ6HrgP3/xw6XGitp
 THrn0RYY6owKt+oRWUEoL3eIf6yNlcLh6Z+A7iaacop4/RyPQcauGbboHVG+zQrFpRA0TYU2QWr
 OJuePE5rbnQL9s8mlCeoPUUbX0I0E2jges1C26w/uthmL5Jmlg1eyzXFafUNmt45LVS97O17yyA
 A2BOWaDmYRmleIMtYuRGy98LCY2KV91GcRPRO/n424NqA6H2dC2jvKwMZAfZLHNYZBLKEgJ+x1O
 GEgCl6Q0UBJ87Io0WzdKw7SlTPxZyLbVNRNcBAm3/kG8WoQXajMQfr4a1wQ/fclJWtptjFdnzZD
 anI/Pt3rN8rtBBA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: BB9CA40004
X-Stat-Signature: krac6rfdjcxfay3g4rqtinnadcwq77x9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768840055-766348
X-HE-Meta: U2FsdGVkX19H6lfECbiR5E/gkvlUNXqY8wPoZMMukQEI3VjQno3xzd7N2AU7v3lP8uGk+I9ak4h1o5Ai8Oo3TTubogmSrzvn1HVToHZ1lO7/ZQES1vY5EID6JifdzRQgxevqjv8aldSimMRyHLjRZkKEe3WqrSkL71W/wUeFuZ4LfUEz+CD//ED/+tl/i2OVvlHwkfPdKdyShpYrJtlUcUXIb8x9DmYxKEWkqOVd/MeLlWA49WdU5xD8sMOTlbsHogiJAa7jZYG60f7jEI64aPzJlMymiu6nqTVUW6zroLF2ez5qB+xW7OOuPum55uJv0PFM375EPXOVkHkcrxJ0vi2KhVq0Idu+8/eoQQkjTSaukb6nB8B7DDId8rJZrCxc0vjdRqLezub3etIycRYZ2MzkUyHN8DS35GqQDLv6Qgslp/RmZr8bQ8w3ndurP8RwtaSbbGeCVO9k08YdgHB17RNnL4ZNtTkKrNeEkAc3gpWESOL/hUHKBsw4vBv3pn1o7Fnm6ty7Ns6YhXfodVTNgjPZQlRxUInImUGOJDvn5urfSgD2fNQw6JIZ4hQar4sHGoJ4J0bv7/Rw0Zws4TFJp8uYWZfa6+Gubfhi1H0s1TfAgmmo9c3AeLqoR5RDXiRGQH1sA49gUiiBV7IbXZr9yFE3NEP9Kirf/PEcuXi9GoqAjHxwHfCwCDftUzZ8RfkZe01ggfp/c+hJtoE7f/5qQUfQkaR9bDxFfCfx/iCkuXB23PrZNRjMJnXy9W6Ent67Kz0Q6htc8EwlO4wvypuv2UaPEz8FvraPt4Kr3Mjy0Vy9KpVHntomtS1Q0fn9LFinCuX8zRe5gtD0f8tQd6s8mlpCVqlgnmRtww5MX8w/XB4os7ny9bQ3zCdNW6nNV90SpAYt6G4xYIrBp9WDATrpegdSRYCDYnK4BGAw29tvjlcs/zJtEOVs5RNT6rm4h9o2i9HWzR1piYJ6K6LY0Tx
 LLFjPqYC
 Tred0OAKXL+SVuPTDf/D+2kKK23tSiv0liTCiZtj6vs+DG9dcK+4Kw028NEOIlNTWkPBCa5t7fvYT5X7c47/GTiZ3yPBfK+cJlJBcaFbGnpqe7PX2DJ/gp8q48+vt0Lvjwhk924NR68qIW6YuC8WL96swYk2h5QMXeSkuzZAr/HbQXy+/HbWLD6+Iyx6IZNVRQHc31N033/oXz/wwLn0KoetHioMFZdepvMs+B8HGPXDFJjp/2BWeEyQn33lsbl9NTRuRnMGy4nmVfs5d7XAMP8weTMz/JBRS0mbrQTtAJ69MxOTQMm12CW1ouv8Rl9kMYH+3QO3rrwXTkpDqmGCQEk2XtI47bIZxo1148FjH57RoEs8=
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

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 Documentation/filesystems/nfs/exporting.rst |  7 +++++++
 include/linux/exportfs.h                    | 16 +++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/nfs/exporting.rst b/Documentation/filesystems/nfs/exporting.rst
index 0583a0516b1e3a3e6a10af95ff88506cf02f7df4..0c29ee44e3484cef84d2d3d47819acf172d275a3 100644
--- a/Documentation/filesystems/nfs/exporting.rst
+++ b/Documentation/filesystems/nfs/exporting.rst
@@ -244,3 +244,10 @@ following flags are defined:
     nfsd. A case in point is reexport of NFS itself, which can't be done
     safely without coordinating the grace period handling. Other clustered
     and networked filesystems can be problematic here as well.
+
+  EXPORT_OP_STABLE_HANDLES - This filesystem provides filehandles that are
+    stable across the lifetime of a file. This is a hard requirement for export
+    via nfsd. Any filesystem that is eligible to be exported via nfsd must
+    indicate this guarantee by setting this flag. Most disk-based filesystems
+    can do this naturally. Pseudofilesystems that are for local reporting and
+    control (e.g. kernfs, pidfs, nsfs) usually can't support this.
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index f0cf2714ec52dd942b8f1c455a25702bd7e412b3..c4e0f083290e7e341342cf0b45b58fddda3af65e 100644
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
+#define EXPORT_OP_STABLE_HANDLES	BIT(7) /* fhs are stable across reboot */
 	unsigned long	flags;
 };
 

-- 
2.52.0


