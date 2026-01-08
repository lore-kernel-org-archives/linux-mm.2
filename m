Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB3F2D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34BF26B00C0; Thu,  8 Jan 2026 12:32:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F4C6B00C2; Thu,  8 Jan 2026 12:32:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E136B00C3; Thu,  8 Jan 2026 12:32:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4196B00C0
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:32:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5B0D1A0187
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:32:06 +0000 (UTC)
X-FDA: 84309489852.08.CDA942D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7DE394000C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:32:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MKYplGgU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+kISGD+B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zchHYT5l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v7Sxuhou;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767893524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rc9QMKouyjzH45LZUhjCbf9iU6kNH1nER3QE4i7JiDM=;
	b=oBJNDaUAn1iB0cpkYbFSXrENkZCILFndErvpLY4cbVPTMtdFzoIangzVUkzj/a/8WOwLEU
	O7EIdN+CLe6/m7EdRbnQfHURsjnL52iuzc/rGoMB535WbQzjPn+XT4Hh5TzdmmKjTYEJFy
	cN3bXR3qBxvv+oJNRIXr34iRBmeY3B0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767893524; a=rsa-sha256;
	cv=none;
	b=eK07XvwwdhkYcVmJQA+mGUgPCLI0+4dp5vwjSS7B7EE0p/3x8Y/RuD7adxbMT69L/zCrSJ
	zZ41D2pxnolNajkkJ1jFmDNZp0hWoxADIih4w1b1Dmwbanh/YKqyV/9h8CGDdA2dwrGejH
	+PiU7ZCkftlzn4w1AoZnOJJJog7MoWc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MKYplGgU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+kISGD+B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zchHYT5l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v7Sxuhou;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E02605CBAB;
	Thu,  8 Jan 2026 17:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rc9QMKouyjzH45LZUhjCbf9iU6kNH1nER3QE4i7JiDM=;
	b=MKYplGgUyR+sE06i0JiUz8GKtJbOPqRHHpMIj+IWs303KtwqzOMjj+JFlHwHtSt7nbAUxA
	UNp4Ll6iPK3H52aM4vFBGo0ErVRKRIPPFhbwF8eh7s2fgE1PWOm6znJF/4G+mtw+movdZo
	1psyKrKOcJR2WxUMmY9s6q28XLqlyTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893523;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rc9QMKouyjzH45LZUhjCbf9iU6kNH1nER3QE4i7JiDM=;
	b=+kISGD+BwUugn2ejyQVVgjX3pI8t3dz4nil+/amsO+obOFpkCydzCEt1LMAEaSWkfKrT23
	PrLkTBk88AY2V7BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893522; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rc9QMKouyjzH45LZUhjCbf9iU6kNH1nER3QE4i7JiDM=;
	b=zchHYT5ly7W8Ws0WGBZ/OLSaO6YePdF0ZuvnJ54B4z/6iRJB1Rmu65L8SCdhqtGnDJRxNt
	h8hIIjb74QUVWPEDWc4b2ZIMvH4EEJ7zRjN43UvzJAdzhjiSz7WLubJqA7OtP6gQLvF0Fh
	qsB+hXW7VQPvyvSNGU9sg0unRkW933o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893522;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rc9QMKouyjzH45LZUhjCbf9iU6kNH1nER3QE4i7JiDM=;
	b=v7Sxuhou8fYCJendb+nuEct46VWp54XIkm6cHFo3LZWNdJd5/5Qm//MUpOHl5WjYSfdzmb
	HPS47RhJ47XDEuBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C47143EA63;
	Thu,  8 Jan 2026 17:32:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pu3oLxLqX2nzegAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 17:32:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3B7FAA0B23; Thu,  8 Jan 2026 18:31:54 +0100 (CET)
Date: Thu, 8 Jan 2026 18:31:54 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, 
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
	Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, gfs2@lists.linux.dev, 
	linux-doc@vger.kernel.org, v9fs@lists.linux.dev, ceph-devel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH 19/24] tmpfs: add setlease file operation
