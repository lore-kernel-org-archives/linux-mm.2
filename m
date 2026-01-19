Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E5CDD29C43
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18366B027F; Mon, 19 Jan 2026 11:28:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5D06B0280; Mon, 19 Jan 2026 11:28:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DA046B0281; Mon, 19 Jan 2026 11:28:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3746B027F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F30C41A0190
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:05 +0000 (UTC)
X-FDA: 84349245330.03.D511A06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 265B6140007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GONKFU7S;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iN+TqZC4HgENZZKB8bo4zGbsDfjfItmjIIecQeBE1wg=;
	b=Ze4YDH2XREG86DyZmmTjHyfDOWJd/WyBHnP7rRUPH0HMqB4n4ryj2XKLtaArT8lOln32+P
	1d3+BYG16giyiheme6MZu4U68jz0TL/VsmUfLf6lkyli1FQ+rmQnxnHze1sFgO7OiEFyPl
	BVZSs7TgqUOf0fMYSzmwbYAGumJK6NQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GONKFU7S;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840084; a=rsa-sha256;
	cv=none;
	b=bQKlNWO4030QXQA4bd6cloPdYBFN51lfjv1Rk+nOlRRe/+074TcDY1C2CgG9q/+aVr1g/j
	gHeV7fiZF9pn1RL3/uiHX8niiSiuWvnzy8+Rsy2dcpvWQ+Gc8QROEDpnAkFL+ZeJ4uF2Je
	4xZzDq19rWIfF4GVl6S0wzoeNqmcV80=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AAAB44516;
	Mon, 19 Jan 2026 16:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F91C19423;
	Mon, 19 Jan 2026 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840083;
	bh=oaRkoY75Ujoq1dtI6aOA0DBBPdbXoxvn8BccRGOLbSc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GONKFU7SBdZJKpEx/+RyIiOJlKzpw3wad5XygHCQ6SMdbFsR8UygDcqhklmkj9xxa
	 DoT6QN0R/2LJRtNAltzb09X5JNXTy6dQB3iI+MgQwCPVrcE66h660Mpm0BQ4JG8Osi
	 1VuiKBmR84INye+Bmqe0VouGphLzEaWWZ/of0z2iH7Iwlv3+apcs+X8vO54dsCxOC+
	 5OqDr3+O5xIEGAiMqQqigHd9/dgExp99/46jSgaQEIyDO47+mlUpcDbop0KIt/3IDR
	 8hwKx6Cno5+vI3d6qqieguhx0KdAqoai2D7nD+ROJ71Ab9hESQgP9QPViDekXMPGb6
	 smRbLidWH1LeA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:23 -0500
Subject: [PATCH v2 06/31] erofs: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-6-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=749; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=oaRkoY75Ujoq1dtI6aOA0DBBPdbXoxvn8BccRGOLbSc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltaC973DLaT/MM7zKoBAyQm0Vj7HgbhB6Sm/
 nlnrklYVq6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bWgAKCRAADmhBGVaC
 FaenD/9BHrGQNmC+s2kvQNgwfP6EEm92NTII9R9h8Ix57czFYsowChpSlIRo0A9Xd4xRCRPGS7L
 HkWGT/3paJqWpLRClUV0PZMel7V5AFRHzEpZYdoc7G0DY1+7NxwSSWsWzFQsSDdiFd5s2qqfldB
 uus4+aXE5PIKQbdjwm7sTXnLZPP7wkWvDbFW15W34xpjLx0dIrUIEiPIyGYcefVklynKBB87PzK
 lVynQnQJPhSUu3hxEXGz4CD3K62WemAfpoXA8elC2tKDt10kqGNU9H+1zmLINg1EJ5bSg3j0rcy
 CcBd6gYBpqnogMMHL4705I2BFm7iVfExvhAZMDz976RnwglpW3txwmK2EFjUPjsIRfagBpSBpGK
 Rli9TAK78IR7UIc9VRFAsIXraY+cgSTnMCPbBl9RcHwZZrKIkr+9cP5A10JLBJRPIw74fXa6gkb
 UYw8P28UY2bXcWrDM/Ji1UKPCyWTG3k8rSLwFdR1dh+MJBLt5EwUbVsg5NNIQN+vLVsAhRyhd+r
 fj3nyTP5t8+DCC1N4v5p5uMqzJ8bCxXrtDQyn1CzDkA3vfg4QrMNApleEXDx1M8TID4oqKVuLMf
 hbo6t/RUnLwizZZh5g9JrEQZ+yXChodcWH0W05XM8ZA8MYIkZntqbIMaslGrsEAClHDBqWhRqV3
 YjtgGIDgn8onLmQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: ctqiotfou6udq3gxrzc4r1a1hjh64weq
