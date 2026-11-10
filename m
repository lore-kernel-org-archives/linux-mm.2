Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50432606BFF5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F08F6B05C5; Tue, 10 Nov 2026 07:56:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7986B05C6; Tue, 10 Nov 2026 07:56:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605D06B05C7; Tue, 10 Nov 2026 07:56:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA016B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:56:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D79A51A05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:56:11 +0000 (UTC)
X-FDA: 85419207342.18.A931FA8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id E4CBBC0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:56:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315370;
	b=BIfOGI+0VqHtfm2ONUDbN2Q3XHm2AF8NFMSmVepQSxXGZiDimcO4t9h9RrvBxCdYY1yeKl
	Yml5+7XwC5QQc1EjoceaGvkzLhHr6945H36fXHZIDNi4GXu2501kzL+9rdNj3pTRUUkFYA
	s6DXMaIXxsZA6F950XnlWDxq0cKm0tc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QUEL7ami9tBt93YnGorfmeiZG+8AFflik0IQpbpHjtQ=;
	b=5807uC5G7IV7Gba/v3YNW/foGCuIi32ps5x8aPIiURGz+o6S9MGabnAiv/JtGLIMObXC9T
	/4nVs9/G8onwiWK2RC77dFYwdlSHdyAJzTq9yOJHdxE+kuVZlwrsWqJxECsu6bfA5vMETl
	M1WfqosWuti7VXhJ3Hg3HcgWi+f8lQE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DB0C521ECA;
	Tue, 10 Nov 2026 12:56:08 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE1661339F;
	Tue, 10 Nov 2026 12:56:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o3haImgU82qJQwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:56:08 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 53F33224E5; Tue, 10 Nov 2026 13:56:08 +0100 (CET)
Date: Tue, 10 Nov 2026 13:56:08 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 05/41] kernfs: use fc_init_pseudo()
Message-ID: <bktltatbokowanmaf2kqhfcjg47gok7lbk4bs2mjsbwu33tvbe@gxd5dq25slfp>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-5-4c998976c6c7@kernel.org>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E4CBBC0003
X-Rspamd-Server: rspam12
X-Stat-Signature: iocmrqwcs9tuj3eaa7nn6ee749pr749k
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794315369-884810
X-HE-Meta: U2FsdGVkX1+0/HyFotUcgWcGB9nkUasNEDZ8rmNG8hyr+JrRIiELzCGW0QIAVG2BboJKmeDryLGagDJGf8WgznuQsBjUobpgr7e16WaRXUZfSObXdO6KjQWAulD2rS3AzC2nfhu/j3RsTCW9kb6lYEoszChdxJQcZuUr8lViu7qDbH/KwYz8PUCSN4qXAIsoblp0R8o2yIiENvf8VCHfOSVyThpokSJradZtNpFQkw67aNhXyKwM9/nNZImCgEA3+aOp5PdC0Pmn7w+GAhoPMnE90nb6Ta9v7/CysAtlD7AfKCAnvLWS/ii2y3Yt/Le6dNJRnDH1fyW2fQamuKWZ31pd8ar5YUPvW8AqrnBpV3IpAVgRTq8xerz3+gblLzMFhV3NgrwMsLCcBLVcRWyAfrxslv4NvZCTqSoQMHiAv8V+21S3Pac6go1zyVox/GcWJ9pvocefGh3O9BKm+0YF7uAvjw8jWLHFn9KdBD3xSqYPpyEL8ugBWx3bG3iq2NrjdS5t1Lyp2zOeCKFdwARW7TK4I439R0Fe7f9otyXt6ETIq0yTAzR+jJMEE4E7yPRuPpDSsKuIz8kSq4Gu0p9zU/yn9GKkdpgOMWZBfbvCXGheuOskbUTsolhcdp0vUzUb7n/3KxhTnkDtxkWgAcbosFPZdSAfmFsY0Ab/8HCLHHZPtnU5RaW4WLRLJ+M3csWZPG9qrNAYgQRCckZ0ORguNnrlX6k6EB/+NubM8L0cVbJJKVVgUz2p04QkIZG/QdxD0QrKTAH28RVWJgGEBFbUuKZLDD9xVR01tbV3ZDRJ/ADl9rwaKhh3L1bFM0uonmksUtkW3JMrLnE7IR5Nv5CK4C7XicWhLoEhfdZneXcu6b+uFMX3RRQ4MbikDYNwrt2tccMdGpPPEDxk0aZDZTEH4sfjY6p9Py9gP0vXbp0cySZtSU6/xnU7e9qeaYZ302pGTdYEKbEL2NV9VwJfIbP
 v7wNWFJF
 JNJqao5Ci7ocq2IeyU60to0UpejjH7FARHFnWIFg3q90+Ohb/+j8FiIq4AqHg/GgdH25TOPny3gEpIqXIxfOz5ziq73j/Ty6HhMVJQ5Y+Gv+86ON4GIcjnuSei0lABtgXDUZk8YkYdrmKmjxtCc+eZ+gfUd1X7zufgnwm+Kwf0si8BGaKgzwQOpELNMCtfGBZ9kvNcw9FE7K69vv5GxycpKL9oPF85yo7Mbd3AlTPVKNtPRcyC5RNIq6syRwpvohCC0QN3WbaPBUIeNUumtKk/xuCwG3VcJ72s3waD9txOFvrivbXbkwq+hbvoCUbUV5XpgCFVG6A6XajW5oLXz7weBj+vWpe0OumCHm3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:21, Christian Brauner wrote:
> Initialize all kernfs based filesystems as pseudo filesystems in
> kernfs_get_tree() instead of raising SB_I_NOEXEC and SB_I_NODEV by hand
> in kernfs_fill_super(). This adds SB_I_PSEUDO for sysfs, cgroupfs and
> resctrl.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/kernfs/mount.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index a0be784bfb06..6b60d212b003 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <linux/fs.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/mount.h>
>  #include <linux/init.h>
>  #include <linux/magic.h>
> @@ -298,8 +299,6 @@ static int kernfs_fill_super(struct super_block *sb, struct kernfs_fs_context *k
>  	struct dentry *root;
>  
>  	info->sb = sb;
> -	/* Userspace would break if executables or devices appear on sysfs */
> -	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
>  	sb->s_blocksize = PAGE_SIZE;
>  	sb->s_blocksize_bits = PAGE_SHIFT;
>  	sb->s_magic = kfc->magic;
> @@ -388,6 +387,7 @@ int kernfs_get_tree(struct fs_context *fc)
>  	info->ns = kfc->ns_tag;
>  	INIT_LIST_HEAD(&info->node);
>  
> +	fc_init_pseudo(fc);
>  	fc->s_fs_info = info;
>  	sb = sget_fc(fc, kernfs_test_super, kernfs_set_super);
>  	if (IS_ERR(sb))
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

