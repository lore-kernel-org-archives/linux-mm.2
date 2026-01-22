Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 051E6D3EE92
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9586B02CE; Thu, 22 Jan 2026 12:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0546B02CF; Thu, 22 Jan 2026 12:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571E96B02D0; Thu, 22 Jan 2026 12:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 418A36B02CE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:04:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A75458EA0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:04:27 +0000 (UTC)
X-FDA: 84360223374.30.ED561D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5F6ED80014
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:04:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ueyMX6oh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qs+XaS+FGKy5XGjHxsh2yZR3UAuTtojhMQnjtTVwQfA=;
	b=vF061XwCQJSwyoczqLu0bgSFqgHemZGpSySP5cBH+rMSjjfxlboiC8s37PWOVAqkZXOdWR
	DU94qnWMtUijb/bcbrlyx09eejbTYPBbiAisSaa+Ne7sO8hso9A49CZSEhTW8U+2mfZKTO
	C+wIHo14uWCbV0WsE+KkcPnFLdPFBf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101465; a=rsa-sha256;
	cv=none;
	b=kS5RocuL+ZulJeRI5un/5k+tAKf9U0ZD1kj7wmGbgOEUh4mGUlKTFLVOtn/4iSkVDWGwJ3
	WUDCoRnkZ78lbsRkvY6ZdcgXoLUXeAYz0urcKRHF4NEPFVVvARz9/kvbinFyKABJa76FjC
	i3F7FeZHwg4g+Y/pcoXcfpYL8Pj22mc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ueyMX6oh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 528AE4099B;
	Thu, 22 Jan 2026 17:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156DAC116C6;
	Thu, 22 Jan 2026 17:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769101464;
	bh=xwFz5Oidq8APQpCp7THEtDpXn9O+NGssd7GC7NPkIXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ueyMX6ohlT+V7E4FTnwyr+bckr2XgM0otlsgh+U8+RB7dufNou2jXtRF8/4HiLX1h
	 aiyHG+xAbRXlOpSKYNl+YW1B6es8lJGWyDpCT3G89X8Bn++QSMPHsovt5BRyWj7Z84
	 MiFPflUjkr2UeHtVIt004pQ2LHYESJ6jR9ib6bF3tKB5BvchCfBJcHtl2H7eGV6Hj+
	 XeQh59i2mPbJ0Z07CURTocG8MzgcrhLB0YpqMQ2BX+Q2rUwcSwiRIRCTHIiyBghAen
	 fRki137MnL3p5j+2P7Cc4giyKdLsB0k8xoBASjwbPFk1rE23p0Kg5qRxi8CJQxSLFn
	 VC/vMBqCcUNNQ==
Date: Thu, 22 Jan 2026 09:04:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
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
Message-ID: <20260122170423.GU5945@frogsfrogsfrogs>
References: <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <aW8w2SRyFnmA2uqk@infradead.org>
 <176890126683.16766.5241619788613840985@noble.neil.brown.name>
 <aXCg-MqXH0E6IuwS@infradead.org>
 <176899164457.16766.16099772451425825775@noble.neil.brown.name>
 <364d2fd98af52a2e2c32ca286decbdc1fe1c80d3.camel@kernel.org>
 <aXDm8FPPOHs04w9m@infradead.org>
 <3210d04fa2c0b1f4312d10506cac30586cb49a3c.camel@kernel.org>
 <aXHFlF1tef68i2HU@infradead.org>
 <b491335d12e976e1ea1c07b9c14164ac69d22aea.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b491335d12e976e1ea1c07b9c14164ac69d22aea.camel@kernel.org>
