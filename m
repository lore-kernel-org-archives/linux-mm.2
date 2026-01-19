Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 431B8D29C46
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A797E6B028A; Mon, 19 Jan 2026 11:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57646B028C; Mon, 19 Jan 2026 11:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966A56B028D; Mon, 19 Jan 2026 11:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84AE76B028A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:29:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4299688C0F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:10 +0000 (UTC)
X-FDA: 84349248060.23.1F966BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 461461C0004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JRT/TJNW";
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840148; a=rsa-sha256;
	cv=none;
	b=L6PoyRliIZnpfcmiVkuOq3pDGEUpSOYaErSLWJ125pH6Zh2WN7Go0ai6ky9x1HE9gsBe4Y
	YRlrAj0PF6Wamo58stYCnYujz3/v8QEiTaS8PHUIDkh1NO8VhwMOFC0UVyybLvjmdw/khu
	ptTroLo0LuvsxthZR2jJudOr4Na1sgY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JRT/TJNW";
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Re6nnZH5SOOtweYNC6i0xBdtjjagVEySFsoYsbDZ7kY=;
	b=LE2sbQNp4t5+ggmOdmeoWwmn5A8S9SbYlHIijuyxJHXezNZUabq3f/+xpV5opIOqzPl9ky
	N36y91G2z2qXVqQiS12QMh0s6klEzb1iXLw7Av9daM+Sim03cRt6Z4IX4MFuCkG6myDoHT
	WvDcFWfWYy7jHZElqHtTigoQoRtihdg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D1C74450B;
	Mon, 19 Jan 2026 16:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A54BC2BC87;
	Mon, 19 Jan 2026 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840147;
	bh=AZAjr5blB9svvv4iy5pFFBzbvOqXSLNmipoZVSEtwIs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JRT/TJNWCbMyt7yIyaTJly6FUhnDZuUxeZSzJVjN/nYS1ps9R0rsJvuhvNTrEk+la
	 1UOENFRaQ+Za0kHHt9AfFI6lZT3tyk/oWRcUSErofVbPjhO/YFqxhdt8WsPnnCiwPM
	 ItMD9tD5V3IaN6AvbQDQ94y0gWWnR60KsH+Y4szRkrmWQvAvN3aoV3uO1I2xGnFTjV
	 bb/zy/OjfmmKh+KLGE1ZQLzascQk+/6G4j0/cFuJri28/kIMIdJDY9BFUEXUnxNhAi
	 KKnnokIJ6qWsyghLwik29BZabKbpjfWWO9IBNOAfp2xo25sBNbzpzF0uEGAuTYvmFn
	 ruklEykJbu/FQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:32 -0500
Subject: [PATCH v2 15/31] squashfs: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-15-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=811; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=AZAjr5blB9svvv4iy5pFFBzbvOqXSLNmipoZVSEtwIs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltcugWXdJNtlW+RKXOXYTtYGJsG/ZI/Kgn62
 QwygZmbY12JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXAAKCRAADmhBGVaC
 Fa7bEADGBiSWRROuSs8J/91dJopWVmzh98rAZDg+3UJE7SHjCQVSwc1En6E7AttfsLanh4BPsdh
 Ey7dJYDTjb3KJReJoWtnBzgjramNeksgxA+e4U65O6gESkPKGSPLVEuByheDKvRtZxmYTtiqgzQ
 Mq2wEtjCZaCAWDVrRQDMllcwjxwnnBpyGy2HIUVdgPO33orBwlEUy5KumpmMk2e+P8fDAdOdqmW
 McggNOU1g1zZKrHp5rGDw/zrD58y7ffoAo0LgxBIwRV/PXjnMWNB/qD9ShCqpQ4BTly2NhUdW9h
 vle0WG/ufE0iU82wXme1sD/eCdiyuDlzLr0gcz/A6spq6D3CzkOznL6gAdqAk2wy39TD8KxPkYs
 Z9/zAlzaWQamQps1uwnyUrZYX7AkWLLLxdX0RYn4XKio+Uv3rfn0hTkvaETy6U2dpjRknebcsJR
 IIRnE5cqH7Z6CylksCFnlCxHsDjnnrBGr2HOdEyX7vZAv4lawkMEFUbd4NnnJC99Y90W1T4O9sM
 lz0DCW67haD9hC9Htrx6MMplYEzK08RQaRhpP0rgNkN7e9hP4YyIFLMikzCI3X34Rdbegi4sDxv
 BV1chOMAWIlFLNKsUt1oXQPpErFamRzH7s+wD9wS+rtnGDO2C95CtPLHJywk32fbpo7UxFjaRsT
 NPjT8Wxn0TBT9Gg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 461461C0004
