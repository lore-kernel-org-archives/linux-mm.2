Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4576FD1D480
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3CF6B0089; Thu,  8 Jan 2026 12:28:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEFC6B00C0; Thu,  8 Jan 2026 12:28:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987796B00C2; Thu,  8 Jan 2026 12:28:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9BB6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:28:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30C0F1AE91
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:28:32 +0000 (UTC)
X-FDA: 84309480864.01.F6DFC20
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id ED48BA0017
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:28:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PgM0qTCX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7I3Psqn1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PgM0qTCX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7I3Psqn1;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767893310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZmRq1jobUO8YamiQvtoLSiP3S45TLaZihc+2opPu78=;
	b=ZYjzpZMgnv2U+hnPDnKYBEwgMPZf3vBGshmln3OR0fSnUUjtl9nKHwEGMY2zJQOD0KmfSA
	xabMjn+fOsnzaBhfPbChOGwUmpw+5Jy1LoVj/aizACcA/9aYZkZipDUNendJNmhU5cMDiN
	YgKz4RhyvzfdIvXcpxc7He2U9gDvnNo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PgM0qTCX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7I3Psqn1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PgM0qTCX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7I3Psqn1;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767893310; a=rsa-sha256;
	cv=none;
	b=51aieZ8AFCC+HrWmVtihJmOaNvCiXd0+ZdIf7I1KdMepbyrhCZmKUx71ATeFvqraWHBNq6
	+6fZLTz4ux0r1W3gXaFNDV9dCHCgQOhxw24OL9+nbYjhJSz71ThLzGJcKFy+dtXBv88Lpl
	1iG3GaaXNx+Et+NsxaOWw3699/ayunk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 31252346D1;
	Thu,  8 Jan 2026 17:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LZmRq1jobUO8YamiQvtoLSiP3S45TLaZihc+2opPu78=;
	b=PgM0qTCXZ2X5Z3hkK3jtzjZOvDMZLm/E4JYhqQ6em+5IaD4UT31FECDXudaGiS5xM4DJ0y
	CjQygviac/9t0aQvin8JilOeYO3xwSNnNhPdm0cnkvbpJgP68yJhD2J3X6sGHvKGWvyaXj
	1+h9HLpBlNo8eR3zYHP8X4pAMSGnU84=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893308;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LZmRq1jobUO8YamiQvtoLSiP3S45TLaZihc+2opPu78=;
	b=7I3Psqn1KNPxXCXm9PcU1P3QCaLnWDhGBG6oy6mEBBHZkBtmbJGI/TRrEDw+5SLm4knqEo
	+ceMclR97Y1K14AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LZmRq1jobUO8YamiQvtoLSiP3S45TLaZihc+2opPu78=;
	b=PgM0qTCXZ2X5Z3hkK3jtzjZOvDMZLm/E4JYhqQ6em+5IaD4UT31FECDXudaGiS5xM4DJ0y
	CjQygviac/9t0aQvin8JilOeYO3xwSNnNhPdm0cnkvbpJgP68yJhD2J3X6sGHvKGWvyaXj
	1+h9HLpBlNo8eR3zYHP8X4pAMSGnU84=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893308;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LZmRq1jobUO8YamiQvtoLSiP3S45TLaZihc+2opPu78=;
	b=7I3Psqn1KNPxXCXm9PcU1P3QCaLnWDhGBG6oy6mEBBHZkBtmbJGI/TRrEDw+5SLm4knqEo
	+ceMclR97Y1K14AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2203C3EA65;
	Thu,  8 Jan 2026 17:28:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9BtLCDzpX2lmdwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 17:28:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D507AA0B23; Thu,  8 Jan 2026 18:28:27 +0100 (CET)
