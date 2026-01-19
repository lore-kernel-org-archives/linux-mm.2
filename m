Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DAE8D29C43
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66F2D6B0280; Mon, 19 Jan 2026 11:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61FD26B0282; Mon, 19 Jan 2026 11:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4518B6B0283; Mon, 19 Jan 2026 11:28:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2595C6B0280
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE38988EEA
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:12 +0000 (UTC)
X-FDA: 84349245624.27.5D168B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2697280009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9zcCED3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840091; a=rsa-sha256;
	cv=none;
	b=8WqOwAwe5IK/pEap7ez7o/zjgI69G6kRHxa5BLgK/o95Vvd0NevmheguMEKqueG8Gnhc7g
	FgXAwHgGE+HFR/6QBZc0LAHmT8rU4eF26UJiSR4GFi1xFp3TgzgPs+NYHuDmElXlAWqpRQ
	FnMJu0IWWk2oz0xMFDhxApSepVGSRMs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9zcCED3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XS0lvYRK5tWOgGjuWzlfHcgoUbS7YsM+rIkpLdRDJDw=;
	b=mwI64wBdVSBteXzz2KyPoajSiTE/94OvxJJ2ZvjL6CQGU6S2I6sIPGCu3lCFA/RqrAGTc9
	7HjB14SUeg2ZhLzXNGDphb3fD3++iiYQJR0CKOtFmXzEnChE3NGPnwnKKH+GCbIQFMjYuP
	0EiMCnRfPZp2JOOWlzP5cAJWWUufEOA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8015C60166;
	Mon, 19 Jan 2026 16:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551D3C19425;
	Mon, 19 Jan 2026 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840090;
	bh=W9kQ6JHsR2ZsjaldNXy1YA0G8roGFhpDKq8DlYvicUo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=k9zcCED3o0/zqDgXmf2Q29FEmNe3cLGAIKoBAvYNMV8yVVR+xpRPHDYmlXWFGrnPp
	 Xx8/4EkYgptjzM971GICg1v/7nSo8lyXbmGysY/ppY1+a4qX7wV9ypwQJ2uWqg5LEm
	 cV83OdEv8Jp8OLq1aq6gX5MPN2eOk5xplswnzRUpFeNSWIT4qmX3TI1tc+qXj4JLcr
	 fjj3xqF+oqoV9Ln9g2ciCb5qev9Q/y16ClfIz4i9GI4/h+i7ycQVfSESjakgis1rh3
	 2FaY5UPnl5tDG2DAe7ozeG/Qngu2FuhMnApy6+GzCJWoy4mttWTWg1+SNSutN7NzR9
	 IGlgvI0Hia08Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:24 -0500
Subject: [PATCH v2 07/31] efs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-7-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=711; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=W9kQ6JHsR2ZsjaldNXy1YA0G8roGFhpDKq8DlYvicUo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltaZVAYq9Bm19m+xxevu0EfeM6niqB4vzX2k
 PN+lbVltbWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bWgAKCRAADmhBGVaC
 FRZND/9GjhlnwziGFOfsbRHGWo6zw7qbjpXy33iIwDWofSDCjLiJVF8ZX53k/UlnjSwhrroC1t6
 3vjiDj0l8skSfM1SFzZpPhHCtMaEGoUB8pYDTihSuJHmFOj3JRV//TN1u8bG31GROegUk5f7XlW
 WOEqj3oBumf52k6p18TPcdNuyTCj+4h8TL6x/PM5JDZ+spSGyCYhRxf3VDgdQdNnbvgWW1E1IxD
 NEglh0jOkYTxbZaeJLyXG5/8EBYcwKPBW04UGQgyTO00A+tQo/IKMnoV4kcqpFN+DeiQcHCtzsC
 ryLKRPu9fNDYOEbDBUe3jLs0uZ7i5hPCI8aODvddmdhPIFdL1QlAu2oKOljOxFSNcPB3BqxZEJ+
 XQk9XZyLQSBU755m7W2Z91Y8sd1vm4rkC/knWxgxBLaTEac3uzfoGM6+ioTgSJxB7ibmC6vL0w5
 TGsRj9ezeMGibVFAigZfqKCgFLO4b2RpFK0lEeHCKPsMEFJ7daFLLgNqFlsbci7ZRBcy1/RxkzQ
 GIns2Hr+8m7KzlQLCRsnendzFHsMDYR7dZ0tPvMSdYFBW/fvowAtotdeCC65Sv9/Cwqa7Yh4B3j
 Rzitnk0XLSvRdr314BPJvQR57SrQYugBXJ4/y89+z01QYCauByVGCX68ci65QG64qIWHXrS1Rfg
 L2/R4X6Pt5t0QZg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: xxizxkbm1roub7bh5t9sw5bgj91a8tbd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2697280009
