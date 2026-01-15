Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 614E6D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C011D6B009D; Thu, 15 Jan 2026 12:48:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1F96B009F; Thu, 15 Jan 2026 12:48:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE1C6B00A0; Thu, 15 Jan 2026 12:48:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC2C6B009D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:48:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BD3F160459
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:31 +0000 (UTC)
X-FDA: 84334932822.10.1ECC68D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A09E5A0011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AyWddbkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499309; a=rsa-sha256;
	cv=none;
	b=zL8xxDdaLkjghI8DGDVyMiiKY6oH13qKG6encLV9ZNygaPc2nqu2OZM6CN581azMlSooox
	EXIxmLpZIuiGHgWYU3ce1pGFU6WxaDvwMWyhWVQ1AB5E/TuqY06YI2hGrhrAMXCH+yC2j3
	dIwG7FmFV4qqiF0QHi4FdYKedYzi3V4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AyWddbkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCbQDHLcMyh1xfaaKWGZNsnmbbAJtn9HmhCKSaZ361w=;
	b=Qta3DxgC580JaiX3Qjf0KrJANwSijbtXFCgs4PuTJipqyAod6mfEY7q/hxT8n8JzwWIMqv
	1TFrNKsPDyEeqIUSbjlhojbO4w5TRYX0/Tkp9upZ0q4252ccsewDj7oWBu0XCNJzPYfHkV
	kSXojmxqMLkIz8lPzyk2VstYrvnJIQ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0A1244073;
	Thu, 15 Jan 2026 17:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4900BC19425;
	Thu, 15 Jan 2026 17:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499308;
	bh=yzPWVHGdY90c9Y0NTbVA+bszZ3BlTU3nheWx/Q0ZXr0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AyWddbkY1+5Bb1BTbzVfuw8e4mTnoB3EX7x0AbvDRHdV9AfbtVjbATCraTP7Zoew9
	 yRHMf3GQH0116BfZFgGjWKABQ2nJKnkYP7k6QNLzqdvo9mVkzmWAweq6oyXAqES230
	 WtCQT5NCXRmsFeuycTaRQl6Fh5Pd9fsK/b1alL8BPGVVL/0DC7ie4l0ZvW9z0bu831
	 9+050J2gyesVCYerBHkdXIgLlrNyv2b7byHHWub7CuCaVAt47zf/Nvtp60kdvEewGo
	 YwOXzlf+1c8VaChPSytGngOQxYetFFU1Ju62W1TTnJFveU4S38+XBG1tbfwNIiTlzY
	 gF1h8u4Kk8ynw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:35 -0500
Subject: [PATCH 04/29] ext2: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-4-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=689; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=yzPWVHGdY90c9Y0NTbVA+bszZ3BlTU3nheWx/Q0ZXr0=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShFcdmHlg3Fyhk1SFEGwKylG7r2LGnEhjLsK
 02h8FdsVH2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRQAKCRAADmhBGVaC
 FbVqD/96kuVCI2GYBHsPIJ3wOdXJQHUv7K7JuvZ9gRVISfe+dKUd8y9Lc5cBgee0AZTty87rl0j
 wIS2HD7eL235/XzinCNcLOkmyX2KF3QrLmvdwYfN2f3BXFWZqsH1rD1ItTGAZsGqN6FvLxExXY/
 N1tdwEHXAZe+MRPWIsobAB8z1hTZtvC0CI6g3UUPpuwjr5hr+/2D3mSznKlLIiMlgltSB60dxUF
 h+zoOLhgj3DzuehgJPc6QoDIXAB2zEG17qxCjXe7mfXKSysVcVCLsevRlK7AofQ/UeLFlagV1qG
 KQNFgmDSIhbXzICLF/w24ziyKzdVJ2rhwydytRkY/qyS2182W74iSU01XJIpUydVBT31aDG+ljs
 H7KyeYjEaFOY7z0a9ToMhFgxZ1eQWcFnn/05oX8jffh2iPx/r1U1WmODokOvOdopr7SMCODLRJ3
 U3VPZMayVACsAOcNXTZSVH54/uDg71SahdfbdPQNmnG6893Q8BegRPut25rDlyv3aatlaHelhQF
 0WKIJYWgWPeynVAmfzMYkhFisxvjqmFG9Oy3ZyAx0IPwpZJOwyXWT8oOUYC/aZKkccxTKJb25BV
 S3ma0QxLJh5JZd8bfsM9BrkOTpcg1WrU7eSUgPsAxCra+a16L0i9ITpWWt7Z310O9l+a5gLLH61
 UkEse/HvsJZgnBw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: A09E5A0011
