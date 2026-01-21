Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C696C44502
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 10:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82536B0005; Wed, 21 Jan 2026 05:01:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49846B0088; Wed, 21 Jan 2026 05:01:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4C2D6B0089; Wed, 21 Jan 2026 05:01:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEF076B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:01:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C004BBEC1
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:01:42 +0000 (UTC)
X-FDA: 84355529244.09.C77AA8F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id E1F5A4000F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:01:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=EaSvsuv1;
	spf=none (imf17.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768989700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GioNW15OomQxHDkrEn0KiwooaQGMLNQRkXTreUFMIec=;
	b=M53o0TiJWKwKwL9coc4wnSj74a3qbUYcZPrGc+y66iJodXuZGMoi0lFtm/LOHNIdktqdfk
	3QPS2aeQxi3NfbhHFwiNQBnVs5KmeyPdAaweMExSPAHVyR0i3VHVbEbDp/tx/wPBzF/SGN
	Wr55vRDbAJoGAvIKvpAKQSYNnvnFKuk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=EaSvsuv1;
	spf=none (imf17.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768989700; a=rsa-sha256;
	cv=none;
	b=pnarYkWoO8YCbKygpAQC4mQ+GkaOlFCEgv3GiiG9cyNTPmS1HGXCGff+C5ZoYFujlhyApk
	s8P2LSsrjyhdtTeYt9eiQov5xKX71hF8rLXBNzXgdA4BPiwp+Qc6fO8sSxPfHmDt7Im6c8
	O4AkKLnp6OE4bHtHIMS39Ls01P7c3Ps=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GioNW15OomQxHDkrEn0KiwooaQGMLNQRkXTreUFMIec=; b=EaSvsuv1TZU2mN64SuI/yRVvS1
	3Rh/o5w7ffYW9KHMX3qJFZZJY4Zzl1PqNJPpWxGM180BKBkt1SVZFGf8QKJcPb0NWjtvv122nEg1H
	OzFKwZ0gcBbQvObpgoOE/2S+Akn4EjCCUUrNtIIKyHvXpH4dzmYWnUtYA/DxyVwWVYhx9ZlF2yvok
	Jrg9DRyKF5qf1NZ8Tm6yVvdUHQyxI2EoJTmHc6/BHt1VYfHI5t8QgU5fVVRxuVw0cApsiz1v6k8h0
	KfPlNLRNbSqHEjiliAGF0iIZ/4UIT4AbAx2DF6R6e2q5SykjxB6n79Ri9aRji9M3oB2bi2qkRcfmf
	m1yhErTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viV1i-00000005ETt-0UQN;
	Wed, 21 Jan 2026 10:01:26 +0000
Date: Wed, 21 Jan 2026 02:01:26 -0800
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
Message-ID: <aXCj9ooYaqsL9oyP@infradead.org>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: E1F5A4000F
X-Stat-Signature: tqkxoe8graats5puc4kgcdpxt79spgjm
X-Rspamd-Server: rspam02
X-HE-Tag: 1768989700-745924
X-HE-Meta: U2FsdGVkX18GyWh/qcALd3+8rzC/WRsoHIda6sqErFejX3y2AwlJZ2zSDqUtmg/vK3AVRmAL4rO/bRaTk4lROmzURwAOjAPeIPcBP1WwHckP7HWdb44CRYh9uBRgvr4PX2Spuc7XrsDT2WCRlyBS1UM7+jSmRqoSAeXWBFqZyB4kXyezz6owxNkL0apPDVyapw8PJXeNJoyx4hSA8Hps38V+rX+wMe/1wsPQxZBGfuEk3u+piIErkaui15MTVkTwYJEOiRZfxhVp4c6EzlucFtsT7OyKXro3+wnaK1d8jjXCjm737iukyZbpU3AXOkpe0Y/CEJgLKRryiPdyHaY2OjioZXr6Nbx1TgOicv5M4JUNLokwCuj6EfSEkFtsBe//nRZsKbtyY2H0LrdbxiUzRlONwFVW7Ucj5Vc6HJv5VpZ4bwxq7Q7Jz6yVEHs8alYofjkf0B1PbabhOYiCPdH6/TPncowNKnLJYzJvfSa44tpQ1W4x0VNecDRGvmnc51ltQLC9I7XTpKYadEQlnSvJh/Yf8owWjBsGtvGr5QisNKEOlhqktQXgiiZ6LbnxoKBag5hPXJKvB1QEdafCGFtF6R/OD0cRUt6dP71tEMxFfJfomRNFieG/DfQMnGBuBPF/+NZnfh/0E3MplDT8sCTDOqm4mxu4WlTXYvkThgf8PS1leEO29udL9r62DTO8Ok6F374Cv4PZ9wQWtElCN4OjHW2gfT32iqD39nIfsV6FYoxavfZR42HOt6qw4puNwTUHRWCNWVMBdtKMgjdbxv10YQn5jXU1h3o/J+vJUxYsrCSBBZZptnjSG0jnSmohO+nwb6uxZw/GWuiBgCNLuHbOk/XhsTvXOBOrrbe52kVveUnNigL85HdR4xCRzUmeXPB1V2XiIeDoL0Xkx/OaSWweSQaeEeTq1M9u5NlpSHNwAqQI6wpDL8BEVuEObDXRqWi4zKRBmH982pnS/QxeAxe
 kTA3EWA/
 lxeQx9cTtDnqpLDnwbxP8NCW1OTj7NxA9jkTGgbM8LCT0x1CU88LnNbI37XKnUgDp5sHFNdSEsouNsXTnxTAFmVctYbdSRQHMM0B72rjRw9usm/TOTNhJSpZl82IsY/+NDFTOQh81rQQfcmrgAivy9h8pUji6ySOG78+cPV7JcgGRMdFal08AV/vHSaD0mliXYx/UoormPeJHW+Z2w2UwSZZWy1XapCmsEsqfIgSUO7qejnkWbSK6umMH/elCQZDLjxF1SY4Z8/xSf0S0yiovkcqzPEk/dBmX7rejWnXtuyn1LfzSSaTwt4LgpuYcDEthaubZfEtGoFo8PrJ+tuecij+XU82EqV/i2qL4gArEhGbPIV18CZVZ2uLAGhDZnHlWOkL7JgoSqISE6AycZIs8fKYq/uD074zaf0wX3NF86s2LOwqgDS0pRfYaz7BAPCr5I3INgsrsO5QAERJ2dFj6KYt+mKK4EKrtcDqICgGWadzInnHXZUaz3UeppMXqvmuQAP6etSypF5lxmSx1R2XETKYscLynQL/ILU/YVv+kR/zCiKb5AAo1qPKPvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 07:50:32AM -0500, Jeff Layton wrote:
> At this point, maybe we should just go with Neil's 
> EXPORT_OP_SUPPORTS_NFS_EXPORT or something. It's much more arbitrary,
> than trying to base this on criteria about filehandle stability, but it
> would give us the effect we want.

We'll still need a stable handles flag, and expose it to userspace
to avoid applications being tricked into using broken non-stable
file handles.  We should have caught that when they were added, but
didn't unfortunately.


