Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF0BD46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3DA76B00C5; Thu, 15 Jan 2026 12:50:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11D66B00C7; Thu, 15 Jan 2026 12:50:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2BD06B00C8; Thu, 15 Jan 2026 12:50:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A24AC6B00C5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:50:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBDAC140428
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:43 +0000 (UTC)
X-FDA: 84334938366.02.0C457B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0F400160004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:50:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vDbX3mGa;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8pOkEdlPgmNI34dyIZCKB6VF8ZglgCh5+XdxlfbEXzk=;
	b=T5Ur1LQ6l8ddmB/c3n09uHqBt1uvI1VtvLYOzHTnH/A5dW0GXI3yES1yZCRRKRjuNfgqmN
	33HHVfb0vjbw++fCEAVnOcRDhHy5wA87LO8WX1du/GhxWc9qVDO90PENwh26zob3nzCW1R
	aDqpFEnxNfRtmluZZxlKeY59wG54rXY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499442; a=rsa-sha256;
	cv=none;
	b=Wd64eZrO6DVCaoKY8ehXcuz5XwLU4MxI+wsdYh19jM6JcnRNqpwZpdmc17Q+qRhOB4YMVl
	/6efNeKStC50auCh2TNC9W7569UctBwPhT++GTon71u2bwVtnbHwZ/dpPGJvpXq4+SfvWm
	lChcwJATn4nOf1ua7DMJ75vLnj7oRa0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vDbX3mGa;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7556C60167;
	Thu, 15 Jan 2026 17:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E44C19425;
	Thu, 15 Jan 2026 17:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499441;
	bh=i+7my1hIKzN4dEiJBuVJ6Xq5R7300GKAIzUA6le5LwI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vDbX3mGaV3J17XgmaClvzPrir7rcZ3244jEyEMkg0ulRRJHe2lzEsEsl6v8ITObrV
	 WvkOhbgNaFo0/WL1grmWsd9hNTGlelkodJYte8X5Zfy6RlEbAVoND5Tq6LyWEqSfuz
	 r0YrXIL6lkDuTdzPDLpnxOz7z6Wh1fE6c9RhzNESyCG5HWxL0omGNAUy0P3QJIDwYx
	 oPZdKHZUG6U3Qkk2i+a1Gk0Yd1/Q76deryInYPHiVrIL7A15tmkN17tEIGtuwpAJmE
	 HoSOOj+qtSeBvhBwA86v5yb2oCgnDtqWCqqSQKXfOrWy5Kfo/GtlsuNj5uXjdW9Ezs
	 PR8uNNzO9mghg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:55 -0500
Subject: [PATCH 24/29] isofs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-24-8e80160e3c0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=697; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=i+7my1hIKzN4dEiJBuVJ6Xq5R7300GKAIzUA6le5LwI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShKBTZTAVUXXqyi6bJrxji0XIyjkD7JqQZY6
 wonbWMv0LGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSgAKCRAADmhBGVaC
 FUq9EACyr/b3KvTajXKKWcsw4iTSig7acGp/8un3L9dhMH4MPBenFoJ9AZtBo9TOeulQUWODwV5
 d0cHtwgvOQyQ5BYykoPeKH3Klf7jh974vbAUu9wNUoufhW31N1yHvp98Hw+1KjoJBj8VEd7xrX9
 UklYejwsyZtn2s0Y9hw+wdkywLFwHe1wdyRKYh2ayx657SSRqjxH18TcmTGkf23E6UiM+CM0AVy
 uFtyUv/kbGeSxYJs/4Y8x9T/gZ6Sth6DCZB3Cs7pJkBXwrtyvZTW1gD77G9M74xXIAWsxDJ8Eyt
 P46Fgt6ZLJlF31KqAGaMdsAQPitvRXAnImogjK3VhJX1kibYdHlLAU8bXjGOs6YTLyNpmLfulQT
 nFWxdkYrH8SZU8AcRZoM86AaPxosuiValXES5vL1ZGcW3dCh6Fi4BCuLqNiWtpCgMr3+Uzt2r22
 Phlyrr58r259LfLhbyZ9qeym2OKdm47S+FTpKKlEK68rS3/9mHOR8GdsY0AtTX3Y0rLb+LXfWtb
 MomTNKAZCecJIvoHWpsKO6lcrok1r1PZo21H11IAheF+wwmQuoVer+ihSNb/2rOutE+Ow3+K+rR
 HoHCt0GkoR97A9lJJVP6yvgQl5GmJ5jMsLZHHBEVl6tuCuNO642t+/h+BMzVGVlHNCEDNiH8aJR
 +8vy+LDJemHgrzw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F400160004
