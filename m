Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88865D46609
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3F76B00C9; Thu, 15 Jan 2026 12:50:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A916B00CB; Thu, 15 Jan 2026 12:50:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0E06B00CC; Thu, 15 Jan 2026 12:50:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C68C26B00C9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:50:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83B048B9E1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:57 +0000 (UTC)
X-FDA: 84334938954.04.5A0236A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 84B11120005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SEhj0jPg;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CeTtLAo0l1hEDPc9wFcr98gFU2TUKuU91rfiKP4k4aM=;
	b=n7hst8pTd9ABx8IDkEMPgYI6JBVeJgdW8//uvBBkIPzh5RIYzRp7B2gCj516gPTHscs96Z
	J5fQPzJ+tuhk+afxpqmNJRSPYv4/B0amu1V9civNP8viTv/n8ESGDfA0vCfs6MeLOnGfMb
	IiSYt6qbuTYOYo8/EmtpIZpFd5fKXRU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SEhj0jPg;
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499455; a=rsa-sha256;
	cv=none;
	b=744jVdZ8Sn9LnuTYiMRbW0Fj045RNNtWTLDjJFErJzG+3uHPD9dixD2OgXsAplqUajyZtt
	IrKYPepNc7xoRLNIRIOZZP83cMlMahw/2+Y6R4hV7vtHa/YlP8Wq5TmExIsIPTWlQLbzCC
	DsauLdSHX+mMreHKx8jttf9Do5V3wQE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6235403BD;
	Thu, 15 Jan 2026 17:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088E6C16AAE;
	Thu, 15 Jan 2026 17:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499454;
	bh=B3iB8PdtmJXVVjQl2iu1kT0lUCYC1JH1znDIT/qACXY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SEhj0jPg2LUbe6QdHiGaIMEcuXoET7yHO1nhDGM0eDszM0SkzMGpCOh4tVBq0wYyL
	 +R5LwCPJYRhA7AK+gW9/IbFUgM08yvctd7ijqfNZ8mQJaevD1wNAREr4FmZNj5n8xf
	 GOV5UKGAyGz6u8AbcPgrO7zJ66fc6qmzlj5cvbY15wa96qI/BbwvUh3PKlSbQh5uSX
	 CNNtI5BNm5gIP5lr/r+jxSQe6GCtwSrgG1o9W80MyO7XwXb0PCpDUV01pQuwqEtIlD
	 rYn5vWgythfAwpUx9EH2EXuifp6whNQDS6ojHLe4tCfa3mdIv5wzqNOWWc7rfo6Wqi
	 uqezwqjpSq/yQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:57 -0500
Subject: [PATCH 26/29] fuse: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-26-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1109; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=B3iB8PdtmJXVVjQl2iu1kT0lUCYC1JH1znDIT/qACXY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShKjlDTIgJ1oIUxVMm6eLiW1LORyjHFx57KE
 4mWRFnefO2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSgAKCRAADmhBGVaC
 FdvZD/96keRaeqAV/wN3y9Y3bEH/SWZiHa7J2LGHoRLFPk7NkJXw6qUjQ+fQke+zYjm5T8ipf0/
 j6OallhpMjyf76MSGKNtwDM12QPde6749iLhlkzuuiNUiBKcUPf1LB88v2dcrFx7PIrj+UVP27N
 sUNHGdsfD8Mo8NhMj4P4Ur5nrA/R31o39qaYZiHwZ+uv1oMfSYug1mGG5w/HaKvuZzyQWfmlJ00
 QzVRyhynYHefKf3BpO82gyCZ8I7cIIVYrTPM+kxTn9dYmIAJ5l2RY47dTWAWdeWutD0LjZ+crAp
 lDqJc7FuApQgNY2lTf6syc5cEOBAGZbTHhjuGcrfd94N+YvlpW2gHzNaHL+U6NzjA0SYlVgXdJt
 mA6emOY0KnTMNYYPWB58iMZtclcVe1bLiT6ebciSo6h9JK+QgrDInMpWTCaukHrjrXOu9ee1acQ
 OcyyLL7ZWDCXYd1zZMBqsv3sYlWJ9VMlyaJxIn9z3wl2dGnIBe+hW1AJpSRJvtKewKQkAMn7zWQ
 tmM4xAj+ZaBtdPGgPttvVBKKtnwxo/15PysDrxEm8RCLyrPCmV2/T8kMQeUgznoKgFjlS25W4/E
 eJvv4uMPQ/7FIHHyKEG2s54VKAbN9dDeqzkpIfBnZL8eiE9e3xOAUhS5xyNkgdFmxAgqVhQO61T
 Tc9M7AyQCooZV1A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 84B11120005
