Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735A0D29C41
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E73C6B027C; Mon, 19 Jan 2026 11:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3354A6B027E; Mon, 19 Jan 2026 11:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139F26B027F; Mon, 19 Jan 2026 11:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 024056B027C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:27:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9754A140110
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:58 +0000 (UTC)
X-FDA: 84349245036.06.761C801
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D5E6220016
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JOwo2Tlf;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0eD/Hla4s8rmMuwNVa4cHjRWxSkSOpPy65dqqDTfHQ=;
	b=qLhK4aAOXr9F3jDpeeebwHsc/HqXSoFFPHcD7xYD7Ztei/S0PkKM/9/8EB33G4iPx477ur
	+6OGDd6VO7a/D9aDI9X3p/30s1xEbKuf3NbDMaJZrkta2fWCHgmJNGaY6g6XtDbnxxAXVM
	zcoVasckXFOGUHOkU9CUShja+bdUuNk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JOwo2Tlf;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840076; a=rsa-sha256;
	cv=none;
	b=iq5YWMaHIivgirlW/ZOddKfNMjDriQUKMe7O2G3gxoUhWjRN5mnooNJX5BnjRtWnt3rG2E
	4Mp2TL2l4CwO/2h/Qh8DHt962MlUcIF/RK6reHzG4jsz9zUCAMNkJBimRy0rGid2243FGq
	7WUWRkg3BE3RyNU/6o+8VSH1+j39jng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 432DC60135;
	Mon, 19 Jan 2026 16:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24386C116C6;
	Mon, 19 Jan 2026 16:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840076;
	bh=NlLYDWzXRW6rnfbCFw7xB95B0dQtUpjhcx2qza1jF5M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JOwo2Tlf1wQVs4rSpB2cvGoIOQu3++5wLoibt1o6KyCZ6NKRs/dwpL3TtvXLTtrMB
	 tcIaKEiJB0U3JEg62ukqgO+wVVLQYHHpZNPMEnMj2cASfeZPDaFPGaRc7/g2tpJcZ0
	 8LEN/zxj39delP6+H9fBw/GfNqeS2kAbT6wazW0CnxR/UsD6zosr4yvOKKXG9kGRu6
	 4h/YQ+A3NcydJEguRgY5PVyIhfCvfttE6K3brApDuPGezWzApDC+TxFB7SnFWAzMSt
	 Kh15fMfIViRm6TDmNYiveV22yjV/aUpG7PhBWedHMlXAGIDOIzaDi9XFZRhQSvf7NA
	 31z/5XUrmsu7A==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:22 -0500
Subject: [PATCH v2 05/31] ext2: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-5-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=727; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=NlLYDWzXRW6rnfbCFw7xB95B0dQtUpjhcx2qza1jF5M=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltabE2Jm7JAwFuoi4xvjHPIjuOTxYjIQNa1G
 qwefu7ew4uJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bWgAKCRAADmhBGVaC
 FUaaEACos0NEKrzptD1SfGjP3BtYKRG+pK3ttXeXq6A9Khy/WctcfkvCNKlgDFmyTKEKtSgK96w
 fzujSdx3zZDxGdKH/+NfIFJWsLGoSjYFRoCEHLoa9JKb507JGYtKM4z049+lfDx/zFh1gT9kCfp
 T7A3LKYI+1JZKk+IEwacJMVGpxciEHIGyd16ecTZ1UXjzMPn23/CbMbugOgyDz+yiq716Rss7/B
 Y0xqLA/b9InbEXlKHeA+TEzc45zeyVJLmqPcVSjw4sVDN2pqtawY3culsHQVOTqQtCI/Ysd/MGt
 Z2oT2COgY9CtFgUnHYwfWuyOGEy2Ct/pKDis48+kr/t2+13V2QZ7eZC39OINqIFttqV2erxtigs
 DxUKY25Ebtr3SLjtdIxPKO9Ae6HtzWe77tux6Yj+uk71h7u4U9wkox2xobuV/erBgRIA8YWhjxx
 nPv8KrXqjz1AugEzDvmceU3KG6j3KaTRuxbDGLbK+0xzj4Rq95qnuvPdcDUCGXLlgdfQEoGBZZn
 BN9cjA9xZ2JHPSRr7Ihx9qp6jKSfdkrObAmq7B1iBkwVpP3nm7htFDPMNp7u9aC04BG9aOdJEuw
 5XYI9GJTUGAorVbchUP0mSCCLwZzDppIbGZZQWY+lr0lTugsXHeG/m5lsFZnn7brwTTaobTfpWU
 AnaMFB6Wxbzrcvg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D5E6220016
