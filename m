Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E54D1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4306B0095; Thu,  8 Jan 2026 12:40:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471A96B00B6; Thu,  8 Jan 2026 12:40:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358CB6B00BA; Thu,  8 Jan 2026 12:40:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 265916B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:40:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70A79B74C3
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:40:12 +0000 (UTC)
X-FDA: 84309510264.13.EEBD577
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id E6EDF40007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:40:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v6o0xZII;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iQxzzizV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v6o0xZII;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iQxzzizV;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767894010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbYulziCehk0+dq0CXHXUlJblsepps/x0pBz736+F88=;
	b=Ok35QBIpo019md/LNF7d3KetTvoia+jrQs6DVfwpV9xblVLfoBmixFnhmqx29h//C6UwkG
	oWZ/IxvYE6tD8SgkkpWag5KU16KUCq4Cb/MX0G7RYsfHax8lhR1xIvBMsTZSBP3PxlLltT
	VUKb8hGV1s1byAhOC8yGdXhZTyELwoQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v6o0xZII;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iQxzzizV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v6o0xZII;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iQxzzizV;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767894010; a=rsa-sha256;
	cv=none;
	b=XZ5Pa3Vz7OAjPUPGOVl49eXw0NztkDnX+Ui3M62l5cmMX/+EBr4WpvIv6xvAd2MEyPF06l
	rqhIvwh56ccWKWI/peM3crusUVhbOiJpc7QPxU+0RNK9Kpjq4ktSCUUkv9jd4gTtRUuKAc
	cfV8x91hF1rx0pcE5fpYAV0ufR2nGGU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 60DD85CBEA;
	Thu,  8 Jan 2026 17:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767894008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pbYulziCehk0+dq0CXHXUlJblsepps/x0pBz736+F88=;
	b=v6o0xZIIolBq3Kc+VF6+9Ya5E6t2G34FsAJ4qlruIPlrp3yRFZ1mosmLKssOtf8GopFPv6
	pdM5KNdg6uqkpzJC2OCiQs93p2MdVtM1C1AsH2TngC8tV9OjZ7anbkGl2iE3fhCSU9mvhX
	K1VxnfPudBQRQJ1Q1ovU0oM49Yj5Rmo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767894008;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pbYulziCehk0+dq0CXHXUlJblsepps/x0pBz736+F88=;
	b=iQxzzizVuPHl0WVwxtpKrivs8r+dbY1HBg67emHdQ+8PTu3CciNeemY/i1L/NaN8QOR0LX
	w4waIzEE2aIOLGCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767894008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pbYulziCehk0+dq0CXHXUlJblsepps/x0pBz736+F88=;
	b=v6o0xZIIolBq3Kc+VF6+9Ya5E6t2G34FsAJ4qlruIPlrp3yRFZ1mosmLKssOtf8GopFPv6
	pdM5KNdg6uqkpzJC2OCiQs93p2MdVtM1C1AsH2TngC8tV9OjZ7anbkGl2iE3fhCSU9mvhX
	K1VxnfPudBQRQJ1Q1ovU0oM49Yj5Rmo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767894008;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pbYulziCehk0+dq0CXHXUlJblsepps/x0pBz736+F88=;
	b=iQxzzizVuPHl0WVwxtpKrivs8r+dbY1HBg67emHdQ+8PTu3CciNeemY/i1L/NaN8QOR0LX
	w4waIzEE2aIOLGCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4927E3EA63;
	Thu,  8 Jan 2026 17:40:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MFPYEfjrX2kUBAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 17:40:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0782CA0B23; Thu,  8 Jan 2026 18:40:08 +0100 (CET)
Date: Thu, 8 Jan 2026 18:40:07 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, 
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
	Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, gfs2@lists.linux.dev, 
	linux-doc@vger.kernel.org, v9fs@lists.linux.dev, ceph-devel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
