Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53272D1D480
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68A06B00BC; Thu,  8 Jan 2026 12:28:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33516B00C0; Thu,  8 Jan 2026 12:28:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A364B6B00C2; Thu,  8 Jan 2026 12:28:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D10E6B00BC
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:28:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A33714019C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:28:12 +0000 (UTC)
X-FDA: 84309480024.24.A481482
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id E4F4F120009
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:28:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d4rSDFVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DgBHV1jq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DLUw9TrT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WJmCqN15;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767893290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRR5MJyX+HDqbBmCwQZHQRTY+WXgey6jvqbxMzndKRo=;
	b=snbtoFlXSCEeEUOKVxjFOSC54BL+ggSZe0l3X7hJxNKZGWF+0zKlnlBn/n+5hruTGbOFDR
	yyoaTMTHQaN1lEA7LpaIcbiTsSHlM3tOaJLe2305aQjWdX5bYQjMFafXwWj5Zu8RRMXT29
	kxcFOwR8ioXqIzfys9lXqhVOLKa/ILg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767893290; a=rsa-sha256;
	cv=none;
	b=ONYIkLFTJuffX9YKCPNaTPWyyhEEmclqRcEogqZrAXPo2QAURNp8NHK6u5msJPTpgJCc+z
	frg0CAoHbzxO5V0qOTSeY8y/u7ASozVTWwYTFLfET2OgxTGeWfaCdpMkM2vY3vRl+x1MMY
	As+m4IrZB1c8dcpx3qz/Vct38TiQFwY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d4rSDFVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DgBHV1jq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DLUw9TrT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WJmCqN15;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A3CB345BB;
	Thu,  8 Jan 2026 17:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dRR5MJyX+HDqbBmCwQZHQRTY+WXgey6jvqbxMzndKRo=;
	b=d4rSDFVrXJSP77CIbAOSkyHjsRgNACqSgQbCVEPwZM/7zstbAcRfpaKGt2UisstM25nHN7
	1Bgquq3HKv8seUDn0gF0sfxOp2JusCFG/9EjeeXW5wzvXBXqmCE1wFrQAYKngFoA0v5P6u
	83axHXkSOymjejIcnA/3CWyrtM2EjP0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893288;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dRR5MJyX+HDqbBmCwQZHQRTY+WXgey6jvqbxMzndKRo=;
	b=DgBHV1jqSF0+H7pOM/PFFepN4UptQo4Xm9zzBWmsA8HM9uc0EEx2dxtRo2p/BgW1yiLhLp
	aLSuKnoBqXXSPuAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dRR5MJyX+HDqbBmCwQZHQRTY+WXgey6jvqbxMzndKRo=;
	b=DLUw9TrTi3ictVL6EEioV8vKn1Tnf6kctL6QZRX5vF/5rVSvqfOAvG70NWVYOUzLZYrPPv
	JdngfH9/bOKbMsGeD044ITXU8l7U5S8cTiEyCgEXIEkp5Gs8xEtWYMvaxY2N8yBFRKBhTZ
	gG0Ba6Ai4Hwdwd3g0MwV58QLPOnmVNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893287;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dRR5MJyX+HDqbBmCwQZHQRTY+WXgey6jvqbxMzndKRo=;
	b=WJmCqN15jIu+CIYMzqKepntgbV5TrDYXbl8J/P+sr5x+oDHQQw2miYcNGTvbX94SXnz0Fo
	fZFJjn0j2xx8QWBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E447E3EA65;
	Thu,  8 Jan 2026 17:28:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iBi3NybpX2lLdwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 17:28:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 92F9DA0B23; Thu,  8 Jan 2026 18:28:02 +0100 (CET)
