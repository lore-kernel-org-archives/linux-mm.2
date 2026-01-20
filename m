Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6356CD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 10:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F626B03B3; Tue, 20 Jan 2026 05:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CA76B03B4; Tue, 20 Jan 2026 05:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28796B03B5; Tue, 20 Jan 2026 05:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0B66B03B3
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:32:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F23B8B964
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:32:15 +0000 (UTC)
X-FDA: 84351977430.26.8F0364A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 90D6714000F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:32:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYn1JLyP;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768905133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIPzDp4//6enUE/aZW6TaDiQzaEzpTggtDW+VnkFMJ8=;
	b=2APeCpOT+JfBg27NoP9wSQr5rk2zS6GN9hjYEHBjjrsZsIMkEHu8WhyhIhThJySKmLnNj3
	Q9XXiM6f0vMsgjOmSPLvwNCcbz+nTUHQylb3zR3RayrJKlNywrRHlHXWS+Q7Ca2az8ee/+
	FScVeSuC59jCdgiHoit58MVTrNAAxQA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sYn1JLyP;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768905133; a=rsa-sha256;
	cv=none;
	b=JDEFQYYMPmER8eJc1BsfUgRMa1BtOuzG0QcE4PW+j+4Zfy+rJDpZBFwX7BZVo1RzU6AXzj
	s5n20bWHoNxtyh4NIaAotBt6gCKGSQBenVGM4vI5BLN/q9wL4G2Lzop6WB4eFP3EyWaqRo
	MR7kwg00yAjP1kU2OZE5oyxNKPDG2f0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E44E60018;
	Tue, 20 Jan 2026 10:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A27C16AAE;
	Tue, 20 Jan 2026 10:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768905132;
	bh=TXpuEn3+iHgMswY7v2yl+yBnFlWexn06CYVhrLra0ps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sYn1JLyPJPiGC80xsPWNxbtykfUUs946DA7esf6l3JMX38rt0GRoNF1cRYsres/wk
	 PEJViML67kDs58KnQ01Y/RlO5bKq7d0ZXMcSQ/mkeXLjjLZV/fDEUuF8X1z67vGwDl
	 S4BDLlAOBnwFrMcS0CNaziW6IFGszNB0/JTGCLvnEXaABq+5D8szxy7iodrNzItOUv
	 lpWjW+neeYAI9cglsT/f5525FKsTcWuHVc8VwgMC9LA2j5BhSVKDtyEXhQPSbOCGl2
	 KQoI5KR3jG9uCQrTTBeQZHZsxSZCqULdPd8KRVm4QkItj+8BOixBLgQenBp1VoSz3y
	 OcHgGkgocKzkA==
Date: Tue, 20 Jan 2026 11:31:54 +0100
From: Christian Brauner <brauner@kernel.org>
To: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Chuck Lever <chuck.lever@oracle.com>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
Message-ID: <20260120-hacken-revision-88209121ac2c@brauner>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <20260120-entmilitarisieren-wanken-afd04b910897@brauner>
 <176890211061.16766.16354247063052030403@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <176890211061.16766.16354247063052030403@noble.neil.brown.name>
