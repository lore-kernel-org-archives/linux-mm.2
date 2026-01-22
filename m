Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 168F3C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 06:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BFF36B00F2; Thu, 22 Jan 2026 01:37:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CB26B00F3; Thu, 22 Jan 2026 01:37:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644656B00F4; Thu, 22 Jan 2026 01:37:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 532A96B00F2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:37:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E08731AF11B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:37:40 +0000 (UTC)
X-FDA: 84358643880.11.EBC9D9B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6E55CC000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:37:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=veFu9ksh;
	spf=none (imf28.hostedemail.com: domain of BATV+561f00ef1fac768e3611+8187+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+561f00ef1fac768e3611+8187+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769063859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Zt3JOdWvHJawcEaPBAxnFT+w3W/aAsZ/dTBj3bBY/8=;
	b=AOtiHwbi1h6hm2XKx41tEhTUPUgkT92SO8ilBabvYnEZD+0f8odN9Fj3jmO/aSmlRubzwf
	0DopK0ihDHoal25rJiRNuBICy+ry/Hl6mnXJuJW2PSNIgXi4U8w/VBko3KFB3Rsf6UvkNK
	9VFwA5ubMqNoho13sP/33dZL81rM/Ss=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=veFu9ksh;
	spf=none (imf28.hostedemail.com: domain of BATV+561f00ef1fac768e3611+8187+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+561f00ef1fac768e3611+8187+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769063859; a=rsa-sha256;
	cv=none;
	b=C3a1D7gY25sm0AVVP37JMLA8s4uP5xaJkAokDNH9qvImmaXiX9Ez9JUcoaUEwUMvSEgII7
	CAqlk62wlm953SKnNXSYNKNxqlC6QhZxB1/CRn7pvY5DutcjeahvfSUbYwccBVy9hHmOCS
	O2AmWsr3MEzRaLJd9h/DTwjAuFdACk8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2Zt3JOdWvHJawcEaPBAxnFT+w3W/aAsZ/dTBj3bBY/8=; b=veFu9kshJmEfxX7sRSxIgphS5e
	GkI5twtuDvheZEcQcOVcNTVolyxAV6yIm7UVZuOxWiUq6LguBJpaaB/O71+aXxrhqH+X9CW/4A2n2
	fS3arJyIzUy/31I2DAYhclYgb5MKjv0Mf4rp9oxF0P0vGPZj8C9ofNbuOUQhZpHCmS19OqenLHTkY
	HPmFLmSxVNadVN/WfFM+uq+Jt2e6qSniJDaM5pDsUXR4/42wdoJgduXil3KiU8EbDXLw2fqtmy14M
	6FyvJMau1BdSFMJf1dtb/j/2MnbIwzYxpFzI7GzNAiBV/pjgNCqH1CNn/FHFHKcaDh9eja2CZlL6d
	1D8LeJDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vioJY-00000006VUJ-2qSm;
	Thu, 22 Jan 2026 06:37:08 +0000
Date: Wed, 21 Jan 2026 22:37:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, NeilBrown <neil@brown.name>,
	Christian Brauner <brauner@kernel.org>,
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
Message-ID: <aXHFlF1tef68i2HU@infradead.org>
References: <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <aW8w2SRyFnmA2uqk@infradead.org>
 <176890126683.16766.5241619788613840985@noble.neil.brown.name>
 <aXCg-MqXH0E6IuwS@infradead.org>
 <176899164457.16766.16099772451425825775@noble.neil.brown.name>
 <364d2fd98af52a2e2c32ca286decbdc1fe1c80d3.camel@kernel.org>
 <aXDm8FPPOHs04w9m@infradead.org>
 <3210d04fa2c0b1f4312d10506cac30586cb49a3c.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3210d04fa2c0b1f4312d10506cac30586cb49a3c.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6E55CC000D
X-Stat-Signature: 41o7qdc8hfykp6h8z7ij5kxxibaqzrry
X-Rspam-User: 
X-HE-Tag: 1769063858-919301
X-HE-Meta: U2FsdGVkX1/ZS0wvm5E+gMbMo7NWFXovWOOO85sTXXs7xNyO03YMY4YgTzkWhW5fLp335RoG+uLjUjBeYiuOGvXqwPpPjMMOmPAKD6alwQFkSYvN0FOYbWYuxljR+cFjR8YBE1ws23f9h5p66cyqq2cdkgS46TZi5NKx9Sa9ReGmTP5M69O5gfY9L+ikFrBZct+LXtcRtFd/+58EKX75NPjjUTB2jmtYfVSsgF/vqBh1uoMux7KqK7AdO9+oH2MMzM9vnmHnLrQJsL8LaCPeVehXxU2MklYlRAVaeXTP3xnZ5PJ9pZdIsagOiQBJzmWuzCXF0hJBLeu+XRV0FIyIf28/IqZlS75eVQdPhUEvon2k80n+9+VlzFrATsHNwC90WyEEfEc+jSD3QOt6asOZg6v2b2wS0YfG2oD9oEAWMMzQ0w04jqnjKYHmEJdstAvSxbBuBJ4BiPLgt5a3Q1neB2xHb3FYlDQBmhyzMNTIJxw0sNIxWDc9a2+dPwzlXBrYhZInAOOTbPZb0LgGgH0FkKv+21kwiSZNjp59qiCJ5bNoT/dmkaFZTq00OK9RQrHn8oI3Qt0JLC09pSo5V3/IrvgAsal3pWh0tLb/7aprOvosRCRoXeeDcDztcv84Hdu3BVhH0W4rDNkWUzc4a8iLZlskqjCwy5lc1NdpjWvuJdWbBvz2NEEknCmcYJSBwFOi8lfUE1L6HMi5e4HFp2S6B4s7ZzjB3ylyUVJczc2Qr5vXV+8V89mHknc/9XZUEke7HKXVLWEbDxbjj/VZr1Ng582pUveBFADchc5iF68E2fDeixnNHGkecWobQsdREIjd/lzLBprYB7Dz9JSKQOANNkhyjF2IbM6zpN2tumiUDPrvC2isrMwsH0d4GoQnf4IekfuSA7lmGsJltfiLaOPlNCcsJhyfdreAmhi2x3TNNxK6UzE1l5yl4PsY6Nt21ZbC0SISXiL0uMRjXibN8wu
 /daIBr2S
 7CZLPUbLU7WQBGgexccYgc6IT9XNtz1vOeZ3wJSKmSTsl0pAg/yxMeSdmzeiNrUYprCZcWOf+U6ffCD6DFM+O6UiCVSkxJiSAhef8+H3YRvgKnqAwGsx1UjWL2rmTh1EbfjXwRbQl8ghPRNJxwyWxEGVxWDQo6j2o/c5Gv6mExqIuopFapmQka5zFfsQiOBOec4X16JfLLWJ7KtZsM/T+0v4EV1LI8duEaOBuY/+4mqQggNpaikBsSdZhATZlpBQnlrunSjO9Hyk3G7Ho7vaYXRczSqt4f9vuGJauP7pN0w+8JDJroaYdWvMvtjR1oOTFfltp9rZho6Yu+St1bA9xcN68jpyG9jj7MPIPpVam/zBy0R8JPgd2xuxIsIpxnsqMx/7tvGEWPHF4LABfN1frgzl9BE+ZSar7FeNFNTymUCReugT/OjeMQqK0zjaAxjmXFoaL6dYLFxXqiQm3TUzlAtdmX1qHjEGy+PUWi8BgcVOA08Ichlx2XdIATQ1XBbzn92LO7ahr//GBTBe34v7bw4V/+fg4mFH7OBhGMRT7mAJFdeyq+hgcrPww58vYVbj8QRPC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 10:18:00AM -0500, Jeff Layton wrote:
> > fat seems to be an exception as far as the 'real' file systems go.
> > And it did sound to me like some of the synthetic ones had similar
> > issues.
> > 
> 
> Not sure what we can do about FAT without changing the filehandle
> format in some fashion. The export ops just use
> generic_encode_ino32_fh, and FAT doesn't have stable inode numbers.
> The "nostale" ops seem sane enough but it looks like they only work
> with the fs in r/o mode.

Yeah.  I guess we need to ignore this because of <history>

> > I think Amirs patch would take care of that.  Although userland nfs
> > servers or other storage applications using the handle syscalls would
> > still see them.  Then again fixing the problem that some handles
> > did not fulfill the long standing (but not documented well enough)
> > semantics probably is a good fix on it's own.
> 
> Agreed. We should try to ensure uniqueness and persistence in all
> filehandles both for nfsd and userland applications.

Sounds good to me.


