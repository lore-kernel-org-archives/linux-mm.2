Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3784C44501
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2B06B0089; Wed, 21 Jan 2026 04:59:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9E86B008A; Wed, 21 Jan 2026 04:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC686B008C; Wed, 21 Jan 2026 04:59:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AEE86B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:59:18 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6A5E8C91D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:59:17 +0000 (UTC)
X-FDA: 84355523154.04.EC954C1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3A818A0009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:59:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GlzCRsx8;
	spf=none (imf15.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768989556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIxfnTqIxfG/JDCpqz8ddR3KhEWm3MiBJqi238v5YU4=;
	b=XK3kZRM4ck+F9+gWZ93wPHBoAKrEV2pZnTbChuwCpLXHjwSTHaKHpuFQmJlziQHIz50yts
	bUdwugLGfyqmqWFPRw6emY81nCS/27cOxLrGxwaq/rKlF8+BOQla48JMtbU/TjD+PAPluk
	slUS2ZFVlFm2n+tM3Yo64fx88DMtu9I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GlzCRsx8;
	spf=none (imf15.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768989556; a=rsa-sha256;
	cv=none;
	b=NTYt/Se3SI9Xh8/g3Wqx9HhOAsCHNVsnT9rfjO5W4yrzME4De8Y/XYtMqdMH6geB0nUNk6
	cTIzHEO1R30ZPIWproC3J86M1Lc13jwlfGmSi5DF6wb4QJyAV9d5cg8uRlOn+4pvdgqNXJ
	HFR8GHw44viChbsofhP49vyHKHhJyDQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BIxfnTqIxfG/JDCpqz8ddR3KhEWm3MiBJqi238v5YU4=; b=GlzCRsx84vMm8sXEe178jEsMHi
	yEfsLuaiVDfKdvvIzvHHomVN4gwjGG/E7g6hvTZrX9Jl+jMggt9g7DJYZ9KBfIFzYhA3kss7211EY
	GEs0h/iYU1akVr821mpLBTcpxPKmjbRmaNEdphN9zpqkHbi/dWkZXm28+Sqj5tXo4XslET+sDAg7q
	8tiAmX+5fSaGZCHmy/XD/afOXoGw6dcJ4dJHsPsM0/1AOYGnrcB/NtcMCkFeZvjwrcVtFQsDFGHap
	YeLREzyq2Ckz1YZlspGFTUyxh+vgvNaPEZGDQVL2D5WGr5K6wxV8nnmvIwla6TuNJ/6ZKDWgoUayq
	u8VgPgRQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viUzJ-00000005EDM-2rax;
	Wed, 21 Jan 2026 09:58:57 +0000
Date: Wed, 21 Jan 2026 01:58:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Christian Brauner <brauner@kernel.org>
Cc: NeilBrown <neil@brown.name>, Christoph Hellwig <hch@infradead.org>,
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
Message-ID: <aXCjYY9tVKWv29fN@infradead.org>
References: <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <20260120-entmilitarisieren-wanken-afd04b910897@brauner>
 <176890211061.16766.16354247063052030403@noble.neil.brown.name>
 <20260120-hacken-revision-88209121ac2c@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120-hacken-revision-88209121ac2c@brauner>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: cnf151mon1193p44z3bnir7yr7tiiy6z
X-Rspamd-Queue-Id: 3A818A0009
X-Rspamd-Server: rspam05
X-HE-Tag: 1768989556-503623
X-HE-Meta: U2FsdGVkX19JrPtn7F0Zr+q30/rp5c3IFdoG1U62OGCC10l/GtfqbK6ITGooJVyHGvd/cCbk/Y3lCY0W4zzlZO0kyzTxvehCrs2ZApLYhrmXT49+BltuxAgIhElyVEZ1amhSfbVI9uJ+3zQnlpCOJoYl/JedEhyV2RiSLNzBNZ28ILnpmKb6m7aC+5HYAfA0t/91i52c8FOSSxUK2kHWvTqA0cpjcLABA+sIO21gREagB4sQZpco1b7vF4FZ+wIeYGKqTbxrY9kofz3dHPX9xh3Aht09X/R/UwQdeLlJowaMj8nDgVJ5hlqP7Sw1RYY+FsUYKeFztKeb9C4QpychTXiy/qsenbK1E46P88SDXb/9TAIr0h7E/XiCZz32tZ9XREUzgukUfHaQ/zLYVN5m/NQndLL0pGukWtXzRv3CW+4Qefvx1sAV+8jqtUD+oowP2iYYnFlFLDPno/3PEPvi4QVv8/cbTqMcw1WeUhN72ncJquIK5e5QLrwcUjk+0IMyaTrUU95iQ9MSkprFU0s47xOrcvTBcJjKqGbm5ZRK2X5VQUXOgtmuUMFJbn0N8yUsWyIgzOCnl0VxwFzZP2Anz454S/vj4KqcSzM+6zIeVvP//1l3eq5iuno4TpmtvOUhRJQZCpesBqjxsfRjDUfECGasswdzVcHRPuBc2IjrjJGjVdu/lpxsGpQXVz1ibrEtGBUfMDMhgmQxqUECY7cX23aIIR4vr8ht6ZMor4uuozeDmTpz8scVipDLDeAPVI7tQgkctpYT9cd2LG3eHhFWTZ2KMJzuYx3P6whDby3B1gPTJ2zY9Ry9w6KGMdGXCV+IAfPIPL5aEkeeguVW7rPBxgvY88p6W1hzNMcCPqxFVKI/Ee+a2VtjEttmrcJi8D3fpPt0pFBvFkIxv+yuedX6UGsSecxt8q8uOJ5zKzqo8UuTnDaa5urVbn6vW17mIKuFzpCSNLaknnYxfw3bbS4
 Xmuj0dOo
 HeqGlCtD+GR4Vvm/9+R8v0973tJK3wmVzi26g3mo2Ub7aw/RgoeQH3B3ZDAmGZ4VBdcwL/iSH/x+akf3yWLL1dEhmX3v0DofyhjieQYrbbfBhnQU/sKnpHvxirovmYIxhdlh4tSiDYrTTl2JM0IDA+tzo45irO/mTDUXjeBedkInGmRM/RbVBRjFSJxhbM5Vmh5S1V4YaWXXwHG00I6VvfCj4Yr82ghIbY6UcxlU+xDWiijVzYntZ+vJAuyV2/QfOlyTUA/oRSNNzqQog/xvpX6ndc+AkoH2VqtNk5LTFzNfmK549gRxLgGjno2+bOL5PvisMUNj+fM9ov2O//2Z3ixiU5kz+RbdVrfd2JQ7yK9YAka2PEpZcQuTA/FZNODczSVMrO6TxrVMiQFTvP3941uOcOjuUptpbW1hk6lbTxU9UxA2C2PT35S1FLjMvS3u8rLWNOSoA3edcIg4AmrNOlrcQFWj/opszzWEltCQmC3GFLFIKi8EJK8e2jvhZaNcYkrDdAcLtn2mgIU5mkFlZ089CywWl07Yc+V5CCZHhxkQsVO3BUQ0Zr+4wdrb+nsGr3POz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 11:31:54AM +0100, Christian Brauner wrote:
> It is very much fine for a filesystems to support file handles without
> wanting to support exporting via NFS. That is especially true for
> in-kernel pseudo filesystems.

I'm still amazed at this statement.  "Wanting to export" is not
something for the file system to decide on in any kind of sane
layering.  The file systems exports features, and layers higher
in the stack make use of it.  We just need to be precise in describing

In-kernel code will then we so nice to respect it.  But for userspace
even then all bets are off.