X-Rspamd-Queue-Id: 5F6ED80014
X-Stat-Signature: i9a4ezjy3m3kahbmhfcnz11x4ns8kuy6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769101465-602534
X-HE-Meta: U2FsdGVkX1+83SjWv8QnSUBk1R7Pfqzq+AvjrYoMVyG+uXmXeMIAGZF93Kdb9xicT6crQib2/yCDsnEe5OTIcqYoJySv315ZiDUPnak5fstJY5MEzzw+tTfPj+14PITjCDaglT8RzmYH5C3mQ60kadYemjWXPnNi5OrEKLUiWrWiqPPn19y4SYuMRFrHjp8nn9W9NXcNRNAfsv8JYJ9oGWjYYkrLfCaI1V88ejt0SFELx+WXzt1at34tp35JIvftA6cZxKs1cs9wqYHt+yMiVi8vt7AvsbwCUUxY9SbfegOsnFE9GnKasTc5cRt0xkaLvQahwjly9KOGR0OKxoEOjaV9XhaALCI8HAVgRAW0nXrvgw8m4U6tX92FD0OoWiJXNaeTs3PdjL9Eym4oLb7wZzjG4vwQLmfJURFhuS8npOp13guP+nW8VBC+x3l2q5Um7/2qb3aslk8KvC1DJ9BwBtnC06gIJHPF7G1cSXYPv1Hqpaktp7MyC8CuYR7ut2SMHnV6/c3cjqSAHBTiGE6qQmXkXUumHH7TO38myoBz9V3ggBR/VM36eYTeYbJPHapGfcrArvNU/REI3JK9cww1ZvNY45zTgbf25XFgbU89zxDqqoNWi43G3fhVZyFRdzOO7oSmD/RbF2nrpJgMDmFNt3ocX+5/ak5CxlNIdVAonFBhM1byA7LTdXCg77v6sMimQzc2KulxNNmlGL4Am4JXWawIYLJvVsDcAbCU6DoabJrx138dFLST0HXpNJ7fqz2YpipHiudREQ77GxWDriqsY6fjrMP/Qbb/urRc5sdvZktwRyNmD67GSi/92vIw8FOcFgBmoUFYDdNQ2epgDjVYLySCKpPoioBnR4UfGy7Pr4KWBPg8CI2EfCmmCvUrYU4Uo78q0yTjpT22KxGEnDo6NmHUBw1mB27CGHVFj2bt9njqIiXVK6zt/+/yaCqdgOriAl8QA6yETgr4rBWqruO
 7sQ6tVKQ
 74OEI2WVYKbQMtq5o/iEuWCYRPf+ktyGjFmBMQV3hcbEV7KnH7nZgcXA+eA82y6ELDOR6hVTsWLmdZbS4Kd7KsQR8BD6dfpju+2O++MyK7PivfWtOoknNvgQHf4iP/N01S6gk1dUzIXGMzC3RtIKf7GbVv6xThWs216LfwDVx7sspJ43YauTp4KNOCTmyVlIfcObDn2o7IOTHxa52qdwWVV4zFhcClEGRCerlLmZXiIVpoegSJoQ8sxj6Zp9B90xtTeX5thQIBiLrC2lOfAzEPFtrT+WK2S95yX4gGYFvZ4YpJnBeBkA4kUu2u602kuAR0tRw030Yi/AEbfytCTcfJCFaGrpHAGD6dAvd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 07:12:36AM -0500, Jeff Layton wrote:
> On Wed, 2026-01-21 at 22:37 -0800, Christoph Hellwig wrote:
> > On Wed, Jan 21, 2026 at 10:18:00AM -0500, Jeff Layton wrote:
> > > > fat seems to be an exception as far as the 'real' file systems go.
> > > > And it did sound to me like some of the synthetic ones had similar
> > > > issues.
> > > > 
> > > 
> > > Not sure what we can do about FAT without changing the filehandle
> > > format in some fashion. The export ops just use
> > > generic_encode_ino32_fh, and FAT doesn't have stable inode numbers.
> > > The "nostale" ops seem sane enough but it looks like they only work
> > > with the fs in r/o mode.
> > 
> > Yeah.  I guess we need to ignore this because of <history>
> > 
> 
> Yep. This is a case where the handles are not PERSISTENT but I don't
> think we can get away with making FAT unexportable. We're probably
> stuck with it.
> 
> > > > I think Amirs patch would take care of that.  Although userland nfs
> > > > servers or other storage applications using the handle syscalls would
> > > > still see them.  Then again fixing the problem that some handles
> > > > did not fulfill the long standing (but not documented well enough)
> > > > semantics probably is a good fix on it's own.
> > > 
> > > Agreed. We should try to ensure uniqueness and persistence in all
> > > filehandles both for nfsd and userland applications.
> > 
> > Sounds good to me.
> 
> 
> Unfortunately, there are already exceptions. Apparently pidfs and
> cgroupfs handles (at least) can't be extended because of userspace
> expectations:
> 
> https://lore.kernel.org/linux-nfs/20260120-irrelevant-zeilen-b3c40a8e6c30@brauner/

systemd cracking file handles??  Yeesh, I thought userspace was supposed
to treat a file handle as an opaque N-byte blob and nothing more, and
only certain "special" tools (e.g. xfsprogs on XFS) could do more than
that.

--D

> My personal take is that we should try to make handle uniqueness a goal
> for most existing filesystems, but we're going to have some that can't
> achieve that. For them we probably want to be able to flag them so they
> can be id'ed by userland.
> 
> So, we will need an export_operations flag of some sort
> (EXPORT_OP_UNIQUE_HANDLES?). At that point, we'll have to decide
> whether to deny nfsd export based on that flag:
> 
> We could deny export of any fs that doesn't set the flag, but NFSv4
> actually allows the server to advertise that it can't guarantee handle
> uniqueness. There isn't much guidance for the client on how to handle
> that though and the attribute seems to have the scope of the entire NFS
> server.
> 
> -- 
> Jeff Layton <jlayton@kernel.org>
> 

