Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C7BD232E8
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 07:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CABD16B0088; Fri,  9 Jan 2026 02:40:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F1A6B0089; Fri,  9 Jan 2026 02:40:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B037D6B008A; Fri,  9 Jan 2026 02:40:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9AF0B6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 02:40:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 122BF1AB0E9
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 07:40:46 +0000 (UTC)
X-FDA: 84311628492.14.96C51F1
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf15.hostedemail.com (Postfix) with ESMTP id CFC4AA000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 07:40:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767944444; a=rsa-sha256;
	cv=none;
	b=hhWULrxPUvQtjk1TDMsZF6onbhUOgwB0l2KxjkT6PyJ3LQvEJryAu6xyB0RzCLxLXTOA2H
	HKG7yC5yjW92oW4ubxBfyXiLtIAkXlqWguGh+7B8T9KKQit0rhkLCKp73u+xsbWQCInZ9F
	2kTJgUQnTfDP/UpCSYt1HNqnb91Ffz4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767944444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gRFBl535XJ21h48TaltTZ13zMho2nH839kUbC2YJflo=;
	b=V4qNJGKwubWWOShAQ6LY6RpqvJQos4RLDljNBxtRCsBd27iIWRozGYi3cPV6rDU4bJd2Le
	tKuh4TC+iV2GSifT3j14GL24cLhqPQkwM65+a4qFK5SOrS3fstdQZ5F3Zzp1Kv07D1YWZO
	6EfbveECrnhCc2/t76ki9btt8zmUBqU=
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 8503429ABE4;
	Fri,  9 Jan 2026 08:40:40 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 4Z-nBiPgjzSg; Fri,  9 Jan 2026 08:40:39 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 9463229ABDC;
	Fri,  9 Jan 2026 08:40:39 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ipM5fPbFtVak; Fri,  9 Jan 2026 08:40:39 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id C28E529ABCA;
	Fri,  9 Jan 2026 08:40:38 +0100 (CET)
Date: Fri, 9 Jan 2026 08:40:38 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, 
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	Anders Larsen <al@alarsen.net>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, 
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Jan Kara <jack@suse.com>, tytso <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, 
	Dave Kleikamp <shaggy@kernel.org>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, hughd <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, 
	chuck lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, 
	Matthew Wilcox <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, anna <anna@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-btrfs <linux-btrfs@vger.kernel.org>, 
	linux-erofs <linux-erofs@lists.ozlabs.org>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	jfs-discussion@lists.sourceforge.net, 
	linux-nilfs <linux-nilfs@vger.kernel.org>, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs <linux-unionfs@vger.kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	gfs2@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	v9fs@lists.linux.dev, ceph-devel <ceph-devel@vger.kernel.org>, 
	linux-nfs <linux-nfs@vger.kernel.org>, 
	linux-cifs <linux-cifs@vger.kernel.org>, 
	samba-technical@lists.samba.org
Message-ID: <218403128.88322.1767944438487.JavaMail.zimbra@nod.at>
In-Reply-To: <20260108-setlease-6-20-v1-12-ea4dec9b67fa@kernel.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org> <20260108-setlease-6-20-v1-12-ea4dec9b67fa@kernel.org>
Subject: Re: [PATCH 12/24] jfs: add setlease file operation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF146 (Linux)/8.8.12_GA_3809)
Thread-Topic: add setlease file operation
Thread-Index: Ijb4veyM6wDb0tIeqxd8skdz5qkIYA==
X-Stat-Signature: bir1jrk7oonf31yuxcn7apty3u1t84j7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CFC4AA000B
X-Rspam-User: 
X-HE-Tag: 1767944443-233153
X-HE-Meta: U2FsdGVkX1+Qm3bPasTHxdAkfdSLS6SUAD3BmEsov5yKPQj8h2VQN0Lc1/+YJpfWroTnOISix2p2df4SAYWGHj1yqbTnuQqXtrkjVPidc5p5yrKA7NWbyTuEv4xog1SXrhVWK5kwUQxgl77YayDi6ox8bfhJRUbNEIUUk8qG36rk7lf7+PTNLJHUa+4XuH0Brk1rGSc+Zy5z+qD0Bo5qNfS5TCojU9zsGHpBjwJcAj2v/mWJoa+WhAcDxwbNiMWH6X1eAYYkfhAgt/XPnv0lsubVrqgu5x+ehSiiDq1UB8vvJhyfS7I3tbJPxtt9jGW1fFAFlewMDWucwbCdgP9oYwQIYcG+VSAB4bEIHsNTEnw9pJq3dadvOZOwIpxntaBO6P5JNzGs2hCuQq7VmWL6lf+nEhbhjMFzdQUFcA0id6daPjKnRNfvAF3FzO/SNyERVxsXbJg1uU5eYp46HpIar2zUxAuM5IP0GpOmdhi9aGC0G1osNAYfedKmM6MUZj6IYBEdxNPu+pniFGIA9gIAYjNMVnKuGg6VjmhLwBALEv2Gj0kK9KdVN2JbAZYE+3C6vp/+zCPez7fbq95Gpb6624XZ36OBlfTCgy5mb0lxqD85YNIonhXYtOtvM57lMlP3ASCM9mGfTxrC2C7A52IcFRbTFu7k4HvWpyWOmJtkyE/1fuv67zoxDlWPNyeoOII6i8suiwuAFdjCDOpJi2x+li3sQ11to06RCmjMvSvROlUtX8BDYTRQTgieJ1FbGZz2Na5ibhHqcNel6zWuXNHXGBqPJrb8/hL8MS5COXWui+n1SrrXrdwodrsso9OkCtjmudAwAJMj9vEQ/E/Ww4lUGwTzdS2Cdn9u23oR+KVBOPxJ+X5O3QzjLx4Curyd9mb24VHL4Jm7WigK76/615a96/sneFb9TR7/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----- Urspr=C3=BCngliche Mail -----
> Von: "Jeff Layton" <jlayton@kernel.org>
> Add the setlease file_operation to jfs_file_operations and
> jfs_dir_operations, pointing to generic_setlease.  A future patch will
> change the default behavior to reject lease attempts with -EINVAL when
> there is no setlease file operation defined. Add generic_setlease to
> retain the ability to set leases on this filesystem.
>=20
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> fs/jfs/file.c  | 2 ++
> fs/jfs/namei.c | 2 ++
> 2 files changed, 4 insertions(+)

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard

