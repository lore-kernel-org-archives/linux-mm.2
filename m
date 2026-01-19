Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16494CA5FEE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 06:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7933D6B011C; Mon, 19 Jan 2026 01:41:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B296B011D; Mon, 19 Jan 2026 01:41:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669AB6B011E; Mon, 19 Jan 2026 01:41:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5601A6B011C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 01:41:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E91A3140661
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:41:35 +0000 (UTC)
X-FDA: 84347767350.08.0201419
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E05C12000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:41:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QwGA4hgL;
	spf=none (imf29.hostedemail.com: domain of BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768804894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SwbeRkUkK9OO/mqWtmzTHxyd7fbhxxJhakqf4s0kNIg=;
	b=DgdVN0l0s/KCSWsvt11jF11S3N+fTiwAMByokq7hmgJTbDhxkGZlY177BxTLbUis9PwMPA
	nRS2vRfs3fgpT+Fx5mGlrv4A6FbhSBQSUBKJW0Xkww8Y1t9Pm7x92b9iZVEu7gKNcpVK6b
	pmrOUP1MixHMwD1jV1InWGTRyqPmoi0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QwGA4hgL;
	spf=none (imf29.hostedemail.com: domain of BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f4f5ba1b7319529cbc9c+8184+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768804894; a=rsa-sha256;
	cv=none;
	b=UYVsVURRr8p56TZ/ghfS9pgYx0ct3ILHcQ5rWX88cJq8MpAQ8uQLbn656yqZtZZllpr12+
	fx7JFSRDa9aANEVaj3TwYzLh5W3+uBNM673KAz8UQnHnvCQDeEUKp48qA2x86iZVLn2kvl
	zazfS+XFt2599f0uTqnVmA03qm3LEYM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SwbeRkUkK9OO/mqWtmzTHxyd7fbhxxJhakqf4s0kNIg=; b=QwGA4hgL9aMV6sQTixPK1n3SnR
	Zri8G531dV5x98A84aReqp2G6UaHJpN4nTXf/6+Wnxr1XHLmqM3RDH1HwtqEKXYEuQzraEqef4ifS
	Rfg7JDYGeHeFp5XweYvklrNR0opJLe/tNClTdos3Mg+TXmulpYbbch6WDkxiaD+n25edx4Evpx16K
	chywKYqiRDwlqzijGrTxiZtG1P3yiRHDEqNuPQfZFCJ+hNE2459H6pBY6SMwsK15gU7luCRmdJNqI
	wOQgeUtkH/rzLOhP3JaZKrgna/cZqGj1BqYMwYctab45DTy467HukeFKRPuJN1wnShp9GMgFQxNTY
	QpZdjvWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhiwi-00000001PpP-1B5K;
	Mon, 19 Jan 2026 06:41:04 +0000
Date: Sun, 18 Jan 2026 22:41:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
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
Message-ID: <aW3SAKIr_QsnEE5Q@infradead.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176877859306.16766.15009835437490907207@noble.neil.brown.name>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: 6h38ffjyxnmf4mo1g6i54fbbbwzpitty
X-Rspamd-Queue-Id: 3E05C12000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768804892-371099
X-HE-Meta: U2FsdGVkX1/o94idLke0Xcvg5LIT8hbRFF87juC9ncmGYoGYU44CEJQZ4A8N4jN9SyrjL4oDHTfoodccJf90J2SbOyfcZUIIFMNkGqm8tJh3kUhc9iGHp0pmj+qCExCa4qwOJutC4qQVSGbIsPHuVtivFy/39JA24zD8MyzP/GXUX6B+UT/EkZMHm5hZTeo6KtWL0hGMwEc9EZ8eQM4iPiTcsEJb+O8ku4N1JTR4rVeb5ZbwIfz02SsxN8wPOhxVuHH1z6zrBpJmGXg27qc0E5WVjPcg1YSwnP0joKhyt+U5Jn1kN/ShXmnD3rJZM2WIY237X2Dryh4mCwaG+CqHBuSI629gZzjUikwawrsdjjbO5pLT059+xfDqhOR3WZycktcru+ZDHmXd/8n294YKtxs+JkcqXZYlul3LbxtgQ/sJ/LphI7TusQVC7gIgarpStUrV5FBwpo6WsY7LwHnBBJkxCWrrh+Du6kWiuEhlugK4Cqly5B2raPNLH/6NwCJaz08UQ67DVJba4j1Dg+whJUXLIhbO27CjVViFkd4Wd4QI8tj6HqbqMzDtl/aoxPfWTVg4LJDJ/fN3TS866P4ToftVmExcKRIqVXStDYRCUTMAl/2W+RvRw8ejFcLP5f/m1R3dCHDn45Fif5+/7Z/nQvzlufc8sbeSigqhG6S5wgXY4uAZy62ZxES89L1cwmCTdvu0R8OJsspbk6KcbA92UsyYq1Yd08chKUhI9BKtw5svEw+O6lGcx7MroL8cpU+xfXAf4ouHmAalP6ZpMeAsClWk6JKmtVsiA6k6hDjAPl3V4rRKJjn6hDJqVOKlnjh0VcP6Dh1fVIqcv2AmkMfAfFB3DaeCy4peLD2VVwUl2aW7HsqgRy6a9h/+KkaEnDZ35GXH0dHPFgnnzJuDorAhVAqitvKNbYk1iQIjKTvSof0se8v3vVFnLBlQdlvmPn7/SVDQXNF4pW6qDs/B7ir
 Z4hjjvpp
 0HzXLFXGZlt0+svCw/x3/6s+riMPHFz2UQae1BOCS7DLFl6kbhGiH7FwaxLhW2GqnEygRYVzc5QnP/kvl7DDR58sCYHPYOiNjSxaQ2ol2piQVd6kehIuNtoD8s5CHg7OFAAmSSpIHKx7Yhog1j/sDIKhYxWDQbBzgtKZsro/yopE/dfEnSMWt0RWK4VFLkOJH3zHnxB1gep1stU5KxnAqnGGm6xS1o6mGdka/l6gc/br0dSz48AcIBtGpC51Hl6D+rO3K4wgkDUyPvUTR8cdUBV1gVPnJ+MKsH7ULNsRfmFOP9KXGK76eTScYm0HnF22fl5hRR08w0RWmtDnvec4PeNrb3rn+t/mDflj/zlNBKjoPuelQK6Yqo4XhTPW9k0fpiT29bH4y4pQf4cGGBIXs1DK70PKwhXYOKU3oxDMPinz9QgIrV0kT/UzelUMMjs2gMgX6w7t+vFl1Fj9PIs/+OXr24hELM3nyYQeAyRLvwD3XUVWZgPHh2JszdAzKohsTsalSOVBGuhQ0cht2P1YQTCE1AEc37WUnnMbvZ6l42buj2UxLWR6dPr4poE8QZTAnSwfL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 10:23:13AM +1100, NeilBrown wrote:
> > This was Chuck's suggested name. His point was that STABLE means that
> > the FH's don't change during the lifetime of the file.
> > 
> > I don't much care about the flag name, so if everyone likes PERSISTENT
> > better I'll roll with that.
> 
> I don't like PERSISTENT.
> I'd rather call a spade a spade.
> 
>   EXPORT_OP_SUPPORTS_NFS_EXPORT
> or
>   EXPORT_OP_NOT_NFS_COMPATIBLE
> 
> The issue here is NFS export and indirection doesn't bring any benefits.

No, it absolutely is not.  And the whole concept of calling something
after the initial or main use is a recipe for a mess.

Pick a name that conveys what the flag is about, and document those
semantics well.  This flag is about the fact that for a given file,
as long as that file exists in the file system the handle is stable.
Both stable and persistent are suitable for that, nfs is everything
but.

Remember nfs also support volatile file handles, and other applications
might rely on this (I know of quite a few user space applications that
do, but they are kinda hardwired to xfs anyway).


