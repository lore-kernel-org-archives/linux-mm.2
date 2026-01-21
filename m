Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10CF9C44503
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4E76B0005; Wed, 21 Jan 2026 04:53:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576626B0088; Wed, 21 Jan 2026 04:53:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F3E6B0089; Wed, 21 Jan 2026 04:53:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30FA26B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:53:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2D8A1409B8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:53:04 +0000 (UTC)
X-FDA: 84355507488.15.FCCBEC7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 46AAC20005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:53:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wHU0Zulf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768989183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PBJOlGAHQuV6fK4m59wMQs9zml1XrtHGpIQe92sdocE=;
	b=Fnvq2SAUWX0827kbt2aMr5aOLwS8107mDitG5DbizBNAwMAZVG7GUJevIiAp+6xNkBL25B
	mhjQgycFQS/H42KgtbkYSJ9REU0Hs1uqmxxZz7UytnFp8tL86yvo4029yTEZDoaadbptpx
	yByPRSOxi+rL7nEe584tAjHx4T00ZOc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768989183; a=rsa-sha256;
	cv=none;
	b=KCNdVWUMoTYWIQX6SrkbOQ3G+3J+iQC4JfshgTLl9S/sZYDvJovEeYvC+/dB7nVERpw0eh
	/8IFrlAZnf/ebZvH3FB2krRAG7lhwYeVfy+LV5NqxX3Hp/OdicF6YlnQc6Wl/70KMJvrGc
	MPA7wqvay36yiUDEuhKIUnTVeo8NTWw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wHU0Zulf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PBJOlGAHQuV6fK4m59wMQs9zml1XrtHGpIQe92sdocE=; b=wHU0Zulf9wG1GWqFnY5yVggCof
	mLydz5OPkY7zp9g7d+yCcH2YzhOZrnHnkVnMmzCmzcNaZ6/6tBJ65SVG+qfeucInj0l0K2D090saB
	OTkun6m7oaDpgwEEmsnayhH2VkCErcrZYpRhnGa/faRG4AbIN/MDBJVKszYg42XsvYACeDCPivLJw
	kyMmL1d4VAGbsEO2t7KXcoS6Vvf14XUxxhJIVdZEkvODAnaLlXlZrIHJxXidrVbE8sgjQCvKLlYyG
	T1WGJET209MDO5bYoI9YMbcisUnYoJAqrcHCiktzGDCHtCbQb3CB82dv+BFL3Oy0BcF9EIaE3BXRr
	j55EDQiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viUtD-00000005Dic-3hpF;
	Wed, 21 Jan 2026 09:52:39 +0000
