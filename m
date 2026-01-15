Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80690D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E486B00B8; Thu, 15 Jan 2026 12:50:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6ABA6B00B9; Thu, 15 Jan 2026 12:50:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39606B00BA; Thu, 15 Jan 2026 12:50:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C180D6B00B8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:50:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F8921A044D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:10 +0000 (UTC)
X-FDA: 84334936980.10.3E38352
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A9CE1C0009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HzaZLDCo;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3PDjLkgcXJzDuu11ScoxsbNv2w5ZQFaQPWZZv+nmpQ=;
	b=XpOsXCsLWr1n6FPeGDnTZ9BUJcTTN1+TSzY7CJ/aqrRFNz2ZIFHx70TbFhApZAKVlVDl1L
	SkmaP1jrdCNsHa520+XoDhIpIUaHPOmRj/GJFmot1Ax+zZkKKO+teV95WY/niiA1TSvHIm
	Rg+9HGX36MkXSOrrSpkKrYIh5wZ8158=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499409; a=rsa-sha256;
	cv=none;
	b=k0W5z/Us2fpqtEcdGCqX1sGvCmIjszBy3LWWWtOnq75o79ILwFfL2fiEAJob8mHMFIhpBa
	mcHUxxjAxMyg41q34/m0uwquOPYE8OfZjMvt7utkYJaPEt37Y6C4N0AFS3320jAdwOqaSd
	OxD1G7UsOjwts87BP5JzZ+UiJ0N8Ikg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HzaZLDCo;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A6D1601BB;
	Thu, 15 Jan 2026 17:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB285C16AAE;
	Thu, 15 Jan 2026 17:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499408;
	bh=ASJZAYmFtZFPW7zLvK0ZjL1I4NBdupfpmX/yzCsItik=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HzaZLDCouvYiTo43CgRna8k0stYnWVggWRX+E7ITKTkQk6SqWtN2mAUd0YAGY8YFg
	 fv5e/by8LOrzChGrKfliZQ09J2SJ9WIOLLR193K9GSI9t/myHqGnT6ZAlWdt+Uzf0N
	 0rJtKvSWVHfJJqTWUhDArUuUXTS48/7IUyWI+5Qw1LrZ/CqnOghvhiGz/sBaMmfaWF
	 KwiX1CJgcy1laOLzsMhtzU5kB/g4fimS9XsKVcl1aEGTakFkmzA5K2zFUXcXPxk3eL
	 joGa56XKg7cKCx0g9tt2zVErEcJm0Vej01lMJF225kYkCN1zd7whNuBBNxCg2pN5G+
	 x8ukV6eAv9GoQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:50 -0500
Subject: [PATCH 19/29] ntfs3: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-19-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=702; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=ASJZAYmFtZFPW7zLvK0ZjL1I4NBdupfpmX/yzCsItik=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShIkjDCKglCICLqHNwkybqhDZvmrtSF0SGBF
 LwETpg24QaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSAAKCRAADmhBGVaC
 FXMJD/9cA2N1WYI1YFIcrFPq4MChLxHnvueE6hwkxPc5K7vP7yNwnn65W6JbEp2ObLGTsNTKPYj
 hmY2b/q/WvxyA0jN2iG7UYGUrcmbm8lyfJERfWQ5WnN1+fOBhsMD2Q+TLMqnMgi99BTN3V7CHwd
 7FcYq1rjFMR7i/SoCxFhaVCqjz/9amidfbT73cjGr0kRadbn4rbsw/SLhVv9+z9iK5uyJ4D0blu
 t6qe9CQoAyjLl+Gms605lcENCFqAWP24jtTNmaS/vvulwuBaTl8c+OxHuOCzcH9colTYZUoXSLG
 amzf7eGV7BAAvedVjh+Ycdb0/GwSn9uu+Tq6iJbHTMQMQhpStolF6blR/PRlzWQ/TjYQ3k1VhT+
 0gnz7OR6GaIZk7FkEbKolcNoVM5mc60b9ZoATyL6jx/F4dczwq8Rsv3SqAiClgX+w8mU9dp2Jse
 SRzo1N+Zkj5xAutyPJHj14ERMNwpP2GQIeG+tUyGQ0NU8BqNcwvKIVqRChO0ozWDEaLh757srrM
 olAdLIVH7Rz+CEygbk+t1jGLoA3ywVL2DS5w14345MUe5Hy0DR3iZdpCUlGE+OsZWQ0+BQmmVc2
 Qt72vG0qGAZ3O2rom6X15ExyF6DZpXjgau/5XwvIGUCwEP72+KQ0B1HN2KFve5zwRDbiBxvD5/o
 incrg3kj2EjzIqA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0A9CE1C0009
