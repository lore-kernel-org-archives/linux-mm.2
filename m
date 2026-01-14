Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B32AD37E42
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4B36B0005; Wed, 14 Jan 2026 10:20:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52656B0088; Wed, 14 Jan 2026 10:20:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27076B0089; Wed, 14 Jan 2026 10:20:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A21CD6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:20:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B5FFC202B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:20:35 +0000 (UTC)
X-FDA: 84330931230.29.BC665C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8910780007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:20:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FqipJ8Fc;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768404033; a=rsa-sha256;
	cv=none;
	b=dN1r9T5lqD19XxPmVo2I6hfzTcaVmn2lgJkRv4fUNXJ3H7cX96puNDDQh7KEgFG2swT7PZ
	jjVt8QZzB1q0e9qb0CqiRVsyIBa7SLuDGblsuLSim9b32Ob8Iy8Rd+2La5nrzUDgj0VBxK
	Em/B8fsVOqlYHTZFh+46ESy+cji92aY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FqipJ8Fc;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768404033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mM/mGj7mKtWtzR+95sdegxfPi111qb3075OeDVGNDZ4=;
	b=mdzDgkIeq5oZnE+zRfEg4Vke+wfryx1+eXm0DqOO4tcyv7PtAQe+9LPsBd9leCTTI+Ek0G
	JxkpIemLJ2piMH9IgilkIuW/BWF+ndOmvYc9iI48yQ++S+fp27ZbRFUMZH53eGuDIDaMvs
	EJ0cepQup+uSeWmBxXQvKvY62wUjAic=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 353AC443ED;
	Wed, 14 Jan 2026 15:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C66C4CEF7;
	Wed, 14 Jan 2026 15:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768404032;
	bh=95l5NkW0A/27kpGYcRaUumPREirLPSD0h/i7bikH9bU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FqipJ8Fclg/c7qbEuyuUoO5LnexEwFkZgygpoboZW7ULcYAGY34jzrJax6uIrAgGb
	 FUepiZcAjlgA0R6fvdFVWwhV9jk0Bth6JPV5psDXj3fKzojOCwDT/rEZzcVE5OnNcB
	 fkG5ZlQLelxcsKpIOTgMpMe11bGcKCWvNYmxvgnzxn2ZC8L7s2dKJy1mrpvPNu7Z7A
	 UqZxpjIOgw/V7XPIA/1Y2FN9yOrK13WyoEdrmVdFpCQbw6zTva9Pkh2JqEgk58ngiJ
	 5S6BKkDUQrDweGrzgYJLMr/YFieOsQM7bFBSWWwVpgpU92+aZuVuBVHfvvOSCo18FZ
	 sKemGEnojFw5A==
Date: Wed, 14 Jan 2026 16:20:13 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Jeff Layton <jlayton@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
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
Message-ID: <20260114-klarstellen-blamieren-0b7d40182800@brauner>
References: <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
 <ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
 <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com>
 <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
 <aWZcoyQLvbJKUxDU@infradead.org>
 <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
 <aWc3mwBNs8LNFN4W@infradead.org>
 <CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
 <aWeUv2UUJ_NdgozS@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aWeUv2UUJ_NdgozS@infradead.org>
