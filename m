Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 469FBD1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB4C6B00B6; Thu,  8 Jan 2026 12:27:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90AF6B00B8; Thu,  8 Jan 2026 12:27:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9722D6B00BA; Thu,  8 Jan 2026 12:27:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 851A46B00B6
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:27:04 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30182577E8
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:27:04 +0000 (UTC)
X-FDA: 84309477168.16.FDF065F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6016C140012
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:27:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zlnIZXTf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=phfwz5+a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zlnIZXTf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=phfwz5+a;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767893221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7QyMjWNwrqj8UEPWI/WaBPmYmyTfSFG6zvi/rjbSso=;
	b=iRyHXFf3qXdSdj8WbDu7WaUW6rlz/WGhwtkYmwCdF+xDTO0MhJbheAZVXYqeoUPr5iG6GC
	DCU6LaeglhQ7I/1mUrOMcjpttznlsgU5XinBg1Nd2UDQknj3CwbP1Q5tGSmjAQjGZOA77W
	5617ZXZxQSFjdfxKkSEJdY7elrYMDSc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zlnIZXTf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=phfwz5+a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zlnIZXTf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=phfwz5+a;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767893221; a=rsa-sha256;
	cv=none;
	b=ntb+ofQjXHI0+s8A9Gg7/PpZtvVz7QLcQu1eaoqGYXCmB8kv+g/O/E8esRXcEWItCvcztG
	P7m94msjM/iidVf2e9ijNBpKi3Z5YbLPP8o22HhVA4s5U+RKS1JtUvOb69DUJSXkvl2+LK
	Np1mT5UPajKd5gzf1oWWERbdCzQ66Zs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 62A895CB7C;
	Thu,  8 Jan 2026 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R7QyMjWNwrqj8UEPWI/WaBPmYmyTfSFG6zvi/rjbSso=;
	b=zlnIZXTfinrf7hq5vt4U5cUKJ6NPNUMQKK2r+Tmfi2xEzptt6ClI4wMDQQvjt9dx8n8JRa
	f+6MG01/Jc9w6M+FLcxwyZZdeIID2KjyJifSH8p7z53HnRVuZYr8SQKyqt/r4Pp8Z+ZZ9O
	oGRfCrFhM3vTR5EXInWctDXLZPrEeFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R7QyMjWNwrqj8UEPWI/WaBPmYmyTfSFG6zvi/rjbSso=;
	b=phfwz5+a+RuRX25uv+FH1xiHN8WR/XirFu4FyQP6WWGFdXXorQlDWQOreoBzrsu9F8q7u1
	Qxxocyjselc1ZHBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R7QyMjWNwrqj8UEPWI/WaBPmYmyTfSFG6zvi/rjbSso=;
	b=zlnIZXTfinrf7hq5vt4U5cUKJ6NPNUMQKK2r+Tmfi2xEzptt6ClI4wMDQQvjt9dx8n8JRa
	f+6MG01/Jc9w6M+FLcxwyZZdeIID2KjyJifSH8p7z53HnRVuZYr8SQKyqt/r4Pp8Z+ZZ9O
	oGRfCrFhM3vTR5EXInWctDXLZPrEeFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R7QyMjWNwrqj8UEPWI/WaBPmYmyTfSFG6zvi/rjbSso=;
	b=phfwz5+a+RuRX25uv+FH1xiHN8WR/XirFu4FyQP6WWGFdXXorQlDWQOreoBzrsu9F8q7u1
	Qxxocyjselc1ZHBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4627D3EA65;
	Thu,  8 Jan 2026 17:26:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E6zLEOPoX2kEdgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 17:26:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BEB9EA0B23; Thu,  8 Jan 2026 18:26:58 +0100 (CET)
Date: Thu, 8 Jan 2026 18:26:58 +0100
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
Subject: Re: [PATCH 01/24] fs: add setlease to generic_ro_fops and read-only
 filesystem directory operations
Message-ID: <iik7pdymlt6glogh6f62ps764go4233ub7mgvdctwktc4iszyz@h33w3q63jjrj>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-1-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-1-ea4dec9b67fa@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6016C140012
X-Stat-Signature: qwoxet9xracgsawo3kadni3poxria934
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767893221-87818
X-HE-Meta: U2FsdGVkX19RscoJ16ZVy82RFLti53WySk8VLf02XQjTOsPDlluCBbKe9NIxiwDmp3YMwdLhKwuXd0px1FXplVKzqrHIpIxk3IVcnAwkN/nhnJQsKJa6luc7OKxyyROzVryVVRUE3ll8A4ZmlIKMKinWRQpEHUYfbCP8je+4kX70jl7yKlCNEow2gzdikDpsUDrxIhxRhF5MyulLTIqrDC3NbkkPanhmWZ1/5irC5gLjhUWkf4Ceb3e0LVaN0IGWh2QeXmXWotZ4h3Uo29vA1arCjPym2ys9jWFwaLISKlGSnaENwQeq2KiyyWePM2W/RDUgIb1Logu0MsSEsE7nbaM0NxvP7V68gPEtvhVlmyo+0DZoTT5eXUfw/LagaqVl66A/SHLSlOrBxy57FqHyFbQNiDruRx7Wg5F3IO5TczgmD9s0XQNe3aP2CID2lkkrEKDRMuL7RTBVwunQ4s/5QNoZGbnyUXl1I+dwMch+/mF3lesYx0O9haXuvmxr/LmleCuL8sgDIC/R3SNJZ0NbVRO92h7UZliunQV1EGnD2BUf1bC5KNxgDZdZTOQKyhTs7Mbk2BaSAAKX+DtaAhJIHQweHv8VLRkn0KCjZ/RfebeM8dPJ32b4p4p1fgx+zp3AoI8kZWvljgVwbaZPgWHWveOuOnY1XDnBY9rEgwgomJP/2snZAxJdC2rotDV7FPpMfjrlt3zQdEjBC1cRADDj2MeMJaaotpYZteJUS9bctrIzmrOeQvb86ph97l6cYzHcFbSABm33sRSv7HtjVYx8R8LyAqGe2m0JmfM9/uWavFaDHRJrIbFcAG973R7+UnlhE96qCUkuVq0CF7qhB1Z8jQ/2rZBPx+CBcqyCs9fPiFbN8o3EZAk4FaVic2raJVYnmfcyhw9NkQI2NAoCQ91TDC8UMdXaRUiJlg0MZu6Rr1c8YC/gRqTbVuiObQJoFlTJLP54PcPXkYMag5AzRlp
 mGhH9cDD
 1zhWifroSQcVzLDRgExn+wZCRVJV2suopDc6zd1R7Tc5OJcdyHjOuz0BjzhkPIvMGTamczLUPf6CdjYeTRomdU1eS4q8fK/dO60MfeTdWh2HP3bwlnK+da87zFO0mprP+Sn7hZumpyd1m6SoaeSuO5O2V4c8Y+5FGvDP+fZMMgEmyke60NCEkoGrwsjje7NuAgr/YxgykVJpUz6hL0dd+V5oPQgj2bQ7n4pQinUGgF6G3mjslGX8mmn8uWnSlo/smsDtvmq7DpeIJwANUr1ueGh1nYDSlA5uWdxKH9SfD0fH7MzrJNLXekd3xM3twb18F19E3NGOQ0PeUyjQRWVJks5A20eiohE4YFJAjmoBCFg1f0y/RRtOU+MMoGEGlmVuWTHwUR686PAlvIbx1TfGiLz4+PX8S2/oYQAHGa5DiDmehg9bl+BghGgSt/3YGUQ/XPX5VHR4xQ/r/m0LL7bjoB+jXsySRM+jtbEgUhAYZ9oS65nY1KZh0vIwZHUjEtwcCZIeJFzizOdXUydw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-01-26 12:12:56, Jeff Layton wrote:
> Add the setlease file_operation to generic_ro_fops, which covers file
> operations for several read-only filesystems (BEFS, EFS, ISOFS, QNX4,
> QNX6, CRAMFS, FREEVXFS). Also add setlease to the directory
> file_operations for these filesystems.	A future patch will change the
> default behavior to reject lease attempts with -EINVAL when there is no
> setlease file operation defined. Add generic_setlease to retain the
> ability to set leases on these filesystems.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/befs/linuxvfs.c        | 2 ++
>  fs/cramfs/inode.c         | 2 ++
>  fs/efs/dir.c              | 2 ++
>  fs/freevxfs/vxfs_lookup.c | 2 ++
>  fs/isofs/dir.c            | 2 ++
>  fs/qnx4/dir.c             | 2 ++
>  fs/qnx6/dir.c             | 2 ++
>  fs/read_write.c           | 2 ++
>  8 files changed, 16 insertions(+)
> 
> diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
> index 9fcfdd6b8189aaf5cc3b68aa8dff4798af5bdcbc..d7c5d9270387bf6c3e94942e6331b449f90fe428 100644
> --- a/fs/befs/linuxvfs.c
> +++ b/fs/befs/linuxvfs.c
> @@ -14,6 +14,7 @@
>  #include <linux/fs_context.h>
>  #include <linux/fs_parser.h>
>  #include <linux/errno.h>
> +#include <linux/filelock.h>
>  #include <linux/stat.h>
>  #include <linux/nls.h>
>  #include <linux/buffer_head.h>
> @@ -79,6 +80,7 @@ static const struct file_operations befs_dir_operations = {
>  	.read		= generic_read_dir,
>  	.iterate_shared	= befs_readdir,
>  	.llseek		= generic_file_llseek,
> +	.setlease	= generic_setlease,
>  };
>  
>  static const struct inode_operations befs_dir_inode_operations = {
> diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> index e54ebe402df79d43a2c7cf491d669829f7ef81b7..41b1a869cf135d014003d6bf1c343d590ae7a084 100644
> --- a/fs/cramfs/inode.c
> +++ b/fs/cramfs/inode.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/fs.h>
>  #include <linux/file.h>
> +#include <linux/filelock.h>
>  #include <linux/pagemap.h>
>  #include <linux/ramfs.h>
>  #include <linux/init.h>
> @@ -938,6 +939,7 @@ static const struct file_operations cramfs_directory_operations = {
>  	.llseek		= generic_file_llseek,
>  	.read		= generic_read_dir,
>  	.iterate_shared	= cramfs_readdir,
> +	.setlease	= generic_setlease,
>  };
>  
>  static const struct inode_operations cramfs_dir_inode_operations = {
> diff --git a/fs/efs/dir.c b/fs/efs/dir.c
> index f892ac7c2a35e0094a314eeded06a974154e46d7..35ad0092c11547af68ef8baf4965b50a0a7593fe 100644
> --- a/fs/efs/dir.c
> +++ b/fs/efs/dir.c
> @@ -6,6 +6,7 @@
>   */
>  
>  #include <linux/buffer_head.h>
> +#include <linux/filelock.h>
>  #include "efs.h"
>  
>  static int efs_readdir(struct file *, struct dir_context *);
> @@ -14,6 +15,7 @@ const struct file_operations efs_dir_operations = {
>  	.llseek		= generic_file_llseek,
>  	.read		= generic_read_dir,
>  	.iterate_shared	= efs_readdir,
> +	.setlease	= generic_setlease,
>  };
>  
>  const struct inode_operations efs_dir_inode_operations = {
> diff --git a/fs/freevxfs/vxfs_lookup.c b/fs/freevxfs/vxfs_lookup.c
> index 1b0bca8b4cc686043d92246042dcf833d37712e4..138e08de976ea762a46043316f27e9a031f60c32 100644
> --- a/fs/freevxfs/vxfs_lookup.c
> +++ b/fs/freevxfs/vxfs_lookup.c
> @@ -8,6 +8,7 @@
>   * Veritas filesystem driver - lookup and other directory related code.
>   */
>  #include <linux/fs.h>
> +#include <linux/filelock.h>
>  #include <linux/time.h>
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
> @@ -36,6 +37,7 @@ const struct file_operations vxfs_dir_operations = {
>  	.llseek =		generic_file_llseek,
>  	.read =			generic_read_dir,
>  	.iterate_shared =	vxfs_readdir,
> +	.setlease =		generic_setlease,
>  };
>  
>  
> diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
> index 09df40b612fbf27a1a93af2b4fbf6a607f4a1ab4..2ca16c3fe5ef3427e5bbd0631eb8323ef3c58bf1 100644
> --- a/fs/isofs/dir.c
> +++ b/fs/isofs/dir.c
> @@ -12,6 +12,7 @@
>   *  isofs directory handling functions
>   */
>  #include <linux/gfp.h>
> +#include <linux/filelock.h>
>  #include "isofs.h"
>  
>  int isofs_name_translate(struct iso_directory_record *de, char *new, struct inode *inode)
> @@ -271,6 +272,7 @@ const struct file_operations isofs_dir_operations =
>  	.llseek = generic_file_llseek,
>  	.read = generic_read_dir,
>  	.iterate_shared = isofs_readdir,
> +	.setlease = generic_setlease,
>  };
>  
>  /*
> diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
> index 42a529e26bd68b6de1a7738c409d5942a92066f8..6402715ab377e5686558371dd76e5a4c1cfbb787 100644
> --- a/fs/qnx4/dir.c
> +++ b/fs/qnx4/dir.c
> @@ -13,6 +13,7 @@
>   */
>  
>  #include <linux/buffer_head.h>
> +#include <linux/filelock.h>
>  #include "qnx4.h"
>  
>  static int qnx4_readdir(struct file *file, struct dir_context *ctx)
> @@ -71,6 +72,7 @@ const struct file_operations qnx4_dir_operations =
>  	.read		= generic_read_dir,
>  	.iterate_shared	= qnx4_readdir,
>  	.fsync		= generic_file_fsync,
> +	.setlease	= generic_setlease,
>  };
>  
>  const struct inode_operations qnx4_dir_inode_operations =
> diff --git a/fs/qnx6/dir.c b/fs/qnx6/dir.c
> index b4d10e45f2e41b45568fe813a3cc0aa253bcab6e..ae0c9846833d916beb7f356cfa6e9de01a6f6963 100644
> --- a/fs/qnx6/dir.c
> +++ b/fs/qnx6/dir.c
> @@ -11,6 +11,7 @@
>   *
>   */
>  
> +#include <linux/filelock.h>
>  #include "qnx6.h"
>  
>  static unsigned qnx6_lfile_checksum(char *name, unsigned size)
> @@ -275,6 +276,7 @@ const struct file_operations qnx6_dir_operations = {
>  	.read		= generic_read_dir,
>  	.iterate_shared	= qnx6_readdir,
>  	.fsync		= generic_file_fsync,
> +	.setlease	= generic_setlease,
>  };
>  
>  const struct inode_operations qnx6_dir_inode_operations = {
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 833bae068770a4e410e4895132586313a9687fa2..50bff7edc91f36fe5ee24198bd51a33c278d40a2 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -20,6 +20,7 @@
>  #include <linux/compat.h>
>  #include <linux/mount.h>
>  #include <linux/fs.h>
> +#include <linux/filelock.h>
>  #include "internal.h"
>  
>  #include <linux/uaccess.h>
> @@ -30,6 +31,7 @@ const struct file_operations generic_ro_fops = {
>  	.read_iter	= generic_file_read_iter,
>  	.mmap_prepare	= generic_file_readonly_mmap_prepare,
>  	.splice_read	= filemap_splice_read,
> +	.setlease	= generic_setlease,
>  };
>  
>  EXPORT_SYMBOL(generic_ro_fops);
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

