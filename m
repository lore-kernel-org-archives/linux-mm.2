Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B340BD29C46
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25CC86B02AA; Mon, 19 Jan 2026 11:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213F16B02AC; Mon, 19 Jan 2026 11:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1338C6B02AD; Mon, 19 Jan 2026 11:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0300D6B02AA
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:30:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C568DD1933
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:43 +0000 (UTC)
X-FDA: 84349251966.19.BB6C3B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 18B644000C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L1drpzmO;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuTkwBieDaBYfiVvkErhMkdIL4UCbBwNP1dX5h4YmOE=;
	b=8GG15ZNCi1hqIGkocVAcr3FOh/Gd0g50wA2+86i0nVD00BJgmphJmkcWOfinAatU3uIDRi
	wdAlLTK1tiRsiLAEuGfRDcfXDFrz/btHJ6IPlfBxfmf/eo4vZn12FQU6U464kZtSYBZLax
	fqdMNsWHFGi0xF2/zLbrVA8qp5/Plhg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L1drpzmO;
	spf=pass (imf12.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840242; a=rsa-sha256;
	cv=none;
	b=cVnQwJ2MtXqUDCObl0xPTLA3JJEDUdy5A6JKfzNTYFAUyIPfZVSNFSf2FbvJAjfnB3pTX5
	EPfx4bqYQ+/MOhXzgVlWGtIPw0drqgqLfE7+eG/1/9NquVhsuafMuxu1yZSRt8B90RTcQn
	kPMhqDdCo7GADlDqxBOm3AmmOJ7fNcY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 609BF6014E;
	Mon, 19 Jan 2026 16:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B28C19424;
	Mon, 19 Jan 2026 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840241;
	bh=Zmo+do6HqZsZlZXVQKKSsmbSay6qOtqCBcv8Ip3ODxg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=L1drpzmOZwhS7wO9cwa19VSsy80i40QcyZlAaGZK3Yn+eev1gLy2tMLiqi6zsQpcX
	 g/gWqsJHMJQgBaVzW4ZFeciI1NUhgPlNi5wWsbXGgGL4j0Uv4T4IPHTMt37mKkUYzz
	 UD4RtogawKHmef7uBWR19MHXmO2cT1auakcTOXeY4PVe27C6i68OoaNwBKad8GnDtD
	 d/nyC4L6XNekUDohSQC4guagkxmqlyAdRj+IVSfTfvVlbK4VUGfXBnjpoUTMP39dmf
	 w5jxXL9g7wxExeBthoaxz8pkLK5ytzCmZJipo8hAi1qkrPrOUFFDoHfUqo2F6DW1bS
	 Cas8WWW1oS0SA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:45 -0500
Subject: [PATCH v2 28/31] fat: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-28-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=978; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Zmo+do6HqZsZlZXVQKKSsmbSay6qOtqCBcv8Ip3ODxg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltgaseKc8dYHUYRj77eGOmyavKVHMKU3e7sZ
 sLVNVNiAJmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bYAAKCRAADmhBGVaC
 Fe4cD/49CNUs86PH4v3uTOUHN5kkn9aZB4X8mzMOEw4J/AAiuF0Tml48ByLFtTTwHiqIZrKm2Eu
 x/gkwXTZvO40kPoyN5fIytK8K0yVjl09hrx8Rc9gwq0iGOtxQ7hdMwP35a/JbGT22DLjJONXGnk
 nRgl2lnb1Y2E40m4Hg8msm2FFmpQDusi9gIyl7OLVbIF5BHQ6tF+jnJ0DKHKQDN1MihKoHBbsXw
 OoxRSrcERSMtIY3oqeV9rzbmFmCEeOcFIM5XY+s2aMQE7vgt8BQKML+7avl/HqW+PEZHum4ZKu0
 a96hkWCBzhBniSGFHY78LpqWIV/41RMKi+a9ipC7ltAdNP69CN2VynIyliSsXbKcb85Q5RCaI6a
 iKydYxVLdL3c2SRkPqHe+m9LsbpCzRbOkEuP++7a45+g5/TU4Gcr+zfJ2ZCT5EsA8rU8KaXJBV1
 41BZcMEXMUTK98bUgMNZoBDlYca6mxL0Ldrru8nrqHr6JkrwGZrQFA7i+ztcA8+xSNKoUf7j/JX
 BDHFLN3lZrbj4ksk4mEN/6FV2y6MNHt9vS8x425TyotVmlwlsCG1NOtCndEL+VOZM/PenzdlEnf
 lFXckOYEqH6cS10AeacCinqqkjHbooveZGMvtPbqnMOniZUQv+cdXig9LrFKv+06zxNZikuiFlE
 F3LGgWPUpQR7npw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18B644000C
X-Stat-Signature: 49fzins7wau534zgo5enoftkrt7o7q1a
X-HE-Tag: 1768840241-546960
X-HE-Meta: U2FsdGVkX18mFdrgi0uACdinJPi4xLf6F6aSYYA5PIQ7pZI+Aseo+YLuRa2D4/3XWs0euijKX9tY+3JT0WrGhyJp5yTC1HcdxN62QX537lPbdYxRKSAu0XbPt3TgkPX+8nFA/w660xZ4DDcF75piZw+oepWqs0KFB6MzUKunbzVATL3ljqzH/b9etCw+kRV2KDtXgEFfdclmMx+tkhsBZwqfIGSH2jv89KLxvR7Hgh7+ScgBz4ecZq2eU8r12eNpoYYHXK1UXhxKT4zKgsM2Jvve8NxC6oB8qn5dtZKI2XBbbJetkTaC6+nIM+8C7ra5zNcNtJ0815Z2Wd1/6SFXvEaSZfMrS8lfpH7SCFC1AiB/YlEGdb8fbJGygDMZDCNYu13/HnDkoomTD46uWaMRvO+npg+gyAFs/3hAa+o1wJMmz+crh4pZ9rN3g3HeOkLJKXnc83c1fi/1P6XK7zwlnE4gLCE3VcTS71aQAbYUXkBUSVz1Y8gJWJnOFmajvHObjCDnZsmXfV8nZhB1VhjvYRB9fpJji0cj3wKdQKyJbMkDTyL81T7Tm00uO1p3YhdrMx28G9s1w3EwLnSEM7oqi5nz5EItSPguZntHq1gy9sPTvdAVD42AN1KEZSrl0io3AUN+Z4VsZTi7sX8SxphC9YEimrkf58F2TGNG58VPuRNDbPSLdpZrYTCq58NSNuTz4xgGUSwrNTCWeE8ojRVXAQCm1f9Uj/rJq2OjYNBe6zlBwBYC3oTUWhAYGW1QDXSCsk14U45YnF6rBwK7LMd+DbdHnUshoofFhOUS9LpmwbsQvADzDEX4zMcagIx5HKkAKIqCBeAIdYQEY9e1Mk4TH1WVVDsrieY55Dtp3/EYxLwEhp5/pxBCp+Nf72ZuX2f2eAYFtYtlFilcKmkULo63lRyA3Ka7ivOHrg8ty6Wxfuv0ZbxlQ0A/0k1hLIlQOgm4LIoPV2xXt4ODCCX6nit
 jcvLrJEL
 hgKd1dYIp4+5L8szjSQZGaM7KPWMV0I42ud+PvZ5T2FtXxt4mTHVeYRQqmfD6BUKSeFmJnoUf36Wpujc5KyXi+DrlGrmFzkXLCkUssolokJXs9hC2/9R8WCcat7aeX4+Xl2itlBkhDcqjjCiMolKGOlUj/TuedAwsehgXRWZNrIRTAICKDScOTiGj+a/ypno8csFMHy+6yDPPQawWm0uIEQZ8WErKHD82BaIdGcy2xXfyXbSD+w/WcI/BNixRhWX0lcWlqGhYMhKq0CuaCTR2A08Kzgy/R1QYfFd+o72GWNvgRTKCT+i4gooaWADL0PTHAFj8ZeuEuwC/N9+JeWCCMyNahkhegMyqkJon3Yz0Eble7wbBBPmJUrWsEgfy+SwU4jkhihfm+NUGfq+HyCEMkE2o0KiaTJOANBAq1QmiZjfGKjwndNZ+sv291vj/ae8LDcmLQUzI1rWC8hIaoZnFLMqCzAvvRuFVXEPI
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