Message-ID: <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E6EDF40007
X-Stat-Signature: hwb5cgtca9qz9afje7f6es5g5da7wjfk
X-HE-Tag: 1767894009-205240
X-HE-Meta: U2FsdGVkX1+GZHHFLwRZy77qXx2gemTLhIsdqyon6Wl+iwOWmpcVT0IdcTP8XbaAAX7nk4xUHhlDvqa6Oclzz/Rv6vAMgoevUW3fodAwgsM2Jl6Pn9jJrRIs671h14GwBzJSgQB/jwCukfMcCln4yz4r27jU8yoLcY+KUVo2sNmb7bfH151V4UsaZ2wWTTvIqyXDKJWoFakR/bapUmBELZ9zdl3xMu6IhKGq006pigsoKJJUfdURW/l+n1PAQDeaLbCWMizCUp+9n/9SAmsLCNAdUKNx6A5QVXlCG0m+74d6y92DNlqe8E+/P7Wnyw3WPXtHryIN7e33gfne7tTOILeana5xBvhDx1DEB0HYmJF7KGkulhvc4InZIwMfLHLtnc0KspYez5YmkWKpuXuDZVxjBdlAfd0RPO/6TpOxuPunxpcUPe6SZhm4IA01hUf6MgIZTJ9/fM9OsyLnRyUmllXY6BbzBfYx9P2aSB7oB84X5QNWR0Yf5UFvsGT+IukYXlEFN06FXR5k+9vR20HcpV1T7c8w4v8N5y2hkZyu4V5830PkZRu5gCYdO8mA8rOpDstYwWn13LOO5Hpn/7BfxzZl1I16wkMipx8+6b4Fw+bzvpu5jk2Zhwbbbam+0UN0jjvc11dQZYcdXrxDQpLFcBeBqEBcdNeqhIRijk/cciFlBgbKakLbraBVYqFgA7WwRx22PyJ+XM7P9YqiNdQxerJGkCFdCQWcIBZZsC1A90zgv25idCcw6q37d3Yl20fjiMMGUXIH3jsxr2iVM+3/u8JdHLS3851ux8eH1AxtVxZC9n6Gq43gjcMkEQEy5/Jo1IBB4R+3TSxuQLw1I90WQEfxNQj/8ynTEnmQwP3p8/lmMXogX6W0TywQ6UcA/QmP2kFTNtPJD2U6rjTm2j+jZBh+LKDY19v+y4jw3pkaR64SRuWLdfBvMe2CGEZiRY59lvQniz6CN3eOqFuoIAH
 pN0YuxAm
 roo3WevtZaompADp0Q3BCi4zOjPcwWafbzL8hVYAsC+gN6hDU9G/0CN6+xS63lBZdUFIRa4tbDzVjMW1VQ9dCUkLxM0v8R906CC9FYv3J64x9RNoe1qceV4agmKoqIKHdzm8BwyCkJJwQSUC0WLdKdP+6OzycrOrRh/D9+TJVlAMlEk0Qhbb6yUHTGl+1hswMURj4pVJuy/+S5XYWAU+w7UlDN6NQvKMWr8EUelQh63Ycq26dV15RvcG3R2N7CYnxqDXYLq+x569qHoad13id4gumFQFMQ+7sMUDC2W9WLx2jIB16w11bNsifL1sklV6qmEdT0g4mXrDIxUaH3EzYwpanar2wDxdSF1/dw+w/cUenKMYcdNB2CpNPSCteq2+EdkTleDfS9brHrMqd2wJMvcR1d0IZkBBvDilFI9RdGyMrEv0Z0sc8VdnVqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-01-26 12:12:55, Jeff Layton wrote:
> Yesterday, I sent patches to fix how directory delegation support is
> handled on filesystems where the should be disabled [1]. That set is
> appropriate for v6.19. For v7.0, I want to make lease support be more
> opt-in, rather than opt-out:
> 
> For historical reasons, when ->setlease() file_operation is set to NULL,
> the default is to use the kernel-internal lease implementation. This
> means that if you want to disable them, you need to explicitly set the
> ->setlease() file_operation to simple_nosetlease() or the equivalent.
> 
> This has caused a number of problems over the years as some filesystems
> have inadvertantly allowed leases to be acquired simply by having left
> it set to NULL. It would be better if filesystems had to opt-in to lease
> support, particularly with the advent of directory delegations.
> 
> This series has sets the ->setlease() operation in a pile of existing
> local filesystems to generic_setlease() and then changes
> kernel_setlease() to return -EINVAL when the setlease() operation is not
> set.
> 
> With this change, new filesystems will need to explicitly set the
> ->setlease() operations in order to provide lease and delegation
> support.
> 
> I mainly focused on filesystems that are NFS exportable, since NFS and
> SMB are the main users of file leases, and they tend to end up exporting
> the same filesystem types. Let me know if I've missed any.

So, what about kernfs and fuse? They seem to be exportable and don't have
.setlease set...

								Honza