X-HE-Tag: 1768840090-837498
X-HE-Meta: U2FsdGVkX1+iorY3fyMRz+8kkVf4ImQElU+aGE89SuVGZF+LaVYXMw2nlmxBMEK9chwYt3WspH/aoNhWxzYvU0mBnmbWcVk++qsCw8WMuvTCnWeTV5nYQ3Ps7K4u455gkNGI7L0r9Kl81OlR7+UtWoM0pFP7LOWjRf/mkUETpQoanUR1jjUFDU42vx6ntCbKNOtM1WdeCb5RCdHU7r5Hoa0VFO+XDjpkOBjDljfg1ldl59UXW5NIbFe18nR/WvjuZrjZINCBkFomm1GLcEFYcSAk/UercMjdpMwHEQgilFag7pRLvm9uDaB6MUFfH88jL4pwkvXcREidaX9wYhgbs41+jaw8js3ff0B3/hzyaWZoAFdfyHNQwPx6oQ3Li42Sz3oXxMLVklmIRhZRqzGLznZpmn/zxLSqqtwDgKh6w1rx0jsGqsky5TLpQRLuo1uAsJ16D9lK4O5ckv0r7qLOH4giaUxI5qsC536wr8CtFr5OEtzs3BpzjqAEJdg9M29zj4WeDKnORO1GxFV5CT4pLS0McUbOVrBChCh2DUF5o+s1Ulmx6Vp0aKieD/X1f2pGraHRk8cBofyhRRONOI/CTL6r+/XKJXKObqZblzLHbUkabgFX0IlOJw6+ly9rnEpbY2XJs/4t6N1hz3m4Q1C4NgBwHVRJW25Azq0VlF7a/cLXk0AhJScpkrpbyC0CUQ7YuCfJ1tCtS0MkbWub5XSu83+9OsX607ugChPEJNMf54JRD9LQqLc0vs2dHaRzL45ZjCHa+6Q6YZ2PfTDuC/iPgqQPpVns3TEnnB8gJg3NWdw4aU1bCbX96MguZk5w6o7C06OiZO9bh1FM7IwEHE8gJ3rbeXENPBuEVoG15s9DDkB0iGeo/pz/Q29sDerw64fyt98TAg/61qVmrZ70lX/TW1BuXrMWSgCd+QdACbhfkxYZ+k6ID4hSV9cPSSg0RSvilg6f/oIjRP4Hj0m9ag7
 z+IeAOVA
 mpx0vG719LxleiQuXgY9v+enwzkgwalyr5fScmWAtHu3TDqFsgnozlDzV4vpcVCXrrziSp5CoUJC1eTZ8sja1RXBHnMKqAEEtoU9hPXSNYJ12kyZT3s5vxudlq32dlIieD9pKJznlH2ClWpLnjfoMfYbkHfrepfT9sEB79Z8qVx2H4O3gissm2wYkYs3bggI1qqpLhTUB9pmMZtW5IPGxrjCbj4t+YSrmke2XpUZ8gyYyDDOhzP6vaWrx6tt1/F4I8h5L2x6uOrUhyH0xa/JOadpbQGGajUHI4kuUmtvoiFf05V9NXP+nOAyD7JOK2THyxqRaBJhztOeCcucOWHvgiJXP+ToisjBvqoT1LgelFX1FAsd7RcZTUNYdk2w0QUHEDtXsEiFYbBmmnpHdipUskSRekjUgX9t2QNGzfx4Li2QI8HeY8aoFnh86ZRMADoBiqwSHlPNboyOYDXafYZOVvwYQZQhMa3z9dhfp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to efs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/efs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/efs/super.c b/fs/efs/super.c
index c59086b7eabfe93939d06f36826aa91838e41ba2..5e06acdab03b6f30bfa469e48463cb0e8a3b32a1 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -115,6 +115,7 @@ static const struct export_operations efs_export_ops = {
 	.fh_to_dentry	= efs_fh_to_dentry,
 	.fh_to_parent	= efs_fh_to_parent,
 	.get_parent	= efs_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 static int __init init_efs_fs(void) {

-- 
2.52.0


