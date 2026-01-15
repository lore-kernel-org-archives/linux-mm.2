Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF52D46609
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233DC6B00A1; Thu, 15 Jan 2026 12:48:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F46F6B00A3; Thu, 15 Jan 2026 12:48:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10AE86B00A4; Thu, 15 Jan 2026 12:48:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F360A6B00A1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:48:44 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDC72B9707
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:44 +0000 (UTC)
X-FDA: 84334933368.27.896E7D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3D87C40010
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P9k1aj11;
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499323; a=rsa-sha256;
	cv=none;
	b=VcYjZpMKiSzuWbnkKfH9xY0wiL3y8nv5xORN4obpisSYr+YpylE5yitXOiC1ltsnerTGLV
	CVDvj19Gf02WkaB1ilHdYla0l8aXYuLvknS0qhUOhTLzK4+iVjqbW5tPbB2C8yeSnWHeSw
	mXQD9UfZClpLIcZ/Ym6sfVM/Yn4sRC0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P9k1aj11;
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XS0lvYRK5tWOgGjuWzlfHcgoUbS7YsM+rIkpLdRDJDw=;
	b=QuNkMhK0AOy57SR14JVLuaWyhNlXhkeVwBaaUSvbcxNUsTNz0P5HWqgMluTlwBLnIbo8+J
	MyjWNi8LM0YL/A1qxAUMTQ8iv7VFARBufzFhl5WH50XjSxgL5yGXTffCLL634KN8CKXder
	4/lViKdO60MsJiBotO63ukphZUznIg4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43267601B9;
	Thu, 15 Jan 2026 17:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E96BC19422;
	Thu, 15 Jan 2026 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499322;
	bh=W9kQ6JHsR2ZsjaldNXy1YA0G8roGFhpDKq8DlYvicUo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P9k1aj11dtUjVmoJ2JkOIxQxD+Lh9HX+4PP4xeaiCmzMsGQQIofAxmN0kwephynVn
	 jgEFAZdP9VCeEM4+lyDrU9hFKtyTvDnuJcMFOj2OBrjJbruUs2gTh4OplQXmRdPFWM
	 y/WtmfJtSDHkl17CbGZ6JPMJHqPthmUnl/csIzRttoW2UlHIntHlS1E5Rnde4PXZqW
	 PgDdvnrYn47ZyQuoFtbs1ukRa24C8rf+drsvuUM7wKZ4EE6Lql+TCbjhRaZL9EX7ud
	 GXY8NtwMda8Oq/h6MItTeABo+X1ixha9jgKSR1HNVdiLAS/2m+SbKJ2jDIsEAaqNWt
	 Ipbx5URfWOUeQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:37 -0500
Subject: [PATCH 06/29] efs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-6-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=711; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=W9kQ6JHsR2ZsjaldNXy1YA0G8roGFhpDKq8DlYvicUo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShFOGCeudhFSnNU5LrX3LBX+RZplJUZv4gNk
 R+Gwt3h8dOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRQAKCRAADmhBGVaC
 Fb1uEACvyte6Uvy9mHwX87tjuyi4RsPEm4K1/E8jJNDj5Zi+574qjjwkKsFEVJY/H6jxPn1y4xn
 PbLLYqQrd9EtydaJ4vWQ9843FC3nqO7/SX3eALSNaseH1ryUYgOoGO627HNQRsanv3azVVKGDLa
 G93+OiYF0xM7Sn6aZGD7VGWl6h7R8eaLbMilwCopjF1rdy6+BgSG+X9Anf9cmZnxFNQ+1WbuCy7
 ue7/yrUYG7h1Th9lsN8hPXpJ80IZOZt8yyTtBH4ZTQb+PDWjJV240MAJMixKUhwPLV0rEJh0p3e
 YoUJl40N+SqwcG2HSUH8e5D/DqhXB1mBTLPM+KagG4DHcJZbIfN+MgTT6mk2EgkjMo3zfEvhxj4
 Ic2nlaRs/8vPSb3e+LFh+7m69YyNHMI8cBl+6oqSgvDdeuPHSkVEIqj8qPaYFUQFpbaqzyHwBkh
 GqW1XkAYc6fjjh9BVHmdlfk93kjoGn5Ar2sORFoPWSSO43FP2PVCrZ1R+P81bF8EFaYGMF0+X6I
 azx+Nmx6fMSuwp8IMzaMUoms0XpTf6LnULVjgzmwTbU0FExZk7LbX2n15X1OywAi3CRU1eItkjw
 So8HzuzU+Sio8FHHPHu6CBquAWoySow7mPaViwxkdytHNY8n5Zh1Nw9WTZ6j5I2MkNaAVWRSG3N
 pjvjCBbT7TxDhGg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: g1jtujqauy15kskc1e6r83g4bqjt5eg3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D87C40010
