Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2BC9D232EE
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 08:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA6B6B0088; Fri,  9 Jan 2026 03:03:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E3C6B0089; Fri,  9 Jan 2026 03:03:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C726B008A; Fri,  9 Jan 2026 03:03:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 130CC6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:03:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2B3458B32
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:03:22 +0000 (UTC)
X-FDA: 84311685444.15.D73F2EB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id A70E6180005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:03:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="u/G6UHBR";
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767945801;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpKkiEmSndwjicxjhbSkEm+OqKkOEZYFr+38yoapT18=;
	b=mNWj4kA6RhSSrGP3pIIWR12i/O1Mg3/s10CHGtwbRIk4/oD+orNm2/vSs4/lVhoZiwRCnI
	zi5nfRtI1yTewQ+U38w2OSzrIUt771CnNbkS6EE6hmVB6YQ5akjvC9slXAPcE/VXU6a9qG
	e1ms7vkRtynbz1XL0t6q91aYac+/2gs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767945801; a=rsa-sha256;
	cv=none;
	b=A73ZSw8lYqa6akVRR6We3JEVvdadCUt/rfdU846Y6Rs+jJrNJ5SjuNx2jiglAf+QrQ6zgR
	LUAiCuR9v8AxuKOwCdL6ORhQR3g5Od+gEeaZBNwpbMuti+R3pUoqW2HcFj1Vj5Kl2vvSga
	Sc+pgKoDcWJkzyYurk6xKysoOADrypc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="u/G6UHBR";
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qpKkiEmSndwjicxjhbSkEm+OqKkOEZYFr+38yoapT18=; b=u/G6UHBR+5ow337c1JghYNJWDu
	469UvSVDGO6+YNoToIhvNpY/ayIALEDFf83grTS2D6y7ywOIZRCy3/iCq0ZM8cD9AQ7+fvI6fMS/l
	VjLYtprYxFtgUJOLkBpfkNoCRVxT2oFQ6XhbJajtpb60QimL+reK7hwOJ+F5oKdDQQZtNH32mdj0Y
	NYtK4gqyLHxfqzyBhdXj9XmvkLhDu8ED96O2oCUUKK/NOkC2O3HxcO7BSos4TaDLom8xvGFiEVG6n
	uXxgBBpevz0vRplri8JSg/0oY1M5QY6lVD/kkliK7tKRqWXLpEXX/jLge7VyyPvx2QBNIuYZ8+750
	dpDI5izw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1ve7TD-0000000F7AZ-0jA4;
	Fri, 09 Jan 2026 08:03:43 +0000
Date: Fri, 9 Jan 2026 08:03:43 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Anders Larsen <al@alarsen.net>,
	Christian Brauner <brauner@kernel.org>,
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
	Amir Goldstein <amir73il@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chuck Lever <chuck.lever@oracle.com>,
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
Message-ID: <20260109080343.GA3634291@ZenIV>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A70E6180005
X-Rspam-User: 
X-Stat-Signature: x4ygypu7qqryh3bxtn43u16dc94o5q5z
X-HE-Tag: 1767945800-190045
X-HE-Meta: U2FsdGVkX19PQt3/jV6qumV8ESxQEVXNww0Fvwx1Lc6vcMee49R8QuA1NPG/KbkcQOYspgQ3hxwUpZOkoiIuYNoJIw9fv5BkcTLOfdQh1AO6r3v4+UbRhMun1KDuUJgB5lHzUHv7JgBp5oCUxyWHQqrmOxfg5slavaUqjCUYUKA2CFhLexMiy3DmNk4yZdpJSw9+72gntyYOD4BWraCg6LpJmyzsgkky8/4uSPe6lRg7bzkbTb9UU0Q6uAPy2Cd1utJY89GChOhcyjmH0xrZ+rnW1ijkdHcvow3QiCm1MSKbCICgzvigSAuRokjcTHOb6Z2TBTgZLDPB/a2TlonOaIukEbBRfCiGC0hRBUVWlqww0yvZka+uPGqhd3rE0Axr15KGsWFMhyYIoHhmH6GcfScbBpoLCoxgDDqE0ZAI2q8Zk5h3m8XRKjpyGcK/XksWGFNbEbC3/MV9YadsYw0XOWiC/1XwULheHWo6sls3W1UoYmqXK5H1FXtqHoszVA6R29JfdPDbLX8MYLdco0sARCN8ceRJjATwVTD6By5qrvyt8IGLPRdKQQSfVQYWDyjo32ht6c72zFY36k5xBinomLN4H6I+zXmkXPpSiTIjaKrjk3deC01GLPNepQGl9uTrYS2y7LpA/hilO41OunFT0G9guocVEAbPVkwti6y0Tgupszbef6fHHNITP2jtw9MVhu+5exwKg8umZ0RkFLrx7mj4i00lAYBgPVgfFbcES031wYc/N9eeImQ4A7d16jcHCf0ZWZNS6lvF9w8TDcZKox+6FgqVDTeLFv3RxL2Rd7pBwCMlLvzxX/hZJQ+Klonz0mC5nfLke4pV4xp119eOE35rqfvd4hgOKWvhuSzflKBAPtkBMHIvTfgaHVSPY/Pc+OV/gAjAC4vO/4d1nVm90uptJ5FSVfqsiI3l/K5VJAFUEaRRvDJYOPPMObNpSBvcaBvQ1xXfpGIRKmEHhyu
 b98nAH1X
 cqCGe34umLg5BnFoYgpyPmPF7ffwdgY0sW2XB1R52Q8v+cC13SH4pJNrRH5AvivqAQLvL31rjUm7knUA5+2YLyHwjQIevKtkwzUZowVDUROwVF7xyJm89FBgErW6QXjAkfgh2crhjVU+dsGrPhxMcdl6NWjUvrybBfpAjnyShFMn+Df292AQD4SIPeANPC/FqMiAKNyUd1CDpubEJQqW1IoGSKBCeecsFk7M4K/lKEelxZpvB76xOESi/8qncTVjI6DQwpJS+4867Bo1y+jbFRSoukMA7jbBAO4LKrgTtGP80An9LJpV26uPjzPzPNe2VZInRrQt9yi4twZpVBUrnAE1NlnV11Tlx9r80QhjqqYKGsbKXESoRU5N775HZeLcxKd9LieiZl3dMul3FbZNLmAnJmW1Xp7APDU3KY3oZU28HByX6u2pNIHvKE5jxwAocxI2NZY7y63/lE1/RuLtOfMYtNxFQoms2NGEb7We4YCT7fVhn2kCdDzWd+tdpey+wHgy9Mp/gPEXWISVgszdwMsKj5cUbNl6SKpQtyl8gbeLMk5YPyfWIbRUYhfr02RVQNh6P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 12:12:55PM -0500, Jeff Layton wrote:

> I mainly focused on filesystems that are NFS exportable, since NFS and
> SMB are the main users of file leases, and they tend to end up exporting
> the same filesystem types. Let me know if I've missed any.

Series looks sane and I don't see any obvious gaps.

Acked-by: Al Viro <viro@zeniv.linux.org.uk>

