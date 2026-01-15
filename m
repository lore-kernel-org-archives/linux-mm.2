Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E07D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFDB16B00A3; Thu, 15 Jan 2026 12:48:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8AF6B00A5; Thu, 15 Jan 2026 12:48:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB566B00A6; Thu, 15 Jan 2026 12:48:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8FEF36B00A3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:48:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E326C1C5F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:51 +0000 (UTC)
X-FDA: 84334933662.17.7CAC8D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7F982180002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:48:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K6+XHbKx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499329; a=rsa-sha256;
	cv=none;
	b=WRjW3auudxKesHp3PfcDTu7yvSRQ5hVJo7chfXnwJ3s2qE4EgUgW+i4U30iM17aXjRToeZ
	db9ZFFYrBPskcukl20fNB7PFwA1J0VC5WV89gQZWzUOO1xQgB/AcUxl7245mMmFRxH1ykc
	DKg1QWzOnNN6z2UGQ8OSmVOT3SRHM9w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K6+XHbKx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tDRbj5Fxnvu6c0vddUL7gT1ZEgkO2T0V5oWM2pNPI8=;
	b=VPayda7Av6YgidZjxkGLB91tgXDOYqixl/egLp6Zb0q9SL3Rn/fxHmZZ88lGZy2mEZ4txV
	L1tdBDWBIioULybSnmC6To26q2T/CiefJoX4SFrgZxg1mEAsqJU7GtetW2VQ5cY0NKB5RP
	QNsBTcFbHE2kTPF2LTuceziY2tPekZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A82CD44448;
	Thu, 15 Jan 2026 17:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A39C16AAE;
	Thu, 15 Jan 2026 17:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499328;
	bh=vuk9Wvyv5ES6VnJs/c70quqpIAbNAzCUaJcxJKcbQlw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=K6+XHbKxqod1uaKNGVLt+q96dw+BOnbjMcmu+xcP3xiYddgG/sJuefym6nZHrJfKi
	 uH5dyVS/KTA4hRUnraDib1V8YEkjK+G8GVjWdIm826RobU7wYg6pDfMglI8V+Xq9Bx
	 9pJ3DpoKFcm1Eq0APjx7imRbBy13g0E356azB26lJtgh0O5ScUdhZNVC/YkdtYSgi8
	 gmVhqy2XaaZjGGOepgCkNZyeiVv3OKETq63VZjHg0LQALYupnIm4QywOci9P10oDbV
	 pLqK1LQxhagszUU/8zfOn1rer6rnz7Rc+MW2csK90ADeRqcyCjpM3Gf8344us2SQbD
	 qJhmn1Zj47U5Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:38 -0500
Subject: [PATCH 07/29] xfs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-7-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=676; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=vuk9Wvyv5ES6VnJs/c70quqpIAbNAzCUaJcxJKcbQlw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShFUCOUlu0HwA0s7NudpYH2UNvJincQ80Jwg
 sEsHA/DeX2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRQAKCRAADmhBGVaC
 FSd7D/9HhL3CQRq9CDjJOgHiepYVXs1Z9+kqO1P1hOhsl8D7DDIrPttx5CuWUkhGAcKXXvzcPmi
 9TKdrUzG50aTMKrqulpKqOunGLLFir7B3FcVywRapPfJUqx0KLTsBaCdT8xUU3osoXsoeb3CQbX
 1KMKEJ/pU/MqyHNy1iKPHPkElMxX0QKsgVM69UadFRWjn2R3skLcJHutgI8INVYsrewANQfW4uS
 MscVfjtjTEcOZNxyFRYwlsCfSFUpDGunv543PqvRAVyvv0BQ+SFeO6U2aMErnOE7r56FTfvMOl5
 tuh937foFGakhJ8nJP9ZQy45v4wE4+/hQzwc8EVn3HWLC195i1O8tt+ewt74JopOTmYHtw9HWTd
 xpQiYgGhx4/DEAijagS/DXh1DHSEFxfNDJ0I9ale+NfJBNUS+zgavkkntEAPOI45FfOYcw0yIAp
 +JGVnw9DNGE9V/hefG0jVOiPj9uu5/A/hwgV5sHzf/Ck0PEZIPTmxsZbDRGdzyIzdk0Ht3Fh39p
 tYyLDOLZCOgznQbY65l6VAW/cvZI0oARSGpZJRy4OudPobv3MM1rd0m77loet1e8lq+9V7Y1oxM
 Q4C8bVqfBvhIO/ANW/XxX4fqO06IwLdqLVvdgppj/GI0MovVq4ZgjfwW9cKZ2xEQTiqm4AFJg9j
 k8Hn27V6ZD+gXng==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7F982180002
