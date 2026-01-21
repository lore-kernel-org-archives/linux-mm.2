Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC37C44503
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 10:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38D46B0089; Wed, 21 Jan 2026 05:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF976B008A; Wed, 21 Jan 2026 05:00:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F1A6B008C; Wed, 21 Jan 2026 05:00:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C29C66B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:00:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7527A13BF1D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:00:36 +0000 (UTC)
X-FDA: 84355526472.03.19DCF0D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id CB7F04000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:00:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pQX0zA99;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768989634; a=rsa-sha256;
	cv=none;
	b=LuvVYDxpsRqyKNXIazgI+ezNu5/dIxmGJUlSZYIGVPOY9S9eTbSZfELPGJfr3iD3CrS50W
	rrXMBCMWslcAIUfF8rNnaH/S71rqQYLxDyKDfIc2YaGT99JMs2dW0Du714nRT3s677wKZ4
	ZzBWKCi4GxT76Tz4heWziHiDhoxEDqM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pQX0zA99;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768989634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMbWURXBKlERnmrf5QHs0kPUbIXlx/juA5w6FY/x4Mo=;
	b=hOQb+3A/LfJuSsPU2hANxyaID00twwMj3C1/7lNQDi5XyP+lo+bDq4z2c4S6k9+eme1cQr
	0b395z30641VZmezU3o4kdOFWyvZdiFxwPDyrv/CsUVzKhbSXemEPJyFVSugtxaWTShWfr
	kQiHIsWK7bD4edbrSIuBb8tPsYFe8VE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wMbWURXBKlERnmrf5QHs0kPUbIXlx/juA5w6FY/x4Mo=; b=pQX0zA99VzZEIlAcpAlPuQefUS
	jy9CjjLBfeNNN1FNJitVD8JqerILO8jjC2fZiCCKiOnZ+AFbjn1TYpqjbQaKf+C8/KRnnpzD3SGrm
	1PWJ9D0VnaLF05hqis2S5I41XDL1jyEKDnD+EFR38vRrwM8QPEg3EqDl695fgD/6Ar8xKBHcmKyax
	7put0Wn3gyLR7YcoxmrK+vm9eU0JdOvfRB2prGJ/Am84hKoGOlEzX9X79ne8Tfk9prDNrEldtzRiA
	ijbo3W0+o5oEyQQ0Ds62PvFNcq+zxEq6evP7CKwgfSi+8rKZW1NE7FntT3VSj7fEic6gmCvCHtw/f
	BXWot+KA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viV0b-00000005EMZ-1e4Z;
	Wed, 21 Jan 2026 10:00:17 +0000
Date: Wed, 21 Jan 2026 02:00:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, NeilBrown <neil@brown.name>,
	Christoph Hellwig <hch@infradead.org>,
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
Message-ID: <aXCjsTBnHGuqTJdb@infradead.org>
References: <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <20260120-entmilitarisieren-wanken-afd04b910897@brauner>
 <176890211061.16766.16354247063052030403@noble.neil.brown.name>
 <20260120-hacken-revision-88209121ac2c@brauner>
 <a35ac736d9ebc6c92a6e7d61aeb5198234102442.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a35ac736d9ebc6c92a6e7d61aeb5198234102442.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CB7F04000D