Date: Thu, 8 Jan 2026 18:28:27 +0100
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
Subject: Re: [PATCH 06/24] ext4: add setlease file operation
Message-ID: <4vqji2aypves2bafiyxtpw442nxzhbipvayyl3jky6uogdks6s@l6tfwl272v7e>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-6-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-6-ea4dec9b67fa@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: ED48BA0017
X-Stat-Signature: eiprowaszhe3iipjmjr81bbh7eogexb9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767893309-155235
X-HE-Meta: U2FsdGVkX19i0SDxyALu60fQ7lsdY9rDH6Nd7Ltl4mmHeXCQsHUse0b5SWOVLnZSn2QOHEeA765LlWHcq58Q0KceRt4cogEYaEcXCQmIbwr6P52saS9rQJM7kXPptJGkAATyx1KdmlbNv9hrOGcAMChVaDaj+gOtkFYSBgeaWuNgc2MwHJ1fG7zXdxQWMIo2RAObceIyIW2CL91rOUuiAdtxjBRUTWBbyjZ7r21HOpsq1cAKvWq9G9OF6KGECWHmyOV7jUkpR0BTgRqVNHEJjWyZMqtdpnB0LQ2GGVjjisTXxFpsFGJnygCbz2sxwAMb/BK/5c0rkTOkqYory9GxuDEI0Vinb6X+1oQmgKfzfp80lhIJYvNI9zqVGplpGBbSn1ehPEDcbbtdT3PnUBDb2knax4SSHd+af1NbALpiNfXPJNz9D6Ij0m5VASOhIkbf+htm65XyTrHjISw8r1HMTOe8MaoFbF3pxLpj/o3ppB8ApnLaFFSDMHhgOeOCMI6W7nleq8d+0Vq7G9O4XvRQNxocZi141RYuLnqDRYY0ec4MKuP5w1ixZ6mLAqC/3WBg90XZu3xELoo97WHvMX9W1JgmDZdi77W6YGz0bqZQkpR+puT7biqQ/Udje+cRFYpvyqR7KItC5AC7r508917dTAoMnnnnPwVLhuADs53YRSWpXVhLsKnYWdzEm6aAfAH/3G9PWh2AaFNnMi0e1mPqHJxZxQWRidihtOLhMKEtLsgqIZRN8G6VccSaiV2U+AG8BgTSukCY/268UF8z1ZQqciG/QSENybgRmF2k5ZJY1kQhyqzbxM8axX5X8DcYVcez4GHGgIzOkTqPHYZ7FDs3q+fl+iYhzar4lMPzMshIsCIgX1RcQoYid0z6ZZDHdHNIrcgYvpQvfml5AF7jIiDOda2TFZM1eyI8Di5NXqtX6fnCkNy9R34q64O6w1/o8fQZTDP7XzXmGeAUdoa0NO5
 xG0dJ5y9
 F0rIcl7rNDdEnTKpbdSJbZHNPuUePkql5X5H8d8oR/fv0U9/XamFtWiv078szqaZZud23fJLyZ+kms18ps+5KadTz1RDR1lbhgOkhHSR21UTtFaUOzZT1V/Rlh8Hu8d4ed2iW5HYURYM47+QVjNjRN2n4gFfDgVTSwd6LAzrXnjbGb0qZ8CGvNGLhSlZkFxV2jkHs4M+mgWfLqfD4MtTZsBFLgIUEkjA1pT+U4ESUvT3mTFtx4aHa1ikv8CRpV0tNqx5kEbE+KXfQnx1Kw79U+PjJgL3p99wLJSfOZsBDJaLbJVu/Kggv2woYVb+YLueIJzZd/F/VeZoBHWMGPvuavJP7ZETLZC0OGHSrRi/ZESXMsrlavxt8tiLvhffMUEEZoGuwKRGN/xjrSqaMAwXVzSb0H3GKI75jAamjoe2z2HHlFl3ArsnyD5zQvKmcjsJRP0AjaV5yA9YmkJa5QQsP0EZk7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-01-26 12:13:01, Jeff Layton wrote:
> Add the setlease file_operation to ext4_file_operations and
> ext4_dir_operations, pointing to generic_setlease.  A future patch will
> change the default behavior to reject lease attempts with -EINVAL when
> there is no setlease file operation defined. Add generic_setlease to
> retain the ability to set leases on this filesystem.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/dir.c  | 2 ++
>  fs/ext4/file.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 256fe2c1d4c1619eb2cd915d8b6b05bce72656e7..00c4b3c82b6534790962dc3964c0c557162b6dff 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -24,6 +24,7 @@
>  
>  #include <linux/fs.h>
>  #include <linux/buffer_head.h>
> +#include <linux/filelock.h>
>  #include <linux/slab.h>
>  #include <linux/iversion.h>
>  #include <linux/unicode.h>
> @@ -690,4 +691,5 @@ const struct file_operations ext4_dir_operations = {
>  #endif
>  	.fsync		= ext4_sync_file,
>  	.release	= ext4_release_dir,
> +	.setlease	= generic_setlease,
>  };
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 7a8b3093218921f26a7f8962f94739ba49431230..534cf864101f8d1e5f4106b61c0580c858bc0e27 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -25,6 +25,7 @@
>  #include <linux/mount.h>
>  #include <linux/path.h>
>  #include <linux/dax.h>
> +#include <linux/filelock.h>
>  #include <linux/quotaops.h>
>  #include <linux/pagevec.h>
>  #include <linux/uio.h>
> @@ -980,6 +981,7 @@ const struct file_operations ext4_file_operations = {
>  	.fop_flags	= FOP_MMAP_SYNC | FOP_BUFFER_RASYNC |
>  			  FOP_DIO_PARALLEL_WRITE |
>  			  FOP_DONTCACHE,
> +	.setlease	= generic_setlease,
>  };
>  
>  const struct inode_operations ext4_file_inode_operations = {
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

