Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08833D26D97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 09:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1535F6B0088; Mon, 12 Jan 2026 04:49:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D83B6B0089; Mon, 12 Jan 2026 04:49:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01746B008A; Mon, 12 Jan 2026 04:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCFFD6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:49:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7220B5B1B9
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:49:38 +0000 (UTC)
X-FDA: 84322839636.27.530956B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CA13B100004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:49:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kovjAz4K;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768211376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfekXN2se1alUjSsCk4xdLnYVKkV19tWJ8Jv/yRkuaU=;
	b=vHYpA1PEzIGCwdZyOwRdZ2fKhRUEiz81VZxcrchcZDdWk5fMK3Fyi1F8sDVIGf0mKxmj98
	xwprnjnAxHtTcQ6kgc61pEpjLzDlnYXMPV7DkTbPpP2oslZRuI4r/md/Sjf1vZIX78H3UR
	uiZMbXohaur8Re0r+K1idwU7dc73mXQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kovjAz4K;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768211376; a=rsa-sha256;
	cv=none;
	b=ndT3P8ZIoqf8sJeZ+DuGQ3nFj4xXRosofpvwDwxZLJIYdbO0z8gdszEZdfS/YVDiu1yyMv
	qNBbM94/gLRkNpEWhfu3aw5G+ZTFR4QoS1W+uhP27dvzGu9TYia0wRksKXo9xKHpikAe9F
	VaIcsYKVLuI3bnYmx80c38iEvJCVb9o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 217D86013A;
	Mon, 12 Jan 2026 09:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD38C116D0;
	Mon, 12 Jan 2026 09:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768211375;
	bh=m8zAICgnxs6xkW3AmfrwI3a0ispTdY6AQGss0vAXdME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kovjAz4KC5mAD7YrC6t2czYMjBWRcZIetUzNRdlwl4Z1rGgyp9glYOLbnOZypWAbx
	 YcmUJCp6E8w+KmTy2i5WzHpX9fHwe2RpJgFtTNA95cnxyqlkjOQ7JUeU62APvVqkZH
	 Y3/3WTlqh+tsw7Ls6NjRbDo/fUnqsYd/eTTthVLhPJ/V7Q9k3YIeMunOn+RktLYgES
	 ul3EQIBMmxhQ+r6sMjogrCPwB0I4vKTgz3PxtAbmBEyff/p4uJORPrLFe5LDSB0Hni
	 RZIrOX4UDngsOGqfziwhf24VBmArYe5xbo5TLnA7nB4zBdXfiNr6kFAgXt4Ej7biQ5
	 RxoAJIZnapRSw==
Date: Mon, 12 Jan 2026 10:49:16 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Christoph Hellwig <hch@infradead.org>, 
	Anders Larsen <al@alarsen.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
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
	Phillip Lougher <phillip@squashfs.org.uk>, Carlos Maiolino <cem@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Chuck Lever <chuck.lever@oracle.com>, Alexander Aring <alex.aring@gmail.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
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
Message-ID: <20260112-gemeldet-gelitten-7d48bae7ef3f@brauner>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4>
 <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
 <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA13B100004
X-Stat-Signature: 6u9jpb1tpxqytbu95qawq83g5cyfuggm
X-HE-Tag: 1768211376-747034
X-HE-Meta: U2FsdGVkX1+fR500yiSHefaauKvM5orEY3iVYVtVil+X9bV/h/z8cV1fD/+nMD5oD8uEALTzLa42vzzJ81NzBUpsEsuvWSKD/cvEe2CFMy48q5UeQql2kijoL1wcuf3mclRGP7W1Lxix7GTy3qv+LUexxgrjp8JVLvdQPZ+tInBsPdK0h11yD6P7i4LtfK4y5G7F2h4Bzfkkiyx54DTmLFnDlP6Iw3tfaKbzd4QiJOU9cxi8mR6BsofMZlE8cRWhwGN1jzduGazlTzS/GFMVTKpkP9nAmvwlQ8uD9Tz36ZU7EgNQNKmGBbQSjlDsD5nmVkVGpZTWbqZQk6itvmVkVWQws9BtXhpJ1KgIW9+oIH5xq93z7fSkfA9cTmwya3SVqicvI5nLFgrbO93KntOJiTeuyBdaOI/tjyG8Dtfv4TFd6S0q5JvpFIlg9M/1/pzshF5//EdmeSIycjuPyaatjFoOePSI+Hmhb/g44XJfVi8Len0Xub1lnGyecNGx2LB/d4S91r9jYyQHIw0PB3GvaNBt4UKTly96J/z8ybl88iJkrtGIkr9CUJUcAIQPS80TWPZA5Ijon8stETyxECxl+8teNTqy86LqLJZUsFoqSefLlrWemu9/+kU6YOgoBizKH3YQ3R/nXJHAKPfr1OpVl+syu0BsspWmRCmoqjBRJw6zBYT6dFC7RG0bzVJLzKKjix+IzQ/9YCaPuXIO4BI3UkPeTMzn/sQ0jAgSR96y0t69E1kfpnOnjqyM5b7XHF1W+aJqjZOkAAVVt8YLWBEN5FSlpNcAmo3xK4GD2/HKlPxjqvkXdsduKNSD+M1LLnSlKxJKtfcO4vTI/WYqbOCOEVg4iQ8FkYrMDIgMblPdHHk5CVeV00XL+WAA0zYdKEhZyNF44DCLsB2wwmT2CaUS4Z2UqcOVfiKjo4KLogLS5ycS05Trf734ZOLNyCI3zQGO/1/RjqhoMIXsZoL9qLs
 OjC/sUtR
 O/IWN8fWVMy3C6/HEcaZ4cwSeFHm8aHLQRGa6EfSZn/Ou/pLVNE3aq7AeQZinb7iDMci1/rcrQmmmx+3UGhPow5OjH01ot8DqhpagURP7ZDpGLLhXm6wNsR2ZOG5IDh0BrA/0Qu4ww3RcsdRvmD5NdeANTZrYDAfuZc+HW+50vjFiAV9K+w8NcvgcfBHzIkEAtbRT8ft2FONhWJDx4W+KGeAbDVQDJf8hmDBV5Fyn8bMqV/fNfuvlgoiw3NV1XSEO0ke4sVNJTtt4eVEvm2e2e5a/HNaLnLy+PPbbirnJ/iIl3R0NCpLb4VOl2VX6u7FtQYgDLCy6+clYsea42iduHv0r6P4WEc6Mz9KobArXETq36PxfwWndJpd2r2JuCkFrxKlY7gMu6S1Y0+Hgm5ThY4euXhv78KDBclkb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 07:52:57PM +0100, Amir Goldstein wrote:
> On Thu, Jan 8, 2026 at 7:57 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > On Thu, 2026-01-08 at 18:40 +0100, Jan Kara wrote:
> > > On Thu 08-01-26 12:12:55, Jeff Layton wrote:
> > > > Yesterday, I sent patches to fix how directory delegation support is
> > > > handled on filesystems where the should be disabled [1]. That set is
> > > > appropriate for v6.19. For v7.0, I want to make lease support be more
> > > > opt-in, rather than opt-out:
> > > >
> > > > For historical reasons, when ->setlease() file_operation is set to NULL,
> > > > the default is to use the kernel-internal lease implementation. This
> > > > means that if you want to disable them, you need to explicitly set the
> > > > ->setlease() file_operation to simple_nosetlease() or the equivalent.
> > > >
> > > > This has caused a number of problems over the years as some filesystems
> > > > have inadvertantly allowed leases to be acquired simply by having left
> > > > it set to NULL. It would be better if filesystems had to opt-in to lease
> > > > support, particularly with the advent of directory delegations.
> > > >
> > > > This series has sets the ->setlease() operation in a pile of existing
> > > > local filesystems to generic_setlease() and then changes
> > > > kernel_setlease() to return -EINVAL when the setlease() operation is not
> > > > set.
> > > >
> > > > With this change, new filesystems will need to explicitly set the
> > > > ->setlease() operations in order to provide lease and delegation
> > > > support.
> > > >
> > > > I mainly focused on filesystems that are NFS exportable, since NFS and
> > > > SMB are the main users of file leases, and they tend to end up exporting
> > > > the same filesystem types. Let me know if I've missed any.
> > >
> > > So, what about kernfs and fuse? They seem to be exportable and don't have
> > > .setlease set...
> > >
> >
> > Yes, FUSE needs this too. I'll add a patch for that.
> >
> > As far as kernfs goes: AIUI, that's basically what sysfs and resctrl
> > are built on. Do we really expect people to set leases there?
> >
> > I guess it's technically a regression since you could set them on those
> > sorts of files earlier, but people don't usually export kernfs based
> > filesystems via NFS or SMB, and that seems like something that could be
> > used to make mischief.
> >
> > AFAICT, kernfs_export_ops is mostly to support open_by_handle_at(). See
> > commit aa8188253474 ("kernfs: add exportfs operations").
> >
> > One idea: we could add a wrapper around generic_setlease() for
> > filesystems like this that will do a WARN_ONCE() and then call
> > generic_setlease(). That would keep leases working on them but we might
> > get some reports that would tell us who's setting leases on these files
> > and why.
> 
> IMO, you are being too cautious, but whatever.
> 
> It is not accurate that kernfs filesystems are NFS exportable in general.
> Only cgroupfs has KERNFS_ROOT_SUPPORT_EXPORTOP.
> 
> If any application is using leases on cgroup files, it must be some
> very advanced runtime (i.e. systemd), so we should know about the
> regression sooner rather than later.
> 
> There are also the recently added nsfs and pidfs export_operations.
> 
> I have a recollection about wanting to be explicit about not allowing
> those to be exportable to NFS (nsfs specifically), but I can't see where
> and if that restriction was done.
> 
> Christian? Do you remember?

I don't think it does.

