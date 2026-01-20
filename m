Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69FC4D2ED14
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC176B038A; Tue, 20 Jan 2026 04:04:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD496B038B; Tue, 20 Jan 2026 04:04:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0436B038D; Tue, 20 Jan 2026 04:04:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 673A76B038A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:04:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC4DF8BA32
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:04:22 +0000 (UTC)
X-FDA: 84351755964.27.26E5275
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6413F18000A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:04:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fGDb6CKy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768899861; a=rsa-sha256;
	cv=none;
	b=3c4foaECJiM/Mi9jGxgYbSKJprv4JDAgHH9wKWN2Vo/q3C/rv6Y+P6LqzH7bEcnAb4qPcg
	vJv0mjlf2cs47A6ggDGaG109kmrUjteJWLy3Y6+hQJctODLoyDYdygskKFjLYy2dXZsJ2/
	x29h6JGWQKUDf5oQAgDSL4qT6vGbbt4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fGDb6CKy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768899861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xsSgKIDuo4qDjit1pBG7rOXsILAbrUIuqR6z6YgwzJI=;
	b=lxPeOGLS5FaJpAQxz6SL/9QGMo58QpFPOz0dEalPxShQQXzEDc4+MfHzGz3damSXf0t9b5
	+1KK17Kiu2OIZbUh/ez5EZAH+bdKOoXrH/itpBRZF4lkv06ZBSjMKChYv+4Ki65vvlG/78
	4a5SYr5rAONpebLxHOBVIDWmhrU5lKM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0AFA4412C;
	Tue, 20 Jan 2026 09:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27E6C16AAE;
	Tue, 20 Jan 2026 09:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768899859;
	bh=JhDsyPDpvGvdyDqhxS7TmcgEIlTc18FPxLf75vE9wzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fGDb6CKy+f5LfPcob1huzIh9QAzk76QrguP0qOMXMNMmAKfWnMvffuvnLOaaLC7ew
	 wiubvCikcdnsEOdPZbW0H4zHWxmUCevg43yAEJPXPT7hXH00W12HfQMEdyIDGD9O0j
	 nz71osv3r1RJtNqoyCLf3dZK5Tzfa3wtmYACMeGkq0oSzzypljd57xjg95SjtXty51
	 UWd/sW/tdqfH5YKWLFRsczUlBeW+ZFhuEDFDscE+KtGNfb9dtk0DPBFCrkx1ut54Lk
	 X+2fXMq+FuO5POPWMylL14pwRJfTUXJAHUYehRsOz+2S0efemBjlbHErutvPMV85s8
	 rd90Iu7ZfyW+Q==
Date: Tue, 20 Jan 2026 10:04:02 +0100
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
Message-ID: <20260120-entmilitarisieren-wanken-afd04b910897@brauner>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <176885553525.16766.291581709413217562@noble.neil.brown.name>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6413F18000A
X-Stat-Signature: gy7gmyo6nxapbj756im9huzr8eoey3nj
X-Rspam-User: 
X-HE-Tag: 1768899861-919016
X-HE-Meta: U2FsdGVkX19qJ9q3+yZj29eWjJ2RTTYxPZjDq3HSFo0XQhsppxTpKxEeMEscEHbAuhq3gbgjQLMEErjLo5UVetWobXnmnY1ZPuwBa+56cd288mXe+fyFdFdJ6HJgol9w+c4hM1cSI/tPawyUNocZaMaZdGIJQ6sE4u9coT2SoMiw4JAxN2jk7uJ3Qsb0vPNIPkEOb9HCYDhmLuddkdOcCIGUdxN7tvU9y9upc9O5kYlw/aDkJDaz+OeciSvp9savSsxBxZKDOHL6pvYMTv8y69jiMCFsV7uxqKNRHWCFIhMeR7mH61F3PKl4rSJ5rWDLnPFAjS5ksw+wWmnSaPptJSKVVc22gLWdxJZFHgmURWIM7/UUEqw1rhsm1Oxtnrv861RX8qoZdqcmo9S79DjH7xVUYL24CVhdMbc7hPAJCsquQxv2OlBYS1V8lwQkJl7AU2R8R1Ijw/82WSBaSZviHja19vlkGeARXKhl0pp2ZeFunaxB+rRs784uvbudHcoRKbQpnMLMXFrP5HJUcS9E5jcka7KesSQqbf2aclw02hUaa7gPOrz1lf/gi0xU6SCAPfIEHi8zRtNhgK1L7our0O2Z/+98ZdYH4VXS5Hj6933CggARgvOn+luROLwI95eqM4OUHmhN3oyveNMpABEgDxkUl0Fyz74xAJ1dfYerhGMGn3B99swUCPcysKWK7+t/bOw9x8s0q3jCtQg47f6Z302Z9EPU2axCGIzFdnswz1uQVoUqhBHqsK+kCS3XYsZ1bLvkcP4HSaQRQpocmfbO9/D2IPfr32yM/sHxqGs2MQ/6dYU3xhowYnRTRzNo4GcCDx4oMzY5zVOH7b5uvC4JdB36eeKuoruBYwg6im6woDXoxIcEi9EBaYGJG+oiK+QwZHsjqDIX76i+iDJEHXdaPgqAU5wekViE5zqwcpJn0y7sQ7dyl3IavjfL7UG198StZ5nsNsRUAqCLvOHuQIa
 azhrNfBn
 ren/ZB3ptqqN2uxeyKrNb/h7bn4wvb0L3Ph8U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 07:45:35AM +1100, NeilBrown wrote:
> On Mon, 19 Jan 2026, Christian Brauner wrote:
> > On Mon, Jan 19, 2026 at 06:22:42PM +1100, NeilBrown wrote:
> > > On Mon, 19 Jan 2026, Christoph Hellwig wrote:
> > > > On Mon, Jan 19, 2026 at 10:23:13AM +1100, NeilBrown wrote:
> > > > > > This was Chuck's suggested name. His point was that STABLE means that
> > > > > > the FH's don't change during the lifetime of the file.
> > > > > > 
> > > > > > I don't much care about the flag name, so if everyone likes PERSISTENT
> > > > > > better I'll roll with that.
> > > > > 
> > > > > I don't like PERSISTENT.
> > > > > I'd rather call a spade a spade.
> > > > > 
> > > > >   EXPORT_OP_SUPPORTS_NFS_EXPORT
> > > > > or
> > > > >   EXPORT_OP_NOT_NFS_COMPATIBLE
> > > > > 
> > > > > The issue here is NFS export and indirection doesn't bring any benefits.
> > > > 
> > > > No, it absolutely is not.  And the whole concept of calling something
> > > > after the initial or main use is a recipe for a mess.
> > > 
> > > We are calling it for it's only use.  If there was ever another use, we
> > > could change the name if that made sense.  It is not a public name, it
> > > is easy to change.
> > > 
> > > > 
> > > > Pick a name that conveys what the flag is about, and document those
> > > > semantics well.  This flag is about the fact that for a given file,
> > > > as long as that file exists in the file system the handle is stable.
> > > > Both stable and persistent are suitable for that, nfs is everything
> > > > but.
> > > 
> > > My understanding is that kernfs would not get the flag.
> > > kernfs filehandles do not change as long as the file exist.
> > > But this is not sufficient for the files to be usefully exported.
> > > 
> > > I suspect kernfs does re-use filehandles relatively soon after the
> > > file/object has been destroyed.  Maybe that is the real problem here:
> > > filehandle reuse, not filehandle stability.
> > > 
> > > Jeff: could you please give details (and preserve them in future cover
> > > letters) of which filesystems are known to have problems and what
> > > exactly those problems are?
> > > 
> > > > 
> > > > Remember nfs also support volatile file handles, and other applications
> > > > might rely on this (I know of quite a few user space applications that
> > > > do, but they are kinda hardwired to xfs anyway).
> > > 
> > > The NFS protocol supports volatile file handles.  knfsd does not.
> > > So maybe
> > >   EXPORT_OP_NOT_NFSD_COMPATIBLE
> > > might be better.  or EXPORT_OP_NOT_LINUX_NFSD_COMPATIBLE.
> > > (I prefer opt-out rather than opt-in because nfsd export was the
> > > original purpose of export_operations, but it isn't something
> > > I would fight for)
> > 
> > I prefer one of the variants you proposed here but I don't particularly
> > care. It's not a hill worth dying on. So if Christoph insists on the
> > other name then I say let's just go with it.
> > 
> 
> This sounds like you are recommending that we give in to bullying.
> I would rather the decision be made based on the facts of the case, not
> the opinions that are stated most bluntly.
> 
> I actually think that what Christoph wants is actually quite different
> from what Jeff wants, and maybe two flags are needed.  But I don't yet
> have a clear understanding of what Christoph wants, so I cannot be sure.

I've tried to indirectly ask whether you would be willing to compromise
here or whether you want to insist on your alternative name. Apparently
that didn't come through.

I'm unclear what your goal is in suggesting that I recommend "we" give
into bullying. All it achieved was to further derail this thread.

I also think it's not very helpful at v6 of the discussion to start
figuring out what the actual key rift between Jeff's and Christoph's
position is. If you've figured it out and gotten an agreement and this
is already in, send a follow-up series.

If I don't like it I can always just rename it to EXPORT_OP_DONKEY_KONG
when applying.

