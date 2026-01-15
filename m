Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EAEFD46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21F26B00A7; Thu, 15 Jan 2026 12:49:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC676B00A9; Thu, 15 Jan 2026 12:49:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5876B00AA; Thu, 15 Jan 2026 12:49:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF9636B00A7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:49:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A2AF1A044C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:04 +0000 (UTC)
X-FDA: 84334934208.21.A8ABD35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2F5916000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VhGTowRv;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499342; a=rsa-sha256;
	cv=none;
	b=seytAIOZCEP9dZV2etHlTgOgF2cnCrTV1e11MD8z9I4uSWRDTg3qxlLpzKa/F5UqTGQF8G
	K6JY5MCBWAzenvghsfEfsGdjHjLlwnH3RemX4OkHCUvhGIq86XTmIFsSS5xZs34z0GAuoL
	k0dfNXpKGjVubdgearOQbS3XOsX1boM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VhGTowRv;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbaS2GnYHC3Yw0jcd4OE6CDNnF+8x4KkNvfYkhEmmgI=;
	b=iQK5XfWJrWZf1kc94sxTGNo8Mdbupf9cqvP8IzNTECPaWuIyk7O10zk7NGJfVnbzy4ZmZt
	5J51rNXsW6nZrOnte58zv8X7/ibIuXopBidT3Cft3QDgc8Ya+0csr5vr8qF8W7+A74tPZR
	Pa2WkzrVrJhPHIdZm/lcMBFUo6yhjd8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CC976015E;
	Thu, 15 Jan 2026 17:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C9FC19422;
	Thu, 15 Jan 2026 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499341;
	bh=kXEhnrEqBGLUfKXF9oxTrDiEyMD/rJY/BOIQHOiqT1U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VhGTowRv1ZdCSbwrP6fIZLhAzqz52dHubpyKszBLI7URAG7W6SPZKGF3KIn0U2zg+
	 5tVYEGsuwDF0mJJELm7H4UgOFOZa8Rmf73fjwJHRZQODsuh4NDe4N42RJqo5k0t/Ox
	 wk0Zyo9z0NB4J2vm9kg+NAPOl3NU2G13g328/x0Ky/AmMH30Duw5NUr8i6JtfOedpq
	 J5Dm+VWr3ls784CODv1E8lo+kwt8rHWrmv7tNk1pSucEBPQyhieOVhKlDaTv3/dxrS
	 mFXsnQgF2g22EioMuqnjQY2fJpwhESYq4WgT9lyV5RHSiQDikgxbfcTKxzQfqZwGW+
	 WoFqmmRBqrJHA==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:40 -0500
Subject: [PATCH 09/29] btrfs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-9-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=678; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=kXEhnrEqBGLUfKXF9oxTrDiEyMD/rJY/BOIQHOiqT1U=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShG89hcHuGwJsd2BxAERNQ67iytfM88cVk1v
 a8CNYB6vTCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRgAKCRAADmhBGVaC
 FfdyEACPSGL8gQMZBDLdHovcBu5qSm6pu4yGdMYyroq6SWbbG9R0Q5Q2XtDnm7GKMnylAUV/7eD
 76S6FhEf7x/OgCgs8sl5VNhrQ1fFRq2rMYx2v6XOqKiCyRShojkXZw/Hxwof17Gk/IYLjwdZqim
 VUVSQ/pSZy3CqJLm0BXUsMs+kCLPzF5G8ZkLT+BNwDGC3KZwhB0HtOut2eYvgwYxWSnQGjV5v/9
 txa5IckHztnGFocaKw9dBZj2YbgWQs37r7LRAJZsmPoSO08Rqu7zr+Z0BtWAAvznqYRu+cQoycT
 41wkc56BHYvd4UFgUOM+7TjEbXnVfuX0u7VdrLQ8esaCm2oh4x8HfqZ+Zt1Yhzn5xhV+bFqmu/t
 D7mX3Pfblk6hCjPdSYPsj5IwLEIKpxUwKcPwOofceq+p4s8f3HXix9p/EPS7PVP2XzgAebYNNAM
 VJxrqtcHumJplzhU9CGlzT3Kob2C/sZ7FqRoMsZGZMRUoQ5MUQX9iFNSVEhAzTf6S5DsYJ9MYse
 c4Chhe+FV8WHQsMBHumIIWiOuHDgPOEeauU1sQlYQDU6HwaQ/bEdxHShDeA7b+/riW4JH/ASR5x
 OGlR2kuII9fCsvYL2J9mVdHOCwyAWITJMJ1OBaJp+VAyA1otLqh9rgT9NK7BlTdb1x13X84Xofs
 i45vrL1rJ67tEoA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D2F5916000E
