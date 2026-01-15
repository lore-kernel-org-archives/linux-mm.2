Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE65D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23B96B00AD; Thu, 15 Jan 2026 12:49:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1696B00AF; Thu, 15 Jan 2026 12:49:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08006B00B0; Thu, 15 Jan 2026 12:49:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CBAB76B00AD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:49:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BBE6C1C30
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:24 +0000 (UTC)
X-FDA: 84334935048.10.E497626
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BE6904000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aoVPha7R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499362; a=rsa-sha256;
	cv=none;
	b=O+OfrriFb1MoftxcdJ+mHMvFn0lQSNZeMlOHjcRDx49RkXVBt/TvAKXU6870SCivJVIdce
	yHTeY6Gv+skreUgFD5D+FmLFi0HQiayninTceAtqd1O9Mi1fnEkRHzT9Lq2uxyqxWXGMHH
	SQU6vvN7agByHHmK0a0xb8rRSWGvsuw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aoVPha7R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+9dqYpkPaX+Jx32+UewuW6FC+I4MhbHQlcF/X9q2rI=;
	b=sYMSqKMKD7c9Fn9VD3cdzecBhWX+ToQHtqP4hBr/Wd29Ud3n6uw/JJZv+rWR0Bex6aB+5+
	9JmhGp/FVbbCeK3i6kYizzL2FRC4BgQJ0PMrPLYPCMxhdixxu+vmX5SMTRoI05XSaH0MkY
	Av1ci2nFIcDqJ9GFNnQDhyMrlFELatI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E548544379;
	Thu, 15 Jan 2026 17:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDF0C116D0;
	Thu, 15 Jan 2026 17:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499361;
	bh=vIHxhWXy09cxwOBR5jwdqwOPX/LuIGbTAXFi0NJ+sEE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aoVPha7RotP93KFonT0uh/G1PEbUfw5RzccdIbFwSWenDBhTkyRjOJtVzv97+g7Lc
	 ey8x9BxnX8OrG87Onr98FCMeeFPvzY9mFFWJ1ymiwRuWLGMXivaI0bR4sGFSYPTABe
	 z+Vl+P07B9BOYnJ46E3xo8EGbkd1+fhpXhG2qNpWFExdd+esO9kHr1jEmpufkm9E+v
	 QPBOflETm5Ydo0n4CF+1YV5V78GVEx8fbCw3C9LWmfF8KAscJIf3WE9nnTzPh/j5c2
	 /UHM/HpXTiP1OdEOOgX2+fDNfZD04sq96BNryy9C3J+VVT7VM40RwnkU319j+sj+i8
	 AkQrkPFtxLQ5w==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:43 -0500
Subject: [PATCH 12/29] udf: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-12-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=735; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=vIHxhWXy09cxwOBR5jwdqwOPX/LuIGbTAXFi0NJ+sEE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShHxC/QAhbO7mbVrXH1nVia3Hfviv3SDRtnW
 +y+FMiktpyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRwAKCRAADmhBGVaC
 FTFZD/9XDkcZd82hmY1yhsac5N/jsQmiIXeuAQ2Mkni6mEVMyB92tEdrk3Gwd8HgDOuWYPHu1Bz
 Z0O/OLUE08CCrAkc+MNTfeih8RKuVwDIW/S8xPrmsI1R7Fph8Qisc4hx8sMoaZ24qkAJ4GU+oMn
 AoBxvXpqJUDPih2yNiXyvrsdIXRJMDr0r+fnffl3Z1G/IYnc+Iom6R8Yi/JxVk1QHyJFKWBpCYv
 5+H1zVkKmg3n6OW7GXXq4boj+hd+YK3lgDgNTmYMKLeKxWajkeJ5vdqoaJwssSQ643uSWl/54b8
 MJa9r1hdHeR0oIUn8ZhMDFeqUZkVaePVRgmQPmPyZPFlmDdXmpw1wXMz9Li4DP6adL8mdtNl3JE
 OuJPSv7VxvmI7hqt5yO3GtdNn0QyNsEkotek1aAPUvSGFLD6P/OcK+JyysT2cxa11yh/iXUn3jx
 /yTeRPDYoqvBzQU97cd2AKrWp8YZCcJAtiwIvjJOO2jmURfe5Yr2sWLS/XF0Fi8QPKJuth76n6h
 mI71FzBHHxE/RE/lFB27XbFser2x53DCRndN6oMxqvDyZrvGJhlCftA/nu60B3fIFvIIiEWHeil
 wXaDHvjkwLW7kGh0gAkcLiqxiq6ba+YQ1+3OimFS8lE6jElkoDn425GmpS4u9OHc26ZNg28lZP5
 lWOj0uKQEFaRbbw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: d6rore1gked9rritfha9nszcwio6d3sd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE6904000C