X-Rspam-User: 
X-Stat-Signature: qudy5zndugiwsnt5axsf9rainfuwekf7
X-HE-Tag: 1768499408-457607
X-HE-Meta: U2FsdGVkX18qDMDGwpG60xof8B+G4bcXkO8qukXDuVjutC57/dncqPDT4qDwrefOkxr5MEGam2Cea813VUAqyZYU3sEGEJuK4ckVZDPBJ8neqSmMU6w8E5qZPcerJJ6WztdEcvNkdm6i9tYxl+6AXY0Pk5EpaGgZ4yO5KA5p6W2kcRikCgAHBSZuSyRH3I97LuU6jM83fgbaDybwk/rZwzpB593mLawvutrvkqyakxTKsoKvHrmwVQ2VyEnKYdkKlBb33NihlSfqGXgODM+1DpLJh49TXllTZWQOMel7Qi3ZEhqZ0b/sG7KqIYmv7s2g4forbHnwbNQsN0zTHPpDHtjkaIUQARsrSf7d5/0VZ2Ejr6cdZJ8TnyrUVTze4KraMWQ/xBOcGjWMCG19uknW6Uh/Mth9/Ogv2jlpm1ZA6aqD6kKtCQwEkSLypVukwNxV0rYZddRI8y8GWpFk3Rdb+3hrFNKivI7S47t1adzHGwTxgjkK3+MwTW6COwTHyMQFxzf9/rWeEqKHheFdLUyTjOG/UClEKTQ/8Aq/DWx18DoSRAWBcoUtjBlpfiJu9qjlENGER1imIR9QOSzThq30fZpPKipsGrLfRqVVz5BF/vh8F6nfqJd/aZfqfOmLxs9qC13WJiIZBgZ7usgDlJ/ARHrb3HZw6r8aMtHo5UQni3FSXVMImF9pQr/IiZM9Z9lEfD0HYy8L5u4DL9tzqZJX8Ql7puil0KooxA2AZowqHOALrtm2Xp4wUzAayasnk4Q4FNklD5jZYKZeSi0bWYgeP6Y4rs/LBcVZeX1hEvnflIvGTjacwctlDc7Ou1dW+rA/BgFzfZDdm7esR6UXcup82Sk6Ae7D5joguaxK1DLKKhX1o65viUuolhx5HTseg6Wh/5W4MQQN3/ui2vHalWkJ01Y2JXrjVaiebZpNLbUskoRPNLs2cvOsBwtvgIHT9RlCa4BX2b7ZZfPCJgt4hBd
 ftTqZ/7U
 pvWOqyrMWbMIsFTTetzSEGsJAQqqX5mr+xEcERYR/7x/lSfvwL+lN+MyrFHePZpC7VBP7qj5e/tyTX40=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ntfs3 export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ntfs3/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 8b0cf0ed4f72cc643b2b42fc491b259cf19fe3b8..df58aeb46206982cc782fad6005a13160806926d 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -889,6 +889,7 @@ static const struct export_operations ntfs_export_ops = {
 	.fh_to_parent = ntfs_fh_to_parent,
 	.get_parent = ntfs3_get_parent,
 	.commit_metadata = ntfs_nfs_commit_metadata,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 /*

-- 
2.52.0


