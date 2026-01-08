Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED5AD1D484
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD126B00BD; Thu,  8 Jan 2026 12:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DD16B00BF; Thu,  8 Jan 2026 12:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986126B00C0; Thu,  8 Jan 2026 12:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8463C6B00BD
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:16:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52BD2899FA
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:16:17 +0000 (UTC)
X-FDA: 84309449994.02.97D6F2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 65F8F4000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:16:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QT6pxXNq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767892575; a=rsa-sha256;
	cv=none;
	b=hWcKEvFbLApeOdUqY07W+n6Ttwa5kFFSp5wcfUY1AA8q87cThb4dZk/30xn31XRLdmFW2J
	V6RkfGZwKSH485YzgrytY7fBHx7Shpn4ZOWU62pJ4dMD285u3tLbDa8aIgK8NTInGGaHDw
	69lldrLLbC9k/tQvhgw2VrbzUp1uwgo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QT6pxXNq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPTqT+oy1OMUOp+so+dZ3cv0gcF4bJuJHtVTEd1VUlQ=;
	b=HRV8QAnwmYY1X46KKX+pg5b/ULXsrLVc7Znn3Ig5/ggJUrCmBp8l7bsdLOxqPjN4/Q77ct
	c37BrKN5lktNZ5qranFSEi+G80wf9giXRadjRRRvg2rBmPGdt6ZhQOsGZY0adEKgJentU7
	aVaqabQfJyP5ChLbLbEN9HD7wgX2zn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BBB242A52;
	Thu,  8 Jan 2026 17:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AC8C116C6;
	Thu,  8 Jan 2026 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767892574;
	bh=Y8yfU7wo+bv5PqTWloVhm87suTQkWJClSnAp6Ng9lro=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QT6pxXNqWvJHyOYg3hWSLfGXpNN0ZmYoWCbIqcBphUyd5e/CKnj3QxGONTxUKwuLh
	 P3M2Uh4IZvhWRfKOoTxPrLO4Qx7aS6dq4lupB62wDtNubrlN+ZO/AM2anEhhuC/LiA
	 S4YtlhE8SwXKIBaCk5YKr35l7JVcPVqP3SnK55MIMbgE3snGMQiHN9IHE/qEQW2mo0
	 drWHgjds0lmogHJW2CzrSvDkWeDElNISjTrsR8B8Kf0Pdy91ehwsPMVflis8LB0Asy
	 mAfM3J8hVwvaGyuDduGwmO4K3TZqj900lAYy0IXWDvxWjCK1SPgzZfeTGmlxdw5SG0
	 XpmYYxN4lDfmg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 08 Jan 2026 12:13:15 -0500
Subject: [PATCH 20/24] udf: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260108-setlease-6-20-v1-20-ea4dec9b67fa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1745; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Y8yfU7wo+bv5PqTWloVhm87suTQkWJClSnAp6Ng9lro=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpX+W9JGoO8MdfrKDSQqEUZX9WyGOSmm4CgIgoa
 LF6x3PhMYKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaV/lvQAKCRAADmhBGVaC
 FT13D/9bGlCwWclg64l01L8s9AmtXvKCjKI2CNeCYh93PBL/4q2X15I6MepVsfrIiXAm1UZ7A+Q
 ourJq67Bakw7EJg/rFsi/5kCxPyQKJOPOEEkKT+5/Zh6R6BovLHz260Zxx4RIKCmnbb/4QSnkyH
 DuY4cIYZFF0M0RhUl9dSXFAl+ho1SBw08F4biLMI+9+yzoZJpf/umpEmSB2ZAKmjd6ayRPatsYz
 SBhFcri2L1TiccU5x1ATzJEUt8nyChJwODOsanWhj2wPmJUvHXqtLhH7TVCJL236zsy8LaFGjXQ
 VzUYt8iKaOR26/G4RAe8R8p1pOz8dN1zEgXv7GkPvxUyYxr1Rn6ER2LQ1LBS4M5SpYVOxxaYuVn
 kyb5VwVhTjjUVZHky+DmcXjzlcoAlGe3R85uJRRydiODVKOFwF0YCgJuWEgbVSc7bSa15xs0aht
 nTeuIOx86PQRWEDbW2u++Rx/wMRnfD8C1cR5ZgM/8vxwy5KnxSLU5UAXS0fLKhLeH6yEmWpSnCJ
 a2skVhzmf7KpcBfWbnnmPHq6nbBD2e/zWKp/6izVesZKMIoekFls1uNZ90RG1IevBfpyphcGstW
 UC/BOdxVN+ppwk4nv6DVG/ew8zcCZXdJCt1onUubHPB1L3r+xoX9WJNHsN7LsR7wdkIB5a/o5xr
 uloIyHIPHURUlkQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 65F8F4000E
