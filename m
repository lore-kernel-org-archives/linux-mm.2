Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 928AAD4660A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026106B00C7; Thu, 15 Jan 2026 12:50:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007EE6B00C9; Thu, 15 Jan 2026 12:50:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E561C6B00CA; Thu, 15 Jan 2026 12:50:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D40E56B00C7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:50:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9915013AFC4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:50 +0000 (UTC)
X-FDA: 84334938660.30.4BB52F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C24D6C0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HAduJ+b8;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehBSJ++W2cPkB0J1WK/qzYleqmCU+xmhuZ52acFYXD4=;
	b=77o2niNh2Ul2N4SrKZLNOyDenkzq/mENaFE2eSlpw9/63phtBWkfPMaMn+kNBn7bxDTBmA
	EnV6TTwg8ZQgVjuzplX8ssWKR4R0InlrmVdZbMk/ZnPl+SlOd0roYtcE36OnWjPeoOifpn
	Ut5nJA9r0NgsqFvcF034CXl9zMy3TJE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HAduJ+b8;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499448; a=rsa-sha256;
	cv=none;
	b=jEJFJCTnchVbUApnYO/ofdS3Gdvs6RSqTzCQqJN8BS3BN0QlM3vv1J69ADrGwmFiYXrOJ6
	6bUA42Gze6frnSAvLo0mFg4IzHeYxbDR887Jd89a3OkKiXE/2H//hk5g2vxw4G7kf6vOVd
	+STNVpF0fxpt+MQnvHXdJoIYK0NZePM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF2674444F;
	Thu, 15 Jan 2026 17:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69144C19423;
	Thu, 15 Jan 2026 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499447;
	bh=Sci10TD3wPs0X/nu0ytauQ8Ud8Tj5YY+K+HKIyo6zgs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HAduJ+b8zSL3EqiL8BWAwWD8dLJQbeePf0bm85OdZfFLPWRA0jjDqsndpbY3aEeJm
	 bSZ2zePm5Ppt5CPtWSq8JfAuvTJdVTN0AalfbQr3+ZmEIVMgZLyre27TUJRL3q79RA
	 rNkOhzjaHEs8Tzs6m7a11HqVSOASVf1UDKrmf2BusNxr4F1ZrSa1AeV3FS1wualjMn
	 edCqfaB7swWMnieicMtljNq2srOk7m1vYCQ/WVyTx7lOJNCf5w6t5Jk73i+CIoGNhD
	 6u2o53je2uuUZ8idJMLxsPE8YuIFnNpQkINvbPOlSBG5OA+QWZzAYgsBIQtPf/0NuP
	 iaOi8AySDlRZQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:56 -0500
Subject: [PATCH 25/29] gfs2: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-25-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=670; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Sci10TD3wPs0X/nu0ytauQ8Ud8Tj5YY+K+HKIyo6zgs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShKEZOnS7UvOdedWpxM2vr6K3ZyrR8i984uP
 36Z/NOZVbSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSgAKCRAADmhBGVaC
 FUAzD/wO4B8LbZIbV1r9N1Hrd5ZJIB+G+pERUxRqQAMDSLuBtzpewxmtTH0hhbSp59SR4MkNgl/
 +2aCmWZWak0wchEfvWhMgfn8Qv3aoofYBRdM41RBXDiS73RXrNux5TRoeH/zHuixgf0wFmfed0i
 jxoj6camRvgEjWE4xs+S0WY2N+i4AAZpT+XPwydSIaDELoku8NFPtj9RKefKVNr0fJ94ul+dW49
 UTt+XNNx6KBm/QZz80fa/w26YhYVLBg6BNGkMity+VSgFJ7x4Ljaw6CqPe5iUSYu2G4wSh8xBbq
 LeNQpupNpNaQScnKKupFcAa/SbRco0dX4zI3o9g51BpGeptkq9hzkW5jBl2TWyOiUWS6/5tWrk8
 O5ziKdR4FKIeC7m2gShMwkA+AtGygxcZMfmt9JoTTJoxBbThAJ5sfZAQ5AqReLlaKBhZ9UxZiVM
 4sWy7ATcwjQoRMD5i/3CbBBtO2qkyWD7+mu06/fKwuoLq12mbWmihF5jaJjBgjsdC6Dlh53xyqB
 Mb1oGWtPvC4v1BTt1ckwG46Yj+uaKNZGbiHsptk0Kn2NWUUxjv1QmRgIuCsDYB1oUwnQbBDLV7G
 LVO7veomLBFg7//KAYREytEu6ObsV2lywlOTKdM5WmYw9LL4gj9OM8SPWkj69/NJPhRp0nQs6Lr
 iCHpJf6gr7VVjzg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: C24D6C0005
