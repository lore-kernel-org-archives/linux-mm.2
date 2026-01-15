Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC2DD33A0D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 08:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CA66B0088; Thu, 15 Jan 2026 03:33:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037B56B0089; Thu, 15 Jan 2026 03:33:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30DC6B008A; Thu, 15 Jan 2026 03:33:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD61C6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:33:42 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 220BC14021E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:33:42 +0000 (UTC)
X-FDA: 84333534684.17.63A31F4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id D1B2FC000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:33:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=c+60rQr7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+cdf73ff56b16bd1381a0+8180+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+cdf73ff56b16bd1381a0+8180+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768466020; a=rsa-sha256;
	cv=none;
	b=eHVezXofSjWvDpVDWCxOROszvBSBRFP8JTm+uFxDfO/C3X4QsJgArAK9FVf/Y6J+XM0n0e
	Y3HLRf4Py4hoX45CXpDyrAf3/+IJkUiRBPhdG3U8Qhw79t/fV5VLn2hySTk9wW8HGH/ZbR
	fxSuciFaPCS6Xs7c/ovVrmwsJgsnYT4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=c+60rQr7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf10.hostedemail.com: domain of BATV+cdf73ff56b16bd1381a0+8180+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+cdf73ff56b16bd1381a0+8180+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768466020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggIby7ZJJhhdPb6y5rH3a2GAOEpyxb4btFDkRofMARo=;
	b=MJpxwuxpXItXmB4VJBHtDnTw/P/LQBPseSelXlyzgElx29XSQc/8qk39hTBHxz5ubXxCnI
	cg8OJfNdH0GfCQ75G6++ZiVXs1IkmMTw1CyriDpw180rY2nXNxXhEbgaS800G5/xBt6935
	sWZhowpti8Iy+MFAcOIPFQwfviy2jos=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ggIby7ZJJhhdPb6y5rH3a2GAOEpyxb4btFDkRofMARo=; b=c+60rQr76h1PsKAd5LgZT9hsxs
	aNKhr+6hZylxOZstJG/1DgKDn3jLBV6CLqh93j+WnurQG7htCVWPbVvx6tOOUVmORqsU2McpPOkHx
	u9JemdngkpC4GOWQM49sG2cFmQXbWsrsABlaLCyNQvNPEl+M5kVweygSwI21MwVsu9pML78e/uHxP
	vmIIVXx4fyMCNx3hPFAoWaY/UvrDQx3Aoog9gQ+mt7L4rBcvXKQQLFteJUrzRcG5+ThbjMMlIeFyn
	n6rc9wHtWg+gNCftYd7qw5Q1lztuERemrK6iJ3CvqvoWgP9e6ucBOBNhWhZlZCMCcpDFLJa8qwA8J
	WF22tmyA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgImu-0000000C08y-0V2p;
	Thu, 15 Jan 2026 08:33:04 +0000
Date: Thu, 15 Jan 2026 00:33:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Nicolas Pitre <nico@fluxnic.net>, Anders Larsen <al@alarsen.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, gfs2@lists.linux.dev, linux-doc@vger.kernel.org,
	v9fs@lists.linux.dev, ceph-devel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
Message-ID: <aWimQEokuib7fXjY@infradead.org>
References: <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
 <aWZcoyQLvbJKUxDU@infradead.org>
 <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
 <aWc3mwBNs8LNFN4W@infradead.org>
 <CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
 <aWeUv2UUJ_NdgozS@infradead.org>
 <20260114-klarstellen-blamieren-0b7d40182800@brauner>
 <aWiMaMwI6nYGX9Bq@infradead.org>
 <20260115-inspektion-kochbuch-505d8f94829e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115-inspektion-kochbuch-505d8f94829e@brauner>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: D1B2FC000E
