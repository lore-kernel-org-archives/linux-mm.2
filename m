Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFA9BD29C46
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214096B026F; Mon, 19 Jan 2026 11:28:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7D56B0272; Mon, 19 Jan 2026 11:28:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FEA06B0286; Mon, 19 Jan 2026 11:28:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F293B6B026F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B60C9140183
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:48 +0000 (UTC)
X-FDA: 84349247136.28.F0EA0E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id EB3034000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ule0GqUZ;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIUiCiYvj4+PQCXeGc2dRPv9jWC04oKwYnr+8nkAWKs=;
	b=yAem/mwM4MuTaIr5MvxZ3Qy0MsvNwnkB5KgBTpr498+p2BRlDLLHbcmGV2gXAImfXBM/g5
	tUIPM92Q0djvETM/oO622dquVgxGSsKr40Wjq/b34lWbfqZKtVXAH/6FVJd84wAnaDWmSc
	Ai0mptWgLQOO1AZytY4qmJ3zZCFceCs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ule0GqUZ;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840127; a=rsa-sha256;
	cv=none;
	b=0nkFJSnehKBU2pBJ4F5oQKlkiBjAgj2kwXoXoxr8y9prTjVi2gHgqT3D4HkvdImzXGpftw
	yNuRfSTWaMqOd6dqkEId+kEzBfp+x4gnMN1MSPB6p7TyQDDBLsPSYVGZtFv4d2w7tSN687
	tQ/8H5yCxo7ZuIydDLANugZbLWKTwjA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A398444E6;
	Mon, 19 Jan 2026 16:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D33BC19424;
	Mon, 19 Jan 2026 16:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840125;
	bh=ttUZbbEr4qNvBmzcmWXht/0+Ro1g2UQElLV80PGUEuE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ule0GqUZw08XdIdQXdwy8YF/nQZodPwE+3Ap+rnwUArUvUqLP17fDeYXRDi2IiJSJ
	 HElLEOqGF8Xtj5odBgm9/xe2Fz8Lpg4CQVge093nGn4xj01wGTq2ovDCqHyWi3whi6
	 GiA7vqdnJNtVL1EejI20NzzJ8W3JehC438yl3lV9CColr9gUKT7C8Gess01Bet1SrQ
	 PrQr6QQdWmaEfrtIG3pvYB570DREtCmV8GhL9h0FkDCPMA6q1tkaEv2Ke3A6GDO2bF
	 U5S0zkEUQzmWWKRbsGGvLtUiO3iuk83JuTbFoFx1FOKcFkMCOPVXsSh7hBRH5E9yC4
	 +L7N+wmfPdx7Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:29 -0500
Subject: [PATCH v2 12/31] ufs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-12-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=697; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=ttUZbbEr4qNvBmzcmWXht/0+Ro1g2UQElLV80PGUEuE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltcC/d9PP4aKa1xZTIbsY8CXA+EgyYZnzp6u
 eqLCl6YoqCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXAAKCRAADmhBGVaC
 FcT3D/90eYAzQC5Ne5cbyw12ND7qM7cfJyie2ZHptiKyfxnrDewCraAH2ILNT0v39bZUSzit5Gs
 Dp5q4Xuq8NV8sm7oeyHsAsvfrB0u5QB3QM4VXZcrkXJ0ErzuiUa2Tr+cq3pQ5pq2gCIQW5z/Sv+
 LcW01jSHo4HndfR9FeCIg0wJ6nykbVpLEItP7xqwBtoda8oVtuolVChc9C+1uSm4O7O8mkccJMI
 UufpLPQb0K/tczA2KhXXQ+lJsW6GWXxIlKymNU57VfW0P7dsWrjj6cw9SZ1JSlLRZGHjpShbfaO
 cPXNsIxonKRlx+AgvCq0scgb7hsdna6caMEyA35No4+7Gk7rLbjOo7vF0Q38piD8irZS+7nDBmv
 HzGjOL+7GtCUUOLuVIxhNq+iP/45+G8zEyg9nAA4e3C3amjEnCFWG/KPszGPgRO2CV0ckSNxCxk
 dSMgIVWYwARpWcBPwyMJh9tzAIuLNmQl4WkxQ6H2j7KE+ormAsK7xTHyxJBEFVc6nPSyDnSEX9W
 LY6mTb62j1OHP8s3CsAjsMyeBpffAO7JIwboIgy4g6m3Z6fb1a6hXz7o3R5y9yEZmZzey9GSbo/
 G0ji6Q00W5ZxB3zg7itpWnOVS1npMB/HvC0SwP+JLcb2i6uiA0+Zw42RyX/lbDLVzkG5PMY8jGV
 CxntFIUPzGwJI4g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: EB3034000D
X-Stat-Signature: pep1gmy16cr9he1xry1eoexwaktap5nt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768840126-163680
X-HE-Meta: U2FsdGVkX1/lxcgVCt0l7XPCrtqcqQJ/nX6ezaAJJFw5PRi5Q1R1mYgd9DBSEHatHPN7vUIMVdLzReNoWzX7DqR9LIuW2ASLAipXoeZr3dNmbgZiTEBlo6fv+9gHFRx+s/AGdIeDc5zV2m2d3TvF4UOzk6rztaJ1E35h2W+oxs4vSyMdwHJkgl7eoyyuWNFFhJBdho6p5vEXKyRg/0pIETZlwcIhmgkjuML1DuCrbc0AukEf5CLWxqZm9sKllaKxpNMml7IzLZvpZeV2uhfJGCy4l3Dtd1SJIsQhoGIcFZlm2ZMNYAUAc+U+p9uhnSCTLPN4K9awm3DBFPpKZVLqSPArEkiKmOiSaeSkBbo1OlSfNMHqYTsEndBXzLAGOiFsiIyWBN81RYals7I5cHHu1BzBIAuZbEWgWsr7YKa3yBp47mbDTcDw20lNAq9JBfqmriQzOkUmdszltDf+z3b2whmiEW4TOJdXmfI6TTdXOw+Uxox/8llZ4oQ3/MnUl0Ckhibw8vX1CZ2YFk7HphNOsAQuv8Hnx5f6Gbq7X7A5nRwodHwILitxrP/tO30gHnReO4qd54sSYr5JPgMTfLVIlHeGIPzFPJjMbduZMLQmP7jWFKpK7gYGk8U+kpWylLlXwTSCLLFvhG0u1kTs5WSnSxS0x7+/iX3QqrHPkaGhqbSuCR7lG6mUxRi6B//fc+foXh7APGgE12EKID/x9LlrXXOkqPL93KjgaSE1GvFElfZUGHW+Mh48jSVjwkYI8k4fY6K9Si5pgGH+4H3oL3qOp9VDRJldHOz5Y2fKvEXlZdgtRoX2CNjvWql1aTlw/8qWNk/Wm/C25oxFEjLjbe5h4LUU5mbRt3xM+/uYGxFaJDTh9Bc4TQ/WcFHNhU1LejpcWaTMnW0Vdio6ybEpqtBOsa8GHdVkxmcynGJVG8GmpIvoQe+XK/qGmWT2yfzLXSB20HzGqFWErJaXZIBthqp
 aTdwDBup
 61w40bx4K63AcSJMAfGIIyrsIauIB+RD5IMNh7bHBC5NEMxwmHy1bN8kyv+ReD5SPpL+uROquThnaG4u21YjJiXEVVvTHmkc/cSHypmMljWjiyKWjU1In3yrrdH0TESOG7GhN7IcB+eu/S0jpXfOvSW2z6lVvupYcAK7L9zt1LbB3BlTP9uJbBbioz1tA6or2NpysOz8MchX4fObAnrkp0liwKM7GpXn5aDMVSEhiBDAbnRML2xTHbEg5wZg3D7JrMmEZW7RBJIs0rYBFj+1fEfFoapgy+Gxe+u6DIoQTVN21a2I++m9daBM2qbNUYdoHNs5rJhS+x/HtRro8zOWOHopp+q9jtISR3iRI/e4lCCpUCp/vdhdz2f9v/3+98wDzQq19KUgb84WlpdG7YPcCtFSCsOsc1wPqtxAGzkly88noLhpJZDEOBDmijoLAy9y10MFJV4kUpFYw8LgDpxlb9oecWSZNP+jMZTgXA0YXhqtBH3MDn8NwT9pBXGm3F4Ymz8W6wdx0GLWfJKg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ufs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ufs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 6e4585169f94bb9652aac29a14b0a64a7bb710d8..9cd9b6691849d52701058973f6b684f101df2634 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -141,6 +141,7 @@ static const struct export_operations ufs_export_ops = {
 	.fh_to_dentry	= ufs_fh_to_dentry,
 	.fh_to_parent	= ufs_fh_to_parent,
 	.get_parent	= ufs_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 #ifdef CONFIG_UFS_DEBUG

-- 
2.52.0