X-Rspam-User: 
X-Rspamd-Queue-Id: 265B6140007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768840083-953652
X-HE-Meta: U2FsdGVkX18nb/3szzqNQgK5pg1IVRDN7t0dX4Tt88u+206fRsWMDrc0MdblPcqrzOBi+nxrCwmg9H+jTX1mb0hOAYl9jNk42q2Bi0E1wPNPhyZl5W3i9hf7JC2PD6/BbMgvqrfnV8Iq+Gy3EVUG1Nai8amhEAPoGx7bA3MtytwLsWzfGONdwvobufA0Pq1IDx/yc1OGVchUbH4C31rEhjHcOe0GaOi/6eZdAYgHd5aHmmU66D95WaQxXidDnlcmI3Rf/+V0ADkV25UZ2ez5W04r2sTsbAC8sIMjNgXloTWVPT0ebmC/IruDoUmcSwNzmO4Tn9unibO8MAoce1ulDdw5a4SMFw8bUQtPVf93dJOqBgFld55EptoeWuLrDl988Frh1XLqg2UMv0YktREPXl+B7Y9tO0tVxdP3niO1vtk6nvm3wyFxWNqiMrfDS2nKnIIfdeB4XAGcK4HuGITTNSx3pTKuYejhqRqxBdynBqEiYfoQV4SPQu7qCHkCkibLxuSHQo+8vL/23et/FVhgVCr8z3HS2TFZwfr41e8RZMSgl41oLodCRZqwrKiKdf/z2nW4iT3AMsA1L/1N8EI8MFaQlEKXKIFW2mH4FpgOHpEkDGNo3Rew5T69I8M99j1GNy+xbNsAKKYr+Q2GonpXaHIg4GSCy5CjQyXOgltAbB3pZbY9v3Ul/WXlSXKbIu/SY5Evm6OGV+L5X8Yj4wx/DQHIp0iTzQ6fVL5UEsfOiPtaL1FK9In9d6DQcmzYdMIzXobzwaeGOg6zG2X5RjapYVcKlEmNnwo6ALoU0ey7iCSFuFnNdDcl0VFoVhZVX/ZND47OQIMUGH2t1+LZQYeKCNN6pOcwo5mmXVNHzeycInxcujgxAWJgE5S5gHhSm1YvSqztA5zeD7fuus72PHgDDT/ERX3hDXlUk2S0ei78rwHV2tldYZMzYTxad5zmGwCQ1DodDAcUvfWVxZ4Cto/
 3D2rJIxm
 V/8bkRYUKJo6T8cvr/PepWJSHxLAtZSK4MqCChD+v4B61XIJFDZMDK/lHFqLBp/jfR688KNTv7Bp2zyqKp6U50YEkteTcz7hJMAks8BriPCyqXPCNVcigImzKxliqJJthE65J/bJLp/nmXH0P9YGiHE2lxHbOHgxpx+ZJ+Ec55S5jFCWlj/BJ3s+gYdopU0wzKDqTcw+GXo8+0vl9DE8oIDSr6cuCM2jUMTFRjWpSBA7TNXS9JcE6emfg8nTmou+yD0ADx1xbDKTsK/bx1GYHv8w6qWOPCNrqrivXcpqVx3seVBBdlaJZ5WE8M90rrC/QQA2DjpRG8pTrgCXN+RZzyfRfWsowRpnCvdUrK3rAGUMUbjbnqw9ntwF+X59UtowzxSsajYds/QtSm7Oee0Q99SCbDcg8sw+OvXYS6lOS7cZ7OkFgZhqqs80id6HvyVIIrmdJ6I70VjwFXdSiIcBMb+JeLv45f9KydKyG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to erofs export operations to
indicate that this filesystem can be exported via NFS.

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


