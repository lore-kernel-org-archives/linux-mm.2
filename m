Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79FA2D29C46
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38E96B02A5; Mon, 19 Jan 2026 11:30:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6016B02A6; Mon, 19 Jan 2026 11:30:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5D06B02A7; Mon, 19 Jan 2026 11:30:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAE3B6B02A5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:30:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B90AD1A55
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:22 +0000 (UTC)
X-FDA: 84349251084.12.773A761
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AB3F640009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uW0qRezF;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KsqRfk6qDOmFi0pzbOsStk9GSjgqkcyLMnYwbWuEqcQ=;
	b=8T9FdBtXpSoJ4+Kw5rvQF3yqPl23uE3vUC8Bn9D7OE9cTIy8F4bOUgasczlbF2InRJG5kk
	lVV+u6frR9+BD1K5qz7JJDemfr5xjf8n/Qglu/mdwKLkaToadCnwOjoKW5/d9EI+tLDEQM
	mXfFUVR17L1BiQurXOSP/5bmavSL5e4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840220; a=rsa-sha256;
	cv=none;
	b=3qJNFQ+bESmr0PKFpILHFwIt3Ep8USE/hZvv/VgBLZrIlFTMAX4/VgViURzQP1jTgzny4F
	oO2nLj8XPuaRsTHnFgTcKic03Ji+bKFpUwYI4tH66fjpgiSzR0jsX7j/5uGrYLUSTZ9gKe
	4KKSGp1Q7A7APxWeOpcPKJpCtaLgjzE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uW0qRezF;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2AEB443FC;
	Mon, 19 Jan 2026 16:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8EDC19424;
	Mon, 19 Jan 2026 16:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840219;
	bh=6tWMcuw4SXKKliFxuwUspWBYz3IXPKjAO64IS1gzwy8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uW0qRezFzlerNDs8PuKGdJ441QJHOwe7SSO/QFQMzNVYXoOjiHcP//yxHRemE39qk
	 YwGPcQkEKt0Jg3XXVxeeWGLZOiZLMUNBT4M1H8Wy+FTFY5CwgHKCm5qxayW2GQmXmD
	 7vXoIKkqjyAzSevqKKCRd3RcIDgYuedYJ2ae2utlrBNPLHM5GNf6na/9xre//+UBol
	 i3xuRLUMWw2Y70PMjpIIXwQqmUp8t4Xt9ge+QmqWKHifKN3ikXmJKEvG71VgxRYeHp
	 zV+2Wqzblek8MtOUKv8VZSWgUhMcF88IV6nE4gWeU2mVJRx5J+IVMMOz2RNWeGIJj7
	 pMuB0z/K6YhWg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:42 -0500
Subject: [PATCH v2 25/31] isofs: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-25-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=735; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=6tWMcuw4SXKKliFxuwUspWBYz3IXPKjAO64IS1gzwy8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltf9nl3RQPci4dHsMHCsM+umo8MjeqaXnesW
 HnO9Lsm4E2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXwAKCRAADmhBGVaC
 FReXD/wIPrLFtBRy7dk3dDTSyjTIH1yJqNgp9Y57L7fa5RL3gAQMGxKbzGjfF5DwWc35pqFfmu2
 H1PTOoCJC/fAYdmdr/3RlcvQHPDNxYIe2izXZY5L0jg02nus05q7iu3i3gsftQ3wI13cFWTyOxp
 SVoAc+i1h6QgfYXpqz4CtCpIGm3rhofWC61ioVAb/S0T7i/BLNDL5iydoVga6uGjhUaXrJO4Xjm
 47OuJ4NhcP/pg4uTpAjmYlQQ1c75RVYJ28CoECZqrqf9BPqdFBFXV2l609ny0NqluGTVypPG9MK
 fg/lfPdwNjBqfeCQHEeqlMPD8vRL2jskqfbGAZ0Erni/nJB41Z04M3U6vrsfy4XGrAC2X2gK/kw
 ExJ/dt/CBBv7a9uFqeA18YaCYtFR2LMOQLlwESdHjQxLunZb0f87fZp3KyAab5u9AI7aBfT+9dK
 1QD0+nfWTS7X4aInbGGhgrtSQMTQ3mTHoknCDwu53pNH1oNlIyazOIfLfBwI8tcoTBYqpuqoS9g
 xev6gXz3JYDe91SFY1cyMnOb8dZeEeRHTPAmhxXB3UnfKlLqNmafMSmelfv4Lw9RXmQRHBMB27F
 2ws5gpBEdy7haX4itXzRZmZah70fjOslHqzInfRoznnLOfY04dMlmNxBkr+5r+BZOfjT3UGyWNQ
 mAGdsC+47hLn5Qw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB3F640009
