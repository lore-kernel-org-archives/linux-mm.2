Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F16D46608
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703C46B00AB; Thu, 15 Jan 2026 12:49:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5506B00AD; Thu, 15 Jan 2026 12:49:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7196B00AE; Thu, 15 Jan 2026 12:49:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BCD06B00AB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:49:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18F8716044F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:18 +0000 (UTC)
X-FDA: 84334934796.23.DB31AB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3A6D01A0004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mDsmjGIn;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIUiCiYvj4+PQCXeGc2dRPv9jWC04oKwYnr+8nkAWKs=;
	b=OjQscuKAfRp4pwuZGyKXdbQAo7hr7Ury8g1PxrGZtz3zflzDvK7Dg69EGyr7dILoy085hC
	74Lf6vo/43/l16NRlz2I3xsVpPGYMiiHeBs5I2HiDtjHjzEzcN1oeI5TbZSvOZXxBkhYPM
	tVDSotpJ4hb3H/fy+2UeBYuvfZb4Tgo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499356; a=rsa-sha256;
	cv=none;
	b=CJEYFkvejd3oia3pPMLoLn5txN87v2edUQDqrF4mQiYDyE4JNOuPOFXEK9kquiRIRLANoo
	Hy9jvTMxBW42+ZRAMnXtvHA5qRpxhhesHuDtxojzKG64rVIVJuQcwvg+k/yAyHqkCYcE1j
	bfVdfP4QnmjznHFoS3azvgvzEmpCwog=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mDsmjGIn;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50A474446A;
	Thu, 15 Jan 2026 17:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9B9C19423;
	Thu, 15 Jan 2026 17:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499355;
	bh=ttUZbbEr4qNvBmzcmWXht/0+Ro1g2UQElLV80PGUEuE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mDsmjGInXlxUuWrIRrwv5qZQIPlIgwVPfetY5f6z1Occkjrpc3fmt3P3+9xz/ygv5
	 2VfiWGSAHJiML0wE2XpjwiAoZh5JRHcQkW9nveDZvznbd9EFKdttqjkG9YMgGwPrq+
	 PoPKFWCJaCUDUeAtEPELAfNcvWqDJpXekdN0m6t1B1tBOmUbf1l2FPA/pGsDT1qacq
	 TCYMr2c/174ubIgDQ6lN2+7dAM2cYmP/VVGNWJgmk+LQIlVDOPnvmigPMbnwRm6bYj
	 A2aIx6YB7e4mVQjVXaE6WhGbiAOAqKdDIvpfXGwCIV/XYpJIWDH3uy9nHt0CQqDuqa
	 0XnNid1EB16xw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:42 -0500
Subject: [PATCH 11/29] ufs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-11-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=697; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=ttUZbbEr4qNvBmzcmWXht/0+Ro1g2UQElLV80PGUEuE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShGDwr1sR2otFzq83UWoMQWbDlnYFlhI0cDH
 jWAJRbmq5WJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRgAKCRAADmhBGVaC
 FZ1ED/46txz5ghIDvc3tR9xaLWo0GlwjYOwsC8m/aAkCADdaEu7da6Oy3D1vM6G2uDHmyabUcOx
 Tdu6BBafUm6ZljC9Exy+OuCvzYJQD9vaiTjprh9kniOU/PxPWTvaUt2VCuNf9SErwzt5728aucJ
 GSNLbDfJN4CbSWtP2bkREs2OrMDgS5Vqho86OgC4Zihzy3QZxeFVBcaAWsruB3qVXWCQHHLj/92
 gS2skgvBG2CxpzZhOyDEJk8jDS5niq4sQ3yIKjxNMlU9c6WqhOw9ZpxVa+gPvx+QVKtlgoUbkaF
 0uK2kCJ20r0TinNvfWM5ix0pgm+Z/nBs/Y62N+shReZKoF6iEK9H5kdwE26GSNEOFgTrt9cWIMd
 8eW+rzCrGY15bvgH6sJ301mMmYI4ffAG90yYsOa71pH4tyyFcij424nC0cXTG6rrJoItJXDlfKL
 IUDkCPRqPzPCCcsfjpk2g06rZIEi8b+vLtaVCgNjscK4HKGvKf9tKauE3ri82pE4swdQlcCFEE/
 4n+jTB5wHzAvRu91i176uz07JhXIlc+yF7jnsVNYCsP7+CGpRNwba1BWSbPAEViu4R/+JdmS8L/
 +pr7mvJn3aZMp0bNqipqZlidXRqUrSGwZk4SnaPs9/ptz7M0sm8z+Stj+/BEWks/d1JjYHVXRWi
 RqD0WGhd5bhccaw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A6D01A0004