X-Stat-Signature: 15ghsr1b7w85x5jdgw4m8osqfys17tz1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768499448-606494
X-HE-Meta: U2FsdGVkX19Kci8ldVnYEQ+tPwG9GHUmYaykwi3MoMnLticidKNcNn1YfDmK8RgEumNcOC0NI0ppH0HZ1ELOh6qL17Ku89lcUQfdYgPHLGYDvcXcf1tur0kHzBWTP4JkGSF4Wxd5sVhFPxoAM4/UEGtcATF2x+26FUv426DvRxLFjxilt75uQtVHagoTf5WXBhRvf2nxVEGu+7cAnoNuTgq91YYn0iR4nq2Xrgj+ZY9IDImUDNb/XheeD48aZIDhxOTrkiAXldiYtMAoEXT995BQb8mfY2ax12JYWkQIR54QHOyQTTsbEtA8L0atNP70juLqrkDdOkVsoxjqJe62ggJ0BF4ZJ73cbPm0tPA7JAJFwVTVwHdfaEjakG7TnpAXiujxNuWdzb8S6t3Ryg5bq12wzmFVkzwOSo6Jq81lHPnjPD7C2hpFtp7ovOLFGKZ5asOXc/dAa/4CN/48s3pjepzGyjIJSvzHzrkf0UR3/3+V8P27xmf8D44r7VV3FVEsVgp9TOd02VAt2grqeF1qKpxmmYUm8NuD8ihIXR1Q1xX5ncOio6XRovsAO27IvQSFLlOgDfeb1fMq9EsIuvtGvUSELpVa+YTAav7REIqVtJzxbSMngRrvPVyLunOyJw5HxUI+l9CeMZHqTkL58HyTsPXv3eBruWCIFQAVEtJpfPSraySpMLkKaYlaSXNZUjbtm+lHWOxhajEFC3NGGFQI8vHsnT+CZfJIN+D3zHPhpB8qZo0M+NQQDqaHDNguMDuOcwhQ7vjtXfoK1MOr7+gc0+EHBEOPeRN/GMB+bIhOfqPuAG+dskYN0mfmOMxUJJiW2TF2pOMUzAOGPr+cyA8X1ZvnSJvPCN4lpvw51xbBUaRrjknMaHQgdvug6C9THmTJaRL+PMtTxhUjUt108seG6Tz600dLUh8UtuF6DsGroKD4DsPPfwRQVFdv73RFLcBMZ2ifkc3Zw8QQkxWD7p2
 NJDV/BDk
 t4hQu0pcfdIUTKUiskjeGwGsr/KEI3vD0kKsNu5TUpPSK4sYGnSxA050FRgqM3DBzwTLno4V6KMS+lFa4F0aZEjmklgqsEqGa7uNBi9ho01IC37vza9VD2nSJJIMYjJpkjHAAqJx6kkpO7Cg37qj3DOKfrkPELW0EyAlkm9ytERi4fxCg3Y2uj+dohs5SuqpAhmJVUSRfjeIxPCx0hZPu8nv4FWDzUweee0FCQvjD4QaiaDzCJfAn1s6JWz/8gc8f6nSo5zrWkjDEIMk+OsQwAwB3bR/oucx/ird9J52ujdtfMqJJgkNsXib6L8EoD5hNp8vRX+swlZ+/9MNA8Z6LK1HF23H8Rb0aVzd4lXj2kEOiyGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to gfs2 export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/gfs2/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index 3334c394ce9cbe26969809874a94e79bf068b11b..43fd2203b34fb0894d2b71e50278e5cd68216ce7 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -190,5 +190,6 @@ const struct export_operations gfs2_export_ops = {
 	.fh_to_parent = gfs2_fh_to_parent,
 	.get_name = gfs2_get_name,
 	.get_parent = gfs2_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 

-- 
2.52.0


