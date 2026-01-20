Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E833D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 07:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586696B037A; Tue, 20 Jan 2026 02:50:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533646B037C; Tue, 20 Jan 2026 02:50:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C8F6B037D; Tue, 20 Jan 2026 02:50:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8A96B037A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:50:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9D0BB97FA
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:50:36 +0000 (UTC)
X-FDA: 84351570072.14.0212E3C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 333FEC0006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:50:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=N18Lfx2l;
	spf=none (imf22.hostedemail.com: domain of BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768895435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haSfZvoEvPhBBZDnUW3y3BhJEQ36mgFSvpNiOqhvJvI=;
	b=r6V2kIo29+mWQZWsf+jPsVet0qvdz2gpWklx2kkoNP+Xuja3nI+8yueQxH8SlkG+kz1IAb
	5juGfjOwcfVjm5odOMJ0XplBMR7tUJKB1mCbyz0v4XgcWUVysee00LloSfcR9+SvsMDlDi
	O8BfikxXHEdLwP0YowuZLyg0R5vtaUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768895435; a=rsa-sha256;
	cv=none;
	b=lpP2yeUFlKSJq0Q/uS/Jdv1IH+3hMMkHIbxWf07IEuCngvMC9S4HO+7ecCeAFX3vJoyrq3
	3Yj4zQ7b8339jECSEX3OAIBJv9mIKAx1ZC4BHfWhM37APK+E5yTErC4ZjcYKDhx4ww7Lt6
	inCWiC+NcbrS3nv5kmB1DWDXYZM3gnk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=N18Lfx2l;
	spf=none (imf22.hostedemail.com: domain of BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+6f87a82fb8d0462b7f15+8185+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=haSfZvoEvPhBBZDnUW3y3BhJEQ36mgFSvpNiOqhvJvI=; b=N18Lfx2l0cTzfa3HEHbSStwRPv
	iyXHar7+IL8UusFL6sjIudxhuirPKAhJMeBNA+7JTaSgRPwHzsN72C9/ED13gd4R3bzZoK6cN15el
	2OOL3ox9rvwKCy+jqAl20MM1KOQeI06m0Nqc7qZlyinWokSDH6OADy7uwk70GRUXw1dKPRbjqr1Mx
	G0x+S1U8gEmAS0uHHMxQqMK+KDGwlJXyI4/nRqaD3y/MPBEQbIe1RJKnMGnpCsJCrYQkezP6l13YD
	Bk/y5So46wc2umpZT0PCIQ7tT9Ms4VQ/Y3zVPPZ8bLDLhE9SURfv9f85/RpFqttM9TA+n04nUeD09
	UJSC4XRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vi6VB-00000003NIK-3jXc;
	Tue, 20 Jan 2026 07:50:15 +0000
Date: Mon, 19 Jan 2026 23:50:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Amir Goldstein <amir73il@gmail.com>,
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
	Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Chinner <david@fromorbit.com>,
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
	linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 02/31] exportfs: add new EXPORT_OP_STABLE_HANDLES flag
Message-ID: <aW8ztQ-RbhxwzMk7@infradead.org>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
 <20260119-exportfs-nfsd-v2-2-d93368f903bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119-exportfs-nfsd-v2-2-d93368f903bd@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 333FEC0006
X-Rspam-User: 
X-Stat-Signature: 1zt9yqs8m13qxdzm58xeoypgfs188epa
X-HE-Tag: 1768895434-202126
X-HE-Meta: U2FsdGVkX1+Dy13FDcEU+4URI1gzpjnl2FUg+ojJwq3rDRe8+0iBmI1QkLuuEc4Ou6HYIC5jkRp8oRUbnmUjQ4Jtk69ZkTUvSdyYY5nObyGuGRGzC/nQML0Sb/SbVFo2sfIzfW98a7xGVhtma9n9zeje18WovJm55Z/85eiewdH57h/L3DHfv3iOnWdYlpCUas+9SxGSfGpGlek5UVZy4NW/GvrQ6XsbSHyfcnVeSY77SANVTrlROwDxgRqiNNpZO9qJi158CDPtA8ewhCr+Fq3ue+sGwmA9lufhB+U2jIrkzvgYMQL7Rjk/m+rCR1UEI0CN+6bewQgGuGt9WGmZVCmQg6JxIhuHFRulLu144bkvd3qKommw43qlKjErk5FtXj14s4ofGNPHCaCanMUFfc+8z8dsB993xuAdjpSajwdrnYNdwhW3ry7IJUfhbUgNtkKtXpBoawYYky4hPMi8nZFKqCZh+tCmkRlK6mEz2l91qYdgRcB5caDtRz36VyPzKDMrmSZX8PFuRHii3ZQaBwAq0SMIZ2Rw/sCqHkEVSjhEiH0Czz8o7Df3QrYglqOj3syvhKjL9LHyVojPStYfbTr+SXln1PPwQ+PSeZ2OoNJE7yLZ0dI792HrSBB1k3jK8HvIhSZZytkw7K5Nljups9k6QYA3fNgaS5VJQ0SyxGuSn78CtjqXv3phNizvDpLMPVTxw258IjDWhD/vZ49pt0XJgKHTIPSTz0l+JTXNjqBZGQ4pmep6EgML+hdAijRUWRyOWFmJM/V64yBmRzbx2TioBqlbE2Cq9YDHTK8HskfNullI+V9HZRZIR5Lt13OBDe3bKb4CNBdr+sczqEypMWrTtWyLTkc6WTuZzZaYtmL+MoFP/JH3ipsgaHLn0gu8Y6bMQW/zYGlRVdy/XXRRu56f9oA2srsJxtyvYWmeU35PBPn4hTMpR3HoW2KGKTOIrZleWPz3RFRzzpBBjRU
 HqZKSisL
 HnZ1ej6x1FBf3wsVKodEfSewvaq8BBtXcEtNIRY11fMLICDdMv/SQZK/rQ/JjXg/LM3hLgJccoaFE0RYe1EouLQxcskioKSpjhbKGl4UPqiqAvp0rJpwlZVkqI7ZbbA6hFxqhNoFjNZBB/4vUvR6BYge74Y8ANB7UydDnC3MIGyEjJDFtdDC/yej3ijp4igU+cweFMzzsbHYe+K+D6uhRfu1r8l5ARzchJSaA039dHFc2gXZn5s6jcI20U6PAVnsTW+1Ny93zWqMyWQLxlrtINPoFsvzAvP63Ls4cm5WY+CsE0o8T+L8NQ+dgsNNMJtzdjTZZihtprH8RjfWnbO2UpQsbPC6CakLx+t0o5qt3VsNGCof+Vr/AVk+MprBPIG+0l0ocB7QIvnOyxlL08TKaZZ1SYsAv9vE8jQ278BZjWAs9vegFRpr5Bvz4APt1I4u4Q8wS88jmQEUdnJX1mztmPFrnKrO66/60sPsebYGtN3l4ilPuLmTXN1cHl7syhawHsBhi8dq2rnfs7pHeVlwWcpoytxBpxKiFe/Me7t6pL0ICj60nRb7XYa1wcBxRx/OzvSYEAHchph+ET5A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 11:26:19AM -0500, Jeff Layton wrote:
> +  EXPORT_OP_STABLE_HANDLES - This filesystem provides filehandles that are
> +    stable across the lifetime of a file. This is a hard requirement for export
> +    via nfsd. Any filesystem that is eligible to be exported via nfsd must
> +    indicate this guarantee by setting this flag. Most disk-based filesystems
> +    can do this naturally. Pseudofilesystems that are for local reporting and
> +    control (e.g. kernfs, pidfs, nsfs) usually can't support this.

Suggested rewording, taking some of the ideas from Dave Chinners earlier
comments into account:

  EXPORT_OP_STABLE_HANDLES - This filesystem provides filehandles that are
    stable across the lifetime of a file.  A file in this context is an
    instantiated inode reachable by one or more file names, or still open after
    the last name has been unlinked.  Reuses of the same on-disk inode structure
    are considered new files and must provide different file handles from the
    previous incarnation.  Most file systems designed to store user data
    naturally provide this capability.  Pseudofilesystems that are for local
    reporting and control (e.g. kernfs, pidfs, nsfs) usually can't support this.

    This flags is a hard requirement for export via nfsd. Any filesystem that
    is eligible to be exported via nfsd must indicate this guarantee by
    setting this flag.


