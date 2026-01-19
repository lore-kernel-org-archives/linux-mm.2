Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC220CA5FFF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 07:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002946B012C; Mon, 19 Jan 2026 02:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1D96B012D; Mon, 19 Jan 2026 02:56:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5E76B012E; Mon, 19 Jan 2026 02:56:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C94EF6B012C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:56:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E949140692
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:56:55 +0000 (UTC)
X-FDA: 84347957190.10.3FDF02D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6D5EA1C0003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:56:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dSF1IFL+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768809413; a=rsa-sha256;
	cv=none;
	b=uTnaOpFcY87SAcxaI5SEM7PK1fy9O0aHT8LZFbt5NqeeuiRynE49ja9Mejta8FfeyDfLrA
	qPE/trh7i/us9QnqQ/NdkPl23a18eK+ekkcDJClHGeixJJ5j1jiuq1W2bvX2OrbAlVkyYb
	2R9aERnFUP5kTMEm5j4SDWi1z+z1+3g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dSF1IFL+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf20.hostedemail.com: domain of BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768809413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dkq9dFVnQ02ADyLqi7RRrcu9zIfz19y2EpNLAEqzuhU=;
	b=qK6wt9EMHfveNhtaOmgbl6IgPMAsqw2vlS55TihxipOA3UbC0+M/FmwZGAfsWDsMDgVrXd
	BQ+FQd54ygZo3dA+CXvEzWjUC2NWUkg1sBFuPVqUozgUTsLl9R4lfWqYcRqI4XyQGyo6H8
	0mlCC6tb/Y9Iw3YJyPSQHNz4V+PI5EQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Dkq9dFVnQ02ADyLqi7RRrcu9zIfz19y2EpNLAEqzuhU=; b=dSF1IFL+VEbufi9323VoWF6NEa
	USB2BXBiaW7TjezbApRts+YAG9RNRYfhPamD4lev/bOGd62WvFVIL6sSe70b84ri0HQwV2wQR3fie
	NHQfWzjRaVOmQbjja6GffvX4ybd0IoBxLkxlZm0WDdh5PD1BKJEEZN2XmKjJt0U9yUpYOoLXyNoKl
	otc3GgIv/kotdkVdSchAlA4Bqh/5N1QYuwvhjeDy3jpLtEfduOvglzvDFa82EF8VLL3CFeM6qtHx/
	hFOG9hVRMecn6BOFZagcxLAIBWCAy/KYZmHunHQQXYX+w/fhRGaYWCtIXaohApqoDtQ5t9IT0ZpBl
	498p8SdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhk7V-00000001Wju-0c1a;
	Mon, 19 Jan 2026 07:56:17 +0000
Date: Sun, 18 Jan 2026 23:56:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Chuck Lever <cel@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
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
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
Message-ID: <aW3joQQvz2t6xkzh@infradead.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com>
 <CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
 <4d9967cc-a454-46cf-909b-b8ab2d18358d@kernel.org>
 <aWlXfBImnC_jhTw4@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWlXfBImnC_jhTw4@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D5EA1C0003