Message-ID: <5dtyb6by4ujjnkjz6lu4rl2x3s5km6awilvrozuzmgq2wn7bl6@cxvq3jpviunf>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-19-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-19-ea4dec9b67fa@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7DE394000C
X-Rspam-User: 
X-Stat-Signature: 7nag5co4bybhon5y1mh3y53sw6rdu5o9
X-HE-Tag: 1767893524-67311
X-HE-Meta: U2FsdGVkX1/S3K/EtrSZUHn8MuCE2Xdt0ByZ76pJsA7G1ghEwzxQSCfeca4Bby1w9LmSAuNhBkwpafjdKo40msAPh/rqsyd3NeoYP8oArhJLGzxjVqDP3oLEpzk6TLXCpBQsXgn/AcyqX1Cu4AyDC8qCP/dhhdE78Oi89jxfh0TxvJaC8OaOB3d+MOHAYWMgkJaPSdw/wXmJPq546TI1721dMnOlk5XuMlymTiI+D4JmaVjl/jx5omwxYYogrXihqoLTTEnVVwh4ni016mUtHlOfqKWyQjR+EVV5+FnzziHQzlRVSCExBKv2f5yaiyWqbIMeMWrJP0+dY2SjBD9KsGRwn677mgwgKbuJoSsgAYa4N+fZ2NTZ5TCQ0z9WVai5gFhCdIIaXTA0st7plNuzApOFjaw9tHIMd6q7txz4sQVJSFNy+pipdobQz5Wxd/HM/HPwl5whzkWM95mGJwu8/2Oy2R3ey8n5mQYQFeQvq/BrnSF4/HXzp+dfwSs0imDZ0yaYEfldIRN7qMR2L9MwDy9HS2ti+Q5BTbPt8ETKxkvomw9aHDU5Lww2G7IbEUzabqO/sJyEuFEYqIp8HhwIuI3f62Pia94eyY1p285Mo7dv0s1Td1vT0nDM1FWOXQLMr+p7PKZCgxV5+aWfXpj2qkY4Zn7JdIWWKy2pa9SKbXID6s3XTAWu888GoA5t0aymm95n+PdM0qlEday1HhZpOyvZGGICTFIMMYvGx9I9xop1TsyA/oyd/qHZ066qSMc0ZPIvEjrvYd2+7HgK3mHF67/wqXclhWLAcKKFWXt+4IWFaTlmlZy/qZ5uKZMJtJsYIz20okn/9jBJA8KrjFjPsPfiZtTGdvzess6SO1dn+FgBwCK3keVldYNPC3Dx2UwSNvq48YRFFs9FybVFKGs98Qg1V7HRBsd9++owEO9EcC+710igwjSxzpT7tXoefxffHyL+VT03RawhNtQI8P+
 vl/dzFWD
 s9ZNAfmWDovlcOxoEHsP0yyYg5nk2it39FnqQdLbtsBVNLyJ2JKR6fXHt1J5bRlECheRnv5ymjjnVdD0g8ZJV2JHvTkQT3xUZQ2yqMDOfQmz7zC+nKfH7tciz9F/Pr9nRoSla8SoJ3040poFYYkCSAR2augoyO4TU109atnAIaowicACgZjnT0rWxbLOIjnOWPgaqmuUMi5MhAv1QMsU5MWBenO9shJ4i5ctw3roRRyLDUw/Bld9/NIc9rFoIO16aYHTFhsadEDkhSQCsMqjVP+LU1iQEC81r694TE0pDfr8VBXCi2WTnf8+jH1wa2884dO3+wY2W6dH82choHieNy3UzbMfeVik2rcJjaNMLSWo7wcxfIbjhl8JhTdFZQqHFBThnsY0vYLoOLdayfjRnQEHNcfYDWqTMA+AmbeUo3esFIbuMqM9UOZPViguKlE+NqobJuHAJ8M2y3GtuXpmAmEYU6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-01-26 12:13:14, Jeff Layton wrote:
> Add the setlease file_operation pointing to generic_setlease to the
> tmpfs file_operations structures. A future patch will change the
> default behavior to reject lease attempts with -EINVAL when there is no
> setlease file operation defined. Add generic_setlease to retain the
> ability to set leases on this filesystem.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/libfs.c | 2 ++
>  mm/shmem.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 591eb649ebbacf202ff48cd3abd64a175daa291c..697c6d5fc12786c036f0086886297fb5cd52ae00 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -6,6 +6,7 @@
>  
>  #include <linux/blkdev.h>
>  #include <linux/export.h>
> +#include <linux/filelock.h>
>  #include <linux/pagemap.h>
>  #include <linux/slab.h>
>  #include <linux/cred.h>
> @@ -570,6 +571,7 @@ const struct file_operations simple_offset_dir_operations = {
>  	.iterate_shared	= offset_readdir,
>  	.read		= generic_read_dir,
>  	.fsync		= noop_fsync,
> +	.setlease	= generic_setlease,
>  };
>  
>  struct dentry *find_next_child(struct dentry *parent, struct dentry *prev)
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d2bd47db9d7506e4d6a565e092185..88ef1fd5cd38efedbb31353da2871ab1d47e68a5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -29,6 +29,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/file.h>
>  #include <linux/fileattr.h>
> +#include <linux/filelock.h>
>  #include <linux/mm.h>
>  #include <linux/random.h>
>  #include <linux/sched/signal.h>
> @@ -5219,6 +5220,7 @@ static const struct file_operations shmem_file_operations = {
>  	.splice_read	= shmem_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= shmem_fallocate,
> +	.setlease	= generic_setlease,
>  #endif
>  };
>  
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