> 
> [1]: https://lore.kernel.org/linux-fsdevel/20260107-setlease-6-19-v1-0-85f034abcc57@kernel.org/
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
> Jeff Layton (24):
>       fs: add setlease to generic_ro_fops and read-only filesystem directory operations
>       affs: add setlease file operation
>       btrfs: add setlease file operation
>       erofs: add setlease file operation
>       ext2: add setlease file operation
>       ext4: add setlease file operation
>       exfat: add setlease file operation
>       f2fs: add setlease file operation
>       fat: add setlease file operation
>       gfs2: add a setlease file operation
>       jffs2: add setlease file operation
>       jfs: add setlease file operation
>       nilfs2: add setlease file operation
>       ntfs3: add setlease file operation
>       ocfs2: add setlease file operation
>       orangefs: add setlease file operation
>       overlayfs: add setlease file operation
>       squashfs: add setlease file operation
>       tmpfs: add setlease file operation
>       udf: add setlease file operation
>       ufs: add setlease file operation
>       xfs: add setlease file operation
>       filelock: default to returning -EINVAL when ->setlease operation is NULL
>       fs: remove simple_nosetlease()
> 
>  Documentation/filesystems/porting.rst |  9 +++++++++
>  Documentation/filesystems/vfs.rst     |  9 ++++++---
>  fs/9p/vfs_dir.c                       |  2 --
>  fs/9p/vfs_file.c                      |  2 --
>  fs/affs/dir.c                         |  2 ++
>  fs/affs/file.c                        |  2 ++
>  fs/befs/linuxvfs.c                    |  2 ++
>  fs/btrfs/file.c                       |  2 ++
>  fs/btrfs/inode.c                      |  2 ++
>  fs/ceph/dir.c                         |  2 --
>  fs/ceph/file.c                        |  1 -
>  fs/cramfs/inode.c                     |  2 ++
>  fs/efs/dir.c                          |  2 ++
>  fs/erofs/data.c                       |  2 ++
>  fs/erofs/dir.c                        |  2 ++
>  fs/exfat/dir.c                        |  2 ++
>  fs/exfat/file.c                       |  2 ++
>  fs/ext2/dir.c                         |  2 ++
>  fs/ext2/file.c                        |  2 ++
>  fs/ext4/dir.c                         |  2 ++
>  fs/ext4/file.c                        |  2 ++
>  fs/f2fs/dir.c                         |  2 ++
>  fs/f2fs/file.c                        |  2 ++
>  fs/fat/dir.c                          |  2 ++
>  fs/fat/file.c                         |  2 ++
>  fs/freevxfs/vxfs_lookup.c             |  2 ++
>  fs/fuse/dir.c                         |  1 -
>  fs/gfs2/file.c                        |  3 +--
>  fs/isofs/dir.c                        |  2 ++
>  fs/jffs2/dir.c                        |  2 ++
>  fs/jffs2/file.c                       |  2 ++
>  fs/jfs/file.c                         |  2 ++
>  fs/jfs/namei.c                        |  2 ++
>  fs/libfs.c                            | 20 ++------------------
>  fs/locks.c                            |  3 +--
>  fs/nfs/dir.c                          |  1 -
>  fs/nfs/file.c                         |  1 -
>  fs/nilfs2/dir.c                       |  3 ++-
>  fs/nilfs2/file.c                      |  2 ++
>  fs/ntfs3/dir.c                        |  3 +++
>  fs/ntfs3/file.c                       |  3 +++
>  fs/ocfs2/file.c                       |  5 +++++
>  fs/orangefs/dir.c                     |  4 +++-
>  fs/orangefs/file.c                    |  1 +
>  fs/overlayfs/file.c                   |  2 ++
>  fs/overlayfs/readdir.c                |  2 ++
>  fs/qnx4/dir.c                         |  2 ++
>  fs/qnx6/dir.c                         |  2 ++
>  fs/read_write.c                       |  2 ++
>  fs/smb/client/cifsfs.c                |  1 -
>  fs/squashfs/dir.c                     |  2 ++
>  fs/squashfs/file.c                    |  4 +++-
>  fs/udf/dir.c                          |  2 ++
>  fs/udf/file.c                         |  2 ++
>  fs/ufs/dir.c                          |  2 ++
>  fs/ufs/file.c                         |  2 ++
>  fs/vboxsf/dir.c                       |  1 -
>  fs/vboxsf/file.c                      |  1 -
>  fs/xfs/xfs_file.c                     |  3 +++
>  include/linux/fs.h                    |  1 -
>  mm/shmem.c                            |  2 ++
>  61 files changed, 116 insertions(+), 42 deletions(-)
> ---
> base-commit: 731ce71a6c8adb8b8f873643beacaeedc1564500
> change-id: 20260107-setlease-6-20-299eb5695c5a
> 
> Best regards,
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

