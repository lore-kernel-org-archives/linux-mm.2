Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B19A0D29C41
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207A56B0288; Mon, 19 Jan 2026 11:29:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8C56B028A; Mon, 19 Jan 2026 11:29:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7BF6B028B; Mon, 19 Jan 2026 11:29:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEC796B0288
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:29:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6C20B696C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:02 +0000 (UTC)
X-FDA: 84349247724.08.02B4905
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id F0F5C8000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GbZu6FSO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840141; a=rsa-sha256;
	cv=none;
	b=2d2ahh3fukDUD+uXkxoWAoWRfDGhXVPGIUOCuMLDa11v5EhtwkzZu6lEisxLZUYPgVvjS+
	+rlrrZLBrlWqLiiq8I4a2JESwK9g7G+k0aJMbD9F8QC0/LNAG847WGNnvLR/NfLfLoylFx
	nKjITQZp1yJhD0cNqa2k5XNZwq7yHC8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GbZu6FSO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYWURcqMUxp9DlYRnvKSwe7IEW9L017mImGJDNWH7a4=;
	b=JC7JRjzTjT3Up5rpUM3kc+4YnQImX0pn7MCzn6Z6SDB6b8OohDj63tv5na7CdskbXAiCiD
	uqiCCOlqp1MDDJrzJ/DMxYQ1OSISSw+hAlIhbGyFTcXDnLSBNqczJllf2SIdlQ96tzAxPO
	O8pJDAkz4rLi+oUKJVd/SC6NxkVgGpM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 65B9660161;
	Mon, 19 Jan 2026 16:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF63C2BC9E;
	Mon, 19 Jan 2026 16:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840140;
	bh=eujLaXiTUgNyjxHmQdWX3y0IvgSLWTxRgF6WqDofLiM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GbZu6FSOp9WcyI754uBOhgiC+hjbrXb3PEhujTocCOkmPvnvAp4bCQ51iP9+gkdW8
	 B4a0JL+gvg9zK2migKuOwwdvrS3+/frWzLC3e9RUxOa57kczpOLuGHvF+9UoQO+7GH
	 CS98+DwnQ29MfmcJDLTXTBDRw9pFlkHHKAeT6cQ2crbJry9uJuena0SneoU3gr+yWI
	 qE9fhRj3q5X1Z+wQYlsf0PHhw7hNi2jqRuQMj9GiIBD4pd0zhhzpuoKfcs8m6hwxUx
	 a16UuQnjs7UT6hSVV5xwRLY1Y7ho2OOQUOkxAhejP7/sILT14iJoJ7t8DA1CNNdnx+
	 U9nZaR2wlvxjQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:31 -0500
Subject: [PATCH v2 14/31] affs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-14-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=733; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=eujLaXiTUgNyjxHmQdWX3y0IvgSLWTxRgF6WqDofLiM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltcWN14PEo1Nujn8uyUCyf+Ml83lXSAsDawe
 D9CEC+RNLaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXAAKCRAADmhBGVaC
 FTJtD/9D134+/6m7eqi2XFu1Ldt3x6QxfDXalFHVzNVlyX155Qtn9qZi4UXAEKjVe2ODkcTVGpO
 11UPI11wgMKn6loI94fVibr9SKlYAahySdpRnTFj/gaHvNSE+0XntrP+Wr3YvA8n9z0qPcqDSTA
 UvgajRyM61rTAYFsGEgtMaq0cRaMlLr3lpA09Pj1xLSFMI4kNUW4+WhSca7PAth/rIjGubVUIrg
 o3LTy8kWsW+ssnz/G3HXpjXU0sa8z5kUrFymZvow2N/5DOHQoOOPMz2tYopAhK+wA0WMiHlPYEP
 V7QKF5XNckiHhNp0sVvNHLOWjppYh3i0G7B5YINXh/Gdt4IcBYvJCzqXNcdqzXAxycgZ/J+YMqw
 5NJw7rXYzFjI997ZGd1XI7m6Y6qSX/cpBEHF+RNlLEYs24Bl6WF2B/EHAJdG/41L4XVIYd2XJIb
 00nVd6iFRkEAPdwVvfHBaBhF5wJfx7QlX3ei/4zp/5Lx0u31MQzjOsirPhW0DNwTtPE0y6enzFg
 Oj/GgrylYOHwkrdl3HHAXJpgMynZVpMDPuVtBuMeKYUDE0ZyXgLSPE8/dd0B5zNW77fNX0kNFET
 gLNm9ggSsGI4QKY1GLxYdtW6d0d6wArslnUBsgla+v/Z4YfNSBPrvAKrXiRE3zatrUAolw2mThU
 euoEInqbxcQA6UQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: F0F5C8000D