X-HE-Tag: 1768499362-16282
X-HE-Meta: U2FsdGVkX19K58os5wH9v1f2UOq5alD6zVlyk972gOmTcEH60RmPBb0SxtPcqk9gfke22weiL9y90EI5SFte+1+x1agn4ygSfpVUF6uetjo8dbS49lnk2HEKTk6gZw3i5F5FN2/5KiRGJce4kefen3n/8M1zrAy4U7y45zbACap50Nd3yaNJvkn4rbh5L/LBAm8KHwxWKHtcbjruvBJBpLpUwDQ2P6+hsg14maPsZk6RdyqsMITjRojbCQNUADcqTi0fzbA84Omj1FxrDFzeAaDPvL3L2iv5Pxw+BbZC5xNiBy9VeHcY4WM+5LYG+DBNa4UGEJb/r9HSHUyG2PpqxqWlcitjtVy1qED+wrwKZvmHY4GLw+Sv7vobyI3WgfPnM+UEvwqA3pN7HJtAOE0RlvYh/idEaUuRn0w6w9R5a3wppBPgEOmDEVHmsm+BT6gWmstw/X5Vd02m13G0YftUVuGXRsps75uJfEcrdgg1nGWQx3ICJQQ4u8+zX20476kmliHRL+Eghbh3T/0oegMrg56MgzmS2Ovm/zVmvUV+vq9/Nysp+cMP/uNokr4noXJnU3pR02jJaKWtsd2qtFerpWv10QC34D/T9iebX5IL7hkIjBJ530g3+LVVJsuQjntzKNYhA5zyazJyz9VHCzg8baqUSmEm/LK3T/oVzywJHx5TbH+JY2HBIzkMhmk+qhaGmBQSAOnd4OS6Ezr6hq8XYC5gtfii2XihlC/fGhaU67FNsS8hXkGyrkzITMEjdFE/LgoBCVPkTjqC6F972nHbVEVpEUX+Ct/0TdMIZdY9WcAxy+99GEJCOY128zap0Xd2z2PNTDjize1Wspqj5THKypiRuNBF0mfGu+GROagvN1g/sg3r4pQRcyFDJ5EGzsARDcqDwa5ndBGew9znHtxIrh0gmvhF3OtCKMEQ9v2I2bTfWgQvY7f/TiLauNkrngPMSd/R/ikjzHTWxcuwDyP
 nyzpA54L
 s1CaVcKYjjCuNhJNR/oc8Ni0w97MvjL2Gy2UNO4yTId6XNh3FUj2jN9cETJJ1iuUVyQGRqoEA3xkd0VfucKmt4Ud8BZT6AlgUvxIkngkDffuSmufvrUBr9J7s4CwcpeGPvh3MS6ZMkorN/b592bhy4B2RAhgX6fIBiD4aUg8UhBVkdrjAasE8Q75x8wWTSqItaCWZlqKIW1Wuvxm++K/aCYf5FTFlATx0FD6WCEdKSjLGq6KHzSQrbv9cb5ccGNeew0tVlSJQeWh6VNKsVegNxHWR5NP73TVAWa6Z8+6qJsP3a9usIQA4pxbUw0hjZgadQIxr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to udf export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/udf/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 5f2e9a892bffa9579143cedf71d80efa7ad6e9fb..7b8db8331c77bb43d9a3c4528aee535eac2bbd37 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1012,6 +1012,7 @@ const struct export_operations udf_export_ops = {
 	.fh_to_dentry   = udf_fh_to_dentry,
 	.fh_to_parent   = udf_fh_to_parent,
 	.get_parent     = udf_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 const struct inode_operations udf_dir_inode_operations = {

-- 
2.52.0


