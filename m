Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6CA8D29C46
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367246B027A; Mon, 19 Jan 2026 11:27:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338496B027C; Mon, 19 Jan 2026 11:27:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7DD6B027D; Mon, 19 Jan 2026 11:27:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06BBA6B027A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:27:52 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C77C1B624B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:51 +0000 (UTC)
X-FDA: 84349244742.21.32516E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E2B6020011
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eSVUryJi;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840070; a=rsa-sha256;
	cv=none;
	b=OwmlqLZ9Zm+P59SUiVVkKyroV/YbouK8RohJPdyd4BgonHYY4N6R1JVQvdgG9YG66v9PZo
	Gs6FM74F9m+XsZwOGZHAfS/s9QLL+dSkxooCaYJ2OvwUs7JQwWQwwBSH9HIrE6kUx2jcPt
	fxTqciyqaqGOYxCVDcjmyd62MGy1bmc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eSVUryJi;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdUVfYLWR8cpz4FK1LdEeOsfAM8FP/V1NlpNec3IH6Q=;
	b=73sFO+Dq/WZC7cJ/F1hrQWiTth5zksIL5AO9gQOeuD/RY7hDnpw+LA0MR2Aqig9LPucw6z
	h87niXfuh5xrrn2SQNU+rZ5dolMsDvU2Uju9UMtz1vQ6h6/Juxf/fOgDVGp3rpsMdtA6Nj
	wajo85U3/LRyfB85PDlEp477OMJBGU0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07097429E5;
	Mon, 19 Jan 2026 16:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13C1C2BC86;
	Mon, 19 Jan 2026 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840068;
	bh=AjWutM65jGFPUYxo72jA+Ij0HC7LS8R/VDQO98k+B+U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eSVUryJiGgJALG2ypJ4Yjr568W28w/8A+eXZrbsI4+hMfQOAzJdZQRV9oe+T3lPi5
	 4mMm87GheTCUUW69mQQVVSKcxiZ4TOh5VdvYEjNSP49v96zd3u2tkg8lkt9b8MPF60
	 AVhGJPZm0T5VDPMCYbVqD1onR6BQ2XhtS7tCp6xAW8IKiFKx/n7v6WobsF/eTJtxjA
	 Nd2qg/+nfdwpq+DqIytb+gszW5PETsTfZ44XEt0Fp/CAMv8hCj9bv2Z1ZnVwuMRGLt
	 B+ukQbLNhB9K9qN6/51qLpBXKria1HuayrhCMAS5caVGwiDxOhazJhCpK9AMP+L1Zt
	 /GayDKKSdC88Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:21 -0500
Subject: [PATCH v2 04/31] ext4: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-4-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=780; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=AjWutM65jGFPUYxo72jA+Ij0HC7LS8R/VDQO98k+B+U=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltaIQXQCdDNYtxGH3/N2irOpG4/iK5HsTT1Z
 4iHLiLUl8KJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bWgAKCRAADmhBGVaC
 FbcrEACGpRl8GOPGkb17ykMrM5G/nRGznE7ZxuOH6ewcr6iKf0fOYadqPEBuyp34Xv2zArXNlNf
 459udNfZ2Blhwbz6pQWEwgTtXq3CYdske/+FYkdg++6FgJPzN7mBg76oRaCGCiL+xi4Q6Z+AaZD
 3K4u+njqrYntZw9j30opGiylxImbwjObkXvc/ZNM6L8pLOmEiGGT+ZEis4o1k97QZs3l8XOCmG6
 k+n+j7uS/3v/pHy3SWNTYBWq7OXzS4vn5YGu8nwBXymjuNdX/CijVLY2oV6Pgib5WS46Qvm6WqI
 OwvgpfxqmTcbN15+7Ypr7ATodGgOgeuroQo2DzlZ0JnZ4CVuSGBm6hkp7jnpGmq2q3Hs5TEREaI
 LA4cuyj0BVpV8rDNZAu1OKN+Vi4Ews3TcD5lIl/ZVyu69jsyh4ksqHFfhWmfkx37TnOivChumlO
 1DDGI4PZloQEDOExjfTtn+1xTF5ZPFgLMR69FJyDpexvcN+5uYEO277e+vMFfH9gDhJysYzFjOy
 jCxWdSNLbBll9mFbb3tbLoSV8e/ikoUzSk+vUn+ePpr6l/kwW9EC7NOdrEwECBcRqxpIjioa/Ea
 At0n0Ja2iF2ptFS/RPVXB5xcfDnEZveIInEcsypAva4ckDFGPFoT8TsrJLLrJsPvagzaaa4HHWK
 KsSCkMjtEOBxyZg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: myztcrjo6mzz59ddcswirnd369nojoed
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E2B6020011
X-Rspam-User: 
X-HE-Tag: 1768840069-444599
X-HE-Meta: U2FsdGVkX1/h/7dltFhslJKPExdraYw8vWlDm+G7aoJUA8bwgBH61ma5+vmT3pMdaCZIzdgOUF9cp9W6jOVnwSfWN0NuEyC3t3OlxYcrd8TUTYBEj4sLQWY1oKO87644fjyRudDaBxrCkzv2AULCUrNuev35AV2cT0gwoJT/8u7YPoQJb8MFI4i5vxR4HNz6rzMgAhVKlGjELlCsnJUWfz7U++4ASNdFVmGA/hqSHbh4wqgmAn7QhbTo/5Ho8R789L36XRUQKW0SNkyCt8aZVu8gs90IBVgKiT380o7YDBPUMms8KTwHiVro6lyVmchwKBgDZTaWv6vpBAmjhFd6bw2u2lolYmahEXxn5KoiZ+XOWOpEhDcERo4wAWHrnSCyXBcHfLAxukztzr//1zsVmpWnJKjHdDjlsYQDQ7tKVjdePTiTw/T7sxjZ0nUOlFHK5p9cMSUKZ7SK0I4N/tdPa1mHlOdPQlorOsurqFSNPq3UG03cq+7C2Aif8Wlzryma5JDke0gk61UXNVsIe8pdVmvjtbrplvNhG6x46tzC8AdPMtSEq20zp5ZtuF2X+B/BrotpS1V/bOe/z46bkdmp7I3xdosxt6DImO7d27mCkbrEagyBZ9uko5l5S/OFcs/NE9RJHW6hkbldF9NicMMTLGroxnlFJMydbVWpMBq63qsgFk0iNSxJhKvDVfjwpOJVpNLokBPWOGyhcRqBPg0hXKxn1d4GGV27NEy79YP5uD/1JaO48zyk8qalxAvHWkBcREV6CRJhNZzI46vEHPXlkimYVm1hQjiYp7Xn7ELjKBOFxKOXnAK4xjaysHpkjBMhS8mEIZu3x1ffx6GKa09N4Yj7mwacIiaearVBLRbEcp/bZxuPloeAHR7giN0eFOfd0rP8X7PsAksOxgaDAHA9YnuYyqIj/donQ/ss1ptD2KRDVB0t1HuGsPgaifp0QPaV9b9K2R3BN9T425h321o
 2ARufzoe
 eNkCoMqvot/4MAM9nmC5oTWH/5RopTkUnY8tdjpRtwHwKx7pd2Lo5iRMX6/SJiVcYBsplop8THInoOYRKuvVfwWj3wDDJrSxO6bIziqiiOOrUAo7xgRRQympzjn6NY4IbEijZZsUegiDplTKAV5mj11BWRq3jM3Xy7AE8IvYLivpqoGz/0iTLERjbhmOPGcfa4mi2oGjv62W3Wqp47BCt4HW3AWP4Rj3io3BVXsNbD2BqDtd8CXrZBLR/T0+iYwFn5ek23FwNkmBOjcknH480G0quo7RssLfNh1g6KFZynIMkNzvCC5yynxKEWEWAfdj6SgY9erdzGvz1ZlF6/Et9gzpLnH8S8OAQfjh1BzpV1q0a6yCEMGCz2Ri8mHb6YH/jg9xgRYUIXX7rBxDjfhy8MtkCKXNWqlPAq+MaGh5MoipPA4JOmdg4OGDr61/zU2RdcokfzhMCdgs5vuW0uJnBTSHTPI345rF9RjQj7n864EEyscW6qVgklOfHMMUY2G6RkqLQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ext4 export operations to indicate
that this filesystem can be exported via NFS.

Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Theodore Ts'o <tytso@mit.edu>
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