X-Stat-Signature: gfn7r568owek9k4td6qwy1n9oss5qz4z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8910780007
X-Rspam-User: 
X-HE-Tag: 1768404033-917843
X-HE-Meta: U2FsdGVkX1/YwKlC80bZ1uTPrvhlkj7IUQLWP08UTkAk75LWL1htR5uYTf8lB6DMMK3d86mUvsXnfRV9D8sXtolRmex75hpR6h+5xrReFonUgIDcaycdJkM7nEPrCyT5A1Y/8aRplYLPo1SxVHYKwScVn2JfRHvLhkNT/jLAot+lH+078F9Z2SyecgjzizDHkcDWLRs/Ou+TNuynD0zUFLdye1ZXpbv3OMCX+96oqlXco1avizs9LZuh9zkrY7IBDuODa8ijO+sn9pHt6QqzmQABCsNIQW60ilUOyXkGwQqzzT6hPO6fdqqK/SlFikST2UbXi4RCTXoDFZlL3KVvOLLje0May0ZynR/BwQVH8j+67Sz56rMBNGy5cYl2pIhJJwAWyRjI91+Qq1M8Hi+SObI2OkDxI/GrsQHZlGTD8iNRiEpXSOGQBcDcc/b+QkoQ1llK+DcCovIMHPNFznci4AO0XnlSWiaPknUStriDp7PrwYNOjveubp7mmGW1uc0lrEvrjrDLeuCIYLkaRO7pqgnxPH/rPl7JH9AH5Ewwo3du3MTxtdr8xLp7eqbljPZ9K8buvNEdfgdBAPiziJvXVCcGP47VsEqn83YOz0+5RdIhkSWP5dIS80UtCvis0A2BxYifSHZULCGSt5cWFCSqDzMDkh/XJL+p7PPF0A+FJg3NCDX4/B4SS21cM8w8tSEwo6uUgzo6Tw85wbcXYdyjRoc1UY3DRcZ8aepR+szNZ2FTpgiRn97MB6BNKRPqusRF+MbgFoznqKLHJb6N4sczCtmzaDGHuH5YsYVKwrsWXJaarrRyxmuSGKHvQbvRnlPfrGJRQFQeTQTcZrosE+dKFBB3JIKsvPHo9+L/E5wT9HlPKtTUH/JkLCAou7HCVmTgzfmhpKdmWshHxC9e1u+tXmeXSCSl2Q65arMGiYiyyNqa3IS/DIkS6zn2SBW7TMgpYMNZyHbrcatvD3/MudJ
 vUA3vm0h
 ZctJthnEQVFsQhHRqJGINCuv8hZulhvfTx2qW2TvU/HXvBWI5paro+k8UUXJAGXcr8iEwNrI4dKOnEvdW6H1z4owQdL0BC6qPHo6FWu5QMQj/E6lKx/TZ7iN+t3+jqy3ScuufzyUcONBu5aYdZ4n0YlCgzgGTctA/kPHiihCwU7dZNZD0u7NJHCWgJS/rN+TIOVaOVjzJHvVUdrHka6A6nvBGVpSnVfuojJpo6UGeGh0Vwh9V2RvFn11K2AL9I2JNudhHVJIlVxDouG0sQQpJf9KAhrUW6cstGs/2lDWPMn+4wUL1+gyfc+VlIXczWK7hABYqwlv3nWIqBwXGgwXXy3CFSswbt9nQDHk2/SGImCl1Zy+t1EGAgyiE315rw/gAG3k2wgW+HT+iJsw2qOjIzLNwA01Kvc9BE81GIv9AkI8PwqbXTVMXJggQMwumBjNFPoV7ZuYcc3Epv9uaRTm87YiSo5nE0PqHoqIzcK356cTscq4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 05:06:07AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 14, 2026 at 10:34:04AM +0100, Amir Goldstein wrote:
> > On Wed, Jan 14, 2026 at 7:28 AM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > On Tue, Jan 13, 2026 at 12:06:42PM -0500, Jeff Layton wrote:
> > > > Fair point, but it's not that hard to conceive of a situation where
> > > > someone inadvertantly exports cgroupfs or some similar filesystem:
> > >
> > > Sure.  But how is this worse than accidentally exporting private data
> > > or any other misconfiguration?
> > >
> > 
> > My POV is that it is less about security (as your question implies), and
> > more about correctness.
> 
> I was just replying to Jeff.
> 
> > The special thing about NFS export, as opposed to, say, ksmbd, is
> > open by file handle, IOW, the export_operations.
> > 
> > I perceive this as a very strange and undesired situation when NFS
> > file handles do not behave as persistent file handles.
> 
> That is not just very strange, but actually broken (discounting the
> obscure volatile file handles features not implemented in Linux NFS
> and NFSD).  And the export ops always worked under the assumption
> that these file handles are indeed persistent.  If they're not we
> do have a problem.
> 
> > 
> > cgroupfs, pidfs, nsfs, all gained open_by_handle_at() capability for
> > a known reason, which was NOT NFS export.
> > 
> > If the author of open_by_handle_at() support (i.e. brauner) does not
> > wish to imply that those fs should be exported to NFS, why object?
> 
> Because "want to export" is a stupid category.
> 
> OTOH "NFS exporting doesn't actually properly work because someone
> overloaded export_ops with different semantics" is a valid category.
> 
> > We could have the opt-in/out of NFS export fixes per EXPORT_OP_
> > flags and we could even think of allowing admin to make this decision
> > per vfsmount (e.g. for cgroupfs).
> > 
> > In any case, I fail to see how objecting to the possibility of NFS export
> > opt-out serves anyone.
> 
> You're still think of it the wrong way.  If we do have file systems
> that break the original exportfs semantics we need to fix that, and
> something like a "stable handles" flag will work well for that.  But
> a totally arbitrary "is exportable" flag is total nonsense.

File handles can legitimately be conceptualized independently of
exporting a filesystem. If we wanted to tear those concepts apart
implementation wise we could.

It is complete nonsense to expect the kernel to support exporting any
arbitrary internal filesystem or to not support file handles at all.

How that is achieved is completely irrelevant to that core part of the
argument. The point Jeff and Amir are making that it is sensible to
allow one without the other.

Whether or not some userspace crap allows you to achieve the same thing
is entirely irrelevant and does not at all imply we have to allow the
same crap in the kernel.

