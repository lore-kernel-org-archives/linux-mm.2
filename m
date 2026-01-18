Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B47C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 15:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA9A6B008A; Sun, 18 Jan 2026 10:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8116B008C; Sun, 18 Jan 2026 10:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9FA6B0092; Sun, 18 Jan 2026 10:36:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC9B06B008A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:36:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7FEFB1AECAF
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:36:10 +0000 (UTC)
X-FDA: 84345485700.13.FD4904C
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf01.hostedemail.com (Postfix) with ESMTP id 12B754000B
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:36:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768750568; a=rsa-sha256;
	cv=none;
	b=xOZbI2yiENJzWHifCLVEmx5s6MzA6mHHUMexbiEAmBbgjJXJ4UjUnaEOmNV5NDZbZNG8NO
	SLiXsA9e2PE0LAQKEdh/hPLkIS49i7/wRpaY8oasMb8ItGta1JyjeDVwo0PDCAcOqTi9CZ
	GgCMfFx1Oj+nch/itFbsLNcdsvJyWIc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768750568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7o8IJfB7ac3jZiXayX/iEYSCvbbdHx+mVAVSDEiNdGc=;
	b=hKZ/jiZtb/bX8ehuUirkB7ZQ45jC7Y2TKo49zs3y/6wNyT6gzpkGN5TthDa8e36It/UHuS
	Rb99v3EgA2FzEZq2wPrqcVHjTDNKNE7zoC388oSE75fbWjnEqkGrxWiXJvG+I1+CU7B46t
	aeOg32v1siEqFzZLlPgN24XW545QpGo=
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 5FD812918DC;
	Sun, 18 Jan 2026 16:36:05 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 8m1VPN69EFg3; Sun, 18 Jan 2026 16:36:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 9E0B129859E;
	Sun, 18 Jan 2026 16:36:04 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Qm1VWoKnABQg; Sun, 18 Jan 2026 16:36:04 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id 04C202918DC;
	Sun, 18 Jan 2026 16:36:04 +0100 (CET)
Date: Sun, 18 Jan 2026 16:36:03 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	chuck lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Amir Goldstein <amir73il@gmail.com>, hughd <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, 
	Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, anna <anna@kernel.org>, 
	Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, 
	linux-nfs <linux-nfs@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-erofs <linux-erofs@lists.ozlabs.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, 
	ceph-devel <ceph-devel@vger.kernel.org>, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, 
	linux-cifs <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, 
	linux-unionfs <linux-unionfs@vger.kernel.org>, 
	devel <devel@lists.orangefs.org>, 
	ocfs2-devel <ocfs2-devel@lists.linux.dev>, 
	ntfs3 <ntfs3@lists.linux.dev>, 
	linux-nilfs <linux-nilfs@vger.kernel.org>, 
	jfs-discussion <jfs-discussion@lists.sourceforge.net>, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	gfs2 <gfs2@lists.linux.dev>, 
	linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>
Message-ID: <2119146172.135240.1768750563673.JavaMail.zimbra@nod.at>
In-Reply-To: <20260115-exportfs-nfsd-v1-23-8e80160e3c0c@kernel.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org> <20260115-exportfs-nfsd-v1-23-8e80160e3c0c@kernel.org>
Subject: Re: [PATCH 23/29] jffs2: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF146 (Linux)/8.8.12_GA_3809)
Thread-Topic: jffs2: add EXPORT_OP_STABLE_HANDLES flag to export operations
Thread-Index: pUsbo+Kg1d9ytlyubsob1wi+Ql8B0A==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 12B754000B
X-Stat-Signature: zi1gjibqioaj79cmoi3dwrj5rcixgdi3
X-Rspam-User: 
X-HE-Tag: 1768750567-148527
X-HE-Meta: U2FsdGVkX1/clC6hsO9CshNsPb0XgreSQxXBtqEUmhjIH8YTdZiRpYw0ULCJl3AKsMXS8V3QMXeUzYS80dUM9dUF2OMZcpvIMCW995nECURQTlaNHOp+RtCAGy8kniGjCTnqEEqdnLmmAbbr9wuwChn2dyecvgQoZYRfgDLV0PGiIZl6zB8CDqY7EtQNDtddLUcccDKhz5kwyz4Ibspm9PpJRU4JSlTi5VnK7F60ySulosZcUcliHSxF3nH32vCUMJqeZ0HExmP5Xb8rGyOYYD3JWImw4P2K3K9g2z+qW/XlS+XvQqjmgRs7gnAStwvKUsRlEVv4oRiCJAOhr5FX/BofnfORnuno0nhVNC4suRD/xTBGgjtDxpUoOPK8nX4wcUhab1QBOEtwv8nqROb+slBQiOxFjuZsjQc2m1ljXyLgA6cvijFhfs6S8MKcqpyZMfoXbqjPY7Rh5NuZkfJKpO+A4yNoj1prAFMRzsUdG4JKUHmyjdS+OR7UjATGbwfqLqweONZfiHprsTan5RqwWe3v2zkvOvmDTqLqGRfxiCQdGFoWb/ib06jBy8TJZM3dbbjTxtHKZX63L9zuDIb3yMuKcGKZpItuY8iEsC2kLx1lvkef2LMlQhw1EKvxBZ4Cw/3asVVvkeQG8Qp+KXSV5DVpiocRfeIrdWH3H+thP5jOuSEKwe4z20t4K2p11JRweLqa/IeZ8chUNaxHecsyX70qR0fw+CAMHv2IPOFye6JLJeQWhnvegDmlQ6+ckZMDVDem5eNgyd7kK6HUl7e2KzS2eCInh5kxDeWCZLvK4Q6deoAWqvhH8e72/9POfchjsx4E3sxmeXMyPKhfnSEosHFV7qUzu/PA+EnWZUcrt89au/pTU8jA3aZwiLbjfihLdHY99zqVFEFdt8Ya4m6BR4UMt8W2YKj3B2Q3RTYa6ear99OPz0r0IU+ers8h2miuF6WMPIeSF//Sovrob8T
 RzSyJfIB
 jDP4TtV7W8zH/WOdaKXwxnVKKl2jeDULVQBkxob5NAIAeEoCqNo70NYWLUBuzmaoc1pexY1xBZvEB62yHT8qJe9dRATDgA9IDQKK6rgqcSBuu2/vzK1MSF3hsxc0f1fDQRK8j62Xrkat9/ac2dXlhC2+1ttVjtUOwK19uxZBpvNFs32uhzRvPhM/DAlP6s1iqh4sfp/SZAcUcGbkDiiJk/ekVE51a5O3Lyfi/KklN3CY00d26WefSIDgp+BZXLpeO8Npa617ymPtk29Wer7E8VSsEh1NziV8sr2BlJOWiBfJtmQ1+fiLetlXeRHAuRlq9GFUx0Rb9RG4qlfUaURaCKuzY/indytuhnjlYAnnFtqWrnvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----- Urspr=C3=BCngliche Mail -----
> Add the EXPORT_OP_STABLE_HANDLES flag to jffs2 export operations to indic=
ate
> that this filesystem can be exported via NFS.
>=20
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> fs/jffs2/super.c | 1 +
> 1 file changed, 1 insertion(+)

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard

