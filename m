Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64752D29C43
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67546B026B; Mon, 19 Jan 2026 11:28:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11336B026F; Mon, 19 Jan 2026 11:28:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC816B0270; Mon, 19 Jan 2026 11:28:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC716B026B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 660405687F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:41 +0000 (UTC)
X-FDA: 84349246842.08.F6128B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B23F380015
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wgi+FWvL;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obBvXeIihwcnYNwIfK7fO8NOfGknt4GVIgzKgx3OkiQ=;
	b=o9HOVVTx4812TGwmE6IZ2Hw7ODKCK5w7ThPHMhjEplxyMoXErZKRCdXDGXMhyNtTvoX54P
	2qLA1H43U8yNTPLsMdGmK6zfSGwgWLNOUx3pya/jKBp2vO3bDMGlOv1yEHTZulS5KMt+s9
	L7EjA1K0glKxY94eleIh5ihvk9G667M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wgi+FWvL;
	spf=pass (imf30.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840119; a=rsa-sha256;
	cv=none;
	b=jRsNlmo5fnVLNlOd0mXR4/M/9AgLOEBow+DVcvb/nI3IUh6rbwU/oXSTPNcEOPqBhL7nQl
	08g6arKwtMpRiVi67hXK7gq6UtRDGRW5vUQgRAlgVgz7Aq/KE+BI0TikUZiI1UGzCJuor7
	MxnZYoa/HxPXU820zAVu2UtV2/4fRbs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1700B6014E;
	Mon, 19 Jan 2026 16:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F5DC116C6;
	Mon, 19 Jan 2026 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840118;
	bh=FgvaakP+KkZTiWPmd/GcmMQL5i/gToOI+UK+TD05398=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Wgi+FWvLw0MQ+2HORgz5R2DzsE3xTDpIeJv3h1S0cFNs6i9UQbBFBYRNiA8j8Fg9+
	 KHV2BRMV8sc5hIpryCF11pPiQxFsp5jsFeGRgjvKpjnr50AHMK8gIN85Nf3HliIyJN
	 fVEnoXFDYtI2qYy/Ygj8CYKdqJi8j61eA8sNsahGBpQ1xk2jp5P4+4TfuS7JqNHmrB
	 NIwutz+PXPre13vg54KrR7HlTKnjxB4xKcJY/PQYeRmbOh3hCGCON9Juobo7p2e8vA
	 llAP9XHmK5riLuTYR5uf34R6+LIIkqWX0A7ghO8ELhidE6qt+BMPFR9uiYqbZgi+m3
	 4gFfkEvNqWt6w==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:28 -0500
Subject: [PATCH v2 11/31] befs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-11-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=706; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=FgvaakP+KkZTiWPmd/GcmMQL5i/gToOI+UK+TD05398=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltbCPwpzNwYdBr0vFnmbNYzyzE/ZPMcrbCYA
 XY3FvJ2K7mJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bWwAKCRAADmhBGVaC
 FXLLEAC5N5AzFG4uvYDzXr4HYnhMSx1oslQeDc2aNn/1b0a0OMrmi86P7CYesaBsl2EI1ujp33F
 OtWIgVKwOCZ0pSCYP3crtFEbaq0Aw+i2Iyap1/h/6lHHzapF70M0725+Adlu3M9tGmo7Bjn9ZY1
 o3g1+ZCSHq7lVtNiYMCk90mQ1RLDIva6G7gisSZ0fNGeM5YvlxzF/PsylbBWHu0MnsIQSKTN08x
 8lcD3ifSkZh+XuXVyuqGPPojdmvdQH2+KTj3ye6IdrjX67X6HUS0cJHLPZZGYv7qZ3zhHIZ4ocP
 S/4ZMNiZoheepK1QszjjTUh6OgEpzWX6wDrw4HIBp5sFA/qKKcltgPiGeItaZGnb1zHxgxKhEta
 6rCEV1Z4hVXYA8qhEdd4mlpJrN8I8crXV7Byc5x1gTg2LAwlNXNqDY/AMBY65Lo1Tz9AEHmByTu
 PIcDAm+N9dxEnC1iKlTmlUoJ1KSXFME0B0IxTb4/5lkGTrgiT3NRCOY53lJ/4kY9QRJuuJUjLhb
 r/b3XrJj5q2R9ASU1G78XzaNpdcTx7XqsTf/VCB6XsMbLtDtkBv5HFeP4Ggahuw4xSJoK3HHhbz
 KtCZVqPbkuk5PQxouzkrY9RyqOAz4a3KbwGRNzNuGfTCJBDAUCM6LBh2uoT33ckjofS0O6ihZ3r
 s+733coP9qobvCw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: B23F380015
X-Stat-Signature: ot97hfy1d3z84m76grfie8ra43n9yfn5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768840119-848459
X-HE-Meta: U2FsdGVkX184t+nQExc+yy387m4KJHYhRwsWTSsHXV4Mjfm3Shh6UoUfNf+vjJSG1aWgU6kqNT2WN8TQdxsxQZB/776eEW8O+9cnpM7hDOV+OS3QEvrf0IDUwWrhKE5MrulwX+xcMe2qethZXY4FlzMb428av2kPVbJx59e9kL1UuaxpRmTdIv2aduxseEX0TwV4ScO2xT7ILRY/dplBppJMpa8vWnEBxiuK4gdUZSAR3As8PwNPpZU7TAEvkBrxOGBuwV1+qCAzIgclGq5FtgCWQcdVrPv3eadulz2e4EjCSOAMFpxP1dn8dkd9aV2go4m5TGFdQLC/HBXDm97Y5d9PPBDB6bD6Fa6Yek6f3nDN4GGuks7eep+3O7rMI9BNhBnwTRrJfFhn300crWqizFdrYWedL0mMXvn+3d2GsGlvd2UEziizJIkcSfRE32SQpHgnR73yo50U3fihg3bpSitKUeJJR/6uezAgVcdSpOYRWVDTEl2qGpUYkOm7hRWT6odW0HZ3I1fIkwMxUOlRcQAGt2XBjNwFUqBqlwg2MPpe33Fr2TKNsDAH3M/xYmyUSvmJgd/WRVFEJzX1zPTUOEKAvWueSq4Z/PC3+yxDXPvTOhAXVPFLoQ0RY5DGW1W+EYjXZBScto5RUE76jbmDc6XtGh26jIz5tm12b0spqQT93qKddRjO9oXeqwuaQeaDE02aT9rLS42lIzkNzJBPjNta8DodMYWUTI+loeTi/YsHhUPuXUlOMvBUD/L05LK8Hab+P9iwIQ/CTfWxTxCyPxa2ZKEa/lTmYklCYmA1kfOpIfgNdrST11N98oHcFU8dskoxSnvww7P6Vv0HQJzBYXIJj0JdUIjunm8MqumxQk4LsVk8CyHZxzbR0rwLanTRTWZX4LxhALhyxnQD00p839DFWIy7sy8kSNjCy8aqtfo9ayy5m1iAp2DPAySCsMdOmnCYXVdtRSAlRkPqXCl
 YNjDqe2Y
 Cn+A0eF/YX+Kr4gtcl/s1j1eGNhJzwh3LdT/IifVDztZ1GzROwx37hErbG7+iRkHEe/oXBwKe1XsGc8gdoG0Wgoxg3RwOQKYpwuYM4ySR7xdm4A7XLWjUPRWjhFRHm1KCyMep5kjW2OsieycgZzFGKFI7DB7kO00T4rlJALA57cNmGMcFp49fU3AoQec600DxqVc9b/inTC6c4dOvc0Hy3nwrU4iAnT0e2FgcK5b/UCBKtMLjaZU+b81mH52B3h3U6LquSjhrFkFvdCtf+I8J4C0cDhr7fMyhE+1xmd/6rboTGxSmHXST1ueRXHVQuwqHUYLFzh2atP6eXGqJx477LPClSfKjPrXkoyooz7vdP8N6WgmA7AQscP0UO3Oq5HBZPyR4QukNya0PfdOfsGxJdf2jEbt47Gz2ctlUEg9AQugY/WSlzi89J/WROuAddtMV6ZEE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to befs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/befs/linuxvfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 9fcfdd6b8189aaf5cc3b68aa8dff4798af5bdcbc..1f358d58af8b4de9bc840b9926970340395bc9e4 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -99,6 +99,7 @@ static const struct export_operations befs_export_operations = {
 	.fh_to_dentry	= befs_fh_to_dentry,
 	.fh_to_parent	= befs_fh_to_parent,
 	.get_parent	= befs_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 /*

-- 
2.52.0