X-Rspam-User: 
X-Stat-Signature: he3c6a93oaajayok3x98wcbo8q5zi8xy
X-HE-Tag: 1768840220-222232
X-HE-Meta: U2FsdGVkX1/X9Tes2AsVBIWX+xhugSkDH1O7jvbiaaCXmDKbERDCI25XKCxGKv3enziWf5PuD62zwBYRiJcaPxBNt1jnkJtMjrumV0CI3opptoYokH1diIfT8MRmTrMh7PE/iTUbEpATieSmFnqiVwG3JUtm4Leu7mhIhkMF4oiVtsEvZck1FyXYKkvUd1X9jy2vVxpc9DwLA+RBYc+Yu4v2MaqM8gvPeuqhHra9q4pMtRPhw641GAy1sfvR69h/aryedniWdcVgtHt8nVngoiQBvgFMOYddEcRn4nkzvKLgFGMmoqLI2Vo+VavoiTT4aKVtLgFplVaN8oIs99xfYRojpYLNo+JyYM7FntFlzYya05QxzQUuGmMyq/e0HsxaoJHt7th88uOsOVpPgRWU2dJjl1shE+9nOujX8IZP/qHIGuXdYKJYamqJp5Ms7Fx/j8EPjniOZAiGwXjwDLODo7c5DPrqx0OqAOUU+K9U/xlHStyZtQrSYOPZUY9gR+3WWSD7uwf51feeo/+bhVecQyKWos4QF/EqZR7RhM8ekhFmXN0xZrA1Fo73y8noOxmnW0KcgUv84iMTkJBJFjPWxIYwodSJmlv3b5xcWMzb3Ivq2RVztiIJw0NUHpw0gmZ6XWUZSC73QJzCpxc/T5jsh22S0QOU3CvT4lcYTnn++HtertSGfKNvRyIJeB5vx8hbU3NaZHwhwhFRx2CIe7Zg1c7/UAftkrCqlrCRFWYnUL7UBWhFdQ4ZqpZFrvqe0MJlyyBS1HoauF5650ZcrkU3LtF1XOhxHamyaNlK4wcN8xMA1BUZjoCwVPxxI9e45seKmcBw9Z5WbXXdLGJhgEwuCYVyOYF5zk08i6mrORRVB0PvW3xjax4p7NgI3tPVp0EVv9c98umPEgPXHVxSMHtMwQ1zgG6xO6U+IsM3O6nwor7mo6kJuCdzaSMWEJaHQSi9rXNx5x4ThP5vPiItutz
 Em/T2iw/
 cYCGBXJQlIJC17GV1DLQObvRANt8CBS2oBtwok6kGonlh5qodeiwzVgoloRMkY0MTD0s/TTq5eJjgJmSLus6gHzUXs/4yZBYtVkZ2smPwzQJcxHKp7TSBGUu8JZYIQGeWjPjQZ+flU8b5VK9fWvDTctEECnIG+eaTgxaZFtrTaI75W5AtTVr9d/qAc4d9W83iGJ8B16mgBaBCUtE9JxiZ6A6bymGXrpt8MbZ4kudNnVImg0/Ya/7NSu2OU/LFiwurQMMHcE56PPTFyoUQhR+e7RS2qAlI4/zdv3Tecsas17URKc9h8mGW3bZnMnd4XIzisHbr8CjrGui4bIL54xPwHZwlbQCPsJqUMADsuqjObUik7xI+8gHzY5zDhuDNCyckeIeYZX8kFZSd3XXHHMPnv6VmN8DOpAJ+2p+rofG6TcT8uzUWA9HyiUX6Q+EN+VK9j04az2PIQyu8igF6eYYKf1+utGpI9crH4wEs8lQrVC1CszO7lfEbbvIxGicU1cDcuRo9T/HlcpHmhKI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to isofs export operations to
indicate that this filesystem can be exported via NFS.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/isofs/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index 421d247fae52301b778f0589b27fcf48f2372832..7c17eb4e030813d1d22456ccbfb005c6b6934500 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -190,4 +190,5 @@ const struct export_operations isofs_export_ops = {
 	.fh_to_dentry	= isofs_fh_to_dentry,
 	.fh_to_parent	= isofs_fh_to_parent,
 	.get_parent     = isofs_export_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


