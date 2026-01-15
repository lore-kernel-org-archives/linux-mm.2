Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA75D46608
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742EE6B00CB; Thu, 15 Jan 2026 12:51:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA666B00CD; Thu, 15 Jan 2026 12:51:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606D76B00CE; Thu, 15 Jan 2026 12:51:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1106B00CB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:51:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09718C1CBE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:51:04 +0000 (UTC)
X-FDA: 84334939248.21.F8601EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2CF2E140007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:51:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4ocNczY;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuTkwBieDaBYfiVvkErhMkdIL4UCbBwNP1dX5h4YmOE=;
	b=KLjcII2H08kCHG2/m42xqL83A86w3ys5QzLDCCElB4zcPZVsFXYXjTQdgHGFCbw4qPuzKP
	4sRIq6CEBKsTKQygWmKLcrVwvoZn1PGMt6weB7jTa/Do2NPeh5/hyxCrBoWKaz6qPGsxQl
	0chBMzXDiDdQZqR69RvRLth6MQaoYbE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4ocNczY;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499462; a=rsa-sha256;
	cv=none;
	b=3mtWb0zp8EBloF0Jlu3FsJ5n5Fi7P+4SOWs8IOoi1n3yDcEWJJG5qoeKkXqR9SQ0PcEtGW
	XsiKB0gvw78B+h52osLuAEPN5g50HApgqtfH3qktITyNCLqNz7BGMMePZsfY4F3RFuWbIo
	3zK05mxzeFYGT799rqkg1gIi4HgnF3A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43ADB40ACC;
	Thu, 15 Jan 2026 17:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EBEC19422;
	Thu, 15 Jan 2026 17:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499461;
	bh=Zmo+do6HqZsZlZXVQKKSsmbSay6qOtqCBcv8Ip3ODxg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=I4ocNczYItMV4PCO+hbSpubXFxTOOvRwelQ5iEnGP+dxJfSBdkpaS8BgcPNjtQo+0
	 13X39dc3sCfjz7ZMXaPaDIvAVfQvYuD8rsBiUUssjnbn+CI2LeXh9lW609XNO9pJW4
	 RWosIVWkPRVb32nDlMhCWWWWcgwSn5dwcfPmFsSOyDc8tvb8bAksTdZfwJieQuT+2W
	 oaeOsUCW736bb7SBCyxDve76M1+gzPkiVc2w03g+s5JUvg1tzkRrCMNi0uG2DxZ8OG
	 VNeaPNWMgyHbFRSgKK2V3mYG38tOvn1l0448Syr6c4z7fJRlqPTqYQWDN8yvnUIlt/
	 GVi49NPoqT9NA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:58 -0500
Subject: [PATCH 27/29] fat: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-27-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=978; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Zmo+do6HqZsZlZXVQKKSsmbSay6qOtqCBcv8Ip3ODxg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShL32CLlH4882Enb521JW8XT+IGMo129fioR
 FwAWlYbPrGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSwAKCRAADmhBGVaC
 Fb/iD/sGhyoeoGw8wPKWzF+cMfVdCztiCASS47/vMz0oiXGV1gCEhqTG9CMIze18Tl9Pk0p+mvq
 lwQsBXayjGP3BD7Enz9ZTXdz7FGGhaKcQ7elWJ6NnDpTqPG61yQ3iPz2tocRnByahbNXFGRT01B
 bDDG4/0lRFn0I0s8tvRGH2GA25WUCRHpQX2sqaeq3HUDDN0AO+NiX35P8nmzTYTIn6azTBEJvqt
 i7m8+BV+qB1SQJsg0wSgcn28i3v+spVZ035ydFW1WchRNsDB/B3h6MvxtR5p7m7ILVITniiPuYv
 3AjUCweM/5jRt5ND1mLrbJrbHRve0L6jhiggdidkpMJ0bZlxgDKXuNiUntjwNb/KzO0f3RYobnK
 R01fL7cRrHYRgu+sda+g9CT+vNULB2SFSivuqhJur7e1BvLo4eO63/TJwnrBm0yi2XuP/C3szYC
 pOGS0FbFrydrLRpRqO/D1JVnhNWaZqp/mJGTH3DdHE09OyqAP6gDvZoCE+ARb0ivdfwKTCf22fv
 J6tbdw+dZNehkFAI9rOCQJvJeTc9RQCChrSxoR2jiz8ROuCCHx6Nh0Fth2yHiCQG0Yu4PgjOzPc
 cMpnCsz/LNIjdu+gfSKzdmcuPlCllwpeWoDOn3Ya0O2qhbEWoKGtgYAnca8FuqgEt3DtWrex0kB
 sG0+GJPuZUBNXZA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2CF2E140007