X-Rspam-User: 
X-Stat-Signature: 6b8ywkhu7tcbxyqk8y99fgxtaimktkid
X-HE-Tag: 1768499441-263901
X-HE-Meta: U2FsdGVkX1/DEviQuC6feXFys2onQEtasSpE3E4kas8SXkd4DElXEyJL0cXvT7q6Q5GSUfxDTSEtaxST6S91rDZGrPB45pu6+iiKBP3zp7Zs2ilp+9BcrcW0HNpCkKtdSY0ZVoeZRWU4wzZnnMAv7cc67MNHp/nhj1NuVNrFrAISvMH6dHcThst+vCSglyEfxNpFKdaswBAoGL05G/2uVcOaB+vdHtl+QsCvPi89Y1/IeMWryCyqc7AN67dWxw9FbNUztce8YiKFh5b58IvsXx8kKy0GzwfeE9LF1EzNA+ilECNG+Psari7jkAxZPc/DGeN+kk5nKCb3MKrOfQVLmceolhSmV8aXknPCLmHUye3cwjc0Wf90wgw5CCP2zqtqy2XotRX+RUboTw/RxlWrRwTQ6KnhashNhWhKJX0nY717q8x7Iz5HvxE5qcLZERSd9YiwjdAkSXmD5v/Y0c85OItk9uX/arwvOvTChdOnVd1kDfA7+Ro8TgD/Cyz5OrDXx9bpUzwnyMRBIr4kWHmvU6pUcWijZIoRqA7muvVK4+8PrHSeej4o259cDyCcG4Eni/WDRqlON7XLWQRA7r2JHEFSOxXBrjER/+4rpF21/LDti8iDaiuST8NdZZJUjnwPL+WHGKAD3D0yNUtolNeOtwSua48ior6hJ04EUDq44PVM54ka7s3cZDso2QUDehgy8qR0rbBkgwFvbliwQgt5TU7JznrdPRm4RSuf68GV3e6LROb3t5WyRb/dG4i1QrpRRROKbGGW2yOekFYIiutcM8mHBsJ16CRsEkrA/WSvDGJk4fOFsLhrrT1Ocl5LfVj6AzgM96IpIkhUAqn/7yzpMvANPKGuKo7zd8RTfUEpy0s8dwUVwgEMjyigdxdhvCVbiTaQJcsrVs6kKJJ5ui66klb1J+LDebJ2nJOUzoPeWlBRxkC1r2ItbzXccyMHFodv1XIPLa8Fs7GnhdYKCVQ
 DDG8se0s
 mxII4y6UnpLIDZxFGimrjBkRllR3Ao+xwJH21RNJL6rElwfqGtNlo+P4ha8cpiDEhDNeQa39ZbZuJQfzm22JbtbFZFtGlc9J/NOtgd9IpfGLjcNnAhFLFHCHy9c1YZfId9LHONbx0xGJzAPUYZUmMUdz2VU4llRktIhZKY8j4T7oyqBLpQ3HYjKOBlrLOsVzxLx/BfenuVzzRVn2NRPHXRIrILczF518NYyLhjc7EtA0MxKPlEI5r1b6b3USx6RH5dZwpwkY4+Cnn4Lj+QXjfvnQiDOh3Vc1DCAyYSneMmKEHA9Tz3zm6sWxPdBIHIhQbwc+uiKU+ILmV2s2//SIx1axaEnZcmtYBX7T83OPk8TwbIkHOw/RSBZXOMa2US5gAuHbQTohj/mdWlTU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to isofs export operations to indicate
that this filesystem can be exported via NFS.

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


