Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFDDDD37E3E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A3B6B0089; Wed, 14 Jan 2026 10:06:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B78C6B0093; Wed, 14 Jan 2026 10:06:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1996A6B0095; Wed, 14 Jan 2026 10:06:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08BCC6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:06:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC62D1404BB
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:06:04 +0000 (UTC)
X-FDA: 84330894648.15.248A34D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0319E1C000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:06:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2aGkR9+G;
	spf=none (imf18.hostedemail.com: domain of BATV+26d5290b15125d0fae64+8179+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+26d5290b15125d0fae64+8179+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768403163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/1eVpMenCIWXkmi+LWs4qBDeJZQRhQ1Mo2xBG1d6m0=;
	b=nlwBseHkV4qL6TyFNDGuLPohL09QENhcUS4pbavtKfbN02qQYFJmdvQuXQ7DF2glKTfew2
	wrjDC5PfIkDe0LSv1/Zk80vPhFo7IZHXWp9mZQVufzcW1bqyy6vc25MgB0RA+f0+2lPHMQ
	CbiG3eEYZm9lefoeUbt6E851gyw/z2E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2aGkR9+G;
	spf=none (imf18.hostedemail.com: domain of BATV+26d5290b15125d0fae64+8179+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+26d5290b15125d0fae64+8179+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768403163; a=rsa-sha256;
	cv=none;
	b=aROLKWNzTOGe3UePbv3eVVwKJ0b/Q5oeiM0WGX3ie85bQ9FD66KdV0JLfNCqhDAlbJtHUV
	cCOPQga37aF3SMWPiTVH+3KM1rf4t69aVTWSCvmBbQRHrcf7igrvc+63Z3SsU+DKvHtVQN
	0yBsYTPQufdzIg91sf+U2cx1qCA9l8I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p/1eVpMenCIWXkmi+LWs4qBDeJZQRhQ1Mo2xBG1d6m0=; b=2aGkR9+Gq07Pqsr81YJxBM46lt
	pC2tFopI1k2CQN/EQyBvUMbN685on8x5U4CpdjMpkFZFWeBtSU1OM84Ciw+y3szFcelfmqTyyg3Vm
	y2DbB7FtxibRk5XBq6sH9x7jaP/v3yPQ2Ob6mTE3lbJs+jMPsrwoZFGtqfkkexkKI90sVyqCbvrKN
	zpFbi2ZET+fTj2fii5dhkiKqKWNVPeKcG3n8jccbhPTVNNeRCqGKQRlyNUdLbE0ua8zYfilMENTNi
	ksLGJd1DFd0SiHbXxA8bZhed6Je0ZmYu3Fr0+QZKywruGLSgXGNe8uS3svWfCZcAVQ+74djzH6mhe
	QKhXyQqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vg2Qx-00000009cKq-2YJq;
	Wed, 14 Jan 2026 15:05:19 +0000
Date: Wed, 14 Jan 2026 07:05:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
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
Message-ID: <aWewryHrESHgXGoL@infradead.org>
References: <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com>
 <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
 <aWZcoyQLvbJKUxDU@infradead.org>
 <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
 <aWc3mwBNs8LNFN4W@infradead.org>
 <CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
 <aWeUv2UUJ_NdgozS@infradead.org>
 <c40862cd65a059ad45fa88f5473722ea5c5f70a5.camel@kernel.org>
 <CAOQ4uxhDwR7dteLaqURX+9CooGM1hA7PL6KnVmSwX11ZdKxZTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhDwR7dteLaqURX+9CooGM1hA7PL6KnVmSwX11ZdKxZTA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 0319E1C000D
X-Stat-Signature: ed8t5ag5ezqc6k91fckjze4xzub3dms3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768403161-297028
X-HE-Meta: U2FsdGVkX19MGTmSlN1DzrTick9iR5WX1+XxJwOS7emYNUamqIh+1WDwLC5sHC4eHmUAZvb2rDTUvy96wB5UcqIEaz1/8JczNiGN1wRtr4/YRs3eTYyI6wHmLdR+GkNCIrVPDqsiFTg9O4ZbVKBLrNAzSJa5z/9vx5EOtxGtM68CpIj3IXs0jLZRX9w40hJX8niT7WLw2uAgtgXB4p5cgf4CqMHRWEEW0h2ku6eggzW8sGh3KotxJC5JWNzhYkH+EN8AxpwBjvuyBlWRv7Nex6UclLgaBCtsp/deGiJdS44cMBiJK7IzP9gdlInM5tlUfNKMPKHxNiA7fzYe/Y8J+9ZmMsNDFT2QszQxPwdL7ikTmoc0z65dKnMOnspdq/GbLIBXd4u0Zbt3GY6dd1PkFfbjUuVsvxWQSQkUGl50fWry5+94od1naQy8uo8lgk07nEFBbOkkrkP8w3eWCvWcnaRje/0vsI0iCNnzrIRVhOy41rW09opE5ihAPH2gpCbguv/NlIX4wZRWIbbRXRwvfa/82oUbo64kqi3/1NjuQlxY/QSR4hog95QVBD2lv+2TeES//KGBaNtIpgjbTXu8+Y10wD+0a19dUuiun5VpTJIPZFP8fxMofLQ4XR4YL3H9JMlfnXOJz+v1OGSO0Lm8Xhp6jY8KYCfpSDHYL+n/KMRYTtPCGUkIUVz2CGoXFOqd+FwiQPuPsFrlnu+V16Yw760BWNEn51N9ePnyyhGND8XmROfnAKtRAbaTcmV2uoMlZVnpOSCsY69TxfEFzlqlN0nTHSaEuaX3o6eVsGTvpbQyv2bRLS2F/V4yuzcbkvotj0HpZHGCYeAVQTddH46MoJ7vMmIUhvr9a+iwoyHf2gO7aO7zIVDM31gX8vMgPGcYYVWmZOirWf+hiT+K4aFgXCGG8t3h4/6xkf4FbE39dGf+B3cS57t/rj/fwQl1d2z1e2vMkvgCdXxv9XiHjFy
 fZ+qHKVO
 BSyym88nx/LxtLGbbbdn9DlUTGt076XvSf8ffm1YMr/7umGLpaKNuM47D67YBswAdmdpSKVPBlka4ODUcuhtIpQ192ImtOb+yeUEITxLgJ7Dtbmbrt2oeASMi90PEOmGn5nf9zAivdC/9HfSn+2MjoTujN8/z0fpNwXYS2vgrMa23l125qHeBkQpdXn9JJLiG0bwIX4rw89ZHqLxNVCYLW/k+J1fXSnFgq5e49FV71zXj6MFfJMhDyIvyVpipPYg2uEEyEKE2xYIbePdb7lvjwr1KvTMANrM+RW6byJ7f1LfTibJpC18NFZk1hAqRHyO4BJ/jRE6M4fU0d8Aea1e+VQfhgBLQA13Jk2iKqG2P21wm5nykuom8t+SI40h7FfHi5JiQDDO+HquR/hzgvCRCuP0Utg7ovLfC08RzgrPo/+oo7O/KpNqn+bgs9+P/HdJ6meLzuIgrY/QtMeQh0jIghkxFEZ12QtzSLSrkQadkCkOl8GLg6AzQPP2CPtX4nrEYBbZPAtqUpuLUUt0v24/iRawPOJFPuY+NdAq8YHsljKbti52M2Jg3Dw4qWSrs0ZqL9qlJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 03:14:13PM +0100, Amir Goldstein wrote:
> Very well then.
> How about EXPORT_OP_PERSISTENT_HANDLES?

Sure.

> > The problem there is that we very much do want to keep tmpfs
> > exportable, but it doesn't have stable handles (per-se).
> 
> Thinking out loud -
> It would be misguided to declare tmpfs as
> EXPORT_OP_PERSISTENT_HANDLES
> and regressing exports of tmpfs will surely not go unnoticed.

tmpfs handles are stable.  It's the tmpfs files that don't survive an
unmount or reboot..


