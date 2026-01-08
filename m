Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A72D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD796B00C2; Thu,  8 Jan 2026 12:34:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0843E6B00C4; Thu,  8 Jan 2026 12:34:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBBE06B00C5; Thu,  8 Jan 2026 12:34:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D45746B00C2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:34:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67860B6FA5
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:34:46 +0000 (UTC)
X-FDA: 84309496572.29.832CCEB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id F06534000C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:34:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0yPA12Jp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qq81RSYL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0yPA12Jp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qq81RSYL;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767893684; a=rsa-sha256;
	cv=none;
	b=NDLVgSPs7MERS1MGLPlU2gu5/zWqKpl+Y8t5+xhzP8+zNVNFWK6Coy1A/vOCC/xwZJmA0h
	ZR52BEm11gOKMGJDLnJTryUoxN8SOXA5SEgVxxArE9APWo/iQu1jJjIZkRDqAXdBA8nkrn
	PgV9zFCrcVqt2AdZnXqsIRuxfvgtuuc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0yPA12Jp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qq81RSYL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0yPA12Jp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qq81RSYL;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767893684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUc1HNzkDvMEUB9H5lBxhNGfEq+qWRq++O1au4+GYAI=;
	b=RoIrfkFzKPtFNAfPfH0oYKHWdbWfLbti2SmVYgCMpj79JyR9siQ3zwk4VJ5+AVKsKZOA11
	mzGGUkr+4PMVAvATdqVca6ZjpBhAY27eGLiCsMY/WbcVgKjeO0lnotE6gmEjFdhZBpO9/A
	vlK9N0kykf8M3+OCQkHM6ojs/WI7nVM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A47FB346F6;
	Thu,  8 Jan 2026 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yUc1HNzkDvMEUB9H5lBxhNGfEq+qWRq++O1au4+GYAI=;
	b=0yPA12Jp8JS5heOg95ZBNoDkf204gVcniWsn/fJeC6+fW2zpurpQMGMMkMCfxGVUVMIjgX
	dG04kvPamXGeblro397+b1pImKgAVsakUAf7h2gbihWm5ZUE2Wn69UivcIh4PjOG5M4Thp
	HtBRjSGX7Piz09dZWxAXHUvjuPH/no0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yUc1HNzkDvMEUB9H5lBxhNGfEq+qWRq++O1au4+GYAI=;
	b=qq81RSYLs9Cj+wyrsmmCLVvswGxZhveuS0nYUbQFYpr4oMVsUrikb2GO7O4YuWAczj2C5u
	XCWEKFLS+EUOIXDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yUc1HNzkDvMEUB9H5lBxhNGfEq+qWRq++O1au4+GYAI=;
	b=0yPA12Jp8JS5heOg95ZBNoDkf204gVcniWsn/fJeC6+fW2zpurpQMGMMkMCfxGVUVMIjgX
	dG04kvPamXGeblro397+b1pImKgAVsakUAf7h2gbihWm5ZUE2Wn69UivcIh4PjOG5M4Thp
	HtBRjSGX7Piz09dZWxAXHUvjuPH/no0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yUc1HNzkDvMEUB9H5lBxhNGfEq+qWRq++O1au4+GYAI=;
	b=qq81RSYLs9Cj+wyrsmmCLVvswGxZhveuS0nYUbQFYpr4oMVsUrikb2GO7O4YuWAczj2C5u
	XCWEKFLS+EUOIXDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7983F3EA65;
	Thu,  8 Jan 2026 17:34:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q+meHbLqX2lYfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 17:34:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 253C2A0B23; Thu,  8 Jan 2026 18:34:42 +0100 (CET)