X-Stat-Signature: afgwn4zo8oiorrguky63xksbraha9igr
X-Rspam-User: 
X-HE-Tag: 1768499342-969086
X-HE-Meta: U2FsdGVkX1+Q9jtvGgBiDiPyNQV2BLLXuEHZVDrEmLGkA5WKckP0yrqAvvue/oaYt3d0BlWsxBbYmJPgn7M9eP5894HPg3SgAVqkrIOfFvyyRdHDvU8NY3lZy7yizpdhuyCCwu3L7EyKRB/TMjF8CFKmR5FAsmv/BMxuNPr00P8mlwSULfBUWFfuEMWXsEWGlFotuR8ir64E4bMq9bjLvyEcp2EQH0gRQHuccmI4jeZHuJzvjXEqz+5fxz0zZgnK1BavwWBFxMF4mZ7rhpewMsZ0NA+l7XwZjzqHk/cDAhuRbbSvo4oBDGKp4OA+7hdBWDhGQ3VtHWjDK/r83kXpAjqyeBq3g352HeloMnDnz01szFoBYIJ6ipkbcdfMa8kcuZMudibpW4irSTH6I9pbANL50VpbMe7KrhjwXaQQJGpwxwPW/yAUqOELvY+JO4BKWMOHKH2LI3J4loYMRtFzu2Ijn9gZLKHmSFKIN20YtpA+PslbPURYZVigPLqObzdvfWqdm6W9yS58eTKmSMtoLjcyb5xt3UZSkA0t0rJ/phiWFmDXUXMPgghB0Vi/PlcwLNaEmZRuYUgRhSDrZBVCzuSzIjnWnl0oO54lXMjbhCYGIWOn0Q71MZN00TNFJP1krIRkXV5H8O7kWzmGhyUJnrPQDlR+Bq4NrqihQJ9N9fdk0tAQ+PVDlMICZCEltQ5XfKo/15tjUYW29Hvi8qbH8JjyyoyJn8GknuovYBJnFHq3gnUO3ho1OhUDjQfREJMvYlKj0OfdoAGLzUU6DRCzRIneORdeS1Juohv7od7r/erSPGJZZ1ulSP2iOuN3H6fpsZ3NC64Aq04REJkMyioTvQfIrrhgA2e2BUqVj2/aA8FhrfNB9KUnCuB49p1nZmO/ULGyqGhnrfc7ICCauJ+olRTondp3t49GRw/ExTnfFWJzQmv1W/I/X4ZKZlRbaSEGvUqnysIRjIG5PDMMX95
 1UnsIxXY
 Tfcz6U8Ko61HqF6XNyZHyl7bgxmDWCl6y7SxHLSrhsZYy7svsazUFSOqk4zYqxLYQfYpuKFx2tcVKFZ3RwQn7kMofPV6FN8Hz/D+BMIbrcxMz8BS4pi9q5HH4d7RtIIQsYmI/zFgQEUXrVUfNusxDhlMjfYMR7S5/MOM+XtFH/+2xsMGhfEx5BEOArJcqx8Srih1sFaCsPofqK2cIj1izmkGB10aFSzztT+oWvgrNCHunrU7NCKv1GrkjZaxgfaRVp4TXlBuDieNMorkA4Q2y9xFQhs7iwpEjOs4mJ+UFEHrCri3szIGzTSyLc3HajR0i3yFEM7qwuPQKZ2hUwM/hY4CYljvvFR4sk1rRxnDeHSluFSrzTErRO7VnNuhRtQdlBhSS7ynynnXOYbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to btrfs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 230d9326b685c4e12dc0fffd4a86ebba68a55bd6..14b688849ce406b2f784015afced2c29422ab6c3 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -304,4 +304,5 @@ const struct export_operations btrfs_export_ops = {
 	.fh_to_parent	= btrfs_fh_to_parent,
 	.get_parent	= btrfs_get_parent,
 	.get_name	= btrfs_get_name,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


