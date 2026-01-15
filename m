Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE060D46608
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D096B00B1; Thu, 15 Jan 2026 12:49:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7196B00B3; Thu, 15 Jan 2026 12:49:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6606B00B4; Thu, 15 Jan 2026 12:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8F86B00B1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:49:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3EEE16043F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:37 +0000 (UTC)
X-FDA: 84334935594.19.A378EFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0C181C000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MtzuIh+j;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499376; a=rsa-sha256;
	cv=none;
	b=BsQ81jdalz4m2e3BZInZOGOwUAVYz8jPTmfOdW1KHIw183dVszwGd2YN+t037IUGRPmT5j
	IwOFUx1BzkFTpRpf9kJUFUGuR0Qgik9hkyXgUNSmLbX23khvG1DxBnLUBQ1AkXRVPXpG9p
	Bxe9efCyTxsUZE4f2udhc7v/kE+zB74=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MtzuIh+j;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGE+/R+xr2ssRJ8nfYf9SyWSi8dZQdz+dJrmGvlYUOs=;
	b=LqrhRsJJ7TZkcM1ClTLaIx/P9NNJhHb3hQaaS/c9uoo+TXcqchycMjjUapJaDGTvPshRQK
	WgMWTv+5NeKgxqxQGndoppDt/3ENbe06aOLizg72tf0R7XsX5RdZ0I2y/R2veMhXjKcsm+
	5VDTpuLUTOV+Uz1alqjumLoHowdHNco=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F0304054B;
	Thu, 15 Jan 2026 17:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9781C2BCB2;
	Thu, 15 Jan 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499375;
	bh=KwuPM0JvOV2Y7neKzi/ub00ol0HUZ0d+WxzE/R5Rb58=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MtzuIh+j84bstKjsgPpleVDxRrs1Yf5No8647Evhx0+iM9Myj1+TDlreUc+fbCqBP
	 5POihyVqnyL9Volk7VBvPm0/1F3iFmpnjbbOwI+SqmEdVivQdCS+MgI9LG/l+BlUaK
	 s2w0ZUN5s2N4stTvz/OIoHSrJaE56oxacHPgAwx8gYvjlMQzSuK8OOzGzUiSJWMZZ3
	 MRvP0xqpBu2v0w9vX7/03YRHxPKRbLGxTO5vEWauXJXlDZ8OFusX39IAWOaBMvO2vy
	 2vkWgH1aet1K/R+NA8ZxavFbBVWjjNWwv/K8qdA5ux3uxtidjH4R2cuEr7aZwDRcXE
	 aBOyx9ONydY6A==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:45 -0500
Subject: [PATCH 14/29] squashfs: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-14-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=811; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=KwuPM0JvOV2Y7neKzi/ub00ol0HUZ0d+WxzE/R5Rb58=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShHm9fevfEQHe49RNxKFnfPTPGVBoyOXaDhl
 y0a/1EhSbWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRwAKCRAADmhBGVaC
 FbOKD/4kLyr4rIIQt2zl2SLHntE3ibyDMzGdKD4l3jfUvNu8RNcwRqaHjDzCQnoUnEOWkAFt6gm
 33YDsabLYaWiwW3riPKtFsXi+UQZdkhwL5/trI0nehU7Dd9LQ1eV7m9FsKmIGrwbVE19B3FyWfA
 bB8YGR706Suce0iR7ci/0z0csTdU3zTqvzojqtOu4/OYtq+GkC/6k7OgOCU4RQ6c55fR/+e0LLq
 P7jqv+QPhK6GTz90SDHxvtmhoW76vzDZEqlFGILfq9vhyQ6X+CQP1RydBtFghIztt/Fz4TSK6xi
 hiG8xV3hnRG3+msGx4O8Hfmv1h7y9kE0BNFh4PEgpSrxWF8l8kRg9tc+IGQAWd89tClvFXR/qOL
 5uc2lTR8WHlctE4PlAiIOVQJRqkco6HxmjKkUxxTHRj8OKbUXkM9uy2Mch+bRr0fMdMSkR2Kb9O
 /aFPzGpZYTjIgXYdoSkMg0UGAW2KMIw06oZ44xNvihqtJoAFLOQy6ZgQgA1RF13eSt+rYrSuLHc
 kqP10SY3GyJjPWX6vVl/KMoQwB0QXqbK/jcVTMJEZB1lo9YhkitLhi0dql0G4OjUno9IwKh6FB6
 RXkcfJpR9KghiraL4CmDZ0y9W2AK9tGoeeBqEAY+os9Qsu0tT+NRnEzgdJK8mcu9lBOPOe41Yn/
 pBpZrQXTJWrMkzQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0C181C000E