X-Stat-Signature: xq61a9ooqb4buboy6tzhk714g1bzpeed
X-Rspam-User: 
X-HE-Tag: 1768499329-269353
X-HE-Meta: U2FsdGVkX1+Y3UZTEUjjFsiDAUWMFVbtOM9WlrUGcYX5BTQ9vsJwQIfkQ2g9C5KEZl9xQBhl1BwQC55lxkDFLwUMtfWNqMof51pv9S5vnOOi6b148JTStr96O/+7ndYaqUrxm5yQXMS8OdI97Tb18ykoov8h7UuDPxBtidtUEfDTf8Xlb8gFkquS5O8mE+BGlSgncvZOx5iG8OeeeOM8Q3t9hNR17vP5J5QviZY4K4kxu8RYkaQ4YqgSruVKBTzhGljahws0HQ0JJJa/wGal20tD3Qpt0E8AQPlpWv27j5eJH6oENnmhd0UQVOaaS7VDTp4JonOCp+j+7heVPql4ZgZJd12On5BNmNb2jWy3EARreCZuCoE3AdwEgzqPRYe0UChN9uI4UPZ60npbV6K0A0HyZbR955u+fXVypmaJMANI4UQvL+4BUYuBNtMh+fnFKXMu0M+Pkq3ZtXZb1ekwcOSDA26pH8rvFBgOnvk1cGYZPJcedK9Uc+pUs76x8qQ9YNubebGXM7TW0N2bX4WkbNqfZAFnNNBlsflG7vReyQC1X7wTwbVa+NxO6V4ZJy8jlpLulW/7EBsB6SlW7Uzeb2U3TneXT+Unz5srL3Bvi7E5QiJVz1YQdfUI1ik3YFv2Ao5nsWP2xtfKhJ7d0yB1bDpzDyCGcngVLG8mChbjGSSj1ftBNH/Rbwb1h2VMfK+YzLK6LnGlmSJvCKWQ+6ugqf69sLEvZzp1gYLMrC7FiVi1HHe8+v29w6WYVwZ2tqGJXsGTbt3xQZVB7oYzYsxKrpQt5hWsABC2Rew9DKFAA6nmSNfHOwTg0AbvzP9vWK/bNi7bmk/l4s0PdGcTsyKiYm1EQnheyxw6Wi7aZ6cZlnmlxW+Whtd/eSZ875TLce4a6MjgOlNwPAaHShRTZNtk2KVQ0BI/LDN4Vto++M0c6dYSIbx+xnzYFmJrG3RQFFMF0iXSDt9VKdcK+PgPPCB
 CmHeoes2
 hoN2PagO7tD6h6BI1QjQeX6sYLKblPjVdHt1wb6+C7PC0p4KzhDoqOF9mpY4xaoG9koCsXHpRDgZ5ZqgaqGnppEFEeXHH+/DF5KA4pHPaNZSkmmOC4w5Db91rqICLsDAdR84OU90qlM3CcRagrxcsj7DvalEGxxRVX31Dbivf/nQ/OjRtU8kq5b+CR6EyTt4wPyYVZO9jV3R5oztdbvdSQHYYqdlbMZDg01IGwBhhOEPdW1tVGxzP0oXOAW08gVoQgiS1gqbm/RcyzxxPw6bSR3rXAVgf7UMcDTC1nBLv8n4qQzN0X/EVeqv7ZLO64fsC/eI04XH1s0ObFHh/x9dCmS1h9i7JjV+jNo6mksjNl9VwigYUpQuHLx8dRklsg+8aoOG8GDebaNkt/6I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to xfs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/xfs/xfs_export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 201489d3de0899af34f0485e00fb8b36842d419d..1be2de3394841a2960c1b2791897067b83cc7763 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -248,4 +248,5 @@ const struct export_operations xfs_export_operations = {
 	.map_blocks		= xfs_fs_map_blocks,
 	.commit_blocks		= xfs_fs_commit_blocks,
 #endif
+	.flags			= EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