X-Stat-Signature: a37bxif4na9ncscy1b1s3dho98853u6z
X-Rspam-User: 
X-HE-Tag: 1768840148-854124
X-HE-Meta: U2FsdGVkX18yVgtU1jD7E5bE0rwcMS1+hk0IuXzvuxxQzRwVfVLYJ5RT66c9BJYBHulybLknGQIWYnQlDBV0yV8sTNKpMAZaQUwGi50RDMj0ONMs4O+zeDWnbxh7cMe0ON4Uq2qauz/gtDnPM7xHW87Xx9o+oihfy8QgWGFYJXow7EyS71NL2Qioy3W7RqvjUZx8fK9hZOWHH2u18wZIQk+RnH9RhBlWQO2ASnlrrFDiEICXc7TInxRtw3JHmTcR2g+C0SnuwST+MXHLzD0l+yji2ZTcG/wOz0gjJCq+xsXcywdzHfUpenI2u5PpCIw8bl6eC9uw6YfPlXyXl+iz58rMtS4H1vpMq2WfK8FZKI2+RYPBzHKyc36ft+3tcJYtPo5LnnFOI9REs4o913gLYEjiFTcQDM8xePc04BgWEjx42frZPsgYOcsDLLxLrCVWBWfLBTbos8VDCui7Jzcmtcoppx3Ym12Ob9Gub4gb9sMRS9XiHx4MjExGC2dlY0qbK/hqFJXelLrSkLlz3FiI+W0M+NWLEsh0NdxWbHHNE2ZwjnRSsOe/oOPHFmMDq6nBJBr1BfY9q1z8j5pp7zhgPuS14gNKdspmo2yEsW/56hmlTCuXqd/pkufTXH9ffKl6KvY4Wb5k2mSi1oLSxt6PAJd4q70C1TW8/rlyJpNiPzoVj4STi4ud74L1Iaxacj2vyJfwsXxbjb5Jren+TkVrY7rBSnMT2FajZ12gcb2EqiVmRuI3299Yib/wXnaihu3BU0EOrCBcFGvNDgREIjAIJE6VfhyHxfj1FnPx8unHZWPp+JKDMEDn2rb68eQMnLdVCHknNEzPwLWQBrjJ+cDIQAwgy6a7v5GLfROeQT7InD906n/s8nXOtay7hul+vXOBD0T5jHwKFw5d5bhWZZCbkGHHxyg0WpqCS/wiATNHd9wwRMhUqCmY4KyQABknT8QDfL49lHDpVHZf7GfvNDo
 qfNhJf+9
 CZutfdQY/2aFslsz8z1YyyrtwvNZa5ZRhu5KtBn8hqVCgeSwVYYPn/BsAdfrpNIr5TnGOdSm7Ehx/+fBZC4qinyeT7pvt8K0QoeAonljNzugmm+AN1LjshQzhlqNsjxkD2qJ/9qcXRTD3u+69ueYf9VIO3xZdCaxY694Ogb3+NjG6OWNw48df+TbiHXBmZEGNJqFgkp+34id99JvXDJPkQdfJykTLph3VG+c5s6shKuu/uegRRTPkd2/e3w4G9rc2gIuKtRlIjJK8TC4YJwGPf6AGyJlcAG9Q42czMN4nLtcaIbBjJU6KuxsR53bIZd8NFdqv4ia/q8GatsHdDH4le4om/jFJCH2hf7jJZoRWIiLQNOKa/GgzMXIofeUrXIoTcOuFvqyKMBJ1zjByq/RiNJl6HDlOI9vdAnaiTghgSUYwRhrBUwWmlNSALnztc9kucRi0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to squashfs export operations to
indicate that this filesystem can be exported via NFS.

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