X-Stat-Signature: uzoznxnpp6beibbsfoet53ezzqpq9h87
X-Rspam-User: 
X-HE-Tag: 1768499375-28181
X-HE-Meta: U2FsdGVkX1/TLjLyXwmQNViuZxxsB7w/GV0PkQQ3keKXPOMboD4xNQswSK5fczxigVfQ423TVQWSEIc8UPbk6nx+ZK7hdJ2DBjpIFrATTAq0qfhsQiUzm2EzydvUGORlxSmbwfGRBTnY/7Z23HPVP82xYuNW1mELVipDPIO1PTelJ9wskxUGCoBCwppUpU/mLg4DH9WPRaHV7BJmNik2jHWaE03aNV0zmvWS07HWzSC0Mor0UZ7vpZ4rhdrFWK14h3dSLI5pj64O0m01iYv6JL+aTEPf1kG0Yq0z0VvL+Ly9nh2vWPfFpUjw7C/0i9jij+yF5pnOwuidaXVEcrmhTUvZ7zBcxqnXvgaqcC8gtjSeuNDH2qdJVxsLyGVqDpG5GOJI4TdMhAUz9wsTPZ6FQHXfukIQ/sHwss2O3WpmwIoAphs9CQK2FMu6fsnzkUK2Np3HJ4d8lFjHeieeaLsI25TFWuxjIrpv58EZHDt00GuKox54PCAzVpFULkI3Epn1lVi/Xun2GxGR94x/tbzJKiImSROz6I99KvW8uMeW2mWxCY6r32Yth5+js1WTc9CzR7ET0KraITt7q471PaUeLqEsIkgBbpv4+yNkDlwQEMfFiFdsQSdeg2yg873lGWVx4Qmr35Agx5YOmTNvDSilI4Iojv7NWXmhM9kcwfbZh4Lg5lK7itdfCESYK926ljlAxvkNhHp6sJ9es7FEyXtbLkqFa/fkBz+R982RbeRUYVof8lmZ76TR6ujC3g5/VJj1k5/s5rVjh9B9z8Ngtqv2Zwv1D4fUjt3jCMsl08OFMe3ceZVDunLdYnBpgoUewTuLYDJpO1VvTLygfB6n2r6CxlIBKz5q3GhSziiSdrhp9w9rgXvHR1jrgKKRc6iOj/p7c9FQRuXZMBFsHDDC6i/QP7vZGGedsDaX6i8rC+V9Rl38eT+p52bJeU7AC3jxP7TM/RFnPvrNFS/aqV9n0tn
 b5Mr5Vh3
 PA8ex/beLKUlegNRVVRxoxaYdfZPVk5d2lPZHo2eKCA9DodRr5WNyRx1Cs4c9HduROllFvXomBwwwgx7uHXMQDhlezpoH47WlEP17J5E62U7PD3XTaf5PQSP8IbzOZzEcVEvAjkSZfaofitmhLhIDAYfYF2tsynmhySpQ6wgT+cr81v72HjdoG2WES9H6C7bvuPxh0W5zPI0tv12m581cLR8sP9RtLvqWVlJbW3lpQNVW78T5LQUVvCQy6CnfXXed61oPjOlbVQOvrIv99bt8H5SFVJV+H0khs1ElrevN4eByC28X4XbLThzn46uqSL2eHEOp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to squashfs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/squashfs/export.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/squashfs/export.c b/fs/squashfs/export.c
index 62972f0ff8681c798f0b11e17d501373b2145bd9..c6c4d8f1f115c65b6dac29582bb5b447b823d3b8 100644
--- a/fs/squashfs/export.c
+++ b/fs/squashfs/export.c
@@ -176,5 +176,6 @@ const struct export_operations squashfs_export_ops = {
 	.encode_fh = generic_encode_ino32_fh,
 	.fh_to_dentry = squashfs_fh_to_dentry,
 	.fh_to_parent = squashfs_fh_to_parent,
-	.get_parent = squashfs_get_parent
+	.get_parent = squashfs_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