X-Rspam-User: 
X-Stat-Signature: naocg56ut95mrhb5xfmnijdhfnngibfd
X-Rspamd-Queue-Id: 90D6714000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1768905133-389870
X-HE-Meta: U2FsdGVkX1+gLq2mVhQpBdysD8/qxL1mumCjpyBkoyCBQaFEBIJxLv/w+9KNNdPHS1zcG8wAQ0LdwO7reYooLMSNsE6a1Tk2KBwRUB5Iq+NpR2lvuJhQYDXHgt4NE8M1Z64tmDx45UBY/wjMY4ykqtHaseYKaajdHDV86Swss+vPe/zIVRg1jlofFEAjtF7j25j6ucVgLPVfGjI1ON9w67P0fzEqT0N0LK04gdYxY1IqphjEKU/cvndQR5Iki+1HC8iIm6nhJy/IusEBY9PG2RaHbjz286cvqW6/kE0DmrDbaTuWjLPcMWl5oSmWYoOpbyEUWRc8O1Quwj+OlcrdmZGwAjCt9Vk0q5a5wHuq8L+EFp29k2qmvgkv5623cPimT9tPsOZd8DgZkkYpk/96ihI5Nqashfns6gd5S+kARY8l3F9T7Tc/m+TwFQTWuaGLYvoMSHOG/qqFh5LVdq5v/PH+UAguRlR8Vl421ZdidQEU6jFtfPdMUBlVrTY9744hbTKS+VzrnAo9X2YRNOuC/Ldm70xUi2EdsBePde2FoTImjJviL1mJsqivWPl1sNTWN+jQavhE50tt1ZVqRC1LZEE7fDKNbrO0T0UBtNSq64EAJI6U8X12jlDXV/h4xyXVEO2tObKdAk47V4EVfht8YWHtnDuILv0/MHoIXvxND/3uhEGhT/FT2olfjua1rM6Llwk7G5EvJCnWj8ExN3K2kxNLwSSsmgFTjKNT/CwSBDX+mQiyhoF2ws+9ITzB190ujFsH9kdH0B0Dlc45g30Zv4Wwmd3HY0ZrBNJulzEgyeI/prmtHDeCEKaXp+Pt9m8yfAClIrrEW8nKtW8xbJ2pFUPgY9/8b9mk8X/yenDek9PFNv/4xk5TZSeLm1fN74C2PJqm1g83yYuOhQXVgtG108vWBOFOhONG9+kZjqQ00PtSNWIarmAEaxLZjO1lXmQ7GoFasgW0Db6Xhkbj/oS
 NEnbmdL2
 mYlQleidU0OVcvWCQHWJ8PQLCZ7v2EdMLtN5TVUMwmj814j2OM+NQtKw1aLtjkTAc5tzNwmRmfo50ubV3Ao9ziWAhhJ65VJaQPHmWfFcu8X0kA9bmdCAxnMbZ/JtB2aIo8quAF2yTAi+UFpNDOManE5u1Nh78/mjSKxpJQRljlPAlip/SJQrVUOp/5mxDgbPxKra++zW63ck08oaPNYG6skVWU5lbCuFl6dfCBoxzq0E938gdwVcCOfGlh3FlOf8mk26YG7KFfLAYeUWMPhRbYNMhSQrbUvgqz8vW6Io10mHUJOxEWNQr30v+07uG/hU2EGwHWV5ADtDYfJs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 08:41:50PM +1100, NeilBrown wrote:
