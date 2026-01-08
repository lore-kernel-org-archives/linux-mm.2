Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9D6D1D483
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387796B00A3; Thu,  8 Jan 2026 12:14:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350D86B00A5; Thu,  8 Jan 2026 12:14:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1AF6B00A6; Thu,  8 Jan 2026 12:14:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7E96B00A3
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:14:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A96045750B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:45 +0000 (UTC)
X-FDA: 84309446130.17.25EDA1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D11D414000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UYNgBgcZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892483; a=rsa-sha256;
	cv=none;
	b=taZxxyZdOxR9QoEB4UQVq0MpKG1Y98N2oSqAFyy9aE7yBYssaByUf2z698Y5Dl4gLg+Y+D
	+X8+e6pOFl7Veiezsz35fN2xPno7mGxAH59FDpsiUvWCxf1te59kQYRVpydO1UmJ7b5eBI
	T697YCwZN0tAfhuoMJepGAWW98Jbo7Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UYNgBgcZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3U3DfC95ROrQkINJU85Gnclf3BoC6EeZB3d0ZTTyF4=;
	b=7ZpdESvAnQZpq5xyQGwjRGwpvgnfqFw3zZqvG+CfZppG+7l1rfQrO50J6xdb4QXcY8Pt7T
	ld5NZsdkxEm+H2sn8+Op5kuiSYhlASs9wlzuCvZl4WGjPghTXaZRaID4u3IZnx0z0twpgW
	ARLfFyr90Q4uIja8ACtkx2dNV0b2/Kw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A8BB60148;
	Thu,  8 Jan 2026 17:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92A5C19422;
	Thu,  8 Jan 2026 17:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892483;
	bh=94xq5tNwwGdVFEbsY7qMy4HxVAW7YcdB4S8NrCMz7tI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UYNgBgcZejmmXe9+DGorQt4RzpRE+LAfkhZHZp2epE14mjVE0kdPbmDA9FBeWHjMv
	 u9grV7ZUhfGqgp292cdxMQ4ebVh+7j4zYMeVX1AUvqsmp+m4hG8sTJKXY2bL0uXnmL
	 OIxyKXSpQg2ocYvNdp4AE5BMRYSlBgMdQrdbza/DISv7Cy76VCfxYvp5i3I5TcTajk
	 YJOEyp1ppteph8H2ZBkKGtwhMld0tUqpbaGdbkBKjsRPR4g/kFdS9O8y8483fi2fAe
	 qoPICRyBKGoVVHyK9qAZiaZUwXNNW3OJnBSiavsAbReAdv/Zgh89GbNfcesC6s4T0d
	 QFBYXqYE9Z5vA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:03 -0500
