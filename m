Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41531D46608
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53B26B009F; Thu, 15 Jan 2026 12:48:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14BB6B00A1; Thu, 15 Jan 2026 12:48:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920696B00A2; Thu, 15 Jan 2026 12:48:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 818526B009F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:48:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49BE61AE478
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:38 +0000 (UTC)
X-FDA: 84334933116.24.9509CE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7869FC0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=me7Bh6Oz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499316; a=rsa-sha256;
	cv=none;
	b=y45lgthl9lCO+p3fLwHakagrTStsT0puJkp4mpihgsg77vnoBK8lqxWTRXN9NHTymT+i41
	0gP8zLqpHYru6SfEhfJTaeYiJ40ttrbXEY+Ii+rN5Xb0SEB/iqPljaxqWPE5UQnKVpDwAa
	3cYKibX7irjHR9EbAVcqi89g5XOaPys=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=me7Bh6Oz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZXvJblK86JOSgVSiEF1V/fCDolsBEqBgV0T8jJ7cPw=;
	b=2jjzw/AIXTt0IUU2CEbB1i1909MdGaVLU5Ut8JAYqSdBkHHiW2SfFZInc9DVUQJc9JOi2P
	9sVuNaRxSA7wHw7nsEZriLsTkgTejYSiTUQaOflNWYVFA8hzxkthMd/W183jSG1Z5Fyno9
	GhyfhG24eioi68vdiMp4/ttaz65jp2s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75BD341897;
	Thu, 15 Jan 2026 17:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BA3C116D0;
	Thu, 15 Jan 2026 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499315;
	bh=fC2wTmyLrxw3hMRoJZcWwwZeJ07trZnOuWc2J0sqBYo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=me7Bh6Oz8yi3rtCvKE31NfEQV3586FDcB9subrRTMuet/g+LjUJ2eN0apKlzh3EHy
	 EZA5I8Cald4Pe5R7q40z0pYJ+IrgezPmzSAotRFzHaHcrQ/RdU/9zaOrAJWfq/d+gp
	 mvoRSdcMbzlJh3Ahip8TzNw4ZxybZ7JtzPKseJsi6FzB6BjxrHP8FHrjKtLFuf87Zv
	 Oxk3GdN3TnzFdcGrmP/M4IUNRiAQCbSXEmduK4aEsRDfNgoES95KukLgmQ7s0Qm/y+
	 GmmmovOi6oy5f6J55yNmRYBZmRkoRTn3DxKDX83Mu5yoFwszUj9Wep3F83P1yJbeR0
	 320NVCxUCVrgA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:36 -0500
Subject: [PATCH 05/29] erofs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-5-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=749; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=fC2wTmyLrxw3hMRoJZcWwwZeJ07trZnOuWc2J0sqBYo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShF9i2GSaSPlHSIuC7Yfec4kziAdHH6jdF9n
 v8rm53zuoCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRQAKCRAADmhBGVaC
 FcTGD/wISjKyKX0w/AhoM44k1zgySDfZixa6IbiGISyVcL25s2rWSy0ZGfZJayD/EPpD4m0zcui
 9Bgbta1ta+miyPZ9wOc4v+48+fiNjNvYr47ar/X0f0sQvet+DpTwskwHfwdQppxLgVjKVuMVdNy
 gck+0tCrIxsD4Oup77mdZf2ouvL7KYYRz32YuszzQr48OJ/qjKDCh+JnXb5KnsvwhuQim0CeRN8
 URkz7aAqGpXu/VOl1oUZ22AKHlAWuSrvTvkcTpncPKLu90Oca6NsDTIX/ON3orkHG4rOdzAGc/9
 RQqt9GmbiUBUdhpF5o1OL90v/ZnZPiG2su5SGPIaGIf5DQWHvpStMhLsuEPeCU3sWgdmjPqYwLC
 iXyRAONUm2KR+WThIgxBjqKyE34WHKpTr8RPwywaJZzzGZZPbKDj6psf6+b1i63wqY40oMyE1Ns
 hEZbql0rYeMGFxCjcVNDxzS3kqNDqGCfS+pC2ECWoCeEditYYF4yz/TOqROEqGtnToNPVyznKeY
 7c12ScEV9IdfwSl9r8CDZxKNpoWPnO4Pl/Rv769XSw/XhUxOLkUF1VqRwTv8Hy/Kz91OuWZ9X4Z
 Mez2MQAmmUG7Xr5Ozdu+dpiMok2IcUzuuuqbWxY+Qr0miQd21xwY3y60kPYiqSZKJ91tJpwnlhX
 ZAXGE9C+nE6tINQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7869FC0008