X-Stat-Signature: s8pbxmcz6p8q7xna8zibcia7hu7se6u6
X-HE-Tag: 1768499461-51794
X-HE-Meta: U2FsdGVkX18MkQ6Pq5/HTNb9ganyKMzXfvVDZzQR5k4aVE/0t0tS9px0aZ3aO6Fn0Kth/bmwZLePo2XVf7w82GWoQTLXi3VL+ibJlO+KLceCQm/cDbsEeZKqaz0QwvicQE2c2Fn4Bgoh6iQEsBOqrCI0s8/RDzuIdUvw/pLRAc5XSF68IARU6/LOvFqcsHVxOC7NsKwWaIU9o35jEZk/Qnql0rUFN5rl2zyr8HdyyZFS6qPun9EfiQojkZwDzheyMkwfJZu8pEsxWsU86IgXI4SVuhtVAu3gE1tHwgVqIu5m7WowruivvteaygAbQn0h3waa3s7St3Xzg/A41r9Xg4ii8x0Mh8N/k6V4GS4QiBzWNxo5X6+AObS52Cx3iIvh9eTTqIpPvDRF8GjINry4VMx4hOYLSa0Aa9+NZ7CXC873AccFiTa1LDVuwOYFa1YJNwMklT0wMDUBbCb3g1sdlZc4acO/iU0Pqph8zI/8bhs1RoYZxkcaKeMEjThWzZ4Z6GgQZu09zJH6bPPEnBAyFvCAWIU76FbOhKe3cur5stTDyuqMe7kN2pVLIYSTzaUJ8aEwtIMX/UOQcjC3s/Pkp0PNY6KcRhYEt0Ad6fpv4mZXwU6KvDhJVTp6u1ZrSp9Rulpi0YccgFfzhMUHzB0oa4PEwoxnoPJUCZ/Mg3nopMBHLPKaMu9sozmEJcc8xM9ObPaN2VzKz2oobickpi7bwSpwHOw4/PeGUhR3e2vxnkp6tlfEI6WbOEju/oAr8+opLtWEpAn3TOJQ8sG76UicA4lCk8MmvniT95p9YqQNH/Pbi6uugg4iBH2et5hDQfqeyLDdzRiiLY2BsFBGEqgQ2azP/4LEWQPedsaXOqmEmk8gR+btfEJ5NaycIcEaLq5euPY7N/0P9807jVKR27Md/ubc9w1ET7GMBwNtpiOdjZMlCaVkW4I2ILYQu6EyNqTWw7fFPqRDdxUVj1eH0pA
 XgSLxok8
 R0GVw0uCuZemOeMu1Tmz1C1PZv7GvYf8RzQ6+vu+wZxcVSWd1r4A5UTaatEIThgh6dGMKOfgPLzhrgAPd/gYc4MssgeyPEkXGLfjXKYbJB6mPjMV4lYb1yQD6A1lWCbQWyGcp8PKohnq7DYrvfaB4kVpHMwf30KAHlDJWw+kKBwoXiJKuRU4sk5wVn0sfDlnuPYXt+ttqTSRhxr7x5Z/lIB8MGE9QhKhktEfEt/kgmosSmEes8jYyYvxQpl0W0IrYzRaV+4+eyUWOwxv1NAOumGyKYbMijvnXjC6Z3eLcRnzrGNzgCVDtR7k1WCXx3wYiR9QswiCeuOl5EIfjfJm2Etx6FAmt1rlgy8Kr23pcJmUjVho=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to fat export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fat/nfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index 509eea96a457d41f63f04480da32aceae75a8a4a..f6a5c8c4f5e8a14e549b5aad6643d490f1d062b1 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -289,6 +289,7 @@ const struct export_operations fat_export_ops = {
 	.fh_to_dentry   = fat_fh_to_dentry,
 	.fh_to_parent   = fat_fh_to_parent,
 	.get_parent     = fat_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 const struct export_operations fat_export_ops_nostale = {
@@ -296,4 +297,5 @@ const struct export_operations fat_export_ops_nostale = {
 	.fh_to_dentry   = fat_fh_to_dentry_nostale,
 	.fh_to_parent   = fat_fh_to_parent_nostale,
 	.get_parent     = fat_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


