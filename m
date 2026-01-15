Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B00BD46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4F66B00C2; Thu, 15 Jan 2026 12:50:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6D36B00C3; Thu, 15 Jan 2026 12:50:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2986B00C4; Thu, 15 Jan 2026 12:50:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAB776B00C2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:50:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 961C21B7CA
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:30 +0000 (UTC)
X-FDA: 84334937820.14.8A1C4DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id CC8571C0003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rR6P5Mqp;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499428; a=rsa-sha256;
	cv=none;
	b=nD6H5Uu3CzRiz8YJd8CPnyCZT3q/MEnVGSBhDcFkwTk3L8tMVIVWxh0heIswMZNsH5Pw/N
	w0oSxii1iTg1JvgqYFggWu2rn3Kc+M2H6K2EVlJDccsdiGnLwulRS2DOyVHNHdbmwArYh3
	awpOjH1uMhr6AVBKC3wuMbBpWGE2xRI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rR6P5Mqp;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xp9C0iSm3vjcoVN+J/acwVOJxS7zKjbIu6neF02xM+0=;
	b=OekjI04RPILt22XoUGyi4njDPyK48pyVYOmW7Q9KvPgis+OmOpZYLciON5uqcMzfZlXFqY
	5ZNlydLt3zZKxfKk8PgCOb0W09mrPyEgef+6TsE/enL2u+DzXzLgIYDawYPIsedRPRF9oo
	Rt4J2pznLVm36NI8C+uSnH06gZ3ox2c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44C146016F;
	Thu, 15 Jan 2026 17:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C287C19423;
	Thu, 15 Jan 2026 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499428;
	bh=5qGrvcoNEaqzKsbFBudRQKuxZ92uiJhY9hmL8JYVNwo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rR6P5MqpIlAhNzf8XuUwzeR0k2ADAPvlltnRtEUjrMxi0Zo6/8Dt3CKUWLqfaVqvV
	 maTTucLjmIvOZJyMtOcHtPzt6gfk4sFH0sIVdzS4AOjzTwdHuJW2+NNgGCEeGGbUIP
	 xc7iAujPGz5+g2OVzeGgRMIgHvoijHlHKpfBOdlpOLRHePm+BIhlb8/Vo8w3rmKm1t
	 vk8WW1Fc3rJyG1JzmOsyAJU1y/vEW7lVmeFFbX+4Wv68qN8/jR85ltMp9LCmeh8+ki
	 /R6lpmzQU6cIvNz1eR/VUPClQqtbJUSUkqmxN7SiK1wm91O0nOO0CL3G5RkpSnrTo6
	 Xb+1xdin+Tpmw==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:53 -0500
Subject: [PATCH 22/29] jfs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-22-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=757; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=5qGrvcoNEaqzKsbFBudRQKuxZ92uiJhY9hmL8JYVNwo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShJ6gzq/GdauLk+afGsy7jPLT6yVwaC0xixs
 lrpnTh5X6uJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSQAKCRAADmhBGVaC
 FRUSD/9ByBjb9qL7WUXU7eQFvtHwFTejj7UPRv9G2yA/sCWJnOY4XI4+DT5LXXjPDJ5WfzDmY0h
 1631R1kksFTmTI4TTr1rMQ3DsyUNANdSFEjmbnoMKjUUf0Gb26G0Zhtehcvah6MyRo4hnuEgO3N
 j9fY2jmqmR+Q0SjY+g/ZSFgJieIZJ1bPG5kGaGg9nys+m/JtMDhKFOib64DAQfBEcdBBtMlYe8L
 asyygrgU0nQ7FjX8gT+iV5Q7p8xHDDDQyIQgzC//m6aacF4d5KuNYKHrTyaMSIo4RugSJslAQV6
 +FMpHhadZQqkN7GDghRXcc0YTmgv5dCyjpWHgS/39eN+IVT9aes5hoc/QI+zkvskn/epPcE+tp7
 lbmZFB7ApvXUyeAEy+EogpQ2GX4AVZ4Q7zRb+uU84rdoX6xNMPAOGQ3UfhGJjImDrAXZaskyOTD
 dg/X43DE4ERo6Co6EL65AGek+DaXlZo1bc+y8QfodlH3bQm3dOx+RrveNSGyjrosX/LjBkT1dO1
 HkBNWR+339Wi7nHQTnjmr0x15tUe4rPHVHW41nMi9vwSOprdFNaG/Cx4O6JmaWzkNOVBkTTOGSb
 FnGwyWVBJgq/a+9nZm67mlnZ919xA3ikbxMmTS4jtWnsmR8eQIsuG+eAMLgmGcjgULQ1AJ8OHd5
 KEtt24Sqjm6eBDg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CC8571C0003