X-Stat-Signature: mtjfdjitgmjc9nyf7awha9ga7973j31j
X-Rspam-User: 
X-HE-Tag: 1768499316-65801
X-HE-Meta: U2FsdGVkX1/qHboGXag4TCoh3hbFx6Myzavp5rkdQ6zq+MiSIpomrUOzYmaQzJ06DEPE+zugBV505dORhgAuk10vEMFdWATw2mg7k+FxDRuLT07PSbWJ9gnljtPcmJ6mQv7EGnOsKYAANo07BnXN89Z8/LfiPBGW+dGQmt2s++ETF2SqNVWuV5W0/Zo12ZDiYLHJghXth2VuMugXV4mJKyAYX9IiBQXBOidrbAKwNfzAfrkenCLzu2VS3APlgxbtJegUfCuTGGBqUlmCYWCqjsSPnGG8gV0ZO1AvjM0BV9DLBJQgnc49RTniVqvl2XbGWNQIEs3Mu1A1XlduWo5O/FOQB4f06JQJGjnr7Y6ZdDcVheELvzQQjceFe2pMC969m11RHU6Tza6JZPSk5mAuav6q6W3XAmtV3YbXl4N1LLpksS3ibFpyhs3lw/VTv3fWk/8cktHn1mXxG8iOrAEUi2kSRsktYtE8lDVLUyqzccLrpTqbp4zJ8zWpj2Bh9/byryfuzwGTnTpLxbLza0pEjZ0usrT3Uka5mnt90uMyawnBWtHEEUoVEnswwM50G4XzDm4UJm99a2cpaj7VopgGz3Bh/YYcUStzWGrOVBoK1jlzFO6yOthGO3mM6kcrq7njTS3CL+dLnfMVefLTdPJG4oqc5AmIMP+9+CPaYnKlDPTQ1CkK61W29Sv9kW4so5cYnHrV7G6tmlJpmhusLVnjJgEJ9dEL8f9+aRt5cuxatE6V1Pmqa9eFmKjHzcrRD/+aJmTFllUgfG0/ZyPVPP9Sz7p3U1+76Yog1H+4bsPypIqm6FHqcHlU/3Gddtnguo6j6lJ5qH8QfP0x9LHQpNwO/N+3d//JqN6ke4nrCycdy+WT66qVpprp5aRiVLYO3JofKTtC4T+KBVjRUfKho4CUCtCGMar/PPGjRgG+rTVlkiXtgMDjpaXYagtjjmNxtZpbO2zLeCumCtCrhp6xkde
 x/0X/NuF
 7m3M1zUlA76yGpByAJuS5+pe4Bhru9kK0+CTDGR4Kqw0ntsc+8R/WWbWYjfESxt5tElHkrfZyk5Tt4FBWhqaYvNrQZ8IfHRPAjt3fdGK8xsSs7AwfzSpImhZbmctxERdi1QuXsud3RLXrryrCaOqhk/v67FlzhcaCJ7AZ6WwHcpzI9H91w3P2ieo1NeF35B00Yseb+fQ3xjnHYGdKiorW7X8jdsLK7+i/Ygd5Dzx5qV2ePrgbE7dF/cpt52AfOTJ7IvnRNomXC7nxZg5c1grCGajL7bEmenqqCJOcqyuc92P4iA6hsJBI0GSZwqvXgz/Hz1km+lSF7NrZDZtJyLR5gYdv+bzkEdFmngpbe3GMJQiZw3M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to erofs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/erofs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 5136cda5972a986dece863290d20ab103791cb98..7b43ad2dd3eada8c132b26f851394492dfe4bfe3 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -608,6 +608,7 @@ static const struct export_operations erofs_export_ops = {
 	.fh_to_dentry = erofs_fh_to_dentry,
 	.fh_to_parent = erofs_fh_to_parent,
 	.get_parent = erofs_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 static void erofs_set_sysfs_name(struct super_block *sb)

-- 
2.52.0


