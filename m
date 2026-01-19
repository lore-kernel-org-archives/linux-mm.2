Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB5ABCCF2D1
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494B36B0149; Mon, 19 Jan 2026 04:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441986B014B; Mon, 19 Jan 2026 04:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344596B014C; Mon, 19 Jan 2026 04:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 225B16B0149
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:27:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C05D0140675
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:27:30 +0000 (UTC)
X-FDA: 84348185460.25.D749477
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 396D240006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:27:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mu2QXGlU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768814849; a=rsa-sha256;
	cv=none;
	b=a1nyMBECkIxmy3wqJyOB8A5n5zQI4ydNoj35LVDSCW3GQKlhHit5YWZuwUsY24/HFIFEIM
	A0IHfq4MTuQ2aF32n5RxKNU1414pN/F78kBxDR71qMtBpnHI+yCEa3+syJEzI4+6tQWIXe
	MUNE+kqYPfOxCRTYENpki+OMOK4XCU0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mu2QXGlU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768814849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48N7Q6quaXG2VUerPh0mhwn+AwJxdPQoMhUkebk+erI=;
	b=R6KlKGDmp7MGKl6l0Eo0BpqJU6Iviy3rx5+bYlqCoHnF5/HLx/Dg9egqaLcyInXXm6aqyt
	ghCURyHJciKPN/6yZ9xeX/XtrAdeVQtke+Pa+mq4H0/43UHiHmTPF52yyjHO1C5zJ/pKiO
	JZSLmeSaOnlnTiXpOo2edG2XhuCGhh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 393BA60151;
	Mon, 19 Jan 2026 09:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB482C116C6;
	Mon, 19 Jan 2026 09:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768814847;
	bh=Zn6TWVYgqMMEo3G81dyTmE6wcI+Sd3bTAPgjzlTxSPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mu2QXGlUo4aerUV1P+3KG6SEVjE4I5PwhJE94jSGcKGFEsi89NRvYzLMGsZyQmRMx
	 AFrdo2vU9n6IMbv1w/EO9SLvuETafk1mFU5xlxvhkxtXkEJNYxoKBYE396mdxVzJZb
	 W5ZtaIJuQRCJeroGKA0KDWsJMPfBkIPP+baoniV9KyAuTgFx19+cYmtPt33Z2z6QMh
	 W/hxfZCWesZN7MEjTCRbAXitVDu+eK0Xl7sEvoG3LmudoMrRbWd+So2BZh0JGzK2g9
	 bPKHftczmsMNxhRS3WkfraWatirsn1eEv2j+V31oLZsNC4UpAnMV0UccclyHU9DeQT
	 92D5SL9b9rhFA==
