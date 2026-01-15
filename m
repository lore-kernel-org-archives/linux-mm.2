Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 346DCD46609
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8F16B0099; Thu, 15 Jan 2026 12:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798A96B009D; Thu, 15 Jan 2026 12:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65AFD6B009E; Thu, 15 Jan 2026 12:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 514F36B0099
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:48:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E07CB160456
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:24 +0000 (UTC)
X-FDA: 84334932528.21.EC2540D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0E0C718000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fu31I0C1;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zt0OOY8HyG5hoN0E0x8SeNq+jwTJvLea9QHt4A47vpU=;
	b=68plNXepxCp3/z50/iVfoVj6srmwpD5vYavu8Uzw6ldwcJerY+JAJjSburVUFFkLhBRrS4
	JLduoeLW7bVcxRxYLLxaOTH7n/S3a+We1dH7ykc9z9F7Z6Bq8tQ7Hog5Z/gjhzCbqzydcb
	EqTKtzVkbMwVeZ2dqzAONNTVwZGJmfE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fu31I0C1;
	spf=pass (imf24.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499303; a=rsa-sha256;
	cv=none;
	b=jci9B7oHzUCxEmWdtrjB9lgFYbu8KT/D6p2Ts/VO900kM7/g7tz9JOJMVKuJRyzXE+lr42
	e8zG+WX/hnfaAIQV6Xmj1xSrO6XvoqI0JSjI0YBxqKMuontYRizzcKgsMonTahobuKfZM7
	zlXE6GxCcFX3BDNP8NSFvlxaJ6TYgJM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DFF143C8A;
	Thu, 15 Jan 2026 17:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F22C2BCB2;
	Thu, 15 Jan 2026 17:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499302;
	bh=cRlpRhg6xvxKE1542vTz8cBp9dDE4OGqd+9j2b595OM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fu31I0C1mcdk48lMcGV6EtvSTJtTvS7viT/oyZx3ky95KhA1IgSibc8Tcjmzk5uog
	 JhOfSN0w8eh5Z08O9hxA03062iTTRyFy4/ENNq/6sLAeHiEPsDHmsbAIgQEI0IjWpV
	 T/St+kEHBMhdyyRL/SqavuasePDHiTIF3g2iGd/j+IqyY/GUdWdAZidh6pKv4L+QqD
	 OMgBs/gdxX2ELQ7SDfAgshPh0CFXbDJQc4/Tduuex3ApWZoagP4zA/NahKjB8yVq/x
	 z2ul5X5032MbJsxbTe9zc46WwFLwjcxopwaev5EqdvJLAaXHPOxDwVojVBE/xr7G9f
	 0k+rR/8yf65yA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:34 -0500
Subject: [PATCH 03/29] ext4: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-3-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=701; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=cRlpRhg6xvxKE1542vTz8cBp9dDE4OGqd+9j2b595OM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShEgnrZ5MvNZeLKEb4VrTRZtcLcYgm2Rrva6
 3/6K7cxfryJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRAAKCRAADmhBGVaC
 FVmlD/9gn1qIb6YReb8Ce9KEi8lP9mKlXfsYUelY1yljVioBDtrsj6dPS9mWtSjm8Uo0e8RBQUw
 3u+AYBYfiZztHHSK5RCTNlUjYWpIOmHSfhaFA+4R6tA1I1k+wi7KMOlFd56rQZv6qHSt1ux4hQV
 fOQZ4dgdIp+5Y02KZSKXCJO8T49s7NnWaTpmoqrRPKxAITVwK8tY4j+dYksoEjkWEYlmEseo48A
 hdWLdh0SSUK/KUBfEg7RBnvNnLiGIhzgdB4vbIZuQnGL7grlU1sE3BKU17GNyLtiCggOZi+ZybD
 Fw9/2DcXJRON+wjA49hKtjHtEfKG1Y8qAaH3idaqGpnoC8r+m4b79j8mE0sXsSd27plq8MRIOuF
 pMlERSHj1ExH6xOwzd6jpuVJkfOxWw/bBUNDlNsX+gw041SuiwHaGaMSyESM09G/84gr2guNJkB
 7aVdZndIARxy14e/XPziyJG0nJ2et7ls7dVfhAkrcFjxtqtS1qBZDCH+O5EojKDDoQkHXF/56fA
 kYYYvjqZCke8Jga71v8k+MdprNGd0kb9Cc+lhK3Jw+k7EbYR3AhygOt0L4FjWbOKZNYmJIxuENm
 J7q3k6kEC1/G0mhmtZHabQpfhJkZJRdW6fzCMS5Q4y3EE9WnfYwtVOrERWZLvlhEohG7qjkztgp
 GZ0EXfbh6QvTyTA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: ejzbcartbrsmnrdadzf468yge67oh39g
X-Rspamd-Queue-Id: 0E0C718000E
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768499302-815312
X-HE-Meta: U2FsdGVkX1+HyRa8mIWjG+xl9yUWcSNLldFXyK3gjoav+AwzfhgUi0zKkC4QIL7tt3AfKymZELeW7CvlcHi88fRFclw+VkN2JVGUecgm7Q1FPpsf6rRyYV7tkB59RUVO5fDUd2Tv33L44i8Hgnb89frdBOk31gzB9gPwpcM4KhVgRrYnWyGsXDfU+S++DANIoY6KKjo0uMaL+vBmj1X1Qds9ewhG3M9R2mad9EjDxlh8dnNy4SmpBc4L8R3QAVpI+RbY3IBFbJstHA1WKiaI11R/Z2x4IWuMUDOv2S8jIN9na0nqCdNTG1nI44iHlIgUsXIWRG7acoycwGVB4pyieXvAnGGu29b+HpBEgUsWIU0a8/OasaavFHPC8e6kkLOU7Thfnw/ysA90OhDClkueuFGzgS2PT0fJkuHOUF4D/Pv/yONLHbRiGaazynYxiQGQBlKMABzqy+77BSHYvn/u9feLovIzY0X/mvy50IKNg4yLB6wCdnfJkUJm2nPTAQZ3HQUg6ZtuVo9VUza0y/sIEwmZwGMuru+o8U06bX1tQDsaancyDnxBSojUvBIEEG2EVyHqjDoMKnsj6GzxLcQUTGI4++7ysbOj2TX3fLq6B4h+w8TdHBoJp6ySqH6LkGHoP1Ngdfhgp19+mFMtgbXiMhOgdASdIUd89Op3tvfUbR0TrrvyozyC2UM75ssDUANYxFYtSKwLKqHzcnlT0eVCQ9dvHV5/66vCOOSUMAuIb06c8kgcvM57mAxk6oGbDxJuFQeDAjqGnuzylyWonHo0xQ8zyK2084F7LjWtTGQ71DgfEznRBXc4Pkd0JZzjLI0B0Q+NSiRyyFCFTKfkC7iqqWxr4+4eRmjJedDXchFFK1yDxLfwaUcf6XFuq8UAyC01J6VAdngI8TjRzr3zKOLQaKSjNFgapRA5155UKCzY39kmWRUddsaBAU11QYSDrp5EfhaY7FFY1XLzq1MsSFu
 UXxQHc6G
 4pPoN0GckQ5Lzmje2t5RvNJZI16IlrZ9XAJtt19nlVqSZ0Ke5vQwEvuwqYZ3DSmzDi98X/hQSUrsL0+AgvN31s7PdnhYKVsb9TB3Hhi315UGKQugdmXvG+pBi+KVNSbknQpebJcuKOCeJkfDFfo8L9ikcrO55098qK8UaNJ7YUfG4toIeLIIIOj4NgjoX6iHwxVG3JNoHziaH8DKP0f8IeuaSl+qZd1HVXJGj9hp/JoKc+eGx8sw0h/PzQyXxJdZ6c0eWIE/lBaUrFtpgaI0DxhcRo6wZ6O7LT2gLA8uvAH/AwHklM3JlfzKTotrnj9Yo+6osmM+4lEeTQOHjsLCyloa+FBBSALiSq8jypxrS0C/aO29gaj07tdMrxCLZEhkN145Z792gnPl51rU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ext4 export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 87205660c5d026c3a73a64788757c288a03eaa5f..09b4c4bb8e559da087ec957de3115e4f7d450923 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1651,6 +1651,7 @@ static const struct export_operations ext4_export_ops = {
 	.fh_to_parent = ext4_fh_to_parent,
 	.get_parent = ext4_get_parent,
 	.commit_metadata = ext4_nfs_commit_metadata,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 enum {

-- 
2.52.0


