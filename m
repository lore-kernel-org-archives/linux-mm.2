Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C09CC44502
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13C56B0005; Wed, 21 Jan 2026 04:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACABF6B0088; Wed, 21 Jan 2026 04:49:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CCD16B0089; Wed, 21 Jan 2026 04:49:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDF46B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:49:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21168D1E0B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:49:03 +0000 (UTC)
X-FDA: 84355497366.25.33C679B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 006E0100004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:49:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nZgTFNzu;
	spf=none (imf14.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768988941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwuG4Zh8xzi3XsfiX+hfl4eOhPi+sTrKAwirdvzvU78=;
	b=ME2xsxag/aQId+gerwzKBMFz6ET+Oo5xNiwY4OFxXpvbAqVvqpGEOLFgbQo8uYIDnKbU+2
	VEPCz7/IA+8S7KSzmgdJ/V0VULTemU+89ld9FfefJmCEyM+iEnv/dPRSv/Ktvj3wVB/Jqk
	mDLpHQ2CeKXfW4ezpe8DrDgRMIW9qrw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nZgTFNzu;
	spf=none (imf14.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768988941; a=rsa-sha256;
	cv=none;
	b=FOJCXfJD3v62Ut+51hWMDY4KACb9divfI1liLWaog3Gewp3am9oXgEWdhLJ+/dhl5H/yBG
	bRAU4hFv4/G1/NVthyA1BY5bbljGsxwXdIA55CFHk6V0yTUUr2w9lMc4KgAh+JOJID1F3/
	kRZxbda2yzktYXjjS5nzcjEAm3jBfio=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RwuG4Zh8xzi3XsfiX+hfl4eOhPi+sTrKAwirdvzvU78=; b=nZgTFNzu14yUnMagBymm1SVNaE
	0iI2+v0tg8mrJftjxuiLasZhfk9iatzt6SV3zcWbej4U221rInInSi+IHEz/gS/qBm9sRHcJyamaY
	2iVgOPW0H3w/vq4ErMxFUpMgqMdpr99bvrrbEx1zBJxf6Oqd1tds0vHyOzdQuLPKc5V+mIOIAqEl1
	w6H+15/ZlqHoAqJ9oz6poJ5+1SXpK3oiRj9woVMFWFqnIBi9cp3UcnQlhY2ZC1n18yBMINnNb27r3
	TUQ/4lNxikcW3bhV7aDAFg1yrx2W+1KDhA9xNOfeEs+KGiyy3rKt15Wi5bHrUF/HESTAyVVaZu416
	HhHRjLFA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viUpM-00000005D5S-1Xs6;
	Wed, 21 Jan 2026 09:48:40 +0000
Date: Wed, 21 Jan 2026 01:48:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
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
Message-ID: <aXCg-MqXH0E6IuwS@infradead.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <aW8w2SRyFnmA2uqk@infradead.org>
 <176890126683.16766.5241619788613840985@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176890126683.16766.5241619788613840985@noble.neil.brown.name>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 006E0100004
X-Stat-Signature: pnqtktp7p1f9z3h4g57mgnij7aeoyu9a
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-HE-Tag: 1768988940-147494
X-HE-Meta: U2FsdGVkX1/xJZT5AYlqK+oXK7KLNrBIiDN0H/0Knvlxi1Zphslx4QVNPHGfP8IqWMO0UzZEzG5yq6O3CwP7dWqB1IDW3f+HFp1cUhjZH9fD4L4OH3SszEaXcj1b9LOqTYqvuaJAlJpwIm5tN0z1HM40oEVjshurOxpU5LIboASVPkHTbM3ZLrSKfxur9kHacwmoekiD3h2L9RYqsS8aPbaxWNJ/pIHlEwwKJAhzrl7VN6SodteB5XApRTlegdT5EqP+w9oezPUjLbb5asfVyRYW8A1Hiy4ZTV4gtwl9kE/5vN9mYzvwz5SG310yUJb7DrBUA23BtQS5ZvomtDwsWGsfQxu51oTrYElevWeKwuQ7F2kvN9gX0asJq1y3ZybPDr1gkqK5IC6AEmhVzAnIQFc9TTqAoa21XXNQBMI8A3jrpXyGS5NYX3nzaAMN+dG6bDSXqB4M0ovZ9ORLmyJn1T/HDVhWfJCehqpqvGnGJoN1zyGdxkzD1e1iaXiaXCXiGt17YJi+RzsZthAJqECHNatkbEA6bW8iQm3Xf5e32IRuXhQkVHkjTZ//qOnX6/x+IcqC4Fccm0tuxilhq17ZngrJlBRrJ4BLeKfKNvSKD/FqqxZd8AcZpq8GeRB9DB+NRl1bxvtIyXwIOc6ip6x7qxh13n3ebj3G7/pjwfDI+8GC9BB7Y8Y1/iWToXj+wtoX0Cag38JfMMJHkEV7hpU3r0cp42Ds0iVR3NxDEYD5Os8R12cqUV63Myv8S5rJOqe+01UbXv0ug/n8zy8z88ubcNlfp0po+k96VH0JNMxe3zbmR4gBW3pNKYdjGuoyC0no5CwmErWZtIFpyo4Lw0Cfc8qsfCqa9ngI+1X+47pD1R+B7BI29p9KhGTaTbV8P/ZxyiOuDVpJ5KRpyR/7aNc3MXNUe8mRs2vIN57Syp362jgkjwv7SNMntZQKTXxb7SoCx3Ve/y7nS2xyQ56y5tS
 lp1Beu5w
 nHxIvl9WRe4CGv3G5l7bZ5BnPxMgIlivZ41bqUzBJMa5vE/wAtJmHpot/s1CXyGM+XaiV4MIeepzsgh7Q9qY4FDpjlGKzbtJh65/LS+7iQBSTYguwkHwKLdEXWal8FPODNB3e5CkOgbSDuqLI76Ioht2h9gVrAORw9KCCxjAnEQQGawwCHRvSPhWARiotiJ+7lOKbxq5zTzlJb8w03zMnnAFWyUxNgUsI/QYVy6nPfqsK8/bKntZQX5mVjb5iADF4YiErefyL0a2EFPXU9TqFHeTTlbLpBnSXX4k/ng4TJ1S7WQKk2ISNozW2eQxBfn2drXy4aEFm9/C8Ntnydp/IcMnV2ltorAtTX8s7yNjiOJ7qd0n3n9Qu7WDoF48lTIdwbNYWZnaVXbluhdyGAbUm/e3l0G901ASpj38joly3ClDA782iztiU+xNngOfWCPWlnXKhoQj0/ONYxjNEiX777RANdMM98V1aJArIl267Ga8xKr2aAevJj9I3FLCowb54gyMBZpxH+JU4jErkGR3rRjjSOrdlx0z9wqeBOLWpUwj/HXoxJEDFxnOd6dzpfLak0NGQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 08:27:46PM +1100, NeilBrown wrote:
> > If you think NFS actually explains the semantics pretty well, please
> > explain that too, especially in forms that can be put into
> > documentation, including for the user ABI.
> 
> There are multiple issues here:
> 
>  - filehandle stability.  As far as I know all filesystems provide
>    stable filehandles when the "subtree_check" export option is not used.

That is news to me, but certainly interesting.  Does this include not
reusing the file handle for a new incarnation of the same thing?

>    Certainly cgroupfs does.  So having an EXPORT_OP_STABLE_HANDLES
>    flag would mean it was set for every filesystem - unless there is
>    something else I'm not aware of.  That is certainly possible and I
>    hope someone will let me know if I'm missing something.

Well, if does not provide stable file handles with the subtree_check
export option, or more importantly with the CONNECTABLE flag passed
to encode_fh, which is the level we're operating on, it can't set the
flag.

>  - filehandle uniqueness.  This is somewhat important and if a
>    filesystem doesn't provide it, that should be considered a bug.  In a
>    different thread Christian has observed that there would be benefit
>    if pidfs and nsfs provided uniqueness across reboots.  It is quite
>    easy for a virtual filesystem to generate a 64 bit random number when
>    the fs is initialised, and include that in file handles.  Having a
>    EXPORT_OP_REUSES_HANDLES flag could mark filesystems that are still
>    buggy if that is thought to be useful.

Yes.

>  - GETATTR always reporting file size of 0.  This is the only concrete
>    symptom that Jeff has reported (that I have seen).  This  makes it
>    impossible to read files over NFS even if they have content.
>    Would EXPORT_OP_INACCURATE_SIZE be useful?

i_size = 0 for a regular file sounds like a genuine bug to me.  I'm
actually surprised anything works with that.

>  - maintainer feature choice.  A maintainer may choose not to support
>    export over NFS because they feel that there is no value and the
>    possible support burden would not be worth it.

The maintainer has no way to disallow exporting through nfs.  They can
at best disallow exporting using the kernel nfs daemon if we provide
that facility.  But as I've argued multiple times, making arbitrary,
selective and very narrow choices about use cases without technical
backing for them (which then would be expressable as a flag like those
listed by you above) is really bad software development practice, and
not something that we usually do in the Linux kernel.

>    There may be locking
>    / lease / etc issues that further complicate things.  So it might be
>    reasonable for a maintainer to choose to forbid NFS export while
>    allowing local fhandle access. EXPORT_OP_NO_NFS_EXPORT.

We already have a EXPORT_OP_NOLOCKS flag to deal with this.

> 
> It took me a while to sift through the code/patches/comments and come to
> this understanding and I apologise if I wasn't as clear earlier.  But
> my intuition was always that file handle stability was never the real
> issue, and maintainer choice was.  Hence my rejection of the
> "STABLE_HANDLES" name.

Why do you keep ignoring the fat that the stable handles are really
important for anyone wanting to actually use them for their original
storage purpose, be that for knfsd, a userland nfs damon, or other
storage applications in userspace despite explaining this countless
times?


