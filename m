Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0185D1D484
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222B46B009B; Thu,  8 Jan 2026 12:14:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED406B009D; Thu,  8 Jan 2026 12:14:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED206B009E; Thu,  8 Jan 2026 12:14:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F28666B009B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:14:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A301D1A0245
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:30 +0000 (UTC)
X-FDA: 84309445500.09.E9D7910
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D0CEA40005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d9MmB1m0;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Ans1oOdE3NYLSz974mpEX/DcKF2I12Io514v9DbvaY=;
	b=AmSD8Prr+Qd77QF5bLEAE9iwsKwBMXGm/WLzjEChq/xWUc65OBumHGmzLSwczzM92Fcqyy
	NPa6dpC5LG67OHN9t5nqnBUnPRVIyVpLD3EMNtzlxBFYxydXilrN+895OoAa8Ta9TXQlf5
	eYPD0+70fjffvEVgJ58M0TqUe3IBUe8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d9MmB1m0;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892469; a=rsa-sha256;
	cv=none;
	b=AHCLMHKvmUpRvTv6UJWtm5FImlA1ezqln4zno/n56pt3Egvqxn7/B926/tbv7yEgOxkFrI
	2/7sB3iTBBKO/m96TR6S/s5RAlC+i9Vu8CgHPYMqqZy+mkaclRF3Z38g0KGUmt2GbX2h45
	lLMx8cCn3cZF4lTgX0iPIvkz6dlBdgw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EEBB444451;
	Thu,  8 Jan 2026 17:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7486EC19422;
	Thu,  8 Jan 2026 17:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892467;
	bh=hlxGHkYb3xkFH9tUolL/syLb6jWJ/uBVgo3tjpiBxyY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=d9MmB1m04Yq51+yvLj5Igg5jvjt2pHNxTK/fBefOXh8TeU4uLphzQaxU6IN9Pl04A
	 tBoV9hqBlk7GrHjFDyAHkh6LbqS7sqpCYUy/uoeiRJFegNbaFGoIR6bSSAPvq95x5b
	 3b0SAShJkVnakBG128c5vI/jQfrSS/P2TDGfDgGUgi59ILalooVkG0diDEYBmCbaSk
	 iqhZQYGDY3tXw2lXE6dkvpWeMQR+GcH0PTKSfpBqJDNYo/o+MTaFT+NUjuvjcrOq3e
	 msPZWt4sPG8TodhD1Ox97c2Oy73trggOtjHggajWT0gizYqDghDAFLpOjOEnQ7tPwQ
	 GG2zYe58TRBpw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:01 -0500
Subject: [PATCH 06/24] ext4: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-6-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1728; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=hlxGHkYb3xkFH9tUolL/syLb6jWJ/uBVgo3tjpiBxyY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W6t0mhuGkERJYbFwmyCbgn+H1ouSbEbBOhS
 BmnbuhF9HOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/lugAKCRAADmhBGVaC
 FUEED/9lGYU2hYsgRrdekmYbHARu7YG2VzVJ9YJTF7i9daxcdOeAV+CM9pvICZhlQXj7ksl2zyk
 +MlC/fF9o43MeuUs82UhWCwUlrjoQWEHCxkZi/kEGCtyrXZStdPHmGPs/jBMBERxfYcccrVRote
 Af82hjhi7S8o/SeYi72kfMiuEbK+TrD5GIbE/l8Pg07AYvM82MejivNSUusmV3nW9TgqpebQOU8
 igqsQPEsODeiWZHFiXaR5yJjNhDdogUGW+iBWXFcfC9EZTc3nSGO83mSmVqTcFNnMJ3ojOQaOa4
 JuNqiG7LDyYmfHkVs8jgVxjYG/PUKziFr6CYquQnsGZi5E39ZVl8HX4iSqKoPh6FjDpc1PDG8yr
 QYPwrdKSZBX5fr5wwy7yrWcwlZeMlCXzoid+Fop70v07YQPWJ5OmwUD7N9Bg0dxArH+srCGIgTR
 p3f2C5FWpQ05m0xTZ7E7oc6KD34XFgwXIJLCPTEwp3nfRY3+IYLQcH4qfJuCCQSB0waZJ/jDV88
 30C0Sp5Ujwb281ckPPKOaDzTtEThYd9Z6U5y6u/ov+PhxJrsPh9JtyAW4Mq+D1+Ds+b5ysfCvDu
 fGntd6Oj1rEilxy6v1snzESsLykyBBKAn/sMaXn4sW1rixrdAHhQ+hW+SLj+O2Z3iVmdb1IRscZ
 CKvOoSCXs9sf55Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0CEA40005