X-Stat-Signature: ik4iqrybebj7shoj58mnx3si9isyme5t
X-Rspam-User: 
X-HE-Tag: 1768499428-260176
X-HE-Meta: U2FsdGVkX19Gw3TarsRupY3DcsyMUg7xC88rXAlO90hrZ608ZIycw9GL50XboXv+MqqPZkxL0JG2sfENHkPAyqv/Bryyk3mNUg+YMrh8harQ6Ft1LrOOVCvsx6fs3c5CVlHcg0qJVoq8ulpx8ggDbMmtTLTZgg+FssSrWOa09S3ELE7kf9+7Fhm3qmo5F41n8duyIRuSyfkVM7uckPRig6W4UCAS7qaIJzvzLQqnnsY/veqIOCum4pD8uH6oeWtPlwBYWXJFgMn0yCJeSRexj7tovmAbzaMJMb9vHherKZK8t7Pck0VTKZHEUC+eKuMlAzAz8ylRtvZSzHjHmGfpc2xdjWRDBki+ilJ+GM2W+syFa238zOPXOnEm7ggOUzGnubxxg0xejcHHdi2nML+6XdCD8zwg6udiiaGFBLin+9AcSLA1LPUsDA7fJhF4uTowTx9QxNp6hGoqC/5tYJCF1gWccuHKeyW+tLrdowlb6p0S+f4oTF9OdgCpKd+smfKe2vCkkIy8fgl7zACuER2L4acMEzw/pLJNspaXW4kT1/+2K8Rkl0Z/Ur/Ce9K8VBvZyKp4SXHNWTB+/zNgSqr8ne05T5u96CT/3s68hj3rBRQU73vBdeccUCiAOQ/c8tPi0OoUWsyuaRnICWxsbhwxAxeJHC0wEPIV3YUQxYzqesiKs3x5r5Sv6LsDRZal323Nnk9aE0862Ni+eGZDEM5XTeegF94zBNIEPWk+LILastxy5eHw0VZhKWLV8IzI5z0KsFhAx6KGGz0LNceiLGr4QZM5WHRVhrKp/LiHi1aJmhikDCHbFHQ9cPtZGbORmwB1UCdXZfcNqf1MFQ3I4VBcrNrhoMIbYysZ4fSIMbXhPhJBzpnCRQ4IAuveL3MY6vvu6Wv4PF3j0y8QyVNMSjWJs33aHn9xXVyIRseiBZymNMfwnZLOjByps1BHl0aaZsEo/7Qm7+OBkYlJewgVlsC
 Hwe1XuUY
 RSu6zSWnS6wlrNfn74gowwJ9yTcyFF010zjHvMZIGwnqOVEDIqp73aRLJK9odJeY1/piA00jzmWooRxo4zt8XZx2Gzx1hBeNbaYyr3s1kvZ8pT5p4Th/q3GwxI1UErXQuupO9BHOXi+G4joC21kYJFcrstRFvXMh0/C81aDmN7QJQ66lbTmvCmpIByBe/cY+nlcTREWfZNHHbKVBDXC7u75BY7ExkNCrmOJOPvqYDngNQxtitAP0cumAWY1fxNVYHCVj3ZlzVbZySypdyNfHWX55Iuf8qkoGgUwWwGF/qs29Y7tSobjtanfnBD/nv4nUm5h+tAXdQtWGBI3pPTtpjrg2nTUXxwe0zRf19WC4KZh8+mMP2/9vlt7rgUjjrgdl5iLhiVOr9srIr1hQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to jfs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 3cfb86c5a36e8f0c46a2734a24fba6ffd36c7ad9..ac9b6d754f8c203baa7e91362aeb0dc9b3ce209f 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -864,6 +864,7 @@ static const struct export_operations jfs_export_operations = {
 	.fh_to_dentry	= jfs_fh_to_dentry,
 	.fh_to_parent	= jfs_fh_to_parent,
 	.get_parent	= jfs_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 static void jfs_init_options(struct fs_context *fc, struct jfs_context *ctx)

-- 
2.52.0