X-Stat-Signature: nf775foyuqs3e7md8uif3rgw6sirywx6
X-Rspam-User: 
X-HE-Tag: 1768809413-946337
X-HE-Meta: U2FsdGVkX19ryiFsCfnzqOPfTV4qx5fNCftSUW9dhhrEeI3TYHmrsv+fTKdSHEM2v0WbRbAi7gt086GTgsDj3UYmu2ZKHRoFp5U4LvrgHcOwAbCbHJ4tHfBY9HunuFTm1VJhv6oOTSQ4nk+B5O6gVInx+MolocAQ9mHXSt2xAasY6e+CoMLi/3uMhbOgliWkWp87DM3L5R90r5nVlJS+uQ+TvNrqYuHPdIqqoJigFMmzX/vyscUDAgmxtqs891migIC5YWgyYnS29/XHTcYJJiSmVqbjgumifbPKvP6BvIm7OGeHRiXkUcsFq9J+Qlb5jOn+I8JtEZ+aDqWI82Q7dXeeFaGm5+NAOTALWfZsxxJ8EB0vzV8OnWk4nakkt5+WMELCo5eoKCwqWF8TH51S7+Y+9T3bg5Km6Im8o8IpvQ0/c9qMNy6e0N/bGxmSHJt5tO/PtVtlMMNrf3nWdN2Y9MVunsRHC8AOG9Z3Inp/8W8h3Bu5cbvmiK8sIPplxnBXFUVQPksuqO7l8QzgHiQqQv9FTj7Im5+1j+PKD5wdldFCR9sUpRv6221vTD0qlwA7LgBNAx4nzPFy8wJTp2DaQrBa+LrptHtudVPd+qhgtAXEi6zOsUF9bfCxgOyph2IUW5WmqvFJJdWBgoiEnZZ3yqXRrfVmw8TdUcLhfr5XOMiqTwgYXuHVGT+CGRmlYYfncSOoGCuP0U6Pcvni/CHkfQhcaMDEkBH1Zc8vBBw9aPFqmqwtOTaQ81+Yl4sbugRfG2Z4wolLKf11BWJHiVern2vSFc9FR9SfH+sOIf/3/6vwO9axGb7vj5i2hN5CZj4wDTwNsIGoJ9++tcJAXWR/ePdsdHuj0nuk+QM4j7k/2RJFJndXeWmO1bRu1PTANalQk2ElCF9oTLTBI3vlOz7lQDvt7HrM7rM9arJwC423IL/Fe4x5THqg2vSX+PdbzxpxCDQPEOpfbBdlTPoiTD2
 owr749wU
 3Q0Z5/r3SHXTxZl/yWhdPlALrXBN85+5YpLrFV/JM269S81kdlbBYEQS3sTKIaofsMcAJxEJr53Wh386Nhz9bZCCGt7UHMcMKTR+h/A+aEDQgD3Eymel6hASsdsTURfIOr2euDoRd7BzY9c0l9R42M2ifBUu2F23/B8bYIOEt7V2mONk5xRYe6o0gc5eppH2L8SX3ucoCi+SAqFC5cDBFRnRkLo8ktyOPixkfMfOG2iiqhhlczmDOwAMLo/y9N3vb/Y+m6/dC2dBT7Ko1dB7r1axnAK+ycO/ueaIb47YTN82Q3nM/tatUzg5hzOpm/9rj0EjWy1avptEmVyembfz8BQfkybvRxNL3jkq4duJ3b2ZPPO9MbHAKWnlW0OA0I/Q8BkGhhPTFfmGjtULO5+gxivwvglXaLrLmPfIl98CIWu2QsnOkxyDJ+I+5Ezbuiq/KF/ozCPZ2PkP4cf26YYF28RqUJZq/mVe4iY6yJ1MNUXAI5MthpXbyw0k9ssPNZseZ8IfWsREBRDpRsHHOTs3m9tyftHSx2s7f6BlsExgbBHzQVHPkHPjVIF6LTFwTp9XqnQz+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 08:09:16AM +1100, Dave Chinner wrote:
> > I think we can be a lot more precise about the guarantee: The file
> > handle does not change for the life of the inode it represents. It
> 
> <pedantic mode engaged>
> 
> File handles most definitely change over the life of a /physical/
> inode. Unlinking a file does not require ending the life of the
> physical object that provides the persistent data store for the
> file.

> i.e. a free inode is still an -allocated, indexed inode- in the
> filesystem, and until we physically remove it from the filesystem
> the inode life cycle has not ended.

For other file systems like ext4 that have statically allocated
inodes that is even more so the case.

> IOWs, the physical (persistent) inode lifetime can span the lifetime
> of -many- files. However, the filesystem guarantees that the handle
> generated for that inode is different for each file it represents
> over the whole inode life time.
> 
> Hence I think that file handle stability/persistence needs to be
> defined in terms of -file lifetimes-, not the lifetimes of the
> filesystem objects implement the file's persistent data store.

Agreed, although I bet that is what most folks think of for the
inode - not a physical place on disk, but an object that gets
invalidated on the last close after unlink.  Either way, that rules
do need to be written down clearly.


