Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27A5D29C43
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236F96B029C; Mon, 19 Jan 2026 11:29:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2221E6B029E; Mon, 19 Jan 2026 11:29:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1249A6B029F; Mon, 19 Jan 2026 11:29:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01B446B029C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:29:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEBD788DEC
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:52 +0000 (UTC)
X-FDA: 84349249824.14.30F8937
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 205188000C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2NIXch1;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2Nyery+u0820owoJoyV1gjey2JK3/SSkxA2SBnZzqQ=;
	b=mkZVGB74I9FAwcxqaLmWlBGj52j2YnGQl+Av5iFLOi/KAwOnL50A8g1uq4t8gr76VzstTY
	FUStEhndV2CGeNfWDyt/V1bjbtuQYhyLLSn0M0VYmz4NBgcDRDs+AsLZV/LXiXasndky62
	sq+lXK9f1U1gEIckIlRLmxC6a+WMFK0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2NIXch1;
	spf=pass (imf02.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840191; a=rsa-sha256;
	cv=none;
	b=A8IIE5yEyoPD6ORLnRPa3wfybFwaFIEtJiE6Kf87GUCg/5QZu4BxC18Fvy8duA4WEj7TIC
	ktiYlsK7Su4zeaq/lPuR/2/ZSIUogyuMLoqPYudW98QlO4xq3nWPJFTA4go4zEXlNEgT+g
	SK5e7rftqwEu0JUqWOOduV6PGcpifJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C2B460161;
	Mon, 19 Jan 2026 16:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150D0C19423;
	Mon, 19 Jan 2026 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840190;
	bh=Vx1t81IxwVBJSLqIX9vPVWngNZL8liRiNm1RYHvLCvE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=s2NIXch1qvgEgJVzeJHUQ/vYQrQNBRHWLVh+5uTV5BK04joiphSTx1rGYkzsL31u4
	 sy/FhwtpHcIaa7AzhWzmP1tuedcD3fA1mIsJbAZaKfMRItyC5XPc0SgEWTOTxw9wSp
	 x9Gbg+hrOA0pd/sDE6jmK9qhWzMpvTNFHG2fFTvutD/erMWglJ3sfK9nQEcmfsdkxd
	 byO8N17f1N+uRU1ccMBcTg89fYHra8qPAl+OamddAUNbEuYWNuIhLhvY7ePZNDr9Ww
	 0bxyA6SjcNDZgRc+BLZh/E871afYJ64+YGs3KB46gQOF5J5UyAGHKPLIlR+1WE9QM9
	 FNrRDOuqBtl4Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:38 -0500
Subject: [PATCH v2 21/31] nilfs2: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-21-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=741; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Vx1t81IxwVBJSLqIX9vPVWngNZL8liRiNm1RYHvLCvE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltevFy1oH+9TGZ4tJg4adzFVAm26w57ZlHqh
 gzds6mLNJuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXgAKCRAADmhBGVaC
 FVk/D/913imOVzFf9dOyb6hCP9vK9aa0EKgm0XGIWuOXDiuJuE8iujL9QyuKBIEz8pjArI6pF6s
 YmQowEsKwGVIOcvA2l5D0cDnY/f1iklQsimK78XdRpHRVsbbjB0dmG9ty+CtlfCQPTf5u2wq0gk
 fTb5+p+BgYd4C1gov9SnxGb0Qc4s1X3PIIbCi6iFVl0e2J41wuqRNY+dYE3SDDNDvZ0i/XeUe2o
 +FuQghmlONCx17pc5ATpLql4aEGf1HlIQsWIlc/zUYlRz59sJC3ed2qWOJc8sXVpRJLv+fBueuw
 ObZYK3AD3rPPmH/K/qkd56Nhauz9J4ubCAJRdsvAyRR8STsFeo+NEOGOI7NtXCQRJl/ChFigFhL
 u3nVj/AJqjqttVBnyBUH6BV2sLtKoJkisZUH5H933q0vje65jZFvfGQJnqW2eUWcjfWMfuA0euz
 yWzMIJwthR6utXHrIE2MQp6D/NJjOLzs7WHdpwPDh0GI5F5lAYljmiW6Vo+gZTrcefXIOl478UR
 kjdq2kHG4hCgZMoibnXQ85diJ4l6S3AGAuqbarYCGwyJ7fboltbKuz/P0yphJTRSTMM3swpMd1M
 P/ZuEbbJhyuSOqzIDCSVviX2aD+SLpGz1vD6vezu8WkPXNdwoXn1mUe67jKXd6KUYm/8yj9I9OE
 /rKaqBOWpNc3NaQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 205188000C
X-Stat-Signature: 8a5ton3unyudoy49udhfthixotprchb4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768840190-266787
X-HE-Meta: U2FsdGVkX1/Zxt5etjbEUuMnkLpOOgHMqR0FIiubFvmJwLU3eK5zQtGmGCUAjFF4222gwbOUT0UzLSJGbHjIHNRYYqHu8I+gGjDDaRi15O8zv/hrEeCHpVxi/1dd/lQUKseldt5wpBxxHBOTXyAW8ZbkJ/j7Krra/RP5IyWN6NHy2IVZeR8rosBflT/H9E5ut2DoxmdKMmPSUDV0y/mp+rYKLSreyjn8eAIlN6Tn1vpkBYmph1tk1eZHkA+kXdts3At7FGUE4LpEkE1yw4mqSq9hYivKWPkjnOagcTXWKfqjbXy+87VEAghwxYv1+gfISV5lC4fUr3n4PGDitYBcu94b4n2HKVwQwsmF7Vp0pCnbyIUHNpn+8mbep1qgr1606X/o/WnzpgT7c2XkMZ8PbTw4s2dw5gNJoynI2p4aDZ15LsTEMXfk9uFEOIcOsRBUHSU9CYHcLzoXXjGl5qPDQLFWkguzlm7R1h6TO2J+rJYGLDyV5C9DouAcaYaqK+PBj5L0ZhpXdXnTRlSIHcrPde+HOZziLa0+ZzW9zvWtveQUaPX3K6/00AEGDYkF8/5BgVIXK72BDpqC8rJ4Oh00SBoR70VzISGQjBz8NH1simP9I4S5c1zjvhQQhmI1RnP1Lu4dzuPWBRuEqls0YOT5Elzk0t9qXGoMCclJFIMd0ViplAg7IKAqHd001JcEeON01wKBa2f2p0ZauJHdufnXm1wUX3WC3eWOUG6c5cOimuI66rb52KXD98lzSThASYFhXuzKrpptiVjBhbGMHWH6D5skL9brVAdisXByWXmZ9X/2i40xmKiRJ3VOifvkTOlQsbhH7Aps5BcLPCHEyNk3Tv7dIHmoFb8iAAjrXDXmNKnqE2KAHSfTAHLNq8ODZbP7X8DDWsDmJ3yIajwspi/taDtjVTPFpLHRnYn4SV03IhIxNzAQ6f2sToPGg0zAxM9Lab8Inqp1XKZ63X/xFo0
 mz/GCZy1
 JZ4v0gbbUqVNSSWVgrs2CUY/q1sVmZViOpAVSW8ReOjj03CF65F44I4WAJCx3+wnJ/TPmCSOmGJC0veJh3e9OyaJdtuXQVaeMUDeg9lnLtyf5+4xIiMI3qfrn0ne2lm/mH7flnmDVUKh5Z0Bl9AqDLIcQTiVctTRQgycDRwiMw/ZX6xz24skqHVKwGk7b/pjmxLlwqdUJm1i4ScY4Oc2yGUqCptgB+9P2WeugMLlRd3eGLjbVUXumIjXUIh/rCGa4cZS3h0eI2DhlyDVTXQGeBldEDW+SKtgWWKGVQCLqZiDBKDXrL+kjy6Mv8K3zonmGmi9qaKXqTALR1TZap8gqnCvUWBUJzQ6WjhhiNLgnuDBfXanVNp820YwCnD4WmzGiGmeHOyFLyQLo4YInE39V3SLIXXGkapqYxZbv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to nilfs2 export operations to
indicate that this filesystem can be exported via NFS.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nilfs2/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 40f4b1a28705b6e0eb8f0978cf3ac18b43aa1331..975123586d1b1703e25ba6dd3117f397b3d785c1 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -591,4 +591,5 @@ const struct export_operations nilfs_export_ops = {
 	.fh_to_dentry = nilfs_fh_to_dentry,
 	.fh_to_parent = nilfs_fh_to_parent,
 	.get_parent = nilfs_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


