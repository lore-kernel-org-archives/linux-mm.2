Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B476D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38B36B00CD; Thu, 15 Jan 2026 12:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21216B00CF; Thu, 15 Jan 2026 12:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26676B00D0; Thu, 15 Jan 2026 12:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D03946B00CD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:51:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A58B1A0431
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:51:10 +0000 (UTC)
X-FDA: 84334939500.25.F661AA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B3A9614000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:51:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dneG3VhU;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQr/NA267cZ3g24Kg8aAk7oc7aW4N/K+I8syFSJ/ypY=;
	b=OMLg/cFZf6VeWBv8Z5h7Wem4C+wxOa3jIFK2eHIsbD8ph/o1rHZJI7rqFU/9pRzf9v/G1r
	VYBrYHTFfM8H1DcVF6pspQanOpWJI6HsSEJbseUQxjhWRpxbXZR51lFTcycdTvIcoDHAPK
	8r2jFNL15bUGItjw7kLFsHG68WvEvO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499468; a=rsa-sha256;
	cv=none;
	b=fePHEKWndBPL7UGmM1L75bIQnDLchPfU7vNdWEssgd+XxgE8HYHNyZZkUHjEQiBqkPELgR
	W2HdHGmfIlrtypY3IpHTzrb7neDu5Bsbtdv2eqyRltYRBz4nk5JkpVcgkGx64T4oDFaslk
	YJ6kDthMfwvh6+NoJMuq1IbMiNqr4qY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dneG3VhU;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D38AD43CF9;
	Thu, 15 Jan 2026 17:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F23C116D0;
	Thu, 15 Jan 2026 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499467;
	bh=htvmJ8h5f0pVu8ImvWNw/JEkkap4HdmaXUH9XULOP2k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dneG3VhUX0Ru23kykpC7XajwKkRKVHqAceMX7jvLNqTRePFNaBuM4ayubTkUvny9N
	 P6EMimUbmvqOqRKadRkQ6T7qroO5u9MrJ+DI/HjwjvI04e2SMcpBqTgzoBJXVzCVj8
	 R5V2wa7+oi6y8sxhLKnZsOoY4DX784WY7uMLk4lb4Vc6Kd/4OLd2SC3Kzlq8kw4pdj
	 8cARkudpqQaRPHHhqvPOw9xFFGDEn4QLQufxN7dtMK+XuU9P8Un4FgC8HH/KwF/e2C
	 moyzLlfSM3DumjxHD5fSrAeTyGV8QjhVSQG+YNhDelzpN0HchBhm/5dLFgin2CwyUD
	 uo+ijlmJDN9PQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:59 -0500
Subject: [PATCH 28/29] f2fs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-28-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=728; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=htvmJ8h5f0pVu8ImvWNw/JEkkap4HdmaXUH9XULOP2k=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShL3pTOMCAQjYksxun5CypfXLq0xcfQ0yLyW
 65BR+drKTWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSwAKCRAADmhBGVaC
 FUFkD/96PWmPhmWuooqOKgSLg+pqHnRgUaL7/ZNDUsAhBKEADaxTrSuVXnu5y06MU9W3lXn3Jki
 tJG1xqeTtwFPfjupnxuGii5/cJK3grEucHSsaObz/C/IPgm2RajqPlObTc5yWQzLajH/ZdsmKuz
 iaN++m5BA2rgnLkFTWSjYb/rOq4ox7mbDacV7EnxfZLef3pg4hlNbFjixmHWZq1YxNtv1GM1PKB
 bYlU5nOry0N5MLT5mJJyhUCXgfMSr69UikdXegrkYuuEal8PA7L2A3UO2DuRcocHdchHdO1mIiI
 aPpzI8SRvE1DQ1wGC2Rr0ZjiolVqjHMERqoPeTbmyNDwFpv+OBpjtjiUYOyD3M4aW7gTYR0+cKV
 E++nhLNIBtBmmCSujF5Gfgbm5rpaJOjnUYkeEDI8zW8AKDwmT4OztE+PvBlPE9xUsIp1A3S5Xdo
 envgJF0kLa1c3oxdciypY/zYLzOtZCb6nL3ixs/MEvwxq9rGiFPOjLC7ctPUSdQni2by6qtQPGL
 w2gOWH1cGO52N67mW9gfCQswe2gXtfZ4GWZLWj9tnHRqmUbdUXBRIFYxRZRcu5CTuplDEOB8K2P
 SNqUouDQZv8sR9URZ+uLTShPnRPM48oApHkWHBLVd0u7cElK7NOCQVx+XgJcY4pkTTaS8REV/+m
 9YQ7wwUNgBGz9iA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3A9614000F