Subject: [PATCH 08/24] f2fs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-8-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1702; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=94xq5tNwwGdVFEbsY7qMy4HxVAW7YcdB4S8NrCMz7tI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W61b/MyUzbdcdSmodRmXRKd3YgHTA99dyp1
 aKrHFL8B/qJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/lugAKCRAADmhBGVaC
 FZP9EAC/KfvgDBVB+iOugVAOgIuiH2lLp5UGHRZYXoccQ7RsLXt40LrXwHbIuUnBnPTDl6Q24dk
 c+qR4vCzUsvTs6ZoB/hQgF5t7enFKO97X64gMM1cI/L5SVv9wJHkr+SlWYrN0ZRkMYbYkqh6Qvn
 YdDpzNnL+2CHJm6WeWY9m3G6MP5VpD6AFQcWS32/nlYcAiAeE8U5UDm6yRPub2BRgLrQMMLwo0F
 gT5ML+oeaRwNhBAtuUc2ywXWSazgnDwe9Nl4vdX9hsgfjqEd5ByGvhbHi5apdnDTqT/qbVjXKig
 +iWXByE7jJlTpLGiOJFwwFEPTEukug/2WKCgwXoSbYea46YVqKLq9pUVapamKmSCjXPDr9DWfYQ
 r8y4tje1jnoLB4Fp8cn9lRtS3Y4EXDQRY0n7L7VKSOtOvyFI4VGIHpsTF+SCJY+VcgswGTMeqVU
 kDjGI23wvqX81gZd7GFSgWewsEYkwNit/sgV7LOVnfE4EUSCygGym8eAfR0jWZ24zMWCeUcEGZn
 03QVAgVIEkYdmz52qL0NWwbiUb8fhK7fLvEUD/dMUt6q1Ot/7vl/H8/z/LaCO2baW1UpCuaPnIY
 maDRAn3wF963W2+JRVkZWEzuiaXz7m2dr0S/XOxltRGXHKRIM0xY+sla9/h8+M3PIOmfyRFvtqt
 V+typZtw20n9PeA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: i6cefegz4e1ngjoufoyo39i8c45dk6ro
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D11D414000E
X-HE-Tag: 1767892483-2637
X-HE-Meta: U2FsdGVkX1/NV4yvi8O2ALM+yc3R8ySZPkiKPS6KL/D7Af8ccIW/vVQwFzENHR/cpUZIBpXJyGMHhv/cV0t888l7c3hmRaWLiFa3u+GG47wmMlp5jy/k0pwtaKZTtQaGAyfC5KEGqbdk+WlSqizPEVbXqj3ZZhxrMU6j1wxOP30YsF0Qk/HX3uHY1n+LfAl7NrqUkxbMlcuMp1w9kLS2ijDVsAERwLw13ycgATOt0DxzpUkaq4xCVeP/6I48mUEbajF8P3m3w8wxp6vm4HrlhKu9AhjPMZ2s4wmdIEb9HSmIZQe6pYcjwrKYX5RhfeDZHO+L0DRy/4iqlDY/z6Q35ForQadpWGledNqikzuwDiqab4HS+rci3tYAfNjTy5MtJQAr/sTLn2TynJC3Df7SOpbdKV00q06e5SBSLnNY861ynodWIymu/+4/ekwFYP29UBwZSOhAgvgjeY+e3puevpbyiMVgXXBSFzEIJ1gqlWoQnDitoIGoVFRGKicrFuHUP8I2q5DvK0q/aZHnLiGDcX3OPrIMu5lVxk7c2ffrGlU5X2OqOYkrIsngMMBKiblS0I90ewiykbq36HfhNuPT//AOpLN/BPo0Hcc+9x/VWK7IgE0pg+gKZInu1SqDOFw3KOLTcB619DCVHUxfFk1BaysZXPW2tpFJYjMg3SLh50NUZbIdaWiXlxNFD2Eg5EKJ4ZXKvtMTbJLxHtMY8a2vo0Ou3TjmUv2p0/6LP2dDwob+8nh+Bn2thl7obSotoE95lzjfO6tJa26DCAK9ThuENHKyC+DaFMUHEkuBzAFm3aqpwqi1z4xWTEIVQEA+BfK/4XiJqw+ueMOFNS9kdj9a9DqRDj1u8kugBZuRwgLyhiQ/mkVZznILnSqV4EOO3eoms9/aapTNal2KwkNtR8l8z2owTp5nAVVzMRymcNHzz6sK2d3i2pshpMEeBdfE0pUYHEC1c0Oh1tJnLvfKFag
 E28o+0Co
 V1/M6CANRj5/fraMtCkqpGjGldZoOjzVmASSBntFwbT3Iq5ZBQkuYb4+p1GxFaTHB5xpipMCfULlJEvy4HEBDKs8qWO2af/6/6nOwdOWvhNA7Tst6X+Aq8jz9313Hf2NREJwPffrYcNHtNGMgMz3HVar7YVJInNXDEuXDNV2QDrqGlDFGRgnmk/oMlf7EcdE3917LpQrgfHOWWTs5PyGvcCplF0k9VGvTAFnxBaVOz9DKVWvJeHtaYFL6eg8bh9YhaYiSkWrX7kDsoManjPWLRvWk02Ev7Bw7pt+2drKK1XMVqNvfY6uFu58AbTrUwlaKXMXRthTxAQ3ok4VaM6nPebTueKBfAm5gVptG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to f2fs_file_operations and
f2fs_dir_operations, pointing to generic_setlease.  A future patch will
change the default behavior to reject lease attempts with -EINVAL when
there is no setlease file operation defined. Add generic_setlease to
retain the ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/f2fs/dir.c  | 2 ++
 fs/f2fs/file.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 48f4f98afb0138aefabaa10608961812165e2312..be70dfb3b15203d6d92c80b4bb64fec879864988 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -8,6 +8,7 @@
 #include <linux/unaligned.h>
 #include <linux/fs.h>
 #include <linux/f2fs_fs.h>
+#include <linux/filelock.h>
 #include <linux/sched/signal.h>
 #include <linux/unicode.h>
 #include "f2fs.h"
@@ -1136,4 +1137,5 @@ const struct file_operations f2fs_dir_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = f2fs_compat_ioctl,
 #endif
+	.setlease	= generic_setlease,
 };
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d7047ca6b98d8a41d69ea79bcbab3e4ae4cf30b6..cd4b1d3c90ab8114533d939e8dc129cbefc85c15 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -11,6 +11,7 @@
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/falloc.h>
+#include <linux/filelock.h>
 #include <linux/types.h>
 #include <linux/compat.h>
 #include <linux/uaccess.h>
@@ -5457,4 +5458,5 @@ const struct file_operations f2fs_file_operations = {
 	.splice_write	= iter_file_splice_write,
 	.fadvise	= f2fs_file_fadvise,
 	.fop_flags	= FOP_BUFFER_RASYNC,
+	.setlease	= generic_setlease,
 };

-- 
2.52.0