X-Rspam-User: 
X-HE-Tag: 1768499323-886138
X-HE-Meta: U2FsdGVkX1+aizyFZOIViXpattZC8Vc+7zz7HDDat4nSG/ro/LlwMWK3FBACgrBEYqbXGS8zl4SDAcckdDUMGVoFqhzl4uEQCE8FGUizp434/Bh8HHfokRWcCz4z5TCNtcGwg/zHwwXw8cx8/siyS7dePAjCgsWFnXRJXhhDmGfeC9clW+vXjpJb0tW7SAsjSd+0Yxi8oWbQNRP/UBW2XWJLqOUdBBovCjfVwf1F2f/I2nIqlWlL33r08y494CuSoFcFEITc6azk7En1bjjuyTVQbR2n/kZRIQnkJspbTaSF2nKZv++xj4QOfcuJkc0QhMdgI9zCl13EXsg9VVOGkH5vk4Rd0SfdP5Xqg71fMfiPg10MIaff5iw1JjWuGfktOVBpRLOhBS9I6gihElGDFclHmP5eXGg544tpo1n2z9Ppogw+h5OWvSPl9K+EIv9JgFvhpnX2clQM+nTZY2LC1cvxeicP7zl6DhIpX94etDB3nyJ+HDBvy2q1UWSmsrr90fZb8V/nYXGee+BNKyHKzJLkJZpaDD0XpsqebrBu/iWjmLx1+z0u6+G51CtU3tgbfUYez/wntzXEL6p1pVvcGhAu3oa9PBzMatdLDoa7EtqrGZl2fGImgC0zVTQsw8I/xR2wvUpNTE8sYHbPuWGi4SBTmclb9lDMLirVzIBBCBZA+yIyHQ4j2DZgzJpAp6qq2SJ8/0VytP+Nw1ZoSJ4G7z2YyGXiSIMeF8kaJuOjkLLOrzfMHJ3I6DKuyUY0epE11RR7Qyde5b/Chk48V0aRP5q/jZPIfWwFb8LpKrJTwTwMLuTFvXOz5Hp98H9RSWFwGufEstKntkHT8PgLzrC6JLeACWqrv8lUJWM6BVN38UDLcfJu0iybS9Jv8cV+TVHvHrTX1bxuyuYdeXG3J310J8GPIs/2JwJX2YrOF7LXViINywfMIX/pcYkoOjqDgVaknyAfSCfcR2fBu7SavP5
 l5BoQ10K
 qsliVcoQkkZOoFaasJrs2x+o5YvD5dPFhPLff
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to efs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/efs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/efs/super.c b/fs/efs/super.c
index c59086b7eabfe93939d06f36826aa91838e41ba2..5e06acdab03b6f30bfa469e48463cb0e8a3b32a1 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -115,6 +115,7 @@ static const struct export_operations efs_export_ops = {
 	.fh_to_dentry	= efs_fh_to_dentry,
 	.fh_to_parent	= efs_fh_to_parent,
 	.get_parent	= efs_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 static int __init init_efs_fs(void) {

-- 
2.52.0