Date: Mon, 19 Jan 2026 10:27:11 +0100
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
Message-ID: <20260119-kanufahren-meerjungfrau-775048806544@brauner>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <176880736225.16766.4203157325432990313@noble.neil.brown.name>
X-Rspam-User: 
X-Stat-Signature: 5hpmorenz7pet7icxojus5n6f9mz4u5x
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 396D240006
X-HE-Tag: 1768814849-228556
X-HE-Meta: U2FsdGVkX19v/Jqu260RMWbTJDVS48Bw4HdvjL5jxOARF726rvoZd46XVaneuCt7P+kPZIFMLME1wbAQDxZpHj7PcWm504ESVwBKaGlwcEFxym7hh+SXev+JCId1f6SADifJBOc/Wkw4SLOdRQlDWEyxX7eSs0x+p7OsZUXY4Ot8yK8N2361v0MxPYwk94hZK9R7L26+jQg+hhQUodj23+t2k/odyeepCvC/sMiQm8NO52yK+wBcMQnCCr66NixgN4hvykcBw90JHllqfrMLifdg9C7OHyXi5YYGdbv/vAoIJkDhqEofg3pDBodSVRGco3ezFJfdNwaL6SQxnfjwvJCMFj/kWP5YohqrXghk+2JRgqzNB+zr0gULdg/PNOVZunz1vRqex+NKNc+6kXkwxfE4V6qlttuYSF3aWlu3LHfXNjVmvEn2akv6oDHP3rWO/7AD51iIty7cbMgGHd7lzVEwpxC2XHak/lCV0uXxAn4Cbef681AHS7uo/gR+6ZevZZLjNBuU7ohhdbQzbDpuxW0LuuFFpSG49G1DwD/hyG5bm1k0mi1fz9nSKoRYXU3kICt2+N7lbFog5Jat1uiMXRtSrGEahBwB13v66cJ2tyAHdMm5BScXQK9S4j3Xxs9uskK7AtZEiZT+wFF2RXuIvarVg4G3AsPYOLB7Xhe2ZVDKb997E/cRR85tmLTeAsKQfRDfHc2uxySw1ux/sO6r9MJbGA+IkaQDw6iPW7UznQ1ZVGTMw1uYkBa3CxrIJ9YEDqAja924DGxk2eRmEhzSuCEjDPjH1rf2GfJ0Si8Qp8JWAdM3xcabSZ0XcMKbpcwT6cAODntdZFZ2aRmKWU6soco9EANEUbMghfPIkr54AZqk3Dj++LosnUVzcKIMha97z/cw9n7eoY8D1BVLqSvycea7DvHAcugjedLAKiOLh/zvQNnyDCFIV0yEgqdEKhR+nFLzC36K5j9IQVYgTXm
 T8mIpv7i
 79aK/Qb9MFF0QVrwCNJ7HUf7WIsIlatjvR5iNklyZyW3aF6on1uQZvwricfSEeT8RD3lfWcMqFeDQS1KuBdPyrAADEQOJHYOt3b1yzDtsZNj4033Ld1BsJ/snFHvdJusbTtvNldtsqROU7qQo0Bo+msRP4k7qILfGvqU+IqV9PHXdkV1Ztm2iJjk1aT0nCmEIsBcMAZCeJbISeLyQW+J+QzrLwQK+A/d7FzhFu1X/8j5N/JgGUfYcVxPVqhBitBO7FNLeykP+t8/e2a1EVRaflmkNHbFSVCKLOlHMZCAVuwnHAtlgkKEUOZBQTuwaEjSLV0zWq7ZQRFd3dzgZX/5j/8L40kTIv/WVEKZ1l4vyqLnkQvncoMyO0CR50g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 06:22:42PM +1100, NeilBrown wrote:
> On Mon, 19 Jan 2026, Christoph Hellwig wrote:
> > On Mon, Jan 19, 2026 at 10:23:13AM +1100, NeilBrown wrote:
> > > > This was Chuck's suggested name. His point was that STABLE means that
> > > > the FH's don't change during the lifetime of the file.
> > > > 
> > > > I don't much care about the flag name, so if everyone likes PERSISTENT
> > > > better I'll roll with that.
> > > 
> > > I don't like PERSISTENT.
> > > I'd rather call a spade a spade.
> > > 
> > >   EXPORT_OP_SUPPORTS_NFS_EXPORT
> > > or
> > >   EXPORT_OP_NOT_NFS_COMPATIBLE
> > > 
> > > The issue here is NFS export and indirection doesn't bring any benefits.
> > 
> > No, it absolutely is not.  And the whole concept of calling something
> > after the initial or main use is a recipe for a mess.
> 
> We are calling it for it's only use.  If there was ever another use, we
> could change the name if that made sense.  It is not a public name, it
> is easy to change.
> 
> > 
> > Pick a name that conveys what the flag is about, and document those
> > semantics well.  This flag is about the fact that for a given file,
> > as long as that file exists in the file system the handle is stable.
> > Both stable and persistent are suitable for that, nfs is everything
> > but.
> 
> My understanding is that kernfs would not get the flag.
> kernfs filehandles do not change as long as the file exist.
> But this is not sufficient for the files to be usefully exported.
> 
> I suspect kernfs does re-use filehandles relatively soon after the
> file/object has been destroyed.  Maybe that is the real problem here:
> filehandle reuse, not filehandle stability.
> 
> Jeff: could you please give details (and preserve them in future cover
> letters) of which filesystems are known to have problems and what
> exactly those problems are?
> 
> > 
> > Remember nfs also support volatile file handles, and other applications
> > might rely on this (I know of quite a few user space applications that
> > do, but they are kinda hardwired to xfs anyway).
> 
> The NFS protocol supports volatile file handles.  knfsd does not.
> So maybe
>   EXPORT_OP_NOT_NFSD_COMPATIBLE
> might be better.  or EXPORT_OP_NOT_LINUX_NFSD_COMPATIBLE.
> (I prefer opt-out rather than opt-in because nfsd export was the
> original purpose of export_operations, but it isn't something
> I would fight for)

I prefer one of the variants you proposed here but I don't particularly
care. It's not a hill worth dying on. So if Christoph insists on the
other name then I say let's just go with it.