X-Rspamd-Server: rspam06
X-Stat-Signature: xo1yxnp1gsu364eme5hq3gt6esdq38cq
X-Rspam-User: 
X-HE-Tag: 1768466019-454684
X-HE-Meta: U2FsdGVkX1/YGRPahfPs8GvJ5jbaIqsrGr1pfou18cWz8dY9HJ/SK8EsNqJiS7BDYXcm0lNw2lXlC/Q+14/R4cBu7WSiQakvXB9QQbTrunt2YXSaYJR6ZwVXs35FIr89TN7Xt7gVee1KEpAr5ZDzqy0Y3FMxA09+EJfnn3HSZpFpE/WZWCJ+YSctoQoabE/BJ61dP94e2+tvLqXeSUwNXc9/ACQ4VA+uIp6CYpnyr4xfjcm4WiMyHZ1modedWIAf+BVfJK80hLoFv33nZ9tNXzi82YXYgWQ3JARKdZts2W7FsPVrUNP2IQbg89ZhMF+RCLqumeL8N1i+QSr4TYVZAQKNEX4DWPejDqu0/G1n1rZQYoNOzCtBMTehzqFqjshVw8Nh/0CCWrIELChn9k0mGmjghpEAapZsOiAtFfncw1vyUf+WgSlFCof3M9L4l8qK5k4jRy2+UB3+iTDtUdu+3aH07nxqDCwpACpzJNw0YQjH+C29jX1+59QiC4psH3+usXXQyI+98B2td4qtJ0JZWN//7kKwbHBBL0v8ux+oybHDRpYRoa5/Cz784Zr77Y7pj6DpjviZCT88co0DGCaMPBhfgW596NfyXv5lAes/TITLIBLD4GHtd8XLFgRDrR4ChAmFaFkwAvTvYUtyI9ftTJPFhMklRA8JGBwdJ4T3Fsoofu8v8siXwHYbgboBySy9SOhKTRxtbNnzQJbeJ8yDdkINV3xMdLzEWEJVQP5cmxJKt+U++ovzAee5QP0DH9ruumZMSGL16VxUNlJ5iVW4w9wpOY/JOuScTAPKrBRR7FuliOrInmYx2AwOHTPwKuM5Si7aFVg4g1xIinpxczIZsxMpcYRt0lAp/UGRqOQiCP5YsFyGcy0kbDSH30BxjvvOCCaFFDLT4tEh3eLTOWYrfRLLOyWYXA8Qcdl3Ex3R63JnobfLYJYHAf62WNtFq79hPacTe4uuHqQ86WCtxTf
 wZFIR8t8
 5WQOneAud7SHG9Pp53FwpLO0pkauVb8CU/1gH+fmYM47ZOqAHMpZ3JkRz26NRqfUGYEq/M3Nq65rmzDEwaFjJZpDyT/UeLjyu1BSVGDlsIUMsdW4Mv4PwYTulit3S08BwWGC+enrvpurnJ4VL3geFJFw+iangzAB4yvuewkWaTtIrvopTtzWjJMiVSnoGg29u8XS/+vBETPjQJovtdY+f6L8sf5eE2fUxG+e45KyetbLcFG1XeCQ32x7Tukd9Cr7C98SnO4v2iNcKnhz+khmrMtA1ZRmOKKiFVYNeEFVYzfv6pA8zQ40XBbE6LjUq5flRm4qJldoWhlqa/ijH80Mei93cTnKJoT+UbrFhM2KbPTZyrAWvIjqzKQtYeoge6GJI67pGYtLHhIFwGmiC/ukiVvHdQY6VojWyHWc+EBD1hfMVm0/7Ar89evlAsvhPyxjO75jXBj2dJPRgun/KXJAAKqBT0K/AikI7tdv3Ohd0/v8dsm2j+HOMGe75TE27flsO5R1g8eONz2X4iDCI3KnID38IZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 09:14:06AM +0100, Christian Brauner wrote:
> On Wed, Jan 14, 2026 at 10:42:48PM -0800, Christoph Hellwig wrote:
> > On Wed, Jan 14, 2026 at 04:20:13PM +0100, Christian Brauner wrote:
> > > > You're still think of it the wrong way.  If we do have file systems
> > > > that break the original exportfs semantics we need to fix that, and
> > > > something like a "stable handles" flag will work well for that.  But
> > > > a totally arbitrary "is exportable" flag is total nonsense.
> > > 
> > > File handles can legitimately be conceptualized independently of
> > > exporting a filesystem. If we wanted to tear those concepts apart
> > > implementation wise we could.
> > > 
> > > It is complete nonsense to expect the kernel to support exporting any
> > > arbitrary internal filesystem or to not support file handles at all.
> > 
> > You are going even further down the path of entirely missing the point
> > (or the two points by now).
> 
> You're arguing for the sake of arguing imho. You're getting exactly what
> we're all saying as evidenced by the last paragraph in your mail: it is
> entirely what this whole thing is about.

I can't even parse what you mean.  And no, I hate these stupid
arguments, and I have much better things to do than dragging this on.

> > If a file systems meets all technical requirements of being nfsd
> > exportable and the users asks for it, it is not our job to make an
> > arbitrary policy decision to say no.
> 
> This is an entirely irrelevant point because we're talking about
> cgroupfs, nsfs, and pidfs. And they don't meet this criteria. cgroupfs
> is a _local resource management filesystem_ why would we ever want to
> support exporting it over the network. It allows to break the local
> delegation model as I've explained. cgroupfs shows _local processes_. So
> a server will see completely nonsensical PID identifiers listed in
> cgroup files and it can fsck around with processes in a remote system.

None of that is a technical argument.  The lack of stable file handles
would be one, and I think we came to the conclusion yesterday that
this is the case.