X-Stat-Signature: ojnmq3sjpikbptqcaxnbi9wm9mkhz8hw
X-HE-Tag: 1768499455-239802
X-HE-Meta: U2FsdGVkX19jO0BHrO/WYKOFIKlHbWEK9Ysi/I+xxIM8ZuWjE/UF4VIwL4BiA1gZIfKIwA4C0SEraP92OftpqYKb8VdgKFAm48MbZ+QbL0fZrPZiqy2TKhgK9k9GyT1i0ilNi1xP1bE7FO68f4V2CAAZczbubl21idwqqkfJGSBDJkQtUiV/lUXDR2b9L0W9qDLoCZTouFFo9xOn+68TYcBIngKvmj6NaK7/0raWZ55C1850OdrPmH5x0B/v7Fy9uN/JPrENOUzq+DmWmG65xyfJakOYlkW5v/CWQNk3n+dYaWN5l0aGfJoDbpuJbI5sw4kE912cWE+GxpHoND1joy7t2s5NiREPc+vshgMAb/iJ6af1QWIAB9MlUoCBIAM8XFL3gC1+0iql8i9DnnLYCH68DbvodqEhSiV2eDlnq9kABUHsxbKRvEqf8oOn68AA+l/CyRHF32Qo+/l4bkZjg9JBrd/+r0q7bBoFY7GbvQDVEIehiW4Ov3I6EGbzVaaAi9VRODrbzAR8clabnxyU3xMrsLisii/RXPMUfFAJhi560b9egrf1h92619Hh6xUqQMF8NWdWLDRZ94YvERIZG059fxb1GkD1tHfCnfXBHGIoXBOv57RQDg/d8zvzo8KBk7te5PUxqhJ9NvHAV2CjNm8lfYKJm5B9XjHafUcHZO3vqeu5SzqfBTR/Eql/wsikZtqrKA1CwGenUrDsrdej6+WIA68xjPhsM/QjoDRQNw4q41W4q6vTCf5jdLBn+w96f4GOgGj+aw4jO6aMqxNPFwJQskXQG4Aez23LzssbnCwDNyMPLDfaWoncftPVNPxqMaG/lWtb2C5hVK98wp2ad9cUsPynoNsh4+sIWi0gDYleFkdkiTpnG4x2ZBndaUYL+up9U8QpBKBuZD+LZPGb+qC3Lg/rHEUsQT8n7Av4t2pzzP0eFEeF8qa0pjV6cSyl30nLGT124Pi5HUk8XPW
 5VohGZNX
 Hs103b4mGdoSzMxw56OILRY4g5jZsI+HOKpl8XsWCP73ngHLlTy6YJ6pBrXxmTDn2xKw6SSxJVfx8sxaeWHpfag6GqpNVFBxaLVbUxdQsIVx2jOTJmkAaRzBRJdRRRtPJvgtrbsvfx814lK8Kyo3mYuIrMp4fGgszLewC3nYt5Lz/6TApQYJPwGMY0BsoKpjwwsmCBFVb+VmN6sj+QOdIwiySU9lAOLGa34Rjzkoq84IcFdUonSJqsWTaeVj0er3n9wsgGEF/aBDDfKrPpqRLKlBU1JHDaEP3dzzT6uPNWLviRkOQhM+/4fsyLdp08QzNbFhY48QAHQgp/ZMjHxMxEscrhyhHQRKxbxDYLKdt9+CSNrw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to fuse export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fuse/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 819e50d666224a6201cfc7f450e0bd37bfe32810..1652a98db639fd75e8201b681a29c68b4eab093c 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1208,6 +1208,7 @@ static struct dentry *fuse_get_parent(struct dentry *child)
 /* only for fid encoding; no support for file handle */
 static const struct export_operations fuse_export_fid_operations = {
 	.encode_fh	= fuse_encode_fh,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 static const struct export_operations fuse_export_operations = {
@@ -1215,6 +1216,7 @@ static const struct export_operations fuse_export_operations = {
 	.fh_to_parent	= fuse_fh_to_parent,
 	.encode_fh	= fuse_encode_fh,
 	.get_parent	= fuse_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 static const struct super_operations fuse_super_operations = {

-- 
2.52.0


