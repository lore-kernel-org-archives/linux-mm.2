Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62FEECA5FFB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 07:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6366B0127; Mon, 19 Jan 2026 02:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B83546B0129; Mon, 19 Jan 2026 02:26:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F1B6B012A; Mon, 19 Jan 2026 02:26:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93AC76B0127
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:26:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F4ED1AEF2D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:26:07 +0000 (UTC)
X-FDA: 84347879574.15.2E2C4DB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id D192B40005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:26:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vpeslnKs;
	spf=none (imf07.hostedemail.com: domain of BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768807565; a=rsa-sha256;
	cv=none;
	b=vGXzhiubrnNc8NoU16/5g+SfBBb2YWf6dGCNvNwnLWBT+rOiw0S5D/3ymv4vKPZy4sGzAr
	Sd5E5EeZ3HfI3i8RHPJtkONTyzX76vPjeK1j03AKkfo7hEW8QxprWWUsMf+9yHOZpHRiVy
	KPHa5Zipw4ySJxTsf8BXPTV72GhtKvk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vpeslnKs;
	spf=none (imf07.hostedemail.com: domain of BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768807565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdeGvwbQpxlPUYjWclzPmRx+IQVLHu58bH+XT7BFy/E=;
	b=ViCTRTtpaBFRxHA15ZywGuHNwhpZvMygBLIvK5logx3Fij2/mX50F/wKpBvAm9mNoBh+Rb
	AqJgNE/0WAAKex0OC2hgf7oymkKN1vISK2jPfC13VlwL4pkrB1jgo+/V9flnZ2apZSsfRf
	3E1Dm5HmBOWkgvJr8DUdFyLLzMqGTr8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SdeGvwbQpxlPUYjWclzPmRx+IQVLHu58bH+XT7BFy/E=; b=vpeslnKs0kEtVQxLv6zNmfQJ5G
	TvTugN4T4j8RD3Vs0BnXZN1QzZqnB4D7uOdAA11Ur0t3FPPWnxyfuuCAHPZbZ+6wIUcEefsFQ32co
	+vCvtBifSMAf02TAMYGbQKi4iMCQo3oLC4QmJQRv4nD92QhZOq3i1XdBiPArAxd6H9i8+Z32A6WcT
	whFYQHvPf8xiWhPRik6EgKL+Wg7G7BqYPvWQS48IfwmdgkkGq1lEXE54n/opOEWpDoa7k0Gy5BYqw
	v/Urt+eLDpkqilIUEQG+hJ24VWsryY+AhaXCJ6FiWwFl73fxmpKewmcmsKet/MLlOupEIGvPesfBt
	nMXlmQbw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhjdu-00000001TQi-3A8r;
	Mon, 19 Jan 2026 07:25:42 +0000
Date: Sun, 18 Jan 2026 23:25:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org,
	gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
Message-ID: <aW3cdlSjcXqcV1VO@infradead.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176880736225.16766.4203157325432990313@noble.neil.brown.name>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D192B40005
X-Stat-Signature: ak55pkc3etd1riakgghwf45ejqn3ws9h
X-Rspam-User: 
X-HE-Tag: 1768807564-387561
X-HE-Meta: U2FsdGVkX1+PBH+tk1LhT+xmNqK7dDHS0PRo+D6/eX1HBIrQ5WZmspD/ZGMZQ0IG+4XV192hldZhirApsmDjALYMniYD0Af0lmyBJFapwoz1Jzpd92959418fJmNgnMKZS6/mXmLB4h9nARIXKIgf2hMDQbBcXYWZR5i5iSTmLb2rke1f4tUwoDBJtFjCDd0XXzOjJMfq3R3BlyuQiGwvl8QQ5zUWLU0gDzxkf+SmPNq7uC4jS1NYXWl81fR3UZ4wQN+OqjE/uG3fby0ZNlazlhHcFaUMaEgrsaPswAsDAWrgQyKr2LROKQx/ZeRipJ35UA0G0ittm9RdevGky/Y06r80V82tc0b+N9OcSp3ItDiJpWSECe9YPI8mN3LxZPMGegu6PCEv3y/PH6VkPLAqfDGi6WS2awMObW3Y+AoUKFOQR8GWZEjzQop45zXIaqYgVH42VNzdnkY8SQt/TQBlSfUrfinTWdSodi52hBJEKhFNybEZPEXGl9ruGvczTgkX0QFWrGS6LBTKy2bjAdcKMQgOiylySj9mEkf/kfVX0pSC0yG/xse7Ol8mfx+k9uqRn5oSWkTdXMF2oRxRG4tR6+5GjLG9Mmlz5H++UrBMfJylK8YhhdlE2ITHL0/EMc6RqW675ngelAbAJf06e1itU5y+ouv+UdfqViifZg1rZQ+ziKZYNOczakRHJFo5t7YYaxHGSUCXdYROFMacvxLJyBUV/KS5hsYd2EJVEZNKKgZg3C1OXipK4p7yGw/Hkuo/1r7noWQx0/PeZTy/J6uq0eTVCmQS5HQ73yymBNN+W2PRQCF3fzvfl+OVjFHrgFpaFun9diBcg1EVc8Cket9Z11OifUd1iJ58K+3Xl4zXOdwTGPskNeMpk2M9RiYfDpOwdfRYPOtULs7joWR2uyUDVXh1vVE0elZS6wpluiL/0NFaHjUV54TXKGuOYiDo+OFWontMvf5jtfFqZWXcZo
 xbAvj3ah
 VUoZJZ8OTG7gevRSoLbCNSUJ5vecFtXC0ojCEx0/c68I+PG3uDU5CoE4qoDBy+48uyPaSdD3iHHfRUpwzjQs/lG7oUPCbJBtUR4uWqOdpo3Z4JDWmPqaNoc/FkadBep2S/AUnkhCWPVAZwl/exLDqn2LGJtH0FysYAOJwMTGtxLKwDCq5LMr2KXDyq06OrzLeSvx43G+iq7FJ+yfYWh7Sgjn1JU4mIKYp8GnPFUzyCZRlgPvQ9PlfCt/6oo06FaeoSXlSj0HRbGicKUL5/3s3/Ja7zrNKHOUvbqwQJoMIyEmR75QPQr0Ntr+an6RBgsmYhn+2HGmxYB2RX/mXNbe4j73kmYTZcyCWcDfmL9s262ObWQQiNzrcDxFHySKKRh7wZffls4MEQp04vrTxAuSNu0JW2TFMFo7i81IIDybMajBk+sWKhk7QsJkqy+vmZUO6+FJ+5Rg6y0hBAAuUgJBkT/ze6Fo7HzKDPWQmUAQ1pmGz8JAAwRKm/Lz4lTHgpPZjw093OToZ9fPUb8IfuqSE/UES/wcrnWJ2KEVvnezxUAbjniyrbK62wZDfGvXD2ZPSss6n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 06:22:42PM +1100, NeilBrown wrote:
> We are calling it for it's only use.  If there was ever another use, we
> could change the name if that made sense.  It is not a public name, it
> is easy to change.

No, it is not the only use.  This flag needs to be propagate to
userspace through statx or the file attrs.  As I said before there
is plenty of code in userspace that does rely on the traditional
file handle semantics.

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

Again, stop trying to name things of the initial user.  Flag needs to
describe smenatics, not users.