X-Rspam-User: 
X-Stat-Signature: 5fqigkibyfgy9y4e1tx1xupoze99zbx7
X-HE-Tag: 1768499468-446414
X-HE-Meta: U2FsdGVkX1+NemfDRfICNpSJTxXQGaNjcUnhGejyWR2LAkbpAn8V6IMTkklPOLcfSXdJFer3NnbhYVi3XVrsDTzyo9X4KMC8YRqIRuxcdSOAHHEaRKCQlwTV+afxpIvSkOIsr7WxjGBjOt9Dl3JHzrfCGx9FD5xhB0KKC6S+JBL5TaUInV9DERp+rsjiaq2lvyjGyT0qgmSkwR5CnVL7LmKjq1PU1zc6wpkHGO3t2+ubMCur06GTg7ObjCv/hJFwagjhv5LsnqA9MxMcKVVoZKSeqX6NImbnG5xGhf5ADZ8lBnY4ylxHnyqKYAwd59qxnLw9ANZ1NdsVsAMxqG4CR7ntGERG8ac1G0ls3Vpm4b6dOPt3DV4+s4WtxiCH4j/UpQVVD63T4ZUh8y/c+K/UJqxW47iRp0rlVKZyOwlRGSTh88UNpgVL1VP3ZyuL46IYBO/tJNQwxtU7xtl/tME0ypeAEcKxbsXRQo1NyxF1QKMB1c2CzxzBZBpb9XtLmSs4DTzZwXqC6eQZQYR9zvNMPLtGnTFp7wrIqjCNqCsZAfsiFlkurdBgEQ54n78IIHu94v0jEB+Z80p0rIU9mUsdFqTfm4UjcKQstisvH4wx5a7D9j7PYJbM0fCxxA7T3++XY4olvsyVbGma++z4FjAy1xKPQFJWaTKEUYUUtE/k4vCTaWwxEAlpA6tmpoxfXJiK4RP5CO0uw7XPGptLkLZKvF6MmLDEnjo6x2YiYWwYIHk/ffBaraiJkyxy8MpJP7J9w2ZsM9qDg9LbdmXOCUYijjWg/m3D67pmNDs4jf3tig3tFmg8SscNwOEc6KwK5Ku6dy1FhfSYuma95RsCWiD2CXerQ8EBJ/qR8UViq6Kho0jNRoFH+CuQ3Y12Uv1gnz1z/sz2VpOPw/4oMGI++ANtKJNr6BK0YljuxzUghU86kohCmECEdr17STYjrnbVZxBhkUcrrBS75xD5MtFfcaF
 NrfgGv1c
 52oCBRiNttgYg1pN6UC1MhQV6gzzzaSpecGgSlN3NKuNU9M+3y7mFzL6j5KkwN8sMDcNHUS4zAN5s97A6u+GNw4UMXr+4cSGCnmKIYEea5EOPV0ayI7qI36u7TRewGSd/02ZtbJEufQZwfgv+fKrw2D1M5WgyzJtMwDUT6L+UGWD0oCUPqZlSedEXTuLkdC4V45iSxCr21YKiD/IlVc+znmyK0grY7sQVuO11C/6m1nHR4LAH+KoSXCZB6BVYzZH/fY3Ztnbx+CpTn5d1nVMrwmNTSktFJPo2PuWX8EPNJvr2b1mlWZUCu03lyPum2hhv6y5x1Trn02BQaHb4pmI2h5CdPiIUu/XPaLq+ZzSABIE/vwl/3e5O2CrQKvO/5rOe12JDK/npMpA4AFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to f2fs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/f2fs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c4c225e09dc4701f009dec4338f2eaba1820ea7d..260c26771c431bbb36e99be8daff6cde40662751 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3750,6 +3750,7 @@ static const struct export_operations f2fs_export_ops = {
 	.fh_to_dentry = f2fs_fh_to_dentry,
 	.fh_to_parent = f2fs_fh_to_parent,
 	.get_parent = f2fs_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 loff_t max_file_blocks(struct inode *inode)

-- 
2.52.0