> On Tue, 20 Jan 2026, Christian Brauner wrote:
> > On Tue, Jan 20, 2026 at 07:45:35AM +1100, NeilBrown wrote:
> > > On Mon, 19 Jan 2026, Christian Brauner wrote:
> > > > On Mon, Jan 19, 2026 at 06:22:42PM +1100, NeilBrown wrote:
> > > > > On Mon, 19 Jan 2026, Christoph Hellwig wrote:
> > > > > > On Mon, Jan 19, 2026 at 10:23:13AM +1100, NeilBrown wrote:
> > > > > > > > This was Chuck's suggested name. His point was that STABLE means that
> > > > > > > > the FH's don't change during the lifetime of the file.
> > > > > > > > 
> > > > > > > > I don't much care about the flag name, so if everyone likes PERSISTENT
> > > > > > > > better I'll roll with that.
> > > > > > > 
> > > > > > > I don't like PERSISTENT.
> > > > > > > I'd rather call a spade a spade.
> > > > > > > 
> > > > > > >   EXPORT_OP_SUPPORTS_NFS_EXPORT
> > > > > > > or
> > > > > > >   EXPORT_OP_NOT_NFS_COMPATIBLE
> > > > > > > 
> > > > > > > The issue here is NFS export and indirection doesn't bring any benefits.
> > > > > > 
> > > > > > No, it absolutely is not.  And the whole concept of calling something
> > > > > > after the initial or main use is a recipe for a mess.
> > > > > 
> > > > > We are calling it for it's only use.  If there was ever another use, we
> > > > > could change the name if that made sense.  It is not a public name, it
> > > > > is easy to change.
> > > > > 
> > > > > > 
> > > > > > Pick a name that conveys what the flag is about, and document those
> > > > > > semantics well.  This flag is about the fact that for a given file,
> > > > > > as long as that file exists in the file system the handle is stable.
> > > > > > Both stable and persistent are suitable for that, nfs is everything
> > > > > > but.
> > > > > 
> > > > > My understanding is that kernfs would not get the flag.
> > > > > kernfs filehandles do not change as long as the file exist.
> > > > > But this is not sufficient for the files to be usefully exported.
> > > > > 
> > > > > I suspect kernfs does re-use filehandles relatively soon after the
> > > > > file/object has been destroyed.  Maybe that is the real problem here:
> > > > > filehandle reuse, not filehandle stability.
> > > > > 
> > > > > Jeff: could you please give details (and preserve them in future cover
> > > > > letters) of which filesystems are known to have problems and what
> > > > > exactly those problems are?
> > > > > 
> > > > > > 
> > > > > > Remember nfs also support volatile file handles, and other applications
> > > > > > might rely on this (I know of quite a few user space applications that
> > > > > > do, but they are kinda hardwired to xfs anyway).
> > > > > 
> > > > > The NFS protocol supports volatile file handles.  knfsd does not.
> > > > > So maybe
> > > > >   EXPORT_OP_NOT_NFSD_COMPATIBLE
> > > > > might be better.  or EXPORT_OP_NOT_LINUX_NFSD_COMPATIBLE.
> > > > > (I prefer opt-out rather than opt-in because nfsd export was the
> > > > > original purpose of export_operations, but it isn't something
> > > > > I would fight for)
> > > > 
> > > > I prefer one of the variants you proposed here but I don't particularly
> > > > care. It's not a hill worth dying on. So if Christoph insists on the
> > > > other name then I say let's just go with it.
> > > > 
> > > 
> > > This sounds like you are recommending that we give in to bullying.
> > > I would rather the decision be made based on the facts of the case, not
> > > the opinions that are stated most bluntly.
> > > 
> > > I actually think that what Christoph wants is actually quite different
> > > from what Jeff wants, and maybe two flags are needed.  But I don't yet
> > > have a clear understanding of what Christoph wants, so I cannot be sure.
> > 
> > I've tried to indirectly ask whether you would be willing to compromise
> > here or whether you want to insist on your alternative name. Apparently
> > that didn't come through.
> 
> This would be the "not a hill worthy dying on" part of your statement.
> I think I see that implication now.
> But no, I don't think compromise is relevant.  I think the problem
> statement as originally given by Jeff is misleading, and people have
> been misled to an incorrect name.
> 
> > 
> > I'm unclear what your goal is in suggesting that I recommend "we" give
> > into bullying. All it achieved was to further derail this thread.
> > 
> 
> The "We" is the same as the "us" in "let's just go with it".
> 
> 
> > I also think it's not very helpful at v6 of the discussion to start
> > figuring out what the actual key rift between Jeff's and Christoph's
> > position is. If you've figured it out and gotten an agreement and this
> > is already in, send a follow-up series.
> 
> v6?  v2 was posted today.  But maybe you are referring the some other
> precursors.
> 
> The introductory statement in v2 is
> 
>    This patchset adds a flag that indicates whether the filesystem supports
>    stable filehandles (i.e. that they don't change over the life of the
>    file). It then makes any filesystem that doesn't set that flag
>    ineligible for nfsd export.
> 
> Nobody else questioned the validity of that.  I do.
> No evidence was given that there are *any* filesystems that don't
> support stable filehandles.  The only filesystem mentioned is cgroups
> and it DOES provide stable filehandles.

Oh yes we did. And this is a merry-go-round.

It is very much fine for a filesystems to support file handles without
wanting to support exporting via NFS. That is especially true for
in-kernel pseudo filesystems.

As I've said before multiple times I want a way to allow filesystems
such as pidfs and nsfs to use file handles without supporting export.
Whatever that fscking flag is called at this point I fundamentally don't
care. And we are reliving the same arguments over and over.

I will _hard NAK_ anything that starts mandating that export of
filesystems must be allowed simply because their file handles fit export
criteria. I do not care whether pidfs or nsfs file handles fit the bill.
They will not be exported.

