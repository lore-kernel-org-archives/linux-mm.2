Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58115D2D11E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA826B0005; Tue, 13 Jan 2026 09:55:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1AE6B0089; Tue, 13 Jan 2026 09:55:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0616B008A; Tue, 13 Jan 2026 09:55:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B06F6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:55:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3659E160142
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:55:29 +0000 (UTC)
X-FDA: 84327239178.10.AA37B32
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id A2043180003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:55:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4Xu9MpV1;
	spf=none (imf06.hostedemail.com: domain of BATV+b9745b0d722f245fd565+8178+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b9745b0d722f245fd565+8178+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768316127; a=rsa-sha256;
	cv=none;
	b=fNAwCTKN1w/Gda+HcPVOwuMuIpOnFq8dgEmwpf/yScGmmjquVilkrPt70aUd8kTs0g+K+E
	OBQnifNedQCW8fL3nvGKo3KUvddPerjqj8wphl4tpndqshGvs/2Fa3Z/E+RdI1hsk8MntA
	z9aYBuPNNnVhGys582X8R82QJ34M2Jw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4Xu9MpV1;
	spf=none (imf06.hostedemail.com: domain of BATV+b9745b0d722f245fd565+8178+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b9745b0d722f245fd565+8178+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768316127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2AuSB3q0O5lkw/gF1nY/Lrh9I92MUD/Wumu9860GzA=;
	b=68HLw9BqhJO4fc0+uWx4jTwSSgKVOqIyAbsdm1AjzesY4P8dM0UbR4mrfqRDgsM9fYYx8a
	9ma+c+ifBmjqSZ6uj6/Mr38Gu/0DcDxj9fJ3HocCqMg+/HN5mEisiXvmyLJWnU63+08mZ3
	+KPLKqUNvaV/BGMabfbhQK3BmLMfpfg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P2AuSB3q0O5lkw/gF1nY/Lrh9I92MUD/Wumu9860GzA=; b=4Xu9MpV1fb36nk+xLVqjw50voP
	zN/I3Mf0fobYWLAtyiFh6eeo2iNKSQjTeeoaA3AO23SzK+/Vk2xX9VLh/6wcQuPfbSCvUOgDwyZYy
	tXshgL07k3R6MJgxwiaacOrzdFKqY26ilV+3ph2n3cLlcyEKXdyvGWC1WCSx/3BvnFpOaXNp0hUlA
	LOdIhx3h0ffALf9ACVX13Eu4Iz33hZNDOWMQjukRFeiggJlDl5sQ6RHc1RZf9BGxevbcm69L9/VYf
	CAJ9bUHsn3reBoeGpHTySi5zkROuhZhDghCw4gv3aAP/DG1boh0ciWwdyMBlKp1WmN0ZP9AS9/Kc/
	9BtfzNuw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vffmt-00000007IYZ-1cGp;
	Tue, 13 Jan 2026 14:54:27 +0000
Date: Tue, 13 Jan 2026 06:54:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Christoph Hellwig <hch@infradead.org>,
	Anders Larsen <al@alarsen.net>,
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
Message-ID: <aWZcoyQLvbJKUxDU@infradead.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4>
 <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
 <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
 <ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
 <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com>
 <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113-mondlicht-raven-82fc4eb70e9d@brauner>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A2043180003
X-Stat-Signature: ytzz5q5jdy8ej6azkj3wj3neinjrxjkw
X-Rspam-User: 
X-HE-Tag: 1768316126-636403
X-HE-Meta: U2FsdGVkX19QcLEJUHpL32nHenyvuOQ2juWl4YsuhLjABXCRK7pvXQFwbe2C5EuuZbSIAnPR62LJEvOUWGlfEiR5ooUuk8xWwJ4cu2JvBrWvrlYdsjOYBOxAGZb9bVA/btub4mg1W8F+5tAIvfhOFQ0bTiDD41jQ3p0Y94zka2iqvtmfcVQaQ0QdtGldxUrTtpmOZDY7rwcE905/AIXCXWtN+0gsx0UZ6Wmbq1aAuyOevERAx+B2AVQGe7Gl9uyYwuB43e/Y+MGd1tdVxuuOU1WtJjPIg8P7m4J0FktXs7Nkx6k7pVMLAcSwGoFdp+AOMjG9eUs9yXQkkS2DC/4xU7Cey/WUqpVAqXBFZz9RAunvB572f+f07Sdf6i7LRSNyC6Gs+bguc7lv8vm1CHC2y9Qa4ouxy3+cLwllttO8/CX/VSzaQPH4unS9SjS+MkTI2mHGRtiJhSnRNwsz27G3XcnL1bKyHqzyQB+gP4hj9FNBrSUxX2jKmONR1sRKC1ra/hhIwKC8CMR+AKm1K1QZz927QqRXTcffUOCa02DQruOryn04rWavyIjGCSG1icWy8qB3SfNQpCixZzWuLgngPXlKbf4h7+EJUmOGWxhAuyB+Y4ufoERH1rgEQTxmi9E2sDITmn4Bm85bkvig1vKd81j2sC3R65+mbILrg1VHbk7EbV5o43mgpFAAPV9YWZ4EfeiDLGONK6Y/KMN8Rww1QRQZnPfjxpZUd5a7tkx/5hzd92fPmpbdB80quiCYjchhXlqwS3tLC+ZjFAl6vg5pLIYP6IWX+FokbkjYcgV7vIh8B20LPHpziQGMEsdWIGHUDLKVO0LyKhUKGLBvat8vDLrqDGOQL1wfDHRqJSS/X1yGnEWYIPDQJpqdwcD4xeGqbhbXLaAUMxUD3Dx/TWSFqLdgjgWRBiuYZFV8ciwGYz/HPVhRDKNH3DzM4QsrpIiKOZNY5dlPhn2CkJtgAlF
 aJSvCAi1
 PmNl96CXg2a9w97bn1wGffil8fgsXEW+W8L+VgpFac4hjvqfWzTQHpod00kwSB7SV+4+lWU4gs4w+h9S5VL8eK+L5Tjm4IPQt6EdVTR2QrbNg6jA2eKEhX39TddSz8dJNRkTuQWWsijaQYZOHenOK1MDG2R1fLBbzAXtDQfvb2dCSYLQemKUztZh8QecrvWBBPixaqhLJvVgnS9+Auj8+jKIBA2QtAMPFDEsHS4kd4earOKIRryDuFirwK7nKddcH8I9FFIXewBnl7zbQzJlhclD2Wjcp9uGcIUQJNJjElLXgoGL0QYtGxtcAjzXgCxNTc9Bj2qJ1OP8wPGUhO2jzkySCxsHkFs7ke+STZFDisN16YaM4kTh109ZgVXkbhqVjJfC0s+XjJT2YgQu4zl09JT9q7Np+bFOpKeCTRwdXI/chZl+gIubBx7kCAuCRDtLiGJkmqmgvgzrO1PLEyA1s/4zVnO8UKQikVly4qjklQS5Lar4ekhRE19DTnqdYObHallyIWmZ7G3i/ADVN6kFuOSslkKVq4nrK2kyUiVd+75/FQ9uFTXX9ymHnxAIthZtc8kkj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 09:54:15AM +0100, Christian Brauner wrote:
> I don't think we want to expose cgroupfs via NFS that's super weird.
> It's like remote partial resource management and it would be very
> strange if a remote process suddenly would be able to move things around
> in the cgroup tree. So I would prefer to not do this.
> 
> So my preference would be to really sever file handles from the export
> mechanism so that we can allow stuff like pidfs and nsfs and cgroupfs to
> use file handles via name_to_handle_at() and open_by_handle_at() without
> making them exportable.

I don't understand this discussion.  If someone really wants to
expose say cgroupfs to the network they'll find a way, be that using
a userspace nfs server, samba, 9p or a custom fuse thing.  What's the
benefit of explicitly prohibiting a knfsd export?

(not that I think any of this makes much sense to start with)