X-Stat-Signature: rrpefn89f66ja6e9ohpw31gpj51pm85i
X-HE-Tag: 1768840076-117449
X-HE-Meta: U2FsdGVkX1++lLbkmDI2dMIRgWlGCIV0juBj8sudNRGynUxnj1TlvDLli+s7lHaLw1Xs/QeKGwd8RsC5G1YMtKGXbSMlnTWGhXOwDx0aaeZtgpKoTYfdoBwXF3uno1UXFD5i3yFeiRtKFRaMLMeUwxH45DqxKcfX70DWdPti7c2Pto6dmhVoRH0r6DdB3ztnYKgq5IGgbBMHoCo17HpMYbaUSwxFIXBNIpk+mtWdW6aosgfOhpio1y6cJXwPX9iu/2HSpKCW7dqYIUv66fRmtLfDqSRguY0Kp0kkw2XeMkPPzX+ix80l68Al7hhtrs0hM2JTI5VoP/PynecT/AwIhicAZnlX+z83T6qxcYn5d2ES5FpdUSlOivo9ohqBXSFplrfkOuQmJH/lfp1pg64z6FYjHWcCKvyJEvTwV6UO+sJEyIVHHO8CrMagSYUhV3bJ4vHnjygOn+xcL864wXxa/xijx8sTkJ6lFyjPF/RM+yMlo3zf34OpUHBWaqcmyPNaE4u8VlYrxvvjEsDlW/hmBiuIliC8z09+yK23u2/e4YoPOY3GWq6UCaLqFLkNpeALQmaLXm/+HsNyjCPKE4xePd5N5DMvK8YKx2NiJLVWOVQ3DX0qHJZdpEiS1WDhXkq+bA45YUQp6mBDND74UDGUnVu9kJvBOMt9tpeytcU08SCWZS+IKUBQToKAQwnJ6ZYepXn8SzgFY1grb1IdWJ83FxkGpZRyQ5dOftwYpoD2HbB0UB2iSa49Bz/9PwFiy33AyWEoCs6ZAIrBBe8G9wW2dUMWM+9+wjlgxXgp52/9iWVpULYu549GIcVIWxDWoQk5+n6PZFWTHYxpDN0bHwSSj1hZwRUK0HMDm16muFbU1ePQXe5QduIH+jm/ZLx2XCQ2/DYKrQWX8OZL++nEB2YeKoGBbBcOO6FXi0vBWpp2snvlpF/t4CM/IMYosKsgEehQ9WJRE4feEKpZDSfdBhH
 MWF17v4t
 pKDrj2Z9FgkO7xoVw2+0yX8UG74TAxqcDl4BOp1qBRNCA8kBLEFBsheuDeTbF03qp4YmXWt5fk/xFLF2FluC4Ccb4Ul1ItzfsEqEj4oq5bQ/N3YVfFJBWMEMNWKNDdo7iUhF0Ed4tvyP4xWeaNizWnSCBWlDsUkJfKLGCZ3uZKxJtZvWxeYHWuPJggOSIb9Dls4ozWPJbVe3BwBwj+DcSayYieP+ArpEsjNeFIt3v0ZlO3pr3P0wzWZUFVWxsEcTOZXX2IKRzWcrmVLZePlOJ2mKU1pIPPBGKDFMk2Wzw3JZAuCraFBnAww0ZcL5PR2hjxwYb2cR7lNclKCPy8oLOcrGfEZBSARyr75qUMia6qvUrppbHyWZarkwJ/ThhQb2BQaALq28WMt244Bh8yv17AsiB+P5RyTz7lNkZ+/xYhAEnEy7VfBmSBH4Rr7wVh43c1QIxgPpGwnH6FSIJBX9H+TnJ9AjNy1LVi7oKoQSgQvDbpxIkEDCLu0x1krfC0WN+p03i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ext2 export operations to indicate
that this filesystem can be exported via NFS.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ext2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 121e634c792ab625d7a07251e572e5844242fc2a..936675f06806d268ded5a3ba5306575c437ca9ce 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -426,6 +426,7 @@ static const struct export_operations ext2_export_ops = {
 	.fh_to_dentry = ext2_fh_to_dentry,
 	.fh_to_parent = ext2_fh_to_parent,
 	.get_parent = ext2_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 enum {

-- 
2.52.0