Date: Thu, 8 Jan 2026 18:34:42 +0100
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
Subject: Re: [PATCH 24/24] fs: remove simple_nosetlease()
Message-ID: <46yafpkezaxdv4jvw2lqdmisfzxqjuxml4x53cl3egpza7opjb@zahika34s67e>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-24-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-24-ea4dec9b67fa@kernel.org>
X-Rspamd-Queue-Id: F06534000C
X-Rspamd-Server: rspam06
X-Stat-Signature: nux7q4gdt1dz6qwynjtbzmw7zrp4w4oy
X-Rspam-User: 
X-HE-Tag: 1767893683-810144
X-HE-Meta: U2FsdGVkX1+qtbV7MpVj3PfvIXlC42mGajULZ1/i0b6geTA9UaJF5Zwox6QvNcsq6WPT+6BnUBH4TUBV0voz+acGgVtaMyr+SK0hgYYQnQS/siYvepm+niaD7YNp/ypES/egr2ibxy+Ra/evC1tx3Icp7XymgPSO7YiOeGgfG74DKgG9Iii96oJO/82g8BCAJQPHUNkN0b30/P3NjfelXRF5DPRO8C+zPnFlKaV4echMd7rnVw7X6NFypvhVnoRpgOiyGaa4vbTbuRsIeNmG/pNl738i3I+bZVXzQHRSc2ay6Vh7YTbKEZ3fdPZY0fK0PwpkyQjmzWx7eqlRKpa5Vco7sLdR5c1IS/2Am6Q1jCNg+TPWTu4IJy8CvnGt7XoHHgS/0RQR9eFtadjK3kwdHO7jd9SCRtA+67lfrNA3F9eGuNrhCGAlF2PisdBfN7G0p3AsFcZb7D8Tfws3GIu5kjtHEUbDcFnSEh8APiRq7l3VMmGqBy4mHwU4FxXODcdJ12vesxGJ5UJwnKuy2c4cy6x79CE7fhNRJE2kw4VC/mZlZ/a6MS7trEOuyTVz+GxtnnwT0qYUcV0BOtW3gTtCyWwTk05dTgbTX0lXhq1B+1L8QBD1TLgSaJL71NUmJ6tD/CPZly+19SNrhFTOqHo2RJXYQutj4p04j8TCif7EFXgHWEH/tfHwhMxqCL7/78a5WGBaQAo0ASUtgu5bTLLiaJtoIVtFHMrTV7paI0uo7aPCwE1zbSn9nljNTJ0Ja02W7Wg+ETj8pEubJZu9Bht3UaFGOT69MApsQ0VXpA/49Czk0D1mOxXV6KNAs0rQBrxd5uD2KROcNNCnz3qG6a18pUo2fhhssVV9nfPfUxvWEwqRSt7HZ0RUfcsN+f09zf377jXB15ryJfHOXGlUz6Y05fGIZC9REl4Fprm7iTSy0haPjl/SB5ZwSUHKI1uHV96zsZDZSVYeKxwp8I1BAro
 XG9cOOW8
 lIXUMZ2vNHtEV7eFgaWPYLqptXxDozX0TCpMZ9ctuNySCrqlAlZC2OsV/T5Y/bLyUfNu6PIGj3TWmdePa4RjQRmv92x/HA1hKWvm5OQ5KbyCKbTi+9ggvvxpFE1fPmeTUZWZV2RnwVaAqCvM02s7pYjrlYeTr8wadB9HcCtXcQTlUrWa7p0vNrVU0k6Zted2tvv4qlciWNurVqViUtIteC0ZBV18fpRqmqSmxPjAu/jIucrz1spRoR1k7XX+u01f661cpslWN1hph1sZZQNnFTxIni8lflQcupSAYgGJ79eAbxH6BGA2NAkBOSVaV729BLWdrQi97blhxShKHsWPVITflMyQArS8hRkCLVKkLvFJGpFdC98XUtAl+l6h5wKCqsjNfRDMypSJdEu3qi+GbQuw+SJIuYmI+aGeh0AolHLFSAfITAbhSrum6odTTeMbobZiitveegdaWo06JMSiEtwwQsNijfsB80xHG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 08-01-26 12:13:19, Jeff Layton wrote:
> Setting ->setlease() to a NULL pointer now has the same effect as
> setting it to simple_nosetlease(). Remove all of the setlease
> file_operations that are set to simple_nosetlease, and the function
> itself.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Nice. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/9p/vfs_dir.c        |  2 --
>  fs/9p/vfs_file.c       |  2 --
>  fs/ceph/dir.c          |  2 --
>  fs/ceph/file.c         |  1 -
>  fs/fuse/dir.c          |  1 -
>  fs/gfs2/file.c         |  2 --
>  fs/libfs.c             | 18 ------------------
>  fs/nfs/dir.c           |  1 -
>  fs/nfs/file.c          |  1 -
>  fs/smb/client/cifsfs.c |  1 -
>  fs/vboxsf/dir.c        |  1 -
>  fs/vboxsf/file.c       |  1 -
>  include/linux/fs.h     |  1 -
>  13 files changed, 34 deletions(-)
> 
> diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
> index af7f72abbb76aaff934b80d4002f32e3b0d17b6d..e0d34e4e9076e3b1a6c5ed07a3e009a50c9fa2a9 100644
> --- a/fs/9p/vfs_dir.c
> +++ b/fs/9p/vfs_dir.c
> @@ -242,7 +242,6 @@ const struct file_operations v9fs_dir_operations = {
>  	.iterate_shared = v9fs_dir_readdir,
>  	.open = v9fs_file_open,
>  	.release = v9fs_dir_release,
> -	.setlease = simple_nosetlease,
>  };
>  
>  const struct file_operations v9fs_dir_operations_dotl = {
> @@ -252,5 +251,4 @@ const struct file_operations v9fs_dir_operations_dotl = {
>  	.open = v9fs_file_open,
>  	.release = v9fs_dir_release,
>  	.fsync = v9fs_file_fsync_dotl,
> -	.setlease = simple_nosetlease,
>  };
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index 6f3880208587e39d965dcd4b4280a2079a36b4a2..c5e73c37baea55394294b939fdda7170db8503c0 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -517,7 +517,6 @@ const struct file_operations v9fs_file_operations = {
>  	.splice_read = v9fs_file_splice_read,
>  	.splice_write = iter_file_splice_write,
>  	.fsync = v9fs_file_fsync,
> -	.setlease = simple_nosetlease,
>  };
>  
>  const struct file_operations v9fs_file_operations_dotl = {
> @@ -532,5 +531,4 @@ const struct file_operations v9fs_file_operations_dotl = {
>  	.splice_read = v9fs_file_splice_read,
>  	.splice_write = iter_file_splice_write,
>  	.fsync = v9fs_file_fsync_dotl,
> -	.setlease = simple_nosetlease,
>  };
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 804588524cd570078ba59bf38d2460950ca67daf..86d7aa594ea99335af3e91a95c0a418fdc1b8a8a 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -2214,7 +2214,6 @@ const struct file_operations ceph_dir_fops = {
>  	.fsync = ceph_fsync,
>  	.lock = ceph_lock,
>  	.flock = ceph_flock,
> -	.setlease = simple_nosetlease,
>  };
>  
>  const struct file_operations ceph_snapdir_fops = {
> @@ -2222,7 +2221,6 @@ const struct file_operations ceph_snapdir_fops = {
>  	.llseek = ceph_dir_llseek,
>  	.open = ceph_open,
>  	.release = ceph_release,
> -	.setlease = simple_nosetlease,
>  };
>  
>  const struct inode_operations ceph_dir_iops = {
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 983390069f737254e8c7bcad1718f375499f443e..31b691b2aea21f04c6d6c9aacbfd664c13a3ef64 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -3169,7 +3169,6 @@ const struct file_operations ceph_file_fops = {
>  	.mmap_prepare = ceph_mmap_prepare,
>  	.fsync = ceph_fsync,
>  	.lock = ceph_lock,
> -	.setlease = simple_nosetlease,
>  	.flock = ceph_flock,
>  	.splice_read = ceph_splice_read,
>  	.splice_write = iter_file_splice_write,
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 4b6b3d2758ff225dc389016017753b09fadff9d1..d6ee2d38fc2dad5c0995b62dd589e7a46d18424d 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -2421,7 +2421,6 @@ static const struct file_operations fuse_dir_operations = {
>  	.fsync		= fuse_dir_fsync,
>  	.unlocked_ioctl	= fuse_dir_ioctl,
>  	.compat_ioctl	= fuse_dir_compat_ioctl,
> -	.setlease	= simple_nosetlease,
>  };
>  
>  static const struct inode_operations fuse_common_inode_operations = {
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index 6daa96d815e1e30f099938543a0ed19aa90c720c..3e061e8115ece08c7cb6594b8adb653ccec998ed 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -1593,7 +1593,6 @@ const struct file_operations gfs2_file_fops = {
>  	.flock		= gfs2_flock,
>  	.splice_read	= copy_splice_read,
>  	.splice_write	= gfs2_file_splice_write,
> -	.setlease	= simple_nosetlease,
>  	.fallocate	= gfs2_fallocate,
>  	.fop_flags	= FOP_ASYNC_LOCK,
>  };
> @@ -1608,7 +1607,6 @@ const struct file_operations gfs2_dir_fops = {
>  	.lock		= gfs2_lock,
>  	.flock		= gfs2_flock,
>  	.llseek		= default_llseek,
> -	.setlease	= simple_nosetlease,
>  	.fop_flags	= FOP_ASYNC_LOCK,
>  };
>  
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 697c6d5fc12786c036f0086886297fb5cd52ae00..f1860dff86f2703266beecf31e9d2667af7a9684 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -1699,24 +1699,6 @@ struct inode *alloc_anon_inode(struct super_block *s)
>  }
>  EXPORT_SYMBOL(alloc_anon_inode);
>  
> -/**
> - * simple_nosetlease - generic helper for prohibiting leases
> - * @filp: file pointer
> - * @arg: type of lease to obtain
> - * @flp: new lease supplied for insertion
> - * @priv: private data for lm_setup operation
> - *
> - * Generic helper for filesystems that do not wish to allow leases to be set.
> - * All arguments are ignored and it just returns -EINVAL.
> - */
> -int
> -simple_nosetlease(struct file *filp, int arg, struct file_lease **flp,
> -		  void **priv)
> -{
> -	return -EINVAL;
> -}
> -EXPORT_SYMBOL(simple_nosetlease);
> -
>  /**
>   * simple_get_link - generic helper to get the target of "fast" symlinks
>   * @dentry: not used here
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 71df279febf797880ded19e45528c3df4cea2dde..23a78a742b619dea8b76ddf28f4f59a1c8a015e2 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -66,7 +66,6 @@ const struct file_operations nfs_dir_operations = {
>  	.open		= nfs_opendir,
>  	.release	= nfs_closedir,
>  	.fsync		= nfs_fsync_dir,
> -	.setlease	= simple_nosetlease,
>  };
>  
>  const struct address_space_operations nfs_dir_aops = {
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index d020aab40c64ebda30d130b6acee1b9194621457..9d269561961825f88529551b0f0287920960ac62 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -962,7 +962,6 @@ const struct file_operations nfs_file_operations = {
>  	.splice_read	= nfs_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.check_flags	= nfs_check_flags,
> -	.setlease	= simple_nosetlease,
>  	.fop_flags	= FOP_DONTCACHE,
>  };
>  EXPORT_SYMBOL_GPL(nfs_file_operations);
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index a3dc7cb1ab541d35c2e43eefb7a2d2d23ad88bb3..8015df1f711e150a0afb44875899435303d9d406 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -1709,7 +1709,6 @@ const struct file_operations cifs_dir_ops = {
>  	.remap_file_range = cifs_remap_file_range,
>  	.llseek = generic_file_llseek,
>  	.fsync = cifs_dir_fsync,
> -	.setlease = simple_nosetlease,
>  };
>  
>  static void
> diff --git a/fs/vboxsf/dir.c b/fs/vboxsf/dir.c
> index 230d7589d15cc98f6bc7e930ba40ca5f7dbf7e18..42bedc4ec7af7709c564a7174805d185ce86f854 100644
> --- a/fs/vboxsf/dir.c
> +++ b/fs/vboxsf/dir.c
> @@ -186,7 +186,6 @@ const struct file_operations vboxsf_dir_fops = {
>  	.release = vboxsf_dir_release,
>  	.read = generic_read_dir,
>  	.llseek = generic_file_llseek,
> -	.setlease = simple_nosetlease,
>  };
>  
>  /*
> diff --git a/fs/vboxsf/file.c b/fs/vboxsf/file.c
> index 4bebd947314a796365728b3af1c46b0d7070abc1..111752010edb2ba48ee1fdf0e3729369c6521ee8 100644
> --- a/fs/vboxsf/file.c
> +++ b/fs/vboxsf/file.c
> @@ -218,7 +218,6 @@ const struct file_operations vboxsf_reg_fops = {
>  	.release = vboxsf_file_release,
>  	.fsync = noop_fsync,
>  	.splice_read = filemap_splice_read,
> -	.setlease = simple_nosetlease,
>  };
>  
>  const struct inode_operations vboxsf_reg_iops = {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f5c9cf28c4dcf9ec648f0fc4f3f4bb44d1b1c482..e46e8aad9339357f99c40eede8ca7b6b727284fe 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3217,7 +3217,6 @@ extern int always_delete_dentry(const struct dentry *);
>  extern struct inode *alloc_anon_inode(struct super_block *);
>  struct inode *anon_inode_make_secure_inode(struct super_block *sb, const char *name,
>  					   const struct inode *context_inode);
> -extern int simple_nosetlease(struct file *, int, struct file_lease **, void **);
>  
>  extern struct dentry *simple_lookup(struct inode *, struct dentry *, unsigned int flags);
>  extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