X-Rspam-User: 
X-Stat-Signature: i3npwqutdsu1rek4p7rw93hsywz761ik
X-HE-Tag: 1768499356-854980
X-HE-Meta: U2FsdGVkX1+KOo5eFCi/E18WjxH+2duJUdVBCONJa6iYT+3XS75l8nYnXqeUlpJkiTc6Kq98v8uc9oWI8EgU5W+twTo63Lkg4uGiEU+GO90XMj0QVali0ShyEw07+tsT5OFUjvxYsRl0pHydezDls5IZ1lCnrLf6SHyd8zUZMuG6SqaZ7uEmy7tkMYFxJNziW73ifywPpMgRSIAz5fpTSpmj/U9tO302mhBY/ELY2WcGpORuh5CefZ/BrIyRaoxU+8EdOAwlNWZYvoUf+3Ib7bqgGE3f/VXh3BkeZRsLtaUB77AHkf9Be79+W/KaWystFq7peQq7aTU7G7mkXWomX1/ZHauW7Z7RQaDoBcAusfnRaHhRkZDUTC1NgW6uvBFInhU3Ox1PDMY/DmeWGAViCIeCU6JNcBDTe8GQVgo/ABxXfPaGX4ae8rGjtjHgBai0Y+GZSC2lm3xDwc6d6j2I2Rgk+bwsaNSysoKf80XDw4CHBU6lcf2XT7I1RBoqjQxCilEY5LG8+gCR9f+24HzlYFLxQXO/XMXrPmbwdIZ9FyETj4qwDhzoXer/lcf5e8hAMShT2ued6xu3253dpN9Rmq6KkaIdVAdliS5ksmb6xFHxdv/6So0XxUpPq/qkWohGfGillkB3CxSXCv38GF2ufnFngfJNRZ0ZWEA+LYHnVroXyJwQRKIt1Gwd4yx5ChdDB47O630ytWjIDPYbz9G99bUf/i2Ev6eEGUbFpxVcI4qG/wlEBmMTI8FPtlKB3FJ8eAMnP1ofxqefDuCvIM38sXjixBqV9hOtLyYTZDfNWtLlPD8wrf4y7VTK+UFos/mWtpZggXT7t2IjfyuzGs8t30SZMk4uF/18LxHZcQNiVTNaVsK7nY2STp/j9xACqr5LGQ40CytZFoA6cq0ShL1pp8lqx4cZ8+uURgHzUOt7FkPBPEcIHc1JmwCZ7pxYh1aQx5jz2V1AA/E7qOA29RU
 fVR0GurF
 cm5d7XPhVF2QXDJ2mHeMrS6HMCxK3Bli4rianI36TvrWNurX9FlY+HHeI2Rm50CGF6/bQ14EVNni8iANI3MSl4Yteap55E+W/mMNCcj/lqnsA6Bu71UKmL/FHd6+Q9lT5jg27L6cKyUuAaKqllBtHlrEdgx4JRaTzS9eyi5PjxVavGNuTzpSztUyuWiw6/j+c+nY36rdUqvIzzfWSZLyL946PbzwZOMFmFJqA8OLBa49yOi7S8ix/i0VZGqxVyiIXfrES+hY/t2gsSI0teXSTM+ZGQ0GVdgquRlJzTFYKY/859VnOlk0//fHj6NnPEzruwfntpqK+lmYk9sKFfzO7F6xBiIphinCSEKwmSUbXEMXzidPuv19cNulrL5sjrK13rvyp9XqBt3CHpjs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ufs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ufs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 6e4585169f94bb9652aac29a14b0a64a7bb710d8..9cd9b6691849d52701058973f6b684f101df2634 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -141,6 +141,7 @@ static const struct export_operations ufs_export_ops = {
 	.fh_to_dentry	= ufs_fh_to_dentry,
 	.fh_to_parent	= ufs_fh_to_parent,
 	.get_parent	= ufs_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 #ifdef CONFIG_UFS_DEBUG

-- 
2.52.0


