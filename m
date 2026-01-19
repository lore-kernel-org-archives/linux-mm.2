Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB66BD29C41
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482AD6B028C; Mon, 19 Jan 2026 11:29:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A786B028E; Mon, 19 Jan 2026 11:29:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336596B028F; Mon, 19 Jan 2026 11:29:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2318A6B028C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:29:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9EB1B3FB5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:16 +0000 (UTC)
X-FDA: 84349248312.05.1592358
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32E91A0009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lqyE8RmG;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840155; a=rsa-sha256;
	cv=none;
	b=LCWH3AYYRToXrvHwV1sHfdAn2QtFvAwKyJqtmNkeU08XJNS9/fKSp4qpzS7cIUGfkHH6ZF
	S3//n7/kPZSNNfwqr4a2qBmF/vXmNBfrBK6po3kaHMQJaddWtr69PmrOLXMG8UEt9NSnTa
	KCsLveIsIJmPSh/mXIzqsdI84XJvydI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lqyE8RmG;
	spf=pass (imf15.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oC4BTWD+QzrKIv8nq0vThrIzQzjJAT/zHr+hpiXxSAo=;
	b=yMfrk8RP+strudRD7pwnLwrq96r9wgt2W4H58B4y/wHbKGlFyuRqnzk+Z+m/HLHeH0nkvK
	N8PcQyJKIY6OT3rq05Yed2PPb1JzGExek7bFRdUo30FaYHodoZKJ4oHkJrQfMAOoTAK2TT
	6SDqIK1A3mZruc99ieQCucZ7KQdWV6M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A16B26014E;
	Mon, 19 Jan 2026 16:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4ACC116C6;
	Mon, 19 Jan 2026 16:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840154;
	bh=o5Frh9Jas0eQsKFwc6fvb8GEIHx/ysO3v6fDYVnQinY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lqyE8RmGZSejzsOQU0MO1ISUcONtsmxikVAGnuUP3SkfDMQ3Du8mM81jZl+aYhVuB
	 Ahn33iMXaUsrrtOpeVjyWwYyKouJkXrEAahILxno3ID9CMj64h5u/UalJZy5oqVgyZ
	 8qWHLcfOhFmYBRu6IYevN+88h7qyQw529L1Juby+udKOlj8WypkXar2wrvwFoOVhnA
	 K7H7Vre4b+VLlU0bHBrNO1jGA6nmVF/nOA8lUtw2Xqq5NotuPvNB/yoj6y2uj88HJC
	 ELMxRaczdd3rzjuNa2h8KNXBV5hP6Fe5ZlTEdVEBaKpIZgflUX0lW18A7v898UgNl8
	 UgMZBpoYTa0FQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:33 -0500
Subject: [PATCH v2 16/31] smb/client: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-16-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=823; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=o5Frh9Jas0eQsKFwc6fvb8GEIHx/ysO3v6fDYVnQinY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltdaF1cThL9y/0XwYSNisksrkVKsW/AB2P05
 5IbY1gx72iJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXQAKCRAADmhBGVaC
 FZXcD/97dgCRFTvF92HsNCtcdMvHBW9NPsmSKBBjqVDufX8MGZ4/VSQkMX3HxFlI1V8Z0AmjBGz
 lepo+/QvxuI983RYiCoBo5QKyaqD5/LhYdLwVB6zL2YcgcVUabFRo/0cPkUTEfYkqb8V/vkFI6Q
 BGpYkOdXPXNbCnjqJRHdjPS6VtBDFXHqdYnLZq1U6/+qNniAioZHs5rk/ceAoybjzHeSqa2bWy9
 yW7UK/oLbatR1sXkXVW4s7a6exqOIK8LxdhjYq6ANlZWAtrum1SWW4nEeByKZQNRAH10bdF3xoK
 kP+kkah34mombElyQofkbwoeLokO09lPBuz/i8S7AlbPqTLSEduAbi5+usEtscs8lcqf/5GeqkF
 3cNT3AVl/M4F5ZSRnPJ3HE3vnIRcLE8WVCQ/iVgjQ/d/Jbrg/iuzYvdTdPxAUaIX9hU7+44HaXx
 Pl9JVlefKdZ4EYPVs+13QPDPsW6+rGzkr06LyGnGx10hzaBWxV8NGBGExK17p7P92SiS42s9/Wx
 qZBUU6XIMmZf8uHh4znogNDhhcm33486WnkQWR5sLhrUEPwQTtno+8U/psXvsmQmBMyNP/ud70/
 Y5W9N5xJcynuMTUHAhIG6VqPezcQlvq/glcZk1dYpz9wOHUP7ThX4OUQyTlCDU9q44iBIV+KYKB
 2PU4LQy2kgFCM1Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 32E91A0009
X-Stat-Signature: d5w17tkouw6mrkqp6gqg1d4uqb7uuu3z
X-Rspam-User: 
X-HE-Tag: 1768840155-784711
X-HE-Meta: U2FsdGVkX1+BF4gC/XTeetjCMNADF3ei4GMCdUUUSTQJqjRIpQf+476dtXFplqznzu0dZqjlvQ8i3cJX4/aYYelsI18tck/FvPD+Xv5/cMIsR/rDZYRNqlbeiGyYpxf/P9wtjYMvArs83kB2YSMvb3v2jTV0cO517hpvlALNtFBalWCKPWBBUFPfU1tksIcDBpwma3NaSz4Nxx5WIs7KuwGwHamHVWTD90QfhFxA4dBj3R+/0CnWfwq3xx9jTzx/GV0X6CLZrB1UFnaZeMbmJWnd8spMiHe6nmEsKmF8buqHWW4obsQmpkSBx8Wencr0c5mdMVBSe3kTpW4EZOYlCA3C5kbBTRInjhAV9L0mbdo7xlOQxCxbmveGVCe7tZ8dRP0qV9JljbA8BNRTx0TaQcQMRabnPB/9H9iWlVefEfEkJCBgqgu7N6hlqFUcisckrfmHblPz7e7A8C8hg27Zzd22x426O1MLEsSJXwT8MAtzw8MzDC0sBUuTjxbpY5Xi416qJRENsweW8bDaib/A6WCvX0g7s1XHjeNpKtgkXnkbAHn2142zSs+3MP/ExFGObTaX2j6nox3VLGsFYiMvMAdFwoYAWIGQXgHV3o+NKnqAVSP2zloniELjll6dVBfaI8KgZhj9zhgitmuJyL7OfKxjR4yg5Tievp+wTh1hmFOQOblIcXwS13FK4suM5k8+X1HyRPBsRgsE+aIjuz3ta91/JfjXfeikqfoNa8kExhruBPkXNIDxiP+ygY6KM53d97IQ6ebO06hdBVW5GbjtQz+V7tTgiT6LWaDcsCgLBX/LAtmNjUhGKgS92Cru/slqtGQpAkvZY/pE2ngerOJcUtbhj4V0WXtXXr4LLvdKGbWWlkKj93puOqswnVKcNpQ4OrVo9VrDgLx5bT1ocJ59d8g2DrSUNLUkJ+WKkf27we4OFbUqhjfIp5toxhO5IVqAyQqp83VaV7h3ONUDoz5
 o+7T/6SF
 i0krLBlgPW0zB3ydwbPz53mEKqIoycyqRb2TPSp4uzeyPP7n800BpdIfZ+7oBA3awp1LQc/pAINhziu/lQmnv+vVs5eG3orPDpzEAG2HpiXQGHEYR7AMUt1/6P84AuFUJxf9znk/xEC/0cFHCHm0tU9R/MWJgD13Gf3XDpV9gobJkf2wKgp+FF72uPrDODDx6P30M4U1nu7SLCK/1brv6rxLp+GrKz/1Hf8kMWcn8fueLK87vmpXelkxXygviAzbX9r2oUjYQPTjTBMcSHzEsUZ0343mDGVXZ8PdfUDTKiQS2fTniFtcIvnD5sqC79vhuG9rW2QOnHcPrOAn5NrOrOas48mPabnJhYjmWbXczpTzmfDM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to cifs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/smb/client/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/export.c b/fs/smb/client/export.c
index d606e8cbcb7db2b4026675bd9cbc264834687807..6dfdba9fcade9e4d7ae01fd107e84956f2f9b82a 100644
--- a/fs/smb/client/export.c
+++ b/fs/smb/client/export.c
@@ -43,6 +43,7 @@ static struct dentry *cifs_get_parent(struct dentry *dentry)
 const struct export_operations cifs_export_ops = {
 	.encode_fh = generic_encode_ino32_fh,
 	.get_parent = cifs_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 /*
  * Following export operations are mandatory for NFS export support:
  *	.fh_to_dentry =

-- 
2.52.0