Date: Thu, 8 Jan 2026 18:28:02 +0100
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
Subject: Re: [PATCH 05/24] ext2: add setlease file operation
Message-ID: <pqnz52eipormcmskhnn6m4d6tzfnjrzk7qhohxri2euftpzjwx@l5zfqgeenvge>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-5-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-5-ea4dec9b67fa@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4F4F120009
X-Rspam-User: 
X-Stat-Signature: a3h1dpq6hr9cqwbhhacm875bgtaaztnm
X-HE-Tag: 1767893289-866867
X-HE-Meta: U2FsdGVkX1/dBvlgxkxfpxaivDqu5eUbsYSZpNGvR5ixtahbF0JzKPWADnYwSz0AjNl6RWmvEyPwf7DX23fmgSkwS20h5ijUGRe2X1zXB+ZsWo+1ubcICCU5kBUOG47O7FR2bdtnr75XxyvCWvtmos1C4cs08EVYqwippixJHMDNpIcE4wpTyJv8dzqRdEqefadWXdBgqClx9m1rzcYvmngcw5GGX1UMzIYTCCSeZKuMFGUs5JPcof42bbDXVv+wTVrL9ZSlf2trg+D1GvTHSWW0hO+xYkAz8eayfnnjj6NNJ5mL+lI3/GEhTj45O8YY2dghGrGETOerxg2BP8M7x6VMdUpEK55lKkbybZHLM5wNVQt540/gFEFgbbbWFDqJwqg9QXFtXTB4drMCJRB2bJeP4MWTZEcxJiazV2XOTW0pMXkhE+cCj0X/4QL4EZXAuNEH2Im7S8oHaYGmlsofXbGkK/zrmI97/3xwy7ZZlZibArQgXfZPWOrNFRVb4zTEf9CNaq7Qo+jiYLZgxxU3XqMkj05ssWIUPAuTB2j6ErYF16XvhilFDFCWhyUNlVEXUJxxylOruysE0I7dnPEaa9jelOAPyx1v3Ezrvn3SMIwTGMEI1VjUzaBY5NSWXlsF53r06pKcYUYEfSQEnTjQOytp363JjosfpaYmVsDF9YPP9nxMDu3x6MWWGu79dZA0JqvAZXWH1ZquKHDMV1mpXYxjdssx247evGu2Io0FnLSGqx2dsEshXCPUqHekfhqk8wyUEFdqQCmwQntyXdhwE6eCY8mlJOXq8YzbUIikVQsCH34QDPHgfAyhImzmPa2A7klosjggv5TlR3VGwh1Zk4fx8gW/+iAqsWrWjKpWPISbKwa8vT5t0Ok9L+4HcRV8nfNIXDyXKJAc6lNMTO/0gDbcCdtRstSmgVxyBulMQlFuj6wkxZ+M1d7uoFBfTEqglyKwPKEg58BqJSGLqy3
 6Qsfh+Ny
 FVQUBh0uKCB8UYk53TDqlm3yowi67L1ToWGOpBf2hcnMZy4BT+04g47yjPHqLtSK02hrjbXG7ngb9+8cs+DFO7GPGFHEnkTzWF+zkTpjReMJMOiRajzViCuypf6fGL3qkgPX3nLVrM35aKXqUlLM6fA2EEglT1g0ZiJsVe3xZHCdatbnGotQr6id/YPjY91oI667pAmoTGkqmQ3G2e9ltIYCEZ4yoR19eUJNx2oaKDsnlJKIZ3edqZE46vtjQbEg/Vp6aOWrZrYRGFCfLLIGYGpGo8sUQIByLzcUp+2KlOp8BOKVE9pWc4CaEzdAYO9vVCu87HDJPsKVcTevxL+LGCMDGTghHgQp1ku2Cy1ewTsea2Xz0hwKA34ic5hCLkwlWhdBaaGnYXqiIFbhKoomdXfQhudQPtBsFuQ4SgY2P8ec3UTzxC9L66yYDEqWuMejLU/nBVH3mjzWBab8B7m9G2ZlH5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-01-26 12:13:00, Jeff Layton wrote:
> Add the setlease file_operation to ext2_file_operations and
> ext2_dir_operations, pointing to generic_setlease.  A future patch will
> change the default behavior to reject lease attempts with -EINVAL when
> there is no setlease file operation defined. Add generic_setlease to
> retain the ability to set leases on this filesystem.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/dir.c  | 2 ++
>  fs/ext2/file.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index b07b3b369710c4848d6091742cdd0b5c42d4674d..395fc36c089b7bb6360a8326727bd5606c7e2476 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -24,6 +24,7 @@
>  
>  #include "ext2.h"
>  #include <linux/buffer_head.h>
> +#include <linux/filelock.h>
>  #include <linux/pagemap.h>
>  #include <linux/swap.h>
>  #include <linux/iversion.h>
> @@ -734,4 +735,5 @@ const struct file_operations ext2_dir_operations = {
>  	.compat_ioctl	= ext2_compat_ioctl,
>  #endif
>  	.fsync		= ext2_fsync,
> +	.setlease	= generic_setlease,
>  };
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index 76bddce462fced77b24d64416cb9fdb172d8270b..ebe356a38b185e0d8662f704ad20e42fe618284e 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -22,6 +22,7 @@
>  #include <linux/time.h>
>  #include <linux/pagemap.h>
>  #include <linux/dax.h>
> +#include <linux/filelock.h>
>  #include <linux/quotaops.h>
>  #include <linux/iomap.h>
>  #include <linux/uio.h>
> @@ -325,6 +326,7 @@ const struct file_operations ext2_file_operations = {
>  	.get_unmapped_area = thp_get_unmapped_area,
>  	.splice_read	= filemap_splice_read,
>  	.splice_write	= iter_file_splice_write,
> +	.setlease	= generic_setlease,
>  };
>  
>  const struct inode_operations ext2_file_inode_operations = {
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