X-Stat-Signature: 9m5jwsbppzmaaoa3sbdgh6zy1akz17bg
X-HE-Tag: 1767892468-429466
X-HE-Meta: U2FsdGVkX195c97JcZz2QSTSIpzoY3Lea3Iuyjb6VDcVBRPFUwRn0HNMNhJ+cc3f2SgF9RQFZOodczYJeY0ovV59jrFTcUHND9mba7JF4iYQzLnLrqUUA1FoAI6ojDqAq6UIWKfG3LW3et/3/COyi8MDuePLcTrTPv2qm4G1WJa7QxOJ1LAVPHUlnVzgkfcc2sZ8J/4DCHqh7nuhv1TJX0jq62i+rXeITjbKrVhPk7c+i24YC8K58OvI/LjaxjAFGGl19AtzCUKAHRSf97G+kWwTMxijsFgGlShLqhZqJhKtPAjw6MrbF93cIWlLJr1VUnotUA2VQ5U83dlwajjOiIB18WIy2UwTRkMyyc8F+P07sZSUBSyxDFtlSVVyXJYX4UsN3fkBsMIZRNWYg0GVuK72Q2CCN4YSe7Hp86DQJ/igDVwf4dPBvOIIlxQevftYJzPIfcR76bytnz9kPWBvSfG1FynveIrECLwZP2+CyJ17s1GPiR+7nUIlU09JGzAq+DMtHcTHr1Vg6gZb9+948UvnkVxO4uYuZl9Z6nqxY3MZbE9iSc9Q7d1jcTESrzfvgEBMlFcJHOysiOLmmGrI3j+TCDBsy4WXqfuwtjkwd84S/HEbVNevyr0eyaDO0YVbHCEImCbMVns1uesc6b9EF5FEcZuceQo2E0CoJPT2zP+VK7E3BMV6PLw0V5C4vgY37oGDUyhCXk/dlnb40jLr+2eq+PyCzdI0pOVUMt668c9JOXzwL3YFpsUfXmgu6bv8snTaXRiGlDjCHdltHtYNZZTJA7Kh+Y1+TMOoIWQE5Q5wL3rMRWKudRfirBzhOQw6EaUAnBSo/tEmaNj86uxeaGyazKY5ZKifo8DdNLoZ9t4wJM1y4+89nQU40/VxpZuSixrOdv0PYXyV2qodm+pwQmBiOJ+gDQ5SuN6p2ZebXoSxOhFob7kwCJu2XGU4Tg56eEs1Ux5KGPV87l/7PVm
 R8p9IjTU
 UWjGn7h1vI5e2l351uUIJyt63DDlTmES81Wx5CeB9TNg6QHvTtOVNQgBjAOiXzUjPOXsfnio6l5agZ8ACtwusnSM7rm4AzSi98KsKezKKMJq8O5ODsRXIqGd9qfhXl1BlxWzknRWnGdvJn0eaSKvWEzyDMIUBqH/J0pwBkswhiM3+RLDIGXEWVy51r6NAEl9D6F9UDwjkyX4Heu34teAKX1tcYiQC14lzeR2fVtcrVekSAu03Mz4GXa1XzOvGkLdSm1PCUHlYM2NYtqlI2Cnk8z8WsVELvz5kk3LqarjVEN51bdnTPC5k4pZTo+tStx/z95mGZpq6DD94FPg7vqS9EN9+0/vZDaUF7vGT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation to ext4_file_operations and
ext4_dir_operations, pointing to generic_setlease.  A future patch will
change the default behavior to reject lease attempts with -EINVAL when
there is no setlease file operation defined. Add generic_setlease to
retain the ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ext4/dir.c  | 2 ++
 fs/ext4/file.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 256fe2c1d4c1619eb2cd915d8b6b05bce72656e7..00c4b3c82b6534790962dc3964c0c557162b6dff 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -24,6 +24,7 @@
 
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/filelock.h>
 #include <linux/slab.h>
 #include <linux/iversion.h>
 #include <linux/unicode.h>
@@ -690,4 +691,5 @@ const struct file_operations ext4_dir_operations = {
 #endif
 	.fsync		= ext4_sync_file,
 	.release	= ext4_release_dir,
+	.setlease	= generic_setlease,
 };
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 7a8b3093218921f26a7f8962f94739ba49431230..534cf864101f8d1e5f4106b61c0580c858bc0e27 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -25,6 +25,7 @@
 #include <linux/mount.h>
 #include <linux/path.h>
 #include <linux/dax.h>
+#include <linux/filelock.h>
 #include <linux/quotaops.h>
 #include <linux/pagevec.h>
 #include <linux/uio.h>
@@ -980,6 +981,7 @@ const struct file_operations ext4_file_operations = {
 	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
 			  FOP_DIO_PARALLEL_WRITE |
 			  FOP_DONTCACHE,
+	.setlease	= generic_setlease,
 };
 
 const struct inode_operations ext4_file_inode_operations = {

-- 
2.52.0


