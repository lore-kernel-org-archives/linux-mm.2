Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73167D29DE2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 08:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10C96B0005; Tue, 13 Jan 2026 03:54:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE8A6B0089; Tue, 13 Jan 2026 03:54:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACABD6B008A; Tue, 13 Jan 2026 03:54:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5946B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:54:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BFFC1A01F8
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:54:37 +0000 (UTC)
X-FDA: 84326329794.26.A8F80A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC20680009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:54:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VMqw4jfO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768294475; a=rsa-sha256;
	cv=none;
	b=QHOFCp4/bnBEDDm+lYL4jxCuUABZe596ax1rv5x5Z41/Yoga7zGKrYP5XmXB6Fpevf99i4
	pCEMs+qYmkd2AheoxoKeNwQXcdZjPf+pLryBK2+n80eYLzoDx9m4nYGWVrg497Ll235gte
	DHUIfZRurpeDuG6bcj4YALYXKOXddMY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VMqw4jfO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768294475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EVqflcatbx4V1B46xWWhgcfIYUol4ag4eDJtKtbMe4=;
	b=5ZohGMgOIMC6RzbXwDQuWEa1GeFuUmkIoE/MsnEczoQFPfPGQDfKxg1mVZHCU6csni7o0B
	SqRnGKmj2G9usm1qV96LLKjiN2a3yu2hn+RVIn6O9l5NzzTigbprIupmyWFIaxuxl2qJPE
	A7aBV6OQG6jb9oO5gBfVQcLUI+BmaH8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B157432B5;
	Tue, 13 Jan 2026 08:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A24BC116C6;
	Tue, 13 Jan 2026 08:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768294474;
	bh=8pJH5EMsw2Zf/vnxVI5TNW+Tn1VjYrvuVd/4u81hQjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VMqw4jfOdED4XJIXekFPVJQafNNTl6ZiZA++QmJZRBiaMMpeaGnJz3p4o2lTbIKwN
	 ZGKZS5HpYR0+N1ii5xC8s/TyQQtV2NHGSS3n0xjeitfnyVlfkGYGF3WN3Zn7pEUn7y
	 amB5o/YtgvPlamLE3g3COpvYgjvxdfsKYBT2hFD400U3g9OGS1J+dMj0yVSbLkyPHq
	 +GkCBtTzjYLjVlnxILoQmVvBvvr3BKnDX0iaKwspCd8aN5JnS4IRKaSF02TomWn63P
	 ouok9TX1G4ku4VsaA4mPbFNSkRS1iOdM6roW82YC7GjR5YxocE6Li41axUo0cFM9rz
	 CEFrc/zUFpOyw==
Date: Tue, 13 Jan 2026 09:54:15 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>
Cc: Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>, 
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
Message-ID: <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4>
 <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
 <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
 <ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
 <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com>
 <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