X-Rspamd-Server: rspam06
X-Stat-Signature: dpbbko9wb3wgymuwr3baf6ct91hqbdhr
X-Rspam-User: 
X-HE-Tag: 1768499309-794867
X-HE-Meta: U2FsdGVkX18XXpE4qfqGS3dKel78lBKxOwi4tb1bjy+SwumiVPApVJwYb3+VD3gW4d9gX51A7gzYUEjXe7hNt769nAt39vLTtxolKCIkUuwh4HjsDapk30mD1DwqpU0NHpZoGtZBlOFTWjj/ssKOqBcRf/uGXVTJ3KMcqpSHC/TSPknaAhLq5bdKRZKsy1a/a2uXx3BOhV+4tmhAkirt6b/9W6YvA2ZppBb7iWnqLwr+AYDtmTj2AanpNBB+pR3GdCW8BndbWD5xPAXt8UZwFGYaYrANDNLDwhcbiJ0dgEaW5awc1JaPXTZrAt0A+W5DeCYh0iD4pBRI6MNcXJIR+pdRCkrPTofy2b5AD0sTh5/XOKIQ1avMeYfTigYAi50clu7mWqtOf1zov8h6YoWa1B37bxPe2Wvq7ZgU0+T6RQbuJKTyBSv30okgv/p46VLR54mI/UtxUp/ZZdEcvTd5ZZFOzIH8IyoFHGPv0VQza2cClJPzrq5vu8CrVLDcPMuwRleJYhLLPdKF69hlN+3r4BYdP7zUcdX7eCIWgJMMD+HX+/nX//qjGt+Lz1CvaqJnVfD0l/SAnwcw1m+Nc98/7gQzfpfpBIvyFu2ho8lD1qx5BZZfF3YjRT4FCPoR2IBoVa4P38U29hFZCbDqwaZxYEhE/orYhVNKy4T5Bu+xh35kwj6Lm7erp8hgIea1Z+aSkmAnanPzFSOBCoJKRKpzepRh+R735jQ8CucVxXMcmdezCNelx0N+48GwLwwUSfBGL8jVTOqYI6jIGNiz/Su9LJJ+FIbF44FhYf7ks3b2+rxUBKeqHtcrfLMGw/lhRmfPSYiuRbZeBa4ibSBGrUxgBaPfcd83qT3WaWoOPg0oqDoflMdi94YlYhiE0BPO9+QabY73/Ami1E7ew9XRn9mJP+fw27174DUW3T/WNZc5d36za0CxY4mEh7m1wPW0eDZh8gaP8p7JyHSfMJZJLjc
 lS8bWEHn
 5FtSz5CvKg+bnBt9JS0VFsSU4IcajXNlnvJ2dc8C4cOIBipAc7buEwim1gIhjDgdB1TwLCObVO1uWxA+44iQCf+0+dMzOvb3WxWwXj9VKWVyKtOEzd2Y6CqN2b6qFW96Te8e/MslKD1cK2EL4nyR40YnX+LPG/3Vl+j2oezwUAD9jc0c6RjHEq6cb/obtRabhsj1GbMsGxCqeZ6n+CDtMxzx0hY9t/1NVyMy6yLpmSr+VEWOsf0wNLvGT3BK3JKxzvPix0mRS5f+WLF6lw3eMC6cEKKIbyCMKGmu5xn/j1DBOXoh/Undj1OlxGWoxDUBRlG3owdxavJvZ9vFCulPfpNpnj7KOg1hUVvErZyF3Bn37mMIRMF8koNmeg24Hjk/hocJr0OUNIt5HOH0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ext2 export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ext2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 121e634c792ab625d7a07251e572e5844242fc2a..936675f06806d268ded5a3ba5306575c437ca9ce 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -426,6 +426,7 @@ static const struct export_operations ext2_export_ops = {
 	.fh_to_dentry = ext2_fh_to_dentry,
 	.fh_to_parent = ext2_fh_to_parent,
 	.get_parent = ext2_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 enum {

-- 
2.52.0