X-Rspamd-Server: rspam06
X-Stat-Signature: iiydhojtg71yck4e6er77hmpkw7gqkpc
X-Rspam-User: 
X-HE-Tag: 1767892575-687387
X-HE-Meta: U2FsdGVkX181g2vHwVfSSYySu1QkNDOpcPhCy1lqQ941jSyAAkTuGuH6a2VmV4OIxzZU6M9rLiyyLCtF507lR4ZS4a5eNGubfkHo5hWoJX3BR6QmTlSDRd2ZoQsXd42UL6sArbZybY82ZNhUN0J5XYSdbbawXMry1f395Dx2Nl0GNtD7H939OtNMRuzlePi4ZZyabmy+uxkdjKmzTh3boRr7FaJK1QU11gDfhcgzuRS2UzjnGkJcNkk2mZmarLxUS+RokdCH32/BWBggu/cYe9zeAvg6219Rk2BKxekp7lLia633CQVfm13kd564GbAT+V+wmJjJTRCTdz2OA4VLBZi+w+B8BbYs6u5onHZ35ox0rxTx9qeGjTgz1YHDF+IUAnPtVv3EuDxh4r6PHvvoNUowP18X1U9DcLmq3o/Upgq7WFbh3PJ8T6XrlNQnm8ZcFBnL5TPl6Rz4rlwsvWes+p4bCXJnJ66n1QHKJnREufs6nN8MT4M0irElSIK4ethO16w8Jpyp4xa1Zq5XHUGGcr1a1gqSA5QA6R2On8n4MKOnLBSexcYUTqbbQYacoflmM1uaqbSmm3HlCXf4IL8h1WNf6zoFdac2UyHJoa3EHredea8LuL96ZmpXtynsYnMizH1t8or12yxPMqyOULXKqBU64Sgfy7pyeO/bwDBo9VLL5yiLPGp17KWNvT2ngeGLPyZBIvLFOgp+8RVWYyPRxdgKNbij3utapqB7b6wHRsjdyXGxNMkmUSgbrAExwVRD6zo00UdQvlrwJt4A3rScNDrEnidhJ9g6LnWgVrwOG5d6N37SUFVHYmULanKESyndhNTM4ZLXSHIYtQsM1phpbl2duK/nGlZ+O4j8vZU4VFpyA+B8bllA2SW6UbZ8yEG88CWMJO4R6FJTrezBJhCYz3pyUqLj48BUrnla3tzp3UPnOJhNaz1etVXKfGoQP+fX2e7BOApIHe9Jqeq2n3+
 O5O4bLQZ
 MW8yfTOuFpN1w3iIM0kcOC77Gn3z35NTzsN0haFuTF5znIqADQuoZyl1GNCODdsOOdi0Rgj0VA3fFP/FLaiJ4OAYG1f3dWSZHDeSR2j+/FQTbmM9xIk+bE6sVU0I1HvlfYdAe0oERrYHv2zVXouUyVFcBU2p5d+MmfYvjcCukFE4pCYmaICNzTW+KcAo4iFuaZMpIPFKAZNRCgG2I2i6UbTsVfxr/IjHyfzjIRRaNxrGBhG7vm4tnnpyr+IMG7GdkIJljhZQBwLBbkKdhruZ9CfoQxR1YeGLyC91B0OOeOfCylP53KXcrgNXRRqkuRwRr4Nq9/RPtnDnOZtH+cOrUsJU/O0hNx+DPm7PaBntABk2mIT0GzHjoyAznRnVlYEFwtZTR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the setlease file_operation pointing to generic_setlease to the udf
file_operations structures. A future patch will change the default
behavior to reject lease attempts with -EINVAL when there is no
setlease file operation defined. Add generic_setlease to retain the
ability to set leases on this filesystem.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/udf/dir.c  | 2 ++
 fs/udf/file.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 5023dfe191e8088b78396997a8915bf383f7a2d2..5bf75638f3520ecb3a0a2ade2279ab56787ecd11 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -24,6 +24,7 @@
 
 #include <linux/string.h>
 #include <linux/errno.h>
+#include <linux/filelock.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/bio.h>
@@ -157,4 +158,5 @@ const struct file_operations udf_dir_operations = {
 	.iterate_shared		= udf_readdir,
 	.unlocked_ioctl		= udf_ioctl,
 	.fsync			= generic_file_fsync,
+	.setlease		= generic_setlease,
 };
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 0d76c4f37b3e71ffe6a883a8d97a6c3038d2a01d..32ae7cfd72c549958b70824b449cf146f6750f44 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -28,6 +28,7 @@
 #include <linux/string.h> /* memset */
 #include <linux/capability.h>
 #include <linux/errno.h>
+#include <linux/filelock.h>
 #include <linux/pagemap.h>
 #include <linux/uio.h>
 
@@ -208,6 +209,7 @@ const struct file_operations udf_file_operations = {
 	.splice_read		= filemap_splice_read,
 	.splice_write		= iter_file_splice_write,
 	.llseek			= generic_file_llseek,
+	.setlease		= generic_setlease,
 };
 
 static int udf_setattr(struct mnt_idmap *idmap, struct dentry *dentry,

-- 
2.52.0