X-Stat-Signature: yin6t17qoohktounm7ktmm5hcugtozuy
X-Rspam-User: 
X-HE-Tag: 1768989634-451107
X-HE-Meta: U2FsdGVkX1+sgAFYBTfZVPUznPghyYTe2F5l47Rvmj8KW/q4RD36hibf4GHj4txhgz5uyFC1+ov5cR0HP2DO9EMyQm1lAuGaaFYqnVnCpgLry87Br6xS3ixcg4VQVwc9WvpXMkzVzeIeTTS7FOckYNJ0XljpqwiHyl1Oq75mnGiL0+4NHnpNfy9mfofr/d12ajbMANTULnGDLq6gl8wj5TXRYHxkE7JxZHPujwwelF9BXtt7HcI7g0YaGRLf7tmFpNkmSQ4MlSZEF9DtQzQBViXGrQaeszIkBl8prrBvoqmkNzhMnKZ0FVOqh0MfGgGcqd8R9seXwy3l0rXYjhMU8KVOvnz6dTXTYhCc/7pcnBqv+tsEAEKH11pJxgPeL2GgZpRUVMGXBkV2yPf//SdA8gV2bttUiermUFrkTLHYu+Aj8lP/OcYMI5ewdYLYmB9ZCJz1/JMzsHAO04TjCmSWZfPaCfCWs9drhQXWLB9tPG79gm4Z+7yu20/kE97Rhr8OkBkoTdTJdRm/io7K4L3711ONJMhWJ4MIPaHc7K6V9D7oJtzhjHKpp4LxDADW+kkg3VXnMlyLyb4QCLUngoTBnNOm5M9aiTgvOumJeDLTK7d/zOxPt6wa+vME02LBLTbYdZfaf7kiodC761Aiu8lkVnJGrMZKj7FCLc3I5ROFQAiSveaG6Y4wPDJVxMgdIRDI9YQvQzLucrc2IaG3MmpF2X4TCQNndq9Zib/9TjcLdCf+gzdmgPa5OMgc5utwmhacghCRosDq36RyrGHVf0UAtMOoNt3/em/qt/1H18RzqeGcIxzdVQuB1Thm7NL+PkyaITKiB5mkt6k9+zACrQu6zTurBv8AmmyXesyNx4Dv/F/HhqGADAyU4qfgoNAoUIxsyQxAvs7xHVOj0ewhHm3NYDNzx3DJnDANBWchLIMoKEn7+sAsLo7IwTBWamVzNiTFh9GsW1449NaDTOWJVvM
 Y6bUv9u0
 uLHnCU9dnvqB2XA+QtRyJhvpNY5pkhrf8Bp6tbe80DPS/O/nJ5nKJj4hja/JBMewzF5KLJ9dcVAkqQRSNGP9UPhK9rJTsyeK2D/8huvXCLW66FFP5OqaFeTXMCyicqHs6D9sE6CAgVb2mHddodJjs/4OWANN8ldQWNW4yt1+tgO2DN1RdlktHRZzV5ba5az+LG+C/6T6bLYP3ugNGJcnOuZYCxQLeEStgktu7XmoR/npkfLA1IkSy0Dg5q9fUn0e+fJyk+dxZ9xg6wbeaby+87rsONSW5oS3pSKbWCObO28MWxCBwlqFQzHIXBeWBp6Mxcbvi3XlWoupLIiAtHZop/KsgYH0ZbVIj1AvndAn1aUX0He+H6PIHpQMGW15W8nWRjTU60ccJyZ4fk0z8Bmgw3ATkvd8aKG5iQBn+AGkjWCQYq55rzwCDgzvh4tdi0zPvQekypMZthO7a1blGclBwyfmg9z8c0qmljkzbms9BGVuwFLPmfKGaXh72UsADTJRd0Ai3wJLCS6bpX0S5+0x84YZB7D6vgngqf+T65WD4L+duFnnlZDN2+xEM+32ulEJt4aKJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 07:50:32AM -0500, Jeff Layton wrote:
> > > and it DOES provide stable filehandles.
> > 
> 
> Across reboot? Not really.
> 
> It's quite possible that we may end up with the same "id" numbers in
> cgroupfs on a new incarnation of the filesystem after a reboot. The
> files in there are not the same ones as the ones before, but their
> filehandles may match because kernfs doesn't factor in an i_generation
> number.
> 
> Could we fix it by adding a random i_generation value or something?
> Possibly, but there really isn't a good use-case that I can see for
> allowing cgroupfs to be exported via nfsd. Best to disallow it until
> someone comes up with one.

Yeah.  And I'm pretty sure everyone here will push back hard on any
such use case.


