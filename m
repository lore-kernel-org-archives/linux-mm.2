Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E362DD2ECF9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 07:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11006B0375; Tue, 20 Jan 2026 02:38:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEF06B0376; Tue, 20 Jan 2026 02:38:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA20C6B0377; Tue, 20 Jan 2026 02:38:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C35726B0375
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:38:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 297F4C1A02
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:38:34 +0000 (UTC)
X-FDA: 84351539748.30.6D201E5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id A14654000D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:38:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QQjy8Utf;
	spf=none (imf04.hostedemail.com: domain of BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768894712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWgDWsJcZSPLDHs9IJsUoi9AsdVhP2NHHfcQigencrE=;
	b=oRmxmK3wosfEPeU7yNXk48n4uM25JjJsbnX7ciuhNMRIox0866vCQyleVpz66oQpAGHugj
	guzSwoKxB2Fgoh/0bx4uutw/18HAzTs1IZOySuE989NhdUOXRPMalQU2tyeOrXp6c6pMcq
	y+NaJfnYWok2dlv+N4E61YRbDHL5af0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768894712; a=rsa-sha256;
	cv=none;
	b=Lh2xWbRBCNuhsvV3VkNBE0XDj6MeCtPqioxxgs0U1hKMWxK/MNp+U1dN3vsJNouujdtg0F
	uer6fMyshiyt17uoTGxapoZsC1pVU3KwJGzh+ZUHkbK2W6OxWNi0I8tvU0ugNQ7PxiErgI
	LV2igXT9OS0SO0EoNatxeJEKZOaicZ0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QQjy8Utf;
	spf=none (imf04.hostedemail.com: domain of BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MWgDWsJcZSPLDHs9IJsUoi9AsdVhP2NHHfcQigencrE=; b=QQjy8UtfJINxBhZn7YjEMtg5bI
	RR/UTX6ry3NKZFPfoe8NvA46huniC8Qe5WKKYr9odSic6x/azSx6ttNuGshX1v/vo0/uShB8r7jvu
	oQsFb6UppuK9W5J+pQ3LkkqP9wItu6+F+hdSK/8VV2v841T7dec2Zxhhl1cf/V6K+X8k3OQle+nM1
	+QFFtmJGhnxZTPqgAKCdQOUJoPKo1QuoWKyKACFSMKWKPzqQYD3//Ir7gB2tYr9y/jfHBn8vwIeOu
	m3+XtJchvn4RXotvr9JWjd2NEnaFbSv/vkLKgykdLYa9ocsv+hA7DGOxFY+mj7v7P2zZZO29/i/nl
	B9PJVAUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vi6JN-00000003MRN-2vIx;
	Tue, 20 Jan 2026 07:38:01 +0000
Date: Mon, 19 Jan 2026 23:38:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
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
Message-ID: <aW8w2SRyFnmA2uqk@infradead.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176885553525.16766.291581709413217562@noble.neil.brown.name>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A14654000D
X-Rspam-User: 
X-Stat-Signature: 4ptpgqehpan66pwzgzbdmk9wdd8qpozz
X-HE-Tag: 1768894711-127127
X-HE-Meta: U2FsdGVkX180mtJ5FhJysbaWDyFkXov2QkfVxJzrFfg9OBYDdbndKB1uKXmaPn7dJ/YxZ20WIADsT86m12bbqJFUEGKg1D2geVplgWT3pA6M3mnLjXqmxuRAV4nK31cUlT94qnEvoKY7Ilzd+VDN2TLDT0QUfP277GDEjYD+hOlvBheKk9jpVLjEDCpa4Cgbkf4UTeER+gtVZKfSwmm6+QUjxqjbW8eSgXQVpkJhakq4XHVirDejxuvlsL3bzz9T/S3k5J1OT7NkngDyuHUhJY5ez0Rqn7ju3HgfHHMR3lYtHO6SVMN5v/ocSh/Af878Kz/nQtGKWzHwPvxi8BmfZO21BXiebVjOqeZh5B26flXz8sP+Ptc0PZz1eAidGgt1N1eySU2WdaswrHJI9sq6gsF8NAdvjpyq0FYrnDKPFZiKogr7mvtJJO5QSANaVt2m5TFCVTd16LPV6XSUP/FJO0/dLhyzjeiRnYWKLDaGQhCbnY5bkFnpMbBXys2gbvzkbzuSOaPi0GKxvYNEZ/UvgiWyN38ilQhTnJi7l8nsRGcne+l90UH7E5KWM1Ey97Fh7BoUflL4KznriYPmWjt7WMrp3fB9bCE/6Ar6KlaGsM/rcK4blW5MA8Lolm1gtbzfwfEHkKVtn9c+KdEgeqQQ6aTLC4n5gX5No8kM25qcdkSQ/SBgT5GDzDBNVLlwYXQ17gMUZ1Icn7+X7K6keQ//BQ/1rLk4yVBilEJppGvulZh1Q/GtMgv4/C6tYbG+8at9s71oWpDfshHTtUVZG8IldYF5S/Jhv4NHqbzUSYTml8fOF+qxAGDTjMIrrlxA8nvCIeQm61rBmErBerY83wOgfosK7MOQwbDMfsZYbT8h8bPZi9t4WvRkOSvUXIghA0tbhekmEcPsVzB8B9u0Aux8LD1d9UkS/BF9qAMnkdQHqszdJfgS9GQBrXxP5d/ZMbWdlcMSMt6aY658mExhVW7
 LCkccczj
 6Clk4BJkarpQYYUo04dGWEmm43Gv8Pn5vm2Qqadpug5OhZ+IO28nC5w4yXhAoKZpo92XX7yR629ijrL1RhpMmzv1hVy0OoM5d0UMhA6NrM02Ji1t3eMA3MnLZZd0svbQhQ0XjWTzzMysTiUbJzb9TDe4YUD1d6BdMxFZH9AHO6Q2y/w0uAk83jo0Mxi2imtQmBuNelNMdCmfNuuOqPb9h5Hs8aOJ3IaOvSK2JXhtPsYz0V0NMoVHZT2/fm9r1jwHvTLRRa5r3mPGeQgTVh44gcFkXdZTu5d1i1KnFPzQeYfSL1OKn8xk4UaoJHA1TM5KXEYICh6eC8dBQehe28emlFbxB4AFjy/E54IaPzdw3zkBH81DG9x9heSdUSEe6tsde87tO3+LihRg7GK2/vuNaxdz5mQ/+LZ4Bze78hyNsnvjHkxM61V1tZT9EWePmJtv/FQfGZu4L4txL+ptJH9FG3w59VZ4RupZviNEwMexmuH0pYqxRbdz7cY9UpmpnDkVi208XWnTBHuP7Fe4PzI2hR6E2savm7Xo92v8NUgPfgbblWPReCVCQrBdsG/N4n7fM0xSy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 07:45:35AM +1100, NeilBrown wrote:
> This sounds like you are recommending that we give in to bullying.

I find your suggestion that anything you disagree with is bullying
extremely offensive.  If you have valid reasons for naming something
after the user instead of explaining the semantics, please explain that.

If you think NFS actually explains the semantics pretty well, please
explain that too, especially in forms that can be put into
documentation, including for the user ABI.