X-Rspamd-Queue-Id: AC20680009
X-Rspamd-Server: rspam06
X-Stat-Signature: u3wpty7ysgz1r597obpusj3jc7abnkqb
X-Rspam-User: 
X-HE-Tag: 1768294475-50490
X-HE-Meta: U2FsdGVkX1+7MAOjp1GLFjiVtdOXqDetIYZSPGgRTfKbr6pzYwWD45NM20M3V9MzzTImY0RkN/vviYgNXIU6oOjcF42m21KlRdpPSrzuI3PggUGfCs1EYfmlk7S1YJKcYeAU23C2KG2167/iOs5KWs/VoYEwGXE5iqLc3JGCncaIuGshqhvFJk7lWP6/cXjMRPwJWuOnbzBc1ckPdPJCrEI7haiRvxUE55FedGmFguRI5S8JIZjzMx+ZT6bogPPaacWDZrUA3Bk66RB3AxmvzouNQcVqa8OY8fRf0icRIc9TegzNsaFwbO+buH8pCmAyRXJ0ri06bMTbcYBGA/u8zMAtjoCEQtRXG2OrdGzbbd9jqrCWyx6gbsy71CkYxmHyNuElnF7jVqAwN+a656nY/nwiumNaxIlpYcm79Nkrp7Yc8owr1dnS1ZHDeTB7vY08/HjIEl2FYm2+6O+HLQNyDpMcUVhXolhEmcLRHaZA86kqXOsKXUNU1TmK5RTKvpNNiu8X/mm0CmfTZ8gX+gNxbmWga//+olUinXlYTCCfpYK1CmJwPNu/tA01zNvRchOXBmJm0DeFHpzcSja2VUkUaV9QbIlxTCdYQK/RuZ8BLnOZgAIPt1h/ur7ayUW3wxZUP318nBBBrlPmNge/EAX9YEZEITTJ+OfVBjWJtUTSLRE3zb95oAYkSPUy4nMGzZ24qbk2Y6rgq1Y1Dk/PMiiE7JS7HvVp8E3Q0GBB8ZmjbqOcR70yI6spupLkKsF79aQ/CJ3SQLgpLcdkmKL18M93Fx4hsGKx/tktcal9lYa2Nqfcg5aDP1pyLSB9+ZJuTg4Vv2z+BG5D0mSxlfSGM6hDo4TM1gquWRu4gNmxQR/9WiO8WpBBHoAnpHqLQmKSfV9ySKDbnERcyaakJzzFirrTan9rL/bTUehcHbzkQ1Igmm69G0o0ATPou1Oz+d2QlTzftk6zymf296ZIM0zOTMU
 lplB++Yi
 Mt9ITwFBuShDSEe6lYtUg7C5U7vwDCqkQg/8SbKFOCZo3jEDNVRNNgES5MYDlmC/X6StHgy6bqMCRUFfldZol7rAe6pdEK/FKBJp1ua4j/7a2OloESmut/qt1MW0XlO1PeadtdZ6sFH7pLbv2o7bga5j0IpYbY80AQt+PDXoLxmYEX69oWXL59kXxzPvZPeBqzgKa0Zk3ujdA7B5RuegQlCydbEgIW/QNO/noCTL6cflv0SjyhquZCgyryandCzTZS0fr5k4hds7t1CX+tjY3Idj0nxjbx91BSZjb1Vdx5HVW/Kf6P5WC5L/akT+KXqA1mgBduDAf8Lq4CZLgm2P5GPlyJHp4MZAZ23TwaUzwOIY+sr3+7DwcWWZmf3y1cExnPpICgEDpQXTqXfUv9urf3nYyEXmeDxBd1rnD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 09:50:20AM -0500, Jeff Layton wrote:
> On Mon, 2026-01-12 at 09:31 -0500, Chuck Lever wrote:
> > On 1/12/26 8:34 AM, Jeff Layton wrote:
> > > On Fri, 2026-01-09 at 19:52 +0100, Amir Goldstein wrote:
> > > > On Thu, Jan 8, 2026 at 7:57 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > 
> > > > > On Thu, 2026-01-08 at 18:40 +0100, Jan Kara wrote:
> > > > > > On Thu 08-01-26 12:12:55, Jeff Layton wrote:
> > > > > > > Yesterday, I sent patches to fix how directory delegation support is
> > > > > > > handled on filesystems where the should be disabled [1]. That set is
> > > > > > > appropriate for v6.19. For v7.0, I want to make lease support be more
> > > > > > > opt-in, rather than opt-out:
> > > > > > > 
> > > > > > > For historical reasons, when ->setlease() file_operation is set to NULL,
> > > > > > > the default is to use the kernel-internal lease implementation. This
> > > > > > > means that if you want to disable them, you need to explicitly set the
> > > > > > > ->setlease() file_operation to simple_nosetlease() or the equivalent.
> > > > > > > 
> > > > > > > This has caused a number of problems over the years as some filesystems
> > > > > > > have inadvertantly allowed leases to be acquired simply by having left
> > > > > > > it set to NULL. It would be better if filesystems had to opt-in to lease
> > > > > > > support, particularly with the advent of directory delegations.
> > > > > > > 
> > > > > > > This series has sets the ->setlease() operation in a pile of existing
> > > > > > > local filesystems to generic_setlease() and then changes
> > > > > > > kernel_setlease() to return -EINVAL when the setlease() operation is not
> > > > > > > set.
> > > > > > > 
> > > > > > > With this change, new filesystems will need to explicitly set the
> > > > > > > ->setlease() operations in order to provide lease and delegation
> > > > > > > support.
> > > > > > > 
> > > > > > > I mainly focused on filesystems that are NFS exportable, since NFS and
> > > > > > > SMB are the main users of file leases, and they tend to end up exporting
> > > > > > > the same filesystem types. Let me know if I've missed any.
> > > > > > 
> > > > > > So, what about kernfs and fuse? They seem to be exportable and don't have
> > > > > > .setlease set...
> > > > > > 
> > > > > 
> > > > > Yes, FUSE needs this too. I'll add a patch for that.
> > > > > 
> > > > > As far as kernfs goes: AIUI, that's basically what sysfs and resctrl
> > > > > are built on. Do we really expect people to set leases there?
> > > > > 
> > > > > I guess it's technically a regression since you could set them on those
> > > > > sorts of files earlier, but people don't usually export kernfs based
> > > > > filesystems via NFS or SMB, and that seems like something that could be
> > > > > used to make mischief.
> > > > > 
> > > > > AFAICT, kernfs_export_ops is mostly to support open_by_handle_at(). See
> > > > > commit aa8188253474 ("kernfs: add exportfs operations").
> > > > > 
> > > > > One idea: we could add a wrapper around generic_setlease() for
> > > > > filesystems like this that will do a WARN_ONCE() and then call
> > > > > generic_setlease(). That would keep leases working on them but we might
> > > > > get some reports that would tell us who's setting leases on these files
> > > > > and why.
> > > > 
> > > > IMO, you are being too cautious, but whatever.
> > > > 
> > > > It is not accurate that kernfs filesystems are NFS exportable in general.
> > > > Only cgroupfs has KERNFS_ROOT_SUPPORT_EXPORTOP.
> > > > 
> > > > If any application is using leases on cgroup files, it must be some
> > > > very advanced runtime (i.e. systemd), so we should know about the
> > > > regression sooner rather than later.
> > > > 
> > > 
> > > I think so too. For now, I think I'll not bother with the WARN_ONCE().
> > > Let's just leave kernfs out of the set until someone presents a real
> > > use-case.
> > > 
> > > > There are also the recently added nsfs and pidfs export_operations.
> > > > 
> > > > I have a recollection about wanting to be explicit about not allowing
> > > > those to be exportable to NFS (nsfs specifically), but I can't see where
> > > > and if that restriction was done.
> > > > 
> > > > Christian? Do you remember?
> > > > 
> > > 
> > > (cc'ing Chuck)
> > > 
> > > FWIW, you can currently export and mount /sys/fs/cgroup via NFS. The
> > > directory doesn't show up when you try to get to it via NFSv4, but you
> > > can mount it using v3 and READDIR works. The files are all empty when
> > > you try to read them. I didn't try to do any writes.
> > > 
> > > Should we add a mechanism to prevent exporting these sorts of
> > > filesystems?
> > > 
> > > Even better would be to make nfsd exporting explicitly opt-in. What if
> > > we were to add a EXPORT_OP_NFSD flag that explicitly allows filesystems
> > > to opt-in to NFS exporting, and check for that in __fh_verify()? We'd
> > > have to add it to a bunch of existing filesystems, but that's fairly
> > > simple to do with an LLM.
> > 
> > What's the active harm in exporting /sys/fs/cgroup ? It has to be done
> > explicitly via /etc/exports, so this is under the NFS server admin's
> > control. Is it an attack surface?
> > 
> 
> Potentially?
> 
> I don't see any active harm with exporting cgroupfs. It doesn't work
> right via nfsd, but it's not crashing the box or anything.
> 
> At one time, those were only defined by filesystems that wanted to
> allow NFS export. Now we've grown them on filesystems that just want to
> provide filehandles for open_by_handle_at() and the like. nfsd doesn't
> care though: if the fs has export operations, it'll happily use them.
> 
> Having an explicit "I want to allow nfsd" flag see ms like it might
> save us some headaches in the future when other filesystems add export
> ops for this sort of filehandle use.

So we are re-hashing a discussion we had a few months ago (Amir was
involved at least).

I don't think we want to expose cgroupfs via NFS that's super weird.
It's like remote partial resource management and it would be very
strange if a remote process suddenly would be able to move things around
in the cgroup tree. So I would prefer to not do this.

So my preference would be to really sever file handles from the export
mechanism so that we can allow stuff like pidfs and nsfs and cgroupfs to
use file handles via name_to_handle_at() and open_by_handle_at() without
making them exportable.

Somehow I thought that Amir had already done that work a while ago but
maybe it was really just about name_to_handle_at() and not also
open_by_handle_at()...