Date: Wed, 21 Jan 2026 01:52:39 -0800
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
Message-ID: <aXCh55UplHkplhFe@infradead.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
 <9c99197dde2eafa55a1b55dce2f0d4d02c77340a.camel@kernel.org>
 <176877859306.16766.15009835437490907207@noble.neil.brown.name>
 <aW3SAKIr_QsnEE5Q@infradead.org>
 <176880736225.16766.4203157325432990313@noble.neil.brown.name>
 <20260119-kanufahren-meerjungfrau-775048806544@brauner>
 <176885553525.16766.291581709413217562@noble.neil.brown.name>
 <20260120-entmilitarisieren-wanken-afd04b910897@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120-entmilitarisieren-wanken-afd04b910897@brauner>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: tmrxpuyr4kkjynxiptiww4t464xnrphx
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 46AAC20005
X-Rspam-User: 
X-HE-Tag: 1768989183-132957
X-HE-Meta: U2FsdGVkX19ab8hj1JhKbfMapQedrSTuCfUMuvmacWaMNdarVk/tM9Agkc+yzu6/TBoBiMvzpXBsSCmgU/t53kpm3z8L3XBr4ZMcFJlW2XD3qJkuPeDDOP2lvqknH0yAJNNQCz3en1wSbSTE37P0tnOigC1SKwtCAziHLD+Nxja+cC8V+e3lqszVZhe8UhW573b7xtdKRo7pEQJZM/B5e7XurzVN/Tl8rZHPQVaXdnCji3AtchuHHA9T73TFktCv+GqrTMIoTebi7z0s7QLpE3R4IdEApkUvOJ9PO7fhE+DCWlLTW2SAT7KOzeNeEPyWD1+qpN0TfzIGrVw8LMqHnciOFTr982sxCQVC1XVOaM2in0eD9TyAVdxm4SvqA5KKE5q5D1CIQ83D8FsgoNNZ/rG7EEsGMDiAwgyQRI5nFO+bxKrNiLStCr7sV0H1XHfNXqOlSTIIpLPjQI5hclGa8VZnrpQxznO7K2wFLQFk7TYR1Ty7KApuQGhYFqXxhaecj7BGbDF7qfFhx9tyWn6PvHko8prWt9E1EVG6RiwJczywGxDOhQAdFw2T9I3ugRwQ4X5ur+O5ZIy1We1FUYWHrCtY/xOELR3LIwnaTV/Min6LVFafDoJepuMOTjbDq/LTCRXZbegsqgjqkWXazSf2ItS1pAIFtgi0qLeXIsQn6Xb5Gn7PvRpJY++05mYduXfWgQCGdWCHN6PwUEao2ruyj75bPqYvvqIrPh+pMpy9LtGeEwT3f1X3iPeROJIkDSLrNZZ8L48Emg/LdfqmeXM5UVsV/N4KeUzHlMbJqEnH74hXzJ1aKXH7+AnKJZI6/4Otpof3TK/8VTsNruYKkRo6n28O7CgiCzXISE6hZJSKZOWwdqeEqLD7YLoL43xSswtxiVW8ZH06u+Hh2RvbDPQ7KvtSBCBzmURpjHL6SZQbNWevN8AFgJNTRhtxux8Y7/3Sf4FLqZDYMGM1CMTMw73
 FbMTVeDH
 t3P/Kj9xiwrBVzu4ReYwNuk3aP99ALfOMoXT3xz/Co4uU5Dyo3W+THIy7SXiT6vzlW98LxGpnr1Kjo9kqxL83ph2C/xn6fz0Ge3Ri0sNA7roiRNJgSprSY2Hx4budTEzK4jeOMRiWQCEl14Z1uKGqgMwB1B3+Hq/lBLzYojvOo9Ir+ioxV6jMrq2Jw276X4CgpssGhMNBVqM9hKaPtNbcXjOgznlHm2lsK9JGFMAx5AkSlPJTmFY6IimRmILGcn5QjaLmzbFZWYkKkUlZsA+zSVHhRDM5Ce1vp074DPEZGiHiiPA+WeMy1sgiWJX4dfYT/BdFF5Adk8orqsdvZ0m66ajAbOBcX7sAnwgKJQv75NOMjbQ84PMIYPe20IATLQ+iKcanRBm5UWXVIQ5h5YWRgtP62VNtDpaadeO0JmxEIHXiVUIKIvOw4VTa82Ebzut4rax9+HXu0c+r2mAAJXyeTYgz7o65rGXl2lCurc0hu5ziiaAW7rFk5nNW8WqIwrPeNmLz0bIzJAsundjpdskzD5GEtlHhES8sXUnWbTq/IG8JdfXd4SAsfeRhbWckCE4+zfdf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 10:04:02AM +0100, Christian Brauner wrote:
> > I actually think that what Christoph wants is actually quite different
> > from what Jeff wants, and maybe two flags are needed.  But I don't yet
> > have a clear understanding of what Christoph wants, so I cannot be sure.
> 
> I've tried to indirectly ask whether you would be willing to compromise
> here or whether you want to insist on your alternative name. Apparently
> that didn't come through.

Btw, I don't think the name is the primary problem, as we seem to
disagree even about the problem space.  The current patch series
from Jeff helps with the stable handle problem, which is an important
one, although maybe not the one you and Amir care about most.  I care
about it most, because the addition of unstable handles caused problems
and I really want that fixed before it spreads further, and I think
anything mentioning NFS in that is factually wrong.  If we need
additional flags to work around other issues (as in the list compiled
by Neil) I'd still prefer them to be named about what issues they
deal with, but folks get too tired of that I could probably with a
"NFSD get the f^&&& out" name if we'd just keep shouting at each
other otherwise.