X-Rspamd-Server: rspam06
X-Stat-Signature: zr8my46n339qhuybk3b8ra9m3i496i7s
X-Rspam-User: 
X-HE-Tag: 1768840140-218820
X-HE-Meta: U2FsdGVkX18zCtykTiiK7g32yqIjWd4FbmJBMxALPoUow+2ufUWIHEzsHNPDzf/W8yq2Un8oPTWhocdatbm9QIDnTwEi62UKPCHIkJ7f32mpllUSmurvWH6mxmO0sgoyXn5ulzHSzv0QgWD31nz0IME6kxTQUyWgcFZhoTra+rZBA42JXaj2opLhDHwznBKkd+F0tMtJwJnf2encmvr+aoEPL7Xl29DL2e5u8xyCqco54jO0vcJI+nTm0wIZX0Mo64Y8mfBJLmMoSlCnkPyHM+XqX+3ENisXUuS99ebIGaW/Un6P5kxAVuBsT1FRDopcC2ljmsenwy2PcHyG0AJNjw8gjTF1oiWpLZevXjsOwIO1s6QAzaIfWnIOZKCGsHe8xHN0ylcu+3UX8I/KQKGqqJOh/yNCof+kP1b9Y/E+oCvk+45oF1CbiS8rzumLfs5d9lnvyrizO4XJzQ4ki2GOTUdnnzA9drBLfegO+yrEr9iN+wtOGv5PKniUwIeTd7NNfJ0BTu4FKgye2NngNMt0YYCREHFcqQuKgPVJZ+HRIfyeD1rI6sKmMPNdWpbDRajGOL7lusIgB5jdQqejsmhtKFmeW1X2Quk6TuHfF0hQA4xdMx32B7jzwkvD67N/Ir3rhnBVICTKmRAClWKuKgl468aUg7Tl7i1cz+msefVBncVry0q+hZ+UiFq3TQbd+/goOM3iO7uYOROCS6WYK8JONVK5goSIVQulN5LsWL96eBByllqFYYWHrGvQiI3fw1QtZfiStDF5iM+COH0ntLZzFS1QG2O6JibAYnL9aZOXdVF1cmvz8eEimBncnZI5TAhRBD/lrOqMkr11Ey3/H5BRK5bRh0sqDLtyhbHNaSKFPe0k2WgUFgr9xYIYTLXkof5OlOgWW4UEg/OMR1PEpqfRxCKzRss0Gf9d2zSDPjDZRZKvnWk1qEocxjvDZ5cCfnF39IN24oGF2LkmfRluLds
 58V9it7s
 r+v71T6KHJ4wGIHFyKHi4SOLmVrG+2M4zXkp0rV6MuFAxN79BsS8ijQpJAKvwg6QvcaFQbeUH/p59oRHrVKcULwhZXxNgTMfoaE/U87B1Ov6GX28lSII1+y9EiyulrPurHF2QWBPiW2d0lp+ZEvfRAzjE47jbe8wW2M16GRxKYWz4xZxfyvbYtXEkoZKrIfuMUtMyFL9Ayfvpcj2Ndo8Fb8zmrFa9vU29i17GuoKGNNUKEISZFmN9WhpcHbHqe23ZvlXMGqrWRgueFKONaNFebnTr7JqOwd6/qxIba/Iln9NFZxtQDtR7l5DLXB5B/2gBEsbXTTv1dHyyjBG3JD08I1MBeD/862xg0/1A21JNrZMxzn8/RztSMotnW5WJkyYT7RwCwv3tnVmIBO46NDRkEbbtZWHTKSdrFeXcnajCIy5S6OwEfQjzOJvFmi5fbJ7no3jy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to affs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/affs/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index f883be50db122d3b09f0ae4d24618bd49b55186b..edea4d868b5131fa69912655879231912ceff168 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -569,6 +569,7 @@ const struct export_operations affs_export_ops = {
 	.fh_to_dentry = affs_fh_to_dentry,
 	.fh_to_parent = affs_fh_to_parent,
 	.get_parent = affs_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 const struct dentry_operations affs_dentry_operations = {

-- 
2.52.0


